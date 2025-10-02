Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A5C6CCA472
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAAF8E0028; Thu,  2 Oct 2025 04:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B4F8E0022; Thu,  2 Oct 2025 04:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96EEA8E0028; Thu,  2 Oct 2025 04:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7988A8E0022
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 415E086B76
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:10 +0000 (UTC)
X-FDA: 83952461460.18.FFFBE6B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5C212A0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=SZ0iRZD6O9XRZZ1EeKWTYzS9QV3p/d1hk73zEjNYEuM=;
	b=hHyDirp2n8ushTb8pWM0zePCam9KeOPuGk8KBuwg8b9Va52jl5Mfp37K9quYOYjfpzjW/X
	Sekk8WgG17qviEH+dAR6/VZhmGtSYigMP4vOSTRJochrCTnq5Fhw54hDjZZSXawMmRC/k0
	skwB/pfLNjXJ4GKaa9hUx4mBOZnouhQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392848; a=rsa-sha256;
	cv=none;
	b=aatL4tmcwb2U16HuLBhWtHwKZbEO1aKdHVA0Brf+hmYDhPQTWRXrF6BrwG6FH7r9IOCD6G
	D6f41YZmLWE43wWUoFKX6UhwOexTQSq7yJ8G9/Idv9EwNXvqJ9RD4FWllAFp0sK3cpRSQU
	Jv+7MOOVeHRdx06J8ewlDM0/8XBFKNU=
