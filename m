Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36CD2105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 14:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549146B0088; Fri, 13 Mar 2026 10:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6C26B0089; Fri, 13 Mar 2026 10:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402F16B008A; Fri, 13 Mar 2026 10:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 315E56B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:17:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCF97B5FCC
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:17:14 +0000 (UTC)
X-FDA: 84541241988.19.F65AEBD
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D3D74001B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:17:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lFsswbNg;
	spf=pass (imf07.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773411432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfNCGWtAaD9IfVKOzq6e/E4scor5n7oi/yhJ7PfVTvo=;
	b=OhBTcJksTXJiRU9Zo2kgHgsEghHw/9zFzrfHDbRag5gu4ZxkTmhcWgeODqo4nCDEraj9um
	XR/Bt6BvHEFo1rd5OnetCFzveRQog4UZftGVSOtXdzPkShMh0L0T1eTWrRKaXL6H6RZFuD
	JAHL96TZ4H9NuZ38MmsiOrgP59qSpVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773411432; a=rsa-sha256;
	cv=none;
	b=We2ptfpQV+wz5kVKFWrJJFxZ/+88KlFusoFVSnH4x8e3WbHEn/V4iclIlQX7uMN4YNZ0te
	vSsSNUjozvxsu4/htnmbjNCdmzPJ5hR0+RUanQeBbnKFcW5yUcvpv8xWlCracx3QzwIOCJ
	zCBrpJ9qJPXtEWKk/xVLYX9TLDAwwys=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lFsswbNg;
	spf=pass (imf07.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D4nj3G2583633;
	Fri, 13 Mar 2026 14:17:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=bfNCGW
	tAaD9IfVKOzq6e/E4scor5n7oi/yhJ7PfVTvo=; b=lFsswbNgS6TE1ExdUK9O0j
	gIg0IeZvmDhhalvaLc8yGHQgQ1J/BodB9JJX+shGVxxFEfgf+A9KTFh9x6uLJ/NW
	apJTv+ar/xugp8xKiXduGOZh/SfsLvjn5iyv7iRuZhF+JJIYba7Flenu+oRPjYwK
	obHAiuYb1/8ihCSuN5TiEbGfvCNPMwVe6t+CX54DqBxgjhZdBmNGuvVxsLTOYXF3
	6CTk3mPtsXpz0NPDQZtznLTOlKDR83Lp18vIi2zJAATA7wSAxwch3AQOHJWaZsCZ
	k+IwcOTepl7OZoT55V4oDeUQUPSE8gt0Q0Zw24cNzCmEExFRsqgSOL5iZySIYxOA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh9507pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 14:17:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62DAFO2g014698;
	Fri, 13 Mar 2026 14:17:04 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8ey1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 14:17:04 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62DEH4UY28967668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 14:17:04 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2F2B5805E;
	Fri, 13 Mar 2026 14:17:03 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7727358051;
	Fri, 13 Mar 2026 14:16:59 +0000 (GMT)
Received: from [9.39.23.217] (unknown [9.39.23.217])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Mar 2026 14:16:59 +0000 (GMT)
Message-ID: <1f944b56-acb6-44ee-8cc2-6031fcedaeaa@linux.ibm.com>
Date: Fri, 13 Mar 2026 19:46:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] selftests/mm: fix failures and robustness
 improvements
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko
 <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1773305677.git.sayalip@linux.ibm.com>
 <20260312150526.3662b2717b9a91776a2e43f5@linux-foundation.org>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <20260312150526.3662b2717b9a91776a2e43f5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=QKtlhwLL c=1 sm=1 tr=0 ts=69b41c62 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=YdAoJE3rqbStyI-1upkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDExMiBTYWx0ZWRfX2vRLn5fFjDGH
 e7ZBS7DlBp3DH3an/kn0qFOSrvVmI/70hmKoAoNhMP71PeN4a1Lsgm+uGlyNFFaJ+Ll0zHp2g2P
 TPT9mHE5ApJ/tJ/9IikbHY48V27tlt9VmvlC+IcAPgN5OgZSguNwro9U+VAT6xlKAHi3r5zCKQV
 mYzUirBbhGuryEnVNNW6EHXUiQqNPYoKbnGYHqnO1ZkEn0PGOjrrqlV39D3/Ttx2giT5S/b5Ob4
 pRO/CNIJmrYqxPUrrEkBImJUXoGsSQlEQDWkl80jiSu4Oo8hz2eR5bc7lpXpxBmwUahXBZ6mrOg
 UxFQvZSeEghFNQvk0eVKKDaFpGR+cPWJzWaVVVE+WUu5hg1k7yVRjoJ3iOi2T6ObMc2bOYSEjw9
 v6OYxj0lIwH7zsZNWwIgzKve7Z5e8+CGjsYGYe+I4fKB3/kHrnr3TZiNuOORsGdWQNN9jhqJX9b
 3UiTK5fxrBtnxBgX0eA==
X-Proofpoint-ORIG-GUID: EKxMMvXJO_-Q6FuTg3Mm2n_bv_9p0Ewp
X-Proofpoint-GUID: _FoW35RApTu9sZVdSSuEqYmN99KNbMEq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603130112
X-Rspam-User: 
X-Stat-Signature: r3bc9w5cwixjtyfmb45z3zj1nsaqzidq
X-Rspamd-Queue-Id: 0D3D74001B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773411431-155277
X-HE-Meta: U2FsdGVkX1+yzogghUuRpojGQ6njiSenZvoxcgSFhtwsvCSzFRCWJG5UHam6MYyLXmWrkzdxUU6sEx8LHnUvY5ra9l73GfpdHDUUc9PIsj1q7Tx42YlzqRhHO2TWYeB6EdwDATK1Bqxy/slm/H+eee+NoL49pHsrFR3ur3KmpSb3/jiXiAVRkurlhEoYlHU7HSbKnRE+qOeDsMWhcAICiwUEH8cbQVHE4+kgSFN5qJxdIW4XYLaLEX+E5Y8xLJw2Jn7qJwSw3AnI9mNCBvCsIm6RUSOzGktOrwI0C7T4DIcai+1LlUDEm325eIM1/wBP9Pbb1ZxfdFg3eGEc32tmn5L3MclH5IHFmufo2oWv5yyhcCoNyF8Ii5j8W0xnFVIeKCXnw3L2E5zdY6KIM1qiQQBlA5GqHvYCuk64EZn1FosCko1P54W/CWUtR2QJ5RVCBnK9CaAbqN7Y8KLHk3Bwf7d7ZD/zdH+F+KZfEwxgv92ZZPmn3sJAM8g6o9t0fhXIabDRyPaTXtXAgU9ijKdFV+Fjusn3obQWl0YvHkT4gO+FG7gfqXzJFbo/EPajQ3y1a1qO5W3wEvIO0tMvicbAHyWEF92pXBdnKjlWMPcHCUh6q9dIlWEiZRQMB3usdWB+/pDL6bNBDeieWcpr6cRPerEIImf54yn3/5z7fLWOLCvfvyQT9AVrCERKnTqf6lqjWLWElDJpmOOGL/i/UHAGSH/soVbWgtZ635PKCB1DOzVvIxiddb1MEuzyak6+bNjFNfYc6BYTFsu7dY6AGff/S6pupy9uyzYNRpRPL/gx1M/MpmHH0hlqbOhdf6LCKIj8XOU0gslSQ6LRa+ib7rkGDySd5G3A2khr0571PeDucxS3RQrgJ/mpEMlpY8NXR/g8ir83SYF16/elWTIKT/NjTZldSlDzq7TRsGSUDNJRAyY1HhO/XhH5Q1nOdXL1I9ah0RhiS9YvS8NhqArcoRb
 Sf7yR2lw
 CShGCjEEoA8d7e4MqsJ9Eot6Hc3lOKeHqjGnNy/ti18VcDwkgQvfbGBgkIAvzZftyCCVQ/doc66ByobBruwtFWEkl4XlS0FCzPlbFIin5mNwXWP16WsWhTsqVRf7LHg2rCYdLBflioLyTQQMT1Q8zZ6BvjJFBdzaOO++NKuK0JSyQELvhrQaKUMVdhFZlP/bCly8aPmrGJVa3JR5ydWD+k4hfQnOpbj3iqBi1ZlZ8sq2Rpdik5qxFfY8EtLRHCrv1UroYt7i/OjltpTf2YA/W5+X8FzwCK/CiMzaCgwTe3KDmpNwIaXjGNQ79GgUmB30YAJ7Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 13/03/26 03:35, Andrew Morton wrote:
> On Thu, 12 Mar 2026 17:55:27 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:
>
>> Hi all,
>>
>> Powerpc systems with a 64K base page size exposed several issues while
>> running mm selftests. Some tests assume specific hugetlb configurations,
>> use incorrect interfaces, or fail instead of skipping when the required
>> kernel features are not available.
>>
>> This series fixes these issues and improves test robustness.
> Thanks, I updated mm.git's mm-new branch to this version.
>
>> ---
>> v1->v2
>>    - For "selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap":
>>      update FLAGS definition to MAP_HUGETLB | MAP_SHARED | MAP_POPULATE and
>>      used it for mmap() calls as suggested during review.
> That was a really small change (below).  It's better to wait a while
> (half to one week) before resending an entire series.  So as to
> hopefully accumulate more changes.
>
>
>
> --- a/tools/testing/selftests/mm/hugepage-mremap.c~b
> +++ a/tools/testing/selftests/mm/hugepage-mremap.c
> @@ -31,7 +31,7 @@
>   #define MB_TO_BYTES(x) (x * 1024 * 1024)
>   
>   #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
> -#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
> +#define FLAGS (MAP_HUGETLB | MAP_SHARED | MAP_POPULATE)
>   
>   static void check_bytes(char *addr)
>   {
> @@ -121,23 +121,20 @@ int main(int argc, char *argv[])
>   
>   	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
>   	unsigned long suggested_addr = 0x7eaa40000000;
> -	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
> -			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
> +	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>   	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
>   	if (haddr == MAP_FAILED)
>   		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
>   
>   	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
>   	suggested_addr = 0x7daa40000000;
> -	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
> -			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
> +	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>   	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
>   	if (daddr == MAP_FAILED)
>   		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
>   
>   	suggested_addr = 0x7faa40000000;
> -	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION,
> -			MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
> +	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>   	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
>   	if (vaddr == MAP_FAILED)
>   		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
> _
>
>
Thanks for the guidance. I'll make sure to follow this approach from 
next time.

