Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EA6FA0C3C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 07:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A45B6B0092; Wed, 15 Apr 2026 03:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854CF6B0093; Wed, 15 Apr 2026 03:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748E86B0095; Wed, 15 Apr 2026 03:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6058A6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:51:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B6BEB8878
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:51:50 +0000 (UTC)
X-FDA: 84660021180.07.5609900
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02587140009
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:51:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PYtTvnee;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776239507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRIBpBXdILwWULwaeFoVfR5LPSMUXfdDEhKqNVYPy/M=;
	b=rA6LNvcmcXD9AFDko9QDcvPPMxKL4LBD3NfxEVBsGMMIEaLk5jEeHdKgcFWMpHzIXwQ3zi
	zTgVJ2+FXmZsLzZxSxFwHGLvnqN1YbOgjcjYbtQtfuqIY2s7MfPMWqr6PwPgpbHlEZOJUs
	pkdx/wrVEzmOPSZt7FdQCqIKvfc95kM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776239507; a=rsa-sha256;
	cv=none;
	b=tZgGNZFPsHWyErVd6dav4fuR4TvcgB1i26RgeaaXzs0yPo5QTxL9PQKgPNp5ELd8q5GYMs
	Ccej3JSYGf6E3Ai+sFs2F0hdYtm0F8j0AF3WquwcG1eGSePBueQBeOP355lGN25n0+UrWs
	TLc0ewe4c/C2eZMRxtZJ3V+e8GM3wsE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PYtTvnee;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F4hP6w1834976;
	Wed, 15 Apr 2026 07:51:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CRIBpB
	XdILwWULwaeFoVfR5LPSMUXfdDEhKqNVYPy/M=; b=PYtTvneewOlvgdYzloR+qc
	Y4M1EbHICI/uP/kLG8PsghpdlxOzSYIPWpHI1WfodzNL/C1LOtCAK/gYfGME4jla
	wsKKkhyBSDwvTfhcFF3cifAcU/tjQy+XzqaqMjcE9xV+bQZ26A17vmtzS6WgPU0M
	pi/sKTZOpOyvkldXz1c4Yl8vNSVXfRKye9P/uMOSX1SUb+nLggfM2uCamqbxaF1d
	pVOR5/73cqf8Q+fWHNPd6YUIbgyzme0bkaT6E9nPb/koaWxj770EUu7iiCraG5zA
	K77GVuAOUASATFZdQLKelnv6NhP3pic+d6Uh9qZPgxuprwr1lz0UHfzVcX/e8K1w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89rexhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 07:51:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63F36QuJ003594;
	Wed, 15 Apr 2026 07:51:38 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg1mnd880-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 07:51:38 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63F7pbOs5440264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 07:51:37 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8981A58055;
	Wed, 15 Apr 2026 07:51:37 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8587C5804B;
	Wed, 15 Apr 2026 07:51:28 +0000 (GMT)
Received: from [9.124.217.38] (unknown [9.124.217.38])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Apr 2026 07:51:28 +0000 (GMT)
Message-ID: <5304948b-18ad-43f1-b447-df1f97f31949@linux.ibm.com>
Date: Wed, 15 Apr 2026 13:21:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/53] selftests/mm: uffd-unit-tests: use kselftest
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
 <20260406141735.2179309-19-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-19-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDA3MCBTYWx0ZWRfX7uf5yzMp4EV7
 ZcwOKodXJFjvDXMi4SwG9EGvPVVr8V2a5xDzUTmJiR5z/DCxjTbWqLlt232AZtYbtnfrqo0yYaJ
 y4KaDkz3hk8m4z/hTVEi/vCgbz6YHk9aNyWLa8B+aD0gSpKQ1C62icHFjJHo+ifZjW9pbnE8NWy
 nNzW6thb1bUMxkdUalHZL6zdIeTEXMqDu7Rsd/q/slwVj4KZzb54syUIzqA71AJitTKJnGpYrQc
 xeOC7p8Tk2efU9mzzXL1DD8qIJoCJuPK3BQPJdcL0gXj8QIpmvT8g5PSvSuzSrhclxFTqSTSWTa
 LDoQPVlzZCHFuZI9t6BIVMqHC9Ua0bvP5n+qRLg5ktmWSwsNN8r0re6tFoIxE3VkCMInS9oFl7p
 6WmESoTDN16gzo+jK97ieci7flahxhD/rrge9HJN7WFe0u+TT0rdT3XSzqZK9TpFum94sokK/qA
 CsLMi1TU6zFKBAfWQAw==
