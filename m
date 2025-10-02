Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F568CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8120B8E002A; Thu,  2 Oct 2025 04:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72EC88E0022; Thu,  2 Oct 2025 04:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EDA8E002A; Thu,  2 Oct 2025 04:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 421D98E0022
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C9F3160366
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:15 +0000 (UTC)
X-FDA: 83952461670.20.6DA7838
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39F47A000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Ck/KxjFU6KU4MRMj4vOlc0JxeRu39ggk5r/OS4COIzs=;
	b=2wQmg6gCfovLpqoHlVaoiBB/LvytdfW9eGOV3ey6hE659h6FpO+Fgp3css9vecQtZvfqWq
	eeFFY0AhEJZYj/OHVhnClfL3WoF4+g+css3+t08wW14MLVe9miVZgv3FleCtuAoUsHT8gH
	5cJbpasLIjWBH8VrlZ0HedtM67JFa4w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392853; a=rsa-sha256;
	cv=none;
	b=wYr+KXBbEGKA2xAQ0UnWRdq8s0yrulkcpcBpuIMDR4jni7A60x8Kk2kA7BWP6F5vgcOrrK
	vZbsbNTzIvqulvF89Qg17DIBQaQHMdghDX0zvKxCe8ya8wMbS4YiUoVatsH8jnHqjX1wbQ
	3+/Wqn7ymJsoOdyKBldk37kwZS0Ce7w=
X-AuditID: a67dfc5b-c2dff70000001609-03-68de34118901
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
Subject: [PATCH v17 29/47] cpu/hotplug: use a weaker annotation in AP thread
Date: Thu,  2 Oct 2025 17:12:29 +0900
Message-Id: <20251002081247.51255-30-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSe0hTcRQH8H73PWlym4G3WVQLCaTMzOJADwqpLlZQ+Ef0drVLG02N+SiN
	Qi1Lq5VZ00qy+ciGW2VbD7W0MlrZEl0vV21TS1NJk6SZr2Fb0n8fvt/DOf8cBpe8J6WMKiFZ
	0CTI1TIqgAjon1qyMCjKrYwYsc2DNk8Ogj9jRTh48600/B75QoPpXiYGuo5OCgp7MwkYqDiL
	oPfFeuhve0TChKsbg9ahPgSdT08h8BYcgOulFgrGmppxKNS1IOip8uX3rG4EdYYsCrry7uPw
	rjMQ3nsGKGjUnaHgZxUF+qw6Eo6X3aGg4JqZgJr2WhrsP8YxcBbkY2A0b/Id93V3g6GosAeD
	N2VOAioyQmFCnwhWYzcNrvM6Am73N5PQ6P5IQtvLkyQ8zGinwfzpBYKcWg8B5m++ouRkOQFX
	ip0UPK5rJCDH+xuBtforBmer7pPgNk2QcKfbgYHN+oqA5tpbJNxotWPQ0e4gwdL0BoehcyHQ
	ckFLgiOvC8Gtn6XUajmf/dZL8aZiE+LHRvMRn53n0/O+AZy/Yeuj+FHPB4p/XcrxNVddNH+i
	/jPN680pvMUQxpc97sX4kkEPyX/+sZI3V+ZSm8O2B6xQCGpVqqBZtCouQFncE3GwXXRYa6lB
	GWicPo1EDMdGcZ7Gp/h/D3svUn5T7HzO4Rj5l09n53AW7XfSb5y1zeQ+2hf4HcRu5B4MWpHf
	BBvKZV6q9M0wjJhdxg2fD5pcOZszVk2uF/nidx02wm8Ju5TLHjiBTc7cFHFFOjTpGdwzg4PI
	Q2I9mlKJJKqE1Hi5Sh0VrkxLUB0O35cYb0a+X6s4Or6jGg22xDYglkGyqeKWUJdSQspTk9Li
	GxDH4LLp4jiDUykRK+Rp6YImcY8mRS0kNaAQhpAFiyOHDikk7H55snBAEA4Kmv8txoikGeha
	bNPiOPcefbHiOXk5V7n3eHpla3ntsUi1ISYspOkDCtQemRW9xPno3LSFc7Xb6i8LK8/Eh+dH
	r90RLR2ONW7Yqhr/wljqYnbG7FJ8vRpcXhIYbpxd3yP9tSVZatHSudXLDj1cHmFKds3csMbe
	lT6asg4bNe7O2mV/WZ0T+STxwWoZkaSULw7DNUnyv6WjRuZnAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUhTexjH+53z2zlnw9VpSR6sSBbjgmRvVDy9YP4RdIreKKG4l2ijTm05
	p21mLgp8G9mLL62m5LTMclfUajkbLbErxt29taTWSqNcyzCzcgnpKl+mbUX/PHye5/vly/eP
	hyFlLaJ4RqPLEvQ6lVZOSbBk65qCpJnLX6uXlHQsg668dgyhkSIMVTebKChqviiCJzcaEQRC
	RQi+jVtJMLmmMITNbhpGRl/RMNXmRlDuNZPQ1JJHwLB9koJP978gsPT2UVDxIQ/DkO0sgsp+
	Kw0f/t0AwUCrCKb87wno/jqIwNY3SUBf+0kE4fI0uFzroGC88zEJFZYnCK70+kkYsEfEFvdr
	BG31+RS8K7tNgq9vOjwLDVHwwHKGgqC3ioDPdgpq8ttEUG01Iyi4epOC8upmDK43d2nwfpog
	oKfcTEBj8xYI2PoxeMpqiUi/iOtWHFgrCojIGCDAcr2VgFFbAw2PrvZgsOUqwNrpE8Hb+koa
	JnqXwlRNBrgb39PgL7VguBF8LEqxIP6bqQTzDQ4nwZuehim+6VIT4sfHzIgfqSsgeVNZZL0/
	OETyhY6jfJ1nkOLHQs8pvu1rDeYf1nL8uc4k3lXpp/nCey/p7av/lKzdL2g12YJ+cbJSor40
	sCTzjTin2OFCuWiCPo3EDMcu576Hz1NRptg/uBcvRskox7IJnKO4XxRlkvXM5bq8C6M8i93M
	Ob+4UZQxq+DyLjREPAwjZVdy30tn/YqczzXa23/GiCNnX68HR1nGruBMQ4VEGZLUoGkNKFaj
	y05XabQrFhnS1EadJmfRvoz0ZhT5JduJiXN30IhvQwdiGSSPkXoVfrVMpMo2GNM7EMeQ8lip
	sr5HLZPuVxmPCfqMvfojWsHQgeYwWB4n3bRLUMrYg6osIU0QMgX9b5VgxPG5qHpP91hiSfBC
	aBynTMbYD/8/L9npyNmekprxvLLu7OzEoHZd17XhLeLuUafiP29qwj+BAx5uTWZCy47wqUNK
	Z9KJGUhITg3MXKU8HHMx/9Bw1SvZgs8f2c3+uJ2rNyYcT15falwwGDbuznrqUuC7M1z1yta/
	HcR6z1/bdMWZvtJ4OTaoVUsTSb1B9QMgdJtnRwMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: sp4cauuqexu14aghiyuo7s3scxaw8m58
