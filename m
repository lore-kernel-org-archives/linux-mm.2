Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312E4C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7526B00A0; Mon, 31 Aug 2026 09:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158776B00A2; Mon, 31 Aug 2026 09:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D1D6B00A3; Mon, 31 Aug 2026 09:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D66BD6B00A0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:12:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61A9E120111
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:12:57 +0000 (UTC)
X-FDA: 85161604794.25.684FD08
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E64680006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:12:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=KPceeqwj;
	spf=pass (imf30.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788181975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhaSwmeDZX+FhVbqZef/6aoKxmBjWUBVyUihTtoeWgo=;
	b=hkVBLxgt2IyA7LR9lxAMkWpXvIRte2H//soh4fsFH+xikXBsO0nxG/FRn+DkwoHSNPOlSS
	zVxQmmAUAWSQJwMkOnkA9sfZG9VicvBzvT7p3Dl2l9+YidfR03k2H3B9NZo7dBW1/pw8Cr
	nueV2WYWLp+B2hsO4Jfs8umjthRpLaw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788181975;
	b=fIoXWpjeQg1D6GLu6VA9A+O91jRNAYlknuogHOicKkMhNU6tj2c1huuufYndeos8qB8OqW
	FjsA3irdGJKfa41+1kyPiCfCPtK3TJZLh5MlkvD6Bi2fX7BmIj+zB+MXB5es0/Qa8Q+C5N
	Me5fcuP6KrichZKFapYiEazw8gdafMs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=KPceeqwj;
	spf=pass (imf30.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QhaSwmeDZX+FhVbqZef/6aoKxmBjWUBVyUihTtoeWgo=; b=KPceeqwjCU2Fbvj/fap1K6JGrk
	VteOYqIzCZNBPGtbM43FSLgWNd2edxK+1Vs92twpxayUN6CDSPs6CvaEO6No61AnEAx2V9aHcyTy4
	ghxRdltlbsAddchl2mSxeMBFP1jrO1O2cMTmr2a821ZcWWQjRIBIaR2cLVvV/Lh0iwZ4yuBtcrPLP
	BXRK9RaEe7j2+ndGqH6JdmkD0e3B7lkryDd0GDcgMorqUzGpt37NsR/Gj38ICFYydN+M9Qt9GFoHH
	lGqihR/t1jrONnRcOO1qkrJJyQsLjVIWLYX1eKo4KZJfSLkaxRisPNNBEYh2t2NR1ELbMF3J3X24T
	OHbql/DQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x11ob-00000009sFC-353M;
	Mon, 31 Aug 2026 13:12:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 918B9300E7E; Mon, 31 Aug 2026 15:12:44 +0200 (CEST)
Date: Mon, 31 Aug 2026 15:12:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jianyong Wu <wujianyong@hygon.cn>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Phil Auld <pauld@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn,
	huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn,
	justin.he@arm.com
Subject: Re: [RFC PATCH v2 04/23] sched/topology: Introduce a method to
 calculate the llc distance
Message-ID: <20260831131244.GJ4120091@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-5-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-5-wujianyong@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2E64680006
X-Stat-Signature: suggd9e1599w63xsgn9fdpaocgpxf5ps
X-HE-Tag: 1788181975-324513
X-HE-Meta: U2FsdGVkX1/4UkHmR7kSGBU6hpEW80s66d69hoIAtsHD0Q7POtfMxkXFzAgVvXieEoxFe5fgEidH20jNp2X7gS2atEuddpNRvN0Y74CNfZ9cApx388CggawHT5im/p4ivliM62lYjtXYuJQiDK4YrDXLhvkGBGKZLez3GS9lT5oQcFUnG8U1PXoKNyGkB4HXyUyihGu6YwHMX0DQTBlGLiVfRWOEvHJZ395r9bHgE1FUtUUI9Zzws09kpaMLFZ0M9hEH461Ex5Ksm7rT/KPv280nNfg7fEVk4qK5+qqNGjbWQ7XVoSlSVTcBxmJehc0IGDqVuelV0KVcwt8Jp3/LL5QBflaWalCJtWu2d2399K0R5oL3ndz2W3+B0Ibezup0P+IWSsj+CpJkaybpxwyAsYYkVtDfhmX7xB+oTgMSaTfs7Hoy/d7ZjGsV/Ax4WODqM7WB2mzl9N1ghq+9DP5UbvOKhuaROeMzwQP1hPsfynC9GVsfyXPoJih+UMggMA6F5s5B3j5xvi4Ox4REXC7j1TVKWCe1+8gUUP9wzs1QZinV+3j0oKOamBH3IGtQ8jt12o8aZYdT3kdvQHtmhuG0+tnay7af2l88EGUdbJpFL5QkjiTS7AexgljW1arrevnAMFpPm8ZPck4jxT0aw76o+UDz2hj3Vo/MQXikyTkHetkPY+U62sS8s6rm7SKwzSEim/pJZnq/evwQqQ8PDJOJQ0XQjKCr2RCluGH8tDd/MTj3qYPkZ1xnEsSm1gRrsdYefRZ8CXJ2pDXWxw0m5SCWYcJLVnJl5nN1EzT+Iz/9mJdmuOHYV5zneaXdRTk79rKk0tyei8ODFJ98Jj7FfXTVoht8GT6IN8WCBAEocJmulHERG/NgZtUzCYBZWUbWeN/l0AaiDBTz95yceUVPJBhsZsIq1+WEDep3KoW1Ocq5iI/K8Xa9Xr63IPOi46bC7OmSAiu8YaNGywEpjTKWg7I
 T9aqLXaS
 Hys69un6pvXesMnjCEdaFH5QPNDhqpoM5O5PTVEKM/bRvOQUESkpF4/kK+CeLkJfpwGt4Zk3jKkCCfRyz/9iG0v8zU6QxjSWK+QJpnRoe8TXeK8RpvyqdMlki1ZsNsIABN5L4Aw657JZrJCDmowiWFjsSJULGrsrT8EQJUw3qfw0wiJplM0Ke2m3C+aIdmFwydPVCdfUQC2gzDOLPyidxNnz9yrDJF+rGonub4FFQrdIVOrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:27:57PM +0800, Jianyong Wu wrote:
> The previous patch addresses NUMA inter-node distance handling. This
> patch shifts focus to the LLC layer and introduces a scheme to compute
> pairwise distances between sibling LLCs inside one NUMA node.
> The calculation only guarantees distinct distance values for all peers
> when viewed from a single reference LLC; it does not enforce globally
> unique distances for every arbitrary LLC pair on the node.
> 
> One valid calculation scheme is defined by the formula below:
> 
>   dist(LLC1, LLC2) = (rank1 + rank2) % k + 1
> 
> Constraints: LLC1 and LLC2 must reside on the identical NUMA node.
> rank1 = local index of LLC1 within its node; rank2 follows the same rule.
> k = total count of LLCs available on the node.
> 
> The formula never yields zero, so diagonal self-distance entries are
> explicitly hardcoded to 0.
> 
> For demonstration, consider a NUMA node with four LLCs (local ranks 0~3):
>         LLC0    LLC1    LLC2    LLC3
> LLC0    0       2       3       4
> LLC1    2       0       4       1
> LLC2    3       4       0       2
> LLC3    4       1       2       0
> 
> Sorting each matrix row in ascending order generates a unique LLC affinity
> sequence, which drives thread migration policies implemented in follow-up
> patches.

Aah, now I see. I got confused by your sched_cache_node_distance naming,
and thought it was cache-to-cache distance.



