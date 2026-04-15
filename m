Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 116B7F43824
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 14:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582E36B0089; Wed, 15 Apr 2026 10:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533D66B008C; Wed, 15 Apr 2026 10:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422F76B0092; Wed, 15 Apr 2026 10:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 303626B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:36:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCD5613AF79
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:36:57 +0000 (UTC)
X-FDA: 84661042074.12.D38E410
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 00AC114000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:36:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ajc0ZCrp;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776263816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R41xfSaGuu9/unRTK6Co4hDrkXjvHiWt3X2jqtUtbVM=;
	b=5WDni4mD+STKGImBwFpPCql2F+DxokIolsSOnQjKSN1sky1w5OY4Rp1ILxiWZ3DzDwsVbe
	7nnZYt9THlCfOISRCn9I6N4wT7LVnWEqG/YfnYy1uFiwvJkFVyCVNzjhp9Yfi/CutWAbai
	l/9dzxvXzfUp6epzuYxFwP1rpI7L/hk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ajc0ZCrp;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776263816; a=rsa-sha256;
	cv=none;
	b=CgUq+SQIx+lTzbSCSH3Ux0E152mX7xeKWoiNHzdBJyCp5Yej289F8qn1XHjPCrrcX7r1wX
	U+vIOzUbZHL+TpTXuH/n3fuEJbV8M9BIXOEsevWtuaQ+7ihrwVLW3H/uvE+YfTbeBZ1ORS
	tdHtP2Pj2ETzikBynTJtzDSKBNPi0v8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D86DF600AD;
	Wed, 15 Apr 2026 14:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143D8C19424;
	Wed, 15 Apr 2026 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263814;
	bh=hha2hAkeavqEK37XCQsy4N+tg4I2zcpdNgvkEtX+Ka0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ajc0ZCrp48qFOd5YeMwU6awPpTlPgOEdgiCW6t9HWpyQfnzlwVgfg/AsqhiG7oyXm
	 nLr+XUl4e20NWvAyngeSQ/T3A9cPeh/iLU2MRydo/sXPwUCq5tStnSMWlbWdk4nxe2
	 SJC4gavTW9vPFR/OyBPrPy5s+tZ95aIdgN9CMgH8/WkWaJKy/rl5orib3fJXfcnm3N
	 jodgITL9XOiwf+y6glhCkD9qRLxtg1dsbYBzawQcSNn1jKjWe63AYk3tLP1Kn1QIh6
	 B0XR3httHFjAONX3ZES54kIkzsRSYch53zvV0eJKuxBxnzUiQd02TbR5wDRafb3c9L
	 +LlLcE2o2QiwA==
Message-ID: <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
Date: Wed, 15 Apr 2026 16:36:46 +0200
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
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 00AC114000E
X-Rspam-User: 
X-Stat-Signature: 3f4zei6fncimigog11prtym7ysxradf3
X-Rspamd-Server: rspam10
X-HE-Tag: 1776263815-792275
X-HE-Meta: U2FsdGVkX18r081PDt96G53Hn8xnseAJ2BdYzWOTdsnfaZ2xO4OgV54F9AHvarQDV0IcHGVhO5eAVEgi1wizn1Ewcn5MDhme6dCgKTBKNvDtz3uCBn1lxJucZ12Dc80cwST+mo7ItLeMe6AQr3hsW57rLvxDQNkdboNdc+46qF6VQxvpfOTXEC9Oyh0M5Tr8lDWp5ZLsZ8mAp8gi7Nc0cJxlGXrlE6vfvMtQEjd2JM/afiLw67FHOfAow+GatUGpBB1k85GHD8lh17EJ3E5fHb3RZN8VAy5Gxt7ITxY518CehWg7RyVS4uLatkBUHjv2BN4O8A7n+s9krctAqwNGEOrbQVWWrAosusYtIs32yvc/FZ+lzYuVOFciIJmkv1J3wdjweP1p0lTxZ19Jf6fbseuzzwgXPVB43ETgwamQXcNpaSewcQoH/dX2DG+bi1MN6vTu0FnUJYcGp9nBMRN/Il2HvN4j43qiUBr/MfGi10PZpi9ToplzRIA3hAvhafncdUBKcitTchGWs6i0UvpRP+4ZeLIlz5olnlVFj8JNGK/R9zHM5cjMa3SCpLy2l1Xnan3HMPeWJpZ/5nt8KbqQIFlW/rYVIvMZEOSP73vjJPCfWf1ahNDJg3okF6Ov6RpvQkzTCKpHOBbMPQIaWRlWrBJj2H97ZL0hymLKYdceyDokxEI0h4BTe2LQPIaU7fQwY3N78UJf2txFGlvUpI0OzAwMzASKBcpaLbGKccYBW4GwzuJBoV02gcT6OxIxla3XJYZgrGwyz2j2zDga8HfScSmvSktom8i58DeHd5dJkfQiNivRqONlle4nnpBTzxWe7/kUzkxjSQ7GibBMY0IuRdg3rotYZMmQQjkH5IQn9QNZCIO5+1wXfV/4+mZ22FrFWdWn9zQzmDP1DpXr3/aJeJJzkDw7JNluvIJ2Nl8Wk0JQrlSJlyhpO5iCEgWsepGRzuOYw4T9mS1PNPUD3cK
 G9q8Xm7J
 36Plguxv4zjwqrNxPeRq7w0ATkECCm/sF4KNrnhOLaYAniR55sO04SweT1YlnoytLHgco3IS5HuKfrzFYpo/VDxKvy8ahe1ELr0fyeLAw77eJqY6Q03PMrlrluvFj8GyUfgEJP0vMNd+j11EAGeRxKPgWeNin6qISbaiI0gx4Lkj2BM1+C8hTQ3th092SGzY0OkUNGnUzP7ZFfI7YKY0Q8uD0LVaMx+1qH9qteXa1Qh/Qosrd3rTeFJftMqpKgWJdy9uoS+wTtKDt0tKK4svFt15XGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 12:05, Baolin Wang wrote:
> 
> 
> On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>
>>> Yes, that makes sense.
>>>
>>> However, it’s also possible that the mapping does not support large
>>> folios, yet anonymous shmem can still allocate large folios via the
>>> sysfs interfaces. That doesn't make sense, right?
>>
>> That's what I am saying: if there could be large folios in there, then
>> let's tell the world.
>>
>> Getting in a scenario where the mapping claims to not support large
>> folios, but then we have large folios in there is inconsistent, not?
>>
>> [...]
>>
>>>
>>> For the current anonymous shmem (tmpfs is already clear, no questions),
>>> I don’t think there will be any "will never have/does never allow"
>>> cases, because it can be changed dynamically via the sysfs interfaces.
>>
>> Right. It's about non-anon shmem with huge=off.
>>
>>>
>>> If we still want that logic, then for anonymous shmem we can treat it as
>>> always "might have large folios".
> 
> OK. To resolve the confusion about 1, the logic should be changed as
> follows. Does that make sense to you?
> 
> if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>     mapping_set_large_folios(inode->i_mapping);

I think that's better. But has Willy says, maybe we can just
unconditionally set it and have it even simpler.

-- 
Cheers,

David

