Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77514D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3126B0088; Thu, 18 Dec 2025 08:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80966B0089; Thu, 18 Dec 2025 08:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C569B6B008A; Thu, 18 Dec 2025 08:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1DA96B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:07:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4AC80133D37
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:07:23 +0000 (UTC)
X-FDA: 84232617966.05.F131E4C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1218C18001E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:07:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oL2wrKYV;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063241; a=rsa-sha256;
	cv=none;
	b=zkP7B40lvLLdJRKyECfBkU0OU+eIQz8GokmS42pw4T1+V3wONbOlIyB2nxvYTByEB5jTPI
	kqOSNBw/XPVVBBnz676nImK7sCGpp0XKq6Ci9ImB3PQNgxCvcBDG5Da3D6fbZG7givo6b+
	HKTRrn/WVWtLcBFNqPRlcriWAlGuTTg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oL2wrKYV;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bVjFftHVS7uWdZpW9/LtnWIGLoCJqI5JblUIwN+Kv4=;
	b=5qmkh5De7DX7V2w+wWVRgLO24O1eQw48llRwAPV0YMrDNcxTC3XfgZi5/aw/pyBd2uEPnC
	VHbT+J6fwRKI2h985aViseyAYbRWlZVL4evBO88Gw3bsp3UlBlmDxoLpC/J0DEKIJi0aD0
	UWlphe/KlAIE4aYrdRF3H3qFHpQuJbo=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIAJhM4011462;
	Thu, 18 Dec 2025 13:06:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9bVjFf
	tHVS7uWdZpW9/LtnWIGLoCJqI5JblUIwN+Kv4=; b=oL2wrKYVOkb6Hv4O5sGlX1
	rjEWnNqOztiynELQMggvGq8sx4nrgdq1QaK6OB19ZDDyZwz0rKWJHidtJUhCMaJu
	B7LcNUlO3wMkXNs7e7ec/P/qxoDBRhsVrfopSTRnPAv8UK1zyc14VnF09QBNQIEm
	lczyTTVcO68kdK/IHwk4dNMSPA20vfmz1QH06R34ov9HdfFUoXmXbZ0OYUZmhVDx
	7YbmVhdj6WtdVmjGfabIeYHScdtHQ8IAkLDWMyOKQPNxLAk8mdHnVzQgjMq5Qgbj
	Tbl9d74sAxgcGJj+UNAaSflpuWhcgigBGelVggjXhlcK1BmuP/iDBPNKaLBKflGA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0xjm9ur6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 13:06:56 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BID6TwE012531;
	Thu, 18 Dec 2025 13:06:56 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0xjm9ur0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 13:06:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIBAuvo002863;
	Thu, 18 Dec 2025 13:06:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b1kfngdew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 13:06:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BID6pOB37159190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 13:06:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58C302004B;
	Thu, 18 Dec 2025 13:06:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC06A20040;
	Thu, 18 Dec 2025 13:06:47 +0000 (GMT)
Received: from [9.39.19.14] (unknown [9.39.19.14])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 13:06:47 +0000 (GMT)
Message-ID: <1fddcf72-26f7-4fb4-84b8-1328e486d58e@linux.ibm.com>
Date: Thu, 18 Dec 2025 18:36:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov
 <bp@alien8.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        x86@kernel.org, linux-arm64@lists.infradead.org,
        linux-riscv@lists.infradead.org
References: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
 <83920c44-47f5-4a46-bfa7-76713197d7e4@kernel.org>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <83920c44-47f5-4a46-bfa7-76713197d7e4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IOMjxDdqC_INVd8pD7lbLmjPG0vfkoRD
X-Authority-Analysis: v=2.4 cv=CLgnnBrD c=1 sm=1 tr=0 ts=6943fc70 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=GZ12N8NoI2vug0DTctEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: rGJZSZAJBQua-nl0FXSZ6hN3il9LBdnD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwOSBTYWx0ZWRfX81IRjmUONXph
 vRAcgAYV2crAU/QbOJ7+PfueA+I8tNHkip0kvKVvQuphwhyC7oqrgSAukbSdpdjxuNYI5umCGCf
 K5+w/qkxfOWhS8HgN14q7okSGpEUZPEtvWx8GpHcGsHSgXZ/Shnj02rFvKJO0xre4+CKtuCEoiP
 dB/GPOCFuV2MF7RA2vZ/lJCBgpIf0a6AsuMAiXDOksBsJQAZ6BxUndMDhkNRxtGXrQ+5MRzP/f0
 AAzNUoSX1crFlsF+mhqU6AVJ7Lzod1K8N/ryvc5l/6RHwdO7me0NDg3htWywFTtQjNefRZQ5SKC
 ikJN5U/o/W0IHViZx/Iiyjg/YIxIUhQ4Nw1yEeALa1D+Ehzv78TUPYuXU8Z2O09tp4XTChyShNV
 qpiBfzUVNwRMF7hOaLwoM49FW/BVRA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_01,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1218C18001E
