Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20502F3C27D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE476B009B; Tue, 10 Mar 2026 05:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2626B009D; Tue, 10 Mar 2026 05:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659D76B009F; Tue, 10 Mar 2026 05:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5170D6B009B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:51:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F0651C63E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:17 +0000 (UTC)
X-FDA: 84529685394.20.FD9EAF6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id AFA581C0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FlvZFI4T;
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuvmGpMHnOZI9YvLg1IB1wfp8k3IRUtttH1sM1d3y3M=;
	b=wBu8LdusBXf6w+lYNdTFeiINddQzk3jWgISwMG59PanVBkKimY1f24pKvkxtV6RnF/rrWV
	CFXo9fJNYxetkUPa+pTVDia7Z40LDtz5OXeFVof5o+93EawbuwCipydpz6IXkY7KD69J7m
	iIdaBXx3wuasEaUnI4wBTVU5kcXtTEs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FlvZFI4T;
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136274; a=rsa-sha256;
	cv=none;
	b=BBlysq0BUHPqdyUNXo3KKJPUr+tjOyfcgvCT07kV/rPHhlRX60WyjNROH1OUny+tN0YmJN
	8bJut8TN/Rrw3kYtx8xZO0vAT6TupWWVrzvdtqGThF336EOXbyXmmTwpnEw0rPcRRjjjmt
	QDk+SZ1NuV5+Q6tHdcchh+JNidGapB0=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A982rt1245259;
	Tue, 10 Mar 2026 09:51:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DuvmGpMHnOZI9YvLg
	1IB1wfp8k3IRUtttH1sM1d3y3M=; b=FlvZFI4They5yDNcDuscGxw+HzVRMC9qN
	qgOsEmtTitGxzdRdug113PQvfpNsNngfAs3FoKux+gsWG/gXY3MgKI0LVn5gLiP3
	NENnCDpo1NNaK8ZHcXAGMwq1nlAcN/6q0ZicuGk9/OKUHnfSqrC6m/DfUP5e8hvm
	ABwDNa65UQH5PT01BCAemK/y23HP79wL6VjOs8jObMp90zo6gLYBpgVWxcV68Rd+
	wyWDlgk3SI9xblKKEvaaCxD9mvyM0OUkHEgQahi5CvlsYwtucRlE4noI56pGznLo
	+w3w+B0Pu1kfjqguxHn8B18VV1ikZYdcdY/kiAE1ubFqnepWWRdzg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcywa97b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A4tHmn021172;
	Tue, 10 Mar 2026 09:51:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4crxbsrph6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9p4FI56688916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:51:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A38DF20063;
	Tue, 10 Mar 2026 09:51:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA13E2004E;
	Tue, 10 Mar 2026 09:51:01 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:51:01 +0000 (GMT)
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
Subject: [PATCH 10/13] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Tue, 10 Mar 2026 15:19:28 +0530
Message-ID: <cca7aee2b9ed290ed1ac231edf2c9451e01ca204.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfXygS2p1Kkg1bG
 hHGEXUK1/UjYivd1szjg2katoa1cdUwnDsTg2aAJh8CBFACresYXf48n3FG162Nlrd8dlejXhfh
 SdnS3KSgldLr9OyExmy99NbzUT561MvTaCNlaVexqh5oiPX8JEoh1tJp9xx8LHnovk3otp1i/SY
 f470vjA3gc+D72698RPhdcbca4tsWAqsBe2RoeRdWqGcv2vpscyGnfiPY+Z287WXxKIraYoAsww
 U+nJO6kP0h1mbmkI6o0DgLsKosrjHSrEYo4J+qeqXtUXE6WOdbSNdjUFJZHC4v6TRXtK+oLY2g5
 MlJH6EZtOnUyu3jZr7kdmKE1NOeifv8Jr1gUf6WJROKA5wGBbPFiR0BYMbBAtBUxPC6+FbckSpR
 BrbtOWHtkMUjtWwLKlbApflbaq0aMSebpZ1oqbitDCYau6nNJBL26uYbX3gyaQFRqqFwOnrOm3E
 ISOXrTNCqPNoGkEOMxg==
