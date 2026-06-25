Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB158CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 17:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CA86B00BF; Thu, 25 Jun 2026 13:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1248C6B00C0; Thu, 25 Jun 2026 13:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061FC6B00C1; Thu, 25 Jun 2026 13:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5F976B00BF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:45:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F5161C144D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:45:38 +0000 (UTC)
X-FDA: 84919162356.06.4DD97D9
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B621C000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:45:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pLYYOBoI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782409536;
	b=OAz1dYKfNz00fBZ9z1jZT32yf487Xf4la2mX0pKrB3Mrm8+Tkrq40/m3AWq9iyRMC2qOKy
	kHH39T/0eCMOKeuAgiYbsq0vqDOId5b8x8XukMADOIgI0bR2XF6wBCmAt74Gp1We/0NmNN
	oxpY0QZ5n4OX27bCCxqEwnUWTX4KCZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782409536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MPa4NfxGFlsR/0ze8KtpPD8L+IgNM7huYMx2u1xMPgU=;
	b=fpXmwn7BOg6jZsl/IMThKDt8A4E92n56UYILQmIQKPbXg4K/Vrbtk8CpGx4iYONG+0RLY+
	ZOZscyiBVNGwKgDpZyui+PxYIDCV+Wj80As9cNSyKwXqJ4+9CFmYly0aERJ9Sa8zc/eX6v
	l3PtOUCf+bU4eCPY/ePWMSQsIBwLTxo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pLYYOBoI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782409534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MPa4NfxGFlsR/0ze8KtpPD8L+IgNM7huYMx2u1xMPgU=;
	b=pLYYOBoIfpAzpj66uxyzMUCl4zexcFVuEE8EPPEsRUbC48gpPtU5iZmzrkbZu0uKIGFWc5
	qiskz2Avy0pJ+Jek7fLQxhZlUyV0AciVXkbjCAj+ahVWn8Wlj9WQrDHgm5ctbPxFCYyGJE
	UG35hAFKXIXFQfLepY6g34sFFtBgtRQ=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] docs: pagemap: fix flags location, member name and sample code
Date: Fri, 26 Jun 2026 01:44:47 +0800
Message-ID: <20260625174447.24292-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B621C000C
X-Rspam-User: 
X-Stat-Signature: msh7u3upykcqyq3uuza587ejfdc3mwa3
X-HE-Tag: 1782409536-950893
X-HE-Meta: U2FsdGVkX1+GPGs7a9kaI7WFMr0FCeY0soIb9T+LLnNxBT6gPrT54AkIf9hCU/HmqWjcjQr9LT9tvsEt8hycqfVXTeje24FlIaCOiXbuxkY60syHXmwR8ZJ4/5LaVwbrqVpkvizilzyHJ5RZt4d4yaWUij/rgC6Li/mrLWBugF3apuHpMl88ojJtDU/Dj0+erraFJqFg6ImDYLMujzTNQ4e8R00Xyiq0RHxih3poiK5FUuYCSkgYQOzCPyPwIAKNZExj2cQatVjtrBrsVSW640SCrhzwalt49tlBfWSFkUWiiCagYZTq6bb3lPkN4x7+B2X0gIrpZKSQXBN2O7htB7eTyP0th35vZGZpHOwhUYQpeYUDbQGu+/E4MEZa5c1RwhjyBBw5Pv0oggbYLv1Lk+AXNxxEZ48M562pU80DUh1wzu7tvYpmTzm7sjj0OR9w1HCFQm/o8ZIktBjsddE+PzEWNEXccnOFcGDG0mgSHHf32s7quCjrCzHX6wUAWeHzXkQ33n/Bq6Gd6nAWkzOQoC7m1Qe9n4XT+BCDznEw8uE+fpVqnaI36UiTNWg3sAIPZhXRE0KX7c2TrtNQkQkqCdjo7cp903BCTni77XtikpT3OQ5ZF6fDU0VOolNF/qD6BbUiWE5q+XgNgCQ2oJOXDekiwhKN203szrErILQEQC4wuc6skcNduhgJsaVrh9fEWD4Xpa1wiyuipvDhVrofN8QdinUWiEsLw3czY9M7GWV4lIa5P19wMnu5WDjCt1JG7dAS5oT4ljvRjNBOVFo10zj/Q9H1FuYipLUvIDqivK+zQsfwCTn6J+IQqYuApIgcUwyJTKw8iPK081S8jxcURQKdlsmu4hg9ich+EVLeAwmP0mEZ0AzUfdaUF4x+t2q7rNeR9B4NhTxAcJpcL9tVy2ARJne13e7/HfhzAT6VIthYcvFpsos28ub1VAmbVCMbBbpuwako7egaZdZPdQr
 t5v8N0ay
 rCe9AY+xKyJ3aOSEsOzGm2l3uxiHAIIRPffRLJ3bed9JTzb2GAHHyU2Q6++c3VQ6WyU/ieb9vhvWrgYPqY1XIxFmJGUMf/Nt5ql9s7/tV1R2+Q0rZGiD/Ed/uz+XaC1Vq6h9Hn7q9rPQPs/+K0myCnn3KGOJREN9xGwsVJJafFiJUSwEPZ9Sj7wjaoK5q2Y02WyPFjWLer+Hup1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The userland visible page flags (KPF_*) were initially moved to
include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
stable page flags"), and later moved to
include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
(Scripted) Disintegrate include/linux"). Upadte the doc to reflect the
current location of these flags.

The member @walk_end of struct pm_scan_arg {} was wrongly written as
"end_walk".

The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
The second one missed PAGE_IS_FILE in the required mask.

Fix them all together.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---
 Documentation/admin-guide/mm/pagemap.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index c57e61b5d8aa..12ac97d9d277 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -67,7 +67,7 @@ number of times a page is mapped.
  * ``/proc/kpageflags``.  This file contains a 64-bit set of flags for each
    page, indexed by PFN.
 
-   The flags are (from ``fs/proc/page.c``, above kpageflags_read):
+   The flags are (from ``include/uapi/linux/kernel-page-flags.h``):
 
     0. LOCKED
     1. ERROR
@@ -264,7 +264,7 @@ The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
     provided or not.
  3. The range is specified through ``start`` and ``end``.
  4. The walk can abort before visiting the complete range such as the user buffer
-    can get full etc. The walk ending address is specified in``end_walk``.
+    can get full etc. The walk ending address is specified in ``walk_end``.
  5. The output buffer of ``struct page_region`` array and size is specified in
     ``vec`` and ``vec_len``.
  6. The optional maximum requested pages are specified in the ``max_pages``.
@@ -275,7 +275,7 @@ Find pages which have been written and WP them as well::
 
    struct pm_scan_arg arg = {
    .size = sizeof(arg),
-   .flags = PM_SCAN_CHECK_WPASYNC | PM_SCAN_CHECK_WPASYNC,
+   .flags = PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
    ..
    .category_mask = PAGE_IS_WRITTEN,
    .return_mask = PAGE_IS_WRITTEN,
@@ -288,7 +288,7 @@ present or huge::
    .size = sizeof(arg),
    .flags = 0,
    ..
-   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED,
+   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_FILE | PAGE_IS_SWAPPED,
    .category_inverted = PAGE_IS_SWAPPED,
    .category_anyof_mask = PAGE_IS_PRESENT | PAGE_IS_HUGE,
    .return_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED |
-- 
2.53.0


