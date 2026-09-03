Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C74C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931826B009E; Thu,  3 Sep 2026 05:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909256B00A2; Thu,  3 Sep 2026 05:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8156B00A4; Thu,  3 Sep 2026 05:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 541356B009E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:28:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC715140491
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:28:42 +0000 (UTC)
X-FDA: 85171926084.09.A70953D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1075580002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:28:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RjYdGsba;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ey992VJ59vkyhnjjAc3vc3uxfb9JDJ9GYvnBCB4zM0s=;
	b=1Ef/TNKHG59GZWb+sObrJwoAl+czBRFQe0KCQ916OuuQUUcrTeWu2P11y8te89+ZCrzwoq
	beKrQ61h9ApkZVPLKhQUnXGjukqtsKPL+5qoJF3fxz/iM3X2TGgxO1gpS+Rg2H2OATTua2
	ySzo0C7HVu1GvB8nlLBnMcZxKVNk0U8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427721;
	b=qZRLPNIn+1fifLCwcPLMUo0t2q7ePxPy4/R7ZKX8uvHYnpqxG7D8ySdhLi+lOx/MX1rwMx
	42c6hYFFPZPvhFoJsFHrlLLQIILlo8XCTKgFEA0R3eMqOCvyF/SYShOLrV0ffe9L+Qso/7
	RbeC8OeL4s6YkQ/9WFfHICdE2KxcgRM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RjYdGsba;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81DA3600D1;
	Thu,  3 Sep 2026 09:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F7C1F00A3A;
	Thu,  3 Sep 2026 09:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427720;
	bh=ey992VJ59vkyhnjjAc3vc3uxfb9JDJ9GYvnBCB4zM0s=;
	h=From:Subject:Date:To:Cc;
	b=RjYdGsba5HHZrGO3OCHTmn5IC/N6RTyFrp8Z5Ubj7a/i8bjv42piN/UnRLS/1Bh0f
	 T6WY+xo9hTACaiHWVLL1I64700TyI6CpONHAAc7NH1wFG8764Rix/yvus0e02RzHwJ
	 6lVfVHzvDDFZZPilK+iLbOrh5eOBUwY4cU1HWIxlQloKPJ5EF4Fp2HIhI0ZgNnmusl
	 YeF8CNVhBIJ2OM4LcTF0AHaHbrzgx1W2NTXtc9Jgo1VCc736L9QnA67+/FqNahfDAB
	 9puZjLKz3xoy7Jn4nRKUELzui6VgXVpeuLgM+vcsR88ND3i+tLMGGRuBI2XxCjpjEV
	 lNZ7OCD0gXGpw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v3 0/6] arch, mm/execmem: resolve confusion about
 set_direct_map_valid_noflush()
