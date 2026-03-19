Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C971090222
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391B36B04C0; Thu, 19 Mar 2026 09:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347E36B04C2; Thu, 19 Mar 2026 09:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231A76B04C3; Thu, 19 Mar 2026 09:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F41C6B04C0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:23:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA4541DBB6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:23:43 +0000 (UTC)
X-FDA: 84562879926.07.017E71B
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id CE04F40008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:23:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hloEogiD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773926622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gi1yeZfgvnivbkzQjzFZaRoJUwW3BJjiIJuxd//iTGg=;
	b=IJu5mk5HjbujNYIK62+ys3Xjz7tbUdl42nw4WcgUYYexg8cp3EtZAzKT0ck/Yg5Y7fy+w4
	B40EVZqfA1MhaV7e5kXsSlX9jM8NqV3vS2tG6Fd1fqdug/hus1i1KUn64PqDpOKQ1HPVnm
	CCuLTaqDtP00yvH48PNqErbyvHMhAPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773926622; a=rsa-sha256;
	cv=none;
	b=YP1nR/9jE2rq9oemDCFiDWzQCsg/fVe/QMIVPB3FsopJW52PC/rBWnA6CHLkKaQeELsgGg
	hDw8Cub3z5fi79bZA8CmPK07KVIiMdG7rdV1w6SOoW5wzTqZSwgQdbQ14GpW+mWwTFQyBF
	mAC5RjUDg40Wek/i8ThXzIraIvR/IPs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hloEogiD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5a133b686f7so1021205e87.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773926620; x=1774531420; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gi1yeZfgvnivbkzQjzFZaRoJUwW3BJjiIJuxd//iTGg=;
        b=hloEogiDtImbUSCrqv3qbYhO6YZIHAdO6uIlXTrUcX9+MR7s1meSpS4JlVUn1g2bUu
         dLYwD+/aBYbd84MIBcU9IEMLElrd30ud+M+V+Fftk5GxsEzk0BtD4al3rhgVgTii8J6L
         3DieQ/elcN4WmUm676bfGq+UmAa9oyz22upZWySTB4rq13ukycw9fmZUUItQJF85W+gR
         xL0B6/d5n9BRDE1PlNCAuEIXXfHeJ2GwKCthQKfwu9ym4OISPw2zCGtZlwQBM53t5OOO
         HyoMYY83Uioj5pUkp9KMv0+DJSlbfWx1L7po1mWIV+ljqTWD36cfSLM3jkYPDy5/HScU
         bbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773926620; x=1774531420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gi1yeZfgvnivbkzQjzFZaRoJUwW3BJjiIJuxd//iTGg=;
        b=mEa+m4xJNg9HY4p/3LcrdTlfou9h29xrVVnDiUoR/AeNMZX02mvyT6PBvDl5I48E/6
         DnsxEP8d0UIUfSdaxm9kHNNZZr08PwPTVCPl1uYhfnmkENHXth43g5X9YrvVIKabnVMo
         IZSzb1+4LH10WIdImrHjEvhJVU2QSQHgQNdsfsYdDFNgym0Rcf+kUS0CAbqhslWPlDLW
         PrwIiibKwZ6tWEzHWXXT9GyPqh1+puAkTDr+VTTvfb7u+yQWNYOWQPSyUTxW0KiOWvBd
         OYX56gfBEuMLayXR9u0CgJybMl/0kVda0+AXqb5LA/KXXNL2iW52ZrUb1nMig45M5FmY
         FwGA==
X-Forwarded-Encrypted: i=1; AJvYcCWiXST5I/uDQuKERuvELH0/k0q/CCqPFSbwhmHrRjXaViGHPc/HrBJ2leZF29qWjYKYk+95WqzVfA==@kvack.org
X-Gm-Message-State: AOJu0Yz3oFOsStIbqhvVaAKIV3mZ21DQx8uAfHvL4YckYzFCVq0IcEDG
	M1fdRc6fX/P86R1hE4D67/hlqfSkuzicnCaB9KxLsoq8pOJFmeMwdOTj
