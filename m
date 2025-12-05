Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8420DD2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD126B0102; Fri,  5 Dec 2025 02:20:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B276B00FC; Fri,  5 Dec 2025 02:20:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390866B0100; Fri,  5 Dec 2025 02:20:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8D756B0102
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B255F1404C2
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:06 +0000 (UTC)
X-FDA: 84184568412.17.1ED01C1
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf06.hostedemail.com (Postfix) with ESMTP id AE69B180002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=D9lJhkgIyl4Q6iUGlv9gXKwumhElTNY3lELIGuZtzsc=;
	b=QiGkXP9IQ0twxi9pcN4z8R2eBbiZp7tBt7dNv6Jj9q1qnFOCqmPFKMvSKJKeagyln5rHr6
	FexnawKquQziZZcEnRRaL4lfTyz1/eyGEYtLfhYysVpHVZfPUjklLMXSFpv7Kev/DLg1jq
	nJwuMDCFOU0zz/uT6xygAtALjfi9WUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919205; a=rsa-sha256;
	cv=none;
	b=Mw4Zz3TlBQig5OO/R1EZpv5y3cNP6Rb7nr1eVVdbZVwsz8Q+Rus22+xqhMONje8unDAILT
	CpqFT1yfj16ZP2aXecPkceFzll+NRJ9dXIxTj/7uXn+pFM7j36XtaOVlGp7n75ext2Ilfq
	UoyykWpI1ZRA3sGw1rrrLrCAnF+d4bs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-42-69328773e512
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
Subject: [PATCH v18 36/42] dept: implement a basic unit test for dept
Date: Fri,  5 Dec 2025 16:18:49 +0900
Message-Id: <20251205071855.72743-37-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSa0xTZxgHcN9zeU9pbHZWSTiyGE2ncdHAxFue6CKYTHm/bDFRE8d02siZ
	NJaLLaCYEAFFCvFSqwUVtWhnQVoVj5igICI3jWioJdaKYCtilXsEqiDiBNRvv/z/z/N8emS0
	8jkbKtMkJIu6BLVWheWMvG/6+bDknMWaRW86aDBk74M2bycL3oABwYexQhqGR59zYM5EkP/Y
	RIPHeYcGR3kmBT11gwjMLzsxDNgOIehqiIY+byULlgvXMYw9aqahwOxEUN74AsHZQhMCf+tt
	CvZbr2LIPysxcNN3iwO79Ad4bX4G8q+FQGHBWwrMlyspeGhtY8CWMQ96/CYM0rMGBI5Dfhqk
	V24WbrcuhFPn2jA0VnRQ0HLrDIYXjv9ZcNY0seCyOxloarzPwEufZyI7dpiF4/1+BM8Kejmw
	BQY4cNUUUZB518qA/8lBCi5ZihHkvK3EUG3wUXCxpI+FukAvBQ/ahzj42F7BgttkwWB/zID5
	kwFD2btiDJlDXgQjZa9Y6DcOs1FRJNs1jonjnAOR4Yv7aZJtnFBd7wBNHlwQyLFHYeTm6XaO
	HKhu5UiRlEIO1PexxFrVRZHzgwGWSKW5mEiDJo60uavwOlWM/LdYUatJFXW/rtomj+u2jdFJ
	J6L3XGn20RmoYWUeCpIJ/FKhq2kIf7c03sNNGvPzBY9nlJ50MD9HuH7Yz+YhuYzmW2YLOaNH
	pooZ/BqhoPU1O2mGnyd03HMxk1bwywVH1udvR2cL9rKaqfmgidz89OOUlfwywZL3YeqowFuC
	hPobZu7rwkzhbomHMSJFEZpWipSahNR4tUa7NDwuLUGzJ3x7YryEJl7Olv7p7wo06Fxfi3gZ
	Uk1X1OyO0ChZdao+Lb4WCTJaFazo1S7SKBWx6rS9oi5xqy5FK+pr0U8yRhWiWPx+d6yS36FO
	FneKYpKo+95SsqDQDJReHbWkfUn0wcAPQ90t7hmR1o148/ENrvTUiD9zk8OpbSm/j/V7fVmn
	fZEkpbR5JCvxL/dKfdLc8X+4zorA2ku1Mc3V8VuO2kfK/9ucFLwp9JeYk5XGzyHRluVh9i2x
	//pGSqxUx4KqUbLOnB6Zu8sQ+XP3jwHj3PqT3cWr6Vmz3CtUjD5OHbGA1unVXwCy08hbbgMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+7+3zdHiZQm9GJKMIggqtYwTVhiRvhRl5YfIL7rqpQ2nxZa3
	IErX8tZFR5vkKs1ylS612U1tJdPMNMmppWi2GXNlzgxTl1vTptGXw++c5zkP58Ph46LnZBBf
	lnKaU6RI5GJKQAj2R6rWK3PCZaGPrgZDrvocfLI5SPiY1UTA9FQuATdqjBT49M94kGu6TkJb
	XzYBXdVVCGzTuQjcXj0O6vp5AnyaVh5MzQ7yQJuFYN7cikBn1eDQ3/UKB+PjLAx+1c5RMNY8
	iUA77KCgeDSLgAnDJQQlTj0PRl/HwLitkYT5oa8Y9M24EBgccxg4mnIQ+HRJUFpe51/X/aTA
	2/keh2JtF4Lbw0M4TI7aETxu/YzAfD+bgpHCJzj0OJZB7/QEBW+1BRSMW29g8KOWgrJsMwnW
	d2MIbuo1CJwDZgxUd2oo0N00EVBvb+CBdewPBp90GgyqTPvAZnAS0FFYjvnP9bserQB9sQrz
	l28YaB82YjBrqORFVSDWrb5CsJV1TzFW3e2jWOMtI2K9Hg1ipypUOKsu9LfNrgmcvVCXzlZ0
	uCjWM/2BYs0zZQTbXs6wd/M8GFvUuZ6tLxniHdgZL9h2nJPL0jjFxh2JAul3gxc/dS0mo/q9
	HT+PXkfmowA+Q29mTL4x3gJT9Fqmv38WX+BAOoSpu+wk85GAj9M9q5ic2SuLwnJ6N1M8MEIu
	MEGvYb686SYWWEhvYYzZc9S/0FVMVW3Toj/AP9f2eRZZREcwpflushAJytCSShQoS0lLlsjk
	ERuUSdLMFFnGhmMnk03I/0+Gs3+KnqOpnhgLovlIvFTYlB4mE5GSNGVmsgUxfFwcKHTJQ2Ui
	4XFJ5hlOcTJBkSrnlBa0kk+IVwj3HOYSRfQJyWkuieNOcYr/KsYPCDqPSowZMfFtR4PO9TVq
	HDlzNULVxWB7EX31d4E0YfJQ+B3HcFt/nG2v27W8RHhpbcvq+yPt1W9NEW40E5p6tAHt6UJS
	Z+rB2MjWn3pHwomIe7HWhryM+FhvHDXYe+zljmUqz64DO6NfGEMCLFH2Zx2qBy2W6Hp92vZd
	sDW9pvLIJjGhlErC1uEKpeQvv2O8gEsDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: AE69B180002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: zwurazbw3gt91aj6swcyordi6mc6y8nf
