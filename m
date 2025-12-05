Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251B4D2E017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABDE36B00F7; Fri,  5 Dec 2025 02:20:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A472D6B00FC; Fri,  5 Dec 2025 02:20:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898BB6B00FF; Fri,  5 Dec 2025 02:20:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65CA76B00F7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DCE813347F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:06 +0000 (UTC)
X-FDA: 84184568412.10.3DD6B8F
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2840A40003
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919204; a=rsa-sha256;
	cv=none;
	b=4IDGu8sUF3oNZzMBLs/wMkyPu3+fS6T+e9LJecQzoy6jBHv7ndoBMyMEd3tb+2MJEUJgKm
	AvDbVc/XP7gDJGN148GQ2GsnR1YEf4/GXfWK3WmiIC2gFwfhUMLQMGKE/mfOFDKutai0qH
	+75zAEfIzWQaWJ+JRXCPv3UatE6fmT8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=+HPkZ+RQ+sA8J0ONBLnI29qjI8ZpQRSXy2L/010uhRY=;
	b=coV/qLAguVkT/r0gUadRgIoFLUlY7egikNk2JmTBwZNv6bt/oGeaLYA+3lMIADRrLnXJjF
	YCN7M2TpimpqHC32PyCtJmjth/LhzXx/pFpTleeGSRWdDYZpxAzulXu20lRIpLAjdr8zgq
	8AFfcJWpf68UyKk2bTHtMR0Cj1B3+RI=
