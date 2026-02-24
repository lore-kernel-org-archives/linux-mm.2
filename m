Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2755EE9B250
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17F46B0088; Tue, 24 Feb 2026 06:09:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2AA6B0089; Tue, 24 Feb 2026 06:09:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19346B008A; Tue, 24 Feb 2026 06:09:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE0E66B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:09:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63CDF1C458
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:09:54 +0000 (UTC)
X-FDA: 84479080308.01.20807C1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5D4044000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:09:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771931392; a=rsa-sha256;
	cv=none;
	b=C9I2DZB1X0DXgiR8Uvf/B1QBabacs0HfWpSw9XK0h3soTaWaed8boIYBAAGrkBghqpbIOf
	36+gwjgUJsIH7HFJTMtTS3Uh8uSaeeu5SVAQ/45kGmpCYFAQ4Fug2Fa2xvVWidAku4E6bq
	pnNtptOzM8bKW40JKi3ZRQB7qRn/7HA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=o0oBOTjqTrrzki2MBdlf2XBLpm/SnnSZruUWuBU033I=;
	b=NPwgVsAzXbiAaOkrfw4dyBtoFwkCBSHgKLcXf8hb1rdimRylWw5Use8A4VvxEa1QOUEdUn
	JklJCIl2lqKJAWmcYIJacV0iCa/nlPF/7cgUXWg8/YhBUVlqY4bu6miriP+vFen1xPyi/v
	hkQrQa7sIwr5IM8y35zSAkOQnvF61Q4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC93F339;
	Tue, 24 Feb 2026 03:09:44 -0800 (PST)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4C0213F59E;
	Tue, 24 Feb 2026 03:09:47 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	harry.yoo@oracle.com,
	jannh@google.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>,
	stable <stable@kernel.org>
Subject: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree folios
Date: Tue, 24 Feb 2026 16:39:34 +0530
Message-Id: <20260224110934.881360-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D4044000B
X-Stat-Signature: eeysmzdjjq3o4fqkqnjxzewo9ty6agxh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771931392-960533
X-HE-Meta: U2FsdGVkX18GwF44+/YMAp8b06NdSLN6OebxRBlFRE0AqEqttPTvegPtZD5xOlKC7A5gnhYi9Q7csGMTTOnX/GjPpKWZVmAtDDsTHIoS7/APvdi40BnQVQ4+4iGcr+WmS+eB7kKQWQTTq7EhQmAyOOTBL1sXRz3ZeJc/aC0Ex3AWvVU2xBP4F91VIw4KhoEVH0RwYpnexIbq3zAZF924H/SZsg5jVnKoMkj76mwmh6pAIXm7lkTCWb5trWWn+padAz62rW9YKI84gJ3jgxpDBQPLzglzsiibkt3TwiLdQQXstloT1av/AnhRPON0+1U0hfoDBnhPcjZohfqRk8JiwfZIlTwhYUYCyw9iSofLEyhcLpIxBGwkd4YWUDHxnpW8tbuE84MpMyF0dEmk1WZY5C9/fONjYXQB0R2ZmFMZNhOyTiiHmuvc/ndfgs/YWuYLTL7fSBCyWyzfEwPQFOuRI4Xe6WIZ4CJNOIfqfGtpYeCrwuN5+AjxBy7sRgAhh5HNVaakbm80oKATzE8/mWM0W6UQr2Au1ILXD3tGXrBxJd/aUap1t3xXOecRWxB9HMD7SAIT9Ldikg151dEQ2FcyootVZnuAawICZ1EIygM/XVUj5cXmYLoeBAt/JlMF9j7imyjaE52ecz7g4uDmtTae53LmO1S5aK5h7fdMBjMS9lkqALuOP6Y63q9/a0YLNBpGk+FMgd9BDzXE5k2n/sSutmZgnWsPubpKaZvvXcEyQnP95tR76Y83xQlvpzPRwx+Qx6z9NJC0OEr+jLqbWgk9cL3gSVL1wjBRhSDkGu8bMffrNGscTE2rj9T47UEV1I9oySachsbAUr2XtOLUB/Lz1+VwxyNnTrwrIeUX+DI4Ze46grHGFGPjBD3aP75VPrGViU33tMUGZ966IPcS24WeYZrBel+UhCJtWJdyoHCh2PhpUzyUCiAflQAezU/SHsatDexB3cBExftyW/ZEvDY
 9s623vAB
 x+7D09tp4pv/WqO8WBDAtKt2+dJ7YN5Qq8K5fHG0FfrDXgPhHGIp153yNHkqeBTQM7rCrAxEo9iUbvBNwjiLSgEINonfvOIvxEm4xiFz6up13N5l6Pvgi+wID1G3danBWWuPVPlFzYnxujazfs+O3HMkIV0FaHT6c3JAimCxRB7Iuo68=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We batch unmapping of anonymous lazyfree folios by folio_unmap_pte_batch.
