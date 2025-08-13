Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C060CC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD109000BC; Wed, 13 Aug 2025 13:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DC4900088; Wed, 13 Aug 2025 13:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CA59000BC; Wed, 13 Aug 2025 13:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4353900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:53:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B1711DB501
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:53:44 +0000 (UTC)
X-FDA: 83772481968.09.9EA7C6A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6BDDB40002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:53:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755107622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=OyceOdpHfLwsfhvuMKGP5wYK/mN4SgG7OMbdOTVEmGs=;
	b=bF1MGMdwKRSveOd+L4N5EibmuUChimaAvfvAtwlny6gR51WtvAyD20wa1gYXUmAEmz0G8B
	eu9mNKMQuC4PLy00FkObbI8q+nlJdk2NdZEFD939AXw4nQ0Ysia3EK4/lXednDbd2mdEf+
	L0Ro+JMghs5XHNUGm1CZ1x0IzWfu358=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755107623; a=rsa-sha256;
	cv=none;
	b=cCg3vBoolZtqJSlvMJjaIBTB8evHRZdNGWhXuLWDbEM+dDWdxSDr0Fcru0ZTow2ij3qZiE
	cPgXLtMB27NepyKs5myQumt2qbf7Occ/krr1RTud7ogdqeETaHcBTyemGmJXabhXYHoOnj
	wyw3BMSb8lEOfL0Ey1lVl+qIIvQm2S0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D3F212FC;
	Wed, 13 Aug 2025 10:53:33 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5C05D3F5A1;
	Wed, 13 Aug 2025 10:53:37 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	scott@os.amperecomputing.com,
	jhubbard@nvidia.com,
	pankaj.gupta@amd.com,
	leitao@debian.org,
	kaleshsingh@google.com,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io,
	david@redhat.com,
	yang@os.amperecomputing.com
Cc: kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2 0/2] introduce kasan.store_only option in hw-tags
Date: Wed, 13 Aug 2025 18:53:33 +0100
Message-Id: <20250813175335.3980268-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6BDDB40002
X-Stat-Signature: 4j3656jjbwy3mhponcn6f9pqfc1ha4j7
X-HE-Tag: 1755107622-388348
X-HE-Meta: U2FsdGVkX18sH6utuY4cOYaNHtZty9vaUG2x2dI9Zra+CJE1mRpIkgVKNnja/Fvh8efngRIMua8UCkiq1NH4XRuLPoiPeiINBLvUhV1OpWREtGDZ5rpri/A9gdq4fwPPbJgM2a5J2gF3Tp6jBmiQK6Ukknzkh/WeZ4tDqJwzy0GYb4cfdT5RwN3b3QsCXmaMMqANHfcrzMmn+wAb3mEt6nEo5FADOcr9R0ObCYBjBdlV45mH8UlQDXvRurtX89r9076WqlUudavCu6jIlh2FGn8JlFnQy4SwEvBusqZn8yAa/lSTfMEN6eQQ0Lmh1K5UvGcOjUFDFHdbGJ9OCODHQwsZt3/CTTBTTp6TtyB2s6TF7Emnnbz+GBh3CRsqNVrRfEG/2gOdDvTRuAEw5UaZ6EbNoePgNeEngltumyh5ymt76bSFKJIMusS6gKQX2LphPHA3Q8Va5bvF/h8dzPqw41ZfNK7zSQwl4nV08YzyBeWaz3I/qcrqUyVrP1NYBTNpLQdhaNjQMdxTHFKNnh7B9Q/6pOQ5XmILuSQDQKPFPcGxMPka1k0ZzLGtE8ZC2L6Xo+8TelMcGNeUrGr+KXdaujH/pDRUupDW+LuE1WqgtIYkzqnEOhcbpu4+9L5cKP9QP0Y6IDyImoZ70FOQ+zOLLKFrkEi3NuXum/G2dhzd9tz9NC35oxzd/H2r0CxWghwXvPSNBj8HjvlPdwegNTUpgA+/kUsJ4UUPvYVS9TMAtPQYRfwjf+5BmkV+M1mN5HjVjpDBW/8Kn97+Wrf4ih52kFxNVuU4wzCTMqnNjPz4bNNHCsP85Ke1Vfv8aKuQArEWgrddeAfGRWZ/dNHW3s/Olch/lIoYY23N5aKIy1KvFC002IN4ZSESj5H8MuyRIRojXNSIkGygDe1iCmsr40IaAe9B/Yj07kdUUouIuMn33BjR6TPqJVX0sSh+dyKKlhUddRfujWEvvoSG+AdDbIA
 5rovz5KN
 0A8efIn2xk4wzVId/JeS2rWfInJj7kB0ofQnuZiERG4Sfb/lwDpj2LB5t8k/KjbMo8MWu+84dgd/jgkZsoUJqgAKjNO4TuIH6P0lAMH8U0VcL5iWrHkvpzISol4caCzSPWCS4CKa2uqG5joPB6To2o9qk3pclic/ISDfMwAWVFRRdhltiK1ED6JwH97n9oHl3+7GIR3U74ilQTktv5KMc6qSFdnOOAeRcpN+Lxoq5ej7reaYWeVzZkMXlSTdHLHjyyZtMimirAs+d1bfSFodaBCo+rbYRseyGC4eKtfVm+SehXTE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware tag based KASAN is implemented using the Memory Tagging Extension
(MTE) feature.

MTE is built on top of the ARMv8.0 virtual address tagging TBI
(Top Byte Ignore) feature and allows software to access a 4-bit
allocation tag for each 16-byte granule in the physical address space.
A logical tag is derived from bits 59-56 of the virtual
address used for the memory access. A CPU with MTE enabled will compare
the logical tag against the allocation tag and potentially raise an
tag check fault on mismatch, subject to system registers configuration.

Since ARMv8.9, FEAT_MTE_STORE_ONLY can be used to restrict raise of tag
check fault on store operation only.

Using this feature (FEAT_MTE_STORE_ONLY), introduce KASAN store-only mode
which restricts KASAN check store operation only.
This mode omits KASAN check for fetch/load operation.
Therefore, it might be used not only debugging purpose but also in
normal environment.

Patch History
=============
from v1 to v2:
  - change cryptic name -- stonly to store_only
  - remove some TCF check with store which can make memory courruption.
  - https://lore.kernel.org/all/20250811173626.1878783-1-yeoreum.yun@arm.com/


Yeoreum Yun (2):
  kasan/hw-tags: introduce kasan.store_only option
  kasan: apply store-only mode in kasan kunit testcases

 Documentation/dev-tools/kasan.rst  |   3 +
 arch/arm64/include/asm/memory.h    |   1 +
 arch/arm64/include/asm/mte-kasan.h |   6 +
 arch/arm64/kernel/cpufeature.c     |   6 +
 arch/arm64/kernel/mte.c            |  14 ++
 include/linux/kasan.h              |   2 +
 mm/kasan/hw_tags.c                 |  76 +++++-
 mm/kasan/kasan.h                   |  10 +
 mm/kasan/kasan_test_c.c            | 366 ++++++++++++++++++++++-------
 9 files changed, 402 insertions(+), 82 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


