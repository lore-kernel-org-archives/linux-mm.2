Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29233C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260486B015E; Mon, 17 Aug 2026 07:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211006B0434; Mon, 17 Aug 2026 07:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0642E6B0862; Mon, 17 Aug 2026 07:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEDA86B015E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:33:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53D031606EA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:33:11 +0000 (UTC)
X-FDA: 85110550182.21.B4CB560
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id E7DBB180008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:33:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lINPbSdO;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966389;
	b=awTvw+bplxMyNZBdHZD0z1xGw7n8keQsVD9jHLXXnRcZ3Eu9aPtbiBKHzCjJts0vqCGV2t
	SL0LnvUjwLTW2FuTAdobdYGTvGL8qGpSTJRgAu6bFnSdhyQ85e5AUL9bJWfjfH8x7nP37Y
	0l3D/DlCnSYrIXyaLyAo7uF9t+ZFFkk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lINPbSdO;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uXokoF4PUm6dgm6RUNuJHv7jlLk70lExgHTtA8VB0c=;
	b=8IUZt72eq9oQtC86EZrI3xGBGC+oh6iawcR0DmEZOUpJJGFnzQooImj2G0MZXnEMCcGndx
	gxGT4flTO4YQIfwwK3g4LqYh2kyOJDuIuoqAmYJptLZmEaIdnTlyhky4ZG1cnO/Wr4o/ub
	tKx/vKks/x90V3QC4RvvRP4BHzn7sys=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67H1ZFFs071008;
	Mon, 17 Aug 2026 11:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=7uXokoF4PUm6dgm6R
	UNuJHv7jlLk70lExgHTtA8VB0c=; b=lINPbSdO2D6p0xZueWMxWwgpinIGVIO93
	b0pjxsfSSw449x3RnL8P61PzVZSBLEq8SkZbeW6GRwYiJqbnRy6IAEljPTaVbzu6
	1JOKxC2WVWPgRTmqdm04rdZdHjX4zwGPzRlRszDvaptxQYjDNYLdoZrhmSFDBHs6
	olrBHDmn1vL+d65zrHVXaLqVcTnhppP9QW2mMLltOf/1ZxeBlW1XWX82BLCOdVlZ
	G6M9klCgQrDbTRFIKYMXAKh8j46pais7AELpAfERiiUITXPcN9WY0cBgp2fF700d
	yNLAJAtMX5NOQADUHGl+nwT0q1BrdVnVHYjMpdjWmvQ/MLa7K9ihg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2frt1m4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 11:33:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HBQMrE007554;
	Mon, 17 Aug 2026 11:33:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32epx019-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 11:33:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HBX2bL45351356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 11:33:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EFF42004D;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68D6A20043;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 4A9F41615E3; Mon, 17 Aug 2026 13:33:02 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Subject: [PATCH v7 4/4] s390/mm: Lazy MMU mode sanitizer
Date: Mon, 17 Aug 2026 13:33:02 +0200
Message-ID: <064436ca2fcc3221f12a37acd0a41d995a794cf7.1786956464.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786956464.git.agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=OfaoyBTY c=1 sm=1 tr=0 ts=6a82f173 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=DuHJb5c9rUSq-GGRdagA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA4NyBTYWx0ZWRfX/F6hRpjEFYcG
 b2EKkTZ1UshVTNvaYejVDVzsIiH6v03MoggxVV/PN50hr1mCBJ7CaKxBmrmiuEQjxBOwb54+2tp
 lCJ2wBy+TpKqngSZWO4E9/nrxqFhkmU=
