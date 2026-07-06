Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5BAFC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0FC6B00CA; Mon,  6 Jul 2026 02:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4B56B00CB; Mon,  6 Jul 2026 02:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3EBA6B00CC; Mon,  6 Jul 2026 02:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62DDD6B00CA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB19C1C7B21
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:29 +0000 (UTC)
X-FDA: 84957352578.10.23964E9
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id F358220002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=UGkObL7oD/K2bAkUVhXxAs7YoFHUnPDSWQxkr9+NXKk=;
	b=Mk7UyyBt1g+9dVIY36Tcamcv5aBid6N6dcIE+cJdTA9KsM7ypZlK3ohrMdrB2PstGj3JWJ
	Uygj5QEbE7ngmmssWoJvMYQF7khfvvSY1BwukDo9Bi03BP0SmSFGg6Of+8Mb19PPzEDjak
	D86s/HPD5QA6rhj7Yd5PG1juuJFnc1Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318828;
	b=hSI0oSu6EJimyNMSSM5qyhpuLvuM4jsW+gwe01SPWQ27viKWy3sGkVX1qE8rGnFR81QDyx
	aV9TH2vFkj0XP08xq4Oox+GioyqejYFbg6UicRLciGahXh5aTfQtlDfdx8rsx0OILHGtG1
	mDAkJKoPqOUYXliJvLXMaZQiY/BPjc4=
X-AuditID: a67dfc5b-c45ff70000001609-43-6a4b48ffa4ec
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
Subject: [PATCH v19 17/40] dept: apply timeout consideration to swait
Date: Mon,  6 Jul 2026 15:19:05 +0900
Message-Id: <20260706061928.66713-18-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxjF/d93GjtuisYLLnOpigaioqJ7dJuBLItXzRLdkmXRJbORGylC
	wUJRjJpOEscEdHYCkYpDhJtSSgtlZIg0Y2grBRqLKFSLgC8rEl6qHbh0oKxA+PLk5Jzz/D4d
	Bpf1k1GMUpUlqFWKVDklISTjSys2YHv2pcTlB8LhmsVEQZ71KgntfecIcJtrELzTOWiYDHpp
	mLU5EBR363DwuP/EYfROAIFfLEBQ6tPTMGLfDbNPhzHoezuG4GXrTwgCI0MIfncMILAZzlHw
	cMpPgbMon4KJOgrK9DoEvic2DHJvWijoHp3BoMb6FQyKPgL0JblY6LzCoKj2NgZB0UiD3tVD
	gqNmmAbz+H0SnAO9JIz6dBQM3jtPwh/aIRqsj+0ITAU+HPKapwiwvghVbE9i4cb5SgJabE4C
	8t5NInA0Pcegp/kaBQV1jSQMmGZJ0Or/JcHd2kmCZdiDQaejnQBnaTUBXtclGu4315LwbMhD
	QoOrC4faiQoKfp3wIXhcMkaDOOWnE5J403UT4qf/0yF+sioX5++M+XG+qnOM4jsqOP6yawN/
	q/QpzZdbNXyDIYa/2TKC8VbjzxRvDeho/sb0K5y/MP4Q4/t7W6j9sQclnyUJqcpsQb1p12FJ
	suXljyjjH+pkib2S1KIO8gIKYzg2niuaHMUXdcfFN9icpth1nMcTnPeXsR9zDYW+UF/C4GzP
	Kq5ALCTmggj2S66s0R4KGIZg13JF9elzUspu5+z9Hy0gV3E1da3zmLCQbZ4pm8fL2G2c13+P
	mENy7G9h3N3XLmzhIZL7y+AhfkHScrTEiGRKVXaaQpkavzE5R6U8ufFIepoVhTYnnpk51IQC
	7m/aEMsg+VIpJOxNkZGK7MyctDbEMbh8mTR6/b4UmTRJkXNKUKf/oNakCpltaCVDyFdIt7w9
	kSRjjyqyhGOCkCGoF1OMCYvSItHZXX3pw7PDrarwoePvGbPxVnAwXirEvX8WZfzi62hL13JV
	cuSV6vwVx2b7Amt8q91xx7+/bi7HNJf93h32z9WP6uudiV06Ji8t42/2xbRooA58K4m8HZ1y
	yPCJ6rvi+tpPg+2ahMRNQuQHsRFbvfnrZpThD7RZp9cW7zyjMfSKciIzWbE5BldnKv4H7IC0
	tG8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSWUxTYRCF/e/WS7V6U4leV0yNaNwXNOMSt0T9A7HxTWKMWvUqZbcFBIzR
	glVUMNjYEikoIhRCq0UWFU2V1ICKGkFUQEAwqShhqUuLYbNeNL5Mzsw582UehiXld+nprDo6
	TtBEqyIVjJSSKtenLvHhkPDl9uKZkKY/BW0dLhre66op8HrSKMix2xgYNd+TQFrZVRqeNaVQ
	UH/biqDDm4bg17CZBH2Vj4JRQ60EPIOtEjDqEPgctQhMDQYSmusfk2Cr0BHws/Q3Az1PfiAw
	fnIxkNWto8BtSUeQ3WWWQHfNDujreEiDr/0LAU0DvQgsrt8EuKrPIRg1RcD1/HJx3fSNgeFX
	r0nIMtYjuPGpnYQf3Z0IKmo/InAUpzDwObOShEbXRHjrdTPw3HiRgb6GHAL6SxnIS3HQ0PCy
	B0Gu2YCg64ODgNSbdgZMuWUUVHU+kEBDzwgBbSYDAdayndBh6aLgRWY+IZ4rpu5MBXNWKiGW
	rwQYbz0kYNBSItlciPAv/SUKl5TfJbD+zSiDbddsCA8PGRD2FKaSWJ8ptk963SQ+U34cF77o
	ZfCQ9x2DHQN5FK7L53HB+SECX361BFdlt0t2bdkj3XBYiFQnCJplGw9Iw+wuHYr9ySRm1RTQ
	p1EdfQH5sTwXxNdd+k6MaYabzzc3D5Jj2p+bw5dndIkZKUtyjQF8uiWDGjMmc9v43Moa0WBZ
	ipvHG+/EjEkZt4avaZv9DxnAW0ur/2L8xPHtkdy/eDm3mm91P6UykTQPjStB/urohCiVOnL1
	Um1EWFK0OnHpoZioMiR+k+XkyOX7yNO4w4k4FikmyGBzcLicViVok6KciGdJhb8scEFIuFx2
	WJWULGhi9mviIwWtE81gKcVUWfBu4YCcO6qKEyIEIVbQ/HcJ1m/6afRo7bGKAElt3/eD8ftW
	dU5Lfh3cN+lcoqJAcehB09r7TvuW3m/7VlUb1MlH2ui8Im1R4pGWgbhbJqVu1uJ18RfnLrLO
	DQ3ca9G6g5Qx2zfcax3va9l+IsKH+rGwst+pb1dOqlzp7d86Jehp+MmzCdbjV2Y5zlft36SU
	zffY6FA25ZGC0oapViwkNVrVH1dU5FdJAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F358220002
