Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75222CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC58D6B008C; Thu, 18 Jun 2026 10:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9DFC6B0092; Thu, 18 Jun 2026 10:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64BE6B0093; Thu, 18 Jun 2026 10:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0BF26B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:47:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4078614015C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:47:40 +0000 (UTC)
X-FDA: 84893312280.18.222B98F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id C8182A0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:47:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iWZVFBic;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+RYyodoiEOwvmJG/H2wYuH2wgz201TLMBhdk5m93Lk=;
	b=sY7UUW5/a0udjcR7zFM9qiInFtoDNr03xEGl1EoWxiyg4qi0ISrb1uESR9/VknWkBFyYmF
	xes+X8SgQEZkrL/0+1v8fyV2ffGUTF1Zxs0+mNmCz5kyDyggh4Ondwk6u307KdFg6UJPOe
	NYTFUN+dYVFjFyyw6rJMJrmaGEhuteg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794057;
	b=RZre8eEp69S6d7TqtAh9QwRra3E2jpQz0xC1V0Yp9s1EO2eaPKK4cR/UXVU9yQgbl3n3w8
	+wQ1IDV0OEWWpC9erWxXvlQjHPD+flEOgHxpHJAEZL634Wm4DPQEwFzXaDDwJffqplzvVV
	t1iqdIeq1y/1wY30X31kGKqjprqiTY4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iWZVFBic;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IEIEv53657801;
	Thu, 18 Jun 2026 14:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=S+RYyodoiEOwvmJG/
	H2wYuH2wgz201TLMBhdk5m93Lk=; b=iWZVFBicjloZSPodqN7cKPkRmi3sXc9wx
	jjy6zXxrZiknZCL9LKZdtnkEZxlW9SpEKjWnKLluhEAkjJ8KXQR8cGQ8uyglIjUl
	cxctmwhsO66wZr/EskPkHAtEAe2EQVifAxbxD993ZFOgl5Y1eVDtp+xPdtlqRlDy
	kw5o5L042l1ogSDtq11WjBgu1o2r25zwZHiAM7FMU5wKFgYtJ0kZ1vq3MXwUzOY3
	KVZsu7D+tTn8SKBhfRq1DpiJV/d0GJzKA6lGUPX00JqIKryt9lw8JTWsW+YLNeQ8
	yf987uz1Fc7f+d3GNRAoa+mDG/lxn2i/FQl4iE8WRqsz8+7vzWNyg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eueqw0q0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:47:33 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65IEYa6W028037;
	Thu, 18 Jun 2026 14:47:32 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ev172c793-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:47:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65IElTxT60883360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 14:47:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 112F320043;
	Thu, 18 Jun 2026 14:47:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E369F20040;
	Thu, 18 Jun 2026 14:47:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 18 Jun 2026 14:47:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id CDD54E0876; Thu, 18 Jun 2026 16:47:28 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH -next v4 4/4] s390/mm: Lazy MMU mode sanitizer
Date: Thu, 18 Jun 2026 16:47:28 +0200
Message-ID: <638d47ee200c586a119ac725864f381fe75eefa9.1781789772.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1781789772.git.agordeev@linux.ibm.com>
References: <cover.1781789772.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEzMyBTYWx0ZWRfXzfGQm+b6A+tL
 wZPzdXbQpKryOp0l+bL0tci8gsXTBYj3fGfMJfDFtavSZnH/3O5qsJE7pmLysEYEWNQs+9BBkLy
 Qtz+d3HyBOIKXtVlDGAKWemywYxsrTA=
