Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C68C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956146B008C; Mon,  7 Sep 2026 08:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E0F6B0098; Mon,  7 Sep 2026 08:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843B46B00A5; Mon,  7 Sep 2026 08:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1526B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:40:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4349A015B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:40:13 +0000 (UTC)
X-FDA: 85186923906.19.626ED66
Received: from mail-m82150.xmail.ntesmail.com (mail-m82150.xmail.ntesmail.com [156.224.82.150])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3F61B1C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:40:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=deepseek.com header.s=default header.b="B/YC1o04";
	spf=pass (imf20.hostedemail.com: domain of escape@deepseek.com designates 156.224.82.150 as permitted sender) smtp.mailfrom=escape@deepseek.com;
	dmarc=pass (policy=quarantine) header.from=deepseek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GaQ5YtuWhqR6EHDoYWKfff2DgSHnW3S6WvgJatwu8eI=;
	b=BjHtO+VbRyWwtzh3UrptjuZu3RNPxnmpnhVnI3FHYlAls4WkMbAZAVpbYvMCdX0+j6iab/
	Ao/vQdKdbJI/stR7eu5hnTB9yDW+6/aRJE0x+ceZC8TV45HEhr5UV5JRCzmHazg/y2qMAh
	5XqK2PttO9upoON8sWzVxodyHhcUcTg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=deepseek.com header.s=default header.b="B/YC1o04";
	spf=pass (imf20.hostedemail.com: domain of escape@deepseek.com designates 156.224.82.150 as permitted sender) smtp.mailfrom=escape@deepseek.com;
	dmarc=pass (policy=quarantine) header.from=deepseek.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784812;
	b=XE9COc8sVS453NtF5SSMKsH9GJYrFnFpt4C4Dkpo6zkfMXilqT2xEPanxH5amCQd9/J/4E
	R9C9b9swZA0Xh1el29F6hyPaCSajLytglmE8GyM898tPauZwcID3TmEgQVmj17n4HCtEx4
	YzZMzfELQ5O5j+EUv6bMzoOIRb/jghU=
Received: from hg-fd0407-cpu-vm1-037085 (unknown [159.138.123.140])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4cd3dc5e9;
	Mon, 7 Sep 2026 20:40:03 +0800 (GMT+08:00)
From: Tao Yi <escape@deepseek.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1] mm: memcg: skip frozen folios in page_cgroup_ino()
Date: Mon,  7 Sep 2026 12:40:00 +0000
Message-ID: <20260907124001.1544655-1-escape@deepseek.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07be1fde309dakunmf5d73b6726c9b2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGUhJVkxMQkwdHx0ZGB5MQlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKTkJVSkhDVUpJSFVKT0tZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=B/YC1o04V0UdNUcHS58/Yw63wjPuwQuOdIvQOvU7dKrt/7c9k8FNgiB0jkhPtFBPikjIrd1drYdH1zuYou5F5nys0UKMMKK5FrRvHMLonH045txDG2rm7tNeeFJuOxLbRvX8uL/7IWKZJGO03PcoYNpIPlnLEqMzK4WNBOfp6zc=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=GaQ5YtuWhqR6EHDoYWKfff2DgSHnW3S6WvgJatwu8eI=;
	h=date:mime-version:subject:message-id:from;
