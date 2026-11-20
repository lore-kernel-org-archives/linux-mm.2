Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF48606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N3c+DUy8
Received: by kanga.kvack.org (Postfix)
	id CEEE56B05B3; Fri, 20 Nov 2026 11:12:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC67B6B05B4; Fri, 20 Nov 2026 11:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5E56B05B5; Fri, 20 Nov 2026 11:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 901BD6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:12:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FECF140F5C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:12:50 +0000 (UTC)
X-FDA: 85455990900.22.AAB6711
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4FA9240008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:12:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N3c+DUy8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795191168;
	b=Y+xU6gTettVSHt1ScnSpHlHqNCju/6KmkVqSpfiJfd0RKjIXAUEsCeGuN195YI7SWsfYld
	EAAhtvhzZ9SuK8oRrsnZdaRDAQn3AST0ALq88ORSuO0b/D6hnxKxlf7BrN7iLJM4KWrAvd
	buV6V5oeFg4k0w7Q33+ehRtg0nOri6c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795191168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUJvVwnS6EwZUWjv8S7z217586V6G8XCo6hR7Yn1lq0=;
	b=QMn5ski2CBuZ4PiYxQ2GirizOdcy+TgMLeidEzF+BgzWhB/SeXl82SBm4Vo08sBoFHy4oB
	vsA+D1FPwWDYkWBB2a0Sz7JNJ5QB32M43My/keYYaS/W6kfouZ7WcYB1mr8RDjy4gmkCRW
	y69m0Rx2qiojwOeoBieNhcgu/1vBEd8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N3c+DUy8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8053D4091D;
	Fri, 20 Nov 2026 16:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE61E1F000D2;
	Fri, 20 Nov 2026 16:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795191167;
	bh=PUJvVwnS6EwZUWjv8S7z217586V6G8XCo6hR7Yn1lq0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N3c+DUy89OIYNJgYet53Hm9+y5kiCcBKKZbBXIgkjsYAK5yjkwgXVZbeD48X7nwdA
	 hDQJUeRAu+B+4t4XjNVIHy/iuVs95mDJS0kZgR5CN8anJoII4Vld5DKJBkh20xXK93
	 phMXJ1zWA4QMMtyNClcFo6ReKQJKUIuDWmzeDHpe4FkLZl6RX0KgSwPoBD9Rs4mt8O
	 OPUlVTXN5fUMpAjnq1Cqta7D0BYDXjVgPqmIWOoLM8EEB34x18uD0iqkMNE76ut6Rs
	 NAls7oApGHHqdH7NKzXh1+ryzpAvZa/XL+0uweigCWoORdnzhsyhen+I7baKCliFQx
	 kp5lKhfwsx7TQ==
Message-ID: <8c9bd441-db5e-4857-8e39-79f147422454@kernel.org>
Date: Fri, 20 Nov 2026 17:12:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Luigi Rizzo <lrizzo@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>,
 Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>,
 Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
 iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com> <awBYFhnpFGtEXZ6r@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <awBYFhnpFGtEXZ6r@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4FA9240008
X-Stat-Signature: 7ya8panxdowgtpoi4fggbm3ujyfqncqu
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795191168-320593
X-HE-Meta: U2FsdGVkX1+gsCqEXJxShEognBdM1tdSRafAn82jIbwlHdLRjTQZCjVPv13Zsgf8IJUnf/VCArJaVfRPZA8QNsVAYoHxCDY/wDheS6iKXHvHCxZ/oQAWe4JKAQ0rTZYhjzPF7LDh5zx9jdQHtGKz5NbwAdarxjX4BZcLtThPkY+qEzNrFHrArm4BoU+gs3jKU7jwvm3CzGVi+sbF+TRrdRW1bNX8gdQndBlGZ8T7wuXjsSlGNEBBj3OLb6G10qNjlfOr6tIRueiQIT/iDQDdp4ygjJYP0IG7oAwuVf2H3iPT1ti47t13F3x+XNq6PZpRZSKPQKr1DphHEw88evGfgrTBvxzH36kXnPLPgsNLTy1+zzNOwU18Ddos7JzgDLS9kyoQxZs2VsjDbmdjBG4Tg4u3GzXkPEBaRuIrcF30NGdf9hQDutDBmqS9Li1Ktu/lbtW4zxutx22qACGJSaZR+x2HI5ZR/HcNOS8zAAayMh4zW5z9uL0MFGHFG8AxW4X6PvXsfyQBJPkdc4tA27XtMndojmQj1jgJSSl0hcncUp66QUtcytXhDqkp1BwifBbVEMZZ100GvFq05RtnJTs7v2m2Vqh7qsvAQtnrWwOKVubS7BffkRmT/lc4A6cz28SmGQN4VhGkS7eS907gnVZkqDAr0X3XtlM19oMhCJmiOGbeVOmL64cnLCdQZQgyxZ/DbVrpvK/7fsnTo/jyROnyizM9lWc4+E/ZVqp2XAAKRPG1b75lkDrsBiK13fl85a6cwrzF+1E3/qiUvu739D1q7OmOd6Y3oMVUF+azqufePVu3wcjxnVlswaIcTMFRTA894yKLjgkRtgCgv/K8lYlD+TzLfK1BvhlEpUjQnh8Jh24VsTyB3+SwEXl0zp8XePlSGQWK/OuCFmcJIgqLGKc48omn8AOxTJeLytGFxCFSfrNvx0IrIJ8P7B9qySm8/fFx22zEVu7O/s4FX/e1hx/
 LYa+Z8a3
 fAmS2ZW3GAP8wtzd7PQoGCOq5+MUDv9sGiUbswKlXgGU2929fG+ITfqXXVIpL9gvCuCYjM2OBQDIy2QO+egSX+emnGRPwEZAypZx1kHO09smJAS06Vpbsofl896Xf4V7DNXhdpRDTfGVrfeWsIkeCzOWYSshdLXqx+LrfjUOpuUYMtRNZU5J9Dl82M8vB79FDLxvKuu/ZyNdwqeWSb3VtEu373kXPXcWqnYFXDA6GxdrmXT3idh0KBmkOMvHzFG4bFUvc3R0Hh0livFuBRxBOgKZfiSBbc5HE8/Da8bzIlKe6cQHsf+zWpfslQXxZ02aL3uIERgv6Y+21fjxlHRbIsCcl7xmWEQ7l8/zQosoHzY3ANhD8uLhxIq7sUoMag+dBRuD9DXHuXrZMsOHNIhaVVzlKIEj8dixSJPjXiRU4JMH2SNWMOCy8kmLOtH96GJamEDyWScqdBoOTNx5X80BWCDWk673Egx4+nhRt9wFKnluix5cErhR1qcucAPYdY3bwhKK83p6m15CbZUkBwbHHpSlx7jNHE7Eo1oTBQOnDHzFOrLiq12142sKIqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 15:54, Lorenzo Stoakes (ARM) wrote:
> TL;DR: NAK. All of it. (And yeah, I'm steeling myself for the inevitable 'oh
> Lorenzo' :)

Oh Lorenzo ... you are absolutely right.

-- 
Cheers,

David

