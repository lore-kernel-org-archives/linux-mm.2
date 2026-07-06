Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0996C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70ACC6B00D9; Mon,  6 Jul 2026 02:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2076B00DB; Mon,  6 Jul 2026 02:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B906B00DC; Mon,  6 Jul 2026 02:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29DA06B00D9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94332402B7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:43 +0000 (UTC)
X-FDA: 84957353166.02.A508602
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 97BED20009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=R4/2pM852PDcO3szkWpMNfFRg+W3nM4E1Vu9ZcLRWDk=;
	b=3Bl/OjRsiEgcnW9YfGF+SzKACd87ThuUf4ny5niQL/TRT2QAoJYyJSJPH4PkF0aIsZLiT7
	eNaQ7UmkdlK5RBR5DkRLYqV41ZB5OGnrn6a38xEoAzxRxA47iBonjjlg2zbmwj0YFvEe7Z
	W9fO8mn9smytJcs1w9sKxKAE88s8XpI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318842;
	b=Gz8HZISKBttQHi8uFwhx+eb5RHFEQp0hgmpq6Boe4boLOy/weH1JfVojuj4/SuqYnMW9bw
	rgleJMP3l2n5A2OcJr3ZXMHvEWJocNWoIG8mBMB4xQYHL6aMp9GLAVyBQM0upH0ypAOWLi
	3vVvzULXpnGoBTtIuATM2ecZy3Zm2+M=
X-AuditID: a67dfc5b-c45ff70000001609-1c-6a4b4903b9ee
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
Subject: [PATCH v19 24/40] locking/lockdep: prevent various lockdep assertions when lockdep_off()'ed
Date: Mon,  6 Jul 2026 15:19:12 +0900
Message-Id: <20260706061928.66713-25-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxTG97/3f1/a0ezasXHVD5gmqCPBuUXnyeIW4mK4ypaZ+fJhGKXa
	m7UIhbSKssWsIJ0VRREHBOqQF9M05UVsgwixruLAF0LoVkzaorYQrJAGMR3FICC2GL+c/PI8
	z3mSkxyWlPupVaxGe1TUaZW5ClqKpVMJjWl4R2bOxif1EjAZf4fHgXEKojMmDIvmLgZM9loK
	3O0tCIzdSzGtsp+BmbkRBrzuv0n4v+MNDeG7EQRVo+M01EwWY5i2nEMw2ZcB467TCBarj0C4
	+iUN84NDJNRUuRFEJoMInNYSGp5VdJIwHJ2m4UHVWRqm/r1MQMjvJOBU8zUauoM9DAQsIQwD
	FU1ErJyG6utJYK45RcTGBAEWQwqYBz0UjFnrGFhqyIf+lucMhEOVNATu/UFBlyHIgN3Xh2Bm
	eJQAU08UQ239YxpuOR9gMC3OIPD0XKbhaesSBQbzq9ilrgEKrj33EjDQfx/DyOAFBoZ62igY
	DXopaHvRRMOlFyEElug0A/+5GggovtOM01XCK+N5LNgcNwihtb4VCfOvK5FQ6jgudNc9YYTS
	235GaLAfE0r/maIEhzVVaL41SQiNkSgl+MPfCHbbGVqwRyoZoXF+gtyV9rN0q0rM1RSKus+/
	zZaqWxZ8VIFvxYnZJj9hQJaPyhDL8twm3mpMK0OSZTT1ldBxprl1vNc7R8Y5kVvDO8pDVBmS
	siTnSebPWcpx3PiYU/H9vrblEOZS+PmrD4k4y7iv+JGSKeZdaTLf0uFazkhievvCX8sZObeZ
	H5m+h+OlPHdFwrsfTlDvFlbyd6xeXIFkDegDG5JrtIV5Sk3upg3qIq3mxIbD+Xl2FPs4y8mF
	rJso4t7dizgWKRJkkL4zR04pC/VFeb2IZ0lFomzt+swcuUylLPpV1OUf1B3LFfW9aDWLFUmy
	L2ePq+TcL8qj4hFRLBB1712ClawyoE8+JMs3SrYmlvHnbb72/TvrMjLO3k3forYbO3+4en9P
	QcC+8tNocM7c2/fbvpdWjw0l/bRDr87UF6eMov2pr5+6kuUGx9o3n9VvUw9v/86pm7Nk30hy
	/nlo9sxFx0nl3vRw1oGusUfur4kmz3jtUPDH9houCxd2XNFWfJ9ABCRjCqxXK79IJXV65VvG
	SGIPbQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSWUwTcRDG/f93u12q1bWCrvoAaeIRE6gmaibxwhjDCtHok9eDNrKRcqcV
	EBW1xWpVUGzSEqkoVGm0oCDFA0ljUwIiXtSqgFCRpBa5xChHoEUsGF8m38z3my/zMDQheSpY
	QitSj/HKVHmylBKRol0bciPRjrjE1bqeMNBpz0Bnl1cAn9QOEkaGdSTcqKygYNL0RAi66usC
	aGrVkNDyoBxB14gOwZjfRIC2doqESX2jEIbHO4RgUCOYsjciMLr0BLS1PCegokaN4XfVHwr6
	638hMHR7KSjsVZMwZMlDUOQzCaG3IQYGu+oEMOXpwdA6OoDA4v2Dweu4gGDSmAS3zLbguvEn
	Bf437wgoNLQgKO32EPCr9yuCmsYvCOx3NRR8K3hEgNs7Fz6MDFHw0nCZgkHXDQw/qigo0dgF
	4Hrdj6DYpEfg+2zHkHu7kgJjcTUJtV+fCcHVH8DQadRjKK/eCV0WHwmvCsw4eG6QergITIW5
	OFi+YzDcr8MwbrEKo8sQN6a9QnJW22PMad9PUlzFzQrE+Sf0iBsuyyU4bUGwrR8YIrhztiyu
	7NUAxU2MfKQ4+2gJyTWbWe7OxQnMXXsTydUWeYS7tx4QbYznkxWZvFK2+bAooTzQLkhvn398
	1PwZn0WWeZdQCM0ya1ldg4aa1hSzgm1rGyemdSgTwdryfYJLSEQTjDuczbPkk9PGAiaebWy/
	PwORzDLWf6cZT2sxs57t0AwK/4WGs+VVjhkmJDh/ECieYSTMOrZj6AVZgEQlaJYVhSpSM1Pk
	iuR1UaqkhOxUxfGoI2kp1Sj4T5acwLWnaNgd40QMjaRzxBAdmygRyDNV2SlOxNKENFS8fGVc
	okQcL88+wSvTDikzknmVEy2lSekicexe/rCEOSo/xifxfDqv/O9iOmTJWZR/MnDryLy+0zhs
	ftJYSd76TVZ8hc36Ltvc0Fm6Xfuxx20mbFnnn2yL89S6dy683uw692xLd2xlmG9FpPOUsWjr
	qNP6yL+nN73uXloP3fdT2SSbnXOw+NPiWQRTE1DLbE2uiGUx+xXRUB8+eDqq9KrN0WSPWDzm
	cQT2ybQZbwkpqUqQr1lFKFXyv5jOPbtLAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97BED20009
