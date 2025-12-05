Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8567DD2E018
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728086B00D7; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515846B00D8; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00CE6B00D5; Fri,  5 Dec 2025 02:19:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C40E46B00DD
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:19:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 636A8140463
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:57 +0000 (UTC)
X-FDA: 84184568034.08.16EC1B9
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7E79D20006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=QO0ktSHVV2QMWlvFK6KCv9VHqzEu0CUax1zwOXR8vGM=;
	b=fwf4922Akawz9OUvXrrbJM8KqG5d5XR+mwQERN8k/vbYJZs8pr6rpSmWfCrwJsG5awcuLe
	zsWF5UkgBS9SlP0li6OIQfBt3U+y1NMyvMOfhJr7NUKyJW4NNA6l4ldRGNlXvstoKWldpD
	L5uSzaVvrBv8aRIwbcp7uDEJd6tm64o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919195; a=rsa-sha256;
	cv=none;
	b=Vf9Z+7vdTDLXrRMpcplultES5zjJS1kJ2tX07RUeLBcJRyarn4r9eU6kcW7v5rAW9gt58d
	DXSTsmFAfwSW56rsDuz8LAZdxrcY1vcXJUgHWYEPY5lglF4r10u9TMbyRoahg0R3ISrP9Z
	rAeVGIc1AGXAKahKnfBG+yoqD6RAcFs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-06-6932876c3129
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
Subject: [PATCH v18 09/42] dept: record the latest one out of consecutive waits of the same class
Date: Fri,  5 Dec 2025 16:18:22 +0900
Message-Id: <20251205071855.72743-10-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSbUxTZxQH8D33PvfettLlrmK8sgRN0ZgwETG4nA9zGpZsz/xgTKYR4YN2
	coWGgqblRTYlAnN0DBBqKhkVLSBIaHlJwQWBxspmdbKGqyxSXHkzBUQlIwg4Co5Bjd9+Of9z
	/p+OjFYNMWEybXqGqE/X6NSsAiumQ6qj0gp3a3fV2ELBN+Jn4EmeC8P8nBHD1RY7Cw8G8jGM
	zBsRvDW5OVhxuhF4pTs02NvzKHjd+h8LL3+bRWAe87NQMZWH4Z/6YgSVExYOpu59BStDkxT4
	XYUIljx9NLS7hxE4G/JZGC+7RUO//0P4w/wzC9Z8JwNVFhOCiadOCgpqW1i4UuXAcHu0k4NH
	L5cp8F0xUdBbVkOBpaKAAnNTFwWL9Y0cWDz9DDxrqORgeSwG3LZJDoYumTE0T/cx4Bi8h2Du
	rzEK7MUTNBg75zE4n34C1T/ewPDLNR8LxrdzCNwdzygobr3FwLB9hQHJ1cvAY5uEoWXSS8Hf
	nksc9HU2MVA38IiCsVEvA22eP2mQyksY8JaNo/1J5M3FUkzs1+yILAVMiMzVFdDkh7ZsUtf7
	iiUPawRS7okityuHOGJ1ZJK2hkhS2z1FEUfjTyxxzJo4Ur30nCa+J93soagExWdJok6bJeqj
	Pz+hSOkaqcJnxtedHbaWcxfQ7/IiJJcJfKyw0DKI37vWP0+vmeW3C17vYtCh/BahrWSCKUIK
	Gc33bxYKF0uDwXpeI/RPPmfXjPltglQ9w61ZyX8quCqWmXelmwVbqyu4L1+dmwcCQav4PcL1
	ojfBUoG3yIXO9hn63cEm4W6DF5chpRV90IhU2vSsNI1WF7szJSdde3bnydNpDrT6dPXnlxM7
	0Kz0TQ/iZUgdonRlx2hVjCbLkJPWgwQZrQ5VvtLt0qqUSZqc70T96eP6TJ1o6EEfy7B6o3L3
	QnaSik/WZIiponhG1L9PKZk87AL6KHU7HxKQ5BnskfupX4QbStni5l+TFSnhEdga2B8pnv/2
	MohOaZBtPnwOv7h4dN+p3IgNYUdy7TF7bVu/xl05pf7xc8mj8ZnRZHrH9xW8dJOLsMVGj5q6
	khOP+VaauvdKgYNf5kcdGkwoz/33zsnZjviIuHXG9gMuVSSVGPdQjQ0pmphIWm/Q/A+W/F0p
	cAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSWUwTcRDG/e/ZVqtrJWHFB7XRmBA8MB5jPIK+sGi8HoiJL7KRjayUI62C
	mKgcNiAqQk1bpaAIUhCKYIsHkMYGFW8FqtIgUDEFJaAoUgjlsmB8mfxmvm++zMNIcMUjMkgi
	xp8Q1PG8SknJCNm+rRmrVZnrxXVtZcsgS3sOOtweEj6lOQjwDmcRUFBtoWDS9JCGLOt1El60
	pRPQfLcSgdubhWB03ISDtm6agEldEw3DY59p0KchmLY3ITC06HBwNT/GwVKbhsGfmikK+p8M
	IdB3eygw9qURMGi+hCC/10RD37Nw+OFuIGG68xsGbSMDCMyeKQw8jkwEk4ZYuFls868bflEw
	/vY9DkZ9M4Jb3Z04DPV9QVDb1IXAXp5OQU/ufRycnvnwwTtIwUv9RQp+tBRg8LOGgqJ0Owkt
	b/oRFJp0CHrb7RhklFRTYCi0ElD3pZ6Glv4JDDoMOgwqrXvBbe4l4HVuMeY/1++6FwgmYwbm
	L98x0Fc1YDBmrqDDShE3qs0huArbA4zTtk5SnOWGBXHjPh3ihkszcE6b62+fDAzi3HlbMlf6
	eoDifN6PFGcfKSK4V8Usd/uCD+Py3q7m6vI76QM7D8u2RQsqMUlQr90RJYtpcBcSiT1zT3UV
	5dGp6Kk0G0klLLOBLfF48RmmmFWsyzU2ywHMMtZ2uZfMRjIJzjiXspljObPCIoZnnd++UzNM
	MCvZ5lu/6BmWM5tYh3GC/Be6lK2sccz6pf65vs03ywpmI3sze5TMRbIiNKcCBYjxSXG8qNq4
	RhMbkxIvnlpzNCHOivz/ZD4zkfcIDTvDGxEjQcp5ckdyqKgg+SRNSlwjYiW4MkA+oFonKuTR
	fMppQZ1wRH1SJWga0RIJoQyU7z4kRCmYY/wJIVYQEgX1fxWTSINS0ZboEGNVZoHrxfHlwtk9
	tWf2WqwJW3bB4nDzAsXBz+NL7jzX5mzYOTIYRosPtuObo1pbxa/dPeW7nCH7I9QKmeZaEKkP
	iJxfGBpxxZVfZtNPVya9T429WlP/2xCpaFcvxLj6uAP8045reSsi3kljfoeKo+0LDmvKki8G
	uxLDfPuUhCaGDw3G1Rr+L3xIHd1LAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E79D20006
