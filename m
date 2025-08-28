Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11372CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 03:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592FA6B0008; Wed, 27 Aug 2025 23:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543946B000E; Wed, 27 Aug 2025 23:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480686B0010; Wed, 27 Aug 2025 23:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 386A56B0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:29:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC5B811966B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:29:22 +0000 (UTC)
X-FDA: 83824735764.23.8AB2BA4
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7095DC0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:29:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756351761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zfd7ud0AtAG/V2aZ5kkuObo2GqOvoseEj49P6g0rfXs=;
	b=CaetoWayduIkyOyEQV32/K2owKkg6ZCdkbnpzOIhrgYd0l1Y6IOct/6F53it+HCHaXUQvt
	5n3OvaJ80z3gDqClw0hPKc9wREBUhj5CgnDpa0TE9phbLr21Co4HiR9cpldnP2s+SqO7XK
	OzN/x91i8h/PsrRJw9ipi6mRAEfpgtc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756351761; a=rsa-sha256;
	cv=none;
	b=1fZ8fg0ZlYQFFe+UmtSBVxYSSAH4UyPAd6Q5JZhy2KA0B/MVgvZnJQDEcpK/VNe4/zZfcn
	qrtpoOzmY/ycdsMVOIoOAckrp/HB3AYDkaoqznVlqKOabTFQN6Qyli/NHOmskhuIs4CLEc
	APLkC4TJ0SjttSC3UDfTnRzQ0gxy7uI=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cC6Fy6m2fz69cS;
	Thu, 28 Aug 2025 11:24:38 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 348C418048E;
	Thu, 28 Aug 2025 11:29:15 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 11:29:14 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 11:29:14 +0800
Subject: Re: [PATCH] Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
To: Andrew Morton <akpm@linux-foundation.org>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20250826030955.2898709-1-linmiaohe@huawei.com>
 <20250826203552.b4340b12b16a374396f49343@linux-foundation.org>
 <0138514f-c580-c066-c16d-2a0b207e0604@huawei.com>
 <20250827194934.f30fe19856fc343005c9703f@linux-foundation.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <a770f778-81c2-3325-b44d-43a95134c189@huawei.com>
Date: Thu, 28 Aug 2025 11:29:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20250827194934.f30fe19856fc343005c9703f@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7095DC0007
X-Stat-Signature: zxnzq8matbbyabx3zcygss4c5oqgpqb7
X-Rspam-User: 
X-HE-Tag: 1756351759-693417
X-HE-Meta: U2FsdGVkX1+Be1tdQlTUZ4coYqzbASgAUqWufsoLE+PgjP2Jca9rX9GBFjIhuNVbdBsVVHZiSnGANsyDxvrO3pHH1j+Wz5vTct76aZ0x8ZvQQ7EzCmdCT2+sqA43GHcywRweHfE+PLCrFSwLxO7MNmYgv/EN8HwyMFZ6Q+F6MuYNyamjkPcFNUedxotjbkm48+G4f+zTUABU49Q2k4XitNdBcd70SbV514/dyneAdtnlLW3tvnXG4Ku4py2LGtlgiEyYon+G/Lq/wxcPaC4JbS8kv4ZqL3MKOq6rOdIGPc7ptXiUHwXU3YZ9NS4hmFvyLSJt9h2X8lFcpYE95sNDSUiRMY4Eezhk3O2w/wnMo2CIA4Hk/n/a2a2rbinGahJHBSNweW/fpiUPl/yRHlvQEaGUzMHCgu3Yg+tbc9l43UoNwPcyAtvc4YmbAiu2JaEiO0sQYsiEkdmzSvHYFH/p5SaZPf4vchgYg8Na5oQwUOIbRX2peB62IkqUiO9vz6hMYcYPytGJfR3vBlMt0mOu1bUHzL0yYfdl4C1jUDM2oXNDC5TQ5dtINFfi7Rzy8bMrpiedB+kK+A+rpfzJr6yT+kPJbJivI+/FdvXFVIQHA111ssUE+uz5EguQs3YgBZHFpzOEXSYFH8U3QueLvv9V+YU+NwIq9+l8Ocur9JQD1KzaKi1vr3NcBnK6NVSvyBr/xtpsUBaK3qae1e/UpgjNHyJClgjolJI8fip7hXPqY+vnHnYclwutgaxlvhjbnkfG5CggCukYPhAuryFdjdm6ZGsRC/NWwbMIoh2B+ekawLN5GqE6Jh7h3PdjEJQjirBSIq2bduFDVAbOLnfH3QW6iTwbMZyHMhkOuoo3pdDeViGvgHBiQaQwFVmNb5lyB86yz2niRb69NLi7h1wADTLJWm8R4yrLk0okr+Hqae/TYAeiemMyGw+LeMpdtla8nbMauS3jJSC2oX84j52nTLw
 iwza48cA
 lMM6jgUWFxUZH/GtT1BR9ZPPOoS52X9IVdkiag+BIdUMvhn1iLF25R83vp5WuijqAaM/hXfL6udyuTCR1UtY4OGlPixeQR0IF6mQODt5M0Mzr7ah/17j9iudPwX8ByI1WpTy5p+T8O6Fg/53VsayATAHnSAj+B+iWZHXkuDdIMcRGGs/LXgS0I4oLja2V1d97FPd9ylIjPrTVoBhw9iNvc+4unqbqgszK/siekugIGksytpvv0EgSxj7EkV1QsQWoN2YpdtNYGA9ui54awMGKXMtPtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/28 10:49, Andrew Morton wrote:
> On Thu, 28 Aug 2025 10:31:51 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
>> On 2025/8/27 11:35, Andrew Morton wrote:
>>> On Tue, 26 Aug 2025 11:09:55 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>
>>>> Commit f8142cf94d47 ("hugetlb: make hugetlb depends on SYSFS or SYSCTL")
>>>> added dependency on SYSFS or SYSCTL but hugetlb can be used without SYSFS
>>>> or SYSCTL. So this dependency is wrong and should be removed.
>>>>
>>>> This reverts commit f8142cf94d4737ea0c3baffb3b9bad8addcb9b6b.
>>>
>>> f8142cf94d47 said:
>>>
>>>     If CONFIG_SYSFS and CONFIG_SYSCTL are both undefined, hugetlb
>>>     doesn't work now as there's no way to set max huge pages.  Make
>>>     sure at least one of the above configs is defined to make hugetlb
>>>     works as expected.
>>>
>>> So there is now a way to set max huge pages?  A reference tot he
>>> commit which made f8142cf94d47 unneeded might be helpful?
>>
>> The commit is just wrong. It overlooked the scenario of using hugetlb through boot parameters
>> when it was submitted.
>>
> 
> OK.  Could we please have a description of the user-visible effect and
> a decision on whether we should backport the fix?

For users with CONFIG_SYSFS or CONFIG_SYSCTL on, there should be no difference.
For users have CONFIG_SYSFS and CONFIG_SYSCTL both undefined, hugetlbfs can still
works perfectly well through cmdline except a possible kismet warning[1] when select
CONFIG_HUGETLBFS. IMHO, it might not worth a backport.


[1]: https://lore.kernel.org/all/5c99458f-4a91-485f-8a35-3618a992e2e4@csgroup.eu/

Thanks.
.

