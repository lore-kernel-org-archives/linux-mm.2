Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F661D2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C78F6B00D8; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B096B00DE; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2A66B00DA; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7C7C6B00D7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:19:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 960CC1604C6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:57 +0000 (UTC)
X-FDA: 84184568034.22.F9FD67C
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf14.hostedemail.com (Postfix) with ESMTP id 827D0100010
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=ebSz83GUgY5e6qUQha4WM0+cVnz648j1W/ZEUSfSrM4=;
	b=cYOh6nKsV4Ibmug7ItquDodsHL3kqcfRv4KrYK7wWrqKcej1niAD/QGhduKkrloudQX2XZ
	NC3gRWqshbsvKkjc5lptX7J+xnhjkAJh9/TgQWhQw4k0NIjp2hCQwobVttrCsq8y6QdBtD
	9OX97AXhmsjAVF7Kpxu1ulWI15qqTxM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919196; a=rsa-sha256;
	cv=none;
	b=O7NI4xWsEiL12PYs2Zcoi2Z/WX048Sa7qOP6sQxuRlEeVYeIjoZg2k00zJ29TZlO2VpKuz
	45ZKaqXsGHTQhqqudxRTOvc5Ib2tg4eDWaoimAAqjzov4Wk8rWm+OHEDtr5/erIgy/0Fue
	dk931+u7pdzm+L9aLCHW2a24b80qn1c=
