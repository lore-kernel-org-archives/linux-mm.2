Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C54BD41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27176B00BC; Thu, 15 Jan 2026 04:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC82D6B00BE; Thu, 15 Jan 2026 04:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0B16B00BF; Thu, 15 Jan 2026 04:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBE126B00BC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:26:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CB328A87B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:26:59 +0000 (UTC)
X-FDA: 84333668958.25.D2145B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 74F321C0002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:26:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GTPbEKNv;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768469217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3P5TXz9n5urVuMSto49THOUDq4k6hsZfwksZf+Xzdg=;
	b=WcasXYoiunsh40HB0TjAW6moEpl03Kf3Hz+p8Z6eDsvef04Qlf9gPEmjMIcFd4+/vopgqS
	rBRfhrjMO26aid3W9a3Afl80G5u/aOyJOJU560rZ4bkpO+cDYkhM38dTHpnkePgo4V06FH
	7iJuS0MKsgX97E0P7ufqo7OAxfGeOx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768469217; a=rsa-sha256;
	cv=none;
	b=xK2gZx52RDvhmNDRzAP9KLCTPW9So7qdMx7UmbfQ1fj+gVHJY2ji+ck5eF83pmazfQ/e7p
	lNKWEJEXS5KtMTthTgzB1QsC0II1IIEShSjQKLxE7soX9knqGxSQpsOlxPejxetEHjZNM1
	oOa/sIjKeikLRPA30UYHkIo4fYIZbfA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GTPbEKNv;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768469216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3P5TXz9n5urVuMSto49THOUDq4k6hsZfwksZf+Xzdg=;
	b=GTPbEKNv/izx7XIIDaEzfYfGIzl4SYts/eHc9xJCuCXH1GMBMPBnuiSCWeJbVBvubANgdN
	YdDI16ptomUcDvL6zVsgsYeQF+poLd+Th6q5yNmsLSv8KTXoSrdzM2JBQK8scMJEFUQxuO
	LnWDZPAeL3IOHVDM8vlWk5VsER636Xs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-3KKHiIK4PEicFgHIz8RiFw-1; Thu,
 15 Jan 2026 04:26:52 -0500
X-MC-Unique: 3KKHiIK4PEicFgHIz8RiFw-1
X-Mimecast-MFC-AGG-ID: 3KKHiIK4PEicFgHIz8RiFw_1768469209
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9EE51800473;
	Thu, 15 Jan 2026 09:26:48 +0000 (UTC)
Received: from localhost (unknown [10.72.112.110])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA338180066A;
	Thu, 15 Jan 2026 09:26:46 +0000 (UTC)
