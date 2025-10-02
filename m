Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA51CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700AD8E0033; Thu,  2 Oct 2025 04:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5785D8E0032; Thu,  2 Oct 2025 04:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306EF8E0031; Thu,  2 Oct 2025 04:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C16C8E0032
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDBC913AC11
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:21 +0000 (UTC)
X-FDA: 83952461922.22.0837C51
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf23.hostedemail.com (Postfix) with ESMTP id F058C140005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=YcZh1vV8SgfnVfzw8dvpv0mjAeTrgvYMwuwe6YQxv7g=;
	b=MQJuFqaT9eDPXItdVmZjZZlvoy5NE+Mo3xq96AESAPTr3/Q6QOs/inc3981QS9OP/JoKGL
	cjPZOrNU7j0cAfT5Eu1tHYh1h0cNrhPKAFqpmrf+oCXEizHFXkVimHTDQrWz1LCZ9fIs7Y
	WbcYL+F9cs8Mlr9Ug4V1tXxd7piLhDg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392860; a=rsa-sha256;
	cv=none;
	b=Rf76FDJ3Xwx0VJnf7Ch2p29bCFjm8qA6p7yIOK1K6GhSQdKYrKLyUic36io78/IEdxV9x5
	xFUOlnsoch1gh/V08Mpy9gpLFV+BW99kswABxMTzSDPa8oDJa+aDEyxq+ED94iEH57Nqd1
	gYBgik/lJnOKYSVX2lzZjeCulkFRPTc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-fb-68de341380ef
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
Subject: [PATCH v17 37/47] completion, dept: introduce init_completion_dmap() API
Date: Thu,  2 Oct 2025 17:12:37 +0900
Message-Id: <20251002081247.51255-38-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSa0xTdxQAcP/3WarVm0riHbKhTfCBr8mYniVmaGLi/8sSnR+Mr0iFG9tI
	0bUKMrOslaLI3MQmLa4XGSAllRaBgkaqRKnCYA3aWodsAZSJlWZgM7Q4oIa1Or+c/HLOyTnn
	w5GQ8t/pJIk675igzVPmKhgpJR2fV70mMWNI9emzjmToM9yhIPK6hIKKRicDvqsOBE8iJQje
	zIgkFLfNUvDW1MWCxW8iwdlqIMA8PMJAechAQbjuHAJrUGQh1LkNZgdfEPB4cgzBW8thKDf7
	EIw2nUHQ2jWEoN1+ioHnZddICIzMh0eRMAM95h8YeNnEwCXRhKDociMDlksuCtqeulnw/x0l
	YMBiIsDh+gq8ZTVEbGWsoXkRiOVFRCyMxi5puEnAVF09C3X6VBB7AzT8ZbeyEB1eD12OFywM
	njdT0DPUR8OTX0/T4PqjE4HzXJCEEneEAtezWKH9z1VQfbqWgp8rBxgIuCsYGHLO0qAX39Dw
	0OGjwNvVHRtivULBA3cDDbbHfmJzDnZWOhGemTYh/NpWROK7Y2ESG1sK8G81PL7Quwa3WQdZ
	XOU6jo33xmncYk/Dl2+FCFw9EaGxq/4sg10TJhZXz4yS21fukW7KEXLV+YJ23ZdZUpWtUWSO
	tq88ce9VGdKj6ZRSlCDhuQz+Qccs8cHNPVVM3Ay3nO/vnyLjTuSW8C0/Bum4Sc6bzPf5V8e9
	kNvBN5Z7UNwUl8rXhBzvemTcBr679ify/cwU3tF0550TYvnAsJeKW859zheHjf/v/SWBH764
	7L0/4jvs/VQZklWhOfVIrs7L1yjVuRlrVYV56hNrs49oXCj2bHXfRffeQBO+nR7ESZBinsyX
	OqiS08p8XaHGg3gJqUiUZdkHVHJZjrLwW0F75ID2eK6g86DFEkqxSJY+WZAj5w4pjwmHBeGo
	oP1QJSQJSXqURhiyvbXpKZ3+bmVbb7Z+bHPmNx+HjXNPvuyfPqteYNu4rmH/luD1gi8Yn3Hk
	kGZp88nCvl3BpwJ73vAJJiqem5dvu75inyhqdyd9PZlZ/Ojg7QarasHELY3tXyb5e11NemD8
	sxv/ZL7yb9zgDm3tKJ7yJN/cXbn1frS01HLKEZUqKJ1KuT6N1OqU/wF0GbkcaAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSa0xScRQA8P73Xu5Firojl7ds2Sh7LTOX1lnvrQ/+q9V6fGhruWR5C+ar
	oEzbWhqyXE+ioUu0yJIcaCLaw4pyWPYwZmRpD8hsplk+WmmlIgS1vpz9zmNn58MRkpIbgilC
	Rdp+XpkmS5HSIkq0cZk6amLse/nCi1fnQ0tOHQWDA3kUFFWW05BnOy+A59csCNoG8xD8GjGQ
	oKn1UzCqa2BgYOgdA357A4J8l46E8pocAn5YfTR8rf+OQN/eQUNBdw4F/aaTCAo7DQx0P4yH
	3rY7AvB7ugho/dmDwNThI6Cj7hiC0fxkuFhSTcOIs4mEAv1zBJfaPSR8tgaaNQ3vEdjLjtLw
	SXudhOaO8fBysJ+GJ/oTNPS6igjos9JgPGoXQLFBh0B9uZKG/GIbBbUfbjPg+uolwJ2vI8Bi
	2wBtpk4KGrUlROC+wFRVGBgK1EQgfCZAX3GHgCGTmYFnl90UmLIjweBsFsDHskIGvO0x4Dem
	Q4OliwHPGT0F13qbBKv1CP/SnKawufoGgTUvRmlcfqEc4ZFhHcIDpWoSa7SBtL6nn8S51Qdx
	aWMPjYcHX9HY/tNI4aclHD7rjMK1hR4G5957y2xaul20PIlPUWTwyuiViSJ5aaWB3mufm/ng
	hxZlo+GI4yhEyLGxXNUTIx00zc7mXr8eIoMOZadz1ac6BUGTbONUrsU1P+iJ7GaussCBgqbY
	SK6k2/J3Rswu5h5fOU3+2xnBWax1fx0SqDe3N1JBS9g4TtOfS2iRyIjGmFGoIi0jVaZIiVug
	SpZnpSkyF+xKT7WhwDeZDnvP3kIDzfEOxAqRdJzYFemRSwSyDFVWqgNxQlIaKk4sc8sl4iRZ
	1iFemb5TeSCFVzlQuJCShonXbeMTJewe2X4+mef38sr/XUIYMiUbjd0Q/U0YPkP1Mjz6Q0Wr
	8UhTws0R36Sbrc43C/eZ+yxhpebUNerM1b74SXBs+qyKCbcdw4v84qbJ0mLPzKgdR7y+rbE5
	9c+u4BY2Zp3jyyP3rS3rE/LcK+Zg/9i7v21FkyOSlmyMc+4+k31y5dqumiT025y7tq9t1btz
	xdbl3vvT1kgplVwWM49UqmR/AOk0IJhJAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: dk5w118fm87qz38fhp4tujex7gryqebb
