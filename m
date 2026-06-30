Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04351C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 20:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138856B00A8; Tue, 30 Jun 2026 16:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1115D6B00A9; Tue, 30 Jun 2026 16:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0276E6B00AB; Tue, 30 Jun 2026 16:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B67256B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:21:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 203CE400FD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:21:09 +0000 (UTC)
X-FDA: 84937698258.28.16F4C7C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8EDB640007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:21:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WW1TeXhK;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782850866;
	b=UypOULmNKYdN2Ua0AJeRyw9YbOWnXiPB4R00bEAJme5hXqCAkNcDaUihahoZaVZUzHuTdU
	6m80ejP4SNAMuQnwHBG4jmwADNBP9yMFKgKrw11NxuGtcuAosKxvjruU8tRnFStTHC/BeW
	ne3W1vf+gdDMMBuGTIHLhezguxHTHus=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782850866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MN1zYNlRIrvCMl8w1g003MYRSSHOfGU46ywAOytAXzc=;
	b=eWfbWQD3FBmTfR06uY80uu8YnyKurwHkk/EJ0aRPl2IEMbJASNhAN7QmIE1P3K90I4L1d5
	/nfOZyAiNciRhM58WBSFHwjNMGy7+hiOTktuA+FijgnDoYvy8MDOU8WcpSy3vGGVX/2MPV
	Sy01cDeohxI1SX9EEBmJHa2Xan6GV4c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WW1TeXhK;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65UJIIvf2957033;
	Tue, 30 Jun 2026 20:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=MN1zYN
	lRIrvCMl8w1g003MYRSSHOfGU46ywAOytAXzc=; b=WW1TeXhK+/+9vIQhysV5qC
	Gp/sOcyXt+OWJEtcXUH63Ug7Lv+8w2LzM8M9WzuAA1qpXi0oNd81bXP9v37uDMSY
	1NAuO+xbKnPl+EUkOQ37WT2NTz5RLT0d6HyzYH0oN6w9yCsuKpyqbWTJfpRz1GYN
	3b14bFTxWP8TlvZ3cMPsh1i3QXp46KVIss0nQ989kNGup7WaMzlWaGKdgoN5lhPg
	cpXOqyypRIAA8kmCENiKDUz01qorM9nAaAyiYqn03ttZBCU673PbFFIKNH2+ZQ60
	HcA/A6WWgc2gZIF7wD2BzVSiQgOhQWH8yLmo6snhXYToK5BIExZr+Fx2VNadG7hg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26pe10fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 20:20:55 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65UKJhUM009636;
	Tue, 30 Jun 2026 20:20:54 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f2uhybuwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 20:20:54 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65UKKrUY57541116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jun 2026 20:20:54 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1CFD58058;
	Tue, 30 Jun 2026 20:20:53 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 708D358057;
	Tue, 30 Jun 2026 20:20:48 +0000 (GMT)
Received: from [9.124.209.216] (unknown [9.124.209.216])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Jun 2026 20:20:48 +0000 (GMT)
Message-ID: <968b496a-a83e-491a-950c-3f6f975fa5f5@linux.ibm.com>
Date: Wed, 1 Jul 2026 01:50:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v2 1/3] selftests/mm: handle EINVAL when configuring
 gigantic hugepages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1782811071.git.sayalip@linux.ibm.com>
 <3d394c8cd59fe380d4e2d13b051544f241918f07.1782811071.git.sayalip@linux.ibm.com>
 <ccba342f-1ed0-43fe-ac59-9b8bbfb168d4@kernel.org>
Content-Language: en-IN
In-Reply-To: <ccba342f-1ed0-43fe-ac59-9b8bbfb168d4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: xyESTlO6dMLM7YcVtcvMAvaTwyluwrzX
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDE5NiBTYWx0ZWRfXwYC8CEf3+t4o
 KiyjGor5a04mKsKTRf7jX4eo4mzRJu2/C7NwJEzG02V/mIlZGyLO4Qi7Kj5lxnkISK5P++UhwT+
 ImE/iurNuaTVuSm4F8y1I58k5E1Kufg=
