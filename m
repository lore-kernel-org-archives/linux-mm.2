Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73A3C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF256B0093; Tue, 11 Aug 2026 02:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0F36B0095; Tue, 11 Aug 2026 02:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6AC6B0096; Tue, 11 Aug 2026 02:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88E966B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:26:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EC64C0334
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:26:26 +0000 (UTC)
X-FDA: 85088004372.23.717ED2B
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id A02A6C0003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:26:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZMSFg7rO;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786429584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrvIDI4l3ibJO+y9A4q6yHaI4leghzx/mVJIb4ZQWF0=;
	b=8aTGwRrnZi1AMY/PA+yA+y2O0ImTSfNEmlaaR6W+yT9mzsrgsj3vscLu5aIjMpmA+zc1ii
	dfIlEBX0AxiNX/gOc2ovUupjOiaLDKXj0axTZxZrTdgsHMQlbv3GvBds35ngjAMhGmVuoe
	MczxAHz+TQCY5rLk2TEVLEvcOeOTD6o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZMSFg7rO;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786429584;
	b=YfyVDYpnLOoUmW2B2HJg20xJ4iPWoFjnQoZOyPirHxRKu1ehDizgcNOsE/NdBJV20G9AwW
	poO1cr7/7YvYxt3CWRlbUtGABb2PlslL+tVfoDZfzN6aXwXA6MJ6SeTzaBYpqSydebuZaT
	4eTDiGjDuZArNPwXHy5UCh8GuLiMHME=
Message-ID: <c2e8b6d5-e444-4fdc-909a-a928e0e8f45a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786429579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrvIDI4l3ibJO+y9A4q6yHaI4leghzx/mVJIb4ZQWF0=;
	b=ZMSFg7rODBkJTKpJce/kKymt/vvKd4Si1DCFMJdlSBmYZBWa5h2iXhozUCctMzolwmOoHZ
	Yy8BPbkRSTT04rnxaf/kAAoWWUk7aqPtScK21NWYnDADO6FijO9fVdDoyRjbu4OpauPfUj
	i0zD/9SLnH+8r7/xeyzinBz4Mbf5PP0=
Date: Tue, 11 Aug 2026 14:25:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] memcg: keep folio's objcg same as its node
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
 stable@vger.kernel.org
