Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118F0606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GASWgN6s
Received: by kanga.kvack.org (Postfix)
	id 070286B00EF; Sun, 15 Nov 2026 11:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0472C6B05B0; Sun, 15 Nov 2026 11:40:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E779F6B05B1; Sun, 15 Nov 2026 11:40:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE7356B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:40:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DA5F1A07DC
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:40:45 +0000 (UTC)
X-FDA: 85437917250.03.7F7D2C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9434240007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:40:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GASWgN6s;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794760843;
	b=oUVf5X4fCTpa8dY53wnsPnCUiUqaM6bWKYXovuRRvkIaDhPAdGkBrzNt5Sg5xwnNt+uh2h
	Z/DKL34XGnCNNY65whya+ypS1MKgI2h9e1s7ZI4ii6gv1s5bU31htOCavtYdf7Td67QzzZ
	wB4uF7XF/py9LeCAy9DYKBcqte+jgHo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GASWgN6s;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794760843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+CDFH8zAL7wgGtbRFmlbP0nitp9kr0fmBISA0T1p0A=;
	b=2pXe9IijtIUKsNLQymcYJKFXQYx6mzDeqBZ2jCQlGZ0OxshnZT/8EuE1QBy4tpoOMx5C+h
	XvTdCNbTOcAntnNt3ZhB1w4KF3pIp9iGr+gU/4rn8IP2U62EDQzU5kv3y6uJJAhCnWvsp7
	X9eaHIdRKiueBRwja51y1fuNKlnajCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02A1B609FB;
	Sun, 15 Nov 2026 16:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE3F1F000C4;
	Sun, 15 Nov 2026 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794760842;
	bh=u+CDFH8zAL7wgGtbRFmlbP0nitp9kr0fmBISA0T1p0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GASWgN6st+wThFR8ljMWn0jEpKoCDnhja450JTeo/R52YP0MLytxoNmV5cCvcwFpO
	 JpE5FnY1kNm97xMfTGykI5yGxYtWDDFjIm15LEjqlDGhvmZh2eJ3TquPNtIDDq/BAi
	 X4bD4X048/7zuo6GgfJkiuJHDMSIABShwEXV1M7k6R4gb6s+iGH3d+J3SIJOG1L7sT
	 SiZr9qLaL8+P/xG2NUj6qSbK61OKoW48tV1kP2lKTbvz4t2Fb1YYZlkox6ATxmUyD1
	 oU0e1C67qKhAA4bn8q7rMG7KTyHWc7CRCyhAOUKTU4ibLX+sWl0gLHT52wcHlioswV
	 joWoQcgy8kgoA==
Message-ID: <76fc4555-b458-491b-ba2c-ec030879dafe@kernel.org>
Date: Sun, 15 Nov 2026 17:40:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/mempolicy: limit shared policy ranges per inode
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-2-16688b2644dc@kernel.org>
 <179467808112.482102.13365594235443107281.b4-reply@b4>
 <70740a32-92f5-4425-8676-68863f3e44c3@kernel.org>
 <179468794889.482102.14066028910704780583.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179468794889.482102.14066028910704780583.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9434240007
