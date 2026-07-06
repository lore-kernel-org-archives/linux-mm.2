Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52973C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC5A6B0107; Mon,  6 Jul 2026 02:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86A16B0108; Mon,  6 Jul 2026 02:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D277B6B0109; Mon,  6 Jul 2026 02:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 977FC6B0107
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:22:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EDE2C1277
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:15 +0000 (UTC)
X-FDA: 84957357030.23.0615D00
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0807D20002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=NZTymmHRPI7bYeQm7xfqby+S3rZlaPRz/THs2Vy52mE=;
	b=rEs8psCO1W8G8kBJIiUmQMoJiA296YW39CtL5ntPvj4wbfHaPeb0qrlkXqYLqvo3u8zU36
	HK8qPWtdljsOzQBtoOkSw0dI00Uv8a8qP80Fx4Xh0nEkDAGA4AA0QZ3VRwzzGAoEN7RhS0
	2ypsuloFAh9LDdZW/8lV8prvsqM2u9Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318933;
	b=0zEzwMXAunlqO+YAVvfumo0Ymx/IiQbGdFF6Sqs7jjdeqq/4rbBvGnfDFAf8RxBBSG5hA4
	9EDxGFvoQQD/pgtpqX8Q/i6AmzJ4m5hlqTR8NMdz/tY14abTdoDtpihHU3ACqr7HcrWkH1
	/d96I1RkkyOLUtHjdOwg6o9VjDPJjUs=
