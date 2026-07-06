Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00CA3C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC1F6B00D7; Mon,  6 Jul 2026 02:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4956B00D9; Mon,  6 Jul 2026 02:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165B76B00DA; Mon,  6 Jul 2026 02:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3F9E6B00D7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4283D168700
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:41 +0000 (UTC)
X-FDA: 84957353082.25.D05AE67
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 43B9920005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=dgegDgfAOUN/1B97G9Jtqj0JFMy3K4Y9ZatZEqAMWq4=;
	b=p1Ep9P3TWpxjYXXLcrCvZPhh3WpuSujMzSBSdtvQ29/cgifdVwfQpuMOqcRYNUvhdQW95S
	PtOLKI+cUuy07nA9IjlBndw5DuCAKgKPuTEmtNSOZNJnr624caxRKomtFCMuLPEVojprcS
	QPLA5FpNx2RQeoiC7tYs6XgOAqZrXKA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318839;
	b=Is7tbVnX14GLzH5EUPi1glFev/0ydcQtBlRjfDHrWEevDQ0Q2zfdyTRpc3ryd6VY98GLx+
	fSF2eSdSf6JfLcjQXC2pBd2Ee1sV/7EiLFGCPXHdBpZw/V8E4a5SzyLvHhJFtMKwAP2Cu8
	AyLpZ6fXUBcum8yWkaWEoNeU84KnKwY=
