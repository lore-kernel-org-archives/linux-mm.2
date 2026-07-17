Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D1CC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 15:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE636B00A0; Fri, 17 Jul 2026 11:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B72A6B00A1; Fri, 17 Jul 2026 11:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A66C6B00A2; Fri, 17 Jul 2026 11:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 241226B00A0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 11:57:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFAF41A0133
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:32:34 +0000 (UTC)
X-FDA: 84998358228.21.BD62793
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id 711DFC0007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:32:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="BWGUdR/K";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784295152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hv3MCqUl10qHtcMMyBPEBq70OO1Ou5CXW72neiXa7f0=;
	b=Sf9FwiZ5Fccz3ybqGEXcTYRk164YCueQxdyX7RKEsv1NiRs9BDGQMVRvXP3Jsf5Q6VlmPc
	bOI9nE9ciiYPdwPU0LDp/ZV506Cbr+V8Drtvp95bTS++IAshJYRuh7BUMO6ZOPS2D5bPeA
	PJKk3hgDiCtBc9N/ILKw2Q1UIvrtOow=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="BWGUdR/K";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784295152;
	b=XBtTUHq8ctvyzzi8yp4Ix5Hi+vu+2FJBbpNiUIDCzUvvq3jIEmKKFjMYspegLWvWlI3KZc
	5TyDl9/p9AVofkxnuZwox9CxljisPDrJwvry0Hv4VJ4jMuNDvMZYz9APQOg1WHo7EOCZXt
	sdm20r43Uss5ONnk1dBgl88l2S/9Yig=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HCg95O2057668;
	Fri, 17 Jul 2026 13:32:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=hv3MCqUl10qHtcMMy
	BPEBq70OO1Ou5CXW72neiXa7f0=; b=BWGUdR/KoyBCcKVqRpwUIrKMHJEXCpzo7
	Fv9gye7RnnX9iAT1JZSvAkb9TmbiCawPjJ/iG2q2bP0F+qE2ZEdd46hxSqrsPmVj
	JRuFQ7P0caExpO1zOtEpkBRsdx1BrtgBRsrWdCJ9kwZUu268FnHuhBKgmYOToA+p
	f2bBCewoAxOEtn4lRYTOH87joGJ8EeNtwbOPGzLtZs9AXJrpv8ds4BmR2k6iShfW
	ZoAP2GIAzxaNyKfKvuodBQQGXpbIG/LUOICX/Vxp49TTgHQIzyFWBoAhLzMFw75f
	gzrAgAWfb92fEWe/3TRTjL+ZeqnMOMPYs7ekJ2UJ2u3akfp9k6smA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbegtpqkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 13:32:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66HDJh9p002357;
	Fri, 17 Jul 2026 13:32:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fc2cgsnus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 13:32:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66HDWNh050266490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 13:32:23 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E733720063;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7A932004F;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 9D76C162754; Fri, 17 Jul 2026 15:32:22 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>, Chris Li <sparse@chrisli.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC PATCH 3/4] mm: introduce __ptent sparse attribute
Date: Fri, 17 Jul 2026 15:32:21 +0200
Message-ID: <80bfffc76cb5a270aeabda26f50f65d10742a1df.1784292223.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1784292223.git.agordeev@linux.ibm.com>
References: <cover.1784292223.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4icc14cu2ighxfl6FYrzqzdyrQx3mEWV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDEzNCBTYWx0ZWRfX4Bm51xaL6rTi
 EoPU+wFi1ueRET11r1OsI8V/rbxrp0TbXSv/SuFljLrsDNIhjEoHQORIkWofKYC5a/ohNs6Idsr
 UaYO/00+2/vfJlZIkJtyJJ8uxlMJXkk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDEzNCBTYWx0ZWRfXxPMds4jv0n+H
 AeGHMJuxoDM7Lw50LDrxQbVuja2t7abTeOhr0aQJHg48fvY5yj15BCL8D7ncW2NAAWoLzIqn4+w
 mjcYTW/2GtwkXFJmlohKG7zuaf/73a5H8iJTtMFI1GtZu+Y6FF8UGiwIPdZ2cj1XXFhA0mrxOEg
 mQdetyOdo1xyH50Hd6z87t3NwtKS6lHhl0sF4a03XozRCIET7bmVvo5lXP/8x2InLw7v7SaviUm
 LxlOiI/OaWwCn6absDQtSMa9FLzFoCNRWtGyMqlBnxUABvJl/vkgi5/RRzkIjzYsyZyfa2filok
 hfveiTHpnBA6exlhuSoCBxxViVN/orDTdAS4hVn1BzCyTiqkXiDX61l69bZnQgQJIhAjF+0ZhEb
 jZNSDGogIm+ErAWXOhDJWXc8ck9FAHnD5/9N9Lope7r8amZ4lSlh6Xbc3Lqw9zjlPkg5/vOFqjY
 gid1QLCMR2ww2NU1IqA==
