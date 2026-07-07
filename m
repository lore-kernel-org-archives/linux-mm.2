Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 950E4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443E76B00A7; Tue,  7 Jul 2026 09:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CD8E6B00AA; Tue,  7 Jul 2026 09:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26DE26B00AB; Tue,  7 Jul 2026 09:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E47CC6B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:48:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CACB168BD2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:48:08 +0000 (UTC)
X-FDA: 84962109456.07.BD4B0BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D63840003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:48:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwb2Vl3k;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dswxlVoUXjFFWOz2smDnQwb5mPOff9g7KEXwMGxsrFE=;
	b=syYf1sFeexNCBVPX74T9eTy8Fx7mYjZaoDjWKMOHt/ALz5c7UWy0GUFmKxej6PjdZaBHh/
	G+r2OnQ8mXOPQ5M5qpmgfj6xg1l22W4ZXAURmIXzL00wUvPULDV421UrKRbiuGcMnAknmK
	bhgakUlNt8xrGV+6ryfRiO9247Ibtl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432086;
	b=B4Vxz9elkfxxeT1Ho6K09u1A123RYHXb99GpQLVlVTEzeMXKpcLYgrDjRupFuDAe12z1KA
	YlHqvgZY3/G+sRX1kdYZFeXAhJ6IDkev3NkucKTIrZAufpvAYAwZuXjpcUjDmAgOCvZXWe
	z0OGP7x86wWzOwiY23G6bwBfBXt/vUA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwb2Vl3k;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABDF840421;
	Tue,  7 Jul 2026 13:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545D41F000E9;
	Tue,  7 Jul 2026 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432085;
	bh=dswxlVoUXjFFWOz2smDnQwb5mPOff9g7KEXwMGxsrFE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cwb2Vl3kw9B1Yir0mxFjBBURXZlilfgRyuUYMiigWxIRGDyiH/388LhuNWxlUSJhO
	 l7848zEObF1rOs8l9B8j+adstLF2PkfshMZKvtDNsPxhlNqLRD8dAfe1yLQdFWG26F
	 7sFqZ0GDboY0G2KCcxJnHSRrA3ERO/Zgnbqbv1x9UPtDRMH0qUK3Eg5ZWDQZjp7tW6
	 4BDMFXllHZrkwMwEs/WQEel5Xao1HDIpV5grS7YI50zjkv7CBQolEG57uW5e6oqp2v
	 OldPhFQ6qiCA9o2/4iYm+X1UPYg/5zk9OsD6ZDxp9N5kxgWDMAGiUak1Uk7YRd3Icw
	 Rvrl6Kc36s0ug==
Message-ID: <c03d123f-2cb3-42d6-8127-9aed5b5333ae@kernel.org>
Date: Tue, 7 Jul 2026 15:47:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/12] mm/memory: Batch set uffd-wp markers during
 zapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-5-dev.jain@arm.com>
 <a9483db7-5b13-40ff-8d45-12f40dc97c77@kernel.org>
 <562addc1-b334-4258-b0d2-0154ffed061b@arm.com>
 <0654116a-235d-4eb0-9970-414322645aa3@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0654116a-235d-4eb0-9970-414322645aa3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D63840003
X-Stat-Signature: zb7mabh6zywgcw83347t5ixkan9b153z
X-HE-Tag: 1783432086-981464
X-HE-Meta: U2FsdGVkX1+jltu1370VltIB9w+rdvGqx7ks78D52MdesnZ7lt+WsCywbZ0eSxIpBZIEClk5Xlk9O5Ejr+mGhXL/BAgm7Tlp0PLshlvSXBDfPn+v5JyifkmqIroWQGbFhOBd1vhTs8eViWgU0EacYoIyYwD6NLRF9X1X0Y8NAFEBG+lrrGElgi52ZTY9pQxV+o2MmKcS0g1a9ZQs8tbJxRbuTkLtzdS6nVwfGkBmcvtsES1QDsoygeJ9US+gC1AtvJk+I+/KuC4oxny8YBtKy8/5DWY3r6ZFmz4fkYQxMYFt/mLbA74FjVR9s8L8eSvtkabtEovfp/DLZRzgbGySqYZgmNtScggXLhYOmAdpoyvaKOFbSdWKAL6X7OxgIb5OjsO4VAPWRK3Hzhz0AuQmSUluIm/YALRf5jYy9zQrBzrEp1mtJnxi8kRO6OUSGWKEzQM8G8+wmEg1X4km1pcn64VxZeRmfbq7810/b593lrBSNhCC5MozuJ0mlWfOA6xjmPjraKHNXZIFuRewhr6ZIRYbLwX+M+e1gPSGYeouewkbZWkb8DSZGsZSjcFpWvRTueryRR/nQReHlNxtjPJ4aKlWyh/tNSk6DfnUDoEgeIaP/BPgcsJo5C4pNUuUPWIUI3hm++OaGjBqOHbu/caHeUvhg9v3j4BfOdxsDEp8tk0IHDJdNHF8FrFqpk015LAApgGUW+aFL336esGSnalp3ucn/F2jeqeiJ0XfOghS317KrGI1sxFigX8Bd+X1R+YX/+xFwNm7SlE+u/dHUNNoUemizVaAU29Z+eLAZvWto0vUnnwMKwf3qFdV/AjAUBDywOqdSSjp+pkZ/gG5iEfCjZ9RWYgqlbGxRzHWGua75VKVUaU54rqVfhlGtB05HGBk2zhZA2+m9y/VNfvL4F8B8FJ2ibyxoDa3vZv0jImHl3YSEVw4C5WXD5doxk834QE8rmEEHroVw+uGpqOaevz
 8VRwHu9i
 qD/auhWaqnA6vJwH6SBB7NTmySpV7GQnqsaf4MxenYvvJQJp/dIIsA7bX8LenRuS0WpCAX/3dZBBbZU/DfuTo6DOM7R2UGY3QIyGiNek/baEASP+FZ2vs9Rw9sfTS6fWUqCszwuzCLhfv82RwJRuXfn025jO88+Uz31PbzIIM9lBEuTkz9ZZIl3winiDvEBJQegZnft+SxIXWBMnKMFyi98q9960BLTJxbuaaS8klOBS0CBt47rBlbdks93ltOrgqHLmW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/27/26 11:00, Dev Jain wrote:
> 
> 
> On 23/06/26 3:31 pm, Dev Jain wrote:
>>
>>
>> On 16/06/26 7:13 pm, David Hildenbrand (Arm) wrote:
>>>
>>> Avoid talking about "next patch". Phrase it as "In preparation for batching...".
>>>
>>>
>>> Below you have
>>>
>>>
>>> Could we easily extend set_ptes() to allow for non-present -> non-present with
>>> nr > 1?
>>
>> We could have a set_nonpresent_ptes() in general, but then for some non-present
>> configs like in this patch, we don't need to change the pfn, while in some
>> configs like setting swp ptes in one go (like I do in later patches) we have
>> an underlying pfn. So I don't see an obvious simplification with a common
>> helper for non-present -> non-present for nr > 1.
> 
> I think a "non-present" entry always means a softleaf? In that case, we can
> simply branch on softleaf_has_pfn().

We could, but it might turn the overall function more expensive by throwing in
additional runtime checks that the compiler will not really optimize out. Worth
playing with.

-- 
Cheers,

David

