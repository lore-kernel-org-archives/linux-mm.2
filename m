Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488071075273
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727076B042D; Thu, 19 Mar 2026 04:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9D66B042E; Thu, 19 Mar 2026 04:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637206B042F; Thu, 19 Mar 2026 04:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53A606B042D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:20:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E475213ACC8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:20:11 +0000 (UTC)
X-FDA: 84562115022.03.A41C20D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2599514000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:20:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nW9ab7On;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773908410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9vONOIrqW/UJkG8W01y5FtYV4fnBAGfruHFEOeSnnYw=;
	b=OFxcFkjYHS9UH6o/d86pggowitRLYWZi88xQqf9GC3RBWIkh1IhdGKChLdL5xhBp4O04N4
	3/93CRoR/ew3AES+KTSpc0wlLOVLjVDOwrT0oryUX1PrLB65oPLYNiJ3Xkg3ucKu31CCRb
	w0Air2wBUs73FTGcxiWkSablXSlrRVQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nW9ab7On;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773908410; a=rsa-sha256;
	cv=none;
	b=07E/jtzaO6B5Zg/Ae97g9g6Jxs8ujc9Z+Bpqzk77CnMB46xJotQydCFcgRJkUdXbZaAS3P
	9kAumIidlQqGaKdgNARCMfVDTttSLNlKMErWiC5AePRr5BRfaBD0g2emR0w9M/Y19bgCqb
	pPVagq0bAEtpeGSoF505I/PBjD7ReeQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E02D43D39;
	Thu, 19 Mar 2026 08:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3B1C19424;
	Thu, 19 Mar 2026 08:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773908409;
	bh=GAQ9b9edKTgGxU+mpQzf5vrvp0GbZiNpB68nUzbzDyY=;
	h=From:Subject:Date:To:Cc:From;
	b=nW9ab7OnkN7S00RxQQ6fV539CUU/HXaHfFwpCsfjk1vZa9nrCehAKXmvHkrdByEwi
	 UTuF8w219c0gp/9PlGkyTjPCXYgHMu+wuB+VcuJDOAEMR4YYArxHQyQe1bdwRE69iq
	 6KnzMuHTxJ83BywVs82C5DCGxHXYPZw/XiMZC3jCTCs7Ed7M20epXUlpSA58uZXblU
	 VhVWCftNRHTP6Wysxkep+z8UHXRrW+AIwQJO/Iq01wPPGebHyKnPiUVOyGVPTWywxV
	 gA0MkkSVRuNWrkUsu2BUt2gfc0ropCqtacyuIkXHK1ZCQaGyBOonZgNXG1/Y1ey4xt
	 IYgm8NZf2LthQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE and
 cleanup CONFIG_MIGRATION
Date: Thu, 19 Mar 2026 09:19:39 +0100
Message-Id: <20260319-config_migration-v1-0-42270124966f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJuxu2kC/x2MQQqAIBAAvxJ7TlhNjPpKRISttocsNCIQ/550H
 JiZDIkiU4KxyRDp4cRnqCDbBuy+Bk+Ct8qgUBnsZC/sGRz75WAf17vKQpuOFGpEPQxQsyuS4/d
 fTnMpH8Y9x3JiAAAA
To: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, linux-mm@kvack.org, 
 linux-rt-devel@lists.linux.dev, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 2599514000A
