Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C29A2E92733
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 16:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319D46B0092; Mon, 29 Dec 2025 11:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304D56B0093; Mon, 29 Dec 2025 11:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207576B0095; Mon, 29 Dec 2025 11:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0EDFC6B0092
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:46:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFD0F58438
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:46:18 +0000 (UTC)
X-FDA: 84273086436.09.C5B580A
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1737540005
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:46:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf07.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767026777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=tYC2KycL3rfVSFqLvotaH1KEwy8YCG3oD0jwMS4kfPg=;
	b=aOeYK8Fnn1slDgEWGLNgszJS4AOmng1BeXxGQRlEPpoCn17E6CB4CGwRV1LUxPrS4icDaV
	FE0A45DGLb1oPkyQ6qtLhsj079rlxLOxEt7Xb9PCkmPb60WoR/8/gpLMfwP1he/2+Cl+fH
	ACB0R24OM7Ogxwvxqw1dwKBkMfGJtPs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf07.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767026777; a=rsa-sha256;
	cv=none;
	b=skNGekxPyDExFIvXxkgZJiLc/cngQwKuf/DKx/kAp5l7LmK7AdfHPnRdN8YqifSImnOY83
	fqu87eUGd8bEww2Pab5ARhhvw76+lo72yHfw9MiY8c6SZPy0RZ/IGU8U8nqUxEX2SPsRh0
	xl3TZWzgTlcgNsNTpY/ck9kAm4TBj74=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4f8a6b37b2dso14475961cf.0
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:46:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767026776; x=1767631576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYC2KycL3rfVSFqLvotaH1KEwy8YCG3oD0jwMS4kfPg=;
        b=COybQwJTvDQon7jZBxfkhIuOrP0eNBJczlzPgmTkH11caucFN3ZLAiSVI1jYSuKIAd
         NE2xT88NCNUW/DFy8p5HIIOK0e3tHSMVs7o9I36s2k76Tp05Mx9T67AOK+w7U0Y4swSB
         CUdC1nUqWMzvS3e+e8lT4gLXqlwQqr7SDZR3kj5VcwZUk8LWtkNSI0GLxB7ij9KN5kmG
         zhHNFDyCPMbdEEiSS6Okr6VtwmCQJwss/7j7ck8dcelAluEDWsBPUuhAtEWM9R9mQcC6
         YBjdAAejf59GsN/6Uxza3T6Eqbtdb/1Xg/KpESjDJzuy2lcCqQxG/t2OT554G0KvLoY3
         cZlg==
X-Forwarded-Encrypted: i=1; AJvYcCWri3OVKBW4AhFTvCmBMKHu8DCUoaJOR+7vX1FgVli7WSnOngYZyt45wFijOcJGqa9BuL0bcRdKYA==@kvack.org
X-Gm-Message-State: AOJu0YzwPDn678BY4d4dwXT85hDA0rbyIL7Ej//caxfjlk6jC03+jUbq
	XJDiDIehwS7uqcMvBQp5HKiXqqyBDWN7yAB8CvuxEQNgEHJf21eYEAQ3sMcjIuU7Yes=
X-Gm-Gg: AY/fxX7KOOitAs977DSiThBukKoehZ8nhEnoDIaWn8QIZ4Ot4P95NeQxpTdbj+Qx/iz
	dzcLJH4gc8f5AUgoxkhBherlCNjFNx0Q5WDJRHfak+E9rOdYanMGbJ20lTzO2/B4IwifbdKfFZh
	7BYt65j2xHHuig5gZrf1GrSkcLPWQkAT2y1MbBbhSGmwXU99u31g+YOlsYSUP8otyIUdSWFw5BB
	GhejTmyb4+tGTjkJZsGqt4plchJiRbMswqBuTA8ZrwDRL5M5gzDX+nGCarUQP7t0dSWhYDXt78g
	TZJFQsHfdi2M9n1fId5D/3DKomkHN78EvEz/ZpO8CoT76OjGGOUEBpuzFQzFA/lKRGuJEJVjpbH
	1811K1h13NjsTwN4wqUlLJJ0Qi67RHISQ/G7XtQlize9odkEwoPZ0DMDfMXa0O+n5nRNdGZCXJq
	21O63qtInc201R9aDhHUpZEtKOXVq6hQw=
