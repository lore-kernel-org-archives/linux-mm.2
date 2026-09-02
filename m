Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915EDC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2276B00C7; Wed,  2 Sep 2026 07:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C99E6B00C8; Wed,  2 Sep 2026 07:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF6E6B00C9; Wed,  2 Sep 2026 07:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5005E6B00C7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:58:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B90911C0860
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:08 +0000 (UTC)
X-FDA: 85168673856.04.F43A90D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 007B21C0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Br0kvwiZ;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+TGgn602Em+uiCZ2yEPxwneC1yhH0OhJjma1frwYe4=;
	b=lrcrFQdP7UYuAvcHXiHtzrY9V5SX0qLEWlNSNb9KP1C2/XEZ8zuyV2xwdO7BB0LiK+2S8W
	6xKYhwUIWkKaXt5f6m+rZ4FWrd0lwoukZuLorAe8pQvyBQpRJo/AdDTDuOLwSnsgrMJC/J
	b+OHHGsc8coLTxFM+Zxsdlh54IR4KQQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350287;
	b=FANu2HZR3zTVY/YjlhU2rBQmN7YYcAMGgQzEIdDUsRpJ0nC+Gi8Wx37Yrzy9Q9fl7Stjk3
	KnLsxLarestZbZUQcLksI7uPpVY2Le1XdogdinmuvXgWmx2T0Dg5SzXBtet6psL8TKp8bI
	iBnTfWjhRzw0R5XPfo1iP10R7vogdcE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Br0kvwiZ;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 831ED1684;
	Wed,  2 Sep 2026 04:58:02 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09BE23F85F;
	Wed,  2 Sep 2026 04:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350286; bh=JAI8HuvMrB06U9pngwcLmVHYlvLOsBAW7o0q3zLItzs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Br0kvwiZKirBYwtP8GSbqaahPr9eXVJSF3G6/g+zhRfz9rudpPonCKSJx1zZiDP5I
	 seMnZ0FIMrBMphvLYpfrg+MO5sigrisjQEeqGAmO+6ELBvPgtEKno0usZoDWmbAedz
	 z1OTeZdg4q9ETpJggfEcDWTY/b5vPm9214of8Xyc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:14 +0100
Subject: [PATCH RFC v3 12/21] mm/pgtable: redefine PGTABLE_LEVEL enum with
 ascend order from PGD
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-12-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1223; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=JAI8HuvMrB06U9pngwcLmVHYlvLOsBAW7o0q3zLItzs=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7nq1z+UGkBh+k3plBTwHn84nfJGlTH4HLv6
 PSsOOGZ/OqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO5wAKCRBt1cPRWsUx
 M4WQC/4j5E65SCGx3a5/ZzEhrT7FR7As2mIMS9VAlDcEK/fUO+neWKP+3tAec53rUxb4zzYZKQr
 g3mrmjGqQfOQWFk0eMRy2UiUFM9sGnzM+aPCUjoMiPSlvR4ZloQz6B11DzS/1vcE9hCDnTfjvtK
 qVQP7mnCLKp6tqIu24k7YyT7/1M5TwLF9MckxKXher2kNgQyHoOU0A++ZAo8AnP5mdlzo5T2a0H
 yqfNYTL2jA0+vAPusTvh552PMoTvcNMpL10IwhehGblQh3b2mr3AWKiPaiII+C/tvF8CX1S0hYO
 Lsv/z7b/+GbqLVyVEZPDMeZ76r21qIJjSuSzlY3XmUdMaIXYuG5Zh2EeZh0142nK7VIzSEQXJdl
 1WqI52sg40psqB++3zm3uJk2vkt3ViK3XEvLCey+cs9cs3THb4NBf8ha4nuPMmOFiw6Bt6yHWOk
 PpTMxtIHG90CMyP8nQCuRgq1kKwGXaA+MSt7L4chgHdCIlEnjwejGwdNLXoe7Bqj4d0Sc=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 007B21C0005
