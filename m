Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1803C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 17:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1DC6B008A; Thu, 17 Sep 2026 13:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8623F6B008C; Thu, 17 Sep 2026 13:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7781F6B0092; Thu, 17 Sep 2026 13:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4876B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:03:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3E8E14041B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:03:53 +0000 (UTC)
X-FDA: 85223876346.13.531AA0F
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf21.hostedemail.com (Postfix) with ESMTP id E44941C0018
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:03:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JmakF19C;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789664631;
	b=WODaJBSNoELtkwVkEdkEYnj6ESzT0SOcMZOtqCLjpU6AmvNnHreREfZ2AgWFrT9Hup4kA/
	gwo4/nNVrodBDtqd6tMQ3ZmCDqz2VHf2z3jRpFfjSpM3V5dpLYU0UsNzziGJwVzSnAxVZL
	rPO97c/UuXTG3Ule4ZXaQrRS6Sw5IGI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JmakF19C;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789664631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fH5cw0fhsMPy1+1s3VO0uTAvQBMG9JXZ6ItIaasS8bk=;
	b=sDKsHeQOFLm50Egn8xG2zTT9BfO8+FHlc6Qe/Vv2/XTVlcaexgYvj5y+GtwSDpIgrS9u7Q
	a2E1Xgldyh10Lfa/qUN820n68m9sZc5x4fdBXCzf4UEPM07GdfO+v4JvUNawmI7mZuq3Od
	GRRkmuUBOlyhFs2X2o6laaz7DIWFoTc=
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a99c5de614so1521689a12.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789664630; x=1790269430; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fH5cw0fhsMPy1+1s3VO0uTAvQBMG9JXZ6ItIaasS8bk=;
        b=JmakF19CHs5uPnLjqjcQp+dtQCEI6icXsXlA9NjiY3XCNf8lcVSPKOesEWFdcBtYwh
         bVc2ZI5OldpwFHSOJbhQPjGMfLQAgl5ODaJOp37W/YWeqZe2pkdKd75ZHSQ5VseNGgbt
         aL9j9Tmi67g4vuPynd9XOl1MnNB6iKs3wHsX0RbMiQc7sOkgWRhWNmi+VZkhYV2TFEVs
         zPeigmi0I5tw3yK0yXtbtUJ3mz7JKRZ5E4QQWaOtb8IqYcFqcIc3gt099SZ3/6K4koB6
         QU1x3mZhBgG96ZbgnAnWS7AXgI3TNO9IDaPZOlseihXBKAT0p4+825YCwCIs00f6vXxg
         Ln9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789664630; x=1790269430;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fH5cw0fhsMPy1+1s3VO0uTAvQBMG9JXZ6ItIaasS8bk=;
        b=cT3nTwRDe35eHO+Pc2+4yAde1Biz5U8DSNepFgz9yf5aCG/eSifSZWj2pGFRavz5Ln
         An0snA48h+dfT3pzMbegK4acvHmItqIK4+8VCdtlCzvVhxHpJqnOL13r9C7ayT58weBd
         rB6t++5zWb0qatejyV7rgDHE8MqKy/5qhRxGjCaSuK8iTZ5DRhbG+lBN18bLNOIDjtcO
         emHFeCGueF78qYqFeoHaV6bFSBDa86q4vgO5DJ0MQi71nhThWUhIfg1nGsNyCS9hkxQa
         u+XIFEx+qsuiUNhB6Aw7cV4zAixY3dWZ+Oxwo9rLlEaA6+MaZl+hViguk3JJcv9gEx9s
         alAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzgkOU4+2e4SkdqJbgLtPZ1aWmfTk45V95az8kpyFix8IeqgunlXHbaNFUC7hkpbdN6oJpAwYYewg==@kvack.org
X-Gm-Message-State: AFuF++kmZycvwL/7v+lIz892a/vNWErjVKE8H4afXk8iDcadUn8dASTD
	ok6A3XQS9bkiFehSlUKQjZF3XWYRWwkSujzoD24bYYADfVXOqLsFxGHE
X-Gm-Gg: AYBFou2mn28m6StbwPtB+87CJSFNjASyY2TMkSldiHsz+uONZyNb+ieMo5PVjL7a3U7
	6ej9Ez4zproleVEBjJ6WN7OXtrUMeiGXP9pvT5sVzsP/N9jhK6OEi4nqHxwZsukRAdYD9gjfftV
	kyF0YqeS95PM1TpzH7wgAbYV0nExUTpkqA+6t3ebB46SlrXQoAOzZNoqCMe+CbyPJvwjWtxF8H3
	+Vi0KDsahxt47D1t1zm0h6zRIYN30qSQn90b0a/RjFbhw4Gt3fPaa2C/HvfVST9YUxcKsGXFd/E
	hcR9QMNX2/PFRmSyLr/FOItTBRsDzLXibdhxOohdcRf+lV9VlExSdhlPCR5wXUdJ0K5DevrEzJ0
	N316dhliqO/5Y02GRzjeiayod35qYcH31krGFfe4j2Aqcmu4hTYmSYOHL+7Un0ZOsBbqAuyzjQy
	9O6+5PZdp2cnPWDwrVlsQb4PKasfJrTf4rvFk=
