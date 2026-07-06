Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A46FDC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1A46B00AA; Mon,  6 Jul 2026 02:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9A36B00AB; Mon,  6 Jul 2026 02:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B0F6B00AC; Mon,  6 Jul 2026 02:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9DA6B00AA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14B7D402C7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:03 +0000 (UTC)
X-FDA: 84957351486.11.167247B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A6B220005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=i7xt5R+Pea2R6utauhdDjr4j4+vRdNjb2gyeFxHYtfI=;
	b=Yp8wPwVgXlD6stHdeEVoZ6hlHmVev5e2ixkg77YHfQy/vIZjXwW93rBHpMQohcdI4+dAxN
	8WBPHsEh14vRDHiqv73C6JTTYBogh8EgNlxWIBCBLHVRC5hjwG5h479gVqwyWGXfotPVh8
	A0mjojgTc0M0MiojZ8dHVgAd0AB466I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318801;
	b=Xvjegyiy2C5dLo+gq3YTW1KxKzvjhy5C8tqdk5TbEaRyODt4aR46djNhvIf9ostUNn8vt+
	bVFHCnZMoMigNXSDixRkWgt/yS+glrgwwzACiwEblkqxkcpafMFDEz7xzoMoHvRU4vRHy2
	acF7W/C6EDxWclBcGfR98PDZf7A3YBI=
X-AuditID: a67dfc5b-c45ff70000001609-f0-6a4b48fce368
From: Byungchul Park <byungchul@sk.com>
To: linux-kernel@vger.kernel.org
Cc: max.byungchul.park@gmail.com,
	kernel_team@skhynix.com,
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
	linux-rt-devel@lists.linux.dev,
	2407018371@qq.com,
	dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com,
	neilb@ownmail.net,
	bagasdotme@gmail.com,
	wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com,
	geert@linux-m68k.org,
	ojeda@kernel.org,
	alex.gaynor@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: [PATCH v19 06/40] dept: distinguish each kernel context from another
