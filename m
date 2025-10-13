Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D36CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 03:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A2C8E0003; Sun, 12 Oct 2025 23:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203EF8E0002; Sun, 12 Oct 2025 23:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB848E0003; Sun, 12 Oct 2025 23:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6A6F8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 23:39:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5759A1DD98C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:39:32 +0000 (UTC)
X-FDA: 83991686184.11.2C0CADF
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1961BA0005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:39:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xs0QJcAM;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760326770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzTCrnXaIrWRzmISflwP0SBUw+W5zP+wxm2ZCkd2RSo=;
	b=WhpZAd8SVAi9IJvbHbFeeylWPhYHa5yx7d6/Ap5vAKL8wZ/QEPixW2J5SaYAMD+PlzSuoa
	ch2JxUjhG5ZpUs0T0JGZsAZgqxlJYuzevyPoc3HINWV7+/RAzF1+i4AcFtNVt91MHgDmKO
	+J187qGjLMRPRuXmwwd2EYuqpsft/qE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xs0QJcAM;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760326770; a=rsa-sha256;
	cv=none;
	b=Woh2Uxp3J9kiiFCOYCk8Fp8cRjZ6llkoGCUXVKfu3KM6WckM1eHw1UBfvL/sBWIKiMxetA
	gSOSxLg8aVwSI8iuipTKjQ9067qRDU8gpWZGRNN2OZ7nZimx/pxqKl9THQCXlp8HoXGyKH
	kGkRIBgzfwP9QkS8PbZmOs2sHvYvKiM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wzTCrnXaIrWRzmISflwP0SBUw+W5zP+wxm2ZCkd2RSo=;
	b=xs0QJcAMosm2Eimlc9EiB/+C+H9Cjv8XRaOnA7czp0qrVcn1+8KL1uQBxMJgB8tcAOrfOAPqk
	UxZO7BUPM1W84So+ZY6TymFi4mnirjos4T0VbdhtKR6jvK1046ZSzGSL+TdZAteG7rB6WDlyDo2
	smeFfaD9BrIvUscwMjlx/HM=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4clNNz0F60z1T4Kj;
	Mon, 13 Oct 2025 11:38:43 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 70FD6180064;
	Mon, 13 Oct 2025 11:39:24 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 11:39:24 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 11:39:23 +0800
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
To: Lance Yang <lance.yang@linux.dev>
CC: Longlong Xia <xialonglong2025@163.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <wangkefeng.wang@huawei.com>,
	<xu.xin16@zte.com.cn>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	Longlong Xia <xialonglong@kylinos.cn>, <david@redhat.com>
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
 <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
 <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <839b72b8-55dc-4f4e-b1da-6f24ecf9446f@huawei.com>
