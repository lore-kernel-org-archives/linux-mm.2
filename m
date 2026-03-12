Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74ABE105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D670B6B00AF; Thu, 12 Mar 2026 08:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D976B00B1; Thu, 12 Mar 2026 08:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D0C6B00B2; Thu, 12 Mar 2026 08:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF8AD6B00AF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BD68B6871
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:49 +0000 (UTC)
X-FDA: 84537334938.06.A18396B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21F77C0003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RAsHUWSF;
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3YfUvPq9GnEF03e//oW7XV7MlglEUe+yZMq58KUZvE=;
	b=m1D9EsAFImdhLVTTuvtMnq7/ivSSNQA7qupkvT0fBaja6VOUdNr4AsHSrOF57l/uLvT+FF
	S6QQlAX/m/TRNzK+v9z95Z8ALa5F2DiUEEE2//6ccD0Mzg8br40DqpZObpSTSOmFWTIj3G
	YuS0CK5hgfRMgQD8FXvm4LaeQBuMQ20=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RAsHUWSF;
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318407; a=rsa-sha256;
	cv=none;
	b=6nhYax+8GO73N/Vm450DOf6XA/oLay7JsL0FFbWW/MobGNC4mjMN7G8sH41wd/Nd1dSZlz
	x/1Qa/fjQVeTmbihfq4p/c27Mx0yRPhxBBOJxHXt2pr6p6LkBhKxs7KBSoRIvLcZLXk8uX
	thJExJlWS4glFRWWRv8St8XqG5Tj/lc=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62C3SiXO2853554;
	Thu, 12 Mar 2026 12:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=M3YfUvPq9GnEF03e/
	/oW7XV7MlglEUe+yZMq58KUZvE=; b=RAsHUWSF664dK0XGfrxWC9SizSsomr1ql
	mZvX688RLJ/n2zPbrhVrAn5mhcggKMzF2N6gZwjQbu/ynXwij5Xb6G4okM9N/0iz
	7ou38QksMTGhWfWUW7w1MuvLaYIt7ksXKQFjVSvAWpjnI8RnKpN3oxBdk86urNgA
	UvqAxWDXnopUAaM2z+EXpNGdOW2UmOSvvYMu7dXBww0WzMWg4DCwCJ47bfIElkRl
	hERfFDnsSmRsTb2bxFw3BU5Mmb0KTYfygBBTz+AbYgimyjcSfoGc5zS5/jm8SwCf
	HwIhD7J4xf42UCIRUb6s5XKp71G2zIxzvu6plYKQOeyERYyZGDywA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh91jm2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9eOSM006036;
	Thu, 12 Mar 2026 12:26:40 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha9j8uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:40 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQcJh52298104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFFA82005A;
	Thu, 12 Mar 2026 12:26:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A285F2004F;
	Thu, 12 Mar 2026 12:26:35 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:35 +0000 (GMT)
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
Subject: [PATCH v2 11/13] selftests/mm: fix double increment in linked list cleanup in compaction_test
Date: Thu, 12 Mar 2026 17:55:38 +0530
Message-ID: <27390ade4251d1f7f6b846bd5836fa79dbf285df.1773305678.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 42Oz-_cQwFioyKpAa08DKyO7c4l3zeC1
X-Authority-Analysis: v=2.4 cv=E6/AZKdl c=1 sm=1 tr=0 ts=69b2b102 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=gsDyKvM7SmIWZGbsndUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfX/HkvvqsILRtu
 mjcdFdzQSxKSsIdKHD37n3PlPS3kT1CaDo6o17EulQHQBZCBYhGDafWxxKgMxDTH6M94fB3nZdl
 m8BEzrT5cOz2aFK5HWZfhWF3C6f+qk5xNfrHcxaC+ADgR1kpTAwuOAghIG9fWxyZi1Ik2umEL/i
 E5WdxtZbNNu+Ix8q9RlJpGR+VKpGDS73e4zYtcNhhtIYXiLkdGKE7ZayXy2ghTtBXDTIYH9eKie
 vm/rODWK3L/GwlgoW817S2/8iNSJ+bOmRnlIUVb3rGJKTD6f+KyxFOU2CkKk7/x9bT3S/TNZzAU
 AcOBf8gR1rYg/uemZ9BWHWyPl2Me8cg28sQuT1rDtNaY1Is/5/MNhcq09dH41sSg+BMo16hn2in
 rcpoB67+f68/0Srf7SP/zJShSu8vejtEwLCEvRfjVARh1onNKYqUfS9IhJr7v7IKjlt7bNzK51t
 2K/AjH0Es6ZG+dII6aA==
