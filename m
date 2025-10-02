Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF49CCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A278E002E; Thu,  2 Oct 2025 04:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10ABC8E002D; Thu,  2 Oct 2025 04:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04558E002E; Thu,  2 Oct 2025 04:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0D488E002B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 947241403B9
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:19 +0000 (UTC)
X-FDA: 83952461838.18.8DC9B8F
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1838E14000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=fq+3ZEoxJGJH4Suv7KqwWhfixWjMUxm6rwB1AqE/fZ0=;
	b=zpGcF2OuYoFhXY9k4/SVHJDT0VWuYRkr+XxAkJpmSxuju7ALxnxJcq/1kOAXofqBwp76Yt
	SCcy849sCBf6lmSuUjyy/RhksvNkf3xRNEaDsvydp2PfuXKubWLzaI2DaFjYnNvvyDTTPN
	U4SkgJDc4+0p3B48IqA35QudQ5aGdOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392857; a=rsa-sha256;
	cv=none;
	b=ZQkBwFl0CwmwUVZ3V6zTmJyJhznxg1+yUj8T1AGSQdCTuCkJVOIuieIKjMxy++ul1An779
	GzfA4ffgeDumCrlwGUCpmdcWSPddawVAU+M4uES7YWmypT5TQN7Ds2GFb9bukd8dmtCpxP
	dJd57J4CyWA+L4H5DPT9IzO7IfJ33WQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c45ff70000001609-66-68de3412bbdc
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
Subject: [PATCH v17 32/47] dept: assign unique dept_key to each distinct dma fence caller
Date: Thu,  2 Oct 2025 17:12:32 +0900
Message-Id: <20251002081247.51255-33-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTYRjHe88579kcLg7L6KTdGEglZatWPN2kPoTvlyCqD5VkrTy44Zwx
	01wULUvoosNWaTnTaSpDZ5fZh8rsskpqplmKrdLlxEYm0/Ky0pSaK7/9+D8//vw/PGJadgFH
	ijW6I4Jep9LKWQkj8YeXLZ+l9KgVntHFUHzLzsJZxzUMrTdrEEyaG0VQ8NZMwxVvLwuFfacY
	6HsRD/7P9RgmC1Lgd/MbGsq8XTTcbfQgaOudCdbsBgxN+eUUFNyZA5bC0xRcqa2noMoYDZbm
	Ngw9tiIR/LGmwStPB4Z+n5kFx4cXCEbavRRcK+kMDpgcQeCx/8FgtPzE8K6mlYE3D2oxeLvd
	wWUX8zBcGvAh6A9U0VA1OigC249CDJUjAzQ0W1qCZPNjcNg7WHB1DYvANe6iICd3TASWUyYE
	Z58H6M0KkvNukiX2Ejsiv8fNiDQErAxxlfPkflGXiFgdGaTOFkNuPOyjSNnQKCYf+zcRR/U5
	ljiGzCJy3t9Okc6OhywZaGkRbV+wV7IxSdBqMgX9irgDErU77zI+3LMu69zdbNaI7seeR2Fi
	nlPyj5w36Gn+9j4XTzHLLebd7rFQHsEt4uvyfKGc5prm8R1vl03xLG4P76j5EnIYLprvHLaE
	HCm3lq/1Xab+dS7ka24/CTlhwbzN28RMsYxbw+cMngk6kqBTGsb3FHz6P2Iu/9TmZvKR1Ipm
	VCOZRpeZqtJolbFqg06TFXsoLdWBgi9SdWIi4R4aat3pRJwYycOlrdFdahlWZaYbUp2IF9Py
	COkBW6daJk1SGY4J+rT9+gytkO5EUWJGPke6KnA0ScYlq44IKYJwWNBPXylxWKQRJRsyeo9G
	6vYn/mjpTn69RLUsq3LIqTxz/OXMwHB8VkLUr/W7Njz+PntHpen6Z9/euRUT4SMJH9YbFYnV
	2erEhkP185RrxfOjm2SlxQdX/Dzt18fvdum2vK4gJwMm2dXmwM0FS+OiHrgrFCZFUffW8q+/
	Vu8eM03swJ+2GcaLtfuetcuZdLVqZQytT1f9BXBuUcceAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+93nHK0uy+imQbEwIdIKepweRATRJbIHhWV/lLNubjgfbD6y
	qHxsZWZmo01yWT5yiVtp0yITQ7TWY1kuy6ycpi0rH62HK8y5NY3+OXzO+X44nD+OABffJoME
	8oRkXpkgVUgoISHcuiY7TLysW7ZE7ZoHHZlNBLhHcgi4VG2mIMdykYS2GyYEPe4cBL/HDDho
	6n0EjGutNIyMvqPB12hFoLdrcTDXZWLws8ZLwWDLDwS6XicFhV8yCXAZ8xAU9Rto+PJgEwz3
	NJDgc3zC4PWvIQRGpxcDZ9MpBOP6OLhSVkvBWOtzHAp1bQhKex04fK7xh3XWbgSNlVkUfCy4
	hUO7cxq8dLsoeKw7Q8Gw/RIGX2soKMlqJKHYoEWQXV5Ngb7YQkD9+7s02Ac9GHTptRiYLBHQ
	Y+wnwFZQhvnv81s3Z4GhMBvzl88Y6K43YDBqrKLhaXkXAcaMEDC0tpPQV1lEg6d3KfhKEsFq
	+kSD45yOgBvDz8n1OsT91uQTXFXtbYzTvBinOPNlM+LG/mgRN1KRjXOaAn/bMuTCOXVtGldh
	G6K4P+5XFNf4q4TgnpSx3PnWMK6+yEFz6ntv6e2r9wrXHuQV8lReuXhdtFDWefYCmdS36vDp
	uiwqA9WH56IAAcssYwde55ETTDGhbGfnKD7Bgcw8tvZs/+QcZ2xz2A77ogmewUSxFtPHSYdg
	Qtiun4ZJR8SsYK/3X8D+7ZzLmmqaJp0A/7y910ZMsJhZzmpcaqwACUvQlCoUKE9IjZfKFcvD
	VXGy9AT54fADifEW5P8m4zHP+TtopH1TM2IESDJVZA9xyMSkNFWVHt+MWAEuCRRFV3bJxKKD
	0vQjvDJxvzJFwauaUbCAkMwSbd7NR4uZWGkyH8fzSbzyf4oJAoIyUH7U5dmD72I33Fw3f2bq
	fl6WPBU2+HIPFb/91rS5w/PwSdDxgZ07vm9V2FY7d6kj9q6tDj40X4SH6o0nIvJUaZ7IxdO9
	36/CyukfWk/uuY8aHlm+BR8tMtv6Nlrdu1Lyo7YtKD21sjJyjbbq2j5FSu6bRZYYb0zuM1eo
	d4vzx8CLi8USQiWTLl2IK1XSv193NrNJAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: gtizqion9m5gt7x4smdjox1m9ru74iyo
