Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433B5CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E256B0093; Mon, 11 May 2026 09:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF516B00B6; Mon, 11 May 2026 09:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6F86B00BA; Mon, 11 May 2026 09:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37C336B0093
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:19:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D85731C0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:19:50 +0000 (UTC)
X-FDA: 84755196540.15.91785E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 495DC18000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:19:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3TH06L4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778505589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1W6PyvvzUTHFE94Kgwr+7D7Vxrg4RNiT0kQOszyhfP0=;
	b=40dcQOfk9x4J3aoBbH2l0E+tlVr8mNCR2yvzFmz0wGZh4jp19RuOGhBK2I8Cc75UBsa5R/
	i2dYxtScNr6BnBNjX9Fm3Cu6p+4o2yLxOEJV1n6vQ8ovnOOkZO+8E+oNwj/4SKc9OdTpCr
	Pm3xMRTnn4dZTJgIPa8UOp+0rpsHC1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778505589; a=rsa-sha256;
	cv=none;
	b=6092SbaZ5kbQYydCYdvka3uHMozIt4gyDY+Xxg8sdEWQFIJokAPzyOrRhVQQu5Ge1Fxixn
	ZL8pnsJTH7K6yDqXWTpF0oSMB87zSLNBOlUUOGKnGjSDGB2g6VrAO9Mc5xn/Nq5RDCRHdN
	X5348Tk/g0wr1DCpCkLQ6iQalbNtOYE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3TH06L4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9DDA600CB;
	Mon, 11 May 2026 13:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E667CC2BCB0;
	Mon, 11 May 2026 13:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778505588;
	bh=H1+fy4iZDYEhZY2GjzfH/emNfhvyYP0nA1cI/0uy0cM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L3TH06L44RCzk/qacwhAzUN8yLdlJxmLUtBwrXO4bVUmJU8pb9+rw0r6DC1Ebw7zy
	 sf1AzPjVpGGttdCauWj5pjYI89B9KaYkx4bGCSZJpgTwnkvHg6jTx56smYZ49kkSV6
	 TClv8H484tr+spByrh2W0D1/wnpJCvU6uWo1k1MLw9FfbDuP2rn3jYj8SkGta6sgIi
	 l2r5afFQpF7Y3yzn/gM3FvPlQZAyA2T6oHrOAbF2flfNyN216+M6iouLrIp4He2Uza
	 16X69ZTW/ndPQZpVXcDluVZ34KI/rVYOkNpJym32ML/W/m92fVJ8x0nAP0GbGqBvBE
	 xXKWtugyCaU5A==
Date: Mon, 11 May 2026 14:19:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Carlos Llamas <cmllamas@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust_binder: use lock_vma_under_rcu() in shrinker
Message-ID: <agHUZ4AKQBgMecBY@lucifer>
References: <20260507-binder-shrinker-lockvma-v1-1-76e3406bbfa6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507-binder-shrinker-lockvma-v1-1-76e3406bbfa6@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 495DC18000D
X-Stat-Signature: mk9dpein4tgo6g94tseo1u4oquzw5k8k
X-Rspam-User: 
X-HE-Tag: 1778505589-205006
X-HE-Meta: U2FsdGVkX18ZE88oP/V8ZR32m9ujfekpsOdyIL1Uaa183Nu9/WqPX+0YuVtU1ecRs2HWg+Co2MXXQAHGHDE5HItRVY72WqFGPhjOpWrH35jj0jieGAyEGWPk6VemgWJprai+OMJqNtuWBn8DIBHR2g3dbUNOV2+Xa60mBd++Qb3+9TpYInE6kRjTiI29snxecs2sYRWjzsTKavLBIAavE6dSir0hc0FulXpBaHmn7nIHLhIfFapHRmoxURZYf6O+PKf7qXouFuJIDRRjsd3EHsY50NtFRNNPayD6mPIJjdW7g4otwIHgGb7i7P5KQLODgWrc2/7cZiCWBfsbndow8BZoRLkE+D6X0KnFe1PbS9SPuPw09SNtdtcK6O0hoWGBSFnBufcTG3Of7WppHDrfeJChLwdJr/KwC3MmLLVCM8NOQ9a9v+djqtC2bOrHg8T/DTb6b39IOv6Bl9dffrI1lHSlouv+5ynEr81hCiALlsHdgz4BUF5EB32UhjasR40c6AmUxOO9GXVDtjPLCfqrMvzw4/Vl2LZO8Qi9PyjzbfdUOYIrXGMmMo9ug2eF3EdYWf1iOTwxjH/bwL8X/r3rIA8cyhUW9l2IG5Xcq/X1uX1NkJbRoCAEpiPXWSw2dnDOKTgRMLCfvEletiSeWZx1DzUMaphzygVdm8odEQMsU4UrPQmCq4sjUFXIR0Vyaw3L2jNqGDHwRlBVnXM8FJxueAOJ3z5OoZzeCXAqd0tTcBJXTbLIceAhhzW+wyxGg33XLjUb71MEYb9o2vY71UetZAsqUt7hxThCJ8HvpCxmKLIVxmxqpdSxwUwUb+UChx9CtyNGanlK68QxExoEgLOi1WIdm+sGoNtSha1n7VyJylDDGxy+jKVaOMnO5CmTbKtuUTnCDVdOqFX0H3n7NUSDF4/rZROBXawxVIDq6qFx2/f9+fXe4aJvJPl02S4hqSHzOMApV/9ZWV09q83x2iu
 NG6yjr4m
 osyIcacc59QZlaoEAOzZglFGYipCD7jJ6hDVwZ4uUZe2WXJlaPXF4ddyu1MGcpXn9sq4tO161+QkKFjrH58U/MmfSS3fjSW2FYCGAmsUv6ehIT5y7XHS7qayB33LAeT5FssXPd03ksBqq/wEdSeXiKyVc52v/w2lCJXjHI+1zGqKg0xibxEWf+YWXIBy8ck2Uz19roAesX74HEoG00gbTIId9VMv+6GshWzLrEZ1VDluwEmI3XG/pqELBYn3Ns7ITT7Q8Bh8yYAAh0747u9aPANRPHU9ENfIp93pK2NJtYDJt0faswzyaoUk7IZV2laAhC7vV0uyXNo3VbjxvzlLa/IUcGoaE6sJOPu+DCwoJ0oU637OVdWp6NvheVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 11:07:47AM +0000, Alice Ryhl wrote:
