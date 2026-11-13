Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5603F606B261
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=qF8Nvtci
Received: by kanga.kvack.org (Postfix)
	id 230A66B06B4; Fri, 13 Nov 2026 06:03:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA4F6B06B5; Fri, 13 Nov 2026 06:03:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0016B06B6; Fri, 13 Nov 2026 06:03:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD0E26B06B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:03:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 075F1C0791
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:21 +0000 (UTC)
X-FDA: 85429809402.09.CF99BD5
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf05.hostedemail.com (Postfix) with ESMTP id DB05D10000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=qF8Nvtci;
	spf=pass (imf05.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794567799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rxpebwgxAi2rpMQVYH2/YieUDfApwWMHIlSz9atE37k=;
	b=UTy+ZGBw12aC2YszdTUQrgF6/Kr4kUE/fRbRtbpPX1M3/XLP6nXGSKScdMXDr7638ZI5J2
	wJ+JNWQvkF2752gG9CJ3R4YxS6m0OpG76cJ65aP25gKBVB0yPz9iAwNePFJO7Q2Q795XOx
	YZPowtslDr/+2fxuNQ5/etxYXQjvXQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794567799;
	b=PShm4LQatbBDjdDRP+wliUQUAz6irJphFYNx0CIAV9zDG9HsWtlnfPihPmuwWA15yL/bPn
	Lats9ncfUBTqqq6XZNSi2V9rvJXI5wVWhL9cia78U8gab7oVr6sKmVU/sbFmmLpk28j0Y2
	hBOqU1C8MuPcuHzx618XAUXEVUUf4FQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=qF8Nvtci;
	spf=pass (imf05.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794567798; x=1826103798;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rxpebwgxAi2rpMQVYH2/YieUDfApwWMHIlSz9atE37k=;
  b=qF8NvtcixCyRwOn8Tud08wV3zhyzeXWBZa3T3UHsvqYc7fjZwZtHehET
   Avp9gf5Htdv84ex4BcLIjMlaWBg225WQBBXrScvqYlS2564xA9KoB2Byl
   OSl8DR4QAKqCttzwKK31IQMT0EuX2PmTWG6ap3AltejtRS8PyLrsxU5yZ
   FaX+c7n37e9DwFNcTqI/MF0P6OavcryQxvyvH5z6lk1RkNk3kPrkkM2qf
   +70RgHxbQs6s0S0+DErrTsVjo58kMU+AI2PPwLi1uwfb5yO215PcXeK9H
   8X9mx+MaWTfUf9FzeZBH1q9X1dvslufOMbgdPQRSaBptMZSL2GxZro4O2
   Q==;
X-CSE-ConnectionGUID: iydCxRSzSXewt4ZzwzSvgg==
X-CSE-MsgGUID: pE9VtNAcSJypVESQgYT0GQ==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33389046"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:03:15 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:10011]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 961ba48b-c7a4-4592-bbd0-a0083439ac97; Fri, 13 Nov 2026 11:03:15 +0000 (UTC)
X-Farcaster-Flow-ID: 961ba48b-c7a4-4592-bbd0-a0083439ac97
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:03:14 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:03:13 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.18.y 0/3] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Fri, 13 Nov 2026 11:02:56 +0000
Message-ID: <20261113110259.2901456-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 33t8qjo4moodmtojpapemkw3sauagduh
X-Rspamd-Queue-Id: DB05D10000C
X-Rspam-User: 
X-HE-Tag: 1794567798-737018
X-HE-Meta: U2FsdGVkX19D8zYdluhFzSKld2HiJ/n/83NrWGq2GTnIGgQ/6OqKolYW9m5M7nxZHxqLngpHmL2kZCGSPRLOGcTHZfQ0cfVPpWJfyn6dn0DxMyHnK/AcXudRuLa4SLPJnpoCb2ID1narbWLAEc994THZ07eXXWmmPdPGBEX9EqiWdMpLJztgu66nL8X2XQ7Yju65NlCN1aeiE1cA3u404ns0++kItZ57cXQPgQwe9O6D0A3Z442RoS34WiNrCJ/ZcTi/29ab1C1NrchGmoEFlEn8ctO3PjKfnJYHbAnixlBd+YgfGn0q9pM48ZgoX3YyrzSyFbrIJH2Nb+LZ54H6y0HeDLANbaF9sVhsjIeZhaswhQ2fEWZVrTKtrU+LJH9S1li9/4W6y1DEd+3+bKeKe55grZRfWOn+9MwMhhYsLPsQ1h5lWP7GE+joooX+tNeidDU5fUnXkEu5F5Zxax2qMgYKxPcjPOF1r18ZvqSUP/RFYQdiPbljqbPB2KcHxR00vIyF9U6o0w4VFkcOPjx/91BGjYiFiV+4qmewmWNU6IaKp90U0tJVqzeONe3Ity2zg8GDmUyFaWIFfbT43ntu1ddfQUkVVN6ICBDStZNLbDcJW7gTekJCD/bNvop5nSDFhZVnuPqWiSQFuJCYPsXOWGGf54OXTbV03TDTd9FMSbr/jVTF3SzZdGO4STGou0QgkI70qqVX59b+wH7XQiMfLcS8UWKZu+6+sukxw5ceG2AFpeob5dbGMNGSRaPoj8GkzWf52v2gei/gTmPc0cDUozKbWy7uEpX5IR6wRCetMDqRKft0OekG/v7RNqAJACf8j6+MZErOn6c3XIINPInYfy7q6+mWdejwLUAyT646GWnId2DdIoE5ENYKEDqhX+EDh0q8GNT0uQFsTrgAUs1RJLP8o1Unq0HBQd/wWrJeQfddcnksp/tW8UcsMUaJnBFWRC2C+fj2NtUJtYQPsVQ
 5ZTdclXq
 ZScgyZtYxPzt9JeWaIUsPWE5DgjrHv+Cs5XmGVPnbn33Z2QToMiNBVQxXHqbaPoF8K2StUKA5Mufes6EceOplhR5NYUkY+YTyVwQdgrnKRmwUtiLCHekDH+DTtvcSmIm8yYJwNSXO5v6x7KA+oX1LMLJ2696UuP9aDZC+ObjiRYaGjwmU0ao5wPlj9g6J3MLuV6Rq1mjcC+tAEbAfWCgCo4LCb2ibCZ2bOWcH2ImDTPB+ZYg7ZkBxovAFIVpD1FvKOVuMiDgfgCzMY4EWnyY9ehwCWwkqO3++c+iTURXKMLUlY81+pw19CRBibhFThf8+EKqae3s1+I6fk55uET16eRoFFaa4LhU/X/ZnPOVxU+NhlxDt7bbrn7LDQT7lgXHqzD5QuzSuNtHuPkvxpt7IzP5/60r42gosfU2PXrxvs0Kt1LzaDSjQ3nK9c/p/Uyc1Qy2kh6xzAWL/DAL4cY8Ai0XFuzm6v4J4ZLIBRnX6cAEofTBnOWH1A+7/okeWeaqbWNNQM6gqz0sfckhFx5JMIX1Vodw9irN8hkAhJWZUIQA/x9xXYmapLMBOVDUalCOuUJLDEovCR4+Jw2ak+tdrgMV1UsVYzT6Da7PMjQ7AGPaM5r8T/ZbKM5Eiduxot2Po8oGjsydhU0VHWi41ksEbLBHzhiRUovc4dEtdvdWF3wLmP69wHDPSQwaJkA==
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

Patches 1-2 are its prerequisites from the same mainline merge (Cc:
stable), only moved from mm/page_alloc.h to mm/internal.h. Patch 3 is
adjusted for this tree, see its changelog. Acks from Vlastimil and
Johannes on these adjustments would be appreciated.

Built, booted and tested with pgbench simple-update (PostgreSQL 18.6,
1024 clients, 96 threads, 1200s) on m8g.24xlarge (96 vCPU arm64),
12x io2 RAID0 XFS, mean of 3 runs:

  v6.18.63               87,278 TPS
  v6.18.63 + series     154,670 TPS  (+77.2%)

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




