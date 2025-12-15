Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7710D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 06:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66B36B0006; Mon, 15 Dec 2025 01:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E179B6B0007; Mon, 15 Dec 2025 01:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DBD6B0008; Mon, 15 Dec 2025 01:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2F7A6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:06:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CEA21369A5
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:06:52 +0000 (UTC)
X-FDA: 84220671864.13.AA5F245
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A6AB71C0002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:06:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dsvGK6qE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765778810; a=rsa-sha256;
	cv=none;
	b=SAhfNoeZjM80CceleiJLhoJ9CXy81nBbdoSGTZVhvYOWSk2c3hlOlsBkexlGNrA3/cHg2U
	ctJeLsdvshPMCRLBNZ4WLEjRyFl+HdkPsygU8whdziVbQpWglhPfz3sKXhbjcCp1NRBTct
	gETyDtvkEDFAca63RnhzNZVHL02ta+w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dsvGK6qE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765778810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TlLSNFRpMoYucnzWkE6fZTL8Gqv3gNFBMOp3BHRi04=;
	b=lscMXFT/hAEb8ZoisbJIc6hexjb26LWfrgEpRIWKv2cQmDHZwHUzMyJLSzWozhsFaEQUZN
	j/7p4r/CEcAolg9XnZ7lr1Zv6e8M6+A9IfkIIZJpmihCFojf08/BDUnRxCmWwhLXyIAmZ7
	E2U6iab+p85G/VeRB3x3Awn9kEqPpV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46769432E5;
	Mon, 15 Dec 2025 06:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAD2C4CEF5;
	Mon, 15 Dec 2025 06:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765778809;
	bh=LZhBjlTxoFNlhrByvEV/y6EF+GjXIZM8Cs2e+DsOYK0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=dsvGK6qEbjcxkfXe4dgqGA+2gUZtLCGId9H7SRkUvCsYVOVSKyLW+oEIivRixBz+1
	 Z2Kkg2MWVahuSVvGlCjiAodOrZGvJJhqNY64Auk2gayogXzdCDIoc10dKd+5rCIJGp
	 g6OOehz+1Z3pGWYZQp2ltjP1V2ZMst0KhsfOTFkv9P4MH2bPqMG5DlMXRoUfSij6ub
	 e0vDR9gl0HQ/I0xH6yl3grXwGmyh32GJjZZfc5hMA9h56ccCrDeUdEezOPD+GB8JOK
	 WmtGBHDM9GXG3PrHDOf2iqrmzjJIALENh50UFXxhp5HRp0BST6R+FidCNs+EnUt6iK
	 76woTMbh/rMYA==
Message-ID: <686b85ff-6a5a-4608-af97-55aee1582c5c@kernel.org>
Date: Mon, 15 Dec 2025 07:06:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/pgtable: use ptdesc for pmd_huge_pte
To: alexs@kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Thomas Huth <thuth@redhat.com>,
 Will Deacon <will@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Magnus Lindholm <linmag7@gmail.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-mm@kvack.org
