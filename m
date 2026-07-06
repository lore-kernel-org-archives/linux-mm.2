Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0621BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E456B0100; Mon,  6 Jul 2026 02:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44EAC6B0102; Mon,  6 Jul 2026 02:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315266B0103; Mon,  6 Jul 2026 02:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E18B86B0100
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:22:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58E2C402AC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:10 +0000 (UTC)
X-FDA: 84957356820.17.5B09539
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf31.hostedemail.com (Postfix) with ESMTP id 730D720002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=WArLovSFXaT8otVlpV7KIF50R+FCcBURwHrSO1jZKQs=;
	b=ymJzCN96eeOgaDB5WbGsYhAL+oR7nPgIIBeeBltx/0gOvV6PJH4oe1ZETaNkTC/UsU+mpj
	/TQP3zckosPLPoofDI//RyxpbFjkT414GKKrr83/TlyypIMuPY0uJ89wjnFXrfc3AFL+qW
	RCztvjWr1b9MQ5yMooKoNQ7JO2UGFG4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318928;
	b=nDfMkZn7wNYfOX744xFxZDPY41XJLN/qeoFTWEM4zkU8mnUQ1S2GuGSaJCXQOnFeDX9v8v
	usSSylRDNcD/SXTPKPj522Uo9iTeE5VIBmxYrS4xo1ZjMN8dWkfwADaIQMqu7T1eOi9YxH
	DQLfcPAuvdwLuTlCc0mR/IrVIp/TYL0=
X-AuditID: a67dfc5b-c45ff70000001609-3f-6a4b49849c85
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
Subject: [PATCH v19 38/40] mm: percpu: increase PERCPU_DYNAMIC_SIZE_SHIFT on DEPT and large PAGE_SIZE
Date: Mon,  6 Jul 2026 15:19:26 +0900
Message-Id: <20260706061928.66713-39-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxiG957znvecNtacdYQdNQum+4xRxMnMk2USFuN8nT+mWaLJzDa7
	cQblozQtMDFZ0k4wgsJcN8tGQUWwMqiDHBQU3GRMhMBgtjWs2zpwiN2wtrgiGBmIrcZ/V+4n
	133/eQRW+we3XDAYC2SzUZ+rI2qsDi+pW1OydVt2yuDB5yEwNsHBiK0bQ02Lm8CCs4OH/t8+
	x+Dw2Flwn7UxUB108jDZuwXCY10cLDhy4PjJNgIhxx0C0cnrCM5eGUXgm1gK12amCIQ9NQxE
	Wgl4fgkh2F/fQiDgsDNQNUnAWbWfgaNnuhi472riwTnk42C8sZqHDut1HpTfexEoN0Y4qDvQ
	gOHbYwECvs4aAqPuRQ6sznsceJuvYhi80o/h184zHMxWroCvIkEEoVkXC66ZKR4a/6viwB6M
	8hBtmMVwYPoBB30V3QycuhthIVB5C4PiHiHwT3UtAz/P3GZg7nRsdqh9gIeBuQEGxivDMbc2
	pjV7MBwqdWA413uPB9v0GILK4S0QOXKXS0+nTW3tDC31LhDqPuZGdOCkRBvK5hh6ofovnp5Q
	CmnJ5TBH2xpX0fqLkwxVmsoIVaJ2nkaGh3na/83/mNZZj7L0Uq2b3570nvqNDDnXUCSb16bt
	UWf5L/s50znV3o6Di7wVjfPlSCVIYqrktV3AT7i9rITEmYgvS37/fTbOCeJKqa0iyJUjtcCK
	viTpsKvikfCMKEs/lJfHBEHA4otSV2dhPNaIG6TI/EXyuDNJam7tftSjiuXfz9cycdaKr0l/
	TvXheKck1quk2xMu9FhYJv3U6MdHkOYEeqoJaQ3Gojy9ITc1OavYaNib/HF+noJiH+f6bH73
	eRS9+m4PEgWkW6KB9LeztZy+yFKc14MkgdUlaF56ZVu2VpOhL94nm/M/NBfmypYetELAumc1
	r85+mqEVM/UFco4sm2TzkysjqJZb0dovXtC8szLz72uZ9g3eVrXm9WWHMgwfpKYV7Fxa9hFZ
	Fw2V7Ej8zptTurGu/f2EXcV9N01D3q9/rDm/UxpPtHhWbzYb9wVNWxOV0fSUqaeHfY7U5Oeg
	8Fba4HqGDrp3v5VmCixuWj2xJinlXyWUcPzSJ8g6bbJV7NiT38J/uf7Nzad02JKlX7eKNVv0
	DwH5ZkU2bQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzVSe0hTcRjtd+/dvdfR4rKELvaHMehBYVlkfJGUBdXtSRER9E+NvOTcQ9vK
	shJ1a7jspYtNalpmbuSjtFmZ2cisLHu6LBvpmtqaia+wLdHNbCv65+N853zncP74aFxcL4ih
	ZarDvFolVUhIISHcvkoXp9u0JTX+qzsRDPps6PJ4BdCR20RAwG8goLimmoRJSz0FBvslAbz4
	pCWg7VYVAk/AgGAsaMFB3zBFwKSxhQL/eCcFplwEU44WBGanEQdX2yMcqu/kYvCz9jcJA09G
	EZh6vCQU9ecSMGI7i+Cyz0JB/7ONMORpFMCUuw+DT78GEdi8vzHwNuUhmDTL4WpZXdhu/kFC
	8M07HIpMbQiu9bhxGO3vRnCn5QsCxw0tCd8K7uLQ7p0BHwIjJLSazpAw5CzGYLiWhFKtQwDO
	1wMISixGBL7PDgx012tIMJfYCWjofkCBcyCEQZfZiEGVfRt4bD4CXhWUYeG64avbs8BSpMPC
	4zsGppuNGIzbKqkkK+LG9OcJrrLuHsbp30+SXPWVasQFJ4yI81t1OKcvCK9PBkdw7lTdUc76
	apDkJgIfSc7xq5TgXpaxXPnpCYwrfBPHNVx2UzvW7hUmJvMKWQavXrJ6vzDF9dQlSL8bdaze
	MEXloF4qH0XRLLOcvXf6FBnBJDOfdbnG8QiOZuawded8gnwkpHGmPZY9aztHRISZDM868vPD
	BpommLls44MjEVrErGCHQw/Jf5mxbFVt09+cqDB/K1SCRbCYSWA7R54TBUhYiqZVomiZKkMp
	lSkSFmvkKZkq2bHFB9KUdhR+J1tWqPA+8rdvbEYMjSTTRZC0OVUskGZoMpXNiKVxSbRo3oIt
	qWJRsjTzOK9O26c+ouA1zWg2TUhmiTbv4feLmYPSw7yc59N59X8Vo6NictAyEZaVt3Nnh7xw
	fUJv4/mYjF0T3YduKw3HF4H80EqVOsGv7RyuiXOfLN/9NqAqr0jTC8dHK8ou1CqslfVDwTyt
	8sTFMd9QcYfu6tr4E6HW71uTe6cH12zoGNU692YvDF4p9cRUJD6yX5gZ30z09fGPuxwzrPTD
	n3lx7zVt69IcEkKTIl26EFdrpH8ALUQrlUoDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 730D720002
