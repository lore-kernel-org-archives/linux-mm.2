Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86FACA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47F46B0098; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2996B00A1; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B126B00A0; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 730496B0098
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00A4D1C1CEE
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:12 +0000 (UTC)
X-FDA: 85295641746.04.298CC2E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9494040005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VSJA+KEJ;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCSxOsbf6mTGc3Suo571XSJ3055Q+qHtEMLZCspKi1U=;
	b=i5Bui+sMGmDs++VFowI7nRdr9n3fjprnp+M+heFcu0q1FkYuy8l7Z/DbkdWYB51ML0G9kO
	k+Itf4kLM+ev/LVTXDnXnga3A8UZvFBgG8fCUrGciIjUlln7UP/pni0Czux0x0bHrVn3jo
	N1Jgs/Hq+M7aTqARHxp2lOY5g03BM4E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373330;
	b=SHeo6nGrXKlpfP+0byTCPK3E2o9vMitqfAm9/e1b2NFAW268SdbZLDwOj07XyMdtbOvST1
	Nx3V2Sw4gOxoyiulIAL+P9Okb09XjtspbgIPRn5fjRFAzWyUkIDzK3J8QCR/H6Za3QCmyn
	80Szq5EXPdoB7mxEA4NduRMATRkiR6M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VSJA+KEJ;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZM2L2462974;
	Wed, 7 Oct 2026 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BCSxOsbf6mTGc3Suo
	571XSJ3055Q+qHtEMLZCspKi1U=; b=VSJA+KEJTI5St1ezey7W1kocMIuF3ot3N
	IVIUG7Ql3kubS++O3fWDgRDYSI3Nc3IgDjFaW6k3JP/7FHf9r8J84xerEC4Mp4DU
	3E5CLyzA7Q1W4xmf23I0uobW0SYwufdTbK7oeHSZyG5dwHC9TDEOuLyEnd6QvfO+
	ItvO9gTbX+bzLv/yfdsgPdRmbkCdsL/tOsBM8JBnjAdnXjC68poqSxOCcpup9ylI
	fNAJ63PsGfunK1q5mLJbba2ImxV6f0nAZ31/ildo+BRzXEhE0/xIIfeasXqH/V8u
	z9+EpxPoTZoPisrE9jQTOC9ESmj02jbzkk5usEiSVQTYGr+fnPlgw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2s74w8c3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWgPB567482;
	Wed, 7 Oct 2026 11:42:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5f3tsb5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697Bfxvo19595962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D12C2004B;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A4202004E;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 8DF56160A46; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: [PATCH v8 10/15] s390/mm: Cleanup pXXp_flush_lazy() routines
Date: Wed,  7 Oct 2026 13:41:53 +0200
Message-ID: <964adeedfd20d4dbcc9a6341f57ec7aaac6c6adc.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: -rbscqX-jlGyEG1AjE7JMIlN7cz_bdzY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfXyf4C5x7d7mrL
 bQiLAzVu04XuOI8WvL7nmG0N+YoIn5yGAb5tfzuZ0S0SElWCkCSIe/THZKu1FUKBatCJ6Sc0Div
 WkLEMz4aWC7tnp7bx05YHtTARMm/S1g=
X-Proofpoint-GUID: 7uuXtvi7iNGngb0u1UfDGoO-xLVZzrkC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX52B+fyo9B4lN
 SM2fiicShdIOuyWmcSOKzZX5jWY1uQkPzXQ7FXWgKEZjCwsq144DsEoixzr4mBYl3ZxufAar/Lp
 ODC5K1FYtsocbx9flsyL6wTACVw4J9Yt3a6Wo4uiVd0mTUu977MG42Hv5n6xwNi7NfD3ILsExqA
 AUOV3WysEdy+YjDOFWmNtybc2e/x7YqtoYaJLl0t2GSfK5/PP7/0+m7DQnZB2u7p36Rn/jongr/
 rYwyrJ49reXkz0ZISy8iWXbVJNKk8NGeuCgA+UYX/5XkHUjfvyFXzrKlU3vPeTejnTWTr88LS2m
 sL65ipV1IldtB6w8HB8o2R4dlvP1cPCPd6J26+c5NI7vHqHEm0phCKkUPyv3gPWZ+3pPRkrBcwN
 gx0rZ9CN0VV0k0Yur8pyM4zxqrL5ZqoHZ0eTsBEjJyKhoTnNs+ZxsZ4mjrS9tfh9+/mJjWe6hHT
 33Ll/46Szzub02b1UyQ==
