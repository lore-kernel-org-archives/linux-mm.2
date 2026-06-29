Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0548BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C5B6B0115; Mon, 29 Jun 2026 12:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE276B0118; Mon, 29 Jun 2026 12:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20856B011A; Mon, 29 Jun 2026 12:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1E06B0115
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:37:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 292CE1201EB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:37:54 +0000 (UTC)
X-FDA: 84933506868.06.FC2911B
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7F6011C0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:37:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nmCNy8wN;
	spf=pass (imf21.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751072;
	b=gjGjhF7SJ2MeJVwmAEHng3+QkRKDhHKlj34XdyY5ye6mmWHYOOvsCPYOxnwRuvwrB4dF/8
	EYv28qNuZ5evj7MT/dJnRCUHWhNpkPisbAUD7NXABUGJAPDR1/8Dw3zVn5fl0GHE+nmaSb
	uENWfg+fHqdvD3UfP9OHs5fWuuEBbkg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rGoS9kJnOsBC1GLvPLCMMJFTI12ls42atzGQpoe5Bdw=;
	b=Ksij1Lsfh5OwtA5pKPppCw6NA5xW2sXEG5G3RJfALKpl9wETScdPx8O5fMnvY1DgNzmCqM
	6xO7joLjhXYA6xdGKOEOLM92Fi2K2x+b7TATW+DW2IDhSZJ28yvcQN1laEc2tV7/etxjEY
	4RlQ1ibSrjNzyujmwnTU9XoL2ansu8Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nmCNy8wN;
	spf=pass (imf21.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8478a25f268so708768b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751071; x=1783355871; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rGoS9kJnOsBC1GLvPLCMMJFTI12ls42atzGQpoe5Bdw=;
        b=nmCNy8wN/y6HNpbQQtp63YX15VO1MGawB/C6lkDaKID6DkjGqiAvqB1xZ5Q+IOVIKf
         yuGPK8nHxK3C3aX1Z9+bvUOCMPoTm9fMTphYiwVEATkiuAr2xmcQlfC63ALQPhfXANcT
         2IpLhEWIV2WAOBC2QSZO6KrjXQrKQUO7JCxuVEYOM7z7Oa6r84ZE7x/c6qOVWko2skIf
         +SXgpDVayGJ4Yk0bNu71WvHEtulhHUmCTC5qW43GM+uJi318HqdboFdHoHLGlkw5iGl7
         3Qt8Vj8LYdwix01hTO2VVCDOIL/WPyvCxTRW4ou8PwMO8/6oFA19QLiOSjzpfI0zxgMn
         DUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751071; x=1783355871;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGoS9kJnOsBC1GLvPLCMMJFTI12ls42atzGQpoe5Bdw=;
        b=SVGS23EvoT25b9RiFBuLaIHV3IQArdQMuGvq1x0W04TfMXpZshP9kRKFVrs/UqQq80
         jqs86xvzReLqB3i0iDO45oIFqDjMp8KK7pW+e44OPRE1Ke1rNlIO7pc/zdutWfk8x+y1
         ZKk6u52Ucy2Xt9HTei6rl2fVv1V4SsLSborI8d16Vp9l7DqmTpTvgRbej4+OeugI3Td3
         fF3kCoQ6O85DKz65S52mO+28EbxgNCoKjV+/BVSjZAtgRSBtgy60NHJzV6E4lsWYtyWP
         wrsUfrhv6AXA6+SPstfI8YKfV9UaWrZy020dbfJkycBshWiyTPEhJbHN1s7DhppM/5oQ
         hucw==
X-Gm-Message-State: AOJu0YxYYJd1bW8AKuARC/gYfc3XTJSY0k1TjfgX3GCpeM5G1XgJugIS
	m+FZpygb7r3iviGWKfS8VR2Bm1wtyuvViJilD7xL3zMI45lrjsgwoq5/
X-Gm-Gg: AfdE7ck7pEJfHkQpzjED4FbFHh82UxXdb1pH53sYvvsrWnVC4LXCAuwWIr+TXNQnsG9
	m4AhvpbX8m2XDeyUCUlSKzum33W+5od/dcFTEhcgYa2tp02eGszuTKZr+zY6p2VZXCtWR91saBp
	5mpMfDlbmjHZtKOQ4fliOebhqyplkKRliih5hP9v/1Yegi2wtfMUYVcdBfByq3ac+7bowT5Z3p9
	YKwG1Tcbm+Bj9J3E4JgFrGrl01H1vjcBJ7GjHPL5nEHf31TP8EDAYgtWCq5Fo6FEd3+eg7fVSJg
	eBNWG2FtjR6QORIwz89gHE84i8lkYesLCoUxp5QHoxXTm6D690FexrzsUb0VpzTdEDW14yJeK0d
	MzPz7vkizSn2EK2qJXU43+dEpFTYMwjZfK0fxPXa87fYUP1fhvCkzzmSJ/Bxfo19hmVd1IuSv//
	8rbg2oODQ=
X-Received: by 2002:a05:6a00:92a5:b0:847:8337:64e4 with SMTP id d2e1a72fcca58-8479f1f553amr205069b3a.30.1782751071179;
        Mon, 29 Jun 2026 09:37:51 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:37:50 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH v2 0/8] treewide: remove unnecessary invalid range checks in memblock iteration loops
Date: Tue, 30 Jun 2026 01:37:28 +0900
Message-ID: <20260629163736.1606688-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F6011C0004
X-Stat-Signature: hs4fazfz19tjbmurzmkj9y5rhhkiwmya
X-HE-Tag: 1782751072-477125
X-HE-Meta: U2FsdGVkX181t4SOAdxCAzL8FVWJpkVL0XbPbFaruK5/QNb8CPLimVClAIK5PpLiJYCWs1ubpydrxs9vlEt1e1CCDn4pzyTpB2aAu60yF3aX+UmqqXsBP/cA3KtGGeXwszAN7SjI9ATZQK6jFL4OipUYWBtKbWpTfShMzr9QVGw6dXTf/1x6FQZ4E8bnq3R7eWtfVhZnhPzBIABUGD0VTne+yO0pch9pRvnj4AyTT9eVAR9j9oyBkBl89fsX7lQpH+UX6dKCSC71qV+5ebzpj3wiYd0t+Dm9pSR+0O9gx7MG50z+GjJj/hd4pJac4q0dcvEViXee1p7U7NYxzb/mGp1TZsUtNb82GkGVP2EOKEVvDpUybTcoPPVrNXcZuXGtB+D7TJKyzYMMP7iBrLM/gtM8k2wSjSN4ttD0WX9pcd9EtuBaK8lmp8hNYhm3m4ZwtDDdRwfCfKP5J2WHVN9JbwaEhWG/6uPRMCkUc97emjta1v2OBSUr/kr8dgPUzhdACifc5ynuCc1HkDa/7Vv8PIXUq/5HkZZLjgRQka5J8UMIaUaeBzRVCZdeH48H4aobyhrb9DljQbnr6M05OQGzmvd+tWMz6FfZRHHCCfW5qSnBueX/vSo7jDUPEsus6q2QhVHQDJnBiXnxR7HjdaJmedq76e90F0JymzZLZZN4Rb66zjvhmQlmOBnwgM7gQOANGCDXxiXf3iU+U57HAKYsounDHM7J+QVWM9P3By8TthLbUlpZR718Uy5jLGay/6bzUzNlqQM8UwXYz3RD8DctEyZUBpHEzEqY+Uk5TUNxIMV3aLkmPtPSxgR/ahI9GQrj+1jWQVlmN5tPMwEvHAgAbN1ydaqf20y5gk/lAFDaRJPMYkwTGlQPpOHlilWNLSWFXwIrXkbXNQXtYAxekWFiPg5l4RkOmlfMhLF7WtTEKOxrbeUHSxjCCAmRvNmFxVztpRF/hGgycrPxf5vJTPS
 XS+4vuOc
 Rcvb87sSOdCfheOcgqIYmM3uzqpSXAWv1lhFmRLyqkoIZ+uFXlHClKV5afZ81sgIDO85mEiTj1rgy6O3CqBobkMlp5TcXNDLe1bNF4Dl+4vwehvVXJyPRqoSeLtXScz1ach28XyJD7NL2AWkxQkVccGnvwFP5XLPehu6k/o5aO61QbbelilkpKkBIiM2U1sW74keLMlQP9etggKIpHaPkk9tlEhp0Zi6BLJETsspm7NkGKwMkhP9isUfk5D+ClarMZcCC8ebqXnt8FxsH2LqDZHcxYc0wHyIPgh4MMCMKgBRh7W7Xy+vW6rthl2wf1VeIepWwXJx5kvvKu+0xex78xOg7wdMLxUkQLq9HVkAWLoNKVxqzw10b9dPGh7miqyO7dkYmfEeGF6qQwLtdBtPon8AvCi6UAvZf4PLwuQFt+8ZsCaeCM7H2pRIBuasOht80QNL6Bdobc0xuLZcEoHXCcrFkIUMfcgrXOpSndlpd+Zgj5bsNXIY4LUfGXIw9vu/tywlU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memblock API guarantees that for_each_mem_range() and
for_each_mem_pfn_range() never return an invalid range, meaning start is
always less than end.

Several memblock callers still have unnecessary invalid range checks in
their loop bodies, so remove them.

Patches 1-6 cover for_each_mem_range() callers. memblock never stores a
zero-size region, so the range it returns always has start < end. Some
callers apply __va() or __phys_to_virt() before comparing, but these keep
start < end too, so the check is unreachable.

Patches 7-8 cover for_each_mem_pfn_range() callers. __next_mem_pfn_range()
skips any region that contains no whole page, so it only ever returns
start_pfn < end_pfn and the check is unnecessary.

For reference, commit 36ca7f4be809 ("arm64: mm: Remove bogus stop
condition from map_mem() loop") did a similar cleanup in arm64 map_mem().

All these checks are in different trees, so I split the change into one
patch per arch/subsystem. The patches are independent and can be applied
separately.

---
Changes from v1 [1]
- Add review-by, tested-by tags from v1
- Add missing simliar patches(5,6) to patch series
- Change base to rppt/for-next

[1] https://lore.kernel.org/all/20260621145919.1453-1-ekffu200098@gmail.com/
---

Sang-Heon Jeon (8):
  arm64: mm: remove unreachable invalid range check in
    kasan_init_shadow()
  LoongArch: remove unreachable invalid range check in kasan_init()
  riscv: remove unreachable invalid range check in
    create_linear_mapping_page_table()
  riscv: remove unreachable invalid range check in kasan_init()
  ARM: remove unreachable invalid range check in kasan_init()
  powerpc64/kasan: Remove unreachable invalid range check in
    kasan_init_phys_region()
  mm: remove unnecessary empty range check in
    early_calculate_totalpages()
  mm/hugetlb: remove unnecessary empty range check in
    hugetlb_bootmem_set_nodes()

 arch/arm/mm/kasan_init.c               | 6 ------
 arch/arm64/mm/kasan_init.c             | 3 ---
 arch/loongarch/mm/kasan_init.c         | 3 ---
 arch/powerpc/mm/kasan/init_book3e_64.c | 3 ---
 arch/powerpc/mm/kasan/init_book3s_64.c | 3 ---
 arch/riscv/mm/init.c                   | 2 --
 arch/riscv/mm/kasan_init.c             | 3 ---
 mm/hugetlb.c                           | 3 +--
 mm/mm_init.c                           | 3 +--
 9 files changed, 2 insertions(+), 27 deletions(-)

-- 
2.43.0


