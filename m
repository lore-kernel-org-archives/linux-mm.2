Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B469FD6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297C76B0088; Thu, 18 Dec 2025 08:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2419D6B0089; Thu, 18 Dec 2025 08:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162FF6B008A; Thu, 18 Dec 2025 08:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07B9C6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:17:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A16601DFAE0
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:17:26 +0000 (UTC)
X-FDA: 84232643292.03.3F40721
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB9C8A000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:17:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vld/X1XQ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063845; a=rsa-sha256;
	cv=none;
	b=UiLHuvpXvPwSDjo097R7BagT1QzyVnAbuP8kcmtD0YuKotWb0myziKzDaAj5y5nh1sYZKK
	MJgCqz24LJBb54OpBiUiUu3YOEb2AqaMXm98LHQKtSZl7p5atw8osmthm9uNF1TtycHY/O
	muEugfvG/yW9yomqIqF4AxCGKA7e2kk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vld/X1XQ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrnloR37d7v9/SAkXdgcilFjy/jvJ7jYp/30DAx8M64=;
	b=wJZby9DdrB5Hzu/TnTW/6xP+OOCyKAHQf2LI/8Nu1OaCxN8T4QC9OuwMYXkIvMEgJG8uYt
	xoThB1BeC3EDIiVWdq37JXkqw3BH2FwCZIKNUqBvWMOKgTLkiLPqUSEHy9mrN1StQx5mYE
	zscaD4Ek9fflS7jne7vjamHbbqbBfqo=
Message-ID: <c1dfbf2f-123e-49c7-9a05-c593e8a1b43a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766063837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrnloR37d7v9/SAkXdgcilFjy/jvJ7jYp/30DAx8M64=;
	b=vld/X1XQQrbVF44u/mRdkjbB9pSzWBcemyKWchoxfSV3s/EgcyWQdaGZxSEalDtj7ksg42
	TUy9FBWMLYA+LDMHysOJHZwPIM5FLtYU58RAykLZjSvsnKS2Jpyo5bcxMEhNIrnEGW9iko
	fm66XNkTWDTCO2V7FyhrIL5LK+roYxM=
Date: Thu, 18 Dec 2025 21:17:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 23/28] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
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
 <6d643ea41dd89134eb3c7af96f5bfb3531da7aa7.1765956026.git.zhengqi.arch@bytedance.com>
 <aUP6_o9WqPv8Y7d-@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUP6_o9WqPv8Y7d-@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB9C8A000F