Date: Mon,  6 Jul 2026 15:18:54 +0900
Message-Id: <20260706061928.66713-7-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTHfe597ks7ai7VzItGMY2CcRGmcctJROKX6ROMi86Y+Bpsxo0t
	b7oWOlmm1jENICqTFCIVx4vUCkWxTBBCN4bC1kALzAUqsMEcVstLWRrBKAijEL+c/HL+v3M+
	/Xla2cus5LWpaZIuVZ2sYuVYPh5SummW7E78+FZPCGRdOAcDg8MM9JxvxvDOXM/B4GQWgtfT
	ZhouNMxhePWmn4M5RxsCT9cvNBT6zmMo8po58LXugt6pMQSW4VkK3hUkwbSrc14wdSEI+IYQ
	PM97QMOT4aXgNF1iYbz7BgUl3zkY6O4YRVBsvobA2+egILP8HgsFxXYMDUONHHSPzlBQZd8D
	gxYvhva8MgoK7q8Ac2EmNT9eUtBRPoDBYlwPz6xFHLRVveDg7ngnA/XGIQ7sT1sR2HK9NDj6
	PoLrNwdYaHI4MbQ9fEZBbs0DBv62zTFgNL9moKu5nYH2tt8xOIvuYOh3XeWgs7GagYrebgpq
	XR00TF1ZBZ685wiq/WUs5Pu9CJ4WjnE7EkhlbR1FbDdtiLyqyKTJo7EJmlS0j7HkVvZbivzg
	2kQaiv7iSIk9ndRaN5LyJh9FSgOTDLFXZrPEHrjGkYGeJpb43W5ub+RheUyClKw1SLro2ONy
	zRXfh6eyD51uzTdhI2rcmYN4XhS2iiNmTQ6SLeDjygk2yKwQKXo8b+ggLxfWirWXvUwOkvO0
	8CRczLVcxsFgmbBHHPnvZxRkLKwXy0ZtCwcK4ROx/yc/u/g0XKyqaV7Yy4RPxbszxVSQlUFn
	4je86JTLxDt/xC1ymPir1YPzkKIELalESm2qIUWtTd4apclI1Z6O+vJkih3N181yZubIQxTo
	2t+CBB6pQhSwIy5RyagN+oyUFiTytGq5ImLD7kSlIkGd8Y2kOxmvS0+W9C1oFY9VKxRbpr5O
	UAon1GlSkiSdknTvU4qXrTQilXgmRajzG85e/JOrsfZapqPlafGh/+6LMk2W5h9csnSv5oN9
	rvokw4nQyENxEdf7Rh7pZ5elfxvjdGwJcxz9LDZ9e4vTus6d/8XnvD5WGZ9zQBZ69p/Vm931
	pq9+DDsWHr02fI39qqPO9bJ17vusiMdHkxTHx2OPNBe7A8xtunpbjArrNerNG2mdXv0/Sh//
	dGoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSWUwTcRDG/e9ut0u1ZlOJrPAANirEKN5mosaoibJKNL6IURO16kYKpZBW
	ETyigI0FrYFqi1JBBKlaKkcBtZgqoOJJuFQIp0dFK0cJUgxQwFbjy+Q3833fZB6GwkUPef6U
	VH6MU8glMjEpIAQ71qYsdrPhUUvbSgNBrToLHd12HnxMqiLANawm4EaxmYQJw0M+qC3XefCq
	JZmAhqJCBN0uNYLf4wYcVNYpAia0tXwYHm3ngy4JwZStFoG+UYtDa8NTHMzlSRj8KpkkoffZ
	EALdZzsJmY4kApzGSwiyegx8cLwIg/7uxzyY6vyOQctIHwKjfRIDe9UFBBP6aLiZV+aJ6wdJ
	GK+rxyFT14Dg1udOHIYcnxCU13YhsN1NJuFbegUOzfaZ8N7lJOG17iIJ/Y03MBgoISE32caD
	xne9CLINWgQ9bTYMUvKLSdBnWwiwfqrkQ2OvG4MOvRaDQst26Db2EPA2PQ/znOtxlfqBITMF
	85QfGOjuP8Zg1GjibyhA7G/VZYI1lT3AWFXTBMmac8yIHR/TIna4IAVnVeme9lmfE2fPl51g
	C972keyY6wPJ2kZyCfZNHsPeTh3D2Iy6xaw1q5O/c+NewbojnEwazymWrD8oiLzsmB2Xuifh
	xRUdcQ5VbklDPhRDr2Sem5ykl0k6mGltHcW97EsHMWWaHl4aElA43RzIXDJqCK8wi97O/Bx8
	grxM0POZvF7z34CQXsW0lw+Q/5YGMoUlVX/nPvRqpsidjXlZ5PU4XxLpSJCLppmQr1QeHyOR
	ylaFKqMjE+XShNDDsTEW5Hkn4xl3xiM03BxWg2gKiWcIYcO2KBFPEq9MjKlBDIWLfYULQsKj
	RMIjksSTnCL2gOK4jFPWoACKEPsJt+3mDoroo5JjXDTHxXGK/ypG+fifQzn1+ju77oRe4xzF
	83L2uzZV2AdWSFy5IZp3QebY98Hh8XWnwmaOdA0tl3csiFCvy7f+yGoaXXN10T486Oike06X
	baxadyH2XvTmUFO/dsaVr1dLv/hV/9RkzJ0+bckeu9Mie2KtOF3hH+Gqjqg/pPCvZPrC7QHn
	qa0fA11a7RZaIyaUkZJlC3GFUvIHD3HWhkoDAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A6B220005