X-HE-Tag: 1764919204-132626
X-HE-Meta: U2FsdGVkX18eG8JB8dZqhPeptg9Tkg+91DSXf+OVNx97Fr1dJZMErGVFN2e3kLW6uouml7q3fYpmFdER0bxMF97ZmixZTms5U973y8gDf/mtJf6No3KNHJ+NcKDpiJSkmbf3WLyxMbpx4Udo+Z/oruPy0+0BwRh/v6VeFUrY0OsrJwFk6d8TYmCf6C7+8gVnMWS5FIFI/jJuTDrcnKZvBZsSpgFDVPbcFZaPC9iTvFu9mUIGGYRd2Uo8GCY7owd3U0dm0GMPVO7nhdlbC8TQAlHXFNmlKKXk2Es+5To9/UG0MSVmufKIRC717Uu1J0jJQgj2hIVq0JeNBh9OV2f55So4OO8r5plqVT32zL345UhK3OVhxZdUow3hN0CKT6sNuBvqfC8mV83UQzBobfnc+WENmBic4SA8lA4K7BnR5ep4ZUJiRu+LmivG0MRGRWfe1iHi7jHgDo9dZnvYB0iajbT+UatK0np3v+JFyunBhvFUMqBgeJzLiNMEjPYkpNc3e9wKOCTyNxg6ha/g87mmrsmT/NgnPzO1ywfXmXKOx5PweaAwCVWhZHn20Ncj5E3Lj70gRvzZvaH1m1UKD/1m9A1B/07KmWBei+Yjf/vJ2+5NDAcDc1GP67SxMf68H4rRF2AuaIew/4PjiifYlI5Maef2hxetwZOQZi56MgG1s8Np5VM1c0GLNqF1d00bm9q3LkNiggVxce4DhymC8J3bVmi0ZuTX6cfu0bxne3xzvzhIGkYID9UuB1Qdp23m5LCM9Lw5PRkJxAywdbiEE3Mvzn/SUfddqdmYGhMYBlRoU36L7McaBoArhs8ooU27Gw0865+DRgE78VbRY2ZqyqHY8imN6an351WnbMiqVuo0IWd0s52/PaL1HGZbd4naZ3k34BJ5rRDh31v+8p88HLfx1rr/G7sBQOfn5lHX3hanE7K0bHM1zztwcNH5jAMFHIgJg27cHnUzV0HBaVUu8qL
 hIom34sC
 ENY46chViupuiEFCKz8bG6i8lKDmB7hBfhPhh2pmtWecqD7XN1psqoj3D5qUgmDTG06kf6fcAQsFecp6FtQBaXu5ACJlgE+tN7Fs6FCQ4o2vl0R8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 include/linux/dept_unit_test.h     |  67 +++++++++++
 kernel/dependency/Makefile         |   1 +
 kernel/dependency/dept.c           |  12 ++
 kernel/dependency/dept_unit_test.c | 173 +++++++++++++++++++++++++++++
 lib/Kconfig.debug                  |  12 ++
 5 files changed, 265 insertions(+)
 create mode 100644 include/linux/dept_unit_test.h
 create mode 100644 kernel/dependency/dept_unit_test.c

