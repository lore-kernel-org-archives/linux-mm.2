Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1086ECAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9EEA8E0019; Thu,  2 Oct 2025 04:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50258E0007; Thu,  2 Oct 2025 04:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDFE88E0019; Thu,  2 Oct 2025 04:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99B648E0007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A76C13AC04
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:39 +0000 (UTC)
X-FDA: 83952460158.30.7C50C5B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 72145A000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=JOxBNktyZFvCF31z3+r/KI9OIK6nf/pK3sNLcyuBTMc=;
	b=wjQvUOjlFRX76N9e1ooD2npv+/y/RJoBdT2XkrQ8Tp/14XnrE8YGaPBz6Dngs2y97we+Ak
	1+8Nr6Y0fufKFp3IEUJ/wAajRu2IoxHcH3sN897ABJbTqPjtuWr0GmJc8RNV++Sv5i5lhH
	6Vn9w5Refams239MpRmJ97l3AZbGxvo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392817; a=rsa-sha256;
	cv=none;
	b=cpkV6KboEmCo38n+xgRvD9ZX0JdrUpFalWOaROus8PbjbPZGK3/OLeVZCicny/XccpiIaC
	doYHDzKPdiXnwgjY4E4zw0qpPGYGus84Y9jJNO1aWKLe+MC2LUvrngvpW01etNEZ5hiUxY
	gHn307uP9jzsxkIyBRqC9YAcAy60ZUI=
X-AuditID: a67dfc5b-c45ff70000001609-ff-68de340edca2
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
Subject: [PATCH v17 14/47] dept: apply sdt_might_sleep_{start,end}() to swait
Date: Thu,  2 Oct 2025 17:12:14 +0900
Message-Id: <20251002081247.51255-15-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG+5/zPxdXi8OKOmqQjCKKMguLN5AKKjxdhKxPXaBWHtpyTtnW
	ykpQajavmaVF8xammK6sY4KXwmnaTdNNa+3D1GZpF7HI0rC8tCV9efnxPO/7PF9ellRkUEGs
	RmcU9TqVVknLsGxk3q0188P71GEf7wC4UuwYCqptNPz6YyXBXD+DYebxUwS2hykEjPQ3UlD+
	YZqAqfxY+HT/EoLBnFoSXo99o6HQmosgv1DC4ByeJOD6Zxry7jYS0FHqwXBvpIuCn6+9BFga
	xjBI710U9DQU0NBnm6Eg2fqLAoe9nYLuKgeG6o9uAsreOgnwvnNTMJ4dDI4rWT7TXkJASnMp
	horv1ykYepNKwLMsOwGptx8QcLW7hIYaKY+E3711FLhyi2kYyB5hwJw5wYA1JRtBhjkfg6V1
	nARrWx+zNUwwd0/Rgq3IhgRzjm9cebVGqL/Zywgl0imhpmKVUProMyFIlWm0II3mMoLH9YgW
	vnZ2MsLzG3+wUO/dJBS9iBb6M54RewMPyiJiRK3GJOrXbj4qU49631AJbewZd1kDk4w66XQU
	wPJcOJ+X3k/856LsQcbPNLeCd7snSD8v5EL4mqwhys8k176EdzlXpyOWXcBF8VWVBr+MueV8
	6stayi/LuY38taKg2cSlfNV9+7+UAJ/c423HflZwG3jzt4u+VplvxxrAD0kSnj0I5Jsr3DgH
	yUvQnEqk0OhMcSqNNjxUnajTnAk9Hh8nId+LlCdNHqpDo479LYhjkXKe3LG8V62gVCZDYlwL
	4llSuVB+tMKjVshjVIlnRX38Ef0prWhoQcEsVi6Wrx8/HaPgTqiMYqwoJoj6/y7BBgQlo7wo
	9eGyRaS2JSI9pPZC2rbtiyy70JawZXgqejq01TM9fNKpP6ZL3me61KHfnRUaPHZvXfCT7p3F
	yBTl6mEyI68NJZGBX4ymucWWet2BHcVdZk/TZfuFHwPQKt8YEtG0p80Y+9ZSELb2Z3XXBDIa
	4ycz2UiqMENded55buWhnUpsUKvWrSL1BtVf89Lohh4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+7/3LZcvy+jNimJhiand49CNvvV2t6gMQXTVWxvOWVuZGpI2
	Z3a30Sa6sqU4zJm3aWRmiJVUy3RZJuW0hZmSJngL89ZW9OXwO89zeHg+HAaXVpL+jFJ9WtCo
	5SoZJSbEezbqQmat7VCs7MtjoTW1joCR4QwCbpcWU5BRkU1Cc4kNQedIBoJf42Yc9NXTBEwa
	GmgYHvtMw3RtAwKT04BDcWUqBkNlUxT8eDaIwOjuoiCrN5WAAetVBDndZhp6X2yD/s4aEqZd
	3zH4ONqHwNo1hUFX3UUEk6YYuJtnp2C8sQmHLGMzgntuFw49ZR6zsqEDQW3hBQq+ZVbh0NI1
	C96PDFDwyniFgn7nbQx+llFguVBLwh2zAYEuv5QC050KAqq/PKbB+WMCg3aTAQNbxW7otHYT
	4MjMwzz9PFflc8GcpcM8owcD44MaDMasRTS8yW8nwJoSAObGFhK+FubQMOFeBdOWOGiwfafB
	dcNIQEl/E7nViPhf+usEX2R/iPH6d5MUX5xbjPjx3wbEDxfocF6f6Vmf9Q3gfJr9LF/g6KP4
	3yMfKL521ELwr/M4/mZjCF+d46L5tKef6LANEeJNxwSVMl7QrNgSLVYMuj+QJ18wCW0Fj+kU
	9Ja6jEQMx67lcq9/o71Mscu4trYx3Mt+7GLOfq2b9DLOOhZwrc7gy4hhZrO7OVuR1isTbACX
	/rqK9MoSdj13K9f/X+IizlZW9zdF5JFb3A7Cy1J2HacfSMMykdiCZhQhP6U6PlauVK0L1cYo
	EtXKhNCjcbEVyPNL1uSJm4/QcMu2esQySOYjcQa4FFJSHq9NjK1HHIPL/CTRhe0KqeSYPDFJ
	0MRFac6oBG09ms8QsrmSHeFCtJQ9IT8txAjCSUHz38UYkX8K8v05Idku7l+9+bNF9/VAdnpr
	eGNw2JaIofPzZgQNhvkcj7xFb+yt25VwP5ixD21flPT8lGZJTE1IunvBwf1zXkp2Ipv+Y4+6
	0KaeLQ0NrTycnp1kEPmEJC9dPjoVeGnvUGSg6NDDt8nnjjhUHTOj1lw5saN9oc/KXcpyX2R6
	si9JliAjtAr5qiBco5X/AYx6uolHAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 65u4jmnzf77txw9w9akgyaced6tayscx
