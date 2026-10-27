Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C9A606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dUgjHgXC
Received: by kanga.kvack.org (Postfix)
	id C88826B063C; Tue, 27 Oct 2026 04:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39B96B063D; Tue, 27 Oct 2026 04:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B509A6B063E; Tue, 27 Oct 2026 04:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 999676B063C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:57:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25ADA40944
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:57:59 +0000 (UTC)
X-FDA: 85367803878.02.4B94B0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5BF2C40004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:57:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dUgjHgXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4pbRIjFXMEepoatVp5SvymIGyJoferIQRKoHK5neBI=;
	b=lvU/+eQ4V8gU4AM7bhQQXjratXNQwxCYrET23fi3HMI+ggUAutOzRfecLdpo/shhvX+cxM
	lhJvZkaKtxuUN2FTJ9dyAlC3RLWT8YUFTUAwe1JaYyZGI1TUrBMuG52f9joJfpyEL8JP7n
	ps0RSeOw/f/fjRJCj+VGJNbLgDY5rRk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dUgjHgXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091477;
	b=KQ2QmuQ9JdWczCrlQcchh0BuNraVw+b5l5QdERJ3Huq4GFfqhLgGIDjZ2edlewGM5atSs5
	0/GzdqiByYsvPTTYv33hOngB2eE+BQltwKz2eHRRJ+FAc/dMERfAbl3sJnVNmMnStlBNmR
	EcZsWYT0StogUEV/lxjUJ8wsJhHzvJg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 887144072B;
	Tue, 27 Oct 2026 08:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7941F01825;
	Tue, 27 Oct 2026 08:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793091476;
	bh=+4pbRIjFXMEepoatVp5SvymIGyJoferIQRKoHK5neBI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dUgjHgXCJ4vLfIuFrQEgzWR4UlIov1j6lq3IiUh6JykkYZoVRU4FVQ+eqKzEWh5JP
	 bGhTuBV6JzJbZD3EjvcLgLbt0bqoT3GIfOiZwPcqVKjryOgz8ZWvBYHCUZGyH46jvf
	 OHaWWaQzE1JxaRR+skY0/u9B3GBcNsWDTwe71wYLsulu3nOBOfQtuA/9M9RJahs96+
	 NFAos8uWErreYYeOHA8j4HPZ2s6teErhWiB8tB3nga6FegO5utJqYFN57oH5LdO4zo
	 Em+16p83yNb+piA3yiqaSL7fPNO0DXlZ2SfnI+pnTKb5X3SUIKBv8vT7hvRXNbwVEp
	 gs0KuoCw3FFGA==
Message-ID: <01d7d54d-0047-4eb6-a1d2-5b3f113f26cf@kernel.org>
Date: Tue, 27 Oct 2026 09:57:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: fix pfn walker races with memory offline
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev,
 iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com
References: <20261027042204.3741307-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027042204.3741307-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5BF2C40004
X-Stat-Signature: giscsqudubu1wt68e63acuxru73m1sb5
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793091477-829349
X-HE-Meta: U2FsdGVkX18OpAR78CH3X5A0bbuIwH943J+wgj+EMpWI1KXTiPqvyeWDqCUivgW+eesiZHdDQxV5cz6xyNNg7KLp7IepLX0HJgIW1dLJKVtoGRDt+rcV1dL7OrLFeWRNzrQSINSuCvV6p2sqBXvZRpZU7Bfvymr5xvC5pfwTuq5g4sTlH1eOO4USSfKSZwFxrb1dlmXBWxwrT9hPIKc2Nr6FoA4AxOiHe2hpiW5pVyM4pw2B9FhgKm/orO27YeJ78dFhjqguu7PEOxfV4sC1+97V6+zRaZmPEh5FhTJvtjMF8AcdowWZMU2WXiFGFg0yRrsXnDkoYH7ywoj0NQwPYr6JZv0Qa2I+wy1/Gp1oIru9nvzbFEWvYu6ZfjWYJB68RXvpZTiT0OiSvQB1BnWKZHxMCSpabwYtYosFMrAc/CCBtCET3CIUlK46ERws+bfVQlr3SV+T8d1BgJpYU4ZlDg1ebKD++RmQl2NfbxU9mGuMoql1m5iqcXt4LrL/gT5EgtAM6BewQpFxfEolhLbHJJhTpFXjhUS0y02qj11u4hAGtR9G26hrB+sV/Gg0HNskOhUJkODSNejzZZw3KtVI8FKBk/pafGVZewyffC4+l331dF6xd3nKkX2CexmsGcAyyFWfunxwPhfZQPN5LjkpwDMUd6zAbUc06KkqHSlAyZW4BvL0k8gqNOG77Ugp4HAbRfyNiZ7ZvMBlH4GqtTZljJy9sjCWkYZ+NDirOq6LnCsAdJLh7ezpfiz8ac1H23d9I2EqzXfryRgzmQiNOfJOprAgnHxlXOlTDadyvU5HnLM2qdj/9Mp8Y147He1H7PjYYFJQHaKWMg50v3vUELS8Q7er/Waf75NRqnZzxRhGnyUym9ph51EqE0OQJKqg+BZz5GbfpGwwbN8T2jbVdcZ43uwGMY+zSEfPUkBUEkIvN0dyauZP4kwNbdIgbyEEl0XE6y+Q2/DiqA09IgzN1B2
 5wARvmXd
 PRULvssIEsiLN8Jw0vGZbEh6yEwlNcsZc9uKWPxYdWwZ3muzwhl+HS6zgye+vMklKLU3yJs82xWc+kAz9ym8HFzqCa6hm3wt6hSi437sNmFQWzLWdXsyOJ8YK3+dkozNxR+EWtDVxfbimqAib8Bmzg9QJRun6g1IG7OYI6RhQt7KThdHl28aUybVdtrRBcrthRAB0UiORhUBguhKO6P5ar+7FpbHnql4j59ETE1YuNUZl0D/1MHRnnGvWXso5oyv15yuzr9Z0NhxxQzpUAYlvZgQ+EwpfhJhZbj60qtz606k/8tW57aXE1h20njUkLTyrFQYPioRsUfcp4398Q5dH97qAVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 05:21, Gregory Price (Meta) wrote:
> Several pfn walkers check that a struct page is online, then use it
> after memory offline has poisoned it (CONFIG_DEBUG_VM) or removal has
> freed the vmemmap.  Five of the races crash the kernel; the sixth leaves
> an offline spinning with the device hotplug lock held.

I have roughly the exact same list of AI garbage fixes here from a certain company.

And I consider this all extremely low priority.

So this is something to discuss throughout the next months and do it properly.

-- 
Cheers,

David

