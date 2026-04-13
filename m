Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CB5F3ED7E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E52C6B008A; Mon, 13 Apr 2026 07:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795906B0092; Mon, 13 Apr 2026 07:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6847A6B0093; Mon, 13 Apr 2026 07:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55BAE6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:40:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 052AB527FF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:40:06 +0000 (UTC)
X-FDA: 84653338854.07.C9981F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4861440004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:40:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2SIrkyG;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776080405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5N9uqpBqtopjMp5eC3BYXp+oaBpb2p4J+TEpwP+N3uA=;
	b=1tlPXpR9XLw/XsJ1U5hNHtxsii6gNqd3gvRv0YQQP8rG50wM2HIHJjCH7oBXwwnWA7QgXF
	ouRdVA0SdfCbihG2Eawhynnqw/tNxOf0hqwDUwv+Bu/ZqQTQoAaBwYG0zRF7aBoS8EYbSx
	0nribx4rky3jhC1FgnIkCMQPxOMGWPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776080405; a=rsa-sha256;
	cv=none;
	b=qnlTiFrGhd4gmQv9/8D86QY/+Za8O3kHJdOWM1ZKl1gtviLv6+87XnPu/R87U4C5pd9f3i
	jipu7VxNo1gS8Nppr7VgmeKMITOI1wB+1r8qDO18eFAwwGhDMJfVBkttmP+or+cwqgi7BG
	4kU6xnUduWnhAklABfgUy8lgGDrxHhw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2SIrkyG;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C824760172;
	Mon, 13 Apr 2026 11:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E87AC116C6;
	Mon, 13 Apr 2026 11:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776080404;
	bh=xgHY69iAejNrSVk/EKAw9xtankmfSUeCz0/D+lTjBKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r2SIrkyG+YIVZ+NYdaru7uPldmoVi9ikfWzsR8oWWPT0XvXEUkpO3VBzAkVOD3spF
	 vdR8l2MejZuSx/RHaKOr9MYUWUouWd+60ud41qrpTPkZHHdwUKfZejLhDiQGTU5hBr
	 mgVEZzieH7RYhEcPGTRFp1+SiFDuqHht0kqdCD8/0ySbgXLF70F6wgNR5zLoJJ6LPs
	 tLiL3XdAXGFxbfToZFjFSpKoCjFUgZcMXCAXkYIv9HCeCbjl2EEhmErpeUy656ertR
	 oFkftLThQ/fVlw8FreN4z8PP13gg4+X4+sG040WwwmA50uGqABuognfxUczAuJqZM/
	 kaVj1yhFuxm9Q==
Message-ID: <8eda3f8b-b811-4303-aefb-4b23aeeff16c@kernel.org>
Date: Mon, 13 Apr 2026 13:39:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: thp: Fix refcount leak in thpsize_create() error
 path
