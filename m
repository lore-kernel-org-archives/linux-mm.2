Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391DBC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026126B011D; Thu,  2 Jul 2026 20:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18AA6B0121; Thu,  2 Jul 2026 20:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA576B0122; Thu,  2 Jul 2026 20:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3456B011D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:58:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD92CC045F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:30:52 +0000 (UTC)
X-FDA: 84944224344.07.854FB61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4DE64000A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:30:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X90zH9Jy;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783006250;
	b=thy9zbHkludZMBf/59hRkkYQHsPz6dhGBaBqTzPBuwPk6H8yws1GCR2lbTIkwH62jXU/Ux
	+CI+SCFptHHTEZsISOo2VFHtz/EytKuWtdo91Tz0M8+Vl1fcDcSIRWs8yClLkXWgQVec4H
	DnroqNbflRwT6UI3cjtcjwkKpp5qin0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783006250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQIOVySReL8vS2U2jav9YDGBDGuteWIuFYGGUlN0FC8=;
	b=7BqNcyds20Pv6BUTROjVcmdV1WEhMMXcwPfMkSG0l2KzLksKx5blaWAnDLNTpv4MW0/JoP
	k5naDv3xToiO0HVDNz8N7BV64rdRuAEy8SjlIEC0fLBr/GcignIvtdIZqHwo+d33zfycrt
	FgIx54lwJ4gS8c0mDmRI0k718EuUOqQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X90zH9Jy;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B711601C6;
	Thu,  2 Jul 2026 15:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480371F000E9;
	Thu,  2 Jul 2026 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006250;
	bh=lQIOVySReL8vS2U2jav9YDGBDGuteWIuFYGGUlN0FC8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X90zH9Jy/e9p4kfi2DS6OMkiROYz/68mN0iPhH41GUXVyq+OeD6UtNB3YsTKjikeT
	 /UkPx2ZBpaK74k8G3UzvLNYI8a9lifGYdqUxQms7WdCu0FE9JFo/8mA6q8pYfxpQOI
	 IJnIeaY04WvUzrLKT7czbbjYuVZOGgQN1L2eEZhr7f8aWRZucinTJPp6ICT6Y3Soih
	 2d7p8lEpmqH9tROhhJw1rCzzQbj5FabizMehNbDndcfZ0XNNhDpNkTP3Oa0sozcNKJ
	 uX3yNDOR/D/lKK6Kz+vBoj8anHJk7Hhh+Z5WVaTLkdwnkdDnB8h2okvAy9k1HLCr5z
	 hBdqJB8YLm1LQ==
Message-ID: <f22ed786-88a6-41d4-9304-ca617a0e7d06@kernel.org>
Date: Thu, 2 Jul 2026 17:30:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Muchun Song <muchun.song@linux.dev>, Dev Jain <dev.jain@arm.com>
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, nao.horiguchi@gmail.com, ak@linux.intel.com,
 mel@csn.ul.ie, pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-3-dev.jain@arm.com>
 <97a43d82-28c2-4f98-ad74-fe05ed9f0297@linux.dev>
 <a6a00b38-612f-439d-9b75-337170e3af30@arm.com>
 <CE6E9F6C-8891-40E3-A5B7-BA475070EACD@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CE6E9F6C-8891-40E3-A5B7-BA475070EACD@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6x4q4srs8dx1gdp5fkib8nubh6tyoei7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E4DE64000A
