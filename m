Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CEF1D2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B49D6B00FB; Fri,  5 Dec 2025 02:20:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9106B00F4; Fri,  5 Dec 2025 02:20:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEEE6B00F5; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8990A6B00F5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5166A1A04ED
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:04 +0000 (UTC)
X-FDA: 84184568328.05.5D4EBD7
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf14.hostedemail.com (Postfix) with ESMTP id 66E36100002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=igOAQV6CSHNc2r3QYmChQK0lqKt7aIgNioL79ZTzzhw=;
	b=Mmkm0C0h8poNDiAF01izaT1DJaUy6zdU0WzHIjw+bvCxRpyqag0o6XCvi8rJlZk40C180/
	sK3PXAW73uQPb03VkT3sZqDn3VFUiXps/Hd/95GPxhXPoiVm078qIAvIjI2s2YWFNvrxCl
	rbDXdwHYCSs3gC7zLn9163TcLLY1OZQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919202; a=rsa-sha256;
	cv=none;
	b=rgCEvqGIUf7GuKyz49n/VJwA8zoE8ff4o0YCqQvsevKVYU3GlSRyfOxKqAVqotMN5OCVbE
	HQ0oI4hHA/+e4kV11zjI0OQmxj1mNJ1WVvB2gIgOWus68cDb1Qd+9EGmgt8//Jt1C4r8D4
	BqeOz/lJAeI7PjgO2JR6Par0vNl4mjk=
