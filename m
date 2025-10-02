Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A06CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54FB08E0011; Thu,  2 Oct 2025 04:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B0C8E0008; Thu,  2 Oct 2025 04:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291358E0011; Thu,  2 Oct 2025 04:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 137B08E0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D28B98678B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:18 +0000 (UTC)
X-FDA: 83952459276.11.CC65C29
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4C1BA000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=fx1g1cAqOgQ4qwDeiSPCW2gwnXZTk07VyirdTBPPKdg=;
	b=Bbf19XdwcVXaku+HFAqSb2E4YnJBoy4uvKVIWK8l14kV02Ps3t50fo2654GMD7KLclWmDR
	enwzjQxuQ5/TAz/ZwVBpstCQLQAFdt+gpGIHM+QGS8Sgxw/NEgeRHDns1l2WTIBff2brvs
	CLjc1ycH+A7qfOD6i1LtmRAY8U7PIa8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392797; a=rsa-sha256;
	cv=none;
	b=NmYRGsNwofV1nNMeu7AMWHLgLGmdsHJJE2UqmjrEqfez3JS1MPMkMJih8rVnbIaRcPCcIS
	me3WFy/uC/7pFkx6RBOR343LnpFYOdA4vxVOJnCt9O7Zllmc6RkEI3ymU8IpU1jhqr+qtG
	YIjPLyZibig4Z9G7FYFRnAzyulOS9gY=
