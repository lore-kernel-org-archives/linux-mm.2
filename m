Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6294BFF60D5
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FAF6B0092; Tue, 31 Mar 2026 15:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FA56B0095; Tue, 31 Mar 2026 15:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9257E6B0096; Tue, 31 Mar 2026 15:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80D156B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:55:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E8B7C410C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:55:34 +0000 (UTC)
X-FDA: 84607412988.11.0E8C455
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 563CC4000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:55:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=weaybsoz;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774986932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndd/0yUUkMAWrVwxEqogP6mFg/9XKndZe0CZx4jWNzM=;
	b=nzx5u4WAX7NRZU6ZZWWNYi5FWabXDIhZfdrbr9ZRnkluoD1ZOYfd9rY26GlOj1xA+iyZV7
	4SSb/GPcdIpOV4tZ0n45QgJE01vhiw2GMdoeQxkshsCWnlDDvLGfuSSHAss6w4X7Q+1NnO
	/1L3tKBTnKhqVBYwWLzXSt4eioMUIXc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=weaybsoz;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774986932; a=rsa-sha256;
	cv=none;
	b=FWH2Pgk5IqNe2iOWrKsnuO050AyYYYJRahH3L0bgzyp/seoSjTUZi8mE1k9ft1cDGtst4P
	2c6aZztDWwpfqJTQ/BIUP8bawJmu4Jv/p5LMUJh36Umly38qgQZ58UTI7G8sxSW3lCnbSE
	mDUlxLzpbpbrD3+v/iljObzJXbxW8dY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2246D4028E;
	Tue, 31 Mar 2026 19:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960D1C19423;
	Tue, 31 Mar 2026 19:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774986931;
	bh=4Z/YbbK/WBO5GmBjI0jCkVx8hWOxUtFdzK5FPKnb4jQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=weaybsozmNvrlJV0s1e4b9zuIdwEDOfFoOpEYXO+IvefIKiedZ2vPq6TFOlkJKw9X
	 iMcwYbBTqhsc8TjWAN5Sc+UeLDvltXqvIOwrQ/veRiLvnZTPy3Ngi50cs5oASb5PlP
	 Bj2QdpN2z4Ejih2XtTWitbJWH0luMUeG94YMMrfM=
Date: Tue, 31 Mar 2026 12:55:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Petr Tesarik
 <ptesarik@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
Message-Id: <20260331125529.de4deb7b46239fb13e4be517@linux-foundation.org>
In-Reply-To: <20260331113023.2068075-1-songmuchun@bytedance.com>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 563CC4000E
X-Stat-Signature: uxcgr77eguuqdwj5s7gpw1koppf6nz7f
X-Rspamd-Server: rspam06
X-HE-Tag: 1774986932-672357
X-HE-Meta: U2FsdGVkX19r5VjqFf8wePtkIjTBNkmIRWukCwnwKiihblXUf7wfP7kgqXVMK8xutm7PliUfUYTRj4xKu9z4il7guWIr3ZrhHBuU2loRzZvNLPyHjslRtDbkV8J4+Gqc6M0vmzoc/YqBTW2DcizkyFNDZYQ2EG9kle64CoDkVkKOcyPR1/x1E3V8l+fmWHUsYeb0RhXRCkuNGywAhBhTa8Wmgdap9y9C6jjbtlqeH3FHJ040YKfiVfsSHofl/LvHoBPr4zv9zbRESJXcd28oycYLVJdAxNQHI3RHachugr5iBLjc6ly2mPx2fPgape2iLruhLUzcyEyTbtFS4YYwHj5kB9ER4GB+5kW7y4y/RLTksoPr/IW6J2zk/3EWmLwtvKeXiuiJzFZ38GlOaTH95jIpexIBksxqa8q2wKf9VNiBHuT7n6eXapnvLaESN7EUlNg0OVe6LyEnIRo3hpDDtJKWSqBTCr4yA6dnTdlffIcCyvz7rOUqcyAw00bz6mxl1ISUniouJB5Y26KJCoNdF7W6IYs1uF5Ymqnw+VxSzSacmO4WgdJHLMCPvYIMBCQXIrMdR31f0+fx6QFFBQKX1W4rG+i3siKAiOPfNb0Z6SyHuyd7erhjXjkagJP9HNutj8A/0bn5rNonUzSLjVa+NWQbw4QcVO0ucZjL9otf2RwVU285nb9Hy38z550wQnah6i+4xID0wDeK3wB6MGYS5HLwyBcjC1spUc/YMbzWDar1Nv+NDb2oEt4FfrX6DzpPCe/HNYMAfg+GUnOaQ8wdOCsePKxa/d7GCZiZ3GACVGS4ibebk7vzwhiMWJwfZPat0rkQ62ymXa4fMDriq3ihiqiFqJqDq7Jx+J2ymvkCQoYR9urnZXzDRGyJpVqdUR4goPEVwbu3OTuwlMzg3Kn8zmOfiOD1NwR5yM76ci/Pb8NQbHFkZCJ3KMQNx1uWASt8I6i4TAFkQY4MlsIGYCt
 Eh4wA2Xi
 79KKVjXN6cgpUjn8DPmLId5YI4z/Pg96HuK2LgWH+4TWwoPhiB0ikyBrHYBqlQwejnj32UCEw4nJXybeDAx6oSlp1BraLAXxlHpD0xQ6mqNE/6GrSbqWtXlGayPBnIU6KX80AhUKtlxbccMEQbtAyGPpVTXmO4VLsbzdiDo7QAh56+feQWScTUROvvesJrqDPfQ+FU4HdUnl07HRw5yMG4oJhnxZ5t0R6+t+GwVs3ZRoda2Uu83joA6NjA7CGZOcIQYvsOofXjxlPiAstkEELveMaYxUA460YDvwXR0HrH8alpDGIw8sYA0lCGFMTYxQU6SHV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 19:30:23 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> The comment in mmzone.h states that the alignment requirement
> is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
> pointer arithmetic (mem_map - section_nr_to_pfn()) results in
> a byte offset scaled by sizeof(struct page). Thus, the actual
> alignment provided by the second term is PFN_SECTION_SHIFT +
> __ffs(sizeof(struct page)).
> 
> Update the compile-time check and the mmzone.h comment to
> accurately reflect this mathematically guaranteed alignment by
> taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
> __ffs(sizeof(struct page)). This avoids the issue of the check
> being overly restrictive on architectures like powerpc where
> PFN_SECTION_SHIFT alone is very small (e.g., 6).
> 
> Also, remove the exhaustive per-architecture bit-width list from the
> comment; such details risk falling out of date over time and may
> inadvertently be left un-updated, while the existing BUILD_BUG_ON
> provides sufficient compile-time verification of the constraint.
> 
> No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
> the smaller limit on all existing architectures.

Thanks.  So this can fix the build on some arch/kconfig combinations?

Do you think we should fix older kernels?

> Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer")

Eight years ago so I'm going with "no".


