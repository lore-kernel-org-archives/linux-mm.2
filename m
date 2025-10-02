Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCBF4CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2218E0035; Thu,  2 Oct 2025 04:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CEA8E0037; Thu,  2 Oct 2025 04:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A6B8E0035; Thu,  2 Oct 2025 04:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 382B78E0037
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11B12119BC1
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:24 +0000 (UTC)
X-FDA: 83952462048.03.1700529
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf23.hostedemail.com (Postfix) with ESMTP id 263FD140005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=qekGrP/YMqxKH+DbEIf7epJip+CtOpUjIRFgKxmaUKE=;
	b=crvDM2PK4KCGzO7xADHIO5khMPNM0UffX/5Gu6GQzmX57hkcebj0v9wPbr/joiY0hrBBjC
	Ul9YQ1L/cKVkM5TDg2AbdcOPtqEXSaX2iT2GhW9zcrsVqwLgfBQVUIqi/Am7BYdwkvtFq4
	mqwVMpGLfPk82aMJT++zgI3bSS4w0B4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392862; a=rsa-sha256;
	cv=none;
	b=3OHiJe5on2dm+w0qvP2UhMpDuqdKtLbRln79jbNaY88as58/LPLcipC7o+vxNkKP5ASBBF
	jhLupjgTjgF7qTtvRnFQSzcjtLyoG5ZrLWawQRYxwWvMyTCL2KhAH5fV9J9ZYpFXhQySe1
	DZsz2WMKD0bj1IUjy2BX4YC/b4LbiDE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-95-68de341581f1
From: Byungchul Park <byungchul@sk.com>
To: linux-kernel@vger.kernel.org
Cc: kernel_team@skhynix.com,
	torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	will@kernel.org,
	tglx@linutronix.de,
	rostedt@goodmis.org,
	joel@joelfernandes.org,
	sashal@kernel.org,
	daniel.vetter@ffwll.ch,
	duyuyang@gmail.com,
	johannes.berg@intel.com,
	tj@kernel.org,
	tytso@mit.edu,
	willy@infradead.org,
	david@fromorbit.com,
	amir73il@gmail.com,
	gregkh@linuxfoundation.org,
	kernel-team@lge.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	mhocko@kernel.org,
	minchan@kernel.org,
	hannes@cmpxchg.org,
	vdavydov.dev@gmail.com,
	sj@kernel.org,
	jglisse@redhat.com,
	dennis@kernel.org,
	cl@linux.com,
	penberg@kernel.org,
	rientjes@google.com,
	vbabka@suse.cz,
	ngupta@vflare.org,
	linux-block@vger.kernel.org,
	josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	jlayton@kernel.org,
	dan.j.williams@intel.com,
	hch@infradead.org,
	djwong@kernel.org,
	dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com,
	melissa.srw@gmail.com,
	hamohammed.sa@gmail.com,
	harry.yoo@oracle.com,
	chris.p.wilson@intel.com,
	gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com,
	boqun.feng@gmail.com,
	longman@redhat.com,
	yunseong.kim@ericsson.com,
	ysk@kzalloc.com,
	yeoreum.yun@arm.com,
	netdev@vger.kernel.org,
	matthew.brost@intel.com,
	her0gyugyu@gmail.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	sumit.semwal@linaro.org,
	gustavo@padovan.org,
	christian.koenig@amd.com,
	andi.shyti@kernel.org,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	mcgrof@kernel.org,
	petr.pavlu@suse.com,
	da.gomez@kernel.org,
	samitolvanen@google.com,
	paulmck@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	chuck.lever@oracle.com,
	neil@brown.name,
	okorniev@redhat.com,
	Dai.Ngo@oracle.com,
	tom@talpey.com,
	trondmy@kernel.org,
	anna@kernel.org,
	kees@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mark.rutland@arm.com,
	ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com,
	wangkefeng.wang@huawei.com,
	broonie@kernel.org,
	kevin.brodsky@arm.com,
	dwmw@amazon.co.uk,
	shakeel.butt@linux.dev,
	ast@kernel.org,
	ziy@nvidia.com,
	yuzhao@google.com,
	baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com,
	joel.granados@kernel.org,
	richard.weiyang@gmail.com,
	geert+renesas@glider.be,
	tim.c.chen@linux.intel.com,
	linux@treblig.org,
	alexander.shishkin@linux.intel.com,
	lillian@star-ark.net,
	chenhuacai@kernel.org,
	francesco@valla.it,
	guoweikang.kernel@gmail.com,
	link@vivo.com,
	jpoimboe@kernel.org,
	masahiroy@kernel.org,
	brauner@kernel.org,
	thomas.weissschuh@linutronix.de,
	oleg@redhat.com,
	mjguzik@gmail.com,
	andrii@kernel.org,
	wangfushuai@baidu.com,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-modules@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v17 42/47] dept: call dept_hardirqs_off() in local_irq_*() regardless of irq state
