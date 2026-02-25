Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EE7FD45F6
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214396B0088; Wed, 25 Feb 2026 17:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1BD6B0089; Wed, 25 Feb 2026 17:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3DF6B008A; Wed, 25 Feb 2026 17:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7B296B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:17:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9857EC281C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:17:16 +0000 (UTC)
X-FDA: 84484390872.24.156DDC4
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id B49381C0008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:17:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tkl7ILRQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772057834; a=rsa-sha256;
	cv=none;
	b=G1oljFPmucvab1ebAZ5tkUaHqmUkt7PFBZ6wqkRWYxrRElv9LbB9jkEatDAseHn62/Vt51
	rVAk80MuNAuyODsqXYegjjV2VkbFa3iWDr9ZY5WS4+Gcv+k4CqFHy5ug1gXQdLIi6IyZyz
	TCFE3YCXhYUQVEVgaMnWxFbR3sUpjQI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tkl7ILRQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772057834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHyAmbqk7HhQ2rW+koNARPwcM5Pex8BM81YALg0B5qs=;
	b=1QHRLd8r7kerK4PnDcpSimG5AkPpT4TmapVZJlJ/RoB9g4i87oM/ui1xvpC3OtwKtyuHuV
	XOxeU39+6ubI/Bql4lkQ+T8ZKciW9HQIIb6ucwWpIo7KotCYB0+S6PC4NahUALVYfS1jXM
	HsSzxL7fgLYKI4YpYZH4CfwKKyb5t0Q=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2bdcb30fe8aso317835eec.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772057833; x=1772662633; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHyAmbqk7HhQ2rW+koNARPwcM5Pex8BM81YALg0B5qs=;
        b=Tkl7ILRQSvawcohHTBS7KJbcEUV+aYKq+tUY+de3G1a7L+Doj1odd4t9D2J0SK/Ag0
         CJJNw7/fOogk4w0dbXwZ5P9rQ4rVcXDK77IEUKVl8+eJu09cOO9XIzLf10lgV79O/W+/
         eOXfxt7PhI85yXv/nVupGYl4KCy3maVC3yM8nuLuo3mJzXVUjlSEgM+d1UvHx+FCtK8J
         OkrI/aIqxDQwvHjBhJ2rSefhYjqnKSjhuSmQec8ExffZuS8rTrnkhJXw99FVaNMEZb/c
         kdFbrLrXbwEcZ1fJ85zrgKquyfkpfFhRNtVpNAwjrSfu4UQP2zipMYreDw0+dsiKwiqw
         ncXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772057833; x=1772662633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hHyAmbqk7HhQ2rW+koNARPwcM5Pex8BM81YALg0B5qs=;
        b=LOY+MzVp46ak27+cvT5hGIsCnJ5HJFNu/qblZoIxnIUGPQtJXPfz46FsWdDEQJOkB8
         vysCdbw6TFO2ea5wA3bGUJjwou2ERXPqttVdalMo0eipJdKTQtPjXnsBLKsqPDVE1rYQ
         g9yzAYNAONH0T+O3U8Rne9LgxMUc5UTxakHlsvtj/lurFf/s1NArOF+EMhlcOoKC4Q+U
         8mSxPLsQzgdDfukBK2jpV2VOCC5cuAif68HRHhhfuMwWfcyksvHpXlETww8Dzb45LH5g
         iHxPk131VcrVAXd1/asRlSxYWSX7JQ6Ckv/21Xjd1OwSOdNKcjmS5Kp8hP6GFyVHZjq7
         2yGA==
X-Forwarded-Encrypted: i=1; AJvYcCW0PYtiC87QZQWNyF+hc6HHroYDEC8ZFuLs/u2Wr5mtRlq0iPye7jl0pW6kJyAX7OnRKWscLRoAbw==@kvack.org
X-Gm-Message-State: AOJu0Yy3VgDHKMIuT905xzVYh7cLNDM3bInJFy92aXcJhIR1Ljd5ySZt
	IWdJ+KPN6QCojCk+QkCjTBd6s3DldDf2mJewOl0r9fZnPIxWv/4+TBLgnf/5Ew==