X-Authority-Analysis: v=2.4 cv=edsNubEH c=1 sm=1 tr=0 ts=6a442528 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=m02x96YjSDSQiHbJXYIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDE5NiBTYWx0ZWRfX5RrnGuMnjta0
 gdd5dAniw1EU9+cmYHg8yNafFjUwPFREIMD0JCAkW8PXv6mivlwxvxmMIx0RBLpUgYzMGWL8fa3
 3xvHbVtDMhYVr3AaEaow9hRPgC90b4Sub4ohZ7NmV7aLdh6SPuGLvPXVZ2j/JOJ5hBWx584AtIm
 nbfJoWdjjU/NFStaOj6WTxrfaHpvFa/H6M6EEB1x25vfBvgclmS/LNObzZilaf6wM4yv69gUSgA
 p5CZwQmyK52eUx0bRylexxEzEflIKRVz5fPBj5hr6j2uQifJfzk54/zlgyI6ORs5nkU8YJ9ZylN
 hsjti6jc1NtOX3jcbezDJEz2UylY+u/RXOifrm66ykPMy4htd8MwAp4ZLr/j5reiLCLhDYA0n12
 TRTphxp5I71/EYRWBtWYLSd9kBmmLmpe6NvMwFI/r5ZZUZlxgXgJBWbn7YbXYct2CIGpwBrtnod
 VLh+aHeglV0Cij6yYcQ==
X-Proofpoint-ORIG-GUID: PqQIfZCw_cvbMYTbclLmQsh_ECd9ocEH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_05,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300196
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EDB640007
X-Rspam-User: 
X-Stat-Signature: qoqdiyc5ag4x77ap9w57em4zpbyi5js6
X-HE-Tag: 1782850866-694886
X-HE-Meta: U2FsdGVkX1888115Kl/SpU8fXGxfD+S4JovY6Rv+TKb/lFYiyottOHC9aXmpvMjI+VfiY0IkLWpvJ/q+YyLCo12SeWN3tEIAEwe8E+mO9BfoIWvcQTlKzfDLwwCPeFeMFFV1EFFzoXFi+WBh5ueAG3BNY9TzhQ64V1yhiDyhCClPN43OdZupd2n/QJgdg7A2JfDf02FsyS/y+fzHTUS9LHjsi8fj/mDRt2VGR6TumqV2mCtasW83f/Sey5IVKDHi9miCY1a84En9ELX8Qe2A9zKYWHybFONxdqFsZg6uKlCyrGX3nic5DqbAtcQqV/AJhYff6D5VUsBOr4kG2Pry7od1UKElXtHAPZ73dznUDBiZyBEkmVEpNa1nyUNcuD6be4L17YrpTzjupDJZMVOwuSX39zXV+BRevorsHoPRz/87gw5wmIzZRA6xK07HrL+U7bjCzPb2JFcZ3TojXcYXB3ALVlbkaLjMENBYoZaiVPY4t5trKL442umC8DtSSE53hHzqvlwI2Jm8W7ApGONWlKC9eAjFNpPq/bP3XOyFvPTvck1XE1oaErjNhOSZ8WwGaKbYEvk10g9Wy5WoE+8fOc/RbqYYRFCSn3kaIYDRgUROLIqphiipHGM3AKxXVIaxEUhLvPOJgEXUPqY0+D6M5lZDHEHdwi8/ZtJ+7RmcnVRfEgL8ECtNWJH6DnBlXMVkJwW13w7t0X90bj0iUH9eOkFjwA7hkDdJA7S5521kfyKDKWSZX5FdqhrmBz/TyXmL71TCdqDgUn00GRHkMfj4byGSeh9eDm9CD/AdInvEFAXbTMlQWBZ7u5EolNVh9wBJtterqaonta2dH12ceKIJi1qO+6U0kZqL7bvJKGivsIsQBwaBJjM4fUS+QVXd6c+e+t+HatH8dCoejfIpjHIw8ZwmvZjgpQzEJpFK9kYhzpOPOldDEwRA5Zrz5xuisiy6LKDqD7Vj19VBzJfB2MN
 v9eEDHhq
 P66mf/tXicTLs9f9F2b8kk5SOeRTPUxGhDWbyR+CItHwIENzj4HpzuUgm/a6gtlah4e85ftII+ywdnJbwraCvFV7Z9gQv48kUJL/y/DOT1hny6eWOee5KCRrErUjrSaCFze3OngqlccGL1jQdFfAinEDe6LqYX8eITV570aBe6QpbExBLEJrcunaWwZi8tNJ2Xj31pjiI3m/C7fE7YIxVWSsR4eggFAR/qkseoh6R3krKoTDNJkIrlqxq2XizH/yI8yItpvN6Usbnt09o/wv3Dwx1iLrWVOT10kYbJhFkcKiHsK1gere2yhKBpWmsxM1A5zkoJrSQ2HMNoCsFxKDi4L82c9c5Oukx5AKp4Xs4cDTdBUZ6UlJyEDfmfmldVIXxIz3udsmunpd0BunCyF83L4RnETsobKQQ5Yw0S+cU+7n3cTv6aB5yGNkvEzf1BVXfgtV+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/06/26 16:15, David Hildenbrand (Arm) wrote:
> On 6/30/26 11:32, Sayali Patil wrote:
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
>> Fixes: 27477b28b74f ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>> ---
>>   .../testing/selftests/mm/hugepage_settings.c  | 32 ++++++++++++++++++-
>>   .../testing/selftests/mm/hugepage_settings.h  |  1 +
>>   2 files changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
>> index 2eab2110ac6a..ce38ae3da01a 100644
>> --- a/tools/testing/selftests/mm/hugepage_settings.c
>> +++ b/tools/testing/selftests/mm/hugepage_settings.c
>> @@ -422,6 +422,36 @@ static void hugetlb_sysfs_path(char *buf, size_t buflen,
>>   		 size / 1024, attr);
>>   }
>>   
>> +void hugetlb_write_num(const char *path, unsigned long num)
>> +{
>> +	int fd, saved_errno;
>> +	ssize_t numwritten;
>> +	char buf[21];
>> +
>> +	sprintf(buf, "%lu", num);
>> +
>> +	fd = open(path, O_WRONLY);
>> +	if (fd == -1)
>> +		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
>> +
>> +	numwritten = write(fd, buf, strlen(buf));
>> +	saved_errno = errno;
>> +	close(fd);
>> +	errno = saved_errno;
>> +
>> +	/* Treat EINVAL as a skipped configuration (e.g., unsupported gigantic pages) */
>> +	if (numwritten < 0 && errno == EINVAL) {
>> +		ksft_print_msg("%s write(%s) failed: %s\n", path, buf, strerror(errno));
> 
> Should we even print anything here? Rather confusing. It's just like we cannot
> allocate anything (no memory).
> 
> In general, you are copy-pasting a lot of write_num()+write_file() content,
> which is really suboptimal.
> 
> All you want is an option for write_num -> write_file to skip on -EINVAL, correct?
> 
> There are not that many write_num / write_file users ...
> 

Hi David,

Yes, all I need is to ignore the expected -EINVAL when attempting to
configure gigantic hugepages via nr_hugepages.

I looked at extending write_num()/write_file() for this as in v1
(https://lore.kernel.org/all/8bfa921e30eb94072685103f6496784aa23bb166.1782365671.git.sayalip@linux.ibm.com/),
but these helpers are shared by several other selftests.
For example, write_file() is used by split_huge_page_test setup and by
khugepaged tests for drop_caches, and is also used for various THP and
khugepaged settings where -EINVAL would indicate a genuine setup
failure. This concern was also raised during the v1 review.

Because the expected -EINVAL is specific to gigantic hugepage runtime
allocation, I kept the handling local to the hugetlb setup path rather
than changing the semantics of the common helpers.

I also agree that printing a message is not particularly useful in this
case, and we can simply return without emitting any output.

Please let me know if you would prefer a different approach.

Thanks,
Sayali

