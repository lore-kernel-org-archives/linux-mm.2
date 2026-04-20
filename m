Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FE0F557EA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8DF6B0005; Mon, 20 Apr 2026 04:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCD66B0089; Mon, 20 Apr 2026 04:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09D76B008A; Mon, 20 Apr 2026 04:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A25A86B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:48:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56DAB1B8CDC
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:48:50 +0000 (UTC)
X-FDA: 84678308820.16.D9E8DFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD47E140002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:48:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9vRxeYx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776674928; a=rsa-sha256;
	cv=none;
	b=t5qSg12XOOKO3L609t1M75zXtMZwqR36/b/e6MJRQbyiAdCgDSZTAJUmzFSIxaWto2cmPg
	4hd/VHN+tglut18usWLvRKgLark0DVGw70HQTM6sN6sQS+G56R3bqRRM/mZ0H2Wg32anYf
	Mt0ZSpdQJC14pUOjqlmTJ3paJ6IZo/c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9vRxeYx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776674928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NOeHAESzNyoOLo2eS/PzuPuitQFv2Vq39LTbJUFR2o=;
	b=b1lgIEv1LSZgh36Rq9bYuaQKpgKUpSH/4UUe+b6BYfh/nO+dNTaEbT0+fEdOQuWqNKGO43
	YW/t8jQbA3tNnivX0GGuGxzleM8CUvRqSo9bDp8i1fGIY8NtjAoQJk2zNhxNGZCUga/nkM
	C0pX2V7j4vZmQKs7Cr4MAfiwbBSwM/M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E69F960055;
	Mon, 20 Apr 2026 08:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FBCC19425;
	Mon, 20 Apr 2026 08:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776674927;
	bh=qLFgeQwJCkpSSOG98sxSdZSktT3hEJUY9FwxAEoEYcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T9vRxeYxFL9cfHlFph+p4HZ7WoGh85kwA61pnA64hopb3JqkEUHIbig41QikVB0o8
	 prK8HkTDt/Ffs9L9+yWgpZ8m4vNtm2NtKgvqFrHGKZ0kSrCIaIWiX8XFRWTp4AuE0n
	 5rRHIYxhoMQxEg92Bznbq5kvvr9NtLFa1+jC88YbV/vcS5Nf256U/iPi/x0/kQMUif
	 dXVbGPzd1qJz/5dHW5nJNtqHKhuEzPHYOIDMMJ/zgr26bjAhEbAWxN1H9vUvNYGDeQ
	 R5c4ehGomLkv+Eu4Uh3VAGGXsphT6EG7QRTvQj3L+E424MFl6JzHADE8L5FH6Bs8l9
	 HaSyWBlFLIDsQ==