X-Gm-Gg: ATEYQzz6vI4pbZL86lNPo10v6BllNmTjF2xDM14R5dABgcmkUcqyBxOhD9qim0CdQcr
	pUNmiYpYI4yd5yifF9+xILUdQQ1FPXGsm9mhKzCJCnNKvqVzoXps1x+GC5GN6+xhk5LoYc++aT9
	DOOOcujg0lU7IHdrl+p7ZyWZS7olsfr43/Bi2IDPR+GJDhlo4mDp2Em48mPEq4s0JTwGQ5QqUXn
	aPhwO4x3txz4F1ZZRgj3VxN1ZmcBuIoM6QHS2WwWsG97Lj19ZVz9yYPhOmqtB/sZwrckdJDWf5U
	K/ldJORapH3AOXULyybdBlAkYdwV4llmE0O0bdDThg0DQz+ioE0pSHlP2Cq8MIr3JRJSk7/N+SR
	+YiCY207oNdxJYAmoX6TA2pclhddReYwdmyrm3TczaPTjNqLF+0nM1d6AN/RIf9fEqe3D0hqyWE
	Yv7mh9YT12fwfKfjFd2R3I
X-Received: by 2002:a05:6808:168b:b0:463:cf6b:982a with SMTP id 5614622812f47-4644622ce34mr8146359b6e.22.1772051111331;
        Wed, 25 Feb 2026 12:25:11 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4157cfa6624sm16078679fac.8.2026.02.25.12.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 12:25:10 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: akpm@linux-foundation.org,
	dan.j.williams@intel.com,
	david@kernel.org,
	fvdl@google.com,
	hannes@cmpxchg.org,
	jgg@nvidia.com,
	jiaqiyan@google.com,
	jthoughton@google.com,
	kalyazin@amazon.com,
	mhocko@kernel.org,
	michael.roth@amd.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	pasha.tatashin@soleen.com,
	pbonzini@redhat.com,
	peterx@redhat.com,
	pratyush@kernel.org,
	rick.p.edgecombe@intel.com,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	seanjc@google.com,
	shakeel.butt@linux.dev,
	shivankg@amd.com,
	vannapurve@google.com,
	yan.y.zhao@intel.com,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 0/7] Open HugeTLB allocation routine for more generic use
Date: Wed, 25 Feb 2026 12:24:37 -0800
Message-ID: <20260225202437.4077364-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1770854662.git.ackerleytng@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B49381C0008
X-Stat-Signature: prmbrr6h1bwjdnydr1hyk95pmy1an1do
X-HE-Tag: 1772057834-750389
X-HE-Meta: U2FsdGVkX18ZD/Gpgh98YaULWj9H+NE21L5EtEbZJ4WuqXMgEe5N5yxfod2RksTYKvRlNIkeE/lE/dFQWk7BPh2qqBIilpCKpbPw6mAR9zufBl6RsBrMcmCt/Ih1Zrz6vOZwlxREdJgaAGfndhhQgu5i+B+5KbosNmK78prWqtM99PmYxrady5aoXLhTGnyrk7xncL0LM2AzmzdUp7Quv8RdAo2bXwpEp6LJgfscgK0jy46sJi9HS2+KtH63quGFSFDmFL+gW/+Ng88OMbBFqhYAwhB+0d4u6hyllcxCc2WmLMKKIj61EDUpTDRIwj2eT66Y2dd/MpOohwptGpZVIKPsNg/c9rBOUtcShSFJPjEfeYKBbZnjO5kgCFCyf3AAwwrhM21ROoXbTJI26LtPahb1W5O817KkQoTUs9kRrm6Fh1DuztCc0AHYT+RhIcT/MNXJoqbIpDW42EB9iprFRSK8x5MNEgKzSG4fDMF+C1e5CBGrl+/8jNEgBqVajNTt0nRC6L4zYI3BABDbwEzUB15PFc5KzJ2+7DbewzIiFOV8+3avXZqxyjI6qY9c8jxfclU52B7tUrMwATrsTekjRbA7GrWXbnWIUM8n4AcvY6X21Ea1nK7Z8HwMhXtmpE+wYzmuLEoW5Rb4OnmvbQDOi8banf3yJUVG70lYtDr6EtPlMd3yVmxN8gf+vy7PJdxwmZoe9hUHaNfn/domYRWJ0xwSbdhgMT5zrdbVjV2Wg0+2BcrjlVgpXkx0AVvt1HEkeuLPfdn/kvJDgWCN5nZ2mPXTF1a0j280azXR1XQ573szYIcRLITVcm+/N805mpsQC4ppsPH6O2+mbadByEz8yHdu6AvVVK8QnimDpVWbK/028fSiifOB8JI8HgepREPvB1s2eXxF4JZAww13nxaiE636CzGshIAqtc1f0bxuEccjmukVfXk4zkn/taM4IfgVCIFkPRBV3F267+8aewx
 FwRbu8Bb
 /bc58w8szRhyMHXLwAVwe8zbYwunYPFgRc0dzYWXS7rNMp+TL91wVRzGV/5lrwDzwwLrD7of71qJr8dMBrA2vAuWaLgm4tfkgYZeHFM5CsohLQxb5K52lXxIEDTLmdSs6sDzelBfHP1jj4CuswUl9RScg/Yt+l5WXRiucegzB5jpjJdVOZExl+Kx0a73ZNiSz1qgkL0z8xGZY+u2voeNwhq4wHpokrpG9AmrU17zrKqHHwgj57q/s5WoP7ssJ1bN7s0kd7ZtZfr/QGP89TO/kF2kYXRXo0AsmIZvaRDweXV01Zi3XJlwVrpve8l/Y6eFun5DAB7QFdUtZEEFKL0rDjds293SIGzTyHNnijwyGk5Zdnu9397i//JM62gFXk24f7/YW6ExrttsBbyncnoeoGYJo1REe7tQ1L44s28wi9zwscjc/D+vHGFw3C7DKhrlQZkO71Ip4+MivpnIHhCX8ZA9HWBHvI36DZlT6rSxjk4tSae3WAxsY2CeJk+2fnxoI7OhtEC08ohpk36Pd6AB53udPtgPsAPZ9p/3z8GMvdJf5mcmhop3C2afjd1GT5002xnuz3TQESWILUlj7pGQ6kJ9T4vfEjhyLOYARZbDUltZbRARr+TEJY40De4npsFghGR89reYsKKxsqs2uzVQ7CEV23/UgKwgQwgtc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026 16:37:11 -0800 Ackerley Tng <ackerleytng@google.com> wrote:

