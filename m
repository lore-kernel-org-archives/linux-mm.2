Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB40CC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BFB6B0092; Tue,  7 Jul 2026 21:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4116B0093; Tue,  7 Jul 2026 21:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F95B6B0095; Tue,  7 Jul 2026 21:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51DB16B0092
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:53:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0FAB169000
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:53:12 +0000 (UTC)
X-FDA: 84963936624.28.68476F3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id A3AF4C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:53:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="KJlQ/PQ2";
	spf=pass (imf10.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783475590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EuNCwAq7Xsx4Ipxaq/SKekSGNOTNlTJ6AghU1Hx3eUM=;
	b=D0Z/s2xfCiZ9lIBqV2/GHNyaD6pvFJFB1YxbK+s8Gd7heGopZoEdjchGRMBllvyX8ToGoj
	xxJypkbc4pGTfqhQsvLFHjRU1KTMvu7bVIa2B5Drz9wopiCQlQJcpBKeuSbxGHcmOVlnWs
	LmzcpqivKL8b0GdGgc5HT0N2mvFkB/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783475590;
	b=oaAclBOksdWEnMbCZ2RB7NL0y5ZY2hy+pVXq2xx0LW3mOnIws5wb3VfoiTWb6hnal4Gsdn
	s9ovYXJrIdAYenqIW0TuNlZn/LipYMBSeADeFrYvNxdTZlWA+RCHP4tQWr3ejij9kjNkSd
	zA0E6L3BH86+OpEOpBbUkhHMPGYG9G8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="KJlQ/PQ2";
	spf=pass (imf10.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667MmNNG184091;
	Wed, 8 Jul 2026 01:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=EuNCwAq7Xsx4Ipxaq/SKekSGNOTNlTJ6AghU1Hx3e
	UM=; b=KJlQ/PQ28kQ21nOTO71XM0kDeayfthZkDQzrcdjBij6THmYtiIfB5yP+7
	EMeChSyt90F1f8cZd9L76NuDiVG0Uc8Z3QyPqp6CAnnWqCYxZElIIMZWlOnoDlJO
	qVQb3TUfsJB/7okPNC8RkOwZNsGus+OUrF2swNrzQjLQPsMNVVMWMq146OzlFWIL
	4oQ5A5aBuXsiIwVq6T4UGKtLc79dHIWN6xHvqIpT97uyPIKxKrTY9fC0a+qaE4QV
	sJ8f+tDxKOdxJxg1uDZ8jbIxNt8bc3p4bNBU7nTB9C2TLDs5s/vm4h5+V4T1kDTd
	70fLYEJ42CTOX4K+rE44kvoZmXmhw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f6rkdtndn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 01:52:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6681Jt6x010737;
	Wed, 8 Jul 2026 01:52:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4f7cvw5nh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 01:52:58 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6681quUB48759254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jul 2026 01:52:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A549020043;
	Wed,  8 Jul 2026 01:52:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47D8720040;
	Wed,  8 Jul 2026 01:52:53 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.39.25.106])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jul 2026 01:52:53 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Luiz Capitulino <luizcap@redhat.com>,
        Sourabh Jain <sourabhjain@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mm/util: don't read __page_2 for order-1 folios in snapshot_page()
Date: Wed,  8 Jul 2026 07:22:52 +0530
Message-ID: <20260708015252.296103-1-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=M7J97Sws c=1 sm=1 tr=0 ts=6a4dad7b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=rW-dpPW7BJeVnpsP6a0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDAxNSBTYWx0ZWRfXzdA5GwOMpNr1
 EmdXzsLS3tOFDSBneoT4iC5XZaJdneSPKvTkfSuKFnls8uTuyL2NMNqEm0ny+msgnWSW+0ZQBQS
 aIH+rcXaLRtZs2FQfXnzwQrYTovi5p0k/1dwqcsqDmn03BPtu41UFwLZdLQw78tiGxR/48yD9OS
 KO96aD9QyY9HZFoaBLfaZJ/dFsh7rtdyxDp+kme2fDJdTBBBpvF6U94k7LQ8AwVjtRFTbe43gm+
 UqHdp4vA6NvCDTgSCDUakOPgw8PqglANCxdScS+ulNQxZTWZeLk4Vu9SWLqFi8UosoHcK01OcNe
 eiDk25ZAdC3vflTgQJ8bkhohFt2WSb2IrlL37b3G9enEctO1aYL2/83WcAKPYVxRHbPASQeu8rk
 OA1IUzidjxLxMC0Mzkz7gzQeqwpW7YSTjKRzdZOOViD8B2U5uAjaDXAmyRG/9PEMhmrBlRnCL6N
 Zj/M9rBDfVT2x4YsKdA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDAxNSBTYWx0ZWRfXxu7UD2VapGHc
 cc3MwNMoBvG8gS9NVihhtBvTRBbtZcAaOChGLxin5EZjpvfROO87cgfvlRi2OOpFPqt1+d4rnXv
 HeiOXyitYP8t1VrBG6M5soheLWfUU8U=
