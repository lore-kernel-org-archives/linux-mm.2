Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9646DD2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784586B00F3; Fri,  5 Dec 2025 02:20:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D8F6B00F5; Fri,  5 Dec 2025 02:20:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA186B00F7; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D661A6B00FE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A827551ED9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:04 +0000 (UTC)
X-FDA: 84184568328.19.2371CC0
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9B152100002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=o4GluIjzAC7UvsdbO2/FontD1m1p73DNCXDT0g9VR/I=;
	b=nxoIIes8VZZhKLvR9hS55qhbX6hzdqHpQaZ7V86wrf5BRGvEEafY5zdA6EJBzZNeX1NKPt
	yyqp2HrQ+vn6cCq9OsK61sVbGnXvpi+lwc1fofLxDzuvdEIFoE6S6y4PxXZ6vmOOO4Vt0d
	s/DQJAwKu3ieKfaU40MJDW/cEoJTP9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919203; a=rsa-sha256;
	cv=none;
	b=GP9sEmonJbOY7xKrbq4PYFPZq3aztXgdisS7aKv+SqcK4mEImXNk+AZvddBliFGfmy0xK4
	Ss7GYcU/Tpp0lLcjyYlJAWz/mQ1cqWjra66uTwBYr1fC9e4fsdiXQVczTQRGchsm+6Lrmn
	WVwF630YFwG17MGRB6NpGR/Q2gl8l9k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-a8-69328772626b
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
Subject: [PATCH v18 31/42] dept: assign unique dept_key to each distinct wait_for_completion() caller
Date: Fri,  5 Dec 2025 16:18:44 +0900
Message-Id: <20251205071855.72743-32-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTdxjG/Z/+z+mh85iT6uIZZtE0GhMdKN7yLi5kZMn234ctLn7TqGvk
	RE4sVMtF0JiAXLp1SKCuxbWoLZCKghmWbeKFUnEwcZgAcqlaqGitK1AmSGEQoKs1fnny5Pe8
	7/PpYWVKDx3PShlZoi5DrVExCqwILbcn6PTbpK2W9k/B6/PTMFDgxnB/8AyG4psRDNNzT+Vg
	KkAQaelAYO4xysDT3SqDN41LDIzdm0JgGvEzYAlY5RBs/wpCvts0RIZeUTA4M47A79YjWDQf
	hUpTN4Kp4DMEv3UMI3jkXwF94X8Z6DT9xECop4oC25kWGnq6xhBcsBoRBJ60UFBY8ysD5gtO
	DF6zkQKfI4Dh7/JqCiqDUX59NVgrC6mo/EOB6dptCrpqvBgc+RvgeZ1FDhGbFjrqX8mhc3iA
	Bt9fJTRM941Q8MOtMAbniyizl9Ri+OWil4E7LZ0YSht/p2G4IUJDvnWWhpFnHhq6K87S4Cl/
	ieDaRDUD5yYCCMZmHDJ4XDkuh163jfo8lcwWl2FytekPihT3LjKk4WIDIsXlUZkP9zPkQbVA
	an+cp0jFwwRy0zIkJ0WuJ3Jic2aToj9DNGmq20Rq7gQpYp8K03u27FN8lipqpBxRtyX5e0Wa
	3/rdsenjuXOX76F81HzAgOJYgd8hWF3tsvfeH7mL33qG3yh4PHMxvopfJzSdDdAGpGBl/KO1
	gn6uLBas5EUh+PMCZUAsi/kNQlcr8xZz/C7B96AUvetcK9Q3umPncVFuGpyPeSW/U7hkmI11
	Cnx9nDDu8DLvHj4S7tZ5cDnibGjZVaSUMnLS1ZJmR2JaXoaUm3hYm+5E0b05Ti/sb0ZT3Xvb
	EM8i1XLOfSJJUtLqnMy89DYksDLVKm5cs1VScqnqvJOiTntIl60RM9vQGharVnPbZk6kKvkj
	6izxqCgeE3XvU4qNi89H6bkqe/LuJP3i6VOtxKL8Jnsp8dwe1mns1YZen+deD5uLNkt7a/UH
	8fWJnR9y/42KN6pOrnFR25sjX1YkPN/+YuFN/ML6nt2lWuOySYPvkM83UGWoiTiyXJNyV4p9
	aZ77epRpvRzoGhn6eOKDFWT9t4leZvoT5RWun6SUFIS/UOHMNHXSJpkuU/0/U6QkQGsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSX0xTBxTGPfdfL8UuN5XEqz64NHEzRBQNkpNopj4Yb5agaMzMlqA2cpWG
	UqFFhG1OSu3AqlgbWybFiTCqARTWKhNcZwUh/sFARYSorLJVNgKKgxYsULCw+HLyO9/3nZPz
	cFhS3kAvZVWabFGrUaoVjJSSbt9giNMWrlPF64PRWGQ8ji99fhqf6T0UBgNFFJbV1TIYtv8m
	wSLnBRrv9xRQ2Hm9BtAXLAKcmLKTaGycpTBsaZNgIPRCglY94Ky7DdDmtZDY23mHxNobegLH
	6mcYHGoZBbT2+xksGdRTOOI4DVg6YJfgYOs2fOO7TeNs3z8E9owPAzr8MwT6PYWAYVs6Xqpw
	RcZt7xicetxBYom1E/Byfx+Jo4OvAG+0/QnovlrA4GvzTRK7/J/g0+AIgw+spxh84y0j8G09
	g+UFbhq97UOAF+0WwIHnbgINlXUM2i46KWx81SRB79A0gS9tFgJrnEnocwxQ+MhcQUTOjaR+
	XYz2EgMRKf8SaL12m8CQo1qyuQqECWMxJVS7GgjB+CTMCLU/14IwNWkBIVBlIAWjOdK2DI+Q
	wgnXUaHq0TAjTAa7GcE9Xk4JDyt44ZeTk4Rw7nGc0FjaJ0ne8o10Y6qoVuWI2jVf7Jem+e07
	MwNZuaErLZAPt1JMEMXyXALvn71LzTHDfc739obIOY7hPuVdZwZoE0hZkutazheGiueNRZzI
	D56fJkzAshS3gm+/w8zJMi6R9z08Df/vXM7X1Hvm41ER3dozOc9ybj1/yTRBm0FaDguqIUal
	yclQqtTrV+vS0/I0qtzVBw5nOCHyTY5j0+duQaBrWzNwLCgWyjxH16rktDJHl5fRDDxLKmJk
	w+p4lVyWqsz7VtQe3qc9ohZ1zbCMpRSLZV/uEffLuUPKbDFdFDNF7UeXYKOW5oPnr1U5sTu/
	Sk6YjsvMuLqk25TkOBDX6j20bGvxovjPDl5rqOmhHe3v1/zd9GP//U27i0+0JTSGL+9KMU+d
	nSBWPogeiSmVVHCpv+c2hG1fS2PH/qhckLwjv+77687vQGro+GHvhqyzPzXdbO2eubeSTPyv
	ObZMt+egP8mVaH79VFOgyFJQujTl2lhSq1N+AFdBCE5JAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B152100002
