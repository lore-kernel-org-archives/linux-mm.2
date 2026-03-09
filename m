Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE894FCA16A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 17:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251416B0089; Mon,  9 Mar 2026 13:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225976B008A; Mon,  9 Mar 2026 13:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128AD6B008C; Mon,  9 Mar 2026 13:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 044D16B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:51:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8B921A02ED
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:51:45 +0000 (UTC)
X-FDA: 84527267370.01.F8C8311
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7DFE7180013
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:51:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=MfdWxYUf;
	spf=pass (imf06.hostedemail.com: domain of mboone@akamai.com designates 67.231.157.127 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773078703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKJJE1a9/G6LVwmqfStU9M/AiiM+ISgsUS0KJWYykqA=;
	b=o76B5r/D9Rd25X+yPwxcEv035DXQvYK4Gp9uqpaI024u4wXDhtCXicLn3A7DCDAf5uZwe2
	+b7NMdn8DYwjQoD26em6pyM700QDk3eSJZ2TZbbDCgw8ig+af5SP3yvSTd1zIJ4s+f1jry
	sWwk2HR7y1/jpIKbsVdtqv6gdCDKWuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773078703; a=rsa-sha256;
	cv=none;
	b=eYpIs3gVcSlyXvNIebP9thUGQJvfGGuvKUnvwN1VbV/wsuCjUthKTwDyi3qEBBb4Dmpfj+
	pl1MKkoJLv4HTUtQ0lsqSsCBV1en0x4POONR/1afGz+I5DbfTvg6KVLxH1plW/x/HveZGe
	kmKeQBAZd/7Cuzm2VtFYaeXJZKzPBlI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=MfdWxYUf;
	spf=pass (imf06.hostedemail.com: domain of mboone@akamai.com designates 67.231.157.127 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com
Received: from pps.filterd (m0409410.ppops.net [127.0.0.1])
	by m0409410.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 629HTUvu2133576;
	Mon, 9 Mar 2026 17:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=jan2016.eng; bh=HKJJE1a9/
	G6LVwmqfStU9M/AiiM+ISgsUS0KJWYykqA=; b=MfdWxYUfo8XNAm5avcphPnFg7
	utE/UxcYAlRMM9H2Yi3FtqZgVW3+gD8xUQa/mmaG+QMPgXUuCZbBxwzG7mF1AJd2
	jyDGC5222/ETxXUxfVh6NkZBXLMCl7EWqnr81C2XQzSKUkq5AXnX4F4RaLMLfFRc
	prxVLNxg3euh+DxhcoQeKIvY19iEH2r/aEXCuzkdvTPiQLFQgTKNdG20oaKxzqzU
	6sMrSiG8i5zEOZyqqqw1lRmLm2Y2lsrFYWaMEmRpdAYHSW9+qmMaHJfxoWkk/czO
	Duv8tPfYvPeA5wv4eaLTUi3rJzfA0Io7PSzuFXUzrjzVXojTU0u+TwL5DUhng==
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18])
	by m0409410.ppops.net-00190b01. (PPS) with ESMTPS id 4cryt9g9sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 17:51:32 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
	by prod-mail-ppoint1.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 629HmuAB013814;
	Mon, 9 Mar 2026 13:51:31 -0400
Received: from prod-mail-relay01.akamai.com ([172.27.118.31])
	by prod-mail-ppoint1.akamai.com (PPS) with ESMTP id 4crg7yh57e-1;
	Mon, 09 Mar 2026 13:51:31 -0400 (EDT)
Received: from muc-lhv4ep.munich.corp.akamai.com (muc-lhv4ep.munich.corp.akamai.com [172.29.0.215])
	by prod-mail-relay01.akamai.com (Postfix) with ESMTP id 50CA889;
	Mon,  9 Mar 2026 17:51:29 +0000 (UTC)
From: Max Boone <mboone@akamai.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alex Williamson <alex@shazbot.org>, linux-mm@kvack.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@akamai.com>, Josh Hunt <johunt@akamai.com>,
        Matt Pelland <mpelland@akamai.com>, Max Boone <mboone@akamai.com>
Subject: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
Date: Mon,  9 Mar 2026 18:49:49 +0100
Message-ID: <20260309174949.2514565-2-mboone@akamai.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309174949.2514565-1-mboone@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2602130000 definitions=main-2603090160
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE2MSBTYWx0ZWRfX+lTaKK7/VWFw
 RX0cFG8smkSdrmeSg5bQ4tgQUcfySS33Ev9vGzp26TewWJoSEpLSan4TUFnG2lgGRm7G4xQKZyV
 eL8vcIVF/QDZ49X76BQ570AX2jNO1AucbJoxm8jYH5lR+uB4ssqmZdaJvd0FFa6aFjV9NxlfKI4
 DdFjPeF36unKLdgkFUsVi740c014VX+4nBpK3l1TDfahS3mPei7DZTEAWTFmGwWksR/kWMtDNeV
 4pa91v1w0UV4QDVggJzOjRMKtQy5RgXDIHoNbHffxMvkM6eKjkEIgQ4cQxfrv2P4uADhF+bs0oi
 mjVDCiHg+asfGLYI8jXChGbUpfSz5QkgbWUUTPNGc4CkVVCU4J+7H3vq2w5J2zHai+218oMvt6f
 /JjHyfOJIRR3+xaamLU5Ta1txRMNIAOQnGAA+BSk/yFZzlQqW04qIpOw4XGyaM/KacVJ3ToQisQ
 azw6/LjW0jpbMtpTZ0Q==