X-Stat-Signature: dunzr3s4fta6a3c9swd93sky9ogc3srk
X-HE-Tag: 1783318841-102655
X-HE-Meta: U2FsdGVkX1/mWejN6hwbB+0ZdkodiXsbkWJHyfKCJA9a7Kh/DZAVDcQ3nanpmabLvCSDdoM5A7o8Bdu9dGN2bi9/y0iGoiuPcMrLbBXwLl0dFnQnNQeOBVQbumDoWrrT4wsbEtprr4M3rEt2yrQ4nGqJdkRklRcZxAWPlOnkjKmyIvlqihptA8O21vYW6h/O5Vm/5OefrcK+H+NvhqRt2N7nHvgtJo8o3eeQifMOg11UOoIY+hEXaDPbgIqkTsKF7ZLnBsq3d5mstD316SYcNjmhtnv7pnUWXm4luZFjlXR54L0OOXHQiZEfLdW+Ap89NKMK9x5ShmmnOo2V8iPg3OohAyym0g79AVSoXHe3Abjla5asB9h8CnRetEUDwhByGJnWoa0wPrK/bWeie87IBHasumtQxh1q64xEj4pp4DgwPFUXRr3KO/svPkRTsOg4lisli/tPoozfRUFQNWNt2Ll1EysASY7DVKdXclFuhhYhHT2gQwNYa8gm5wS3Jd0vLpySqz4wCgQaSlDvVl5ZK21WI6z6Ue4nqDrT8NmkxyguUPBvtxgaQYsR2eoZoBebVjolK8PYkuz9bJUl7mfd5hvCfwgm1EtrUZNgZsvKqLDknXHGNDx7OX615PqDCY/OwFkavsfbQdlIuSziH5u/0PFAwildCuvxZFyCADvY2EmEQnDfluX8ULgZsgnZrzkTXl/r+RdUL0ocQ1UEg2VNcEdjLGsoRvVHw13LeLEux+P/ggv/KT+2HYZbr+U+KqBMTII4o0iYdQG0YzEOxhyK1I/Gd+XOT8trq9UYpodWzYnEXbDHrD+oFjI4tOPXv3dWZt7xcY5vJVbwMIrK8fKz8xCJhSPLwAXjbSEBXSuMlU32Iz8w0stbdzKsT8WD9qn88HnKgbybK3mI5HujPdCIrMPx3SG0y/1GJzFraHUbU4Ty7sGX89TbIZ0XeJkGPxTtCMCPb1lY9RaLxk2qEDn
 pMZUpUCO
 Psu//+AU5jxv99HTmZRwccjIIdWq99lht/t3ErA/KiiZr2VPF1oOV9WqOgNiXNzk/t2coPfr6SGsPd26vGKqMNHl0cRpOuZpFd4GQ0z9oOH9OQl3RBH1ljxWiASWrShEl+OgtO3I7GQfkCHtcKhCE4HNsAeocTGXyDe4AKGvEpsAu514fABAT07ODvfcfaVUof917+AUV1BFGTlPDPLtgETcxAA==
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
index 60b17a2ff555..5113b7053b62 100644
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


