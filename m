Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4ECCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 13:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1168C6B0005; Thu,  4 Jun 2026 09:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7716B0088; Thu,  4 Jun 2026 09:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8B36B008A; Thu,  4 Jun 2026 09:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA57C6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:43:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B8741A072C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:43:05 +0000 (UTC)
X-FDA: 84842346330.21.6F1283C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf31.hostedemail.com (Postfix) with ESMTP id 894E520014
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:42:55 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780580575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YQzLfI7cqcuvs6IyIPvW2YW8ka+WX6auHJcS9qJj5k8=;
	b=XW9XBqzgqvG184z7gXH7S+LAUaSPYgE2CkPJNqpdaPJaUQMv0sdpy65hGAIrkmzKhmrFbK
	vG34r1TS+gIWTJLiM3zsL0t8CAPM7BWtgT0VmgsxSPVSfT9rfv7W5kcNFoU5VbHlz6ZRU4
	bzH1yAFtujNUj3tP7/UGJpxLPHDlDBI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WUYxK7i1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf31.hostedemail.com: domain of imran.f.khan@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=imran.f.khan@oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780580575;
	b=D80ssclx9EQh85VBmIUw+ZBq/pjh1JjbWeEY0BRNuTh7/fMnowJdAfbTGtrrfDr2oN/2H2
	Syb304zg4wz8SqtOTPPNY+IiKS2gKF996ojMLENo+B77TfE88/ybLwiBsbq5u7RW++OovQ
	4RAUSaxpdjfpFpsbRwof6njO/oqC/sk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6548npAP1821678;
	Thu, 4 Jun 2026 13:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=YQzLfI7cqcuvs6IyIPvW2YW8ka+WX
	6auHJcS9qJj5k8=; b=WUYxK7i1TuEoO5KVcLNHx/fAPh7EeqPQn8lvJCMScWvt0
	2pb/Tt2lUj1/dwVEWsvL+IgddDSF0ITwqmuH/sXC5oYS9ipplUNxoziZ3ORoaZjk
	tOfTNGKrXJxP1EnbJUCLF6P5ktwxtT8ZbgQKc6L0R8gvzkFVihlK70a4B6W6/TfS
	jSh36CvsJRs7diFGPJeBfdDt46XUC9U/L/Mbk+eOhI6m0ObF2/fH/Kthlpw0MHa8
	GdXJOWxhhXjEzPAUfM3epqoretKGCMixOwYUIxrU2vKhwabJSPKmhy1nTlSbhx7M
	zzvn33tk4aOliorKijrsXSRY+/I6D1anT4ll7tMBg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqgs078u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jun 2026 13:42:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 654DdjP0001204;
	Thu, 4 Jun 2026 13:42:40 GMT
Received: from imran-metabox.au.oracle.com (dhcp-10-191-115-51.vpn.oracle.com [10.191.115.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4efpbfwatb-1;
	Thu, 04 Jun 2026 13:42:40 +0000 (GMT)
From: Imran Khan <imran.f.khan@oracle.com>
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmstat: avoid taking zone lock in /proc/buddyinfo reads
Date: Thu,  4 Jun 2026 21:42:45 +0800
Message-Id: <20260604134245.1580287-1-imran.f.khan@oracle.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-04_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606040133
X-Authority-Analysis: v=2.4 cv=NLnlPU6g c=1 sm=1 tr=0 ts=6a2180d1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=YhumCNMSV65wbhEYhDcA:9
X-Proofpoint-GUID: pAa5fQDIeDXB7xp4SIyCmHOP4A8V3zu5
X-Proofpoint-ORIG-GUID: pAa5fQDIeDXB7xp4SIyCmHOP4A8V3zu5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA0MDEzMyBTYWx0ZWRfX1XST2npXnF+U
 BveeUULTvCursnK7A7KCROvMx+IB7k+d8KFAj2C1it3tgi8bYH/anK9DeV7lb3f0tZAciBRTBgQ
 ULNYn4HtRt/M9/6qcFJJ3s4RKwciIKYUXjOMyjtF9YNpKufba3K3X42uDSaD/D9KU//tovh/voM
 JzPKl7h4Ie0Ru+yszy/JmzpTO5k0k4PTHO5HQlH4DifMuVGaDKvk6mhSxVuQ71a8c2EGg6bL0L2
 hYLtqwPzeSBQOvqH7aRrMkQzIz0Dt2ybUOdmXKfDNJEusCao3/wKqOQAj5ZqBCO1wJtNiwNN+e/
 C4UiItG3VJXX9IzimQF6CWHgqMWmoIK9PMY3OjPWyT4mf3Wac1VhgYyop8Hl24UOChLAxmt82Da
 5JrRY9LXhsb/lmdS7oIucl9O5/K8xMNjU/dbW67Wf5VjzaOGr9EZCu4OqElZrkTg+joNgs3l5eP
 fveCgnnU2TMOZ5U6wCQ==
X-HE-Tag: 1780580575-732094
X-HE-Meta: U2FsdGVkX1/R4eEoe9LAZ9EyNow0GdtdnIWH4FIPh0wULklpYMyCa7Lby0BNTsGAaNKmGx1Hfa80rTYTCB9UKlJ3VsMUP357gpJko64Sj+lbEY35cgRbLkNNh2FzTyjNVbGiG9ct3cYGUfDLGGzZHpnqsB/a868Tq9ZCXGvlSLeIoIu2gdEe2KXlw09PIRRX4m/+oPtAvqPO7EejB650B1+8ttE+qDO//6QSfk5Zb7wYc0FB1zA17GH1ik4HjZLCPfi9cGejRnS/kTCS2ClcLPeWv9fICpTbc8Bs317Zm9QTDJOXtk8YiZLUAXf97ekds6TU+9VY9g1dNN8Icp30THJlpBZFze/zo3jjS042eU/ZzKHJXiEaOYZkrw0XrLxT7b7MSn7lV98hVXrOGrRceE6F8Z2Yk+Hb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

frag_show_print() just reads zone->free_area[order].nr_free, so
it can safely do this without needing the zone->lock.

Pass nolock=true from frag_show(), so that walk_zones_in_node()
can skip the zone->lock acquisition.

Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
---
 mm/vmstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517de..7b93fbf9af092 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1568,7 +1568,7 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 static int frag_show(struct seq_file *m, void *arg)
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
-	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
+	walk_zones_in_node(m, pgdat, true, true, frag_show_print);
 	return 0;
 }
 

base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
-- 
2.34.1


