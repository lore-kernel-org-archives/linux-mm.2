Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD17FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9968D6B008A; Mon, 27 Apr 2026 12:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947F16B008C; Mon, 27 Apr 2026 12:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85ECC6B0092; Mon, 27 Apr 2026 12:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 730786B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:51:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 150331C0170
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:51:09 +0000 (UTC)
X-FDA: 84704925858.02.690184D
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE837C0018
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:51:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=YQDj2eBR;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777308667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Di0Etxui169qRnRooajrzDSyqwkhyD0hpidzw6bAyGg=;
	b=ntfGsgwOp3Wjrx2yXFLyBfE6/LNEZQY7k5mRGjAgYSu7JCLzsOntMwr7ZE2PkMK0qKKm+9
	R2ADiKfnCaPUTHnMTQVyO0expy39aNz5u1087lDrI+cp2HoYSuJ9Tai9uWaTPwbTX+JL9/
	Yz6T8jT38rxlAIVIieK/fXDSEApLQHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777308667; a=rsa-sha256;
	cv=none;
	b=dH5qLZ05FN1gCbYmqiiiKQxZcVlmywYq1gkY6cBe0gMvHq4YdHxzZq2aPDASwztorR2eJA
	aD1qug+KlsOOixJrFsSrPvnPFn812Lzgh/TN2hY2Qx+39q2n9F1ztIQ7wq2LdSNqMYFfkT
	1XOW0bQ6diZYIwyyCnv0PqSFHNeF3o4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=YQDj2eBR;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id BB604C7966;
	Mon, 27 Apr 2026 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777308664;
	bh=Di0Etxui169qRnRooajrzDSyqwkhyD0hpidzw6bAyGg=;
	h=From:To:Cc:Subject:Date;
	b=YQDj2eBRaRm0JA0vVq/QDzXenU4Ez3lfNmfBZP3ZZzP4dVeFCs72VXsF5K4QcHyfp
	 SGt4HyTjePTr7xiuTCRv1kDQk0R0TuTDN5ILCAO09QpSGD96tYE2E6VJ4skhYtpWZY
	 fJTYmuC/JwA4/9HYWA0W3ggZaZbX5jcDj0JegPRI=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Dan Williams <djbw@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Marco Elver <elver@google.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH] cleanup: Remove NULL check from unconditional guards
Date: Mon, 27 Apr 2026 16:50:37 +0000
Message-ID: <20260427165037.205337-1-d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE837C0018
X-Stat-Signature: hbwrfdmfhn1wc7bxhpxb4uc6df6w191b
X-Rspam-User: 
X-HE-Tag: 1777308666-357125
X-HE-Meta: U2FsdGVkX18dj56Ge5BBERnWD4KHAY+QOrbkUw7J8fX7VC+3N9NQS8A9WUpCQ+/wqJlg8OTYwtDv1VE9yXju9vOxO/gifKFPYruiyc17cFKNUm+DS/sXMVlsGkuykfD5T//mSIfVAPq/zeO863FOgq9/w82PR1NK1EJzJTyHZLp5OXtd7Cec111vKLnXf2DQ/VXl03dLDnToAqMZSKhPgMElQEHW1nRk72lAiNFz8kYi+iv2eJ0Du2PxCFrWh9CvL2ht3mL8lPUSIxi2Jyxuj9076Eu175DNA0c8i++KmApedsP/Qqt2XNEI7uB2F40AeJPIH+jFSzRDfCs794NfP2g4m5va8WItDpDFbMobsYEzJoNcvYoY1DbOGYA75eESEH8ZGOhZMPim5uxqWO+HiGYXqzvSqvqjpxTdUkPEzlLK+kKRyPAu3hjXiZqQstAuT3ItjtT03plQbprfhtlMky3cvdglyzeAhWv/CtadCI5Zx+JvK9ZtFRWpxKIk66VB8XDX6QAgTfrjR2jieJGVwFh0zqcr3ptOLdmkZQZZav+Ur4MI8pWebOdSu3ZUWHKaZgdDYCeYLIa9400H9qEPvwKuaiShdnUV8j1WbcFkSFFYjaYYX3v1kynJJYDHaqZExz8IjyoQ7uWPjhTjUAdy9teymE9b21RltBgSCCOG+xQ2Jh8etwaztrXJLVqOsIgGW2PwiD725kUrhk84JmV0eSspx+YH4AqAyrMKO/DIRUTs//nRAiKJRlbxAxI+MTogh4AZZZKPoHX3ynJrGb0QqrgfvuZB36QjTZ7dFWPVoDB7VUEyxsiPhrj6p42XKQh6g8DmAC/rbpqGPzper0DN8fL9F0PK+gbk5RWg69pAwMpxfssEa6HCtM0Na874RUFcmBuSg4et+zL67qZG2p+jiSCgdOhE3l9rB4+NP7y5enNkRpbTsOLs2Bqg9xMFOxK1BHlvKN0o60QEb2i8qes
 cpkvqUp0
 6sS7lO9bNP3+0v9luKuDYeFRBE8fmf7FPYlrB/Nm8lBPscLsI3mlvCjRQ/4mD1pD3s24GcTWX51240v+EwjscHO/hnMYJSPUT5JAS/IJDgyAq1EyYEG25208ZBbHtJz/SqL5LH4H2n5IMM/hgLCXXkENVsPXir8wlODAo7C37soiXE43h+pgP18HZSbqryUfPWg4KHY0D4jDbS/+TH/giMNp2U7heiTnBRpnxGYaTEj6Z64MO1v0WJeF7vq02IfehFAJYa/GwIcYjzqcF06SGaT9YbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unconditional guard destructors check whether the lock pointer is
NULL before unlocking. This check is unnecessary because unconditional
guards always acquire the lock: the pointer can never be NULL.

Conditional (_try) variants have their own destructors via
EXTEND_CLASS_COND() that handle the failure case before reaching the
base destructor.

As compiled by GCC-16 with defconfig on top of the locking/core:

Total: Before=23770501, After=23716538, chg -0.23%

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
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
2.52.0


