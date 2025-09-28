Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F15CAC5B0
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 02:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A4E8E0008; Sat, 27 Sep 2025 22:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C508D8E0001; Sat, 27 Sep 2025 22:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66638E0008; Sat, 27 Sep 2025 22:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4B6E8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 22:56:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FFA916069D
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:56:22 +0000 (UTC)
X-FDA: 83937145404.22.80267C8
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E790120007
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:56:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Oad5CTon;
	spf=pass (imf29.hostedemail.com: domain of wuyifeng10@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759028180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ReN4RalhyqYDHTLM2Xmxafnn7ELIZ78nRRZkoXRYIc=;
	b=AmKZiQzt7vlZ0Hjz1ODEy/n2LGdF7IZcpUUgpb5twySQ7LimbDjlZyuLAPYNe8CKIhjI4s
	J6Ufuq8ussREGNMbYDlskBokwlTB/SDslA7246BFXZqUB9+7sedxXYdkaQ44geuxzEEizi
	dSy9d+uBDLxER3JIfylzYVEelQm2xh8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Oad5CTon;
	spf=pass (imf29.hostedemail.com: domain of wuyifeng10@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759028180; a=rsa-sha256;
	cv=none;
	b=qpAEO0BMtD76M0hsC/qpwnoFMhA05FEnQJ+T9z20V9y3408P+8GuLMpJ533Poq1mgEbpLO
	RuBQLNNnD3nChRiBOjrj04+ti5r3Kd9O5Tc02PhOO0bTs5m7+V6R25ncMthao3NmbkN4O4
	pUESP+47X/MKaTAWlsjE9gxvsjzL+s0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7ReN4RalhyqYDHTLM2Xmxafnn7ELIZ78nRRZkoXRYIc=;
	b=Oad5CTonG2nrxjl4e5L/879r+lw9KXelukEMaPk0naMZCFa+YAnxiqRPoS9DLFykw+nreDqaf
	L1SH42XrfQik3YunE4I3AKxdGRRKiDRl7owakId7NmgJj85WxAWyheYK3yG0NfTJoalkpJ7zVHZ
	DgQWvYUNXUMUP9oAzz7qFaA=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cZ8921SX0z12LcH;
	Sun, 28 Sep 2025 10:56:22 +0800 (CST)
Received: from kwepemr200005.china.huawei.com (unknown [7.202.195.182])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D71C180B5A;
	Sun, 28 Sep 2025 10:56:14 +0800 (CST)
Received: from [10.174.184.156] (10.174.184.156) by
 kwepemr200005.china.huawei.com (7.202.195.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 28 Sep 2025 10:56:13 +0800
Message-ID: <446875b6-36da-412b-9281-4e111f0ddff4@huawei.com>
Date: Sun, 28 Sep 2025 10:56:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Question] Is flush_cache_page() in wp_page_reuse() really
 necessary?
From: "wuyifeng (C)" <wuyifeng10@huawei.com>
To: <david@redhat.com>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>
CC: <linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>
References: <4343116e-03d2-45dc-8ad4-12835477537e@huawei.com>
In-Reply-To: <4343116e-03d2-45dc-8ad4-12835477537e@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.156]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr200005.china.huawei.com (7.202.195.182)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E790120007
X-Stat-Signature: 4juucka95ibq6sacp74xzztckcp6xtwr
X-HE-Tag: 1759028179-895219
X-HE-Meta: U2FsdGVkX19Ak0o4LuP/snWkbGyKu4FTY8FDBVX2Qgp1V/sIqHlYjdysqqsrFiKVb9eOK3dgDSdtTF7Swhv+PzpR3jqFirzFoYU2f+ppFuZy2VkOunw2pJHXeCbXF0tt5wZdm+JVckcm8GUGUW5W73PRTYxQIv3CFZvK/8B7x+naWpegcbyeacaLf87MiJXFQJBQVEPzBIuvC5mBM/tOQcR0PRQnGDa86QeGNNkbr7VxLwWdWhEEJgRmNyemwA7zYwGF/5NCh59/Gs4Twmh6y+hqs76A63WEFzfRTwPdwlmU8DlGJXzp3ZZVuJpfm+inyLLkMJzj4cK8Yt3H5K3JpYgltBtRATqNIZUnv9ZooNyucsOqUr5M8ulQWVNKApxVViUs7b1wsCaN1MRufhSG/qF8BWnvksby8IQRUEWzTfhTKQCNjy45YjOZk9mDgorPl9Xsx0qcfxMSuM0kRDaShh5b+1ezQugcw7kXTv7pg1kE7p9zgPr9aFFQahyTgkiLwgkELRUKipp3wQqpsmpbEUdiSzlZs7VMmGYW9EulpoGwDetzDnJuS/yMqjliEe4VHl0ZkhI0p310E8oGHC6kliprNvHY/lXKTEZV180m7/Yv3foscimdG2cs3IJrujHlcZfTcIA2Pt0LYPvIbqcGQXprERjoH8OpZxBSC10jEYre9OaG+JARUD61xFTrRAVc3mjxZ49XxYpwj6lr4bKEqxH40iQotkUirccCs37FeN2GiWhp0UtW6r8jh2TwdzNL1vuzNzKtVR0jpIcY0THNDExmLPq1y6a/KCQqIQ4AmMJADmoB7hrGvPs0c7yv064hAtC692iHOCx0E30uh4mFUjQtVLQCt4tl7npX73gddkWgR1aW6WHuGgVp0msOECmdTA1l+hcYfYPAUFt9UAvPbpwLZLcv82ETcKvBjlrjfJW8Vhyo5t3rx9dz2GqWyxqudrP98gCJkQ5l9nrG/dK
 2ygN6ZWI
 qBOFs/TIs3nrflNTMwh78+CriRP7FIFWJrJXy570mfQbRn4Byn1Go9lRiThG+2Vy7JNl3reiYph6umQ4ijCXojj/d7z0paHgkxKLwIOCLpaKDnmXTbjgT4KEfVlaCwwHB9X+n4sUMLOd8xojNt/4Pv/bN8QWoEDfxO4EBEXG3z2gK82I+fHZny1IWkm3N2vseyuFu32EvSYKwdiwrQa66UpReV0tlT6QZ7BZF6YdLd+9QrgnaM5qBJSceQiz5oOKlUpIC3tc03DBDm9c+tMbx5pagAtNI3onuVENhDpfvYbjY6CPs9gjN/1AUCczOEhfqiA5aClXRIe0AYWQLmOq3xb5jGVi4xazPn6pYGGfMIHqbNMN5ZUINDshsAvaf88ndXmTvd1K1m3qB6el0wTEjTniO/Q8pMt6LxU+eNFFSYi4VcFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have traced this back to the 2.6 kernel, and observed that the
`flush_cache_page` interface has already been present in the
reuse-related logic since then.

It appears that this part has not
received much attention over time, and the invocation of
`flush_cache_page` here may indeed be redundant?

code in do_wp_page (linux 2.6):
	/* reuse the old page */
	if (PageAnon(old_page) && !TestSetPageLocked(old_page)) {
		int reuse = can_share_swap_page(old_page);
		unlock_page(old_page);
		if (reuse) {
			flush_cache_page(vma, address, pfn);
			entry = maybe_mkwrite(pte_mkyoung(pte_mkdirty(pte)),
					      vma);
			ptep_set_access_flags(vma, address, page_table, entry, 1);
			update_mmu_cache(vma, address, entry);
			lazy_mmu_prot_update(entry);
			pte_unmap(page_table);
			spin_unlock(&mm->page_table_lock);
			return VM_FAULT_MINOR|VM_FAULT_WRITE;
		}
	}
在 2025/9/26 15:39, wuyifeng (C) 写道:
> Hi Linux MM developers,
> 
> I am reviewing the page fault handling code in the memory management
> subsystem and came across a point that puzzled me regarding the use of
> flush_cache_page().
> 
> When I referred to Documentation/core-api/cachetlb.rst, it describes a
> typical sequence in a page fault scenario:
> 
> flush_cache_page(vma, addr, pfn);
> set_pte(pte_pointer, new_pte_val);
> flush_tlb_page(vma, addr);
> 
> 
> That is, first the CPU cache is flushed, then the PTE is updated, and
> finally the TLB is flushed for the corresponding virtual address. This
> makes sense: when the virtual-to-physical mapping changes, flushing the
> CPU cache is necessary to prevent stale or corrupted cache from affecting
> the new mapping.
> 
> However, in wp_page_reuse(), the virtual-to-physical mapping does
> not change. The function looks like this:
> 
> static inline void wp_page_reuse(struct vm_fault *vmf)
> {
>     struct vm_area_struct *vma = vmf->vma;
>     struct page *page = vmf->page;
>     pte_t entry;
> 
>     if (page)
>         page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);
> 
>     flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
>     entry = pte_mkyoung(vmf->orig_pte);
>     entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>     if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
>         update_mmu_cache(vma, vmf->address, vmf->pte);
> }
> 
> 
> Since the mapping itself does not change, I am puzzled whether this
> flush_cache_page() call is actually necessary.
> 
> A similar situation appears in do_huge_pmd_wp_page(), which handles
> huge pages. When the system reaches the reuse branch after the relevant
> checks, the code looks like this:
> 
> reuse:
> 	entry = pmd_mkyoung(orig_pmd);
> 	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
> 	if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
> 		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
> 
> 
> Here, flush_cache_page() is not called. Instead, the code relies on
> updating PMD access flags and calling update_mmu_cache_pmd() to refresh
> the TLB.
> 
> So my questions are:
> 
> Is the flush_cache_page() call in wp_page_reuse() actually
> necessary?
> 
> If it is necessary, why is flush_cache_page() not required in the
> reuse branch of do_huge_pmd_wp_page() for huge pages?
> 
> I would greatly appreciate your reply. Thank you very much!
> 
> Best regards,
> [wuyifeng]