X-Stat-Signature: 8an3ae7b7zbnaqy17trdxat1xb9nyzzh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773908409-588355
X-HE-Meta: U2FsdGVkX18qqcD0AIsrW8S9bs85H2ikx3jflrrbcwMRY3JSJtuLvQ9cLHAaJBvqeX52gDPaXyH57nu5IGbPQQMsCSOboTYFdwVkrfLt2UGv/3TNloX2QEkwfaUh+Nwh5FIMwhYlUVgu6hBhds4wnJGF7KeQ6AWW0Emz8w3TfrpDbdEsKbkvc2Cb7h6GAZ4E3lLPgDzcqsmJoebZ+bIythDWBasWOMk28JEbUXd6O9cLJpkeoZpgFh6AXk9Rc9e5Mh0T2okvSZsca+HO0zDxnUezp8D1NApSpPHlZp9qaYyn1eyXUUOHKPo6kT0X6ErchjIKQWjJpaIil5Ab6upHh2dd+R246xz7jrmBllAoIy0NQgn7jnyhne195KNl0+iVgUDormytX23QVUTOxBKgL8PXNzy1VEhlUB3dq06cerrF0JOKkfZlw/L31W8vTF6CRg3XDloIDXsrt68XCjJf6vj5teiRwhmuCIzOBvEHkCDHrkwyZm59DH2OJvS7+XbUn9afLpwiWPTZF7ll4vpQmJojmPpN117uiV36n2alnz9fihCbtyhs3nFFrl0YKF66sgRqPQaTgIPeUcSk1k1rgWTBLudgHAZct/6pjkZ3oIKH8WybnSeqCARun2dtt7/rCqqb7AoLkKwoY2A3rR47h/dVi0tgyieYO3BPmG+CCrk09Dz5f2sAZAhc8US5V9QFRagsHlEubKekcN0eBHlWe4tByWH5RwBhD5T49j4oEieyQ6DvSQkLTgi97MfjtGFGR0T6GtPj5kNzE0O868laNczX3giNscBq97Qj6pb24pc7vDwaG25c8Rn+zm3a15CwAneFsLSVcxenQv4vH49faOzQ9JwcqTuXLcOFdPewVtUl8oDp+1FpB32SaaE0Vud95Gy2fjW1zvFIhgVyXqjzO14lHEQsJWqGncI/Sah+zk8k31Glzbg1ktnjeoUXduphejSGCVWUWGhLq4iF1h6
 LkVoa7Y8
 ziKHiPPizJsStJfdWoXH1jckkZh5DIcfA+sbTqwYDCwZmu7YvdAeK5eQcqAVUwjSykdQRr1SwwDhz6YT9KNXUJHTh4mETNLsZehhd96qIa0pibnjfe2D0yvYakECmuaDZMUwZ0jPQvoLcBfVkXn/Wrcp8NUexVxFNeZc/3EdwXDSR8q7mBxFeeEcLkAHtwz0O88lsx57faA9AlG3aocjGFahxt0LMnWyPxjEFsjxuaZAEXp6i4KjU6dOremjCk52RA/x/Vxs/CV0Z4ixVBbIFnnu6nzJY8ZzAyIAyxDDinYE95mtVH8RNAU6fjw08XQo9hZ83alm/DZOZY5Jvxq7t1Ybt5qiLdPxtlrFBNxweAuYRLqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While working on memory hotplug code cleanups, I realized that
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE is not really required anymore.

Changing that revealed some rather nasty looking CONFIG_MIGRATION
handling.

Let's clean that up by introducing a dedicated CONFIG_NUMA_MIGRATION
option and reducing the dependencies that CONFIG_MIGRATION has.

Heavily cross compiled. I assume these changes are fine, but messing
with kconfig sometimes feels like playing with fire :)

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (2):
      mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
      mm: introduce CONFIG_NUMA_MIGRATION and simplify CONFIG_MIGRATION

 arch/arm64/Kconfig           |  1 -
 arch/loongarch/Kconfig       |  1 -
 arch/powerpc/Kconfig         |  1 -
 arch/riscv/Kconfig           |  1 -
 arch/s390/Kconfig            |  1 -
 arch/x86/Kconfig             |  1 -
 include/linux/memory-tiers.h |  2 +-
 init/Kconfig                 |  2 +-
 mm/Kconfig                   | 33 +++++++++++++++------------------
 mm/memory-tiers.c            | 12 ++++++------
 mm/mempolicy.c               |  2 +-
 mm/migrate.c                 |  5 ++---
 12 files changed, 26 insertions(+), 36 deletions(-)
---
base-commit: fbf55982f31ae6aa11f890c36bccc130ce70a312
change-id: 20260317-config_migration-463e20400499

Best regards,
-- 
David Hildenbrand (Arm) <david@kernel.org>


