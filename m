Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0099DD68BE2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6164F6B0088; Thu, 18 Dec 2025 01:50:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4A46B0089; Thu, 18 Dec 2025 01:50:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D09B6B008A; Thu, 18 Dec 2025 01:50:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7896B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:50:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E00F061015
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:50:36 +0000 (UTC)
X-FDA: 84231668472.01.AAE257E
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2F8ED40004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:50:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qqYeirWs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766040635; a=rsa-sha256;
	cv=none;
	b=PyRDa9lzqBIlRAu7mqP6rkWuw9aUfmBX1AI2rcExAaqlGZxNkigo0aZzR/dDln/sza8aS8
	ImBkt4eI214kdnApx20fkFw1F4GMH/nS9wsEUrbkL6Itg0Gl2yxUN36jxguYNtT5wzl8VW
	YiUPvYZRq+ye1GWoaX+yuEdO6ZijXoo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qqYeirWs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766040635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dW1sFUrpgDlh6EpvXxN9ly9S/e1gx9r8RyoILFDsHvs=;
	b=JSZ3lf/3NomPN/0RmKF2APwTHmDZxknRpLrxj2QPE+jNNNZrEiDz6ur+0dmfPKT8yMIKO4
	a5JK25uGIqLpQ9NRW+w783yztH7q80vuNKq61hY5JfVUYH5z+7Ma/GjFelR5qyg+Vdo8Da
	la1HZLClc3SfTxLbHnXLl77UP29fkcY=
Message-ID: <4513ee04-03ff-4de0-bbf4-b5b35dfd41ad@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766040631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dW1sFUrpgDlh6EpvXxN9ly9S/e1gx9r8RyoILFDsHvs=;
	b=qqYeirWsSALh+5MJ3vqdKKt01VPxpqJMm9SbwN9uQ2gnloClPekoB/b0dUyK0Q/KKCItnz
	lQxU2gJPqVR6ATWE/UNNaLHwgFbkLxIPksppMfCKHALKrQuapRMg2sVGEJQXMUT+PkABkK
	4+ude2eYI1txPiaCzHrkn0AnpdXTx7A=
Date: Thu, 18 Dec 2025 14:50:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 14/28] mm: mglru: prevent memory cgroup release in
 mglru
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <ab60b720d6aef1069038bc4c52d371fb57eaa6e8.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMsQPjBtYtVWjwf@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUMsQPjBtYtVWjwf@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F8ED40004
X-Stat-Signature: bk5obq9f7riqxd97i48kzz5rirf1fotd
X-Rspam-User: 
X-HE-Tag: 1766040634-826586
X-HE-Meta: U2FsdGVkX1/FsUfiBSVl7sNmsFS9eRtAghalrXIgsVNqKnzwDFQkJ+MDiM9vJ6eGf0A/HoAnA9+y3BWA9vD+6LEIGUNR2U+OUT99pjErHgRofJ7EB478sfthy3hLIlVRN26MS4ODsXIC8dl2TLz48qsrZppx/U1tCwYnhCRe8NheOumbwiUn4A4kFY0EebFob3T95DHYdhfDc4hmb4j3wyQKoArEnqfe25it0n62gBZpwAN7jG9uZeTSBNJSDaZiZTpPV5hC0W/neJ+pugVmv6AWFLIi8+ESB0CmPuJrhNVxoWsdi2uyAac8bi3SUWzscxeGtVpmEct6UUyJeDdtvz4PaBaltRHrSZ6XeYk7Az98YqF+2gDA9SzCAYA1MzmTL7k4dU7ii64Sd7TPw5+bbd+SXVJSCInu35nNp8BoDhl5lmMCil72B5/uiQuFw10Cvy4UfNBdODaFR13M5TKsbMT0rtwy/WI4qov+QujW9aidN3Yb7zhcTIIZi567XvEcJG4h5mO5RLWLsLtzos+a+IH1FKczgZEJdNf5Vq2aJoSboQ+PvxEs11k+Se/SxTsA/hoL0JWby01/VDpggceYAHLE0jGbGRvjtJ5eZuyWCAQvk8dgO5tQ5w3LsTQu8dDYuH3mcGlq+/6KbIMm2AByrwVgE4PaHs+S29qIuNrSaypuFNLgyIGADqBR47C0EGjtGh6udxODqTOVNM+1CRF38sgLlad9PiK5pnAJRbtogSmUB4rpbh4SWrYUQrmX49nFou2d0Zv/Y32umPm1bvJCVI4vDN99t8QVeSTGpcxlzfIKcNQWLfUKxtFd2xEDl1xe43OMAhDsGyK9/1RnTdaVKaUFC+E6xga4N9YpC6pT71PdW7yNFIYr/Spw35uKfflPT7lbEDKA4mEoCdBPLAaRG8FQwwiMj9RmxFcKr1fWe2FRJ52iVsg0zxZhUuW9FABHWUmYmIEgtcGcx1mk4IQ
 ZrhLz9iE
 61MjMc5g6is5anUxy/p8VQ69VdUw2lMu/vmIRbyfeUw2UaDacKX08629O3itVpnSXDt4nvmr4rueb/NLlz34DEHeRWoMVY7VxYphuOdTZxzboui9bYiuZozoEpAtLRsTHbJGJxRUTkGdOpeTt8WtQhTWbcOQA0UBzOVJv/f7SVfBfWZ9mc50y+pn1yvPCZdOoKBYuS0/paXLi1157pK2SIeDq0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 6:18 AM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:38PM +0800, Qi Zheng wrote:
>> @@ -4242,6 +4244,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>>   		}
>>   	}
>>   
>> +	rcu_read_lock();
>> +	memcg = folio_memcg(folio);
>> +	lruvec = mem_cgroup_lruvec(memcg, pgdat);
>> +	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
>> +	gen = lru_gen_from_seq(max_seq);
>> +	mm_state = get_mm_state(lruvec);
>> +
>>   	arch_enter_lazy_mmu_mode();
>>   
>>   	pte -= (addr - start) / PAGE_SIZE;
>> @@ -4282,6 +4291,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>>   	if (mm_state && suitable_to_scan(i, young))
>>   		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
>>   
>> +	rcu_read_unlock();
>> +
>>   	return true;
> 
> This seems a bit long to be holding the rcu lock. 

Indeed.

> Maybe do a get and a
> put instead?

OK, will use get_mem_cgroup_from_folio(folio) to do this.

This way, #8 doesn't need to be folded into #27.




