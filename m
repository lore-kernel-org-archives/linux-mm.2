Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CCE606D816
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=karaolidis.com header.i=@karaolidis.com header.a=rsa-sha256 header.s=protonmail3 header.b=gTIswOwx
Received: by kanga.kvack.org (Postfix)
	id 91FE66B05B7; Tue,  3 Nov 2026 04:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8614C6B05B8; Tue,  3 Nov 2026 04:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE3C6B05B9; Tue,  3 Nov 2026 04:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2133A6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:51:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 857B912035B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:02 +0000 (UTC)
X-FDA: 85393339164.05.7E2F820
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id AE32C1A000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=gTIswOwx;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com;
	spf=pass (imf19.hostedemail.com: domain of nick@karaolidis.com designates 109.224.244.108 as permitted sender) smtp.mailfrom=nick@karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6HeAXp7yX1tk/C25b06NP0zuPlHPPh/+Hik7J1wwkx4=;
	b=JNeDD1ncVcbGoPfWQWtksw7n50xovSCTAMncgzqMcJPWBi13pMQaI2Bl6PsyLbis6gYSRW
	MCkxskNEuKYVH5B75jL0aCEMkvQ/IPbwHDiQGtLDABH9MFV14wALGzK3eB08Dwvq5n9MZc
	yegOT0I365wZY+y/j31CgCKBybv1Xww=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=gTIswOwx;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com;
	spf=pass (imf19.hostedemail.com: domain of nick@karaolidis.com designates 109.224.244.108 as permitted sender) smtp.mailfrom=nick@karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699460;
	b=XCGefTl5dK5oacqoKBNIzzQnFYXEHWA5BJRAGa3RtV03Gy0dgTRBPwhAD4QKStZ4aqCWWO
	x9GBlEGGDs0DBbhr6TtjTkrDAMhIcKIzF+Id3OylUyLhqzAWcpwB5NDk9nuJ9mmHWZlql4
	LQ14J67QqejByyQ9c/z014ApV++dziM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1793699458; x=1793958658;
	bh=6HeAXp7yX1tk/C25b06NP0zuPlHPPh/+Hik7J1wwkx4=;
	h=From:Subject:Date:Message-Id:To:Cc:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=gTIswOwxYUKlWxErWTokOEKDObVzE4bKBY/CclpMYDcrnQpos3B4Chm/GAQYdO9ne
	 NCFU0Nm/1acbnYIthTxWyYkezlUio/rHrN/azR3xwQEZMaNqLXJKpWBSme9JxsDdaw
	 V0dbE/uGxqH3/S0wBEoxxPbZ0B2UmuqECjGzQDAu1v3bON1zqqm620nPTnzvUJdFs+
	 Of5brxqy7L/afeq3PfYPi+apdJYg++v6cjNoxjdvstDhJp7WM0AUweiwEXIQhxYuH8
	 43h9QzoQUBw0aYisHyXYYPyh8zDBRKigXj4AzQM9r4xH396hHJH7F+YiC6LKeX3nIc
	 kGnJU8S/ELKsQ==
X-Pm-Submission-Id: 4jJkN811Fsz2Scj6
From: Nikolaos Karaolidis <nick@karaolidis.com>
Subject: [PATCH RFC 0/6] virtio-mem: support memmap_on_memory
Date: Tue, 03 Nov 2026 09:50:06 +0000
Message-Id: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQwNj3bLMopLMfN3c1FwQzk0s0E0zTk02N7YwMjc3SlEC6isoSk3LrAC
 bGa0U5OasFAsRLC5NykpNLgGZplRbCwC08b65egAAAA==