X-Authority-Analysis: v=2.4 cv=bahmkePB c=1 sm=1 tr=0 ts=69af08a4 cx=c_pps
 a=StLZT/nZ0R8Xs+spdojYmg==:117 a=StLZT/nZ0R8Xs+spdojYmg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=KDzEjHMMTas96-nIEKpj:22 a=X7Ea-ya5AAAA:8 a=TWRbNayY-KqUAGRnHQoA:9
X-Proofpoint-GUID: PQGRm8GX1GzudYyVcHmOtKlfYD8YwBf-
X-Proofpoint-ORIG-GUID: PQGRm8GX1GzudYyVcHmOtKlfYD8YwBf-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603090161
X-Stat-Signature: 4yri6k6adfzto51rmju6upapgg7psqoe
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DFE7180013
X-Rspamd-Server: rspam12
X-HE-Tag: 1773078703-324023
X-HE-Meta: U2FsdGVkX1+nRV8jHMbHaxRTVDkTgr0qIZJLxqQZKotRJ1f9tCK9GBsekp+f0DUCEDkTmNA6Zme8y7HevaeWnwmX9upBDBlK2H42AhjFpU4wZD/ArITc2x0oVKEQbPNCpIy7Kl43PvANSd0XsuRMLghfjl/upthPKPNja7OuwiBkiqwN8NykMlbZet0SCFDUZq+8bj9Gj/Tqf2Ny5kGIN68Qr4waM9y5S/M3IKC+T7PafDgnEkl9p5ofIFO/JwSIq6VIO9LiIe8JY0TbhPHyzWGXXQ9XgwU2bsWhOGm+D20C6JqveGv2Jm6uLve5QfN1mkSR8jv0y1+fIURCEsPwhRaXWps49D+TmMGJvQST5FW14lx3Np8HxHUuRf3hoeZNYNksKm0gWL8hZ7HpcC3yTHsR0THlAiPbLVu39KwcJfM+LppTNz+HEdq9NGF7zhxWcULLGtZE24MfLNnwsW2Na1eLiQRNaO7OxInProiY3lTkON/vW9plYF5QbUo4U9An01P2HJdPn098cviOdZAALA+i1PUFduA+Zsfm2f5bVCCkTRHlqL3l6BLQWOC1lJggbVgr3xQVeesKfU48IVHXb8OLnZyUeKUJbzDFY9RMb5RE2+ThVR2jtwtm4QnOT2XGjCdUSd+f1xZ3M/zhlizYBbwkLusB30h67fI6u+tuYugbDprz82Qafgh0DLQDtbZv27mrNYrw+YG0XbNCa9u83NvQWh4oN9glphrZlVbsH9ZoMDzwOZ60qe6YHZyjI4GPfn3L321P/hBtQBCYaLG1rZAYdGoi0sHgiL8L2hTIQPYIGiUAkp1OiF7zdoS0OWTYEvl9rS7CaeTnO5KwKpgzM6ZzhXoO7uHJOAoXLmDYV5jUVHqnZEhA1e37ysHwtBkbcAAg2UIe18bjhM7tujy+yr9Zzq1ucHCKCxseXtKbyEcE97ZOJFiZOiRxD5phIT1STG9rUbMP0bpSdZNcpma
 JohobMUV
 pQKew5etQhHoR+Jr4coRFnWh6yUEQBzXMZcIIR7uPt9LtlmEgzjbyh3Yz9kzPceDZW8teKeh9izfsh2sYrAI3C7m9zfIc8H9FIFNfyzQydUjohbkwoU+419LWPXJ/AgJzfwtShZiM32E9zvGGAKe4TDOMI6TMAhIBmLlUcaMKVyH5unM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't split and descend on special PMD/PUDs, which are generally
device-backed huge pfnmaps as used by vfio for BAR mapping. These
can be faulted back in after splitting and before descending, which
can race to an illegal read.

Signed-off-by: Max Boone <mboone@akamai.com>
Signed-off-by: Max Tottenham <mtottenh@akamai.com>

---
 mm/pagewalk.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab..d1460dd84 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -147,10 +147,18 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		if (walk->vma)
+		if (walk->vma) {
+			/*
+			 * Don't descend into device-backed pfnmaps,
+			 * they might refault the PMD entry.
+			 */
+			if (unlikely(pmd_special(*pmd)))
+				continue;
+
 			split_huge_pmd(walk->vma, pmd, addr);
-		else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
+		} else if (pmd_leaf(*pmd) || !pmd_present(*pmd)) {
 			continue; /* Nothing to do. */
+		}
 
 		err = walk_pte_range(pmd, addr, next, walk);
 		if (err)
@@ -213,10 +221,18 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		if (walk->vma)
+		if (walk->vma) {
+			/*
+			 * Don't descend into device-backed pfnmaps,
+			 * they might refault the PUD entry.
+			 */
+			if (unlikely(pud_special(*pud)))
+				continue;
+
 			split_huge_pud(walk->vma, pud, addr);
-		else if (pud_leaf(*pud) || !pud_present(*pud))
+		} else if (pud_leaf(*pud) || !pud_present(*pud)) {
 			continue; /* Nothing to do. */
+		}
 
 		if (pud_none(*pud))
 			goto again;
-- 
2.34.1


