Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A132CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DC26B00E5; Mon,  6 Jul 2026 02:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277216B00E7; Mon,  6 Jul 2026 02:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2AF6B00E8; Mon,  6 Jul 2026 02:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6BD96B00E5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43EF0402BE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:55 +0000 (UTC)
X-FDA: 84957353670.13.6730D77
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3CB5B20002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=kNVAe/X4lOnhSLDK+pJO6rAgr055L/z0/R5my/dmM5g=;
	b=pA0t9UpHGbO+BCoDyXXxYHHsFuHXGN8jUeTpSXEuissVHZ7PPZ1kmpwIbah3sqftxA/H3B
	Izg9qm05L/NUaq6qfQ6BB6xopr9CSgc8KMNYN4udSz9CJBCOt8T6vdL+Dl3fodeWqvxPIS
	NGprjSg2JK5Va2ctK5p5zv+f3U/t+YQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318853;
	b=xxOQKqIS35l7peZWzaWqd5FObhxjIqA0TuTHpR9Qz//OaP9kZoPu9jBX+6MWznFM66I0/7
	ZvsAht0uXUFoE6ailzeVa0ABwKcC+lQIS4MfNW+WJFSyrHOnbfn6YrHCd19IB0IEv5DIfx
	B3jkDraeOS7xZkJqffOqbro/Xn5zRRw=
X-AuditID: a67dfc5b-c45ff70000001609-94-6a4b4904e0e8
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
Subject: [PATCH v19 28/40] dept: assign unique dept_key to each distinct dma fence caller
Date: Mon,  6 Jul 2026 15:19:16 +0900
Message-Id: <20260706061928.66713-29-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTZxjH957znksbupxUE8/cB0yXOcIUp1H3ZJmbmiW+0ywzQzOd21wz
	jlDGLUVRtjhppIww3LrOQkKpAxwNl8NlFMLFG1YpQyEWYaVUBNRaYQpELRBF7VrMvv2e55//
	7/ny8LTawyzndWkHJX2aNkXDKrFyKqp8NfPxjuR3/P0bIN94DEbG/Ax4DJ0YZoP5GEobZBae
	W1s5GJvNRzC/YKXB2B7C8Nzs4sBiQBA650JQ1G+mQW42UPC48QULllt+FoonDRhm7IUIJru2
	QejmPQqG5h4g8Hf+hKDY4kbwaHIcQbNrFMGA/1UYnJ1hocfyMwvTjSzYrOaw1taEoX28g4OR
	IjMFY/YAhqumCgqK/loG1uIJCix1Zyh4Yq/hoPf0CIbbVSUchMrSwVV7j4P6qWsM9Ix6GLgf
	MLMw1p3HQGvOOAdNw10IgoO3KJALAzSc870NAx2lLBQ2tjAwKocYyLHOM3C91h2+5/obQ09J
	NYZrHXUMVA71U+Do66XBa7qLoG66gt2cQOaNv2Ain5IRWXhqRiRYeZwmRlN4zHUcJpVXH7Dk
	SoVIfutbTdpLbnIk97yPI2VNh0ju5SmGOKpiyemzkxTx3d+0c9UXyvcTpBRdlqRf88E3yqQG
	TzedYXvviPfPz3LQ07gCxPOisF6cMxwrQIpFXDj1mI0wK7wler1P6AgvFVaIjhMBpgApeVoY
	iBYL7SdwJFgi7BVvX7izWMDCm2KXc5qJsErYKFZ1DFMvpdFibWPnokgR3tc/sy3u1cIG8cZM
	N45IReEPhfhr9XH8svCaeLHKi01IVYZeqUFqXVpWqlaXsj4uKTtNdyTu2/TUJhT+NvvRZ/va
	0CN3vBMJPNJEqWDz9mQ1o83KzE51IpGnNUtVK2N2JKtVCdrs7yV9+n79oRQp04le57FmmWrd
	3OEEtZCoPSh9J0kZkv7/lOIVy3NQ/IdtqrP+8jtydb1z/8YDNtm9a3vzRwHf7yOxWy9e0ZR/
	+cNMi8sTtXvb0MlPiO6hW/53eB7H9O9UJ2YsKf3UFPOV40e5Fs60XnhR+fn09Ut7m9/Ie9d0
	EkXt7g32rWxXTHyt38eSuuCahn/yW/ImXHuKBpPlmhu+o23xxkRn9BaTBmcmadfG0vpM7X95
	y2B1aQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzVSf0yMcRz2/b7f+97bcbw7mXfMsjPlx4QN+wwZjXkxP8bG+Ec3vdN118kd
	KdNSuSlidXYXTiS6WR3lzq/iVivlZ1NCh5I4kcoZpXV15cr889nzeZ7P8+z548MyiruSKaxa
	d0DU61RaJZUR2aZl6fPIug2xC566p0KGMQWaWz0SeJNaSaC3J4PAhRI7Bb/1rhQyHOck8Lgp
	jUD9jWIErb0ZCPoGrAwYy4YJ+E21Uujpfy8FcyqCYVctAkuDiQF3fQUD9lupGH6XDlHorP6F
	wNzmoZDbkUrAa8tCcL7dKoWOmrXQ3XpfAsMtXzE0/elCYPMMYfBUHkfgt2jgUoEzYLf8pDBQ
	94KBXHM9gsttLQz86viI4FbtBwSua2kUvmTfZqDRMx5e9XopPDGfpNDdcAHDj1IK+WkuCTQ8
	70SQZzUhaH/nwpB+pYSCJc9BoOxjuRQaOgcxNFtMGIodG6HV1k7gWXYBDtQNXN2cDNbcdBwY
	3zCYr9/H0G8rkq4sREKf8TQRipx3sGB86aeC/aIdCQM+ExJ6CtMZwZgdWKu7vIxwzHlIKHzW
	RQVf72squP7kE+FpAS9czfRhIadunlB2vkW6ZdUu2fJoUatOEPXzV0TJYkrePGLi85Ymuq9u
	PYp84SdQEMtzi/iBi7/pCKZcGO929zMjOJibzjtPtUtOIBnLcI0hfJbtFBkRJnI7+U8Vn0cN
	hJvJ11T9kIxgObeEv1b+Fv8LDeGLSytHg4IC/I3BvFFewS3m33sfkWwky0djilCwWpcQp1Jr
	F4cbNDFJOnVi+J59cQ4UeCdb8mDOPdTTuLYKcSxSjpPDyvWxCokqwZAUV4V4llEGy0NnbYhV
	yKNVSYdF/b7d+oNa0VCFprJEOVm+focYpeD2qg6IGlGMF/X/VcwGTTmK7NNOexec1eHlxgeR
	3ycZbe7Nac1o6FhnpmJ/ZUTKmk3e0ERHzoyECnMYjrZRdbWmbaMvBYmmsQaIdqtXsyFzv2pn
	R357KD2zrUK+fQwf9n18/PGopBVzV01IzkyeTt2m7pA5KS/UUZpiIkTcq9HfbnwSqjzij8gq
	n1Dn5CKVxBCjWjiH0RtUfwEbdFq1SgMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3CB5B20002