Date: Thu, 03 Sep 2026 12:28:26 +0300
Message-Id: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43OTQ6CMBAF4KuYrh0pbcOPK+9hXLQwQNUCabHBE
 O4uBRe6MS7f5M2XNxGHVqMjx91ELHrtdNcuge93pGhkWyPocsmEUZbQLE4ARywMGnA4gDfQozU
 OPAUGSmImUimqRFRk+e8tVnpc7fNly+6hrlgMAQwNJR2CsrItmnB605Hf9JWO1o7nod5oN3T2u
 W71cWD/meVjoJDTXAjJZSl4dbqhbfF+6GxNwi7PPijGf1FsoRSNueRpmQnFv6h5nl/7jJ1fTwE
 AAA==
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
X-Stat-Signature: 7qsso718atxag4wpg1ag7tsfhwjbcchn
X-Rspamd-Queue-Id: 1075580002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788427720-812797
X-HE-Meta: U2FsdGVkX19owXEgAuFsjSSYuoXim2V2S81gJaH0yHHE1R8lPXfbMYzQzo1M0ySYIUpcqZSTEiVZy3tQqoxdymnP6VSF4W+CFnYBIuuejKRJnTL8aCRPIHds5EICWSAj6/ZGLFnipHU0atfjnWC1ggVPDH5XCIAIZiz40q4dqjGeN0JKCM4hbMEGF9pUC6tYZ2gdufZxjmeAYPAzklZczh1b1nhuGxl+DH4Tyvx5TGm9Vf59KKf4QSpYAkLrY/mzMImANQu3RaLJ+KqK6cDhSuBSgfovteb+vARPzTfxz/5fFZopwFrqvUlHLltqHjWHlhXpMHTscxz3bRCHAPbjxj/ZQ+Fuuj53RE/cR7Mwlqi4ONxmRhiY7+6COC8bdVAKvLodxnEhy7EpiGQVudx6nX8hl/kPwMIBQhUKdh3GMPTvbPAze+807q/mZh9CDkiqVjjSZz+Y8W62h8HUoVy0HbUj2owJhNv3xZeU3Jw877TeCS2eJY+nJl0ijfnTNlOMrvFGtENobUnMzOA+iTgniqO/r4uIvUdL3Op3E7+EcvVEZjllpmJk3Gwu9U+Ckk3CNGKwBLNjaGowyEWrckFygJwMADiVhs21nzo/XjItR96SN73OJ9GXEmJFsGNiz/JUukzAUZLSgxk59W3bbJHtxoMOrdP8kxyUwVV2vLljuGoceqiJGVRm4iqp7qeXBk+DrPDXlY1RfsKBfDWMlkTC3/lO9cNVp4UIPg2ddG2xS+MTjDV7qyg3WktvF6UOrECHZtxZQJiw0qr/RcrRsasphXOG0ATuLs23rGhHDn9cnOyJ3xWLCUlIwnt9qlKR9Vx6jLxfNvY92OusG8twxLr+CTpg87sJb0XD5GGOQyCt/a3p9POMEcjNuVhhLuPfpsiE1n15CIGdY47JRh4oVMAQOkyJ/4koXmPs+Z4eEos3el/fF+ikgM7sMHRx0xDQfJXCEojPu03mMr4kxuo/9ki
 v4nJFTRJ
 RTqHlcPG9v/qB4lnJh2SOV0lnhHJbrQojuIuwjryNLn4hVzOvHQ8tC5xaFTZxqi2l3Fm8Abjy3xD4B/v/oNf2I//ThXYXuZqidz/aYKBkv4LKfcpGKfF+bHzyBBZhPp+OnYP6WR5Duz3WV5Dw4FGw0iOi/X1/MiuMdFC2Y8MVBk+iXPzPekzoDfYs06MIY33VALkgSCQnCN2SmZIrwLJmG+KOXqDwPpjlsnn8i6n/5ulN1dC2k2H0j1XFXPjzjC/4ifQcDu8JUWbBz8laFkEQN48F4OyZf0bbWUhfxZzJhTUffq9NAoQF4RgWaixnOCYGIbeqRVXnqxIP09vVOqoFBpc6k1aLe9DWv9yxWkZVopDV2eRi3pVkG9bswxE2GtJ/P4mRMdtAlJV/1aSXvM2D3QnNDw==
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

Implement these adjustments, make execmem always use VM_FLUSH_RESET_PERMS
and revert set_direct_map_valid_noflush() changes.

This applies on the current mm-unstable with v2 reverted, the base-commit
b4 lists is bogus.

[1] https://lore.kernel.org/all/20260611130144.1385343-4-abarnas@google.com

---
This version does not address sashiko comments about the preexiting
issues, it only changes how VM_FLUSH_RESET_PERMS is set for ROX cache
areas. 

The fixes for pre-exising issues sashiko found are coming soon :)

v3 changes:
* set VM_FLUSH_RESET_PERMS to allocated area just before flipping the
  permissions rather than at allocation time

v2: https://lore.kernel.org/all/20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org
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

 arch/arm64/include/asm/set_memory.h     |  5 ++---
 arch/arm64/mm/pageattr.c                | 24 ++++----------------
 arch/loongarch/include/asm/set_memory.h |  5 ++---
 arch/loongarch/mm/pageattr.c            | 27 ++++------------------
 arch/riscv/include/asm/set_memory.h     |  5 ++---
 arch/riscv/mm/pageattr.c                | 23 ++++---------------
 arch/s390/include/asm/set_memory.h      |  5 ++---
 arch/s390/mm/pageattr.c                 | 20 ++++-------------
 arch/x86/include/asm/set_memory.h       |  5 ++---
 arch/x86/mm/pat/set_memory.c            | 16 ++++---------
 include/linux/set_memory.h              | 12 ++++------
 kernel/power/snapshot.c                 |  4 ++--
 mm/execmem.c                            | 40 ++++++---------------------------
 mm/secretmem.c                          |  6 ++---
 mm/vmalloc.c                            | 26 +++++++++++----------
 mm/vmalloc.h                            |  2 +-
 16 files changed, 61 insertions(+), 164 deletions(-)
---
base-commit: d7bc5ce72091180aef05d001dc05c90f6b14c18d
change-id: 20260816-execmem-set-vm-perms-v0-2-bae847a4f64f

--
Sincerely yours,
Mike.


