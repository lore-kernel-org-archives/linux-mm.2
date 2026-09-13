Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD93CC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 06:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52DC6B0088; Sun, 13 Sep 2026 02:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05C46B008C; Sun, 13 Sep 2026 02:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A276B0092; Sun, 13 Sep 2026 02:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6E46B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 02:46:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27F12405AE
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:46:39 +0000 (UTC)
X-FDA: 85207805718.05.23043C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 53E9220002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:46:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XAnBHG8a;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XAnBHG8a;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789281997;
	b=IrHumiZkPMb9qPH3krjDSFSgwsnIzV3xt7ykQTV36bprxXzC/Zq9f6QYpEbihezpgdt6gQ
	kc/ORRXb8+s4Dyyo8ogaBLl8uMu2X+IXo3Kj5/SWtyGHVgR1w/hCzZYNasOxmcBpwUJ/RG
	rt3pChfleRz8fpJDHlIRxGzPY77YOEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789281997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQwdvU95FrXRFZwRBjEBFe2/Hx2FqUUlTLasQMUqqps=;
	b=zG6DzFf2nJGslq4Cji3eKATwukBCaUR0OVuIuqHBEnUw6TZZsy1u/KVusuYUyE6A99SLz1
	RQcFLHhk5VNmpiYTV+PVMEOJi5dPaY51f5sJnG3Nd21HmMnWwGomNa0OG/ECvISUvZ943g
	SCKd5jhDl75tlIG49+JpJ1fryDdFOOQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47391401B8;
	Sun, 13 Sep 2026 06:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72A81F000FF;
	Sun, 13 Sep 2026 06:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789281996;
	bh=xQwdvU95FrXRFZwRBjEBFe2/Hx2FqUUlTLasQMUqqps=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XAnBHG8aaIJf3Qg7JPHialtHJS0edKVR9YxPGIF64eWU5k+ntxHydQKfUl+NAY0Nd
	 9o9UYmJ8HPCNiCz6K64j9IsAo7b8DqvCGwAt17PZsa82RYoIXM9oOW4ik23SPITNqm
	 jv/7UJh2FCC4QPLUCjPrEFiyUV5vMhR2lGYhmqns=
Date: Sat, 12 Sep 2026 23:46:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 ljs@kernel.org, surenb@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge
 zero PMDs
Message-Id: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
In-Reply-To: <20260913051942.40889-1-lance.yang@linux.dev>
References: <20260913051942.40889-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 53E9220002
X-Stat-Signature: irdka6wue1949kfo8tn91ymreoswic53
X-Rspamd-Server: rspam01
X-HE-Tag: 1789281997-29454
X-HE-Meta: U2FsdGVkX18z1Bh6G9qT+jVYqUUHbRevSCxx8qWlhVS2/KYMkHKfkm22EQWC7TmRiXjqp6gtSgAj0l5ldHMHSZywUPjIXUiEuc15t+Ym/xKbJ0d+BHTnwVLQe2DLJRO0uEhU2I4FtP6JMB/Ci4Zvwo7MbnXxYDr1WQcU5xCT/3j1LHcbDB7u0iBNV8KRenR3eUu4h4pFDP9l80+WhhKI6umX78L/Z8psVKJxz5+cRHwJ1EZOXx2QwvsA7ca4mMnkbyOadUgZnYXC5e5Wqs8JL2ulxTSc3bsZs2iedXps/OkPu6KFIUxAFfwJp1TZRvRBvh4KDdypStl6jeBVE+XMb+PL+8jxTz3Ia+sRp0MGOmmJArtrUBpKnLZwL0/IlVzQTaJkXpWxzmrmNBDT8GNMsL5QdxVQSpVO1ouxNK7DKgrdsfmc0giY9sd2Ly2rIdHW2FrIdcuM17VXbs0VR8W884MWQlPJCCZqwfQkkii+2rOQrT/3UEVVrlMXKITK/Riu6buegNRaR8nKePbTCbdhnlhN6P3YtltQh7gkCpdHWuY25VYFedHpIi8n+uyi3P5wdUMS4eHxFoHDLsi3nNlaZsj4qG6tkYYj3SnOmnNSvNNIG96E5hjKU/SZWqwScd8kwJzuc7/ocxjt/TdQPswac782jPJQIbw2rWyGyYaKLHBOl/6afN5CgZQoEeIBRi+BiGM65nMSVh1uSk/nEjxl7yKgP50el0MmwuIOMxZUwMjGROmNSl2QmQgQTB0/pbvGbKhNLyIfYbIhDC4WwMlxFAaXgW/gsPOlc1O95Bn2cxQM3dY8TFleaX9+JbZqCUkjRMYMX7u01LCa7wxklR3K5S2cYNzCkG36Ie+PZg+swocdH1dEDaNwT1e4v4CbOZJJBQqc+iv3CaXVLPvsHAo6TRPEZQWAynQloXrexcHQ9yukjXQakY/rygC6m9FOJMkm6jqC6+Gn82YFXp8ONW2
 temG7/RU
 au60t5jr26wi0L9igE5lMQt0ig/Il7kQo9m/ZK4tSP5+ZvYyGGB9fw/LhstMzETIYf/5jGzqVLNyCZItaI16cSnyK09aTuHTQYaBaGbymvIQb2ZTkr/1s2QQ5cazBxRxtnQ5Rh3+MWTC+mQMSOo34DQFJK4F4UEtiuAi4/qkW8hDPb2QpKFqdQB1lqNBQjmUp1LTYMohERnVUZytOpnqICNFo1vE6AH/BKlOeBeJLlhk979LzWPoKe8tRdu/gh8G3U0q8OvEbXB0V7mdico+HwEN4JB0r4LRizZV0R8iB21r1b0PfUi3krscP8edDUNYqkkpZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 13:19:42 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> From: Lance Yang <lance.yang@linux.dev>
