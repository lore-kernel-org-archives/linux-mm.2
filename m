Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E075C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E226B0143; Wed, 29 Jul 2026 10:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6006B0145; Wed, 29 Jul 2026 10:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498456B0146; Wed, 29 Jul 2026 10:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20FE56B0143
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C541A14063B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:13 +0000 (UTC)
X-FDA: 85041736626.08.FEEF3C9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1C06740006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dbby0wkQ;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327972;
	b=nl5eD3gOHugdwc4O9/09YP7jNaR08CIJg9TrkB27TfPC+xFr8p6mj2LakbgKe55kW3scN8
	Uxhg6b1wcq9y+AwKKLmTPpc1vFkoX21aYsOJpJS6MfZMnkwd6CV8D+t80mGi0eXcjRzI0k
	dMSWmMBYaulzJl/U/sFMh2A32LDWqaA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dbby0wkQ;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TqhIhqUpzpOOzDUBk7hCfNYEZnFrNF+Qqh8CxlP3wY=;
	b=eejHX/nyTDAq1yjs1dH8+eU6Zp/qrseNp1vXKbySz5wBU5/YHwBKXs261jOUguRqX2MGbL
	IRhCKCdHcmsuQ8m4K9s2I08mkHBLkhG7FsAz4wMk64bTMRaeh8q1GtIjLX+bswmNicfNBw
	WHS/G4iv5dQqqnKqkOi1MS7oebmv7h8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 435EB1688;
	Wed, 29 Jul 2026 05:26:07 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BA9433F66F;
	Wed, 29 Jul 2026 05:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327971; bh=B5C06n+nHY3GH1lL7Fz8Op3mIJsdyU/2KKr0Mpz2km8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbby0wkQjJDxhPwa2B5hoe4l1aUU3Z2WfTysZOLj6vDiaOlnStimYU/uzN9QvveMo
	 uHc+bX4xreeuGiw6Ykl8RGuIfEjaSwDGyhEq0sR3lsMYh9AKmcJzhD6W1GwxoJvXos
	 yyCP7YIYoXD0ajUAKxB6pW/qG2DGgAx7pDefUVJY=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/17] arm64/mm: Add an abstraction level for tlbi_op
Date: Wed, 29 Jul 2026 17:54:50 +0530
Message-ID: <20260729122452.3797443-16-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cb53gff79a1swggo7zdgk37fijg1sy6k
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C06740006
X-Rspam-User: 
X-HE-Tag: 1785327971-274103
X-HE-Meta: U2FsdGVkX180/cc2f3DHLdEb9v4oYcGjwjvJtLrBGaXRu0LHyTQvrsmwS+SXg2OYc8g4gcjJCirp3SaEKWPmxpWCEj1Y7cBMc6whvUHu8ddXb+iSNrkgZwkl+za+Ft1kBN1Uig19M/kYHFH/HIKJKIjsccD1yZ2RXKtXKxCYfFXKK727KQVUxn00Kk2aKa7a7FgS8MYqDD5zqyfhPU1CL3zS34b8PxSvUM6WI9lQ+ZEofoHjJBeobKXsY81wIWub+CRubd/n2VvNfth2VphwP75Nlv6xxHX7I3tacRKDk2TD3v/jdYAal229N9g7glFGJvRf+56yMLGTy3b1hxbHYZszkayjGLIh9MTyI3+i4s6TOF9YAWR9OoN68f+AeGE9RoIwHi15XGqgfiQ+5DvPgKfBMa61+VPRwKqCuJYZ8Ynaf+Jrr72LzEqPs/P23BuIVFclDWRV5VrJklCux5A6GztERtVG5wyXHi518+2h/DvAEeMghlu8s6Q0LiBNc3SapJhQNbyaZyPHyPxTQnA2C7SIBpsXBe2rAeVO9TxnHSIvfUN6Eb3YIv6Ffdy4QQz5CJjDGsDTExg4UgeNSSAtvLqpxhfGL7ufGd55uBwu4mCOF/SG+Z6l627GjZVeXdA8oxL6bXmAiU/2kCjY1HluF2TVPO7XOZKfjnB/aQ7SmP7Pr00urK/78438LKu3oA7O4i9OKCpW7vrh1eoIJYkjeuu3jD0g1uKfv63CR8YUBVRLFrJDmGnriZKgSViJVas44M9Zgt4/hxtzJvwRmaL7MJyh56rSyfPotXlGanK+obF+de89z5aVXIeI2FnrfJFXxJ8ZHnKeOE/5yXhUVyiaL9PdjEk1GMFZLJ64LQ/f4oQdDGSJbAFPS/34/A046vNXsMtxjJs7WJsHxjnil5uQZ0Zix+fT3A4KCh5b0po8H2EGgtWTknrjpsrLguKVzCBbnNfWCygXrQCuumqvUPR
 2lmxVH2o
 /JSpwWNVweHbazAZ4/gP18mIzI92LCEocv1vUtlUUsbGnmgVdg4wOY/WikVofcSlDKgmFC9IEo4JQZvbBJ+gI6/2sVkU7luMyFxsdFtwbyUtDdjwasBGejaMvpTUiNyx89ttwQWBPXa1uD32Xspuf1GZoR7kllj8QKXENUD7KS1DqaAfbYq/uu4EtclsyC8iCnrl9Ynwa/cML2C42dMQWTXyR9lE51iF3zDj7AmGIEE5D1kkVzERHyCv8BPjQJF5ESF/onwKj82t7WLy99xODuljK/67mgeDTTko6YMUZShRyq0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linu Cherian <linu.cherian@arm.com>

