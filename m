Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C9D1CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0116B0005; Thu, 11 Jun 2026 10:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461096B0088; Thu, 11 Jun 2026 10:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34FAE6B008C; Thu, 11 Jun 2026 10:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25B996B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:58:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C1561206E0
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:57:59 +0000 (UTC)
X-FDA: 84867936678.23.3F59F90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D47D74000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:57:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O++plUEx;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781189877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wz9ItHliZGhJvKRUZ4gAmxcUKtvEMcuTAQo5bvyQH6c=;
	b=ZeaduaJ+8Vl1Wkxnbfu4R8iAT8vuEgopLOUbMAA2RjXKGV3aOfCF0UpwSrXV4HOBHo48NW
	s5Nj2oPjapos9bJ/tNxHaiL74mrVgQuDy34DTYAWhoJYVT3laRITPp5TC0jhCG+f1+lro1
	yzTF3A1H2Hf5VJOKySJ9pq93zTocKqE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781189877;
	b=cnSls3wUtW3tXTxLcqFbcnwoY6QIeP+GwaFGFedqpeGmFcoDh82sQ0G/MR1+ShsJb3FoaB
	aI+zJzQsCIxHXjIjOIfmZC4L8WYBL0hNgYskAsxtY0rwxIRt97VU0x4LkFyXAPHS82DsZF
	tZ6jnPbngxzLxJnBKgiP0AWzoElR5iI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O++plUEx;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50B2D6001A;
	Thu, 11 Jun 2026 14:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917941F00898;
	Thu, 11 Jun 2026 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781189877;
	bh=wz9ItHliZGhJvKRUZ4gAmxcUKtvEMcuTAQo5bvyQH6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O++plUExQDTLTfRaG6pFrkzLMrG5CRRssZX2tQl6B6x921jcKkinyn1IDVOsRfAQj
	 QgVQl3VkYQPcrJ41mO1WNPBBIqVI2Uq0gbPOxTNEX7pOyA+oVXViqg6e5WSLG6823f
	 uO5BRfQxSurW2O5wpkUzr6dtet5+CPVlQuIXNVf04am5m5zOmzb8+mN3BD/jahIY4P
	 qvpGimdhqXdQyx4MpH7HRc1P24vsudiSx5mUE4B5iNINSTQBwP+CmKKtwQ7N+bsAEV
	 DWLuxm/70VpePzLALuDJEiVtY5Aoh/Ue2eUtB7xUBGe2nb5ZLIlh6peT3mJUx1vS94
	 HaIZRxumXmcmQ==
Message-ID: <266c82ff-8788-49ff-8a14-5ae57b880f80@kernel.org>
Date: Thu, 11 Jun 2026 16:57:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: drop pte_clear_not_present_full()
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Peter Zijlstra <peterz@infradead.org>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
 <20260611-clear_not_present_full_ptes-v1-2-49865fc82629@kernel.org>
 <aiq86-eKAeDi-CQd@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiq86-eKAeDi-CQd@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D47D74000F
X-Rspam-User: 
X-Stat-Signature: swuyx4de73mtcm7gqfjwxj1bobyi48px
X-Rspamd-Server: rspam08
X-HE-Tag: 1781189877-432589
X-HE-Meta: U2FsdGVkX1+xU4qY6p+hby4wu3PWXisO8fc1ZAEBVhO2tEQhd/drlCuKBtWM7vOATCqvGGhgl8WlS8OrhGcC6kRdPSWzO0xoNpIM4ClH33cQG++Z4Z827OujfgBJD3HbkXY2ieyXnEY753VQLq7wB1PQ+sLzSRKbZepPUjF37M//3/pZk5WGo2arnhNxq1k4BlaaEpzBlAgDP5Lk0Q7r6+qmBolZ8Ef76vqVNpO+XknX/Qsa0ViSMDsRrQHaIWg8UJPYLn+w+UjgWev5mCN2iJ2R7hgizw2j1+YqLaVwAPNph/78V8sFQKG7WCeUJWpdFQDfm8NGWXeUmw1+XBdPVAhZmqb9omyGgfTgJtOt9pUxLwzfYxpGvHdHTKtrHYDw7N0gump3Nmgv07Zz5U+Se0RxAf8WfqcbaAXxuR51Iiy0B0Shns4v2dyCEStw+aMu9AeYShUaYfUcUcNT3SRg4hhkAynhxmT5CIbLMdEX5StHeHx8kL9Zj5ttSqFKcj0ZdFPFb8uiIgcp7kPi53X6pYOkOgorXuCW2HL7wSSeYIkvU82SE5eh6Hq1e9unWhLF4LYzt8/x8B0naDwhg3ikibFoprhcN9r0I7UWOljR4yl+pr60IEuJIUvXfWpOhyOr98QF2XCNw4F3bOmrqH7xS6WA/9qoBidTswhGeyu/NYPqCfqewGi0n5Mih4nnBu5CSsqSCe2zfBEsH0nrNzpwzXGK7Pt1mpPxdNhKz6WYQke6//xuWzHlMAaBs+rbTdz2+/P1DbRTO7Xn8P8jVACn43PgtDC9lCigajRyQIMX0jKTGKZR40NwBJ4sFM0ydPvoflMsh6ihigDxQUNFwD/2Aa2Ze4RSZa4tcUP4LgC7L7jEYv3HtjDRwtA6INpLk3j55h7v7RzTh+b3ptkXH8y3jCfizIGKSBAp226trpdnNC5QAHR9c94Nbfd9dQRFMOznbhCaj5i4g++nnJh1NhR
 pH7KRGOT
 ehlI6yoNqwPDaLiiF5mTiriB/GXF8VYPrJXUCNOFb+kOd3mifCqPhFi9Mgs++SWoKdFVQxe7jnftu87YoE0B2KGcQTGmnAOo+2+K2Vh17azCFDv2IVDcm2nZDgqGiL1ML2R3NLzNaaqla0QAy/BfpOaGfrxgQjNPxNIQviB5O80zolWvwK4jZvYwg73FAo0RXsf5VPdqnXgO/00mVtSfCEZ+sOAuJNXaofg7WXYPXTWM0KY0xLhuIiSXsl/9PK5h2DzmmcnLTaBUHQYPrmpwkglvJ8vc6OtfDurAwH3nyumWK6Y955PlvWQK/6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 15:49, Oscar Salvador (SUSE) wrote:
> On Thu, Jun 11, 2026 at 01:50:48PM +0200, David Hildenbrand (Arm) wrote:
>> In general, there is no good reason to do anything special when clearing
>> non-present PTEs.
>>
>> In theory, HW that does have to invalidate TLBs for non-present PTEs could
>> benefit from a "full" parameter, but fortunately
> 
> That would be on arches like arm64 where it can cache non-present
> entries, right?

arm64 cannot cache them, it may only have them in the CPU pipeline temporarily,
and a special barrier (isb) is sufficient.

Risc-v has something like that, but they seem to handle it differently.

-- 
Cheers,

David

