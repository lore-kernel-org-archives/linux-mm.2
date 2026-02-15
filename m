Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7063DEF5868
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 07:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6199C6B0005; Sun, 15 Feb 2026 02:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D836B0088; Sun, 15 Feb 2026 02:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F366B008A; Sun, 15 Feb 2026 02:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 377386B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 02:29:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1335140A37
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 07:29:12 +0000 (UTC)
X-FDA: 84445864944.08.5C13E52
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id B7850180004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 07:29:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZmYS8zv1;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771140551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaUSkkuQJofxBHkox8rsl9hWWFEkHV2aAas3PKJ8HkM=;
	b=YdBYk30CKLHg1q1/epJpDdRPBtOfKVGAEoWyYbMrETW5Kd6Hx19gCHiycT5r8y9L5JZ+dW
	UmzaNueZlBk9IaiRO1j+boPkA8M1g/USCs5iydjHh5XORPr1RcFr0Aw/JfsgmDu6prbrjD
	pWRGORBVb29l4028c2Skvv6Gjog/VOU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZmYS8zv1;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771140551; a=rsa-sha256;
	cv=none;
	b=bVbQy7YQ+pTE7PCCP6BkMSLP4TYWA61ZMquAaWgQFFWMvvBvF36oW53ZTUrLD9xBaSAouq
	gE/fFQcspeokrX3UK/oArDOCVJbCMu0U1j02+401FGBPASWVlN5ei4Ukl08/5vq/m+OLnc
	3h/jHxe4jHgGyLONjg8J/nzpTLkX0W8=
Message-ID: <5e178b4e-a9e0-44dc-a18d-8c014365ee2f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771140548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GaUSkkuQJofxBHkox8rsl9hWWFEkHV2aAas3PKJ8HkM=;
	b=ZmYS8zv1jl3id/SALH3E1caXqMgXG64D/zHcfOV9yALlFnQAAOgXoaMYN8G6BVHTUFM0Wo
	eCCHQTErQDaCeHlva3gg/Q2YRDwD8gj1ezn8i0MKmmJIqIOHiO0bB+9VWqySaMbghh0EDo
	e98G07fXbtM3Un95sSEEVJ4DSdmCX/4=
Date: Sun, 15 Feb 2026 15:28:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 26/31] mm: vmscan: prepare for reparenting MGLRU folios
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <2cea0e0cf208e46dc55f2baef8162bedba2db47e.1770279888.git.zhengqi.arch@bytedance.com>
 <aY2Tem0Fn6dIknXP@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aY2Tem0Fn6dIknXP@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z3apyi1w6bxkqqkb9nnkk9daug5ywnx5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7850180004
X-HE-Tag: 1771140550-665983
X-HE-Meta: U2FsdGVkX1+ikITX6ptODv6GRJvkpDcJG/ea6Pv0qrpA2REq+zhqLrUeAMskD8F2G4FXcgg7BIU7mmskt0MJYV/c17XNcETb0uI6Vb3gKe5jhziYG4gqpTdn4m/+i9YX7Y1H22YKBPaNsMbSqnfXXIBFU4KOsJtryxXuCYSefPqw16qpQLNM5EzsbYqeviwi+BVbHcnbxABKdt3W/PO1zyFh3GnmYP4KO8Sh6ONtohIFsJ/nXOIxd/UvcOilh+nKQOTokz7r5g+YNr/4OTawRzAv8aqdS5/XPviPnNT+zAotdg3TsYifhuvg7K2+M0L1LVmZ/d+FPBYWwT1sKU3RTh+WNZul3lw3IoimBPpjoXzGSbVdajeyxnSEXjQzfqvYpZyEPuWprp6YRVTG8q1L9kZRnqt9ZZ9pztgtbAh0YKOYUFBqEvfvjdme/IT65RWn2M+5laL11rfLfeG73B/C/K2x2jaKr5QsPMwKq8z2oY/D6f4dotIfRZVdmKiV8iBpTuSDV/jbNyr0kw5IFNjJMAmmXkMfl7qDHiUGDfgYAm0QGDxcboDRaJN9p+o4+blJTx9ahM1wFWPiQsEottM4QZ77fSpxulDVwXuZWnXukqYlNwrDbFI5bzOgv3cEWpnalhaI27oOmL8Ir7gB+Qf3s0NZqUZTetQRvh5nFlhRTumn+A3YP1H6L3ntNTSpkpNf06zWXdjImG9flzq4HcBoUGjYG6WaaiualuDYzWZIh4h11aVeXkeuW+VYsXMTYp1CuOBXRvzZRBFNZ4S9+vuYQIqTohgeOYPONSJuv3d5wZuaTIRYE2lbRh1RCjyELrhUHIALfTedPcpfke0UOZgKRlW/VJG4u9kwygU75JkIXi6fuegGawpzjXME0z/ZpxxfQXzr9bM/rQaJ7KJJ3iDtsBFoA+g5LLQkKndcFV624FQCzLIuPr/70ACaDHX0BDyhTxZGhpkP+EY6ecOYYtT
 NezLeCbi
 F+2cu7Usr2E41WWJvKxczdN2X8yeg7FVA3VGFrFGGCScAqIVReybwADW3I5BmNnAIx91vELjhCdTy2sZ5scgMf1q2rkdYxTcMPsccTVRM+mHS/n4ww3bKpqOFDFiu/ORKzGwE1vi5TcalrsW8DJ7OqTRrSRx/aTADugXZs8TK/88puTd3Df49UPvSu63vO3k86CVHeXY7J4rqUxDcOXmChpixyFLMHHNxpxNCpeqHfo5MGxQeb0DVtAEKA9XdJtE5Qqjb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/12/26 4:46 PM, Harry Yoo wrote:
