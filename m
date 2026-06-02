Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0915ECD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1A446B00A8; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB516B00AE; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A78E6B00AC; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82B0D6B00A8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:13:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F3521C0E27
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:34 +0000 (UTC)
X-FDA: 84834107148.02.79D2AB1
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf19.hostedemail.com (Postfix) with ESMTP id 959A31A0004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=O5PmzJPQ;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780384412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLXXDlJ/Kxp3Cp2KJoa7FnY+i+nRO7rY9YwMwddxJq8=;
	b=to385fd6QMO8qd3dJabAHWZuvzpw85bNagdetjdP4r4kZQg88vYT43jq6fzphuBgGoN/hE
	KAe4PRrkRZHQq6SVgamuTlvLvcBIhZ4VxiJNFfPSyPA5+jsYz+IWv61MxYmIW/vlB0vbzY
	RhBVjUTJ+aQe7L40RzDYUtnhO+5C8F0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=O5PmzJPQ;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780384412;
	b=FcES4wxU9JiGa3W/nWhU7p1OHmHTZjOlMqOxD45VQ9N/MzHsqUp0/LwLuBjI7HCP1QWP2P
	CuPIsCSyu3YBc/LIBzBV/8NNMQXeEb/BaS5A9HnGv6J5L8oBpIO6v+zjiP2TETen5ijYpU
	snZSR6zWYcDm70QbwfZemvi9LmOAXvw=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 29631D0F6C;
	Tue, 02 Jun 2026 07:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384411;
	bh=wLXXDlJ/Kxp3Cp2KJoa7FnY+i+nRO7rY9YwMwddxJq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5PmzJPQQm9wQcEZ2Jqis/QLMEQOkkjveUjH0SpE2xGnFIA/WeL8h25Z6fWKhp+Uo
	 SR2OjmkoIyffFaGReFL1Wzn2jWkgJFvTSJDAcAqfaJ3dOiTOWfKaGcGO+lbK1zDFJR
	 EqvxDWzR2ygXNycgzNDV3NlplOHbGlc+D0dg6iTs=
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
Subject: [PATCH v5 4/4] cleanup: Remove NULL check from unconditional guards
Date: Tue,  2 Jun 2026 07:12:53 +0000
Message-ID: <0503a089389b2270c478a873e095cf0a4ff26d24.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: aya9638bw6endh3wzgfzwrkfubjzd99m
X-Rspamd-Queue-Id: 959A31A0004
X-HE-Tag: 1780384412-911510
X-HE-Meta: U2FsdGVkX1/zJu/T/HgJIfDERn+3VbJBA9+8X1sJBGgi3OdMeJS+jfJFDal+MS1TzozwCZ3F+k++yFbXjfXMAF+122m+ojyLSKdEyKW80K65D0cKTM7JiMX6PKrixCOjonynR6mKD9c3uIqPXCgQIfNBA+zn5dfddkRUSLWG95xEUN9yV6ZwqHBUIJSFdAZ8VJR0N4463E3H4QFHwr0gSHsFQOTlxrvb+LxJgN7IpvHkUzWRO48FXgG9V9XITzUcYJ0cQfXNLxeHu3qxbkeaRv3Zi95/42BeC7APYG0KHqYj66uvon9YVxKXWMO7hiD1plpJfVJro3X3gWenfVolfr8FHzftoWl7VOK7ryjdUIpHeHZGQ+nImDR9jGy3QZ+4ZIGP86MBPTFqBpIYHU7JeqH/hCNKSdnRnltgzOiVzyGb1eiF59swy3pKF27AxGJ9eGv8e1psQ8pCGflB8CwPxXdeVhPp8Um3rlhaChPXNik0gjoqUq8XLHavIjZmka1/N1LMQ6wLCb3fUK4XJpjoqakcjyc0dh4nqGKPaJN4WNMQPNfaWtoFPe93oJxYgnvDA42vCUS1BKg6HVPZqPu1B7x9ICOGtx61zRhe+WR40AE/c5t91+KXAd1yLngcWRhPKeELhO+9ZK2qoCbUE+6EYIM6UfKd7ns6bRIDoX8zTKgfwCRM7yCJqePsKApKphzNCPhO8sSZnKufFYUnclp1jQom8EhndZNREZEyHP4VLom0MG8Huy2osH9D9RIWn9OCrLYuNvt0FcxQz+9rmsZ/6KvweQACHQAl1pIdmiV5h+y17ZYSvVN0zlG6HLyM97XppKkEM8mqukCCBO0ZAzjP+09BRFGisB1D7YSlB4Rw6jTT//PwGiQLAov/FOBxUHv8h2q9wagf6RiQXbdYhj07M4gCE+UJAMsMxSSs8hNiCR1h3uoO0NzOQdJKr+z47mWI+nsqhs0Fl+KBJxinQah
 VXL7rz0K
 SCpWZuqGtM66qA3qAayhS7SAnCGavX19vfb+nZ3DTnddnVmq6KNXjvhCH9Ppcm5orelKnOUNcD+CVlwM0y1bJ5tTd1eQt6b7R0igGGcawErr6oVazkjZVCYzyqI6fXf5ERFfD3ThC0O2NLJUokmjESOmC92BlerjsYRZcjgdijUzMfrMr9Sf1Kpprqn/WVJQmc261wR7aK+BRQ8y+CobSEZy5xb6pyTHBZAM4L/gFfadLRTBPHAzIDLNBYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unconditional guard destructors check whether the lock pointer is
