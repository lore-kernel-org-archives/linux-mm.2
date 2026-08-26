Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61710C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 17:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0012B6B0088; Wed, 26 Aug 2026 13:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3996B008A; Wed, 26 Aug 2026 13:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBB76B008C; Wed, 26 Aug 2026 13:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3F426B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:35:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9410CA2D5B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:35:29 +0000 (UTC)
X-FDA: 85144122378.03.36CEB95
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64C7F16000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:35:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RGSh+8c/";
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787765727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WV70tfensh2wjze4y2gPAd84Sqt8gTf/UhwPuFp0xQ=;
	b=rewQBRBbqbHmvU+EKoQgzKNvTyMMNYAGvx2yPe/qNV93N6P0kE/PLyrewFYlBrZ+x7Ur4c
	Bq6arefT0CgHtdIyhbRFr5xd2Xo+wweeF8E56x26GMr3726ClNSfiQDEXX7ERfBgskhuwv
	+mKudyCNlAsZ7vlo2tGNcJEEhpiyiNY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RGSh+8c/";
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787765727;
	b=ohcwy8l0PIq0GpVcQWDESqJT1vQPqp2JaBVTnibAKiAD0Eyp782iP1B8gcUvQwRGN/kxrQ
	5jBs6uRy24GFobziA74lv64JDB5+fdnBb8NIa523VfKgnGzD9+9cIOBqLb4vLnxHSkF4OZ
	PwWmmK/bzZnmM89pKN6xwQ9euLvGj0Q=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1670dad7a8so207128466b.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787765726; x=1788370526; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8WV70tfensh2wjze4y2gPAd84Sqt8gTf/UhwPuFp0xQ=;
        b=RGSh+8c/TJzYIqKdx/+tQxSD8vo098699Crs4Wi/dbWjJv4zQlqf8YQUPDWOTgljEq
         L/mf/jZ834AdQdtHudCptdM0CG02iBZ5Y/50pphykrv21hk2sy9OfGI+yk2TAV3g+ySD
         PUmngXzg7A92g1YIGoR2Jk4KU09lMD+VV8rp+e8qejnY1qtjeU7HwDbAlItF5a1QTC6O
         O0KT20L/gzjW665Fu/gjv5698tnnjwt+u1ea0R7cRbg1+A/EpLLvXtiqLcsBXmkcFae3
         of5WHnwEAmSwnIxOXjG8xaOseUQ6Zjhta0dgSKZ+F6lVMELPj7UNU7EexBaOvNHV3O8V
         OdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787765726; x=1788370526;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8WV70tfensh2wjze4y2gPAd84Sqt8gTf/UhwPuFp0xQ=;
        b=jPi67ZODPZCefTqtmQcdlvgkrRxcPOX0a7BWHVYBZ9c5tWg57gI6ynH4nzYYFeWFwd
         o6eDV3EwL1lm3wO+EDhFrW5E4DlngelkSILFBGNzqS9nfJ1agybImlnm8GlhyBbu1mZy
         okkRIUBiborMx7WcJuRIS7bPQnXNvpflSOy+u1gbJNFuNQ2RxOuCtNR+wuE/ozksFXOg
         5DgD/U7UZg9KfROtcLtV0ZB2VW+/7KJwzhxnmEQHn6qc3cWAEzLZUSLyjxufu6tkb9Xp
         Lcqbp4m0gT4hHhpkc0i9b2eYE9YhE/nGgXjIJP936pr+6xk4YkcmA+jkhzG1aNPWHRZD
         kgXg==
X-Forwarded-Encrypted: i=1; AHgh+Ro0hmcQaN+TwYukcqF87IlAwSuPpE0KEhggSHaoJbzRUpML3cows8TnAp8LjedElWWkc0MrgELnrg==@kvack.org
X-Gm-Message-State: AFuF++mVwed3nt8dOSwMqy5vwNMx17BEk9Goj8XN+QYSfixjsnnkWcc/
	kwI/3Ov2RKPwKIcBVO+3peLht8PDGWfoMC9jmMvHdlwn5THP2FxH/v8o
X-Gm-Gg: AR+sD13EvSeg0hfisSsjxcJTnii5ShO1lFkaEK8OeLYIU6W7mpuaguGqmTW+TB9zwT5
	6PDJD3bc3fXgeMMX9BCJYioAQiOobafmjjn4t9aq/ZlSGKaTtymehJ5rsas2f5YoAZnzxr3oiov
	RiT/wwotc7Z55MscX7NCikB37elNvn6/6z/RmcGca/+XAahi0i0HJFp4F//CQe9D9qxJUESGW+E
	uVq95NaBntwY9Y5OmrXGZDuUS3hHEFqrohfyp0kjgJWt2YHF2LmWmLUpItopXR+kVwbr5NhxI2q
	+0AZ6abJMSbz67kHufieb2fyo7QqehFZj2EQ1p+wH4DvZboI21eTqw2q3G9Und+NmnRnZ8Fnizf
	7MQfA7eo1MIKgLjlj7KxKiQf7Z3IkceeW0dN1vRVd1mVCBYsTHfx97vOdcIquU0ozdcE676NYbF
	PrZXc2x8sb4gAZADMgerL0bFySNv0=
X-Received: by 2002:a17:907:80b:b0:c20:9447:bd6d with SMTP id a640c23a62f3a-c250c363b01mr1140061766b.11.1787765725171;
        Wed, 26 Aug 2026 10:35:25 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2534533a80sm111450566b.56.2026.08.26.10.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 10:35:24 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 26 Aug 2026 19:35:22 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: fix vmap_purge_lock livelock under memory
 pressure
Message-ID: <ao8j2kOMbCUv5g9i@milan>
References: <20260824095020.1225189-1-ye.liu@linux.dev>
 <aoxE7rw6gru13DB5@milan>
 <0c34aab2-9b73-45c0-8fbe-e33895bc8eef@linux.dev>
 <ao3Tf193sQpS22c-@milan>
 <3b7abe37-4f6b-4af8-a78c-49ff5edff298@arm.com>
 <ao6heKKQLSYMj4tX@milan>
 <db2d4453-2bd7-4548-a920-fdc12730dce0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db2d4453-2bd7-4548-a920-fdc12730dce0@linux.dev>
