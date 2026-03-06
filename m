Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BAB3FCC073
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F206B0005; Fri,  6 Mar 2026 15:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560D36B0089; Fri,  6 Mar 2026 15:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4600A6B008A; Fri,  6 Mar 2026 15:46:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 337F66B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:46:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6F7D13B5BC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:46:00 +0000 (UTC)
X-FDA: 84516820080.20.A05D5D9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id D1693C0004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:45:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IZDBISFp;
	spf=pass (imf10.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772829958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n0ppwyNbw+EN2W8TjeTFyB8h2S47qibDmv1sVABh9ZE=;
	b=ILJz0VU2NEfXkAV3l7sj0eq5stSfD07LFdmcMY/cynq/GG+S8CLq3yz/qcP1RnF8s2ViYx
	l/diJgmQOfyoNq+MTnVdrILiHmxR+Y6zpvB3aLQ70hKOCxj+c8kMD8Ad8nB9bBl9oucAEn
	3gRYY20Nfgx2nvULVxKSzIxfMwhV38Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IZDBISFp;
	spf=pass (imf10.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772829958; a=rsa-sha256;
	cv=none;
	b=QqkgKdkGIDerMFJp1+jhUpkFy77iaYGhbcBIvSYqECcEGGzaxxhNgy++pBAl/tDkaL9Apq
	VwumrhLeiQH/0XQAj8xE8J1To7g70csgf71CJrmN3PyIrMLadCpgUEOE7gcyNbziY5l0m+
	KW6ZOwqdxKhPez+77qi5maO64i885KI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626JPVMQ3781939;
	Fri, 6 Mar 2026 20:45:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=n0ppwyNbw+EN2W8TjeTFyB8h2S47q
	ibDmv1sVABh9ZE=; b=IZDBISFpl+2YZmjDE9sE/7TeDpIhDa6CNFMGEaRJLMceP
	QONHNuJpWOKxqFg5BZnaxcALfhM9ITThVeRml689W17L54rYmeuJEXjx+n+aCo42
	lzyIGHaCXJSlA6lWXwo7Phq8eJxOmgmeg4PxS73xGUer7pxCQ5/v3xZ4TBMsiK/a
	jFl/9lo3fhqYlQq68jRULcKMKes9zxNyVT546AfrD6l3CbLeOlc96feVMLFimvqA
	9uesaCpsxkhjKfOBNiI0i9RK4nXpPdD8XRm9VyCYcp4qPHXNtrSj5ePEsSHyIG3H
	KmeNnd8hR9ztC1FAZ++3Dwu5edNSRFuXTWwWqTeIA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cr52t83rp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Mar 2026 20:45:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 626J6Ecl023114;
	Fri, 6 Mar 2026 20:45:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptkey23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Mar 2026 20:45:53 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 626Kjq8Z033939;
	Fri, 6 Mar 2026 20:45:53 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ckptkey1q-1;
	Fri, 06 Mar 2026 20:45:52 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com
Subject: [PATCH] mm: prevent droppable mappings from being locked
Date: Fri,  6 Mar 2026 12:45:50 -0800
Message-ID: <20260306204550.8405-1-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603060196
X-Proofpoint-GUID: dFzVRbpyflEp6yyhZLFUCeqYT-4ZbZDG
X-Proofpoint-ORIG-GUID: dFzVRbpyflEp6yyhZLFUCeqYT-4ZbZDG
X-Authority-Analysis: v=2.4 cv=PdfyRyhd c=1 sm=1 tr=0 ts=69ab3d02 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=QaRZ64KJlpYahcCkVoYA:9 cc=ntf
 awl=host:12267
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDE5NiBTYWx0ZWRfX1fDcSd6JBS0I
 zXDdsdcxfXmgPvWqp3jDlLjntkUVBv/JbM/exqj9p09RA/yAshrfY0gyx8whUgBdLwMEWnh9788
 1hIYypClloc1WA4pYS1u88e+tNWJGgHpB73hpceah4QOprhfZk0oFxDLBYMKAsbgKmtySXXfs1C
 cq2NbYOHMrHkmnBparPcHFJVcIve3hEOPTGEnbP21kAc1V3xK9RG9sJ2EUJJUYekw/QU4DBLfVN
 ncD77ylrowp+/XKBXZyYJA7QCxbGXPt5WYyPKorz84WAS1Q3wNF5jX98sAf7jDDpWEIaxx1xbFI
 DL/GBB2ySoENKH1K7xltjLtoJI0KnXk87O3DgXeeGUAEbn/ggCxR2A+8+MnpuysAKdq+HQ4QILg
 Qbi+LIr0BSix8gAiK4IPkZ71lce7lIA/EYsXh82UFCuIqOU2lbvO/h43uuBMD/2N2OEMGeJ5n65
 bkWTDdaCW0bcIqt6oAr7KlQKNbrZfsEvbhAht4lE=
X-Rspam-User: 
X-Rspamd-Queue-Id: D1693C0004
X-Rspamd-Server: rspam08
X-Stat-Signature: oj7kgam668omb949hxang5cgn9ys41jx
X-HE-Tag: 1772829958-608796
X-HE-Meta: U2FsdGVkX1/OZCZqpy5LUyZTJ/iGw1E3vX3U0MVr57ziasI6UAEDXwsSYjuZMoAuOYkAQO1agPzIKU6FkNG6AWivuNBff3fz/baACa4+3Zszkfa7122Gl3LSvnCDfyVeWUYVSomrAT48pYIrQwcnnCEg7Uu1D7oCsUYxa6V7wl1xJ/UPZq+KpqwLtjPfyvUAASiknet2iZUwKT+78al11H9xXkNTDehk2fzfv6f558/cmUXAMxFJv5QNaK/qtDna2FvgAHEYUpVOb/Wh6dXLF6o8FIdo9+Ho6tIkWEhUL+FAIu1T8vZ4HKgI/Yfn2bjmayH40FHHsgast0Mw8DFJgMdff9u53A1uE8Lm9XbwLlbL5oiSSmGO9JdEgBgguClGUctbIdGlx0QW0yKIf2zSXEYXp/J6u5XtZ1b/x4UJRUJ9rWaioUAES/8ufc9e8Y76cKprECMgwC93sGImTmYuOROYDbMlEotu6lEk5RVc3G2uhIHwAEFz7wcOxM3vKtNq0s5EVeHmO2F8lrvKsFglHnCmBIwIwxScJkrVgQJWqrCQQY/xbt10f+ddhlM5neUV/wxATGfLmmNnxFkHGOt2A9Pg10g9w4/PdgV6zvgIasfeo+SQr8I/dppQzEyhLY3JnYDLiPFpR8x5zF4lNHQ4XrPYo6j2XoXsl/4AqNMnGQTARf5r+AcXHCwn7yLGNvEbSKfhho7nmKPB85ZFT0RbmKzqY+sxwPJeWmxDwY2Yf9xZmZWLX+G2AlkiWhscdRdYLFimTiNXqjBN4QV2i0xhBqERSCpVdjXHm0wN85YbTBMNrqmyQyorVECRcMZYrAdFoNKz3+3B8+QMuF5XtnLizXRz3QGu4K9oce0birOYI+SQk5l075TYf5KfVHswkvNYir3h0DolJeTBT+2ynH1VMe/2RFunZEcrcjjGzUztm2oJoCxaR86B62ATFCcqnFAKa3mWXkKr90Ca9aANrVn
 JR+AXzM0
 /E7yvPKMR53xbuGJk9Q/GDtl3uvVEaZMPlFfPvftHZ1tROW92jKJBsJ6J2iUsZbE/v/vvDdmbAaP30OsbcpJQ2YoaN564zghXrbj2gjQnk7LTT4d0Ej6BphJ9wMrrl+ZsfqshcRMmuUbc7TzC0q0tWgswvF9vmOaWJGxFF6zopGR/2iWxEccDQKll5OFCVg8HduKpvQDIqgBj1qGiokipMWwXn0N7CDwjjwzpLdn0wd7RrCgWoCTTts66qmGcR1No8LYGNQa8MpldUKgaCIUMfFI9nIsprWxG6Anvt9seIr6YEaVx2a2E2jWamQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
to the check in mlock_fixup(). However, they will be locked indirectly
if they are created after mlockall(MCL_FUTURE).

Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 include/linux/mm.h | 3 +++
 mm/mlock.c         | 4 ++--
 mm/vma.c           | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..bb830574d112 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -574,6 +574,9 @@ enum {
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* This mask prevents VMAs from being mlock'd */
+#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
+
 /* These flags can be updated atomically via VMA/mmap read lock. */
 #define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a5..fd35c1e88c4c 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -472,9 +472,9 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
 
-	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
+	if (newflags == oldflags || (oldflags & VM_NO_MLOCK_MASK) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
+	    vma_is_dax(vma) || vma_is_secretmem(vma))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..1334622e4a03 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2589,7 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 
 	vm_stat_account(mm, vma->vm_flags, map->pglen);
 	if (vm_flags & VM_LOCKED) {
-		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
+		if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
 					is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(mm))
 			vm_flags_clear(vma, VM_LOCKED_MASK);
-- 
2.47.3


