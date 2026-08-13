Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A990C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242B26B0293; Thu, 13 Aug 2026 07:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AAD6B04B9; Thu, 13 Aug 2026 07:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1306A6B04BA; Thu, 13 Aug 2026 07:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0CD56B0293
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:17:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 750F71C129E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:17:20 +0000 (UTC)
X-FDA: 85095995040.08.A1D7D31
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf11.hostedemail.com (Postfix) with ESMTP id BCA9C40005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:17:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="y7c/dPz2";
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786619838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqDmY3x99GeRYdiCETTV3FiXwwCqkvOTnz+GthI0fBM=;
	b=GDGBJxmJ2HmJ7Fi0mgkg0IcIZyM8VC0FpjHmXAMTyYiPqG8OiVBXALoLLbNRPBzrqxcgfE
	hcfRL/9NlaxVf0q4RioqRiql3iJJYJzXD2rCOKZFzwdxvwLlhUsHwL6obOoK8ejVQm/Sig
	KKSgnsm4FB1r+ixnhdnGZHI7PgkqbUI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="y7c/dPz2";
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786619838;
	b=uOaqPmuX4e45oX0IyJMIba493DngZ3pXNyOizY1BekZJ0VpqgIOlmoHwZaeJY46OA7LdDg
	P3qjVz62NHZSdQW4vAmWMBnasImBvnuARdTwSv0RjniIUcv0hxuo1EumCzWtA5Vb9m9BBy
	BYBoxsmiHkYBOKUEse1q8vpizrRM4bk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uqDmY3x99GeRYdiCETTV3FiXwwCqkvOTnz+GthI0fBM=;
	b=y7c/dPz28ro3q31Gy+FjZHizteeThz0eP6V+Pu85s5S5LTOXmPnJVa0Xz9tRSJxNnIPDfTI3T
	RfZ7WjSVbaso1xw6KhBu88DZtJoAE8PWe3oi32Bqi5BauBWeLzqPS1vacRhTjKIF390H0fjW7ps
	XFBdV7Nmp0Kv9tgqS3HBUWk=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hLMxb1RCdz12LDV;
	Thu, 13 Aug 2026 19:06:43 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id ABD3640537;
	Thu, 13 Aug 2026 19:17:07 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 19:17:06 +0800
Message-ID: <b35d14b5-65d8-4b8e-8754-de35f03d4b2d@huawei.com>
Date: Thu, 13 Aug 2026 19:17:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/ksm: fix advisor_min_pages_to_scan description
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <shr@devkernel.io>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
 <20260813031722.569983-3-tujinjiang@huawei.com> <an2g39TIN9v87enG@lucifer>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <an2g39TIN9v87enG@lucifer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: h8ehq8stro6fuzq9ytemz6i8okded686
X-Rspamd-Queue-Id: BCA9C40005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786619836-209594
X-HE-Meta: U2FsdGVkX1+NO9v9e5SDA/uVs0ixqdGngWs5xwOAgVdtlPPFcGrjO/ywXNlue1h5wXYNzD16z6owJEPDQUucxouijCDEJGkA1a2zoRf7zZZuAR5/HnZ6KT3gL3n+H3EvX8Y6eKJMoCnYdJSooOUkKJtaGNh4Abnt+dUwhxwOBmR2gnMBiQ4Dar5/mlLMJ1ZrJTYjnC6xHpzxN6E8qNd6VKPVFG7d8Ch16WJpjro5LMfip/l83MIDNS5tMOopwKw6m/8A3R4hgK/XCBdxqSPDyYrJnLgFvlBprOM0YglsbMZgTOcujErfdmTaj6z5IggLGzC8eN3wkKV7n892h1QRAHdZYVfThhkeORouJlUthaVdx+FvlFy9QiohVp00/X1TbOcSW5iA0bkvGHwMasKT6D6QEtsUP/upVdcVZFLoB5f0x4C/V6lCuUCSOkN1NXb767ol01NN5SrbSRfB7EjCtolSmvY+6bvnD0o3E/c8ASZh3BpOjCBlo2ypwcPZ/LooIuAPvdVMrzuSJ4Pwtipj7wjKj2r/lap0bue/jTB2h8HRbkrWJQyoBXtWCH3YXnpW2N58F+LU1FMTPMwUVZnjiej6anlaIHFgd3WE11uHFdGdGvlm6kFtDhhMtdAN+dXGg35ATqgK2UTSm0ulAKjIx7dI8GLITC2HYR4yLybdUFPo/8e8nINuSaOXNHPwgu8G+oMkEqgz6JyUoJF81UmlTTesQfQ0yMZUyB1Zdm7EZUZzzNAxTrFWWsLxmj83crzSaMX8dk88XC9GA8e4crdwL82sxmZmJUB4bvwqxLo4SxVI9pveKCb04eCLk7Q8NBBYk4rRgJHpgWVgKHQCOt4/Bn+xugGofsPeYhNBlo3Fp5ZhxdPrAlfxk/YmoNawvlSlWlNumtwLMc3T222+hTlB/QYizwjns+pkagkt7mHYDEM7xfAANGdvFjjKr9IP5k+hp5UNvcgv0uu8vXe+Jfm
 b1FL0CCK
 D443C1JVvlLDIN+BMMZIscTtKsZDnOgXG5nuiX6QRb8wv3J0VTkJoyRXT+i3qQxQ1giuvOFEtV9GuYBLZM1FmkYWBoDRdwfsuzkIGZIa5+li0rpKk+jYsVhAOsDZlkYstpWDxI4T4nTuRvwvQ0DRvFiAbmg7KT3dXbsZMb2sP5in0RBTfQoD6KcZh4lT3h9f76bD9+uMfWF+bTJbYa1XQZkh0ycVe+GDctf+ZWWtNDYMPA8mTo0+5t0PBptKbC5VgOxD5QMmfJj9uBfCXd2R6SB1r4l3LKW5062WCOFlNx/doAnzoD0wFkly5NAZlWq1PWhjtpLFcMvBb5Phydf1i7UtA66+sb3h0EjY2sLbYQpovB8EiZ1ZypZh+HoiaP7O2VofSsE/wMfJ5L2BYBO2T/9nmkJ3syi1GRfBjz68eNdlN7/DEltLjFOlkdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/13 18:56, Lorenzo Stoakes (ARM) 写道:
> On Thu, Aug 13, 2026 at 11:17:22AM +0800, Jinjiang Tu wrote:
>> Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
>> variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
>> lower limit of the pages_to_scan parameter, but that is not how the
>> scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
>> advisor") only uses it to initialize ksm_thread_pages_to_scan when the
>> scan-time advisor is enabled. This will mislead the users.
>>
>> The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
>> [1], but the documentation wasn't updated.
>>
>> Update the documentation and comment to match the semantics of
>> advisor_min_pages_to_scan.
> Umm, firstly if this were wrong you'd need to change the name of the variable
> too instad of documenting it as something completely distinct.
>
> But secondly AFAICT the logic in scan_time_advisor() suggests that it truly does
> act as a minimum bound as well as being the initial value for
> ksm_thread_pages_to_scan.

As the cover letter[1] said, 'The initial value and the max value for the pages_to_scan parameter can
be limited with:', ksm_advisor_min_pages is used as the initial value, not the min value of pages_to_scan.

The v1 patchset[2] uses ksm_advisor_min_pages as the min value of pages_to_scan, but as David suggested, the
author changed the semantics of advisor_min_pages_to_scan in v2, but forgot to update the comments and variable names.

[2] https://lore.kernel.org/all/20231004190249.829015-1-shr@devkernel.io/

>
> So this patch just looks wrong to me.
>
> But in any case, you are making a claim here yet have provided no evidence for
> it. 'It is just the initial assignment' means nothing - if the logic can then
> only increase it up to the maximum value then it still acts as a minimum.
>
> A brief look at the logic suggests so.
>
> But in any case - the onus is on _you_ to prove that that's not happening.
>
> And even if you could do that, since it is _intended to be a lower bound_, the
> fix wouldn't be alterting comments or documentation, it would be to re-establish
> the minimum as a minimum.
>
>> Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]
> This patch repeatedly states that it is the minimum time. You have failed to
> provide any analysis to suggest otherwise.
>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> Assisted-by: ?
>
>> ---
>>   Documentation/admin-guide/mm/ksm.rst | 4 ++--
>>   mm/ksm.c                             | 2 +-
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
>> index c9f533b10f6f..c329ca747b8c 100644
>> --- a/Documentation/admin-guide/mm/ksm.rst
>> +++ b/Documentation/admin-guide/mm/ksm.rst
>> @@ -183,8 +183,8 @@ advisor_target_scan_time
>>           pages. The default value is 200 seconds.
>>
>>   advisor_min_pages_to_scan
>> -        specifies the lower limit of the ``pages_to_scan`` parameter of the
>> -        scan time advisor. The default is 500.
>> +        specifies the initial value of the ``pages_to_scan`` parameter of
>> +        the scan time advisor. The default is 500.
>>
>>   advisor_max_pages_to_scan
>>           specifies the upper limit of the ``pages_to_scan`` parameter of the
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 7d5b76478f0b..4a6cf8cf5d60 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -342,7 +342,7 @@ static enum ksm_advisor_type ksm_advisor;
>>    * Only called through the sysfs control interface:
>>    */
>>
>> -/* At least scan this many pages per batch. */
>> +/* Initial number of pages to scan per batch. */
>>   static unsigned long ksm_advisor_min_pages_to_scan = 500;
>>
>>   static void set_advisor_defaults(void)
>> --
>> 2.43.0
>>
> --
> Cheers, Lorenzo

