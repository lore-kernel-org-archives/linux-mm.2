Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50C2EE6B66
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 00:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2E86B0089; Fri,  6 Feb 2026 19:16:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50866B0092; Fri,  6 Feb 2026 19:16:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA7D6B0093; Fri,  6 Feb 2026 19:16:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9856B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:16:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41CA4B812B
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 00:16:47 +0000 (UTC)
X-FDA: 84415744854.29.2E67560
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 35DDF40009
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 00:16:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fWV5nYtC;
	spf=pass (imf04.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770423405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S16TdP4xo/UiX5O2RhDUbDO+zFUwSMyLxrLuBL92rRI=;
	b=PW8QAD0ZoRjeun7Bhr/qOhqUJwWOQQYDa+TA3UtNFScZ/EAWkopAehbeUCr9hcsfOwlZUi
	MpQOJfrMJkz3MGDpeog94DPa4raXRzN+dDqcmlVa2tEbe57e+iU7EDns2A4I3zntR5u+/x
	ZHLc539yZHqctzPK+jCwure2t3EhmmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770423405; a=rsa-sha256;
	cv=none;
	b=O2XKTZoHx7xs932wd6FejQtkxS1baJptia2PYndCywqqeAzknrd3YSGaTkj3UUMomNGE/3
	hQfmNCBrsDgXjdAi6YkX2xDLgpdU9x8iPR4uK1TMrFeXRghag94lpK0FIsBZX+2RdAlWxg
	QbnptYq7Z8T76uTshqqTMtCqq9avG8Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fWV5nYtC;
	spf=pass (imf04.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4806f9e61f9so15914665e9.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 16:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770423403; x=1771028203; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S16TdP4xo/UiX5O2RhDUbDO+zFUwSMyLxrLuBL92rRI=;
        b=fWV5nYtCPLHXuyinlHaSL8Asu1rg+moetiUYKm+x0xQfxAqk0EzLRVjHXWiVoCLusy
         Ga6vn917HyvDKoU/2kaHpth2OYnnK9Zq5N8mY5Ws60CtDOa4+/XZmvL6vGeKJ63B6x66
         lxuYdgFdLPQdaS/tCeP8QMLvkd0FwzjqYFjr+aUVMmy8C7ov3i1xzebWqMtfC01DkxDF
         RxW9vRO6SOUkFIGuxTEqqYcUAXu6g9NiwYrZkB+M1ZHxGWSd2P7+wip6WIKXB6AqdhCI
         LG/h7vY5nQl0r1FiSMeSBa19JmauTOhYu80BHDbUgbPXxqgu6imLvYCXHWZd5JqdNu/B
         +Obw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770423403; x=1771028203;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S16TdP4xo/UiX5O2RhDUbDO+zFUwSMyLxrLuBL92rRI=;
        b=DagVm1O9XhZ1aLxX4XihCvE5/P7WDVv06XdMojv6YtKmayGmqgImrg/sLgjPWJOQWd
         RGWBP9O6/Nvkgcxgh6OVyjKgnWZEY/nbazH+FVCpdthdg3QiXg4Kvr7wyK/7sk5vIlLf
         IV2yURzkVsouP1xrEezb4dfqY7QEnptElrmXtoVzo1kpew97hUOlliDaZwatNIUDgTCH
         cRt1khwFWyDiVV3LFirt/ONJKNmDoP2r3CyipsslCkMFNA61mz6Pp+Ntikokp/wucxcQ
         dwcEsn4qpJdR1nREO3RPSWcEaMGx1FYKHCrZ9Dwn/9Bq3XCAEdThNBGO/zgjf6XjZRRJ
         nfUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJntiItPXaO7Ea4ZswEOrlxybyFECo3BkXfxPoCowT7vM8fcYRR7ZOMmI22tHSUvLIYE/FzyL30A==@kvack.org
X-Gm-Message-State: AOJu0Yw5xqC7WpuB5GkK/Y1pd7wO/Uji6GJf8cR3yksrVa1njsbaSfh5
	Evv4N3i4nnbYFkivbzyf8UIP5FLwFLX8QUBBtWCUyrQL6YWzACQEzlLK
X-Gm-Gg: AZuq6aJWs7NQ8KXjfE8ZqPwuhCfsq7Mx3RgSPO5nxTRxQeKbgcUVStzSXazsVr9YlKf
	CfDhzFHcmNyxKf2t9QXsiZ5qg7ck6gIGgMhVvnrKwoRB+0qx40ChsQmANmurH/eK6KwSlD8nObj
	MWSfNkNauBhSQAqHd1jIWhVpaIGUkbyJilTpRTNN7RF6N5TQfw/23hzwJ41/6L7rm+A4iz5e7Yu
	mCxMgiXU27E1TZFB50L75ulbE/h8ofFHdcfpWJ6a+eDAOdRsror3WuPcqtQLyBBAjbNgLsRf4gY
	sjomlo2z5w6vXJQtLGCT0d+/weKIUvkQT8JOS48JH18EmnGp/58jmWzZ5phWnlhcgQ65MnpOckg
	1PWN7Y53Szx2/CLYdJ+V7lrgZVAswE+MIvV0JlbIT38W3FbJf4nlv5U/P3Hd7M1KU9u2QCDA1pW
	kQCwPBMBQkW9dZ/AaahA7DJmRb5ld4VsF9+w==
X-Received: by 2002:a05:600c:c16d:b0:480:4a90:1b00 with SMTP id 5b1f17b1804b1-4832021605bmr52766175e9.20.1770423403305;
        Fri, 06 Feb 2026 16:16:43 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48320983f18sm42686405e9.8.2026.02.06.16.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 16:16:42 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
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
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 1/4] Introducing qpw_lock() and per-cpu queue & flush work
Date: Fri,  6 Feb 2026 21:16:36 -0300
Message-ID: <aYaEZGImn7qayP12@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260206143741.525190180@redhat.com>
References: <20260206143430.021026873@redhat.com> <20260206143741.525190180@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 35DDF40009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gdgo4jfk3666fxwuey35bhj3nxhtpd5s
X-HE-Tag: 1770423404-365596
X-HE-Meta: U2FsdGVkX19+/0RyDTnSno+pOdH/fDkgpqDojxVwQ4M126Nyl5MA0QqGjOfu5SocdKIFBF735Yq3c3DnyE4C8bk3AF3iTzNtbT6042Key4uuah8ehKnt15pQ1Cqcat5wmFjIpwI+o93cd79xlHInCbVLS2Ae1OAyLaf3G6AXC2Tch4kaqJipYkNJSYBsb5QECazY1Q6LccDW+vrulp0RHrMsaJbD5Iwz4qsKebMpBhb9wi3qx2RDbn0lMeoMssRIy5E1OfsXtiuSeccJQznFKgvakVv81TvBobQ6z8h5y0J5YLoKMmDL9ZRECwWzvmlrRkm34ttyfdnTfODgNglSK8aJi5YxSPgNo75wTM7hjEfn6IzlqoFcYVpvCUL4DXlM07jD74CsBH3MpV48VFi4spDwg82SloiMwEUbdIuCO0i1g2aLtIv6Aw+DmquoFlIkQMC8Jro7SaPJwGuUJ3WtnZLsw75ex1OfLpG+tys59fCXu8wsDz2bJEbXVqE9Lal+cgo111Zco2eCg9oAyGMdCewsfl4k9fyGGEV5ZEkWelW9QQZySYykd9h48U0LWJBO0qt+C4payLCzQKWsWfVW+rmGGUvlj8U4Jcq8jgHEQdVXTtW5Vw8jUEtNa03FzHEzQiRDXqGuw1O3w2CNJ8HjTGz4NonA5qZL/xgc0iJ+ndroIL/JtAKkcv+UHgIKDa/0EmCNfR5sZZnAFLVmYu1WYUK9WNIWRZQ4pNLAHarskj8jPKM1CwCB3qYYpKCcV6P+8iXFxDlT9zaJ+pbzbR+Oc+cZqy8BbDMEGusAJ+rpnOhJPZo8FFlDZWZrxhDab4nTEetkoBL3220vD+LTLn/zntw8AVKHuMaM+/Qrqy1OWLZM53cUbabqeA1sDDky87T8Cieiv+o5hW4fmRdF1nI4bZbGIWLNw40a6Ica/ZyRwuPIrYP5rHqvs9wB0zdagoGLHQl+kvQVqPqsrNjuJmE
 aTV11j0+
 dJ0SQL62bEFjpDNF0+yX6Me/tfeR1tCf4CZsjUCr6K2Nmg1yEgppTeGFqEvKWw21BWKPxZR1VKDEE2TCmvMd1mIZSc/obywXR0qQuh7Clp9pTbTmbqPS96V/KztW2S5ozO7zxahpgmf608+5J1q633dAcT52NQddAXezYgrzdPTVSebZqHtybQsW2/JxrjNKSD909L+gHDDyloQrbw6K/wmKegCUilCsIsRA1r7XbSHoxCZYLO5WIKGtBCy7/jYNl7+08EYEDjoW4ANwXmAZHYklOwKHuBjLdgNCE/y6I5lPeZzJmRzCVTtoO7MBPkhsThdHyYAqKom17H3RJsilsDs8YrFYfJH1ZHSaHD/ZqS6cgIRmuDVvROxhkiqyLKBfASwXJ/S8at+5J5sYTNCC/oiVUkOs9GVNqORgFMiYZ7iGFMgmvYIQ9HDWhTO4dA6FIyGA3PhjfGrNjDvzIuR1//2RP2nz7jxxAWUChTr3xe2y018SPRkC8cbkxYVk3rekI58TXf4slByD+s+fbmFxmHFiim4bUAKhr5YTo8r3ZiU2u8czhmhoN8JfO+dM/EZL7WqWD9G5In86+WZko9w4PAhe/vG321pY9s+qtiDqlrU9W2vibacdsDyyyaOqbcXo1W9DE/uaI/cUeIp9HKNL4TrKjYR5SHjEz+oWe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:34:31AM -0300, Marcelo Tosatti wrote:
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem:
> scheduling work on remote cpu that are executing low latency tasks
> is undesired and can introduce unexpected deadline misses.
> 
> It's interesting, though, that local_lock()s in RT kernels become
> spinlock(). We can make use of those to avoid scheduling work on a remote
> cpu by directly updating another cpu's per_cpu structure, while holding
> it's spinlock().
> 
> In order to do that, it's necessary to introduce a new set of functions to
> make it possible to get another cpu's per-cpu "local" lock (qpw_{un,}lock*)
> and also the corresponding queue_percpu_work_on() and flush_percpu_work()
> helpers to run the remote work.
> 
> Users of non-RT kernels but with low latency requirements can select
> similar functionality by using the CONFIG_QPW compile time option.
> 
> On CONFIG_QPW disabled kernels, no changes are expected, as every
> one of the introduced helpers work the exactly same as the current
> implementation:
> qpw_{un,}lock*()        ->  local_{un,}lock*() (ignores cpu parameter)
> queue_percpu_work_on()  ->  queue_work_on()
> flush_percpu_work()     ->  flush_work()
> 
> For QPW enabled kernels, though, qpw_{un,}lock*() will use the extra
> cpu parameter to select the correct per-cpu structure to work on,
> and acquire the spinlock for that cpu.
> 
> queue_percpu_work_on() will just call the requested function in the current
> cpu, which will operate in another cpu's per-cpu object. Since the
> local_locks() become spinlock()s in QPW enabled kernels, we are
> safe doing that.
> 
> flush_percpu_work() then becomes a no-op since no work is actually
> scheduled on a remote cpu.
> 
> Some minimal code rework is needed in order to make this mechanism work:
> The calls for local_{un,}lock*() on the functions that are currently
> scheduled on remote cpus need to be replaced by qpw_{un,}lock_n*(), so in
> QPW enabled kernels they can reference a different cpu. It's also
> necessary to use a qpw_struct instead of a work_struct, but it just
> contains a work struct and, in CONFIG_QPW, the target cpu.
> 
> This should have almost no impact on non-CONFIG_QPW kernels: few
> this_cpu_ptr() will become per_cpu_ptr(,smp_processor_id()).
> 
> On CONFIG_QPW kernels, this should avoid deadlines misses by
> removing scheduling noise.
> 
> Signed-off-by: Leonardo Bras <leobras@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |   10 +
>  Documentation/locking/qpwlocks.rst              |   63 +++++++
>  MAINTAINERS                                     |    6 
>  include/linux/qpw.h                             |  190 ++++++++++++++++++++++++
>  init/Kconfig                                    |   35 ++++
>  kernel/Makefile                                 |    2 
>  kernel/qpw.c                                    |   26 +++
>  7 files changed, 332 insertions(+)
>  create mode 100644 include/linux/qpw.h
>  create mode 100644 kernel/qpw.c
> 
> Index: slab/Documentation/admin-guide/kernel-parameters.txt
> ===================================================================
> --- slab.orig/Documentation/admin-guide/kernel-parameters.txt
> +++ slab/Documentation/admin-guide/kernel-parameters.txt
> @@ -2819,6 +2819,16 @@ Kernel parameters
>  
>  			The format of <cpu-list> is described above.
>  
> +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> +			and remote interference mechanism on a kernel built with
> +			CONFIG_QPW.
> +			Format: { "0" | "1" }
> +			0 - local_lock() + queue_work_on(remote_cpu)
> +			1 - spin_lock() for both local and remote operations
> +
> +			Selecting 1 may be interesting for systems that want
> +			to avoid interruption & context switches from IPIs.
> +
>  	iucv=		[HW,NET]
>  
>  	ivrs_ioapic	[HW,X86-64]
> Index: slab/MAINTAINERS
> ===================================================================
> --- slab.orig/MAINTAINERS
> +++ slab/MAINTAINERS
> @@ -21291,6 +21291,12 @@ F:	Documentation/networking/device_drive
>  F:	drivers/bus/fsl-mc/
>  F:	include/uapi/linux/fsl_mc.h
>  
> +QPW
> +M:	Leonardo Bras <leobras@redhat.com>

Thanks for keeping that up :)
Could you please change this line to 

