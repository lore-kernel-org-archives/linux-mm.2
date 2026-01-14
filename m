Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B933D31A15
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6BF56B0093; Wed, 14 Jan 2026 02:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC0A6B0096; Wed, 14 Jan 2026 02:21:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D83A6B0098; Wed, 14 Jan 2026 02:21:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3D86B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:21:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2357B160209
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:21:18 +0000 (UTC)
X-FDA: 84329723436.22.84E6B80
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1FEDF140008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:21:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=GLYRdRw6;
	spf=pass (imf26.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375276; a=rsa-sha256;
	cv=none;
	b=r9WsEm3Gx0ZKW1E1TncDn7EsSSGBXuVkNPHPTQy6jpyfsx9S+pspJTkzM2LnwTa1hCuwD7
	RAOh/RHcggC42Ym5P5ggLh7ZfcAOkGSujMKDLW8kYzky71UnTU56fNyPiRCJSO+5TnVrtQ
	FojIBsy3B786jkD+o50VLH1oDci1/HE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=GLYRdRw6;
	spf=pass (imf26.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USGtV3+n93v8pp6pT/3Zgm6YGfywpo0PJVEBtkCCeSQ=;
	b=Pd9r36CdVg7i7XZyQYrnwlpYawGo9w6TmnbtJicSHshaSjcyn09CK4Ek3P8GYtpgbqqhlS
	YKLozLHRSxqik2fTPlGD1tETtRvc1JxX+2f3mUdBzg3CYx+H/oqGmJc8GH8iJhlpK2VY/D
	DDUX7M/DyMhwB9/Fr5yigi7BV5howEw=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4drcwp38sWz1DR2b;
	Wed, 14 Jan 2026 08:21:14 +0100 (CET)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4drcwm54NNz1DDXY;
	Wed, 14 Jan 2026 08:21:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1768375274;
	bh=USGtV3+n93v8pp6pT/3Zgm6YGfywpo0PJVEBtkCCeSQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GLYRdRw6BcVYpXpDzS8ZqYhxtT7bZEqyt6FuYL8Og+uuX6KmBzkodf4AAzTgQK8Vj
	 6QbBYuy/EUx3fCM7vga1p7zdd9seT9SSuJ28fck7TvCAs/Gwc0UpWogq+FDfeMLhxP
	 Q9tIWi9KAy3JY7vvXnVldebdrOSI6/xQmw6aZqkHZJU9FXjDY0poTHU/LzOD1ekgYF
	 2nFh0u8d2uWVggyereuQ0MAq07iXxOjlDmJmNDlViRxcJ4I2srsAz+uaxP1y7echmT
	 rgWILKmtxf/xBcRfC4IBmOKjPaCa/8zHfl4NRJCZIC9TqeetLFcYzLPvsXlK9du/pk
	 oxIYdU3UlZQgw==
Message-ID: <544172e4-cdf7-4789-8cad-4dc3c498e497@gaisler.com>
Date: Wed, 14 Jan 2026 08:21:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/14] sparc/mm: replace batch->active with
 is_lazy_mmu_mode_active()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-13-kevin.brodsky@arm.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20251215150323.2218608-13-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FEDF140008
X-Stat-Signature: auy6a17oj7h3h86kcd5cbe99q6rdkcxo
X-Rspam-User: 
X-HE-Tag: 1768375275-739957
X-HE-Meta: U2FsdGVkX18CQEw4xfB+4jxiuKnlqIIUqDQmP6Y+3+Qx3ko2riHTnvQuykk+Y2aTjMWPeE91KyISuO+aUMI//2BtHm5b9MYhmTE2VR5bBVNioMZWR4wVANlPIcYOJJj3BKe2CQjtADoUxMeyy9rFKN0qoGGOo4bARzKYKXxBMq1l9GyZ5Pj/gLajMIydpSDrqt/qAL0YFu3pIaxz/01Ks8GSdfm0KR+9Un9PlZfifBvrwqLYOizFXH5p0IJPm76VzqZwl1foNUdnSEVhSdbTTmUz5QVDIt18dI1SCOnVAJ2VG2QxobtiNjMCd14i9gUESm97VEVgrJkNBQ34s69B6kBzJSQhmQYnEWSxUysipb5XdnlTMyr+8bJn+/RbgSnuI93n5zO5xAA/kB802inLyl+cMnbFN5cOHlmttuaaP5bffTkyEtUy+mQ2AIIXXwEDHP2fddVNFXHotGCO8LPXZ2Me86elM//QMvwjI1CvHlAdYP282Qsjg965s+YjeJdOr8EsfutmBIPpu/YBKLd1mFWGVm1ElCVcAINoEpFsIE7F82V4U9LxMbOgaAt9ZRTXz5OGIGXce8DFHMK/M7YIBoGwnbQo7XdyFd7kgWP7MF1xsW3hfbCNQ8+vLlQArpHRjZPihOn1A17ZZVpEYqkOKRE7HnPjdhXAiPrdnsgSEOZKi+pZU/l5UsJOg8jyzZ+zeImXg6DC2zf+Hk9ouWh1QWPmXnNqRSKjND/u2YaiLVFKkWkPaoUK8BHaoghZsFadFgihAY/nMfRd8D9cu0vVVtyPNIYTD/bzqm5JlBKGHtD/WQw8sQ9s5zCtUyHmGFHH4i/h3/RoASJDjgRLiuSbT5OMEjkFk/daHDkmkmJKo398UzlmN77672fKLaoP+BoBWVmlAHBz8qjj4S7pgQRwy2W3oTzzqHcxVAqH3v7tyRkVkk3TS3Mx34QKffkkr6sa589Pf/uA8S7P9noOLFM
 8W3I81bD
 OVPE5IV8FeuBTlYR9qURFH5nWuZ9Y5QyjdxlsH5RAbYVKZez9wd8CyKgYWOl3zjjSNtxL2hOqWAaihK3NbHaIkaYvcKzO2Llj4D+fD/EBwLWZauo451/9tlPTW9s6VfnN6HYW3RTpbdF5oUACrH1xNrif7HcwuVA+LEkZhmmhrcb5jjAhvmi1lO0GA8ehQmLx+uql2Wxcy4wE+fmtcoqKw53iMdVYNagS9291kAo2kWZ+bQPKaibahcOwVNIau205ct3Xh9JcPO7wl7hCLr9LXyLv69FiBPOTykMSPlBILx1tm88b/Cy8IuJ9tBcSoYFatDwTJ6WMyIzF+EXB1/velcJ0Jrkc/oDvC3kHspo/GJklXaRy89KUOzjStQpYqOpDJSzHukd2bKw/Pw+6aVmgZGvXG+8q9w5T9qie6UMoQbOgixIYDtyVIijiF/YZQstkp22tSbyj7MOLLmmZzv2goWQ9ybviTGGJRYxQ/SCRkn7KZYEdmWBZxwqA6gwTYE9t/8ajnFk2/Vu1aku6v7qqqalGTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-15 16:03, Kevin Brodsky wrote:
> A per-CPU batch struct is activated when entering lazy MMU mode; its
> lifetime is the same as the lazy MMU section (it is deactivated when
> leaving the mode). Preemption is disabled in that interval to ensure
> that the per-CPU reference remains valid.
> 
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. We can therefore use the generic helper
> is_lazy_mmu_mode_active() to tell whether a batch struct is active
> instead of tracking it explicitly.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/sparc/include/asm/tlbflush_64.h | 1 -
>  arch/sparc/mm/tlb.c                  | 9 +--------
>  2 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
> index 4e1036728e2f..6133306ba59a 100644
> --- a/arch/sparc/include/asm/tlbflush_64.h
> +++ b/arch/sparc/include/asm/tlbflush_64.h
> @@ -12,7 +12,6 @@ struct tlb_batch {
>  	unsigned int hugepage_shift;
>  	struct mm_struct *mm;
>  	unsigned long tlb_nr;
> -	unsigned long active;
>  	unsigned long vaddrs[TLB_BATCH_NR];
>  };
>  
> diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
> index 7b5dfcdb1243..3a852071d260 100644
> --- a/arch/sparc/mm/tlb.c
> +++ b/arch/sparc/mm/tlb.c
> @@ -52,11 +52,7 @@ void flush_tlb_pending(void)
>  
>  void arch_enter_lazy_mmu_mode(void)
>  {
> -	struct tlb_batch *tb;
> -
>  	preempt_disable();
> -	tb = this_cpu_ptr(&tlb_batch);
> -	tb->active = 1;
>  }
>  
>  void arch_flush_lazy_mmu_mode(void)
> @@ -69,10 +65,7 @@ void arch_flush_lazy_mmu_mode(void)
>  
>  void arch_leave_lazy_mmu_mode(void)
>  {
> -	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
> -
>  	arch_flush_lazy_mmu_mode();
> -	tb->active = 0;
>  	preempt_enable();
>  }
>  
> @@ -93,7 +86,7 @@ static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
>  		nr = 0;
>  	}
>  
> -	if (!tb->active) {
> +	if (!is_lazy_mmu_mode_active()) {
>  		flush_tsb_user_page(mm, vaddr, hugepage_shift);
>  		global_flush_tlb_page(mm, vaddr);
>  		goto out;

Acked-by: Andreas Larsson <andreas@gaisler.com>

Cheers,
Andreas