X-Authority-Analysis: v=2.4 cv=IqMutr/g c=1 sm=1 tr=0 ts=6a5a2eeb cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=htX2hAWjaI0RTq2uS3kA:9
X-Proofpoint-GUID: 4icc14cu2ighxfl6FYrzqzdyrQx3mEWV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_03,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170134
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 711DFC0007
X-Stat-Signature: 7jic4q4x1n351wxr7qupsy3g3nxx3a5a
X-HE-Tag: 1784295152-254901
X-HE-Meta: U2FsdGVkX1/SNQVPV9tSM2tYlDPalTSMvct2+4kj7Htl36BULmRsTaVo01FuuCydft/Hqm169PVDY9b2IR+Du/ivg8NmNbFbEzdR5thRLAf4fbQy28yZuJ88y0lQMm8EOBWgTy9DjthvUFV6DO7syVhhYrzSQcsNekskT1qENIN0TM2bPPPNGXs0DJ0CEFInGRG/FQAVTYNi0c024pCSZCJqXsm3I5sNhwBbSiwZ8iQWw19fPZrsxD04vmcKrG330G3y/z9Du3tqMR/YZUE/IJC99UxpfwIIOJe0IiaRdlEBiGkGoyx2gT9oH/i/BTz8zRRWJzbBDhQ7ZUAi/Gj1zEdCF97vwNq/MVJLaxydAwG7zDTt0AqkymuyQp7ID5QLL/XzLDN473DExT7eVDlHtcSZYDpjiqMdLWP1bw3TYx55R6hOkf08HJVbzGqW2murIjJsauUZqVS7v2Ca22qBiFq9ZZPucvuMm8qGrE47Jzyz03nRXFxGXIUUp6fE59z7ypQZqWTgPLBaQ+LkLQIaLTN/TKp00kIWVCy6EVcOkDGUZt7FdzirKA3txu/eD2rezhIAbwRsP/XZGJhwTNWfozmBK0qZ3dc3GF6s34ydqtbSo/f5d66H5cx2VJYRqsEfXTagUlovAXhB712qZgtJ/lWCNdv0HhA2FYoKe14O+eMt+5Z6swF29UkZuPEQjr4b4c8ohibNxj7D0GmKyvBravcnu2m+NrOgCMQeSGticYgCyERuYzK0S38w4d6SD/Gn1nlWXbBYbbnwdU6T9qkopW3MCuWCK+oXd54h7I3y7xpk9+tFZnKBmwgSgc0ojyIecCvTkVu0o9rhYjgwRlpT1PzeOcZlUaF6Tos6eHlIB8WMwytof7bUIRENME0OTM+uORmziZmHWVxC5csMNETdMccj7f+17/0ha1BzAp5zo9V2a5MYjjbGZXOgJALPhtjIbU7d9j7juk2oTI9ohdI
 NSLzsUQI
 q4OOiYDkJYsREfY9Vv4DRufHmpkGwsWHJxRP7XFB1UBpuXqYOFlQtD6fNRZVkKqmKjmyY1O7fxdbUDFWvmGoQb8yfoJJX2kFYfxwlrjoBmn4/uCJCBgufMxsO4Ejhk9Q6aBSvKST61ppFsVaotSbfD09/ZDoG5qycdwBcW1m/84t97/E+rEWx8gE97vCXYDQVbPocGWuxu5im4ZzrWHQkuw6GkWEIgmqX9N7iy/5SJhOM4z5X5ctqXVuV7BJ1tiG2xGgdkunZGvjtZaR5vjFpPQPC1WOa49u9UU/4p1gUliJlmuUXEBq+tkArvUeeEGp4KLc5CWD2VkEYvDPwSHGzGNvRpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new __ptent sparse attribute to enable type checking for
page table entries. This attribute would mark architecture-specific
pte_t type, whose pointers should only be accessed through proper
accessors, such like ptep_get(), set_pte() etc.

The corresponding sparse tool rework for this attribute is required
to cause the "dereference of PTE pointer" warning.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 include/linux/compiler_types.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_type=
s.h
index c5921f139007..472af4fb2546 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -58,6 +58,7 @@ static inline void __chk_io_ptr(const volatile void __i=
omem *ptr) { }
 # define __nocast	__attribute__((nocast))
 # define __safe		__attribute__((safe))
 # define __private	__attribute__((noderef))
+# define __ptent	__attribute__((ptent))
 # define ACCESS_PRIVATE(p, member) (*((typeof((p)->member) __force *) &(=
p)->member))
 #else /* __CHECKER__ */
 /* address spaces */
@@ -78,6 +79,7 @@ static inline void __chk_io_ptr(const volatile void __i=
omem *ptr) { }
 # define __nocast
 # define __safe
 # define __private
+# define __ptent
 # define ACCESS_PRIVATE(p, member) ((p)->member)
 # define __builtin_warning(x, y...) (1)
 #endif /* __CHECKER__ */
--=20
2.53.0