X-AuditID: a67dfc5b-c2dff70000001609-81-6a4b4984d611
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
Subject: [PATCH v19 40/40] dept: implement a basic unit test for dept
Date: Mon,  6 Jul 2026 15:19:28 +0900
Message-Id: <20260706061928.66713-41-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTdxiH/Z87DZ0n1cSjfoA0cRoTEBbQ1zszmTleY7K4ecvkZD2RQluw
	CFgj2iidtSLDZqC2w3CzQSmDFMU67eSiVaEqFaNFbgoIkoIkIDK1gBTjlzdPnl/e3/vlZXBZ
	K7mAUWoOiVqNoJJTEkIyFFoUYdi0JTHK2MKC0XAc2rt6Sfi70k7BhPUGDV1jRgTjn604GG5O
	ETBhdtMw5XIjyPeacfA138FhtGqSAn/DCAJLn5WGoa5bJLz4MIjA1juJQW/tKQTX3J0IXGUn
	KHiTex2Hlt7v4NnYMAXvqigoPOEiwevxIyiwmhH0vXRhcLKkkoL8AgcBXn8Ag/Z8Mwbljm3Q
	lFuMwfkBCqznT2LT4y0GeRW3MLDpF0F3mYWGwOtomCpMBnd5Pw0df+YR8LDzOQk39K9ocLTe
	Q2DP7sPB0TPtiv4oJeDipXYKbrseEmCceI/A7ezGoNM+RYLeOk5Cc20TCU/Lmwmo7Pdh0OR+
	QMCTfytIuPzCi0H1Iw8OFe+KqTgFP27IIXjD0wmKt1+yI/7zJzPiGwaHcf5y0yDFNxZzfOnp
	Txh/7lEEf9PSQfNZ/72k+UJHGp91d4jkq8uW8iW3BzC+aGSM3BG1R7JGIaqU6aJ22bp4ScJf
	rUYipX794bz//bgenYk1IYbh2Bgu0K0woZAZ7Bptw4JMsYs5n+8jHuS5bDhXfbaPNCEJg7Mt
	YVy27SwRDOawP3HeKy46yAS7iPM+Lp3xUnY5Z3K24V9Lw7jyqtoZDpn2/wQKZg7I2Fiubfg+
	ESzl2JIQLrumh/q6MJ+rK/MRuUhaiGZdRTKlJl0tKFUxkQk6jfJw5O/JageafjhbZmCvE400
	/1yPWAbJQ6UQtzlRRgrpqTp1PeIYXD5X+v2SLYkyqULQHRG1yfu1aSoxtR4tZAj5POkPHzIU
	MvaAcEhMEsUUUfstxZiQBXoUv69xV1jNrCU1ku2rmIOCKWpXeI5/dlLPwFqm5dymO56smLUx
	R3ZvrdPsXBGZ0xFf6ozQVQ+EW/bHLxz179x6zKmLe/JbyuKjsZXR47/2vLrbaHJkSOLCN/af
	qmvYHfHL6rQDk+oLmiRXtmqF7b1XnSm8nbR4Mjf8+BrL4KwrQ6975ERqghC9FNemCl8A1xKT
	4GwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+917dzdHi8uSvBn0GD3VHkbKiV4WVLciiwiiItstLzkfS7Yy
	7UHpXC0fNVeb1LLMdKWzWq7SKSNRMnuYTistsxWs1VBTTCvfTaN/Dp/z/Z7XH0eAi8t4/gKZ
	/AinkLOxElJICMNXqBambtoSvcT2VQIa9Wn46HTx4F1yJQF9vRoCrt0vJmHYWMoHTckVHtQ2
	pxDQcM+MwNmnQfB70IiD2jZKwLCuhg+9/a180CcjGLXXIDA4dDi0NDzBofhhMgY/LSMktFf3
	INB/cZGQ7UkmoMuUgeCq28gHz9ON0Oms4MFo2zcMmn91IDC5RjBwVZ5DMGyIgRt5Vm+7oZuE
	wbp6HLL1DQhufmnDocfzGcHDmk8I7HdSSPiqfYRDk2sSvOnrIuG5Pp2ETsc1DH5YSMhNsfPA
	8aodQY5Rh8D9wY6B6tZ9Egw5JQTYPpfzwdE+hMFHgw4Dc8lWcJrcBLzU5mHec71VD/zAmK3C
	vOE7Bvq7FRj0m4r4YQWI+a2+QDBF1scYo24cJpni68WIGRzQIaa3QIUzaq03re7owplU6zGm
	4GUHyQz0vSUZ+69cgnmRRzP55wcwJqtuIWO72sbfvnaPcGUkFytL4BSLV0uFUZffa4j4qjWJ
	+j/t+BmUHpKGfAQ0tYx2/mzFxpik5tEtLf34GPtSM2lrppuXhoQCnGqaQWeYMokxYzK1nnYU
	2vljTFBzaMfr/HFdRIXSaWWt+L+hM2izpXKcfbz6vaGc8QViKoRu7XpGaJEwF00oQr4yeUIc
	K4sNWaSMiUqSyxIXHTwcV4K8/2Q6NZRVhnqbNlYhSoAkE0UQtjlazGMTlElxVYgW4BJf0dz5
	W6LFokg26TinOLxfcTSWU1ahaQJC4ifavIuTiqlD7BEuhuPiOcV/FxP4+J9B0kZ2dv0UqyWo
	cffz0ilZ5WL1qpgDZ3MuSwMt4cf22bXT44wb1v2pXW41e6QBmr3BQWsS02RHB0/daAjnFljl
	5b6fKmqn7ogItJ3uDr2Y1+kvuXCi83bppPqdnrqmQPfS0PRZXFJZt6pat1VamGqAk3LxjhTt
	tvUBly6KmIgC1iwhlFFscACuULJ/AYjxPnJLAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0807D20002
