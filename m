Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA0BCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9B58E0016; Thu,  2 Oct 2025 04:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6E98E0008; Thu,  2 Oct 2025 04:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639BC8E0016; Thu,  2 Oct 2025 04:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 442898E0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D4CD1A0399
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:30 +0000 (UTC)
X-FDA: 83952459780.19.8C8565B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38E3BA0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=7nMDaPuLoqZUrD0QHpXGn+/L3gdag8KL76f+z2/B7g0=;
	b=uBRuDBSDv0u8zIjOsJzr7fb8FStlknkE9wkBw/f+9l1PUB/OkQUBtiHx08bHIbuA877QrF
	i6NjqJscEFU00rhCamVvBN84w/jAKfSitCSkgf+KAuHvJGet2dcX2FkzsoIy9U7mTkPZSk
	4uQpDXiCN6tp6eIMu0ZSr9VplWloQ/g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392808; a=rsa-sha256;
	cv=none;
	b=cZcXG9cc0192d08jDxRwk1MXPnfBYIhw/1mSgy0G5oF61R4Ed2rQPU6EBJ/sErQOP72D3x
	rsbFAfDZlt1fXQrNDeozoYWSS0syPQLYicbvx353Od5Goww2YqldTJgJUk+JkA2T8hfPV0
	dDGNnHJfKTdyb6nHlm/uTo/jsjf2iy8=
X-AuditID: a67dfc5b-c2dff70000001609-52-68de340d2012
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
Subject: [PATCH v17 10/47] dept: distinguish each work from another
Date: Thu,  2 Oct 2025 17:12:10 +0900
Message-Id: <20251002081247.51255-11-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxjF97/3f+9tG2vuKnN3atQ1kmVEnC7gni2L0Zi46z6ZbIsJTqWx
	N7bhzbRaZNEFhTrUogUHNa3WWrQgLdBQNb6AQSIYRaTgps2k1M6uQEhrNlsMDKi3GL/9cs5z
	zvnySEjFM2qJRFu8X9AVqwqVtAzLYgsuZstzRjRrba25kExUYTjX5qHB3+pGEEpWITDeTGFI
	TD1n4LV3joa6cIQGy/gRDK9cJgTWqI2B8Z7vIBa6TYErMkdApOs3BLP1BXDB6aPh//4BEi6G
	gySMeUX9au8Igs6mozQ8iSyE2OA5AuJeGhxHOyk4b6tFUNHQRkP9+XYMgxMzBAzX1xIQckUx
	9JmdhDhMg80yRsCUq5mBRw3DGFzlmTATXgcpRwn0ukcZCJ6uw9AaG6DgwchTCiaitTSE7h+j
	IPFHmACPKUpC1a0khvaXols1m0DQe+NvAkzeaxSMeFIU+Lv6xKz1CoaBWy0UhF8EKJg8tRT8
	NdUUBMz/IGiJO2k4E48imJh0kRvV/BvjKcw3+64TvHFoluY9dg/iE5crSN5oFqnSV8p3Tjow
	/9DJ8TX92fxNa5DhK+/8xfCO9gN85b0YxfuasviGjnFi2+d5sm/VQqHWIOi+2JAv00Ru36X3
	xZmDx0x2phx10CeQVMKxOVy07l/iPQ/NtqE00+xnXCAwRaY5g13J+aqjVJpJtm8Z93RwdZoX
	sZu557+n5nswm8k5emxMmuXseu5h6Cx+17mCc3u75nukov4k3DevK9hczviqUtyViTc2KXfZ
	/5h5F/iEu9sUwGYkd6APmpFCW2woUmkLc9Zoyoq1B9fsKSlqR+K7uQ7P7LiB/vP/0I1YCVIu
	kPszgxoFpTLoy4q6ESchlRny/KZhjUKuVpX9IuhKdusOFAr6brRUgpUfy7+cLFUr2L2q/UKB
	IOwTdO9dQiJdUo4Miy3c+g9XZngOQcPh46YXV86UNUpf6/1j21u+qQmbp1ND2YaFF7Y0ancf
	sW7q/3n6ozc78jTW6qTl5adb81u4rK/zyCFhm10fP7HcWbDl151fXbWMJX8MCp7t7uAudWP/
	1opnozPTPX92zlXLv+/IPZRpmLMHu346aR9dNeC+VNqhxHqNal0WqdOr3gJ6jgCjagMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUhTcRTG+99797/baHVZQheLipUVYS9CxbEieoNuRRF9KSrIUZe2nBpb
	WUaSb0upLB1O05u1lIa5paZl6VrZwlEtyWnvOpexNNFlpBambm1GXw6/8zznPJwPR0zK60WR
	YnXiCV6bqNQosJSS7lqbuVS2sku1wtUsg3fpTRSMDOdQcK3aiiGntlgErVUWBN6RHAS/xwQS
	9A1BCiYMThqGRztoCNqdCArdBhKs99IJGKoJYOh/9hOBsduHoagvnYJB8yUEJT0CDX3NW8Hv
	tYkg6Okl4P2vAQRmX4AAX1M2gonCeLhRVodhrOU1CUXGVgQ3uz0kfKsJmfecXQjsFRkYvubd
	J6HdNw3ejAxieGG8iMHvvkbA9xoMpgy7CEoFA4LM8moMhaW1FDR8bqTB3T9OQGehgQBL7U7w
	mnsocOWVEaH7QlN3Z4JQlEmEyjcCjHdsBIyaK2l4Vd5JgTktCoSWdhF8qSihYbw7BoKmJHBa
	emnwXDFSUOV/LdpgRNxv/WWKq6yrJzh92wTmrNetiBv7Y0Dc8K1MktPnhdpnA4Mkl1V3irvl
	GsDcn5G3mLP/MlHcyzKWy29ZyjWUeGgu6/Enevea/dJ1R3iNOpnXLl8fJ1X5bE/x8e/06fOX
	rtNp6BG+gCRillnJtk1UozBjZhH74cMoGeYIZh5bl9sjCjPJuGaz79zRYZ7BbGY7CoKTuxQT
	xZqaBTrMMmY1+9J7lfqXOZe11DRN5khCenu3a1KXM6tY/WAWkYekJjSlEkWoE5MTlGrNqmW6
	eFVKovr0ssNJCbUo9E3m1PH8h2i4fasDMWKkmCpzR3lUcpEyWZeS4ECsmFREyOIqOlVy2RFl
	yhlem3RIe1LD6xxolphSzJRt38vHyZmjyhN8PM8f57X/XUIsiUxDh/mOB1FnHZskuv5T+X6y
	6Llv+tX7e7Y1OlxO4es5Z0zpDv9zx8edkhw7J3xJjaX3WS1Zqi0FHfho9OwHT4VIZmFr6fyN
	Tz4XrCmO4zdWxV6x9QcCrkMSY5eKppgVgYPRP1Lb6g8UaOYcWxBL3m70qm1Nlt7s8r4tQ8WL
	c3uNCkqnUsYsIbU65V94koK6SQMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: n84s9gdsfrj5j1mgn8qkfw7nhuusz956
