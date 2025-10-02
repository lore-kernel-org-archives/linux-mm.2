Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E520CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5AAB8E000E; Thu,  2 Oct 2025 04:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10158E0008; Thu,  2 Oct 2025 04:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC228E000E; Thu,  2 Oct 2025 04:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72CD88E0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40D341DF71A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:14 +0000 (UTC)
X-FDA: 83952459108.10.5191E4E
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 545D8A000F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=XYvLnFU7p4k6RdXHiiqjPg2FVqRQ+ke3blM4eEqwJHs=;
	b=YFIwkBIq5/EfI4C/9yLUry2fO2HwOBMPZm0oAJEiZfEK2vfOK+3+3X4Y65sEIPdxgGfOwR
	pmjIOTH4uIUm5bk5Ylz0Zfvl3nlFZIGOLBCxzGOqXNy8ogVN3Rf/JtB3Ni/O5/RT6i8wvG
	NiMpdUnrdsJt7E8kSqrs3dZ8VK8DHsI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392792; a=rsa-sha256;
	cv=none;
	b=5cjt5MoUt3UcHR8jMFX90LFXwAA5+mmh4Ofzh3R6Ga44zknau+hZDLpN9AEUZXUKos7W8I
	DrdwSGEynCbmvzYTPAbAvkMFLe+cg5gjyuDYZzmUjkAXggVqchQ+9HiV2BRc+9rd8iOmne
	rFqeAZH9TG6hI/8hI5UhrCta1nQMl10=
X-AuditID: a67dfc5b-c2dff70000001609-7f-68de340b4270
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
Subject: [PATCH v17 03/47] dept: add single event dependency tracker APIs
Date: Thu,  2 Oct 2025 17:12:03 +0900
Message-Id: <20251002081247.51255-4-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTH99yX5146mtwVEi5g5tKkWWJEx4J6El+izsQ7li0j+2Cic6PS
	m7WRF1O0WoMJCnVEnTZdwAnGQUc7giC1HYuAHa92ZvWFKmpRaCmBGlMKRtsS1NK1Gr/9Ts7v
	/M+XP0vKvHQOqyk/KGrLlaVyLKEk4fSWvPQCn/oz988I6uwXaPBH6xAsvm4iwdCToCBucjEQ
	WXrCQIPHRMJL2zKG0PALBPWBGQznnx2nYMF6BsGzGzsh7O+jITH5lIBHsTkE1pllAmYGksHx
	hv3wu9mR9OtHEbQEJkn4y+VD4Gw7gWHW2E3CWHQBQ9hzkYB5G4aaP7ow9Ez1MnDZ/jX4rUEq
	+QlDw9UsaDpfQ0B9Zx8BS9Z2BqzVCphua2TgTSAfEs0VcCV8l4ZQ0ITBPn4DQWQsQEDLyVYK
	LlyawFAXjyBwXZsm4H7vRQxnbN00+DoSNFQ3LdIwOuCmoeuplwC36yYFlkceAgJTXhoct2+R
	EDubC17jLILOeTOGX+eDCEIxK7lVJSwazlJCu+NvQjDci2Oh41IHEl6/MiEhYqkhBYMxOQ7P
	LZCCxT2HhVfRB1hwxpop4T8zL/Q0TjJC7T+PGaHZfkioHQnT367dLdmkEks1OlG7dkuxRP3S
	00UeuMUfMftsVDVyZJxCaSzPFfD9z+30ew6F6nGKMfcp7/UukSnO5D7hHb8E3zok517BP/Ss
	TnEG9yXvv7OMUkxxCt7u7E/6LCvl1vH+c7p3kSv5y7aBtzFp3Hr+fsBNpViWVAwLtcQpJEk6
	f6bxzpvPyXcH2fxgm5cyImkz+qAdyTTlujKlprRgjVpfrjmypqSizI6SfbMee7PnGnox+t0Q
	4lgkT5eOKibVMlqpq9SXDSGeJeWZ0uK2CbVMqlLqj4raih+1h0rFyiGUy1LyLOnnscMqGfeT
	8qC4XxQPiNr3W4JNy6lG/J7oY1+dyabp3Le9oHXV90UlU4odwTsm2uKZ/ULlLOJ2b9w83bLB
	ov+mRKffC7ragULZ6ZOUudWSt4netWt+JPFvdlFv01jVlHEp6+65lTW6wrmv2qsUqwcbPx4f
	z/vtQ0apEbp/6Cncvu34zvi0zDITzR38SHXdEbpa1O9iiuVUpVqZv4rUVir/B12Cq6xrAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0wTaRSG/Wa+zgzVmklFnaiJpgZ1jXiJtxMv626ykdEEs/5Rsz9WGpjY
	hgKmxSpuVG51iatSaloi9VJxHQmgdFtQkVYRtVEBteKFIKWi3SICkmDBAIXa7sY/J8/J++TN
	+XEYUl4nmcOoM7MFbaZSo6CkWLpjY0Hi1DVdqpW991h4ndeIYThUhOFcTTUFRY6zEnh+vQqB
	f7gIwddxKwmG+giGCZOHhtDoWxoibg8Ci9dEQnVtHgFf7JMU9N0fQmDuDlBQ2puHYVA8iaAs
	aKWh92ESDPgbJBDx9RDwZqQfgRiYJCDQ+CeCCUs6XCx3UjDe+oyEUvNzBJe6fSR8tEfDWk8X
	AndFPgX/GutIaAtMh5fDgxQ8Nv9FwYD3HAGf7RTY8t0SOG81ISi4XEOB5bwDQ/272zR4+8IE
	dFpMBFQ5ksEvBjE0G8uJ6H1R65/ZYC0tIKLjIwHmaw0EjIqVNLRc7sQg5iaAtbVNAu8rymgI
	d6+CiC0LPFU9NPiKzRiuDzyT/GRG/FfDacxXOm8QvOHFBMVXX6hG/PiYCfGhKwUkbzBG1/v9
	gyRf6DzIX2nup/ix4VcU7x6xYf5JOceXtCby9WU+mi+800H/uuE36aY0QaPWC9oVP6ZIVV+8
	NeT+Fu5QeZcd5yLnjBMojuHYNVxfn5mKMcUu5trbR8kYx7MLOOepoCTGJNs8j3vtXRbjGew2
	zv90EsUYswmcw3036jOMjF3L+Yv1/1fO56rsjf/VxLHruLbuZhxjeVQxDBYSRiS1oSmVKF6d
	qc9QqjVrl+vSVTmZ6kPLU7MyHCj6TOKRcMktFGpLakIsgxTTZN4En0ouUep1ORlNiGNIRbws
	paJTJZelKXMOC9qsvdoDGkHXhOYyWDFbtn23kCJn9ymzhXRB2C9ov6cEEzcnF8lOeUKrwyNT
	Uj/15LjCtl8in7eU/f6JS8QGVzDu9NDOw7OS5zXksX+7Zpae3PzDh4naM62LAkl/3HyUnD7y
	puZidseerh2J/LFd09r1Y66sRWd+Vrd0zH28dGHJhiV7HxxRVBav77yZuklMEm+lwfGgyyge
	FZ5c3fJqKL+3rmSrBiwKrFMpVy0ltTrlN9U1ZkpIAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 7g8wiahym8op6uk36wigfda1wn1qw6gy
X-Rspam-User: 
X-Rspamd-Queue-Id: 545D8A000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392792-481540
X-HE-Meta: U2FsdGVkX1+mD289bX7DtyVLNZ8B4PhUW4lmbSmookXB0JNILsHSrP/LAKDtXw32aOXJtM7twI9OW/Bil7sZJioXT75Gj/VS5x4usrQuYN3zOnR35hIngp8dZ4xJ5UW3eRCwPqFj3C+2rEEeYSRStUchapTulhJ6auDqTIX6aPJOhcyy+e0F4rromxvKnPdK4ZnINWy46DGxFPyjXdTPW3t6NwyTXvkRZveCE5gpoagEulFsxGcCLHDTDnrUndZr5r857XKK3PD7ikxG9cVHypvzL3JxjfPR/JnnxzvS3iQfjJiMS7yHC0VEwSxtwVN3+U17TF0Dw4qALIx5zkMwZ6wOY56r+Kldq9L+DsDXVIvie+z3tNWJ6VAKfgSWADeF/rLB+UpY1ui+P/pJzet8yPdBYdfM0JsbrtGGe9kaw/NI6Yba7MVnBpZOLUmsbwgvUz/40mGFHriQ4xRxRxljp2jYaDr9ecDboYpYyqdQ6sz+dH35sfM3tmxchFljX+tfMsgjHe1G+CUGf7ZHg97j/WWh3vlcNOUhwm2ekRdDMz8+0J3WofL1Z0KN1rWtziXPQdEMjvbVsgTl1Aw/B3sxj80lsZQl3gGuf4tPiFoexcTbA1DUHILdwYffDH2Ty60w90wozitMRG/ckwLSuX2lDlpVyJL39T+EGCxTzcwzCBIgAjhjxI1c+kVwrA8Aqm4BcUqL6J4Bv9x77wohboJbLpaSDN3Yoi6tyyZ8FSvU8/UoJJ9SRenQjOUghnvRq42uNbIiVQLseJltIK3xQYWNIuEE7U5sLdO05r+PbbSV9O5NwUE4WpHPAeETRRRhyvotkZQwk1BSSUozBgZaKHxKoxSuA1LwoCdlFcc0dNht5vpfed7VipB12r2ac3yUlXEQ2wSTEO2h1xgTJFWGAoE/4A3Ykhd4ZOQlYRP6YvN7ioVrDRSeAvVCo9z5AmrvMLUQmlwCrxGxMtgZoC8d/Wq
 uO74Qlg+
 qnM+AmivqV5heCxOv2wfFYm9ZY4CKdwcsoCm4/Tfj5BgNKNBX+AdLsIKlTBqsI/qw0UOW+lZKYcr76COh5eMunpyvBE50St7HbDK2PS1/IufJB5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wrapped the base APIs for easier annotation on wait and event.  Start
