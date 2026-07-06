Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A92C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B031F6B00E3; Mon,  6 Jul 2026 02:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3556B00E5; Mon,  6 Jul 2026 02:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906A96B00E6; Mon,  6 Jul 2026 02:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62E2B6B00E3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE9D41C7968
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:52 +0000 (UTC)
X-FDA: 84957353544.05.051FC3D
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id D819320002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=obX6cRC5Tjpyj6hWhUuMw5KAfJISgGU5/rRdfNSec0E=;
	b=MWP6T/VhRInJpf6+cxVCfwngLZf65T3LKTqiLB4KGmWjBVEwHMml2cAZ7TPyp7Zz/L/H99
	BalntZsTpuHaTguVjKb5RVNC7vVFefeDGMDGH6ZhmHWEi5+ql2xm6kL15IQHsiADeyMthN
	9bjmlR3E0DdQfP/g1oe2itFJRT0t1CI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318851;
	b=hVB3hSKk9rUFL7LgdHknuZQns0quIE0vDoIzYcNaMb9eOLz4lVQ0CD2QR32ERUI8Ilu3Uc
	G5V+qeXkHQNyzBRkj8lPP8cm3iJnG/0Kp+QEOApLyYrhD4PCFokjN3O2lF6eBSACqRkBnr
	5oC6fRkaKSwMT4X9vyE2MI8jRINfD5o=