Date: Thu,  2 Oct 2025 17:12:42 +0900
Message-Id: <20251002081247.51255-43-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTZxjHed9z6Wmh7FDdPOqMpAma6IY31GeZm8vi5XxZYjKzeYta5cQ2
	3FwLCE6TgqtDA7M2sUbKEKirXalaW2AodqkoKDbGVgxjysVOrBroGitCOihdwfjlyS+///95
	Pj0MIfuLmseo8gsFdb4iV05LSEkopf7TD7MGlMvbWj+HnjIPCTVX7DT4LjciGHxbgWB8wkSA
	7lqchJihUwSj0SciiLs7ERj9BgLsTWUY3jimaBi+FUEQtlQiqA6aRPCqYzOEBtsosAxNYRjy
	/IwgZsyB8w0uGibuPyDgpSOhmjoHELit5TQ81zcT0D2UCiF/DYZ/HTTUlbspOGa+QoN/eBJD
	n9GAodH5DQxagiR49Q0YjFfngOnsMZwYLzGcudSGIWqxicCizQDT/W4K/rFWi2AysALidQVw
	OfSAgq6BHgoG7xyn4A/tUxE4/+5AMPoogMFeGSTA+SyRnqvto+GGu4uEitgogu7rNTRUOpop
	GLDHKdCaxinwebwUPGz0kdBV/Tv5VTY/rvuF5G2uFszrHsZo3l5rR/zEfwbE6/QJujUSJvjf
	vCM0f6+B469V94v4OmcR77Iu4c03XmG+PvKW4h8Pf8E7bSfoLZk7JOuyhVxVsaBe9uVeiTLu
	aaIOln1QomuLkFoUSj6JxAzHZnHmC0bRe669GKammWYXc729UWKaZ7PpnKsqOOMJ1vsx1+P/
	5CRimFnsPs4WUE5rks3gzJdCM3Upu4a7fecZfndyIdfo8Mx4ccJ3B7zkNMvY1Zwu/FOiI0l0
	Loq5532niHcLc7mb1l5Sj6R1KMmGZKr84jyFKjcrU1maryrJ3F+Q50SJd7McndzZiiK+b9sR
	yyB5itSX0a+UUYpiTWleO+IYQj5butfap5RJsxWlhwV1wR51Ua6gaUfzGVI+R7py7FC2jD2g
	KBRyBOGgoH6fYkY8T4vmBr67voH5vkMZPv1DC/rxTdqmVdvd9bX3xrA3WvokLTl6xBaQrhX0
	mrztG2Wfra+v+tqflRr3nygsutvsxynlI4t3Gla/2Pxrk2SR5KmcWLCyWByTuyq2JbUGx460
	XK2ZSt/9UU7Va3e/+c9IWtJQ8rpU5Ce3Hj+0dNsILtmVkyYnNUrFiiWEWqP4H3kUzzhqAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSW0xTaRSF/c/5z4WOlTMdMp4oidqEkMwgagJmZ2qMzosnRo0ao4kvUvA4
	rdxMiwwYTbg1EEaUNrZEqlghFqSACGjEWiSg9YIItSPgQGWqHbxArVGQIIVOwfiys/a3VnbW
	w2ZJ2Q1qBavOyBI1Gco0OS3Bkl2KwrVRCS9V659bEmEgvxPD1GQJhgvXGmgoaTlPQX+TDcHo
	VAmC6VkzCbr2EIY5g5OByZlhBkIOJwKTy0BCQ1s+AZ+b52kY7/6EwOj10VDxLh9DwHoaQeWY
	mYF397eBf9ROQcjzhoDBLxMIrL55AnydxQjmTKlwqbqVhtnePhIqjP0ILns9JLxtDpttzpcI
	HHUFNPxXfoMEt28Z/D0VoOGR8S8a/K4LBHxopsFS4KDgotmAoLDmGg2miy0Y2v+9zYBrPEjA
	iMlAgK1lJ4xaxzD0lFcT4X7h1PXlYK4oJMLjLQHGRjsBM9Z6Bp7UjGCw5sWAuddNwau6SgaC
	3g0QsmSC0/aGAc9ZI4Ymfx+1xYiEad0ZLNS33iQE3bM5WmioakDC7FcDEiavFJKCrjy8dk8E
	SKGo9U/hSs8ELXydek4Lji8WLDyu5gV971qhvdLDCEUd/zC7fzso2XRYTFNni5p1m5MkqlBn
	G3UsPzJHZ/+E85D/h1IUwfJcAl9VG6AWNM3F8kNDM+SCjuJW861lY4uc5Hqi+QFXXCli2Z+4
	ZL7eq1rAmIvhaxr9i3Ept5G/9+A18e3kKt7W3LnII8Lc7e3BC1rGJfK6QBFRjiQWtKQeRakz
	stOV6rTEeG2qKjdDnROfkpnegsLPZD0V1N9Ck+5tXYhjkXyp1BXjUckoZbY2N70L8Swpj5Im
	1Y2oZNLDytwToibzkOZ4mqjtQitZLF8u3X5ATJJxfyizxFRRPCZqvrsEG7EiD+XK++ePDA25
	dt8sS0k5nfJsP467e3lHxL41YvKDvuBt51XFj47pO9EF9u2xOabk8TNPi4cteved4sFh/b5V
	8ZEKf+T10ljS1ntu696f4371lH2kqjpifFxAR++piHcpqj+4DO83js09VKjHT9b+3mTX9ye8
	aHwaLe4J7tVlzcQelWOtSrnhF1KjVf4P8xIkJkgDAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: p3twt8a7p6aq6xi995kg7h84uh5c5och
