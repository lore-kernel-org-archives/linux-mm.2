Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650E6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 20:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121836B0088; Wed,  8 Jul 2026 16:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2A96B008A; Wed,  8 Jul 2026 16:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06006B008C; Wed,  8 Jul 2026 16:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C45046B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:22:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 470CD168D25
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:22:26 +0000 (UTC)
X-FDA: 84966731892.10.D2F31B3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 121F3C0006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:22:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Cr+j+iOX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783542144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tknLwERrIw+KuUXCBYFFzSBxUeBG9hYB7jy23J8B18Y=;
	b=kFeCLebYWjAazqp2R4CO12YUnGU7DRfb6Fl1WoCkDPTmWCBA1GtD9bTobhbdxmOPLem0Vj
	iNuymBq1byv73bSDc2sfOjyzqdchFjccKtGXDcOfH9e6X0/Wmj8qO2c8eeDM8ZbP5gdHrI
	Ta8CysteFwyVhLVPnDhBwbO3FA9zx7o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Cr+j+iOX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783542144;
	b=AWgEtSkEJRz7CfO4rF/+lFGL7yq0tZNq+JMDWf4hqooBcD3JUzctvdxb727oysgip9W+zm
	an0gLsSWsKd/el/NAvnLqogk/2b5zbEWAEkW3N74zDiogv3J1d64yR7b1q/ww1CJGfYIXe
	n00N8rhecavNlLNO8d97RImdoFTX8Ng=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668KIKKa3699062;
	Wed, 8 Jul 2026 20:20:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=tknLwERrIw+KuUXCBYFFzSBxUeBG9hYB7jy23J8B1
	8Y=; b=Cr+j+iOXewxEAY6jFJQ0UoUWwF7De1VDHWQJlAOzfegxHUMyw7Rdvl3xw
	BFHSzsd7Zn5pqGApoqPOcB0ItW/s/U0JnvC5hwaoq9j+XATOHg/rzuvnfkquNpMa
	yTSEDcTmj0YC6lLaxpqhykyQ9O6zC8HM4HkO5SzPE0HuodAzTTJrt/nOcmb6B8J0
	a90ZnHCHfOoYl1eSdLl5ZTDNGjTUOuzlhwbz/PJY9WqxCfV1d7SFpLRuhqtOArBy
	uo1rzM3uzSCPKMYebRsVobWD4mL/gJAFDnHTT8NMBkNjQp/Ba9vSt4paUmWLnZAJ
	STSpmo3y2zQuwCtT7gW/C3s91hCtA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f6rkdxnyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 20:20:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 668KJhs0023235;
	Wed, 8 Jul 2026 20:20:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f7eqg9k44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 20:20:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 668KK0Mo24969686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jul 2026 20:20:00 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E94C220040;
	Wed,  8 Jul 2026 20:19:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2909420043;
	Wed,  8 Jul 2026 20:19:56 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.39.25.152])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jul 2026 20:19:55 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Luiz Capitulino <luizcap@redhat.com>,
        Sourabh Jain <sourabhjain@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aboorvad@linux.ibm.com,
        stable@vger.kernel.org
Subject: [PATCH v2] mm/util: don't read __page_2 for order-1 folios in snapshot_page()
Date: Thu,  9 Jul 2026 01:49:54 +0530
Message-ID: <20260708201954.686111-1-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=M7J97Sws c=1 sm=1 tr=0 ts=6a4eb0f5 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=ySnz47qbrfd7rJXDOpkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDE5OSBTYWx0ZWRfX5mDbOq6xxWQi
 Md8rcKeDavIliKimRjqWK4Th1p+hb/s96U7lAxydA8YbM5l/i8p9v3D3aup1gmeBjCYc1gCbIuz
 OmUxkhUAxSZ+y9pB6ltFH+c1tQsgDFcOnQKiqqzcM/Guum91eXzY+oicuIKCMV8YWKq4IDGiAnY
 ZHm5+CEaYgrnx/jY4rh6mxhaqFJpdn0qyMyX0r6NPyq6OYGwjqgbNd8gyFSJhEUmFKNfOZ2/bmp
 ZIykLl5s6ATGu6vPjJ6Bnz2GxASsf1hJDaGNiYisz+ePjEc1krK2ZvM9PuuzKVwyVsgqAKQHS50
 7rEcfRYHm4PWnDfL8QIXnF+paT9ZgvYgnRRzrFLLruiCAp2guG7xKkSBaQytWVmnSseZxaProZy
 jiF0xvasFimeAU3dP/Y+NaM2UX9xjiLtBGeTfAGIMA6q5K4XO1m4IOkVal3gooU9ENVHCvl78sR
 KlQlSvjsp2xZGvo2BFw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDE5OSBTYWx0ZWRfXxVPDhdDTJqjW
 +DXsqtkyUjv6DPl8mTZ7lfoBLwwh/8v7PjZ04VhoVxffwe9KPTU/oT8AdXK36td2qJZDz2PuABC
 wPCCfMbD1Kkk3S88IvAxmB+VJ/hTGfo=