X-Rspam-User: 
X-Rspamd-Queue-Id: 1838E14000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759392856-786766
X-HE-Meta: U2FsdGVkX1+a2hg1GMjneGK7HCb3nX99W18bAjmx75j/DyZy+QLe97j2JhaBRuZd8MbgRL1rGT4mWy8ceLqbF03s1+T4+oLoHUL5xo9bC6xV9+hfGTYmZMzYRdVEmWFkQGpoZ61Hh/jIgxUX1NghZ3XA021Lgv2fgzhzKP66kG2Bgd+SPavG9n5YqqrdjGV85WKOCcktrFgHkC9bkuutqhqsCKoW8YtyQBkCkqkRJ7iHG6lfrf999gok2zD6OZpm0ceEb5RZ7fbyzMUYafll+q2URQkFToB5mw7yWVVXhLBzEl1FCZOzvFAIycJ/r7oWDb3037GKH3HASCvEgxES9lNQJEDttfz4VkN2harjK5UD9MvvSN8YteUEiaduTs7K4jwDYZaMJZ1AYaPX+JWdsnK7gXQhLH3CllPo8r70VbBAgUl94RmYcbXoUo/xj7K4kOdQP/Ysw/k9yL6VgDLMgjmrFN+cB7VrsPAivK/nkLrZLJVekGUoznAfCYIb+wnxBgCY6wDqTek0+HybbnrdFc+SvgGXiQgkASvDedrdN0kMfyO8bs/YzBdk+Hd6R6G33nA5iJelLPa6A7lWxOuqpiW9yqclhmIudUXj06SxryYOLeRrnSVxSl46jFdHRICtGtamkgwSIUIZ23cz4rxCiUSwZ+oC5ZAvxl0DaNryFaBZiyuWtA7jkpRIQrMikjW1PgpUOehg25Yf+2bN+tMBj3SEnmQFjB1PDpJwTeO9ja8OxyaJEMB91ARMt60U3NHxxaIzQIZYdLxzHh4xGt3p0Qe8rBKq6+cLp6sSZddPSabtlGQaz9NbQtB2D7D0iOkzESCo8dlUu0sa1nXlNccmsTwT73T5pRjV4UjXJztu1bkX1ZgMWpdtJ1WuEZCldtn4BrK4IbQiDnyL7QxyfEHPj2yojWM/hiczmyjyoTzFzbQaPZe9MWpoqcKD7ukT7+sRrz+mWectrzoZHucU+O0
 yhcP/WJl
 kM1bP7ROVLjgkZ8X1ulqGWpVPN09mtS2fYMPFpNtIC56WIWPui5IPEUOknwiqQDG2Q9+XZzp2Pl8gK8qhywPQ9SfNiw==
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
index 0a4b519e3351..df52a7ae336a 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -481,7 +481,7 @@ int dma_fence_signal(struct dma_fence *fence)
 EXPORT_SYMBOL(dma_fence_signal);
 
 /**
- * dma_fence_wait_timeout - sleep until the fence gets signaled
+ * __dma_fence_wait_timeout - sleep until the fence gets signaled
  * or until timeout elapses
  * @fence: the fence to wait on
  * @intr: if true, do an interruptible wait
@@ -499,7 +499,7 @@ EXPORT_SYMBOL(dma_fence_signal);
  * See also dma_fence_wait() and dma_fence_wait_any_timeout().
  */
 signed long
-dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
+__dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 {
 	signed long ret;
 
@@ -528,7 +528,7 @@ dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(dma_fence_wait_timeout);
+EXPORT_SYMBOL(__dma_fence_wait_timeout);
 
 /**
  * dma_fence_release - default release function for fences
@@ -764,7 +764,7 @@ dma_fence_default_wait_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 }
 
 /**
- * dma_fence_default_wait - default sleep until the fence gets signaled
+ * __dma_fence_default_wait - default sleep until the fence gets signaled
  * or until timeout elapses
  * @fence: the fence to wait on
  * @intr: if true, do an interruptible wait
@@ -776,7 +776,7 @@ dma_fence_default_wait_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
  * functions taking a jiffies timeout.
  */
 signed long
-dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
+__dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 {
 	struct default_wait_cb cb;
 	unsigned long flags;
@@ -825,7 +825,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 	spin_unlock_irqrestore(fence->lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(dma_fence_default_wait);
+EXPORT_SYMBOL(__dma_fence_default_wait);
 
 static bool
 dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
@@ -845,7 +845,7 @@ dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
 }
 
 /**
- * dma_fence_wait_any_timeout - sleep until any fence gets signaled
+ * __dma_fence_wait_any_timeout - sleep until any fence gets signaled
  * or until timeout elapses
  * @fences: array of fences to wait on
  * @count: number of fences to wait on
@@ -865,7 +865,7 @@ dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
  * See also dma_fence_wait() and dma_fence_wait_timeout().
  */
 signed long
-dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
+__dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 			   bool intr, signed long timeout, uint32_t *idx)
 {
 	struct default_wait_cb *cb;
@@ -933,7 +933,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 
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


