Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014AACA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FF76B0093; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9024C6B0095; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2EF6B0098; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 560146B0093
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA30CC01AF
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:10 +0000 (UTC)
X-FDA: 85295641620.27.8AF93E5
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5B2F3C0004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zgvt3ctw;
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqypqc+l/OqAfcEQC4OZjmmHbg7ldU+PpmJE6Skx8i4=;
	b=WC5t79S5igfoHFB8d3tGPW4Hsd2HU/KcIYEqwHcYQ40DeT8KCni+YRqJ0Rzca6V/xgqvpz
	pX0WLakYGLdibscuMj/Pt5NHkERwE6vrxTiXoB8z5HtvKbmyinIkB4vCkF35DdVkWQ2i+S
	1zubtmAH2iaL1WHHzK5Aoog1j4weZME=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373328;
	b=Y2r9dl1bhNFlyexJKMOVe+k1tJkvDbUr6CLBONnLxSEb+qLHTfZeqcFXuMyDy04K5BkDk5
	SzEui/H6jEJXvy8C9v+H1iJWZVVfeFba7KCW6bHeGUTOFr/gnF6jmQrN6m5Tbcu0QnN6L3
	oTuE5yDYyhVf5lxSC5iM/bQuUP4XftE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zgvt3ctw;
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZwUw597197;
	Wed, 7 Oct 2026 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=aqypqc+l/OqAfcEQC
	4OZjmmHbg7ldU+PpmJE6Skx8i4=; b=Zgvt3ctwgw39rI6FDeb/+dsryMIWUsE1c
	QZMYF9SyvJOZveo+bHhsHOmUBCXg8mUdXzyErX7sY5bxBMJlrO8UHQXCLlZZKO/c
	3lm0C7hkT3Czi/m7MZyxPEXNXzUVYHHCQ3GTt6FTDoJjxlJKKhTpJVRWwXA8wRMu
	DePhENtazvZVwpng2NHXn++qYhafCtvQKiscZ6h0zOhOFNLBmqU3jrK+YOH04/QF
	c/0OufjiwJ9FPFI4xyFiScOBWycN2M2aDbvn71m/D6HoXyEh64IG0gmoHlBAXOBJ
	zaTGaY3PkFhr4D17d1+ZPD3ce6blfmPQTInCW1d4iDpSjZ4EZBJWA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2scrn5kj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWcPa1810428;
	Wed, 7 Oct 2026 11:42:02 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h58ek2ka1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697BfxAC44106128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8A1E2004D;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EC252004B;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 7BDEB1608CE; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
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
Subject: [PATCH v8 02/15] mm: rename pointers to software PTE values as ptentp
Date: Wed,  7 Oct 2026 13:41:45 +0200
Message-ID: <76c38f9eea5132fe56aafffc68d5c499f423a705.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX+fY+IgbOtwY4
 OpWN2uLcMS28bfINiICBAFqzw8N2KoMRVI1O67Qa26y5BAPl3x7GBPqtQIjvtXWIE04fbCGeP1A
 pmy4uXb33mlBk3VFxZ84h4LFFaKjGDc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfXzkPi73YV188+
 dawf8MKfaiyv2YWKW8lmnEV/r0RIh00DTVLSBVODNT8rHvC8wI0XPpv8ngVYpnPUcFy+pTr25Pj
 964jSF5Z9lkIPTt/liYP9RYKt6ZchYGR2uZGmWCTqLcjtj4CMr4uCOtL75UyBgJC1Y4fZerQHoH
 E3Mm64xDcVo9yHMsDO7/oe+eRSIT+lNwI6bIZXJ5WNxe6R84pHEDvjPpP1CnHQtp6/NMhCKwb1e
 c4RRw0MKWck4YNj4KW5OiVjMh45E9wKEJqRPOzh49dZZFGL6yCdYLv96f1ctS13XJA9TJca2HxM
 lJyKKLGdVLbewxC68Xc/nDTNJx7wkZEx5Ll37Pw70I0HsQ9uAf8zN0uIDGMT7GB1xEF4Ms/qM30
 EugUdkE2Q6nnbfjAvW9b5ZwNBKPp/CQNTK7yQrc47nirVLYn3D6aM0DBssWbonQKi8YfT3BmRQd
 W+9bCKt4gXhjJr4NrSg==
X-Proofpoint-GUID: Eue0-3r4Z0cAnjS8exp06yeH6pO9gDCl
X-Proofpoint-ORIG-GUID: T9jWbWBEm7D-IWe0zqIMM0rFSjO0bvE7
X-Authority-Analysis: v=2.4 cv=B7osQ+tM c=1 sm=1 tr=0 ts=6ac6300c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8
 a=DykVs9dKbHxkzX7wQTQA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Rspamd-Queue-Id: 5B2F3C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ujdjmqhpz8msy3ec73b1rgcixuj7yias
