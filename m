Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16389D3CC92
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 00:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 615706B0005; Wed, 14 Jan 2026 19:54:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC8C6B0089; Wed, 14 Jan 2026 19:54:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB7D6B008A; Wed, 14 Jan 2026 19:54:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1586B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:54:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4739138F32
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:54:31 +0000 (UTC)
X-FDA: 84332377542.21.77C491F
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by imf30.hostedemail.com (Postfix) with ESMTP id 670DF80004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:54:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ispras.ru header.s=default header.b=CuH1fcnd;
	dmarc=pass (policy=none) header.from=ispras.ru;
	spf=pass (imf30.hostedemail.com: domain of pchelkin@ispras.ru designates 83.149.199.84 as permitted sender) smtp.mailfrom=pchelkin@ispras.ru
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768438470; a=rsa-sha256;
	cv=none;
	b=FNQk/NuyZ+cFqkXzv2JbAEl3xjRh2Lf/vb1VaYQMTK/F2lKkiwSWVlwBFk22hlN8kFWklb
	GoYeUEMItf870SEmRM3uXJXvmOLF3UBE3lsvLF7SkB7LjPeCcBDK2Cqfk1Zm7PEWEzp/VA
	1H9WtI8NoDX/P4IQuYgiJWIFnsAj66w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ispras.ru header.s=default header.b=CuH1fcnd;
	dmarc=pass (policy=none) header.from=ispras.ru;
	spf=pass (imf30.hostedemail.com: domain of pchelkin@ispras.ru designates 83.149.199.84 as permitted sender) smtp.mailfrom=pchelkin@ispras.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768438470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=07dpiY8kEY0GFcUy8qFirliZcsifX5zb7aQFpXv8mdk=;
	b=CY8LuNDPNtO9cZki34FJ3pWC8qnXW30kw7nU7lNntf+RU4XJjRx3jo2xqkT4k4SWytNoum
	7IlvG7OgLEfI7ZdgwLpRKhwFSDvfkvAbuViM6ksz0HGGhYJPWmeiWUaWEhel9pw6MGS1Jg
	47lU9p2BZhwLiYL4hWqR0zcyhoobYMo=
Received: from debian.intra.ispras.ru (unknown [10.10.165.10])
	by mail.ispras.ru (Postfix) with ESMTPSA id C4BB7407795F;
	Wed, 14 Jan 2026 18:58:02 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru C4BB7407795F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1768417082;
	bh=07dpiY8kEY0GFcUy8qFirliZcsifX5zb7aQFpXv8mdk=;
	h=From:To:Cc:Subject:Date:From;
	b=CuH1fcndh0lXvPTo0rn/Y+U9pKgds0YKQya6T2gKdmRU504AtbeSOI+LLGyuzkvxE
	 +Te0rfQCvkIdEaanOsp/J3qcq+k70Wk/CeJK1rC88V041b+zzksrd+zYI5rtf2taGP
	 KSa2aQt+LJXlrca5a/OwnZ1LE8O4GB9CkBHlyMXo=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Harry Yoo <harry.yoo@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 6.1] mm/mprotect: restore pmd stability check in change_pte_range()
