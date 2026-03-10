Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF2CF3C27D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8334B6B009E; Tue, 10 Mar 2026 05:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEDD6B00A0; Tue, 10 Mar 2026 05:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7F16B00A1; Tue, 10 Mar 2026 05:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39ACF6B009E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:51:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFAA31B820C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:18 +0000 (UTC)
X-FDA: 84529685436.19.9D04809
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5575C0003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="l/QIJccT";
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEIPjtg9gWEbVKB/YcF/D7E+rwK4lFNKPSL1ENPVeB0=;
	b=Ri9JoLA04JQmIoxuJRmfCPuOqEWi7Wn2d4lgwuJ6mm04Z4QA0Bdpe+ewZAewQQEEC/Jd4E
	0o4tfjj3uY1r4sj2xW9k+84RKSch2NqmrTgeIoCD+YSRAzyVQlNX9wS3O1t1ATFwjh3Spp
	LZ3tQLO18yiCwoS/4EeL7TbbefdJtKQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="l/QIJccT";
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136276; a=rsa-sha256;
	cv=none;
	b=QFSsSvRcbCNUQGGKkyqEKEzwO17tSfNi0TIXUBx7HmHCMFJ8u/EpsZ96mZBbL36k5lwcDu
	0XMZ9J1Zhb7YbRNmTMn8shWivFsTnBv1BYIMSESLRFbeusUuYF5ARpFu7BFLMGJd0cjs5A
	aiiPiOksGgrrUF1xei6LKbG6a/ATGsk=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9jOl51527158;
	Tue, 10 Mar 2026 09:51:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CEIPjtg9gWEbVKB/Y
	cF/D7E+rwK4lFNKPSL1ENPVeB0=; b=l/QIJccToUTlkUvQ7YzQ8+MfV7GA+vmCJ
	3K7lV1/LU5b4Z2Nwi1G59oL/iq9DoVfMmNg7ZihCtJ07fYqYpkkBzsI4PnU0+RBs
	AJiemloCxZFrHfxwhCRo34evbtMaeBxnHpVpUJcGiriniS9lD0AThXE7G/oFXlD8
	oPh6mXBj/oiQA7I0ImTDOOFLzWlNfp15y9Likg9zR11pxFYDo7Nv0rseS3Uw1mO1
	bDNzWgnI8mwXBfRoj3N4kKwUHMhCl5atfzxhzkwWVTSuB1D24dFaThKZ5Klj/l0+
	rR7E4U4JmeUL/FlX9lWUq/wgEhga2udtbP8vlj89S/C/c0uTHdLmA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcun9ygn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:10 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A7K7Od024657;
	Tue, 10 Mar 2026 09:51:09 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs0jk0chq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9p7Fh48103760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:51:07 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA60F20043;
	Tue, 10 Mar 2026 09:51:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10C692004E;
	Tue, 10 Mar 2026 09:51:05 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:51:04 +0000 (GMT)
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
Subject: [PATCH 11/13] selftests/mm: fix double increment in linked list cleanup in compaction_test
Date: Tue, 10 Mar 2026 15:19:29 +0530
Message-ID: <00fdaa3c84427958f51eaefa7603094a090fcebc.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: kixY2zL5yaEAA-mD1ndaixXgGIqUzKp5
X-Authority-Analysis: v=2.4 cv=Hp172kTS c=1 sm=1 tr=0 ts=69afe98f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=kdAlEqw6soqvCZangacA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX17VkN1Q7r02q
 jQ+WosVzNNvXYvzljn437YUOvwzbMVuF1NDDeDd+NHx/NL+Dk8Fr4pZGko8Ehad1ZnUP6SXCTtK
 +vsLDtyZD0auZ+dauHzB77mfUM4cc5EG35+BFdOGkZC7cJL2uuCePtaAJfjd57w9K49OIzIZwxz
 5I//WGZuORXbz2XMhNbbvfHqrKXrYcu2fmIcPKEcM+sfNfujxhvGTMEIYUxn8A8aeP0qmfPwBaM
 VJxLeqJaLk8lRvpC1ODvcqvSVAdojmjC6IDASLrj1ufuE2aAaI0yqzirmR7By33wpOPBv8NdhJe
 COjlD1MsCopFJQ5uVwF3gChuZY2dGxCpO8nfUdwEoCG1HVkAdfoO2C6puxKBJFPANDhARwdfAHu
 mFQp8rGT9fi9Hgub1FPbtxQ5PMvV4RzKZOX/Vv3+FQHWu24QSW4POdnNBc5HUk7M0v31EktwAWp
 k5hZmCo9PJRASEeWBjA==
