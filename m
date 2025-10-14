Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06490CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348B18E009B; Mon, 13 Oct 2025 23:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9258E0007; Mon, 13 Oct 2025 23:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7C08E009B; Mon, 13 Oct 2025 23:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 094178E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:57:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6390F47299
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:57:41 +0000 (UTC)
X-FDA: 83995360722.29.1A57B49
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9AA5A20008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:57:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aBQwZozv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760414259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2Z2NlKgP/sNpQxsAzBMmC/fbOmtwwCUWX3Npz5SEPkc=;
	b=wg8Al+UGHh4WC/pVj9Q8bN8IZcTA0oBvZPaTE9juXHXkuftQrn5Onmp9nD5W0doWhiGGZ8
	DLw8hEWZqtSlLZu1F9Bfpyr5PrLGMznNW1UHJMHxQ3uf9jYqQZysYaB6o2RtjpoaEk+jHr
	yHiXhIRjGj0qVOVsp5HwleCRc0nuJRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760414259; a=rsa-sha256;
	cv=none;
	b=j8MADOyAqjp0KHA2rpAtI2o6cuh38S61czGSIiaEFmiKgcDH0Ouz5Di+9fb2tUP4ClzM1M
	1aKDD+xKGHOojKxcBTBgGWNXAbK10whAr8pLy5yOEBBh3laLa5oy8fsLtmH5Cw/iii+uNL
	wJ3MdN4X7dFE438EhVIGXhE/8pLrQI4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aBQwZozv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-796f9a8a088so4655112b3a.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760414258; x=1761019058; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2Z2NlKgP/sNpQxsAzBMmC/fbOmtwwCUWX3Npz5SEPkc=;
        b=aBQwZozvzr7CfAufQgNaJC2hc0PtqbaHkgFSKWRxyGWuQWveC6GIKNL3Mc/Z8FZEJO
         dyE41t8wfqbiyVkJOJ0RN8bee+BhwS4sE/JQB2rgBIL5ijKt/hjKIeUQ7iqshpyyKsty
         nEBhzIzg7h9W5x4kwrbuPwzEOXyKogxcgvRmDFd5YXd4/BBjpBfaIHabMKM6v9aKRasD
         i+lqNlbFwn2k9/OT2JoBuqlcfC8fJFUF0JAnFjjpPLQaFmQabQj6nTX3GLINDrx6xfX5
         ZfD/JkcDrjv83L6TXB3iX8VGuClhutAjZa9tuUaj9Kui9slGpNgInHPLTn0uotZU4Ipo
         q3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760414258; x=1761019058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Z2NlKgP/sNpQxsAzBMmC/fbOmtwwCUWX3Npz5SEPkc=;
        b=VEdJ3fC3r+GEC2dmQ5sheraGLlkTrR1e+NaXQlFJUoEdQa1LV8Bx+OWg0GnTGlEhYE
         smDrAmLHhQlrE+caSbGjrrkciEL+MBBvEKu7EgA3DrHnTTp/1F6DEYl1W7BHpsti6nZP
         lAgemMKeRwxuf4/xX2aao/nZw3SrXZ+MgmbAvKldEy5VpZcCzrKmLWn0RpUhF+7EUjGj
         s9NckawfaH0M2uqAQ+RAFJwqjUNvVIusP2sr4R1pDvvgf/wqjW7U2Mh+7aTvnS7bCB+V
         xJKGb4yc0ofzAonLQBby2rQxyMsUN+QvQrzELLNDIQjK+Y7Q7+aiu+prMygqWm4EHT0R
         ZGOQ==
X-Gm-Message-State: AOJu0Yxog4HADlcKI6ucYBY1k+uiILn5iADzTOpBsEBaAT5P1o0q/0f9
	S5626SgHIgOxenCK9Uv+qhAvndVJw4kPvfD/cGxWf0ko1QbNKw7GgLGp
X-Gm-Gg: ASbGnctLevkJcgvcfYk2ePE1/lgvV9we8pnSLPNLvh+xS0/L0fzOHQbfyH+L39CSPQu
	G+kYmDrnNslgN3Z8FiAhK3zBXKhtPbqs+pDfQIBeLHpHvExNJlxhaGouon6LgyooVd7KNbYIaFM
	oY5JOpZxyDnZ5dKA+h72m0emWgVQHUkpfOA7GB3tYa2ImitJ5Q5FFv4CxhJwtigyaW6OS76DoHx
	UjIk06PZRzyk/qhd3ViqC3Z2sgP1uikAct2AGMb2j5QQz21zy46kqnSpO2td2PxrloD5wj4xb+Q
	2nyhxu0kQl++p2arl0WC1J3umBqjoK1xupbrjdyHxuUhjjlTH8WaALX+caO2zDqDqKbJ1+mEUcY
	M5kIZG0w+/r61uz48uTaatzrPjMl0hs87J33KUhkxA+qhl+CWxkOnBurPgr+k5Uy3aGPOGPW7FS
	I9b8o=