X-Proofpoint-GUID: qeiHoXAqPbPkGirfdOby0GuvzEgfuLiS
X-Proofpoint-ORIG-GUID: fS1IAaLB7VVGfl1SPbn4NIvQ8xZrAmNN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1011 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080015
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3AF4C0003
X-Stat-Signature: mr1kso67nukrjh64etrfcwcwru5ojgkn
X-HE-Tag: 1783475590-147457
X-HE-Meta: U2FsdGVkX18PYTmlPbiS0nuwYhl93HQvU+mUtcZ585FGN1cXLZmbUOgzXK88ud1bUggbDaaHBXIj6XiYXEjnO97/YmXF5p4/R1HIN5HBC+gDSdHAk3Gegdfj8e6jGZ6bsw53lI3WpEp9mCsJ488kc1zuUY+58Laqd6sMPG/w9+APBrvU1YxPaIWfg/9zWPmSzUbtrdCf8+JetWh7LLF8lNrNYTSSLrKsJB58t5PlUv9VKasYdof4xz3KLl0Pzyy/VIzD69m+gXULfZQ6lqi161DpH5iJjDT0MyvvzjBgUjNRqu2MHio4ywFDltbRJHt4fIgaoqabNyio7Qk1CThLMHF0QwOSAc+BQBu7cGOI/ak7pBQtb36v1MkiLMnCL0g5FD/WZgSyydsnmysBuO1dbNL65NB6UiBcVDudXPdIcP8UaYrdsPWYGdmOjOsBRtZ6epPZWcrxpb2efoNXYtAs1QGTtTXArpFoLXqefUM2lfNRTdLMj+ETSBmOk5yMA1fxM1QcuKAe1TIiNgAMBwSEThy6sS8MA+vgrvTSr09tRDhAxgkUVpZ1nW6mkIOjFG1PvxsJsjsIdI3thDaLG3FuBZuvoO+cQX/UQavktlC06Sm35C6aQ4c9DYsXWqybYQXxNi9JndsXZdU0NR0dHw4Lg7VrxLyX14Amw6Ir7ynHMEkBzmdfa+nhpD/2cIzMjoZBqUrLTvUioTM/3JVa9s+Ga4WDuA9OCtTbA140Qzl0xDz/50jyFYAEX5gk7tSb7fHB4viw/62xrt75L0fbaoWPzCf9IWmIP2wfFBiaDwM9vt+nLKhqbixDH1NkvcVk/3Ws7NQPD6WKp4UVbSZaiI6zwBbnCbK7pe7oPA8OtRe3PdbZb78vrprShKT36oRQ5SmO4Eudp7IqQnl/PdyR21CS5XVtr67IVHFa1sI1ydC5clE8jDWdfp0o93wsmP0aoO4uQKAn0bcDC/FyQB7GRyo
 V5UZAH5Y
 aZQ2SfLqNJknPINGLwKjfsd7d/+mVj101U/XZTYoH1O55fgPDTLtdF8xaREZ3z+M/gGUup3q9PBxRW+M7tbbuVcTFtCslouP/cptWJj071y5odX5jRQxr3VeZ/FLI9+xDHRUnpY0A7Vz19aRp68Z1Jy8Q2I1kUFnxUX1FoL9Onc5UawvvJboeYzgkn6E3nIKt4MXG/SUT33tpn89t1XU2TesNB7UlTCi7kXugAs0EKgheobYpdtwhh74l0uJMcz2EV61Tm1MbUFd1gIZSAQm60ewKzzo3fSEA3RJSADaG2FYI7KZWIykHx7aKrRD1uAy4fXfyXzussiKuYgCPkO41Dnsk2sF4aSVmqc0b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

snapshot_page() reconstructs a folio from a struct page.  After copying
the head and __page_1 it reads __page_2 whenever the folio has more than
one page:

	if (nr_pages > 1)
		memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
		       sizeof(struct page));

__page_2 is the folio's third struct page, so it is part of the folio
only for order >= 2 (nr_pages > 2).  For an order-1 folio (exactly two
pages) __page_2 is not part of the folio at all, it is the struct page
of the following pfn.

When such an order-1 head sits in the last struct page slots of a
populated section whose neighbouring section is absent (a memory hole),
__page_2 falls into the next section's unpopulated vmemmap and the
read oopses.

Observed on a 22 TB ppc64le LPAR during DLPAR memory remove, on the page
isolation dump path:

	offline_pages -> start_isolate_page_range -> isolate_single_pageblock
	  -> set_migratetype_isolate -> dump_page -> __dump_page -> snapshot_page

	NIP   = snapshot_page+264  (ld of __page_2)
	r4    = foliop = head = 0xc00c0005a03fff80
	DAR   = r4 + 0x88     = 0xc00c0005a0400008   (unmapped)
	DSISR = 0x40000000                           (no translation)

The faulting head was a free page that still carried PG_head with
_nr_pages == 2; its __page_2 is the first entry of the absent section.

It is also reproducible deterministically in a VM by placing an order-1
folio in the last slots of a populated section adjacent to a hole
(memmap=nnM$ssM) and calling dump_page() on it.

Only read __page_2 for order >= 2 folios (nr_pages > 2).

Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
Cc: stable@vger.kernel.org # v6.15+
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 mm/util.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index af2c2103f0d95..b3d48a05e6d82 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1353,7 +1353,13 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 	if (ps->idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
 		nr_pages = folio_nr_pages(&ps->folio_snapshot);
-		if (nr_pages > 1)
+		/*
+		 * __page_2 is the folio's third struct page and is part of the
+		 * folio only for order >= 2 (nr_pages > 2).  For an order-1
+		 * folio it is not part of the folio and may fall into an
+		 * adjacent, possibly absent, section.
+		 */
+		if (nr_pages > 2)
 			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
 			       sizeof(struct page));
 		set_ps_flags(ps, foliop, page);
-- 
2.54.0