Date: Wed, 14 Jan 2026 21:57:45 +0300
Message-ID: <20260114185746.816527-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 670DF80004
X-Stat-Signature: oois8qn3t9535houhrz5uec5rikn1eqc
X-Rspam-User: 
X-HE-Tag: 1768438469-46181
X-HE-Meta: U2FsdGVkX1+O47rDnWxl6Nec1Ae4ar4WHH9S0Fwfa036h4Wjo97WXMhGEJZMHrf5g4PyDT4OBypBeO2WEV0KIF1jmqITqHcdO1WbT3Ty3VJfSL1HxV4WCsgGDt5RGHeBvbQIRB1aDme9+WHuirzVzKrWk4BSWfnrPm/KNNi8LUjrZTFBflSCtnb11Sb9OZzG8iI2/VQavMFtKHPntygsuBDpYGuHCjUJCI/xMyYqMa3kwSjgohNiAt/7mvEmYq6Nc+VamaLzyapgeHrdnx7/E5WK7c2EHPjcdjD/sC0WBKytmBwphuLJSnn/DRbyBP3KKnfV/qRvnh3oLOXoNKwvaosGr91UESWfHT9HyQh/KLTFABeiE0MLPnIwmMXccT74ZDE0fq3NfSeu/tzx1CVdM/991VYi9px6u2GzguiZjvDPNiEz2hjlFCRfk9W1ihBWoWZ7HLItZ0Rs9sn0k3ao2ZQQFO12NzNNh8YEUt9gJ8eE+jw6TTA5n5TmLD5mWvU0bUejUWtoRxiFUOcygvXYTMjjHxvx8TAFmbZUse60rSxA5BGK4KOtMyr5dcTLy7ZTkbwaaLPoY9Zhh7bB8S0LF6DmtX+UtbDPrUuGFwOvX/LRAUOVTrUBq5sZhQFn6bkzo+8sDZ2RGe0JqfvQJX8erqX7u7ebwLpWEpk82v+bCOmxZI/DF2Mivc2XNQGF3iPuxwYXXU2QCLhWh+bcH/3g1PfCyzK8/dS3ANCek741BH/JBpCAvh/Yjf0DJI1hyzCWQcf7Gi0QzgPZr/ZRd0JOzRsHqgVUWPKg9ezN8A7EPq0a6nK5TlGCeJnlXHJB3uj73N+IHmjyxcIrpiWkLKJ4v2uNLM6kdsu5+GeTqekE1ZWt92JjCpijGRpTTolNRMUnWTUj0ROOg5T1zXftA+gSD80V8C53godSQ2homj5NX1EUu6GZgfzzvi9NAY41QxgIIb2kvFm7tk7OI7t1AoE
 ETXBkcAG
 QLi6g3/jf0b67ZNkymMTAp6VSHBgzUFD3QR5Hjxy2U5GGHAE1lYRQMe21MH2jMs8/ClDDYi0Wp1enrqYOhZ1UrzkvLHYnzEftuKipdO/xwgDs1Y/BmvXqYSsQa5LbJvhnG9Em0JCNzOHgjQiBtCf3IFYpjRfNqIIr2LqoUjrZcz19BXd4ZgzVXXyyUCB1hg9YzPHWrWT2bOEWIM2ROxLGlqLDPa1YqjzdYtmgkK7Qe3C9GTkOW3Jfx8eLkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No upstream commit exists for this patch.

There is a crash which started to be observed on 6.1.y kernel after
backporting a modified version of commit 670ddd8cdcbd ("mm/mprotect:
delete pmd_none_or_clear_bad_unless_trans_huge()").

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 PID: 23316 Comm: syz-executor.6 Not tainted 6.1.160-syzkaller-00409-g94ae58088937 #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__lock_acquire+0xdc2/0x5320 kernel/locking/lockdep.c:4919
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5662 [inline]
 lock_acquire+0x194/0x4b0 kernel/locking/lockdep.c:5627
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x27/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 change_pte_range mm/mprotect.c:91 [inline]
 change_pmd_range mm/mprotect.c:401 [inline]
 change_pud_range mm/mprotect.c:432 [inline]
 change_p4d_range mm/mprotect.c:453 [inline]
 change_protection_range mm/mprotect.c:477 [inline]
 change_protection+0xa1f/0x35e0 mm/mprotect.c:499
 uffd_wp_range+0xf8/0x190 mm/userfaultfd.c:748
 userfaultfd_unregister fs/userfaultfd.c:1646 [inline]
 userfaultfd_ioctl+0x38a7/0x46d0 fs/userfaultfd.c:2037
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x19a/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:46 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:76

The reason is that a pmd_none entry made its way into
pte_offset_map_lock().  It crashes when USE_SPLIT_PTE_PTLOCKS is set.

It seems that pmd_trans_unstable() check shouldn't have been removed from
the 6.1.y version of the patch, restore it.  Upstream code, starting with
commit 0d940a9b270b ("mm/pgtable: allow pte_offset_map[_lock]() to fail"),
has internal checks for that inside pte_offset_map_lock() itself.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 670ddd8cdcbd ("mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---

I've tried to follow the original discussion [1] regarding the problem
this backport is supposed to solve and how it was tweaked for stable
inclusion but failed to find whether the pmd_trans_unstable() check was
dropped accidentaly (because upstream commit does remove it as well) or
there was some reasoning behind it.

The backport patch is already in 6.1.160 release so I guess the fix should
be added to 6.1.y branch directly.  Looking forward for your review and
comments on the problem, thanks!  I can provide .config and reproducer if
needed.

The backport patches are currently in queue for 5.10 and 5.15 kernels
inclusion so they still may be dropped from there and reworked accordingly.

[1]: https://lore.kernel.org/linux-mm/20250921232709.1608699-1-harry.yoo@oracle.com/
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/

 mm/mprotect.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index f09229fbcf6c..ef6a360ec088 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -88,6 +88,15 @@ static long change_pte_range(struct mmu_gather *tlb,
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
 
+	/*
+	 * Can be called with only the mmap_lock for reading by
+	 * prot_numa so we must check the pmd isn't constantly
+	 * changing from under us from pmd_none to pmd_trans_huge
+	 * and/or the other way around.
+	 */
+	if (pmd_trans_unstable(pmd))
+		return 0;
+
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	/* Make sure pmd didn't change after acquiring ptl */
 	_pmd = pmd_read_atomic(pmd);
-- 
2.51.0


