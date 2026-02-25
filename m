Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E491EFD375E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0692D6B0092; Wed, 25 Feb 2026 08:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040B26B00A4; Wed, 25 Feb 2026 08:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82546B00A5; Wed, 25 Feb 2026 08:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1C896B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:43:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FD0E8BF99
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:43:50 +0000 (UTC)
X-FDA: 84483097020.30.12BFE59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 789BA40006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:43:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DxRkY5y2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772027026; a=rsa-sha256;
	cv=none;
	b=30hvK+jA3Hfa+dZAn6H1GN5L1gfXn7v7DyGjy+DGgwQjrN4qM6fXLdTByY3yYgOc+Q+xp7
	wTzJeV70I+oF+PXEIeqUvR3XolaRRMxH2WPsHDSSAf4a2O8LLasKdCMMUp7800veMwTCsp
	Pie5SS4fZnGfXsiUKZzs7CRGoq+5Ap0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DxRkY5y2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772027026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M7g/E9llXQ5kuibHxH8usT/nCYIuORTR4eDSgtVj2FE=;
	b=exodvmJ5vaCx+E1qn2PJYDooTbeYgS18GgDOXqOJqClFo3LPrbIRfeN282b91oG9GUXggD
	9zzsdwWK0o2CE0ZVRlaJHTQesftyRkO6Uwweb8PdemeCYS7jj0KDOaI106VZqh7KMSmv5F
	9gyDCkVGvTbLwDR05xBbZDa9fsa8Gts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB6DB60054;
	Wed, 25 Feb 2026 13:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56914C116D0;
	Wed, 25 Feb 2026 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772027025;
	bh=X1wEjjAYlFTfzQHK869ldggLOwWMHG36v14bBGfZGLY=;
	h=Date:From:To:Cc:Subject:From;
	b=DxRkY5y25Z2rF2Mj744oKM+l9U11z/v+T6At6FKy1NeMZxChGv7OChrkDnEXeNSAc
	 92DX8Hym9WgdcYTTjFJOlBVnLSdIfDHmYf9WX3rcTWmYh8+mzXlo8+cmRZq210nRQB
	 l0IAqJrqSDjwd3oLn5nSCEr7iT01xh/RXL0uWR/8fej/mJN9WmITFx0//l2fBHf4yA
	 eYyrJ3JVRV/bGXvNqa9r+aVfaGQFzXQMm/RYpYFe6Tnqakf5mqAMMzp0aQhsVEFBs9
	 8sIqatsxDlYXdFgAcR/ynQ4yGXagN+oWjorXojaIlCcURiVdcg/xpYYjWPPLXrax9J
	 Zo1Xjb14qsiaA==
Date: Wed, 25 Feb 2026 08:43:44 -0500
From: Sasha Levin <sashal@kernel.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>, Zi Yan <ziy@nvidia.com>,
	Gavin Guo <gavinguo@igalia.com>
Subject: VM_BUG_ON_VMA in split_huge_pmd_locked: huge PMD doesn't cover full
 VMA range
