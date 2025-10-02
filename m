Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D32ACAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5FD8E000F; Thu,  2 Oct 2025 04:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77368E0008; Thu,  2 Oct 2025 04:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9D68E000F; Thu,  2 Oct 2025 04:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB1CF8E0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E9AF1191B7
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:16 +0000 (UTC)
X-FDA: 83952459192.24.A4D2AA6
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96585A000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Jx1fwvcyPyfVj+2h4k7nvo/fnuBkbemC4LrGi53TwS0=;
	b=r1meLhfhGgjVTjI00Rfpm9w+O5xiBxuAPDZv/u+rTOXboF+FIz4K2p5GrPHX6wvJqAn/KO
	aeFAXgoDcGhVreWL1Vs0FNVQwhR49m+SBMT1eVJ+d/woPkSvh9ReZEILAZa/bRx4uw0Ti9
	6AlGagwEMlrpDxF9jN000rGKB86mAMs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392795; a=rsa-sha256;
	cv=none;
	b=yCMWptquCQLn0sJAxRYU6E/bjjfQ/YL6v0VSb8WeL3aPr/AxZSrXFi/J3XHRabJqLOhOxO
	OjmFDY7f/te05y/oDHxRoivdIniSBNfb1+ueeCCZgMeO3+fpQjt/erx847JIwB8HPNOt58
	e/Sf8ViTlrNku0e+J6oZrTjlx102xzk=
X-AuditID: a67dfc5b-c2dff70000001609-9d-68de340bf1d3
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
Subject: [PATCH v17 04/47] dept: add lock dependency tracker APIs
Date: Thu,  2 Oct 2025 17:12:04 +0900
Message-Id: <20251002081247.51255-5-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSbUxTZxQH8D33Pvf2tqHLTUfGM3Bu60KW+DqXzh2jM/Jh8ybuA85kZuzD
	7ORmbcabrTBYsqQICAOnpRvqBLWU2XS0EQayQWNNIbFTC6GlDGuVSgkysTCm0mrHm+0Wv/2S
	8/+fnA+HoxV/MpmctuiwqCtSFyhZGZbNpVk2pqnCmreXf5DDWKUbQ0uHgwXfRTuCu7E6BE8W
	m2mo6VvFsGzySGAhcVsCqy4PgpN+Ew2OS5UUPO5cYaEpMsXCzNXdcDM+i8A6tULB4tAwDa2R
	cRrud9YiuOQJI3DZjrBwz9hDQ2DqRRiNzbNwvamBhTl/CwXmIy4GzjabEFS1dbDQN+GUgD+6
	RIHXaKHg1AwLJ3/NgIS1XQKDbXcwWA3Z0DwUYGDSdiZ5lbkYPPa/JDB+ognDxblhBqLTJhbu
	/nGUgd8NExLounUVwcJohALHsWka6pwxDK7Qemg9+jOGuuUFBJ7eSQoCzhYWjnX2MBB2rDLg
	c3sZGLH7MHg91zBcuOmnIDIRZKB7aJCG+PGsXfnCk5rjWGjv/o0SHOccSFj814SEGmNSF7yz
	rOCKm7Fww0KExqGNQt+ZcYlQfSUkEcxdpUK3bZ3QdnmGElofxRghFH0/d32ebEe+WKAtE3Wb
	dx6QaaIjX5ScJeWVD+yMAY0q6hHHEV5FGsNlz2moldYjKcfyb5FgMEGnnM6/Trq/n2ZSpnnv
	GjLm35DyS3wOqV15TKWM+WzSMPkTm7Kcf5eM1Q+jlAn/GrF3uv/bI+W3kkDEi1NWJDM189XJ
	riyZaZaSh/2z+P/CK6TfFsRGJDejF9qRQltUVqjWFqg2aSqKtOWbDhYXdqHks1m/XfqsFz3y
	7RtAPIeUaXJf9rhGwajL9BWFA4hwtDJdfsB2R6OQ56srvhF1xZ/rSgtE/QDK4rAyQ/5O/Ot8
	Bf+l+rD4lSiWiLrnU4qTZhrQnsBS+Fy95fR3/fPxnhMD1of27XtDn2R+vNtYFdvwYMub6T2x
	81rt4KFDe9ZAYoe8OPHL05Kcf9Y6M977wKIy/mjNU1Zvy9KT8tydvdf+dnbM7dv7Rt793LWl
	Hwmhuv0tjQdV7KeX9+dNytw5Qf3IqVepK9fd9MsfZty+dbphW190qkqJ9Rr1lnW0Tq9+Bjgg
	UlloAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSf0zMcRgH8D7f33cc353GV2zZbc00oc2PB7H4py9z2BjDHzp8505d2V0i
	8+OuOqUjd7ddqdMPWSddkooJxy2TcVpOxOgkS6Jyxp2Wfpw7m3+evZ69nz17/ngYXNpMRjGq
	tAxBk6ZIlVFiQrx5dU7clKUflEsKXdHQpXcREPDnE3DpRh0F+Y0lJLyodyDoCeQjGBmz4WBo
	CRIwYWmjwT/6noagsw1BkceCQ12zHoNfDZMUDD76icDa20dB8Vc9AT77OQSl/TYavj5OguGe
	eyQEvV8wePN7CIG9bxKDPlcegomiFKioaqJgrL0Dh2LrCwSXe704DDSEwua2DwicNdkUfDbd
	wqGzbxq8CvgoeGo1UjDsuYTB9wYKKrOdJJTZLAhyrtygoKiskYCWj3dp8AyOY9BdZMHA0SiH
	Hns/AW5TFRa6LzR1cxbYinOwUBnAwHr9Hgaj9loanl/pJsCuiwFbeycJn2pKaRjvjYdgZTq0
	Ob7Q4L1gJaB+uINMtCJ+xFBI8LVNtzHe8HKC4uvK6xA/9seCeH91Ds4bTKH20ZAP53ObjvLV
	7iGK/xN4TfHO35UE/6yK483tcXxLqZfmcx+8o7eu2i1OOCCkqjIFzeK1yWLl4Mt9h8u4Y/pv
	DlKHXkkLEMNw7FJOlycqQCKGYudzb9+O4mFHsvO4pvP9ZNg4657LdXkWhj2DXcflTf7CwibY
	GM74qYQKW8Iu47oKOlDYHBvNORpc//aI2OVcZ6+bCFsamjH4cjETEleiiFoUqUrLVCtUqcsW
	aVOUWWmqY4v2p6sbUeiX7CfHzXeQvzOpFbEMkk2VeGK8SimpyNRmqVsRx+CySElyTbdSKjmg
	yDouaNL3ao6kCtpWNIchZLMkG3cKyVL2oCJDSBGEw4Lmf4oxoigdit/uW2C1V5y5RshXHRJl
	JExX+xasDETN/HjRhf/YNm+bUn5qzQ5TxchZMnlKpDlJUo4SnFcnuLidM9XxJXc2Hjpxf4XM
	aZSvH8g+9zki4kmi0eRPfBJMYHqOyNOtXXt0K9yCp9W8oSX2zS49fzpaPmqWG6s3GR/OPlq4
	Zcwwe4uM0CoV8bG4Rqv4C17aBwtHAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 6155nuthw55z8g87gkmosxos1qdp1inr
