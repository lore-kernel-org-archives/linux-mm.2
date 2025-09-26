Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F532CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923898E0003; Thu, 25 Sep 2025 23:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB998E0001; Thu, 25 Sep 2025 23:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810C48E0003; Thu, 25 Sep 2025 23:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E23E8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:33:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CD1F595B9
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:33:13 +0000 (UTC)
X-FDA: 83929980666.17.5345EAC
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4062C1C000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:33:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lIm6gK6X;
	spf=pass (imf21.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=swasiKAy9erpXahrURLh1edzUqPTKg8IFE0nB6K/KGE=;
	b=U1QaSizQY0q4RZGWIfzzvb446ESxwIu/aD5aOT/kGdQvtmA/9qAYrkmhx1PvDCUPMpPSQo
	U+3Ez0LIIN2j5dsiZCJWXC1Lg+5Zc+ZZXQGiLMqLoiu7ZCZUyqBCR1nUD/wPvy7w4FIoPQ
	nwuNQZuliwAHJDlc4t4NjX9eFvmlVD8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lIm6gK6X;
	spf=pass (imf21.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857591; a=rsa-sha256;
	cv=none;
	b=7beCl23rShoNUfEOdHmY6sB0DrfZBjASK9PqCCd+XF244Jj241eBY+QP0oilsrKjppeKY3
	jjO6GZDc5Ivz5MDXgEUaAi37taPOuiimFdmhxXxNmTuedP5TyJFq4OVhPQnsNAZCQ3/SPk
	jsolC07MgXhKcSWToQ+dVdVZcWIPbFg=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-25669596921so17967035ad.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758857590; x=1759462390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=swasiKAy9erpXahrURLh1edzUqPTKg8IFE0nB6K/KGE=;
        b=lIm6gK6XkRzTVpPXNUdHWGAaCbL2ub0CvCMyHfeTPPE1ijZTo9AcQJDZsVG2Nxt8Kl
         zPnOu9XGWwoXDXiIB00bfN/douPHjpppIN9AQHHJmcdBu89bayWHiYgUqljqF2whYL1W
         EwknrlaMfqCDz6+xS2JInxMJlGM48JhN8tJWVMmRI+S2I2g6LSeus7O2oalQlFTLNOQ5
         6teLtbHyDBcpWOEEhSVZLjGanEohGFy8TcCGHbpYQohPBTu+eFVhh1MrCBXCp4T663yA
         p9lXGllvFXZRRlM4iaHQ/fU/hweCyu5mmw3GKvoi/v7pwAQ3T/u8cETUyCA86TrRUAHI
         /wGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758857590; x=1759462390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=swasiKAy9erpXahrURLh1edzUqPTKg8IFE0nB6K/KGE=;
        b=QZRXTCLJd9b8ETtt8jpOpuEIS609JiHgVTRPbDpUtdtn8s8FJ4XVxM7Mq+x1zuB6B/
         Q/mx2gH4yXTKWBPhAXxsu/HWffBu9v/QG5XTUIzbHFdHS4A9fWQy83UllinevRSiSgIx
         /6N8zTTPxRqPjbKpRlHDhaFofoc05yxDKC0FXoGwvCGX18gig//lAXpuEZvlXku0ZNOM
         j4D0XhPzlHyieZ1wAzwT2+mJz/B3Tz1mAh91Ru1M9Al7c8fPLCgBeZFNANBtxOtyGj2b
         hnoEIXDlNZ2EzG5lZd0WvUstgLMJGlSTY1qGfs5Kidjvb/oiFK1ibsKd94zcCDn7bamw
         pwPg==
X-Gm-Message-State: AOJu0YyINa6Zdonqu+Pgu/VnZLLlwSY6LrU9gtk+hMCpLCyGiSpxZ/J6
	/TbuhLJY4l/N+shN3YyaL4k9vNW/yrvS/WTL4eH+J5kGhChYLJLh+eCM
X-Gm-Gg: ASbGncs4vW/VJnJG6x9kgjE5fWe/vsSyMpeJk71JB4eclyNxj4S52MxNntzjbkKdarq
	6OTrFFIGD+IrIqQoZhSU+YzK06HdNaHoUUd98FqP7LmSo7I1pYouD2UubtP16x8/LpPJGs8JnQA
	i7/jQKmKpFFySbvzaaZkn1Vb6Y/kB89uZrdzyPJLH3eUtzodiBiAp4l6PMJ1SUC/8Vx+YMRElV0
	7QgN2wvaK/InjltZt7GipKYDt8WhZRT9ibuZ+GroAb9DStOCwPROOMEs3nYwjIguDD6r9kxFrF5
	m2mnz1O2SZ+2brvOCTXZufSFsJ5kw0SPh94MOlWwKdekg0t9T7mB2hKVeDuq17sX5VP9sqHRDDa
	vvwXROCbspCGFB4uED2OAzqpunlbiE/BlZWQ9MJWyk5tpLaqD9icFDcehik7nMCVSmYF+ZJBV7m
	sRVM0=
X-Google-Smtp-Source: AGHT+IGVib1Wn8HeC0syL4GXw8dpS7EKsj57MJdQZoUqPJPbWnjFKnxPMpLvgZM17uyJ+TvLTPKElg==
X-Received: by 2002:a17:903:244b:b0:27e:ef35:2dbf with SMTP id d9443c01a7336-27eef3530ecmr12593585ad.30.1758857589845;
        Thu, 25 Sep 2025 20:33:09 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:3094:a5a4:3d95:4e23:c62c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6882227sm39830265ad.82.2025.09.25.20.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 20:33:09 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: [PATCH v2] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
Date: Fri, 26 Sep 2025 09:02:54 +0530
Message-ID: <20250926033255.10930-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4062C1C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: 931nqy9o6515sdyyrbnsrmgso41f4tgc
X-Rspam-User: 
X-HE-Tag: 1758857591-173414
X-HE-Meta: U2FsdGVkX1+GepfeYAN5TFqRFU4tQwnt+2zDr1ljJ2PeOjqIGGs5WEq3BqJ18sqZaPL2OPYozCC4lxajZD5yMd1kFswvDrtk+iMkLIlZ66Ip7Uk1gqQyV+m5nQTAO8rOAZB2jG1lAmBpk+CJJKE6d/PgGJGspYxu7LTjF/m9TZcmU2Fsc71s+jhW4FX7lwWgWu4dUTXVvukdgrwoPCOeEOKkvmktAYDQoEhsKaF2SVgGPRimBLTRmuJYFzlhW9GZAxAmiLQbe3BBSStlxvNXt0tkSzOnhy9NJn+jj4yB3sLeCmIHnJl7z0GCiAtgcLCEnlW1DYp3NFWmL8iqQwVU98Fvly4RjTassm7f7bB5PN3XYMT8ry8PZHIEfy0zR+SEC1rgx5QdQOs74RUBZvpvwEgXIo6ZPFlHc/lVqcjO/iMQsXeFKt9Jql9sDbFw+9viUn3+pr0bqR4sCHc6myoDf4OAVDWozFcUcXYQgCksBLaZXzcOcD/pJho2UA6mS0wUQP5jV6NgkufBULzL/JMeXWXE99kl96SWLspnepw0AQ7SKEAJW1jIQUPoci8fhSTC8duB8Hh11F8zz2GXkg4AiK4Qva/007HwLi/Gmk8Yp6Scs2EEqAQrWt0Eqb1PcYi8keYb4Tvcxqn2bZ4+LDiHaYiQ+2HJDyIxcBTFZaMumUKRBYNj+O23WEqCPQRU0k6mkSPtWaPDw7/SpJxwnkwbsbwA7tkqsfUVOkqFk92GIs2u5E48gexxMj7XVrb2E0jLsQM/P1D2July6BGSxPGEggh3cRl+8kb0x/PTPr4nwgaIkGM3YYKUb81dX6/GrFAQ+hKMIRFwrlM8OT4ZkPW0JO3Ku8lklcuo4HRo5a6DLxmrqjyz9TLrg2I0/mK+kU67mEXgl/IpiDfEZCZVLcSnCUK4kemXi0JPxchQ5auS3v39zbn8O7pKGQhLoSsoTJ2ROa0EbRO73r2hZKbcsGQ
 P6r2bKRZ
 pH/iMMTAq0bxm44qMWtYJ6HZGm4QJT7i1Ey11WDy9YrDM7gGaiOB/tpgrDc5sKmliv6WPW5QXLotiHk5kLxtluHs8m5+StNp0zYSItDzf+ENiwDilefOBi3dr1TVXIrBEe+nwRy/aiRzslYHORji8Q2u1I6fp8q0cMxzxySwyaaI24eNDzDVqfcM/puveohxi5VIyfA4/82JOQTPeqIn/Sx6VrD3knNVx8EANYQm9rY91a9lgZTVaV3+7l/kZdHQ7tCMS9Bt01apCEDBlqIBIwrS80SMSCRNZNCmTcrP1n6RcMacmdmUqGcsz34AlDzu2IUp01Pic2JhHkppmESZ3iuwaqv++W5HxDuaAl/8EplJMWbpNZnqiOwIMz9Bfcmdtl8LDrYxD6ePqhEy8VH0NIzkdoUK35ehElUJxhQK9wANE3ZS29eqS0x8YHzGSCeBzGvvrt8tbwhxEvkutGxwwRDF+Qn+tSUrzi3F8TWUQQc2/yaetDkaaXReLqh6TY/tzlhfoNqS/mEHm2fia2Njisa6ZO6ZGeY+wUKyDz+AVetzuSJvi6hBra3jJYFVKlCY9f3u/l8ISYRjzf4gIN0W9w8eF5xWoMnNSRIHVmPUp/ayiMIwpVslS21a+K85WmiJw8DavyJ6043HS9UvDPkxzqSiIyJkCDx/WDHVIwN96+OzLJZpO2Roob2ktlkXZLt2LJspEpOYyQv6jG3vKTwWo1Y8NGj1IauWVA4pBI4SQi1EQni9+l4iOzhvgpxvfKBh4YGABz1KmFtFEDwD/CHfPgRrmUWXMqN66dbtpP5NK5nJGgQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_vmdelete_list() uses trylock to acquire VMA locks during truncate
operations. As per the original design in commit 40549ba8f8e0 ("hugetlb:
use new vma_lock for pmd sharing synchronization"), if the trylock fails
or the VMA has no lock, it should skip that VMA. Any remaining mapped
pages are handled by remove_inode_hugepages() which is called after
hugetlb_vmdelete_list() and uses proper lock ordering to guarantee
unmapping success.

Currently, when hugetlb_vma_trylock_write() returns success (1) for VMAs
without shareable locks, the code proceeds to call unmap_hugepage_range().
This causes assertion failures in huge_pmd_unshare() → hugetlb_vma_assert_locked()
because no lock is actually held:

  WARNING: CPU: 1 PID: 6594 Comm: syz.0.28 Not tainted
  Call Trace:
   hugetlb_vma_assert_locked+0x1dd/0x250
   huge_pmd_unshare+0x2c8/0x540
   __unmap_hugepage_range+0x6e3/0x1aa0
   unmap_hugepage_range+0x32e/0x410
   hugetlb_vmdelete_list+0x189/0x1f0

Fix by using goto to ensure locks acquired by trylock are always released, even
when skipping VMAs without shareable locks.

Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

---
Changes in v2:
- Use goto to unlock after trylock, avoiding lock leaks (Andrew Morton)
- Add comment explaining why non-shareable VMAs are skipped (Andrew Morton)
---
 fs/hugetlbfs/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9e0625167517..9fa7c72ac1a6 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -488,6 +488,14 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
 
+		/*
+		 * Skip VMAs without shareable locks. Per the design in commit
+		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
+		 * called after this function with proper locking.
+		 */
+		if (!__vma_shareable_lock(vma))
+			goto skip;
+
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
@@ -498,7 +506,8 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
-		hugetlb_vma_unlock_write(vma);
+skip:
+		hugetlb_vma_unlock_write(vma);
 	}
 }
 
-- 
2.43.0

