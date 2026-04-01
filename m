Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 921A8107637F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6AE76B0005; Wed,  1 Apr 2026 10:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4996B0088; Wed,  1 Apr 2026 10:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B950D6B0089; Wed,  1 Apr 2026 10:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A52276B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:32:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D9331B8726
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:32:40 +0000 (UTC)
X-FDA: 84610228080.09.BD9AE9D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 879E51C0004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:32:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="lUexXE+/";
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775053957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCjnqfzND3siMSjdM7ztAg0ApusfOuj9tUAMFjr53ZY=;
	b=jcWgZcjpCwiZSUs3n1QtV8kWm8fyNblx7jbzOGHWJzB9lreDD6W58+cgFZs0gwQ79Oy9eH
	gzHjI3/n0/RCe1gNBjw9KbVwsp4N8bAILTnz041wV6gMP+GNyscDRgqal6EIotmQ+EdQDA
	BEiXQgsApxAii3tm6r1lwblqBIXhtu0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="lUexXE+/";
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775053957; a=rsa-sha256;
	cv=none;
	b=k5iFJ091lRkBYC5+NiZtK7dxyOddiRVGVP/kMPXWsZuFAxDwrzWsBvf1OUu2g01vpRB/eF
	N28378DxKUdKlcXb5vU2MWGklUlkqB8kPf5JcUyTjcR1NCgjrrd3o+s4ZyTVDZrtjF7Cr4
	rLMPQAWP1Ra+3Bzxw1zdYo1A2/Tt0Xk=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631CXfGr169440;
	Wed, 1 Apr 2026 14:32:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XCjnqf
	zND3siMSjdM7ztAg0ApusfOuj9tUAMFjr53ZY=; b=lUexXE+/iv7l23MV8dz9Oz
	0XEzCy1FXjw990EAmF7E/gNcymfqYhA2gRKKmxaU7hRkeOctQb/qbb8PRYLUHUlS
	TFbSPFYkM8cRfGpSq5sdSifV/QAj4jpichXMmuolEJNvKWR25kU1ZzOPbusdYD7l
	cpmgv6tsDFNcO7T0P9+ungV07c705ctfMR4zS2hWLRh0wJfX6gVkOhaCWMiIxqEK
	BUhuPsLDMqzVHf53A68y6p/qszDRo2uAQbD2F9NcW3SKVl0JYfKhdE8jrbYl2VbJ
	IiO5jRjFT8cLyrWZYPERMKcB7oVaTi1BLTu3aejyrH6KfGd2zMuowFYf4P8ok+hw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66q38m3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 14:32:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 631BjPRO022291;
	Wed, 1 Apr 2026 14:32:29 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6tan5yx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 14:32:29 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 631EWS3X1770044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Apr 2026 14:32:29 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB54C58054;
	Wed,  1 Apr 2026 14:32:28 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 563F25803F;
	Wed,  1 Apr 2026 14:32:23 +0000 (GMT)
Received: from [9.39.18.42] (unknown [9.39.18.42])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Apr 2026 14:32:23 +0000 (GMT)
Message-ID: <b6d211e1-233e-4079-a8b9-6682e12077ba@linux.ibm.com>
Date: Wed, 1 Apr 2026 20:02:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] selftests/mm: fix double increment in linked
 list cleanup in compaction_test
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <4c47a2ebbc41f90c7a0cb3f8b34106b2b64296f6.1774591179.git.sayalip@linux.ibm.com>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <4c47a2ebbc41f90c7a0cb3f8b34106b2b64296f6.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: N46Buve6LLjOY-8cEDx28LKGk35wp2Te
X-Authority-Analysis: v=2.4 cv=frzRpV4f c=1 sm=1 tr=0 ts=69cd2c7f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=_rQTWCYq3bkPLdup__cA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: q70nen16mzFyUJWl05e4U8Txb9r8jnvY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDEzMyBTYWx0ZWRfXxVz1MwK3oBRi
 b593UD/1bwhpKB6ZGc+V1gyY5N3wSUvdD6PIJn+ip4X0z5qBlhU4hTlwJjq0CjZiI6pqhhTzRZE
 oZCOtFPMjtQABspSqebRFvaMc2MRFCCmxOT+sWTHuGHFHcSk3I6ont3eeHT3219qcn32cHaHkS7
 ld8RA5ofe1bmWjrzf1XeSzQ1rQgQhwgl/SqZz16H7KXl2G7USFCtI/5Fs4SKb3goyPIP3rXts4M
 IrkXoL3Jz8bKPQOLExNaj+QM5on8Oh8nz1rb2tF6lE6WxrzoKtB8+gkJ8LxEAsp5WlIGIXpXTla
 9rH06kriLngXUJaPRfyv/GkAzcJ5UsuqFBDUcgi7Z+nEAMySwe8e5l/i96J+BTxw1NUlt5hEu8l
 aQDZIukCAk9RSqribHSDgd4gqa5gN46CV8QT/XlEdPOj0przE/HgR+O5D3TIOfrVZJAn+RUmFbq
 W8iifSNYOHfP21RDdYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_04,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604010133
X-Rspamd-Queue-Id: 879E51C0004
X-Stat-Signature: xg866eop7dg1oo76yjae97czrxmn6pfu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775053957-197744
X-HE-Meta: U2FsdGVkX1+UulIVkj7UVmXW3wKAhC1VPiQklvkxfthENVxv3NmmQxCCUw0RHw/DFGkvT5NsQudHRCEhuzTFxdKHLFCq6/2d9Q5MS6N/MDXufeiGdS/klr6IePPBsGFAn6GNhbWStRtip4R/e/XpeOy8dcOEJAyk8Jh203SCD3JENPU2CNCocr6iwgYhZK1WitVokk6yRzJlZ8TkoPL7BfpYfxbcW+eIBbldKt+6FOAic6/CBZumxh4ctzCxi9ZJYsjOUQBt92DY1UKg8ockaGIrT1ZY9xyzALnEN/kh3Rkv4S3xd/x/3nepjcj+g+kD0ZoVPtWZFD3fTkukJFV+qAL4ookKB+10/nBCh0Mj8f3rOfizh/u+Hje4uCkNgWwcWcqpFUy0Ss4fPOQxb3wRXTMrXtztH8iYaSak6VZSXjMgJ8ajlwwKtl0eLhVkxf9jjo/yXNGAxcaWarbKEKMGoZwJUHOWqMnjMVY+WVQ7ERdD9f/q6VqkC8j7BmD2lj5G8jX4hIIBbFhT+shUroTrK5+vr5MI3IEA5p2T4VrMxfo0lTBnnC/F0BakqDket98ynPkropoqLDlw/+gCeu41VuANgo1rM5j5dASKSHDLJoU0fw9pECM2v+Z3vNgfWVF3fkVHMGWTN01STj9TR/R+gU9v+OCI0J0TQIi1cwc0lpb6BZiRyjkZHJj9CZIjjdDhfEg1vhuzVrlb+b/AjbpEHq0nEuDmJxK/eqmEmIhFRS2brQyZNM/hu84o305dKZY+6A35LXwicxmAYQgUZUrZZAEq5K4yJsIF0BuYEoiHVnRiRlDicW3wA3YqPovYjZR0Cd9zBEGs/uV3k/AF5LCGej8aUKl53A7m6UvGcsp+4DD897LGSlPs8/nCrgOY7xrcYxB4Sv2Jt00vq30xhzsFsqmc5O9Eb+JziBoSKpycSfaSV6c+nWCB3al95RoA2FLsO/ce0onQ7xsNaYyRVrL
 VQ/yJM0N
 s4k7r0kyI/clogk51FQ5SW5qKeI5/nHvXPRwWzUG4EoNvOJQPHLYBJY4Zx8Q8xWjSbPxpxGpcou7bpc+L+3vUL9vJyjtD7U5QaazmgVhLW33YtTRwKyuIZzYBNwQc9SgtRJPaUAmhM2lMWt4OYusuDsguyvVSlaWnCrgY8IJitVY79aUEoiQNTUqvMMpxVko7WZw6TmzQZRNqw6gAvXXKGgfe1QkLPT6gFFpEM9fkyPRHj0zK5Sobo77zeVQfSa6b3oW9Kgtj3elACOAsQ2rqDvGUe4T4rr+YhnRJYGkIipAJCtsnCV5sh0IbTtMVnFyep+BEczH60sIghnLGG703YK/kfOI4E+Nl+t3HBjyeN/DqNcCf/oiwy5nd4LNABadWeCJ6iIQOevIv2G/S6WpcpKBtUCnKJUociX22bxpFyIaH71yWhKJJmQmAUnUDOOUl1AsF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 27/03/26 12:46, Sayali Patil wrote:
> The cleanup loop of allocated memory currently uses:
>
>      for (entry = list; entry != NULL; entry = entry->next) {
>          munmap(entry->map, MAP_SIZE);
>          if (!entry->next)
>              break;
>          entry = entry->next;
>      }
>
> The inner entry = entry->next causes the loop to skip every
> other node, resulting in only half of the mapped regions being
> unmapped.
>
> Remove the redundant increment to ensure every entry is visited
> and unmapped during cleanup.
>
> Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>   tools/testing/selftests/mm/compaction_test.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
> index 30209c40b697..f73930706bd0 100644
> --- a/tools/testing/selftests/mm/compaction_test.c
> +++ b/tools/testing/selftests/mm/compaction_test.c
> @@ -263,9 +263,6 @@ int main(int argc, char **argv)
>   
>   	for (entry = list; entry != NULL; entry = entry->next) {
>   		munmap(entry->map, MAP_SIZE);
> -		if (!entry->next)
> -			break;
> -		entry = entry->next;
>   	}
>   
>   	if (check_compaction(mem_free, hugepage_size,

Sorry, this change is not valid.

The goal of this test is to verify the kernel’s ability to compact
unevictable (MAP_LOCKED) pages. The loop is intentionally written to
unmap every other chunk, thereby creating fragmentation with locked pages
before check_compaction() is invoked.

With the proposed change (removing the double increment), the loop ends up
unmapping all allocated locked pages instead of leaving a fragmented
pattern. This results in memory being effectively unfragmented.

I will send v4 without this patch.

Thanks,
Sayali

