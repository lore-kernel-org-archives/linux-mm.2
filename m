Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E86FA0C2C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0E36B0092; Wed, 15 Apr 2026 01:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482B86B0093; Wed, 15 Apr 2026 01:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370986B0095; Wed, 15 Apr 2026 01:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28C0D6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:40:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DADA5C1940
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:40:00 +0000 (UTC)
X-FDA: 84659688960.04.D8D9246
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7391940008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:39:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TJmXuBSr;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776231598; a=rsa-sha256;
	cv=none;
	b=QSnp+F/8krf9tDqVMolr6J2cnSGvF4bVFtCxRPW8Z5YbtwTmDC7X6DBf+tG2Dr9xVBRoIe
	L2yCEwI+YYs03KEHuGoecw/Pjre8odPfrHBuREmstOyFWZOk6Eh4l2pAOkEBHprElBRJiH
	4HOxm4VouzNGS91oIopuZzZdpyFohDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776231598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0n6HTLG7e9ILzs+XjWC2pf1cq5ZuUAOHbj2wjvUJB/U=;
	b=SH8dEJ7ot3BlSGAF/kAFRIsoQOZfw3Q01m5SA45b6M0XA+tfPkLcL6/89LRkzoDjUdrUWx
	GGOgwyS7Ks1JqpJoCKc0WQzeRtAKH+4XSvurTqfGI+bc33XUynKZLqXq1qUZG1VGhfvuiR
	CH3fai5s0wwPg7DQrWd6mvMdLVD3fH4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TJmXuBSr;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EGH51a2451334;
	Wed, 15 Apr 2026 05:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0n6HTL
	G7e9ILzs+XjWC2pf1cq5ZuUAOHbj2wjvUJB/U=; b=TJmXuBSr0craOeSZoNVOF2
	WIXP+BbTWB3/xzA36zyRvOtFKOEbNTM5ZEHRJsyjZiwMo00Zi7r561neZ5duSl68
	zwqA1Wv5Nga0p3LCNmALKtz7tx5V0opzVM+7ngmxz5zrvQXoxWzHh8NJBElpx8ah
	fQv4Z1fAjUs9f9lim2O8yeAQKgSY345nILQjEjxqECk98uHrTpjzwmxZwaG8QI7P
	tal2DT8c1Srjpf96HA+BNHIjsnGR17RHGCSfmigI3ZlCYTmM72Ulq9UPNo0RJDRw
	WX5mpOk5ifxdtf2Ta93ZRLSxmbRvlb/mVq+EPD3J1KSvYuzzgjWlk/EVNg1hBpfw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89m644j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 05:39:52 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63F4XdgK025841;
	Wed, 15 Apr 2026 05:39:52 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg3b1mkf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 05:39:52 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63F5dphZ36176138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 05:39:51 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54D0C5804B;
	Wed, 15 Apr 2026 05:39:51 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3A4D58059;
	Wed, 15 Apr 2026 05:39:41 +0000 (GMT)
Received: from [9.124.217.38] (unknown [9.124.217.38])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Apr 2026 05:39:41 +0000 (GMT)
Message-ID: <b1fc0aac-9619-4240-86f7-abe0d68f2798@linux.ibm.com>
Date: Wed, 15 Apr 2026 11:09:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/53] selftests/mm: khugepaged: group tests in an array
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,
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
 <1524b172-a5f7-4fe0-9bb4-29287762dbff@linux.ibm.com>
 <ad5kXC-F_YyWD590@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <ad5kXC-F_YyWD590@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69df24a9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=xH5FL6UbJZk6oSiiWT0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: p8gPax9qbfzKNyrdtcYTznrGJBiguDjm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDA0NyBTYWx0ZWRfX0QNXQu2az0po
 QJumG+aWfNLS+XCDj+rXLMGOMe6w+46T2Knu1R/znRaeDfJguPdioqbuFQ5fbUhFeH6xHbTPh50
 SmoqjBCEHVQzLcSQlN8gxJS8xkYTE5pEfoSM+5DIh8qE5YGtTgD0YTombZ/Ama3MhKouwv5LBmW
 eI+EbCeBrqWVM/0teamekQG1Z/sK8rMHrsHfxP+Ven1BXhJNFzK0CGGeen4adRBnnFV9vfRUWeQ
 NgKhn0sOd75YpDsSw3MCOYGg4D7HmN6vn+xCQzt7/W7b1cTD1cSt12G4SQmCwquPiMkDjtOKOtW
 AKOBVWwU7rnUt3l0OJftsqQwpiT/WPGOEHAdGfRIIYFCmoCCC1tUyBSENBL727Z3LaDdinJJgL8
 AVKbu1Q1Ib3oPmcXBLQNYeyM+1uEZhE2/UuaT3rLlZZUf4ugmcwWf55VZ/CHX4YCLxDnxiGkuA6
 F0VvY8VejlTmzvkYjig==
