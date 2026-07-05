Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2067C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC36C6B00A0; Sun,  5 Jul 2026 04:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A744C6B00A1; Sun,  5 Jul 2026 04:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A1B6B00A2; Sun,  5 Jul 2026 04:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 695396B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:33:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8ACB21C8168
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:33:41 +0000 (UTC)
X-FDA: 84954059442.03.902F05A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BFAD740007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:33:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eNPPFp5q;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783240420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=baTotMMHSOM5O4gBj8/uxAAtb6QXbZ9I7HQpeImF9RI=;
	b=NOXQUTqhIQYZLRBQH6nMBEqIOoS120odTWlfFA8yGBWkwZw3wiFtcr9R4eEBJFFb6oZHjX
	spTAueYJ5fFLRfobUZurs0ck8H97S4uMZPVLFcxwaRlnhh1HMAOhd/ToLwR7VrUxUDbV0E
	VWe0h/29Kx1DXuX1Z5DIxmAZdEDW/bM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783240420;
	b=fZ+T6X2KoFzXQWoflM+T8ond0XBWYYmnQ7nEZJBpo6pXvJ9f1D10Bcv5tmzIdXPSQsfBxX
	jCMxmOdDa2O0LYCq3WL0ed55/VAkQQ1WHaUhx/r1Leu2AxvQP4CLhRWgW/1enPxt/B14yc
	eqn5qV4IHqDCbcIUXEf1T3BbJ/0umIg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eNPPFp5q;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A24F643A71;
	Sun,  5 Jul 2026 08:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742221F000E9;
	Sun,  5 Jul 2026 08:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783240418;
	bh=baTotMMHSOM5O4gBj8/uxAAtb6QXbZ9I7HQpeImF9RI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eNPPFp5qbKoJvjUdtGg8w3IZMg0vNZv6+vkTJLLSWou52vAtg3PDH+YXoVUKkouG2
	 Tp5I1zPHI6skDu0RSAecz1Q5bIQEjW4D5u6sgFWBLlB3ZBkSkoh5xEUlGn3n1eSJGK
	 peEKGToSl+aX/tl3OJYA18f9PnOfG4kNUughduRc=
Date: Sun, 5 Jul 2026 01:33:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 david@kernel.org, liam@infradead.org, riel@surriel.com, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apopple@nvidia.com,
 rcampbell@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, ak@linux.intel.com,
 nao.horiguchi@gmail.com, mel@csn.ul.ie, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, tglx@kernel.org, dave.hansen@intel.com,
 jpoimboe@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
Subject: Re: [PATCH v3 6/6] mm/mprotect: use huge_ptep_get() for hugetlb
Message-Id: <20260705013337.2bbc075b508b5db36b954051@linux-foundation.org>
In-Reply-To: <20260703114202.365553-7-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
	<20260703114202.365553-7-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFAD740007
