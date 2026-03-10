Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C823FF3C27D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3156B008A; Tue, 10 Mar 2026 05:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A5D6B008C; Tue, 10 Mar 2026 05:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3ED6B0092; Tue, 10 Mar 2026 05:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F06ED6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:50:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF10AC2041
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:52 +0000 (UTC)
X-FDA: 84529684344.04.A9D13BA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6DEB64000B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nA7SrZps;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vh2R1fZUFI2KCkjuQb83+k6e3ocZTs8W6LF4xNSkGEQ=;
	b=3kJAXRZhcYIaTTP2fwCCRwRQsruBrUi6FgBKymUWcec83tjOBVnMXbWiMVyL5arK/7KyZ8
	SuA/gDPlVYgWmdr6mM6DaNypNLLim/FK6Cv8T2PelY0NzNrXr5v87Lveo8N8uXHrfjcRim
	F9VliBWfYymJOMD7K3aKhjT7aSOREkA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nA7SrZps;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136250; a=rsa-sha256;
	cv=none;
	b=LBok33OWyAXAyI/DJ9UsWyykHyFq3biU11wNF0rgkgOVm2C3FrEXWVQqg9crNkLWp3eA7i
	asK+/5IdGtYvO0FQyAilkBRG/+4i/NA2AU6x8tx7CXSuIb5BT8Df0ypXr+L3lysxPtutu5
	BtWjJxCxn8o3XDghSqrb6YJfLw+Hh1s=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A7FNnu1027783;
	Tue, 10 Mar 2026 09:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vh2R1fZUFI2KCkjuQ
	b83+k6e3ocZTs8W6LF4xNSkGEQ=; b=nA7SrZpsVnQmpRoRxVxVWAnm7fAdm8Bd+
	M9oAUwuJTnLzTheX7mTrK/ayTsrysi3gI1ROFg8l4mVl/aDM4heEPIV1Ia7PzMLO
	vzCaU1CuOBvrHptbGXQexP9FIgd6eyZD0XpC50AruNwXOnjFOKcz6NB82wL1oDgw
	oYXaG8ZTVDd8EMu9PUPC2r441RvB2v5bu6Poy3f/KiThtAhHdP9QnicNk59ObIx4
	CWWJe+/jtaxs9YtbfysyY6yLjuxMFRJIf5RlSIKnOAsTc46c7cxrNU+TsB8xl1wa
	dUJBU469aQPDMSiDh40QIwy3cQvJZyDRHcza8T/I5UvEKUnuiGvhQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcun9yfg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A7urQT025085;
	Tue, 10 Mar 2026 09:50:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs0jk0cfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:42 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9of6L16908742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:41 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E887A2004F;
	Tue, 10 Mar 2026 09:50:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A5F9020043;
	Tue, 10 Mar 2026 09:50:37 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:37 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Liam.Howlett@oracle.com, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH 03/13] selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
Date: Tue, 10 Mar 2026 15:19:21 +0530
Message-ID: <19d011f1e9ac2e69c8885e182f8a800fffd088d3.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: IaZJNCXQZ5CEixKj0sJsdUFpOXOBvpQw
X-Authority-Analysis: v=2.4 cv=Hp172kTS c=1 sm=1 tr=0 ts=69afe974 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=FuDccmWO3zXBdYXouJMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX3ZnZHG69bnYq
 5yFBMUxOwjruT0UOht1ss8jJWp884CZaJerpboxJ0OY8BbmzLE0miuKAUsQjSvbVSnRzeHQ8RaM
 q2wCPYa8shWyJb/gW6EpsKQLsmeEIftOX5TSxW5P0eNBq8IQkAdpfZxRDgQfSIZOWyxhc0gyJl+
 bLt/O/L8VCvz2rV+HEtXk4QZ6g6yLZs6gBG8GqI2lhPXlWh5T0xYCdVjV1E21EGUHfs48EfDSv0
 YQiugR7vwx5qD+nEkaX6GFI9HH92CX+H2hs3lg5XlDatRFT8CVAjxZnEwG+haV85A6s5K0XNC3c
 j8D7WgoAbblQvR2bYwS1dP80MmjWWmdYOxNHeqoj8pwBj6nXEpGaIz4KPhNvnOluhQSe6rK82VU
 oaRfUzM2Kt+pr1DVaSK5L8p83f0mn//o/318FWVct7DHG9q6DVUMfigEY3YdfGoZ77BXa+j1x7S
 8CWKexfJrnoVmUpNKgA==
