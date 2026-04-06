Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4945CEF4EC2
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2827E6B009E; Mon,  6 Apr 2026 05:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259FD6B009F; Mon,  6 Apr 2026 05:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC466B00A0; Mon,  6 Apr 2026 05:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E651C6B009E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4B54140374
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:53 +0000 (UTC)
X-FDA: 84627586386.04.DB52439
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id 76B081A0003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="NY/AE8em";
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBqdS5nVcWPMjB8CEBH752E10Mp8905KEGmdHXqnGYM=;
	b=UND0jwuH4j+Ja7i5qB3Xz7tQA95mIvF89W0JEY4MIUeIaUl42ib1r6p39/iSfb8zXSUs/6
	BEZFJP2DdDKIt/eXA0FQKmeebfeB+WUwiqEAAh5oIw2mfE6oSc+WC9W4+Jv5iOrLsEeboX
	TU2myCA/fV7O6iPtavjZmOWqQtqtMio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467251; a=rsa-sha256;
	cv=none;
	b=iPQnSWtOIp4eEPOxFJNDDengsUIiPLdGFephiBm29OKa+aU93m1+V+0OriGFRvwtw15JRZ
	JnVqURjThIdDisM4t2g/mTHz6r/jqnOkI4bJ4hWjqFfMusB4WJBPxBixCgwWp2GGbS22wM
	TKW9io89/NdsYssiL2ExLq5O9Lw6v+k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="NY/AE8em";
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635MdY2g4037439;
	Mon, 6 Apr 2026 09:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pBqdS5nVcWPMjB8CE
	BH752E10Mp8905KEGmdHXqnGYM=; b=NY/AE8emcXIDAWqeHGkVPFPvm8XooucK4
	V1qEeyPnF8vCnKLZqKkDv6bXPcYavYjcfiLRv3VpImxYeucHkimhQ90fwNS0tv8Q
	pRu8H7eq67Eabw67wy4ksdQaHIsKqqwmcLwDltxdh4TzI5XeSzo+T1n58MZtjQHK
	oZKRqUL4SPKtHS6hCw9x7vNSoFqB4Jnbp+uHZNYM0yH/m8JcO3om9j3XvBbPorQp
	0pYdVlQR7KvZVzOGwOLzj0tjssDispGfqUYoJDNxq/rNi8Z/qFQ6VvTAZ6uAQ6pj
	6g338AkAK1htk+nqbEag8m+grhRT4/hj+cPdkp/77cYy2qXOdOR+Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dat51wxka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:40 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6366GArt022945;
	Mon, 6 Apr 2026 09:20:39 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbefkc0xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369KYdG38928832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D602A20043;
	Mon,  6 Apr 2026 09:20:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54F5E20040;
	Mon,  6 Apr 2026 09:20:31 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:31 +0000 (GMT)
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
Subject: [PATCH v4 14/15] selftests/mm: clarify alternate unmapping in compaction_test
Date: Mon,  6 Apr 2026 14:49:33 +0530
Message-ID: <e6ca6066c0869cf58c6fbef59ea2d35547cabc6d.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=J6anLQnS c=1 sm=1 tr=0 ts=69d37ae8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=drp7DlKwS4wFpybDI60A:9
 a=ZXulRonScM0A:10
X-Proofpoint-GUID: mqojUT3DmpMioyJHmt3KvQPAQkRaaDlZ
X-Proofpoint-ORIG-GUID: 19LRlPIFPDuzkGxRK8_l-LF11lGhtkKQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX+PdhhPBXeUrs
 qBNQXlMPWA7f+tki8SwCHi0vHgFWvjAfcpSle1z5ZP1KDPAUWDlg5SgWZ7wbFYsdU/+gWK0VcvV
 IFy1h0aOUJDUWdxWWFPr1yzctgBz4EwK/RG6NcsBvgVpz93sHj8TlR8zd4Rb3bF0jJG0SIFrt9U
 v8W2iOl0cWTVeJe6lGqk9ZUU1boNY0AuVnOGnFSCOJExDBpa/3nhQw3YiHbfwXq8YCElnM1lmlL
 S3yyxZ8B0MstX/W3MxydYGEF6+I5M1XuO0SfcNzw1qFvcRDXsoItXOXsZonVbApwQ9F8uqSa1UZ
 O+hgfGnaep5cUGVoFIDEaNOh4X+HSGOuN+yiPmkc8dIq5rW5qgvDRRnjZxbekWbQ3WYPi/CVUqC
 qRXhR62Xf6pIR9wkk2BNywoIP3rYj9FJHxcpBwNX4sDDwlMpjN4qkVr/p8KUhSCKMzNV27vecMs
 3MY/qLyDnwO96lTT4QQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Server: rspam12
X-Stat-Signature: pcryy1je7hng65p964syszhdxpphmca4
X-Rspamd-Queue-Id: 76B081A0003
X-Rspam-User: 
X-HE-Tag: 1775467251-54696
X-HE-Meta: U2FsdGVkX1+QdRRT/L8IXqA6N1rACrWMpMCe9e0eWVKETU+56iygrwp31Qf5Jp7cJ2o8mghyLNnfvtmI50AeqfuWavKnMxYBCA29bM9in4Om+qATFNkuFVqzkRsHlM6hqBZ97+cWJniVTv5Y/Je5qBWmSOFBZDm10sSUVggQkfWW8ra0EOVio1oNQh/67Msv8+xkzUEtZLm7Fw5dfyj4MCmhVtyaOmgD6YfmLDBPOkH289rg8Lbg7l3vJhWxTtexyKmWk2fcn36WNyQ2zU7SWM2ffGkX6rQyBS7i5yK96u+YwmgI0HmY3WBV5285qyTF8Tr8wYJxSPwAxk3zbp0KAADlL5XQZAgVvkqYF+gLj7AOxEDfpRywhQF8ae8vAoIQxM5K9tsfTLO7khSJy6MMJ8hs9wU5mSN00XMKa6hfHAVibzFjIGvv+WIHxpo+geyvSo0YCiGN0yDnOxh+6hrkWYcC/y/m75NgMDORDAyxJ9EtSkgtMs2c8unrzu2w2JTQxfBsBP79PoluofqPVF5jpWvkmUjIc6/UajHTHqs5J0QTbG2rDIfMeUJp7C+5lETsSu/zDSZVI6CFSHlyJVsvp9bVzsCwmw498ycgwHCfdPiTh7mJBZTNuF6z058NznK6mtztr0Is28j6h5MNWhhydGWbDVdHpEcGp3MMCkRkscJj30CD3YchuuSZEFC1o4cf1HXsD1i1n/brdov6LspWMBOXeINie31jzC17NCVccweSF11iqPIwxYwpLYTAt/0nlobwRify6+UzsT02kbjPnzxuBSMN+pePN2oAnf9H4Vzcw7IaOA60fZyh5CgeuQVcr8DFMF9KzZvVssZf3xlP2JqfLPTCaQCIW/QhUjLV5f1zMUX1LKS/FBfPUPwNN4rkpBHeLPi35uv87LvceXC3Bs7HiH7O1uJmaV8HZQT5+6DsATL1rDx6fPDcjimHaC2D9FsILWbpHUNvJHDISD3
 x3443UOD
 SCR3ULmcsEK/NTtQ=
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


