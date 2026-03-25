Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FACFEA824
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00DC6B0095; Wed, 25 Mar 2026 05:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB23B6B0098; Wed, 25 Mar 2026 05:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEFD66B0099; Wed, 25 Mar 2026 05:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFD5B6B0095
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:59:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 693D71B8A74
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:59:20 +0000 (UTC)
X-FDA: 84584137680.28.9349BDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 880B4A0011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:59:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XOYMZUqZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+mboone.akamai.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mboone.akamai.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774432758; a=rsa-sha256;
	cv=none;
	b=HDxpba3FNVSUDa3uySzpZvwW3fQ6Y2DNsfbgCSB/4ko4GcZ/tvqCQP3VENwNP3tAOWj2Ln
	OGWsG/nkD8/4nDCtNrYrtcFZ5LMtpcVguTqNYHK3uv7sb9ezNb5vqYxW/ZMHeYpmKVrB0x
	cTDtXIXiui1MU/dSPCo7+KY9dc7rZk4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XOYMZUqZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+mboone.akamai.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mboone.akamai.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774432758;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Nmqe3JKM60Rrb1xFTiKN/pWxH7yywIELUa8VERBbvrI=;
	b=FmgJTNz3pVzZYaFOZnA7tt9LKsj9dXNUYt19ZlH6G4d9paGJ+vh2PrUT1mFcnYuJrmQ6F/
	4/snt/w/Khx0AOfBgjlr3TxIcqP3UmSzE+IlAr6jZCaIPbBsL+5d/gWt8Hbk4E64RyGzsY
	LrUCEcJnf56bYo4OzdQ08D4/3TCUohY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B25A6444BB;
	Wed, 25 Mar 2026 09:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A0B2C2BCB1;
	Wed, 25 Mar 2026 09:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774432757;
	bh=2qe2hb3ehnVI+3DXdISg2rTtp7ZKp6aAIx4MjaZqwK0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=XOYMZUqZL0YGKjmZVW8QW94McnxaueUbxuu91ZPKwyYUbiYpoKMTcJjsg/GmVCjUP
	 xB+WTPVHDlkWSakfHgm2mLqEezdp/J4jTZIeHVssBm/MaSpBnwqQBYMKlQWzfVx/y9
	 GTtqDYIo8266MndpTvfvfR5GMuxA4OMNKHrxYVrdHubXDvMBzMLSIOUiPYP1kC+aYM
	 slWvmnMNphO0D5Xp/ogP6WryJ9mdmeoYs2I0b8Pvfzf7HFpDSz/O/tpTlU4ydICdB/
	 zzBw5rMnks8NBESE39OY+9q5Ttjl3cpMVdVr55V/EtqIBpqVosy55zmhDBrwDQr9Z+
	 TG3t1XClVrrhw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7986EFEA824;
	Wed, 25 Mar 2026 09:59:17 +0000 (UTC)
From: Max Boone via B4 Relay <devnull+mboone.akamai.com@kernel.org>
Date: Wed, 25 Mar 2026 10:59:16 +0100
Subject: [PATCH v2] mm/pagewalk: fix race between concurrent split and
 refault
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-pagewalk-check-pmd-refault-v2-1-707bff33bc60@akamai.com>
X-B4-Tracking: v=1; b=H4sIAPOxw2kC/42NTQ6CMBBGr0Jm7Zi2KIor72FYDGUKE37TImoId
 7dyApfvfcn7VgjshQPckhU8LxJkHCKYQwK2oaFmlCoyGGUyleoLTlTzi7oWbcO2xamv0LOjZzd
 jxVenT67kjM4QA1Mc5L3HH0XkRsI8+s/+teif/Su7aNTosjwnpZUzZXqnlnqSox17KLZt+wK2a
 pjvxQAAAA==
X-Change-ID: 20260317-pagewalk-check-pmd-refault-de8f14fbe6a5
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 stable@vger.kernel.org, Max Boone <mboone@akamai.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774432756; l=5936;
 i=mboone@akamai.com; s=20260317; h=from:subject:message-id;
 bh=dadFHTWNp/nC5fmA7WR3ReEmmPozjoOq5u7J1/Gx8+8=;
 b=zHMIYTvae2Ac4rzwemvxPjAcizdYW3HB1l9t9Op4HrtWAALX1Y7kIn7m3Fq5Hj+Q+N1NiTtVb
 3cqf/gRrGx2AVN4HrNxz7W7mO+GYKYUjQnOSKWh9bu10p+SjGiQjOcw
X-Developer-Key: i=mboone@akamai.com; a=ed25519;
 pk=jWdC/h5H2KWQCiC2kpr/puMVX0mJmP9W5sM8YTGBXA4=
