Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5023EA854A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 02:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD236B0088; Sun,  8 Mar 2026 22:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AD76B0089; Sun,  8 Mar 2026 22:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8456B008A; Sun,  8 Mar 2026 22:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9CC06B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:59:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B7EBC3D02
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:59:48 +0000 (UTC)
X-FDA: 84525019656.09.ADF50E6
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6BE10100006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:59:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FJawJpKa;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773025186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=surD7Tl7I0c7IM/NAN7h4/O0mH6dbWmZP+2JPPoPahM=;
	b=3/DGy9l+I3CAYTBDthmO2IJYbe1NadGTn3/FZZHRmhBGc6sELV1IoD2JfAI8bF0UCmahSE
	RoFM2bkQF15TeFlVoi9+oa4kc+fmy6Lm3mkAe71fWhvNH7SauCDlWRbbfr0dZeG5hPCevy
	aDyuuHpcLXM/Yj7pJ1zadoTvHDP6eSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773025186; a=rsa-sha256;
	cv=none;
	b=KjtoKjyYaZ12UPJ9Di74xw/c75B+vCTwdWErIvMPM2pwXdf2IkCTaxhDhsyX6wrPyEZgmz
	1pvPPfgNlPWGJOOmPjomPp0gbAtQgSvPT6FcSjc0vxGIWIe+mEBgRR6N2DG8W4uu2WXCTj
	r0m5HTdAq1cx1+OgeAvnkxXHHe1cQGw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FJawJpKa;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d5eb31b8-a099-49bf-9b3e-09e525242968@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773025183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=surD7Tl7I0c7IM/NAN7h4/O0mH6dbWmZP+2JPPoPahM=;
	b=FJawJpKa2+SghPS7x3wAb1/ADkqlaG+EU48QgAFLhye7ep1KXmfv8aR211KO6QMm+aM9jE
	lkSfHq7NYA6CmA4qgbrbz1Bb+64sic2GD+OsuriZ38V6yHQAVTjuMN9h63nPZs8OqpFDZL
	E7/eoswn88XvnfZ+A7mJ8TC5NNgcmWI=
Date: Mon, 9 Mar 2026 10:59:18 +0800
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
 <b77bd438-3420-4569-a461-7b1b7afbc0a3@linux.dev>
 <898e8ca7-efcb-4bd7-8016-871b37be830e@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <898e8ca7-efcb-4bd7-8016-871b37be830e@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: x7btssfh1w5wm5e89jwyxr1wq5ezgq5z
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BE10100006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773025186-887675
X-HE-Meta: U2FsdGVkX1+j6cI11z9O41gvAh6l3+nk+zT61aiTUaV31K8xELbHqMnodFqhMXgmImWOqIM106f1EUWPpRo+fsEdqB487kdZSG3WMsKDdPw75tX8XHluzgrAq/fjMMh4u9XkwSTeFBqq/W/9U5wHfBTrioU4xi2K3YDEsMxo1Twnun/W09z4ykox6uCqpuZuf1Qg/+YlDHbgvVSpyAa4VSYvrpASvbUwJSi10B/JGp66Q1t1YLhAIS5urwpwAh+rUSh/1DlWDxLMhlvDgOSa0G6c6692N26D6UFDfrNs5wQTUialkWdeuj2Oo2nHIfewdwWEy0+tP3r93Gotrk27JaDfpMS3gntA+lUq1uPd5ppoAd1r2LILcrlek54uLwQ/I9lhDRPFYPsIHdVGUIHx6x1ZmfgHPSgpajCodr1wFz8bdwzK7Ojv5itQ+2/CKSLIoGtb5tIiG0VWtU6muBA/XLkrv+0oWEJPrusRmNuC21+ml4oFlCafONa+/5jBWchI+pJgD2EHlqd6uZrfwhW0asUwDbrj/IeyaP7rDUGH5I5XL/ZLeGLMtuey6QVkBjTnfNdvVYqvYGarWCOWXXb5jifPy/xUITccm5hlmfSZdw+HL2ZDgP4NP5J1RssPGN/KyU3frspeJN7gaOtPkQsBLb6lDvEqxN9XMPE1kSkTBRaISMyypl51RomxDnLXoxxKm9LFUjaUiDi/PDz5nJITux/DP6Xg9T5SGFhTAutUnGSsaeWezAFLShoiB5MHuId3JRXItt3jVvTCvOnRL7U6Am2yLJxoeLWHSzcVaya3Y1RS5DJgp6Nyu9Boi0PIufKQsTnUiDqSK37zRpqK6dw4DhSSu8kkZTHcLytQivlz304ft0MRV4ETZwi98ZVAyc0woKWhlQOaJA9yzTxAgL+9a3hg7/iP5sqSitUkgGgPqJYShmaOQ75EeQygcOID3VQa/9O/b9VBgQh6apy7xeC
 pkfIiM14
 Acl+/vlNOXKS5fcNY+bnSOxM9Qd9A+2X0wVP1QDeNod56Sd324YEADnsUbHxBIVNeDZS/YUjOF0COAB6pjGALNxis1CzqyuAZDIyxTjW45R7RY6h9bqUpe3bavQujKEF+9AzIXZB5Y7SVRi1z2ibmkvp80GKc6bLuyXTJ6pInHoFZOtOy7goj1+6RqBaHW/mndEq0xkF2ZXDE7WwC3vY6cZkrmkCu6iBovnml/ja0uGPxLG2BUSWxLXQE4XS2sl7z4sUWygMWo9641nv2rhbrAs6fb0xvqCMZpQb2HBoQPltHiLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/7/26 7:08 PM, Usama Arif wrote:
> 
> 
> On 07/03/2026 08:51, Qi Zheng wrote:
>> Hi Usama,
>>
>> On 3/7/26 4:29 AM, Usama Arif wrote:
>>> On Thu,  5 Mar 2026 19:52:49 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
>>>
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Convert objcg to be per-memcg per-node type, so that when reparent LRU
>>>> folios later, we can hold the lru lock at the node level, thus avoiding
>>>> holding too many lru locks at once.
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>> ---
>>>>    include/linux/memcontrol.h | 23 +++++------
>>>>    include/linux/sched.h      |  2 +-
>>>>    mm/memcontrol.c            | 79 +++++++++++++++++++++++---------------
>>>>    3 files changed, 62 insertions(+), 42 deletions(-)
>>>>
>>>
>>> [...]
>>>
>>>> @@ -4087,7 +4100,13 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>>>        xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
>>>>          return 0;
>>>> -free_shrinker:
>>>> +free_objcg:
>>>> +    for_each_node(nid) {
>>>> +        struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>>>> +
>>>> +        if (pn && pn->orig_objcg)
>>>> +            obj_cgroup_put(pn->orig_objcg);
>>>
>>> Is it possible that you might call obj_cgroup_put twice on the same cgroup?
>>
>> Oh, I think you are right. Here pn->orig_objcg was not reset to NULL, so
>> obj_cgroup_put() will be called in __mem_cgroup_free() again.
>>
>>>
>>> If css_create fails, css_free_rwork_fn is queued, which ends up calling
>>> mem_cgroup_css_free which calls obj_cgroup_put again?
>>>
>>> Maybe adding pn->orig_objcg = NULL overhere after obj_cgroup_put
>>> is enough to prevent the double put from causing issues?
>>
>> Agree.
>>
>> Like this?
>>
> 
> Yes below looks good! Might be good to add a comment as well why setting
> it to NULL.

OK, will add the following comment:

/*
  * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
  * from being called agagin in __mem_cgroup_free().
  */

> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 992a3f5caa62b..e0795aec4356b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4140,8 +4140,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>          for_each_node(nid) {
>>                  struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>>
>> -               if (pn && pn->orig_objcg)
>> +               if (pn && pn->orig_objcg) {
>>                          obj_cgroup_put(pn->orig_objcg);
>> +                       pn->orig_objcg = NULL;
>> +               }
>>          }
>>          free_shrinker_info(memcg);
>>   offline_kmem:
>>
>> If there are no problems, I will send a fix patch later.
>>
>> Thanks,
>> Qi
>>
>>>
>>>> +    }
>>>>        free_shrinker_info(memcg);
>>>>    offline_kmem:
>>>>        memcg_offline_kmem(memcg);
>>>> -- 
>>>> 2.20.1
>>>>
>>>>
>>
> 


