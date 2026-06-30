Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06A4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BB16B0118; Tue, 30 Jun 2026 05:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBB46B011B; Tue, 30 Jun 2026 05:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02AD6B011C; Tue, 30 Jun 2026 05:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDE16B0118
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:35:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C870140404
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:35:56 +0000 (UTC)
X-FDA: 84936072312.22.0EC5068
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id B1A5C1C0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:35:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fqL0qCCh;
	spf=pass (imf18.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782812153;
	b=kSbuIF45yXF6ykcAGGoWL6pmvdv3hjTqitQHb28oCtpykjRSReJKNTKlSOSrl/gCQGmolu
	GT+7tzciEChm499rcd+SB/cXHFW3NjyF+jeLb/NgiKjNNi5BSLuJfBd4J25QCr+nTihu4D
	dYs+fa9yS50EZNxhJ3f/6wkCaaWsKWg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782812153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynIHlG9XKyd50EeZ1Oh9hk1QBbklthyVMi9jY71J0TM=;
	b=fXTc2TQpqwiaRH1HW9iPsa5NKD6LO0hxgYo5fp8EFJz4M4hZn/IbYLsX57l7ZdiViPWYv2
	lai/INxU0CMILkGK7+HDpWJQ23HZa6X6ozf8kv6pPx+t3e3DKuKNvw9P20H7+0OxTZUgLn
	/nyhitYhyFNILtK23ZYSsxNKJXZOyiY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fqL0qCCh;
	spf=pass (imf18.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U5mMkS1069686;
	Tue, 30 Jun 2026 09:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ynIHlG
	9XKyd50EeZ1Oh9hk1QBbklthyVMi9jY71J0TM=; b=fqL0qCCh3ANo1+l4UOOMn8
	pgyoEGMugURk/QbqJDyrahBPdTjVqfAaA6OdwJsA/uny+msEq6tj50P2aHXSS1Yy
	6clqb1eFKWJQmKJJ9Q02bKjCW3TW2Ef48SAXtIgQEjOflAa5UQFqiMa6fNDvc/vc
	vVrkuiIWOX9dCFOQY02dlCwgylhmExZb7KjrhxJVQf7ilTmSie9rUhXtp0KVv9vb
	qEemq1gNo42vvRhikSSzIQhOT+3+HRA5dj4n83Yy59wcB78XGKXZVQS9mu/Uiggc
	MSp/nx5jcm35ud4VBEpZklFQzQ14fBE9vsEUjtW/+TVh84CbK0At0uhv6JTfgrzA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26rewm56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 09:35:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65U9Yhcl005799;
	Tue, 30 Jun 2026 09:35:40 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f2uhy97vh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 09:35:40 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65U9ZeJK26804944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jun 2026 09:35:40 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 109055805F;
	Tue, 30 Jun 2026 09:35:40 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C4A85805A;
	Tue, 30 Jun 2026 09:35:33 +0000 (GMT)
Received: from [9.39.22.200] (unknown [9.39.22.200])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Jun 2026 09:35:33 +0000 (GMT)
Message-ID: <8483ce18-070c-4d14-add6-bf65e3f71ddb@linux.ibm.com>
Date: Tue, 30 Jun 2026 15:05:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH 1/2] selftests/mm: handle EINVAL when configuring gigantic
 hugepages
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <20260626144835.3759976-1-usama.arif@linux.dev>
Content-Language: en-IN
In-Reply-To: <20260626144835.3759976-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=a4kAM0SF c=1 sm=1 tr=0 ts=6a438dee cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=sZw2k_FkU4g0e2GbGXMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: O05riK16JTu0mCcfDhGEvhNGcRsFq20J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA4MyBTYWx0ZWRfX1F5LFHMQC1Uy
 WDGF1qlwgVeVVpKLWd/3RF65rRLw6rKLKDnh/vIEVXJdipdEBhOYTo8lhS36RYnHhKFiuyIkk6N
 hGi0XsDEbkzQa7dvK19AujSLmOme8rW58QMbjwN/wIuivV5BwQ4zT6cJpWpyt5YiGuqmW7RJ+/F
 q6XQ/X25XzF2qRSxguyM5MTJcZOxbxa6XG6nxzA4Q41QcX81iWFHYrrYAu+slncthSPieQd4iRj
 KA3PWR14/wlhsm4YQZLFqlnSsbnYjA0ILrbpkOdSMeC6jie2FC0Xno/y00c8lOB2bAy3zAqwaGv
 91bDgvi0aHfAKrY6iYEigb220QtI7VIFD1Oe8c1z29tSfX5zJXnH0va/GeA8Z2SblXzTMW1lPLv
 luAeoS9O85EyuaPPZ56c4CWKTpqCymU3L/U00XCyGBVBybKL5VTPexHibs0gAJSfQOBRyOBdBKD
 DYdaUmuoHSYPu2g5xkQ==
X-Proofpoint-GUID: phyyY_qkonHDLKEyL1C2LMBimzIXQU-q
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA4MyBTYWx0ZWRfX1cnShknkJ/ee
 0x/UssF7tYiW7UFuGNZKW3uZv1DbylP9INZp0eU0fQliRUXc4rQKc9lKzPF5CA1iuTDuBoagdsC
 9r+B7v4hQFFFcPZyKJeNgQbd8H+OwzI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300083
X-Stat-Signature: sek3cco5nypumw7aaanktmabmo5rx56h
X-Rspam-User: 
X-Rspamd-Queue-Id: B1A5C1C0005
X-Rspamd-Server: rspam02
X-HE-Tag: 1782812153-987521
X-HE-Meta: U2FsdGVkX18hJ0EsxM4Ue6is0LnWmuPywCYn7mDH/KYBJax+UxiVt0Yvm20u5j9p5MHb60oNCpl6zWEby2G5ptJMxcq8NCEIfdYUAQQyI8WZ9gxx+DFH5lyFxJoB1Wszk6XzWVgGbY3R1H/7nYS+JA7YeTHSbgk16yYEnUothjKzqNVX0PX1eXmluDRL0Obkcjm4aJpgU0Mm800EWuFjgUBtOCTSxmRBzh4UDI540TpIfkSA1eRXq+o9bu25DraJ/Oc3KWSyPNZJPBHwR+1lhvN8Rv/2XTITQY/Fw1dGFKYQnp8KCvHJQp/1xZbSrqZCEoANk2U0Qe3+v5Zft0T+YaQF4hvLHBp5YGkcygIi6zrCuxhk1SXCYj2TKxID/GaLA9uAWr6Ve4bTqlOQozUgPVVKj9mX2gwNP4bnzajpBZVQhrja0xYEF0zOPYlVVjMWZFzfdPPwL/oDDo60OOJz4iR+1397+DiaUNsMXHzLCys8HilEC67p81dJPOEE3sXKO9kVLxDrMLJWaZn2Y4LYGksaIC20kihBzy2vaF6vDeQ0rQPAGrmRsI0qu4QfBFEKVfxNB6RS2mP1y31WwIdK5Okvi0+oLIv2e1IxW7DuoTBtiA1qJCgQ/Snv2eJEcNg2hHjsG0KlSVfvnHJnOS4yQW8aLxA5Utm/cdlsFo8K+ysuoIdKAY/e0vGlta5TNiiFrp2eq665RNv4t6Rqa9rPijiefzLys+ocL0mCP/fJtEp8KDVLwyMcmO//PFjmaBd5djP3wuzU0uKJQdZ969uQZpgLiKcOqSot7TUnkuLjCuPTuPi9yp5Am1PTAi6eMzZVjkvEI4lWgj9TaeGayrUb8+IxYnJCoAO6Yw8TErEQyXXEVk/uGp0okiH/WotBJPAbGJjRaAdRW7cHEcEDkmmV2WVxgtVAXClELqg+SoGDEDX7FVAfZLK0FE0JT6PFg6kKDeel+6f/H6CTueKKCUy
 /cMEGyMD
 ZgsuXkOaB83GFO02YWvbIvGGhb/RtRb61ZrZdcuSCWOH9kfkN0vIp9am/4ICpm7VuWilM/sjFCy5d2q45zPYl8mTnR2lX4CkUEyj36GUCBeoV1QhaTBrYvP1TZp24NvRW4V14i2MUlVPsJLOWFJomEPIsEIEX/bEa6PAwVGqq/XEkKHYLKbJXsf2AgpS+vaBjW326LiaLnNPxY9/puiGk23t2O1n12ZKoz5gHJ174xPZIQO4FAu5ULlyu4xN7PiFWe3sCye9fk6oUzo88kdzQYmN5xJIX4DJh+mueHyAMN/xIyREoDMzz7ZlRxkN7kpvl8yoGkWjKGMIBe05cCWw+2+ozaq4zT1LPKF99e9NTBsycCXl/M/MKU0Gqg/OCHSisiDWtQlSHLcVqMRy5cJGz29M5Dd6OSt3iLFPLOXDaNapC719HG0/5E1sY54/SnY4+qnM5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/06/26 20:18, Usama Arif wrote:
> On Thu, 25 Jun 2026 18:10:16 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:
> 
>> Some MM selftests attempt to configure the amount of
>> HugeTLB pages of different sizes by writing to nr_hugepages.
>>
>> PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes
>> but do not support runtime allocation of such pages, writes
>> to the corresponding nr_hugepages file fail with -EINVAL.
>> This causes the test to bail out even though the failure is due
>> to a platform limitation rather than the
>> functionality being tested.
>>
>> Treat -EINVAL from the sysfs write as a skipped configuration request
>> and continue running the test instead of failing.
>>
>> Before patch:
>>     -------------------------
>>     running ./hugetlb-madvise
>>     -------------------------
>>     TAP version 13
>>     1..1
>>       [INFO] detected hugetlb page size: 16777216 KiB
>>       [INFO] detected hugetlb page size: 16384 KiB
>>      ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>>      Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>      Bail out! /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
>>      write(0) failed: Invalid argument
>>      Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>>      [FAIL]
>>
>> After patch:
>>     -------------------------
>>     running ./hugetlb-madvise
>>     -------------------------
>>     TAP version 13
>>     1..1
>>      [INFO] detected hugetlb page size: 16777216 KiB
>>      [INFO] detected hugetlb page size: 16384 KiB
>>     ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>>     Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>     /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
>>     write(0) failed: Invalid argument
>>     [PASS]
>>
>> Fixes: 9d07250ea1eb ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>> ---
>>   tools/testing/selftests/mm/vm_util.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
>> index 311fc5b4513e..a8f16eef5c7c 100644
>> --- a/tools/testing/selftests/mm/vm_util.c
>> +++ b/tools/testing/selftests/mm/vm_util.c
>> @@ -735,6 +735,13 @@ void write_file(const char *path, const char *buf, size_t buflen)
>>   	saved_errno = errno;
>>   	close(fd);
>>   	errno = saved_errno;
>> +
>> +	if (numwritten < 0 && errno == EINVAL) {
>> +		ksft_print_msg("%s write(%.*s) failed: %s\n", path,
>> +			       (int)(buflen - 1), buf, strerror(errno));
>> +		return;
>> +	}
>> +
> This makes write_file() silently succeed for every EINVAL, not just the
> gigantic-hugetlb setup case. Several callers use this helper for writes where
> EINVAL is a real test failure, for example drop_caches or split huge page
> setup. Those tests can now continue after a failed setup and report misleading
> results.
> 
> Please keep the common helper strict and ignore EINVAL only in the hugetlb
> path that is probing unsupported gigantic page runtime allocation.

Thanks for review!
In v2, I kept the generic write_file() helper unchanged and
added a dedicated hugetlb_write_num() helper to handle the expected
-EINVAL returned when configuring gigantic hugepages. This limits the
special handling to the hugepage setup path and avoids masking genuine
EINVAL failures from other write_file() callers.

V2: 
https://lore.kernel.org/all/3d394c8cd59fe380d4e2d13b051544f241918f07.1782811071.git.sayalip@linux.ibm.com/

> 
> 
>>   	if (numwritten < 0)
>>   		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
>>   				buf, strerror(errno));
>> -- 
>> 2.52.0
>>
>>
> 