X-AuditID: a67dfc5b-c45ff70000001609-e4-69328772042c
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
Subject: [PATCH v18 33/42] dept: introduce a new type of dependency tracking between multi event sites
Date: Fri,  5 Dec 2025 16:18:46 +0900
Message-Id: <20251205071855.72743-34-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG/Z+7Y4vTKjzlh2JhkZBpdHmh6PIhPBB2ob6UQa12ytXU3MpL
	JLnIXFKWqy1KyWk0bVtpZ3ZRWyxFw0yaFbnyXmNmzrKlhqHZNPr243me93l54WVw+XtyAaNO
	OSFoU5QaBSUhJEPS0uW6vJXq2HfOSDDknoHOHh8JoyMGAoorHRRMFj2mwSDeIMFz344gt2aK
	gJHxDhpMegTmNiMOjmo9Bj+r/lAw2BBEYOrzUXB9QE/ATX8RDQON8TDV1Y9B+1gAgdX3BwOf
	Ow/BpPkYlJQ5Q0Pm4VDe5EFQ2teFQ3CgF0F1UzcCV8VZCobaijGwnHWRUNNbS0Pb4AQGnWYj
	BnYxAXqsfgJarpRhoX0UmB9EQNH1LxiY7tVhMG610fDqdicB1pwo6LpsIqC5+z0Jg34jBY9z
	emkQPzQicFz042CoHSVA/BxyDZMjCJqefMLgYtVDErodU6G73S0kvLF7CKjs92LwuvYeCX29
	XhKcra9wGCuI3KTif+UWELzN+QjjHbcciG8IfMf5c84M/k5LgOJdYxaCf1nG8TU3u2j+3LOP
	NG8RT/LOimj+9tMBjC8NjpK8aLtA8WLQSO9YtleyXiVo1OmCdsWGA5Kk9gnl8cJDmY3ieToH
	Fe7IR+EMx67iOorzyf9sdZXPMMUu5bzecXya57KLOOclf0iXMDj7diGXN14QMhhmDnuY0/ct
	ns4QbBQ33PqNnpZl7BrOdDfxX+VCzl7lnqkJn5bbf8+wnF3NleT/mqnk2JJwriRgx/4NzOee
	V3iJK0hmQWE2JFenpCcr1ZpVMUlZKerMmEOpySIKfZs1eyLxCQp6dtUjlkEKqcydEaeWk8p0
	XVZyPeIYXDFXFtDEquUylTLrlKBN3a89qRF09SiSIRQRspVjGSo5e0R5QjgmCMcF7X8XY8IX
	5CBVmOLHUIIxLSLDNavOLjuwxPGizrGzufawwVOe1tKBYglb/td57T2z+zcGC05n7Wwdkma/
	2xSZljg8586E/lrD2nq79W55/O7MLZUjw3vIbcX9l1Mrt0s7LdKmq/uiGNNBdzMXvbm7sGjF
	uuyasN1h8Vt/WrPjjvquDq5NcJtXRykIXZIyLhrX6pR/Ae9POqRpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzVSWUwTURT1zUxnhsbqWEkcNQrWGHFB0bjcqHH5cqLR+GHU6AcOMMqEFrBF
	BJdIqbW4Bpq0RCsKKFWhCLagIqk2KMSNWESlLmymooQiRAuEAmKr8efm3HPOPTkfl8bl1ZIZ
	tJicJqiTeaWClBLS7Wt10WrDcjGmo38x5OhPwud2rwTea10EDPhzCLhSYSNhzHKfghz7JQk8
	a8kmwH2nDEH7QA6CoRELDvqacQLGjA0U+Ic/UWDSIhh3NiAwNxlx8Lgf42Cr0mLwq/I3CT1P
	fiIwdXpJyO/WEtBnPY/gcpeFgu76zdDbXiuB8dZvGLQM+hBYvb8x8LoMCMbMSXCt2BE8N/eT
	MNL4God8kxtBUWcrDj+7OxBUNbQhcN7KJuFrbjUOzd5J8Hagj4TnpnMk9DZdweBHJQmF2U4J
	NL3qQVBgMSLo+ujEQHe9ggRzgZ2Amo6HFDT1jGLw2WzEoMy+DdqtXQS8zC3GgnWDrrvTwJKv
	w4LjOwam8loMhq2l1MYSxA3pLxJcqeMexunfjJGc7aoNcSMBI+L8JTqc0+cG1ye+Ppw75TjC
	lbz0kVxg4B3JOQcLCe5FMcvdOBPAuLzGaK7mciu1Y9Ne6boEQSmmC+ql6/dLE1tG+dS8+Ix6
	+2kqC+XtOIvCaJZZwVqdNyUhTDLzWY9nGA/hcCaSdVzoCvJSGmeaI1jD8MWgQNNTmQOstnNu
	yEMw89j+xh9UiJYxq1jT7X3/IiPYskrX35iwEN0S+IvlzEr22tkhSS6SFqIJpShcTE5X8aJy
	5RJNUmJmspixJD5FZUfBZ7KeGM17gPzNm+sQQyPFRJnryDJRLuHTNZmqOsTSuCJc5lPGiHJZ
	Ap95VFCnxKoPKwVNHZpJE4ppsi27hf1y5iCfJiQJQqqg/q9idNiMLBSVFL3LMPP4oQ1ZsbOm
	tx076b8wb/4ro2rrkK3QcKN8tmdPZHfFqjXH1xXgX2R90UuPqkQPQbra3O6nHSkZ2XGnx6cE
	pk6it3p9j/zKernG6YjJX/AxalFE3M4PbG9kCrM6taiRL8q0Dm4Lm+yzMm3xVQWviedpETsX
	xB56N0e3WkFoEvllC3G1hv8DvAV2HUgDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2840A40003
