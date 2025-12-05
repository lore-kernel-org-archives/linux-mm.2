Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FE4D2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9F66B00DD; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5DF6B00E4; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3326B00DA; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0339B6B00E2
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7B22C04EF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:57 +0000 (UTC)
X-FDA: 84184568034.09.809A2BF
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0F21340003
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=JOxBNktyZFvCF31z3+r/KI9OIK6nf/pK3sNLcyuBTMc=;
	b=QVND2OyRoJJ5W1keLPUUeQSrN/o5KRMXj1ORGJZqamLKEDT69zzcoKZRTTTIt9BTvGKC7h
	A3vSJq6hML9Rj79tIxqR6UOTZqikzpzPpvwNEV12RjHozFlmA01YOomrts405REloBn7G3
	7jSFvVoOKyyxczl+nKExhOTEXgYbFoo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919196; a=rsa-sha256;
	cv=none;
	b=DbIL5Kvx/ZaMpJY8bK5BwrbAnFHMtrrA3Le1x5YvzyemFELk4EhDPHGwwu7yzgeO52WlrH
	wukMFcv9ShtzVwcPSTuBvjGCcuEn0pbaizjsuHveMqSXcmoHvo4y3izOdRiXcB71zKpY4L
	mjkG3vYn6xXErhnHGHxEK0KCqn2o3Hc=
X-AuditID: a67dfc5b-c2dff70000001609-46-6932876d3fac
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
Subject: [PATCH v18 11/42] dept: apply sdt_might_sleep_{start,end}() to swait
Date: Fri,  5 Dec 2025 16:18:24 +0900
Message-Id: <20251205071855.72743-12-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSe0xTdxQHcH/33caau07nFbNgmjgyEhUIW062SUj2h3eJRhPjP1vm7OCm
	VMsjrfKY2VYI0NIhKlhNaFQeo5q2OlYkg+KQR4oCthK6YlXKYzNVpNSsFBAQa6nxv8/5fnPO
	X4fBpY/IBEaZd1JQ58lVMkpMiOc2Nu7K1aUpU+5OJoG+4ldYiOgJuPewjICRm1YEkwt6BEur
	JhwqOqMErNUO0GAsRTDbH0bw0lyNoD5gomHGuQ/WLp6Av6+XUeB5uglCrRR0TjlouDRDgfFG
	FwbLZgsNJpeHhGhDPgxYn9HgP2sk4ObcAxL+0k7REPlnGgNbdQAH/VoEwUDHvxhUt7aTMGGL
	kjBqHSHgiessDdNTPhLaXPdxuBFqoqAuFEDw6FKQhtLeZgIC3koM2u9UIAj/vkhA5fwbEnTP
	uyhwmdwkjNe8IKBbP4XBH4F+HOy2MQqe1V/GoH8hiMGQf56GutEGClb8HSSM1V6N6ZoTwdDK
	EAbG13oKXrX+R8LlSCpErBYKTM4JOjOTt12xIX51pRbxFediKm8r4luGgxTfWe+n+fLuxzTf
	YD/FN9+ewfjHs3t5u6WK4u3hWppvXH2O8+Njtyk+5HbHRq0RP/Txt+KvsgWVslBQ78k4Js4J
	T3vJAidT7Gtx0FrkpgxIxHBsOtdjvRAzE3eVd/96TLFJnM+3jK97M7uDazsTIA1IzOCsJ5HT
	LdfEiw/ZA5zH8gatm2B3cn++chHrlrCfc31jdfi7+4mctbUnblEsNz5ciVvKfsZdNSzFj3Ks
	VcRNVj2l3y1s43qv+4hzSNKANliQVJlXmCtXqtJ355TkKYt3Z+Xn2lHs4cw/v/6uA4VHDvch
	lkGyjZKeolSllJQXakpy+xDH4LLNkqAqRSmVZMtLfhLU+T+oT6kETR/azhCyrZK0xaJsKauQ
	nxROCEKBoH7fYowoQYsUXyffMh5dHvGaRdTExfYfE427PlKcnna+DG7JNp/+kkg7Mtyf0TXz
	aWVmt87bq0DRQ/dudSnc6aYrGXc/GRw9v8fywt9Tklb6zZnQL4Mt5aN1sqxhUcIHji1Rz3zz
	0hfnE/4/5nAcT3li4Ejdbw+avj+8uElDau4cTJozaDU1lVtlhCZHnpqMqzXyt9u+Re1sAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxTG/d93OrtcK5EbHdE0mewNB2awY0YW/eSNGYZEE5LFqA3cwA0t
	Qqu8Jdso2AGdI1DTklERRNswQIEWhsg6mzqYwBCwvFQHK2wdGwHFIK+FgoVkX05+5zzPkzwf
	DoPL2sn9jJh+WVCnK5RySkJITn9WGKkqOipG9dowKNZ9A+NeHwmjWicBS4vFBNxoaqQgYG6n
	odj2AwmPxwoIGLzXgMC7VIxgZd2Mg65ji4CAoZuGxbU/aDBqEWw5uhGYhgw4eAYf4tDYqsXg
	dfMmBbOPFhAYp3wUVMxoCZi3XkNQOW2mYabrJLzwdpKwNfEvBmPLcwisvk0MfM4iBAFTGlTX
	2oNx0ysK1vsHcKgwDiK4NTWBw8LMJILW7j8ROOoKKPinrA0Ht+9tGF6ap6DH+B0FL4ZuYPCy
	mYKaAgcJQ7/PIqgyGxBMP3dgUHi7iQJTlY2AjskHNAzNbmAwbjJg0GCLB691moC+slosWDfo
	agkDc0UhFhz/YWC824nBmrWePm5B/IqulODr7T9hvO5pgOIbbzYift1vQPyipRDndWXB9dHc
	PM5ftWfzlr45ivcvjVC8Y7mG4HtrOf5OiR/jy/sj+Y7KCTrhxJeSuGRBKWYJ6o8/vyhJXZga
	ITO6mByP5QGdj55QesQwHPsJVzLyhR6FMBQbwXk8a/g2h7KHOPv306QeSRicdR/kitZKd4S9
	bDznrt9E20yw73Itq/3ENkvZWM41en3Hw7EHuYZm5w6HBO/GMf8Oy9gYrlq/QpYhSQ3aVY9C
	xfQslUJUxhzRpKXmpos5R5IuqWwo+E7WrzbK76NF90kXYhkk3y11ZkeLMlKRpclVuRDH4PJQ
	6ZwySpRJkxW5eYL60gX1FaWgcaEDDCEPk55KFC7K2BTFZSFNEDIE9f8qxoTsz0dvfX239KlY
	aYp471N3k3fZc+6MkLcrUec8G7WaKO/K+9ny23HpsL/ONyxWV4YnhDftaYH7rRl1ew9/S/0S
	09B1vs1r1Do/mqwKqz5QHmv/69fxwEjmY/rhOyVJkfGZNaqBiL8z9RXeDxf6evb8OD++75gl
	TsW/X/Us5ZALy0qYvdojJzSpiugPcLVG8QZ6wBFfSgMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F21340003
