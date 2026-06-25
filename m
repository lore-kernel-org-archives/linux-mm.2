Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9736CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8A86B00B5; Thu, 25 Jun 2026 16:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BAA6B00B6; Thu, 25 Jun 2026 16:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5420A6B00B7; Thu, 25 Jun 2026 16:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 242FF6B00B5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:42:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CAFF1C4B83
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:42:13 +0000 (UTC)
X-FDA: 84919607346.15.C9ADF69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01D7018000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:42:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J42nwSbC;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782420132;
	b=59zr7tgZz0OZS/YPkB9rixetocDjsNpOTI8C3kCe9jEq358/B93+Kel+A0vW93B1l1Qz11
	r7mPuZqPvZP8C+bCvmxHkndeEyanzMVKnkV6aWqvFTLMtrlTiHHMFk49hJz2GV5YkzLEp6
	RPyy02Fp254GrQdZ9Wnb7H+h4hzDoP0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782420132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvlsNB+ervCF+sSkJEPbN4Ijm830xLpfVQiWgPNgpJk=;
	b=antI7iXPXnxFKfpzVtfMGKqK6TONgYlzjgxhiyQAxdRcSpuoH0s3WHw8dqqK9PF5A4CLxe
	TOUv65n15BdmHx0OY4gt/kgaWtrbsswKvE3alc55lBFgk1shXuvOC0aIoxEHDrAeJPVO2l
	7TL1NA5A3t5zxHEc7cEndyrI+jgeijE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J42nwSbC;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EF7C60098;
	Thu, 25 Jun 2026 20:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6161F000E9;
	Thu, 25 Jun 2026 20:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782420131;
	bh=JvlsNB+ervCF+sSkJEPbN4Ijm830xLpfVQiWgPNgpJk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=J42nwSbCRvM0JMjF02PGznrxY18hUTDWVZ7tp9Th64egsofZWFuK/7UwkXSOiRMWZ
	 JFb4QbKQRBo1ee2fgXL4731g8g5ZKzhOektm+yfvSxklJkQC5qdKNXM7OsyGK4z/tY
	 7jjlUpMGk4xKRsvKVa6Ep/nb13JWkOg5psKsGHVL12oqfaiiky+CVSym81jwqCaUJd
	 l0RSq4P99yJkSjwmgCdMrOVUExxK7WZ1uEcahg8Pc27XeAso/gLvzUpXefzzEJr9fg
	 eaOccN7Oxpq5Nq5P16tkAeJOKLakhws44CZBq+jtnWPcBaYjoZ+eeFOMpFoUsZb9wW
	 GGmRDKHSaUNGg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Danilo Krummrich <dakr@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Uladzislau
 Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Daniel Almeida
 <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>,
 Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=
 <arve@android.com>, Todd Kjos
 <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, Carlos Llamas
 <cmllamas@google.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Dave Ertman <david.m.ertman@intel.com>, Ira
 Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore
 <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Igor Korotin
 <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth
 Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>,
 Pavel
 Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski
 <m.wilczynski@samsung.com>
Cc: Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 driver-core@lists.linux.dev, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH v18 3/8] rust: implement `ForeignOwnable` for `Owned`
In-Reply-To: <DJI5ZY2TPFSW.BEKOVZYRSTQZ@garyguo.net>
References: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
 <20260625-unique-ref-v18-3-4e06b5896d47@kernel.org>
 <DJI5ZY2TPFSW.BEKOVZYRSTQZ@garyguo.net>