> 
> has_deposited_pgtable() uses !vma_is_dax() to decide whether a huge zero
> PMD has a deposited PTE page table. That also accepts raw PFN mappings
> of huge_zero_pfn, although vmf_insert_pfn_pmd() does not deposit a page
> table on x86.
> 
> Zapping such a mapping would call pgtable_trans_huge_withdraw() without
> a corresponding deposit. With pmd_huge_pte(mm, pmd) == NULL, that causes
> a NULL pointer dereference.

That's the sort of thing we'd prefer to avoid.

> Use vma_is_anonymous() for the huge zero PMD check. This matches how PTE
> page tables are allocated, deposited and moved.
> 
> - For anonymous page faults that install a huge zero PMD,
>   do_huge_pmd_anonymous_page() allocates a PTE page table and
>   set_huge_zero_folio() deposits it before installing the PMD.
> 
> - On fork, copy_huge_pmd() allocates and deposits a PTE page table when
>   copying a huge zero PMD into an anonymous VMA.
> 
> - Raw PFN mappings use vmf_insert_pfn_pmd(), and DAX file holes use
>   vmf_insert_folio_pmd() to map the huge zero folio. Both use insert_pmd(),
>   which deposits a PTE page table only when arch_needs_pgtable_deposit()
>   requires it.
> 
> - Moving an anonymous huge PMD preserves its deposited PTE page table.
>   move_huge_pmd() transfers the deposit when necessary. For UFFD MOVE,
>   both VMAs must be anonymous, and move_pages_huge_pmd() transfers the
>   deposit as well.
> 
> Keep arch_needs_pgtable_deposit() first so architectures that require a
> deposited PTE page table still return true regardless of the VMA type.
> 
> Commit d80a9cb1a64a ("mm/huge_memory: add and use
> normal_or_softleaf_folio_pmd()") removed the vma_is_special_huge() check
> in zap_huge_pmd(). That check skipped the huge zero PMD deposit test for
> non-DAX VM_PFNMAP and VM_MIXEDMAP mappings. Removing it exposed these
> mappings to the incorrect !vma_is_dax() test.
> 
> Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
> Cc: stable@vger.kernel.org

How real is this?  Is there a reported-by:?  Do you have a reproducer? 
Is it a theoretical, LLM-found-this thing which can't really happen?

> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2529,11 +2529,11 @@ static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
>  		return true;
>  
>  	/*
> -	 * Huge zero always deposited except for DAX which handles itself, see
> -	 * set_huge_zero_folio().
> +	 * Huge zero PMDs have a deposited page table only for anonymous VMAs,
> +	 * see set_huge_zero_folio().
>  	 */
>  	if (is_huge_zero_pmd(pmdval))
> -		return !vma_is_dax(vma);
> +		return vma_is_anonymous(vma);
>  
>  	/*
>  	 * Otherwise, only anonymous folios are deposited, see

Thanks, I'll add it for test-n-review.