X-HE-Tag: 1791373328-852000
X-HE-Meta: U2FsdGVkX19kz1XyYOQgB5dT1gsMAevl2714BYx8+AhdepIXsnoCb7pUbHAuGSDY6VVsO1sk69hJHfQbbF22l0aHO5dCZ6gN5XZG+mJ13cAy+WqLfpMCP+TCQB+7BhproUUwCGOdYMeRWibfFhXw6SPfDYmkdaxVsw5qyQHpKmVH6ruu6PTHHF+WLhFpsYXNxGvpCQUn/FisHd50T8r34AFtmDujwfWU4fRca9j1ZTo26LyegCr41SG5d2RYMRFfE/ld2hwH8hLvpSlD40QDg5y7jeItx5mAwCEJLqFMhcuTow20JlN8jQTPvk76ybHl/GYkWXakp+1E4bG4u/osfBXrxdcxFXnbS2ikFuJ0eaZO2RBRvKDzXuAtwmPbo6YQPrzEUbYqeRhHZksgDVKS+xJNmaJ+QIizPHDv10ymAisAKKThPbBiL+xwfmqgtzNmsibbcUZevLjAY7Zz5m114EYQtlQAbV2QQcP8bCmX3XC6hR9+YDW6R08Jwx0ZQmhIfI+2LGwQN83yOK1T5NPMNPD4VOpzWaa2KNFV5oWSDwTKw+ur9P88ru1mreBGcKB4m4b4DnrkMVQCWq5oEAYZvqzsJr6mMX0t02ZKRez4Moxyu8lHlHPmqOeBpKPOS0T33LemXl8KS/0fF9YOkWAY3IUxl3k/oXU+WB5G4W+7YPxGe3Vb10urDuBq61PIdLr0Tq4tSyAxJ7Q7j2NIhywITjj7WQ7aHLjXVOTNiMkgkVRLnEDJ6Phl3Adj4mw8RAClkPaJvGZXdXzqtqqfSicFdqGuzprjyINGUY3suW0e4Xqpfn/q1QVmAjGuiJpNisZCqM5mmt433YgcmFHvara01mo+jY/muljouDn7NfBwYUg2VM80Ynl90CqrG9lamFy8o3jYEcU5qrU/oVMhkYyWGeqL5pzTmpkYAfXCtprHtptW8iIBhMxU4oc1hhfJZObR15/khgJJnLqjKMUA/+3
 kqgGgVv1
 DArt8u3FvmXdMny/PwcojIUE78tN5P+nW4rM+/Mt/QEyrvGL1OPN4kASS/DmffgsFaDT1TCIWXDNzwneJ87gJTM99T/Jh26fiXsAVUk2DtMaMmUVRCMeCyqlhZd6HPI4zGZ6IrHu5zbzb0rh4JMbsIhQXoJbT6lArsbqWjKUXXGc0h2aReCYs0mVYhMepZ8X9KgqE7rFU0dEIz9F5G8QAzAkJY9LtVkhYEGuXmWZ7jtfAnO4W+MNd+HhcK0GoPK2Gwlf/EqnvbXBcsr19AnjwB+a4o/uBKeFnydN8/M4p4ungzTMtksRDbjJpo2LMGQbuQKc3gv6j8a4782lC4BqgJZuvwKMiVZg+JHNzlp2sbkbGPr7dlGfhMCdEtXaWfw97tlIt8N0WjMdXfIyPblpR7UzRcPuwGt3ZXgFoBkv8QJlkbhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

Some interfaces use pte_t * for a software PTE value rather than for an
entry stored in a PTE table. These pointers must remain pte_t * when
pointers to PTE table storage are converted to hw_pte_t *.

Rename these parameters in the install_pte callback,
write_protect_page(), and guard_install_set_pte() to ptentp. The later
Coccinelle conversion skips pointers named ptentp, allowing it to convert
the remaining PTE table pointers without changing these interfaces.

Some functions already use ptentp for such pointers, including:
- madvise_folio_pte_batch()
- folio_pte_batch_flags()
No need to rename them.

This patch only renames parameters and makes no functional change.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/linux/pagewalk.h | 2 +-
 mm/ksm.c                 | 4 ++--
 mm/madvise.c             | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01b..c34d826c5e4a 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -89,7 +89,7 @@ struct mm_walk_ops {
 		       struct mm_walk *walk);
 	void (*post_vma)(struct mm_walk *walk);
 	int (*install_pte)(unsigned long addr, unsigned long next,
-			   pte_t *ptep, struct mm_walk *walk);
+			   pte_t *ptentp, struct mm_walk *walk);
 	enum page_walk_lock walk_lock;
 };
=20
diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e0998..892bf4a0d6e4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1291,7 +1291,7 @@ static u32 calc_checksum(struct page *page)
 }
=20
 static int write_protect_page(struct vm_area_struct *vma, struct folio *=
folio,
-			      pte_t *orig_pte)
+			      pte_t *ptentp)
 {
 	struct mm_struct *mm =3D vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
@@ -1370,7 +1370,7 @@ static int write_protect_page(struct vm_area_struct=
 *vma, struct folio *folio,
=20
 		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 	}
-	*orig_pte =3D entry;
+	*ptentp =3D entry;
 	err =3D 0;
=20
 out_unlock:
diff --git a/mm/madvise.c b/mm/madvise.c
index eeee82cf2b3f..c2133b36b24a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1110,12 +1110,12 @@ static int guard_install_pte_entry(pte_t *pte, un=
signed long addr,
 }
=20
 static int guard_install_set_pte(unsigned long addr, unsigned long next,
-				 pte_t *ptep, struct mm_walk *walk)
+				 pte_t *ptentp, struct mm_walk *walk)
 {
 	unsigned long *nr_pages =3D (unsigned long *)walk->private;
=20
 	/* Simply install a PTE marker, this causes segfault on access. */
-	*ptep =3D make_pte_marker(PTE_MARKER_GUARD);
+	*ptentp =3D make_pte_marker(PTE_MARKER_GUARD);
 	(*nr_pages)++;
=20
 	return 0;
--=20
2.53.0