Date: Thu, 25 Jun 2026 21:47:35 +0200
Message-ID: <87y0g2h06g.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01D7018000B
X-Stat-Signature: 3cg69zymytca5iok7q3cxkzd8bud1sn4
X-HE-Tag: 1782420131-815261
X-HE-Meta: U2FsdGVkX1+rWJKE4qpZ7UvkJMNbaa4juuZ28a7mcOYUFmhtrGKhcVvQGnOCOc6DRDjosc7dU3B4Pk8j5zKYJOSNcdSV1cKelxtth1IDfK7cOet/UMUPBdn09Xwdf3hJDb04OT/9aNRnpU+KzKfhoQtLRAK88gYnKs6s/kOYah7LfgzzBpGn31aH0t1iEwgrRx7YcEJw8tWqCTCquYMCKhRRQpKx++6S+CHyqlaJbBKBm1Khw61rjB1JtXz+oslZeE8+jqYR/jv4TM8s1Om8/SlXEDpac9+vsvNGAzukoAtXvYSQn9mYudGGdyC+ieX8wqEDuZlHqCm1yclOpav6Y0xfsUcB1zMZC5J18HxK2uy0YDT3iBG1u+i9Pdj0eFb054xZFshzCblO+HvcncTvIWoItRPbL9sCSDnIZOkiB2975Y5rC08+oc9sFWfJ6EtIMX4qrkHH3TRlYgubGrUYTAq/bLI7Q/BQqTAgTwOJExj5t/sMw6qYdAwqk2OoZnuKqeKIhqU8elT7O3/vFurKY7mSkTZVBSQOGo8WGY2v4eqDPZXQlR/mOup40ezr7c+sB5NSqxIMpZCKC3kvTtewiNmTpF2Els299E3ovdcvypM9c5F7nCnxVtelbBF9v9wgfNTvtmEQ9NjEZwyGaGKgvFnB0CcOENUCoTiqA0wLyfWMUgKyJif4OeTnlAfJlKzEwHpW5JB60VcHICF5WG4WvQ2LrukvzfTx2CkvEAQTvAViSlspQ5F6XK+grkQFxGdwBuca8RgxIWc7p+f3t17oL3bHwI821xPnfWHDLvvqypw2y0JfFHVBXbQml8EhTI8fFW7ZssMtLRBHi98gpTVQQ4dfzX7fw6mr1FhV8OojutWsbzFLY4vgUQ52n/8ALoqSYUnx2Lstb7BAoNvizJm2kpXCGDuV+eK9vyFJfDZ5hvJjkkVlgKsk+7/ii63WnGtEyWkrUTzZ7vz4GLTOyns
 XtclJ3nb
 gSDsYJrZMRg7dbMGovpZfV5v9X4DVbpgMRV/vUWkDA5PCdvDM4CeczOMpARDHhDHDVyWibtczKQqsmY4ichSBDtRB4QjAOWY1SbMu4fD3ee8M/5Jc8DYQkQr+0Mcu1C7QfeWnpTQKGbC+Vh7Yt3C586Ij7GiU9SfPbAccC6nx1nQ/ubFfdw8KsboGuRIIQwv9meEmWJ8WSj7t/1QQK7GA4satBcR+VvrdT1rYvfJweQNJKO0FyGsIUmCzVRlJ1uVKDk+TUbALv4EPxq5nBCpZlHgkaXOE3VxzcUzlKwDRW7assWTJPz/VbBZ0Ys2zT0A6f09g/3hIW8nhIBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Thu Jun 25, 2026 at 11:15 AM BST, Andreas Hindborg wrote:
>> Implement `ForeignOwnable` for `Owned<T>`. This allows use of `Owned<T>` in
>> places such as the `XArray`.
>>
>> Note that `T` does not need to implement `ForeignOwnable` for `Owned<T>` to
>> implement `ForeignOwnable`.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/owned.rs | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 53 insertions(+)
>>
>> diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
>> index 7fe9ec3e55126..9c92d4a83cc1b 100644
>> --- a/rust/kernel/owned.rs
>> +++ b/rust/kernel/owned.rs
>> @@ -15,6 +15,8 @@
>>      ptr::NonNull, //
>>  };
>>  
>> +use kernel::types::ForeignOwnable;
>> +
>>  /// Types that specify their own way of performing allocation and destruction. Typically, this trait
>>  /// is implemented on types from the C side.
>>  ///
>> @@ -186,3 +188,54 @@ fn drop(&mut self) {
>>          unsafe { T::release(self.ptr) };
>>      }
>>  }
>> +
>> +// SAFETY: We derive the pointer to `T` from a valid `T`, so the returned
>> +// pointer satisfy alignment requirements of `T`.
>> +unsafe impl<T: Ownable> ForeignOwnable for Owned<T> {
>> +    const FOREIGN_ALIGN: usize = core::mem::align_of::<T>();
>> +
>> +    type Borrowed<'a>
>> +        = &'a T
>> +    where
>> +        Self: 'a;
>> +    type BorrowedMut<'a>
>> +        = Pin<&'a mut T>
>> +    where
>> +        Self: 'a;
>> +
>> +    #[inline]
>> +    fn into_foreign(self) -> *mut kernel::ffi::c_void {
>> +        let ptr = self.ptr.as_ptr().cast();
>> +        core::mem::forget(self);
>> +        ptr
>
> I think the pattern in `into_raw` is better:
>
>     ManuallyDrop::new(self).ptr.as_ptr().cast()
>
> Or perhaps this can just use `Self::into_raw(self).as_ptr().cast()`.
>
>> +    }
>> +
>> +    #[inline]
>> +    unsafe fn from_foreign(ptr: *mut kernel::ffi::c_void) -> Self {
>> +        // INVARIANT: By the function safety contract, `ptr` was returned by `into_foreign`, which
>> +        // gave up exclusive ownership of a valid, pinned `T`; we retake that ownership here.
>> +        Self {
>> +            // SAFETY: By function safety contract, `ptr` came from
>> +            // `into_foreign` and cannot be null.
>> +            ptr: unsafe { NonNull::new_unchecked(ptr.cast()) },
>> +        }
>> +    }
>
> Same here, could be using `Self::from_raw`.
>
> However, the current code looks correct to me regardless, so:
>
> Reviewed-by: Gary Guo <gary@garyguo.net>

I'll defer to `{into,from}_raw`. Keeping your tag.


Best regards,
Andreas Hindborg