X-Stat-Signature: uq9opg8nigkk7xqrku8ijxpkikf6a9kg
X-Rspam-User: 
X-HE-Tag: 1783318932-245740
X-HE-Meta: U2FsdGVkX1+0DpMc/Zv2d4h+oV0z2vNKF22Yjs+6NszjAy3v0WPTInTieCSPafk2nFPb0Fl1oekQLFRC9hQ4KBJF0fdzfjrYGZxgpWNpYTgqKiNA5YkT82z81BlBRj6IfwJLuazIAtdoMMbkwg2VTDLSy7Lbhmj8u/+V6vuih+bY7cD01v35/bostm4YpiZkPLhOBO1LYWxWRpJlBVwveOPbrZu+j7MnVb7DW4Nd+8qRGGw8X7IkA+//vBjBpodYITQVOSWc4PwSmAtVTMHeDBHWWE21gzg2qUb6WQJvLg9yHQt7w7safx5TXboGliA90d33wHliqZ4Dtp2EFezLXlkjuMqm+NsE7Gu323ICMVkvQuZSJNuwS8cr6xe7yrlvpvpqmFFU2+Aec1QyzA/VGyP5QH7yxN2WIvNqAfW5BPkLPBOOpfLOBWBYCmpnWMiZ3YmEEkSlZMBYDCejGjaysGgMVL2QgNvFoYXZ9iluppZIONlkKC6aNBCMYnqe6BYOwc9y5DoL69EHnT+nUVN0GSjRbnM1jevV/WeY6DBVWqPamXERpQBvOaS/qd6mKTzctaCo1rYAY+vRraqhdKEbC7mMlLT66PLAUQwlJjvxA39XcTSFxHEzQk0t7id5tE1pFLssKgRstnAeF97N6yik9S2MpkoqKE5a93TV1VxUKueIvwRDweYJpY5Y7I/fNvh4PO9sqCkXd1J/y/rSjP/V1SFVFMr/X8pOIYi+VfSKb1KXdVDlkHlszY7/kqsw7QN4axvoR3wf2AsqcbNJeE/0bQi/Gaw4DV+vEM3jevC9VdSg2gYIJhchXMapNjGUQ+3bWSNd4ezyD5BmvqO8Q2B+ES/lHETwuJC7IKUD7dLwh9+cUGllKJFDD8Zns2SZOdHY8TNGFyrKIRpTq2WZIjYm/6tVU5FWBj50qfmhEE9euUzlPabL8MyLKh3DL0C22biw8/n2baoEExC/FecSGM7
 9Sbz3XHD
 6pfkgnrGILzHJQ3LkHzgYMnK8NE69H1rjWqXschygfhT9JVDM618GiBaz92qMaaK9dbKMk2bgHajcjLITjJqTmPuvQFQkLJVYQFF7DAT5axwDpxavLQ7zZlXKHvb7nj4SO/2wIJd6RcOVlCs1CxwMzQAuYUBX1eFQU4YpNVIFXHmXZvZf4Y6oaoglPJwXl6bjcVnA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement CONFIG_DEPT_UNIT_TEST introducing a kernel module that runs
basic unit test for dept.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept_unit_test.h     |  61 ++++++++++++
 kernel/dependency/Makefile         |   1 +
 kernel/dependency/dept.c           |  10 ++
 kernel/dependency/dept_unit_test.c | 149 +++++++++++++++++++++++++++++
 lib/Kconfig.debug                  |  12 +++
 5 files changed, 233 insertions(+)
 create mode 100644 include/linux/dept_unit_test.h
 create mode 100644 kernel/dependency/dept_unit_test.c

