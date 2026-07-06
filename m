Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2C8C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3CD6B00AE; Mon,  6 Jul 2026 02:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A916B00AF; Mon,  6 Jul 2026 02:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEBC6B00B0; Mon,  6 Jul 2026 02:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66A9B6B00AE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D920B402BE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:09 +0000 (UTC)
X-FDA: 84957351738.29.67B25B5
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A78420002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=3olgKqfia9A60Ns2brnFNnC5Em2AsBiwJjVwVNKVuYA=;
	b=cLzjo6lnf9VY8PUL3V6tCERC1tToUkVQwJq/k6XJGsGiwWOaycPj9uIbaDrNlayFJJwwFe
	JCaKdQEjrMRsjdurk4uHwTZgENOuAHbpeFqArCvOQOTMXALUDuuuI+8E17mDcPRCy0pmNf
	F0RZnvPEOHt/Dhd6oZ7JJfxdgv+1uB0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318808;
	b=RF/Kv1IrTpuUDatb8nc65GuSUWuyQ8TXcXbxGnCYunTfsPiKlfn6Q384R3WoM6OCk+W1AU
	/ST7I4UoPgqJ85umR0r6XeB1NLxz+5XyBTdlfAUU8r1lvdJDB6EUiieE5yxDshGoTl7Ea6
	oUyIeUN130Y+Vdb1wkC/y8vp3+mWp8s=
X-AuditID: a67dfc5b-c2dff70000001609-4f-6a4b48fda1b6
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
Subject: [PATCH v19 09/40] dept: record the latest one out of consecutive waits of the same class
Date: Mon,  6 Jul 2026 15:18:57 +0900
Message-Id: <20260706061928.66713-10-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxiGfc95z3tOO7qcdGY7Qxe2qpuDqWNT8pgs2iVmO9E/JvBnH4k7
	kWYUWiAHZWLYgm5tAGlT6oCMWqkWiZGi2K5GgU4+Jjj5GEhsug3FZQGCHXUrIAFbWYvZvzvX
	c9/Xr4ej1b8xqZy+8IhOLpQMGqLEyrmU89tWxQP57/b5GDhzxUNg9HIrgri9n4XVQD8Cz48n
	KJhvf0Yg3BdF8LilBsHcZCcD8foCeDr8Kw1TNj8NkXYCrpMBBsaGwgicDjuCGw87WBgLxygY
	tJ2noGGWgKPhWwrq2jopGHJPYGip2ALhaTuByo5FDN6/ggwEfs+Ac+ZmDF2BXzCMd5wh8MCz
	ykCFY4mBKzOhhKz/NoY/H4YY8A0P0TBaa2EgZJtCcDoyjeBEjxuD/6YJgXn+GQMDlm4KLixE
	aJiwPsJgbr5KgdcTJDDT6KTgzv15Fk7fdRHweetoCNqbCESdiZmpZpmF1jEMdbFKAqdM9Qnn
	rSUWrCMfg3MhE9riQQQR2wIDjlsPWK1WXDJZsWi6Gyei56wHiU9X7Ei8MPg3EVcW7xGxuWqF
	EmuHt4k3Gu+zost7VPRdTBfdXbOUeC66yIjeS1VE9EbtrDgR7CIHNZ8qP8jVGfSlOnnHni+U
	ecGGk7h46oVj/1oeoQr0s6IaKTiB3yn0TV5lqxG3lpvqDUlM+LeEUGiZTub1/OuCzzLNVCMl
	R/PjaUJNiwUn+y/xkjDQuDXZwfwWYbbKj5NZxWcJ3/st1HN9mtDa3r3mUST45Zhzjav5XcIf
	jwdw0inwPoVgXegmzwevCj0XQ9iGVC607hJS6wtLjZLesHN7Xlmh/tj2w0VGL0o8XMvXsc+u
	o+hodi/iOaRJUYF2f76akUpLyoy9SOBozXrVm1sP5KtVuVLZcZ1cdEg+atCV9KINHNa8onrv
	yVe5av5L6YiuQKcr1sn/XylOkVqBNm+2Lb8sGf0pbcc3tPePbJIPWXoDu/fmMO8UZf/gc2gN
	qQXmjyqrvN9Nvr2Srd1vnPlwLkJe3OF7P2vdJ1339t3c1Hp9l1y8tzyjdu7skxH3az+Fy7J6
	cmT3nttL4+mneq7FrXcyzPtcb8RGynOCmf9omz7fGB79ZrAzrYBezCkP5GlwSZ6UmU7LJdJ/
	7tbiI2wDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUxTZxTGfd/79vbSreymYrxxZtYmfibiR6Y52YxzyyLvUJa5GHWLiTR6
	MwqlmJahmMxBWbPKxECztkphMja6CVWwpcyONBKc+IFuMFSIikBSO/moddiCfBTWmuyfk995
	znOenD8OxyhaJEs4jS5f1OvUWhUrI7KP3y1ZF6M7szcEhxaB2fQ1PBoISOB+cRuBaMRMoKrR
	xULM8ZsUzO6zErjRayTQdbEBwUDUjGByxsGAyTdPIGbpkEJk6qEUrMUI5v0dCGzdFgb6uq4w
	4GouxvCiaY6F0avjCKxDARbsw8UEws5TCCqDDikMX0uD0ECrBOb7/8HQOzGGwBmYwxBo+xZB
	zJYD52o98XXbcxZm7vzFgN3aheDHoX4GxocHETR3PEbg/9XIwpNyLwM9gWS4Gw2zcNP6HQuh
	7ioMz5pYqDH6JdB9exRBtcOCIPjAj6Hkp0YWbNVuAr7B36XQPTqL4ZHNgqHBnQEDziCBzvJa
	HD837rq0GBz2EhwvTzFYL7RimHLWS7fXITppOk1ovacFU9PfMZa6fnAhOjNtQTRSV8JQU3m8
	vToWZug3nqO0rnOMpdPReyz1T9QQeqtWoD+fnMa04s466qvsl37y/ueyrYdFraZA1K/flinL
	um83kiNPXjv2b9kIKkJ/JJUijhP4t4VzNm0pSuJYfpXQ1zfFJDiFVwqesqCkFMk4hu9ZJpxy
	lpGEfyGvFq5Xrk54CL9CGD7pJQmW81uE771lOMECv0xoaGp7lZMU1y/OVr/SFfxm4WH4OilH
	shq0oB6laHQFuWqNdnOqISerUKc5lnooL9eN4t/k/Gq24jKK9KS1I55DqtflsD09WyFRFxgK
	c9uRwDGqFPnK1TuzFfLD6sLjoj7voP5LrWhoR29yRLVYnr5PzFTwX6jzxRxRPCLq/59iLmlJ
	EVo/M/l8xJmVtyHT/eLTzL3LXbrI8bSwYsK49mb2NvbDkMerpKEP7r2XMXcldvCNqvyMz5TK
	j6K9e3z1l996WtR/YvC81N16djL9WajTu/uXpSs2rTnxznLf/v3U32LHXoUn19y8JrXiwAiX
	vGNTLz9undc2vVyAd201K/9sbD+afEZFDFnqjWsZvUH9H6rrtARJAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A78420002
