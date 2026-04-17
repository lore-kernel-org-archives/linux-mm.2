Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4918AF43699
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11A16B00F7; Fri, 17 Apr 2026 08:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE98A6B00F9; Fri, 17 Apr 2026 08:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A266C6B00FA; Fri, 17 Apr 2026 08:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2A86B00F7
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:46:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52A941390B3
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:46:00 +0000 (UTC)
X-FDA: 84668020080.30.580F3DB
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5907A20002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:45:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GayrPppv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776429958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ta9DM9SDNRcmSJ5h0e+0G8+56tKcA4LQSKmXx7BeWew=;
	b=BRRX7/wlVdI1+TJVKrwHjJruurGd5DXpn6MpzwEWI1ebJ4xi+qZV0Zjl6I+o5Si2wIxZBs
	FEYnuB40lL3psHVvkUYKpZYjUSqzjXBOALNzHJBTxL2TONtH5CfIKW3tTJDJwFHhenaJfO
	joC6ZHJy/Hfh/ix66GS1cXJQscdWAII=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GayrPppv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776429958; a=rsa-sha256;
	cv=none;
	b=21oPLlGsQ7GdsFIIVw7TGwZZBFyLLmpI3rNihZ3awLKWu4Xwws2P4ICqeM1ZM5uKiGahnY
	JzGnoxnT7UyJktONJO8r1jOipWR9nPwPEPYtEXvo6n+lXT/3UH9qh860aEVjRaoERpQAun
	IYoiBuT60kGtrrTB51d338K7pctRvNg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776429953; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ta9DM9SDNRcmSJ5h0e+0G8+56tKcA4LQSKmXx7BeWew=;
	b=GayrPppvNYlE6+Fg0A/xt/9fXZH27HvqWeyHCJxBCv0umR148hnjPhXyYeWzVifis9tY0GErhcLzU1F7OXAxGPqHWiWUaYMQtlXlHb3kULwF7rAcvEd8e0S56EH5m61RH2xGLoPfVVVAwlWZO/Zx3aQwbz8GSOedWZ23H0g2q9s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X1BNHJL_1776429952;
