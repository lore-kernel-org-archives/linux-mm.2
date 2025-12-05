Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD10D2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80D06B0101; Fri,  5 Dec 2025 02:20:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08DF6B0106; Fri,  5 Dec 2025 02:20:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713C66B0101; Fri,  5 Dec 2025 02:20:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53A9D6B0105
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D0681604CB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:07 +0000 (UTC)
X-FDA: 84184568454.24.85CB497
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id 53CEE40002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=UWD4TubwAeIBKR7d9zSJFGXCU5GWoeH6ZFpPXRfskmk=;
	b=kBHJ0ri09aqRSwsmF5qoo1y7BHcEizPAyGJVQOVcBORpYGREJRTcJ41ori4OxWsLFlBO+K
	MqYAbr69fJu7ARE5i4n2XvWtZmUJvJ/rkGh4jdC6nOP9ZG/SA9nevavfgaxYpoT8hZQ5br
	2nIHDcz8BCMaN4Z1yWlb+oZSo8iMSHQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919205; a=rsa-sha256;
	cv=none;
	b=xg4kMTcaNUPzaSNCsXamBkQny7D8d70Rq7ovR5bQNFOyJMIKxfAcfxoyOq2XVqWaeXfKSH
	fQmmN1LaXvDD5Z5Lp3ENhg/yEcfl9JM0SbbzAgdiexaxA3iD+w/VkcuRpVAtLRSxuxNoG1
	bnJalo8+e1O0Kqj8TybUFDpXb79ZFQQ=
X-AuditID: a67dfc5b-c2dff70000001609-a1-69328775258d
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
Subject: [PATCH v18 39/42] dept: introduce APIs to set page usage and use subclasses_evt for the usage
Date: Fri,  5 Dec 2025 16:18:52 +0900
Message-Id: <20251205071855.72743-40-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTH99x7n3tvO2puOpJdIZmuZjEzzFmi5ESN4rdrptFEzZbtw2zG
	HdysVNIqCIm8SCsVmExmMVDBblgoUKVpNb5CBIRNoDhoIiggL0EIFTTy3lJ1BfXbL///ye+c
	D4cllf04ipV0x0W9TqNV0XJKPh3x1zepebHSFlcLC2ZTFszPmSkwu0sxDM2bESwuW0mw5CAo
	6S4mwXk9h4AXLTMILCNjNEwP3cXQuzCFoGrsLQENjtM0+MbWwENLAQ220w0Yxp82EJBbWU9D
	Sbmbgu4XIQLq3PshUFXLgNXrwzDqKGMgNKKGtroJBob+OYPhZvYwA+4nrQicheMkmO/MU1Ba
	MUDDM+c7DPUTfQR0tP1LwcOyGgr6vUUMPLpzFYO9t5sAj7eThJymSgpqGrw0FI/PMOC1dmEY
	OOenoNE8TIDdMY1hoqycgPbBWQb+7LHREBy8heFx8eUwVYf3tgfbCTAVBhiwhMw0FJhKKLjR
	usiA63U1DTmzQwiMA9tgeekSDeVz6vh4wdTzhhacFU4kzNlzSaFl6hUpGD1pgr1jihZulw0y
	grHxKSPY3CcE44NpLHgcm4TKe5OE4K49SwvumWJGGHh8jxZednUxB7/8Ub4zQdRKqaL+211H
	5Umm/iCZUhR3stvowtnoYkw+krE8t5V32G6TH7nWWYFWmOY28n19gdU8klvPe34fx/lIzpKc
	bx2fFzgXLlj2M+5X3tkcuTJDcV/xFUs3mBVWcHG8/e9r+L1zHV/nur/qkYVzS29wlZXcNv5y
	/uKqk+cqZfx1790PR6zlmxx91B9IYUOf1CKlpEtN1kjarZuT0nXSyc2/HEt2o/DLVZ0K/XQL
	zfx3qBlxLFJFKO6nqSUl1qQa0pObEc+SqkjFlHaLpFQkaNIzRP2xn/UntKKhGUWzlOpzRexC
	WoKSS9QcF38TxRRR/7ElWFlUNvp6xG/QKfwy7koBRLfVPPAndko3H+H2PT3R1v76tjN7zREu
	76Ej+y+gzOW4/MRq9YbCA8/t+ouHNWtiMia3Z4SaRN2ca/R840ZfkUx51Pf9DxM7sBiMNiy9
	CUitu6O+sxYNy/blei582hGzKzErftiVeXA2zr8+ZUP9F3u5K6UqypCkUW8i9QbN/wCtvHFu
	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUhTcRTG+9+3XVeLy7K8FfSyiOhNLTIOFVF96Rb0AgVRETnqpsM5bVNL
	I2qu4dK0udiGrtQsR+nK5bKyGommZBa6LB3psmitlpa9OG0ztVn05fA753nOw/lwaFx8l5xF
	yxRpvFIhlUsoISHcvlazPD1npSy2qWUB6LSnoKfXS0Knup6AwKCOgIvVNgpGLXcFoKspIuFJ
	VzYB7TerEPQGdAiGRyw4aOvGCRg1NAtgMNgtAKMawbizGYHJZcDB3f4IB9ttNQY/7WMU9DX+
	QGB856XA7FcTMGA9h6DYZxGAv2kzfOl9QMK45yMGXUP9CKzeMQy89TkIRk1JUFruCK+bvlEw
	8rwNB7OxHcHldx4cfvjfIrjd/AaB81o2BR/0tTh0eKfCy8AABS3GPAq+uC5i8NVOQVm2kwTX
	sz4ElywGBL7XTgw0V6opMF2qIaDu7X0BuPp+Y9BjMmBQVbMNeq0+Alr15Vj43LDrVhRYzBos
	XD5hYLzxAIOgtVKwoQJxw9oCgqt03ME47YtRirOV2BA3EjIgbrBCg3Nafbht7B/AuTOOY1xF
	az/FhQKvKM45VEZwT8tZ7urZEMYVPl/O1RV7BDs37hOuO8zLZRm8MmZ9vDBR2x3CU8+vPu46
	YydPI/OyXBRBs8wqttJWgiaYYhaxbncQn+BIZh7ryPeRuUhI40zHXDYnWBAWaHoac4S1NURO
	eAhmIVvyq1YwwSJmNVtRfpP8lzmXrbLX/82JCM+NXaG/LGbi2NLcYVKPhGVoUiWKlCkykqUy
	eVy0KikxUyE7Hn0oJbkGhd/JevJ34T002LG5ATE0kkwR1R9bIROT0gxVZnIDYmlcEinql8fK
	xKLD0swsXplyUJku51UNaDZNSKJEW/fw8WImQZrGJ/F8Kq/8r2J0xKzTSId2z0iIsU/Z1bfl
	gjuqMPHCx7jieU3eTXZ+vXZGfmiLqzW7TV9qWKMXzV+cvzfa86zHn7d7//TFKuECn07zvrjt
	c9ZjddHO+7U+/9KD14d+TU6ammXurD5wMvbct8I5EQ9L3Am+oz3x4470bt4Wow94gidOHMop
	+i6dWTBfEb9jjYRQJUpXLMGVKukfSrjLMUoDAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 53CEE40002
