Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6E4C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53D86B0093; Tue, 14 Jul 2026 10:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BFF6B0099; Tue, 14 Jul 2026 10:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A3B6B009E; Tue, 14 Jul 2026 10:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 538276B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:05:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7F808037E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:13 +0000 (UTC)
X-FDA: 84987554106.24.BF9A7AA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5FA77140017
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=q0uPHDqZ;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=02jrDYAZdOm0x4gD33hZs72qTqmO5I6oYk7pbPGMrYk=;
	b=LuTEt330PXv1jyaP8EB7GxTCvYwTk2BeZdQjqnO4sEd0y+QVRGBvI7WoSJUBBuV7SzLckK
	xWhYvf6yMNMZRIRepjhrSIE7qL0NOI3j+YpJk8ULLb3RwsYsBRHXO7cZOOl99tt2DRsWa9
	pMxpFTUL7h0iZBIjX0uBHWls0EzLbpc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=q0uPHDqZ;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037911;
	b=sH1VuNNKaDWAPtOH75wN77qR8+ynxH6glMkIryYejfSblW/rY+LHXEk8h0h0HkhMieGF3u
	e+u33/+8VANKLbg09b5uFYEGzK4rDXzzgEoNSCzzDmd7y0YDt1mPwSW5NL01S2Z7ZNyqdc
	dgmWFL5VtcMi/2UYxmNJsK1JLY6N5rY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9D7014BF;
	Tue, 14 Jul 2026 07:05:05 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF48D3F7B4;
	Tue, 14 Jul 2026 07:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037910; bh=A/Cn1c0AUAxtIAEn7ITqmFX1U6YhbwtQKf8EALtGcTQ=;
	h=From:Subject:Date:To:Cc:From;
	b=q0uPHDqZrNcDoonE/5KEkThGmJi09sfIXmUdhFBxpveC/cpL7yx8Jott7XrZ2lhje
	 e3zq2fD140qS9/mddw0buhsqQit6UnbeHYwPVILFolYeJg7W+WcAFxb0QUh3KvUkpE
	 vvUtFIfbxaDwNCdjaJpHxmlQAz62XDBUdnDULHmI=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: [PATCH 00/22] Simplify special kernel page table handling
Date: Tue, 14 Jul 2026 15:03:49 +0100
Message-Id: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMZBVmoC/yXMQQqDMBBG4avIrBswCYjtVUoRk/zaKa2RSZSCe
 PdGu/wW722UIIxEt2ojwcqJ41SgLxX5Zz+NUByKydSmqRutleATV3TzmHv3RudDjqKs08ZebTu
 0PlBJZ8HA33N7f/ydFveCz8eL9v0H0rm4l3gAAAA=
