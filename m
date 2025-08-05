Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE5AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 08:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165EC6B0099; Tue,  5 Aug 2025 04:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFAC6B009A; Tue,  5 Aug 2025 04:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005606B009B; Tue,  5 Aug 2025 04:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E629A6B0099
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:47:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63DD8C010B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:47:40 +0000 (UTC)
X-FDA: 83742075480.29.68D0A43
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D4A412000E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:47:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of mawupeng1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754383658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vK0xdlXQ5Cdw/4Zae1jVmeLIJx8HH77nwAsCPzAHkOM=;
	b=Gop0wLS2szvZdEwNgDgcSCUImSZ2EZyKPSquO1zdXYn4xspbI4bF77lIi3rxn9Pre3tiaw
	qwPOwyDz+b73oLTVtOt0KlHsMw6No6C/wEprEpWpbr9q9gku9mB4xP8aNHRuOicX1iy44b
	hdJ1GlUw7zNU0fyOsRYY5GtTQaU1iDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754383658; a=rsa-sha256;
	cv=none;
	b=oXOYDN/4bfQL+6uaXB1U9dL+FhgQkhHnS0McTfQ4pj0mo1rficXrAr62RHQfJi1/gf1onY
	xDjVXkFbhilZAP++903LPzXHSSHlIv5kMNLC87MdbLQ5k0TMV7uIZCl+yt6pb0eXlVcVDM
	Qa09qFtFe9fjr0rAJ22UBkJnFiQEfSY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of mawupeng1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bx6QD1Xj8z2Cg3h;
	Tue,  5 Aug 2025 16:43:16 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 33DC5140143;
	Tue,  5 Aug 2025 16:47:32 +0800 (CST)
Received: from [10.174.178.114] (10.174.178.114) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 5 Aug 2025 16:47:31 +0800
Message-ID: <113b914f-1597-41ca-b714-7ea048c3c6df@huawei.com>
Date: Tue, 5 Aug 2025 16:47:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
To: <rppt@kernel.org>, <ardb@kernel.org>
References: <20250717085723.1875462-1-mawupeng1@huawei.com>
 <aHjQp9zPVPuPyP3B@kernel.org>
 <9688e968-e9af-4143-b550-16c02a0b4ceb@huawei.com>
 <aHj8mfecDhJJZW1Y@kernel.org>
 <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org>
 <CAMj1kXGKGXeKGKWT3VzkBtACtjFyz8ntiyoTU26DA4aR6mi88g@mail.gmail.com>
 <aH9JMT93itrztZ+m@kernel.org>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <aH9JMT93itrztZ+m@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.114]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemg100017.china.huawei.com (7.202.181.58)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D4A412000E
X-Stat-Signature: 4jy6ze8k98b6zh5fsptgnqjkafeiiwad
X-Rspam-User: 
X-HE-Tag: 1754383656-593507
X-HE-Meta: U2FsdGVkX1/2oLqiRTTnMW+3HC762tNnVaRlXkXnbyU/w5vyBJS+6lTpxr17Z36fMqJblpdAwVJzc9eEaRDoEdzvcM0amAheMrOfuuQ/mkFB2RKhrTqkAlUlLPUvK+QlOe88NVNMTsecBVzIpIU2r5eGRU9j8aaCLbwl2NFaF8N+EIWD0eMZxqmzvfAiDoDTn/icyf3PXjGJ6+jGS76p+HbVNcURVWEbRWEdLGHqa7uTuPU2IHAC2XlLdBPicePvAe5gBsFgyb9mANOTWdlUBetGeKxXLhW7lh4Q8Ipy3OVcVqF6f9J9mjDR6pOYxCBPx6FE5iy8ePvDIJtxFu/KoRC/xc2KIuyp5mLrAAD9I4Npwqjr2Z45x4O5X1wGNU/LMHfZLKnhlntJ3WsDIHjcM+JK+AP//bxTk3b16veioNxZlA9WEegTpsr/AtQbLAdfNk2tItCo8V1uUGFEXHneRc7rrnrQE/yVuwBe43MEI/4Vu+5GodaOgETq9pf2c0VW08zBlc7EakowppIMknb15TJEVBa8hm9wB3Lid3wN5mZ83qBbB8Yq4ljHoRdPz/5CYNRSnI52B2hLne5aoXumtvYTl/gJUNQY3INSyVot9FOwZq0cR4Ac1B2FTkQ0US074uzGBuyO8wIQbmOkdraYTuqWxJaL1o4gTgjWJBc2Swc6uACPcvnGtsKvTq/fujVTXnQP3n7k9QHl0g4RuhmyYxktGN9+2wgCn2ObCrEG2op9hzYou35NY70MPyki3MF8GI49XhxlykPQaOLWoIfLupceTPej5TlmhC/YzXmrU2Q2Jdd4fZo2Y5wYNXIhKbg1PiPxL+clBpEYaVoJ2YfNQd+cLndcAtuMTvEVbvMEjxHOt/ZZTmAH23wknwpY6j8jRVBUmqktDR/gynpcFs1UuMMLWWtlpJOwHgAio7cKSrsVVteccWGeEQGy8o3JZECuAhK3wO8V9PHuaY16RfC
 xwUyc/kZ
 YAiFjfVibt8L3+tc55Tv5oQRGrBSfg47FBfec1mr0Z59VACAOmCTXsnudKl5Y6DRGQWNZZOg8Q/HWn1mHpiEwvsDyogJstN6AZfR5C/9nhw5FNovdHixjoUaNCHjqIbz7SbS9N8GGSzZ8/40nj9cSb7rwxmylGi5uJtNby37hEQC+TqEiM8bsOG5o4hEZLQEdKw+QU8Y9Xxw5hKZMfKeFZL4DARK7bCyeFP1bPjBs43gHtz0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/22 16:17, Mike Rapoport wrote:
> Hi Ard,
> 
> On Mon, Jul 21, 2025 at 03:08:48PM +1000, Ard Biesheuvel wrote:
>> On Sun, 20 Jul 2025 at 22:38, Mike Rapoport <rppt@kernel.org> wrote:
>>>
>> ...
>>>
>>>> w/o this patch
>>>> [root@localhost ~]# lsmem --output-all
>>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
>>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
>>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
>>>>
>>>> w/ this patch
>>>> [root@localhost ~]# lsmem --output-all
>>>> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
>>>> 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
>>>> 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
>>>
>>> As I see the problem, you have a problematic firmware that fails to report
>>> memory as mirrored because it reserved for firmware own use. This causes
>>> for non-mirrored memory to appear before mirrored memory. And this breaks
>>> an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
>>> always has lower addresses than non-mirrored memory and you end up wiht
>>> having all the memory in movable zone.
>>>
>>
>> That assumption seems highly problematic to me on non-x86
>> architectures: why should mirrored (or 'more reliable' in EFI speak)
>> memory always appear before ordinary memory in the physical memory
>> map?
> 
> It's not really x86, although historically it probably comes from there.
> ZONE_NORMAL is always before ZONE_MOVABLE, so in order to have ZONE_NORMAL
> with mirrored (more reliable) memory, the mirrored memory should be before
> non-mirrored.
>  
>>> So to workaround this firmware issue you propose a hack that would skip
>>> NOMAP regions while calculating zone_movable_pfn because your particular
>>> firmware reports the reserved mirrored memory as NOMAP.
>>>
>>
>> NOMAP is a Linux construct - the particular firmware reports a
>> 'reserved' memory region, but other more widely used memory types such
>> as EfiRuntimeServicesCode or *Data would result in an omitted region
>> as well, and can appear anywhere in the physical memory map. There is
>> no requirement for the firmware to do anything here wrt the
>> MORE_RELIABLE attribute even though such regions may be carved out of
>> a block of memory that is reported as such to the OS.
>>
>> So I agree with Wupeng Ma that there is an issue here: reporting it as
>> mirrored even though it is reserved should not be needed to prevent
>> the kernel from mishandling it.
> 
> But a check for NOMAP won't actually fix it in the general case, especially
> if it can appear anywhere in the physical memory map. E.g. if there's an MR
> region followed by two reserved regions and one of these regions is not
> NOMAP and then MR region again, ZONE_NORMAL will only include the first MR
> region.

What kind of memory is reserved and is not nomap.

> 
> We may want to consider scanning the entire memblock.memory to find all
> mirrored regions in a and than make a decision where to cut ZONE_NORMAL
> based on that.

AFICT, mirrored memory should always locate at the top of numa memory
region due the linux's zone management. there maybe no good decision
based on memblock.memory rather that use the the first non-mirror
usable memory pfn to cut.

> 


