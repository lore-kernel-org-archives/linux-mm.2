Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21964D3B7E5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762C76B0005; Sat,  6 Dec 2025 18:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714966B0006; Sat,  6 Dec 2025 18:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602F16B0008; Sat,  6 Dec 2025 18:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4984E6B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:02:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1A95140698
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:02:56 +0000 (UTC)
X-FDA: 84190573152.25.8E2C581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 202841C0015
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:02:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RJBCBR/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o3VAh2os3b+UvZGIBlby5rPpcBqmxelHC3H161To+tI=;
	b=kaoGX7SNkviqOPwUb9uST+E+4dNlxs4CyLFSc7fVUw0//+DBwvPbqr/veh+iwtKQnwcWD8
	dNYWjqGLObsRnAINbF8DpMLLEYMbIMGF94cSVztOqyFWFGkvLO/1I1Ib3O9jh2JhdXvGZk
	qaw3J51Iy5zS7dDyu9gf/Q1OGggSlm0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RJBCBR/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062175; a=rsa-sha256;
	cv=none;
	b=GpyUzI567irhpcgvq2qUfiy08avftbz3BC5QAW1Nao5kv3znf6d1mVgianZZ1Lz3IRSmc1
	eltDdeQhZpzjYJy3J/3L9+IEUE43NEDYM6AEibeEcwJyl0FXt/wnmomqD62v6d8cezMjuY
	SF4i4vqid+3KYu1z2kQFvaQzOImw3SU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E000A41906;
	Sat,  6 Dec 2025 23:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9A8C4CEF5;
	Sat,  6 Dec 2025 23:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062173;
	bh=6DUm1o6LCjuGMMwws850Z+v4EVJVfUy729NCTOuuZtE=;
	h=From:To:Cc:Subject:Date:From;
	b=RJBCBR/km2500aF5vgAXFl6sUru0D8L/mlvyTxge58ga11iRXtwqV4rZElGW2RXqg
	 zI+NNmcWWWu3PXbyBtbL82tMygV7P2Y2s+a5eRNBX+S2Zpkz3zGQ8t2rCOXLtUPMPf
	 0TFY7poJ2yZ71jSgZbywl0CirbqQZq9w4nSuX6DR2ooegCM7gNgsI0bDxKHdtoxCA0
	 f1T/uevcfPw8Akk2IWz6/w8oRykDBX2GW7ZdedUy/1pXla2938KeChFUtrKICAT/Re
	 tO3BqDFipykd34xCADSx6l81cmz7BZ4JIHm92V+b0En3krxgHIzLuVqGg9JLiyNPFl
	 dvmE30P27EkpQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 00/10] liveupdate: hugetlb support
Date: Sun,  7 Dec 2025 00:02:10 +0100
Message-ID: <20251206230222.853493-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: x9cudnahpp4piyakeuwq1i35cio3zm49
X-Rspamd-Queue-Id: 202841C0015
X-Rspamd-Server: rspam06
X-HE-Tag: 1765062174-499415
X-HE-Meta: U2FsdGVkX1+aqq5XGK0660/E2UmSt3y7LKySiQ48CQI8+unm1kZZKK82rMLtEdxAPYZZnW0dcoqIkV3lJXhm6arefrccn536N5lUITSEbbh/jFzmOjF3dJTvR6bwEjMByM1V4KEJS61IzAGMM8EjWWT8NZQ221pbQv6w/4w9aCyttiCmyIfqwM4aLBX/yDWMt/V7M+nNvmiM6GKjiA3QkCn3z3CE9RR+8b3SY0py6mCitAdA8zKUXVLGMCS4SXa2uBYspYrrH2jc+xLRlpjbsXmq4UWmqMzUyx3SeF3taOFpkXHNvKtQh/uxAxnxp5cv0Wtjt7yT21HlK5eIwKwpUCyNoNuVvEiKJnM3HA5N2071lkD2BJt3uARwYWrOmPYlzmvST8OIZSY/BjWZOnRj7MULfjka6Vkc7JHtyHBmpZUdR7SbmMjyWvSxNwTK8YmE4hhjgKbXWzqIzDe/FFmB0OH83lmwztxORi1VPslI4sEwW2mQS16Pdd4MjvVzGysZhk8BDqEgwCNW0joz5GPraATIl1GkBRvTa0ya2tnJGhykuEppPfqo5F9htzVa2e4jACSRHExeYVdahSivDwYlxrgdRovw5wli+3oQoK5cJMpFfiotcTBg1sMqStngF3e0Cz84RMfsnebicoZw+uS/CY0WGEOSvHUjUiCwTl5WjHN6rj3XtTToB0EszlRGOFifGlOiYiNc/+B4xYADrt4aQxBEc19KbWC57xKJL/cwsuae0BbP35SNYhmDDQRKeOv0O+01yOwhKv1jmSoJdL8wOoNVuvmrhJE3QwoyfmnubQUnuyFSrsXfu+5iQzD5T8e8dlugAMG41xJT7SgXDuMn+haNzzKkdwU7ROESAGCCFD3nBcW1crxsC8tTNF6TbxhwiPRYXzJ3lBdO8/d7BmjAdzx9jjE5WmDQtmWuWjAbLsD3QaZ7t79CqJFFLnsEE5QbcawKQ3BxM4zXs8PEAXD
 kRIL/N6M
 DfIbBsPCPI1LrogWXaez7XNR16gVJEFfZKL4jiUDbtrl4jsTN/vBsxNun40R/crWNtxuuYmYaIYYW89HuOqmbSOgLpGFEpgFyYvNj+pIxVisfRqoQ/vSK/PEv/zwukXaooGNR+fVX+3E0pvIEOYwdSXihx+C6NQb2NFO6kEWqPLAfyF7UxmZGH4C9z2X02JFA2uJr8YiwOfQhyau+dKVIFZEWRPnQbnJuYKZkvxm0XnCrdDOx+5NSneM4JUlF0HbQR1dEB8t67q8IBWSA1lF3Xs0NCj7V/C4/zSmWnkmxQLveRd/hVJgGkNGIK0gwKCHt5xWfGXgtY6CLbGxtTlLpJc1zUZv+rg7u7AtWEaC+u+iuiMUuQljX9OaNOzL/pKwbPWdXWUgJSco2jNEq0auRKYCARr1TIzSSpzHH48kNXImQR2nwO3pPmcjL6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds support for live updating hugetlb-backed memfd,
