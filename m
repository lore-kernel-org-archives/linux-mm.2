Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE47ECA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2C48E000C; Mon,  8 Sep 2025 03:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164468E0001; Mon,  8 Sep 2025 03:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051DE8E000C; Mon,  8 Sep 2025 03:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFAFE8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:40:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C0DCBC821
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:36 +0000 (UTC)
X-FDA: 83865285672.15.F98ED35
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DB1F3100007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=MFkkO1F/ehQm5F1fclNMPZMJvYctYpk2C79PJc5Is3I=;
	b=xKUwtW57evwCDcA5ejWESNbumMosWT0NK7DrdgOE7Gp+pYuq8GmmtweG/R+eWwF5aLQzc2
	9AcE3p/bw9t2HpbGmgH50Ezg/LSk6C9X8QbGUpOA3ynD9GMY+lFrDWotM0vSPCAC65J1pU
	2XF8kCu2VewoYrPHEQ4hSAsH0CEZ9X0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317235; a=rsa-sha256;
	cv=none;
	b=WjM7y9pHNtiawBBQ8troddHqWIOaCZafAKPO1MdIxy+LCG9JyPox4zm1+tHNvoG0JHdYYc
	cv6fJT0kkH0vvanTYQKV1/M0tVYF/vdTwEz0lAXcF/vZ42ZBPiulGlWLGiKP/kAR3rGPZA
	OhavBTnW/lcOodipzeJultYIu0/ZTXg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E6E91692;
	Mon,  8 Sep 2025 00:40:25 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23BFF3F63F;
	Mon,  8 Sep 2025 00:40:29 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v2 0/7] Nesting support for lazy MMU mode