X-Rspam-User: 
X-Rspamd-Queue-Id: 38E3BA0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392807-443439
X-HE-Meta: U2FsdGVkX18oXB7rPhWRZPz4W4E4ml9H6q9eXuot/9NEOd1o8ljOjxdiKYtPRgw+5HN6zR9SELV+Nv3Q7gtlsICOZ3YY0fj4spdvb0Erg05BMXUl7mtj5Wyv2Btng9hpB9NXTu4UOHz1WCwKKDMehQL/Hrrl+iiWWcnMeV3jR14MEWzvL0SfWI/R3o6UBZuyhzb1FYdnN7zEOtjEOGmHVUa6TwkNWyoPYlJSG0UuitQNww0HP7/gdnCl5K/tY2ASP60ad+3k07S6v7up/2xVzNI4kwBmEcw9MtDRK4zahvga+sNH32I9TzqlaqZlj6DqotNXdGrQ3JVJCqbSQUf5jbW5AngAVNdKXJzakSYzkfoD9JW24gzDUumSq5qonIbrqVT9M94IzMH2Vg4DJGgsJkPBJn0VFYXkEsr47rCBcsjxE3MmIMDyDDfQ9NLXPRdishhFvR2IANHLlBGYVp0ANh6RE039NKIqTJbohkthzx0FbW7qGxGOkiyi+MFcXdDeJJtKe8mb8ZdR3tlmP69mA2hanaZyBx8KrI81AGpLrpPA8k+FgdW2oFmR3zHXwZRu5ZWmCCU+Tse5Lob6ptPm4MwR7Yc8xIugcv117mtnCXhAA4TVGiQtP7WU/8J3mPQm+8eZ4ADztG6VCRGnQzU7/KU2A3/8A+q5qE+GanvzyB9LFaEJ7KCUsC4BAfqWITRZseVR+/HsSwJyNrk1iXh+qUxITW8FLrJybhXcH/0wvHiGPMCIqqSdb5PVzA5gmyGZmqYQyC6QXbC9xfSq6HEhZHT+ldTMODkhbsgSNr+U3vDsIIYs14IwzqLyWH3Pf/HZaRygOmikJjVWEGbylp+yVhMzCDlpKM9McrqUKE3Qz7SGQ1AAzqiMvKCyQ3U2klvi76Fa9hBnWoIJ9/byh75AUPndy2V2zPBSSoWhVCSguAf3OmSjBhYVYPxsGwHd54UjWih8Hc6RjnxUuLGiNjs
 m4J5mBXd
 hKjXOAyvBGGneeqxl1UDGgXRU3rpUuSo8JaskWwui5FOByOTdlLkGBaOBKdBOpg44D9ZcDqvfPcTuUBxLocZeUacKWkx6D0D1c9kdSWSGt5Wl6yaUa/OEZcdJNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Workqueue already provides concurrency control.  By that, any wait in a
work doesn't prevents events in other works with the control enabled.
Thus, each work would better be considered a different context.

So let dept assign a different context id to each work.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/workqueue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c6b79b3675c3..0e05648b4501 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -55,6 +55,7 @@
 #include <linux/kvm_para.h>
 #include <linux/delay.h>
 #include <linux/irq_work.h>
+#include <linux/dept.h>
 
 #include "workqueue_internal.h"
 
@@ -3153,6 +3154,8 @@ __acquires(&pool->lock)
 
 	lockdep_copy_map(&lockdep_map, &work->lockdep_map);
 #endif
+	dept_update_cxt();
+
 	/* ensure we're on the correct CPU */
 	WARN_ON_ONCE(!(pool->flags & POOL_DISASSOCIATED) &&
 		     raw_smp_processor_id() != pool->cpu);
-- 
2.17.1