X-Stat-Signature: noqdjuz6uyrgpiianm9arhyejutbrtq9
X-Rspam-User: 
X-HE-Tag: 1764919202-643798
X-HE-Meta: U2FsdGVkX1945AlM77ctbYmHc7ANqhqUNuO1rWkGaKVptl0UTWksGdUst3XyMLS9WwfRn1IDxrfUG17ig2cKhJS4TR/wfl4nsTjN/oASi3Jfiy/qkvWXPzaZpYxUYrWBxHdxKPhsjnvexccBYvcrjzB8mjfjIY+WGcYN0iz3I2qcMYZv52q4GvY5LyRtojHiN7vDvvKS0ZYXZR3dSqL7IAzJqttAqZAmuAU4nFgSR+ujOaD9zzuCLAj7LNDlCIAexT8VPpKW32RhyZTTFIJYxOcQcAdZDeNK9u694vIbic7zKZuCBUFCK4SdLppdfaE4ufRR12Gawas3cBHUPdOqvQyUNcL4YWrU+xj9Atu98wOfHh+aQdleqE0D0X8uvTR6lXzdNGa+eJ0kOCVYtjKwqlpQ10x684rCHAKVcCpEBIHj1Ybt60Gpwtn6ozq/rOjnTRB9tkYsfJBj2i/wXwHGOJ5Kdiv4UJtuqZF1RvHZ5skfMU4q/Dkhw2Hfb5nR17INeVwaFwhGzolPyaYyIPxMxzsCDdBLN6eUEdbUV1i4/TWReNQXydemzo6KzZO4fQ/xeXq74v2vINZY67LvusDJYWSALX+dCIMXZw69PtmqaxoTd7lKT7v7LDFEQxoggUJ4NaG7PzpOgKDE0ak+wKU3QPhYldV8VTKRxzev3UFnRoD2QwYqIpbm8BYfUq94cjpSoqeCVvrVHkPD1HIYFWSR0ViuX+UUUFAZKBUAlx4+/sl5BCcM/CT6Oh9vK7Q5cbosNihw2o0j2P25YAFT71ZyDisPAS7H6ufQ0wqh18YxthaoIFQSXaf417g6OQb4iyu25lLFHTrkPKgsyiq5Vbpp++tG1rw09G0526DU/SKY2LcY96pM2vGfMEKe9dw6HSudtwa4APLkaF539e6h4TLFAlSo7cq+sxtUy1CTD39MISWSHX5JQRs3upd5SzXXlnvVcLAedzN2CW8TI33legU
 XOmpKj7B
 Y7u77xHRw7Qd2uiZwJdUvt6HfRyS5uIJ+GoU1aKEB718PpOiRrb5HAuBWCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

