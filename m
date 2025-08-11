Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDE1CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1922B8E0060; Mon, 11 Aug 2025 13:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169D28E0045; Mon, 11 Aug 2025 13:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0317F8E0060; Mon, 11 Aug 2025 13:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3E4B8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:36:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB57C1DBAEF
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:36:37 +0000 (UTC)
X-FDA: 83765181234.26.DAA1810
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE84CA0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:36:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0J//ZXltFEFiHPuvSR5EwE7cIsv7sl+t1JLUFLvA0g8=;
	b=FN7rB8NnwEKQ++Eeq4QupZ651NKXyrYFNIQUf/GOSLiPFqNnBH0elWPHzRIjI09iWNXRcm
	kRYlBuqwqAjF3h1I+/hCfmdheM3SBDRuca9b5C/tPINo3BLzhGZnSBH6mFiFI0tORdyb0j
	rjUibpHJOcZXM7Krwryy5uRuyLnaZ5E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933796; a=rsa-sha256;
	cv=none;
	b=Zu3a7ZsbGSR7n0aTk8GX4EnYnybwjiB1VjkOaJKZTqFyhl6rl9NcCfWE4zuGus/qNRkMTo
	Eq6RO+ziodabo5O4wMLyTx2uFTbNsCbSKclTHGFnYQ438b8HhYYklbsf75OPU1NktUu0lu
	JJ6eQAIbXp3XBHk1AdUEfVDas74/EW8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96350267F;
	Mon, 11 Aug 2025 10:36:26 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CDA733F63F;
	Mon, 11 Aug 2025 10:36:30 -0700 (PDT)
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
Subject: [PATCH 0/2] introduce kasan stonly-mode in hw-tags
Date: Mon, 11 Aug 2025 18:36:24 +0100
Message-Id: <20250811173626.1878783-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE84CA0003
X-Rspamd-Server: rspam06
X-Stat-Signature: usqh8zsnth4gti71emgwch1ytr6e16dn
X-HE-Tag: 1754933795-941599
X-HE-Meta: U2FsdGVkX1+Gg++lIgDLtnkO3cRWqjFA5Clj7Xmj8Ckjt+D6IduQRrdtqFAx3nQ91y9YZKOIabeeDsvXbbCEHfxfsb7zL30lrLf7+j2c4cCbzzlBAHiS3TcdERp2GwQgTDbNQH9Ucpn6iFJ3UQNb9cdUrqYXWX2sum0hFbTsRI8esHvKDwx+3T3uOSRdjyj8OIzLDTB6yYhBDqoJIYk6joSqs4YKXZ7c34GIekySMRLkQCZZq2BRHF2PEvSVdxozK5XJzcGEPZEgYHhEfGq+uSrN1S8WCTtKsb52D2boJwN/pT/KywFIqEgHXlwG88965Q1x7EWKITxwoiR2RCrvvpTocxSXNSQ9+jJgXsGGfzDBVCQWKS1gJmRZCdFclbRtYxHPfTy5mZnb8Htmemkac+cBWGqP3yQwWjhaU42mQpCd0V1TseHS0zLLa7xY5ZwNMXxG5gymjn9u0C/3xW3e+JfAmCBHsT97lb6D170903hixlglmA2pIbxGc1fHSpx5JXcAv3xSIcIPZ/nhY+L6swW+gOqHEFI3SQP226k6XCemnUcbfhV7jjGGmpFiwaJlV6hs4Q25ZlXlEKkhHQMOPvyECAUT/AXDY1SnF0NeSMNOWhxCxYhXsqsiwyF14mJmrQuS5Mb1y/LvZjAEphhAb+fO1QOzvpcQHND+iuA3Ej047Uv/mRnUVuqv5ya0NdviVEIOcOdsYkfGP/lYwdBkuhMCFsXtH9u4NY0tAXJYLtgdLnAAitlGjwoH5pkxmaK1nbQsOEMTdMarGzrPpq8OLU1CNdlpkCCLpFOg2vcQDUKoTk+LHb/jca/oAGCUdqkxEgIDE8CFAOIa5AQAosBTyxP6+EdzlBTJjYQR51QSLgIsvO82IJmtAe1Am55DO8m6R0Wa7mZtw7smc7PFk7B3vVUCaRMtOATg2UqPvZBioUzP+qTdjUtCt9pPBy/yFxLuyrLhRkEM0d2R/M0w5Ry
 AJnhnXA0
 zBuMLvak0WxpRKO3DMADqJVBAyJxcrWpfLHYloEANAv5LeMqUBnAxtffBRx2G8rx3ohL/HsvEsK2tq8Herjxk8NMZxrGqBGH4xcQrgGoBlZduyNfggN8dh27KVyoWugbHBCDf9R3FrlRVIq3YJpj0ASnT6f7GvuoTAYFc
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

Yeoreum Yun (2):
  kasan/hw-tags: introduce store only mode
  kasan: apply store-only mode in kasan kunit testcases

 Documentation/dev-tools/kasan.rst  |   3 +
 arch/arm64/include/asm/memory.h    |   1 +
 arch/arm64/include/asm/mte-kasan.h |   6 +
 arch/arm64/kernel/cpufeature.c     |   6 +
 arch/arm64/kernel/mte.c            |  14 +
 include/linux/kasan.h              |   2 +
 mm/kasan/hw_tags.c                 |  76 +++++-
 mm/kasan/kasan.h                   |  10 +
 mm/kasan/kasan_test_c.c            | 423 +++++++++++++++++++++++------
 9 files changed, 457 insertions(+), 84 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