X-Google-Smtp-Source: AGHT+IFhUxr5n8VZRZbKH7W82fTkxc2RP8kajse/6MgRobffbByIorFltc6WUeCvU41oKdSH/PT+mQ==
X-Received: by 2002:a17:902:cf08:b0:2a2:ecb6:55ac with SMTP id d9443c01a7336-2a2f220cbf6mr353927325ad.7.1767019032156;
        Mon, 29 Dec 2025 06:37:12 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([45.8.220.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d7736fsm279669625ad.92.2025.12.29.06.37.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:37:11 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v1 0/3] skip redundant TLB sync IPIs
Date: Mon, 29 Dec 2025 22:36:54 +0800
Message-ID: <20251229143657.76968-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1737540005
X-Stat-Signature: a3zc3f45sipzmf9u8axjw8qsqmeujmts
X-HE-Tag: 1767026776-152394
X-HE-Meta: U2FsdGVkX19XZMiwbZQ/eTm1RzZcp86iQPrEbOnY9qwMl+SZn7vh2wkEArlK/eITdztEbqzzedYfgFqVU5hHz3B7aVNQ/RtZW6+hqPHnMf+bxvvUwDHl/Tyt3FDdyFSk/XKMpUuckUlUQQTZh9lfxgomB8a07griurdU43lOIL05tK297dFil81uLCb84leyXLoUdJA/jYea1SaB76aSnCgCTgl3sdv8D/8QquZ1eT9WLbooDwksG123X/0sCdp/hcfaBLBH+jlJTCTToDHY35POl3dCyCAaVrN9EF8OUS6k6xIIBgek33Zwn9C749SDDEefkTfrXTbP80l68Tkam2r1WerWpjesyj5pgpB/S9zycPYNAmBS0MTrYj/9PqZbRYuvsSWTiett0eZeGXOIIMdXZhcs69GHcgv3AZYqXMxoNh0ztykfN0uAzzuVvaFIuvaFoSBsQbLgkAjTr8iB0OyBfwzuLD3gkWihbhw+nTak4a/BPeVmlScGm4p0Pui3rBzkYf+/LzOvAkInd4iz9hHn+JfB/h2z5so5vyjWyKhzSlhPX8uZqpg6hz8U2h0k8/K9GrYNskaagiP5RWrzdLjXvbOG+QSDukZqOq5sqBCFif8v1FhAuIe7f2FKJ7n4wUnUZRJ4iZY6mWAwTlBenvhRp394o711rMI4Lnr7Auvrst243tVKtAeOQm5iqu9NGWgW2IKPJyNZWle48zCKRU8CX2gZulWuS2hK5DKnjHBVrlPwojKFUT9Cb1wuUfwNofBMGSLdTyLMJ8z2YKwJxCDVKySyPLLK2yD26seds9BvO1kmA7yV1qRcY39uBgZHByP4jXy/clR+9avoCUV71DvwaUOZ+snXc+cmA04qQF+E6rZM8PXVyshNSruNQCqFdU9SZ9qxcjD+jYPdPYq6OpQAmTAz/Jz48z3Qb9fMcWW7hD4iXVw5qYUJaAwthy021wf4YzYIsy609pQxCiV
 haGPC9iD
 uMgnhC0iTLuxP1KrQslxf908o2VdBpNvbuviEVX43rRb94gkY5Cr+vfKoYyUVIRuo0a4/6q33ECnLVt997ECpPvwEXi9bGpYRwkSPsDtDW2G/KszbZQzH8NVpyPa6A6/k3AP4LV7IGoiPCWsrPQOCuvDn4/WlqnbCVdz2ugw15YLi7jKD+gH/yphuiNETcgl8rj12XKi0XhCpHjTWex37CKDwrkZG3yDs0PGerSGlIJdbM2Y8doanfUuUHOJr6cmSiEEFZpp/CNupcNa5YA6u3Y5kHvE8i4/xMQQc4Z+mYY0Ev3JSnwCxSGVkAeRka0DLSZXAO6fLx2BK1falV60V/nzfH+Sp81vXKeioL82OLZsVeLyivCnzbb05rfuzI6ov+b9RRkuhNiwAWPujMgfPU1X6ZvDcYUtYD69ojTSMYcTBz5JyJ0qCFkrlsfqMWVdHo6cKMhsHMcLfbak=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Hi all,

When unsharing hugetlb PMD page tables or collapsing pages in khugepaged,
we send two IPIs: one for TLB invalidation, and another to synchronize
with concurrent GUP-fast walkers. However, if the TLB flush already
reaches all CPUs, the second IPI is redundant. GUP-fast runs with IRQs
disabled, so when the TLB flush IPI completes, any concurrent GUP-fast
must have finished.

This series introduces a way for architectures to indicate their TLB flush
already provides full synchronization, allowing the redundant IPI to be
skipped. For now, the optimization is implemented for x86 first and applied
to all page table operations that free or unshare tables.

David Hildenbrand did the initial implementation. I built on his work and
relied on off-list discussions to push it further - thanks a lot David!

RFC -> v1:
- Use a callback function in pv_mmu_ops instead of comparing function
  pointers (per David)
- Embed the check directly in tlb_remove_table_sync_one() instead of
  requiring every caller to check explicitly (per David)
- Move tlb_table_flush_implies_ipi_broadcast() outside of
  CONFIG_MMU_GATHER_RCU_TABLE_FREE to fix build error on architectures
  that don't enable this config.
  https://lore.kernel.org/oe-kbuild-all/202512142156.cShiu6PU-lkp@intel.com/
- https://lore.kernel.org/linux-mm/20251213080038.10917-1-lance.yang@linux.dev/

Lance Yang (3):
  mm/tlb: allow architectures to skip redundant TLB sync IPIs
  x86/mm: implement redundant IPI elimination for page table operations
  mm: embed TLB flush IPI check in tlb_remove_table_sync_one()

 arch/x86/include/asm/paravirt_types.h |  6 ++++++
 arch/x86/include/asm/tlb.h            | 19 ++++++++++++++++++-
 arch/x86/kernel/paravirt.c            | 10 ++++++++++
 include/asm-generic/tlb.h             | 14 ++++++++++++++
 mm/mmu_gather.c                       |  4 ++++
 5 files changed, 52 insertions(+), 1 deletion(-)

-- 
2.49.0


