Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E24ECA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447706B008A; Thu,  8 Oct 2026 05:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9016B008C; Thu,  8 Oct 2026 05:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6FF6B0092; Thu,  8 Oct 2026 05:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09D686B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:39:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B8C2C04E7
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:39:42 +0000 (UTC)
X-FDA: 85298961804.09.358C6B3
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf28.hostedemail.com (Postfix) with ESMTP id 771F0C0004
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:39:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YQq5UsJq;
	spf=pass (imf28.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791452380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IJ4lYBRnOH1ELDqm8p1BYesqSHem4oJyVkCQ2OMYXU=;
	b=vQ/axN+fKBQKwlAcpVpFdcGGTpcjxQzZtnezlsrHqj3dNdmXbD5REBqjOPPjKQkuAylwhU
	EYzEaNGTS+22cxZx+viWbsKQMLcTzHhmW8tL9qjyfHLXVbNYCHu4FT6Kezo3WHZJipoy+e
	xsFLpoRwEZKKreUA3r1mDOQZrKSC2YA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YQq5UsJq;
	spf=pass (imf28.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791452380;
	b=URcDo683M+166gwp2H4jeuPNZv24W07KZyPyL+vLG3xZhGwDhzZsBLndX6CIGTYg/z8lX3
	WPneBKTMrzK8f4Sp3LIpQcmrgM+jVflaleDM+LZBz3F/wQVOpB4PgYX82+vmZAShQPRUi3
	j70lHdoYPksczT6MHKj4A17r+U2IIO0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791452374; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4IJ4lYBRnOH1ELDqm8p1BYesqSHem4oJyVkCQ2OMYXU=;
	b=YQq5UsJqvLuF9cPvHB9ifkDEz4LR5bBIHweK63UYikOIe2SXUL8Eb4Cg2ytsIjoUuJ0nsOLcQMeh7EpHFOK/ZLB6cr6daCdgSRv5iBmzGuwi82MLY5Ck+01UHusPtsFwEJpWdKQ+aOWdu2fP7227suX3UXrKOjIp6qZe1SGDumQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XCNdeuW_1791452367;
Received: from 30.178.85.189(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCNdeuW_1791452367 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 17:39:33 +0800
Message-ID: <01f89ece-9d46-47f2-b660-d32ab5d32923@linux.alibaba.com>
Date: Thu, 8 Oct 2026 17:39:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: memcontrol: drop kmemcg_id and use
 mem_cgroup_id() for list_lru indexing
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
 <20260910080722.3961351-2-qinyuntan@linux.alibaba.com>
 <CAMgjq7DkLi7aPLRyGv__f6NLPkRHY=0Fw0kLEdevnoTFpqsbzw@mail.gmail.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <CAMgjq7DkLi7aPLRyGv__f6NLPkRHY=0Fw0kLEdevnoTFpqsbzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 771F0C0004
X-Rspam-User: 
X-Stat-Signature: smbqb4c8ag4aip9418skopn6sxbxm1kb
X-HE-Tag: 1791452378-564190
X-HE-Meta: U2FsdGVkX19oedoGkbwaSJE1iE9dPMLTNwOgx1HyrRrhZ8S2EWRRy3sKBhH/1taGH8lnvZTjPWbxdSR0zLWape6fieyyCYIPy6tT8Rf8tqyt1BOEAPYG20/2RkiM3BViyCaMIidylS5e3do1Jlcn4vTVpt1Ow91uceLuZD3hMZufTVDlqp6kbw5zfTC5s9irICk2GYLpUaMBk0uWMwo+l8EvEaONvaTFZ8hdPDXtbFZJwWL1GtJfCzZWTnVDT36iNJ+2xC0WTnZTh0LifTYqQv1Vf0AFlxDZXdLILFTS8CF7L0QSKjWLczLHOIA/xGZS9AijAA3ygfBMJhPJmdCXVdzOSlLUV1LDJ2DOl+c3M7Iu5x0VvJV8Okg3XO2tYjIP26HydP4zK0fMpBzlgYoUBSxVAdbTUaCwmZt9B81XNqTywAwi6lN1Lu+4UUfaXWOfCfABOJsu49nCr/E/8xmGOsr0K1I5V8e2Y+BtcLcvgT3qvsZgeGOOeC4OCLVUEJu9T+Xbjr7617vw/8WFhIgEmPcHcvOEawvn352/XzUMukKz4kLLaj0gXco0m4VTCRPmmq7X26H2NJ7ApRECschFPaNADtDCOAoejANpH9hHo12JX20vK7k97N6JEyp9oSMaI0fYGFNoE8s2GdELqph6thHmTpI59xyJFglEnxSUHO8mRkccnCir0r4wcqI1Sr54K0/+7+a0EtPxMMnf19+hepKWN5fjTmZIenoEE+da7cVUVUMekJtJgnhThS/Y7Cc8eo/KpmGGNMUnm28BSoYwbnY8/PYAItf+WRwy9SKaHpQXoP1ADUYgOv9KyBHPZyQ7CMuW3GZF2SgsvjCWJz84oiF0LwIDyNzCHUWKOragg7MeAUwmubj+J7zL21sY9L0vHsSRUZ0mpR+MctjhYxUtf0oHAMvUURn3L5o4i3JQgfe79xISbpBiFI7U08LlxPjWq+0Vriz9HB0+oxVwjbc
 Nkm5MX9r
 /12F2q7aTrkUdqQYdFis46inxn6E4ARp0Nt8cp/mg5zilfVY52HWfSDg2B6yxY+cSYbz1OzazMQWJo+jgFIgnRXAuLXPPl8JSBJJlN60n3VgkQlpdPsuCXX5Nyy36kxpQC+W9FtMjfSCoiK/T/JrIpINO0EkyaBnONklwBiDslgvEdH9+S+9/oaMhgqjQHeTKXh9C/Gh1PLcwEbURyTwDcJX4erfzzmN6oF8FnOl7dX+bMUZbFS2CLcT15hiaAhE8A5N7joVVT40yRSET/Lvc//q5FW9hh3m3eskN9WE/NY+Ohqajn8TgLpDOT+2gRcsOP5GUDAVCTkj8xNl39SAHPOlHN5s2o0lKSnTWXBZOd9FLnxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/27/26 4:29 AM, Kairui Song wrote:
> 
> Hi Qinyun
> 
> With this commit, my arm64 VM hangs at every boot with a
> 100%-reproducible infinite loop in xas_find(), driven by
> the dcache shrinker during the first remount of the root filesystem.
> Reverting this fixes the issue:
> 
>    CPU: 2 UID: 0 PID: 579 Comm: mount Not tainted
> 7.3.0-rc4.orig-00725-g09d9672a5d4f #33 PREEMPT(full)
>    pc : xas_find+0x184/0x1c8
>    lr : xas_find+0x6c/0x1c8
>    Call trace:
>     xas_find+0x184/0x1c8
>     xa_find_after+0x88/0x120
>     list_lru_walk_node+0xc0/0x2a0
>     shrink_dcache_sb+0x80/0x130
>     reconfigure_super+0xc0/0x1f8
>     vfs_fsconfig_locked+0xa8/0x120
>     __arm64_sys_fsconfig+0x280/0x33c
> 
> Just for reference, this also fixed it:
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 7dbb6125cb1d..42c48c3b9235 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -427,13 +427,13 @@ unsigned long list_lru_walk_node(struct list_lru
> *lru, int nid,
>   unsigned long index;
> 
>   xa_for_each(&lru->xa, index, mlru) {
> - rcu_read_lock();
> - memcg = mem_cgroup_from_private_id(index);
> - if (!memcg || !mem_cgroup_tryget(memcg)) {
> - rcu_read_unlock();
> + memcg = mem_cgroup_get_from_id(index);
> + if (!memcg)
>   continue;
> - }
> - rcu_read_unlock();
>   isolated += __list_lru_walk_one(lru, nid, memcg,
>   isolate, cb_arg,
>   nr_to_walk, false);
> 
> ===
> 
> And BTW cgroup ID lookups seem much heavier, not sure about the
> performance impact.

Hi Kairui,

Thanks for tracking this down. I missed the reverse lookup in
list_lru_walk_node() when switching to cgroup IDs. Your change fixes
that mismatch.

There is a catch with mem_cgroup_get_from_id(), though: it calls
cgroup_get_from_id(), which only looks up cgroups visible in the
current task's cgroup namespace. Here we need to walk all memcgs
on the LRU, including those outside that namespace, so we need
a lookup without that restriction.

Thanks,
Qinyun Tan


