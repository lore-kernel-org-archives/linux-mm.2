Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6E1FCD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FC56B009F; Thu, 21 May 2026 03:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553306B00A4; Thu, 21 May 2026 03:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5726B00A5; Thu, 21 May 2026 03:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 223B36B009F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:18:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E700B1C17B2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:24 +0000 (UTC)
X-FDA: 84790573728.18.54CFF5B
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45ED1100006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0BhumtCI;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PMlovbl5QDd8E52nk+/Gka5Rv5cUQE0QYmiAeICQTo=;
	b=MBhOiSujM4Tk1SRdKrL2s1WTLM1+3vDBli0xoFdV1TY9MI4tg7+QKJRwPOJ5GUH9+KVoFT
	B+dDlcq88foGTC3EDvwvGNhHKd4zDch8TvJIz10fAdi4UyLLw1h0jkJXu/tb+HvcbzjBTJ
	ptvJBJrTFduAfnwlT7iU1y2NWiw3nBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779347903; a=rsa-sha256;
	cv=none;
	b=pgPfpZrX3F9Ohgy0x5uUZQKxKL8iv9k6CILIeruh1Axg1deOBznN2glVHpy/oMIx98wjL2
	K9xQLcMYaV1L2lfrHCr9te4AmiQ7uPLTavCOElPYIOKEhtaTNfWO/VLHAifWrdF10A+0MF
	pMGSWGde8v6YLCGLim5Vzb+aQvgBSxc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0BhumtCI;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 4FE9DD0930;
	Thu, 21 May 2026 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347901;
	bh=3PMlovbl5QDd8E52nk+/Gka5Rv5cUQE0QYmiAeICQTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BhumtCI3qt/nu8cGcm5GhsrGynk+LBJqztZWuBaRC6ZU7E3w2/aFMfW3XWci4t0v
	 +WKKnawSUSNlXv4McrTVCMJDXWM7Q4XyokhEhZhLyFTx5Ja7s8P+2G6vW536CZ9o5T
	 6+Nd9cVrtY2tOdDJls1rqKmQ/uWjk/vjDc2oYFa4=
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
Subject: [PATCH v4 3/4] cleanup: Annotate guard constructors with __nonnull()
Date: Thu, 21 May 2026 07:18:03 +0000
Message-ID: <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779286416.git.d@ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45ED1100006
X-Stat-Signature: 7qn9iq9amrzwd8d3qjszey5f9go4c53c
X-Rspam-User: 
X-HE-Tag: 1779347903-221014
X-HE-Meta: U2FsdGVkX1+1PZdqxIC5zFrc9AsLIzaV+Df6Pk4WWsYSHtJG+tK59J0+mbLaRn7340yPbfp3G/onyWx+QyH5u6wGPOrK6QVboAEJV2oFDlZuxmWY5VgQ2iasetacmT1EYXVX5IryKPz27nEItL0HAw0ZySfqtDiOTw0q+s+oY8eIfTZtkJSCKLQu7Iq+Ltfej6NAlajD0J2s9dc31GhJTZia+5L0U8Wnf7GmHR/AlUe0j/l3x26uGV4HMTHGtXvoLamz4CSTxG9DcrftXUrECBPunAqox7itgUbs3v+AbnmBDePXw9lAH9/YRRiqXiMDrdarNXs1Kb95yLrXDsVNgNFfMS2IvAYWPwPDhO3foqYkPNRmdTNf4L9oAKJDFI5IZIahoIb4OAfPVwzT2Cm+hlp83k5wI5r8ZL3vfaRzOh3OTnH2F18mbwg6HcKNR0PrL+t6ELNo0tsHdUA1SzAisnNJyEzNzWO5K79sBn1CKAWVo+MkCqCzAE8DsWwmkSHrx4PyEU7QGQlmcDeLzieLqMu8uj5ARuUASFUVnj+tfqe/IvBdmXtcD7rsng0BtHaSai3b81H0AKj62cxLQKGUrLiS6bvpNepFEqtjY5LNUQwxNgaXnVa84Un13kHRlUjyvFgKoWOncPsu5Nx30S5r5AuedT8Xta2xXFD117h81bNxWK9PkPHZzFrCGfE48cG87izx1TfNVm+acpRbyTYnh1ZNGkjW8o95OTNn6BE4zSpketM0D4JkDauKwpT+CEKm/1HvLGqrQgKU/NOhZBq/x6HFePSajGDUQFtQ1PYKyv6b5tg/1bJPtE3wUWpgIQErcdmLkWWW0BRRacNPCRYvCtv9L8QEYfZdT57DSNwiI1JzqU9N8pxGTO6uOH2jc7fT7EFGivNSNgfaA6H+eMar8fyPS8aKlEnHZCmki0X8JyPukeS0NKQyN+lwpMXMCiBiApYmPtqybq8ida2Fz7t
 kamAHo57
 IqcoTOKSfLaQMHTa9m/Ew1Fq0REX4B85xXKubLqXAJrwdWZsFyf2hxff4bPOlu3zqi691ZIOluvXPdll6NpOCWywWKDs7DuOEzh0N8uebio54zJt/KDb+kKLHT8/44QBmm6uBz7Y5PHotBuvaHeGvA6i3v1w878M7AFDWpYKIMb8Rm3V4L3Hyg3yoh4PkMWcx/GJ2PrGPZm6PKC2TCN4Pf4OLWsebVpOPnFCpDeqkS5h31ReBwdw2/QhzJ0eBlrNq5T19XksPwXe6KFNf+JihOC4N3OhDugMltwwDZR13vPlNUfDYDY2ZdQWYI3ozPv8Om7NvrgbttQUyRBWlvzkEn+AW2QI3aeZJirweF85GVdXNTLMP8JzfwozwWkH224c4IfBJgX+KXxbMgWsiKFs/LEca2ryiORRxQrWT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add __nonnull() to unconditional guard constructors so the compiler
warns when NULL is statically known to be passed:

- DEFINE_GUARD(): re-declare the constructor with __nonnull().
- __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.

DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
pointer arguments (.lock is hardcoded to (void *)1).

Define the __nonnull() macro in compiler_attributes.h, following the
existing convention for attribute wrappers.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/cleanup.h             | 4 +++-
 include/linux/compiler_attributes.h | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index ea95ca4bc11c..8f8d588b5595 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -397,6 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 	__DEFINE_GUARD_LOCK_PTR(_name, _T)
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
+	static __always_inline __nonnull() _type class_##_name##_constructor(_type _T); \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
@@ -497,7 +498,8 @@ static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, ...)			\
-static __always_inline class_##_name##_t class_##_name##_constructor(_type *l) \
+static __always_inline __nonnull()					\
+class_##_name##_t class_##_name##_constructor(_type *l)			\
 	__no_context_analysis						\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index c16d4199bf92..10a1410eb3e2 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -230,6 +230,12 @@
  */
 #define   noinline                      __attribute__((__noinline__))
 
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
+ */
+#define __nonnull(x...)			__attribute__((__nonnull__(x)))
+
 /*
  * Optional: only supported since gcc >= 8
  * Optional: not supported by clang
-- 
2.53.0-Meta


