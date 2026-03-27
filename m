Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCB410BA436
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89EB6B00DB; Fri, 27 Mar 2026 03:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A606B00DC; Fri, 27 Mar 2026 03:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBF56B00DD; Fri, 27 Mar 2026 03:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2A976B00DB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:18:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72A41140CAE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:18:09 +0000 (UTC)
X-FDA: 84590989098.01.4E4B8E0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3602C40002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:18:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BYxrlnVK;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyW8Ofkx1HMBiOmnF55yEU4eXpZIIJ4PDZKxrukkoAA=;
	b=Lcx7jJVQfT//09RpsyfqfvXIqBzDQuWznp5exxEUze5nSQMeAEJMSWdUaFHFoWIrLzALPD
	SKOkF0a9wQrjt2A+qhw3KzcGPqRqrGMEQSFsQLf7XTKY+lvPq5NjMfpOuytz7yZFrodToX
	1z23VDrnZW9ggQqXchtffwO0VqvEz7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595887; a=rsa-sha256;
	cv=none;
	b=sboWYj3rU7d6buTPvIf1/EszUQ+ZGgAhmQZe8YvXUNOWnjABYhnu3e9bKLUKFv+OVoqKZC
	PvBYXYnIvVKIaen5RsQc3zEzwz7jYhOSZ4f/JPG9lql6TuLwPYtSOoBO8fiSR3bOJkznQp
	vtOT5oQUSJSxT5qv+m2wXeJV8Q6+U2Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BYxrlnVK;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R3uxVh369072;
	Fri, 27 Mar 2026 07:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UyW8Ofkx1HMBiOmnF
	55yEU4eXpZIIJ4PDZKxrukkoAA=; b=BYxrlnVK3JKlcYC3LRCGTSJdjJa0UxpcF
	wXPy7FK2AhLskhS53FN0ulfLURw0ue4+hoIyvTkS1mV4jy395T+y4cX4KztfRPzM
	hli7pkTz7a8bN0jwqOuC+m2F06oFIxb44mDMkNtxoIIqe5yjfzINA9fjoYc81zN2
	01IzwhoJfDfA6wgjY7jP5cDh9Rq72aKVw7RUGHavClBZ9WbTDcH1YK+tGPg7KCAu
	IJoG7qNwznoYBfHI8og6gNjom11kJuupjrL3/rSiCIow69azXzch0EGeCfUvQoxS
	w91uGP4LxB8d28q6kBJXqwnJIhoCV9b6xrTf4zQHOkGQYx8U2zWTA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ky0fs9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:18:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R6RsMW011824;
	Fri, 27 Mar 2026 07:18:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d27vkeacv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:18:01 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HvVS29688084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C78482004E;
	Fri, 27 Mar 2026 07:17:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3848E20040;
	Fri, 27 Mar 2026 07:17:54 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:53 +0000 (GMT)
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
Subject: [PATCH v3 11/13] selftests/mm: fix double increment in linked list cleanup in compaction_test
Date: Fri, 27 Mar 2026 12:46:05 +0530
Message-ID: <4c47a2ebbc41f90c7a0cb3f8b34106b2b64296f6.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfX2QyYexAWl5Vx
 PPRqvI8V2jqmIQLEsoRSC/KV7cvNfncS2dbJz4+hNSiMMWZG5JqrM61MLyRdVS1tCKZgxRusfEG
 ZJCDS2imHTWqYxLnOuwBxM5XQw3/EZMFNkISwdKZIxzKQl/26dMw/r53SfzGhqZUK2HatAsXbRf
 LSOEitRk5tAJuW1EFliucYWBV3vLVvVVWZ58AtkMeh7A8QXo0vIonAG8ioe6/J2lM6oLPJTxw2Y
 6OyZXP1+0ZuCeeY8dy5hQ2rkQqVFYoWk73sHBFUCD/XWFy/hBYeGSlq+EPxh+mq1plKx3f6VrRw
 hl4+dcyDcWNmUxXPzan71NL/Apasgvn2NvAJi1p7nJFXqYMYu6PrjdTpt1eiitlVHaTT/G5CpO4
 voAghzmffvGF0zG0ZikKEJwns2jq2ln5J2WAFZbjkThSSZ/8OVxVA1/GWXKMGgXcbQ7jV3Ksc0r
 Z1PIehmPWT6/En8P/pg==
