Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C619FD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 11:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4596B03CB; Tue, 20 Jan 2026 06:51:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC076B03CC; Tue, 20 Jan 2026 06:51:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A606B03CD; Tue, 20 Jan 2026 06:51:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E001D6B03CB
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:51:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81DC35904C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:51:52 +0000 (UTC)
X-FDA: 84352178064.23.3FD297A
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89B81A0006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:51:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FoBP3E4u;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768909911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9xxVtMuSeOSiPFHs2DPvF1bZM+k4doJowUTIgEXb84=;
	b=aKZV8vQSpQPh4S3i1G+QYoOSFYOZyuKM7adztk20rVtLJEcENjVNgadj8SvYmiZS9hDCHW
	Jl/lk5djda0J20QrUzEKR778QzeUiMbtzIikFmZ3Bdqsoe0m2ozg7FbGITgzGCTp1BH5oc
	I3CaifbhRWhdx8DYJuujaG3zSKLI6kQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FoBP3E4u;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768909911; a=rsa-sha256;
	cv=none;
	b=TM2r91JDnxVJ55zLWWTjJgo3RI3xd3/l4gOSjbNjxklqUaLi2BBg8Fb0Oj+GwQK0cgcwkI
	8aW+5I3EcCLVdplp8T35o+efT00vV3ydxws3N5DymJLPx6jaj1RYDLsnnGF2rnCs7vpYfo
	MZygbwv9MFDHhiVBWbmotVVXb/JtIv4=
Message-ID: <88d90d30-8f54-43f5-98d6-1769aa05a10a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768909908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x9xxVtMuSeOSiPFHs2DPvF1bZM+k4doJowUTIgEXb84=;
	b=FoBP3E4uU4cp25iVs0YnuLXf8CmTrLWVI1GO/15ajs+mzhMyEradq4fhK4j0VFhngoJ5kb
	qw0gnnUyDkR14vYXjGlGgA9V4nPaMOxs8iZwchUgWN6gFNOpS0ruLM+dl7Uex3jPp9EbCf
	oGjXSaTppQvh1No36QGTU8/5TF9RLj8=
Date: Tue, 20 Jan 2026 19:51:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <0252f9acc29d4b1e9b8252dc003aff065c8ac1f6.1768389889.git.zhengqi.arch@bytedance.com>
 <aW86_5SOdtQQnVr7@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aW86_5SOdtQQnVr7@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 89B81A0006
X-Stat-Signature: tffyeh6o4b1ihp37ukd7osrb7fy71pwn
X-HE-Tag: 1768909910-553523
X-HE-Meta: U2FsdGVkX19oUN9LXneq10YvOCV01uUwOHQw+gUUEHs44DY/XIAcAxOZ1bgzVwxtAvfBmcWzvuLvMePUZYe1iFUFywjM3/DRBKWioylSalKXRa4Zj+eNsEVIuLnHSemttQEZ6sBbccZbQi8AirrNWUKU/BHebN5ECam+9MvnxFAu/H5IOKg/HiafEyES/rIgxZG31iz7wV25IWNDwkTgAKWb/7pQTPBASiow79/T84CnsXr7WxfYM01FYrixkHBprEsd3esDSfoXmTDJif2pvsmvy5KN+UjC4hEMRFPImQBmi0Vzyj1jcb5ne9sRy93FR0wLSBIYRZUFwZwGWD/F8WVPFrtVwErh1suXOHptMnq8aB9G+LwdvlBGDvIy7H/fxYg1iVTXrvKdEdozG26WoFXlp0VnL8FlkQHM8fzhmEv0yxM8g9ONOdxK0HwLJbT4Ys6zUjAZovdj6OiuA8mOF5BcrdRmI2ZZ7EScMr4V1XxA4U7sQ9Ls397M8ydL7GwT+xhxr7CoSPm0mRtcsenYn4lZgeNrmIY+c8ua6OlelRwzD1r8YFgeUvrJw5gWFWt7ptCpzWwujFXVyIZ6dvi30vOWvYnMxT35Uti2F/7i/SGWSu4XYORdLd9cH+h5TUrBp5JCtnFZ9tloNrsmqADPT15i41cxHnR3grz0VxQyySPH9W4S6jto+5Rn3R9FJOqJI4HvOuWqQXuWYSwY2l8WyrOa+8zKHp6rxny+U8aaRybBT0Do4JA3G5eWinwtfBFWKoy30LUvbUG6UO76zCdoGbuk5ZceFHta8jSvnxMRwXV2NXM2mdwfnK7QIHFUn6ewsszQJP4qzX0cwIT43rar16GJECEqJWs1QywCopOowpImy0DlxxFZGRiEqm8EjbTx2FyHWRoEVVpa0qyYI39JKCYRVSgq6YRYdoaTptfxSILorLZWRUWe3NuZS9wnF+mrorIOucInCdzHCFQMstk
 w9bmI2L0
 2qZ7tDjciZxOkP/NPjEZJRJSVW3uvfI0KNZ9Q7sqxx2YhQsqLrEtAurkYYqHYM52eiHFIXHzqHFF5Gj+087lHHsbA/m+A5AXubdiXsLchui/OmleMFhsL1daMOCMcCoKq7cKJ0X+pMI2A0v6AkwOzZBBtIEeCGKCM2QS1l7bwYt+vbCRCSUv83SgbVdhBG0Rhq7X7o05ALT0/L9ViDMPdnE2MFNYiT/UXDJ7lCGfTkdNEXV/2sCpbkJQ3GW3a+1JNLRjSBibnuogB2VY3Wd5tMPkUHyjh+/KPdsiuvB5f0OZ/fbnKaSCsWE2fJr4vvge6AhVWkWph18CQiLY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/20/26 4:21 PM, Harry Yoo wrote:
