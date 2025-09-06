Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909B5CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 07:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B9B8E0003; Sat,  6 Sep 2025 03:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602C38E0001; Sat,  6 Sep 2025 03:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F8C8E0003; Sat,  6 Sep 2025 03:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4201A8E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:56:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D241A85CB3
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:56:34 +0000 (UTC)
X-FDA: 83858068308.25.F61D56D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0D4EA140005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:56:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JDPgr7UR;
	spf=pass (imf26.hostedemail.com: domain of lossin@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lossin@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757145393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxlpDa4GqZ4XRVsLXFjUQ1YImqTwGPMi438uU6ntMko=;
	b=cG3LKjpGbH/M5Imwa7VIdF3NnmTf710v/C5b5SIRLU8mSdG8b6dMQ9vhQe/Jtl0O7i7eqW
	JsdqgqEJLAaCi+6hHiuKMg7HlGVRkpn45jixMGvXN1LgAhuyJ7c2w6vEnWgfmCQqxPtLUC
	1FpzpihUkzYGxUQ0p+WFfPgBk445+rA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757145393; a=rsa-sha256;
	cv=none;
	b=NX0M+Qsk0IbLrwX9bqRhGz4d7aW7jIHKXrqEjLMiOgrf0JqSxzBUQKgyaoNalyn2OOIneC
	fhoQHcquTgBwf5gYqKYMhNemAPUfyzgUYtIQu0KQi8uLaBRJmuGG3OMjtJMrqpMcMOyRbg
	a33bMdePQ+oFmT355A7MsZ61zCQnk/k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JDPgr7UR;
	spf=pass (imf26.hostedemail.com: domain of lossin@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lossin@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8930B44946;
	Sat,  6 Sep 2025 07:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1806C4CEE7;
	Sat,  6 Sep 2025 07:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757145391;
	bh=6MpzkwaTQMjmEYFnZViHjiIwAE3okFT2YcFGwEWrMu0=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=JDPgr7URW8s7vw/k79cIlH8pPnGb6W1TRtu+NcgwNT+haAornpO/O5/b02eZY3tOw
	 vvzGi9grirM0MP4Oky1dwoVR4tRHa9eQDEUCTyinM4bPPHCwxcB+oGtX8brxFP4K0N
	 66cSVv1nOkSKtaW9mhxLnbkcWLyAVz0nkRXTmMY9+kaKmBxQjiRZOFdY7H5VNBURWz
	 xgD39ulj6KwxWdYWKrfNm63CPXIjTJLFNOwmKgaLwFreHeLB1wbzERLMRGH6HORPgT
	 MDZf/Yd+PsjNIB5vOkiWjf8fhc5o9GtXk5RcK9sxaHH+HPpsThbDaY6v41hpYnKIrl
	 6pWiNQqdJv05A==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Sep 2025 09:56:25 +0200
Message-Id: <DCLK1YG1L5TZ.1VMGX131LII9V@kernel.org>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>
Cc: "rust-for-linux" <rust-for-linux@vger.kernel.org>, "LKML"
 <linux-kernel@vger.kernel.org>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Danilo Krummrich" <dakr@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>, "Bjorn
 Roy Baron" <bjorn3_gh@protonmail.com>, "Andreas Hindborg"
 <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed" <yosry.ahmed@linux.dev>, "Nhat
 Pham" <nphamcs@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH v4 2/2] rust: zpool: add abstraction for zpool drivers
From: "Benno Lossin" <lossin@kernel.org>
X-Mailer: aerc 0.20.1
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250823130522.867263-1-vitaly.wool@konsulko.se>
 <DCCIRTHGQFNX.1M8GXO4TYA7DF@kernel.org>
 <DFA3B588-3650-42DA-8875-7AB7D20A2BCA@konsulko.se>
 <DCDC2M7N28X2.3Q8XYNEDOGK6A@kernel.org>
 <9c63dda1-0a4b-4131-a5e7-12ad2e88c6d6@konsulko.se>
In-Reply-To: <9c63dda1-0a4b-4131-a5e7-12ad2e88c6d6@konsulko.se>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D4EA140005
X-Stat-Signature: cte4exrbtakfkniu49cgjau6t3833kif
X-Rspam-User: 
X-HE-Tag: 1757145392-912498
X-HE-Meta: U2FsdGVkX1+ET4e+DURkcrc47nIoeyaTAPH/lSdBQ+/a3KRpt4e5bZVshFtx+w4ObfzUXxTB9Nyzw+WVyrQgg+QWGGLl7Oe0E/z9GQN1rO566/DFQB1NjENWvbnfKU8jGi8I5GAgu1/JxXGgBc4hyqrcsusMtDvgRA0HEOB6xmHzyN1dFXNGjTCbyzvL7Lb7qH3ONTKgt5Sn0yYPo2vE9EBdHRAFB4YTZQCbLI5fLWlOBVMlv23tsOfIeMYiAo4KzS5oE056ZzdrF1wjp+rbofFMbM9ow3gtB/kxJuPnnfKYpGvi+KCXA8WOMB3kpyWfyiyDNPekBaSiEXy/uUvtBvWFt37ofGfxDD2jfNtKaFZT4fhkPlF2VetxrafQfqKrlmtMELWM3uRHqyoeQbn7936alySXpXOnP7IjlHrsWl4kpXL6N9COwZFLhZeS9qKRuw9nSmIWKexsZ7BoQHhZG7gCrvPtTZM56FaAhT5yCPmvRK0XYA9lNsiMndT7jKL7WhnzLkHrs8TtY6aoAZCjdUVqJGsHAD9D1Qym9jbzWqInGq2pDzDpWbEcnapQnDCewWLx2aDSg85fi+md+GhNNErY7yU+/bwZnLYtwUV3biLtX1Tot0yJAilL3r3GFvHyRwW3KJcAGSd9kzSexs/Pv8gAbh7FYYdu9+FhZnJteXEFCjpxcHmpS/diZ3B/vSEJoGOsuEB4HXk8bGVoqGCuW6716hXkjpZAFmbadwbDLpPKofj9v9RE52FuamJVmqP4w4HAeNH6JCNsr4vxukbdaBk53pHvC8y8R/l95yLZSuBDg2oXWlie1+qwfATRPG0vAYTqBH2Ybdfwut8qWIDcVilZ+by4v9QWUjlKwRh9PdbkrtBIrMsi+4v/cRqpszY1JBBXw8fKXkXriM6DO2MY75mTzAl6NPkCIgNFmKhrG7LHSYEn75ldUZjSspirWro3u7JTZG7F8et3tLOGbWL
 746NPvRS
 udDPxhA6kFcjSnTBLW0d23R4OdNshqmcpiWIJ3NJ2f9UI8JsHZ44ay3147z0WDug2cYdrlFVPJpdBw+qWmssj2WP7Nl87knADC1l7E3ElqOlcU40+cHAPdh8ZDECKBcVXm8W6TibetsNHUF5UKWbxqD8Nwi/442DmmFAms68mhHa/yi69uy0632VVsIdc+z/Jh/kWR0FeeIV7puVUVMb9Du1/2ht9kX2k9kJwXSHuxxSfsR4y9GtDsScxal81zpD6EBdH5H2Od1+FqVxL0ptXynySeG0zHGO/yVk1xfUT7G9QxIoB0Flf/JbgyJaI+ozX5daQtLSazutmbfTjTNhdYvb0IQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 28, 2025 at 9:22 AM CEST, Vitaly Wool wrote:
>
>
> On 8/27/25 17:59, Benno Lossin wrote:
>> On Wed Aug 27, 2025 at 4:24 PM CEST, Vitaly Wool wrote:
>>>
>>>
>>>> On Aug 26, 2025, at 7:02 PM, Benno Lossin <lossin@kernel.org> wrote:
>>>>
>>>> On Sat Aug 23, 2025 at 3:05 PM CEST, Vitaly Wool wrote:
>>>>> +pub trait ZpoolDriver {
>>>>> +    /// Opaque Rust representation of `struct zpool`.
>>>>> +    type Pool: ForeignOwnable;
>>>>
>>>> I think this is the same question that Danilo asked a few versions ago=
,
>>>> but why do we need this? Why can't we just use `Self` instead?
>>>
>>> It=E2=80=99s convenient to use it in the backend implementation, like i=
n the toy example supplied in the documentation part:
>>>
>>> +/// struct MyZpool {
>>> +///     name: &'static CStr,
>>> +///     bytes_used: AtomicU64,
>>> +/// }
>>> =E2=80=A6
>>> +/// impl ZpoolDriver for MyZpoolDriver {
>>> +///     type Pool =3D KBox<MyZpool>;
>>>
>>> Does that make sense?
>>=20
>> No, why can't it just be like this:
>>=20
>>      struct MyZpool {
>>          name: &'static CStr,
>>          bytes_used: AtomicU64,
>>      }
>>     =20
>>      struct MyZpoolDriver;
>>     =20
>>      impl ZpoolDriver for MyZpoolDriver {
>>          type Error =3D Infallible;
>>     =20
>>          fn create(name: &'static CStr) -> impl PinInit<Self, Self::Erro=
r> {
>>              MyZpool { name, bytes_used: AtomicU64::new(0) }
>>          }
>>     =20
>>          fn malloc(&mut self, size: usize, gfp: Flags, _nid: NumaNode) -=
> Result<usize> {
>>              let mut pow: usize =3D 0;
>>              for n in 6..=3DPAGE_SHIFT {
>>                  if size <=3D 1 << n {
>>                      pow =3D n;
>>                      break;
>>                  }
>>              }
>>              match pow {
>>                  0 =3D> Err(EINVAL),
>>                  _ =3D> {
>>                      let vec =3D KVec::<u64>::with_capacity(1 << (pow - =
3), gfp)?;
>>                      let (ptr, _len, _cap) =3D vec.into_raw_parts();
>>                      self.bytes_used.fetch_add(1 << pow, Ordering::Relax=
ed);
>>                      Ok(ptr as usize | (pow - 6))
>>                  }
>>              }
>>          }
>>     =20
>>          unsafe fn free(&self, handle: usize) {
>>              let n =3D (handle & 0x3F) + 3;
>>              let uptr =3D handle & !0x3F;
>>     =20
>>              // SAFETY:
>>              // - uptr comes from handle which points to the KVec alloca=
tion from `alloc`.
>>              // - size =3D=3D capacity and is coming from the first 6 bi=
ts of handle.
>>              let vec =3D unsafe { KVec::<u64>::from_raw_parts(uptr as *m=
ut u64, 1 << n, 1 << n) };
>>              drop(vec);
>>              self.bytes_used.fetch_sub(1 << (n + 3), Ordering::Relaxed);
>>          }
>>     =20
>>          unsafe fn read_begin(&self, handle: usize) -> NonNull<u8> {
>>              let uptr =3D handle & !0x3F;
>>              // SAFETY: uptr points to a memory area allocated by KVec
>>              unsafe { NonNull::new_unchecked(uptr as *mut u8) }
>>          }
>>     =20
>>          unsafe fn read_end(&self, _handle: usize, _handle_mem: NonNull<=
u8>) {}
>>     =20
>>          unsafe fn write(&self, handle: usize, handle_mem: NonNull<u8>, =
mem_len: usize) {
>>              let uptr =3D handle & !0x3F;
>>              // SAFETY: handle_mem is a valid non-null pointer provided =
by zpool, uptr points to
>>              // a KVec allocated in `malloc` and is therefore also valid=
.
>>              unsafe {
>>                  copy_nonoverlapping(handle_mem.as_ptr().cast(), uptr as=
 *mut c_void, mem_len)
>>              };
>>          }
>>     =20
>>          fn total_pages(&self) -> u64 {
>>              self.bytes_used.load(Ordering::Relaxed) >> PAGE_SHIFT
>>          }
>>      }
>
> It can indeed but then the ZpoolDriver trait will have to be extended=20
> with functions like into_raw() and from_raw(), because zpool expects=20
> *mut c_void, so on the Adapter side it will look like
>
>      extern "C" fn create_(name: *const c_uchar, gfp: u32) -> *mut c_void=
 {
>          // SAFETY: the memory pointed to by name is guaranteed by zpool=
=20
> to be a valid string
>          let pool =3D unsafe { T::create(CStr::from_char_ptr(name),=20
> Flags::from_raw(gfp)) };
>          match pool {
>              Err(_) =3D> null_mut(),
>              Ok(p) =3D> T::into_raw(p).cast(),
>          }
>      }
>
> The question is, why does this make it better?

No, thanks for sharing that function. Then the question becomes, do you
really need `ForeignOwnable`? Or is `KBox` enough? Do you really want
people to use `Arc<MyZPool>`? Because `BorrowedMut` of `Arc` is the same
as it's `Borrowed` variant (it's read-only after all).

If you can get away with just `Box` (you might want people to choose
their allocator, which is fine IMO), then I'd do so.

---
Cheers,
Benno

