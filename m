Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 115EECF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BA66B0032; Thu, 20 Nov 2025 09:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A216B6B0062; Thu, 20 Nov 2025 09:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CF36B007B; Thu, 20 Nov 2025 09:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 775A96B0032
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:42:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2698012C63D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:42:28 +0000 (UTC)
X-FDA: 84131251176.06.C71114F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49C98180002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:42:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=TbRkCcmS;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf06.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763649746; a=rsa-sha256;
	cv=none;
	b=HxJ0HI8+5U2xS+sRNzy2FlznvRl7D9lXTNz8jhoRDBT1lfJpNl5C1g2DscbzoAUFAPWvi9
	ixI4fmibuqlxjBINESB69O1dmIbUMYSOBQYen9NiBzh2ljJ8DS/+DN3uYejoec4z8+5+gm
	/xr3QzxNhgFoG3/GGQtOp085krjTZ9M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=TbRkCcmS;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf06.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763649746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VzGv03IYbkXuhrbno5kD8tYczSIVbSX/Gu02hzXe/jo=;
	b=cjSsnzd2UfkjcQkjfiptGx44vJBiYZfgjHPAZpdz45GfXA2ev663OBX7u7axknsEyIqUjB
	Fcwo/bKvCUXXIhJILnzJs4FqE+Ew5+YkIbPdKrvEHPkm1HxIS8VKN2UBETjQG7N5teQqea
	HTKu0spx17s4GlJDzXP2vSsaqerJTiY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Vz
	Gv03IYbkXuhrbno5kD8tYczSIVbSX/Gu02hzXe/jo=; b=TbRkCcmSf4nblu/8gP
	A+0RSQtSnda2MSlbfIJ3KV8GTzmlSCTkSNmRxtB2/7BUSupFgEIWHcOxBbBypd9q
	VIyaGSxakci3yrFW68ev6/b7x4j15RepqGAw17oVexLk8UUll6ahvX1Bx/3mvD4m
	/nb+WzcHfYRzFQtqZk2oDrft8=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wA3yJmuKB9pTEQrBQ--.727S2;
	Thu, 20 Nov 2025 22:41:51 +0800 (CST)
From: ranxiaokai627@163.com
To: catalin.marinas@arm.com,
	akpm@linux-foundation.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	changyuanl@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 0/2] liveupdate: Fix boot failure due to kmemleak access to unmapped pages
Date: Thu, 20 Nov 2025 14:41:45 +0000
Message-ID: <20251120144147.90508-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3yJmuKB9pTEQrBQ--.727S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr48CF43Jw4kJF4fJw1UWrg_yoW8Zr1xpr
	yDCr4jkrsrJa4Y9Fsavay0kryIyws3KFWUAFy7Xw15Z3s8WrWIyws5A34YyFyUGw48Gr4f
	XF4UKay7ur1jqaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pin2-UUUUUU=
