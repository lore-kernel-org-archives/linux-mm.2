Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92236F557F5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 09:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077676B00D5; Mon, 20 Apr 2026 05:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EDB6B00D6; Mon, 20 Apr 2026 05:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7A06B00D7; Mon, 20 Apr 2026 05:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D77146B00D5
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:32:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76A6D5B980
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:32:30 +0000 (UTC)
X-FDA: 84678418860.09.3AA4A40
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id F037E140010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:32:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pJJeHxSV;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776677548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNivuKOZd9xZyhSpJn+DU8SvBGtkdipt4ruFn8pt63A=;
	b=UY0Dmi83MdLGn3cZQ2+cTjK67XSsTqaAwTTgMJTLm6YYFGAAZ/XjF7ZxhHN9UoZnrpUOtw
	fU4MFZa2rwoAsfqJSRm+vI1mQRugA7s0CHPYwJ5slU0KiHbAef+7AiZNr2/3f2Z/8Q0PzJ
	T9xhVNF+cr1ARMalX2LLoh2wle9OgOw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pJJeHxSV;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776677548; a=rsa-sha256;
	cv=none;
	b=yBjl/lOpw3/x7mQ0RdfsG/exJG2M86ypGjmZ2g7x8r8rf21dNPutGuCsnCpMqJCsR/w6Wh
	2Jb0pRYC311x1y912oBt6W8q1Km++D/7ywYTvFHmBQbj/tgt6jJAw8RjMx3by9NfHztwIO
	azyAbRZUnFgJ0qib9oR0eljQ47JWeeM=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JJlxX53234594;
	Mon, 20 Apr 2026 09:32:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=PNivuKOZd9xZyhSpJn+DU8SvBGtkdi
	pt4ruFn8pt63A=; b=pJJeHxSV1xUdLtlBGTHpFuqMXTnst5WBXYl5vW8d2WPJ6V
	N5h7b8HhEJUWRPrskulK8zPIX2SxmX51hhy0d/XMjVS9zbzsDYSePNG/2ZMnJcc2
	srVPh6ghjaqhhM1lZm1qrK0OXlHTuSpBF7sxTnwFffZeP3stjuQ4ACeSxq3HxIcZ
	tecPYbbOvu+I2w8npQ2Yl6egh7OWh211Z9XryGy2oC8teK/aURxvxN5vXYT47Air
	2V6N6b0BD5GAyCPsg3vUVIwbMw5Y/xBa/OIbttOtHe055AUisu3wXI3zCiacw/bK
	7zWkSYqiZ073QTPDkLYyOo1lkK6C7bLvQlaQm0ew==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2ney581-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:32:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63K9KLf3030378;
	Mon, 20 Apr 2026 09:32:20 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dmm9pvade-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:32:20 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63K9WK2X32965286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 09:32:20 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EBC85805D;
	Mon, 20 Apr 2026 09:32:20 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0165058053;
	Mon, 20 Apr 2026 09:32:12 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Apr 2026 09:32:11 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------lBXh2sLMnWOq4Uzhaj9NSPOx"
Message-ID: <b19f4ff3-f0d4-4a80-9ee7-a6fe3c57d0b2@linux.ibm.com>
Date: Mon, 20 Apr 2026 15:02:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/53] selftests/mm: hugetlb_madv_vs_map: use kselftest
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
        Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-11-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260418105539.1261536-11-rppt@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: HGDfHL6ONOKdm5KH33FpzLry6xoYuowi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA4OSBTYWx0ZWRfX1bxn1gIKXgES
 4K6JV5CspQwcDQaCDnmDXRTImO+44qfP4ZtIMgBfnU3WsDNtWaHYwFNj6Y281gekY+bK9SEXEQM
 VOmgGhrrYcYGeCe1UXw9w5M/r1IR8KiwWGQGfd6Y5iTKBKWm0aM8IQ46pvdRpTqbNrm9Z/nMHdl
 tVTTGYMVSaH/QwptbK2bnvmiOekQz5Er4Ba4UbL7milFmUfZs1jrOd7ByjNwmnzTH6ed3wPNCig
 9sHmJX8YJ8pV/aLKABrJA30BfScCtkHn1rTPOU0XyEwtocpZuINaeVIsE5bs0CffYrPjProAtSi
 VoM6KQrLsayQJaC0VQBnXv3dDN1ThvPHoFUvDpHRcc1A9+im61xOik9n7Ww1cuzS1mcB6vZ91d3
 L7TPm8je3oE0AtYtEzJgCpIEJqud8xNliNArP4sebGj3BNcpTZGTEUVueLrbRrPGO1YZlefPwRn
 2NbmShc9MDsK+O3uFXw==