X-Stat-Signature: y4gdjasf6sat658xzykon8mbfumjht66
X-HE-Tag: 1783318800-14642
X-HE-Meta: U2FsdGVkX1+n70gRCfu4nwenrzXlAcMXpoh0udJdrMqt7SvDs+NKBKZlXRECrSMHmwiuk6xDzR6btHtb0raBB96TxKYdWc7shw1ynOnTNwD1CUvMsIFCantxIRrY/NpVMWI7pIMnHfn1aXiLSNF7n5Dk/yRmOAv6yTyMUXtnSgi01n9a66vEnqULBO4tMYrw21z4n9mURFuy9I2W40RtVl+LKj65YAUpYvpuLM5fS/271l/Tc6HSkptRVN8RYuMl7AONyDWh4smTynqTMuxv6b7WU6g05TtSKqIfmVdeXh+mqKP/K0riUizfBB7OfJbDh3k0jkH+mgOIq3CUzQotPKspqZQ6OzhqVYQJNjubd6akzhZMh2vO8axiuLfKMeCP4SDM9SU+JAePJu5ZGnpuwGvz+vGREO3Hw59DBFk9MZEK2I1ECcp+jchaWuioQqM1GNiTvd14Hgq21cpS0cJ5hs2HV3waaLac3wh3Z7LEfJ+AcA2H3mjzzmGBl98j+1w6bIclhdHaaR4HUA2YnWb66l97LeFVInN579M0T1N0jVi9aJ0ZvTRHYpXA9FVs4BgF8VXUNoPwOvh0U2kWgtgsyDekbzPeJTKgzigT99yX29y+z3PdVckexXBohwjsCGuPJraapdgObx9ZGkIj/lnNH0qmHlLqYSzunmAdraKdKThQlmRtyLPKFEmUto9bFJI2m90woQj2VQcOacCELhNIKgIZCulYZX92Cy8URjyNLSqlK9Nf0THWql79YXbNuzytOF8gfgUy/lhUX4a+nJRs7wz312iIInjrXBK5Y7bcttZT/AF+HMII1bVzettFrllCkDVLkgsVQHWbRfHY2IXJPEebRjT3vUpVPkjQukPkWBr2iiK7h1mqxureUloJiDcGAoT9z6BZrPJXhZ82kvlYENkyHDipziERXgdGsCTxlIjwzdKycLaK0tL0lzwa/2QetvrweaWvXYatfw68Rke
 agLTBAiI
 xjpsJurtqTtWoa7rph9/ZyFYoVuQa2Sddygd1nzUS+qDhYz1vBpRd1khBlHhz5fFstvqjwB6oxR0qMePfUs0KIUag6yqyDkLf8f60YI4sdgpy+TpHKqBb1Jf5cCntYPT1qcwfIX3WQ1lYGlYhg4vawrTV3euTksCqzL7Ork/vx9XuqtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each unique kernel context, in dept's point of view, should be
identified on every entrance to kernel mode e.g. system call or user
oriented fault.  Otherwise, dept may track meaningless dependencies
across different kernel context.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept.h              | 17 +++++---
 include/linux/irq-entry-common.h  |  4 ++
 include/linux/sched.h             | 10 ++---
 kernel/dependency/dept.c          | 67 ++++++++++++++++---------------
 kernel/dependency/dept_internal.h | 12 +++---
 5 files changed, 61 insertions(+), 49 deletions(-)

diff --git a/include/linux/dept.h b/include/linux/dept.h
index b1c55305be17..0b012d3799f2 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -24,11 +24,16 @@ struct task_struct;
 #define DEPT_MAX_SUBCLASSES_USR		(DEPT_MAX_SUBCLASSES / DEPT_MAX_SUBCLASSES_EVT)
 #define DEPT_MAX_SUBCLASSES_CACHE	2
 
