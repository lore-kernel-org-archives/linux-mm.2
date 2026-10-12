Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8118DCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1DB6B008C; Mon, 12 Oct 2026 07:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7793B6B0092; Mon, 12 Oct 2026 07:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68EC26B0095; Mon, 12 Oct 2026 07:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 444076B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:15:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3291120B48
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:15:21 +0000 (UTC)
X-FDA: 85313718042.11.DEC175E
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0502B1C0004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:15:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Iampd+S3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791803720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOcvEm9msY+cl7KKbAZfMaogQnVH3/RbIaSfojxkTRo=;
	b=xL24nOxn7Dvu2aNcESDzWi32SqoHCaLGOVOGmQb/ucJ9hbYJ9z7d66S9E2ZbabukZCUQzi
	ABT3nn/fBUTzuxmC6LWQAdDQ/liVaCxLDqsqXKWoJN2u/wXi66UmyiOb9VGH5cdhot2ndD
	iaws7su7nGKOilmZMYUEGMLenFGUrz4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Iampd+S3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791803720;
	b=oAYdIYjzZz2Zj/DZGmViajOSU2/aEtrKUPSyZabpmZHf/8cFdEhp0D38YwiulgnMIDY+oN
	eYINO+jLMeLI1Ju7nrCeXHhNyTmqFR6o1tuxrvfKEY5ROdbM1dENIUXrRECrJ4nezCrYVC
	2X4hWYwcMRVG8jGCNyWP0dXDgAcaLHM=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b0ef9c76eso1454062f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791803718; x=1792408518; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dOcvEm9msY+cl7KKbAZfMaogQnVH3/RbIaSfojxkTRo=;
        b=Iampd+S3xYrXhXbswiPYMVDtPTKohsWJ3+IfmSnE0cjJbhM4uFghprkHMQiWsCiBpk
         Na0Qf+Fc3QjonbSoLGCDvC4ZWvvRRaWiF2kZdvRgMA0GUd0r5wH9fDJmUHt7j36u9VTi
         rrkWjhXIuZG5nUiXNOG/bljpbLgK5WqBrshWO5KVNLZck/FpBx979UkvJDRXNRCnb7fn
         lc8pBmbHbHS9Ee5Q7qWBrtTLyjMATAFmHMzhUellUvvu9yIqPE0RcsEEf/mPY/m7BgR/
         ZiCpYX0m25lsP5z+AvHGGagZsyhPIkWsS9VrGpvjPqHRoRHcTZ4tKMhS/o4/zZTvT8tW
         NPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791803718; x=1792408518;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dOcvEm9msY+cl7KKbAZfMaogQnVH3/RbIaSfojxkTRo=;
        b=xOc/6vk2M0R8Ka/FSKRgY+1t/hZd4JlMDGuRSjUDIDPJkf/RWtVYWkvLTrOX7OrepQ
         moVC+0Xb/j2RvApAHwcwwkUCD/DbA7qfCBqRZBS1oXesPbDBYwf3Xw65bcl8hYKvdfqi
         PnZqWz4kudIejr+CNHk7coOXl+mwgBOqb/luzl/Nut5cwjSi9/Dsjdyv9Gdq3Oql0qrw
         jVPvIfXGBhL9xu6r75nDcZ/4FFdrk9SEKCgj7MDIETFO1/IDfyQCUMTuwtUEdZdn3e85
         59izsoUq9mdJaDILeb3k+W3LFvBAJ3x0ko2W2TFzueVSS3k3N3IILkPBYxpYRqaJ5wK2
         dVYw==
X-Forwarded-Encrypted: i=1; AKwUvBwvbu2hxouDJSvf3jZAfJjoPl1LobU23C7vdlA2J6FmwRiAWQTuhm29Mbml6pvIYzglF5QWJQDmeQ==@kvack.org
X-Gm-Message-State: AFq9FYIpM10uzJoA8dIQ6q959Z8fpgH1ysBrxdvHAKNivq4EPKHFVBKt
	xIrI84jfB5UdVcwT9k6VONibrk7R2WDQKvD/dlp6OrDaKClnpSefcTBz