X-Proofpoint-ORIG-GUID: 5P0GG_ESkEJ6a8EgrkO8kdbULkt_VrU0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Stat-Signature: unwj4kp84uyuhmj978dan8rwzu7xhogt
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B5575C0003
X-HE-Tag: 1773136276-274344
X-HE-Meta: U2FsdGVkX19SFXg/70iyenbnxjJQsKka7yEeOei3vrVPW91VLDfHy7moA5Zvm/kgYdPfNxnkbd6FxqRpoOHeG4i1my4+2uNypudy7SZi8GxUt4NZzUJAjE9jEP0quv2BMHJl8DIMJsal0dGpmgcW0UjTRt5+qlALBgn+npVnPGr/WA4kPbzd7MXMmh+/Kut31MLe9nloiSH4jz3L19LHOj8/TfiT+stRHn5zD8qzwF4LYnXihONqnHt6DQWBLUADyiJOmb1kGY5AybSogbIy+UhC+4cayBsyWtgZYAnrUC3c8YlU0BHXNZcVZ0RMMnzmhtneKbXLjpilkfGqjdGZYRIfe55Zt7Z6410gcR8wWsg/vQ9dYupoIXmlVosYnhYF3zYLkgyBctEeMMhwf+qwkVX0AsmPVOixP5Gx7vJd2cRnP1CHYxo8H5tAt1YhnAiPl8mi0nMN8Boo3TFl4jQcZOjcOopxYQfBc0ANMehq2pk9Ky0Vpd6cRaHVz7dUbqYAc7+hVato9wdo+6vLi/UifuKMsKzAVWFtASQGXBEu+p3nxe/4zS5Da3qtkBMTcusB0MNCtDGiLz2J/JpK5BcMtWpddYTVaHMBEYdgdwCTc9bUD96+E4+gZHu3kLueguUMgfxHnzKBJkUxrd10IMn2nnAuUP6xZ43FL/lvNxUvbV2mtmo+4a25mPrOD44/M6IeP53GnynlFEdGHRLvb3CRgGWYD+yYSmCNcvQSWW9a0vA4JU0VJIV9SqQ8csukPVvC6/bjgQFXboK6pqayBZtl2FMnOWfpGR0H/0fu9F69CCO10CSX3ECvZdo6t2yZ1KCBhEyYrMCC5UrOMQvt+fB/5OntA8z3dZL2TS/gqqTIeGLwC2WiAWDEt3Cd43uVWtq+RQkjl99BwrjqmTJFGn9lQUj6vAZ55MMoQ8Q0qr1KaFuORF1R1SmPQODmLlFb4Z5pmihOLNbld77mt7eEQln
 pUhkQ/00
 t/KTpDZFCQwliOyOYZx1aTvLYtheQ1mKkRVJ7Cb3DMLFHV8KG3HEduQK1UjWOwgdK7rN1EGUAJfs0IgUz9JZSeKWDMshCrODXZ1wJEOyftO+G/J1uTC0kmZRktwXwrriD40cEYWBpOG13we/cEb3IERt5O16D5FC3yWz6hvd8vg7dp+IPNaVgH51+6j27E2xNYFfWSi3EEyume1p3rTJFArjJUIlG+tETSs9Xv9PIyxj50W9eg95m1KJ4qgnh4MgaqS3937fmsdjBirCKtT6hz1aRSBHngzaHd2UFZH3iWrWXeGYxY7eE71fPNhyuWd1i492rYUr+K1uix3u+cPfviHZU73M5d0NdYWWYNuyz8HSY/Cwr2EYdhZYh2a+aazPe3F92XuA+z2x2syW+8vZHKNVbqMC8lgPUNqpq
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


