Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD93A606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=jxzmHuI6
Received: by kanga.kvack.org (Postfix)
	id 8F9626B06D9; Thu, 19 Nov 2026 22:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8834C6B06DC; Thu, 19 Nov 2026 22:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74AA36B06E1; Thu, 19 Nov 2026 22:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4439E6B06D9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:46:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3A92A0D36
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:46:16 +0000 (UTC)
X-FDA: 85454109552.28.8AD8927
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3229180003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:46:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jxzmHuI6;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795146375;
	b=YlQ7yF22lAIQs4nHJ0nka8wK8JQ+OiHGtxuGA4LFrR7rd2SJyHLGcQAbkKn+XQXyOgt7dK
	7c2smY1TvGe7WhmeDtrUmG/Nchq9O0JUuIcIQ0enqVZNTK039H829BxwmE8q9s/+Dd3QXr
	uDF7habJF65EWTBiZvaZq1TWMGLw6VQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795146375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ov5PXrThZFLHfyzJInb6D7h8b2OrOQGcnTyb4KYS+vA=;
	b=n0vjjHB5p8XKQOmLu9vYBCIcJs3o4n7waVQmmHEcvwVAljQCZOrXvtrvkFAksAyiLuvWMy
	aCfqQA8aPqXGXIgEfosZTcTGdPJ18jh+dqnN4lUbRq/lEcTf4yLI/L3VsDekU1ZKX/QO7J
	UVtGP/L7AmNLvOh57i7DO1ZEFSYSfV8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jxzmHuI6;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ov5PXrThZFLHfyzJInb6D7h8b2OrOQGcnTyb4KYS+vA=;
	b=jxzmHuI6+S2AM4qB3E6tP2vW2EUIm1a9lvlv02TDGcNki//Y61eFm1ApxoIQgdj3/h5NwLoHa
	a3ofvYZNVW3pp5D041bES22Fz+KwZQhv0ZzdinV5+BrMqyfZ0UyikSZIFcJbGC16ojEpb5VuKCs
	la9j/D50g/n+bztD1j+E+is=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4jW1TF0f7VzRj3B;
	Fri, 20 Nov 2026 11:45:53 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id A9A4B40683;
	Fri, 20 Nov 2026 11:46:08 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 20 Nov 2026 11:46:06 +0800
Subject: Re: [PATCH v2] mm/page_owner: fix double decrement of stack count on
 unpoison
To: Nilay Vaish <nilayvaish@google.com>
CC: "Jose A . Perez de Azpillaga" <azpijr@gmail.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan
	<ziy@nvidia.com>, Marco Elver <elver@google.com>, Andrey Konovalov
	<andreyknvl@gmail.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Oscar Salvador <osalvador@kernel.org>
