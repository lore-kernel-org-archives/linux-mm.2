Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE52C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2996B00B6; Mon,  6 Jul 2026 02:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079C76B00B7; Mon,  6 Jul 2026 02:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C116B00B8; Mon,  6 Jul 2026 02:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9C7E6B00B6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48BED8D105
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:23 +0000 (UTC)
X-FDA: 84957352326.23.926A58E
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6C74020002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=KBo4j9odS0bfXTnFZRDFUvRjMDVquFZkh/AYrfKB7tw=;
	b=BigdN2/rt52b7aGs5kp1LScdZbQ4ZxOENwLj88lq5wYnhZ4lvCYTvMM/VIcjC3XfbufKK5
	BiBOJA0yfEDaOn1UBR9ZXx3/aKZpEpnlr8M9LqLQrLDxRp4iYpWAJbXM96PBqAhRfck3gF
	5/US4EnwKJ5Cp2djCNA12WswVqQ/d50=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318821;
	b=oalORqwiLnJUKOBJpCZ5PNy6vIC+fpoRWDbgP+0ccI33Zgczwsek9o/eVBHLWpT7SH4AIT
	1D6GLxAzc33RbGc87v2w8tTJlsNPGPd9VRlUiYBTOanKsfGHKesnOxEavLDblbJGqr8yUg
	ix09IVrEy3fcldSibTOyxHypUYipnc8=