X-Change-ID: 20261103-virtio-mem-memmap-f3ec7382772d
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
 Hui Zhu <teawater@gmail.com>, 
 Georgi Djakov <georgi.djakov@oss.qualcomm.com>, 
 virtualization@lists.linux.dev, linux-mm@kvack.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Nikolaos Karaolidis <nick@karaolidis.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3925; i=nick@karaolidis.com;
 h=from:subject:message-id; bh=NNPpcglNLpTNsJShxSz++7ZYM10avVud+ofnAjWB9aY=;
 b=owJ4nAFtApL9kA0DAAoB2mjImL9M9YgByyZiAGrprndObZ4nJcHkyOGnR8X98GzRHnZPY00og
 5ZdyhePWdMUsIkCMwQAAQoAHRYhBLMZG7EWqsMYjymWX9poyJi/TPWIBQJq6a53AAoJENpoyJi/
 TPWIl/cQAOEJLHdPO99uWz96izDeMCElaiPsorxDa1dY2D7aoG+gVGFyjbiVLoPG9ccyV1X8GgC
 87APtvVTOGWAICVzNMI0UPWriIepArKYeYAc4lBS+3NAYLHRT4/MLnOtyM3+L8309oIOtWqqGar
 STGxvYP4Mu/EjXRXgFqg6x88Yps/JzPTJX6kKzl7djrtOi/e29OebonxeqcTSnaDQVgKERsH4+e
 idJTNqaGL+oCQMJFGD6xzdqeNOoMJF0SnhSS6okBcXzUOhJq0LUUYMIW5Y2XU26bZ9sgw2fTEPv
 ILJ9/LI0xqeNBobSe3mYGTqv87IWSHaHiM/Y3Ua7sKQ11xvuGB0B9gzRTEh+A/hoQa96hLsXuTo
 6satoUNqNKdss39D/7karpqARuukEM0TJowUmDXgcpDyRa0TbaTL2yuORmsZrSJWvdyaAPMYSyX
 7nozNOBTetb1iZoBDllZqEGy4SLiJzqbweJMPAR44VrLXUQsqgKPDuSjWZw5Bd0DWprJcMABQBJ
 PATSor2IAhktB3UF9AoNqLs3PO9hWpzb7/8Fmkkp1oIMHpdtcVal1e3uR7VduKLW9QmJFZUB/Qe
 zz++rHq/JxPYPxJb9tDy9nR8zT9oQg6P7r/CyBFWdyUCitOiOeSrPA5kJ/mxLafm00ve7nFBY92
 vwP46+z4AtqoCW2pzw+clRg==
X-Developer-Key: i=nick@karaolidis.com; a=openpgp;
 fpr=B3191BB116AAC3188F29965FDA68C898BF4CF588
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AE32C1A000B
X-Stat-Signature: c37r3j3mr57f3hi8usyyh1h4am3t9jh8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793699460-838719
X-HE-Meta: U2FsdGVkX183L9K4SxVVSp+IMLx68ZEeiSTgrjEwDcCq6EVgsDbFQHFPU82UHem4ieO9j0SGTxoflkoWeIFH3/Lqp4PB8c3cR/Y0TlOvx63mdDG4M4QrT0nCUyaUgPCvWIMfAPz8MDoO+y8pClzEjQzHKyOOVDJlpZNM8ZKx+Ue5Wo2FRBryebtUVAnHUuBpPzWxKUvHd0rhOrG6gfczDM6vdOfkk3zndfnDAr/+OTvYd7zKGjb21D4OUjjE36QyCLJW6wdIhv0UHLILkoh4rk2klTWkNV9oXi767FGgtN6wmFz+mS5OpKji7xSLcZkYvgqMgXu21dXN3E6a8Mgd2wxV0RlEQPmiYUhdixRvTPJjfiMcf2IK1B3IZeQZlayUNJFpYUJd6MoseRO+0GypEdeJI9rUsHC12bc6M9ad5DUb5YlYiogrqx2V2YS4ekI3+c6oBhJevfVZYGV9oAWtL4prnPhdj2SbDplKsJ6vIkcim+sMorBHa7dmYuIwkRCPflPf1BujVjr5v6CAt6kNfUPdH0bL8ZaYGt4S+YIEyM8Gejhzg2Gwr/IDM22VGSXN4m/pGHJKFLvuO4wCwFnn7rwVONrt9QxM4XeT7ZY0vGDCRTtHqx2bvD3ZDNmdZBn3RnJZ2QGYrLQFPASitbYsLOYNlGTffkl6XYGESb3mshpq9JBg+CknWcxZRxyzBBoWpTo38Racyfe5FiUnRItvRSRR1ckj4j19XY/Q2aeJXV26DaOBa74Yo6Crkmd+wdlNEqrcX9xuGlsWPTQH+qUpZqzrcNLk1dcDLocSSULH/nTs5cXStp/uGhuH4EbZkbf0Rya0K9lGPs6xCD0NUhq4L0fSnsn8SeCrqt7WK9+ZmjMGMW2vTC4vl8lOvKayjG3xGuyolmCj4fKXFN++PETx+kAbrSBewDA2MvR1+K3bv9UnMZqt3I6zztvjOIM7Rb75jporyLURGGkvuGAauNE
 03Dv6fhB
 wUoRNZntUs9biJKfssy21LT0jf16+uZVmZx9kloG02ynChOufKh5AQRrE/zYmg0pFcj/YIzAHpDwD/BxJt6nTz3sjNbLqwU6Z37OTwXI8G5iqgzSJ/JkK8ngdd08C5KhGgEaFv1AJdkpc+OcAV/K9Dzu/pUFbhvM6t0WnNnooBVP9N6NN14FO8TN3ze0ayVBbKu6XDq+Zv9hbL6rSZY0e/7R2AkrFq2U1FaOmqdCm6FwRnebPOOe96TKlASkcoJkFWToWH6RXDM+olSXPUGzKSdDzkg12+KoOA/IjLW0txHvU0lGohrvSDxtR8QBUiraVY6lBnenSECrOaE6qy2TpvUgNYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

