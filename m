Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1878DD2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4FBB6B00E6; Fri,  5 Dec 2025 02:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF176B00EE; Fri,  5 Dec 2025 02:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983646B00EB; Fri,  5 Dec 2025 02:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5830C6B0030
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08B931A04DE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:02 +0000 (UTC)
X-FDA: 84184568244.09.144D5B9
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A5EF40002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=6/SRTPKkuLIHU+YvAOb/eKFbLa2GuA/QEIc1Q/U4gu0=;
	b=UZZdXhvHyyjxjlwzvDJQDiqTg60CW0lcODyTy/IAYF9wAcq4Sre8xzv92wNJPchyVU1sMN
	scdCCgeBszSpVcrsZk7SCCmUVNTU/Y+aZru4okNTG7pWHHWrclxC1KddEXQgy8uvDASZqN
	qNwRmeUSsD49FBzBqRCQVlepuMaif9k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919200; a=rsa-sha256;
	cv=none;
	b=MAOPZ5JDp32BDg/YKiXRzsUnla8UyfW0JTId3BF9pODT+cAsnz8+j1PSQUBlQp/UId8l02
	v7YCJmXG24GyY/1sMI2u24mVvV+ieyG64fEBcROk7avXP4EmbTRX9hks1O39Omi+wuka8l
	ouQx8JJ8dBL9Rh40RXpCSq/TEPzWAIE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-5b-6932876f2fe9
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
Subject: [PATCH v18 20/42] dept: apply timeout consideration to dma fence wait
Date: Fri,  5 Dec 2025 16:18:33 +0900
Message-Id: <20251205071855.72743-21-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxSH/d/3VpvcdZ1eNQ7TzJm4iC9Rdz6oMX7x+mHGRBPNzF4aex2V
	UrAoiPGloEClKFgsBKpSyyAEapgXF+RNazs7J1bLMLYIrmhIXW2RSKikalNr1W9Pzu93zvPl
	MLh8hFzAaHQHBb1OpVVSUkI6Mefy8rzy1ZqVkXIExtITMBocJ+FRsZOAhLWLBqNYT8IdfwkB
	wZgRwcxbKw6l3UkCpuMjNCT7PQhqB804BHw3cYi4pxDUhYsJmGypRNAQstIQvr0FJoK9JCSf
	PMfA/zqKYNyZciVqs6HR3knBW+8DHOosPgRT4TEE/a0lFDyMTVLwj8VEga2kn4SLVjOC0ON+
	DE42dVBQe1EkoHush4bRWjMG7eIPEGwJETBQbcdS+lTh6jyw1v2PgeVKLwZJWy542p/TEAmZ
	KQj+XUZCl2GMBnH4NoLph08xMPbECLhc9jsBxsQ0As/1ZxgM9Vyg4D9HkgSDdYYEn3OAhAHP
	HQJGvFU0POi5QkKzfxCDTu89fJOaL/03QfGOSw7ETzefxHl3dBLnmweiFH/Ou5zvbnhC8zbx
	EH/qrwmS72xdxjf1hTH+cWQDL7adpnhxykzzo4/6KP7l/fv09u9+lK5XC1pNgaBfsfFXadbN
	mqcob4g5PHhmhDCgdroCSRiOXcOZEjHqM9s9f6aZYpdygUAc/8AKdjHXeSZEViApg7NDGVx5
	/Gw6+JLdxr2qGUwzwS7hxm90kR9Yxq7josPxT4IMrv0PZ7ojSc0t/jdplrNrucaKmfRRjrVK
	uLEqH/q4MJ+71RogqpHMhma1IblGV5Cj0mjXZGYV6TSHM/fm5ogo9XItx97tuY6mfDtciGWQ
	co7MWbhKIydVBflFOS7EMbhSIYtqV2rkMrWq6Iigz/1Ff0gr5LvQQoZQzpOtfl2olrO/qQ4K
	2YKQJ+g/pxgjWWBAha5KxRtTdf1QzRcvFHN3FrucR/cYvo/rdlX12SeszN36/U3uWfbzR2Kn
	9/3cVr1jq31JxF1ZVE+ecJTVrf/2pxubs9XfNIZXSIb9tgzOe0oSOLCvddGidZcsbQ2kbXuy
	o6z3lcN0teNYpnjgguna3a+37cpUzHbv3li196vjivC5tUoiP0u1ahmuz1e9B3x2PNRuAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+793V4u3Jfhi0WUVUaJZdDlhRFHQ202iL2JfauRLLuelrbQV
	XdSGtm422SSXOVcuUdO1aWm6MqXRlVxWWmkqrJW5smxL5iWbUl8Ov3Oe5zycD4fBJXVkOCNP
	OSwoU2QKKSUiRLEx2ZGpOSvk0flaDnI1p6Cz203C28wmAvy+XAKuVldSMGa8S0Ou7QoJj9uz
	CGitqkDQ7c9FMDRixEFTP07AmM5Jgy/wgQZ9JoJxhxOBwaXDoaP1AQ6VNZkY/LL+oaC/ZRCB
	vtdNQUFfJgEDlvMICj1GGvoebYFv3Q0kjHd9xqD9txeBxf0HA3dTDoIxQxIUm+3BdcMPCkZe
	vMShQN+KoKS3C4fBvh4ENc6PCBxlWRR8yqvFoc09HV77Byh4oj9HwTfXVQy+WykwZTlIcD3v
	R1Bk1CHwvHdgkH29mgJDkY2A+p57NLj6RzHoNOgwqLDthG6Lh4BneWYseG7QdTsMjAXZWLB8
	wUB/qwGDgKWc3lCK+CHNRYIvt9/BeM2rMYqvvFaJ+JFhHeJ9pdk4r8kLti3eAZw/Y8/gS595
	KX7Y/4biHb9NBP/UzPE3zg5j/OUXkXx9YRe9a+Me0boEQSFPF5TL1u8TJT7I70VpbcxR14UP
	xGlUQWtRCMOxKzmzs5aaYIpdzHV0BPAJDmXncfYLHlKLRAzOts3lcgIXJ4WZbCz3M981yQS7
	iHPfv0tOsJhdzXnfBf6FzuUqrE2TnpDgXN8+PMkSdhVXrB0i85DIhKaUo1B5SnqyTK5YFaVK
	SlSnyI9G7U9NtqHgP1lOjF6uQ762Lc2IZZB0mrgpY7lcQsrSVerkZsQxuDRU7FVEyyXiBJn6
	mKBM3as8ohBUzWgWQ0jDxNvihH0S9oDssJAkCGmC8r+KMSHhp9GMJYYy+nOp0vo8ZtO5qsZY
	uvfrvK6HD+21u7e+OhDQrvVd86sv2cKUVsUhbc3s6O0RjcnLxELr4xnqojlCfIsjoi/t5NRH
	A6/r3rjNFtNJqa/Q31mWkPGV8fwcjYk9uHlhcW2ACr0ZtkYoKTMNOpv3ps/fEUckxk8/fnZB
	xCh2S0qoEmXLl+JKlewvxvLG0ksDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A5EF40002
