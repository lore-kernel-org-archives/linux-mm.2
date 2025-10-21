Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA52ECCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A938E000B; Tue, 21 Oct 2025 02:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1FC8E0002; Tue, 21 Oct 2025 02:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3216F8E000B; Tue, 21 Oct 2025 02:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8518E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:22:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD5F511A019
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:22:23 +0000 (UTC)
X-FDA: 84021126966.18.2AE94AD
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8A1004000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:22:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QM6xEaXQ;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761027741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kya1JAQmVRbw00lv1IpjiwWxKFwn52KaWMDi202LPPQ=;
	b=gniJW0m2braaeL1yERiqSPRxJ1IoiRt50g0JQNRgr8l135jxKCOgfPIL8/k8EkRekEvldV
	X0jSTnxvspNJDPAjqcpvQ+TuSCbpjhoo2nS+y0oVrjg7Pa+lApvMJB0QBAyGPPHWLGjQoF
	cIHmnzTqZrR0kpZP1YQhj6CrXDOu/i8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QM6xEaXQ;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761027741; a=rsa-sha256;
	cv=none;
	b=OkTNx9XW25RMhv8PUrMUIuDDiHcpkCaxnimThN5n+LeWSDQeU+eCDeMDjAscXgwG4Dtx3P
	PR3c04Bedz6du3WyuH1E4CjHY0mOJh6ly6DI4WRG3Q6fr+4pS4VxaumjPjDQeVnBRUAz3U
	lCiW2sYyZ6LBzf/7mUm1rk0q7uDBQyc=
Message-ID: <3acbf7df-b890-4679-bbbe-959bd45fdef3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761027739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kya1JAQmVRbw00lv1IpjiwWxKFwn52KaWMDi202LPPQ=;
	b=QM6xEaXQ1k9fTRzqU35722oyvtkjOhFRFUn6hv7F15sVNnUzXmeTTn2sd0kuiqZ03eqLb3
	yeUPqfOeX+rbw3/za/8SnDe/EQgKFudCqn0bA8eG/3HY1aYPpOdEgHLGz3PCveOq0oGoVK
	1/6Xk2/3qrqGrJgsLddULhG7FS2cUmc=
Date: Tue, 21 Oct 2025 14:21:55 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
 <645f537dee489faa45e611d303bf482a06f0ece7.1760509767.git.zhengqi.arch@bytedance.com>
 <aPcjnKAapap5jrK-@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aPcjnKAapap5jrK-@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bmewb3wr6bsg9qggciq6545n8qhco7zm
X-Rspamd-Queue-Id: 8A1004000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761027741-304880
X-HE-Meta: U2FsdGVkX18fMjqK+mKIcwyrmHGRp92eGWiJD/vn3NVlno4I29yn17hEDBHUySc+9zlHEc/5jV5ZF3Fp+Fk7N4/zk+HxSzK17EnbI5Sccc1o4/n8eFoExEIv1rXheGHeg9SKsU1UCnuu9Eh8E3jDpT/WAA23nkxvPRTk5oJoTSOiOquGqRs88NNb4IWDyGFLWPdstMSNGGoGAmUSNQ91ZUmbGMaGCpWGKy01vffXXIz9hT7omPxpvgsc1od+lwNo5107XT4OO09zhVv5q+v3XvWSIh9l8qpSJHN+me5UqvfW8mWDzun/IEg+snXMGHfyMJRyAC2o2JC7zoburVAlDsRaE6oIHBp5wOVHNut80lV6ChQ8OSu2+MArDtAS/1nSC98ewLx3O8nw8g2++ePSaTUhSxg79kTgqnFs24/sE/HL6hZR2zmzCK71SVegIvMLNhUsss4HOE7XyOavuqKmrMVEmDiHrYAXS2Ellx35Wnz6lbBPcFgqTZnkyVr4b8KGsjhZYjSlzudo2O/sU6+z59KVC9oVE5KeA4TPwb1+Kv25jRelFZVimhaBlv35QORkJhjRpWrqDSa5qdA5xAzwHOIjwkvsHPtigvnyS4TRG+NdLJL49inYJbS4Kt+fUZUY20qdeaOHTMKrO3RCGhI1Q8tVlIycBq64LZS6yavNFbsk2Qr+CJCZlPCoJd80w032QJPuWdZr2egfXf+0zm1/2V64/WJnMpVLP3vfyTUjL9XsDQ7JW9ep13IDEWq9ZFzk+RswOAiJVvbShXCuIH3WeEy+EnudSgXmAwTGYdqiMVqYGWgiKCFPS/ydePmcJLTDVXOtRHsCSaEaJO3o/gsxsyTHGiWEeuC1Oi2To7KcER87nTqSUQAPsOoAa04OVl1YgN7wKHGnAAzXt0MBUwnbnDg9QRpjfQoO4YJmPZsRyudjzJitJFINlVgAr823ge7RGlNzaX6X08llXuy4/Zl
 ZWykuOs+
 jPaKON+8q0X+Xxvv4VsG9gulgVKCQ9TA8aJNHYr3pHmjBkDplZC1hZ4zl5EsiuWiVlUgxsKGRvPNuw3N6z/FGFkJ4HyRlDoCz2rHUaC0vF6VgXoYpOuMCNgcTUlq5RqIN9uxrF1B4r3sMj0yvSk4s+Zmrzih/V264v98TrshsYxWvQghnrS+DKI28ncq2VP8IXEEKrh2OFmaQv2cghiPBWd/oLSRuMLeUkP2DdbFnYLdpcBC0UyZ7GSbRl4g8IPp9kpctvWgpdhUb4320NOc9N86QqN3l9Ctfusb7sloC2/ZQ4XGI+ZZk5vmPoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/21/25 2:09 PM, Harry Yoo wrote:
> On Wed, Oct 15, 2025 at 02:35:33PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Similar to list_lru, the split queue is relatively independent and does
>> not need to be reparented along with objcg and LRU folios (holding
>> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
>> to reparent the split queue separately when memcg is offine.
>>
>> This is also a preparation for reparenting LRU folios.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Muchun Song <muchun.song@linux.dev>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks.

> 
> with a question:
> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index e850bc10da3e2..9323039418201 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1117,8 +1117,19 @@ static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg
>>   {
>>   	struct deferred_split *queue;
>>   
>> +retry:
>>   	queue = memcg_split_queue(nid, memcg);
>>   	spin_lock(&queue->split_queue_lock);
>> +	/*
>> +	 * There is a period between setting memcg to dying and reparenting
>> +	 * deferred split queue, and during this period the THPs in the deferred
>> +	 * split queue will be hidden from the shrinker side.
>> +	 */
> 
> You mean it will be hidden if the shrinker bit is not set for the node
> in the parent memcg, right?

Look at the following situation:

CPU 0                   CPU 1
-----                   -----

set CSS_DYING
                         deferred_split_scan
                             /*
                              * See CSS_DYING, and return the parent
                              * memcg's ds_queue. But the pages on the
                              * child memcg's ds_queue has not yet been
                              * reparented to the parent memcg, that is,
                              * it is hidden.
                              */
                         --> ds_queue = split_queue_lock_irqsave()

reparent_deferred_split_queue

Thanks,
Qi

> 


