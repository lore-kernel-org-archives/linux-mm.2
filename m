Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BFCF364A6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9176B0005; Thu,  9 Apr 2026 13:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590FA6B0088; Thu,  9 Apr 2026 13:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6926B008A; Thu,  9 Apr 2026 13:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF166B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:14:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D16058C706
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:14:53 +0000 (UTC)
X-FDA: 84639667266.24.B9F116D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 59B80100010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:14:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NCBvl+hU;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775754890; a=rsa-sha256;
	cv=none;
	b=x57VccO/J3c43fNebCrmPPoClyq7TEitSZ7KdYvqbeTofRl0MChau/c0aTTcrzuFxbDpk2
	Na5A+kPMjkJEYfVOh9CidNlNVsH1oFzvCEd+Rq/ajTws01QIliBB+q67Tn7ZtOsYdWFkmC
	o8tourGU+vKCaaPQtcriiPnM98W0SLI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NCBvl+hU;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775754890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkxvffhtPq54J6x39xM7tr5d0IUFupbo1pbbbmEFrYM=;
	b=a4MOa4vNeMLOqdnkFKzVLeyl7petwOAjwc84CvBt1hducsp02Wv2d0RKxBP/t/TYzbcve2
	kSbnPWQhDZco3hmb7d+E7DNI745XBlUpYCN8HuVvyPjGLKtH4jiotcmp9AXz86cieNIOFK
	XO6BC0aGxKG4RCj2aNd0GYNOrZdNJpI=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639AUGG72302379;
	Thu, 9 Apr 2026 17:14:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=fkxvffhtPq54J6x39xM7tr5d0IUFup
	bo1pbbbmEFrYM=; b=NCBvl+hUA6tXYNEhoM+Lymm3vl9Qc1ChxRFLSXfahOT9Ks
	k+EyIKP4oa7BQwxuIC3oJt/ekxoqR5J8YAsrQ0ps9EQsXeZbXtqxTQdVhsIE4XnK
	nC4hJVD+WVgaRGDlTQfzTw6/uoElzQyFxlpoZ9jXqwmkzuq3WcsWzuWgudRWMyni
	w+AluM2J6Fz6vPQUEvf9h0Q7iL6nI4YVBN+ZPVXblHPsbSls9pDWD5Y1/cAJokwn
	eJy46UhRoJ4WXuJFhGKkeKtUtBqHnqofKI3PRSreNbNDqB+lk0CPxSFDbaozTrrL
	UBg1U/+fgU8zkzGtcpm/duE0TG0dp8KG12o/kosw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2fp68w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 17:14:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 639H3klC026646;
	Thu, 9 Apr 2026 17:14:40 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg84hkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 17:14:40 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639HEdfh31916644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 17:14:39 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8132C58045;
	Thu,  9 Apr 2026 17:14:39 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E43758066;
	Thu,  9 Apr 2026 17:14:30 +0000 (GMT)
Received: from [9.124.214.147] (unknown [9.124.214.147])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 17:14:29 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------daimTmXZrXgQ54xKW750ToV9"
Message-ID: <c1ff61ca-89a2-4d13-b376-03cbe7719366@linux.ibm.com>
Date: Thu, 9 Apr 2026 22:44:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/53] selftests/mm: hugetlb_madv_vs_map: use kselftest
 framework
To: Mike Rapoport <rppt@kernel.org>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-11-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-11-rppt@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE1NCBTYWx0ZWRfX+6qmzrKYZdab
 TkH136RBO4jpr+F56VyVy9IWOuWD9AvZGfJYv+tGYFi6pFL7NtJF6ufv69i6R4V1s8+czHE0U3J
 mQRAvdy1OF0Be2sqpTxih4OkdnAHT9F7FjwMm8UPc1dg9YpmlMIIA4oW321yPx6mLdaHSgFwnVF
 XppfEnwLluHZQWuEjhchYDW/tnibuH/zvahgWB7Q3eafj9WF7rdnt+HudRzqV+dlw5vPZWmXuIo
 //OPyL1gZudI/QAY5P/OGsBz1l378/3gcLcR8gr8/bFH0J0flKPPZWCeg89y5tQ1tVRnmzJXgiJ
 bKcFwijM+pvuUBnat6L0DetzSvMGYG6kQGLUIbAfvQmFJH1yj6hskx7CtBQa+NqmCJ6e/y4+d0V
 FClVxVFUPogubPxd6aYpEGgmodRH0n9gm2/pIJd2eJG6bvtsQx+Rg5Tvpk7N5C5/EqkLLOesLnc
 66FBY2Oxn7T19q62hEw==
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=69d7de81 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VwQbUJbxAAAA:8
 a=8TFfJKyJk2BYoSpm0M0A:9 a=QEXdDO2ut3YA:10 a=ja45LuVpSxjyBGvCv-UA:9
 a=kzlf1ODm9A065gvr:21 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10