References: <20261119234804.1740734-1-nilayvaish@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <539112f2-06a8-7c3a-cf95-0d6d63a7a5a5@huawei.com>
Date: Fri, 20 Nov 2026 11:46:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261119234804.1740734-1-nilayvaish@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E3229180003
X-Rspam-User:
X-Stat-Signature: shone6edxfjnff3w3x8gb4sq4cnu78dw
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795146372-875121
X-HE-Meta: U2FsdGVkX1+O4mabxymVNnIYolJBSoF4sMQeCowp6lNbqfvTWg7pNL48mmBlo7zBxrBTXDf6HBZ2KOPhFbzYpnSOS41RMqbcbYc5k2FYBFLrJuAYFVjXmRrhpfHED3TwKt9uyC6SGHy4st2kP0HISyk0AT5lapdVfMI3w5pDB0QfpdgIxWALcpLcuNNg04c9O+rchsVsYbFiCCxMmPl22x30AZOOaqKm/3/eWzfDvgyEOjmm9OGqu/YYy7J8gVLnVhiluqF3DJg6qVETDtQujLEs+t4TUpW5Br2LvsgTXU8XSwHjX/bSODTfBJp6r20vAv2f+9QLErxx/CEV6TWldYqnI1JRPHZBwgnqauTp6FBYdiEH4jUpwN5ZhxVK0oOKXnW9himwEv/ccZ2hQhvLpn+gepPn2F24nZq5pOqHeAIxdZWvgRQnjGLWAy50yi+MRRt2Z7XL9K+pNhlfYGkbKQZT3vSyFW4cpX/PSIPpTgVbGjxkr/Vg2/evKguth4GG/PFKuhw3cJ6IvZC1SQEk34UaQTeHvSwO3EVWyeJ56LDw73shd85IjaPdZ5hv7PLzemqsTsHr3ov1kwtV3nxi94+EwNSoi+pwlVhol9jUGiRBDbe3rN4dULoIuwUF4FWiVoYuUWAvGNeWkGRtm8VLymVyVnFyj8yxZaqTF2pQgCpnzKwkPA+luHE/w61qGzCnXWS19yAq9qmudEb5VcFweetcZO5xuQbvvMuYQF6GT5oiBuQcxkLUwJrxG9u7KMbvfyopvpvRNqe4elJw2hzGANghjSqHsqLrNHSpWZOfgVd/5z4e5houKm2Bb44jkCmTy+nfdMHfEiimoKWOoOMmfS6TYqHjL/9gpQbSpn+4jdudbZr7SIqHDBPyaqNdD+VMyTAIkJrwUXFOVyUaOFz0usoXPc35+4hq9I5oRjBN3GqpHmbLcMK4bkCyt7V1BichuSUPeBgXG0/ohT8nt5G
 TtuH3qnY
 HBC/CDn1kZ6v6EIAllc907qQ7kvjGRSBgTOTiGrTRcOZvSzo3uB9KRIec5iQYVYdiUyBidXhpHar971D4YxDaU7GC7Ph3WbljAzdOH8ebsN9CB1GFnTye/jrz/yTALtQlJAwpUZuKWTeWYMUswvr6ZwqNNR0IDJ9XR//0wrt530ameKzoCqv3OU1WggZlg6Enkd/KjlioytuhUJ669KzBd4viX1Z4TCRRibKKojs5bKdHZm+UhR0/wFhYZzC+iAuZC/7EXH8peoPpmOhgAWLFFMeSX7IhOcA2jaFqUuM6PioJegrQNcULtmGffa9Zx5rKL9ZP4b8ZUo4UYQuJputApTvvyFFC3kUIVusph/8nyL/lqRJrUtYLqRumYKU/28Jk2gcOSh7N/aTSt3GBqZ6LXt30lHHps7XxIZKrG0v/9wbKiu1xJQkpsEySzV7mF/yGkighEJQ9w+547VT3uZ8Js3+MaGGvu8yr4Ggd2arRyMulHLV4JhO2inyar3B/l0HC6ODpcDNVhIaJHvXMFF186uCU0UFDqmZMYDsLEgzSTikLOX4HPvbtSP1kFYyK35NeQly7bXz6PC9woJw/jiNa5+rD3io7m2cmhuwJjBj4DIaNciPXChl5JyAew5IsfQoJhsWjxv9X6f1DTZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/20 7:48, Nilay Vaish wrote:
> page_owner counts, for each allocation stack, how many pages allocated
> from that stack are still in use. The count is incremented when a page
> is allocated and decremented in __reset_page_owner() when it is freed.
> 
> A page that is hwpoisoned while in use and later unpoisoned passes
> through free_pages_prepare() twice:
> 
>   1. On poisoning, the last reference is dropped. free_pages_prepare()
>      calls reset_page_owner() but, because the page is PageHWPoison(),
>      keeps it off the free lists.
> 
>   2. On unpoisoning, unpoison_memory() drops the poison reference and
>      free_pages_prepare() calls reset_page_owner() again, this time
>      really freeing the page.
> 
> __reset_page_owner() decrements the stack count both times, although
> the page was allocated only once. The first call clears
> PAGE_EXT_OWNER_ALLOCATED, but the second call never checks it.
> 
> If this drives the count to zero while the stack is still in use,
> stackdepot treats the record as freed and warns on every later
> allocation or free that uses the same stack:
> 
>   dec_stack_record_count: refcount went to 0 for 92274844 handle
>   WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x5c/0x70
>   Call Trace:
>    __set_page_owner+0x110/0x290
>    get_page_from_freelist+0x1225/0x1440
>    __alloc_frozen_pages_noprof+0x1fc/0x1b00
>    __folio_alloc_noprof+0x12/0xa0
>    alloc_migration_target+0x81/0x1e0
>    migrate_pages_batch+0x1f2/0x14c0
>    migrate_pages+0x9c3/0xca0
>    soft_offline_page+0x189/0x570
> 
> A single soft offline followed by an unpoison is enough to trigger it,
> because the migration-target stack that the offlined page is accounted
> to usually has very few pages.
> 
> Fix it by decrementing the stack count only if PAGE_EXT_OWNER_ALLOCATED
> was still set, i.e. only the first time the page is freed.
> 
> To reproduce, boot with page_owner=on and CONFIG_HWPOISON_INJECT, soft
> offline anonymous pages with madvise(MADV_SOFT_OFFLINE), and unpoison
> each old PFN through debugfs hwpoison/unpoison-pfn. Without this patch

Oh wow, this issue should be very easy to reproduce, and it has been around for
quite some time. When I tested earlier, CONFIG_PAGE_OWNER was enabled, but I didn't
add page_owner=on to the boot parameters. :(

> the first cycle prints the message above and 2200 cycles produce 6597
> warnings. With it, the same run is clean and all stack counts return
> to their initial values.
> 
> Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
> Signed-off-by: Nilay Vaish <nilayvaish@google.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