X-Authority-Analysis: v=2.4 cv=JK42csKb c=1 sm=1 tr=0 ts=69c62f2a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=MZMhi0B3OYeqIO-B2KAA:9
X-Proofpoint-ORIG-GUID: a4cP-qB6RQC6j627j8QHJ5lZ5IjZP2cH
X-Proofpoint-GUID: Qco1Z-Qc9pxkMdF_tJ-zhBZgAnK-HINy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Rspamd-Queue-Id: 3602C40002
X-Stat-Signature: 7t3u3oofpwphxzd9uyb9hwgccntuqbpz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774595887-389020
X-HE-Meta: U2FsdGVkX18l9KkO26CNk354nUMJL6IE3wCMXZ/7oenkNUdcptfT2u6foPzTpCR0g23JLmO3vuptjYXDUZk1R7X6Ihylt55bYKULm7H84OO1OaqSRnpb1Pg6IZMVqoQUTvKfwL/iAysDKMsVFP3AHhL2XP6cTVSewLpfIiN02lcogNUotVTUdq19iaMJfh7w5AzGNZx5DrNA0zjsJOzIwflUmWL0Ev9ODkdfXGYpQkdgyTDj1Eueg9Gk1/50dWqyHjI7HpkdbjtL7o4f23O/2OG+qYfLXfqe3o1GDBTuy/U55gXshjGdQfn3Gu7Fcbbmu6CpmmIZK8II2+IxLHZWPBN4da5hBcCWKQJqGLA3KA524zXs+aB42t46RAi3Udwjmf2yVYFbhDY4e/GqJ76sqEWne9SThcNBAhyJd7+vCURzg/p54B9SALmtRPWq/DYLOvYiTEpCf5f/VWn4NC9LVgWHwHq7i5rR0KzKVVg76cWzc8GaCI7PBhAxw381CAothSM034SwmJwxe7Z6groCnUHaFS1BlXdsexfRZRDhAZHFcuPnUp7oIEpI74M764TAbhV+0Xk5RXzbdmqAsfmeaebz0oF0AOsEIck89rh3JN8TMXaHoN9o7wLBoX7+TyA4sw3Hz+bw71ypQtYgPhee4yac/HbyHrwIx724YplLfSvEKWfB5VXabj5mwSQL9laWcLzSW6PbapqvMtSFygDIsUy90X+e5DUtuuWDu6xzB6wxrTrR2O+yE2rKdXECR2bbEEtfSu5rphotq14kmFvrgUMNsb2siR4AFbGdS93UvtSEIfb6rSwN6AFcOokDeRgFBMeI7CRvXEsmetgtG10KQAFxBvErBFNVXyAR6fezlvGvn4S+ET7YIxzzgUjNZmUnLSTp5T9QKY1mqBDSGsAautWsEaamg5efEgoQkZOVbXheN63JYmceMaVb+o3LvRvjA0Xl/9G4IAQdRsSnedv
 WthbeeD5
 jhQTX2zGePsCLpjJgdMqh1bUUEKJUZ2iL9vE5cqqz1OrzLmtq5EaMLwl8IU4XUtmLzf1E/+9hTmfRLW6Ez5q54Mn/kawqT07IusLk4jK/+e9PIyB38p/u7u2iYZTi92nX4tAHUK13oohb8fO4/ufKFU48wdY2V9Mc7aaDHZLbP6V7UOgp/oHIW1WUpLHa9VW9K5ff4yDROFuHNzKR1X5zJuVVlO/+3Au6+zFBktlPAtASAhz8+JoDXYC6VyeNSWV5houFjhKWWLJhrppkRyenMgYmbjGSWN2kRTzUag1/q12HTJVihhkNccGVUX1YaNBh+Hkd10JEZMdURY849yUcG3CadoWuUDkfDq72Xl88v6JAplR7xXconywNPozON28t0W71PFW980XsJWAP9bVcIfjAKRLqalXB9FPdNl7oA9582c8FRQDPhLlvrdOH+Q8T7xwKcPFvhhWO3mM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cleanup loop of allocated memory currently uses:

    for (entry = list; entry != NULL; entry = entry->next) {
        munmap(entry->map, MAP_SIZE);
        if (!entry->next)
            break;
        entry = entry->next;
    }

The inner entry = entry->next causes the loop to skip every
other node, resulting in only half of the mapped regions being
unmapped.

Remove the redundant increment to ensure every entry is visited
and unmapped during cleanup.

Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/compaction_test.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 30209c40b697..f73930706bd0 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -263,9 +263,6 @@ int main(int argc, char **argv)
 
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
-		if (!entry->next)
-			break;
-		entry = entry->next;
 	}
 
 	if (check_compaction(mem_free, hugepage_size,
-- 
2.52.0


