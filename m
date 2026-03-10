Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E00DEFCD9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CFA76B0095; Tue, 10 Mar 2026 05:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679076B0096; Tue, 10 Mar 2026 05:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51AC86B0098; Tue, 10 Mar 2026 05:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2836B0095
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:51:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC811596C3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:03 +0000 (UTC)
X-FDA: 84529684806.02.5C20A2B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5B4C84000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rnZEfvcO;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXZsW+ak0T8ZB8EtMAosBnjjsP6rAGaoHM6dWBrFEio=;
	b=wZHCB3jHN43iiiRb9k2FJqGYofG3VnW3rKYFpocvPzZBJ+s3KoKZnffTjNhN4Lxsa8hOTP
	FGIcTrt6P+PUNQtRGf7TGxTIHqgwF4tUxiwrpvlSEWRimPm7HITlI7U7EVZj5tiHBQ2Wfr
	D4nBhIq+5dEUwPJCFuypP8+XXZj/16s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rnZEfvcO;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136261; a=rsa-sha256;
	cv=none;
	b=exi8DV0ft6xeFmeZeM4TsWh+30D4AQWGSzcnpKexCVEO91NHrG2i4p2spiy3tNuLq73w1+
	oU7rpEL+tuN1HIWEMz8ucN1VHaKdJalhto6TtHb7AC6sMCM7FOKCx06w/x7UYQFrTQujtk
	ia3lsNV0njYjrs9KyC5QIeMREQmajV4=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629Mj3kH557886;
	Tue, 10 Mar 2026 09:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IXZsW+ak0T8ZB8EtM
	AosBnjjsP6rAGaoHM6dWBrFEio=; b=rnZEfvcOr+pZFdWYpAd777kKP2yOuVnRK
	4OKf+2vCFsSTv0X9uiPqaCzpvn8j+aMuMa41Sny0sZUVRLRfd7kV6vdM/6Urf4C/
	H8f9y21l05PgjVU/sEwL0K4E2PynQLF0HGtRjgJdu3xRK3Vikm2K2Hv9ZUD2DkfH
	IDWZGwjuSqURehyzi3PFHBcdO6EslHGocWK2kUxL2i6gdC42zpSZuiqxmJKzpLhQ
	MABFRDe8WKJUdv5Ehv20gZnQAHc2Fc871kVg2bsyteam9VXJW9N+ycXQZNP1t7K5
	l1U51jslwZZt2Bdsc0L/Bdp1cBtNJl7kVkLDQaMhXqGWn02FVy9Ag==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvmab4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A58aQB029279;
	Tue, 10 Mar 2026 09:50:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4csp6un5sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:54 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9opPH24379784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A5542004B;
	Tue, 10 Mar 2026 09:50:51 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E00F820040;
	Tue, 10 Mar 2026 09:50:47 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:47 +0000 (GMT)
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
Subject: [PATCH 06/13] selftest/mm: adjust hugepage-mremap test size for large huge pages
Date: Tue, 10 Mar 2026 15:19:24 +0530
Message-ID: <a5fc759e5896898bf930382f4a353771f4249204.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Ul1BLXfo45uJkTP-aNnnvFaokKMfdsyS
X-Proofpoint-ORIG-GUID: iVNaIZ2Oy1y41i6k_7kvXMWfcwIYm3PI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX/SZNt1EpC7eG
 5wp3oCn9kXt02+Sir0iAiMZ0tfY8ru3cIQSOLQtSoWShineXcvYjyGy4T23uwGD4urrUVzKviYw
 +bSZarJQPCEj1L1ckXvRm439Fa5wGcrX82p3HfbLPr1GI7HpTmrseBuX/pVl40MT0zAvnsAKG3P
 fpxf9WZBQgdKfSTji4gA49GRGwbZAbM8eEy2zXsqIWDmAJuJhwCUAm+zLLrbffKsybqm9q/jjSf
 nJxNe6hqf4XMYA5cZXQES6j3fwDPwCO7NC96vdNl9GknjVz+iqM66ac6cxGv0Cmc6IZcAZourOq
 ROANbQa/muhbHb4xJdjIkwdjVzr2hl4YQBrPHF3gBLhnsVNQlCZEVfzjiR40GR2mbtUcAY906+5
 BfBkIO1KBAbEU7uizNdlGnLSg1s3XW8tcCfJjzH+GpswZDPe0ks33q9kQnSyJ6yLIOVAKKrmZsd
 QZzuYIxaqca09zZsp7A==
