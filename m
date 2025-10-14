Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790FACCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 05:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59218E00BC; Tue, 14 Oct 2025 01:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D330C8E0005; Tue, 14 Oct 2025 01:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DC18E00BC; Tue, 14 Oct 2025 01:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6C3F8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:06:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E20047302
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:06:25 +0000 (UTC)
X-FDA: 83995533930.15.D913E73
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 953D112000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:06:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TziKZBHg;
	spf=pass (imf29.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760418383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B9BK+9ajYmleGpxEkSE4YYmD6WR6oYv/sY36uPRqwkM=;
	b=JW3clMWjiDhJ5E8AZu4HOXDdroLGBan6Mhj9XvtQAOdka/07yybck1AqgHxJjrExWed7hK
	OihUXimzTOBavU5ZcExL0lZhpdeKQkJgp68WgHbRGo3i9U8QiouoYDojNoELPSU2VHnnCL
	/Ev0d//pZTgzKlyPdaOlYyK2KgBrxB4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TziKZBHg;
	spf=pass (imf29.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760418383; a=rsa-sha256;
	cv=none;
	b=VayBNbHU/Dkmkox1IvQD0Qgn6mpTwb0ytpDOMWVuoFcE0gZwTWTL6246OD4To7lGJlgHCK
	sEKkKug0IOLfsjo3LldGP2QgKOAi3qz2tP4aWFKHoyxJtRfQLMsAoiJVQLEcQMCz2uB09Q
	8FtLflebyiuMEEjtcgqDh4IyGMOZJSs=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b609a32a9b6so2901176a12.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760418382; x=1761023182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B9BK+9ajYmleGpxEkSE4YYmD6WR6oYv/sY36uPRqwkM=;
        b=TziKZBHgG4pQxqzv5zBI8rvOgyPtxRc64uqsG+14hpjGAQbraAB7nUo934jyoWwRsH
         8eDDcjvlDhOEnFBmF6GiO2VUhjBXCdnwyf1vBCBVmyGDykvRiNFisBvui43rKpt3WYMW
         pXHKOvpL2gQRK5wKH6KLclE8rnIbsEKSZpkbJatw5vNMSmYsKXWP6/zbBwv+u0/XFfSO
         rbDjAIj4gmBjmCLZhOWehHw1GfF9qu71zFq2XwSR8gpg803HoZN+38M+sH7o2oBX8/B0
         zTOV1JH/sIhgLnRcH/KmBP7E/6Si0WXFpPyT+e5efYau+eaBM5L2TWLNImmRm1uCDRet
         lHsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760418382; x=1761023182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B9BK+9ajYmleGpxEkSE4YYmD6WR6oYv/sY36uPRqwkM=;
        b=MgLk64lTpQoMhz4U0ZBuEzUL+kDwxd8TgS+1xpCsme/4UEf5PJQocRjZID8Vd06AIR
         gB2MyMt1SCaC5IAnn8TV1mItlbQi3oYSRn813FEezM6tdyzO9XzyR9O7qUvEGqfDDpTD
         CLjpS5R1Tft54IDOynOTGP0RkFN7IToa+WDkGtEFVtYmWiDgMDWkc8DxftrrnOy3kV81
         tr/Lq5VS5ug7au7iGCyZ4mcTgAGvKTPkw+1YvQKAjaCVsUodB2ePzURglSAkV8eZYnJO
         12KvMu/ejxkqgO3tyg9bGvdyb3RNi7gHuFZgKMxym0VkrZBjTKchpTone36k5xr3/USs
         OU+Q==
X-Gm-Message-State: AOJu0Yy8iUtB4ntVogQ/7J/VDew0mOhRDb4xJBvSDr99Sd7GM7WRAMgs
	yuyx/U4pi77CFlAUZuA3B03e1K1h9a0Whc7y+scvX/oZcb8S11saC8vN
X-Gm-Gg: ASbGnctq9/JIsiVMSjpJpCY4ZL9yjwufoFMKK5bK3Gn3wlS9aro8xYoLbzDCle6k87b
	lEo/WL4T12zN0KBdwWBAPU1brBsTg60VvdAU+eedHizvkwI+b+OOYxLQNbLCpFYCBZBX6qAOMkI
	0KB7+VEUzotGqFQGWjfb9zQ6bOnYBmmPqlUp7pG2ng8T7yWqYfVbm0Zdz/i4RvOoUbFL8IlZKGe
	rVcMs/tYLgRKc7eAqa3VuPGqyWXzYSIvyiC44Zy1SKcO4DwmoF/v6KFRkbHZwQlrmD+ZB5IjiIP
	hwvYl2xGjCOu+rqhYUKR4qu43O2+adu4NNTcUsafU88i7do39WDhPEBSFCaegsROPA05vs5Xk6J
	GuhIt/u8HN6w3obYIthec/o8eySEIupltxq8mmvZL+S3h9+zgenkYoD4X7LZhB6eAhWUfplp5/z
	FlWVUQIVgOlv+rFg==
X-Google-Smtp-Source: AGHT+IEIVs7lvSQ3NXzZb0jGdos4Hk3jrN73ntxBRefqVaXGal6SIJg7cZ/x00Q/QXcoJ9SkB9/Wgw==
X-Received: by 2002:a17:902:ce88:b0:26a:8171:daf7 with SMTP id d9443c01a7336-2902723f086mr387687875ad.16.1760418382248;
        Mon, 13 Oct 2025 22:06:22 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:389d:c391:4ad4:fa2d:b790])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f8f9e0sm150546215ad.120.2025.10.13.22.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 22:06:21 -0700 (PDT)
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
Subject: [PATCH v6] hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
Date: Tue, 14 Oct 2025 10:36:09 +0530
Message-Id: <20251014050609.349461-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 953D112000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ibzyjeej6cw3musihrffpucbcg98t9en
X-HE-Tag: 1760418383-649191
X-HE-Meta: U2FsdGVkX19Vo9lpKfcDDCFJ5nM85tcXERHwlD15grp0TD/Qh7NaStJ/PfcOELAcu8ZYkEyYM9KUwRByH+NsAm8hsje2d0HyALIhGT3IvRiPxwqbd/IHpXNPDrJlkEMehY9YS74boSI3xq8ka+moHZRGzPR/H+FHdk5UbCcVTFSxst9azp9svb4rVPhVQ3AYj0tWDnD3ooWpNoSCEZQVj//LEXwyR+nhdYBVm2tnlt6/SlTEYiW9rBMhw569XHza2dN8Qc00ja/l3DZ79MBGLWEcAnKJS93E+aIfJf5QU7qtW4CPyNlwvz6viM7HmGz712J21HZrOXgThcJNm8jkUkMtorVzUeAhsZfocVV1/eoTUhlCJF2Lrjv2r53su7Oo9KX5gTie7MLueXsgXuCxFAOSpXT+anJV3YPjaXWmrt/3Vg2vGFiXKejsyK+RDs2V+bhdP+blyvX/f7qN3KSR3s8VdrY6k3gRCr02tgeiZj7nvkZY4WH9Rp6o0GcX4klRhl1LPgZy0qy3aIil4xJfPuc3obUQgkckexh+R7ZC75OcisoUoPdJpqWiQVDd6/erfJTUEln2awfo/psZj/blVlakX3RjYIzYjL4ic0E7CMQL4oNDi0/JKPIcLaRN4y/LuSqju+vgfLILCPQOzowT37IFCmLmP4EvkXmP6CZ6ca2a2zilachNrC98i4fe8fnfCNDYxvcPVh30kMx+rN080jkJgZwax969XiFfEN4qNCwu/XW2jBlzk+78lumh+iwE/NRZ4fdj15NSf6c735X6bjPCWMMAM/Y3IJw/G5EVIxKLSm3Rf3U6dcKOmwaoQoonggAG6OSQVB8NgYSgzYEhV4J1pBHDC4udqEu74K1nP+iX3MG4BJ+05cweXklZuvShML2FjCL/Ea0yyn+7MqdhtEJ46JLKbTuldTVXT2ce15dpjRa2S1AIFnN9Whp4FYBC2WHuYfYPF/vlji6hw2X
 0zFgGuVO
 WKJEE6Ic8T2EJNfghiBHfRXKtGlM1eD/U781XM6x947IVlRGOky1F3+x6CTisSP0U2fGN05YqnOMMhbp5UD+tjIGJvg4F2KOezwXLGH5yfhrdV3WUfPNj2Hh4f1CuOnvmguT5xJI9YKE7LBljYEw3r/rocrX6hrQm3ftY19po7ClL8xN+jZlIzlM6JKq3ZwsF/CrFFXKZMJx1hNyruh624F6CWBEUNpyRf+RW0dvq9KF4NtFhfBdg+MmT7XmN0zqV/TQzcP2w4gNrRf9ir0sKObk6C9NiiqC/DUOz9NZJi+cy36MDJ11HjMTyy+KPJce61zbn4V68yS2OkO/x+7t9WEXO4vLS0P1gAIY1W39v5K4DxnnWnGgRrZ4YfLt9dq4BSpJOYPRXPRRWYtx7jzRZ0fO5tBpXXGgmhhr5g8aaQJAZAfC+bKhPBdCNfmTvOPlZcuZx7a5COTPMGPnjZlWlmT4KujBkv2nG3lGvhG2F3XsAvlQa8/cFMsEhX2UhzHyzPBFhA2sA2PoovIO54yZPVZgg/D2+L8nm6pDEhRuFg5nOfxhAal8hY4bWd6/55aHAxKD2cSJ+leptMMVTp6ABo9flvIGrTFrhvls7vU+GD1Q2F1V2bjNMbH0MyzSKzgxRBDWuO9gluH7F6kWc1sxTZhW5reTl6l6JplcNrwBAySNroOU=
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

A subsequent fix in commit 06e8ca1b3dca ("hugetlbfs: check for shareable
lock before calling huge_pmd_unshare()") addressed this by checking
__vma_shareable_lock() in the caller before calling huge_pmd_unshare().
However, a cleaner approach is to move the lock assertions in
huge_pmd_unshare() itself to after the early return checks. The assertions
are only needed when actual PMD unsharing work will be performed. If the
function returns early because sz != PMD_SIZE or the PMD is not shared,
no locks are required.

This patch removes the check added in commit 06e8ca1b3dca ("hugetlbfs:
check for shareable lock before calling huge_pmd_unshare()") and instead
moves the assertions inside huge_pmd_unshare(), keeping all the logic
within the function itself.

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
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v6:
- Remove __vma_shareable_lock() check from __unmap_hugepage_range()
  that was added in v4 (commit 06e8ca1b3dca)
- Move lock assertions after early returns in huge_pmd_unshare()
- Complete implementation of David's cleaner approach

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
 mm/hugetlb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 85b2dac79d25..0455119716ec 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5885,7 +5885,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		}
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (__vma_shareable_lock(vma) && huge_pmd_unshare(mm, vma, address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, address, ptep)) {
 			spin_unlock(ptl);
 			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
 			force_flush = true;
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