X-Proofpoint-ORIG-GUID: k10TzA5FDebAP7Xwbb7fqXyCyy-39Pu6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120095
X-Rspamd-Queue-Id: 21F77C0003
X-Stat-Signature: d4b1ozrb1x78geawtfcynzne7kqkuzer
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773318406-246499
X-HE-Meta: U2FsdGVkX1/ty1mUHfdkJ0DWh8EjIkjV9LN9gHB1areKnr+Ozwus8K0qK1hZgLX/5etJr8KcLJme3LCcrvFdXOpkCtVUBxcdCZ/7vZBhowi5bdhy3vbY7EghZ/GyF7MiwB8+p1hipT4iBmhawNHUh3mK0es55DebS7r6ZJvvyhfi7qD9rxwX+YHkm3wMpn0nltLpIS4c/DtypEV6hae18RNnRjzczovYujuHYSg0IdOE7PBcNN/Lb6Ce3lelMV6KC9KTy6zygX3IPTDG2D5udJtGPVh8p6TZJf2OjcinWy6N0JLEOtgGgYoQcfLJtBYzDUj78Zy9wc39d/dlzRewTGGePO6eN1XbSXjJw2M8y6bAt68eWsDBDPMsZPOvgoojTcYLrEUYacpRnD+lv+Cj9EDdlKBOf/ErExEfxbadw+bRThSiahRGzy3pS5M9OAOfaLHnGXfiqTy/RQk7p62IGePRt72bLw7E5hpLmzcZSLLMHCLAhPYsZQZ8uSLDStF3AlXx9jWyQSKXJ9yIhp9LYH0DYHGPZYEsQMK8k1ytSSL8jysPQwXmQLSgN8usUwc30Z6JPpIn8FbPnQQTzT060fgRElAFh+cibUgxOhfAyYvVmze8kTBVbwb4/dvYRFA4TRbTBlQb4cyYSlHjsAQkViGLVanWLzIBU+a0d1SAygokB+H48nqtKWwUPA9qKXAdfp2gQeILTJAK1RcYUC7IZ0SwY0pxPxLaoHOC5zaaI5KJK1jp0/+YFPkgSpsgoZw8Lbwqeq0IoWIdRbttbIfFh7NTWvi4Biq536/3LuBLTn+c1jV9Z+XGbUsj+4jGyHw1kG/KTzYbDfXQr/T0BHGTQRgYto1WrS4MeazBWFANFpxctmVMaB6HqRCJoxeOuscfh4L7A9M3+SqaUW6q/v9bLGy9KxhLv3dmAOSRtJkcFSAvfJmFtOgOxv2Rooom/3fPAgxl24zMAQr1QgYZ8ch
 U+wxruHC
 CKG2QA02mCLliqjM7zJs/lh4VgN6W7Ng23P9+8Lf4ItBZ7SM9X4BbMGwwzvXLhUac9nGhYOBYNgPSEYvhDw2st3DTR5brNtWTaRmCLqXW7HdWjUV5HYjWHejayHKBvp+3DcWP9IrJnk+SAGn/3Gf3RnSOCiMTGdvpl9Orig/NbNMo+Md1uVOBygrcWcoxPXUWiCeEnrtqK0ZgRPhxnmqkA47LsyIFDVawVYlIu6PKkZo5VAeCDgOwLNRv80jgxsxFxm0b+NT7NF7k03+vm1th+8vrAOxUAAteAhhGS1ITWO1w4KRB73tJb2pSN6Y6hOiywGe19sIv1/livEV5dE02OXUYXIsK/8vbkUnGtw7o8c1E8W+VsVPquRhmcmZJx1N10wDStN11lerlMm6g4R/nZDR0sF/fFJJPy3zCccWxB3847a930It/rqNHZQ==
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