X-Rspam-User: 
X-Rspamd-Queue-Id: 72145A000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392817-266647
X-HE-Meta: U2FsdGVkX19s7ACd9hx3BWYYD/N50Uq14n72qs2LyIQwHLXpYZ6JME2Wl7tcO6ktNQsdp0NrUTuPGB/eVgTe9DLu8iArxLmMzgbmZQbjQZ/vtx8qCdm77I/0GUV1wW0EGuZr+NZtTZ8Va4ubX4Wo52/fbGVKQ9HGIqQuDYrikfjcOPk3+wLO+tOLpmi7BToS6W9vq5sewm/W17haC2lzMv+Y2DMrFC6NVzX9Aub8LAdWN1uYxHAMlxdyyDrbUlMjdOPjBIlIA1gqKWypMq9vlmMP/ZHPFTZBI7TfBFckbfss957wgXBM0wAJnfxZF+9EAuWXrmEeIsrwVrwIc+oyLlulaPSJVr9nAUHLvu6b/3oSgfwOey0FLf6t3c7pOm1wRMELH9E5oKL1IWAC2myrXeBsgWgAROIvQzXFxlVWRh3g21xm/mu+H1p8cOW4K4VbyvHPnFl+7ctEaBtxVqk1h6evYibp0aEJGO1yRqWXWf9MVqdHgCxv+BlzKIijRmjXJnRAkjrtO1AcFKGcqNU0MSbZngbx9Tbtdf60IG6c8OVm+CnJ6P1OM8uFaSj2W55DYkDgnE6kiyMWeBLlKuSsrNtXszfQARUieUJL8MTqgQ5/03wawNjUDTWFyhnVQQIrXR6Ki2fbXbcKHu6yjBbZq3wbTsvfgbnAEQ5e7bqV6e6IzGw+6gAaWed1Cr5EVscqeA9q6Ig0ernstbKLhKLrdsi54wF5fSww/1NI5UbhCE3hgi/n+lSouz3opfUxiaAVhY+CSgFCq/k1Alk1hKOy7degd/Z5UqeBZQxDeRYIrmyONtok0hD/MNZXE4n1id85kXL95KdjMMsZaKpVDIScV2xjBspgyGXKPN7WQxDPNo+TPY0Y9tW8hitkwX0EUogRlytzVGi/OWNAFehibr721LdkkwfLWiXE4tMex8H06W9ZwbngtpqYfqjwomBVXjjCmk/vjwjmiEjYWcCWkC7
 8W1bT+e6
 RQg4xmV/keM5KB+fxfb9m9EKe1wdqE3QIx4DoBmSHZcYuflIdJTjkkqJcGjpQR35yjjiyqThccfuly6E6SI+KBBfQeoxS+bEm8YWh7z6+FJeKr6ayn2SrOp6wsSDvZcJGKvHXTo/q3CPU2Uu2PRhuQGqV2ms8kMLSxKR0MwLXjbq6BVQ=
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


