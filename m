Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BDD310F6FB5
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C2A6B0096; Wed,  1 Apr 2026 10:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCB66B0098; Wed,  1 Apr 2026 10:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7124B6B0099; Wed,  1 Apr 2026 10:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAE26B0096
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:44:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E810EC8B49
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:44:13 +0000 (UTC)
X-FDA: 84610257186.11.ABD10E0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6215B140004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:44:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OyHRQyM6;
	spf=pass (imf26.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775054651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4ouKinkP7sVz6qmY+ztSsgUI7tqQ1pXjZnV/QMQeBU=;
	b=mhCwOMwP2MtZ+iNPQoyNurCR4COrNJ+vX4hlmhmCU/alGJvqlph9+WEUz0MHmN1ZDMzUpD
	r+lFog1Mvlo+mCiOEyVVcSonaRf+VFmBaKuQMpU4MLuA+jfhw+zroy5HJOd4YNbe8k2GfM
	6S+ZV+3e5GQguo/MtVQuPRHoNacHO9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775054651; a=rsa-sha256;
	cv=none;
	b=eqUq9VC9AjwLHC7q+Y+/sE4iE06EWxPLK5EvjPmPS4jWL14yliScEgEbRi3oQ0Yyjv4+UH
	w2k3ox9TN4i+f7qXBj9Vlpl0JOoU3E4FBfXKTbcgMaQPNtRhs/ujc/I/beczBpLuQSHOF/
	6Gjwf7wJGBL0Z0fUpURIbTdaFnNvKZ4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OyHRQyM6;
	spf=pass (imf26.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631DC5mK367956;
	Wed, 1 Apr 2026 14:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=T4ouKinkP7sVz6qmY+ztSsgUI7tqQ1
	pXjZnV/QMQeBU=; b=OyHRQyM6YewH8vwu3u/+YWfGRbf5gEZ/sYBd/r1TgO73Ao
	9D4FetLtpbYrIGWzPAF/xxJIlRrlScmQyhl76wfaxxxYo2vFOvsAX0pCQqrttNiZ
	oTS4B/EN2gWSiFWSexf5/IhyitGGO45hBaxT8EA92nlfAyu4WA2ZYYUNdIXBd1ib
	8bG2NbimJ5urKYhQzsWLMGXOCg6gDn7UIA8R6zXaolL3D/kGJIpcVUvMKGtvclB9
	9ZzmYLywusSyEq1JRsIChYnACb8ejHKDEeOKe7rOhkBiSfgefjQk/28h5gP/Z49k
	SHKlGMy2p0Cy9CEwt6uh0z02cgh2V+zdv5IzeQyw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66nnrnv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 14:44:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 631AplXw005910;
	Wed, 1 Apr 2026 14:44:04 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6spy64n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 14:44:04 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 631Ei30421168728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Apr 2026 14:44:03 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDBE958055;
	Wed,  1 Apr 2026 14:44:02 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 332785803F;
	Wed,  1 Apr 2026 14:43:56 +0000 (GMT)
Received: from [9.39.18.42] (unknown [9.39.18.42])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Apr 2026 14:43:55 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------j01rMRmFAjBem8boRpENGo7n"
Message-ID: <7b6652f3-c994-4ef4-87a4-5473cd1254b7@linux.ibm.com>
Date: Wed, 1 Apr 2026 20:13:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] selftest/mm: register existing mapping with
 userfaultfd in hugepage-mremap
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <b3a1760e4583340e767d4045b90784ee41c8773e.1774591179.git.sayalip@linux.ibm.com>
 <142f8c68-43c7-4a6a-bd2c-1c5ebda09b27@kernel.org>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <142f8c68-43c7-4a6a-bd2c-1c5ebda09b27@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: LKHD9Kb6Cf7wQxUMMviizC9waiFl9wYd
X-Authority-Analysis: v=2.4 cv=KslAGGWN c=1 sm=1 tr=0 ts=69cd2f35 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=VfrzIvjQRdSuATq7i9EA:9 a=QEXdDO2ut3YA:10
 a=FSPndQFl7K_JWSFFR1MA:9 a=vB-rV8X0N0Ghjk4z:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDEzMyBTYWx0ZWRfXwKmDTrW2wQk1
 YGD3RtRXB5dosAB4bnxHw2Y/z9MqruDhMwKf8Nm7OEVREYIE+DLCyDb1lYTwAOA9UQKWSCVhu/V
 GI8NcgZBZZRHVf53m0BlE0oLMN8lzk4ZpeP49MEOOCdqISLKxQAsnI5qMAHqd5tGK3rTSp5EEcB
 qYVflDILzQxxoJFjb9U79U0CWklWmrD+3GMPAx+vc3VUdIUlBSd/7fiw5DiqYkKuJSSiGCwwYvR
 SviUUUJDL+I7LkOt61zVfq4VUjkA3xdrBu/jeHuDIvZSB4ZID0qg+UKpBzJ+Xo15Wkm0xO2PLIt
 jQ0CNA+hQHFjkKJhFyoMUov/gv2JFhhthiXfbnPPzBb1HENo+vCZuXdEFEsbiFpcAxdEA17btNS
 QB+pzPvblfjt/4AZNuFeiMeRcN/cj9fOWytzU7Avwr8rkwo/shC3vI0uwvaNwoCfs6GlxzYpwof
 bf37xfSv3cuNMs6izIw==
X-Proofpoint-ORIG-GUID: rjqz69gtdt3uc-M7Io5MXqf8CtBHYbbb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_04,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604010133
X-Rspamd-Server: rspam12
X-Stat-Signature: sireqe5zmj3idnb49q3ywdrptc6yask9
X-Rspamd-Queue-Id: 6215B140004
X-Rspam-User: 
X-HE-Tag: 1775054651-364462
X-HE-Meta: U2FsdGVkX1+Crx6ZrB6xnB15jlJihyfgQ8RY4RFj4eohtJ8w8g/gobQbtH25lkec03sj9aorF1g+8l1A9Vwl+E89RldgIQFKDp8LPOyDA86FNnva3df4iGP+HL8Pjg0QBdg3/I8yNmoQTj5Ief2mYCy2O5UD7M9nqpUK3R6ypPZvSsd5NGolQXgxFDpowR0SREGJskOFYfWJiTGBxacIEz+2qpb/16PuH/Vs6H2oNR4QsOF2PQTdPComwTOGBfyyt2QvNXNoRLTb1VfxokJhk0Km7FLhGQ3BmPjm4Z6a40/bDaXz2BFfqu9yYHpPvVNDOS9Yw5I41rrs9DHfNUyXO2pvYd599zmsFWmPwLfndTwJXurf2cMdnE3NLqXW4BBgti183QqFmg180FigRW3iqSXy1aNqtfZo9eTG4g3Jj/OEoWYkaJmMOBgjTiAHY5L8jJOy95f0u3YPwbgLaoDVLo0cjABr6GHwr/iulw9VWRw1llZCNxhHZ+Y8oF/C/ob3bnwYvULIbkffPY8Xv5JxLZHLmj2k1j4EGmoEDB3YQuSSPkMYu4VSttyM3qMo1BG7DIkvmdfcYlKg24aZS4cTeeZkDvxXJSCnHjCodIzXm6LkBcwlbpXVHryKju6QIMuaTNMDZ2r/31Snl0VcAy7/H51BiktOFQXJ0yH1kEhGigdQcIRf8AjjSkcx7l95+U7t8wwHPme+PIYAK6wc+9d+uefK8xADcvqQ9+nlBAYwA+qJNmtJgzYBW60elrvsqD9VtQVewUSnk2shXavBH7YxfK2o8fT56YYBOytROh57yN05kGNLxh32NPeUjk1424KXbzL5tXKu7NW0w3YiR6rsG4l/yv05HLfYlKH2EDSLrNnqX4c2B61nrILGyJxsFiPuhZuzCEHheH5VronV1MDy8m7fAFPwHmA/6Sc9RllP6+/56XyXkM1eSPkHfZY4z65V6WbKqZYHI8riswVS1xF
 xy2gG5l2
 ep4/XCEIaU2I6MdGlHF/wKWfwdhKY3D2wKPQZdISBISkvgSIl6P2BwyfjhKGVx5mZHfXNE62jT22QLifD0Y6OLEzRLdZb78zL8ywt6ANko4TPs7zu7HxUriG3jzW747VSnRPry7hKrjhwHobnu/48GQysWskPKISFvjdYYZAXaxYxzfz6fxdNgsJmOT7iU12hoxbkKk7DujRC32yzYuI1Wgin57BtP82qUopkh93I69wq7D8AqKgu6lRplQuRzSJEechCqA4x32BJAuQLQ788qA/NwG9KDuoETK/qoE4TCaR00vj7pl7cyPXUHhFfnWzK956885rRuxXAGPGsTo56AWwy4QwUplwL4zvCA0i+tqM9cEZ1ht+NQxoaY35W79pVdyDe037eDJnSnb7BJaqtyti/VG/pIwniZHlU7mF0YApjqgy6Y2jNTXxbeJqkUDiFwksJBxjGv/BbJJBpTpmNoww5X57vuRGa63dxw8hE4DZUSHg/IpBY0+ug1UyqifwaDNgU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------j01rMRmFAjBem8boRpENGo7n
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 01/04/26 19:48, David Hildenbrand (Arm) wrote:
> On 3/27/26 08:16, Sayali Patil wrote:
>> Previously, register_region_with_uffd() created a new anonymous
>> mapping and overwrote the address supplied by the caller before
>> registering the range with userfaultfd.
>>
>> As a result, userfaultfd was applied to an unrelated anonymous mapping
>> instead of the hugetlb region used by the test.
>>
>> Remove the extra mmap() and register the caller-provided address range
>> directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are
>> generated for the hugetlb mapping used by the test.
>>
>> This ensures userfaultfd operates on the actual hugetlb test region and
>> validates the expected fault handling.
>>
>> Before patch:
>>   running ./hugepage-mremap
>>   -------------------------
>>   TAP version 13
>>   1..1
>>    Map haddr: Returned address is 0x7eaa40000000
>>    Map daddr: Returned address is 0x7daa40000000
>>    Map vaddr: Returned address is 0x7faa40000000
>>    Address returned by mmap() = 0x7fff9d000000
>>    Mremap: Returned address is 0x7faa40000000
>>    First hex is 0
>>    First hex is 3020100
>>   ok 1 Read same data
>>   Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>   [PASS]
>>   ok 1 hugepage-mremap
>>
>> After patch:
>>   running ./hugepage-mremap
>>   -------------------------
>>   TAP version 13
>>   1..1
>>    Map haddr: Returned address is 0x7eaa40000000
>>    Map daddr: Returned address is 0x7daa40000000
>>    Map vaddr: Returned address is 0x7faa40000000
>>    Registered memory at address 0x7eaa40000000 with userfaultfd
>>    Mremap: Returned address is 0x7faa40000000
>>    First hex is 0
>>    First hex is 3020100
>>   ok 1 Read same data
>>   Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>   [PASS]
>>   ok 1 hugepage-mremap
> Okay, so we tested mremap() of something that is not even hugetlb.
>
>> Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
>> Tested-by: Venkat Rao Bagalkote<venkat88@linux.ibm.com>
>> Signed-off-by: Sayali Patil<sayalip@linux.ibm.com>
>> ---
>>   tools/testing/selftests/mm/hugepage-mremap.c | 21 +++++---------------
>>   1 file changed, 5 insertions(+), 16 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
>> index b8f7d92e5a35..e611249080d6 100644
>> --- a/tools/testing/selftests/mm/hugepage-mremap.c
>> +++ b/tools/testing/selftests/mm/hugepage-mremap.c
>> @@ -85,25 +85,14 @@ static void register_region_with_uffd(char *addr, size_t len)
>>   	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
>>   		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
>>   
>> -	/* Create a private anonymous mapping. The memory will be
>> -	 * demand-zero paged--that is, not yet allocated. When we
>> -	 * actually touch the memory, it will be allocated via
>> -	 * the userfaultfd.
>> -	 */
>> -
>> -	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
>> -		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>> -	if (addr == MAP_FAILED)
>> -		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
>> -
>> -	ksft_print_msg("Address returned by mmap() = %p\n", addr);
>> -
>> -	/* Register the memory range of the mapping we just created for
>> -	 * handling by the userfaultfd object. In mode, we request to track
>> -	 * missing pages (i.e., pages that have not yet been faulted in).
>> +	/* Register the passed memory range for handling by the userfaultfd object.
>
> /*
>   * ...
>
> While at it.
>
>> +	 * In mode, we request to track missing pages
>> +	 * (i.e., pages that have not yet been faulted in).
>>   	 */
>>   	if (uffd_register(uffd, addr, len, true, false, false))
>>   		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
>> +
>> +	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
>>   }
>>   
>>   int main(int argc, char *argv[])
> Yes, that code is extremely weird. I wonder if this was some
> copy-and-paste from other uffd test code.
>
> Acked-by: David Hildenbrand (Arm)<david@kernel.org>
>
>
Hi David,