X-Stat-Signature: afd963nx4rq3ob6pc7iy6fatyzkf5gb5
X-Rspam-User: 
X-HE-Tag: 1764919203-224134
X-HE-Meta: U2FsdGVkX1/yINhVVHdxKCxNT4OKtjUbDgsP+ER+GpKuOILTwZ+IScxvN1xYtem0bMZHsyIqOe5Vvope96kZVsBf8fxyIEHFFifBJ/mfp/wbXhiDk+TIC2hgcOttsRkov/0Vjz4UGbiFfsXAyoD+BmrX232LQy3dh9Jlh7dbCq1bQ0RIq+HoDhhvTAR0HtmR8eyP2hhBjBJPHX4VWj0AUntvHUclremDcAeSJuXVTj0I27JUzVr8te/iteGrYD5nNSbNP3qDuA03sr363lCgNd7IDxMikeWer2mv/bfTb0iU7if0GvJkOSlUIca33pcphqJokK3pelpwLLp/eD70oKyJ/Wxs2S6WE5bNbd1khPCwsVfphqYmYa4P7N9RPTd5xALnK++ixMQatVT9WpSm7DmYpDVZSarPzoFi7D6ZfYszZiuXAB5jgBp818smjA6FF4DS+0B5tZHwUi0OnGB+bAeAKB6nOnyZKTiOyvoI8kKMy9g8q9qzouJZNZEIaPVDihHbvhFwJAzonR7iNgR2Ws6B6axUJUWAuZO9pMFakMARipKzk4jBbN6mIDrobT0lfx0JsKDd1WTR+f/TyRKbYRqPtCyJlbQIPoVEActYmYGEGKhlrV4yhB9YrpVy+xeow9aulcDT2nVyznRWKhKdxykHkVXiOuhYlCNZHcGOCNiqOHEzP8B5CnQsmGMpSBaE9GzIZKj/MsNoNyW9Si6YXI9sUnRtFhO1l2hX0RSlK7b5SrJokwTN+6yUKhS4u2h6in+gY/2GBDuzIi/uV58LpAWSoQEyYxk7Z7FHYHE/HbUQnKyKbD99c5WoZ/Ueu8Yr1O+UDGL1VvdS5uVn1JC6/UMdl1MjsA1Yu6XmgQGNEVM++VjtizEZ6grGVCla3vRYhDfB2t+ljW1Oe5yWlvE1Wl+9KyHS9hE2ACMLhG8nvy6fyFff3mMMzqz+rizx9pKTtG8+CLaF0pfN5qSgOEi
 PfbSbyzP
 KLOHkmQWBAt3CemzNvbUK/zNnYSs1CfX1Z3AZe8SB2lT8674=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's worth reporting wait-event circular dependency even if it doesn't
lead to an actual deadlock, because it's a good information about a
circular dependency anyway.  However, it should be suppressed once
turning out it doesn't lead an actual deadlock, for instance, there are
other wake-up(or event) paths.

The report needs to be suppressed by annotating that an event can be
recovered by other sites triggering the desired wake-up, using a newly
introduced API, dept_recover_event() specifying an event site and its
recover site.

By the introduction, need of a new type of dependency tracking arises
since a loop of recover dependency could trigger another type of
deadlock.  So implement a logic to track the new type of dependency
between multi event sites for a single wait.

Lastly, to make sure that recover sites must be used in code, introduce
a section '.dept.event_sites' to mark it as 'used' only if used in code,
and warn it if dept_recover_event()s are annotated with recover sites,
not used in code.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/asm-generic/vmlinux.lds.h |  13 +-
 include/linux/dept.h              |  91 ++++++++++++++
 kernel/dependency/dept.c          | 196 ++++++++++++++++++++++++++++++
 3 files changed, 299 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a464ff6c1a61..2680f85b677a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -717,6 +717,16 @@
 #define KERNEL_CTORS()
 #endif
 
+#ifdef CONFIG_DEPT
+#define DEPT_EVNET_SITES_USED()						\
+	. = ALIGN(8);							\
+	__dept_event_sites_start = .;					\
+	KEEP(*(.dept.event_sites))					\
+	__dept_event_sites_end = .;
+#else
+#define DEPT_EVNET_SITES_USED()
+#endif
+
 /* init and exit section handling */
 #define INIT_DATA							\
 	KEEP(*(SORT(___kentry+*)))					\
@@ -741,7 +751,8 @@
 	EARLYCON_TABLE()						\
 	LSM_TABLE()							\
 	EARLY_LSM_TABLE()						\
-	KUNIT_INIT_TABLE()
+	KUNIT_INIT_TABLE()						\
+	DEPT_EVNET_SITES_USED()
 
 #define INIT_TEXT							\
 	*(.init.text .init.text.*)					\
diff --git a/include/linux/dept.h b/include/linux/dept.h
index 8b41f7a65abb..44083e6651ab 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -142,6 +142,82 @@ struct dept_ext_wgen {
 	unsigned int wgen;
 };
 