X-Proofpoint-GUID: YaD33rHQ7-Vf9X-8qKMxI3oerY-lZbx4
X-Authority-Analysis: v=2.4 cv=bMgm5v+Z c=1 sm=1 tr=0 ts=6a340506 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=DuHJb5c9rUSq-GGRdagA:9
X-Proofpoint-ORIG-GUID: YaD33rHQ7-Vf9X-8qKMxI3oerY-lZbx4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEzMyBTYWx0ZWRfXwOSYOwJA1DPF
 pa8tVEgcntwPG1zvVU1EtVi38rxY44clMU5PAcMWoPfIW5FvaWfHaIXIWVXWWqb/EHW8LnjGxsS
 Lv20QIQduoH9wVElPqSygBvqBChTMlpHTZKXaW0oJK3n3waHJC1m++8vqvuHeswNaTnRxTwIk2z
 G4QYZ5P1nmOb3l1XxkODk3rM22ynLuoTNgTmSj6ByGm5GE3M1GPp4kYa3qBjND9vtqhJb8H1KLH
 Wkh4RTHkBcQpU+PI0n+w9CjNT8yuvC/ctrBH/BHgQuIOrsojzjUPuxpGb0k9OOS/uvy/1qJqUED
 Vy8iER2yuGtnEtdZ1lzEmsMVBwiHVEh15Kpc/19y0G/GQg+pPQ87uquJkLeNHhwTmUCoG+GhUws
 C8DtSWoUvutteiAfVIujzx2GnaLradJPaveDSVdP02a+ATqbk07HUoSVlDyuTMbjlywermrdo5v
 wh+gB1FIgaS/KFPNdCA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_02,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606180133
X-Rspamd-Queue-Id: C8182A0005
X-Stat-Signature: azqrgntdwiqykhe5ox99bcm9c9h7csra
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781794057-338016
X-HE-Meta: U2FsdGVkX18uzp7/TXq+gOn9OXhF9bY/2lr7UW7ziGFkQOU5eE5hXFoOpqu9ONLo2PD58SYK1TCTVGI+cPbKDakRnbs4BURUVKq/Vg6sstZAo52m9yNjIFWU/1GKqtiIs+D32pS+e5Ipgz5gF93X5JTqiv29L05532Q8uvfWSMhCyV5sqYgNgMhZvth9Dy9tmlRpNmQ7JIuxbyPeAXpv/gAClJDEY+6fjdoZ3WpuUlQAqPHTUPcb2wQ9DOwMJy9gsgnJHJtM6JDdKDT4SRkZqIrhdjtZvt3zWkEyFk6DyRR5P9l4huwoyckPaJPUm4adttDxkNO44hqE8a23endqihGb1pntLeW0rGet3G5vZAHmcJHAYSTQfXOE3Q4rNHVx1PX0bkJpOqJmXUPi7hDb86Rr5eRjsJ0WmcKFqyGMhSc22ruO9Kn3/cRtknp6kZqwMv6m5vCmMrh+qP7sHCxCzvSACOFxP1AYzJarHjY5vTk2ZLastwbgI1vkLIlDDAL+T5DMBHftI3+eSHsQ9CrBcfdl4bED0zx2rw5lpJScVTHqptxNBHL+B6k4nrjN0mCObdr0OOw4F7miIXSFdoeHw45AiTvZppruZo8EeHZbISjvC2xU9iyp7WGHtx4LfiL7Aqmq/lb0rxbWqs42Na7sYCKKk7Xxd3asw2LLV2aF10lx3RV5SQFMEAi6yE5TjaezbyA85birwpZs6t2vxY4Vt3Pt8LDRTQS5MDthPjN+rJc5hMBB6sFpyg9R3Jd4zZCBGsM/qTvjrR/Ggf5TtWJ33g4G8RIfd1B8p4qe3yjd9IiGopx6QhNrm7O2dnzMKPx1p1l7/5ZLUn0cyCPognbfiCMQ0VELKCuQvp0lUBFVp12BWiFGakCztbVFec7/kEPIqeNYhE0Jtoc+kliAvamj5aq+Zd6p5NUIO9GljAiQNTPL37cicdt9uqIRXJtJ01vy/ieQm8F2oPAUZVSIvBR
 ucMtC/yR
 qj+dydVbXyDQlRudVSRgeXOhx8qOqfz1AG5lJ0+A39eQ/2APavjhBDrF8JsjthWo9DNjRYfTV30uT5z5NVFbFtkvY25Fi6tWRlBE2D6BggeI2Set3KZ/PNf9wkYiqoN9D+5Z1Gm39fzQ0Xtwli7CeZqt+U9Jd4F3nRRcPwuJ4oGYscwuSdaovP5lbhhILwgO5+ZA0ubzit4zUXoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Detect PTE entries access in lazy MMU mode by means other