X-AuditID: a67dfc5b-c45ff70000001609-e6-6932876c974e
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
Subject: [PATCH v18 08/42] dept: add a mechanism to refill the internal memory pools on running out
Date: Fri,  5 Dec 2025 16:18:21 +0900
Message-Id: <20251205071855.72743-9-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxiG957zntNDY82xmni0M5I6s8UpfuuTOA3GH54/JpotLhkzrJET
	ObFFLAKyZVnBDyoiHzUtQgsUmKSWorVVULCu4jQYIYJ1tjqKkmiRWHTD0gaxYkH9d+W5r9y5
	fzwMKX9ILWTErEOCNkulVtJSLB2d1bhCU7xGXGUxyUB/7A8Yj+gxxM3tEtC7qino9hdh6Dvf
	giA2aSbBWIhgynMbganfQILjUiEBb5zvaXh5cwzByK3tMBUcJsAfDSN45i1GEDfth/pGd0Iw
	/UfDZO89EhqGgiR4bEU0+J7NhjvGkzSM9lsIeOWkwVrkoaDWbEAQeuwhYMBkIKDFtQOeNIcw
	3K1oJKBqhAbTxflgbO0koKdpAIO510dBsNyI4c7gQwpehgw0tOueSsD16BaCyIMhAhylIRL0
	HeMYPI+/hYbjf2KorhtIDOiw0FDqvEzBoGOKAp05RsGF4QABd293J+pqzmH4t7dcAvc6Wik4
	6+8nIFqmgL7KUxQ8qgpLwPZ/FZWawceOlWHe7m4jeEedA/GRs0dI/mb4NckfdefznqgV85W9
	K/irNUEJb3Xl8kf/HqV4t20Z33RthOBd9hM07xozSPiGyRfkzuU/Sb/LENRinqBdueUXaWa5
	sQRn96Ue9sYthA5dXFuCkhiOXcf9M2SgPrMpEpVMM81+zQUCE+Q0z2OTOfepUMKRMiTrW8wV
	T5TNBHPZvdzz6zcSzDCYXcp1Btjps4xdz93v7iQ/di7mWpzeGU5iN3BG/9sZliec+pLYTCfH
	NiVxFzr9n0Ys4G7YArgCyazoCzuSi1l5GpWoXpeSWZAlHk7Ze0DjQolva/79XdoVNNb3fRdi
	GaScJfPmrxbllCovp0DThTiGVM6ThdWrRLksQ1Xwq6A9kK7NVQs5XUjBYOV82Zpofoac3ac6
	JOwXhGxB+zklmKSFOlQ5+J77xlua3F59sMHa9sOC8cjKuXq7ZGusNV44J6hrnigq7FGohqvT
	U/fYv5qU/xVfK/c92PKlZo+VCG8r31RwRp1eMyX92fiirn9jyvrTocB5Z0XxcNnukXgdrjW1
	Li1Je6fo2bo5W1Tk7l7im70oLfmVcVPzb7U7bfVtu360tClxTqZq9TJSm6P6AE97hX5pAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+93XrqPVZUldKipGDyh72IsDRdgDugg98B97Ua685XBabaYt
	qHy0XOuhjTaraZnlKDVdm2U2VktLLAtdZtpjmbJMcWXoHqhNm0b/HD7nfL/ny/nj0Li4ipxO
	y5JTeEWyVC6hhIRw65qsxfLs5bJl5tbJoFGfhi/tbhI+ZDgI8Hk1BORXlFEQNFYJQGO5RkJ9
	ayYBTeWlCNp9GgSBYSMO6upRAoK6OgF4Bz8LQJ+BYNReh8Dg1OHQ1vQMh7LKDAwGzCMU9Nb2
	I9B3uCnI68kgoM90AcH1LqMAel5uhp/tNhJGXT8waPV7EJjcIxi4HdkIgoZEuFlkDa0bflMw
	/LYRhzx9E4JbHS4c+nu+Iais+4rAfjeTgu+5D3Fodk+C974+Cl7pz1Pw05mPwS8zBYWZdhKc
	b3oRFBh1CLo+2THIul1BgaHAQkD1tycCcPb+weCLQYdBqWULtJu6CGjILcJC54ZcD6aBMS8L
	C5VuDPT3bRgMmkoEUcWIC6gvEVyJ9RHGqd8FKa7sRhnihod0iPMWZ+GcOjfU1nr6cO6MNY0r
	bvBQ3JCvheLs/kKCe13EcnfODWHc5beLuerrLsH29buEa+N5uSyVVyxdFydMyNFriSNNUccd
	wXwsHT1YoUVhNMusZA1ev2CMKWYB29Y2iI9xODOHtV7sIrVISONM82w2e/DSuDCFOcB+f/o8
	xDRNMPNYWxszNhYxq9h39Tb8X+ZsttTsGOcwZjWrbx0aZ3HIc1MbIHORsBBNKEHhsuTUJKlM
	vmqJMjFBlSw7vuTA4SQLCr2T6eSfy4+Rt3lzDWJoJJkocqRFysSkNFWpSqpBLI1LwkUe+TKZ
	WBQvVZ3gFYf3KY7JeWUNmkETkmmi6Fg+TswckqbwiTx/hFf8VzE6bHo6yomIGUlfn9N5p/Zs
	sHFiwUy+Ytuag05Vt6bv41bb0ch75Tpt4xNUHz1r46k9cwde0OK6Tp/Kc37F7h26DfMz77ZU
	bgr87hQPkF+rApLo7Ji0fpfF5a/ccHXvzgip0RnVEVXQuPOYescJeUxp1aJ15/a1mKemxO2v
	jrf6O6/E/mjolhDKBGnkQlyhlP4FQKgHCUoDAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 827D0100010