X-Rspam-User: 
X-Rspamd-Queue-Id: 39F47A000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392852-166783
X-HE-Meta: U2FsdGVkX1/GmJHsbiaJEGnYGB52uc6ReW99NHz5UJfnhSLadDCo76GKQOI9ebQbgnTVrNiYtCXmo8XINvafsjQKFbeNttuE7tETIOZelPQhvLGk79iITr4fb5aCjWPgWFAiM9EvhWLgWUPJaGOnMUM/dw+IhA7UuXB0ws0uGJFCyWPhU3UpkcJccUxNimboXcEbTvM80hTOyr5h1KKmdXNhdzrCOqbEYJkacgOBClI02Szwe6RhtBkafyNWnb3Ul+uBOoTh0jaIHMaWXAYR8okHYRhuq8ktrwNUxHJlqe9lOE4X5BhLaxYQ11B6SSzqwlfM8vpehyTFs7JTGVcnPLAqd1fp4vGBZOqu1tu2LKBhr9nJDhijTgTlCTvppqjafBNod7elSHxlldAW2qKZizAs+9BTg6PsUgcH94e7cvCBy4n+ooOXW6UA3+EBxAKEWGF/0t//tUzczBngTKGI13m1LVvyA9CGYZsG3o1wfkpTxOdPt+BK99JuCCJfWPFtWdb4slGEN4KWHvGJSF0FhDaK7jC03hy6ZgPcQgUEhISiTXr5XbcmtsmurhkTDDbPyKYhDEbqaXC6/W99VwD7VKNHi3PXkPkZfuaDiTXqsnVzsbHCNVYI52hQCvPxRLCa7pz7es6iTG/dOdYYB2cEZ9fDMAZdRIIaUe9vcGClH+2fWtdn+1rHoYAI6dMU6w/J+KAlIK1ddQl1gfoUJyWHtm4mNzLDSeDvo+tXwya5+FTwSAro4/U1+6TnaOGUdrGtng/H52V2/NSoOS5t9zIoGtMppwaOKM8jjLdvHs08L9gOURAWZbwoJ5qrBGLW1XRo8UN/SvLCSa0LSDSEbIdkEawAZdq94OUCO5JnLbSxWQRG+Zav9/1ORdFuC6hSzLLzZXd9vCs4xro81n7jrVZHJTTlv510a8ROGM0vNsuuQ64kecMiAI2rcdewa99M1Vtl3uqsrI2zNkdx3DmnSGn
 VKO+/Hjg
 Q7ZA2IQ7GgcRqH8OmAJbYQNn3X52dXRBQl0erQxxQ9rxIWGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cb92173d1f0 ("locking/lockdep, cpu/hotplug: Annotate AP thread") was
introduced to make lockdep_assert_cpus_held() work in AP thread.

However, the annotation is too strong for that purpose.  We don't have
to use more than try lock annotation for that.

rwsem_acquire() implies:

   1. might be a waiter on contention of the lock.
   2. enter to the critical section of the lock.

All we need in here is to act 2, not 1.  So trylock version of
annotation is sufficient for that purpose.  Now that dept partially
relies on lockdep annotaions, dept interpets rwsem_acquire() as a
potential wait and might report a deadlock by the wait.

Replace it with trylock version of annotation.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index db9f6c539b28..285d7fa55523 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -538,7 +538,7 @@ int lockdep_is_cpus_held(void)
 
 static void lockdep_acquire_cpus_lock(void)
 {
-	rwsem_acquire(&cpu_hotplug_lock.dep_map, 0, 0, _THIS_IP_);
+	rwsem_acquire(&cpu_hotplug_lock.dep_map, 0, 1, _THIS_IP_);
 }
 
 static void lockdep_release_cpus_lock(void)
-- 
2.17.1


