Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B949606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=BEg8tQnr
Received: by kanga.kvack.org (Postfix)
	id 769D26B06C3; Fri, 13 Nov 2026 06:07:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F23A6B06C5; Fri, 13 Nov 2026 06:07:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609136B06C6; Fri, 13 Nov 2026 06:07:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1206B06C3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:07:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01C7380670
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:07:41 +0000 (UTC)
X-FDA: 85429820364.17.38805EB
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf12.hostedemail.com (Postfix) with ESMTP id C63F740008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:07:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=BEg8tQnr;
	spf=pass (imf12.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gj3HoWNEdcXUIqwe/gBb5WQmn/6jT4sWX+r8pFb7IGI=;
	b=gSSnBvyNpTiEhiEZ63DyyEwtI19Uvb/XvhnkY/8PVM2yX8tFH51Ak4aJbAX0nzn0g/8M2t
	5re67PvJyxtgpsopz/gLKlWHMn03FPCBWkTZ5zLzVAnq57XINWT7g+zorBnUDqz2OTL7Ea
	89QstgL6i8E6J4qtGSYD9Uu9/F8hZGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568060;
	b=cH4uEqUH07GHUfQIrz03Bc4dpwN44Mp32IuyfFU60pB+sIjMdvM7uPViGuudGsvQPlEoYa
	tNov7wq78pySxN5kZlLKdH4MN7CnFyvXwqjpsqNf1YOR+vz91xwt3bZmtByB4HvnlqDSlk
	K5Q8Oqw/DpKAUqtjW4lMwXJButxPnaA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=BEg8tQnr;
	spf=pass (imf12.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794568059; x=1826104059;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Gj3HoWNEdcXUIqwe/gBb5WQmn/6jT4sWX+r8pFb7IGI=;
  b=BEg8tQnrK5JRe75DsCBhS38ayc7z7LQFKd+qHeP3ghxbHtcKNf5A3lMD
   pWhM+4Uw3gRsJ4FiObVfk5kps86wyLkre2r9t+90cP7fFJPxyUyzgg9BT
   gexy9BpmZuzFUVvCthT8amBUQ9R9/BXEEAYN8xT0w8WATew+0GuEySQqt
   DJAXuX31L/gxGtkhIX+cqXx7CodqlCWtwMXbrHIzaiooZXtZ4WYS6bkFt
   aEK01JKCsdXeH6hHT7o8fBrz4DMt8M+cUF3CiTveTIiCmheBCvJLcCCz0
   5vhCeiUsdOw3ynxoOkdAbayXXQdBWeaQCzTdhLl5C7VW7UERmbpFZrxNQ
   g==;
X-CSE-ConnectionGUID: vlBfzprRSBCgq4e4/EhTgg==
X-CSE-MsgGUID: s9Q2zoMMSbyugKE3CccnBw==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33792832"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:07:36 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:2974]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id e3bd98ca-d8e2-4122-a144-737d8c8b7749; Fri, 13 Nov 2026 11:07:36 +0000 (UTC)
X-Farcaster-Flow-ID: e3bd98ca-d8e2-4122-a144-737d8c8b7749
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:07:36 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:07:34 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.6.y 0/3] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Fri, 13 Nov 2026 11:07:21 +0000
Message-ID: <20261113110724.2920455-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: fzyx7shu8sroyr9nizgjnnioa9zxgsxp
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C63F740008
X-Rspam-User: 
X-HE-Tag: 1794568059-896286
X-HE-Meta: U2FsdGVkX190eaxVqdBzfjdVRv1leWk8KY0nmJqh8tE8YUOxHBvDhUKnd2EK6l9iBzxtG25jXI1K4E60MfL7yhZ31T1pUf/0qC+WWk/6HlEazc+yRyne83giioB+wJI6C7pRYfpTuoGtuhG0xn+6Wv2kNJULZ8Ils2iimzJ9Dr/a1/XStxQjtBAdNRUL+NG6LXJ0/NUJtkV/jsplGoyzPuL90AKsMIUQ8yjRlpar61/QWQ6HXT7o94bbdUxHLbaHB2KX+o5jXloT8d4Q3XzPjxPDNNZRpPC6E65OmS/8ZMEqzgOaVmNZ25zhHF1XmlMAPRQIwlvFK6ZuO/iKfRCUv7/5LRXAlw9B26nmrmesFYkjsm6i5Ifm14yF9nqqQ/pAFHRSB2dnULTcW9qKaOZ4Hv/HHEB8n3EWZMWwPSUGUkwZDW9Yz2eCdcheWb+STLfccvoLSraP+yJkjYEf7WzDn/c0lYN7j3GokmstjMCuw1UJmGRYzQYEcfd/PtJcc4duCJkVRdH86jqtukiK5KkMmmE0XRkVSkg6QGCwn7In6wBRUmNCn+Dth6tzaMgcQGWgHd6TZPPen4PCVHgxT9LsI/mVzHSkFWPQlX/UzbbYFkZk8dNPD4lLKlrHEOc+1+mQlyqcetgGNYry5VfzIWgYK0L1BOz0wR7N6fA8SFFMlD+yh0He10DkQ2ZY+Tt5DIgJdduQk3htqfIJVc/de+J5uLSVHtKBo2mZCwQWE35q+gZdC/rSCbh6h2S0kPRVXS+FIwCLRrxCSWf90CqGX918KYyDaWK7oXtSrq3Lrq/iEpWmN8ihoSn2Ua97Sl6a0CZMEav3fNqvhVkpKl8uvfd6pH+PFB8eo886/+4E4i7ID7hhsDVWRUATzb3wAPhg5wPqtOkuKnQmDqL75OIwlH9XtC83G7JTymg01g7Uty8SC5lTt8RedWX0ZRIb4Ee8SClTSaziAmJ8scrdnhesfRb
 QemX8OYF
 dfQsQTgSjb2eLqhVcVLA/GILwHThmu7k16QAnCRB5xv0Q7oZBpsBd6ucd3U3cfJua34dgibOMfa+rOIyuYauIViB1gkoq5l6TaS8l+uz1tievQgrAekF/hGoz9ulVObc9hX/e4dqE33pNDfcccCHjDNef/3XuIHfQZcW3ANVYP1lTvLzYhkULVZZj11NQyV4WJW/mjo7oKofANeThDlKDLHEwKvWkdjXXMFWV3O5vO2v6Z0jm3OZ2Zse6qL3fXIWfHuLrS/GRPKEOmSiE/G9k28pOGkshB9YhXHC0NNy/vNCl9rpJc4Jorn1gfEDNjFlyNfk6Ip5o+iWGcQZYziSLOeqkC1gBeydaSyOFAVlxWzDLuGQ5k+7N1na2qOuHKoKMvoqHTBKAp5nBGFXyRUuGu9EKdSU+wVT7nyjdoGYeuMGJK6F3FZYiynsiEVQJ9L8ebVl0dNtQYWNR3vYHDhsooLT9H3pCth+dBhjLK1wh2glGThKuTd2kIlN5QUyYI/NxSpIAOK0DS/T3uwbNIqbh8sEjNwkoYJ9yVWW7IX4xvPgG1ZR5WWAXfqH41eKVw/g9DH/R1UwDASwy/WulOsWI9rbd6EerV62LUdRPTIPideART0rArmrRXTrLTk86NIDjZZRG7RZGErnTmVnrZs8TE8XJKA4Jl6RbGjM/wMB8kSdnUVYlUvrW+yAbfbyQvcb+Ne5I
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

Patches 1-2 are its prerequisites from the same mainline merge (Cc:
stable), only moved from mm/page_alloc.h to mm/internal.h. Patch 3 is
adjusted for this tree, see its changelog. Acks from Vlastimil and
Johannes on these adjustments would be appreciated.

Built, booted and tested with pgbench simple-update (PostgreSQL 18.6,
1024 clients, 96 threads, 1200s) on m8g.24xlarge (96 vCPU arm64),
12x io2 RAID0 XFS, mean of 3 runs:

  v6.6.162               93,808 TPS
  v6.6.162 + series     159,670 TPS  (+70.2%)

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




