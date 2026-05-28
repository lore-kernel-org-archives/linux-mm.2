Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31AECD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5796B0005; Wed, 27 May 2026 20:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACCB96B0088; Wed, 27 May 2026 20:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB636B008A; Wed, 27 May 2026 20:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B78B6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2582C4068D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:22 +0000 (UTC)
X-FDA: 84814977324.27.98AC400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7B54020007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=N2vAOfpA;
	spf=pass (imf13.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MlAphM6lIy04CUio1znmzudM4J3s/1bUFzd6ZYAVWN0=;
	b=T/HHEMWhwdrtw8Uil8OTv4bki+4KtKrM79s/Dmh/0HUyYmHc861MhOfMkqRCQiFsveK0zL
	maZiuj6O5wn7ef5/Yv+Y5QUneypXYSiqgsIhQohHlyl1eIMsQjChpzY7Wgym2KjMxtG0Ie
	z734zgKdDG3YsU09LOJ92TqrYf39KO0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=N2vAOfpA;
	spf=pass (imf13.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928940; a=rsa-sha256;
	cv=none;
	b=bZxWj4376uDUPfKA9kXjcZ4DJe0Exa6QFqvqyduapVd770MOfv/tlJYVHy77fWMmVz8dAB
	xd90fFC4ZpfpV/AuHubgYimlmg6pjLt5yImNd4H7Kt8Kkg/Q0G+2eGslilGtsDpIw5MFto
	YCoLbxfxMx0OBPHv9vQwsfgREAlGB3g=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 3F42520B7167; Wed, 27 May 2026 17:42:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3F42520B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928928;
	bh=MlAphM6lIy04CUio1znmzudM4J3s/1bUFzd6ZYAVWN0=;
	h=From:To:Cc:Subject:Date:From;
	b=N2vAOfpASzX1EDjGy6YAAwkPynJ5GW9q35MDxfssI1LB5uZxHV5aX1fQgJFCn0lWS
	 FWP9njR85BuseWjwEiHUzAbNOhvtyBpu0fBVx/Pp2EtF+fHeg23fnp6RWXL6icFZ37
	 geNEFabO21Jp613vSD92tPBkmeBr1lm1Vy/xYD/U=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 00/20] mshv: enable kexec with Hyper-V donated pages and partitions
Date: Wed, 27 May 2026 17:41:42 -0700
Message-ID: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B54020007
X-Stat-Signature: u4t4yy7xo91h5dtx1wnh7jmzgjkwa176
X-HE-Tag: 1779928940-953092
X-HE-Meta: U2FsdGVkX1+NK7V6K8PAdXx44FYUppW4u8o+nBc95imI2cFcdc+o/fWORAHKmeJx5kUi2ORgOjacTsQKKSUUUyf0j7QfeWbp72U55+PPsdjjP6XSByVmSFnkeJZJTge12uFeyEQgdSOnJr/bSBCn/Cg4BkWPwTk8R8ny6mmb+BqPI2TiXlR56ZAtvu6bYsxLYCJQXC+drwfpk5ylTVX53vT3u3mk4xqKx1jirew7EVRg2Q4HIIuoB4yY9uI3F3CCeSFxh6I3B7pmDhMefOWgPs0BjYM9VfOICfNxQ+DSc7m2Xp8VXN9tfi6AxSgNX71rfoDV5RkwqMnL6fKIy4vgZBPdwtpmk/5dTY9f83yy9/EWyLiYkb3yIBQpC+QdHkkE7ZPFPOahgjtO+FnTPqkYBZvQ77zvBNdA+Z5YP+B/VXZPOaqqmVSU08jKIghm0M6M8S3zZdI11CpfszoRHRJyh4zHbe0Wujt509srO6sreRxJ/ga4Ya9MZri0sesYACSzt8ZVDe79zLcl3glq3TjdZOw4AxHwBlqpwECGekvODlS6h6BsRU0ssqZRzG21kCReBEt0xq0HNB35NLbliEnFRgjY14mflXwyyS0yx2BwoFwTOrwONarRWrBisS9p6r6NXucI16T+sdHz1fmpStBOtkwguWTGQC0j8lFBRfRZXEPFSkj0GMo1xHz9oqvUxEb9fCkeq17eA9zfDxCUEndK2nVN/sTKUKm3MtGY12zb732rYCtRHHFkfvo1bYGHYSlSf9t59aaTNsD/hOZhutgUPGfud3aZi1K6qPskLEKcZ5Uc7OV3whgWpuf2Y9LLpuXMi6momNlg61NcuAv+edZGnqUDOoObAItyOBOf8chNb5dNqlTfzIh4dowulXsMzB4MzyDryefGqGoAPUGhbkkGAbYsK9wlWJDeZW6hOHeTKyAuUcrIEYCrfoOlYSye33AvXvOx+oxTnHIOuL/KkWr
 HggAF7h5
 nS2+s6HUXg4aI2EMnCnHN8kmAaZYIT0SZKAv/Nd6JlPD7p/JKGLTGKiz07/rdrB6rOTHaXg1o+9CIl1uZmn/V6hjEDDsaGyPe6mjUjSVBYD31m/2FKUXKn3DnHk3Xav0odaB+6oQCEQWVF5snIUxqkM/JUKxbhQiGNQbsiDSD4d5LGzPM6rtCe1hRg2GSceKfOIT9uY95tD+GSrQMviYRVdNYvIxsujXIKtq951Ky3GEI+dtJ4538MBVBqlgdG5jfpEFnGC6lSlnxlszG0AsWaD/K9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When Linux runs as an L1 Virtual Host (L1VH) under Hyper-V, the MSHV
root partition driver deposits pages to the hypervisor and creates
partitions for guest VMs. Prior patches enabled kexec for L1VH, but
only when no partitions had been created and no memory had been donated.

This series lifts that limitation. It uses KHO (Kexec Handover) to:

 - Track all pages deposited to the hypervisor in a KHO radix tree
   and preserve them across kexec so the new kernel knows which pages
   are owned by the hypervisor.

 - Freeze running partitions before kexec, record their IDs in the
   KHO FDT, and vacuum (tear down + reclaim memory) stale partitions
   after kexec.

 - In case of a crash, exclude hypervisor-owned pages from crash
   dump collection by passing the radix tree root PA via Hyper-V
   crash MSR P2 to the crash kernel.

Dependency on Pratyush's KHO series
===================================

Patches 1-12 are cherry-picked from Pratyush Yadav's v1 series
"kho: make boot time huge page allocation work nicely with KHO" [1],
which is still under discussion. This series uses functionality from
those patches -- specifically the meta-data page enumeration via table
callbacks and the restructured radix tree API. It also extends the
KHO radix tree with:

 - A freeze mechanism to lock the tree before serializing for kexec
   (patch 13).

 - A crash-kernel-safe variant that memremaps radix nodes for use
   outside the direct map (patch 14).

Patch overview
==============

Patches 1-12:  KHO radix tree and memblock changes (from [1])
Patch 13:      Radix tree freeze and del_key() error reporting
Patch 14:      Crash-kernel-safe radix tree presence check
Patch 15:      Page tracker using KHO radix tree for deposited pages
Patch 16:      Debugfs interface for page tracker
Patches 17-18: Crash MSR reshuffling + crash dump page exclusion
Patch 19:      Export kexec_in_progress for modules
Patch 20:      Freeze and vacuum partitions across kexec

Feedback
========

This is an RFC. I am looking for feedback on the overall approach as
well as the KHO changes (patches 13-14).

[1] https://lore.kernel.org/linux-mm/20260429133928.850721-1-pratyush@kernel.org/

Based-on: linux-next/master (next-20260527)

Jork Loeser (8):
  kho: add radix tree freeze and del_key() error reporting
  kho: Add crash-kernel-safe radix tree presence check
  mshv: Use page tracker to manage MSHV-owned pages and preserve with
    KHO
  mshv: Add debugfs interface to page tracker
  hyperv: Reserve crash MSR P2 for page preservation root PA
  mshv: Exclude Hyper-V donated pages from crash dump collection
  kexec: export kexec_in_progress for modules
  mshv: freeze and vacuum partitions across kexec

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

 arch/arm64/hyperv/hv_core.c        |   6 +-
 arch/x86/hyperv/hv_init.c          |   4 +-
 drivers/hv/Kconfig                 |   3 +
 drivers/hv/Makefile                |   2 +-
 drivers/hv/hv_common.c             |   5 +-
 drivers/hv/hv_proc.c               |  32 +-
 drivers/hv/mshv_debugfs.c          |  99 +++++
 drivers/hv/mshv_page_preserve.c    | 557 ++++++++++++++++++++++++++
 drivers/hv/mshv_page_preserve.h    |  21 +
 drivers/hv/mshv_root.h             |   5 +
 drivers/hv/mshv_root_hv_call.c     |  12 +-
 drivers/hv/mshv_root_main.c        | 341 ++++++++++++++--
 include/linux/kexec_handover.h     |   1 +
 include/linux/kho_radix_tree.h     |  90 ++++-
 include/linux/memblock.h           |  14 +
 kernel/kexec_core.c                |   1 +
 kernel/liveupdate/kexec_handover.c | 605 +++++++++++++++++++++++------
 mm/hugetlb.c                       |  19 +-
 mm/memblock.c                      | 177 +++++++--
 mm/mm_init.c                       |   1 +
 20 files changed, 1767 insertions(+), 228 deletions(-)
 create mode 100644 drivers/hv/mshv_page_preserve.c
 create mode 100644 drivers/hv/mshv_page_preserve.h

--
2.43.0