X-AuditID: a67dfc5b-c45ff70000001609-bc-68de340bd265
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
Subject: [PATCH v17 05/47] dept: tie to lockdep and IRQ tracing
Date: Thu,  2 Oct 2025 17:12:05 +0900
Message-Id: <20251002081247.51255-6-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTYRTHe977hoOXJfl6gWwhgZRZWJwPlX58qi92gaCQesuXttJp8951
	y0uZmaloXiqdVui00A1LsWBqqbnMaSKWZRfv6IpME11mW9G3H//zO+f/5XCkMov24TTaeEmn
	FaNUjJySOzyMmzxChtXBK995GDBYKbhqLqbh4/xVBAvOUhLSm1YoWM5rZ2FucYiFgs+jDIxa
	ryAoq7Aw4OzuIeFWgR3Bs6rLDDh6bxPwtY4B280KAgrrvaDgYTMBD/QBsFIeA48cPTRMj+cx
	8ET/iQXzyAANxox7FDx99tJVvDyHYLh2hYa+GjsFlu5XJNhzs2nI/zqOoL18DXRkWwm4MtnM
	QHfpaxr63zYjmCi5Q0Db/AwBXUtdBHy54WBh9s5vGmp6KchKL6Sg4cUCC4YfHxHM1ZgYKH0x
	zIYFY5PlMYFr79Yi7FzKQ/i+bYbBTSUfWJz23EFjS1Ugrnw6RWDj7DyN303vxGZTJoPNs3ks
	NjonSdxZ5KSwUV9A4rsv94X7HZbviJSiNImSbvOuY3J1RtoQG9t3Ljm/uJ/Vo+rj15CME/gQ
	Ide5RPzniRI97WaG3yAMDi6Sbvbk/QVL9vjfnORtfsJA70Y3r+ZDhbKGCpfDcRQfIPTP+bpj
	Bb9NsE0skP9OrhVq6qx/WcZvF958tlFuVrqc9G9prlq5yymVCRVFPcy/BW+hpWqQuokU5WiV
	CSk12sRoURMVEqRO0WqSg07ERJuR60UeXPh1pBHN2g+0Ip5DKg+FPeCDWkmLiXEp0a1I4EiV
	p+JY1Xu1UhEpppyVdDFHdQlRUlwr8uUolZdi68+kSCV/UoyXTktSrKT7PyU4mY8erT+Vu5ls
	fOy1/1ByprIFP6+faZzgjv+qC04djvDO6ngfqq3u9VvsCww+02nJ9Pdpu9zRVPmJm8rBZUOF
	hlT/vRcN4mjy4IV+WezFg1O7u4s0qeFHxdweydS6Nyc0LCU/88xIV90lWEbnC39mBUTQOWPF
	Y9eT9iT4rYtgPT2shIqKU4tbAkldnPgH2MTxLh4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH/d23q9VlCV4qqBbS016kHCuqf6JLkD3+MOqfXHVrY05rK8tK
	cm0r6TlXU3JZtmr4ymxmaGGYQ8mm1Jq9zGU+ckqaVFu+s7uifw6f8/1+OZwDh8FlFeR0RpV8
	WNAmK5LklISQxK82RE9a+Um5rPdLNLzV1xAQDGQScP1+CQWZzmskvCotRtAWzEQwOGrDwVQ1
	QcC4pZ6GwPBHGiaq6xFkeyw4lDzUY/Cz7DcFX10/EFjbuyjI6dUTMOC4gCC320ZDb91G6G97
	QsKEz4/Bu199CBxdvzHoqjmLYDxbDTft5RSMNr3EIcf6CsGtdh8OPWWi+bD+E4LqgtMUfDFX
	4ODtmgLNwQEKGqznKej3XMfgWxkF+aerScizWRAYbt+nIDvPSUDV58c0eL6OYdCabcGg2LkZ
	2hzdBLjNdkzcT0w9iARbjgETSw8G1ntPMBh2FNHQeLuVAEdGFNiavCR0FOTSMNa+HCbyU6C+
	2E+D77KVgNL+l+R6K+IHTZcIvqj8EcabXo9TfMmNEsSPjlgQH7hrwHmTWWxdfQM4byw/yt91
	91H8SPANxVf/yif4F3aOz2qK5qtyfTRvfNpCb121S7Jmn5CkShW0S9cmSpRnjB/pg69PHLty
	rZnOQIV7zqFwhmNXcv7cDDLEFDuPe/9+GA9xBDubK7/Y/VfHWfdM7q1ncYinseu4mxV2McMw
	BBvFNQdmhGQpG8O5/YP4v5GzuOKymr8czsZy3nY3EWKZmDENGDEzkuSjsCIUoUpO1ShUSTFL
	dGplWrLq2JK9KRonEp/JkT6WVYkC3o21iGWQfLLUE+VTykhFqi5NU4s4BpdHSBMLWpUy6T5F
	2nFBm7JbeyRJ0NWiGQwhj5Ru2iEkytgDisOCWhAOCtr/LsaETxfvrrSvR4NU59wppft7r2z+
	2Te0qMOeZcAebKtr3HNHvX/L98a1CRs6w4JH44xxV4+4FvonbQ/T7ISrWnXkmm+n9KNkQrR5
	fnpDz5Bi7xxvx4Kzxvm6NtdUZ0LhybyimBXxLTHTCg99iNOkutSVn5/HbolPD460RD2r5bRD
	+vgFqjA5oVMqli/EtTrFH0yyWjdIAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 5jhrqqeg5s1pyqjrxnhbi5ez389mrmej