X-Stat-Signature: ww49nnnz5qfr5pc7hk3d93igpautz3ic
X-HE-Tag: 1764919195-332704
X-HE-Meta: U2FsdGVkX1+B/josdP4d4t0FkmrLsAX6mtkXYNZXD/Us5EzIF1kpPZEOSn3Bs1m5Dy5gtl55ZTwLQ8xVYlsZEtbkB4xSXlYAxgIiOxUxU+Bo8GwMstXnVvHXgFv06MJKRLY/0E4EtFIOSHBokGxJqSXfw9d2txx/LNr68W8WnrbHps2AWPHz9XzGSXIidFKWg5T2knd1jPspW1oYIMWg5S1Wwb+3HbwzFqBXFqmu0u8nLYgcLRGEVk7FBCAkW+pOwJ/7ntAJa+ibo/6/RkkiMMcG/kUZtloiuNNK0Lb07d375Fc0CipqbnY4WdGPEtyQS4bXlOIzgE18hc5STvmOJpbFvOTrMMF+szPDMNNrLDYUumDBqIzDN27cufNjymV/7i+1la1URKtCI2kPjUfhMw7jaKevDSg4l7MXVslcC69rPGf/veuiHxcrsMwssg6Q/1l/KwXsOlAyXJf2wm9d33KiGnYGf21sXnb4DnBemrAXFJwx99Rirm4nb+3/ebBKsdhwd90cSVfvxYXgKA0JLvWog+dRejFpTmlTqKf8xru5ZS6d/GG94pAJNTBp0bHSe4CoYi5QlTl23lmSel+AOIqcq5H2sNCRINn2PcX8WkArLurEWbtXa2rMV85jBeO0pZaWAOVmA9A6qkonW1EY5FRRzstl9clAFw77szirkDM8H5QA7S2r65LRe74ihS8Rg7lcEGRYuvfkmQY9BiJQxur2sg5cH2zkF6WEsXfb5o7ulYg7xFogMOYS3MDVWJLo9WniWwex0qp0L1kwTv5ttPcaHu/rjZho8BPPuidYSEY3AjjSUOD1Ywk9l4/7lUytpWu19HRCmJbGg6fNhp6M44IO+CjuEjnsDlEtJbmFKYkHOu1Bi0d4Jh5iyJUfvL5wJG+fuDKFzMs8rFX5Uq5AHNuh6qdxi1WvOsXrMP78g9jR8M+gpHsoJGPbPjI3rL4yDCeAeGRyIvU2LeZFtaQ
 2W+5RWFM
 qFujs46dzZCjZyyg0q0HBV4nSRK8rN49BtWmt
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


