Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C42CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6468E0007; Thu,  2 Oct 2025 04:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A802D8E001C; Thu,  2 Oct 2025 04:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA058E0007; Thu,  2 Oct 2025 04:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 245628E0007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC488B8913
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:43 +0000 (UTC)
X-FDA: 83952460326.15.A97B24B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0AB38A000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=2RZYJT4nXPz/0zunBSrL2ai9dkx+LO0+UPUASDTqCL0=;
	b=vbiS/5z9GpEREe4zqRn21/RTRuxznLErJ9eGOEOFzrTudOsMhI5TcY2v+MLrXSWrjiJZZs
	nsOeJzSVVYI/1V3f2fPJI9fVYK9UWRrnuQ4FSc7+Trx/l8wvtexUbaDixl1rNS7AAS7seG
	nPp+dD8JQMpCB9NEtxxlVnxnNE6CKAI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392822; a=rsa-sha256;
	cv=none;
	b=WFXN9zWgtdfe+B8FFF4RhrGwIVmeQXJEAOIp9Xi4Y1bFFGpiV3wjbORnzXo0GdLZ3ooz/d
	UBMkd0P1H3uuj++CQVIQVyuxXfVKoXDaOazpyrlzYtY/wJVX0/nNgg7s2Nnfk+lP8n9Jjt
	GJj9+Zp7lFk4OQpT9cKzkAXs9bdy8XI=
