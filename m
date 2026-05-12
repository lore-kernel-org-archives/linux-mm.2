Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5634CCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D496B008C; Tue, 12 May 2026 03:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E066B0092; Tue, 12 May 2026 03:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44516B0093; Tue, 12 May 2026 03:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 93E2A6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:15:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5676E8CAE4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:15:34 +0000 (UTC)
X-FDA: 84757907388.08.ED6FAD6
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7A5732000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:15:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=BZY3XNC+;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570132; a=rsa-sha256;
	cv=none;
	b=B+uqIxEYJNP8uoGn2juzztYZjDa6LMG51y0BTW+jQx+pYcjnfZqwF4MPfBUl82k72ttxVH
	U6reb+gWJyJu4nNYN0Qwpd7S8MwuQEMFfuSrz2BGPsrzBjQboI0eZY6Ar7brachLnAbNVT
	bhz+lP4Hdqi/XqoCx2pebWj6Q8KxE3U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=BZY3XNC+;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BFor0KrBkxvS9w0H6iEW/kE3ciN1+oSXsC1h7srZquA=;
	b=s7yT4b6S2a9YjcfFQduVe3GrYWdawpfgKghi6XvGtW8tdwNldTfij20bFya/slVkw4BOac
	gFpWh4LJnmKMKcOPVfovrzIM0Bp+JcN36ynVgfD0UhMQnEZ/8Qgz1jrKlYMSZUgeKHmw6e
	q9y2EbzYsQZo15NTc2MnQRoh80LvDXA=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 9E93DD03F1;
	Tue, 12 May 2026 07:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778570130;
	bh=BFor0KrBkxvS9w0H6iEW/kE3ciN1+oSXsC1h7srZquA=;
	h=From:To:Cc:Subject:Date;
	b=BZY3XNC+rtFbvH+ITtrgxA6DrZeIf4ChmwIoKFc78kqEg7hSrMs25mrS9VOyhTP/N
	 YVgDeEkO0Rib71w4X0DLdGHCTE0POQWEYFHb3/ZiXRfmlAgMt3W8gR2MqTM6wjaa6o
	 D55j8H1OwaL7YGNsr7uxzZ57bS6Wl1ShaMQ5OHc4=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2] cleanup: Remove NULL check from unconditional guards
Date: Tue, 12 May 2026 07:15:10 +0000
Message-ID: <20260512071510.92451-1-d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1a9gqzt9zkcyc9bsfadje5dgzd3xqrqk
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A5732000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778570132-612846
X-HE-Meta: U2FsdGVkX1/yg/Fw/rJlui3820/VKqyqDQFWQVbs87O7ENQBPNIwR7dTb0OoGRIavHOimZpTSVOxin52DZQZ/sl2H1ztzFa9Bbgy2YwlvDrKau+MqgCqVqiRVTrg8RY5J5QMC7baWwoijvMmzTmqBXBQszySEBcbnOYHYw3VL7gnBqe6pBXg6zLdvLt+ogNtRm6Q7fKPUqdwv2qr7bgDRgVmMEXe9MXle7mVoFKj3XsGIX4XByRGHLuSDvwZv/gqrS11QW7xu5y1JaSBNCY++Klqg05tI5Eu9ZjZ4gSogC5nSOT6JFUfIrGnYQZ77FIZ94Sp/61iM0DZao06N46FncgFB25B6x7vJTaBGGf3Fc3CHQ58tSPoZCSK3gCjQ0hTy4stIXQ08H9+pybJBm5jVc6rt8ntdPjw4pg5ZhFuVuTnTvqYNCyuDDM/x3iIK02liEOdpqt9pEjNFyoav/UWpU7zdEMCORLhiJeOUpd1M5z8slJYAL+nhBc0CiiA0yFYLmVJGnth2hq7pYbu6GLYgogLr5LJi7zGYZUTGdLtF/BATh6oWcxHQqzckvSaAmll5+YtU+/AsqbrZ1IfUR/MupybgY/1PttN4+rbeewYMjSLiLCZrdivh5Ed/YiHHj+3hZ4FB5r8BT7w0QT/A7Is24POyH/Wo2hpH8id/qRM854Y6Hs8eDDWUfJovP9GhR+7K7F9Q45lMoqhH3JcK3w5sSgJnAbDOXm1T540b5AywOwJlKzP6mqa3LPfQV/hEQ1lBdJJUOeWqKtLrbrXYI6UQBzSRtx5AwCygh/MAh5DUdR/ohrz/+84J9G1tpy55SYvzOkgxnPHpYuhFXlx5XAdPwGNr/Q7h0POuvubeNUEn8bpcf9hBsrRSva8HCe4aopJMpZwedeYzL6UP2qSQX/P25YYq4R/iyP17N27qWXcMHATc3GVrWZQPtOaSftvDKX2+dmQkHXxhWfQ3IlkyHE
 QT1fWOwC
 W5zSGcffveXZlqlZZS58BQTna2TKz6e4ilXrRmOVxC4yQHiiZo+4sa4USeJpb8vEm+oJidYbW5piCg4hWTSwC3VPY7sgKz+gr0nPaJMwlbpwwQhHeG8plZLCOJEX6lsvRELA7yVSKb4+92JXN2ilW/cX9btmVRRUr7kvQV6A6ovK6jG6wNxAlu7yV4tdU3g+XuB0iYAESg4XZNDDDtlqI3fs+lJE8shw6rC2TkS7impmOAfCB/PhSL4OMOUVY0bmZkdIkBWlaHsofVjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unconditional guard destructors check whether the lock pointer is
NULL before unlocking. This check is dead code because unconditional
guards guarantee a non-NULL lock pointer at destructor time.

DEFINE_GUARD() and DEFINE_LOCK_GUARD_1() both run the lock operation
in the constructor before returning. If the pointer were NULL, the
lock operation (e.g. mutex_lock(NULL)) would crash before the
constructor returns. The destructor never runs with a NULL pointer.

DEFINE_LOCK_GUARD_0() hardcodes .lock = (void *)1 in the constructor,
so it is never NULL by construction.

Conditional (_try) variants: DEFINE_GUARD_COND() and
DEFINE_LOCK_GUARD_1_COND() use EXTEND_CLASS_COND(), whose wrapper
destructor returns early when the lock was not acquired, before reaching
the base destructor since 2deccd5c862a ("cleanup: Optimize guards"):

    if (_cond) return; class_##_name##_destructor(_T);

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23833993, chg -0.23%

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
Changes in v2:

- Expand commit message with detailed reasoning, why the proposed
  change is correct.
- Rebase on top of locking/core.

v1: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/

See also [1] for relevant discussion.

[1]: https://lore.kernel.org/all/afCS4d4YccQFtvpi@shell.ilvokhin.com/

 include/linux/cleanup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index ea95ca4bc11c..1410effa8780 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -397,7 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 	__DEFINE_GUARD_LOCK_PTR(_name, _T)
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
-	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
+	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
 #define DEFINE_GUARD_COND_4(_name, _ext, _lock, _cond) \
@@ -491,7 +491,7 @@ typedef struct {							\
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


