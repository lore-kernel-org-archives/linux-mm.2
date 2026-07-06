Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 699E9C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81ADF6B00A7; Mon,  6 Jul 2026 02:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC3D6B00AA; Mon,  6 Jul 2026 02:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690C26B00AB; Mon,  6 Jul 2026 02:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 375926B00A7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B31131C1EBA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:00 +0000 (UTC)
X-FDA: 84957351360.03.9051E96
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 74B9320002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:19:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=7rjdkOM5Vc9bkp6hoj4JQEjZEaNxMT/uvb/Yhl9f0hU=;
	b=unhUOTBGi+U97O6cdsQ+5osOrLYdY6MNAfS/SGuEMMmkhFGsVOdcJtBc1PVwM+2sjcA71S
	eZDZxlwQzc5FxxicX02kb1sc/qW2iCUG+KX532qHq9q68qL+vEmCi/zVtrwEBHfERKLk0u
	e42JdtiPJW7N2WRxZM+UNY9zmFmoPMA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318799;
	b=g3IASYY2snCpgnjKApWXlLUJYIaQeOsnbZNNzSyYHH/ycZihoPnoFhPGAFjEXSZwQJCfnG
	vjOxDo/4KI0400iKXx14NDjgILrykWhqP7Wd3BIYMiAIoaM7ZfBt/N6PWg5u4CJ5tA/6Nx
	rkM0TmFTuotHPZwDXXXblcy2Kuv5WJk=