X-Stat-Signature: hcnbph31ofpi4ij4hu5jwanahyba1nj5
X-HE-Tag: 1766063240-817505
X-HE-Meta: U2FsdGVkX1/G8QPSMSShOhtOe4s/sgZvom67q1j/88MyP+O3TnA4KvflOkNuAJ9ExcNPZSaSUhh0D48aQvXFTENrHIQUigQoD0pXcg963crXQ8akYw35LXzz1/fqKzdNSHpCET5wmZIrCM9CE0OqC6eJ1YopsbRx74f+otgwl0GG68vY4Em/wTewkgMknD7XAsDNpDczC+eqF5R9EPIAC3qgAh9We6LJpkNWvEDY3lbD6VL7bC1Vfam1zQJ3XHETtgcaZyYkzrJiWLAbHR1443GypOjzXJKTnuNdJ26CzJOeQi4+pCmXxATbI4lVQO/cixRVrWpmKtFbjfbPgKMi2/SdkjajQLo7NHkU60jW48uK9++KNxP7yO73lcgLXEyucMA+B5x4UrXUFrglwCXaJnTeRKqE9ikb7AiVCuB/TOTQXVIqi0ydpx4Nt3cGRSqPDGGdhk5DUXK17X1Xz+fMLqdMZSC3746AvuDwO4q9u9eG3DxmK26hAQlx8Wa5zIrolX6ilpwywq+GbuTx+yLg7Z88WYbTJPNBczMcPO6Fls0xpaqRA3VslfN2D2buTfi2hLGI/Ne2/5UN54Q/AXeU6UHJbq8Nvs9Pc2uOrEHu0zj0VvWyqaP7k9nxa7MxRHbmiSXNJJDNZrZpaQul1QRTdNXo5MGWOjA30HSAwUv/IcNhE4FrCmLWZ1IJK4gbt5EK/c9UdSqVu/0FnvGpTFHeM2Z0rd1Sy9PtNN2sQXA8u8nqK+75NRhZmzXz6DZxBX45Ry234JzCRM2SYBa821p++uNt1AO1aCigKQrCy7vC+0lJQ1hc2AuSlWVBb1m182ed5XZYgiIkcCvPidRwsEGVp+kOjOi3ikde0c9hzCMmG6+fpD3OPOI+Q28e5UHwIMTa9vr0rHzlxwrZtaEp8OEFch1zumZvzRG0kAFUWSiUTT6BVWkSiVtZhXR00QdJvLoW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/12/25 17:32, David Hildenbrand (Red Hat) wrote:
> On 12/18/25 12:41, Sourabh Jain wrote:
>> Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
>> default_hugepagesz) when hugepages are not supported by the
>> architecture.
>>
>> Some architectures may need to disable hugepages based on conditions
>> discovered during kernel boot. The hugepages_supported() helper allows
>> architecture code to advertise whether hugepages are supported.
>>
>> Currently, normal hugepage allocation is guarded by
>> hugepages_supported(), but gigantic hugepages are allocated regardless
>> of this check. This causes problems on powerpc for fadump (firmware-
>> assisted dump).
>>
>> In the fadump (firmware-assisted dump) scenario, a production kernel
>> crash causes the system to boot into a special kernel whose sole
>> purpose is to collect the memory dump and reboot. Features such as
>> hugepages are not required in this environment and should be
>> disabled.
>>
>> For example, fadump kernel booting with the kernel arguments
>> default_hugepagesz=1GB hugepagesz=1GB hugepages=200 prints the
>> following logs:
>>
>> HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 
>> 58 hugepages.
>> HugeTLB support is disabled!
>> HugeTLB: huge pages not supported, ignoring associated command-line 
>> parameters
>> hugetlbfs: disabling because there are no supported hugepage sizes
>>
>> Even though the logs say that hugetlb support is disabled, gigantic
>> hugepages are still getting allocated, which causes the fadump kernel
>> to run out of memory during boot.
>
> Yeah, that's suboptimal.
>
>>
>> To fix this, the gigantic hugepage allocation should come under
>> hugepages_supported().
>>
>> To bring gigantic hugepage allocation under hugepages_supported(), two
>> approaches were previously proposed:
>> [1] Check hugepages_supported() in the generic code before allocating
>> gigantic hugepages.
>> [2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes.
>>
>> Approach [2] has two minor issues:
>> 1. It prints misleading logs about invalid hugepage sizes
>> 2. The kernel still processes hugepage kernel arguments unnecessarily
>>
>> To control gigantic hugepage allocation, it is proposed to skip
>> processing the hugepage kernel arguments (hugepagesz, hugepages, and
>> default_hugepagesz) when hugepages_support() returns false.
>
> You could briefly mention the new output here, so one has a 
> before-after comparison.

Here is the fadump kernel boot logs after this patch applied:
kernel command had: default_hugepagesz=1GB hugepagesz=1GB hugepages=200

HugeTLB: hugepages unsupported, ignoring default_hugepagesz=1GB cmdline
HugeTLB: hugepages unsupported, ignoring hugepagesz=1GB cmdline
HugeTLB: hugepages unsupported, ignoring hugepages=200 cmdline
HugeTLB support is disabled!
hugetlbfs: disabling because there are no supported hugepage sizes

I will wait for a day or two before sending v2 with the above logs 
included in
the commit message.

>
> Curious, should we at least add a Fixes: tag? Allocating memory when 
> it's completely unusable sounds wrong.

Not sure which commit I should use for Fixes. This issue has
been present for a long time, possibly since the beginning.

I also noticed an interesting issue related to excessive memory
allocation, where the production/first kernel failed to boot.
While testing this patch, I configured a very high hugepages (hugepagesz=2M)
count, and the first kernel failed to boot as a result. I will report 
this issue separately.

>
> [...]
>
>> +    if (!hugepages_supported()) {
>> +        pr_warn("HugeTLB: hugepages unsupported, ignoring 
>> default_hugepagesz=%s cmdline\n",
>> +            s);
>> +        return 0;
>> +    }
>> +
>>       parsed_valid_hugepagesz = false;
>>       if (parsed_default_hugepagesz) {
>>           pr_err("HugeTLB: default_hugepagesz previously specified, 
>> ignoring %s\n", s);
>
>
> LGTM!
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>

Thanks for the Ack David.

- Sourabh Jain

