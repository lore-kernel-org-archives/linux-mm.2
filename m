Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0D7CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F0F6B00A8; Wed, 13 May 2026 00:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06886B00AA; Wed, 13 May 2026 00:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BEC6B00AB; Wed, 13 May 2026 00:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9706B00A8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:47:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6827CA06DA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:44 +0000 (UTC)
X-FDA: 84761163648.29.36EBCEC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 98D0F180009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sIw08p51;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aJljDkEl530JUlXP/acd/Wc+KOQERlK0h/Hx734pvo=;
	b=fNqg8DWFFemOzcf9BA77/GXdzno971EdhmZitb+pNvKMlEkms42B4mhatccdykXJqg86sf
	I3+xTrV6ReDkpuPr1m80O9/PSU3VPASQnNteIfNyiwRFup4Zi5fqaC9KZjUZVbWhD2BVGC
	nXhNpu5IF+ye0fuazEUYgRtipwNi0bY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647662; a=rsa-sha256;
	cv=none;
	b=kL/WMbY1p97BNWtWqblJAmQf9ndo07qcZbef2ZPOW/t+0jQgX+aPvEhliAwGy/+0ryJkBs
	C5/c50oOkkYPyT3c2FEtu5OG05Z3XRIKlpDUjzz8ULXrCYCNV5V3T64BfVS0lnjujRmYxL
	9Oz4pDNSbZe6G3nUhoxrPi7/mry5qHo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sIw08p51;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82B061595;
	Tue, 12 May 2026 21:47:36 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 305A53F905;
	Tue, 12 May 2026 21:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647661; bh=TmCvO12iAjHSRBJDFbEkaVzXDT8a8vX3wzPeUnlsa9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIw08p51XIj5EbAwuNGYLYUlpNL2nf3nisSDjSd6CTG5MqAQE3CPjzFwXRo9Tctza
	 dmq1pAKdWQqtprsnDuwV8WLy9TcNI3EPXi6eprgKVZtL1goOwG6DhSoroM/thdRCZg
	 gm/DV38U6ihb2/WizMSYIpahGPpI3K55FfOqXhaQ=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V2 13/14] arm64/mm: Add an abstraction level for tlbi_op
Date: Wed, 13 May 2026 10:15:46 +0530
Message-ID: <20260513044547.4128549-14-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98D0F180009
X-Rspam-User: 
X-Stat-Signature: 4gahf31anjx1sethk1g8eizydmsgfquk
X-HE-Tag: 1778647662-511050
X-HE-Meta: U2FsdGVkX192GDJLo3JSxKnE7BN0DuUfnPNSrJE08yy/AIdEWIzOwP+Ml10bWAAejZQiotGACJ+M04vV8G38MymLU1+cGtpxGiJlz0oJ2cViYMBxtnaC3zqSkVqbhJMmrPNI7PieQHvwhz2Z2dctNmYqu4/8mOYjxx6sPsZACm50hgUS3nSZoMP1tQbHPbKzM/UFIE5xqQyqjzvkbO2l1y3nmg1gfFXM6MQ2TidPxoAVbYtSIvKVU0ORYPsX4w4c6ETBRjEgBPol+G6hNluLn46hi4osaJKLMcus+hRyxhE1jxENx8j3kVhLVo+qfGn43vz+t5KUMR7a8Dq+n3QffAGGQER4z1pWlfDCnwoeWKfTyMftL9Zm8JaqdaZgQ7FUFXQXyOKBhQAvMzwc4DjPvtQkowFr0N1x0/jdFNPBAo/JTvZQ3TVtavFrUMDxSjmf4wkW6z87MVRdGpcMe08QFTvEHxburNaD+rAnmNaxzTFlZdU3/DgPoejeKue4oqtgGiw1RjbCyT8G/oPiVAYeh2IDPLdPjJChimKmcrkcHsrNqU4InSS9+jyShqeRCzViAyPI5wMU9uMGrti0gzbtmIIRDctFretDDLhGoP5J0m4R6iJIXpcy3F8+xB+ivhcKWMLb2cu5hB4CV8/enLpb7CiiA6WILKvWzGcNNvuX2FgafXNuABxWI+YcligIFHCrkrPaQARwvzGieuK+91cS05WE8Qzz4YJ0qdPxMrbjuvqO1iMD4f0BrWSPddV9WmG5yO4SxiPdPXFaFri9zQ26pAXFCJ9zrCDLFz/0J14uV/4YYmnWrmtHYpBFRIyY3Nt9VqxmZQLLF92+v1BKSHkLL4cY9ZHMBhm9tV60HrB6iPPLB9el7JteDCn/et8ESSHb/ydLF1IfpmGugS/WHq3eDclXdjrEKEorPrbh7UhwzBMEwuEJK9mCWUC+F+iYLQiWWcnBAXwo/KHp/zRa231
 75oYGPfb
 j/7jnrjas8hWYdS4R5ymFMjdkXzJa6qYBQYvcbvSNPo8BxQSCz63rjIxc4uNtvO1ys9QfGEaWCpTi0ellStuM7GJQKqRs1IoV01Hj4U7pn25j7IhEcOCGAtN4FhNxOzU8sDa1BNLKs29F0bb8TJCgXxxiacMB9Apvioj1uuufAY0qCHV4vwpBvmMtSTKOWGluAVaogd/Cmf4mPNyNGvBQjbgYgHOFvNGxpSmNe7xEAgeFgHrXb3ipNztBjkK+X55oj5GtGDZKS7d1dq6gwZ7nNCHvQhn23ydYJ5Hj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linu Cherian <linu.cherian@arm.com>

