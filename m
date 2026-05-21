Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D0BCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF34F6B008C; Thu, 21 May 2026 05:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1C16B0092; Thu, 21 May 2026 05:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C907F6B0093; Thu, 21 May 2026 05:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B721F6B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:13:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DB5D1C187D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:13:55 +0000 (UTC)
X-FDA: 84790864830.01.5741443
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 08D49C0004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:13:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OKqUzPnh;
	spf=pass (imf10.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779354833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OevyjTu9FiHf2CLX090f6Fl/3bswf0qDQG/sp+fQ7zg=;
	b=YnXivKuFhl6OdMHePY3xdHQUQ46nOxp9a7AlMYgFCsbUuGomPqZoKn4aNX1y0u6B8V23Xd
	b/L9VQcFQr+OXNidTKfGFYxBvTUniGqbv6/iEQk9Jy4gKWSbKJIx6hdSAigurJtb56ElKd
	FrXq9iwPF/7kVOniKxcS6KH1wMsbcMM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OKqUzPnh;
	spf=pass (imf10.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779354833; a=rsa-sha256;
	cv=none;
	b=va8QnuS/RZc9JzXwBE+dE1BptdP3N8gR6suspf/ZCtxgOP+YRGLdaKXJhBDZI8SzSmHsw2
	d2PA7zd5toZaEKnQ4sm1K8qSjgegDQtQjUuL3uwRJjP/ebCl16aJ6WO6lo3OT2Pn0bUMUl
	n6y8MRljeqV3RLjAnLKZ4KquhUZyf6w=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KJ8bo31588176;
	Thu, 21 May 2026 09:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OevyjT
	u9FiHf2CLX090f6Fl/3bswf0qDQG/sp+fQ7zg=; b=OKqUzPnhznUoDQSmPi9Vma
	m/Jt/P0O62RFr6XuEAeTto1ilU+XOVRHbiFPT60g6GgTFUiucBoPCXvpedr5+nr7
	aE/VoYW+fekw9XWuXJ6H3kvKa2n6TCxjuNHeXp6f6mxiRjgqkmAyESwqlN9vHd4N
	PyV1sfYvRDzUoqe+8Joa47JNkAtFoKdpS4km7yssIP59/NgO/jQkcXyDG7URxVui
	8qSsbGGgTQHYuxol1rlhsWDnA/1TOxtn8aAviD+PyJbWE24seN9e61silVElBVSf
	Y+UDcGMp/9rx9CR2YQ4smnuqQDs2wqAIH++/7Gm/OHJdGY5MAHGwkaF2OIEHsrLg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8mvq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 09:13:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L998Nj001114;
	Thu, 21 May 2026 09:13:42 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gk403-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 09:13:42 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L9DgLZ48496976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 09:13:42 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13F9658054;
	Thu, 21 May 2026 09:13:42 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B81FB58050;
	Thu, 21 May 2026 09:13:36 +0000 (GMT)
Received: from [9.123.3.209] (unknown [9.123.3.209])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 09:13:36 +0000 (GMT)
Message-ID: <88202b56-1dc5-43e2-9d1f-a0823a9531f0@linux.ibm.com>
Date: Thu, 21 May 2026 14:43:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v7 11/13] selftests/mm: skip uffd-stress test when
 nr_pages_per_cpu is zero
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
 <0707e9a0f1b3dd904c4a069b91db317f9c160faa.1779296493.git.sayalip@linux.ibm.com>
Content-Language: en-IN
In-Reply-To: <0707e9a0f1b3dd904c4a069b91db317f9c160faa.1779296493.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA4OSBTYWx0ZWRfX0NfPxMuPQdl8
 ZQEW9qTenAPbDx/m/wMEMbT71aF8Nrx90/1QHthXxmzys/O8PX+PZJa8c8Km+aCHWlnfl94BhRO
 p4dj+pxgQqaXY8c3+luxPdjK/DJ4hyP0JQ+upF4txAE4bKzFoLvWHXr0Bor94MaVoaIoLKEiPO/
 Vz4MNDmKfa3/GbRbB1+0aSTN+a1+cQAXxruJTAWjTxsrOTPR0kzih/YzKr0fYpWPLsDIoZ3ZugT
 OLYUjmYp2NM6cQxl6zvqvE6fGZw40XLIAuUesPFIMhfXcgo1cyOrLNAnjj7/zIXljBK5qPt91JG
 l5OlqmEzh7rymHqn5WGMxYOV0CGiWfW4726bau2MCrgwdZWq8Ug14SUbeuuF8pcQ5nkoZC52A+a
 34rEq4PYDPtGZPJ9SgQwPzllQEOwP/gjiwiQ1ciXoXZp2C6/EeuiXjhdZHJ/f8VH/R/l7mWH+40
 dE/HuLCtEjs6PD5BNJw==
X-Proofpoint-GUID: YBD6R_YN9_Ss56w9WvlauW_CAYGbIE73
X-Proofpoint-ORIG-GUID: nSLeMh-JvVOwp7mGCId-w65f2VJDqkvX
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0eccc8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=Bj7DDXi5LvTWgAAjYWoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210089
X-Rspamd-Queue-Id: 08D49C0004
X-Stat-Signature: ofbt5udiwuxsn499rrazsk6zsr14ztnj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779354832-48998
X-HE-Meta: U2FsdGVkX1/35ku3Ohbp60zNqvMrHwcWKknMRAiSYLEWYj4OrlVfSUUQVXTXnhrOeAlK/uAdOfMVUlUUuzzKJsHDrIrE9I5B1oDgOtHybZdTU9cpYRjedP+7O+QEj40qbuNQj8KXRxECFjIaX3VezBEXGEaiF3FV+U/pNyBIVQP9eLesXA7mpqyRtJ3EpjO/6vOoD9TiMw+MHgA8osK0hQyh12fIN1AXQbHAjYrQWldgiQ25RNFAv/5dHvhHrmtrvSFQ3FI5y/Jf4xbZw2rKgUJ/eqiR6xqspr9QLub79eHMs7mtoM5JWb3boew1UZWfon2bi27bDcQsdt37Te8qMAGkV7XwaqKvDy8dGwGu2zKoizh5fjOxe2+t/AWkIYD0R4ze1rrW26s7QY7NvYhHxYOCVW8opi4tDQPzJuOiM9mFI1xf2EeU5CFqLgnvfN7M14BYhdh7/MMtc7pllOR9Syw1CD9S70cQu6JQ1sKCP22SAV2JwiXuFfNTYlFrhvvJUT39mwmWt+0jhTqXq3AHOQtxVFYX5/eLp6P2/3ItiP0NZZ6M7YR7+0FOQ6XW71qiQ8q90w9KsV5IDB19Ip00yhc3C2NK1dBMDnvqMXrbuM7HPGHCLyIq3wSMAIDw8fmUhN8pqu3y1rcW2j2ABDyYplph9aL2CavVYjKBd+7KZJakLVEAIa9yY1gXQR8qwBEG1ISbp0gSqXm4rB3BJIhz8fE/RnQSJOfyfdIJyUPkVlABM23uIGOMr+GJh9CsBA8L5U+tITekGhGu+y09C+bPRrLOPaAzLpC7SjBhGRYaEuF+zpo4ZE4u8TKp3pGTqrEln/Xxl66DNwh36aHb5XvDKGBokTTfqL9nIKHbq7YkYKGz46fr1HR5wUMe/mRWBW8LHPLUSWdYBhPbpYz4xt2QMpTJ+5HUv7fCabjfdvYiVGfblLGymbb7Ixvo4WRjxzE+8d/nkDfNw8qqf3CO9a7
 XErrC+Hw
 yDzADBWyj+9SvFy5MSRAri/pBv6hfq0wCQIeh0H8GTNNqSoHAQ0J+UZEgnEJWgJCtST7+yMEwBhAhYq/LP7aKuXTR3+zrqpqvwQ+uOgl2nREH3sFCVqaoOME1X9YWfNl4c/9eLMAvgGO0uU+d7TyNvB809bN51dzsHaGJAlYjESCbGQL4+P4f3rqze8j3SRzDHXEV1torOxdNbe2rEhbX6nuBbHVwYtIfZiX1r0re+N7M4CfIoIq7CIa+6DruOMI5/ovoBg9G/+U2hPT1mygqb3jseh69xNMZ9MFN3zrdFk/jN7WjWMzsCOaDSCwlah2M13zSylvcfgggz4z4L2qR5i1/XiOlvUHRnwg4osO681KPA7OJIydpjyP/wasvsqVvFFGCzezgiwnFsleFzBaLDfx6DNuqb/+9KOlqLQkPvdbDtmVmC7K3OUAbQUFPD5fz968cBCHdYKM4NB5BarcDwcH6lbzcNd0b7cB9RSEpUZTljjgLVfrkghYnViXSlmpVxgbl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/05/26 12:17, Sayali Patil wrote:
> uffd-stress currently fails when the computed nr_pages_per_cpu
> evaluates to zero:
> 
> nr_pages_per_cpu = bytes / page_size / nr_parallel
> 
> This can occur on systems with large hugepage sizes (e.g. 1GB) and a
> high number of CPUs, where the total allocated memory is sufficient
> overall but not enough to provide at least one page per cpu.
> 
> In such cases, the failure is due to insufficient test resources
> rather than incorrect kernel behaviour. Update the test
> to treat this condition as a test skip instead of reporting an error.
> 
> Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>   tools/testing/selftests/mm/uffd-stress.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
> index 43cc79590136..39e13e2078a9 100644
> --- a/tools/testing/selftests/mm/uffd-stress.c
> +++ b/tools/testing/selftests/mm/uffd-stress.c
> @@ -489,9 +489,9 @@ int main(int argc, char **argv)
>   
>   	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
>   	if (!gopts->nr_pages_per_cpu) {
> -		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
> -			bytes, gopts->page_size, gopts->nr_parallel);
> -		usage();
> +		ksft_print_msg("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
> +			       bytes, gopts->page_size, gopts->nr_parallel);
> +		return KSFT_SKIP;
>   	}
>   
>   	bounces = atoi(argv[3]);


