Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21285CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFBD8E0012; Thu,  4 Sep 2025 08:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7EC8E0001; Thu,  4 Sep 2025 08:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDF58E0012; Thu,  4 Sep 2025 08:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5924D8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:58:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2809D1187D0
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:24 +0000 (UTC)
X-FDA: 83851571328.07.A86F16C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36DE0A0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=xx3k/xCeAHwbrVKHW5t7t/1u791QzLoKUDcVcEFFHzQ=;
	b=UhccNz1KiAmQbGE77MgE6703S5uxfVViwMCv8g9QxspDx9kr0H/yI8QGtCsXybdkYnVact
	I4MdKyztMFBVzsLuCw0SED+3S1Ot0KQ8HotAv17iC5HhNnh30m91UzkGrT34l4Sr24v3nO
	ZTjjALIv3Z0XJbvwWw/VK+kPpLM4SVQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990702; a=rsa-sha256;
	cv=none;
	b=n06NTioRiNxNNYFu7y6v56vbSh0U0dA7clqQE83JdS3OTX16WoLPPrEO2ZPnLVt0Ywnt3D
	2ch+BU+k9AJ1UZGiaO85dCVi1XkKEwKD1LQGjpWILr0S4VBaRHZT99QLoKw+lpuniXA2sN
	I1TADtpLcUpAQj3n5F6jOFLudxU0KNw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F7181756;
	Thu,  4 Sep 2025 05:58:12 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 684763F6A8;
	Thu,  4 Sep 2025 05:58:16 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH 0/7] Nesting support for lazy MMU mode
Date: Thu,  4 Sep 2025 13:57:29 +0100
Message-ID: <20250904125736.3918646-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x8kqqos6nbff8f6aag1g5dsug3xjkmsa
X-Rspam-User: 
X-Rspamd-Queue-Id: 36DE0A0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756990701-140120
X-HE-Meta: U2FsdGVkX19jpWXddg14tlZD14lwKjNdCi2S6Jck/JubRhU7fppGvvDtTvM1HTH83JMBEvUsY2oWp7VKO5RxTzpr8FhRflstWydxiYnxsenxu7YMhdoWa8f8dW8xhvxCH/wM3oiqczQk6bI1ud5CDUQ+ZRzOJIZsD9QlQfvdud/x0XpWFH0V/pr8/yNAobVpEZT8QYYtpFBqKvZMm03MhZXqz/5gGnYcK/mZttacHSpIvp//kqOAQK8S8UKIDVTo/vaIGYCEhEXqZKcODT2pTawrBO+7fyZgJayTxL1y3c/f86C2FrVxap/t/EexPzPvpHdDTpZeaITzb4tpUDLZ3E3+xWWqzDpcFnwvDHGEsI0vjXiHrVz9DN02IhOGIkwNd2OiMknmV40TXSRppep8QK+LADEnMWN5+qMIvL6TN+En6bxg/F2+iB3mmdIgl5+CXIxc5Y3x88HAh0HpZCclpQBzy8TRji/eJVZzVXnR2jSeIZK2ggTX1n0NC53r/1IJ3J4g/Cq1UhHdSB4YdhMmF6mDjOiGsATjpqFCMi4hAFV5346csg9bp6z/NtwP13/0HPGRPKgN5mK2WEx9JFXEpzGXG9loGiXun+xKJ0WdCOqU3YFGcXu5NVv57gVpVzNwMlHh8VjuVTlEofnPZ84S7WKfU21jGykoUriJ710vimNNkxwQcpGbjeHo5I5P2xM52fMEvfav1Lsgq9eOxuPcsC1hC7nzLh1L5aOSdEXvP9CJjAnFPdp3NY8ktp0DWetciV2qYhcIsUp6u3ywynXAIWHhHHBSBpVxFoVSp33+QJA8rOFUczK8DOfkRsfCXOSnlQcASDXkGf/3cfQlNm7roVxitqTOaZ516KQ6xIS8CUUHaFVxikHmUYyUUZ4tkxKYvia/b3brjKRAzfO1JdlsFOMOi1eW7iF3pf1eqW0f9F8Jv8/cxKxOOv+4VSdCvyydmkodHbnbkGvVZCcJcV/
 CLLCdnjb
 FFTJHER1MHFMqPgnAJvXQsRUqi5R0zgGIoFHJXKx7JDYDkkN1YHNE63AXSFpGaEJEks/smUbH59bm9UWyXePeBAStPkIVhqN41u53Z5hQyyR0yyT8g0HvhbPHS5oEXQIFBgNbzRKeKvB8LLRvxmVKYI+YharxcL/nhf2t1CDAqXcTAz0jMbRcag1qptCiglf/set01bdtvrvy0qQkZlr4CjDjH3hxQCG8bQ3dZHr6KLPLweU0I0O/SCfQSSKZLkW14qya7muyzNGCmNpJNXTl5nj1D+A+sQjuzAqPbel7yFwU4KzZdqYnVLvHnC23bPjm6PTUygVwKcXk/e/d2iWnjO6U0E8sw/gZca8mINJOyJSHohroiecznA7bnV6AkkjgEhZAig8uizWQ5Z/Aa4h+fybeuenOUXNuHHA+taYf1S0CJTY9yk60UoTJTPpr0gIdCFTofJBEEilXHaEAPTqZ2TMVBZFbemEkzg/1Akn7wks/zw5cI1QfrPalXUmWUM/QIZLCEQS4V6X1A4YzlfDbIt1PfVu3gis3/1VuC9ccf9LnsJqn8DKiPSYKjHVzXtGluiAhwsN2BGDpB5fM5roA1x2zw7aFwAluhf8OZCe8EARZV+VcSHBIJw8gxNDQTLTdVN2E7+pNjP+Rb0o+Qlbax/WLFqxFNTVNQZH7IUenmzSBnFtOScHBw5S/hzA9yVpzkJtm5+P8XL5PffrcNsGkDlKz3+Uj4Jabs04HKI97aghI9Q6hn2jpdMxfcu8Q9PvBJYZIfLN+NZ80wGAST3Ir7zOplVx3/SEjPblsrrSvqueGn0aGiOWVx6+cpFcZ9rJs96FL2OGbYkY243hjp5Dch2HajP3MPZ0QD6oL
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
 .../include/asm/book3s/64/tlbflush-hash.h     | 24 +++++++++----
 arch/powerpc/mm/book3s64/hash_tlb.c           | 10 +++---
 arch/powerpc/mm/book3s64/subpage_prot.c       |  5 +--
 arch/sparc/include/asm/tlbflush_64.h          |  6 ++--
 arch/sparc/mm/tlb.c                           | 19 ++++++++---
 arch/x86/include/asm/paravirt.h               |  8 ++---
 arch/x86/include/asm/paravirt_types.h         |  6 ++--
 arch/x86/include/asm/pgtable.h                |  3 +-
 arch/x86/xen/enlighten_pv.c                   |  2 +-
 arch/x86/xen/mmu_pv.c                         | 13 ++++---
 fs/proc/task_mmu.c                            |  5 +--
 include/linux/mm_types.h                      |  3 ++
 include/linux/pgtable.h                       | 21 +++++++++---
 mm/madvise.c                                  | 20 ++++++-----
 mm/memory.c                                   | 20 ++++++-----
 mm/migrate_device.c                           |  5 +--
 mm/mprotect.c                                 |  5 +--
 mm/mremap.c                                   |  5 +--
 mm/vmalloc.c                                  | 15 ++++----
 mm/vmscan.c                                   | 15 ++++----
 21 files changed, 147 insertions(+), 97 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.47.0


