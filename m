Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0A3F43834
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2956B0088; Wed, 15 Apr 2026 11:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62E06B0089; Wed, 15 Apr 2026 11:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951CA6B008C; Wed, 15 Apr 2026 11:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 862E26B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:01:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23B891B7FAC
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:01:35 +0000 (UTC)
X-FDA: 84661104150.02.F137B6C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 864E8C0026
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:01:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cYEfPX2+;
	spf=pass (imf28.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776265292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AawMJZ37vHT913xUBz+7vglL3k1ezbWLUoslTSp6LiA=;
	b=Y4T24E+La253RUod5Fhsqpa47sCVGf+457PYK/cQK/vRBHCqrCi5uc0FH7Vu55ecYewJr0
	E73IiKzw2gw4InECAWxP5zwcDjkLtyj+6f4a0PjLykQ2lDq0apXgletwFscA1X6Hz0eW2m
	1zXmPl/OYdjEdeAQndJ8JsGJG3lVtMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776265292; a=rsa-sha256;
	cv=none;
	b=WKRuboLG3cFDw8+og+GhS1JvLhovI9snxdViozX7dSligaun5d5ImPP27RSlv0fCoU3s80
	ejSEtxnLW8D0K/DcznsMy/xGZvRtqsX8I8YVYI3vLTdEM7NBzog9Ws1jcB5tOA0xxQJwdG
	8DmTw1YJ/x7iT7ZNfjlmWmCFkhKRvUM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cYEfPX2+;
	spf=pass (imf28.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F5Ymit1804412;
	Wed, 15 Apr 2026 15:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AawMJZ37vHT913xUB
	z+7vglL3k1ezbWLUoslTSp6LiA=; b=cYEfPX2+xsn/zvNvDiqCu4hW0WKZgI5iH
	CNWdxBzfnn4p2opp/rW96qzbuoDgIWohtoCIc73w8Adt4F9HTVMFj5sZ74ogmtsc
	LF5f8qAD8YRpEa2g9a2hpPw0fx4oHIZf9/A8WvXSC4W5aoZSszxhkEHHAnHsW0Or
	W1sl88b31aEfpQ6dJbs4UektcjoREUiD+PpVdlXk+SFl1uxlNzzaajL4rvGNwVNt
	I33lpLeqe5Nsga3qu/xmTIepn1RUfUP9DsArW0davJqqI9bdvhrDW5LdDB1E7FFV
	tkeOtwrH2VRaGAwTrWxarfI4hra7TCQNfMjRz3FM9pPtO9J64Novg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89k86ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 15:01:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63FDfIIR025621;
	Wed, 15 Apr 2026 15:01:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujph1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 15:01:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63FF1PJp52822400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 15:01:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28CA32004D;
	Wed, 15 Apr 2026 15:01:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC57F2004B;
	Wed, 15 Apr 2026 15:01:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Apr 2026 15:01:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id D1358E0801; Wed, 15 Apr 2026 17:01:24 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] mm/pgtable: Fix bogus comment to clear_not_present_full_ptes()
Date: Wed, 15 Apr 2026 17:01:20 +0200
Message-ID: <fecfcf70436e267968c1c3b6908e51fe49fd9009.1776264097.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776264097.git.agordeev@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wUxFePU75dFuu9XEQYLQp5QQWQdNErNT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDEzNyBTYWx0ZWRfX8o7nYZds3FYC
 F6xqkVk1dSJOmSv/MJgyTp8+yINiHneLwX5S9OyqoiaSxFVG0/JpNeAez/M1WtuCddni9FgWz7T
 iLqZkMcs4NhWNcFBaAfDMXJ+B9kZvMNI47edUZfB3+lX4nWHGK9akwn/AQVhhmV42MIwCRNv75v
 3B+NTFs5I3B9Hl/Px48Ovyk2y3NOBYR3Ec15FDlxL1sQ5hegXJIknGLi8xmb3o0vR6b37ys8CN1
 VyvqXZ0UH/CgfDrxPOQBZXq1rxz+kXDbY0TtNwAVJAMGmY0q2MIu47qAhRKC2T59AFf2uXyhFuP
 dsURtePZdS5feQxNzOlGlOvnkvoUebKtZfTyZfz5cBT65tPP6Eal30KwLU8ZG31izqvfxBQ6hoK
 UqXczHyupaC/lIlj0SYAjBP48Qo+pr7hfINpSMr/l8UWQ5EP65DvhrX25Oe+numhFvh7o/g9JQS
 JxXrxDnaz60fsSqcpMA==
X-Proofpoint-ORIG-GUID: wUxFePU75dFuu9XEQYLQp5QQWQdNErNT
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69dfa849 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=7CQSdrXTAAAA:8 a=VnNF1IyMAAAA:8
 a=q9Jasox5db4hgyQSpQ4A:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150137
X-Rspamd-Queue-Id: 864E8C0026
X-Rspamd-Server: rspam04
X-Stat-Signature: yf4fryqk3zmsgcex1zwwhrinxf3jb59j
X-Rspam-User: 
X-HE-Tag: 1776265292-41670
X-HE-Meta: U2FsdGVkX1/dZaZ4MPDAFNN01nfIEqXZzhqUbyBK+zxNY/e1oPt8pUqCZ2LphNqK4eW8+W8x8Cho9b8TXE0QcQhU/e7RS/wnangBc5qlVkFfzzBykOnDAZwN0Aq4VRcQxB30iZddeojwpOVB3CJS4GHd6TSmxAYr257hK7Uhb9AFSAHPhsxPrggvLWz0V7edN3+r4WAdOEOQF6BaR35Ebdc1o/lblcpwuyCUDsTRg9CT6u2IF9DeLNvaafZ7r/XflPwfvc4nbVMGezYrTks7tclz4OEFHGg3qz5YJ5NHsrOWpb+KjgFzL2jXAkcky0/5YJqor5LJkN/HvyDrbzY+1IBmibrbEofGyxtn5+LoNQ1f+sLi30tTELplelgMs8rMv+pJI6A2QkiW6AmXaQhyUsXTRaXjK/Qco/an2aM60+VeRo5kwFrbfsj+XQrX0nECJLtdDjK/zVx9W28+vwcIMQzqePrLdxXaWk3XJeUK/XSiO8yi/P48XOBbfsNCgSWAFQJybuL5hA6T/ltEfzNyX8jQEsnbtnH5Bs1UCphAugMdXPKkIZKUtxneVXHUBk0bAacczJkJQmCFFgcm7vUgeN4orjqIEEPKM5Bpmff8OGYWxES+uWSMoFJ4iaM7SRW1Ah+rBqNdtKcrKq23wWPf69eLnctAjGWXiMQI1C9ribhSfdsUSRM5PLzTaNYpH+mgZGK8x6j7ry0JymLummCm2wBt4H4DrIblBihm+OqvNuXOYv9iZIQTem/wTqo1DvLAfiRBE3rooBTLnksld0soT8fvKDz846ovsowrtISJk1MUfvl+HrMztpdhf5IuBVaaBoBfTp0lr+eCtgaZZXzyXD7XtwD/DJnEbkX+vUu2Uaq9nOy2QaYozsQ+p916Aai60VrgbT0UH/AN3VOAChMowqTP7EXOqdrecGBTJsZVVtqOWmTg2YmiTTKStGSGk8xSy63fB37mr5CDTS4glE9
 XBk2IaUc
 ZdqK1f8hI5pUqW3Lj78mIUjGP1NsOemIZVbPLOA54voFd+utlOAqvzzItp4lLCagc2jWuuucOWgwchE87vsX+mXivptZoqKZtm3wEm2BX6OxnXl3JgM5kRIa+mEwzg5ClZ9y0npoXwQax5WvPXhoJ8du13hsOWVDX3Mb5LLz0ZSWXQGKF8ugO/Owr6TvhIDV+W9e9FynDHnizM6SZbB4qxlg1HkPwlRWXNuLLHxYpsiMh5w2pEfneM25TF/FMzlpOXmrOLSupKUe1BkBhSwmYBbvAd+4MyjET86Tawss8FdcIVBhTgxfhqznz2vWpd66LhW+O17Ngx3OH6GqgeyNcDJKlFlkOT6eNu/zUjcjDcPR5rnuQOl8xcUrcDHUhRNcWd6sHtQLvPXd/aGvn+kn/+jpJXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The address provided to clear_not_present_full_ptes() is the
address of the underlying memory, not address of the first PTE.
The exact wording is taken from clear_ptes() comment.

Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 include/linux/pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 9ff7b78d65b1..2b82a71f13d7 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1021,8 +1021,8 @@ static inline void pte_clear_not_present_full(struc=
t mm_struct *mm,
 /**
  * clear_not_present_full_ptes - Clear multiple not present PTEs which a=
re
  *				 consecutive in the pgtable.
- * @mm: Address space the ptes represent.
- * @addr: Address of the first pte.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Address the first page is mapped at.
  * @ptep: Page table pointer for the first entry.
  * @nr: Number of entries to clear.
  * @full: Whether we are clearing a full mm.
--=20
2.51.0


