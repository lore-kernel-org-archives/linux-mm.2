Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 632C8CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13E86B008C; Wed, 29 Apr 2026 09:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4FE6B0092; Wed, 29 Apr 2026 09:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9D36B0093; Wed, 29 Apr 2026 09:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7967B6B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:39:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A03F1B8409
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:47 +0000 (UTC)
X-FDA: 84711701214.06.2F6AE26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A6B9080007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MJs6lfTE;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777469985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1cj3p388M/S8fstPOqvIwS2hzSzyo5GApF9WxbiPSy4=;
	b=wPZq/5s0dx5NbGwKjTaQsjgORyL77Pht6tZZRp2Q6QzY4owoEgEXwUHxHWr30LKzhJsfNm
	RwiUuQ0VHd+kzfyIZ0zq37R0DOiW6tyVTMe3qFDvw1Z6pkxEHF8v/8YyOQUVnDEoTWa+eT
	ZMYmnnUTlnOiJ2Cb/R4hdqOVYopjFbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777469985; a=rsa-sha256;
	cv=none;
	b=703kI4d2lVUTqQFLz7oqINrpuKtYbgOTF14PQ5cfElq+PjrCwfjWv1quBcnwPc6ITBTRtw
	9q3AoQKG/tp0Dc8D2iSffYwX5gBRWMqcgRdQyTQaaE9aStO5WNXhdT7fbuQYLyEC3dv2In
	xb+epWkCwj20NZFBotsJIfme5Jy+ZN0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MJs6lfTE;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF6C460142;
	Wed, 29 Apr 2026 13:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2195C19425;
	Wed, 29 Apr 2026 13:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777469984;
	bh=w869zNKzhithGNRmRqp8WYig74dnCUUN98eSnQq4g4Q=;
	h=From:To:Cc:Subject:Date:From;
	b=MJs6lfTE7V3kbascG1+hudy/89zmczFa5PxlZb5UB9FFDeycEMZORLHAl0r9HeTbG
	 xqc3Gi0YqX51ek5zsuVTKbNZU/INQwG7AjqhtYWOg7E9FRvYtQM0Da8ZNgcTV67nCR
	 kcuSTAj4LjOQ49eRp1hus4XCBUTq5/X9mJX03PiQ4ttbMrRAehATP2YYWKXE5dPdru
	 VCsmOKouXvBl7J0S5gjrxRzqYFh+k778oF8861LTfFygHVLDtX/ZaJBwXUiKc69zK5
	 D0jKzuL4H3n57HWS3knDqaHryDPzba/sy0Ustoy6M9jDA/bDNZlPNRCSrHkTu8UFoU
	 lAoK9K3AxOKHw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] kho: make boot time huge page allocation work nicely with KHO
