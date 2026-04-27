Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B32FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92BD6B0093; Mon, 27 Apr 2026 11:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D431D6B0096; Mon, 27 Apr 2026 11:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31DE6B009F; Mon, 27 Apr 2026 11:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B01D86B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:58:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E756A946B7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:37 +0000 (UTC)
X-FDA: 84704735514.04.5E48ED7
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id EC65B40016
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ekw62YGs;
	spf=pass (imf17.hostedemail.com: domain of 3RoLvaQgKCF87OA8+DFQDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3RoLvaQgKCF87OA8+DFQDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YrjY8IxNTKfKtmD2Yq6xqpB77zy7Hr/7JUIGpo0JaOI=;
	b=0eCB+ZYZZ4RP0o3a1j21UxkaSwjeeMUu8wyL+z0drD5CkcObv10wv/pTKSklvHxH7Ofi9j
	U7gV5tiXwQyX1SCJYxEBJ7nJuLCUm5aK1qzMDwglrekcNCwfOAEPzWqriuT+JfwTg5FacJ
	nGy+iCiAxxnxG8E/OAm0RQOJvO94vOk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ekw62YGs;
	spf=pass (imf17.hostedemail.com: domain of 3RoLvaQgKCF87OA8+DFQDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3RoLvaQgKCF87OA8+DFQDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304136; a=rsa-sha256;
	cv=none;
	b=EBuT/WpqgxKPlq1rtjLSN8wOsxYcb4kQUiHq7bRvhG3O+cUpTZ+51ziagxKibrCUtkkgLh
	5KndW825UX7cg4s3WqhrD0ggIY31JwfOB6eq/EH5oCT/Z3qQbJAm6Qn11X6zOvAeuFjdvZ
	+CEVziL/CiQHghMlOXN9GCKbxiIutKA=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a5952c635so59717265e9.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304134; x=1777908934; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YrjY8IxNTKfKtmD2Yq6xqpB77zy7Hr/7JUIGpo0JaOI=;
        b=ekw62YGsvY4ZESALsIWk+/LpXWK/ofJKDgEiEVgOY0SeIRYTlgtEg5vnryhfeazL3c
         7Z7Sved6IbGh3T6rxe0vJFb8JLrPsPn6XN/J8zfgywCUj9mTI6thOQt4X6S86ovYtCvC
         mqrpI5t+Pgt4nZsdWjrQ0wPQcyGPH13vYKpvslG1ch1nKeBBfLCGP/AdvIe30RA9CgM4
         OUUmnSV38d+886ie3vUH5MNI7F6K4e8D11QMa4L3fV3MKQclVi59ocD1G/WLqfKstpNP
         tQhbgAq6RagDf5lKC3Sg9I94hvTYzsxTzlpYaWVEUXX1XMEOR2oaLcDr8wQ4nY3KoEjx
         JcmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304134; x=1777908934;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YrjY8IxNTKfKtmD2Yq6xqpB77zy7Hr/7JUIGpo0JaOI=;
        b=Y5SxQzbHqux+mrDjdCuvuibP5Ez1LX9TOasp1asBtcZ/QJkCw1SVAjxtfTxVklDbKM
         LBMvRAxx5kOqVLGnhp4EAxtXYs4QTWy5qP572SEvgbjm9JoQJcdElTU2/x/hRWyMggAn
         hges2UptAtkL4lJzupD4cIbQPV+xd38PaM2siWJGzpY20UGgMtqpm8SkjMpdj+HXt/Qi
         GO+2K2y5+UAcjln9VjJDSG0qfNoZBg+/XxrwSQidFiuPovKtCav8CwMPL9rvEtAGjBxH
         c6+cWCzZxXd8e7l6qtWxHc6rPlurzMS60I7fXKr/LmDBBCHsi5leAkF+Mu++EJ510dUu
         OZwA==
X-Forwarded-Encrypted: i=1; AFNElJ9LmwGpgx59vXkrnHLW2ltC8oPlL3ybvTPUl0R1f95RkSGQq2sTs2gIpr5WKQ+Fbv6uFoL5Hc4Llg==@kvack.org
X-Gm-Message-State: AOJu0YwW5H9MWa+h81XMbVQU4d51zxZrcGrxkGtRaCyKP3Ow9SPQ0hZS
	S+B89GyxEG7bFtCkWuWBqkBqbgVSPsrGWvu12j21LlmGb6bg8+7fEUCTjyGHCBv+xJlisI3x+A=
	=
X-Received: from wmbjx26.prod.google.com ([2002:a05:600c:579a:b0:485:34ec:2b75])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1da1:b0:488:d376:42cd
 with SMTP id 5b1f17b1804b1-488fb785901mr663577045e9.22.1777304134363; Mon, 27
 Apr 2026 08:35:34 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:17 +0200
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3717; i=ardb@kernel.org;
 h=from:subject; bh=LVM+Y6mOTsDAEGVgOMgatOUvHVY5AE8R0yMbkioDilo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9488nT45tn57o6vvE7q8ny9U5wpOCLGfNE187e/1Rp
 nVSOrNsO0pZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEir4yMvxY9lqk7ujm5tS7
 xyZaFgXbXOJ9Of3Dt6l/Uw/4vXS8MzuU4Z/xlCfNa575zJdKs4u0OnaxjvUIEy/3O1G52/Y+7/z ZU9kB
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-17-ardb+git@google.com>
Subject: [PATCH v4 00/15] arm64: Unmap linear alias of kernel data/bss
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fsm1h3jffuot4gmq7as6pqppsxtfrq7s
X-Rspamd-Queue-Id: EC65B40016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777304135-671239
X-HE-Meta: U2FsdGVkX1+3TZAvonYXQf2XtbkBdFmj4rCU/1D1EOQywMm1hLK62KQgYRHGYF9gf7tgXq1r0e1AAO82kHZ41B+FFRNrlgjkwSkigZOHFwYNswLukzwiIbGCfL1pomcucXE1IEgNS/HyUj5NntZVho9v5cpQW1jgrnJ0mO9x223d9hlEd8CvrWlF1uhWC84hOjCqj317Nn59ZMi4TAAc0rsLxHPp4vqB1rFE1nATuvyJdQt/PGjUrxbaEw49xDdtQCi93r7fV9UnSYEmUD2gS0d8kJ4LzwGDsovHdZPQF8FIGDhih/JNhJJgxPT9fH0k9/7jEGslgEEV5w6ZYR7XlPETWPl3IS9dzTQFxSwdi5iL/z/ia9G/Ym64OrOi0okP4V/lmBdmy0oFuJv5gCywMTSOJ1RJIZCjwBcTyc4jBVcbKe6kA3IpCvCnXHVTaBgGrQZKIgdW3cXMLkvjyVI0kCmS6/00WwvRJ4FpkD0es83bapueGrPqoX00cfFcS9cNbMEkqY/4iTtzoWC3Ywx2rFCYOb/ZZ+bLW0GvAoeP/WmyaDn3ibE1hZn/G9Ynrbh6dK9/RjLe9gw59IVB439aZBoDXjP/3uAVnxTnKqRgoi+faw3+IN5fliCs5CQiZAgAO3CCgcujsiZcEkAFUPAkS2CLeFaTgbpxLB65OvJWnyDWEDQ3ByzOvI/gRaym+RpmQ6AWhkCqq5kbgZNnxB3IJwVfkgUY4ErGrRST2EsaWoCKhV/B5a3xxXsMG3Xjwb4BDXuMxtDP4wIIr5QHvdO1pGWczLuTpx3lvnUw99sL5Z6aWCXBl4Nw9oaf8A7+EOwOoCEbpmZmmo8rNKcY5pSV83jSxByQlw9BNpoK9Qjm7lWp4l52J6t/27bsJtlwgilVUxqP/+9FKMY6DKwDkShEAn9Gn1AXjqiBGO5V5n/a3tA7xJGvPZn6K5EQO+4nbCq8PyTPucs5XGJtXrGmmed
 ibthY9E5
 iseLwfY6JSGQhvdpOASHiwwEoaJnWqtJz5LR5vZxm3f2vOe4IzVvwRH9nuJ4pJUOv12r3ZtEwGMVcsmyLlvaUK4JuY8U3Ekgq8SDVsI1zJYnD5dnQrItFUva6t783feda4p0N0f345C1TMNOe6IhBeM7VYTcFRoKsuVeMv8Busv2ZXhVpZOcxVlOekknIZfhV2Agx8hLSHXrFv7m08UullESdybonv5r6eqhZ2Jv2ksO3nBWEV45QREA+rEGeDBYwEV71VtXIcDjRKDw0YMvnmEsRe+YuyCV4XAKsjH+27yxkhjKcS8d18j0sioYwOtCf07+ZvbwQ13rsuOM7Rlsbs5aZN1JLd8MJOoP1yszorZIT1HVlcezp8R78qmY9QidfltMlZotn8XeXCUpRULVunlpEzltR5vBdqpEuFz4oG+ZWVYH2wuXGSN6F2X5A6JwYBjVX4kODd39OO97NnmcMqxxTJWeuBgdOZYHQIR7vHmYRQ7vbj0B6S70yfvclA2NoFLYXhswpEGIRFGQ7xEIOFMlU9v6WjMZkbejUe8rFznsn+QdZMVWKFKvGZfujIUBHAgzIh7HN2hT6qERPOmXLrGtPO141tZoY1f7jIgllHdU52SeZgnmnEDbDaXkcicAQV/m0Nm8CxhbRKbbJdIalE3vEr6ieDIomqhDMJJqb6uuUYbF/s30/70DMyACopH+zvcOEQJdT8YIIN+eKkPNFdW1J97hpRRcyFa/rK8cvs+qNXN/UsoLk96jQa8YEdJe8iOn+G4uuo9/3rq38aNNZec1wQKzUVZK70Xp7G9ablD3hgoAK7jB03//wUPewC/Gorr5K
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
Cc: Liz Prucka <lizprucka@google.com>
Cc: Seth Jenkins <sethjenkins@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-hardening@vger.kernel.org

Ard Biesheuvel (15):
  arm64: mm: Map the linear alias of text/rodata as tagged
  mm: Make empty_zero_page __ro_after_init
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
  arm64: mm: Generalize manipulation code of read-only descriptors
  arm64: mm: Remap linear aliases of the fixmap page tables read-only

 arch/arm64/include/asm/pgtable.h  |  33 ++--
 arch/arm64/include/asm/sections.h |   1 +
 arch/arm64/kernel/vmlinux.lds.S   |  14 +-
 arch/arm64/mm/fixmap.c            |   8 +-
 arch/arm64/mm/mmu.c               | 167 +++++++++++---------
 mm/mm_init.c                      |   2 +-
 6 files changed, 130 insertions(+), 95 deletions(-)


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


