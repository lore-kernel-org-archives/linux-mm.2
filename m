Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49659105A594
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF6E6B00A3; Thu, 12 Mar 2026 08:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59C56B00A5; Thu, 12 Mar 2026 08:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932076B00A6; Thu, 12 Mar 2026 08:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 814966B00A3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FD2913978C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:29 +0000 (UTC)
X-FDA: 84537334098.07.B2D11EB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id D1B75C0015
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="KNYT2/Rm";
	spf=pass (imf10.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjGqSi2qeZS0jr//OksiYi0l0c78Qgoy4P0z1IMFjGg=;
	b=KYr5wLVURjIQ9rhTIhzZ5SNVBgOzTx/a6venzjbWO4ygXABjc+KRMxqCfn8CGgzq4XdhII
	Vdo86UdgXBdpj1yDni4zW0u8z036yoOony/JXnNSnPvIEJqOCOJItgalHX6DbPNye2FSKT
	1SkGqXT+meyAxb60lSU4yXVmThOO39E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318387; a=rsa-sha256;
	cv=none;
	b=LNHfMhp4FQJeSZN6xgorGJ+kGovbo3Bt3CywclARehLyOpiu//BJUeIJBi+/YCTArISpQZ
	vHGX/RMEtc792IYnB0VAX3YLYKiJd+7lqESBQ+pA/HIQXWN6kRIbHj7Jzc9xm05egBoteS
	2rFtZ5XRnqOP6ldNcJAz5DJovyHy6nM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="KNYT2/Rm";
	spf=pass (imf10.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMWDuR2306667;
	Thu, 12 Mar 2026 12:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZjGqSi2qeZS0jr//O
	ksiYi0l0c78Qgoy4P0z1IMFjGg=; b=KNYT2/RmPMyq+HmukOJVbmNmoRkaLC2OO
	FcGudQWxSTnYA4GRCcIQ9x5Ct/WV8J4iPf3K07W0PY1RCZmRc+ELJgJPK1wRmk6d
	cqVe8YVdqqtR0HJ87JG5UzCNgc+2O0pnlgnYKagvtq7XZ5bnO0yHPomhMG5cHz/J
	jZXo/147Z95mCnYzWaIX6u+AArPydM5+e/UHlFJOWLfMh0N7PfRUvx/qLxVWgnIV
	4K8twNZc/ThygXe/z4wmtoIrAJ6Uhh9RiRG2yUCC1LVOcemOEzCz63OCHZvYCXIn
	llcpP8TTtTnjlmJc4zUQXJYFkiPuLEpDHAn45GP/H+ERzjcWAVahQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh96agta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:21 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9aRDh014797;
	Thu, 12 Mar 2026 12:26:21 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8a8rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQJ7q43712974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECEB32004F;
	Thu, 12 Mar 2026 12:26:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E85022004D;
	Thu, 12 Mar 2026 12:26:15 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:15 +0000 (GMT)
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
Subject: [PATCH v2 05/13] selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
Date: Thu, 12 Mar 2026 17:55:32 +0530
Message-ID: <94c18dd26cf88f10b4b496cb3de08d81439a8909.1773305677.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfX3aQhsvirouQL
 sLxYoZChXsZoC2ubR6c+B+HlrhZ3oXTkv8tGus32S9zu7Vum4H+eWQbG+ZZxym/d2Jw0BQ3Afhr
 G/r1lBa2gdmO1/Idw0bvNOxuHXwkYKySvcM6tQI0ShcvkMdhZd0Z75/ts02TjNQzBg0HTB5YlQz
 4cntdxhHnKq15LdPJQ4FSirU8iC6yBKKbc6tx374I+OUlIiCJLt4jK1BRzSUfc2ECZJB+t0kWli
 45M1Y51eh2u5ZkxPuUtdQnoWGDxLotvge87ToFUfTXa4h86K5DJ+gfiNHqewEMIoB6rv1QVWUF3
 MD5xqCelw6pxR6s+k4Nid+gi48tZg42MWj/rSzs+Kpxh/om/uE0j9at8/zQ0eN4LhzaphX9oeqo
 1Rbv7oIQGu43pLE8sSizudyeCVoBvKN6VRq8LSCEdSe2ts6O8rKDu4biIIg6WlgfiSfnHvOd/gR
 e4ho06Z01KerQi1d/sw==
X-Proofpoint-ORIG-GUID: 53sx8aNK62ilLh6kD_DjwEBbUJ4YR3QW
X-Authority-Analysis: v=2.4 cv=RLO+3oi+ c=1 sm=1 tr=0 ts=69b2b0ee cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=2DqBuDyFdJ_AORcY0zkA:9
X-Proofpoint-GUID: yxxACtQRrI0kzAt9OXrOCppiXWZt_nBS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120095
X-Stat-Signature: ftzbqrz6j4xc1anzumyk9szfo9cho1fg
X-Rspam-User: 
X-Rspamd-Queue-Id: D1B75C0015
X-Rspamd-Server: rspam12
X-HE-Tag: 1773318386-292512
X-HE-Meta: U2FsdGVkX19XQUj9h4gSTsULcc/tNdPxQ1msmQoJgWxnKCihIc5/FybQIadHH8ONVovY0yZj60VNYpy2gASAF4raZQ8tO1sS91IRDG7EUx2eWErXuiUgZzWNSPUdvtmW/ZJr49Z1FGcI2uqtd2AbEe6hyUF48ht2pwhVxFb89P80Be1fjqEZ+K/6xmiXeTTQZn5RjdagFg22Qnm086JZX1K5vYy0wsWv1xv5dISjcYvKzDcoC8o3E/BwCXsUbwhOPVo1LRj3m/RBca2RvgJFCU7Er12dSdXleY36wl1fKYlrPbwMktKhaQJ14GamMGCV8pGR6X8vDRk8TzWMpp0pILJRSykPqDx/HaZgvPzitCVkbRVCqS4+nYJejRoiTmp4Yo1r1uIRZBaRCs6owNzcWRG25xlP0C3glzmkbu6R+YoQtHy1/Hgy24SaZc8Vc69+RLPJ9zmz0m/0uVwN5fbcrwdm/J+8Z+1hJaFDQRVLjWzdXXLzi2n442fgLdmXQyF3oCPU3Va4BbY3vaVxNVAIKOz0FKdn0Hxjnhg1XgAcFqfoJIioHpgK+nbbbtFYgzKWnXP5mj75WrVe1lQmge40X6AfuI+fFH/Gk8HyMy2QKEfIsLxRM/9SflQnV5fRXdnHeEnzyZ9LtL8XO4At2agOvmt+160L0zPBOdD9MjsjDytJOmR+jTljJZtzKISbN2K3jVg+VW8+OWiAG8sm1mUm9fzUqFDGiD7etaImon1TgCxl9zm1WX858GmIhLOCCcRoc9sUEqo9UDWZFQ6HdFQ60URdwEuUd3Q19T+tzpLMMoGncRCtHSOPNPKNSWgYUPXTQ/OSGaC2Y3OxiFoDbkgFDPOHR7CYE8Np6Wpi0Npx7E+XO4VHTksRDxHkFbp1LGhitI2+f0LhpTKRmPjNCMsrN/hnbcswVFmL/PYod7AWHrVtGJjDj2er4HOqvK6OEleoAEdVNnw4DJisuvNAyPb
 n2FrzBvY
 a92JX3h0xJVIc08puUIUM1QNR1N+AFQXjWMUyG3EqHkcDRQdPjursVctuP0uhUQFGm1uu4LgLieivlYnfM2bGv4xoSJeUnstb/QGOXv4aemGspWv2fURL3nML+AsUHuZencT8p1LbtE7aKUJp/HLM4Xg1ZMcWo/XCywrEn4Bw7tbfXF/0iugcTJDR6sW7XikV8fww1shP92nh9FWKoqos9UESjJdiiC+C6eFh0efDI7uTwMgKS4CWeqtoxBVZ+SHUs3ymjqWgoJxU0/3M4zXKBr6USgGExHBT2zxSnOYlA0kqZ3TBDUgTB9dVHad4U4vTo1tYp/bZtqZVT9GLMffNCYAMrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The split_file_backed_thp() test mounts a tmpfs with a fixed size of
"4m". This works on systems with smaller PMD page sizes,
but fails on configurations where the PMD huge page size is
larger (e.g. 16MB).

On such systems, the fixed 4MB tmpfs is insufficient to allocate even
a single PMD-sized THP, causing the test to fail.

Fix this by sizing the tmpfs dynamically based on the runtime
pmd_pagesize, allocating space for two PMD-sized pages.

Before patch:
  running ./split_huge_page_test /tmp/xfs_dir_YTrI5E
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Failed to write data to testing file: Success (0)
  Bail out! Error occurred
   Planned tests != run tests (55 != 9)
   Totals: pass:9 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]

After patch:
  --------------------------------------------------
  running ./split_huge_page_test /tmp/xfs_dir_bMvj6o
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 10 File-backed THP split to order 0 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 11 File-backed THP split to order 1 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 12 File-backed THP split to order 2 test done
...
  ok 55 Split PMD-mapped pagecache folio to order 7 at
    in-folio offset 128 passed
   Totals: pass:55 fail:0 xfail:0 xpass:0 skip:0 error:0
   [PASS]
ok 1 split_huge_page_test /tmp/xfs_dir_bMvj6o

Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index e0167111bdd1..57e8a1c9647a 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -484,6 +484,8 @@ static void split_file_backed_thp(int order)
 	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
 	const char *tmpfs_loc = mkdtemp(tmpfs_template);
 	char testfile[INPUT_MAX];
+	unsigned long size = 2 * pmd_pagesize;
+	char opts[64];
 	ssize_t num_written, num_read;
 	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
@@ -503,7 +505,8 @@ static void split_file_backed_thp(int order)
 		file_buf1[i] = (char)i;
 	memset(file_buf2, 0, pmd_pagesize);
 
-	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
+	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
+	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
 	if (status)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
-- 
2.52.0


