Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56110CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AEDE6B0088; Thu, 21 May 2026 05:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FB26B008A; Thu, 21 May 2026 05:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E626B008C; Thu, 21 May 2026 05:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44BDF6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:25:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 107BB1C0425
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:25:09 +0000 (UTC)
X-FDA: 84790893138.10.64C863E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id AB1084000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:25:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=a91vgFwn;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779355506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nN5Zrve5CEI3w9REVd6MPgbUnjHSW03mmKxlBSME++E=;
	b=FoLi1/gHgdIt9nCtjUbd8TWDditrqakqhOKNo1kyYIOabnOQpQJsj0VDlUqmWSWHdO0EUE
	pm0vn2HBKA/YWx3BYa0bExabSSpaqW/YF3DRW2mLPweDpu3yTLHEBm4fFVEXIr+cdBdMM2
	n8XTVlyUqXLMbyms8H6uGSfKaE7+U90=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=a91vgFwn;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779355506; a=rsa-sha256;
	cv=none;
	b=SGGsafw1rovomBMy6gRI4CMdFa3imA3RtP159LRJoWA0AiF9aNoid7eamcqXAkVl4nGXxI
	tKAkmLl67rPOPzKyBQ+Kup+iQB5Wdrn725fqEPiRfUU8xb83VxM67LMlsLhtgB49QX5KUO
	7sAzVz0r8HIgCzQkAdaij1HrQaaB4TM=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KH7qqv2386827;
	Thu, 21 May 2026 09:24:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nN5Zrv
	e5CEI3w9REVd6MPgbUnjHSW03mmKxlBSME++E=; b=a91vgFwnDReTWI7h5j/wn+
	3GWmYl+ngk/WvW204tVZEZTPttYQzsQ+Mt5SwKsmUQK27+HRbhq7i63foukKbSso
	gnWMNSoL9dxD6R0hFxwD7cKJSmbWaQxxAqybfd9YP2dJW363HksgstAjrUy8H9xZ
	5Cy9ocoofsa0FFNjkCgDumdED3gSayixJAP3FXBanqlUeDwi1eF5TKMZr5Whcdva
	O3GbNParyEqdSlzWRcfy00mzUB8YL+MjdEZluJsD7JROx6Oe4g9+pqesZ74Ycf4z
	cXQ/zGbFpcKEcsjhF3aCxSRcS/u0p8RbBiGfHDRtc/qsYOBnsqri0pDPoPm3Kyhg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8mx07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 09:24:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L9OjNg019842;
	Thu, 21 May 2026 09:24:45 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w3g74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 09:24:45 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L9OimT29164110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 09:24:44 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 928C958050;
	Thu, 21 May 2026 09:24:44 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 395EE58052;
	Thu, 21 May 2026 09:24:39 +0000 (GMT)
Received: from [9.123.3.209] (unknown [9.123.3.209])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 09:24:38 +0000 (GMT)
Message-ID: <e5a25cd8-8084-4058-8df4-3da0feedca27@linux.ibm.com>
Date: Thu, 21 May 2026 14:54:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v7 00/13] selftests/mm: fix failures and robustness
 improvements
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
Content-Language: en-IN
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA4OSBTYWx0ZWRfX1HoKC/EE9JqF
 G4zU2TIDhkAWXD/Yagje7FMl61+VMMiiTwkMjJtyo2+k9KXfzARmAsFjhI6Cr0FU+IVR83b3KA+
 7EiNHy1ns1KGljkxFlNivmof+1OXmD1pAQKX2izjVLW8NjccwXjTz7OM+WXAI8totn0yyKY4bcm
 ENqRoY47iLfbZficBmNGZG9OeXIl5jgVpgXFpyyokFqGc4d2+5JmrcFMj7DTx55+gR5eOcSw5Yo
 uwJPIihCZ/phAZ87gxzsXRffw7140ueURW5iRvrASwNCnVtgGKNWf0uwO0nO60XulyVpTF5sxUS
 RiWQ6/EyhZjzUwNod4tl8fZqqVhguNAcLv/kGXFo2MvxACv6tlU3Q56DK9jt/JLxSy6A0Hr90k/
 bNJiyEZXPY31mEHehhqkfL3imEMwk42U4GnU6v7+4y+rbFc/wzxND4+3z3J3JO9qMYVIA4wFcnS
 XWBjUWo03X/LYtLRwvw==
