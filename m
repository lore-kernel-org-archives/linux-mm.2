Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06C2C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F49F6B00B1; Sun,  6 Sep 2026 23:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556C96B00B2; Sun,  6 Sep 2026 23:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445796B00B3; Sun,  6 Sep 2026 23:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 229596B00B1
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:51:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE488120675
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:22 +0000 (UTC)
X-FDA: 85185591204.09.16EE5CF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C32580003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lKEnAII+;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753081;
	b=wmoOfDWUd5BAVf2GaTP5YyxLBR5WbdaQcFjUlhzZ+OhW5QK6qWruPnklI6nfYA6Giz/1CB
	5ge7aXcLinLG5EnCQUH2odOUbsjL9k8RovqOCnrdBDlGprQD+qaJdEzfasZOX+8h3LcNRZ
	KHy3Gbzfa7ttXzMso52Y8GjbD2T7/yI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEBvV9gjKrbuABjrjbq9iRE3PsX+PTSdkrbdKxkE1G4=;
	b=IJgwsEFBK23dlaFUzm2rmNAH7FHzZ77Ml3NRp10KtIQNNJG/HsdDXPtXIJwkSNvcvXXm5D
	wF/mYENVikvR3arnfGk08CutXkvbrPm+6vBlwdg/K/Bzx+aMoUoAlz/5b0USI8LknwkV6A
	sCrvGkSCOsyDprIFQAsYAaIJ/KujEtM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lKEnAII+;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A16E41BA8;
	Sun,  6 Sep 2026 20:51:16 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9999D3F7B4;
	Sun,  6 Sep 2026 20:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753080; bh=Qb+7E8NXipxvoAEHwL2Au3g/XDt1GmXueAfBnPSqsJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKEnAII+5BcNq0/1T2NrvYL3H4zsr6jbJe17vY4vHbGtC5Ka7nzO99iXt8eHS5Maf
	 DUh3npYqcQW/MG/QV9gj8aGR+OWVu2/7LIT0nnrpnjXk7rBdDRVbBdyr+CQYOu3SFr
	 xyxdDNO5/m6NQtaItwuz7F+PRbFHlpCj5q5LgVLM=
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
	linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	kasan-dev@googlegroups.com
