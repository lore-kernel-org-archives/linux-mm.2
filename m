Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33955CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7229F8E0085; Mon, 13 Oct 2025 23:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D29F8E0007; Mon, 13 Oct 2025 23:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A518E0085; Mon, 13 Oct 2025 23:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 451958E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:26:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1D7E5A743
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:26:43 +0000 (UTC)
X-FDA: 83995282686.03.9ABD6FE
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0C2044000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:26:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lb4vY0UN;
	spf=pass (imf07.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760412402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2Z2NlKgP/sNpQxsAzBMmC/fbOmtwwCUWX3Npz5SEPkc=;
	b=1jVs6gRNT2kgpfrt2SXj+JB/29PJSRLGF1K38yTGSEfXbRnqtcIJA/jQ41zEaxT/A5eGBd
	/lQ3C3WPnXKSLNdZWAfK0qvbtwjkVkpNsQOoX1xPUY4eOA0iqSTYa5OP+gAKnQ63cYZMn4
	qXmGWq44uOi4dA+GaP66dOkwDUzTyO0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lb4vY0UN;
	spf=pass (imf07.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760412402; a=rsa-sha256;
	cv=none;
	b=6Tbqd82mikJiSgiAmkJ303Rl55Z0hcSy7fgzbKMjAW/VxAHxDlxxxNz6+MGBwT5bQGRFkm
	a5D9nUudl5kcGBXBhhoDPW/6nZ18dp0Iq3T/3JqQo7OTBY1BFuKlY+fag+1/pt/zjpgkDR
	O+nCbeay2YA0OeSAo4/8TTBJCiBpaNc=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7810289cd4bso4629476b3a.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760412401; x=1761017201; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2Z2NlKgP/sNpQxsAzBMmC/fbOmtwwCUWX3Npz5SEPkc=;
        b=lb4vY0UNLIW8hQ4naTm6mK250Ku01Sksc/F6Z9q+zNt85+rNjtqsUOQnWVAntD9Jbg
         RjtjKJoCKBsw4u+hObXZEbi1EHCYx7REGyXqv+nw4a20wGoV6JpeOxOQpoMFxzjRcRO8
         Y1Djmo5qE6wtAK59lxrjJ3lPxrUzTfaELFXt3jsXJ43noS2hFVPbMEI4MLMyNytr4dlg
         D5P6jdjeDvezZrfsB8kzagMqNg6OUJ6l5HUv2cg9PmkZsBJofhYtk1Z+hd8s3HuPh4V4
         /6/RupTwjkBoOdruyg5GC6R7aeIotAqC+hjkoSfnUO/Vp7hxQhBAZbiszBzpJh4KRj+d
         MLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760412401; x=1761017201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Z2NlKgP/sNpQxsAzBMmC/fbOmtwwCUWX3Npz5SEPkc=;
        b=AK9bSBClW62c6pNDTTBcYbMkaBjwAFeRn9DPa0oRQ9BfiuHgb5g9q6SFZSm7u/K89Q
         vACl1DKP3YtS5IArCYDmw1f2p1qsPdRT4nU7c1IEdV+lGgeqgvttwt5WjW0knPtaGfO9
         QVpZJ2yayhIb7eBnrB7+YMv/q23MeUf0xrM555LbcsYukblFoMO8GRmoyc2Sorq9suNO
         FNXaD0XnRs8xbZ75ncReR7BLpXgHyqBI2WuK14FHj6NMfD3YbWuLtYD1ikyAulQcKxWs
         OEtgPe+mG97+A3DZzWW0i/8+GTdKWUOkgxtBqq0c4Okdx8B3BhRSyry0fhcUxammWHAm
         urxw==
X-Gm-Message-State: AOJu0YyVlngDBVHCLThkmzl8n05fNFUN6XmWKxb3dL9O0YWJbqUJK4bT
	dlmB0L3A4z9pjsIKzkjFWIVM4997OTfqSyeGSgQ0sFaA6bcHyhXCfeSB
X-Gm-Gg: ASbGncsgi1LvdnDYLf36PW9btkiDhvbwbG7BxRiu6GeRF085KpYOMLh2nz5THWK8Kp+
	hDoyEUpAoR/kzC1u6j85i3MYWyEBkVpTnmVOPqdO2eXHKaY6KJiPtTRsP1BGBWJh7MaHuhxP9bY
	YwA/erAOwZ5oCObQCXWBHqMt3WcKmygkuUht09kYFyM/xR1R38S4lKs+hbkJ2nd4vBbO2+kowIe
	CVy42gD0AtSY0rcwD3WZbUo9SKG0vnAM9ErwNcmTNfrzm+U3caYBqMEIKQQtV/Tw6DZ1GTMSLDf
	LtyGqtJLKcQWhUShW7OgrIUrU+XytC7ahMqfoFnde1EsF4WigvWDbp0E7SJTEv3c+cHjn/Rm9nd
	qDoDZLv9CociMYrpq+4K5ft/6gNTS58masUb63r+PKoPE4JVKsJMNTi0k9eUdUlYWz9dtG2+2iU
	BSQ1zrzpd5U9XxKQ==
X-Google-Smtp-Source: AGHT+IHiLyaDYcsWx+W3f+TMyLFs0ZaeLr7rJrtuKhZhf00wDHV9m8BCbHrvN/bPmejb7TkCpfTpuA==
X-Received: by 2002:a05:6a20:2446:b0:262:4378:9df2 with SMTP id adf61e73a8af0-32da845f861mr29523182637.44.1760412400792;
        Mon, 13 Oct 2025 20:26:40 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:389d:c391:4ad4:fa2d:b790])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b0606f0sm13673109b3a.15.2025.10.13.20.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 20:26:40 -0700 (PDT)
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
Date: Tue, 14 Oct 2025 08:56:21 +0530
Message-Id: <20251014032621.344209-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C2044000C
X-Stat-Signature: knqw5hup4jh7ewp4mazqtactye6dymzt
X-Rspam-User: 
X-HE-Tag: 1760412401-659930
X-HE-Meta: U2FsdGVkX18xnsTs/pGJS25sfaY/UoS5NS79JrzgEOaIOQDr6cUr5kG9Rs+Q6tG4V55GVgmyFKgClJhOwu5VlTfORIQnB8L8AapmbHv0sHopJWTPGdqLU5vp+DG6KTkHVdrPYQDPiJyxtGuVcBLROR9LQ3ZW7A0CJ1iPpsawvoEnhsNOrfHsjhQmU9Z8fHbfy9y57fBpxiK8Z57AqD6N5XKYR2eD2A5cBwi/X88mLlJDjcMC7KbwksaXjy8AarP9T21dEITiq4jbWSMCmlQYnH/KJT+PPFkvWloohbdcxiwXJWG8xtKqhrgL04zITFPoidUxYM7RHljBIYjTJd1E1AYxQSZg3g2C5v+Pf3CFDOSmI2TjDPaPazeq3boL6HU2htRzxV+1QupT1NeF2wH7XwnVHpeP3IOPYo2wEAAdizHCW0HmhNVNKii20foStIuAb27PtHfqC+/zndxsCc+UNB6xkzOm65tV7Afo3aUqiPmUPJJTi9oFtE8i4WgXfQSehqUl8WkkDZ80MUXzshF5SgerzFslaVz8PLPdHNmQjosU/Dz32FvMgB6GIx3kW41cuOBXxqAQ4JiFOiusvotGxPBlo+a9RThYsdlHq61cwF4SbsSJHFmFLp823lgLAjDUzfbJxwB1lIxG7yU17tAaqPTGoazzgiMS9DVJv8MKF1szQXwhBF+DE5FjQ2SA5CjvYu+aMtAJd29/nHUaVSN+QzcdYsuSkSH9YuTaIxO1PKe2ksso2ue0AU6TJnyoY+SI7jB6C1T7UaHbP6EZjuHDCg8EKSpCHC3rlMhPWa7JKOU+VmD40bmcWDYg9ruO1HfspGuUTL0mLmZ4aOyVQ2mcm09MFN/K6asOycyhFhzoYKa2MRNmAKTMUr9X3XhB9FRV5KEorPXgGEuWpiDN1LgS7qlKRjcsMyn1SQTPGD0PJ6/KNqj66daaXkA6kNML3ZNpARwiRF2wAAtGxAJKVQc
 DEkGYJLn
 Z4l6KdVHHhygk09/SyDvFNyPxFKZCGPl6QQieFKvsNn20CI9FLqllkMCuwFXIKS61Np4BiWve8KdnmDvhBfgR9bRp4cCf0NZpUIoVdewOUUd0YJopBl5oVBOd6kJv/PUu99/TlIoBoce8fBeuwdt5IDAoKWNYERPGr0skZzmsPc01zpP5zPfk/2g1RCWRkRRiUE0SaZ7x+i/kjKQ3HGd/B3KkjMS238DJduXL7P/M8EItTq/QzG66N7a5xmobY6X0zQlCJFqaw+IgGl5lUznHQMpk8MuDFREgyQu2iviVdCMKK3vR/0hoEf1PpXu04WiX5m/bE72vBbE7wcgy3NoT05GOlbnwLaSQu7uD3vPxEpoFMyMHmvBnTGazynBjdefNxx2i5q7McvqErCbSvAVNkQIkhuGO9faPdYFyPQjVqaZjiLXrM+yGpikQ8VF9Vqu8s/KZMvJUsRo+IxzTcPLpatAsXS5wL3YeJ5OD+tmo3N5ziGV3x0NWrsS4QqiVfEuuDtqoA4brK6Fux56Vsd8G+gk3+ICiGZxTfJpbUfVnrwFRlSTIGcViLgK0Z/KD42SXc7l6h4LLnwQTqEwZSv6p4mBBpFEMdCZxqSFDEah0Xv9909SDwjExNCkfoRwpn5F98H2VYtBSId3BXd/YDCiPVUF8TCs2gkk4ELfqATrK8f2gCIr6MnOxoLpzJRWXJZ6QQsafP8sPj4HFndECbnchTUp6kA==
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


