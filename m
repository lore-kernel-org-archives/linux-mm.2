Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82C1D4A5FD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 04:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B9A6B0088; Thu, 15 Jan 2026 23:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0BAA6B0089; Thu, 15 Jan 2026 23:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AD96B008A; Thu, 15 Jan 2026 23:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFBCF6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:29:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B215D140520
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:29:12 +0000 (UTC)
X-FDA: 84336547344.03.F101C82
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id E9C71160005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:29:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Vaf1jmIH;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768537751; a=rsa-sha256;
	cv=none;
	b=ZN4sYst7Ol4Gs9Ehau/DKi8qtlKGtPxQHAnNWJ4B/55MbhqWSW5zCJ5RnSrkCQ1sBE+WLE
	Q51wR7/Wa11dUXftKvctfLd7ifCr5e6OBw9Liks25PkhQBH/G2b9U03/BdyQqO4i3IoBnc
	6uTPZ4lCrFl49NeHIFXEGGtAhi5HtQY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Vaf1jmIH;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768537751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eP3njpltV1K3EjB4QjEgVjSquOOd4TFp8ei/1PUu6Eg=;
	b=DEwczjZ9rxAtDO+g/K2oB0qpoioZH/igkNqdHZauH3cy3hvvlG6/pk9wISxrv+N/C2izPQ
	lSBZHAMNahborpJ/4eaO6FatmOfFoR+7a281NLiJ0dYBnYQQDpYVDzmjR7DPIDGngFRF9W
	656FVrZAtg3ijrFvmWxdApH297ZdZ+c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=eP
	3njpltV1K3EjB4QjEgVjSquOOd4TFp8ei/1PUu6Eg=; b=Vaf1jmIHGcNwl9UAQR
	6BkVNv8uVwonPOQf4treTG49XEm6Hi5Dffx0PpzO2pHG1XBmSRbJk5EgGIaLRtXE
	KEizFlS+CY/8FlDMvxmuo+V3bHaRdPUjdJ2OlehSYSOkYufAmI3vBCvcnmWXIvgZ
	yNwI0ganUUDJPeu/ZD7/ca5jg=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wBnsI5jvmlpEDHXGA--.25381S2;
	Fri, 16 Jan 2026 12:28:21 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev
Cc: kuba@kernel.org,
	jackzxcui1989@163.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] mm: vmscan: add skipexec mode not to reclaim pages with VM_EXEC vma flag
Date: Fri, 16 Jan 2026 12:28:17 +0800
Message-Id: <20260116042817.3790405-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnsI5jvmlpEDHXGA--.25381S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3WrWUGw4UCFyDuF4UZw47Arb_yoW7ZF4UpF
	Z7Gr18KF4rJr13Z397AF47Zw15t3yrKF47GFW2934xZwnxWFyvqF93KFyYyF1Fkrs7XFya
	qr42yFWruw4rAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRAR6rUUUUU=
X-Originating-IP: [124.77.188.51]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbCvwV9h2lpvmXzyAAA3g
X-Rspamd-Queue-Id: E9C71160005
X-Rspamd-Server: rspam06
X-Stat-Signature: ffdc78cc6d8wkq5qgzakxh3z58p7suip
X-Rspam-User: 
X-HE-Tag: 1768537749-313012
X-HE-Meta: U2FsdGVkX1+th7DCN2edxXAvHJ7aCpBbf9PpXlYJ/YrNPn9axKca7a456Cj+uq96a4Qv5B99NE8kHMzJDyxx8S1hDeqFVcSfRxEGxh5EDqvzEMgmYaLCMy4vaNAiL95Wl4S1swdT/Y6ynGJcw4LKeHAiUmpqqfiNONiHe0yh/+p4lPtkqCBNT1IA1te72+60OEwflXuQzKTxmbiKT2A3X4bN+oeyUV4SpqJsE46jO47v9LW0LT/2O9gljiQbrAl81VcJvARoMV9JtccfpW9RYb3kEXwdpX6oQtcpzA5VdTJvx7TtWEIlaN0QyUm/e0pUfzu/XKBseDgPxilnqTfWJgRiaBAM7Xre2QggkHLsCBz0xFlCZ+OmszFykh3SbHElAJiwSRLuuFREW/Py+YKiW63Arzu9iifO41Hn603wCUIGZste5B40mzyArveRFc3ZaTw3RnM72+eNuiA70rdKP978QSYJ833lQBQvlKn8TwlEcojub00HxY+w6O/3Ullx1sx+YCyiUcKGM3HvLf1iLjbjAVTL20w0QklKrod2UCfSpw00thORSBwXLpE6L33uy5iRTD7GxR4nE1ROdjm15gjLAmXLbhWvK9z9Az7Oqb58TuWWexdT4GJ8ZK+p9kOuYOFY0gBAU4jJ3mLq0IudIoBQBmH976scSsKjJ3J41hNilNu4+ameGEF3jz7WbunKwKMGoxy7WqKYZUbOZRKg4iMytHMstJohb/vuIJFIdZwEtKxbN3sIotqbDRyPy/coSFuP3+nnLWoPdGK+92iO/uhYgCSo/5m0C0kWUmRbljGFdu41xB2e7U17yuhP+c9A9wecWg8mzmu1POlKBCVyDBhX0XLrxiFThifqAagMq/SnyfzYs6q7zqUkT5dwbfEO0AHkwjyPT/6B/guektYqKfd+Igc7rkS+nueJFQYEjXsqqaa4dFPQ1SycZruiaPFRvQn2anvrC1j5pX6oLLP
 XK9eGq/K
 Kj5SYYM2/oaKf/Hr9czd0itJzSkkSLIji53MYDlDbwGzb6zxjBVCIs5DVI/e4uMnraKgomVzXESF5kcthA8sjqRdOlNNNHDDUqI5lTrL5s45fkV6nQPLzgix+8RRmpCrLAqljsrzRqkxU/UkgG6Ex99STrNevrw5kojnvehA4nCfZjcYlBm7kySNyFjsp/rYxRzmkcFiPGFTnBXHsVRqoKzSr/8Yl5+dnurPxHuElCHclufVEqRxK1/JrzW2ZXcStUitQuRDqnbMu1WD4dEvuCXaJ5rTDLqy86JblZNUFhmroT6TgXEcSTKbiAHH4tTdDz5/kzw7TlToHyCZDmwIFlE2Akh1Tm3VPAJJaisho82ncO3U3hG366ssSu/Lj4ZW9qUdgu/TQjZeMNPN+NPNdU5KtG8MCgl0jTQVlKLhu0eRMcVTVhNJwu3ZcDt2868P3JUBBVcGbUk6gFEdTShmO0oxPKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For some embedded systems, .text segments are often fixed. In situations
