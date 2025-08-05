Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9F9C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FC8A6B009F; Tue,  5 Aug 2025 02:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD4F6B00A1; Tue,  5 Aug 2025 02:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BFA6B00A2; Tue,  5 Aug 2025 02:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 556BF6B009F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:14:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A83C160F71
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:14:15 +0000 (UTC)
X-FDA: 83741688870.09.DC678B7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 71947180007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:14:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=W9o7oqv5;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754374452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nSruB1AfIiJcbqhJAd9VdSFyvMrBKvghywAZBeiRWs=;
	b=68oWxJkcdaF4gssuuTgerGZEt1GBjhvyszDmXos4giZAui/pMAHgAoFga1Y+dGXhtGcvSa
	NRZSaZG4ex9puwX06yxKiTOphj1DnHEbzVH2L7Uw25jZCekMOSCyTG2WdA2VwixrlxMJNf
	2UAY//FK4KEd2ca8Ia8P/bH5Gw+Y82Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754374452; a=rsa-sha256;
	cv=none;
	b=xK7cAFKfifnddpJEfsD3e+xn0w0dDj4AXu1T80iTu76bO0G4IdkNhcDSrutCy0su5jc7D6
	TYnvhx08jVub6RKM2T7quKZZJqWnHDtNeKhB2sQuB/I0TUvWc8P4JA5XI0srLTeBvumkMu
	1xOgDBKdJQA3QJL7RKeLOdKkR5aJWrI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=W9o7oqv5;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5751HI3q022644;
	Tue, 5 Aug 2025 06:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/nSruB
	1AfIiJcbqhJAd9VdSFyvMrBKvghywAZBeiRWs=; b=W9o7oqv5iTHaOg9xPNgqEm
	U/o9KJZZlvcyXOSBFHjvLgeXiDglaWQuPAPdU90Dz4NmdhgQAa0dWgMI92s+U3iF
	ndZw9JLQ2uqjMkRghkT0O8yI7pY3PIjY54mjHJE2BMSiUVRMDgEBQVXLoLbkpPWQ
	/e/pMvLBCK0MifjlWiHxNoxSa/1UT7Safjeyig5ysPe1IuwJc63pMzJ0I7U5j0hz
	KIQ9rCBFMsv2MCcwVOv0x4G/EGy1VCzKaCasyQx/F66xh1xxy6YFmbaGHPQ73XvT
	37nOIb9QnbFLXRmhOvXAh5/+yMDPG2wvs2qX+t9KDnYX6H+tH7zR+xqw46C4CjeA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ac0vqft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 06:14:06 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5756E576001185;
	Tue, 5 Aug 2025 06:14:06 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ac0vqfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 06:14:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57550SgY001508;
	Tue, 5 Aug 2025 06:14:04 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 489y7kryvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 06:14:04 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5756E4JF10814496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 06:14:04 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E8AC5820D;
	Tue,  5 Aug 2025 06:14:04 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E57075820C;
	Tue,  5 Aug 2025 06:13:57 +0000 (GMT)
Received: from [9.109.245.113] (unknown [9.109.245.113])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 06:13:57 +0000 (GMT)
Message-ID: <1399003a-31e6-42e3-9457-24c0a89e8757@linux.ibm.com>
Date: Tue, 5 Aug 2025 11:43:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] mm/selftests: Fix split_huge_page_test failure on
 systems with 64KB page size
To: Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, ritesh.list@gmail.com
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-5-aboorvad@linux.ibm.com>
 <20250804090410.of5xwrlker665bdp@master>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250804090410.of5xwrlker665bdp@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tlzj5DoY8pOA_ZBoPalFWaMlmr2nH0yv
