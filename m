Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D41D30CDB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 22:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067926B0088; Tue, 13 Jan 2026 17:01:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016686B0089; Tue, 13 Jan 2026 17:01:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63696B008A; Tue, 13 Jan 2026 17:01:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D35D46B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:01:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96A741A02BA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:01:21 +0000 (UTC)
X-FDA: 84328312362.20.4A5D9AD
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9279D20009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:01:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=a9HRVjTd;
	spf=pass (imf03.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768341679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFJSz6HWUVroy5Xeu7AQq6OJ493rMP5IhTgqTexfW2w=;
	b=p8XN7tO3rFpxg9bLBgCeXRueNh0HaImSTyCwWHp6/bzeKmmTKo56V+f5Ot3ArVZQiPtt75
	mZ2r+2jVXjPguFlf+nYtwB2SZfRXvMxt20fZXXXJ63qeZHLGSZv93G2huyu2nygNFzG44I
	1e7guWKSewIVKZfkMP4Ms9vmM3HZve0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=a9HRVjTd;
	spf=pass (imf03.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768341679; a=rsa-sha256;
	cv=none;
	b=ocExOiporGBxm+xxdDoU68cNbbQZgL4aeeScfxQyUfkBTnUxivBzRQUrUPKV0ieX5rgTw/
	cDhiYBV+TPdiAumPqKUzHk3UnukSGbgehxS/OI99au51R2BATeO5G1JdeqrLaV8b1JTjq8
	iTV65FXX+i1s4qCR307Mh1KXPDIDvyw=
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DJ7cQo970108;
	Tue, 13 Jan 2026 14:01:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=qFJSz6HWUVroy5Xeu7AQq6OJ493rMP5IhTgqTexfW2w=; b=a9HRVjTdtKCO
	qhYRLwS050zCl1IeRph1U0HkB2sbmOicaN1r6fntX+P1z8iiAyUZpp1WqJTrFWRM
	DpmkaFQEgiM9ibecfBRASqbhxZNvuUU5ddTeVGoMlbqL/RvjTuNP71sX5jUagX3f
	1rHGQTe1Qi4fvSPhPnYEAWGxzPworvnBbfSM97mFBJiGiUAND3BTuM3gFDA+L2ea
	3w8oFA3EWQsnDAehjDehdruwZBl5UvvJK/n7P5QwI+xvVCnDUfJ886nEvIWmsnfR
	yfU2buf5aWgt0p900yK0re0M03DUNP5MUFVB17pdUcWdd3SX7p3g44BxNCcH+xLe
	BDgwRKrhew==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bnuxc1hw3-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 13 Jan 2026 14:01:04 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Tue, 13 Jan 2026 22:01:02 +0000
From: Chris Mason <clm@meta.com>
To: Qi Zheng <qi.zheng@linux.dev>
CC: Chris Mason <clm@meta.com>, <hannes@cmpxchg.org>, <hughd@google.com>,
        <mhocko@suse.com>, <roman.gushchin@linux.dev>,
        <shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <david@redhat.com>,
        <lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>, <harry.yoo@oracle.com>,
        <baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
        <npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
        <baohua@kernel.org>, <lance.yang@linux.dev>,
        <akpm@linux-foundation.org>, <richard.weiyang@gmail.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 4/4] mm: thp: reparent the split queue during memcg offline
Date: Tue, 13 Jan 2026 14:00:43 -0800
Message-ID: <20260113220046.2274684-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8703f907c4d1f7e8a2ef2bfed3036a84fa53028b.1762762324.git.zhengqi.arch@bytedance.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::2d]
X-Proofpoint-ORIG-GUID: JjIO1_e8ho5mXlIbvHaG4iVAEGRmmuK7
X-Proofpoint-GUID: JjIO1_e8ho5mXlIbvHaG4iVAEGRmmuK7
X-Authority-Analysis: v=2.4 cv=ZfwQ98VA c=1 sm=1 tr=0 ts=6966c0a0 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=968KyxNXAAAA:8
 a=v-Gz4QzHp4V9PmqzfvMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE3OSBTYWx0ZWRfX4ckwhbLA9Bim
 jNqv1Km9MpjYJlz0/8inX1dUbSk5CpyBj2jckX24emS7wb8CzcsBhQxzhgxaNwQ0SvflJWONVTa
 haUN8rx9VJcqUhRcYT0mY1gmej2leDsFntn/Z7cTq47RgkuYtYT1XLSoIboxipSEo9VY2t3jOlP
 LnGT9eRnbIMbX1OxDg4cRO5SyBBc+PkBmCrPgQTmVJFrCLFWomL1BDom7mscs2pA9H2TMWIaXuT
 XAYuSs0iizUtkFPG9+ltZ+Qpj60RV5AolvTdlHiRLyqvCVpdYr93qDpWrQqWieYD0NlDtiU5Fs3
 Hn2jkzQ4wb1rGeYu3t8ogIIXOiLOUNPXPyyezqothWAIC/CnZCbMwySgrbsd3oCJwW6Ed7O6Jei
 njb+Z7CxulHf6wpXrLLISbI7tiH0kxGpI939sbTyArq09/n2AU5es9ZsBTiH5EOrAwIUh2XWJBH
 tO8MFZWr3hxa139TAWA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Stat-Signature: mojjunjpt464tsbghnetfz8yt38uk9b9
