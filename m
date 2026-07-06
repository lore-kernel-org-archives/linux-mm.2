Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFACC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA9F6B00EF; Mon,  6 Jul 2026 02:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB136B00F1; Mon,  6 Jul 2026 02:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424A96B00F2; Mon,  6 Jul 2026 02:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 169E66B00EF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:21:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93B461C1EBA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:21:00 +0000 (UTC)
X-FDA: 84957353880.10.A27477E
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf17.hostedemail.com (Postfix) with ESMTP id 73D5340002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf17.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318859;
	b=vI03xyQvFy15NAz6H8pKNDz7f1vcUwP4seDi6lzzLo1QmsEI+epVxOPxDrgpRnvp5KEdD3
	WB0Py3L/wxM7Dmyz/iy1yzRuK320EgDFPsXaE7FBpT1+MnVavYFv2mVLIkYFEP3JXWrrmR
	lvM4HfOWqc5K70vTKe5FaKs912aulck=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf17.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=xBro/pS8XSklZi33ajlqBMARpg6j4+kbGF2NYOwbtjg=;
	b=MY4YIcm6HHSYtV2SXLD10lMLBqaJQ/6GCsfkkXCP2fNcojbMmQ8H1jdGkNJX8McY2oD86O
	m7y7Gpkx8hDiDOobJkMsvheEe1YBsTIi/OYEBjTaQqaQNdnoJnLSUtFB6Mgzdo1gTzO1p0
	DaS2T1p7ScaWoaf6LTmRJeGXRMBqqcA=
