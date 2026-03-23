Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9200DEC01B6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056B76B0005; Mon, 23 Mar 2026 05:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0070E6B0089; Mon, 23 Mar 2026 05:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38656B008A; Mon, 23 Mar 2026 05:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDBB36B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:47:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97306160A9E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:47:54 +0000 (UTC)
X-FDA: 84576851268.25.1701024
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9666F14000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:47:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CwxYaQu1;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUcyey8JJET54dG1RcxlUPbktgzb/K1oah1AT7wcgO0=;
	b=4hEVhjuFBK8P8inbyiyV/5FiSkogOBZ9GD69dSYu2+/esQTk7X1Z1TF5Te70bgj+G4EEcz
	BRBhF4hZHh/CNVCRJ2z4/Y0UfNujbJJYgfKE0u0XSIBC6unmSaD7UU95cC28h+qy+4F+V/
	g9TmPbSeQLyxNihZul2sKI4mMQR4cLo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CwxYaQu1;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774259273; a=rsa-sha256;
	cv=none;
	b=z3frpPe1YpVwtU8W6aad/K20S+lEFgYZD3RuP3EYCiO8nz0KSoDGqGeVc+Y2oE+dJ22OAu
	DeUot+mTX1cg1JbNmnhTiiIyl9zj59yOupkgHcZGfZugVkICqoTq8DDWEQjVsTkHr9TQEu
	ilMDTyQIRtWw82qRjN+Q/7A2mPCKUjA=
Message-ID: <2d39ea5e-fd69-4acf-8518-a504f5f7a838@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774259270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hUcyey8JJET54dG1RcxlUPbktgzb/K1oah1AT7wcgO0=;
	b=CwxYaQu1n0VmMyb46AU0irJsJRHETzAAsRr3dEl7G8MuKiYiMDYJxB7bCYjztd8Wlyol9Q
	tvBYS+JsyWstB+h4ToehfXaGvY8XOajahWwp21Dsd6zJj1Oxi8+TUoErpvCTE9LFK/ko7E
	qunY8dUK2nRfmD6DFG1q6p5QnH6u9h4=
Date: Mon, 23 Mar 2026 17:47:27 +0800
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
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 Yosry Ahmed <yosry@kernel.org>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
 <acDxaEgnqPI-Z4be@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acDxaEgnqPI-Z4be@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wnk8axapkct1yr5upwnk3mskywekemtt
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9666F14000B
X-HE-Tag: 1774259272-223201
X-HE-Meta: U2FsdGVkX18k2Cx1I6GQi3d5dSBY1DJZ2c4ogZZoTqphsj9f1GyYwlffDn4+F+eTUb+o5imAz7SCHfQcE/IcYj2W+40jDCwgDYCVPtTj4WvjJyJhNvv3Rn/bAk+qcSiwKoFNgXYYKXSXa/dFwkO8eE4K/6p1hR9LslwzObuqjxOTGgLHXf0HDbLckV308Zug49PBlTWWmB9VOMxOIXkWm6nu3XA4stFMMhDOE9bwSvjIRqxOaoU2Y/LTGRgK8hjrj4tixXhKrlHwOpKAUt9RfSG6PbSVW2iVQzV3j7yE/GvsT7LzCpasWFBQkJ1ZGjGTleRoj3eSMa4vUy9H0e3z+pkk8xZr5sNN/uhOvibsrHh54mB7Hq5CcBP9aQTG+S1t/0xIBpFqLJPcNUvRuyjS6EEpd/xhfv1wlLb2xi0SPFFFfY3kTi19TC9ETtjs4yEHcedw5+FbpGoRVfVp79ui+D65BFKBNbBIjs0e8bRrLyPn4ZcWfL9/snbXanJPrO1mgdAH8HjnC4NRBEGn4Sj3CILUqvvftiNb59JeVm75QBDpG3OxyyR2SGX6lHDILHSkLKK1E73JXhsm4ewvZ3LHyrwzLksM9tHbPtMrRGfu8I6ZOTcJtOwj/2mhpsm/RscLypYCvf6sqD2pS1G1IYvsvTBPLaEVbIjzofwmkEzkSTflC5/cLUxwoQramoiE6FafaGQWCUCANMWYuZ0E1PXEGg74aFB8ZzOxAIJgpSqLvCFFRjM8v2W1CPd/TVm+u04eCtwn8vfT0QOtC1de3Pac//TYMVDf8UCV3KCWO+Or6EoewrNJxFIFkORVyJ1IJtp/KwSI15ve7RQyUTDJrneY55tvadABYRS1gzGAVoKYWi8ilZl+SNLsrgI1fx8IN23fNVEcA5UWPovJxT6B2hCSkl5SGX/GhoyzpjKb/5BiLCZ+wFK4mcWjLmX4uYFgMPMIRlyM8hiIUmlxVPkrUYO
 S/DNyNi9
 mCzJmcTzAZWAaGKI/zyIMVpoe3Gi2ybdb7mm/JVqWGvUCzpkqGZJ/EqOTKQrfepVOWrvG+H6M1t9KMtNtrmX+X+KaRA2+cEX66w6dALqkwQibNXW9pi31P80HB4lrm2/ApAta63CZlEygXw9kBbyrmdRdDXDk0udMKolQq7tOvRslXTqSTWBXCj4oOGt8/3gSL6kflmUjOd/hFQnbhckfxRUqQHRqDLSSkHuU1o5xLGjwFleXaLBSXlf+aB6fOeh+wKZO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On 3/23/26 3:53 PM, Harry Yoo (Oracle) wrote:
> On Thu, Mar 05, 2026 at 07:52:48PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> To resolve the dying memcg issue, we need to reparent LRU folios of child
>> memcg to its parent memcg. This could cause problems for non-hierarchical
>> stats.
>>
>> As Yosry Ahmed pointed out:
>>
>> ```
>> In short, if memory is charged to a dying cgroup at the time of
>> reparenting, when the memory gets uncharged the stats updates will occur
>> at the parent. This will update both hierarchical and non-hierarchical
>> stats of the parent, which would corrupt the parent's non-hierarchical
>> stats (because those counters were never incremented when the memory was
>> charged).
>> ```
>>
>> Now we have the following two types of non-hierarchical stats, and they
>> are only used in CONFIG_MEMCG_V1:
>>
>> a. memcg->vmstats->state_local[i]
>> b. pn->lruvec_stats->state_local[i]
>>
>> To ensure that these non-hierarchical stats work properly, we need to
>> reparent these non-hierarchical stats after reparenting LRU folios. To
>> this end, this commit makes the following preparations:
>>
>> 1. implement reparent_state_local() to reparent non-hierarchical stats
>> 2. make css_killed_work_fn() to be called in rcu work, and implement
>>     get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>>     between mod_memcg_state()/mod_memcg_lruvec_state()
>>     and reparent_state_local()
>>
>> Co-developed-by: Yosry Ahmed <yosry@kernel.org>
>> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> ---
>>   kernel/cgroup/cgroup.c |  9 ++--
>>   mm/memcontrol-v1.c     | 16 +++++++
>>   mm/memcontrol-v1.h     |  7 +++
>>   mm/memcontrol.c        | 97 ++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 125 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 23b70bd80ddc9..b0519a16f5684 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -473,6 +501,30 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>   	return x;
>>   }
>>   
>> +#ifdef CONFIG_MEMCG_V1
>> +static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>> +				     enum node_stat_item idx, int val);
>> +
>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> +				       struct mem_cgroup *parent, int idx)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>> +		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>> +		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>> +		struct mem_cgroup_per_node *child_pn, *parent_pn;
>> +
>> +		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
>> +		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
>> +
>> +		__mod_memcg_lruvec_state(child_pn, idx, -value);
>> +		__mod_memcg_lruvec_state(parent_pn, idx, value);
> 
> We should probably change the type of `@val` from int to val to avoid
> losing non hierarchical stats during reparenting?

The parameter and return value of memcg_state_val_in_pages() are both
of type int, so perhaps we need a cleanup patch to do this?

I will send a cleanup patchset to do this, which includes the following:

https://lore.kernel.org/all/5e178b4e-a9e0-44dc-a18d-8c014365ee2f@linux.dev/

Thanks,
Qi


> 


