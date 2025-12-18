Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D3DD6ACDA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2294F6B008A; Thu, 18 Dec 2025 04:43:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3D36B008C; Thu, 18 Dec 2025 04:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3696B0092; Thu, 18 Dec 2025 04:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F25FC6B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:43:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0FA213756B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:43:37 +0000 (UTC)
X-FDA: 84232104474.02.FEB26B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13070140003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:43:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlt0+kyk;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766051016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U40dfvDhPdSkbgvcp3QIYQnCNeZgO5u1p0c3W2eUDlY=;
	b=7Ka6odNzs4ulyBHLZCKgaMRSRm1omhTvfiQbPMLgSZgG7vN9CJJlfIf+K9TqZcH8hPC7Ai
	ggdwRi2qWtiqY9KZ/SYS7UWt1nonHnik2yhPnmVdEWBCDEgv+3+F2y2Zq11IV2dUpHo/74
	OHAr8QgAZMEMNGfQ7yS1wjKqLEDj3v4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlt0+kyk;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766051016; a=rsa-sha256;
	cv=none;
	b=c108VbRO2x2UA2BOZw+ZkTZpYB7aPLmOdItA+iT5EvfG0Z0FI6fUsMH7oYJRHPkgJfCwXr
	M19ANYZW1C5U2EzWa6R8AjT7hamNu4hJGRSL2/Lu8CSf3pW8wZaotNsJLKSXBPLPjXCRsF
	ZrcBSEmOgWHrtHNXODt/8ZQ1fRO3sxc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86CBA60008;
	Thu, 18 Dec 2025 09:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A44C4CEFB;
	Thu, 18 Dec 2025 09:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766051015;
	bh=W/qmYeDxG0g6wORIz29Z78deE874oJ9pDVm2KieOcss=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tlt0+kykzbzNIp2VLjkAWLd8XB2fRlfNJebkBDgtbtPLc+fvA1vLkUg/zJDXt/TLD
	 QI9RUNoB4lF6pvQHRDeHFH5HJg1+IzLMk7ze3bNCPy3zJy9sSSF8LrKTXtCM2rsexN
	 kuGb+KZDBWSktM4WisGBulWXNxViRzSowPPYmfEXlmZFqP+YAdjNdKoeMDblYvIVOq
	 FJXO1MUyvyRz5L30D+5VvFGm1hfRYsRo5JyitC5OcF0vKcKhi+yPWOx7uK19zkMlmL
	 opi8nNkCdB2lBMri+A2x17UXa3kofOQbirzivRvlvxMF3UV0MkWq0sv+9Uhx7VqoJj
	 Rk/Kdz1JGTutw==
Message-ID: <d62756d4-c249-474e-ae80-478d3c7cf34d@kernel.org>
Date: Thu, 18 Dec 2025 10:43:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
 <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
 <02c3be32-4826-408d-8b96-1db51dcababf@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <02c3be32-4826-408d-8b96-1db51dcababf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1pftmuxozrfo8boy6cntk9jhsrehcpdc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 13070140003