X-Authority-Analysis: v=2.4 cv=fM2sTpae c=1 sm=1 tr=0 ts=6ac6300c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=jYzbKW4fU5_uXXChEaUA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9494040005
X-Stat-Signature: is5uxj3cyaxgbprhbjs4g6h5ju8eceqy
X-HE-Tag: 1791373330-741348
X-HE-Meta: U2FsdGVkX181AjjyUAjD8RphvAD0jDqIHFrnmTOsRMJH67/cS7jlxpsw1ejnIz73HCzi+nzvGO8Yoo/3HgzAcc/oKHiK2t70AaCjFSrL8Lx1oZkLr63iJxV4sZ/qCq0aw9eLtomf8DGo3j4nYlLW7oOe1sKA1sRGxDNH6Ib1/OulX10zMyUgSyPS8r/gXBj+RfbuVtCbyNKSpl30yfVrLpou37M//lcKJiNJo8S4vFAlxtlUe7r0oGrd3FKXBVFCO0rGkW6d2MneKfsArtFaIyT6hz7KHKjRZT95l21W+CBgU423ToxFZPPL29ej/2uZKUTTks4/AOrPwc55jh8x7RbivMqkgRLPvDqBGvd7ae8tM+XynTph5Bo+q+uP01ejFGa04cI0o3Pn1d6BQSThtEYS4v8Rrk4+CR2+f6Ek3RuJAVFQI+3lb3TiPTLVBRvXIPGe3HXErCMtpdZhsK/41FVT6hc4tmMgJd0DFPLKe+vuUYPBzPUzcos1UI2YolagPkPo1b5MqpMfqa65zd40ljxMuptXfDqHtmhtEqZKs7xhIYsu20xuUbUEv9Xq+Jq8AEqKjNNGgc9bPbrOj4SWs3Sen/V1OOs4E5IEYKxXZu6Taf4WdRs62HaFzH5vTWaqD+437zoZv9IsX7FmFTTHcGqR45lu6ZygQYcqZa8rncdz+EKpfwgv7tcV9/cKhubJMXK82h2Rj8vVR0UGElZJgc6AG5xMGSqAeUShoLHN7IyaG825Izs9lCrjRShrDzZbY6gcI0Dqd+tWlPXxvFazQd8f1lJVTn98CmXLna+xJ3/N4foAfL/jeCrA28da5LMAeszeDAPhMeDsXcY12fK4DJrUwQSCWVSWD8tgq23c11io5e2TfNC8+oiWTTaOe2dMzqFX3MxzS7litISlWbw7qff/V05oueXjO7B/nmvi5k3yQTTKZMZ222zufUilwea5oAfAaPKDAQM/Pp5uKlr
 FbW+7lek
 AhAYTBNUFMaJrvZL/3CGtSKAJ0/z8CSA2z8b7FFdT+bDgc6e6XtumIXkl15rPFAv6mwJreURtKcWD4w6rLRSYU6i1+C8Pj0XZMCil821gcffsRfcmLhJ/jIQqeHGCVBdzZyeGFDBsGP8kSkr80ymDsc2N5I38OhfcwMp/8n4elT762VjHyi8QWYvue9P/OAReEAxWMxknHxym5oAHavoCgFuoNTnmB+W3Ksbe9NkUS1DovwyHgPqaBD+am7N8vA7+Gb537dXwIr64K0biqljZ+DTUCDK16bE3hsAlzJ3LyedxgIEWGJy2tvv5ccQAdgi9atgOJlOZxpKRV6L7MZmmua0JWp7kDxugQCVfIYl+n70iH82jArwZJeOTqy+IuWyw+I+6uuyaw7kLUyDfN675XGrLOUncWcmkWVi+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Avoid unnecessary pgtable entry read in ptep_flush_lazy() and
pmdp_flush_lazy() routines. Use the already obtained value of
a pgtable entry instead of dereferencing it again.

It might appear that the optimized out second dereferencing happens
under mm_context_t::flush_count lock and therefore a race condition
is possible. However, both routines write invalid entry bits to the
pgtable entries and therefore no reader is allowed to interpret the
rest of the value afterwards.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/mm/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 4acd8b140c4b..da076928b63b 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -107,7 +107,7 @@ static inline pte_t ptep_flush_lazy(struct mm_struct =
*mm,
 	atomic_inc(&mm->context.flush_count);
 	if (cpumask_equal(&mm->context.cpu_attach_mask,
 			  cpumask_of(smp_processor_id()))) {
-		set_pte(ptep, set_pte_bit(*ptep, __pgprot(_PAGE_INVALID)));
+		set_pte(ptep, set_pte_bit(old, __pgprot(_PAGE_INVALID)));
 		mm->context.flush_mm =3D 1;
 	} else
 		ptep_ipte_global(mm, addr, ptep, nodat);
@@ -227,7 +227,7 @@ static inline pmd_t pmdp_flush_lazy(struct mm_struct =
*mm,
 	atomic_inc(&mm->context.flush_count);
 	if (cpumask_equal(&mm->context.cpu_attach_mask,
 			  cpumask_of(smp_processor_id()))) {
-		set_pmd(pmdp, set_pmd_bit(*pmdp, __pgprot(_SEGMENT_ENTRY_INVALID)));
+		set_pmd(pmdp, set_pmd_bit(old, __pgprot(_SEGMENT_ENTRY_INVALID)));
 		mm->context.flush_mm =3D 1;
 	} else {
 		pmdp_idte_global(mm, addr, pmdp);
--=20
2.53.0


