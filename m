Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88081CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4189E8E0018; Thu,  2 Oct 2025 04:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEA78E0008; Thu,  2 Oct 2025 04:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2908C8E0018; Thu,  2 Oct 2025 04:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12A628E0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA3EF1403AB
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:34 +0000 (UTC)
X-FDA: 83952459948.25.2C06A6E
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id E1203A0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=QO0ktSHVV2QMWlvFK6KCv9VHqzEu0CUax1zwOXR8vGM=;
	b=2/7yWtem3ht08dIWJdMZWUxEt3CFY6geK16/ltxPkOGeEFhuzDnFfgdtkEDBTMSQZzsjon
	S03trrVxrul4R6GaVLTpX8IeEksxsw7OCG0Z43IZ6GovUz3qXC+woLQn+RRXapwmwmWloy
	dSXsVTNfhXnkVzh/E86z/IheFxHpjm0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392813; a=rsa-sha256;
	cv=none;
	b=JNo2oRNBkx/DdfTC1Zww174RnzB7/wB4iY0JVUt+5BE3sfHsPpXBo0P/uPyKs3MtVOxXTN
	PF0sajY++6izW11+mnREcngSZb0epQbfqq8skOJG06CxGQYToJ9o3+7k9erX6McPFHDyFT
	bhOmYlrnYB9HUotxC3G/n9yONnj772A=
X-AuditID: a67dfc5b-c2dff70000001609-9b-68de340df55b
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
Subject: [PATCH v17 12/47] dept: record the latest one out of consecutive waits of the same class
Date: Thu,  2 Oct 2025 17:12:12 +0900
Message-Id: <20251002081247.51255-13-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTdxTA/f/v/z5aLbspRK+6h2tEN+ZjM2w5H9S4RePNMjaiiR/Yh9mN
	m7WxFNPy6jITHI9h50LtVp1FESSySotlZaDAMAylaBgDgmKBtohgKyKQdNRlIrDC5peTX37n
	kZOTw1FKH72O0+qzJINerVMxciKfWlW5NS45qHnb7H4FBo63ETjndjFQ4jlLQ+8VJ4KRaAmC
	oqZFAvNWLwuLrV4Erl+PY5i8EUFgGx1nwB4qY2GiYz8sBsIY7j19gqB6fAHDhYv1DMx191Dw
	qO5bBK2Obxh4aGmgoH88Du5EZxi4bfuOgam+cxjOl1kRFFS5GWi638yC/7QVg9OTAiPVIQJd
	losYzkwwcPqXNVB2pgDHwiMMttoWDH9U+QlU5ydCWXc/DQ8c9tiOFZngdYZZCJTaCFyZ6qFh
	MmRlYKSzmIar+fdZ8Ax2IJi9M4rBdTJEQUlzlIBnbICG1qG34Gy5P3aA+VkE3msPMJysa6Ah
	6FqkwR32Yejy3iJw236ZQE9zLQ2X7vXhPeliTX0jFl3lLiTOPbMicfZSASXeeDJDic+idxnx
	VPdWsckeYMXC60OsWOHJFusdSWLVbxNYrIxEaXFocpfoqTnBiJ6IlU19M02+M13SaXMkw/bd
	h+WalpHz5OjDlXnBilNsPropMyMZJ/DJQvEPfuoFB0sr6SVm+M2Cz/fPsk/gNwj134eWPcV3
	vSwM9G0xI46L59VCtMS0pAmfKPTdsiyXKPj3hGDI/v/I1wRnXdsyy2K+f7SLLLGSf1cominE
	ZiSP1fwsE9rGw+x/DWuF3x0+YkGKCrSiBim1+pwMtVaXvE1j0mvztn2RmeFBsX+rPvb802so
	0nuwHfEcUq1S9CYGNEpanWM0ZbQjgaNUCYrDDr9GqUhXm76SDJmfGbJ1krEdreeIao1ix9Pc
	dCX/pTpLOiJJRyXDiyzmZOvy0Z6rRYFNj1dGOl9KGQ5bwhsJ94k9vnZ07Zj2gx0ZX2c9/nt4
	n37ho7S8643OP9+IC093Ng07cgYGbdMpzeA2Hdg7RPaGWi640wYXWmoLdY3v++ZylX+9Pviq
	ND91aLrYbEzYNfxx6U+fZ8ffTN38vHiTbWH1j8dSkzpyPxwr1989aGhQEaNG/U4SZTCq/wWf
	HeRmawMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUhTexjH+51zds7ZvKvD0jy9QDWQICqLUh6ucrn3n/pxvUV/BEEQOezQ
	hrrJpiuDQtN1pZfbXGyWy+syHKaWy2lky5DNzDJz02q9uC1rrTdtl64rfMum0T8Pn+f7/fLw
	/eNhSVm7aBmrUhcKWrUiT05LKMmOjLL10i1B5caHrlR4UtpFQWy8goILLc00VLSeF4H3ahOC
	UKwCwdcpKwmGjlkKZkw9DIxPvGBgtrMHgcVnIqG5rZSA/x3faPjo+YzAPBKmoep9KQVR+ykE
	1RErA+/vbIOxkEsEs4G3BPi/jCKwh78REO76G8GMJRdq65w0TPUPkFBl9iK4OBIg4Z0jbrb1
	BBF0Nhyj4Y2xnYSh8EJ4FIvScM98koYx3wUCPjlosB3rFEGN1YSg7FILDZaaVgo6Xt5kwPdx
	moBhi4mAptbtELJHKOgz1hHxfvHUtWSwVpUR8fGOAPMVFwET9kYGHlwapsBekgLW/iERvGqo
	ZmB6ZBPM2jTQ0/SWgcAZMwVXxwZEv5sR/mr4h8KNzusENgzO0Lj532aEpyZNCI/Xl5HYYIyv
	ntEoicudB3F93yiNJ2OPadz5xUbh+3U8ruxfjzuqAwwuv/2c2fnrHknmfiFPpRe0qb9lS5Su
	UA1V8CbhUNBWyZSgbvEJJGZ5bgsfPHNRNMc0t4Z/+nSCnONEbhXvPB2Z10mubwX/xLfuBGLZ
	xZyCj1UUz8kUl8L7eo3zESmXzgcj1eSPkyv5JkfXPIvj+tBIHzXHMi6NN0TLCSOS2NCCRpSo
	UuvzFaq8tA26XGWxWnVoQ44mvxXFn8l+ZLryBhof2uZGHIvkv0h9KQGlTKTQ64rz3YhnSXmi
	NLthWCmT7lcUHxa0mn3aojxB50bLWUqeLP1zt5At4w4oCoVcQSgQtD9dghUvK0E54tys20kZ
	gt5vntTcfE1vfOhOCK30FI56/EXbT9Wu3rV16Uvbdc+HrCODJ7uPe5M/ec8NhNPPPovqlnj9
	WXs//MFeySyPZKoS4PIgdvylb6/3HsXdbSVJS6ZL7973E5b0ImeGGzarC5KqbqFFut7/JtNe
	rFteq6k9KnPF7tyTUzqlYtNaUqtTfAeSC7G1SAMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: kykgqpczn13kygqg685iwjs41roic7oe
