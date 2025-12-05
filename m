Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3152D2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517D56B0107; Fri,  5 Dec 2025 02:20:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1A06B010A; Fri,  5 Dec 2025 02:20:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231256B010B; Fri,  5 Dec 2025 02:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB7366B0107
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA00051ED9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:08 +0000 (UTC)
X-FDA: 84184568496.12.06C4E89
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id D9A7840002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=WArLovSFXaT8otVlpV7KIF50R+FCcBURwHrSO1jZKQs=;
	b=fTILq7kAVBU0nM+o+IRZRotHReHR8ZMUpfOxcCKyJZ04gMHYTmTOhwPWEhBPn0/F5ihsFW
	u1dhc2u7hhxjmGEuCWsqH6w7th2+0z60DC3XFfjwfFy297pR+hhz0VNis0dXt1Oa/1Pd00
	p9GTlf4f0ftzzNGEk6zzqM3VGJSxGn0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919207; a=rsa-sha256;
	cv=none;
	b=mczQigFQQRwggLcWWQFYJ6LEZsM5GeAmU3uz1S+1/a/Or6uYfEZ0Ly7vdTCeOZIzigwbuK
	3QFwbYQx49IaRHFBAfgg9f5MOPbDGMD82JTmRisLVrCRA13qPzFSqGvAFTbqpfa3ELa3p5
	IHoV6fHNsdCwfBXzHxC83aNZr8f5cjE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-fb-69328776f97a
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
Subject: [PATCH v18 42/42] mm: percpu: increase PERCPU_DYNAMIC_SIZE_SHIFT on DEPT and large PAGE_SIZE
Date: Fri,  5 Dec 2025 16:18:55 +0900
Message-Id: <20251205071855.72743-43-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxTG/d/7v/97Wym5qSZcXxKXJpsJURSj5sRsuGRbcvdhyZJ9cHEf
	ZpUb21iKaZHKlmW1QqiICpi2kSIWHE1Dy1sr42XWVWCMhhGLKO2QqrwEcUJIHIUAug5q/HLy
	y3nO8zxfDkcr48x2TqsvkAx6tU5F5Fg+n1a311R6QLvf0bsTrCU/w+iFEIbEohVDTYuPwFtn
	BwtW/w0GBqIWDJFmL4JnCSuC5TUnDYsrT1iwD1fREIv8ToPvzgUK/m39j4BtYprAgrscQTL+
	goLo0hyC6VApglv1AQJrQw9ocNgiCOom4jQEPRYCI9Pp8CixQCBsu0xgfriGApclyMBNZxWC
	mbEgBeP2Kgq8/q/gmXsGw2BFPQX2tgxwOi5S62OWAlvTbxT8dXscg3NohIFJTzULSVc+xK/Z
	MISfjjLwaqaKQIf5OQv+v/9AYO1OYPBPrQs3ascJ3A2GMfR3TlIw0l1DoLy1nYGnviQDkdAg
	Aw+9kfXW/gEMT4ausfCgu4mBhugwBRPPY8ynueJyyVUsNgZ+pURfrQ+Jiw0XabF3boEWiwMm
	sWFwjoiricdEDC65sFg5tFfsqo6zYvG9MVZ0+c+JxX3zjBjwZIq3776kvt5zXP5xrqTTFkqG
	fTkn5JpYX4w52y4732FNsmY0yZYhGSfwB4WBvivkPffXO/AGE363EIut0Bu8lf9ACFyZYcqQ
	nKP5kV1C6crVlLCFl4RZuzllxvyHQlN5OGVW8IcF28tJ9C50l+BtDaXuZRv76GqKlfwh4VbZ
	cipU4J0yYba8hH5n2Cbc98RwBVK40KZGpNTqC/PUWt3BLE2RXns+61R+nh+tP537pzffdaLX
	kW96EM8hVZoiZMrWKhl1obEorwcJHK3aqpjT7dcqFbnqoh8kQ/73hnM6ydiDdnBYlaE4sGTK
	VfKn1QXSGUk6KxneqxQn225G7potwyVjGhC8GTms55d9n3Vpej9J78xyN/dMOSrc1WnZqjbT
	yYKjdZUn9B+lWwQCx/484iGXfBa1S3XY3XI0Th0/FD0SzuHunPyn6HTbjkROx+iXjaXXN08t
	X+6yD67KpNrmH1vGVZWZyUdGs2J14Fv//fb0S19cn/h8bU93lwobNersTNpgVP8Pisz1+XAD
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa2yLcRTG/d9rVyqvGnszH9CwicxtMTlxJ2FvJERCIi4LxctqbdHabBLs
	olkNSzXa2boxZSW728VsNGZY3LWG1WXK1Gg2m0y3pe266Sa+nPzOeZ7n5Hw4Alx8mwwXyJRH
	eJVSKpdQQkK4YUnGnKTMaNn8CnsoaDUn4ZPTRcK7tEYC+jxaAvIrSikImOpo0FblkvC4NZ0A
	W3kJAmefFsGA34SDpn6YgIC+mQaP9yMNhjQEw9ZmBEa7HgeH7R4OpTVpGPypHKKg80EvAsNX
	FwU57jQCeixnEeR1mGhwP4qFX847JAy3/cCgtb8LgcU1hIGrMRNBwJgAl83VwbjxNwX+F69w
	yDHYEFz52oZDr/sLgprmzwisN9Ip+K6rxaHFNR7e9PVQ8MRwhoJf9nwMuispKEy3kmB/3omg
	wKRH0PHBikHG1QoKjAVVBNR/aaDB3jmIwSejHoOSqvXgtHQQ8ExnxoLnBl03w8CUk4EFy08M
	DGV3MPBaiumVRYgb0GQTXHH1LYzTvA5QXOmlUsT5fXrEeYoycE6jC7YPunpw7lT1Ua7oWRfF
	+freUpy1v5DgnppZ7tppH8adfzGHq89rozeu2iZcupeXy5J41bzlu4TxjocO8lBtSHKddphO
	Re10FgoRsMxCttmcQ4wwxUSyDocXH+FQZhpbfa6DzEJCAc60TGUzvdmjwkSGZ38aU6kRJpiZ
	bNnZJ6NhEbOINbjb0b+lU9mSysZRf8jIvNU3ymImhr2cNUDqkLAQjSlGoTJlkkIqk8fMVSfE
	pyhlyXP3HFRUoeA/WY4Pnr+NPC2xTYgRIMk4UePRBTIxKU1SpyiaECvAJaGiLvl8mVi0V5py
	jFcd3KlKlPPqJjRFQEjCROu28LvEzH7pET6B5w/xqv8qJggJT0WTFIH77pjV3rjT7mX73m+d
	3ss1dK/1r4xesSb5W/a4qN7N/gNXdksvSmyxm8oPM4P32/s9WkVuuG7D7O113f7oGWz4btOJ
	6/aauO4hItJ71//YnFtg8/AlLy+caytq3aFR7kkMy4xQRhCzJvgaFua9ipoxdrLhuPremkQn
	u1hdliAh1PHSBbNxlVr6F6fDGrJLAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9A7840002