X-AuditID: a67dfc5b-c45ff70000001609-2d-6a4b4905bbfc
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
Subject: [PATCH v19 33/40] dept: call dept_hardirqs_off() in local_irq_*() regardless of irq state
Date: Mon,  6 Jul 2026 15:19:21 +0900
Message-Id: <20260706061928.66713-34-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTdxjG/Z87nZWTasYRs2BqcNpFFEHzxrnNffJ4y0yW7MMWo904Slmh
	TatcTAytihEHUru0BgoEYUOk5RKKFzpRrFAE2tACYlVAqq6MYMWoZZuUsML0y5snz/O8v08P
	g0uGyXhGkXVU0GTJlVJKRIhCSy9tYHbtydgUsLNwtiAfhvUdBJQ32SiYs1yn4d6DkwR4G60I
	/p614GDSI5hvdyEw+4w4XJzUE1AWtNAw2bUT5kcnMJgyv6Jg1tOPQ6trDEF73UkKBp8vg6Hw
	NAUhXzkGL5sp8LmnEFRYjAiCj9oxOFXTREHbuIMG31QEgxGzEQNryz7oM1RjYLl4CgNTwx8Y
	uGtGCKjVJYLFM0hCJJAM81UqcFknaBgtMRHQGOonoWdsmISpoJGC67pxGt4OBTA46wgT0PIs
	GpRWjlDguvEUg0FHOQVFzVdJGLPNk+Dt6CNhwOoloGnCj0Gf6x4BPWVXCHjsKaGh39FAgt3j
	xmHm/CrwXigmwW/4E0HDy2pqRxpfb7+G8bZKG+ILDNFz98U0zv/e94Li34XvU3xvNcf/VvgO
	4y94NvBtZaM0f/rWI5qvajnGn+4Mkby9TsbX3JzE+Euvw+T+5O9F29MEpSJb0Gz88pAo/a/h
	AlKtj80N2kCHQh+dQzEMx6ZyrbcHsA+6v1VPLGiK/ZTz+//FF/QKdjVnLw6S55CIwdnBBK6o
	tnixtJz9kTOHxqIlhiHYRK54SL1gi9mtXO01w3tmAmdt7ljkxET9xkjFoi9ht3CPp7uJBSbH
	Xo7hTPW95P8PK7k7dX7CgMRVaEk9kiiysjPlCmVqUnpeliI36SdVZguKrq32ROSHG+i191sn
	YhkkXSqGHbszJKQ8W5uX6UQcg0tXiNeu25MhEafJ844LGtVBzTGloHWiVQwhjRNvnslJk7BH
	5EeFnwVBLWg+pBgTE69DFWcCsfmxm2Rfd5pK26oSfKXrfBH2WfevPTu7TBZ3ZQ9a82SJk0kJ
	9K5RQX78P2y5LnVOJatWqVNUb745MKPccqij8JcjszkfG90O+ulxKvFKUUn21r3jh9VnZPRA
	3Of738geblPkGMxfhDMLI7s/62bn8j+5v/6rJ0kJztxk7XdSQpsuT5bhGq38PzJOGWtpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0xScRTH+90XV5K6Ec07bdlYT0urle30WPbmmus129r6p6juEgUzKItW
	SyCmPWxEgUs0zZI1pTIflDWWs2UPa0n2cOWjB1FOiVZY+UBDW/+cfc/nfM93549D42InGUkr
	0vfz6nS5UkoJCeGGJYZYMjEpde4JxxzIMR6D1g4PCa91dQT0BHIIKLjhoCBouyWAnMoLJDx6
	oyeg6Xo5go6eHAS/+204GGuHCAiaGwQQ6H0nAIsOwZCrAYHVbcahpekeDo5qHQY/KwYp6Lr/
	A4Hlg4eCvE4dAX77aQT5XpsAOh/IwNdxl4Shti8YvPnVjcDuGcTAU5eNIGhNg6KSqtC69TsF
	/c+e45BnaUJw6UMbDj863yOobmhH4Lqqp+CzqQaHZs8YeNnjp+Cx5RQFPncBBt8qKCjWu0hw
	P+1CUGgzI/C+dWFguHyDAmthJQG17+8IwN01gEGr1YxBeeV66LB7CWg0lWChc0OumxFgyzNg
	ofIVA8u1uxj02ssEy0sR99t4huDKqpwYZ3wRpDjHRQfi+vvMiAuUGnDOaAq197v9OHe86iBX
	2thNcX09ryjO9auY4J6UsNyVE30Yd/ZZLFeb3ybYtGKbcOluXqnI5NVzlu0Qpnx9bSQzdGMP
	eR2QhXyjT6IwmmUWsM+rdcSwppjpbEtLLz6sJcxktirXS55EQhpnmqPZ0/bcEdN4Zidr9bWH
	TDRNMFPZ3JcZw1jELGTtThP2LzOaLa+oG8kJC/HrA4UjXMzEs+/8DwkTEhajUWVIokjPVMkV
	yvg4TVqKNl1xKG7XXlUlCn2T/ejA2dso0CyrRwyNpOEiWL4uVUzKMzVaVT1iaVwqEU2bkZQq
	Fu2Waw/z6r3b1QeUvKYeRdGENEK0biu/Q8zske/n03g+g1f/n2J0WGQWulWTrfRLuFFrHdPu
	zIjJ7t066WPUqnPYlORA8Jg2fO30yT7JlVUDWRPVTnf827hZ81dPiNJGvpiavCjxJlqcXIav
	UanOxSQcWR3VvuXy5i/hR/cl/BkXiNZr/Pol9bNlO396Z9ZuDPTrGrelnTl/QC4rkh3+HPuA
	SJj/9NPKmsEVW45ICU2KfF4MrtbI/wIjatboSQMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 73D5340002
