Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07CC6F483E0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A6B6B0088; Mon, 23 Mar 2026 14:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3156A6B009B; Mon, 23 Mar 2026 14:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5D06B008A; Mon, 23 Mar 2026 14:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2FD26B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:06:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABE5A1EC7F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:21 +0000 (UTC)
X-FDA: 84578107362.16.AD61076
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A850A0008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cSamENWL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=osP1Ij82qQMR90cDWp1W7z47HN+UKQWoX2ScoVd/4i0=;
	b=CCfkHYrmiFZDSCKgkgQnSqxDmDiPXfGYeZEiVKz0I9vsXwEMvd8Wt0qv6EAQc9Mnud486z
	GHYpFrQQ1gJE6fYLDDIGn1/FmID0OBQCnPEEDrCeRynKWyQlRhcl4pKEddm51AkNyxidbY
	qeb1aIwTmr8tMYxClQ8U0OsJfGZMcFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774289179; a=rsa-sha256;
	cv=none;
	b=NFvlSHepXUBNTc2xR97XUdD7JC2yR2r/g8KVM15oSvSrMguDoRduS9d7QcpR3OhWHyXevm
	p9qAprPFjH//vOmWOoH6GPDr+wu7UELIdlaSZO/hfBLNilmHduUNkZqW7joC/EQUUOQvUu
	mYLHuhrLX56vmxfsaW9zfgd4iB7hTTU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cSamENWL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774289179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=osP1Ij82qQMR90cDWp1W7z47HN+UKQWoX2ScoVd/4i0=;
	b=cSamENWLqjoFY0WSLu7yclcZow9qULTmoi49Px1O+1H0zexDqbEjbiDFIWkyyaVyM7Jnhn
	hR+jg4VEfninemEAEq4vCopuK5i81sbgD+Dn5Hz4knEj4qQ7Sfp9R55yAqgAtzETUapy0d
	/uZAA8IyPaK3IOOVpb8eX1135L17h2k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-gdOCgLodMCCRzi0_14wKaA-1; Mon,
 23 Mar 2026 14:06:15 -0400
X-MC-Unique: gdOCgLodMCCRzi0_14wKaA-1
X-Mimecast-MFC-AGG-ID: gdOCgLodMCCRzi0_14wKaA_1774289173
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46ABF180034E;
	Mon, 23 Mar 2026 18:06:13 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 531A01955D71;
	Mon, 23 Mar 2026 18:06:11 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id A98E0401E3F5C; Mon, 23 Mar 2026 15:05:44 -0300 (-03)