wait_for_completion() can be used at various points in the code and it's
very hard to distinguish wait_for_completion()s between different usages.
Using a single dept_key for all the wait_for_completion()s could trigger
false positive reports.

Assign unique dept_key to each distinct wait_for_completion() caller to
avoid false positive reports.

While at it, add a rust helper for wait_for_completion() to avoid build
errors.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/completion.h | 100 +++++++++++++++++++++++++++++++------
 kernel/sched/completion.c  |  60 +++++++++++-----------
 rust/helpers/completion.c  |   5 ++
 3 files changed, 120 insertions(+), 45 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 3200b741de28..4d8fb1d95c0a 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -27,12 +27,10 @@
 struct completion {
 	unsigned int done;
 	struct swait_queue_head wait;
-	struct dept_map dmap;
 };
 
 #define init_completion(x)				\
 do {							\
-	sdt_map_init(&(x)->dmap);			\
 	__init_completion(x);				\
 } while (0)
 
@@ -43,17 +41,14 @@ do {							\
 
 static inline void complete_acquire(struct completion *x, long timeout)
 {
-	sdt_might_sleep_start_timeout(&x->dmap, timeout);
 }
 
 static inline void complete_release(struct completion *x)
 {
-	sdt_might_sleep_end();
 }
 
 #define COMPLETION_INITIALIZER(work) \
-	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait), \
-	  .dmap = DEPT_MAP_INITIALIZER(work, NULL), }
+	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait), }
 
 #define COMPLETION_INITIALIZER_ONSTACK_MAP(work, map) \
 	(*({ init_completion_map(&(work), &(map)); &(work); }))
@@ -119,18 +114,18 @@ static inline void reinit_completion(struct completion *x)
 	x->done = 0;
 }
 