If the batch has a mix of writable and non-writable bits, we may end up
setting the entire batch writable. Fix this by write-protecting the ptes
during pte restoration in the failure path.

I was able to write the below reproducer and crash the kernel.
Explanation of reproducer (set 64K mTHP to always):

Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
fork() - parent points to the folio with 8 writable ptes and 8 non-writable
ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
the folio as lazyfree. Write to the memory to dirty the pte, eventually
rmap will dirty the folio. Then trigger reclaim, we will hit the pte
restoration path, and the kernel will crash with the following trace:

[   21.134473] kernel BUG at mm/page_table_check.c:118!
[   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[   21.135917] Modules linked in:
[   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
[   21.136858] Hardware name: linux,dummy-virt (DT)
[   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[   21.137308] pc : page_table_check_set+0x28c/0x2a8
[   21.137607] lr : page_table_check_set+0x134/0x2a8
[   21.137885] sp : ffff80008a3b3340
[   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
[   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
[   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
[   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
[   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
[   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
[   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
[   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
[   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
[   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
[   21.141991] Call trace:
[   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
[   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
[   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
[   21.142766]  contpte_set_ptes+0xe8/0x140
[   21.142907]  try_to_unmap_one+0x10c4/0x10d0
[   21.143177]  rmap_walk_anon+0x100/0x250
[   21.143315]  try_to_unmap+0xa0/0xc8
[   21.143441]  shrink_folio_list+0x59c/0x18a8
[   21.143759]  shrink_lruvec+0x664/0xbf0
[   21.144043]  shrink_node+0x218/0x878
[   21.144285]  __node_reclaim.constprop.0+0x98/0x338
[   21.144763]  user_proactive_reclaim+0x2a4/0x340
[   21.145056]  reclaim_store+0x3c/0x60
[   21.145216]  dev_attr_store+0x20/0x40
[   21.145585]  sysfs_kf_write+0x84/0xa8
[   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
[   21.145994]  vfs_write+0x2b8/0x368
[   21.146119]  ksys_write+0x70/0x110
[   21.146240]  __arm64_sys_write+0x24/0x38
[   21.146380]  invoke_syscall+0x50/0x120
[   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
[   21.146679]  do_el0_svc+0x28/0x40
[   21.146798]  el0_svc+0x34/0x110
[   21.146926]  el0t_64_sync_handler+0xa0/0xe8
[   21.147074]  el0t_64_sync+0x198/0x1a0
[   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
[   21.147440] ---[ end trace 0000000000000000 ]---


#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <sys/wait.h>
#include <sched.h>
#include <fcntl.h>

void write_to_reclaim() {
    const char *path = "/sys/devices/system/node/node0/reclaim";
    const char *value = "409600000000";
    int fd = open(path, O_WRONLY);
    if (fd == -1) {
        perror("open");
        exit(EXIT_FAILURE);
    }

    if (write(fd, value, sizeof("409600000000") - 1) == -1) {
        perror("write");
        close(fd);
        exit(EXIT_FAILURE);
    }

    printf("Successfully wrote %s to %s\n", value, path);
    close(fd);
}

int main()
{
	char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if ((unsigned long)ptr != (1UL << 30)) {
		perror("mmap");
		return 1;
	}
	
	/* a 64K folio gets faulted in */
	memset(ptr, 0, 1UL << 16);

	/* 32K half will not be shared into child */
	if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
		perror("madvise madv dontfork");
		return 1;
	}

	pid_t pid = fork();

	if (pid < 0) {
		perror("fork");
		return 1;
	} else if (pid == 0) {
		sleep(15);
	} else {
		/* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
		if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
			perror("madvise madv fork");
			return 1;
		}
		if (madvise(ptr, (1UL << 16), MADV_FREE)) {
			perror("madvise madv free");
			return 1;
		}

		/* dirty the large folio */
		(*ptr) += 10;

		write_to_reclaim();
		// sleep(10);
		waitpid(pid, NULL, 0);

	}
}

Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
Cc: stable <stable@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Applies on mm-new (commit 018018a17770).

 mm/rmap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index bff8f222004e4..501519844f290 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2235,6 +2235,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				smp_rmb();
 
 				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+					/*
+					 * The pte batch may have a mix of writable and non-writable
+					 * ptes. If the first pte of the batch was writable, we may
+					 * end up restoring the ptes incorrectly by setting the
+					 * entire batch writable. Avoid this by setting the batch
+					 * non-writable; this is not optimal, but improbable to
+					 * reach by virtue of being a failure path.
+					 */
+					pteval = pte_wrprotect(pteval);
+
 					/*
 					 * redirtied either using the page table or a previously
 					 * obtained GUP reference.
@@ -2243,6 +2253,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 					folio_set_swapbacked(folio);
 					goto walk_abort;
 				} else if (ref_count != 1 + map_count) {
+					/* See comment above */
+					pteval = pte_wrprotect(pteval);
+
 					/*
 					 * Additional reference. Could be a GUP reference or any
 					 * speculative reference. GUP users must mark the folio
-- 
2.34.1


