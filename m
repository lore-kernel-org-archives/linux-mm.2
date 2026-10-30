Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4167606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Gqb9e2vA
Received: by kanga.kvack.org (Postfix)
	id C00E16B05B5; Fri, 30 Oct 2026 13:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2176B05B7; Fri, 30 Oct 2026 13:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CEE6B05B5; Fri, 30 Oct 2026 13:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA7A6B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:23:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D55B314064A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:23:34 +0000 (UTC)
X-FDA: 85379964348.01.469C2FD
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	by imf07.hostedemail.com (Postfix) with ESMTP id 82FDC4000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:23:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=Gqb9e2vA;
	spf=pass (imf07.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.216.98 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793381012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/s8CVJR0YF5mgHtNd3A3LZYKxjpwFNKk2F6XF60RQU=;
	b=PSZPpwIAcxPkBOMmUN+AxKQkauIykzc3URBCj4b1KIOwDJjpE6GFPZOQ3zBXqTOqFFoJDK
	ViCLxSX2KxPFtz5r7TdXdwhWCrDNiupjjj1ABCnKVPHe7UD5bI2mAYaHPyHySRx31aC72p
	EL1JJ0Bfh8CHkw6xuzgVZXhUi1c4c88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793381012;
	b=QVcx8t3fw2AvsAR4JMeY8iqcZjdT8yIGwIvNw2S0dYKRSUPftfVE50pLhVpXSWEX+2nfun
	Kx0NTBA2YCWv9m2pQixpoeVr8wWF/iffbSTQMEOOwdbgu+LMPDxZeq72h+EoT92R/gjP5z
	8S7QDf0SRcqRMU7eJju/mwGfRBixHGc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=Gqb9e2vA;
	spf=pass (imf07.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.216.98 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso545839a91.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381011; x=1793985811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A/s8CVJR0YF5mgHtNd3A3LZYKxjpwFNKk2F6XF60RQU=;
        b=yy4Dt9uiGK3jiHISYrIKY6HVyrznxSn4v8OcgbJ/Oxeeg0mT56UNDd1f19aHhsn4Bs
         iUhSvmKUu/KG6EX36MzFtKXk7FhE3YaGBVYwVQNBAYXnZJNbW03cmW4K/vRQSCk04x3B
         WXhz5DulrizKpBCd7q6kwRZ4IZMHbyeDeprV2jdpdJ7L6y/Ua5WJ+U/LICf/dDcgTKog
         kzkbURxxbad7vwJkpnnDpdbBmn22B5yCGgoyjgrrClyOzwzYDjgktjKQXbj+puRi2i07
         pSRexmEqzZFlIarj//RT3YqdlgVTbMLXRbdasykxscrsaLlhfeIK5B5c+DeB7RaIW+t0
         IJ/A==
X-Forwarded-Encrypted: i=1; AKwUvBwyDINkLlO8tSLCZpnREqsl2+frrrD9db7dG4Ol3hrESl+lEQQ9LlH2mquy8zJgPvkpS1dElbox7g==@kvack.org
X-Gm-Message-State: AFq9FYKKWBcnQVU13QgM7B9gq2On3Gl8l9mR+vZSCnxHFBS9D0u6/WmS
	D1LYf7mwKoTJcRA3RIUWFpmKibh7z73LgIGEF5STywQ6L6ii1EDMfyuBusBLDR/47mlZmoe1O4a
	DdNpZj/FY+01h0EeNDw4YZKPiUMl7VfSLenZJ1tvQEIu1AmWf4/Oxx3B2LJy6o4Ii5RE/4fQ+MG
	Ga0AQYTD9DC3W88LDxd89M4HFyiuRsh8y2/qskFWBQEo8UDcmYVaol8KpBY5b+LsOVD8K6CRFNv
	v6LrAQ2JRmnLA==
X-Gm-Gg: AYBFou1mXkwxhqEDpb3lvZ57M0R9qNA2TsM2F3W+FIepyOCTo38W/ZZpU6yQPHxUs9b
	90XYkzZsR5eIvLwczJ9E6KxwoRxD4aOKCYeJ1lbl6KKd8cK0eVkTjGqHrh5e14043TT9GwmN1VZ
	FmR+byAv2a8hLcCpv7yqP0s5imjJW/DMfNmKyDnzylrAo8n5izu7nT/0el4gnXy0ObEKr6G5b4/
	Q5mYP3F62ONLLEnLxAmWwMBk/XYFvH2oGUk9xx2kdzv0rNHsT06sNX8osonMHSK0T6sPe+td7bm
	rWTVbH1m7fOnJ0UGBApktLbKgBnxjRyjXsZgZCZSB5FXA5YyyUUXT4co7It8Av85svPGD1VMvJf
	K2Khaf5BlU9550RaYygHn091mIvnVhzFOt8nO2vdhwCMa+WzP39pw05xdY428oFzyd4aIwhK5Fq
	18aQGANr8BSQNnvmI7FAFACkgJf7T2kdv33asqCXZX
X-Received: by 2002:a17:90b:4406:b0:3ac:b6eb:e0dd with SMTP id 98e67ed59e1d1-3ae8984de49mr2272959a91.50.1793381011319;
        Fri, 30 Oct 2026 10:23:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae8444ce5esm2347833a91.2.2026.10.30.10.23.30
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Oct 2026 10:23:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-14373747468so988982c88.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793381010; x=1793985810; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A/s8CVJR0YF5mgHtNd3A3LZYKxjpwFNKk2F6XF60RQU=;
        b=Gqb9e2vAG945y0rJ9SCbI6ZIscrLewUVDs5JP290a2QkcWHMzCkjL6D1QAJhNftOsy
         HM8haJOJO2FRRhfrLqCsE4Pwy911r2M/ONHQ76xK83q6U4owDkPONgtb0bvWFl3FcV9X
         9ZeWFXd2W+t4fHrNLczy8NE3Qt93YmZsWqCAw=
X-Forwarded-Encrypted: i=1; AKwUvBwIMOjR9gaaUKAUeY+l2WgGk6UBzfQh3vk4XGIa4em4NzXw4fGwl1XdO2QRJfRGgs6i49dB4fRT5Q==@kvack.org
X-Received: by 2002:a05:7023:903:b0:17f:7280:1332 with SMTP id a92af1059eb24-1ac5c92f6e4mr4286481c88.40.1793381009068;
        Fri, 30 Oct 2026 10:23:29 -0700 (PDT)
X-Received: by 2002:a05:7023:903:b0:17f:7280:1332 with SMTP id a92af1059eb24-1ac5c92f6e4mr4286388c88.40.1793381007744;
        Fri, 30 Oct 2026 10:23:27 -0700 (PDT)
Received: from stbirv-lnx-1.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm8463406c88.21.2026.10.30.10.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:23:26 -0700 (PDT)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: stable@vger.kernel.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Russell King <linux@armlinux.org.uk>,
	Liam Howlett <liam.howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.10] mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()
Date: Fri, 30 Oct 2026 10:22:14 -0700
Message-Id: <20261030172216.368052-2-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261030172216.368052-1-florian.fainelli@broadcom.com>
References: <20261030172216.368052-1-florian.fainelli@broadcom.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82FDC4000B
X-Stat-Signature: fd7iooruaeyy6y1bs676srpwy5yeg74b
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793381012-721362
X-HE-Meta: U2FsdGVkX1+szJaVTBXXuMd+e2aX7kZO6A3VlMzQlmgLSlkJMtV1yGE2nzl8X43TkaCUY5W1JtXDcKFXjJxlSXJbj6We/uGYlKjciRNaAKYW3patS70gJ2KE6uIFDShuc43LY9ktlbeBktIKNuSRGjzhsSVhxfuSS0q/FXD3IN2wvo+1m4EPcEW6uVjhaqxA3XJNfwfsTwMVk2ItVz7lVpwEsartgu3coCEqWb1GXBPotBDBeknN/lILVT8aJLA56rw2grFSNc6WclX8f2Q6LaHN94z+xHJnGsgxvIG14kU/xhuDgjMasmSYw4pHjj9v7lHfhJiZBWm/La5TFkp/01TBXNm84ZgGjfERwV7RgynA6O+3a8Ey7cjkF3BE2f13gxm+rkujM2qkMvhrrfPQKkF4jpaG0T+fztRUiwQfms+1K4Ajn7o+wPbMzpb8yT45lZYwPlxZuH75fkERC3rjFYMcommyf3ReoXqOjlDkAtkwDDg2jKxLzuklEos7L5V/UWtO6XNyOcbNrUIejjW+MdQ2QkLUI/Fs6fBBtGdJ+gTXSx1mC9FXm54297vdOKgk0EsadEVhZIYDBXhSaJwFvjLrzCT9LYGE6JQHhkQuflHKxKLi83Of+As2s8IVKf9xw+PgpD64jFLqi06G5NCj3temZ0osTuEWA4cAX3k9d3N1a6yXZdKXf/rILJYzEbqL09i1bHa2GGxsdvy3tj2bRTuvgnIp0ERsIh6WzVwuLt0hPWufmrQpGLemUUdGy1epkJlnHGGIc4zBWgO306kYh9J9l6JfrYNA1+ssK5hDrr50nEOhhwKFQLsOKW9U6vgpVlnT5col3dSIy5We+SZK8e6Wecwj1jzva+Ka7u3Z266OAsbqGisdutMyoWrkIYSwN2jd0Aa0EXk0jHEvAlZ0t8hpq0TfRYYvTxjOl2Bmzvz7LW7Igp5KVtimtdeVTL/lm38UO67xUOQgqWu6Y6Q
 8ri/9Zoq
 RI8yKZ/kAdIgWl5nxEMgHNgay8QjFkIs5Kb+13OquOB9wol4EHiACgk37L4ey2RMV4630PA59PoMfK0jSxGqEk9es/V/EfCOyYc40yxM3ZQMvkr0F8GVm3JUsRJLWJ/Wyg4GqJ/V4wJMNOdlPW9ezheTP2Co7hbJU3qyxpmIiDhftdSxzWD8jfRlcF3nUWU5uu/1+30e9tx0IKQ/cO/jg5/xZAQusU0o7iKFE59ASNsDORLFjdzwtdI3eWITHxpFJ5THz1iGx1KwUeauYuUzd5ZTrtb6hdOYPRjnJKjoURM8PB+6h1QdKsmYMJYATqjYdBkFGXMMIJTNBU3PvrovlKyV6qilkvSzp3Mr8cgyXtaCL8yIFmtDmsOwyMnhrslRDdG73y/W0IoqhGrOtb5UlGSakWZF1bxMp5R/LeUwwEwt46WsYr8s1VNDg2ett++WzBdGfL1MoyJs7NkzPTnKihFIAFJoWfNhpsESzxVQdjWAN56nTQZ9jkCYpvHQs5Z7jFzhKppXZne7ljWNwTEDngodnzCxFdxsBhvPy5XClXa0MMe2SS35k4L+SYs0N7rBGiNkrELRxtDeahAnfKCsyXCQhUERy9EZ/0Oe48CCHFdxzfjS22vdVhvazRhHZHZGe3CzXPryDe1RLc0yp7+EhYsP5/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6b008640db7355d8de6ac18f74cedd7ccc92684f upstream.

Instead of having callers care about the mmap_min_addr logic for the
lowest valid mapping address (and some of them getting it wrong), just
move the logic into vm_unmapped_area() itself.  One less thing for various
architecture cases (and generic helpers) to worry about.

We should really try to make much more of this be common code, but baby
steps..

Without this, vm_unmapped_area() could return an address below
mmap_min_addr (because some caller forgot about that).  That then causes
the mmap machinery to think it has found a workable address, but then
later security_mmap_addr(addr) is unhappy about it and the mmap() returns
with a nonsensical error (EPERM).

The proper action is to either return ENOMEM (if the virtual address space
is exhausted), or try to find another address (ie do a bottom-up search
for free addresses after the top-down one failed).

See commit 2afc745f3e30 ("mm: ensure get_unmapped_area() returns higher
address than mmap_min_addr"), which fixed this for one call site (the
generic arch_get_unmapped_area_topdown() fallback) but left other cases
alone.

Link: https://lkml.kernel.org/r/20230418214009.1142926-1-Liam.Howlett@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Adapted to the rbtree based unmapped_area() and unmapped_area_topdown()
  used before the maple tree conversion: clamp the lower search bound to
  mmap_min_addr there instead of in the maple tree search. ]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 arch/s390/mm/hugetlbpage.c |  2 +-
 arch/s390/mm/mmap.c        |  2 +-
 fs/hugetlbfs/inode.c       |  2 +-
 mm/mmap.c                  | 18 ++++++++++--------
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index 0ca46f5d9438..96c04071a0d6 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -290,7 +290,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = current->mm->mmap_base;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index e54f928503c5..1cb7ec9f9e6f 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -136,7 +136,7 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long ad
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	if (filp || (flags & MAP_SHARED))
 		info.align_mask = MMAP_ALIGN_MASK << PAGE_SHIFT;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index d2a3964daf70..0a5236d8d2db 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -232,7 +232,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