X-Proofpoint-GUID: xMBIo49HIMLhvUE5H9tE-NFN1IQ8dBuy
X-Proofpoint-ORIG-GUID: 8tLAzdzqwcadh2QqphpNWfyNEjWxcXcW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-08_04,2026-07-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080199
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 121F3C0006
X-Stat-Signature: 8hq11uxh33yohsitncta4j33x3btzx7w
X-Rspam-User: 
X-HE-Tag: 1783542143-750503
X-HE-Meta: U2FsdGVkX1+iLEsbfEnlUq7TKfwEPkDMIiEMX8pLGvaBIo6hSCh5unGO/v9g0/MA/wWPHDwW+OTkCyXItTMuUHORy32OZaCnxAO78kEvhtbZ3J3JH0o4eAsKia6vQLolys9xiiMjTmYcjutdA9EyUmKMskcamKqSvLDZM7Shue5sGfMjgdkG3QID1TySalWD8crIceEYz6uMmMl4xBUoA+ID3nXPcaSRPpEd2YlCGPKGr1kzyKRvrz/ZfOJ3L702WieZziv7G52XZc5AeFu7lFVAhkoJ0MLFSlszkaTNsZNgzsPubcpSwvo7Prn2Jt6Us1evCQnaLaMqk0V1/O4r7TjSnLRM6u0DqK8wAS2Wt9eShSFFMkxzEO6opxGEgg5k5xcqBt1Z4FiJ996QeNdK4GsXpvzIz79W0tvCM8Q8n3ZtEDh6Ptt9vr0liy/DCszdiN+SEqQ9EluxMMADCbP780cfnXhXAJur/b9RxuDbDKes/5fLcZuudJCpxx4lqh09hOV8l3LRWcul87+cKR+THPd9Fs0mQC7rtMmvdT/OFyj3QuXH8gEjGto2r02PtTAmwd4bzx8+VE0N5egTswY/4HDm9LBBl7uUMoxu+6vNU5+qqOjCDZdUp0pdr/1l5zHxsY1T5amPLFc6djDEj+oaLzc5V7nNGMrPl8nIMuUCTGfazROiT+DXE5mfLhv1LymOay0OMqCNdg5reHDzoqoScpgIMirbGG+iuij1XqJKl2NSacLX17lY6+4WIKC02hEyPr1q38NNatU2wNR6njuKFiltvVtRnCkA5CDj5hkAcGj3Equ20BVz2Ib69BmAcBfp/Sl2R/FY39OJroCv/SehfiR6ejiMinDNFrEtj+NUh+A67rs8mzdjuSK5WEtNa49NgSJavNfaH1eSPkFcUkfjO8+4HMxNjCXIwUSYRcJPDBfyM1k0aW+duksoG9Npk3r4TQ2e2aQ0WoOcrJJb+DI
 nIXUnxeX
 EUUqDUvnne/BTDELHChkBgAKe+efPTlBmcvWxJ3tal1I+83NvupIsKNLH3yKIO20JYcf06++kqHFeMmKSvTY+KfaBcZ9cATR7A+cNqEJu5G+QRyz0ZBMUERd4z1q1Ge1CmxVXxCTx+FFn6BDbWfeZGFG135MmEmYrAZW+vN0i+T22LL4EzjRxmfSRjI4NViP2sRAbHU/eDZFTPxvUlZx6eX5fiSjFCnlxmAT+TijoV4gQMIlnDm9lNCQPqx0yJeWV8jbrMOz/5IjX/ueq5XH+yjYXbt8u8maK03Hn/Mjc09Fbcb3QDhCa0CtoJgUNWJmKwq6VDgJFcBIn1vr78E6BHD1ImJ9zEc+VgfmV3C68rtkANNnEzHF2PxvLx8Rje6rRIhct75lSFY5xAXN9aDpzfkFJkgww6Z6c7z0rrLMilSZ79kmhxupfKEWNlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

snapshot_page() currently reads __page_2 after checking nr_pages > 1,
but it should only do so when nr_pages > 2.

During DLPAR memory remove on a 22 TB ppc64le LPAR, snapshot_page()
oopsed on the page isolation path while reading an order-1 folio's
__page_2 from an adjacent absent section (unmapped vmemmap).

Fix this to avoid reading memmap that doesn't exist (e.g., a vmemmap
hole).

Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
Cc: stable@vger.kernel.org # v6.15+
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
v1 -> v2:
 - Condense the commit message.
 - Drop the code comment.

 mm/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index af2c2103f0d95..34cb43b3eaa4c 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1353,7 +1353,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 	if (ps->idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
 		nr_pages = folio_nr_pages(&ps->folio_snapshot);
-		if (nr_pages > 1)
+		if (nr_pages > 2)
 			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
 			       sizeof(struct page));
 		set_ps_flags(ps, foliop, page);
-- 
2.54.0