X-AuditID: a67dfc5b-c2dff70000001609-b2-68de34112b76
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
Subject: [PATCH v17 27/47] locking/lockdep: prevent various lockdep assertions when lockdep_off()'ed
Date: Thu,  2 Oct 2025 17:12:27 +0900
Message-Id: <20251002081247.51255-28-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfVDLcRzH+/6etnaNn8X5kcPtPIbIhc8fOOfO+f3jjnOO4w/Gfmc7tdxi
	lYcTNaLJiuVqclPXT9piNo89XXJNSSx1WWnNyNT1dOhBLNnCf6/7fN6v9+efjxCXuMjZQqXq
	GKdWyWKllIgQ9YfdWiGJ6VSs+qSbD61nqwkYHkon4MY9CwXptlwSnHfNCDzD6QhGfxlxGBp7
	L4CJSgeCnKZsHL5bf1Ng8HZRMMjrEPTUboV+TzkJE+4vGLwb6UPAd/3G4LrBiaDbegHBA0cn
	guauKdAyPEhBvSGDgv6mGxgMWCkwnaskISffRkBHTjYGHt5HQIO+IKD3UJBzfyYYr3djMMaX
	COBVYQcBxsZmEj4W5wnA742GCVM8OMxfBOC+YiCgvrOVhF5fNgWeF+dJsLXVIsi92UFBRWU9
	AenjQwgcTz5ioLM+JKHTMkFCinGUhLdmZ+Cmo46AN2WlJBS9a8LA+8FFgr3xFQ4jmRHgzLpM
	gkv/GUHpQAEFVwd8aJOcHdVmEmyJ/RHGat+OU6zlpgWxQ0WpOKvVByjNnsgWNfRR7MsChn2a
	5xawaVXtAtZkO87aiyPZwooejG3v3cDaSi5S25fsFa2Xc7FKDadeufGASHFW208cbZuW9LK6
	F6UgfuolFCpk6Bjmh6NM8J+dvtdYkCl6MeNyjeFBnk7PZ+yXfWSQcbphDtPatDzI4bScqcro
	ncwT9ELG4C+f7BHTa5mqlNJ/nfMYs7V6sic0MG/2NhBBltBrGO1gWsAVBTLGUMaZ2YP9FWYx
	z4pdhB6JTSikBEmUKk2cTBkbE6VIVimTog7Fx9lQ4N/40/59T9A3584aRAuRNEzsXOhWSEiZ
	JiE5rgYxQlw6XXyguEMhEctlySc4dfx+9fFYLqEGRQgJ6Uzx6pFEuYQ+LDvGHeG4o5z6/xYT
	hs5OQScP/7ry+DUdddGqz1p0KsJWa0g8UacNn/W8fbMqdbfxgrCvMLJSvOa2eG4b6DR+95Y8
	jXzsIJ/USP+0VodnTC073fJzBp+6bkGWudykXGnzVVg0uSGru8ajPao9C7jh/O/blnZvavTn
	z2O+puqutWQ+PBMSsuzgjjveXfz5uiNhUiJBIYuOxNUJsj+jVpGvawMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+7/XuZq9LcmXipLhEsSy6MLJIqovvZVdqA9BRDnzbVtOra1M
	A8HbSOw2F5vlLM1qiFrazMhEEyMhbeWy7Lapq6WFs6Fuijm1rejL4XfO8/DwfDgCXPyYXCxQ
	pp7h1akylYQSEsK9m/JWLljXq1g9+WQR9OS0EuDzFhBQWltDQYHlBgldD6oR9PkKEExMmXDQ
	Ns4SMK1vp8E7+YWG2eZ2BEabHoeaRzkYjNXNUDD0fBSBwemioPhnDgEe8yUEJQMmGn6+2AHD
	fU0kzDoGMfgw7kZgds1g4Gq9gGDamAxlFfUUTFnf4FBs6EJw2+nA4UddQHzU3ouguTKXgu+6
	Bhy6XaHwzueh4KXhIgXDtlIMftVRUJ7bTMJNkx5B3p1aCow3LQQ09j+lwTbkx8Bu1GNQbdkD
	feYBAjp1FVigX8D1MBxMxXlYYPzAwHC/CYNJcxUNr+7YCTBnS8Fk7Sbha2UJDX7nGpgtT4P2
	6kEaHFcNBDwYfkNuNSBuQnuF4KrqH2Oc9u00xdXcqkHc1G894rz38nBOqwusz90enMuvP8fd
	63RT3G/fe4prHi8nuI4KliuyruQaSxw0l9/ymd4fd1i4OYlXKdN5deyWBKEiRztMnPq0IKOj
	dQhlI/P8QhQiYJl1bNfAayzIFBPFfvw4iQc5jIlg6y8PkEHGmc6lbI8tJsgLmSS25eLQXz/B
	SFmDv4kOsojZwLZk36f/ZS5nq+ta/+aEBO7dzk4iyGJmPav15GM6JCxHc6pQmDI1PUWmVK1f
	pUlWZKYqM1YdT0uxoMA3mbP8RU+Qt3tHG2IESDJPZJM6FGJSlq7JTGlDrACXhIkSKu0KsShJ
	lnmeV6cdU59V8Zo2tERASMJFuw7xCWJGLjvDJ/P8KV79X8UEIYuz0dr+I0cfbrX74z06edhI
	TOiYceO4PDdKXjg6o9cXvhYljpSmOYWVB2pN8e4G6bLrDd7Efct2WkczX13LkL7YHjehEj77
	5iuMihTFDmqje8LfFmfN9Z8Yc9uLxLBaXpa+7aQg3rXb6rWsOHj6nHhXmTA69C552JL1LjLi
	Q4SkbUZCaBSyNdG4WiP7A0laOYtJAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: qokptcj3ghgasu5k7wkrbqy4w4hrrcce
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C212A0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392848-113477
X-HE-Meta: U2FsdGVkX1/ST2pEkdJDxcU5E+qltkhWrOIDAzMHJlKo9OmmnnUiIhYF9eUsTKtQwBgzsbSsHBI/+Gxz8L/9TMuYjHFrXtDKYuONGMNmfbwWSGnxY6HL4bBBr/8v8pCOBHXsbWPxEiwPa+61x9dQfYqvrk0bbOCY0lSe2Pv0WIzrAyH1HTEMvAng/BslyKeifMcpLmZJ8uS5hlI066D0OUnshuIH1naeOrYQUsOoOlPoCIvY3w3ZxItrKnDtRJznLZy0rWg4ecKclBqHLRgVYICFR8aTlt9E6itdj/39Wvzt89iOkUBa2Q1HJUrY3ESNU8fH9uCBPX5jOonVh12a8/UyDmDXax1UR4ILI17g7X5xwboaFHQjMUUO3/NksV9mm3w+kmsrJdedbenShnkNwxQAnLGUJ5O3vFk7QZ5ITJIi1gcyEi3hqEVe7osJJmSqOzMh1z+EU3wzxltDWZt52ZbiG/A2vLE2nqh/RmPQ+gOecMtU90Pad/sPdHJhaaQdOg9eVfJYi2a+6Ca4Ht1xveoiOK4Xsy9j50Bw7KkT11/GBD0Y3zuSf6eIXK72SD/VligYGYpUOkxa5aZ+t2iQLwdzsSOmhtH26ppyOnqr8V77jHTbtjNlIuc2pdf6e11MC13ePj7I1NP4jtgd8OkPCOCoteuMeBHRIKjofE9xvsO4pj1NCZdnaxFUZEFJFXnq00mSDdeWQ5wtPuRwr40htx7lXXI1WmNugEJMQOrtZnDI5kMxrwb6nE5+5Gf0tQp+tLLMvxd2zT0tX9ikIsh5L3D54WWhlnBFzQRgJ/OJNY8i2njTEUzV8HFEQWDLqC4Bi5EqJbIx1DXQKannYhoYZZ4dkhQXhEklCCXCS1WumJVskHd8p06E/d4osMiwPMJlll8PVqbpEFkXQsQr4pibRbnXcCDiG1IYTyg2XEsm0d4x7SYW93D5xIDAvmekOaQvrOpHztTQ6neO7/CgoGK
 KKozKS2n
 a0ZlGayAJS1YsEut/YElEmep1oRNwvdn6JOtQk4YLaqIvFYaqMK7Ch0C4SWUQKGxgOQYJKADHeH+SbhuHIIyVn2toniA7T30X4+knXNMDSHPt9KpN9HLB/82tBejcrd6pPsae
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lockdep provides APIs for assertion only if lockdep is enabled at the
moment asserting to avoid unnecessary confusion, using the following
condition, debug_locks && !this_cpu_read(lockdep_recursion).