Date: Mon,  8 Sep 2025 08:39:24 +0100
Message-ID: <20250908073931.4159362-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7183y8jje6spozhkg6opf6sjgz7u6qwm
X-Rspam-User: 
X-Rspamd-Queue-Id: DB1F3100007
X-Rspamd-Server: rspam01
X-HE-Tag: 1757317234-240228
X-HE-Meta: U2FsdGVkX1+9cyHQlDu4yIOyUF+HWiJA6GQOgX/jsrIAwt5N+W3a70OyCBlbDNsXfo3PzTl9Ta3e4nmZTkW4rtfYl+75eNIRWfMX5zAv7MZgq4ZMo8i4QzwnHG+Z/17QpC/u2n2ROepaXu0oTBCCXwuh0eLdzUAFyPenC/ynIwtvBvU7zr5AsGnzoKdHtg+aBFNnbAnNxYu9FTmlCJgxQW4tlNgelIbKieGM/zqjglCVfmo1XSskSgD4e/68eXqiCjI/hwxySFqxDLIcEhlOAueRBbqu01MECBrV9oCXQNC6+TP5ab4LmH/gMeuyPCafQTa1fk8W/poUuEQPdJWv2moB7Iw4yJyPJaj7Lm3q8N0Ive6ZqHoPwJ6CVHSnJfUCIhOHGd98BRaPaDb1zgWybJMuUaQST+GBEqClpTHbrV6NjV55QLl6gJVoqz91gH06/tE0X0XB97BqlkwC3MReAyzD/7rF2S5zekJXjNztd6iEGwsnFEf4Ewxo9dbp69kb0DvNKo4wtfPmucYWTaXixZ9XqciGiYpXsRi04wIOuMJ5f/xvrBP2xqASkbQuL+1XoQpT8ektS0fO8mq6228UDx7YPlIN77QCYHvwpV7uRwFJQCKcfpxd9sq9z8cNqn81J7CaPRGSuVWYPD2knWcof8xSBN0BU8dnS7gwMNw3SIgUMCbyMfJRA3Znm1gDbSgVm3UChb+Duy1Oy6mTh/zGjK7A7HnAW/wUvCmKApCZ8RaNlY8/VmwRvpLXo8oQkM+4ZBuNlEd3ZwPHbXQgIzNgf7EuzkaRON2ZqxCUhCNyW/SkYnxqbo2Q7SzVOfTCsSK/dLvMY9t85PAc0Z1htJwaOExL6zWZSCPaVxB+pktymrb/aHLntmv0gCoQwpKmKNh8AmrdVO7FrocU4Nse7Z02nNQCT4Cih95RfCiFHLymMMo5tWuMf0hCR/yVmIPrFtU73dxGf0y9JjZsZgNvN0s
 fw4IVsnS
 3Fjc90+YJjiUdxzrH5GhjWE8VmgGtUs+CqM/Rk3dJGx5B05QzgG5DWuV2bRMZJRRvGihyT71evcmtRXm5S68I36cC/hyukVvVVG7tmQgfRBBEEIey878LtlYbmmFZEAYLuta0XWl7ouOuuJh0Wmtxl0z6C/6Q++agkbZbSyXhqUZcimSWOGzz5da8SbdgiRsaN8n4W1kckaMBVyMscK0izcetU2Oey64U4lYb4sX1Qezz7W2pWQZyVQriaqwGHh+rt/45lBL0tonV/2eExwClFINUiuSpNMQwaf6Xf+KEZ7fOXTb12OVZ9oEQvISyERTynWR/lzsGIu8MMHgb2GF19M2IwxOZAgdeQg0NxsqV173aJSN9chSsL9JtLxFoxW888MHXDo3OULnFGAqQZpo0/+vQusYLlR961id9QgzxTKITOzNMQ79RrgxmWoTAaDs2YEPZFej5CYqgTjhcZa8GVwS/UTJ+MVqF6cH11eMY2U2EZD/nEebzy8szCbHDyKeXX/WmUCJhfzFdmSXhm6xlWnzzjWbU9J4kFThfCK2nupYidCdKQV5yp5PhnxDu/W/SAPln5Mi6OUnFgVeg8sxuvZfT5PHCJheFaREmd3AopzDr1Jh70GhW7LHmrUVZN/U2FUvk722mRWscFYLuqK5s5D7YRX4KchYrDVWx92TpZh95P3Pdrkr9oNEYOoCSVQu+KGT3fxJd0qzQ5+8sTVDhfb6rpqVYZyHxA0opkzHahp0dmdxzdOJGPtfGeQO27QWVCkKXlnRYgboxx8LcS6YoJuU4eWnYq62h1llD1t/Z+YvtYNjALwRiPtqZ3aTZLWx32Zh3v/+4gzty2vH0C4lz6pjrX6WSO6LOTFyz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the lazy MMU mode was introduced eons ago, it wasn't made clear
whether such a sequence was legal:

	arch_enter_lazy_mmu_mode()
	...
		arch_enter_lazy_mmu_mode()
		...
		arch_leave_lazy_mmu_mode()
	...
	arch_leave_lazy_mmu_mode()

It seems fair to say that nested calls to
arch_{enter,leave}_lazy_mmu_mode() were not expected, and most
architectures never explicitly supported it.

Ryan Roberts' series from March [1] attempted to prevent nesting from
ever occurring, and mostly succeeded. Unfortunately, a corner case
(DEBUG_PAGEALLOC) may still cause nesting to occur on arm64. Ryan
proposed [2] to address that corner case at the generic level but this
approach received pushback; [3] then attempted to solve the issue on
arm64 only, but it was deemed too fragile.

It feels generally fragile to rely on lazy_mmu sections not to nest,
because callers of various standard mm functions do not know if the
function uses lazy_mmu itself. This series therefore performs a U-turn
and adds support for nested lazy_mmu sections, on all architectures.

The main change enabling nesting is patch 2, following the approach
suggested by Catalin Marinas [4]: have enter() return some state and
the matching leave() take that state. In this series, the state is only
used to handle nesting, but it could be used for other purposes such as
restoring context modified by enter(); the proposed kpkeys framework
would be an immediate user [5].

