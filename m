Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE86EFCD9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DF86B0089; Tue, 10 Mar 2026 05:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072A46B008A; Tue, 10 Mar 2026 05:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBA4E6B008C; Tue, 10 Mar 2026 05:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCF386B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:50:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FECFC1EEB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:44 +0000 (UTC)
X-FDA: 84529684008.03.E25CB0A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56A37140014
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LU5u4RCC;
	spf=pass (imf26.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeAr90eFhRz5od8FjNUqBWIiRy/xl55LDbt/6vvvs58=;
	b=5VpjdyGry98tSTi5H25lg/TaLBWVMgv8MFMiiJOatzwkfQ+LN1oluHF5GrR9yxtK7wjX5M
	9SRAmcMcgMcTLXeWhP4FYgYTUdV4V0ZYN8d/CcWVKPobtiAkN5QWBzjjWbwJ10+KQv4deT
	UBPvt75lJN44FkQyidQGRhyhcYsmqiM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LU5u4RCC;
	spf=pass (imf26.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136242; a=rsa-sha256;
	cv=none;
	b=bQAtiN3gWjD4yMKMaB+aLn3oR5UnsNo6LX0T8TuCSHfzPnKQ2Z+ie9zE1WaWBtLwnb1eo9
	d00UvRmwzWdvZCUWNscyqKvH/Q4olVVYxR9AXl3uC3alwJQbZrZG5WOTBRQleWN5YyVzpH
	nJdcZ9h0FEpOKeA2NeI3RaPhWcs7jmY=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629GYDIv1913204;
	Tue, 10 Mar 2026 09:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SeAr90eFhRz5od8Fj
	NUqBWIiRy/xl55LDbt/6vvvs58=; b=LU5u4RCCp+T+zVlIoKHR/mGHzqXRCYpTI
	3WyS2QxA6XNTpYaiC+BaQNIIwWPFxFFC216QPu4MDhoK9xludWw4c75RuH18Ff/E
	Pvx81H37tIUhcamIc9PwyNBawppTGnWIsEAj5SXrFunEvFJeAOQy4UUFkMSbJPoz
	PptXbnEYrMhGy9P1kDXbYKF+jcMm23dMKfZmRH9HiLv9YXy6tyLvzHbnWEWCyiWn
	fV0QVOdaEFeenZnEz2BdnSzep8wouiJ2TlwEkbia+E6KnZFhMOrYe6MOf4NNczgD
	eWSntg+IhkGD2ENPrqL8yRjg4IXwi5yXzUH4cdIMAypQJn1SO0CpA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcun9yf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A60oZ9021365;
	Tue, 10 Mar 2026 09:50:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4crxbsrpfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9oYHL15859970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23F4E2004B;
	Tue, 10 Mar 2026 09:50:34 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D39982004E;
	Tue, 10 Mar 2026 09:50:30 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:30 +0000 (GMT)
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
Subject: [PATCH 01/13] selftests/mm: restore default nr_hugepages value during cleanup in charge_reserved_hugetlb.sh
Date: Tue, 10 Mar 2026 15:19:19 +0530
Message-ID: <aef8d9c1c6fb2b80af90543be21e15030e720733.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 4WpWe8PCgu63lWRoOf0rVFa5-vg3lGuT
X-Authority-Analysis: v=2.4 cv=Hp172kTS c=1 sm=1 tr=0 ts=69afe96d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=BQN3rKDzEokXj-ItFMoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX81dX/sCLlI++
 BPg2k8Ms2lTcZQ4PlZiBgWyZmdi+0Y98DtSSoylm8wza+VE5U6pPmUtTmOBwGaRCWnwFlZ7CbfA
 W4Yakj6ACeMSnUccVAQ44orG1UqPxNpMxL8SYE1xp+BVCyvYXwO7T+gxmnKJZrB514C5Snv+d5v
 CTI5znqOYKLCxQkArBgcPsiQ1wcSGHjmln+Q46O+ympYvoXTc3nnblQ858petNNyT67E/21yJNW
 S/Ufe6/0RodfrNBXvLhnR6bgy3bb6d3itzHFDV8LDbmsHMJzNoLWZDF3/KO2NKtuhFouAvsHZq/
 5nLmKViGqWGXKluQpwkNM1I27dvOaKuMTGaKz/3KOAvy/5kh3wvciJp5HjVYBI3kCR+CvnDdzMR
 l3/9j1PKAAz3TEoQMMg2Vik1v5Ra9D2HfOq+amELKeLEIBbd4PdtJ85lfz8UNWh/03wHZhPjBWg
 9aWrOaEg7enpHHo/HgQ==
X-Proofpoint-ORIG-GUID: ZYu47pYo16JodI_J1nrpuHJ2UWNfhrDv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 56A37140014
X-Stat-Signature: g99i7mye9mwcomziwzryjuub3u3x91sm
X-Rspam-User: 
X-HE-Tag: 1773136242-905036
X-HE-Meta: U2FsdGVkX1+sbDAnPMpst361yCaFpR+/H4ZNlNa+rYuvkIwlo9yY2zQxDNpoq+gUi5lOGzSUgoo/mRHnIY71seVkqSxFetpONhK8zu3OIDVS8N42jATdc2fxvqFZ+osuikvaC3o6WJuc2BDq5/1UsMBn2OWANTIvq4pHZ6moOtYJ8EVzEMNw8fJi1kAZ8rkEb/KHAGt49L9WgOpF93OcoVTdJe+x6cYGSLqMVTuK+TcYPuCRXo9FTJvK9ZDf3JwM3yXojDg6C5uCeMJJFNTQV+7vfxDrYzErolEohh1iSphEa0BrbC+nreRmQRq2KgLFO/ZEz2QL0Je5yf/wpmF+EE/mVd3BlYT44qV+PLEthHMp0Ka3dnIY5XX6v08+uJbfa39goCjfUHvlG268WbGwr0737V0dRhuG4VEX18CXGleRxaWDBKebNmjrjHKnLEzj5IKkyhteDA+uD9wZy1SgN1NJ8g+YZrnvLXbcXD6Zwqd4puW1jV1LFbeayQhTgeCaklwhjDcXcWXN7t5TSXBVfPivyHFEm9zH5H3KLkKbU/DUWk+/UXgoCF1qkTFQaxCjxzgLlLBPF0J5/Objgtdg06tLXBffd1mPIUt3VgyTwDW4fUafx6KrXTQW46Cm+KsVaiDllEN3fk+3V4ChyiaZTj4Rg+7hGySW0HRhphPbVlDdKXkz69GQinFlyiY12Tuby2S3vHunUKgyrWDuuRe3/ZkDcfm8zqfM+rOnupG9ajeBddq1vFsK56WmxgsSlvQKbmEVUN3tjgptFp0nmtoy99yysfgLekyNOtJ1KN2qfmhzQo2s/bG+/eg5bxUt10MEEYYsDH/PLGQnw7pKySx+3rdFCMSrFbFds776Q08MLMHRx6sWRLRDaMl/53MfxkurjqnVBP42oebmbt32LtmiOISTABwb6JdZazc0XkJvM92EkCpi7EHKAYXjKZZycEaeySx5sWXGglwO+dj6kdZ
 UgYdVbQf
 2L3wFyix9tV/m8jQkb3On/R1faX79+uW0AGHKV0XT7C7Y4uM9ZeAZnoFUvYjDfGQYl890azl5lnPp4k4U8vPN9aYp+Nbmgyug6yQ3R2UiGU4n4ddJtD+OcpfwBP2Ox1SGb5ekpOJ/zC7XqnbB0wYMaq8SQNAuAVgIXmPRUhz8WkG4F4PTSp/qRBX7gVMWzNm7ipAL7T0zUC9AQw4joiZ1hYT66weWviSHRwkTgAiMVf5CNkvrcdcrPiLalof41G2m7MP3at3HeXBPRAuwODKcvX3Bt+oOoOQ062yk43lICKoUdcTMrpPmm2ArXda4luomw866/FDCTVsv011HS4YxMbTbmHpX5+3Mzc9zf2gwhocIfpCRw46fzykawj+CPqoLSVPzNleGbyLLLU/4VnCNEloacdmtuREWj1pd
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