To: Guangshuo Li <lgs201920130244@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260412175428.2613383-1-lgs201920130244@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260412175428.2613383-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4861440004
X-Stat-Signature: wepfxnr65r5c4uafgciw9xoq38egww7c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776080405-40981
X-HE-Meta: U2FsdGVkX1+n2nexKlsLlwuaXfYVcQtfJDJ0awHvAmHwZ9gyfwQaE8snt782cwPE5DVLsqMpNSkzIGPN6zHHBaOWOpwivYWPCBXUmbNT2Oj6mODkRoptUNC6zzhyUOMFH7b4/wiesZunBADepniHUSIL2bkQhYGqx95hcyJBh/CHtOvBknb9ALKN5/XQ5o5AO1ycWmeWvpQgVt3IOaEUEf2jZ9GGt92mJ5G+Rq8xYyJYGpwOXQoaYjkg97al3VYWjncxmKAzpRnNKXV6aEu2a6J3vvDAgO4/O5vkcy0sTvDLkYIbn1gk3kURckTw/AeQDRcC2iL/8A4xIpvzfsDXRtw5tdp7zl+Zp70755KR0HULSKg3rgNtpdZhtU/Mof1FC1RGX2HncTi+V2OQJZh2asU3Qsb7VUyUxdPb3X65b2tlWLyR4O/ev6Llj9pnzODuhYDEIN8fc4RF5Y+4bFm1B36E4FciuYJFIbDOlS2BA9kG68LySk7x00koDr5S7E1ogLuLIC+qtd1ftdHzz0tohrHsyqMxPAgcnKb7TiCqUMDanOrbr2f1HKe4WC0fslvhHdLDONOpzNIMpj5AJm9jYIVKCHhlMWsPLlaPIq3V4RqJClqG12HersJIKPCHFNc+qEWNAibiX9RqKrQxAxskdC70rYjpzRESkmUALH0ihw0shxUYgPnU3uMQ2BaegGKwBwdSRXjkq99jU4LlhGHsGvv8v8Mdl7BtsLAdwqVKriue7I/Z5wGIyixesbQI75obeVyxoBzFbZZGbrz4jEkG1Q1bO9nKO/vKuN0R97F1jqGERHH6VC9MA9COYwPzP3f0LT0KUmfjocR/axxFuxZxXkyhRSL6N+QiAug4TCUVzCE8/mvyLMqZCNJvtHeEhLmE1FJN1G9ZakLlaj5OoBrZyiKiI/yWQlWPQ0C/rVNaPUgYE9CwwWhyjut1v0TBzGMBsgMxiayvsrfVvKe+e+S
 Cu9YBC9O
 dUTG0kdRPnSbdyjr1wofK63uPbonIh+WZ1WkbduH7l6rv+xUYpkYUYwlk8kXILDjQJ2YtMXb0IhbgxWTpT6v6bLmT9zFKc0azig4A3rxuTLcH/euOmfIhHtKB0Vy0EkdO3JYPplu8HEUA4E538dpbBGatUEkNd6UYxVO9SdrHG69ugBhm8mZiOXMRLrSXS1SW735c/nA7AD1RZ3xwfQXPXAkSG8CK3uL+r0EVKfSybjJhz3QKFZ2RlaBUntpzWn6TLxUZTTrc7Dy/mgdAfUAVL3zyT55jM578vB29o7zZQXd2LOJjfXxe9eOitMzf2k43Q0Q9+0nR7NXa91HGNOmJWoIPw28rtqh3s6RL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/12/26 19:54, Guangshuo Li wrote:
> After kobject_init_and_add(), the lifetime of the embedded struct
> kobject is expected to be managed through the kobject core reference
> counting.
> 
> In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
> directly with kfree() rather than releasing the kobject reference with
> kobject_put(). This may leave the reference count of the embedded struct
> kobject unbalanced, resulting in a refcount leak.
> 
> Fix this by using kobject_put(&thpsize->kobj) in the failure path and
> letting thpsize_release() handle the final cleanup.

Fortunately, that's only called during init, and the stars would have to
align for this to ever trigger. I don't think this would ever trigger on
any reasonable system, really.

And if it triggers, other stuff would already be severely messed up.

> 
> Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
> Cc: stable@vger.kernel.org

Which also makes me wonder whether we even care about stable here.

> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> v2:
>   - Drop the incorrect UAF mention from the commit message
>   - Clarify that the bug is an unbalanced kobject reference in the
>   - kobject_init_and_add() failure path
> 
>  mm/huge_memory.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..c8ffa188a198 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -726,10 +726,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
>  
>  	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
>  				   "hugepages-%lukB", size);
> -	if (ret) {
> -		kfree(thpsize);
> +	if (ret)
>  		goto err;
> -	}

kobject_init_and_add() indeed documents "If this function returns an
error, kobject_put() must be called".

As Andrew says, that's not what the "goto err" does.

-- 
Cheers,

David

