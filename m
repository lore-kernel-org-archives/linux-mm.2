Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B2FCCA472
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E868E0015; Thu,  2 Oct 2025 04:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E5B8E0008; Thu,  2 Oct 2025 04:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1598E0015; Thu,  2 Oct 2025 04:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8068E0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D834E588B9
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:27 +0000 (UTC)
X-FDA: 83952459654.01.3AFA258
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3619A0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=B71dyQo2bbB1wN7ZhmtLrszEg0r0pvmLiaomQ6wL4KU=;
	b=ixchf5Ny83hAPO+O75lpTEJDBzKIbGJWWfQsHrKmVLRvosTCZtn5iYsi05Z65j2c+Wzex3
	Myb8Y4ByyS/MhXqNcHfprsP8RRf/t0Hvid/EbEU81BnH8SXFvUEvn3mPFBU9A+1B+lz62X
	hR9ybq7Jvvq10ePsInaXRD25kB28RZM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392806; a=rsa-sha256;
	cv=none;
	b=moCsAgKa2uzouPR1SOx1lUlDMOkUnRUE8FHZjFoX+5i0Iiq3uoiR/b1GDG/P0DZdSoeD0F
	Ds/en7gYYn3LMwmwwyFPkDjfesmkzQiZW3ld0pIYtxq8jgYRe204DK2O1i/qHuzvtP8foe
	iIg/Wd7QpE82fcrPPNHJ/cxExhrz3xU=
