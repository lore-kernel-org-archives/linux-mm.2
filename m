Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEBAC5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 11:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D199B6B0095; Sun, 23 Aug 2026 07:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF08B6B009B; Sun, 23 Aug 2026 07:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0316B009D; Sun, 23 Aug 2026 07:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9575D6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:46:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECB9F14029F
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:46:30 +0000 (UTC)
X-FDA: 85132356540.19.290F842
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 511FE100005
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:46:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxsWQ55V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787485589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Lrb3AaG5i4+pyOfjbgQo+jz5A6PG6nAPFo2gdyz4uew=;
	b=ZAOtQTBotPiy6AfHUyg7lXS+fSyBBXaR10z3ub5oLefJZ+DtGimwJjxfhoU3Yb2nepdZiZ
	8FAUUf5AMz7E5HAHAF5sXKM0C30jTRj5lALOnA7g4lmjvlMRiK0Q1r8wTS9B56lH02Af2w
	TPcf1U1cqBPb6Uv4zsGAh3ShM8Kf/Kk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxsWQ55V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787485589;
	b=yEvUDnmdyJYqx0M+uy7j0vBmEoYxxDSO59svDVuS/69s7a75XoKn0CvWhDdA3AHpnqoXOT
	Q+j/mN6k1cOdIB8FydR9J+LiYyEiahngifJy+6DqtmBsiJ3Q1QSGA/Y5HqdrBQuXmKno+2
	4fsciOTg2pgBSNsgJ2S+18RgrvDw1vE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C8AE60052;
	Sun, 23 Aug 2026 11:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD03A1F000E9;
	Sun, 23 Aug 2026 11:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787485588;
	bh=Lrb3AaG5i4+pyOfjbgQo+jz5A6PG6nAPFo2gdyz4uew=;
	h=From:Subject:Date:To:Cc;
	b=KxsWQ55VlofiuDkDqLgek/1eVhKQq7dlOrawBrJveRKSZ1yGnkgnqiGKv46o2hZM0
	 1f20ZKFiMj+1fxQNOTXgRAyLxU2lfST+kmfN/+1qWuc+RAy6F0PaDSCzoCbeQS5vHo
	 LSPO3vI0V7PtU3PthwkC+vp2ll5Q1rwMpxKdF+mluTuDJZ1prHz/55dPjwK5+lHlts
	 RBZlLhx4emUfToOGA/bT35i9FhDMh5qEWu7LHj8Q7lPVdPY4MUGzRJqPcWoki4Vf+b
	 3igd+UgVgyQ0xUwwiiKuXFOAflN/AhFVsnUUeSYuG8OoCfanjQms6d3jJWtydQaeV+
	 kI8IOB9eqYv8A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/6] arch, mm/execmem: resolve confusion about
 set_direct_map_valid_noflush()
Date: Sun, 23 Aug 2026 14:46:11 +0300
Message-Id: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42OQQ7CIBBFr2JYO0orqdWV9zAuAIcWdWjDUKIxv
 btFL+Dy/fz/8t+CMXpkcVy9RcTs2Q9hgXq9ErbXoUPw14VFLetGtlUD+ERLSMCYIBOMGIkhS6j
 BaGzVXivXKCeW/RjR+efXfb78mCdzQ5uKsDSMZgQTdbB9iYiGRFsimAInbR5YOr3nNMTX92Cui
 uufL7kCCQd5UErv9FXt3OmOMeBjM8ROXOZ5/gChQWkL+QAAAA==