X-Change-ID: 20260611-remove_pgtable_cdtor-3b123938f8cd
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=9809;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=A/Cn1c0AUAxtIAEn7ITqmFX1U6YhbwtQKf8EALtGcTQ=;
 b=AY0DlHdPwwjQV1l4USYCeEzunc/KTYleiR8EgZMSmkc47b7jgYZ3T4zlZbvB5FH/jEd5MkJpl
 EriXIo84rM0BlBNiSQgcgZjpWISK7Nh4jh7sMRR/V01Ieun4LI1lR9Q
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FA77140017
X-Stat-Signature: 96hbxbtdjdhsus8pwgxsjfzp4g4xic6u
X-HE-Tag: 1784037911-673269
X-HE-Meta: U2FsdGVkX1/I66Mft1LhcLL4Um6QULSiXlFNxgbbBjOOgbM+C2tx8besOwhdc3dm1RhVydBxwDZePgZsTiRrV4mrBzV6UpBAcCrDHIZ4Ik8spfiyv0at5cYsOemuGZxtMcYkVOvqUfD6Nq58Iw0bQ0Vrc5sV8/153/Ia281G0XweRqX/qGM4BaVlNwj5c3XuegwJr7YtwhKgRs+kso7IhUC74PRpvsdUpf2Lh7Oz2O7YTOeMNLOHR3Ur3GSY5ngYyHacHAQnIIgB5Y/VtLo7Xmss93fFzWAvV5eM3chr5WY69CvL4shrUkx2fqMaC+R2W+9oMLGMqCiiK32tCBFyJ637T+3IRqQmdrl+af9vFJ82oqRjkzfkkirsCSSIGplJlS885T1OTupN2jYsaAPL1pQcp+yl9MyElhKYWjhx6CykzrYoit8O9DjPSGfuWp4ArfM1UNLvPpBe1pKFER3tkrIUg6hDjVN2dljkP2mQKh9dKvwVNj5+pBYu5IOWQtZBV+dyZqcIxYwaMVhIFl7Q/pkSnHn047Cbd3d8mNCXOHqyoIec+X/v/6p8RBf3CDmp3BAt61tDj60e/LtW4PD7nNTKo9HspdC4B4ZO4QpU5XTZlJWGPnhuNl3RzWMY38SwL7RKFXzkRE6fXu4eHjBIZhs4H8k9+DYxXTi5ydYOSxRxZRrN408O/PWEgUk67/jugr3z8UGzN6cpF4JFod2GHS5pzi9hSuutHrkKAbHYOaFgoCBhsoLjPZos6PLlALv2fzSHzPIi5AApZkVXzrKo4wQKVu4NMqMfClZLG+VinWWuHSY96n8o7RKzPOGeCa/8PVRPPoTXHWfrVXN7uwVrLR9+kYQszJmTGsNbZ+eyde7DzxQzk+pHo8ZAnZbI36ACCTjA0EYCOUuYU76VutBy0ph5EydwRFBbBgECARFhA5X3r+IkxzrVkT7P0AvIRiCq2AwXEGQ4/lLX+8B9RCT
 h78bHL4b
 p1PUw5X6Zx66jbre11Oj43O3bC8LI0WKeXHReFmBU2uMxNMKa/q6fZmhqc3ZDGzfZi8aG+UGVDtFRDA7GabyLs6agb6FRbZaSM5gin9cT7r6r/0U/omKn2UTNKv3HSSw7luXmBvJ4WxdFlZteYOAA/UXMKw2+4vdXmifwixyozc7tfGafDYscf3vv4wLcm22ivHWR7IItETluYx0mLnvNEJkpN6ibJZkw3g8xfmNAxLD+Wf1CjQntKetNPPOJSCMw4ws6zYjXEn8H5Xeq7t04vuk0ieBvDFRDhYhoeKD2+hDmsLM6+jFtPVVf2V9Y+i9weUfff9ehz6Dcfny3qSgmQjvNJ/Y8915uOQ0JA/qTGwHVyUaOaqaaf4kuXjiA0b277Wr/rxj4lc6AZBWrXNP3aDG3tQu+BxNx0Kyd27D8eqAVkNI1C9V5W6tWEl6i59FZJGv7u0QlOMnHK8YIO3ijTdA7jcaz6mUtoiCasayfnNilfS0FKIsoZ6garzgr4sYqLE0N0vWBCzlI4OC3a+W24fLHpDRpsgQnrODePhu2EVLdgIAkXjbwS6Rg26BeH8sQo1QchQdI9+Zz1WL9fAbjSLn65jwGdFq+HC0hOJ5MOnFPqEtoupOngrix2fWt8tVJxTuRKrdFGdZ7FS1tU1WKmXEaXWRAAZfIp+wCK7BQQid9+d9D2DZ2n+p1q7isoleEILYqddHau7c6c1ciUCxLQTHDc/NlBJmrj7klND2Jrn36gUc5vZQyk+W/4tcnNes3s5H5u1tcmZtSer5D20jKXUwTYMphm4iMh2W4ic0DMCFEAJS4qjqv3Dgd+6IG1G8atohCpSpPSW3mr0o5/4reLREJ1Y43mA7TnlAPDyLszlB/ilBZGHvpaRSpc9Zl2nfRR1/TJvKq5l+7lg/r6XPn59q3hOK3UDbaeU91SkBf+1E0WdCjbafRmjibeexkXIFkPGqtlM4PEsMUVyxKsL3yZNRJMVE9
 QxhjxDo7
 3eeJxicG2NC0YgIJM2TYN3iHuWtnSFYHW9LPutaq243AhJfwSTCvPYbZuOtpId/hpDGbMIyjVkGfuGwf/Ky/agEPiVDYYk7CX1/I0U3VQgA+w9ArsjM0T7S5xW3MjxhGY3JSy1NJlgg05dOF+3IC7RI7ihYZHs3oGzvoTKBrw9JgPCciqydLoa0nfH+Qn7FZgPy3jQyAUd9THEDDAf9twV6e6EhPFBfWGUpQryciCPD+JsQytWvG0KaiyfVIML83vZK2wq/Yw8Ljp5SOtB60f+e9ygbMt06YuI0Jm1KllrgH8DGe+WjCAUG8qFg4caRJVyF8XC/A6adddl0qBHKMt4+maZaM+SKpuOCyh3bzHSaSLSOLGGoJS4V3qNEwaAaIEHCO3YeY8cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page table constructors and destructors were originally introduced