X-Stat-Signature: tjdeuductkstpf75nob9dp7ggf7qytaf
X-Rspam-User: 
X-HE-Tag: 1783318928-891527
X-HE-Meta: U2FsdGVkX1/8ZWMl6/u8xAEu0DmI0o61uImwZuwCEHbUU3qZtLJ7wO49fF7YVFJn3HFn9jS63aS0RNUL68+nQZ/ZuKgEqvCmAh1aUsnx1IwalMFfYLu5Tpq6sWisxuYxULBywlhwzPlybbbGWNlG0mbB1COYgIIhL8rF6Qnxr+Mt+oW1UMlzJW7FPeuntITTfTOnQpd3VI6K3OljLWKzzw7yNoa9O/bOvihAjrKhOyfcd5MyMHeBs/IcGzN1Ph/FRkot4iNSP2Sg/RuEgXuMiQnzGspv7iHXZNsvqf1c4lGqgg3kX940fh4BF8QXbY5TTQ+u9qW+v8IuSNuGjtgU99M1iW2qnLmwHaIbrJZjHhbs2xj7wGur/Un/3pgEE63P8v3Scfz/HOPuEVBSMb1aFYsGC5GOJWytZXvFAXgiV6IdskTa6gcUiDS0R3yMHW0HomWVg3LeAFXJcPhFx59hlRQc3stiA9JYUwexfCZdLYhPy0t+F/81fKOqLqGW/1uVwdwHmtOJAymiry7AS5j/Waa4RmmLN6vfMsBDDMtkaH4BrcNO/RJY/m2wi4Ba8o/AhyRYHNVVPGEyGTIvEpTPxnYOPJPPjwQQXsn8vRnjM8DwUknGutvPYT6DVmYZfRGiRTItiE8W39kJQHLYQZV2RMhpAtEqbzmz9akXU/EQ8LfNr0QhecYiJbuW/+OxkotqeQ8nqW9/KxNy9gNQFJiP/FySubgES65BEYYTYBBTQXhIGRhNZ33TlBjh+BxdBSlk/m5Q+spBHpbLFRNfUW/AYOvs1DwC2xZS3f9KN4EDh61xVDSPP2I5hTK1DJL6odPIt//HLn1UNXfEiAKFc4c3bh7da9hCUXfdg6H2MVaVu3b1a2hH4Lo4HHVEHI2a8zFjp3SzAFpUTRAokboRGqPEIvNyjJqtEGNiw+o53GNskF6ObJOBylauBdXdi5q96GwTNHqTw3sfWnaB2Ik5VMe
 xxQmnkbf
 6M3SAT3RtT3FUI1rjXxDVOCpVMTy8jptj2TLVcU4fK59wHDbyMWjBkjtwS1dxQl0mJAFgoSpL4l4/548PZv+gjLXe5M/DiinDOS8Iyv/U9KFZYpKoJU+BjLyqGdrAW/A3KWGnZs2ZYicqyOMcMaa2hGMfllKInYrZAoA7jL0bDrSanNLlP5DutSS0RaGTCSDhSbdY3r8XGpZhnznGqd8zMFVg8qhCRP/lJPsoSBOt7JzTfQrhlLLn9PfEC6aGqP7SPl+oMrwo4m2JfHGut0rU1IbbwA==
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