diff --git a/include/linux/dept_unit_test.h b/include/linux/dept_unit_test.h
new file mode 100644
index 000000000000..753ac9ac727c
--- /dev/null
+++ b/include/linux/dept_unit_test.h
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * DEPT unit test
+ *
+ * Started by Byungchul Park <max.byungchul.park@gmail.com>:
+ *
+ *  Copyright (c) 2025 SK hynix, Inc., Byungchul Park
+ */
+
+#ifndef __LINUX_DEPT_UNIT_TEST_H
+#define __LINUX_DEPT_UNIT_TEST_H
+
+#if defined(CONFIG_DEPT_UNIT_TEST) || defined(CONFIG_DEPT_UNIT_TEST_MODULE)
+struct dept_ut {
+	bool circle_detected;
+
+	int ecxt_stack_total_cnt;
+	int wait_stack_total_cnt;
+	int evnt_stack_total_cnt;
+	int ecxt_stack_valid_cnt;
+	int wait_stack_valid_cnt;
+	int evnt_stack_valid_cnt;
+};
+
+extern struct dept_ut dept_ut_results;
+
+static inline void dept_ut_circle_detect(void)
+{
+	dept_ut_results.circle_detected = true;
+}
+static inline void dept_ut_ecxt_stack_account(bool valid)
+{
+	dept_ut_results.ecxt_stack_total_cnt++;
+
+	if (valid)
+		dept_ut_results.ecxt_stack_valid_cnt++;
+}
+static inline void dept_ut_wait_stack_account(bool valid)
+{
+	dept_ut_results.wait_stack_total_cnt++;
+
+	if (valid)
+		dept_ut_results.wait_stack_valid_cnt++;
+}
+static inline void dept_ut_evnt_stack_account(bool valid)
+{
+	dept_ut_results.evnt_stack_total_cnt++;
+
+	if (valid)
+		dept_ut_results.evnt_stack_valid_cnt++;
+}
+#else
+struct dept_ut {};
+
+#define dept_ut_circle_detect() do { } while (0)
+#define dept_ut_ecxt_stack_account(v) do { } while (0)
+#define dept_ut_wait_stack_account(v) do { } while (0)
+#define dept_ut_evnt_stack_account(v) do { } while (0)
+
+#endif
+#endif /* __LINUX_DEPT_UNIT_TEST_H */
diff --git a/kernel/dependency/Makefile b/kernel/dependency/Makefile
index 92f165400187..fc584ca87124 100644
--- a/kernel/dependency/Makefile
+++ b/kernel/dependency/Makefile
@@ -2,3 +2,4 @@
 
 obj-$(CONFIG_DEPT) += dept.o
 obj-$(CONFIG_DEPT) += dept_proc.o
+obj-$(CONFIG_DEPT_UNIT_TEST) += dept_unit_test.o
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 35a3667ac8b3..bcff14f20046 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -78,8 +78,12 @@
 #include <linux/workqueue.h>
 #include <linux/irq_work.h>
 #include <linux/vmalloc.h>
+#include <linux/dept_unit_test.h>
 #include "dept_internal.h"
 
+struct dept_ut dept_ut_results;
+EXPORT_SYMBOL_GPL(dept_ut_results);
+
 static int dept_stop;
 static int dept_per_cpu_ready;
 
@@ -826,6 +830,10 @@ static void print_dep(struct dept_dep *d)
 			pr_warn("(wait to wake up)\n");
 			print_ip_stack(0, e->ewait_stack);
 		}
+
+		dept_ut_ecxt_stack_account(valid_stack(e->ecxt_stack));
+		dept_ut_wait_stack_account(valid_stack(w->wait_stack));
+		dept_ut_evnt_stack_account(valid_stack(e->event_stack));
 	}
 }
 
@@ -920,6 +928,8 @@ static void print_circle(struct dept_class *c)
 	dump_stack();
 
 	dept_outworld_exit();
