Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE005CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F409A8E0006; Wed, 27 Aug 2025 11:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2938E0002; Wed, 27 Aug 2025 11:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0C28E0006; Wed, 27 Aug 2025 11:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C86FB8E0002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:59:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A8EE1A06D7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:59:58 +0000 (UTC)
X-FDA: 83822998476.12.ED66462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 70AFD1C0003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:59:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V/nKrlgt";
	spf=pass (imf18.hostedemail.com: domain of lossin@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lossin@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756310396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wzdd3Cp0PH3DKyUoHz7xTKaylFp/fJX0UW6AKzG3Zd4=;
	b=qhEfTscXNsR8f9p3HRp/XTywe+YJb94RDzEbuSaksmmsC000yxaE4mdp/lKjFme7la1K1o
	7zjQQ0Mi7QxtLvDCUuATiTczJ5G8bbODoTbI967deOQrY3feTuq6vgMhjWf/ZtrKAzZzP0
	oO4gBUm2OJ9oOKkUxXu6Y8yixS0by1A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V/nKrlgt";
	spf=pass (imf18.hostedemail.com: domain of lossin@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lossin@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756310396; a=rsa-sha256;
	cv=none;
	b=azp5LgKOzrrkR2z3MJBk3/bGryrxeAU1QfzQi6e2JEP1lA9adVuWrMrd5EWPi3jPlQknGN
	2DORp63Bux4xxpxR917ujGrOvfcgTnwr+Yj5MfW+t1cHlTYhDMxvYagwS6+M0yrNoB0ymJ
	UGHoDKQc/jW97OP9bqlBg41KYv7TNdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 355D544B6F;
	Wed, 27 Aug 2025 15:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74664C4CEF0;
	Wed, 27 Aug 2025 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756310395;
	bh=J5+h5UrziIldL/6ShiAr1mBz3pMe+bEDgeuau7q6E0s=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=V/nKrlgtdnqj1+XgGOuPsNiHcsH6n/RYGVSCh0CsufP7uQ5rxG7hZ3xRlonzuzx8v
	 Jr/UF2Lckz6aO+anmWy5Mo6vEN5SyJf8xRF4FNLdFTKef/3ClapU8Q/n1DO/1E4jEC
	 rO44R+cuU2A9o2Co9egJnAjUjrUNA8unH1v/ccjhvzvBGV57YewafNjg2juzwxodGj
	 +HNMaUulAd6UPsOqvJh62js65XsTrLD/MQw4AFGdD6JjcpwCSF+eTmipNWaFyiUX6H
	 LbX9FDQlyKiXNraafiWq4IWQIqJItXP4viGa99FIeCd8nNV0O6YScYKVnm3OLgIDuf
	 xqvYjxL/ZyYAg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 27 Aug 2025 17:59:49 +0200
Message-Id: <DCDC2M7N28X2.3Q8XYNEDOGK6A@kernel.org>
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
In-Reply-To: <DFA3B588-3650-42DA-8875-7AB7D20A2BCA@konsulko.se>
X-Rspamd-Queue-Id: 70AFD1C0003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e47ba3y6ormqrerxi95iigweo787axrt
X-HE-Tag: 1756310396-718440
X-HE-Meta: U2FsdGVkX1+m98CT42fcx6AMeWNlrnANOzsy8t9NLRLv43isIlM9PbhyuHZnBV4yyaMwluiq1txVv2hrWs/H8vUcdG7JhuKTQk9Uo8lV3n2qBiKu8JGjXPMScvlnf6h1lDilFoaQgkk96Y6TT4zOSFacZjevPI5patWFdAgkchsBIAlLv1eiZKGWapHOgb6Fp7c7XiEwt3d+sZt5EUfLRWgnjknzUiZfE8oWU170PUZIGXa0jTtUUYUkiLa4wZfjlPfj9gG5B7ExlBlN1WMibuiXcxnISFvXSmqpX1YbCq6NJET/4/1TkPoEK2pCr079/lTqj1aPtrb8Iouous+7HPKDIWyhuDxeJqM44WKNrnklthekYvfidMHm+LfuJNPlnJcwDjFdPro0e1+HSTi1tQegJWhCd1/81XEiywX2uglZaRrMwSLin7aitJs2ynTlSH3yIDj0iIJitxVFHqsDCpMo+zXLl7ttyBX5/zwyafiBp25kqhpbrIofzITVOp93+JNDDR84Z4jp+OohhY0U57hSQsCvYZgneVUuwhH8IuLQe91Iygjl2PAUGkSFaY8kA8UP2pTVg5gR6B2sBG9hlLg+f82fhNy1GOl1SgDQ30DpGaquTFO5dwh7aCdQ24Cd94R5wEvslw9DtKAl2fZH16+erPIZ+HzBDRuZJFwp+nrb/1Cc956Fw468PHSP5lu69VCfkcJUdfu1IG6vot8ZFOS7k7mMu6YUOxU7dIL0MuCGFCp1djldqMwFKa7gI8MGTe76aWpdAo3jDkJG4V4lWL39dWruJKhGkZKW8eHOkrbxutu7XkugKAx94pyoTl32wTEeiRZ6DypwlABVaUPPq6a2WTn8G3oqTsFWVlCbKMg4eh36ZKqaP8IHnMC6OV8tyNz3iljetjQtZGO54obNS6MyBUBCo3IarU5OOHrUSD/vtKBGWntBWSzXT7u7oOjv8E9EX7+QPmqLhr19ur4
 8inCOvjQ
 gvFWV243foho862ZGgBKkAyyYUDJ3L1hU/XME7GRqaEN8z2t9rZefCIGqqunPladQCl+T6wR1AiRLXWuX6IzbWtfo+RceXfLh6FBXELxmR60/3lqP3oVd0fWsj+7OIQliUizgPzTMrTrrMOcTcYa9jJYcblV9drDdYaxSJ59oi8R0f0azKnUAfqe72x6wpxRxGq2jUyphTkNTPQ4TWAfD5r4Zfcn1nm2zNw8CX8EiBqES1rrQHtAokuz4q3wb9P1IAsuaKYQnN3nRJ2Cw84HJXv5nX5GlmqWvgP9SYsBADL6qJyotznECu7FhYQip8TCtFsOGvVvIsYQoqY7FJW4x6f0BnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 27, 2025 at 4:24 PM CEST, Vitaly Wool wrote:
>
>
>> On Aug 26, 2025, at 7:02 PM, Benno Lossin <lossin@kernel.org> wrote:
>>=20
>> On Sat Aug 23, 2025 at 3:05 PM CEST, Vitaly Wool wrote:
>>> +pub trait ZpoolDriver {
>>> +    /// Opaque Rust representation of `struct zpool`.
>>> +    type Pool: ForeignOwnable;
>>=20
>> I think this is the same question that Danilo asked a few versions ago,
>> but why do we need this? Why can't we just use `Self` instead?
>
> It=E2=80=99s convenient to use it in the backend implementation, like in =
the toy example supplied in the documentation part:
>
> +/// struct MyZpool {
> +///     name: &'static CStr,
> +///     bytes_used: AtomicU64,
> +/// }
> =E2=80=A6
> +/// impl ZpoolDriver for MyZpoolDriver {
> +///     type Pool =3D KBox<MyZpool>;
>
> Does that make sense?

No, why can't it just be like this:

    struct MyZpool {
        name: &'static CStr,
        bytes_used: AtomicU64,
    }
   =20
    struct MyZpoolDriver;
   =20
    impl ZpoolDriver for MyZpoolDriver {
        type Error =3D Infallible;
   =20
        fn create(name: &'static CStr) -> impl PinInit<Self, Self::Error> {
            MyZpool { name, bytes_used: AtomicU64::new(0) }
        }
   =20
        fn malloc(&mut self, size: usize, gfp: Flags, _nid: NumaNode) -> Re=
sult<usize> {
            let mut pow: usize =3D 0;
            for n in 6..=3DPAGE_SHIFT {
                if size <=3D 1 << n {
                    pow =3D n;
                    break;
                }
            }
            match pow {
                0 =3D> Err(EINVAL),
                _ =3D> {
                    let vec =3D KVec::<u64>::with_capacity(1 << (pow - 3), =
gfp)?;
                    let (ptr, _len, _cap) =3D vec.into_raw_parts();
                    self.bytes_used.fetch_add(1 << pow, Ordering::Relaxed);
                    Ok(ptr as usize | (pow - 6))
                }
            }
        }
   =20
        unsafe fn free(&self, handle: usize) {
            let n =3D (handle & 0x3F) + 3;
            let uptr =3D handle & !0x3F;
   =20
            // SAFETY:
            // - uptr comes from handle which points to the KVec allocation=
 from `alloc`.
            // - size =3D=3D capacity and is coming from the first 6 bits o=
f handle.
            let vec =3D unsafe { KVec::<u64>::from_raw_parts(uptr as *mut u=
64, 1 << n, 1 << n) };
            drop(vec);
            self.bytes_used.fetch_sub(1 << (n + 3), Ordering::Relaxed);
        }
   =20
        unsafe fn read_begin(&self, handle: usize) -> NonNull<u8> {
            let uptr =3D handle & !0x3F;
            // SAFETY: uptr points to a memory area allocated by KVec
            unsafe { NonNull::new_unchecked(uptr as *mut u8) }
        }
   =20
        unsafe fn read_end(&self, _handle: usize, _handle_mem: NonNull<u8>)=
 {}
   =20
        unsafe fn write(&self, handle: usize, handle_mem: NonNull<u8>, mem_=
len: usize) {
            let uptr =3D handle & !0x3F;
            // SAFETY: handle_mem is a valid non-null pointer provided by z=
pool, uptr points to
            // a KVec allocated in `malloc` and is therefore also valid.
            unsafe {
                copy_nonoverlapping(handle_mem.as_ptr().cast(), uptr as *mu=
t c_void, mem_len)
            };
        }
   =20
        fn total_pages(&self) -> u64 {
            self.bytes_used.load(Ordering::Relaxed) >> PAGE_SHIFT
        }
    }

Also using a `usize` as a handle seems like a bad idea. Use a newtype
wrapper of usize instead. You can also not implement `Copy` and thus get
rid of one of the safety requirements of the `free` function. Not sure
if we can remove the other one as well using more type system magic, but
we could try.


>>> +
>>> +    /// Create a pool.
>>> +    fn create(name: &'static CStr, gfp: Flags) -> Result<Self::Pool>;
>>> +
>>> +    /// Destroy the pool.
>>> +    fn destroy(pool: Self::Pool);
>>=20
>> This should just be done via the normal `Drop` trait?
>
> Let me check if I=E2=80=99m getting you right here. I take what you are s=
uggesting is that we require that Pool implements Drop trait and then just =
do something like:
>
>     extern "C" fn destroy_(pool: *mut c_void) {
>         // SAFETY: The pointer originates from an `into_foreign` call.
>         unsafe { drop(T::Pool::from_foreign(pool)) }
>     }
>
> Is that understanding correct?

Yes, but you don't need to require the type to implement drop.

---
Cheers,
Benno