X-Stat-Signature: s4isxee4747eyxxwuyicdibn7ushw11e
X-Rspam-User: 
X-HE-Tag: 1794760843-711733
X-HE-Meta: U2FsdGVkX1/Mad3efLBnycJx3Wbj9IODPOiSnhwYdlywk0gJdmkK+MXg8irlHunBYSm+/koaJ+NLQb/x+5T3cklINrFJIH0M/9FCWD2j9DvddPLgrQrZ1x9frzknnvdyElflTfEY0E1qPwo+yvNGmpvv9mPG5NCBz6UEHBsFgunEHi3e0gqlHqj1ToidvpV6JjQQNHRZC3jjp5jZZSbBgXrh5DQtxWdg8z2T90OKqFNbPJs8UR2Md795v9h9rAApWY1kBmz49LrF7aEKdgO3L/VrBkbe5aVsKroFZOcPM7IhhSioqxSec/MJVDy/LWdGc6U34iI5XJMeuuAY3uEBJf8dGaIKyCI6oBzmmLdfIUd5O0D0CZlSGB8eqPDQxPjOzESbLYN8VYsRXDmw4g2NpGL8ndyUD+vmEognUzyMRTeEKUZoHGkfFHSHhDJgXfc/TVO05/iBxuSfrurx54izRw6w0IRuKPoHRghY1x8ahJgk6/lgMob5jDrIXGQN7zaa4UHq7QQJAbXBKUpFlv7/EUN5iW7GuXcP+RSQrKw4PxuAbO7jPF8s2pcGgQPG+u3UB6fZHlAtSPayuRS/IdvBXfe7d21MUqW+HezgIaa/nEOgGqBkDGY69VSv+f3N/8Pnzwqs4qwt6J3lNobzgDoUm7hjhB1NSCcwuS1PHXzEMgpeK8GNSRe0pYZHN2DMzKESaKXA7QexcCKH89lujSaZKUNqQNlvcycxiaPY+F+Weqi48vBS6tVAhaiOtH3hN2WT8c0+774VnPK42TtaUcIavJ2QE4TgFf/uRkK+lz9ngT93gxs2keLF8WuYWvQMQVRNncahRyTNlp3DS11yzNTEcjn/EMqOw1VA0/gqfwOpN/vxKYOnCUWIB/qIzWMz34lthzi2m3hlUdK8oFj+koubcrSS8Gz0Z+ZQea/p8/o1KHJ4+hq9CfwaR6zxo8pEduBi92MkVorhpWzBpZvQhsb
 f15qSuRG
 zm7pvcWsxFcb6vEOF+XiPB6+FBsF9iiRzfOvrvH28SOyAx5k45EuyBHW57Q1EONJL10ZDNsPwvBM0cfjyTelE9lHWwQ1RSRg6AUHPvq8KA1r0O5SSX2+OTQw8E4zy09rLzygbLytxJjhdN7FYnAEskeK9OHseRIfz0FxSqAgNAuBSaEF5uzurqFo76bwlQqL15fuICSVGHT6z3LKpmW/ItOqZ4wOd5kdKZ2aHNvvQtnJFBFFRgI1lP87B7/vBlCDyrruuQB2XDBGCjtG+5zG5/L/h76BJ5T+4GHAiC14/GWAw5cX7FMwrgGqJbAwm9cxjVBQPxQx5IqZxKI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 21:25, Gregory Price (Meta) wrote:
> On 2026-11-14 21:16 +0100, David Hildenbrand (Arm) wrote:
>> On 11/14/26 18:41, Gregory Price (Meta) wrote:
>>>
>>> Multi-task mappers were previously unlimited, but that seems like more
>>> of a nasty unintended corner case - not a real feature.
>>>
>>> A single process is already limited on the number of vmas/policies based
>>> on `max_map_count`, so it seems natural to just use max_map_count
>>> directly, but I took a brief look at some distros and most seem to
>>> ship a raised `max_map_count` (>1 million) by default).
>>>
>>> I tested that and even 1 million can cause a soft lockup.
>>>
>>> Not sure there's an easy solution here, we might have to rework the shm
>>> policy locks.
>>
>> Do you know a single valid use case that's not solved by patch #1 and would
>> trigger that many policies?
>>
>> Ai was not able to come up with anything for me.
> 
> Just want to make sure the bases are covered.
> 

Yes, and I'd be very happy to learn about use cases.

Maybe we can let this stay in -next for a while before moving forward with this?

> If others are ok with this change, it doesn't look unreasonable to me.
> 
> Although I'd wonder whether just using max_map_count's limit instead of
> adding a new toggle would just be cleaner and avoid adding a new uapi.

I considered it but discarded that. Having 1mil on Fedora et al is not
particularly helpful. Both are related but, in practice, completely separate
concepts.

-- 
Cheers,

David