Subject: [PATCH V2 12/14] arm64/mm: Relax KASAN shadow alignment for FEAT_D128
Date: Mon,  7 Sep 2026 09:20:27 +0530
Message-ID: <20260907035030.2839978-13-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2C32580003
X-Stat-Signature: 49rrkr56wfkg5atddnaq3k3e5a5u6mf7
X-HE-Tag: 1788753081-83812
X-HE-Meta: U2FsdGVkX1+dcP7qYYQ8gpyk3GDrwDeBYtfsqeuk6sL+DhKG62BZpel4C+kVT/MVBWi3jQ/Ciz44NJ0UbW9owI5xG8aSFapCOSJsnNjUVo8Nc4guIwUxFIcCbBoYFrqLdLtc3vdFP56e6bNdrN0XPImO3nM4YVZ1H4c+vgt6L0UEh71l7EZ2lXvSk3cEQvQPX+wK/mMzQIGZ9jP8DswzkuXaOOkyUnzrvgpVb7kZNoTJnJ+ZMzE8VDy7/j7EcBJDS+GehGgovf1qe1QAkv2fCwGLNNZcvuq455gTBnzooq463HWbcy79dVTtrkhXSIrEf7Tp8//+ZRzdXaNhuglsc330NGD9Pmm0nqr3C4RaYzk5odWQYYeNKu1n2FeeDEwvdFBQca8aSkwerUAJUIg2eJg0+puZKm+uB65th+2PueeTphk50MG/S4nqRBcvyRWeTjr8ehKtGJHik90j9yS2FgdMQ4AfzNlfNOq+pjRETiDFYgYyvAsHifJvzMEPwd9qq6xY8MukleUnHKBvPSGczkbdrRD0UlqwoKiLbNDzciD6pkfk+ITfJIw+uYEfuxuip4KtHPOibN2K0kr6WkcPpwWFh0VB+WjuEhhM4WsLsucVo2fWoVZpLt5d0YdeQ5bhnHOFpMNdNOvsua9Ycin1ezcTroraWB6f6ya6YQAZyUqA7EDAjtvMOvZnoA1p7215kNGkD9ARiBcbxjdJynojED7/IRD2J38Q11Weq30zN9PMnb3zExWDu8HIgHEpyDg3Nyu1DTQ8mZYIJnEBXSLtqDzYkIDjd+2RHfVP49+qed3AoutI43bYB59jYFfkFkZWq/ziMRsGVYCYMc4xC2c52BTaXo3Wik/W3tSD/mGM5VeG1+wBUf5P8BOA5OSjlWL8D6APQZ20IR3sa1rKAy0zJESSTUuxxz+WRQKfCxx4RNtGGOx2PL+cXL7p/f4AIk1hz5WWIZa+QBeRyIsaM5J
 OjvXuQcU
 oUTvhKRDASOZ0SGmGxSZ3a674RPZ8tmF3QDn36wgubs6JIYaS3sCRr7bqRefqOR/CTps5kc6kt/k7B9OZt9vYT7zXb/jywytU900hZ2o39DUFsmUsb4wiXnG1ssdpzWZREyic8dSJ5AR95UUaJGZffKyGuVP/dKoXR7Lj9S4PzNM0ZOvPIw02EC0uztzvi5lK8SdN9Ax5bYIj8qfNhRlqcxENXJgdxd4+OdSmBSpTPVhdzY3NSl+YehAAtGZBX8J/JcxEr9cxFifMkxnBgSL3GI0TWxRMBDOoiqoRwmyCoOBjvvKpnG8L9JFdBuVrH5xzPv1nWmTuML500+7MhmJjRmVUjPUZ1+BMPMFrbZ3uNGE0i1gSvODGd593RSeJ4e3QOBXmK/Cre/uzhZcE1m8vrd6cGjXCH3COcKdKMv+KRrBay33+1lJnPuMuZQtJ8FN3lENHi5sKVWKSRvcHU/3ldJfnUWZPkhD3zVzdG2dLrzttPIkKsfhsMZsIOTNxZcrFOgc5w0XpCjQrK6mxmCuP71mEi6/+jH2We9CumUUiKz/qZp9EqCMcc431C8ktxMlbX9gW+T1QTNb/mxuANnz3aYqsjkA17S9Xrd14
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

D128 reduces the number of descriptors in each translation table, causing
some VA size and page granule combinations that use two page table levels
with D64 to now require three levels.

For three-level page tables, the PUD level is folded while the PMD level
remains a real translation level. Hence, PUD_SIZE represents a root-level
span. With D128, some configurations have a KASAN shadow region smaller
than this span, making it impossible for both KASAN shadow boundaries to
satisfy the existing PUD_SIZE alignment requirement.

The KASAN initialization code on arm64 already supports shadow boundaries
which are not root-level aligned, by installing or cloning the next-level
table as required.

Similarly for three level D128 page tables, relax SHADOW_ALIGN to PMD_SIZE,
which corresponds to the first non-folded level below the root level. Keep
the existing alignment requirements unchanged for all other configurations.

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: kasan-dev@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/mm/kasan_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index f61f5bc09467..e12abea6ad15 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -178,7 +178,9 @@ static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
 	} while (pgdp++, addr = next, addr != end);
 }
 
-#if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS > 4
+#if defined(CONFIG_ARM64_D128) && CONFIG_PGTABLE_LEVELS == 3
+#define SHADOW_ALIGN	PMD_SIZE
+#elif defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS > 4
 #define SHADOW_ALIGN	P4D_SIZE
 #else
 #define SHADOW_ALIGN	PUD_SIZE
-- 
2.43.0