X-Rspamd-Server: rspam11
X-Stat-Signature: ieyza57wkio9wr53n3tfn6ohxgk8wyhn
X-HE-Tag: 1764919195-404791
X-HE-Meta: U2FsdGVkX183KC9Uke/lxteBWl2zbp2QLr5SdQU1nMK+9omzwHnkd/tjupI0PB46O/olE6HSJe6A0wXylsMNze29/vMbs1MSu1sXQ1uaGuj+xAtJWrGCSZA5UrfqJVnSVZTCocTeo8eanClkEVZcl+zz+DbUURhCiOVzgbgOM9V/UKciWYKML8F3lfwhnsPUChnSgjRU7fFTrthT5Zu4kLxxrNMQZRI7FNnT814J56Eo9lm0WelBSHr+u4fZTj7srhnaRlYLeUDMAif99vdeu05VfvA+Z7v7eK7U3pEyBwqIZG/VmPqIN361uhkIHCh/wncfUU2aBon4X4rycfjvmuft2ty5pKXf0jDwTsZaHyQQtqW6wXh7YkiaNI9otuxwK4T93zo+mwng1DGE3nOyYrJbs7iE5t9qQgvsA0W9F73zDePtJJJk7+zm3VKGa7oydMBvGGjT/Hu2xHa6DtmWEKyRHWb2tKH8CGjnqPc8hGgQKNn9z/hp/mOy/WRXigvMInlgkdOdB4yOAc00JyyWkB4m+5m9ahkC+VsI956KHsu09MAWfLFbVMne7+GC2qbNG7bCxChTfPqR5/jgZ4UuA537oa0dXQqQkRXeV6jJt8OLzsCRqFXSBsc0n6UDSD5ifOX7Atbsth39gU3gpaGlhq0r0vF19WZrK3fs8rY7VDUVuu1waPGQRPSiK2m9DzABmrfQ3oinXeduJ/KgpbaJos9LZHk51Lz7PX2bi/Fq+8kDtpRcZwmIB2cU9/ly0K1F7gKQMtcQ7NBemjehswQzBHrgkEoWEJLNIKLxiSz2hd/7KluwAOIR88Ix83HFB0MkOG/vR55CsOf+rrQBS6waLbMToifeR+Kq4/KHFy3/HDhiYJJs9uQYQoLpW1UviwqimgmKaIcVr2iY5geyu/LQbgECG1akDnazowHD+fmX78xTfWO13HzAoD4DQXzA+xerzG+IiD8Kmkyh1Ekwjs3
 wCBUgxgR
 DlLCvR1MfYpVu7cqKSRbWoHDPOJOGmYEJ/f4JAVCAqQ6vGP4Ni9esYQtHf265Bf73rd9c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dept engine works in a constrained environment.  For example, dept
cannot make use of dynamic allocation e.g. kmalloc().  So dept has been
using static pools to keep memory chunks dept uses.

However, dept would barely work once any of the pools gets run out.  So
implemented a mechanism for the refill on the lack, using irq work and
workqueue that fits on the contrained environment.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/dependency/dept.c          | 108 +++++++++++++++++++++++++-----
 kernel/dependency/dept_internal.h |  19 ++++--
 kernel/dependency/dept_object.h   |  10 +--
 kernel/dependency/dept_proc.c     |   8 +--
 4 files changed, 116 insertions(+), 29 deletions(-)

diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 953e1b81a81f..1b16a6095b3c 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -75,6 +75,9 @@
 #include <linux/dept.h>
 #include <linux/utsname.h>
 #include <linux/kernel.h>
+#include <linux/workqueue.h>
+#include <linux/irq_work.h>
+#include <linux/vmalloc.h>
 #include "dept_internal.h"
 
 static int dept_stop;
@@ -143,9 +146,11 @@ static inline struct dept_task *dept_task(void)
 		}							\
 	})
 