X-Stat-Signature: 1qxprtp3ix5rbuuezk1j51kfqsiketku
X-Rspam-User: 
X-HE-Tag: 1764919206-593622
X-HE-Meta: U2FsdGVkX185slNVBAh5kqspFe/eVGgvooab+Ecnd7YdiB4262oPxfnxIAcoDMw1BBVgCNfWi8K2BMJTAZNeRXE7CAfdP/Pl43ikwNfbRRtphCz3Ry2Cm+ab5e2S8iZAGzT9kKFalcY6wZ9DVg4iV6vYEDxc9vgnOUcvGfA5M2yRQlrChYmTa0Sd2nLOkAws6AiZbdIuMqnmg0yQFDkawYxkHvTAoVeorEBFaBVummpWoV/FXiAPUUP1OJXhgqDnCyQnU4wurtSgrORjDizTl1NA3yXRh3UKC3vQzIxK0mkX7TrxQN83vajECnA9FKRgHiOsNXMwzd5MeHLmhypJzEyRMY81w9HNlRAc8ZwaeqeNR3mJ/tnigb1VArK6bQz0/pAoI/pW3uT/6ECcFJOSaWLhS1SFG22DUhtPBPQ3c2MHQS8oyvIu3yMMAp+NozfQvgFaC3NTKaJzdhi/VU2j/anRjwJxLmYK1BqKKvrqjB1TXvbCiBu8tOQg4c+wI48xlPWlu3yJhSndm2ZRKTjZjXES2ZE1dKrh2v32zuwVA5xrjB3UTV6XCNaRZgxDkKiCfLwCawG58ON4atV336DcHFPqh2VlUZtYQNB6wOBlutJc+tp7qa/SmkvqM0EbAM1lXkyhCJUhuGZY02ztQGCy5BpQdhQEg8CjHYtkdvn73dA9cob/9giTxqqbWOmQ5omhsHjkFubmdfnTmd4p6xUTroFoc248oAoaj59/emkfTauO0UFRoWkPLIJKu5kRdpaIvPXja9O5bmGTs8jq4wqHB88uTL86aJRLyIILcINwrpEyLKc5sAEdEifJ8DipxITXEXYe+n8uucBwJuYeFxGJHwYyGiSrcEbKqfHRECC30L6sydmdk2CjsGFlsaUx8EeoHkydMGGiuwqahOiykqEL/Rq83K5uClkVreWnDL2bFL7gXPDEz+CCmMGVqeiJ2IQWVTwZkwxWfqcdzstWtZe
 XWAExd2j
 EYD73W0mUowKoGCdeC71JMnhQsqKz4YIZac2E1NeiGKbT+xlxn0NHZ2OGRE2jlH1pyq1fFKxqvowNon1IgmqwE+GgLkgVz5UAC33hbnFXOCnfuU2F7qnLOJk0+Htvjet+7TTS4lrydfmRpb0PvEni8eWQ/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yunseong reported a build failure due to the BUILD_BUG_ON() statement in
alloc_kmem_cache_cpus().  In the following test:

  PERCPU_DYNAMIC_EARLY_SIZE < NR_KMALLOC_TYPES * KMALLOC_SHIFT_HIGH * sizeof(struct kmem_cache_cpu)

The following factors increase the right side of the equation:

  1. PAGE_SIZE > 4KiB increases KMALLOC_SHIFT_HIGH.
  2. DEPT increases the size of the local_lock_t in kmem_cache_cpu.

Increase PERCPU_DYNAMIC_SIZE_SHIFT to 11 on configs with PAGE_SIZE
larger than 4KiB and DEPT enabled.

Reported-by: Yunseong Kim <ysk@kzalloc.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/percpu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 85bf8dd9f087..dd74321d4bbd 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -43,7 +43,11 @@
 # define PERCPU_DYNAMIC_SIZE_SHIFT      12
 #endif /* LOCKDEP and PAGE_SIZE > 4KiB */
 #else
+#if defined(CONFIG_DEPT) && !defined(CONFIG_PAGE_SIZE_4KB)
+#define PERCPU_DYNAMIC_SIZE_SHIFT      11
+#else
 #define PERCPU_DYNAMIC_SIZE_SHIFT      10
+#endif /* DEPT and PAGE_SIZE > 4KiB */
 #endif
 
 /*
-- 
2.17.1


