Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E65ECAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 04:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584E78E000B; Tue, 23 Sep 2025 00:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55CA08E0001; Tue, 23 Sep 2025 00:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499798E000B; Tue, 23 Sep 2025 00:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37E388E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:10:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D16A61402FE
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:10:18 +0000 (UTC)
X-FDA: 83919187716.21.6B4185E
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50B031C0006
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:10:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758600617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cbwILMP9S/7uCH7Ly9mb9Ufcp+AGOzkLITV7WrkX2FI=;
	b=35Pk13JcrpyPoANrYoU5Tl8kif/XNR+f9r/WMVyqvQmR6yiqVuvXHUaPJcaGnujjaX3sj4
	BIlUQJXxK4a/DwuupXlYcCPxsFt/KloLVdqF7AGlktCcmcxOTjZq4uXyfYd74L2AtQJyAR
	OfraGQ6cn0xLW6aVbGR0KWtfmHhS3/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758600617; a=rsa-sha256;
	cv=none;
	b=k5+bXKvYvzWBr8xlH0CiXk1BvsU7q5Do8i2liO9MtRweZLJzd+ugKMPkSgrCXZZ8vdkNz6
	r0qAhO72Q/dTVsCm+9WCjI/jvKAeGBHssTTyhHVKjVwF1hIjpFNaNtQGCbB+KwUGAp2LWU
	EbErrXvzJMNICrw3yJ41BSCQM0G6gqA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cW5x869rMzddRl;
	Tue, 23 Sep 2025 12:05:32 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 178EE147E9C;
	Tue, 23 Sep 2025 12:10:11 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.108.232) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 23 Sep 2025 12:10:09 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<rmk+kernel@armlinux.org.uk>, <ardb@kernel.org>, <nathan@kernel.org>,
	<ebiggers@kernel.org>, <arnd@arndb.de>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <dave@vasilevsky.ca>, <peterz@infradead.org>
CC: <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH 1/2] ARM: mm: support memory-failure
Date: Tue, 23 Sep 2025 12:10:05 +0800
Message-ID: <20250923041005.9831-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <9c0cd24c-559b-4550-9fc8-5dc4bcc20bf7@app.fastmail.com>
References: <9c0cd24c-559b-4550-9fc8-5dc4bcc20bf7@app.fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.108.232]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Stat-Signature: 3cjf3634q7cide6jux5rnkiy4x3piodj
X-Rspam-User: 
X-Rspamd-Queue-Id: 50B031C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758600614-831685
X-HE-Meta: U2FsdGVkX18LZZ1Jj5UQq1bAeTAkp9MeI2IvvnA38pTz0CbfTu0U2LZyGWpYstJQnNANUPS+MN/x8NrE/SZ2Wv9DEnmGfU3vKVvFQNxE5zQOJDZKnIbT2H2q3GDkOW2bnAOCIQrZxlzW2PvRolqCp/Mg9Wo2KDol9Nl/tU15kxZFI7pXdMX/TXpULA8PLDX4433Rspq1jOaPixaBrLKewFJ+WYUzv+rSCikdrJNI+yDK0pi+iZjCeMWUL8MWfKr59KtPZNjJcemBHiUkoPdsaHTkNXMkHbsCd9e1xKNY+GpPEwMmYdL69AHGWDqYUgsmPqrr6jme1i2I+hXrKHFcqlIOQLi2vt73s5kVG1LTN3b4fXrHiIao1a1s3CWZQKFk0E/nIyeyE/9yM+grwv4IVFyg9vZTpvMpe8rNVuKUO0kBnigzkRY4gLm6N+0pu/fcDKfXLhVPWVMy6j/4CkfCHjyukWwKxrla/DLLO0ykCQFpQeEpRb+JmCZ9p0ScF5+QfvKECblWRMbagrwUHht8ySm1Klchd57otXBIlb3UexaRkrduYdiSFJzIY8Jc84bCZ6PvpHxllxhL/+iXVpCyGtX2cX8aQ19TuE9vH1CYF2/Cp8VohyklxtYn5JSEfyqqgM8lVEiNYLFw/H7fg6z6h21Jeq1UmuJw6AzZfgxG2BroCyYE2Z6+YP+X1HJ2hJXuc+JFxxYJZbgInJnTromryk7B7DieDyXDHFJMjzlUNxg5zZbzzxh8PMH5TvTN4/N+kPjCosr0V6xL2fuKEGsP6Db3QTVSxunA+UanlpyZAXPq7BnSU7kRJEYDB93Rzf1yI97Z2Mst3dw93hitXBzcswE/vPGGjytqWP2PlutBW5eN5S5YNcseEEizlYJvOaacs9/om4z0+0YKnrexFpAxSnoNvZB5CVm4JNk0oCNcE3r1XDz/6pG9HnlrZxH3oE2xe+afQ5Huxo019D0cM7g
 YRgAu3Az
 /Khq3JpII8aZQSBzTS8CUrpWDiZ6JaQmBNF27Gx1kgZqi/ynJY+SEHqoXSnYiGxrHW00y0kwPk5qvQA6wc3tMITxwsD3ajM5Gk62m38iypgHNPQt1CYsFDdpMaGX4qh5acnouQLNKn0rOqu/S6eXh+8Bc72aDg+kohaEEKtD32ZMPdH70xLWas2JI69X34IaoJ+bf/0fkkrGxC2MRwIqrKzxUgF7UclUGVTqjjuJKt/bFXTrbSx8/AG9aUZ1EJciXpQqXSia3TfvlfOpzFHdo5qVr1KEAzJtB4qEC6uiaZP6ujZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Arnd Bergmann wrote:
>>> It would be helpful to be more specific about what you
>>> want to do with this.
>>> 
>>> Are you working on a driver that would actually make use of
>>> the exported interface?
>>
>> Thanks for your reply.
>>
>> Yes, In fact, we have developed a hardware component to detect DDR bit
>> transitions (software does not sense the detection behavior). Once a bit
>> transition is detected, an interrupt is reported to the CPU.
>>
>> On the software side, we have developed a driver module ko to register
>> the interrupt callback to perform soft page offline to the corresponding
>> physical pages.
>>
>> In fact, we will export `soft_offline_page` for ko to use (we can ensure
>> that it is not called in the interrupt context), but I have looked at the
>> code and found that `memory_failure_queue` and `memory_failure` can also
>> be used, which are already exported.
>
> Ok
>
>>> I see only a very small number of
>>> drivers that call memory_failure(), and none of them are
>>> usable on Arm.
>>
>> I think that not all drivers are in the open source kernel code.
>> As far as I know, there should be similar third-party drivers in other
>> architectures that use memory-failure functions, like x86 or arm64.
>> I am not a specialist in drivers, so if I have made any mistakes,
>> please correct me.
>
> I'm not familiar with the memory-failure support, but this sounds
> like something that is usually done with a drivers/edac/ driver.
> There are many SoC specific drivers, including for 32-bit Arm
> SoCs.
>
> Have you considered adding an EDAC driver first? I don't know
> how the other platforms that have EDAC drivers handle failures,
> but I would assume that either that subsystem already contains
> functionality for taking pages offline,

I'm very sorry, I tried my best to do this,
but it seems impossible to achieve.
I am a kernel developer rathder than a driver developer. I have tried to
communicate with driver developers, but open source is very difficult due
to the involvement of proprietary hardware and algorithms.

> or this is something
> that should be done in a way that works for all of them without
> requiring an extra driver.

Yes, I think that the memory-failure feature should not be associated with
specific architectures or drivers.

I have read the memory-failure's doc and code,
and found the following features, which are user useable,
are not associated with specific drivers:

1. `/sys/devices/system/memory/soft_offline_page`:
see https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-memory-page-offline

This interface only exists when CONFIG_MEMORY_HOTPLUG is enabled, but
ARM cannot enable it.
However, I have read the code and believe that it should not require a
lot of effort to decouple these two, allowing the interface to exist
even if mem-hotplug is disabled.

2. The syscall madvise with `MADV_SOFT_OFFLINE/MADV_HWPOISON` flags:

According to the documentation, this interface is currently only used for
testing. However, if the user program can map the specified physical
address, it can actually be used for memory-failure.

3. The CONFIG_HWPOISON_INJECT which depends on CONFIG_MEMORY_FAILURE:
see https://docs.kernel.org/mm/hwpoison.html

It seems to allow input of physical addresses and trigger memory-failure,
but according to the doc, it seems to be used only for testing.


Additionally, I noticed that in the memory-failure doc
https://docs.kernel.org/mm/hwpoison.html, it mentions that
"The main target right now is KVM guests, but it works for all kinds of
applications." This seems to confirm my speculation that the
memory-failure feature should not be associated with specific
architectures or drivers.

Xie Yuanbin

