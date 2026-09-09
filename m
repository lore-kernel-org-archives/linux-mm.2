Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A9DC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2658E6B00A3; Wed,  9 Sep 2026 05:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20EFB6B00A5; Wed,  9 Sep 2026 05:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A636B00A3; Wed,  9 Sep 2026 05:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E04B96B00A3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:59:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E75E4A018D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:59:51 +0000 (UTC)
X-FDA: 85193777382.09.670A429
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2EFBE140005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:59:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kCi04qAE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947990;
	b=oLLJuqGdTRXnXaJX1+d32LL4XsJQMbBGm3IipqWxmDPlrpKVB0PKG2BHTswNMeGi8K5n5P
	TRhWhib6V3AWbTCW+7njC/5GIQERQ6KaA0YFERZQHFJDCgJnbWhq0/r9FKMkn9uBFtFw0y
	vkVr4kvas6Q6gdgfFFabh/I9lua/fNE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kCi04qAE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8OfBKj6c21YzZNj+ukA+Gq4PS1zlEulIVEv6QtMuPU=;
	b=Cq6orL4d9uCQsY6A84O/k8oJXyAmDbPHlj0u+2Mn6J2+sBv/fnfOoJ6TI9hxoX64KRQPok
	gabr6n4eJWuwaIDQ/VhrV1jhI6lz4PZ5ALWUl+sWQi93bhTpK5ZK1ohzrEcxvXoEWVOglW
	0qYTNmIpGPhaZFpE1dP1CUJzl2nxAgE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ACE9360214;
	Wed,  9 Sep 2026 09:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106901F00A3E;
	Wed,  9 Sep 2026 09:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788947989;
	bh=N8OfBKj6c21YzZNj+ukA+Gq4PS1zlEulIVEv6QtMuPU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kCi04qAEJQPwqy9h8EcMQz2yRB2+xAu7J2h5HL+PrpbtsKC/dG0EEEmqARw1peuqS
	 Ywg1S9F9VJhRGlUKsRRSsWW/vmNrR4Zbs/zOTncFIJFLknroMcVHH6KvnXvxaYeKaY
	 gdTG7KMNsvngPp7MPWtbowgFZGpCDSi8582T3RMpTE3bE0QTW3axd4lh9a8cvLYzlq
	 rRgZ3R5idwVQEBozc7k2HenYJyftxXWYe5MJ3mWv0okW3nEiIiXZfJAfbblM/ssF+3
	 ckg5uxryFiFazmRPzxdFSTloRFmvoGIzBut6yfhWu2oy2dpD5P+vwMzwr0P9DY39+d
	 Sm6wxlure1mkA==
Message-ID: <f1a0caf7-754b-44a1-880b-75433ab34659@kernel.org>
Date: Wed, 9 Sep 2026 11:59:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/17] mm/sparse-vmemmap: remove
 SPARSEMEM_VMEMMAP_PREINIT support
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-12-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825084608.47437-12-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2EFBE140005
X-Stat-Signature: 7ex933j5mut3bd6ytfdus463h8kbmet3
X-HE-Tag: 1788947990-455627
X-HE-Meta: U2FsdGVkX1/Jj4fhw3Bj1D5vOF0zMIthZAa9Yl67sQMuc9KIiBNMAlVfRbQLoOkjsqlkg5ObQmFx8oCVWBvUweeoGg7NSimDeuRzHBb7tiHl0CtYcqY75IJEtmJ+OlOxIOJ4D+5N315xShxoPCdD/EHigFpw8n6/d9XNu8o2OawO2902AQExn9dNxRQEx8F/rjZodnLL4PB57YVQ2xggM68a0+jFOKcBH2N0LcTcrBYklD5VS013yK3lv0tCaq7nIayEkjLXzP+fa8eGzB+jIe/JkNs/kQhF2RwIkwiuSDFcL7ObuZ70RoVGEz3pKeAv6U8FydLgErtuRRVjaJIoW+XQpro3mMXjAIKVu9KKpf1VsSzC4Um3MyaXhFdCKtmO+XM2i9QjZFYq+NDBse86BVW4NdgVZqjNZ3iMPIPUzYg+0Ka9D0tl1VxFsv69sjMl5wGzT81hcp34mm1fzOn26HA29jpNdvyVx5ZgkMIVWVbMQBbSHdloqFdQadNOm2E/PFOaRQtXV/bDuUOwYeJxR3+1OS6U2rnBK8J51D/SupAu2Cu2ARfQnm/XVJcINXa2ipPnClxYi0XikAun8AHypzFEei0tpzHokNEYlLWoMxmTmKVKjTHoF5oeQTf9Pjs6fr8ken3hhOuKbuslRsPeVOIHaonghy6W4dLn2Eg/SJwB3gkzFNMnzA/vQoK3CKAwQ1uURadSFKf7BBNp4EqOA9oPg0GAhtXp6o1SYZJ3HSMLR27Nnroztf+kNS7vzhcBMe2J9fKS3iJSy7Ozrgrxc/1sanDLQih4EiMQULncL7mxEuX78T8I0kg8NzU/JtuoignuqPLr8sJj08P3AiCFF+8vO45btjljKL+WLbvgMwKMt1H481f2dwNq0t4Mo6p2xl5A0/Lgr0hvGOL/BU9NJQh3qPM6AZixdZRAF5R7Ji7S3KtjyZKvBAW07O9hsa51aE+TzsvPigKBEbsc01a
 0w558+Eg
 ktorGspiu8mHGmATEIKMVF69b05lDw0MGwKDSvBdqKKKgCXFigl/d5P8g9crCDcgMtp/D0HvcMdpijvdjhjkdUGx8vaGOcYiSkgVwkJUN7IdYgFpj4fssYfeYd6llvnraR2Ng4an9ycBylAtjmUJ47Sa5psFkYIH/OCf0K5bl+uyw73Uv7WS9gvEyvuSNaA0BoBwAXFh6QytPLeI8dppDLX864kbSuvgQbOz4ptDX47AmAv73LP/0XP0IcyPlyfz28WPIJXw5ucQqDRYeQl72xQ/6njwJUdofOi8t3A7MihWsnvk2iMjvxYB6u5qbvxIIiPxdQANA/83MExUwtu4+wHr/kvNLKR5SMiUjpx668T8kffcDidEJ1qGixqAIUfMzLTo3dqjHuHwj4Wy8aARFO/EUQdlrrF3009Fm0Z0/6fleMBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:46, Muchun Song wrote:
> SPARSEMEM_VMEMMAP_PREINIT existed only to support HugeTLB's early
> vmemmap optimization setup.
> 
> Now that HugeTLB bootmem vmemmap optimization uses the common
> section-based sparse-vmemmap path, the sparse initialization code no
> longer needs a separate pre-initialization mechanism for vmemmap
> population.
> 
> Remove the related Kconfig symbols, section flag, and empty early hook,
> so present sections always go through the normal sparse setup path.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