Hi Andrew,
Can you please apply the below fixlet on top of this patch as suggested 
by Sashiko.

 From aa8f2eea63defd9b9c1342b83838f48e93e1b918 Mon Sep 17 00:00:00 2001
From: Sayali Patil <sayalip@linux.ibm.com>
Date: Thu, 21 May 2026 13:32:51 +0530
Subject: [PATCH] [fixlet] selftests/mm: use ksft_exit_skip() instead of
  KSFT_SKIP in uffd-stress

When nr_pages_per_cpu evaluates to zero, the test is skipped by
printing a message and returning KSFT_SKIP manually.

Replace this with ksft_exit_skip(), which prints the skip message
and exits with the correct skip status in a single helper, making
the code consistent with other selftests.

Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
  tools/testing/selftests/mm/uffd-stress.c | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c 
b/tools/testing/selftests/mm/uffd-stress.c
index 39e13e2078a9..3401dd6028f0 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -489,9 +489,8 @@ int main(int argc, char **argv)

  	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
  	if (!gopts->nr_pages_per_cpu) {
-		ksft_print_msg("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
+		ksft_exit_skip("pages_per_cpu = 0, cannot test (%zu / %lu / %lu)\n",
  			       bytes, gopts->page_size, gopts->nr_parallel);
-		return KSFT_SKIP;
  	}

  	bounces = atoi(argv[3]);
-- 
2.52.0


Thanks,
Sayali