X-Rspam-User: 
X-Rspamd-Queue-Id: F058C140005
X-Rspamd-Server: rspam10
X-HE-Tag: 1759392859-429230
X-HE-Meta: U2FsdGVkX1+4Uam+lbmJQ9wWjH+jL9J1Spp76UH5x2sEabj/nuUUi6jYQW2RjfRMkohDmSRyRnYn7RG98LXuler6j9+LTpY2ZmJ3+Q3A6adoo2x5zgLD8bwveXLGtTne5V0585zOHYd43S0l4chM4bnTCrzIQ/TSi4lLuO0r3fsayZ44VibLiF5OLJmbJTuDbtVKgQN7o7PBavCF0nktXk1brih2pTu5IBwDkN345YSMRrqDYQoKZn5LedYJAaR5FBAhhj1piMW2hzr8m48aAQVmmRyjgam+JbypmeyPr+7T/aCQL3HyNdfRBbelpCA3Vhz3FU3EQwp1byJY7m93VHaNYYTP8wKrUMV2itNv712YWnX3VIOszRBov8PuYtK1WUMtkM5j2IJHEJMJhN2D8DXnfbagUNQ3/70+0aw5VpP758sBWpFdAUfFf5Rv8eVOTAPwX9acuiaXNfj7ThShpNaPdLFfw0qJzRjoEZUjWe7NEEo38yVrennaP40dddq9twOmtj6GxiuHbRVtado8pPo9ZjbpQhW+2KqDG/pTRaxVrcDKl/Xk/C84h4GUaYKW4odPb1J1+h7hYd1ksJ5DaVLrSk+1WoM8DfXYs+TbBQPr02mUCJ6RC37zj2wy6P6mrQgxyjvEmVFufWu7JhEg2sBHmrXO36PYMI8e/UD/wEf1vq3NuJzSUBcLMGbm/VNG9poDD24nmkw/Ld+7sCcpfQh/cbB3pk1nWG9i1B42lfY3AIOq1wZhGaccYC5eZ5OlrbhJ0IXpnHJ0KDi8x+N55H/Ft9fUShAr6mOtxeyWkugtrp/Pg1awLofsl1FMk/8BvxxOCp1ddnMcG+NYvidr3qfN2YqEIdPc1bImORGFVMhGKS0fmnkPJlYs8nEipdiFThLhBNLhv6N2LZDT7PB7xDSwpb0mN9iD7/ivC2TXjciO/miEJnA2YhpupaXJOmrlpouG67bs4PmxMDrqdTP
 cZZYrQyG
 bvEyu2DqDafatDIs3kyAa+5xuefOYHKJ1HqfaMwHXG8C/cqEZCovHMwre9r63W9o/xQlB9PH50fUsGMEqUCfHLfx8fq2bZcnQhrUuRo9HZbD+NKeV5DLLnBGAj7BGz8r/eMaC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, dept uses dept's map embedded in task_struct to track
