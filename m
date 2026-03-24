Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0E5F532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DBCF6B00A0; Mon, 23 Mar 2026 20:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C0B6B00A2; Mon, 23 Mar 2026 20:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A6C6B00A4; Mon, 23 Mar 2026 20:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3476C6B00A0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:38:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1F88140E0D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:38:47 +0000 (UTC)
X-FDA: 84579096294.26.E6F0E60
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA6704000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:38:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RLJoMchi;
	spf=pass (imf27.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774312725; a=rsa-sha256;
	cv=none;
	b=XgARiPPAq/K2rzC8T3Igu97x4rTF/dWXp6GcFO2d4OXKwQi6lT6sNk9Qiauhnq74yDJ2gN
	7lmAJaUIRog7L4r/VjBf+Ba0cUfI7J328sKDOwZVF3QaXb7r6CpUTDPVf3Z3hsEgAC8ynv
	oJkcQryRdmAoFBNIcbRL5SJKJ6udZW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774312725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8Fgds8o/HF7x3RJydQeNzUk7oi06BCIPFOXT38dGlU=;
	b=7URwgmFWC5uRp59SPSI8YgaAl5x+kEjVP1jbi1DOWKseBt3ZcPAxnxnmpt9v2cMDBRnQFi
	hSGf5+YiYga0AsHsK0POtXNMKAiqgtdYV/ykdRYvdhKbMwj7IP76xam2RdK/4NTr24w+dO
	0fhqorv5R1Xivn4jHFRu6+Zn5PJUKtg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RLJoMchi;
	spf=pass (imf27.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-486fd5360d4so7688215e9.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774312724; x=1774917524; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L8Fgds8o/HF7x3RJydQeNzUk7oi06BCIPFOXT38dGlU=;
        b=RLJoMchiQ4TTI7IdcH9YarfRFDw3+wut+ZTLXKEnTks0h+2jzgfFjfqt/D0OdE4LrO
         9z1uQSc1DOCCC2d0hbyCQrl6ibV3g2Qxz0wrqLslLG42UWa3SPsE4NRCWBEEaq1hN4Pg
         HM1PwJVxbjITMnx/pS/D0xo+dp4LvO5HGDU318TYSdHwaz7AVbNtJKtm68We1Hr0Zw8T
         4Wy193B9IYvCdiBFZa/B8zoZUPka2zh5iWY2DS/jEFTkrpLHuGbmp2Me6ZZnAVLvynbJ
         McXd278WmKh9G2BZqwGyI4Sli44KsyeAr0alVhLIP21PUzAFVfW5ESo/Y0OMV0i2/Jk+
         EztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774312724; x=1774917524;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L8Fgds8o/HF7x3RJydQeNzUk7oi06BCIPFOXT38dGlU=;
        b=TCvshDp8PDPXs3DCo0ayC1mO6/GY0SrdtouTGxGD8dx8x0Ti2dfL/2AHdtsNt8oSSR
         +KuYHHBBKGAe1nUON8o1d4yBK6KZKkb9fcQSsY3LUZP7DZifuknEN6PdpDjon8LFXlnf
         pS+/h1SNcKWpF/ucthd4hluWfq2No8hDMj311zI0akIdbVtiiySl13Wz8P306tpkG9lJ
         G1j1NuqaNHLroQEEjjYJDm/3JnqrdzJ+ckcY7+8tHwa687AuhI2mrTfudMXZhLc51eAg
         KRajabb6zOHd/Fh4GpAdRmXzkns2TjWpXvWm4jMa3N2CBH3q2JltzoO/+NHNeboeKuOQ
         S/Ww==
X-Forwarded-Encrypted: i=1; AJvYcCVxUOAtx/cAuoTAWTa+c+NH8XWYe3F5lqRQ3PDrPWIfvKxIvbmdiv7igs4aUPLc5zFhKR54HYx2xw==@kvack.org
X-Gm-Message-State: AOJu0Ywd47/bHCWCDlcwJWqLUieZ2K2Wv+te7aIfwOk58nivfWhm/FQc
	XMOhG0kbPcJawRrnEDl6oG+Y7olr9lrvNUkdWNLcLC7wFrA6nE24doSY
X-Gm-Gg: ATEYQzwtKfFfz8iG9xCUcRRCjaZmPRgP/DjMLvjRhsaZpMo4F17BUO6X2jvd9RQ2J0g
	BD2Si5iRe0AyOu7L6KSwih/M/x+Xpjyr9eAl+A/IIf5sKilFufBVe938Hm7Lz02SVsXGfwWe1w3
	J1Fm8Gjg8RKEqjUQ8XjqtnaE9Rx7oZ6rKIhkYbOM/l/BTZISgo1eeD0/at4A7M90cyhrCKs1jfn
	x362oaqoKTAYXM9M1AhK8pts0+O9SXy2iiENVm8zw90fOaKsr+rGIL4snPm45JzbGmCprGoII1a
	QGIar10ffIfMEVrO28+xa0Bo158dkXNPBu6ex6C30DDx1zjU3wbE0Lpphw/R/9UsPeyVUK6guGQ
	1az1vrr0cl0COSXN0DVcLDVgDugOXSFkUa0Q/bfPYrobJowJFE2ote3s3Zr24GiGOLeRaZEVEc3
	iq3+jWcBpNo6KVjLYag9mv4bHmhWoX6bHn8R8=
X-Received: by 2002:a05:600c:c167:b0:483:9139:4c1d with SMTP id 5b1f17b1804b1-486fedd4143mr191783925e9.14.1774312723636;
        Mon, 23 Mar 2026 17:38:43 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487116abecesm8709775e9.5.2026.03.23.17.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 17:38:42 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
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
	Boqun Feun <boqun.feng@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH v3 1/4] Introducing qpw_lock() and per-cpu queue & flush work
Date: Mon, 23 Mar 2026 21:38:37 -0300
Message-ID: <acHdDFapv_RIPjQB@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323180150.242567098@redhat.com>
References: <20260323175544.807534301@redhat.com> <20260323180150.242567098@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA6704000C
X-Stat-Signature: jradcbmx39fbkts7d69yz7ua9fj51mwb
X-HE-Tag: 1774312725-81895
X-HE-Meta: U2FsdGVkX1/TE09ZiN1tkPO/ouck7p8TE+CBlQ7YHh/m8gAgcEmSw1P1yOV48XRUT/E3n0fo4FB+1tZyci2EIOWxhAu2NphoVkHYhoDChW/sf8nrxVh5yOLYr3Q8itfkv/pfC63UzENRbrY1DxJRP/QIygvWiUQ/BQQ8caDh6/CGi90DkfLyIyxP8juAz7IMi+8hUgiwPP9T1bVyrZ9FvS+dWv968bnHsiYLXxZpddPHji9u42yJVKgMx8eP0wqMwkJZ20GcaJEYcHYFZ4QkfCDX1XBrhe7oDljXoed6FBNKUlALpuoJav4JaHk5vYzl70lIJOPDjNRyDvuSHXwYdRNDqDyNsKh3VjV1g3+dT3Fp8c4qmRlXE5wyExK91p46H/IrHvDuW9yS98s79qtdeVI/eyHxS8ya5IbbAb75lOT0TFFmBCk1ceEW9qejD9pAAGPx8veAmc9M3c1PJjqSrExHHE1gDgKw4qm/oVBWKXdXmDF6tgbZeTfTra1+7/zXSWE177rITlBrHgXpGwrkszD/LHxRLkWgNvUA8DHSmp9mPDDZrz5cBaO4b1K1980NljGdSlJISzv71x+nkDtGYc0pf87zrnzwF8O+a4ZRn2f3h9WlevJiY+h+0aXl2wjIEDXCFo0fwZHP/MB56L5yIUPRtutNxWa6mtSMl9xvVhRS3gb6bgF2x15jG3UcisjW0krVhgBZCaVSB7PpB5wX5kv+N0sw92phpGYtKLNRHkjQ5RKARuEVUjUS/wSq5zwC3k3uNbjtB7hCJ0CbWDfqoxvBYT3OJs5Fh+UqWxum/SWEV4Zljx9w3ZCyAQ2ZVwoGP8eG8XBOelnjLlpKNuv2OuKxvOsjz6+P0aGBQ4yASuW2CKKaDbnD7WvUbmJBbbflKv8lRguaas+F99nI7G/1CmE3s9euB0dgxjuzm97f4PnIUsBOkWuKuCTkryMx6GwFVhei/2n/utfmEDPsj5H
 a5Nz8EI7
 3TffdciNhVx3MYdUoKDAJLcyGpQsiTajAocy827FWM41oSmGVtFsmcHWIdpOJSDD/tHVg3oQz8zdCEBWb/pWPBUltck63zfuQoFvUr2VrzOtzgzZbsXf9XALNv99/kR2T8yIehZymKwOYPRSKNPOmFF+G7aAfkGJ7gLOwxGLgwahM2/6rIFsS1B/qt9jkFB6IV5IacpJKUK5o8EsPFd6w9XWQ+kOSbEr6lAHnxBnGq0IIydNe12Vyy7bPXUzsSmbmoYZKxgBHOqYyNc4X9JeOeW4kLNybkVZxHzjYRtJklKTYJbfvVjhh2lmnc9LGjUq3WsUTx3ksCDYx4fjvcHsZs3OpAHAz+RZXmCL6GIl853xu035R92gk9lx26xSnpG0mauQbZcE2gd91Z0Q6xXPiHUbphVYyfvEo4sXtEqjxOuwvxwEN+/NOXrkt0gO+vAZnsRvG8Qx+W7AxmmOhj6GkEJoDiRhLqyV1WMp8OsE7ONTJF/hFXoUUitnT4yRe9yvpVzlqdUi8kA+Q6DveUjYbOMWBun7B24OxJzZI29lrBWHC5QqkRQVbXFhYhpB5ojqfmVJNHDSho6RE2B3jO5DVhJL/zBgce6RpT0qy2n0lUqLDshVpPzFs594+K8cFytNZAcl3YnjteZ5VQ8TfvRnOM3DRzJa72Kd90EIL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 02:55:45PM -0300, Marcelo Tosatti wrote:
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
> Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |   10 
>  Documentation/locking/qpwlocks.rst              |   70 ++++++
>  MAINTAINERS                                     |    7 
>  include/linux/qpw.h                             |  256 ++++++++++++++++++++++++
>  init/Kconfig                                    |   35 +++
>  kernel/Makefile                                 |    2 
>  kernel/qpw.c                                    |   26 ++
>  7 files changed, 406 insertions(+)
>  create mode 100644 include/linux/qpw.h
>  create mode 100644 kernel/qpw.c
> 
> Index: linux/Documentation/admin-guide/kernel-parameters.txt
> ===================================================================
> --- linux.orig/Documentation/admin-guide/kernel-parameters.txt
> +++ linux/Documentation/admin-guide/kernel-parameters.txt
> @@ -2841,6 +2841,16 @@ Kernel parameters
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
> Index: linux/MAINTAINERS
> ===================================================================
> --- linux.orig/MAINTAINERS
> +++ linux/MAINTAINERS
> @@ -21536,6 +21536,13 @@ F:	Documentation/networking/device_drive
>  F:	drivers/bus/fsl-mc/
>  F:	include/uapi/linux/fsl_mc.h
>  
> +QPW
> +M:	Leonardo Bras <leobras.c@gmail.com>
> +S:	Supported
> +F:	Documentation/locking/qpwlocks.rst
> +F:	include/linux/qpw.h
> +F:	kernel/qpw.c
> +
>  QT1010 MEDIA DRIVER
>  L:	linux-media@vger.kernel.org
>  S:	Orphan
> Index: linux/include/linux/qpw.h
> ===================================================================
> --- /dev/null
> +++ linux/include/linux/qpw.h
> @@ -0,0 +1,264 @@
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
> +#define qpw_lock_init(lock)				\
> +	local_lock_init(lock)
> +
> +#define qpw_trylock_init(lock)				\
> +	local_trylock_init(lock)
> +
> +#define qpw_lock(lock, cpu)				\
> +	local_lock(lock)
> +
> +#define local_qpw_lock(lock)				\
> +	local_lock(lock)
> +
> +#define qpw_lock_irqsave(lock, flags, cpu)		\
> +	local_lock_irqsave(lock, flags)
> +
> +#define local_qpw_lock_irqsave(lock, flags)		\
> +	local_lock_irqsave(lock, flags)
> +
> +#define qpw_trylock(lock, cpu)				\
> +	local_trylock(lock)
> +
> +#define local_qpw_trylock(lock)				\
> +	local_trylock(lock)
> +
> +#define qpw_trylock_irqsave(lock, flags, cpu)		\
> +	local_trylock_irqsave(lock, flags)
> +
> +#define qpw_unlock(lock, cpu)				\
> +	local_unlock(lock)
> +
> +#define local_qpw_unlock(lock)				\
> +	local_unlock(lock)
> +
> +#define qpw_unlock_irqrestore(lock, flags, cpu)		\
> +	local_unlock_irqrestore(lock, flags)
> +
> +#define local_qpw_unlock_irqrestore(lock, flags)	\
> +	local_unlock_irqrestore(lock, flags)
> +
> +#define qpw_lockdep_assert_held(lock)			\
> +	lockdep_assert_held(lock)
> +
> +#define queue_percpu_work_on(c, wq, qpw)		\
> +	queue_work_on(c, wq, &(qpw)->work)
> +
> +#define flush_percpu_work(qpw)				\
> +	flush_work(&(qpw)->work)
> +
> +#define qpw_get_cpu(qpw)	smp_processor_id()
> +
> +#define qpw_is_cpu_remote(cpu)		(false)
> +
> +#define INIT_QPW(qpw, func, c)				\
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
> +#ifdef CONFIG_PREEMPT_RT
> +#define preempt_or_migrate_disable migrate_disable
> +#define preempt_or_migrate_enable migrate_enable
> +#else
> +#define preempt_or_migrate_disable preempt_disable
> +#define preempt_or_migrate_enable preempt_enable
> +#endif

Nice!

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
> +#define local_qpw_lock(lock)								\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> +			preempt_or_migrate_disable();					\
> +			spin_lock(this_cpu_ptr(lock.sl));				\
> +		} else									\
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
> +#define local_qpw_lock_irqsave(lock, flags)						\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> +			preempt_or_migrate_disable();					\
> +			spin_lock_irqsave(this_cpu_ptr(lock.sl), flags);		\
> +		} else									\
> +			local_lock_irqsave(lock.ll, flags);				\
> +	} while (0)
> +
> +
> +#define qpw_trylock(lock, cpu)                                                          \
> +	({                                                                              \
> +		int t;                                                                  \
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))                   \
> +			t = spin_trylock(per_cpu_ptr(lock.sl, cpu));                    \
> +		else                                                                    \
> +			t = local_trylock(lock.ll);                                     \
> +		t;                                                                      \
> +	})
> +
> +#define local_qpw_trylock(lock)								\
> +	({										\
> +		int t;									\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> +			preempt_or_migrate_disable();					\
> +			t = spin_trylock(this_cpu_ptr(lock.sl));			\
> +			if (!t)								\
> +				preempt_or_migrate_enable();				\
> +		} else									\
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
> +#define local_qpw_unlock(lock)								\
> +do {										\
> +	if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> +		spin_unlock(this_cpu_ptr(lock.sl));				\
> +		preempt_or_migrate_enable();					\
> +	} else {								\
> +		local_unlock(lock.ll);						\
> +	}									\
> +} while (0)
> +
> +#define qpw_unlock_irqrestore(lock, flags, cpu)						\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
> +			spin_unlock_irqrestore(per_cpu_ptr(lock.sl, cpu), flags);	\
> +		else									\
> +			local_unlock_irqrestore(lock.ll, flags);			\
> +	} while (0)
> +
> +#define local_qpw_unlock_irqrestore(lock, flags)					\
> +	do {										\
> +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> +			spin_unlock_irqrestore(this_cpu_ptr(lock.sl), flags);		\
> +			preempt_or_migrate_enable();					\
> +		} else									\
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
> Index: linux/init/Kconfig
> ===================================================================
> --- linux.orig/init/Kconfig
> +++ linux/init/Kconfig
> @@ -762,6 +762,41 @@ config CPU_ISOLATION
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
> Index: linux/kernel/Makefile
> ===================================================================
> --- linux.orig/kernel/Makefile
> +++ linux/kernel/Makefile
> @@ -142,6 +142,8 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue
>  obj-$(CONFIG_RESOURCE_KUNIT_TEST) += resource_kunit.o
>  obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
>  
> +obj-$(CONFIG_QPW) += qpw.o
> +
>  CFLAGS_kstack_erase.o += $(DISABLE_KSTACK_ERASE)
>  CFLAGS_kstack_erase.o += $(call cc-option,-mgeneral-regs-only)
>  obj-$(CONFIG_KSTACK_ERASE) += kstack_erase.o
> Index: linux/kernel/qpw.c
> ===================================================================
> --- /dev/null
> +++ linux/kernel/qpw.c
> @@ -0,0 +1,47 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "linux/export.h"
> +#include <linux/sched.h>
> +#include <linux/qpw.h>
> +#include <linux/string.h>
> +#include <linux/sched/isolation.h>
> +
> +DEFINE_STATIC_KEY_MAYBE(CONFIG_QPW_DEFAULT, qpw_sl);
> +EXPORT_SYMBOL(qpw_sl);
> +
> +static bool qpw_param_specified;
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
> +	qpw_param_specified = true;
> +
> +	return 1;
> +}
> +__setup("qpw=", qpw_setup);
> +
> +/*
> + * Enable QPW if CPUs want to avoid kernel noise.
> + */
> +static int __init qpw_init(void)
> +{
> +	if (qpw_param_specified == true)
> +		return 0;
> +
> +	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
> +		static_branch_enable(&qpw_sl);
> +
> +	return 0;
> +}
> +
> +late_initcall(qpw_init);

