Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875B6606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 08:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68CB66B00EF; Sat, 21 Nov 2026 03:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DC16B05B0; Sat, 21 Nov 2026 03:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553456B05B1; Sat, 21 Nov 2026 03:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 272BA6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:32:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EAD5160391
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:32:31 +0000 (UTC)
X-FDA: 85458459702.27.F4FCE0E
Received: from cockroach.ash.relay.mailchannels.net (cockroach.ash.relay.mailchannels.net [23.83.222.37])
	by imf31.hostedemail.com (Postfix) with ESMTP id D45F420005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:32:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of brad@sim.vu designates 23.83.222.37 as permitted sender) smtp.mailfrom=brad@sim.vu;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795249949;
	b=d7RQa7VzRiBqySRT+NmBlS72e4mgDvNjNbWo9K6odSeMcn9ekRkT6E8W7EEy3WPInH/2ag
	Q+sC+ZIIA/vOrjqikwo0WxO9jltPVTTS8psH0nCnBvwJfW3VI8sy9jmDOxh26cq630oyhU
	n8Ekg79ux8NlPVQE9PMImI/7DnJOKII=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795249949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=U3QJzZioSMNb19niLTdHJqpa/pin/cGmv4Gv8E2Edm4=;
	b=hihKdqP52ge8cN43IpSuZ2kTHETivSbNuBskhXq9r+5w36ZjSIaXcYrp9zrM/aMeId+kWI
	dibOtAQ4lhkJvu/JdPpaO23O4sVk+OVy9VF2OzCJ5Vt4qwztpVpB+uSQ6ETERO4rjEEJt9
	ESEzyNo920ULQ0QBWx5TLFHaJbRqmIY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of brad@sim.vu designates 23.83.222.37 as permitted sender) smtp.mailfrom=brad@sim.vu;
	dmarc=none
X-Sender-Id: instrampxe0y3a|x-authuser|brad@sim.vu
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 078AC600F3;
	Sat, 21 Nov 2026 08:32:27 +0000 (UTC)
