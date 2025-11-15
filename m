Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A98ECE8D7A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 01:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD018E0007; Fri, 14 Nov 2025 20:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD2F8E0005; Fri, 14 Nov 2025 20:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79BBA8E0007; Fri, 14 Nov 2025 20:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65F9C8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:22:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18F121405F8
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:22:55 +0000 (UTC)
X-FDA: 84111092310.19.55EF68A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89886C0018
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:22:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhEqFRWJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763169773; a=rsa-sha256;
	cv=none;
	b=YWcPwjTkwy7JKk3bZJIxvhmThGRSJzkuykP4pDeu9NsXgWc5mY8rffe7g2vaMrdA1bwvVj
	4XL5Tm/jRUEWgSaB06BdBWWa0EGkYH9M33aGTsTnbgzlhXZ1u5tGRMXRnNBvRqor/zWblm
	oszlbwUX5U99TtPheKCn0q/2/iOeCBM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhEqFRWJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763169773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNcKJq+UACovyT5vAe98UNjzddBj7reCTzaAD7Q3hPU=;
	b=6d//SnMKGOw5M9X+1LfG5e65KcO04zuzppUO0xgJ987mwicnpVkFLPpXWBFLzc18FwOAUt
	n3TfYUFZpfNl8Da52OfytK07dHHClq42qNTkJaIyr4GX9mtbZjEibPJ4VNNStcIDcPe76H
	8PliDNbn4AHQMasy4tRqXWqxznB3z+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96A2B43AD3;
	Sat, 15 Nov 2025 01:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FE0C4CEF8;
	Sat, 15 Nov 2025 01:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763169772;
	bh=eQsdDltmb6P7uFAk5MYeuKsn/K8/pYmmEhSLmqls45A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhEqFRWJRAl8ptzMXC9mAW/w4Mk1OEKJ6drFzClhcMlgN0OHpKVwIysriIsH4E0jB
	 TPMcGNZl87bIxYAdbKurkge+oINY5IdFUx1vaCRpI6F/AsxdL3dqyb8pQU1Gbb+jRC
	 OIKlhQk+QTSLISAlg3xc4M6fvnpTVWFWf0vyM9Lt32IAqxDxV2rp2QsoYGFeYqyXGE
	 Ge2PibrejVTmI/YJ66JOUjh+5W9RK9kDlxXjbQ6I1sc4dCL6fodKX3q9PsV9UEblk2
	 p6GyUsFY4JWOBrhAY7n9AicE5YqROoHJkRkce3t8gm39AQNARp0CPj6SmZcNmDAIxd
	 iV2MTiHObJOyg==
From: SeongJae Park <sj@kernel.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com
Subject: Re: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Fri, 14 Nov 2025 17:22:45 -0800
Message-ID: <20251115012247.78999-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109124947.1101520-1-youngjun.park@lge.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 89886C0018
X-Stat-Signature: dmhw6oa8pypur9ythn51sfj7rhagftb6
X-HE-Tag: 1763169773-676298
X-HE-Meta: U2FsdGVkX18FtqUBMkfrUivZEEjd3wIqD/yb0wBKaHBkH0InrShzPiSFg4UGj5LNm0POk+VjuJGAv+io5Mdvkj7lebVHubOFsj1xgF6N6dZxAo5F71F+F7V0DtOBJKlDKBNglug3NNDw9ufTTxHJ2QXEJu6XdAs/ViODc1FiGcBBKBGWTyHmoR1Gg1DHk/umkF3OQDhkHj5BVSQiw4Qrx521iYi4iITor75seNZSkEl6Hlz2M5VlRgRLanTPtLuKL06s8Z2DVS+RhoTJV14ot1uQhpbAVprDqditVAGCqDXDIh3nqSZ5wHYmVbziVem8Jzg2/Q2YqRN4YrU6P+uMRIdkGLCI15tWfWtymwnJvMABmBvUREUFB76rjoNjbcEFYe85JGrBCpP9IoBA5I5E+hRNxaJJdhJwp6c/ysk0JBIq/ulWNSZIywepQHNjw0vT3N35FOqGZeFeo5G1Yn5B9/RVgmHLI9wNw0/oILYZlhK/z+OWOznaxm0H5MMDhOwNWAmv91rshyWmBTWmxgVUCcl0S5sM2YAEgLKpd/2kwtyqcGOLJhcEW2MVbOKiKPfLC2t5/pR0wCgaaRORGgvrLJ826rqt7lRTbjpuCK4BYR4Jjc6twqcpfP9DZcVVTzxvMDfE/MX1i9woJmpZO4/LdfNa1PQfEDFS4q54RoYzBlZ7q6K1Q1pN8TAOM9CSlg68CbGtOrfi7iznIqcCiHocgPvT/LxfVhf3ErV2Kh+CbO51UYxiFIk/gUMfjDsB0pTJrHrfzqLp5SeglOVH1jTHLiCklsaW0+/zkCHUTpy6UY8N9RJMaqIlBqri/rVWOLWa8WGZkIQchhHUq+cngpzvbAFSKCGE5vxuOeLtCLjUwx8hZ5kX/HqR/DyeNuKrg3g1FuemgGRZIQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  9 Nov 2025 21:49:44 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Hi all,
> 
> In constrained environments, there is a need to improve workload
> performance by controlling swap device usage on a per-process or
> per-cgroup basis. For example, one might want to direct critical
> processes to faster swap devices (like SSDs) while relegating
> less critical ones to slower devices (like HDDs or Network Swap).
> 
> Initial approach was to introduce a per-cgroup swap priority
> mechanism [1]. However, through review and discussion, several
> drawbacks were identified:
> 
> a. There is a lack of concrete use cases for assigning a fine-grained,
>    unique swap priority to each cgroup. 
> b. The implementation complexity was high relative to the desired
>    level of control.
> c. Differing swap priorities between cgroups could lead to LRU
>    inversion problems.
> 
> To address these concerns, I propose the "swap tiers" concept, 
> originally suggested by Chris Li [2] and further developed through 
> collaborative discussions. I would like to thank Chris Li and 
> He Baoquan for their invaluable contributions in refining this 
> approach, and Kairui Song, Nhat Pham, and Michal Koutný for their 
> insightful reviews of earlier RFC versions.

I think the tiers concept is a nice abstraction.  I'm also interested in how
the in-kernel control mechanism will deal with tiers management, which is not
always simple.  I'll try to take a time to read this series thoroughly.  Thank
you for sharing this nice work!

Nevertheless, I'm curious if there is simpler and more flexible ways to achieve
the goal (control of swap device to use).  For example, extending existing
proactive pageout features, such as memory.reclaim, MADV_PAGEOUT or
DAMOS_PAGEOUT, to let users specify the swap device to use.  Doing such
extension for MADV_PAGEOUT may be challenging, but it might be doable for
memory.reclaim and DAMOS_PAGEOUT.  Have you considered this kind of options?


Thanks,
SJ

[...]

