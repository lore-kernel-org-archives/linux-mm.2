Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A46ACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82038E0006; Wed, 27 Aug 2025 14:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59838E0001; Wed, 27 Aug 2025 14:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6FC48E0006; Wed, 27 Aug 2025 14:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDBBE8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:03:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DE1ABB6E6
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:03:22 +0000 (UTC)
X-FDA: 83823309444.24.97F7A6B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id BFEFB140011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:03:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AMFGtk0r;
	spf=pass (imf26.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756317800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsicJFyUGzqrRincdd9SL6qrr3FQUyZ32w3XHMjc0jQ=;
	b=M61eUkP3UCh3fRwyitbkEFC5OHyLvGtXn5I58w6nrxC5/mPMBk6UpqvFhCqH+zYKlW+UsA
	+li99XI7zzEsdoiVmzEFB9OmH0O98EPtBqmUk0xcewqETvsWV3JSmOxe1xBRkOtsYcNMpo
	9nv0vGOWZRar3VLEpukRjT67gFIbjs4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AMFGtk0r;
	spf=pass (imf26.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756317800; a=rsa-sha256;
	cv=none;
	b=UxIfinESjPY2I9VRUOTRWlwLtWiw2KhG+0q1kdcAQBNQhjZBebXN8aEvqo9F7MOafwyjPj
	NCQURAS4bmw6dPQW1WjtFjzurDnN6oqNCHEfFaeCvH2LceJQLBGxg4JYP/lxtLan9MbFBI
	qJqufW7Dvf1G1Z+tLQ+4PusdT2hYtAw=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57REWA2h029170;
	Wed, 27 Aug 2025 18:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tsicJF
	yUGzqrRincdd9SL6qrr3FQUyZ32w3XHMjc0jQ=; b=AMFGtk0r/dDIFVGJulW71C
	G8/+UdBpoQyCiX/OV0hObViy7xNV2hR8piNzV4J7kl4krhS5rKnZQfdTjWHLaOrK
	JoqtiyteFLCwAAUYy5J9J8U2+yWqzQULraUL9R2nuJ1a/VqF/L1DRXj5wC/HRrg4
	58Uh/TaqISY7JhLCBPqAyJv0AH0uhhlu7HyaooI/B3hXFoxNpjmI8/oPI8pbnd2B
	fjDYXzzV7jIo1g6xdvaD5/QlwtEah4kcHfQDeN1URXzIwr6v9R/e845dqr+4pnH3
	Q16tlxbzukQXpGvytmtfk7uNpdkbeHcoOla0QBtawXJWAckhDfGfpESypRT2bE2A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q975cvq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:03:18 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57RI3H83002054;
	Wed, 27 Aug 2025 18:03:17 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q975cvq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:03:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57RFckvt020799;
	Wed, 27 Aug 2025 18:03:16 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48qrc0s9w7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:03:16 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57RI3Fd665339766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 18:03:15 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5307258043;
	Wed, 27 Aug 2025 18:03:15 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B8BD58060;
	Wed, 27 Aug 2025 18:03:12 +0000 (GMT)
Received: from [9.124.214.234] (unknown [9.124.214.234])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 27 Aug 2025 18:03:12 +0000 (GMT)
Message-ID: <0c724a5c-3317-4bc6-b9ba-98b073934b66@linux.ibm.com>
Date: Wed, 27 Aug 2025 23:33:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: add fork inheritance test for
 ksm_merging_pages counter
To: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
 <88d6d5f08ff119625fa9accaa7b849dd77f9df25.1756211338.git.donettom@linux.ibm.com>
 <ba6d3e50-d8dc-4ee4-ae44-bc1b57e4a2dd@redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <ba6d3e50-d8dc-4ee4-ae44-bc1b57e4a2dd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YCNmbhLy-s6QMExH8r-QNmM3LVWDhq35
X-Proofpoint-ORIG-GUID: Usxyx_aXpToUZfM8V5gW_Hqd6HlYMoj6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDA3MSBTYWx0ZWRfX5jaV89N6LQJn
 A11Dun0fx97w01sjRhmsOyjj7Ztb2wEY7jLqcGfJ/95KwA65BkYhW49KPlj4c/PxWFzhSAb1za4
 iFj31Njn6SUQA41/TyRgpspHrnnZlnShjpFogom8KlKBFcwQMnN2j3+r0bHwJD9Y0uHyySqTNu6
 Abp7AeE1WOE1nwh9q5ELKHdBDA5tggNQfv/bwx4PkI5ohTXqu/P+nPTLRkV18R7/izfv5rKKTuk
 Pqp9df0wHjnTqWkJz4wKrCv8m9q68EUCmXSikqT/jS4JbZg33k7JD978bQLvlaaL6qIPxPlaDvD
 QyHxRRrZS5T7s+EJLi9UvYhraj2LSVZIcWtLP4XgDHRLxNTc5RG9RQmKWo16Z8bpCokXC6ArUFN
 ICq0Rsvj
X-Authority-Analysis: v=2.4 cv=RtDFLDmK c=1 sm=1 tr=0 ts=68af4866 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=BrG3DMFQotyEFiz2VCoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230071
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BFEFB140011
X-Stat-Signature: qi61e37jjz55b6cbhkas1kzqyrdzgien
X-Rspam-User: 
X-HE-Tag: 1756317799-732819
X-HE-Meta: U2FsdGVkX18y+xOncj474Wl2x/2uEz0Am6zvyl+aOo4dDEG04NBH9LTP7WxkuK4krdmBSm1tAUqQY+fVlsw1fGGJK39bxjMKihLfuAjqt/Q5jVcT79e5svlcnO2qJhJJhjdcSz/0l9rzPtwWo4XHLqB2st5h1/D6Cor7dfVoSiNuIe1eDrq+uMeT2ti1GVYFetZ+68hV9ihQCnO586yImMKBIIsYaTo+8aQ47y+1Ais/u3YLcZYae9M6Yx5L8qEZFdEIFZBiZEp5xNxpwvechaQRMHFoLomMJbfxCTgpZGyc7S/nLDeHT8HSrSItowlcbnH79CAQjA+2IwUbv6+P7CWH3NzlNMKxfoiiSNXPG09pnbo/9ZDwYmYjnaFLdtlJ2g98sjSxI4t7u0C0qHCMOWMUY8UJBhpboTmvnSsDvVuAnIYkyuhWtgrsw1G5XENeP7064fYCHTJ97lUil2q+Lb0yaod/HhNIMqZ6vnZxig3j95O/NA3h0whwHJfxJu5WGb1mXiJ4KWIzj8nK8nUeSaZzdddBvSZ7nRdHNzjirGCiaPF6TMQm3t+0GB1tCEqyeqW60zG//oI3f92Ph2MWr+U5BIPiIU0e3hHZR77pF9EA4t0/tpCDpk7HYwUW6T7Sbe2/ZybWP4LmOUf/FKmtZetp4TES2a7P9D3dwbDxp+07wV7hwObS6auCtWbbCeCssJCMN0mPyA4wpotwBZoHk5PzhK7F8vypz+FlCdIIVpdiJwUy4oWRpyHF1o1UoAD5cjOMZCBjoMbmH34pcrE7nqEA7yo/eU8F48m5dW9/LkwTspsSynbviP48i7dcYJVmFAZsXDB1hbh4KfjC7B9z0wLBPlrJaojegTHdbE7xNOBYy+QngjYImzXVMOAVVucVaYgjpB4DxxlWyNRwUH2wEIIvjughxUfEMNmvE/pCJbmhaVaCIJveRC5Fy4ZazskoaUh1T1mTGb/H5iJkWn7
 HjrtU/MA
 eOGG5S808V4OZbXtpTccDJ0swgJh8cApsv7EKhh+n1fnVOXrkJm0bgvny6o1J3UknfattZf7kxzZYZrswoS92PbuKiX44eKBXIc86SR/D61uCNeTSa6qIpR96RSzEHKkfb18Kd99ODcII+/p/y+gG3qiPSocAkEh7qqnbNA/aj8OKSWGdT8LO6T1yxLlbUgnkM8JH/zD6XU2GLHgSsGLBsVn3auJaL5xEdYKuvSPeXuJOYZmaCjPrJ7u7CaC0SpPBB06aOciHrNkZfhDuqtHWN7VwR4MCMVDkg3/v7/+Vb3HoOQx5IMnRAzUQZkKPelFn7b0uXFwEXe3zAR3EDyBuWYRcy3kgUmm1Ya4317FpZh0jTKM02R7wyOGyzqJ+Q1glGUNFfUnamC28mZ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David

On 8/26/25 6:52 PM, David Hildenbrand wrote:
> On 26.08.25 14:49, Donet Tom wrote:
>> Add a new selftest to verify whether the `ksm_merging_pages` counter
>
> "to verify ... is *not* inherited" ?
>
I will change it in next version.

>
>
>> in `mm_struct` is inherited by a child process after fork. This helps
>> ensure correctness of KSM accounting across process creation.
>>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>   .../selftests/mm/ksm_functional_tests.c       | 42 ++++++++++++++++++-
>>   1 file changed, 41 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c 
>> b/tools/testing/selftests/mm/ksm_functional_tests.c
>> index 712f43c87736..d971394c9567 100644
>> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
>> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>> @@ -602,6 +602,45 @@ static void test_prot_none(void)
>>       munmap(map, size);
>>   }
>>   +static void test_fork_ksm_merging_page(void)
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
>> +        int mpages;
>> +
>> +        init_global_file_handles();
>> +        mpages = ksm_get_self_merging_pages();
>> +        if (mpages > 0)
>> +            ksft_test_result_fail("ksm_merging_page in child: %d\n", 
>> mpages);
>> +
>> +        exit(0);
>> +    } else if (child_pid < 0) {
>> +        ksft_test_result_fail("fork() failed\n");
>> +        return;
>> +    }
>> +
>> +    if (waitpid(child_pid, &status, 0) < 0) {
>> +        ksft_test_result_fail("waitpid() failed\n");
>> +        return;
>> +    }
>> +
>> +    ksft_test_result_pass("ksm_merging_pages is not inherited after 
>> fork\n");
>
> Won't this trigger a fail in the child and a pass in the parent process?
>
> You should likely instead let the child return the result (or the 
> number) and check that here.


Thanks for pointing this out. I will make the change in the next version



