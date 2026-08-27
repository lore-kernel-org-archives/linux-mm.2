Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A72C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 22:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF726B0088; Thu, 27 Aug 2026 18:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959876B008A; Thu, 27 Aug 2026 18:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848266B008C; Thu, 27 Aug 2026 18:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5A36B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:35:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF8AC1C0D9D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:35:31 +0000 (UTC)
X-FDA: 85148507262.28.4E9F6B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0849640002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:35:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p4dP3qdI;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787870130;
	b=xtbjKk58JMiV1A6sbh9YDh5GlQiMgsQzwrJR/JQqGxpzB8MtvRiqFxabg+d1AfYpdc8egt
	E1R89sOPl6sdtLgN9ggcyHL3vk7gdUIsLycvGVD+WCzvezQtoeiXWU+9VpOQq0+LjbOTl1
	1m8Vl+st+gaDm519WsZfu7Fyv1XuXIA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p4dP3qdI;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787870130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEGL3tkX29E+ZP0McEKVxJynzb895syCk3QM92mlNxU=;
	b=7OhIfx3SDjFzA6qE3VH4C15/T5p2yCpMJyivP/CDZkSVk3MS6XP5JIfxrQtngODR1jYudP
	/LsgGZ+B2UEworvZQs9MsGpA24yYTMRHbyFiBmUmnXSIqnIQkfXmbpHz42Gv8ANPgFNEnF
	/a+AEPXVUDzej/j5oTIr8jcTyDhre90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6565942E0C;
	Thu, 27 Aug 2026 22:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FF31F00A3A;
	Thu, 27 Aug 2026 22:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787870128;
	bh=NEGL3tkX29E+ZP0McEKVxJynzb895syCk3QM92mlNxU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=p4dP3qdIJCrBvW5kDTppeje6GliGUYcIFnG6Ywq7nlm4o84rRjlq0fUSIiO00MEyw
	 Sgi4r3ip95lL83gw1QmavrvRPLe5Et7gphzelVusOJVIcoKPDynxEl9O1d+Fu6cpKB
	 JZQ3QcFGoBjUtUGoyH++kybBReMBE1EdE7BskmfY=
Date: Thu, 27 Aug 2026 15:35:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work
 during offline
Message-Id: <20260827153527.e0e968a22717f558a22fb893@linux-foundation.org>
In-Reply-To: <20260827124211.3b94b103@fangorn>
References: <20260827124211.3b94b103@fangorn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: t5inhzngao6j5n5rqd6bonx3dx717f3h
X-Rspamd-Queue-Id: 0849640002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787870129-984476
X-HE-Meta: U2FsdGVkX1+1cJu9ukAhxzTSOjNaVtVPf561aPN4LLg7E9FxYvL+iwU/kkph/WDS2H0kSIt7GYxyuj9o8doEulXmhb47OiTRQiut3Keaf71U/ag48ilV004Hjw+B32UpLcIs9JY7r+T45djUfOk5IeF/0GDZetd/jJyQf+22CP4ZPNC93MhPhDEV5yZKVHFfsD7dR1UrfjhHVnOJEK9GzUPf+P+2ZZmHfdmWlGKcRdZ79TXg0pO4GtR662Jmd98+cvCG1J246AQDDmz2Rfi3BaOcKGU3W32rINQi3S9CZqS+hdov0lTG8EEpbOFwL/N2aFMAbRpcr+VKRR4vQNMROipc0v+FViPOtAhCn8W6EcredP7Hpm1IosCimrVPUgjsCG10aTfvbU0fxqGfh18ScEesVBvNTaO4MIuA7l5ug1xButFkT+X3ALXCZpvSpHLHi22+SG7wuE+GaeJfmX2KnEWMMeohG8589e5PCWYS8/0rpinBKjKj+zV7978N4zrqePOu8TLXIT2S94XCDA0z0EGq3L14y5JXLiY1Upx4WdI0MYDUMgN2edhaJ5RToWvUbkzvFo4UFNtgauw/lK9Lvawc77VLmn1W58LxSXx+jI70wJwP68fMmjTeSXHWHvGCol+DiVia05T/C6b1AJ/R1x3KGJ0jH4BcK/XSN2h9eJSl/wh7Uj7GOeKmi6x208KYmfU5iztCu0AtjfAx9f1hMngC8k5iXGUy4WTz/+yjk03GbzXN8HuIKWcyXjX3pd6YGgyBGSSLJF1Y8GkgcWCieBPSG6a21kV62qqoRcCV9Kd9exql3V7DE61JUqBb7rBGNpYVV/sF7rt0T7sg2d0PokpyNOo6x6saOk17Q4nGWyEM+P8vpwg5NK9UHUU1L0md5j5Ua1evw7lH7gRxS7dhFzc9OzJDTK2ZcQw32ez3hEg8WT3NpUIdFe0xqmgzH1d73N2d/z2lXqjbZx55lAn
 TiDMd3Z0
 X9sNKV9hBQJ84ajLfwxQz6O2XnIyFiWvQXBGobyw6vKPUgOSmHbNnv+TouKI9kZK1vZZ2etZh0Ys0su/rTVeWzfn2N9cRaRvLK+4a3L1nidNkd99kRxEXFylczrVO+2QUZd0JhlYtjtLaIuQoqfyX5fgyn7dxAleRbbhmcgLuIbXaKbjMKrgioCxQIa7gSKedxhTIs8rdiUT8zxpIULCLYvuONhusIku+nco/x6xTqMWZBsUqaNdePp1JFP/upFySLnJoxBFULKoSRAFlg6FiAgXig1lEbP4pJQv0xGkmWMmyiwrd9v8mFF23PSAmpjJyZlVOc4Oz+/6FSCz0s0oU3LUO7UOJfwu4uZzUbG5F2oh1oU28cbwI5VdZj7IhNvYZS0sWYqd6lwsLpUNhg3bWT5h7aGDQzkOZNHT2oT9NuMSnJut367LWEQeOvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 12:42:11 -0400 Rik van Riel <riel@surriel.com> wrote:

> drain_all_stock() queues drain work on remote CPUs via
> schedule_drain_work() -> queue_work_on(memcg_wq) and returns
> immediately without waiting. The worker, drain_local_memcg_stock()
> / drain_local_obj_stock(), dereferences per-CPU stock caches with
> READ_ONCE(stock->cached[i]) and does css_put() / obj_cgroup_put().
> 
> mem_cgroup_css_offline() calls drain_all_stock(memcg) to
> optimize reclamation latency, but never flushes memcg_wq. If
> that races with cgroup removal, free can happen while workers
> are still pending, causing UAF. The drain work could also have
> been queued by somebody else before offline started (e.g. high
> throttling), not just by the offline path itself.
> 
> Timeline illustrating the race:
> 
> ...
>
> Fix by having the offline path wait for the workqueue to be
> done with the memcg, before freeing the memcg.
> 
> Found through a code audit with kres.
> 
> Fixes: 591edfb10a94 ("mm: drain memcg stocks on css offlining")
> Cc: stable@vger.kernel.org
> Assisted-by: Hermes:muse-spark-1.2 kres

Sashiko might have found another thing in there:
	
	https://sashiko.dev/#/patchset/20260827124211.3b94b103@fangorn