With FEAT_D128, a new instruction aka TLBIP is being introduced for the TLB
range operations which has an argument size of 128 bit.

Add an abstraction level to void (*tlbi_op)(u64 arg) helpers to support the
D128 variations when applicable.

No functional changes are introduced with this patch.

Signed-off-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 70 ++++++++++++++++---------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index c0bf5b398041..361d74ef8016 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -162,49 +162,53 @@ static inline void sme_dvmsync_batch(struct arch_tlbflush_unmap_batch *batch)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
-typedef void (*tlbi_op)(u64 arg);
+typedef u64 tlbi_args_t;
+#define __tlbi_wrapper(op, arg)		__tlbi(op, arg)
+#define __tlbi_user_wrapper(op, arg)	__tlbi_user(op, arg)
 
-static __always_inline void vae1is(u64 arg)
+typedef void (*tlbi_op)(tlbi_args_t arg);
+
+static __always_inline void vae1is(tlbi_args_t arg)
 {
-	__tlbi(vae1is, arg);
-	__tlbi_user(vae1is, arg);
+	__tlbi_wrapper(vae1is, arg);
+	__tlbi_user_wrapper(vae1is, arg);
 }
 
-static __always_inline void vae2is(u64 arg)
+static __always_inline void vae2is(tlbi_args_t arg)
 {
-	__tlbi(vae2is, arg);
+	__tlbi_wrapper(vae2is, arg);
 }
 
-static __always_inline void vale1(u64 arg)
+static __always_inline void vale1(tlbi_args_t arg)
 {
-	__tlbi(vale1, arg);
-	__tlbi_user(vale1, arg);
+	__tlbi_wrapper(vale1, arg);
+	__tlbi_user_wrapper(vale1, arg);
 }
 
-static __always_inline void vale1is(u64 arg)
+static __always_inline void vale1is(tlbi_args_t arg)
 {
-	__tlbi(vale1is, arg);
-	__tlbi_user(vale1is, arg);
+	__tlbi_wrapper(vale1is, arg);
+	__tlbi_user_wrapper(vale1is, arg);
 }
 
-static __always_inline void vale2is(u64 arg)
+static __always_inline void vale2is(tlbi_args_t arg)
 {
-	__tlbi(vale2is, arg);
+	__tlbi_wrapper(vale2is, arg);
 }
 
-static __always_inline void vaale1is(u64 arg)
+static __always_inline void vaale1is(tlbi_args_t arg)
 {
-	__tlbi(vaale1is, arg);
+	__tlbi_wrapper(vaale1is, arg);
 }
 
-static __always_inline void ipas2e1(u64 arg)
+static __always_inline void ipas2e1(tlbi_args_t arg)
 {
-	__tlbi(ipas2e1, arg);
+	__tlbi_wrapper(ipas2e1, arg);
 }
 
-static __always_inline void ipas2e1is(u64 arg)
+static __always_inline void ipas2e1is(tlbi_args_t arg)
 {
-	__tlbi(ipas2e1is, arg);
+	__tlbi_wrapper(ipas2e1is, arg);
 }
 
 static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
@@ -475,32 +479,32 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  *    operations can only span an even number of pages. We save this for last to
  *    ensure 64KB start alignment is maintained for the LPA2 case.
  */
-static __always_inline void rvae1is(u64 arg)
+static __always_inline void rvae1is(tlbi_args_t arg)
 {
-	__tlbi(rvae1is, arg);
-	__tlbi_user(rvae1is, arg);
+	__tlbi_wrapper(rvae1is, arg);
+	__tlbi_user_wrapper(rvae1is, arg);
 }
 
-static __always_inline void rvale1(u64 arg)
+static __always_inline void rvale1(tlbi_args_t arg)
 {
-	__tlbi(rvale1, arg);
-	__tlbi_user(rvale1, arg);
+	__tlbi_wrapper(rvale1, arg);
+	__tlbi_user_wrapper(rvale1, arg);
 }
 
-static __always_inline void rvale1is(u64 arg)
+static __always_inline void rvale1is(tlbi_args_t arg)
 {
-	__tlbi(rvale1is, arg);
-	__tlbi_user(rvale1is, arg);
+	__tlbi_wrapper(rvale1is, arg);
+	__tlbi_user_wrapper(rvale1is, arg);
 }
 
-static __always_inline void rvaale1is(u64 arg)
+static __always_inline void rvaale1is(tlbi_args_t arg)
 {
-	__tlbi(rvaale1is, arg);
+	__tlbi_wrapper(rvaale1is, arg);
 }
 
-static __always_inline void ripas2e1is(u64 arg)
+static __always_inline void ripas2e1is(tlbi_args_t arg)
 {
-	__tlbi(ripas2e1is, arg);
+	__tlbi_wrapper(ripas2e1is, arg);
 }
 
 static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
-- 
2.43.0


