Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9503F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 02:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263126B0005; Mon, 23 Mar 2026 22:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213DB6B0089; Mon, 23 Mar 2026 22:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1295D6B008A; Mon, 23 Mar 2026 22:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 030776B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:55:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 959E41B988F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:55:06 +0000 (UTC)
X-FDA: 84579439812.15.1DCCB37
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9FC2D40008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:55:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K8tsLqZr;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774320904; a=rsa-sha256;
	cv=none;
	b=KUIvKqMzL7IpP/aljM3Ln630dHPTEEeg98H1/ZJBgS0Jqi0lUchZifzHf5PmQScg6e6JLW
	McFrh+bHeF2ByzCnC4ApEY2nlDEhi2R0tyB5oyKwrVc9K0EBzftqPjXb4jyi6NcggrEWrx
	RwWx5Ys1ytFxbFaxKd9cBownKoweDIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774320904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqMcPOtJgf2Sc0QkuwSVrttG2FHeAWKIGSwI2uBamrU=;
	b=2sz5VnUuH3hPcGvMdxvnbhB/zgq4LwpaG3FgxXSBhjGQ2EU7JYgNjg2HRpmzJrl2Yp7RxC
	Jgyln7RqwSP3cNrxkqfck9MDwId3RhDtZtRw9zIRrRW9mpdV5PT3PrykincSZPwduPFgji
	TpQbUSDinzpTsX//xTNq4rN9jktpbJ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K8tsLqZr;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c913ce46-bc83-4d36-b1b0-a51b12e515e9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774320902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hqMcPOtJgf2Sc0QkuwSVrttG2FHeAWKIGSwI2uBamrU=;
	b=K8tsLqZrlczicjdzRpXTszHlVi9n3yrWvfaGfX1T5GkRUJvI+gsNav6y8WvY4gwJaZwiNA
	WWmM7T/pajMIW7qn9pDAJbCkc8d0mAiQjYI6d+hjvQ8yWsKsCU1J2Fg4e6aSDrtWBH6ZMM
	2ipJeO3cP7Opc31oL18CS7JYh08lJGI=
Date: Tue, 24 Mar 2026 10:54:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
 <acDxaEgnqPI-Z4be@hyeyoo> <2d39ea5e-fd69-4acf-8518-a504f5f7a838@linux.dev>
 <acExNWaaKdhrBH-J@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acExNWaaKdhrBH-J@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9FC2D40008
X-Stat-Signature: jr6gbo9ztx3f9wsp6a4i1dkuudw7h5uj
X-HE-Tag: 1774320904-242650
X-HE-Meta: U2FsdGVkX1+JIYTfie7nZJrRxAKITm1bC8yEdxlc9F/whSINZdwQP/m2U5bG8MJmAWZUygo0Lfh/yLTguuOs4nFeBNQihbyOLIVGgVihd+PJ/7cNvh5+lrMg3L1puVX5QDZSnhs8nH/8+OItmUPnKmLMubpJpbmra7YrOrLCDRFoZHOJ2H/1MKgSPUYonL9hwFsg1kQD4sVrJYGUswEcH+opD7NAP9678eaq1lkt5PtSSOxLGGu89Ttvm8t3VzDoL5S0vUbK2rtkLVSW56m4HzfjnBJph8P3JD0Hrp0fLlf84ge/8bGaE8eOPuiw9QBenQw6TyGHFJTA4bhW/c3Ds0xxnfNtiSjFPR5pUK+e5NNys20kydfLJ7AjZSObay/BGgbYJIAxeYZ39RXbiJPlCgqePODjElAkLwRUFENZSq7D5pRXd9P9/oTlkzS4Zs1G2XoewlCrOdHYo9qBLllx3KXGIsiXEEwVrvXUgrIn2Y2VLmAw16Yq0v2yOriCNVODGrkaYsRcGJOpnR837w5eQa1BZMMCh/ZTCXZ/J6HRt9NKlkjv0HkkANsk9A5ir4buyWWgL2Ljr9X2MIehJ56NNX9t+9LMBO8jz1R9aFNC6yG/eAHJaawK8gHhfiXJ5CUkKmPG+WD8G+mDccX0FboUKHcHrDCQE6gIXz3+q/3mpnGNjBBHardEmbHQDTxtNsTFwQg/LabV0nwJYNLWjE3XAgJj6rdoZ0Zz0ZGCxYM57IV+v1Fxb76kPWVD5cTNkQpg/ZCep07NsznpBETITCpMFb+uVUxGLIDldYigK3GlJgR2wCFej8WCj+F6pgQahbF3/DgLun5JgoXXVkHHi93wgcRtAs55+U2OIdoi7AmJqPdgyORMId3KgiIjPv3/euPUtw1jWxZ9jT88Ehw8Ot5julWoFkJ5dt7tqLpf1ED0w6U8muHLtaku5veoDhmXvaTmY3NrDFaeVx2KGGi1nbU
 rOM2cANU
 zfHgyk0BK5npORNpQwv6+21JpCSs2fLQ+6/iKQ/CNDc0FimewIvpTaN2m2s2dhKyXMSEt2Z1nnf+eadGl7CvkpA6dgXVOUCDM9ZWNJmC11aNAU7FR5X21GZVDPwBDlypfiIxzywdpU4Yys1Nx4lgD3a9LykwIiYuUDu+bd950tmF5RZMPhGS8Gr5hqj60YCZ4xgHo+iFvamiV02ct7iOF/kbFxEbWJfuPNF7YXG1jcGlMDbB2Rgmvntl7asJQQUQXfrR+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/23/26 8:25 PM, Harry Yoo (Oracle) wrote:
> On Mon, Mar 23, 2026 at 05:47:27PM +0800, Qi Zheng wrote:
>> Hi Harry,
>>
>> On 3/23/26 3:53 PM, Harry Yoo (Oracle) wrote:
>>> On Thu, Mar 05, 2026 at 07:52:48PM +0800, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> To resolve the dying memcg issue, we need to reparent LRU folios of child
>>>> memcg to its parent memcg. This could cause problems for non-hierarchical
>>>> stats.
>>>>
>>>> As Yosry Ahmed pointed out:
>>>>
>>>> ```
>>>> In short, if memory is charged to a dying cgroup at the time of
>>>> reparenting, when the memory gets uncharged the stats updates will occur
>>>> at the parent. This will update both hierarchical and non-hierarchical
>>>> stats of the parent, which would corrupt the parent's non-hierarchical
>>>> stats (because those counters were never incremented when the memory was
>>>> charged).
>>>> ```
>>>>
>>>> Now we have the following two types of non-hierarchical stats, and they
>>>> are only used in CONFIG_MEMCG_V1:
>>>>
>>>> a. memcg->vmstats->state_local[i]
>>>> b. pn->lruvec_stats->state_local[i]
>>>>
>>>> To ensure that these non-hierarchical stats work properly, we need to
>>>> reparent these non-hierarchical stats after reparenting LRU folios. To
>>>> this end, this commit makes the following preparations:
>>>>
>>>> 1. implement reparent_state_local() to reparent non-hierarchical stats
>>>> 2. make css_killed_work_fn() to be called in rcu work, and implement
>>>>      get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>>>>      between mod_memcg_state()/mod_memcg_lruvec_state()
>>>>      and reparent_state_local()
>>>>
>>>> Co-developed-by: Yosry Ahmed <yosry@kernel.org>
>>>> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>> ---
>>>>    kernel/cgroup/cgroup.c |  9 ++--
>>>>    mm/memcontrol-v1.c     | 16 +++++++
>>>>    mm/memcontrol-v1.h     |  7 +++
>>>>    mm/memcontrol.c        | 97 ++++++++++++++++++++++++++++++++++++++++++
>>>>    4 files changed, 125 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index 23b70bd80ddc9..b0519a16f5684 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -473,6 +501,30 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>>>    	return x;
>>>>    }
>>>> +#ifdef CONFIG_MEMCG_V1
>>>> +static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>>>> +				     enum node_stat_item idx, int val);
>>>> +
>>>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>>> +				       struct mem_cgroup *parent, int idx)
>>>> +{
>>>> +	int nid;
>>>> +
>>>> +	for_each_node(nid) {
>>>> +		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>>>> +		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>>>> +		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>>>> +		struct mem_cgroup_per_node *child_pn, *parent_pn;
>>>> +
>>>> +		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
>>>> +		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
>>>> +
>>>> +		__mod_memcg_lruvec_state(child_pn, idx, -value);
>>>> +		__mod_memcg_lruvec_state(parent_pn, idx, value);
>>>
>>> We should probably change the type of `@val` from int to val to avoid
>>> losing non hierarchical stats during reparenting?
>>
>> The parameter and return value of memcg_state_val_in_pages() are both
>> of type int, so perhaps we need a cleanup patch to do this?
> 
> Yes!
> 
> and @val in memcg_rstat_updated() too, I think.

Right.

> 
>> I will send a cleanup patchset to do this, which includes the following:
>>
>> https://lore.kernel.org/all/5e178b4e-a9e0-44dc-a18d-8c014365ee2f@linux.dev/
> 
> Thanks!
> 
> Should that ideally be applied before this patchset?

This would conflict with the current patchset. The v6 has been in
mm-unstable for some time, so I prefer to add a cleanup patchset to
avoid interfering with the merge of this patchset.

Otherwise, sending v7 might be more appropriate.

Thanks,
Qi

> 