X-Change-ID: 20260816-execmem-set-vm-perms-v0-2-bae847a4f64f
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 511FE100005
X-Stat-Signature: ue6k7wofum4aaqgmzf5iy4mekefcjrww
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787485589-42859
X-HE-Meta: U2FsdGVkX1+i3wfoYwzboOavZ8yUZaRKJJgEwXm0+xrxUbzeGeht497P0aoJEevUDOzHgMCRL0mAF+3ElnPT0OiU2enX/yG8HEDxP9qlHygFZkXHRsl/62/TIh2bu4+/cPmjlgcKkcLftJvFNkDvNC8X9Lkkmv+w/mgpYdRaRx3dzL6vPCpjlV2Ink9Y04ABbD0NIMkbV50P4oMkJ1rCR/132In3bEQ401JZXDslxET738gg0DCrTc1i33+kH5E5ITP6d/jU7SZ2MK82K+0Oz8MV24YHNcElh3lyr7BkCNEIBeztJCVuNZII274ifE+NfWz1LC7NE68wnuVs18OGLcTysPTP947AbSFPxr7BjK1EW7e72ZQ23Mzi8wdaa8R5DHaQYbY4/lzRT/9u5+03qMSGZjlDX8/yM3wQYmGIrk3BO6Y2FZiuopZiMQO4KR50ncnCoR8WKnv2EZPxwks1ookhonlqYnBhA6tYLNBAP1e9NTm7v8RBbA67lw/VfU4hOO3pRCUmdGUiKyv6n4xwLXQSMk8sTqYScMwCY0bEJn7LFNBfF9N/NsP5qkgSOndzqdwY4kA0DBWY8p4wBRr34bk25xnsNSzHREC33O4HeTYSXrxSqSDcMzd1+mq/6YR2e+HnsSXjDZRAEVsmfBCzyoxcHvzuXt0TTaGa7l09IVhqAXSVqf5laAWAqEtySs9BQ7th9ucZAf4FWa5fx70nTJ+M9tNWCBd2bPBUe7ZafBcOLFLe5rlI9OhetYkz46mxsSESHJ9aF8ORsIJufRBdgaDK2rbPd9OOqGJcPIVS8MbW6WzbZsr0ldmnurQ5QsoEx02lOSzIGMBy6pdSGDF1X5yJenIbwjbv+bwrKwOT6N9vEH1UA+B6heYMSBsMS8lh/pTwdHQVo9GGbR/dq5vw0GtAHy2NOiOVrsIjMhYLD430zKDOnx43BLkUDDRUV+h/833pmGLua6a0Ffi/evE
 S1EVekEd
 BpEexq62ojlfc5e7e6KJT9YXt/CoXTb3cRMuWdbEdNSf/5rsMLIZbyD9re3htKXoB7POG6qQMv2rT6IpzrTmTBy0iC2DMRZHDXJ3045lpr58kigu4Jp3DpQRfjLYFtL/oKxsbAQ3f2FlLq39gMjW9vkQXqP96i8poyndbFM/h+pb9LtmqKz5183g2FrrXgcXWrByBCZkdS27HGGUBDx7f8+o3rDKCWZtbl1sZQz2KXIlESV/uVWhmSz31UqSordAceGeLfOFjdOSn5xfpVT3/EOzqalmPOpQEac1MWh8Q1DCe2l4Q/SaCqlzBNWjCFaewxiWN/X4lqED/vDZ38d14D0JalR18UXeIClOC+6Qfp752OE/SxZSohy0uPA87tj9jtu/KFQ9LHqVijuCXUTO6yU6A/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recent discussion about implementation of execmem's ROX caches on arm64
revealed a confusion about how set_direct_map_valid_noflush()
implemented on different architectures.

On arm64 it sets or clears the PTE_VALID bit marking a PTE as present or
not present.

On other architectures it's a range version of
set_direct_map_invalid_noflush() and set_direct_map_default_noflush()

Unlike arm64::set_direct_map_valid_noflush(),
set_direct_map_default_noflush() not only marks PTE as present, but also
sets its default protection mode.

Other than that, initial design of execmem ROX caches didn't rely on
restoration of large mappings that's now available on x86, but
completely removed the memory allocated for the ROX cache from the
direct map to ensure that large mappings are not split. This precluded
usage of VM_FLUSH_RESET_PERMS for the ROX cache allocations and required
execmem to implement manipulation of the direct map alias.

Current implementation of ROX caches does not remove the direct map
alias but simply calls set_memory_rox() that updates the permissions in
both vmalloc address space and the direct map and relies on
collapse_large_pages() in x86 CPA to keep large mappings.

This allow using VM_FLUSH_RESET_PERMS for execmem ROX cache allocations
with small adjustments to set_direct_map APIs and vmalloc::reset_perms()
behaviour: adding number of pages parameter to set_direct_map APIs and
making resetting of the direct map permissions in vmalloc VMAP_HUGE
friendly.

Implement these adjustments, make execmem always use
VM_FLUSH_RESET_PERMS and revert set_direct_map_valid_noflush() changes.

[1] https://lore.kernel.org/all/20260611130144.1385343-4-abarnas@google.com

---
v2 changes:
* move setting of VM area order back to __vmalloc_area_node()
* add tags, thanks!

v1: https://patch.msgid.link/20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org

---
Mike Rapoport (Microsoft) (6):
      set_memory: add number of pages parameter to set_direct_map APIs
      mm/vmalloc: set area's page_order after allocation succeeds
      mm/vmalloc: constify vm parameter of get_vm_area_page_order()
      mm/vmalloc: make set_area_direct_map HUGE_VMAP friendly
      mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache allocations
      Revert "arch: introduce set_direct_map_valid_noflush()"

 arch/arm64/include/asm/set_memory.h     |  5 ++--
 arch/arm64/mm/pageattr.c                | 24 ++++---------------
 arch/loongarch/include/asm/set_memory.h |  5 ++--
 arch/loongarch/mm/pageattr.c            | 27 ++++-----------------
 arch/riscv/include/asm/set_memory.h     |  5 ++--
 arch/riscv/mm/pageattr.c                | 23 ++++--------------
 arch/s390/include/asm/set_memory.h      |  5 ++--
 arch/s390/mm/pageattr.c                 | 20 ++++------------
 arch/x86/include/asm/set_memory.h       |  5 ++--
 arch/x86/mm/pat/set_memory.c            | 16 ++++---------
 include/linux/set_memory.h              | 12 ++++------
 kernel/power/snapshot.c                 |  4 ++--
 mm/execmem.c                            | 42 ++++++---------------------------
 mm/secretmem.c                          |  6 ++---
 mm/vmalloc.c                            | 26 ++++++++++----------
 mm/vmalloc.h                            |  2 +-
 16 files changed, 61 insertions(+), 166 deletions(-)
---
base-commit: 1029098ee3275ea5b78e329ce132262affa2f8cc
change-id: 20260816-execmem-set-vm-perms-v0-2-bae847a4f64f

--
Sincerely yours,
Mike.