+struct dept_event_site {
+	/*
+	 * event site name
+	 */
+	const char			*name;
+
+	/*
+	 * function name where the event is triggered in
+	 */
+	const char			*func_name;
+
+	/*
+	 * for associating its recover dependencies
+	 */
+	struct list_head		dep_head;
+	struct list_head		dep_rev_head;
+
+	/*
+	 * for BFS
+	 */
+	unsigned int			bfs_gen;
+	struct dept_event_site		*bfs_parent;
+	struct list_head		bfs_node;
+
+	/*
+	 * flag indicating the event is not only declared but also
+	 * actually used in code
+	 */
+	bool				used;
+};
+
+struct dept_event_site_dep {
+	struct dept_event_site		*evt_site;
+	struct dept_event_site		*recover_site;
+
+	/*
+	 * for linking to dept_event objects
+	 */
+	struct list_head		dep_node;
+	struct list_head		dep_rev_node;
+};
+
+#define DEPT_EVENT_SITE_INITIALIZER(es)					\
+{									\
+	.name = #es,							\
+	.func_name = NULL,						\
+	.dep_head = LIST_HEAD_INIT((es).dep_head),			\
+	.dep_rev_head = LIST_HEAD_INIT((es).dep_rev_head),		\
+	.bfs_gen = 0,							\
+	.bfs_parent = NULL,						\
+	.bfs_node = LIST_HEAD_INIT((es).bfs_node),			\
+	.used = false,							\
+}
+
+#define DEPT_EVENT_SITE_DEP_INITIALIZER(esd)				\
+{									\
+	.evt_site = NULL,						\
+	.recover_site = NULL,						\
+	.dep_node = LIST_HEAD_INIT((esd).dep_node),			\
+	.dep_rev_node = LIST_HEAD_INIT((esd).dep_rev_node),		\
+}
+
+struct dept_event_site_init {
+	struct dept_event_site *evt_site;
+	const char *func_name;
+};
+
+#define dept_event_site_used(es)					\
+do {									\
+	static struct dept_event_site_init _evtinit __initdata =	\
+		{ .evt_site = (es), .func_name = __func__ };		\
+	static struct dept_event_site_init *_evtinitp __used		\
+		__attribute__((__section__(".dept.event_sites"))) =	\
+		&_evtinit;						\
+} while (0)
+
 extern void dept_stop_emerg(void);
 extern void dept_on(void);
 extern void dept_off(void);
@@ -179,6 +255,14 @@ static inline void dept_ecxt_enter_nokeep(struct dept_map *m)
 extern void dept_key_init(struct dept_key *k);
 extern void dept_key_destroy(struct dept_key *k);
 extern void dept_map_ecxt_modify(struct dept_map *m, unsigned long e_f, struct dept_key *new_k, unsigned long new_e_f, unsigned long new_ip, const char *new_c_fn, const char *new_e_fn, int new_sub_l);
+extern void __dept_recover_event(struct dept_event_site_dep *esd, struct dept_event_site *es, struct dept_event_site *rs);
+
+#define dept_recover_event(es, rs)					\
+do {									\
+	static struct dept_event_site_dep _esd = DEPT_EVENT_SITE_DEP_INITIALIZER(_esd);\
+									\
+	__dept_recover_event(&_esd, es, rs);				\
+} while (0)
 
 extern void dept_softirq_enter(void);
 extern void dept_hardirq_enter(void);
@@ -192,8 +276,10 @@ extern void dept_hardirqs_off(void);
 struct dept_key { };
 struct dept_map { };
 struct dept_ext_wgen { };
+struct dept_event_site { };
 
 #define DEPT_MAP_INITIALIZER(n, k) { }
+#define DEPT_EVENT_SITE_INITIALIZER(es) { }
 
 #define dept_stop_emerg()				do { } while (0)
 #define dept_on()					do { } while (0)
