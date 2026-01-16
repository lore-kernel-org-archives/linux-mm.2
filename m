Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E77D3CCAB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6F76B0089; Fri, 16 Jan 2026 04:50:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5EE6B008A; Fri, 16 Jan 2026 04:50:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8B86B008C; Fri, 16 Jan 2026 04:50:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A89026B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:50:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 605751AF69
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:50:46 +0000 (UTC)
X-FDA: 84337357692.15.28DC6CA
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7E8D74000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:50:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGpEcK2n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768557044; a=rsa-sha256;
	cv=none;
	b=6fkC7mNEGwe7r+ysMBITuaj/rwMsZQQqoT1SSCa36M39hYgCMCoYvFva9Xrr63+A8vnRLI
	LpEIw02R7Q3Ry9t9Ar6IPk7UWp+cMG5HvpsLk14LF/nCwiSIjSIuwhOnXcz1JYduCaKhuo
	K5iz1ThgcSQJnN1t3jQm5OH20xw42J4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGpEcK2n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768557044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tY1zm2yFB+lwMcoske1piKHTmmmXqk4EcOUiZFWewj0=;
	b=2W+ORSMt1UP/9Bv4dlCp3jt7D9oRLkLNN72e4eV2vnUeMgRaTqJxmSOR+CxK5RjUfW3Wcw
	wdM05EAVT1Soo824NUA8RWSV3TosbjkSEgo8Jx/20JbJxhwnIh6QzfIjjYBlGuS760LftS
	ctdQIpJc2uUtX4Lj8jEawzwsUreB/d4=
Message-ID: <e7aa1221-040e-4806-a259-56718844897f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768557042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tY1zm2yFB+lwMcoske1piKHTmmmXqk4EcOUiZFWewj0=;
	b=kGpEcK2nQNm15EhpUE+Or/OubKhk77bch8X3o97W6vBSzb8hrWbDLc/x7oW2aW99vze2S9
	sTexkfhb8Z3YMzcYoP49U2MaVXx6cnuLbrZs3pcVXCNVPa9Zpo26kgIhSQSEHeK2YQ0g2a
	6LgtbQcGV9XKFc/OUw7qBe1Qvv7uMSE=
Date: Fri, 16 Jan 2026 17:50:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
To: Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <0252f9acc29d4b1e9b8252dc003aff065c8ac1f6.1768389889.git.zhengqi.arch@bytedance.com>
 <4a1b69d2-df29-4204-91fd-bb00b52350db@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <4a1b69d2-df29-4204-91fd-bb00b52350db@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ika9og6abej1jk3qjjzypm44rd5yr4yp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E8D74000D
X-HE-Tag: 1768557044-330801
X-HE-Meta: U2FsdGVkX1/mo8OnDbWOl2ENHOEuJXV/JqxoKZ3VW8l/XvW4LmL/+Cd6qE8WuXhbx2D6Co5VnlWexCxORsvTA8Er4TM9RMZun8yGlomgjsnQAWgdTsAgHlRpC2x8Z1adQCtWXxNANVl7vhTxkkNvdRukXj4bxreP1ru2sp0Q7eCprtvjf2hQxdLDc8Ofid/AwFM0QEf6/b/NUwsvQxqbhBiEjTseUN69cwKdI0qtFK/+kMHOOKWiCNgorI8RQoOr+YfIbkvb28Rc2X3tlqR6jf1a7ryRdS1BBN5UED7eAYBIwrw4GehCxATcpgGRMmfNyKxbftnVS0IBhCXQBbqWJpeH7GAAsqTTjAKCA8CfMAJ2Dpjo120NPd4JUs5gFKpfHWcMv21RDrq5ph54CvBnMenBI7hHJ11SiqUh5pgk+AYMd1h5WTA3KTOOHt/yaoGo7Z2DbK7KXHatNYtTaO4XQbX4A/YE2aUYnF//qrry+CcThIpmS/tynBdLRb+Qo6CVO5ten19dGTxD0+h0gdOm38D2kiLZps+sIDOuP0HMJzQM6MNzmJZqr7XfY25VKuZop/z3vEUGZHH7hGHB69My84lUFvLICEC/AhJiZ845MMJFhIYroWiN6ukgo9rEKDO9CyNHz3n5woCJNQa45SEcUp2FpfHl8wPg7pC1P3f31dQ0j/ZhH5JOF2D/f1RwzyfzjgtKOLlA5ukkYVM8ZQ44fM3WDlsWWcjbY++Xkgibphl29XewFWvL32touAo+idF3UNHG5wY3ryS/YVF3a7/4bCpnP16jKgJPWAiR5TeOanWjot4DuzZcCoTOCqo84sHXv6xBxYoCtBOLRCbbXnmLghPc1UcN0kYD3fyYMzCPU7AcCsakZCMZPSauk7FKjpFAN/jkNRpB6XFeEgn301N9br1cMmjLzuAIJOqYqljaLbnmhKXxDFPSFfbJjHOnlmsnHHXyUEom2LTRGlG1ah2
 xYvSVnF7
 EJm2NjZ1JJR21qXSv8LgQHCFU1izhBDMRT0/Hb4p5w5a219fDNqum2wvlyWUH28sNVIwFC31lCAaIfg3QpD6fUs0YPODbMcmCoTpueYOCRYlMTK7qcmd6WQ7shciPk1wnEg9yKzTeZyycgE9+VrvIwklExGJ6APPvCl2BjHjMCep40zHMIol1fP7OFHr72/WMZmT+CSyxt1NgOJtvyAYPDkZ/sVPLkXWP3oyln+hy+rNCjpd+4aSsYK/SspUT9xI517tygt+UpR5t9sBVc6GxCH2Sn5Hw/pU5X/UUa3u8IGw5RI/pglSpqSGpYdP7KmOf64fg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/16/26 5:43 PM, Muchun Song wrote:
> 
> 
> On 2026/1/14 19:32, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> The following diagram illustrates how to ensure the safety of the folio
>> lruvec lock when LRU folios undergo reparenting.
>>
>> In the folio_lruvec_lock(folio) function:
>> ```
>>      rcu_read_lock();
>> retry:
>>      lruvec = folio_lruvec(folio);
>>      /* There is a possibility of folio reparenting at this point. */
>>      spin_lock(&lruvec->lru_lock);
>>      if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>>          /*
>>           * The wrong lruvec lock was acquired, and a retry is required.
>>           * This is because the folio resides on the parent memcg lruvec
>>           * list.
>>           */
>>          spin_unlock(&lruvec->lru_lock);
>>          goto retry;
>>      }
>>
>>      /* Reaching here indicates that folio_memcg() is stable. */
>> ```
>>
>> In the memcg_reparent_objcgs(memcg) function:
>> ```
>>      spin_lock(&lruvec->lru_lock);
>>      spin_lock(&lruvec_parent->lru_lock);
>>      /* Transfer folios from the lruvec list to the parent's. */
>>      spin_unlock(&lruvec_parent->lru_lock);
>>      spin_unlock(&lruvec->lru_lock);
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
>>   include/linux/memcontrol.h | 45 +++++++++++++++++++----------
>>   include/linux/swap.h       |  1 +
>>   mm/compaction.c            | 29 +++++++++++++++----
>>   mm/memcontrol.c            | 59 +++++++++++++++++++++-----------------
>>   mm/swap.c                  |  4 +++
>>   5 files changed, 91 insertions(+), 47 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 4b6f20dc694ba..26c3c0e375f58 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -742,7 +742,15 @@ static inline struct lruvec 
>> *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>>    * folio_lruvec - return lruvec for isolating/putting an LRU folio
>>    * @folio: Pointer to the folio.
>>    *
>> - * This function relies on folio->mem_cgroup being stable.
>> + * Call with rcu_read_lock() held to ensure the lifetime of the 
>> returned lruvec.
>> + * Note that this alone will NOT guarantee the stability of the 
>> folio->lruvec
>> + * association; the folio can be reparented to an ancestor if this 
>> races with
>> + * cgroup deletion.
>> + *
>> + * Use folio_lruvec_lock() to ensure both lifetime and stability of 
>> the binding.
>> + * Once a lruvec is locked, folio_lruvec() can be called on other 
>> folios, and
>> + * their binding is stable if the returned lruvec matches the one the 
>> caller has
>> + * locked. Useful for lock batching.
>>    */
>>   static inline struct lruvec *folio_lruvec(struct folio *folio)
>>   {
>> @@ -761,18 +769,15 @@ struct mem_cgroup 
>> *get_mem_cgroup_from_current(void);
>>   struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
>>   struct lruvec *folio_lruvec_lock(struct folio *folio);
>> +    __acquires(&lruvec->lru_lock)
>> +    __acquires(rcu)
>>   struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
>> +    __acquires(&lruvec->lru_lock)
>> +    __acquires(rcu)
>>   struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
>>                           unsigned long *flags);
>> -
>> -#ifdef CONFIG_DEBUG_VM
>> -void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio);
>> -#else
>> -static inline
>> -void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
>> -{
>> -}
>> -#endif
>> +    __acquires(&lruvec->lru_lock)
>> +    __acquires(rcu)
>>   static inline
>>   struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state 
>> *css){
>> @@ -1199,11 +1204,6 @@ static inline struct lruvec 
>> *folio_lruvec(struct folio *folio)
>>       return &pgdat->__lruvec;
>>   }
>> -static inline
>> -void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
>> -{
>> -}
>> -
>>   static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup 
>> *memcg)
>>   {
>>       return NULL;
>> @@ -1262,6 +1262,7 @@ static inline struct lruvec 
>> *folio_lruvec_lock(struct folio *folio)
>>   {
>>       struct pglist_data *pgdat = folio_pgdat(folio);
>> +    rcu_read_lock();
>>       spin_lock(&pgdat->__lruvec.lru_lock);
>>       return &pgdat->__lruvec;
>>   }
>> @@ -1270,6 +1271,7 @@ static inline struct lruvec 
>> *folio_lruvec_lock_irq(struct folio *folio)
>>   {
>>       struct pglist_data *pgdat = folio_pgdat(folio);
>> +    rcu_read_lock();
>>       spin_lock_irq(&pgdat->__lruvec.lru_lock);
>>       return &pgdat->__lruvec;
>>   }
>> @@ -1279,6 +1281,7 @@ static inline struct lruvec 
>> *folio_lruvec_lock_irqsave(struct folio *folio,
>>   {
>>       struct pglist_data *pgdat = folio_pgdat(folio);
>> +    rcu_read_lock();
>>       spin_lock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp);
>>       return &pgdat->__lruvec;
>>   }
>> @@ -1500,24 +1503,36 @@ static inline struct lruvec 
>> *parent_lruvec(struct lruvec *lruvec)
>>   }
>>   static inline void lruvec_lock_irq(struct lruvec *lruvec)
>> +    __acquires(&lruvec->lru_lock)
>> +    __acquires(rcu)
> 
> It seems that functions marked as `inline` cannot be decorated with
> `__acquires`? We’ve had to move these little helpers into `memcontrol.c`
> and declare them as extern, but they’re so short that it hardly feels

Right, I received a compilation error reported LKP:

All errors (new ones prefixed by >>):

    In file included from crypto/ahash.c:26:
    In file included from include/net/netlink.h:6:
    In file included from include/linux/netlink.h:9:
    In file included from include/net/scm.h:9:
    In file included from include/linux/security.h:35:
    In file included from include/linux/bpf.h:32:
 >> include/linux/memcontrol.h:772:14: error: use of undeclared 
identifier 'lruvec'
      772 |         __acquires(&lruvec->lru_lock)
          |                     ^~~~~~
    include/linux/memcontrol.h:773:13: error: use of undeclared 
identifier 'rcu'
      773 |         __acquires(rcu)
          |                    ^~~
    include/linux/memcontrol.h:775:14: error: use of undeclared 
identifier 'lruvec'
      775 |         __acquires(&lruvec->lru_lock)
          |                     ^~~~~~
    include/linux/memcontrol.h:776:13: error: use of undeclared 
identifier 'rcu'
      776 |         __acquires(rcu)
          |                    ^~~
    include/linux/memcontrol.h:779:14: error: use of undeclared 
identifier 'lruvec'
      779 |         __acquires(&lruvec->lru_lock)
          |                     ^~~~~~
    include/linux/memcontrol.h:780:13: error: use of undeclared 
identifier 'rcu'
      780 |         __acquires(rcu)
          |                    ^~~
    include/linux/memcontrol.h:1507:13: error: use of undeclared 
identifier 'rcu'
     1507 |         __acquires(rcu)
          |                    ^~~
    include/linux/memcontrol.h:1515:13: error: use of undeclared 
identifier 'rcu'
     1515 |         __releases(rcu)
          |                    ^~~
    include/linux/memcontrol.h:1523:13: error: use of undeclared 
identifier 'rcu'
     1523 |         __releases(rcu)
          |                    ^~~
    include/linux/memcontrol.h:1532:13: error: use of undeclared 
identifier 'rcu'
     1532 |         __releases(rcu)

And I reproduced this error with the following configuration:

1. enable CONFIG_WARN_CONTEXT_ANALYSIS_ALL
2. make CC=clang bzImage (clang version >= 22)

> worth the trouble. My own inclination is to drop the `__acquires`
> annotations—mainly for performance reasons.

If no one else objects, I will drop __acquires/__releases in the next
version.

> 
>>   {
>> +    rcu_read_lock();
>>       spin_lock_irq(&lruvec->lru_lock);
>>   }
>>   static inline void lruvec_unlock(struct lruvec *lruvec)
>> +    __releases(&lruvec->lru_lock)
>> +    __releases(rcu)
>>   {
>>       spin_unlock(&lruvec->lru_lock);
>> +    rcu_read_unlock();
>>   }
>>   static inline void lruvec_unlock_irq(struct lruvec *lruvec)
>> +    __releases(&lruvec->lru_lock)
>> +    __releases(rcu)
>>   {
>>       spin_unlock_irq(&lruvec->lru_lock);
>> +    rcu_read_unlock();
>>   }
>>   static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec,
>>           unsigned long flags)
>> +    __releases(&lruvec->lru_lock)
>> +    __releases(rcu)
>>   {
>>       spin_unlock_irqrestore(&lruvec->lru_lock, flags);
>> +    rcu_read_unlock();
>>   }
>>   /* Test requires a stable folio->memcg binding, see folio_memcg() */
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 62fc7499b4089..e60f45b48e74d 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -330,6 +330,7 @@ extern unsigned long totalreserve_pages;
>>   void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
>>           unsigned int nr_io, unsigned int nr_rotated)
>>           __releases(lruvec->lru_lock);
>> +        __releases(rcu)
> 
> Missed a semicolon.
> 
>>   void lru_note_cost_refault(struct folio *);
>>   void folio_add_lru(struct folio *);
>>   void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index c3e338aaa0ffb..3648ce22c8072 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -518,6 +518,24 @@ static bool compact_lock_irqsave(spinlock_t 
>> *lock, unsigned long *flags,
>>       return true;
>>   }
>> +static struct lruvec *
>> +compact_folio_lruvec_lock_irqsave(struct folio *folio, unsigned long 
>> *flags,
>> +                  struct compact_control *cc)
>> +{
>> +    struct lruvec *lruvec;
>> +
>> +    rcu_read_lock();
>> +retry:
>> +    lruvec = folio_lruvec(folio);
>> +    compact_lock_irqsave(&lruvec->lru_lock, flags, cc);
>> +    if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>> +        spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
>> +        goto retry;
>> +    }
>> +
>> +    return lruvec;
>> +}
>> +
>>   /*
>>    * Compaction requires the taking of some coarse locks that are 
>> potentially
>>    * very heavily contended. The lock should be periodically unlocked 
>> to avoid
>> @@ -839,7 +857,7 @@ isolate_migratepages_block(struct compact_control 
>> *cc, unsigned long low_pfn,
>>   {
>>       pg_data_t *pgdat = cc->zone->zone_pgdat;
>>       unsigned long nr_scanned = 0, nr_isolated = 0;
>> -    struct lruvec *lruvec;
>> +    struct lruvec *lruvec = NULL;
>>       unsigned long flags = 0;
>>       struct lruvec *locked = NULL;
>>       struct folio *folio = NULL;
>> @@ -1153,18 +1171,17 @@ isolate_migratepages_block(struct 
>> compact_control *cc, unsigned long low_pfn,
>>           if (!folio_test_clear_lru(folio))
>>               goto isolate_fail_put;
>> -        lruvec = folio_lruvec(folio);
>> +        if (locked)
>> +            lruvec = folio_lruvec(folio);
>>           /* If we already hold the lock, we can skip some rechecking */
>> -        if (lruvec != locked) {
>> +        if (lruvec != locked || !locked) {
>>               if (locked)
>>                   lruvec_unlock_irqrestore(locked, flags);
>> -            compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
>> +            lruvec = compact_folio_lruvec_lock_irqsave(folio, &flags, 
>> cc);
>>               locked = lruvec;
>> -            lruvec_memcg_debug(lruvec, folio);
>> -
>>               /*
>>                * Try get exclusive access under lock. If marked for
>>                * skip, the scan is aborted unless the current context
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 548e67dbf2386..a1573600d4188 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1201,23 +1201,6 @@ void mem_cgroup_scan_tasks(struct mem_cgroup 
>> *memcg,
>>       }
>>   }
>> -#ifdef CONFIG_DEBUG_VM
>> -void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
>> -{
>> -    struct mem_cgroup *memcg;
>> -
>> -    if (mem_cgroup_disabled())
>> -        return;
>> -
>> -    memcg = folio_memcg(folio);
>> -
>> -    if (!memcg)
>> -        VM_BUG_ON_FOLIO(!mem_cgroup_is_root(lruvec_memcg(lruvec)), 
>> folio);
>> -    else
>> -        VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != memcg, folio);
>> -}
>> -#endif
>> -
>>   /**
>>    * folio_lruvec_lock - Lock the lruvec for a folio.
>>    * @folio: Pointer to the folio.
>> @@ -1227,14 +1210,22 @@ void lruvec_memcg_debug(struct lruvec *lruvec, 
>> struct folio *folio)
>>    * - folio_test_lru false
>>    * - folio frozen (refcount of 0)
>>    *
>> - * Return: The lruvec this folio is on with its lock held.
>> + * Return: The lruvec this folio is on with its lock held and rcu 
>> read lock held.
>>    */
>>   struct lruvec *folio_lruvec_lock(struct folio *folio)
>> +    __acquires(&lruvec->lru_lock)
>> +    __acquires(rcu)
>>   {
>> -    struct lruvec *lruvec = folio_lruvec(folio);
>> +    struct lruvec *lruvec;
>> +    rcu_read_lock();
>> +retry:
>> +    lruvec = folio_lruvec(folio);
>>       spin_lock(&lruvec->lru_lock);
>> -    lruvec_memcg_debug(lruvec, folio);
>> +    if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>> +        spin_unlock(&lruvec->lru_lock);
>> +        goto retry;
>> +    }
>>       return lruvec;
>>   }
>> @@ -1249,14 +1240,22 @@ struct lruvec *folio_lruvec_lock(struct folio 
>> *folio)
>>    * - folio frozen (refcount of 0)
>>    *
>>    * Return: The lruvec this folio is on with its lock held and 
>> interrupts
>> - * disabled.
>> + * disabled and rcu read lock held.
>>    */
>>   struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
>> +    __acquires(&lruvec->lru_lock)
>> +    __acquires(rcu)
>>   {
>> -    struct lruvec *lruvec = folio_lruvec(folio);
>> +    struct lruvec *lruvec;
>> +    rcu_read_lock();
>> +retry:
>> +    lruvec = folio_lruvec(folio);
>>       spin_lock_irq(&lruvec->lru_lock);
>> -    lruvec_memcg_debug(lruvec, folio);
>> +    if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>> +        spin_unlock_irq(&lruvec->lru_lock);
>> +        goto retry;
>> +    }
>>       return lruvec;
>>   }
>> @@ -1272,15 +1271,23 @@ struct lruvec *folio_lruvec_lock_irq(struct 
>> folio *folio)
>>    * - folio frozen (refcount of 0)
>>    *
>>    * Return: The lruvec this folio is on with its lock held and 
>> interrupts
>> - * disabled.
>> + * disabled and rcu read lock held.
>>    */
>>   struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
>>           unsigned long *flags)
>> +    __acquires(&lruvec->lru_lock)
>> +    __acquires(rcu)
>>   {
>> -    struct lruvec *lruvec = folio_lruvec(folio);
>> +    struct lruvec *lruvec;
>> +    rcu_read_lock();
>> +retry:
>> +    lruvec = folio_lruvec(folio);
>>       spin_lock_irqsave(&lruvec->lru_lock, *flags);
>> -    lruvec_memcg_debug(lruvec, folio);
>> +    if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>> +        spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
>> +        goto retry;
>> +    }
>>       return lruvec;
>>   }
>> diff --git a/mm/swap.c b/mm/swap.c
>> index cb1148a92d8ec..7e53479ca1732 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -240,6 +240,7 @@ void folio_rotate_reclaimable(struct folio *folio)
>>   void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
>>           unsigned int nr_io, unsigned int nr_rotated)
>>           __releases(lruvec->lru_lock)
>> +        __releases(rcu)
>>   {
>>       unsigned long cost;
>> @@ -253,6 +254,7 @@ void lru_note_cost_unlock_irq(struct lruvec 
>> *lruvec, bool file,
>>       cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated;
>>       if (!cost) {
>>           spin_unlock_irq(&lruvec->lru_lock);
>> +        rcu_read_unlock();
> 
> Better to use lruvec_unlock_irq(lruvec)？
> 
>>           return;
>>       }
>> @@ -284,9 +286,11 @@ void lru_note_cost_unlock_irq(struct lruvec 
>> *lruvec, bool file,
>>           }
>>           spin_unlock_irq(&lruvec->lru_lock);
>> +        rcu_read_unlock();
> 
> Ditto.
> 
>>           lruvec = parent_lruvec(lruvec);
>>           if (!lruvec)
>>               break;
>> +        rcu_read_lock();
>>           spin_lock_irq(&lruvec->lru_lock);
> 
> lruvec_lock_irq(lruvec)?

OK, will do.

Thanks,
Qi

> 
> 
> Thanks.
>>       }
>>   }
> 