than set_pte() and ptep_get() primitives, which would be
a read hazard.

The access to kasan shadow memory from ptep_get_lockless()
mistakenly hits invalid access in case a concurrent lazy
MMU access to the same PTE is happening. To avoid that
disable instrumentation for ptep_get_lockless() altogether.

Suggested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h |  6 ++++++
 arch/s390/mm/lazy_mmu.c         | 27 +++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgta=
ble.h
index 2b6659d61fa5..a93e7e786457 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1047,6 +1047,12 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
 		__set_pte(ptep, pte);
 }
=20
+#define ptep_get_lockless ptep_get_lockless
+static inline __no_sanitize_address pte_t ptep_get_lockless(pte_t *ptep)
+{
+	return READ_ONCE(*ptep);
+}
+
 static inline pte_t __ptep_get(pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
diff --git a/arch/s390/mm/lazy_mmu.c b/arch/s390/mm/lazy_mmu.c
index d75b93d9b0de..ee2385897bc7 100644
--- a/arch/s390/mm/lazy_mmu.c
+++ b/arch/s390/mm/lazy_mmu.c
@@ -63,10 +63,13 @@ static int invalidate_pte_range(struct mm_struct *mm,=
 unsigned long addr,
 }
=20
 static void set_pte_range(struct mm_struct *mm, unsigned long addr,
-			  pte_t *ptep, pte_t *end, pte_t *cache)
+			  pte_t *start, pte_t *end, pte_t *cache)
 {
-	int i, nr_ptes;
+	int nr_ptes, nr_total =3D end - start;
+	pte_t *ptep =3D start;
+	int i;
=20
+	kasan_unpoison_pte(start, nr_total);
 	while (ptep < end) {
 		nr_ptes =3D invalidate_pte_range(mm, addr, ptep, end);
=20
@@ -77,6 +80,7 @@ static void set_pte_range(struct mm_struct *mm, unsigne=
d long addr,
=20
 		addr +=3D nr_ptes * PAGE_SIZE;
 	}
+	kasan_poison_pte(start, nr_total);
 }
=20
 static void enter_ipte_norange(void)
@@ -94,6 +98,7 @@ static void enter_ipte_range(struct mm_struct *mm,
 			     unsigned long addr, unsigned long end, pte_t *pte)
 {
 	struct ipte_range *range;
+	unsigned int nr_ptes;
=20
 	if (!test_facility(13))
 		return;
@@ -105,6 +110,9 @@ static void enter_ipte_range(struct mm_struct *mm,
 	range->base_addr =3D addr;
 	range->base_end =3D end;
 	range->base_pte =3D pte;
+
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_poison_pte(range->base_pte, nr_ptes);
 }
=20
 static void leave_ipte_range(void)
@@ -112,6 +120,7 @@ static void leave_ipte_range(void)
 	pte_t *ptep, *start, *start_cache, *cache;
 	unsigned long start_addr, addr;
 	struct ipte_range *range;
+	unsigned int nr_ptes;
 	int start_idx;
=20
 	if (!test_facility(13))
@@ -148,6 +157,9 @@ static void leave_ipte_range(void)
 	range->end_pte =3D NULL;
=20
 done:
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_unpoison_pte(range->base_pte, nr_ptes);
+
 	range->mm =3D NULL;
 	range->base_addr =3D 0;
 	range->base_end =3D 0;
@@ -227,10 +239,17 @@ static void __ipte_range_set_pte(struct ipte_range =
*range, pte_t *ptep, pte_t pt
 static pte_t __ipte_range_ptep_get(struct ipte_range *range, pte_t *ptep=
)
 {
 	unsigned int idx =3D ptep - range->base_pte;
+	pte_t pte;
=20
 	lockdep_assert_preemption_disabled();
-	if (pte_val(range->cache[idx]) =3D=3D PTE_POISON)
-		return __ptep_get(ptep);
+	if (pte_val(range->cache[idx]) =3D=3D PTE_POISON) {
+		kasan_unpoison_pte(ptep, 1);
+		pte =3D __ptep_get(ptep);
+		kasan_poison_pte(ptep, 1);
+
+		return pte;
+	}
+
 	return range->cache[idx];
 }
=20
--=20
2.53.0