X-Rspam-User: 
X-Rspamd-Queue-Id: 96585A000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392794-920614
X-HE-Meta: U2FsdGVkX195EBY2djrU5+UPDhq+u3dh9HLb/8i0XBydLTi0l6hHSStUXbPFttmuq5U7xe/8dGSE2c7Vw1wBZs4wH+ZLc71reYcckM094HDC4iKf347QcQBny2/hB6nUZzDqtC45nkJtujX77SAnIre8RJMBMtAgat/9PrnSGl/6GCiadLzyb54O+h3MwwFFQYi54F+B4ljigUjl9SJX200qDrQZoxHkWA5LDSsY8oF+i/Crzp4l0MKKFoY03coD2SJvjlltCUhz7x5Z0jXi83nxYnXEzjlbn8maj230Rx7E5VnAczmYC2cEEwDgi/nKhYVBlg97McrGulS28Xs47Uaa3SqC4AAhd3PJpfY5PuMPQbUJc6o3K5sWqfwQXJN0PoS6Zsqoh9dAhFO/N6PbNnEPv+qLCZv4gEZfiP1pw0aeMB7mxOR7FTXNRuPMBuL9AwCCphpZoyKy4br8lqKdHaAXTz57pqu6Y3ErXE/xoLB+i4VXYUPshjXGCcST3HoZQ85TJxGvKEJlyO5wEMLBjqpi5eXfotIZQDzcLdOtodS3Ph8XUqi/H6o6VjMSL4gN+KQ9dqjTEy1k3QbN3ojLjo7dhoFB5kaMIIl+ur2sExTc6CYuH+EF4XTxFonqC05BRfBIZCjZrMH/OVqVcfuZVKxN5KJ+nvKXTH808H7AEC0rTuTQSZfoM/Vik18FunH3h6hTZu/DIfyjEMQLflirxUaPH8VK7sDuVaYP64BD6AcRKb0tJSNU5Qj3rpKmPS1g+UDtTi411cll761QeiAZ4LSvH0FlxVEzrPdB4laxVDg4NisCkT7Yr6VvNbmRn0IjoeXP0oBOrnU4yxPGz7HJ7xioeRdT3lF72s/JTq1Oa0mKjSP185R5ABxgzPGwptacBNoEEX5Ucya4+Pr9tuOOz6qm8gxrWhzp2GgTQhM5vZjo3KaMWe9uB2W+/lZQXtca/X7fhyYs9WF2qw9S90t
 mh/dIu9U
 uLyikrW7SksTEl42gr9L2kw4vn2kYL7Icbc1qQySDDm/LS5JHxFbWFXQtuRsU1YF1oiU14ZPq1aVA5FbUFdwUlifwmAF7GSCJ1g7SzquIwsdRjvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wrap the base APIs for easier annotation on typical lock.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept_ldt.h | 78 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 include/linux/dept_ldt.h