X-Stat-Signature: fczm7on4zyystbyrf8qar96rnfd6i4xc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 64C7F16000A
X-Rspam-User: 
X-HE-Tag: 1787765727-465174
X-HE-Meta: U2FsdGVkX193utzBGYKZNpAK72dFeFv/IZRMZvz0cw5KymKW7yn+puDnWs2vupGtgiOyNGDtwLZXF6XnPoAtUIPuhECv/UZ4ATb9hDFx/mYNO8sUbjNJ80lndmlmiyvdF14HiVQMysea3nevAmUJ9RjLjuu3HVwILhloJHejZnbtoEvbxW55flaYhKlZIWpkZ6jzcafbJoQYFlxWViVws5oJKmh5zLt78woKhpYgiXFRmFsR7r09SdD7YBO8ekzh/mz+uiI4PDMtqoNyBHIeveHRCh6Vb/vIkQotohCviD3Xxtq5iL7yqpGCVHEwzG9TUKGEepuDhWkC2o0ab+8GpHa2IuYa2Jj5yGlYtzJKbCMRh1kJvTBIhD5IdyseVTMB8ZMDS4x+VupLj9/p2D6DbdHT8zXArsFpa7mh9A51QBorniLfYe1MQUEjWJuUAz8CjiuxbwJA0L7SWwSYbS90YzVJJfSY3fdZLAKCVXUJRB7IVfS4XdIag5Qe1X4A7NVGphiC9p5jNj9lvlax2qPpHwI1yTbU09uHDm4Xh5ZozD+8XTRuNlifvUnc2rGnPsI/K5ilqdkafi+/ivm7mrz8PdGIX8UfN1VMnHm/YIVlgoRPwK//V3RrnEaSNzGsV1+4NETISOod18WS2auy08/gnm4Dn0hC8hFBzFDsF42Unw4XaNi+Bxb1bc3+cGQAWoUFKFMIB0umkRY50RF8RMk7I8lwHh3/3fUh29NXCWFN6ZDf8GrsHbGk+AqA8Di43e5vVDMbhLDk7ixeLLtoT5LUpgG3g/7E2I21ErUSjrZWSfCFjcHIi/WP5rpV64SkX97jDQzffEwXnu8tKIJ8elMo0Ym8liAtwAF0Tregf0391HPwRm7RBWGnED/Th1wPam8e5iiL5mdrQUlaaMjPRn1UtXmzYq2DRmE0yeshI/L6ytICFTe9/eTLPb557Y8u5MJEMCW6wRpVZZ/ZH9IjftB
 hSjIdr69
 tt5R8C1XHHWBqt/1nOBJNkVx0VPY+SAc6o75aB3G1uRtQQs06anv0am2KEfkhErnsByQZtLNDhIk+O9MwjH2+2w+p24qVDWaqepBLubTUaXgoqIFQDrIw+mLdzba7CTuASSobXmeO+pZ8yJzpNZld6HXZPDVu6N+0vcSEcTZ1FnGCKmUXAJnha8ywoqoAuWld8wCGbgNIRNopm5WGXl/MpKklN+wLiWOUmDeRLBYMgAsMQCOtbWnCmURsRRC/+5QCqFzSLWxgBKI7xpN4sOgIv9WZ65U8rh5DK+G6gZuhyJSQGoYD5759FlTEMwtrHR2kvF4eduNsq0AKFFVAUSzrGXeMhgthnc2/TzV48CS456faQeG96wYjilMF2cJXLBgmAbWS0Ks2Bjyo2QzZcqIZ6KhRKgmopAx4KZE5gHHCPJmKlP/f7bQ44qahg3zxdXD1ibPSUGYBCZiNzr+UbzdSiMl9SQDyd36mqO2GdXIkeYoFbCzlcMK/pRBqpORKwI3dC5NfFk7mu5eexVXjhup1d4cey0wi6Ja22/0i5DB73hc/Vwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 05:04:40PM +0800, Ye Liu wrote:
> 
> 
> 在 2026/8/26 16:19, Uladzislau Rezki 写道:
> > On Wed, Aug 26, 2026 at 11:09:21AM +0530, Dev Jain wrote:
> >>
> >>
> >> On 25/08/26 11:10 pm, Uladzislau Rezki wrote:
> >>> On Tue, Aug 25, 2026 at 09:04:24AM +0800, Ye Liu wrote:
> >>>>
> >>>>
> >>>> 在 2026/8/24 21:19, Uladzislau Rezki 写道:
> >>>>> On Mon, Aug 24, 2026 at 05:50:19PM +0800, Ye Liu wrote:
> >>>>>> From: Ye Liu <liuye@kylinos.cn>
> >>>>>>
> >>>>>> The vmap_purge_lock mutex can be held for an extended period by
> >>>>>> __purge_vmap_area_lazy() which calls flush_work() to wait for
> >>>>>> purge_vmap_node workers while holding the lock.  Under memory
> >>>>>> pressure, those workers may themselves be blocked in direct
> >>>>>> reclaim trying to acquire the same lock via the
> >>>>>> vmap_node_shrink_scan() shrinker callback, creating a circular
> >>>>>> dependency that deadlocks the entire system.
> >>>>>>
> >>>>>> Two changes:
> >>>>>>
> >>>>>> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
> >>>>>>    mutex_trylock().  This is a shrinker that only decays the vmap
> >>>>>>    pool and returns SHRINK_STOP without freeing memory; skipping a
> >>>>>>    decay cycle when the lock is contended is harmless and prevents
> >>>>>>    tasks from piling up on the mutex in the direct reclaim path.
> >>>>>>
> >>>>>> 2. __purge_vmap_area_lazy(): purge all vmap nodes inline instead of
> >>>>>>    scheduling purge_vmap_node via workqueue and calling flush_work()
> >>>>>>    while holding vmap_purge_lock.  The workqueue dispatch + flush
> >>>>>>    pattern under a mutex is the deadlock trigger: if no free worker
> >>>>>>    threads are available (all blocked on the same lock), flush_work()
> >>>>>>    never returns and the lock is held indefinitely.
> >>>>>>
> >>>>>> Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
> >>>>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> >>>>>> ---
> >>>>>>  mm/vmalloc.c | 51 +++++++++++++++++++++------------------------------
> >>>>>>  1 file changed, 21 insertions(+), 30 deletions(-)
> >>>>>>
> >>>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>>>>> index bea9f76ed7e7..41443708d22d 100644
> >>>>>> --- a/mm/vmalloc.c
> >>>>>> +++ b/mm/vmalloc.c
> >>>>>> @@ -2358,7 +2358,6 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
> >>>>>>  		bool full_pool_decay)
> >>>>>>  {
> >>>>>>  	unsigned long nr_purged_areas = 0;
> >>>>>> -	unsigned int nr_purge_helpers;
> >>>>>>  	static cpumask_t purge_nodes;
> >>>>>>  	unsigned int nr_purge_nodes;
> >>>>>>  	struct vmap_node *vn;
> >>>>>> @@ -2397,36 +2396,17 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
> >>>>>>  	if (nr_purge_nodes > 0) {
> >>>>>>  		flush_tlb_kernel_range(start, end);
> >>>>>>  
> >>>>>> -		/* One extra worker is per a lazy_max_pages() full set minus one. */
> >>>>>> -		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
> >>>>>> -		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
> >>>>>> -
> >>>>>> -		for_each_cpu(i, &purge_nodes) {
> >>>>>> -			vn = &vmap_nodes[i];
> >>>>>> -
> >>>>>> -			if (nr_purge_helpers > 0) {
> >>>>>> -				INIT_WORK(&vn->purge_work, purge_vmap_node);
> >>>>>> -
> >>>>>> -				if (cpumask_test_cpu(i, cpu_online_mask))
> >>>>>> -					schedule_work_on(i, &vn->purge_work);
> >>>>>> -				else
> >>>>>> -					schedule_work(&vn->purge_work);
> >>>>>> -
> >>>>>> -				nr_purge_helpers--;
> >>>>>> -			} else {
> >>>>>> -				vn->purge_work.func = NULL;
> >>>>>> -				purge_vmap_node(&vn->purge_work);
> >>>>>> -				nr_purged_areas += vn->nr_purged;
> >>>>>> -			}
> >>>>>> -		}
> >>>>>> -
> >>>>>> +		/*
> >>>>>> +		 * Purge all nodes inline.  Do not schedule_work() and
> >>>>>> +		 * flush_work() here: flush_work() while holding
> >>>>>> +		 * vmap_purge_lock can deadlock if the worker pool is
> >>>>>> +		 * starved (e.g. all workers blocked on this same lock
> >>>>>> +		 * in the direct reclaim path via vmap_node_shrink_scan).
> >>>>>> +		 */
> >>>>>>  		for_each_cpu(i, &purge_nodes) {
> >>>>>>  			vn = &vmap_nodes[i];
> >>>>>> -
> >>>>>> -			if (vn->purge_work.func) {
> >>>>>> -				flush_work(&vn->purge_work);
> >>>>>> -				nr_purged_areas += vn->nr_purged;
> >>>>>> -			}
> >>>>>> +			purge_vmap_node(&vn->purge_work);
> >>>>>> +			nr_purged_areas += vn->nr_purged;
> >>>>>>  		}
> >>>>>>  	}
> >>>>>>  
> >>>>>> @@ -5519,10 +5499,21 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> >>>>>>  {
> >>>>>>  	struct vmap_node *vn;
> >>>>>>  
> >>>>>> -	guard(mutex)(&vmap_purge_lock);
> >>>>>> +	/*
> >>>>>> +	 * This shrinker is invoked from direct reclaim path where memory
> >>>>>> +	 * pressure is already high.  Blocking on vmap_purge_lock here can
> >>>>>> +	 * cause a pile-up of tasks all waiting for the same mutex while
> >>>>>> +	 * the lock holder may itself be blocked in flush_work() waiting for
> >>>>>> +	 * a worker that is stuck in the same reclaim path.  Use trylock to
> >>>>>> +	 * avoid this; skipping a pool decay cycle is harmless.
> >>>>>> +	 */
> >>>>>> +	if (!mutex_trylock(&vmap_purge_lock))
> >>>>>> +		return SHRINK_STOP;
> >>>>>> +
> >>>>>>  	for_each_vmap_node(vn)
> >>>>>>  		decay_va_pool_node(vn, true);
> >>>>>>  
> >>>>>> +	mutex_unlock(&vmap_purge_lock);
> >>>>>>  	return SHRINK_STOP;
> >>>>>>  }
> >>>>>>  
> >>>>>> -- 
> >>>>>> 2.25.1
> >>>>>>
> >>>>> Have you seen any report about the problem you described?
> >>>>>
> >>>> Our testing team discovered the issue during testing with syzkaller 
> >>>> on kernel version 6.6.89. The relevant warnings are shown below.
> >>>>
> >>>> INFO: task kworker/u80:6:141 blocked for more than 143 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:kworker/u80:6 state:D stack:0 pid:141 tgid:141 ppid:2 flags:0x00004000
> >>>> Workqueue: events_unbound call_usermodehelper_exec_work
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> __alloc_pages_node_noprof root/klinux/./include/linux/gfp.h:244 [inline]
> >>>> alloc_pages_node_noprof root/klinux/./include/linux/gfp.h:271 [inline]
> >>>> alloc_thread_stack_node root/klinux/kernel/fork.c:367 [inline]
> >>>> dup_task_struct+0xa4/0x6c0 root/klinux/kernel/fork.c:1161
> >>>> copy_process+0x4eb/0x57d0 root/klinux/kernel/fork.c:2261
> >>>> kernel_clone+0xdd/0x910 root/klinux/kernel/fork.c:2849
> >>>> user_mode_thread+0xcb/0x110 root/klinux/kernel/fork.c:2927
> >>>> call_usermodehelper_exec_sync root/klinux/kernel/umh.c:133 [inline]
> >>>> call_usermodehelper_exec_work+0x69/0x170 root/klinux/kernel/umh.c:164
> >>>> process_one_work+0x90d/0x1aa0 root/klinux/kernel/workqueue.c:3235
> >>>> process_scheduled_works root/klinux/kernel/workqueue.c:3315 [inline]
> >>>> worker_thread+0x633/0xe80 root/klinux/kernel/workqueue.c:3396
> >>>> kthread+0x317/0x420 root/klinux/kernel/kthread.c:388
> >>>> ret_from_fork+0x4ae/0x5e0 root/klinux/arch/x86/kernel/process.c:152
> >>>> ret_from_fork_asm+0x1a/0x30 root/klinux/arch/x86/entry/entry_64.S:293
> >>>>
> >>>> INFO: task syz-executor.0:37820 blocked for more than 143 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:syz-executor.0 state:D stack:0 pid:37820 tgid:37820 ppid:1 flags:0x00000004
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> alloc_pages_mpol_noprof+0x1ee/0x530 root/klinux/mm/mempolicy.c:2270
> >>>> pagetable_alloc_noprof root/klinux/./include/linux/mm.h:2982 [inline]
> >>>> __pud_alloc_one_noprof root/klinux/./include/asm-generic/pgalloc.h:174 [inline]
> >>>> pud_alloc_one_noprof root/klinux/./include/asm-generic/pgalloc.h:195 [inline]
> >>>> __pud_alloc+0x40/0x650 root/klinux/mm/memory.c:6222
> >>>> pud_alloc root/klinux/./include/linux/mm.h:2939 [inline]
> >>>> copy_pud_range root/klinux/mm/memory.c:1270 [inline]
> >>>> copy_p4d_range+0x95e/0xb70 root/klinux/mm/memory.c:1314
> >>>> copy_page_range+0x432/0xa30 root/klinux/mm/memory.c:1408
> >>>> dup_mmap+0x1127/0x1ef0 root/klinux/kernel/fork.c:773
> >>>> dup_mm+0x93/0x4e0 root/klinux/kernel/fork.c:1722
> >>>> copy_mm root/klinux/kernel/fork.c:1781 [inline]
> >>>> copy_process+0x2c89/0x57d0 root/klinux/kernel/fork.c:2436
> >>>> kernel_clone+0xdd/0x910 root/klinux/kernel/fork.c:2849
> >>>> __do_sys_clone+0xcf/0x120 root/klinux/kernel/fork.c:2992
> >>>> do_syscall_x64 root/klinux/arch/x86/entry/common.c:51 [inline]
> >>>> do_syscall_64+0x74/0x360 root/klinux/arch/x86/entry/common.c:81
> >>>> entry_SYSCALL_64_after_hwframe+0x76/0xe0
> >>>> RIP: 0033:0x45d778
> >>>> RSP: 002b:00007ffc4d846860 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
> >>>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000045d778
> >>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
> >>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000013782980
> >>>> R10: 0000000013782c50 R11: 0000000000000246 R12: 0000000000000000
> >>>> R13: 0000000000000032 R14: 0000000000000000 R15: 0000000000000000
> >>>>
> >>>> INFO: task syz-executor.10:56553 blocked for more than 143 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:syz-executor.10 state:D stack:0 pid:56553 tgid:56553 ppid:1 flags:0x00000004
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> __alloc_pages_node_noprof root/klinux/./include/linux/gfp.h:244 [inline]
> >>>> alloc_pages_node_noprof root/klinux/./include/linux/gfp.h:271 [inline]
> >>>> alloc_thread_stack_node root/klinux/kernel/fork.c:367 [inline]
> >>>> dup_task_struct+0xa4/0x6c0 root/klinux/kernel/fork.c:1161
> >>>> copy_process+0x4eb/0x57d0 root/klinux/kernel/fork.c:2261
> >>>> kernel_clone+0xdd/0x910 root/klinux/kernel/fork.c:2849
> >>>> __do_sys_clone+0xcf/0x120 root/klinux/kernel/fork.c:2992
> >>>> do_syscall_x64 root/klinux/arch/x86/entry/common.c:51 [inline]
> >>>> do_syscall_64+0x74/0x360 root/klinux/arch/x86/entry/common.c:81
> >>>> entry_SYSCALL_64_after_hwframe+0x76/0xe0
> >>>> RIP: 0033:0x45d778
> >>>> RSP: 002b:00007ffc6a4dad70 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
> >>>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000045d778
> >>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
> >>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 000000002d906980
> >>>> R10: 000000002d906c50 R11: 0000000000000246 R12: 0000000000000000
> >>>> R13: 0000000000000032 R14: 0000000000000001 R15: 0000000000000000
> >>>>
> >>>> INFO: task kworker/12:13:56977 blocked for more than 144 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:kworker/12:13 state:D stack:0 pid:56977 tgid:56977 ppid:2 flags:0x00004000
> >>>> Workqueue: events drain_vmap_area_work
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_timeout+0x268/0x2b0 root/klinux/kernel/time/timer.c:2142
> >>>> do_wait_for_common root/klinux/kernel/sched/completion.c:95 [inline]
> >>>> __wait_for_common+0x3ea/0x600 root/klinux/kernel/sched/completion.c:116
> >>>> __flush_work+0xf4/0x180 root/klinux/kernel/workqueue.c:4125
> >>>> __purge_vmap_area_lazy+0x8e5/0xcf0 root/klinux/mm/vmalloc.c:2324
> >>>> drain_vmap_area_work+0x2c/0x40 root/klinux/mm/vmalloc.c:2349
> >>>> process_one_work+0x90d/0x1aa0 root/klinux/kernel/workqueue.c:3235
> >>>> process_scheduled_works root/klinux/kernel/workqueue.c:3315 [inline]
> >>>> worker_thread+0x633/0xe80 root/klinux/kernel/workqueue.c:3396
> >>>> kthread+0x317/0x420 root/klinux/kernel/kthread.c:388
> >>>> ret_from_fork+0x4ae/0x5e0 root/klinux/arch/x86/kernel/process.c:152
> >>>> ret_from_fork_asm+0x1a/0x30 root/klinux/arch/x86/entry/entry_64.S:293
> >>>>
> >>>> INFO: task kdamond.0:66163 blocked for more than 144 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:kdamond.0 state:D stack:0 pid:66163 tgid:66163 ppid:2 flags:0x00004000
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> alloc_pages_mpol_noprof+0x1ee/0x530 root/klinux/mm/mempolicy.c:2270
> >>>> alloc_slab_page root/klinux/mm/slub.c:2315 [inline]
> >>>> allocate_slab+0x27a/0x3f0 root/klinux/mm/slub.c:2485
> >>>> ___slab_alloc+0x889/0x1060 root/klinux/mm/slub.c:3727
> >>>> __slab_alloc.constprop.0+0x52/0xa0 root/klinux/mm/slub.c:3817
> >>>> __slab_alloc_node root/klinux/mm/slub.c:3870 [inline]
> >>>> slab_alloc_node root/klinux/mm/slub.c:4031 [inline]
> >>>> kmem_cache_alloc_noprof+0x385/0x3e0 root/klinux/mm/slub.c:4050
> >>>> damon_new_region+0x29/0x1a0 root/klinux/mm/damon/core.c:124
> >>>> damon_va_evenly_split_region+0x1f8/0x2c0 root/klinux/mm/damon/vaddr.c:85
> >>>> __damon_va_init_regions root/klinux/mm/damon/vaddr.c:271 [inline]
> >>>> damon_va_init+0x2b5/0x470 root/klinux/mm/damon/vaddr.c:283
> >>>> kdamond_fn+0x289/0x1240 root/klinux/mm/damon/core.c:1432
> >>>> kthread+0x317/0x420 root/klinux/kernel/kthread.c:388
> >>>> ret_from_fork+0x4ae/0x5e0 root/klinux/arch/x86/kernel/process.c:152
> >>>> ret_from_fork_asm+0x1a/0x30 root/klinux/arch/x86/entry/entry_64.S:293
> >>>>
> >>>> INFO: task kworker/u80:5:67724 blocked for more than 144 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:kworker/u80:5 state:D stack:0 pid:67724 tgid:67724 ppid:2 flags:0x00004000
> >>>> Workqueue: events_unbound call_usermodehelper_exec_work
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> __alloc_pages_node_noprof root/klinux/./include/linux/gfp.h:244 [inline]
> >>>> alloc_pages_node_noprof root/klinux/./include/linux/gfp.h:271 [inline]
> >>>> alloc_thread_stack_node root/klinux/kernel/fork.c:367 [inline]
> >>>> dup_task_struct+0xa4/0x6c0 root/klinux/kernel/fork.c:1161
> >>>> copy_process+0x4eb/0x57d0 root/klinux/kernel/fork.c:2261
> >>>> kernel_clone+0xdd/0x910 root/klinux/kernel/fork.c:2849
> >>>> user_mode_thread+0xcb/0x110 root/klinux/kernel/fork.c:2927
> >>>> call_usermodehelper_exec_sync root/klinux/kernel/umh.c:133 [inline]
> >>>> call_usermodehelper_exec_work+0x69/0x170 root/klinux/kernel/umh.c:164
> >>>> process_one_work+0x90d/0x1aa0 root/klinux/kernel/workqueue.c:3235
> >>>> process_scheduled_works root/klinux/kernel/workqueue.c:3315 [inline]
> >>>> worker_thread+0x633/0xe80 root/klinux/kernel/workqueue.c:3396
> >>>> kthread+0x317/0x420 root/klinux/kernel/kthread.c:388
> >>>> ret_from_fork+0x4ae/0x5e0 root/klinux/arch/x86/kernel/process.c:152
> >>>> ret_from_fork_asm+0x1a/0x30 root/klinux/arch/x86/entry/entry_64.S:293
> >>>>
> >>>> INFO: task kworker/u80:9:69412 blocked for more than 144 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:kworker/u80:9 state:D stack:0 pid:69412 tgid:69412 ppid:2 flags:0x00004000
> >>>> Workqueue: events_unbound call_usermodehelper_exec_work
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> __alloc_pages_node_noprof root/klinux/./include/linux/gfp.h:244 [inline]
> >>>> alloc_pages_node_noprof root/klinux/./include/linux/gfp.h:271 [inline]
> >>>> alloc_thread_stack_node root/klinux/kernel/fork.c:367 [inline]
> >>>> dup_task_struct+0xa4/0x6c0 root/klinux/kernel/fork.c:1161
> >>>> copy_process+0x4eb/0x57d0 root/klinux/kernel/fork.c:2261
> >>>> kernel_clone+0xdd/0x910 root/klinux/kernel/fork.c:2849
> >>>> user_mode_thread+0xcb/0x110 root/klinux/kernel/fork.c:2927
> >>>> call_usermodehelper_exec_sync root/klinux/kernel/umh.c:133 [inline]
> >>>> call_usermodehelper_exec_work+0x69/0x170 root/klinux/kernel/umh.c:164
> >>>> process_one_work+0x90d/0x1aa0 root/klinux/kernel/workqueue.c:3235
> >>>> process_scheduled_works root/klinux/kernel/workqueue.c:3315 [inline]
> >>>> worker_thread+0x633/0xe80 root/klinux/kernel/workqueue.c:3396
> >>>> kthread+0x317/0x420 root/klinux/kernel/kthread.c:388
> >>>> ret_from_fork+0x4ae/0x5e0 root/klinux/arch/x86/kernel/process.c:152
> >>>> ret_from_fork_asm+0x1a/0x30 root/klinux/arch/x86/entry/entry_64.S:293
> >>>>
> >>>> INFO: task syz-executor.18:73039 blocked for more than 144 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:syz-executor.18 state:D stack:0 pid:73039 tgid:73039 ppid:1 flags:0x00004004
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> alloc_pages_mpol_noprof+0x1ee/0x530 root/klinux/mm/mempolicy.c:2270
> >>>> folio_alloc_mpol_noprof+0x3b/0xd0 root/klinux/mm/mempolicy.c:2288
> >>>> vma_alloc_folio_noprof+0xaf/0x140 root/klinux/mm/mempolicy.c:2316
> >>>> folio_prealloc root/klinux/mm/memory.c:1062 [inline]
> >>>> wp_page_copy+0x21a/0x11c0 root/klinux/mm/memory.c:3308
> >>>> do_wp_page+0x762/0x14e0 root/klinux/mm/memory.c:3700
> >>>> handle_pte_fault+0x573/0x730 root/klinux/mm/memory.c:5717
> >>>> __handle_mm_fault+0xae4/0x10d0 root/klinux/mm/memory.c:5844
> >>>> handle_mm_fault+0x376/0x650 root/klinux/mm/memory.c:6009
> >>>> do_user_addr_fault+0x2be/0xc40 root/klinux/arch/x86/mm/fault.c:1330
> >>>> handle_page_fault root/klinux/arch/x86/mm/fault.c:1471 [inline]
> >>>> exc_page_fault+0x5c/0xe0 root/klinux/arch/x86/mm/fault.c:1527
> >>>> asm_exc_page_fault+0x26/0x30 root/klinux/./arch/x86/include/asm/idtentry.h:608
> >>>> RIP: 0033:0x45d8e1
> >>>> RSP: 002b:00007ffd015d5e10 EFLAGS: 00010246
> >>>> RAX: 000000000000003b RBX: 0000000000000000 RCX: 000000000045d778
> >>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> >>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000701d980
> >>>> R10: 000000000701dc50 R11: 0000000000000246 R12: 000000000000003b
> >>>> R13: 0000000000000032 R14: 0000000000000000 R15: 0000000000000000
> >>>>
> >>>> INFO: task syz-executor.13:74790 blocked for more than 144 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:syz-executor.13 state:D stack:0 pid:74790 tgid:74790 ppid:1 flags:0x00000004
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> alloc_pages_mpol_noprof+0x1ee/0x530 root/klinux/mm/mempolicy.c:2270
> >>>> folio_alloc_mpol_noprof+0x3b/0xd0 root/klinux/mm/mempolicy.c:2288
> >>>> vma_alloc_folio_noprof+0xaf/0x140 root/klinux/mm/mempolicy.c:2316
> >>>> folio_prealloc root/klinux/mm/memory.c:1062 [inline]
> >>>> wp_page_copy+0x21a/0x11c0 root/klinux/mm/memory.c:3308
> >>>> do_wp_page+0x762/0x14e0 root/klinux/mm/memory.c:3700
> >>>> handle_pte_fault+0x573/0x730 root/klinux/mm/memory.c:5717
> >>>> __handle_mm_fault+0xae4/0x10d0 root/klinux/mm/memory.c:5844
> >>>> handle_mm_fault+0x376/0x650 root/klinux/mm/memory.c:6009
> >>>> do_user_addr_fault+0x2be/0xc40 root/klinux/arch/x86/mm/fault.c:1330
> >>>> handle_page_fault root/klinux/arch/x86/mm/fault.c:1471 [inline]
> >>>> exc_page_fault+0x5c/0xe0 root/klinux/arch/x86/mm/fault.c:1527
> >>>> asm_exc_page_fault+0x26/0x30 root/klinux/./arch/x86/include/asm/idtentry.h:608
> >>>> RIP: 0033:0x45d8e1
> >>>> RSP: 002b:00007ffe18ac7000 EFLAGS: 00010246
> >>>> RAX: 0000000000000038 RBX: 0000000000000000 RCX: 000000000045d778
> >>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> >>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000eb5f980
> >>>> R10: 000000000eb5fc50 R11: 0000000000000246 R12: 0000000000000038
> >>>> R13: 0000000000000032 R14: 0000000000000001 R15: 0000000000000000
> >>>>
> >>>> INFO: task syz-executor.5:78550 blocked for more than 144 seconds.
> >>>> Tainted: G S ------- ---- 6.6.89+ #931
> >>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >>>> task:syz-executor.5 state:D stack:0 pid:78550 tgid:78550 ppid:1 flags:0x00000004
> >>>> Call Trace:
> >>>>
> >>>> context_switch root/klinux/kernel/sched/core.c:5346 [inline]
> >>>> __schedule+0x7bc/0x1310 root/klinux/kernel/sched/core.c:6720
> >>>> __schedule_loop root/klinux/kernel/sched/core.c:6797 [inline]
> >>>> schedule+0xe2/0x290 root/klinux/kernel/sched/core.c:6812
> >>>> schedule_preempt_disabled+0x18/0x30 root/klinux/kernel/sched/core.c:6869
> >>>> __mutex_lock_common root/klinux/kernel/locking/mutex.c:679 [inline]
> >>>> __mutex_lock+0x914/0x13a0 root/klinux/kernel/locking/mutex.c:747
> >>>> class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> do_shrink_slab+0x3c9/0xf30 root/klinux/mm/shrinker.c:435
> >>>> shrink_slab+0x175/0x5e0 root/klinux/mm/shrinker.c:662
> >>>> shrink_node_memcgs+0x4d6/0x700 root/klinux/mm/vmscan.c:5900
> >>>> shrink_node+0x247/0x12c0 root/klinux/mm/vmscan.c:5933
> >>>> shrink_zones root/klinux/mm/vmscan.c:6175 [inline]
> >>>> do_try_to_free_pages+0x314/0x1580 root/klinux/mm/vmscan.c:6237
> >>>> try_to_free_pages+0x293/0x740 root/klinux/mm/vmscan.c:6472
> >>>> __perform_reclaim root/klinux/mm/page_alloc.c:3965 [inline]
> >>>> __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> __alloc_pages_slowpath.constprop.0+0x800/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> __alloc_pages_noprof+0x490/0x570 root/klinux/mm/page_alloc.c:4792
> >>>> alloc_pages_mpol_noprof+0x1ee/0x530 root/klinux/mm/mempolicy.c:2270
> >>>> folio_alloc_mpol_noprof+0x3b/0xd0 root/klinux/mm/mempolicy.c:2288
> >>>> vma_alloc_folio_noprof+0xaf/0x140 root/klinux/mm/mempolicy.c:2316
> >>>> folio_prealloc root/klinux/mm/memory.c:1062 [inline]
> >>>> wp_page_copy+0x21a/0x11c0 root/klinux/mm/memory.c:3308
> >>>> do_wp_page+0x762/0x14e0 root/klinux/mm/memory.c:3700
> >>>> handle_pte_fault+0x573/0x730 root/klinux/mm/memory.c:5717
> >>>> __handle_mm_fault+0xae4/0x10d0 root/klinux/mm/memory.c:5844
> >>>> handle_mm_fault+0x376/0x650 root/klinux/mm/memory.c:6009
> >>>> do_user_addr_fault+0x2be/0xc40 root/klinux/arch/x86/mm/fault.c:1330
> >>>> handle_page_fault root/klinux/arch/x86/mm/fault.c:1471 [inline]
> >>>> exc_page_fault+0x5c/0xe0 root/klinux/arch/x86/mm/fault.c:1527
> >>>> asm_exc_page_fault+0x26/0x30 root/klinux/./arch/x86/include/asm/idtentry.h:608
> >>>> RIP: 0033:0x45d8e1
> >>>> RSP: 002b:00007fff9b912230 EFLAGS: 00010246
> >>>> RAX: 0000000000000019 RBX: 0000000000000000 RCX: 000000000045d778
> >>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> >>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000cd3c980
> >>>> R10: 000000000cd3cc50 R11: 0000000000000246 R12: 0000000000000019
> >>>> R13: 0000000000000032 R14: 0000000000000001 R15: 0000000000000000
> >>>>
> >>>> Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
> >>>>
> >>>> Showing all locks held in the system:
> >>>> 2 locks held by kthreadd/2:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 4 locks held by kworker/u80:6/141:
> >>>> #0: ffff8881041a4d58 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x803/0x1aa0 root/klinux/kernel/workqueue.c:3210
> >>>> #1: ffff8881053cfd80 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_one_work+0x859/0x1aa0 root/klinux/kernel/workqueue.c:3211
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 1 lock held by khungtaskd/155:
> >>>> #0: ffffffff8b33eb00 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire root/klinux/./include/linux/rcupdate.h:334 [inline]
> >>>> #0: ffffffff8b33eb00 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock root/klinux/./include/linux/rcupdate.h:786 [inline]
> >>>> #0: ffffffff8b33eb00 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x75/0x340 root/klinux/kernel/locking/lockdep.c:6721
> >>>> 2 locks held by bash/957:
> >>>> #0: ffff88800310d0a8 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x29/0x80 root/klinux/drivers/tty/tty_ldisc.c:243
> >>>> #1: ffffc900039852f8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd55/0x1230 root/klinux/drivers/tty/n_tty.c:2217
> >>>> 5 locks held by syz-executor.0/37820:
> >>>> #0: ffffffff8b511780 (dup_mmap_sem){++++}-{0:0}, at: dup_mmap+0xbe/0x1ef0 root/klinux/kernel/fork.c:668
> >>>> #1: ffff888106b396e8 (&mm->mmap_lock){++++}-{3:3}, at: mmap_write_lock_killable root/klinux/./include/linux/mmap_lock.h:124 [inline]
> >>>> #1: ffff888106b396e8 (&mm->mmap_lock){++++}-{3:3}, at: dup_mmap+0xdc/0x1ef0 root/klinux/kernel/fork.c:669
> >>>> #2: ffff88801ff62be8 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested root/klinux/./include/linux/mmap_lock.h:115 [inline]
> >>>> #2: ffff88801ff62be8 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap+0x125/0x1ef0 root/klinux/kernel/fork.c:678
> >>>> #3: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #3: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #3: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #4: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #4: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 2 locks held by bash/41651:
> >>>> #0: ffff88801f8cb8a8 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x29/0x80 root/klinux/drivers/tty/tty_ldisc.c:243
> >>>> #1: ffffc900001fd2f8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xd55/0x1230 root/klinux/drivers/tty/n_tty.c:2217
> >>>> 2 locks held by syz-executor.10/56553:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by kworker/12:13/56977:
> >>>> #0: ffff88810419cb58 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x803/0x1aa0 root/klinux/kernel/workqueue.c:3210
> >>>> #1: ffff88804264fd80 (drain_vmap_work){+.+.}-{0:0}, at: process_one_work+0x859/0x1aa0 root/klinux/kernel/workqueue.c:3211
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: drain_vmap_area_work+0x1c/0x40 root/klinux/mm/vmalloc.c:2348
> >>>> 2 locks held by kdamond.0/66163:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 4 locks held by kworker/u80:5/67724:
> >>>> #0: ffff8881041a4d58 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x803/0x1aa0 root/klinux/kernel/workqueue.c:3210
> >>>> #1: ffff88804664fd80 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_one_work+0x859/0x1aa0 root/klinux/kernel/workqueue.c:3211
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 4 locks held by kworker/u80:9/69412:
> >>>> #0: ffff8881041a4d58 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x803/0x1aa0 root/klinux/kernel/workqueue.c:3210
> >>>> #1: ffff8880346afd80 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_one_work+0x859/0x1aa0 root/klinux/kernel/workqueue.c:3211
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.18/73039:
> >>>> #0: ffff888048652940 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff888048652940 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.13/74790:
> >>>> #0: ffff88803e37eeb8 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff88803e37eeb8 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.5/78550:
> >>>> #0: ffff88801f4310e8 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff88801f4310e8 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.26/80991:
> >>>> #0: ffff88801b3c6068 (&mm->mmap_lock){++++}-{3:3}, at: mmap_read_lock root/klinux/./include/linux/mmap_lock.h:146 [inline]
> >>>> #0: ffff88801b3c6068 (&mm->mmap_lock){++++}-{3:3}, at: __mm_populate+0x220/0x360 root/klinux/mm/gup.c:2170
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 4 locks held by syz-executor.5/80992:
> >>>> #0: ffff888104871430 (sb_writers#2){.+.+}-{0:0}, at: get_signal+0x18d9/0x1a60 root/klinux/kernel/signal.c:2915
> >>>> #1: ffff888001a29818 (&sb->s_type->i_mutex_key){++++}-{3:3}, at: inode_lock root/klinux/./include/linux/fs.h:828 [inline]
> >>>> #1: ffff888001a29818 (&sb->s_type->i_mutex_key){++++}-{3:3}, at: generic_file_write_iter+0x91/0x2f0 root/klinux/mm/filemap.c:4181
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 2 locks held by syz-executor.22/81067:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 2 locks held by syz-executor.31/81012:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 2 locks held by syz-executor.31/81059:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.23/81024:
> >>>> #0: ffff88804a3aa080 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff88804a3aa080 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 2 locks held by syz-executor.23/81030:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.27/81031:
> >>>> #0: ffff88802008cb70 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff88802008cb70 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 2 locks held by syz-executor.30/81070:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 4 locks held by syz-executor.28/81036:
> >>>> #0: ffff888104871430 (sb_writers#2){.+.+}-{0:0}, at: filename_create+0xf9/0x4c0 root/klinux/fs/namei.c:3928
> >>>> #1: ffff88817b041270 (&sb->s_type->i_mutex_key/1){+.+.}-{3:3}, at: inode_lock_nested root/klinux/./include/linux/fs.h:863 [inline]
> >>>> #1: ffff88817b041270 (&sb->s_type->i_mutex_key/1){+.+.}-{3:3}, at: filename_create+0x1a1/0x4c0 root/klinux/fs/namei.c:3935
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.12/81086:
> >>>> #0: ffff88801f2a45f8 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff88801f2a45f8 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 4 locks held by syz-executor.22/81082:
> >>>> #0: ffff888104871430 (sb_writers#2){.+.+}-{0:0}, at: get_signal+0x18d9/0x1a60 root/klinux/kernel/signal.c:2915
> >>>> #1: ffff88805c122910 (&sb->s_type->i_mutex_key){++++}-{3:3}, at: inode_lock root/klinux/./include/linux/fs.h:828 [inline]
> >>>> #1: ffff88805c122910 (&sb->s_type->i_mutex_key){++++}-{3:3}, at: generic_file_write_iter+0x91/0x2f0 root/klinux/mm/filemap.c:4181
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #2: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #3: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.17/81084:
> >>>> #0: ffff888084e01430 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff888084e01430 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.21/81088:
> >>>> #0: ffff88801cde23c8 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff88801cde23c8 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.5/81089:
> >>>> #0: ffff888004d1abe8 (&mm->mmap_lock){++++}-{3:3}, at: mmap_read_trylock root/klinux/./include/linux/mmap_lock.h:165 [inline]
> >>>> #0: ffff888004d1abe8 (&mm->mmap_lock){++++}-{3:3}, at: get_mmap_lock_carefully root/klinux/mm/memory.c:6036 [inline]
> >>>> #0: ffff888004d1abe8 (&mm->mmap_lock){++++}-{3:3}, at: lock_mm_and_find_vma+0x35/0x5c0 root/klinux/mm/memory.c:6096
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.13/81090:
> >>>> #0: ffff888004d1f568 (&mm->mmap_lock){++++}-{3:3}, at: mmap_read_trylock root/klinux/./include/linux/mmap_lock.h:165 [inline]
> >>>> #0: ffff888004d1f568 (&mm->mmap_lock){++++}-{3:3}, at: get_mmap_lock_carefully root/klinux/mm/memory.c:6036 [inline]
> >>>> #0: ffff888004d1f568 (&mm->mmap_lock){++++}-{3:3}, at: lock_mm_and_find_vma+0x35/0x5c0 root/klinux/mm/memory.c:6096
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.18/81091:
> >>>> #0: ffff888004d1d5e8 (&mm->mmap_lock){++++}-{3:3}, at: mmap_read_trylock root/klinux/./include/linux/mmap_lock.h:165 [inline]
> >>>> #0: ffff888004d1d5e8 (&mm->mmap_lock){++++}-{3:3}, at: get_mmap_lock_carefully root/klinux/mm/memory.c:6036 [inline]
> >>>> #0: ffff888004d1d5e8 (&mm->mmap_lock){++++}-{3:3}, at: lock_mm_and_find_vma+0x35/0x5c0 root/klinux/mm/memory.c:6096
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 2 locks held by syz-executor.7/81096:
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #0: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #1: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>> 3 locks held by syz-executor.16/81095:
> >>>> #0: ffff88801de15e08 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read root/klinux/./include/linux/mm.h:694 [inline]
> >>>> #0: ffff88801de15e08 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x1c7/0x6f0 root/klinux/mm/memory.c:6165
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim root/klinux/mm/page_alloc.c:3962 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim root/klinux/mm/page_alloc.c:3987 [inline]
> >>>> #1: ffffffff8b56b4c0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x74d/0x1fb0 root/klinux/mm/page_alloc.c:4394
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: class_mutex_constructor root/klinux/./include/linux/mutex.h:200 [inline]
> >>>> #2: ffffffff8b567390 (vmap_purge_lock){+.+.}-{3:3}, at: vmap_node_shrink_scan+0x1d/0x90 root/klinux/mm/vmalloc.c:5108
> >>>>
> >>>> =============================================
> >>>>
> >>>>
> >>>>> --
> >>>>> Uladzislau Rezki
> >>>>
> >>>> -- 
> >>>> Thanks,
> >>>> Ye Liu
> >>>>
> >>> Thank you!
> >>>
> >>> I can trigger below:
> >>>
> >>> <snip>
> >>> Aug 25 13:56:52 pc638 kernel: Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
> >>> Aug 25 13:56:52 pc638 kernel:
> >>>                               Showing all locks held in the system:
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by khungtaskd/488:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3306840 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x47/0x19b
> >>> Aug 25 13:56:52 pc638 kernel: 3 locks held by kworker/52:1/694:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffff8ac4401a4140 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x57b/0x600
> >>> Aug 25 13:56:52 pc638 kernel:  #1: ffffce26435ffe30 (drain_vmap_work){+.+.}-{0:0}, at: process_one_work+0x1fc/0x600
> >>> Aug 25 13:56:52 pc638 kernel:  #2: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: drain_vmap_area_work+0x1b/0x40
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by in:imklog/3831:
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/2/5009:
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/4/5011:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: alloc_vmap_area+0x8a8/0xd20
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/5/5012:
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/8/5015:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: alloc_vmap_area+0x8a8/0xd20
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/30/5037:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: alloc_vmap_area+0x8a8/0xd20
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/31/5038:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: alloc_vmap_area+0x8a8/0xd20
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/38/5045:
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/39/5046:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: alloc_vmap_area+0x8a8/0xd20
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/41/5048:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: alloc_vmap_area+0x8a8/0xd20
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/49/5056:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: alloc_vmap_area+0x8a8/0xd20
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/51/5058:
> >>> Aug 25 13:56:52 pc638 kernel:  #0: ffffffffa3406300 (vmap_purge_lock){+.+.}-{4:4}, at: alloc_vmap_area+0x8a8/0xd20
> >>> Aug 25 13:56:52 pc638 kernel: 1 lock held by vmalloc_test/57/5064:
> >>> ...
> >>> <snip>
> >>>
> >>> I think this is with your patch. But i can check also without.
> >>> One potential issue to inline vnode-drain - is a time. At least
> >>> we need to inject cond_resched() after each vnode flush +
> >>>
> >>> /*
> >>>  * Reclaim vmap areas by purging fragmented blocks and purge_vmap_area_list.
> >>>  */
> >>> static void reclaim_and_purge_vmap_areas(void)
> >>>
> >>> {
> >>> 	mutex_lock(&vmap_purge_lock);
> >>> 	purge_fragmented_blocks_allcpus();
> >>> 	__purge_vmap_area_lazy(ULONG_MAX, 0, true);
> >>> 	mutex_unlock(&vmap_purge_lock);
> >>> }
> >>>
> >>> here use try-lock as well due to potentially increased flush time.
> >>>
> >>> Any thoughts?
> >>>
> >>> --
> >>> Uladzislau Rezki
> >>
> >>
> >> IIUC we won't have to do inline purge if we switch both places to use mutex_trylock?
> >>
> > Looks like that. One concern about inline is a CPU hogging by one thread
> > due to slow progress.
> > 
> 
> So, should we fix it using the method below?
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c                                                         
> index bea9f76ed7e7..e5c68b795a3e 100644                                                          
> --- a/mm/vmalloc.c                                                                               
> +++ b/mm/vmalloc.c                                                                               
> @@ -2440,7 +2440,8 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end, 
>  static void reclaim_and_purge_vmap_areas(void)                                                  
>                                                                                                  
>  {                                                                                               
> -       mutex_lock(&vmap_purge_lock);                                                            
> +       if (!mutex_trylock(&vmap_purge_lock))                                                    
> +               return;                                                                          
>         purge_fragmented_blocks_allcpus();                                                       
>         __purge_vmap_area_lazy(ULONG_MAX, 0, true);                                              
>         mutex_unlock(&vmap_purge_lock);                                                          
> @@ -5519,10 +5520,20 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {                                                                                               
>         struct vmap_node *vn;                                                                    
>                                                                                                  
> -       guard(mutex)(&vmap_purge_lock);                                                          
> +       /*                                                                                       
> +        * This shrinker is invoked from direct reclaim where memory                             
> +        * pressure is already high.  Blocking on vmap_purge_lock here                           
> +        * can deadlock the system: the lock holder may be blocked in                            
> +        * flush_work() waiting for a worker that is stuck in this same                          
> +        * reclaim path trying to acquire the same lock.  Use trylock                            
> +        * to avoid this; skipping a pool decay cycle is harmless.                               
> +        */                                                                                      
> +       if (!mutex_trylock(&vmap_purge_lock))                                                    
> +               return SHRINK_STOP;                                                              
>         for_each_vmap_node(vn)                                                                   
>                 decay_va_pool_node(vn, true);                                                    
>                                                                                                  
> +       mutex_unlock(&vmap_purge_lock);                                                          
>         return SHRINK_STOP;                                                                      
>  }                                                                                               
> 
Yes, i think so. It would be good if you could test it with your
workload which triggers reported kernel splat.

--
Uladzislau Rezki