specifically for user PTE pages. Over time, their use became more
widespread, and starting from v6.16 they are called at all levels
and for both user and kernel page tables [1]. Or so I thought. Turns
out, we still have various special kernel page tables where the
ctor/dtor are not called; vmemmap page tables is one such case.

Looking closer, we do not actually need per-level ctors for kernel
page tables. In fact we do not need ctors for them at all, because
nothing is specific to kernel page tables in the ctor/dtor and
nowadays they should be allocated with pagetable_alloc().

Here's the plan: all the generic page table handling moves to
pagetable_{alloc,free}(). Whatever is left is specific to user page
tables; the ctor/dtor are only called for user page tables at the
required levels (PTE/PMD), and renamed to make that clear.

Doing this will allow us to remove a good amount of special casing,
but there's quite a bit of churn to get there. Here's what this
series does:

1. Introduce the concept of "kernel mm" and replace most comparisons
   with &init_mm with a flag check (patch 1-12); no functional change
   so far.

2. Move the page table accounting/type setting to pagetable_{alloc,free}
   (patch 13-15). Kernel mm's do not need to call the ctor/dtor any
   more.

3. Mark special mm's (efi_mm, tboot_mm on x86) as kernel mm's (patch
   16-19). They now abide by the same rules as init_mm, which means
   in particular that split page table locks are no longer used.

4. Remove the ctor/dtor calls (now no-ops) for special kernel page
   tables on arm/arm64/riscv (patch 20-22).

[1] https://lore.kernel.org/all/20250408095222.860601-1-kevin.brodsky@arm.com/

---
I stopped there for part 1 to keep it digestible. Part 2 will then
ensure that the ctor/dtor are only called for user PTE/PMD pages and
rename them accordingly. This is comparatively simpler but also
involves a lot of churn.

This series was suggested in reaction to [2]; removing dtor calls
entirely for kernel page tables systematically solves such issues.

