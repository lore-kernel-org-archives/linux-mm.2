Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F1D606A324
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LTMtLJmk
Received: by kanga.kvack.org (Postfix)
	id 5D8226B0973; Thu, 22 Oct 2026 11:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AFED6B0975; Thu, 22 Oct 2026 11:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E766B0976; Thu, 22 Oct 2026 11:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4B06B0973
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:27:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85E4A14019E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:27:50 +0000 (UTC)
X-FDA: 85350642300.01.E2E945B
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 948A518000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:27:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LTMtLJmk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792682868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Hxj+A00cR7R2uHGcUSbmEOS3DLzDMNRKc/7icWTlNI=;
	b=2ci5rCZ2sUlVUdi1pwCR8swTkWazvQMJn/TDrsz6uteyVMPgHAAf1xhkEtcqtYDRVz5EZ7
	sT7AX+9JOgziEunU4rzlwwg8XFx0uq64Bi/zjq0XxzSwCwjQMAVfNr94eTkK5GnS8zKCxZ
	RNjYAc0SPuJQGV1W6m2S5h67k8eVII4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LTMtLJmk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792682868;
	b=jSgqOie7USzaCNLqqbGSLjS2hAvyGD3DPXZUZ/NN68DfLTy9b1JFxj2g8kQQAqckBrxCgx
	ofBNhUkbgcIkHTiT7gj6U2QeGMCZmz2nUnx5P1Io1rNWL7N+zimCwOMkfFa+INVRMxQNFf
	KhtKSA7GCOyk5w+uLWitpWpifnfZv68=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso283508766b.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792682867; cv=none;
        d=google.com; s=arc-20260327;
        b=sfbdqwRHqrwNyMLpT/MaO1g8U+/aArnfO+jawTyioMi1y//WdAihJhSBqJnRtJALVH
         JR0ZSRLj89pEV4GH7BOQcAb7gHThcKKgPUZQCH1khH32SNMZkS9SDVz0osU7jfmj+p2o
         68B62vs0sYWGsCjrevvnfRUiNNcIcEW5CD4Gb54ff03wrpuH3HGi30OKH5H8RJSiUJPk
         UT+og0M+CoemK8LrIPsvNu44YeyqPrbzDCXhhxu1DoJbMneSBPv+AwZds24xuD9tJdks
         cf1Vo//MnEt6sbJ2z+qsSMu4oWDTKofdQ/qdXjC9OzPFDFIy2Vt1qDbjjAxLWQGdtJ0S
         fdyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6Hxj+A00cR7R2uHGcUSbmEOS3DLzDMNRKc/7icWTlNI=;
        fh=Wd+1CTCmPLXb9cucQRcN336/lLE05wBnTxow7ZcgnhM=;
        b=LqjAJeqU0HJikfC3qtKlWLZMonlBCICe2kA1gBN8Db1SbVTOtl5TH6TO/TG5d9KOuG
         OtNxR6da3aRtn7h4Hbf1znFjHK7eI5Pz7SeAFWLJoOeYT6UI8Zbv6mKuqwDrlXGLXcev
         o3dpYFK/WfAykCPpcFcOPKeb5ld+GhjVUDcW5D9xrFwFEp1/zSMCp7Lpf81uLmFTD533
         pHnTr2A+VeqrH9EGbs2wsZFSmHfGU0UqUcMEGWkUgKANPSckT9ddaBm4G+jQhk1SU1xv
         ub2y8I4RqFnB8xOC9eh2j8RN9x2vQUDGFY6LOxF1XN6qfluSFdLI8oF4bVE2Bk1nFKvP
         fDFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792682867; x=1793287667; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6Hxj+A00cR7R2uHGcUSbmEOS3DLzDMNRKc/7icWTlNI=;
        b=LTMtLJmkTngeDfYmUBN/X2BXwzAIa0stT/V9HRcR3BVR5oxGXdlxaQJedlQsSb31sw
         efC4A7cigesuR6YPRSLreNhQE5yDC80G9Jrbp9Uh7MnXPDDGrHyUOUwxaitA1QB7hlcd
         f0qqG0QxJAXwRnb1OhRjFO5Tx0nPQ/YtHG+WA32Dyj1hFq3CgW6jn5a7Z0tGp5Rzsp+b
         a1GyTRhrSn+N2DBQgQCUSQg9f7MWXETyszfl2sPIs95vR2qlpZF0h2VIQW7o0EzGOoZW
         gsKiMEaMG0siQHuvDQKPNgnQERE3RHk8tOzmXQYGKQ5C+eNLHiIZeI98NsNLwfKT0WP8
         BGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792682867; x=1793287667;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Hxj+A00cR7R2uHGcUSbmEOS3DLzDMNRKc/7icWTlNI=;
        b=p/aKSUF4nM9AnrNPloTShlgcso/kVbBDCA8/ulzyN7AhujJAyGKl8vhua3aG3VX98B
         QZl/tY+BvnqBVfy/6nct+lSDeWzNWc4wcTTVr2oYCNPloK8YILF+XKydY84p+AfqkwGv
         +i0d6ffk1yIYO3mXnQZHUyju4F+RzV+swXvz7OBsUpqtvvdGpeQ07mPxLQpxIByGEm8w
         oYYlS5VTLqJOi9rGlOz5K3m9ulkB6gK910+vPgrYeH6KwiTqj5d66VPX1Isf9O0iOzQK
         V9N1Ks8L8VKEujIDDvWzfr06phMxnoXcGwSXKZ45Gz1jQ7s/82JvVHpsyJAk/fDXzjkn
         7pSw==
