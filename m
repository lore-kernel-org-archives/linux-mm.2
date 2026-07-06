Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE90C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A326B00EB; Mon,  6 Jul 2026 02:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C616A6B00EF; Mon,  6 Jul 2026 02:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02736B00F0; Mon,  6 Jul 2026 02:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8228D6B00EB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:21:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 010761686F6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:59 +0000 (UTC)
X-FDA: 84957353880.01.5260377
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1F6E420006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=YcZh1vV8SgfnVfzw8dvpv0mjAeTrgvYMwuwe6YQxv7g=;
	b=wQJfmbQbZHvDkSQiHFQ2hRwq9WZqssvD8umD93a2VAcVouVkah/HvFjiUMLS1NNwnnWOCF
	T5sB/jWVkNFfUi9WFEmbKOSna7H+NvTKKvl9o2LhwCZT1QteLnLABDc1hYLLxmdbibEcMd
	ST3T3qoIHA4ctB1GBaMA2YcDP6ycgyM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318858;
	b=z3Gz7bziemJxddcW1FoyU/Wnl9NiSRVnkym4zzLlRXQVOkn1jhppzW3svaHtUNWQwhhSIK
	3tBHp/K5fylJZA8/3Ufy19E0Cjp76P2sFZEIt9ayR95iCTfuRebyy9mBMfrlg3buHQrEsl
	nQFAfAcf4UpiTOW76FxM8ayFwj5XX6Q=
X-AuditID: a67dfc5b-c45ff70000001609-0f-6a4b49054145
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
Subject: [PATCH v19 32/40] completion, dept: introduce init_completion_dmap() API
Date: Mon,  6 Jul 2026 15:19:20 +0900
Message-Id: <20260706061928.66713-33-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTH99z73Beq1ZvqxkU+QJqpiFGnYeYkvoS4D141SzSafZi62Yy7
	0VKgaRHFaUAU10zQrksRAQ24USstoK1DBOsLClIrs4zNdVAqRFZCKmIUMGWtXavx2y///zm/
	nA+HJWVeahGrzCsQtXkKtZyWYMnE3PoVzJZtqk/Gb2aAvqwYfE9GKZie0mOobbHR0PN3KQZP
	sxXBk2k9grLrUQwRYzcDU6FBBqLObgS2q0cJCN59icA0MkrDpLkcwXjXZogOjRFgHn1DQKQy
	B86YPAjqR4ZIuNrtR+C0lNLwr+E3EvpH54HLdJKGib5aAgIDTgIqz9kx9AXDBPgqjQRY7Z+D
	23Ahll9JhJozxwgwNXUQEDI3MlDT209BeGQ1ROvyYei0CUPzxCMKXP7HFAQDRhqulQwzYP+n
	K3ZneYAE+9NYcfa8j4YbThcGfWQKQX97LQ1+W5SCkprXFHhuuyn4w+rB0DLmJcBVfQnDYO9p
	Bh61N1EwMuylwNH7kISZU8ng+amCyswSGh2thGA7b0PCf7NGJJQZYnT32SQpHHccEBrcz2hh
	dvovWnDO1GHhwQVeuF49xAjHbw4wQp19v+CwpAu/3BgnhIHghu3pX0rWZ4lqZaGoXbVxnyS7
	oaWG1jiXHbz3yoBK0GzKjyiB5bkM/oG5mnrPlnoLGWeaW8p7vaG3vJBL5R0VgdiMhCW5/hS+
	3FyB48UCbgcfcuvpOGNuMX/LcIuJs5Rby4eCHeidNIW3Xr79VpQQy5vD54g4y7hP+cHJ+zgu
	5TlrAm+6+JB8t5DE37F4sQFJ69AHjUimzCvMVSjVGSuzi/KUB1d+k59rR7F/Mx8J725DLz07
	OxHHIvlcKWRuVckoRaGuKLcT8SwpXyhdkrZNJZNmKYoOidr8r7X71aKuEyWzWJ4oXTNzIEvG
	facoEHNEUSNq37cEm7CoBJ1I3Lvl8ONwX9dTVeS1sdWfduL+z8+LDfOZdVXmw6lbNZkFX+1q
	qk/evv5D70XXvA68obQqc47uo32XNafGqi79uaOgXN2W+nHr7tycnqQ5m5cmnm0PLG76/ocv
	lqc1mMP+Xd2RNt/vx/YU+ord3/76GZvauGo4KXmN5oXqTuvJnr6j9zbJsS5bsTqd1OoU/wM3
	LlxMawMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0yTZxTGfb9bS13NZ23mFyXBNMFbos5kbGfReElIfC1jmYlhxmik6hcp
	BSStY7DNCJRix8SUZi3ODxAYVALVYsELkgaCE6doLLAhGbJi0pYRilUskJabrcv+Ofmd5znn
	yfnjiEnZPXqdWJ1zjtfmqLIUjISSfLVLv40+mJL5SakjAYyGC/DS46VhqKibgpmQkYIqh52B
	ReGuCIzOX2n440UxBe6bLQg8M0YEc/MCCYaOZQoWzb0iCIVHRGApQrDs6kVg7TeTMOzuIsHe
	XkTAu9YlBiYfTCOwvPIyUDlRREHQdgnBVb8ggomHB2DK00nD8ug4AS9mAwhs3iUCvN0XESxa
	NXCtvi26bn3DwPyz5yRUWtwI6l6NkjA9MYagvfcfBK6mYgZ8ptskDHpXwZ8zQQYeW35mYKq/
	ioDXrQzUFrto6H86iaBaMCPw/+0iQP+bgwFrtZOCjrH7IuifXCDgpdVMQIszFTw2PwV9pnoi
	em506tZaECr1RLT8S4DlRicBYVuzaF8jwnOGyxRubrtDYMPAIoPtNXaE5yNmhEONehIbTNH2
	QSBI4pK273BjX4DBkZm/GOyaraXwk3oON/wUIXDFs2244+qo6Ov9RyW7T/NZ6jxeu2NPuiSj
	0SEwua4t+b+/M6FCFEkoQ3Fijv2Ua6prImPMsJu44eHwB5azG7i2cj9dhiRikh1M4C7ZyqmY
	sYY9xIX7jEyMKTaR6zJ1iWIsZT/jwpOd6L/QBK6ltftDUFxUv7lQTcRYxiZxI8FHlAlJatGK
	ZiRX5+Rlq9RZSdt1moyCHHX+9lNns50o+k+28wsV91Bo8EAPYsVI8ZEU9ikzZbQqT1eQ3YM4
	MamQSzduTsmUSU+rCr7ntWdPaL/N4nU9aL2YUqyVKr/h02XsGdU5XsPzubz2f5cQx60rRApa
	flkYvXJkqb205uNZP6xJ+rKqqaLzZPKujVscUCoE7NfcJWXJ1QM1EyWRExtSQoGp8Xi3nFPu
	zk0vmOaHGn5IfOTD4cOmROtIvFG5em/uyoFC4cfrq1LfejRHeEzqfGS8suEKFUgr/+VzzpcW
	SNXcrirRH3R+cdwX1B9TULoM1c6tpFaneg9Ns3PXSwMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1F6E420006
