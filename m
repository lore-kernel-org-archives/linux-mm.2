Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B09F606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=VbaOSzme
Received: by kanga.kvack.org (Postfix)
	id C495A6B06AF; Fri, 13 Nov 2026 06:06:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21466B06BD; Fri, 13 Nov 2026 06:06:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37226B06BE; Fri, 13 Nov 2026 06:06:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B34A6B06AF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:06:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E3D8A07C8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:44 +0000 (UTC)
X-FDA: 85429817928.11.CBCE6D6
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	by imf27.hostedemail.com (Postfix) with ESMTP id DDC5A40003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=VbaOSzme;
	spf=pass (imf27.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Jq29Nsw/eEx5Hh7qSvslNVdmTpbWIfGqW3t7KRPkB9A=;
	b=UJZkRPITCN1Pj77pntw2ev6WTpCam1xQ+FyaZjwxvbhc1FpLoLAQJ27wpfOFdT5tCB//dE
	OhPcs+4iHE44q9MSte15cA/xlsvaB2Jrw/GI/UoJKfypq4ewU9lmXkxIAj1qw4qh3GPHYq
	vl2fZ6P6x5WaBB3txTAvbZxX3/YLxM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568002;
	b=O/yq8VgwQ6xROI3F+R0BcX9TwRtqUyKCat7apSnvKwdIyxmyYjR9On3vkHpZ1KVvCbNBJY
	w2JgkIxWyhP62vXPf1MvZhtCWjaIEd1Bf06T5Tr25kWGjOaKfPwoLqW7nyStB8QF1HUH85
	/bjTSgxqmPmMh3H++dLtica3SP6J1j0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=VbaOSzme;
	spf=pass (imf27.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794568002; x=1826104002;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Jq29Nsw/eEx5Hh7qSvslNVdmTpbWIfGqW3t7KRPkB9A=;
  b=VbaOSzmeljXiL5Hseu2Hof90m6/MBMQtFEGRZE3tn6Za40wuZb4F1FyE
   0bcvYR67Wy5XzlZZoukzd90u/HYRrRv2SHF6U8oAgDkKZhJ+WoaXQ4Dd9
   FWzguuxNENCbDuUkcidLiKhiwto36Fi5nqR0uJbHa5tZrp6bipIzkXeLH
   fBDpiOp2AimUuhTI4fGYsDBb9q0u2fxp6kJyOHWpAgm++HTWNnXgkXF1T
   klLX1vAZyJyrkejC8jaWMqXsAzaMKNhgMONrKhmEJXnjHilk4TXjdWHI/
   hHjmWHbsLs5koAr3n2GIT1n8H3U9QpPM8/7+uxlvLDxBVzRpd4fY6QWG3
   w==;
X-CSE-ConnectionGUID: D1YbGy0gR7685tDEwbAB7Q==
X-CSE-MsgGUID: UlK8vAVhSFmtBXcCyirhEg==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33654426"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:06:38 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:4219]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id 16f7b55b-9c7b-409b-9075-6902078ff420; Fri, 13 Nov 2026 11:06:38 +0000 (UTC)
X-Farcaster-Flow-ID: 16f7b55b-9c7b-409b-9075-6902078ff420
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:06:37 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:06:36 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.12.y 0/3] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Fri, 13 Nov 2026 11:06:08 +0000
Message-ID: <20261113110611.2915381-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: oyc3f63dkkaseui8z1isb49wbm8koqwu
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DDC5A40003
X-Rspam-User: 
X-HE-Tag: 1794568001-250790
X-HE-Meta: U2FsdGVkX1+nbZodBhdZWxyLIo9vNoLFtjuZihD4Gq3U6aG2Uae6GYhSejV3AfCq4X+yVqqEDZoP9obHYfQIOWCbGLiRXckoIELbHv7qFHfweRhqIU598KFr6tCDu1LNYrlZRjaYbo+ChnOuZMH/DpeQ4rCMm69xDSZudpirsklCMV0n9gZiI0RTftBJvl90IhsbsHeXf7wL1zYBFVVSjp8F+WLQUknGOP77FjmkKH4PyoU6uCk+WyXcNe3gRXEGHa6ofKTLhp74N0x5VXeiINckSOCeqn+wRFxzc6239Fc2SLoivGzFH76f/W2J4dxCmY/JccKJTFKMMz7w9PgTpdo5oyReeTvpKDRmLdNYIsBWpxcPbL7JbULOlO8orV0IYE4WkHR9jrq6Lp0I+A3nDAqjJByrMzWS9FRtco1MRQ4kJE0+qjDvZNwuQQgWrnQ1z7bJbeKH3DXAu48E2uZvpy8cLOT9lBGxbldb1giDu+sNWfTe1Ep3rYqgYeQtbRxmMMUle4RlQA/QGgeJ/oqgCPDDAerltyVO+Y89qOH8Hmtmz2x18bMSemfxQyyAw+B3A7/TCloisIdbz647TCY5NrLHaIiQ0jjmW7r/d5K2zAMBrVmZrJbaY+JVjif1ZxzEZpu7xGeac81/7xLBfraaiABzg2cgFdWM5QBytrcUH+ZL/A+ppTBwpd8QmDPwzLeVjGpVMhdQdcv5vIBRbloTEJpugNaZHSoEShDRCfyEBEOTuhMwS1qWKfDtSIyCdM3iyehub95Yr1OMZ5uWJxjvfDuH8xx9ba6QsJALcs4pYQhI9UdvS8R5vqn4vx2So0NDb3YO3KbRVmr8LFyJShqH6QIBHgGsNvH+G2eUYKC7kW29Ey6nvWyZK7fPOd0N71/1/BtxzCuZRcsQSOklUJiK6clbA1aMj78e2PKcLDxwHlShSMg8LviAJ/hBL29ceSSPd+fu1EWS9o5btrAXvM7
 b2Aaqyeb
 lKEHRkPSmSIHRGhu7rrUIaYUcacXXFo3/Rfsld0qtqqFQ4J//ZlnsIK5ZenaxZqjHiK835lV5sBWcKIHwKa28Q3Ok6oCWiev7mgSD/jq0u8t6YVS7wHQp14Ltrq7tbYA5ZA00uh/EClXrfNkcZkM9EI10W4htKcrzSj6ybglFuoQKS6ST8VtpjZB1wHj/0FfoXRsyQnm6GIN737QS0Wpq1dds1B4Kxl3aOtSet8y+Vz59IDA1Yg0vj0xJBOIiXw70L+uCM1dywKg5vKLYtxsixLMHzyjIEhNCTU1rL805aMm3QsnzoxyDg3fkiICPFsVY4z6iAh8GO9Lq2ByNjbaPsXEku7S3C3OAoxjfQbMpyrZA8nzJW0vUPolBcT9l5r0NXJIxfVT07sy2P+CmXmS+nfU2zvC5mYBpvquoV9qWvWg3fihS/LycEXMg8d4UMXH7DbPlVdLC6QWq6KlTttL38C+FMnrUdrmlzrPl2TEREtnA/UAqk9SGekyPED36rirIumnhlE2Z0u9HNmoPl+fe/1atPJQEBKjwAYFfCOEWjmxxrvV2N/PBbfH1TVIsfQLFIcpqQfEJoyD8QhFsTx/h8DBRo2ProQgSwcyfFCE69/RDg4pl7gEMJQLSYvupdMkwxs6zVAM3NrdtXfoHjIA7PgrBeiqb/tYwt59s7BaYaUHStvbbPT81zbc4fGXl3yYYqmk6
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

Patches 1-2 are its prerequisites from the same mainline merge (Cc:
stable), only moved from mm/page_alloc.h to mm/internal.h. Patch 3 is
adjusted for this tree, see its changelog. Acks from Vlastimil and
Johannes on these adjustments would be appreciated.

Built, booted and tested with pgbench simple-update (PostgreSQL 18.6,
1024 clients, 96 threads, 1200s) on m8g.24xlarge (96 vCPU arm64),
12x io2 RAID0 XFS, mean of 3 runs:

  v6.12.117              87,565 TPS
  v6.12.117 + series    144,458 TPS  (+65.0%)

[1] https://lore.kernel.org/all/1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org/

Johannes Weiner (2):
  mm: page_alloc: do not give all non-blocking requests reserve access
  mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES

Salvatore Dipietro (1):
  mm/page_alloc: avoid direct reclaim and compaction for costly
    __GFP_NORETRY allocations

 mm/internal.h   | 14 ++++++++------
 mm/page_alloc.c | 16 ++++++++++++++--
 2 files changed, 22 insertions(+), 8 deletions(-)

-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




