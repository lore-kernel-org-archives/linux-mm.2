Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822BECD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53BA66B00A7; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED126B00A8; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB586B00AC; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3106F6B00A7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F22AE162A77
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:33 +0000 (UTC)
X-FDA: 84834107106.23.085A3B3
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6609610000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=gGKNYGjE;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780384412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKADVtROf0vQ43aH1Xe6H1MxCOHUxw7qwH7HL4aVwN8=;
	b=La7QseypGrWGUxPxUyffSKR7c97s+pWqtZQOC6ApwKBl31/vpX4iIJpx32dSp6KdMxfheL
	CW8/cl9GmUfqIXcmK4Pb0NZVXcmmSF6j1YWUhb6dj2wi/swYkkmI/QyANA7flzzIwXa18m
	PocOnoVq0p2CsdX6Vyh+M6uPpbjvQgQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=gGKNYGjE;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780384412;
	b=He4SL6/58cgRiIfkfQw4/fytrXivz8mjtf7mOsBM46UMJ7At6195WXWwWRCcmDUGBhSh8U
	iyj2MNlHPC9/L5TH/N6NoEY8ux/5m5EHZlucMBQEjbvmgcfPIO4fg4FElFL4zf4Nl7S7mC
	19kpxV3rTdTuVBDqQarPyugh5VfazeI=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D42B8D0F68;
	Tue, 02 Jun 2026 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384411;
	bh=jKADVtROf0vQ43aH1Xe6H1MxCOHUxw7qwH7HL4aVwN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGKNYGjEIbcIJJ8/BH414muQKgbnvibQo1farJStD+pOyV3SS+WJ5obh8FA9JZ2Uo
	 tTE0N0GsrgOx1gBSMKm2GP6j9ZgCzHDc2JXw8on2mXJ9Wj2cHhX49cGaqJleS2KbHE
	 dCToWVoqbZtw1amijeqFNXMIWnAuMm9B1Q+k41oE=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
Date: Tue,  2 Jun 2026 07:12:52 +0000
Message-ID: <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6609610000A
X-Stat-Signature: nh1onqcxx1qmuy5xbmd9djsxzhrdod96
X-HE-Tag: 1780384412-549182
X-HE-Meta: U2FsdGVkX19wfyVC1dYev2B2I/7y0Tn07ojhvYcYiVH1hPbBzEhJXAjKn//K09QRNU5RqorX6FLDOW+WS61AhikACOkvNt6ZNsO9qEa+UYlszoNzNsq7l7MKozB3hFpOV6QGkB1gW8vDXSafKBxhvz2HYisYUlXGHGmJbTYxwLtj7hWH8yonemAPVw/WwgaWZa37hvYH8NXlP51MVdK+wN0r5gpcZiIf+9jh6wlbCx/G7DhEp7kReC5kNIjq7C7LC1KCMBgAgWz1FhoNub69jUQUfKOHHj42DCXzyH7tFMtCdryu/B5ZT7K5lWQV3OGkPvuZeWzTF6G+pFexOLeSAQCq8ql7hAGhRPprVIP41GAHxeKgZVInV4/SQU5eP8OmSxt9YP5FE4NF96981+LP4oXY3OB/nPiQ4nHXq0VWgu8fk9Oj7yJxSUdhqlXlM5/iek4zy3d/glUY+n4g74zZL2b2smq6NSpwLmxRkw+X/w83sYRTrLx6C58aeF9nr8qahLv3K1AxmO8QZaRGIMxsPHuNniy/TC2dQsf2C+9M7y2VjctZoLCCYxnXYXxqEMdQ4iQ9bOEP51ah0xqx4t+M708yQDzdz9oc6/hTUFN3y5ezR2lqivADAdnvUzd9CTZlOXHOv8M2HLwvRmShZKwvf5B86TvfH7RnEyKUK0aYscTYYWy/kaCs4c2iSjMMs/Gkb0YhIEBMN5q7fRXgN2XOTk0vmV3o5oLqQNRMRvMPfi5LCY97sSFrZV9fr3afBn6t4vfLFi8sV1JRKEEF1BQZ+RuxPYo48tBY/62G0PH98lSFqNkc7jhDygRkdhi/sbbokLjlAM9rlZOTWrpe5m0Sl7ld9JEa83zQUgjtf2YSmYrd4pKaGtYfompBFCpOMpeeKOIT/RJIvMtm9XcLRxPX2Gu17MGaL2AkN/xxrA4Ybe1BDaCh4GvrrTve2UDI4IXfmcVRMn88XaEcopl3nKt
 RzFf8imn
 cbFnn5A3lZ4GiN4Gw3+5WHoBNUr7jrUx83aqYTN4nVUv8ygw7oyS4b+re9hKLhStOiqddGlNh/KRu4Mw43rtGzqXtcVyljC9KPhFnNchfqgMFCdj/TefSdttx7NaXRgxv8Qo6drCNwdlOkkHc3xtvTXgFcvBp8A39lh73o7LUf47ZkwNf1nrwvwWvvbp5YUYAIQ+qebh5yd7ePnEnt9nOWm3DXmgz1e+0WOWEtQdvAFh7fVYswsbE0EfYB3YCJpofDndAu/frQkcykEO4romPBpS8YhmmMZwcL9HrDNdjRTt0f2Vm2w91nWQPkZJh8rmQokib9Il7k80SU1NbyAxi+qUSHCE3CSOldJgojgIK6MgJeUsgpcv6wqlQsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add __nonnull_args() to unconditional guard constructors so the compiler
warns when NULL is statically known to be passed:

- DEFINE_GUARD(): re-declare the constructor with __nonnull_args().
- __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.

DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
pointer arguments (.lock is hardcoded to (void *)1).

Define the __nonnull_args() macro in compiler_attributes.h, following
the existing convention for attribute wrappers. Deliberately not named
'__nonnull', to avoid clashing with glibc's __nonnull() when kernel and
userspace headers are combined (User Mode Linux for example).

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
Miguel, I dropped your Acked-by due to the rename. Went with
__nonnull_args() (over __knonnull()). Happy to restore your tag if that
spelling works for you.

 include/linux/cleanup.h             | 4 +++-
 include/linux/compiler_attributes.h | 9 +++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index ea95ca4bc11c..4e60d519713c 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -397,6 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 	__DEFINE_GUARD_LOCK_PTR(_name, _T)
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
+	static __always_inline __nonnull_args() _type class_##_name##_constructor(_type _T); \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
@@ -497,7 +498,8 @@ static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, ...)			\
-static __always_inline class_##_name##_t class_##_name##_constructor(_type *l) \
+static __always_inline __nonnull_args()					\
+class_##_name##_t class_##_name##_constructor(_type *l)			\
 	__no_context_analysis						\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index c16d4199bf92..cffe09387ea6 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -230,6 +230,15 @@
  */
 #define   noinline                      __attribute__((__noinline__))
 
+/*
+ * Note: deliberately not named '__nonnull', to avoid clashing with glibc's
+ * __nonnull() when kernel and userspace headers are combined.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
+ */
+#define __nonnull_args(x...)		__attribute__((__nonnull__(x)))
+
 /*
  * Optional: only supported since gcc >= 8
  * Optional: not supported by clang
-- 
2.53.0-Meta


