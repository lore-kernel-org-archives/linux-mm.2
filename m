Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D69FD2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB996B00FE; Fri,  5 Dec 2025 02:20:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27EB6B00FB; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A866B00FC; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90C026B00F3
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63B9E8A4A4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:04 +0000 (UTC)
X-FDA: 84184568328.26.97F5B8C
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8CF082000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=qUI8dD2nVOyy+ILt7ExmRWmv2yHZTuqbXAS17IXwLOg=;
	b=7tR0Thypp7cBoiKja0tlIpNeuYzcEOhFmwyhXQSzPl1NJlBjR15jUrwzQhZX0DOTeieVI8
	CTh3VQpteh2ElpQ7vRYO4N+WpvOiFlCGqNmnH13eEKSDCEpUTtl7eTsG97UG7UGTZibyOs
	p298l9VisbcCPWccDwrrNpybG1Ppc6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919202; a=rsa-sha256;
	cv=none;
	b=XAyXQPV16mRY/4GuzuX/3mmLP+S6cwsUMiyludNTxFHumZmdd/lTFP8tbj5RAlUYm3Z3zV
	s/CVYNlKEGVm/xM278iw+lzq1LBRVwXYaGCII1XMC/3HTeVfeiDnA4DIMcbQinq6wGWVeY
	A0rkT7af/tIdzvXzq0qVXFx4X0szxKk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-6c-69328771e8c3
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
Subject: [PATCH v18 29/42] dept: make dept aware of lockdep_set_lock_cmp_fn() annotation
Date: Fri,  5 Dec 2025 16:18:42 +0900
Message-Id: <20251205071855.72743-30-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+7/XbTl6WUFvCSmjsLIspeIQGX3ww5tfKgoqFWrkm47mrFlO
	i7K85CU1k9TczLvLdF7aLEoyzWpEaiZ2WfNuNROzRJ02ndlc9O13nuc5h3PgCHCJhVwrkCvP
	8yqlTCGlRIRo3K1kqyrZT77dPuEOvQNfSfh4rYUA23QKAQV1egpSDPkkzM5rcVjINtEwbe+h
	YbHJhEDfcA2Dqfo/FIy9mESQM/SVgl+6dAQaq9YZ6RvBoKjU6HRzJyiY7+jEIS/nHYLJ0UEE
	DaZ+BN+yHuLw3vaLgvGuAgx+1lNQHN9EQlf7GAKrpQmDhLI6CnLvGgh4MthIQ9eYA4MBnZWA
	tqxSDPJGneaD1aDN+46BXVdFQ3tZLwHDlRoaHEO+sFgcCabqERpqxztJGLNmU2D4/Mq5eLoV
	h5RGGwGGLx9JaLJ4Q8n1cgLyC3ud5y5MIzA9Hsagu7GAgvT6hyT06xdJqBsxY9Bmek1AT8dN
	Gjoba0gwdrTjMJPpvi+Um03KJLgq4yOM0xfqETc/l4246YoEnEvKcpaJRjVX0faD4uZsHyju
	TSnLlafOYdwTTR/NJT6z0Fyx4QKX+HKc5IyVmw/6BYn2hPIKeTSv2rb3pCh88G0bdjbXK+bO
	zw1XkcYjDQkFLLOD7Z8ow/9zkbaTXmKK8WLNZrtLX8V4ssYMK5mGRAKc6fZgk+2ZLmMlc4z9
	ZEvDlphgNrBPa3RoicXMLjZ+8Db9b6gHW13f4soLnXrOpzkXS5idbFHarGsoy9wTsoWOPOpf
	wxr2eaWZyELiYrSsCknkyugImVyxwyc8VimP8TkVGWFAzo/TXXYEP0aT7w63IkaApG7iFrWv
	XELKoqNiI1oRK8Clq8Q/FNvlEnGoLPYir4o8obqg4KNakbuAkK4W+82oQyVMmOw8f4bnz/Kq
	/y4mEK69ilLP+W86Gua57srbL6kzgWiFdsiSrGj4bEEre3f737d43kloKakJESm9SFmNz62E
	rgrToWaLZjTuQXPsVE/M4mRtdPD+JDbnN3EjsDrw9aWGjO5navK2Q73lwPHuI+apSIN33N2A
	lzFbg4VHQsLe9KlhY8amAMdyve/6uObTAflBUiIqXOa7GVdFyf4Co+nbDW0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe2xLcRTH/X739t6uVq6auBkyKeKV0WFyxJtkLolH4g/iEWu4sVo3tLMH
	8eimNhvSNdrZis5YyR42nddMWSYWzFgNHTatqM2y2YZ1tU1NN/HPyeec7/d8c/44QkJyRxAs
	VMTG8apYuVJKiUjRuoUpoftT5yhkna3TIE17FBqdbgG81VSS4OlOI+F8SREFPtMdGtKs2QJ4
	4kgmoe56IQKnJw2Bt99EgLZ8gASfvpqG7t4PNBg0CAZs1QiMdj0BDXUPCSi6qcHws/QPBW2P
	fiAwfHJTkNWqIaHTcgpBTrOJhtbHq+Cbs0IAA00tGBw97Qgs7j8Y3JWpCHzGaDDnlfnXjV0U
	9Ne+JCDLUIfg0qcmAn60uhDcrP6IwHYtmYIvulsE1LtHwGtPJwVPDRkUfLOfx9BRSkFusk0A
	9udtCC6Y9Aia39swpFwuocB4wUpCueseDfa23xgajXoMhda14LQ0k1Cjy8P+c/2uG2PBlJWC
	/eUrBkNxBYZeSwG9LB9xXu0Zkisou4057SsfxRVdLEJcf58ecd35KQSn1fnbR+2dBHe8LIHL
	r2mnuD7PG4qz9eSS3LM8lrtysg9zmbWhXHlOE71h+RbRol28UhHPq2YviRRFuV7U4H3GqYnn
	OqYcQzkh6ShAyDLzWLPpJT3IFDOVbWjoJQY5iJnIlp1uFqQjkZBg6kPY1N4zQ8JoZjPr8KTj
	QSaZKez9YgsaZDEzn012naX/hYawhaWVQ/4A/9zg6BtiCRPOmtO9Ah0S5aJhBShIERsfI1co
	w2epo6OSYhWJs3bujbEi/ztZDv/OvIu661dVIUaIpIHiyoQwhUQgj1cnxVQhVkhIg8TtSplC
	It4lTzrIq/buUB1Q8uoqNE5ISseK12ziIyXMbnkcH83z+3jVfxULA4KPoSrZO2/GxsiljtWv
	3/bYuezt4S0rkhYfrs92abZFjFqhC5zg3Rr4feXn1WHVCzbKZqLPZtGDlt3OuJ+NiYaLZl/J
	pHk7PyzJxNkVjhHLJp+Y9KskVBZxqtbxPfd6xKHZwdbA4d4HGRldHSfix0/f8zjAe3L8qIQj
	XVfWXx0zsrg0sW7uKympjpKHzSBUavlfDbu1g0oDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CF082000A