X-AuditID: a67dfc5b-c45ff70000001609-d0-6a4b48fc170e
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
Subject: [PATCH v19 05/40] dept: add proc knobs to show stats and dependency graph
Date: Mon,  6 Jul 2026 15:18:53 +0900
Message-Id: <20260706061928.66713-6-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0yTZxTGed/vSkP1S0fiNyaRdFEnBB3EmRN3CZmafJFkGpaY6Uy0kS9S
	1gIpirLE0TEKHUHEJi1ii6s4GuRa2igXV4IkVgxzymXQQRBQhCmgDim3Al0B/efkl+c5z3P+
	OSwh66PCWGXKGVGTolDJaQkpmQopi14W4pM/Nds3g16XBd4ZPQmWumoals0NDLT3ZZMw5NUj
	mPOZCdA1+UlYNrgZmFkYYMD4MwK/y43A1Gkg4K19hYapoTsU+AfHMfTNTiKwja5gGG3NQ/Bb
	mZOGCdMbGnwPHxFQbHyM4PrIIAGuimwaukc3QI/3dSDfacHwyk6DNdtFwVi/C4Op1EFC03Az
	A50TSxiGbGMkdBSVYSh+QYOpfhOYi3/BgfEvBmPNHQwLtkoGbNqtsDQSA35rKrirxhl48KSX
	gqH7uRQ0aIcZcPxzD8FMzwgGfbOXBMezgOvqjwJ341MM3c0WGgrstyh4Uu2nQGueo6Bu3IOh
	w91OwqPmGgrK+zoxjAx7qLhEYU5XSAqVzttY0HUt00L1tWok+BYNSNAVBSjHeU4o75ikhUXv
	37TgmrWSQtPVQUbIaelnBKvjrOCsiBRu/PECC9envdTh2GOSLxJFlTJD1Oz66qQkqcVwm0nz
	bj8/Od9LaVFDRD4KZnluN+9pMpLv2ehrpVeZ5rbzHs8CscqhXATvvDhG5SMJS3DdW/gC28W1
	wAdcAq+7UobyEcuS3Fb+5fw3q7KU+4yvKC7H651b+Cp761pPMLeHr10qXdNlgZ2B1/ff3b0R
	zBssh9b5Q/5uhYcsQlIrCqpEMmVKhlqhVO3emZSZojy/81Sq2oEC72a7sPR9I5p+/G0b4lgk
	D5FC3MFkGaXISM9UtyGeJeSh0m2fxCfLpImKzB9FTeoJzVmVmN6GPmJJ+SZp7Oy5RBl3WnFG
	/EEU00TNexezwWFaFGVuoW2xiyU/ha6YjpD1QbIdHzdO0VGSz/8L/7Mu4bvjWRs3lIZdummR
	7908rq/R5OSwR2sGvo7jIiZV2x7e/Gs6b//+A0m/d706kltw2Web/zVDo1LXOuLfxIRJ2tN6
	WvZhFK2yRhc67F29ufWGoHDZ3renn5cUeksi5eov7aZIOZmepIiJJDTpiv8B+kXnZWoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzVSe0hTcRjtd+/dvdfh4rIML/mHMiorsAc9+CApo8CL9pAIAiVq1SXnY8lm
	lj2wqUObj2y0Lbc0XTlEzWyzzGQmSvZGzVJ7mEXLMjXNnM/NNY3++TjfOec7nD8+GhfXCZbR
	Mnkyr5BLEySkkBDu3ZoR4uIi49ZranwhW50GH/scAuhSNRHgHM8m4PqdKhLcpjoKsq2FAnja
	nU5Ae3Ulgj5nNoLJWRMO6noPAW5tKwXj0x8o0KkQeOytCPQdWhx62h/hUFWrwuBPzRwJgy1j
	CHRfHCQYBlQEjFhyERj7TRQMPA6H4b4GAXh6v2PQPTGEwOKYw8DRlIXArY+HG2ab91w/SsLs
	qzYcDLp2BKVfenEYG/iMoLb1EwJ7eToJ3wru4dDpWAxvnCMkPNPlkDDccR2DXzUklKTbBdDx
	chBBkUmLoP+9HYOMm3dI0BdZCaj//JCCjkEXBh/1WgwqrXugz9JPwIsCM+at63Xd9QeTIQPz
	jh8Y6G43YDBtqaDCyhA3qc4nuArbfYxTv3aTXFVxFeJmZ7SIGy/LwDl1gXdtGRrBuUzbaa7s
	xRDJzTjfkpx9ooTgnptZ7talGYy78iqEqzf2UlE7ooWhx/kEWQqvWLftiDC2UXufSnIGnxma
	6hJcRHVBGuRDs8wmVjfbRM5jkglme3qm8XnsxwSxtrx+gQYJaZzpDGRzLXnEvLCE2c+qr5mR
	BtE0waxgf07tnadFzGa23FCG/csMZCtrmhZyfJgtbLWraIEXez0fRp4QBUhYghZVID+ZPCVR
	KkvYvFYZH5sql51Ze+xkohV538lywXXlARrvDG9GDI0kviIIi4gTC6QpytTEZsTSuMRPtHJV
	ZJxYdFyaepZXnDysOJXAK5tRAE1I/EURB/kjYuaENJmP5/kkXvFfxWifZRdRqG3VhtWLzxWu
	EBZPyQ8WFm8b/ood6m5LDphb2rlPlVuaGRPu19t42eDenhWdFF5dbzx2bWOWzKi0dvsGvws6
	/DZkbrm6pasrynLgAJxHgWGu3Ae/03bH1OY9c73J8c8v91xNPZqiifOxR41anaErg8Cz3li3
	a+r0w+ZfO81Um0pCKGOlG9bgCqX0LwBrjGNKAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 74B9320002
