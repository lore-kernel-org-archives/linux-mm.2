Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B624D715E4
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 18:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207A16B05C5; Sat, 24 Jan 2026 13:51:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF096B05C6; Sat, 24 Jan 2026 13:51:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108356B05C7; Sat, 24 Jan 2026 13:51:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF80A6B05C5
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 13:51:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72417587DB
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 18:51:48 +0000 (UTC)
X-FDA: 84367751496.24.B164DC8
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 56D621C0002
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 18:51:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=o1chr7v9;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf21.hostedemail.com: domain of "prvs=94842e8a75=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94842e8a75=clm@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769280706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cW+1ftD0Dn7OqF1vQTlFaX5dTZfhVWFeJzH1lpwdqxw=;
	b=0hf2hLkRssbiesVAbY1/97ft8dFi5xneVH25VDXmh6h4IhiXfwdkAwE6QDLH4COtfkxFWL
	dXjXSTk67N+l8BzFgNMUghwh0evyn7rEOhNSLdPHOM0ydX1Exo1oErn4wn7daYfpC6leTb
	U23Sop/21ncy5AZ3kJ45eDeDxgfcylo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769280706; a=rsa-sha256;
	cv=none;
	b=r+TPuxQLuq/Fv9U3UeyTpEHFcgHImT5+K+7mUp6f8G0M7ZMu0qy8eIBSVKEVADqLt7behf
	LfiuO1DxOHnoNTArUbgTiVSvCStLP0Gk5jktzoFipjAliPwNkblyxirrVueTZHLjpszgxJ
	KqPQWpqTLt1Kc1QJWXP/tG7raNyTMmk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=o1chr7v9;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf21.hostedemail.com: domain of "prvs=94842e8a75=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94842e8a75=clm@meta.com"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60OAmNx33979789;
	Sat, 24 Jan 2026 10:46:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=cW+1ftD0Dn7OqF1vQTlFaX5dTZfhVWFeJzH1lpwdqxw=; b=o1chr7v9q1Tw
	Dnq9/THrymZWT/c3ZVIC0JNaEoubZZEAiTbnhIFbe1mPiN+iJddGW4K+1A1saN9y
	JGIiN5EWFnfL5UwBoX+1ds7pG94sYAwDjBV52tkREkj7K8IrhZLjEJCc5nMMBptF
	mttAeot9WEsNDr9UCVj6CkhB8Xku9STlCG7iFuGXPch1g7kOutSQFcCZvBR3XJTD
	AskZ2+KKKkhpewfjKQLzAY1spb0F8Y8bOs+ygbYN7aZcNhAJzUEfWZtSnjB+Dj9k
	/J2gNuqZ6FnUrcu+lqlzB68gLdqbYIxOovz31W0zuzNhURjuI7a35BFkmdMMnIxZ
	+RZlER8/Zg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bvvn1j225-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 24 Jan 2026 10:46:22 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Sat, 24 Jan 2026 18:46:20 +0000
From: Chris Mason <clm@meta.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Suren Baghdasaryan
	<surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Pedro
 Falcato" <pfalcato@suse.de>,
        David Hildenbrand <david@redhat.com>,
        "Vlastimil
 Babka" <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn
	<jannh@google.com>, <shikemeng@huaweicloud.com>,
        <kasong@tencent.com>, <nphamcs@gmail.com>, <bhe@redhat.com>,
        <baohua@kernel.org>, <chrisl@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 11/11] mm: Use unmap_desc struct for freeing page tables.
