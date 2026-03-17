Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC90FD8770
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145716B008A; Tue, 17 Mar 2026 10:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5E36B0092; Tue, 17 Mar 2026 10:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88476B008C; Tue, 17 Mar 2026 10:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D295B6B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:03:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF87E1B6FBF
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:03:12 +0000 (UTC)
X-FDA: 84555721824.04.1A6F22B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84E0A14000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:03:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXMIuAAt;
	spf=pass (imf26.hostedemail.com: domain of devnull+mboone.akamai.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mboone.akamai.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756190;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lmI89me5/KAO3ADGfZtvrFqhtoPqicS1XCzqIT74zFo=;
	b=HVRqXW+SyrxYNKqTBDz78k7J9Bs1gvolo2jwnWAlL2y5FncshnYD5UqRUPGtnkrcX3HTSR
	tVPkkNnLD5dyEwpzHfE3J2lqWByGBHcc2kZk73JOugUGJOQ/i0L7FzrOHVznTlYN/7kVDH
	LcXIAOAPcxmQ4DmWC2vflMSzfN/gL3Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXMIuAAt;
	spf=pass (imf26.hostedemail.com: domain of devnull+mboone.akamai.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mboone.akamai.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756190; a=rsa-sha256;
	cv=none;
	b=2CbO6x+QvTceakelp8gAUUMro0fRNDlLA94LPyk+IJWKHui6G9XqfWcT43SzaPF9LBDNBb
	FXO26qlSIg6vmZMIs/sjey66R0okacVm5eiWPSdNR2OLIotVQGeQ9NOiP5El8bDrXulBow
	Pm2/x+pFrXAmZwCIK8eoaWO3wY84nfE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31E3E445AB;
	Tue, 17 Mar 2026 14:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 020B3C4CEF7;
	Tue, 17 Mar 2026 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773756189;
	bh=lgwo9KS3008kg15rv+pTQG9FZaWHCxL0N5M1/wcsyX4=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=BXMIuAAtCLErz6TJtAX4cqxNKNuNylxIz6b464gVjA9gVYGuBvp0/9bvMtvzqnmnL
	 aG1KTFHVXNaYu89cyJH8mUxA0m/QJAmOS00YXoFOam263CWGT9Q00fCAwlA4RydoM2
	 QRGUqPn2sD2jSx+0ebd4EJ0wBx+B+Ow4R3yvNUSFQfj2jEZDKCFL3latDfZrPHpSaf
	 eEITNtV1mkKhFxb56BUTSLCI18q0Ir81b0gyCABH38MoLjX3uYkXUoyokADfe50eKd
	 bTNTpdASU/69tJ7pwWZm/+vSntWF6l2KWvISHtfhKjfHTzvfCvlfGydxTnbXjG7Lt/
	 OaqJN40b7l2KA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3502FD8748;
	Tue, 17 Mar 2026 14:03:08 +0000 (UTC)
From: Max Boone via B4 Relay <devnull+mboone.akamai.com@kernel.org>
Date: Tue, 17 Mar 2026 15:03:04 +0100
Subject: [PATCH] mm/pagewalk: fix race between concurrent split and refault
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
X-B4-Tracking: v=1; b=H4sIABdfuWkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDY0Nz3YLE9NTyxJxs3eSM1ORs3YLcFN2i1LTE0pwS3ZRUizRDk7SkVLN
 EUyWgAQVAicwKsOHRsbW1ABoIXCRsAAAA
X-Change-ID: 20260317-pagewalk-check-pmd-refault-de8f14fbe6a5
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 stable@vger.kernel.org, Max Boone <mboone@akamai.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773756187; l=5185;
 i=mboone@akamai.com; s=20260317; h=from:subject:message-id;
 bh=QGHVUo+03M+dpGE5pLcz4dqKumPJOTwrXl5sg1teplQ=;
 b=foxzADgcbaI48K33hsp85pjr9ORwpB7l8TxVBMkYjfsDCdXtHe8MI8OCynPuJKCG2UfIekJUl
 q6L4mIIzY93DHQMjP5N06BAZoPRbEtF1wVRP7By0VBKWYMiGfH56m/j
X-Developer-Key: i=mboone@akamai.com; a=ed25519;
 pk=jWdC/h5H2KWQCiC2kpr/puMVX0mJmP9W5sM8YTGBXA4=
X-Endpoint-Received: by B4 Relay for mboone@akamai.com/20260317 with
 auth_id=685
X-Original-From: Max Boone <mboone@akamai.com>
Reply-To: mboone@akamai.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84E0A14000D
X-Stat-Signature: fyc3bxu5cb76xdqhcqiahqyqyoir7w57
X-Rspam-User: 
X-HE-Tag: 1773756190-864257
X-HE-Meta: U2FsdGVkX1+FTNABqyiifmThvAMyCtmaAVvKKEcaTRVV1Q06o4qFCryLuueD4UBUGZkhRHnfgqip4zA6zD6VAJ53VhuEjkelsB+02LpSPKs2uOTGik5TJzNH56kktI2UHe7TbLpu75OkmntfDij1bGBd8YZIkX2h8Oz/BxqAuXqJe0D5LvJAlaLyntBIclQkkkwnAoWoi2fFnXTGKb+403xrKWh+RldIzyQ85I62Kasz0IjvdSx+/7VP1fsGV2uosUlSiWv7OPvephPe+7YiBIWrn6Ismvi6cgey+vR1Jqx32QP5J3PheHeU/lMCnGNCeVjgUuJYxScDtPa43df2G56vskQkTHObqB53w4q11wVDITIqXTU40W63JPssHSIhtgGfr6oUgaeJ2NiXRMhT7FuqZo2zvej8QYoJlaRCGTUeWCJIWp5pY1IzfzAbTZvL+LK5IB+ld/Ky38vPI5MN46MQN8a3L/nmIJ8cJakUcNbkb+3U4Av7OsjfvB9EleGt9QTEoc2ssyal+WDnzszhJz2eAqOYFyzbXClFF6jvksTKIiv+Scpme1VfVT+sSxXfW2hEptqulL+pEMPfXM3vqmfyoMrFLUwDcTaNz3JF56FgJUtV9HpFYSWxSZUxUdEBJmqYvC+CNPgbZMmeZGWG0Z+ULK8oMXVR0eMvyqBqs/MOwB5XGhc10XJlB1V/GZGPt6cLH8eCSRWEP2wOP4Xqx6qaY2K+6/gsrtjXZ1GMHZ1xEYEoBkNiSXSAmsZxVG68d8Oyv2Om0fDoV/PshO4zSrTqfiodvqh126lDWmQH0fw49042BAbvMbsnlU6MzJPI8Cv1rA17+3FaweFY9s/CXUjTlJyqMTK5uNs98foJxttpfUSXVJ2FYhEdGgspbJ6HLtQkvbYpR0Ha9NDrM94wNYO2cLNIBRPnNdNGZNV7InYAvS5JQEeFU2ZfhsWGlSLtCd6A7LSHk3QXb0DDNr7
 MhZ0pWSc
 e3B6GlFgpqzJ6EOCaOXpxyrSWahaclVx8J4nIA5F+NYA9VzPFXu4NncNvYXvaOlv6+ZoEW3D2uPnw5m3VXdEFvW7Iyrr+lWesZysqaJeQCm+zoMFmxJEonhDHJ9lv/9nP83/wwaGfrwxzlJt4TaSdiYhl/C2/KLietDMo1nfxN5sRNH8MT1mpXawyaPUR3/9ZlglURLn3OdrEn/eFitmPsbkHEtQrIKay/wTjHDAHbQ9W8dbi5mlatfSHbDhvAUAMJ4tRxoWJMiBJxzlVEh68used9UfoUF3FdCo8D/z3/e5Kdp7aLAbQDvQoeoce0BPZzZzIRAK5Fz8w5W54wKDztFMZ/uS9aP+8gOksylR90sycu64PXhi4LKcNIARGubFKfTBfbG4WFQxPmxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Max Boone <mboone@akamai.com>

The splitting of a PUD entry in walk_pud_range() can race with
a concurrent thread refaulting the PUD leaf entry causing it to
try walking a PMD range that has disappeared.

An example and reproduction of this is to try reading numa_maps of
a process while VFIO-PCI is setting up DMA (specifically the
vfio_pin_pages_remote call) on a large BAR for that process.

This will trigger a kernel BUG:
vfio-pci 0000:03:00.0: enabling device (0000 -> 0002)
BUG: unable to handle page fault for address: ffffa23980000000
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
...
RIP: 0010:walk_pgd_range+0x3b5/0x7a0
Code: 8d 43 ff 48 89 44 24 28 4d 89 ce 4d 8d a7 00 00 20 00 48 8b 4c 24
28 49 81 e4 00 00 e0 ff 49 8d 44 24 ff 48 39 c8 4c 0f 43 e3 <49> f7 06
   9f ff ff ff 75 3b 48 8b 44 24 20 48 8b 40 28 48 85 c0 74
RSP: 0018:ffffac23e1ecf808 EFLAGS: 00010287
RAX: 00007f44c01fffff RBX: 00007f4500000000 RCX: 00007f44ffffffff
RDX: 0000000000000000 RSI: 000ffffffffff000 RDI: ffffffff93378fe0
RBP: ffffac23e1ecf918 R08: 0000000000000004 R09: ffffa23980000000
R10: 0000000000000020 R11: 0000000000000004 R12: 00007f44c0200000
R13: 00007f44c0000000 R14: ffffa23980000000 R15: 00007f44c0000000
FS:  00007fe884739580(0000) GS:ffff9b7d7a9c0000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffa23980000000 CR3: 000000c0650e2005 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __walk_page_range+0x195/0x1b0
 walk_page_vma+0x62/0xc0
 show_numa_map+0x12b/0x3b0
 seq_read_iter+0x297/0x440
 seq_read+0x11d/0x140
 vfs_read+0xc2/0x340
 ksys_read+0x5f/0xe0
 do_syscall_64+0x68/0x130
 ? get_page_from_freelist+0x5c2/0x17e0
 ? mas_store_prealloc+0x17e/0x360
 ? vma_set_page_prot+0x4c/0xa0
 ? __alloc_pages_noprof+0x14e/0x2d0
 ? __mod_memcg_lruvec_state+0x8d/0x140
 ? __lruvec_stat_mod_folio+0x76/0xb0
 ? __folio_mod_stat+0x26/0x80
 ? do_anonymous_page+0x705/0x900
 ? __handle_mm_fault+0xa8d/0x1000
 ? __count_memcg_events+0x53/0xf0
 ? handle_mm_fault+0xa5/0x360
 ? do_user_addr_fault+0x342/0x640
 ? arch_exit_to_user_mode_prepare.constprop.0+0x16/0xa0
 ? irqentry_exit_to_user_mode+0x24/0x100
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7fe88464f47e
Code: c0 e9 b6 fe ff ff 50 48 8d 3d be 07 0b 00 e8 69 01 02 00 66 0f 1f
84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00
   f0 ff ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
RSP: 002b:00007ffe6cd9a9b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007fe88464f47e
RDX: 0000000000020000 RSI: 00007fe884543000 RDI: 0000000000000003
RBP: 00007fe884543000 R08: 00007fe884542010 R09: 0000000000000000
R10: fffffffffffffbc5 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
 </TASK>

Fix this by validating the PUD entry in walk_pmd_range() using a stable
snapshot (pudp_get()). If the PUD is not present or is a leaf, retry the
walk via ACTION_AGAIN instead of descending further. This mirrors the
retry logic in walk_pmd_range().

Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Cc: stable@vger.kernel.org
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Max Boone <mboone@akamai.com>
---
 mm/pagewalk.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab..c74b4d800 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -97,6 +97,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
 {
+	pud_t pudval = pudp_get(pud);
 	pmd_t *pmd;
 	unsigned long next;
 	const struct mm_walk_ops *ops = walk->ops;
@@ -105,6 +106,18 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	int err = 0;
 	int depth = real_depth(3);
 
+	/*
+	 * For PTE handling, pte_offset_map_lock() takes care of checking
+	 * whether there actually is a page table. But it also has to be
+	 * very careful about concurrent page table reclaim. If we spot a PMD
+	 * table, it cannot go away, so we can just walk it. However, if we find
+	 * something else, we have to retry.
+	 */
+	if (!pud_present(pudval) || pud_leaf(pudval)) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
+
 	pmd = pmd_offset(pud, addr);
 	do {
 again:
@@ -218,12 +231,13 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 		else if (pud_leaf(*pud) || !pud_present(*pud))
 			continue; /* Nothing to do. */
 
-		if (pud_none(*pud))
-			goto again;
-
 		err = walk_pmd_range(pud, addr, next, walk);
 		if (err)
 			break;
+
+		if (walk->action == ACTION_AGAIN)
+			goto again;
+
 	} while (pud++, addr = next, addr != end);
 
 	return err;

---
base-commit: b4f0dd314b39ea154f62f3bd3115ed0470f9f71e
change-id: 20260317-pagewalk-check-pmd-refault-de8f14fbe6a5

Best regards,
-- 
Max Boone <mboone@akamai.com>



