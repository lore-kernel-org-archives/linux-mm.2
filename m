Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C6CC982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF4C6B0093; Wed, 16 Sep 2026 12:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5FA46B0095; Wed, 16 Sep 2026 12:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FA76B0096; Wed, 16 Sep 2026 12:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6C06B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:00:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68DD91C2E30
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:00:27 +0000 (UTC)
X-FDA: 85220087694.18.A7163B2
Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8AECF160003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:00:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MjT3z3k6;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789574425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TsvLmFYjKq8EwshF1xfkN1TxmP1IiwbM+LSRU/xQAr8=;
	b=pBAm2rrLOmfDHEDmj5Kj/YeBGaNc+dcFy5LVt0awUCqTtoMIxW6mLwzh8V4j2g+/wUiiKr
	Wn4cfIFyw46ptsURdHDzCFlm6C7gHbG4BPlf4ZCjPQwv6YR3QRoDboc5tTZUosQqE7wjhg
	Xr2LHDp/Z6hpMmS7aSG64fYIoGZ4rnQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MjT3z3k6;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789574425;
	b=yvU80fJ1g1rDEGuexPao58pFZuVcB/bkI1mf1yJhEobBUqu+xqko0W57vlupYEDlRe+KSK
	rhguw9zvGEm5ZwJgp3VuZnjyvG48LaXhqoNCq6nQqya0VPS4BgihTrbTDg+7TJzSVuKu8V
	351/Yvjj+Iv+/Bk8UPo2an5tWf9h0h4=
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa053900f5so2010075a12.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789574424; x=1790179224; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TsvLmFYjKq8EwshF1xfkN1TxmP1IiwbM+LSRU/xQAr8=;
        b=MjT3z3k6EGKWtNOjNOatxLModF/LmGVeoAgiDkP2I6rGUN5EtA+iCb51Q0YbL8Do/x
         klY53SmcXxlxSQroDpjih1O0xsfhvnU3RCrdrQfqFhmd27zbzKJRaHYZ2gxq8eoagEIr
         nOh+yQMfnreLr40LcT9wtif7nHO+eNNHQ1htiQXZcHHH03wphCJJsDxqJiBtrWluKuLI
         weqBc5Pc7CNfQZXv1Dp16SwOB4WdnM/+9bt+PnrdmzArGMIAR1jZvRYEPf8NTn1LWxP1
         AFzeQKtCVAuQQJloKe8t1kg2poRSgEy3lyrlB9CEE21iRMM3tBOsgBkBFnwAynBzoP9q
         v9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789574424; x=1790179224;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsvLmFYjKq8EwshF1xfkN1TxmP1IiwbM+LSRU/xQAr8=;
        b=G7PBM3+C4+x3TNuyw7qLCsHsTHl5aseqR+OFTBY2xrN2BCksz5FTxrs8ewPMJqSdQm
         x8uavyZgFdo6/omzhV8uuhyPnE6h6q9eH1QrDrS88v1jh9p4OzePrNAFMQdu+twumqrv
         VLaCEJYcW+zLw70CjwcZzeN1bYLFCPW8cF0WWJabr2BsdHN5EIjUWSkyVdHelY95sg2A
         vfq9h8jbNB3BccYHAs7L9OTKf4+yg1SWy6ORMoMbv7zpfhCdc+X/hcf5OgWfllyawx3F
         Lfn/lhexndKxz1uAv0+Y7Tp0giGAx/uVYzzPAenktn3Ue0osEAsUTCPjXgLmO6GlS0+p
         LsmQ==
X-Forwarded-Encrypted: i=1; AKwUvBwXHfECbaaWFYBBFU+kzjmRc1/h09PPx28ygReOvyErW6LZAgh3ruUKQ3HyndBns1yzwkB+ZBc+qg==@kvack.org
X-Gm-Message-State: AFuF++mUAT9iStlkdBjd3vH0YQEW00XCyG3iFgPyULPvConXPsgruwwi
	6t+dgjytGB97GOGiSQs1Paxek3J4p4BbmAop1uGABq3ibL7ph53WYoDJ
