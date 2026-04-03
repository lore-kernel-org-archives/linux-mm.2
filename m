Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C4DE8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 17:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DBFF6B008A; Fri,  3 Apr 2026 13:41:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C2F6B008C; Fri,  3 Apr 2026 13:41:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154CA6B0092; Fri,  3 Apr 2026 13:41:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01B536B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 13:41:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 946875887A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:41:47 +0000 (UTC)
X-FDA: 84617962254.02.9322FE5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 32A522000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:41:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=d7GbwScI;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775238105; a=rsa-sha256;
	cv=none;
	b=2vvGUE+InXPq3jWYyaDTPoVNCk7/TWdu04ZpheUoUYF5Mzb8k3crwlOueDrWmkRcWmSRDq
	RjSyF9SPBdVgvUOZH8p8/1Kb3YjoBiI6ONON6CXeV/+N+HkOEXCWpZQNP7jnCYgso/11EW
	/L0+07Mm1fkWn3CBQ3T8HPioD4S5IaQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=d7GbwScI;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775238105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkxScTQSBH039AIlOz7s4kDxGFGT8EvumFs+M+Lv59s=;
	b=2fkw1LGS1UzT75lAwaipHOP/EBziBeV6DWlWvmlXcYtqy52UP+6uOKuVt/oRPF4q851TTm
	U/nECVHOsBtY2MdAc+SUktkwzFuoW7LdHpEK67F0BfVtAfPp1r0e+alPcZ7QpJYC7dsp3M
	EOoKiSZ3iKvVQiif09WiUsV9+3Xf//I=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6339bDlG270868;
	Fri, 3 Apr 2026 17:41:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XkxScT
	QSBH039AIlOz7s4kDxGFGT8EvumFs+M+Lv59s=; b=d7GbwScI33XM97muP/sQQH
	5qqHFFGrHElotpalSLY9r/kORDfjrKTAaGWQWQN61zeW4go4wVSm3smFVNCJRScF
	EXKlVXxSJdfTlImO7aL7mI29hocZXihwf9s4f87O5enYVX6sbmQlLQoheziW9x8G
	1wCeq+HGxYc8ypqI1QhHnOuaOKrowRZsWvZJTJobIS3Dx303xncRxCXawO2qMrbG
	E0YwWoiXnmBzPokeWLL0832nchHvrPrbAYZTOLi+2pRT+KgChexqQzb4sIsLtY7v
	leB/FEl21at9my174AY2kFtKfCTegWcLElHhxQL7C8P3pLCKcxoCp0UKgefsnVaA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d65dcrmyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Apr 2026 17:41:39 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 633D3UWp005947;
	Fri, 3 Apr 2026 17:41:38 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6spyf0tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Apr 2026 17:41:38 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 633Hfcu319268314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Apr 2026 17:41:38 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55B115805B;
	Fri,  3 Apr 2026 17:41:38 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C286058058;
	Fri,  3 Apr 2026 17:41:32 +0000 (GMT)
Received: from [9.124.211.212] (unknown [9.124.211.212])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Apr 2026 17:41:32 +0000 (GMT)
Message-ID: <d48fe27a-75e6-4431-8a0a-427e79adc84e@linux.ibm.com>
Date: Fri, 3 Apr 2026 23:11:26 +0530
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
 <7b6652f3-c994-4ef4-87a4-5473cd1254b7@linux.ibm.com>
 <a1527067-0d49-48dd-85c5-06b628471424@kernel.org>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <a1527067-0d49-48dd-85c5-06b628471424@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=RsjI7SmK c=1 sm=1 tr=0 ts=69cffbd3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=mgfXflzu82Chz1Ycc7MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: jyrK17GrSu3fk7v3w_MYtr3q3dtVP1Ud
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDE1NCBTYWx0ZWRfX4L05kWTBg2oF
 YCgJXnPDx3h+vpsD7qvf5j1A+2q6dUnNBGWMNaXgqqs9CY5ZsN5T7L+JAOJBd9aD1cw1TmZjJBs
 XKiT7LbCE+aZmA+6SQYi2rQxt99/2RTZiTKCl8gjBoJ9Wpnhc0AUIpTfsouYHHz4e/XIC9Xujxo
 AUkpfgTZZGUVwrmvMC5owzLNCAG+XXyUB2K6tt7xgMuSpWHH1kBxrAPJbobpmcToLBhwjipmoPK
 3ulaeFeF07Bo6TJLt72eYsoAQQ33w3k69nYMQDXKDU/GW7C81y1rgad4xhh6x8kdMApGULU/Hut
 S2CF2ZTT3CA1G5e2CVpjzw4pD5fOSOPISBHOZpGmSfPFIZzYcoUpVDcXBmPrJmJksplf5ZdZtYv
 VDJGfHiI3HyC2tM19GoI05tx6cP1U4yu4YYUBbt14wh8n91JfIdrdspAZAuomdF/3jL7Y3rsQvd
 2lv0DDtooZyQrrYyRTw==