Date: Sat, 24 Jan 2026 10:45:51 -0800
Message-ID: <20260124184555.3936797-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-12-Liam.Howlett@oracle.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::f]
X-Authority-Analysis: v=2.4 cv=X8df6WTe c=1 sm=1 tr=0 ts=6975137e cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=nrObawGzxuk_COoAWlAA:9
X-Proofpoint-ORIG-GUID: GITbP4S9OHpGmi_jCuU0UxlbrxrvKwyY
X-Proofpoint-GUID: GITbP4S9OHpGmi_jCuU0UxlbrxrvKwyY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDE1MiBTYWx0ZWRfX3q99NYI7yFEm
 URREbCwqTH9E/wJRa+SwfPkA739ORfji8LuLRFj8dyKvpXzzZZiJOl6DvYZTFuUZV/A1Kc80h7N
 Ux8wyWW18NHhKM3yavYOEOvHfXkvhq7NeknPrHGlyTnaSozx0TSz83zqxijd7VbRbwJsygKsXSn
 q7FaNj++5Q1Y5jwvwDlpWB3dpBQA4BdRA1AnUpmC8UsytUNhpR/1bHqfQLPJjZtoYrpXM+pPsQG
 P0orOuHlpVEewLBvJ3Bzi6RFutWgZ8pAUcPVVmUE4ZJ7+fFFtPO8uTUO73/BXW6bSAk7gpjCLqv
 TJ5sO+0Qh9uUGeewWi9yuTKktzmkEzv82+1h/S3biVwaWgoNaBni9H4dYmT4YyNhYOZntumY6hl
 TIbuh/QmlSm5uz/DkgQIzKKiJnouBFV+UpjsLD+3cmoCla+V0rozH0sjMKjp+PrOizBHCZXt3ZE
 kcTE3wGxK8YRGIgLkhw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_03,2026-01-22_02,2025-10-01_01
X-Rspamd-Queue-Id: 56D621C0002
X-Stat-Signature: zw4685kmup981th461qxep8py4zc7tjr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769280706-368200
X-HE-Meta: U2FsdGVkX1/5dHkBkVigHeMURdZL/DH7oBhxcU85v5hb6zIJSdiin3NMZ1P4NLwU36Ml8TNrsyIXIPmg5AlXFXL8CNoGHaQ53Gcv3boL3KIkKivI1NgqKkXpgnW2aPmpbFTKY9kwyrr2sDTpL5pFY64XSFP9zH2S4jkDpQE8Ya6EvwZ5qhA93vPh6Orr7h1//mCyxEK/9uodXmCc5Oms7v/Csz1rLYpzK0hIbHSQez8/23eEFNBQdjOE3DY5R0GyyS4mzFNnIeFEaD/3ew500+uM5AhmPGIOEeA8qFi+ZEflrmzPokOEfZXf17b2/xmep5CMF6r3KinQoyhHy454C4w/DOX3ZAQRNzAFoYAebo6erGsrcCYa1XAevIOrTidYJqvawNUJmymA8PabPMENmTJWtV6p7RtVzMXfcujxo8V34MyxOzZGm11PKagDszVYAjNthvPYKWrvc9Rnp+Y/DxB/f5pS3Zon1V0h9eSYMbMfAtZYfqObIUUbjk3CSY9NvTy+A4J8i3FqjJw1GZFC130/wjECQWsgPUPzedz7lLtoxOXCnGexzzxFkeR231CqQwW0L4dYPJSAKoqEAtrXmr8uHKFXzpD/Ovy0sZurBKJy4q1derZc2lRzslNrC121gRpqbwSxCwEnCCPupMfwLVl3QzlRay2P+//tKOYR+G3EhRKEy8vhJOYdAAqPNzZRabnRrzDtXWzIMhgm2ImBAzaFnI+bo/UYeI22R9NUkaXOOPCy7lGm6FOf6v6vOPZNE9d0Co9FXxpEUe+r4RuSkoM00umIXRnzYaTdHhMpU0SoF3Wa5clAGU4fkDflqcbIa5nd6qurnZlRv+pNPEIgBM3PBP0bM3Lk9OSLjyCl2+XyR5wQsPx0uf/T5fjbzhQSOKR96vPrRqVQg43YSJBgABvspWkHNY/Oj4wlzQuULsZx6hg+FN26G2oW2gfOgyKA54skbNGRXJ35KVEf8qH
 txQYJ8fh
 EHZM22zSv1PURKsy/Yqo+lzlSLZDFBy+yMR/+BuD1BqgcTDRqrMN/+pXdv6GClFz9WGJCec1nnrALnJmJpcU8RLvrowzDUsYAUplTYgAa4kf7CT3eD2r7LzsQ7lMzB168Vw7kZ75st+1cMBLX91VaRszwTzfjP60y+7EuyxyMu07D6anrVh9tS5VjUwyThRxUEhABuXr99eSiHE2D1g7C0c1Rs9C688t7NmWu9sHo3woWGrDsIzKOlEOOPIG73GCbB7fjGBYVcNaRZTp8hUg8lUQTm85Tm9aMn4/pjql/21OJJfBQd8hVSFo8GqGsS6ukeTgauoCMr1q0XmibnEzBbx7JXk6Lo/mb9UpAqZzFvPIzkhf0m9S9WkV8YdNLTdpBDiZl0E6/8jt/zkaH0WSqogy2L4KXW5H6qcoxAJhumUyWWPBHaP4phThcn2NlsbB8FowsJYrdsotOtHuAB9uR8MUFZ9Cx0e4wMOY1ghl6miqVK60lDzCSvAdxVNQ/AaTc/23IlG1Oj9VQplQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 11:49:46 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> Pass through the unmap_desc to free_pgtables() because it almost has
