Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D480BEA4E24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9276B009E; Mon,  2 Mar 2026 10:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E13C6B00A0; Mon,  2 Mar 2026 10:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850C76B00A1; Mon,  2 Mar 2026 10:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE086B009E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 026FD1A01CB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:38 +0000 (UTC)
X-FDA: 84501568158.03.037599E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 06F5C120005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZBNHOI6i;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=c8Ff9E/yYCuTDlBqHrRgyjN1kyuwiuuy9fAwp4DzOAs=;
	b=Z4WnUFcO4+UZRT8e3IJ00tt5YYV04yBIaQ7CghEFaH+OFQZj7MS4tHXSEmo/drIcJWma9x
	G2AlH5bIdN6RInwsUiBt3AyAOLotvh3OZLJXG8pvK36Ra/e5o9EtKSkigA555RcBSTz4hd
	qrALU+tObT03y2sVum2W4Vs+ass7VXw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466817; a=rsa-sha256;
	cv=none;
	b=Fp5k0p3+45imiiLPQOJpOL4yCNig07MU4MGDrR3ed4d0Vd9sICSR0MHFSV9+hG19FGOt5R
	e4O1yGqUcS0MZyvaXMCyXaOnyOB48vpP+Mk4vRfvTlBnwrAjpaqIk3FANKDfaMwWAMy5m2
	H04hoiw+Vz0pMCX718xrI7ZRBHWpDq4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZBNHOI6i;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=c8Ff9E/yYCuTDlBqHrRgyjN1kyuwiuuy9fAwp4DzOAs=;
	b=ZBNHOI6ix/2fEK27UPfhftREEfycdeYKJCB/mmK+awRsQV5E+P4C2eN9YoLfzzBUGRO7Wv
	Cdk1Ulyaywu/xmwO4w1hkbf9zx53hNUTublE9XF9FNyhsMggWCmFDOVCcOOkhlegjgzrrU
	yyd6zN11RNArFsf12H2AZHFJtKqkfIg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-HhEEhgGyMaGdkol-nmx2ug-1; Mon,
 02 Mar 2026 10:53:30 -0500
X-MC-Unique: HhEEhgGyMaGdkol-nmx2ug-1
X-Mimecast-MFC-AGG-ID: HhEEhgGyMaGdkol-nmx2ug_1772466807
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A6071956056;
	Mon,  2 Mar 2026 15:53:27 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 207F819560A3;
	Mon,  2 Mar 2026 15:53:26 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 9351A401DECF6; Mon,  2 Mar 2026 12:53:00 -0300 (-03)
Message-ID: <20260302155105.214878062@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 02 Mar 2026 12:49:47 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
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
 Leonardo Bras <leobras.c@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>,
 Boqun Feun <boqun.feng@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush work