Date: Thu, 15 Jan 2026 17:26:42 +0800
From: Baoquan He <bhe@redhat.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 23/30] mm: do not open-code lruvec lock
Message-ID: <aWiy0mDN0Ed9mLiG@MiWiFi-R3L-srv>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <33fef62fd821f669fcdc999e54c4035a4e91b47d.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33fef62fd821f669fcdc999e54c4035a4e91b47d.1768389889.git.zhengqi.arch@bytedance.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74F321C0002
X-Rspam-User: 
X-Stat-Signature: jiywjg1y7x5aw6bifmyjy7zn9y8ydu1n
X-HE-Tag: 1768469217-977023
X-HE-Meta: U2FsdGVkX191/2bCwr5lQ0U7jXPwoaxAI+dyLZjsiJibtZ09i8XvLB/A0c3ZwFL8TafmVTcBQvCOy1TLk5pT5eajgnc+4iK/ouRB1F4TXEQNS8+2ws+bWB5adUlH+CjcEfszctt2O/XQ31LVZAKahKHoHaSV1tYKCTWzi+XUL+jrs1cKlFt4qeIvcwm47r7V4og6WKCQmL9vdGchSUfEsp8pBDAdLSOaOxfpqKKwFgxUlZmqp86lFFsX8+iSNUDEMVe7CL3MazR04luLW2Lv0D+9Q3o801MrG05vj1tcwBEE5M50YM2lCwgX6VmkoTspZug5gthq1Oad6I0qiDge2oZt5EhCJEl+8DNFpgcXtB8tTdjaC73aT18nIXNBj8tFy1CRoeMtQ6SvBz6yz05WKx3Rt1f1iNXaK2kaCNxdupvq2xjuODZt4NSA1vQJfeMo5ci1762cxCYt+zZxn045NNE+2Rfu+2rDXfXvjLuVclImSbgX/BgQv6XdqTTl7/upVxVuVI4vbRIVQrfh4ajv1CgPRQANbKbOXWM+HrPCObTVvH+cGIP+Vz6RfOpJcx0bx4JKnU04Mnbv0jhI02JoITCrHP64gghl2b9kVhBycRhMJhrAzs0f7T6WC8IdOb+y9jJAgpqn1qrKpRm+SM0IlP2bmTXDheyQvUHhCvbOPJRCcEe9Gks0whyiyRMDwJlTcCwtZADPWO3wIczmb3bVRwEgHnyTzp/G7oWGmnTtJME3gVdBzFVfoyKEfJSIqKI1OorefcJqMf/kC3VkjdvTXbCDOxjec2JXrH8HuoQNWm4RTGmx5qLJngGd74GyQBTlkLLZfH+NVxdwgYuFAA8O4pQ4/dJXGQ/NfbwLxM6l2Lg9lsFV17/UnOQQfM1Dovm7RBp+ep9TDyGyWIewNo+3F4nbLzNK0sx224d18uGRUwgIAJlsrwZpDJ875JSTG8fhqq9KnPzJm2Co/H4qiGP
 6yUfBPKN
 LCooAcVZw8NOfh/bcvDc3yClu6fJnTcAtCRf5kCas6apNZCkjw+q1S8tFTutRqztx1F9xzMd07zbcZwXkNWjOvmJO8kVS9u/RJXTghrZTi19ZSyvl40tuRBmasXJKDHX9bJh7xBFC4ccG3yIJggw9Ejz6KSlOG57tMPE4NjKy9EO30A8N/ZlcwXu9m132AfGAc8+G+XnprOHrWP+f6uoBDnQkksZc8Ee6dmiWhn/bC6+d/ylzJAXa4RbUcHUtL+6BJnrGgTT2+wHiKGPWRdbN4c/fOEHHxDBLhZw3CyJXJzAanxolio7b8ZdHbpsd3w5DmG8NV80F/WJqVyZcDYw1WEYO0kpVhmiLsinsVO6iGm85QJrT2mxqNyVwJRsqhv4IuwIx0jgsQyn+rewK4E4VHS4eHl+40Po2C55SEpBymzKg0eY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/14/26 at 07:32pm, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Now we have lruvec_unlock(), lruvec_unlock_irq() and
> lruvec_unlock_irqrestore(), but not the paired lruvec_lock(),
                                  ~~ typo, 'no'?
> lruvec_lock_irq() and lruvec_lock_irqsave().
> 
> There is currently no use case for lruvec_lock_irqsave(), so only
> introduce lruvec_lock() and lruvec_lock_irq(), and change all open-code

  I didn't see lruvec_lock() is introduced in this patch, do I miss
  anthing?

> places to use these helper function. This looks cleaner and prepares for
> reparenting LRU pages, preventing user from missing RCU lock calls due to
> open-code lruvec lock.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/memcontrol.h |  5 +++++
>  mm/vmscan.c                | 38 +++++++++++++++++++-------------------
>  2 files changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f1556759d0d3f..4b6f20dc694ba 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1499,6 +1499,11 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
>  	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
>  }
>  
> +static inline void lruvec_lock_irq(struct lruvec *lruvec)
> +{
> +	spin_lock_irq(&lruvec->lru_lock);
> +}
> +
>  static inline void lruvec_unlock(struct lruvec *lruvec)
>  {
>  	spin_unlock(&lruvec->lru_lock);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f206d4dac9e77..c48ff6e05e004 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2020,7 +2020,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  
>  	lru_add_drain();
>  
> -	spin_lock_irq(&lruvec->lru_lock);
> +	lruvec_lock_irq(lruvec);
>  
>  	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
>  				     &nr_scanned, sc, lru);
> @@ -2032,7 +2032,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
>  	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
>  
> -	spin_unlock_irq(&lruvec->lru_lock);
> +	lruvec_unlock_irq(lruvec);
>  
>  	if (nr_taken == 0)
>  		return 0;
> @@ -2051,7 +2051,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
>  	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
>  
> -	spin_lock_irq(&lruvec->lru_lock);
> +	lruvec_lock_irq(lruvec);
>  	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>  					nr_scanned - nr_reclaimed);
>  
> @@ -2130,7 +2130,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  
>  	lru_add_drain();
>  
> -	spin_lock_irq(&lruvec->lru_lock);
> +	lruvec_lock_irq(lruvec);
>  
>  	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
>  				     &nr_scanned, sc, lru);
> @@ -2141,7 +2141,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  		__count_vm_events(PGREFILL, nr_scanned);
>  	count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
>  
> -	spin_unlock_irq(&lruvec->lru_lock);
> +	lruvec_unlock_irq(lruvec);
>  
>  	while (!list_empty(&l_hold)) {
>  		struct folio *folio;
> @@ -2197,7 +2197,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
>  	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>  
> -	spin_lock_irq(&lruvec->lru_lock);
> +	lruvec_lock_irq(lruvec);
>  	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
>  	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
>  			nr_deactivate, nr_rotated, sc->priority, file);
> @@ -3832,9 +3832,9 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
>  		}
>  
>  		if (walk->batched) {
> -			spin_lock_irq(&lruvec->lru_lock);
> +			lruvec_lock_irq(lruvec);
>  			reset_batch_size(walk);
> -			spin_unlock_irq(&lruvec->lru_lock);
> +			lruvec_unlock_irq(lruvec);
>  		}
>  
>  		cond_resched();
> @@ -3993,7 +3993,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>  	if (seq < READ_ONCE(lrugen->max_seq))
>  		return false;
>  
> -	spin_lock_irq(&lruvec->lru_lock);
> +	lruvec_lock_irq(lruvec);
>  
>  	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
>  
> @@ -4008,7 +4008,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>  		if (inc_min_seq(lruvec, type, swappiness))
>  			continue;
>  
> -		spin_unlock_irq(&lruvec->lru_lock);
> +		lruvec_unlock_irq(lruvec);
>  		cond_resched();
>  		goto restart;
>  	}
> @@ -4043,7 +4043,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>  	/* make sure preceding modifications appear */
>  	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
>  unlock:
> -	spin_unlock_irq(&lruvec->lru_lock);
> +	lruvec_unlock_irq(lruvec);
>  
>  	return success;
>  }
> @@ -4739,7 +4739,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  
> -	spin_lock_irq(&lruvec->lru_lock);
> +	lruvec_lock_irq(lruvec);
>  
>  	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
>  
> @@ -4748,7 +4748,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
>  		scanned = 0;
>  
> -	spin_unlock_irq(&lruvec->lru_lock);
> +	lruvec_unlock_irq(lruvec);
>  
>  	if (list_empty(&list))
>  		return scanned;
> @@ -4786,9 +4786,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	walk = current->reclaim_state->mm_walk;
>  	if (walk && walk->batched) {
>  		walk->lruvec = lruvec;
> -		spin_lock_irq(&lruvec->lru_lock);
> +		lruvec_lock_irq(lruvec);
>  		reset_batch_size(walk);
> -		spin_unlock_irq(&lruvec->lru_lock);
> +		lruvec_unlock_irq(lruvec);
>  	}
>  
>  	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
> @@ -5226,7 +5226,7 @@ static void lru_gen_change_state(bool enabled)
>  		for_each_node(nid) {
>  			struct lruvec *lruvec = get_lruvec(memcg, nid);
>  
> -			spin_lock_irq(&lruvec->lru_lock);
> +			lruvec_lock_irq(lruvec);
>  
>  			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
>  			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
> @@ -5234,12 +5234,12 @@ static void lru_gen_change_state(bool enabled)
>  			lruvec->lrugen.enabled = enabled;
>  
>  			while (!(enabled ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
> -				spin_unlock_irq(&lruvec->lru_lock);
> +				lruvec_unlock_irq(lruvec);
>  				cond_resched();
> -				spin_lock_irq(&lruvec->lru_lock);
> +				lruvec_lock_irq(lruvec);
>  			}
>  
> -			spin_unlock_irq(&lruvec->lru_lock);
> +			lruvec_unlock_irq(lruvec);
>  		}
>  
>  		cond_resched();
> -- 
> 2.20.1
> 
> 