X-AuditID: a67dfc5b-c2dff70000001609-34-68de340dfdf5
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
Subject: [PATCH v17 09/47] arm64, dept: add support CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64
Date: Thu,  2 Oct 2025 17:12:09 +0900
Message-Id: <20251002081247.51255-10-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSbUxTZxQHcJ/72laqN9W46/tSQ4z4MjGdOSY6F2OyJ4vTReMHZ6I2cLUN
	ULQowrJlVQEZbpE0KUYq0MJSm1Id3hKVag2ChWGjtKEKgxXsZJ0ESrMGMAjYtRi//fI//3M+
	HQmp6KdXSLS6s4Jep85VMjJKFk2zbparBjVbXZ3roFy8TsPQZDmCtzNmEkpbEhTMGTtYmJge
	YCHh6UBQFTCS4Gy+QMBoexyBKTzMwLWRCxTEbL8gqI6YWRjxfgWJ0L8E9E6NIbANvydguPUy
	grmqHKirdzEw86ybhGsmPwJrOETCm6bksLljEIHHfpGBnuFFEJyMMdBlusJANHCDgPEmBiwX
	PTRcavidgaoakYKWV24WAqOzBDSK38CQLUKBr7KeANOtBwRM2xws2AzpYH7WQ8Pf9moWZsOZ
	ELpqouB2tJuGrsGXNIxGjAwMdZbRcM/wigXxTy+CiWCYgHL3JAXi62TF078RrGW/UfDQ00VB
	+dwEgh73DQYGnQkaDOa3NPhbffSX2djhuktgZ60T4Zl3RoRLK5NqH4uR2DNlofDTeh63VIdY
	XPKon8UW8Rx22TNww8MRAlvjkzQWHT8zWIwbWWydeUN+m/GdbGe2kKstFPSffXFCpil7fpM8
	7VYUea+M0waUWFSBpBKeU/G+jjr6o/3eF/NmuPV8X980mfJS7lPe9WtkPic53yr+ZWBTyku4
	I7ylt5tNmeLS+YmrMSJlObedf94eJD7cXMs3NrXO35Em856wj0pZwX3Ol8ZKkh1ZsmOW8i7D
	ffbDwnL+sb2PqkRyC1rgQAqtrjBPrc1VbdEU67RFW7Ly80SU/Djbj7NH76O4/1Ab4iRImSb3
	p4c0ClpdWFCc14Z4CalcKj9h/0ujkGeri78X9PnH9edyhYI2tFJCKT+Rb5s6n63gTqnPCjmC
	cFrQf5wSEukKA1p217KjQnIoZ1/+vsTC1dFdG4N75+4Ew48GOjuNUd2GP8YHTgpZGxY7PKea
	G2uLBw7SGeZ7x97/U6ssxWmXb++MZN766b+KJyU18sNbl1lVbmlDVV7hmu171nyte1rnP0mE
	dnfdWe60vdvvrVEtYIpKxnqXHPjh6Jm4eSiwPwubbduUVIFGnZlB6gvU/wN4eVhLbQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG+5/rHK4OS+p0gWIg0U0rKl5MoojwkFT2oSwJ8pCHNryylWUQ
	aLqU1mUNpuW0puISt8xcVkss0RzUMl2W3ZxzskxRG9SmmZe1FX15+b3P8/LwfHhFuPQRuVyk
	yDotKLP4DBklJsQHdhRujNw6IN/kdMZDX0EbAQF/CQEV9y0UlDTdIqGnwYzAHShBMDVjwEFt
	CxIwp7PT4J/+QkOw1Y6g1KnDwfKwAIOfjfMUjHX8QKD3eCkoGy0gwGe6gqB82EDDaGcCTLhb
	SAi6vmHwYXIcgck7j4G3rRjBXGk63Km2UjDT1Y1Dmb4HQZXHhcNIY8h8aB9A0Fp3kYKv2mYc
	er0L4V3AR8FLvYaCCWcFBt8bKTBebCWh0qBDUFhzn4LSyiYCbINPaXCOzWLQX6rDwNy0H9ym
	YQIc2mos1C909WApGMoKsdAYwUB/rwWDaVM9Da9r+gkw5UeDoauXhKG6chpmPZshaMwGu/kb
	Da7regIaJrrJXXrETamvEVy99RHGqd/OUZzltgVxM791iPPXFuKcWhtaO8Z9OFdkPcvVOsYp
	7nfgPcW1ThoJ7lU1y93o2sjZyl00V/TsM50UlyKOTxMyFLmCMnZnqlh+6c1dPOep9Fyn5juZ
	j4ILL6MIEctsZXs635Nhppg17MeP03iYo5jVrPXq8F8dZxwr2T7nhjAvZo6xxg/ddJgJJpr1
	X/dhYZYw29k3He+wf5mrWHNj29+ciJDe63EQYZYy21i1rwjTIrERLahHUYqs3ExekbEtRpUu
	z8tSnIs5mZ3ZhELfZLowe+MJ8vcmtCNGhGSREme0Sy4l+VxVXmY7YkW4LEqSWtcvl0rS+Lzz
	gjL7hPJMhqBqRytEhGypZF+ykCplTvGnhXRByBGU/11MFLE8H1XHP/5xaTrtS0rC0bhjY4mj
	OQNWR17S8b2Et2L9nqOJh7GzaGTDfGX9p1jvQa1Fk/LrfPMi0ZZAM286kmiLrJpNWuUZinuh
	ObnJ9/xrjX+Snhp6bI6y7WlJXsv33TzkLR7/uWTlbvv2B37NMtu64gsRybGDn3piqlxu42CJ
	29swIyNUcn7zOlyp4v8Aa9MXtkkDAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: ykuqza8ueyacu3fhmze366dzafx1hdn3
