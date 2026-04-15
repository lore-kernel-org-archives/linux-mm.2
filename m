Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45717F41984
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0706B0092; Wed, 15 Apr 2026 05:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCFF6B0093; Wed, 15 Apr 2026 05:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6A36B0095; Wed, 15 Apr 2026 05:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8806B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:41:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97AF6140384
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:41:28 +0000 (UTC)
X-FDA: 84660297456.13.A773C73
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89617C0010
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:41:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MHEc3dZe;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776246087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jh//D4vksZoAA6xh7LCf64lJtL6THr5KcZUnckQfI34=;
	b=UEPhyLvPZmcAdWZwFilY+EnA9O1vDH7638aJtoYrhub4qsafNrmPqt92obfk/bWMzagKb3
	f+E3g9En9AuMoS+N3jRej/EfR18S+MK5O36btwvJgCX72Ck536AZth4LXPHYJPk7W4372u
	9sFnw7EGwNGse7X/NSs5bWwYZ8HcqYE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776246087; a=rsa-sha256;
	cv=none;
	b=yCGxwZGCmpjO1fuaty85HBu/rYl3FGotA3tZZNKaP1oR03ZQuYAIWskiJpQ4mkRP/11ZHr
	5/yFeiff1+FT744mXyI9xbp6dAuuRNBowFPTYjD1zDe6TukjKYLUaBjAkLCWcIVjtNxaMW
	cSDNTurcLkCy/fPCBKT/+oGgI8Lxss4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MHEc3dZe;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776246082; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Jh//D4vksZoAA6xh7LCf64lJtL6THr5KcZUnckQfI34=;
	b=MHEc3dZeJy9Fh3Mu5+HAG1OXJC51KyGjzKYZ15hJ6RFyXhYGDJvFna6hmvKfdd8CV8e9zkN5yLt8Nr8rLpdQVTZWPxh1TmxEAnKwmA27HOdB4/1bvqBYDvyK7cMLQwV28oAI6yO4z2ObSZHkbzp16x/sbvfzeI/1lakq/3L9odY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X14EjGc_1776246080;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X14EjGc_1776246080 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 17:41:21 +0800
Message-ID: <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
Date: Wed, 15 Apr 2026 17:41:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: rfbnsjr4puu9nf63kq9ukgo49dgbum7g
X-Rspamd-Queue-Id: 89617C0010
X-Rspam-User: 
X-HE-Tag: 1776246085-663513
X-HE-Meta: U2FsdGVkX1/PJuXcZO6U5fqHnrQpqStkMApJ3eTX23WH5QIooGzauCf4Eyaa7tYpOxrBgVm1BlB4DcrauNcw/v3LcuWXabFVjTKfduvodzGgRqRXvSy4YpAhsqZE3rYLgbVkZV/ZnitFzaRDC9l9tPguESt2UDSxrR3ECd+Ro+qamliz+KpAMjULZiMctKMBPanteuE9jRUt/wyHrtcmEpoEOz29jGcSELEvC0XyfA+skfI3WdK+skvcPl+UW56bK3cowCXFnvuoPatV/gLTcjqmacn9gH2ZTTy9H+39Q2zgSdxhgJa6EgQyXkLfiwaIvxgQ3YQSghJbL3GDLcI0pJ83XrFNCWMp+ewu09Hct+4xFxjqvPPGZaBiyW8shCjwsAEPbS2NqFkXjXAYTTgQWGxN0qw7mLQ56I1wmBmXGYSnrvn03j0mLu2QWPdywWXRSsQSiLIQi7DPgDoYBaL6l6UYGDuG/Ihz9bPrYi7esCGeyIiG1Pm089LeZNuJzobSkF9irxu6MvnqPy3upeB0h4ITehJbOuHdFJxpOgJg/QLKxfU/e5FBTeiqVuYmUGUnabFV+V0Zif3atinE8mX474CqxOIew3wLLK+KntVYLULCGw6xcQaoFtX1aYCUwn8gK3FCpsbQTJfRtppBOfi3X8eKWPuq1PC+jZpb9mlcljHnG5+lyzmLBLtlWh27q+P5y/R8zzYudvK/DpoaxNpeTIvFF83n9thq8sIogEjjHkdClwGomTLlKHKP/u2AtJWtsdKCF1EWXn2cS5tfP7+qPgeWBHAOFX0j03oOea3uyR3Qbl9qqZSXT37HMf32XhPtKl3CmAdhyTkxMLDnzN8J4PzT2rhwRz0fmFPDzooAYZzKD6kNLHN5HgA/MH5h2FwvaTcOgJcupjNVt6DW8N/5J08FH/cB3NXFNRLjvTdxfCkVjLcAAw/hURD8mxTGO1N7YBpbhGZj737O7LxrC+A
 j4M7sbMs
 hN4+kDilChYMrdpvbLtI+RsRKPwZfG00lILmALyiLSRpoMTtSL6vNoNE040Ii0rHby9GEwjM2lTsNz4+GY8m4pKZWgp6jcmeP8JY/ydezSSAMD0lsSeIH+xMbkaseUtqJB3wCGeYxqQyaVSsVCbJ2wG1+fyyHtIEv8XminMmYFodrqZnvbl4Udey3DDQ74w6AWVLZkoFPXb182iXrbPJYmtRQv7Jtms+NIDNdqhZMscWipjTFvCuGgeDWRCCokcds0qplAqI/8AAxZy2DnSCAzuuAUqaL0Qm7M7T7VbHcUyjiY/E9vp3vKHre4ef4jCRkZdnTkL88qDPmCknlCy+szk5mNQv3CLe6YJsk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/26 5:19 PM, David Hildenbrand (Arm) wrote:
> On 4/15/26 11:04, Baolin Wang wrote:
>>
>>
>> On 4/15/26 4:47 PM, David Hildenbrand (Arm) wrote:
>>> On 4/15/26 10:22, Baolin Wang wrote:
>>>> Anonymous shmem large order allocations are dynamically controlled
>>>> via the
>>>> global THP sysfs knob (/sys/kernel/mm/transparent_hugepage/
>>>> shmem_enabled)
>>>> and the per-size mTHP knobs (/sys/kernel/mm/transparent_hugepage/
>>>> hugepages-<size>kB/shmem_enabled).
>>>>
>>>> Therefore, anonymous shmem uses shmem_allowable_huge_orders() to check
>>>> which large orders are allowed, rather than relying on
>>>> mapping_max_folio_order().
>>>> Moreover, mapping_max_folio_order() is intended to control large order
>>>> allocations only for tmpfs mounts. Clarify this by not setting a
>>>> large-order
>>>> range for internal shmem mount (e.g. anonymous shmem), to avoid
>>>> confusion,
>>>> as discussed in the previous thread[1].
>>>>
>>>> [1] https://lore.kernel.org/all/
>>>> ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>> Changes from v1:
>>>>    - Update the comments and commit message, per Lance.
>>>> ---
>>>>    mm/shmem.c | 12 ++++++++++--
>>>>    1 file changed, 10 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index 4ecefe02881d..568e1baee90d 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -3088,8 +3088,16 @@ static struct inode *__shmem_get_inode(struct
>>>> mnt_idmap *idmap,
>>>>        if (sbinfo->noswap)
>>>>            mapping_set_unevictable(inode->i_mapping);
>>>>    -    /* Don't consider 'deny' for emergencies and 'force' for
>>>> testing */
>>>> -    if (sbinfo->huge)
>>>> +    /*
>>>> +     * Only set the large order range for tmpfs mounts. The large order
>>>> +     * selection for the internal shmem mount is configured dynamically
>>>> +     * via the 'shmem_enabled' interfaces, so there is no need to set a
>>>> +     * large order range for the internal shmem mount's mapping.
>>>> +     *
>>>> +     * Note: Don't consider 'deny' for emergencies and 'force' for
>>>> +     * testing.
>>>> +     */
>>>> +    if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
>>>>            mapping_set_large_folios(inode->i_mapping);
>>>
>>> I don't like that special casing. In an ideal world, any mapping that
>>> supports large folios would indicate that.
>>>
>>> Now, which large folios to allocate is a different question.
>>>
>>> What's the problem with indicating for all shmem mappings that support
>>> large folios that support, but handling *which* folio sizes to allocate
>>> elsewhere?
>>
>> Thanks for taking a look.
> 
> Sorry for the late feedback.

No worries:)

> 
>>
>> As I mentioned, the original logic has several issues for anonymous shmem:
>>
>> 1. Whether anonymous shmem supports large folios can be dynamically
>> configured via sysfs interfaces, so mapping_set_large_folios() set
>> during initialization cannot accurately reflect whether anonymous shmem
>> actually supports large folios.
> 
> Well, the mapping does support large folios, just the folio allocations
> are currently disable.
> 
> It feels cleaner to say "there might be large folios in this mapping"
> than saying "there are no large folios in the mapping as the mapping
> does not support it", no?

Yes, that makes sense.

However, it’s also possible that the mapping does not support large 
folios, yet anonymous shmem can still allocate large folios via the 
sysfs interfaces. That doesn't make sense, right?


>> 2. Calling mapping_set_large_folios() here by default makes anonymous
>> shmem support 'MAX_PAGECACHE_ORDER' by default. However, the range of
>> large orders supported by anonymous shmem is also dynamically
>> configurable via sysfs interfaces, which could cause more confusion.
> 
> Fair enough. The mapping supports it, we just don't want to allocate
> some orders (right now).

OK. Make sense.

>> 3. Currently, no users will call mapping_large_folio_support() related
>> functions to determine whether large folios are supported for anonymous
>> shmem.
> 
> Right, we special-case shmem all over the place :) For example, in
> khugepaged. I wonder if that could help with Zi's changes to get rid of
> some shmem checks.

Sure. I'm also reviewing Zi's series.

> What if we say:
> 
> shmem that *will never have*/*does never allow* large folios never sets
> mapping_set_large_folios().
> 
> shmem that *might* have large folios (in the past, now, or in the
> future) sets mapping_set_large_folios().

For the current anonymous shmem (tmpfs is already clear, no questions), 
I don’t think there will be any "will never have/does never allow" 
cases, because it can be changed dynamically via the sysfs interfaces.

If we still want that logic, then for anonymous shmem we can treat it as 
always "might have large folios".

>> Therefore, rather than having anonymous shmem call
>> mapping_set_large_folios() and introduce so much confusion, I'd prefer
>> to exclude anonymous shmem from calling mapping_set_large_folios().
> 
> I think it's more confusing to end up with large folios in a mapping
> that claims to not support large folios?

As for 1, it still doesn’t make sense to me.

