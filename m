Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421D2C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8596B00B7; Mon,  6 Jul 2026 02:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0D96B00B8; Mon,  6 Jul 2026 02:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3D56B00B9; Mon,  6 Jul 2026 02:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E790F6B00B7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6956F8D0C1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:25 +0000 (UTC)
X-FDA: 84957352410.07.78FDE12
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 92E4D20002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=xr7YxQ3mDgzLlVDJz4QHuiIob5IdzD85o9Kn2I4mvjo=;
	b=rv7hiUcQxF2AFQlmnawaEtJI/qcp0hJg3z83AL8/i49lLKmf970dr/pcojIOX5qfJ2M9Wb
	cc/J0qucdGKdFoZSGHJOZjSFvy6JoyLjQoU4jMJnTdeFv622HKkE+QZbrKluAWksLmRUvJ
	D3xWLjRxtlp1MuGoVE23f/zdG0Tc74k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318824;
	b=u+Awk2c1tDjL6/LcENP97z9F2RZI/XsmpE5HlfQR9+elKmvQZYpCQqDe4hcKXzRoCsKmsd
	VeUfgqjiUqyWUOxZO2nFIe9057iL5ujniHo/cdHBK9fF2YLMsbYVCKZWzvaxJEY6ZPRqu4
	R3ANAuDSmkuC11gP38KsKeTkRBrzvxA=
X-AuditID: a67dfc5b-c2dff70000001609-26-6a4b48ff8903
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
Subject: [PATCH v19 16/40] dept: apply timeout consideration to wait_for_completion()/complete()
Date: Mon,  6 Jul 2026 15:19:04 +0900
Message-Id: <20260706061928.66713-17-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSa0xTdxgGcP/n8j+HhppjxXnUELRm6jAiEi+vxix880yJQlxM1Bht5Cjt
	oGhBFOMSjIJOC2HV4g1aKIqVFsqKivWCiEMmmwiRS8FyM6TRoQWxgtiiFojffnmfJ8+nlyVl
	nfRcVqlOFTVqRaIcSyjJu+CiZeiXTarIvGvLoe14DQX5NiuG8StVDDSVWxBkOr5SMK57woB3
	7CUD+uMInE0PSfhQ8QXDwONhBPq+fgyDJVoEb+o2QPvIWwRGU2UgzBvC8KJ/OjzVn8VwotiG
	Ia/ATkHzgJ8Afdk9Av4rdlHwynyZgQG3DkNPfRYN9o46BN6WPgKsWjcJDzqXwiWDC4O24hYN
	3davNDy/W0ZDX6+ThqY/s2ko85gwnPO4EQyMlJBgfn+BBndrFgFPCn+AG8brCOqzawi45vWQ
	0NJxD0H16V4C/rZVEfD441sCGro+MFBp15PwuesODW06I4ZntxsYyNSOMWBppkDvP43hVt0o
	Ayddq8D3KR9DTuMGKPCuAK+lFEdHC6OZOZRgNViR4PusQ0JmbkCOy12McLK6kxEqzeFC8f03
	hGAv/QML9mEdIxT5XpOCq+0+FjyNjYzwz0UfJfS3XCAEw9O42NAdkvXxYqIyTdQs/3mPJKHV
	1UkeMEiOXP0/i85AvewZFMTy3Eq+/dkr+rst5ttowphbzDudY+SEQ7j5fGW2O9CRsCT3IozX
	lmRTE8FMbg9f4KqaNMX9yA9ZzxITlnKr+evn/cTUaBhvqaiZHAoK3Mv9BZN3GbeKfzlYT011
	LEH8zYsRU57DPzI7qVwkLUTTSpFMqU5LUigTV0YkpKuVRyL2JifZUeDjSn7377yDhpu21iKO
	RfJgKURvVMloRVpKelIt4llSHiJdtGSTSiaNV6QfFTXJuzWHEsWUWjSPpeSzpVEjh+Nl3H5F
	qvibKB4QNd9Tgg2am4HOt/voM8lF5aYZMWsVvaEZkYWrI8srUGroqE4W57DjSBUZZaxZ8yls
	jSE4dtu6X/G6huHW7bM2G1WLgn0hcQt8B9VMT94jh41+bvLss3cnNHdrFx7Thsvo8KG7P+VE
	zY4x9RgP7tqSXh/lPZXkQDHjf5Gq/H/7bLmLO0b6B6vlVEqCYkU4qUlRfAOQr6NebQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTHfZ57e3tpKLkWDNeXRG0U3wKTBPSYmaFf9Ilki/GLxqjQzBsp
	r65VXpYYLbXaCRhobNksCKJUAxWxVZSRIi+ObToyEBGCYMHVIgNXBlRGAbuC8cvJ7/z/5/xz
	PhyWkj0SrWCV6acEVboiVc5IaMk3X2oj/SQ+eestUzDodWeh3+kSwUtNEw3eKT0NJXetDMyb
	H4pBb/tJBL/15NLQUVONwOnVI5ieNVOgq/fTMG9oE8PUzCsxGDUI/I42BKZOAwW9HY8psN7X
	YJis/cjAaOsEAuOQi4HiEQ0NHks+gqtusxhGftkL750NIvAPDGPo+TCGwOL6iMHVdBHBvCkF
	yirsgXXTOAOz7X9SUGzsQHB9aICCiZFBBPfbXiNw3M5l4G3hAwq6XCHwwuth4HdjHgPvO0sw
	/FPLQHmuQwSdf4wiKDUbELj7HBi0N+4yYCq10VA/+LMYOkfnMPSbDBiqbV+D0+Km4VlhBQ6c
	G5i6Fw7mYi0OlHcYjHcaMMxYqsS7KhGZ1l2mSZW9DhPd83mGWK9ZEZn1GRCZqtRSRFcYaFvH
	PBQ5b88ilc/GGOLzdjPE8aGcJk8reHLzBx8mRe2RpP7qgHj/7sOSnceFVGWmoPriq0RJUnd/
	H3XymiT75t8XROfQIHsJBbE8F8NX365DC8xwG/je3hlqgcO4Nby9wC26hCQsxXWt5vMtBfSC
	Ecol8qX9DxeZ5tbz49Y8vMBSbht/68oc/hS6mq+ubVoMCgroNXOli7qMi+VfeX6lC5GkHC2p
	QmHK9Mw0hTI1NkqdkpSTrsyO+jYjzYYC/2Q5M1f0CE117W1BHIvkwVLYtS9ZJlJkqnPSWhDP
	UvIwacTG+GSZ9Lgi53tBlZGgOp0qqFvQSpaWh0v3HRQSZdwJxSkhRRBOCqrPLmaDVpxDGY0F
	E9zj1lUe11/BTvcy8CXs2BSnX5s90fhf2/iWnhB/TXLQE4uhznklxB4x+bQs4/q/MW/UpDmr
	e09W6OSPS7dubslcNpTXcLr9xVFU9mSGtQ6bsMaWe2jMEr/Wt6Qxf503rlm/I2rEWcJ/V5QQ
	fSRc2xG/nT92YHno9ju6eomcVicpojdTKrXif+1e7ZpLAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 92E4D20002
