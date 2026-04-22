Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9589F94CCF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 06:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B196B0088; Wed, 22 Apr 2026 02:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015396B008A; Wed, 22 Apr 2026 02:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46BA6B008C; Wed, 22 Apr 2026 02:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D35BC6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:28:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 801FA141069
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:28:39 +0000 (UTC)
X-FDA: 84685213158.26.444397F
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf04.hostedemail.com (Postfix) with ESMTP id D187E40008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:28:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yH7B5D5n;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776839317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyGv40nPvSpN36+krGHiG2gXh1QyZtRuvIHyoCemdlc=;
	b=SIjdvKdd4rxCvds38VHahBkTfzrBBY22+VwETfWTwkfVuWsWMyCuIMSLJTGWwVQi2ohcS/
	mRgAsLwI7+IRBQf0686YsSWtWT9xf2yeF/AZTzgZLEPUJglu1oZXnopyfcQur3aww1kBuW
	LrncWscLKmvVMnzFuu0bbOYUfxPCzTE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776839317; a=rsa-sha256;
	cv=none;
	b=HE9XQnhWqfFZEZi8kHkrnL76gygG5aOCIH8rBhODlNvQutwLKXiakbDbkWgzTfi0FZDPzC
	ybx1N+XgwCLinPRyF+s/I7mywZ4J2D3nDV4sXIkfiHEQrOwCVYyZHOclu3bXXSi1nKxPJS
	su/6dB472YR1sagNESjV7w92xTKJYls=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yH7B5D5n;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776839311; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wyGv40nPvSpN36+krGHiG2gXh1QyZtRuvIHyoCemdlc=;
	b=yH7B5D5nkzfWfEYD+VQFo41KGF8c5k71X8an9kT3EO4PWu1r+aZkGFY0jFalSXBYMxIrYIF0EM7MoMc7lQosSfYqNYcqbFxEPcu3gzal+mQ2Bvy4Gsy0fGQrFmCKzj2WkXYdHIGujox2v2IHxTEz/HEUIA48cEXWYCtvf/V+my0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X1VDMR9_1776839309;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1VDMR9_1776839309 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Apr 2026 14:28:30 +0800
Message-ID: <116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com>
Date: Wed, 22 Apr 2026 14:28:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kefeng Wang <wangkefeng.wang@huawei.com>
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
 <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
 <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
 <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
 <dee02e5b-653e-451b-8f59-7196bdae8f88@linux.alibaba.com>
 <07e26d39-6155-4661-b3df-c2419535ed43@kernel.org>
 <f9508e75-789e-4eb8-b09e-b66a8676a6b0@linux.alibaba.com>
 <bea6080a-850c-4b3f-bcc0-719efc372e72@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <bea6080a-850c-4b3f-bcc0-719efc372e72@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x8humaij4p9sotrqfhrwkimbxs53t5pi
