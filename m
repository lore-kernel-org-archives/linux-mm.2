Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F195FEE4CD
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 07:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9966A6B0088; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9741B6B0089; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88DC86B008A; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 793326B0088
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BAC613C02E
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:29 +0000 (UTC)
X-FDA: 84493004778.26.A51C161
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf18.hostedemail.com (Postfix) with ESMTP id 748371C0015
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b221ls31;
	spf=pass (imf18.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772262927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOSDprgL0d5fs/XXHSWHAOQEs7sQM/PZoje0g5bejM4=;
	b=8F/PtReRJ7Dh0vkTcuTgVTMnzDzvvCrU8Lj1rmoJM2Yne0ArF/tnLe/lrDMuFpfY2pPNpz
	6Q+kVo1r65rn/NxTOSyOYVoXdynNNm48nZMzFvIIDh6zsFIpcj6vkHxvVKqLqWoC3UB5Em
	X36D6zmYKydj3o91JJVUepqyzKr/bwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772262927; a=rsa-sha256;
	cv=none;
	b=R1AJM8RGj3+tunDzLG7o/CLv2AY4C1bGQiJ1JNJpYJxxeff7czG1rz95x2cuqMm+vfSLo/
	M87feydwbDmsz+XTY5MssI6C80cuJLNb+QKUH4yy7nnFg6UE/HhrAxhqLxNevoaNTGzp1/
	0WRhIbPecGPt3ZawzLT1f2GBpe9Ka3k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b221ls31;
	spf=pass (imf18.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SOSDprgL0d5fs/XXHSWHAOQEs7sQM/PZoje0g5bejM4=;
	b=b221ls319orrwaq2qXPX2X0zO6JRk7cd5joqvN2G2Lw2Z1N4/h1DK7lO7egszzySI87F0+NCZ
	O0HVVtR/kXiJ5iHfgXHC74jXTGkIoz4xJ2UEd7vIeGKxB7f9+6BZDG0zz6yp0mKfUcKwuVer6nW
	1joxT8IUuxM8Vaj5HB3NzDQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fNGYh4GDDzLlT6;
	Sat, 28 Feb 2026 15:10:32 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 1684A40565;
	Sat, 28 Feb 2026 15:15:21 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 28 Feb
 2026 15:15:19 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>, <jgross@suse.com>,
	<conor.dooley@microchip.com>, <Jonathan.Cameron@huawei.com>,
	<riel@surriel.com>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC v3 3/4] x86/mm: Remove pte_clrhuge() and clean up init_64.c
Date: Sat, 28 Feb 2026 15:09:05 +0800
Message-ID: <20260228070906.1418911-4-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260228070906.1418911-1-yintirui@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: totr8mmt3t5nj8hhguas17bjkeaswpyx
X-Rspam-User: 
X-Rspamd-Queue-Id: 748371C0015
X-Rspamd-Server: rspam12
X-HE-Tag: 1772262926-409794
X-HE-Meta: U2FsdGVkX1/jka0NryAQXXxQkyZimG4WPW4oXcUqEYO/McJOMlwObP3H9/1TgG7KXnbpVFuO+KoZxiLdwBDmH5c0B1tx1HL2noCD6x/5sjoXntjQ+je8eNRjOr2yfXSe7OXYWCC1SYKcDlI/YKxJJfrQhkgK6vikhIQq876G4vFzGNrRsO0T08Yf3sVVbsyMjQTeoKMaLZF4psrZwcy8BBPtiBAOP8xZythST0klalfez/yjuelSSOmcEfTZ1xD6h3JX5Rb6znzPsCo0EQ8lQ510C8NYgrCtQC2L3+iA+6fbcyALrMvrcPadNNp6R6EL0xVzhR3JWP4dwoR4xHAt3WOuAsBAEH6+I2GX4xwSA0xxLBeGCDVsv18025awfsAEIR0A2QnUcl8lmVLIbxvNtCtkGAo4CqUR/H0/vGqzAA5PzAsgqtdIQQGycYGVzVJiZkV42UccIJ6F4vLNGAh8QSUgOggpvesuJwnU+huTgzu9+/jNiUnVvE3rKZFCArL9e550CBwX/hBMB0K49znRsFptLRYClcGkasNd5q3HE5IU2gnZFWlJzjfmHWkrD8fJDB21Wo8V2lN/SIezO71nc6WoxObwm1A+tq9r7MT3nyTewObjZG5eALs53RChaqFpLza9RPJyXwJ/a97dRKLGBj3kovMww18jIIMc5zq+2S3muKcNwkxXjkh5Ss1eTzgZbQuKgxskATtkr/pYP8kQliVZghJtUqIwRvD+ViJEYnZ3Vjm9mZQ2n/y0DLOIvKK48pBqWMUp6df+XTSOtNpN9xh4re04RI431HnLIVScsUHRmsnpwGZCXmiWcCa/Pcx94NW/WpVmSePEFrQX4qau9DGhJVujYYD3mZvoMFGC2nIhr0GDQX160W5ldTqVGG9kwCYRLclYnVhTR3Eid7gRqZ1TAdWZFBkkmf8KlNK5/9z+BVzTUsBFr5C6DgiLgfArIb84DPVj5SaPPPTPsBp
 BQb1zlIG
 pwW0AvN8yB2cFZZ7LC1MYZMB6XbfKoWSc7E12ycdlGlXbn1aT2tnFZ+dJARd8RP1JT49hgsrAsWgcOlAq4+yK3JsD1Vnl9iUzfBj7kR0YpQw6Ur4ppPimFJkTuzAeS97txFYyTbzVmKPJ6z8EG6y6D4fUUbpXdXV8v/RwewsbbTCwrlueZ6fT0MX01wV0l7gL54Y3wJLx4Vw/QxMZQw3QqTs1IzgRef01u3f8XGeuZkLBofh3/7WT8Vab5oM5MEkZDKyOTx26KgWndJxRrqtXS6JicTZ7QJnCdLNL/L3rYk+widkO8YCDilYzG5qTia6MNwcaQER2AyvXY8LFWfvgt/51iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With `pfn_pte()` now guaranteeing that it will natively filter out
huge page attributes like `_PAGE_PSE`, the `pte_clrhuge()` helper has
become obsolete.

Remove `pte_clrhuge()` entirely. Concurrently, clean up the ugly type-casting
anti-pattern in `arch/x86/mm/init_64.c` where `(pte_t *)` was forcibly
cast from `pmd_t *` to call `pte_clrhuge()`. Now, we can simply extract
the pgprot directly via `pmd_pgprot()` and safely pass it downstream, knowing
that `pfn_pte()` will strip the huge bit automatically.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/x86/include/asm/pgtable.h | 5 -----
 arch/x86/mm/init_64.c          | 4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a4dbd81d42bf..e8564d4ce318 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -483,11 +483,6 @@ static inline pte_t pte_mkhuge(pte_t pte)
 	return pte_set_flags(pte, _PAGE_PSE);
 }
 
-static inline pte_t pte_clrhuge(pte_t pte)
-{
-	return pte_clear_flags(pte, _PAGE_PSE);
-}
-
 static inline pte_t pte_mkglobal(pte_t pte)
 {
 	return pte_set_flags(pte, _PAGE_GLOBAL);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d65f3d05c66f..a1ddcf793a8a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -572,7 +572,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long paddr, unsigned long paddr_end,
 				paddr_last = paddr_next;
 				continue;
 			}
-			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
+			new_prot = pmd_pgprot(*pmd);
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_2M)) {
@@ -658,7 +658,7 @@ phys_pud_init(pud_t *pud_page, unsigned long paddr, unsigned long paddr_end,
 				paddr_last = paddr_next;
 				continue;
 			}
-			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
+			prot = pud_pgprot(*pud);
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_1G)) {
-- 
2.22.0