X-Stat-Signature: pf49mqyod4ut1gi4uqucz5sk73jniceg
X-HE-Tag: 1783318798-971784
X-HE-Meta: U2FsdGVkX1/vZAIlqVZWQTYJxxgoSnyW01v2feztiYgloXUxb7peCuSNuMDKWSR27utwRGkFDeRhLTr3D1THXO++zqqd/1G2wlgaDNmTCPcN/muCyNtIyrjX/qh3KDSfHYuffWaxcpY51eCPLdoCEPO0UapIOXho4KgQcPrGRCVQi1H4a7Lu5HufYbANYGVNIoiPVGthQPZZChsiIKmq2VK0VBLGnre5SnIGSCjT82qL0wLT8ZRcjBT95jE9nYu8j02RnkfINy73mkgoVHzvFx0jxA3s66YzyE+LlGO/gwRqchK/tXK42VKPHcXAC2X6hMJtb0ovuXkHabdPaenH2+8LeiFzzahbGYK9joo5YcPrINGJSikWAYd22m6kDKCFdg0r+mjVSYJTKoC4MhqhHvAAEoaTWqA8tUrhEZT2Y+YNZtRTKaEWHNlo6cVxNuBl6rdfG36OwknjMf8FyEE0/685nr279Dz6lqlaS/1l/2nxZypaBx26+L9ykzDkI6V9QysRbDSB6R++EWiV1RJuyFDvwMm/jgLu9iWymnpnfmlZTP0LCyo7McDLA7LTjXPsXQJhiRD+hJjK3CCSLh4oAk2vtsLM5GJ1dhZK3I+Yxi8HFAZ+/dNgMQsheQRB3F6yMFyTCgYUbxsvIlWUwWIwCmqJtkIa7Edct8389oWCgXUSK0S0NhCE41sZQ9DdsLUETN0zR13099MJ8fWFGmtgKzsQI2qfp5QeRssD8l3e1OPTCL8wgbOIY4AdF/VZZo9XpKY4btxAGSue0v2JwenlnbWAIdMYx2TK/Gtww1tRhiRkc2W/rZJSDbeKTvWGwDIWqMYc5FAvseGT3Oua3qFBCpVrVbEV30zx6Q9yKmqFYGRORB5Z9xZ8WT7CAZuISYyVisEeLN41A5P3MQTQWongY3CyE7vac+lLG05fa22PwnukWW56cxEqIx+H0wHKupeHSSvDyUru9KM/8QI1p3j
 HtqZzETA
 yz3tvI5Zg8z79NnY+g8ZQKNTaxq2nGM9rfFhYk4IIZn7A+wM9CeULw9rdmLqb5wvKTZaWqYxxnIqmvFHDekK4ggnHyDOpaJqzWs2c/6PONxKa33fBdcpMGfaeDnbIoUjobcEAwt4a2x0iFdrEFTa8imrTfoadPvnLbJw2r9Z7uW4JMfwOlf0wyDLrub//Di/wGeGR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It'd be useful to show dept internal stats and dependency graph on
runtime via proc for better information.  Introduce the knobs.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/dependency/Makefile        |  1 +
 kernel/dependency/dept.c          | 11 +---
 kernel/dependency/dept_internal.h | 10 ++++
 kernel/dependency/dept_proc.c     | 96 +++++++++++++++++++++++++++++++
 4 files changed, 109 insertions(+), 9 deletions(-)
 create mode 100644 kernel/dependency/dept_proc.c

diff --git a/kernel/dependency/Makefile b/kernel/dependency/Makefile
index b5cfb8a03c0c..92f165400187 100644
--- a/kernel/dependency/Makefile
+++ b/kernel/dependency/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_DEPT) += dept.o
+obj-$(CONFIG_DEPT) += dept_proc.o
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 47fef2207af1..fd091ae28ae2 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -266,20 +266,13 @@ static bool valid_key(struct dept_key *k)
  *       have been freed will be placed there.
  */
 
