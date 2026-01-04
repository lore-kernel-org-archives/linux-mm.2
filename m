Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F56C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 18:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638396B009B; Sun,  4 Jan 2026 13:27:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610386B009D; Sun,  4 Jan 2026 13:27:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D856B009E; Sun,  4 Jan 2026 13:27:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 413866B009B
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 13:27:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE00E14120C
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 18:27:49 +0000 (UTC)
X-FDA: 84295115058.15.3EF1EDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E339840005
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 18:27:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZDCFqu9L;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767551268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TiAUC0bp7AM7FYgKFgUvHMqTAWhCJawvo/Gzj0nrbwY=;
	b=P2oAGEP9UK98I/M29pRdiIWj99nQMG3PJ5/DpQx8VodZhqPtKFRLkAITuU6HcoXrsEQtPw
	gLPcCNMvE7FKMHKRkbNQkIv9N7K+hKbrX6NiNEuoVgC1wX7MfC52mmqwYb6jaGXOAy9I0A
	xAXnfy3+xHTlruwmkJ+rKQd6rHTmtzg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZDCFqu9L;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767551268; a=rsa-sha256;
	cv=none;
	b=zkTCqKb/qRiLDmLBpcqjiM8hmIUO4Ckj/Q4woT0cG1qCLWapyRGsS5cO6EUO63fI+UD+qn
	97gtbUSyFA47uXV1mdlW8Vo/SIHiO42bxYHlQy+TqCImUK09GgqnwKcLU6EpPZiZDVoMDh
	fMQnfJeobli0fYEMeHv+vIufZ+9h3VY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80A2040317;
	Sun,  4 Jan 2026 18:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE170C4CEF7;
	Sun,  4 Jan 2026 18:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767551266;
	bh=ncBLtjyDgpOU9nUGlYr/lR60bzhWGn+9CqIvEOL0bQg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZDCFqu9LkYtIhO1nOFih2qPFuzrbgULNTICSEuJzXgTv0atk0QwQhewhTZBIhtbYq
	 OnDoQCNk+g8uOFfgdbhr72l1zUocTUsaDoS6VLSnSg/1623eFWM2W99/ikh1C8O+7X
	 M7+l3ArIO6KJeeM7Q/7qhB2IxduoGupzddf7bvq8=
Date: Sun, 4 Jan 2026 10:27:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, gourry@gourry.net,
 longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 tj@kernel.org, mkoutny@suse.com, david@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 axelrasmussen@google.com, chenridong@huaweicloud.com, yuanchu@google.com,
 weixugc@google.com, cgroups@vger.kernel.org, Akinobu Mita
 <akinobu.mita@gmail.com>
Subject: Re: [PATCH v4] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-Id: <20260104102745.cfd4f6bd661e8e817afcdba8@linux-foundation.org>
In-Reply-To: <20260104085439.4076810-1-bingjiao@google.com>
References: <20251223212032.665731-1-bingjiao@google.com>
	<20260104085439.4076810-1-bingjiao@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E339840005
