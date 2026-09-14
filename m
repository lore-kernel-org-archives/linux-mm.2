Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE8FEC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1376B009E; Mon, 14 Sep 2026 09:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672A06B009F; Mon, 14 Sep 2026 09:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588936B00A0; Mon, 14 Sep 2026 09:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6146B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:52:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA9261C0669
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:25 +0000 (UTC)
X-FDA: 85212507450.26.C6C14B6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id F27FB160004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l1MXFaUt;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nnqHTFFg7SjKjtGZVIXxU+lBLQPtRSbaf8oHL0yupPo=;
	b=f8K1DTDogcixcjoHeRAEQeseZ5s03ksdVhOUaifGYLtR3OHZ5sRnzAgOKdNbjWxdHPzPHy
	f449//zXSUnKpiaeV30q05MnyD8C6Ic2ZdfprRN6uU/p5eGlLTtlFQhiY5jQam/yH7Z/D9
	UQIEmtJp3XciIWMA0fllIHTvBQjaFeU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l1MXFaUt;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393944;
	b=ui5j4wJDIyVbdpRYfDvf0Dtvbci+Dbc9YNnENnnwmzhHPM4W2XcoKk/tXEG1LBnFJwAdsQ
	1linVJMsCRSS7TKPdOV4/5lr5dd8jQ/T67Q5N9HQxPUjT2qrXCP2uRTxGYTRWd/as3SMDQ
	WLu0USRxamKu0DPfmExn1yeiVzGh/hc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60C4B1576;
	Mon, 14 Sep 2026 06:52:19 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1F373F882;
	Mon, 14 Sep 2026 06:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393943; bh=M/GSINSwm6+Et2eyJmmD/tFqPTuI/A1b5T1YgKWiL9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=l1MXFaUtsScvaXSmDpLzKQ0x5H2a0xG7fjpv0PnXJZhfGml/cb2/NWB6wiGm/2m/W
	 HbtYIf5YprgsmmREN4DpnnSbzRTpl0G8iRLXXwXoBcCYEWBUBfax0si2I2ttMOWuCI
	 JgPXqqlaUmx6uMk6xS6A4rRtyvVaJNKnNht1RaJ0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:35 +0100
Subject: [PATCH 5/6] arm64: use HW PTE accessors in early map_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-5-bb53b663e396@arm.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: 1uko7afzt4ux9fyhxn8nmwxwkumwddqe
X-Rspamd-Queue-Id: F27FB160004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789393943-223101
X-HE-Meta: U2FsdGVkX1/XhHKGloolIH/s18VK641pSr3Y0XFeZNDQPPSFkiajsDLExZjMeOSIE+MW27y+ckXOYukUSRomko760ZbOPM3M6t7cKEgoQuLGF84/4//kPp/17USgwrCqEcgd63lnn+8zRla/2an4FzjAkeJS2KthzLtsoXHkr3/C3wCh56rRLCOsOOw1+F5LnETyR+bIaTasqaW14HZHQsLgz6OJH6cr+rjvgdtRR14pbcv9VMx4Y0VaXb+inG2Tjo4JUYWgcpUNkd6lP6+SkBRR02dxh+/95DVNtiby8TijuorK+CrqypZGqzavHZawGDZGH6wPBHqqN2JXQhwmq43Q4IuPYthJNixAAqC03Cm/hPjZxDj1y8XFdnELlgx735b374IuOCdTZJ8FTlSQlLoNg4BU06as4qojovV8RnFtha3GRU7CW5a5lMVDH2UpnHSoIMP3RezmtWKou7xZS+oMwbK9A44XK3GidKcMPcjY9LHQ4iU2g/suFk51C1+bN19zyTQ5/LX92joKRshEENPIVI7QRA2oU2KwLUQwarq2BIhMHw4LtogKOLGUEI1+zmij6Mh/KAdTkzYYhEqhbyfoXB1z1jaJDHBk8HCDkhagFxNk+rhJHvqzo0WHzbOcc4cspmGqk/7PGlO5HQYbY8iKqVJifl+to8m6ms7juGXJVOOEnJKhzVRsyPIeJFd2pLxrSaDx9XJsOAmQWupWIj8kpKJZeNNSvZtc4sei3doL9IzMDYtYXeFrKx7rKXUCn0PWCxDPuEh+8m0gMZQWesNYqCyBlcxQ9yK7GaomcvZWYVB4oUOQXRoz1OcAGn6qO1g76O55V7L32fOw/U7dHUTFQfN4IGgV1g8mAc3L65WaIsXZc0pqYInw4e6ZzU1Nb9YKyC8qdTBjrH9fjXmeDnLSA7HDR9XRfngmdRt968H0krCMq6s9VrJTgta5UQ72TYjrJwnaYqciM3uL8rH
 zoCEsVLF
 +i1LFU7M2xsvrEND6YndvTRmRuufTTEB4r3yvtqeHBp2TCR2+RsOI3YgSzqkWOjPHviFQ1l/LW6H4Jc/6EgTvbnPjxFoK+CdkOPyhGqRG2uEJI9xBBkr2zc7te02TSFPnMaf5tbqVeVZMVpW1jg4OcCAKPPTW5p6KfBlqK/vm9wEbb8d9IzIxiEk9ZYxvCMv3C2gfTXN6lNH+sa8fnYuubrOlauCuhM6hGIvHlVXBw0qyACuJTfstw1TnCD77gp6VFIOgBZh+pN3FQzcDJRpCJM2N1551Hwe93GtOVtVhhhEzVreN9sTW1DStJsKUWiNPiNeh4xI6n9o5OjEDBpaQcU+6Rdm3Mctr2ExIFSSBa5GT89BYZtpcLy/LSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

