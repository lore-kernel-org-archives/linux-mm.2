Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1CAC5AC80
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 03:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9E66B0088; Fri,  7 Aug 2026 23:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B336B008A; Fri,  7 Aug 2026 23:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49966B008C; Fri,  7 Aug 2026 23:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A504E6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:16:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE056C02AC
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 03:16:21 +0000 (UTC)
X-FDA: 85076638962.28.4277E52
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id ECD57100009
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 03:16:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="d1wj/x2O";
	spf=pass (imf14.hostedemail.com: domain of sh_def@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786158980;
	b=nJsYsb5dst2cqrNWaUnb/t+DGnv3riE6uu4aliP7Jq4VIzZ0mP1ozBChLvH30GSN6pChAX
	uMdqHAGkRqnoirPUisQygfBr6pz+BLsL06l6XxtfpKBfHNKclDP4jTJEUUa4QLr0TGUDNP
	Uc+KdfIBfc5ifTAFKXAT7RI0VVCHOUI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="d1wj/x2O";
	spf=pass (imf14.hostedemail.com: domain of sh_def@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786158980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yFxoYkm6JojXNUVuKu6qzrezBLUlcTSSEZm/pGV4e6I=;
	b=dIFDDnGaw7d/8rad2OkBNhLLSKMFwQ9JcEQIbxPXhgb+EmQi4AQsxqDWemoq4cgQZifvGZ
	TsAM2PpFgXbQixyEXbrpcKME6NhHoj6pd6y77AxTHdBf1Z/DmwfrRG8NnuvES2cBbv3F7v
	nH+XYs4aB23a4Mtt9Cw7NOuxdv9NmR0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=yF
	xoYkm6JojXNUVuKu6qzrezBLUlcTSSEZm/pGV4e6I=; b=d1wj/x2OXuvoqNF1TM
	tpseKZpWuR5WJcjlhcyDfL0FTyNiVFd8JDkWVBXHlfhlbPE9slIEt6s7uZs0HMCX
	+LNzByKybG9+L1g21mSXU/U38dgMWMqoHxqRmVjegMkR/WeeAXpHyck3nA4/7Maf
	VkHP5YAVQppnyASLVMX+rtPS0=
Received: from localhost (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgC3QCBin3ZqScbJLA--.19934S2;
	Sat, 08 Aug 2026 11:15:47 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Zqiang <qiang1.zhang@intel.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hui Su <sh_def@163.com>
Subject: [PATCH v2] kasan: fix cache shrink race with CPU hotplug
Date: Sat,  8 Aug 2026 11:14:59 +0800
Message-ID: <20260808031459.3032812-1-sh_def@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgC3QCBin3ZqScbJLA--.19934S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxurW3XF45WF1rtw48AF1DWrg_yoWrtw47pF
	y3Ka47Jr18Wr18tanrGa1UWryrAFZ8ZFnxXwsagw1FyF45u34DW34UKrW0vFWUWryrJa15
	t3Wvya45WFWqyF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-Originating-IP: [183.192.100.171]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6gU5mGp2n2XpBAAA3F
X-Rspamd-Queue-Id: ECD57100009
X-Stat-Signature: b8xxu87e9xq16m4xguik73f8djh6q1uq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786158978-477760
X-HE-Meta: U2FsdGVkX18VG7zzUEotGUDQ+p7XLZ/+6E446Z60+v83LEE9TMGmiUJuRN3/36yZHCI7EXGEwVhl5HYgF7V5KD88Ky/jzmVCZSA1QkvIfLZtXv/HTwHuuyYH+zP0WzoJlSanOJHXXK/RQ3YNpUtLjSaOBtwsXZZsKh2z9K2jU48r47bOV0ACHmmS0aTcpasYtlDGlTw+GrNp9UExUOfv7N7K/un8Ch17jbdAIf6bDBaOx5+9RQMLd4E0BgpP6qIu1E7zCUGmlMspBd2nrGueVZKZK6+OSHdWbIe2Ic2ex8giGmZBpI5AjRBBqedrU3aCjk1yyjmcixjOmYjWGx3R7UVcTpfdtVPho+VCzlzwlRTalLSezOL9lt+Lr9WRhtGSXWFfTKFaAlqzXGGqYH5TAQWzKrrGGElKL+3BJE8OuVm9p6FrB/NoDBomjdcQPl4aUz3fwvofwZ1R/ZPAyppz1fQTs41naeXITyWKbxE9RROa1U/5677gEILkj03cY7ChS0Jcrs5IwC0aoie9+DQjk3E9NKmVO810kLKDsLN8ZgC8U08o11c95CZ3vUMuFz+e25Ec1SRFQ7MKwf2NZI67UDb4+GVXFdjXl/E13qbuYtJEFeuMqIfGmC6rDXGWxyxZrQYRSoNuZRS9dR16XTiULyKaE2nXgjK4phUodjK2duzyCGiZ7YzO/82UvDteAuBNLOtDk42/jexKIqxgwmRjelW/0Tk0iTTlDAkM2WrbvRCfNSXdCJLzN8c2hgOr85n/3V8xh4sTPO7Ff2SgUmRohFQcvDzZIY2xn+mHenicRkUMRWzPHG0OqUMSDcLmhFBQ1hUaFUqYleyqklgbYvNLIAGCmvNjgufZtG7kuWI+z2pg6LJaAfQqsbX8qqX/4BKGPSt9jNPqVaN0FAjKHFFUqeVorGnCQxiwqeauLPXZGJKluYKTptJI3tcvcsXRebj6DWtkstedhVV1z/cVKNf
 yd7BOfgs
 58r3rGs4V7VME8aJ/gsNWaS4vtSz/L+nR6KIyX3zbfI8vU1ouvd0k1QXcwou82i9uuv6Rci2uDE7B4vw3IReja1LO7lLhQjtc5Fu/lDM0fqT59O8i4FyWJs4o49CUqIVLnNNaW+eMkVpSJBDSs2ens13LZ7lOTVT2Yz2F6oP6wRkSIZ4/Z1wcjkkbk83yYR2YRofBLORAXahpu6fA3PFWjH90/gKP0KmrGKOkzcQIMhzKJ+YAg3um+oAYawr2OSkZS+rDFkg+yQXXgz2dAKiPl6vRNL5BoG/uDL46EdJq73KwGgRjN2yp/7UQ9YtNl4l/U8ssiOIMYB3ULk1Vg+U4Peeq8hpbmIQ+2LblABQ661uo1/NSbysORB3G40HmgncCnfT9GRUysn2S+ZayDC9fLuZ0xCseZFKi4JwNM7jfXrs92kdGFMFhvFkflIzeFV/WCXVnWbHdJFwQDdmz+zGnCg1zbXk9Tr98ZAwx8H0kGcHA6W0tVWIwekb5f3kBY53nt5/w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_quarantine_remove_cache() first invokes per_cpu_remove_cache() on
all online CPUs. Each callback moves objects belonging to the cache from
cpu_quarantine to the CPU's shrink_qlist, where they can later be freed
from task context.

kmem_cache_destroy() invokes the quarantine removal path while holding
cpus_read_lock(), but kmem_cache_shrink() does not. The latter can
therefore race with CPU offlining as follows:

  kmem_cache_shrink()             CPU hotplug
  -------------------             -----------
  on_each_cpu()
    CPU1 moves objects to
    CPU1's shrink_qlist
  on_each_cpu() returns
                                  CPU1 goes offline
                                  kasan_cpu_offline()
                                    drains cpu_quarantine
                                    leaves shrink_qlist untouched
  for_each_online_cpu()
    skips CPU1

The objects left on CPU1's shrink_qlist are not returned to the slab
allocator. This may prevent kmem_cache_shrink() from releasing slabs
that would otherwise become empty. If CPU1 remains offline, a later
kmem_cache_destroy() also skips the list and can report that the cache
still contains objects.

An intermittent occurrence was observed with a virtio-9p filesystem.
The mount and umount commands both returned 0, but the kernel logged
the following during the userspace-triggered teardown:

  [  2994.380134][  T111] BUG 9p-fcall-cache-1 (Tainted: G    B              ): Objects remaining on __kmem_cache_shutdown()
  [  2994.381140][  T111] Object 0xff11000004361118 @offset=4376
  [  2994.381607][  T111] Allocated in p9_fcall_init+0x201/0x400 age=19564 cpu=1 pid=104
  [  2994.382591][  T111]  p9_fcall_init+0x201/0x400
  [  2994.382810][  T111]  p9_tag_alloc+0x12f/0x700
  [  2994.382982][  T111]  p9_client_prepare_req+0x102/0x3e0
  [  2994.383165][  T111]  p9_client_rpc+0x1ab/0xa50
  [  2994.383334][  T111]  p9_client_getattr_dotl+0xb0/0x1a0
  [  2994.383515][  T111]  v9fs_vfs_getattr_dotl+0x115/0x360
  [  2994.383719][  T111]  vfs_getattr_nosec+0x22c/0x3a0
  [  2994.383910][  T111]  vfs_statx+0xd7/0x170
  [  2994.384062][  T111]  vfs_fstatat+0x45/0x80
  [  2994.384215][  T111]  __do_sys_newfstatat+0x84/0xe0
  [  2994.384386][  T111]  do_syscall_64+0x115/0x6a0
  [  2994.384566][  T111]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [  2994.399720][  T111] WARNING: mm/slub.c:1244 at __kmem_cache_shutdown+0x363/0x500, CPU#0: busybox/111
  [  2994.405655][  T111] Call Trace:
  [  2994.406325][  T111]  kmem_cache_destroy+0x73/0x1b0
  [  2994.406630][  T111]  p9_client_destroy+0x271/0x3c0
  [  2994.407210][  T111]  v9fs_session_close+0x3c/0x260
  [  2994.407409][  T111]  v9fs_kill_super+0x48/0x90
  [  2994.407584][  T111]  deactivate_locked_super+0xa3/0x160
  [  2994.407778][  T111]  cleanup_mnt+0x1dd/0x3e0

Thus, a successful umount left objects in the 9p fcall cache and
prevented the cache from being destroyed cleanly.

Per-CPU shrink_qlist storage exists for every possible CPU, and each
list is protected by its own raw spinlock. Iterate over possible CPUs
so that a list populated before its CPU went offline is drained as well.

for_each_possible_cpu() can do more work than for_each_online_cpu(), but
this change only affects CONFIG_KASAN_GENERIC kernels. The extra work is
limited to cache shrink and cache destruction paths and does not affect
the normal allocation/free fast path. It adds one raw-spinlock-protected
scan of each possible CPU's shrink list. These lists are normally empty;
a non-empty list is traversed to remove objects belonging to the cache
being shrunk or destroyed.

Fixes: 07d067e4f2ce ("kasan: fix sleeping function called from invalid context on RT kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
---
Changes in v2:
- Document the intermittent virtio-9p slab shutdown log and user-visible effect.
- Explain the runtime cost of scanning all possible CPUs.
- No code changes.

Link to v1: https://lore.kernel.org/r/20260806121006.1642946-1-sh_def@163.com

 mm/kasan/quarantine.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 6958aa713c67..16f4e67beee8 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -355,7 +355,12 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
 	 */
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
-	for_each_online_cpu(cpu) {
+	/*
+	 * A CPU can go offline after on_each_cpu() returns, leaving cache
+	 * objects on that CPU's shrink list. Scan all possible CPUs to
+	 * drain those lists.
+	 */
+	for_each_possible_cpu(cpu) {
 		sq = per_cpu_ptr(&shrink_qlist, cpu);
 		raw_spin_lock_irqsave(&sq->lock, flags);
 		qlist_move_cache(&sq->qlist, &to_free, cache);
-- 
2.43.0