X-Proofpoint-ORIG-GUID: bOZcsluK4y2StxfgoikI2hdJmJEcu51q
X-Proofpoint-GUID: 1RcRM7NSf0CegPpu9fi6PZJtu5OtdAGy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090154
X-Stat-Signature: ntohxncw5uuxwdeshuj3qkqug93kb36w
X-Rspamd-Queue-Id: 59B80100010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775754889-614903
X-HE-Meta: U2FsdGVkX1832oj9BMQ3J/9vktKIc6qHcT3ZaYmdvnKqAF3/fJO6i3MjaYA2cozl0rTiJr7eV777JewPiDniFhS1T4zoTYy0E2aHw3FZh4hJ/cIPYLgK5S+1Vv4etL0Bpk2B3mKYWuD61A9mxOvqdMzgsRbTXI1m9pfGE/Nsv0R+ZmAb27335eCvJkIeY/aWLjOuPHv4djvq7pZsERaz4juIJolhgfrY8eNxJ70yM7oI3Yodi4hZPM+sviDUc1jYVQVEXP3wx5vvmjGzc8MAzoJ7/Q6SjrU4YbHWFB4OJSDaPQwKTBzWIqxZr4Fvsl0nPW5AAHwdBMngVbGOi4bqiwE07eKXpKs3LbsW/JNT8TJdx8mPGSUx5NgkiDjXBIUVxVeVKy7w7q3kW+H6Vvv+JoV8A/oyVFJLAA2XIFRj5KJOw2JtoAYqyFU9CCFtIhZ34+pp/yO4qyC98g5yzziDCX7w9C2JhSnKxYrMNR065Otk0P0vjk9wfNbDv7msIXRaq4ejsqnUuCkZAe6dBGc1RTknPKotQ94al6ASslW8ZLtFg+/WJlOuWfpX2RIU9h0zSXab5tK6KHwVoyUDo5xtXMni1Zv36Hm9knbpxrT5zVQ6qBruYwTHwz8/UZ5kwk9YPHgGplF15b/KdH+o7hC5dFVH49oCGlkTez8PcRA5KqI4JzvCoTU4E1TmVJvgtcSznvvW5kauLhIs3/iDm4FHmXgcaeRi2o1Rep1trooZWjuvvVdk+//BPEFbiSTUZKWu5M6SqLmy7Lu9oo4LnRz07yJ823xgmed2v8O+qAMUm/Nzzsr0PtvwTE1HUUGJ4FL0U0GIu3U6YN/dkFUHGto1/ujbZ1tZF0M5c05sFI2pyMxuWEphJR/brhzTtxonp3EEA0UQxEfC8/2cuv9txd/kDIlliIx1HByfT+bjDqLV5cVXPdzVln1W8+m9YZSI3JKctJ1nsr2EPiRh6wJoUoh
 A+qomnXd
 kqoBM5tuBHjZY7waPLh6xOx4rxjdhYm1FdVPLMiPZF8QOQfUCcf85Zftin5CuN0JwjDGt+Hc/vyLqP0yhjxlXoX0zqudDdFQXO+ct/LTMNJakHjrGfDd7a6pDZIBjn9Juap3fU5TzJAX9hJv7zfEXF1pKzioDZjbcpBNjIrYFTPUF9m7Sca/PVEhAxw5yEEYlMK8Yn8PD2JXPUoO1Z4yQaaKMYFopRYKxjz9NC3lBwZrTYvW3zoTES6F0Dpit0wlILUQOO9026/Q2hVGlgwVZ50gaqQs7yTYBeAe8kNcRP/tBPKZ5nywPWgKakOQSZiL3J7J8E7sJdUoTtd2x3aTDQU789uBrO5bvzbNOgBO/PGVHKDAVSEEPct/i0/dQX3Qc0GOJurvYIKpg8IKzxizqFYc31jYida4EPi+aQpt31MWjNB0O8M2DORJj6tZsIz7ru0O7GBfAcV8/v1vsm+Yr79V1mlnP4TTujGnwimb0Pblbfbo8vKlMQNpWDlZYD65WVbkIbBrCEXLN7BEDmx39yGd/bX2oV4MhQLfdBt4xdR1IxzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------daimTmXZrXgQ54xKW750ToV9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mike

