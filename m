Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07DCDD74961
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD8E6B0088; Fri, 19 Dec 2025 03:14:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A7A6B0096; Fri, 19 Dec 2025 03:14:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A076B0098; Fri, 19 Dec 2025 03:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 474326B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:14:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13E87B9990
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:14:48 +0000 (UTC)
X-FDA: 84235509456.10.B9F96B5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id A0F204000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:14:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nwttFawp;
	spf=pass (imf04.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766132085; a=rsa-sha256;
	cv=none;
	b=1iL/Y7meP1dPGfNVIAVhAK0TgKnpRRGuRnrk104t5B+Ep9WjJbNe2xQ84jIruquh+O84uH
	j6qXhF85z57WPvH83g5HJyC4u8Z4qvZhUoIZmxUqcCGSWCqzX+ImLPmCdGowr2FFgxEH2g
	t9JRFRR1tZ2XGM1PmNMfP78uc21wZe0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nwttFawp;
	spf=pass (imf04.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766132085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLmAC4hT0OSI18H7TcOFY4Ez6H/3FbSY2SyIRVYgovE=;
	b=2+WacExn/JNAEXmwu+eKq6dbSzmB86fgKV5r1QvtteNkmhQWxF+lYvC4SMuJdr911AlRdG
	1KdhILCU7hNYpiAzRtvwpu0jPuldJWjxMD1J+V0irFtSbIYOR63YZKT8QYtpQvsIJKPabf
	4meXaSsdhkV7Dm/4vuwl8QdiwMePkDw=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIJnu1C009885;
	Fri, 19 Dec 2025 08:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TLmAC4
	hT0OSI18H7TcOFY4Ez6H/3FbSY2SyIRVYgovE=; b=nwttFawpHer+20l410dRlu
	cKOvNOTC0wkbEAA7HSAbXIOCiHGVn5aehw+coVbKAolv/DFC3dnlV/HidILC1RDJ
	CCh+RYEHq1677l3YMI5a4jFgK10x0QpRZlh1HCkN9LTk/yw36fMECqaei29Fe9yI
	4M9htiVhpMNWFIaJ5YfUW9tleDQOqpEwT6FMpR7//SG6E7lDT1HyS1g+jZFnHuqd
	AkEPq+c65fBdubmcTkNI8jbM/vyr734mKAZOMu5FTUY7lhh9gXEndXSUchimT2OX
	YLw6zfxTC34hZPeFM4kffGzkaOqNurRSILC7oN25rPEjRF7S+AgPqkuId6duBtGw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b4r3qacw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 08:14:23 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BJ87tpl013021;
	Fri, 19 Dec 2025 08:14:22 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b4r3qacvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 08:14:22 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJ7ZYkL001249;
	Fri, 19 Dec 2025 08:14:21 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b4qvpjqj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 08:14:21 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BJ8EHdx52822390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 08:14:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C98B2005A;
	Fri, 19 Dec 2025 08:14:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CED9A20040;
	Fri, 19 Dec 2025 08:14:13 +0000 (GMT)
Received: from [9.124.209.192] (unknown [9.124.209.192])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 19 Dec 2025 08:14:13 +0000 (GMT)
Message-ID: <041352df-41ce-4898-8535-d6b7fd74a52b@linux.ibm.com>
Date: Fri, 19 Dec 2025 13:44:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov
 <bp@alien8.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        David Hildenbrand <david@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        x86@kernel.org, linux-arm64@lists.infradead.org,
        linux-riscv@lists.infradead.org
References: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
 <875xa3ksz9.ritesh.list@gmail.com>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <875xa3ksz9.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PyctZo-oqOS2S2ryVat7yBVzS80fLUM4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA2MyBTYWx0ZWRfXytVrcdj3UhfX
 Z8Vv9kMP0lMlwbFYhGcACf7pjgeECzAYFhQeBfU3P07X5wGgFiK9l1nnIAu5mg9e4G5uAYB6xak
 th58W2VYeaEcbUbuCrtcQn3a+sUnLl8JD6j3hdBrzuJfg4KQ7rt5RmL1A+BVc2qz79P2hwYP5ed
 WqgZGZ/zmGdlvU+WpcYuFcw9dwq4Bj/OYhjS3fXjQAAsifERVxszD6rP/QQorzk4k/i7xH/AOuT
 S+27eQb0MkDCeQ96c/ngWWgd6r2PMNDX3+vjEA6GID2JdwjmSh1jNLVO5Un4ntk2bMzcTjk0tVC
 s9U+7Ay7aQva8pBivlzQDr+mXwnPciyysNUsjcyRXEj+gouTutQCHOZI62FwHpPivwDtoOXqlAx
 H0Zm3o0A+OeCQJlE9WX7ZBlPQxgVRvroPCdMLKmlpeP9yVIs9shPkc0ydrcVnBTV9M6rTm6GeLl
 Uez/4l3A21EnUiLKd/A==
X-Proofpoint-ORIG-GUID: KZXZSziruriyHL7lrh2IB41nqPbe4UYL
X-Authority-Analysis: v=2.4 cv=C/HkCAP+ c=1 sm=1 tr=0 ts=6945095f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=ejwGrTNpCrPNuk7NXeMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512190063
X-Rspam-User: 
X-Rspamd-Queue-Id: A0F204000A
X-Rspamd-Server: rspam04
X-Stat-Signature: ag6q4by516d8h6u3ooewfcu3xys4mydc
X-HE-Tag: 1766132085-782013
X-HE-Meta: U2FsdGVkX19WtU9uJg2ohqa1kF7TEiLRRDNUcCA/+S5y2AXLqT3Oiu9igQVJZYS2rhXliSKj/d2LghQdx2Xc+l868zlHzojftTBOjM8oTgr0h2LjLsuNeSiHuAC6ikNo9TYdphFsacx7pGdR2EBXvWKwueJ6jqLGyqfrba1Xh2xCKLoWrv1k7kyBRiNCl3PVyp7m+QsmWwYRte7y5t8b92xLXM0luwrh6izwlIk8VlvcGH1jWY5nc2PIbhRTKCIJppK848zcW1nmt8sjOyTNFCsP/eeWZrJCqdRLhBoEuyMT0W8o+9h9+P3f/i/QoO6/KWKC5Nm+MHKzQNynAH8hR2V/f9bwBx0qF8a8K6PnVSXVcuxHva1qb9mFr9uA91rWBosUrA0qq3iLtP5UtJ4ST3THZYv2H/uW82Yckj0IqO1noHcuYT5y0YgGsyRQ+f2w5/MAyrEGTySm6l6vwbQoTWiqti3dgsSqf+uWsQfVMt3IWw8cdLZEpn0AcvvWhXIELBvM3NCTy8Urs3J7+CFvRoxoL4MwzoodibCFIjUjDGBE7zQsXoowKfQE5tSLOCa44RlwuyNC2qkVwhv3xbYdc3ZxpQz2/+WaON0vLG56fP8fvUzLy+uq/jg16QobO7IUROUVXi5aHsJk5EoZJEPhNBN2HPkF33hC0YE4N9xJWQwSobtc4kVK6/3QYfhIAhA4pPN2WJi7QMx/s3Vpr9+VNcrJK77kePWmhu6WTBZfFmDENKz6yKzJ4TyCSqjtBFrM6FRK4mq8CKdKhmHejr1crgmzW3fWY7KviKOiYTrT3I+WOe8jxAUF6+fp2Uo8wL7Rckn3O28euhHrx9McpoINviydz/7Q3GxJ+FpwEP6+NZanVCeS/OKzP55MseQISL9PJXoBhjSSJFC0nuSHJhH6/Cy+rxyV9YPBthhCPLTHmTXkmZntRrOMwITzfAvi3lcho/Pbc81Sml3TAbh5gx4
 wABTMKQE
 bfto93WCzdJyCBA3+X9H3xaVMB80gUEmNuEO6hW9XOBBAQqLQCM+/X2J3r+eN3PEwltBBxY2c6EO4mkTZSqSNtSFU+MD7wA/hGpBBv7fImuhJXaTL7rn0XqcpuQRznTudAeUzXI8W114w/VMeQOGoREGf/d9MthmbdEqr4A0o+VwoFs1hZ251G08BxBSo49UsT/r1FDQZUMnJIUbkjJg/14JN0ArKmr0f6sC3aUJ54t22+TnK4B5Yqz2grbhKwnn+MO8usP8X1Xoz8PCsEGi8js0TjJKFWZR8WBtsN0BYLRUL97EkNksi6TQap73tE5PTLQBCPthTUOeFhwYONF09UtO3qgfR7jX+J3TsYapDtL3w/oCAYVrgEGHydj0gWij/5ODn6CKXwb/GyBsHDcpgjYe2CJ5u+362VHaRgllEIPJ2cFfsNI/Y0z4Zr74/azZHIE+ja4rQczuhfAhRBWjPSHHEzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/12/25 09:45, Ritesh Harjani (IBM) wrote:
> Sourabh Jain <sourabhjain@linux.ibm.com> writes:
>
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
>> HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 58 hugepages.
>> HugeTLB support is disabled!
>> HugeTLB: huge pages not supported, ignoring associated command-line parameters
>> hugetlbfs: disabling because there are no supported hugepage sizes
>>
>> Even though the logs say that hugetlb support is disabled, gigantic
>> hugepages are still getting allocated, which causes the fadump kernel
>> to run out of memory during boot.
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
> And that every other architecture will have to duplicate this in their
> arch_hugetlb_valid_size() whenever they face the same problem.
>
> Instead like at other places, hugepages_supported() should also be
> checked in the following cmdlines setup functions.
>
>> To control gigantic hugepage allocation, it is proposed to skip
>> processing the hugepage kernel arguments (hugepagesz, hugepages, and
>> default_hugepagesz) when hugepages_support() returns false.
>>
> Right. Thanks for taking care of it. I guess after this patch [1] moves
> hugetlbpage_init_defaultsize() to mmu_early_init_devtree(), it's good to
> bring back these checks in the respective cmdline setup functions which
> was removed as part of commit [2]
>
> [1]:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2354ad252b66695be02f4acd18e37bf6264f0464
>
> [2]: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c2833a5bf75b3657c4dd20b3709c8c702754cb1f
>
> LGTM. Please feel free to add:
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thank you for the review Ritesh.

- Sourabh Jain

