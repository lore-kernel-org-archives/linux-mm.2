Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5AAAD2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259CD6B00CC; Fri,  5 Dec 2025 02:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C866B00D3; Fri,  5 Dec 2025 02:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41946B00CF; Fri,  5 Dec 2025 02:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB1D6B00CE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:19:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F9FE13B110
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:55 +0000 (UTC)
X-FDA: 84184567950.12.17046F4
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf14.hostedemail.com (Postfix) with ESMTP id 10719100008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=XYvLnFU7p4k6RdXHiiqjPg2FVqRQ+ke3blM4eEqwJHs=;
	b=vAyQLuQg70gv5K3LUoBjjiq/V64z6dv8izJL8Ztfi9S+pblzIb28QAKw9d3YyKc5mPJIsA
	n+uCAh9dzo/AbJKEVJY6vsfLZWF6lQIwmsWQwxrxGPoPJsnqrXckqDUxZkt7s5wNX6eTZp
	SdfYtkY2txdm/T+CICohpxC4NI7C3So=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919193; a=rsa-sha256;
	cv=none;
	b=hCtzl1vXjKZDIfo78SSutc/rZe3rUhWt1gOGvdbf6QqMo3f0rmCr1XqT0bz8uup4DBIMgQ
	OhLbdVgl6/AQ/gAzm3W1CMf/8UuBnZZaRfE2yXvR7D3DHsXxBR3WH1HXj4W2n01w+yMkOQ
	fpYztV7UKW/azfs9LKLNKsyA2aUSeFk=
X-AuditID: a67dfc5b-c45ff70000001609-2b-6932876a9648
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
Subject: [PATCH v18 02/42] dept: add single event dependency tracker APIs
Date: Fri,  5 Dec 2025 16:18:15 +0900
Message-Id: <20251205071855.72743-3-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTZxjHfc95z+lpY/WkmHjGPmCaLCYoDgiaZxkzxg/mGDNDMk1U5qWR
	E1stoC1yMTPWcmnXqGE1QKCoBYairVLbLMOOai0GJUAoEqBhQIsQkBTihlTCZbAW45cnvyf/
	y6c/Q8qGqHhGlZMnaHIUajktwZLZjfVJFwypqmSfUQzG0mswHJygYOC6F0Nk3oihttlOg9FZ
	TcGbQT0G/xMbgmDEiGBh2ULCf+Z2Ecwv/i2CNU87gspeMwkfHas0hNvmEFSMTdCwNjJFwITX
	gOBevSsqVP5Dw3J3DwlVFX4EdWMjJMxNhxB4mvQ09E1sAqveQ8EdixnB5JCHgOKGZhqehdwi
	6A2vEGBz/gid5fUEVE3TYKkqJqLnPQEVj/8ioKthGIOlu4+Cd001IlgZS4E1ay48me2hoGN0
	gILwpJmG4OsyCv7UhURgvzFJgtEdweAcj6p1Zb9jaG95R0Cfu5aGG44/KBi1r1GgsyxQ4Pd2
	UvDW5sfQPBUgoKPmIYbGwV4CxkIBal8Wv1B6C/P2u3bELy+ZET/fWEzypeXRt23mA8mXuAr4
	pUg/zXs+WTH/W3cS/6xmRMSXPB8S8VbnZb7k1SzFu5oS+YbWaSJjxwlJepagVuULmm/3npEo
	P/Y2kxe7uML6UQfWIVecCTEMx6ZxluuHTUi8jj3eahxjmt3OBQKLZIy3sNs4181JyoQkDMn2
	JXCGxVtkLBvHHuRuDx2NeTD7DdfSbSRiLGV3cxFbNf25M4GzObzrPWJ2D1cxuLTOsqjnnmlh
	vZNjH4g5vyeIPge+4l42BXA5klrRhkdIpsrJz1ao1Gm7lEU5qsJdZ3OznSi6uPtXVzJb0Jz/
	Jx9iGSTfKPUWpKhklCJfW5TtQxxDyrdIZ9TJKpk0S1F0RdDkntZcVgtaH/qawfKt0tRPBVky
	9pwiT7ggCBcFzReVYMTxOvSzpFVxaqVls+PAvsT92heVPkdtXMbV7f2G/sxDZUmW7+RpCblP
	Zz7s0dO/FIb6L6Xuz0iWHXHoF4+ePLCqm0nQiKfvhOLcb+ZbTULmMX6bW3Pu+K8/JIVXO/89
	H1Rekbe1mZUyLq/rLhqo/n7KGb6WnlLQGe8YX2rMr+sYNuy0yrFWqUhJJDVaxf+EPtdSbQMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxScRTG+997uVxJ6o5c3VnNxlatF80y22m9zNaWt7ayVq3Wl2J1lwSa
	A7Os9aLGJCunNCAkyyiphNSkIjMmWbreXJKVzjdqEenUbAoaGhnW+nL2O3ue8+z5cChcZOdF
	UtLUdE6RKpGLSQEh2LIqJ/pQ7jJp7GBnJKhVp6HD7eHBxywnAX6fmoArFVYSgkY7H9RVBh68
	aMkmoKncgsDtVyMYGTPioKoeJyCoaeCDL9DOB20WgnFHAwKdS4NDa1MtDtb7WRgMVf4moffZ
	IALtZw8J+p4sAgbMFxAUeY186KlPhH53DQ/GO79h0DLch8Ds+Y2Bx5mLIKiTwTWTLXSu+0HC
	WONbHPTaJgTXP3fiMNjzCcH9hi4EjtvZJHwteIBDs2cKvPcPkPBSe56EftcVDL5XklCS7eCB
	600vgmKjBoG3zYFBzo0KEnTFVQRUf3rMB1fvLww6dBoMLFWbwW32EvC6wISF6oZc92aAUZ+D
	hUY3Btq7NRgEzGX8hFLEjqjyCbbM9hBjVe+CJGu9akXs2KgGsb7SHJxVFYTWZ30DOHvWdpQt
	fd1HsqP+DyTrGC4h2Fcmhr15bhRjCxuj2eqiTv7WdXsEqw9wcmkGp1iydp8gechVgae9YY6Z
	uiqJM8g2LQ+FUQy9nHnrNBATTNLzmdbWAD7BEfQcxnbRy8tDAgqnm6OY3EB+SKCoafRG5lLb
	zgkPQc9lHjWqsQkW0vGM32Ig/2VGMZZK59+cMHoFo20Z/cuikOda3givAAlK0KQyFCFNzUiR
	SOXxMUpZcmaq9FjM/sMpVSj0TuaTvwofIV9zYh2iKSQOFzqPLpWKeJIMZWZKHWIoXBwh7JPH
	SkXCA5LM45zi8F7FETmnrEMzKUI8Q7hpF7dPRB+UpHMyjkvjFP9VjAqLPIPu7diysnz5ne7n
	SWsSmPcyr2xF++LJCy/vnt59h1s/OGwyShLT9SvLtxu+747dekowZP8yZeRdftRsePJ0SWGc
	xndj1tRt+qBodrE9Zs18wyJLW239PEX95sjaqeF3b00PjO9Ns9d87IpLdnf/3PSt6PGCU3P7
	mQ3+uKSk9mjbiYoTVjGhTJYsXYgrlJI/9TaX10oDAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 10719100008