Worth noting that some comparisons against &init_mm have been left
untouched, as they are truly specific to init_mm. Reviewers are
encouraged to take a look at the remaining cases:

  $ git grep -nE '([=!]= *&init_mm|&init_mm *[=!]=)'
  Documentation/mm/active_mm.rst:78:      if (current->mm == &init_mm)
  Documentation/translations/zh_CN/mm/active_mm.rst:76:   if (current->mm == &init_mm)
  arch/arm/include/asm/mmu_context.h:144: if (mm != &init_mm)
  arch/arm64/include/asm/mmu_context.h:100:       if (mm != &init_mm && !system_uses_ttbr0_pan())
  arch/arm64/include/asm/mmu_context.h:210:       if (mm == &init_mm)
  arch/arm64/include/asm/mmu_context.h:242:       if (next == &init_mm) {
  arch/arm64/mm/fault.c:121:      if (mm == &init_mm)
  arch/arm64/mm/fault.c:139:              if (mm == &init_mm) {
  arch/arm64/mm/fault.c:154:               mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
  arch/arm64/mm/mmu.c:997:        BUG_ON(mm == &init_mm);
  arch/powerpc/xmon/xmon.c:3314:  if (mm == &init_mm)
  arch/riscv/mm/fault.c:42:                mm == &init_mm ? (u64)__pa_symbol(mm->pgd) : virt_to_phys(mm->pgd));
  kernel/cpu.c:917:       WARN_ON(mm != &init_mm);
  kernel/fork.c:725:      BUG_ON(mm == &init_mm);
  kernel/sched/core.c:8390:       if (mm != &init_mm) {
  mm/ptdump.c:182:        if (mm != &init_mm)
  mm/ptdump.c:191:        if (mm != &init_mm)

Testing:

* Built all modified architectures
* arm64
    - mm kselftests (FVP)
    - Hot adding/removing memory + memory-hotplug kselftests (QEMU)
    - Reading /sys/kernel/debug/{efi,kernel}_page_tables
    - Reading from /sys/firmware/efi/efivars/
*riscv
    - memory-hotplug kselftests (QEMU)
* x86
    - mm kselftests (lkvm)
    - tboot page table setup using a fake tboot shared page (QEMU)
    - CONFIG_EFI_PGT_DUMP=y (QEMU)

Patches based on mm-unstable.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

[2] https://lore.kernel.org/all/20260521032730.2104017-1-apopple@nvidia.com/

---

To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>

Cc: Russell King <linux@armlinux.org.uk>

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: loongarch@lists.linux.dev

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org

Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-riscv@lists.infradead.org

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: linux-s390@vger.kernel.org

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: sparclinux@vger.kernel.org

Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ning Sun <ning.sun@intel.com>
Cc: x86@kernel.org
Cc: tboot-devel@lists.sourceforge.net

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org

Cc: Vishal Moola <vishal.moola@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Cc: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org

---
Kevin Brodsky (22):
      mm: drop unused __mm_flags_set_mask_bits_word()
      mm: move mm_flags helpers to mm_types.h
      mm: introduce MMF_KERNEL flag and set it for init_mm
      mm: use mm_is_kernel() in generic page table code
      arm64: mm: use mm_is_kernel() for kernel mm checks
      loongarch: mm: use mm_is_kernel() in switch_mm_irqs_off()
      parisc: mm: use mm_is_kernel() for kernel mm checks
      powerpc: mm: use mm_is_kernel() for kernel mm checks
      s390: mm: use mm_is_kernel() for kernel mm checks
      sparc: mm: use mm_is_kernel() for kernel mm checks
      um: mm: use mm_is_kernel() in TLB sync
      x86/mm: use mm_is_kernel() for kernel mm checks
      mm: account page table pages when allocated
      mm: set page table page type when allocated
      mm: only initialise pt_share_count for user pgtables
      efi: mark efi_mm as a kernel mm
      mm: pagewalk: drop redundant address check for kernel mm walks
      arm64: mm: drop explicit mm_is_efi() check in contpte
      x86/tboot: mark tboot_mm as a kernel mm
      arm64: mm: drop ctor/dtor calls for kernel page tables
      arm: mm: drop ctor call for kernel page tables
      riscv: mm: drop ctor/dtor calls for kernel page tables

 arch/arm/mm/mmu.c                        |  3 +-
 arch/arm64/include/asm/pgalloc.h         | 10 ++--
 arch/arm64/mm/contpte.c                  | 26 ++++------
 arch/arm64/mm/hugetlbpage.c              |  2 +-
 arch/arm64/mm/mmu.c                      | 82 +++++++++-----------------------
 arch/loongarch/include/asm/mmu_context.h |  2 +-
 arch/parisc/include/asm/mmu_context.h    |  2 +-
 arch/parisc/include/asm/pgalloc.h        |  2 +-
 arch/parisc/include/asm/tlbflush.h       |  2 +-
 arch/powerpc/include/asm/pgalloc.h       |  2 +-
 arch/powerpc/mm/book3s64/pgtable.c       |  2 +-
 arch/powerpc/mm/mmu_context.c            |  2 +-
 arch/powerpc/mm/pgtable.c                |  2 +-
 arch/riscv/mm/init.c                     | 63 ++++++------------------
 arch/s390/include/asm/mmu_context.h      |  2 +-
 arch/s390/include/asm/pgtable.h          |  6 +--
 arch/s390/mm/pgalloc.c                   |  4 +-
 arch/sparc/include/asm/mmu_context_64.h  |  2 +-
 arch/sparc/include/asm/pgtable_64.h      |  6 +--
 arch/sparc/mm/init_64.c                  |  2 +-
 arch/sparc/mm/tlb.c                      |  2 +-
 arch/um/kernel/tlb.c                     |  2 +-
 arch/x86/include/asm/tlbflush.h          |  8 ++--
 arch/x86/kernel/tboot.c                  |  4 +-
 arch/x86/mm/pgtable.c                    |  2 +-
 arch/x86/mm/tlb.c                        |  9 ++--
 drivers/firmware/efi/efi.c               |  1 +
 include/asm-generic/pgalloc.h            | 16 +++----
 include/linux/mm.h                       | 69 +++++++--------------------
 include/linux/mm_types.h                 | 52 +++++++++++++++-----
 mm/init-mm.c                             |  1 +
 mm/memory.c                              |  6 +--
 mm/page_table_check.c                    | 14 +++---
 mm/pagewalk.c                            |  7 +--
 34 files changed, 163 insertions(+), 254 deletions(-)
---
base-commit: a531f0cf705af3374388eafe4115f651c625d8db
change-id: 20260611-remove_pgtable_cdtor-3b123938f8cd