On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)"<rppt@kernel.org>
>
> Convert hugetlb_madv_vs_map test to use kselftest framework for
> reporting and tracking successful and failing runs.
>
> Signed-off-by: Mike Rapoport (Microsoft)<rppt@kernel.org>
> ---
>   .../testing/selftests/mm/hugetlb_madv_vs_map.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> index efd774b41389..c7105c6d319b 100644
> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> @@ -25,7 +25,6 @@
>   #include <unistd.h>
>   
>   #include "vm_util.h"
> -#include "kselftest.h"
>   
>   #define INLOOP_ITER 100
>   
> @@ -86,12 +85,14 @@ int main(void)
>   	 */
>   	int max = 10;
>   
> +	ksft_print_header();
> +	ksft_set_plan(1);
> +
>   	free_hugepages = get_free_hugepages();
>   
> -	if (free_hugepages != 1) {
> +	if (free_hugepages != 1)
>   		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
>   			       free_hugepages);
> -	}
>   
>   	mmap_size = default_huge_page_size();
>   
> @@ -100,10 +101,8 @@ int main(void)
>   				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
>   				-1, 0);
>   
> -		if ((unsigned long)huge_ptr == -1) {
> -			ksft_test_result_fail("Failed to allocate huge page\n");
> -			return KSFT_FAIL;
> -		}
> +		if ((unsigned long)huge_ptr == -1)
> +			ksft_exit_fail_msg("Failed to allocate huge page\n");
>   
>   		pthread_create(&thread1, NULL, madv, NULL);
>   		pthread_create(&thread2, NULL, touch, NULL);
> @@ -115,12 +114,13 @@ int main(void)
>   
>   		if (ret) {
>   			ksft_test_result_fail("Unexpected huge page allocation\n");
> -			return KSFT_FAIL;
> +			ksft_finished();


Should we call |munmap()| before exiting?


>   		}
>   
>   		/* Unmap and restart */
>   		munmap(huge_ptr, mmap_size);
>   	}
>   
> -	return KSFT_PASS;
> +	ksft_test_result_pass("No unexpected huge page allocations\n");
> +	ksft_finished();
>   }
--------------daimTmXZrXgQ54xKW750ToV9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi Mike</font><br>
      <br>
    </p>
    <div class="moz-cite-prefix">On 4/6/26 7:46 PM, Mike Rapoport wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-11-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">From: "Mike Rapoport (Microsoft)" <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>

Convert hugetlb_madv_vs_map test to use kselftest framework for
reporting and tracking successful and failing runs.

Signed-off-by: Mike Rapoport (Microsoft) <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>
---
 .../testing/selftests/mm/hugetlb_madv_vs_map.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index efd774b41389..c7105c6d319b 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -25,7 +25,6 @@
 #include &lt;unistd.h&gt;
 
 #include "vm_util.h"
-#include "kselftest.h"
 
 #define INLOOP_ITER 100
 
@@ -86,12 +85,14 @@ int main(void)
 	 */
 	int max = 10;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	free_hugepages = get_free_hugepages();
 
-	if (free_hugepages != 1) {
+	if (free_hugepages != 1)
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       free_hugepages);
-	}
 
 	mmap_size = default_huge_page_size();
 
@@ -100,10 +101,8 @@ int main(void)
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 				-1, 0);
 
-		if ((unsigned long)huge_ptr == -1) {
-			ksft_test_result_fail("Failed to allocate huge page\n");
-			return KSFT_FAIL;
-		}
+		if ((unsigned long)huge_ptr == -1)
+			ksft_exit_fail_msg("Failed to allocate huge page\n");
 
 		pthread_create(&amp;thread1, NULL, madv, NULL);
 		pthread_create(&amp;thread2, NULL, touch, NULL);
@@ -115,12 +114,13 @@ int main(void)
 
 		if (ret) {
 			ksft_test_result_fail("Unexpected huge page allocation\n");
-			return KSFT_FAIL;
+			ksft_finished();</pre>
    </blockquote>
    <p><br>
      <font face="monospace">Should we call <code data-start="82"
          data-end="92">munmap()</code> before exiting?</font></p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-11-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
 		}
 
 		/* Unmap and restart */
 		munmap(huge_ptr, mmap_size);
 	}
 
-	return KSFT_PASS;
+	ksft_test_result_pass("No unexpected huge page allocations\n");
+	ksft_finished();
 }
</pre>
    </blockquote>
  </body>
</html>

--------------daimTmXZrXgQ54xKW750ToV9--