X-Gm-Gg: AYBFou2+Zi9IPcoVUyHW19w2Uuk7eivK0AHwvVk8IKcqas0xTl/It9YECFQqRfovVJt
	rU5SqQcQ9QQ2gcqCJfYcLmL2+a7Pb6nJykh5TrdzilCa6dSDGU93mKeARHBtSJkvRSzlm4HapVp
	8quMYr8wjM0969RPZ/nq04vGQuHV60bcFTYNqO5n1zDUa+l39utV5gKTA5PvpUJZd0JIJOsy0oT
	3IZpyXtVPRXd4sV6F0ZQuXfe2QVaPnBWHjAlDz24idiXaq8q4o0jSeDfW7xF1L23t2yHJolXxgn
	jVcQjXspHhcTjtOoY6L1onK6vpgPjiyNGrJTapJHR0EgBo/DcnwbtEHxHVA8LmhiTFY78jZSifu
	HmH5zh2XS7fThll0sIL88EqItnvCqjJuCYLXy9oiuf9+zl5I/HPvWwWddu7fodVE3wxAgb5bO34
	qjC91tJ+6VH+akDMUkxqlBoKSTMyR5RWO0KkDy
X-Received: by 2002:a17:906:6296:b0:c21:450d:cd88 with SMTP id a640c23a62f3a-c29e51e1395mr226379866b.6.1789574423786;
        Wed, 16 Sep 2026 09:00:23 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29de454b4csm165476666b.17.2026.09.16.09.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 09:00:23 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 16 Sep 2026 18:00:20 +0200
To: Hillf Danton <hdanton@sina.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Dev Jain <dev.jain@arm.com>, lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for
 vmap drain
Message-ID: <aqq9FM3ti6NIHxQ0@milan>
References: <aqgnOoOjWxRtaqxZ@milan>
 <20260916001228.644-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916001228.644-1-hdanton@sina.com>
X-Rspam-User: 
X-Stat-Signature: feg74qysswwr1fu1fxz1jqrydtar3poa
X-Rspamd-Queue-Id: 8AECF160003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789574425-428954
X-HE-Meta: U2FsdGVkX1/Wx56YaAxKukoVKI+HNd9BujxSuhx/GzHC7qUmKwFtRT0T+e/S2xHlOPWnuleGcvKBmyRVuqC0UErOvVgQ5fa9fvxWdSEsH1q5cICYbOly1i3/LHgr6+7AScS8NG2NCiFHju2nx1wJS2/XBYpfsqLfS+/joWjv6BTLTF/2Cw1MOqCGf3ZzDkicjrfOnbxSsrC+DVpNdg4EI/d0b7hET1hzoXrrh24CKoLZ8QPPuiXx3u16Za2GdkL+8Y8CwMmPZgnCH0DpU5Fkw3uCxuuzlTDC9jd3b2b/M4PV/c9n2m8t3IwWj32giWEEVW8eZ4zSDA/ZGZNJag+gcm8SVbUpn1NAfhXx3WHx3s57lyuWKX2Hg9jrdHeEeeI2tWoYhNzeU/BaEvbHtBHbS/pDF8TiFG9Qm9SCDKTbv/EUuKpXF3VaDTVm9iHT3bxLiJ4Yxau9wu8tPnnIkdTQAtjqqQ/x8bT8dfZzt2PlklNM/F1DDzaxqq1ydHLfUMbGD9F4K20jS0Bdm3yn8d1MEGOQ+sIxpgmVhGiijCE7uo4FkC9G4m6yi7S0nl9F5TwMAYjhTPYWLWBHa512Qa5f5/A7ouCjA2ot2vAWb+wEmN/XJ/dddbGfUC7Wm8VLW8r+ZD3v3kB/Igj7kkkKFvz+2daBKwzjxoMUROcI/Zt1SEsqlmq8fJsrd8pZx04XeQWc3WnMOoX7Iwv4xukk7I5TjagsEyz/kROftWmsNbRFWCuyyz46zMQ8pfimVMeBGSZFlhPQYlNmnptwdjQ1a7JGHG6kkVVX2Q52bBCT5NJGidSak4WZAuAYrpy4OWuoGlen7/Zv+YpO/KkfausdGzAgdl2UQKid6K4pxPVX+7BoPOnnmUMk3XtdrpXvm205DCkZbkF8FPgQ76LE/+ro1Rb1otqJ07ZTaBwZXcWdt+ylumHYAmdbDn63HLMbFjI/v2sWaO4ysOqrBjrKVgYuPmP
 fpZy9PXX
 EsUqskDhWi3CuhUoUk9XmsmXmFfQxBpiOVKostcT0JoVc2nXkT+OwjrLXe7knt/YTxGa6wj5PNTjj+1MZ2zmyiYWlI7x9aR+j5X9mjmeZ4QwW+UK4lpB0MbDhAkdD+G3gqJPX9lfsPprRiPQjVSjFjCLWjy0ofKjBHUCq3jQ7z1B7830xAs1rAqBvpAzpY+mNdRfHNa8T6xO9ar9vAZ6vIVplCBjOKWtiYehsuwJSEE9F/FQCT26yWvx4qOW3cakS2D4BnFTxoe1AHpZliymFRn3JBaMDvI3M4W1ttzu6EYtX4dRvXD1euZKt2z49dBkZZKlva+TX8gl/WGTmm2zTCHN9rc0xUgApIOEEWdg61TnFeofDvJANootPrETGGEIpphNq49aJOoFRLZLTFeyX8C/1jfSq7Zj6BLScXCHGszkyvgQVbSHNE8Kb7AsTCNNhT5Li+59jQ20iVvMLLq8DDocSmXYeeNTUC3lItN5MgvH9Ib+eLpaNRmOdGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 08:12:27AM +0800, Hillf Danton wrote:
> On Mon, 14 Sep 2026 18:56:26 +0200 "Uladzislau Rezki (Sony)" wrote:
> > This patch does not use queue_work_on() semantic thus i do not want to
> > queue all helpers on current CPU. Instead scheduler does balancing and
> > that is it.
> > 
> [Fair queue in the Eric Dumazet accent]
> 
> +static bool
> +schedule_drain_vmap_work(struct workqueue_struct *wq,
> +		struct work_struct *work)
> +{
> +	if (wq)
> +		return queue_work(wq, work);
> +
> +	return false;
> +}
> +
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/workqueue.h#n697
> 
> static inline bool queue_work(struct workqueue_struct *wq,
> 			      struct work_struct *work)
> {
> 	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
> }
> 
> queue_work_on
>   __queue_work
> 	if (req_cpu == WORK_CPU_UNBOUND) {
> 		if (wq->flags & WQ_UNBOUND)
> 			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
> 		else
> 			cpu = raw_smp_processor_id();
> 	}
> /*
>  * When queueing an unbound work item to a wq, prefer local CPU if allowed
>  * by wq_unbound_cpumask.  Otherwise, round robin among the allowed ones to
>  * avoid perturbing sensitive tasks.
>  */
> static int wq_select_unbound_cpu(int cpu)
> {
>  	pr_warn_once("workqueue: round-robin CPU selection forced, expect performance impact\n");
> }
> 
/**
 * worker_attach_to_pool() - attach a worker to a pool
 * @worker: worker to be attached
 * @pool: the target pool
 *
 * Attach @worker to @pool.  Once attached, the %WORKER_UNBOUND flag and
 * cpu-binding of @worker are kept coordinated with the pool across
 * cpu-[un]hotplugs.
 */
static void worker_attach_to_pool(struct worker *worker,
				  struct worker_pool *pool)
{
	mutex_lock(&wq_pool_attach_mutex);

	/*
	 * The wq_pool_attach_mutex ensures %POOL_DISASSOCIATED remains stable
	 * across this function. See the comments above the flag definition for
	 * details. BH workers are, while per-CPU, always DISASSOCIATED.
	 */
	if (pool->flags & POOL_DISASSOCIATED) {
		worker->flags |= WORKER_UNBOUND;
	} else {
		WARN_ON_ONCE(pool->flags & POOL_BH);
		kthread_set_per_cpu(worker->task, pool->cpu);
	}
...
}

A local CPU preference for WQ_UNBOUND is not the same as executing on
the __bound__ per-CPU system kworker.

--
Uladzislau Rezki