Date: Mon, 13 Oct 2025 11:39:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: fs7fjko64bfr5em91t53e3yapws1ezrk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1961BA0005
X-HE-Tag: 1760326768-671060
X-HE-Meta: U2FsdGVkX1/fJofZw4NXNELZVibbB8i0jhMas2Sa0+uVViTsYlznTF8BIQ+EyjzHXc7ucZxHjhuSwI1ZyCcXnomMiQvl1RKapo/KiGzXb1qbtWevKuYkmiVva+HzyoDVkJkcmIQKy/rb3mL6BpCsY3Z+0UyyC3xY/313brDA0c6Snbqe3tPlWfx54dyBbgLCdGD7PpBfbVzXsSxxFQ1kH5HdhkEfrZ+MQJc6HaXlgZUGhQhEdZ9GZA4a1Ps6XyL2CwBUTpz4Z6HMbUySPlM1bsB+rFq0XrQuhSj4C7fOo7nPq3FsvTJvQSddeRKt7FTtNIFzV4tp13nDL2CbP6sNwAFK5IYvj4+afnraE1ZhQXDBNtnCi7vV5JWVEQl02VCMBE5emp6EPgxPkn7wPNKGaY0jIrmpuhzFQVh38XaqQyTyqRjEEm8BCNpXBL6cn+aIXfZt0cZosO6fF6hApSXbNM5h0vp//+n2We/pYhL86HRDJgQnjtdo6gMlbAfwTh5X53JZSCI4srcIdtWej9TH40b/PjMSi2G/nxB8S5LQWDgY4fed6sb3m6k+QR9r2JjdfYDdfjwDqxV7GUc9JanB5IzobAcu9+aeZBLxni4Lcmd6V5fTJ/So64ZHhtAw+TWarj57WWetfsQBiIrcryuc+yi1XMIMFKC5YKJkY7XNVf+zoL/fPTgEKKSTSqXOPZzr+LTr5xOIF/5oeRho1sno0kjleUGZ7HtQhp/QU2pg+7it21mZVpxW+nmSZXldzJMeVMjh0SNjVwe6cfrZAW7uDsqfQvKMmd2AUnsb3kjtZ0xw8rCKurdJGOsDlYb4XPh2mh2wkH+lTi500DLPxqvEzVQ7L4jcmU2WpmwqgglJ7fKIFT38tWBB+7zBtv10a1oQqFE8ZJP0GVWU1O8vxKATjD0J+E7vhGzOUjVTPvKA0AgvridkavSzsYC4X9mSf5e+qyKelj3ZfwiOL/cHtdT
 0603kjFQ
 mD1Bs7r0lX5ODwP6OLqqKe9t/vn+p/4K5VTnACbcIThTWrE0W8GALmrZkVIGfIzwRWvXZnawD5pTQIJaXjEH4wF8mj+wj8aTyHV0muGGPeVw4jF2z39odI6Jb/Qd+3MOp2JuuT93O+VLzmgosyxSgZMNkAPbrmCOBOfxtenAvD3RIPHIMqq0a4VOunZ0OOHK6YHUZlDF6eR8oh6/iE7QivDdPpyqVVhE3a61UVqcp4Ub1jSSwPt6zKrdVj5oCoYgP4B9jR6GmfP1Xp5lBGoUGb+k6Gd7ZhsbziDQ2U7Rx/UdVK7i4LbSRAFTLnKeCMXKSzhgCVm4r3eOZP4jQGyaayblMGIxDuLsLBOmC18Pu3ygR0WkTIw+RoiE6LE9SnqEY+xUBKLIWeAz4Iicue/1UrPWqCXgb3muae7WzEID1zqz/avk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/11 17:38, Lance Yang wrote:
> 
> 
> On 2025/10/11 17:23, Miaohe Lin wrote:
>> On 2025/10/11 15:52, Lance Yang wrote:
>>> @Miaohe
>>>
>>> I'd like to raise a concern about a potential hardware failure :)
>>
>> Thanks for your thought.
>>
>>>
>>> My tests show that if the shared zeropage (or huge zeropage) gets marked
>>> with HWpoison, the kernel continues to install it for new mappings.
>>> Surprisingly, it does not kill the accessing process ...
>>
>> Have you investigated the cause? If user space writes to shared zeropage,
>> it will trigger COW and a new page will be installed. After that, reading
>> the newly allocated page won't trigger memory error. In this scene, it does
>> not kill the accessing process.
> 
> Not write just read :)
> 
>>
>>>
>>> The concern is, once the page is no longer zero-filled due to the hardware
>>> failure, what will happen? Would this lead to silent data corruption for
>>> applications that expect to read zeros?
>>
>> IMHO, once the page is no longer zero-filled due to the hardware failure, later
>> any read will trigger memory error and memory_failure should handle that.
> 
> I've only tested injecting an error on the shared zeropage using corrupt-pfn:
> 
> echo $PFN > /sys/kernel/debug/hwpoison/corrupt-pfn
> 
> But no memory error was triggered on a subsequent read ...

It's because corrupt-pfn only provides a software error injection mechanism.
If you want to trigger memory error on read, you need use hardware error injection
mechanism e.g.APEI Error INJection [1].

[1] https://www.kernel.org/doc/html/v5.8/firmware-guide/acpi/apei/einj.html

Thanks.
.


