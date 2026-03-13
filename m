Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FD0105F7AE
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 14:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FFC46B0088; Fri, 13 Mar 2026 10:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD3E6B0089; Fri, 13 Mar 2026 10:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085DD6B008A; Fri, 13 Mar 2026 10:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E91C46B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:26:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BA491B6F76
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:26:18 +0000 (UTC)
X-FDA: 84541264836.09.DA71E7E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 259DC140008
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:26:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PeAS+waH;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773411976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHgUOdstFRXEITYlGgY3DjCI5zusFpP4mQmBTm8g4tE=;
	b=q8sPbEKslFVw5Q0o5P7O1a3V61nK9DqtCE5gPwcV7m0UJp+XoSaloon5e2EnVi9f0ZTTpj
	YA89dj4sUdMCngCIzcHxAHOgoBKktNNoat4WJ2AZdH6LRZtRlH3UYOpO66IjkQr3g+Wy9y
	Lx9Ho9Jr9Un5TlYFS4/W92dU/2ncQ5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773411976; a=rsa-sha256;
	cv=none;
	b=FVP7+QjnhjbpmnZCm+n7YYJrzblMUbJUm5YztxkzPFopTaq1HeKYU3GIBqlm0y9HxrC+zs
	4tbhYYE3GceuUriJWCz84EpJwTDTfvWfl8wWBMMKsIB2dcOo2JoR3+3/JwV7XhOKzagWCR
	figNU/o6xZ+rQ0GuvNCqMYKPLbJjh9U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PeAS+waH;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D70tIW2533623;
	Fri, 13 Mar 2026 14:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cHgUOd
	stFRXEITYlGgY3DjCI5zusFpP4mQmBTm8g4tE=; b=PeAS+waHZCe+gRpC7rst33
	/ypJ0yEBn6Sqly7InNjbZjZF4CMRZiasBvQ5gJVggi2tzT8N/BjCJABjQOU36om3
	s4p8KeSvUDs695WcC0C8jLCes95jxkT1Sz9r5PRRsMRjc0X5y5YYPWd/9PeENmBr
	RwiN06qLd2tXQWBJKjuW6ZonBdYNrKkjPj/Qc0lWuBDjig42lvJVIeNQiBZdJfii
	njPLOBmU6dh8OM3aGMZnG1bI7x1VURfDKrlm6/voMFSPm27vLULsR2isuJlQwHiJ
	IZje9zSqHc6iAFkyC+aWHGJnxAELndNy23qclzF3yKfEbNDoq6KUqE72mMUui9JQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh96fxv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 14:26:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62DASuWI014748;
	Fri, 13 Mar 2026 14:26:07 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8f042-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Mar 2026 14:26:07 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62DEQ7OY24183498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 14:26:07 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EF4D5805C;
	Fri, 13 Mar 2026 14:26:07 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AB4458051;
	Fri, 13 Mar 2026 14:26:02 +0000 (GMT)
Received: from [9.39.23.217] (unknown [9.39.23.217])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Mar 2026 14:26:02 +0000 (GMT)
Message-ID: <0e9cea41-7c49-446a-b67b-256584960516@linux.ibm.com>
Date: Fri, 13 Mar 2026 19:56:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] selftests/mm: skip uffd-wp-mremap if UFFD
 write-protect is unsupported
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1773305677.git.sayalip@linux.ibm.com>
 <ed23ff57a80881c9d087d22709862af40addf49b.1773305678.git.sayalip@linux.ibm.com>
 <457dddf1-04ec-4d1e-8640-b04997fac4f1@kernel.org>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <457dddf1-04ec-4d1e-8640-b04997fac4f1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDExMiBTYWx0ZWRfXyFrqHXKrDTlG
 bzQvlTv3Cb2GKRRUrNjAU6EuIDJ461ZhAr/WMhxlpJSDafWfDGonUbvbiQNF9xdVvPuIzEeS8HA
 apyqevWK40VZEbtnabkDiEE92kH3VR/xbJMWtbS0s0Uou9SPKcIqJwP5JzGFsB9Xk4nkxapF3k8
 vKAqtr8/43BK3DQXMOOEo0SwiRdyyShmPOv41cWERTzUxLAoBhMB+JZvrbSQNqlC6840avUtqw8
 2rXOBboz9w/JSBsFJ0umqNOZ01FHDJDEroX3uCbLe0wnTM4caXPSlcOOhXbA2iQ28oEvuZwwXtS
 updEWv4IpJLxckm3U6xkvKnkkzznaj+1Cl3GtawakHiMSSHNhvX87VnNVdQwlSCUmjpAiSFFfSt
 VjMChdvegxscTvl0BIS2uwxir/rJsV/cxoer8fCoU6Oxc0+a+/nGTwfWhanQlnX2MVfs+rwTA/D
 mS+yql/XKIykP0JGJpw==
