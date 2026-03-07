Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E3CFC9ED3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 08:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D932F6B0005; Sat,  7 Mar 2026 03:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40A46B0089; Sat,  7 Mar 2026 03:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C866B008A; Sat,  7 Mar 2026 03:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DDB86B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 03:53:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06DDDBC2A0
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:53:12 +0000 (UTC)
X-FDA: 84518652624.15.380A4EA
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 03385C000A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:53:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CawqzaEc;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772873590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTpdDjrX0wTiL0fAhrePIJwxDS9K/k1k3ZXc5DUWgFA=;
	b=gJ+dXAM4xgBywbaMUSAzN5oz5QiDJ/u3zFbjqSRdcJh84oybGjmQk2ntnd9FlbsMHs5pj/
	hZNKhlf/WoVTKTP6p10+WrJRj6bUzK1KqByPyyhST3Id8dcBcHhWzXn+76QBmz4C4z9cV2
	qaOg2kmtWUoswOpGiLWR6ieke4MiunY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CawqzaEc;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772873590; a=rsa-sha256;
	cv=none;
	b=EDfLqCEHCYs09+ZVRAW+vsBf1LmA+zI/F8sSn6v043GpPe+QhH3Qph30NctcLJ8iwwaULL
	O2UU56JsZpQIhM9uv5hTep6hUAK10DXvitCxxnjJQS7sGjYnWUGb0d7vt1wqQO7eyarqSz
	TWm3ER/C+Dr/py7X34SHe6T1XHbAL+o=
Message-ID: <b77bd438-3420-4569-a461-7b1b7afbc0a3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772873587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BTpdDjrX0wTiL0fAhrePIJwxDS9K/k1k3ZXc5DUWgFA=;
	b=CawqzaEcU9hO9vJW+5g8ONlJ2RUwoSXjBsrHnHWghOAHhDNG5ovYnEL5GkizH5j+vQLW/u
	Smfzz/V5alCB0t6HJYZvtsS7YbVIFnMwRLlmk2UdFl5qh6hb18+cZxpoAZZ6kVemODYg/j
	1uIpWYQGZmSj/3ji+7RQAzkA8EgqoCY=
Date: Sat, 7 Mar 2026 16:51:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 31/33] mm: memcontrol: convert objcg to be per-memcg
 per-node type
