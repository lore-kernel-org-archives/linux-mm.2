Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E7D6CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 03:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F76D6B000C; Wed, 26 Nov 2025 22:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0236B000E; Wed, 26 Nov 2025 22:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27206B0022; Wed, 26 Nov 2025 22:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1CF86B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:49:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CF1013BEFB
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:49:36 +0000 (UTC)
X-FDA: 84155007552.13.2B25323
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64173C0005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:49:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MprLPJcp;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764215374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQ0ZXYaEsqXDUL5h8p3v+NwU49BKhktpBBnYsZDc89I=;
	b=fQ3G4AOaLV3a+aVGhriv+U56xJTj1aVcvqqKpN3L/nJQ1CZ0ZWNKTNL+dw/vYkRvOA1x9S
	JZVZtuT4RI5Su/MTgtgUCrNrN8E/3dLnqXmm9gYnAgLLPx8K2KHXR4fHiToGbT3W5Wuiii
	prhvJ/ioOLmxTIkzFAAAf6rBWsHDgPU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MprLPJcp;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764215374; a=rsa-sha256;
	cv=none;
	b=MNDI9CvNdWee6QRkR9oLZXwnkdyIMKAxia3/yHKf9h+L4bu2eaiYjo6b8G3U9WcNMEV++A
	ntt68NBzLI4ApTDhSozxwmdKYZ0wtQmtfPzkhgzsDM0UP4/6yDRgrr4RNJ3fL4zLAXmc99
	Koh7HH2xXEf8I12U/r9PcNSWwt132jg=
Message-ID: <363eac01-4dd3-44c2-835a-1c843c9ad176@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764215371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hQ0ZXYaEsqXDUL5h8p3v+NwU49BKhktpBBnYsZDc89I=;
	b=MprLPJcpPK1AcE4rMa8EQXQpeJ8xaMTQGBfWxH6LezFLbZf+L6bnUsNF/Ns+IavWjiNpuv
	JbTSaofPAHEMDRMzawPDXRQ1/ZUX4WK2W+QJBN1PXCrUoZOQlS1cCeNa0kSnICyk5aim5W
	nZ9cof3nDUTQf6/5y1Fjdl4Jhb4qi3Q=
Date: Thu, 27 Nov 2025 11:48:30 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <cdcedd284f5706c557bb6f53858b8c2ac2815ecb.1761658311.git.zhengqi.arch@bytedance.com>
 <aScFNZjGficdjnvD@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aScFNZjGficdjnvD@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 64173C0005
