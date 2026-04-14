Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F22F531F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BB06B0088; Tue, 14 Apr 2026 03:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC486B008A; Tue, 14 Apr 2026 03:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB616B0092; Tue, 14 Apr 2026 03:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B96E6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:03:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71C2413AD2B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:03:12 +0000 (UTC)
X-FDA: 84656269824.20.EC46176
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD343140006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:03:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bCIZf3nP;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776150190; a=rsa-sha256;
	cv=none;
	b=rdaBITplurVb7mdVsbkSsWyrgZEaHx4nBlieRnMHqEsEgYEA4ZTCZxHK4LCGCcXxhulKSm
	tnSqRstejSok5ePUHJSPFWoRfw34+Ni7h1wWn2XLn97IZcIimA8YObgIwAH0c2lA93PHyE
	73kZojuu95rZ7Qewyy1/EUZ+vKIbmK4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bCIZf3nP;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776150190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQvv5Hf2M5sv/4kjwRMzCTqS3s/DKy3Zr5s2bA0rr7c=;
	b=ijxkxBowvlROynh5SYf44mFVGqvoUcjDn3N971/qyMnNWGlfFeq3y25JReEu4ehyihmyc1
	w8ttjX856uzrT8KP5t4FNz/jaPkF+ot4DaCxyoIOlxqm8Esa5/7ZT7WpqrCcj8B8x77ksK
	5p1UyzKSBUmMUXVpDPyhgIL3b48HJ6s=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLId8L1843048;
	Tue, 14 Apr 2026 07:03:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=TQvv5Hf2M5sv/4kjwRMzCTqS3s/DKy
	3Zr5s2bA0rr7c=; b=bCIZf3nPLdLU3P+nY2+bxJmaRicUjp0bVXnMacLLG2X4sw
	/R23yyhgekJru4yA2E95oq2b14SckGVqZB23VJUNJoPlbu/IdH6+d+LdXV8UKyuq
	v2p703usbtaUEBShqurhOBJp43wWRRaQM+d9Q7EX751HlIAwAIHDWUC3u+teP3G5
	cdhv315TewVxo9o/J/7RdK94MqxQT5a8/JPAdELleMZODwsQUMtJMjRSncYdJRrh
	k5Ke6wOiAl9SWFny4iBDQM7IRI8Okrljlwhn16UPatzhbWFmzlvQ4XZxvDG5Rgh9
	glcZ8WmIMyX+nSwK9Awd+H8Kyj5pqUYF2Gd3eu4Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mhgn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 07:03:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E605xS025862;
	Tue, 14 Apr 2026 07:03:00 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujg6ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 07:03:00 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E72xM621496528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 07:02:59 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 361CD58068;
	Tue, 14 Apr 2026 07:02:59 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EEEC58055;
	Tue, 14 Apr 2026 07:02:50 +0000 (GMT)
Received: from [9.124.214.190] (unknown [9.124.214.190])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 07:02:50 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------JV9s0NqN852IzUja3upxWtmp"
Message-ID: <1524b172-a5f7-4fe0-9bb4-29287762dbff@linux.ibm.com>
Date: Tue, 14 Apr 2026 12:32:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/53] selftests/mm: khugepaged: group tests in an array
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
 <20260406141735.2179309-13-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-13-rppt@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA2MiBTYWx0ZWRfX+6au3xvMgIgk
 P3CgErjEVJmqMZNegU9/D7NSHrQVtAc1PRACFJzW37ktVz4XtlBTqzceftAcsZ6ukb2gcLzJhMS
 5wJj+eeqK55NXv9YjF6M0bGDxT/a1nU+DV9SoeeLNLweufyPa6FNwrTF6JdC8RABff2yqMmrvqS
 138lU1WPW3g1z1svyHNAbUoBvvighXoxhfN1dI/U1EWhAO7bnDT+blu1qaqus9nhfFBNlNhmx5D
 B5Y/At801MyuvCqppxDZoadh0z2hLRa92gzc8Pr3sXu46UKd6rs8qFwIgYaeLHcoxSfMaq38+Cz
 bQwMgIAJoB+7W3iB6lrRVdaWym47XWPyc2q7kbvpK692p2tnNt7F/wXTi+WompbDgHUAEvF8z9Q
 elpM3zHTGiQyFJ2xWywRR2XzZuLM4aKGiPA+NtznlPek2BpSC7nopZzLjea3afPxvJlKXlkT2QV
 XqFBm12To0shQR+1JqQ==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=69dde6a5 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VwQbUJbxAAAA:8
 a=Y-wGZ01TH4-Qvw8gEbcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=jh0Gp1b9Cp5uNb-QS1sA:9 a=sy0sXRxk1YMRXcxa:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-GUID: Y9vVeXL6DIIVjqecYKa4G4caJfjp9MzR