X-AuditID: a67dfc5b-c2dff70000001609-f9-6a4b49011fa5
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
Subject: [PATCH v19 23/40] dept: print staged wait's stacktrace on report
Date: Mon,  6 Jul 2026 15:19:11 +0900
Message-Id: <20260706061928.66713-24-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSb0wTdxjH97v73V1p7HKpZN5YDKSJzjFlg8DykCwE35hjxERDzBbdv0Zu
	0g4qKYgCMQO0pS5FS5URqNUWsDLaSWmFAVoDGCAhqaDNRnGgIrRCVJp0UCOK2GJ898n3+f55
	84hI6RSVIFKoSgW1Sl4oo8VY/HyTdReZk6v80mD8DHSa32BlWYfhYqeDholrdgQPV3QINH3r
	GNaMIwyse0YQOK5XE9AwO09D42I1hpBNj6A5aGLg+cMbFExGniGYH6hFcLnFHbU0TCCwzs6Q
	cH3kAQJPew0NAUM3Cb75D2HJSYOlxkOB2WRE8IfZhcHu2gumxgUCXto6GDB5fRQ8bm9m4GnQ
	SINrajg6rw+SoOtfweCa+5cCz/3Pwaptw9B0aZoGX/9FGh441ikY7/+LgiuTdwnwGwIIbCsh
	Bu4NWAioHmzFEPxHS0C4LYJB+/8bCkbrBgioXbhBg9d0hwJtWxcBt3SPCOgM3iZhdaaXgtWr
	0W1vzxgDYXM0Yb+LoXv4BQPm5dTsbF5zb43mHZcciH+1akS8xhCl289CJH/afZz3RCyYH2vh
	+HrvLr6veYbhT9+6z/AW1zHe3Z7Mt95cJHhXxxmad4WNzL6kg+Kv84VCRZmg/iLrZ3FBU9Mc
	VTyYdeKcDVchS9rvKE7EselcR2Caes+rVzuZGNPsp5zf/5KMcTybxLnrglGPWESyvkROb6vD
	scNmNofrCl/YCGN2G1ffsLQRkLBfcb3jo8y70kTO7hzY0OOi+rXXZiLGUjaD+y80imOlHNsa
	x9Xf6aHfBT7mBtv92IAkFvRBB5IqVGVFckVhekpBuUpxIuXw0SIXij6c7eTrQ70oPJE3hFgR
	km2SQPY3SiklLyspLxpCnIiUxUu278hVSiX58vIKQX30J/WxQqFkCH0iwrItkrTI8Xwpe0Re
	KvwqCMWC+v2VEMUlVKH4b/c7t4ZzA8ocrlh7qqJ4LuUH49bx7j+zkkL7n+48+0q6u2Cpypm4
	vWeixh7ecjiZcKaPs5WqTP0vurO7I7N76rct/5h5YHPqd3+vpYjdZ9YOZN6czMTW832Lmp2V
	aXTrqaa8tOrLXRnKvfpaq8+Nj3xErPvlnh2136t7nniTAjJcUiBPTSbVJfK3vqqFUmwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+93nXC0uS+hilDHoSVnZg0NFDyi8FVkRUZqQSy85nZabmkYP
	dQ1XaeloE13aslyi5mProcnIjNTeListNY2WJZoz08zpss3on8PnfL/nezh/HAEuvkf6CGQx
	cbwiRiqXUEJCGLhOtRRt2xG5XJtOgkZ9Bto77SS8S6klYHhIQ8CV8lIKXIZ7NGjMOSQ0tqQS
	0FRWgqBzWINgZMyAg7p6ggCXtp6GodE2GnQpCCas9Qj0Ni0OrU0PcCi9nYLBz4o/FPQ+GkSg
	+2SnILsnhQCHKR1BbreBhp7HAfC9s4aEiY6vGLT86kNgsv/BwF6bhsClj4KrBRZ3XD9AwdiL
	Vzhk65oQXPvUgcNgTxeC2/UfEViLUin4knkHh2b7dHgz7KDgie4CBd9tVzDor6DAmGolwfa8
	F0GeQYug+4MVA9X1cgr0eWYCqrvu02DrHcegXa/FoMS8EzpN3QQ8yyzA3Oe6pypngiFbhbnL
	Nwx0t2owGDUV05sKETeivkhwxZa7GKd+7aK40vxSxI05tYgbKlThnDrT3T7qc+DcWctxrvBZ
	H8U5h99SnPWXkeCeFrDcjXNOjMt6sZSrzu2gd28OFq4P5+WyBF6xbEOoMCIn5zN57OGGxEsm
	IhkZ/c8jLwHLrGKdN8tpD1PMAra1dRT3sDczl7VkdJPnkVCAM82+bLopg/AYM5htbOXgZdLD
	BDOPzdL1TwZEzBq26lUD/W+pL1tSUTupe7n1svE8zMNiZjXb5mggMpHQiKYUI29ZTEK0VCZf
	7aeMikiKkSX6hR2NNiP3O5lOjWdVoaHmgDrECJBkmgg2bY8Uk9IEZVJ0HWIFuMRbNH/hjkix
	KFyadIJXHD2kiJfzyjo0S0BIZoq27+dDxcwRaRwfxfPHeMV/FxN4+SQj+cY5IckZ1/yDl71e
	sijsNMp1TOSvuiHlEu8OvG+Zv2fNysCtEdNP+vrP3tv/1Tpg6bplaTi4r3FLUGHJtBBsQVFl
	bbPm4+OHIQdiD7w8Wc2qfI3xcwfXFsU25k59sn+qT1DTHLPj4m+RS1Xc/yPW1DWaX3Y4rTyt
	oGfEaQs87dy764uEUEZIVyzGFUrpX8zaz9NKAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43B9920005
