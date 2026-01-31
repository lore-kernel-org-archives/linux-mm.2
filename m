Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1E3E7C6E9
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 21:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779466B0005; Sat, 31 Jan 2026 16:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727106B0088; Sat, 31 Jan 2026 16:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6292A6B008A; Sat, 31 Jan 2026 16:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F80A6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 16:15:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00DCBBB991
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 21:15:15 +0000 (UTC)
X-FDA: 84393514590.24.62D18DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2AAF440009
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 21:15:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=knqR6QtH;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769894114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvr0RDKu4nyIvOgDIIjDDzWfQQv4EYfQVeJK8mDAyaY=;
	b=d65P08C/VO1nEwyLiAre9PN+0phR8dZ9teEWzJMqGGrvmhmfr4HiykInHq8sDfImMc71AJ
	g5csLc1ozykImE6mSa+M08PRRnVREaEpuecGK/fpxbu5wyoD4iTu/9BeywYziQ5SOoDQAu
	bsXqS+/yNI9AY5nSZapTcV1BjHMqKig=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=knqR6QtH;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769894114; a=rsa-sha256;
	cv=none;
	b=qIcR65evvXfDDwpSba0bD3OUuvk0vLu+pM7qXIVSdD9Z2o6IHcK/XfdYQ0il/dcUQO2a2f
	WivK/Wb7oBChVbcdRTnJRzVPd9uEkQ2zuGyPEgkP47xVyGeWdIfnEIn/tt7t+nHH3ACU1V
	j3wghfXpFKlk1GBYSFNY/sG6KWa7jaY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0897743D04;
	Sat, 31 Jan 2026 21:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3110EC4CEF1;
	Sat, 31 Jan 2026 21:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769894112;
	bh=xcm867JgMbkkY0fTpvZFMhpWopYN8xdNIr1JmHZJZbg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=knqR6QtHT4eLud0Wuw0mdH9iqbgHVNi81q8RTfLHCFf5u9RGDDeETZ5qghnkZLZuz
	 vW7J9enus/UdbnXbq5HQ/lyoUIxdo+tCHpXOQLySwDlepNYI/jJ3CTx5UzvoOz+MrR
	 uxcrMPQehcRjvpOH9/4s2LKcL1cHL+A+1es+HcEI=
Date: Sat, 31 Jan 2026 13:15:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>, Usama
 Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Matthew Wilcox
 <willy@infradead.org>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
Message-Id: <20260131131511.e5f1ec520fec066b22ca04c1@linux-foundation.org>
In-Reply-To: <20260130042925.2797946-1-shakeel.butt@linux.dev>
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2AAF440009
X-Stat-Signature: x68jk5jqonc59wq8ua7gyw8pmxjosnhz
X-Rspam-User: 
X-HE-Tag: 1769894113-874788
X-HE-Meta: U2FsdGVkX1/mgTH6QqOse5Oufr/XZSP2Z/KnL5XEg+vRAFdvEfl9isrPDv1jVf3pzstExHcxlgQ74LKzITO2iLG3MdsaxybafoaCbD4ZE5jZtBi44qZaAE6Lr4rXOt/Pe/dkFYPx+0ETwybgya5CN14n2F6xgfXz6+cFOybOTQd6oz9uDbPKOuMML8XMl/2q/F8T4rZyVlNBQH+L5l1RqaY0aV0pkpMfsq/IDUtZGaRinh367pjNnwLUF6dLaJI0BCbhFgSKwhbu2JZNAQ0hwackkX5ESWiViB7rLQIJ1Cbhf/aHdaK09nrR87QdW+1Ur2BO1HRta8O1oaFnO5/jwScwwTKBQiwnljGF0Cmh7pnzFsEN/gkZiBgwWWdgWBOeLbLpHBpnBJqxULH3y2spWBeEuUzyxKi3y/4YMppbLeUYfuObgzC62tQM9Lux9DJsWnq4jSjckzlTsCgarBtZ0sH4r6Op32Qrw8j9HCUjv7cBPInqTkeFAx2QWe0wOpG5YI6nZt+pDdL6zv1nypX3tS5QHlLAE8pMk9qfrOrD9UryrIh+PsyfhpvSrsdWQzBFveYcsazfy9YpdEFmSQ9Ay5RqyCb58wkiq+9DrludAX3W8u5x+4FMQxFR/Q7RITGQZzC9bdGy3tMeAYfsPa2HIYT0h6sH2LINd1UOcmKe0SgBhFCCpke3dmA4WsCfa5tiS/sGupuqfpxz7krOjZxxyZzuiTDvsRr5gGDtg9txsEDDbZVtVcfwQBLIAc9Jq5AUmfUz0XKddigj489THzXhT2FCR4sC2PcQtUPG04kss1XPM07OSY5ARc7QEQA2fkZtkTyrT71BJFsizKjZYJq+SUEcqkdEUF3DMCgboEEp65uWZzx3s7I5e7je8pj3pRe74g+ajKbUEbBjft1elplUK4JV9XjeZ3HDXWYblP/5bcswEK/EWQk8T8gi0WQJbnLknFMavMyvNElBnnkak5H
 s9TtYA62
 MK60eMeeBqcI0EwlST+++OofbpuQtpxyM1BRI3Kxin82sKToKxtRKFUvFjXbI3yCyrKSuo6WZz2S34g2fwcZkDI8G85h0DbRAwnd8koNEQTBGlDZ2z1Ihp5Fgijp1m9oxsxBaZAJdWJzY65L8IQkDw1Dskonz9yPaGP+g89DGTMd71M4rkBb5yCXZ/McmHvLXcrHfeYTSaoRwR9xgT6lf874dUHc/T2yX1y5+7EkmVQwPzNO5qATgte9XCO3YxWAujKs8g4+ILOGruv5LX/kVKdcFtb+l0HsQlExGD0nRD0tAkt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 20:29:25 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> In META's fleet, we observed high-level cgroups showing zero file memcg
> stats while their descendants had non-zero values. Investigation using
> drgn revealed that these parent cgroups actually had negative file stats,
> aggregated from their children.
> 
> This issue became more frequent after deploying thp-always more widely,
> pointing to a correlation with THP file collapsing. The root cause is
> that collapse_file() assumes old folios and the new THP belong to the
> same node and memcg. When this assumption breaks, stats become skewed.
> The bug affects not just memcg stats but also per-numa stats, and not
> just NR_FILE_PAGES but also NR_SHMEM.
> 
> The assumption breaks in scenarios such as:
> 
> 1. Small folios allocated on one node while the THP gets allocated on a
>    different node.
> 
> 2. A package downloader running in one cgroup populates the page cache,
>    while a job in a different cgroup executes the downloaded binary.
> 
> 3. A file shared between processes in different cgroups, where one
>    process faults in the pages and khugepaged (or madvise(COLLAPSE))
>    collapses them on behalf of the other.
> 
> Fix the accounting by explicitly incrementing stats for the new THP and
> decrementing stats for the old folios being replaced.
> 
> Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")

As the bug is 10 years old I think I'll queue this for 6.20(?)-rc1 with
cc:stable.  Just to get it a bit more time-under-test before -stable
kernels pick it up.  Sound OK?


