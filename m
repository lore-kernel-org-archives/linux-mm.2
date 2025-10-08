Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFEACAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 05:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB09C8E0016; Wed,  8 Oct 2025 01:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88AA8E0002; Wed,  8 Oct 2025 01:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9338E0016; Wed,  8 Oct 2025 01:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF8F8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:28:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAB59C03C0
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:28:10 +0000 (UTC)
X-FDA: 83973815940.12.B33A311
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 41790140007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:28:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mqqW1YOG;
	spf=pass (imf26.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759901289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMqvRrCCbf00Rf1hkLneqb6IWYGGdZT3hFbhVoMk1mQ=;
	b=Sb0Lsdk+14gQi3w63vPYAj+wbJgXcYFPEN9p/7txc/HeGNc3uZGlRwZSl588uJgZa0HwG1
	jHa6Cyv+1hjLJV17mAko8GblD0nMyuerDZsBEEAANa5PxfHmS1aSZmLpNaV5cgCsU34Yoy
	35/NdvFf/9SkaDRNjpzA7y0wxhkpVE0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mqqW1YOG;
	spf=pass (imf26.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759901289; a=rsa-sha256;
	cv=none;
	b=kZx74Cskg8MaQjSz5lm4ilCdJqhXEuXPdKTEpHbKoOJ28+8/jtxTSILrVtIcapB/pSEZ9j
	6HHZoCDleA8eK3hcsfYidNai/oY2uMu2MR13a3HwpeGvYFqZsFqwrwfI8AMYWfOM08zpbB
	l+cp20w4JGwCYME+hUhyL9GmvySa9bg=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-28e7cd6dbc0so79907285ad.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 22:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759901288; x=1760506088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMqvRrCCbf00Rf1hkLneqb6IWYGGdZT3hFbhVoMk1mQ=;
        b=mqqW1YOGqZMtS6YNBJJ9ttd3QbrP6eSEcoBOoQbf4olDMq//129QAqi82TPR9Jcr7B
         s5S4R3DbM0IUGbM+JC+2NFKNo74QVZBAnCY0+aQ23u8wfkFPvsTnepOIIPInAa+zNTfH
         T27oAwlzbZ/ilfJFU9nlARFN6lmju15Ekct8n024XqScQ13VrJkhNL9zOREleq3BQsWs
         swK+JZglsmaHhGwlo+4mNYyPUwrcNqE3716nZ9MahTMk8pOlin14r1THtmSE2BRLMx5r
         8BP9dUUj+2JEHk2uHpnaDH/SyjXdWYS1HGH/Q3GcmunFhsMGvuk7jYncGXbTNGEVjieh
         kp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759901288; x=1760506088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BMqvRrCCbf00Rf1hkLneqb6IWYGGdZT3hFbhVoMk1mQ=;
        b=sUbEAOw17nKiDYTiNX8w3DD8CyZOgWKmLI+1gGLbHE+WMoMeY3KQpn9ThSLfQL4a20
         mQKmfXcelqGeB1zW+VMvReFH209LHmie5K/WnmgpLVsNAyI98yxm9nsywddfQ+oe74bN
         iJPeEMcrquf21QWAz7tWTuaw6wcnoExjIXZtBOe1Sta4zt2I2+e7SyvuxJy5z65kbpfY
         /CtcBgp/Ha6+quOy3vEcDJmUdjNR70PxmkA6Uz2hT7IYMD4o5FA+BZK4OQE99t6h3GM3
         aaJ1/6S2uTT5XVuyRgXS/wUzaK8+h8JdvNzB+QLDholcpo2itmYm7rNavw4GEj2rYqDV
         /imQ==
X-Gm-Message-State: AOJu0YxtMen/R3MyxNINH1KNG+4EwUmxqXwhQstentT9Cbj28woPFEfR
	PfMauocst5Jkmv+OtuK+Ah4VYikXej/jCr0SQKYnJQsgaFzMH8ZPvqEz
X-Gm-Gg: ASbGncsOcpGv00/hjhXPsLXTSewCxLHmFwYiGfd3wjYVTD5gwI0NZ9cbf2Sj3LD9y/D
	SPBzzleyN4eIHqajcNuFmDHiGyTc0SOwWRFj90CPFifKQGhtMoAzhPUo5pBeRPjJNvQtul2qf7c
	ElzPcTV9DF4vfYuxCbHFugBhQZbh15qeeSAlRicNaLZxXg3wWVa/cDI1Bn8ojqke0Q4scvVIDSq
	LDxtKIlv9PCYzpBZpElpBtlyYXcxNc/RzD5/AKt7wWcO0NUZEHmMwltJuH5UYD41dHq5rqpmgyX
	mK+m0xU+N6t98f0S44g2pKSFZlle4d/gtkNHLzu/kSQLbumd1uKMGdRZ9RIlZI74hsIdMsK4HIh
	0r0OR9/sIDTsOm+6IoIpIjyaJ8lFj05PQJ9+OPuMkx4FqYm+ygQ0kgVFu4jUKVuzpn1UB6Ox8su
	AeQ+q3+zf3ygAPAvNW1gfLGJQ=
X-Google-Smtp-Source: AGHT+IFbymgP7acspeJIYGYr+yCoZt35ZnCOv65FC9GFvmEZGXKh8iwKgmM+q7JvQSYy5hZmRSAA/Q==
X-Received: by 2002:a17:903:3c4d:b0:267:44e6:11d3 with SMTP id d9443c01a7336-29027379986mr28771885ad.21.1759901287971;
        Tue, 07 Oct 2025 22:28:07 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:4c4:4e8:dff0:bf0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1f1a75sm184147135ad.125.2025.10.07.22.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 22:28:07 -0700 (PDT)
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
Subject: [PATCH v4] hugetlbfs: check for shareable lock before calling  huge_pmd_unshare()
Date: Wed,  8 Oct 2025 10:57:59 +0530
Message-ID: <20251008052759.469714-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251003174553.3078839-1-kartikey406@gmail.com>
References: <20251003174553.3078839-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41790140007
X-Stat-Signature: uarayeaj4bb3cs35ehaik6bcc5z58gzm
X-Rspam-User: 
X-HE-Tag: 1759901289-955601
X-HE-Meta: U2FsdGVkX1/O1UIZpIDgLFITJC/tOrCUUQ/+7lH1is3OnJwkRbiOK+CPZmLc3uMk4OCxzSslV+jJC1XfLDq81zMlFVv/FD3SGR3Sv59Tzh9cjJs9Di4W7o8S4Fm3/1EHbSBkIUagffZCR5c7R6oWM11z2L4OrA9tAQMp2hH+QOyNYyBmcg0jIIAxKj4/sLJwDr9f7Iqn5+hhVMVfwCxQlE/SB/X2AovOAdk4aFv4mSZQ8csqwekVDGquGK8/CEAlZJPobvPBrdBuao2XqvwsdeQ6Hv4+eUPpQNSTHBp8Hi8n7Dn4vjzrGEjFKe3/lbY59mc9UpvccHFS7i4FUuQXmmsideCFe95eMMnRgfMGaxEGtn6cbPv42Ex1Yn5muvoCz//PzvF+3Hsw3RdcN3X3d1I8Eb2ZF8mtr2l8moVlNElfyy9QDq0HDqUO65qfRg5/pv2/xg6x6crRomyYdsOwQgHd3U5KS2ny2OKTkC/qbaUB0WOFwoKniFjMhY3yYVDDrOdNbvkSPMeyu1FUoJH2vSkdunOBshG0qxMF7jSinWb9P+7o97OkjZeUs6uRtFOtIiUe7xwb09/PbalhersGwdC25/gWRFugX6vldiCaR/KJGViGbzzTb+gZnhKBb1gEnmEVLbGJxpCnEx16/MZFSVoN3DxB+JLGvVp9XUExEZ49RY4OfNBqDZeRKV0JpITGiHHBzkWFgbzR66QoP6uor1nK7hs0CeMYa8sjJiQPOR6/ECjciXyyv/pRyC+zHF2G1MEdJ7ZslxzveNWwcsRor52sBWb+KbVK3FA8bfh+mEUfRUNw5FzAhvvHzsLiapLNNsMo9bMRrtCDk0OE2wcYM1ICdS3qYdcuFR5bJmrpV6dWsoNa/E8j8D8wwKA6AtcgJBcRFSQWtzkqiA6AYcjly6fJfn3Ly1GjvNrto2caijTLgkV4Ef8KdRMsqDie642e1J2gobWJVaKSvObY5WT
 nU/T2C8l
 cXh5kCj7E3X0dEIsOBEc/eiomFUoVeNvfRieC+Iw+prZ529vyBzHPV/YpwOwIWLazL5dQU7YZ8mTaQywefTlPiJEhDtE4uqvScYgMgaQ8XvZRIEPRZL1XCXpE+q8WKnrGwyThnoAw1wpx71XSjz2DRkrJsET+KCtCEdtg0wyLHCcQS6Lp3bJ7yaIr8j7zI96VvO82JN9Q+WrZ6+Y=
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

Instead of skipping VMAs or adding new flags, check __vma_shareable_lock()
directly in __unmap_hugepage_range() right before calling huge_pmd_unshare().
This ensures PMD unsharing only happens when the VMA has a shareable lock
structure, while still allowing page unmapping and freeing to proceed for
all VMAs.

Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Reported-by: Mark Brown <broonie@kernel.org>
Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
Suggested-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/mm-commits/20250925203504.7BE02C4CEF7@smtp.kernel.org/ [v1]
Link: https://lore.kernel.org/mm-commits/20250928185232.BEDB6C4CEF0@smtp.kernel.org/ [v2]
Link: https://lore.kernel.org/linux-mm/20251003174553.3078839-1-kartikey406@gmail.com/ [v3]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v4:
- Simplified approach per Oscar's suggestion: check __vma_shareable_lock()
  directly in __unmap_hugepage_range() before calling huge_pmd_unshare()
- Removed ZAP_FLAG_NO_UNSHARE flag per David's feedback to avoid polluting
  generic mm.h header
- Reverted hugetlb_vmdelete_list() to not skip VMAs

Changes in v3:
- Added ZAP_FLAG_NO_UNSHARE to skip only PMD unsharing, not entire VMA

Changes in v2:
- Skip entire VMAs without shareable locks in hugetlb_vmdelete_list()
  (caused PUNCH_HOLE regression)

Changes in v1:
- Initial fix attempt
---
 fs/hugetlbfs/inode.c | 10 +---------
 mm/hugetlb.c         |  2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9c94ed8c3ab0..1e040db18b20 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -478,14 +478,6 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
 
-		/*
-		 * Skip VMAs without shareable locks. Per the design in commit
-		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
-		 * called after this function with proper locking.
-		 */
-		if (!__vma_shareable_lock(vma))
-			goto skip;
-
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
@@ -496,7 +488,7 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
-skip:
+
 		hugetlb_vma_unlock_write(vma);
 	}
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6cac826cb61f..9ed85ab8420e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5885,7 +5885,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		}
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, address, ptep)) {
+		if (__vma_shareable_lock(vma) && huge_pmd_unshare(mm, vma, address, ptep)) {
 			spin_unlock(ptl);
 			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
 			force_flush = true;
-- 
2.43.0


