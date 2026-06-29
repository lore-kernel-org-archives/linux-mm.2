Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8FAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEC76B00EB; Mon, 29 Jun 2026 14:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6286B00ED; Mon, 29 Jun 2026 14:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104126B00F0; Mon, 29 Jun 2026 14:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5D036B00EB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:47:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EDC58CC0F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:47:43 +0000 (UTC)
X-FDA: 84933834006.29.FC79152
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F493160003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:47:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GcSEKVgt;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782758861;
	b=LAbYpHkYKFCfP3GER3dp3MSZl1xzGiTM8j80co5Bq++9DYziuqb/DvjmgwjC6cSSSkXo0p
	3gTnPdZKafvrtKBpQMLYkf1JSEWENSMw46NEWndwHPErIihxcHpKw9rYfToMfIK+xpa7Pq
	7ie9TgYODRf1ltWvNqhF3+bWeHG6w/0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782758861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ysXCP313kAdt03KShf1kvSecozhx/22zS/+otoUNAg=;
	b=hV9L+QdZg65Ok3xaPkl2kW00hwLmBG0zSeT390ZAL9posOtcAjpCpiKoEUSlXd/XxqR8FQ
	LESlUcj2nXknZKVaT5EG76YIjc35ZMMAUF4BEo31w73zK352XmydlDP76bXfuZ9CaIPgEl
	kblxN2h24K/rFwTYgXdfSIXH5HQVjMI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GcSEKVgt;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51bee804d15so15780151cf.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782758860; x=1783363660; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ysXCP313kAdt03KShf1kvSecozhx/22zS/+otoUNAg=;
        b=GcSEKVgtjuNCoUmK+Eei7mrmQmkUZhDSzbijcoEUQPoDJGQbfbUukh4MZyFm3Ej4pc
         /1WdWMo1OG8swhtTCHrMcofJvM9UxBbuIj0m/rYT7e/mn50WdsMf22n5bXCvHcJbQdUI
         paQVs3Xz/u2/L9s04SW4TUltYgxgDMF3+bKgv77ikhWG5jiWSWC/5gzaHUoqHBNnJOwA
         f150HT3tdpKl4rrjfT/vxMQRVqV9VPUAonkNx9BLbTSG8FvlWEoZZBYqJeFVGVnB54b8
         I1LSAfuubZwUYJfPoQtllXfvVV6crIbQXm7V83BEjLRXvOuMyQAfRgCy8bWYouTbAGWJ
         40Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782758860; x=1783363660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ysXCP313kAdt03KShf1kvSecozhx/22zS/+otoUNAg=;
        b=Py3Wukgupf4eH/E7yfeEZeYVgOo3wt1tZa+F2kLhvDezj/VScGbliJOQKcclXP1/pS
         fOt1K9FQTXN8f2ntD7iTezOmMHKqrVQ/KCm5AP695XK23MH615RO2D77vJfCmSLMhl0y
         VFWydlTjMJF0izboXLf5M7gAQAfrdj7FhLh4LIXXoFtZmObr4Hg1oVSgUYPevKb/cU6K
         S7d5vZWG9c+y7SNY3EwYJglBmpd17CWxT64KURLUTy3RpTBzQ0Avxy/+1sxCNEa6gjHv
         GbF/fcLaM8IXvNt0hq9lv3rSe/1csmKhP3Z/N8dvpN0xulTLIxrVRS6uAG/RP3zMp/tY
         cKog==
X-Forwarded-Encrypted: i=1; AFNElJ9lC64OkpvxE6npOfPrZ2KnuTf15yepelLfE4rDyljSBc648DysfUCuX1cYXyN6b4bnRfPXfW2Z6A==@kvack.org
X-Gm-Message-State: AOJu0YyBouKkBQsUoP+SmE9uWj5nEqvWCTQoUc2TF+/vhBT+9Vd9Ok+s
	9vMF149WFmChbDr9bJqwhbDW6cj/o79AxSDBJlRPr7iuMCIAKy9AvmNKrg5WETKkTbk=
