Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074EDF34C4E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49BFA6B008A; Mon, 13 Apr 2026 09:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473696B0092; Mon, 13 Apr 2026 09:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFC16B0093; Mon, 13 Apr 2026 09:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28E986B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:36:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7A09B42C8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:36:00 +0000 (UTC)
X-FDA: 84653630880.09.BFD2B40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC4DD1A0004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:35:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O2V2Ka6m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776087358; a=rsa-sha256;
	cv=none;
	b=2LUo91iAIBpc6jST3554mptSyLj/bLPPYY3Na5Lv7fHNWJtetsI6M4iWB+q/p0SMSI72RR
	QDH4aG/2tMIw7M4xfzhycQ3CJYVh8PluA1bMU1d88SjMq/5UKSN7eQrrFbz50NdaVlareO
	LZlHyviOBhfyOaBKoJqJwhZrvwp2TIw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O2V2Ka6m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776087358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrjpwvB83N2giVKGPFKhc5pvsj2/HjIz0wMXzQQvs+0=;
	b=VpWsMLlUMZo7qU6remXFvaT/cr520y6xYEBXcxj5JBHHsNMe93Rhp3yRdNqoCM736kS1ef
	hXkDVEI6j/VnltfncqW63vqsRiq97XMRDiBzDTBOunoTS4rTbUA3roSYOZZeZcsmBmFXfc
	EzLMQa/liF1xC2F6XJa6jkCobLdNCBs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5F6B437A4;
	Mon, 13 Apr 2026 13:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C5AC2BCAF;
	Mon, 13 Apr 2026 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776087357;
	bh=xRUAWLrLgzwCdGi7KEt4++j4ZklzOjG8GAiY3yBRcWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O2V2Ka6m8t7FhRSXO3t1Sodi7if2bOG/BstBJVrdrfAs77AHjkdBsdh1wcEstujtW
	 Pcv7UdqWAunyHp5xXBxNMQs9y3ZS1HBnJVMlWhs2SvQufE4uoI+Z5jzyqROACi9P5X
	 lx++2pz+0BMA4WBx7xBvVjRH9VAoWX+31ym0QCr7BSAWjYzt7FsN1Z0cXHpY+1FoKx
	 m2wGoVRnNcyNhZOoWASweYAR0GWveSxc0LiIsAHiSBZGyv3EkHwkJYrT6PMTSRyZTI
	 n7uFaRdKk6ZmwtE+nRnDTtrFJQh39d6c8O1NVYd/EON9R+VMcZpuOay6ljEbqe4Ebq
	 Fvdzgcgm2+j6A==
Date: Mon, 13 Apr 2026 16:35:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Liam R Howlett <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on
 memory hotplug error
Message-ID: <adzxNAa7RnUDrykW@kernel.org>
References: <adzb5o9aWxFWphRK@kernel.org>
 <8AEA6BCE-570F-4095-ADCF-9699BDE0DD64@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8AEA6BCE-570F-4095-ADCF-9699BDE0DD64@linux.dev>
