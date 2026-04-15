Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95681F531FC
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4246B0092; Wed, 15 Apr 2026 05:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075AD6B0093; Wed, 15 Apr 2026 05:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC756B0095; Wed, 15 Apr 2026 05:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D845F6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:19:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8494B1A0556
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:19:33 +0000 (UTC)
X-FDA: 84660242226.24.4F6E0C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AAC4340002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:19:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+v3+tLt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776244771; a=rsa-sha256;
	cv=none;
	b=xdMGKXpJFpTmMqrxW27ovfuY0n2X45Wxq7GBEuLJ2aYhOCVfCk/dXaATzelVsTd6wvjM81
	MVzBcENCAoLN27iKvVNsA1o09BtmNym+72RgQtkZhMR90NygDnMvwoOuUgL60Q0wFxeMG8
	27nJPiCztZlpjj2mMb6G9r6IhLpLCEQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+v3+tLt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776244771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvnBDhZuNVTPUxvTueyamJDCXariN7PtjiykgrLiaeI=;
	b=T35G9BibNTaRnp/M5SmgY/YEtODgqqKX/OzJMnoClLX/3DWXj1e5I6a6KBbam8iKCFDExF
	MSYTMp1uBmXzb3Xyt+H/T+/AsfWyhmIvtZEg7nYoxs+A6Rg9wLMGIkG28D1LVSfLxKgLyM
	/LpYWoQK3rkW12Dqt1gJS6jxu9BYLoA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 917FD43D28;
	Wed, 15 Apr 2026 09:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F056C19424;
	Wed, 15 Apr 2026 09:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776244770;
	bh=eaf+9FTrGC1GlHBQ3TAOThZ6ZntCyAP34JFUFoiKhqY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V+v3+tLtTVLZKScGwljiuIEdJTkcUe2WhuO44pI/o7E25LseReeSyyweh0cMiA8T0
	 hYleZAAQhOwGGjYdZ9+tOiiu6P+boYSxTYMVDwfsSaNjEJ77MGiaMtOfvQielHjtyK
	 0GqbVzO/btrEji6Xz2rKMX9yw3QJzJ/+VBlKAtlY3Q0HPwPEhkXDrbh3sw3kEeDzyL
	 pT6et/U7vNF+cs6kgwh1VZdhwdqJc4c7jvO3umsr2GSlFeZEPjPsWKbtDmWViPmTmc
	 4q3fhvXW/l3c9iGgM+uZ5a3DNEWgpiEqMGOb36k3hEJJllbqaZJ1bux7mvWBsvBAsk
	 KX/hriAhmxL4A==
Message-ID: <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
Date: Wed, 15 Apr 2026 11:19:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAC4340002
X-Stat-Signature: cum7xppgqi7dum6n6dkzwtepd77ws19u
X-HE-Tag: 1776244771-153018
X-HE-Meta: U2FsdGVkX18dYD5Az31oA1MpP7O0uXPByNwmrm+pEpzD/UQDWjzPCfc85yoa5nBJItcvKNSI03EDJ6Wsx+Eboy2zCc8/KkZilPRAy54qTVV6s3u8cnFddYOlAd+o7bzg9AYphXyzZhD7HOOy4WxFHAZUUG0RFMUi3AvR+RNRy8JT6v/kpm6PB0StJgQJZIkW1VPin+IGSBo98Nd7Bkoig1pzhI/G1ttTVAPFfvuUG5YUu4nYcF5JmTAWK/wgbdmnXW2Yeh7yTXuSZP8PN7AbqozXUNhtMNFGWlUUDSiBV2FwPBjutS8ILMWwbz12or3Rx4x19EeHSt20g/MjoTJ4BEPFAl43v4W3UZh4OkyaXEESdUcH5jkLurkfFh71b6Sjhu2iGVeOGPNRtSvcUTUyV4VF2VM/IbOG898esdv8gL8aw4xs683PTypVLUj8R0vlaKNXtoZWnHaKbgsLntqSi88BHy1yp+m1hamsjezm1smGp1Uw3WtW9x1MzINVN7osqgMpRlED5qbZe7CxoxopeZhvxxTlvkSaZat6f2mNODYZ8rL7cANNINHrT0j72kAlGbxy1Dsq6u8pPo9ZPWWgM5zf+WMFkJ01T1BZbPXE7XFPu1UxdT25nVZSJkZfYjPM7o1QviTR0xjO19Za+XOEtUogSOqrmE3jxh4TQBSlZb+cKhcLzpqKqe4Gev22G0UXVcOpUx2IJBmxuEPtz/z8lIO7qk5WC8Jj6gGscNfYNrXRwoxH1mUNG48P7Hx4Pw7ydWJgRcHuDS/IJ7UzP1aonFpj+fgqvY1gYXckg6TT+1a/TXltjuwJU1BGgsqTtfeJFC6SsYBu9Up8S/RWfpfXF2G3nNwsMkLODfvUerDLVb6vh+dPttywOawTGU9kj3anVCmggHbWpH65g23hOAgaSGdbs5BJ/WyWTwqDB/qkMRGTuaIm2rMhF4+9SG9/KpD+pzj48jd0JL84ViFy/nA
 yGWytmqB
 k5+mFwxMJWnDIgb5+rrolHC3GLpCR2YqMdt2c2t/J0TJhoCeCUDSb/VELRATd+spLb2I0jYNe2LqwGCpQ2F2LzGywJzVHAQixY2MZ2UquyOLpr1+8X5UxE9gj5zzAdzX5A/GN0XJIW+qJj8lUpBqukmWWvOQ8FvgVq/e4aid3LnKMV+efzGBOTSUe84QhIPY450EsrnaQuzJamAlRb2YuD94QIzY/7HnDF9GW9jzdrVnAaCu6iUmE3tVlQOuQh05vjLt3oLu1xTeGZC+5Dq/ar//09yMzHds27oAVqmc6j6koqnEUp1kCp2yUBEQ4bSZRspMyHcvt/0T8y/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 11:04, Baolin Wang wrote:
> 
> 
> On 4/15/26 4:47 PM, David Hildenbrand (Arm) wrote:
>> On 4/15/26 10:22, Baolin Wang wrote:
>>> Anonymous shmem large order allocations are dynamically controlled
>>> via the
>>> global THP sysfs knob (/sys/kernel/mm/transparent_hugepage/
>>> shmem_enabled)
>>> and the per-size mTHP knobs (/sys/kernel/mm/transparent_hugepage/
>>> hugepages-<size>kB/shmem_enabled).
>>>
>>> Therefore, anonymous shmem uses shmem_allowable_huge_orders() to check
>>> which large orders are allowed, rather than relying on
>>> mapping_max_folio_order().
>>> Moreover, mapping_max_folio_order() is intended to control large order
>>> allocations only for tmpfs mounts. Clarify this by not setting a
>>> large-order
>>> range for internal shmem mount (e.g. anonymous shmem), to avoid
>>> confusion,
>>> as discussed in the previous thread[1].
>>>
>>> [1] https://lore.kernel.org/all/
>>> ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>> Changes from v1:
>>>   - Update the comments and commit message, per Lance.
>>> ---
>>>   mm/shmem.c | 12 ++++++++++--
>>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 4ecefe02881d..568e1baee90d 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -3088,8 +3088,16 @@ static struct inode *__shmem_get_inode(struct
>>> mnt_idmap *idmap,
>>>       if (sbinfo->noswap)
>>>           mapping_set_unevictable(inode->i_mapping);
>>>   -    /* Don't consider 'deny' for emergencies and 'force' for
>>> testing */
>>> -    if (sbinfo->huge)
>>> +    /*
>>> +     * Only set the large order range for tmpfs mounts. The large order
>>> +     * selection for the internal shmem mount is configured dynamically
>>> +     * via the 'shmem_enabled' interfaces, so there is no need to set a
>>> +     * large order range for the internal shmem mount's mapping.
>>> +     *
>>> +     * Note: Don't consider 'deny' for emergencies and 'force' for
>>> +     * testing.
>>> +     */
>>> +    if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
>>>           mapping_set_large_folios(inode->i_mapping);
>>
>> I don't like that special casing. In an ideal world, any mapping that
>> supports large folios would indicate that.
>>
>> Now, which large folios to allocate is a different question.
>>
>> What's the problem with indicating for all shmem mappings that support
>> large folios that support, but handling *which* folio sizes to allocate
>> elsewhere?
> 
> Thanks for taking a look.

Sorry for the late feedback.

> 
> As I mentioned, the original logic has several issues for anonymous shmem:
> 
> 1. Whether anonymous shmem supports large folios can be dynamically
> configured via sysfs interfaces, so mapping_set_large_folios() set
> during initialization cannot accurately reflect whether anonymous shmem
> actually supports large folios.

Well, the mapping does support large folios, just the folio allocations
are currently disable.

It feels cleaner to say "there might be large folios in this mapping"
than saying "there are no large folios in the mapping as the mapping
does not support it", no?

> 
> 2. Calling mapping_set_large_folios() here by default makes anonymous
> shmem support 'MAX_PAGECACHE_ORDER' by default. However, the range of
> large orders supported by anonymous shmem is also dynamically
> configurable via sysfs interfaces, which could cause more confusion.

Fair enough. The mapping supports it, we just don't want to allocate
some orders (right now).

> 
> 3. Currently, no users will call mapping_large_folio_support() related
> functions to determine whether large folios are supported for anonymous
> shmem.

Right, we special-case shmem all over the place :) For example, in
khugepaged. I wonder if that could help with Zi's changes to get rid of
some shmem checks.

What if we say:

shmem that *will never have*/*does never allow* large folios never sets
mapping_set_large_folios().

shmem that *might* have large folios (in the past, now, or in the
future) sets mapping_set_large_folios().

> 
> Therefore, rather than having anonymous shmem call
> mapping_set_large_folios() and introduce so much confusion, I'd prefer
> to exclude anonymous shmem from calling mapping_set_large_folios().

I think it's more confusing to end up with large folios in a mapping
that claims to not support large folios?

-- 
Cheers,

David