Message-ID: <aZ78kFBEA2SjgT93@laps>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Stat-Signature: extwgte4jksszsjbzka45tqb79ashj3t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 789BA40006
X-HE-Tag: 1772027026-971830
X-HE-Meta: U2FsdGVkX18OYqzieJ4QOBAgk8J3jouJQsBZWZgVTEh4vz4tt0HmV86IEsLauuQqLb0U9+PXPCxBjC5ytKm6BJmJgGs0kb4whUjZkhHV3QKEGKQj1iyQN3cGzs87WYFuy55vTa9hzpmLLMw7/YxQW9tl5hJ1Eq0y/oeTyZXYYf2/nJ74cbeb6xIIPQ6VKhWM52yc4zoxydsO3s7pY1+W+j8MQJRnIz6gjdZlGhGsZjhg6uGPoxUxVhPTIulh6YV6LHi6u/sULaRQSwD1XzXtUbBML+nYPoI0WOy0k313lqZO9+RF0Ito71/YWJfxedTVpsO1H04t3sujBvqP8n1QB5PTMgsRnuXAN3lvGsDdZEHDfaiVUi1thAuuu/FIFuv8MSqemrG8q1a/8yLB243kV7qaj+h2454n6aCrJUpRdSYoHnFACVOLnwwdqEAig0WbnloO/4IfgxdHerpMjHtwJ76JAyoIT1xdQQgLpUv3W0+Rf2VvRCG+MvuNArZOGCiRHqEqtBOtNOu+8QJoy9pIFZ5tlrFooMOju2jspg8MNOvmk5ATzjuOXn7uTf93+cGWlVfexbOTy/PEnyVNBcoNF9YcXI3I8O+LLyRq23IKD4S4itLIVgwTRWD0MVAQr+tJb9E8XLyy4QDFoN7u8r0XZW3oiHKlB+KN8Wld5SMSpKepkNTYYAYMJuwxJQbhgxy07shq1TCkSM0fw+W7/GU0Dwq+WiLdsFgT2xBJyXb9RGGRbM+ufZD2GLNhFl0bq2hfPN6Mp4kc2twztWJ3snqGr/upqqR1RX+0ebapLerRIE86z8UOXM68lXnJRd2FxQVuzXhAinWLtH++vFlWYmMuz4P9uduO0lpmSeNK7B+elOnXh8jKwF+sJCge3bo+fCmIyiRzWDI8LXIE18WonWe3x6ubvcFa4caHShmL7aNyxmdGSxYTtX1Hsdseo9XRSMR6iLzUZddsMwPk7Ufqcbh
 aUZ2ixnL
 /RNTS0eMbOv6KDOyM+CuMg1at7PXJf7hGzqkKSqBIpS2TfeZOInm8n0H2MGSBdYqC/LIOWANjhG6kP1mYUk1YxzMcSfFhHjacaTEyZPXUlgZjWNLlM5IwJSJF/r9i5IqkLvad9PE46Q9+qwaBOwEdDQPzDQhnONJPamk2uirdXRUiC5dsC/Z0Z4Cz2gYDdbQktLT4CeXHSeaAhhNb0NdKCCDKkzkqlIMopsp7wq5f2InjLgOJHtu4WpLat5EVJTFIAHWNdaVuvFrccpOpEETECdM2qcWSjMAzxzWxjjLBOPgn5DY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I've been playing around with improvements to syzkaller locally, and hit the
following crash on v7.0-rc1:

   vma ffff888109f988c0 start 0000555580cc0000 end 0000555580ce2000 mm ffff8881048e1780
   prot 8000000000000025 anon_vma ffff88810b20f100 vm_ops 0000000000000000
   pgoff 555580cc0 file 0000000000000000 private_data 0000000000000000
   refcnt 1
   flags: 0x100073(read|write|mayread|maywrite|mayexec|account)
   ------------[ cut here ]------------
   kernel BUG at mm/huge_memory.c:2999!
   Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
   CPU: 3 UID: 0 PID: 15162 Comm: syz.7.3120 Tainted: G                 N  7.0.0-rc1-00001-gc5447a46efed #51 PREEMPT(full)
   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
   RIP: 0010:split_huge_pmd_locked+0x11a0/0x2f80
   RSP: 0018:ffff888053cc7338 EFLAGS: 00010282
   RAX: 0000000000000126 RBX: ffff888109f988d0 RCX: 0000000000000000
   RDX: 0000000000000126 RSI: 0000000000000000 RDI: ffffed100a798e43
   RBP: 0000555580cc0000 R08: ffffffffa3e62775 R09: 0000000000000001
   R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000080
   R13: 0000000000000000 R14: 0000555580c00000 R15: ffff888109f988c0
   FS:  0000000000000000(0000) GS:ffff88816f701000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00007fe2ac1907a0 CR3: 0000000021c91000 CR4: 0000000000750ef0
   PKRU: 80000000
   Call Trace:
    <TASK>
    __split_huge_pmd+0x201/0x350
    unmap_page_range+0xa6a/0x3db0
    unmap_single_vma+0x14b/0x230
    unmap_vmas+0x28f/0x580
    exit_mmap+0x203/0xa80
    __mmput+0x11b/0x540
    mmput+0x81/0xa0
    do_exit+0x7b9/0x2c60
    do_group_exit+0xd5/0x2a0
    get_signal+0x1fdc/0x2340
    arch_do_signal_or_restart+0x93/0x790
    exit_to_user_mode_loop+0x84/0x480
    do_syscall_64+0x4df/0x700
    entry_SYSCALL_64_after_hwframe+0x77/0x7f
    </TASK>
   Kernel panic - not syncing: Fatal exception