Date: Wed, 29 Apr 2026 15:39:02 +0200
Message-ID: <20260429133928.850721-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6B9080007
X-Rspam-User: 
X-Stat-Signature: kn7outxu4mrbiu6uegydx63cg84uoyiz
X-HE-Tag: 1777469985-88954
X-HE-Meta: U2FsdGVkX19RkfOTs5vaNtatYFsDiXU4tDBYtgX9FiVPzeRPWN9zuRnQdnFTRV0qSm+7vYNxcWqgmQ0UqdLyfqn7MR8oEhyLOWEVEjj4PYWzwVg22kfNTFurYlA9a5cDWDWhOyOBwchera7fQHeuriUWWIdKxR4YAgWN3ezz1TNf8I6SdtNy4w++Kirbr2jYSvUA6BekmgPjOgoYv+U618gyLPCkKmAB+KG33UjLhfrlpMgY4CAJMRwdsYDh/ncjeeOs5AQ/XMvHqPRchcJQAB89BcMAl8NZtAsVnrmsGdwR6kuLTYgMvqXKO2q6XG/C07URx4i2w8UC6eQnryxqUxm/2M1E7il4Yo9KLfXuw5oJtytDaCwD3SuHjNAHf7O63wUuNhOBeEb52iG7712+2joZiO36LuPCv7AToyrqQV8Asy/PAv0/WMvScrKP8hzn689UPkEEjjwEgcM5SbDhUwaLAtURl2fPH4T/n5N/CE5BLOiNsUfyM0jkMU2PizPBYoAXsti0fHbFYgVyNI9EAPnUEA8hYBTlv/TxGPIDDXakZ6/DPp0svN/kCqqFUF4HnmDB15vYGjm99QlbwxAHn+A02MlwHdmNRkvm0lZ8JxMp6cY+WKzTZtldILN5rnPL9zhUZJkcqAJek9LXC8v3WRAo09qAhHJUBa4mCJzVD4+nWnAz2hvYOC+M8oNpHvsbwNkFVhpRLRhEAL+6D2bO6regezFXZLuT5WHYE/OYn4VDX4bcnlItlxmIPXeEFR5qD9Roy9kClZxEwhYwZdgxrqgBkWX4h/K9u8Zfl9fbKymBokJ58oM0Q73tGS0UdrSOkeMrthVwTUxao7q8lYi51ZxTXeEqwOndJTw0/G9lp/OSDvcIDRv1yEOH2pxDq12TBCW11u7VU1fsy70yT82X9nmaZCdy/Havuc/IXq3ZFKJ9lAlM+/SLq98wQydTuExdFXOr9hNp2fJiAVhntOv
 hT09Zvs3
 BMcKaVRYoBI3cU+oEXEooP5W8cgy35OgVS+uudgFEmk0UO2jQq53Cv68BV6yVlyAuYTzSR1gwM1R7ul9v+oQtDI9HIgkNDrKuoni5OnidU0sihnUd+SKlqi0AvYRcoYMFHVXqe1WjvMxFFiyTdzByg75lwso4thut25eQTlWyd/5LhSGBRQo8fJVSvEpuVtwvnXVensJ2tldzI80w0aG9oyFU3rDJ0wZJ1TLwYjooOo7VjVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

Gigantic huge page allocation is somewhat broken currently with KHO.

First, they break scratch size accounting. Since they are allocated
using the memblock alloc APIs, they count towards RSRV_KERN, and this
scratch size when using scratch_scale. This means if huge pages take a
large enough chunk of system memory scratch size will blow up and fail
to allocate.

Second, scratch can not contain preserved memory, and if hugepages are
allocated from scratch, they will fail to be preserved with the upcoming
hugetlb preservation series [0].

Fix this by introducing the concept of extended scratch areas. They are
areas that the kernel discovers on boot by walking the radix tree and
finding free memory ranges. See patch 10 for more details.

Discovering the scratch areas needs some changes to the radix tree APIs
and to memblock. Patches 1-8 do that.

Patch 9 introduces extended scratch to memblock.

Patch 10 adds the extended scratch discovery logic.

Patch 11 cleans up the preserved memory map API.

Finally, patch 12 puts all the pieces together and uses only extended
scratch for hugepage allocation and does not count then towards
RSRV_KERN.

[0] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@kernel.org/T/#u

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (12):
  kho: generalize radix tree APIs
  kho: store incoming radix tree in kho_in
  kho: add a struct for radix callbacks
  kho: add callback for table pages
  kho: add data argument to radix walk callback
  kho: allow early-boot usage of the KHO radix tree
  kho: allow destroying KHO radix tree
  kho: add kho_radix_init_tree()
  memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
  kho: extended scratch
  kho: return virtual address of mem_map
  mm/hugetlb: make bootmem allocation work with KHO

 include/linux/kexec_handover.h     |   1 +
 include/linux/kho_radix_tree.h     |  44 ++--
 include/linux/memblock.h           |  14 ++
 kernel/liveupdate/kexec_handover.c | 389 ++++++++++++++++++++++-------
 mm/hugetlb.c                       |  19 +-
 mm/memblock.c                      | 177 ++++++++++---
 mm/mm_init.c                       |   1 +
 7 files changed, 489 insertions(+), 156 deletions(-)


base-commit: eee13213401bafb7ffe3b447adffb1f570b9d813
-- 
2.54.0.545.g6539524ca2-goog