X-Proofpoint-ORIG-GUID: crsjs0cRZXeEf6DcRBo75EnMdPl_BFTG
X-Proofpoint-GUID: RdUmzU2AB-5czPCzIDm2gTB5_OhM7cwq
X-Authority-Analysis: v=2.4 cv=fYidDUQF c=1 sm=1 tr=0 ts=69df438b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=ICrVR6_wMwjK95LA6u4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150070
X-Rspamd-Server: rspam12
X-Stat-Signature: y5nacftiomoe79ykpk7yndgnws33zzou
X-Rspamd-Queue-Id: 02587140009
X-Rspam-User: 
X-HE-Tag: 1776239505-211998
X-HE-Meta: U2FsdGVkX18TZvFGoy5hSOsyuuRfi4LMKe/ER7Zqr4I1a+X4ktVL1m6qwyPVxbGs4EJCqRVucYaLLekMBHEp/FkwwSNG4lej0HbE5Xij1EIVCWydnQoUVnes8a3frtBS6L1gmdSkarlNY+yHiSOTwyZ9mzg9LtCLLCvcAEUuSHgYTT9Xx24Jf3ye7RAM1AqykvXqX8GCRocY3M7dsIrOTP5wjMuEEMo4KZLZDgKSjhum7n4FO3jwU4WQ+ixRs3rPHy7HkUrl/nQ6evMznGzxJ5yL0b5kJR8H+MhwkRj4Qz4eL8U2Iw90HmLwJlPjjsXjbu6RkySISUYtEaRlxUrnuxBB8T4eoWfUDsNdHYCqLRovJQ2nzPbU6USf9CNU/sQR0+pUYyMRIn56AVnl73INV30WpmFT0gUotWlf6qvZ/xcvhFJIegEqqs2nlq2MJRFEXvI/vEZ4hxszFsTrqdmxn/oTRt6VBbhnS/zjSR9U6EMEShjl+x4e4VEuLtUoBL/VCbVoNxkdr58M0KH4GbGwKvIY1U75OCukmN8zAukV6yfa8iQlIw9+h+pTIesyPV32nabnK3dEf2REtfKZ+JVWNYLeOeqICthb7I8ELR9r+Pzra/zFvfXI5znOeGGG7UqpJGXMWdlV4wtryMj+TZKxkiTcrqqJhO0/nBY94glslh4CPLnwSh5GF/qv6dShfQRVVDCz4naF8Qy81gbrd7TessPvyVWBy/Rsq9QIx/YFTmeejjxvhMg+/lj724+UDP5QyPK5tMJs86/XQ/8+X0Lye2jxUqdNdnjsRZVa6b0HNolGlMf0D0cwuPLoK+4X5H+S9K0+7wMZNzqgCo92E20d9YJQrJ2BW3Jf7kkxBYIOlMb/Yt2r99S4HbEFfIyuvqzM/s5LmkzFpAM1+7r6soKoMdPl/JSgKFDhgAygyspRHf1S1ZbidYgcrj3oWY2v0HIk9OYhM3MxHQ9os+9Ln/3
 L7HxS5T8
 sNP9xLX+RUhSMR2UVqW3N+BQVHaYuX2cnAvrbn3tI0A4PPdY+Mf4/looRo9gSd3porZzaAT5UcJlsUS55VnVwTeMuitxR1GHBgOGdwKbb0ANbPbUYmxrk4dXtOlewW16c14ddFY+xikgBEZSDv8UrWz+qNEK/0wSQZAVWGxrnuY0zZE5s+xB1xn6XkV/G3z+ifZR7gSbFGhOtmGv0JS0MsbUi+g/yO4UgpEJcnzXIbmfAxrGrqJVzXTIfVXKKhCzXc1MB9Pclz96/dR5NqWOyqvaqgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike

On 4/6/26 7:47 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Convert uffd-unit-tests to use kselftest framework for reporting and
> tracking successful and failing runs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/uffd-unit-tests.c | 79 +++++++++++---------
>   1 file changed, 44 insertions(+), 35 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 6f5e404a446c..1a33db281f8a 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -86,39 +86,24 @@ typedef struct {
>   	uffd_test_case_ops_t *test_case_ops;
>   } uffd_test_case_t;
>   
> -static void uffd_test_report(void)
> -{
> -	printf("Userfaults unit tests: pass=%u, skip=%u, fail=%u (total=%u)\n",
> -	       ksft_get_pass_cnt(),
> -	       ksft_get_xskip_cnt(),
> -	       ksft_get_fail_cnt(),
> -	       ksft_test_num());
> -}
> +static char current_test[256];
>   
>   static void uffd_test_pass(void)
>   {
> -	printf("done\n");
> -	ksft_inc_pass_cnt();
> +	ksft_test_result_pass("%s\n", current_test);
>   }
>   
>   #define  uffd_test_start(...)  do {		\
> -		printf("Testing ");		\
> -		printf(__VA_ARGS__);		\
> -		printf("... ");			\
> -		fflush(stdout);			\
> +		snprintf(current_test, sizeof(current_test), __VA_ARGS__); \
>   	} while (0)
>   
>   #define  uffd_test_fail(...)  do {		\
> -		printf("failed [reason: ");	\
> -		printf(__VA_ARGS__);		\
> -		printf("]\n");			\
> -		ksft_inc_fail_cnt();		\
> +		ksft_test_result_fail("%s\n", current_test);	\
>   	} while (0)
>   
>   static void uffd_test_skip(const char *message)
>   {
> -	printf("skipped [reason: %s]\n", message);
> -	ksft_inc_xskip_cnt();
> +	ksft_test_result_skip("%s (%s)\n", current_test, message);
>   }
>   
>   /*
> @@ -1701,6 +1686,26 @@ static void usage(const char *prog)
>   	exit(KSFT_FAIL);
>   }
>   
> +static int uffd_count_tests(int n_tests, int n_mems, const char *test_filter)
> +{
> +	uffd_test_case_t *test;
> +	int i, j, count = 0;
> +
> +	if (!test_filter)
> +		count += 2;	/* test_uffd_api(false) + test_uffd_api(true) */
> +
> +	for (i = 0; i < n_tests; i++) {
> +		test = &uffd_tests[i];
> +		if (test_filter && !strstr(test->name, test_filter))
> +			continue;
> +		for (j = 0; j < n_mems; j++)
> +			if (test->mem_targets & mem_types[j].mem_flag)
> +				count++;
> +	}
> +
> +	return count;
> +}
> +
>   int main(int argc, char *argv[])
>   {
>   	int n_tests = sizeof(uffd_tests) / sizeof(uffd_test_case_t);
> @@ -1730,24 +1735,31 @@ int main(int argc, char *argv[])
>   		}
>   	}
>   
> -	if (!test_filter && !list_only) {
> +	if (list_only) {
> +		for (i = 0; i < n_tests; i++) {
> +			test = &uffd_tests[i];
> +			if (test_filter && !strstr(test->name, test_filter))
> +				continue;
> +			printf("%s\n", test->name);
> +		}
> +		return KSFT_PASS;
> +	}
> +
> +	ksft_print_header();
> +	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
> +
> +	if (!test_filter) {
>   		has_uffd = test_uffd_api(false);
>   		has_uffd |= test_uffd_api(true);
>   
> -		if (!has_uffd) {
> -			printf("Userfaultfd not supported or unprivileged, skip all tests\n");
> -			exit(KSFT_SKIP);
> -		}
> +		if (!has_uffd)
> +			ksft_exit_skip("Userfaultfd not supported or unprivileged\n");
>   	}
>   
>   	for (i = 0; i < n_tests; i++) {
>   		test = &uffd_tests[i];
>   		if (test_filter && !strstr(test->name, test_filter))
>   			continue;
> -		if (list_only) {
> -			printf("%s\n", test->name);
> -			continue;
> -		}
>   		for (j = 0; j < n_mems; j++) {
>   			mem_type = &mem_types[j];
>   
> @@ -1794,10 +1806,7 @@ int main(int argc, char *argv[])
>   		}
>   	}
>   
> -	if (!list_only)
> -		uffd_test_report();
> -
> -	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
> +	ksft_finished();
>   }
>   
>   #else /* __NR_userfaultfd */
> @@ -1806,8 +1815,8 @@ int main(int argc, char *argv[])
>   
>   int main(void)
>   {
> -	printf("Skipping %s (missing __NR_userfaultfd)\n", __file__);
> -	return KSFT_SKIP;
> +	ksft_print_header();
> +	ksft_exit_skip("missing __NR_userfaultfd definition\n");
>   }
>   
>   #endif /* __NR_userfaultfd */


LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet


