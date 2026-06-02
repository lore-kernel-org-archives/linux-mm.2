Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E05CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8CD6B0088; Tue,  2 Jun 2026 13:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759B66B008A; Tue,  2 Jun 2026 13:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621F56B008C; Tue,  2 Jun 2026 13:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE686B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:33:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF3E71C1029
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:33:38 +0000 (UTC)
X-FDA: 84835669716.26.F079AA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 359F740006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:33:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0eGlr8c;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780421617;
	b=PSTPJpdZsnLZMs0GubLli6QyKqvv9WH7fYUYfqa6CAtPV6VHiSwzd8dDEyi2cgS80F+thg
	pMs3as5Vio8ya7NlLXnmwRkNExCnstiT3zQVJ+7giG1j5nCH5CNwhlTnpaTlbQ7QlIVCBE
	J2G7c/59S/pSi7nL1VjnUKYOzkyK+Uo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0eGlr8c;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780421617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5KkLRZDKHzqzgauZa36DRNu943jxeoDnNjfgu5c58g=;
	b=kaw+l6CMGGZH2K4K0gQff3EknBIG8UEgpEjI4WMZ16kSTi42k4xxTbvMkmoO7j7DLGU6Qp
	lMvRCb0PkLZhNbYafENnpONznJJQLNcNiyuwLPnj+p3gukodOHczsX0V8IkAPY1S8ciwFX
	5SQuZUznNAL6DKW1VKdw574s6th+18Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A35E960123;
	Tue,  2 Jun 2026 17:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420AC1F00898;
	Tue,  2 Jun 2026 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780421616;
	bh=o5KkLRZDKHzqzgauZa36DRNu943jxeoDnNjfgu5c58g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a0eGlr8cNqe5fWtVVRIkjgBEI8yknJFz5yl76rkX84Jt7Tzwx3d/Y2U8C43dPL0CS
	 1Y8HN2p36jLfxyiOxKF3kVZl9kM96B2bWRfwDb9y3OeetGo13hNso5NA2FVQBbadm7
	 VkhxzruT9bWIuKBbaV0AaFOqTnhdKh2t7Oyy6f4VC6tYFoSAP3hvUP45dm6i6KU10c
	 ZTEt90pVa7twql29hgu3gqBLoFyoII+8UJWWPik+/hajQp+ouvJSwudD+ZcniEpZQQ
	 mVkS8wf7NHJv8Kii8vWaKnWOZiCbeHRmo1yKOmuC6DPXOy9Fe+GmlFsZcuibmebhyG
	 5r624HcOZmBkA==
Message-ID: <2f30e6da-0b1c-41e6-a74f-893d4ba67f65@kernel.org>
Date: Tue, 2 Jun 2026 19:33:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: ljs@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev,
 qi.zheng@linux.dev, yosry.ahmed@linux.dev, ziy@nvidia.com,
 liam@infradead.org, usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org,
 ryncsn@gmail.com, zaslonko@linux.ibm.com, gor@linux.ibm.com,
 wangkefeng.wang@huawei.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260602043453.67597-1-lance.yang@linux.dev>
 <1dce1561-b42a-4322-a99f-89eba1e7c227@linux.dev>
 <716c7351-2641-4317-8675-e07a16a1efe2@kernel.org>
 <63797977-1c18-4885-8099-f5c21c80da39@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <63797977-1c18-4885-8099-f5c21c80da39@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 359F740006
X-Rspam-User: 
X-Stat-Signature: 8px16j39ur3fe3ksinbaujb5j88bb58e
X-HE-Tag: 1780421617-227569
X-HE-Meta: U2FsdGVkX184/UsRmzzBquR8KHAqHwpqxn1AWFwgGhustvRHs0uzcEdxIXM7bbjchT4hCmermmc8CaArQlCHbYt/Dn9Or+cvCrO1+hI2HnJzQ3EFXgOWqdN69kbUEAcHsmE2yBpEHb01NziUJB4uLTQNOqhaox8qc78GMf1eaeQRtg1Eat5/3wYSvwVhjb2UVDfggwAHRZk4ndvfwPsWIzdRTaNTjwjqLmLuiOuknQG5+5I2oRdAS5bJos64uT6zL95+NgwzVJ7hh9lD6j8G6pUC5BS27T7bwURYJun75Z/qLIabC0M/JsgmW7jjQvGZbmb3YWmH6i3VgxUYe+rjSkuj7ehSdhrGJp9M7O9NkK40NfIH1DnPhOYRJ2LDcTTkfw47PMo/MCDIVFIJpLHr6/K1yLDnRDJz8AkxaRNM5y35AE+AP6o7s1bIuPeQ8vafIb7IS2jeIPPQF6K8nr/LjvhhIhSCr9PEIb4gWXhVvGfVffZXl5tHYu9udkPkDP8nCv+1gNTZRr1ZB7PFJs7q89Df0Fb4Mk3dTjdRAenWAqPg7KwUaVk/8KFbcssTepYF3XulfoO3sfcEJAiGA/lAn403R+rSd0Ynfu0PpUA1go5GLCgTKN0tDN7R5MbyRs13gthsAEv92iyNBH3kl6AjESQgKxjltk9PdZUDBACdYFtuSOCdiLX+dIuNcEoaM84SA8L8kyYzd8+cZZmzwZYz5rZ50KXhXl2NIsTlvFuB24wz8l8kb4PigKRYDsl6YrxLrk/GmmFQh9shl6qw+Am45P9KQ+kxVKpV/DhX9EjxXE/w2kicKokq2v+Q0mN/ckuSlRglPMPQj2UXDnHwCkpTPjQQ82/1C0TpHqYVVJQu74VxojJFRb8IB8HUMCgx7OyNcY7ywqPzVp55/PDLRy7PwlgPzYsGmMxuDT+gzoBG+4kNOUecCsmSbCLnZIFF8diYQ5RvPpw3Kyi69XKzEmb
 Hokoo6u9
 1wLMnmrKROfFwZAfYAUSeYXiCdjNXVzCJDxikUr3W9zcFZ+nhJ7p6lqJy/cx0LPBzNhICZD/A6mNgMFhVOET3O/6QiMMbA2GTAB3WRMIOoYihd5MRycOSC6hUEGdcuwj5fQfWKmCjpLV43PUXX4Xj3B2ccWf2CNj3Y8nbdAX23rE4ezqiYgAvEhCdqO5tNk3cRJJeaplTT8vR/1ZkJ+Ghy9rSGi9AJ2/HfPzu3EWlURsLsJ9DQX/wNbU/exHOFZwuy4caA2S2vUCFoECra3hQXnfMrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 14:47, Lance Yang wrote:
> 
> 
> On 2026/6/2 20:11, David Hildenbrand (Arm) wrote:
>> On 6/2/26 06:38, Lance Yang wrote:
>>> Sorry, I missed Johannes in Cc ...
>>>
>>
>> What's the effect of that? Would we consider it a fix that we'd want to backport?
> 
> Just a stale memcg shrinker bit :) I'd treat this patch as a small
> cleanup.
> 
> Once the queue is empty, count_objects() returns 0. That skips the scan,
> but shrink_slab_memcg() only clears the bit on SHRINK_EMPTY, not 0.
> 
> So memcg reclaim can keep calling the shrinker even though there is
> nothing on that queue.
> 
>>>
>>
>> This is against Johannes' work, right?
> 
> Yep, I noticed it there, but the behavior is older.
> 
>> If this is a fix, likely it would be fixing 87eaceb3faa5 ("mm: thp: make
>> deferred split shrinker memcg aware"), right?
> 
> No missed reclaim, just some extra reclaim work :)

Thanks for clarifying! :)

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