+
+	dept_ut_circle_detect();
 }
 
 /*
diff --git a/kernel/dependency/dept_unit_test.c b/kernel/dependency/dept_unit_test.c
new file mode 100644
index 000000000000..e8dada2e3dfb
--- /dev/null
+++ b/kernel/dependency/dept_unit_test.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * DEPT unit test
+ *
+ * Started by Byungchul Park <max.byungchul.park@gmail.com>:
+ *
+ *  Copyright (c) 2025 SK hynix, Inc., Byungchul Park
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/dept.h>
+#include <linux/dept_unit_test.h>
+
+MODULE_DESCRIPTION("DEPT unit test");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Byungchul Park <max.byungchul.park@sk.com>");
+
+struct unit {
+	const char *name;
+	bool (*func)(void);
+	bool result;
+};
+
+static DEFINE_SPINLOCK(s1);
+static DEFINE_SPINLOCK(s2);
+static bool test_spin_lock_deadlock(void)
+{
+	dept_ut_results.circle_detected = false;
+
+	spin_lock(&s1);
+	spin_lock(&s2);
+	spin_unlock(&s2);
+	spin_unlock(&s1);
+
+	spin_lock(&s2);
+	spin_lock(&s1);
+	spin_unlock(&s1);
+	spin_unlock(&s2);
+
+	return dept_ut_results.circle_detected;
+}
+
+static DEFINE_MUTEX(m1);
+static DEFINE_MUTEX(m2);
+static bool test_mutex_lock_deadlock(void)
+{
+	dept_ut_results.circle_detected = false;
+
+	mutex_lock(&m1);
+	mutex_lock(&m2);
+	mutex_unlock(&m2);
+	mutex_unlock(&m1);
+
+	mutex_lock(&m2);
+	mutex_lock(&m1);
+	mutex_unlock(&m1);
+	mutex_unlock(&m2);
+
+	return dept_ut_results.circle_detected;
+}
+
+static bool test_wait_event_deadlock(void)
+{
+	struct dept_map dmap1;
+	struct dept_map dmap2;
+
+	sdt_map_init(&dmap1);
+	sdt_map_init(&dmap2);
+
+	dept_ut_results.circle_detected = false;
+
+	sdt_request_event(&dmap1); /* [S] */
+	sdt_wait(&dmap2); /* [W] */
+	sdt_event(&dmap1); /* [E] */
+
+	sdt_request_event(&dmap2); /* [S] */
+	sdt_wait(&dmap1); /* [W] */
+	sdt_event(&dmap2); /* [E] */
+
+	return dept_ut_results.circle_detected;
+}
+
+static struct unit units[] = {
+	{
+		.name = "spin lock deadlock test",
+		.func = test_spin_lock_deadlock,
+	},
+	{
+		.name = "mutex lock deadlock test",
+		.func = test_mutex_lock_deadlock,
+	},
+	{
+		.name = "wait event deadlock test",
+		.func = test_wait_event_deadlock,
+	},
+};
+
+static int __init dept_ut_init(void)
+{
+	int i;
+
+	lockdep_off();
+
+	dept_ut_results.ecxt_stack_valid_cnt = 0;
+	dept_ut_results.ecxt_stack_total_cnt = 0;
+	dept_ut_results.wait_stack_valid_cnt = 0;
+	dept_ut_results.wait_stack_total_cnt = 0;
+	dept_ut_results.evnt_stack_valid_cnt = 0;
+	dept_ut_results.evnt_stack_total_cnt = 0;
+
+	for (i = 0; i < ARRAY_SIZE(units); i++)
+		units[i].result = units[i].func();
+
+	pr_info("\n");
+	pr_info("******************************************\n");
+	pr_info("DEPT unit test results\n");
+	pr_info("******************************************\n");
+	for (i = 0; i < ARRAY_SIZE(units); i++) {
+		pr_info("(%s) %s\n", units[i].result ? "pass" : "fail",
+				units[i].name);
+	}
+	pr_info("ecxt stack valid count = %d/%d\n",
+			dept_ut_results.ecxt_stack_valid_cnt,
+			dept_ut_results.ecxt_stack_total_cnt);
+	pr_info("wait stack valid count = %d/%d\n",
+			dept_ut_results.wait_stack_valid_cnt,
+			dept_ut_results.wait_stack_total_cnt);
+	pr_info("event stack valid count = %d/%d\n",
+			dept_ut_results.evnt_stack_valid_cnt,
+			dept_ut_results.evnt_stack_total_cnt);
+	pr_info("******************************************\n");
+	pr_info("\n");
+
+	lockdep_on();
+
+	return 0;
+}
+
+static void dept_ut_cleanup(void)
+{
+	/*
+	 * Do nothing for now.
+	 */
+}
+
+module_init(dept_ut_init);
+module_exit(dept_ut_cleanup);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5c7f22ba253e..41c822f7b75a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1477,6 +1477,18 @@ config DEPT_AGGRESSIVE_TIMEOUT_WAIT
 	  that timeout is used to avoid a deadlock. Say N if you'd like
 	  to avoid verbose reports.
 
+config DEPT_UNIT_TEST
+	tristate "unit test for DEPT"
+	depends on DEBUG_KERNEL && DEPT
+	default n
+	help
+	  This option provides a kernel module that runs unit test for
+	  DEPT.
+
+	  Say Y if you want DEPT unit test to be built into the kernel.
+	  Say M if you want DEPT unit test to build as a module.
+	  Say N if you are unsure.
+
 config LOCK_DEBUGGING_SUPPORT
 	bool
 	depends on TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-- 
2.17.1


