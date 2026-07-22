Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7441CC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447A16B0095; Wed, 22 Jul 2026 09:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7656B009E; Wed, 22 Jul 2026 09:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3341F6B009F; Wed, 22 Jul 2026 09:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEB66B0095
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:51:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BC2C401BF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:51:32 +0000 (UTC)
X-FDA: 85016550024.21.2E88957
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id C470018000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:51:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=bIPv4Yo2;
	spf=pass (imf16.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784728290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VjUgTdKBXVgimfk1nhh4m7/ifjPlF14ARVQofuTq48=;
	b=GcQSfFc9Q+gAtcVw3c1YKLty2uu4YE3Yo1GTllmgIcH+kxuVERpTptIKAOdQTerF/0kTNc
	HT3jYhqiS2Xa8rJ6X8IvkCVkOS6381FhfuGoxliuZGXGCRa8QxhJd1PbnzcOM9lr2cdsl5
	ceJna/8ToTZuQP7J2mjLooX4psJituo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=bIPv4Yo2;
	spf=pass (imf16.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784728290;
	b=7ep7+J3nyL40r806zaAlg8g/psNbepbg4+Pc0zHhepGl9Cs2BfbPQdKSlXaDfy1FBIfU6S
	e6gqVykNW5aeQutVwnN8XSz4vptx6fucxYNU3xwODCSVe+KKuVEyj0Kqkw6R+U7+jsOYKG
	NyyYHRlvPxltYuHm3KYIqp4ViG9JBC8=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6VjUgTdKBXVgimfk1nhh4m7/ifjPlF14ARVQofuTq48=;
	b=bIPv4Yo2UJ4eD73IPWp/UrYfPa//ToDrTZ/AviRgkhfrLp9amqoqK+KZK8J76wrqkz9pnKzaw
	FbzKAZE9AEaDfaWWFxu2weGowjur8nTBM3ljFerX7WJJhz/BIc9xrtgmuxpQUyyIN1kj15Pq6B9
	rmTlxHJhNw+0VC305nkZ0ag=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h4wdD6N55zHnH3s;
	Wed, 22 Jul 2026 21:50:56 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 3188540572;
	Wed, 22 Jul 2026 21:51:23 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Jul 2026 16:51:22 +0300
Message-ID: <1d91aa7f-1601-4cd9-8ef5-8599983bc42f@huawei-partners.com>
Date: Wed, 22 Jul 2026 16:51:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] mm/damon: Introduce a huge page collapsing
 mechanism using auto tuning
To: SJ Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260722134523.87856-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260722134523.87856-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C470018000C
X-Stat-Signature: g5k5nniki8k9w6bk9x18h8mfpib5zrqw
X-HE-Tag: 1784728288-903733
X-HE-Meta: U2FsdGVkX18UEmwcdlQTTSPA0agxv4N4kKeIpRHb2qrJqSHjrwPuJQ+QxN2RGlbgPnIYiPDTZG+ImJeMnT2qyg1gfBfvwnbpb3xROvqUmXaRlkhqJTkiiQI9WHbftZ+P/bw5DrqmBm58+itmddT/VMSeyVhCdgB8ZisSSNgl/mu/SNwzdCUc0k9lYWtYuxLcdG4ee4U8M12b5ZcstTKcpbEpxqHvkgak8HPsR44fGPYIAXcWaiJsAiGd2/6/BJ0xyFz6qZv4utozBoh69g5rJeC9PTBVId17xn8XQh5v1vDGeVn2ARv1H16BllFPXALmSW0hQ+arMIyxwHQncIlxCXY7WPN9+r3scWXdwX7Ldoo7OU3soKFrINQn/ztxWb49MQrrOS/48dYXMQCAs+lILuUQN/CnYjBU8EV9DbF7a9bFRSMwryferxb7EgnUvsqz9bLRGKtdagEaXVBMbIy0uCEuKJ/RtAQPlvP9ZfFBxntPT7pc1Eqa2MljzEFcZzLz+MDKkYs9jg3ilURmWHYT9KTL+Nqzb3teB5Xh/fWxYHs6dhyftZPm7Q2VVx1wLmi1qzIvqndaKPDCBnRSIB7SYjNlSPDGed2fcNUVsZm+92ORwSEFfr0T+KZkwVVegUW/Hs4fzlvYdq4/jae0KlQ37SfKLkS3EuDo75l5a7ahi6GtUBmEj6l251QU3QiBo5GfIyvFQvWAXGdJOHTGaINiQ4F4+KPLGp4qaE2Vj8NMAcP2zbCgG0EFZ1DW2mJ9Zxj94F3uZ+67+eHeKWqfXbjY/xDgPZ+W8CByL/6r1ZE4Io+fWt+CvjaNY3i3TYmrCRpGItKMc2D8vDppfFBW9ohKDr8zCzQkJ+2kVrSLCf+MSN82LejMhwFT0Ot8OQRzLkhZ5XQOz2t34x+o/WYlmYGYxAuVZBysJSP4nu5qqz5dERGTzSDyrqambSeL0GW7OBWXXsjn/AtQOPdBXgHUre6
 Nv5Nt1Mv
 osuauU2mp/82epqWnQVE6k+PfMzO8MFXlW6OW99RVLYEmbCCq3kOG6ydf4jzbZ9eUQ1KYy+pPJR9FP8JACecb7XJA3U8ApmnmnaDTmr7OPAgxahXjMMlzwg8SS8OGWJrdANr+QBtotPz2muIVeK4BMDuQfVwJdXg0WOJ7ElZLrFNOXYjqv9Nzj2ClZsMsXyCru8BN2YdZ+es7YdbLKSIv/dQNmFnx+yCT36UWagQaUFQ0Avx0l74lCq2fbEhsWZXp8wj32Hw2rdNG28wwMRP5iWbrrXR7n0zqGtiZfd/ZfXTxviv1GjLoVgHV0ZUVlDXe+NJUxo/ZAOvi5Dv414kCBrqLz8h1TQ65kULflePJ7aO45ErD1lf+41JGzd3Y7v2aS4WGyOovTA0RpsggwEW4AT59FLvuNUbfXedqh9WGfDRSul4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 7/22/2026 4:45 PM, SJ Park wrote:
> On Mon, 20 Jul 2026 20:58:47 -0700 SJ Park <sj@kernel.org> wrote:
> 
>> Hello Asier,
>>
>> On Mon, 20 Jul 2026 12:01:37 +0000 <gutierrez.asier@huawei-partners.com> wrote:
>>
>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>
>>> Overview
>>> ========
>>> This patch set introduces a new autotuning which allows to collapse
>>> hot regions into hugepages.
>>
>> Thank you for making this series well done like this!
>>
>> [...]
>>> Patches Sequence
>>> ================
>>> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
>>> Patch 2 -> sysfs support for the new quota goal
>>> Patch 3 -> Document hugepage_mem_bp parameter
>>
>> I'd prefer handling 'total' underflow and returning 10,000 instead of INT_MAX
>> from damos_hugepage_mem_bp() corner cases.  But definitely that is no blocker.
>> For the series,
>>
>> Reviewed-by: SJ Park <sj@kernel.org>
>>
>> This series is applied to damon/next [1] tree.  If this series is not added to
>> mm.git in short term (~3 days?), I will ask mm.git maintainer (Andrew Morton)
>> to pick this.  In the case, I will update patch 1 to do what I mentioned as
>> preferred change if you don't mind.  So, no action from your side is needed for
>> now.  If it seems I also forgot doing that or you cannot wait for my action,
>> please feel free to directly ask that to Andrew.
> 
> We (mm community) now want to focus on making mm.git more stabilized and
> therefore ready for the next merge window, rather than adding more changes that
> are not really urgent.  I agree and want to help [1] that.  For the reason,
> unless Andre pick this first, I will request adding this to mm.git only after
> next -rc1 release.  Let me know if you think this is really urgent.
> 
> [1] https://lore.kernel.org/20260722133829.87607-1-sj@kernel.org
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

No problem at all. I am fine with it.

-- 
Asier Gutierrez
Huawei