X-Stat-Signature: uxdjf73oz4me3x5dzkk77c5oxwtejxfo
X-HE-Tag: 1764919202-173175
X-HE-Meta: U2FsdGVkX18AWEP2idClDULYSUOcC2olIHXFriIaKnDu/1MkKv2QuJN1z9GKqTwYKMCiUiMaCrWQqB8W0bNxu6WkAFS5VY4lmbM6RIZoG2IWHKQa0pP9EDpZGt8zlaKZonnP2p+82LED2Iex5sfNzupW9oZs1WZy44faKovsxsDlDn1jTByZpJmqCjGSS6BlZkqtoAZSC8kXR3p4rojvrl39eFMW/ghf8Ju0t3RtqyNLpj+InB/V1Uo2/VrTVPhYya45U98aaa+MrMLwFURKDZOS+ScaZElzDisw9KxNCT5+DJ2WrUlS2R9Vwt9U+DGw2W3v1k46uTuTnyuY6AQKV5j61wSh2T+ES+3gp8Uvgy4mPLjEZ6PLEUvoa4kRVv1jsEe4HGmGyIkWAvvi+fugsb6D4H+Qyzj1OJTkXs5fgJPgds0xFClrQUQup13VjQ7eWHNq/RPiba7Pnb2tLiez0vpDVUvQSPSZazYnHqDfxt9V8gs+fGzsLwHhyPBRGAwtPkw+tcisUhhZvUry5GiwJjo63a3evtyOO0i/RlCC+ylgCH74cF+2PLT7j1jrmWaFcf3npl6VlSb4NHEBroL81JvpEF7wYrPa7wLez2TN3kV8thm0Ywro6sX8woX3mAWzSPtT9gGZ93VSSvrOwZD1VqUJ+BgbjH+VzCA2GWxu6y48ElhSA3+hFrqtzy/OYYRsWJKT/+ynwgVoLh/FEIISPQGYK+497Ctu97xZvgeDwnnSGdUaGZMZF4AwI4lkLVILuTJjA0IXsFP6RuuWJcyctuWfbMgA9O/iiEzsqxgXYDuZF25xF2VOKlS9JVV+U370F3byjqf4Enc/J3sfDhJIvRNlcCR/2keWK7DxtfcSpELN5wUJnOT7SaM29fsJ35HjjBRUXovepNZMwohpeFNy5cnHYmQRpzcKGxpbjXyfiAYieOBeLzoot1ygnQAflVjoFiTYqhXQ6GhCSkjFbM7
 ymkIXLHT
 S3//b2iJ57RxUCDLvmxFIu+dhe1n1zqCJtnc03O396S8AsJcyy7hejq2+9VEUbO0hhOAqsT1wqG3/fgjQk6MxqTgqcUFloaMHk7Q5NcbXqIFALSwCFth/dZtMEuAeMICW5ZTy1tIiHOeTTQwCPz3U5xB03ItJwXiUI/7UcUJDfTwuSHSF4OyBHQYRBQTTDlnoahzpBuPhMxoP6io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit eb1cfd09f788e ("lockdep: Add lock_set_cmp_fn() annotation") has