X-HE-Tag: 1766051015-878482
X-HE-Meta: U2FsdGVkX19F7r1zKtFQrEaxkO6Af/Ed2JK1duQtzEIZOaPz00RaFrqv/TzTJAiEFT2rUTplmggyu4TRt8P0vh/rtHsx0NPx4GsOzPOPZSIzsoikHoaqDAg+KXAv5EMjQX6o9hqj6L4+tNfgkK3k8HsgA0zorieOUGHT0UcQyUWd1FVohRwGkMnZ/fOUgObFMFA3i7v4BhznHF5wK+W5lmg0uUSz+wTfXdAWh4PQYmcmuAWbqE5n1gzVlcd4qznJBKrqk+pvQgI+nNaL5Wz42Lu86L6/QeukFkTBoSC4ClySnpPamx0abNlOUgkxUSXmcfxXRtM57JrLBxYmKkywx4OKAMzx2SjUg+DM8yifqPb5mJZqRwkz2MexBl5h43iSKPVwUZYimgjSdg1XEL93NpPrjk831k2VQVdPjNtdhn0xW6nZWjoIEyNBdDVHgWF9xm6yNL3d4giUBp4wJCv87nzTJapBIryShSXUcEfjj+F1sQrgZye0n2FOc4P6imYEcb4E3nV4Lk7CnvFaQ3aglKCenjSETjOL5Zu386C0QSjw1oIG9GYTSLW76pqInuMGA7TomKE7G2GwvBVQz/zkce7WOCOj8CdoZkZkwNp6droa9+YR6IsDLMqV/b2/YNLDeWq1eF40NZjZ8LwqJiW5lhV3A4BQIwIkU3pOybeFT6hyYED2okmwxTID1VgXKjqfQWU7C4URcEbbCkPd0qmnlqRQqUfe2hbYfOC2I3cGdlcw250bGCxsYI+nfxlWm22U9y7QXU5AJRlKTDDtpKN2KJoTgAi0AME7vUPOVSW6D6vw1SDSjPSEt5hWwLgwRO5lOQ4t/ICRks9/mBHE/08Ge5XiwcVG2dKCX0YDzz6Q+oB0KDWRw6PzvxFLR0jtRWU8jvbRB2hbGSZlc7YctE+Y7S6EbZP51oo7WiAzeEi/sfvvGJn3bepLOwa39d4iS2+F4jjL2cEFbF4h6c6YIMM
 zOEd8Gok
 5Dlv7dweACdZDHurVXezjc9DYpg5TNdYuvKmNDnFoR463UVGNUpxuZy/zNUJkkC/tXq9NpGtGiOGX1ws2m5/3CrQm6kdUNmf4sxaduujmvZA4bmqIb9dtd0LRGsHmLxJOr+/2wgay177GoN4o1FWuKGQTAN0xy1RqD+P9OAupTUB51WP4UQukPXl3nzgVYVx345dgY8DcIK5KqPUjdlv9S6rR97rgOCRnq4+tN+kUn44JNghxeTsTaUN/fVtE+SIy5yJRzH2a/FrCJXrN7TbiztvPbvd8POizuJiTUVuU3k4hSNtU0fuDQbZ2UvXaGNnEvhzq9Npjo8EkjNGobgf0x7vBYVPlO9RRqcjB4Bx+85VydYVsPX105WZHCKcYCUIplT4q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 10:36, Qi Zheng wrote:
> 
> 
> On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
>> On 12/17/25 08:27, Qi Zheng wrote:
>>> From: Muchun Song <songmuchun@bytedance.com>
>>>
>>> In the near future, a folio will no longer pin its corresponding
>>> memory cgroup. To ensure safety, it will only be appropriate to
>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>> returned by folio_memcg(), thereby preventing it from being released.
>>>
>>> In the current patch, the rcu read lock is employed to safeguard
>>> against the release of the memory cgroup in folio_migrate_mapping().
>>
>> We usually avoid talking about "patches".
> 
> Got it.
> 
>>
>> In __folio_migrate_mapping(), the rcu read lock ...
> 
> Will do.
> 
>>
>>>
>>> This serves as a preparatory measure for the reparenting of the
>>> LRU pages.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>> ---
>>>    mm/migrate.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 5169f9717f606..8bcd588c083ca 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct
>>> address_space *mapping,
>>>            struct lruvec *old_lruvec, *new_lruvec;
>>>            struct mem_cgroup *memcg;
>>> +        rcu_read_lock();
>>>            memcg = folio_memcg(folio);
>>
>> In general, LGTM
>>
>> I wonder, though, whether we should embed that in the ABI.
>>
>> Like "lock RCU and get the memcg" in one operation, to the "return memcg
>> and unock rcu" in another operation.
> 
> Do you mean adding a helper function like get_mem_cgroup_from_folio()?

Right, something like

memcg = folio_memcg_begin(folio);
folio_memcg_end(memcg);

Maybe someone reading along has a better idea. Then you can nicely 
document the requirements in the kerneldocs, and it is clear why the RCU 
lock is used (internally).

-- 
Cheers

David