X-AuditID: a67dfc5b-c45ff70000001609-e6-6a4b48fe6c67
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
Subject: [PATCH v19 14/40] dept: apply sdt_might_sleep_{start,end}() to dma fence
Date: Mon,  6 Jul 2026 15:19:02 +0900
Message-Id: <20260706061928.66713-15-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0xTdxTH+d37u7el0uSmaPxN/9B1wTkYTA0uJ2Yq0SVeITMuM3EZM1tj
	b6QIVFtksMTIQwyOooARgghSula05WGrrhqrgLPyKrQqj/Eoiq5Mi2NpwEREWcvmf5+c7+Pk
	JEdMywaZFWJVRqagyVCkyVkJlryM0MeinUmp68qus1BUeAxGx58xMJDXiuF8s4WFt9W/iaDI
	WsVAx2A+BneTGcHZPAQLDieCCk85DUPuOzRYruZR4L8bQDBt0gXVsUkKLtTbWPBX/MPCG1cf
	DVedXgSOhnwWOs8Ws1BTXY6gwNDMQkWNFYPHP0/BaEU5BWbrVzBu8mHoLq2noPJ50HBlOVRX
	/kVBj2EUgyk3Chbq1OA0T4qg6WUfA53eAQb8vnIWxu+fYGDm0RMKLDofDUU3ZzE4hmNAf+JX
	DFW1o8ET384gcNonKNC1XGPAa1lgwN3azcADszu40tmBofPcJQwjrtMi6LvZyIBx0EOBzdVD
	w6tTK8FdVsLAmb99CP6onBJBXpsBJyh5S60F8TPGApovLA3S3alpmjd2T7H83Gw/y3fVE77M
	FcvfODcm4o/fHhbxddYjvK0hmjfcek7x+sAsww/7N/PWyyfZ3dHfSb5QCmmqLEHz2ZYfJSkd
	V7pEh4ql2b2lu3LRlOQXFC4mXDwpvFTFvOeJsV4UYpb7mAwNvaZDvJRbTWwlvqBHIqa5h6uI
	zlSCQ0Ik9zVxzOoXGXNRpNFesBiQcp+Trn7j/6WriLmldXEeHpw3zddQIZZxG8nI9H0cKiVc
	dTgZePcU/xf4gLQ1DOFSJK1DYZeRTJWRla5QpcXHpeRkqLLj9qvTrSj4bqaj88l2FHB/0444
	MZJHSCEhMVXGKLK0OentiIhp+VLpmrVJqTKpUpHzs6BR/6A5kiZo29FKMZYvl2549ZNSxh1Q
	ZAoHBeGQoHmvUuLwFblI1zjh32Vpvifavq0tsDVsxPx9okEeOXfNsS+z6uiHyusjzN5lXwbs
	Ts+SbOLJju0V9G8ek40WtbZ7puuAve3TltW21s3ub8cPUy2Hd+wrVn8UN92TPPf7J0Y8WRKX
	4w1b9jjKrE7cE9H/J+TTPfFef8JYPuU6ExkjvZj0YtP2O3KsTVGsj6Y1WsW/APD4SGoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+793V4vXJfhSdGFQRqBdyDhhRH2I3i5aQdDlQznyrc07m5l2
	Id0amVpsi01qmtNyhC6vlVmOzEpt3VxmrotZsVbiysjN8DJtGn05/M7znOdwPhwGlzSScxlF
	aoagTJUlSykRIYqL0URO8NsSV3heLYE87Wn40Ocm4U1uCwF+Xx4BxTU2CgLmRhry6i+R0NGj
	JqCzugpBnz8PwZ8xMw7apkkCAoY2Gnwj72kw5iKYtLchMDkNOLg67+Ngu5mLwVDtBAUDD38j
	MH52U1DUn0vAoLUQwWWPmYb+x5vhR989EiZ7v2HQM+xFYHVPYOBuOYsgYEqC0vKGYNz0i4Kx
	5y9xKDJ2Iij73IvD7/5PCG62fURgv66m4KvuFg5d7tnw2j9IwRNjAQU/nMUY/KylwKK2k+B8
	NoCgxGxA4Hlnx0BztYYCU0k9AU2f7tLgHBjH4IPJgEFVfSz0WT0EPNWVY8Fzg1N14WAu0mDB
	8h0D4417GIxYK+kNFYj/o71A8JUNtzFe+ypA8bYrNsSPjRoQ76vQ4LxWF2wfegdx/kzDMb7i
	qZfiR/3dFG8fthC8o5zjr50bxXj980i+6XIvvXPjftG6BCFZkSkol6+PF8k76hx0eoE464Uu
	Lgd5RfkohOHY1dyX3hdoiik2gnO5RvApDmMXcQ3nPWQ+EjE427WQK7SeJ6aMOewuzu4vm2aC
	XczduKOZDojZNZyju4L8t3QhV1XbMq2HBPXq8RJsiiVsNPd+sJ3QIZEFzahEYYrUzBSZIjk6
	SpUkz05VZEUdSkupR8F3sp4a199Bvq7NrYhlkHSWGDZsTZSQskxVdkor4hhcGiZesnRbokSc
	IMs+LijTDiqPJguqVjSPIaTh4q17hHgJe0SWISQJQrqg/O9iTMjcHITtK744XFgQQVj8Fv05
	R+xQR/nsSqc5K59e2zgzRXJAGrUjdmgTPi/9UORiY0yNS4i+4Lqiljd/iehOaHpweDKincxR
	75aX6p22NaoE+UBB8/zQR6Gr3p40rEjTNZ+gAj79272jj3QutzdmdSnz4En3lu2O+GvLhfAF
	lva6uBlSQiWXrVyGK1Wyv//RwaZKAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C74020002