+M:	Leonardo Bras <leobras.c@gmail.com>

As I don't have access to Red Hat's mail anymore.
The signoffs on each commit should be fine to keep :)

> +S:	Supported
> +F:	include/linux/qpw.h
> +F:	kernel/qpw.c
> +

Should we also add the Documentation file as well?

+F:	Documentation/locking/qpwlocks.rst


>  QT1010 MEDIA DRIVER
>  L:	linux-media@vger.kernel.org
>  S:	Orphan
> Index: slab/include/linux/qpw.h
> ===================================================================
> --- /dev/null
> +++ slab/include/linux/qpw.h
> @@ -0,0 +1,190 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_QPW_H
> +#define _LINUX_QPW_H
> +
> +#include "linux/spinlock.h"
> +#include "linux/local_lock.h"
> +#include "linux/workqueue.h"
> +
> +#ifndef CONFIG_QPW
> +
> +typedef local_lock_t qpw_lock_t;
> +typedef local_trylock_t qpw_trylock_t;
> +
> +struct qpw_struct {
> +	struct work_struct work;
> +};
> +
> +#define qpw_lock_init(lock)			\
> +	local_lock_init(lock)
> +
> +#define qpw_trylock_init(lock)			\
> +	local_trylock_init(lock)
> +
> +#define qpw_lock(lock, cpu)			\
> +	local_lock(lock)
> +
> +#define qpw_lock_irqsave(lock, flags, cpu)	\
> +	local_lock_irqsave(lock, flags)
> +
> +#define qpw_trylock(lock, cpu)			\
> +	local_trylock(lock)
> +
> +#define qpw_trylock_irqsave(lock, flags, cpu)	\
> +	local_trylock_irqsave(lock, flags)
> +
> +#define qpw_unlock(lock, cpu)			\
> +	local_unlock(lock)
> +
> +#define qpw_unlock_irqrestore(lock, flags, cpu)	\
> +	local_unlock_irqrestore(lock, flags)
> +
> +#define qpw_lockdep_assert_held(lock)		\
> +	lockdep_assert_held(lock)
> +
> +#define queue_percpu_work_on(c, wq, qpw)	\
> +	queue_work_on(c, wq, &(qpw)->work)
> +
> +#define flush_percpu_work(qpw)			\
> +	flush_work(&(qpw)->work)
> +
> +#define qpw_get_cpu(qpw)	smp_processor_id()
> +
> +#define qpw_is_cpu_remote(cpu)		(false)
> +
> +#define INIT_QPW(qpw, func, c)			\
> +	INIT_WORK(&(qpw)->work, (func))
> +
> +#else /* CONFIG_QPW */
> +
> +DECLARE_STATIC_KEY_MAYBE(CONFIG_QPW_DEFAULT, qpw_sl);
> +
> +typedef union {
> +	spinlock_t sl;
> +	local_lock_t ll;
> +} qpw_lock_t;
> +
> +typedef union {
> +	spinlock_t sl;
> +	local_trylock_t ll;
> +} qpw_trylock_t;
> +
> +struct qpw_struct {
> +	struct work_struct work;
> +	int cpu;
> +};
> +
> +#define qpw_lock_init(lock)								\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			spin_lock_init(lock.sl);					\
> +		else									\
> +			local_lock_init(lock.ll);					\
> +	} while (0)
> +
> +#define qpw_trylock_init(lock)								\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			spin_lock_init(lock.sl);					\
> +		else									\
> +			local_trylock_init(lock.ll);					\
> +	} while (0)
> +
> +#define qpw_lock(lock, cpu)								\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			spin_lock(per_cpu_ptr(lock.sl, cpu));				\
> +		else									\
> +			local_lock(lock.ll);						\
> +	} while (0)
> +
> +#define qpw_lock_irqsave(lock, flags, cpu)						\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			spin_lock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);		\
> +		else									\
> +			local_lock_irqsave(lock.ll, flags);				\
> +	} while (0)
> +
> +#define qpw_trylock(lock, cpu)								\
> +	({										\
> +		int t;									\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			t = spin_trylock(per_cpu_ptr(lock.sl, cpu));			\
> +		else									\
> +			t = local_trylock(lock.ll);					\
> +		t;									\
> +	})
> +
> +#define qpw_trylock_irqsave(lock, flags, cpu)						\
> +	({										\
> +		int t;									\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			t = spin_trylock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);	\
> +		else									\
> +			t = local_trylock_irqsave(lock.ll, flags);			\
> +		t;									\
> +	})
> +
> +#define qpw_unlock(lock, cpu)								\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> +			spin_unlock(per_cpu_ptr(lock.sl, cpu));				\
> +		} else {								\
> +			local_unlock(lock.ll);						\
> +		}									\
> +	} while (0)
> +
> +#define qpw_unlock_irqrestore(lock, flags, cpu)						\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			spin_unlock_irqrestore(per_cpu_ptr(lock.sl, cpu), flags);	\
> +		else									\
> +			local_unlock_irqrestore(lock.ll, flags);			\
> +	} while (0)
> +
> +#define qpw_lockdep_assert_held(lock)							\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			lockdep_assert_held(this_cpu_ptr(lock.sl));			\
> +		else									\
> +			lockdep_assert_held(this_cpu_ptr(lock.ll));			\
> +	} while (0)
> +
> +#define queue_percpu_work_on(c, wq, qpw)						\
> +	do {										\
> +		int __c = c;								\
> +		struct qpw_struct *__qpw = (qpw);					\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> +			WARN_ON((__c) != __qpw->cpu);					\
> +			__qpw->work.func(&__qpw->work);					\
> +		} else {								\
> +			queue_work_on(__c, wq, &(__qpw)->work);				\
> +		}									\
> +	} while (0)
> +
> +/*
> + * Does nothing if QPW is set to use spinlock, as the task is already done at the
> + * time queue_percpu_work_on() returns.
> + */
> +#define flush_percpu_work(qpw)								\
> +	do {										\
> +		struct qpw_struct *__qpw = (qpw);					\
> +		if (!static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {		\
> +			flush_work(&__qpw->work);					\
> +		}									\
> +	} while (0)
> +
> +#define qpw_get_cpu(w)			container_of((w), struct qpw_struct, work)->cpu
> +
> +#define qpw_is_cpu_remote(cpu)		((cpu) != smp_processor_id())
> +
> +#define INIT_QPW(qpw, func, c)								\
> +	do {										\
> +		struct qpw_struct *__qpw = (qpw);					\
> +		INIT_WORK(&__qpw->work, (func));					\
> +		__qpw->cpu = (c);							\
> +	} while (0)
> +
> +#endif /* CONFIG_QPW */
> +#endif /* LINUX_QPW_H */
> Index: slab/init/Kconfig
> ===================================================================
> --- slab.orig/init/Kconfig
> +++ slab/init/Kconfig
> @@ -747,6 +747,41 @@ config CPU_ISOLATION
>  
>  	  Say Y if unsure.
>  
> +config QPW
> +	bool "Queue per-CPU Work"
> +	depends on SMP || COMPILE_TEST
> +	default n
> +	help
> +	  Allow changing the behavior on per-CPU resource sharing with cache,
> +	  from the regular local_locks() + queue_work_on(remote_cpu) to using
> +	  per-CPU spinlocks on both local and remote operations.
> +
> +	  This is useful to give user the option on reducing IPIs to CPUs, and
> +	  thus reduce interruptions and context switches. On the other hand, it
> +	  increases generated code and will use atomic operations if spinlocks
> +	  are selected.
> +
> +	  If set, will use the default behavior set in QPW_DEFAULT unless boot
> +	  parameter qpw is passed with a different behavior.
> +
> +	  If unset, will use the local_lock() + queue_work_on() strategy,
> +	  regardless of the boot parameter or QPW_DEFAULT.
> +
> +	  Say N if unsure.
> +
> +config QPW_DEFAULT
> +	bool "Use per-CPU spinlocks by default"
> +	depends on QPW
> +	default n
> +	help
> +	  If set, will use per-CPU spinlocks as default behavior for per-CPU
> +	  remote operations.
> +
> +	  If unset, will use local_lock() + queue_work_on(cpu) as default
> +	  behavior for remote operations.
> +
> +	  Say N if unsure
> +
>  source "kernel/rcu/Kconfig"
>  
>  config IKCONFIG
> Index: slab/kernel/Makefile
> ===================================================================
> --- slab.orig/kernel/Makefile
> +++ slab/kernel/Makefile
> @@ -140,6 +140,8 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue
>  obj-$(CONFIG_RESOURCE_KUNIT_TEST) += resource_kunit.o
>  obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
>  
> +obj-$(CONFIG_QPW) += qpw.o
> +
>  CFLAGS_kstack_erase.o += $(DISABLE_KSTACK_ERASE)
>  CFLAGS_kstack_erase.o += $(call cc-option,-mgeneral-regs-only)
>  obj-$(CONFIG_KSTACK_ERASE) += kstack_erase.o
> Index: slab/kernel/qpw.c
> ===================================================================
> --- /dev/null
> +++ slab/kernel/qpw.c
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "linux/export.h"
> +#include <linux/sched.h>
> +#include <linux/qpw.h>
> +#include <linux/string.h>
> +
> +DEFINE_STATIC_KEY_MAYBE(CONFIG_QPW_DEFAULT, qpw_sl);
> +EXPORT_SYMBOL(qpw_sl);
> +
> +static int __init qpw_setup(char *str)
> +{
> +	int opt;
> +
> +	if (!get_option(&str, &opt)) {
> +		pr_warn("QPW: invalid qpw parameter: %s, ignoring.\n", str);
> +		return 0;
> +	}
> +
> +	if (opt)
> +		static_branch_enable(&qpw_sl);
> +	else
> +		static_branch_disable(&qpw_sl);
> +
> +	return 0;
> +}
> +__setup("qpw=", qpw_setup);
> Index: slab/Documentation/locking/qpwlocks.rst
> ===================================================================
> --- /dev/null
> +++ slab/Documentation/locking/qpwlocks.rst
> @@ -0,0 +1,63 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========
> +QPW locks
> +=========
> +
> +Some places in the kernel implement a parallel programming strategy
> +consisting on local_locks() for most of the work, and some rare remote
> +operations are scheduled on target cpu. This keeps cache bouncing low since
> +cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> +kernels, even though the very few remote operations will be expensive due
> +to scheduling overhead.
> +
> +On the other hand, for RT workloads this can represent a problem:
> +scheduling work on remote cpu that are executing low latency tasks
> +is undesired and can introduce unexpected deadline misses.
> +
> +QPW locks help to convert sites that use local_locks (for cpu local operations)
> +and queue_work_on (for queueing work remotely, to be executed
> +locally on the owner cpu of the lock) to QPW locks.
> +
> +The lock is declared qpw_lock_t type.
> +The lock is initialized with qpw_lock_init.
> +The lock is locked with qpw_lock (takes a lock and cpu as a parameter).
> +The lock is unlocked with qpw_unlock (takes a lock and cpu as a parameter).
> +
> +The qpw_lock_irqsave function disables interrupts and saves current interrupt state,
> +cpu as a parameter.
> +
> +For trylock variant, there is the qpw_trylock_t type, initialized with
> +qpw_trylock_init. Then the corresponding qpw_trylock and
> +qpw_trylock_irqsave.
> +
> +work_struct should be replaced by qpw_struct, which contains a cpu parameter
> +(owner cpu of the lock), initialized by INIT_QPW.
> +
> +The queue work related functions (analogous to queue_work_on and flush_work) are:
> +queue_percpu_work_on and flush_percpu_work.
> +
> +The behaviour of the QPW functions is as follows:
> +
> +* !CONFIG_PREEMPT_RT and !CONFIG_QPW (or CONFIG_QPW and qpw=off kernel

I don't think PREEMPT_RT is needed here (maybe it was copied from the 
previous QPW version which was dependent on PREEMPT_RT?)

> +boot parameter):
> +        - qpw_lock:                     local_lock
> +        - qpw_lock_irqsave:             local_lock_irqsave
> +        - qpw_trylock:                  local_trylock
> +        - qpw_trylock_irqsave:          local_trylock_irqsave
> +        - qpw_unlock:                   local_unlock
> +        - queue_percpu_work_on:         queue_work_on
> +        - flush_percpu_work:            flush_work
> +
> +* CONFIG_PREEMPT_RT or CONFIG_QPW (and CONFIG_QPW_DEFAULT or qpw=on kernel

Same here

> +boot parameter),
> +        - qpw_lock:                     spin_lock
> +        - qpw_lock_irqsave:             spin_lock_irqsave
> +        - qpw_trylock:                  spin_trylock
> +        - qpw_trylock_irqsave:          spin_trylock_irqsave
> +        - qpw_unlock:                   spin_unlock
> +        - queue_percpu_work_on:         executes work function on caller cpu
> +        - flush_percpu_work:            empty
> +
> +qpw_get_cpu(work_struct), to be called from within qpw work function,
> +returns the target cpu.
> 
> 


Other than that, LGTM!

Reviewed-by: Leonardo Bras <leobras.c@gmail.com>

Thanks!
Leo