X-Rspamd-Server: rspam11
X-Stat-Signature: 9kco7s137xhgnb66iz6sebrfyxi5gj5n
X-HE-Tag: 1764919192-841928
X-HE-Meta: U2FsdGVkX19VkWHMbGOHa6UFxT5jyVXP6gxPNFAk9bldTOhGsBsZHyNsXAHyE0IZwI1ZF3I5x1YlDLO8HHvryIiO8UtGc9sJGFKxrKtoopBVTIy8Nm3nh9cMHdIhGM+h421Dfm3NlXfGZKu+ANnpBDpFAAsusV9ANafZudzy9DuYQQGT7CRiX9OePEl1rkt1hTbnIZNGO3oaW2VfOpn9wZKGM81cUinQm3YTl09XyL/09DNqfgTdCExsR+vXyMzxzJUqYD6ZvVptf02eqZKk1UT6s5QlrN3d+IdfE68fbZRsfwveSpMw9MwmRQa45jahfM9BeB4y6p6SBWHWa70Rar6g6NkQ/nCnEIsZCrNEl4x6lUVYiSyJeziOKNZfsB5/xJe+IgmgRoiPHzfpoTzrKnzClo5G8o3QQchxnBVGHPGdB98HA2vfOQlEsuvqT4iECI+Lh5/B1PbhZFG2I6CQSr0VYHl7zuNg+z1vfOUtmj1EFzk+V5TX4+3ZU9sixtfHsX7vUenA+NbAvD0RjRopXmhI+j4HQoW+n4Kdj9JqtKGcFtB2rNjJNy8I78FEr/tUJ+PeQ/VchnwbLnmg7g1kr3zqILBz7/pDScCx+XKYd9A+QprB3chphz3jGP1mH8PbVMV6g2SGjITL3KIfS1YT18xqcBsCQWeUuYDwg6lvxgkaUaCAI2+Tjggz2m5u84ljSVBETP3iEb7I9owVTlXxxUb7WzQqX9y5mqtE0+zjObHSTRHxg4VkO5jazxtEiP8kuQSJ/bLRCBS52Gi9dIHoM201Xa1Eikb17bHueV7ahnR8WdsByGFkDgMzkZjI5/EItJSSvzfsEze+/m5JAKJbtq5j3JNR4ucKJk8BS4ICDkPVZE6rXDF49/UI3kVXqadw811Yx6cMhH36TOMQofpOYYuq3KUZiYmTauGHMo7dUWd2GVJVu5en+LA55uBBEAlkWlWHYYA3gR+JQjuwxQV
 WcxAv3PN
 kk1OwKgBNs+TC1tCaBsbthaxwpqCaRq5rytslZQ/NGuq5a4qytS7Zf6SXyKHAGWRtjOvwVrLz3f5Rvq5+JXdGQc8gBcDLCsEQ5TyhXJfq1vgk5G4=
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


