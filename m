Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5E3D2E017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0BE6B00CF; Fri,  5 Dec 2025 02:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393286B00CE; Fri,  5 Dec 2025 02:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A446B00CC; Fri,  5 Dec 2025 02:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3886B00CA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:19:55 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2498C133358
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:55 +0000 (UTC)
X-FDA: 84184567950.18.1A1DBE9
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 16C6C40005
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Jx1fwvcyPyfVj+2h4k7nvo/fnuBkbemC4LrGi53TwS0=;
	b=mV8Sk7QGSkC1P6MjdgE6pPEgDSd/OVBEcG3dXPOIs5oU4hCzjzBKzDrMQjvaUCr/kzFOYM
	aaZSEQsUpI6hy+ZOcffRaagi6RHn8AnWlKmaX2fb+f9ISMIpZeR8DgEHP+6HVywzr4Oltd
	O+3L153XpB6VAYlZ/kLukH5ib+FZ8GE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919193; a=rsa-sha256;
	cv=none;
	b=GHkpJdMfGZQSdP6AVMq31fgi0+IbUx4neOQMw3gkIaIN1lqdL9eWT6zRDK97xpgmLdtnzC
	8bBYbyFnvREApnmpc+glBCvqh/hmskETAoJkDSacmhToaObg0rIxpejM8OSZ4QWZq1GMfe
	/l8dLwASs/8kKIjnJ+s4b8MVMmCbs0Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-4b-6932876aa6d2
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
Subject: [PATCH v18 03/42] dept: add lock dependency tracker APIs
Date: Fri,  5 Dec 2025 16:18:16 +0900
Message-Id: <20251205071855.72743-4-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUxTZxTGfe9970c76+6uJF7cjKaJMzJ1oM4cEz/QLPFG8SPhH6NbtI7r
	qJbqioCYuVEVLUwqYgpSqFaqWNvquhYd06EVBUXEdTCBoUURw+IsMhHqShBtIf73y3me85w8
	yWFJ/j41mVVrd0k6rUqjpOVY3jv+1Ozth+aq4/OGeDDk/giteh+GwQEDBoOnlIJHgwYEA+EH
	DLiq9ASYup7SUPJMj6Gv8jCCtlAQQYnJj+BUV4CEqvpOBC1PJ0CD6Scaev8sJ+CFmwbrvhoK
	LGVFCPbbfqah2OLB8LC4iACnZzU8quzBUPzLJDCdv0JAuNLBQENnKwXPe4po+DXnMQOev+sQ
	GC4PYvB0R4Sajs+g5XI5DZ2utxT4fY0UNDv9GBrrb2PwNt0lwX+0gAL7yxIKeu4fJOBcTRMN
	F6/lIug/HcJwq8BHwFXDYwL+MVsIuDEYJOBO4BUDx5qtNAwFqil4YuxloN8yQkGZ3hi5fTNE
	wsW61wy4X56lwXhvBfzv7o5UGkiAsrpOJjFRdHgvEaLrhAuJA2f2k2JuYYRuBPtI8YA3SzzT
	GKTFmpAVi3cqBPFo02zxN3OAEQ9c7WBEqydD9NrjRNvvzwjR48ij1326Qb4oRdKoMyXd50s2
	y1OfN2/ZaRF26/91UjnoLz4fyViBmy/YKt6ifMSOcvEFOjqmuRlCe3uYjHIMN03wFvRQ+UjO
	klzLVOFQ2EhG/RO5ZYL52tYoYm66YG77IGpXcF8I9oJcPJY+VXC6faMxMm6BYGobGmU+4jmZ
	/3o0UuBOyoQHI6XU2EKscN3ejguRworGORCv1mamqdSa+XNSs7Xq3XO+2ZHmQZFnq9w7vLEa
	9fuTaxHHIuV4hS8rQc1Tqsz07LRaJLCkMkYR1MSreUWKKnuPpNuxSZehkdJr0ccsVk5SzA1l
	pfDct6pd0nZJ2inp3qsEK5ucgzCzcWhv2Bn4wbwuViHro3jjqq7h+P/Wnq5YfsU1bHP7753j
	k14FbETrcd3Sr/vLL8wynJVdcizeuv6Iqdr7/ZoP+1akVJm0yYvmrbfa6eXmhyMzFhZum5I0
	86vu+pg/nCvLvpu56Y02o33Jl/XBhrjCOO0b28HEu9vcyRuq88wffVKuxOmpqoQ4Upeuegf5
	dsfOaAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe2xLcRTH/e6rd61yU2M3Q0i9EvGa5xEiHn+4JFiICCFWXHate2gZE2Nd
	1Wq2qSZtWTdms1rWYi+PodFMLJ6x2lg9to7UmJXJtGabmVbin5PPyfmck/PHl8ZlNWQ0LSTt
	51VJCqWcEhPitYu00/dmzRZmWT3TQK87Bu+8PhJeaVwEBAN6AgquOSgYsN4Ugb7qHAkPmzMJ
	aLhqR+AN6hH09Ftx0NUOEjBgrBdBoPetCEwaBIPOegRmtxEHT8M9HBw1Ggx+VPyhoPN+NwLT
	ex8Flg4NAV22HAT57VYRdDxYCV+9d0gYbPmEQfNPPwKb7w8GPlcWggFzAlworg6tm79T0P/s
	OQ4WUwOCi+9bcOjuaENQU9+KwFmWScFHw3UcGn3DoCnYRcEj0ykKvroLMPhWQUFRppME99NO
	BIVWI4L2N04MtCXXKDAXVhFQ23ZbBO7O3xi8MxsxsFetAa+tnYAnhmIs9G7IqowCq0WLhcpn
	DExX7mDQaysXLS1FXI8uj+DKq29gnO7FAMU5zjsQ199nRFygVItzOkOove/vwrnj1Qe50id+
	iusLvqQ4588igntczHKXTvZh3Jln07na/BZR7LIt4sW7eKWQyqtmLokTx3e+2JFSyB7SfLGT
	GahJlo1ommXmsuarVDaKoClmCuvx9OJhjmTGs9W57WQ2EtM40ziOzerNw8P+CGYZm39vdxgJ
	ZhKb3ywJ61JmHluWqyPCzDLjWHuF69+ZCGY+a2ru+8eykHMhu4c0IHERGlKOIoWk1ESFoJw3
	Q50Qn5YkHJqxMzmxCoWyZEv/feYWCjSurEMMjeRDpa6DMYKMVKSq0xLrEEvj8kipXzlLkEl3
	KdIO86rk7aoDSl5dh0bThDxKunoTHydj9ij28wk8n8Kr/k8xOiI6Ax1t3SxZkeUuKd62PnfT
	x4Zu34Q5glY2akHwwfAVlpS4dZJB+9lVljbFxhKNfsrlAmVT3Inr6VLjwrEbXm2v/bUu53yU
	YWS8fP7YnPrYShQsu7LV2Loxln8Z4/HnjXDNuez5wDoQHEltfCsZXTnGluG9O/l0IPr1vj0T
	y5Yn56bPlMgJdbwiZiquUiv+AtJ/KdJHAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16C6C40005
