Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECEDE60A260D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZQa6Iju4
Received: by kanga.kvack.org (Postfix)
	id E8A716B05B1; Fri, 20 Nov 2026 12:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E142B6B05B4; Fri, 20 Nov 2026 12:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC866B05B5; Fri, 20 Nov 2026 12:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 967C86B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:48:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 189E6A64C7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:48:08 +0000 (UTC)
X-FDA: 85456231056.06.A24C38B
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf20.hostedemail.com (Postfix) with ESMTP id EBAA71C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:48:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZQa6Iju4;
	spf=pass (imf20.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795196886;
	b=UecrvA9P6f1STKRQEoZVEHIBAUo/r/1gDrB+oHWSNdflkRFWCGOPCjqTu7tFUOY4y8bW3+
	4l2cQy9KpWk7b40CE3ssBhT5ZOMMJ8EFXcS6jdqqTemAFPRisZGEHr6P1SBUfNV08CF1Wx
	ZdMgHQ43Ju/rd7X79/qEWqhbdoywL10=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795196886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BRbB4TeEbeDPYP10r5R78d5DnXhIf+696YAbQVI6b1I=;
	b=33JiJqXU+OBwz0kzTPZuNZy2dWX5tBoJ6U+pEBmVPhjg2nshJkU1tVdHXGgKwtOJyVsJAI
	NOpv8dkwlvG/sY6STyOxkzj7AZD/XDjGiH2mTkdDGPuCl1h6Zrppv2EJ89UzSxqJT9Ymlh
	tL4hP+TWTPcQxFFrnx8+4n1wE99pjNI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZQa6Iju4;
	spf=pass (imf20.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1795196886; x=1826732886;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BRbB4TeEbeDPYP10r5R78d5DnXhIf+696YAbQVI6b1I=;
  b=ZQa6Iju4Bn5d9UBitjDHnbGqASvIucGy9JvsCD7A4zsRZaTxQoASYBrY
   BzqXZTw7RZhj36EBz/L/pVUCmyQ2S4N0Y+vt1UnQ0ak+iklQj8K0t857u
   EIZe/N8P814tkX9Nu1tRsl6rVoV7C/KM9KerRNPxERYgKvY1vsRqqvHIG
   UAZTJw4PH1LBFqZAvbRgcmp6VIzw2g0cGgSaHyMBbSbK3CSm9FPb7MY0n
   2U6urITQ10OKIpbX920C7kCSGMcUJRBup0cL1nGN3r3uK04sQtRq5tWY+
   5tHvRBLr3vU0V77kJ3dm7mSWrj/v4pnW4Y4f3cLXGUp+swZzXye+leGg8
   A==;
X-CSE-ConnectionGUID: Q3ofdov8TCKC2HnaxqewtQ==
X-CSE-MsgGUID: 5Jiw2TxURRiOZZBwsk6NYg==
X-IronPort-AV: E=Sophos;i="6.27,223,1787011200"; 
   d="scan'208";a="34540198"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 17:48:00 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:28745]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.13.177:2525] with esmtp (Farcaster)
 id 767f9935-a099-439d-9b67-2386925f1139; Fri, 20 Nov 2026 17:48:00 +0000 (UTC)
X-Farcaster-Flow-ID: 767f9935-a099-439d-9b67-2386925f1139
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Fri, 20 Nov 2026 17:47:59 +0000
Received: from dev-dsk-gyokhan-1a-87ab81cc.eu-west-1.amazon.com
 (10.253.85.128) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Fri, 20 Nov 2026
 17:47:58 +0000
From: Gyokhan Kochmarla <gyokhan@amazon.de>
To: <stable@vger.kernel.org>
CC: Mike Rapoport <rppt@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>,
	<linux-mm@kvack.org>
