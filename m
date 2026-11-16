Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9D3606FEA3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=jt0NVq4o
Received: by kanga.kvack.org (Postfix)
	id E13AA6B061F; Mon, 16 Nov 2026 06:18:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB0C6B0620; Mon, 16 Nov 2026 06:18:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27E96B0621; Mon, 16 Nov 2026 06:18:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B131D6B061F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:18:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B55D8092E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:49 +0000 (UTC)
X-FDA: 85440734778.11.6DF015B
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20F20140005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=jt0NVq4o;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf23.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827916;
	b=fAy8oHDz0ggf9J/mpTOY4u4O+pHlsEsonfjqsQ5bjYNVXlY0ydC6xDgllRQUFY149iC1w8
	fIhj2rWYEYzH6hVuMZM1xZxVKUHAM/+xJ2e0kSgsMs4XWmdU+H05Veh1OxdTzXGlvlbets
	qVp+6FfOcTAPGtrB19+Roz2g+wnMRZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ki1kgkg1irbVoGfnzm0B8lNmq46n7VG09X3WPUY+KUQ=;
	b=vmYl76+7u41l4M5WpXOFoMfGksz9uhvFgbalZetSuAG8bZ1nddEM43c2780U+HJLLwcrAl
	YNDcicslgbsxP9yIN1grnaeEAD3qiPBZm+nIaYhtEZkWOMFEj0yaHLmgyFZ8biySpwjBYj
	37D4xXODiAipXfmLjH+6/q11/8oW2e8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=jt0NVq4o;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf23.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794827916; x=1826363916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ki1kgkg1irbVoGfnzm0B8lNmq46n7VG09X3WPUY+KUQ=;
  b=jt0NVq4onPPsDdmnYNThgr7zgHATmOoPlddVlNMf317sFpoZpcEee+hc
   AoP0uVgZxCtHoIAkAfiPX6gzfw85+1PKfHnMqYuX/tAT7TdXYKvuEZlTq
   Ce9WRowuwS+1JEEFpNHfisHDkaqIeBuu8w6p4140qQRefjxEkhh7JMT6Y
   tikRAB8i6JnoUuXitRlA1CllbW43TN2mYr82/9zOrbiwXsKa2J59EVJgQ
   pnxcjw0rgou64B7fgFIOvsKTiFZMVCu9hgIt5elecHutqGmpEEeUlTGOh
   xRGsnF1hkaTJDByTb1NcwJ/KnNtpSjuME+7PvGEx7g9G4Bpe09Qmoskh3
   Q==;