> The shrinker callback currently uses the mmap read trylock operation to
> attempt to access the vma, but it's generally better to only lock the
> vma instead of the whole mmap when you can.
>
> When lock_vma_under_rcu() fails, there is no reason to lock the mmap
> lock instead because it's already a trylock operation that is allowed to
> fail.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

This seems similar to Dave's patch [0], not sure if it was inspired by that? :)

[0]:https://lore.kernel.org/all/20260429181957.7511C256@davehans-spike.ostc.intel.com/

In any case the general approach seems sane to me, as rust code I can't really
review it properly, but aside from the comment below (presumably that's fine) it
conceptually LGTM so:

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  drivers/android/binder/page_range.rs | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
> index e54a90e62402..e82a5523804f 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -705,7 +705,7 @@ fn drop(self: Pin<&mut Self>) {
>      let page;
>      let page_index;
>      let mm;
> -    let mmap_read;
> +    let vma_read;
>      let mm_mutex;
>      let vma_addr;
>      let range_ptr;
> @@ -728,17 +728,18 @@ fn drop(self: Pin<&mut Self>) {
>              None => return LRU_SKIP,
>          };
>
> -        mmap_read = match mm.mmap_read_trylock() {
> -            Some(guard) => guard,
> -            None => return LRU_SKIP,
> -        };
> -
>          // We can't lock it normally here, since we hold the lru lock.
>          let inner = match range.lock.try_lock() {
>              Some(inner) => inner,
>              None => return LRU_SKIP,
>          };
>
> +        vma_addr = inner.vma_addr;
> +        vma_read = match mm.lock_vma_under_rcu(vma_addr) {
> +            Some(guard) => guard,
> +            None => return LRU_SKIP,
> +        };
> +

One question here - are we good to do this _after_ locking the 'inner' lock
above?

>          // SAFETY: The item is in this lru list, so it's okay to remove it.
>          unsafe { bindings::list_lru_isolate(lru, item) };
>
> @@ -751,7 +752,6 @@ fn drop(self: Pin<&mut Self>) {
>          // `zap_page_range` before we release the mmap lock, so `use_page_slow` will not be able to
>          // insert a new page until after our call to `zap_page_range`.
>          page = unsafe { PageInfo::take_page(info) };
> -        vma_addr = inner.vma_addr;
>
>          // From this point on, we don't access this PageInfo or ShrinkablePageRange again, because
>          // they can be freed at any point after we unlock `lru_lock`. This is with the exception of
> @@ -761,14 +761,12 @@ fn drop(self: Pin<&mut Self>) {
>      // SAFETY: The lru lock is locked when this method is called.
>      unsafe { bindings::spin_unlock(&raw mut (*lru).lock) };
>
> -    if let Some(unchecked_vma) = mmap_read.vma_lookup(vma_addr) {
> -        if let Some(vma) = check_vma(unchecked_vma, range_ptr) {
> -            let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
> -            vma.zap_vma_range(user_page_addr, PAGE_SIZE);
> -        }
> +    if let Some(vma) = check_vma(&vma_read, range_ptr) {
> +        let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
> +        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
>      }
>
> -    drop(mmap_read);
> +    drop(vma_read);
>      drop(mm_mutex);
>      drop(mm);
>      drop(page);
>
> ---
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> change-id: 20260507-binder-shrinker-lockvma-51ff7d621f25
>
> Best regards,
> --
> Alice Ryhl <aliceryhl@google.com>
>

