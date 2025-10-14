Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 858E2CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39A18E00E6; Tue, 14 Oct 2025 07:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10C18E000D; Tue, 14 Oct 2025 07:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D270E8E00E6; Tue, 14 Oct 2025 07:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C28C88E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:23:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 088F24762D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:23:10 +0000 (UTC)
X-FDA: 83996483340.01.4A56EED
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3534A140003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:23:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j1LOvV2f;
	spf=pass (imf23.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760440988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3IQr6PZDQBToACp5mh6bdKZxuflv1r2zt3g5MFeHMik=;
	b=wSSDZjxGWykncurVQCXEOtZG+gMbPWtbB+6KlV7KL8gBZFE28BOKJq5WdIrC9W4Q4bBeJj
	XQ+sTzkNvIQpkdSodylaTBM5I9hwcXB+zd+ywoarS7bFX9rMs0423Mg51Vxe/buOBqzRh3
	tiuJ+c9stD3v99RAGLkFMYw+/TDMwTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760440988; a=rsa-sha256;
	cv=none;
	b=mw5ylZur66SGwk+kC7USVpN2PRHVAnJKmY4pCYkmAlKTs/RljXlYq71Dj7uTcRmjDyfzRn
	/pvwOBxBCCMfifqfCN3cTjgyLVM1meVM3lvEFv647cgUn+3SjbIZyUNH1qUiVvPeb7yHqL
	lDT6S9B1tNFWM+Kg7B3gCb8oiYhq9rw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j1LOvV2f;
	spf=pass (imf23.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b593def09e3so3506319a12.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760440987; x=1761045787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3IQr6PZDQBToACp5mh6bdKZxuflv1r2zt3g5MFeHMik=;
        b=j1LOvV2fBPZRXUMab9BYNGnJttz9nUtxjvteVXCJ/eUdhyyX2UgOegUTJ72gwwvOXl
         NyW1NEhtiICzCVC2vivSC0TD2wkWixqikxhl3TZ6uGAhiZ8VYJ2sG3mqx64ViynuZYLQ
         ZO7ajaZGrWmHKO8LE2wop8VkmeH9uy9m5b3sCSIcgvfSb0xeD0K8cME2WldOxiu1sjrf
         FcqxotuSK/zwpsp6IMOtqZSYPdl/fkADVMegqpfQDPR+cHvGptiHk6r6aDwglXNyXqGO
         ht8IugmbbVZVQzTeLu+w2J5PAT7MXDFBdXq6iGZlQXRUF6prLmrmSkgfuosZLD1MP1yT
         +0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760440987; x=1761045787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3IQr6PZDQBToACp5mh6bdKZxuflv1r2zt3g5MFeHMik=;
        b=VTD8JHECrF7eQd0LNOJVV3oFFnbPO0sUB4IGd3oxUN/3qTSNkP4UiIxEo7X6JJg4Qs
         Q+4sND0lcwJsykHdsLl9BSMCVyiboSP6WUOZ52LGG1J+CNX7gGpb2eh+cadHYGHLp+45
         3IIvmgL1Oaxs0uHSWfuk3rdXmPGQq5ExIgsaGxnjgzDqEvksElGN4EAGkZ414jtYP8hr
         gSEA5lHF+cy+q4kApmXb5bxm4OLdSlrb9fklP11Ecv5E28FDW9RpCpAZr/vkeZHfMKVK
         mIzXTPG0HJsjaBDMOB3RxI+SPhXLYniP6X9bmSETLbLktS8Td1UiSxBWfOeHWH4jNm7x
         Xy5g==
X-Gm-Message-State: AOJu0YxWx2myr5hioVsdR/tq2wpV8sBFq5ZBEaqZuVMIED49ZKI04fLk
	wl2preTpbMfSS0ClSmtL9O3hpbGBYR/W2CsssnVxUTuOGuHH/RoJO2C7
X-Gm-Gg: ASbGncuufhjs9nyAvI1pi9cEsoaS9BHoCU30rEANBZ2dHLGhp0v4/gKhY8+9WSX260k
	/TGNPQdIOL7y4a0RPRfC8dl+6p6pZ7lgKoEoG4A26JJbV2QJDXR9ChgW6ryCvEuqtVMFOalZbva
	O+z47Cp14e8aLOUpPwtI1NvMIEwUi7L1B2+Qmbqogux4HReAd4l59O5jyvD83+iYjs4rGYu50UV
	+JFQJ0xEnKnhSJi4+E0VnQTChsGVKBGZ753uiH5QywK1k2ODFCeDQtQD8Z4QYY4qHTPeMsugFx/
	LhVL9Z+LMYrlH89zMa+azw+uoEOhTJqesZ8BkBuiUgv0rgU4BnktqBH/rm+5AcYIyEwaJRd0wCq
	Ulz84vb7HFLNQKaxmGfG+dv4JGpWxtZzcsq6JkT4B9Advtsp2Ht9GVhUv1PUWQsxNXipD6PINV0
	MZf67tUVVTwbOu9w==
X-Google-Smtp-Source: AGHT+IGa0oqy5yfoyAy3K3ez2PQeHy+vgY4rEknyAjWpihPiUnLUUYcVsJVMT12j0p04g7Su/853Rw==
X-Received: by 2002:a17:903:286:b0:276:842a:f9a7 with SMTP id d9443c01a7336-290273a1725mr289815555ad.57.1760440986849;
        Tue, 14 Oct 2025 04:23:06 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:389d:b33d:a221:52bf:8d99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034e18557sm161986165ad.39.2025.10.14.04.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 04:23:06 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org,
	broonie@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>
Subject: [PATCH v7] hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
Date: Tue, 14 Oct 2025 16:52:56 +0530
Message-Id: <20251014112256.18793-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: ab9dukbg3ugc4xbsc11x4p4a6woqre6w
X-Rspam-User: 
X-Rspamd-Queue-Id: 3534A140003
X-HE-Tag: 1760440988-520939
X-HE-Meta: U2FsdGVkX18bLUq91mihJQ2i2jL1T+fESmwq6STz/OY7W7wp82Q/QX8whD8aGdyzMLeTJhdoqsYGw1MfY0N6tForFiDuOXJeHU9oL+52x+MjUDUK98MLVj3KFl1BnEar4UDk4YnZDim4F8cLJ+GHgplIz/dHU8qXbJDorfKrATtnluWz4YcwnaL4F7e3nfIda0AFDjMrNCeBkx/1WdDjZx8oFhfLK8wAlgJUMc+v907VI1KxCuP33m1V+iaDXpOSo6Ha7tb+PWsqh2ZPcl8r493wKNXiIhsZuJhmkIF5Pn0EhitWGbdwNoEKWg30HoexmqeQeHhQUvyKp2LpRPC1rF4E4RpSPL8DJQBh5G3Dp3M0+2+0O7Q+v/adaBpIdcxGqVliRqzm0i/+96ajX8/cjQJCDVuyJ0B4tx7+PS1PqOlLBZZeLljxvuyDbFrAacGp4YZ0SH9m8zeM/Z7KVDCIeRh34c/t/QHrhqwxBs+Lz0ukbPFjrD6ERuXRsNpI8SBhhbdK1ISsAM1B6vbicx2/9yvCEp8fastwJCj2aEey5qZx/V1Pz5aZzPGKQ9JpIzteaNRfv7eY3wx3qSj7j2gFJMbp1mBrv4fcNAGZrKfFHBSAPKcSrvod7ftxEmgnVmCwpezFTvEP1BL8uJcnxbKw8ruuWMHV8aeO9W1NJeFaTWgBiPjrCaVTdd3OjhSUnvKdWrTYx3S0yVETcbfFePz8KJIS/wQ2vr2N3l/mUh8aRPj4kJzavX5ro/L23+D+64DQye8Q+hu1F3NGB6rBD/+f9KspYWkf7/XyQW5nC8Oe5aHzFO6kgcW+hFBbXVeRKIBvI2qmLoUycdNFQd+bDck/pD0bLqGpxYntXrSJPEmd1kdOb4Nd4e+nM/KthMqPPZwnkGD5Cv7z63MDtfHwM3Gjs4hmzlgl7VB1hfa5ZjJnOPiIko03Rb0x540jVH7MMsLg9Ymlbnnqj85YANOVuKJ
 Y58acH/B
 3KMqfYpD9bdbEM15r0qi65OW4YiAICkj2sQi34yNmCs8HuBmU8zKwPa3u0jOoxF8yJRhC2BsMFK4uLfIfgbhj+DJKsyr3kr6zYzgFD5jornza02XguLLsfKcHZvFl6SkzkZ72i5OqKksrv6h6uLxInlNjObcwXn0oYE0PqQ27I/+KnETH4cr1OI9+rqxjC7Kccm7ukokBTZqk5CqiwlL5HQg4GUdZFqRTLLxeT0oMRmX/7d9WiAwTLJ2HslaE6V2KU1NB6djXUYmxDtF8mkQLOrCtyb9TwCA7XWu2Ix12/0ZXuBcCblFWx/b0VjyldA15G2UacPfdT23bzC39HjDIPr1n5JPCV3/to6MZhaNhzLaCfgQkJcvFGMSquEgGwzVFbdHCUfg4sM9ZxjQ3P84IZuESVgPlU7FWBSsYi0IgFm4I4IFHQwkHVEXfqoWryFyZc3C5cejjLg188f+10XnWBgVmJJaoAh4lcNyPLcGx8kTuR6G6qTIa2Jko8WEjDJfgI5gfIETCjnM0n/BLGN0bPLH59uKtllxN8otG5+KheQ3XDracTNs/qGKkSRyayvbiLeneji0FOt981YrVquJEEAikZcJmCtlQ5omLZWj5piWEuT44o5VNy+Hkr7ehxlR1h/FhAPIvyv13dNKS5zvkDaoTBHqAoWMH+XcslH2HDy3AmVqrHxLcY3wW0/aZI16QD4+UHIQ8dMtjPROwxatVE320OQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When hugetlb_vmdelete_list() processes VMAs during truncate operations,
it may encounter VMAs where huge_pmd_unshare() is called without the
required shareable lock. This triggers an assertion failure in
hugetlb_vma_assert_locked().

The previous fix in commit dd83609b8898 ("hugetlbfs: skip VMAs without
shareable locks in hugetlb_vmdelete_list") skipped entire VMAs without
shareable locks to avoid the assertion. However, this prevented pages
from being unmapped and freed, causing a regression in fallocate(PUNCH_HOLE)
operations where pages were not freed immediately, as reported by Mark Brown.

Instead of checking locks in the caller or skipping VMAs, move the lock
assertions in huge_pmd_unshare() to after the early return checks. The
assertions are only needed when actual PMD unsharing work will be performed.
If the function returns early because sz != PMD_SIZE or the PMD is not
shared, no locks are required and assertions should not fire.

This is cleaner than previous approaches because it keeps all the logic
within huge_pmd_unshare() itself, while still allowing page unmapping and
freeing to proceed for all VMAs.

Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Link: https://lore.kernel.org/mm-commits/20250925203504.7BE02C4CEF7@smtp.kernel.org/ [v1]
Link: https://lore.kernel.org/mm-commits/20250928185232.BEDB6C4CEF0@smtp.kernel.org/ [v2]
Link: https://lore.kernel.org/linux-mm/20251003174553.3078839-1-kartikey406@gmail.com/ [v3]
Link: https://lore.kernel.org/linux-mm/20251008052759.469714-1-kartikey406@gmail.com/ [v4]
Link: https://lore.kernel.org/linux-mm/CADhLXY72yEVDjXWfxBUXfXhNfb8MWqwJmcb1daEHmDeFW+DRGw@mail.gmail.com/ [v5]
Link: https://lore.kernel.org/linux-mm/e6bb05f7-8f05-409f-9d87-2d25f66942a9@redhat.com/ [v6]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v7:
- Rebased on mm/mm-stable per David's request
- Move lock assertions after early returns in huge_pmd_unshare()

Changes in v6:
- Remove __vma_shareable_lock() check from __unmap_hugepage_range()
- Move lock assertions after early returns in huge_pmd_unshare()

Changes in v5:
- Incomplete: only moved assertions, forgot to remove v4 check

Changes in v4:
- Check __vma_shareable_lock() in __unmap_hugepage_range() before calling
  huge_pmd_unshare() per Oscar's suggestion

Changes in v3:
- Add ZAP_FLAG_NO_UNSHARE to skip only PMD unsharing

Changes in v2:
- Skip entire VMAs without shareable locks (caused PUNCH_HOLE regression)

Changes in v1:
- Initial fix attempt
---
 mm/hugetlb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 795ee393eac0..0455119716ec 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7614,13 +7614,12 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	pud_t *pud = pud_offset(p4d, addr);
 
-	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
-	hugetlb_vma_assert_locked(vma);
 	if (sz != PMD_SIZE)
 		return 0;
 	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
 		return 0;
-
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	hugetlb_vma_assert_locked(vma);
 	pud_clear(pud);
 	/*
 	 * Once our caller drops the rmap lock, some other process might be
-- 
2.34.1


