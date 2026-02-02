Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFC6E65293
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18656B008C; Sun,  1 Feb 2026 23:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C64C6B0092; Sun,  1 Feb 2026 23:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2AD6B0093; Sun,  1 Feb 2026 23:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 794EA6B008C
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:15:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBA3013BF86
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:15:15 +0000 (UTC)
X-FDA: 84398201790.30.72258B1
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1FEBB40002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:15:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bZlNb6GN;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770005714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvtlAMLtgHm63VCI0lv5mAl1ZFv8A9Ibz2DahGIKhtQ=;
	b=FbASyBj6GIW3Ceo1EQu3JLMAM0iB5Ydexy5qsW7YRRpfUMwH0Cwtzc2tzBYfjkEFOISDrO
	HGuKZ6KhRHbL0B154l7ypNRhr7y36DtT6LwcUY6x21S0jrpIUnb9yv0bUcWh1VbXqzqn/m
	vqRG8B/SUUWeV/oDy2f1QsvM/UrNbKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770005714; a=rsa-sha256;
	cv=none;
	b=q7hEt13RaBCa6i0Jv/bb1/YmGzi2M9/N4wwnLL6HH4mRBumhIGuBjRXsWxw480fkVR2aRc
	hGUgQqrtZq1loP2kXbEc3MceziQwYrG64k8yKZMoW6qjxK/kTLP8gdvMO3opals+TpYB1k
	lJurJzH21QnKWqKDFLt2w32RKHvAKhc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bZlNb6GN;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sun, 1 Feb 2026 20:15:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770005711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zvtlAMLtgHm63VCI0lv5mAl1ZFv8A9Ibz2DahGIKhtQ=;
	b=bZlNb6GNNV/QTypPFLHskbMbyUuYpJXjrBAvd2OIlM6KKtLhufwy08CcTMwVumVlTqlXXW
	3Upk6ZTmHjt1ZYCw2nmoz+AELoMAyW4BA49n1b8r+sohZns5a0EcBeyDXA5gE4DLCJUybx
	AFIVdhd4xYJ2m7dyU/j1rhBqRW1GPaI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Bing Jiao <bingjiao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, tj@kernel.org, longman@redhat.com, chenridong@huaweicloud.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 1/2] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aYAkqsItdd1x0jEE@linux.dev>
References: <20260114070053.2446770-1-bingjiao@google.com>
 <20260114205305.2869796-1-bingjiao@google.com>
 <20260114205305.2869796-2-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114205305.2869796-2-bingjiao@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1FEBB40002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 33erec5foziumon6ww7uruqya58xxkq5
X-HE-Tag: 1770005713-850292
X-HE-Meta: U2FsdGVkX18y7rcF12IKOXuSIoeFKVn7mGDErExndpN/K4isXBIQVR+4KlVYoPbJKX7uojE3L/96X/wdLSTiV/4q5EoYYCaBiUUTh1pVXneDZqUmkQ6AaM0i3UL2FUs9jqMme/5E576OLGQ+APpTr3haK6Yy6oEJrQ9Cyyh537tBj8X3+VKZMZD2JwIrJfMffmkSuLJCHjrUy9Kjp7ZN2IBv76nJquSUu+dBFEZNFgrtLOIp0ouqocEOeO7EtJKjJY+5ZHgpJb5Ueq1r1SdJl/P73M/Nxz9vsTVR485hQfbQYKSw97xskyygL+8YsyarN+psffy+ZNygTnC6yuB8+4yvc5H8yybTuxIB2EJh2m+itAf3EVg8shX/Lwgs9mas1B3QSDeHnF9/GsFMxs6ni6yOVpopR/ogjbSvyjWcrsZy8fiJT0/7KWeFNUB0wXrT+8tmdrceA1Voy4MzlwVnDMLsb+uj0BB2sKOqQl2ltyS+psytXfc0W5G2/A1u1Pc1d8hvl7RrmzS9NyX4T9GfeCyVq4sZGb9w064wbog2oxp0WPOo/ne/56lBpVQN61X17cnHEzr99shqW7o7NzOrrKk+d81MWhOpqkEMth0q6kNnh9aNQvvZwRKzaDYK5TSwqXXhGnDMLmFefu7AMcWUAakz2IfYStROPRtw9sDucr1tKwuhUkdeyzATSSLgaC+QQPtfAHG3oIv6nIEbS7Bh7KYUtBpf2s0WkksrJIhXCcTFU2xeHmrjqTxPlwftfgCA3RBwzWaOqB/mHX1MeExqwCWgTrBetwGoGd9JKqP2taJD4QdQj6bl37O2ELOinjnJugiSw3obKsVUyeLUU1rtxnyqDw0PUJdoLP5hRAsWsohLwBtaFpxIksBIbNh8Pw7em+dcVJm3zoAFcy6cYCQiaj9tCasNW1Yjj44tr1ozEfZ5mkUUFvgZ0sjHnVjI2yMi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 08:53:02PM +0000, Bing Jiao wrote:
> Fix two bugs in demote_folio_list() and can_demote() due to incorrect
> demotion target checks against cpuset.mems_effective in reclaim/demotion.
> 
> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to can_demote().
> However:
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
> These bugs break resource isolation provided by cpuset.mems.  This is
> visible from userspace because pages can either fail to be demoted
> entirely or are demoted to nodes that are not allowed in multi-tier memory
> systems.
> 
> To address these bugs, update cpuset_node_allowed() and
> mem_cgroup_node_allowed() to return effective_mems, allowing directly
> logic-and operation against demotion targets.  Also update can_demote()
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
> Signed-off-by: Bing Jiao <bingjiao@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