X-Rspam-User: 
X-Rspamd-Queue-Id: C4C1BA000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392796-524840
X-HE-Meta: U2FsdGVkX19TrAyhTu11S//9C/iotCFaUKKhzM+YFj/L+9qrmfU/K8FMxDGXxOaImrCX4GpNcsiamTJOKu0e/gjzb1zTw2od6Ddgbez3WspnsRFbnOA8za5FDVwaq+ASlREbCmVQe9TrBRXyNxlKuELReLOASnfxADCVA4WpOIIwWA3fhU8XSfpbqUjJnx9ULSML92E4ihZ9HzXxkBWVg4jRcu1lzEdwMoPzPfMrMjc5nLxfrCOGMf0p5flAvzyAiYQ5WkipJRaeR/5Mw+ppYAZPF/JdMmTlyJk+/eXpsyR5hQECwiuyAcXZz0BE2OvM6kd9kCS1546mwKnziO+HmlBcPOYCggk5EO/OwRcB8GYt1L6UOuTNSR9VXUd5x9OBPTlsKbmF5JhSGhBsRFT6LNlkPwQYWGS0s8GBn5Gc+osLX8cl4jL3204B88/4tfbsxr7rZVSRoJ+XwJBImbJgw9SxZBOHygZEA3JC82KNzcpo6QAFlZB7OVZpbonuk7nd6B3Jq/opLvSUwXwPE6fwe3fOekuc7UEm9HEsGVQmZ7e4z0THTAwLOTxTcphczicYGfldsy9ufVYQT2MMvaXWhRXMYZjr/iYQ3GRZtTidiSB2rb1mWRT79ppyeF8ZxWgm/9p4L0ChAy7lIyXNpKGYZapnNdW8L1cXWTFqRnVVh6IlVuf/P3JRRkrDNcMh1yY6e6jSp/XN7KO6DkStLO40q5HTdIj0vDZgi+Ijnlm1CwjpbIrFiQDp3VahrJLsBVrUmGiq5C4sl9ZLYBH0bHLuMne7GjRSuXU4uNOchsNrVU7j7owDTc+ojRgAMRELw6wumzANeVT6CGNwf08qVgAQmVdkZF04m162H2EJqruFiiy/isg6aBbpAbmU+z1INPxQxUAenokFrDgFAR3DvucH7e47urfaRBnmy6BD7L+FRB6F0V+g8AZK4aGjmr4rD+l9JR881Ij/PXp+CWz4mMB
 bpG/2XdS
 baQ6BO8p3BjvBOCyl4KA7M35WQE+CMZy3kVoC8bn4wpoLdz4goVhVqhD0TjptrRVZiPErgEKOO+c5erxaZufNNJmoKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

How to place dept this way looks so ugly.  However, it's inevitable for
now.  The way should be enhanced gradually.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/irqflags.h            |   7 +-
 include/linux/local_lock_internal.h |   1 +
 include/linux/lockdep.h             | 102 ++++++++++++++++++++++------
 include/linux/lockdep_types.h       |   3 +
 include/linux/mutex.h               |   1 +
 include/linux/percpu-rwsem.h        |   2 +-
 include/linux/rtmutex.h             |   1 +
 include/linux/rwlock_types.h        |   1 +
 include/linux/rwsem.h               |   1 +
 include/linux/seqlock.h             |   2 +-
 include/linux/spinlock_types_raw.h  |   3 +
 include/linux/srcu.h                |   2 +-
 kernel/dependency/dept.c            |   8 +--
 kernel/locking/lockdep.c            |  22 ++++++
 14 files changed, 127 insertions(+), 29 deletions(-)

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 57b074e0cfbb..d8b9cf093f83 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -15,6 +15,7 @@
 #include <linux/irqflags_types.h>
 #include <linux/typecheck.h>
 #include <linux/cleanup.h>
+#include <linux/dept.h>
 #include <asm/irqflags.h>
 #include <asm/percpu.h>
 