X-Stat-Signature: br6bocfqbz9zz8egdw3dtsjndbci9jj9
X-HE-Tag: 1783318839-872997
X-HE-Meta: U2FsdGVkX186HU4c+p3XxnycDi+Iv4GOR5Y7Zo6G5USr3/pb19IpL8lyitWeN+Tm8l2ABFLS5KP8HJ2HdCJe+kulcM1/l4eEl9w2limOav9kyq4Tvl4B1uL4/BjBjwBaDgsc8LM265Mj6ATkJvW1CaqOPc2ug0soBshzbN+aeAYt8L4uYz6nNPZQ8rli0vO5NJX2MKnDBtOPZc88kyb20XvzgPxTaobXngiscqlyrOSV3Z1IdRisQ4GBKZfLwCgVurD3QHX7NClYRjT0MA9C6qafP8qvZ7XLpCAU4I0XOltbE2lsPzRVM4EDHA+UoL7DUIgspDfgo0O+zGRAfYnq4DfRmUikH+qNnyLfvR7NjoyqcqibXBuIOPJBDG0tRPIK+1z/CTn0CiDV0jp2i9zhvAa5k+efGcgb36vQWssskqF0OO7ufJUsazBdmZElVPVDCCkFA8BmOOdNOqIvIu3aAzzmacUajAM/trSIJXC6dmVaL3tcexrnAebDpTzwf3triATVrrI04ERjmjq1HYEZpAzBqddijwOPn61NHFwYD9UYTgZyCtg4L3tdLgqieNg3ko2aBFgVQa6EJVl4vf07Zwnt8GuSWHAs8XzpFRcYXrfUocpLn7JuMgFOtwjz1LUu4JS2GffkYlm7Xd4qNUV374v3lT0ZhSl+P2cITEEPuI8JSPLe8gvC2xYKQDN5iJo6veqRjuMdusXJ7R4xRzDsTckJ8e9DTEuXpmmAi5Vpisai+fcNDO8TXKJCXDU3mWBgQXKjImOHZ2P7gNtXZQ89ORGRwOfN9aIsI8PfZ3NZNudX3+BjHMy54u/5DZMJQ9WxDfI6u8Tn2Bp99xZeO9n+Mwuid8X4kdwvzT2O6waa8cdtFZFNaEftj/O8HbregzSOz0WsgDRQQQLmKTig7g4Cz7mUCf9BwgJKrtw01QPWZ56zQzcdas/0e3uH9CIjX42Vaj8JYIw7jXvaPVKIfXZ
 YOm1h3/w
 O0B/M3MpDYMBBABLOwU0Nv2u8MPZ3XRyirr3SY1qaA/hE+dDhP/DjAbPuRiTUh2iZx4k5RkCdtRZ5VgcRJBL+ZR4okSeIuDQXz0li73A/r6J1/fPpeb4xQGNGq1vvc5i6U53QcH81bNjJ7UjYlKIBmlZ6Tl8d34ZWdYSdfQ4v6D79ci0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, print nothing about what event wakes up in report.  However,
it makes hard to interpret dept's report.

