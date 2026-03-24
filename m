Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AAC5FEC11A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 22:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9436B0005; Tue, 24 Mar 2026 18:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A4A6B0089; Tue, 24 Mar 2026 18:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0494A6B008A; Tue, 24 Mar 2026 18:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E38676B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:06:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 616AE8B75D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:06:45 +0000 (UTC)
X-FDA: 84582341970.15.03E2B4F
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 599C614000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:06:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILt99KmH;
	spf=pass (imf26.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774390003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31RLaPoXgoqacAsqS3rULshRlRBQNXVz3bwTKZ44LII=;
	b=Fmaw9nNUW+6BKGUjiOntzQuC5peDCtV92h59Qk6n+61KgtiX13+ytHhzYnboiYqDwZoSYY
	XD0JdmAnPpzLbDn1Z0t4LfPNMkvBieatmvF27mQgo9uK2XQybgncXBJunbcn65CNLIWbuH
	saA1ey+Rcf/UXdO8nixChBuXvj4Tes4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774390003; a=rsa-sha256;
	cv=none;
	b=apiykIMIuQab34BQqu93YygDtSlPLr8HKYw1E9sM86SzrO2MoCHLS0IicpUAUOsNIXWjvD
	p0D6A8O6X+UVbGHJfOLSueDwikR8tb3LcYat3eeEiNPE/XhCaSMgoESjxOOkcU5OZfnQU6
	Ad0d57poNO/aMUu+miCNmBl3Rekv6Dc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILt99KmH;
	spf=pass (imf26.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-486fd5360d4so19825335e9.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774390002; x=1774994802; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=31RLaPoXgoqacAsqS3rULshRlRBQNXVz3bwTKZ44LII=;
        b=ILt99KmHYDMxTphM/9Hwhz0ZbMlGBvvzCWRAIUDK7m15+Pn5A0ak2yoq5ZYKPwvCm0
         LHG1Si3a3pZes4+OCj9V1YxTptQ/Dt/VWlo/VlLcfdXj/O5EZUQJBWYHe5u7JVjODCP6
         75r5IxbkC0xIownv6jYAfzWTsCK1mqxlOyMR7bQNbwsXrLAP2DPz+v3PVJ/FYGW/nS/s
         MZQVya9lkyEmpNlUqf6qbfcBul7ze2YG+713UK1eQY+0l/PufLbBQnGltPVhHQzN2iKU
         NpPjUK1y8qrwzkiR8kuxmBzYomaUtAJcWBg+a7M7k3vcA0+29Uy11EtHYcuWHkcLq5uv
         wIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774390002; x=1774994802;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31RLaPoXgoqacAsqS3rULshRlRBQNXVz3bwTKZ44LII=;
        b=gmEINHCmBfLdZ9WJrAxdtoh/61Rbd1aMiAWC0kNNsNJpBpl8Z65FZiTR0zTjlrMu4q
         5T98OTSVMNYYhHIHBQkm3nRHB55QTE/w0R0qVLcEv3HCkQ75ar/cPA8jCFXf2Pd+TXsf
         8/sUW2aQDh+C76sD2He9ns6FZuvHih7VFsf+JLBD5y1ba/pza8Un9Y4CvbfEUybsjkWe
         MQv0OE9BsS1f6/jYepIvmLQ7diTqQ9PXgiQXnEJJhDD9zKkGsFLOadlGu2qbBpIF2vbY
         smKjcAB2fxoGwLvOu3i2jnlNJCQUxw4TdlSJE8XUX0REoOLGRb4f8gFNyZambytWoa7l
         dBQA==
X-Forwarded-Encrypted: i=1; AJvYcCV3k1LS3OT2v1NKXOavzSWL4B+IbPEAhUAc6+WXmP7RDl/4B/8S64miOL8S3ieEENqx8+xaZ6DIXQ==@kvack.org
X-Gm-Message-State: AOJu0YwmFYnLsmJd+xWjm4eECk13L3UfQQ0XUDcCDo9M78SQev05TfHV
	P+Sg0N3gKj/f0H0fQ2CTPlOEnpQHCz1MrawKSbmtik4uAERCqwVt+bJPLJDZdA==
X-Gm-Gg: ATEYQzyg/J2TjPfSzLVcEW9/ym2fnz7wTKnHLtMKQB8wRBawP9wuOB3xdhb+bqantNU
	XhBDFbfeNqsamR3NTJolGerZx2kyhHS8IfWQpMcbwRD1lT5rSiPrYzOCqLjtysjKvCGH3YRpj+D
	ocCs/Xp55uY7U8jyvLTzSMZAmFVAChFjfpuF3guCSmjF9KJsdfZDpyxPbdhDxIwyq0PqVjHsZ/O
	biYf9GktzadccTyJflUbnELiu6YYzitkab3Jj+wNBYjPHqptAQu0VLezX0zyUA3HH3WVVkpfU1C
	rKnYa4gm4rilXBl6eVs5HyMDAZSLQBasUL4FvUKAJTCqHNIuhRxHrxD+E2PYqoM9VMTuixywrNw
	JxB9Dk6fO8ZzdVluNEVrReJH8ehcCmOsbmpiAmkxoUsAkZRmqtgjga+2BJbq3AvAQ/Pz0KTvvqC
	+Tw/IDW5F6/OcMxhz0z//4V/bmGoSc1D5acRAn50G4bA8F+Q==
X-Received: by 2002:a05:600c:1e2a:b0:487:18c:7acf with SMTP id 5b1f17b1804b1-4871606d963mr19826655e9.25.1774390001583;
        Tue, 24 Mar 2026 15:06:41 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48716547649sm12045235e9.0.2026.03.24.15.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 15:06:41 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush work
Date: Tue, 24 Mar 2026 19:06:39 -0300
Message-ID: <acMK75mqEZoZAdhH@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <acJ7aS7Pt3KknN1B@localhost.localdomain>
References: <20260302154945.143996316@redhat.com> <20260302155105.214878062@redhat.com> <abSH40oW9qiVDXZS@pavilion.home> <abb2E3QW7t5Rhxrt@WindFlash> <ablYPt92Y63GcIu2@localhost.localdomain> <acCZsEOsrv5Ku-mu@WindFlash> <acJ7aS7Pt3KknN1B@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: qf4tu8a7uw9uj4e53h781in5x786onqq
X-Rspamd-Queue-Id: 599C614000C
X-Rspam-User: 
X-HE-Tag: 1774390003-141469
X-HE-Meta: U2FsdGVkX1/N9IfGzfrCwKUbh2S+/bZFjCZbTDIGmfjG0ScyheVAhck4l4TBtmp9/lpUBsmhKwCFpeMh/nhyvCV8ybm6eG/UcMSEbkZ2nmVC7pfBXB8iGdFBTFRfu+iibex0j/3BcvdMs/r6xNoIghAYYRu1bocUTdGsWieV3j9Yj48zCuZRgHOeqnwNEMaytNSxR/zN2KUemUuiXz7zBG0h/VtdRFLsm9jyh2gWGMZ0EcfxEwEoqa/AalhN03OiiP1DStwrV4rqP9Gp/YOntX1Un3pGk8IaKUqwEqAo4qolsVcd2+a2ksURXz5zCHALjZVm0ehmAnvq4zbpEbOqvunAE0vKAiMfgVvF94Q3g8vGXTFQXDftB3cYRzO58NcHR6FQnKZgl0JlUvwAHsZz+vkl60CqWoK1PrqEONfhZ3G3InZaAXWsVQelDBsW0Iu9gf/o8COMZPyyUYy0rhVXKVbPVaGAIFNJxS5WCJ3nQClGQHfe9F9RwuTBa1gSUHFdjZtV1ZGvaI66MDCGE+6kSa8iUqEnebhmarM5oW5cl0IWL9U/970KgW3x3hoWLLm1NYWePk7z9buBS75WH2x9Be2jEnrLtCoYmQGAwlRLQoOZ3EzOcGbFygyp7jSFFVcxRRdgNhyG1B2jd8hQl9kkTZXENa92SXOPtnWu/t7/sp5buAVx1F0u7iT0nOOj9FbF03I4BwWsVZL+Nbv8CqZk40+1pzWM2fl6HdAKdV9xQ3CkiqIZTpkHGKJVe6XbVw4pmMpIX8c0WK+9BhiViO3QnliBR3AK91AoO/KrYu3bq53nb6ISWwOtr2z8Dk8My1Mid6Y6E8zumYDyYrzQA4vETqyAb7IkffA9yvFzX9q2RKBxYCx4xy9eLhAKUfSS/dnlwFRBA5s9OAv2XcVFnf5I3aNDcBa13CGIuYlkRKIcpH6DxbNl29p7uPGEw0dyevk4JDr1wT3YATaBi5FM/ct
 Pc/nZIWk
 SCSQCiAKE99xfG1u5+STQTuMXGe9tls4iJs1JCC0yPYSnJYrV2oCqjcHgLWMkgNp6nT5+abl/OwIvZNZmmiX9IuYnlYEcURuvqmSgfvn8d0aEZsmUwk4oslqVGeS61CiDhOyvpQVe/NuKa0zvAk1QLBFLtcnBNWEb1mlBscLaA2Tce+3+nD8+pGCgUhlD2eYdKHSkl4dIAE6rgr1rCf6uy9FSALmQoVjqGXtSFhuVEWeuYYsWgJJE4frZ0r2Cbvpy1RnXNCeRoSvbajE1x3tk1XidCh7qk9lbXrf2ZF9NoGKuOjHUr+qbYPN1T13U6MlASXfyxPKL3PGrCQe2YddHCvx7Q3gk3kawXFSQZ4ZOcZC1+DlDAqaeW5FWmTngAMxKVKzBgugS1lwlaW3cP7+QbERQQwlX03U/WfWY+8L7riZXsv9i6PWvWr2u3tB0bAsR4H4cE1NMYmwSZeagBQIzz/zZoPrFxjjMYtiYlTTV8x6ri0YtKj5CoT7Z8s065C8kCEXXdJAgb4Z4II6cavgp1sl0Jg3+tl3ttK3cJJZcQrb6FkDb0b5EG0KYXwOUHspxWVZVGuFz4ObJ3TbaT8SnYmdB0RffYHE3gkfhPGOQX4OZXgxifoaMbs68YrXd8xfZ4rMf+OSkOsAiW78YMXK8fx1BslkCPeYyE1cSHhARAqf0bjvrtsyjszXejA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 12:54:17PM +0100, Frederic Weisbecker wrote:
> Le Sun, Mar 22, 2026 at 10:38:56PM -0300, Leonardo Bras a écrit :
> > On Tue, Mar 17, 2026 at 02:33:50PM +0100, Frederic Weisbecker wrote:
> > > Le Sun, Mar 15, 2026 at 03:10:27PM -0300, Leonardo Bras a écrit :
> > > > On Fri, Mar 13, 2026 at 10:55:47PM +0100, Frederic Weisbecker wrote:
> > > > > I find this part of the semantic a bit weird. If we eventually queue
> > > > > the work, why do we care about doing a local_lock() locally ?
> > > > 
> > > > (Sorry, not sure if I was able to understand the question.)
> > > > 
> > > > Local locks make sure a per-cpu procedure happens on the same CPU from 
> > > > start to end. Using migrate_disable & using per-cpu spinlocks on RT and 
> > > > doing preempt_disable in non_RT.
> > > > 
> > > > Most of the cases happen to have the work done in the local cpu, and just 
> > > > a few procedures happen to be queued remotely, such as remote cache 
> > > > draining. 
> > > > 
> > > > Even with the new 'local_qpw_lock()' which is faster for cases we are sure 
> > > > to have local usages, on qpw=0 we have to make qpw_lock() a local_lock as 
> > > > well, as the cpu receiving the scheduled work needs to make sure to run it 
> > > > all without moving to a different cpu.
> > > 
> > > But queue_work_on() already makes sure the work doesn't move to a different CPU
> > > (provided hotplug is correctly handled for the work).
> > > 
> > > Looks like we are both confused, so let's take a practical example. Suppose
> > > CPU 0 queues a work to CPU 1 which sets a per-cpu variable named A to the value
> > > "1". We want to guarantee that further reads of that per-cpu value by CPU 1
> > > see the new value. With qpw=1, it looks like this:
> > > 
> > > CPU 0                                               CPU 1
> > > -----                                               -----
> > > 
> > > qpw_lock(CPU 1)
> > >    spin_lock(&QPW_CPU1)
> > > qpw_queue_for(write_A, 1)
> > >     write_A()
> > >        A1 = per_cpu_ptr(&A, 1)
> > >        *A1 = 1
> > > qpw_unlock(CPU 1)
> > >     spin_unlock(&QPW_CPU1)
> > >                                                    read_A()
> > >                                                        qpw_lock(CPU 1)
> > >                                                            spin_lock(&QPW_CPU1)
> > >                                                        r0 = __this_cpu_read(&A)
> > >                                                        qpw_unlock(CPU 1)
> > >                                                            spin_unlock(&QPW_CPU1)
> > >                                                    
> > > 
> > > CPU 0 took the spinlock while writing to A, so CPU 1 is guaranteed to further
> > > observe the new value because it takes the same spinlock (r0 == 1)
> > > 
> > 
> > Here, if we are in CPU0 we should never take the qpw_lock(CPU1) unless we 
> > are inside queue_percpu_work_on().
> > 
> > Maybe I am not getting your use case :/
> > 
> > Also, I don't see a case where we would need to call 
> > queue_percpu_work_on() inside a qpw_lock(). This could be dangerous as it 
> > could be the case in another cpu and cause a deadlock:
> > 
> > CPU 0 				CPU 1
> > qpw_lock(0)			qpw_lock(1)
> > ...				...
> > queue_percpu_work_on()		queue_percpu_work_on()
> > 	qpw_lock(1)			qpw_lock(0)
> 
> Ok I just checked the practical usecase in the patchset and it was me not
> getting your usecase. The qpw lock is used inside the work itself. And now
> that makes sense.
> 
> > 
> > 
> > > Now look at the qpw=0 case:
> > >                                   
> > > CPU 0                                               CPU 1
> > > -----                                               -----
> > > 
> > > qpw_lock(CPU 1)
> > >    local_lock(&QPW_CPU0)
> > > qpw_queue_for(write_A, 1)
> > >     queue_work_on(write_A, CPU 1)
> > > qpw_unlock(CPU 1)
> > >     local_unlock(&QPW_CPU0)
> > >                                                    // workqueue
> > >                                                    write_A()
> > >                                                        qpw_lock(CPU 1)
> > >                                                            local_lock(&QPW_CPU1)
> > >                                                        A1 = per_cpu_ptr(&A, 1)
> > >                                                        *A1 = 1
> > >                                                        qpw_unlock(CPU 1)
> > >                                                            local_unlock(&QPW_CPU1)
> > > 
> > >                                                    read_A()
> > >                                                        qpw_lock(CPU 1)
> > >                                                            local_lock(&QPW_CPU1)
> > >                                                        r0 = __this_cpu_read(&A)
> > >                                                        qpw_unlock(CPU 1)
> > >                                                            local_unlock(&QPW_CPU1)
> > > 
> > > Here CPU 0 queues the work on CPU 1 which writes and reads the new value
> > > (r0 == 1). local_lock() / preempt_disable() makes sure the CPU doesn't change.
> > > 
> > > But what is the point in doing local_lock(&QPW_CPU0) on CPU 0 ?
> > 
> > I can't see the case where one would need to hold the qpw_lock while 
> > calling queue_percpu_work_on(). Holding the qpw_lock() (as is the case of
> > local_lock()) should be done only when one is working on data particular to 
> > that cpu structures. Queuing work on other CPU while touching this cpu data 
> > is unexpected to me.
> 
> Yep!
> 
> > > > > Like Vlastimil suggested, it would be better to just have it off by default
> > > > > and turn it on only if nohz_full= is passed. Then we can consider introducing
> > > > > the parameter later if the need arise.
> > > > 
> > > > I agree with having it enabled with isolcpus/nohz_full, but I would 
> > > > recommend having this option anyway, as the user could disable qpw if 
> > > > wanted, or enable outside isolcpu scenarios for any reason.
> > > 
> > > Do you know any such users? Or suspect a potential usecase? If not we can still
> > > add that option later. It's probably better than sticking with a useless
> > > parameter that we'll have to maintain forever.
> > 
> > Out of my head, I can think only on HPC scenario where user wants to make 
> > use of the regular/RT scheduler for many small workloads, but doesn't like 
> > the impact of IPI on those cases.
> 
> There are many more IPIs to care about then. I suspect the issue would be more
> about the workqueue itself.

There are some mechanisms for workqueues to be offloaded to other CPUs if 
those are isolated, we could easily mimic that if wanted (or use isolcpus)

It's more about the locking strategies: some code uses local_lock + 
queue_work_on() and it is really effective in a lot of scenarios, but that 
relies on IPIs which can be terrible in other scenarios.

QPW is about letting user decide which locking strategy to use based on 
it's workloads :)
 
> > Such systems that explore memory at it's 
> > limit will also benefit from those, for example, if cache gets drained 
> > remotely very often.
> > 
> > None of those necessarily will need to or benefit from isolcpus, and may 
> > want to just use the kernel scheduler policies.
> 
> This sounds like "just in case" usecases that could be dealt with later if
> needed. But like Marcelo said, those who want to rely on cpuset isolated
> partitions would need to enable that on boot.
> 

Agree, he could exemplify much better :)

> > > > QPW comes from Queue PerCPU Work
> > > > Having it called qpw_queue_work_{on,for}() would be repetitve
> > > 
> > > Well, qpw_ just becomes the name of the subsystem and its prefix for APIs.
> > > For example qpw_lock() doesn't mean that we queue and lock, it only means we lock.
> > > 
> > 
> > Locks for queue'ing per-cpu work. :D
> 
> Right!
> 
> > 
> > > > But having qpw_on() or qpw_for() would be misleading :) 
> > > > 
> > > > That's why I went with queue_percpu_work_on() based on how we have the 
> > > > original function (queue_work_on) being called.
> > > 
> > > That's much more misleading at it doesn't refer to qpw at all and it only
> > > suggest that it's a queueing a per-cpu workqueue.
> > > 
> > 
> > Humm, maybe qpw_queue_for/on()?
> > 
> > Or maybe change the name of the API for pw:
> > pw_lock()/unlock
> > pw_queue();
> > pw_flush()
> > 
> > and so on?
> > 
> > That way it stays true to what means :)
> 
> Would better to keep the same prefix for all APIs :-)
> 

Naming was always hard with this mechanism :D

Will try to come with something meaningful and consistent across this and 
other APIs.

Thanks!
Leo

