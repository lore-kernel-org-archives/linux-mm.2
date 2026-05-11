Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B572FCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76BE6B00F5; Mon, 11 May 2026 10:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00556B00F6; Mon, 11 May 2026 10:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA11A6B00F7; Mon, 11 May 2026 10:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A41626B00F5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:47:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE41716014C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:47:55 +0000 (UTC)
X-FDA: 84755418510.25.A292C95
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2AF5BC0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:47:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i0bSWCXA;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778510874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfR3U2d6Rd/6gIydstfYEs6i0NLkEBQ6d0p0pnkzOKQ=;
	b=mFjZ4oUbAHYUvxM5o82i1ubfpHA0WMRoBKqgB4ruyIbgu0z+Tx8jXSufq/l/VCWi6J2+jQ
	fWBLykf8KTqNNaxQJtvuryKI3dVRocjmwex+8jnKDXiSmry5jh2xqgyJcMF5njrH9D4o/2
	ZLplMOUnER2Eq7WhE3PXlWSmtDkgkGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778510874; a=rsa-sha256;
	cv=none;
	b=oVGrCOPmdtDKV6QQyXFnEyHphY8GDqTSMdEtqaahLW7HBIQnu4b8ZvL66wzM97KJd4mwGk
	6VoDZe2ZOt7x10oU2yOrP1rg0TNmexZpMStzSFZmSrV/0xvWZ+wkTHZT073vDlLtqXWGT2
	v/8EcZscF2QgvBk1dvL/E8QLf1K5p4g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i0bSWCXA;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b74b460d77so43857216d6.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 07:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778510873; x=1779115673; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CfR3U2d6Rd/6gIydstfYEs6i0NLkEBQ6d0p0pnkzOKQ=;
        b=i0bSWCXA2HVN32dtMIQZ59b6oUnOOWBFlYmDHnh2Mq7AFJZuDrFwDaGwb1Ij8ADTSl
         PLFk1/TVB/HdA4AGYGJdS14E2PPR+ENr57zM2lEV9SyhXSMOlahRXB1Wwx0yU9fS9neD
         /F74yCiov+CtVJwAGh6PZW6WdG9iUAtgBYWFaYsLPKOe8RhN5NH4E5XZER1Z9JncfUcv
         UWc+vE0meHCezlLD634nll3MGDYVJt5m38sXoxAcltXKgSEIwBAcWWaN7jIKcdPAcWxj
         q5XvyKS5lVRz1p44+IM2/tajS5qxXN0VC9P47gvYCePrpQf6cbeoBV9JMPIZztidFH7n
         qhEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510873; x=1779115673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfR3U2d6Rd/6gIydstfYEs6i0NLkEBQ6d0p0pnkzOKQ=;
        b=CQRmOEvBV0NezHQpMr0sS3GD1nsMvHoyXdSe4ED9wXb4HIFikQpLvZ8Q7+8SI7maqL
         q9agt+Y4zk6r4RmAvMP2KHWNWGZY2biasD1u1Xi++2gsUlRLU4dL3+M9B9+jqoChimx8
         3U72IFGJ2z7cr++Qps32WUw2NRD4yjhOCU6xAfBbesjxaOXT3YHzz9X4eQO6OWlK03xO
         MWNo/IhFVfGXb4zsufVKG384PnJLiW+IpSXDZj6dLMT1rMhVWYgotzywOwxEwqVb2Fgq
         vRmbr3qwfF1VHiLuqVGg3S9uPevwlKExsmNW6OivW2Cc4k0qp52iZmv4WXuD0C23kwit
         OMpA==
X-Forwarded-Encrypted: i=1; AFNElJ8mvu4HnrJNivac/ZlHHix32lX8app+2QHLCmo1ZH2DoO8JBtr9XDEQJwzIejeEI64c0GHdRKKQeA==@kvack.org
X-Gm-Message-State: AOJu0Yx/rmV1MGrzj3cuFnqkbKlcg7l3IinhyIIbERxp1cUrSZi/U7jP
	KoXRT3ysS+gMlqk3V+8bSNhNgihZTjHTpabHSDIR80rWG44OAXXwvFqGhLlPvW1JaGo=