X-Rspam-User: 
X-Rspamd-Queue-Id: F3619A0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392805-723219
X-HE-Meta: U2FsdGVkX1/UWNlmYwT/Oe0+pKFqbudakGoJGi0Ysgikt9I9/8j530eKVvmN6xilrYC01uqFieT7SFPAzfe8Az7PIgpThK/oGe1ldoui95yzPUSqBvngdrrpyJQpdVVohIYTH2gv4wYUXks0syzS1iUQ0kvkU1zsceVyxEr5UyHbS/u71Pav936Z0FzDs9//pVA6dfoBB6Tt0NCyC/JiySpX8IJPT+E3RaAfbf0jtIaDuWcFSfV7A7mQvoPoeNvxj1Felu17avHSGJCqADCBnJ3oWFK9azyXW300mH5lMN7n7kXmlD/wNmfOK9IVYePNqALpVwQu5rvaDMYBJi/T8qquSIBJ+LBcN0abtT6MpWAOPAYJKNM1qz2yMmgSTmBkhwLguViA0TsZkppXKLbZCzgl0wDinFp5SXPLs8o9TuAq9f8Zy+BddkBLrhQ42XdFT+ixIV6K28M7dCk+FbU9XGZcO15YgTfLpfQtgQfp7SaTbNJclRMTLV7pgHTbEmKvEk4l5znaht6yP51EPCHhCtp7GxIZzSg016Srw0yhwgRWbU4aVIKSFI6GK7oCV5i9MB/8T9vQPwmhPhCuIaf44aOWeYPo11SoxfoPXf4/8llspvA68ZRRljTcBUtw2QjtjObpcU0pkm+SPAxsreKyxcKJNh9BjUjKTkP2zJW0MzH6+INgjPG39FHv7yZlOhOfAKWzMdqqDePNf2kpVO0sOw6Fd1nG+541ySPROZW1CJocGlFHz0phgARkHQMbh/m/iRT2uL5ARv6GIrH2hnD677lxditCPPumX0hDloXqnsDjXlREOeVwncr8NAt98VldhJTV6il1wRG8z1hHpGkO1LDmBqTVHtNYc/QbFZhbuKctEPUat9Jfes+ykoHzzRxkBVerbmAhrd/XzQp0UGppCg0O76eOpdklcA43xY9lqOu/lptZauRoSN9eaAduCvv+HEbvQv5qdcng6QZgl1s
 ygG6XJZ8
 7aP+O4BcifHKtqDDCUvNXr1v/4heWSnE6CSdOwFbm1xTJYV9RvpfpsbudNAamuY98gPiuQeQijg9H/UY6N4rCON9Pgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dept needs to notice every entrance from user to kernel mode to treat
every kernel context independently when tracking wait-event dependencies.
Roughly, system call and user oriented fault are the cases.

Make dept aware of the entrances of arm64 and add support
CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 arch/arm64/Kconfig          | 1 +
 arch/arm64/kernel/syscall.c | 7 +++++++
 arch/arm64/mm/fault.c       | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a6..a8fab2c052dc 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -281,6 +281,7 @@ config ARM64
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select VMAP_STACK
+	select ARCH_HAS_DEPT_SUPPORT
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index c442fcec6b9e..bbd306335179 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -7,6 +7,7 @@
 #include <linux/ptrace.h>
 #include <linux/randomize_kstack.h>
 #include <linux/syscalls.h>
+#include <linux/dept.h>
 
 #include <asm/debug-monitors.h>
 #include <asm/exception.h>
@@ -96,6 +97,12 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	 * (Similarly for HVC and SMC elsewhere.)
 	 */
 
+	/*
+	 * This is a system call from user mode.  Make dept work with a
+	 * new kernel mode context.
+	 */
+	dept_update_cxt();
+
 	if (flags & _TIF_MTE_ASYNC_FAULT) {
 		/*
 		 * Process the asynchronous tag check fault before the actual
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d816ff44faff..96827b999d18 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -26,6 +26,7 @@
 #include <linux/pkeys.h>
 #include <linux/preempt.h>
 #include <linux/hugetlb.h>
+#include <linux/dept.h>
 
 #include <asm/acpi.h>
 #include <asm/bug.h>
@@ -622,6 +623,12 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	if (!(mm_flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+	/*
+	 * This fault comes from user mode.  Make dept work with a new
+	 * kernel mode context.
+	 */
+	dept_update_cxt();
+
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
-- 
2.17.1