X-Rspam-User: 
X-Rspamd-Queue-Id: 263FD140005
X-Rspamd-Server: rspam10
X-HE-Tag: 1759392861-382625
X-HE-Meta: U2FsdGVkX1+lyAafjTGdi1x4bs/o4zHyt/ikV8cEK+qO1lc/0KaJkybREPuMCjJXnlPPLTz4WARnpysZMkLIeEyRzjgYln8cf2ViDMXpMMML0mZO5w/0krEqDOWWl4FW6YGE3MpkFhgLdLS2zKNEHSWVkkmBZ7indKiA7Zdu/pSfkXlxFEiuu9UO3uydoX5DK01wHec93KpLTqCMXiH8NRh+P3FN9sjVjK+I/F4Z4pb4RhSJHzJrRutYdTO2q+IXJLEBzSDtxbGSsHXDQNuhAEkX2/+E8Dfmq3QoIn+yT1tCc2LI2IcMN0PoRW/l4rUTHgIBFfUS5/hF+cyu2TRghfppu+OmOY4bSTZJPK847dkHhvmd2RG3fyeP/DzGKY8LTUMAz8s4ovkBwJNzi6keuVN7MDQS+HFfCQcxhucNLQ5pRgpX4sJv9xXszMU0u9CZBMU1pDzauFVEo110BuIFQWlx6gSk+LqFJe14Di6n3BgSFdyjqJHUT19sS54Q98y9kj+VXgo6ZcNAkvOGjDmI3HTx4IFppOVLY3J0Vj01MZ+aF9yjgLbKGdtLJIQrB+BdYJYv3rrHFx1fu4fSozz4qfRvbubmY97PxqMjrq8cql4TCeBzkrCpGgYdjT3tf6UgHgi6KHv6te6DzEbbTMg0oLs4pjmxppqsHs2HKfdUQnRYx2z6Znxvm9MtTEYkfcm9eJIxVNQfg8zAnAcMkbxhNj2WM7hsPsqnJTtQK6wwMFYAzqvgTWitsXAFDGddMLUl4reCBwL8sRS/H7XBDuK/m25NHofhKYYD4eNJhbSrNKaBlw391zOWPWqwqTIGo1waPa0dcpg4R4QwA95pDN0V/GwURUZ7PK/1kohFgMK7bLKDKi/p/gdvoZTgQqLEtA0CK+D8tuZOGxQuwpyySWzCzFiiAYH81SHXbNxZr9c6N5ss2NAF9A6IevkNPxN7T8hiA/olVub91dfLtRR3AR7
 eHwO89Vb
 Y954peqjyrrOxp2IbgqwYSzaxMYrhiFovFdcXnU8Mg97Mf5zHJPUZo2AWwmJOWfpPLMN0ogHdU/QJjkhAlCVUmfGAzmwib/E2Rok6qldo2QrfBbOksUDemw0gFVg9clvjXwJM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For dept to function properly, dept_task()->hardirqs_enabled must be set
correctly.  If it fails to set this value to false, for example, dept
may mistakenly think irq is still enabled even when it's not.

Do dept_hardirqs_off() regardless of irq state not to miss any
unexpected cases by any chance e.g. changes of the state by asm code.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/irqflags.h | 14 ++++++++++++++
 kernel/dependency/dept.c |  1 +
 2 files changed, 15 insertions(+)

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index d8b9cf093f83..586f5bad4da7 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -214,6 +214,13 @@ extern void warn_bogus_irq_restore(void);
 		raw_local_irq_disable();		\
 		if (!was_disabled)			\
 			trace_hardirqs_off();		\
+		/*					\
+		 * Just in case that C code has missed	\
+		 * trace_hardirqs_off() at the first	\
+		 * place e.g. disabling irq at asm code.\
+		 */					\
+		else					\
+			dept_hardirqs_off();		\
 	} while (0)
 
 #define local_irq_save(flags)				\
@@ -221,6 +228,13 @@ extern void warn_bogus_irq_restore(void);
 		raw_local_irq_save(flags);		\
 		if (!raw_irqs_disabled_flags(flags))	\
 			trace_hardirqs_off();		\
+		/*					\
+		 * Just in case that C code has missed	\
+		 * trace_hardirqs_off() at the first	\
+		 * place e.g. disabling irq at asm code.\
+		 */					\
+		else					\
+			dept_hardirqs_off();		\
 	} while (0)
 
 #define local_irq_restore(flags)			\
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 0f4464657288..a17b185d6a6a 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -2248,6 +2248,7 @@ void noinstr dept_hardirqs_off(void)
 	 */
 	dept_task()->hardirqs_enabled = false;
 }
+EXPORT_SYMBOL_GPL(dept_hardirqs_off);
 
 void noinstr dept_update_cxt(void)
 {
-- 
2.17.1