X-Rspamd-Server: rspam11
X-Stat-Signature: 8qc5wkywir7powrhxzki5oqz7kcks8em
X-HE-Tag: 1764919205-828039
X-HE-Meta: U2FsdGVkX19C4gVbnNb2sy3fMauziLdYD8uV+mSFFXQanxRhpQtEjwS9Eua2LrpKrHQu6PVkr6mTxttfvvzjnEu4IjtNhAf4KtOqUpnZ9DG5VnpSB9/Ymks0D5bawbVEM3yorepNE9jaeOwl+20UtO3IhCO+z/FmVyfvuUau8DoJHcK23uag4tbI56GkZz3GnUqrKe+vw65L3BBfCURp6AEDW1/x0tw0j2vXy5GXHLzh41HsSV+87GLGaEMjL6LSpb2P/NS+hjP/ETULAy9tOx8CbFpAuUgCDzhiK9aBAIMI6fnOs57n/OUCvetPERd+wJ7kjn81h7ePtww9GxM+qGDlgmLvSXGnviRWgcpKNLEL4KytFAMCLoeewOcQGjWR5VbUeb2uBULBGakoS0xf+WAZbJTOazn2hMPXSpnd6IF7/mqoYdVbdxjcODUnrBFkIM7vwGgqy0t/SM2imUmwRmxt1TQSOmC69nvUFO7n3r2X1FHtZnQlDVwFwJlp9vIA56iFonOX0kItFjGIbIu4AE+FeZClM40Z0go/pvXtzjhjDnXSKF8mDCQWh2vWwiESvyiQcEluxSj/xHvXkDwlEf7sFS1/o2iNLeUIJy7gP1/y6uguKK8UCTKMMFtQy1v4ABUhmEuLU85jS8JTIvx30vMI5hlMGAy9zg8XGElZoM7ONsXnCnlyuVIan14Ji7F6svyXfW7C6e+sycQQuDdYHl9nG6GWOb59YUeXyYPFkfsXZtDANWE2L3a6NMdXHt/7BTfY4Qln97WC4SR7vLnH3QJRzC1ubxOL1n6GOSjyxQMir7kFmFfo4TZIRNPf4mDFmjHqNr7PvgHxi2Zvd6b9w+kgQpWd+1brL3YksHr6gl46NLb/g8e4/w8kco7rIjGprQJsF9etgryrqdr2U7imweum5n45YPUiaOkjUhofxDA/+xvLBg4ZE85VyqsSvaAiOwS+UWqw24XA7Xppf+s
 9YzB6+t0
 Fl5RYm61QmziNypJIgHGp5PUviXVZD9ZzjYfDleX7vV02aL/SHH44oMxsAl0usKCYTb+Am6GMcuuCFT8BY8ZDJLCDVZOcmupJAlyzK8YgZz8jyaIKPmH4QZ4a984Dt1lRD4yJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