X-Stat-Signature: mnzoro8gwnhzcuouj6hn3qi1o6rghjbf
X-Rspam-User: 
X-HE-Tag: 1764919192-872968
X-HE-Meta: U2FsdGVkX193F6++QhQW58XFampTMeZ2046eUa7qztHQPuzhSt70hYq1YkLAwA9msfmCh8yhvQFcxh6thqMDhwZLSSmzIGEMyaFT98GOdBZBpG0li2yh/ae8ipnjHF80RdYjzJ1HANxjcxlOJOsJgApQFVNpwv3YLe8hRIqJY4RVKG+HLMQ47vD5UeCVniH/Oym7/afftGRdeNvcyxdsYqXczCYefFiP3Vrz9HQxk2hX8dqhumyft/AhmsZCk62BInDUs9USDwpi2uuBuafH5VR0qWkZT6MNA8BAN2uyh0TibhY528ECuXp4BnpTCE4opn5lsRVjWs6Kk00cLpcKaW+WoQVwDpsQkObcKsLURpv54or5zO7jUUFDotvAKk86yoYGeZ+FHr9cNHM2+PRmNj0zJnxgGGpTXhlBD8DwvyLuYu4Of2XidO1qAywtqXqbfiUS9qMOMO7MTqBoROhjeD7c4weTEdBg8/4tDOI3rjyuRVOJqj/PTWGQjJuNUp3gdW0elrM+hAuBl6W0zGADJyp9W1Fse1obS09gP7lnFNypGriVMQ3BEy7MJEJg4vRB+hiY0T5103QSDoVlXpgQkxThIm6Xkt7iTv27PGxLXbHJN+NbH54119frViN+atsOxq6fLymtTshSBjPMblEAy/c+KbgtSPOX1BQi3o+ImJE0Un+jqePT+FwSt3BPdHgcnvu4foMgWlAtn5hXOmq2NsbVoEfZXd7HWKbtlHMxX3cFQ3JF2snSt999QqRJkfkoMoM6sPQNdnhYqzxgwuS7hbBQva4BcubbJKF2+aXOzM90u4VfLujXiu3zlrSa73tdRCF3JY+GOmVG9905QWRJIVaaLh84cntsW42IHgBOQGMbti8pkRc1GS1zCKZRNVaW8M4p1ZiD+PGzSYxzf+CYsX5jqBqZgH+2hPuvXxcEu7Ewbd3pqeTzwf71w6wqbtjnegM7uvFfWgvaDl7YVFz
 ZLgFQTbD
 U8OJJliX+Ydq1O/yv4VpA+/jzaiZaC1Ef1lJnjurCZjlMV29cW61ic7J2VbgOwoW3QaCKOzWgKCIRDjnRBUiMoBUbSC5xKZa1Uwsbf5velVlG3QI=
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