Received: from 30.32.70.62(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1BNHJL_1776429952 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Apr 2026 20:45:52 +0800
Message-ID: <dee02e5b-653e-451b-8f59-7196bdae8f88@linux.alibaba.com>
Date: Fri, 17 Apr 2026 20:45:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
 <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
 <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
 <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5907A20002
X-Stat-Signature: xcuqxin77hi1mq1wrxuciqjus7qhb7p6
X-HE-Tag: 1776429956-576101
X-HE-Meta: U2FsdGVkX18/nW9O5BU9WQcWqGnGCWM9pAwr4Dv9OlyaV9qyBZrgmKU/w4/dwQ3jg/sxXPD1GGZZ2iR9u2BEwkI5nZ7LEhwCguu3M+ZiY5/dW1Bm5sC9J5tQPeGREWv8N8frKAR25N/ZQXJRda1jXS1GLfhxl7wj4iK3Hj1EOQWsiWGjulOc02tgHEMgPX8PwMBpH+NVoFReaAkELXlc7VHglrRNqg9dhV/NnBXBCZqNdEnxT+BnjGjqWQYxcQISZC0F0GiUvARoM9x7t6tpNIIi/BljYAURY4rk1gEtzWFCtqVjnpAryw5mPapiQ7tIhA3jgxXOnDWU9BVfrO/45/BpS2XaGBJXHunlAH1CYhMqqk3ZdI2A5suRlGefffPgSpkoq87MohXtQ0JDrcvlz9ag/3DZ0FuVBQqmX9zWhkyBvBrCQ0PU1KxsMOfydiH3zEunjDrCXRekhkiqu29jMFSmXkpklWjUdLlr9wnYPd7jLsxDRWdJuAlRtIxP7LNKMqXDe263FjcuSZe0jo8tT+e+uaaMcBKt7bdJ2lms29WjCjRVDnXQkm5IFs0D0wDN3FpBCL3KOWdSqPJy/+bR9TWDrx9zmrCM/39tM7YDkiqaXvsTPmMbuHU1+wdrxFRInBqhVRDrzBYE4J/vn+AIj11kEIfM/2hUR/3G9J3msJlwP2bF5w2mfjEmkPrIyg7qewir2XAkIQpXuVd2hq22aNGIXaBHaMdflSCMgC9sB52fniY6Su4tEMv/dH4HNeROQLfr1Oam1qH1s/ycLt7hjX+IajLKzGKzMmcHcOR6bgDiAlUzREGrTUSmQMavW9KmiV5kmi8wafdAfDl6FaVLv9iI9eXG2GZYC1qx4G5gtxIzyPprK9yD4cez6kPOZGGeqyQ215xC63V8DF76v9pREaRdF6brYUN8Yc8o5bZ3efwyF+f+e/5yk4HoURreenfv1ciW4gsstU3Dc65IsWa
 rfhkJaAF
 mYrQFWNUWZvsN8Jycn384wKvu+SwM6AhnI29nvWotWczZGC4r1kcK3RfWje2TnfIGO2OgGkMelsdeRAOjaYebTvO13tA/Ovpjfdyvuu5zfOvj6Miu8xNJw13FETWprSCV3Sc21NtyWWpQplIw+Gitx2HjtwJHypDhYeUEXebRMKBs2vZ8mSR1GB0Lv2aPKUa4Yo6AR5ZyacNdTIgRcj84mttKUsKyugOpBNwL/M/4jaSleBclKyMcTDdPuTB08jr9VHWhRkriOd+thJ0nAwhOW1wDwIyFeBatLSmdA1ZKutEpEwuvk97ArsKZXHNJyDBHou6NkTGAzO+scXaxLanqohLyr7hvqnyXtdLWTz76kZ+O2kuROzaaMvCpCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/17/26 5:52 PM, David Hildenbrand (Arm) wrote:
> On 4/17/26 11:27, Baolin Wang wrote:
>>
>>
>> On 4/17/26 5:21 PM, David Hildenbrand (Arm) wrote:
>>> On 4/17/26 05:25, Baolin Wang wrote:
>>>> Currently, when shmem mounts are initialized, they only use 'sbinfo-
>>>>> huge' to
>>>> determine whether the shmem mount supports large folios. However, for
>>>> anonymous
>>>> shmem, whether it supports large folios can be dynamically configured
>>>> via sysfs
>>>> interfaces, so setting or not setting mapping_set_large_folios()
>>>> during initialization
>>>> cannot accurately reflect whether anonymous shmem actually supports
>>>> large folios,
>>>> which has already caused some confusion[1].
>>>>
>>>> As discussed with David[2], for anonymous shmem we can treat it as
>>>> always potentially
>>>> having large folios. Therefore, always support large folios for the
>>>> internal shmem
>>>> mount (e.g., anonymous shmem), and which large order allocations are
>>>> allowed can be
>>>> configured dynamically via the 'shmem_enabled' interfaces.
>>>>
>>>> [1] https://lore.kernel.org/all/
>>>> ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>>>> [2] https://lore.kernel.org/
>>>> all/875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org/
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>> Changes from v2:
>>>>    - Always support large folios for internal shmem mount, per David.
>>>> Changes from v1:
>>>>    - Update the comments and commit message, per Lance.
>>>> ---
>>>>    mm/shmem.c | 13 +++++++++++--
>>>>    1 file changed, 11 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index 4ecefe02881d..769ef37b1ea9 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -3088,8 +3088,17 @@ static struct inode *__shmem_get_inode(struct
>>>> mnt_idmap *idmap,
>>>>        if (sbinfo->noswap)
>>>>            mapping_set_unevictable(inode->i_mapping);
>>>>    -    /* Don't consider 'deny' for emergencies and 'force' for
>>>> testing */
>>>> -    if (sbinfo->huge)
>>>> +    /*
>>>> +     * Always support large folios for the internal shmem mount (e.g.,
>>>> +     * anonymous shmem), and which large order allocations are allowed
>>>> +     * can be configured dynamically via the 'shmem_enabled'
>>>> interfaces.
>>>> +     *
>>>> +     * For tmpfs, honour the 'huge=' mount option to determine whether
>>>> +     * large folios are supported.
>>>> +     *
>>>> +     * Note: don't consider 'deny' for emergencies and 'force' for
>>>> testing.
>>>> +     */
>>>> +    if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>>>            mapping_set_large_folios(inode->i_mapping);
>>>
>>> Two questions from a non-fs person about the semantics here:
>>>
>>> a) Can sbinfo->huge be triggered later, for example, through a remount
>>> (staring at shmem_reconfigure())
>>
>> For tmpfs, yes.
> 
> So, we could pass this check here, not setting
> mapping_set_large_folios(), but later someone toggles it and we missed
> to set mapping_set_large_folios()?

Indeed. Good point.

> 
> Or would we always go through another __shmem_get_inode() after a remount?

Not really. There could be files created before remount whose mappings 
don't support large folios (with 'huge=never' option), while files 
created after remount will have mappings that support large folios (if 
remounted with 'huge=always' option).

It looks like the previous commit 5a90c155defa was also problematic. The 
huge mount option has introduced a lot of tricky issues:(

Now I think Zi's previous suggestion should be able to clean up this 
mess? That is, calling mapping_set_large_folios() unconditionally for 
all shmem mounts, and revisiting Kefeng's first version to fix the 
performance issue.

[1] 
https://lore.kernel.org/all/20240914140613.2334139-1-wangkefeng.wang@huawei.com/