X-Stat-Signature: 8idaxseic84gy19yctkbsj35xk49we7s
X-HE-Tag: 1783318821-753459
X-HE-Meta: U2FsdGVkX1/N3decJucOQHhsWEEUmaBNiqbsLhJrKLrDQ5tjcKH/VLIceMZX9tpPaOr/3cFu9vIWrYhw3CmDwHWebn0/fdZuCmwjUM80nN7d/oirnBJFkkDobX3pJlTREGfFvs9Pu712xKMC60FDQ+5rq7TZaiiVYNDuuF9ZsLkT5XJ/Pnlk0rGWcHD+oI15/fCfnFypENEINVkWgQPz6YyOvMEld95bvUqO0UTjG1L8iIFXEmsHNTixrg74BK8SNmBp51NmlLwb7RIw/Wj/eDQcbLU/5yulAbmiErx2Hk22jg7k3D1EEaG/XNaYhBWWYamIFh6km8WQMZf8qusl6spIg0tdA581zl0t0hDkfdHXBpkMWwW+ksqCDcfckYe6fho7ByiJiflFmxhMRn7FdmThjSULN9pnO3lzlkw5zv7RON4HsmuldNa1v2JLehUFNPf2Cczi4wJyjH4QTbRpehP14pQpmB/EVhNSm+V7gIhC1Q3P1v2TiheLgJGV1taQb6lKqMoLxoiMwJhszVtPzlZM9R5Fb5JA6IV1Gta2nj2pgTBJFhKXiHEvg70qg0jGlGKrIYW73OSJA3KkGP9rAgBZKMnTE8HX0BvGlEXIqQD8xtV1vp3xpbuoBpJuAKzB77hcjGyCgN1Yc6hHd+Rw474opjd68us90ckUE6x4ZPzgfKg4e9cc9yvrOOMYmYqX0pTqqFJEPgTEAr8cFtnv4leNClEo5MlRmx8YfpRYQduLLEwYItNOA8EFA4YIk88+HOhZD7JFQ66YDH9hNwC5mt6LoipEITK72DTopNUAmxqUEq85wlM/GlQG3Puy1fs2gnIz+dqGtQO9ud3WMy3ce8whvz2S5j2dlCXOfFIhhIsDsVO684db3UJvbPbJYJfdAY5+G63o0CuDVRk0UeodEpj9dTuxPnchYnagpyHtWI1v1sP0hSYFslVmTrszRqQcAFssI5Uz1zz8qFNQQhY
 zTeGa7ie
 fvmupfLRc46AW/2jJVoPsvtiV1QWGTWEl+2URuMkpP/mT6Pws9EBeAyX2HVUg8nLGxXDcUOMlQF+6CejbqhsphTeNtQt+uKg67hnKuX+/rpfg3PQEf+3BFEG5KXRzG3xGPemd2KDrjB4/VtRjS0+kl74lfp+ey/HfK5Gf/ZfhopKT7p+8xXZ9bLRC1aDU9e5oH5iP8smHXoiKQlzyOyBXwnjPnIaBAHoNefShpm1nhRDMW1o/nn65K0DLfGhw/OhHlyz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make dept able to track dependencies by dma fence waits and signals.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 drivers/dma-buf/dma-fence.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 35afcfcac591..f7498c770035 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -16,6 +16,7 @@
 #include <linux/dma-fence.h>
 #include <linux/sched/signal.h>
 #include <linux/seq_file.h>
+#include <linux/dept_sdt.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/dma_fence.h>
@@ -822,6 +823,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 	cb.task = current;
 	list_add(&cb.base.node, &fence->cb_list);
 
+	sdt_might_sleep_start(NULL);
 	while (!dma_fence_test_signaled_flag(fence) && ret > 0) {
 		if (intr)
 			__set_current_state(TASK_INTERRUPTIBLE);
@@ -835,6 +837,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 		if (ret > 0 && intr && signal_pending(current))
 			ret = -ERESTARTSYS;
 	}
+	sdt_might_sleep_end();
 
 	if (!list_empty(&cb.base.node))
 		list_del(&cb.base.node);
@@ -924,6 +927,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 		}
 	}
 
+	sdt_might_sleep_start(NULL);
 	while (ret > 0) {
 		if (intr)
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -938,6 +942,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 		if (ret > 0 && intr && signal_pending(current))
 			ret = -ERESTARTSYS;
 	}
+	sdt_might_sleep_end();
 
 	__set_current_state(TASK_RUNNING);
 
-- 
2.17.1