X-AuditID: a67dfc5b-c2dff70000001609-b4-6a4b4904580f
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
Subject: [PATCH v19 29/40] dept: make dept aware of lockdep_set_lock_cmp_fn() annotation
Date: Mon,  6 Jul 2026 15:19:17 +0900
Message-Id: <20260706061928.66713-30-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTHfe597ks7G28q0Tt0wzUR0cQyNjBnyaJEk3mFkZD4xYwPoxlX
	KQKSggyWbOKkikWapoTiFLTdpAotpamwAoovIIhkYUy25Iqi7TZRlLcUqgIVLBC//XL+5//L
	+XBYUilRkaw2t0DU5WqyVbQcy8dX27ZT+5KzPv3DGA9l+mNQ0+SkYcDlQKBvW8Tw1tzDwMzs
	QwYWO3oQWP4ykyAN3CRh2r1Aw8uuAIJzI+fD6fAzAuz/LxDw1nIYXlqmaAiM+hA8NbWQcK+q
	nIYJNw0jQx0EWGo9GNp87Qw4PCnwxD6CoXqUhvPVJwioarxGwKy9gQF7yWYI+ePANf4nBd4S
	HwO2k5cwXO+4h2GwvYaGx85FCpqeSQT4fRIFkukpgsaJX2l4UD0WrgcnGbh/y0pAj3UdtNzU
	I6ibmSDhRpmPgDtNXgLqroxT0BUcI6DyvpWGueFWCvrm+gj41zjOQFWoLHzScSOCcr0FQ+mj
	BDD274U37v8oqJ2JgxlHQzjvfswkJgqv9UYsOC84kTA/Z0ZC19gkKbSdG2aE0htDjGD1HBV+
	uz5KCLZAkBI8DadpwRMwM4Jt/jkpTPT3M0Lv2XksdHaVIaHN/0Xqx9/Iv8wQs7WFoi52Z7o8
	88wDL5U3F11Ud+00LkE/RxmQjOW5eP5UuYN4z8NVF5eZ5rbwkjRLLnEEt4m/WjFCGZCcJbnB
	KP6MvQIbEMuu5Q7wTS2xSzuY28xbXlTSS6zgdvCLwUvkijOKd7hvLbMsPHeFapf9Si6Bfzh5
	Fy85ec4h4483NjMrhQ/521ckbEIKK1rVgJTa3MIcjTY7Xp1ZnKstUn93JMeDwv9m/zGU1ooC
	A/s7Ecci1WoFJCZlKSlNYX5xTifiWVIVoYiOSc5SKjI0xT+IuiPf6o5mi/mdaAOLVesVn736
	PkPJHdIUiIdFMU/UvU8JVhZZgo4tsOqDfc/X/0MbIpu5vw/tKYqI3q9wu0567xw015+w9fYa
	Q/5SbcpUTFGlKymt/uvaVPUeQ8/GnZcNxXu3RqVNbfI6y5MLDbtMCRt264MuVsSfEHlPkqb7
	8tL9Fc4PbhvV7Y9+GvpKhtZIp0ze7voLMa8/n1YxZ83c77/QH7WqcH6mJm4bqcvXvAM4Wnkk
	awMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSW0wTeRTG/c/8OzNMrJlUEifwgGlcMRtBjZecROPlQRkvu/FB48YHpdFR
	Sgtiq9iaGGlrFRF2a7UlUtCK0ChUQaoiYiNCwHvkpqKA0KSiCIgolVAotWj25eR3vvOdL+fh
	MKSsWhLDKNMPiZp0hVpOsZj9e6UpAW/cnLrYdzMRss3HoavHL4HXhjoMgdFsDIUVbgpCjmoa
	sqsuSODxGyOG5hvlCHoC2QjGJhwkmGvCGELWJhpGxztpsBkQhL1NCOwtVhI6mh+Q4L5lIOB7
	5RQFAw3fENh8fgry+w0Yhl25CAr6HDT0NybBUE+tBMLdHwl482MQgcs/RYC/7hSCkF0Fl4o9
	kXX7VwomXrwkId/WjOCyr5uEb/29CG41vUfgvWqk4IPlNglt/lnQHhim4IntDAVDLYUEfKmk
	wGn0SqDl+QCCIocVQd87LwGmKxUU2IuqMNT03qOhZWCSgC67lYDyqr+gx9WH4ZmlmIicG3Hd
	nAOOfBMRKZ8IsF2vJWDcVUavLUXCmPlfLJR57hCCuTVECe6LbiRMBK1IGC01kYLZEmkbBodJ
	4YTniFD6bJASgoFXlOD94cTC02JeKDkdJISzLxKEmoJueuu6neyqvaJamSlqFq1OZlNy31ZL
	MoLzdaW1p3EWMsbloCiG55bx3bZLxDRTXDzf0TFOTnM0N5f35PVJchDLkFxbHJ/rysM5iGFm
	c//wFbcXTXsw9wdv/3yOmmYpt4IPB0rI35lxfHll3S+Oiug3Jot+5cu45Xzn8CNsQawTzShD
	0cr0zDSFUr08UatK0acrdYl7DqRVocg7uY5Nnr2LRtuS6hHHIPlMKazdlCqTKDK1+rR6xDOk
	PFo6f8HmVJl0r0J/VNQc2K05rBa19SiWwfI50k07xGQZt19xSFSJYoao+X9KMFExWcjSsLhT
	FU6tIWdkGT/H599Xzx2x6ra1qupikxrXXI1t31By0KAfowKMacsd57zVGXovvy50/5wOxWgV
	U41LY5K17c89H7p86z9KvxTWsrrzCa6t233O3u/0gyvsiGfXfyczRxZee5vXui3uYH38w4L9
	ucf2zaTZx8HtQx5Pu9svx9oUxZI/SY1W8RNXjqH7SgMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D819320002
