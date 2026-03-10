Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F14BEB1076
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 15:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE046B00A1; Tue, 10 Mar 2026 11:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D856B00A3; Tue, 10 Mar 2026 11:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0216B00A4; Tue, 10 Mar 2026 11:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5C96B00A1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:58:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 154261B704E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:58:39 +0000 (UTC)
X-FDA: 84530611158.12.88E2375
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2185CA0011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:58:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DQQrAnE5;
	spf=pass (imf15.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773158317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=De4g2LAyWvY3GWO7BeINKqb2S28hzYXHWiu9xaz7NEc=;
	b=b1KL1K9CFrqCyPRQj4LMzHj8jjZrgeRx/rxPxGPNBPd+zrwOHwOf2DEg4IBi1JJlU8TTld
	gdlkBQwvqWt+HkZeAsarfVwisJgQMi4Tcd4a9oQWidcrBuFgeu1Tl5XKX7GxZuv7G8M5lk
	bvNVcJbNnBSrgTowwbwgEX6ztspJUKA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DQQrAnE5;
	spf=pass (imf15.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773158317; a=rsa-sha256;
	cv=none;
	b=qW0yXA25Kjj0DWcHKjZL+7Tfn5iEOSjMOekZ3OukaR3DJbOZ4X8NllLgBJKUnXIT3uSXwP
	XRFuDj4IEyGsW830wzbdDW58/cCxhfua3q74EL1CqpcCQlZBxyhIK3IGNqjHtfJJ03krJj
	ourX4g2VoxpNMVXhI6TsC/ZzLmRvPJM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AFcc0Q2582839;
	Tue, 10 Mar 2026 15:58:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=De4g2LAyWvY3GWO7BeINKqb2S28hz
	YXHWiu9xaz7NEc=; b=DQQrAnE5EBBJNqVzGSrnY5PZvllsaEenaJ/j35CNNMPc+
	if513RKpVaEAnuw7XCC/8qnWZcAM7Da0/vYEiBDqR1nDB7h3ZL8hLaCeBJwqIcaK
	84QfpayjX8aD45c4ZrkvbieaRqbpWlxLZWo1VzrjaEjdjBU3VLXmSZBkGrZ52OTq
	LvpzI4UY3ebYKgCwk7S0jYut+E99lfTGYr/CYGwkJAi3If72KsSKrYwgS54+LTq/
	uyX3WeEyeyydIV8MV21SB/2iXf3z5oRDZIt1vB8sfwltXKJys9gPTe7Ui/hJQyC8
	nGM0XfnozDi+tevFOfrF4FPstQEsK05ya7RuBnuCg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskyp350n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 15:58:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AEZh1l022712;
	Tue, 10 Mar 2026 15:58:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafa9wxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 15:58:28 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62AFwRjC027022;
	Tue, 10 Mar 2026 15:58:28 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4crafa9wu5-1;
	Tue, 10 Mar 2026 15:58:27 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v2 1/2] mm: prevent droppable mappings from being locked
Date: Tue, 10 Mar 2026 08:58:20 -0700
Message-ID: <20260310155821.17869-1-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100139
X-Proofpoint-GUID: 3ANEJ9zuxwbaKK0FOosQOnxfOLriMh2V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzOSBTYWx0ZWRfX5pR1s/plwPJM
 MViPNiMklGdGKAA2mkRnPrJ5sLUYq13b+k4KDZ3wGxz6cF/d+3bbrePc2iZR4wvTTA3BSESsG9n
 ec5xBEY8h+RJCi70R3AqT9l/88yHAQftO3gCYtPk6owA1Kitdn/OWQgtXrjuGSb+J3fPrgwEGXI
 v9tyKNmy714ZzMFMK6U2ddyUceTRS5cU1phT/n6+2Ssh4MEev5Ms6qAZMU2mV8T/q24V8Bb8qWf
 dUvajm+yezMBXP2uNHJoWestU2BZ0/WtyiR//PT6O7IRGCSrqlA40Srbu7IYmPrh80SRUPXJvCC
 RxsFUOemI3bNn2j/AQR9Mz3P8V3dpKWrAAefslK1JuFKNCxMQlms1Tmuzq001Tfnxiq34EhC6Pz
 CHI9B+BQDBhy3anvgePs7icHCYliVke8Pe+nZl2UFRxvQftT+N5o5gstxN/sAOlRxgTEFQPqJaI
 haHj9KL8pUAU6gVxnQw==
X-Proofpoint-ORIG-GUID: 3ANEJ9zuxwbaKK0FOosQOnxfOLriMh2V
X-Authority-Analysis: v=2.4 cv=XP89iAhE c=1 sm=1 tr=0 ts=69b03fa5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=iWkOVUfiZeQ8vpaLj3YA:9
X-Rspamd-Queue-Id: 2185CA0011
X-Stat-Signature: 94opxhamp5p1174kxicaq8urwqb8bcq5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773158316-3384
X-HE-Meta: U2FsdGVkX1/ngzCr2ZzlZrY0vfYYRISdCEEOemcSrwZa1NddeSbhpjZw4cTJm6r6u4YsZRGjOBKHUets1GhIC4+1zx1H9H65SGabxjzt4LPOybC8h7ivw2gJB6iFAeOT6kIaNui8zpFIAW7VLdtthsMEqdRvxU96hjZYkMW11y0+qXqUkl6+l77GjSOMWvJzu8HiRPyCZitbgU8JhkASKzDuJgbHG4KAdYZI6O2tP8V2onrQhxxqyc2DpgUVPPCVYUOnL08eXd336QJkch8lTkgiCBtsg+m35KE3F5V06h+lFxiERGJpoqcsVWIU3Atlag0UHZz0/SSJNtEFeEDjvAO5UmXkXJk6gqOEsnBPnG/E0k1eGw1Cz28Kx0QDOWixlQQ7OZflxW6X+hTXJcvn5EMuiMBCZWXhg56URk/SlU4aPUsWWnL1HQ4a+PUZegsNR1VXOCLsLVXzmk67vez4p7jwsrEoCMPTQWRh6qnuz0SiMtVoufUU+kJIDtI+ENte6rECXHABlMk3GAeLXemf2L5Eezvb2p9lO/B8hnqhxD1ROlYqdpSuF7KoKEn7kxThq+r89Hgr+NllRtLsf0SUbHm9QEtMScru/gaCfaBzLSEMdW7ddk+YqEh9Mryxc5pz2TAexcw/OPN06clUB8JOipciuOOkc0lc2F6eSow6UVKwRY5knZVkt9jCsl/8Krj1+bLn3Zl5xJQavHFzPDsOsWznPlaRRRT0fX+BtOsLQZ80EX42qa2vuDGDvTwYDZWDcrUNgYjEGsFIrddxIpIuhGvCho3u8DgKhsCx309JIZO1PlG+MhOkpsSysYPyVuCVBg2nQscF4P7WVN9pYy+JARHq6JxFQxeW6fFmlc/KVZoffOzqm6JkF46HdBnCAUe+4XtPTGS3r6d/aM+t/yVERehCDhQV3t+VwIyCy2DvzRq6CqhyRlbIng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Droppable mappings must not be lockable. There is a check for VMAs with
VM_DROPPABLE set in mlock_fixup() along with checks for other types of
unlockable VMAs which ensures this when calling mlock()/mlock2().

For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.
In apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set, the
current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
applied to it. VM_LOCKONFAULT is also applied if MCL_ONFAULT is also set.
When these flags are set as default in this manner they are cleared in
__mmap_complete() for new mappings that do not support mlock. A check for
VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
mappings created with VM_LOCKED set. To fix this and reduce that chance of
similar bugs in the future, introduce and use vma_supports_mlock().

Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
v2:
 - Implement vma_supports_mlock() instead of vma flags mask (DavidH)
 - Add selftests (Lorenzo)

 include/linux/hugetlb_inline.h    |  2 +-
 mm/internal.h                     | 10 ++++++++++
 mm/mlock.c                        | 10 ++++++----
 mm/vma.c                          |  4 +---
 tools/testing/vma/include/stubs.h |  5 +++++
 5 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
index 593f5d4e108b..755281fab23d 100644
--- a/include/linux/hugetlb_inline.h
+++ b/include/linux/hugetlb_inline.h
@@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
 
 #endif
 
-static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
 {
 	return is_vm_hugetlb_flags(vma->vm_flags);
 }
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..8c67637abcdd 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1218,6 +1218,16 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 	}
 	return fpin;
 }
+
+static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
+		return false;
+	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
+		return false;
+	return vma != get_gate_vma(current->mm);
+}
+
 #else /* !CONFIG_MMU */
 static inline void unmap_mapping_folio(struct folio *folio) { }
 static inline void mlock_new_folio(struct folio *folio) { }
diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a5..73551c71cebf 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -472,10 +472,12 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
 
-	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
-	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
-		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
+	if (newflags == oldflags || vma_is_secretmem(vma) ||
+	    !vma_supports_mlock(vma))
+		/*
+		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
+		 * For secretmem, don't allow the memory to be unlocked.
+		 */
 		goto out;
 
 	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..18c3c5280748 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 
 	vm_stat_account(mm, vma->vm_flags, map->pglen);
 	if (vm_flags & VM_LOCKED) {
-		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
-					is_vm_hugetlb_page(vma) ||
-					vma == get_gate_vma(mm))
+		if (!vma_supports_mlock(vma))
 			vm_flags_clear(vma, VM_LOCKED_MASK);
 		else
 			mm->locked_vm += map->pglen;
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 947a3a0c2566..416bb93f5005 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -426,3 +426,8 @@ static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 }
 
 static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
+
+static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
+{
+	return false;
+}
-- 
2.47.3


