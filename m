Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031CBCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC6C6B008A; Thu, 21 May 2026 02:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6846E6B008C; Thu, 21 May 2026 02:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A0E6B0092; Thu, 21 May 2026 02:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 480156B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D44DB14053C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:22 +0000 (UTC)
X-FDA: 84790498044.26.9F1EB53
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 88CFA40002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=S1uj1feU;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuvm835NB4tDr/INmAj8E4pEfzootxPjtudzVh0pFns=;
	b=BZ+oHLfXFjURYnG+PKQZGUir6+ZPno7mmvPrAE5ogoj1H5zzZcUyTKfiHxvmjAZC9N/BRN
	Ip53O1PJGa9DAkh7APNPYt0D1H3kbnw6P/ZH6tmGB4Xk9jzDBE4GlpPCJKcajFwxmLbTJx
	9KTBbleK7NEzMsnfr9PjxvDa+BjQIY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346100; a=rsa-sha256;
	cv=none;
	b=BEUiUNh8SVNtQf/69PQJTAvZFl9g+FmLJJlp+iRv/UwphkrphP9FP1GHe8TXzW9ggQ3qWi
	TzeCFxPizOqCFytQKyvCUiz730t+hsS7RdaTQxhSVzppdNWT0GpSE6Hod6Wki8e9kFqck6
	xQZhVxWnBPN+O9hiIpnnNXWTSl/mhqg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=S1uj1feU;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L4nxT93913287;
	Thu, 21 May 2026 06:48:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=wuvm835NB4tDr/INm
	Aj8E4pEfzootxPjtudzVh0pFns=; b=S1uj1feUmJDrzF8biPNYlSJlwZkvySj8A
	c0vtK40B9uOmElM3p/wooq7GMGYq6O2axnTQdeTfYIc5yRVBI0r/oSHBs15AlUiI
	W0XT9VyPCe11iuqYYMoD71j8p1oc4Wrf5h1ffu+WUBtwCccw9T3PZ8/uyUyUs2S3
	Tb/HVjajSRP8Im2Aj6ick5a5gjw06U3UR67kK8DfbXJc3BSRr9ZfHUSsES/hkZHy
	cBuNh2GYPstp3O+keUytMtW297WUFXcv2JJFCJFaqeWub0Ow92dFUu0mpMejWmzo
	cvaSZfvT/SrFG+sBTOHwgQTAXKDFLLnl8NG2gzQjTlRj8H5IUzGaA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y5k63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6dBB8018365;
	Thu, 21 May 2026 06:48:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75kyajd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6m12e40829320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:01 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 986E120043;
	Thu, 21 May 2026 06:48:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C819E20040;
	Thu, 21 May 2026 06:47:58 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:47:58 +0000 (GMT)
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
Subject: [PATCH v7 03/13] selftests/mm: restore default nr_hugepages value via exit trap in hugetlb_reparenting_test.sh
Date: Thu, 21 May 2026 12:17:43 +0530
Message-ID: <29db637c3c6ba6c168f6b33f59f059a0b39c35c8.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfXyUiUAcSTpt4k
 fKUdI3XYMIKIt4FLxvFnjj4gx0nrIHMwvIuiRoKid+KvpYf6WGbDD3kPCTnYTm3yCLmk35LXTRm
 iuXfha/wH0vkSdb4evkhsq8OPAjEXAHZkPSC+q2b2d6bumllxqxXpiDfdQkc7x8DCeLlWZAgBJE
 w7fan0s7Q7EA/SYpjatFm0lTkRPdCENRA+aaj8iCsGkIuSgvu03gcAnldNRM/hGiZqeMc0mv90Y
 BRgqeP80klWcc0LukWJ2iliF08qtjfpwNEVqPCy8pOBDu9+AKecPbVNUm+kxxMUrbt8LKVt0sz7
 okVb5RXHIUdycvRtXSKdqISkIjLOkbKubtsoV3IbcfwzFzTaZ4OsjhYITf3h1Eprn6KstEM/ZxV
 pVVyxVBjkqiX8O1N+z9mtuxABQDQ/QbuTtHguCjRzkKSv1Z0ojbLyDYeFHPHqkMXywdSRr68Rh/
 xhoKAMrco2mu0fIwvbw==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0eaaa6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=dU9eaedoi-733nYHt2kA:9
X-Proofpoint-ORIG-GUID: G9G2dDS_3HjUZVGRrb2MsSArkdyVZq6t
X-Proofpoint-GUID: 6N2rSNS9x34ORBswSKiOSH2EjL8vY8sw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210062
X-Rspam-User: 
X-Rspamd-Queue-Id: 88CFA40002
X-Stat-Signature: 6i4qa3tzxsq4bid14qn87js6axxbewk5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779346100-28851
X-HE-Meta: U2FsdGVkX18IGuh7PqQTQe1OObZCVUhXF2OcXYRCFccACIdd2rC9vpBFPB24cxPZjRSIxAUgRBe1iRZfyO7jtFPA1e5jk2BPK6ihEPwtiCQsOy3Kaugra3lNAvMP8sLOO9zh4Mwlp+MNSBwWmLyZI9EAWaJfqwlyBbmigZwUBCemNzUDw3se+owDqYE4hLlb6LdetNksFGdT3vl+lpLhMJVdPv8RdGEI0AdRldFqZopGEnuaG9+wLfqwIw1VVneXQfUcb0YaljomR/z0/wqRuX3xBX6/O1GxXXgDfEttyv1rSYJPvTEjU/7/fQidNvyl7V73WKQ18PSzDkIXkFlWwlG/xPANl4B77afrI1dMphX1+aJQFJzeu1dFzcbXQSkkiXqlyyvFVQUJ7c7Gk2HQM+bAYd8j5qzdUIKjNjxnq4M7M9HD7yMP4rCnsNcgjJIoxKikKZwdPeBR7Q2/8pAUGIJ614j4BnbQTXvxpNcyjl/d7XeWoNRWfzH2nmsha+IHLWGXfeAdWRZkNKL6yzB2gVYNF9c7sPgCWAyDKOEKZfbok6oUmCpVYEsaOWREWyC8/SXyR/1Zjr2/5Df2MCpKZgPHYmW/Ffghqg8kGzsfKPylyL9lrovTySXZvfpRc7hiUhL12S/Lu7BgsoYEwYCbv1z1XlC2F7okbdTtc7v7md83Xmh08QeZrBRhdnIeJJbyw5dmlYNKuAsKXKpikmD2M5maHdhxVLov+NMuHHxEhBMyPi7wU+tXhv28WNjTwNL9jC3bLwfJMc536csH2O7ddKwfWsGZJl0b5iCDgqc4HlIG8cGD+kiNOfiL2qC/k4PMZ/ic1oCCBKb9mph8snyHroJwMydaerQVcUbR4LzqWJXW5xTCy+R1JKza0XakucVpmBcxu47Tlt8yiZAOBGYXIHv6HV+sezBLbk6z4S5P8iqh393ALspH7iq1Op+V197GaGKQ2/rlQ139nvLKgQJ
 VvYjyoFN
 SRSbNOfe11uaoC8R1TmirLU7kHpFdDHcWxzLxiDoUdiiBh+O01Yp1T2fh0+Bhr8aXRZTytPVzWrhArGFSBJjIEbnlDQmscb6+kwm3tW68Qz4NZtEQTpzRYZdzEvQx33yeXkwyHzEtUUtlgfjCox8iK8RHUT1e1pCC45zGjCxrAGzbphVOvRofg+DvW5YIi8WqF1Lz+/lY8q8h1oRXYjGlVkupSJgHSWUNSCbN5ff0hsenksdVwqddbvRAOqYK2SowmutVEwcs+qxQxb/Q8H4kQLeBcMY88488oc+BhVIW9yeD0HDp+mvMdMkWsEvoDufFXZElP7dTxvpy51sL5wNa0Ggh0rpOkamrdLgqSqbNnpiClqc19ozJLxTuGyJuZ8wMDDVCrfuN8/9yUXrOZOymUF/UNfRIZUwC7wuTBQgvNeNeSGu+WF385JJ8Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test modifies nr_hugepages during execution and restores it from
cleanup() and again reconfigure it setup, which is invoked multiple
times across test flow. This can lead to repeated
allocation/freeing of hugepages.

With set -e, failures in cleanup (e.g., rmdir/umount) can also
cause early exit before restoring the original value at the end.

Move restoration of the original nr_hugepages value to a trap handler
registered for EXIT, INT, and TERM signals so it is always restored on
all exit paths. This also avoids unnecessary allocation churn across
repeated cleanup/setup cycles.

Fixes: 585a9145886a ("selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 0dd31892ff67..11f914831146 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -12,6 +12,8 @@ if [[ $(id -u) -ne 0 ]]; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
+
 usage_file=usage_in_bytes
 
 if [[ "$1" == "-cgroup-v2" ]]; then
@@ -56,7 +58,6 @@ function cleanup() {
   rmdir "$CGROUP_ROOT"/a/b 2>/dev/null
   rmdir "$CGROUP_ROOT"/a 2>/dev/null
   rmdir "$CGROUP_ROOT"/test1 2>/dev/null
-  echo $nr_hugepgs >/proc/sys/vm/nr_hugepages
   set -e
 }
 
@@ -240,4 +241,3 @@ if [[ $do_umount ]]; then
   rm -rf $CGROUP_ROOT
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.52.0