With FEAT_D128, a new instruction aka TLBIP is being introduced for the TLB
-by-range operations which has an argument size of 128 bit.

Add an abstraction level to void (*tlbi_op)(u64 arg) helpers to support the
D128 variations when applicable.

No functional changes are introduced with this patch.

Signed-off-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 70 ++++++++++++++++---------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index e0e84332f51b..c103380ec87e 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -130,49 +130,53 @@ static inline void sme_dvmsync_batch(void)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
-typedef void (*tlbi_op)(u64 arg);
+typedef u64 tlbi_arg_t;
+#define __tlbi_wrapper(op, arg)		__tlbi(op, arg)
+#define __tlbi_user_wrapper(op, arg)	__tlbi_user(op, arg)
 
-static __always_inline void vae1is(u64 arg)
+typedef void (*tlbi_op)(tlbi_arg_t arg);
+
+static __always_inline void vae1is(tlbi_arg_t arg)
 {
-	__tlbi(vae1is, arg);
-	__tlbi_user(vae1is, arg);
+	__tlbi_wrapper(vae1is, arg);
+	__tlbi_user_wrapper(vae1is, arg);
 }
 
-static __always_inline void vae2is(u64 arg)
+static __always_inline void vae2is(tlbi_arg_t arg)
 {
-	__tlbi(vae2is, arg);
+	__tlbi_wrapper(vae2is, arg);
 }
 
-static __always_inline void vale1(u64 arg)
+static __always_inline void vale1(tlbi_arg_t arg)
 {
-	__tlbi(vale1, arg);
-	__tlbi_user(vale1, arg);
+	__tlbi_wrapper(vale1, arg);
+	__tlbi_user_wrapper(vale1, arg);
 }
 
-static __always_inline void vale1is(u64 arg)
+static __always_inline void vale1is(tlbi_arg_t arg)
 {
-	__tlbi(vale1is, arg);
-	__tlbi_user(vale1is, arg);
+	__tlbi_wrapper(vale1is, arg);
+	__tlbi_user_wrapper(vale1is, arg);
 }
 
-static __always_inline void vale2is(u64 arg)
+static __always_inline void vale2is(tlbi_arg_t arg)
 {
-	__tlbi(vale2is, arg);
+	__tlbi_wrapper(vale2is, arg);
 }
 
-static __always_inline void vaale1is(u64 arg)
+static __always_inline void vaale1is(tlbi_arg_t arg)
 {
-	__tlbi(vaale1is, arg);
+	__tlbi_wrapper(vaale1is, arg);
 }
 
-static __always_inline void ipas2e1(u64 arg)
+static __always_inline void ipas2e1(tlbi_arg_t arg)
 {
-	__tlbi(ipas2e1, arg);
+	__tlbi_wrapper(ipas2e1, arg);
 }
 
-static __always_inline void ipas2e1is(u64 arg)
+static __always_inline void ipas2e1is(tlbi_arg_t arg)
 {
-	__tlbi(ipas2e1is, arg);
+	__tlbi_wrapper(ipas2e1is, arg);
 }
 
 static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
@@ -443,32 +447,32 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  *    operations can only span an even number of pages. We save this for last to
  *    ensure 64KB start alignment is maintained for the LPA2 case.
  */
-static __always_inline void rvae1is(u64 arg)
+static __always_inline void rvae1is(tlbi_arg_t arg)
 {
-	__tlbi(rvae1is, arg);
-	__tlbi_user(rvae1is, arg);
+	__tlbi_wrapper(rvae1is, arg);
+	__tlbi_user_wrapper(rvae1is, arg);
 }
 
-static __always_inline void rvale1(u64 arg)
+static __always_inline void rvale1(tlbi_arg_t arg)
 {
-	__tlbi(rvale1, arg);
-	__tlbi_user(rvale1, arg);
+	__tlbi_wrapper(rvale1, arg);
+	__tlbi_user_wrapper(rvale1, arg);
 }
 
-static __always_inline void rvale1is(u64 arg)
+static __always_inline void rvale1is(tlbi_arg_t arg)
 {
-	__tlbi(rvale1is, arg);
-	__tlbi_user(rvale1is, arg);
+	__tlbi_wrapper(rvale1is, arg);
+	__tlbi_user_wrapper(rvale1is, arg);
 }
 
-static __always_inline void rvaale1is(u64 arg)
+static __always_inline void rvaale1is(tlbi_arg_t arg)
 {
-	__tlbi(rvaale1is, arg);
+	__tlbi_wrapper(rvaale1is, arg);
 }
 
-static __always_inline void ripas2e1is(u64 arg)
+static __always_inline void ripas2e1is(tlbi_arg_t arg)
 {
-	__tlbi(ripas2e1is, arg);
+	__tlbi_wrapper(ripas2e1is, arg);
 }
 
 static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
-- 
2.43.0