X-Google-Smtp-Source: AGHT+IGtOgrE8fYCzjl+tEEVLvrBjJ8kfoQiIhkeUyl6gIYCX4G4EyjTz7imEmv/zdWusWGJdNBk5Q==
X-Received: by 2002:a05:6a00:8c5:b0:772:59d2:3a49 with SMTP id d2e1a72fcca58-79385518011mr30755301b3a.13.1760414258257;
        Mon, 13 Oct 2025 20:57:38 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:389d:c391:4ad4:fa2d:b790])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992dd85317sm13243178b3a.79.2025.10.13.20.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 20:57:37 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org,
	broonie@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: [PATCH v5] hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
Date: Tue, 14 Oct 2025 09:27:20 +0530
Message-Id: <20251014035720.346268-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: knqw5hup4jh7ewp4mazqtactye6dymzt
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AA5A20008
X-HE-Tag: 1760414259-886812
X-HE-Meta: U2FsdGVkX18SgAzrMAab4DW0N2WvDcl6PB910q1Ia2PN0vrRBf/pjM1O408PTA8TrAjgZDj8sNwIV0nWR6/Isbyy4FiElmFxljoC5KZCFLLFhhDDSGV673xwd4Jhj5qVuAPcHJJgG17a1khlXBpJSGX/VHyZL00bsjY+OtZ4eQF4VgWMJlLmXda8jInBUTzoSAaYSFi3bhC7BXOKCmLiwkGiiPV6WRObIEuysYlkbuqHBfheYbQSzq31w4fgOFkxQJrjG6ZMkSJhuhFTzBr08k2dq5XA/KDxdT6IQUT7Q4mVGzydK4lTmC1mltpi7VWR+3uP/L9yAaTY/R7acV81thzHiqyfcMAxnsDNbE+CgbGtdiRg9WnVTFIfGK3rwQCnxPXW+/ZTPEyOiDshNnoKydYKJYN6dHdV7AxIFayz01FJerX6UjuId1Ns3uluNT9OstCkVLTnbTMUtj2QrC/svz3bLNb2aUOXan12ZbyA5SUHjvWwp9uZwr+iQAEdZbIG0grbQcqcE/tMZVOCzxzsLuWF/6loowjEcHfPZqgNCQrZRkCLFVGDSO7/j0+oeeWy7YCix3qwONaHYhEvX0NYhPfGT5CrLqrpPWFIMjiCnePjbQkmoVDleo06njuGaGLYONjs/12VagXL3K6yrNxevgXCRotSzhC3bVwUylZqkxnihjswoL8THFYmDJPJsVx35Ur2Vra5Aco0snxZDhiMVU1Fs9XS4tlwEaFHZSFX2RWkEp2wWYyzBGvWjfAEmgrH7Tn66nefhp8UHRvBHkoEE3SXTOo62dWCyRcE0sjecd1Ira3cU/NXuUOFTEfHih4AQRIyKXnW8cL0kyISO4xqafAC/CHiPKm77f3n/0YUaMBuAYciTiJS+n2XuuKjvHegHonxjT6NOQxOIjBySkLthQRopl2WTPUwnZnNzIFRPqHNrGQGLC+SsVW0coo7Wti3VqpdvM+KWCZIkGOQRK6
 F7extE0T
 kaSzFeZvW4TFg4U/l+kKJsUFudolwDvjnEoerduX4EKJg0FZChhMndOzldnvB73dMojvepyi1HOYtxxtFqEbhoLDSObXUZnNmY8xafEjXcDzJKKVkcpHWDnBcU2DAogHM5X8RLsDiXszJQ5+oVJ7VwEtfS+4nVlAEZ4EobcsLocSDgoCAKlWxE6yD6K6q1BQjMTKUHnHZnPeYCPaFE/Q1gRAmggnWGtR3059/VjqH6WY47ajCDm9FzYXeCwDPplO/BeCZGHNYmS0JPN2ZlUn0X3csZaMgZ+SKfkifMc3icpRI5fMgYwMV3l2L1fbPQA21GKYkIrgsb3daIqdrNpFhnznj96Hj22LcTguXxOQjoM3GcTkkMyslvGkaonn79HtdG/Ml2oI/GEumAXjhGz2pVg/UUTsUtVB8sAmJZcjI1LO6ERs65Lajk5+d+jOqiEhcV1rJB14y5RSJIbQN09EdzheCCoAlFpOieCUM/MoyAsckRlKoQnHeO1nJcn5iLurCqga0MbEbG3GfybgWG6s2eXCYRztLpxgJ3yWCoFl2Vll14+CtcCSze8/m751L8dJJQ3lEROncM++15L+0dAcQbmT3PI5SUtE0y6sOx0SpVqu9G9CskDPnaiOHb3/dRuKn9hYHUcGLePUKe5Yvf1KW4L0dcEosheMnmfoQ0kfK44Oa4nqmg1aOYQQiYicfr2iftikxNmxi2St00qoR1OFZhHsZgA==
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
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v5:
- Move lock assertions after early return checks in huge_pmd_unshare()
  per David's suggestion - cleaner approach that keeps logic within the
  function itself
- Revert all previous approaches (VMA skipping, flag additions, caller checks)

Changes in v4:
- Check __vma_shareable_lock() in __unmap_hugepage_range() before calling
  huge_pmd_unshare() per Oscar's suggestion
- Remove ZAP_FLAG_NO_UNSHARE flag per David's feedback

Changes in v3:
- Add ZAP_FLAG_NO_UNSHARE to skip only PMD unsharing, not entire VMA

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