X-Stat-Signature: zmmim9yuo3j5mtrm7f8rh7f3te747ssd
X-Rspam-User: 
X-HE-Tag: 1764919199-433282
X-HE-Meta: U2FsdGVkX1+u7naTScMM3Y+b5xAXEzwWdl/8wpYB3jcVXkm2lOC5H/ALg3eNyveswGawmrym9VJHRnWvYuZW/ebWr5Pq9W2ZWJlnoGWbcAmnortthYM5SE6/4Ui8Nz+sKSEhRMQsw8I/K4Xob9XbZs8t4V95x1pCrPLeQPh/ZBuXjtjPN+fbXmVGMfh00ferio4gbA+9HCsPVsBCq8cMTZo5eHP4W15WmeE8Vh8viHCa+lV8Bvsk+6gbDqWuaUb5qcXiX17ma83Dp9fizzbtni54OSSalvQV3Rjrxo6OxnYc8+donbMesAAczFvtFLCzfvINBeeNJv6nXQALdTVTtYmZ7DwbC0PLu423o8/qsqQQlW92LUf3uIUJQJ5Xg+Y6AQzI7QDHKJHYpXZMON7dut0AFkWRrEFYWTSpb83H56HNu0Jvg33zjsDoBqPRl7w1o5oF5d1GQmSXbyt3jfQ3lJzDwTIxHT6G77k0v36skDQmtNz2JnEfibXgqvY7FHP47Fe378cIQSSwiEvY4xTPjKSbAHCpNUYu3GRDLS3zeo1NIYwa3sAoqjSlqPhVR513dZqyNRDuplSUoHag28/pdNi2CYvFu2s+YXKy6e0hH3EADrf5Qg8ibFHyuCNqpB5oz3HAyirgfEQyd6XCnPZ69FEg9126EwQVkbofLDjMp9j5bIDaB8HQR4fwJ/Ba9dzurWt+1ccyvCSRVPSLej3IxegAueBepsiXiepCM7roIJWByKU9aMiQRjwyJGJR3ro1KjNrPuDyl9xnI+xdvoDHZH3yyQazJ0hNM8fnANDwhDpZqG8IxAKAL2G44S/eNgDe8vG6bvLRaExNRnnMazQzkFfzg3EJXHNtrtlyuI9jl8ETDvrU4th820gbpbKbe71ZV+5S66Yp9FpX/rag0GeOH9PCSqcvpbAw899zpZjQi01wwKtlenl/o2RzrhcN0nHtNL//MaZRIQQ3gpsvR6O
 ZtfNGEQ9
 dEXbtFqDz5dypjIJKzBxcUHXdTFuLdK4Cf7kQ8lRfW96RTZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to dma fence wait.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 drivers/dma-buf/dma-fence.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index b313bb59dc9c..f2cc7068af65 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -799,7 +799,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 	cb.task = current;
 	list_add(&cb.base.node, &fence->cb_list);
 
-	sdt_might_sleep_start(NULL);
+	sdt_might_sleep_start_timeout(NULL, timeout);
 	while (!test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags) && ret > 0) {
 		if (intr)
 			__set_current_state(TASK_INTERRUPTIBLE);
@@ -903,7 +903,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 		}
 	}
 
-	sdt_might_sleep_start(NULL);
+	sdt_might_sleep_start_timeout(NULL, timeout);
 	while (ret > 0) {
 		if (intr)
 			set_current_state(TASK_INTERRUPTIBLE);
-- 
2.17.1