been added to address the issue that lockdep was not able to detect a
true deadlock like the following:

   https://lore.kernel.org/lkml/20220510232633.GA18445@X58A-UD3R/

The approach is only for lockdep but dept should work being aware of it
because the new annotation is already used to avoid false positive of
lockdep in the code.

Make dept aware of the new lockdep annotation.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept.h     | 10 +++++++++
 kernel/dependency/dept.c | 48 +++++++++++++++++++++++++++++++++++-----
 kernel/locking/lockdep.c |  1 +
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/include/linux/dept.h b/include/linux/dept.h
index 7d5e01f56e8e..bbcb48f6140a 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -53,6 +53,11 @@ struct dept_map {
 	const char			*name;
 	struct dept_key			*keys;
 
+	/*
+	 * keep lockdep map to handle lockdep_set_lock_cmp_fn().
+	 */
+	void				*lockdep_map;
+
 	/*
 	 * subclass that can be set from user
 	 */
@@ -79,6 +84,7 @@ struct dept_map {
 {									\
 	.name = #n,							\
 	.keys = (struct dept_key *)(k),					\
+	.lockdep_map = NULL,						\
 	.sub_u = 0,							\
 	.map_key = { .classes = { NULL, } },				\
 	.wgen = 0U,							\
@@ -179,6 +185,8 @@ extern void dept_softirqs_on_ip(unsigned long ip);
 extern void dept_hardirqs_on(void);
 extern void dept_softirqs_off(void);
 extern void dept_hardirqs_off(void);
+
+#define dept_set_lockdep_map(m, lockdep_m) ({ (m)->lockdep_map = lockdep_m; })
 #else /* !CONFIG_DEPT */
 struct dept_key { };
 struct dept_map { };
@@ -221,5 +229,7 @@ struct dept_ext_wgen { };
 #define dept_hardirqs_on()				do { } while (0)
 #define dept_softirqs_off()				do { } while (0)
 #define dept_hardirqs_off()				do { } while (0)
+
+#define dept_set_lockdep_map(m, lockdep_m)		do { } while (0)
 #endif
 #endif /* __LINUX_DEPT_H */
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 1c6eb0a6d0a6..a0eb4b108de0 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -1615,9 +1615,39 @@ static int next_wgen(void)
 	return atomic_inc_return(&wgen) ?: atomic_inc_return(&wgen);
 }
 
-static void add_wait(struct dept_class *c, unsigned long ip,
-		     const char *w_fn, int sub_l, bool sched_sleep,
-		     bool timeout)
+/*
+ * XXX: This is a temporary patch needed until lockdep stops tracking
+ * dependency in wrong way.  lockdep has added an annotation to specify
+ * a callback to determin whether the given lock aquisition order is
+ * okay or not in its own way.  Even though dept is already working
+ * correctly with sub class on that issue, it needs to be aware of the
+ * annotation anyway.
+ */
+static bool lockdep_cmp_fn(struct dept_map *prev, struct dept_map *next)
+{
+	/*
+	 * Assumes the cmp_fn thing comes from struct lockdep_map.
+	 */
+	struct lockdep_map *p_lock = (struct lockdep_map *)prev->lockdep_map;
+	struct lockdep_map *n_lock = (struct lockdep_map *)next->lockdep_map;
+	struct lock_class *p_class = p_lock ? p_lock->class_cache[0] : NULL;
+	struct lock_class *n_class = n_lock ? n_lock->class_cache[0] : NULL;
+
+	if (!p_class || !n_class)
+		return false;
+
+	if (p_class != n_class)
+		return false;
+
+	if (!p_class->cmp_fn)
+		return false;
+
+	return p_class->cmp_fn(p_lock, n_lock) < 0;
+}
+
+static void add_wait(struct dept_map *m, struct dept_class *c,
+		unsigned long ip, const char *w_fn, int sub_l,
+		bool sched_sleep, bool timeout)
 {
 	struct dept_task *dt = dept_task();
 	struct dept_wait *w;
@@ -1658,8 +1688,13 @@ static void add_wait(struct dept_class *c, unsigned long ip,
 		if (!eh->ecxt)
 			continue;
 
-		if (eh->ecxt->class != c || eh->sub_l == sub_l)
-			add_dep(eh->ecxt, w);
+		if (eh->ecxt->class == c && eh->sub_l != sub_l)
+			continue;
+
+		if (i == dt->ecxt_held_pos - 1 && lockdep_cmp_fn(eh->map, m))
+			continue;
+
+		add_dep(eh->ecxt, w);
 	}
 
 	wg = next_wgen();
@@ -2145,6 +2180,7 @@ void dept_map_init(struct dept_map *m, struct dept_key *k, int sub_u,
 	m->name = n;
 	m->wgen = 0U;
 	m->nocheck = !valid_key(k);
+	m->lockdep_map = NULL;
 
 	dept_exit_recursive(flags);
 }
@@ -2366,7 +2402,7 @@ static void __dept_wait(struct dept_map *m, unsigned long w_f,
 		if (!c)
 			continue;
 
-		add_wait(c, ip, w_fn, sub_l, sched_sleep, timeout);
+		add_wait(m, c, ip, w_fn, sub_l, sched_sleep, timeout);
 	}
 }
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 39b9e3e27c0b..c99f91f7a54d 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5035,6 +5035,7 @@ void lockdep_set_lock_cmp_fn(struct lockdep_map *lock, lock_cmp_fn cmp_fn,
 		class->print_fn = print_fn;
 	}
 
+	dept_set_lockdep_map(&lock->dmap, lock);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
-- 
2.17.1


