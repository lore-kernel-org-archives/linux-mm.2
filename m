Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466936071B39
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=X8+2OjaX
Received: by kanga.kvack.org (Postfix)
	id 5B54B6B05EA; Mon, 16 Nov 2026 06:22:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565656B05FE; Mon, 16 Nov 2026 06:22:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B636B0600; Mon, 16 Nov 2026 06:22:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADA96B05EA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:22:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97247C0928
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:01 +0000 (UTC)
X-FDA: 85440742842.24.9DC18A3
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf28.hostedemail.com (Postfix) with ESMTP id 534D2C000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:21:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=X8+2OjaX;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf28.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noCYfjyXVIMbbLN6Ti74onkf+XgPewQsAqDuvy/OF9Q=;
	b=2iD0aEJYaW/U9NcUPWZCBwY8/igowcnbyfYhlo2B+TUtsvYvKnzPFhfDaBg8oC8KY1anw1
	3ThcD/l/wpp9Uca5M0CX1D/vZM+TPsyQo2RqB9LrMXJnt+k1ZZMQKgE3/5Af7bft64TGK5
	sSCoi8h9YBgQAv0Xq5RBH0WDmoKDAdo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828119;
	b=rOP1qt5bB2wuGtQVGOM+iyUXzyKxby2WTIFXLziAGo2HrhkiTOCZLmbNH0ZfhYoC3OOpnd
	tw15LY+pt0e9Z+54l2mGYk11cpufbjv0YwsJ1L4hWY36aBSOiXmONLzqhuI6aQX8VBtNip
	VO+DrScN9EoBBSkCxwvw45Y2bFMAcUs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=X8+2OjaX;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf28.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794828119; x=1826364119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=noCYfjyXVIMbbLN6Ti74onkf+XgPewQsAqDuvy/OF9Q=;
  b=X8+2OjaX9BeRYsFP5sf147Tn82f4JmHrtdSXL4csOG7FAHl87+nLmKh4
   8UX1S7rW7VUB3JXr+ONWXpnvVeGHO9w0fAPP1CtAN7f98Le9gTzJc8vNl
   83sJYgMZ0/mGbTLFcFpNMCwlIVZnB3e+Bnl8JE7Zrhwxlzsxzr2mMvoHd
   n2/+WNaE1u/aKweGKj5TADaOp+HkkLoE4cVvGV4I3Oz5bdV378/UbWnlz
   pftV0gpqUeVtfGI3SYzUQl3yECaB7up+QEsJllxSEyrX7x6cL9+K2fwQp
   ZU8ZN7PjejKEBhgy0R1Jj6qTCyH/m4zVy26VLaIJqZDX5YcyAAcuIfAtI
   w==;
X-CSE-ConnectionGUID: HyzXHEqkS16Q+NoYWQHUFQ==
X-CSE-MsgGUID: D4zTA3UQQyWh80f/zai0fg==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34068360"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:21:55 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:29002]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id f60cd348-5baf-4a64-9388-a28c25dbb758; Mon, 16 Nov 2026 11:21:54 +0000 (UTC)
X-Farcaster-Flow-ID: f60cd348-5baf-4a64-9388-a28c25dbb758
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:21:54 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:21:53 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Sasha Levin <sashal@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.12.y v2 0/2] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Mon, 16 Nov 2026 11:21:40 +0000
Message-ID: <20261116112142.3813013-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110611.2915381-1-dipiets@amazon.it>
References: <20261113110611.2915381-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z8ffx7of19o65s3f85ppwmowp7rjzboj
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 534D2C000B
X-HE-Tag: 1794828119-282715
X-HE-Meta: U2FsdGVkX19AL9sDdZVyYgIQDaBdI2i0kLWx2ye/OfMX66OuzqYNpENZ0Z3efeYhqFmPK2euGlqB0pYiStbEYOlLk5wctE8G85UH8Vp90302haiJlUmTskVB1CgDEnv4qhOe2qSzNgyJrMp4LYQsU0aKFsfX19LuGpAy7B/yYwBpRLBYbB8uzlU2Wrqal0+b8qehZxflO1muiTUtA3y8EHF0cPYGSZw0wNj7pootX2zdqd8K94GQd/pK44RVNhtwEwSq0ArKeyIgPBvL8UQdP1phIPGcIuPwWVKt1esn9BfxUD1vtDgUskEda4dwYIbPuDle5ZFLnCehkejc4SVDF9HUAa15Kj1HZ4/5aT9WetqwyTv6Dpd9Ng7DX2V2XRTypHFm6yVO9BQ6/pPD4BXHdxTO/6TvKkVnhw7ozgxd+Wtmw8MCavQiSENM1rFSgjUxrENU5SsAvlYR3SBqFeddkyItGRrdztmUE+61fh3t8lmbbWumHNU17xrCelg43G0v6MbRIJoMQHwdXm3rOhLbJhYkvf1pPrmmCZFmV4VdJZZSYd/Tl4sykeD0/ojLAUYoNMRBBbORwd7B8BdDaWM241n1dSkg5b4kISAHzMOijAZADPdBbEcXIEQCPeWU4UxwCcW3mGfph8mSty0OsNmcQQ1Fovq3tvnXxDHM7wA/LfQJXiE/GHlJJUME8kkiSQYfE7KUaKYPtwVdeSVKIkeDhADJ5DcjQgZ7a7j7j8hh90POb5SDGLq5YGXBal571oWQjXcGQERbmi5bOeMhnpNBbjkv6xlFf+++K9hUzin0Y/uBvz2yh20R3QEiTPsVsE7PZ6WdTjT24JZmdVRbxkoNNPFDakAXiNkCDu7ij9Sr2veQDzNJJGs8SFn2uiQ2pNcprNYBBpx40EbShzd+2/jOzVDXlofxoJZi7MoN3K5+JEQCbKlC4KtbgJHnWJpXFM3tOIbR+8iVUicCrjkppi9
 oJex+fh1
 z7xUPamTz38h/gjzwnq3JvdbE16TIJtb2PvNlzg0msuyDp2SDEo9wnl6yKi2zqaOdnI6FFFGvkvJWGsD/Z47b7hWgir95cifcJlwJpdOicXCpew9VKmQkMKXhr0heVe7dqPZWsQ0HdCxgN6KhwK+yE1rmcE+zoLDz6ityNvxJhP1+X9GIenUZoJERVePB5oU1E4pFCc54Bb30sPlY/GDXqKpGlKo80TVp2mQzAN3OECsDS7q5+qhmcH6vM3sE9cqMjEP+N4j6S8KbIcQn2mZJsZk9zseTq+V8z/OtmuBF1L3LN4ZWV3230yZRxYZc0DFXG0ziP3P55aCs8WiD4pVJxDQ4EYCx/87H90LyBOjsltnoonnAWBQedwIzuwcTDp+76cTISsv84BbqYWEw6ZF9abEQO+zbvVGTrWcWVdLf4p+OQdA62yQ0HvzzWlEhq+TvDYEW2uS1956rju6satoK7IXVNvysbiVhrywgVR00B0GV1AXrug5awGOh653OsBrkUArQNOqsRCQcSQnkkgWZ5seF8gyt2sfUtFkfetJ7mFvjggoWO2byVUhIOYuNrLC7kktafMi0b9FlA3Nv0OsY0fI0qf/f9xrK/SaPiY1FuBPLfllxZLNShpiZGPmXTkx+SOequiPrJ55n9q8O7XafD2UO2XDHTgJQq5KlUQKtCiU1RJgOvXK8VEGT1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Backport of 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and
compaction for costly __GFP_NORETRY allocations") to 6.12.y. It fixes a
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

  v6.12.117              87,565 TPS
  v6.12.117 + series    144,458 TPS  (+65.0%)

Changes in v2:
- Dropped 6ee3d87b9408, now queued from Sasha's backport [2].
- Added my Signed-off-by to both patches.

v1: https://lore.kernel.org/all/20261113110611.2915381-1-dipiets@amazon.it/

[1] https://lore.kernel.org/all/1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org/
[2] https://lore.kernel.org/all/20261112171856.3309378-1-sashal@kernel.org/
[3] https://lore.kernel.org/all/sashiko-outbox-214389@kernel.org/

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




