Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5837F433D6
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 02:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34DC36B0005; Wed, 15 Apr 2026 22:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FEAD6B0088; Wed, 15 Apr 2026 22:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214956B0089; Wed, 15 Apr 2026 22:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 115456B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:08:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DAF159B86
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:08:33 +0000 (UTC)
X-FDA: 84662784906.05.A443D11
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf22.hostedemail.com (Postfix) with ESMTP id E2840C000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:08:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aQKm9x4s;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776305311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13i5phm2ETqjPnWJPbN6WHGGkRFPThnfNwDtCB2m7B8=;
	b=1zzoJGR+AXDcb3p+Fk0LKctIbOs69BxpkOdXP0na/DaeWHjbjt1ZbmzFvJgZAD8g1zgXjJ
	HdQXmqF60F0MptUEQ3BKMq3No2mYgFrvc6zy7+JA92Ku9PIgqj0lJ/kbX57/IxP3r24wTC
	aD5y3+0oJ5gkDH9YqrvAb0xwCSWoKGY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aQKm9x4s;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776305311; a=rsa-sha256;
	cv=none;
	b=ozP4OqbZhXcj1h/xUQlthFtGKBcSw98BebV+IZ3LhDs9jYUcfxJFuyAhI1QMa1BF+0yUaU
	fLgWZra3NZ5JSf8Q2jO903bRf6Hr+LkH5mwqKBcTk19XbHwNnuigzFzoCyyRONDfYMnBHt
	xTAhmoiyHjCCaOdUoawtMH66OoVSycQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776305305; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=13i5phm2ETqjPnWJPbN6WHGGkRFPThnfNwDtCB2m7B8=;
	b=aQKm9x4snOZg/mth1yFWRqLTY49n4R7cuEa4flff/K7osgvqoPm/wP8/ZdL3DNjl50xqorzk1nwJauMauQ3dDclNtM9tT0gKLSuI38u7nFhIKwqj+diagbbyjKsG6ZRmvdJHYutF0G3FmFphDcJZ+BpQHRrJ98D5LRbG/Og2unc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X16ZudU_1776305304;
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X16ZudU_1776305304 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Apr 2026 10:08:24 +0800
Message-ID: <50a01c86-fbf1-4f93-9557-6e5cc1dd1dd7@linux.alibaba.com>
Date: Thu, 16 Apr 2026 10:08:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, willy@infradead.org,
 akpm@linux-foundation.org, hughd@google.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
 <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
 <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
 <16745f2b-b008-4df1-ac76-f18b4a826dbd@linux.alibaba.com>
 <4AD72E13-C4AE-4ADA-8AB2-DDB3CEE6A527@nvidia.com>
 <907b3a20-52b3-4969-8456-bd3a8d2571f2@linux.alibaba.com>
 <D29FD39A-50FE-4EE5-8D14-A7B40E565074@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <D29FD39A-50FE-4EE5-8D14-A7B40E565074@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dimn4o6ub3inywfppiatakyisaznjkgo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2840C000C
X-HE-Tag: 1776305309-472470
X-HE-Meta: U2FsdGVkX1+X7KQPdI+4qpmpy0Etaui33atAFsmmVHds5+xmO5C7E9Dge7sG2zOte7cNqzBmjPYQN2DRJhm9GUq4Sj2+GojGTUsLLp14fm6cODVJxv5+32nSIQyz8VD8bToknTUzKJW5qHf6sc0wTZVGDPpooTfeUDKSUftY9MDvU/Ul44/6jxgd2BwNdRXYggae4LqtiaGx+vYutNnSnpQuWoZJ6+pT2lHV4M9IncpC8UkIsHhJVnBzoDqiTHtpdEHgoatIYYNKAXKkQh2d1TQSM08sPft04vnFRg8c1bb7wgQ9osIixmqEpDmuRLX21vBBSv648HU5eIDyDVdhlcm9U7GyuFxfo1AoxLg6GpnZEW6UxVgF2W4p7t5iwcL8bobY6niyJqsGFjVtK2/gN1Pad+rWAOQ0ocCXiDX4tiHzV7YRJ7LQWM+uhvz4eDFcgyFUbuMHfWlMWZvUnElKOQhZ2DU0xrYj8axJpgWQD1paDYne4D0vHWP2T+/s/sz3B0INQVRCfYNsltAgpE7yRvQ7V3hfnrhFK4MrO+CVavIdkYCpJx9u5j9aOC3JsjIVgTaLO99Nz9P9ErCWahv78iIFDcElRKMi05UBf7Q7md8Zyj2gShmSItFB8H3Rm77wZoLek2MtM+zBurSnkF7BhGHdMVvwo0/CEDi5ZfIaBuRgdJFt4itgvOvddtoopCltV2nQVdLS13ZZBMaMxm5KN1+/3xeomecq9l+A1iQ4s8gFkq6VG5EZqgmjtw/vMX1l2ruPNgTD1dOXEACffI+XAqhulb2KRDNi9+sL2QYZmvAPoz053rLoOeQjiKHystAjmYP1KUtRfZ1PK1fKy22SMmJC7ABXRy67hp7LBQDODP2/1ejImGqnoMrMgRaj2N3fSrt6FgvX+e1a+sKfn6ar1C4+mGhDGDaUlApCowCQRme54rFgjlZzxKwv15yDW1nGI4rB8gPqI4sS01BHrPO
 7ROGerdp
 U0HvccWYa3QAJqDKSD0aPTDZv+iNOm/bdUj9ChPVQC0HiArIy2nvbRrop0RN2LQdWDGSlUGE3Ms4v6z6a+vPJHv4fchtw2p8nrT78Ay44g4YLVgesyGybVHT05ZM91KTJmojq/PXk/DZ8+sf09e7Ec/wOkbGrW1hfO6mPcQ1aQC7WM0FzfHPGTToziK6EHYwoUFRlVjKSxkm3Wi3wvzNqAXmZj5dtuxBtPRn90ooysNz7ZkE/X5Db3mfRpSGLxsp0Jbc5x8OLecUJa+TTUKx6/80H5cgX/op/r2X2XQtvcGLvDq8evTqB+E+3ooiql4yZ08tlvBNpxpPSVG7ciuyyqlX2SM/yFdZ+gTYcPO3/XIDcfEvD87RgitG9SOhz8M74VLc3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/16/26 9:52 AM, Zi Yan wrote:
> On 15 Apr 2026, at 21:45, Baolin Wang wrote:
> 
>> On 4/16/26 9:36 AM, Zi Yan wrote:
>>> On 15 Apr 2026, at 21:22, Baolin Wang wrote:
>>>
>>>> On 4/16/26 9:11 AM, Zi Yan wrote:
>>>>> On 15 Apr 2026, at 21:05, Baolin Wang wrote:
>>>>>
>>>>>> On 4/15/26 10:36 PM, David Hildenbrand (Arm) wrote:
>>>>>>> On 4/15/26 12:05, Baolin Wang wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>>>>>>>>
>>>>>>>>>> Yes, that makes sense.
>>>>>>>>>>
>>>>>>>>>> However, it’s also possible that the mapping does not support large
>>>>>>>>>> folios, yet anonymous shmem can still allocate large folios via the
>>>>>>>>>> sysfs interfaces. That doesn't make sense, right?
>>>>>>>>>
>>>>>>>>> That's what I am saying: if there could be large folios in there, then
>>>>>>>>> let's tell the world.
>>>>>>>>>
>>>>>>>>> Getting in a scenario where the mapping claims to not support large
>>>>>>>>> folios, but then we have large folios in there is inconsistent, not?
>>>>>>>>>
>>>>>>>>> [...]
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> For the current anonymous shmem (tmpfs is already clear, no questions),
>>>>>>>>>> I don’t think there will be any "will never have/does never allow"
>>>>>>>>>> cases, because it can be changed dynamically via the sysfs interfaces.
>>>>>>>>>
>>>>>>>>> Right. It's about non-anon shmem with huge=off.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> If we still want that logic, then for anonymous shmem we can treat it as
>>>>>>>>>> always "might have large folios".
>>>>>>>>
>>>>>>>> OK. To resolve the confusion about 1, the logic should be changed as
>>>>>>>> follows. Does that make sense to you?
>>>>>>>>
>>>>>>>> if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>>>>>>>         mapping_set_large_folios(inode->i_mapping);
>>>>>>>
>>>>>>> I think that's better.
>>>>>>
>>>>>> Thanks for your valuable input.
>>>>>>
>>>>>> But has Willy says, maybe we can just
>>>>>>> unconditionally set it and have it even simpler.
>>>>>>
>>>>>> However, for tmpfs mounts, we should still respect the 'huge=' mount option. See commit 5a90c155defa ("tmpfs: don't enable large folios if not supported").
>>>>>
>>>>> Is it possible to get sbinfo->huge during tmpfs’s folio allocation time, so that
>>>>> even if all tmpfs has mapping_set_large_folios() but sbinfo->huge can still
>>>>> decide whether huge page will be allocated for a tmpfs?
>>>>
>>>> Yes, of course. However, the issue isn’t whether tmpfs allows allocating large folios.
>>>>
>>>> The problem commit 5a90c155defa tries to fix is that when tmpfs is mounted with the 'huge=never' option, we will not allocate large folios for it. Then when writing tmpfs files, generic_perform_write() will call mapping_max_folio_size() to get the chunk size and ends up with an order-9 size for writing tmpfs files. However, this tmpfs file is populated only with small folios, resulting in a performance regression.
>>>
>>> IIUC, generic_perform_write() needs to use a small chunk if tmpfs denies huge.
>>> It seems that Kefeng did that in the first try[1]. But willy suggested
>>> the current fix.
>>>
>>> I wonder if we should revisit Kefeng’s first version.
>>>
>>> [1] https://lore.kernel.org/all/20240914140613.2334139-1-wangkefeng.wang@huawei.com/
>>
>> Personally, I still prefer the current fix (commit 5a90c155defa). We should honor the tmpfs mount option. If it explicitly says no large folios, we shouldn’t call mapping_set_large_folios(). Isn’t that more consistent with its semantics?
> 
> Filesystems wishing to turn on large folios in the pagecache should call
> ``mapping_set_large_folios`` when initializing the incore inode.
> 
> You mean tmpfs with huge option set is a FS wishing to turn on large
> folios in the pagecache, otherwise it is a FS wishing not to have large folio
> in the pagecache. tmpfs with different options is seen as different FSes.

What I mean is that tmpfs is somewhat different from other filesystems. 
We have tried to make tmpfs behave like other FSes, but differences 
remain. For example, the previous fix to tmpfs’s large folio allocation 
policy, see commit 69e0a3b49003 ("mm: shmem: fix the strategy for the 
tmpfs 'huge=' options").

So the tmpfs specific 'huge=' mount option is another way it differs 
from other filesystems.