Received: from cpanel-010-lon.hostingww.com (100-97-173-43.trex-nlb.outbound.svc.cluster.local [100.97.173.43])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id DF451629DE;
	Sat, 21 Nov 2026 08:32:20 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|brad@sim.vu
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|brad@sim.vu
X-MailChannels-Auth-Id: instrampxe0y3a
X-Juvenile-Ruddy: 2530bb0949302cad_1795249946826_3700707252
X-MC-Loop-Signature: 1795249946826:3590204740
X-MC-Ingress-Time: 1795249946826
Received: from cpanel-010-lon.hostingww.com (cpanel-010-lon.hostingww.com
 [18.130.191.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.173.43 (trex/8.0.2);
	Sat, 21 Nov 2026 08:32:26 +0000
Received: from 162-195-230-196.lightspeed.wchtks.sbcglobal.net ([162.195.230.196]:35312 helo=epyc.attlocal.net)
	by cpanel-010-lon.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <brad@sim.vu>)
	id 1xUgWA-00000002cE4-01LZ;
	Sat, 21 Nov 2026 08:32:18 +0000
From: Brad Hawthorne <brad@sim.vu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	Brad Hawthorne <brad@sim.vu>,
	Hajime Tazaki <thehajime@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/nommu: keep the maple tree in step when mremap() resizes in place
Date: Sat, 21 Nov 2026 02:31:39 -0600
Message-ID: <20261121083139.803682-1-brad@sim.vu>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: brad@sim.vu
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D45F420005
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hq1k4s5xhhikyohjitm6pwpnt33y6pc7
X-HE-Tag: 1795249948-856423
X-HE-Meta: U2FsdGVkX19/oMQtLPyCqYI0jTBQ25ofayG/quRhRbZUcIx1XsKMouKISEm1pHc3tToERn5WUrJOVKvBYMiMej81PqhOufQoP9xHaBzfC3pT4ZDp2jw+tv4vwGk7HFb4+S7AKom9MwvAbJOuiargK7H5hVqNtavbnI/3GmMtVnpVkdyKC21WZS6tJ7iL+B0++TdMqHsryZw/S4mEByg5BjO91eGG2IE7JPjTXDEo7ZVZkM9M9Me19yjqdpbeZuMdSRKQEJR4YAju2PNsG3v+9sj9mkEhhG6Evs8oRQlGe89AQ1KJEjX3S04Dt0Z/UxIg4aMl5AVjvoo9AgjOG8oonduuAPDf7XHcGfF6w2mPEyvOfRds5IWE1LXAO0CZKv0Negb481lDYL5urgX5f296t0hbnocCqDj4vhQ0p+NzTxGamYCDdMfG8+lOWe0ZO3WoRRqGdWk5VImcMgkIE0npIOzIFW5ttD30eIlNcAcmW83axdhHbZnqlAAvEwHYrhoJyHwLkiZGOmeW4aKqNeLc/ZrXLfOuC8hjymWuzN8J78pGhUnJs9jzewaIAoFdI5flfh/ykwv6e+hmv+ts70H3HzVrvH22B5o5iAcJ43xBpq4IvZmSM/vAF2ukc+sBuO/N5ONsi2nYVNfpbjTaoJeT1yUFGtbEYO+jPiN5vj3cBlGkeZTM1FVM4zFUvUxXxgN+D+5e8FCaxibwkhcigb0nfutslwtU5KelYClLaxKW6zhaFXXpOWUD6NdjOcZF7/yALvHJvf46yDAs7EzSGCYiLYKtuuif65ZTHJzJCnDffTSqloyj9b4yO5mrPC0Y/DkFCy+RL4uvbB4mFRYc985NVMIq4EZnKvt0NrBqJp32Rzxk9G/u5KofH9gquEhgTIL3YqriXzcqpUaknmk+sXyk89/07UAEwp4RVK00GuelJvQRcZiePZ9J0lU6AoScQB+T/SCoiwmT2v+nMWW1b4U
 1euTDnuq
 aA7ryorJZ2t8JBc+cl+CeLvosCko5BNH/BHiRg9vF3fAYds+LqfE+dkwz1wGxv16Exext1jV9pc2a6TlH0GUnziu5nj4H0z8xq8TL2ZxTG4pjuwTzL8YiXcR+Wp13+G8I+EPyJ+zX9RPLOFqOdYyqq+ceUhAQ6FM4ul/q54P3YjTRo6gy1TkfDLXq9GMxDu7GYaIsrpj4JSGxG16UVh9sIGacb+RYXsEdKKtGdfPFVsNu0u9HVoFC866TiHIOPAcTqBu4gU8Px/YGyMmwvdBgn+bm/jbjleQpjSPXuP1VzzfzYo/1VpVR6hazluNQ9xR/8OY7Dzv2LHajSesAd8Dy6Pw1yj9uKA6DcjQa02lEb1i2Z9ZAlL7Z1Uk6yzhRkWvq99ISA+yPFoijPkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On !MMU, do_mremap() resizes a VMA by writing vma->vm_end and nothing
else, so mm->mm_mt keeps the old extent.

After a shrink, [new_end, old_end) in the tree still points at the VMA.
When the VMA is unmapped, delete_vma_from_mm() clears only
[vm_start, vm_end), so that range survives and points at the freed
vm_area_struct. Lookups in the range then read freed memory (after the
munmap(), /proc/self/maps still lists it), and exit_mmap() frees the
VMA a second time. An unprivileged process is enough:

	long pg = sysconf(_SC_PAGESIZE);
	char *p = mmap(NULL, 8 * pg, PROT_READ | PROT_WRITE,
		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

	mremap(p, 8 * pg, 4 * pg, 0);
	munmap(p, 4 * pg);
	_exit(0);

It was first seen on an Adafruit Fruit Jam board (RP2350, Cortex-M33)
running 7.3.1. There, three rounds of the program's mmap, mremap and
munmap leave the process's vsize at 2133 KB instead of 64 KB, and the
next exec faults the kernel, in vm_area_alloc() or __kernel_read()
under do_mmap(): the double free has corrupted the slab. With this
patch on the same kernel, 11 of 11 runs keep the vsize at 64 KB and
the board runs on.

On mm-unstable at the base commit below, under QEMU mps2-an385
(mps2_defconfig plus SLUB_DEBUG_ON), run as uid 65534:

  BUG vm_area_struct (Not tainted): Object already free
  Allocated in vm_area_alloc+0x10/0x38 age=0 cpu=0 pid=20
  Freed in do_munmap+0x2ec/0x2fc age=0 cpu=0 pid=20
   kmem_cache_free from exit_mmap+0x7c/0x8c
   exit_mmap from mmput+0x2a/0x74
   mmput from do_exit+0x1f8/0x520

Clear the range given up on a shrink. Once a shrink clears it, a later
grow back into the region must store the VMA over its new extent, or
find_vma() would miss addresses that are mapped; so store it there on a
grow. Shared and overlay mappings are refused above, so the region is
this VMA's alone, and the grow is bounded by its size; but the range a
shrink gave up may since have been mapped again, by a direct mapping of
device memory at those addresses, so a grow into another mapping fails
with -ENOMEM. As before, a shrink keeps the region's pages, which is
what lets a grow back reuse them.

With this patch the program above exits cleanly, with and without
DEBUG_VM_MAPLE_TREE (nommu has no tree validation of its own, so that
adds only the store's warnings). A shrink, grow and partial munmap()
sequence also passes, and fails with the shrink half alone, which is
why the grow half is needed.

524e00b36e8c is where nommu find_vma() started trusting the maple tree;
the exit_mmap() double free above follows from 8220543df148 ("nommu:
remove uses of VMA linked list") in the same v6.1 series.

Not changed here: a private file mapping's place in the file's i_mmap
tree also goes stale on a resize. That predates the maple tree and is
left to a separate patch.

Sashiko's review of Hajime Tazaki's nommu series found the stale range
in July, and his fixes and RFC since then cover it [1][2]; review asked
for a minimal fix-only patch with a Fixes: tag [3]. This is a minimal
version of that fix.

The consequence was reproduced and this patch drafted with an AI coding
assistant (Claude, Anthropic): it reviewed mm/nommu.c, wrote the
reproducer and ran the board and QEMU tests; I checked the result.
Stable backports need adjusting: 6.6.y and 6.12.y lack
vma_iter_store_overwrite(), and 6.1.y nommu uses the ma_state API.

Link: https://lore.kernel.org/linux-mm/20260710021028.892645-1-thehajime@gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/20260813063401.1786548-2-thehajime@gmail.com/ [2]
Link: https://lore.kernel.org/linux-mm/an77pELeQdW-sTEi@lucifer/ [3]
Fixes: 524e00b36e8c ("mm: remove rb tree.")
Cc: Hajime Tazaki <thehajime@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Brad Hawthorne <brad@sim.vu>
---
Hajime, as you asked, here it is as a separate patch with you on Cc.
Earlier note, and his reply: https://lore.kernel.org/linux-mm/20261120221021.789792-1-brad@sim.vu/

 mm/nommu.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index df99495c8..9221cd241 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1575,6 +1575,7 @@ static unsigned long do_mremap(unsigned long addr,
 			unsigned long flags, unsigned long new_addr)
 {
 	struct vm_area_struct *vma;
+	unsigned long new_end;
 
 	/* insanity checks first */
 	old_len = PAGE_ALIGN(old_len);
@@ -1601,8 +1602,37 @@ static unsigned long do_mremap(unsigned long addr,
 	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
 		return (unsigned long) -ENOMEM;
 
-	/* all checks complete - do it */
-	vma->vm_end = vma->vm_start + new_len;
+	/*
+	 * All checks complete - do it.  The maple tree must cover exactly the
+	 * new extent: a range given up but left in the tree still maps to this
+	 * VMA, and once the VMA is unmapped and freed, to freed memory.
+	 */
+	new_end = vma->vm_start + new_len;
+	if (new_len < old_len) {
+		VMA_ITERATOR(vmi, vma->vm_mm, new_end);
+
+		if (vma_iter_clear_gfp(&vmi, new_end, vma->vm_end, GFP_KERNEL))
+			return (unsigned long) -ENOMEM;
+		vma->vm_end = new_end;
+	} else if (new_len > old_len) {
+		VMA_ITERATOR(vmi, vma->vm_mm, vma->vm_start);
+
+		/*
+		 * Shared and overlay mappings were refused above, so the
+		 * region is this VMA's alone and still holds its pages: the
+		 * grow, bounded by the region's size, stays inside it. The
+		 * range a shrink gave up may since have been mapped again,
+		 * though: a direct mapping of device memory can take any
+		 * address.
+		 */
+		if (find_vma_intersection(vma->vm_mm, vma->vm_end, new_end))
+			return (unsigned long) -ENOMEM;
+		vma_iter_config(&vmi, vma->vm_start, new_end);
+		if (vma_iter_prealloc(&vmi, vma))
+			return (unsigned long) -ENOMEM;
+		vma->vm_end = new_end;
+		vma_iter_store_overwrite(&vmi, vma);
+	}
 	return vma->vm_start;
 }
 

base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
-- 
2.43.0