X-Rspamd-Server: rspam11
X-Stat-Signature: 56bznhpbr9htzq9wczro8o933g3bc7nk
X-HE-Tag: 1764919195-98980
X-HE-Meta: U2FsdGVkX18w5b6r0QsGA9ZwgqU6bz3M62uUy0edbkColTuaiFegUfiQMojm4VOmhlxxnax0q/OrFMH51b9YfFA31XAYH7A3JF42l/ykunhm0Uvr5y1gSjMPa7cOsiAUjI3FZi8LBrmWBh88YzGY0ll/iyAlbixYt2f5zEi48/d4E5YBjvlTAl1b7ggb8oWSelH5HHfmPivXzY4LTUL128E9rPjAw1jDlcuaxWHkwSk1sLM3Bl4GK6dxgC4Kh8DiIqEnwHZWaCNvgfAuD1YjnQ6exN5MzIjACJhTDg/P5i+VoXWZu63UE1SrRgQB9Ue2lkRLBedT/qDV8I2gxLtB05ZgmoRlc8F9pV5VrwUadryek1ssC1+JWI8D4iAkeCKLnvpfpIq1s7NOZn69CvS3q0otnF1WWD0r36BNGOW3SXmbtNWSdQEA9BQIKpUkoQWvVm1C8pBpodBeCPEAsUj4j6PZGQQ3qORmz4FNuEGMdKa92Ik3piH60j891wiXebxdLhGe2qUw0cagsKyAoeMmhxqxRWMK+fMoNIF8e0YUkZEkUJi8WpMfdHPlNDrMBB3xeaQ54RtxmHevOYSX0DWy6l3B/aOqquQE+bzSMe/FHiE78wLLLgdEc+SNAuOjrW5HnwOSJWE+IOgNEJPqBF3s4oGbY32noT7OZPL32+hP8LCfyazuQLJoSOEDC9Kfkg8jVimprRdIb5WIV9IhrE2EY/uI5azBK/TovpWzqkkB5FtdpUL/qf8NwHvZvlN9UY1dJ7fNvt8KTYuPQVO7pe+eGrKsJRrXlkZSdIbNq6EBysXY/SG3G3yDor1QFiHM1lWSFhfwXTZImj44AkvHw3G30/zulZ0hnlu78vtzmLeW5C6HthV5qVjM6BH9mCiGBOX/LUWtYyuCetXflcBUL9Z1m2168k6T7dML5yL6IVD4x9SziT3I7iETDkHeX+PlD0IOW6gYDGKk5URUreQv5iL
 nhvaBbNM
 1XxrsyGtoMzBHBNJZDL644vFW/ez2+1gFKCTILPrBmSdp2Su2g6G7ncogbMGNHxbQIqjz2NwRHEgwcY8XMEPiJhOX2AUErbO2G++p2hUPQY1/EMSlK1VhLmIi0LSZ229smhqjTHbUHO7W41yJahs3RmTyRD5E7sg/LEy6i+7fmp2e42o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make dept able to track dependencies by swaits.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/swait.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index d324419482a0..277ac74f61c3 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -6,6 +6,7 @@
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/dept_sdt.h>
 #include <asm/current.h>
 
 /*
@@ -161,6 +162,7 @@ extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
 	struct swait_queue __wait;					\
 	long __ret = ret;						\
 									\
+	sdt_might_sleep_start(NULL);					\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	for (;;) {							\
 		long __int = prepare_to_swait_event(&wq, &__wait, state);\
@@ -176,6 +178,7 @@ extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
 		cmd;							\
 	}								\
 	finish_swait(&wq, &__wait);					\
+	sdt_might_sleep_end();						\
 __out:	__ret;								\
 })
 
-- 
2.17.1


