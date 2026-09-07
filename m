Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB60C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36196B00AD; Sun,  6 Sep 2026 23:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D9E6B00AF; Sun,  6 Sep 2026 23:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB866B00AD; Sun,  6 Sep 2026 23:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86DAD6B00AD
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:51:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23101C061F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:15 +0000 (UTC)
X-FDA: 85185590910.15.1947763
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 64F72120006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="GoO/h9TL";
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBKjzxKqbK2knnmjzHZp2Ng5aIG6jr0Gcceu+Cipq3o=;
	b=MkZUnf7yEVR4ViKGOGYPXzfqCKPTKnmjR4Ah/1e97sBK1xnP+ZZuFMPKTeIuo7LqwRivB7
	XSTfY2Wuy2I8kn8x4pbSfvVLUTv3/EPYqk19ZELG/1f9URpYRwHSbEGZJUFBdvM3zd8hUd
	XM9+fVud/lp7N8In073O3cEahUr0F24=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="GoO/h9TL";
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753073;
	b=FOawnB1uIXPUScoDxzkHOZRE39WXnSaftFVhnbGpHIgD4+0emhPnzukJnX42Tqfs8EY9EN
	LZ8VKFE+a+5UMZuKDixI59UUMl+VWDJYfnYAmnvzGfk6cuZ8lftSoaH3iF1M/GxwVKRdil
	klreBrYYgcQgD0+4v6/3P+NxYkbAtIg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0018B1516;
	Sun,  6 Sep 2026 20:51:09 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBE743F7B4;
	Sun,  6 Sep 2026 20:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753072; bh=e60cWCqWvU5usBlVAuNQW11xubuWlhpocNAxI1B8G28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoO/h9TLo5WxQU44DjPignv1t1V1GPmlyG79AXj0rqAGEsV1VdWickcqE4TMSYxKb
	 e0iIuExCyFmFHPnmczA8v3nVJeUJ1HA9VAXFwEGmE7WaYEZXk/vp0Prb41nDO6V5jP
	 z3hOjL0pkiO6NZlaJ4aoiMB+agf8MRlGxZ7t6X4k=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 10/14] arm64/mm: Add an abstraction level for tlbi_op
Date: Mon,  7 Sep 2026 09:20:25 +0530
Message-ID: <20260907035030.2839978-11-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zdsgctrz7x1qgag135qa3ghq7xs4fcc7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 64F72120006
X-Rspam-User: 
X-HE-Tag: 1788753073-42694
X-HE-Meta: U2FsdGVkX1+NpMck2ANYOJMJfaYfifi/b0ggFI0wyEAw0IWCXsbn9sqtN0ez1rcZxZhnfLigw0fsOAchkAaIZVUzvEQFhxu+hAuhr0BVJ/RxcGwPJPbK/NW1+YJek+O5RWMh//4ouBS1/uDRV4p5hQjaFD94U/UH4NxKljEXOUXugcv5ZrhtPIdk7I6I7qehlGIxfpVtyxf38QoqlZFt1gwK3uRsHfVtVngxECySs1b2NGub6WAd9+6rzFHXLeD/RWUqCDRUtZw3R/zHaIq99jL4z1FoeJq/Lsgts0tZuqKVojE9Ieps+73mp/xra6mVMUY2O1TOnGoOXYh6kzzMqHCU51+pxyvCSelgRE5SAXUgsfboB4eKw2d8M1e0UyItQqJEQxo0EOpsciAC1dQ+ToYAIw0YVSfuorS67uN/7oZcOI2EsZIrzulmeW60THqXrtwAXGAcXfqNp9CfbUIXwLVfPoQ6cQ8384Li2Ful/mbOfiF+53orj8q+cjbcdQb3g291ueXyr1m9SMk20uuo8BvbA6niL4srV427oDlZB4+RoYM1onH2JKaPdgBWxA9JjRRUrlZ0NoNWgKf5oj//uvhgC+CYa0c/oblPSJfgUGkb58PULqkJkY1qubL4INYqAzuthTXHcUFaFZk0yJTR/i2PYuuqjV8vN/GKrG5sCwNDYkgS3MB5iuZYfILlZCEHRw2B61ebKRtvATLLda1Q1C0aFvoK8y+gG8nxdBVO+GVJFHX/4QJacmcVgTyrkMGSaUwkXX9oyRbRpJYMGIh+ayPNOffVUUG1CtVaglUN1leQqsTG5hASPKZ/FD7in7AwnDp8TkC34Vk2UW2Vy3DlMXcgiEvovfGGhwU7yJvdFwY51DzNi1dXANrFTkQS3nJqoe5OtmuwyLu0tzJFjpkkV+2XpCVuEdPWsbIjK6ktwLN5YOhD//wSlXsGu53dXzDhrSBN14AQZuqTHrfwHlJ
 lLiObW0b
 h6JxlH9z1i7MZK8rlv/AKta7yYA7iR2BlOL0zqZQVOezs6Lx/5gzQvHFhZWQqscAcwWJKtYYyW29IMYJqBun7KCoo42WX4IwKvPPvbuVuqvGOoYpAMpwLvsoj5lJNdDUcVRYQr6tBBXmY9uEQRzLLPL15orXBQmxy12s6M4Q/6E0wTs3xWC28cyTDztgqyjtUDt62h1gTKwc5eZMI1m2bT9FLnCmX7B8KGD8YHik9eyXGI8FtTf+PNZO+rEHV0W4Jf00oEeRewK/HyK1DkuncS/CqtVuIGbMLQKzjm1mUxcx6241Og9h5EIP7BGvnbo45QQQ1lm5W5bH3xi5+ArzwwJ20IgZyckutOiOUYscy2fcnM7g=
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

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 70 ++++++++++++++++---------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 14a78ac0f800..88ae4e443ed6 100644
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


