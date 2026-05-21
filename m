Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2914ECD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833536B008A; Thu, 21 May 2026 02:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D436B00A1; Thu, 21 May 2026 02:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685906B00A3; Thu, 21 May 2026 02:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50A026B00A1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C6318DDA1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:47 +0000 (UTC)
X-FDA: 84790499094.05.E867A20
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id CFAB040005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Mlxj7w+d;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQF9FZs2eg1Enek9qTboZeMmaUyOa6cHAXzM+prlfBI=;
	b=AWZvE4y2MbVYFk1RAoYif5G6qyzqDpx9HLBEG6ajpkCiVo5z93XFCiK7mKQuV5fFzVWAuP
	gVa3prGOqDmSM33GPh09e3NZdVOl1NvdO33nUv70G69LjN6FG9TukQx3a5DGiPwZQbXPXe
	+k8ScF2HenErhnnpuOITMI0mcy6IT8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346124; a=rsa-sha256;
	cv=none;
	b=wD0uXY98ntYrVcK6jjTybrgKxQouFsol3rM7V/iUmDLKoXw2vwYeJvXRdFNS3ROB8kVc4m
	ZU58wBm9JBTUvUbXXSg0X9rUU54SCDylFMfrVBebRq1X7cEKAx9pFfE6slfcEyaqm+iErw
	gaNMBI3qgwf2XWnYsUMImGHNClhVMnc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Mlxj7w+d;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KL6B651853987;
	Thu, 21 May 2026 06:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FQF9FZs2eg1Enek9q
	TboZeMmaUyOa6cHAXzM+prlfBI=; b=Mlxj7w+dI6BPwWKLt9DobguPgTezmwtgq
	6IYVol4dfvkvBY/EnYfZVcQnZoCpyJJh+WF373/4/gMEqetOPEpiHc5hp8OUhoi7
	CvwqhzfF8v5d81LD2RR1ExLLR38RZ7OaCQ6RiSEaywenuJ51ydA/+2cK97oK+cVh
	jrNs0RiSnxshveuwYP0ZuYMu9XBIy021BB/rKUGR284frDtaxHE+aM5C8KCJ6xw7
	88BmtBqHxXTR1ZEwVbxe6Y7d7QIAHuvpwQmlQVEcYhLjLQiyg8towhyWQVPBH4mh
	mRQJc98aorhoOtuKIhRPkTNQ/JdrhasJww06oou8PYafrcBo5Fwug==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8mbp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:33 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6dIbu018383;
	Thu, 21 May 2026 06:48:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75kyajev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6mSAK24248782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC0E420043;
	Thu, 21 May 2026 06:48:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D64520040;
	Thu, 21 May 2026 06:48:25 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:48:25 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v7 11/13] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Thu, 21 May 2026 12:17:51 +0530
Message-ID: <0707e9a0f1b3dd904c4a069b91db317f9c160faa.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfX5T9MuEj6il3V
 UJOg1gPjYjwcVi+pLoVBKsSGrOjMDf2eR0Ci18QiQ0WDrYrrN1MYpNRfvffO502mEKxKRhj8MEB
 W1H7oKAVeW+X83PL+8oIcFDLRguerUwu/uSVHEsQEyURYsj+q3jv8oFRU2vgqxTDGbbOIAAMwLu
 Gg0MfFUeeufQ150M36iL4soXznGKJIuVLlTBzJiPmU7v/1KCoCCllgtqTRADt+Qr0blKBT7OO7F
 mcf47vY7cTeyYheZ6yj7Z9XDvliIrZ7hZJAt5JscB6RDeB7sCnnrcj38qFrs6LSC92re1R2lRiJ
 mrgYdqMnQI/qOYJa5Jnnufj85WZW3hKMS21PJw22zrayE2n44trERaKpqbJzS9HDt+WnkDwQnSY
 ZIvM67sU8/Tg0M+XCJtClwKckQ1AX0q78YL72RiIdhwNFnQKI5XaHT7EJMVo0R6z9DY69N8IP5M
 Pt3rLFxcdU5lOtAuUjQ==