-extern void wait_for_completion(struct completion *);
-extern void wait_for_completion_io(struct completion *);
-extern int wait_for_completion_interruptible(struct completion *x);
-extern int wait_for_completion_killable(struct completion *x);
-extern int wait_for_completion_state(struct completion *x, unsigned int state);
-extern unsigned long wait_for_completion_timeout(struct completion *x,
+extern void __wait_for_completion(struct completion *);
+extern void __wait_for_completion_io(struct completion *);
+extern int __wait_for_completion_interruptible(struct completion *x);
+extern int __wait_for_completion_killable(struct completion *x);
+extern int __wait_for_completion_state(struct completion *x, unsigned int state);
+extern unsigned long __wait_for_completion_timeout(struct completion *x,
 						   unsigned long timeout);
-extern unsigned long wait_for_completion_io_timeout(struct completion *x,
+extern unsigned long __wait_for_completion_io_timeout(struct completion *x,
 						    unsigned long timeout);
-extern long wait_for_completion_interruptible_timeout(
+extern long __wait_for_completion_interruptible_timeout(
 	struct completion *x, unsigned long timeout);
-extern long wait_for_completion_killable_timeout(
+extern long __wait_for_completion_killable_timeout(
 	struct completion *x, unsigned long timeout);
 extern bool try_wait_for_completion(struct completion *x);
 extern bool completion_done(struct completion *x);
@@ -139,4 +134,79 @@ extern void complete(struct completion *);
 extern void complete_on_current_cpu(struct completion *x);
 extern void complete_all(struct completion *);
 
+#define wait_for_completion(x)						\
+({									\
+	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	__wait_for_completion(x);					\
+	sdt_might_sleep_end();						\
+})
+#define wait_for_completion_io(x)					\
+({									\
+	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	__wait_for_completion_io(x);					\
+	sdt_might_sleep_end();						\
+})
+#define wait_for_completion_interruptible(x)				\
+({									\
+	int __ret;							\
+									\
+	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	__ret = __wait_for_completion_interruptible(x);			\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
+#define wait_for_completion_killable(x)					\
+({									\
+	int __ret;							\
+									\
+	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	__ret = __wait_for_completion_killable(x);			\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
+#define wait_for_completion_state(x, s)					\
+({									\
+	int __ret;							\
+									\
+	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	__ret = __wait_for_completion_state(x, s);			\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
+#define wait_for_completion_timeout(x, t)				\
+({									\
+	unsigned long __ret;						\
+									\
+	sdt_might_sleep_start_timeout(NULL, t);				\
+	__ret = __wait_for_completion_timeout(x, t);			\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
+#define wait_for_completion_io_timeout(x, t)				\
+({									\
+	unsigned long __ret;						\
+									\
+	sdt_might_sleep_start_timeout(NULL, t);				\
+	__ret = __wait_for_completion_io_timeout(x, t);			\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
+#define wait_for_completion_interruptible_timeout(x, t)			\
+({									\
+	long __ret;							\
+									\
+	sdt_might_sleep_start_timeout(NULL, t);				\
+	__ret = __wait_for_completion_interruptible_timeout(x, t);	\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
+#define wait_for_completion_killable_timeout(x, t)			\
+({									\
+	long __ret;							\
+									\
+	sdt_might_sleep_start_timeout(NULL, t);				\
+	__ret = __wait_for_completion_killable_timeout(x, t);		\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
 #endif
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index 5e45a60ff7b3..7262000db114 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -4,7 +4,7 @@
  * Generic wait-for-completion handler;
  *
  * It differs from semaphores in that their default case is the opposite,
- * wait_for_completion default blocks whereas semaphore default non-block. The
+ * __wait_for_completion default blocks whereas semaphore default non-block. The
  * interface also makes it easy to 'complete' multiple waiting threads,
  * something which isn't entirely natural for semaphores.
  *
@@ -42,7 +42,7 @@ void complete_on_current_cpu(struct completion *x)
  * This will wake up a single thread waiting on this completion. Threads will be
  * awakened in the same order in which they were queued.
  *
- * See also complete_all(), wait_for_completion() and related routines.
+ * See also complete_all(), __wait_for_completion() and related routines.
  *
  * If this function wakes up a task, it executes a full memory barrier before
  * accessing the task state.
@@ -139,23 +139,23 @@ wait_for_common_io(struct completion *x, long timeout, int state)
 }
 
 /**
- * wait_for_completion: - waits for completion of a task
+ * __wait_for_completion: - waits for completion of a task
  * @x:  holds the state of this particular completion
  *
  * This waits to be signaled for completion of a specific task. It is NOT
  * interruptible and there is no timeout.
  *
- * See also similar routines (i.e. wait_for_completion_timeout()) with timeout
+ * See also similar routines (i.e. __wait_for_completion_timeout()) with timeout
  * and interrupt capability. Also see complete().
  */
-void __sched wait_for_completion(struct completion *x)
+void __sched __wait_for_completion(struct completion *x)
 {
 	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
 }
-EXPORT_SYMBOL(wait_for_completion);
+EXPORT_SYMBOL(__wait_for_completion);
 
 /**
- * wait_for_completion_timeout: - waits for completion of a task (w/timeout)
+ * __wait_for_completion_timeout: - waits for completion of a task (w/timeout)
  * @x:  holds the state of this particular completion
  * @timeout:  timeout value in jiffies
  *
@@ -167,28 +167,28 @@ EXPORT_SYMBOL(wait_for_completion);
  * till timeout) if completed.
  */
 unsigned long __sched
-wait_for_completion_timeout(struct completion *x, unsigned long timeout)
+__wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 {
 	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
 }
-EXPORT_SYMBOL(wait_for_completion_timeout);
+EXPORT_SYMBOL(__wait_for_completion_timeout);
 
 /**
- * wait_for_completion_io: - waits for completion of a task
+ * __wait_for_completion_io: - waits for completion of a task
  * @x:  holds the state of this particular completion
  *
  * This waits to be signaled for completion of a specific task. It is NOT
  * interruptible and there is no timeout. The caller is accounted as waiting
  * for IO (which traditionally means blkio only).
  */
-void __sched wait_for_completion_io(struct completion *x)
+void __sched __wait_for_completion_io(struct completion *x)
 {
 	wait_for_common_io(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
 }
-EXPORT_SYMBOL(wait_for_completion_io);
+EXPORT_SYMBOL(__wait_for_completion_io);
 
 /**
- * wait_for_completion_io_timeout: - waits for completion of a task (w/timeout)
+ * __wait_for_completion_io_timeout: - waits for completion of a task (w/timeout)
  * @x:  holds the state of this particular completion
  * @timeout:  timeout value in jiffies
  *
@@ -201,14 +201,14 @@ EXPORT_SYMBOL(wait_for_completion_io);
  * till timeout) if completed.
  */
 unsigned long __sched
-wait_for_completion_io_timeout(struct completion *x, unsigned long timeout)
+__wait_for_completion_io_timeout(struct completion *x, unsigned long timeout)
 {
 	return wait_for_common_io(x, timeout, TASK_UNINTERRUPTIBLE);
 }
-EXPORT_SYMBOL(wait_for_completion_io_timeout);
+EXPORT_SYMBOL(__wait_for_completion_io_timeout);
 
 /**
- * wait_for_completion_interruptible: - waits for completion of a task (w/intr)
+ * __wait_for_completion_interruptible: - waits for completion of a task (w/intr)
  * @x:  holds the state of this particular completion
  *
  * This waits for completion of a specific task to be signaled. It is
@@ -216,7 +216,7 @@ EXPORT_SYMBOL(wait_for_completion_io_timeout);
  *
  * Return: -ERESTARTSYS if interrupted, 0 if completed.
  */
-int __sched wait_for_completion_interruptible(struct completion *x)
+int __sched __wait_for_completion_interruptible(struct completion *x)
 {
 	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
 
@@ -224,10 +224,10 @@ int __sched wait_for_completion_interruptible(struct completion *x)
 		return t;
 	return 0;
 }
-EXPORT_SYMBOL(wait_for_completion_interruptible);
+EXPORT_SYMBOL(__wait_for_completion_interruptible);
 
 /**
- * wait_for_completion_interruptible_timeout: - waits for completion (w/(to,intr))
+ * __wait_for_completion_interruptible_timeout: - waits for completion (w/(to,intr))
  * @x:  holds the state of this particular completion
  * @timeout:  timeout value in jiffies
  *
@@ -238,15 +238,15 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
  * or number of jiffies left till timeout) if completed.
  */
 long __sched
-wait_for_completion_interruptible_timeout(struct completion *x,
+__wait_for_completion_interruptible_timeout(struct completion *x,
 					  unsigned long timeout)
 {
 	return wait_for_common(x, timeout, TASK_INTERRUPTIBLE);
 }
-EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
+EXPORT_SYMBOL(__wait_for_completion_interruptible_timeout);
 
 /**
- * wait_for_completion_killable: - waits for completion of a task (killable)
+ * __wait_for_completion_killable: - waits for completion of a task (killable)
  * @x:  holds the state of this particular completion
  *
  * This waits to be signaled for completion of a specific task. It can be
@@ -254,7 +254,7 @@ EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
  *
  * Return: -ERESTARTSYS if interrupted, 0 if completed.
  */
-int __sched wait_for_completion_killable(struct completion *x)
+int __sched __wait_for_completion_killable(struct completion *x)
 {
 	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
 
@@ -262,9 +262,9 @@ int __sched wait_for_completion_killable(struct completion *x)
 		return t;
 	return 0;
 }
-EXPORT_SYMBOL(wait_for_completion_killable);
+EXPORT_SYMBOL(__wait_for_completion_killable);
 
-int __sched wait_for_completion_state(struct completion *x, unsigned int state)
+int __sched __wait_for_completion_state(struct completion *x, unsigned int state)
 {
 	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, state);
 
@@ -272,10 +272,10 @@ int __sched wait_for_completion_state(struct completion *x, unsigned int state)
 		return t;
 	return 0;
 }
-EXPORT_SYMBOL(wait_for_completion_state);
+EXPORT_SYMBOL(__wait_for_completion_state);
 
 /**
- * wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
+ * __wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
  * @x:  holds the state of this particular completion
  * @timeout:  timeout value in jiffies
  *
@@ -287,12 +287,12 @@ EXPORT_SYMBOL(wait_for_completion_state);
  * or number of jiffies left till timeout) if completed.
  */
 long __sched
-wait_for_completion_killable_timeout(struct completion *x,
+__wait_for_completion_killable_timeout(struct completion *x,
 				     unsigned long timeout)
 {
 	return wait_for_common(x, timeout, TASK_KILLABLE);
 }
-EXPORT_SYMBOL(wait_for_completion_killable_timeout);
+EXPORT_SYMBOL(__wait_for_completion_killable_timeout);
 
 /**
  *	try_wait_for_completion - try to decrement a completion without blocking
@@ -334,7 +334,7 @@ EXPORT_SYMBOL(try_wait_for_completion);
  *	completion_done - Test to see if a completion has any waiters
  *	@x:	completion structure
  *
- *	Return: 0 if there are waiters (wait_for_completion() in progress)
+ *	Return: 0 if there are waiters (__wait_for_completion() in progress)
  *		 1 if there are no waiters.
  *
  *	Note, this will always return true if complete_all() was called on @X.
diff --git a/rust/helpers/completion.c b/rust/helpers/completion.c
index b2443262a2ae..5bae5e749def 100644
--- a/rust/helpers/completion.c
+++ b/rust/helpers/completion.c
@@ -6,3 +6,8 @@ void rust_helper_init_completion(struct completion *x)
 {
 	init_completion(x);
 }
+
+void rust_helper_wait_for_completion(struct completion *x)
+{
+	wait_for_completion(x);
+}
-- 
2.17.1


