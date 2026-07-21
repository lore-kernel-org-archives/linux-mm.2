Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC48BC44537
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914CD6B00BA; Tue, 21 Jul 2026 12:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5A96B00BC; Tue, 21 Jul 2026 12:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4AD6B00BD; Tue, 21 Jul 2026 12:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5636B00BA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:25:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD69C80214
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:47 +0000 (UTC)
X-FDA: 85013309934.19.497F173
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2422212000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJK8pSoA;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxhCd9eCEjBgJJhCeRA2CyrrLQ39c+yshW1zqJ57eLQ=;
	b=FRFVG/I9bBNdETczvz1CO2S7pcwfAwCOhAwufJGzZ11LlEetNgc9tomcjd084FTY9VUdUW
	SN57cgGpV3aF8dbkgaOSDxNp8qDy1hfRSJI5A3OaerUHS+vLZ2RceC36rvr/XXEXFrG8S1
	rjfFf3p2M8sdJdMAYa+XKS5S5X5w9tI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651146;
	b=ulP8JisNYx+4dEacRcEYg9FE4VeGN5xmv5zlotpIkHKcFitNg1ZAboi4yHxFXPbvEGUokP
	Y1qqzjKg+lEmzeNhKtKOWQyPzECtGK2NOa3mhRqnh+95kxIDdi+E3M+lCg+Cf3++ivR5Rv
	LtBhfMfoxVc+jy9hvJXIoM7ko/KvcaY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJK8pSoA;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EDD94065C;
	Tue, 21 Jul 2026 16:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36A81F000E9;
	Tue, 21 Jul 2026 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651145;
	bh=ZxhCd9eCEjBgJJhCeRA2CyrrLQ39c+yshW1zqJ57eLQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AJK8pSoA+U81hrrPiZf3Q9Tb3HIzm92yIR8W1DG0ikMnk6uAV7OdgkMR7YjEGxSm9
	 RD4suD1pNjUF0c2rrXBqrQy4bp/rbU1Is/oX1bl87Wn38B+UlIvf/m2n+iOiyDgXq/
	 0kadO6UYVhOIu9t86F7A/hVRK+DaRDnRffiVsD8OnjdxiLD3hsjoSYanLb+qMvNdy9
	 A3QQwhvFXtLf6j57ifhFoy+i9N5yaEhAIQVePJ+RqGIx2Mo7zzGHl7Bwq7COcQbxeF
	 BHH6f6ASOrbJFvNpI8pJPhjR6qHVXi16w3VR4Ai0C0xh1jbY++Ugxpc3LtI141KJ9b
	 GIpvlDGA1Melw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:41 +0300
Subject: [PATCH RFC 18/18] loongarch: make set_direct_map_*_noflush
 actually noflush
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-18-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2422212000C
X-Stat-Signature: hczqi6xwo7zoj51bgg585hg44nr9d451
X-Rspam-User: 
X-HE-Tag: 1784651145-134443
X-HE-Meta: U2FsdGVkX1+UuK6YtTxuON7nhOV3AhawVdH5Y8R+dOgMoui6p0E294aN7D5aPNc06ye8M5b5ar8FeFmEtLQxgDf6nPzq2U5tSakSEreFdlsWqXO/rpKUrzuAh5lY1Cpz0mQEwhiqayrjo0QoIzm/G0TN9VMNfDgFj48B8oW3riXkvg+V8eQEwQWRt+y3rtm6Eoe8e7oTScfZvqWe4H+J5PH3n+LT0jiTzLGndxOalEEh2rnOtROpkiq4LlPWqLMLH097ed94uXPoRbSG+IJd5pPUNtws500WKLYILti49n7vZjnAM6vduR0gaaygoXsT5oyJlTtt5hJNwjF1g+aPTblo9306X3LyF0DMyGq3NT84OrM5yZH/FW/ur16bqeZl+PwMukYeA/qQvy+rEf5v83seBFmk8X8lL8mgkZPBHzpnyk4fl9ZJDDIp0cTHiQIdQyzK6mZmA5Ojq7QhEB1BWkqN12R3nZY2s4z42j+mLZ2mweO+gRRJ8VgwlYCqKro/LoM1KsSafv/XK6WLSGMgkUhzQIJ8Zt3cM1x3T14FGejMhozRqUGom/uRgwhIkxaZfk6V1YVsIV5t6zdSjsSvhFOrBQce1YrDRjKl0fzboghG8KDNp/SVxVihGE5aqZnyOblpdD5l1j+CjTCmuNuljwk5c40DgLfEeEcsiGQWh/z6sUZ406IQgoZhuC/iuO0eeJbOhycCJ48DtWlI7qKeLiZTuZUCMYIZvt/t1LRkyjaGVoj91hM9jlE7z2GuCH3x5BLVGMVUecXNZ/bQfjOHHvwoR0YG3gPH0IQgEYZce39HohS4nHqBcIvfdrHhnW6Dd5j/C35zerbHwrJQ+DeoKQfkPbsdHHqaVfaP1DLdPC5Ykh3/ViZlrOiw1mQ1RtS3JnRvQYoT+bilw6tuZNyCKLBLoDeIIqriHAlnzV+w7spPVEag9utTG7Wk+H256FbIQ0rQnWuWZ493Zdwi/Ts
 hvXj4sNW
 x00ZOH3x3BhVWbnCdk5xon+HO9nFZw7ddClPmrQ+hfWSzn7+YTj+Ujyk4NWKaEW9472YiSWcw+BOHvO+BlhmUDp1/nhvRS8CODjCqe2pd8eVosNO0e5iPR55CviBIAvUooQj73qm1lnzKWKmU8GR/ylWWpgafklRpCdXfrPLcBzjlZ2RdqMV9g0PkD+coEquOHwP5iRxTyWIjqZutqoa21D+Oh7WhBT8d0w0Mq9jJxL7mpR702k5Kn11I68siFwNYwm/EkTk3PsgfvInUtFy89FcobbaubSXe69mf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