X-Proofpoint-ORIG-GUID: tVSaGMBHpoh9ki9OrGwK4cAX9J672Sit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150047
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7391940008
X-Stat-Signature: qomdw6ndprde3ss58mb8c3cko6hrn6j8
X-HE-Tag: 1776231598-333767
X-HE-Meta: U2FsdGVkX18ryvfgO/4xrfwPptGvA9BmuG98AjhW/h0AHol9BZFW+CULMT0QyS8Fx7Fc7N71vdrlIp1l8Xr/6K8mc26l4/Xby38YU5pCYtmL6KiaAZ7EUifUcHan2P7K/08zKaa/JFcfHuChDOIq2Jtl2OosNrYHkXD4iGZJOJxFAX7axU3XhmS0hcp6/2FoDZzpRg3iUb6f4GWfuPGYhgKHILKfUobwSkBbEDWPfyRd80261pubddIMaAwqmBOBfqIPBtUUYyXRIrKElTWtVsj4zOO1Itgn8IwI9+f6bcDcUDRNAUR+xFHcocYQ6vvOCNKJ8a120YSZiLcIHA0YhEiSaYrm+vx/Q7sUqdGuUfCHfag+KqMBxXhdJGkCJzp3Vz9f404YY6WP8PoCRf3YUm46n21Bu6QGgh65TUDVjBwNxL+GVJpEdhNacCs98riv1gnLridOcsBAZMatZE4HSDW+LbEf1l+EFqPTkNDaDBHKTXCKG6wJDuJXJHZmyNKA/z182OCfp5sw0ziWjafXY7YJergXsOHBIRKTkkv6e3HfWoFjA4gUk+9DU4mj1MocPeaKEYugJHK4FKx4kbEEDN4p/WGAX/0BQOJ09w1BZinpWwL9ozWrg6cooZ9WBR0ew0djfbzGt7fO/WBvNKvrf0tTc5ECGhr9jCh+GiFatHA7pv99OSm0/DEx8wNZz3j4f7tVXcz92gnAeHA1D676U6MOa3gWmrBGt/HxKzmDWq7dCF6+ox1z3APeAMxmw5lIXVGKoXUQH4Q/hT5OBeDBj0JxiKOBOWCir0b1uqHQjhlNe/bXQbu8gxWBzZuruIdpoolT+pNU7Z4wpM6F+JMKNCRB7ziM9wEGJmmn1IcSQmuEZUEJxCdO/pojqfvZQ05QpNDhVzxDi5sigQhzqI6deq9+wIjmkytQkHNJvU3anOSdOV03LOdUu8bDP3yLed7cIvQKlpg7YLZNgx3MYtu
 RAYf/Nqm
 TjPy90wqHRfXhM5rswIJUMa3VgxDUIxkh+WhRfIZ4PlzA8UvNnsoMuHtxPqI/d3RGwM9Wk/TrE4C5m6ipsz2O/4Iw9Kb5uUmusCph86Hyr2X9hLmLKj+HChHFW2gXhqLWd1eCCo3LxGsjC9wzCgLrGQhOMrAO2CVgvSx9R5ccW7COG5wrAUHhNYSm6GziA197Fo2BOC2pknfuBdv+Qcb1bMQlkuVITs7ldIBG8jSlS4V66YVFac2EHAgv5ljAgaM6Aitd8awB3RbADyv2nhuEoRrq/iX430/kUpECZ9YekAi2vvCfok19ObnMAzf4oxkRv/203gYCq2V5LHzu4FP0yy7LDA8lLABLtO9Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/14/26 9:29 PM, Mike Rapoport wrote:
> Hi Donet,
>
> On Tue, Apr 14, 2026 at 12:32:48PM +0530, Donet Tom wrote:
>> Hi Mike
>>
>> On 4/6/26 7:46 PM, Mike Rapoport wrote:
>>              get_finfo(argv[1]);
>>       }
>>
>>      +typedef void (*test_fn)(struct collapse_context *c, struct mem_ops *ops);
>>      +
>>      +struct test_case {
>>      +       struct collapse_context *ctx;
>>      +       struct mem_ops *ops;
>>      +       const char *desc;
>>      +       test_fn fn;
>>      +};
>>      +
>>      +#define MAX_TEST_CASES 45
>>
>> I see 48 tests in khugepaged.c, and running khugepaged all:all results in the
>> error below. Should MAX_TEST_CASES be updated to 48 instead?
> I'm going to bump it to 64 to accommodate potential future tests.
>   
>> ./khugepaged all:all .
>> TAP version 13
>> # Save THP and khugepaged settings... OK
>> Bail out! MAX_ADD_CASES is too small
>> # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>> # Restore THP and khugepaged settings... OK
>> # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>>
>>
>>      +static struct test_case test_cases[MAX_TEST_CASES];
>>      +static int nr_test_cases;
>>      +
>>      +#define TEST(t, c, o) do {                                             \
>>      +       if (c && o) {                                                   \
>>      +               if (nr_test_cases >= MAX_TEST_CASES) {                  \
>>
>>
>> I had a small question—since the number of tests is fixed, would this check
>> still be necessary?
>   
> If we add too much tests without updating the maximum we get a nice "Bail
> out" rather than SIGSEGV :)


Thanks for the clarification. It’s good to include this change.


>   
>>      +                       printf("MAX_ADD_CASES is too small\n");         \
>>      +                       exit(EXIT_FAILURE);                             \
>>      +               }                                                       \
>>      +               test_cases[nr_test_cases++] = (struct test_case){       \
>>      +                       .ctx    = c,                                    \
>>      +                       .ops    = o,                                    \
>>      +                       .desc   = #t,                                   \
>>      +                       .fn     = t,                                    \
>>      +               };                                                      \
>>      +       }                                                               \
>>      +       } while (0)
>>      +
>>       int main(int argc, char **argv)
>>       {
>>              int hpage_pmd_order;
>>      @@ -1216,13 +1244,6 @@ int main(int argc, char **argv)
>>
>>              alloc_at_fault();
>>
>>      -#define TEST(t, c, o) do { \
>>      -       if (c && o) { \
>>      -               printf("\nRun test: " #t " (%s:%s)\n", c->name, o->name); \
>>      -               t(c, o); \
>>      -       } \
>>      -       } while (0)
>>      -
>>              TEST(collapse_full, khugepaged_context, anon_ops);
>>              TEST(collapse_full, khugepaged_context, file_ops);
>>              TEST(collapse_full, khugepaged_context, shmem_ops);
>>      @@ -1284,5 +1305,13 @@ int main(int argc, char **argv)
>>              TEST(madvise_retracted_page_tables, madvise_context, file_ops);
>>              TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
>>
>>      +       for (int i = 0; i < nr_test_cases; i++) {
>>      +               struct test_case *t = &test_cases[i];
>>      +
>>      +               exit_status = KSFT_PASS;
>>      +               printf("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
>>      +               t->fn(t->ctx, t->ops);
>>      +       }
>>      +
>>              restore_settings(0);
>>       }
>>
>>
>> -Donet
>>

