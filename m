Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B11C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833EE6B00D1; Wed, 22 Jul 2026 11:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B056B00D3; Wed, 22 Jul 2026 11:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA7E6B00D4; Wed, 22 Jul 2026 11:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3CA6B00D1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E389B1401E3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:08 +0000 (UTC)
X-FDA: 85016803536.15.DE6FB21
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2F617C000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=f6SmQojq;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSQKp0u4WCyMjI7rDFyHG0HCA2/rWwWJg9VdMF576lU=;
	b=QRBXdMI9KOG0vFN7xmYypN7fgZuL8GoVekimEE2u1oOEtsywac0LMBHo9kfPHmj76AmWPe
	lIMTzwcXd2KA1aGdKeMU9SvQlzJ/iUnfjuV1lcqIRnIYCEW2wb80hN1/igG7aAbOvfmDfe
	Q7EkRkaEWAJej/ip9rA3rRTH7uZTfxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734327;
	b=24y4NXB2MOTGZB1zeeO2+Cq1gXY7JRGXXPdZHPwJ7tQNSUvkQ8n9/tu04m8ZUpx6gh0GmT
	hWq2CJE68J+5m03r5jGz4fkLrIQKAm0j+z15H0JEImBlVM/q3AxLwxZit8mr+KMYEhhtKz
	60j1moKiSXQoVtVxPrhlKV2tdhhKcc0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=f6SmQojq;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B4C4168F;
	Wed, 22 Jul 2026 08:32:02 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 749C13F66F;
	Wed, 22 Jul 2026 08:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734326; bh=wmJtmiPytl3HyZyDqwtjxdRsUOFgZxGgVlONXYHiJqA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f6SmQojqGR7brRiEZavDDkmTWbw75QsPyhFd4pAG4O5+6Ju2I8ri3QCdZWN2rXkyN
	 DCTNnGSdIhw7z2ehWnVgZaQ2zE6WyM6dw1A5orUEziWCCg2RkmxAjlcAHyBQDq35NO
	 soM9uXuZ1k30ziofw8vM4Eb1IcYS6m8WnZbnkIfw=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:20 +0100
Subject: [PATCH RFC v2 12/20] x86: mm: define pudp_set_access_flags() when
 CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is enabled only.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-12-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1039; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=wmJtmiPytl3HyZyDqwtjxdRsUOFgZxGgVlONXYHiJqA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIVfJAQ0bxNGFW5YSiAzNm7IwBxCLOqc80gj
 i7axQ/7jfKJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiFQAKCRBt1cPRWsUx
 M8CyC/9q4ATnNzBRhzDxRuqLX64PSTzrSfdIPjo8WlRytut8ZrhHFMfgcsu1OWhST0JPWq+r22v
 zJ6g8PXhJN5GkfC/aA5WFgbNDhiJO9mfOY4WJaWFSoB5qLe4rVE8KL1nSOeHn4he5thhorlk+FZ
 o1l4TLcbjqnpdwBpnKy9yw8hjMCo1D5TlY7XD6cf4nX6YeSoQzJK3j77HvuaM/zd+70XJcuZkfL
 5Oyds34g83k0HLkkrjLBNu0DPunfEw8czmxodjY9Gvre/8CMOBUGGPSoNrCzTLjf/vjX5PWo3Rc
 oIGj8lh9egTAe+ruiexvMFVgMd62WeL/DvqiV/9KgLIluHYqsG7i7w9KvNOtjtUQ0XjkMtGcuOO
 nZVxKCU95sKFoKLDo5eYIJEZMubYpNqePB4xQQofkIs0yKScpMw20O2n7w64nCyFnn7uV86yb9N
 uOyUjDcvEWXUFQO0OPQ0pIwg21NrgYutufdstDwZ9vqKWkJclvbzJ9HKcNZlfdJcGaxsM=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F617C000D
X-Stat-Signature: khoxk8s8thbu4xaohbd3g334dkwy4qcp
X-Rspam-User: 
X-HE-Tag: 1784734326-481572
X-HE-Meta: U2FsdGVkX19CeejCLMu5+MmTE6ITjQunSJ1tCrbquApbJE4QJJWZDpmuYVIYLVTOnd5Pow4lxChM69OhKStMxuuWN8+xo/IbytS5mNq+K4hxxJyLlsq9OyVWKytmMMdEAESJCK6ZjhBLznFvtTH17+mfOAdBYO7XHyzxPxiErryev3n5hOkfuuCsK1rOtao7LCFPuyq8eXYDxf/wjauS3A8K7/Fe9iuZkt/B0U1H6PaXCmDn78SxoJ2u5vTF7X2IcyFBJXznbqwHR9KBN8K2E/VEf61KV4WYZJ8lNlj937kgHSJSzXENk7yw54QTLBjAeTf3kFDf7PaPB01cHklWII3hGWG7PO0E9xhVNVffMWqmfnoEiO/K9mqnoe7Oi14bBM6MDgMR1kB81eZpKx+qBqeLbkPLHprHeEj4BcanA3XiN7FRBiHk3E5B/sSoKHoJzs8bJVHEHqZOOcOzTSPw2Ev1QQ1csUVy7SV4h+qVRqFxdRBYidetOR4iXZAli1b+l0jyVlO907hNE3QO31ZrSyKrdQ54LhzbQCz5s9VFuP3RoHd7R9O2aclGvzXlUPAC/zfn5U70ikK4AoGKJF2Ees4qo50KdLRG/gYCuDRq9WoN7+DHYBK/s576BBvK2CJyyysqqQ8gQxA2NNAlmYDeoD0mSXrpxtW0S41HKBgVjAyjHA22zoJh3xqJS3vjgl+YODrAwCEyZbb10jnnPFMkhS8yVTs5oriNmtGvoZ7ml7tciOqzp0GwCa/81YtfabwIgWKE64hORi005MPMgmiH3+s5nEUYQDW05w4vlzV/ivshnq5zSmKdO6PKKZYDPxtdTrJrN9/p2RDJKlfK31q2iHVpnSRp3u7FZzpvack/e4WNXH+/P3/NCJuncMukpXl8sw6lYoe6WqdYojQpe84RWfeKPxjjDZPa4ETldafMNZafbOZEqa3rR7G1S65u0OdbDmoO2npNYRh/ReB70k4
 YLnvi5kT
 9PocWB4qerE56QZLQ9GxYzQeHsL6H8rSgwGFZQ/LqzuIFcZeed3vcKC97n7M24EDAJvsrGSlIXmlDcujCHLbsGThhP/wHrld/HyAKyPshOXW3QQa9cPPurmRBCVwC/qlepTgq3ce0WNFqPqvqPu05K6UxepAcnO3xir4EpnJrqOiy4F94jXbIAM9RIRiFWs5sWzoBxUCY3l+8bLBxJXUbziOS5rNQAe/jJszej9BozsxC+dqUybpHRHYydM8fMhEQ8t+ZQ8NDaMY9oXIdraGl98/nI9mF396b0c88JmdjUu8rgNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pudp_set_access_flags() is not used when
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is disabled.

Therefore, define pudp_set_access_flags() only when
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is enabled.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index f32facdb3035..edad847a2ecd 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -411,6 +411,7 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
 	return changed;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 			  pud_t *pudp, pud_t entry, int dirty)
 {
@@ -430,6 +431,7 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 
 	return changed;
 }
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #endif
 
 bool ptep_test_and_clear_young(struct vm_area_struct *vma,

-- 
2.43.0