diff --git a/include/linux/dept_unit_test.h b/include/linux/dept_unit_test.h
new file mode 100644
index 000000000000..7612b4e97e69
--- /dev/null
+++ b/include/linux/dept_unit_test.h
@@ -0,0 +1,67 @@
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
+	bool recover_circle_detected;
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
+static inline void dept_ut_recover_circle_detect(void)
+{
+	dept_ut_results.recover_circle_detected = true;
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
+#define dept_ut_recover_circle_detect() do { } while (0)
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
index 3c3ec2701bd6..0f4464657288 100644
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
@@ -1021,6 +1031,8 @@ static void print_recover_circle(struct dept_event_site *es)
 	dump_stack();
 
 	dept_outworld_exit();
+
+	dept_ut_recover_circle_detect();
 }
 
 static void bfs_init_recover(void *node, void *in, void **out)
diff --git a/kernel/dependency/dept_unit_test.c b/kernel/dependency/dept_unit_test.c
new file mode 100644
index 000000000000..88e846b9f876
--- /dev/null
+++ b/kernel/dependency/dept_unit_test.c
@@ -0,0 +1,173 @@
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
+static void dummy_event(void)
+{
+	/* Do nothing. */
+}
+
+static DEFINE_DEPT_EVENT_SITE(es1);
+static DEFINE_DEPT_EVENT_SITE(es2);
+static bool test_recover_deadlock(void)
+{
+	dept_ut_results.recover_circle_detected = false;
+
+	dept_recover_event(&es1, &es2);
+	dept_recover_event(&es2, &es1);
+
+	event_site(&es1, dummy_event);
+	event_site(&es2, dummy_event);
+
+	return dept_ut_results.recover_circle_detected;
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
+	{
+		.name = "event recover deadlock test",
+		.func = test_recover_deadlock,
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
index 540583425d8e..86e26b9708fa 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1404,6 +1404,18 @@ config DEPT_AGGRESSIVE_TIMEOUT_WAIT
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