Hi Ackerly, I hope you're donig well!

[...snip...]

> I would like to get feedback on:
> 
> 1. Opening up HugeTLB's allocation for more generic use

I'm not entirely familiar with guest_memfd, so pleae excuse my ignorance
if I'm missing anything obvious. But I'm wondering what hugeTLB offers
that other hugepage solutions cannot offer for guest_memfd, if the
goal of this series is to decouple it from hugeTLBfs.

> 2. Reverting and re-adopting the try-commit-cancel protocol for memory
>    charging

On the second point, I am wondering if reintroducing the try-commit-cancel
protocol is tied to factoring out hugetlb_alloc_folio. When I removed
the protocol a while back, the justification was that for the most part,
grabbing a hugetlb folio was a relatively cheap & fast operation, since
hugetlb mostly operates out of a preallocated pool.

So the cost of being wrong, going above the limit, and having to return
the hugetlb folio was also relatively low.

It seems like this patch series introduces some new paths for hugetlb
pages to be consumed (specifically, without a reservation or vma).
I imagine that these new paths make the slowpath for hugetlb more frequent,
which makes the cost of assuming that the memcg limit is OK higher?
I think explicitly spelling this out in the justification for reintroducing
the charging protocol could be helpful. 

Thank you for the series, again. I hope you have a great day!
Joshua

> To see how hugetlb_alloc_folio() is used by guest_memfd, the most
> recent patch series that uses this more generic HugeTLB allocation
> routine is at [1], and a newer revision of that patch series is at
> [2].
> 
> Independently of guest_memfd, I believe this change is useful in
> simplifying alloc_hugetlb_folio(). alloc_hugetlb_folio() was so
> coupled to a VMA that even HugeTLBfs allocates HugeTLB folios using a
> pseudo-VMA.
> 
> [1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
> [2] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25
> 
> Ackerley Tng (7):
>   mm: hugetlb: Consolidate interpretation of gbl_chg within
>     alloc_hugetlb_folio()
>   mm: hugetlb: Move mpol interpretation out of
>     alloc_buddy_hugetlb_folio_with_mpol()
>   mm: hugetlb: Move mpol interpretation out of
>     dequeue_hugetlb_folio_vma()
>   Revert "memcg/hugetlb: remove memcg hugetlb try-commit-cancel
>     protocol"
>   mm: hugetlb: Adopt memcg try-commit-cancel protocol
>   mm: memcontrol: Remove now-unused function mem_cgroup_charge_hugetlb
>   mm: hugetlb: Refactor out hugetlb_alloc_folio()
> 
>  include/linux/hugetlb.h    |  11 ++
>  include/linux/memcontrol.h |  21 +++-
>  mm/hugetlb.c               | 228 +++++++++++++++++++++----------------
>  mm/memcontrol.c            |  77 ++++++++-----
>  4 files changed, 212 insertions(+), 125 deletions(-)
> 
> 
> base-commit: db9571a66156bfbc0273e66e5c77923869bda547
> --
> 2.53.0.310.g728cabbaf7-goog
> 