X-Stat-Signature: pazx95kie8zca4jgbyfxkqbpz1zag4zw
X-HE-Tag: 1783318807-3184
X-HE-Meta: U2FsdGVkX18ShPwb6h+tYrBqxiXX/CeZgcwgiH6A+ifNzclySIn9yCSrRiAIRT2yfp8krriNAuQ2kIFqd9PU1X5btPzS3qRXPXsCNtnnJctlyFXHyEZTQVtvDBfxJAAZMvL679qfUvKvtoskhS2GBJ9pbbRjK0qHksiQaAZR28bdUbiuqrXy79uZIVpPHFVWMdpsxSdmxuc3mr7NO0HIMkEcXeCqi49gSiLhOLWGL3d/kQkW+61lq0cisM8JIUVg6Rp0626q2/fzhG2HCD7BV94yTojpdQ6HuiO5n1QEAGx6d7V6Wk5fN22GjfHrmqOqgfFgu756Uqj6s6bUEvU1OAA8HRo8plGoC0YnQzPQu5wiSQSJ/nTySqkGRJlOztceEB04TCMvnVir3R0Rt7SP1hBbvNQZ2Flt+vXsYn+aD7fxFlr0A2ORYKVF7BxB+dh2faiLPA2cnsK5GCdGHgHlcDGgoffOtARvx2UR8QeK+I/yXRxSE9TPMuIyL3QXgw9nxoAZFacLWVlkQaRiP0R1xskub+9Otl9tkIxFKFYHl3cPSL1QCwU5Mtm9jMpudG+96kifkEoKGq/jjUipURIcycyByTcRmqcsR7BLIYipNFGDcnrOfh3uc5cTPZEOSe06LRbMCU0YBIfC6yXMUBJZi9zdtbkWfgqCF1xMsNvXJZtQ/AMViElHLre+RDIcOGrMLzKKe0DZ62titu9o3vBu2ew/BFWDlNP2fvBZyflDEW8YQdaocF4KVXBUNN+p6JGAHdlysjktlZOkUUSMHpJOGYzZpxoa8CDZX4apKuOgkbWvIoGKn/4zeUOUeFDW+lCb1ijzRFeJDHwACxSzRM6RVBz9OeSNndQaCeJiOTrPAtB/xD0qCHQNt1zCN25BiSr94Zw1MJiY5iLWQzprsJ66fsh2GVxT+rUUHxItQqjrh/9U27MlXjWzxwHxpJyYZoEHSszNOh6hGuXBAIOv8eu
 dWoDEuRY
 gk3Fyq5W/qkvi6or2TOMK1GRXp1PoHDB4miQ/t/iM8RxgAHlbtvIY3s1MrLjTgnS+64wQqJfI8/hyeosnhYRLjBew3ddGDO5pMtlieRqEODVfQJRdrxP2Ira3DkF+USHDtDLZXEpskLQpUuhu6HDx8vwhDHQmXMIwKJv1/ZwFMBGfKsfvxmssUFFjPt9wGAX2RlBoZUVSL37D31w=
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
index 4b4b28ddc819..3af360ba17d8 100644
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