X-Stat-Signature: m345sh6ba5xs3cr1urpy56yogsqgcyhy
X-Rspam-User: 
X-HE-Tag: 1767551267-956088
X-HE-Meta: U2FsdGVkX1+/yZJWvhwCEsls8RtHa3SSH5WmPDKDCziHhAoa6Ls/olrWS8q1W2/jSCe2fI7v1rVujXKbMCwSUMh/1cWVrpZ4M5OCAWgzFqXLZEHecL98hjD+nVK2j/bwSFR5sFENWRPipFC/56flU7mzRvtK90gt7GqTL8U5vKiq9cc2Ouchw6MawerN96UqH/iAFtYUr62hnxP1NjpNDhGCjUFCYLn+jfmZ0a0Avmda5K088nT6RdPTdUNVNUvWkwzoiGr6k+fdlms6DKF3Qug1I5oooQX84JFvEsV4njS4uFx+/Yx7pATaoYe5PoEx3CYeQ40dEIkUbe0ADzZ1pM9XCusXhnUJJ77l/AmBXybrbbdvY/Fy6MO5wdvk6x68Lr4i5mSJd4yAaGWGqRhBK5tA5qUPJQMzinfGXrR7wei79d84TrNzM/DOfpqCNsOl90CNooNh/pZIZ1tgkzk6u+Dy5vgq1H9XZMB3vgwYAK0cQrBYOgC4NzkmGhhtwC/UyxySdUSDUBRKQcmP0vKQ0ehbeRYPrNSZnmYK9AQ3rjqsLpZ0489OmUWot47fG6VbXEv2j1TtuENVimwqwAEnv21uuZe3tFrz4rgz1IGZsi6AvvNpFurB9D9o84WZurFTz04d1gU8WQNAASeKSOSANUDkxU9jb2lvaB2Mb7FkQ1bikmYlYrXTpMMVPBOLn0VSxw3PaErUVrwr5xAh9qSTU30Zp8bBjXFD1PfyWd+O7buW/h0xPl4phcnXkORaSp4I2BL0nEbwyV1DL8gin4eGC8BF/ux76Bq7YsLrsrCwt417USp+nLgp6MmcdyyrmBPDgzDLfdAO2EEdvK/74k5ECytnv0lTbfgk6hzWSOhjfeQxNB6dune6UQbfpC8obp+5nfi+ALkEP2tfgqGbMj8OGkWl9D6S6GikLl04uge4fHP/NVMcQjK5QIcSs6Rf/4XwXQXzm4RqdPi5UKBJOff
 sEXanE/q
 hGAB1yNvgHClkrIvjEsXykFY/QKyIeIwztRE17SxLRJL6REcl2uO4c/9O1eZAU0LogHSYulkG7L2ntTV+x+ftUxkjtm9+7i8REcAtqpvQ1oFMmcHNf2EbWNuU5gG84ptUz4par89VWIQx7OTe5rYPnIcgdNn/AuW0yZnTj+lyfejl6nBbMto4YEdZhE79QXxwVqHarHtjoMbaqA2qGaQaeN+zgLFDtCCy1+aepSryA5k/dRCWN6kYbIgHjjU3GxgrAkHKI144vqAykragnWvXishZ82is4+Q85s9tO74qK9Oq3c6zcVM9XFlN5VRk5LICfKJMy6i/jYokfhvchr5KCeTwXxeVPyqpBPP1HV+3STqguFSj9vreuEmDNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  4 Jan 2026 08:54:05 +0000 Bing Jiao <bingjiao@google.com> wrote:

> Fix two bugs in demote_folio_list() and can_demote() due to incorrect
> demotion target checks in reclaim/demotion.

Thanks.

> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to
> can_demote(). However:
> 
>   1. It does not apply this check in demote_folio_list(), which leads
>      to situations where pages are demoted to nodes that are
>      explicitly excluded from the task's cpuset.mems.
> 
>   2. It checks only the nodes in the immediate next demotion hierarchy
>      and does not check all allowed demotion targets in can_demote().
>      This can cause pages to never be demoted if the nodes in the next
>      demotion hierarchy are not set in mems_effective.
> 
> These bugs break resource isolation provided by cpuset.mems.
> This is visible from userspace because pages can either fail to be
> demoted entirely or are demoted to nodes that are not allowed
> in multi-tier memory systems.
> 
> To address these bugs, update cpuset_node_allowed() and
> mem_cgroup_node_allowed() to return effective_mems, allowing directly
> logic-and operation against demotion targets. Also update can_demote()
> and demote_folio_list() accordingly.
> 
> Bug 1 reproduction:
>   Assume a system with 4 nodes, where nodes 0-1 are top-tier and
>   nodes 2-3 are far-tier memory. All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Should respect node 0-2 limit.
>     # Observation: Node 3 shows significant allocation (MemFree drops)
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1
> 
> Bug 2 reproduction:
>   Assume a system with 6 nodes, where nodes 0-2 are top-tier,
>   node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
>   All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Pages are demoted to Nodes 4-5
>     # Observation: No pages are demoted before oom.
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2
> 
> Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> Cc: <stable@vger.kernel.org>

We'll want to fix these things in 6.16.X and later, but you've prepared
this patch against "mm/vmscan: don't demote if there is not enough free
memory in the lower memory tier", which is presently under test/review
in mm.git's mm-unstable branch.

This seems to be incorrect ordering - this fix should go ahead of
Akinobu Mita's series "mm: fix oom-killer not being invoked when
demotion is enabled v2".

So can you please redo this patch against current mainline?  And please
also review the "mm: fix oom-killer not being invoked when demotion is
enabled" series to ensure that things will work together nicely when
that time comes.