X-Rspamd-Queue-Id: 9279D20009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768341679-638135
X-HE-Meta: U2FsdGVkX1+Sf5IvvLduXjRoZw3fq13xXHyEuSr7uO/Oof4yiSqVUj3gfHhlpWF0c3Ps/QFL9ig2qrE+ZLsMe92LqglUec6z6aZgXtSyEqtoorXKJrPI8zGqoTxUNXwt/yUFDLffYIdkSMgyqJDriN7kWWRUaJsam+636sgnL2SMUjSXyuQC+cil0kmkH59XohWVMiuFpf/w3PBnx6S5WXJ+BCyr4/ZlybW20qfdm5lISLYlMxGnNbHgpTLZksgSb7MSAZN9JPzwX3oNlHXyQW0iI8sZoEz/WDR4yX3YwU6qJoia+hne6LjYhoD6LnwSqJ58l90dgKF5QeLatvRZC3/NiwsLcpqDjANLLtc1xmOJh0dB/xjyLU1JZEiUtroWFveJFC/rlhubBCj6ZDOhKbOJet+i9lnv4xr1MJ5EIFovu77XpP1zQVvotKfKN2v1OJtM+s6khAsh07+RZfc6/QNBZF/9/SFA3EO/oRfOL/3+0XNEIAslPduH5d1uKFgsn7hHrleXNTrMdUGtMtSL2pKhVpXSKQWaDAKwNUG+lQmQmHJz5e9hu6zZ1mo+jeFN7Zl3aV81UlaIf9tEwwF5WFLV807o6x3KYBwkqabgqxEZwwrbOwTpJpDc/lvgCtAij8jmdf/8/AwQx9xIGhDaNvRknzOQnDvfzei95d9yj+Jp49nndLTAtPttMDHREI+yK2DsIOjaCvyDHzDPLsoAzWF4qQxENFOKLZzwWvNH4GC3CvJ1ccesvm5tUhx6mPRRoxMBRBvptQz/ssoYZcAJOvrmCIYNjgVCAtmu2EmTlPyqVW7MkJwRCQtojPr+sQLDGk+6KcgHklgF+Ud4l1+RjCAeFDS0CCws6I2S/rpQQe4P+BoPwjGDcQg0IoaJJUOAuRjGbeY9cllam/DYPW6IcbCkY650QJxlIp0cNXm6rjuZWJgLhuN7nKEhbmUpM4dMb3kjBTfcE0xJ5TYOiOU
 fcBp/YxM
 Ru5GL9yzLxYyXS56YkZl/mIKiw/NoMSnDdruO1y93OrJhM7KFrwQSZ+NUHHugEE9Wm48IEPxXnlIa+A0mc/FnLfqwNiFF2dj1lLUmRZSSMZXitbXj0Rway0KAKibOXq+KKRAI8ZhWmZAgmPOCzQEjCwZMg+utZfnvazvyPmNa+TJ238OAJzTbMMn/pE8dUX54HZ5aOszhN+7qTPGAO/rqc21nEjUI4m73J/dqD5gISb7wX68DLFoVsQRcG5johaZuq3iK9inqZKueknE9w8SjoXVKMiaZwQhUD5N0d+DMYPJYK6QN5IOgx32kiy12JbEJjIOpQtBT8GmcRtjvYBO++mN5n4OZ7C31q6QgbjcqnQTPt9uuiqDp9WbOGRl5B6pO7RG5M0Auoc8P/NppDLqWdQmeHaa7xDF3/USHC9hmmGmnbIG9Djy3b9RfKmZLthKBJ1t8u7FJzVWhKw28wtXPA8BqLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025 16:17:58 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Similar to list_lru, the split queue is relatively independent and does
> not need to be reparented along with objcg and LRU folios (holding
> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
> to reparent the split queue separately when memcg is offine.
> 

Hi everyone,

I'm running all of the MM commits since v6.18 through the AI patch review
tools, and this one was flagged.  I'm much less confident in this report,
AI tends to get these races wrong:

[AI review output]

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b0c6a4635c67b..cc6db20d7dca0 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1775,6 +1775,12 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
>  bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
>
>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
> +
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +	return memcg ? css_is_dying(&memcg->css) : false;
> +}

[ ... ]

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 13684e5376e82..d17d3810a882c 100644

[ ... ]

> @@ -1129,8 +1140,14 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
>  {
>  	struct deferred_split *queue;
>
> +retry:
>  	queue = memcg_split_queue(nid, memcg);
>  	spin_lock_irqsave(&queue->split_queue_lock, *flags);
> +	if (unlikely(memcg_is_dying(memcg))) {
> +		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
> +		memcg = parent_mem_cgroup(memcg);
> +		goto retry;
> +	}
>
>  	return queue;
>  }

There appears to be a race window that can cause split_queue_len counter
mismatch. Between the time CSS_DYING is set (in kill_css()) and when
reparent_deferred_split_queue() actually runs (asynchronously in
css_offline), folios can be unqueued via __folio_unqueue_deferred_split().

In this scenario:
  __folio_unqueue_deferred_split()
    -> folio_split_queue_lock_irqsave()
       -> split_queue_lock_irqsave() sees memcg_is_dying() == true
       -> returns parent's queue (locked)
    -> ds_queue->split_queue_len-- decrements parent's counter
    -> list_del_init() removes folio from child's list

The folio is correctly removed from the child's list (list_del_init is
self-referential), but the wrong queue's counter is decremented. If the
parent queue was empty (split_queue_len == 0), this would cause an
unsigned long underflow to ULONG_MAX.

Could this be addressed by checking that the folio is actually in the
queue being unlocked, perhaps by verifying the list head matches before
decrementing split_queue_len?

[ ... ]

> @@ -3920,6 +3920,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  	zswap_memcg_offline_cleanup(memcg);
>
>  	memcg_offline_kmem(memcg);
> +	reparent_deferred_split_queue(memcg);

The race window exists because CSS_DYING is set in kill_css() before
css_offline() callbacks run asynchronously. The comment in split_queue_lock
mentions that THPs will be "hidden from the shrinker side" during this
period, but does not address the counter accounting issue when folios
are unqueued.