X-AuditID: a67dfc5b-c45ff70000001609-4d-693287712395
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
Subject: [PATCH v18 28/42] dept: assign unique dept_key to each distinct dma fence caller
Date: Fri,  5 Dec 2025 16:18:41 +0900
Message-Id: <20251205071855.72743-29-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSfUhTexgH8H7n5bc53OXcJXRSwVhEYGlaGU9Q94pwbycouFD9UUG3Ux7a
	oU1tmi9BZOVwmXnNmN3rqtksGWq5tiK1TLNaWa6tN11lzsy3lS9grmFpu7rovw/P9/k+fz1S
	UvGajpSKaVmCNo1XK7GMko2Gm+O0hSvFhIeWSNDrjkDn0VYK/JN6Cs7V12GYMd6UgPtqLQKv
	X48g8M1Igq4xSMHk1FsJGI4iCDY7EHjcLSR8tn7H8OneBALD+34M49XFCCoGjRLwPdgAo95b
	NATfDRFQ3f+dgP7WQgQmsx3DN6eLhLMGN4Lrjh4EzZZjGAZKb5Dw0j+Ood1wEsOYFcN5YxmC
	41X1GMrP2yho7G2SQHd5GQG1ts3grR6kwHh2mICOqu5ZOV/Q0GepkECwMh2ujrpoaO/ppOFm
	fq8EbB9m9d+Fbgz6mUkEjoY+AoqtN2joqQvSUD/kIeCJ4xEFrqYrNFzuekbA+14PDXZnBwlf
	SqLAffoUDZ7SAQRXxswYzowNouRULqAroTjd8xnM1V2oQ9y9kXGSK7DncJefjGDuq/8V5h6b
	We60M45rrHgn4SptB7mC+6M0Z7fEclW3fQT35tN6zlZzAv8Vt0O2LlVQi9mCdsVvu2WqsjtF
	dEbf2lyXb0iSjxrji1CYlGVWs03+f6mf1hlriDljZinr8UyRc45gFrH2U4N0EZJJSeZFDFs4
	VRIK5jPb2WvDplCZYpawAWcHnrOcWcMet7cRP47GsLXW1tB+2Ozc0PU1ZAWTxJqKAqGjLGMK
	Y1va2/GPwkL2rsVDlSJ5JZpXgxRiWraGF9Wr41V5aWJu/N50jQ3NPlz14emdDWjCvaUNMVKk
	DJe35iSKCprPzszTtCFWSioj5CPqBFEhT+XzDgna9L+1B9VCZhuKklLKBfKVX3JSFcw+PkvY
	LwgZgvZnSkjDIvPRn8oC9NCRvE217uPaV+W/R/Bmbdle78aYVSkbjG7bxnkpnYunc/YlvhSL
	Ta8Lcxcca3h6P6klqeGfAsMv/clKuSM6unlPYE3WsviEVRcPtdjm+4q7zJMVKc826fRbfQOi
	Zljj0uT3pFi9B7Iyti7v/EO5K6rb+Dl60/5w1fQEf+lXJZWp4hNjSW0m/z+YVYC2bAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+7+3zdHkZRm9WVCMLhBlKl1OFJFf8o9g9CGK+pIzX/LFOWsz
	SyNqruVaF3S0SXszzXSV01JnpdVSlOympK3ULqbFsoaaZepwpjaNvhx+5zzPeTgfjpRU1NLh
	UkGTzms1KrWSkVGyHZsNaw7nRAuRP3sXgsl4Ej72eGno0DdQMDpiouDKnXIGJsX7EjBVX6bh
	WWc2BW23nQh6Rk0I/BMiCca6aQomLc0SGBn/IAGrHsG0uxmBrd1CQldbPQnlNXoCfldOMdDf
	NIzA+tnLQL5PT8GQ4zwCe58oAd+TWBjseUjDdPc3AjrHBhA4vFMEeBtyEEzaUqCw2BVct/1k
	YKL1FQn51jYE1z53kzDs60VQ0/wJgftmNgNfc++S4PGGwpvRIQaeW88xMNh+hYAflQwUZbtp
	aG/pR1AgWhD0vXcTYLh+hwFbQTUFdb0PJNDe/4eAjzYLAc7qeOhx9FHwMreYCJ4bdFUtADHf
	QATLdwKsFQ8JGHeUSbaVIuw3XqRwmesegY2vJxlcfrUc4YmABeGRUgOJjbnBtmlgiMSnXUdx
	6csBBgdG3zLYPVZE4RfFHC45GyBwXusaXGfvluyM2SfbksSrhQxeu3ZrgizZ8thMH/qy6dgr
	3zfJKVQXYUYhUo5dxxnFMmKGGXYl19U1Ts5wGLuUc13oo81IJiVZzxIuZ/zirDCP3ctVfS+k
	Zphil3P+1hZmhuXsBs7gaiT+hS7hnJUNs/6Q4NzaGZhlBbueKzT76VwkK0JzylCYoMlIVQnq
	9RG6lORMjXAs4kBaajUK/pPjxJ+8WjTiiW1ErBQp58objkYJClqVoctMbUSclFSGyQfUkYJC
	nqTKzOK1afu1R9S8rhEtklLKBfK4PXyCgj2oSudTeP4Qr/2vEtKQ8FNoRY0u/tYt14V5VOz8
	wK/E+DT75po4W3LJjY2mqIgVOPQ+Tszj02sLOnaeGdtzoinag/M7B7dUxeigUJEYWn/Jt53f
	WLFacM8RF2tUYn9M2HExZJHeHKc5s3rpo6QE++5d4RV2jbM1MPSgw+l/+sNT4ihKSF9oyTK+
	w1lTy4aVlC5ZFbWK1OpUfwEB28b5SwMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 66E36100002
X-Rspamd-Server: rspam11
X-Stat-Signature: j96zpict1dqqtjr74rr9zxsrb9hy37kq
X-HE-Tag: 1764919202-399277
X-HE-Meta: U2FsdGVkX1/JsIErXGw4qagLAnWvmLXGaxIymCCfB3oE2E/d9YKjQUW+zHNbvnaXZOfijwSAvPGKNXy0oO/mbc4AE3wzWIOqt2xGmRuY2GXwzJV6v7ZvVuhyokpZ19aDGs7SRfIkVIeoRmpBxXn0MwtaXG26gksTm8t8+zYIFzNq4K2Kapbti/rHjPBU4MKJobMyCZ7LevrySvTiwghH06gwAZABH8iMcSmM5+e9Pkr99/6mfZbKIlHcrjRY1PRTmhkZtiM7b7frtQa9ijm96hWN/2JcB7TCakYaXqCPIr82y38pI+96Rz4sb7pVkqOa3GsMNaGMmtL8EFAbUb1xP3VEaPeaKfUrxpLInOCdgvGrmYV6RsUzm+H9nvbXBMgt75PROXQxsvqu3tnfMzXsmS2ScoM41ckT7N23Bqh5TUbLXY5ko1LM+iiSxh7n7S3n8FB3a07AkXykmvzd+ZqQVzyt2AJBryf5FFs5iMQcv3NpiiDK75TOE+YvAZY7B1ZWII7I/1ffWfdFmqUI5+WmzBDipAupcvt2oJ9QfE953jtvDZABRUFDdHZBtH764HJEkEJmJGMA+qacs+ptg4Q16Psl9P91cDwftlrpKbXCugpTyuIob0+DnUnLCiG1Wlphwq4YHmSDz52t2dJjKcStcXWVg5s1lNxq36NJ24NCbjzuM5rz3VyzJHhlBMmuO9N8W/WHiz9dlef1xwTeCdfGI74ncln2zmE6tD6aDQ9ArCE4Lf34CZxDps7TA88hPRSW3BdjGEVI4XpG4YqpkGD8ihJBYySv41QAdbhae3J/mhOG0DJadHzhGuyd3cdIexJzj9Lr5n97TfBXeWLEmYcR7JbqGMDPr1BmYAKHFMGTdFfaC49LzzhSVWG5jCrZF3w5KfRoMopJgB4Y+cdozRWY1l5gamevlB60c4PguJ3s3fAY+Ty5oa3WFXU+lABlUfaN0YKrvjenqIY4BCu+Roz
 1K/IvnV8
 e9Q7cTmj5DPPN/o7DBV9+knlzS7f6tYoAEp047U3RxhdrshrQ7U2PRx8MUUDkDrDWDJK8uCqsmcVs++IDvWB0MSvPrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dma fence can be used at various points in the code and it's very hard
to distinguish dma fences between different usages.  Using a single
dept_key for all the dma fences could trigger false positive reports.

Assign unique dept_key to each distinct dma fence wait to avoid false
positive reports.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 drivers/dma-buf/dma-fence.c | 18 ++++-----
 include/linux/dma-fence.h   | 74 +++++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 24 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index f2cc7068af65..ca0ff298859b 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -479,7 +479,7 @@ int dma_fence_signal(struct dma_fence *fence)
 EXPORT_SYMBOL(dma_fence_signal);
 
 /**
- * dma_fence_wait_timeout - sleep until the fence gets signaled
+ * __dma_fence_wait_timeout - sleep until the fence gets signaled
  * or until timeout elapses
  * @fence: the fence to wait on
  * @intr: if true, do an interruptible wait
@@ -497,7 +497,7 @@ EXPORT_SYMBOL(dma_fence_signal);
  * See also dma_fence_wait() and dma_fence_wait_any_timeout().
  */
 signed long
-dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
+__dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 {
 	signed long ret;
 
@@ -526,7 +526,7 @@ dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(dma_fence_wait_timeout);
+EXPORT_SYMBOL(__dma_fence_wait_timeout);
 
 /**
  * dma_fence_release - default release function for fences
@@ -762,7 +762,7 @@ dma_fence_default_wait_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 }
 
 /**
- * dma_fence_default_wait - default sleep until the fence gets signaled
+ * __dma_fence_default_wait - default sleep until the fence gets signaled
  * or until timeout elapses
  * @fence: the fence to wait on
  * @intr: if true, do an interruptible wait
@@ -774,7 +774,7 @@ dma_fence_default_wait_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
  * functions taking a jiffies timeout.
  */
 signed long
-dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
+__dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 {
 	struct default_wait_cb cb;
 	unsigned long flags;
@@ -823,7 +823,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 	spin_unlock_irqrestore(fence->lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(dma_fence_default_wait);
+EXPORT_SYMBOL(__dma_fence_default_wait);
 
 static bool
 dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
@@ -843,7 +843,7 @@ dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
 }
 
 /**
- * dma_fence_wait_any_timeout - sleep until any fence gets signaled
+ * __dma_fence_wait_any_timeout - sleep until any fence gets signaled
  * or until timeout elapses
  * @fences: array of fences to wait on
  * @count: number of fences to wait on
@@ -863,7 +863,7 @@ dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
  * See also dma_fence_wait() and dma_fence_wait_timeout().
  */
 signed long
-dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
+__dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 			   bool intr, signed long timeout, uint32_t *idx)
 {
 	struct default_wait_cb *cb;
@@ -931,7 +931,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 
 	return ret;
 }
-EXPORT_SYMBOL(dma_fence_wait_any_timeout);
+EXPORT_SYMBOL(__dma_fence_wait_any_timeout);
 
 /**
  * DOC: deadline hints
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index 64639e104110..1062fbb637e5 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -369,8 +369,22 @@ int dma_fence_signal_locked(struct dma_fence *fence);
 int dma_fence_signal_timestamp(struct dma_fence *fence, ktime_t timestamp);
 int dma_fence_signal_timestamp_locked(struct dma_fence *fence,
 				      ktime_t timestamp);
-signed long dma_fence_default_wait(struct dma_fence *fence,
+signed long __dma_fence_default_wait(struct dma_fence *fence,
 				   bool intr, signed long timeout);
+
+/*
+ * Associate every caller with its own dept map.
+ */
+#define dma_fence_default_wait(f, intr, t)				\
+({									\
+	signed long __ret;						\
+									\
+	sdt_might_sleep_start_timeout(NULL, t);				\
+	__ret = __dma_fence_default_wait(f, intr, t);			\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
+
 int dma_fence_add_callback(struct dma_fence *fence,
 			   struct dma_fence_cb *cb,
 			   dma_fence_func_t func);
@@ -607,12 +621,37 @@ static inline ktime_t dma_fence_timestamp(struct dma_fence *fence)
 	return fence->timestamp;
 }
 
-signed long dma_fence_wait_timeout(struct dma_fence *,
+signed long __dma_fence_wait_timeout(struct dma_fence *,
 				   bool intr, signed long timeout);
-signed long dma_fence_wait_any_timeout(struct dma_fence **fences,
+signed long __dma_fence_wait_any_timeout(struct dma_fence **fences,
 				       uint32_t count,
 				       bool intr, signed long timeout,
 				       uint32_t *idx);
+/*
+ * Associate every caller with its own dept map.
+ */
+#define dma_fence_wait_timeout(f, intr, t)				\
+({									\
+	signed long __ret;						\
+									\
+	sdt_might_sleep_start_timeout(NULL, t);				\
+	__ret = __dma_fence_wait_timeout(f, intr, t);			\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
+
+/*
+ * Associate every caller with its own dept map.
+ */
+#define dma_fence_wait_any_timeout(fpp, count, intr, t, idx)		\
+({									\
+	signed long __ret;						\
+									\
+	sdt_might_sleep_start_timeout(NULL, t);				\
+	__ret = __dma_fence_wait_any_timeout(fpp, count, intr, t, idx);	\
+	sdt_might_sleep_end();						\
+	__ret;								\
+})
 
 /**
  * dma_fence_wait - sleep until the fence gets signaled
@@ -628,19 +667,24 @@ signed long dma_fence_wait_any_timeout(struct dma_fence **fences,
  * fence might be freed before return, resulting in undefined behavior.
  *
  * See also dma_fence_wait_timeout() and dma_fence_wait_any_timeout().
+ *
+ * Associate every caller with its own dept map.
  */
-static inline signed long dma_fence_wait(struct dma_fence *fence, bool intr)
-{
-	signed long ret;
-
-	/* Since dma_fence_wait_timeout cannot timeout with
-	 * MAX_SCHEDULE_TIMEOUT, only valid return values are
-	 * -ERESTARTSYS and MAX_SCHEDULE_TIMEOUT.
-	 */
-	ret = dma_fence_wait_timeout(fence, intr, MAX_SCHEDULE_TIMEOUT);
-
-	return ret < 0 ? ret : 0;
-}
+#define dma_fence_wait(f, intr)						\
+({									\
+	signed long __ret;						\
+									\
+	sdt_might_sleep_start_timeout(NULL, MAX_SCHEDULE_TIMEOUT);	\
+	__ret = __dma_fence_wait_timeout(f, intr, MAX_SCHEDULE_TIMEOUT);\
+	sdt_might_sleep_end();						\
+									\
+	/*								\
+	 * Since dma_fence_wait_timeout cannot timeout with		\
+	 * MAX_SCHEDULE_TIMEOUT, only valid return values are		\
+	 * -ERESTARTSYS and MAX_SCHEDULE_TIMEOUT.			\
+	 */								\
+	__ret < 0 ? __ret : 0;						\
+})
 
 void dma_fence_set_deadline(struct dma_fence *fence, ktime_t deadline);
 
-- 
2.17.1