The assertion VM_BUG_ON_VMA(vma->vm_start > haddr, vma) fires at
mm/huge_memory.c:2999 because a huge PMD exists at PMD-aligned address
0x555580c00000 but the VMA only covers [0x555580cc0000, 0x555580ce2000):
a 136KB region starting 816KB past the PMD base.

---

The following analysis was performed with the help of an LLM:

The crash path is:

   exit_mmap -> unmap_vmas -> unmap_page_range -> zap_pmd_range
     -> sees pmd_is_huge(*pmd) is true
     -> range doesn't cover full HPAGE_PMD_SIZE
     -> calls __split_huge_pmd()
       -> haddr = address & HPAGE_PMD_MASK = 0x555580c00000
       -> __split_huge_pmd_locked()
         -> VM_BUG_ON_VMA(vma->vm_start > haddr) fires
            because 0x555580cc0000 > 0x555580c00000

The root cause appears to be remove_migration_pmd() (mm/huge_memory.c:4906).
This function reinstalls a huge PMD via set_pmd_at() after migration
completes, but it never checks whether the VMA still covers the full
PMD-aligned 2MB range.

Every other code path that installs a huge PMD validates VMA boundaries:

   - do_huge_pmd_anonymous_page(): thp_vma_suitable_order()
   - collapse_huge_page():         hugepage_vma_revalidate()
   - MADV_COLLAPSE:                hugepage_vma_revalidate()
   - do_set_pmd() (shmem/tmpfs):   thp_vma_suitable_order()

remove_migration_pmd() checks none of these.

The suspected race window is:

   1. VMA [A, A+2MB) has a THP. Migration starts, PMD becomes a migration
      entry.

   2. Concurrently, __split_vma() runs under mmap_write_lock. It calls
      vma_adjust_trans_huge() which acquires the PMD lock, splits the PMD
      migration entry into 512 PTE migration entries, and releases the PMD
      lock. Then VMA boundaries are modified (e.g., vma->vm_start = A+X).

   3. remove_migration_ptes() runs via rmap_walk_anon() WITHOUT mmap_lock
      (only the anon_vma lock). page_vma_mapped_walk() acquires the PMD
      lock. If it wins the lock BEFORE step 2's split, it finds the PMD
      migration entry still intact and returns with pvmw->pte == NULL.

   4. remove_migration_pmd() then reinstalls the huge PMD via set_pmd_at()
      without checking that the VMA (whose boundaries may have already been
      modified in step 2) still covers the full PMD range.

   5. Later, exit_mmap -> unmap_page_range -> zap_pmd_range encounters the
      huge PMD, calls __split_huge_pmd(), and the VM_BUG_ON_VMA fires
      because vma->vm_start no longer aligns with the PMD base.

The fix should add a VMA boundary check in remove_migration_pmd(). If
haddr < vma->vm_start or haddr + HPAGE_PMD_SIZE > vma->vm_end, the
function should split the PMD migration entry into PTE-level migration
entries instead of reinstalling the huge PMD, allowing PTE-level removal
to handle each page individually.

-- 
Thanks,
Sasha