X-Proofpoint-ORIG-GUID: ivDDrpa1Sp2ERmiG-QxWJYQ2orBF1Fbt
X-Authority-Analysis: v=2.4 cv=GNoIEvNK c=1 sm=1 tr=0 ts=6891a12e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8
 a=Ikd4Dj_1AAAA:8 a=drvxjjOeZLWjmwp7pQoA:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDAzNyBTYWx0ZWRfX6ZaxNbpx7iDv
 LA8o8XKmI8fSnDhuD771QnEj+QlFPbmuCX+a4mmF9CUSa5OKZKtDi3VFuppwFmXmC1hvb7TwvDE
 OrHh6LY2223m++hkGhcChKW6zahuNfNp3AqEKvZHW77MSmdFYdQ4D/FTH9NrvmL1Jij8+IPrn+A
 g2+w4u8NGW+0w3+Ja6B/QJT6UFzh5kBIs4EwHkmnn4I5IxvGeMhfTEpNyPjNNtl2fYTpd37H30S
 z/eUeeidEyODu493cKyxSW97+k6GPX9FjGP78BVC3XSVnnbnF90daW0Rn4o7ygplmR4cy4NaJL2
 Zoh6TtIHG70q6OthaedvqRAuIGgmNiZjX7rNTVrkiBBF816YxdfT42GPwoRDBNQM4wv7OPKLeVj
 7n3tIKbeLXs4VadoeNOOgmzz4GzH2G06T2vM8L17iFCI5PZQhL93Pkvu4XfawakkhaZc4Pth
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_01,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2508050037
X-Rspamd-Queue-Id: 71947180007
X-Stat-Signature: mq5cg1tyt1u5g5yaka4q96tdsynnb8x3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754374452-758861
X-HE-Meta: U2FsdGVkX1/hv5fyD6rWuPW5NOlHGdIDsayK2Xjoz6dKqLx3016wR8InASVzfB9wgjBvzJT3a+9LFz/AHgyojM7HAlsJc8flpwYgKLkOBau7L+L2IwxWeqaM1omja5sQYPRP4wiUGwtXvC21t3MgiV/OX1LAjYT0ldv8Yi/0L8xcLnV0SzwujFNcQ2SB3gKNi4OFTwojvRzxHp3WA3sAlDZOWhipgEQmfwFLgfBZ2ju0XBy7M7LS437xP5GNNlDkjb4GUP5p5Bo2ZCL0fAq5+iLEmoYVVd3vovcXVAyd4WFYfWse0+tdgWoQoq7E3HPOIv3Mkh52gqPO6CPLbqIAvZJz1HB2pz9FHXGfSswkD6gYKbswUC1jbyygf88TYTXgQhvIh68sRSXo4xfW60n5T9DgutBA9f4E9nctg68gsb4GButSSK8x6HveC9aAlMHZRi7yiOmayR3U3yJ3d2tGc44QwUmIFAWgCiQtI687uu94iA58x/xGsLbdCc4G9pbbYRu3BidM3xb+GghyGbmD4U7r8n24k3Rs3MAykh8VO8TrXcHFj2Whce70mqSj74lXsi+x7xq455fpKIFiHI13bErjYDuGEGlDDzf6uEld8wq3RwvkvhJPAQa3rp076y1VyIfLUM4tKR6/yFAszXkPUvNeFnfAcyOqRNoQAOhJDcEUJPRMYFCj90LC45A8w75OzBdQq+E7UL7+Y+l86RMZ1b0YTYzB0xqLzyXYJBXHF6Ff2hNnibN1CakgzNWiGEWRxmkO1EJJOzwfwk/ubsFl2q9O1YZcnzFcwQjBSloN5U0EI29IDBeg2mhnPhKHdu5iOM+tDfy0EHZtUyMGSEgiuCxSPmZ+j/VxCRT79udBAz/RXedMilz8wCGneY2gBemr6VatqCTmtRCLvfLBOCaFlPzd9+suEV6pKxHMCP2hl/lqubYxmeghJ2WXFWoIS553SXPl+H/KI5ncGhB/rJh
 bwm+o0kn
 AgWcBykfTl1711DfDYdKsiZGyWVwZTZMgQHU+qnrMPc2Yq0sBgokHgUPpd1tKD0ulwp7KPgO7HtdxbWtznz/zUujYojobFPvOSf0Nu4Nkzx7dGFHd51EJalSu+JzkEvnaVWOcZHUQPSMI78LeHEreB6LqbiNeMB4PfX+hfPLvltwb77ctnMRyhqolerLadD2770jkFvqlWXYEcbIVzBOIpHbqsATOtq7DPQo6kz1t0qb0FHlNisc66uqhW7QEPXasIFAN/RcieSQ9Y826JPtHDJArrmQkchJIsS57mqfc6iaquP5QYEVe32GM3OQbLEhh9LjYuZrIwUZw1pCnPoCbw55dQJdbSrwGBTjqKGX5YUTXyMsvb/Uk3AfbGPzIRwzy79tDt+3MbHMD5L0z5qVrpEn83GOucHhjJDsyH27PS+1A0uAFPtPrNp7VG3DZXGVcBlGC+ge3RxZn5LL21ZPKVbDCyw3vXbSYjZ+M934BsNF5THkGePpSuOWzdX7au9VdHFj2RjPzQ/cGvC4bepyKv6/6Sbt0BLnt1EPdB1WmsH3K4nnloOCd+ORa2yRAEKWfI/ms
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/4/25 2:34 PM, Wei Yang wrote:
> On Tue, Jul 29, 2025 at 11:04:00AM +0530, Aboorva Devarajan wrote:
>> From: Donet Tom <donettom@linux.ibm.com>
>>
>> The split_huge_page_test fails on systems with a 64KB base page size.
>> This is because the order of a 2MB huge page is different:
>>
>> On 64KB systems, the order is 5.
>>
>> On 4KB systems, it's 9.
>>
>> The test currently assumes a maximum huge page order of 9, which is only
>> valid for 4KB base page systems. On systems with 64KB pages, attempting
>> to split huge pages beyond their actual order (5) causes the test to fail.
>>
>> In this patch, we calculate the huge page order based on the system's base
>> page size. With this change, the tests now run successfully on both 64KB
>> and 4KB page size systems.
>>
>> Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>> .../selftests/mm/split_huge_page_test.c       | 23 ++++++++++++-------
>> 1 file changed, 15 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 05de1fc0005b..718daceb5282 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -36,6 +36,7 @@ uint64_t pmd_pagesize;
>>
>> #define PFN_MASK     ((1UL<<55)-1)
>> #define KPF_THP      (1UL<<22)
>> +#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>>
>> int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
>> {
>> @@ -522,6 +523,9 @@ int main(int argc, char **argv)
>> 	const char *fs_loc;
>> 	bool created_tmp;
>> 	int offset;
>> +	unsigned int max_order;
>> +	unsigned int nr_pages;
>> +	unsigned int tests;
>>
>> 	ksft_print_header();
>>
>> @@ -533,35 +537,38 @@ int main(int argc, char **argv)
>> 	if (argc > 1)
>> 		optional_xfs_path = argv[1];
>>
>> -	ksft_set_plan(1+8+1+9+9+8*4+2);
>> -
>> 	pagesize = getpagesize();
>> 	pageshift = ffs(pagesize) - 1;
>> 	pmd_pagesize = read_pmd_pagesize();
>> 	if (!pmd_pagesize)
>> 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>>
>> +	nr_pages = pmd_pagesize / pagesize;
>> +	max_order = GET_ORDER(nr_pages);
> There is a sz2ord() in cow.c and uffd-wp-mremap.c.
>
> Maybe we can factor it into vm_util.h and use it here.

Sure, I will make the change and send a new version.

>

