Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC8B5CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BEA88E0007; Thu, 28 Aug 2025 03:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2928A8E0001; Thu, 28 Aug 2025 03:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8C28E0007; Thu, 28 Aug 2025 03:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0855F8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:22:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 865CA13A4EA
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:22:08 +0000 (UTC)
X-FDA: 83825322336.09.58E67FC
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id 02A4C1C0005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:22:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b="TcbUNeG/";
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=lPJ11e5h
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756365726; a=rsa-sha256;
	cv=none;
	b=r9YBO7X+wukEKw8LrzqrdIaguxmNjQqyUU9vY+4dQajqh2+Fpqgw/O9sFUHkii5tIqWpVj
	BLGM5ZYAC7KQSE6K194wV+ClSr5KzKsiiftRxXqGWzH6u6d3ZhApZp3tev2+5d2igTsU9S
	/+Ft0TcdCpE5lXMVuY8PZQ0MxvOmJLw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b="TcbUNeG/";
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=lPJ11e5h;
	spf=none (imf20.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756365726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YfXwIt8uRuB24ocvEdwemGPCWUZNGhB6pqOxsa3SJ0=;
	b=M1f8+kzSOSHmPOIIAd7zL/njDOvwt2mrAJ+NfNrw9V5GzLGomEGlrBYQpREWxrW/z59EZt
	PcOrA3YZ1nLncv8LaR5YqhXyInSyHAQYceSQn374dRUrDQMAjvm4BSfhr+UEBxqDX9I8KE
	7ieOKugQpS2ZulWTHHqCUUyk6lJJCQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756365723; x=1756970523;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=2YfXwIt8uRuB24ocvEdwemGPCWUZNGhB6pqOxsa3SJ0=;
	b=TcbUNeG/Qd6OqSN287cQTmdl55p7z84ZIkeCBkDU3GIILprGfzuQ7Ik4bXeFOv5u5dMucEA1leH/j
	 u6cMu3yYFuMD3hFGcoBfWcAhlbyuEhYQ0cqzPQaCFNjQ63UC8RCPmIE50Ghz1kJL8CkHrCpeSGyKaQ
	 rEhzod0zsmBxDSfysQl6qGN4xyjljeiYJ95M4UBdX2D3Wg7h3hjGXEOpFY+jqbMhS/2V5KtflkrWL+
	 G3UQY0+4SJzUMooFb5K18Gfkbwiov48Zm4WP8mCtvkWcqHKKcmEYAn2pnLDNLdu+EVz4ZJh7ZQ30mk
	 lAmWsyPAVc0z5D1GXMGnPyczzYxeZSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756365723; x=1756970523;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=2YfXwIt8uRuB24ocvEdwemGPCWUZNGhB6pqOxsa3SJ0=;
	b=lPJ11e5hy9upngoLEXivO2ahV4GaS+cyXshxFqcORIa094aD9pjodBkqBSAZmjvmhhngAHoeXGbfK
	 FEge1gOAg==
X-HalOne-ID: b09ec1ec-83df-11f0-80cc-f3c0f7fef5ee
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay4.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id b09ec1ec-83df-11f0-80cc-f3c0f7fef5ee;
	Thu, 28 Aug 2025 07:22:02 +0000 (UTC)
Message-ID: <9c63dda1-0a4b-4131-a5e7-12ad2e88c6d6@konsulko.se>
Date: Thu, 28 Aug 2025 09:22:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] rust: zpool: add abstraction for zpool drivers
To: Benno Lossin <lossin@kernel.org>
Cc: rust-for-linux <rust-for-linux@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250823130522.867263-1-vitaly.wool@konsulko.se>
 <DCCIRTHGQFNX.1M8GXO4TYA7DF@kernel.org>
 <DFA3B588-3650-42DA-8875-7AB7D20A2BCA@konsulko.se>
 <DCDC2M7N28X2.3Q8XYNEDOGK6A@kernel.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <DCDC2M7N28X2.3Q8XYNEDOGK6A@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 02A4C1C0005