diff --git a/include/linux/dept_ldt.h b/include/linux/dept_ldt.h
new file mode 100644
index 000000000000..8047d0a531f1
--- /dev/null
+++ b/include/linux/dept_ldt.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Lock Dependency Tracker
+ *
+ * Started by Byungchul Park <max.byungchul.park@gmail.com>:
+ *
+ *  Copyright (c) 2020 LG Electronics, Inc., Byungchul Park
+ *  Copyright (c) 2024 SK hynix, Inc., Byungchul Park
+ */
+
+#ifndef __LINUX_DEPT_LDT_H
+#define __LINUX_DEPT_LDT_H
+
+#include <linux/dept.h>
+
+#ifdef CONFIG_DEPT
+#define LDT_EVT_L			1UL
+#define LDT_EVT_R			2UL
+#define LDT_EVT_W			1UL
+#define LDT_EVT_RW			(LDT_EVT_R | LDT_EVT_W)
+#define LDT_EVT_ALL			(LDT_EVT_L | LDT_EVT_RW)
+
+#define ldt_init(m, k, su, n)		dept_map_init(m, k, su, n)
+#define ldt_lock(m, sl, t, n, i)					\
+	do {								\
+		if (n)							\
+			dept_ecxt_enter_nokeep(m);			\
+		else if (t)						\
+			dept_ecxt_enter(m, LDT_EVT_L, i, "trylock", "unlock", sl);\
+		else {							\
+			dept_wait(m, LDT_EVT_L, i, "lock", sl);		\
+			dept_ecxt_enter(m, LDT_EVT_L, i, "lock", "unlock", sl);\
+		}							\
+	} while (0)
+
+#define ldt_rlock(m, sl, t, n, i, q)					\
+	do {								\
+		if (n)							\
+			dept_ecxt_enter_nokeep(m);			\
+		else if (t)						\
+			dept_ecxt_enter(m, LDT_EVT_R, i, "read_trylock", "read_unlock", sl);\
+		else {							\
+			dept_wait(m, q ? LDT_EVT_RW : LDT_EVT_W, i, "read_lock", sl);\
+			dept_ecxt_enter(m, LDT_EVT_R, i, "read_lock", "read_unlock", sl);\
+		}							\
+	} while (0)
+
+#define ldt_wlock(m, sl, t, n, i)					\
+	do {								\
+		if (n)							\
+			dept_ecxt_enter_nokeep(m);			\
+		else if (t)						\
+			dept_ecxt_enter(m, LDT_EVT_W, i, "write_trylock", "write_unlock", sl);\
+		else {							\
+			dept_wait(m, LDT_EVT_RW, i, "write_lock", sl);	\
+			dept_ecxt_enter(m, LDT_EVT_W, i, "write_lock", "write_unlock", sl);\
+		}							\
+	} while (0)
+
+#define ldt_unlock(m, i)		dept_ecxt_exit(m, LDT_EVT_ALL, i)
+
+#define ldt_downgrade(m, i)						\
+	do {								\
+		if (dept_ecxt_holding(m, LDT_EVT_W))			\
+			dept_map_ecxt_modify(m, LDT_EVT_W, NULL, LDT_EVT_R, i, "downgrade", "read_unlock", -1);\
+	} while (0)
+
+#define ldt_set_class(m, n, k, sl, i)	dept_map_ecxt_modify(m, LDT_EVT_ALL, k, 0UL, i, "lock_set_class", "(any)unlock", sl)
+#else /* !CONFIG_DEPT */
+#define ldt_init(m, k, su, n)		do { (void)(k); } while (0)
+#define ldt_lock(m, sl, t, n, i)	do { } while (0)
+#define ldt_rlock(m, sl, t, n, i, q)	do { } while (0)
+#define ldt_wlock(m, sl, t, n, i)	do { } while (0)
+#define ldt_unlock(m, i)		do { } while (0)
+#define ldt_downgrade(m, i)		do { } while (0)
+#define ldt_set_class(m, n, k, sl, i)	do { } while (0)
+#endif
+#endif /* __LINUX_DEPT_LDT_H */
-- 
2.17.1