X-Rspam-User: 
X-Rspamd-Queue-Id: D187E40008
X-Rspamd-Server: rspam05
X-HE-Tag: 1776839315-78926
X-HE-Meta: U2FsdGVkX18igFYUO+r89rpAK7X6X1klR9hQ1VHW4IX1jsU1ktj2c2rqeUedjNm2bXns++PxL/PdjJXZPW5yDeqCkCzebr3C7xozhOyDfGVXNyAEmkqFNJeiazqZ2YEkVS1oZSWu7cGtjdYOaZ+kDLc6qkBUg1taXiOV+KHTfTYun9g1MOncTVm1XbWSzh4A0AftgBICwVO6cSveIOB8nLIeM4KCIr1nY5UzAEGAz9GLvb9lAeFNll5vJTwn4bwGHh5CvFOUvskioGDM4IVSfbl3qNN5eiZDr9KsP48xwEqVrPjnFwktkMKvzDVrnk8aiGkUeUKruoZrFoByS5NIa73cvKO/pKH5JqXdgbAfs4929nifhV1z5OI1tv1Ll88wHIsrCTWtzc0uSbQjaz86Tp8TpLMZxVo2eClVpojJazUwum8c89embPJoshid3RZAYb7tFiuKIqde8GoKEZvwuaTL2GM7Azxk0wvDwoFf/pfJ6thXL6ku1pHKs07dRQzwgSxULa18yP8Vsv931WvybeRUgVIEA5jKfiytqkyF5hfHSqWYicf3H6YbSBqXYVTzVf0tBPD7Wc3dSj0qsqDo5Y5bh8dcPYpmK0VaQlP70Tt3haumwhpKHB+LttwJjfGSbEpH7yIjT7ShIdo7h/hdZE/U6g+KKnFVmxG+/l9vJDlUXcGj/6ESwJVdRQQ2EUDlXP0FO6tHt7Wqfz6wWY/APKszfe9bAMpig8nHxm8wQb5cCJMfI/XS7uOw/jnp6gjj/MZ0BB+zUuuGZTC+K40Cel2Z8FTd9wj9Cc8PxARUVV7kPeT2WhG+siRlrjEXEodcaz4Xpa4PzYrPiEoNRx2dBVQ8C5Pr4Jbb+U8CRZclluinBfHQSDU1epj2NJlwVOGImr48B72RVTavgLL/K03g/1m4WsLLlE3ttW5XtoMSXYKWPtA6+oNK/EOppfwCPzbKcqE++iyVIPfOE/PKOrI
 SOnySwpV
 +YAtqp3Yby/JqIS0NGMgXFkXW8bfNdONgK/H/VJE0P1OLALo+vvfdJyeOEvU+i22cVZlHLSa2C5UnznyyVbGDMDoxkBJvHAc6vwkxSnLKmLbm1qeSPN9KgbpJlbfF7mT482iU0rBA4rPetppksblZ0yzt4SkKtDZMN49S3uuZZFWtRya1rydx/sAdeSQEeml1Atatv5H7Mxs4nAlqWrccUKppWqEwdXe7OAJWos8sirsfB+uEN81bj3tOD0s9qLjuKGyyJBN49aMApT9cTCkADgfZMxzg9uJXE3bwSo4r5qQnc4ybGdPsWcetfw3YPMuU9vzp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC Kefeng,

On 4/21/26 9:39 PM, David Hildenbrand (Arm) wrote:
> On 4/21/26 08:27, Baolin Wang wrote:
>>
>>
>> On 4/21/26 3:00 AM, David Hildenbrand (Arm) wrote:
>>> On 4/17/26 14:45, Baolin Wang wrote:
>>>>
>>>>
>>>>
>>>> Indeed. Good point.
>>>>
>>>>
>>>> Not really. There could be files created before remount whose mappings
>>>> don't support large folios (with 'huge=never' option), while files
>>>> created after remount will have mappings that support large folios (if
>>>> remounted with 'huge=always' option).
>>>>
>>>> It looks like the previous commit 5a90c155defa was also problematic. The
>>>> huge mount option has introduced a lot of tricky issues:(
>>>>
>>>> Now I think Zi's previous suggestion should be able to clean up this
>>>> mess? That is, calling mapping_set_large_folios() unconditionally for
>>>> all shmem mounts, and revisiting Kefeng's first version to fix the
>>>> performance issue.
>>>
>>> Okay, so you'll send a patch to just set mapping_set_large_folios()
>>> unconditionally?
>>
>> I'm still hesitating on this. If we set mapping_set_large_folios()
>> unconditionally, we need to re-fix the performance regression that was
>> addressed by commit 5a90c155defa.
> 
> Just so I can follow: where is the test for large folios that we would
> unlock large folios and cause a regression?

I spent some time investigating the performance regression that was 
addressed by commit 5a90c155defa ("tmpfs: don't enable large folios if 
not supported"). From my testing, I found that the performance issue no 
longer exists on upstream:

mount tmpfs -t tmpfs -o size=50G /mnt/tmpfs

Base:
dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)

Base + revert 5a90c155defa:
dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)

The data is basically consistent with minor fluctuation noise.

Later, I continued investigating and found that commit 665575cff098b 
("filemap: move prefaulting out of hot write path") fixed the write 
operation performance.

Base + revert 665575cff098b + revert 5a90c155defa:
dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.0 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (2.9 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (2.6 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (2.6 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (2.5 GB/s)
dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (2.5 GB/s)

We can see that after reverting commit 665575cff098b, there is a 
noticeable drop in write performance for tmpfs files.

So my conclusion is that we can now safely revert commit 5a90c155defa to 
set mapping_set_large_folios() for all shmem mounts unconditionally.

Kefeng, please correct me if I missed anything.