@@ -224,6 +310,7 @@ struct dept_ext_wgen { };
 #define dept_key_init(k)				do { (void)(k); } while (0)
 #define dept_key_destroy(k)				do { (void)(k); } while (0)
 #define dept_map_ecxt_modify(m, e_f, n_k, n_e_f, n_ip, n_c_fn, n_e_fn, n_sl) do { (void)(n_k); (void)(n_c_fn); (void)(n_e_fn); } while (0)
+#define dept_recover_event(es, rs)			do { } while (0)
 
 #define dept_softirq_enter()				do { } while (0)
 #define dept_hardirq_enter()				do { } while (0)
@@ -234,4 +321,8 @@ struct dept_ext_wgen { };
 
 #define dept_set_lockdep_map(m, lockdep_m)		do { } while (0)
 #endif
+
+#define DECLARE_DEPT_EVENT_SITE(es) extern struct dept_event_site (es)
+#define DEFINE_DEPT_EVENT_SITE(es) struct dept_event_site (es) = DEPT_EVENT_SITE_INITIALIZER(es)
+
 #endif /* __LINUX_DEPT_H */
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 1de61306418b..b14400c4f83b 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -973,6 +973,117 @@ static void bfs(void *root, struct bfs_ops *ops, void *in, void **out)
 	}
 }
 
