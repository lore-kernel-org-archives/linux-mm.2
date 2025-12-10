Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0530ED3E781
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 22:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7AB6B0008; Wed, 10 Dec 2025 17:46:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF4B6B000A; Wed, 10 Dec 2025 17:46:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE8F6B000C; Wed, 10 Dec 2025 17:46:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC646B0008
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:46:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4C165A791
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:45 +0000 (UTC)
X-FDA: 84205047570.22.1D56B99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 405A3180002
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GgfixRCi;
	spf=pass (imf24.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765406804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXKtenz6DaLMGUShcrB400tfbTGBqWhLKx1FA2IPRio=;
	b=ROP3mfIx5KDS+PjsUByhn5aWR9FHx2jLa9j7RBxpJRI/QCkCjW3ZKiJve1qkMa31Rg70Tq
	FuW3xIhqRWtFAC5VLZSGfSV/No01XZSvGu6p/pPzab/o9ygu/iBUC7bmD7CKd5eTx7qaAa
	9qaDEA5oSmQ5lVkaNUCRhH/l5PFFfps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765406804; a=rsa-sha256;
	cv=none;
	b=KoWElyhcEEvLUYeGjWcjL7j8Fiqt4w/Wm/lXvSITMaMlFlEuQgCQylmG+kLE4+kPcEv2o7
	U5vqGWQEMmp590Tm3Q1OtyT0hQ3iusoReIYJU+3CrrBb6qoEeKaHjejGU2V6FkmiJzp84S
	Pjwc78zhF/ZlIMVnttVVJfcH6iiCeMg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GgfixRCi;
	spf=pass (imf24.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B6B5601A1;
	Wed, 10 Dec 2025 22:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617C3C4CEF7;
	Wed, 10 Dec 2025 22:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765406803;
	bh=Rsfmd7zbC+kSZ3iat7Z+yufKodHJKLHaalHhwgTU+L8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GgfixRCi7D7zmf3LonNP4Ozluj3wnGSed4vLDV4g17ge/6u5M1FsXvVGvX9p4ZrpS
	 M+IsDN9v6aU9atxImKnxkehgn/1UxkHVP0Mn0N9ScQY/Qv0ZJnH2hOmqw9hL/KZ8lI
	 kOheLRRqM/O3o7/HcKvk8lLIhulQdS3hWsRx9Y7iJ9gwrdwXI8VFVf0fXYo4lvIpyR
	 nCc4DBMJDwv6nwS7OZhwHtWVz81y/SAHIp9VrpBNaXQoG6UehgOSeq6bPOHLxmXgJ4
	 RWiF73VfH7N+ezRbnYv5wey494xpQZoY09iLJkLrZCoBznINB1eJgpdCwVroGuGduU
	 d7cpqDth50dig==
Date: Wed, 10 Dec 2025 23:46:38 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v5 2/4] mm: Fix benign off-by-one bugs
Message-ID: <9c38dd009c17b0219889c7089d9bdde5aaf28a8e.1765406337.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1765406336.git.alx@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 405A3180002
X-Stat-Signature: 48uy4fry96te63yrunbmzpaodjw5u94x
X-Rspam-User: 
X-HE-Tag: 1765406804-282834
X-HE-Meta: U2FsdGVkX1/Lj96Zw1ryG1taoRjGw8Kq1QJsVvE/zssp48QjUO8EDul7tQoG+NGvOp/mufFoEFZJnL21VXZvrwzKfgwYkWC8A4djG2C6qySAacTXzTFCUfg1z3rn3RMhc2IrUZx3CWmtQDcf9t5onqryqegfvam6Ww4vmfMvFJ3cu0ydUGjPJBUgD5/4z/HBvjYyZ8CnJBiYzbKodcUdsR+PNQ5kuIaxGCCKer+XKRaQCOt+UGqGM5so4dGDaqMVCW8V4OQbO444n546MDj/vYnsHJiY0T9IVvOvC/7PIT6mXZ7nUUAtmsxWUlZfXjmTXVz3UFxdOquEcbkeyunIatmrp3RZbd3y5aT1b9IWSjJ8W+EEIST18H5gvGU+Fez5UX9VJw0BeKdIqYXG6rNKn0tEtfX+DnKddjQxvcaoHWYBO2NX14Eriw02NRp2wOt2Z0hdI032OP2TKFMvd8qjuR1vq3zhz3GPnThIYXy59wTZLjfXHw1va6tjIbaU26pTgY3KlvmlKFbqstYURxVx7gWg/LMBcl7ad2TZXdqUufJGFJiwuUUKBidpNgdFRoP12V7Yym8d4s2ttFvZXcfxvJMrcp57taSmUNUsoBTMVCWK1ih6lDrbYdfXk9TRzPg0h3SlZHzEVz58ohb3RmPEsswTNcWKq8JP3xJRnScWiipX6DSbcXv7xPVpdRer4tCfEJbMZ0p6kZrsE7EGCoj6g7p/7Wq2xBbiXDEZx7DDO7gbl5Ci2wRHNRMElmra4DtndvnT3NKgj/N3I6TzN1Vualsa7wkCO1ibVGg9fbnDb0FluDg+GzPtBdrrDuxOURwRLhdsQlJ0FCtku9pPbeVSShN+oDZpYlJ0eSUXDa2PYpPHse9lcsJhAsqdvGOCec4pDIsDmJqwvd99YgQAlc6sdUeO+H6aQ8tsUV9i+THNBG51vxNJFplMgfJs0V+G8+hXfaoAv4ZkHl3g1hsVosY
 xRgEVff0
 A2NaENcCPJSgicnVlcZneKMx6s+2obrbm1bixG5/OCyierDfRPagnWIC5yNIfdaBbczl7MoaLvkW5vWttkTbxTNPW/goaZhnqQeNEbkg25HI2EeOZSNQvwrzYXCSRYSlLoqforM//oYYehBaNmbvErbHcwjAHTNJseH2udsn/A5QuWtMZypjk9HiAr++CeI3U8ynvbhC+Ik6uql3sowG5IY5kvBAQNj0cxy3srP4JTF0vVrr+fmGmmOWycKw1NnO0CEiwuTMv1S2Cf6yfWbYcNr4OVr9H3UHPYIC3Izno4uGNnaWm9XD+4AAz+vAcoAuP/5wF19R7I/wtWAeTtyzepBqTS3DoLpQs2hs5mMi1ZSKPEEIY81X2Q/4gOc4PWo4OP0PZeGPtO4P/ZEB0SpnW0Kzu4QgHGWwAcSECwtT8rjcDov14cpNgGAJbf4HPjog2zuYFqkHVoWL0koq+mfai+MHdAol0VspaS52jgsQi4ib45BBegqU8zkivvYlPG74NNT2p0ddkDTj4hTcFVy425jQtVRS3XPIeJwZB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We were wasting a byte due to an off-by-one bug.  s[c]nprintf()
doesn't write more than $2 bytes including the null byte, so trying to
pass 'size-1' there is wasting one byte.

Acked-by: Marco Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Message-ID: <515445ae064d4b8599899bf0d8b480dadd2ff843.1752182685.git.alx@kernel.org>
---
 mm/kfence/kfence_test.c | 4 ++--
 mm/kmsan/kmsan_test.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 00034e37bc9f..5725a367246d 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -110,7 +110,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
 		cur += scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
@@ -140,7 +140,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Access information */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index 902ec48b1e3e..b5ad5dfb2c00 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -105,7 +105,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expected_header;
-	end = &expected_header[sizeof(expected_header) - 1];
+	end = ARRAY_END(expected_header);
 
 	cur += scnprintf(cur, end - cur, "BUG: KMSAN: %s", r->error_type);
 
-- 
2.51.0


