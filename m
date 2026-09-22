Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A13C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A376B00AB; Tue, 22 Sep 2026 13:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AAAE6B00AD; Tue, 22 Sep 2026 13:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A7E6B00AB; Tue, 22 Sep 2026 13:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 529E06B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:33:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5E5DA044D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:11 +0000 (UTC)
X-FDA: 85242094182.01.F154C3A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0AAD310000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mNoQ9q5B;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790098390;
	b=n47j9eAvLkKEGa+OgNTg+xNUyumbC/juRazYz1LZDeGWUhUBzINpG6ulCOuWfLpQ70viDd
	Ei+CkJW/gv96CvnwCTmb3SkNmZDrO5f3mCdinLQex3zuhjMOqXnMZVr+w7tl4SifBgNc80
	ShhrX9F8tFqQeKr2bK/Auj/QghCN/2I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mNoQ9q5B;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YV43xe2l6HV1crSikFZkZsSOAepK1RGDdx6y7YuuxyE=;
	b=Hs+EqE7Nop2pf3vnShjNi9OgnNEXZqFhk6gbZBs66rZnbW5Mh84WBTXjDP6aKQdlvY6TeX
	jgjBWV6zzVxC7ZEqeh9rpONpprQJwv7+Dji7VsuspCtyYrDQyNF8IB+VpV1HWPXpnXCw8P
	vtZYd+NcAZjqCtyx1fUSiiZF3V9l0IA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85DBA1576;
	Tue, 22 Sep 2026 10:33:05 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EBCD3F86C;
	Tue, 22 Sep 2026 10:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098389; bh=lGoyQT/IUQtR3cNCOID4as8wOLQ/VDmkytsu/6BddYQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mNoQ9q5BtvoMd+Rw12q0kZB49nZuw7UiCE1KeciQ3TnFAZnWIjbD+UV3pSFN6VIrW
	 HiDynCz+zSRp1JmOxEnCoMWiBzqNZqS42/vU0/wJuCDlZ01zEtC5LxR2cFN0m6O57w
	 DIbzipLnMXJ/EX/qZe4oH777ESIeNsTvQu0X9Inw=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:32:00 +0100
Subject: [PATCH v2 5/6] arm64: use HW PTE accessors in early map_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-5-a3f1ddff0a8a@arm.com>
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
In-Reply-To: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
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
X-Rspamd-Server: rspam06
X-Stat-Signature: 1ojxzwkz7mhmnan3sca8n1xz7tz95ioc
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AAD310000C
X-HE-Tag: 1790098389-926379
X-HE-Meta: U2FsdGVkX1+kkRQsaBP9ZoU6uKwIrPMOO7dTi360bWRTY2s/25PlV3oF9LeECpWMpdaVrZLYC8abW7+L41EtFu7G36/zQqA7aQEqsPbtOXbvE3c75vpxzr8tFSnwXibNaPOYfGac3tIDjtM3mXmeoIwX7rh3f8WHwrZ2pjEI18Y5TXW9ovT3STzRpby+vVZr7kmuDyKaKXkRTTfjtYJeBNsD9e5tS9zz54YbXKZXy8Rmcniuo2dhRHIkELiOEHOYszXJYPnkZf2AjA4RLxNL4cMnHGFTN7ZKFhQJg/84BVpeBp/3adUDyhh0C3H5OKh8wxssX5P4TGM2OV9TTIym5VgwXlZhxCNLG02T7xgok9hweYUvRttEQd/RkXtsMe3R7HrV44HdtssIuZQlPao1of5zLp2Xq5dtLpV9iDLQVTIskOVVy6Noi/L71mTT3Bcw4zBMVDNQ95tDzuoluLi91VnnG88mQ9CbyUdk89Yziv95t07QSR4Frp9DaYTbn9Is/uJn6KyN4A98eZyHGFtomrewYpTSapECvVWK/xCs0Gsg4WTYLnCRxSGlvVddp9XrH0zJIm1m50C5dtAuLYvYUzIUKpWh3qeCmtuHwO4vJIPYWSXXZ2lPy+mzWTrm7Asr163VX9KMf8qC5nlIt/HVcGpv+AA50HGs2R2vCExdrLX3NDRZQaQ878KATPlpugCwJHCKL5baS4qZgVnYl7rqpgmpgVkB99TvnOQkLiYNa7K7fXBEDUuWuvhASJ5CvREBt4O1bLFqYdZVj3qkbZO4lTYl9TYqAAW8KaAyBzFIlT370p+JQc+DlcW49/RcN3B9B87ETniq+muYkcw1JTqt8O6wTXUelNSFrubbtP+TU23a07Ia05U77ddirHjG4B/z4U3WSMpZcQfZ8goVNJoUY/gGD4ueLGUxj9Rw5GhKl30IkqY25lsC9kon2Cl51liAIFmiwXRuqj+tThlucfr
 G3hyES/W
 amc4kjI9l+7Ez+3RCxC3VEUpmAtK20IQCfAlY5ECnyBONhSAlafQCvxzA3KQhkqRXCNkVRYVO+0P3GqHzrQ/KNJ5lBIX4zSWM4veg5976XMTdUKgW7V2F+s9NUFdazqMxs4stsc4/pz4u5N8wQExZt44r+xhrItKwWtaulxs61vKHFQ/nIjAB+NiqQKjpamu5PGHbDS0TWyqSyFgb1UQFvbioY6pFjrZDvTpgJ3W4a6OZIJQqucsXcQaS49YyXDX/8y/Lex1Zy4ntPprKXYwKGHIvPCNKKtYp9Tm69EzY9lJ/nsKSRSOC4AkryETDOq4FAqD+dis2iGAtvTATMaz+4zNkW/gEE1a9y2IQWzBJ6RupVFyMz65AebTkjg==
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

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
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


