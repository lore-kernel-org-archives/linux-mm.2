Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A18EC982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813DC6B0092; Wed, 16 Sep 2026 20:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC246B0093; Wed, 16 Sep 2026 20:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7031C6B0095; Wed, 16 Sep 2026 20:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3616B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:08:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC188A016B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:07:59 +0000 (UTC)
X-FDA: 85221316278.02.0E86C60
Received: from r3-25.sinamail.sina.com.cn (r3-25.sinamail.sina.com.cn [202.108.3.25])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D79A140004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:07:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=vNt79vPy;
	spf=pass (imf09.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.25 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789603678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKjnpvXTojaVU5YIzpdNIrqfBtMirn+eCnJFcui5yEg=;
	b=11vSnQ2DrJg1JRqZVzgnrRcDFB1tHsutz8fgCDuV2Wqg1EV28ibuZg2/fE0aJWN/5keeZu
	gajFkoLdPEUcCLldQv4dh+swbD8+OD/nd0WuKz5HZv8jK8LORlZMRQ4V8c58NFsOAqgJGE
	y5M/1svyew/M10jRrgFaNZ2oQU6TJoU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=vNt79vPy;
	spf=pass (imf09.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.25 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789603678;
	b=u2/rgtzG6JWvi8x4p765XBcE2H8ieOPVZwPAK8b4uxQhFQCGAVPOfkVnJPJOrOlDqOb5wT
	fpIaIgTogqWL+/Ns5rmDToLK9h7NCHkczV4B6YZvC0pBcSPEWbRQ164cgsGPKGODpBfCSd
	mL2Rws7pcp1h+dbZwxFElfPEx4p9M+o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1789603676;
	bh=hKjnpvXTojaVU5YIzpdNIrqfBtMirn+eCnJFcui5yEg=;
	h=From:Subject:Date:Message-ID;
	b=vNt79vPykNoNngXEx5JT9Q5/HxV6TDIMfxVnloiGvfRk4IuuMOKLxgGWMF0tagFb/
	 BzEnkUCiz6M6IUchQWLA81wvsHtkYUYpqH7f+lErODeyg4JBLNmG284gpLnXLRoby+
	 rdt55LzDepinCQDrCe0c3aF71MQEcLXFenaYrXVc=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.194])
	by sina.com (10.54.253.31) with ESMTP
	id 6AAB2F5500000181; Thu, 17 Sep 2026 08:07:51 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8931646815926
X-SMAIL-UIID: 98200398C3E643C3AC30E941A3E8AE43-20260917-080751-1
From: Hillf Danton <hdanton@sina.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for vmap drain
Date: Thu, 17 Sep 2026 08:07:37 +0800
Message-ID: <20260917000738.115-1-hdanton@sina.com>
In-Reply-To: <aqq9FM3ti6NIHxQ0@milan>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ihubh61mtb3kdjgj4zxg3qu3yjxppmfw
X-Rspamd-Queue-Id: 9D79A140004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789603676-850061
X-HE-Meta: U2FsdGVkX19Nbk9ogBl73b6pk7+Mf2D/sCIC+Sb5/t6M46rbtiZKlcFjU9kC0gjNi1o52FuWF7SGaclipLzbor/xsmzarKtTbqkm3Hx9RF/ShvszmsLuK2dhp5dwGJLw9e7uP0G6V0Qua4JhnjN6//DT2SIhERocEAciZmtBAl4F5R07VtxWJg6da8/z4qieDKxmdpvifT7n+JxAQDZAv78XDA7bccotVue0GlVb9MTrR2MQdL2zWpekIGC6w0qHwSG7dfL2KhYYL6MavkB/3ZS4J5KV1GscJi3jcAT4/uwt/ua7sOBlKZDt0aAqY5JHXmY7bGI3WdWzZIclzWa5/Jj8+2S2zt7ySMwG74GLsfI0otFdAc3g+rvjdyiEVP19uC7vBkN1139sVGiJNAM3lACkxAcMAeB1iJ8jatJFxm82v6ix3rhB4k3PyK7YjcORpTpZjlF8L7ESs70flw7vlGArrlL3huWxxgKEzTyovwK/bcf7Jlu7Yz1UhPdyNQIFM4JcnpKySrhRe/6SIbf9qyc1c4ZpoVRR1ulwFen7MnbKpigCENkOKzyYkE0huc+xZi1y1ZTc4jZykglwQ3tCNg6vS7ZJXT/hz4TQgdrQjCagY8dMyAEo29fcn582TMoEyflDHR5VLTQsFbIZ/+C0UREdKQDjJ6GTWJACbAZ1eJw8fwYDCzCi4nyRnhnDot1JLWh0WZECnNSzWCHCIWySgK/hcmU4wkO3TawAJHOQbUzb/aC2DpaaP/Rp8mqmpyEqHSoHSiw7tZSZQxrU4JBL1yoEDu96Knu9K/JVY6nnipQn8a1vczbhUrcKiSN/Bt9ol79FGWNYR9MpcgL6fieespIhyrQLC9lDXeq5Tj8osxJkhdK1mau4BnF9XhrBEYHBpQJc2YNn1SgSOEomUqeJcvL8o5TWRlOvFBcSO9zH1JAeTVajdhdKHWCStqxmA/2QDk1varsKqGr0U0EmPYI
 sgE3WhET
 MKLcxCaGUsE/EoOszHs+b7Bjgsqiy2b701X9XHBLdrYlZGQU+Tg/LqqTtlY2LApXKRoYf9IYkvXVkWPa8C5CsodbjDYuVLVrIS7ovpp9h85ZTdobYxCL5COYkIpEtekwJfTB680ian0NwXp1TaeV9aK7quy6JaMlmtoaZfQdrJ3K5UDjkq50Vrrvi/LU4m+X0F5YrmPqkWdhCMvfqTQVLT4I6e2hkvTeyEn+co0uYNJNwgWPNzZ/o4PDX14UuUP1PaQJYgkcbWnI9V1rIFmi6s1N6iLuX9EdSTS96oMRSswJ7OmRsM0nRWEdUCGMhKwn0hoIIfeVINB1u2oqGngf9W2ZWrUwFq/xbtgUR9VB8HRxbBI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 18:00:20 +0200 "Uladzislau Rezki (Sony)" wrote:
> On Wed, Sep 16, 2026 at 08:12:27AM +0800, Hillf Danton wrote:
> > On Mon, 14 Sep 2026 18:56:26 +0200 "Uladzislau Rezki (Sony)" wrote:
> > > This patch does not use queue_work_on() semantic thus i do not want to
> > > queue all helpers on current CPU. Instead scheduler does balancing and
> > > that is it.
> > > 
> > [Fair queue in the Eric Dumazet accent]
> > 
> > +static bool
> > +schedule_drain_vmap_work(struct workqueue_struct *wq,
> > +		struct work_struct *work)
> > +{
> > +	if (wq)
> > +		return queue_work(wq, work);
> > +
> > +	return false;
> > +}
> > +
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/workqueue.h#n697
> > 
> > static inline bool queue_work(struct workqueue_struct *wq,
> > 			      struct work_struct *work)
> > {
> > 	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
> > }
> > 
> > queue_work_on
> >   __queue_work
> > 	if (req_cpu == WORK_CPU_UNBOUND) {
> > 		if (wq->flags & WQ_UNBOUND)
> > 			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
> > 		else
> > 			cpu = raw_smp_processor_id();
> > 	}
> > /*
> >  * When queueing an unbound work item to a wq, prefer local CPU if allowed
> >  * by wq_unbound_cpumask.  Otherwise, round robin among the allowed ones to
> >  * avoid perturbing sensitive tasks.
> >  */
> > static int wq_select_unbound_cpu(int cpu)
> > {
> >  	pr_warn_once("workqueue: round-robin CPU selection forced, expect performance impact\n");
> > }
> > 
> /**
>  * worker_attach_to_pool() - attach a worker to a pool
>  * @worker: worker to be attached
>  * @pool: the target pool
>  *
>  * Attach @worker to @pool.  Once attached, the %WORKER_UNBOUND flag and
>  * cpu-binding of @worker are kept coordinated with the pool across
>  * cpu-[un]hotplugs.
>  */
> static void worker_attach_to_pool(struct worker *worker,
> 				  struct worker_pool *pool)
> {
> 	mutex_lock(&wq_pool_attach_mutex);
> 
> 	/*
> 	 * The wq_pool_attach_mutex ensures %POOL_DISASSOCIATED remains stable
> 	 * across this function. See the comments above the flag definition for
> 	 * details. BH workers are, while per-CPU, always DISASSOCIATED.
> 	 */
> 	if (pool->flags & POOL_DISASSOCIATED) {
> 		worker->flags |= WORKER_UNBOUND;
> 	} else {
> 		WARN_ON_ONCE(pool->flags & POOL_BH);
> 		kthread_set_per_cpu(worker->task, pool->cpu);
> 	}
> ...
> }
> 
> A local CPU preference for WQ_UNBOUND is not the same as executing on
> the __bound__ per-CPU system kworker.
>
As Ulad, like Yu Zhao, is one of the couple black horses I saw in mm the
past a couple years, lad, I make the difference between BOUND and UNBOUND
workers as clear as it is.

Given numa node1 including cpu8-15 without cpu hotplug cared, a bound worker
for cpu9 can not migrate to any other cpu, while a unbound worker can run on
any cpu of node1, that is all.

Important UN/BOUND have nothing to do with eevdf (and balancing cpus) because
of different layers.

And at best I suspect what you missed is the difference between drain_vmap_work
and lru_add_drain_work, but I do not like the latter as it annoyed the RT/full
nohz apps more than thought [11].

static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);

[11] Subject: [PATCH v4 3/4] swap: apply new pw_queue_on() interface
https://lore.kernel.org/lkml/20260519012754.240804-4-leobras.c@gmail.com/

