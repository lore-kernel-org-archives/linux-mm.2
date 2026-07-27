Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0EB9C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9766B008A; Mon, 27 Jul 2026 10:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD3E6B008C; Mon, 27 Jul 2026 10:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798E06B0093; Mon, 27 Jul 2026 10:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F91D6B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:34:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0EF1C0717
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:34:49 +0000 (UTC)
X-FDA: 85034803098.08.A0FF27C
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1845640013
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:34:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aI4RNmN7;
	spf=pass (imf17.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8jVxeCFazqwknGlFRRbIYSIHmRn7jbRySRKJMOZEfOc=;
	b=NohMW5qojwRdBm4I70tgP3XzPUBZztgd9V+x/7thD+mei8eel8dFSP/wnOsNqfwIOEbIyI
	is9xtLVqy6woE/xnkZcSWuWwqN8OymQbQkg/pEgYu13WI1cGu2FCFwzJBdblSuKVD1A0Cz
	A4M8FBj+/+i5y6OcWX1Z94bnwrq5jZs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162888;
	b=UG5VP/PJByGbJIUCahZVtmtyHaWPth2nM9lSBywY6YCuFCi04CHO0R5Rths6+UTund73ut
	viOMOZXgo0i8GMaMZmsylnEWMw+YT8fusaPehkGO/6GEvI9But5PJRCfGLs1yXljW74kYv
	yiFx2O/DMw0VfW5fXyfTeOM46FkCRZk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aI4RNmN7;
	spf=pass (imf17.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cad68425a7so4039235ad.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785162887; x=1785767687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8jVxeCFazqwknGlFRRbIYSIHmRn7jbRySRKJMOZEfOc=;
        b=aI4RNmN7wbQoWXbhps2I/U9Le3eItRdEf2kNVWMRZz8ziDcUaiplkGaTs92coqCffT
         UXh1FoqfZsLyOu1qW5eGq8aadfhv8wDmCaCjQLEK20Ci0Ij/9gY6x6+ryEWM2Hk1G9g4
         Ocbyhi7Ps00GVcg9YAbP0nUE5xbISbVSl3sWG1USo5PJtxB1bbs0MQ+tj48n3CoUM9wP
         ODBNayyoQq7eyFMECHm+WYJUnsTCstW+Terdx0RtgaBncAQxsCG58/JFwWlbWWfVsksD
         FtJ7Lf5gSbSOHBsb0F46J25rH5U1Sh6NA58muf8ghmJUw/uGhyEg/B0r47lNPUwLDLmQ
         mi3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785162887; x=1785767687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8jVxeCFazqwknGlFRRbIYSIHmRn7jbRySRKJMOZEfOc=;
        b=EgnPZ2/g6kMMmYBRR2xqcdjuR6zr5Jt/UAj4Uqu2ivOpn0jDVevXXa41rDsDp+Qknt
         t6M2RJVpxx+JZUQlxp6Fw3T8DYEocJ0WaknbsrkXCgD4B4bKMwgTV/KVqG20TCfgj3c3
         +SIB2FOvBYqo2z2KQC+y1bzK9Bifalw9FdZKtneofxZ461pkutUV8Bm6zM+kT6WtsaVK
         vScv66778DXNgJ+xAFFRslsXTrLd4xNBNFSnqWyRTWQs9E5yoQanKY0OMxWvuB4wIuDv
         qt8rX02PCCZ2oeW2UwD3CZTvXQSU2OmV5ve/xnYuYp9vYcXWlcu0G+9q38DoD2m+ZaBi
         IZQQ==
X-Gm-Message-State: AOJu0YzgJsPTKsM9byEQ4WQk1wPqfykVNMOiL3bFMFA2VkK3//bREMXy
	cLjH7epYpKJt4g/0JL6Iex1gS4WHI76RTFqe5m2rgHo+5iA3ZUqHdzWLhxIMO9mVQE1yVVB1
X-Gm-Gg: AR+sD12Hi6ZNnhYXtV/81H6NCJ3ZFVkGXRtx8lI6voCc3BKUiSCsbckC3I0Fxadukrx
	gXpP96b2vKaEQcRmis1QF8hVoTauU9L0p8ArXDz64BnyeT47k+2GAxHLM8qCNEUuCZpcOm/5W0L
	UZ8pwKW3nmEL8qiazVlKtNYwrPrJAmNeUu/bLXnw71nOubZ+DtYo9hMtj74B1fdxPMNq88kqofF
	Hh3z75JXKpZLI6pjtCF0Xqdm9HsQ9D714Tz69c/okCxMEc6hn6ZtMQRgBZr4dMcpQVsjRftcFJ7
	R47caZLUW0vpSMThJWJsT46/RAVmuJ76b2ep/llk+Xkm5baj7lVy5DG6kw4+zONZsc5FvCpDltN
	EwwsFIz4y5NnEHydg0nLPAeC6WLOtc3CKGnxlJVVLd6b8ITYGcDCiZtKbxwXBLMdEqrI/pve77Q
	Bt4bwWPZxP43FDJRmP8VFStaVzmfTkj66IufYObbUSwQPhHSGk5gm+F6Wjrs3XVPlVSXglU5EJj
	V0=
X-Received: by 2002:a17:902:e948:b0:2ca:d803:5c8f with SMTP id d9443c01a7336-2d00b42a776mr4692505ad.1.1785162886755;
        Mon, 27 Jul 2026 07:34:46 -0700 (PDT)
Received: from debian.lan ([141.11.42.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7d5297sm36877485ad.56.2026.07.27.07.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 07:34:46 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	jannh@google.com,
	yang@os.amperecomputing.com,
	rppt@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org
Subject: [PATCH v5 0/3] mm: make persistent huge zero folio read-only
Date: Mon, 27 Jul 2026 22:34:23 +0800
Message-ID: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1845640013
X-Stat-Signature: iwchib7rw7z6mmehepk5srwfh1xb74sd
X-Rspam-User: 
X-HE-Tag: 1785162887-668863
X-HE-Meta: U2FsdGVkX18n1t2SNFVkYLKA44CxPDhfcPBWqz5Sg59py9mClDG5KbriqRgvRcdPH7fctQ3xFhzLbl8j3/bfC7mc+HJlcG19iThTJkxHFYvkLmHcYAOQQaY8aIc74a9GcMAj8M3C2sSXrHCrLWMTdGAyhZRfPl3qet21tkuPGEHuA7A3sluuLY7vpizRa7huQQeEjqcZ+igozQp5cjMP+pASEPE65ZAgfPbngHyw7+50d1Jtfhx/H8ZtRaQXdzK7ptEwX8x27KRrwHyCeuHuUYUAR/xECewzlxS9ku0v70aFh2kc74fJWwy/NDEj4buLaihr+9JKIZ9WlpV1wDqQCsYNFd/cw3TSEtHvDqlpuxl+XbEwUqgIDh8FxEhys/DORjz2BYqZmloDtdVyY28P8v6b+nXv4Fk2SBKF8wIv+6MfIE9aPjhGeNXJphQ89IzVVjpdryBTd4159GTqkygccIygTQZ27B3vUVKkBhzDFEcVgj2OAMtqzalQUqVhTp+FxzAL/mxQ1HN3cIDmsgEVOkLvmzMh3fexjjdqtxQ+8rMIiPjTqTLP8RhH2+dkcaBuUfjHPpiT7TGHWYsTFO7Y/zkvBgTFl4PorA9GCklY8zzAsEgU8EmDr3XgsYU7WUGcSVCv9b3AC97lTNofA2xoDdBkXnXq40Mycmd168VtVQHGeTDnXISYcKY7M98rPOSH6E6+YjeuMGB9vgMZJtj2ssTOvrORZCyyTx+xLqwffQxrkOqdrWthqQBjFzzQPoeqoY3jnMyUFSwwcPjcuI+KKdcS5oxdM4VKL3PKm/rIDP6xh5mP0+S+KP9U185srlA0roVChlZePfBW6kUJLgxuxDSIh/iLLHyrxT68gcX8Tb16fl9BmtN6Zv6k5SoxaBTtSSq5DVyZrm/VT5nKeeV/9M2qFgqvMoC98vHxjjBifvmv83ViZWSokzJsQCeZ+6bpAmCVdtW9BWZ1IfHBETM
 G74cf4aX
 52hZxruMXGuJ2Ef4VzLtFD7MKqAyUCoFiB4OmQnhLdMApjIGvNHJqZPMcuFgZwuhWZCEqsV5IqW39o5ITcgGdXMBKHm8nnjEjm3ESMFiFunq9+9exOYRSLWJjPR2hsMOZGPHioPF7AOkJcXc1J7tvggEFZnzl2Ym32RHjT3Ljb/eMI8lxEf1+shELi0e7PCIlH2EfG1f0/Dxhgm9TSRsJGLnF2TnSGRHXxaLyOaIxu1FuO2zIBBQ424Rwm6Cbqx5LBJccXAR+6QkhgzFDqdM19bFIELmUDs7u6VciOZOE+r9UwUPbd9VUnvRnExEHIdVOW62M/m9Ynkd6YUQyYbA1Ig7740dGRgWR3h4tQ6+cXhPax6a1Kn9gg1+gFChQLpCcKK/G++51tL34ekKB4mVTT0zGdpFTZpWWlERGDPzKJay+1OtQI4uhw6xDrX3fyzU396V+yTQJq59Naek7vrFqvrsXzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out[1], kernel bugs have ended
up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the folio read-only in the direct map
turns such writes into faults instead of silent zero-page corruption.

This series adds set_direct_map_ro_noflush() so mm code can make a
direct-map range read-only, then uses it for the persistent huge zero
folio. The helper is direct-map specific, takes an address-based range as
discussed for set_direct_map* helpers[2], and leaves TLB invalidation to
the caller.

The folio is allocated and zeroed through the writable direct map before
thp_shrinker_init() changes its permissions. thp_shrinker_init() is called
from hugepage_init(), which is registered as a subsys_initcall and runs
after SMP initialization. Writable TLB entries may therefore already be
cached when the page-table permissions change. Patch 1 flushes the exact
direct-map range immediately after the noflush page-table update. Keeping
the flush at the call site preserves the helper's explicit noflush contract
and follows existing direct-map helper users such as secretmem and
hibernation.

This is the first non-RFC posting of the series. The direct-map helper
interface and its TLB invalidation contract have stabilized through the
RFC discussion, and the series is now intended for regular review and
possible merging.

Patches 2 and 3 add arm64 and x86 implementations.

Link: https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/ [1]
Link: https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/ [2]
Link: https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/ [3]

RFC v4 -> v5:
- Drop the RFC tag.
- No code changes.
Link: https://lore.kernel.org/all/20260718095647.182592-1-xueyuan.chen21@gmail.com/

RFC v3 -> RFC v4:
- Patch #01: Flush the direct-map range after changing it read-only, since
  the folio was cleared through writable mappings after SMP initialization
  (per Usama, thanks!).
- Patch #01: Keep the flush in the caller to preserve the
  set_direct_map_ro_noflush() contract and make the flushed range explicit.
- Patch #01: Clarify the noflush API contract and the reason stale writable
  translations must be invalidated.
Link: https://lore.kernel.org/linux-mm/20260706130440.9295-1-xueyuan.chen21@gmail.com/

RFC v2 -> RFC v3:
- Patch #01: Replace arch_make_pages_readonly() with
  set_direct_map_ro_noflush() in the existing set_direct_map* family
  (per Mike and David, thanks!).
- Patch #01: Use a direct-map address and number of pages, and document the
  direct-map-only and no-TLB-flush semantics (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for
  set_direct_map_ro_noflush().
Link: https://lore.kernel.org/linux-mm/20260609143801.7917-1-xueyuan.chen21@gmail.com/

RFC v1 -> RFC v2:
- Patch #01: Drop the READONLY_HUGE_ZERO_FOLIO Kconfig option
  (per Dave, thanks!).
- Patch #01: Replace the huge-zero-folio-specific hook with a generic
  page-range hook (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for the new
  hook.
Link: https://lore.kernel.org/linux-mm/20260527035607.14919-1-xueyuan.chen21@gmail.com/

Xueyuan Chen (3):
  mm: make persistent huge zero folio read-only
  arm64/mm: add set_direct_map_ro_noflush()
  x86/mm: add set_direct_map_ro_noflush()

 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 10 ++++++++++
 arch/x86/include/asm/set_memory.h   |  2 ++
 arch/x86/mm/pat/set_memory.c        | 15 +++++++++++++++
 include/linux/set_memory.h          | 29 +++++++++++++++++++++++++++++
 mm/huge_memory.c                    | 16 +++++++++++++++-
 6 files changed, 73 insertions(+), 1 deletion(-)

-- 
2.47.3

