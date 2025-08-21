Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A3CCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95838E0037; Thu, 21 Aug 2025 07:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D738E0013; Thu, 21 Aug 2025 07:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C835C8E0037; Thu, 21 Aug 2025 07:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B83D18E0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:20:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68F67B8724
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:20:02 +0000 (UTC)
X-FDA: 83800520244.14.C792E47
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf24.hostedemail.com (Postfix) with ESMTP id 95711180002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:19:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755775200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+PNfh4sGvW7stzXORh2oYRTzZ51SOZJNmAsSzBMSXs=;
	b=NqidVZaI+E7sS5dXN8IJAV7KtvEovTmbNrif6h/9Rdqj5BITOymcnNEd79B2phihfCA7cy
	rVyxOjomfkzYu4cQo+Gwj0O/pujkTSA3eB7LdYLtxsc/uf/aY8a5s+Euauu4VvckbOrFsU
	0aIpKIaxF8RQqs83EsCzwycIsZXrIpA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755775200; a=rsa-sha256;
	cv=none;
	b=n/2bEDux0iS+rDbLlVZuC15F993w8l8NsFfXvtJo61eF1NagrTbBBYK/FjMLlf41rpDdnh
	9h2gzKrKVcdxpYPJqhZ5kp3iVwtA4wsNIWoU8281jlSYzVGcLNLDcgFMkuBPwZ0jkNQ+tw
	87KWbLwc8YFA2O97mPeL9Cl2cCwzWqE=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c717V6LmHz14MTn;
	Thu, 21 Aug 2025 19:19:50 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F296180B57;
	Thu, 21 Aug 2025 19:19:55 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 19:19:54 +0800
Message-ID: <1463effc-bb59-418a-ad9a-8c30784279df@huawei.com>
Date: Thu, 21 Aug 2025 19:19:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH mm-next v2 00/12] mm/damon: support ARM32 with LPAE
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250820222302.88000-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250820222302.88000-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 95711180002
X-Rspam-User: 
X-Stat-Signature: smbqs7jj4d4kw335p8at95o9tqpaa48h
X-Rspamd-Server: rspam09
X-HE-Tag: 1755775199-274795
X-HE-Meta: U2FsdGVkX19FFJe30IArBcEs4cJHdtfDYPopziFiYA7iRsHM+DOQywigfPDrwGr3EG5hFer2ufS00firoQPczw7iBkhH85+G1ptasviMxxhdICXLlqTp0KIR3u4BRiTXXBRNOmnbzCXImWOfPeUm46tf/FCyKznZ66OQKXfZ9B+BvPkJDiW8EjInJDyozx6qJmwF94hQe0ia6lG2A3dQ/WH/g/P9LRzUljhhzz8i6fEXrqCoAG95g66a6gUxqSI3xhQeceMXnSNiHkx8H8D0uz52C08RmQmQ5Qlb7g5kYg7juFPbr1aTwP53U4kDD+FJownmtGksB7ePnHERs6FyEHlYbVXfSWUr3x/eQrhbpfjWKR6nht4PSFQe5RPDrWuaILR5YLExyeO0PBKGlbbRSosXsiah/XZ/YaMVF70NyYG9+fdpfnTjF+bhcdEhK6kqi81MKRBKMBql0hsxjgvKl1SZwUaLZQ8XBRj4Lnxboma+fAeyWQ4wbE20ys121ULGeNeFt1qWeJmH23wdvFua7qeGRxt0mT+psJSfITDYZGyMrcUSxn73VLGzh+WQblqxLCycHPh1/4pplaroZ/9nYA2kY9S20+A+dUzPT1f9aMq5r8x+jre8rp9aBrOV82buDD8lYi7d/JZtOXJ/gkM7fm3XNoyITSV/5TT+HHq2ilM4CxRGac265pjvOvDEr5nYGlA26xxs1PycuoXk6MUZsmrs68LLeJN88uzKguvav+Q6OX33WCyi6oqh2LWMUp83vo+5jeJumv5e96u3SrvS9L4IqJoxujz4JJrEgXq4VLIZAa6PQpqe9n3zb6eSFo+LyaYJUfwRHwznQuEjt0qTpSEUu5LpRWy9K9rbN9Ovy404nBpYRWT8EYA6bAjwJS9VxdOWxXEsg1LlCislZ1ClhYhEEDknI6IGfeyAl+W1Ud6AC6A1oxqL75K/AcmPTA5x+I03yO+ldHQJuKpLcNG
 4dRKVyoW
 NUWD6+2EuHomimQ5a7FZcndETrzdr4FKwzYd+vE+R6VmRe9LWEQo8aGg6uiIHWbcgKRz39I7XDtfjqmLU+BoDEeL6qx/0cJd6hksK/GncC4yUaT3RlO89sAZFsYTh9q0BFTTW1eFB62z6IIWVQFSvhtFzAV4pZFxHpJ/LFfVItFm5of3UqjW9NYtg1ypc7iPWeTpVQ5Abbv0CPciLUsyGc1qgbTkdbxkyTQUoFPBm4XQ0SsA+mNQS/SDHW8SHYTrZYyTKHfBm0yzAY3leepDm/7VKZrQkkHSnRGGE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/21 6:23, SeongJae Park 写道:
> On Wed, 20 Aug 2025 16:06:10 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> Previously, DAMON's physical address space monitoring only supported
>> memory ranges below 4GB on LPAE-enabled systems. This was due to
>> the use of 'unsigned long' in 'struct damon_addr_range', which is
>> 32-bit on ARM32 even with LPAE enabled[1].
>>
>> To add DAMON support for ARM32 with LPAE enabled, a new core layer
>> parameter called 'addr_unit' was introduced[2]. Operations set layer
>> can translate a core layer address to the real address by multiplying
>> the parameter value to the core layer address. Support of the parameter
>> is up to each operations layer implementation, though. For example,
>> operations set implementations for virtual address space can simply
>> ignore the parameter. Add the support on paddr, which is the DAMON
>> operations set implementation for the physical address space, as we have
>> a clear use case for that.
>>
>> [1]https://lore.kernel.org/all/20250408075553.959388-1-zuoze1@huawei.com/
>> [2]https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/
>>
>> Changes in v2:
> It would be nice if you can also add the link to the previous version, e.g.,
> like the revisions history of
> https://lore.kernel.org/20250819193404.46680-1-sj@kernel.org
>
>> - set DAMOS_PAGEOUT, DAMOS_LRU_[DE]PRIO, DAMOS_MIGRATE_{HOT,COLD} and
>>    DAMOS_STAT stat in core address unit.
>> - pass ctx->min_region value to replace the original synchronization.
>> - drop the DAMOS stats type changes, keep them as 'unsigned long' type.
>> - separate add addr_unit support for DAMON_RECLAIM and LRU_SORT from
>>    this patch series.
> Thank you for continuing this work!
>
>> Quanmin Yan (2):
>>    mm/damon: add damon_ctx->min_region
>>    mm/damon/core: prevent unnecessary overflow in
>>      damos_set_effective_quota()
> I left a few comments.  In essense, let's rename min_region to min_sz_region,
> and separate the last fix from this series.
>
> Other than above, looks good overall.  I think you can drop RFC tag from the
> next version.
>
>
> Thanks,
> SJ
>
Thank you for your guidance on my work. I have published a new patch series,
please review it at [1].

[1] https://lore.kernel.org/all/20250821105159.2503894-1-yanquanmin1@huawei.com/


Best regards,
Quanmin Yan