-#define DEPT_INFO_ONCE(s...) pr_warn_once("DEPT_INFO_ONCE: " s)
+#define DEPT_INFO_ONCE(s...)	pr_warn_once("DEPT_INFO_ONCE: " s)
+#define DEPT_INFO(s...)		pr_warn("DEPT_INFO: " s)
 
 static arch_spinlock_t dept_spin = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t dept_pool_spin = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 /*
  * DEPT internal engine should be cautious in using outside functions
@@ -268,6 +273,7 @@ static bool valid_key(struct dept_key *k)
 
 #define OBJECT(id, nr)							\
 static struct dept_##id spool_##id[nr];					\
+static struct dept_##id rpool_##id[nr];					\
 static DEFINE_PER_CPU(struct llist_head, lpool_##id);
 	#include "dept_object.h"
 #undef OBJECT
@@ -276,14 +282,74 @@ struct dept_pool dept_pool[OBJECT_NR] = {
 #define OBJECT(id, nr) {						\
 	.name = #id,							\
 	.obj_sz = sizeof(struct dept_##id),				\
-	.obj_nr = ATOMIC_INIT(nr),					\
+	.obj_nr = nr,							\
+	.tot_nr = nr,							\
+	.acc_sz = ATOMIC_INIT(sizeof(spool_##id) + sizeof(rpool_##id)), \
 	.node_off = offsetof(struct dept_##id, pool_node),		\
 	.spool = spool_##id,						\
+	.rpool = rpool_##id,						\
 	.lpool = &lpool_##id, },
 	#include "dept_object.h"
 #undef OBJECT
 };
 
+static void dept_wq_work_fn(struct work_struct *work)
+{
+	int i;
+
+	for (i = 0; i < OBJECT_NR; i++) {
+		struct dept_pool *p = dept_pool + i;
+		int sz = p->tot_nr * p->obj_sz;
+		void *rpool;
+		bool need;
+
+		local_irq_disable();
+		arch_spin_lock(&dept_pool_spin);
+		need = !p->rpool;
+		arch_spin_unlock(&dept_pool_spin);
+		local_irq_enable();
+
+		if (!need)
+			continue;
+
+		rpool = vmalloc(sz);
+
+		if (!rpool) {
+			DEPT_STOP("Failed to extend internal resources.\n");
+			break;
+		}
+
+		local_irq_disable();
+		arch_spin_lock(&dept_pool_spin);
+		if (!p->rpool) {
+			p->rpool = rpool;
+			rpool = NULL;
+			atomic_add(sz, &p->acc_sz);
+		}
+		arch_spin_unlock(&dept_pool_spin);
+		local_irq_enable();
+
+		if (rpool)
+			vfree(rpool);
+		else
+			DEPT_INFO("Dept object(%s) just got refilled successfully.\n", p->name);
+	}
+}
+
+static DECLARE_WORK(dept_wq_work, dept_wq_work_fn);
+
+static void dept_irq_work_fn(struct irq_work *w)
+{
+	schedule_work(&dept_wq_work);
+}
+
+static DEFINE_IRQ_WORK(dept_irq_work, dept_irq_work_fn);
+
+static void request_rpool_refill(void)
+{
+	irq_work_queue(&dept_irq_work);
+}
+
 /*
  * Can use llist no matter whether CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG is
  * enabled or not because NMI and other contexts in the same CPU never
@@ -319,19 +385,31 @@ static void *from_pool(enum object_t t)
 	/*
 	 * Try static pool.
 	 */
-	if (atomic_read(&p->obj_nr) > 0) {
-		int idx = atomic_dec_return(&p->obj_nr);
+	arch_spin_lock(&dept_pool_spin);
+
+	if (!p->obj_nr) {
+		p->spool = p->rpool;
+		p->obj_nr = p->rpool ? p->tot_nr : 0;
+		p->rpool = NULL;
+		request_rpool_refill();
+	}
+
+	if (p->obj_nr) {
+		void *ret;
+
+		p->obj_nr--;
+		ret = p->spool + (p->obj_nr * p->obj_sz);
+		arch_spin_unlock(&dept_pool_spin);
 
-		if (idx >= 0)
-			return p->spool + (idx * p->obj_sz);
+		return ret;
 	}
+	arch_spin_unlock(&dept_pool_spin);
 
-	DEPT_INFO_ONCE("---------------------------------------------\n"
-		"  Some of Dept internal resources are run out.\n"
-		"  Dept might still work if the resources get freed.\n"
-		"  However, the chances are Dept will suffer from\n"
-		"  the lack from now. Needs to extend the internal\n"
-		"  resource pools. Ask max.byungchul.park@gmail.com\n");
+	DEPT_INFO("------------------------------------------\n"
+		"  Dept object(%s) is run out.\n"
+		"  Dept is trying to refill the object.\n"
+		"  Nevertheless, if it fails, Dept will stop.\n",
+		p->name);
 	return NULL;
 }
 
@@ -2957,8 +3035,8 @@ void __init dept_init(void)
 	pr_info("... DEPT_MAX_ECXT_HELD  : %d\n", DEPT_MAX_ECXT_HELD);
 	pr_info("... DEPT_MAX_SUBCLASSES : %d\n", DEPT_MAX_SUBCLASSES);
 #define OBJECT(id, nr)							\