X-Proofpoint-GUID: -CucJ3FH16yBss_fs3OoREtGrlLo9_xL
X-Authority-Analysis: v=2.4 cv=B7iJFutM c=1 sm=1 tr=0 ts=69e5f2a6 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=8TFfJKyJk2BYoSpm0M0A:9 a=QEXdDO2ut3YA:10
 a=ja45LuVpSxjyBGvCv-UA:9 a=ZRQ563D43ZfVqoCn:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200089
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F037E140010
X-Stat-Signature: ow4oqqobts65d1ac5g6zejxyigcodx5t
X-Rspam-User: 
X-HE-Tag: 1776677547-21100
X-HE-Meta: U2FsdGVkX19TQN/OuDXFerxl7wC117iPNsPigQ9Ep2/rm3t3YcQ7J9D87kXt4W65qfeCXJzPA5qaqkbwyLCNyuAY6oNt4p9nTSPstU7qR+tTUV58rEPSKG4HIrY5Oe/F7Ok48SPJb8f0OLT2Jr2Ava20rKUGOgaM4YJ8tCSViFYh4MyZD/vwDsbGJ9Lfun1JOJdJu1cKPXoEDswuFkgxHZdzcJ1KXMDc8n1IsX68bqbrCJ5Nevja5+Jk+zAg3g0LhMPkHqFCp0M5oCLnJPvvrdDf+kwHAuy5wq4Ag5HPqBHFsZeNRRmne9D0TVGxLnZgAeihCpIhJRsAwj9Go0QbaP8c04+PzDM8FtfQ5IdjaR89XzPJEogpwdjKsJ428KM72sjQOHZUG+SGiJhy5YRPprGaNtIpziLG2jfiBxsMZ4bHrC1es+/L7sMXAYOn9CsOs9Ft78jkxAQtGDMMeIKslkiBlVtZCgZ1a+nlAx65McLibh7i8uwlos9iUEXYVJRS63J/q/E0Cum9kzUykJRQY0xwUInx0A6jfNyonWYUGN/td5+KXMMEPh7dE68QGaYD5jpNkwjHtzu513LKIJ0sxRaOlZlxWjfXuLlm59zk073KkDeHa4vsBisWJ74OAkuieVQJzS4ASzTd+Yt+ll2gSPE0AbdL8dLCxEchMoQ83I9524Y7UfLMqbUNVmSDtr+/Dpg8+CxX+yg4LnKwMTA0R236NWfbqTkxgVyyRREwd9K+1CvZprSom1yjdEKKKI6NRrjqNzzy2KpFj+hXhF4uAeGzNhFwpW/XlZWrViCwW3go+2z+0X6WmUn1+ZhECjc4b+11sUndhD2xtQ/6oGpWVpfEd60UuCkUiuOWgeN7FfGcGj9Ngcymlw0ZSIq1TNhtsldMbK4wDFeGClzfxaeQVLRjTTQoeShD7E175s6BsuJPZRXOUbWbC3QIO4UHoW1ndIhDZQYu/MAIdK3BgPu
 Mq3mK5rg
 x3wfwUDQychGFZX/qhLFW5zuhqZRzGap80kCIURFmMOENxGIRjzgDjE6eyuBVUfozCz1yCDm3qMzbfZ8+w+02/3dEuLXDUtJu75WK08dNJRb6p+DQEhrPCkYwLxVOgu1DaTMFf4yIRTghDsKrkOg7ZmC7whYnuYymKk9n5FbSpmAW2EjXW2HGY1v3n1Pc6J5XJ+ubZhPztX6dBz02pcwf+wGeNf0rB79pmYAf+vDFAIKmHfOEQKFT3z792Ot/53EeR827QpQhavdJvpY4eM4jnKgpeXURdE5AYCshTAifAEx/WRsYp7fms3a0aTmWl2oSypfgDpFYjJDCgkQrvFoVo5GX77pFIPzG76Xw+ofwUwBV4Io4VjHa1sm9yBFBUxYSpbyQ7Hh1JQLCxlz10WgwX8CK1kBnTMhtadElst+XiKPEGLg38zTiM/HDH9/TV+b6vmEk5txZJZz86UuHmJWNiUG2mjUR2yv5GLftIyiAeMVX87vj3A/AQMhONhC0Dt3VjEkjXauZJXH8p0vG+NsaTOfIsWN/1pVbwyQ4863mvBeVZiwAFtcE1K76R+6x9m8YLasGrndwXg7D56A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------lBXh2sLMnWOq4Uzhaj9NSPOx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mike

On 4/18/26 4:24 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)"<rppt@kernel.org>
>
> Convert hugetlb_madv_vs_map test to use kselftest framework for
> reporting and tracking successful and failing runs.
>
> Reviewed-by: Mark Brown<broonie@kernel.org>
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

LGTM

Reviewed by: Donet Tom<donettom@linux.ibm.com>

-Donet



--------------lBXh2sLMnWOq4Uzhaj9NSPOx
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi Mike</font></p>
    <div class="moz-cite-prefix">On 4/18/26 4:24 PM, Mike Rapoport
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260418105539.1261536-11-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">From: "Mike Rapoport (Microsoft)" <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>

Convert hugetlb_madv_vs_map test to use kselftest framework for
reporting and tracking successful and failing runs.

Reviewed-by: Mark Brown <a class="moz-txt-link-rfc2396E" href="mailto:broonie@kernel.org">&lt;broonie@kernel.org&gt;</a>
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
+			ksft_finished();
 		}
 
 		/* Unmap and restart */
 		munmap(huge_ptr, mmap_size);
 	}
 
-	return KSFT_PASS;
+	ksft_test_result_pass("No unexpected huge page allocations\n");
+	ksft_finished();
 }</pre>
    </blockquote>
    <p><span style="white-space: pre-wrap">
</span></p>
    <pre id="b"
style="overflow-wrap: anywhere; font-size: 13px; font-family: monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">LGTM

Reviewed by: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a>

-Donet</pre>
    <p><br>
    </p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20260418105539.1261536-11-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------lBXh2sLMnWOq4Uzhaj9NSPOx--