X-Proofpoint-ORIG-GUID: gH5VyK7h9hirq9m8Hn4vEsuAxk_fP2cr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Queue-Id: 6DEB64000B
X-Stat-Signature: 1ypzgqms3i4g1twyr16tiq4r36j4qeto
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773136250-126582
X-HE-Meta: U2FsdGVkX1/47rYlnqxchoVr5RRe+RjbiNgkIaOVv50Lcs5xAofJytqxjcHo16nEFvm9tzp6VSBSZKBu2zVsCoMa/H4i0L+yDMjR0AVI0+15QjDI0v6ghTkVzLNJyrdTpIuo5+jz11smcGic2FrpB45m0YSj3CuZsOh620vGTQOO26wHVNnxtNrvEbHiwYPfaDe27Pl8UXwhw5yqp8PvnPMUzN2/diVfvFxO7TJ+goIBbSPR0X0U0lxncuV2aaU/dd3w1ApufKLWM4UUet/AyGS0fdOs31iB+rDgdPH99BJQg0bxW/meS99WbUpM3b1b0mzu7vjsgwQk6WFQ8eKuniVywFED8lHsnwlgWkWFctKT7EYkjwMwqz3LSeDTP4HWCZh2JCLOJc4NRkDQjP6APJrTEh0YlU0dXbmYA8+7r7fd0n1iYGvu15J2VMoAXFgt277buJpk9KhJNxgDi6HRUw90BhbWTTgH4IGTzDaAhHtBn1AAG40hhqjvYrRhU8cOrqqSSLVCtXCYW675H7M9xTDfjpaDLAZCbhixaXeigwqDSbwiG3gz3zuaNgDlYa7Lp3c3Chv49Ey5mZgn11lSIMNNdhhW74UOZbg/UEm2aaJ1ltWrAmiTmSXGmKnXCWftt560yPoZNmcLWIulIehB1ivDEvLyReBuSyPY0fhfFzktpIO6taHiBPU0rMi008yDq3uxEz2v0rCcfPB/W8or4B2g+tZMtbREMGT4qZYMvhbIo5cORklWU0oKNdCi0va/gbXeCEqric5KdrTG6yrq4r0nwzik65zMvx0YQRzbh37LxmXosedZJEAY5C8y/IHiwMNfPT0LszN85u7svQBtCZT7VKcx27cdI3qiM9+2EBHXS3onGTzBj1pdGO1jFaI/pTdpNKYK6dIZnktO4Q6px2xY2bvmg0tkilbWORmiTv5UvNmjmBJ1bHAnct3PY5FQP/A7rmJhXOwewqjqQge
 Jz6xJWcP
 5XbDU24FbmpiCjX/Mdi2JVIzTVYSr9cICjDP55P3oc8VcUtDPre7H10k7YTHjnIt0wXAfZ57H9OUVgAAVtbDhbVBOe53CgP1kAandmxAgcW+x3SCMPn5u9eM6ko6Xr14UJX0fy9Ju6nfFODQd59V4g8npGL9VKlCRyPfp+sADW7qLJQ9BfB3Du5GVoQoR0tV/c37EUUWnWxi1jTkYdM3SXAXdvvYq38qPCZlF14nE27p5n0OeL3o9XdIxRC9zhmATaxrCsX298Xc2xJvqJckW5FsilRanTPg2YQOgKbpTtjLK7Rw9Vz/AgIMAzvxCwUK7+yiaqAg+5mgjxuwTgjhnyMFvz4EYX/Pkkq942Pj3+zxGPyMFxH/oGY+VPKLiqXcu5YliXOnymq6ec5ffRsnMSaSIx0NYXOreHCgn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb_reparenting_test.sh script constructs hugetlb cgroup
memory interface file names based on the configured huge page size. The
script formats the size only in MB units, which causes mismatches on
systems using larger huge pages where the kernel exposes normalized
units (e.g. "1GB" instead of "1024MB").

As a result, the test fails to locate the corresponding cgroup files
when 1GB huge pages are configured.

Update the script to detect the huge page size and select the
appropriate unit (MB or GB) so that the constructed paths match the
kernel's hugetlb controller naming.

Also print an explicit "Fail" message when a test failure occurs to
improve result visibility.

Fixes: e487a5d513cb ("selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/hugetlb_reparenting_test.sh       | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 0dd31892ff67..073a71fa36b4 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -46,6 +46,13 @@ function get_machine_hugepage_size() {
 }
 
 MB=$(get_machine_hugepage_size)
+if (( MB >= 1024 )); then
+  UNIT="GB"
+  MB_DISPLAY=$((MB / 1024))
+else
+  UNIT="MB"
+  MB_DISPLAY=$MB
+fi
 
 function cleanup() {
   echo cleanup
@@ -87,6 +94,7 @@ function assert_with_retry() {
     if [[ $elapsed -ge $timeout ]]; then
       echo "actual = $((${actual%% *} / 1024 / 1024)) MB"
       echo "expected = $((${expected%% *} / 1024 / 1024)) MB"
+      echo FAIL
       cleanup
       exit 1
     fi
@@ -107,11 +115,13 @@ function assert_state() {
   fi
 
   assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
-  assert_with_retry "$CGROUP_ROOT/a/hugetlb.${MB}MB.$usage_file" "$expected_a_hugetlb"
+  assert_with_retry \
+	  "$CGROUP_ROOT/a/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_a_hugetlb"
 
   if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
     assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
-    assert_with_retry "$CGROUP_ROOT/a/b/hugetlb.${MB}MB.$usage_file" "$expected_b_hugetlb"
+    assert_with_retry \
+	  "$CGROUP_ROOT/a/b/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_b_hugetlb"
   fi
 }
 
-- 
2.52.0