of high memory pressure, these fixed segments may be reclaimed by the
system, leading to iowait when these segments will be used again.
The iowait problem becomes even more severe due to the following reasons:

1. The reclaimed code segments are often those that handle exceptional
scenarios, which are not frequently executed. When memory pressure
increases, the entire system can become sluggish, leading to execution of
these seldom-used exception-handling code segments. Since these segments
are more likely to be reclaimed from memory, this exacerbates system
sluggishness.

2. The reclaimed code segments used for exception handling are often
shared by multiple tasks, causing these tasks to wait on the folio's
PG_locked bit, further increasing I/O wait.

3. Under memory pressure, the reclamation of code segments is often
scattered and randomly distributed, slowing down the efficiency of block
device reads and further exacerbating I/O wait.

While this issue could be addressed by preloading a library mlock all
executable segments, it would lead to many code segments that are never
used being locked, resulting in memory waste.

In systems where code execution is relatively fixed, preventing currently
in-use code segments from being reclaimed makes sense. This acts as a
self-adaptive way for the system to lock the necessary portions, which
saves memory compared to locking all code segments with mlock.

Introduce /proc/sys/vm/skipexec_enabled that can be set to 1 to enable
this feature. When this feature is enabled, during memory reclamation
logic, a flag TTU_SKIP_EXEC will be passed to try_to_unmap, allowing
try_to_unmap_one to check if the vma has the VM_EXEC attribute when flag
TTU_SKIP_EXEC is present. If the VM_EXEC attribute is set, it will skip
the unmap operation.

In the same scenario of locking a large file with vmtouch -l, our tests
showed that without enabling the skipexec_enabled feature, the number of
occurrences where iowait exceeded 20ms was 47,457, the longest iowait is
3 seconds. After enabling the skipexec_enabled feature, the number of
occurrences dropped to only 34, the longest iowait is only 44ms, and none
of these 34 instances were due to page cache file pages causing I/O wait.

Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
---
 include/linux/rmap.h      |  1 +
 include/linux/writeback.h |  1 +
 mm/page-writeback.c       | 14 ++++++++++++--
 mm/rmap.c                 |  3 +++
 mm/vmscan.c               |  2 ++
 5 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a585..6a919f27e 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -101,6 +101,7 @@ enum ttu_flags {
 					 * do a final flush if necessary */
 	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
 					 * caller holds it */
+	TTU_SKIP_EXEC		= 0x100,/* skip VM_MAYEXEC when unmap */
 };
 
 #ifdef CONFIG_MMU
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f48e8ccff..16cf08028 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -343,6 +343,7 @@ extern struct wb_domain global_wb_domain;
 extern unsigned int dirty_writeback_interval;
 extern unsigned int dirty_expire_interval;
 extern int laptop_mode;
+extern int skipexec_enabled;
 
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ccdeb0e84..e7c4a35ad 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -101,7 +101,6 @@ static unsigned long vm_dirty_bytes;
  * The interval between `kupdate'-style writebacks
  */
 unsigned int dirty_writeback_interval = 5 * 100; /* centiseconds */
-
 EXPORT_SYMBOL_GPL(dirty_writeback_interval);
 
 /*
@@ -114,9 +113,11 @@ unsigned int dirty_expire_interval = 30 * 100; /* centiseconds */
  * a full sync is triggered after this time elapses without any disk activity.
  */
 int laptop_mode;
-
 EXPORT_SYMBOL(laptop_mode);
 
+int skipexec_enabled;
+EXPORT_SYMBOL(skipexec_enabled);
+
 /* End of sysctl-exported parameters */
 
 struct wb_domain global_wb_domain;
@@ -2334,6 +2335,15 @@ static const struct ctl_table vm_page_writeback_sysctls[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+	{
+		.procname	= "skipexec_enabled",
+		.data		= &skipexec_enabled,
+		.maxlen		= sizeof(skipexec_enabled),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 };
 #endif
 
diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d5..5f528a03a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1864,6 +1864,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	unsigned long hsz = 0;
 	int ptes = 0;
 
+	if ((flags & TTU_SKIP_EXEC) && (vma->vm_flags & VM_EXEC))
+		return false;
+
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae..c9ca65aa9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1350,6 +1350,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
+			if (skipexec_enabled)
+				flags |= TTU_SKIP_EXEC;
 			/*
 			 * Without TTU_SYNC, try_to_unmap will only begin to
 			 * hold PTL from the first present PTE within a large
-- 
2.34.1