X-Proofpoint-GUID: dY7S0-hVddtmiyTGPRj2gkH2IcX9yDWG
X-Proofpoint-ORIG-GUID: NlL45JyIS0IkwGwb4bRlbgWKq2rZGFzy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA4NyBTYWx0ZWRfXz0XKPB/T+VdT
 WLVzTc4RdKa363ytu9yJj+uBgKXWDUHWlOJGGTET3zGzEJ79qldEmorLO8jMivk+VL4RxjCoj0n
 OVOQSyetzW0woAXie+ZxH2P522PlPTO6+otTbZIEglCmWS09LBSBoevc3iO2b0L5va1DhTBZ8qh
 Fb2iA4JfPRiWKIN+QtbsfWVvI62fSG4tafP9Be1CPwsg6NKKhtuLokKhapS4+TzCBA+M2UsyN80
 dwQpFR+UxfxGuB1xemf0QhdS6VdtF/zR6zF8jq3Xan/Vtu1mIuafJCn8at0Nh6ldgzIuYKFsXTb
 96tCpov5W7rryNPmlR1eXM4/XNJ9TybCGT92jqSGo5GPaRQh+QpJn0t0I2/5HhFkk0pCkHme5Vz
 khcdUVAPlhW0hang7m3xWiNOwk4N7DxELPqtmDA8r25I3QFGZ2uZyTUFFG+RTsiKpQWsgqcdotX
 aIan644huX/rjukai4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170087
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E7DBB180008
X-Stat-Signature: bk6388yozyj9upxsiwucdngg63nugtaj
X-HE-Tag: 1786966388-579372
X-HE-Meta: U2FsdGVkX1816H8vTbYFddnzCISY91qAGbQxLumM8OpMeoRhfSzXPIwQ6qt2YjHAYFlE++n+rnskKlHmElGzmYBOubKqoygL0FfMAzm+l8NyUezxsVRvrvUMkxSbJnOHH+g0Bu72InGSKpQgZsZMtKHioEKL4z/lgsNw6CQ82AdMWP2+ZXmc6xTqpY35v7CwtTtpnJfIh4j6PGGq6AYH5sByc48Gy64Ssn9G+65Ky4iGNGBg0u6gJLKdaYxwmbKdb1B7qfsUy+0kL0RSrU2DJ0XzMiR/rGWaMMZB06no2rkLcOgeKyN0coZMbNl1nLFRy9IfMfo7M8069aF3zULkELu399+eJgsIXU/jD9w5IMd9WxA9qdkUUAGLgp0ln2CFm43mXKIgNgNvJP6LMOLU8Qa42i19FPX1rMQq9/NyEPYfovokh+LDxGfa47rYpCibffFx9YDeodUvLNgn9TJ6v1ZSrUYGqwxM5s2gW4pcviQ+m8+tk/pxOX0ZNVKZahA+FhBTEv7nMK23AQ/FfDPrUQgfFyXF6NTqZ/GclK9accUgj5+DxsK/uFiOqbdNQgNmhHOVfsDhCROmdxv2kIk6d95wI2Qlav1CFgWRfT/bonipjFpufRrlp/raUCemTBhOvTfrFJ5i8+8Bv8zSyTcj6n5DqMzeTRztvxfVvgeMRglkm3wxIdVNNTjL76T/kGFvv5ggPqQfKaHyI+kq8XT9NMc984GZQ/0WR3qAUK1nwcPUO7gOdhmMIFXmcbJgpN/9VUtLA7yM2lL4Wdu6wLEwx/YKC3msoJauB6gcYtqjdkGr6Dkb6cA51VhLBj5yabzna3B20nzZ4J7TKy4lrpGMIGTvMJfiD9rrixVMohtwaK+BAXszY/CXm+8nb0e2PWmctmKu4bf6D8gNu/CATuuO4m1vaeUPtuu6bsyRF6wkZdQMPfUCTcULnSsP32kED7KhiVlpbCv2npL5FCbTeDw
 H36aZQ0J
 VPJwa4X5KfhCvd14xpWftg6MqKSMhvES5zPJBHqONmvn58xSIxGT6lf1ZvO2y7U8VglgF+uIJaDSJtL4CENCyOkzHcTbZfXwzaI3/2L/TDrK31pxnMu9ARkLum0eRzM2oMG+aeB55o2TyDz2AdLZNpi3MDMTZCr+ZAYpCtuunCduim5cfA4jg6cTsX+vXj0FjX9hQBD5DaeqB5bVJeuce7KxIXmBFD1AsBLMwMyJcPMUa9bga8KYFH2zH1xFYNis1S0Nd8pkFF7ENom2N9bARnAZJaKD/27AGn8H364F9sZDUCQ55062YtdpRo/cn7+JVa2dOaGY4IIXboTtphjnSMO8j7Uyq/jHkgE536Uk9ZQWvPFKWptIHAzZ7Ow==
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
index bf54202a0630..1e8a79989ed6 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1049,6 +1049,12 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
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
index 002ee766b391..7e3a4115ea04 100644
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
@@ -98,6 +102,7 @@ static void enter_ipte_range(struct mm_struct *mm,
 			     unsigned long addr, unsigned long end, pte_t *pte)
 {
 	struct ipte_range *range;
+	unsigned int nr_ptes;
=20
 	if (!test_facility(13))
 		return;
@@ -117,6 +122,9 @@ static void enter_ipte_range(struct mm_struct *mm,
 	range->base_end =3D end;
 	range->base_pte =3D pte;
=20
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_poison_pte(range->base_pte, nr_ptes);
+
 	local_bh_enable();
 }
=20
@@ -125,6 +133,7 @@ static void leave_ipte_range(void)
 	pte_t *ptep, *start, *start_cache, *cache;
 	unsigned long start_addr, addr;
 	struct ipte_range *range;
+	unsigned int nr_ptes;
 	int start_idx;
=20
 	if (!test_facility(13))
@@ -163,6 +172,9 @@ static void leave_ipte_range(void)
 	range->end_pte =3D NULL;
=20
 done:
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_unpoison_pte(range->base_pte, nr_ptes);
+
 	range->mm =3D NULL;
 	range->base_addr =3D 0;
 	range->base_end =3D 0;
@@ -244,10 +256,17 @@ static void __ipte_range_set_pte(struct ipte_range =
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


