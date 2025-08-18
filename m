Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9EECA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DCE8E0049; Mon, 18 Aug 2025 12:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2654A8E0048; Mon, 18 Aug 2025 12:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154148E0049; Mon, 18 Aug 2025 12:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1AE68E000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:39:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CFD9C0984
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:39:22 +0000 (UTC)
X-FDA: 83790438564.30.30F8709
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 723584000E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:39:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lxvmYFxk;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755535160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygtR6f2nWYzlzt5fL2eFvz+eu0ybJnfHHIWv/65pn8g=;
	b=PxZAF36BPSjp6sM40uWz0wW4pLmVoimW7KV+oHol0wxdSKOJOp9O4WGlwhpH7g3GHy2UQy
	GJ6dPzzkqoEuUSPGnuiuzqYg6jmWRU8SO6gyGvq+fUj7AHoS1IGgf3Lv9YBLZoodSWAchE
	m3GZtW3qd4SE2nWm38b1pZ2wJygPp3A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lxvmYFxk;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755535160; a=rsa-sha256;
	cv=none;
	b=2zdmQOst8s1brPeMxHMgl0c+KOBBMxriD2AAUAQ7USTL0Od5WwfnvyoTwd9QpH6VsVa5nm
	7bitA2abkACBnH+bfTOir+iHTf5FZENCuAyAgnMLd8Oc3ZsTtqMDmbxTjtp3OZrIcxthtg
	pmmPlXS3FMLa0/D2eGVn2kQ0DFqMCRY=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57ICrWD7016582;
	Mon, 18 Aug 2025 16:39:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ygtR6f2nWYzlzt5fL
	2eFvz+eu0ybJnfHHIWv/65pn8g=; b=lxvmYFxkjkMpl0rAUj9QVpStKWwRvrUua
	I7oyLZ/lSfF+Swk06c8zB/oLQ+nF/J00/HZkarFwulLJ8+UlHEs6/FVplOXMdQrQ
	Zhgekoe2lI2k7cuVk5K0ww9kvF0MwPgpqLyQ1aU0jK1f4HcWr6twGDmhyR0/caC0
	8ng814A8K8Ss71XXnGg/RRSBfAWam0UY7VvORHxj4H7ONwCNYezzQkOMJlNO6ifU
	pqUjJ2tA7NnPvCqcHwxjOfSSSXaqY0J8R9wzB/wgzLmnVG27tD/VsWKKWFUFGow5
	4g+O0HYlzj9aUOH6BlxjqXM0ieIJMTA//j2ngSMdkSYZ4feAu1VHA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jfdrtd5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 16:39:16 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57IGamgX027674;
	Mon, 18 Aug 2025 16:39:16 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jfdrtd5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 16:39:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57IFRaAm002340;
	Mon, 18 Aug 2025 16:39:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48k712xbum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Aug 2025 16:39:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57IGdDse31851050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 16:39:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CAFA20043;
	Mon, 18 Aug 2025 16:39:13 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D70D20040;
	Mon, 18 Aug 2025 16:39:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 18 Aug 2025 16:39:13 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 43E9DE138C; Mon, 18 Aug 2025 18:39:13 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Daniel Axtens <dja@axtens.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 2/2] mm/kasan: avoid lazy MMU mode hazards
Date: Mon, 18 Aug 2025 18:39:13 +0200
Message-ID: <0d2efb7ddddbff6b288fbffeeb10166e90771718.1755528662.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1755528662.git.agordeev@linux.ibm.com>
References: <cover.1755528662.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v-pPmVsfYB8aWZ696MiUmjnkn_I1mE_A
X-Proofpoint-GUID: qXQLAt8GvgBgB0va-hWWdqzwhhp2QqFk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAwMSBTYWx0ZWRfX4fbSHZEHXORf
 8ZQ7fcfOW8VZI4tcwzj02pawPeHcEa4Wsit6guhDP78kZB8b1PMUyieogeS7DMT9nqm1ojizMID
 5V1YD9jjlOYPmZEKG1rrjVj/OS5Hcbhpx1ZDSH4MdVaN2qucNtqzMsWsfIBC622IfAYyp2l6W2l
 L2Fr6YAvvxA1sKPXltEXgEPZpJ/uposFoosJb0bkYWF8JGsMQCncxUI3UhFheHAOn4zOjnY7TWQ
 PejEMNGmAdUAiq/rjauWG0onl1GLvmJRVwATw+luOlKL94OFJdrm2LFy+XXyK4QcZlDQCqnAzZs
 wHtElihoYSDX9vW602V+VHqu3Dj2/ndPM4kWyXT46UAUkLwNZsG7LvfjC2cpeY9QzfbRE6Dr4FF
 Pxd/mqd2