X-Stat-Signature: y9wsp1gg11dn4b9wh4ftk5x6wa9p6g94
X-HE-Tag: 1788350286-554003
X-HE-Meta: U2FsdGVkX1/QRUaHF1FtL0f7aYb/ViyyFXnoP1cxugT0aHVRmm28IL9n7veoLoKKMLzD1bofeii6VgcgL50vnBc3fN2bTKpsdbQJ9Ktdp82xye2xrkqsePVvmwDchUIaYjxcHrb1Jv64MWgLAkvsfHOljipeqx/DLGnlqeQTRTaIDIPx4msSBTNJq6dRPldXNdgGGRqfflyJC47yTgeRxA2/h7b+eHNK7dCP/dk983yrG796o9l4sZMdT8VJTFREK8Z5CHFLz2x88TAhIqoEI0UidubCCCl6s0NSbN7f0SeaMlrW/CLc1PkhV8aF2y+OTymEThbfEwhfRNeQrj1FOOrm3IytjUkCA0OPESJq4fLv2awjj++1YiGRMwHgEX6mabB7mStkOSHo65LjlO63cT+I67Q1KILPCV8eBxkQ7GLUO0GqsS4vSBoya4CAhebmoC0PcsvDpmSKEa811G3bDMC4xGTbdKONSsqso5qBvdgUh1gU18B6l6njtGAzWyfQtamxDbJT7ZD+Ud6Rcpe2Futm13oQeycvtre4gTLleLz1JPWs5xn3iV9v2XBbSnfVJZSqWq5KIHynUJIDj/LHRpDwF3Z1Z2/mN3dzXqJipRkjrF5iErttynTx9E2Nymt+L2oQiUJylEvXkWVtiV/XE2CQMGieC4oNxtJcZDhEFvKyVqn3EsXI9t8pAWZDeWIhiExT08QbbP85T33/w9NvFKjRhyrcFmPAn08L0CWD5kRrrbikLYuWKXRrwyj7BB3DgGo47zG4sGsQTuZnbYDG2Is6zdPStKq7Ub5OVIB83f/pwFlNbZBCKiG0XIPumeZjW3+KaM66p6mTS5LblaUDroLPArAqGbQKj86yISSKuznVGtOy+0ZThGyUVUO0MfkBNc7BZW3hLE7FMNRlldV7w7OBbNatMTFb8gcxgFM0X//XNYPzKe60CCTfN7R4NlaMqGjUS33hVc+RT48vqGu
 GiWULdW4
 CZavHgOHvBC6t6heBPt/PdLb40rhqnH1Wt9ssjxtsO9uGmk+NxQsIEwvNIQZGZXqaDpAROvUbKF0v/Z00Pjhot8pXNqVgakymNFNwjbsx5bRDlscDteOTa8JYJfeAPExMBLBpoW2BMSfUReLidNvfCnalPU4x2ztAYkD1EaQpyDYCkIKui0tdNbDex0XtzCBpf/9qZsashmNb04kelWx32XXZyF2UhXAyBvIhxZjDZF4UDXsqIF47Txs4QlpIWFof8LXFGh+hvS1rrW/f1bHbE6Dp6Z8T77p7QkRCxvj90PGcPck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PGTABLE_LEVEL enum values appear to be ordered in the opposite direction
from their intended usage.

Intuitively, higher page table levels should have smaller enum values,
but PTE is currently assigned 0.

For consistency and cleanup, reverse the enum value ordering.

Since there is no current user relies on these numbers to be ascending from
PTE->PGD, so it can be changed to be ascending from PGD->PTE, in the
direction of the page table walk.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/linux/pgtable.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c..3186096a6e13 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2288,11 +2288,11 @@ static inline bool arch_has_pfn_modify_check(void)
 typedef unsigned int pgtbl_mod_mask;
 
 enum pgtable_level {
-	PGTABLE_LEVEL_PTE = 0,
-	PGTABLE_LEVEL_PMD,
-	PGTABLE_LEVEL_PUD,
+	PGTABLE_LEVEL_PGD = 0,
 	PGTABLE_LEVEL_P4D,
-	PGTABLE_LEVEL_PGD,
+	PGTABLE_LEVEL_PUD,
+	PGTABLE_LEVEL_PMD,
+	PGTABLE_LEVEL_PTE,
 };
 
 static inline const char *pgtable_level_to_str(enum pgtable_level level)

-- 
2.43.0