X-Rspamd-Queue-Id: BC4DD1A0004
X-Stat-Signature: 4ys376xxmtko37mkk4a768d79i1b18za
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776087358-766479
X-HE-Meta: U2FsdGVkX19TjRa9Scx88z271xvA/CdoDwN3uyUhjloGmQhao0RzOYf3YInV0sNFwuG874CXi3r72iQD6pECpJNWtitqHy3bTYQUnLpldgSHcz25yyItC380tCKxHqmfr9FqkZyjojm2ePbfI8S3YXJDfYkE98Y/bId1rEMpfUIU+rSBzQfE4NXMY4BWEdKCr1aR46+EsTekhnNBYq71Lfa4E3f6Faa4XA2SoLoLjP6NzGe4cBnpfuDJm4PO4UXeQ0Ww3VkQSoO9dd9YrfpheLHeZ0Z62feuiTk3bC55/VBIbcR+OMnx/1jbIJuAgL8iN+i6Sab+rIQ2t3yAjPeB5NGlmbUvH9v9JBxHrzzBA3H6Q6eOOCHDnODAbiw5mSz8lJojuzlEFiJ6dFpVZPEfVWBwKo56hGZPS9h8j2uGAD2FfuQ4dDztnVQ66PwYJQWxp2dCwc8kUmRPWSZI9SlL1J/tM7pjmX9k8nnF7dbZZCMPc6GFBFLSNBuBUCaxoxnkKLrW2ylZk0DDWaRiQcWVsHM+r99JYNemU6zeP9Rkos9XdgCPK9vsrkrV714N9uThA3um7mefwRFiYP1QzjzYA0LQULypUcrZTMXD0SBI6MhvmFcRcWVDgzxaaJmDplRi4Y9yn/Eb7dUmlH5B+qJsMxtXkHngeseT5cJajE/LnHa9R8j0T6Tzsgi08y++tuL57ghr8x054e0AW7GLuEMDGWG8TtRZnM3RSRfjjFvgrtVvc4blouuZ2TcQWm6ge7PsMz3CzLPT9oEloLo7n3oJEl/dQKBBiy+zUXVLbkREeZE6f23fUeOPy50EvfPAb/0JSXrt04jMkWaR/quIBrVB2IfO4U+mgEGTGlAvF0pRvfccXcdWrYzhS4ot7+/MBLhq6jUaZVbBKu9Gv4fntKvYEmP7zKhMsmpowiS/pRmWc2IqMVEF2+ZXZBktRLnu5HBWFbH0R3E4dx2gsKKyn8M
 EH2SrkG7
 XdmdtNWYpxIuMDxFTvQFvF0gEcKetiG61VzhjixepqsXO9QQhHP1Xb3EJYtA0BHDIDEKYd5H7vdpMWbVroLYEOE/tjPzfqPHWnYYMRW+K1egtwzbrTDsdW9V1HQwezwPkwaP1Tx1mdNeMwpfS06gtZIRmPXj1JvwERhzYTt4QaL8T30BmRtXDBZoYD2XIqC9Y18vruNSUe9TbTcYvOHsabz4RcLUNbcfAEIYdFJlgKWusRF7EEw2qY0pWWMgqFE3hC3x6taoMA+FDOINJ8BzRs9c7AzxCc4+TA4GQ2hH7Qh/lneg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On Mon, Apr 13, 2026 at 08:47:45PM +0800, Muchun Song wrote:
> > On Apr 13, 2026, at 20:05, Mike Rapoport <rppt@kernel.org> wrote:
> >>>>> 
> >>>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> >>>>> index 6eadb9d116e4..ee27d0c0efe2 100644
> >>>>> --- a/mm/sparse-vmemmap.c
> >>>>> +++ b/mm/sparse-vmemmap.c
> >>>>> @@ -822,11 +822,11 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
> >>>>> return pfn_to_page(pfn);
> >>>>> 
> >>>>> memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> >>>>> + memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> >>>> 
> >>>> This logically belongs to success path in populate_section_memmap(). If we
> >>>> update the counter there, we won't need to temporarily increase it at all.
> >>> 
> >>> Not strictly related to this patchset, but it seems, we can have a single
> >>> memmap_boot_pages_add() in memmap_alloc() rather than to update the counter
> >>> in memmap_alloc() callers.
> >> 
> >> It will indeed become simpler and is a good cleanup direction, but there
> >> is a slight change in semantics: the page tables used for vmemmap page
> >> mapping will also be counted in memmap_boot_pages_add(). This might not
> >> be an issue (after all, the size of the page tables is very small compared
> >> to struct pages, right?).
> >> 
> >> Additionally, I still lean toward making no changes to this patch, because
> >> this is a pure bugfix patch — of course, it is meant to facilitate backporting
> >> for those who need it. The cleanup would involve many more changes, so I
> >> prefer to do that in a separate patch. What do you think?
> > 
> > For this patch and easy backporting I still think that cleaner to have the
> > counter incremented in populate_section_memmap() rather immediately after
> > it.
> 
> Hi Mike,
> 
> Alright, let’s revisit your solution. After we’ve moved the counter into the 
> populate_section_memmap(), we still need to increase the counter temporarily
> (but in populate_section_memmap()) even if we fail to populate. That’s
> because section_deactivate() reduces the counter without exception, isn’t it?
> Just want to make sure we are on the same page on the meaning of “temporarily
> increase”.  Maybe you do not mean “temporarily” in this case.

I suggest to increase the counter only if we succeeded to populate:

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..247fd54f1003 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -656,7 +656,13 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *p = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						   pgmap);
+
+	if (p)
+		memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return p;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -826,7 +832,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
 

Then we'll better follow "all or nothing" principle and won't have
exceptional cases in section_deactivate().

> Thanks,
> Muchun.

-- 
Sincerely yours,
Mike.

