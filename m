Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81691C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F2D6B008C; Mon, 14 Sep 2026 09:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0606B0092; Mon, 14 Sep 2026 09:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AEEE6B0093; Mon, 14 Sep 2026 09:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40FDE6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:52:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8229E120153
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:08 +0000 (UTC)
X-FDA: 85212506736.06.7DA82BF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4B905180005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tk+RZPyw;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cM67djn2fRA+KCyd0hnmPMEMIDSDvJTmP12zr9BGRg0=;
	b=uxBmQ/ATnSgGrOy/hwgzxlCbidtuDWHcwF3JtJ2fZlJWe5eExeH+Te74j0ZPHlYq2hMWJQ
	Z4BNe4FdGa568bJKJM+HfOVqV3TRtgrpfwCmSoS82+7GYF+5xjvAFm+rBTYNToLbh3t5Zt
	syOamzGUzudbCKhMd2ahR76V7Qox5eA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393926;
	b=6zdRm1XdguN3OT+MrjaXU1Hh/4r8EpSQtL9lVgC9yae3eNpWXLeBHN59Q7I6DzwBYxiKJU
	wKOjQEujwK40Qoi3IwIF0NB/h1+WuKbToJnLtoCn8WPQmiCofc33tjJkywHXy/D/y5O9pc
	neovSXKtQvbbaUwPhxpCPUESPTehuAY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tk+RZPyw;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 741FB1570;
	Mon, 14 Sep 2026 06:52:01 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D203E3F882;
	Mon, 14 Sep 2026 06:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393925; bh=8bcmJRzDVb4V3IZFLlLeumBeTAhSpAnT5L10Em+D5OE=;
	h=From:Subject:Date:To:Cc:From;
	b=Tk+RZPywSSvl3bQ1edKhmEVBmo8RzAH7Qc5AZ04G0FWVQoL1uB6jo76WbFghq8tLT
	 Bh11TN1PblPVURJeW05SCe/mV9ww2hDTyRxTgOtUOziFsLhEE0FYtkiV6Ckg2mcu/S
	 SUNuZxyGBkb4FupTF3a5LT3fgJ+c6Euuof10W8mM=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 0/6] arm64: distinguish HW PTE pointers from SW PTE value
 pointers
Date: Mon, 14 Sep 2026 14:51:30 +0100
Message-Id: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOL7p2oC/yXOQQqDQAwF0KsMWXckUaytq96jSBk1tlMYtRMtB
 fHujbrL/4SXLCAcPQuUZoHIXy9+6DXQyUDzcv2TrW81Q4rpGa9EdpwYHy4G21FdtF3RYJ0T6Po
 YufO/nbpXR478mVWcjhICi7hdLM3hYUaYIaYJqX3Jr5bsLC64xPXvOdz0TNIMYdNrJ2x1Dn4qz
 f7D1kC1rn/5OF0MwwAAAA==
X-Change-ID: 20260911-pte0_arm-f1b7df7c0b51
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Stat-Signature: 4oy7g1g3saho783scby8s5hygogmhhqj
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B905180005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789393926-554119
X-HE-Meta: U2FsdGVkX19Fi0PpiutlT/lcNKHSOd38FPq842Rv1VbU7gOteA7Xj4IoWKZgk2L5sJoGfUcxo45yaB5NRw35OKpXTUGd4l+0s4ZDQoHNtuT/Wpchn5j+/RMuJ+BLnYtkopFPfbaqhy7RQvxbbSTAD7ogw/R6DsE78k7eE03TQWZqi8gHGBO/OlWL10CkrjLOl9t9+S4iSr7yYiaVVJCGPKjWFZV5+HxelKj7CLUoOUk95/sHj9VlOrcWJM/SFEriwXUEa9PXzg2X9XhiJ5lMBhWouPRUmRvDL7JrdqvvCxQNKlmjM8lnEHohVplUeYV4iHBL0oXakkV34SvwOT+QMldtHwCNPMmlFcCYHs8jOuv3zkKg3l62Rdp4ZdqcT2lz2eUyxfZyCF5C2B909Lo/dlXbMuez/nx2T2X3yUwIKT7Cmc9VzGQlauvNoS6Q+u5NWgrmOf5dF2xvE75JtewRT/Sd4B7sx0PzpPG3lc6EnXFQI/Hek1qSXoElaYOzu0EbOfrSytlLydB31WNyyrh1f3FSUjVzg/gjwR00LXKQHVPy5F6NqIMdjPEq0wO+HahXBQEP7rhVxlAyAcMjm7CGftdCJ9vXuE+rrhy3oPFgi8hDcvK2NpnPKU1Zbex+JMTI27qAHaQ2qal3ErPYHwkwLMU1vqtpqOR9LaYftc4oOqH7fxVZsmCAJ1wsW5u9EYOGVzVlBW2iyOdCyo5uoMW6T1nDP75f1LJjyqZporNGHUKadmd8Aa7RC+/itpx5DyYN0yRERfIjKyp2chNGTPE1OeOLMxvEMVvOCDh2I/ojlHs69P+issZ1fdbgQr0p97i/kKdwbr8AaPGTwNtbpcx41/pZWCBNB1XvvXWY0n0l5+ELttUNF0PwvAubuik0SHMDGOf7g8Z70A/dWjvvareSBpqT37HjzUaA/bizfYASCAtJlBXMh+/HaB8/grL3ibmO9qr0msQ5SJRK6AGjlkJ
 xxtJI+xR
 gcMnsr8gibRpCWMvygPR8PfILb+pTpTQKSeyDXKPzC+cWdmWpuUsoG4maVutb6zQ8SEhtlzTP7zZbUQNsWfPZV4nTGJYS0gKFoXCHXExUiFHZ2T+4PyoS5Gggkb8IRv8fGeCLWmv9AFmefHT04xh8u+f/Nbptq6Bl3iSFgd6IO7HUojYOs7IbVjYHUcXQ3BrKnMbjHBr8CnieAgw1FKpry3LkQDJkyLroOCM1pypZg104RRj5q2DSbnZL8g3x+j72y9XAs0QHWT9MUMM+NOZz8SvLTd455ABiT3SKxDi64K9N2u5DXsYRfFOeu4EViJP5Vrbbgw2FSheU5YZ3P8c6fisLUemmA1a+caBR/iwNAZcbJ3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The generic series introduces hw_pte_t for HW PTEs, while SW PTE values