loongarch versions of set_direct_memory_{default,invalid,valid}_noflush
call core CPA API (change_page_attr_set_clr()) that actually flush TLB
after the page table update.

This was also the case before the conversion of loongarch to use generic
CPA core, loongarch::__set_memory() always flushed TLBs, even when it
was called from _noflush API variants.

Switch the _noflush APIs to use __change_page_attr_set_clr() that does
not flush TLB unless there was an error or there was a split of higher
level page tables.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/loongarch/mm/pageattr.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index 4500769ccf6a..dbbd408bd3d5 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -134,40 +134,53 @@ bool kernel_page_present(struct page *page)
 int set_direct_map_default_noflush(struct page *page)
 {
 	unsigned long addr = (unsigned long)page_address(page);
+	struct cpa_data cpa = { .vaddr = &addr,
+				.pgd = NULL,
+				.numpages = 1,
+				.mask_set = PAGE_KERNEL,
+				.mask_clr = __pgprot(0),
+				.flags = CPA_NO_CHECK_ALIAS };
 
 	if (addr < vm_map_base)
 		return 0;
 
-	return change_page_attr_set_clr(&addr, 1, PAGE_KERNEL,
-					__pgprot(0), 0, 0, NULL);
+	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 int set_direct_map_invalid_noflush(struct page *page)
 {
 	unsigned long addr = (unsigned long)page_address(page);
+	struct cpa_data cpa = { .vaddr = &addr,
+				.pgd = NULL,
+				.numpages = 1,
+				.mask_set = __pgprot(0),
+				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_VALID),
+				.flags = CPA_NO_CHECK_ALIAS };
 
 	if (addr < vm_map_base)
 		return 0;
 
-	return change_page_attr_clear(&addr, 1,
-				      __pgprot(_PAGE_PRESENT | _PAGE_VALID), 0);
+	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 {
 	unsigned long addr = (unsigned long)page_address(page);
-	pgprot_t set, clear;
+	struct cpa_data cpa = { .vaddr = &addr,
+				.pgd = NULL,
+				.numpages = nr,
+				.flags = CPA_NO_CHECK_ALIAS };
 
 	if (addr < vm_map_base)
 		return 0;
 
 	if (valid) {
-		set = PAGE_KERNEL;
-		clear = __pgprot(0);
+		cpa.mask_set = PAGE_KERNEL;
+		cpa.mask_clr = __pgprot(0);
 	} else {
-		set = __pgprot(0);
-		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
+		cpa.mask_set = __pgprot(0);
+		cpa.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
 	}
 
-	return change_page_attr_set_clr(&addr, nr, set, clear, 0, 0, NULL);
+	return __change_page_attr_set_clr(&cpa, 1);
 }

-- 
2.53.0