> On Thu, Feb 05, 2026 at 05:01:45PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Similar to traditional LRU folios, in order to solve the dying memcg
>> problem, we also need to reparenting MGLRU folios to the parent memcg when
>> memcg offline.
>>
>> However, there are the following challenges:
>>
>> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>>     number of generations of the parent and child memcg may be different,
>>     so we cannot simply transfer MGLRU folios in the child memcg to the
>>     parent memcg as we did for traditional LRU folios.
>> 2. The generation information is stored in folio->flags, but we cannot
>>     traverse these folios while holding the lru lock, otherwise it may
>>     cause softlockup.
>> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>>     may be updated, but the folio is not immediately moved to the
>>     corresponding lru list. Therefore, there may be folios of different
>>     generations on an LRU list.
>> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>>     found based on the generation information in folio->flags, and the
>>     corresponding LRU size will be updated. Therefore, we need to update
>>     the lru size correctly during reparenting, otherwise the lru size may
>>     be updated incorrectly in lru_gen_del_folio().
>>
>> Finally, this patch chose a compromise method, which is to splice the lru
>> list in the child memcg to the lru list of the same generation in the
>> parent memcg during reparenting. And in order to ensure that the parent
>> memcg has the same generation, we need to increase the generations in the
>> parent memcg to the MAX_NR_GENS before reparenting.
>>
>> Of course, the same generation has different meanings in the parent and
>> child memcg, this will cause confusion in the hot and cold information of
>> folios. But other than that, this method is simple enough, the lru size
>> is correct, and there is no need to consider some concurrency issues (such
>> as lru_gen_del_folio()).
>>
>> To prepare for the above work, this commit implements the specific
>> functions, which will be used during reparenting.
>>
>> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>> Suggested-by: Imran Khan <imran.f.khan@oracle.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/mmzone.h |  16 +++++
>>   mm/vmscan.c            | 154 +++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 170 insertions(+)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 3e51190a55e4c..0c18b17f0fe2e 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index e2d9ef9a5dedc..8c6f8f0df24b1 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> +void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *child_lruvec, *parent_lruvec;
>> +		int type, zid;
>> +		struct zone *zone;
>> +		enum lru_list lru;
>> +
>> +		child_lruvec = get_lruvec(memcg, nid);
>> +		parent_lruvec = get_lruvec(parent, nid);
>> +
>> +		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1)
>> +			for (type = 0; type < ANON_AND_FILE; type++)
>> +				__lru_gen_reparent_memcg(child_lruvec, parent_lruvec, zid, type);
>> +
>> +		for_each_lru(lru) {
>> +			for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
>> +				unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
>> +
>> +				mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
> 
> This part looks fine, but I think the nr_pages parameter
> in mem_cgroup_update_lru_size() should be long instead of int.
> Could you please update the type as well?

Make sense, and I think it would be better to do this by sending
a separate patch, will do that and add your Suggested-by.

> 
> Otherwise looks good to me,
> Acked-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!

> 
>> +			}
>> +		}
>> +	}
>> +}
>> +
>>   #endif /* CONFIG_MEMCG */
> 