Awesome! Clean and efficient!

> Index: linux/Documentation/locking/qpwlocks.rst
> ===================================================================
> --- /dev/null
> +++ linux/Documentation/locking/qpwlocks.rst
> @@ -0,0 +1,76 @@
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
> +* !CONFIG_QPW (or CONFIG_QPW and qpw=off kernel boot parameter):
> +        - qpw_lock:                     local_lock
> +        - qpw_lock_irqsave:             local_lock_irqsave
> +        - qpw_trylock:                  local_trylock
> +        - qpw_trylock_irqsave:          local_trylock_irqsave
> +        - qpw_unlock:                   local_unlock
> +        - local_qpw_lock:               local_lock
> +        - local_qpw_trylock:            local_trylock
> +        - local_qpw_unlock:             local_unlock
> +        - queue_percpu_work_on:         queue_work_on
> +        - flush_percpu_work:            flush_work
> +
> +* CONFIG_QPW (and CONFIG_QPW_DEFAULT=y or qpw=on kernel boot parameter),
> +        - qpw_lock:                     spin_lock
> +        - qpw_lock_irqsave:             spin_lock_irqsave
> +        - qpw_trylock:                  spin_trylock
> +        - qpw_trylock_irqsave:          spin_trylock_irqsave
> +        - qpw_unlock:                   spin_unlock
> +        - local_qpw_lock:               preempt_disable OR migrate_disable + spin_lock
> +        - local_qpw_trylock:            preempt_disable OR migrate_disable + spin_trylock
> +        - local_qpw_unlock:             preempt_enable OR migrate_enable + spin_unlock
> +        - queue_percpu_work_on:         executes work function on caller cpu
> +        - flush_percpu_work:            empty
> +
> +qpw_get_cpu(work_struct), to be called from within qpw work function,
> +returns the target cpu.
> +
> +In addition to the locking functions above, there are the local locking
> +functions (local_qpw_lock, local_qpw_trylock and local_qpw_unlock).
> +These must only be used to access per-CPU data from the CPU that owns
> +that data, and not remotely. They disable preemption or migration
> +and don't require a cpu parameter.
> +
> +These should only be used when accessing per-CPU data of the local CPU.
> +


Awesome!

Thanks for this new version Marcelo!
Leo