X-Stat-Signature: j9d4677j4itif9i5tange8z5u9s9k1xy
X-HE-Tag: 1783318850-473091
X-HE-Meta: U2FsdGVkX196b5HEHnrzxQd6IvOwF2y2oUe7OR4n3wPVpZYeiNnTCR5b6/QJlAqXI+K5hIxY8SpGlXai2hB5K2GX55sxTEv0DaYh0guzLXEPmQY5VBsH2yQW00RFKaiQTfTywG0yBj0XSGPsVxqEG94LGPzwH28Z6BWZFifZdxgpa+b6WiBgSDcSfPY8PnuGVVRCMBS3Cyc+JPiLkta5gQ8mveNRbGd56BtnGIQW+jqImcw/xjtH9UE76mscCJJIEKKVxF7nHRNEaEYE+cM9uMGySS8XioEHoAmSrAK/aUGwFmQB1xot7XxS/7wCEUDZ3fUUHvaJZ1dkXCAUyQVsbtp3n9s2OiYrIkjIOqLu9lwrkQXbFaj5fyyo84jXMt6LTPHQpHU2VzFYHqJpLOOYuevLgZkrcUjsSue4MyfzYKSRLU7Q6UV1VEA2eH/BxseZs9lBbiFVf9XiMcozF7/2Qro6NJrSc2MBoZu5XFAvjZbKUQoQ+xp+OqKugAXCJx4hpQyByGg+ma5K3hm0n8eAl1LxQwWZEKfobntd7pcTlaj6WLCk32CZjuNxEN1m29mJ6g7ybzkFlgd/UnVFWH30FvAm8i+RXKgAM28mkyS3Z2NIEITER/REhKlcI3agvDl3EQ7VR/43pURzbSM1hVo+pcVw4h3US134k/9PYAa6NMTIb4DWil7Lo7Jt7N2oGqy1MGK8DeZ1wc4ExjQM4J7DbQpDnMNbtTXIi7pj0/4ILHkmhG5odXRU0Fq3d5tm4/cZajU8wurHmwJwGXsgs9YHr33JlBrBbK+nsJLjCCd+kfb4zHTbKTmbtCnM9rrSLrwgLFrTCpWfb0X9sDiObS0ALea7wfkLKpKhGPY9hqmw8bbwPrDfshhByybnMdTSJmDzdOfXGJtIxPBNgxkD+tiH/NYN/ALIL5yGU45MNNMl5q0E0KPF+CRX4G0H8+nm9awPyjwsJzoTQo2W3ucxKHp
 1Il++Wfu
 gqtmbf9EUxe+hsyEfByDWyfIS+oY9VTxeDJCWiwUQmVns3pZQcSC2eluV9Ue5hK82M11q0TGeWs0O3/rS2qGlKfpMuLSZ6h1pYtJjqhtnkUGPIGOP0wK3Ls7Hnq0s1OHyiQSx1vEg0GUnAfv/16M3QIr4K1SWZ/H4ktmRARDZ/MnMeWbB/Vcndrzk+ya+REzDpbaI0MfhLEf3+SQlErlgAu1dJ51T+y83kHWt2rUr4A7LzAoOfGg7frMnYBzoJdj8hBCGajYDhtccEKbwm25juHZN0+P9elPNBBqf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit eb1cfd09f788e ("lockdep: Add lock_set_cmp_fn() annotation") has
been added to address the issue that lockdep was not able to detect a
true deadlock like the following:

   https://lore.kernel.org/lkml/20220510232633.GA18445@X58A-UD3R/

The approach is only for lockdep but dept should work being aware of it
because the new annotation is already used to avoid false positive of
lockdep in the code.

