Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89098CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5626B0277; Mon,  1 Jun 2026 02:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E965E6B0279; Mon,  1 Jun 2026 02:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86496B027A; Mon,  1 Jun 2026 02:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6C2D6B0277
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:13:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C8211405C3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:13:43 +0000 (UTC)
X-FDA: 84830327526.23.D9A6368
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id D4A3016000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:13:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sOVjxsXZ;
	spf=pass (imf08.hostedemail.com: domain of pavrampu@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=pavrampu@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780294420; a=rsa-sha256;
	cv=none;
	b=8PYe0jti3+T47kv8Y6x5SPtIiLrY6lHY/g1ikvMk+6hVJ2tbd1teZUFT0Iujm5e+kZ7wCE
	vnmE/fztfFiwx0ZdVhkwiRKp5nUI6WzkS7d0RsLxNN20Ik1zLWT9Sl7HhnrAC10eDnADtA
	e8OL8RvPlujbnJHZvJP/3Wy2y3zF+Wo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sOVjxsXZ;
	spf=pass (imf08.hostedemail.com: domain of pavrampu@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=pavrampu@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780294420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LEuzo96EvcBe1L0RHV2X4G4DgTPw2E1t0irsEQ+uWos=;
	b=MP3/6Tp1GWQOCSCHeubPHb3vaWX/EPRuEfT8KUZxAE0YLeGEGFC0Jc3LP9UqEdIGHwRDf8
	VJ5bHRuCPUv9XzkGrhYIt8EI5X8NtQaPQLmVNR//CrB0/twbtcGIiEu9itvuQArvF8H467
	KYhuFTGT0bSw+BdV5Cxzq5eUW8fFli0=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VBj1LM3166613;
	Mon, 1 Jun 2026 06:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=LEuzo96EvcBe1L0RHV2X4G4DgTPw2E1t0irsEQ+uW
	os=; b=sOVjxsXZuocv+p4kc4pW6WMbIZHxFdwQJR2UfAD1dg87iyOoF/fB7V/8e
	VnC1DshEeAb+bzbxSWexG4dr980AbpoB+PV2x+jR8t8q6EILEw9kng9g6gybOCUe
	p3HIpxTKfC1V478FwqF48TyNGsC5Fo2/roBk24iuI6NpnJO7c3Xp9UKeo8vHHOlu
	xEotAfc2Vu4hDflK7BQMXfWK+nGnK398ibanwxDU28F0IW/u8STcIAaOUK5NEuPU
	AivwG1Jg+DfNRTGGvoQJ4jtAl3YJH6PCAd5HoHI35hh0mRW2/sk4GGa9Jcbv0udv
	7xTcmlWc1U6IpyGsWVGnzf792veAA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efpady01u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 06:13:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 651698ov029749;
	Mon, 1 Jun 2026 06:13:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4egcwy4cnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 06:13:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6516DOGW55574824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jun 2026 06:13:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7040720043;
	Mon,  1 Jun 2026 06:13:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AE1D20040;
	Mon,  1 Jun 2026 06:13:18 +0000 (GMT)
Received: from li-49acbccc-2994-11b2-a85c-d51b89e344f1.ibm.com.com (unknown [9.39.21.19])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Jun 2026 06:13:18 +0000 (GMT)
From: Pavithra <pavrampu@linux.ibm.com>
To: shuah@kernel.org, akpm@linux-foundation.org
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        pavrampu@linux.ibm.com, ritesh.list@gmail.com, david@kernel.org,
        ziy@nvidia.com, mhocko@kernel.org, osalvador@suse.de,
        lorenzo.stoakes@oracle.com, dev.jain@arm.com, Liam.Howlett@oracle.com,
        linmiaohe@huawei.com
Subject: [PATCH] selftests/mm/run_vmtests.sh: Fix protection_keys binary name in run_vmtests.sh
Date: Mon,  1 Jun 2026 11:43:14 +0530
Message-ID: <20260601061314.898388-1-pavrampu@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Zt3d7d7G c=1 sm=1 tr=0 ts=6a1d2307 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=lXLsEBLhcoI0ZpkwZQYA:9
X-Proofpoint-GUID: OJlNuBd6hlFxsohbUEUIL_9AtncMoPCx
X-Proofpoint-ORIG-GUID: IXp5ZTHGnG6UIm2hLhoaz_lg1eQqAP9u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDA1OSBTYWx0ZWRfX9Ds9qcgBDGWA
 hRTe60PVQV517Xv9rEEGUrpEdQjlgJZyoQ4qW6i14EDul8DyLuOxpvtbzW1OtFun+aI8cFA1/eh
 7Y/Ffovc1/qRRqByhvnOsQos503Qspo19qYBf+ifvsoCBi/M0aRzL2VLpJQi1hZt3u0v2pGFgrY
 wIdnKyLwtFUMf+eyfgxeuuMohWTLJmRkShjUQeF8vK/sXW29pkxBUcz2htTCWPY9Ke7gaLDnusX
 k2vQFF/u+4YrLHXRrIoKQRiEIkxk867bR80aat6+tE+nNz5sbb8/F9qKbVFjxQ59toYBaEYOl2s
 WWTJtQ/O0J3JMBum6PlOwBtARNeSSyGJo03Tkwe+bsRZ7lPjxjHHtZP/VWc7nVwqLqbWZqn7k9y
 yxHB67e+23uZeFcdeuZW+49C4GCzNFJB9oylsaajw+NlVId3X59It011j0geiiDm2aR0XLqFHEg
 P5yxlEhbw7/u2FlSebg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606010059
X-Rspam-User: 
X-Rspamd-Queue-Id: D4A3016000F
X-Rspamd-Server: rspam03
X-Stat-Signature: epzhtjewxcrcbtdbwb1b5yizwhmehyei
X-HE-Tag: 1780294420-351497
X-HE-Meta: U2FsdGVkX19GD224WIsVbuOMkn8vsxe5AoasmILzgWHiJl0517CLF7YjFExm6FmcXQUim40K5vxRpUUuYEO1yTfuPW1+mGvJykQlHaVphgDfYA6Z9CjjcM0H3SG9PtWSWE7DP9pDftUI7U1kL13zcbzGS87Kp8JG2eH+BH6uO7rVsZJZvTnChTsdblAbWb65X9fkrF4e5sFtNRwjM4BizAD5QGOH4/fZhs8wta1n/0RDOCWWGNMD6HEIZbjRrz0TCQDs9iE9d0hhMY8k4QAP+QY3JBDID+J84yxHac7ZWJhVnX71E+r6GWiKySOFLu3x+PMHRsPKbW3w1dNXr8r2tYN1MWwa8C23uVBSN/sC3YtkK4IQdS/zFz3AZGuTGUmm4Utdkg2NAJ399K5bDiw3akEp4trXoJnIDR7PLH2uVl9oyCmaFWsExZ3m3ClmxAYVEID9buQz/ytVdLjAE3gKDDlgYmGFdsyCs7zzXAYkfXvKEVGMtybPksUbF5eqO3d2H7ihP6ByhhWkhch05CXJXvpeOgfmjDGuHdLt0ees71z/9CHbcd2rxUdLzVn3cPMi3bOCjSsZAEHF/9K47D15JCPsVY0ni/AoMPVlNSi1xhVAHa84st6ShniqJ5TJ8i+1E41hZvqRmGO/2sWsaVReA8OefH9M+PDvTtipk909dFSpFCkBJ9J1W6pAs+/9wGNV1myLEDfXKi3cpthXS4yTEtrVpy8oO9FbaLgEM/WEFlGgRVI9TB33Kt+uFBeZDeTom8eVXJLKAGJAxrfPyWNlLHKFOBSyCGWdtKVBOIIkgssvnNPY/bCvDc8CqbuVCbrYmZQpuT2YjZNtAXLWI8hLIk5wU7kpzSLxRXvMCVSRqI2YdRc6VlNIKK/mJj6W2WftULrv84tscDZqBe8ezicJoG4WYIU9POAlhtwzAqiqowiLKqft1mRDbqZR79RZ3gZfPCIV9pBXSpqE2OnoayQ
 1v91bioV
 yS5iVavlpCt9/cyPGHTrFg9bBOjR7KgIRBhHAbmc8+pB43NeMUHV5j8nsbh/jrB3jsU/j2i/rfF+LkoIAhmpa5futmjK/hm7JQDKQli61t3LazVNfx1LDapoiS3I5+YnFGrJiJ9dp2dpyNjGuHzYjlbgSJxQ/aOCrtbUGiCcCjKCz0El+FGFJGhUtIcwuZHhMQR5fvHchEqN7Pp7XzS41sJ9Y96sTYFkjYR6uyQdew2bU15VVYl8mfNGirE7TSigniUTeJzEI1h6OcSl/8A07Zj1SzP5jXeXYaXlbmU6XKsxHBai5ZFfda2/mtR4gHHK0rWeSF+QwA+3eFmCGbdVnNhLrXGb2HiJfSisDh3RpQz8zaGnt7f74Yz0qTG+1YNu7/V5xV/05+LEwMxB1Z7PfTtedFvh61gI4dRPB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

we have protection_keys_32 and protection_keys_64 tests mentioned in
run_vmtests.sh but the binary name is protection_keys with current
kernel, adding the correct binary name.

Signed-off-by: Pavithra <pavrampu@linux.ibm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 043aa3ed2596..a6b6f397d942 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -344,14 +344,9 @@ CATEGORY="ksm_numa" run_test ./ksm_tests -N -m 0
 CATEGORY="ksm" run_test ./ksm_functional_tests
 
 # protection_keys tests
-if [ -x ./protection_keys_32 ]
+if [ -x ./protection_keys ]
 then
-	CATEGORY="pkey" run_test ./protection_keys_32
-fi
-
-if [ -x ./protection_keys_64 ]
-then
-	CATEGORY="pkey" run_test ./protection_keys_64
+	CATEGORY="pkey" run_test ./protection_keys
 fi
 
 if [ -x ./soft-dirty ]
-- 
2.54.0