X-Endpoint-Received: by B4 Relay for mboone@akamai.com/20260317 with
 auth_id=685
X-Original-From: Max Boone <mboone@akamai.com>
Reply-To: mboone@akamai.com
X-Stat-Signature: hxyaathf7utp5adoc91w4wuunz4jitm7
X-Rspamd-Queue-Id: 880B4A0011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774432758-262684
X-HE-Meta: U2FsdGVkX19ijq7CL0/ZjJXUqZWMo+/lCWOqTgVH32bcqC82VQVxKWRonsv+cyjYvCT9iu+fw5jOINa/VSacVPDki9JQrjcO+88Trc3MW77Ehj1DsntRti7HoeSJx5t054dNoX5E8UBMR8tLq6aoNU/Oi8FNcQDK6syiqsX7qF/iAehrJfQRo637gqsp1rLOz5yZs37TDdAnFDCkNQf603vkOfXV/OPuCLG4U/9fyUYxaJHf5/M41zW3P+2kAlsVwimIP+vWn4JltVI5ysTYyy3SuG2Af133B3C5jZjQI9W58V/tXdtA61wpGss8JtwBhBslC+z5tPT/5hv6+WxtjfmbQSJIdBSRrWBLnyXLbV+o2vu7poPqkxsLrR8+D/CisM9i6KGglCRljqDpu7SxeBeQu6RRoj6IWdmevYQY9boR1pz2LUZnBCMlWNsSFVSaH/UJEBmiwi09NP2eRLsRlGWpuivUm/XlTOO14vCKrPV947xQsEAAgOCBRKV77EX0lHImKK2xA30MhK1T3eTZ5GRwiG5cnBf6vckZdpRv1lY6zH06EjGIXu2J9bwOqB+QZY9PxvNOkeflfGIrmobxL/M62uliEScAyKzpLI7qzTj461QNvcCzLXcbAgG1siuXMqcMWNgZNR44/oZZs0oyy5C2QdQsMAh+P2+hRq1MPvQJM0mKFfu4wl/e31TMGdMdDetEH2xY8aMWiJS/Pn8ByCfwEhwBvIARR6txyzylfPTY0jyC1pNLkSneYbxHF87mg8NlnH0dUF9YXjGLglINZGPrhSaaB+GfM2VSzwvz+mbY2n0ca4QLLp5cm7wYbeA9HJY16MfimFAGsE9pdAAQLivMyw9Sy/H/IvAJEGwealsgwgfi0mrs4/uvjX4m6IIruaVHMoQl1iua6wQzt20s1IzQT5k5lGZ/DgKKBnhm6I12BXpbS4rtCx3A3VV3jis8MIkYvZIsRf6mSpQR05t
 1ytMhR/e
 TrYsPCefymph9uh2uqP1EVqVOyAD6kFTs4PfbpSKgOU7/PEQ=
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
retry logic in walk_pte_range(), which lets walk_pmd_range() retry if
the PTE is not being got by pte_offset_map_lock().

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Max Boone <mboone@akamai.com>
---
Changes in v2:
- extended the comment in walk_pmd_range with split/refault example.
- changed fixes, race not introduced by hugepage splitting but rather
  with huge pfnmaps of BARs.
- clarified that the retry logic mirrors walk_pte_range instead of
  walk_pmd_range.
- style changes (removed trailing newline)
- Link to v1: https://lore.kernel.org/r/20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com
---
 mm/pagewalk.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab..4e7bcd975 100644
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
@@ -105,6 +106,24 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	int err = 0;
 	int depth = real_depth(3);
 
+	/*
+	 * For PTE handling, pte_offset_map_lock() takes care of checking
+	 * whether there actually is a page table. But it also has to be
+	 * very careful about concurrent page table reclaim.
+	 *
+	 * Similarly, we have to be careful here - a PUD entry that points
+	 * to a PMD table cannot go away, so we can just walk it. But if
+	 * it's something else, we need to ensure we didn't race something,
+	 * so need to retry.
+	 *
+	 * A pertinent example of this is a PUD refault after PUD split -
+	 * we will need to split again or risk accessing invalid memory.
+	 */
+	if (!pud_present(pudval) || pud_leaf(pudval)) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
+
 	pmd = pmd_offset(pud, addr);
 	do {
 again:
@@ -218,12 +237,12 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
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
 	} while (pud++, addr = next, addr != end);
 
 	return err;

---
base-commit: b4f0dd314b39ea154f62f3bd3115ed0470f9f71e
change-id: 20260317-pagewalk-check-pmd-refault-de8f14fbe6a5

Best regards,
-- 
Max Boone <mboone@akamai.com>