References: <20260807142406.443516-1-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260807142406.443516-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7dh5eaf9y7t7epf34d1w9b7ucuxfwz8e
X-Rspamd-Queue-Id: A02A6C0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786429583-982276
X-HE-Meta: U2FsdGVkX1/xK5zwIvr8k45E3TFz2o9/PeDb/XMcRFJOUUQdRi+WfWU8BqU3Gn/FiwWcVVRFGxe1jSnZmelNRB8+oMGqGMymkE7cqAOgMd8f+HNqGphF4VXQpi5x10XMqb3Jz+tZHlwq5ILd2U5rHRIrOKNyPnLNuZcIN3KPv66zIc4PfxObH8E3rs3wYjt7GpkYzfhHQNkseUSEuYyRkNECeVeNZO0msxc1VUBssraE5Jcr5tD6v0/UsltnTI9RdxwqOWngiOFr6KQBRvyNtzcYO+McvdktNI8LJtdDy7Mzp0dfCpA9AF33S9pZLzq0FsmHZsArE3JIpgqEvn4lPFbm99dIW8fq6CDAnrNkueaKdjCiGhy/eOjGGeRsoyjya+R15b3I73RcKwj7tXKky7oN5GjF2OECeR452EwPXZa/JshxZ7fxwTTjdTTNyw1CwyfXfxyMm25N1TZy5CXu1RukOmJB+AcwkgJl2c2CowRBtHXkj1YeOJzRuhB745JAjPJfjvaNqonB/HLELhODnz6tvRoufvAB9oxNH773QMyzGucSU+FTQiPj04jU/inNeD2o4jh0wdnoXOd+Lpt7FW9/Op6t2DLe+ZZnRhD1kukXJNVExWwD6rRGRWLPi7JY2aE0Ldwy6D/wUL/6hpejWbpfhRFmdST3bjCyhNGgdSCf9UdzzhlkeokjPzkfYEF2Z4iqhFkK+7sbAfAGAqZXu4OgeoeUhXkGoWZPc4Q8ibpegGAOvniD9aTKHzuC0bJc1iDlgBqay4OXy+ckt3/kItecTJZRwoH9JADYPLF05ajkdTiaMfehl82rg7r7YlxT7eKtoXNxVI+mk+WB+6T+z6Pr0CMcYV5VjmbmsdsCbPly2ze9lv7kMqiQPU/hMVJiHdZJtey1HoVDU0drcTmN03x1w9fCowqNrj8IP1SdjWbje0cYw9nvu4I1ftj8PEX6Q5yyDwpg6n4g6RIU+QX
 MIpDG5WQ
 rauk7rXCJshQhAb13MZt/6x7Q/t1CyhxwpvMtt95IFc7JjnDNff89v68mv5lGSAbIFthmL//LeJCAfd0vNrU41FNcQZUqgtXhlx1PzUMAlFx87UNhwzo36XABfw77eAMOJSWj4ldHEU/hxyUFHyiIoMKxc8g5vH99zIfIDdPIWJo+yN6TQDaUyn6BS/dmYvcMm4Hc7GizY3UNU179qXL4YalaV9wqmIhxxPQ2bETBs/wnmmwWN9bgOQT4QrcdeAyjEtvFCH6Kdg8k5saHcws75jWWoU9hLracEjZNsW89NLt0O+T2gyeB9G/sjJYr0ctZLlj2yF/gLw8IuNDm6cX0iqSMyxhVErLO+9t4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/7/26 10:24 PM, Shakeel Butt wrote:
> memcg_reparent_objcgs() has an inherent assumption that a folio's objcg
> is the objcg of the folio's node.  Folio migration across nodes breaks
> that assumption: the new folio simply inherits the old folio's objcg
> while living on a different node.
> 
> Once the assumption is broken, the reparenting of the folio's objcg and
> the reparenting of the folio's LRU list are no longer atomic.
> memcg_reparent_objcgs() handles one node per iteration and drops all the
> locks in between, so the objcg gets reparented in the iteration for the
> objcg's node while the LRU list gets spliced in the iteration for the
> folio's node.  Any LRU operation on that folio in between resolves its
> lruvec through the objcg, and thus takes the lru_lock of the wrong
> memcg, not the lru_lock of the list the folio is actually on.
> 
> Fix this by selecting the objcg by folio_nid() at charge time, and by
> re-deriving it for the destination node in mem_cgroup_migrate() and
> mem_cgroup_replace_folio().
> 
> Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
> Cc: stable@vger.kernel.org
> Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
> 
> Changes since v2:
> http://lore.kernel.org/20260806165813.2526415-1-shakeel.butt@linux.dev
> 
> - Refactor common code between mem_cgroup_replace_folio and mem_cgroup_migrate
>    (Johannes)
> - Always commit the destination node's objcg. (Johannes)
> - In mem_cgroup_replace_folio, force charge based on committed objcg (Johannes)
> - In mem_cgroup_migrate, if destination node's objcg is root, uncharge the
>    source node's objcg. (Johannes)
> 
> 
> Changes since v1:
> http://lore.kernel.org/20260806061830.3294679-1-shakeel.butt@linux.dev
> 
> - In mem_cgroup_migrate, do obj_cgroup_put at the end (Sashiko)
> - Handle scenario where destination node has been reparented to the root but the
>    source node's objcg has not yet (Sashiko)
> - Add comment explaining the race between migration and reparenting (Johannes)
> 
>   mm/memcontrol.c | 100 ++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 83 insertions(+), 17 deletions(-)
> 

Thanks for the fix!

Acked-by: Qi Zheng <qi.zheng@linux.dev>


