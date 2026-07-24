Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53EDDC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 00:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E137D6B007B; Thu, 23 Jul 2026 20:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4826B0088; Thu, 23 Jul 2026 20:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5BB6B008A; Thu, 23 Jul 2026 20:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1D066B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:34:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D47C4024C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:34:23 +0000 (UTC)
X-FDA: 85021798806.09.CDE8D45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4D11780002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:34:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2N475bEU;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784853261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFiuk9YnSrQ9gDttwKCFevREVVtLKrpsxcv5mAjS/Pk=;
	b=yVj14rNe6X6uAD4GUwZhmcROFS8oKW24aZ7GYTIxDQEAzAasHrPuiDC0KUDY5I7KE7W8BT
	X9dRPiZSzeXgYDeplsNkwJj6cuDRRSQIy2Xg67npxDTxgMR3X922BGOX/47WqzwugiTdYg
	AB23Ltx73z5R1VEGr/xjE44ZkM6UBTw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784853261;
	b=tRMbMPNqJufw6hYTqqAN40+IWEx1re9ty308opalzpjf8jvKdfljOnanFYbfKexIxDUkiM
	O59lLslUGtuhM49C37uQkr8f+7yyj6voF9oAokQ8oxpPy6eojWHBbjHdJYf/ra9dq7hi7T
	axKOEIi6gNr9nLh2ETEkavfEhkDvTeE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2N475bEU;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09DC843CE8;
	Fri, 24 Jul 2026 00:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275F41F000E9;
	Fri, 24 Jul 2026 00:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784853259;
	bh=uFiuk9YnSrQ9gDttwKCFevREVVtLKrpsxcv5mAjS/Pk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2N475bEUQDEIU440uwwra2wBt6wKRKr1mV5I3Z1Jnouas8x7jlTrSOLtKBGplsCzy
	 dIpAe0zkYkdC3f3qPzGrprzpie8of66ajK00ElzN2YdHOIIO0GGvbQsNES6qIw5pr1
	 Krhmdws8yXY79Cyscu1ngMxt5hicdceFEECwGq4o=
Date: Thu, 23 Jul 2026 17:34:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Song Hu <husong@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 0/2] mm: vmscan: fix node reclaim ignoring
 swappiness parameter
Message-Id: <20260723173418.010e38f655f83850d92c2c8e@linux-foundation.org>
In-Reply-To: <20260723032434.2016749-1-ridong.chen@linux.dev>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p1ewjr4g1u9xs1mmqregbahc4qkdgfsd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D11780002
X-HE-Tag: 1784853261-800434
X-HE-Meta: U2FsdGVkX18Vv8wYUDfo5gf4mqaDDjMQrbNRrKc3/ke4jJ0bfs/+mjxQgHeuByHnRy+RVqTtnhquAhkM49O5Vqlm6Qtb3Z67QiNgBj+MBAx8Qb1Ax6bOhQfpdI1zIqDlnzMyHlT3nZfyQYVSFvgaj+0Zr4ZOJ7H2Y62gCOBrL+u7BN4GoIBVYnJ4h75TjJU+BC1SEcAcXeRdrpC2lwcbFLiUrDLZOqtXD2pfoStCTynlFEqvMkI6Ujxzmj7I8TrpUxdUcCD7sFzxyvAipGO9g3BSXPdMR7DBW+dA2hCC8bJbnYeK5jHNQbzK1z/OixxoH48O6RAC0Rq/IKKrJ0lqR0pF8TlXT21CXWyHg5z2WmJg1fHYfWe2hb7PLd2J6O9iaw5tOcW2rbd6lCpMBD9AJ02nvP9pvL7kV60ay4x+R9LCdDMIzvHA9RbI8Lll+I6+OC7+2H/cV1usUmPnUVfy/rcj2JymwdXXUFE5Vfm5nBCbfWX86Ux8iHY/1X4z9CDY3s5aG8oar1AWPNNz1rEeJ8uWz/0qJpd8+4IxNkaalT4vY4JaE24mHa25mSxjeKQwPF2oaK/w3+ylGkvClbo9BiC6x3sxhtEKWYx0GJqBkDlar5u/6y5ciDq4eIaNSfEp2ymfUvUmxr91J8tPpJ9rr4DNGcmwicSMAB1PzuTuKMTaWYdtR3GfGhS/sGsxQ4RHjvTI7k8SR5mQmgZiURV3ghChHo/WEMCLtbIwr7wH+VPK+ye+9I9+fohQ5ZPb18Xrd5UoHhDz7+Y0+ZwAwwWi7BpytypGpS/cwU1j5Tk6l5qJSOUNeC1bNjnWUwijNuQRYBBVM1qH94WLEuPrbAPN52RIGq+VKqDih1MzBdulSHZ6OvqcXxygfnuVLY6l7dQC6ReHgSp31HOHMBIGz6qiQi1To9AdrCRPc4bxbLoJtSCnjKC2dQwbEfj7gxLYsGmLyvQzx1yJCfGJavFuVmT
 J9gPxqPO
 4Bz3ClUfD8mrnkRtGSBj0EaPcU4a0RL9dqj3OoG2PasxYXnFKzddBMc+85XULJ0ZIc94fDAKPS5PdpDELAk7z53gYJilOtA/lTODK0E1mWOXEp07n2teNHuQmPLHnnSQpD+drHVOg/iOdk0JlNv/QDaQf3apGv1I+y29eLuJoi0M9P5isFHSpyTEcsvZN47KzMgc1q98DFtAKPp+aPTWldI/DKe5vlAgjoLfD3WueigIK8LfUDc8Bye6L8BYCQIWO48afQEaTEftkhqFbmIskwLFGAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 11:24:32 +0800 Ridong <ridong.chen@linux.dev> wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The per-node proactive reclaim interface
> (/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
> but it is silently ignored when CONFIG_MEMCG is disabled. The root cause
> is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
> !CONFIG_MEMCG, and the latter never checks proactive_swappiness.
> 
> Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
> include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
> handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function.
> This is a prerequisite for unifying sc_swappiness().
> 
> Patch 2 consolidates sc_swappiness() into a single definition that works
> regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.

Thanks, I updated mm.git to this version.

> v3 -> v4:
>  - READ_ONCE() was missed when reading memcg->swappiness, add it back.
> 
> v2 -> v3:
>  - Simplify mem_cgroup_swappiness as suggested by Johannes.  
>  - Rebase on the next-20260722

Here's how v3 plus v4 altered mm.git:


 mm/swap.h |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/mm/swap.h~b
+++ a/mm/swap.h
@@ -105,18 +105,11 @@ extern int vm_swappiness;
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
-	/* Cgroup2 doesn't have per-cgroup swappiness */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return READ_ONCE(vm_swappiness);
-
-	/* root ? */
-	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return READ_ONCE(vm_swappiness);
-
-	return READ_ONCE(memcg->swappiness);
-#else
-	return READ_ONCE(vm_swappiness);
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
+	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
+		return READ_ONCE(memcg->swappiness);
 #endif
+	return READ_ONCE(vm_swappiness);
 }
 
 #ifdef CONFIG_SWAP
_