NULL before unlocking. This check is dead code because unconditional
guards guarantee a non-NULL lock pointer at destructor time.

DEFINE_GUARD() runs the lock operation unconditionally in the
constructor. If the pointer were NULL, the lock operation (e.g.
mutex_lock(NULL)) would crash before the constructor returns. The
destructor never runs with a NULL pointer. All DEFINE_GUARD() users
dereference the pointer in their lock. Verified by auditing every
instance found by: git grep -n -A 1 'DEFINE_GUARD('. The only exception
is xe_pm_runtime_release_only, whose constructor is a noop, but it has
no callers.

__DEFINE_UNLOCK_GUARD() has only a few usages outside of
include/linux/cleanup.h: tty_port_tty (NULL-checks in its tty_kref_put()
call), irqdesc_lock (fixed earlier) and two guards in
kernel/sched/sched.h (dereference the pointer unconditionally in their
lock constructors).

DEFINE_LOCK_GUARD_1() sets .lock from its argument and runs the lock
operation in the constructor. Same reasoning applies. All
DEFINE_LOCK_GUARD_1() users dereference the pointer in their lock. Also,
verified by auditing every match of: git grep -n 'DEFINE_LOCK_GUARD_1('.

DEFINE_LOCK_GUARD_0() hardcodes .lock = (void *)1 in the constructor,
so it is never NULL by construction.

Conditional (_try) variants: DEFINE_GUARD_COND() and
DEFINE_LOCK_GUARD_1_COND() use EXTEND_CLASS_COND(), whose wrapper
destructor returns early when the lock was not acquired, before reaching
the base destructor since commit 2deccd5c862a ("cleanup: Optimize
guards"):

    if (_cond) return; class_##_name##_destructor(_T);

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/cleanup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 4e60d519713c..65416938e318 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -398,7 +398,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
 	static __always_inline __nonnull_args() _type class_##_name##_constructor(_type _T); \
-	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
+	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
 #define DEFINE_GUARD_COND_4(_name, _ext, _lock, _cond) \
@@ -492,7 +492,7 @@ typedef struct {							\
 static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 	__no_context_analysis						\
 {									\
-	if (_T->lock) { _unlock; }					\
+	_unlock;							\
 }									\
 									\
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
-- 
2.53.0-Meta