X-Rspamd-Server: rspam02
X-Stat-Signature: ezx3fzgtxr86iz1p9qi7dsmnbzb4xnn9
X-Rspam-User: 
X-HE-Tag: 1764215374-946653
X-HE-Meta: U2FsdGVkX18CXqlmugapq80XTlrjrmwyOOfnmJ01n6Ybj186cSoyNODPCNmmfVTnFrs99mJ4sGSjSsY0d2vxc1PK6WyGVNWJnJ7j3NUdZymAj4dVAptv6Q2LZLeZoINp1UIVF4ptqcM510J2/DNH4DQ2KQZIavTrA7yPtsB9z6m53wdFPt/6dq2A022cbOlBeCQWTeFktiAeDixjsEwx1gFXaX+zcQ017x6IW4SS00YYqp4j+ny8lVt9Q6075anBghJMKC2VZtaSKpm2rVDC8sdwJwf0IKtGqL0KSbajFJAESciOeLHZC3ILjvNF0Q/1+sYojOJehL/PfkWzGT6z2+cNxYzl+vqQK71MGaIyXGSAw2Ph7/gS275gyQCam4+RwfOt9TObQsmeHqcD5nP2ORf76xDRrcmEScK0A90PwgVwyFa3TLW91Fln7/eWyVPT6onba0a7n5nJVjckBXQl+obuG+NqilO707tlqZMGFLCl6Vikvfg5RXSM1SWFvAcH1qub/t93opt9UIq4x4ztvAGaISY/Yaw9NFICgmQnzynYRzAdUeSH256ZrT01dYGp1P8TXKDf/k0kh29zFPxkuKAwBXP49NFkcWLmE5YBw9SOK8JBRkurRAIHDWVNuB7zFiM84ADOHKFy/0+RPAAnUqjBHKhGO+VrAy6SjChJHJmHv5Yt6LkWAgNlLLln4vm9VcePOd6I2c97Xgh1thk2hqlSoDYHH92+Ju5TVy7w+QAUrimmOy2m2qQQI6Su9yCmNDaRFBLjIGoFcM+ExL/abyFrwS2SauHd1ErGffFOEG3/ZmD18LN0nprGKCs1iU5o2wKRaxMZ5NSiRmMJU1BgHQeuS39K6ltxBUjdADGM/zRNNzhoAlCBOVa0tpgmxEVxhgSZCr/GqB9InvPqjHDFuCrI60PUrjWkj/9GtcPdkpEospc2T/14dENAyo6MYnJQC+Ui1mFt8kbo/hRt7sK
 imbkaKuc
 9oRPeiA/LT8m/906BsYBuUacjUx71Ha5tqUP/fT6xaEfRGjV2B4DATvHuxEc7Fw4rbTZHlm41uN4cRLB1mgFY+kkGQE+/j/Kn6UqlRVxN++6PPv3VR1QwrnMBIsreT6qx85PAsh7t9nVMqjBDi5Ph6FQw7VdlYH5k6+U/8yiFB/SGreiqlSgtk7uqyYYvcPxV36KUirSjrUtTEfDrfp0WgVV39Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/26/25 9:48 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:36PM +0800, Qi Zheng wrote:
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
>>   include/linux/mmzone.h | 16 ++++++++
>>   mm/vmscan.c            | 86 ++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 102 insertions(+)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 7aa8e1472d10d..3ee7fb96b8aeb 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4468,6 +4468,92 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
>>   		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
>>   }
>>   
>> +bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
>> +		int type;
>> +
>> +		for (type = 0; type < ANON_AND_FILE; type++) {
>> +			if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
>> +				return false;
>> +		}
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * We need to ensure that the folios of child memcg can be reparented to the
>> + * same gen of the parent memcg, so the gens of the parent memcg needed be
>> + * incremented to the MAX_NR_GENS before reparenting.
>> + */
>> +void max_lru_gen_memcg(struct mem_cgroup *memcg)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
>> +		int type;
>> +
> 
> I was testing this series and observed two warnings...
> 
>> +		for (type = 0; type < ANON_AND_FILE; type++) {
>> +			while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
>> +				DEFINE_MAX_SEQ(lruvec);
>> +
>> +				inc_max_seq(lruvec, max_seq, mem_cgroup_swappiness(memcg));
>> +				cond_resched();
> 
> Warning 1) Here we increment max_seq but we skip updating mm_state->seq.
> (try_to_inc_max_seq() iterates the mm list and update mm_state->seq after
> an iteration, but since we directly call inc_max_seq(), we don't update it)
> 
> When mm_state->seq is more than one generation behind walk->seq, a warning is
> triggered in iterate_mm_list():
> 
>          VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->max_seq);
> 
> Warning 2) In try_to_inc_max_seq(), the last walker of mm list
> is supposed to succeed to increment max_seq by calling inc_max_seq():
> 
>          if (success) {
>                   success = inc_max_seq(lruvec, seq, swappiness);
>                   WARN_ON_ONCE(!success);
>           }
> 
> But with this patch it may observe the max_seq is already advanced due to
> reparenting and thus inc_max_seq() returns false, triggering the warning.

Got it. Thanks for testing and reporting!

> 
> I'm learning MGLRU internals to see whether we can simply remove the warnings
> or if we need to do something to advance max_seq without actually iterating
> over the mm list.

Thanks! I will also check on this.

> 


