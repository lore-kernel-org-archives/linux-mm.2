Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C380FCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F083B8E0014; Wed, 17 Sep 2025 10:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E921F8E0003; Wed, 17 Sep 2025 10:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59F98E0014; Wed, 17 Sep 2025 10:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFBA98E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:46:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81E401A059B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:46:09 +0000 (UTC)
X-FDA: 83899017258.14.CD6E7C4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id E64FD140013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:46:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dZtXKNF+;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758120367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4c5NoP+/KMEyuE6stnFP+rnvUtBaPSsbrRLQHfCq0rk=;
	b=fz0lqqRgJ6cAZGDthYJtsJlS87L3mj4JIzcq0LozFM7/3ax/gRSgpbHtyQInCf+nnm7MYV
	I7aRv+JegB9NJbs1rQkdFi2ztGAUCzabaB9Q9kUERYfLtH8e83gEOq2jiEirSVUZJUC+/O
	bM54OLcu7Iir1FqItbBYA4oFCeD/3HQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dZtXKNF+;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758120367; a=rsa-sha256;
	cv=none;
	b=ewYB6WZA18K0V7nVzzgMdXNYqHD2yr/VptPBeJPn4T/WCujTvzj/s0Jy1Xp8dZtnB3ZNE9
	dYakkFSWTw79edej3czxJoA3ENXfv1WB9RBibe/g8lsHQj57zxkU29aI4/rFS8P/28nfCM
	Yz8W4v1AstB0OikpeRRt6ixPzQ/qIsk=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HBCqL8027546;
	Wed, 17 Sep 2025 14:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4c5NoP
	+/KMEyuE6stnFP+rnvUtBaPSsbrRLQHfCq0rk=; b=dZtXKNF+f+8v5kciT43b8v
	pU6ElQpsAMOYUajZ1Vt3XObPwHDGo8+4eXLhYsToHruYjIcrSgv68yTqXIkxLnyp
	ilWuPbkwFdKGQfnokAlFDtGGq7jq9d0JOmUib+VqYUlhft+wifz33dP2Eg4if4LA
	KShLo1rWYbwmVg49LPHQWaZbCorYVTSJd9NBm1Ju8ISK+jqzP0QGfvoC9Was9JfX
	g9kZBJ1pux5CVDda8e+kUukBQLov/R9MWvjsvwxVINFvX/IHX26h6S3k+16HmeGt
	QPB7ltwMG3bjv9rgJKY4KoXeey4P278C/8SDOiAbFzal5WD3WSV9diA/naxZEDaA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4p4dbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:46:05 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58HEXE0E009956;
	Wed, 17 Sep 2025 14:46:04 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4p4dbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:46:04 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HDLA93006385;
	Wed, 17 Sep 2025 14:46:03 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu9yxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:46:03 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HEk2SA26018376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 14:46:03 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D48C558060;
	Wed, 17 Sep 2025 14:46:02 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8ACA58055;
	Wed, 17 Sep 2025 14:45:59 +0000 (GMT)
Received: from [9.109.215.183] (unknown [9.109.215.183])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 14:45:59 +0000 (GMT)
Message-ID: <659ba2d4-fee3-410d-b611-04a3586b5bb7@linux.ibm.com>
Date: Wed, 17 Sep 2025 20:15:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] selftests/mm: Added fork inheritance test for
 ksm_merging_pages counter
To: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <f07c901d4b6b1d1c15a8c1bbd324367d6135d0a3.1757946863.git.donettom@linux.ibm.com>
 <26e38fe5-e6c4-4678-8056-95c0ff4350e6@redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <26e38fe5-e6c4-4678-8056-95c0ff4350e6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfXwnycUZ3Fld+5
 2YguMIDES/qowsvDjfe2GgPNRUMYd+a7ylomoGYeDDs82zO7tkSbrFmXCBIV5cJYqoQoxNamT+l
 F0q5Jm28Hv92BRPZ1HRy9xYfG7qDwp73ijaOLOE5MP0bau/2VL86gKFoHsSnKGaTPbIWcvbbdjQ
 WbQ+lymbj7V9dYZ8xNAq1kfwveu0YegRjHPJmo5v2zZG5lWW+Fj/eT8FjjIy9yJFovAqwPJIFIZ
 Xf6Lp1GIgyFovlRCxZJZ/QxzBxmQYEQ6WlnqTndi1lfkJmINtOlWwspS3BE9y/PrCRt8F7PQs3h
 j9HQmxvgOL3HoHXTDZxrMNN7lJIwS6c4+lPp8bTm9EUD9WeOo5Ji9ITacNA2JPuRxpnbcT6aMVU
 RVCc6QbR