X-HE-Tag: 1783006250-640832
X-HE-Meta: U2FsdGVkX19VNjCzznVi49XWhhxPDh9d6Ji6TPtaCbO0bsr4ZmK2tOzh8BFiMMHdAESlkdWt8RE83xPgAJikSzQuX68gevQdsIBXUYWoTQKEevjvHFH7eO3TFn0et3Uri4cninJE1dlxdDXkz8SbzQoWLaO2GXKxY9xMeFxakr4axa6UiDY4xm7NlKCHFK6AKqSpUbT1fBo3QXxODQEmREZeYHB8zhUcjLLcBbuQxFMyMBdUcRnOTfupa6YXlEAmzH6o8kvIHZBAf9oP9GyvIvftRyjveHkbYpex5qgT7iIN71JhDFpO0QRfWtOU7OZUYAGh6aCJfHPG3bLHCyJG7IYseH2BG/ZihgnEi1ebgOy1yZaA80zMPxu5ELTgKI6xTM/00vTtxZYFqNLI0kCB617Xc4yFPsQMNifphoywWxC2x6l6IS7vjNxycKXAHtgBAE6nNZ4oo4vHhFhJNzk8kcdtBYcgCsMP0ezmH19ExhYTeceP8EsbnIdMmFw3xHJ551J04LnMmxfI0V5ZIRDLZ131SC0T/W1HFW6G7P975wBZjoXbPMtwtFIrEWrI5CjWT3u7NAlwEnTYOcozfGVPSe1sfZBr49ezlGuBcuibda6SVMu0sWq8UmWfSxhZIO/cMr7mDY4Ng655p2RaVC5GIgjTLgt8aGymjqFuTTenMoHF4ZctLKTlhKAB87fKKwuVlK4kc+YQ0bmI7F3gCBq01j5y4qBDcvp+h1uSl/ob8qQ2VMlcHeI/S7bsUasVvzsZRZqAaSe4V5gxebKNwOIbeVktCqxZz5Dp79/GEFW5/ltG9nNWwqS/gfDYT6x/fSbfm/u+yXfRaNw4/dnXX6LOvp/P3wRtG3XP+aszbFnM/92ncVxpqIH7qjnW0HbxSuKtvsS4g4ysZttxnj7BiRrwjiwHoNtnnmVH50X0ezE5YdqxVn7jcLgfh7P9bvKDXpUj586hpqS3yiD8r7NN0+A
 btdW/GBZ
 s85YcGZAv4o9FF4ytRhSHmEtoNj9n9wj7NqCIsnkICnPBKGbQb83u4GP5kCRolt+Jw3gFi1DogRp4zsiVOW58qRJ4ApNI67xg5GAwlfWMvWFd3T1ouuvv8IeLg5AJOSgMqw96c5Zq3PvFUgDvh8gP9P2sTmoymiZSpYxY1lLioLXQxfoDMQham20NoID/HERiVvkWvNfrQg3fgEaI9DObhY5JpuMX97UdFxBUpnI2AXkWXVqjPo9Y2ci4Ta/Ehu6AHY+ifiWQfU3bQ123cJokFQc7ywi9gFNTTY1nPI3UJARp0bBbuZE7FygaesKsd1yesyhDLE1coKodl5yNXrjOy4bMHRTzW9rqwYHdB24qs9iLNl3yPs9lF0vpVU3SZVlQhO6FsXjsr5syod1FKEEgEZAvS0mg3vCewB0cffNUweFnpiYUC57WRhHUw9vLBjYSShUCdkF2YTz7kqM0ZMGIb77wbsf4ctbYjj2qdsqE19FgGNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 11:35, Muchun Song wrote:
> 
> 
>> On Jul 2, 2026, at 17:08, Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 02/07/26 2:17 pm, Muchun Song wrote:
>>>
>>>
>>>
>>> Maybe I didn't express my thoughts clearly in the first version, let me
>>> explain in more detail.
>>>
>>> We should define this stub as a no-op for !CONFIG_HUGETLB_PAGE (like
>>> set_huge_pte_at, that is why I mentioned 5d4af6195c87c6 for your reference
>>> in your previous version). Currently, you've added a declaration, but the
>>> function itself doesn't actually exist, which seems quite strange to me.
>>
>> https://lore.kernel.org/all/a4fe8ba6-2ecd-4bb9-95a9-27f9f1e87d2e@kernel.org/
>>
>> David suggested this. Honestly I quite like David's suggestion, what do you
>> think?
> 
> Thanks for pointing that out, I missed it earlier. That said, looking at
> hugetlb.h, it already contains quite a few no-op stubs. To keep things
> consistent, I'd personally prefer a stub here. Since David suggested this,
> I’d love to hear his thoughts on this as well.

It's the shortest possible way to enforce (through the linker!) that you
function is not called from wrong context.

The only alternative is using a stub with a BUILD_BUG() in it. Which will 4 5 LOC :)

-- 
Cheers,

David