-enum object_t {
-#define OBJECT(id, nr) OBJECT_##id,
-	#include "dept_object.h"
-#undef OBJECT
-	OBJECT_NR,
-};
-
 #define OBJECT(id, nr)							\
 static struct dept_##id spool_##id[nr];					\
 static DEFINE_PER_CPU(struct llist_head, lpool_##id);
 	#include "dept_object.h"
 #undef OBJECT
 
-static struct dept_pool dept_pool[OBJECT_NR] = {
+struct dept_pool dept_pool[OBJECT_NR] = {
 #define OBJECT(id, nr) {						\
 	.name = #id,							\
 	.obj_sz = sizeof(struct dept_##id),				\
@@ -2083,7 +2076,7 @@ void dept_map_copy(struct dept_map *to, struct dept_map *from)
 	clean_classes_cache(&to->map_key);
 }
 
-static LIST_HEAD(dept_classes);
+LIST_HEAD(dept_classes);
 
 static bool within(const void *addr, void *start, unsigned long size)
 {
diff --git a/kernel/dependency/dept_internal.h b/kernel/dependency/dept_internal.h
index 04c040dbcbc8..732f297710aa 100644
--- a/kernel/dependency/dept_internal.h
+++ b/kernel/dependency/dept_internal.h
@@ -279,5 +279,15 @@ struct dept_hash {
 	int				bits;
 };
 
+enum object_t {
+#define OBJECT(id, nr) OBJECT_##id,
+	#include "dept_object.h"
+#undef OBJECT
+	OBJECT_NR,
+};
+
+extern struct list_head dept_classes;
+extern struct dept_pool dept_pool[];
+
 #endif
 #endif /* __DEPT_INTERNAL_H */
diff --git a/kernel/dependency/dept_proc.c b/kernel/dependency/dept_proc.c
new file mode 100644
index 000000000000..97beaf397715
--- /dev/null
+++ b/kernel/dependency/dept_proc.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Procfs knobs for Dept(DEPendency Tracker)
+ *
+ * Started by Byungchul Park <max.byungchul.park@gmail.com>:
+ *
+ *  Copyright (C) 2021 LG Electronics, Inc. , Byungchul Park
+ *  Copyright (C) 2024 SK hynix, Inc. , Byungchul Park
+ */
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/dept.h>
+#include "dept_internal.h"
+
+static void *l_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	/*
+	 * XXX: Serialize list traversal if needed. The following might
+	 * give a wrong information on contention.
+	 */
+	return seq_list_next(v, &dept_classes, pos);
+}
+
+static void *l_start(struct seq_file *m, loff_t *pos)
+{
+	/*
+	 * XXX: Serialize list traversal if needed. The following might
+	 * give a wrong information on contention.
+	 */
+	return seq_list_start_head(&dept_classes, *pos);
+}
+
+static void l_stop(struct seq_file *m, void *v)
+{
+}
+
+static int l_show(struct seq_file *m, void *v)
+{
+	struct dept_class *fc = list_entry(v, struct dept_class, all_node);
+	struct dept_dep *d;
+	const char *prefix;
+
+	if (v == &dept_classes) {
+		seq_puts(m, "All classes:\n\n");
+		return 0;
+	}
+
+	prefix = fc->sched_map ? "<sched> " : "";
+	seq_printf(m, "[%p] %s%s\n", (void *)fc->key, prefix, fc->name);
+
+	/*
+	 * XXX: Serialize list traversal if needed. The following might
+	 * give a wrong information on contention.
+	 */
+	list_for_each_entry(d, &fc->dep_head, dep_node) {
+		struct dept_class *tc = d->wait->class;
+
+		prefix = tc->sched_map ? "<sched> " : "";
+		seq_printf(m, " -> [%p] %s%s\n", (void *)tc->key, prefix, tc->name);
+	}
+	seq_puts(m, "\n");
+
+	return 0;
+}
+
+static const struct seq_operations dept_deps_ops = {
+	.start	= l_start,
+	.next	= l_next,
+	.stop	= l_stop,
+	.show	= l_show,
+};
+
+static int dept_stats_show(struct seq_file *m, void *v)
+{
+	int r;
+
+	seq_puts(m, "Availability in the static pools:\n\n");
+#define OBJECT(id, nr)							\
+	r = atomic_read(&dept_pool[OBJECT_##id].obj_nr);		\
+	if (r < 0)							\
+		r = 0;							\
+	seq_printf(m, "%s\t%d/%d(%d%%)\n", #id, r, nr, (r * 100) / (nr));
+	#include "dept_object.h"
+#undef  OBJECT
+
+	return 0;
+}
+
+static int __init dept_proc_init(void)
+{
+	proc_create_seq("dept_deps", S_IRUSR, NULL, &dept_deps_ops);
+	proc_create_single("dept_stats", S_IRUSR, NULL, dept_stats_show);
+	return 0;
+}
+
+__initcall(dept_proc_init);
-- 
2.17.1


