Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431FAFCEE8A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C5A6B00A7; Wed, 25 Feb 2026 06:43:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CACC6B00A8; Wed, 25 Feb 2026 06:43:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2766B00AD; Wed, 25 Feb 2026 06:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 553C86B00A7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:43:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 015E8C1FFD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:43:12 +0000 (UTC)
X-FDA: 84482793024.11.6E86C1F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C06B20004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:43:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ry5+cxk3;
	spf=pass (imf03.hostedemail.com: domain of riteshh@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=riteshh@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772019790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9c89aL6Vynh2oMQeP45uCaFbeh0Mb7xFQnDGPw1iVpU=;
	b=CI11EYnjwMSVgToY+7Iu+eGGhEO4DBj3ILaHZnEvY1dJRU8Sdag32S+yFumMbc1999GOty
	JDBEOgZYvc+5Xq/fOG+xH34aLsRYUwkJKb46InC3xZkC68xfiWwIX7RLWnxdS0O8M7Ezuy
	eVuuKwLIGpVurQe82MFMib4fupIWy+I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ry5+cxk3;
	spf=pass (imf03.hostedemail.com: domain of riteshh@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=riteshh@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772019790; a=rsa-sha256;
	cv=none;
	b=X0WrinmNSCrAr3uJlG07kjcmQbaJ0Q18pSt15/PCqU5xEUSa7jtTc8IHXLkSmFi7/zEULt
	CSk8DJaFXl6+1ODgQRB/wB/NZBGHejigTYtxYjMtFlZFgulDYp5WWkRmhdTA+8bYLS6AjK
	ysgSZ4S17v4Sbh7HzmtAo/GYQyReXME=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OM9OXN2753620;
	Wed, 25 Feb 2026 11:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9c89aL6Vynh2oMQeP
	45uCaFbeh0Mb7xFQnDGPw1iVpU=; b=ry5+cxk3bBvrU3Z295lLC2941Q43qO0f5
	DbkvE+FRz8pUVUDxYF9/eOSecnZUeF7D0ZDMKsWkXQwf+DD++LfrOR1X0H4l/jdh
	otGgFMkYMRNjt+LLd5eQriZrNFMIxrgQ5ggc31FO5YSmu5V/RA0QNRCkXus7OFey
	GdXXj99K2fovVKA3bM4EjcZLIQK2303xRI7xJM8vjyRDKZJniBpd9racrcGmif/2
	/Pqw8+TFXB0wMbQ5oEeJeYYt7ngAead3rAjiB8wNkWz2LdIxbJifM45G6J0URJZy
	HbMalq4pnmrZ+rk1YCKH7PdZQbY/W0ItI/WeXitZgiE6wNcpVL5dg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4cqyy43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 11:43:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61P7PZAg013478;
	Wed, 25 Feb 2026 11:43:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdy56s9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 11:43:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61PBgwJi43450696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 11:42:58 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B113C20043;
	Wed, 25 Feb 2026 11:42:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4D4B20040;
	Wed, 25 Feb 2026 11:42:55 +0000 (GMT)
Received: from dw-tp.ibmuc.com (unknown [9.124.209.31])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Feb 2026 11:42:55 +0000 (GMT)
From: Ritesh Harjani <riteshh@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
        Christophe Leroy <chleroy@kernel.org>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 01/10] powerpc/pgtable-frag: Fix bad page state in pte_frag_destroy
Date: Wed, 25 Feb 2026 17:12:45 +0530
Message-ID: <62dfff55a7f4f465ac1f8077cee93e6e87ebddd0.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: lRJVb9BDkAFUVcJLJAstUx5gTsmgr1p0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDExNCBTYWx0ZWRfXzgYw1EnrC6Qa
 mSexlTWBru7Lmci8dY6bHbgdfDpdOLlItKxXojYJZuPtsz8VHaDc5zPohASQEhW7czhZf83DUU/
 UqceQ6gU1Hvct3f48xoaPMCaU123alKN7DiYsZdCSQqU71IepY05+TgqW4eZJI5DQF6N/mjK0gb
 7X8pWQcDNFxvLqCieWSYlO5EUnnbJNbe2xQor0WFfC3one/W+0uk34fykS1s1K6vzZ4jWlwJAI7
 gdd3CpraEdXxFJiE/nbmKjHRXcSV9bb7FPHshlDoiA0nJxP46T1xCrxK2tzjgRvlbvQ8D6nldal
 3+LGs0n6eXKo5/upKc13c+I1KcY+V+R5ly/++pSkIbajD/fMxgfenJbEgjEhfO779e/2EFyIY4R
 Q+ktvgMQV3ASrVP9aJlr9qvoQXiM3rtjK+kzIMcUicZ3TWj8pH17JpFCqlYJYED4Db8HqPZiIST
 UJJA2rr6p8xhs9DuF4w==
X-Proofpoint-GUID: dyNhNz11mFhZj01lY9gkExyGYPFHfo-T
X-Authority-Analysis: v=2.4 cv=bbBmkePB c=1 sm=1 tr=0 ts=699ee048 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8
 a=kiRESG9uuu1a7uI29B8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1011 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602250114
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C06B20004
X-Stat-Signature: 3rom5rs4r4yctdntq147age3wbgdru53
X-Rspam-User: 
X-HE-Tag: 1772019790-223413
X-HE-Meta: U2FsdGVkX19xeGwrslYPFXXcfCA4Sf1rdHGs3pxxBgQ9nwHoSfUZR02A7jMzx7aZuTxS3QTjRjnlcJRzcPc2KHzpN+wEwY79eQ6yD3TxzCiLep9lcCFoC3luTpvzBXRGgWcu8HZuaakxzdrg4SIgJ1yX5HFSI+rplQeqcP/zluWPoq3cGIv2VdxVVvRIU9gqPbASUbYjYhpvoKqYOxVsbN/z6TqQiS0ZXlksVX36I8qfUPlrOxoS/gSE2cFIshUiyC3zh7gtYvQDJR0g+KJhOcHHE0dSPzJBNuc/jrmQku4gvQVW2aE0H572k0po9EdkP1c1ediRoTmXFTkN5P4poL83ZVm0V3qYaele4R2Dd+VNX3UtYpcGWoZbYINtohSam/TUcvNJOCXBAZBIaUJ574xupQwWGviVRe/Nvl8IaXNftsAeaqp/85bWoA9c/KeEWCAMGMYdwR6RHqQzCBDhCwvwDkd9WbmFbhPIGdjwDPQSf5h8hynMTOjplIL35XYGGlMKvvQNF4cx7nndBeNizBENyWarbUbG1+/KtyA5S+q0VHY2cqAdsMBQ6EVA5EH7tFKhKjujlM0iJTkdEccWBXICbHMBlwcSDxbSO7SBbFTroSQ22dy06gZelpTc27pQVmz7eY/5XJjvtQQp5y+8GlD2ARvM+f+kw79FViBe+yFp3a8nxkBmbp31sVrpn/D+xIZXnqohPPHnmdISHwEuOulTc1UU1CTrB2o4AfW9l7xeVsh3AwjjoS4Sv3g6h0OL+OKEFls8pL34Ui/lmIxAA5Dw2nKb+XaiUec1hOO9ulH0nZHIHtcUEdktoYJoqyHksIjrNxQ+t6kJm/vj8ZKA/QdrfJ5iIXteGPMsaf3s2S5bgTAxWjTI7F6AIP3NIsjbp3+0sIOGkwlexojeH/Hfu3uEdGhPQQQBDqkR/1qPn4vi49SQzjGHL3HVB1TmJMUpYI44DqI7MUkbdtor94M
 BUBKN0rN
 wU5uRJ6tWg6XNKtUlItR8yfzv5k/s+3NXM0n6V68FMQS3iogF12Z/TVpwQW/X3iXYLxl7N5yqO289y9Yf3ml+Og/r/M64onhSR9TLGZplNRkKz9WUnLHd+vdLza+hvxBfqBAqrjG7xut1IheEbJEDJrnePtMX93P+vaVwr0BOPcY3mvjLlyg1DYm5EXkZ3BWN0fykbv+X5Jcz9DR5ztH2yt3QkT1yOF7g/OWarlXawXj9wzjI7D30/HsAXU7SJ6NPe18xtSzcN+J/tPi+hI4KYUwwTyWGdIlkEEg19I7yupkN8rUHvNspt6s5zSl8VtBpVDTk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>

powerpc uses pt_frag_refcount as a reference counter for tracking it's
pte and pmd page table fragments. For PTE table, in case of Hash with
64K pagesize, we have 16 fragments of 4K size in one 64K page.

Patch series [1] "mm: free retracted page table by RCU"
added pte_free_defer() to defer the freeing of PTE tables when
retract_page_tables() is called for madvise MADV_COLLAPSE on shmem
range.
[1]: https://lore.kernel.org/all/7cd843a9-aa80-14f-5eb2-33427363c20@google.com/

pte_free_defer() sets the active flag on the corresponding fragment's
folio & calls pte_fragment_free(), which reduces the pt_frag_refcount.
When pt_frag_refcount reaches 0 (no active fragment using the folio), it
checks if the folio active flag is set, if set, it calls call_rcu to
free the folio, it the active flag is unset then it calls pte_free_now().

Now, this can lead to following problem in a corner case...

[  265.351553][  T183] BUG: Bad page state in process a.out  pfn:20d62
[  265.353555][  T183] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20d62
[  265.355457][  T183] flags: 0x3ffff800000100(active|node=0|zone=0|lastcpupid=0x7ffff)
[  265.358719][  T183] raw: 003ffff800000100 0000000000000000 5deadbeef0000122 0000000000000000
[  265.360177][  T183] raw: 0000000000000000 c0000000119caf58 00000000ffffffff 0000000000000000
[  265.361438][  T183] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
[  265.362572][  T183] Modules linked in:
[  265.364622][  T183] CPU: 0 UID: 0 PID: 183 Comm: a.out Not tainted 6.18.0-rc3-00141-g1ddeaaace7ff-dirty #53 VOLUNTARY
[  265.364785][  T183] Hardware name: IBM pSeries (emulated by qemu) POWER10 (architected) 0x801200 0xf000006 of:SLOF,git-ee03ae pSeries
[  265.364908][  T183] Call Trace:
[  265.364955][  T183] [c000000011e6f7c0] [c000000001cfaa18] dump_stack_lvl+0x130/0x148 (unreliable)
[  265.365202][  T183] [c000000011e6f7f0] [c000000000794758] bad_page+0xb4/0x1c8
[  265.365384][  T183] [c000000011e6f890] [c00000000079c020] __free_frozen_pages+0x838/0xd08
[  265.365554][  T183] [c000000011e6f980] [c0000000000a70ac] pte_frag_destroy+0x298/0x310
[  265.365729][  T183] [c000000011e6fa30] [c0000000000aa764] arch_exit_mmap+0x34/0x218
[  265.365912][  T183] [c000000011e6fa80] [c000000000751698] exit_mmap+0xb8/0x820
[  265.366080][  T183] [c000000011e6fc30] [c0000000001b1258] __mmput+0x98/0x300
[  265.366244][  T183] [c000000011e6fc80] [c0000000001c81f8] do_exit+0x470/0x1508
[  265.366421][  T183] [c000000011e6fd70] [c0000000001c95e4] do_group_exit+0x88/0x148
[  265.366602][  T183] [c000000011e6fdc0] [c0000000001c96ec] pid_child_should_wake+0x0/0x178
[  265.366780][  T183] [c000000011e6fdf0] [c00000000003a270] system_call_exception+0x1b0/0x4e0
[  265.366958][  T183] [c000000011e6fe50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec

The bad page state error occurs when such a folio gets freed (with
active flag set), from do_exit() path in parallel.

... this can happen when the pte fragment was allocated from this folio,
but when all the fragments get freed, the pte_frag_refcount still had some
unused fragments. Now, if this process exits, with such folio as it's cached
pte_frag in mm->context, then during pte_frag_destroy(), we simply call
pagetable_dtor() and pagetable_free(), meaning it doesn't clear the
active flag. This, can lead to the above bug. Since we are anyway in
do_exit() path, then if the refcount is 0, then I guess it should be
ok to simply clear the folio active flag before calling pagetable_dtor()
& pagetable_free().

Fixes: 32cc0b7c9d50 ("powerpc: add pte_free_defer() for pgtables sharing page")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/pgtable-frag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/pgtable-frag.c b/arch/powerpc/mm/pgtable-frag.c
index 77e55eac16e4..ae742564a3d5 100644
--- a/arch/powerpc/mm/pgtable-frag.c
+++ b/arch/powerpc/mm/pgtable-frag.c
@@ -25,6 +25,7 @@ void pte_frag_destroy(void *pte_frag)
 	count = ((unsigned long)pte_frag & ~PAGE_MASK) >> PTE_FRAG_SIZE_SHIFT;
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
 	if (atomic_sub_and_test(PTE_FRAG_NR - count, &ptdesc->pt_frag_refcount)) {
+		folio_clear_active(ptdesc_folio(ptdesc));
 		pagetable_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
-- 
2.53.0