X-Gm-Gg: Acq92OGych2B8Y9GeDuLo2hI0aszuLyHP/KCnJJXDvyKS8CMV/iTzkSIX6Vw5hsGKi9
	QEWMsIRizoj2fIJY47LK98WWW6OOk0xToHkhoCHHEk2OjPDtl+Q5X4PD/WZe96GRJBr+L4HzCTL
	8u2VXgq2sG5MfdsO946rub+JqjhhV5I5BqNdpuiqwI+l9epPjs9LaXgvzBs7vHJXx96fKBeKsba
	VgOR9DpDKF7pIdIdJdwFyNnl5PfdGdB9TdDHqUKRg2fJyV32a2Y9tspO9Sbn4pgbvl7SYR03cr3
	2GD6PZIqWje8LyBNbZC0db8tMvQZQOd/qTDGsQz0bho6KVmKo6z8xP8xoOBxW2Bzk4M30fAm2SU
	sVJ3RyWPMt7HIpOqseHIeyFDlas6xi4NZi8cM0LdmOokBRGt5CJ65Ww958bje1xNovUVWY1wEB3
	SvQxBAXlz5OBq7tmdUoiukxlHp9U3CkvqXWu0SUjZYFilBv5okxS17cKCv1pWITYdz2dGBhiXiY
	o5k6eJjXinGmnQgLvPXk1E=
X-Received: by 2002:a05:6214:c84:b0:8b0:2d20:ff8e with SMTP id 6a1803df08f44-8c1a4712947mr154948486d6.25.1778510873086;
        Mon, 11 May 2026 07:47:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8bf39c82420sm105832246d6.33.2026.05.11.07.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 07:47:52 -0700 (PDT)
Date: Mon, 11 May 2026 10:47:50 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH resend v6 01/30] mm: move vma_alloc_folio_noprof to
 page_alloc.c