@@ -55,8 +56,10 @@ extern void trace_hardirqs_off(void);
 # define lockdep_softirqs_enabled(p)	((p)->softirqs_enabled)
 # define lockdep_hardirq_enter()			\
 do {							\
-	if (__this_cpu_inc_return(hardirq_context) == 1)\
+	if (__this_cpu_inc_return(hardirq_context) == 1) { \
 		current->hardirq_threaded = 0;		\
+		dept_hardirq_enter();			\
+	}						\
 } while (0)
 # define lockdep_hardirq_threaded()		\
 do {						\
@@ -131,6 +134,8 @@ do {						\
 # define lockdep_softirq_enter()		\
 do {						\
 	current->softirq_context++;		\
+	if (current->softirq_context == 1)	\
+		dept_softirq_enter();		\
 } while (0)
 # define lockdep_softirq_exit()			\
 do {						\
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index d80b5306a2c0..3b74da2fec50 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -27,6 +27,7 @@ typedef struct {
 		.name = #lockname,			\
 		.wait_type_inner = LD_WAIT_CONFIG,	\
 		.lock_type = LD_LOCK_PERCPU,		\
+		.dmap = DEPT_MAP_INITIALIZER(lockname, NULL),\
 	},						\
 	.owner = NULL,
 
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 67964dc4db95..ef03d8808c10 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -12,6 +12,7 @@
 
 #include <linux/lockdep_types.h>
 #include <linux/smp.h>
+#include <linux/dept_ldt.h>
 #include <asm/percpu.h>
 
 struct task_struct;
@@ -39,6 +40,8 @@ static inline void lockdep_copy_map(struct lockdep_map *to,
 	 */
 	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
 		to->class_cache[i] = NULL;
+
+	dept_map_copy(&to->dmap, &from->dmap);
 }
 
 /*
@@ -428,7 +431,8 @@ enum xhlock_context_t {
  * Note that _name must not be NULL.
  */
 #define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
-	{ .name = (_name), .key = (void *)(_key), }
+	{ .name = (_name), .key = (void *)(_key), \
+	  .dmap = DEPT_MAP_INITIALIZER(_name, _key) }
 
 static inline void lockdep_invariant_state(bool force) {}
 static inline void lockdep_free_task(struct task_struct *task) {}
@@ -510,33 +514,89 @@ extern bool read_lock_is_recursive(void);
 #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
 #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
 
-#define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
-#define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
-#define spin_release(l, i)			lock_release(l, i)
-
-#define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define spin_acquire(l, s, t, i)					\
+do {									\
+	ldt_lock(&(l)->dmap, s, t, NULL, i);				\
+	lock_acquire_exclusive(l, s, t, NULL, i);			\
+} while (0)
+#define spin_acquire_nest(l, s, t, n, i)				\
+do {									\
+	ldt_lock(&(l)->dmap, s, t, n, i);				\
+	lock_acquire_exclusive(l, s, t, n, i);				\
+} while (0)
+#define spin_release(l, i)						\
+do {									\
+	ldt_unlock(&(l)->dmap, i);					\
+	lock_release(l, i);						\
+} while (0)
+#define rwlock_acquire(l, s, t, i)					\
+do {									\
+	ldt_wlock(&(l)->dmap, s, t, NULL, i);				\
+	lock_acquire_exclusive(l, s, t, NULL, i);			\
+} while (0)
 #define rwlock_acquire_read(l, s, t, i)					\
 do {									\
+	ldt_rlock(&(l)->dmap, s, t, NULL, i, !read_lock_is_recursive());\
 	if (read_lock_is_recursive())					\
 		lock_acquire_shared_recursive(l, s, t, NULL, i);	\
 	else								\
 		lock_acquire_shared(l, s, t, NULL, i);			\
 } while (0)
-
-#define rwlock_release(l, i)			lock_release(l, i)
-
-#define seqcount_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
-#define seqcount_acquire_read(l, s, t, i)	lock_acquire_shared_recursive(l, s, t, NULL, i)
-#define seqcount_release(l, i)			lock_release(l, i)
-
-#define mutex_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
-#define mutex_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
-#define mutex_release(l, i)			lock_release(l, i)
-
-#define rwsem_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
-#define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
-#define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared(l, s, t, NULL, i)
-#define rwsem_release(l, i)			lock_release(l, i)
+#define rwlock_release(l, i)						\
+do {									\
+	ldt_unlock(&(l)->dmap, i);					\
+	lock_release(l, i);						\
+} while (0)
+#define seqcount_acquire(l, s, t, i)					\
+do {									\
+	ldt_wlock(&(l)->dmap, s, t, NULL, i);				\
+	lock_acquire_exclusive(l, s, t, NULL, i);			\
+} while (0)
+#define seqcount_acquire_read(l, s, t, i)				\
+do {									\
+	ldt_rlock(&(l)->dmap, s, t, NULL, i, false);			\
+	lock_acquire_shared_recursive(l, s, t, NULL, i);		\
+} while (0)
+#define seqcount_release(l, i)						\
+do {									\
+	ldt_unlock(&(l)->dmap, i);					\
+	lock_release(l, i);						\
+} while (0)
+#define mutex_acquire(l, s, t, i)					\
+do {									\
+	ldt_lock(&(l)->dmap, s, t, NULL, i);				\
+	lock_acquire_exclusive(l, s, t, NULL, i);			\
+} while (0)
+#define mutex_acquire_nest(l, s, t, n, i)				\
+do {									\
+	ldt_lock(&(l)->dmap, s, t, n, i);				\
+	lock_acquire_exclusive(l, s, t, n, i);				\
+} while (0)
+#define mutex_release(l, i)						\
+do {									\
+	ldt_unlock(&(l)->dmap, i);					\
+	lock_release(l, i);						\
+} while (0)
+#define rwsem_acquire(l, s, t, i)					\
+do {									\
+	ldt_lock(&(l)->dmap, s, t, NULL, i);				\
+	lock_acquire_exclusive(l, s, t, NULL, i);			\
+} while (0)
+#define rwsem_acquire_nest(l, s, t, n, i)				\
+do {									\
+	ldt_lock(&(l)->dmap, s, t, n, i);				\
+	lock_acquire_exclusive(l, s, t, n, i);				\
+} while (0)
+#define rwsem_acquire_read(l, s, t, i)					\
+do {									\
+	ldt_lock(&(l)->dmap, s, t, NULL, i);				\
+	lock_acquire_shared(l, s, t, NULL, i);				\
+} while (0)
+#define rwsem_release(l, i)						\
+do {									\
+	ldt_unlock(&(l)->dmap, i);					\
+	lock_release(l, i);						\
+} while (0)
 
 #define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
 #define lock_map_acquire_try(l)			lock_acquire_exclusive(l, 0, 1, NULL, _THIS_IP_)
diff --git a/include/linux/lockdep_types.h b/include/linux/lockdep_types.h
index eae115a26488..0c3389ed26b6 100644
--- a/include/linux/lockdep_types.h
+++ b/include/linux/lockdep_types.h
@@ -11,6 +11,7 @@
 #define __LINUX_LOCKDEP_TYPES_H
 
 #include <linux/types.h>
+#include <linux/dept.h>
 
 #define MAX_LOCKDEP_SUBCLASSES		8UL
 
@@ -77,6 +78,7 @@ struct lock_class_key {
 		struct hlist_node		hash_entry;
 		struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 	};
+	struct dept_key				dkey;
 };
 
 extern struct lock_class_key __lockdep_no_validate__;
@@ -195,6 +197,7 @@ struct lockdep_map {
 	int				cpu;
 	unsigned long			ip;
 #endif
+	struct dept_map			dmap;
 };
 
 struct pin_cookie { unsigned int val; };
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 847b81ca6436..f8d7f02be04d 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -29,6 +29,7 @@ struct device;
 		, .dep_map = {					\
 			.name = #lockname,			\
 			.wait_type_inner = LD_WAIT_SLEEP,	\
+			.dmap = DEPT_MAP_INITIALIZER(lockname, NULL),\
 		}
 #else
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)
diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index 288f5235649a..11eece738f1f 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -22,7 +22,7 @@ struct percpu_rw_semaphore {
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define __PERCPU_RWSEM_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname },
+#define __PERCPU_RWSEM_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname, .dmap = DEPT_MAP_INITIALIZER(lockname, NULL) },
 #else
 #define __PERCPU_RWSEM_DEP_MAP_INIT(lockname)
 #endif
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index fa9f1021541e..4dc7f046b0a6 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -81,6 +81,7 @@ do { \
 	.dep_map = {					\
 		.name = #mutexname,			\
 		.wait_type_inner = LD_WAIT_SLEEP,	\
+		.dmap = DEPT_MAP_INITIALIZER(mutexname, NULL),\
 	}
 #else
 #define __DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)
diff --git a/include/linux/rwlock_types.h b/include/linux/rwlock_types.h
index 1948442e7750..6e58dfc84997 100644
--- a/include/linux/rwlock_types.h
+++ b/include/linux/rwlock_types.h
@@ -10,6 +10,7 @@
 	.dep_map = {							\
 		.name = #lockname,					\
 		.wait_type_inner = LD_WAIT_CONFIG,			\
+		.dmap = DEPT_MAP_INITIALIZER(lockname, NULL),		\
 	}
 #else
 # define RW_DEP_MAP_INIT(lockname)
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index f1aaf676a874..0f349c83a7dc 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -22,6 +22,7 @@
 	.dep_map = {					\
 		.name = #lockname,			\
 		.wait_type_inner = LD_WAIT_SLEEP,	\
+		.dmap = DEPT_MAP_INITIALIZER(lockname, NULL),\
 	},
 #else
 # define __RWSEM_DEP_MAP_INIT(lockname)
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 5ce48eab7a2a..5f3447449fe0 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -51,7 +51,7 @@ static inline void __seqcount_init(seqcount_t *s, const char *name,
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 # define SEQCOUNT_DEP_MAP_INIT(lockname)				\
-		.dep_map = { .name = #lockname }
+		.dep_map = { .name = #lockname, .dmap = DEPT_MAP_INITIALIZER(lockname, NULL) }
 
 /**
  * seqcount_init() - runtime initializer for seqcount_t
diff --git a/include/linux/spinlock_types_raw.h b/include/linux/spinlock_types_raw.h
index 91cb36b65a17..3dcc551ded25 100644
--- a/include/linux/spinlock_types_raw.h
+++ b/include/linux/spinlock_types_raw.h
@@ -31,11 +31,13 @@ typedef struct raw_spinlock {
 	.dep_map = {					\
 		.name = #lockname,			\
 		.wait_type_inner = LD_WAIT_SPIN,	\
+		.dmap = DEPT_MAP_INITIALIZER(lockname, NULL),\
 	}
 # define SPIN_DEP_MAP_INIT(lockname)			\
 	.dep_map = {					\
 		.name = #lockname,			\
 		.wait_type_inner = LD_WAIT_CONFIG,	\
+		.dmap = DEPT_MAP_INITIALIZER(lockname, NULL),\
 	}
 
 # define LOCAL_SPIN_DEP_MAP_INIT(lockname)		\
@@ -43,6 +45,7 @@ typedef struct raw_spinlock {
 		.name = #lockname,			\
 		.wait_type_inner = LD_WAIT_CONFIG,	\
 		.lock_type = LD_LOCK_PERCPU,		\
+		.dmap = DEPT_MAP_INITIALIZER(lockname, NULL),\
 	}
 #else
 # define RAW_SPIN_DEP_MAP_INIT(lockname)
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index f179700fecaf..f1961554ed1a 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -35,7 +35,7 @@ int __init_srcu_struct(struct srcu_struct *ssp, const char *name,
 	__init_srcu_struct((ssp), #ssp, &__srcu_key); \
 })
 
-#define __SRCU_DEP_MAP_INIT(srcu_name)	.dep_map = { .name = #srcu_name },
+#define __SRCU_DEP_MAP_INIT(srcu_name)	.dep_map = { .name = #srcu_name, .dmap = DEPT_MAP_INITIALIZER(srcu_name, NULL) },
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 int init_srcu_struct(struct srcu_struct *ssp);
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 712b7f79a095..cbb036e8cc1d 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -249,10 +249,10 @@ static bool dept_working(void)
  * Even k == NULL is considered as a valid key because it would use
  * &->map_key as the key in that case.
  */
-struct dept_key __dept_no_validate__;
+extern struct lock_class_key __lockdep_no_validate__;
 static bool valid_key(struct dept_key *k)
 {
-	return &__dept_no_validate__ != k;
+	return &__lockdep_no_validate__.dkey != k;
 }
 
 /*
@@ -1946,7 +1946,7 @@ void dept_softirqs_off(void)
 	dept_task()->softirqs_enabled = false;
 }
 
-void dept_hardirqs_off(void)
+void noinstr dept_hardirqs_off(void)
 {
 	/*
 	 * Assumes that it's called with IRQ disabled so that accessing
@@ -1968,7 +1968,7 @@ void dept_softirq_enter(void)
 /*
  * Ensure it's the outmost hardirq context.
  */
-void dept_hardirq_enter(void)
+void noinstr dept_hardirq_enter(void)
 {
 	struct dept_task *dt = dept_task();
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 2d4c5bab5af8..dc97f2753ef8 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1224,6 +1224,8 @@ void lockdep_register_key(struct lock_class_key *key)
 	struct lock_class_key *k;
 	unsigned long flags;
 
+	dept_key_init(&key->dkey);
+
 	if (WARN_ON_ONCE(static_obj(key)))
 		return;
 	hash_head = keyhashentry(key);
@@ -4361,6 +4363,8 @@ static void __trace_hardirqs_on_caller(void)
  */
 void lockdep_hardirqs_on_prepare(void)
 {
+	dept_hardirqs_on();
+
 	if (unlikely(!debug_locks))
 		return;
 
@@ -4481,6 +4485,8 @@ EXPORT_SYMBOL_GPL(lockdep_hardirqs_on);
  */
 void noinstr lockdep_hardirqs_off(unsigned long ip)
 {
+	dept_hardirqs_off();
+
 	if (unlikely(!debug_locks))
 		return;
 
@@ -4525,6 +4531,8 @@ void lockdep_softirqs_on(unsigned long ip)
 {
 	struct irqtrace_events *trace = &current->irqtrace;
 
+	dept_softirqs_on_ip(ip);
+
 	if (unlikely(!lockdep_enabled()))
 		return;
 
@@ -4563,6 +4571,8 @@ void lockdep_softirqs_on(unsigned long ip)
  */
 void lockdep_softirqs_off(unsigned long ip)
 {
+	dept_softirqs_off();
+
 	if (unlikely(!lockdep_enabled()))
 		return;
 
@@ -4940,6 +4950,8 @@ void lockdep_init_map_type(struct lockdep_map *lock, const char *name,
 {
 	int i;
 
+	ldt_init(&lock->dmap, &key->dkey, subclass, name);
+
 	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
 		lock->class_cache[i] = NULL;
 
@@ -5736,6 +5748,12 @@ void lock_set_class(struct lockdep_map *lock, const char *name,
 {
 	unsigned long flags;
 
+	/*
+	 * dept_map_(re)init() might be called twice redundantly. But
+	 * there's no choice as long as Dept relies on Lockdep.
+	 */
+	ldt_set_class(&lock->dmap, name, &key->dkey, subclass, ip);
+
 	if (unlikely(!lockdep_enabled()))
 		return;
 
@@ -5753,6 +5771,8 @@ void lock_downgrade(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
+	ldt_downgrade(&lock->dmap, ip);
+
 	if (unlikely(!lockdep_enabled()))
 		return;
 
@@ -6588,6 +6608,8 @@ void lockdep_unregister_key(struct lock_class_key *key)
 	bool found = false;
 	bool need_callback = false;
 
+	dept_key_destroy(&key->dkey);
+
 	might_sleep();
 
 	if (WARN_ON_ONCE(static_obj(key)))
-- 
2.17.1


