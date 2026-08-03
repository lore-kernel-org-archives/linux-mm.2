Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2E3C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834B46B0088; Mon,  3 Aug 2026 10:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B4A6B0095; Mon,  3 Aug 2026 10:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3A36B009B; Mon,  3 Aug 2026 10:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 434E46B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:01:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7AA9A0724
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:01:42 +0000 (UTC)
X-FDA: 85060121244.11.B16FF6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C67FB180003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:01:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="npJot8k/";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785765700;
	b=o/QF7dXFVSw7F5XPlx8BNcR1NSDpfcEgHbKd+VWdoYjhqTXvHFuYlzwdNPzKxrmEcREW1e
	dA5xHuG4btVvqsn6jSV6SH3+UBKFo/rVfn077rLvOUo3vbQB6G2gHQv4V89CuffAY/zhS4
	8P3GGp+1TpxOZ0wCZOSlxGgL++VAjHE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="npJot8k/";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785765700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WncJv2kkcU64xKPGNQ9beukr0q+5pv5G1Ub8Qx4hfik=;
	b=h5QK/Nc9BK03z/FWpK6Cx/i/rGX96lrXvpavwQCxLI36NY8O0LRVzIjn9BR6hrDfV8bWOU
	2RC0Ay0eBgUDcyikh9nSBSbCQLHnlsdUKJJTlZFnnREDptCsOPBQlvuLj06njwV7iPoEQc
	gvkpaKYaCWLVdPii6vL6TxDzBsYoeuM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE3A9415CC;
	Mon,  3 Aug 2026 14:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AE41F000E9;
	Mon,  3 Aug 2026 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785765699;
	bh=WncJv2kkcU64xKPGNQ9beukr0q+5pv5G1Ub8Qx4hfik=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=npJot8k/nrdn2nthtMpZON/6+VLaq8SVi8n+4nzYI0Jk2DSK5qwvIOA2D3oOkYQh1
	 f3q1+vu33VbW5bjt0uiNre4iWtGzntus2qu1QxZJLVnfpM00USX/UMGDHcMBYLJLh+
	 SCyj29wXRdSdHv5CHVJ1eTDd8wADiAo1t+EUvGN97K98lm32Sopdid6Do79v2v61Qw
	 3Tw+Tf1ERJbiE/d2ZmuATr9wgacAy9Thola6shj+ZwFFKh044KBuin47utz8u6lh12
	 Gos65PSTbKmdBKNI+sc/kNiy4T9a71yIJeOheQjkcjeeEpu5z25UvfgP7UraGMPldT
	 bg/fIPFuUsPDg==
Message-ID: <d01d461b-6af0-4ac6-8e5f-c7c4dfe6234d@kernel.org>
Date: Mon, 3 Aug 2026 16:01:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org,
 david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev,
 jannh@google.com, aliceryhl@google.com, arve@android.com,
 cmllamas@google.com, christian@brauner.io, tkjos@android.com,
 dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-2-surenb@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260802215459.2769283-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C67FB180003