use pte_t. This series enables the distinct type on arm64 so the
compiler can distinguish HW PTE pointers (hw_pte_t *) from SW PTE value
pointers (pte_t *).

The conversion updates HW PTE pointers and accessors, including atomic
updates, fixmap, and early page-table construction, before selecting
ARCH_HAS_HW_PTE_T. Higher-level entry types remain out of scope, and
shared helpers retain explicit casts.

The linked generic series is a prerequisite. Its cover contains the
Coccinelle script used for most pointer conversions; the remaining sites
were converted by hand.

Link: https://lore.kernel.org/all/20260903103002.1091859-1-usama.anjum@arm.com/
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Muhammad Usama Anjum (6):
      arm64: use hw_pte_t for HW PTE pointers
      arm64: use hw_pte_val for HW PTE atomics
      arm64: convert between HW PTEs and SW PTE values
      arm64: use hw_pte_t for fixmap HW PTEs
      arm64: use HW PTE accessors in early map_range()
      arm64: enable a distinct type for HW PTEs

 arch/arm64/Kconfig                |   1 +
 arch/arm64/include/asm/hugetlb.h  |  19 ++---
 arch/arm64/include/asm/pgalloc.h  |   2 +-
 arch/arm64/include/asm/pgtable.h  | 157 ++++++++++++++++++++------------------
 arch/arm64/include/asm/vmalloc.h  |   2 +-
 arch/arm64/kernel/efi.c           |   3 +-
 arch/arm64/kernel/pi/map_kernel.c |   4 +-
 arch/arm64/kernel/pi/map_range.c  |  20 +++--
 arch/arm64/kernel/pi/pi.h         |   3 +-
 arch/arm64/mm/contpte.c           |  49 ++++++------
 arch/arm64/mm/fault.c             |  11 +--
 arch/arm64/mm/fixmap.c            |   8 +-
 arch/arm64/mm/hugetlbpage.c       |  48 ++++++------
 arch/arm64/mm/kasan_init.c        |   4 +-
 arch/arm64/mm/mmu.c               |  46 ++++++-----
 arch/arm64/mm/pageattr.c          |   4 +-
 arch/arm64/mm/trans_pgd.c         |   4 +-
 include/linux/pgtable_types.h     |   6 ++
 18 files changed, 215 insertions(+), 176 deletions(-)
---
base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
change-id: 20260911-pte0_arm-f1b7df7c0b51
prerequisite-message-id: 20260903103002.1091859-1-usama.anjum@arm.com
prerequisite-patch-id: 0114fcc6ab0dbb739b5bb6fc0fe6b1c8f1fa37a1
prerequisite-patch-id: 09fcf65970074620dd3a9cce6850b901beb01db8
prerequisite-patch-id: 9b2fdab97c99effabb85526fa7f141c933b3aa23
prerequisite-patch-id: 1aa309a26d98a1e93a54742705a03567ee93be71
prerequisite-patch-id: ebe32f52c95ad0542982f0b37798d209595e25e1
prerequisite-patch-id: a60d249f52d092524176851b2570d7245bb24434
prerequisite-patch-id: 81ebd1378e25d40a1771b53973abcc4defa87535
prerequisite-patch-id: d982f2b00c5eddb2459f69008a73e4f4ae4d8299

Best regards,
--  
Usama