Make it print wait's stacktrace that the event wakes up.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/sched.h             |  2 ++
 kernel/dependency/dept.c          | 59 ++++++++++++++++++++++++++-----
 kernel/dependency/dept_internal.h |  5 +++
 3 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a4e6dce98f36..b2fbcf0f00f4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -871,6 +871,7 @@ struct dept_task {
 	const char			*stage_w_fn;
 	unsigned long			stage_ip;
 	bool				stage_timeout;
+	struct dept_stack		*stage_wait_stack;
 	arch_spinlock_t			stage_lock;
 
 	/*
@@ -912,6 +913,7 @@ struct dept_task {
 	.stage_w_fn = NULL,					\
 	.stage_ip = 0UL,					\
 	.stage_timeout = false,					\
+	.stage_wait_stack = NULL,				\
 	.stage_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED,\
 	.missing_ecxt = 0,					\
 	.hardirqs_enabled = false,				\
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index e425d3ab05e5..5bf32633e1fb 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -523,6 +523,7 @@ static void initialize_ecxt(struct dept_ecxt *e)
 	e->enirqf = 0UL;
 	e->event_ip = 0UL;
 	e->event_stack = NULL;
+	e->ewait_stack = NULL;
 }
 SET_CONSTRUCTOR(ecxt, initialize_ecxt);
 
@@ -578,6 +579,8 @@ static void destroy_ecxt(struct dept_ecxt *e)
 		put_stack(e->ecxt_stack);
 	if (e->event_stack)
 		put_stack(e->event_stack);
+	if (e->ewait_stack)
+		put_stack(e->ewait_stack);
 }
 SET_DESTRUCTOR(ecxt, destroy_ecxt);
 
@@ -794,6 +797,11 @@ static void print_dep(struct dept_dep *d)
 
 		pr_warn("[E] %s(%s:%d):\n", e_fn, fc_n, fc->sub_id);
 		print_ip_stack(e->event_ip, e->event_stack);
+
+		if (valid_stack(e->ewait_stack)) {
+			pr_warn("(wait to wake up)\n");
+			print_ip_stack(0, e->ewait_stack);
+		}
 	}
 
 	if (!irqf) {
@@ -807,6 +815,11 @@ static void print_dep(struct dept_dep *d)
 
 		pr_warn("[E] %s(%s:%d):\n", e_fn, fc_n, fc->sub_id);
 		print_ip_stack(e->event_ip, e->event_stack);
+
+		if (valid_stack(e->ewait_stack)) {
+			pr_warn("(wait to wake up)\n");
+			print_ip_stack(0, e->ewait_stack);
+		}
 	}
 }
 
@@ -1657,7 +1670,8 @@ static void add_wait(struct dept_class *c, unsigned long ip,
 
 static struct dept_ecxt_held *add_ecxt(struct dept_map *m,
 		struct dept_class *c, unsigned long ip, const char *c_fn,
-		const char *e_fn, int sub_l)
+		const char *e_fn, int sub_l,
+		struct dept_stack *ewait_stack)
 {
 	struct dept_task *dt = dept_task();
 	struct dept_ecxt_held *eh;
@@ -1691,6 +1705,7 @@ static struct dept_ecxt_held *add_ecxt(struct dept_map *m,
 	e->class = get_class(c);
 	e->ecxt_ip = ip;
 	e->ecxt_stack = ip ? get_current_stack() : NULL;
+	e->ewait_stack = ewait_stack ? get_stack(ewait_stack) : NULL;
 	e->event_fn = e_fn;
 	e->ecxt_fn = c_fn;
 
@@ -1797,7 +1812,7 @@ static int find_hist_pos(unsigned int wg)
 
 static void do_event(struct dept_map *m, struct dept_map *real_m,
 		struct dept_class *c, unsigned int wg, unsigned long ip,
-		const char *e_fn)
+		const char *e_fn, struct dept_stack *ewait_stack)
 {
 	struct dept_task *dt = dept_task();
 	struct dept_wait_hist *wh;
@@ -1825,7 +1840,7 @@ static void do_event(struct dept_map *m, struct dept_map *real_m,
 	 */
 	if (find_ecxt_pos(real_m, c, false) != -1)
 		return;
-	eh = add_ecxt(m, c, 0UL, NULL, e_fn, 0);
+	eh = add_ecxt(m, c, 0UL, NULL, e_fn, 0, ewait_stack);
 
 	if (!eh)
 		return;
@@ -2360,7 +2375,8 @@ static void __dept_wait(struct dept_map *m, unsigned long w_f,
  */
 static void __dept_event(struct dept_map *m, struct dept_map *real_m,
 		unsigned long e_f, unsigned long ip, const char *e_fn,
-		bool sched_map, unsigned int wg)
+		bool sched_map, unsigned int wg,
+		struct dept_stack *ewait_stack)
 {
 	struct dept_class *c;
 	struct dept_key *k;
@@ -2382,7 +2398,7 @@ static void __dept_event(struct dept_map *m, struct dept_map *real_m,
 	c = check_new_class(&m->map_key, k, sub_id(m, e), m->name, sched_map);
 
 	if (c)
-		do_event(m, real_m, c, wg, ip, e_fn);
+		do_event(m, real_m, c, wg, ip, e_fn, ewait_stack);
 }
 
 void dept_wait(struct dept_map *m, unsigned long w_f,
@@ -2498,6 +2514,9 @@ static void __dept_clean_stage(struct dept_task *dt)
 	dt->stage_w_fn = NULL;
 	dt->stage_ip = 0UL;
 	dt->stage_timeout = false;
+	if (dt->stage_wait_stack)
+		put_stack(dt->stage_wait_stack);
+	dt->stage_wait_stack = NULL;
 }
 
 void dept_clean_stage(void)
@@ -2561,6 +2580,14 @@ void dept_request_event_wait_commit(void)
 
 	wg = next_wgen();
 	WRITE_ONCE(dt->stage_m.wgen, wg);
+
+	/*
+	 * __schedule() can be hit multiple times between
+	 * dept_stage_wait() and dept_clean_stage().  In that case,
+	 * keep the first stacktrace only.  That's enough.
+	 */
+	if (!dt->stage_wait_stack)
+		dt->stage_wait_stack = get_current_stack();
 	arch_spin_unlock(&dt->stage_lock);
 
 	__dept_wait(&dt->stage_m, 1UL, ip, w_fn, 0, true, sched_map, timeout);
@@ -2579,6 +2606,7 @@ void dept_ttwu_stage_wait(struct task_struct *requestor, unsigned long ip)
 	struct dept_map m;
 	struct dept_map *real_m;
 	bool sched_map;
+	struct dept_stack *ewait_stack;
 
 	if (unlikely(!dept_working()))
 		return;
@@ -2597,6 +2625,10 @@ void dept_ttwu_stage_wait(struct task_struct *requestor, unsigned long ip)
 	m = dt_req->stage_m;
 	sched_map = dt_req->stage_sched_map;
 	real_m = dt_req->stage_real_m;
+	ewait_stack = dt_req->stage_wait_stack;
+	if (ewait_stack)
+		get_stack(ewait_stack);
+
 	__dept_clean_stage(dt_req);
 	arch_spin_unlock(&dt_req->stage_lock);
 
@@ -2607,8 +2639,12 @@ void dept_ttwu_stage_wait(struct task_struct *requestor, unsigned long ip)
 	if (!m.keys)
 		goto exit;
 
-	__dept_event(&m, real_m, 1UL, ip, "try_to_wake_up", sched_map, m.wgen);
+	__dept_event(&m, real_m, 1UL, ip, "try_to_wake_up", sched_map,
+			m.wgen, ewait_stack);
 exit:
+	if (ewait_stack)
+		put_stack(ewait_stack);
+
 	dept_exit(flags);
 }
 
@@ -2688,7 +2724,7 @@ void dept_map_ecxt_modify(struct dept_map *m, unsigned long e_f,
 	k = m->keys ?: &m->map_key;
 	c = check_new_class(&m->map_key, k, sub_id(m, new_e), m->name, false);
 
-	if (c && add_ecxt(m, c, new_ip, new_c_fn, new_e_fn, new_sub_l))
+	if (c && add_ecxt(m, c, new_ip, new_c_fn, new_e_fn, new_sub_l, NULL))
 		goto exit;
 
 	/*
@@ -2740,7 +2776,7 @@ void dept_ecxt_enter(struct dept_map *m, unsigned long e_f, unsigned long ip,
 	k = m->keys ?: &m->map_key;
 	c = check_new_class(&m->map_key, k, sub_id(m, e), m->name, false);
 
-	if (c && add_ecxt(m, c, ip, c_fn, e_fn, sub_l))
+	if (c && add_ecxt(m, c, ip, c_fn, e_fn, sub_l, NULL))
 		goto exit;
 missing_ecxt:
 	dt->missing_ecxt++;
@@ -2840,7 +2876,7 @@ void dept_event(struct dept_map *m, unsigned long e_f,
 
 	flags = dept_enter();
 
-	__dept_event(m, m, e_f, ip, e_fn, false, READ_ONCE(*wg_p));
+	__dept_event(m, m, e_f, ip, e_fn, false, READ_ONCE(*wg_p), NULL);
 
 	/*
 	 * Keep the map diabled until the next sleep.
@@ -2912,6 +2948,11 @@ void dept_task_exit(struct task_struct *t)
 		dt->stack = NULL;
 	}
 
+	if (dt->stage_wait_stack) {
+		put_stack(dt->stage_wait_stack);
+		dt->stage_wait_stack = NULL;
+	}
+
 	for (i = 0; i < dt->ecxt_held_pos; i++) {
 		if (dt->ecxt_held[i].class) {
 			put_class(dt->ecxt_held[i].class);
diff --git a/kernel/dependency/dept_internal.h b/kernel/dependency/dept_internal.h
index 3d1cd1a9b6d4..c02783ecf0c4 100644
--- a/kernel/dependency/dept_internal.h
+++ b/kernel/dependency/dept_internal.h
@@ -194,6 +194,11 @@ struct dept_ecxt {
 			 */
 			unsigned long	event_ip;
 			struct dept_stack *event_stack;
+
+			/*
+			 * wait that this event ttwu
+			 */
+			struct dept_stack *ewait_stack;
 		};
 	};
 };
-- 
2.17.1