False positive reports have been observed since dept assumes that all
the pages have the same dept class, but the class should be split since
the call paths are different depending on what the page is used for.

At least, ones for block device and ones for regular file have
exclusively different usages.

Define usage candidates like:

   DEPT_PAGE_REGFILE_CACHE /* page in regular file's address_space */
   DEPT_PAGE_BDEV_CACHE    /* page in block device's address_space */
   DEPT_PAGE_DEFAULT       /* the others */

Introduce APIs to set each page usage properly and make sure not to
interact between DEPT_PAGE_REGFILE_CACHE and DEPT_PAGE_BDEV_CACHE.
Besides that, it allows the other cases:

   interaction between DEPT_PAGE_DEFAULT and DEPT_PAGE_REGFILE_CACHE,
   interaction between DEPT_PAGE_DEFAULT and DEPT_PAGE_BDEV_CACHE,
   interaction between DEPT_PAGE_DEFAULT and DEPT_PAGE_DEFAULT.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept.h       | 34 ++++++++++++++-
 include/linux/mm_types.h   |  1 +
 include/linux/page-flags.h | 89 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 120 insertions(+), 4 deletions(-)

diff --git a/include/linux/dept.h b/include/linux/dept.h
index 7b822caee874..b3bb1a1a7eb5 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -19,8 +19,8 @@ struct task_struct;
 #define DEPT_MAX_WAIT_HIST		64
 #define DEPT_MAX_ECXT_HELD		48
 
-#define DEPT_MAX_SUBCLASSES		16
-#define DEPT_MAX_SUBCLASSES_EVT		2
+#define DEPT_MAX_SUBCLASSES		24
+#define DEPT_MAX_SUBCLASSES_EVT		3
 #define DEPT_MAX_SUBCLASSES_USR		(DEPT_MAX_SUBCLASSES / DEPT_MAX_SUBCLASSES_EVT)
 #define DEPT_MAX_SUBCLASSES_CACHE	2
 
@@ -142,6 +142,35 @@ struct dept_ext_wgen {
 	unsigned int wgen;
 };
 
