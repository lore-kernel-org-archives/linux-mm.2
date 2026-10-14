Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE2CCC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A210A6B0088; Tue, 13 Oct 2026 23:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0FC6B0095; Tue, 13 Oct 2026 23:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899426B0096; Tue, 13 Oct 2026 23:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 550E26B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:13:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAF281A040C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:13:16 +0000 (UTC)
X-FDA: 85319760792.11.7C79309
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf25.hostedemail.com (Postfix) with ESMTP id C191FA0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:13:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nW27Ss9q;
	spf=pass (imf25.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791947595;
	b=cZ2jOR8dSJZJd8NclhgUY+O7PCDoBo4wS9QIGpyLtu0TxUKulj6eM0SaWwgkX43MEe5a/H
	QIikEXwZ1eJIFT/XRVpCREaioDoCKjQF/16IYVS3OiqV31/6KFeHCBgmNRb6m2qAvCbr53
	q53Qqv4dZ487GbohoEWsPCJ34GOC+QI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nW27Ss9q;
	spf=pass (imf25.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QgDLweGJbcN+p8LbKPcNn2/Fq8wZFtiysyyozTFsl6I=;
	b=7XnJFdbKgN5jAsfUvYm7XZhMnlSygOv/mUPx3UUzstiN+IC0prHsSZ5eYlvoqQO9dXjMrM
	6hpgOlToEbmUeYl+jIXaOVM6Czj89c80YuBwNj4II1PYAkAJQ6tMa9rdUpxv/4gP1lYaXf
	Zaqry5yWSwzcUEpl0vLAHFpimbEqzEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Qg
	DLweGJbcN+p8LbKPcNn2/Fq8wZFtiysyyozTFsl6I=; b=nW27Ss9qtXLqBTup6y
	sOtw6aW0wluKo3t/4JSS/Vc46dypJka8JcZyuCjyYygWEpMV0TC080091e9V8USF
	JW4pzxXO3GXeiN0W4R4q9z+l6rifplFumQLZP+bj68IBMcbUGomUhxW1sNo+DtdT
	RKlrhCeVMv6whVNCyth/ZgvLc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD330I_885q6IC7Eg--.21712S2;
	Wed, 14 Oct 2026 11:13:04 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/memfd_luo: preserve the sealed exec-bit state; fix retrieve() leaks
Date: Wed, 14 Oct 2026 11:12:52 +0800
Message-ID: <20261014031254.432582-1-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD330I_885q6IC7Eg--.21712S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtw47Kw4xCFyfCw4DuF1xZrb_yoW7Zw1Dpr
	Z8Kwn8A34DGFyIvw47Zw4IvFyrA3yfJF45JrsrKry8Cay5WFnaqFyS9ayY9FyUAw1Sg3ZF
	vF4UCw18uayDAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFE__UUUUU=
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC9gFbI2rO80FOCwAA3c
X-Stat-Signature: t1x3hp7rkozow3z84wscjbqmfs1aeq8m
X-Rspamd-Queue-Id: C191FA0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791947593-422233
X-HE-Meta: U2FsdGVkX1/SQYs39cWVE5i3KCWhWGiJxZNbcfNehJjQgKHkBDu6mmtsBjuV2NeNcPOJUL3rlEQI9w/p8GTA3VsSW01Z0mL52mpr4Lu6/warv4Z75Fyl1dlBim2U/OzCIG/2p0jObksuCHaHM2h/8JZ4XQrTZaLlKXIdK5/8dnt38BJQl0BNjj162Q4GEVBuAb+MiVo2LvtMOC1E1xxjrVLaSK561EGeiNd7+ez84jJTtQbKLJZYlLxk6vgv3h2fNNhxpJNIUc9g1/EAHKWcRKKRz5nXJvgDBX/TMD1A4nvm4iofiET2CmojUn1GvmHJyd57huxCr7qEQDkdSxL7eCekhItAchh49GIqLnUbUbsxxEEwBzWyhy6g+5L+wR33RUcbTIIoNM7sqIFjkNaRq7RIw0nWkmR1WmGGnFarmIUU33Vb5LOPgFjasoSyZRKltlxXwbFy8kPHYi0RwGGY+ORvi7aD8lTiSy5YRCJvaGO6Xw+ZYsFZKvMy2hTaLWRTJ7vYMtub/eeHiIbAyVbPo1d0PU+08JJsC561rP1uB/RuqokNjXaBWwRKdqmTR6aX7VGA8lDJh32/Um4FCe4xzEhBRnLyXR1yv/Pda+j/XoG6ZIhiAEGf97JMBRaeNJKmIaKjvA2GoxJkt+CS0tYbnXsrahgYb5q1sLeij/hJAu3hHtABpd+CCZYvWsuyh/kTzUORr+JfMYP1W3dKwC4hllSr/v3/WelAxi51UaqjnD4jSgoytn6Pl15ToZ8BjlhlwafeO6cMdiwBPvYUC2C1ClqBrKYEVmEh7D2ZMz+0LwmGZ/3Sc0zxgrO/+7tR3E6ODg6rN7Mcf3IuLykJjGBU2i67cBB8uZV0/iEbARqwMl8lWiiLq3sWQUm5xKbf5Hmh9IqOum45L9epiK2U0RQenuBzfy1iWmI6+gM3odZQT2QBhISkph7g++JGhKWGmsKJnDjLIc6y7Q4EcCmFjQI
 WBaIEncB
 GtfOXObje0wZ/9Ys7FzRyeCTusFvVjSxPPqbggBcvj4USRDDP8y1sdN9dcthRzTiAPMlrIqONPpGFD+AEW7Rylo4YMiDh+4NLPQdIuT+pNYjt0dUUEpI36F18yKVRp8GdJ3mStc/RUnpp6o3tEQJX2luk6qj4IC+SlIy88P/CC0u/K11OKEFDs6Dq+ZG8IHgiT3awvn/LvXIGOueHmKPK6+Q2pFsQUuOkGwbgGb1t9WFKK9IpZND6ONCozFN8YLSINTZUOt2iOcK6Pl7c/nrQ+zdlHYP7oi4Bkka4sxX2GWI7Yo5UFLTZbOI9CixY5HaMX9+y22iIpozOv2Wdxg/oRNEviIlDKzZ3y2VVoNNOydA/I1eJcYWwXA8HaR6gjdx/4TEB4g2e52Xjm7TaQrlB+Xq4MghdxASon8TL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v1: https://lore.kernel.org/all/20261014003558.357783-1-18766350203@163.com/

Sashiko reviewed v1 and reported two issues, both of them real: the execute
bits were sampled long before the memfd stopped being usable, so the record
could be stale by the time it was handed to the next kernel, and retrieve()
leaked the preserved folios on its error paths.  Both are fixed here, together
with a third problem that the same reasoning exposes (the record carried a
single "some execute bit was set" flag, so a partially executable memfd was
restored with execute bits it never had).

Changes since v1:

 - Record the user/group/other execute bits separately instead of one "some
   execute bit was set" flag: an execute mask of 0100 was restored as 0111,
   inverting the guarantee this series is about.
 - Take the final sample of the execute mask and the seals in freeze(), under
   the inode lock, and freeze that state for the rest of the transition.
   shmem_setattr() (chmod), shmem_set_acl() (an access ACL rewrites the mode
   without going through shmem_setattr()) and memfd_add_seals() all reject
   changes from that point on, and a new .unfreeze callback clears the state
   when the update is rolled back.
 - Reject records with flag bits this version does not know.
 - Bump the record version to "memfd-v3" and keep reading "memfd-v2" records
   through a read-only handler, so that a record is never restored by a kernel
   that does not understand its flags.
 - Release the preserved folios when retrieve() fails, by sharing the cleanup
   with memfd_luo_finish().  This one predates the exec-bit work and is a
   separate patch with a Fixes tag.
 - selftest: an execute mask of 0100 with its full 0x3e seal set, a memfd
   without execute bits (MFD_NOEXEC_SEAL: mask 0000, seal set 0x20, still
   writable), and a skip when vm.memfd_noexec forbids MFD_EXEC.
 - Document the execute bits the record carries and the restrictions that
   apply once the update is committed to.

On record versions.  The flags cannot tell "the execute bits were clear" apart
from "the writer did not know about the flags", so records written before the
flags existed have to be told apart by the version string, which is compared
with strcmp().  The version is therefore bumped and a read-only handler for
"memfd-v2" is registered next to the current one:

  record writer   reading kernel and handler     result
  old v2          old kernel, v2 handler         default executable mode
  old v2          new kernel, legacy v2 reader   no execute bits
  new v3          new kernel, v3 handler         exact exec mask and seals
  new v3          old kernel                     no handler, -ENOENT

The legacy handler only reads records written by an older kernel: its
.can_preserve() always returns false, so it is never selected for an outgoing
preservation and every new record is serialized as "memfd-v3"; a "memfd-v3"
record is never handed to it either, because the compatible strings have to
match exactly.  If registration of the legacy v2 reader fails, the already
registered v3 handler is unregistered as well, so the kernel never ends up with
only one of the two handlers registered.

Row two is a one-time behaviour change for records written by a kernel without
these flags: an executable memfd preserved by such a kernel comes back without
execute bits.  That is the safe reading, but it is not what the old reader did
-- it never looked at the flags at all, it restored the default (executable)
mode -- so the change applies to every such record, not only to the ones that
were sealed with F_SEAL_EXEC.  Without the version bump an old kernel would
instead read a new record, ignore the flags and restore the default executable
mode, undoing exactly the guarantee this series restores; with "memfd-v3" it
has no matching handler at all, so the deserialization of that session fails
with -ENOENT instead of the memfd being restored wrongly.

Two things I could not close here, both written down in the patches:

 - f_pos can still change after freeze().  The LUO file API has no global
   userspace quiescence before .freeze() runs, so this needs a framework-level
   answer rather than a memfd one.
 - If kho_restore_vmalloc() fails, the folio array cannot be walked and the
   folios stay reserved; that API is not failure-atomic and cannot be retried
   after a partial failure.  A KHO-side fix or an allocation-free
   discard/iterator API would close it.

Testing:
 - the kernel builds from this tree with the liveupdate selftest config (plus
   TMPFS_POSIX_ACL/TMPFS_XATTR, so that the new ACL path is compiled);
   mm/memfd_luo.o, mm/shmem.o and mm/memfd.o build without warnings
 - QEMU live-update round trip (preserve -> kexec -> retrieve) with the new
   selftest: PASSED -- the memfd with execute mask 0100 and seal set 0x3e
   comes back with the same mask and seal set, and the memfd without execute
   bits comes back with mask 0000, seal set 0x20, data intact and writable
 - the same test against a kernel without this change: "execute mask changed
   across kexec: 0111 != 0100"
 - checkpatch.pl --strict on the series: 0 errors, 0 warnings
 - not covered by the run: the freeze-time rejection (it happens inside the
   reboot() path, so userspace cannot observe it) and the ACL path at runtime

Haolong Wang (2):
  mm/memfd_luo: carry the sealed exec-bit state in the preserved record
  mm/memfd_luo: release preserved folios when retrieve fails

 include/linux/kho/abi/memfd.h                 |  24 +-
 include/linux/shmem_fs.h                      |  20 ++
 mm/memfd.c                                    |   6 +
 mm/memfd_luo.c                                | 240 +++++++++++++++---
 mm/shmem.c                                    |  35 ++-
 .../selftests/liveupdate/luo_kexec_simple.c   | 208 +++++++++++++++
 6 files changed, 490 insertions(+), 43 deletions(-)


base-commit: 3a0b8fa2eb36afc88b62a95f33f0c77c71fa5ded
-- 
2.56.0