Yes, the test operates on hugetlb mappings created with
|MAP_HUGETLB | MAP_POPULATE|and sets up userfaultfd. Consequently,
registering it with |UFFDIO_REGISTER_MODE_MISSING| does not result in
any userfaults.

Originally, the helper function created a separate anonymous mapping and
registered it with userfaultfd instead of the address supplied by the
caller. However, the test operates on hugetlb mappings, and the registered
anonymous mapping is never used in the |mremap()| path being exercised.

Would it be better to remove userfaultfd registration entirely from this
test, since that path is not actually being tested?

Thanks,
Sayali


--------------j01rMRmFAjBem8boRpENGo7n
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 01/04/26 19:48, David Hildenbrand
      (Arm) wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:142f8c68-43c7-4a6a-bd2c-1c5ebda09b27@kernel.org">
      <pre wrap="" class="moz-quote-pre">On 3/27/26 08:16, Sayali Patil wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Previously, register_region_with_uffd() created a new anonymous
mapping and overwrote the address supplied by the caller before
registering the range with userfaultfd.

As a result, userfaultfd was applied to an unrelated anonymous mapping
instead of the hugetlb region used by the test.

Remove the extra mmap() and register the caller-provided address range
directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are
generated for the hugetlb mapping used by the test.

This ensures userfaultfd operates on the actual hugetlb test region and
validates the expected fault handling.

