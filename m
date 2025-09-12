Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38241CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948C56B0007; Fri, 12 Sep 2025 04:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8ED6B0008; Fri, 12 Sep 2025 04:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E4B6B000D; Fri, 12 Sep 2025 04:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE0A6B0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:31:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBF125AB3A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:31:46 +0000 (UTC)
X-FDA: 83879929812.10.19AEDC3
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 20DC940005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:31:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f63grGhq;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757665905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyIjnXxgpEHBZ+jHUO6LD6T+lct8c3N/yDNLEXQZh0U=;
	b=WmHZZjWdYFfNDkjqRy3/+N1YLhkO72jw8xnL4lSK7MpdPbj31pQfVES8QXucOYfLfE7HbR
	9+EOvZTq/0aOzIBkgDI6uQul/n5kJfoFZrz05i9c6kc+rXzud7K+dflKlXJya3OllGfo2q
	mgEKWrzrq2C7uUzKEW8/ifpyTL1MRiI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f63grGhq;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757665905; a=rsa-sha256;
	cv=none;
	b=gKDaGIySvLgFyEbzBLIyLigPmOG3XZmBLXl7p8vtgjbwtLdfpHE8Gr4k+A4rrQi1WGDzg8
	JBZtyL0oMQ0vGydJEIA8dg2WdL2xmYLo/qSdu8mc6XqDk3jqGSK6Vy0IxQj+w8FmP3R9Nq
	TO4D4OK8+vlUxhZPonE3W75y5jVngpA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757665901; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GyIjnXxgpEHBZ+jHUO6LD6T+lct8c3N/yDNLEXQZh0U=;
	b=f63grGhqA+2/ulYFKDt+DeFlRRksVfwTIFv2nTz1VL+xWgQegezbmUpJXUc1W5d8JYrgrTcoG5YffW5sfdWcmm8cjVlHT2hYHGPXNPh9/nLwHpuq+aNGZzqyts74dnnMTlX2UKIdBKMAhkULGuRY+SV1XFVMANPBrk/ZxI7U1GY=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnqVd-r_1757665899 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 16:31:39 +0800
Message-ID: <b6fa0add-e739-499d-9fbf-32454b5e137a@linux.alibaba.com>
Date: Fri, 12 Sep 2025 16:31:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <e6fc05fa-a622-47fc-acf4-9a5be98032aa@redhat.com>
 <94cfb423-1dc5-43e1-bd1f-75b8d43fdc1a@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <94cfb423-1dc5-43e1-bd1f-75b8d43fdc1a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20DC940005
X-Stat-Signature: unnkjpk1fnfc7tuk4fnr1ha1axg85qhq
X-HE-Tag: 1757665903-237245
X-HE-Meta: U2FsdGVkX1+TgCoZk1CeuMqurzCkcV8vt9D1stV2c6O0r7ti5e4Mk+fTKsEj1rdYL3LaeouZ6cEcOvTQ2i75AWxZqqNJY1MS0/818HvL/3tVxAcKWu0K0w3gLsec82r0XpRXy0YaOt5KFY+bqZMzdTqbvswEdpvP0PB+1PGynQzx1Qmc+ewaTefx8kF6/hYcclkkxaE6syPzN9YBGFpQ4OV/9JVN9dBJL4OzfxVtFZKCluAXzvDuMrpkTJQL1/CFhdJr3mcN8U3uhSvo5c1N/kA9mP4z2I+WSFpe3sqTizc9tlhqj6vGZTJfImMv9GHwM0BlzL6WtzYPpNmt6f8k+gcqt+2KW9lfybIbGIbobyk02ZmTQXebj8hKha2rFB56yMa/71PRruXXxGidmHkSuSV3S+unzqNqftl2QUJdPpiR5fqCWDQDU1qSLKO4ZPlRIVgitbxxZJXadmrYGAfuiSKKNsK1I/ElemUWw32cgVq4gKvcKnoCZysG8C84VEwz1LVItI5WI9b037vQlpsEGYI+397kxrzZVmAueW5QUwLqUel7u6xQFqKAB/hAWQkU9Cz4rPTNjANxiGvEGdNadeng0FlVf2xDjB1zy8MXCaRfvvfUuHDDmohZVtnAAXs5OA6ZvYuJKsajD4wPsViP63X0QJJgLA2XFS2GQrjytuZGCOeyHlLZMt9srT/xG58gjoyYkfjbgpLKmSmcYfmcIHJPJftP6Y4Kt2yvXNRoTdr3tm+OOI49EWb9T5jYz9AqejzUIDQhfkjOd1GDvA5GwhgS65XRSZ5kgHfEl4V152WprHVOXNO1FeO7+ml+jaw5/a5LCamr+bHV7yKG9drGfv9CMBqG/wH03kmNq9IDj67qlvwcyzyV7qotuwHPU5oqAmaQD5KoekmNih6SsF9/2ECrEi201bNYOykUg5UwKjwQmWi82Ic8t/0IehBF9+fR1LnBH1L4mGHV2o3aROE
 5FXdHQ3G
 UKFI+Eqh+8NwFfwdRHIzq6NXUqwklEWMdIfwHgzVLwMfVRGCBqqoxZgjOKKeN77wCawRQhLcauSHLHwutz/XrcWQ/LcBIAihKerZMKcYpPDBWVf7iqNbdJLnMhNxCBW+qHMpDz5MOSuruifyyLXYFt6pLSgUy5mPdB80kDwJ9e4B59eZofevuu5q+ws+KCMAI/r9gtn1uu/76vrs3y8+XW3/hKAfhLebHOTjUYTv+1J2CurYM9L2cmB0jpv19hu53Hh5XK0zJ0ysGrK8IWLmMGM4D88ymE/V+FkoWtad8N1Du7BtEoAKhsyveFLSWlW2hosDAmAB2cSODeMxMmPj/UETAZn6bVS5dcNJ/uRD25z8GLAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 16:24, David Hildenbrand wrote:
> On 12.09.25 10:24, David Hildenbrand wrote:
>> On 12.09.25 05:45, Baolin Wang wrote:
>>> Currently, we no longer attempt to write back filesystem folios in 
>>> pageout(),
>>> and only tmpfs/shmem folios and anonymous swapcache folios can be 
>>> written back.
>>
>> Can you point me at the code where that is fenced off?

Please see the following check in pageout():

if (!shmem_mapping(mapping) && !folio_test_anon(folio))
	return PAGE_ACTIVATE;

>> I can spot a folio_is_file_lru() check before we call it, but the
>> description tells me that there are indeed ways we could still pass that
>> check for file-lru folios if we are kswapd.

Yes, but this also needs further cleanup, as kswapd also cannot reclaim 
filesystem dirty folios in pageout(). I plan to continue optimizing 
dirty file folios in isolate_lru_folios() to avoid some unnecessary scans.

>>> Moreover, tmpfs/shmem and swapcache folios do not use the PG_private 
>>> flag,
>>> which means no fs-private private data is used. Therefore, we can 
>>> remove the
>>> redundant folio_test_private() checks and related buffer_head release 
>>> logic.
>>
>> If that's indeed the case, do we still need the folio_test_private()
>> check in is_page_cache_freeable()?
> 
> Ah, that's patch #2 :)
> 