X-Proofpoint-GUID: dXJ0nkajYA2Lru3-zkMYNeHMWyuIfRsw
X-Proofpoint-ORIG-GUID: xgA5V8WKI8AnnvAp33V4fJehmcguyDAs
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0ecf5e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=Cc8i_hhpoAqM_cNX20EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210089
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB1084000C
X-Stat-Signature: zfcqaz8tz3fxd5dq3q7kxod39zu9wc14
X-HE-Tag: 1779355506-224703
X-HE-Meta: U2FsdGVkX1/2SOPzMMjeicso1teLhEzgTlsvUJFhWWLDnbe+86xeqrGgxNj8lL+ti9wkfHOxYJcnfNXRfnYMyPgGpbP+wCEI8+SKDtfZuNmfszPojlu30pqq6jbyxAOaEL0BGQvOHJAi+Hzpelyrko8xO0pfgYBR2d5T4mBs9w3IFl4V93PbE5epOA1UdZVRvYAuDjlBnIZx5zy7+pCNzcelaBvPXxpUADuSEQPFi70z5/Zy/E+O/gx9mHl1cp61D58348J1vc2Lz/PDa55yWe7KLgv3iJ65TE2d0EM6xOHYICYodiib3CaF25EgZkCweihSq6F7O85ktw3Kqrhi5PgiBPVWdpYaXV9f50aJJS6RQ1uVvr3Liyqf8032HqRrSwXMH8x3kuIwD0sTVZdjnOMl/uylBkEQsMztqEQmhtJahTrYI0HZF992iF7rtm7jFhA9J0vQdgwlMd87OHy01z7DJL4e96qNKQQHITOow+woOlr1i4WMgsLCCvoxSuQOH6/84EMHV56Kfwfne1CMZF+XCaH307DS6F08WrxcUw0ex0lSm7dbjMqD8xRsNNmBo0oGke1ZczaYSQnizp3/cX4Cx+oAjO9jdod6Nw49grmi64jrU6zhM/SGwheFaqMPAU0PMFSUIotHHypOYfGnGixy4DZTlM6UoXs5/I/AxMvGDR377Ep9lehMoVyui54yNki5Q+cKif3yowkJYFh6T9cWMadoK1DFG3Lnsq0Q72JvlZDQfn/IVUwLd88V7J3YGjpQmgpYs8p/jbO97bmvO6zHjYqKp8DqO6M+MdQdwlfmyc8vNEPMwaKKpub1QhbMWT4ncvO2a1berUwLSOzrrzQ40vniKTI8rW2hKj1GcsjxiTAperdwNk1E2MXA3cQvkY+/CZnc+JPheTODo5D9IFSjLtZaqaKRq9gU12i6Any3wMcnulVjufLma0mI6zTqP1yKRJQuhNs4Ngcuone
 EKf+Wlhv
 TvSbRyQ6LNj1NHj5+6Pbq/1yT7CzS4vHtdxC8zPM6JqmweTIegZjnAftd5t0F96Hx4oaljn6bE9nBAjGBveoo0Mi3efu9uYlq9nrQyOOH4AxLK8/IVOR0JG1kwCFpTAUF26Zg+orBcUxoJRhaimcUjUCNrXbNBl4K+S2UO6YgCrqpKI1zmI/sUI1783Rg19M+qe22FcJqOB92xEqiPa7idbbILwkzeBbMhntEbyq74NBBMo32WOp6sC2EZCsd+7P1KebZ7ZazsZVOfEk03PMdf0VyKV+JvkLZXsfjj/mmlqmUmgGYXM/42IQIp4SizlJmzNmplKPHsGHZ9yG0c8uVtonM0Tsj9BuuEYr3w3SBQjFJqBqCl74zws90RjWiy2gIOSdI2vH4AG1hG/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/05/26 12:03, Sayali Patil wrote:
> 
> Hi all,
> 
> Powerpc systems with a 64K base page size exposed several issues while
> running mm selftests. Some tests assume specific hugetlb configurations,
> use incorrect interfaces, or fail instead of skipping when the required
> kernel features are not available.
> 
> This series fixes these issues and improves test robustness.
> 
> Please review the patches and provide any feedback or suggestions for
> improvement.
> 
> Thanks,
> Sayali
> 
> ---
> v6->v7
>    - Rebased onto the latest mm-new branch, top commit of the base is
>      commit 0cec77cfd531 ("mm/filemap: fix page_cache_prev_miss() when no hole is found")
>    - Dropped "selftest/mm: align memory size to huge page size in
>      hugepage-mremap test":
>      Similar patch has already been merged.
>    - For "selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero":
>      Changed format specifier of bytes to %zu as per review
>      comment.
>    - For "selftests/mm: move hwpoison setup into run_test() and silence
>      modprobe output for memory-failure category":
>      Added condition to avoid executing the test pipeline for skipped tests and assign
>      ret directly.
> 
> v6: https://lore.kernel.org/all/cover.1777877814.git.sayalip@linux.ibm.com/
> ---
> v5->v6
>    - For "selftests/mm: restore default nr_hugepages value via exit trap
>      in charge_reserved_hugetlb.sh":
>      Extended trap to include INT and TERM in hugetlb tests to ensure
>      nr_hugepages is restored on signal-based exits.
>    - For "selftests/mm: restore default nr_hugepages value via exit trap
>      in hugetlb_reparenting_test.sh":
>      Extended trap to include INT and TERM in hugetlb tests to ensure
>      nr_hugepages is restored on signal-based exits.
>    - For "selftests/mm: fix cgroup task placement and drop memory.current
>      checks in hugetlb_reparenting_test.sh":
>      Updated the subshell invocation to pass variables as positional arguments
>      instead of interpolating them into the command string as per review comment.
>    - For "selftests/mm: move hwpoison setup into run_test() and silence modprobe
>      output for memory-failure category":
>      Updated the condition to avoid unconditional module removal and ensures it is
>      only unloaded if loaded by the test.
> 
> v5: https://lore.kernel.org/all/cover.1776150071.git.sayalip@linux.ibm.com/
> ---
> ---
> v4->v5
>    - For "selftests/mm: move hwpoison setup into run_test() and silence modprobe
>      output for memory-failure category":
>      Renamed LOADED_MOD to LOADED_HWPOISON_INJECT_MOD as per review comment.
>    - Dropped "selftests/cgroup: extend test_hugetlb_memcg.c to support all huge
>      page sizes":
>      Due to intermittent failures observed on some systems.
>    - Added Tested-by from Venkat for all patches.
>    - Added Reviewed-by from Zi yan for patches 7,8 and 13.
>    - Added Acked-by from Zi yan for patches 1 and 3.
> 
> v4: https://lore.kernel.org/all/cover.1775466329.git.sayalip@linux.ibm.com/
> ---
> v3->v4
> 
>    - selftests/mm: restore default nr_hugepages value via EXIT
>      trap in charge_reserved_hugetlb.sh:
>      Updated to use an EXIT trap to restore the original nr_hugepages
>      once at script termination, ensuring reliable restoration on all
>      exit paths.
> 
>    - selftest/mm: fix cgroup task placement and drop memory.current checks
>      in hugetlb_reparenting_test.sh:
>      Updated to use a deterministic synchronization method by migrating the
>      workload process within a wrapper subshell before calling exec() to
>      ensure correct cgroup accounting.
> 
>    - selftest/mm: align memory size to huge page size in hugepage-mremap
>      test:
>      Update test code directly to align memory allocations to the hugepage
>      size, rather than modifying run_vmtests.sh. This replaces the previous
>      commit “adjust hugepage-mremap test size for large huge pages” with
>      a cleaner, direct approach in the test itself.
> 
>    - selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap:
>      Updated to remove MAP_POPULATE flag for the mmap call as per review
>      comment.
> 
>    - selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported:
>      Updated as per review comment to initialize features to zero and exit
>      on all uffd_get_features() failures, avoiding spurious test errors.
> 
>    - selftests/mm: move hwpoison setup into run_test() and silence
>      modprobe output for memory-failure category:
>      Declared LOADED_MOD as local variable and avoided a redundant
>      skip message when the module is not found.
>      Updated logic to set exitcode to ksft_skip only when no failure has
>      been recorded.
> 
>    - selftests/cgroup: extend test_hugetlb_memcg.c to support all huge
>      page sizes:
>      Updated to skip on memory constraints instead of returning
>      EXIT_FAILURE.
>      Updated the logic to fully account for the scenario when the
>      per-CPU stock is empty and a refill charges MEMCG_CHARGE_BATCH.
>      Updated to avoid overflow on 32-bit systems for memory.max value.
> 
>    - Included "selftests/mm: restore default nr_hugepages value via
>      EXIT trap in hugetlb_reparenting_test.sh"
> 
>    - Included "selftests/mm: free dynamically allocated PMD-sized
>      buffers in split_huge_page_test"
> 
>    - Included "selftests/mm: clarify alternate unmapping in compaction_test"
> 
>    - Dropped "selftests/mm: fix double increment in linked list cleanup in
>      compaction_test":
>      The behaviour is intentional.
> 
> v3: https://lore.kernel.org/all/cover.1774591179.git.sayalip@linux.ibm.com/
> 
> ---
> v2->v3
>    - selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported:
>      Rename function to check_uffd_wp_feature_supported() as suggested in review.
>    - selftest/mm: fix cgroup task placement and drop memory.current checks
>      in hugetlb_reparenting_test.sh:
>      Drop memory.current validation from the hugetlb reparenting test.
>      Keep tolerance at 7MB (reverting earlier increase to 8MB in v1).
>    - Included "selftests/mm: allow PUD-level entries in compound testcase of hmm
>      tests" patch:
>      Extend the compound testcase checks to accept PUD-level mappings.
>    - Included "selftests/mm: replace hardcoded THP size with runtime PMD page size in
>      hmm tests" patch:
>      Use read_pmd_pagesize() instead of TWOMEG and cap maximum THPs in
>      benchmarks to avoid integer overflow.
> 
> v2: https://lore.kernel.org/all/cover.1773305677.git.sayalip@linux.ibm.com/
> 
> ---
> v1->v2
>    - For "selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap":
>      update FLAGS definition to MAP_HUGETLB | MAP_SHARED | MAP_POPULATE and
>      used it for mmap() calls as suggested during review.
> 
> v1: https://lore.kernel.org/all/cover.1773134177.git.sayalip@linux.ibm.com/
> ---
> 
> Sayali Patil (13):
>    selftests/mm: restore default nr_hugepages value via exit trap in
>      charge_reserved_hugetlb.sh
>    selftests/mm: fix hugetlb pathname construction in
>      charge_reserved_hugetlb.sh
>    selftests/mm: restore default nr_hugepages value via exit trap in
>      hugetlb_reparenting_test.sh
>    selftests/mm: fix hugetlb pathname construction in
>      hugetlb_reparenting_test.sh
>    selftests/mm: fix cgroup task placement and drop memory.current checks
>      in hugetlb_reparenting_test.sh
>    selftests/mm: size tmpfs according to PMD page size in
>      split_huge_page_test
>    selftests/mm: free dynamically allocated PMD-sized buffers in
>      split_huge_page_test
>    selftest/mm: register existing mapping with userfaultfd in
>      hugetlb-mremap
>    selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap
>    selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
>    selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
>    selftests/mm: move hwpoison setup into run_test() and silence modprobe
>      output for memory-failure category
>    selftests/mm: clarify alternate unmapping in compaction_test
> 
>   .../selftests/mm/charge_reserved_hugetlb.sh   | 45 +++++++++-----
>   tools/testing/selftests/mm/compaction_test.c  |  3 +
>   tools/testing/selftests/mm/hugetlb-mremap.c   | 32 +++-------
>   .../selftests/mm/hugetlb_reparenting_test.sh  | 60 +++++++++---------
>   tools/testing/selftests/mm/run_vmtests.sh     | 62 ++++++++++++-------
>   .../selftests/mm/split_huge_page_test.c       | 27 +++++---
>   tools/testing/selftests/mm/uffd-stress.c      |  6 +-
>   tools/testing/selftests/mm/uffd-wp-mremap.c   | 13 ++++
>   8 files changed, 151 insertions(+), 97 deletions(-)
> 
Hi Andrew,

I checked the AI review comments. Most of them appear to be relatively 
minor.

I have sent one fixup patch ("selftests/mm: use ksft_exit_skip() instead 
of KSFT_SKIP in uffd-stress") for the comment in "selftests/mm: skip 
uffd-stress test when nr_pages_per_cpu is zero". The remaining comments 
were either already discussed earlier or can be addressed later if needed.

Please let me know if you have any additional comments or concerns.

Thanks,
Sayali