To: Usama Arif <usama.arif@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <20260306202931.3878822-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260306202931.3878822-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 03385C000A
X-Stat-Signature: jg6ngwy1g1jmuydeqiok8g4ejkqswqqq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772873589-293301
X-HE-Meta: U2FsdGVkX18fx0ut6dgcbgXCInicugVSeZV4S2A4tx+8g1XFVyCmRAQyDp8cbKO5B//ma+dDS1D+Z/DSI5uEMUDaRevKmFmEwF4vV3giwLOA7+exDb52FEFFDf+uKZXLsr6LkvntcQguBwMjMuNfYYRi03i6vVpQgd+9LzesVZdimYYByJSiA4IsQxUXMXlWmxmb2v4B19R82YD1rX/Hc3Jlgd3JJulkRWUYNN4HwGB33DrQPEUb+MCiRi7pbIUcw5a8HFIWceAF9HPTZPqwyF3AMFQWlVNlPUgXrFG3zgLBPmYXXkzD/DLzMYudhe4Xb1M12/0T5oLi2MqbX21tnJMleszYJ4bKsLZCnA2hBhq2pC1cfARPwSeqmDkTAR6DEbo1Wzn1bMwWqip5g8bLficehviwtAFF2w7nx0RqtwMUtZWkzA34TAYt+xnNJEwuHMv38B7LqlViFabAXnOH7WNz7/jK5dXJlhMpWuyH+Em73pZUhW1vuIhPfPyq+vaMlT8ZU9qe+sBviquaSwI01F8GpQ9SGTblnL92jwVOjMTd8gxQswDlTCRV9X3lNSGCVN0GbNyj0EaY6JxDqooGe8z7PCiI/zUCvmetcubHOik4zajYdVMBw27d49QRT1VsOFUXK6pDtxpPC+lxY3OlsuxGEINDreybFiF5t2G8SiR0ynvr8krjm7oNiuoCLxsyPCi+RVkPAsvwBU+v5LPWgOPWrq2J81E4klYzo9Zvzq50W+uErmVyzqcz4RoM0yUC8z8A5nfqDV40iBIt4JV8wjBU+L6uxfYxgmCwQ3Fiv3Kqo5vrHqBITE29yVs/SR/X1sd0gGCd52CzwHmanipA/otT2zSlg8Ar0fWHWzc3BpV0vw66sttCWdoWSjzyHP4Crg5ucw4tFPti3dIsYU6zZY1EAt4PwePi2E4pAdVHtT+sx51mtvibw/7A+eab/874U3HT3R3sNbOp7lxmtby
 6XFFWo1C
 04xZSl1yv1bL04jZSHlv/50lgqKkNlCuca5Q5nYtnqdb23UlBsDoWiXawqmst7Rk+3zvTtPyQkE/w5Vb2YcTYivVP3Gr3VGw125brVaNAafLH84ghRotRoNbBrc4MGUPHVF0FXqW/yhcNUlbfL/eGf7PljLa5EBy/+sxsNq03Rq+m0hsT/zxracx5ShZrxxdOhBOeAjw7PLAysXKQJssQa2mMqXIdCsyrtTea5I0XjnbUn89XdXwnY7WZ9gWKeySZsy+dRsFcJUC2sYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On 3/7/26 4:29 AM, Usama Arif wrote:
> On Thu,  5 Mar 2026 19:52:49 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Convert objcg to be per-memcg per-node type, so that when reparent LRU
>> folios later, we can hold the lru lock at the node level, thus avoiding
>> holding too many lru locks at once.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> ---
>>   include/linux/memcontrol.h | 23 +++++------
>>   include/linux/sched.h      |  2 +-
>>   mm/memcontrol.c            | 79 +++++++++++++++++++++++---------------
>>   3 files changed, 62 insertions(+), 42 deletions(-)
>>
> 
> [...]
> 
>> @@ -4087,7 +4100,13 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>   	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
>>   
>>   	return 0;
>> -free_shrinker:
>> +free_objcg:
>> +	for_each_node(nid) {
>> +		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>> +
>> +		if (pn && pn->orig_objcg)
>> +			obj_cgroup_put(pn->orig_objcg);
> 
> Is it possible that you might call obj_cgroup_put twice on the same cgroup?

Oh, I think you are right. Here pn->orig_objcg was not reset to NULL, so
obj_cgroup_put() will be called in __mem_cgroup_free() again.

> 
> If css_create fails, css_free_rwork_fn is queued, which ends up calling
> mem_cgroup_css_free which calls obj_cgroup_put again?
> 
> Maybe adding pn->orig_objcg = NULL overhere after obj_cgroup_put
> is enough to prevent the double put from causing issues?

Agree.

Like this?

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 992a3f5caa62b..e0795aec4356b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4140,8 +4140,10 @@ static int mem_cgroup_css_online(struct 
cgroup_subsys_state *css)
         for_each_node(nid) {
                 struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];

-               if (pn && pn->orig_objcg)
+               if (pn && pn->orig_objcg) {
                         obj_cgroup_put(pn->orig_objcg);
+                       pn->orig_objcg = NULL;
+               }
         }
         free_shrinker_info(memcg);
  offline_kmem:

If there are no problems, I will send a fix patch later.

Thanks,
Qi

> 
>> +	}
>>   	free_shrinker_info(memcg);
>>   offline_kmem:
>>   	memcg_offline_kmem(memcg);
>> -- 
>> 2.20.1
>>
>>