X-Rspam-User: 
X-Stat-Signature: i4wcijxz64d1e6mn1xycn4sf43rc7wn7
X-Rspamd-Server: rspam03
X-HE-Tag: 1783318858-713773
X-HE-Meta: U2FsdGVkX18NR1t3knwjXaVWGl3AfQN/4XiHo2ionDD9i+dA9/13vFsNCaNAOEP4PWkQfochG548YMl10T63hQGpLjgBokBqHFQJr7sFCqe1l/0NI66ipsVPO8bHO4//tjOuoRJZ5EkpvCZDKKFi3PXgKlC72Ab2bEINWs29BC7O6ORpMkaxCHfNw6uxoIWiyBHcZNWz1wn7clyfRse6Hei5JJiVDm7naGPYtIo29jVxC0PcFf2EKJ8UVUPwtfOhKngVSVGSevhUh1dSg6iaCV9D0Ju83q41t4f0MVPdVDGI9eHWUd93JUk/5s0fXMCN5fd8lRgqtM7ZEyu9MRwIVVqXCjO5iGU5E8BuEcXDcvMASn5mUEtKQ4rWeKrREoScw+YQiJ0aPbHsP0EoE99bdamOCaZH/GLiDt4zam9Ak6cQxqYDL0noK4/Py2TwwhkTXqOOGaJtomPXMjy2xho0++8ZCvjGXf8LzvhvhILN/mHdZ+73Jwgfg4PYg6E7yk0ROgOOj6+Yajbx+ht/KC+imQEpOwkmT2sPaBlqiHiBqQtpK03icr/F+hc52qnCHlZD57Sk0AN9tBH9qg1bj4+/5JL7qP3LeUrPcj+h7nq5n5HSAEHxGEtre4e2lw8Lj5uc+RQkECpglrVyHswNiOjaAiwADNb1JT7oO1YzGFZnwOxMDF77uGLPK+TC6YBw7bWcJKfHIhKuk7bH6T9er6qy4cxnXVNgW02BEMcPZfsQukc/o4qZ/I4HAQ3EIxKvVZwx0L7rpEogY0ULOeTA63GkNMiQCC9JHNBxQ/A7cy2qKKqCGk0ACmqZANEEYtkcW+RjuUB0JeMIWg4rL1sLSRIV3DeFr5Z9R0RAMpOG58H0R1X19pMNWGZFYfRngEznFM+szeHAPBJ2Sy5nnIFrgeBa5vcuCg8bjmC/LnBtEqsRIjGwfuSe9gFG2Ula7iJJW/bRb0xDKRX4/gkroUu+HDa
 DcK2QXqH
 1Yk31mhulGOr5wjP6DLrYn144dgbvnFWFwI7GCd9zDnLkzKmXVvNbBwipArTovuXYNePzQ92kRSjt6tE2gnJx9+aWJDYvVugDf+B7CiWoq5gR3FraRqALfavFyWUPv8iuTlATe2ESCaVjjMiRBDE9VN+D4/Dxu3YRpbaHxVMSE20/mRhoEJ29glDocoUUvjGpfrzf2vJzUB+hxFO4h+3zc8jM2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For dept to function properly, dept_task()->hardirqs_enabled must be set
correctly.  If it fails to set this value to false, for example, dept
may mistakenly think irq is still enabled even when it's not.

Do dept_hardirqs_off() regardless of irq state not to miss any
unexpected cases by any chance e.g. changes of the state by asm code.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/irqflags.h | 14 ++++++++++++++
 kernel/dependency/dept.c |  1 +
 2 files changed, 15 insertions(+)

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index d8b9cf093f83..586f5bad4da7 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -214,6 +214,13 @@ extern void warn_bogus_irq_restore(void);
 		raw_local_irq_disable();		\
 		if (!was_disabled)			\
 			trace_hardirqs_off();		\
+		/*					\
+		 * Just in case that C code has missed	\
+		 * trace_hardirqs_off() at the first	\
+		 * place e.g. disabling irq at asm code.\
+		 */					\
+		else					\
+			dept_hardirqs_off();		\
 	} while (0)
 
 #define local_irq_save(flags)				\
@@ -221,6 +228,13 @@ extern void warn_bogus_irq_restore(void);
 		raw_local_irq_save(flags);		\
 		if (!raw_irqs_disabled_flags(flags))	\
 			trace_hardirqs_off();		\
+		/*					\
+		 * Just in case that C code has missed	\
+		 * trace_hardirqs_off() at the first	\
+		 * place e.g. disabling irq at asm code.\
+		 */					\
+		else					\
+			dept_hardirqs_off();		\
 	} while (0)
 
 #define local_irq_restore(flags)			\
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 007e1bc7d201..35a3667ac8b3 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -2095,6 +2095,7 @@ void noinstr dept_hardirqs_off(void)
 	 */
 	dept_task()->hardirqs_enabled = false;
 }
+EXPORT_SYMBOL_GPL(dept_hardirqs_off);
 
 void noinstr dept_update_cxt(void)
 {
-- 
2.17.1