X-Proofpoint-ORIG-GUID: 7kGJMDKc0qPezQ8Ur2ctOp3J5WiF7-oE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140062
X-Rspamd-Queue-Id: DD343140006
X-Stat-Signature: ppjn76jm3zemhn5ub1o3jegz3orrhiij
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776150189-188592
X-HE-Meta: U2FsdGVkX19GWm4R4/UxKNKejV1QvaEY3YAPCtPWeaAaHUwT3YhjssWbTZs16uloGGmeaQnYYwcgbp2z05c2GhJo1haMamHa72uDKhITG8lqvflc+N58jFUENveebhkSqsyrMBXcxx+ZH1/6tXp8oBg/kY2eOY9Z65UXQ5P1I/Lp5sIhmIQnquSkTSDkKd8kJSIi2qqBMZ06OEGx2UqCSH/Dhplti+3PIlOMSa4Y6/nJWqqYuYdiPNqc3HdCh21VYdroqZByQPun+t/m9oHd2xt6SLC/2wyUFnfK1PWwMh0TCurpV86s2AqiWroON0GBylHEdqdioiOEafF3oForQXdIV47dT4/zxCjtf4aYYqmfdsyC+xUXOqfeKKLEPEvgrnocsqSIxnaTgeqEO6CIcSD1+oZknZGv6SCD/hs5NdIfS9zve9XWffiytyNI4XW7yVFAqx2NGS7i4hwMq2mPdNS0e9aqkm0o9G6b5kKwa6NBQiW77JYuJPcft26ozXKbVzOtaHpjFuE2gGgUNMTN/yLlfFkFzhoLWhLLS0ocSqbVBMKtHVY4cbWDg5CxJcOOKtKVcdkEaZC9FJ7L5RiiqbBS9I98Dd0HvAN67+6xav3ri8LNZzW2WRCcE22T5mIwm3JXbaSngVe10Xy5mnRosNdiJu0MO7HpSoXXdAB5GOHEzSewPlGTCJR5Boz6UMYuMJqagTQCv8+LECS6pczKtJmV1/FpYmUs/DlIXVBLm2h9J2vYjh73GQ2D7E5zbYQJzKT4bFlSuHjlbDq6cDe4nnq2Y4XQGXBnS89ZPIMLDzPr7xJSMrVayDXqK1/dRYAjLPIDmdm/0QU8jGrE4UHAi+0z9wywvJ09T3GFcjmNoX6Uy5fnuEMB7e1loule91sGAvn8IkJtHQBA1j7cmWVcShVpe47q/eOWqiYYTpN/AoIByZPL6vg+CQOtNMtSp7qRFxCD+htQqje2PPJhDhP
 KiFUbyIo
 5LA5ApmvOhiIdwyCuswQLw9XVXC+7VezFRDgiDbQyNaoFNO8jF/W4X7hX1s4G10AWT9foCeBan2WfdPoF0F0mpJiHGyFfJEf66FBu6AN2OP3NIhW4NTTC1GT2hPyXws38YlwdDd0nRJpYliYY3piFhEHfWw0wFaDXk1PGvHxHLKosap3h+TzjOe1WPaQFGDzQtqgnkX82wJUqlvoU0Oid+ZqZPLQMTHf/fakVL3BPshJk/WggfX4tbU6pArNc7Zh1/KAo23GDTflQ5HfuxxpPtqJq42syv+h7GmLZ70FetCBDIrauUP/DTpWew9mJIeeEKdEjoYPb3vbQ5XYxXARv6CQdkGUyiOeL5sXsmx3HUTHq3sb+AsTooONdd92q1jwV61Hb/8xL24YsW6QDHjlU7yHczWM30fAUmJgG6p6s3IJEU0iPyLtsoY70qcPk0K4qZqLKkf4QfKIHqN7VFvxd0TDXMTegHzLFz9e73QezolJNtdNvaagDxC/oerE765SxlOZG5C2eeaHahUmzbEYleWR1LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------JV9s0NqN852IzUja3upxWtmp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mike

