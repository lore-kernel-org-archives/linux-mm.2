Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD4C10BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EB36B00CF; Fri, 27 Mar 2026 03:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEFAB6B00D1; Fri, 27 Mar 2026 03:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DED06B00D2; Fri, 27 Mar 2026 03:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBC56B00CF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:17:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 380691A0C39
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:40 +0000 (UTC)
X-FDA: 84590987880.01.CDB5021
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF680A0008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qOcpPHzH;
	spf=pass (imf15.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBOgR1l9moyFZt4QtKx6pynWY1WrXZnmRZ9D9UZIMvA=;
	b=ug66c/wiTFc2WQ5fLUyr8U2Vf2aYTwotqVeURnxRwMVy+tKcBhPet+nkpeUiCms3AJyCDm
	l1hDI/p+4GPuN1GNJ4hdOvEyjbMIin19yif3jp7Rp9nH1NkSwvfLbeSYtS/6FFrD+K/YXS
	0wRcjmPKzuL1EaucWAjeYWbHDU1Ymb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595858; a=rsa-sha256;
	cv=none;
	b=x38OrS8gpMbLPFRszp/4ndCzqOZygrw1biBO1gpiMvx2zZMaJtzCKvX52tIUCDM5Xwiz27
	S1/xEXZw5pe6/Sx0/zk9kmDK0jhJZsc96VuyvsDYIzasI/vzeurVmSB9mS8riqxcMaCbbH
	za7UeTmC07yQ04FZ8ir/qOurovSCMDI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qOcpPHzH;
	spf=pass (imf15.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62QFxoxX755965;
	Fri, 27 Mar 2026 07:17:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=TBOgR1l9moyFZt4Qt
	Kx6pynWY1WrXZnmRZ9D9UZIMvA=; b=qOcpPHzH+o3e0onJgNuSY6rfdlaVSmmBs
	K20X9oi9kYFEGai2sXuzhMx5kDWn9+Pm769kFcRa1y94qQLwoviRP2xYbllz0sVl
	QgeEmvWGbzABgh2tP5X15LFrXL2lM9lJzrJXntdLwKTBdlBudo/1lU1vUP/ooL3E
	qkJ9SxECcvvCZgOyREEH3oJ2e9EZjdI0/FpYS46Cl0jNlmEg5vkD+RMm4QdRER1G
	4NesGH5U2cqBGAqotJUW0ipiLK+LLRbx3s+uqH5t1PfZ4eoFIDgHHM7u9VV5ANmb
	TKBs4itGO1qM7Ue3rUs7JVOqlJ1BGzgb2vITPnFHJY4DgFPlR9BVQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kty8xaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R5f79R009143;
	Fri, 27 Mar 2026 07:17:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nnxgpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:30 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HQGh51118442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9C7D2004F;
	Fri, 27 Mar 2026 07:17:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CF5520043;
	Fri, 27 Mar 2026 07:17:23 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:23 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v3 03/13] selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
Date: Fri, 27 Mar 2026 12:45:57 +0530
Message-ID: <05459b5038595a3a673507e707402839cdcc2955.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=IqITsb/g c=1 sm=1 tr=0 ts=69c62f0c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=FzkvBdHCBhmLUSHJBJ8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfXwqNqCoTDMWjI
 V/cDYptktXkfxpQrOGMsHHe5eiKQRe9KPyV0hfxIOGW/eaJWwujzyU+TsC3AnI3kNt3/xox1bEz
 RO1HA1yguOGniLXKNeTpwkKawakNtGFsZrLSH1hBQaYLvOoXITyk1uDCiQgWveNonrQJG/wPjms
 jgd2Qzx6PpNk7wRW9rxHDHjilEonsKSJkbANQht5N9mKPd4/xm1h0BVL4vqzP/P0Bv1kIIcvlkU
 3l7UX9OUBIpEMyv9l8fpDAZOqZ/3MvwMdG6CyCstnIEqlSMD/fo31+IpV+7Qbpz3AET9meUmgzN
 Gw/hBH5drQequ8wv79DaLtCXUgVxN3BkR/jHCxkSA1rqTAAgcx3o09+zTJYLi923cJop6GHnzW+
 7z5ajzPMQZJN56W+CFGOch+pq0tHF9GhUPdCPpq3w8dGY5wxGrC9sDJ9RIZSbW+2Wn9HoiXLoW9
 ydGYWXGxCHglFCeO1/A==
X-Proofpoint-GUID: dhmQA_ssikxSnGk83UShumqltiWBxoez
X-Proofpoint-ORIG-GUID: Q6rcQmFkzW8eNl5Ajow8T3DjL16loKtD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Rspamd-Queue-Id: CF680A0008
X-Stat-Signature: ibztctuucmcm6xhii9z7txa8y8bd38k1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774595857-932310
X-HE-Meta: U2FsdGVkX188U6An7PRcWkZZQwMty9gClnJz8WeGwcB4ITU43dA1MvL9LdHE5pVKjXtPBAsDVLGoICG58ukcGz58Vzd75u2bkEAkaLNTqgLsUERXN3dqfmV9UcNz/A1De2RRk1Po/jGsOoRJGQZDAmoGJLpTT1OYMYS9IbRE0X9CORGwxU7PgVN3qCm/K8ByQzBnxPA54L+Bk27T2qtM7T4SvYa6CuvxOzciTCZDstCD8HY42eSRSLNZF/fhNA157q74JN9hSdQLDbq+7vDbB+WN6a+rb7g7IuuvltdU8rKZK/7TS3aEn7+Gf51GA0EhpCXxZh/dlSXAtINNnr4tfIQP5aU467StQIYCjoQyz0VC6RnJb7LJXDPmUP+Yq7FR1Ym1x3PWVuQ4e28OHcFwgm1w8Mo628LRlaSOyhrLNDYgF+Q6RvslaAWtRMVXOVviKGjMr0LodW8tLRZPl4ab3q0PV2HcpFFl7uAQGdHlwVf3cTPOUM24eA7W9I17ieLvMMr7ROTZbcmDfTS0TZhQmSiMwLbsXWFrCgL80eA7cjfbAVSE5NMFezz149OiwaIfLINJEeRU2IGMMHv4FfGGiCPpU8KlVFEl3oXR6r7SyPZNmmX7K8A2ePqrHh8+9Y4ordo6ciRWfPwFEj6xDWCmuK4reoTcwa448GUXU5z4KdALniCLVhNEWrFC6+ObOJqApiUtop/y7I2M5MaeUMgUNsJJtnuQIra8ncgAW996fND94GyTgW6RGBabk+tV1VDm/9hscqsUkPd3QZ/nLOWZGqb2XiKdz2aJ/S5N2BrN6A7mWzC8WihVYVoTvvRpNqe6fYMToZBG684ihDpPBb4dugpQP2r37u7zB16ATIZD0GPP+vvREsk3Y3W8HkiXAIcBpcqNNp9JJPGUAshjANk+MXXzUth6VE9VTEF81f82UZbaHW5we4wI1mA3FRvlWO8iIB1iTknc8r5Bf/fvdgK
 SaXg/mpo
 JXZwLun34royJ72TLEZwAzbO1CsEMEPkket47kL6GxBmT5rxz72sthhJvGHnOVWU2ZvMjBN1eVSpONFNwiMJ5aHnlvI9ooGix6HELikKdV6H+0tiB65joeFj6w65UhMS9qAFfVIJrfWW7nQuqkfMv98F6Rtgki6kr6Pn4bcuG1mhpKMEkFEyWt3kKbQW5+rfQLjbeR8op0akOXY/g4UKA9N6Jqx0/6L6LgqK+2fd7Orc2LLzWpLrkNN9NMw6WxAqmlR95S0oV6M3NPcUn8pt8oISbV5L4rNUYBZMpCbSS2cRP/05hzIxakxTdKCggvAeZVnQ3AASHzxc6qGuF3K8gTBgceQ==
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
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