-	pr_info("... memory used by %s: %zu KB\n",			\
-	       #id, B2KB(sizeof(struct dept_##id) * nr));
+	pr_info("... memory initially used by %s: %zu KB\n",		\
+	       #id, B2KB(sizeof(spool_##id) + sizeof(rpool_##id)));
 	#include "dept_object.h"
 #undef OBJECT
 #define HASH(id, bits)							\
@@ -2966,6 +3044,6 @@ void __init dept_init(void)
 	       #id, B2KB(sizeof(struct hlist_head) * (1 << (bits))));
 	#include "dept_hash.h"
 #undef HASH
-	pr_info("... total memory used by objects and hashs: %zu KB\n", B2KB(mem_total));
+	pr_info("... total memory initially used by objects and hashs: %zu KB\n", B2KB(mem_total));
 	pr_info("... per task memory footprint: %zu bytes\n", sizeof(struct dept_task));
 }
diff --git a/kernel/dependency/dept_internal.h b/kernel/dependency/dept_internal.h
index 262114a0110c..4c4d7bacec15 100644
--- a/kernel/dependency/dept_internal.h
+++ b/kernel/dependency/dept_internal.h
@@ -26,9 +26,19 @@ struct dept_pool {
 	size_t				obj_sz;
 
 	/*
-	 * the number of the static array
+	 * the remaining number of the object in spool
 	 */
-	atomic_t			obj_nr;
+	int				obj_nr;
+
+	/*
+	 * the number of the object in spool
+	 */
+	int				tot_nr;
+
+	/*
+	 * accumulated amount of memory used by the object in byte
+	 */
+	atomic_t			acc_sz;
 
 	/*
 	 * offset of ->pool_node
@@ -38,9 +48,10 @@ struct dept_pool {
 	/*
 	 * pointer to the pool
 	 */
-	void				*spool;
+	void				*spool; /* static pool */
+	void				*rpool; /* reserved pool */
 	struct llist_head		boot_pool;
-	struct llist_head __percpu	*lpool;
+	struct llist_head __percpu	*lpool; /* local pool */
 };
 
 struct dept_ecxt;
diff --git a/kernel/dependency/dept_object.h b/kernel/dependency/dept_object.h
index 0b7eb16fe9fb..4f936adfa8ee 100644
--- a/kernel/dependency/dept_object.h
+++ b/kernel/dependency/dept_object.h
@@ -6,8 +6,8 @@
  * nr: # of the object that should be kept in the pool.
  */
 
-OBJECT(dep, 1024 * 8)
-OBJECT(class, 1024 * 8)
-OBJECT(stack, 1024 * 32)
-OBJECT(ecxt, 1024 * 16)
-OBJECT(wait, 1024 * 32)
+OBJECT(dep, 1024 * 4 * 2)
+OBJECT(class, 1024 * 4)
+OBJECT(stack, 1024 * 4 * 8)
+OBJECT(ecxt, 1024 * 4 * 2)
+OBJECT(wait, 1024 * 4 * 4)
diff --git a/kernel/dependency/dept_proc.c b/kernel/dependency/dept_proc.c
index 97beaf397715..f28992834588 100644
--- a/kernel/dependency/dept_proc.c
+++ b/kernel/dependency/dept_proc.c
@@ -74,12 +74,10 @@ static int dept_stats_show(struct seq_file *m, void *v)
 {
 	int r;
 
-	seq_puts(m, "Availability in the static pools:\n\n");
+	seq_puts(m, "Accumulated amount of memory used by pools:\n\n");
 #define OBJECT(id, nr)							\
-	r = atomic_read(&dept_pool[OBJECT_##id].obj_nr);		\
-	if (r < 0)							\
-		r = 0;							\
-	seq_printf(m, "%s\t%d/%d(%d%%)\n", #id, r, nr, (r * 100) / (nr));
+	r = atomic_read(&dept_pool[OBJECT_##id].acc_sz);		\
+	seq_printf(m, "%s\t%d KB\n", #id, r / 1024);
 	#include "dept_object.h"
 #undef  OBJECT
 
-- 
2.17.1


