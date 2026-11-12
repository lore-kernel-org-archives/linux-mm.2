Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773C7606A335
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=W57px+Te
Received: by kanga.kvack.org (Postfix)
	id 825066B05BB; Thu, 12 Nov 2026 04:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD016B05BC; Thu, 12 Nov 2026 04:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7127B6B05BD; Thu, 12 Nov 2026 04:42:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 510F46B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:42:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D97DC1A010F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:42:24 +0000 (UTC)
X-FDA: 85425976608.24.5743CCF
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA3301C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:42:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=W57px+Te;
	spf=pass (imf21.hostedemail.com: domain of "prvs=769decef9=dipiets@amazon.it" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=769decef9=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5FhPhptoiDnbvGobJSg/2oYz4NalMfRC1p+IyPS8BeI=;
	b=6607/QeHSUV2RfmasNUYEmiczwA/OK0esu9SBdmhikJ84bKyPyKWOOr5uJAlNZ+18x1off
	3NEjq9Km0Ve9D4IQatVEHc3W5jJwxvopg8ScDohBW/f8x9Knzy6+UYWILrw/A7NraATGcs
	tqrvmIbCEK5ODW1Xt5ppiKF9EU2KIh4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=W57px+Te;
	spf=pass (imf21.hostedemail.com: domain of "prvs=769decef9=dipiets@amazon.it" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=769decef9=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476543;
	b=Bbrwy2JvY1b/wK8KVoHor730bMuxYfnavKkUA7p9a7h/PD062HPyLvv1MKKYRlAS3EEwm+
	R6kiJ+L9LGMUyIQLmpyqzt6LhIoQdakgMXnXsiCMFTMFQhJo4Bp10OXuLWjEO0nJaNYvI/
	HJrxJA4t4faD2uQbAO+dEKPmRteZvQg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794476542; x=1826012542;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5FhPhptoiDnbvGobJSg/2oYz4NalMfRC1p+IyPS8BeI=;
  b=W57px+Te0+mIsygB9ENiCJIxVjOskwOJDEwZ+6UOKWJ68H9D5xhGbhc8
   +8pci46EllQNhW6BH1cNI6rB3GkcD/ndHLNUh0bBLq9KaNn5iicN0VJKl
   BaDw+Uef/xbPe/3he9FsbzgzQIzhBL7KXEgFqbwqzhkNB9KyJfYgyy1wd
   s0NjEmSxZxmXvAXglKipaJkStxr4YeaZvoppSgMkSsW7Wubcvib4GlOe0
   PYyQhA0fq3wmNTGDMb59lXg32u7lYn/dmwuWgr8LFDZY0xJFQ9LLnr8so
   OcpR6xRBZRTu6cPWKQWZrYA/pCRL9gyqrMjbfrs2QMe1Bpn4yVs1SbrUh
   w==;
X-CSE-ConnectionGUID: pG+pAsDBRd2ZShkzIRXO2g==
X-CSE-MsgGUID: FQuDohEITmWX7HRwKQviZg==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33702422"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 09:42:18 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:3788]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id 191c253e-7415-4cf6-b337-d056f3a4794f; Thu, 12 Nov 2026 09:42:18 +0000 (UTC)
X-Farcaster-Flow-ID: 191c253e-7415-4cf6-b337-d056f3a4794f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 09:42:18 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 09:42:16 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
Subject: [STABLE 7.3.y] 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations")
Date: Thu, 12 Nov 2026 09:42:05 +0000
Message-ID: <20261112094205.994560-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k6gurguqkhtsyeddwt844axutbpxe4cq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AA3301C0004
X-HE-Tag: 1794476542-694513
X-HE-Meta: U2FsdGVkX1/O5AOZkSTkqMrJ8IXZamCT8NZS0NJF8cOQTflcAm98jytRCbRPTf42AZEapAWLJfSgz4MKePtXDos6HDTl9vTCfVlhsNszDR5aYwqAlXc1XB1mL5GDx9Lk9j9B+xWZvWuMQEJyRSJi+4aAUVeHzQE38EkUDYrxoBQzWxpzry39Nsh/MAPBXqapvl0yA5LmHZ3vM6txJmTwRzRQgjE1bzAyJTvM3KNFTTJDBZ5pA01BKFIv/pcALjHiW7EMAPhC1aSHVUGksYi9xoVN5rIbES3YsUvIAsVg1syiSFBnP5EbKkS/K3huQeb2dJ6Kk3fpBMezYPZcfjqhMKfaJSY+qTv6PacjbafCkbA/+5sAzqMZvzLwyz6LQlKxzhhGksV0YBgYTKJSHlE5TNZ6l/QcLNFsHIn7RaJp+fCdzuq5CQaMQv2kYCxb55u4eY1tVrsV2v1yeYlo1Hr/uFYHs9eYvMdwD9GT5tYjmW6mnWcrXICp2XI33dp2NHggO95d7JpoEfzQiSq+G3XkhyvLvBqdWno7KB6Gk4TIHskJakchHD2mkeWN7r9rPxpR+R2K8zZgice5Ba7CD9MoBtros88OMa+joD9BQCfS9XAse6tqHO3dMIyIpVYEFd7QfrqkBPWP+NwZUEUJPgPG1wuZbPr3VsRyqmd9W8bk8bTd2lJX9pCsvu42Y5KWDlu9jUxCcl/wCQFqKtIMCIVKRzIw3jmH8MS0BKKQAnW9z0B92qv0hv2YifYZveUUHmcBWidAvkdifH57ZDfEFoStiw6cHhoVS1ktVoX+Fi4UXsXDtaRm+dQchRF4FWUM26kYmSSntxUsH8iJzaBPSbAD4V4FokbqXTpt7Ie54IyO4PmGoP/QMZ4ShVmfPibBL2zCaiYEr2AGk1qT6lp+mtltlcwrQ8ZI1i2MksBT1V+L/+oH38O7zt6rBcnSRX7o/92PEkg58/BPC4Kd0mNcxff
 GRkallL4
 WY+vhrh0fRxOEB57JpljEq5kTydGR2eopgWw740LXqz67fXRvNw/IWiHEsWBYe+6RrSM0g9RaxJ6Gwbrd2tFkvaOTqhODixli0XvkXNE7nvdiGqIJdt6kRF3tl1kgJMWBZ8p0egOICRE/G1bsnDCjns7ZYaejeqQWOEBi4N8gOTS/JfVly9iTlQ4ercS8wnQ0v1ytBvX/rp5MBwbs0rwa4h1XG2FtKZfOq/fdN5zJKS597j9lUDc0HS2OyeIB8bdt2gsUyoXYZfz2+OLAqgyEPS1pm3BIm1PSYa+tlyRMJQTDOs9m/iTc4gBC5ZN9gcRiMVqec/xaq6Tx47VZmKcYgit6AcesogKYx+TEl4yzXPPmo5AdcKOwvfb/rFOArIRYc8nRbKXxbgDh5OiuZRvAXWpXoaJwVDMMJM33rqpLO5ELvI2SeDoc4FRaANYXD9pPM9D95Up8JwQclGgmmcbb13itd0JHJsVYLLPitkEm71hvk/vsxUeJwV1oH3cCT+UpNXOGuhHevHOljgYyHu4JI453ppRDpQiCjUx8bMOo4GP6z6Vc1fayiujoNnbBwXWNJONLeyPQkvQtpEnNeMWlWZJWRb3qQXeTty/+TGVESr72IIYLosmr9hhFH0w6/dBjFrJfjXmgJBiJGYWCPhsXIvHFhmJexxS2WPrDuxPbK4bY6dYNk++QYKodY7mcrqBTyOejycqd9BKPlitxjOXSpk8THQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Hi,

Please apply to 7.3.y:

  0e05a469c294 ("mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations")

It fixes a regression from 5d8edfb900d5 ("iomap: Copy larger chunks
from userspace"), in since v6.6: PostgreSQL pgbench on XFS runs at
0.38x throughput. Andrew and Vlastimil agreed to restore its
Cc: stable [1], but it was merged without the tag.

It depends on 6ee3d87b9408 and fe21f930d1e6, already queued for 7.3.

I'll send backports for 6.18.y, 6.12.y and 6.6.y separately.

[1] https://lore.kernel.org/all/1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org/

Thanks,
Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