Message-ID: <20260323180150.242567098@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 23 Mar 2026 14:55:45 -0300
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
Subject: [PATCH v3 1/4] Introducing qpw_lock() and per-cpu queue & flush work
References: <20260323175544.807534301@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: eaAFI1dhM0tndW0G7QPy_yy88WLUpRKrXaF2_JX4mpM_1774289173
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 9A850A0008
X-Stat-Signature: dreq79seudpiogs16scf4trnot79h3du
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774289179-702961
X-HE-Meta: U2FsdGVkX18Fl62kEuJ4IpoN/sWHhqlfSrlnOtJkp7qyV9yvZmLPu9mNNMz3hGj2l/NnPrLaMnchbt+xLeG1zugryI/ye/TWYO9qdSAAP38UHJnjcUrqAu2dMiIHOJ04r27xHOwKTAwane0120BeoNxDvAg2i7C7kpr2v9G1WSAwk7IjF4lXcA8sG9SIPsJON/NvdBryK1IQ5Zi2JaFLoupENAN+550c8Bm+nHLgw57nsuYvQJsb8zdoFgbL7iBRbtvJJu0HqvKD9ViIT/2b1fta5FZMupJy4Y/G1FVRsJOdb3ABVhJcaOShsDSnABeXDc8g3OWGmoxoXiQysV8iRhb5TCD8PYWVlIvHw0eyiDdMlg6B5aQMw+Qy64UA/dM5aC79UXmfPMNse6r9K38cmqa9QMaNM3P4oiUaXO2C7g7fDFiZrQwpmy3umhvqQU4UftH+BClegPmcJjl6Bs59IFEqvmjXNfTBK8INW5laxSxRoVV7Sf5JhRjkq6qLCXbej7FFaTjx2Ulg6oZEjvjk9AYn6VdJFvbp7kmp3sJuhYwKhvs7S3/Ti1+Bf+ONFlhbsT2Kmus0de+TQ4xLyap/mWAFheZVOqzpu32HitEn2HzIl3C5bmuxHEq9FmOghn6o724ceZ9lpYgHgme/cY+2lg+4i7/Au2XLvwWwLIsXzclapjn5mvAPtG3xm7T+dDwExtYHuxafR0j4pJCWccJ69aasUmCZ2Xh7yRoy3ocU2eUA/9uqgHX8qezhLCTdoB6yEbUQFKj3BvC8+NBpnn+KOZYlXVxbX0k7xArl6hFkzZZVbBdppBrDnbEkm3fXwkzCiCWRPi9WFvEJPxCCsh2iCGjBkkbHYedNTjRo/GajKZShGnULf8zg1js8WH8m0oazAfQCNseRMlXgiivQf7ZtqafuPxSmHd4cFJgoU/fARIRsJUtMul9o2PdBGRGis4a8i7Y1YYgR3cYmOBNa0xR
 dV6I1EX/
 39Ld5DNw1eAuwmr7zh1k4RauxSwU9ZBVmjWz+IpHjElQEvJXwphzKmsuX8UG9+TWIkkQD5m+ro8dD5TX+UsjX9bOVGGC9hRApE1wjFnhrJDM2C2m2Yu9sGIBgk+aj533mpie0gpzDAoZIW/K7sdYio0pYMzugVnH4YAowP7g4Q1dGUCTHV9VEnuhcDakIwHKRpjJ5cH3W20jf8QZKxo3afmkm318jwPTccv858cMZLl4XFiie00reRnsvDUqOZV9Rf4guMsX6AJ1arEz9iiiTICogmFp6k+XUUtk0sQtZc+66ozVLuoPiuE1FYCAsFcyc9koEaVqQToX4/C+tIK+zxfZHYnZp8xInVDojntaJ8rIM122MSd5SWhWa4JZKvF+A5UdbixTeaDlrirMjrYu+JK1LPa47kO3bTK8cika5a/YjcVdL/CwQ37iJMg==
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
@@ -2841,6 +2841,16 @@ Kernel parameters
 
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
@@ -21536,6 +21536,13 @@ F:	Documentation/networking/device_drive
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
@@ -0,0 +1,264 @@
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
+#ifdef CONFIG_PREEMPT_RT
+#define preempt_or_migrate_disable migrate_disable
+#define preempt_or_migrate_enable migrate_enable
+#else
+#define preempt_or_migrate_disable preempt_disable
+#define preempt_or_migrate_enable preempt_enable
+#endif
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
+			preempt_or_migrate_disable();					\
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
+			preempt_or_migrate_disable();					\
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
+			preempt_or_migrate_disable();					\
+			t = spin_trylock(this_cpu_ptr(lock.sl));			\
+			if (!t)								\
+				preempt_or_migrate_enable();				\
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
+		preempt_or_migrate_enable();					\
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
+			preempt_or_migrate_enable();					\
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
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "linux/export.h"
+#include <linux/sched.h>
+#include <linux/qpw.h>
+#include <linux/string.h>
+#include <linux/sched/isolation.h>
+
+DEFINE_STATIC_KEY_MAYBE(CONFIG_QPW_DEFAULT, qpw_sl);
+EXPORT_SYMBOL(qpw_sl);
+
+static bool qpw_param_specified;
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
+	qpw_param_specified = true;
+
+	return 1;
+}
+__setup("qpw=", qpw_setup);
+
+/*
+ * Enable QPW if CPUs want to avoid kernel noise.
+ */
+static int __init qpw_init(void)
+{
+	if (qpw_param_specified == true)
+		return 0;
+
+	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
+		static_branch_enable(&qpw_sl);
+
+	return 0;
+}
+
+late_initcall(qpw_init);
Index: linux/Documentation/locking/qpwlocks.rst
===================================================================
--- /dev/null
+++ linux/Documentation/locking/qpwlocks.rst
@@ -0,0 +1,76 @@
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
+        - local_qpw_lock:               local_lock
+        - local_qpw_trylock:            local_trylock
+        - local_qpw_unlock:             local_unlock
+        - queue_percpu_work_on:         queue_work_on
+        - flush_percpu_work:            flush_work
+
+* CONFIG_QPW (and CONFIG_QPW_DEFAULT=y or qpw=on kernel boot parameter),
+        - qpw_lock:                     spin_lock
+        - qpw_lock_irqsave:             spin_lock_irqsave
+        - qpw_trylock:                  spin_trylock
+        - qpw_trylock_irqsave:          spin_trylock_irqsave
+        - qpw_unlock:                   spin_unlock
+        - local_qpw_lock:               preempt_disable OR migrate_disable + spin_lock
+        - local_qpw_trylock:            preempt_disable OR migrate_disable + spin_trylock
+        - local_qpw_unlock:             preempt_enable OR migrate_enable + spin_unlock
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