X-Stat-Signature: mf1jgni4okxp4w14pggeer4t388otx5x
X-HE-Tag: 1783318827-522782
X-HE-Meta: U2FsdGVkX18UnelE9sCBggjUe//wOao9Mo7X7HVEoV0b3T9PY1vY1V/N5Nz8H/RIiObfWihamRvgA2rn4pA6bgYKihO2aspuami3Rth/eR/ClM56B6LgsGZQgf+galXSJfcGGY/VQPfC2YAetil8G+76DVRZ4R9xirWnwt8RhLDKsMj7pVuobnaIeBog95aR9FVJ29so1kQINV//FLSrOqBjeT/T6MNDI1TfsZ8kCuhqEZ4ivtN1BBZElN3QPGFeR1jp+tk0gRz4/LFdJEHrgwOu3lQmNucZsJOT3fw5KaKwzyr3Nd+Q5TRkmhLHLtSltpvIX7GtRABMmOdtcuV4c/JQwT3T/MiQhV4R+G/uMS5zejrpCtGWKlFTqFuqZze3UIUZXvHAT4tV0PmS9rzyIaXKu75CdKo+6sibjUoXGeXHvNp7EmBS+cSFGF4E64SVHpYQRMPmDCe/TXez3l1e9ykdgtogqmJmD+q3Kw9Z+Q9lO3/ioA2pwSSJudU530WA+K/s7hX857Pm7NA2CoRueuyE8QaKmJFSlm3Uzk8zSHnRzhIDejVXXPvdV4bz7Q9dDT7QEC0UtLHZdBYY1yYhnYrnvmJl5X79+SUa4hL5cVF+rP6r1KYO3N7W1jK3AIjBoXsKdyFoi8VNtbvtLcePXuQtvb+XBgpkYlkJuLQBCucEDffg8N09dOi87ri+5tQnQ/ShfgL6wWThIBF1gsSQM0tnzKoaaVZ/FvPwWD0ou97KOJPK/+hpiEea/xRWsFTSxEjmOtb90Ud6ggZMgafUbGB6oPolZAOY01WyS5be59YO3ZPQJLX8UW3r1rDTgXfkBVVYQ33jolEtWdNjp6giRyqEqtCoAx+4yZSSdbKeCxkl83HuNCBUb/vVn/2Q1FU5RdWM9bTEmV/4ChuZfCVqevYklPGmH/d3xKfcmcUdE3dxbQhhzFGovOPq743qAXP9VPsGTQn/POrJYim69Qh
 6rD5mg57
 togTSDzdUoA3aK6B62nb9dzptmZ8PMGq4rD3JXoOpqQ2Rv84WSns3N3Ce8wzfy8Zfft4WL3aJmPlDAAv89vHABRrAUqE2OIoGzKMhKiNIHwovmNzBIfqTW0BiOj45l13ITfaAnP9gysz13UVP8/16YW6carYShvKnuvrM0FkijZLISc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to swait, assuming an input 'ret' in ___swait_event()
macro is used as a timeout value.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/swait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index 277ac74f61c3..233acdf55e9b 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -162,7 +162,7 @@ extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
 	struct swait_queue __wait;					\
 	long __ret = ret;						\
 									\
-	sdt_might_sleep_start(NULL);					\
+	sdt_might_sleep_start_timeout(NULL, __ret);			\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	for (;;) {							\
 		long __int = prepare_to_swait_event(&wq, &__wait, state);\
-- 
2.17.1