X-Stat-Signature: 1aza71enp3gzx8iaxn1dj9ogjqmaay33
X-Rspam-User: 
X-HE-Tag: 1785765700-144950
X-HE-Meta: U2FsdGVkX195EH0FqCIzEBRtS4NCJlryfnLRj5i0/C3KCGgDcCqybMOL0Hr1Dx5uCBsk+0YGJzVi0v7t7u6PcNuQIr/5M/xfY/4oe+l+oXm0mEhfm6N7wm0rGL3P421fL3KutVkY8VNuRuf1aSwRxSpBIi8/sW/7l2fhkUpkDldRfCDDuNCSVC9Xk3CZ0qtu+tEFk/FAmEk22QR1k5XbfoJgzRMVzrM17V+Pn92Bj6IQl0QxKg6xU5LkS6oPPUUth/t8Zacg4ePKXblm/UWhtu9ddURRpiY9dyS2YAecwramUY2Hqti8cD1VNSsNNlSpDRqadEGiG69STRp5DSNZNmbrF460+7zDoxi99vgoJGqO1fVEQI+ls0d8YA7zKShWmB28Ui3QTbowH3Y1meZrLDL7MIhhIMiTZ+F4N0Y78Em+M79BxCa0Vy3iZnhK5DikYPLfssqsLYon8/TlHZHBHzzw+ivNH3PZG2JZ8QH1HoCDEkv1L4tp8BtmlmEQ9RNoKe5GU0BwOez8KbllCmb3ayjQMheYcL+cDhRJ17r33JNUwzlVqz7yyFCHhIbwugPbwnQJ577bu0AohcXA6XZ1xOva11dp2+0Mky48GesOC9e8wI9SPF/hCT62fSrXFTDF1VeyMfc07FgL0a40YHlBo5Md1z9l4qcTJHIQwtZR2rQKb3Kxcx9cYWvLtIXaZSKYWTLfkpPCHymM7liExFtekB7sEfGno0sCfiaFT/I7PlFjDKMBI7cU0ZKbQE2nj1jILih4K1xUwJWErh+blZXDGWB5W0MWPpDoszwY3WLI16KPM9GH2u50g33RzSOpRmYOo/tsh1modvrz9u/ChRr58ijXPk11PacDv0CcvQmrqGm3OU9viUpXwE2ie8dWOlrIQU1wHwVZxqq/p8/0i80UzktYCcEn24hw/V0Z9MvRKAeL5iJUVmN/RC/A08WMataPvJUItOfln5r5ySDfjq9
 EfErQsYr
 t3txoNcPRT8Qz/6cMGd1cP6b/q7x2Rh3H2QAWkR3btY42yjwi4yImMYEykZC7DwswsEjNSW8C7FqSR6s5gB52RsdoGeoYKDVNm943JNEFve658sr8JWVW/0bzzjwxGG57A7TpfqZ4aVRCHEEwHPTt7w1qJDgKZd7nSHIGq1lEJNoXg49VJromoXYqdIq0FoHN0CkQe0UhKqekKW6Q+br1W+cetGI8RWAXXaAvF1uPJSptwPjvQF/Ab6ognhn143wqRFOYvtmPF5yIUnrukDOTXB4d3d/CO93+vuCfnNXV9m2MiSzvPMQ16S3ctx6sln6CPsuFyOmetQSWZ6TDs4OXzs9smekozkMDzJv9ROUuiJTE/WoLGeF4+ISG/FFN1vv0AnqEMmQKYEG/hTcNpaVMBly8MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/26 23:54, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.
> 
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.
> 
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=n configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
> 
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* brings additional
> simplifications.
> 
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. There are likely ways to optimize this, especially for
> things like SMP=n configs. For now, do the simplest thing: use the
> same implementation everywhere.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nits:

> diff --git a/mm/Kconfig b/mm/Kconfig
> index 060190e12bce..77103b46b679 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1425,19 +1425,6 @@ config LRU_GEN_STATS
>  config LRU_GEN_WALKS_MMU
>  	def_bool y
>  	depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> -# }

I think either leave this in place, or remove the line above with "#
multi-gen LRU {" as well?

> -
> -config ARCH_SUPPORTS_PER_VMA_LOCK
> -       def_bool n
> -
> -config PER_VMA_LOCK
> -	def_bool y
> -	depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
> -	help
> -	  Allow per-vma locking during page fault handling.
> -
> -	  This feature allows locking each virtual memory area separately when
> -	  handling page faults instead of taking mmap_lock.
>  
>  config LOCK_MM_AND_FIND_VMA
>  	bool

...

> diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> index 4764d7b68f2a..2633e704c83d 100644
> --- a/rust/kernel/mm.rs
> +++ b/rust/kernel/mm.rs
> @@ -174,26 +174,20 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::mm_struct) -> &'a MmWithUser {
>      /// When per-vma locks are disabled, this always returns `None`.
>      #[inline]
>      pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadGuard<'_>> {
> -        #[cfg(CONFIG_PER_VMA_LOCK)]
>          {
>              // SAFETY: Calling `bindings::lock_vma_under_rcu` is always okay given an mm where
>              // `mm_users` is non-zero.
>              let vma = unsafe { bindings::lock_vma_under_rcu(self.as_raw(), vma_addr) };
> -            if !vma.is_null() {
> -                return Some(VmaReadGuard {
> -                    // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr, then it points at a
> -                    // valid vma. The vma is stable for as long as the vma read lock is held.
> -                    vma: unsafe { VmaRef::from_raw(vma) },
> -                    _nts: NotThreadSafe,
> -                });
> +            if vma.is_null() {
> +                return None;
>              }
> +            Some(VmaReadGuard {
> +                // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr, then it points at a
> +                // valid vma. The vma is stable for as long as the vma read lock is held.
> +                vma: unsafe { VmaRef::from_raw(vma) },
> +                _nts: NotThreadSafe,
> +            })
>          }

With the "#[cfg(CONFIG_PER_VMA_LOCK)]" does this still need to be in a { }
block?

> -
> -        // Silence warnings about unused variables.
> -        #[cfg(not(CONFIG_PER_VMA_LOCK))]
> -        let _ = vma_addr;
> -
> -        None
>      }
>  
>      /// Lock the mmap read lock.