On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)"<rppt@kernel.org>
>
> Currently khugepaged decides if a test can run using TEST() macro that
> checks what mem_ops and collapse_context are set by the command line
> arguments.
>
> For better compatibility with ksefltest framework, add an array of 'struct
> test_case's and redefine TEST() macro to conditionally add enabled tests to
> that array.
>
> Then execute the enabled test by looping the test_case's array.
>
> Signed-off-by: Mike Rapoport (Microsoft)<rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/khugepaged.c | 43 +++++++++++++++++++++----
>   1 file changed, 36 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index e6fb01ca44ed..1cdc5918d20d 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1161,6 +1161,34 @@ static void parse_test_type(int argc, char **argv)
>   	get_finfo(argv[1]);
>   }
>   
> +typedef void (*test_fn)(struct collapse_context *c, struct mem_ops *ops);
> +
> +struct test_case {
> +	struct collapse_context *ctx;
> +	struct mem_ops *ops;
> +	const char *desc;
> +	test_fn fn;
> +};
> +
> +#define MAX_TEST_CASES 45

I see 48 tests in |khugepaged.c|, and running |khugepaged all:all| 
results in the error below. Should |MAX_TEST_CASES| be updated to 48 
instead?

./khugepaged all:all .
TAP version 13
# Save THP and khugepaged settings... OK
Bail out! MAX_ADD_CASES is too small
# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
# Restore THP and khugepaged settings... OK
# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0


> +static struct test_case test_cases[MAX_TEST_CASES];
> +static int nr_test_cases;
> +
> +#define TEST(t, c, o) do {						\
> +	if (c && o) {							\
> +		if (nr_test_cases >= MAX_TEST_CASES) {			\


I had a small question—since the number of tests is fixed, would this 
check still be necessary?



> +			printf("MAX_ADD_CASES is too small\n");		\
> +			exit(EXIT_FAILURE);				\
> +		}							\
> +		test_cases[nr_test_cases++] = (struct test_case){	\
> +			.ctx	= c,					\
> +			.ops	= o,					\
> +			.desc	= #t,					\
> +			.fn	= t,					\
> +		};							\
> +	}								\
> +	} while (0)
> +
>   int main(int argc, char **argv)
>   {
>   	int hpage_pmd_order;
> @@ -1216,13 +1244,6 @@ int main(int argc, char **argv)
>   
>   	alloc_at_fault();
>   
> -#define TEST(t, c, o) do { \
> -	if (c && o) { \
> -		printf("\nRun test: " #t " (%s:%s)\n", c->name, o->name); \
> -		t(c, o); \
> -	} \
> -	} while (0)
> -
>   	TEST(collapse_full, khugepaged_context, anon_ops);
>   	TEST(collapse_full, khugepaged_context, file_ops);
>   	TEST(collapse_full, khugepaged_context, shmem_ops);
> @@ -1284,5 +1305,13 @@ int main(int argc, char **argv)
>   	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
>   	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
>   
> +	for (int i = 0; i < nr_test_cases; i++) {
> +		struct test_case *t = &test_cases[i];
> +
> +		exit_status = KSFT_PASS;
> +		printf("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
> +		t->fn(t->ctx, t->ops);
> +	}
> +
>   	restore_settings(0);
>   }


-Donet

--------------JV9s0NqN852IzUja3upxWtmp
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi Mike</font></p>
    <div class="moz-cite-prefix">On 4/6/26 7:46 PM, Mike Rapoport wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-13-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">From: "Mike Rapoport (Microsoft)" <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>

Currently khugepaged decides if a test can run using TEST() macro that
checks what mem_ops and collapse_context are set by the command line
arguments.

For better compatibility with ksefltest framework, add an array of 'struct
test_case's and redefine TEST() macro to conditionally add enabled tests to
that array.

Then execute the enabled test by looping the test_case's array.

Signed-off-by: Mike Rapoport (Microsoft) <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>
---
 tools/testing/selftests/mm/khugepaged.c | 43 +++++++++++++++++++++----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index e6fb01ca44ed..1cdc5918d20d 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1161,6 +1161,34 @@ static void parse_test_type(int argc, char **argv)
 	get_finfo(argv[1]);
 }
 