X-Stat-Signature: 96a9dw4nn94j3u4n8fws6kmx6cammy9y
X-Rspam-User: 
X-HE-Tag: 1756365725-990512
X-HE-Meta: U2FsdGVkX19OOxdCC+pkTn8KXgXkRfgR36VuIzMuM0OswqDuTII0yWUuURBWZSvQaiwCb9P9+6eETSrdGRmb1lhRHWS47yYWfX6McrPdKMJYTwgCMPTnU7CCOZkR/d7nzHZOV6U3lZyYUYkicVVwdCQjJi3bQ2rspCQ66bgKH/uh5t/Cqq74txXkbgF1+sMiDJrt2jW/ncwRkV4SAOeabwIH8JAqu7Z8D4FnoCvx3l9pF6ME7JvapCFRjwPHh+x4oXJpFb4kGc5s3AQcRU0WEGR3OwKUkupC5fqf3UZPASyC3SIS1DxVjJ/EuU2kTwbGn05iq8p6cATGmWHGKR4KFgeRbUKeCK6nzz0Jkfr53wrGhJwuHbdmyET+fC0R3yuMNEs3HEEqlr/mBMtNoaojozux6mXYeWnluoG4bXDdF1Y6/cNcyv7pFeYKWIIzXvIW8iP+hBWtU2L0d770a9gPr6QYNVygBhxQtBF/tQhYHCMhlkORPESul9UrUPd/A7qF8WHi93FN17nSZlUc3U1NrkzG6pJDhjHAbbxHtJmSxf1uUMmROCTAuaynuxKZiKYikRfUwGrC68z4/0WHj1fFUys0aWHS+5LIZYjoeg20o/ImbMTKdIMb2p+ql+E0lyc3G0Rnzz/HDZAD7s7vDnx4MRKcFeY/fHNGXB4fAnmHwtrg4GXaNPzgRDUrqz+FONI8XNI16KtFZpqCa5czj+1xx/+5tWersqFuB8h6l5v7jqDCteSPY+AuL5wpGLNzM7u/ShXfxLaPusQVV/xOuztojXIhgk7nMLValhEAu2xQwDkobBjaWogU1FZG9oeJi0vdGsDKvpQLMbbLBePIEn19yTSo5+Hu5Ilrw0bhRPhj8EabqiyxqS08yAZgNKfjk6uUIeXHK5iZBuIEogq1KuiRzOZ8Mt4jn4W9nPohKmi9BvuAcW3XfVjkvhUT5c+Em7kt37eL1I672yeauoVlHwX
 Zgw/zDyz
 j7jh1LUtXnqBx4T6xylnHjboCDiT3eTd1lobmHI9WxJzhZQDywVmLcqHuHxikG8w3dfQ6myokNCaG+aLwXVaHsl1e06zBoFqPNE+Acez47Rcdu+O+uKHwJ5EP2gsQ/mlcyAXzKRZBYYv0B5f2OEmzXv1adgFBHD1ud2l7Si0S1x7a5EdsFYo9iORVvRmhFQsdhBSRR+zC/svy5lgxqdRm4oBKob1rE2xOyVLhduxDujgN2nsZ4IDIT1fDWJp4vmFRj2paYjG1GG+1ErqAckS24TdQ+5m81RIMb8/fpnDC9bjCdteHVv5Bm2JnmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/27/25 17:59, Benno Lossin wrote:
> On Wed Aug 27, 2025 at 4:24 PM CEST, Vitaly Wool wrote:
>>
>>
>>> On Aug 26, 2025, at 7:02 PM, Benno Lossin <lossin@kernel.org> wrote:
>>>
>>> On Sat Aug 23, 2025 at 3:05 PM CEST, Vitaly Wool wrote:
>>>> +pub trait ZpoolDriver {
>>>> +    /// Opaque Rust representation of `struct zpool`.
>>>> +    type Pool: ForeignOwnable;
>>>
>>> I think this is the same question that Danilo asked a few versions ago,
>>> but why do we need this? Why can't we just use `Self` instead?
>>
>> It’s convenient to use it in the backend implementation, like in the toy example supplied in the documentation part:
>>
>> +/// struct MyZpool {
>> +///     name: &'static CStr,
>> +///     bytes_used: AtomicU64,
>> +/// }
>> …
>> +/// impl ZpoolDriver for MyZpoolDriver {
>> +///     type Pool = KBox<MyZpool>;
>>
>> Does that make sense?
> 
> No, why can't it just be like this:
> 
>      struct MyZpool {
>          name: &'static CStr,
>          bytes_used: AtomicU64,
>      }
>      
>      struct MyZpoolDriver;
>      
>      impl ZpoolDriver for MyZpoolDriver {
>          type Error = Infallible;
>      
>          fn create(name: &'static CStr) -> impl PinInit<Self, Self::Error> {
>              MyZpool { name, bytes_used: AtomicU64::new(0) }
>          }
>      
>          fn malloc(&mut self, size: usize, gfp: Flags, _nid: NumaNode) -> Result<usize> {
>              let mut pow: usize = 0;
>              for n in 6..=PAGE_SHIFT {
>                  if size <= 1 << n {
>                      pow = n;
>                      break;
>                  }
>              }
>              match pow {
>                  0 => Err(EINVAL),
>                  _ => {
>                      let vec = KVec::<u64>::with_capacity(1 << (pow - 3), gfp)?;
>                      let (ptr, _len, _cap) = vec.into_raw_parts();
>                      self.bytes_used.fetch_add(1 << pow, Ordering::Relaxed);
>                      Ok(ptr as usize | (pow - 6))
>                  }
>              }
>          }
>      
>          unsafe fn free(&self, handle: usize) {
>              let n = (handle & 0x3F) + 3;
>              let uptr = handle & !0x3F;
>      
>              // SAFETY:
>              // - uptr comes from handle which points to the KVec allocation from `alloc`.
>              // - size == capacity and is coming from the first 6 bits of handle.
>              let vec = unsafe { KVec::<u64>::from_raw_parts(uptr as *mut u64, 1 << n, 1 << n) };
>              drop(vec);
>              self.bytes_used.fetch_sub(1 << (n + 3), Ordering::Relaxed);
>          }
>      
>          unsafe fn read_begin(&self, handle: usize) -> NonNull<u8> {
>              let uptr = handle & !0x3F;
>              // SAFETY: uptr points to a memory area allocated by KVec
>              unsafe { NonNull::new_unchecked(uptr as *mut u8) }
>          }
>      
>          unsafe fn read_end(&self, _handle: usize, _handle_mem: NonNull<u8>) {}
>      
>          unsafe fn write(&self, handle: usize, handle_mem: NonNull<u8>, mem_len: usize) {
>              let uptr = handle & !0x3F;
>              // SAFETY: handle_mem is a valid non-null pointer provided by zpool, uptr points to
>              // a KVec allocated in `malloc` and is therefore also valid.
>              unsafe {
>                  copy_nonoverlapping(handle_mem.as_ptr().cast(), uptr as *mut c_void, mem_len)
>              };
>          }
>      
>          fn total_pages(&self) -> u64 {
>              self.bytes_used.load(Ordering::Relaxed) >> PAGE_SHIFT
>          }
>      }

It can indeed but then the ZpoolDriver trait will have to be extended 
with functions like into_raw() and from_raw(), because zpool expects 
*mut c_void, so on the Adapter side it will look like

     extern "C" fn create_(name: *const c_uchar, gfp: u32) -> *mut c_void {
         // SAFETY: the memory pointed to by name is guaranteed by zpool 
to be a valid string
         let pool = unsafe { T::create(CStr::from_char_ptr(name), 
Flags::from_raw(gfp)) };
         match pool {
             Err(_) => null_mut(),
             Ok(p) => T::into_raw(p).cast(),
         }
     }

The question is, why does this make it better?

> Also using a `usize` as a handle seems like a bad idea. Use a newtype
> wrapper of usize instead. You can also not implement `Copy` and thus get
> rid of one of the safety requirements of the `free` function. Not sure
> if we can remove the other one as well using more type system magic, but
> we could try.

Thanks, I'll surely look into this.

>>>> +
>>>> +    /// Create a pool.
>>>> +    fn create(name: &'static CStr, gfp: Flags) -> Result<Self::Pool>;
>>>> +
>>>> +    /// Destroy the pool.
>>>> +    fn destroy(pool: Self::Pool);
>>>
>>> This should just be done via the normal `Drop` trait?
>>
>> Let me check if I’m getting you right here. I take what you are suggesting is that we require that Pool implements Drop trait and then just do something like:
>>
>>      extern "C" fn destroy_(pool: *mut c_void) {
>>          // SAFETY: The pointer originates from an `into_foreign` call.
>>          unsafe { drop(T::Pool::from_foreign(pool)) }
>>      }
>>
>> Is that understanding correct?
> 
> Yes, but you don't need to require the type to implement drop.
> 
> ---
> Cheers,
> Benno