X-Proofpoint-ORIG-GUID: t7yKBDzj05PTTN_bQv44gKStj1pyEK9R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_05,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604030154
X-Rspamd-Queue-Id: 32A522000A
X-Stat-Signature: aoi9oibmy6r4awwcgz5gogwpp9zxngu7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775238105-245251
X-HE-Meta: U2FsdGVkX18Zqia3LDwKw2k7lP9vBmMbuRf3MBnmg6N7YnAwTPCnat32Hci5PjCfzu58UiZegeQCYgSzPw8QX+tgJxcU41OXCaQiBOZCrKi0vIJVsbLBkLhzBnjsKUTD+ipl/lWkN8+G+ysa2FIzu9QwnTApbESbGe7EIvStmMCKRpcGdxm4YfZjd3Kh82vlKSYxGvhaTUMKx/4l3WtqxR8YeSLe8OjQo3yf9niv4VlFpMr0MvkwXVK/fdF3BBCOf3jIW+VX/noWVuh+H8/Vdg9beTAEleUeQpg5BYxwUEwOcIdE+jvh6hqaoAUFjIg8CkUF78au1TyCmhIRIkN4v1CZcxJPmUk0lhqeO6CZVLFUQ5mmFPfYC1MSeQkpFaFABQzuB/dTB8KN2Xvc5RwasrV46/QBRmWnpQ3UdtNTV3MAIgxGkz4Nr7XyYwTnZWbDXD7OnkrVfUQjuHK9NHX8cnnnlcDC3boAFOZvXTSSD1DXx5LBzTLzwCt8/WYdaESjMWrkPF+/0Saxv4dypdRFG1WH1p2AovViBnaQcvoVc1O4lp2YqDUgum6sGHq3ewnquT3LE83fIpMxkUom1tDTioLymEZn2lJdZ5zbURSA2NPvnE9T/jHjGfQqVctiGLMK+00gObWCSRSYHdRvVBJ3FQ6tVvAJTDiybbdFv04a3Dk5mlXuqsrLc+PbUcYkv9+Zj5J4a39B9XMUzb+amedaFB//Lh63CS++HgHdNkmcNNOU1rYT0q4WWLFvovzZIUn9yCztw2xTWOP8xXqUtP9CFFNb75cgs7czB4LjgPUGcxlCGmyywQPsIBFSOfInXxX/av2YstqiD5ffDTRARdoGFGipzJfFuyHQAg38TSTzn1xiUjLFNr89jpkOKwEKH1pN3HwlW+KMBvDLShJLLAyVr9Urm+7Egfj9xwh1ICYUO60Zbbs05vLHNH6Ce+jFaZX2VM1mIWRYZkAyJ1s+CzY
 heZeAK3t
 8p1wCCVqXwV4zc2iswASRn779XUHH1BtygCwXgB79qeWMJCcIlvJzLbW2dJ3SBO4rrSuw/HA7V3g3n6fCf73IIhqLCtOcjEzWDq8O7q4nh3vCChw1fqb1EV6qxhro0V2dzEBR59vc1dxu8rz9iaAYB9O/tYokx9tM0eyNNwtfkXSK1kleQFimP7CUGhvc4kKtwN/r/G8fQrFIoOGC1SAZt6ge9eUEbLHiYMr9oLxqIJiJsBIUByw/V8oHO1BGU0dQBTVapE3DFvmjIeskiRe40UC/4Gl7fZY194x8LwYAasOv5NKJzPQ+6uAVvwSHI8ZVj8orEFKnUrGiRtOq7tq+hrXlqovfuViK5SjX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/04/26 13:01, David Hildenbrand (Arm) wrote:
> On 4/1/26 16:43, Sayali Patil wrote:
>>
>> On 01/04/26 19:48, David Hildenbrand (Arm) wrote:
>>> On 3/27/26 08:16, Sayali Patil wrote:
>>>> Previously, register_region_with_uffd() created a new anonymous
>>>> mapping and overwrote the address supplied by the caller before
>>>> registering the range with userfaultfd.
>>>>
>>>> As a result, userfaultfd was applied to an unrelated anonymous mapping
>>>> instead of the hugetlb region used by the test.
>>>>
>>>> Remove the extra mmap() and register the caller-provided address range
>>>> directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are
>>>> generated for the hugetlb mapping used by the test.
>>>>
>>>> This ensures userfaultfd operates on the actual hugetlb test region and
>>>> validates the expected fault handling.
>>>>
>>>> Before patch:
>>>>   running ./hugepage-mremap
>>>>   -------------------------
>>>>   TAP version 13
>>>>   1..1
>>>>    Map haddr: Returned address is 0x7eaa40000000
>>>>    Map daddr: Returned address is 0x7daa40000000
>>>>    Map vaddr: Returned address is 0x7faa40000000
>>>>    Address returned by mmap() = 0x7fff9d000000
>>>>    Mremap: Returned address is 0x7faa40000000
>>>>    First hex is 0
>>>>    First hex is 3020100
>>>>   ok 1 Read same data
>>>>   Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>>   [PASS]
>>>>   ok 1 hugepage-mremap
>>>>
>>>> After patch:
>>>>   running ./hugepage-mremap
>>>>   -------------------------
>>>>   TAP version 13
>>>>   1..1
>>>>    Map haddr: Returned address is 0x7eaa40000000
>>>>    Map daddr: Returned address is 0x7daa40000000
>>>>    Map vaddr: Returned address is 0x7faa40000000
>>>>    Registered memory at address 0x7eaa40000000 with userfaultfd
>>>>    Mremap: Returned address is 0x7faa40000000
>>>>    First hex is 0
>>>>    First hex is 3020100
>>>>   ok 1 Read same data
>>>>   Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>>   [PASS]
>>>>   ok 1 hugepage-mremap
>>> Okay, so we tested mremap() of something that is not even hugetlb.
>>>
>>>> Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
>>>> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>>>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>>>> ---
>>>>   tools/testing/selftests/mm/hugepage-mremap.c | 21 +++++---------------
>>>>   1 file changed, 5 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
>>>> index b8f7d92e5a35..e611249080d6 100644
>>>> --- a/tools/testing/selftests/mm/hugepage-mremap.c
>>>> +++ b/tools/testing/selftests/mm/hugepage-mremap.c
>>>> @@ -85,25 +85,14 @@ static void register_region_with_uffd(char *addr, size_t len)
>>>>   	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
>>>>   		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
>>>>   
>>>> -	/* Create a private anonymous mapping. The memory will be
>>>> -	 * demand-zero paged--that is, not yet allocated. When we
>>>> -	 * actually touch the memory, it will be allocated via
>>>> -	 * the userfaultfd.
>>>> -	 */
>>>> -
>>>> -	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
>>>> -		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>>> -	if (addr == MAP_FAILED)
>>>> -		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
>>>> -
>>>> -	ksft_print_msg("Address returned by mmap() = %p\n", addr);
>>>> -
>>>> -	/* Register the memory range of the mapping we just created for
>>>> -	 * handling by the userfaultfd object. In mode, we request to track
>>>> -	 * missing pages (i.e., pages that have not yet been faulted in).
>>>> +	/* Register the passed memory range for handling by the userfaultfd object.
>>> /*
>>>   * ...
>>>
>>> While at it.
>>>
>>>> +	 * In mode, we request to track missing pages
>>>> +	 * (i.e., pages that have not yet been faulted in).
>>>>   	 */
>>>>   	if (uffd_register(uffd, addr, len, true, false, false))
>>>>   		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
>>>> +
>>>> +	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
>>>>   }
>>>>   
>>>>   int main(int argc, char *argv[])
>>> Yes, that code is extremely weird. I wonder if this was some
>>> copy-and-paste from other uffd test code.
>>>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>>
>>>
>> Hi David,
>>
>> Yes, the test operates on hugetlb mappings created with
>> |MAP_HUGETLB | MAP_POPULATE|and sets up userfaultfd. Consequently,
>> registering it with |UFFDIO_REGISTER_MODE_MISSING| does not result in
>> any userfaults.
>>
>> Originally, the helper function created a separate anonymous mapping and
>> registered it with userfaultfd instead of the address supplied by the
>> caller. However, the test operates on hugetlb mappings, and the registered
>> anonymous mapping is never used in the |mremap()| path being exercised.
>>
>> Would it be better to remove userfaultfd registration entirely from this
>> test, since that path is not actually being tested?
> 
> If it's tested with your change now (which I think that's what
> happenes), this is fine.
> 
> It was just very weird before, because it tested something fairly unrelated.
> 
Thanks for the review. Yes, tested with this change and it behaves as 
expected now.

