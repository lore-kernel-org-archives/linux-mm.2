Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C35F5105A594
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7C26B0092; Thu, 12 Mar 2026 08:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98676B0098; Thu, 12 Mar 2026 08:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5826B009D; Thu, 12 Mar 2026 08:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C731D6B0092
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75801139998
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:17 +0000 (UTC)
X-FDA: 84537333594.04.2E6A954
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 33A1CC000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V5K0oyXI;
	spf=pass (imf22.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qSq1MVoaxT0x7vgUoOua+dnJy5M7XPh6J4mmqEG0Jk=;
	b=0IUBA1ZqPG0rfZB8sbQKPGHJtxT7+vcNYUHEdKdcFgeJPbQHeXYHkFnXsezQk/uWO2bnAC
	CTN+VeMDgAVpHD1AWGZDBmNmrIdwdNLBJsstN2ysk0NiOHWMsrE7k2UA8iGVSpOQ+hqVaB
	U6S9/+6G96vusUuD8OyhdrmtnOTlR7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318375; a=rsa-sha256;
	cv=none;
	b=gr5NmuTNbqdhiuGI49mnBpaQkfpp/AZr6vdGOUvbv2O6H1D6/d/Ek35F0G0IFAqNoYogWk
	vtWtkjVrh6nGluyxtHBhtoCtmdJorqbN3s+NYJG0GjcTGjv4V275bonfZKtL8IZC+o95hS
	03DluMS4MTk1DfCmiEAoyw/e2enqq50=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V5K0oyXI;
	spf=pass (imf22.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMWYmB2307755;
	Thu, 12 Mar 2026 12:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=8qSq1MVoaxT0x7vgU
	oOua+dnJy5M7XPh6J4mmqEG0Jk=; b=V5K0oyXIAlN2CAIPwr4AlyTJYmxRR6HTg
	ju2WKdhOHSHhwmLrN6bB6lGycKKQA49JwjpdFN+MaQwm6QHmY/C6WJ6mXyNIsqKr
	ntA6p1qiPbwDWa5Yge9x+xeMdS9bF26JQGrStIuo9JOZ5XPkmY+3Jh4TmuCB9jc5
	qvUXmLk0nU4dXXxZJtxGBfD6pE27M2mrfhRHhFfBcESpF7xd/xG5YLUccglkB0Z7
	tuPfylG5H9xkShNigG0W8h0bSznmTsZLAZSr8JvwSJtL3rIfbYI8RNgulXf3+D+W
	2O+oWhXr1LQ4+l/I2m4fMsBxWJHR2U0o5jN0T+eFaVNscmT7sO0bw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh96agsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9lbN7006048;
	Thu, 12 Mar 2026 12:26:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha9j8sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQ57t50266558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A837A2004D;
	Thu, 12 Mar 2026 12:26:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D9242004B;
	Thu, 12 Mar 2026 12:26:01 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:01 +0000 (GMT)
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
Subject: [PATCH v2 01/13] selftests/mm: restore default nr_hugepages value during cleanup in charge_reserved_hugetlb.sh
Date: Thu, 12 Mar 2026 17:55:28 +0530
Message-ID: <9d150c91d4fe18732f9a90234e6878b7bd7f61f7.1773305677.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfXyt5MxPqV/3Id
 hTNhrbYZLCurtfYEXPNatnN/hOFjgQ+1mMkfU4Fv9Di/WjsEO0YDak1PvRiEYhzceP8rLGph3NH
 fUqsSd4fD5PNEUp9dEaaLGEpUZO3riogyGW0PIXTt2tcVXcTu2mehg9HaMarrMm1ytcPJvStAMZ
 cKDISL9xjw/kpU+ri+4aEq8mbdsJrM1h+bMUDNSjv09I6TYBJA2RwNVX+XOsYaKblgHXKkMvT3x
 TMlHKicZxHc/+p/ejcbVEJeg/tZFAqLLJ397DM6pbCcamX7pSY9FAsGOobR24sYyf7/6Zjj6kvE
 Ay/xW99MzFmmHnXIAtXvpE1xLOgyc6kDqfQHBWfFSbbB1Za+XU5vrc0dvAlsYbS6NeN/KL7Se3N
 nwRaFM4arNuMrzbyuP0Gk4PNvbVc7vo+jRliWxhB95ffgAwvBFwZCg6eQhuFn6P3oIOHbZg5m6V
 SkMeYHtq+ZoqbhxMZgg==
X-Proofpoint-ORIG-GUID: s9imjdtoYdCWrwIH55kSoeUlUuV8-fqF
X-Authority-Analysis: v=2.4 cv=RLO+3oi+ c=1 sm=1 tr=0 ts=69b2b0e1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=ZPMwvEa68uiV5BrjEmoA:9
X-Proofpoint-GUID: XV0_N_WBNmd1FZFKjZZBVtYm8c2R0vMR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120095
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 33A1CC000A
X-Stat-Signature: ukmrqyr4mqikz13feha6fcg9dxbk1yt7
X-Rspam-User: 
X-HE-Tag: 1773318375-395777
X-HE-Meta: U2FsdGVkX18GcPVRUU59nbCaSym23fyYYnqRC8RJwq9Xizjkrx3DFjH5fZk4FlWPWPVOsKttDfX1E/+df9bjPfs/z/BJTTbLt1J+akPQPX78IFBEOgsQirCpU901ugEox8aXSQhgps/eWC4V4Tdqv/V6HkPMQHtPUWrH0YvsX+gj5e7DtkeHPSylpu5bDc+kWdxWUj7XThCeBSFz2Ae+4b/f2Un48RFKQZjZVCZwo92otkiG6OLzyYl+T/8HUMO/MqrPP9ItHh3yjBNfVMPHcoJw8WivxBVrXWewvOww6GK5bNxA5tQst/xr8OC+6bcUOAh1+aTM3qRH6EAuICd5oUlkCdbzmQbUakKXkeRH10BOYnsP3fE2sNJiKS+V5jF8iqdphLIXlvBAGs7mA2ErvikQUrqmCW/lt8fLYbEXgdphgW1jIFBv8YW5aLTCBL7QZk4rI/4qVeQTyv4i3KV2gI5EKc482Duf+UJzf7nKmcXBYnGdHhSQL7G1/MSkJNsjUJhm1DkYM0+T/qHutV2f3ItHp2MxmWiGw6V20AeJ8HbbaY+inOWLhp/cxWSoc/JgcWdqf8OqzPnci052DKieynpdkFNWxflQ5O53rF6FHa6JBHYG3+BKzgH5DcQ4FAysMMDA/NioE1aRviizYf1/dkOVPcpAvPR2M7oNyaANuOboO3PKK4nmF6iz9Rfj88BtdyMBn+X4ej43xurr6YQiZVjwtPNDuTtD1Zp3kt94mcqpP1VnfNdFGhhEEb7vxfsNapkRvFamgDCHKMbPZu0kt3tb+gpqNIIRGGZdU+P1h26XiPkzQ4YAdITIGWVcl6DLY7Lx19oKCM4RrosU5hEbD0Pcr/hTUu3uft8koihjze74VSOJeSEZEvOBUQoIafQatJ3x/RG9zNiAaJUlmSn/MyV5xemel6mvKbe5YbNG01ZEQ7ao/xbt3JdRH/5chz9x4bLmD1EEb60M2FQvDHd
 P1nydrE9
 sIe0ZiHPw2P0lPmxq7U7CCuPXYIjJrD9TE3RSlaQ344gUT46iiBMGs2wlzUxcQtA+2QihhFvLYEuChn5IvMFU8+D6rKPiQ/+fHoyiigRHwnDpPbAXxxVp3iKpscTsOivU42OIYi6YlgMZ5J+zS75wxK1a7amLaPTKU8PVfP59Iam7KYzS2a4Z7U7b+EjuNtJeTzaMRO+ji7+LPD+K3wVoVUE9ncmHWBIvyUzr3t6OLW/0GaqZcM1eEIFS2lprHddacDaw17Zr3CIlUsxbX6Ii1YqtT2kEtGCizqa44pjcPtkeaTITKRt8PnhkAFZlEqOo/vFqldhbJ0c1pwrA8Aj90tLfErLVIQHvOB4eVt79rekVmOn+F7YfquTkSqE8RPzAezgqAbJ/sCI+6s4PwplYwXD5Pw4m2Ch3CQkfXa2c4rrn0gE0JxCXNaTcZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During cleanup, the value of /proc/sys/vm/nr_hugepages is currently being
set to 0.  At the end of the test, if all tests pass, the original
nr_hugepages value is restored.  However, if any test fails, it remains
set to 0.
With this patch, we ensure that the original nr_hugepages value is
restored during cleanup, regardless of whether the test passes or fails.

Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 447769657634..c9fe68b6fcf9 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -65,7 +65,7 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 >/proc/sys/vm/nr_hugepages
+  echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
-- 
2.52.0