dependencies related to wait_for_completion() and its family.  So it
doesn't need an explicit map basically.

However, for those who want to set the maps with customized class or
key, introduce a new API to use external maps.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/completion.h | 40 +++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 4d8fb1d95c0a..e50f7d9b4b97 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -27,17 +27,15 @@
 struct completion {
 	unsigned int done;
 	struct swait_queue_head wait;
+	struct dept_map *dmap;
 };
 
-#define init_completion(x)				\
-do {							\
-	__init_completion(x);				\
-} while (0)
+#define init_completion(x) init_completion_dmap(x, NULL)
 
 /*
- * XXX: No use cases for now. Fill the body when needed.
+ * XXX: This usage using lockdep's map should be deprecated.
  */
-#define init_completion_map(x, m) init_completion(x)
+#define init_completion_map(x, m) init_completion_dmap(x, NULL)
 
 static inline void complete_acquire(struct completion *x, long timeout)
 {
@@ -48,8 +46,11 @@ static inline void complete_release(struct completion *x)
 }
 
 #define COMPLETION_INITIALIZER(work) \
-	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait), }
+	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait), .dmap = NULL, }
 
+/*
+ * XXX: This usage using lockdep's map should be deprecated.
+ */
 #define COMPLETION_INITIALIZER_ONSTACK_MAP(work, map) \
 	(*({ init_completion_map(&(work), &(map)); &(work); }))
 