X-Rspam-User: 
X-Rspamd-Queue-Id: E1203A0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392812-235760
X-HE-Meta: U2FsdGVkX1845JsHJWEOPXxhpgZv6mx891AE2T/9Ql7QAVZHdO75J2ZRRWNtV+OuLsw65CGZryQlCt8Vlenn3IQchvAu7v3UmKKyuTl+9pgs4jLmBwOFJorn1lv4Ic0W9Kl41n+GXdRrbdSEpYF8Cjg4v7baUZVNaglw0rsESFTOk/CATvJndCw3cyxo0hNrP5eRZHOwLRRJoCaWz+NvzhjleQ0GIrYyW9pMfcSPf3SUq49mqghhyRYpFC70PTRag5t7E2SL7xTULvuST5z3oOSafmDTJO/9qpV2UaLUjRBPdMBS7V/IVRP7ZRA3uNgocdVeUHNVEp3s6x9uDVB6P6sSz0EFmT/Qmu1XSQxAD9Q4QjxzDK/3sI96im16MAhT7Ew9Yn9zMUYyHAoRPS519e0KIK67NBQVnMRaZT1Fj8900SATIygeReN1zvieIxrDQatqWvAtTk7QpOaN79iw6A+TP41lyBQWJGCnUAouQuSGeOmkbN/rGS7zGXlh1YBAnQlAnOl/WVodsNPgX4owl+tHtLvTUkGAZhReRAzb90+pnpx0D77oYBiOT7SOlAJTCGL4na5CtDm7QfTnUtSpSET7a6WfWmipz1Aob7H3L4lTiwnFtBoENIs3AS4YUuOhDLQvJzE1/nUxCsZ+65LBKhb3nfCqhqR7qcTvYcLHK4hAhWBvKnZhGTm8EsOAPDcdBqbHOtlBU5V81LtkTFxQW0gi2Opi4+ddnKVl677AyOi1Q7Y1SHehvvA/GWjoYgiJFdB65NjS8XEbohVDnnShLtZPU+P8PuLrliC+77l2akXEuS2I8Ud14/790JUDqE1Ue1hmA7i3lF9E0O5CxxSVrl74ePzXS7b7V5b5y+z+Td3RnZqxdAPZ0GNnWig7UU7kZY8GdQ/QunZANx6fOjeqG9MPRhudiwYRQFaeC//eAwXIegYWI4gAioob6Tzqb9y1uI+OaAJb3wapSmRKEfC
 /s8kggwE
 EiNgPIDbEl/lPalip57TrkrTn7nI2RuLNQ3aWZ7aKzOMjf2V66gT21ykVVpppkcoTjcwWcmPTl+JlSzc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current code records all the waits for later use to track relation
between waits and events within each context.  However, since the same
class is handled the same way, it'd be okay to record only one on behalf
of the others if they all have the same class.

Even though it's the ideal to search the whole history buffer for that,
since it'd cost too high, alternatively, let's keep the latest one when
the same class'ed waits consecutively appear.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/dependency/dept.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 1b16a6095b3c..f4c08758f8db 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -1486,9 +1486,28 @@ static struct dept_wait_hist *new_hist(void)
 	return wh;
 }
 
+static struct dept_wait_hist *last_hist(void)
+{
+	int pos_n = hist_pos_next();
+	struct dept_wait_hist *wh_n = hist(pos_n);
+
+	/*
+	 * This is the first try.
+	 */
+	if (!pos_n && !wh_n->wait)
+		return NULL;
+
+	return hist(pos_n + DEPT_MAX_WAIT_HIST - 1);
+}
+
 static void add_hist(struct dept_wait *w, unsigned int wg, unsigned int ctxt_id)
 {
-	struct dept_wait_hist *wh = new_hist();
+	struct dept_wait_hist *wh;
+
+	wh = last_hist();
+
+	if (!wh || wh->wait->class != w->class || wh->ctxt_id != ctxt_id)
+		wh = new_hist();
 
 	if (likely(wh->wait))
 		put_wait(wh->wait);
-- 
2.17.1