> On Wed, Jan 14, 2026 at 07:32:51PM +0800, Qi Zheng wrote:
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
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> ---
>>   include/linux/memcontrol.h | 45 +++++++++++++++++++----------
>>   include/linux/swap.h       |  1 +
>>   mm/compaction.c            | 29 +++++++++++++++----
>>   mm/memcontrol.c            | 59 +++++++++++++++++++++-----------------
>>   mm/swap.c                  |  4 +++
>>   5 files changed, 91 insertions(+), 47 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 4b6f20dc694ba..26c3c0e375f58 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -742,7 +742,15 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>>    * folio_lruvec - return lruvec for isolating/putting an LRU folio
>>    * @folio: Pointer to the folio.
>>    *
>> - * This function relies on folio->mem_cgroup being stable.
>> + * Call with rcu_read_lock() held to ensure the lifetime of the returned lruvec.
>> + * Note that this alone will NOT guarantee the stability of the folio->lruvec
>> + * association; the folio can be reparented to an ancestor if this races with
>> + * cgroup deletion.
>> + *
>> + * Use folio_lruvec_lock() to ensure both lifetime and stability of the binding.
>> + * Once a lruvec is locked, folio_lruvec() can be called on other folios, and
>> + * their binding is stable if the returned lruvec matches the one the caller has
>> + * locked. Useful for lock batching.
>>    */
>>   static inline struct lruvec *folio_lruvec(struct folio *folio)
>>   {
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 548e67dbf2386..a1573600d4188 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> diff --git a/mm/swap.c b/mm/swap.c
>> index cb1148a92d8ec..7e53479ca1732 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -284,9 +286,11 @@ void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
>>   		}
>>   
>>   		spin_unlock_irq(&lruvec->lru_lock);
>> +		rcu_read_unlock();
>>   		lruvec = parent_lruvec(lruvec);
> 
> It looks bit weird to call parent_lruvec(lruvec) outside RCU read lock
> because the reason why it holds RCU read lock is to prevent release of
> memory cgroup and its lruvec.
> 
> I guess this isn't broken (for now) because all callers of
> lru_note_cost_unlock_irq() are holding a reference to the memcg?

I checked all the callers again, and they do indeed hold the refcnt
for the memcg, so it's safe for now. But it seems rather fragile,
perhaps we should also include parent_lruvec() within the RCU lock.

> 
>>   		if (!lruvec)
>>   			break;
>> +		rcu_read_lock();
>>   		spin_lock_irq(&lruvec->lru_lock);
>>   	}
>>   }
> 