X-AuditID: a67dfc5b-c2dff70000001609-4e-68de340e4c85
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
Subject: [PATCH v17 16/47] dept: apply sdt_might_sleep_{start,end}() to hashed-waitqueue wait
Date: Thu,  2 Oct 2025 17:12:16 +0900
Message-Id: <20251002081247.51255-17-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTHfZ772sZu14J6fUlYmqDxDV9S3fkwjR+mufHDYuLUZMboVe5o
	QwHTIoIJDmFMYLixZpVYOlIlXLtygaaoExgJYwvDFEYRo52jlAoCCmhEcEFAvMX45eSX/znn
	f3JODkvo/6VWs+b0TMmaLloMtJbUTiy9vuVjY79pW0txArjqFRqK/FcpCNbVIIhMFyGYt7cz
	MDXzHwPKzYsYXvne0jD25yQCR3SIhvKnF0l4IZcicA5XMDARaaZgITyC4eHrcQRDrZdUgyup
	MNvVTUC5I4hg1KdKLZ58Gp6U3SKgd+gjuOv4noaJHheG5z4a3PktFDQONDHQMzaHISIPkxAo
	u47VUTRUlBdgNYxicNQ2Y5iRvQx0VvWRIOclQkVXLwWPPU4G5qLbYcGdAe01IwyEf3SQUDfR
	TUHk7+8o+C1vQN3nfhSDUjpMgH/wAQUtjzZB0fwUgvY7jzGU+m5R0K8sqFdoDVBQPxLCEGjv
	IOGu81cSuptqKah+2IMhOhCioKGrk9ibLPxf+AMpeBtuY6Hw3jwtKJUKEmbf2JEwVV1ACNWB
	cVpodIYZwe0/KzR4NgpVvz/FwrXJaUp4NLZb8HuLacE/aWeEa7OjxMH1X2k/S5Ys5izJunXP
	Sa3pZmcxOhNhs6uC9UQeitAlSMPynJF/O11JliB2kS95Po3JNLeeD4VmiBjHc5/wDZeHqRgT
	XGAt/6Bnc4zjuOO8XSlctCG5RH6wNLpYr+N28U0//4Le2yfwNb7WRV2j6r3RABljPbeTL3zx
	LS5BWrWmQsM/czfj9w2r+D88IbIM6dxoiRfpzelZaaLZYkwy5aSbs5NOZ6T5kfpwcu7csTto
	MnioDXEsMizVBRPDJj0lZtly0toQzxKGeN1JT59Jr0sWc85L1owT1rMWydaG1rCkYaVux+tz
	yXouRcyUUiXpjGT9kMWsZnUech0rHg35P3fp7ClKx7L8oVVo3/7cV6wv/pD2TcrRfmPBX4dP
	IVnM2VtbvmmNy1YfXpe7dv+JL0IRZ4Jcdz8u88I/3S+3bUldsmAZ33VPFk8plXRjn3dQd2D5
	ho6QJgJWfseNw0nf7JF3bzbykuvr2hXcT13ZaV9Ox1Xxz8kjLw2kzSRu30hYbeI7iuKwe2wD
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG+59zds5xNDmtVQcNioEU0TRB66UbRR88diMisQLJkYc2dGpb
	WQaRt6Gp1VpNyal5wTXm0qWz0poto1GZ6LJ7zrUyU9KE0sTU1hb05eH3XD68H14aF7cJwmhl
	+glenS5Pk5JCQrh3U74sNGZQsc55Qwavc50ETE0WEVDZbCWhqOWaAPqaGhF4p4oQTM8acdC2
	+wmY17somJz5QIHf4UJQ5tbjYLXnYvDT9oeEb49+IDD4hkgoH80lYMJUiqBi2EjB6OM4GPfe
	E4Df8xWDN7/GEJiG/mAw5CxEMF+WCtfrWkmY7enFodzQh6DW58FhxBYo7a5BBA5zHglfdG04
	9A+FwsupCRKeGkpIGHdXYvDdRkJNnkMAVUY9gvz6ZhLKqloIaP/YQYH72xwGA2V6DBpb9oDX
	NExAt64OC9wXWN1aBsbyfCwgIxgYbt7DYMZkoeB5/QABppwIMPb0C+CTuYKCOV80+GsywNX4
	lQLPJQMBTeO9gm0GxE1rLxKcpfU2xmlfzJOctdqKuNnfesRNNuTjnFYXsI/GJnCuoPUU19A9
	RnK/p16RnONXDcE9q2O5yz0yrr3CQ3EFne+pfRsPCzen8GnKLF4dtTVZqLA/P48yvfTp+r5m
	PAd5yWJE0ywTwxaaNxSjEJpkVrFv387gQZYwK9nWC8OCIONM93L2tXttkBczSazeqiWDTDAR
	7OdS37+9iFnPdlytQkFmmRVso835Lw8J5P2+biLIYiaW1U4UYDokrEELLEiiTM9SyZVpsZGa
	VEV2uvJ05NEMVQsKPJPp7Nzlu2iyP64LMTSSLhS5IzwKsUCepclWdSGWxqUSUbJ5QCEWpciz
	z/DqjCPqk2m8pguF04R0mWhnIp8sZo7JT/CpPJ/Jq/+3GB0SloOM00W+ut17u5J20bV84uj+
	a3cyYw/cP2TfUbxjT/aWqw7ZlYfhlD8ylI2yZfZ9rE2wrB7RbTansIna49VgOTUrOVfsrN8U
	vztsrWyJ6pk9PtnhStoWE/IkwoDbHqCDul1LNr56eXxR5868pdQxbvCdle2VnDerUhLGnDe3
	W9aXSAmNQh69Bldr5H8BWyT3Y0gDAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: ie4dxb7xxpx5aijn36g7dtskt5o78iag
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AB38A000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392821-696975
X-HE-Meta: U2FsdGVkX19+S+VOWiKUiQ7jw0GGl/tk5+dSo0tk5PPMmyEgC8sQQBJuQXI0u/dJ9mK+7RFS9o3eyv0KI5yevW9uxXTczoOX2oZERwBKnkRA1ujXgnyRNuwXPqzrStoAhC3nphx/4hAgAd8bU0BuovTEKHGaQwhIMt7gRDX4/nxkggkEU15OTUDqYXRflzwhd3d+gGYhhcCDslqNswOHjE4q7smv0hft/yYt+/glNEHwEq3tCwEOGv62emlMjj2aMaphNO+WGGGzYeJauiOF7Je5f2lCm034SiuyCA/4E27/Iag3W4Dusy3NQ345TWD2sukWhzq//pHqAmHNDkjQzyR2m1tlvaxdFfcY5b2+ZiV2SHNeTUrj8js3rfGN3/UuTsvhlXlbjNMizhKnDsMTYqzHxChjc/6U2/PwQe5vioALxbLWoRZXNucm7Z38ULQl+h0KPQ+RnSqwx6iR3zGeSSBbsysBcp5X+p4ob+Py1K7zyZCB7YpNWVEoN24E98X+F9PWGTlrFdIJOhPAryAJcL+UKgM07A3EbWd1JLfHvCr+/MBEepdUxaJvbMBq8mJ5dDOSokeZu6WOHgjyQ/ARbLKNiYZeaeJlaiWpnnfTVHiBIRDu06igm0696cOP7Q59CoXE6fIyRnsvfdfQLs8jVVoILfUrO/HeVmFNQb0sW06ggMTkx5n0HwOq6HDbg1fZmxP6hLToq9Z3J6gg1nNTVpfPWYXzjKTZzMxYfjQzNR+cOQdx6iVjJQFoUgRnb6lwkKyd3y9axKAWTDAz6ikZusZei8DK7GC7XLKK7EO/Y551GS1I8zWWjWVgJ7Vep82h+to+mayZuMIoO/nO0LZN1Xn19YaKd2juBOe3Gb+RzMjyUXFAOzAGEm5WhcPslrwqxDbe2vNb/kgHv4SxdS7UYQ0V1ymYdMh3xkRewUO1pQNf5csHBU5q2GjY+FH9PNlbAMeW4lCLrOTlH9XNtUs
 gL2dOous
 Z0rGNi1DmsBNLWuNUB9/2JXn3DRTnztOvEnDSeOuscljRuqD5+sN+GRQn8re+S4xvx9zYvu8hK5yzrW6AWTpHfBFRQ3hnYonU9Q+Aekzv5yBmVuGUTc9SlM0TNNCO2fmdwYxL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make dept able to track dependencies by hashed-waitqueue waits.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/wait_bit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 9e29d79fc790..179a616ad245 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -6,6 +6,7 @@
  * Linux wait-bit related types and methods:
  */
 #include <linux/wait.h>
+#include <linux/dept_sdt.h>
 
 struct wait_bit_key {
 	unsigned long		*flags;
@@ -257,6 +258,7 @@ extern wait_queue_head_t *__var_waitqueue(void *p);
 	struct wait_bit_queue_entry __wbq_entry;			\
 	long __ret = ret; /* explicit shadow */				\
 									\
+	sdt_might_sleep_start(NULL);					\
 	init_wait_var_entry(&__wbq_entry, var,				\
 			    exclusive ? WQ_FLAG_EXCLUSIVE : 0);		\
 	for (;;) {							\
@@ -274,6 +276,7 @@ extern wait_queue_head_t *__var_waitqueue(void *p);
 		cmd;							\
 	}								\
 	finish_wait(__wq_head, &__wbq_entry.wq_entry);			\
+	sdt_might_sleep_end();						\
 __out:	__ret;								\
 })
 
-- 
2.17.1