X-Gm-Gg: AfdE7ckjQxETx4HUss/8DuXfzxDWL80ZtIXfoLXw1qFgzCXvb9nDrTQafcGrMR7mlou
	DRUAWUdRVp676T8xQ08ZfJmwe8LS2R4Fyc2f8t5zShwNd3v9obIVGHCKFWrzAmhbzqYMRCSeP5/
	0tl3VxJ+390GuxZbxFouT6ON5/Kf299kmMHDROYlnjVdSiWwLvVRfrp7w0JygIwcbH+re4rRXTM
	R3r+jDgJalwYQ2PFvsZfnMz+laYzNAd3QfNf0HLMifklbtWcX4PzXfqLSUqtIeCHjOfkpT7z9g6
	SIV/k4lElYHed05295QOwgjqrq/mUjY9RojOT3KVk8E6Vcy81juDudc0Qy15McCn/wAp1blWSMF
	b/F87l7Jabj2rlBJD8CAO5GPpOxvny8h5QL8QS3fQrxVXOJV9uc2nJBqdWOpbm2zZBVyKI/zJF+
	h8nG1aEkoTV2c=
X-Received: by 2002:a05:622a:5792:b0:51c:6b6:9d0b with SMTP id d75a77b69052e-51c1072cb39mr7475191cf.2.1782758860012;
        Mon, 29 Jun 2026 11:47:40 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c10862ecbsm2517521cf.11.2026.06.29.11.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:47:39 -0700 (PDT)
Date: Mon, 29 Jun 2026 14:47:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akK9yo20yelJ_M-a@cmpxchg.org>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <e18f075a-2203-4ebb-8f4e-713d386d0ef3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e18f075a-2203-4ebb-8f4e-713d386d0ef3@kernel.org>
X-Stat-Signature: zd593zn6x6ec5oaohxkjqgjpngqeke4c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F493160003
X-HE-Tag: 1782758861-162574
X-HE-Meta: U2FsdGVkX1/DB/V2x4POBkqoKUvJna+uUViv6fxSG0/kAyqzwWnsXhELOBSsVk18fbkjlTbpr7i+j7UjnYU8NQ4Gp7CkYwhHmw6HkKGvRouSc/Z1baS6vl9Yd7YDaoHOqqbPr0zBS7W6LCTNCNU/1yxvg0xCNgiBL7n93pH707CQAcwpqnxg2E/jQBdJAA67J0E4uhqP8nqdrFdnkcot5bpIrB0m5J5OzF6bbXt3PhUhhyl2JHggUp6VXAgph6FPAFe3aen3oyuDyvH07edFc0YswTOqdSODva3Tn1Hn+djBKN2CahYhXi00p4Z3BQiqNFRi4QLAGmA8b1Y5HD5NdLeGB00UasaeJ668wsaOMRiSqTJ/MamNW3PE6brHNwSOJDnFrYofLbXfEcg5RMLEbXF4BEmhxX+PyAgOjcVPD0YfaUoYcdrlSlnaujB1mm00wLXrgqaQanTkEhKL6J+9I7nN7+e/JHh/OcqYAlrkdvRQr66vGCMLhZTWDWxRMeXKlbKPViRSKToJo9YxACO47+PaiAEE0ofNX/i1LmxxE478y4KwC+XJ5DTgznwtltjRsC8YQY1tFwADd9uI9WxKERsAO+XXj0WIE6nNc6VnLUYL2z/6+qE4u4G7VlulejyueH0iOE3KussVmNiI1a+a/mqKIwwl0dEtmySiA8zWYdhUIRjDwcndKgj5cCKy8Drfa2KRaHf/qFqEGkRC7jYxP3ls9kY3RUtBrDsX7oSTjfv00hKpjtxyyOTqTVnNb6VyiqBIYQ2Sy5aAMbyaynrw4aOGULIySeu6Pispx3w/TkliSOxLwxwFgwa8vaRtG0b+IoXtLHCVS6RRCLQSByDwgHYnSUmz7Y9CPAoXargjH88S0+3i62o9F6vN7uXnuVcWA8M0fHuTDVmc59pOO/w5h0PnRgHGG0BK5BiN0V2VTz0gfuAgChheMaATjEwCT2loj705ftEsP+g8uKZy5xP
 UA1hcQfL
 ucT5CvmPeQBWiCtVD4MawUd55AqXQ0mWj7Qlyvf/gZNvuLLOj/x/DXOKAdT9vXJJtFz4kyZCirf6uLhapFfTL7nX7dTrx7jEej8H3vVxL/BX++78+kk3srCUBuI4nm4VGM+5Vkphnk3b9QK+HSSoU+dKhs1K7CwDVpuSi6eBHVRw9fTOqfElCPsFQQ9nk7Lchb9nb+fZqDG5p5zJ6mKLkibuSL2SHmJIVFkTVSJkM4CnpWJopbmGxVTeDd+ZF18egMLID5V+KACL8WV3pd4NRX4xfTmxfriWhR2fLr8OyPuAUCfI65sJ+VXfs2TLT01y1aIGTMoUjTHprYWz3LCgoeHMzYUNkTuCIbUx74EamQX4Co20+WCCY6d280X0N19ciJ1RDwp5LExu4ce7pEL69OHhkn3d0w5q+sbUhJ8/7nNhJhGUwqgEKDjEZE9vVXrOb/zjYQwIoUOreMf6E8ST2CANxceNN9gy+tzLTudsE6m0Pe/c/2L/yb0Vzeexpog5jlnrundn+wnoxQDc8meCzMAkaXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 08:33:32PM +0200, David Hildenbrand (Arm) wrote:
> On 6/29/26 18:33, Johannes Weiner wrote:
> > Neha reports that mapped shmem aren't considered for NUMA balancing,
> > noting convergence problems and bandwidth bottlenecking for cachelib
> > based workloads on tiered memory systems.
> > 
> > Looking at the code and going through the git history, this doesn't
> > actually seem intentional:
> > 
> > Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
> > VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
> > policy lacks MPOL_F_MOF are skipped from NUMA balancing scans. The
> > motivation was a real usecase: Oracle was pinning shared segments with
> > mbind(MPOL_BIND) so trapping faults was both expensive and pointless.
> > 
> > The handling of NULL from vm_ops->get_policy, however, treated "user
> > explicitly opted out" the same as "user never specified anything." For
> > VMAs whose shared policy is absent - the common case for shmem - the
> > scan was disabled too.
> > 
> > This issue is old. It probably hurts less in conventional NUMA. But it's
> > very noticable on tiered systems, where entire tmpfs workingsets can get
> > stuck on lower-bandwidth memory.
> 
> Sounds bad enough to warrant CC: stable?

No objection from me. I was hesitant because it's old, and while these
are real workloads that see it they are hardware/kernel validation
runs. OTOH it's a straight-forward bug and should backport easily.

> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/mempolicy.c | 21 ++++++---------------
> >  1 file changed, 6 insertions(+), 15 deletions(-)
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 36699fabd3c2..bba65898aee1 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2057,24 +2057,15 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
> >  bool vma_policy_mof(struct vm_area_struct *vma)
> >  {
> >  	struct mempolicy *pol;
> > +	pgoff_t ilx;
> > +	bool mof;
> >  
> > -	if (vma->vm_ops && vma->vm_ops->get_policy) {
> > -		bool ret = false;
> > -		pgoff_t ilx;		/* ignored here */
> > -
> > -		pol = vma->vm_ops->get_policy(vma, vma->vm_start, &ilx);
> > -		if (pol && (pol->flags & MPOL_F_MOF))
> > -			ret = true;
> > -		mpol_cond_put(pol);
> > -
> > -		return ret;
> > -	}
> 
> Okay, we used the fallback of vma->vm_policy before (if vma->vm_ops->get_policy
> was not available), which is what __get_vma_policy() does at well.
> 
> But if vma->vm_ops->get_policy now returns NULL, we fallback to get_task_policy().

Yep.

> Makes sense to me although this is a source of confusion for me.

How so? Is there anything I can improve in the changelog?

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks David!