Subject: [PATCH 7.3.y 0/2] mm/execmem: keep the ROX cache huge-page only
Date: Fri, 20 Nov 2026 17:47:43 +0000
Message-ID: <20261120174745.3785179-1-gyokhan@amazon.de>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EBAA71C0007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 4ycnnd3fdyt96x3ezdf8d3nn7ro4fbtm
X-HE-Tag: 1795196883-939785
X-HE-Meta: U2FsdGVkX1/5pRi/Ka/24HTPVTQ5qVa7IEkhWFAYAskWL6QODbPK9lX1dBKZ7u7rok29uanLpwUi1rGnDFoRCZWA2HebX3dxKlF5jcae1lKqBqrkZKAyVE5WDMKryB4HFPOvB4dBrMoQ6tyWyBkOIGfMozBsTDw41SxWANvy6+Av+BC/k/ZiZrMsPXeJZtQJ/6JibX5SACQ2zy3oD6M/XWMbwk7QFVh1ACj2Hxx/vTQvWT2tSkLc5duAZeBHoDop7GUgBizo13r7nbR3a96btokg5dRyqpfzQFpP+N3SjgBP/q5O5EDOYo2X8EjY9Om5qvJVryPgEopWIFruVHUgMRu6ikDb5J1iVZk4t9cxkIZAB0NLV05eiD4EJwNQVSMTd21ERCjbeLq6EW+CXQLrnpJ9/K7oioZrH6CIetCLlC700OaF0YnVVmtmmYPNYDfr85yq5SGe0cF/LuN6QkQqakE3BteAum2F95b0DBWp9ZFfl2UnukzbPrXVwKv12FV1yNTajTh7UEgsAtsSYOFxYAD4mpzWttftIIlm5z6Hme5EuLXFbWykky7BDD0P94uz00t3EKspZf3AwfzajJAF3zgtInGTIQ9a5jtIAhudpwu3+vmaxfElXvgxMIYRaN0Vj2Ah6LBWKfv/CdCpA2pmUP1VGhQ1/JTZIl8f9vO73dPy3g8AZ7U+G3avw0PknIAm51rmEZXvWG681QQ9ZZKRBvsTwzOlppbtVkpxM4pYWd/hAr0mZ72JhmHK+I21i9oCWCXSqS4C6Hn/MVWk9YLA9ZYSHAogJANk/LluCIhQwGtzX05oRtbcZZcxAa8tedlgX6gaR/Dd1TSxXijUS/F5VgLCd6DE0dAJzvxxBAH5y5kajdkNX7Pp4pa0w+UXMM4IUGA190pVoOq6UoUOAK0HsOJ4CE7VFezPw9HeAW0HvYmM7VrzWWWaUwvvvnZSYLRoIHo08q0EJMTfj1OAPwZ
 3iHPkjHC
 OMAQSIiowAlZXyBB1dSY4dgl21It4yOmPtGwtugPU9C+AUv0j7vX6vok8sEa+ORxhsWH2OSy9ubrLZ2Jf8ailUmjMwJsf6GKxG7bWsb8PdIq111FRfFZ2kF3FfTucyDwg2V3C4LKmBQyBX1q7F7HC282w9hMHolylEwOTSq48mwsW/SOL2OWGmUg1nRwM7otad95yuIodRb41K+ZlZWgo9HQnfpt17PCKuu+QGnxjNndKCwDbzyN1mWhONh8/JaqIftj6LYkFJyj5sxvTADLzQaV0100svQyhZdowUBmH6e4UdeYXmOFWUhh2lNXqjdhK34F4MQTJQbjmzSm+l9PHUZVeMX9Ivh/p1RqsbOw0rPT77Hgmj69Oxk/VFcfU3XJbPJgu51fJwiAeL5TERGGBIZo0iOfdHKXmy4xJooTwHsAfJ7bVUiDQfmh1zDiX5tvGRkGLdKU2ETMGMdTWK/vkqZ6wR/9jATS41vQTDXDsInTJlw+oX02t9nDkE7jqs3r9OU2Qf2bbXgNY9LogbLNWuXzsIL41MJpOUIQxzqkf/UyywFlwtlGflt5Ps7KLSn+PnL+Y1IgFhwL/PQgDVH3Bt15PaeRAbSajBmmsQCxUFQfpoKVg4fUta198YZNHePXq+4zbvyCyMDegIAPyP0pqmfUeg6JCiKxWyV6GrRKytGGPQqMn/8VGDc8QWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Please consider these two mainline commits for 7.3.y:

  d80773cedde2 ("mm/execmem: handle potential allocation errors in the maple tree")
  569db54d8b7a ("mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE")

They complete the series whose first patch, 52d95a55a011 ("mm/execmem:
free ROX cache chunks only when they span an entire vm area"), is
already in 7.3.4 as 8c60564f03e0. The same two commits are posted
separately for 6.18.y, and this version keeps 7.3.y covered for that
request.

On x86 systems with 384 CPUs, udev coldplug runs several hundred
concurrent init_module() calls for the same modules (kvm, kvm_intel,
irqbypass, x86_pkg_temp_thermal). On a ROX cache miss,
execmem_cache_populate_alloc() reserves a 2 MiB area before it takes
the cache mutex, so these reservations briefly exhaust the module
address range. Each failed attempt prints "execmem: unable to allocate
memory", although the exact-size retry succeeds and every module loads.
The exact-size areas then stay in the cache and are never freed.

With 569db54d8b7a, the cache refill only accepts a huge-page backed,
PMD-sized area and fails quietly otherwise. The allocation then falls
back to an exact-size ROX area outside the cache. d80773cedde2 is a
prerequisite.

7.3.y does not have 4c4b2ed5b783 ("mm/execmem: use
VM_FLUSH_RESET_PERMS for ROX cache allocations"), so both patches keep
the existing execmem_set_direct_map_valid() handling for cache chunks.
The uncached fallback is freed with plain vfree(), so it uses
VM_FLUSH_RESET_PERMS like the non-ROX path. Each patch documents the
change in a [ 7.3: ] note. Mike, if you would rather have 4c4b2ed5b783
backported as well, I can send that version instead.

569db54d8b7a is above the usual 100-line limit. A large part of it
moves the ROX setup into a helper that the cache refill and the
fallback share.

Both patches apply cleanly to v7.3.5, and mm/execmem.o and
mm/vmalloc.o build with W=1 on x86_64. The code changes are the same
as in the 6.18.y version, which was tested on c8i.metal-96xl: 20 and
29 warnings without the patches, none with them, and no failed module
loads in either case. I have not run the 7.3.y version on hardware.

Gyokhan

Mike Rapoport (Microsoft) (2):
  mm/execmem: handle potential allocation errors in the maple tree
  mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE

 include/linux/vmalloc.h |   1 +
 mm/execmem.c            | 109 +++++++++++++++++++++++++---------------
 mm/vmalloc.c            |  15 +++++-
 3 files changed, 84 insertions(+), 41 deletions(-)


base-commit: 988117cc1bb17338c586a4e21ade88b5397eac33
-- 
2.50.1