X-Stat-Signature: r64q1uduj3fridk4jxggs8afr9o48mhj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F61B1C0003
X-Rspam-User: 
X-HE-Tag: 1788784809-304782
X-HE-Meta: U2FsdGVkX1+m6+2U3QkNplngFH1nZvCajpVQlcf2cdm/gMEkeIPGBpfiO/JiNcN2xiwODRVmiUFA08rqkEZjqid7SM4ldGV0E8oEHCG8lDxe6XPnD9viLQyd4sMo3e4DvhKKq3fWLpAfH32vCzT54X45Ta6Ri5IxBUmkDklQJfsOY3tOqbcebFZ3oeUjqzUZm04vG8knBcrLB4Krkc9HihpdQwplSeFXUG2SmMedkn/DTnVlbPuyhrmAA3djgnhKxlATNAOAuAK3+0PVp7MXJZAqIlJt8afFwGVOlb1rtYewKTa5PTtYSGvuWfzx6lqeD82FsOP11TvTjMyF0wEBYtAECKWZiaU0dYTgLDPg3FlVdH6R3CK/3xA6n3yJiFsYTPhLxxyGvgDqk8zx5kzpdwMLwXHUeU3Ztea3yaEtP61d4lxxdtHGk3Bxwx/Ze/jdew9lzk7LEHSVL3GarjHdfd/HSrbVytPiWAxT4i/kH36lfxVN9/DvOkfODtTCmUNNzosZxt61JUGIzb/VAbqT5vrXuLUUl9WjxcbozOA4i6pCemn6E9SG6e9Xquym+hcexCS4ckro0YSiLZBueRPzRF+c/GmWUzn2KmzOVw2iHLl5quQBsI1zBzXRHDgB5WTJ1z+L7KgoxrB45QlQAV3ikhIKDAHxfz777HEA7S4kZBZbesbbH/+wYkEnBgzHbw+mPn/cDljgHXZRDdoWDJ/KuFpV+ngPVL7DdmXPdvrMlxOL1praoLELCck6TjFXSTQGe7V8K7Ba4a97ZW+j3VYbYSlWmbqDsW2GbXabdB3+qS+NI28Zb94nfZzZiMtb7HgfND5GKNNlpsq/tPqLhy2+9WC/mk086Ck2sXHY47UQqFP1B41gWW0ZmueSdZzM6z9MW1/sLxbWruh4Gk6MGZWJ7fcc99GLtsZRdz8C6guPgd1r4ploYKU1WCjrn2u4pEv4nxQ6r6KS4eM9dB24E5z
 2MBsCuAK
 sNUYFoH0kS0VNTozuyTs6MnNTSl1qHf0WD+kY09jpHjZv9Zlj1ULW/tij6VYAe8gppFqNBov1qEWn6+FqwI+BwJyQYBlwAomxWEcB2DcNbKTKL9QRNrRF8R8TnsvSScOtzJWMNXRx6LVuXVKBsn/8lhBBRUdb9530DOAhPmrpSa1dljuMqpu4dqf4n2TqEdHQfCW1/UNMu1IktXusCnMdxwBXUNrmlHhEWsbE2s7ztFqZ0nFauersNIPwCi/U3xI3MHceRyBCpqt3d3rLdfwfstLwEjrpmWrl8/Z2dcvbsghtW5SRVWfZNFsQwSW64N0OgV3ma8FtvtDQwmi7E+Ahfq9VUfD+WjA0N8bQlR8MBACI6Z90gZnthFqDaCW6DHPqXbk9nHEbBsVKXfS2JyA7fOrRaCNg4i0NWG2IjWCPkgiZsf1wILFd9qHsiUnYq6yfhA6n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio->_nr_pages overlays the memcg_data field of the first tail page.
When a large folio is split, __split_folio_to_order() clears PageTail
before copying the original folio's memcg_data to the new folio.

That leaves a window where a lockless PFN walker can resolve the former
tail as an independent folio while its memcg_data still contains
_nr_pages. For example, the first tail of an order-4 folio contains
0x10. page_cgroup_ino(), which is documented to be callable without a
page reference and is used by /proc/kpagecgroup, can interpret that
value as a pointer.

This caused the following crash on 7.0.0-29-generic while a process
was reading /proc/kpagecgroup. On that kernel, page_cgroup_ino()
interpreted the value as a mem_cgroup pointer; page_cgroup_ino+0x4c is
the inlined css_is_online() check, RAX contains the stale memcg_data
value 0x10, and CR2 is RAX + 0x4c. On current kernels the value would
be interpreted as an obj_cgroup pointer instead, but it is invalid in
either case:

[870611.552359] BUG: kernel NULL pointer dereference, address: 000000000000005c
[870611.553709] #PF: supervisor read access in kernel mode
[870611.554704] #PF: error_code(0x0000) - not-present page
[870611.555676] PGD 2ce74eb067 P4D 0
[870611.556330] Oops: Oops: 0000 [#1] SMP NOPTI
[870611.557131] CPU: 2 UID: 0 PID: 646187 Comm: grep Kdump: loaded Tainted: G        W  OE K     7.0.0-29-generic #29-Ubuntu PREEMPT(lazy)
[870611.559161] Tainted: [W]=WARN, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [K]=LIVEPATCH
[870611.560427] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
[870611.562203] RIP: 0010:page_cgroup_ino+0x4c/0xc0
[870611.563061] Code: 53 38 48 89 d3 83 e3 01 75 73 48 89 d0 48 83 e0 f8 83 e2 02 74 0f 48 8b 40 10 eb 09 66 90 48 8b 80 b8 00 00 00 48 85 c0 74 14 <f6> 40 4c 02 74 ee 48 8b 00 48 8b 80 00 01 00 00 48 8b 58 60 e8 7b
[870611.566161] RSP: 0018:ff837258046afbe8 EFLAGS: 00010202
[870611.567146] RAX: 0000000000000010 RBX: 0000000000000000 RCX: 0000000000000000
[870611.568305] RDX: 0000000000000000 RSI: 0000000000000000 RDI: fffbbc7280d84040
[870611.569443] RBP: ff837258046afbf0 R08: ff3110e00bc9f500 R09: 0000000000000000
[870611.570567] R10: 0000000000000000 R11: 0000000000000000 R12: 00005f6b27ac3808
[870611.571704] R13: 0000000004036101 R14: 0000000000018000 R15: 00005f6b27abb000
[870611.572806] FS:  00007cec6f8bdb80(0000) GS:ff311118762ff000(0000) knlGS:0000000000000000
[870611.574025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[870611.574948] CR2: 000000000000005c CR3: 0000000361776004 CR4: 0000000000771ef0
[870611.576069] DR0: 00005e7136461088 DR1: 000060e18f7c22c8 DR2: 000060e18f7c22d0
[870611.577171] DR3: 000060e18f7c22d8 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[870611.578292] PKRU: 55555554
[870611.578791] Call Trace:
[870611.579249]  <TASK>
[870611.579689]  kpage_read.isra.0+0xe3/0x110
[870611.580345]  kpagecgroup_read+0x1c/0x30
[870611.580980]  proc_reg_read+0x31/0xd0
[870611.581595]  vfs_read+0xbf/0x3a0
[870611.582172]  ? proc_reg_read+0x31/0xd0
[870611.582814]  ? vfs_read+0xbf/0x3a0
[870611.583398]  ? proc_reg_read+0x31/0xd0
[870611.584046]  ksys_read+0x71/0xf0
[870611.584602]  __x64_sys_read+0x19/0x30
[870611.585238]  x64_sys_call+0x1ff1/0x2390
[870611.585905]  do_syscall_64+0x105/0x5a0
[870611.586529]  ? page_cgroup_ino+0x65/0xc0
[870611.587197]  ? kpage_read.isra.0+0x7b/0x110
[870611.587901]  ? kpagecgroup_read+0x1c/0x30
[870611.588554]  ? proc_reg_read+0x31/0xd0
[870611.589189]  ? vfs_read+0xbf/0x3a0
[870611.589782]  ? flush_tlb_func+0xa3/0x370
[870611.590423]  ? __pfx_flush_tlb_func+0x10/0x10
[870611.591149]  ? __flush_smp_call_function_queue+0xa1/0x4b0
[870611.592013]  ? arch_exit_to_user_mode_prepare.isra.0+0xd/0x100
[870611.592987]  ? irqentry_exit+0x97/0x6f0
[870611.593727]  ? __irq_exit_rcu+0x45/0x120
[870611.594464]  ? generic_smp_call_function_single_interrupt+0x13/0x20
[870611.595595]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[870611.596509] RIP: 0033:0x7cec6f9cc3ce
[870611.597250] Code: c0 e9 b6 fe ff ff 50 48 8d 3d 6e 08 0b 00 e8 69 01 02 00 66 0f 1f 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
[870611.600473] RSP: 002b:00007ffc12394718 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[870611.601834] RAX: ffffffffffffffda RBX: 0000000000018000 RCX: 00007cec6f9cc3ce
[870611.603102] RDX: 0000000000018000 RSI: 00005f6b27abb000 RDI: 0000000000000003
[870611.604328] RBP: 00005f6b27abb000 R08: 00005f6b27ad3000 R09: 00005f6b27aba1d0
[870611.605497] R10: 00005f6b27ad3000 R11: 0000000000000246 R12: 00007ffc123947f0
[870611.606774] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000003
[870611.608041]  </TASK>

After-split folios have frozen refcounts while their metadata is being
initialized. Therefore, skip folios with a zero refcount before reading
memcg_data. The acquire load pairs with the release store in
folio_ref_unfreeze(), ensuring a nonzero refcount also makes the newly
initialized memcg_data visible. This prevents page_cgroup_ino() from
dereferencing the transient _nr_pages value during a split.

Fixes: fa23a338de93 ("mm: separate folio_split_memcg_refs() from split_page_memcg()")
Cc: stable@vger.kernel.org
Signed-off-by: Tao Yi <escape@deepseek.com>
---
 include/linux/page_ref.h |  5 +++++
 mm/memcontrol.c          | 14 +++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 9f5c75d06f76..401330307bc5 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -107,6 +107,11 @@ static inline int folio_ref_count(const struct folio *folio)
 	return page_ref_count(&folio->page);
 }
 
+static inline int folio_ref_count_acquire(const struct folio *folio)
+{
+	return atomic_read_acquire(&folio->_refcount);
+}
+
 static inline int page_count(const struct page *page)
 {
 	return folio_ref_count(page_folio(page));
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..2971e5e0ece1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -358,17 +358,29 @@ struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
  */
 ino_t page_cgroup_ino(struct page *page)
 {
+	struct folio *folio;
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
 
 	rcu_read_lock();
 	/* page_folio() is racy here, but the entire function is racy anyway */
-	memcg = folio_memcg_check(page_folio(page));
+	folio = page_folio(page);
+	/*
+	 * After-split folios remain frozen until their metadata, including
+	 * memcg_data, has been initialized.  The acquire load pairs with the
+	 * release store in folio_ref_unfreeze() and makes that metadata
+	 * visible to this caller.
+	 */
+	if (!folio_ref_count_acquire(folio))
+		goto unlock;
+
+	memcg = folio_memcg_check(folio);
 
 	while (memcg && !css_is_online(&memcg->css))
 		memcg = parent_mem_cgroup(memcg);
 	if (memcg)
 		ino = cgroup_ino(memcg->css.cgroup);
+unlock:
 	rcu_read_unlock();
 	return ino;
 }
-- 
2.53.0