X-Authority-Analysis: v=2.4 cv=B5q0EetM c=1 sm=1 tr=0 ts=69afe980 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=OVCysDtpdsIOlQakpd4A:9
 a=aORTNHwJY3_lF7LJ:21
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Queue-Id: 5B4C84000F
X-Stat-Signature: x1oms7t15utwn8m4db6tyyu7gpc43fe3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773136261-694663
X-HE-Meta: U2FsdGVkX1/gT+H+smIoBo81Zen486Bh577cVhXn+e9kwU8tALIMGTANRcPUihPeZhaSpHUYIFMKErSRJhlfeczrKht3RMoHXaUECqWFJx/vVShxhMIQYhV/VyjAtDwNAEbwI2ydexg8DgXty+iHu7S5tUExTCRBQ3IoYdI+MUwFcWd50AJG++pOvo9JLzOMo+NAlLodXzK6fEafbxUJ7LB8kWe5VTeDU4tkluULE6QcgWTmGV+opphvmE8jFUuYd2D5t0gdADhFDGa4rYTEarFXPPpuIjNgmyQGhZpdQr90IjQuSqQwGr86kswPE8qT76xB3QQcMi3SRHZLcjl/vcYaRzw8yNJYpNlNGVBFzjTrrROD2YLNFkBDWYNhz5M3x8rQcOeYeDDpLctvLKg2Gh4972CqkeGC2JicfDw/SL2yGYId6kHVkEAaHbzWsLhEWu9R/XmPJdeLixOaE6iIvH4Bf7SSxh4CyAoBEowK/Zc/JB8GzRUXwpt8t+u9CUN4nEKE+Fzy6JlM/NrocoeTp92gmdHz12zyiVkKvifT+9z6sAPka0b2nrcqCJ/u3t75XrAT0teMi3qlaGLlmCnRR8B87Zo+joxFHnHyLyXUCYy+4psflHIBypOKtltGSZoh5EhPj0vkp1zDqDnE11MFIZlGBJCPcL5NpSWno5rWpL1UdhxCBvYrSBdMtb5fmHLDs01DxbMFX7U/FG0aDggkUT+xEo3Mio6xqcV8PbK8VhfSHO1nx8njLiYlggbt+Lec4dmIkF36zFJJr03BHnMqpkYxgdG4ZP+mfABwyu3kFIzoFCk16RcEv/r386fNq0fqk11/1TRadgEZQaJCO1WFlqqE3Lw2DkwIL/HrFGwabwEXWKbwJWFtZ+4l7Z9BOkT1usRWdfZdML4eVpFXBgjD/vpaENy7K3XbH8b1OBf5y+maOOD6bgO2Ufrcx4ecekSrc99uU6EwzStrV9Xgl5B
 eDH7WvcI
 vuu+eQsQiE9Kyydj/gUXXo17wFIhA8GajzDtBhBhnaEx1fQguJyaICBQCVOvacQ39wSncHMGWz27GA0xVtrIfyfz+2YBg31FlRMc3K5lTq+AJof/1FlJ7edUVT3bh/Cj3SrBQjsa723Pc5oX3ubgRNN4PkilAcH0YPae1B+kAvpfnTgkPtdOCcLnguweJxDUkrcQ9eMpN5jUjJ4yQf2qiPf8VUibLE0uFaBEmRwZ8+NDTT4JuEQLe2SRno+hnPkcVL/aEIU36N/O18KmJMJjXLJfMtRW/8b2tY6LOYTuwMXaz8I0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugepage-mremap selftest uses a default size of 10MB, which is
sufficient for small huge page sizes. However, when the huge page size
is large (e.g. 1GB), 10MB is smaller than a single huge page.
As a result, the test does not trigger PMD sharing and the
corresponding unshare path in mremap(), causing the
test to fail (mremap succeeds where a failure is expected).

Update run_vmtest.sh to use twice the huge page size when the huge page
size exceeds 10MB, while retaining the 10MB default for smaller huge
pages. This ensures the test exercises the intended PMD sharing and
unsharing paths for larger huge page sizes.

Before patch:
 running ./hugepage-mremap
 ------------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fffaa600000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 Bail out! mremap: Expected failure, but call succeeded
 Planned tests != run tests (1 != 0)
 Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]
 not ok 1 hugepage-mremap # exit=1

Before patch:
 running ./hugepage-mremap
 ------------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fffaa600000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 Bail out! mremap: Expected failure, but call succeeded
 Planned tests != run tests (1 != 0)
 Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]
 not ok 1 hugepage-mremap # exit=1

After patch:
 running ./hugepage-mremap 2048
 ------------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fff13000000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
  ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugepage-mremap 2048

Fixes: f77a286de48c ("mm, hugepages: make memory size variable in hugepage-mremap selftest")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index afdcfd0d7cef..7273c3e18227 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -293,7 +293,18 @@ echo "$shmmax" > /proc/sys/kernel/shmmax
 echo "$shmall" > /proc/sys/kernel/shmall
 
 CATEGORY="hugetlb" run_test ./map_hugetlb
-CATEGORY="hugetlb" run_test ./hugepage-mremap
+
+# If the huge page size is larger than 10MB, increase the test memory size
+# to twice the huge page size (in MB) to ensure the test exercises PMD sharing
+# and the unshare path in hugepage-mremap. Otherwise, run the test with
+# the default 10MB memory size.
+if [ "$hpgsize_KB" -gt 10240 ]; then
+	len_mb=$(( (2 * hpgsize_KB) / 1024 ))
+	CATEGORY="hugetlb" run_test ./hugepage-mremap "${len_mb}"
+else
+	CATEGORY="hugetlb" run_test ./hugepage-mremap
+fi
+
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
-- 
2.52.0