X-Forwarded-Encrypted: i=1; AKwUvBzYFo0tt6JLVFRs5K0BZEwRwDlFNhRQcGwN35X4CYQVIu8yqpwxyX/PVBIJPfppUyh0I9rEljw4RQ==@kvack.org
X-Gm-Message-State: AFq9FYJAcIWgQmsbnmSpfwYz65/0GHgnSeW72iK1dCckwLkHIWMjY4dM
	VmluUPObKK9lhxtJ6pUyx07Yixwv4eOypMGAnsUTObGcRDlwjsBg8ROyR2Z0sXCr5pP1bN3uPaa
	xeI5G2xnxNLqxUpXLjtghvqsSIZOwXSI=
X-Gm-Gg: AYBFou2G4GIQovBqUGM6HUJwgas6h/o6OVEkJUd0pouu316lnoKfXiCSJWHNTz6r9hu
	FJl/XtiPUBL9GDt4Kcd7PB7tKd5BByinI6owriLtJXcxgyf0Vxxdrb23abo/c7YvjDKY7ED9ahI
	biRwLORssSFAM4jO7usNma9oUYhnr8/ZftQSo5mfqZtUlGQqpT3gwmwFs+GXXxMaSPaohSE8SE3
	B+XDM9SvZA3m4br5LCCKNdhVdNYMzfJUePok8DrFNqSMku59sXpXHwhuU9xYB4FPS9uWbvQzAs+
	JhCLlIDL4vW71R5WVt03IvI0mHO5VVzlGQOhp5PZHkDxfnQ57h5fmItGA8JRVk8ZCfnA+HNPj8z
	ahE0PaDDhHAJhA8wksVh3w5zC+YDlDp2sT42v5X0vwKp2DhmftK8Wy0oxrYaLmvZK/qzj5A==
X-Received: by 2002:a17:907:96a0:b0:c2a:fcb7:62f2 with SMTP id
 a640c23a62f3a-c46795d8b8amr616802066b.19.1792682866675; Thu, 22 Oct 2026
 08:27:46 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr>