diff --git a/mm/mmap.c b/mm/mmap.c
index f820bfbe5852..290822968e21 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1944,6 +1944,7 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long min_addr = max(info->low_limit, mmap_min_addr);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -1955,9 +1956,9 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 		return -ENOMEM;
 	high_limit = info->high_limit - length;
 
-	if (info->low_limit > high_limit)
+	if (min_addr > high_limit)
 		return -ENOMEM;
-	low_limit = info->low_limit + length;
+	low_limit = min_addr + length;
 
 	/* Check if rbtree root looks promising */
 	if (RB_EMPTY_ROOT(&mm->mm_rb))
@@ -2023,8 +2024,8 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 
 found:
 	/* We found a suitable gap. Clip it with the original low_limit. */
-	if (gap_start < info->low_limit)
-		gap_start = info->low_limit;
+	if (gap_start < min_addr)
+		gap_start = min_addr;
 
 	/* Adjust gap address to the desired alignment */
 	gap_start += (info->align_offset - gap_start) & info->align_mask;
@@ -2039,6 +2040,7 @@ static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long min_addr = max(info->low_limit, mmap_min_addr);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -2054,9 +2056,9 @@ static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 		return -ENOMEM;
 	high_limit = gap_end - length;
 
-	if (info->low_limit > high_limit)
+	if (min_addr > high_limit)
 		return -ENOMEM;
-	low_limit = info->low_limit + length;
+	low_limit = min_addr + length;
 
 	/* Check highest gap, which does not precede any rbtree node */
 	gap_start = mm->highest_vm_end;
@@ -2128,7 +2130,7 @@ static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	gap_end -= info->length;
 	gap_end -= (gap_end - info->align_offset) & info->align_mask;
 
-	VM_BUG_ON(gap_end < info->low_limit);
+	VM_BUG_ON(gap_end < min_addr);
 	VM_BUG_ON(gap_end < gap_start);
 	return gap_end;
 }
@@ -2235,7 +2237,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
 	info.align_offset = 0;

