Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6E0DCD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4E26B00BA; Tue,  5 May 2026 13:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048DA6B00BE; Tue,  5 May 2026 13:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0F66B00C0; Tue,  5 May 2026 13:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C977F6B00BA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:09:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 861CBA0565
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:59 +0000 (UTC)
X-FDA: 84734003718.14.64EA124
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id A591F100005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=lt719uei;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778000997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNQRtWDHTSdHuulO3xaZF7TbUmQJOtiaHzb+LTQXOgk=;
	b=ynOe7GyV+avwMOlLx6L6hkE/G1TTnXeLg2dWn6E6kvWeTXwSG8xCbeMkqMpiVBcuDKA9/G
	gmPt2o8RDnj7p8pva0JaDSWk3vmabWjt/YNoWSd3u7hg/LzCHkAwG4+2zkBSiijy6cjQDO
	YBGD5W5slXNvOVT1owSEw1QqbFVbbeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778000997; a=rsa-sha256;
	cv=none;
	b=bmbHCltFAosuCv/Y/Li7W3xgvLJ5T8Fyv2XLkDX5VcIpLh0TryyJX/tPBo0San8i++Bc/x
	X46TLDkCwCTstR1g/x9ahpN8iXYU/RPm2dMCKxhzXi2Z7FieVyo+1Cq16Kp//LDFV26vW7
	8+OwRk6DGMBGybgN8gpffOlTAib8dXI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=lt719uei;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 388DFD0005;
	Tue, 05 May 2026 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778000995;
	bh=HNQRtWDHTSdHuulO3xaZF7TbUmQJOtiaHzb+LTQXOgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lt719ueizrhf62Y1Z7/DZbnmjEx0GJ0GjDpQhigoaaIbE/RpBOAJkHGdfOMuYyBjk
	 4l56I3tj+XiqaPZPebIxNQMWRr+l90s8NGj8CwP7j64JI9O3RyLiI7Cd4dIRMRt2Pg
	 WnkSFzXSeAx6cbAJJHStQMGcmpN8eYCWX+ayIshY=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v6 6/7] locking: Factor out __queued_read_unlock()/__queued_write_unlock()
Date: Tue,  5 May 2026 17:09:35 +0000
Message-ID: <8e88613c73f0603c4440ba3a62eb604a5dddc57b.1777999826.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A591F100005
X-Stat-Signature: zdjb7s3rj8p4mthoyg5zdxqdhw7gokso
X-Rspam-User: 
X-HE-Tag: 1778000997-596597
X-HE-Meta: U2FsdGVkX1/8e3WEl4ykHy03IGTJhQxY6u8pVbMpPSk7IR5vG9lTexlb8uYHi+5B6W7Gq+LWnxnQyOZbaQ4LVNAad9ZWvYmCv12UzjVnh1NgRLl06FvMtmjh+lJgUhSiO9Xsw+KmK6zFuA9MbXfNiuJaW07Zt4+WXD2+wORKDNlzGvt224xYmXIgWnN0c/FkDFD+YsWT9R8ht56w0PNPr1yCXWH4YvHrvN0CuMiGgnyOqcgf7ohGtXEvgf1lTFCTxrHZG9+/tvjrou/QrUUPxqlxjYC4RUGWwz3yoTW+5Y6sY04mzjijQx9JPloJZVj2yrCrs/QHWcGGf5J4GzbsM/jLRuO47k0zyxp7RoMpBhEknt9q4YuRtcB6BwToI6Udzev0j/nho+n/BHS0fQJlL7WAE+yoxmBS+YaAJp+82AwznYrSOG4zR/eSMIQlg4ka9bN7Fl+RnUp6JPUMx8K/QRxMh79bLMxvU4PsriSOb7JpbABBHvZQvf9E0RPo3ANqHH947bPyNeRVAenE249DE4hDm7uNuPfbEZxLBFcNaSRYkgwhAOHksU+G+EhcbKo5kRbp2DHKeLWogKk5mMJVwZFlaN7ga5g2yr6dt+IDfMd6IJLlZg6mokIHVsS9P17xEJP3bSJ3DR5wXhDW6w/SbtZWtdfA3d03yQyeK1bPTAGGHxzgIv7xKyXyaNWDi0PBb930DC16RavYR0S2edrPrzy0ZLDRLZ97urHO2XZklPVzFNDCl/mDVEw/BA7bvo0RzhBZLbdGlNnEN/FA7JGGNHKckLNFkRCpj1vpfuzzThynxhwHpo/UJLqaDSEWAzIeXTJ8fMAqmYmRVTdeQn7BBRB0IfV9QGb+Pds6DGa3y7qSm0FRjQp2LV3YtR4+ATJrhzpjAQGmux7Ew30NRUwqm4YYvHB+C2iYH+4ci5DQ2rhpDTC83QS5a1EqWS460SkVnoZ5qqNVQ7viaO/T9Md
 hTFKLQff
 yS05AnwiWL23cbZBkcurQvvfST3K+SbQvVuXsvpcsYV4fpCk0B3l94BaPMUDfw4KuMbKu8G1wSQtGeBvLsifFtEniHwHm+jZfeBGzqMCGjOw6XF6Iiu/UsAk7woSgrthFBYZEM1QonBL/6SkzyQOjOlnkyqfyQ1fUhu/SuZzMJVcb8tm/mA8aQT0RD3e5qvkTlCNqJ1cFzI4Oa5k0py4yRLsTgCvtUzdVxY898m0WwRRSj0aii0lcS7LnQ45O9yHOW6GG3GCil6y0qS1nxOrDRsr+Po8lSDnSP8eOxuXZT/Y0KO/IqAFLduT6ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a preparatory refactoring for the next commit, which adds
contended_release tracepoint instrumentation and needs to call the
unlock from both traced and non-traced paths.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
---
 include/asm-generic/qrwlock.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 75b8f4601b28..4b627bafba8b 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -101,16 +101,26 @@ static inline void queued_write_lock(struct qrwlock *lock)
 	queued_write_lock_slowpath(lock);
 }
 
+static __always_inline void __queued_read_unlock(struct qrwlock *lock)
+{
+	/*
+	 * Atomically decrement the reader count
+	 */
+	(void)atomic_sub_return_release(_QR_BIAS, &lock->cnts);
+}
+
 /**
  * queued_read_unlock - release read lock of a queued rwlock
  * @lock : Pointer to queued rwlock structure
  */
 static inline void queued_read_unlock(struct qrwlock *lock)
 {
-	/*
-	 * Atomically decrement the reader count
-	 */
-	(void)atomic_sub_return_release(_QR_BIAS, &lock->cnts);
+	__queued_read_unlock(lock);
+}
+
+static __always_inline void __queued_write_unlock(struct qrwlock *lock)
+{
+	smp_store_release(&lock->wlocked, 0);
 }
 
 /**
@@ -119,7 +129,7 @@ static inline void queued_read_unlock(struct qrwlock *lock)
  */
 static inline void queued_write_unlock(struct qrwlock *lock)
 {
-	smp_store_release(&lock->wlocked, 0);
+	__queued_write_unlock(lock);
 }
 
 /**
-- 
2.52.0


