Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A8CCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665226B0005; Tue, 26 May 2026 13:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615C16B008A; Tue, 26 May 2026 13:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504156B008C; Tue, 26 May 2026 13:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 397076B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D02E6C1C2A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:23 +0000 (UTC)
X-FDA: 84810333006.03.2DC26B7
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00D6514000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fq352y3C;
	spf=pass (imf26.hostedemail.com: domain of 3eN8VaggKCOUHYKI+NPaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3eN8VaggKCOUHYKI+NPaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=n0vWMvJYNWuq9BUtLKfBugHf8I5ifX5auG02Ilaszzw=;
	b=H+HEbIGbZWfSSKc3NWlufPywOoKQtViDs35xYsqb9jP4pM+nxCjrrO2gWSeTSy/pil5E98
	/wREPNxaU9Rg5ZEDymDA2LZQZYgoo7IMyF/ZoJszf/guX99Sb47XS52rNhMMfm2m7O8nc0
	69eVvpRAfvcTklrvgzMHmpN6YsSLM4A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fq352y3C;
	spf=pass (imf26.hostedemail.com: domain of 3eN8VaggKCOUHYKI+NPaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3eN8VaggKCOUHYKI+NPaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818362; a=rsa-sha256;
	cv=none;
	b=puokY2h+kBk0Plu91R4+RfTTfOobaFNSLjaWWUwUxGLwJTt8hQjf6AqGrieXrbgvNKT1mK
	jHKHjXb0exIHtNoWvdJX18X31NHAU8BK6PlA4tkX/Dbqu6Syn33qC3BEf6X6TZKTh/rD3S
	oOylvoFXLGWhvWmm75IPYCXHTrZRQwk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49047e22ed4so35614245e9.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818360; x=1780423160; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n0vWMvJYNWuq9BUtLKfBugHf8I5ifX5auG02Ilaszzw=;
        b=Fq352y3CAwFp6RasODLV5vIqQYynir8rhlk/xvOcfJTRRbSc2ZYI/R7bs9PtYPF5s8
         OJQK/NPEoUxKTBMZHduxq5HGgaxCAgRYNgIOEYsxakkKka1P7RIxwI8UZcClnYZev+G8
         UJbhSdCzykorAUsfHvMgYOafeJ/LMevp0W1Dzv6oFnIhAfrEt02YJDmf0lfDzD6svE73
         tADgFPsiQeZwzXPbNozUhDG0sfhqx05nuxjmgWuJLnkyWUnIK599OeQvq8rbJ3wgYfdc
         x/t6HLjgdSuzJ+3B+eisuZEQLc873B/GP1p4ACbnxhktPrm39QCaWn1oWZM8sx5etH06
         +0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818360; x=1780423160;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n0vWMvJYNWuq9BUtLKfBugHf8I5ifX5auG02Ilaszzw=;
        b=qAtSLomTDXRYvAvqRTIeMO+AMVCx6ZfCB9klz6Bj1MzljYIwgiqUr5qRmWjmLVuPJZ
         6YLngleCunh74Fxvw2Xkv8vWLh1DaOSjyO9C1vVrjsxX47rkY6NoTd8AqlXxhTdwRsfj
         +pjdjtPHPJ3if1efHOLkwXr7uPm9E72+wHaPPR1w7OktqyGa1FhVtbzixhXw3Sv5NUTk
         J1ff5E558VMg8ZWpNzFP3b3iRoHubMhARq2YsqXZ1Y9Sb3IpYAmdUyrtInHSs5RTuz74
         oeVebMGXvGFOmPD2QtkZchEA2Og40+w7I3gQ8H2wbREDtd/v4yy8DLaIaB2BplaTwKz1
         38AA==
X-Forwarded-Encrypted: i=1; AFNElJ81XsxNG0+nu7suL1lMqvOcN0I8AQ6xrESptiYnDgYMKFeohrg2PDQgAWV0gvCMt6wikavN6qVx2w==@kvack.org
X-Gm-Message-State: AOJu0YxsmlYaY41BRTe3q4yDSS0FxkCL0Q/DIMfeeX10KIolKmn+dZ86
	LUi3XGXGnyqp9/u9qgRSpR+gv6YiOFjoejc7g/12spJTSLxcz/5DF1bRsfjyXjRRfb9U3Kowaw=
	=
X-Received: from wmbfj10.prod.google.com ([2002:a05:600c:c8a:b0:489:1f67:5a81])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3581:b0:490:482c:4391
 with SMTP id 5b1f17b1804b1-490482c4586mr347539725e9.23.1779818360071; Tue, 26
 May 2026 10:59:20 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:47 +0200
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5484; i=ardb@kernel.org;
 h=from:subject; bh=U8803ZhDPt8GJ8Atx6VTFHHmARjJ+nX3UDhXHVYH9xo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0frj6sbw7T/xOHgou4E0vMGDKO3VgAmdWo+XnCVG6T
 1oEOto7SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwERU7jL8L1Z3r3IPnBwlZzZh
 j9LEyREPWzJrNh55n6V8I1KW299LiZHhyvMT6w/KRn2cG6r8u+luO6dv1+6fH92Tg3pK51buVHT gBAA=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-17-ardb+git@google.com>
Subject: [PATCH v6 00/15] arm64: Unmap linear alias of kernel data/bss
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00D6514000A
X-Stat-Signature: whsnnan8n4aa7tcgx9pr9ix41jt4un9j
X-HE-Tag: 1779818361-27380
X-HE-Meta: U2FsdGVkX19vz517k+Kl1aMyUjf/vq8fzLNMC+cpRHfIRZAhqztWk9IHg/aOSC16tsmfKGKDydCxumNCJztAVVYdronI5wD/Vvo2MdtQi9ZOFAooVDnbREENBvxJPKxBvK36jKwDSVYOqZy+rM4yxw35qOfDkxd1J+00GfQ/zpZkBTwdH/yFjwEs7mxKkdNADDsuLEM5naqUPrTLQ5SEwoK0IlwjkKzkXD1sXajmkgL5CBvz9TijMlZXKZEODFABEZCGVbfOPgqFugtzgCBLSt6bqTK5/tfd5YDRiW6WFT2V49MXo8A1XIhauvsp3XDensySwnr1f/T4KO4bmLrHxCgmuLYjefLKeyIg04TuSrqms4zOUoQmco3L4tqH35P6QC5ZZf1KxLhxm+AeaMQK5z2bvEPFvyjlob4fBDHbL9dwyk1nyiwelIeD+ZjtFjWjFF5v56FM3vuTeGdmKVjy6mGEneZVxtGsTMRDFXKQwSCFxxO68jws/z8IgPmzKgzxus2NscIB71iGA4i+I3zExbx/3E6duv1u8HD3IpuVLFdKroDQ7QAuO5kZFxfrEQ3HFOBdUbwOS5oyLIzMD2CnfcZY0vy7APCWQcWKR+jZ3xrUzwLQwLmuqhbyeDa93t2F5RmrwpyQpUzs+S/JAgEuUCjvb/qbbn1kNkPeIc3o22A7uan7gLAPnI3u0vwdajoT45XbhsXT5a47hx3gWTCZhJKyG5gVbXo7N5kd1RM2Fms5z104DjM+7pyF5hGWpOZGN7OOOnGo7S3a5qjVyFvE1SZiV1WeXYqmIg4ofE2QGqCjxbLDBOfF8E92Cr6txJxXRDlhkgqJnFDkfg5gbgyIb9q/nXtqyn8Cf5MEL4VW/u5WnvEJH0gENgZ/yGGMNnttlIKghj/keaZ+T6QdkgD8zvd3eKX3XjaoZKSoG7ofFexqBtHADlQ5CZysxINZkd22pqKcpNM7RrZNXQlsa07
 ZP8QFjCk
 nMJ1zDYOWX4wYAhQSseYRUzM29RjSCh6gFBQYjrypQM4HbkVJ+pyjjIW2cIP/IvTMsG2z+MLe75O/sgBOrBikqgp3ykZoOzJW/3gIsS0m8yOy9hw1I3p7T3OC48Sn1ELi/5oEzwQL8mVhOBOt2Tnjqc9h0o5TfyaVl6jtxBMwkRWyMTWreBtnciWNkDk/7Zozaff9fPp0RrdhiZNvWKOHQI/GJotAZlGnxVlfG7agD4oBT4KUZnS/lcJUuaBEapGH7idwdujM+DLOAldQNju/7Oosq0BUXKg/RYT4UW4reyxtp3VJSC9hYxB0bUNXF56Id1gggpFkQk8KDwpq6sNhLE3mT2Y7Ad692GD3YlJxbOsj+hFpgPJjpCfOjvjkUVNqly54CK0b5uN3C6o+nvHDKiyl3TyiVSsqd+c/RyLwiCiEun1bYf0DD9tSNLJgDw0qDsUB+4IZyRb4v8Y/UEJMTabvRRMFMr6Z7ABE6FeHRVRpQHY/fnuc+e6UDJp1Y1JZ7Er+GjTlqilRZHrekGNaC1OKhwws4UPynbRxjBYgw1xFfmr2wYx2Xwr6TGPD0ouFlY7vc3mpnHbDZTQ8DRjgrhcBs1wcK5rj6ASBvPrAOj94qO5AGEs7t8PFKDJFWEip/WCT5JmR2cSD9kvl84k0ZDmQ92rWLLJ4WvX9zgVJ5O9g+k/4L2gPIKztr8Axa+WRhLsH9Z7DOqrQTzmKZtCYsq7HQCCcqKkR71hkKVZblSLsu5LxCLgcsDjJkLjOXaPM0lOJSpCQQ/oH0vuusZRJRGvsXZMTmTlTYjPjxeDOFlniuqSzdrG/7SkdpOyo3pBa7kHs2H3NY3Kbv+bacjQ7xO17GLXM9dSM0HCU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

One of the reasons the lack of randomization of the linear map on arm64
is considered problematic is the fact that bootloaders adhering to the
original arm64 boot protocol (i.e., a substantial fraction of all
Android phones) may place the kernel at the base of DRAM, and therefore
at the base of the non-randomized linear map. This puts a writable alias
of the kernel's data and bss regions at a predictable location, removing
the need for an attacker to guess where KASLR mapped the kernel.

Let's unmap this linear, writable alias entirely, so that knowing the
location of the linear alias does not give write access to the kernel's
data and bss regions.

Changes since v5:
- Reorder series in ascending order of impact, so that the first few can
  be merged earlier if desired. This also makes the patch that remaps
  the data/bss linear alias as tagged redundant, which is therefore
  dropped.
- Add patch #3 to address an existing issue spotted by Sashiko
- Fix thinko in contiguous region check (#5), where the whole region
  needs to be considered and not only the first entry (dropped Rb as
  well) - this addresses the kfence issue Sashiko reported on v5 [0]
- Update commit log on #6 to clarify that changing permission bits on
  PTE_CONT entries is safe as long as PTE_CONT itself does not change
- Likewise, drop hunk that adds the PTE_CONT bit to the 'permitted' mask
  in pgattr_change_is_safe(), as changing it is not safe. (#8)
- Move kasan's additional page table to pgdir BSS as well
- Use (NOLOAD) on the .pgdir.bss section so it does not get emitted into
  vmlinux
- Add powerpc and SuperH patches to deal with empty_zero_page[] being
  made const

Changes since v4:
- Update the correct [early] mapping in patch #1
- Make empty_zero_page[] const instead of __ro_after_init
- Drop patches that remap the fixmap page tables r/o for now
- Don't force page mappings for the data/bss linear alias, as it is no
  longer needed for set_memory_valid()
- Add acks

Changes since v3:
- Drop bogus patch adding hierarchical PXN to the fixmap mapping, which
  breaks the KPTI trampoline (thanks to Sashiko)
- Add generic patch to move the empty_zero_page to __ro_after_init, as
  it now lives in generic code.
- Add patches to remap the linear aliases of the fixmap page tables
  read-only too - these live at an a priori known offset in the linear
  map if physical KASLR was omitted, and control a priori known
  addresses in the virtual kernel space.
- Rebase onto v7.1-rc1

Changes since v2:
- Keep bm_pte[] in the region that is remapped r/o or unmapped, as it is
  only manipulated via its kernel alias
- Drop check that prohibits any manipulation of descriptors with the
  CONT bit set
- Add Ryan's ack to a couple of patches
- Rebase onto v7.0-rc4

Changes since v1:
- Put zero page patch at the start of the series
- Tweak __map_memblock() API to respect existing table and contiguous
  mappings, so that the logic to map the kernel alias can be simplified
- Stop abusing the MEMBLOCK_NOMAP flag to initially omit the kernel
  linear alias from the linear map
- Some additional cleanup patches
- Use proper API [set_memory_valid()] to (un)map the linear alias of
  data/bss.

Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc; Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liz Prucka <lizprucka@google.com>
Cc: Seth Jenkins <sethjenkins@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: linux-mm@kvack.org
Cc: linux-hardening@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-sh@vger.kernel.org

[0] https://sashiko.dev/#/patchset/20260519151616.2557018-15-ardb%2Bgit%40google.com

Ard Biesheuvel (15):
  arm64: mm: Remove bogus stop condition from map_mem() loop
  arm64: mm: Drop redundant pgd_t* argument from map_mem()
  arm64: mm: Check for pud_/pmd_set_huge() failures on kernel mappings
  arm64: mm: Preserve existing table mappings when mapping DRAM
  arm64: mm: Preserve non-contiguous descriptors when mapping DRAM
  arm64: mm: Permit contiguous descriptors to be manipulated
  arm64: kfence: Avoid NOMAP tricks when mapping the early pool
  arm64: mm: Permit contiguous attribute for preliminary mappings
  arm64: Move fixmap and kasan page tables to end of kernel image
  arm64: mm: Don't abuse memblock NOMAP to check for overlaps
  arm64: mm: Map the kernel data/bss read-only in the linear map
  powerpc/code-patching: Avoid r/w mapping of the zero page
  sh: cast away constness from the zero page when flushing it from the
    cache
  mm: Make empty_zero_page[] const
  arm64: mm: Unmap kernel data/bss entirely from the linear map

 arch/arm64/include/asm/mmu.h     |   2 +
 arch/arm64/include/asm/pgtable.h |   4 +
 arch/arm64/kernel/vmlinux.lds.S  |   8 +-
 arch/arm64/mm/fixmap.c           |   6 +-
 arch/arm64/mm/kasan_init.c       |   2 +-
 arch/arm64/mm/mmu.c              | 153 ++++++++++++--------
 arch/powerpc/lib/code-patching.c |  52 +------
 arch/sh/mm/init.c                |   2 +-
 include/linux/pgtable.h          |   2 +-
 mm/mm_init.c                     |   2 +-
 10 files changed, 111 insertions(+), 122 deletions(-)


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.54.0.794.g4f17f83d09-goog


