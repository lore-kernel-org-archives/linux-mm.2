Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C82C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EEFB6B009D; Thu, 27 Aug 2026 12:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C74B6B00A5; Thu, 27 Aug 2026 12:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD116B00A6; Thu, 27 Aug 2026 12:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD2E6B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:45:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D04BB160139
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:45:29 +0000 (UTC)
X-FDA: 85147625178.18.B4219DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1EC8AC000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:45:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AdoA9Uqq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1dZYAjFuoGFepZl/cbwoPeJTSw+Dg47rXi7QIqZjxg=;
	b=sBGvv8/ezFFD5r6WxP4uIjFqUN8Vz4BKpZBtahnyB42z79Mu3BwRQpvPRAHmDkYEo+THVw
	SEWWpZMXfIDoh6ieAxsHvxoJkcEVwTrFYd2bO776p7K4GBoVVye1SScE46OTriLSWZZQEQ
	fqUaBJPYnxSmm8leN1lBzePnIEWL9EI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AdoA9Uqq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849128;
	b=sfxWheOyaSQEpOYdSU/bvzYb09Ms/aRqXQ5I2v/V+1mK9IyKjaX37EB3fU/W0dYWBUJu4b
	m23f0dyDJpC8McjDus2KpSiQfMZoCGP30pU0WM4yiPvenJm/ODbc1GPlADtvk19otcfNr3
	FoxDLZow8eq8Ql4U98fyJjir6fFIih8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97DD2600D2;
	Thu, 27 Aug 2026 16:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7E51F000E9;
	Thu, 27 Aug 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849127;
	bh=c1dZYAjFuoGFepZl/cbwoPeJTSw+Dg47rXi7QIqZjxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AdoA9UqqEDpW+uKrLMUNbTXMFtPqnL/cE1hxXd1M+y6KHmBhziXUoT4oUVsnklGDX
	 rSfgggMCO4k+O5yg4LpR2ln6+3c6VpyxHFr3OLZ6j2iQqJyM1182HeTBn7QIBeHq78
	 M25npVCajc55jkhYwFHmin03/84Yy11ZKmnKNkjKMmpqhg9XTFtmcgrnGP5YaSQDDM
	 VEzKdhk5SnnDbUqV9sOe15kOyjpCHyuiDnbMpHzH7RP9bM6DobSh9+vc/HH20qCJ0Z
	 FgILrheHgqGxYxi2KEE7ii0JhBeNh/p8pYGo2YogJHnIz6oAfk1qkVbgbUngtiYyGm
	 C7jz6DNfbapSA==
Message-ID: <60908273-aeb8-41fe-b7d9-d35c80e950ca@kernel.org>
Date: Thu, 27 Aug 2026 18:45:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/18] mm/huge_memory: add kerneldoc for the split
 helpers
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-12-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-12-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1EC8AC000E
X-Stat-Signature: ts96gw8nu85i4odp7mwm8mxep7w4zhs5
X-Rspam-User: 
X-HE-Tag: 1787849127-780347
X-HE-Meta: U2FsdGVkX1+jNKogOVU/8ZSNP/0uSNhRARxZHupXmG0H+k1kLUHLbdSeUSnUXO9nIwTAyOBRqfXnuPuS+sfN18Oipti1uummFiC30duD8Z6DCd4rY1TICOyRB3zKaTr+Qh8O0mHeSW7F3Y24ZorQ4pn2amHkllmvKck/YY+iJw18u066KuuA5peSnBHiLDg25cXBQ0ZfxKEoIWTpkB506zfuepTq0LXmRXbqKOb9IbLYtt9ZtZsD/nnkh9MGFWY+4RIfKmudptTTi68ShcWfkGoc8rmZtQZuWRHtODT9NpWdAMbuVTrMNjmUQ8RFs9TGYB5QqODeybOWXUDzoeq38jmcKy8OgTRU9tAudUYCvu8co0cT7rIOxirA3ol12S52Dnu8ZRIgr5o7LexfBibg1q5cKftrgWXX8tA4GJa5pwAwnOZOhnv6YMi0zOL3mWP7CrlGhRK48v8X4lM0SQLAkSjBcQBeP2oyolepvoq/+POQ5LG8M4P3JpN2XHwzrum5YRjHe6qN9DrruysKR0MYud+QZAhFzSgpqwzBNIvd19TMu3XoK88U5jvkiUHshkxFQ49MQvjbM3BE97L01zHxrIYxEtWb4wHL78qml1Emz0B/36WhQVdqw4Ql15e+VlR7vDolMXTAnw3iSsSEUrV5BpbgHO3bLQzTbcqTd2VwpZxy5lME3KcQqxYDy3ont5D+kTf6o/XI4Nn8RliFMOxaALW6WaEf26t5yJZHg1KpShGypqHzlRrfZHc/otc2DGYLLOMZWL7bBeYkbioCUE+tQCUlQmRTRrDPyvr4JUiUQs7kPplO74H0NhEWfbMBvc8f9uCxiOEOXXkuk+hYCNycIAUpU4J9vuG50+gAzHoxrGEt+eysejlCEZN6DIOlXoqHXS9t+xHSv2g73FKx8jNVFLyk1YD21EDVUsfm8ifmA4H+U7aPYRdbqaOgyH2v30hvXYkPuQogJsLhjO4dcYi
 L+FpwPt8
 pu4hfa6lA6FEBNpHqUznZxgilqqIGy1h8jhgaDGUTK8L+UkXWYBXpBYTb4Tr3gEj4Lkhjlw0xu8a8itMxzlbXxesHgBvVjYImTcXCox0pueWB4z9hPJUgSU3jP+2mm6gIszpgMXyqQOcSX2gUDxNiYhtEDH84uVq7cdAfjbSOV9ROlPpDxNoH4T6qtj9zJ4yy2bmOYnLYQYidiZ+kw3Lfjv2E3CR1RWsbmDKGW2GtM1VlZgdzD1p9q0C/5mRvlDHV83fI7sX55NPlXzg2fWjg6kKU9lkDNPVOgpuLZBnNf/abTPX/XvCcuNy1uaeCWfHmVw07X1rNm8O5FPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Document __folio_split_unmap_and_freeze() and
> __folio_split_unmap_and_freeze_file(), and rename the file split
> helper's definition to match its call site.

We don't really write kerneldoc for internal helpers.

If you need excessive documentation for internal helpers, it could be that the
function semantics are not clear enough to be expressed by a descriptive
function name + variable names.

Sometimes taking a step back and questioning how the code could be reworked to
be more self-documenting helps.

-- 
Cheers,

David

