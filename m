Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BAB3FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3886B0005; Mon, 27 Apr 2026 01:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73BE6B0088; Mon, 27 Apr 2026 01:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90856B008A; Mon, 27 Apr 2026 01:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA1396B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:20:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54F3514071B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:20:14 +0000 (UTC)
X-FDA: 84703184748.14.EEB3CD4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 094F480006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:20:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kexT6xKR;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777267212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4nEsBxBk+seZw+u7Xx1eDjzz9+lJYddsqvqoTmtvDQ0=;
	b=qE0xzrHnBu5cYwBftSZVJRq1FmVgmHlOc7l7ic4rZlH57DJ6sK5amBCAMQiVuwVgvHpseE
	ocVGQgi1cDhJ23NIMUZq4j5qcjSE7DSj1IZ+lG5rhalSVKFZN1IOow4v/eHMiWSX7qyF3H
	u7K/+yK6mjdY/L4Ara9WCxdQHge8hCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777267212; a=rsa-sha256;
	cv=none;
	b=3M1FLrMGRcvGwWdzZnGHg+8d+RYOjI7yVb4nHUGhluTuXC/ENqOK4GZ3vWpJ+vMP23VKlr
	gmXjuqrVE+mJ0zExRS7rW3TwEWacarrRQ6kQTkGnOEvCxRqDlJyiOc2sMgLyoge7urmeSN
	fktsjyZ4AL5LZ2c9nqdtsdBaNfnL9KE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kexT6xKR;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QMkPsJ2933551;
	Mon, 27 Apr 2026 05:20:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=4nEsBxBk+seZw+u7Xx1eDjzz9+lJYddsqvqoTmtvD
	Q0=; b=kexT6xKRl6u2r4yg5t5alWepxikP5khOYDICyhTTX9fe0PLnSJABE6gDa
	hdBl0ji0Uc2QO1hpb/BAdrqtNhqY9vwWVshwKhZ3EfYWTk3X4amAb/PnRahFMNG/
	NEAaJP3vkCTEDAksZfwzdG5qaPK59zlPWydsyQGnGuzFRmOU/EtpDrwzALe6HZHJ
	61NRZIjrKcwpR69PxQeylURgf1QatspI2qZzkfwLecfgrXvjjwjcjzN3PcZfCT5L
	mSbK0dTT/5FuyrUVCqEfpAl3SsdOScqA3jbo6GafH6P1sev3V6LaLD3Alqbkk8n/
	NejuqLCmKVubL8aVKsoPt85lBy8yg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn9qxrnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 05:20:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63R58hSa005843;
	Mon, 27 Apr 2026 05:20:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds8avkv9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 05:20:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63R5K1RW29033212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 05:20:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFA1C2004D;
	Mon, 27 Apr 2026 05:20:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF41020049;
	Mon, 27 Apr 2026 05:20:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 27 Apr 2026 05:20:00 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id B7C87E066F; Mon, 27 Apr 2026 07:20:00 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry accessors
Date: Mon, 27 Apr 2026 07:20:00 +0200
Message-ID: <20260427052000.196402-1-agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KLWXsFStS9wxIe74e9wlHShCUGR159aI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA1NCBTYWx0ZWRfX6pdaSSR0sFra
 2C2qDgF7ggAvahOz4etl+xbC5UdXzVr+dxqD5A2hHywN5ncaCSDF68YLabuwl/JX+xSpUwKXCgs
 m4I92f6BgzzOb9PSXacdx3JJLS/Ecf0KHHYy84BuemPRTce+rebYaKh9MN5hbrcSVLb4z/vjwJN
 nQhqj64oVuB1bB8O2HJcEmjezgTtnLg/vqg5N0nv4QjTiP5w13+SkHk94wpfJECvvIbIlrVNbd2
 hKM30dfNaBanKEaF9PpSxGKSLOz9hb6zEoYb18FZGIZcryroQdmrvf0ffVODh4SkDgQfhD+wt9Q
 4EOsHb7VZG2bEariAM2yFxpzyvyw8LNopcOqI7Eu+P6+8JgaBTyFjpZ+Hh+1obUkooVztelFUTn
 K465lnGTpT2EVC3nj2M9p+hBNeKo5oVvWhx14uOYHqzI2a3j05OYOj1F08OXkludDE45Nes9jj9
 W0Xsw/Xb+PYh5Dn6ekg==