References: <20260302154945.143996316@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: brKHcfNyc0JTsHLzKOMAsZQFyohNJlKP65FMAjuhhe0_1772466807
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06F5C120005
X-Stat-Signature: 7fjyankmsjgz4kx8meqkhbhqaugkoiie
X-Rspam-User: 
X-HE-Tag: 1772466816-38767
X-HE-Meta: U2FsdGVkX1/lVzgIhiTAB9WjMU9LrnXYMeGVrxUActRdc2SjzNXJu0U1WF4dsuDcD0G8tgUDMKEt0gtOoLcQUThoJi4s3YpNEjS4CXJ1EjaGaSiJv4fhucJX20hAjvBLf+nu3jYOiVBeS/DmMIpKaAzJC9vvyXtxrZ0Kb84v+EhDxS0A/mycOED1rL1HTHAjhCIQQ7XgSyfwM4Ns58DvPCC0APjSf9vfxu97jiP1eftPZl3gUsg8VJqXuzNlBN9BxH1MGCYs49NTL8p/baDm4/Mthaej6J6aLLj8NcJVxU+MJSVl8xTDgFVEPC1s+fNvNW5cf5E4XzIgxWHros23M0Lg/IJzS/X4w1myO370KAtXm5qnoG/EKAXaDYUTozq7XlMgAWz5WJJxI+mhVxHnwqR9X5UemmfgD+YS+W6pIcxiDMPtJrDnSEle2xVDmizjw6YcCi4+zxwM38/WqehQLC52O1rbKNRTwojjeReNk4jC9lED0/Qil8f0l0YEKAu+TK0BF3HXx4RAHYDAefZPKOU6pJ7UrBH2QkS1dJUMdLcxvqZ7pRZLPiep8Qfsc+l1oTlapAmBblVt3lDYbKG9dGmclezmyJ2NpmgEgb/DI78DhHBozk8fPJxSMgf7FSr2fob+zEy+W8uTyBIxX3ejTzeHhrR9s0hIaZKm6N4qepRzmzHvmkNt7bA5we7EzWMSbmX9M+EJC0+SRmitElAit69Os34FQNF3ZvHzaowk/5ZsENoCZRweqdkfvKJQivOPXjXRB00CzLNxKUURThXqBf10x0ZGN+1vayzcBiRIMRfOUGonsSUKCb59Ofl0BVbPkL+0a/Z6GylXmOqSn36kUvMcxrIdAi7BOjTpSx/pYyb8Ab+WkrdeAmZz6C5w9iHcxOEEuj8c/+LfThshKKcpzUDYsIiVqXBRCepkf69x3Pv2/awrrVx3yGxix+5xi5oEHkN7tk63Gcdgw2JWoq3
 6BFtTiYR
 0q5lpu40Wm7HII0Ju5cyAniDBHDMPVfnX3jlv9CK9Whv7KlKU+xvbuQpHkhLmwMhAC/R4QwiDCw5RioYIvdb4Gb2GVfSprvMOmK9TDohzYy24ph/i0QwmdNgdep+b6kpSrpDgOpCvRlhJ6znNClAxJkSPh66SeuYyK/Qxzj+sasUtm6OgUnyMJdIKZwPB51rD5V+VAXIXQAKbd/eTBTf+0Ruj+MHCUXxMxtlf04IFkZMiASotSSKazF8Gjt8kke7o9LuD4bAq31UrIWTZ0OFfhO9U5AQiI6v7TRKFT2Fuj/MPU08RYY2m2v47bC6QWodlDJnXyo9E4D7Jldz0XE/LWU3zb8OZLofPx9zEUfW5z+rzh3b0p9/S5WUCfX6j7c+yXdGaOYRMl/mA1mnFmKpg8DJ5GYuNEy7A/iMrGZc3BayeyDZxnFmb4JB61GnBi5pY5Td9L9C+yH4l08+xOxxJ/VAqtFpKNe7Idgim
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some places in the kernel implement a parallel programming strategy
consisting on local_locks() for most of the work, and some rare remote
operations are scheduled on target cpu. This keeps cache bouncing low since
cacheline tends to be mostly local, and avoids the cost of locks in non-RT
kernels, even though the very few remote operations will be expensive due
to scheduling overhead.

On the other hand, for RT workloads this can represent a problem:
scheduling work on remote cpu that are executing low latency tasks
is undesired and can introduce unexpected deadline misses.

It's interesting, though, that local_lock()s in RT kernels become
spinlock(). We can make use of those to avoid scheduling work on a remote
cpu by directly updating another cpu's per_cpu structure, while holding
it's spinlock().

In order to do that, it's necessary to introduce a new set of functions to
make it possible to get another cpu's per-cpu "local" lock (qpw_{un,}lock*)
and also the corresponding queue_percpu_work_on() and flush_percpu_work()
helpers to run the remote work.

Users of non-RT kernels but with low latency requirements can select
similar functionality by using the CONFIG_QPW compile time option.

On CONFIG_QPW disabled kernels, no changes are expected, as every
one of the introduced helpers work the exactly same as the current
implementation:
qpw_{un,}lock*()        ->  local_{un,}lock*() (ignores cpu parameter)
queue_percpu_work_on()  ->  queue_work_on()
flush_percpu_work()     ->  flush_work()

For QPW enabled kernels, though, qpw_{un,}lock*() will use the extra
cpu parameter to select the correct per-cpu structure to work on,
and acquire the spinlock for that cpu.

queue_percpu_work_on() will just call the requested function in the current
cpu, which will operate in another cpu's per-cpu object. Since the
local_locks() become spinlock()s in QPW enabled kernels, we are
safe doing that.

