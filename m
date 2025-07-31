Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD642C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 21:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2245B6B0088; Thu, 31 Jul 2025 17:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5AD6B0089; Thu, 31 Jul 2025 17:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D8B6B008A; Thu, 31 Jul 2025 17:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1A566B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:41:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C3B711498D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:41:01 +0000 (UTC)
X-FDA: 83725880322.10.DD75F63
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A64AB40002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:40:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJb5NJG8;
	spf=pass (imf11.hostedemail.com: domain of herton@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=herton@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753998059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JlsU4UAqSZQRdqGvx8oaC4/kh3OoM15U/EG/gdrxGFs=;
	b=JbsoWu7lghefRVJl50LzffNawQs/vo8Q13WtafHlg4nX5zQ4xalzWLV45WBSzelyS1quzg
	m2DiACLnvkMlkKMtRndQSklV3S+a8V7tC3q77GTIFbWttIMaesDNUCa9NsVBfdzfokaq4k
	IxVlHWAY44nyAOPqcrngIXSEkuDvxto=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJb5NJG8;
	spf=pass (imf11.hostedemail.com: domain of herton@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=herton@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753998059; a=rsa-sha256;
	cv=none;
	b=SqaBB4i6/nk5PyB3q9Batb3cSc5saDyxMQPfCkImaK/gwopXJB7vILnkn/kM11SW61WlDU
	lh3gHvOpKoUjc62KAPwKDWi9REsOloxoAOLI3LzFMstRVsJF/gLITbB/mooqmoM0AB/4+I
	+BgLNFVBorTlkHT/tz8nBz126vTV5CM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753998058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JlsU4UAqSZQRdqGvx8oaC4/kh3OoM15U/EG/gdrxGFs=;
	b=OJb5NJG8GvKZ7xS6EKNGEbDQyYkJolG/iUksa4Tj7WIgLasQwhFl49vOA/Mz+qEWvo6uYi
	F7SxyOgrgoTtP5xabsLUnpKkwaJsb9pFm+RVxKNUhfuQZi9RY482MBEOd+qUfE4U6Kmxiw
	C7Mp1YOFXGDNvhS/4lCiRAjnfXO0te0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-WG9EfwGcNjK5HLMRx3-M5A-1; Thu,
 31 Jul 2025 17:40:54 -0400
X-MC-Unique: WG9EfwGcNjK5HLMRx3-M5A-1
X-Mimecast-MFC-AGG-ID: WG9EfwGcNjK5HLMRx3-M5A_1753998054
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 954861800360;
	Thu, 31 Jul 2025 21:40:53 +0000 (UTC)
Received: from redhat.com (unknown [10.96.134.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B1523180035E;
	Thu, 31 Jul 2025 21:40:52 +0000 (UTC)
From: "Herton R. Krzesinski" <herton@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	herton@redhat.com,
	anshuman.khandual@arm.com
Subject: [PATCH] mm/debug_vm_pgtable: clear page table entries at destroy_args()
Date: Thu, 31 Jul 2025 18:40:51 -0300
Message-ID: <20250731214051.4115182-1-herton@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: A64AB40002
X-Rspamd-Server: rspam06
X-Stat-Signature: t7dxixwaomh9f3u593moiw4uf8s53h9o
X-HE-Tag: 1753998059-816357
X-HE-Meta: U2FsdGVkX1+dCWwayM2bZyi7gMGkyE900pLghkFVQTkV20X+LgNJ35hP3BAq+uV3vMNh+Y8QBpha55ooZ1g3bWh7vX+3G1TNQrYcXUvu96RtjRa0EQPsZ6Gk7Lk6YmJxzLdD24t4CrEAGK/vkyzz/lALv8QcnBKN801MbH0uSRj9siYSgX87mX0BvqS+vo3mwOmNoA45AmyZ2yq5GLbuPgzfVtSBxLgY01ezq5Vc0d3fp7BNoERwQGPPW1iJVAybmuQgfa5EEMCdyddhlAvzi6ygQj1ETEH2piFxDPrsbkz4oTcD2cvsG8SbrHHUY6QJTvd3oY5LfePVwYqxn3Uxg29D0FZnNRsZ2s0kKb5P7/GDXvgdPETKhspfu2Y/EgrLNW2ED1iYG1zxMAK1z83oe9FOLibbVjmL1xtF9Vk7CeUGCzqkYciv1lxh8MPp4sXgtjtNDxj6lhvkgDLAx3GTJ9EFik4rgE/lILgbU1Yek8tw1hr6uOTryoixQGDhOq3mMLxLmC4xVyBmRQhzo0Ea+tJRkeDMQQ4vi0BcbBwrXqNah05j9FdWwnpq+EGtgdeQTULU6jZkDvgjQ9kPqzZblpgYxxibaEeKHYPJZXSrvb5v3kiq5+XOwXcj/6xNTuPelKVxqFrTw60OZc+ipCmEULP2i3WmwuxT96ZfRz52lq/xGxFEHCxK+Cc7Vr/Hhxi1drodGHUylDzbX+QiiT4BV3GKquwdrCRiJsSfkuPq3TT0/ox5nhOPgwCzc+CInYGzHJ9Sn3OApREfNHfLf8JydTfK8BHdvFvZmGqDAFygTD2wrY+Mqh+K8X7VJFLRqO032WVpTdZ0iyFdmRqeWfANk/wVInKY0g4a48y3GTzAclYcA7HbSwJi0MOfv5DdMRv5ERgYwab9Ni8WvhzbjvK0XH4rlSi+GKTf+sQ1IWlL26yIPhogZhUYxZUuobV3/Pd0/6v7+WxXBEEbM+KF7eS
 8lov3Pog
 2vUFNvyFOBB87VzKV3fxzjuO57Pxou5/1UfEtJ9Ve77mS08AESeqicslhL1+i51MkHpP5laW6pukF7qhp7AVQK4jfEamSFj6gaGX6Vs5bazl6hCR1IhRtdnwJ8dE/OXhBqTC9bQM3uL5DRSR9DiYH/89QICFh1QpAfUeGVH9IvMoeV68JVF6vLAZuWlbIf0NFdJ0469N0zBr66yO4dlLW/LFxocHUXr3JSo0N3bQ8Coc3preZrpKFl1Xao5x5085v6eJFyk4z6FjTXJILiDhGOYdeWXMrRcr112nlNddDnh+3BhsLqAmL5y4KqJqxYAfpvVYQ/yBE2SkIpPzCCcdoLDcYlzoW/9kUZgDmT9gehJxQD4d2Ga1vBmQROw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mm/debug_vm_pagetable test allocates manually page table entries for the
tests it runs, using also its manually allocated mm_struct. That in itself is
ok, but when it exits, at destroy_args() it fails to clear those entries with
the *_clear functions.

The problem is that leaves stale entries. If another process allocates
an mm_struct with a pgd at the same address, it may end up running into
the stale entry. This is happening in practice on a debug kernel with
CONFIG_DEBUG_VM_PGTABLE=y, for example this is the output with some
extra debugging I added (it prints a warning trace if pgtables_bytes goes
negative, in addition to the warning at check_mm() function):

[    2.539353] debug_vm_pgtable: [get_random_vaddr         ]: random_vaddr is 0x7ea247140000
[    2.539366] kmem_cache info
[    2.539374] kmem_cachep 0x000000002ce82385 - freelist 0x0000000000000000 - offset 0x508
[    2.539447] debug_vm_pgtable: [init_args                ]: args->mm is 0x000000002267cc9e
(...)
[    2.552800] WARNING: CPU: 5 PID: 116 at include/linux/mm.h:2841 free_pud_range+0x8bc/0x8d0
[    2.552816] Modules linked in:
[    2.552843] CPU: 5 UID: 0 PID: 116 Comm: modprobe Not tainted 6.12.0-105.debug_vm2.el10.ppc64le+debug #1 VOLUNTARY
[    2.552859] Hardware name: IBM,9009-41A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW910.00 (VL910_062) hv:phyp pSeries
[    2.552872] NIP:  c0000000007eef3c LR: c0000000007eef30 CTR: c0000000003d8c90
[    2.552885] REGS: c0000000622e73b0 TRAP: 0700   Not tainted  (6.12.0-105.debug_vm2.el10.ppc64le+debug)
[    2.552899] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002822  XER: 0000000a
[    2.552954] CFAR: c0000000008f03f0 IRQMASK: 0
[    2.552954] GPR00: c0000000007eef30 c0000000622e7650 c000000002b1ac00 0000000000000001
[    2.552954] GPR04: 0000000000000008 0000000000000000 c0000000007eef30 ffffffffffffffff
[    2.552954] GPR08: 00000000ffff00f5 0000000000000001 0000000000000048 0000000000004000
[    2.552954] GPR12: 00000003fa440000 c000000017ffa300 c0000000051d9f80 ffffffffffffffdb
[    2.552954] GPR16: 0000000000000000 0000000000000008 000000000000000a 60000000000000e0
[    2.552954] GPR20: 4080000000000000 c0000000113af038 00007fffcf130000 0000700000000000
[    2.552954] GPR24: c000000062a6a000 0000000000000001 8000000062a68000 0000000000000001
[    2.552954] GPR28: 000000000000000a c000000062ebc600 0000000000002000 c000000062ebc760
[    2.553170] NIP [c0000000007eef3c] free_pud_range+0x8bc/0x8d0
[    2.553185] LR [c0000000007eef30] free_pud_range+0x8b0/0x8d0
[    2.553199] Call Trace:
[    2.553207] [c0000000622e7650] [c0000000007eef30] free_pud_range+0x8b0/0x8d0 (unreliable)
[    2.553229] [c0000000622e7750] [c0000000007f40b4] free_pgd_range+0x284/0x3b0
[    2.553248] [c0000000622e7800] [c0000000007f4630] free_pgtables+0x450/0x570
[    2.553274] [c0000000622e78e0] [c0000000008161c0] exit_mmap+0x250/0x650
[    2.553292] [c0000000622e7a30] [c0000000001b95b8] __mmput+0x98/0x290
[    2.558344] [c0000000622e7a80] [c0000000001d1018] exit_mm+0x118/0x1b0
[    2.558361] [c0000000622e7ac0] [c0000000001d141c] do_exit+0x2ec/0x870
[    2.558376] [c0000000622e7b60] [c0000000001d1ca8] do_group_exit+0x88/0x150
[    2.558391] [c0000000622e7bb0] [c0000000001d1db8] sys_exit_group+0x48/0x50
[    2.558407] [c0000000622e7be0] [c00000000003d810] system_call_exception+0x1e0/0x4c0
[    2.558423] [c0000000622e7e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
(...)
[    2.558892] ---[ end trace 0000000000000000 ]---
[    2.559022] BUG: Bad rss-counter state mm:000000002267cc9e type:MM_ANONPAGES val:1
[    2.559037] BUG: non-zero pgtables_bytes on freeing mm: -6144

Here the modprobe process ended up with an allocated mm_struct from the
mm_struct slab that was used before by the debug_vm_pgtable test. That is not a
problem, since the mm_struct is initialized again etc., however, if it ends up
using the same pgd table, it bumps into the old stale entry when clearing/freeing
the page table entries, so it tries to free an entry already gone (that one
which was allocated by the debug_vm_pgtable test), which also explains the
negative pgtables_bytes since it's accounting for not allocated entries in the
current process. As far as I looked pgd_{alloc,free} etc. does not clear entries,
and clearing of the entries is explicitly done in the free_pgtables->
free_pgd_range->free_p4d_range->free_pud_range->free_pmd_range->
free_pte_range path. However, the debug_vm_pgtable test does not call
free_pgtables, since it allocates mm_struct and entries manually for its test
and eg. not goes through page faults. So it also should clear manually the
entries before exit at destroy_args().

This problem was noticed on a reboot X number of times test being done
on a powerpc host, with a debug kernel with CONFIG_DEBUG_VM_PGTABLE
enabled. Depends on the system, but on a 100 times reboot loop the
problem could manifest once or twice, if a process ends up getting the
right mm->pgd entry with the stale entries used by mm/debug_vm_pagetable.
After using this patch, I couldn't reproduce/experience the problems
anymore. I was able to reproduce the problem as well on latest upstream
kernel (6.16).

I also modified destroy_args() to use mmput() instead of mmdrop(), there
is no reason to hold mm_users reference and not release the mm_struct
entirely, and in the output above with my debugging prints I already
had patched it to use mmput, it did not fix the problem, but helped
in the debugging as well.

Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
---
 mm/debug_vm_pgtable.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 7731b238b534..0f5ddefd128a 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -1041,29 +1041,34 @@ static void __init destroy_args(struct pgtable_debug_args *args)
 
 	/* Free page table entries */
 	if (args->start_ptep) {
+		pmd_clear(args->pmdp);
 		pte_free(args->mm, args->start_ptep);
 		mm_dec_nr_ptes(args->mm);
 	}
 
 	if (args->start_pmdp) {
+		pud_clear(args->pudp);
 		pmd_free(args->mm, args->start_pmdp);
 		mm_dec_nr_pmds(args->mm);
 	}
 
 	if (args->start_pudp) {
+		p4d_clear(args->p4dp);
 		pud_free(args->mm, args->start_pudp);
 		mm_dec_nr_puds(args->mm);
 	}
 
-	if (args->start_p4dp)
+	if (args->start_p4dp) {
+		pgd_clear(args->pgdp);
 		p4d_free(args->mm, args->start_p4dp);
+	}
 
 	/* Free vma and mm struct */
 	if (args->vma)
 		vm_area_free(args->vma);
 
 	if (args->mm)
-		mmdrop(args->mm);
+		mmput(args->mm);
 }
 
 static struct page * __init
-- 
2.47.1