In-Reply-To: <20261022145615.2184343-1-alex@ghiti.fr>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 22 Oct 2026 23:27:10 +0800
X-Gm-Features: AclHuK-fIBBaSiERuV8G5LHCXzXK7ovXYByOu5sY2WraRLkDWuK_sndSlfwYbXI
Message-ID: <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/swap: keep reclaim batches contiguous on swap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 948A518000B
X-Stat-Signature: 59fq8cqooi3efhg6wumdr7gukxwyn4ne
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792682868-978849
X-HE-Meta: U2FsdGVkX18eRLhAL3NG1ZaEFG4N4ToBs1BMLoy4+usxoLeYO/IudgPPgBYVmRRtMqqTQNV5uN8HJuFHxg8iQv7J8tsZjQ6ONKXEmlKtehqv8EvIQWirGWwf82SSe+8RDaeeHk92qnXCNc5QSHqkpuETddeFVvyC+SHr4kGNbC4hIVqBVMHHrDUixSDALuPj8kgSR1InA9cXFofzu+hLfWuTeThm/rFonX3t94zrjiT8bd/D/I60oJZ6f7/IBNfL9bAg/aKMd6Z/vGMrDmpsSGe+DKgCmPBu7HLX1I8yhyjGmJuAE1cDU95stRCuN2n0rjj+Mnhd/wU9/6XRtg1UF+xjBYZn2JsJncKSO/egt6pdYopMBpwh14VqluKqJQs9cYTSznkB5UVX5EvC04Sf7aLmJYIjlh5pkVuvCqZzokt/TAAVJkDZfp+hKXxfqfoKpijjzneKT9wGP5m3Zr/35LZ3tvQNTWtyAn20aFv3I7M2/EzeSSGRACkzgvMswpfvyQ7kA8+LoaFwJQUU+XND0ubUEu+52KovIyNbEdR0Yyf/morNBL/qwP/y2q3R+xb70GJWFjdaOytpIDzjITqjfWeDU559DVrkXTVFaunTYu+UfY1V98CgIxxM2DkI14zveym7fEaUkFP6xTUqNSWT8zv3GTXCOa0Z+GN2XfttEVdCtJ72kl0xye6C/9PVsg9JZbdsM/gDfMqS8CQW0o5R97rDD+RJFXrmnjIY9CL1GEwmzdC87401QIj4z6vpYEaiAxNGl3m0/y3Y4AjqYN3kvSqJRpCO+9a/TAlH2eCw3khN5aKgbzFtEX2dFvbLpbh/UcEKALiZ54MSfhu8DIyR3DvEWE77LxDzKg259K2WqfEfF+xfN2OWMy5Bvlev3oJjOehPVb7LIgvo+28xBbeWJMbmXXjb1Okgs//LKGJG1TESScgzBU7y75xWYsVfctBpQXevO1JT02Yy8XDvKkV
 gRaQv/OV
 iam2AMuYt2B+96TUkggN4SiLYh+qM6wvVF3AZdO+isUoiYV90H1+oFwtC/xgPPtcDNi0AH5dMX5YHG1kw4oLlhHR/vVCrOSxe3nZeZanCgRZLnitLREBBxU/YpT0TYp5udpmcs1ShyQ/lipoTj3xZ64zTlE5O2q8Rwad+KzYn8oB6hM/c/2KXzrQ1s27uHShyAtiUOHH/lz0w6FOd6EySu6NgLM/I2nrih2JGAuBsx/81LV9CqGcJjC0ORM7HO4jKjbWm2Ga9oRQhQecod3hA9fz2Ok8Y9B7lmXU7nX4JEOOaevI8jOIpsOn/0y77KFro8TzSU7lkhifO7E6WB3wMZvP4SaheT0XNYITDOEkxx335LTFQOeyIdnNWY5j7LRI67cyxPmfXPYLhO7bMFmBvALVrMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 11:00=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wr=
ote:
>
> 7.3 regressed swap I/O: for the same swap volume, a workload that
> rewrites swapped out memory sends many more requests to the device.
> mysql/sysbench in a 256M memcg swapping to an NVMe partition, 7.3
> compared to the previous version:
>
>   device read requests per transaction        +59%
>   device write requests per transaction       +27%
>   throughput, iocost off                      no change
>   throughput, iocost on                       -19%
>
> Two commits interact:
>
> - Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters"),
>   in 6.18, makes order-0 allocations fill nonfull clusters before
>   taking a free one.
>
> - Commit 3cedb745d354 ("mm: clarify the folio_free_swap() for
>   do_swap_page()"), in 7.3, frees the swap slot on an exclusive write
>   fault. 7.0 to 7.2 kept the slot, but only as a side effect of commit
>   4b34f1d82c65 ("mm, swap: free the swap cache after folio is
>   mapped").
>
> The freed slots leave holes in full clusters, which then go back on
> the nonfull list. Reclaim allocates slots one folio at a time and
> merges the writes afterwards, so a batch of LRU-adjacent folios gets
> scattered over those holes and is written with many small requests.
> Readahead later finds those pages scattered as well, and needs more
> read requests to bring them back.
>
> I tried three fixes, which perform similarly:
>
> A. Revert 3cedb745d354. This keeps the slot on write fault, but undoes
>    the intent of that commit and keeps swap space pinned under dirty
>    pages.
>
> B. Below 50% swap usage, make order-0 allocations take a free cluster
>    before a nonfull one. This is what the allocator already does, at
>    any usage, on swap devices with discard enabled (swapon
>    --discard=3Dpages). It is about five lines, but the threshold is
>    arbitrary, it stops working as swap fills up, and it applies to
>    every order-0 allocation, using up the free clusters that
>    nonfull-first keeps for mTHP.

Hi Alexandre,

That's a interesting problem. I think the real problem is with commit
9a42aed48421 ("mm, swap: prefer nonfull over free clusters"), right?

It's more like a balance between fragmentation and contiguity of small
order allocation issue.

Perhaps we should instead always scan the full clusters and revert
that one commit? That commit was only following the idea of keeping
the allocation more compacted for that series, it looked good at that
time. Since fragmentation issues can be solved in other ways,
contiguity seems to matter more for large physical swap devices.