X-Proofpoint-ORIG-GUID: 8VeRrE0Wp5XNH9_jmiJFajk_m7pZrsbs
X-Proofpoint-GUID: cPyzT-UFtYtpAzuBmZiqRj02G87oK7XS
X-Authority-Analysis: v=2.4 cv=cNzgskeN c=1 sm=1 tr=0 ts=68cac9ad cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=Z4megsD6RVqFqqBZ_rsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204
X-Rspamd-Queue-Id: E64FD140013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1u4imndf66t7brdo6uu3s4pamukgfehw
X-HE-Tag: 1758120366-36891
X-HE-Meta: U2FsdGVkX1+06Rl1wxAFf+SNV5V+6smk7NJKeR3iN2pUxL1ZRLrnxghXIQGzevBj0YOdJ5RLVy0TAXn2BDTzTzTZ9KtKq0Zwm7bv4OD4gvjsTk+pdNAI1t8PIAcbInJz5+8ZT1hp2QPH+Qi8s2bpBLr4pa7ActpqWaPw164nByBvF97gqXPibwO4sowxtLWNfUPjiF5WTVjyjaQS5GqCv6vFaVPWX5v4XMYxlLnlZ9ua+cVctkIQoGMTTg4Ku/PwFvJsZEPJQQJ1mr64QIFGZUbY7DMl6kSlH52qWKNiNxJl6o9wCdRxPOTKhfB3bqEdNNgS0KJfOSi/PhX77CSZlPlRCISz5dluQWSU18iBjWLMtsozOn3h96z+uAMCT+n8KSBTUnoXyvqEYNu40WDUlFo1Tcld1/LdJwv6+G0BaRzJHre2oADZyKixJIOepbPeq0lKPzdoe0m64iWGXiBTlfi7pPfoKPm99PMWjJlbmjFUljnY3BkKrYrO27yJFR77pDExWUoSNyH52n95n4peUT/x80RJQN274VqY5kVIGQBH4U2JYIPGE4+V4WMnIMG9vvkm0a8US1yM0QFpIg6nPxsugqdppwd/uSCRB3hAnWSzKURWkaMrxyy/TVv6szlvD+uXh7TbOC4hMRHjAViViMSAdDDGqUdrayCCzJngwWgNNXj3Y5WqwnXRnNl8ZFqqml4E4xLEK8qjYgvJMbwla37g/vrE7ACriP1zdolREYkW4Ys1WehEBvjI5fAf5qCBNVHb5bZmvZCxbGYTb9BH73iKYd4tSo0ntnbXOUYWN4UwC8qRBRUCz8cGGkybOyFOZ/6y6f1y6rzi3sJWMp+bcXDVy+JVfHsWA99K6Q1v1mNvLPcuEsBjpid0JQ5S/plgxRU3Qu5SkPM2a9sUe32vGTo4QnmGahm1WN8uotHpF7yv9AwZW6GEgkEKHFSVwKeJnqBc/L9YVKeCJ+ec5hs
 6clMz8VN
 kPfwN8EIjnbslY+mDsaaVjwz97SO/C0Jhrxt/nkHJGnXFJtTQqZi7t7YnSOBMNrwvhgmOEECCnCyDJKB6J5YW2ASSpg+U18LR9m9e1ZmLXtfY2E441ePkNz+vw1bBk127Qq3ghPOAM9mt6Fc4kjppFEX2YzJ+QriGiLSObkuvlToERAzVavOf8s09x23ggU58W6pINJf6BU0UJZPo2ltsmASR5lvggfKytv57aOLHqZkqT3SfV3jSKO3P7Fxiro0eMi7ifPa85c7xlJwNLHZ/WoUwNXBImqPYcM7rd+yiQTfCFjZmNnVxQv+EQZawohW6oXaoL2FSOBz6OyriMhYoMdDuwnXAJGBedMQc+E+ur5cUfSAvSxvAyPGuL9J0eUZuRujYPZh4xJB6Vtep4z2TmLx5dn46Uy82oq3HMVSX7oEix1XpuBuVxRDvfn7q/zeyn02iuZPzF8UUlyk1UtmC48uV7fGKTrJVV6XFW03oND3H8KAM3Qz39TyVg7p+0oLPIPGukbxhuXJHovi8aBNiKRJF6kwxlRQ6u7J9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/17/25 6:45 PM, David Hildenbrand wrote:
> On 15.09.25 17:03, Donet Tom wrote:
>> Added a new selftest to verify whether the `ksm_merging_pages` counter
>> in `mm_struct` is not inherited by a child process after fork. This 
>> helps
>> ensure correctness of KSM accounting across process creation.
>>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>   .../selftests/mm/ksm_functional_tests.c       | 42 ++++++++++++++++++-
>>   1 file changed, 41 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c 
>> b/tools/testing/selftests/mm/ksm_functional_tests.c
>> index 712f43c87736..645cefba2126 100644
>> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
>> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>> @@ -602,6 +602,45 @@ static void test_prot_none(void)
>>       munmap(map, size);
>>   }
>>   +static void test_fork_ksm_merging_page_count(void)
>> +{
>> +    const unsigned int size = 2 * MiB;
>> +    char *map;
>> +    pid_t child_pid;
>> +    int status;
>> +
>> +    ksft_print_msg("[RUN] %s\n", __func__);
>> +
>> +    map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, 
>> KSM_MERGE_MADVISE);
>> +    if (map == MAP_FAILED)
>> +        return;
>> +
>> +    child_pid = fork();
>> +    if (!child_pid) {
>> +        init_global_file_handles();
>> +        exit(ksm_get_self_merging_pages());
>> +    } else if (child_pid < 0) {
>> +        ksft_test_result_fail("fork() failed\n");
>> +        return;
>
> Probably
>     goto out;
>
> in all these fail cases
>
>> +    }
>> +
>> +    if (waitpid(child_pid, &status, 0) < 0) {
>> +        ksft_test_result_fail("waitpid() failed\n");
>> +        return;
>> +    }
>> +
>> +    status = WEXITSTATUS(status);
>> +    if (status) {
>> +        ksft_test_result_fail("ksm_merging_page in child: %d\n", 
>> status);
>> +        return;
>> +    }
>> +
>> +    ksft_test_result_pass("ksm_merging_pages is not inherited after 
>> fork\n");
>> +
>
> And have
>
>     out:
>
> here


Sure, I will send a v3 with this change.


>
> With that:
>
> Acked-by: David Hildenbrand <david@redhat.com>
>

