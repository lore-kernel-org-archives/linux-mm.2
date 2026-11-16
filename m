Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6145606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=P1rMI0kX
Received: by kanga.kvack.org (Postfix)
	id 039806B05F8; Mon, 16 Nov 2026 06:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011136B0608; Mon, 16 Nov 2026 06:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44256B0609; Mon, 16 Nov 2026 06:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1A7F6B05F8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:22:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F42BA08AA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:55 +0000 (UTC)
X-FDA: 85440745110.26.214D369
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32C7414000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=P1rMI0kX;
	spf=pass (imf23.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aW10dZOCDVLhX+LRThn+G5BuApVtmzcnsTbZKWxJ2B4=;
	b=AgJMdPalm2OMgqznIhLfbK9caMjWfxzRSvabrab2qI4CT9WP/SnPmlD8FCef+sdAkSVUlX
	NKyxR5INEHZC2FGhhiPtfndovIk9XnD3GH+RbpG5zul/MVz/S17jqh4I1wB4S97rrW950w
	Yz9p9soTqhMDJ0CjJKcDv0rLLe3Er84=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828173;
	b=dCy/xCBXaHOv108wnqvW4yT8hUE+0AR1wW/JWnJ2u8CRPmF6yInhDG13z2iEO0n4lTTkwJ
	znjjmReV2XUR1udzFefT0Ws2D+d4hNFwzu3pEK0X80HcPz444PvbjJ5mapKKl0UUPMf7aU
	HTy/ujnjaTfPHzig4FNNEeqVm4iGz8w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=P1rMI0kX;
	spf=pass (imf23.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794828173; x=1826364173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aW10dZOCDVLhX+LRThn+G5BuApVtmzcnsTbZKWxJ2B4=;
  b=P1rMI0kX9LGdj01fYP0X7V/2A82XG0u5u1yLG3IWkmNgnBon/JSe87AB
   qa6VBVyt/l0wy1e5LOBTBl7dYf+fELggDAYkouzK4MqpxEmrY+b19YYX4
   QmXP9XtdecDO2/3GRZgIodfxzduNqBtVl7OFxD+EnnafXppxJ4e51F8Gs
   NXuG0o9DAUZCBAsxXqQE/9EYmtVfEnwWKriqADquvLnBjS8AsKU72B6jz
   RtbfcgeXphVLszUeiCAhHHUHzkS8gkIP4aIkKkt7uipCEjW4YsxJooOHt
   DU9uPRBw6IP32lU+1gxFovdOyW6qwDL7RN9a7YrUQ7C6rMCd7+nTv7Vm3
   A==;
X-CSE-ConnectionGUID: 6RlaTJZTQKGfwWQ3fjh9jg==
X-CSE-MsgGUID: iT66582lSwWykIVIEx0EVg==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34289709"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:22:49 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:26291]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id dc406a10-dcca-481a-a992-1204c6fe75e8; Mon, 16 Nov 2026 11:22:49 +0000 (UTC)
X-Farcaster-Flow-ID: dc406a10-dcca-481a-a992-1204c6fe75e8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:22:49 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:22:48 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Sasha Levin <sashal@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.6.y v2 0/2] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Mon, 16 Nov 2026 11:22:27 +0000
Message-ID: <20261116112229.3815501-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110724.2920455-1-dipiets@amazon.it>
References: <20261113110724.2920455-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: o7bdb8mdr9yczm43honyjhq9fp4picfm
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 32C7414000A
X-Rspam-User: 
X-HE-Tag: 1794828173-268248
X-HE-Meta: U2FsdGVkX19GLCwFN/WLUrRtPRR4p9Ik5NRuecLDp+uG40B91FWulbamZ65F9/XiVsHII91xlLijQPEaRYfjjr68atGS6g1yljFwXlZAEdu1MCT7Idz1L8UxegytpyyzdbGI0dNc8c1i76Yq4wItCQaZUwwH3lZZg73BJl02oQQjT9bFiCmmAcYoUV8ACftpBw/NsDoNJK4gaqFuW2FG+TFMzaLdP6mRIE2Gw8hSHXy+jOBgmibjOfEfMMwzRrriNSTg6xdTRBTs8UU+xE6arEBTCdGfei/WLpog8a0RDVve3uPOfTOPl8OL8gpWOOAJAYBFio5SUy/nU0TKGC+UAEq1iEmfraK40bzeac3QiWc1R+jB60NBEf7sN3QHNycyZk9x1IG+P4ayS4J8/qfAehY6TlI8Dxhv38W2RrPd8uxTOMDfgHlSWqvmsw0Njyn10M3WMSJ0F0vYhyuF8J6hQqdo/Vhe389j/dR5aCXAdDqB29B8LCkCyKI2DNKt1h9/ZvJz0Eki7UmCwWxHN3kNM+7B2H34bUe2OHQp73HoTDm09JdU+wVYBVgtyfXvN919JYc5en3aeClgZSmFez1GeREONt9PMLwY4XuOBSxBgimta8tq4AoLVKtLIA0JmvjLfRSJgtcASnJM+k0Vc2lRsLXxJXE8TAATo95gEPusa9e2IJCVYIn7khhJ+XFGkRzWa/W0WovXSscs3onewLpITqjbi+S3G1WRiLIXa26ifxeKWvnnmA7t9y3cGrnMwAdF6A9GJAjZVWb3+a+7Irn4IuaJY8UGkp6ymj5N/J5+aWh2kEbuBZykWFMHlvuvP4okUD05o7zcF+Imuev2MsAFYPtZ2snBP21zdSz8MEna3154H7b19gXPQ6tCM1DrYbngpK1oP/0JMNwrnWo0WFi8k1XX+hAGkIQ5EuNm0eVk0LBbE7bn3YtBLbJdtZl65E8Zt6GUjc3UJVFs6KpsmmO
 TGIsYkA6
 U0PnQTH81+l1jl1uOlm6Xa96al1qMvf/o/6SEkaGy2AYC7Be1fFAIOEYpj7IDv5qYIipynzTGFKcf2AY1KghYeHaRg0VyP0PcHLz9fLRUDOSChAn3H0Nfij4xd5bhezd9mlObawFD4RglZDFhUID7XBeZ02oYYx+cGsPt0RtykW5lVK9mOxf7VOxE1jjw64PT8rve3Pt/Jm42JacRrFnLP0uSxU9OVqV9M9v3aT7ADa7+si+nPdF7yoIejiR4AkCsLrMCGu3PrySP9J5kOnupG+Tmzs3HOWUIMpH3uZUEAqVYSYjGJBC4rqKq32I7Ga7+i6m+dWEC+BBgDNqfFUbO1a2MZOyL45hZbH5QVheoTkpZWNs5qx71Rx55myGQEj1g6nH34jt2yZpJ3wMCzoJRlb13VhH6FXZjt6GvSJWlJgDw1k1TvkQdS34Ef8caMVJEr9TUME427BL1DDBcpk1hTXmSPVRbQOnYXiVHRgUAiLxNCaMMu0+EYgy5Ja8afVNYtkAQu1+WTFDC7aO0kMqNAkmDRggQuYEw/2sUsPzPOgOdkm77zWwqx+hGaetBwfHztKlm0tA5tFpg44ne8o48tcInhLrGnEXJqgcC9BI+9So00Pmw0fX/YerX6OZwEXiLa84jeQtf0ErIMDMj7GRQHxzPlc1tVK04JoS0PbmZwE0FUtSAGwImT3/YcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Backport of 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and
compaction for costly __GFP_NORETRY allocations") to 6.6.y. It fixes a
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

  v6.6.162               93,808 TPS
  v6.6.162 + series     159,670 TPS  (+70.2%)

Changes in v2:
- Dropped 6ee3d87b9408, now queued from Sasha's backport [2].
- Added my Signed-off-by to both patches.

v1: https://lore.kernel.org/all/20261113110724.2920455-1-dipiets@amazon.it/

[1] https://lore.kernel.org/all/1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org/
[2] https://lore.kernel.org/all/20261113005511.435938-1-sashal@kernel.org/
[3] https://lore.kernel.org/all/sashiko-outbox-214392@kernel.org/

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