@@ -90,15 +91,18 @@ static inline void complete_release(struct completion *x)
 #endif
 
 /**
- * __init_completion - Initialize a dynamically allocated completion
+ * init_completion_dmap - Initialize a dynamically allocated completion
  * @x:  pointer to completion structure that is to be initialized
+ * @dmap:  pointer to external dept's map to be used as a separated map
  *
  * This inline function will initialize a dynamically created completion
  * structure.
  */
-static inline void __init_completion(struct completion *x)
+static inline void init_completion_dmap(struct completion *x,
+		struct dept_map *dmap)
 {
 	x->done = 0;
+	x->dmap = dmap;
 	init_swait_queue_head(&x->wait);
 }
 
@@ -136,13 +140,13 @@ extern void complete_all(struct completion *);
 
 #define wait_for_completion(x)						\
 ({									\
-	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	sdt_might_sleep_start_timeout((x)->dmap, -1L);			\
 	__wait_for_completion(x);					\
 	sdt_might_sleep_end();						\
 })
 #define wait_for_completion_io(x)					\
 ({									\
-	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	sdt_might_sleep_start_timeout((x)->dmap, -1L);			\
 	__wait_for_completion_io(x);					\
 	sdt_might_sleep_end();						\
 })
@@ -150,7 +154,7 @@ extern void complete_all(struct completion *);
 ({									\
 	int __ret;							\
 									\
-	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	sdt_might_sleep_start_timeout((x)->dmap, -1L);			\
 	__ret = __wait_for_completion_interruptible(x);			\
 	sdt_might_sleep_end();						\
 	__ret;								\
@@ -159,7 +163,7 @@ extern void complete_all(struct completion *);
 ({									\
 	int __ret;							\
 									\
-	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	sdt_might_sleep_start_timeout((x)->dmap, -1L);			\
 	__ret = __wait_for_completion_killable(x);			\
 	sdt_might_sleep_end();						\
 	__ret;								\
@@ -168,7 +172,7 @@ extern void complete_all(struct completion *);
 ({									\
 	int __ret;							\
 									\
-	sdt_might_sleep_start_timeout(NULL, -1L);			\
+	sdt_might_sleep_start_timeout((x)->dmap, -1L);			\
 	__ret = __wait_for_completion_state(x, s);			\
 	sdt_might_sleep_end();						\
 	__ret;								\
@@ -177,7 +181,7 @@ extern void complete_all(struct completion *);
 ({									\
 	unsigned long __ret;						\
 									\
-	sdt_might_sleep_start_timeout(NULL, t);				\
+	sdt_might_sleep_start_timeout((x)->dmap, t);			\
 	__ret = __wait_for_completion_timeout(x, t);			\
 	sdt_might_sleep_end();						\
 	__ret;								\
@@ -186,7 +190,7 @@ extern void complete_all(struct completion *);
 ({									\
 	unsigned long __ret;						\
 									\
-	sdt_might_sleep_start_timeout(NULL, t);				\
+	sdt_might_sleep_start_timeout((x)->dmap, t);			\
 	__ret = __wait_for_completion_io_timeout(x, t);			\
 	sdt_might_sleep_end();						\
 	__ret;								\
@@ -195,7 +199,7 @@ extern void complete_all(struct completion *);
 ({									\
 	long __ret;							\
 									\
-	sdt_might_sleep_start_timeout(NULL, t);				\
+	sdt_might_sleep_start_timeout((x)->dmap, t);			\
 	__ret = __wait_for_completion_interruptible_timeout(x, t);	\
 	sdt_might_sleep_end();						\
 	__ret;								\
@@ -204,7 +208,7 @@ extern void complete_all(struct completion *);
 ({									\
 	long __ret;							\
 									\
-	sdt_might_sleep_start_timeout(NULL, t);				\
+	sdt_might_sleep_start_timeout((x)->dmap, t);			\
 	__ret = __wait_for_completion_killable_timeout(x, t);		\
 	sdt_might_sleep_end();						\
 	__ret;								\
-- 
2.17.1