+/*
+ * Recover dependency between event sites
+ * =====================================================================
+ * Even though an event is in a chain of wait-event circular dependency,
+ * the corresponding wait might be woken up by another site triggering
+ * the desired event.  To reflect that, dept allows to annotate the
+ * recover relationship between event sites using __dept_recover_event().
+ * However, that requires to track a new type of dependency between the
+ * event sites.
+ */
+
+/*
+ * Print all events in the circle.
+ */
+static void print_recover_circle(struct dept_event_site *es)
+{
+	struct dept_event_site *from = es->bfs_parent;
+	struct dept_event_site *to = es;
+
+	dept_outworld_enter();
+
+	pr_warn("===================================================\n");
+	pr_warn("DEPT: Circular recover dependency has been detected.\n");
+	pr_warn("%s %.*s %s\n", init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version,
+		print_tainted());
+	pr_warn("---------------------------------------------------\n");
+
+	do {
+		print_spc(1, "event site(%s@%s)\n", from->name, from->func_name);
+		print_spc(1, "-> event site(%s@%s)\n", to->name, to->func_name);
+		to = from;
+		from = from->bfs_parent;
+
+		if (to != es)
+			pr_warn("\n");
+	} while (to != es);
+
+	pr_warn("---------------------------------------------------\n");
+	pr_warn("information that might be helpful\n");
+	pr_warn("---------------------------------------------------\n");
+	dump_stack();
+
+	dept_outworld_exit();
+}
+
+static void bfs_init_recover(void *node, void *in, void **out)
+{
+	struct dept_event_site *root = (struct dept_event_site *)node;
+	struct dept_event_site_dep *new = (struct dept_event_site_dep *)in;
+
+	root->bfs_gen = bfs_gen;
+	new->recover_site->bfs_parent = new->evt_site;
+}
+
+static void bfs_extend_recover(struct list_head *h, void *node)
+{
+	struct dept_event_site *cur = (struct dept_event_site *)node;
+	struct dept_event_site_dep *esd;
+
+	list_for_each_entry(esd, &cur->dep_head, dep_node) {
+		struct dept_event_site *next = esd->recover_site;
+
+		if (bfs_gen == next->bfs_gen)
+			continue;
+		next->bfs_parent = cur;
+		next->bfs_gen = bfs_gen;
+		list_add_tail(&next->bfs_node, h);
+	}
+}
+
+static void *bfs_dequeue_recover(struct list_head *h)
+{
+	struct dept_event_site *es;
+
+	DEPT_WARN_ON(list_empty(h));
+
+	es = list_first_entry(h, struct dept_event_site, bfs_node);
+	list_del(&es->bfs_node);
+	return es;
+}
+
+static enum bfs_ret cb_check_recover_dl(void *node, void *in, void **out)
+{
+	struct dept_event_site *cur = (struct dept_event_site *)node;
+	struct dept_event_site_dep *new = (struct dept_event_site_dep *)in;
+
+	if (cur == new->evt_site) {
+		print_recover_circle(new->recover_site);
+		return BFS_DONE;
+	}
+
+	return BFS_CONTINUE;
+}
+
+/*
+ * NOTE: Must be called with dept_lock held.
+ */
+static void check_recover_dl_bfs(struct dept_event_site_dep *esd)
+{
+	struct bfs_ops ops = {
+		.bfs_init = bfs_init_recover,
+		.extend = bfs_extend_recover,
+		.dequeue = bfs_dequeue_recover,
+		.callback = cb_check_recover_dl,
+	};
+
+	bfs((void *)esd->recover_site, &ops, (void *)esd, NULL);
+}
+
 /*
  * Main operations
  * =====================================================================
@@ -3166,8 +3277,78 @@ static void migrate_per_cpu_pool(void)
 	}
 }
 
+static bool dept_recover_ready;
+
+void __dept_recover_event(struct dept_event_site_dep *esd,
+		struct dept_event_site *es, struct dept_event_site *rs)
+{
+	struct dept_task *dt = dept_task();
+	unsigned long flags;
+
+	if (unlikely(!dept_working()))
+		return;
+
+	if (dt->recursive)
+		return;
+
+	if (!esd || !es || !rs) {
+		DEPT_WARN_ONCE("All the parameters should be !NULL.\n");
+		return;
+	}
+
+	/*
+	 * Check locklessly if another already has done it for us.
+	 */
+	if (READ_ONCE(esd->evt_site))
+		return;
+
+	if (!dept_recover_ready) {
+		DEPT_WARN("Should be called once dept_recover_ready.\n");
+		return;
+	}
+
+	flags = dept_enter();
+	if (unlikely(!dept_lock()))
+		goto exit;
+
+	/*
+	 * Check if another already has done it for us with lock held.
+	 */
+	if (esd->evt_site)
+		goto unlock;
+
+	/*
+	 * Can be used as an indicator of whether this
+	 * __dept_recover_event() has been processed or not as well as
+	 * for storing its associated events.
+	 */
+	WRITE_ONCE(esd->evt_site, es);
+	esd->recover_site = rs;
+
+	if (!es->used || !rs->used) {
+		if (!es->used)
+			DEPT_INFO("dept_event_site %s has never been used.\n", es->name);
+		if (!rs->used)
+			DEPT_INFO("dept_event_site %s has never been used.\n", rs->name);
+
+		DEPT_WARN("Cannot track recover dependency with events that never used.\n");
+		goto unlock;
+	}
+
+	list_add(&esd->dep_node, &es->dep_head);
+	list_add(&esd->dep_rev_node, &rs->dep_rev_head);
+	check_recover_dl_bfs(esd);
+unlock:
+	dept_unlock();
+exit:
+	dept_exit(flags);
+}
+EXPORT_SYMBOL_GPL(__dept_recover_event);
+
 #define B2KB(B) ((B) / 1024)
 
+extern char __dept_event_sites_start[], __dept_event_sites_end[];
+
 /*
  * Should be called after setup_per_cpu_areas() and before no non-boot
  * CPUs have been on.
@@ -3175,6 +3356,21 @@ static void migrate_per_cpu_pool(void)
 void __init dept_init(void)
 {
 	size_t mem_total = 0;
+	struct dept_event_site_init **evtinitpp;
+
+	/*
+	 * dept recover dependency tracking works from now on.
+	 */
+	for (evtinitpp = (struct dept_event_site_init **)__dept_event_sites_start;
+	     evtinitpp < (struct dept_event_site_init **)__dept_event_sites_end;
+	     evtinitpp++) {
+		(*evtinitpp)->evt_site->used = true;
+		(*evtinitpp)->evt_site->func_name = (*evtinitpp)->func_name;
+		pr_info("dept_event %s@%s is initialized.\n",
+				(*evtinitpp)->evt_site->name,
+				(*evtinitpp)->evt_site->func_name);
+	}
+	dept_recover_ready = true;
 
 	local_irq_disable();
 	dept_per_cpu_ready = 1;
-- 
2.17.1