X-Stat-Signature: oo4th33xhsb5kpmg6xrpe8tieo9qfk1z
X-HE-Tag: 1766063844-494628
X-HE-Meta: U2FsdGVkX1/oIUoyn5tfNfE+MIu15JitRR44yWjfm8PT2qDNM/17zrRmwQucp6S/1qVAikJC76aN88iJtyNIy+jC8fv5L/elEW34t08EFRkjzU9eafWus+AsZb2xXEqtYjS3q9aUQDKJzHRaTNYPMB/Ss9bReAyj5kWhWro8qhmWu766aRlYWKa2W3MDmbdiiIF7SwVuKAOnD9+jJ8Tet5tBHGhVteECBqAIc3mO86QWSJN2GTAzkL5hCMJIpf1uIOW9LMbeZiGb79Td2EV5QpUxi38EI/0FjHT6fje65fygCWFVVE2VgSIkUvTh2nps8eR6dellnYZWoKrfoSFbN9axLCJYJI0dqTKTQaQSVut8t+nK4JYJN3FSe4YZ6Nrc5ynL0kNb8MUXpncH6qrELhQGjNQAxYciso7d3LcV6Elc/adjhEWdIPJEz0D7d/NpAijBney/rGZV2aJ3buS4mOhROo21V8fXOwQOmCXx/e26iFYgJRbnt39VqAEU0yZRiiSEhM+M32jM7QUSNQgbmd2GFg2XBvSGU6iTflM+P114K1dxNv8u7y6lsXAfT/xaZNCAcfwn0r4REiXwQyPWBqNSxTx2W7+hrixeBTXAKpiV0MctrfYF/IoM4EpfFS1WGszm/Du934mG5ixunrYUKZqzt6+CNhJDA+SaDbrppuzVki6U9rUTTlPpirnM0wZpiJ+WO0OOuBea9yiLIy/lLr6W32z53HAj44CtCaJWH9TlIF/MPl7t2CxKmL9wsSEMqikNsqZLqrXXHrOdMawqeKdK5wuZIhEsj/dadBpf6Gy7f7SMF/ax/SygM8ixLf9Ke/6QB+3j1QdjGsmcMIBDESSezHZzhn6F/r3Kz4bwj+AhxxnPgcSS0pe2uHrBz+QgWk2Mhxw6XX2hsIhDspU3xA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 9:00 PM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:47PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> The following diagram illustrates how to ensure the safety of the folio
>> lruvec lock when LRU folios undergo reparenting.
>>
>> In the folio_lruvec_lock(folio) function:
>> ```
>>      rcu_read_lock();
>> retry:
>>      lruvec = folio_lruvec(folio);
>>      /* There is a possibility of folio reparenting at this point. */
>>      spin_lock(&lruvec->lru_lock);
>>      if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>>          /*
>>           * The wrong lruvec lock was acquired, and a retry is required.
>>           * This is because the folio resides on the parent memcg lruvec
>>           * list.
>>           */
>>          spin_unlock(&lruvec->lru_lock);
>>          goto retry;
>>      }
>>
>>      /* Reaching here indicates that folio_memcg() is stable. */
>> ```
>>
>> In the memcg_reparent_objcgs(memcg) function:
>> ```
>>      spin_lock(&lruvec->lru_lock);
>>      spin_lock(&lruvec_parent->lru_lock);
>>      /* Transfer folios from the lruvec list to the parent's. */
>>      spin_unlock(&lruvec_parent->lru_lock);
>>      spin_unlock(&lruvec->lru_lock);
>> ```
>>
>> After acquiring the lruvec lock, it is necessary to verify whether
>> the folio has been reparented. If reparenting has occurred, the new
>> lruvec lock must be reacquired. During the LRU folio reparenting
>> process, the lruvec lock will also be acquired (this will be
>> implemented in a subsequent patch). Therefore, folio_memcg() remains
>> unchanged while the lruvec lock is held.
>>
>> Given that lruvec_memcg(lruvec) is always equal to folio_memcg(folio)
>> after the lruvec lock is acquired, the lruvec_memcg_debug() check is
>> redundant. Hence, it is removed.
>>
>> This patch serves as a preparation for the reparenting of LRU folios.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/memcontrol.h | 26 ++++++++-----------
>>   mm/compaction.c            | 29 ++++++++++++++++-----
>>   mm/memcontrol.c            | 53 +++++++++++++++++++-------------------
>>   3 files changed, 61 insertions(+), 47 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 69c4bcfb3c3cd..85265b28c5d18 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -740,7 +740,11 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>>    * folio_lruvec - return lruvec for isolating/putting an LRU folio
>>    * @folio: Pointer to the folio.
>>    *
>> - * This function relies on folio->mem_cgroup being stable.
>> + * The user should hold an rcu read lock to protect lruvec associated with
>> + * the folio from being released. But it does not prevent binding stability
>> + * between the folio and the returned lruvec from being changed to its parent
>> + * or ancestor (e.g. like folio_lruvec_lock() does that holds LRU lock to
>> + * prevent the change).
> 
> Can you please make this separate paragraphs to highlight the two
> distinct modes of access? Something like this:
> 
> Call with rcu_read_lock() held to ensure the lifetime of the returned
> lruvec. Note that this alone will NOT guarantee the stability of the
> folio->lruvec association; the folio can be reparented to an ancestor
> if this races with cgroup deletion.
> 
> Use folio_lruvec_lock() to ensure both lifetime and stability of the
> binding. Once a lruvec is locked, folio_lruvec() can be called on
> other folios, and their binding is stable if the returned lruvec
> matches the one the caller has locked. Useful for lock batching.

OK, will do in the next version.

> 
> Everything else looks good to me.
> 
> Thanks for putting so much effort into making these patches clean,
> well-documented, and the series so easy to review!
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks!



