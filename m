Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E7BCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DC28E00C8; Tue, 14 Oct 2025 07:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305C78E000D; Tue, 14 Oct 2025 07:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B6E8E00C8; Tue, 14 Oct 2025 07:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA278E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:34:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C824D5BA79
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:33:59 +0000 (UTC)
X-FDA: 83996510598.14.5BA01EF
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1153AC0010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:33:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=etPCnlki;
	spf=pass (imf22.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RqXpe7x7iRLgj6HmBHBg92vRFuM1OGyjmXgGmtw1Vmk=;
	b=4txEDKwawX+AbH3rlwBPi/MI6i8mSWNcYz/k8YjvjY5WGZlqLrEjj+fsqACsUv/Sv4wIpi
	bahcGQ3KFzb19FqiD9yFMY+h+J83pKAWfrOGALwvSntAIAzpWlvrytC4YCUP9vpUpNRtMy
	pY8vGy3tSdMNj3UGlH0zMH3m9cq5MEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441638; a=rsa-sha256;
	cv=none;
	b=iQMvqqqtblBOs/vReEu59c6vhL9Hvxe2txagv0c0fWTnTi2WjSPwGDx77Ev5FuNP4qpnPt
	8E16Y4zjuqbH85RJ12Q4YLWsaBUGkDRsN012czpDe1CvtjImjO33R7bede23nUXsmlDivG
	UEWmUEoXELIVCDF4fVJhdm7RbI5IxxY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=etPCnlki;
	spf=pass (imf22.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77f605f22easo4520501b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760441637; x=1761046437; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RqXpe7x7iRLgj6HmBHBg92vRFuM1OGyjmXgGmtw1Vmk=;
        b=etPCnlkiVdrogvcRCvsrzWUlMnn2bZJRNc0nW0LpNhEXy8izZQtT8KAlNaJahMSq6e
         A1J1vDUQdz+3Bee3ZIliYgoqPZTyYdlvuoPTNfzQ+z4rFZKF158NxyxyQ6fWH3PKO3Zk
         40fLHXXsClZZEjSiX0GRWMfY6gpxwM/LSJ9MnAq82TfSeUm6e35DoS13Z/yu0Vsrr5kj
         rAXpTuVnOihOArddrtSwarkzhneLYoJ1v/EPgvvpN4Ts2zhbDS+amIzoEEiD7B3BM426
         CglLQNQqstGXgjjHKaEdthqmSK4hJ+b5tYfHDJOxW7kzLEmf5SlBo2REw/PWGnCdP4my
         uQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760441637; x=1761046437;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RqXpe7x7iRLgj6HmBHBg92vRFuM1OGyjmXgGmtw1Vmk=;
        b=S6VZtS5mnZG15MwhsaSq3Ujatm6zYAFOmuCzOvu93lRIGOcRjr4qGoFIxhAngFGL2X
         HmktCxWp2TXRM8H67dsWjc/Kaz4jE6A/7ioxxBx5Pi5Qsvir1EJy0amC//GUNXENpbzC
         4zLiU4j73GrfTWkVWp460VaieQjmpIaPfVxvuVDPT5ZChUwVIKnIFVHsp3RSmFSJn9y5
         Lej04Bx917JT2qGxsv0qfVk8jZbWn+dVLSGei6Aj9vYAVTaIo7KFah7e2h9C1mMN/92N
         /zzPioqFBwzg4sRH7z6FZpzapuBjj0TTUy+m2HIaqVOavAdnDImw5vR3ChoS05lkp80Z
         jzGQ==
X-Gm-Message-State: AOJu0YyyT3/b08ZkW2A7v1ckvbaYBhux4JWOB2mjGiXVxPf6Ubtp22Ra
	0LV0AFy8Z5qXrnqQQYU93fDyG/9zRBXe9HjwDUeCG6LAUNk40y29B04E
X-Gm-Gg: ASbGncvBRS8oMQm+/rMD3sGl4hIi3hBKBXU9aCCV4JGRHmdyBVVfDVq+30A41reblNN
	U1Js7bodE5a2Z2o65Y2qZ/tIrrYfnhDdHGb0rygdv2lEZ5T7A6CbWzfgPBqSdZdxynalXh3g+Gy
	y0GOaG1N/Ybn4jt3Wj7EIveWjXcjgf2v4oPWF1vtIxp2AM9Rq+2B0493f3qjiN3cuwT+gHmIcjZ
	g+dCb86D1ml32I6JzPzjV9SFrkfaIKw1NG6OBVBwKUZunfuNhBU+zr8tmSoDP8S4zGwdYHj0nDn
	UlKesF8ARvcOsH06vjlkxzrA7rDLjqo4VaSRkzrA6J6Y4OmWgAc4JQXO9chf3qZ9wr1Xdkaz8hA
	tV7aW9g1znZ8PZyRbmxMJg3vQNx6WdsjJyH8jT4R+ne+m9NtawS/fGTE6u9aywQ6bT2uu6QxJfY
	o/mVQ7rAySWbUAmg==
X-Google-Smtp-Source: AGHT+IEH57zSPjucO0Eu9gEc1MdmkoQRp0mGC5W+PYhilR+SJlwfPxoxj4Bq3iEq4uuqQJa3s64vWg==
X-Received: by 2002:a05:6a00:3e07:b0:781:899:a9 with SMTP id d2e1a72fcca58-79385ce166bmr27119513b3a.11.1760441636489;
        Tue, 14 Oct 2025 04:33:56 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:389d:b33d:a221:52bf:8d99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992dd854a2sm14792004b3a.76.2025.10.14.04.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 04:33:55 -0700 (PDT)
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
Subject: [PATCH v8] hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
Date: Tue, 14 Oct 2025 17:03:44 +0530
Message-Id: <20251014113344.21194-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: bmwcqzg5673cq5wdo8ar5jdipwsrrp6z
X-Rspam-User: 
X-Rspamd-Queue-Id: 1153AC0010
X-HE-Tag: 1760441637-53852
X-HE-Meta: U2FsdGVkX1+ff09TwgoKEQbEL8CCmS5ZDThB+8E9KmyiZ8u4W76BDQqsaTfy+uuFnHVx28Z1RFyN0mVGi1gCVouChCi5q70/heIs6AEAzrRrHvMsNlG9S4WTm6LxR9YwB8raEmz9GzTYvSP5n3roThu4+b4Mrt/pNs+LbfgQl8qhZmx0RhkyaZ291rdvymdGUBpjTeeX9MFxW6vSD32RLVoJDMsKBxIevuJ93EBK2IXvlnxzJplwHJ+V107JVcnsAPKE3L7e29mKXsb2QuL2Tf+upPYOwR7SjSzDm5/io6C6awsQw4hudKNp4g9nvORrO0X9SagCry5ghQQ+jyg+S/jHXHfh2wrLTi4DZFyE7Qz0pkSAtduarYPrUgHmryF0XnCVAZa46qhAlWVLKbHm4fHEZhdUo5F+jDDAc7GnFQI9k57G6vUqUeKEQbLs7RsNOzD+UPfgRFfL0TC0s7+EsmSa5SLIXh3X0ZY/RA8zPHRBo2bk+SDW/ICb/aASIak6W3A/UAKAYB4HYnee4bv/70nFARPHvdOkWLxSFExMbYAqEzaf1RiuXhB9XIVV8wfg3XCvH4j2yQFU+lcH+UNLjOKKlTEYMcz7znSguDZ0GqlV2M9pPH4YBhyRl/4cBxnBw5GeuyIhUeIfxVpEgC95iFxZZMdJaIt64i+fcVUiNuiTpTllU2Wk1aQ8lZiE7D54HKEAHQF4c06sfUQA599o2Hc42gZz8GgIdk0w4OdauZEXGDE1WbLxwAPjUGRhJBIrjP7oxF+BdwR1+X4/2wCym2rn5IPHG6LB9u9auRLiPBfLCAr5O+IXVJQaPf7cg+3hs0aou/RBVdFRqUVzrel691Aid6JHNr4lxnYUS1BoAxBAxPaRceXrz6xhwQLwrc1/kNesw5vaU6raxTULNTKSjjXOO1g3/IOVE+pejmvLxFBOUuBehldMbv92YBwUSw6gvYe73ijbauAETsNhg10
 wEdUmYS9
 rYzX/bnXHUTF4swVrLoJdQtMmSq80KCbtOgz6W7rPrCmmHIKsMzeeQufqC7CPHm9Is211IbpRbpqSJ+jmXLHz2Ky3gW5/0guJhMN/BGCTnxkvelXScwLeU94fXO7ZBDkDqjnmXezJV2cPUTMVmAerNzjodL9oPNThHuZjTazf506YDy9uRcU61g5bGNld6NfZFO2avWjmvHpJtA94660gMzNCSFoikq+QAHPoZbp0BRJG/vfbCT8bIhwBONaB1xlINy7gCAngqEiQS9YIgpW5DnFjjns8/B4eSfC+btM1/ObRCC6ngfUck2h+cn1GOW+JYMeKIJ4EQc9FuRLljzzry5sCPjhG1TnluuvEppk9T/Y/H7OYc6KJvoJkiWchchxLxSspVlNMKaxShk6MvhC0qxxfIJyto1sPA1nBli7/EerHRU50EWHKKTEB1Mcf3iJQDKMd2m6HF9NphDXOSu3ZgmVEgRYrqGRGm99iF70RDms/jZ/6oU4mdsVP1U5wnbqif99UEnT+vmNh/e/5VCbVtCjyxjFYm11E2TG1k9fMS2n4O6tHgoTYqiA6Sln1iuEpeQmgwrEdtkNRB4EUQIgpFSSMklOV2Au9yXObbZVj1VFA1cd67zLfW0ECAVzvTsix17CLmx0+YwdFfL4nYLgKUHvxEcKDQjkgr4GTCxNUdmG4AI8=
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

This approach reverts the VMA skipping logic from commit dd83609b8898
("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
while moving the assertions to avoid the assertion failure, keeping all the
logic within huge_pmd_unshare() itself and allowing page unmapping and
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
Link: https://lore.kernel.org/linux-mm/CADhLXY4WPxzvzuiZPJmhS-9xMqRZ_qf7ZcFf5MXPgXbgB3_Xzg@mail.gmail.com/ [v7]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v8:
- Add missing revert of skip code in fs/hugetlbfs/inode.c that was
  introduced in commit dd83609b8898
- Move lock assertions after early returns in huge_pmd_unshare()
- Based on mm/mm-stable

Changes in v7:
- Rebased on mm/mm-stable per David's request
- Forgot to revert skip code from fs/hugetlbfs/inode.c

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
 fs/hugetlbfs/inode.c | 9 ---------
 mm/hugetlb.c         | 5 ++---
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9c94ed8c3ab0..f42548ee9083 100644
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
 
@@ -496,7 +488,6 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
-skip:
 		hugetlb_vma_unlock_write(vma);
 	}
 }
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