X-CSE-ConnectionGUID: HP9IQvENTwidbkcxcFr8Fw==
X-CSE-MsgGUID: 7r4RpmX3Ti+98YxCDaVCCA==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34139142"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:18:32 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:12795]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 6a985c6f-36f3-4358-8b0c-8e13929dfc3e; Mon, 16 Nov 2026 11:18:31 +0000 (UTC)
X-Farcaster-Flow-ID: 6a985c6f-36f3-4358-8b0c-8e13929dfc3e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:18:31 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:18:30 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Sasha Levin <sashal@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.18.y v2 0/2] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Mon, 16 Nov 2026 11:17:32 +0000
Message-ID: <20261116111734.3798483-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110259.2901456-1-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 20F20140005
X-Rspamd-Server: rspam12
X-Stat-Signature: s1niug39wgkkiompyxamjmcp7pqpehe4
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827915-286058
X-HE-Meta: U2FsdGVkX188oxYY1LkBp/gd18Uqi93VdOIptjKXlxzF62vfJnDfbXFRuWy99BzJQCUQiqQau4Qma8Os/Gy/D2ogV/iPmm5nJLzmTgu+U8w5Cu1F2FGFGGZISoAwxZsia4SfKvGAYKHnbokfkB24b2ZNxa1hG5D72FSPgX0fDo6jkLktQ20TPxiGSgL/+IDd5RzrlikUF+y163yUCoZXbG6mQscQXRNiKBDv50BRWYBT2fMiF6P40+ATWxsJ55gZ/535TEIDv/t+WPWeWAJA+9vcIdr6klQ1HObXhRTJecQEn8Heji6fvM66p8MeUvLki0LlL9URbLFM9/FwhqyHDXUFdNSibEsuXWJqh1J5PpDP7kqr0UPmffHv+vF99j4EDbxVE8Fbw4UDtP5VW/rxSRmMuZeorhdi1hObrtKdmRQ2stJIffqzqQ8Vo06apjmSvsrFx+zvfsEX6YjySR8lmeZ9YNaGYGf5Y4JU/0JwsTaqCY5UCI7OEj4PkVhjNZimd0/kbosSJx2VWKuzeQvvS+xhaRB25An14KtQw379i8aLI+OcEB4lsZrEtRf0G9UzYoRP079i5TiSKS7C3uEXvPxIIbt8AREqKQZ3RTAulTAVtg2z5HHVxI0lVqtVdYgVwpCallsrv0NxxqWGSv6vXJ/FhngWcxxHSb/BXURRQRqJUDebHqSCpIILFNjRHDSN4c+4fTDgDvxF1fWdGeRm+3WjyVlcUXWmsvFyg2hB8scy0i+vugEZ71Zl27PK0yrUzsPb/hFCMYrrfb1OETSLWoHXI5byYtRlaNFbRoVms72LhUGy7lS5VmmbMzZDqf30b9GdGdLCYP9JXKtBpRbiqPpVNSWbtY3UshUJpOBn9WGLyjYKtoHZB2OSf+QllP8xZehcCIJo3pinN0rNaaoJyYESG/pSffPf7bhpZG+cIdPJ/sRhMtorU18UeP4LXXy0IHbfSnmihO74MU4pkDw
 ixZmNcVw
 11ZftbE9jjpiTYgDNnbjFA68E4CHoM2B/dylwVZ4kqLDPpvbL2l9G+IlWNPK3H38vYZ68WML0r9fLslQpBR6FzdoBhVle8TtkbHmrg1DaHL8H9ZlAoEED4laUYNh7JEQBQpAenZeESxgfLfUjl7+SlGADbj3lhlKlbPchdcdPVpJfo7E1c/V++RDs6vxhEiW5/jTs0AvP0RWzyebxJ+vdIwyTxt7s/GUjSeQA3PFO1uaA8EOSiSrOyy2/kpr/bKidAMCqr4vHH47mphOKcjfbM+veK4i1IY7rb76MowHLPdQW8Pyo/048FFLEngDOS/OUkHrlA0iZw1E+/Le6+17XS49KroKkQ5+SxK4M1/cesN5TsUsxuzIm0Ar5/veAjt4uM+O5/IlsccEzL768M+PFLU1YqkpymjofcavUw1f4nGnXAEN0WbZE7tdLzkgvxIx54phaJLPUgXezB0qrdMRvXX3jAyIXBgw6kkJBEk29X955i/FxskNDPOAhT/uYJRcuJVCQaLg46j7va1sfEzzOezC3QbyzUqleAJoktH6Gh6mr1wRV6mjMFHc9lElsQwiFbqqr6OcUcHksG88ksY+mbJrRASfDlYLmMDBvO7ABquwH0oJKddLQo81QH6cfq0PSRKSd1oKVFCzAkru/aYTmOwCNLdblTcBh5M+T2C+3TonRD8uDYg6TOiJCCKVOE/+sWUSo8h0wLJck08RhPJH6mk3lB5KyFTtyt3n5d0XvPH5h8zTp5lLH+qDFi8MAFfD4beu0hHK7KPUgsl6RJts89Toln+hTG/oNt538v/Kmi6RiN3oy3fQh66sE3+SmCahWyVAqyJ0CZ1I+MzWc/CkqxFwwEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Backport of 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and
compaction for costly __GFP_NORETRY allocations") to 6.18.y. It fixes a
regression from 5d8edfb900d5 ("iomap: Copy larger chunks from userspace",
v6.6), which slows buffered writes under memory fragmentation.
Andrew and Vlastimil agreed it should go to stable [1].

The series applies on top of Sasha's backport of 6ee3d87b9408 ("mm:
page_alloc: do not give all non-blocking requests reserve access") [2].
Patch 1 is the other prerequisite, fe21f930d1e6, only moved from
mm/page_alloc.h to mm/internal.h. Patch 2 is adjusted for this tree, see
its changelog. Acks from Vlastimil and Johannes on these adjustments
would be appreciated.

Patch 2 keeps the mainline behaviour, including the THP defrag=always
case raised in the Sashiko review of v1 [3].

Built, booted and tested with pgbench simple-update (PostgreSQL 18.6,
1024 clients, 96 threads, 1200s) on m8g.24xlarge (96 vCPU arm64),
12x io2 RAID0 XFS, mean of 3 runs:

  v6.18.63               87,278 TPS
  v6.18.63 + series     154,670 TPS  (+77.2%)

Changes in v2:
- Dropped 6ee3d87b9408, now queued from Sasha's backport [2].
- Added my Signed-off-by to both patches.

v1: https://lore.kernel.org/all/20261113110259.2901456-1-dipiets@amazon.it/

[1] https://lore.kernel.org/all/1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org/
[2] https://lore.kernel.org/all/20261112171543.3069410-1-sashal@kernel.org/
[3] https://lore.kernel.org/all/sashiko-outbox-214380@kernel.org/

Johannes Weiner (1):
  mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES

Salvatore Dipietro (1):
  mm/page_alloc: avoid direct reclaim and compaction for costly
    __GFP_NORETRY allocations

 mm/internal.h   | 11 +++++------
 mm/page_alloc.c | 12 +++++++++++-
 2 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