virtio-mem adds memory without MHP_MEMMAP_ON_MEMORY. With the memory
onlined to ZONE_MOVABLE, a VM that grows to many times its boot size
can run short of unmovable memory. I ran into this while working on
a guest-initiated memory negotiation project.

David wrote last year that memmap_on_memory support for virtio-mem had
not been worth the effort, because virtio-mem adds memory in small
blocks [1]. Each block is small, yes, but the memmap adds up when
scaling to many blocks.

This picks up Hui Zhu's RFC from 2021 [2] and follows David's review of
it [3][4]:

1. Big Block Mode first (patch 3). Since commit 6b8f0798b85a
   ("mm/memory_hotplug: split memmap_on_memory requests across
   memblocks"), the core uses one altmap per memory block, so this also
   works for big blocks spanning several memory blocks.

2. alloc_contig_range() with pageblock granularity, so subblocks can be
   2 MiB: done since v5.19 (Zi Yan's series, 448b8ec3bf11).

3. Sub Block Mode only if the memmap spans complete subblocks (patch 5).
   With larger device blocks, the driver warns and continues without
   memmap_on_memory, as David suggested in 2023 [5].

The other review points on [2]:

- Plugging more than requested: if no more than the memmap subblocks
  remain to be plugged, the driver stops short of the requested size, so
  this doesn't happen.
- Error handling: if unplugging the memmap subblocks of a removed memory
  block fails, the block is left in VIRTIO_MEM_SBM_MB_PLUGGED and
  virtio_mem_cleanup_pending_mb() retries.

Georgi, Cc'ing you as you mentioned out-of-tree virtio-mem patches that
use memmap_on_memory [6].

Tested in QEMU/KVM (x86-64 guests) on v7.3: 128 MiB, 1 GiB
and 2 GiB memory blocks; device block sizes 2 MiB to 1 GiB;
ZONE_MOVABLE, kernel zones and offline blocks; force_bbm;
memory_hotplug.memmap_on_memory=force on a kernel without THP;
grow/fill/unplug cycles with memory held during unplug; 600
offline/online cycles from user space; random resizing under a memory
hog; injected failures when unplugging memmap subblocks; the
memory-hotplug selftest; virtio-mem as a module, reloaded. Also with
KASAN, lockdep, and DEBUG_VM. Built for x86-64, and the changed files
for arm64, riscv, and s390.

An LLM was used to review the series against the core, write the test
harness, and draft the cover letter and changelogs. I have reviewed all
of it.

[1] https://lore.kernel.org/all/1efcb368-fcdf-4bdd-8b94-a705b7806bc2@redhat.com/
[2] https://lore.kernel.org/all/20210623115839.3524-1-teawater@gmail.com/
[3] https://lore.kernel.org/all/CADFyXm7Ky+S2gq5ht2h_tX9bLsoOSuctCkG==VYAH0uUHGp+QQ@mail.gmail.com/
[4] https://lore.kernel.org/all/bc36b6fe-0d1a-6fe2-e8f3-49bbcaebcf41@redhat.com/
[5] https://lore.kernel.org/all/1bf30145-22a5-cc46-e583-25053460b105@redhat.com/
[6] https://lore.kernel.org/all/fb932d7f-0ba7-415d-ab36-e948d2bbb537@oss.qualcomm.com/

Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
---
Nikolaos Karaolidis (6):
      mm/memory_hotplug: add and export mhp_memmap_on_memory_nr_pages()
      virtio-mem: prepare memory notifier for a self-hosted memmap
      virtio-mem: support memmap_on_memory in Big Block Mode
      virtio-mem: move virtio_mem_sbm_try_remove_unplugged_mb()
      virtio-mem: support memmap_on_memory in Sub Block Mode
      Documentation/admin-guide/mm: document virtio-mem memmap_on_memory

 Documentation/admin-guide/mm/memory-hotplug.rst |  18 ++
 drivers/virtio/virtio_mem.c                     | 268 +++++++++++++++++-------
 include/linux/memory_hotplug.h                  |   6 +
 mm/memory_hotplug.c                             |  15 ++
 4 files changed, 236 insertions(+), 71 deletions(-)
---
base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
change-id: 20261103-virtio-mem-memmap-f3ec7382772d

Best regards,
--  
Nikolaos Karaolidis <nick@karaolidis.com>