-#define DEPT_SIRQ			0
-#define DEPT_HIRQ			1
-#define DEPT_IRQS_NR			2
-#define DEPT_SIRQF			(1UL << DEPT_SIRQ)
-#define DEPT_HIRQF			(1UL << DEPT_HIRQ)
+enum {
+	DEPT_CXT_SIRQ = 0,
+	DEPT_CXT_HIRQ,
+	DEPT_CXT_IRQS_NR,
+	DEPT_CXT_PROCESS = DEPT_CXT_IRQS_NR,
+	DEPT_CXTS_NR
+};
+
+#define DEPT_SIRQF			(1UL << DEPT_CXT_SIRQ)
+#define DEPT_HIRQF			(1UL << DEPT_CXT_HIRQ)
 
 struct dept_key {
 	union {
@@ -146,6 +151,7 @@ void dept_event(struct dept_map *m, unsigned long e_f, unsigned long ip, const c
 void dept_ecxt_exit(struct dept_map *m, unsigned long e_f, unsigned long ip);
 void dept_sched_enter(void);
 void dept_sched_exit(void);
+void dept_update_cxt(void);
 
 static inline void dept_ecxt_enter_nokeep(struct dept_map *m)
 {
@@ -193,6 +199,7 @@ struct dept_map { };
 #define dept_ecxt_exit(m, e_f, ip)			do { } while (0)
 #define dept_sched_enter()				do { } while (0)
 #define dept_sched_exit()				do { } while (0)
+#define dept_update_cxt()				do { } while (0)
 #define dept_ecxt_enter_nokeep(m)			do { } while (0)
 #define dept_key_init(k)				do { (void)(k); } while (0)
 #define dept_key_destroy(k)				do { (void)(k); } while (0)
diff --git a/include/linux/irq-entry-common.h b/include/linux/irq-entry-common.h
index d26d1b1bcbfb..37ef4f20bdc4 100644
--- a/include/linux/irq-entry-common.h
+++ b/include/linux/irq-entry-common.h
@@ -9,6 +9,7 @@
 #include <linux/syscalls.h>
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
+#include <linux/dept.h>
 
 #include <asm/entry-common.h>
 
@@ -88,6 +89,9 @@ static __always_inline bool arch_in_rcu_eqs(void) { return false; }
  */
 static __always_inline void enter_from_user_mode(struct pt_regs *regs)
 {
+	/* Make dept work with a new context. */
+	dept_update_cxt();
+
 	arch_enter_from_user_mode(regs);
 	lockdep_hardirqs_off(CALLER_ADDR0);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 11c2efbf59b3..63360eb2301a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -833,19 +833,19 @@ struct dept_task {
 	int				wait_hist_pos;
 
 	/*
-	 * sequential id to identify each IRQ context
+	 * sequential id to identify each context
 	 */
-	unsigned int			irq_id[DEPT_IRQS_NR];
+	unsigned int			cxt_id[DEPT_CXTS_NR];
 
 	/*
 	 * for tracking IRQ-enabled points with cross-event
 	 */
-	unsigned int			wgen_enirq[DEPT_IRQS_NR];
+	unsigned int			wgen_enirq[DEPT_CXT_IRQS_NR];
 
 	/*
 	 * for keeping up-to-date IRQ-enabled points
 	 */
-	unsigned long			enirq_ip[DEPT_IRQS_NR];
+	unsigned long			enirq_ip[DEPT_CXT_IRQS_NR];
 
 	/*
 	 * for reserving a current stack instance at each operation
@@ -899,7 +899,7 @@ struct dept_task {
 	.wait_hist = { { .wait = NULL, } },			\
 	.ecxt_held_pos = 0,					\
 	.wait_hist_pos = 0,					\
-	.irq_id = { 0U },					\
+	.cxt_id = { 0U },					\
 	.wgen_enirq = { 0U },					\
 	.enirq_ip = { 0UL },					\
 	.stack = NULL,						\
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index fd091ae28ae2..1c4de1b55730 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -230,9 +230,9 @@ static struct dept_class *dep_tc(struct dept_dep *d)
 
 static const char *irq_str(int irq)
 {
-	if (irq == DEPT_SIRQ)
+	if (irq == DEPT_CXT_SIRQ)
 		return "softirq";
-	if (irq == DEPT_HIRQ)
+	if (irq == DEPT_CXT_HIRQ)
 		return "hardirq";
 	return "(unknown)";
 }
@@ -410,7 +410,7 @@ static void initialize_class(struct dept_class *c)
 {
 	int i;
 
-	for (i = 0; i < DEPT_IRQS_NR; i++) {
+	for (i = 0; i < DEPT_CXT_IRQS_NR; i++) {
 		struct dept_iecxt *ie = &c->iecxt[i];
 		struct dept_iwait *iw = &c->iwait[i];
 
@@ -436,7 +436,7 @@ static void initialize_ecxt(struct dept_ecxt *e)
 {
 	int i;
 
-	for (i = 0; i < DEPT_IRQS_NR; i++) {
+	for (i = 0; i < DEPT_CXT_IRQS_NR; i++) {
 		e->enirq_stack[i] = NULL;
 		e->enirq_ip[i] = 0UL;
 	}
@@ -452,7 +452,7 @@ static void initialize_wait(struct dept_wait *w)
 {
 	int i;
 
-	for (i = 0; i < DEPT_IRQS_NR; i++) {
+	for (i = 0; i < DEPT_CXT_IRQS_NR; i++) {
 		w->irq_stack[i] = NULL;
 		w->irq_ip[i] = 0UL;
 	}
@@ -491,7 +491,7 @@ static void destroy_ecxt(struct dept_ecxt *e)
 {
 	int i;
 
-	for (i = 0; i < DEPT_IRQS_NR; i++)
+	for (i = 0; i < DEPT_CXT_IRQS_NR; i++)
 		if (e->enirq_stack[i])
 			put_stack(e->enirq_stack[i]);
 	if (e->class)
@@ -507,7 +507,7 @@ static void destroy_wait(struct dept_wait *w)
 {
 	int i;
 
-	for (i = 0; i < DEPT_IRQS_NR; i++)
+	for (i = 0; i < DEPT_CXT_IRQS_NR; i++)
 		if (w->irq_stack[i])
 			put_stack(w->irq_stack[i]);
 	if (w->class)
@@ -665,7 +665,7 @@ static void print_diagram(struct dept_dep *d)
 	const char *tc_n = tc->sched_map ? "<sched>" : (tc->name ?: "(unknown)");
 
 	irqf = e->enirqf & w->irqf;
-	for_each_set_bit(irq, &irqf, DEPT_IRQS_NR) {
+	for_each_set_bit(irq, &irqf, DEPT_CXT_IRQS_NR) {
 		if (!firstline)
 			pr_warn("\nor\n\n");
 		firstline = false;
@@ -698,7 +698,7 @@ static void print_dep(struct dept_dep *d)
 	const char *tc_n = tc->sched_map ? "<sched>" : (tc->name ?: "(unknown)");
 
 	irqf = e->enirqf & w->irqf;
-	for_each_set_bit(irq, &irqf, DEPT_IRQS_NR) {
+	for_each_set_bit(irq, &irqf, DEPT_CXT_IRQS_NR) {
 		pr_warn("%s has been enabled:\n", irq_str(irq));
 		print_ip_stack(e->enirq_ip[irq], e->enirq_stack[irq]);
 		pr_warn("\n");
@@ -866,7 +866,7 @@ static void bfs(void *root, struct bfs_ops *ops, void *in, void **out)
  */
 
 static unsigned long cur_enirqf(void);
-static int cur_irq(void);
+static int cur_cxt(void);
 static unsigned int cur_ctxt_id(void);
 
 static struct dept_iecxt *iecxt(struct dept_class *c, int irq)
@@ -1443,7 +1443,7 @@ static void add_dep(struct dept_ecxt *e, struct dept_wait *w)
 	if (d) {
 		check_dl_bfs(d);
 
-		for (i = 0; i < DEPT_IRQS_NR; i++) {
+		for (i = 0; i < DEPT_CXT_IRQS_NR; i++) {
 			struct dept_iwait *fiw = iwait(fc, i);
 			struct dept_iecxt *found_ie;
 			struct dept_iwait *found_iw;
@@ -1487,7 +1487,7 @@ static void add_wait(struct dept_class *c, unsigned long ip,
 	struct dept_task *dt = dept_task();
 	struct dept_wait *w;
 	unsigned int wg;
-	int irq;
+	int cxt;
 	int i;
 
 	if (DEPT_WARN_ON(!valid_class(c)))
@@ -1503,9 +1503,9 @@ static void add_wait(struct dept_class *c, unsigned long ip,
 	w->wait_stack = get_current_stack();
 	w->sched_sleep = sched_sleep;
 
-	irq = cur_irq();
-	if (irq < DEPT_IRQS_NR)
-		add_iwait(c, irq, w);
+	cxt = cur_cxt();
+	if (cxt == DEPT_CXT_HIRQ || cxt == DEPT_CXT_SIRQ)
+		add_iwait(c, cxt, w);
 
 	/*
 	 * Avoid adding dependency between user aware nested ecxt and
@@ -1579,7 +1579,7 @@ static struct dept_ecxt_held *add_ecxt(struct dept_map *m,
 	eh->sub_l = sub_l;
 
 	irqf = cur_enirqf();
-	for_each_set_bit(irq, &irqf, DEPT_IRQS_NR)
+	for_each_set_bit(irq, &irqf, DEPT_CXT_IRQS_NR)
 		add_iecxt(c, irq, e, false);
 
 	del_ecxt(e);
@@ -1728,7 +1728,7 @@ static void do_event(struct dept_map *m, struct dept_map *real_m,
 			add_dep(eh->ecxt, wh->wait);
 	}
 
-	for (i = 0; i < DEPT_IRQS_NR; i++) {
+	for (i = 0; i < DEPT_CXT_IRQS_NR; i++) {
 		struct dept_ecxt *e;
 
 		if (before(dt->wgen_enirq[i], wg))
@@ -1775,7 +1775,7 @@ static void disconnect_class(struct dept_class *c)
 		call_rcu(&d->rh, del_dep_rcu);
 	}
 
-	for (i = 0; i < DEPT_IRQS_NR; i++) {
+	for (i = 0; i < DEPT_CXT_IRQS_NR; i++) {
 		stale_iecxt(iecxt(c, i));
 		stale_iwait(iwait(c, i));
 	}
@@ -1800,27 +1800,21 @@ static unsigned long cur_enirqf(void)
 	return 0UL;
 }
 
-static int cur_irq(void)
+static int cur_cxt(void)
 {
 	if (lockdep_softirq_context(current))
-		return DEPT_SIRQ;
+		return DEPT_CXT_SIRQ;
 	if (lockdep_hardirq_context())
-		return DEPT_HIRQ;
-	return DEPT_IRQS_NR;
+		return DEPT_CXT_HIRQ;
+	return DEPT_CXT_PROCESS;
 }
 
 static unsigned int cur_ctxt_id(void)
 {
 	struct dept_task *dt = dept_task();
-	int irq = cur_irq();
+	int cxt = cur_cxt();
 
-	/*
-	 * Normal process context
-	 */
-	if (irq == DEPT_IRQS_NR)
-		return 0U;
-
-	return dt->irq_id[irq] | (1UL << irq);
+	return dt->cxt_id[cxt] | (1UL << cxt);
 }
 
 static void enirq_transition(int irq)
@@ -1877,7 +1871,7 @@ static void dept_enirq(unsigned long ip)
 
 	flags = dept_enter();
 
-	for_each_set_bit(irq, &irqf, DEPT_IRQS_NR) {
+	for_each_set_bit(irq, &irqf, DEPT_CXT_IRQS_NR) {
 		dt->enirq_ip[irq] = ip;
 		enirq_transition(irq);
 	}
@@ -1923,6 +1917,13 @@ void noinstr dept_hardirqs_off(void)
 	dept_task()->hardirqs_enabled = false;
 }
 
+void noinstr dept_update_cxt(void)
+{
+	struct dept_task *dt = dept_task();
+
+	dt->cxt_id[DEPT_CXT_PROCESS] += 1UL << DEPT_CXTS_NR;
+}
+
 /*
  * Ensure it's the outmost softirq context.
  */
@@ -1930,7 +1931,7 @@ void dept_softirq_enter(void)
 {
 	struct dept_task *dt = dept_task();
 
-	dt->irq_id[DEPT_SIRQ] += 1UL << DEPT_IRQS_NR;
+	dt->cxt_id[DEPT_CXT_SIRQ] += 1UL << DEPT_CXTS_NR;
 }
 
 /*
@@ -1940,7 +1941,7 @@ void noinstr dept_hardirq_enter(void)
 {
 	struct dept_task *dt = dept_task();
 
-	dt->irq_id[DEPT_HIRQ] += 1UL << DEPT_IRQS_NR;
+	dt->cxt_id[DEPT_CXT_HIRQ] += 1UL << DEPT_CXTS_NR;
 }
 
 void dept_sched_enter(void)
diff --git a/kernel/dependency/dept_internal.h b/kernel/dependency/dept_internal.h
index 732f297710aa..f5023365b3fd 100644
--- a/kernel/dependency/dept_internal.h
+++ b/kernel/dependency/dept_internal.h
@@ -106,8 +106,8 @@ struct dept_class {
 			/*
 			 * for tracking IRQ dependencies
 			 */
-			struct dept_iecxt iecxt[DEPT_IRQS_NR];
-			struct dept_iwait iwait[DEPT_IRQS_NR];
+			struct dept_iecxt iecxt[DEPT_CXT_IRQS_NR];
+			struct dept_iwait iwait[DEPT_CXT_IRQS_NR];
 
 			/*
 			 * classified by a map embedded in task_struct,
@@ -169,8 +169,8 @@ struct dept_ecxt {
 			/*
 			 * where the IRQ-enabled happened
 			 */
-			unsigned long	enirq_ip[DEPT_IRQS_NR];
-			struct dept_stack *enirq_stack[DEPT_IRQS_NR];
+			unsigned long	enirq_ip[DEPT_CXT_IRQS_NR];
+			struct dept_stack *enirq_stack[DEPT_CXT_IRQS_NR];
 
 			/*
 			 * where the event context started
@@ -214,8 +214,8 @@ struct dept_wait {
 			/*
 			 * where the IRQ wait happened
 			 */
-			unsigned long	irq_ip[DEPT_IRQS_NR];
-			struct dept_stack *irq_stack[DEPT_IRQS_NR];
+			unsigned long	irq_ip[DEPT_CXT_IRQS_NR];
+			struct dept_stack *irq_stack[DEPT_CXT_IRQS_NR];
 
 			/*
 			 * where the wait happened
-- 
2.17.1


