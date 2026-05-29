Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473F8CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45D36B00B6; Fri, 29 May 2026 11:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB476B00B7; Fri, 29 May 2026 11:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4BE6B00B8; Fri, 29 May 2026 11:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78CE66B00B6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 479E1401B9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:21 +0000 (UTC)
X-FDA: 84820773282.27.519C1B2
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 140E340007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vzd4Z0Gv;
	spf=pass (imf04.hostedemail.com: domain of 3eKoZaggKCIsp6sq+vx8v33v0t.r310x29C-11zAprz.36v@flex--ardb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3eKoZaggKCIsp6sq+vx8v33v0t.r310x29C-11zAprz.36v@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HpQ+gbfLV3ep0KH+7DICYy7iPk4t74I7YHv+Lp6qVhM=;
	b=A7y6prikIa44ZccC8N2NZf+3GVXIZVG/pjERNY8T/j2V1U2Bt8oGNcfxyaoxJ8XHqvZJT2
	t3JS6kCoYmRylYGxrFVopMotlvFfWvBextB6rm+R76tvAvgCvCDGcERnYX20besm+x/Xjv
	VlvOGz4ra52MUl8+Uy5fdTdzFBPvytQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vzd4Z0Gv;
	spf=pass (imf04.hostedemail.com: domain of 3eKoZaggKCIsp6sq+vx8v33v0t.r310x29C-11zAprz.36v@flex--ardb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3eKoZaggKCIsp6sq+vx8v33v0t.r310x29C-11zAprz.36v@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066939; a=rsa-sha256;
	cv=none;
	b=z6gU9LAI3eFWCc8oNmbkZIdJLZWEFAbmWdnTpRtedoTMm40OZBmE3zCAinqV4Dql78csuI
	/bmOnDd3qW0OW/J1vuwJC7ylQvm3vBDPAI7dupigexQz5sgEsXOYZ28cwt2yXNMO+QayYS
	YBaDe0jYKhJcm//bNWjcYLXHxZsm+v8=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bd9a6aae530so1062121566b.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066937; x=1780671737; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HpQ+gbfLV3ep0KH+7DICYy7iPk4t74I7YHv+Lp6qVhM=;
        b=Vzd4Z0Gv2nREXHpNr5qgN3s1xCvb11j2x6/N5dg8OVNYS/y/pQSiketNtj7WYe4pqG
         hNg2HC+rYvk/yiFr5DZv02N5zDBG6m60wO7RWscigIxMS+6PgWjMu0S72PUfhXw1eJ9E
         9ZE+Y1mNeUwek3BRxJ9xqqJmufDnouMsv8TKp8LEbMp88W6QUwg2NLX2IdyBUNHplHAu
         kQ6ZW8CV9Z57dsDyXk18va3nM5umMWnQEsNPWk9V9tnqodIaHrpt6OITMy8Z6ejKzHhO
         XGrscINUE25LA8w17fZEhgFYNzdgpnnkPCgYwQLHlRFFcSYkezW7/2Vr5CO99G4Hkg9J
         Szrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066937; x=1780671737;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HpQ+gbfLV3ep0KH+7DICYy7iPk4t74I7YHv+Lp6qVhM=;
        b=rhVpNCB8pQAYGDAghNWK/2HxXR9+nBqDXeDJQJAu7LoEA0IY63y+9Rg8phTgSC04Bh
         dhrBQWEsZ77WxU2LkCD83LCfiTcApA8AR2UCPDkF/0//atGP1POt5GjSAMcDYkO96gYr
         jHvItcfv6t5LEpiQzfSHKMjMIpt6cI6EFUTNiOk6egP69hFnHZKcvVKOTADN3hV7U91/
         VPeUIJ0yH+0jTp+la3yVSZWhGem6tulBorSq8J1VvigmVe/7yPvfpCdzYeuOqIPNz0Bq
         1J7mgEq9tRumsf64M0lnzrJkQLPzk5BvmBVzB1wg+HJ6E98JvR7JsjnE30jaabAryy4+
         15GA==
X-Forwarded-Encrypted: i=1; AFNElJ+yBouSo5HIN8dJlOHRvKhKjFXhCxFEUmpc3UEeXuAEHlTElgfmkDX+2k5hxa5IuXngqz7kyw3T2g==@kvack.org
X-Gm-Message-State: AOJu0Yzjtk+zrXq5xd9NzhIN+l2NbUZf+1fThXXOdQPY29wAz2NMtITS
	144Ld+qPDQcEfUinXlW+45hCec4CVKL+F6i/44jSbPXTNSul99nyEBl9b57yHpCYUIhCO5lkJg=
	=
X-Received: from wrub1.prod.google.com ([2002:a5d:4d81:0:b0:43d:77d4:5f14])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:7945:b0:bce:a1fc:6877
 with SMTP id a640c23a62f3a-be9cad0b276mr172778166b.24.1780066936607; Fri, 29
 May 2026 08:02:16 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:51 +0200
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6016; i=ardb@kernel.org;
 h=from:subject; bh=1J4/eBxWUzNbzISy66s5wYlPFITBFouUFXFgBmOizGU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVbx/uurJFp+7lxfraxzxO+j8qpt7ylXD8r3Oblc1D
 1q97K/sKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABOZzcnwPzZyX86SrtObDbx+
 z714VZhZY8c1Kb2LJRHXPl3UVlXMUGL4X+DuW1oyQ1zWb99Z/cx301JrXATZI7vYmbc++evbL/u BEwA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-17-ardb+git@google.com>
Subject: [PATCH v7 00/15] arm64: Unmap linear alias of kernel data/bss
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: oduffynrrctur7zpmw6ir58ym5ha4g8a
X-Rspam-User: 
X-Rspamd-Queue-Id: 140E340007
X-HE-Tag: 1780066938-906421
X-HE-Meta: U2FsdGVkX19MAdjdbndq3ADklZFe0Dc7gC4vBFfUNfb3o6qQYYB6ZWiqyydbnSFZtUx/HO+A4gP/8uJqsj6rpv9UwF+DRgDns1cyOBLOimxsWK4Yc5q3hkguCKkCnnhxYZh3UxEjf26TRV+Vd6M3kA1DuH/YR99OqUFSlnQyE/Or4gReNhtAm218E+lWjBehYBweOe4ZUbGudsMDhfq7xUvT/rv04Odaw4lc3/3boshCvbbjvjZzTya88ud14+NkKVUiZ86vTASlNPUfD8kw9x5wRSLRNUSeBP9/DC9w6JV/yviNi5ikR+MPLFoz90DXnsRSt+9ZZqRQbgaqOgPkVoSbkZ6nGCg2CpnWYRnMG7pwmQWCPfgLpwKjsbYTGgp0OnnoMOiBxyNAA/B7Jhecfamp67rjy7YvQ2bgLcyNFNzYlMz2j4jQGp31VwYyxbgjAqid7FIAy99LjFX75+FQEajo58DoBG0vx4arVHpQQj8Vq0Sy6pKugkhv08lwvBWpuXxzqps40Qkh0U5DIyQGlZjtQ2BzZbCl0Qwl0XUFIHwoL7NY4T8wnmp68fFaDLh0lMS+nBeeb7/8DGGNzx2ndEeyMGn3Sb6wP3Jq1wKcE7aM/5Flp1CgQVwweI9LE6EckpsYjQ0l8nETzWUTfPBnfv1cfkW1iCHb5GE1AfAohqnnzoDXE17L73+Gw3uBGcHDHDIPKouNc++yOB+erk9/kVUD7Dl+r8gcmKy+KeBzbmbjyH1UPP1bKhLrBk6gijrRPsPfKNYwQxqp8rqt/jFUcoHlZnfR8XSkzrpoT9d8Sq5BjoJBGJEjxjxjpi2eBd7zKWtPD2BJNST6L7TBRXvFrs/Ro7MgctNR2iy2XZC+6DPIdHujL3DldGjnvcqpNK1LF0q9b05mPB6Oyhb6uULW2dOwgTu0tJhcVHSodJCky/wSgXCJjwLgK3KgEIu7jcsIGs5p7OycyeNZlRGYdlT
 5c3NRzoZ
 9RmigYvBrMiEHquuOFULGNrcCoESg6fPCHgecLRMtWQuVHjj9yAoeSbbyx2YF3dtInskBtogZbX1K2dPtpupmYD9V615VDvV5Apg7qrH99HIadWu8XSuL0sLEkYjWUCZwlFY8kBcYldQZqtToEeIEhtZBlFBZTyFp4IpnBcUqyiI7jR+htyNI6gfqoO1bTIGs53R1pIv8l/NXRN5+HHVB+n8yAQhiRbudwyMG1FkUqupToY81XepimtpqKDYwLYwKYdC8TqEfG7CD6CnefTa9mjLfRxF1jtOcVN1wKa3iofSMQGcAis/hOkFNXEa0h1mcd6vZBm5JM72gLt7ODqPEkEmrxG0b4UiUSWZhGk29r2xsxcp8nx4sl/c5K2RIBEh7fXVpk/ahSo68IHyZYU8llmhTmMSezh+NrPyz/qpH0nuA1T9UI6nlPiwn7Mx/sxG2Dp2b7DJLt/7jbcoBFRGNy42KH54RUXyWzYTeiNiuMzB5hSCwYiTUeGz5YOL7tFyW9d6mfaGeGvI1PkWLlI7HqnY9mnY36Ba9zAuE7TT1oeZzvMp2sRve5Wpckal5V8+dWM5kAibpbN9T/POJ5dxG7R+gjljHI3hOd+4UV0DqqpwiHFUNGcWuq/0lgDHgDMmi9LOLUR4Vhr5oY9tvPPEb6m3Jje1LsI5aI7C7/m6CboyTA7Yt+5BePknq2pgZ9azXx5nQ+aJ6OTaFfJ6DwBLUP01P2yZSghlbQtA8T/nshTZd/Zyss4mmL1+WCepZ4dnr8i+GonTcF8/CMBQq2Hs0h5HtrGxdlAwF5CcUlTshNJoC0QeAqo0PQhY9w8fnVPhuoI36IWgsD0USFO1WwnED5hqpV7FULqxTuVU/zfwFoDthKOZdOQwBF+cg1jz/JzwmcFFN
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

Changes since v6:
- Improve commits logs and comments
- Add acks from Kevin
- Reorder patches so remapping data/bss R/O occurs after moving the zero
  page into .rodata
- Drop zero page cache flush from SuperH rather than casting away the
  constness
- Map kfence pool with NO_EXEC_MAPPINGS

Note that Sashiko had some comments on patch 15/15 [1] but none of those
seem accurate. (I have tested both suspend/resume and hibernate under
QEMU and both work as expected)

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
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
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
[1] https://sashiko.dev/#/patchset/20260526175846.2694125-17-ardb%2Bgit%40google.com

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
  powerpc/code-patching: Avoid r/w mapping of the zero page
  sh: Drop cache flush of the zero page at boot
  mm: Make empty_zero_page[] const
  arm64: mm: Map the kernel data/bss read-only in the linear map
  arm64: mm: Unmap kernel data/bss entirely from the linear map

 arch/arm64/include/asm/mmu.h     |   2 +
 arch/arm64/include/asm/pgtable.h |   4 +
 arch/arm64/kernel/vmlinux.lds.S  |   8 +-
 arch/arm64/mm/fixmap.c           |   6 +-
 arch/arm64/mm/kasan_init.c       |   2 +-
 arch/arm64/mm/mmu.c              | 164 ++++++++++++--------
 arch/powerpc/lib/code-patching.c |  52 +------
 arch/sh/mm/init.c                |   3 -
 include/linux/pgtable.h          |   2 +-
 mm/mm_init.c                     |   2 +-
 10 files changed, 121 insertions(+), 124 deletions(-)


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.54.0.823.g6e5bcc1fc9-goog