X-Stat-Signature: j74h1nwjpjgnthaupoxsjw5ues15w63q
X-HE-Tag: 1783240419-960344
X-HE-Meta: U2FsdGVkX1//qgco7JPjC79HwtvLrI6tPJf3ExrfQYtGsav0xkrMVTO8M4Hm5XZSBLDJsW8EQ5ZIgKKeb0lvEDF6rC2fluxihfxBZeAoQb1JwEQ8cfZicaRshDbNYipghscBvgW4bJVXF41ZbZLGdeCitiluBE0lJdfXGpM9ebNqj1TdP8nKu129tBWPip7JmtXoECYl0V/+hzrlXOLaiN6Z/xBSLSW6XL+3MoTej7+ZiB5ktR7ERgV7Lobv6iioPbD85FCoLGzzwTWInwhPrHIOAnMF7kv0HnYudDNJeUU0G3U5I0UQdCQpz1ny3QAEK4Y1oM35TTm5PSidOhrE/Y1YV4xuUouS5Z/IeLTy16bTMTGreDCN5PTp35JUg5fsTsScR9Rb2TxMWl9VObeC8nWQzKjdwFyZ6Z69XMyNzNRnvSN9BtiJRxKpnJDeCCsfNEumu/gDk36bBvI9SPlJxYXjtfTXdkND4CsZBOUBIEPt5ZVLht0PQkP8c48d1N3C+fjsW5OmDQ204BBg7HahTqFoEdFIRVNUoxfIsGPFdm/52LBWqZayzZZm+clm376p2yR1PKtQPbW1Ec2pqlsLB1sG7QxGdfpfzbINOg4sPrdNW8+j1exTdNpDE0en8G6V93x1MuKY5L6LVjl+uuZ/djvQQlhYrr5Vt4egZTWTbzrNRepfzbdfjlhvtYSL1jD4vzfGcVETHB+0CbrOVPTLai2XZ/NW0SR1+M2swv5J5mZfCB9+QzC8NRjTRJ+FyMY08fNceuXAe50T2mFnNsOiz1CsjUrO/OcX3QATjIxoByN/VRVrxR15KGrTUSfOUSkt+nRa53rL99HLukHQAvmTd0G3bgL2WS9Q5c5niFXFMYcoCL//pEnYmUiMaqxKNVufE0FrdPEJ0SytJ7yaePpXRpZ/zK5+w4TNQ5NLqTnAckxccC/ZEWGDsMrQcy/7uAbNOLiwsWG/ZXHfXU+X/+8
 dgMrysQg
 ncM26viiZmjYiLd/XuipOLNKTvmwcaToZjTNzoHJzZOT9pvHgMr0rS9Xcer7zwLyaCGuEcM7J4MmtRzaKgVMGVXfnCSrbcvHak/Fl5vvl9J9nkxalozERxOs0x8spk/zrdTZLftG70r5Vb7bUXPgekFqgTJ60lTWn4Zdncmq8HaTXklOJL1l1v2NatQRyMiYP0l85Hwjztg+UfwAKU0rw826q8H8yS1cGgSyaJv9YsIk12uXWPOF1WnNUwhV6kBAAFE6gMaRbHQRNcvB/va0zhnq1ibwcp8halJAXYTZfyPaLmAWG9i6vCpOBf3cF0jRw6cNk4FLAJtAIwX7A7dEhzmqmnLNukg3GTIXyRKCRcwdssvRNmU+Y80512Fw6uNnJ3ujcf5hK3Cgdqi++/I2MkZGR+uGl+1agTrpeDH3wnDi+NbOfzHlsIbCMcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Jul 2026 11:41:59 +0000 Dev Jain <dev.jain@arm.com> wrote:

> prot_none_hugetlb_entry() is the hugetlb callback for the early
> mprotect(PROT_NONE) PFN permission walk on x86.
> 
> The callback passes the decoded PFN to pfn_modify_allowed(). For a
> hugetlb callback, the pte pointer refers to a hugetlb entry. On
> architectures where hugetlb entries need huge_ptep_get(), reading that
> entry with ptep_get() can make the permission check use the wrong PFN.
> 
> Use huge_ptep_get() before decoding the hugetlb PFN.
> 
> Currently there is no path which can trigger a bug: huge_ptep_get() is a
> simple ptep_get() for x86, and the prot_none walk occurs only for x86.
> 
> So no need to backport - use the correct helper anyways.
> 
> ...
>
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
>  		0 : -EACCES;
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
>  static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>  				   unsigned long addr, unsigned long next,
>  				   struct mm_walk *walk)
>  {
> -	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
> -				  *(pgprot_t *)(walk->private)) ?
> -		0 : -EACCES;
> +	const pte_t entry = huge_ptep_get(walk->mm, addr, pte);
> +
> +	if (pfn_modify_allowed(pte_pfn(entry), *(pgprot_t *)(walk->private)))
> +		return 0;
> +	return -EACCESS;

"EACCES".

>  }
> +#else
> +#define prot_none_hugetlb_entry	NULL
> +#endif

Presumably your .config resulted in this change not being tested...