+typedef void (*test_fn)(struct collapse_context *c, struct mem_ops *ops);
+
+struct test_case {
+	struct collapse_context *ctx;
+	struct mem_ops *ops;
+	const char *desc;
+	test_fn fn;
+};
+
+#define MAX_TEST_CASES 45</pre>
    </blockquote>
    <p><font face="monospace">I see 48 tests in <code data-start="113"
          data-end="127">khugepaged.c</code>, and running <code
          data-start="141" data-end="161">khugepaged all:all</code>
        results in the error below. Should <code data-start="197"
          data-end="213">MAX_TEST_CASES</code> be updated to 48 instead?</font></p>
    <p><font face="monospace">./khugepaged all:all .<br>
        TAP version 13<br>
        # Save THP and khugepaged settings... OK<br>
        Bail out! MAX_ADD_CASES is too small<br>
        # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0<br>
        # Restore THP and khugepaged settings... OK<br>
        # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0</font></p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-13-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
+static struct test_case test_cases[MAX_TEST_CASES];
+static int nr_test_cases;
+
+#define TEST(t, c, o) do {						\
+	if (c &amp;&amp; o) {							\
+		if (nr_test_cases &gt;= MAX_TEST_CASES) {			\</pre>
    </blockquote>
    <p><font face="monospace"><br>
      </font></p>
    <p><font face="monospace">I had a small question—since the number of
        tests is fixed, would this check still be necessary?</font></p>
    <p><font face="monospace"><br>
      </font></p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-13-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
+			printf("MAX_ADD_CASES is too small\n");		\
+			exit(EXIT_FAILURE);				\
+		}							\
+		test_cases[nr_test_cases++] = (struct test_case){	\
+			.ctx	= c,					\
+			.ops	= o,					\
+			.desc	= #t,					\
+			.fn	= t,					\
+		};							\
+	}								\
+	} while (0)
+
 int main(int argc, char **argv)
 {
 	int hpage_pmd_order;
@@ -1216,13 +1244,6 @@ int main(int argc, char **argv)
 
 	alloc_at_fault();
 
-#define TEST(t, c, o) do { \
-	if (c &amp;&amp; o) { \
-		printf("\nRun test: " #t " (%s:%s)\n", c-&gt;name, o-&gt;name); \
-		t(c, o); \
-	} \
-	} while (0)
-
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, file_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
@@ -1284,5 +1305,13 @@ int main(int argc, char **argv)
 	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
+	for (int i = 0; i &lt; nr_test_cases; i++) {
+		struct test_case *t = &amp;test_cases[i];
+
+		exit_status = KSFT_PASS;
+		printf("\nRun test: %s: (%s:%s)\n", t-&gt;desc, t-&gt;ctx-&gt;name, t-&gt;ops-&gt;name);
+		t-&gt;fn(t-&gt;ctx, t-&gt;ops);
+	}
+
 	restore_settings(0);
 }</pre>
    </blockquote>
    <p><font face="monospace"><br>
      </font></p>
    <p><font face="monospace">-Donet</font></p>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-13-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------JV9s0NqN852IzUja3upxWtmp--