X-Stat-Signature: 85aqxeqdkj1rrwfq6wqsgqbaa1a8pdzp
X-HE-Tag: 1783318852-99787
X-HE-Meta: U2FsdGVkX1+5oEYxEJfw1Sizbok10YPHyQ8eF4w2neTx2hbf5+v93N9ooF388e3pRyHT3HTyyOdxWcx3Dbn2gZxedSUQ28S/MjUyB/mloV1+VYjkpE/cQRAtNoBnMsTVfH9DggMB5K+D+g/0h3gWA0XzB7TzPY0KQku7T9dvEKpn2HysCPobrZAsYtIw4NwjIQMeIzY01ZR5MquSBDIEl0nw7VaJgzSbfk2E3x5Qt5SOXBvuupxed5lRa6fRpj1N8Ro3J/LuXhlZrJQcMebCe8Q1t+rpl37L4f2Ucch+vdlC7GW+w+fOFJcRtyLa0dna4HUCt6J8bxoogmnXrGoAL07c1IB+Y4MPcs0LIv/GxQXKWBYkya8xGJkUDNuoSvaKTGMeNTqQgaoXlS0vpuJZ3PXQDnOHCsOVF9F3mZtRllQCr9c0YOgCSts6ffmkAgCTLwLXb3CBGJ3kEwr/2gOJaNsN9v+gcAb4fmjsZy+ZuqojIaD365MB30oaJYh4cW1Vz27nEBu/L01AkKrx42MorHqC91TNvwsHxqovKRfa8UjSOQ4J+a1S6BR9hAJBcexGtIKnnOYyUUB7eg05SBO4I9+iisOYQkD8zLWbXoS48ZhANstxw8UFQuJN6CRTn0aMag2kxcLYkRxbGAzIxDXpUesjiJb890jaszsT6YaTSeu94y8IwZCzuWyWceSxK+f7st6+iPzf9dmt9fZU7BwJmwYQHR/vNFc5j8X3lFFppUG2l/XvgKxXBXYrnpzPytyYzPw3feTAoUuUM70d7lOJUHxupTzNCJCdZxWqlkO/p+oo7tLGsH2Y6WLS/F9AC/zyN34A1cP0j1j2J/CJ4qlofRSLEKDUci3AR6PesbEKTXgToauMQkbiyS25WKOJ4k2K3zoxbNjWHmRk4M5gCgOit0l1Ep4pxdTAZnIzGyFXMDmiywLzGzWzM2ye8N5QcgaV2hWWWLbMs0CirAvzzVq
 JDxLTmgi
 JLK0TEGExgb3yIG225eM6gxITjaORc2hNQnFR32d4R3hgkVr7/XJ8bM7FxyDE23eovd/rRcRwsx/pjgyTh15Nl4UToyTPCMIHNlGpDfQ9426oFi/ZzJtmwHVkSyPErskT8rk1xDyfTwvmMZjI7jZ6gVW+L0yWwM2wzgTAmVegP2DSXig9FEeLdVIQQQEqF1sixVAj4ycbdjxslRhMCUjjOLfkew==
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
index b75b7b9c445a..e56044492166 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -503,7 +503,7 @@ void dma_fence_signal(struct dma_fence *fence)
 EXPORT_SYMBOL(dma_fence_signal);
 
 /**
- * dma_fence_wait_timeout - sleep until the fence gets signaled
+ * __dma_fence_wait_timeout - sleep until the fence gets signaled
  * or until timeout elapses
  * @fence: the fence to wait on
  * @intr: if true, do an interruptible wait
@@ -521,7 +521,7 @@ EXPORT_SYMBOL(dma_fence_signal);
  * See also dma_fence_wait() and dma_fence_wait_any_timeout().
  */
 signed long
-dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
+__dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 {
 	signed long ret;
 
@@ -550,7 +550,7 @@ dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(dma_fence_wait_timeout);
+EXPORT_SYMBOL(__dma_fence_wait_timeout);
 
 /**
  * dma_fence_release - default release function for fences
@@ -786,7 +786,7 @@ dma_fence_default_wait_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 }
 
 /**
- * dma_fence_default_wait - default sleep until the fence gets signaled
+ * __dma_fence_default_wait - default sleep until the fence gets signaled
  * or until timeout elapses
  * @fence: the fence to wait on
  * @intr: if true, do an interruptible wait
@@ -798,7 +798,7 @@ dma_fence_default_wait_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
  * functions taking a jiffies timeout.
  */
 signed long
-dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
+__dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 {
 	struct default_wait_cb cb;
 	unsigned long flags;
@@ -847,7 +847,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 	spin_unlock_irqrestore(fence->lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(dma_fence_default_wait);
+EXPORT_SYMBOL(__dma_fence_default_wait);
 
 static bool
 dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
@@ -867,7 +867,7 @@ dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
 }
 
 /**
- * dma_fence_wait_any_timeout - sleep until any fence gets signaled
+ * __dma_fence_wait_any_timeout - sleep until any fence gets signaled
  * or until timeout elapses
  * @fences: array of fences to wait on
  * @count: number of fences to wait on
@@ -887,7 +887,7 @@ dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
  * See also dma_fence_wait() and dma_fence_wait_timeout().
  */
 signed long
-dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
+__dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 			   bool intr, signed long timeout, uint32_t *idx)
 {
 	struct default_wait_cb *cb;
@@ -955,7 +955,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 
 	return ret;
 }
-EXPORT_SYMBOL(dma_fence_wait_any_timeout);
+EXPORT_SYMBOL(__dma_fence_wait_any_timeout);
 
 /**
  * DOC: deadline hints
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index d4c92fd35092..3732849a30b7 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -370,8 +370,22 @@ bool dma_fence_check_and_signal_locked(struct dma_fence *fence);
 void dma_fence_signal_locked(struct dma_fence *fence);
 void dma_fence_signal_timestamp(struct dma_fence *fence, ktime_t timestamp);
 void dma_fence_signal_timestamp_locked(struct dma_fence *fence, ktime_t timestamp);
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
@@ -628,12 +642,37 @@ static inline ktime_t dma_fence_timestamp(struct dma_fence *fence)
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
@@ -649,19 +688,24 @@ signed long dma_fence_wait_any_timeout(struct dma_fence **fences,
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


