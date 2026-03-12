Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDC2105A596
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2916B00AD; Thu, 12 Mar 2026 08:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21A46B00AF; Thu, 12 Mar 2026 08:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85316B00B0; Thu, 12 Mar 2026 08:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA44A6B00AD
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 801695701D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:45 +0000 (UTC)
X-FDA: 84537334770.20.373A67A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 21B732000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fYPClEaA;
	spf=pass (imf13.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP5DnIGqX+IWoGTaswpG4DKOIk5RWcGIq4sPAjVal+4=;
	b=2Ia2PAGAEjH8K02tpabl5js1E+z9IXDQPwBxaUywnTWSndORLXJ3Z9eDkYVTjghejeeMg5
	3uTpaW6Dz4Sr+W0FH43htd/cpp0Y3abj5anXHOJLXbfeIQDd7ohPx9rnlagBnOtvstdpFV
	ZBdJBEFCxCKn/+dQJZ98NENh5xkq+64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318403; a=rsa-sha256;
	cv=none;
	b=dn4LPr7qcNuD+WpVXGFkTrq9Avt7D/Z/rJNOT0CuQ88PXSX+04VaMy7aPPYTkd/kfqGc6/
	k7xW4ejejPWhxmf58ROxl6mzr1OjLQAgeQP9tmKkymclOQgs6Q0MHAqP6N9JJLIEaBvkNI
	m5hF9BpsKIybqy3oCSmbNGWLaCcWhJ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fYPClEaA;
	spf=pass (imf13.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMW4mA2205603;
	Thu, 12 Mar 2026 12:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cP5DnIGqX+IWoGTas
	wpG4DKOIk5RWcGIq4sPAjVal+4=; b=fYPClEaAW4o2h6rfEXazjLNd86rTc5AX2
	aC1dJdL0MuhctKpu87NoPvN3kOW3BKvhGkCbMhqdbLoLEColKwey8VawvbWIe2lq
	0Tfiy49BBPodhAprbps/C7EbNGbKhCri/01UfZUvyg0tNYDr12YXNrJp6Sof0NWe
	cbEJXlVI1cnmVjHNA5ejEzMC81BjqdBcz6BphPdk8YMh5kTmn79hJO5t8pvR4qg/
	9Yxp8IUewd50vsF/7vX6v+YGxnOrcmWgb5dCUEqwFogb4P4xvZIsq4kEjW/zJOmC
	PXbxQedPL4hU18MVbx9X8uJn0+pwjnzqLY6GplBoJ2B4NwJ7+WxdQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh98ag6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9WLLa025750;
	Thu, 12 Mar 2026 12:26:37 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha8a92p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:37 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQZ1032309628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BC3D2004F;
	Thu, 12 Mar 2026 12:26:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4644820043;
	Thu, 12 Mar 2026 12:26:32 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:32 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v2 10/13] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Thu, 12 Mar 2026 17:55:37 +0530
Message-ID: <2516cad1d9dcbe613619a1006aed1991302c9bee.1773305678.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=M+pA6iws c=1 sm=1 tr=0 ts=69b2b0fe cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=007535ZYCZBjDdtOErIA:9
X-Proofpoint-GUID: EODHtCal7aKmrKKS_qj29Bs5gVqcXyH7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfX4hf0OjoomiiW
 A1eCfyOP+cepbPP01EOz8bRny0BaRaXlFez13ztLBJi8q0I2pxMliNygXfxUqRe6aFzDVd9X1Ux
 NQOJK8oI+oYDH6GWpVAHSLarzKraiYmNPm298T7KmWldQGHgf/PloCXbbyo+AfjNyFzDPm1k6MO
 DQC5qCzC6wOa/w7DY0L+WDXe3rg2//z6bEuGfyC/D9xotBjar2LzZiXK0gRdJtYaZCJcXKhsIKR
 PNOSiLy7pmhkCdbD7w1H7YRhoi05q6PlPUjCqqVyOtocc3fjiIaaBDeGHUlyKoZFzmKotxKPAYa
 eBhN9vWoO/a8QeL8lvZ5RULmIiDHVZC6wnxBrem2rSBaOZdaFjGxIkLdzS+17J5o1UrdjL57G+s
 OY9xk1s/gGT4H4CK2Mm26VtYhZNmdChqBCztdUUvoIyYZHOq1BBVhnYzE1t5SXerS7NirouUAvu
 rgEVTbVRixrXCctZ9oQ==
X-Proofpoint-ORIG-GUID: 1txIhhYvwZehc3zeAahpyWjBUMEm9eRN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603120095
X-Rspam-User: 
X-Stat-Signature: 17hrebd8d5p1s815yo1simcxjwytiqbe
X-Rspamd-Queue-Id: 21B732000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773318402-521275
X-HE-Meta: U2FsdGVkX1+Y7eJ9l7TK1zkZNkrUuF+Af9vUJTKKAVJKh02ggHG48XVTNnplK1ijw6zvLLizZJ+9DDe34H2n/2drJUNLldHZPzc8t0/ZAgtFhy5hNxNTzHwjvqYfXuZ/YTkMHrPFcXToHto+G3HKczhteGUHILtK8EQ5+UtueH6XqomJGCMIsGJMPaAhYAxp+GQ2u0D7es4Gb656Zqqjk9XK23m1rbBod/Ejm6mTlNij48NhifnSww+xFGBLlk5kas0uIgAYhYsY3Wn5aAyZTi3k/c1ptpsi4Y2sfvBFjUhQssOR2J7WTgPwxmuwiojkiTZg2D75kx6shsAWv0GETcPLqEhcxQh4FbSOD3bs+qqKV1zx4GaFlF8Nwt/ORsdoLc96Jkh03KeWYYoVtudZ003QHramrEtJyocIU1QGX5TYYfQC1zALMpPotdaMQwAVsE3K8SubiMRVr1fW1LS2DSPbYYjoa0vBgpUYRSrw1bfe0Nv4HFsk5qHLady/UJvn4dE+MaBlSsQW51xUxEFqGol9xPWh3VqOpeFoKEGLDPazoEPvly20f6swX9qNJ5WKBsmMFoFXpys8PMtjoVJhmLqZ94/kqj10fJuu9Mw0Lsdyz2iYK5ysnbntRc3qiB2yG2akrO3AZ75mvRMOQIS2HpnVN1X9sUu9afWCIrWGoU60Ocu5XnIl0H/zg1DHfacSuteM0+QzV0lH5/RJqZrtL2L5QOkJPZ3RATFM43mTy4d1vzcvkpOxaNgmQo+bIq817BW2Ahu9zf3oBfncn2nohtylsegmx4lmii2/N130i3tC8PGJOta5JdsIST2rzFD2qJNpdmQBeXDXoQnDB0w4HlnuW3idwT0iqWKv7IraMmvD99dO8VObL1QgGT7sB/Gf0RNZ/Ci7t05G8K1VdVEUt4hwF+JI9D67REtMKq3GwSYTiMTwmy7V/tI13Gni4on+CG98HMTzQ1xzh2S0YHn
 FX++M1tp
 /c9LHUT+B3ymdD2Q1FCy4P1S3rejLTIvwkm4d5nFYjHkHJr/sc2Q/YpIbQ2uPQZgu1VWRQgv8opxu0Kh6/j2U/ogGyCF0zQa7gW4NrGeC4WJJBusM2ByTE4fz9BuQPfoz5B4LoaKBBCR/ZkbvSheod2dg3JGBrTVFe/c+jNdCPaZqjXWrfjD4UbXb5GqFkAEWaWS+6aWgqznJvsMnSdUsYpQAXYD4CWoSrCDlXJnv2wdvLR9lxbl9v3hoEJscqvwCe2yGCbj3mo9n4EUblCoosgOoURWvN1wSqEX1yEUSmNW+UADGzASSQzgTneje6qWH3IpM2U+ZazfKyorQRCtXTUbDQmWX5zw1rywI96rzPo4y0CPCfX4rg0Nh0ez6K3MvvOgOy1xe0BDSGvuB+NlDrRuUkm/sD1mgA1hVYkYHoJ8Gayug3X3ixCV8xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-stress currently fails when the computed nr_pages_per_cpu
evaluates to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g. 1GB) and a
high number of CPUs, where the total allocated memory is sufficient
overall but not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources
rather than incorrect kernel behaviour. Update the test
to treat this condition as a test skip instead of reporting an error.

Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/uffd-stress.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 700fbaa18d44..b8f22ea859a6 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -491,9 +491,9 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_print_msg("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
+		return KSFT_SKIP;
 	}
 
 	bounces = atoi(argv[3]);
-- 
2.52.0