X-Authority-Analysis: v=2.4 cv=QaVrf8bv c=1 sm=1 tr=0 ts=69afe98b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=V6oyBhSSS-FQw5HbkikA:9
X-Proofpoint-GUID: YptssC6h6Ysu7Glg9aAtBwdgq2C3EAl7
X-Proofpoint-ORIG-GUID: 3i5EBni61NJmMd5L2a8HAKqPe2kPIO1C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFA581C0005
X-Stat-Signature: w7tddddxp6ykftpejqtr7iwfd43curbj
X-Rspam-User: 
X-HE-Tag: 1773136274-316899
X-HE-Meta: U2FsdGVkX194uvnelRh0Rwk4ZiVL+ZACRyGsrm3o9LOdh5KGGrDQ2LonEGrsH0h4x8hILJUgZ6rNYO3GPvVvS+n7/OkFtl9Ad4sgeGYFfAhvvwu7jGqnpAp9n9MpMVIape3g+FBt5Gcw2oiHFelQoi1ZJ3Hn65l7SxmbVc6r9WEdVoLVmbBe2CAuvRgaKr0zTqeDeJ1jrOtiwpvVZBD28BRm9q+QPy0ORiomeJzB5UuWg3asClym1oyGx7XY1HIVnOVmOxEB2JIWekAMiC4PRlX+vwkk2mLFIj6IM7eDBm6fA5UmbbImEKkdjyg6cHTiEDlVX5lmyooN4ahE564r/O17x+2kR3YSw6LLSiLRijpotDfvfVGh3/zR+208fPQHcfKRuCZwa87bSsaBb7gsDqit9ASmI5kA2d9gxyJ/kqr1akad1yWP18b9NZMrGaZJoaSZNKqFK/ZRRVZJuv+Bszb7FaJQscVnKSq8XXLzEM+3khNedz96MJWSFsbNloXGSX3+4G0t50UaDiVnQ5t8gGXjrbP6r1Gj4abYEn4LpgStlbirrlPdB3A1/JBb8jO38MbqrEp8kj4mT1zvlWY8ArX0Bp3/ytiF1afG2wSuHT8+KwXJT42zEhwfPwQdrsH3etJcsZzF+w66TDhAPVRxevXP6c2KNEXgKpGMoO3oswD3fbOUCnwDiA1UlHorAwTENJzfaCci48CucJowK1PdcHV2FQWkmLdG5EdAjYEgw+EJgJR05YqpQb6hIo+8uOgF8bL4bqT4VUmKxvB53L0q98hkoiTcCnUnaGxxnSY/GTyDf5rTVE+1r0Nw3RwB8h45uWodnVDFgDB3R2cWtgPdr5P+yseyGzrYfN+S2Vi7u4+iebojG4H++sEiYWME4vp8omroLy8oe+qeMTJu9quRJ1lzjhPwwJXQ4mluUoIprEvL+QaLObNBPSfMuNmsd1AuJ/sL3+Ty3boNkbg5Xbz
 hs4YLi3k
 zDIlFUX3Gpn2qVazUwu5tEMuYJHShRfKhx2fbUAzVGF9yv2kttEZeiwMkh7sCLKlcfmJn8N0wllVaj+OoxA+hun/ykJ4ZXJ1LrkCQO90fUH0sCelGT4D5wxUMc9GBeUrTK5sg7WVsqICXDcATemR60v36en4UQ9rc0H94nT/W3BQswj4+7wLMvpV9kmCmN9xKRKV/srK2oTLr0whhi05wmaNoNQVPqJllkd5Jo+9jDjzqYOt1gau3J9R8MLPLPhJtjT96MZoZUe0JoQeUg2urEeejkO/cT0vX73jaA7LuCk0pb4o3x+DznPWfDQmZX+2ts6YO7j7maUJ8HMGWEqulfqYjmIzH9tnsglsZbAm5g4M4gghMDCxOE8kWwcu73A6WuB2X5gLY+/00CMkeqcwfwCxN5g3fwElVrDbu
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