X-Authority-Analysis: v=2.4 cv=GotC+l1C c=1 sm=1 tr=0 ts=68a35734 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=0CqGaNLKB4nZpUE_F0UA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160001
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 723584000E
X-Stat-Signature: u4mwzwctkxfbeghuamaogje7gehyxb7d
X-Rspam-User: 
X-HE-Tag: 1755535160-434782
X-HE-Meta: U2FsdGVkX19TIiBhgZhuLIaxTmfVjZU1iR3e4hj39VdmirxCa4zUh+mdQ/MDfCF8Jes8LhGTuD0ZzvF8XKSsZd5/OwNGduhvquQA+LnsAGr3UwZgiACAJr3B1MRogtLw292OHpmJeKT56ZeVQJUPObVtf81Fm6JD5F5hEiYkoxWVL/mR+CHZ+By9zZaBq2BO4JQTsOYw4y42XGQ1HipxyYVSEPWL1QDB/bGLjyU6xGKX4St5ImJ2Lrj4H2co6IkcVEu+qZMtgu1UdRXbO/E/Z9Kg8Spo6VnD6qiVbMMoMETzUa7ONLh4IMcFO12ZzVVhBWlyfIQ7Z5swL0yD+Hg8Q5Cb6axGrGbcfEstwER7myaCe+5tVvoQQHO2Yb7Q5P9dGSdCaY/YnbTgmstohKy2/zMo42WGFGNZYt21Xc1RkgWtZbmHmm3SvTwC99cXsIND4enqfuDdz5aCKEDRtDn/0f/0FeXRXEDwIVsFTrNy6eu6fSSE2AzhbQYuUiiDBKJlJdX4FfggsgkEuuETgZuYNy4IyCCUAtW5PeWHPxoiJnEFUj5495h8QKo0ZXZ8YizOuc7sY3ulnhMyfG/NaKaqzoTRN08q4wVWbhdefkrtCdY0DIQDL2F5Ji1E2RGRZNOW65lmsbckXe5DPxl73IKzpLpX7N/X3etgHEVrG05ig/mlcO2jegAcUSvCvhSPpRdSNhMJKcdfOQzZmUhVsMEufcddS+O4VFuEuiAXLn6+ItBwzu45117OlNK06C3QHPUXz74Y8MbVCqDtrmrIxMY/hIy3r/23zLjPCNPqcUH46jvpqfBwudzQfPgxoJkLjW4MokYX3MakRk06Mt7PNMhTPC86VA25JgGx7tKxJculGPW7T4krusPqdrhhFGXJB57rCCbSqzhSKyPF3+aIlut7coVKwfEGZwi/sUqlf6I57WmquZWhRk4krdyLY0w2wl9Yt4/up79ptAvrqh/xZ8y
 R7ya1fuu
 cb7J1yrQ+U9YYDwuhb2CfPEgvORMvAbG+FP+Lnh5h1K2m0HnSeBiHoHn6Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Functions __kasan_populate_vmalloc() and __kasan_depopulate_vmalloc()
use apply_to_pte_range() function, which enters the lazy MMU mode. In
that mode updating PTEs may not be observed until the mode is left.

That may lead to a situation that otherwise correct reads and writes
to a PTE using ptep_get(), set_pte(), pte_clear() and other access
primitives bring wrong results when the vmalloc shadow memory is
being (de-)populated.

To avoid these hazards leave the lazy MMU mode before and re-enter it
after each PTE manipulation.

Fixes: 3c5c3cfb9ef4 ("kasan: support backing vmalloc space with real shadow memory")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 mm/kasan/shadow.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 4d846d146d02..e2ceebf737ef 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -305,6 +305,8 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 	pte_t pte;
 	int index;
 
+	arch_leave_lazy_mmu_mode();
+
 	index = PFN_DOWN(addr - data->start);
 	page = data->pages[index];
 	__memset(page_to_virt(page), KASAN_VMALLOC_INVALID, PAGE_SIZE);
@@ -317,6 +319,8 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
+	arch_enter_lazy_mmu_mode();
+
 	return 0;
 }
 
@@ -461,6 +465,8 @@ static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 	pte_t pte;
 	int none;
 
+	arch_leave_lazy_mmu_mode();
+
 	spin_lock(&init_mm.page_table_lock);
 	pte = ptep_get(ptep);
 	none = pte_none(pte);
@@ -471,6 +477,8 @@ static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
+	arch_enter_lazy_mmu_mode();
+
 	return 0;
 }
 
-- 
2.48.1


