Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160E5CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 13:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5C78E0001; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2A58E0016; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02A08E000B; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 808778E0013
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41A1C1604C4
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:37:35 +0000 (UTC)
X-FDA: 83920617270.25.6683DC6
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id F32AD140012
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:37:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758634653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rz2BzszcEXiuSNsZolOaAYncFvYFyjET7mNAKvEoSkg=;
	b=rwquH+Myp41yELj1GGy99sry1+B2ISaHzH7mAv2ByrsfsKzi4cJcnwiM+zKdeLoBtQhf92
	FZv8c1mNTQD1KbIu61UcbCL3f+1wCOoY3NUWd0MYs9wti5l/BaaxU+V2l24Yjut5qWaOAr
	G75NnJWA/Etdfh4eYieUBUIbHbJFlN8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758634653; a=rsa-sha256;
	cv=none;
	b=aAiCrAan8gN0ZjLXh41qq8YDQmEa9UnG/jKYjUZ9sG61Ke7/eakN/38cJOipQ8T/79zfVJ
	r6adeS1+qKMB3nz/JZzG7DdF8Gel3IYAipVHVLgVu0eHjqHRqnf5KzpILIMuaZ8Ce4xwjG
	Vy6VLZYe+EwqWpVkLo/HULWg9UQp4Kw=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cWLWg3pB3zddT4;
	Tue, 23 Sep 2025 21:32:47 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id E43701800B1;
	Tue, 23 Sep 2025 21:37:25 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 23 Sep
 2025 21:37:24 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <anshuman.khandual@arm.com>,
	<yangyicong@hisilicon.com>, <ardb@kernel.org>, <willy@infradead.org>,
	<apopple@nvidia.com>, <samuel.holland@sifive.com>,
	<luxu.kernel@bytedance.com>, <abrestic@rivosinc.com>,
	<yongxuan.wang@sifive.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and riscv
Date: Tue, 23 Sep 2025 21:31:03 +0800
Message-ID: <20250923133104.926672-2-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923133104.926672-1-yintirui@huawei.com>
References: <20250923133104.926672-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F32AD140012
X-Stat-Signature: 6ghkb6eke6tdez9py31a6icjnkkh3mqd
X-HE-Tag: 1758634651-879724
X-HE-Meta: U2FsdGVkX1+2Mp4w7jFDO7AkNJVNfssDVIlyP0E8gxHmCqq9PehlELBZSZ8lAqmSzAPVPRRQbG6irrVsLoceZ3gzeZ0f1UY4GcjSuhkA0WQe+jYPcp6UbGERbYvG9w+Fx4jDIox+pjswK+ND3tWCgHq4YxwDBe+onmu9ibBUtEgC2h3emQ7FvdH9q3iAV00tZLonHYNmh6V4lKNXK0O2rbLWzIKqAQkHK8iUjuK94QC1B+fL5WMTDW26jAbTuW/IPgBZXTJ20dfBFRljURYrX/5ujCaTr1Kud3t/SO84vaqJs6XVsmuYYWrzDgIUq2dPb+7dQ5F38ZKPqVDKBZg3PimYhhlVeydhktQ4oE+LXN3+Z3qPD95uHdr0qLi3qam1xDfRaEzXcATNVK3ihDxf2lLfJfmvVHDFL3PLFOKoUjuV8l21b86h9azoQMKTb0mV9MuXNdG743YLMaYkPswAwZslvV6Et2GICipm8vZyZlP+upi1fsZesDT02B30yoa5x2B2RNbgmpf4OAbKtIgjWuQz3FxbO9yrA5T8A9AzZS24qRPWXrwdgBkE49B6iCDhEMOXNEgp1x9QAsRqtUrJCnoOwDpJslGSawk7T9ygUfTcO102OAgyNAKi8MXV8VIE9zej0lzousqHKPjkZ9cKS9HDjkcd71uifP4qORrZ9REMLJPECyNxMPfudoZfQaWmze8b0ISwPyIl3Inr9wXgdIdXQZKHPff1E2CcIiLSA4pUAKJvOU+uOTQBR9/BJUgxzMDoToV3bKAHDhmgPTSt9+XZP6op55i14yHuy/7a8RpwYTcriT+oVy+VwNSKgK+150Sca++ZifVY5tcfExVrwhaxiZd5sFPN0CKThJtOA1pYS8sMQ3gqbaOyhInmR3eycZ45s1CU9uB0J0Rx05DXKy7hqdp23rTJWN2+oJChI7r1fQf6AdQzVUnn84YIg8VtIqlHYm/MbPUEIngZIy6
 pHiijocU
 grp/GQZxn1I3gJ8aQvbHWbXyGNQHabQWcNcAgGztgFu70RDmhpmF1dfWo9O377lOit5vB32ZADsLMMazgRSfvqRQxlfOSsk/FwOUL5N+gRxLtGJQT1Cjz0g1AIcJno/hQeRWKnJNyi0fYlfwar5qPBqLjERfhMLsZIAYrnaxN2iULUaO4+dkE2ftE9ZAgTQU+hL+ZBWcBlZSFy7N3Uv7I/JuJcvyS2D3KNA4eob9EToYTBIyhNLOtM2kF/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add pte_clrhuge() helper function for architectures that enable
ARCH_SUPPORTS_HUGE_PFNMAP to clear huge page attributes from PTE
entries.

This function provides the inverse operation of pte_mkhuge() and will
be needed for upcoming huge page splitting, where PTE entries derived
from huge page mappings need to have their huge page attributes cleared.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/arm64/include/asm/pgtable.h | 8 ++++++++
 arch/riscv/include/asm/pgtable.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..244755bad46f 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -366,6 +366,14 @@ static inline pte_t pte_mkinvalid(pte_t pte)
 	return pte;
 }
 
+static inline pte_t pte_clrhuge(pte_t pte)
+{
+	pteval_t mask = PTE_TYPE_MASK & ~PTE_VALID;
+	pteval_t val = PTE_TYPE_PAGE & ~PTE_VALID;
+
+	return __pte((pte_val(pte) & ~mask) | val);
+}
+
 static inline pmd_t pmd_mkcont(pmd_t pmd)
 {
 	return __pmd(pmd_val(pmd) | PMD_SECT_CONT);
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 91697fbf1f90..125b241e6d2c 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -455,6 +455,11 @@ static inline pte_t pte_mkhuge(pte_t pte)
 	return pte;
 }
 
+static inline pte_t pte_clrhuge(pte_t pte)
+{
+	return pte;
+}
+
 #ifdef CONFIG_RISCV_ISA_SVNAPOT
 #define pte_leaf_size(pte)	(pte_napot(pte) ?				\
 					napot_cont_size(napot_cont_order(pte)) :\
-- 
2.43.0


