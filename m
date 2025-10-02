Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07661CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B278E0023; Thu,  2 Oct 2025 04:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612908E0022; Thu,  2 Oct 2025 04:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C478E0023; Thu,  2 Oct 2025 04:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4A88E0022
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D83A81403A5
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:59 +0000 (UTC)
X-FDA: 83952460998.05.D9EEA4A
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id EFCACA0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Irf3Oyph52vEG30MuAN438PQS/OMGYpARnTVIzgPmmQ=;
	b=5fde1VJiAVfA5IueFHVjtwhfK7coOOocdA2OuIfZavpJAwH/QOMenzU3B8Zx6KB7x/2nWx
	PNuJF96YoKqpyKFf3ZuhiSfJhaU/rALFFz9QVWthgkrrOJyRKVR7fjw2Dpp7hxDb+MVI8u
	Z1AC5++OlsyFxp9ttpvAJkAtAN9zRFY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392838; a=rsa-sha256;
	cv=none;
	b=E0wPhvKG8qO4O6eINboXqiSSag75gdale0B0Axf7efMGEt6ks9vg5isVbslmhDOjy9igqG
	8LGw8deRiiBSlpkcpM5Q30lUVV5ZvFJIOrupZ6xNqnaGBdMA+0a9MYox3EJhUT53poxH18
	OLXEJzxTq1cvmXAtC8kT3HDxB70Fkq8=
X-AuditID: a67dfc5b-c2dff70000001609-2e-68de34100f44
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
Subject: [PATCH v17 23/47] dept: apply timeout consideration to dma fence wait
Date: Thu,  2 Oct 2025 17:12:23 +0900
Message-Id: <20251002081247.51255-24-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0iTexjH+723vVutXpfRmwanM5LCshsWTyGdiOC8cSCiIugCtdqLG95i
	y1sQrJrd9ISN4zo6081w2VxZM6isgUmtbEmbq7VqmivRRNfF5kRzrVerfx4+z/f3fb7P7wc/
	Gpe9JpNode5hXpOryJZTEkISnmFJS0jvVq3ouJcM1U12Ct6OnEYw+s2EQ8mdOAExg0sEkbE3
	Iog7XQiMXgMOFaFeCi4MHCPgk7UMQVWfSQQDD/+G8Nu7JLyMDiGw9n7HoLf1FIKYMQtq65oF
	f4UHgSXUhcOH64J+09WNoL2ilALzcScJF00GIfyigwDv4AQGQaMBA3d5HSasocB4Yy6YLpzA
	hPIBgzGrTQRPLwUJsOpSwNThI2EitBJcjf0iuBZ+RsJgn0F4xqOTJNzS9YjA8eohgsjzEAb2
	sj4cHO/9JFTWBCk4HYsg8LVUU9Btj5OgM42S4Gl1k9DZ6CGgqT8gXMH1mID2qisEPGu5SkL9
	Sy8GoZ4ACdFzyXD1Yx0Fg1ErvkHJlXTGKM5eY0fct3ED4iL1J3CupFxox0deUJwzaia4J3Us
	d74jjbtT1SXizI58Tv8gTHLNDancpXsDGGcZHiE5h+0MtXXxbkmGks9WF/Ca5ev3S1S37o7h
	h3x00RNfBNehRtFZJKZZJp0N6ALUbx7yfJnSKWYRGwiM4ZOcyCxgm//tIycZZ9zzWb936STP
	ZrawTV9Lp2YJJoX1P2ia8kuZNex/+pu/8v9gG6+3TuliQfeF3MQky5jVbMknPXYWSQSPScyO
	hOPYz4F57P2GAFGOpGY0zYZk6tyCHIU6O32ZqjhXXbTsYF6OAwk/znp0Ys9tNOzZ3oYYGsln
	SD0pXSoZqSjQFue0IZbG5YnS/Q1BlUyqVBQf4TV5+zT52by2DSXThHyudFW0UCljMhWH+Sye
	P8Rrfp9itDhJh/Dx/EKb5B9t/872yoUNSXQhM1S/JLXquyUvetA6b35WNauObP3Mx9QHFqT9
	Zc5z1hatlSX2OPm9CfFh/59+YyXTmZGZuW3T5tJ34S6xbdZm/cY5mxQZyv9nmqWndoQZ2y7s
	2LoyL155PzNB31Irf/fZfWTLRI3FPLrtcuLT6UE5oVUpVqbiGq3iBwsd8xhtAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+7/XuVq8LMW3C1QDKSKzION0pcsH34Qi6ENRoI58a8Mrm1kG
	kTpXll10tUlOyyyXOM21mbVkYquMNHVrZVJOmy2tnNllJqZmm9SXw+88z8Ph+XAEuLiBXCCQ
	p2bwilRpsoQSEsLdG1WRzNpe2WqvYz505TQTMOrPJ6C0roaCfPNVEhx3jAj6RvMRjE3ocVBb
	pwmY0rTQ4B9/R8O0rQWBzqnBoaY+B4Ofpj8UDD3+gUDr8VJQ/DmHgBHDeQQlA3oaPj+NgeG+
	RhKm3YMYvPnlQ2Dw/sHA23wGwZQuCa5XWCiYaO/EoVjrQHDD48bhkylg1rf0IrBV5VLwsfAe
	Di7vXHg1OkLBc20BBcPOUgy+migoz7WRUKbXIFDdrKNAV2YmwPr+IQ3OoUkMenQaDIzmXdBn
	GCCgrbACC/QLpO6Gg75YhQXGJwy0tY0YjBuqaXhxs4cAQ3YE6NtdJPRXldAw6VkD0+Vp0GIc
	pMF9SUvAneFOcqsWcWPqiwRXbWnAOPXLKYqruVaDuInfGsT5K1U4py4MrI99IziXZznGVbb5
	KO736GuKs/0qJ7jWCpYrao/krCVumstrekvv2XBAuCmRT5Zn8oqoLQlC2f3GcTzdJTje6vLj
	2chIn0MhApZZy/oc32eYYpax3d3jeJBDmSWs5cIAGWScaVvEdjlXBnkes5ut+1lABZlgItiu
	J3UzeRGzjr2SV//v5mLWaGqe0UMCusvTRgRZzESz6pE8rBAJy9GsahQqT81MkcqTo1cpk2RZ
	qfLjqw6lpZhR4JsMJyeLHiC/K8aOGAGSzBE5I9wyMSnNVGal2BErwCWhooSqHplYlCjNOsEr
	0uIVR5N5pR0tFBCScFHsPj5BzByRZvBJPJ/OK/67mCBkQTbK5S9uxroPl3TIJLMJa9SLvcrE
	+1k/uvfN3ryn9rTXNLB3u6WCNJK3dqw4cWhrf3x4QX9sxFTSw+F71cW+LUtxT/qzs/vLBsNu
	L47KHdpeH2dtCmuy23u/vquNS1F7x/aTB+N2xjwSr1dc/lDLnkqUbHN0DJU+Zb58WK4KMX/T
	2aokhFImXbMCVyilfwG1nG8USQMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: 3nfzxiqd4ijxjwnfoixrjb37ghw84iyu