Before patch:
 running ./hugepage-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fff9d000000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugepage-mremap

After patch:
 running ./hugepage-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Registered memory at address 0x7eaa40000000 with userfaultfd
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugepage-mremap
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Okay, so we tested mremap() of something that is not even hugetlb.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Tested-by: Venkat Rao Bagalkote <a class="moz-txt-link-rfc2396E" href="mailto:venkat88@linux.ibm.com">&lt;venkat88@linux.ibm.com&gt;</a>
Signed-off-by: Sayali Patil <a class="moz-txt-link-rfc2396E" href="mailto:sayalip@linux.ibm.com">&lt;sayalip@linux.ibm.com&gt;</a>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 21 +++++---------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index b8f7d92e5a35..e611249080d6 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -85,25 +85,14 @@ static void register_region_with_uffd(char *addr, size_t len)
 	if (ioctl(uffd, UFFDIO_API, &amp;uffdio_api) == -1)
 		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
 
-	/* Create a private anonymous mapping. The memory will be
-	 * demand-zero paged--that is, not yet allocated. When we
-	 * actually touch the memory, it will be allocated via
-	 * the userfaultfd.
-	 */
-
-	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-
-	ksft_print_msg("Address returned by mmap() = %p\n", addr);
-
-	/* Register the memory range of the mapping we just created for
-	 * handling by the userfaultfd object. In mode, we request to track
-	 * missing pages (i.e., pages that have not yet been faulted in).
+	/* Register the passed memory range for handling by the userfaultfd object.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">

/*
 * ...

While at it.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">+	 * In mode, we request to track missing pages
+	 * (i.e., pages that have not yet been faulted in).
 	 */
 	if (uffd_register(uffd, addr, len, true, false, false))
 		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