X-Authority-Analysis: v=2.4 cv=Kc7idwYD c=1 sm=1 tr=0 ts=69eef206 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=WjDiwf2ghD9uJ69bLr8A:9
X-Proofpoint-ORIG-GUID: KLWXsFStS9wxIe74e9wlHShCUGR159aI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604270054
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 094F480006
X-Stat-Signature: kiha48yg5r9so1wgny8kwj64mox4mu3t
X-Rspam-User: 
X-HE-Tag: 1777267211-687217
X-HE-Meta: U2FsdGVkX19CXo2YPjNE5YUoY5MMZtMk68DPDM574I6FjW5jZVuaRqB6jbn0K4yvE2a/W3XEMUB2lmPY8xBydaIuxI4Pb6fKWBaVBmQ6mPpCStGV4s5fxYM0k64Th3J376XnBtUpUE0pIK4aLVP7+bMnGo8mzwvvZQgXx6zDB+/qUQ8hEOnblMTrDsdrI5qmDCtuc4dnL21+Ds3MhE92rL/72SYjR6uYMS6N0rCBLl8UHDE2xkBwsUN4dY0VEbU26/j47/Kn/OZTIiuPGLtqHZD0Mvf4eXHCJJXXBx0/UefI/sYTxYTRRApwD21llp7wa9E7fskDsS2rz7pYBmfdT9aw8jowtT32/CASvAysrBtRAYdoPKPWawb/8UTIUb+OlnCWQkW+oYO+YfVthfQQ3yfLDqNarzcXaBOeDxuGJueazMyWvimWQ6r8QOp9PxVVh0BFHlbKdghAk2iqI6PVhtjnSKCTbtrEurxdEK6Ll5edM6mFVR8f46u8BJ6IicoZWlL5p9syns9sgh+Wb0pq7OXiNFoIgXISC64W2F0kkG7IV66yScwxJl0MfqnHLaRHzfQ6nhgFMtieQIex9U0fcCgxjrnHt8baPTkpuE1FSM5H4zYP3GRHXJm1m8i2uxsLECnyP0qon2+WHi0IJHkjTI4LCvxhW/+DOo1csY8qTKY49xj9/K9nxtzY59hQslACzFtCbmb7aMN11AQVWGQ8cuPOVjwI8g4OfgeHPEyK23FPc36w5O/jlUGy7+6fxv3j+RE2EZyUYGo9+aVBD9w5ePO5s5JT/b0Erozrlfddeb13bQ3tHkzzU96myoqreB6GHe6axJEBhxBS+zJXSueU+HaMGBsXMMDMoeuAm38fg8eKfRnAB7P49x2KeWz7uK6Wga52Qca2r5XficTmD6Lf3sSGuPBcfPeY0S1BRD2fJk5jct9yjqIcpw++7i03S+gcG3tSL/lAtvSheRVnWFA
 VdNv4hnD
 yp3/ZbjL7AOUHpPammaVPlTuosj1Sy0/Srw+aqMxq77KvSaHtVXbjr5MRYr0XTBy/Akj17XXc6ISlLYRLX9eOXfLqV/m1q5KiQJqEb5HzoDS/FIBAyOQTsgJFM4ErY9knYyH9iWdDqQNf7m6hPxl5o1gazwlFa/jG3vzwIzVEh4eRmIU+jNiCUo4qgFWZIHGlLe6Pwk39fbJQzok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert pgtable direct entry dereferences to the corresponding
pXdp_get() accessors. Use ptep_get_lockless() variant for PTE
reads when no lock is taken.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 mm/page_vma_mapped.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index b38a1d00c971..a4520bb10d2a 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, =
pmd_t *pmdvalp,
 	if (!pvmw->pte)
 		return false;
=20
-	ptent =3D ptep_get(pvmw->pte);
+	ptent =3D ptep_get_lockless(pvmw->pte);
=20
 	if (pte_none(ptent)) {
 		return false;
@@ -219,17 +219,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_wa=
lk *pvmw)
 restart:
 	do {
 		pgd =3D pgd_offset(mm, pvmw->address);
-		if (!pgd_present(*pgd)) {
+		if (!pgd_present(pgdp_get(pgd))) {
 			step_forward(pvmw, PGDIR_SIZE);
 			continue;
 		}
 		p4d =3D p4d_offset(pgd, pvmw->address);
-		if (!p4d_present(*p4d)) {
+		if (!p4d_present(p4dp_get(p4d))) {
 			step_forward(pvmw, P4D_SIZE);
 			continue;
 		}
 		pud =3D pud_offset(p4d, pvmw->address);
-		if (!pud_present(*pud)) {
+		if (!pud_present(pudp_get(pud))) {
 			step_forward(pvmw, PUD_SIZE);
 			continue;
 		}
@@ -244,7 +244,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk=
 *pvmw)
=20
 		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
 			pvmw->ptl =3D pmd_lock(mm, pvmw->pmd);
-			pmde =3D *pvmw->pmd;
+			pmde =3D pmdp_get(pvmw->pmd);
 			if (!pmd_present(pmde)) {
 				softleaf_t entry;
=20
@@ -317,7 +317,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk=
 *pvmw)
 				goto restart;
 			}
 			pvmw->pte++;
-		} while (pte_none(ptep_get(pvmw->pte)));
+		} while (pte_none(ptep_get_lockless(pvmw->pte)));
=20
 		if (!pvmw->ptl) {
 			spin_lock(ptl);
--=20
2.51.0