X-Gm-Gg: ATEYQzxpRIMfDXPxAi0/ONSogsz1rDaNC1yQWqQf6CEwat9lEyvI1huDS20+U5AoK/F
	McgRkNrCgcW04MenRmrI3pnoKZDqpNQGZwivHQhGZrJnaQOnW4kBr4dwgSlbVvdH1Mo5nnqKjnq
	VkVQu6xgUsZRosENpHTrX1RbvGUGSPJ37+67uI3suMOvMlSdVyqfvaz4Fg0rDJn1k2rwUQrZ+i4
	/3eNbT/rZbwV0KaoBQnU3tCZwcwTpzL7gpCT+X5hW9rNKW/1aR3OGaeZOQCnzFIEdjy3/sKy+b+
	h/d4k/6qW5T+gxJw5ZFetKLh/bL5U12qjqny7dL7yPFJ2EYUSRwiagwY07QYvVgDmcDi8X8N0+p
	iY0K+sWI9ARAwDm2YdIwEiH2GfcIwreilC0UDOtniIRKg9ePECci39IejbIP7BOmu
X-Received: by 2002:a05:6512:14d:b0:5a1:74e3:203e with SMTP id 2adb3069b0e04-5a2796b61d5mr2389827e87.41.1773926619474;
        Thu, 19 Mar 2026 06:23:39 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a279c2c11dsm1212391e87.22.2026.03.19.06.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 06:23:39 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 19 Mar 2026 14:23:37 +0100
To: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbPz8/P10gUmU6IFtQ?=
 =?utf-8?Q?ATCH_v2=5D_mm=2Fvmalloc?= =?utf-8?Q?=3A?= use dedicated unbound
 workqueue for vmap area draining
Message-ID: <abv42QtTuwJCv1St@milan>
References: <20260319074307.2325-1-lirongqing@baidu.com>
 <abvEZehbufg4amhQ@pc636>
 <73a0ae8d2a334777a199a1555d6fdaaa@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73a0ae8d2a334777a199a1555d6fdaaa@baidu.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE04F40008
X-Stat-Signature: y9wztwt5t3y4aqyk44bbkmmjayu4m8g6
X-Rspam-User: 
X-HE-Tag: 1773926621-413178
X-HE-Meta: U2FsdGVkX186i7o7F1i/41bcIogThQ5rFT8m87o10GYa/MSkOQ8tCcjHla7RDc0NAT9gI4iQM05RAEdEDlxuNMh4LCaYwCR48R7PzIJPGvulu/H5ia8vUvuMRdCpwVkI6YYPUsQ30QHu+CUQ2SNY6H66xHZG0EB9VbSVco7abH/4l0Vcy0r4koD0pTDJYaCU54Aw0/MWetgQ5MUYv9kmFtiHyZmPEQaJjeclK6Iqrv3s+ooVI9G6yRYWKJCmj+HT/Xdy4LDtPborEoj0V00qcuCeyz8CDdAqvXcj/gDXhXxNJSH9wOoLlNzkCwR+zKZK5vCl/a1cgr6tYXYUI+vE35s0VcTYQLOlSOz8/lxhRJyBQAGfhod/93IDOeuD9qY428BthrP0mPp0VveCHymRx/AS/nEdW45UuaMGiPhH/iPNvYkDzn+7E39PbK7MUFHqI5EmDxSNSbdObX4+7S6IZsuVrG1IynxX4nVyYI+n6+elTBsTOC6/ign77E7sLXUQORgBQc5VW8nspbm58JRcQ3w4aPZ8do00HzKqJkx4aIDGcQpqZb1U/QuDbaWAKQKT+061pHPD3etLK1AWflS7/Yo3CcVWTGmabXiMU4/d8JBqeOI7T8QiBWKQL8gLEKphAj6ABqPrbBKeTxNd3E+LVSYzGE0Zd22w+CqbHoURwlkAKY7GGdEBeM3X3cf79kGNgvGrxNpbO7UmBqKhlYgD8bTMDTTkUtqt3MOIsS5HKke+GAMK75ElXPMrJSlHfCVbQvHtJ2E4v1teo0RqmFmIEQxTqKzT1HlueZGkJuAARhOcfPcy8fIbHPLkawYl/3Uik0eH0UH+P4vDzZeNLCOAaljaZNM5fSo3jWU7Eiu2UFMidCPpCez+S+nvzeqpaLJV088dH3BDXdaSjTyc34InJCmWTno9i1kpfiJOPkVj4tsoEyskMPC7buR66Kvt4bYL3tYqI0zywXe5q071/eG
 Xomy9krY
 YAC4NdJ8IIr7AXH9zGMKgUZiwEzjq9y/lINiIvZK6X2azPRFdH1ugxwb8LBs7LitXwIFYhuBxP/oeb+FQWNXSIqyXFWjCBfQgW/xhuetsCARs4Os4cHwLjCkRFqsmorTUU/V+dPVtafKAF9DXB4k16zNEuZ3xAtLqbRhx0wnppD7Hp57OWSDsRFWiTMgZQonBoXuygkk6odtmDfCim8qqbSU0iUbgSdc7L2jPnzd76T3sPnVJCs+1YM3lmdlxt2Ro95kkk8CwadV5NSTGAOkl/YhUFV9qmsat/dJJOX/7ZNk1PGHieZyAxFaV1EfekRxk6sLX44cbTUOZY/hcAMMQJRP1MLYv/Zc0sh0d4QZazXCGyw40SNSyqQ5L34hU0CcMAhnz8l7LfChXSs0uTcXtAX9iJLReL9ihZtP9wmPblWDGCd2AyD36ZKRtsxltQDxZ5K1/BUUKzdl9q9KOGAuCtrwo57wzL9gb76cE5oP+At0zBrVyaK92OqFDpqfMc6Fe4AcZyV/al3tzR1By8uEaxERm+vaLa/fl5WXBQG1vDkTLyUGFbaGLlLzMpfKOJmmtCfb0iFoLYYKyHZXxpFbyYXEQ2XKkUMG7/w+dIegqkstxT6AhkzvquGri2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:05:42AM +0000, Li,Rongqing(ACG CCN) wrote:
> 
> 
> > On Thu, Mar 19, 2026 at 03:43:07AM -0400, lirongqing wrote:
> > > From: Li RongQing <lirongqing@baidu.com>
> > >
> > > The drain_vmap_area_work() function can take >10ms to complete when
> > > there are many accumulated vmap areas in a system with a high CPU
> > > count, causing workqueue watchdog warnings when run via
> > > schedule_work():
> > >
> > > [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU
> > for >10000us
> > > 4 times, consider switching to WQ_UNBOUND [ 2192.823225] workqueue:
> > > drain_vmap_area_work hogged CPU for >10000us 5 times, consider
> > > switching to WQ_UNBOUND
> > >
> > > Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
> > > run this background task on any available CPU, improving responsiveness.
> > > Use WQ_MEM_RECLAIM to ensure forward progress under memory
> > pressure.
> > >
> > > Create vmap_drain_wq in vmalloc_init_late() which is called after
> > > workqueue_init_early() in start_kernel() to avoid boot-time crashes.
> > >
> > > Suggested-by: Uladzislau Rezki <urezki@gmail.com>
> > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > > ---
> > > Diff with v1: create dedicated unbound workqueue
> > >
> > >  include/linux/vmalloc.h |  2 ++
> > >  init/main.c             |  1 +
> > >  mm/vmalloc.c            | 14 +++++++++++++-
> > >  3 files changed, 16 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h index
> > > e8e94f9..c028603 100644
> > > --- a/include/linux/vmalloc.h
> > > +++ b/include/linux/vmalloc.h
> > > @@ -301,11 +301,13 @@ static inline void set_vm_flush_reset_perms(void
> > *addr)
> > >  	if (vm)
> > >  		vm->flags |= VM_FLUSH_RESET_PERMS;
> > >  }
> > > +void __init vmalloc_init_late(void);
> > >  #else  /* !CONFIG_MMU */
> > >  #define VMALLOC_TOTAL 0UL
> > >
> > >  static inline unsigned long vmalloc_nr_pages(void) { return 0; }
> > > static inline void set_vm_flush_reset_perms(void *addr) {}
> > > +static inline void __init vmalloc_init_late(void) {}
> > >  #endif /* CONFIG_MMU */
> > >
> > >  #if defined(CONFIG_MMU) && defined(CONFIG_SMP) diff --git
> > > a/init/main.c b/init/main.c index 1cb395d..50b497f 100644
> > > --- a/init/main.c
> > > +++ b/init/main.c
> > > @@ -1099,6 +1099,7 @@ void start_kernel(void)
> > >  	 * workqueue_init().
> > >  	 */
> > >  	workqueue_init_early();
> > > +	vmalloc_init_late();
> > >
> > No, no. We should not patch main.c for such purpose :)
> > 
> > >  	rcu_init();
> > >  	kvfree_rcu_init();
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c index 61caa55..a52ccd4 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -1067,6 +1067,7 @@ static void
> > reclaim_and_purge_vmap_areas(void);
> > >  static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
> > >  static void drain_vmap_area_work(struct work_struct *work);  static
> > > DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
> > > +static struct workqueue_struct *vmap_drain_wq;
> > >
> > >  static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
> > > static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr; @@
> > > -2471,7 +2472,7 @@ static void free_vmap_area_noflush(struct vmap_area
> > > *va)
> > >
> > >  	/* After this point, we may free va at any time */
> > >  	if (unlikely(nr_lazy > nr_lazy_max))
> > > -		schedule_work(&drain_vmap_work);
> > > +		queue_work(vmap_drain_wq, &drain_vmap_work);
> > >  }
> > >
> > >  /*
> > > @@ -5422,6 +5423,17 @@ vmap_node_shrink_scan(struct shrinker
> > *shrink, struct shrink_control *sc)
> > >  	return SHRINK_STOP;
> > >  }
> > >
> > > +void __init vmalloc_init_late(void)
> > > +{
> > > +	vmap_drain_wq = alloc_workqueue("vmap_drain",
> > > +						WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
> > > +	if (!vmap_drain_wq) {
> > > +		pr_warn("vmap_drain_wq creation failed, using
> > system_unbound_wq\n");
> > > +		vmap_drain_wq = system_unbound_wq;
> > > +	}
> > > +
> > > +}
> > > +
> > >  void __init vmalloc_init(void)
> > >  {
> > >  	struct shrinker *vmap_node_shrinker;
> > > --
> > > 2.9.4
> > >
> > Why can't you add this into the vmalloc_ini()?
> > 
> 
> If alloc_workqueue() is added into vmalloc_ini(), system will crash and fail to boot, sine allocate workqueue depends on workqueue_init_early()
> 
> Maybe this commit 3347fa092821("workqueue: make workqueue available early during boot") shows the reason
> 
That is true.

<snip>
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..81e1e74346d5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1067,6 +1067,7 @@ static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *drain_vmap_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
@@ -2437,6 +2438,17 @@ static void drain_vmap_area_work(struct work_struct *work)
 	mutex_unlock(&vmap_purge_lock);
 }
 
+static void
+schedule_drain_vmap_work(unsigned long nr_lazy, unsigned long nr_lazy_max)
+{
+	if (unlikely(nr_lazy > nr_lazy_max)) {
+		struct workqueue_struct *wq = READ_ONCE(drain_vmap_wq);
+
+		if (wq)
+			queue_work(wq, &drain_vmap_work);
+	}
+}
+
 /*
  * Free a vmap area, caller ensuring that the area has been unmapped,
  * unlinked and flush_cache_vunmap had been called for the correct
@@ -2470,8 +2482,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 	trace_free_vmap_area_noflush(va_start, nr_lazy, nr_lazy_max);
 
 	/* After this point, we may free va at any time */
-	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+	schedule_drain_vmap_work(nr_lazy, nr_lazy_max);
 }
 
 /*
@@ -5483,3 +5494,15 @@ void __init vmalloc_init(void)
 	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
 	shrinker_register(vmap_node_shrinker);
 }
+
+static int __init vmalloc_init_workqueue(void)
+{
+	struct workqueue_struct *wq;
+
+	wq = alloc_workqueue("vmap_drain", WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	WARN_ON(wq == NULL);
+	WRITE_ONCE(drain_vmap_wq, wq);
+
+	return 0;
+}
+early_initcall(vmalloc_init_workqueue);
<snip>

--
Uladzislau Rezki