map_range() uses HW PTE pointers to build early translation tables at
each level. Directly testing, decoding, or assigning *tbl treats an
HW PTE as a SW PTE value, which requires explicit conversion once
hw_pte_t becomes distinct.

Use __ptep_get() to load a SW PTE value for the empty-entry check and
child-table address, and __set_pte_nosync() to convert SW PTE values to
HW PTEs on stores. The no-sync helper performs WRITE_ONCE() without
adding the completion barriers used by __set_pte().

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/kernel/pi/map_range.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/pi/map_range.c b/arch/arm64/kernel/pi/map_range.c
index 94f06da76e333..9c4c8060c5df4 100644
--- a/arch/arm64/kernel/pi/map_range.c
+++ b/arch/arm64/kernel/pi/map_range.c
@@ -51,19 +51,21 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
 
 	while (start < end) {
 		u64 next = min((start | lmask) + 1, PAGE_ALIGN(end));
+		pte_t entry = __ptep_get(tbl);
 
 		if (level < 2 || (level == 2 && (start | next | pa) & lmask)) {
 			/*
 			 * This chunk needs a finer grained mapping. Create a
 			 * table mapping if necessary and recurse.
 			 */
-			if (pte_none(*tbl)) {
-				*tbl = __pte(__phys_to_pte_val(*pte) |
+			if (pte_none(entry)) {
+				entry = __pte(__phys_to_pte_val(*pte) |
 					     PMD_TYPE_TABLE | PMD_TABLE_UXN);
-				*pte += PTRS_PER_PTE * sizeof(pte_t);
+				__set_pte_nosync(tbl, entry);
+				*pte += PTRS_PER_PTE * sizeof(hw_pte_t);
 			}
 			map_range(pte, start, next, pa, prot, level + 1,
-				  (hw_pte_t *)(__pte_to_phys(*tbl) + va_offset),
+				  (hw_pte_t *)(__pte_to_phys(entry) + va_offset),
 				  may_use_cont, va_offset);
 		} else {
 			/*
@@ -81,7 +83,8 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
 				protval &= ~PTE_CONT;
 
 			/* Put down a block or page mapping */
-			*tbl = __pte(__phys_to_pte_val(pa) | protval);
+			entry = __pte(__phys_to_pte_val(pa) | protval);
+			__set_pte_nosync(tbl, entry);
 		}
 		pa += next - start;
 		start = next;

-- 
2.47.3