including support for 1G huge pages. This allows live updating VMs which
use hugepages to back VM memory.

Please take a look at this patch series [0] to know more about the Live
Update Orchestrator (LUO). It also includes patches for live updating a
shmem-backed memfd. This series is a follow up to that, adding huge page
support as well.

You can also read this LWN article [1] to learn more about KHO and Live
Update Orchestrator, though do note that this article is a bit
out-of-date. LUO has since evolved. For example, subsystems have been
replaced with FLB, and the state machine has been simplified.

This series is based on top of mm-non-unstable, which includes the LUO
FLB patches [2].

This series uses LUO FLB to track how many pages are preserved for each
hstate, to ensure the live updated kernel does not over-allocate
hugepages.

Areas for Discussion
====================

Why is this an RFC?
-------------------

While I believe the code is in decent shape, I have only done some basic
testing and have not put it through more intensive testing, including
testing on ARM64. I am also not completely confident on the handling of
reservations and cgroup charging, even though it appears to work on the
surface.

The goal of this is to start discussion at high level points so we can
at least agree on the general direction. This also gives people some
time to see the code, before the session discussing this at LPC 2025
[3].

Disabling scratch-only earlier in boot
--------------------------------------

Patch 2 moves KHO memory initialization to earlier in boot. Detailed
discussion on the topic is in patch 2's message.

Allocating gigantic hugepages after paging_init() on x86
--------------------------------------------------------

To allow KHO to work with gigantic hugepages on x86, patch 2 moves
gigantic huge page allocation after paging_init(). This can have some
impact on ability to allocate gigantic pages, but I believe the impact
should not be severe. See patch 2 for more detailed discussion and test
results.

Early-boot access to LUO FLB data
---------------------------------

To work with gigantic page allocation, LUO FLB data is needed in early
boot, before LUO is fully initialized. Patch 3 adds support for fetching
LUO FLB data in early boot.

Preserving the entire huge page pool vs only used
-------------------------------------------------

This series makes a design decision on preserving only the number of
preserved huge pages for each hstate, instead of preserving the entire
huge page pool. Both approaches were brought up in the Live Update
meetings. Patch 6 discusses the reasoning in more detail.

[0] https://lore.kernel.org/linux-mm/20251125165850.3389713-1-pasha.tatashin@soleen.com/T/#u
[1] https://lwn.net/Articles/1033364/
[2] https://lore.kernel.org/linux-mm/20251125225006.3722394-1-pasha.tatashin@soleen.com/T/#u
[3] https://lpc.events/event/19/contributions/2044/

Pratyush Yadav (10):
  kho: drop restriction on maximum page order
  kho: disable scratch-only earlier in boot
  liveupdate: do early initialization before hugepages are allocated
  liveupdate: flb: allow getting FLB data in early boot
  mm: hugetlb: export some functions to hugetlb-internal header
  liveupdate: hugetlb subsystem FLB state preservation
  mm: hugetlb: don't allocate pages already in live update
  mm: hugetlb: disable CMA if liveupdate is enabled
  mm: hugetlb: allow freezing the inode
  liveupdate: allow preserving hugetlb-backed memfd

 Documentation/mm/memfd_preservation.rst |   9 +
 MAINTAINERS                             |   2 +
 arch/x86/kernel/setup.c                 |  19 +-
 fs/hugetlbfs/inode.c                    |  14 +-
 include/linux/hugetlb.h                 |   8 +
 include/linux/kho/abi/hugetlb.h         |  98 ++++
 include/linux/liveupdate.h              |  12 +
 kernel/liveupdate/Kconfig               |  15 +
 kernel/liveupdate/kexec_handover.c      |  13 +-
 kernel/liveupdate/luo_core.c            |  30 +-
 kernel/liveupdate/luo_flb.c             |  69 ++-
 kernel/liveupdate/luo_internal.h        |   2 +
 mm/Makefile                             |   1 +
 mm/hugetlb.c                            | 113 ++--
 mm/hugetlb_cma.c                        |   7 +
 mm/hugetlb_internal.h                   |  50 ++
 mm/hugetlb_luo.c                        | 699 ++++++++++++++++++++++++
 mm/memblock.c                           |   1 -
 mm/memfd_luo.c                          |   4 -
 mm/mm_init.c                            |  15 +-
 20 files changed, 1099 insertions(+), 82 deletions(-)
 create mode 100644 include/linux/kho/abi/hugetlb.h
 create mode 100644 mm/hugetlb_internal.h
 create mode 100644 mm/hugetlb_luo.c


base-commit: 55b7d75112c25b3e2a5eadc11244c330a5c00a41
-- 
2.43.0