X-Proofpoint-ORIG-GUID: BzLx54M8v8O-Pi911du9xGBNDUIkuQC0
X-Authority-Analysis: v=2.4 cv=RLO+3oi+ c=1 sm=1 tr=0 ts=69b41e80 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=PItrhlCilDZ6J6cGNoIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: wqVStvOSDOc9kufZk6OpbR-pzgZSWe-l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603130112
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 259DC140008
X-Stat-Signature: hz4r9ceamc7p31f7awfqbaw4hnnr173q
X-HE-Tag: 1773411975-584079
X-HE-Meta: U2FsdGVkX1/lwZBgsQnSovY6j4VTAk5Oih6cZyQPIYgAHjAUj4U/ybaza1iIXeQENUbue+YHMqhx+rhv/4fI4NWraEPx3WQtr9HiNTctJ7qLUJK+DLXEZVe5ZoF7yLQett2GacqW9hrl25rUGOKE0WOszv7qO1q49KbnjiLOPn54t7oltNDkF4Pi4T0zyIs7NyyjAkHK6CmgMcYI+ULvfJM2qercpF/lAx5eNJTgLVUcI9G7gjYtrcOPKXovuwR13Ldz0QWmswqIf+mFxmF46Zxj8oREjD9bz2kiBX+P8JUyPhIv0IZksQip73BIncZp/rB3neEsFPE3VJyheWlN3gY0dH2gy2iITQf3HkbBR/f2IOQmHZAkvgTXMhPOTcYkMQfxQTY90AHShyD2XZcFUthwKY1gytPV3eebD0T9AZps7aGY0y/OaHhqKC0mwaKm2uh9qmreoBQFlGDIb58X4ZfxZfQ8/OfbwdfD6ay0MLIeJDNwvTuqDHCENbMX36NlmWWFtrATDVpVBhI2k8sLeXdNZ8hzNrRinnVs5gvxHue3LbThAs5j9+ofTgXRD1hUs9tYQyEakJd2qP7ruwfcvmRO/DKKiHivDR56Mcl9GbPtZmKS5q18jx8mF1oRLMPoaZcz7tn9kymWSCeNVOsdLxH/AWfygv3Dr1Usat6cffxc5nCK8btZKfgzQllzNpPmzvnvO9/Q4JMMrdZ+MSGry7k9hoKAMNJPVSJbhodba2r3irYJqQQeiBl+8bFKOLDkQO0g5p1yEfwIEmgtK6o+VecBWYAU551apRi4O1a1lxjetP2US3on79hvZjP0IK1Z9aHO+ioWS4IWHTX0O3F44FyR00cz2B9O1t7worJqOR+XY4VhgHEpW1VhFhf6lVSMw0XK/mf0xFF8vY00sSEzsaBYacmH9dI0/2R47SaFYHKrCogQItr3q+4pMz5D4gEmCXR4IYPcLbbLR39jZ2G
 LW8VeQ2X
 OAR+XMepLmWQYpnRT5loCizdl8gGHKdIAzU41H1md/qZP6GJV8RorRjxfQNvgL0RM4py2SFkE/PcUy1xt5+B79Ustcrr75Y8NJ0r72mxhmxplI/Ux1gbqZZyzMs9T0YNa6NBJBNZJBjAiLir9DowLMUN/DW5ImvPHZTPd4XPdajxOcDTEQrlFiSRXY9tOPIxscGsau/gWmOmUneBfuzzrCdsyhym7OdxPSqKnXY2gkmurox/OC6xjEYyhc5r8C65zm7b7X2D98TdP7/Ws4dGIMhXNH5s2OtxrY6E/3+sRxi0EXvd88xaNNdWyIvC7nNZWE+0PYwg2kagQV8ynH8/UXqKQ/RyeVRh+GtD3Z39LnQ9K4WC0RbvnKpiWmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/03/26 18:20, David Hildenbrand (Arm) wrote:
> On 3/12/26 13:25, Sayali Patil wrote:
>> The uffd-wp-mremap test requires the UFFD_FEATURE_PAGEFAULT_FLAG_WP
>> capability. On systems where userfaultfd write-protect is
>> not supported, uffd_register() fails and the test reports failures.
>>
>> Check for the required feature at startup and skip the test when the
>> UFFD_FEATURE_PAGEFAULT_FLAG_WP capability is not present,
>> preventing false failures on unsupported configurations.
>>
>> Before patch:
>>   running ./uffd-wp-mremap
>>   ------------------------
>>    [INFO] detected THP size: 256 KiB
>>    [INFO] detected THP size: 512 KiB
>>    [INFO] detected THP size: 1024 KiB
>>    [INFO] detected THP size: 2048 KiB
>>    [INFO] detected hugetlb page size: 2048 KiB
>>    [INFO] detected hugetlb page size: 1048576 KiB
>>   1..24
>>    [RUN] test_one_folio(size=65536, private=false, swapout=false,
>>    hugetlb=false)
>>   not ok 1 uffd_register() failed
>>    [RUN] test_one_folio(size=65536, private=true, swapout=false,
>>    hugetlb=false)
>>   not ok 2 uffd_register() failed
>>    [RUN] test_one_folio(size=65536, private=false, swapout=true,
>>    hugetlb=false)
>>   not ok 3 uffd_register() failed
>>    [RUN] test_one_folio(size=65536, private=true, swapout=true,
>>    hugetlb=false)
>>   not ok 4 uffd_register() failed
>>    [RUN] test_one_folio(size=262144, private=false, swapout=false,
>>    hugetlb=false)
>>   not ok 5 uffd_register() failed
>>    [RUN] test_one_folio(size=524288, private=false, swapout=false,
>>    hugetlb=false)
>>   not ok 6 uffd_register() failed
>>   .
>>   .
>>   .
>>   Bail out! 24 out of 24 tests failed
>>    Totals: pass:0 fail:24 xfail:0 xpass:0 skip:0 error:0
>>   [FAIL]
>> not ok 1 uffd-wp-mremap # exit=1
>>
>> After patch:
>>   running ./uffd-wp-mremap
>>   ------------------------
>>   1..0 # SKIP uffd-wp feature not supported
>>   [SKIP]
>> ok 1 uffd-wp-mremap # SKIP
>>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>> ---
>>   tools/testing/selftests/mm/uffd-wp-mremap.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
>> index 17186d4a4147..73d53a4da389 100644
>> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
>> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
>> @@ -19,6 +19,17 @@ static size_t thpsizes[20];
>>   static int nr_hugetlbsizes;
>>   static size_t hugetlbsizes[10];
>>   
>> +static void uffd_wp_feature_supported(void)
> Likely that function should be called
>
> "check_uffd_wp_feature_supported()"
>
> Because right now it reads as if it would be returning a bool.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
Thanks for the review. I'll rename it to
"check_uffd_wp_feature_supported()" in the next version.

