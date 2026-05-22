Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE80CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45F346B0093; Fri, 22 May 2026 17:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F946B0095; Fri, 22 May 2026 17:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7C66B0096; Fri, 22 May 2026 17:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 181596B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:52:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8F9A1C1D2C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:52:11 +0000 (UTC)
X-FDA: 84796404462.26.FA3354E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 19B1A8000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:52:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GBit5RGA;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779486730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eApYXU+swQ/aSMT4+a9qbCpi/b8FjdNDOxy/EU7ZU2c=;
	b=L/DEdYJpxKz9u4yM1oWA9jBS+qsbnp7MYkSGFPORSRL8GSiJCGRGVKckG4JUr8s71YNveO
	Mxbc37WIfdQKRCMlcmsWBgrdbrl1hEIJi4InJiAopS9jYY+Htqy+jddC7ZGMA9e98NDdsf
	IQjeeWkzgodDMiXHTC1V1dZyQuLvK+k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GBit5RGA;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779486730; a=rsa-sha256;
	cv=none;
	b=7dkhqYssC/VYi1i85nI7pZzZEp2j3tQpPchZ8jr567sDrspobyNckcr8YkN9A0T7AFaI36
	wzOChVdNNjrZxxLJOAP4WPZ2/YFTFyYkmYU7c1w0pMldju5umvcVNZdQxHKlQLPnKaS2WQ
	9Fcl0FMmDEXzGqpY+nAZ4dRJN0MYP5s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11E58417FB;
	Fri, 22 May 2026 21:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47E11F000E9;
	Fri, 22 May 2026 21:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779486728;
	bh=eApYXU+swQ/aSMT4+a9qbCpi/b8FjdNDOxy/EU7ZU2c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GBit5RGATOfbr5x1B8Iah9ZKcHyEC4nw1LQkzGQ1ljV+PUlp0sDeFbRMge8ndkD2N
	 5hbxQmyDKoxzBT2A2WOm3msxhnQSIeFA1rxJEhBh1tS5fsrRP34troIl8gB8dwVSSy
	 n7incecVx0eMXZzVx1M2WyuUX2wzl1KEGQyLqwcbXO5cLbzciDNnFyGrRMSJQ6Iv3u
	 in+lJV5CbLbY5Vjz8OaHzoxOFZhQr3IBXF8Ojv4ugrXTIjR/CA64ZAImWeduGj97uq
	 OswYEX7Pt1D2sTAFTHfmYgA4cGgJINi19f3moklhfuUcALrBsmn1Fmc4GXGXoVGWPL
	 o6612VYwIJr7A==
Message-ID: <f8b8e2c5-34fc-4dee-bd18-41101e859cb7@kernel.org>
Date: Fri, 22 May 2026 23:51:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 07/14] mm/khugepaged: skip collapsing mTHP
 to smaller orders
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-8-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260522150009.121603-8-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 19B1A8000A
X-Rspam-User: 
X-Stat-Signature: 5mzgrdmnjq1dj9hh1zfpft1ghucz6b6k
X-HE-Tag: 1779486729-949265
X-HE-Meta: U2FsdGVkX19BoKlZpP0crObvJpn7Vywd+fUM5zZ+oNfCsS0G+/AAubkZKGRvrWR96kZSKp5GBOIVEjyxu8QvtTNcc+pmj1utN6FtXn+SXFAN5hRNvvJMSMJy/wlrXHKy/FHDLelnxYNFA2hqsGxAEK7250rY8HYQqUVc4ndsEPNZVkg/P4yiaknanhYrFmezRzR4Lh4U9H4BqdYqFQW2w/A6hPU4rtCbhvE/yk7OnUnUlilcuqHCrJM4d2wi+uZqrUxrqlbevbfJztOXII0aPm6IJniN7aGl8L+Oduz5R/uthAvY9UrgCIV0yX0Kc1EFfp/Ub49BSNcJwoK3tvawf0v33HEBxOD2sfWELGh0DuujNFO1Fjna6NIuBbPqwGm1Zokoq/6qml4uKj8eAzDf90E3UObM71qjzSo/D6wyqxdzPwN8571DAZ8/LQWgklunezN0g2YFvCr42H24NWkGuf0OkKqfMFns93xO4WXTlZaLCXk/HADympGx/PV1EcytrVG0MDAYan7uJbseWBVVL06pe5Px+C9+JiV9ZA9nwKTUEeD5LRPlxTNivMoZkiNpBHzFvlH6oqY5+ya+klhK6ZCNMbpvB1rvPgjlzYyI5/pf2zItm4VyfvnyHZ2VUVmASgnZrXw+NO4lk3ab8FAuMLlCyITprRy82AggCqk6g/1vDfz4QicYRiFcptbisgr9amSACRHr+l++NjwVp0dwm7aQjiH6RNLCXKXJwNySuJEUNcqJiHhqMibUDhb8NM0XuNe0f8HA770qntKPJL39rTxSozkQcrYQitepzwM8dAk/2QdoyBXjM4qI2GVvuRDyXpQYUKeifqLuK/z49OOpsHT/GCSutfarRmHi2GbwHmxU/QbMc3gYxi9BgZsyGn4O07tM+0wxywx01qb+P5XR5YQnJhM13np0E1lkQr8qFMMvgypiRf6Y74a+K1lrZ/lH1UrKFRELGSDZFn2KtbV
 BQVRq60c
 3ke40vkZVHrfZb6HLiEJFQNAQ8u75tgPdzOWyurNkz6O7+8WE7xLnw1qegLbTHAwzpUfyO79yNjLfnLPlqUe2WlixGjN5e3UU9Is8wuW4L3Tz4y88zJGCxsP0y3qN1q00bgJof93Py4JQRS8egL2vqlcTaCM5rB2Lsm1yaWHMgLies4PF+JC00zImz1rMwxLL14mcAHrGNsWfBnhDbvhFBkQXe0RRU4m7ejGq+uNn1NJYHLWoCj60O4WCjJGOaRJaw2oLssRR+nvZcwy6/2wxsv6GYWAtVe4ijFKFobW6TozzpRr6zzNoAeKbn/hSv/E69UQnNBUOZHmTZB8E0HqEFlnwKGC1aKgZL2AU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 17:00, Nico Pache wrote:
> khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
> some pages being unmapped. 

The "some pages being unmapped" part is unclear.

I assume what you mean is "possibly resulting in a partially mapped source
folio, which is undesired."

But there is also the problem that we could try collapsing a folio to a
same-sized folio, which doesn't make sense (assuming the folio is fully mapped).

Clarify all that, please.

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