flush_percpu_work() then becomes a no-op since no work is actually
scheduled on a remote cpu.

Some minimal code rework is needed in order to make this mechanism work:
The calls for local_{un,}lock*() on the functions that are currently
scheduled on remote cpus need to be replaced by qpw_{un,}lock_n*(), so in
QPW enabled kernels they can reference a different cpu. It's also
necessary to use a qpw_struct instead of a work_struct, but it just
contains a work struct and, in CONFIG_QPW, the target cpu.

This should have almost no impact on non-CONFIG_QPW kernels: few
this_cpu_ptr() will become per_cpu_ptr(,smp_processor_id()).

On CONFIG_QPW kernels, this should avoid deadlines misses by
removing scheduling noise.

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 Documentation/admin-guide/kernel-parameters.txt |   10 
 Documentation/locking/qpwlocks.rst              |   70 ++++++
 MAINTAINERS                                     |    7 
 include/linux/qpw.h                             |  256 ++++++++++++++++++++++++
 init/Kconfig                                    |   35 +++
 kernel/Makefile                                 |    2 
 kernel/qpw.c                                    |   26 ++
 7 files changed, 406 insertions(+)
 create mode 100644 include/linux/qpw.h
 create mode 100644 kernel/qpw.c

Index: linux/Documentation/admin-guide/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/admin-guide/kernel-parameters.txt
+++ linux/Documentation/admin-guide/kernel-parameters.txt
@@ -2840,6 +2840,16 @@ Kernel parameters
 
 			The format of <cpu-list> is described above.
 
+	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
+			and remote interference mechanism on a kernel built with
+			CONFIG_QPW.
+			Format: { "0" | "1" }
+			0 - local_lock() + queue_work_on(remote_cpu)
+			1 - spin_lock() for both local and remote operations
+
+			Selecting 1 may be interesting for systems that want
+			to avoid interruption & context switches from IPIs.
+
 	iucv=		[HW,NET]
 
 	ivrs_ioapic	[HW,X86-64]
Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS
+++ linux/MAINTAINERS
@@ -21553,6 +21553,13 @@ F:	Documentation/networking/device_drive
 F:	drivers/bus/fsl-mc/
 F:	include/uapi/linux/fsl_mc.h
 
+QPW
+M:	Leonardo Bras <leobras.c@gmail.com>
+S:	Supported
+F:	Documentation/locking/qpwlocks.rst
+F:	include/linux/qpw.h
+F:	kernel/qpw.c
+
 QT1010 MEDIA DRIVER
 L:	linux-media@vger.kernel.org
 S:	Orphan
