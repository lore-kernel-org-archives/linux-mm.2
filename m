Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F2FCD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF34E6B00A7; Mon,  4 May 2026 04:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCAC46B00A8; Mon,  4 May 2026 04:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1246B00A9; Mon,  4 May 2026 04:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0AD46B00A7
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:26:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 842A21402F8
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:26:11 +0000 (UTC)
X-FDA: 84729054942.22.61F6851
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3A44C10000D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:26:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kT4sH3qD;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcC4IMd/M46lcIebNKowLxjbupegKYGulhXVqQiEBho=;
	b=6nOuPUdMXYLj405PnzGjjoPqb50Rk4wIx7oP5VM66PflS0fE5Evw0URs2T7eR2xWGF8uQr
	gHdTJQCQ8n9Mb6YVQDNfY2zsRoHAi9DV67zCfZSvPyk9VFlN3JBtq4bDZmedFLDFFOsIrP
	xuLoRfrCVROp1HSCIT1JVL8KRTs9RKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883169; a=rsa-sha256;
	cv=none;
	b=T8VecGZRndSBA7e4p9zTQYqV9PswEaQkrMrcfgOjXT3Z5rmQp5SskI+j4TmYKKBrExi4+Y
	BWb5nOlFE/QfHJ+WSVXR9SlbYMZ/gXMlYCMpl1rwKXHCq0w+qmWCFIsvj0Nt/cOMH5SrD0
	nREELFXXyMY5ysb8NRh1PUWJPXcrzC8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kT4sH3qD;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643MHdXM3183452;
	Mon, 4 May 2026 08:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NcC4IMd/M46lcIebN
	KowLxjbupegKYGulhXVqQiEBho=; b=kT4sH3qDNqr9ym8uSr+D7AuOZV4svbNRC
	gDuNeglrVNlohx6N6XJ/nGY0/2ng62/4QowVGiuP0jfm2wIZIrsHIVjJ0sjgai1M
	PtcdYbtbtaGzo8cLcIOJ89LinMnV6lmXtrb947F+J0pr3cTkgqVZ7L7LvxxSM55N
	tQoWFpTi8Lq3cpY0L3rGb25x4/+oQB6Ery/UwhIa5X0pBNWfed8wF/6UiMOUlm7T
	NqgyhEwTvQPr4YxMY2Ok2RfLaL9X0uoypRGMt/7Fq6lM2CxiJ2GRsqgqYlI8xBg3
	77nRjNa4lm3xejiqpQoWPxvDAfpITQxcBj6HZzbR+vljj8/vMaPmg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w65y38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:58 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448ONKW023986;
	Mon, 4 May 2026 08:25:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtg45sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448Pswm56164802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:54 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F0502004B;
	Mon,  4 May 2026 08:25:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD10B20040;
	Mon,  4 May 2026 08:25:50 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:50 +0000 (GMT)
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
Subject: [PATCH v6 14/14] selftests/mm: clarify alternate unmapping in compaction_test
Date: Mon,  4 May 2026 13:54:51 +0530
Message-ID: <91e4eb8e0d0b5a27e166eca59fd7750fe6e34036.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69f85817 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=THlBPJCoSQ4NST9nLWYA:9
X-Proofpoint-ORIG-GUID: NLzTdpf4GZ06u0zeN4xQXz4pmJc3Vhf8
X-Proofpoint-GUID: XI43Xpx6JbIWOebeDXPu_gP1yG8Jtt__
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfXzeR7DZj7ckY4
 MVMDpR5ydZDuHjf1v2HKAR8lDUstiZJHgEQlpV0s0S008AbqZ1dzzXfN6+3CuclWl2lP3nEiYgn
 KuXJarWcVIckkLiufJZzW0pWLJko/pGkdIvfWwCiX3Ft4cvGrMMfKW7c1Yu4a8tOxAsNbJqk6f9
 2upAvtcmhJslkHXt6ElfhA/OtCtMxl6t2ma1CT/rHyZHp9b5bGjrIy42eQLrKwIClpo4u018gmg
 9azKG1A0qHNde/uL/yHUltBYVNWdVmJjp98Laxpgg//BE6ARTBo0rMKu1lURZBjB0Razeip/9Gq
 HhYv2H62eJtdGPlty125BeqO3N3Uw9j4ot3MhveEW72QFdijhe6qOT/tGpmymCoQa/jHXby9470
 8qyyE43eNOXXWozoznJw9r0o6iju+9vFW7jfrxVwQNKcRMSzmmIF/QgsTObN+OxVXGCjmHwZf1Q
 oZW8KLCqUjaKjJn65Cg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040087
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A44C10000D
X-Stat-Signature: rewtuq3nhfy8pb43y5d9jxim5nwssrpa
X-Rspam-User: 
X-HE-Tag: 1777883169-349606
X-HE-Meta: U2FsdGVkX1/F6l75jgUym/rKGpYmaUW5eQpMWqup0Bt6y6J+lG8OqtjkZL50i0l+u0dVW1ULCfz2NX6nP5EDEpCeIAPN0UnWZO0cAzXi4wWZSmFYyoxT7t55nEvVY+pJjTJWSIzVw2UcUTavg8K2LPOUjcEERh0eEzLbDRdF9b5VAAppOKrSn0wzZomF/+hIN2LaDZeAKgXEsFS07OCw5ytvBRYD++NEoBr1mVnTckq4u0Lp3OKTzOVzmWMFBR4CF6NPOoJ0G235vo7Z1UIFIwUriySBOLLC9hXxUibFvj2y4wJxYyw/i42JChegfAjAsGV1cQ1eHcORF3NDHFKdLm48GM5IOfOLidynjUAb7YvrPqkjHcetDAXgiV8wx1zqtIoB2FRCZcMUGqsQIpmiDrVr5gbmiJEuWo9o/hL6kttER3ne2t/SFv+FIwpn3BOqjC3YDXS7C+XOskm1Sq/ZAwl1qAQL+y4RnZra29jIiQCBAmEDU+mfXDt2ocWlxO9a4IcroxRZTuySaq5zqcGb25HiohNlEfhgdy9PQuR8QrlVOA5BcFFohvC5zf8VNJOrVGr2RyxMIMl0aqQfLRwaejiCemCKgaOcSVVM5oHo+VI9IoDFQYQICsCTNOA04svLZqZBFiX+7drPoOlWA7bqUGcdTuhHuvKBx6VyZXM4ZiBjjEGGtga9Pn/3Nh4gL6RTXHoPCkSLjWWww3j3whkEtdtL0jgWjqbl7lv1BqmptjyOa/2uSYeD6TvLS42PON/9GTmzv3L65Iq3fPSrfkYnKZ2oxMTpuwNbe65kkLDOrqP9NoJbpKZrEpsYLEbbjsLVwT427/S6mynO5xtUCRpMXR051Xu1pDV21I6Z9mEJV55U3jvUsi+SwElJd/rhxl28AKFefPfxdGgneZo8oe2lndy8WmCJ4V+zdgSh8qRhv36ZuyKuy3sUaBfJKAqnUc57YaMkGfW6TBc1HyEBap1
 /d7VUDi0
 8sHCi2Ht+u1Y0gnknsBdI3JULBiPbD0tQ9ILdyBjyo9RSeOx31HXj+O0lelbLXNS2gNv5y/zDypJ7U3QWXMBhQcNGnwIbsG5DGPAp1IYvxIsOHfDUNHNLY4Z9jCrzgMEAD0IZAelB5Jb0yokrMvG1+pHnzHiRwNbYfW3TYnG4OyK41ans8zEW9TqD7Ooh6Y8NyrLPH/NGF+TbWfOVOBinzBOfoTjxLg+Fn6jvPN+keQzjjpqexN7jWnFNftyn1C7cGyecGbeDoIKNzsw25aqGWwmP0u2jCMtz+kItEvEtPtfJCH/BV8XVSmN5kRaNYQax63WQdId94nz8S7TQMti+dwQ39ZmuXu97qYE0VU4/T3tSyRZdfG2HZsff2R3DExmjDh3KPPn0R4ZY9tBDA/06qXsVPu5Jc7ZDvYQz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a comment explaining that every other entry in the list is
unmapped to intentionally create fragmentation with
locked pages before invoking check_compaction().

Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/compaction_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 30209c40b697..e1610e2fbdf6 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -261,6 +261,9 @@ int main(int argc, char **argv)
 		mem_fragmentable_MB -= MAP_SIZE_MB;
 	}
 
+	/* Unmap every other entry in the list to create fragmentation with
+	 * locked pages before invoking check_compaction().
+	 */
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
 		if (!entry->next)
-- 
2.52.0