Date: Mon, 20 Apr 2026 09:48:35 +0100
From: Will Deacon <will@kernel.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, willy@infradead.org,
	david@kernel.org, catalin.marinas@arm.com, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	anshuman.khandual@arm.com, rmclure@linux.ibm.com,
	kevin.brodsky@arm.com, apopple@nvidia.com, ajd@linux.ibm.com,
	pasha.tatashin@soleen.com, bhe@redhat.com, thuth@redhat.com,
	coxu@redhat.com, dan.j.williams@intel.com, yu-cheng.yu@intel.com,
	yangyicong@hisilicon.com, baolu.lu@linux.intel.com, jgross@suse.com,
	conor.dooley@microchip.com, Jonathan.Cameron@huawei.com,
	riel@surriel.com, wangkefeng.wang@huawei.com, chenjun102@huawei.com
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
Message-ID: <aeXoY7lrRJev0P83@willie-the-truck>
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228070906.1418911-3-yintirui@huawei.com>
X-Rspamd-Queue-Id: AD47E140002
X-Rspamd-Server: rspam12
X-Stat-Signature: 7hxppqzjkn7ua4eh8edy6b733nfgffs4
X-Rspam-User: 
X-HE-Tag: 1776674928-600060
X-HE-Meta: U2FsdGVkX1/6q5RLohVJ1uz4XrKNVtonl32lg4KjWbJB1ATc6BwULvlMMOpni39vErWyi/QGW9y5xuiK7E3wWMDcTNGeS3xxMlioKEmdmyRvEsfujkYPYD8WClrc9++e+rWgr2iChdWulkUrnv5jSXZQlGZ1JvDlD4P1e6BZC8e7bCExWUkJQctImlBfwLcmr43/BNwusIp+XlP/X16Abmd8o7y97rVWW6bsssbww9r4lURhYxG8Bjr3AylUZ7pOrGIIlTChbqa1ElTyCAckbGAV+gl6/BGgemxwDwxsZagjqXECgdHqNwItFEmO9PoVm7zGooehaLYcGj2/n5/r6UvTFgOm0tix4fAwQpGkAcoZ1uzGXa0t2qVs/HVAuQRKtnhOm1YSl3LhPFkzjbL64swb1jVmddOd01YkcPZvcBNDPKbxzhY204RO9jn4Y0jaPUgBVZN5Jaz9odFQAew9DRAaoKkw+mIxUT/4GQQqUQf/tr+sJJT43qEWwN6t/gLBQr0UfrmMtKIYvM+gPlDqvNZycxnhOZkC9OWi7+UP1YxhltNRFlN10R2ztiZ+HIlkocdjHbOkSoWn+LvQmwjR2RFR2Zxfbl4Ol/VUekfa31R99pM1Ssi/Tz1eDzmXW30Skxka4DM6kdDK+i0jKAKlATpNo/VDuaFO8CUIC4kskcTcIqQ8dMLtLRqW54XqMGKX426G4BU4O1odzug+I89XZsff0AAYqQcu5HYXvvLYEQ+9J5oLCnkfQ4ScFe+61iOjdyZHkDroKR+P+rvjkumk/9GjLKHhpqKbXY3WgNd8tvey8406nmzyxoCDVHQdkmoy4vzWKiKPh1HM9fX7b6EOz2YIRGQ6Bk83o7klyYwWEe6+xQc7GKgqxG8QkQJgJvhmex1pjh3XPocOAWm8nFjcXPjBC4DZ3Ndb0UbOEXfYLrMO6xh10wQkWJVN3A6LOhhDULlD3r9PoMEdiMHFAZl
 pqSry9eY
 RwvBLBP+p+hpOxIidCa+w0tTQ+BWLc4l0BzlInTJ5EqRcqOsFzlhiOQIZb4WbPnLw7ycIQUTBCzwtzgiynT6kHzN7mHCV9kWXcO+1LwAEHoGNLvk7pFoifHvRfnAGCoZZoIc+pIu6hxFb6AATJGw+xHXeYIdf0qNKW7r5NnIbJ7te70ylZh/Nr89dZu95rRRtZ2RzsQ1+QdRHW237yux72hxbUuRdVE1xT6YJI+c3tGxG4OsAvYZeaFAkq00InQ0BxR4xer+8qn0JRQmc0dHjvWcGxjM159m7ONuMAdcXGdFQ5YnVKpOhTglw4ASZKaZztPvJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 28, 2026 at 03:09:04PM +0800, Yin Tirui wrote:
> A fundamental principle of page table type safety is that `pte_t` represents
> the lowest level page table entry and should never carry huge page attributes.
> 
> Currently, passing a pgprot with huge page bits (e.g., extracted via
> pmd_pgprot()) into pfn_pte() creates a malformed PTE that retains the huge
> attribute, leading to the necessity of the ugly `pte_clrhuge()` anti-pattern.
> 
> Enforce type safety by making `pfn_pte()` inherently filter out huge page
> attributes:
> - On x86: Strip the `_PAGE_PSE` bit.
> - On ARM64: Mask out the block descriptor bits in `PTE_TYPE_MASK` and
>   enforce the `PTE_TYPE_PAGE` format.
> - On RISC-V: No changes required, as RISC-V leaf PMDs and PTEs share the
>   exact same hardware format and do not use a distinct huge bit.
> 
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 4 +++-
>  arch/x86/include/asm/pgtable.h   | 4 ++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index b3e58735c49b..f2a7a40106d2 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -141,7 +141,9 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
>  
>  #define pte_pfn(pte)		(__pte_to_phys(pte) >> PAGE_SHIFT)
>  #define pfn_pte(pfn,prot)	\
> -	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
> +	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | \
> +		((pgprot_val(prot) & ~(PTE_TYPE_MASK & ~PTE_VALID)) | \
> +		(PTE_TYPE_PAGE & ~PTE_VALID)))

Why are you touching arch/arm64? We don't implement pte_clrhuge() afaict.
What does this actually fix?

Will

