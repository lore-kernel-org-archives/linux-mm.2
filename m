Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EB9CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB426B00A3; Fri,  5 Jun 2026 14:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6BBF6B00A4; Fri,  5 Jun 2026 14:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF236B00A5; Fri,  5 Jun 2026 14:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDDD6B00A3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 364121C009E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:49 +0000 (UTC)
X-FDA: 84846712818.04.FE9D412
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9EB6F100011
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLUDm4rU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QT3CI10YOMV9hUEPRhdgcJ9QvcUudLRgOrpPReLPq4=;
	b=cv+F+Tb5N2Hnsr2IKE86ezkLbKovU5OlEsYWms8/G1rFBjy4xAEh1Dmu/YwIURx1E0FSSU
	Y1afhqYqX9MNQ9Q5y7ZkYsuh3gXdZmGMjeWzc4VJXXHV36ARFjkaN4DbL0ZdKf2V25+20c
	a6wSBXV0qScuJ6r8KBchfP7rjOaxz9o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLUDm4rU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684547;
	b=pH/FIq46dp40lG0hjZngi8UpJgr3WKDRFCPfKTFOpTXuaxAAzPj38ZGa33QEb/iFSZyFVC
	ankp3xpNl8UmGeWJBh0Pi16snpXNzc1eb9dayqxKXzSroB7MdbuQNCwdBSPelVkZ/dw6qs
	Ew5srpmnOVvnM2pCQVP4rj5V+/54Unc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36560601E9;
	Fri,  5 Jun 2026 18:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB91E1F0089F;
	Fri,  5 Jun 2026 18:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684546;
	bh=/QT3CI10YOMV9hUEPRhdgcJ9QvcUudLRgOrpPReLPq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLUDm4rUgoMvsHQTE1pGmbmzwZJfnKYM4r0Fl12Iiu55XvxbEQyIPEmbsBBCSIKAG
	 SpQO6BJkJDSC6dVEv5wNBaRX43ykIXIxv4QMJKlIuqJNysvE4HD/rz32IZSeOg7lIE
	 Wkm2HwaqEWxn/T/okFVc4wz4MkgvIqqg+nCvx8y4eOMT32nFZX/HnECOpnrXZzsOV4
	 gov6d2M2CfqI69tunKAwHVdRNCZJgzC66LztW+WFKFk9v3juqRCrCnBiP4aEdpHrwF
	 rs27b8UYvAwU0ogmnnlz27raGiyjlJ1taOQx6kNCb4BbXeEoNyQPTc78Tsma1gBM1i
	 7fs6PMOVnY/2g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/18] memblock: use kho_scratch_overlap() to decide migratetype
Date: Fri,  5 Jun 2026 20:34:47 +0200
Message-ID: <20260605183501.3884950-15-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EB6F100011
X-Rspam-User: 
X-Stat-Signature: 7imgsz89oiregteer4ntq1zuteumk7ip
X-Rspamd-Server: rspam09
X-HE-Tag: 1780684547-561567
X-HE-Meta: U2FsdGVkX18VQALEqj+KmBFJrpxrLcX5O4cjuNd7HQnxV9v6ATxWMI8JoA9rXZpm7yt/xt4ysV4OiugHne/4OPCT6Sg4yDDUFMWb4u1fP97mBOw3rB+R2s5lZ3IFKr9GeKBlGLUmGFNuoO2dJ83tVh0N7XHXp4GBDxbElF55tksCnoUVUKBlLhsaFGeYYL9vWcgeZoP3vz4yyTzW1F1Zv9VxldLRMCEjzVRFcmjWTqNq6kLZWO5027KHB6ZPSOHICZ4QrrVAqB68QTNPWy2cpmQbPcs6u0fBuX3YBMWQvIX2BlJCxx774/FyRaW0+MiHLV+3lWIvaA7PLGHBNjlcnWHulnBgtzc3yBAO6VVg8GIqHo7AGP125mmKI/MqtYCQiMn/bWCrlBxNClui48ZiFcDYNke+mzI2IXQuTr5GhpXdGuPYK6J+N0xJ3g0ACNEFGiQdDxVR1OHz6wXUxvr8YGS/XMMreTx8+v//9VbRHTov6dlXFyuyWhHctcZY/yj3U9aVG9RW8AeGLmsU4ktJ6K8ZZddW1zgGP2KtEvh4UxWtUcngdAizp/S/Wl8WxNM8csFp7FC6pWB35HeB8vPV4FCsPNfeL4s55aYTjdJJ1fW2ypAsSoLMT3gZTpRCVS9AgfLcKV36uwqX+TT4OXJxNl3vjHBvcEsSlV5TloL7ArcBT9l9GDEVoe57qobP/7u+ZqHnTO7JerFL6dYSDwsIhZRpzDhXwAGIhlR+9U4Ap8VSviB30sNUd+MnZg1OT68IAkVOAgSumzx9tyrc+J8/CaMm9nvDh67gzDbM0ZWizmjNOLY2WUbjS0esC+mwtt2sp24917I99D1YICMcLFRQzAXG8UTQZyLo+wuGAhZEWGf449DFqXoiaLDEAnFR3n814teu4mjt/cW6ZI8FMtw2kwQvlcy+4Klla4P+hDfgtPeWtym63tMFR4OgpikX4Fq2Ptu77Yr5cG4t/i5uGa3
 vjKNkHeU
 njsjx46quR+eAJPbf7bJh/1G8WVfYYOUHsz/LEvrz9ObHBKMn0ulmg/tVdyUosA4TdfnXtHRE+sOPD72GaMvG8uS3GgZmlIUtYuXSBj/UdUyDgczHOJBwVvbkciWGR2sKFzRwLsea6kx5br08ndJFzngW0ICnVzLbIVgQfCWZ+MNDMfJFjYM+hXLZ9ihRViiC0zitQCYoJWewvM3SQiNTz4EUTdsbjMdukN6COXNVE7sT6TTT1ynhQVNZpiruhQprExKCKE5jXF+g6o1E8mpv7hNbrWX9o6WmdS7ckPeL3c0TVhrIV1Xm+PytiaEwdHE/QRp8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Support for discovering memory blocks with no preserved memory will be
added in coming patches. These areas will also be marked as
MEMBLOCK_KHO_SCRATCH to allow allocations from them.

But only the scratch areas passed to KHO should be marked as
MIGRATE_CMA, all others should be left as normal. So instead of checking
the flags on the region, ask KHO to loop through its scratch array.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5afcd99aa8c1..546d7ef798b8 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <asm/dma.h>
+#include <linux/kexec_handover.h>
 
 extern unsigned long max_low_pfn;
 extern unsigned long min_low_pfn;
@@ -618,7 +619,7 @@ bool memblock_is_kho_scratch_memory(phys_addr_t addr);
 static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
 						       enum migratetype mt)
 {
-	if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)))
+	if (kho_scratch_overlap(PFN_PHYS(pfn), pageblock_nr_pages << PAGE_SHIFT))
 		return MIGRATE_CMA;
 	return mt;
 }
-- 
2.54.0.1032.g2f8565e1d1-goog


