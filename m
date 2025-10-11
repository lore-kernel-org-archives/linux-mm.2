Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 508F6CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 09:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8721C8E0013; Sat, 11 Oct 2025 05:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B608E0005; Sat, 11 Oct 2025 05:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AA98E0013; Sat, 11 Oct 2025 05:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAE98E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:38:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2A47C04A9
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:38:38 +0000 (UTC)
X-FDA: 83985333516.20.F9795B3
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22816100009
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:38:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WnZ7HDOR;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760175517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bU9ccrGCxLrD5q9ZcZ92Iy4RlaTWTf5iyTMrPa72q+g=;
	b=HicJDUbOtyCRKDXgxSRbuI0xWyJ0l2qAMZvD9OitGHfha3AqugdIQsTVwNe4Je5d6qqmNz
	BQ78tWvLCbAcK1PoLGkfhTSk93TcXn9bYrJDoyTbyXc8TbTDQptlCOY1Q1ftGZJm4F52NV
	dLIT/RuqnuqkSJPavUUziQUbd2EG3xM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760175517; a=rsa-sha256;
	cv=none;
	b=qNzn1EKatO4uLOIwKYko8HE6t6rBt/oYDq6Oh7us+eHJfx/xjmGF4objUyVhDB2OsMxZwp
	F+KDG6Och6TWZVfmPulhrUJ6AVt1sUbiz0bA8b/trjoJphfuawhwSCgrh3/MygNMoSHEge
	yITNmP7jMKWLQMqQ6MxYsDcnMoOuAm0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WnZ7HDOR;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760175515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bU9ccrGCxLrD5q9ZcZ92Iy4RlaTWTf5iyTMrPa72q+g=;
	b=WnZ7HDORXRw0FkzY9RY5Hx8Lv3cOFBm336RWJnRpjIUiK2INkFvHgzAft+IaFLiQRSzeaU
	U4xxGNBNVa4j1hj8Dgg4zdJHYbKlR9ZPlhV57nYVbBNlvS0GkSghei13pvQ6cwiLxcNSGu
	vQos+1NrIOp8uHZjz9O/j9CWOsSnxG0=
Date: Sat, 11 Oct 2025 17:38:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
Content-Language: en-US
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Longlong Xia <xialonglong2025@163.com>, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, david@redhat.com
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
 <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: yckckenxqjks16wd5ubm8s5khz3xpgop
X-Rspam-User: 
X-Rspamd-Queue-Id: 22816100009
X-HE-Tag: 1760175516-684508
X-HE-Meta: U2FsdGVkX19PDDflI2dHrPhxYFHLYU0d/zcQpM4PXOdEQ9hKHC19wZdAoPGOrLHCEztDM0leNeCHE5kdpQwIw5wb5oibrPAHlBnDO5UEVOfyNIUSluEcxHdR+1HVE9385r9zwAIuSKLIlKZJg+oCtU4rT9/2i8lArMNdJJeBK229aCHPb/om8oFohq4hH89WyHWjEU2fNDHI8YmHQv5Ik+KyA/6PJbgz6ICgAWGmly9w6ltegcebxKDulD0LBk6olTYcgH3mBTQc/cdoXKAtoCELsGJyEi+lnfLkPR9HYX8qrQr6B/+J3e8XHNP+eYJRrJTQz8jXBVuifMovLqkL2q2l/lfRIB+n/i+t1MYOnfT4DRcaPx3KAOLezHZlWkl5TZyrXbg7YJzCswF5F70CAMFSNZa8ZZ6o7zhfiut20QogdC3WSOMJme48t5EwMwOGfHHzz5J+JLD7+wRnq1mihepkBuXw93yL3cR9/B22CDoWUYst+jC46oWrgt+FU7jbCiO+LCgQlCqyCZQ2HCamzWHGH9KQgwU/bdFnhpn/VJELivTZXC20RAedBcgDJVwCbli8m9/gVSeU/4hggnXWzE4mW10DRbXRM/l+oZybA8v9LVpHNeQeSOBlHUKQkTT2831DkLCR/xjz7Y5z/F9KW0XYDm5yc+FzdZb9E2v0RO53eSZbIq+MdXzwllXhgG/8E7H0pxb69IKZI+QijuBYOybbOTOdB3h2f7rwiIfUApUmLNxiqMYZtp1FrDcZlEtmKzAez5hygCsoP27ENNZgRrcY8UpVsEjvMKbD0qJshelCOYCpa0+atDASrvthB8vUWBIwYkFGjR21afwYwXADE7AZDV+hlkJAYDCEV3aF8XCypffxu0fjpHWWvmBHzWszwOFciOClMAoXUVcPhALlNQfvXLMaYRsAPQozdHxBEba6Qx6r9JxfKq0/LBB8rdISTnM+f1AR2/h03wlQtmR
 QhauuW6t
 vtqWuLyvJjzOntIHBoLBfaK0JLZV62YR1G6/sdLqhMC5Xl/j2yumHlCFt2ExhXGKzjLCuE96AEZEfVtf4qMWc924TKF87ro59oc6ttWVa1bEbhHEOas6gi98gZ/5BoYSF6fkFIq8K49FvLiwoEe4ZyK/p0EbqRtTnpnvfyw9MNk3/UdszC3wITefL6TMclC5rTZjzeUWsNJuK7R93OpkTkAT8PC8HZoqwoeKtQYNOIIKca7GfUB/UXYw+vswEyJtdXk6Us4h/lBMAHj4C+26cm4zY0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/11 17:23, Miaohe Lin wrote:
> On 2025/10/11 15:52, Lance Yang wrote:
>> @Miaohe
>>
>> I'd like to raise a concern about a potential hardware failure :)
> 
> Thanks for your thought.
> 
>>
>> My tests show that if the shared zeropage (or huge zeropage) gets marked
>> with HWpoison, the kernel continues to install it for new mappings.
>> Surprisingly, it does not kill the accessing process ...
> 
> Have you investigated the cause? If user space writes to shared zeropage,
> it will trigger COW and a new page will be installed. After that, reading
> the newly allocated page won't trigger memory error. In this scene, it does
> not kill the accessing process.

Not write just read :)

> 
>>
>> The concern is, once the page is no longer zero-filled due to the hardware
>> failure, what will happen? Would this lead to silent data corruption for
>> applications that expect to read zeros?
> 
> IMHO, once the page is no longer zero-filled due to the hardware failure, later
> any read will trigger memory error and memory_failure should handle that.

I've only tested injecting an error on the shared zeropage using 
corrupt-pfn:

echo $PFN > /sys/kernel/debug/hwpoison/corrupt-pfn

But no memory error was triggered on a subsequent read ...

Anyway, I'm trying to explore other ways to simulate hardware failure :)

Thanks,
Lance