X-Stat-Signature: 8infb99kafiy7htms6yeea7wjhqaz7pj
X-HE-Tag: 1783318823-968257
X-HE-Meta: U2FsdGVkX1+xRMkKW1sVw/jvaJZlbL1HxyNwaavhFJ+6iYUVIQxQ6/cYbA0bhDYn/gZHzv++ISZONRVVNwrvgZkg2PCmNN0DX/hPJ460beuM+5JSVg30AIDaJ/9MAWjtvHxuYMr1rAJowQ5rd0Dl5SLsvKcfjIqHswuOjDYCiDNzDg17QO3trc46STLbf/ASsFMPrq5tTBBDn0jrInA2IHDKE798br4sfdHu0/3z91e2r2Y7SB4zPHxjk0+KLLCZpdC2bUoUG4Us7WGP5HZibZixc2iI6pCvfZRH3a98bFH7DAPFdM5UVmaXEFbvhViIixbXDOFPwfNoob/O+uZlt6S0kbimnPyphWJkj4kDUZHgkst0epNHTaJnpA26rtgNUSr/4yIj6lBRNbm3l/sgGw3T7jMNjafJepmF7NWk4jtY6fMJlXnFD1/+Ms2MC1Umr9oHh8KJ3TlLpdH0t9WR7a7cFSzZe685tKYHAGrl1KNFwXdQtMgGgJkRQ5OZLtb35C21u/EdZmayI/atOYn8Nz7w9Si5fE4ydiffUCCY7nkRjTNBD1upx8EDtoZnynRMAtXIeLZwKppa3AffjGt5lvMzIFwdTkGzgqtGdZ0pmXNoSRuIlN5fY8d/Flx0Y5ns1KW5H80cn+bW136kwNKB5BdRuoqKijW1jh7+9cAmAExulEzsw+pIT/Hm1QCL04mVMISzr061MSDTelqG7I6eiVQiR0Vfh1meiGdAE1JJkWSFFicVGMdkovuf1LtvCy5W1dydu7WDAEcLLAVPH4vq8qeiJo8DqsUmB1ELBG/+dzLgAY9QDrJCaWO5vHsycvMP2CaXt37heRCGeKsnBiGg2Bz113qvqbb3Z0Jg/unThQSDqRWIqPuA+Uun4RtgC+Mv03KipN4R1H4999SBcGKOPl864jYP2Wow2Rb4NPrG4NkyQqr++Hzo4mbDKF7WsAPQZveF1ekU+w8NIlPRd2F
 cEOAIBrN
 MOKK4n3hdVCeLvA9UJMb2ewtHaR2V4T0WZ3hulxO5PHetX20n6KXP6PyEKzunHVc39ShVkEbq/yknTBBCCREWVJALjWnfcem53wiN5vKXDI/wGJGDP449Y+x7VD1rjuDIdaSyIJm0gwCadw0vpIWGmTI2fSCSqqQXKzak6eHVFCBXtLZGPUbMk0on9GA6bK0J58I95yp8eoc0yZ2CSAlcZMl7VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to wait_for_completion()/complete().

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/completion.h | 4 ++--
 kernel/sched/completion.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index bd2c207481d6..3200b741de28 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -41,9 +41,9 @@ do {							\
  */
 #define init_completion_map(x, m) init_completion(x)
 
-static inline void complete_acquire(struct completion *x)
+static inline void complete_acquire(struct completion *x, long timeout)
 {
-	sdt_might_sleep_start(&x->dmap);
+	sdt_might_sleep_start_timeout(&x->dmap, timeout);
 }
 
 static inline void complete_release(struct completion *x)
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index 19ee702273c0..5e45a60ff7b3 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -115,7 +115,7 @@ __wait_for_common(struct completion *x,
 {
 	might_sleep();
 
-	complete_acquire(x);
+	complete_acquire(x, timeout);
 
 	raw_spin_lock_irq(&x->wait.lock);
 	timeout = do_wait_for_common(x, action, timeout, state);
-- 
2.17.1