References: <20251214065546.156209-1-alexs@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20251214065546.156209-1-alexs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6AB71C0002
X-Stat-Signature: adwdyxsb96im8hx578qqqkomzeg84gi8
X-HE-Tag: 1765778810-536330
X-HE-Meta: U2FsdGVkX18DVHgJ5drhQp0b0AQoarqR6tknH1GLVZwtb7qsgmGbjS3oqL4TThIqJwFK1/nvRIAsWja3bw2YQ3MjAZKt1sPCkgyKw+2CSJtmn4zQcDrFk5cY+I55bb+K44gBb6c4khq09rmHLiy83oz0l8eQpdhUh+Gr2JmMPDdjBRqU+9q/GogaizyaTcJ/hmSuA7Mrc/Kq2JYYwmFhrYVQsMld6gQ8rpN8h2fIT1cqwj585jlxCJgak3Na3rczkIuHzV0a3liYDIZ9aOdTa3cnajzpraWzZsVtH4bCMLP8Bt3affofaUTrbve/Bd1yfhSs1JvJOfdjLGbj2UjJKZGpA7kLMFskAImI6vXNtZH1nOgbcykkfBlbaU3/fb3UmFOYT0WO27QHlk+7BPnsDIdvSP9SFIOnj8o4tUGxYRsWU6+hN3YGf8QMkHNY34AlCMSLLjyTbloANh+98CqfCMHZuRUIAf0OPsJrlDfbvMAU6UWPVZrC9NI2La+Co7qGgyUTChMq/55QkCvD+ofLG0CzpZLLfDbOE6M3BC2R/X1EyvCeob5GkQEArAPd5InWUYl0vk3FH0c7UdY44EghnMIm/42rCz1ZbMgcZimXhcXiOe9MgtETFTqv5GDAzpe4QN2EOsLpy0uDeaAbn9YpTCDH78eQQdZouEgDWD/AscJqxpdfS+C56R3UDVqcKxAZqvKRLntxKmjXPetIBd9tej30Gh5Ba4p96x2htNRr/hMDnbzR7T4q1ER5h2zjOPcgM12f9NSYZaCMZQbCo2Zcucz60CMrUdXvGlHaOamWN6haD4Gxl8yoReTJi/L9JrUjSOQoLwkiNT9Z5BXMIkkR56dretq4QJMvtcwUcBvdvn0hGpXYF1+VRzPZPQU0Cn9LeMXlLsaNYU+jb/Xo80+KLbhKjfKnTnevpOK8hahKQCHP6BgIjLdXgHXvwV7eVZsxq1JSk5+B5H7y3oVsuyv
 RsLhQFCL
 I4XT0uQFnqDP1bhTSKYzndW8OhlUI3LHaDoTrbG4RmumG62dJV0lVUvbcLC7rA0N6Q724wnHovVtS+Vzo8ctdyY50vpWEICUMf8+wG2i+qMIS7qMDgbjQC7hymkH/NR44KMo+0GJIWG2fK10+M3r52ey86nNaXuEm2b+NGBi1p2rGT0l98W3Tmdy3K/ckD0al84HSALYaCDQjLz0jLI93zUDMpU3O7QdyANIOyHtfZfm6zGw6+X0OP3NFJmAyELsmqtew0F3yu6yAwNO8sGEi/1I0m63OtGjnw7ehBQb1DwNF1syYEDfmA5DnwHj9haM8wI3PjS9l1oPGR2v7CubH+L9qQcYPBXYHjJSo7GfmSHPItGIAr1Qa59UJeRUwIfXyViy0MSjGfNWs+Ero+z4BIkhyaZtozTlHdZ12EVgOuMkZCiY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 14/12/2025 à 07:55, alexs@kernel.org a écrit :
> From: Alex Shi <alexs@kernel.org>
> 
> 'pmd_huge_pte' are pgtable variables, but used 'pgtable->lru'
> instead of pgtable->pt_list in pgtable_trans_huge_deposit/withdraw
> functions, That's a bit weird.
> 
> So let's convert the pgtable_t to precise 'struct ptdesc *' for
> ptdesc->pmd_huge_pte, and mm->pmd_huge_pte, then convert function
> pgtable_trans_huge_deposit() to use correct ptdesc.
> 
> This convertion works for most of arch, but failed on s390/sparc/powerpc
> since they use 'pte_t *' as pgtable_t. Is there any suggestion for these
> archs? If we could have a solution, we may remove the pgtable_t for other
> archs.

The use of struct ptdesc * assumes that a pagetable is contained in one 
(or several) page(s).

On powerpc, there can be several page tables in one page. For instance, 
on powerpc 8xx the hardware require page tables to be 4k at all time, 
allthough page sizes can be either 4k or 16k. So in the 16k case there 
are 4 pages tables in one page.

There is some logic in arch/powerpc/mm/pgtable-frag.c to handle that but 
this is only for last levels (PTs and PMDs). For other levels 
kmem_cache_alloc() is used to provide a PxD of the right size. Maybe the 
solution is to convert all levels to using pgtable-frag, but this 
doesn't look trivial. Probably it should be done at core level not at 
arch level.

Christophe

> 
> Signed-off-by: Alex Shi <alexs@kernel.org>
> ---
> 
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index aac8ce30cd3b..f10736af296d 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1320,11 +1320,11 @@ pud_t pudp_huge_get_and_clear_full(struct vm_area_struct *vma,
>   
>   #define __HAVE_ARCH_PGTABLE_DEPOSIT
>   static inline void pgtable_trans_huge_deposit(struct mm_struct *mm,
> -					      pmd_t *pmdp, pgtable_t pgtable)
> +					      pmd_t *pmdp, struct ptdesc *pgtable)
>   {
>   	if (radix_enabled())
> -		return radix__pgtable_trans_huge_deposit(mm, pmdp, pgtable);
> -	return hash__pgtable_trans_huge_deposit(mm, pmdp, pgtable);
> +		return radix__pgtable_trans_huge_deposit(mm, pmdp, page_ptdesc(pgtable));
> +	return hash__pgtable_trans_huge_deposit(mm, pmdp, page_ptdesc(pgtable));
>   }
>   

I can't understand this change.

pgtable is a pointer to a page table, and you want to replace it to 
something that returns a pointer to a struct page, how can it work ?

Christophe