Patch overview:

* Patch 1: general cleanup - not directly related, but avoids any doubt
  regarding the expected behaviour of arch_flush_lazy_mmu_mode() outside
  x86

* Patch 2: main API change, no functional change

* Patch 3-6: nesting support for all architectures that support lazy_mmu

* Patch 7: clarification that nesting is supported in the documentation

Patch 4-6 are technically not required at this stage since nesting is
only observed on arm64, but they ensure future correctness in case
nesting is (re)introduced in generic paths. For instance, it could be
beneficial in some configurations to enter lazy_mmu set_ptes() once
again.

This series has been tested by running the mm kselfetsts on arm64 with
DEBUG_PAGEALLOC and KFENCE. It was also build-tested on other
architectures (with and without XEN_PV on x86).

- Kevin

[1] https://lore.kernel.org/all/20250303141542.3371656-1-ryan.roberts@arm.com/
[2] https://lore.kernel.org/all/20250530140446.2387131-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/all/20250606135654.178300-1-ryan.roberts@arm.com/
[4] https://lore.kernel.org/all/aEhKSq0zVaUJkomX@arm.com/
[5] https://lore.kernel.org/linux-hardening/20250815085512.2182322-19-kevin.brodsky@arm.com/
---
Changelog

v1..v2:
- Rebased on mm-unstable.
- Patch 2: handled new calls to enter()/leave(), clarified how the "flush"
  pattern (leave() followed by enter()) is handled.
- Patch 5,6: removed unnecessary local variable [Alexander Gordeev's
  suggestion].
- Added Mike Rapoport's Acked-by.

v1: https://lore.kernel.org/all/20250904125736.3918646-1-kevin.brodsky@arm.com/
---
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
---
Kevin Brodsky (7):
  mm: remove arch_flush_lazy_mmu_mode()
  mm: introduce local state for lazy_mmu sections
  arm64: mm: fully support nested lazy_mmu sections
  x86/xen: support nested lazy_mmu sections (again)
  powerpc/mm: support nested lazy_mmu sections
  sparc/mm: support nested lazy_mmu sections
  mm: update lazy_mmu documentation

 arch/arm64/include/asm/pgtable.h              | 34 ++++++-------------
 .../include/asm/book3s/64/tlbflush-hash.h     | 22 ++++++++----
 arch/powerpc/mm/book3s64/hash_tlb.c           | 10 +++---
 arch/powerpc/mm/book3s64/subpage_prot.c       |  5 +--
 arch/sparc/include/asm/tlbflush_64.h          |  6 ++--
 arch/sparc/mm/tlb.c                           | 17 +++++++---
 arch/x86/include/asm/paravirt.h               |  8 ++---
 arch/x86/include/asm/paravirt_types.h         |  6 ++--
 arch/x86/include/asm/pgtable.h                |  3 +-
 arch/x86/xen/enlighten_pv.c                   |  2 +-
 arch/x86/xen/mmu_pv.c                         | 13 ++++---
 fs/proc/task_mmu.c                            |  5 +--
 include/linux/mm_types.h                      |  3 ++
 include/linux/pgtable.h                       | 21 +++++++++---
 mm/kasan/shadow.c                             |  4 +--
 mm/madvise.c                                  | 20 ++++++-----
 mm/memory.c                                   | 20 ++++++-----
 mm/migrate_device.c                           |  5 +--
 mm/mprotect.c                                 |  5 +--
 mm/mremap.c                                   |  5 +--
 mm/userfaultfd.c                              |  5 +--
 mm/vmalloc.c                                  | 15 ++++----
 mm/vmscan.c                                   | 15 ++++----
 23 files changed, 148 insertions(+), 101 deletions(-)


base-commit: b024763926d2726978dff6588b81877d000159c1
-- 
2.47.0