+enum {
+	DEPT_PAGE_DEFAULT = 0,
+	DEPT_PAGE_REGFILE_CACHE,	/* regular file page cache */
+	DEPT_PAGE_BDEV_CACHE,		/* block device cache */
+	DEPT_PAGE_USAGE_NR,		/* nr of usages options */
+};
+
+#define DEPT_PAGE_USAGE_SHIFT 16
+#define DEPT_PAGE_USAGE_MASK ((1U << DEPT_PAGE_USAGE_SHIFT) - 1)
+#define DEPT_PAGE_USAGE_PENDING_MASK (DEPT_PAGE_USAGE_MASK << DEPT_PAGE_USAGE_SHIFT)
+
+/*
+ * Identify each page's usage type
+ */
+struct dept_page_usage {
+	/*
+	 * low 16 bits  : the current usage type
+	 * high 16 bits : usage type requested to be set
+	 *
+	 * Do not apply usage type on request immediately but postpone
+	 * it until the next use of PG flags.  For example, if the page
+	 * is already within a PG_locked critical section, regard it as
+	 * DEPT_PAGE_DEFAULT temporarily at least until the section ends
+	 * e.g. folio_unlock() since it's still unclear which usage type
+	 * the page acts within the section.
+	 */
+	atomic_t type; /* Update and read atomically */
+};
+
 struct dept_event_site {
 	/*
 	 * event site name
@@ -314,6 +343,7 @@ extern void dept_hardirqs_off(void);
 struct dept_key { };
 struct dept_map { };
 struct dept_ext_wgen { };
+struct dept_page_usage { };
 struct dept_event_site { };
 
 #define DEPT_MAP_INITIALIZER(n, k) { }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 42b6959882b3..85d06073d37b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -220,6 +220,7 @@ struct page {
 	struct page *kmsan_shadow;
 	struct page *kmsan_origin;
 #endif
+	struct dept_page_usage usage;
 	struct dept_ext_wgen pg_locked_wgen;
 } _struct_page_alignment;
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8ab39823ea31..0b0655354b08 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -204,6 +204,80 @@ enum pageflags {
 
 extern struct dept_map pg_locked_map;
 
+static inline void dept_set_page_usage(struct page *p,
+		unsigned int new_type)
+{
+	/*
+	 * Consider the page as DEPT_PAGE_DEFAULT until the next use of
+	 * PG flags e.g. folio_lock().
+	 */
+	unsigned int type = DEPT_PAGE_DEFAULT;
+
+	if (WARN_ON_ONCE(new_type >= DEPT_PAGE_USAGE_NR))
+		return;
+
+	new_type <<= DEPT_PAGE_USAGE_SHIFT;
+	new_type |= type & DEPT_PAGE_USAGE_MASK;
+	atomic_set(&p->usage.type, new_type);
+}
+
+static inline void dept_set_folio_usage(struct folio *f,
+		unsigned int new_type)
+{
+	dept_set_page_usage(&f->page, new_type);
+}
+
+static inline void dept_reset_page_usage(struct page *p)
+{
+	dept_set_page_usage(p, DEPT_PAGE_DEFAULT);
+}
+
+static inline void dept_reset_folio_usage(struct folio *f)
+{
+	dept_reset_page_usage(&f->page);
+}
+
+static inline void dept_update_page_usage(struct page *p)
+{
+	unsigned int type = atomic_read(&p->usage.type);
+	unsigned int new_type;
+
+retry:
+	new_type = type & DEPT_PAGE_USAGE_PENDING_MASK;
+	new_type >>= DEPT_PAGE_USAGE_SHIFT;
+	new_type |= type & DEPT_PAGE_USAGE_PENDING_MASK;
+
+	/*
+	 * Already updated by others.
+	 */
+	if (type == new_type)
+		return;
+
+	if (!atomic_try_cmpxchg(&p->usage.type, &type, new_type))
+		goto retry;
+}
+
+static inline unsigned long dept_event_flags(struct page *p, bool wait)
+{
+	unsigned int type;
+
+	type = atomic_read(&p->usage.type) & DEPT_PAGE_USAGE_MASK;
+
+	if (WARN_ON_ONCE(type >= DEPT_PAGE_USAGE_NR))
+		return 0;
+
+	/*
+	 * wait
+	 */
+	if (wait)
+		return (1UL << DEPT_PAGE_DEFAULT) | (1UL << type);
+
+	/*
+	 * event
+	 */
+	return 1UL << type;
+}
+
 /*
  * Place the following annotations in its suitable point in code:
  *
@@ -214,20 +288,29 @@ extern struct dept_map pg_locked_map;
 
 static inline void dept_page_set_bit(struct page *p, int bit_nr)
 {
+	dept_update_page_usage(p);
+
 	if (bit_nr == PG_locked)
 		dept_request_event(&pg_locked_map, &p->pg_locked_wgen);
 }
 
 static inline void dept_page_clear_bit(struct page *p, int bit_nr)
 {
+	unsigned long evt_f = dept_event_flags(p, false);
+
 	if (bit_nr == PG_locked)
-		dept_event(&pg_locked_map, 1UL, _RET_IP_, __func__, &p->pg_locked_wgen);
+		dept_event(&pg_locked_map, evt_f, _RET_IP_, __func__, &p->pg_locked_wgen);
 }
 
 static inline void dept_page_wait_on_bit(struct page *p, int bit_nr)
 {
+	unsigned long evt_f;
+
+	dept_update_page_usage(p);
+	evt_f = dept_event_flags(p, true);
+
 	if (bit_nr == PG_locked)
-		dept_wait(&pg_locked_map, 1UL, _RET_IP_, __func__, 0, -1L);
+		dept_wait(&pg_locked_map, evt_f, _RET_IP_, __func__, 0, -1L);
 }
 
 static inline void dept_folio_set_bit(struct folio *f, int bit_nr)
@@ -245,6 +328,8 @@ static inline void dept_folio_wait_on_bit(struct folio *f, int bit_nr)
 	dept_page_wait_on_bit(&f->page, bit_nr);
 }
 #else
+#define dept_set_page_usage(p, t)		do { } while (0)
+#define dept_reset_page_usage(p)		do { } while (0)
 #define dept_page_set_bit(p, bit_nr)		do { } while (0)
 #define dept_page_clear_bit(p, bit_nr)		do { } while (0)
 #define dept_page_wait_on_bit(p, bit_nr)	do { } while (0)
-- 
2.17.1