X-Originating-IP: [117.176.242.6]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEAkMTGkfJUZRaAAAs1
X-Rspamd-Queue-Id: 49C98180002
X-Rspamd-Server: rspam07
X-Stat-Signature: y586pstq9os4faypmnkz7c5o3y6iupuf
X-Rspam-User: 
X-HE-Tag: 1763649744-396757
X-HE-Meta: U2FsdGVkX1/qgYUcnifENG/zt2lytJI4gHqPhufCyOLOYzcu0M99Iy7PpordkhfxAFFOfZRzMORIJCz4wWPS4r+DAzzx3j6PG7BI8KcguDChbIaWayBLw3WzwIG+tix6oCsG4IbC4FJ98gKO2z3e7v4AYg1Ln5wRoERpbGIMDY2qeumRT/ktHET+Mp8n7YqyaoOeVYGicu73LIjhhQ6OFbaerjjGnr3B4Wv5GAFhSc9lWd9wVRJVVlTjcPtT0RxKKDTfzzWxAc0rL4WGull8jzY4gfO6LrIsvNp3/hqo1Wz7kjXF7pddF7h0DO9D880216uVMtFo44X/F6/7wf3Ut3MPO8oiVJesOjAb5j13+hlv4yPcULz8Ol6KeippVaggdA342ljO8DJfghwTQ80We2sCOXxarsYmQuXhKhKt/RZsoSdcIpceML5qHb/aeYFDnM5trZj/TNP4HYCrqVe0lHiTuN+6giIfCdBlqZVmJEFNvuyElNDJ1c1iRPYIsco37sV/26IpzG1sYkFnZC1qLhy8O1D9oKoCg0E1hX1gXKaPZ876i7TsvYY5BQ3yeE3dTN9s0INFsqCY7EXfeeWMnMjOSRPhZFoXOvuK1b2OnpIpETZ2Cdl6/9o81cj2gg3z5aP+wvOLqFwRmX3KJxvuSC5PlWxqynwTkM5psFZsc2wdHHHhxBxkEoYQsL6V+yWrSTLYaDKyLK2YgwAqH0wjBhisnyMy4PHsqjwWAPEKPdQjq4X9rcxhan+x+oXdlhcyujJ7TpGb4lqU0+Z5BiHqRQRVyiLpqc0+lJPqH6VZkSJuIfgNgC2+8B22Liz0ZyOpDXVq4NPN9vljIk4vf4jEo8Sz/6LFT8e68LHcrRJDrn2aLV2wKRn6XwgbxS/gRi5G1Tbm8F/iqko9KENJMYl3XSeXPfAQ07Ktg2Zw2ZCyxjin5CmK9BKkJ5X52iKlqHsX4EnbaznuSd6qbcarvjU
 i/wiLFvg
 T8U/DExkJWTByZIRTeZ7xd58Shjwj/RoFo8ZWRME8gOUxWiqH4Hx9/DUe3gzdVf//OJCVB4WTrEWIIeEqi/p2EQ8aKTBjLXpmUI6pavBySIeo42jxbw/Rr+jWofy+wOurnzpVxPkP6yJwwM++Br1ijwg5TxfSPTIx90vXqa5soxYpMr+PYK4N2x5miMSmhvcHQ1gIdxfUTbvbthyS/uoV8MECQrW6yJGCHwfxetQUEXjRxoCwMWyR1gLyUyyEG0MSeKk3jATPkjM8eohOaTysNXMae7hki9+yh9DG/S2/2R8LFDCBr9yQb1wG3T+s1ltmcRf0bu8bWlnbTufY90hYcPH97yYC+e7Tdl5z6JI6IafMn4IkUkFkEHcrdAROhZ2tXWR7fnZbxDmP0jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

When booting with debug_pagealloc=on while having:
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y  
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n  
the system fails to boot due to page faults during kmemleak scanning.

Crash logs:
BUG: unable to handle page fault for address: ffff8880cd400000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 11de00067 P4D 11de00067 PUD 11af2b067 PMD 11aec1067 PTE 800fffff32bff020
Oops: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
RIP: 0010:scan_block+0x43/0xb0
Call Trace:
 <TASK>
 scan_gray_list+0x2b5/0x2f0
 kmemleak_scan+0x3b1/0xcf0
 kmemleak_scan_thread+0x7d/0xc0
 kthread+0x11c/0x240
 ret_from_fork+0x2d3/0x370
 ret_from_fork_asm+0x11/0x20
 </TASK>

This occurs because:
With debug_pagealloc enabled, __free_pages() invokes
debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
freed pages in the direct mapping.
Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
releases the KHO scratch region via init_cma_reserved_pageblock(),
unmapping its physical pages. Subsequent kmemleak scanning accesses
these unmapped pages, triggering fatal page faults.

This patch introduces kmemleak_no_scan_phys(phys_addr_t),
a physical-address variant of kmemleak_no_scan(), which marks
memblock regions as OBJECT_NO_SCAN.

We invoke this from kho_reserve_scratch() to exclude the reserved
region from scanning before it is released to the buddy allocator.

This is based linux next-20251119.

Ran Xiaokai (2):
  mm: kmemleak: introduce kmemleak_no_scan_phys() helper
  liveupdate: Fix boot failure due to kmemleak access to unmapped pages

 include/linux/kmemleak.h           |  4 ++++
 kernel/liveupdate/kexec_handover.c |  4 ++++
 mm/kmemleak.c                      | 15 ++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

-- 
2.25.1