Make dept aware of the new lockdep annotation.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept.h     | 10 +++++++++
 kernel/dependency/dept.c | 48 +++++++++++++++++++++++++++++++++++-----
 kernel/locking/lockdep.c |  1 +
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/include/linux/dept.h b/include/linux/dept.h
index 827ccc1890d1..f3cc7566ddf2 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -53,6 +53,11 @@ struct dept_map {
 	const char			*name;
 	struct dept_key			*keys;
 
+	/*
+	 * keep lockdep map to handle lockdep_set_lock_cmp_fn().
+	 */
+	void				*lockdep_map;
+
 	/*
 	 * subclass that can be set from user
 	 */
@@ -79,6 +84,7 @@ struct dept_map {
 {									\
 	.name = #n,							\
 	.keys = (struct dept_key *)(k),					\
+	.lockdep_map = NULL,						\
 	.sub_u = 0,							\
 	.map_key = { .classes = { NULL, } },				\
 	.wgen = 0U,							\
@@ -179,6 +185,8 @@ void dept_softirqs_on_ip(unsigned long ip);
 void dept_hardirqs_on(void);
 void dept_softirqs_off(void);
 void dept_hardirqs_off(void);
+
+#define dept_set_lockdep_map(m, lockdep_m) ({ (m)->lockdep_map = lockdep_m; })
 #else /* !CONFIG_DEPT */
 struct dept_key { };
 struct dept_map { };
@@ -221,5 +229,7 @@ struct dept_ext_wgen { };
 #define dept_hardirqs_on()				do { } while (0)
 #define dept_softirqs_off()				do { } while (0)
 #define dept_hardirqs_off()				do { } while (0)
+
+#define dept_set_lockdep_map(m, lockdep_m)		do { } while (0)
 #endif
 #endif /* __LINUX_DEPT_H */
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 5bf32633e1fb..048348ea64d2 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -1615,9 +1615,39 @@ static int next_wgen(void)
 	return atomic_inc_return(&wgen) ?: atomic_inc_return(&wgen);
 }
 
-static void add_wait(struct dept_class *c, unsigned long ip,
-		     const char *w_fn, int sub_l, bool sched_sleep,
-		     bool timeout)
+/*
+ * XXX: This is a temporary patch needed until lockdep stops tracking
+ * dependency in wrong way.  lockdep has added an annotation to specify
+ * a callback to determin whether the given lock aquisition order is
+ * okay or not in its own way.  Even though dept is already working
+ * correctly with sub class on that issue, it needs to be aware of the
+ * annotation anyway.
+ */
+static bool lockdep_cmp_fn(struct dept_map *prev, struct dept_map *next)
+{
+	/*
+	 * Assumes the cmp_fn thing comes from struct lockdep_map.
+	 */
+	struct lockdep_map *p_lock = (struct lockdep_map *)prev->lockdep_map;
+	struct lockdep_map *n_lock = (struct lockdep_map *)next->lockdep_map;
+	struct lock_class *p_class = p_lock ? p_lock->class_cache[0] : NULL;
+	struct lock_class *n_class = n_lock ? n_lock->class_cache[0] : NULL;
+
+	if (!p_class || !n_class)
+		return false;
+
+	if (p_class != n_class)
+		return false;
+
+	if (!p_class->cmp_fn)
+		return false;
+
+	return p_class->cmp_fn(p_lock, n_lock) < 0;
+}
+
+static void add_wait(struct dept_map *m, struct dept_class *c,
+		unsigned long ip, const char *w_fn, int sub_l,
+		bool sched_sleep, bool timeout)
 {
 	struct dept_task *dt = dept_task();
 	struct dept_wait *w;
@@ -1658,8 +1688,13 @@ static void add_wait(struct dept_class *c, unsigned long ip,
 		if (!eh->ecxt)
 			continue;
 
-		if (eh->ecxt->class != c || eh->sub_l == sub_l)
-			add_dep(eh->ecxt, w);
+		if (eh->ecxt->class == c && eh->sub_l != sub_l)
+			continue;
+
+		if (i == dt->ecxt_held_pos - 1 && lockdep_cmp_fn(eh->map, m))
+			continue;
+
+		add_dep(eh->ecxt, w);
 	}
 
 	wg = next_wgen();
@@ -2145,6 +2180,7 @@ void dept_map_init(struct dept_map *m, struct dept_key *k, int sub_u,
 	m->name = n;
 	m->wgen = 0U;
 	m->nocheck = !valid_key(k);
+	m->lockdep_map = NULL;
 
 	dept_exit_recursive(flags);
 }
@@ -2366,7 +2402,7 @@ static void __dept_wait(struct dept_map *m, unsigned long w_f,
 		if (!c)
 			continue;
 
-		add_wait(c, ip, w_fn, sub_l, sched_sleep, timeout);
+		add_wait(m, c, ip, w_fn, sub_l, sched_sleep, timeout);
 	}
 }
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 39b9e3e27c0b..c99f91f7a54d 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5035,6 +5035,7 @@ void lockdep_set_lock_cmp_fn(struct lockdep_map *lock, lock_cmp_fn cmp_fn,
 		class->print_fn = print_fn;
 	}
 
+	dept_set_lockdep_map(&lock->dmap, lock);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
-- 
2.17.1


