Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458B0EF0705
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 20:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7046F6B00A4; Mon,  9 Feb 2026 15:17:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2456B00A7; Mon,  9 Feb 2026 15:17:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0D26B00BF; Mon,  9 Feb 2026 15:17:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 442396B00A4
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:17:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF7B8C131F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:17:40 +0000 (UTC)
X-FDA: 84426028680.22.6EEC3A4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38C4FC0007
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:17:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RBOU7lB5;
	spf=pass (imf22.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770668258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2KX1peBy+jC9AYVsIVk00mZBTEKYZUJkP2vokfR9y70=;
	b=BJSxMo2Gdg69Pi9iNvcw7BuR5yVI5a1Hql1L1OreYu3PNKRSBh8xY0Qtffvyu1C7LQMsA5
	vaoSFvbeNlDgFJTMuThH8YvayTH4M9TgUcnYcN46PCYvG4FiJMNxhJIa6bciKyfbo0iXy6
	O3pL01Vwdo8aqHMlVrfLPQoUnxa08qo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RBOU7lB5;
	spf=pass (imf22.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770668258; a=rsa-sha256;
	cv=none;
	b=kplHc9sX2Es+o/Cyh9a3sEmyt1xm8sw8L8eUMMT0de90MAPiSz+j1ki8FHt42BikyQvOHz
	FAjHUzc6BZ8nq/zIwc/4f5lcLsjHfp73qeBy1uvVHKT0T8BKkGq/izKsUOZR0d70aZEivn
	3Mo0gSuwDgukX1zUVEYss4Qdie6NUEo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770668259; x=1802204259;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mO9KvaCxSxjaKQri3HOqdCrZdJkCwNtMjDtvvxJltKs=;
  b=RBOU7lB5ekJGwie2mnsgwFlE1twu2fMBqoM+tXP9gGc9FTIHClCFHRSt
   68gX0lhMq05h2UsdxOuD3sTVYC5pjLQYbtph/SgYn2NjD/WosKZNAXhUl
   7DLoKajFT62VqBDtLkTQVVw+kFlKD1YUzfDq9ImfTKLiT2JC3aGibQl3b
   ASgfOyGHWT6XhmhEC0EZXTV1pKU9h6YkMYhEYkCNDMQYTHcLzsFoObQs0
   lIuKnHXf4xRT6GQOXDjQNEnG4U2MYuV7o56kKpjCY5xZhVJ3n75LpbQOV
   smZRxUZpe/vZV9/rv7jz2TFXFLo/W+as3Q5ZzWrSSXQAa0Ho6rAfOgvXQ
   A==;
X-CSE-ConnectionGUID: oO17zq+LRSuE55BYQwqOeA==
X-CSE-MsgGUID: XzW7pDToQB6ViTGOGheJbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="83231540"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="83231540"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 12:17:37 -0800
X-CSE-ConnectionGUID: DcmBMGoGTcOOSpT/zJuwiA==
X-CSE-MsgGUID: 9aPAnJ21Q3iYSJrPbkPMag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="249315748"
Received: from tassilo.jf.intel.com ([10.54.38.190])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 12:17:37 -0800
From: Andi Kleen <ak@linux.intel.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org,
	willy@infradead.org,
	Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] smaps: Report correct page sizes with THP
Date: Mon,  9 Feb 2026 12:17:31 -0800
Message-ID: <20260209201731.231667-1-ak@linux.intel.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38C4FC0007
X-Stat-Signature: 8fis34nbsgsyaoskbzuz6jb9nuy7e7n6
X-Rspam-User: 
X-HE-Tag: 1770668258-657247
X-HE-Meta: U2FsdGVkX19vVVBHPXvk+p3j7c/nU9q+E2rctiSnaHpE1OVPq91leFDiFGU0n0F1o5sTNBNvpA8wMho3KtFpdnFgcsfE4O1RIt4Hwqjr42qMRUcbnl+kxoSne+2FlwjFRh1nxRjyC+05NsnhOnJsIV2vtRT9PKFnaurarbc31o5zn/bwRmKZBub4CnIwHdtONdPKzJuB64rVPE7wBPOZD8FlvX/wzYxHvx6XJKf/ngatmDG1uGcOEOmuOU3yA84Xq2oNUYaRjHqUPxcjN83GGoK4ZK6w2AIccIii/LyMPPV+Zkq8YdTPQqxFXXcTj7hBplo4Fsfa0ilTzystHyJ4PzDWsonCPeiXlOWsoSiSR/GBKPyMsLjsBMSgGP/nlpQ0rTMuzgoIrZmvDRlFHugLQ7nT6guxYgAGwWWB3fkZYcGXvV0vE8en1txpFXmmG5pZBYPGu3pGNha4wcZhZYVidj1JtDMEgn6HerSX90ehGbAyimFAuXmMOe91u6g5meMMX5TZrlzBde8IX8qja7hWYVKuXpiqOr2x9iBMssMTbVWtTmMZI097nNW+c78i37h7k7YqYvUJWIE2cTasysDnUtu9KTkiYhWh7LB5vb5yGk1DgKouXzbp8u1eciiXQTy0rJ+sNpxVVBs0XhJEBKJ1JQpZRttxRF3eJWcjB/Ry74dc2SNA5DFVEqq51zn461E02OgqTNDMryYUBOQoQXUeW4r6XUEpr891odBn6OOmojtdfNfluVxADBVu2l9cl6+Q42vE0XXMfsdMTiAM6231m5r7mvbh5fNCyf5zVJzky5y4IyOzfHTSwVvY+QT+IbIcfUm4N9jaioBF8Iil+iKR+YlrBkP+DusAk4Z0m3rjRRfarEZRCSMMIoLYtNS5leELFB1bYsbk3SHWZgQZrMR3MYxRyx6rfE70VYdTnC5taFyY5VqoI/1p3d4eqfIIPIoWSdneKH8OL8xQ/+xivHC
 LzFva6ik
 HmHq6chCXH0gkFWliL/9zzxaE5YDkbGHvXs4aWWdzpsZMgQRTvOLPxFImUlJcZJjsd0UxsljZEAv3mhJucXmWnWBJnMQhoqgoCUy3xhhcK/yiiSkdlzO/Ost/hyZSDs8/apmw5t4QRxISmm6Vzj86Twj5HMqOhpHWk3rBDnOf1ZUgOHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently I wasted quite some time debugging why THP didn't work, when it
was just smaps always reporting the base page size. It has separate
counts for (non m) THP, but using them is not always obvious. For
standard THP the page sizes can be actually derived from the existing
counts, so do just do that. I left KernelPageSize alone.
The mixed page size case is reported with a new MMUPageSize2 item.
This doesn't do anything about mTHP reporting, but even the basic
smaps is not aware of it so far.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/filesystems/proc.rst |  2 +-
 fs/proc/task_mmu.c                 | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 8256e857e2d7..7c776046d15a 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -483,7 +483,7 @@ entries; the page size used by the MMU when backing a VMA (in most cases,
 the same as KernelPageSize); the amount of the mapping that is currently
 resident in RAM (RSS); the process's proportional share of this mapping
 (PSS); and the number of clean and dirty shared and private pages in the
-mapping.
+mapping. If the mapping has multiple page size there might be a MMUPageSize2.
 
 The "proportional set size" (PSS) of a process is the count of pages it has
 in memory, where each page is divided by the number of processes sharing it.
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 26188a4ad1ab..9123e59dcf4c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1377,7 +1377,19 @@ static int show_smap(struct seq_file *m, void *v)
 
 	SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
 	SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
-	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
+
+	/* Only THP? */
+	if (mss.shmem_thp + mss.file_thp + mss.anonymous_thp == mss.resident &&
+	    mss.resident > 0) {
+		SEQ_PUT_DEC(" kB\nMMUPageSize:    ", HPAGE_PMD_SIZE);
+	} else {
+		unsigned ps = vma_mmu_pagesize(vma);
+		/* Will need adjustments when more THP page sizes are added. */
+		SEQ_PUT_DEC(" kB\nMMUPageSize:    ", ps);
+		if (mss.shmem_thp + mss.file_thp + mss.anonymous_thp > 0 &&
+		    ps != HPAGE_PMD_SIZE)
+			SEQ_PUT_DEC(" kB\nMMUPageSize2:   ", HPAGE_PMD_SIZE);
+	}
 	seq_puts(m, " kB\n");
 
 	__show_smap(m, &mss, false);
-- 
2.52.0