X-Stat-Signature: kfaoxudg5uqnc6henajokbf8j4jhej7t
X-HE-Tag: 1783318857-310272
X-HE-Meta: U2FsdGVkX186lvdUNYj2FZUf5olg2q3LvkXGoBUHQqK2tjpeDkUO+zD2M01iBteVwH6IojqJ+CgGL9UFo3D//8OCGJ9s6FhvkOjggEVeWqtnQU4jUCVkgu+V+3Wf6zCONt/sMO4pCibSyy5l/hvMFVLbkldUhF3gcALPFmLHRSVsyyopSov4sQv81MQzgsxqpfG+PZf2e2z20k1MaBybZKoWL5EDkaDqMrfqWOM+3evVhRTo9s4luR3gCOpl86q6anTBOjH66LCBbxTwTyRyUh5XdGk4vP2NqlRpZeHANspv28FhFRyDHs8os/zyK3ImeZybiYgv/SdAElq41e4OZJwmEiEffybh/ip6DnPmNBaIgzLivnokrjSuHn5WUpr325TmkQ8+h4DD6fmdfKKOWV8siabVh1CWue5RqL2SHkPq2QTHsfsOFOrKK0pRNGZJeuil4usUeGVci8u9zqQwNuI+LGt46d3TEAPXCCpQ8m1cFtT240BE1LDsDsiKqL+ymKZCGSkHRcviyIihf36Qz7d/zSKE4uByzLLL1onoNs6rnz+BXWx7GsdqEZR5wf8mbLiio4dhthE2rqTSQ7CalBid0qgvXQP/Tw1Bvb4TULFM7qk67i2ky1lGUgBZn8406TgISDv3JnO0W/pVxm/ykm15puldCPvJJDZF66Zetv64gXRk80/dGDKAdhRPq0kfgyib+8Ct67TTUKgmteQeeHbdsCG4eweS8+1yrZxcDp2QzUyIgSqmrsO1nPfR7aFv0cBg3EmvcCs+EwpV2sotZzGZ/3cof4KdpGYeJ/zgvEWh1NA5dsBe1nRqqB5H1keiuhfxKmbcFpBN6NboldEFEk25YLmbTdqdoGO4Lp4e/hyziFjkPeeGBG2b2elkYYJfrxWEN6RIa5KEO9+YQxhAknrYRs5/kv7SzrE7rwr6aqPn1z/qB6e7fwIDUSe+BX28puIEUcYn0Z90gI0QLJE
 wYcESAb2
 Tjx7xZHs9LBxob8ACk1koEFMACBV25b2DaVlbteVNjkhAettVoxhIAYO0XlnQf2h18OPc7O8V25fe11X4mnoYAXglStGqCL7tLfqokNq9I81oABMj5AsQZXHiADLI3cE0HRcjOe1n8RYZcpjbVTfvVdMBstfbt7trCi114aqoE5Rh7yoX9Ie5VM4UG3MGkFDSRNHyU0wKSdRY+X3LqrI2M9c+7g==
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