Index: linux/include/linux/qpw.h
===================================================================
--- /dev/null
+++ linux/include/linux/qpw.h
@@ -0,0 +1,256 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_QPW_H
+#define _LINUX_QPW_H
+
+#include "linux/spinlock.h"
+#include "linux/local_lock.h"
+#include "linux/workqueue.h"
+
+#ifndef CONFIG_QPW
+
+typedef local_lock_t qpw_lock_t;
+typedef local_trylock_t qpw_trylock_t;
+
+struct qpw_struct {
+	struct work_struct work;
+};
+
+#define qpw_lock_init(lock)				\
+	local_lock_init(lock)
+
+#define qpw_trylock_init(lock)				\
+	local_trylock_init(lock)
+
+#define qpw_lock(lock, cpu)				\
+	local_lock(lock)
+
+#define local_qpw_lock(lock)				\
+	local_lock(lock)
+
+#define qpw_lock_irqsave(lock, flags, cpu)		\
+	local_lock_irqsave(lock, flags)
+
+#define local_qpw_lock_irqsave(lock, flags)		\
+	local_lock_irqsave(lock, flags)
+
+#define qpw_trylock(lock, cpu)				\
+	local_trylock(lock)
+
+#define local_qpw_trylock(lock)				\
+	local_trylock(lock)
+
+#define qpw_trylock_irqsave(lock, flags, cpu)		\
+	local_trylock_irqsave(lock, flags)
+
+#define qpw_unlock(lock, cpu)				\
+	local_unlock(lock)
+
+#define local_qpw_unlock(lock)				\
+	local_unlock(lock)
+
+#define qpw_unlock_irqrestore(lock, flags, cpu)		\
+	local_unlock_irqrestore(lock, flags)
+
+#define local_qpw_unlock_irqrestore(lock, flags)	\
+	local_unlock_irqrestore(lock, flags)
+
+#define qpw_lockdep_assert_held(lock)			\
+	lockdep_assert_held(lock)
+
+#define queue_percpu_work_on(c, wq, qpw)		\
+	queue_work_on(c, wq, &(qpw)->work)
+
+#define flush_percpu_work(qpw)				\
+	flush_work(&(qpw)->work)
+
+#define qpw_get_cpu(qpw)	smp_processor_id()
+
+#define qpw_is_cpu_remote(cpu)		(false)
+
+#define INIT_QPW(qpw, func, c)				\
+	INIT_WORK(&(qpw)->work, (func))
+
+#else /* CONFIG_QPW */
+
+DECLARE_STATIC_KEY_MAYBE(CONFIG_QPW_DEFAULT, qpw_sl);
+
+typedef union {
+	spinlock_t sl;
+	local_lock_t ll;
+} qpw_lock_t;
+
+typedef union {
+	spinlock_t sl;
+	local_trylock_t ll;
+} qpw_trylock_t;
+
+struct qpw_struct {
+	struct work_struct work;
+	int cpu;
+};
+
+#define qpw_lock_init(lock)								\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
+			spin_lock_init(lock.sl);					\
+		else									\
+			local_lock_init(lock.ll);					\
+	} while (0)
+
+#define qpw_trylock_init(lock)								\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
+			spin_lock_init(lock.sl);					\
+		else									\
+			local_trylock_init(lock.ll);					\
+	} while (0)
+
+#define qpw_lock(lock, cpu)								\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
+			spin_lock(per_cpu_ptr(lock.sl, cpu));				\
+		else									\
+			local_lock(lock.ll);						\
+	} while (0)
+
+#define local_qpw_lock(lock)								\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
+			migrate_disable();						\
+			spin_lock(this_cpu_ptr(lock.sl));				\
+		} else									\
+			local_lock(lock.ll);						\
+	} while (0)
+
+#define qpw_lock_irqsave(lock, flags, cpu)						\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
+			spin_lock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);		\
+		else									\
+			local_lock_irqsave(lock.ll, flags);				\
+	} while (0)
+
+#define local_qpw_lock_irqsave(lock, flags)						\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
+			migrate_disable();						\
+			spin_lock_irqsave(this_cpu_ptr(lock.sl), flags);		\
+		} else									\
+			local_lock_irqsave(lock.ll, flags);				\
+	} while (0)
+
+
+#define qpw_trylock(lock, cpu)                                                          \
+	({                                                                              \
+		int t;                                                                  \
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))                   \
+			t = spin_trylock(per_cpu_ptr(lock.sl, cpu));                    \
+		else                                                                    \
+			t = local_trylock(lock.ll);                                     \
+		t;                                                                      \
+	})
+
+#define local_qpw_trylock(lock)								\
+	({										\
+		int t;									\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
+			migrate_disable();						\
+			t = spin_trylock(this_cpu_ptr(lock.sl));			\
+			if (!t)								\
+				migrate_enable();					\
+		} else									\
+			t = local_trylock(lock.ll);					\
+		t;									\
+	})
+
+#define qpw_trylock_irqsave(lock, flags, cpu)						\
+	({										\
+		int t;									\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
+			t = spin_trylock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);	\
+		else									\
+			t = local_trylock_irqsave(lock.ll, flags);			\
+		t;									\
+	})
+
+#define qpw_unlock(lock, cpu)								\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
+			spin_unlock(per_cpu_ptr(lock.sl, cpu));				\
+		} else {								\
+			local_unlock(lock.ll);						\
+		}									\
+	} while (0)
+
+#define local_qpw_unlock(lock)								\
+do {										\
+	if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
+		spin_unlock(this_cpu_ptr(lock.sl));				\
+		migrate_enable();						\
+	} else {								\
+		local_unlock(lock.ll);						\
+	}									\
+} while (0)
+
+#define qpw_unlock_irqrestore(lock, flags, cpu)						\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
+			spin_unlock_irqrestore(per_cpu_ptr(lock.sl, cpu), flags);	\
+		else									\
+			local_unlock_irqrestore(lock.ll, flags);			\
+	} while (0)
+
+#define local_qpw_unlock_irqrestore(lock, flags)					\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
+			spin_unlock_irqrestore(this_cpu_ptr(lock.sl), flags);		\
+			migrate_enable();						\
+		} else									\
+			local_unlock_irqrestore(lock.ll, flags);			\
+	} while (0)
+
+#define qpw_lockdep_assert_held(lock)							\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
+			lockdep_assert_held(this_cpu_ptr(lock.sl));			\
+		else									\
+			lockdep_assert_held(this_cpu_ptr(lock.ll));			\
+	} while (0)
+
+#define queue_percpu_work_on(c, wq, qpw)						\
+	do {										\
+		int __c = c;								\
+		struct qpw_struct *__qpw = (qpw);					\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
+			WARN_ON((__c) != __qpw->cpu);					\
+			__qpw->work.func(&__qpw->work);					\
+		} else {								\
+			queue_work_on(__c, wq, &(__qpw)->work);				\
+		}									\
+	} while (0)
+
+/*
+ * Does nothing if QPW is set to use spinlock, as the task is already done at the
+ * time queue_percpu_work_on() returns.
+ */
+#define flush_percpu_work(qpw)								\
+	do {										\
+		struct qpw_struct *__qpw = (qpw);					\
+		if (!static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {		\
+			flush_work(&__qpw->work);					\
+		}									\
+	} while (0)
+
+#define qpw_get_cpu(w)			container_of((w), struct qpw_struct, work)->cpu
+
+#define qpw_is_cpu_remote(cpu)		((cpu) != smp_processor_id())
+
+#define INIT_QPW(qpw, func, c)								\
+	do {										\
+		struct qpw_struct *__qpw = (qpw);					\
+		INIT_WORK(&__qpw->work, (func));					\
+		__qpw->cpu = (c);							\
+	} while (0)
+
+#endif /* CONFIG_QPW */
+#endif /* LINUX_QPW_H */
Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig
+++ linux/init/Kconfig
@@ -762,6 +762,41 @@ config CPU_ISOLATION
 
 	  Say Y if unsure.
 
+config QPW
+	bool "Queue per-CPU Work"
+	depends on SMP || COMPILE_TEST
+	default n
+	help
+	  Allow changing the behavior on per-CPU resource sharing with cache,
+	  from the regular local_locks() + queue_work_on(remote_cpu) to using
+	  per-CPU spinlocks on both local and remote operations.
+
+	  This is useful to give user the option on reducing IPIs to CPUs, and
+	  thus reduce interruptions and context switches. On the other hand, it
+	  increases generated code and will use atomic operations if spinlocks
+	  are selected.
+
+	  If set, will use the default behavior set in QPW_DEFAULT unless boot
+	  parameter qpw is passed with a different behavior.
+
+	  If unset, will use the local_lock() + queue_work_on() strategy,
+	  regardless of the boot parameter or QPW_DEFAULT.
+
+	  Say N if unsure.
+
+config QPW_DEFAULT
+	bool "Use per-CPU spinlocks by default"
+	depends on QPW
+	default n
+	help
+	  If set, will use per-CPU spinlocks as default behavior for per-CPU
+	  remote operations.
+
+	  If unset, will use local_lock() + queue_work_on(cpu) as default
+	  behavior for remote operations.
+
+	  Say N if unsure
+
 source "kernel/rcu/Kconfig"
 
 config IKCONFIG
Index: linux/kernel/Makefile
===================================================================
--- linux.orig/kernel/Makefile
+++ linux/kernel/Makefile
@@ -142,6 +142,8 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue
 obj-$(CONFIG_RESOURCE_KUNIT_TEST) += resource_kunit.o
 obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
 
+obj-$(CONFIG_QPW) += qpw.o
+
 CFLAGS_kstack_erase.o += $(DISABLE_KSTACK_ERASE)
 CFLAGS_kstack_erase.o += $(call cc-option,-mgeneral-regs-only)
 obj-$(CONFIG_KSTACK_ERASE) += kstack_erase.o
Index: linux/kernel/qpw.c
===================================================================
--- /dev/null
+++ linux/kernel/qpw.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "linux/export.h"
+#include <linux/sched.h>
+#include <linux/qpw.h>
+#include <linux/string.h>
+
+DEFINE_STATIC_KEY_MAYBE(CONFIG_QPW_DEFAULT, qpw_sl);
+EXPORT_SYMBOL(qpw_sl);
+
+static int __init qpw_setup(char *str)
+{
+	int opt;
+
+	if (!get_option(&str, &opt)) {
+		pr_warn("QPW: invalid qpw parameter: %s, ignoring.\n", str);
+		return 0;
+	}
+
+	if (opt)
+		static_branch_enable(&qpw_sl);
+	else
+		static_branch_disable(&qpw_sl);
+
+	return 1;
+}
+__setup("qpw=", qpw_setup);
Index: linux/Documentation/locking/qpwlocks.rst
===================================================================
--- /dev/null
+++ linux/Documentation/locking/qpwlocks.rst
@@ -0,0 +1,70 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========
+QPW locks
+=========
+
+Some places in the kernel implement a parallel programming strategy
+consisting on local_locks() for most of the work, and some rare remote
+operations are scheduled on target cpu. This keeps cache bouncing low since
+cacheline tends to be mostly local, and avoids the cost of locks in non-RT
+kernels, even though the very few remote operations will be expensive due
+to scheduling overhead.
+
+On the other hand, for RT workloads this can represent a problem:
+scheduling work on remote cpu that are executing low latency tasks
+is undesired and can introduce unexpected deadline misses.
+
+QPW locks help to convert sites that use local_locks (for cpu local operations)
+and queue_work_on (for queueing work remotely, to be executed
+locally on the owner cpu of the lock) to QPW locks.
+
+The lock is declared qpw_lock_t type.
+The lock is initialized with qpw_lock_init.
+The lock is locked with qpw_lock (takes a lock and cpu as a parameter).
+The lock is unlocked with qpw_unlock (takes a lock and cpu as a parameter).
+
+The qpw_lock_irqsave function disables interrupts and saves current interrupt state,
+cpu as a parameter.
+
+For trylock variant, there is the qpw_trylock_t type, initialized with
+qpw_trylock_init. Then the corresponding qpw_trylock and
+qpw_trylock_irqsave.
+
+work_struct should be replaced by qpw_struct, which contains a cpu parameter
+(owner cpu of the lock), initialized by INIT_QPW.
+
+The queue work related functions (analogous to queue_work_on and flush_work) are:
+queue_percpu_work_on and flush_percpu_work.
+
+The behaviour of the QPW functions is as follows:
+
+* !CONFIG_QPW (or CONFIG_QPW and qpw=off kernel boot parameter):
+        - qpw_lock:                     local_lock
+        - qpw_lock_irqsave:             local_lock_irqsave
+        - qpw_trylock:                  local_trylock
+        - qpw_trylock_irqsave:          local_trylock_irqsave
+        - qpw_unlock:                   local_unlock
+        - queue_percpu_work_on:         queue_work_on
+        - flush_percpu_work:            flush_work
+
+* CONFIG_QPW (and CONFIG_QPW_DEFAULT=y or qpw=on kernel boot parameter),
+        - qpw_lock:                     spin_lock
+        - qpw_lock_irqsave:             spin_lock_irqsave
+        - qpw_trylock:                  spin_trylock
+        - qpw_trylock_irqsave:          spin_trylock_irqsave
+        - qpw_unlock:                   spin_unlock
+        - queue_percpu_work_on:         executes work function on caller cpu
+        - flush_percpu_work:            empty
+
+qpw_get_cpu(work_struct), to be called from within qpw work function,
+returns the target cpu.
+
+In addition to the locking functions above, there are the local locking
+functions (local_qpw_lock, local_qpw_trylock and local_qpw_unlock).
+These must only be used to access per-CPU data from the CPU that owns
+that data, and not remotely. They disable preemption or migration
+and don't require a cpu parameter.
+
+These should only be used when accessing per-CPU data of the local CPU.
+