+
+	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
 }
 
 int main(int argc, char *argv[])
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Yes, that code is extremely weird. I wonder if this was some
copy-and-paste from other uffd test code.

Acked-by: David Hildenbrand (Arm) <a class="moz-txt-link-rfc2396E" href="mailto:david@kernel.org">&lt;david@kernel.org&gt;</a>


</pre>
    </blockquote>
    <p data-start="0" data-end="9"><font face="monospace">Hi David,</font></p>
    <p data-start="11" data-end="226"><font face="monospace">Yes, the
        test operates on hugetlb mappings created with<br
          data-start="66" data-end="69">
      </font>
      <code data-start="69" data-end="97">MAP_HUGETLB | MAP_POPULATE</code><font
        face="monospace"> and sets up userfaultfd. Consequently,<br
          data-start="136" data-end="139">
        registering it with <code data-start="159" data-end="189"
          data-is-only-node="">UFFDIO_REGISTER_MODE_MISSING</code> does
        not result in<br data-start="208" data-end="211">
        any userfaults.</font></p>
    <p data-start="228" data-end="523"><font face="monospace">Originally,
        the helper function created a separate anonymous mapping and<br
          data-start="300" data-end="303">
        registered it with userfaultfd instead of the address supplied
        by the<br data-start="372" data-end="375">
        caller. However, the test operates on hugetlb mappings, and the
        registered<br data-start="449" data-end="452">
        anonymous mapping is never used in the <code data-start="491"
          data-end="501">mremap()</code> path being exercised.</font></p>
    <p data-start="525" data-end="651"><font face="monospace">Would it
        be better to remove userfaultfd registration entirely from this<br
          data-start="597" data-end="600">
        test, since that path is not actually being tested?</font></p>
    <p data-start="653" data-end="669" data-is-last-node=""
      data-is-only-node=""><font face="monospace">Thanks,<br>
        Sayali</font></p>
    <p><br>
    </p>
    <p><span style="white-space: pre-wrap"></span></p>
    <span style="white-space: pre-wrap">
</span>
  </body>
</html>

--------------j01rMRmFAjBem8boRpENGo7n--