X-Received: by 2002:a05:6402:440b:b0:6a6:21d9:541f with SMTP id 4fb4d7f45d1cf-6aa22375faemr10992820a12.6.1789664630199;
        Thu, 17 Sep 2026 10:03:50 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa1d29a1bdsm4317739a12.26.2026.09.17.10.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 10:03:49 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 17 Sep 2026 19:03:47 +0200
To: Hillf Danton <hdanton@sina.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Dev Jain <dev.jain@arm.com>, lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for
 vmap drain
Message-ID: <aqwdc7Oh24b_bxOQ@milan>
References: <aqq9FM3ti6NIHxQ0@milan>
 <20260917000738.115-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917000738.115-1-hdanton@sina.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E44941C0018
X-Stat-Signature: gcra9zqgw5kafa38kb1ss396rfwho6u9
X-Rspam-User: 
X-HE-Tag: 1789664631-332303
X-HE-Meta: U2FsdGVkX18XUgatczijtHRtuPtJmWpvTgcWOU5jE+7sVUL/C1JIjIDB+uAJLp++eIiZ8Xd6VJde3uMmA7a7mCqdtm/7y+K4etGudguiiohrjJaz+QUZKLR9DACI+srGVGbeNxnSZkgIBO3+1LnRMHDVCiwNOrVR28YXQemcVncGWUJgVkY8e48nmOyQeLxZPrr3G37MJRovqn5AXEdO4S2my7eMFE83NjqZuk5x7si/GyK/IJkIbDjSvKG1/X4ZoGk/ivTD/KPJvpmzSDXfLd/LVxG0dsxtllzcn+gb1kXxi5RnLh1pEZXdgGFG9G5Cl/7b9WaRmDSz93oar3nzDAnQcIZr+1/pSk3Ds/8sCTjRjtMR+0FJcSLHBHJI7iuDcNju/cN650XErDBk+5x2Gf+6DgJ3YybBYISDi6FVDhzuQFpUJLJ38UunT2P3Mm2Dok1TgFQJKgiMMB8r0cBOR8ijzbt1KERIGfhv9Wp2aYKFROFGPzx6jE6xX+62kxZU9gc1NIjPx4GM0ou8vrGL0NCL7lKILsooD64mOL0wnFhDsRY+g/qjFKbJuMCZJAnk4ydbkC8ZonL95+RAlwpdxKTZbCqHO6QWsJomPyWX2qIR7Snyoz0/yJZDWqOGo8m8WQiCKkBs2YOzhxhTEkIJB+2lAKSfcgNulXTLhMEBWbeZEIj/V4S/LRvCJSQNyKFz90nk/sKj9/pb5DhHVz/+mGQg4DDUy3E8iFrh4m9E/Gy2cXSHUT47rMnh7KvfzNX60JQ10dYcCR1ZpRYDDTl8+4uPqvbxP1QRO7n9+RVFtA0pKIJVGtUoGaHbyra1W0wHL1rcuzsqcKBP9Q6VJlgQDRTs04ddtJpJdd83c1VvGNK+nf2MwOUcziYDwkcTnBH/Fp7zwFnHt8kqN5K/t38b+hCrP9iC6KP1gFF9mzVMoRac6/jEHh3ys3urJMpxzKJwhAEgbGzUazzeGpIJxN5
 JD+3C258
 2Wf1lQZIN8bNmNv4hTxeFXOzZ3kTarXnMwfkvrUK0DO2Noh1hs5Z0Ws2Mc4+Q4kLeFJHsMgAoLY0RITr9p/lIMGE3/+tNhy8+1qydhaP9yNyUDrPcj1isjrJ9s+a+40QP/WnxR68g49sIt9EW43ifcHDffuFjIB9rqB8chQHG5O5E1oczT4YMx88YNng1g6oVxXMZ+NsIuW+VfiatekVSHiFsmBGb6rcvtk+9NuwImLqVGTQo5K30W2eZDcNOvx9bRtZK0EsjhjxiFtd51vzKiGP9SazslqbGRb2Pd1ejC2unCuohsNQczds2dAtdx14+kdGlcKWxhbhscES7Lyy6t9tGX8Jq0Fe3GyZtLSsGEi0YXI7YK295XLZNFZCOV92g76kAm2HWVPBjkCaLHw/4dl+gWZWhwfqulxXe0H5IqAX8FKiV+7LqpzbvXlKM8WsFLamb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 08:07:37AM +0800, Hillf Danton wrote:
> On Wed, 16 Sep 2026 18:00:20 +0200 "Uladzislau Rezki (Sony)" wrote:
> > On Wed, Sep 16, 2026 at 08:12:27AM +0800, Hillf Danton wrote:
> > > On Mon, 14 Sep 2026 18:56:26 +0200 "Uladzislau Rezki (Sony)" wrote:
> > > > This patch does not use queue_work_on() semantic thus i do not want to
> > > > queue all helpers on current CPU. Instead scheduler does balancing and
> > > > that is it.
> > > > 
> > > [Fair queue in the Eric Dumazet accent]
> > > 
> > > +static bool
> > > +schedule_drain_vmap_work(struct workqueue_struct *wq,
> > > +		struct work_struct *work)
> > > +{
> > > +	if (wq)
> > > +		return queue_work(wq, work);
> > > +
> > > +	return false;
> > > +}
> > > +
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/workqueue.h#n697
> > > 
> > > static inline bool queue_work(struct workqueue_struct *wq,
> > > 			      struct work_struct *work)
> > > {
> > > 	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
> > > }
> > > 
> > > queue_work_on
> > >   __queue_work
> > > 	if (req_cpu == WORK_CPU_UNBOUND) {
> > > 		if (wq->flags & WQ_UNBOUND)
> > > 			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
> > > 		else
> > > 			cpu = raw_smp_processor_id();
> > > 	}
> > > /*
> > >  * When queueing an unbound work item to a wq, prefer local CPU if allowed
> > >  * by wq_unbound_cpumask.  Otherwise, round robin among the allowed ones to
> > >  * avoid perturbing sensitive tasks.
> > >  */
> > > static int wq_select_unbound_cpu(int cpu)
> > > {
> > >  	pr_warn_once("workqueue: round-robin CPU selection forced, expect performance impact\n");
> > > }
> > > 
> > /**
> >  * worker_attach_to_pool() - attach a worker to a pool
> >  * @worker: worker to be attached
> >  * @pool: the target pool
> >  *
> >  * Attach @worker to @pool.  Once attached, the %WORKER_UNBOUND flag and
> >  * cpu-binding of @worker are kept coordinated with the pool across
> >  * cpu-[un]hotplugs.
> >  */
> > static void worker_attach_to_pool(struct worker *worker,
> > 				  struct worker_pool *pool)
> > {
> > 	mutex_lock(&wq_pool_attach_mutex);
> > 
> > 	/*
> > 	 * The wq_pool_attach_mutex ensures %POOL_DISASSOCIATED remains stable
> > 	 * across this function. See the comments above the flag definition for
> > 	 * details. BH workers are, while per-CPU, always DISASSOCIATED.
> > 	 */
> > 	if (pool->flags & POOL_DISASSOCIATED) {
> > 		worker->flags |= WORKER_UNBOUND;
> > 	} else {
> > 		WARN_ON_ONCE(pool->flags & POOL_BH);
> > 		kthread_set_per_cpu(worker->task, pool->cpu);
> > 	}
> > ...
> > }
> > 
> > A local CPU preference for WQ_UNBOUND is not the same as executing on
> > the __bound__ per-CPU system kworker.
> >
> As Ulad, like Yu Zhao, is one of the couple black horses I saw in mm the
> past a couple years, lad, I make the difference between BOUND and UNBOUND
> workers as clear as it is.
>
This is very good :)

> 
> Given numa node1 including cpu8-15 without cpu hotplug cared, a bound worker
> for cpu9 can not migrate to any other cpu, while a unbound worker can run on
> any cpu of node1, that is all.
> 
Right. 

<snip>
	if (list_empty(&pwq->inactive_works) && pwq_tryinc_nr_active(pwq, false)) {
		if (list_empty(&pool->worklist))
			pool->last_progress_ts = jiffies;

		trace_workqueue_activate_work(work);
		insert_work(pwq, work, &pool->worklist, work_flags);
		kick_pool_pick(pool, &wake_task);
	} else {
		work_flags |= WORK_STRUCT_INACTIVE;
		insert_work(pwq, work, &pwq->inactive_works, work_flags);
	}

out:
	raw_spin_unlock(&pool->lock);
	if (wake_task)
		wake_up_process(wake_task);
<snip>

wake_up_process(wake_task) - this guy takes care about task placement.
For us it is TASK_FAIR thus select_task_rq_fair() decides the fate of
unbound kworker.

> Important UN/BOUND have nothing to do with eevdf (and balancing cpus) because
> of different layers.
> 
> And at best I suspect what you missed is the difference between drain_vmap_work
> and lru_add_drain_work, but I do not like the latter as it annoyed the RT/full
> nohz apps more than thought [11].
> 
> static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
> static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
> 
> [11] Subject: [PATCH v4 3/4] swap: apply new pw_queue_on() interface
> https://lore.kernel.org/lkml/20260519012754.240804-4-leobras.c@gmail.com/
>
I am not sure a drain_vmap_work should be per-cpu, IMO.

Thanks!

--
Uladzislau Rezki