> everything necessary and is already on the stack.
> 
> Updates testing code as necessary.
> 
> No functional changes intended.
>

Hi everyone,

I'm running some more aggressive prompts through linux-next and this one was
flagged.  Apologies in advance if it's way off:

> diff --git a/mm/memory.c b/mm/memory.c
> --- a/mm/memory.c
> +++ b/mm/memory.c

[ ... ]

> -void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> -		   struct vm_area_struct *vma, unsigned long pg_start,
> -		   unsigned long pg_end, unsigned long vma_end,
> -		   bool mm_wr_locked)
> +void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *unmap)
>  {
>  	struct unlink_vma_file_batch vb;
> +	struct ma_state *mas = unmap->mas;
> +	struct vm_area_struct *vma = unmap->first;
>
>  	/*
>  	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
> -	 * may be 0.  Underflow is expected in this case.  Otherwise the
> -	 * pagetable end is exclusive.
> -	 * vma_end is exclusive.
> -	 * The last vma address should never be larger than the pagetable end.
> +	 * may be 0.  The underflow here is fine and expected.
> +	 * The vma_end is exclusive, which is fine until we use the mas_ instead
> +	 * of the vma iterators.
> +	 * For freeing the page tables to make sense, the vma_end must be larger
> +	 * than the pg_end, so check that after the potential underflow.
                           ^^^^

The old comment said "should never be larger" but the new comment says
"must be larger".  The WARN_ON_ONCE fires when vma_end > pg_end, so
"must be larger" appears backwards?

> +	 */
> +	WARN_ON_ONCE(unmap->vma_end - 1 > unmap->pg_end - 1);
                     ^^^^

On the exit_mmap() path, unmap_all_init() sets vma_end = ULONG_MAX while
pg_end = USER_PGTABLES_CEILING.  On ARM, USER_PGTABLES_CEILING is defined
as TASK_SIZE (around 3GB), not zero.

Before this change, exit_mmap() explicitly passed both vma_end and pg_end
as USER_PGTABLES_CEILING, so the WARN_ON_ONCE would never trigger.

After this change, exit_mmap() uses the unmap struct from unmap_all_init()
which sets vma_end = ULONG_MAX but pg_end = USER_PGTABLES_CEILING.
On ARM this means:

  WARN_ON_ONCE(ULONG_MAX - 1 > TASK_SIZE - 1)

This would fire on every process exit on ARM systems.  Is this intended?

> diff --git a/mm/mmap.c b/mm/mmap.c
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1307,10 +1307,10 @@ void exit_mmap(struct mm_struct *mm)
>  	 */
>  	mm_flags_set(MMF_OOM_SKIP, mm);
>  	mmap_write_lock(mm);
> +	unmap.mm_wr_locked = true;
>  	mt_clear_in_rcu(&mm->mm_mt);
> -	vma_iter_set(&vmi, vma->vm_end);
> -	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> -		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
> +	vma_iter_set(&vmi, unmap.tree_reset);
> +	free_pgtables(&tlb, &unmap);

The old call passed USER_PGTABLES_CEILING for both pg_end and vma_end.
The new code uses unmap_all_init() which sets pg_end = USER_PGTABLES_CEILING
but vma_end = ULONG_MAX.  This changes the semantics of the WARN_ON_ONCE
check in free_pgtables().