Message-ID: <agHsFsEIU8b9RiJr@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <a26c5850219e349f8a666282aa8003a82a4819b8.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a26c5850219e349f8a666282aa8003a82a4819b8.1778489843.git.mst@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2AF5BC0005
X-Stat-Signature: nz7xdrrtt53we81b8qrhqmb6krsujhf9
X-Rspam-User: 
X-HE-Tag: 1778510874-65168
X-HE-Meta: U2FsdGVkX18siinTAexkeqRCoU7HnohEABy2EFovsHrNE3qtwGUwfQx4dEfLbvWM5aNKIQF8msI+6exUBNtbs99ewdjAla3Suy29Xz1YWhFmmLaWWMoK19s5mqszIjG63QnOM6hWvnVcCtDIxiDatUdGljSAFNCxwVUZemAUwsjMSs9BpJNActt9qVaQmWoBaefYwOHazsJT7bqvyHKxiUFgTqb12PELAdrELPg8RYu6lc87XdolP3U1eTqT3B9cFlXlFsvDJDo+OIBRH7BnzIqMxJRr0cGQbSFIFTkc2OUqBwzuz/vqr43mcYYvEjZLaF2ivSYDLwL0o8WEsmbFFf8BstpFYZSvn6Ep4r5Gaum78j0/K8byDi+m1xy4qb5jItTV+rcOUOkCFf42jDuwWG+LPxIqY52VeTHOtr7U8ZfRhv1ELatvVVYTGvR9cJsrv7ZEBh0xJClU2gdhhP7H9B+ZbitmA2kJzD8aXICE+2jrqFG7xOy7MkeArxHrpkK5LW5mm6DVXlZOG/lK0dnD+PExaE3OGgB3i52dofB0WEBaTHt7LK7GlLBjs9aHjvRtw9J2rStJNOqNPaaYR2ZiUk1JOFcyG9d0qsUMcbHvTT8kEYustsvh1zaphcSjeBOWfZfQHxCvFZZQmpz8qCCW3U5otSJEVdRccYfu2MKxY1K3vVZ2xAY+ZaBTpN9HE9DkXdhqpq0Qw6zoVCnPCYmPHlTXzkpmOr4vBdWCPQsi5HaXdT72duwYHUw+ov84wXMQJI53ASC6oBEzbM16XNYkVfKhBsPsbzLiVULKkJOQV39BABsJfMjKk+QeBRTae9WNQzBCLZ8VKTTEweSozGKQC7dP2tPLJihEUFkEs96p0KoGrLze1OkNneecbeSxDDK46aQkvXdFdCKEZtYAyoba4BHHpsKymHdbj3TsPTf/cjUu2nI1Jo2LdTAFVUJ6jza4MvIZg8F472+PnVDYQTC
 BxE9z+P0
 3Q6zbGNCYElSK0rzLCuZGwflR1Vd7Y2Ta/iv3YO9/j1xVnMhnvbMeQXCogXkEAkwlUEqZfwxLidwCPj5A6C3TvOg4ilqilaM6fYEBingY1ecQe1p7tSvMLZP67gJwvvyEBOVV6OsOhF/WltUI16Yexylt9IJ/+djQVjxSb0Zuph7Xc6zY3tHk/QolrIiJDLwOKtdtmYSudI5A+Awq5RdaTcCuIxDrDL2jWskHvTDHmmZpuJEn6mK5eDL/pG3N+2GIoRgM9/fuizDoUtUmwQFRdTxB68olkrO6r4+w9u7CxkN9/thCiHEvaAY4NVs7NywiFdEV9+n5yoyNG/53v9WVGm02BY0qrdzAsJh79qgx7cB6CoUH2upDnaf6BX01yXp4EL7mPBporoSVMotMRWzWw2t9TLI9AYl6mkmi7EGCUfMZYX5qJDy14wdFx6mts0udFpZ4dA2w+cxJUKZZPeV077dZREF4+847afDrckyu6OBzm9qH4Rt4VTAIhLzZI66np+3aJt+LnTMqwBKD+j5rofSArqyokOREKrRs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:01:44AM -0400, Michael S. Tsirkin wrote:
> +#ifdef CONFIG_NUMA
> +/**
> + * vma_alloc_folio - Allocate a folio for a VMA.
> + * @gfp: GFP flags.
> + * @order: Order of the folio.
> + * @vma: Pointer to VMA.
> + * @addr: Virtual address of the allocation.  Must be inside @vma.
> + *
> + * Allocate a folio for a specific address in @vma, using the appropriate
> + * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
> + * VMA to prevent it from going away.  Should be used for all allocations
> + * for folios that will be mapped into user space, excepting hugetlbfs, and
> + * excepting where direct use of folio_alloc_mpol() is more appropriate.
> + *
> + * Return: The folio on success or NULL if allocation fails.
> + */
> +struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> +		struct vm_area_struct *vma, unsigned long addr)
> +{
> +	struct mempolicy *pol;
> +	pgoff_t ilx;
> +	struct folio *folio;
> +
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		gfp |= __GFP_NOWARN;
> +
> +	pol = get_vma_policy(vma, addr, order, &ilx);
> +	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
> +	mpol_cond_put(pol);
> +	return folio;
> +}
> +#else
> +struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> +		struct vm_area_struct *vma, unsigned long addr)
> +{
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		gfp |= __GFP_NOWARN;
> +
> +	return folio_alloc_noprof(gfp, order);
> +}
> +#endif

Can this ifdef not reasonably be done in a header?

I know the old path relied on basically mempolicy.c being in/out of
scope based on CONFIG_NUMA, but we should make an attempt at keeping
page_alloc.c clean on this if possible.

~Gregory