X-Proofpoint-GUID: Z1xE03N4YSu0Q5Q9srAd_BPqDsz20iYe
X-Proofpoint-ORIG-GUID: 9jLyuVdzYQWkAs55cBOCg5EFOmwt-_YL
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0eaac1 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=QLFraA1qSxkZgXf6QZAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210062
X-Rspam-User: 
X-Rspamd-Queue-Id: CFAB040005
X-Rspamd-Server: rspam04
X-Stat-Signature: jy648oriitqhyx5kdq9ajpgf9a5s3sd5
X-HE-Tag: 1779346124-819342
X-HE-Meta: U2FsdGVkX19Mt+ZarKd3tBDn501F+dTQsIlKxB1voU3alb+NePD73NBKU0yBtnAskeg9FDmWa0XoTgMcSsqhf1tC9AytuIeH3dI129+k7SQlE1b4t1qlsDOKzq1DRtUyxNWqNFIVI8vkPKqWv0asmWd56YQAcYAMG+spCuty/1apFiFJ5P7oJfBIwmqdlUQautxyigNCwAN75LA+I5lVtT2W8zkG6W1lOzfwiRBdyDkJz7puNX7HL+P/SjpA7LKpYgghia3rfsYONIB+udSoajL0mmFNpl2K87InCjMvjZ4Tewtl9575myY2xTcwvlxOqJOfeiCmpttwcYm9KT1FkXUjiimXBjr+5ls7ZsDhnAqGATLaHsvoDvfE8PfCQ1WwfNfK41CoqC2d3wRbRgj4ObgvtUokr7dSSXHbLMKCcCf+kVqTSsmSBrEmtA17K3/aEOhKq8JwC+Et0iOGyCSLM6EkT/r/Xr7r2Cd7ACc8pJ4VYmTASTc1svIQfJ9eR1/Z0Qqg9xG7LAJUA/YORu0vc3pRLCr0oB4DcMldeKq38tG2xPUlmMR49u4rUfx9pHhHATHNeoTlucpn7XJ+WtqQ1BXV1/ru69ayn7pIYA+nANpctsgTi/KWKgqVr6VHHQPNeN1hWXoLIDOg+RPDgBxgpYXDStxBKUC972Rg7ZRJwrI0ghxlIB0CRzJXtlM0Ux6iYR+8tkL5Fd7k/z60Ozk3Lb0dj2lJCx7Ti0c7W/QLNUMS3B1xUSOq9Y2ZT1Quiz6wCHDwdEOCa4SYkbhzfXnfCgyKUUlLgYLUy2bC3Tg9wBl7OUyAuJDtWx/B6ZD9VfV7HSE1DaObFzf0HAOctyK6hQo6K7zowKwFz5J59GFtZG3fOCgkYHvYDcqjk0D2dFJOZIsbQVvJsBHV6wRqrbgzKwL2AliVzjpZL+8M61Gcbf/SD9M1wmrQQLkGvv8eBRnmpX1H828Ay8MQWO+QQPF
 lV6UJ/2n
 B6D5flIfIhB21Z4M1DsyGFAEVbL4M/CtVK3UnjfjbuL5jMSOWE19jqM+zsuC4H9qrxEmbf19HWCSUlvtEoq7QwEtFtb1QmKhIAasknAF/Ls0qA/HWNqQcLEQ1/2YRHFu4yrSY6+t7kwksY3sM6l9m80MQE/1gQkJDA7s1Pha8baEJ9veC/L8AcgriR6jl+VSXN9EmUXQ2wwkjaMETvtemOB8GSJ8yb3bwK5DWdjy1SsOOOMtqjUzKo3MqBxUAvNKCfBKwLZVGIs+9FlYgwmiklui4Tc8tKvWesoDxYx+3MB3B//d/3CBkMia9x9KfwIHleYRFNjkdsg/K1MwTT7TpCsV+iCTwcPduOtFBlrOZof6wWyFi+yvJZj/wUW9cK0U0tr2WYsCHjEn+m9NS62hNlVpVFK6nYDVsFHWFvvRs8heD/4Rs+e9l3kXnYEGFcKH1F497eXoo036KGMc=
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/uffd-stress.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 43cc79590136..39e13e2078a9 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -489,9 +489,9 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_print_msg("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
+		return KSFT_SKIP;
 	}
 
 	bounces = atoi(argv[3]);
-- 
2.52.0