X-Rspam-User: 
X-Rspamd-Queue-Id: EFCACA0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392837-371645
X-HE-Meta: U2FsdGVkX1+YJ3QzUtTJ+LZ3slKaJlw+/A56pzn4zOPKpm9jOLoohTeOqcAhAWeHW3rX54JkUPTxHy0y3SkAxp78mSeGbPMBp2HzmHRusl/Dpo6A3QVMfxzgBfr9yIhx+ZzI+EZU2rvalUdgWHkKoN/QAq47XXMeTxyugMxyOkYLd9qoqTPX8vfW39wyqV6W/tA1bMBIDhKHgsZfcDgXdcXxWqe5KYFYBkyeXSbn7DHts3FbFNWPezzkMn4DLMEhTeyucEAssNI9u9YRjbQyT/6rRvWzv1CzNgiT1NGTX+c/Dy0svAN8kArOeIfBEvE57b0+y0S9z8zb5razAkDeYqQBvOQTK8ZkZMqk5JdwQnLNt2y9BJxSFGDIoAJeqzvROhUmxATaaECY7wSb26RticdpOnR+XlNduGiywt6N4kyZuU17RsDerv/2EvC3/z149ZlZQ9srFiWDrdTO35XG1u28nGbKU0go24j1VeUYdXtcCe5ivlNbUH0P8FIP54w1Key+UrnVd/zKewj2fiQ++Nw4oU7gtRrIC2B5aNgQJaADCD1B4uCShszR65gOmZMRMyrS5AAuzp7Vrwmonr9WLYL+jUTixSPj8r3eDjTaw7+tt3n06+nBBsclT8Q4XVQTkwLmbGb9peEBzqSn6zfodiCe//lSQnyBJs+Q0r8BWAryVf16nPhZq18GOzOTJbhduTyjgwz9R18sEJaueCp8eCjZ3+WQPJi8rxzSc30DKgGVi3oXutWYl4Yby8MlYnfgWEOLO838RYCj/dMwtdoLvX1l/eMkZ4wGd8lpklH1qDAJ3p1pg85mekHiJZVYmYLnYJcoEKVIQyWvDeFEG6xP3STeNA2qd7m7IcK1Qe+PJCnqVrpFJ1VhiNxNNMMTeNaYZx927luFmz/IRUcyBkCfU1oN9oaoXeG7fS4NOw3REbjXOxNUEZPGhkWb6bZJc8ejP4UUi2eWnIy8rOqxjmo
 lwSQY88r
 9V7sD7hAttk4uLQdR7PO7ce39TVAGaVBGOLA1CryJjpfqGX0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to dma fence wait.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 drivers/dma-buf/dma-fence.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 787fa10a49f1..0a4b519e3351 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -801,7 +801,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 	cb.task = current;
 	list_add(&cb.base.node, &fence->cb_list);
 
-	sdt_might_sleep_start(NULL);
+	sdt_might_sleep_start_timeout(NULL, timeout);
 	while (!test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags) && ret > 0) {
 		if (intr)
 			__set_current_state(TASK_INTERRUPTIBLE);
@@ -905,7 +905,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 		}
 	}
 
-	sdt_might_sleep_start(NULL);
+	sdt_might_sleep_start_timeout(NULL, timeout);
 	while (ret > 0) {
 		if (intr)
 			set_current_state(TASK_INTERRUPTIBLE);
-- 
2.17.1


