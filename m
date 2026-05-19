Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84872CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29ED6B008A; Tue, 19 May 2026 11:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAD46B008C; Tue, 19 May 2026 11:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC93B6B0096; Tue, 19 May 2026 11:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97EBF6B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4AAF516105B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:19 +0000 (UTC)
X-FDA: 84784525518.04.CE47327
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6A1A514000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QCZyrw4w;
	spf=pass (imf26.hostedemail.com: domain of 3N38MaggKCL4evhf+kmxksskpi.gsqpmry1-qqozego.svk@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3N38MaggKCL4evhf+kmxksskpi.gsqpmry1-qqozego.svk@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2Ph0PYjrVkzoxIOEpCFOVz5Nww7QyWvmwqNXMq1WP4E=;
	b=L71FNmIDnJn6ZxDQd/+4SB7IiYL9Jx5wlFE20DPhAVnZvQiB8Z5CETI/9pF8+rb4NkO0lL
	wjj+rW/vCnzYcyopRR/XP6h6r5fFDCiiBXzFyYbPUHWY0Oc7/4PVvQllwHXU/04FamE5hh
	H08pfYDJgFZJz0kwbLHu3tOeRRvq4qM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203897; a=rsa-sha256;
	cv=none;
	b=k8w9erZj97NX6jfWaGwY8/U5RuI+uqxa3azz+L7QmiYGWaZLtiENcXuG4uYczZ1LVjLM53
	KSOCjWia9U2jHgBnb8hBM837bWVx24ipHNhhDcfliPX8wx2iCdE7Ke8TA8xPTOxcYe0/BU
	2siZfLMY2mALIzVxHINZUELFVmVzGmQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QCZyrw4w;
	spf=pass (imf26.hostedemail.com: domain of 3N38MaggKCL4evhf+kmxksskpi.gsqpmry1-qqozego.svk@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3N38MaggKCL4evhf+kmxksskpi.gsqpmry1-qqozego.svk@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45e55c44ac1so3020610f8f.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203895; x=1779808695; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2Ph0PYjrVkzoxIOEpCFOVz5Nww7QyWvmwqNXMq1WP4E=;
        b=QCZyrw4wjLS2PeIfgU/dAcrrDZECOW2BfP8Aa5pP0s6OIvgJAdqw5CL65SHUZEQ2eo
         TFRDy8X6cKJB/LQ16L0L7yeTZjzyEiHUtXktyskLL+5W8GtUwz3IubVVM2G9tl8BDkpi
         aeUfQkgCcYyoZH7lTo7rns3SkjCssQM35pA6NC3bX4UXh2TiCm+p2Ko+usIsYJjZ4Ds2
         IiFYFwDy4gAqfrxooxeqSPE8BWwfvyyit4PfybSnuL42ZzlqmJt97iw4fDUwA97Fz68T
         39BSUPfWMiBGF+c/Venm+SbaiKiy9WdtR0hToxH4EkaPldJk3zUwClVA817W6DvaV1Nz
         HZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203895; x=1779808695;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Ph0PYjrVkzoxIOEpCFOVz5Nww7QyWvmwqNXMq1WP4E=;
        b=GDd2+5dGVik4ObS+FvdMip6y4+Y0Xk2ysYxFiLrLxqJoSpEmdTGCqVfSh0c7YDQGzm
         leafWLLR+1IE+4oI0rpKjBC82PqfNuVZYOzYx1AWPfitPi6MHqmGFGIzvRF7ngT2AB6J
         agnXEfEBYbZGO9Jtix9V3bmiInsMT18tKJHckji5ElgMaBvaSe9f5/Yt9KiKGAgsnN4S
         ykhu0Zdo6z2M14Csp4wAO5z4EmyMf8L94mOIdnmnyumTAPX7F8B31qOs6td/oExYQLFZ
         Pg76ChaOJHgXgXSqbT54Zn19htndBtOs7L/0rb6fvUS6wuDnNyYFCZ9G3tNZmDifKk7o
         bBKw==
X-Forwarded-Encrypted: i=1; AFNElJ8p08ua6BJjZBhP/ljZUyusw08r2+5CT34cmFHgpXvpvYyIgau344FuiM2aFHkdXzn80h+gz67Dkg==@kvack.org
X-Gm-Message-State: AOJu0YyPjHPtMcFYrnIbdhvrx3phpmgaOLnmYALfFQpkHbaQJG5ltMkZ
	AO13hONdIj2Mtka3AllapQA5qDkH064o8rmqop06IDYGMa16J3zBAjU25Llw9O5IfLdomUUwDw=
	=
X-Received: from wmpj8.prod.google.com ([2002:a05:600c:4888:b0:48e:914f:1eff])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:630a:b0:48f:e249:4094
 with SMTP id 5b1f17b1804b1-48fe632663emr372340605e9.18.1779203895433; Tue, 19
 May 2026 08:18:15 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:17 +0200
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3950; i=ardb@kernel.org;
 h=from:subject; bh=BfiC0GgeYqFLHZMi63jQd6ueIObiG50ZwO7JVw9lq90=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7uCD1LW29zmS5p9gmMnBPcXya+T7hzd9amtaVA8LL
 ppw2OBBRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiIsjwjw5o1DHveb37Ccv1C
 /yufS+tkgkKu5x00Wi/Jqyy4yP04lyIjw3M52VN8QnNmTgnRYP7z+ucK531LSjtfPF1akOSyrz9 xHQcA
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-15-ardb+git@google.com>
Subject: [PATCH v5 00/13] arm64: Unmap linear alias of kernel data/bss
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A1A514000A
X-Rspam-User: 
X-Stat-Signature: 3zoyq5jehb41794prew5onahsbac1md5
X-HE-Tag: 1779203897-204037
X-HE-Meta: U2FsdGVkX18A3vKuy5xgPLtabtc40pJ8IMadVHJi2bk94KEeNlYIK0Xy7pxd9HVZ2sqaqbTDQWDy8pImQQB6EzcQ0MCgV1aCX2ZwQrjrc9JcfPCLTgJ9xjYZv7iuPk4t70LY+6muT/UFkmVTIlRAgVE/w23yEKSINN4m8ylVXCpqx3NAeM2I0z9z/TOHjsz4ORNJqR0LyqEM25EoJv8NMUcDX32lAHxwQoxIKbZOqsql0VYvQMmpTXHnAK3eF5uIbxYIrgDd46nRE3QeHx9536NmhwAFmP6wgmr1skNL1kBILNTlydAhXcFJBYHy0XH3xzz+nPaEXK0tLlRK/zQvxLhULgbEpoMo8jEpFn7Q+/EGKsnJkNPI+GnNKZYEt2gU1TyZVjmv+QxHhtZm6WHDhlAA3vhSXZNR891dniZpbiq6D/bK4dyZ2t9iMtXbutRVPOMoKxI3TZMJvviXq4vZTG++s755qxkWxA7us51xn2FfHzlJJ353OiVuxEEhBLbqpMiIZDQMTLBi+SQxh9Xsu18nNe++jdrgEdpQDgoup63gTM0sAOzpHPrK4Refdtb0NK2rC1shIWvQ6rSxKeyT62931qoyJiG7yzO2t6IUAodRjndjqjWVnrYLO4hhdWzhsycDEmEYSoXPaeF6oGD2s3mPbdQ+yuZU4/vrVHSnHJ86HwmO5xoPzhBYWw21pP3bkvzmC6HdYgxeY8pnw1S/h6sY02k5emsUOBNgH5Tbk/RciKsJGPFA92TGgHUslKasZ2Y2cpNF5oPLpjPZDX7IMfrzc67CEmL3xpuEaIVGp3KY3ebcOSyl3wXAZh6Gitsn2kt1BpoU8YrY6RjB6OOuqhv/SoEb08r70Qs4vcyxFzaEvk7eINqYYuC2xxHrkS1UGFdr4732j1oBX2QpWTb+e/XvLZCatVzNbPEIRZTjPvVz6Tg1PVI3ukeqpdY2vN/qJYrFD7qTgS0CwJ+xPLn
 W7QWcdMQ
 5o9pVVo+LiVk2m4aZoUn4gTTbW/bFHwpJvbAS+q+QGIyZ/Atb4A+3gkGhINQJGYUefcy0mWPsib+MPpzBHVZnPaDRvhuvNctHK6/dPmSaud9KkLT9LJbmFsLDyMB7+EleaR0UwWZjk6t6tG0AeEJ21QPj/Z1V4z9kmtFfd7geUbvBi5MeLRVUEoIw4JwE1USqvDavGdj0EDHcvKgK8EZeLxyQ8ZYMnG2gmA2DwlfBFz4tT6vchLqJDOdc70cOtJ4rfV4ozFMY+6Bjl8+Wq3g2gywhSZ9NBwt68BlDRj5KM6G/JFxJspaO0JqlPk1aBDtLpnIrFJRY7JbXOgWI+19CMNwLHaIg4YiHT+IX33y+D4IzatQJXFguiOjIxA+h7Jq3SM5KALvl7UFQSX7sBA+ZmKe42Oa5gA9ngZ9LW5OeYLyrz9EPC4+DDx021mlTVVFqYa8FEl529rgwbU4dAjrzuk/frbEAfs2UAMh+46Kce4cRKNJUqBP/I/WGznsqj7woilePnnx88lg725rIrDYxuHCFgNQtJKKeNIYL+E4WNwefCTJNubbki25fajfqROTWqMxlBRiVibFHFWDo+Z3YAFItsKtm+owEwrrsBRWOEowrE2irPHXtTlDbhGixGvMzlXRlxgVcobzEZaAd7zYHx1KqRp60TMw3HbArtS3SkRWBnb2okmMtX7SeVVRhucOOIhDXcFF4QsAcnUVzXGVUDNkgyGASt7cp34I/0BH5vIO70oI=
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

Ard Biesheuvel (13):
  arm64: mm: Map the linear alias of text/rodata as tagged
  mm: Make empty_zero_page[] const
  arm64: mm: Preserve existing table mappings when mapping DRAM
  arm64: mm: Preserve non-contiguous descriptors when mapping DRAM
  arm64: mm: Remove bogus stop condition from map_mem() loop
  arm64: mm: Drop redundant pgd_t* argument from map_mem()
  arm64: mm: Permit contiguous descriptors to be rewritten
  arm64: kfence: Avoid NOMAP tricks when mapping the early pool
  arm64: mm: Permit contiguous attribute for preliminary mappings
  arm64: Move fixmap page tables to end of kernel image
  arm64: mm: Don't abuse memblock NOMAP to check for overlaps
  arm64: mm: Map the kernel data/bss read-only in the linear map
  arm64: mm: Unmap kernel data/bss entirely from the linear map

 arch/arm64/include/asm/pgtable.h |   4 +
 arch/arm64/kernel/vmlinux.lds.S  |  10 +-
 arch/arm64/mm/fixmap.c           |   7 +-
 arch/arm64/mm/mmu.c              | 134 +++++++++++---------
 include/linux/pgtable.h          |   2 +-
 mm/mm_init.c                     |   2 +-
 6 files changed, 90 insertions(+), 69 deletions(-)


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.54.0.563.g4f69b47b94-goog


