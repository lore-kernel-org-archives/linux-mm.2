Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46EB606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=FH9l+0PC
Received: by kanga.kvack.org (Postfix)
	id DAF146B05B5; Fri,  6 Nov 2026 05:43:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88216B05B7; Fri,  6 Nov 2026 05:43:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76736B05B8; Fri,  6 Nov 2026 05:43:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 980296B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:43:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1044D140CC5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:43:19 +0000 (UTC)
X-FDA: 85404357318.05.FC0332B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id E7764C0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:43:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FH9l+0PC;
	spf=pass (imf22.hostedemail.com: domain of zaslonko@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=zaslonko@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793961797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hsjGKsAeD8QaxYplDPt0EpldWweYT+Xkhb2l+NcQA2k=;
	b=WPIyUTXSA1doJjX6CFMjT8QiJ0kcE50+h6EkiwQT8PTKi3e3vKU6tfax244oAGvmcV/qsQ
	K1EiGbznTibe5QVhA2bTQocfIvunLuv0hem2ZktwH/luFkVa55kKEGdkJl0geW1vhxLick
	CAWmGuEOI8hx/JvdzaozKJw5XeDeaBY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793961797;
	b=1hVAOOYrQjvgMHGOlbHFIQ3AFiR7dVzPlR1D1lfPaR/XMbPtW8V6hXGOhlyCsshrIUNyEc
	WL4heB8PZ+iSANDbJULnvgFxAPR/t50QpdVc1oR5SOy1b62BUXiQZNt3Acau6FRkC+7GX9
	CSY0vP93YmyI2u53d2NLBXr1nuMi8E8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FH9l+0PC;
	spf=pass (imf22.hostedemail.com: domain of zaslonko@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=zaslonko@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67i72r1759530;
	Fri, 6 Nov 2026 10:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=hsjGKsAeD8QaxYplDPt0EpldWweYT+Xkhb2l+NcQA
	2k=; b=FH9l+0PCV+uL1gCx7gxdqtoa3VUvUUqiYG7FljwN1nKMk+/z16tla3Ufw
	OzUTVBDDCtVyvMnpDhh+5mW7ulDwZtS578x4dAIQGfazQoLunLhAYDs2I88v6CLN
	TjiKjfVut6GFgyOXyjTOoEIcCwxs035eKYKOmWwI1uWCgCRST2WYZy3aFcsQEaPh
	sQH+KcqPArxoxZhQzqrphQxBvVsMSoDh0gLuxHKZRVPzQbYLOV0yYm4w/jvNV2C6
	kSO3t+6INSTJUVB92U11Yu7KrRUh0pkHQI+uULDHbyG0WHN2wvqamDKV/m0rCWCT
	zKQR+AWAKYad6GPvXtaGI1H8wTIRw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hs3r9br7y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 10:43:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6AYx0i3268955;
	Fri, 6 Nov 2026 10:43:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hrka70m0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 10:43:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A6Ah9RQ17498386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Nov 2026 10:43:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B511820043;
	Fri,  6 Nov 2026 10:43:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72F1520040;
	Fri,  6 Nov 2026 10:43:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Nov 2026 10:43:09 +0000 (GMT)
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Pratyush Yadav <pratyush@kernel.org>,
        Dave Young <ruirui.yang@linux.dev>, Jiri Bohac <jbohac@suse.cz>,
        David Hildenbrand <david@kernel.org>,
        Usama Arif <usama.arif@linux.dev>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, kexec@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kdump: Give crashkernel CMA areas unique names
Date: Fri,  6 Nov 2026 11:43:09 +0100
Message-ID: <20261106104309.3669583-1-zaslonko@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=LKHz05W9 c=1 sm=1 tr=0 ts=6aedaf42 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=hR5eV2nCcz1Zz8vUuPwA:9
X-Proofpoint-GUID: CVJwi85HMVi4di98wVuO7BMLHM0mh7Rm
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA0MCBTYWx0ZWRfX46OaJdwxmACt
 eJ0su/177/KowBAIMk7OoWdwirMtqYrcLXeRoqSw7RAD5eyoCk8yh/wwbBr77pE5rpQXZSvawB7
 892uXMCU08MJVU79OyYVCtYtwag7kBg=
X-Proofpoint-ORIG-GUID: CVJwi85HMVi4di98wVuO7BMLHM0mh7Rm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA0MCBTYWx0ZWRfX80Zh2xVqO8L8
 D+Reh8yqrxwfG5pOc3L0Bwk2oYeYPnyyDec3iAiVYVSh6jG25dMlrtybpM8rLpHWeA/h1W2u6Ow
 BjdrIvJ7F/XJZcAt+Y+FNaDBZW2qjeMTdxChMZlDzx4Pd4NCsffzHeKP8Y73+u4GvO69bG8Lbv5
 GhwygeZQRGGRkUkGmCiLHw9hdXRJpR1qfXCukeE06hKF3z0zZtNSKfNF6ZE8WL7aI5ksJwJbxEr
 myQmewboZPFPGjPQrBWY+xAZPOaCqd2aS5mO7+8mGZILcE9DCiCvDtPWWoesvlvJE28pdk44MT6
 vj1QVwMC7RszoQyZ8MPc20F1fambmUPHdyv95efjGMO5BLV2Wcp7ZIdMtKCB1kaeTObHpAT5VeJ
 cbiYiApP49Z3WGbzDMVY8EwXTF7ouxQVRNBWDqBasMRaVtj//rISaUX5Ld/TaYECQbZz1D67RjK
 /nMwsxAnCLxXwOUk59g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060040
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E7764C0003
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c3erbrkyyjwmeimat6bqxoqzyq6f13w5
X-Rspam-User: 
X-HE-Tag: 1793961796-996295
X-HE-Meta: U2FsdGVkX1+wUdtgw7533MGGOS6Ppm/07zMX6s6+I+B8+I3zJR9N272223hpf7FF8+JqQ4yAre+fqA07HCIzMMIxLOLdL5eore4Umf9NZoCb/4Vl93HWNjFSaAWIvKf2fmIEXWDJzOIyKx/ocZrHBIplivzvXIcRMihaeIYaeehvPdkXPH12wdy8s/1Mz09bfRE+jqOas+NXdBdeSNpeJmkyhquzZw9MzXT+juCSjs3qg8RTH8Vt7Eku6ITdq+WvIOQtie6NTJWjUDoDjAysaNsbRhvId8Kn6/W/0VG+MPECeY7+YuehfCA5cclIi4Fh28spVgiaP2EnelnegIvAOGvY5OrjgIPjlyfS93CMbhXiVxbkwMThYhTt2L6P6l2F7SLo+NdweumyiXXuFS1EguANpnm+XUkb7D1Co5qj2CHPhgTp36MYDpocUrnUawKv7tvsVMi2DuU4LJh+Xoes9recaTfNr9Jn7V2rB0E2fML8BbUoAT5360/KcZX7Y+NZpjaQlRMwSe85/ar7vi/vwb1u/SHFB7c8jvpxjVcKy/gyyAFL43EwZvxim6/aefDDZTSV7iRdnLB88wYRUSY97zN9Lu4pLr/0R4ilFqr8dKFUk0lMKYjtrla9nW1UULTOagoj1gTfXmAsIJOVx7s6jFIKaFnCbjs/RCZCclQhb2cBOaZtIgZ4En1uf6bax7lGSQvxDrjQqIFNzvAXjgaCIAmVXMh7qVvhP17lYt0/O4iUlWDS3RZc6E5YTg4kHg/zG5DPh802uS6ZMjmWzAjFx4w2wMoL9cXa1uCqCfviRUljiYaO8FzeQs+6/D08bqJEp1vZIyJfJIuIJQTpMgpGsNKJW0EGOT0kCA8BRFhOnXkRDiCZ0I4zPb4nAjKdfqFch4wP+PWNmWuig4Nxk7+Dn0Yyg8D8++N9R/xe/uSuw9auhgeyqneMOLGzMXM32CiSAl3pXhqF9G9FnaeFd3u
 CaW4CZhI
 cLCpfNo8qS3xPwz1z2AREsGMIBOEXsZoJRB6ULAddJPH1LY37IIvH38yQYFQDKQsAtIC+VTyjmaoGfSZoi0D/p1fmCkpfUyl8ZSz5gPKrq5gIzX7jp2JXkSIce1O6D2AL4rU8VjfWY08LtK1KLkyeQbSDdkatXaV1WPOJE9Dowmmd3TJOgXGZbqZHkKC4+Hiy9hh5SimlwIeDx9zr5aZgwhZEu30JN9BwvDkYoxFLXy6e4+PiaRP45ivh8QZS6zEzVheu5DoClYEZhBFwncDj8Y5fhmLtm9OAyTXkRfwBLueEX+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

reserve_crashkernel_cma() names every CMA area it reserves
"crashkernel". If the requested size can't be reserved in one piece,
it falls back to several smaller areas, all with the same name.
With CONFIG_CMA_SYSFS, cma_sysfs_init() then fails to create the second
directory:

  sysfs: cannot create duplicate filename '/kernel/mm/cma/crashkernel'

and the error path removes the sysfs entries of all CMA areas.

With CONFIG_CMA_DEBUGFS, debugfs refuses the duplicate directories as
well:

  debugfs: 'crashkernel' already exists in 'cma'

so only the first area shows up in debugfs.

Keep the name of the first area and add the index to the others:
crashkernel, crashkernel1, crashkernel2, ...

Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
---
Found while adding crashkernel CMA support for s390.

 kernel/crash_reserve.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/crash_reserve.c b/kernel/crash_reserve.c
index eee37a11380c..e58318b1e092 100644
--- a/kernel/crash_reserve.c
+++ b/kernel/crash_reserve.c
@@ -483,10 +483,16 @@ void __init reserve_crashkernel_cma(unsigned long long cma_size)
 	while (cma_size > reserved_size &&
 	       crashk_cma_cnt < CRASHKERNEL_CMA_RANGES_MAX) {
 
+		char name[CMA_MAX_NAME];
 		struct cma *res;
 
+		/* CMA area names show up in sysfs and debugfs, keep them unique */
+		if (crashk_cma_cnt)
+			snprintf(name, sizeof(name), "crashkernel%d", crashk_cma_cnt);
+		else
+			strscpy(name, "crashkernel");
 		if (cma_declare_contiguous(0, request_size, 0, 0, 0, false,
-				       "crashkernel", &res)) {
+				       name, &res)) {
 			/* reservation failed, try half-sized blocks */
 			if (request_size <= PAGE_SIZE)
 				break;

base-commit: f66469d9905b39d2c260a15d7d6db450f4db67c1
-- 
2.55.0