with supporting waiters on each single event.  More general support for
multiple events is a future work.  Do more when the need arises.

How to annotate:

1. Initaialize a map for the interesting wait.

   /*
    * Place along with the wait instance.
    */
   struct dept_map my_wait;

   /*
    * Place in the initialization code.
    */
   sdt_map_init(&my_wait);

2. Place the following at the wait code.

   sdt_wait(&my_wait);

3. Place the following at the event code.

   sdt_event(&my_wait);

That's it!

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept_sdt.h | 65 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 include/linux/dept_sdt.h

diff --git a/include/linux/dept_sdt.h b/include/linux/dept_sdt.h
new file mode 100644
index 000000000000..0535f763b21b
--- /dev/null
+++ b/include/linux/dept_sdt.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Single-event Dependency Tracker
+ *
+ * Started by Byungchul Park <max.byungchul.park@gmail.com>:
+ *
+ *  Copyright (c) 2020 LG Electronics, Inc., Byungchul Park
+ *  Copyright (c) 2024 SK hynix, Inc., Byungchul Park
+ */
+
+#ifndef __LINUX_DEPT_SDT_H
+#define __LINUX_DEPT_SDT_H
+
+#include <linux/kernel.h>
+#include <linux/dept.h>
+
+#ifdef CONFIG_DEPT
+#define sdt_map_init(m)							\
+	do {								\
+		static struct dept_key __key;				\
+		dept_map_init(m, &__key, 0, #m);			\
+	} while (0)
+
+#define sdt_map_init_key(m, k)		dept_map_init(m, k, 0, #m)
+
+#define sdt_wait(m)							\
+	do {								\
+		dept_request_event(m);					\
+		dept_wait(m, 1UL, _THIS_IP_, __func__, 0);		\
+	} while (0)
+
+/*
+ * sdt_might_sleep() and its family will be committed in __schedule()
+ * when it actually gets to __schedule(). Both dept_request_event() and
+ * dept_wait() will be performed on the commit.
+ */
+
+/*
+ * Use the code location as the class key if an explicit map is not used.
+ */
+#define sdt_might_sleep_start(m)					\
+	do {								\
+		struct dept_map *__m = m;				\
+		static struct dept_key __key;				\
+		dept_stage_wait(__m, __m ? NULL : &__key, _THIS_IP_, __func__);\
+	} while (0)
+
+#define sdt_might_sleep_end()		dept_clean_stage()
+
+#define sdt_ecxt_enter(m)		dept_ecxt_enter(m, 1UL, _THIS_IP_, "start", "event", 0)
+#define sdt_event(m)			dept_event(m, 1UL, _THIS_IP_, __func__)
+#define sdt_ecxt_exit(m)		dept_ecxt_exit(m, 1UL, _THIS_IP_)
+#define sdt_request_event(m)		dept_request_event(m)
+#else /* !CONFIG_DEPT */
+#define sdt_map_init(m)			do { } while (0)
+#define sdt_map_init_key(m, k)		do { (void)(k); } while (0)
+#define sdt_wait(m)			do { } while (0)
+#define sdt_might_sleep_start(m)	do { } while (0)
+#define sdt_might_sleep_end()		do { } while (0)
+#define sdt_ecxt_enter(m)		do { } while (0)
+#define sdt_event(m)			do { } while (0)
+#define sdt_ecxt_exit(m)		do { } while (0)
+#define sdt_request_event(m)		do { } while (0)
+#endif
+#endif /* __LINUX_DEPT_SDT_H */
-- 
2.17.1