However, lockdep_{off,on}() are also used for disabling and enabling
lockdep for a simular purpose.  Add !lockdep_recursing(current) that is
updated by lockdep_{off,on}() to the condition so that the assertions
are aware of !__lockdep_enabled if lockdep_off()'ed.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/lockdep.h  |  3 ++-
 kernel/locking/lockdep.c | 10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index ef03d8808c10..c83fe95199db 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -303,6 +303,7 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 	lockdep_assert_once(!current->lockdep_depth)
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
+extern bool lockdep_recursing_current(void);
 
 #define lockdep_pin_lock(l)	lock_pin_lock(&(l)->dep_map)
 #define lockdep_repin_lock(l,c)	lock_repin_lock(&(l)->dep_map, (c))
@@ -630,7 +631,7 @@ DECLARE_PER_CPU(int, hardirqs_enabled);
 DECLARE_PER_CPU(int, hardirq_context);
 DECLARE_PER_CPU(unsigned int, lockdep_recursion);
 
-#define __lockdep_enabled	(debug_locks && !this_cpu_read(lockdep_recursion))
+#define __lockdep_enabled	(debug_locks && !this_cpu_read(lockdep_recursion) && !lockdep_recursing_current())
 
 #define lockdep_assert_irqs_enabled()					\
 do {									\
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index dc97f2753ef8..39b9e3e27c0b 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6900,3 +6900,13 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	warn_rcu_exit(rcu);
 }
 EXPORT_SYMBOL_GPL(lockdep_rcu_suspicious);
+
+/*
+ * For avoiding header dependency when using (struct task_struct *)current
+ * and lockdep_recursing() at the same time.
+ */
+noinstr bool lockdep_recursing_current(void)
+{
+	return lockdep_recursing(current);
+}
+EXPORT_SYMBOL_GPL(lockdep_recursing_current);
-- 
2.17.1