X-Gm-Gg: AYBFou1ad4ZHinOkvAfXNS0RI0ktx6VO9QYhmJDiAoLw1IQ+DsHRMP2cI7AR+vYVUvq
	luKhYIzRuUdb1EQoryc4qb6F0rA+6HAuCKstrQ/dtRCVIf4Oqn2aoKy01TAJYkip9u3aDxMnXHt
	bwvTPm8XpjLtJC4w+ifw+o05DDvQ9sOA1DoOZjO2v2P8sgZju5ws9UYLriVwmIhfGwoZ6Cd81EB
	di+XuwOgak8kA0LSW6kg5fXA4uhvAnxipuU9t7FcbtgnNd6+59GIMuPzok6iG91X+ZXi6thM3jL
	KND6mLSLf1KTpRmLn224zbn1fyYCpRMDvZZnUikcLJXCUg736ajL27u69mhXp7EaqP/ICw44Rya
	bRmGeADRfJTi5ahwHlhYJ+zBfxK9LeIJdlJgHxhLM7EyPaEMpLvVnai0R8wJDibEUpzD/NgSu/d
	zzahsTQi1oYeeQqWNKc6tMp6ZKLW8Cu+F13KaR6HAzWSuZz2R6ILrnMOprk1mONtIMzk0eIw==
X-Received: by 2002:adf:e005:0:10b0:48d:dec7:974c with SMTP id ffacd0b85a97d-48ddec797bfmr346783f8f.7.1791803718021;
        Mon, 12 Oct 2026 04:15:18 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db94e33d2sm20034954f8f.9.2026.10.12.04.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 04:15:17 -0700 (PDT)
Date: Mon, 12 Oct 2026 13:15:14 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Dave Hansen <dave.hansen@intel.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
Message-ID: <asy-b7_C3SjnmSaS@gmail.com>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010112457.49485-2-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 0502B1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: w8h7mib6suyti5jb1wfa5rot3o73uc81
X-HE-Tag: 1791803719-668079
X-HE-Meta: U2FsdGVkX1+mp6hj/kuc2DHvykIuJVPodqvJWE5ulE75zxw2+ySlvlFw0QrNb0Hv92U5cV3fBpfBQOJaycpjZoWwaSqSHlWv2ZNMsjk4aABrvA/0W18gesZ+cVTjr1ecQiOpxxy0d0hFrx4UKyCO1fAuEZHN5muQnQEcFyLE3lFC22ZGzfArAEAA1H50rxISqpSJnRi0aK7UcpkFbcMuv3snhqHtQtsLCQ+KfHgcp5vhY7+ivYvxU55QFvv7ZQ08K4YqIYLSYMWXb2yfqD7l2Rc7nCum3mOq0qEdhLWjJP/gXDBXP2vC9xwA5ten8dZ8DfFlvbWScCRmDTTsH2bLykble8P4Z6HfRU9upMsxPew798MYXX6FNGo/htGmyaRBsTs/96YRF5IRvaLeGuOm0QytxU0JQ4uIoYXHGwrBRXU6wKlYBDtUvUngu+NRPvf4HJkWlqp923eDChKZ4uQZA+cOw0JCTY0l7ElOok+N6lam3wNmux85zIl52Ol/00GkYvuYy7wHj/h93qSVeFDs38f8HupUFXQgAhl86int1sQDlGjYfS2mELTXHPS73B8qwugfOHh4hMKRmm48oQym7zDC6+4BrkMIvNxmE9PuqcAtueUe0etkVGEgxcytbVOHxjaMzOgCV9H/PrSzZGtvbyaQ2SmpXY3jz7jXk3/1L3IO08nCz9VUcEYbU0FQqN0bDZGjwIOxZRZc9W6lirvAshmT9no4aoUPi6YVa/B0CB10VERygin7zOwjLl0LDEE3nJkTS7fb90aBif/qVCz5mrdoG8yAzIXQ+dJp00BV2UD6dfscZtXUD1bTuDRQKmdcRciyITJYKv7uBb1d78Fd7r/CYHqejo6jlhpbyhI2N3iVcyDymTb51Eah2iiNrqLlhoLUWFab9Zgd8No259G4c5okAz9/XCrJKnTyA8e8VEZP0ZHkoZ8DjwlVdXEHpZu/2VYGH+6FLSH+rzSO82c
 AtCIl4Eu
 vwBerIPCWhc6uwhjRsEVsikgBC2kHmTjtxsSoI5Gn+qQ9OelCR8IbODdTySzMQjB04VbMcmglmLSFwBAQ/3oPXTaIBV1JF2AoOr3pNAjRWLN+Zt5KzFL1sdNo2GMfV7CBMbCbaPBbd4qvYwJVZCC9iVIPL/sBRBddm5GkeabtiUQr68kFFNtNCMK9sEGGYfZQdESl23Kitp/jMCvz+UP7OPt1JGiK0d2YGugiJghOkT4te5esDfvIQjM++nRMu6ZwIaA9PylSYuXvaDzzYqFFTLfiNNQIaD8zOEvnyMrOerN+mRSeOpetKqFQV0RZmu8uIa5nwPSiWVYkZsYXzfyZM/6qfMzia0B760oIir+UTRyyD6kZ3Rcx3MYJ+GtqocrzroL47c/3FafKoi8TeV5ZcXyUd0ez8CfBJqIMvRR7I2RCqTq6eIS6NTfzr2jI01ASAX4pDVG6Ow5CwrtTkbTy3y+/3n0JscD/dRtXvqgpIuSrlaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 07:24:54PM +0800, Muchun Song wrote:
> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
> tables.
> 
> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
> splitting a PMD. Restoring the vmemmap backing pages does not collapse
> the PTE table, so a later memory hot-remove eventually frees it through
> pagetable_free() on x86-64. That releases the page without running the
> matching destructor and leaves NR_PAGETABLE elevated.
> 
> Make pagetable_free() detect constructor-backed pages and run the
> destructor before releasing their memory to fix the problem.
> 
> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
> Cc: stable@vger.kernel.org

is the x86 case covered for 6.16-6.18? as far as I can see, x86
free_pagetable() only uses pagetable_free() since bf9e4e30f353
("x86/mm: use pagetable_free()") in v6.19, so the backport wouldn't
change anything there. or am I missing something?

> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Move destructor handling from x86 into pagetable_free() (suggested by
>   David Hildenbrand)
> - Trim and update the commit message (requested by Dave Hansen)
> ---
>  include/linux/mm.h | 37 ++++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5cca90fc1df6..771a7d60b0a5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3969,23 +3969,6 @@ static inline void pagetable_free_kernel(struct ptdesc *pt)
>  	__pagetable_free(pt);
>  }
>  #endif
> -/**
> - * pagetable_free - Free pagetables
> - * @pt:	The page table descriptor
> - *
> - * pagetable_free frees the memory of all page tables described by a page
> - * table descriptor and the memory for the descriptor itself.
> - */
> -static inline void pagetable_free(struct ptdesc *pt)
> -{
> -	if (ptdesc_test_kernel(pt)) {
> -		ptdesc_clear_kernel(pt);
> -		pagetable_free_kernel(pt);
> -	} else {
> -		__pagetable_free(pt);
> -	}
> -}
> -
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
>  #if ALLOC_SPLIT_PTLOCKS
>  void __init ptlock_cache_init(void);
> @@ -4078,6 +4061,26 @@ static inline void pagetable_dtor(struct ptdesc *ptdesc)
>  	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
>  }
>  
> +/**
> + * pagetable_free - Free pagetables
> + * @pt:	The page table descriptor
> + *
> + * pagetable_free frees the memory of all page tables described by a page
> + * table descriptor and the memory for the descriptor itself.
> + */
> +static inline void pagetable_free(struct ptdesc *pt)
> +{
> +	if (PageTable(ptdesc_page(pt)))
> +		pagetable_dtor(pt);
> +
> +	if (ptdesc_test_kernel(pt)) {
> +		ptdesc_clear_kernel(pt);
> +		pagetable_free_kernel(pt);
> +	} else {
> +		__pagetable_free(pt);
> +	}
> +}
> +
>  static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
>  {
>  	pagetable_dtor(ptdesc);
> -- 
> 2.54.0
> 
> 

-- 
cheers,
jose a. p-a

