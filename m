Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C0B606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z2yz/HGR
Received: by kanga.kvack.org (Postfix)
	id AC1B86B00EF; Wed, 11 Nov 2026 03:27:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4BFF6B05B3; Wed, 11 Nov 2026 03:27:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961C66B05C3; Wed, 11 Nov 2026 03:27:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73E8D6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:27:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 006F212022A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:26:59 +0000 (UTC)
X-FDA: 85422157800.26.D910F83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 67DBC40003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:26:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z2yz/HGR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794385618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbZEjgVXvDK8Kgt+gDF1qseEqGMNX5lwx+fvKLN2KlU=;
	b=uFgV3XAK8yeY9VoP3ozn7Fe5Lc+h/o1Nw6Qj+a6LK18V0hBCTRdJC+CqHqLi/AKmvrU9w7
	ZBKhwQiKS8/YUdF1w3ZsmR75f03cwQEKw8/1kkegOYemBKA6E4gP1IoSuHJvbjptWOVZdp
	+hMvYF3M+rLJSax+hFBrlWefjvn1jHk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794385618;
	b=CmVO2z9zC5+OvKu3KqJN3BHKGUTBEJpMepzEcnj51/tUdme3AAl8VseZnACMlhGkBf2+Lb
	JLYolBhJtPTaMkLEy7kecaRYS+3FnB0rSmJ9PY3JWB5UTQ4fQcmcmbyGtqKQg0xSxWcuGC
	EE/lMgt9RcRG66TKaWW+wuUoRf1WeV0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z2yz/HGR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA16B63686;
	Wed, 11 Nov 2026 08:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F221F00A05;
	Wed, 11 Nov 2026 08:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794385617;
	bh=PbZEjgVXvDK8Kgt+gDF1qseEqGMNX5lwx+fvKLN2KlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z2yz/HGRzmYSvQvNgV67yt87aPCx9/zsbsS1SeMWnjmYqjoz6Vlkpxfdp24lOa+2U
	 7y/hdkwhwsxLT47Do3IxTVA95ZRIWFepZdyVHxxaRI3JuipVKrwCI3o3VtQUu+ZKjJ
	 OzGxICDXrhjgVOsKCquA4syGsxF7w0y4MYURwdUg9lPRIA0jHeL505rmrMmQkgQNUN
	 NX/IG7iXkVHF41wjDSUEx1mC8B9vBW22qbSbqeSnFwwXMgbFz1r5Fzo+vZHswXM8dM
	 u1iCw/dqNnqFezdo4efFPrjWaypkyLhGq6msNhZ97Gw+i/PebXHjgpAM6Q6P410K+e
	 QzQgz7RqhEWWg==
Date: Wed, 11 Nov 2026 09:26:51 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/cma: simplify cma_declare_contiguous_multi()
Message-ID: <avQmyzQZhwRPQJxa@localhost.localdomain>
References: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
X-Stat-Signature: wqhto9gedoxkjxgznh46mueacrod7ojo
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 67DBC40003
X-HE-Tag: 1794385618-907930
X-HE-Meta: U2FsdGVkX18L5oC+hoNyUU0gm3ikBAk8FtyEIpm4VAsMWYcxhw/+5ib8ZbPAMMbwboKaQbv1zd85n6eJHn064VOSQtWl740apPQlLjy7LMkvJcAY527lz/Gp0+GXNOWTnBiugE1IdF3GQzmQKmnlEVdZWd0FMy/QVFUIV6pDwu/yPfWm0xE7X4a6PjZjSajAm70geHIWDWrwOHOOpeWR7rNKF4blTxJ8UYr7ZwS8Cz5yfNqu/0hl7ivr048BwLoPbf7C4HvZULgKVTizx9SKL/Jn1qfRF3T6eNPdx6fK+wzVoWALZG8tsG4KRa8OBb9/XvssWEiwXc43l8z3+CXG5i98nfRxWZgy18VtfVrhwVGBuFmNwRsxkvrmGJEU6hXwkQLwJ/7YGnn+YOj1LEzCKgzYk8H+HyQUQruLzZrnPVqRlKqV/kLoSTPrqN58vmhTey0Fi9kvto8wb4y5OCa043tv3WVFMjysJgjMGRZQxDnMtTobfOOgni4RSbeJS711Mad2EDqJl2uJSTFIV8GynkV5k0d1qyGITZT5YTVBVVQhrFr72liXKwdAVjlXKrZdokZotemtU5I+eYHg8OxZu4t887oD0EVVHEVNHsat4uAYsk/mv70iCfCij3sPxxHrNVq7veIYOBQ47aoA4jweig8IovdJF9ppYT+Vn8NRz6Cq+dbduyZKwulDSJbBlA/rPYqVaWbKS+v+Fy0aGi8vC2SuSFIVDsowEOvU56hAhZjK7iwcOX89OSVO0dw5szm+BPv/pGyi+YynIsfLYwkuDBuaCEQeNqk4ksXe+qUXPpFUyiTje/PpmoGmmoWgv9s5g1GkJ9TGVDv4bEIiJkPgacg9udHmCPK0+jarMAQMTi4ySlKr3y7XJEY4iSn+yePXMlhjTnFN75icib0W4p80gOoUac3m5srJvmyvPgNvn2T3OC8y5imviH/Iy7BIfssgo//gKOxnyXzSJj1H222
 o3lr/yGZ
 atlwQASEz4sCQOcCQGQdx7gSotEiaT9Jb/TMdLFqijfDzmdK7GwsmkSzR2/M+etvWX71RAOjkeunqb1CkENQQTi2Twc/iocA9pV92wL69ytQrF/KcMMBf55OH4HLqxWsfd0Aidw4zgNtL6Uzw2jYMQHm1R8euvBJYWs4Br5NXRjMqT+EMSMt4vj2NtdqIyWJUT/hKXn9qzfgmv4eg9mroKZkGBESyeasEgprEH2wWssLR0EMgYu2qXtBOUj8eJ+XO5psEd53v+hyw4ZKxYIGm6enAM9K7KjQ/EvE/q5z9UoRuWVMXIVL4k7HGlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:14:40AM +0200, Mike Rapoport (Microsoft) wrote:
> When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> largest free ranges above 4G, reserves them in memblock and adds them to
> cma->ranges.
> 
> The list and subsequently cma->ranges are supposed to be sorted in the
> order of base addresses of the "allocated" ranges.
> 
> This implementation has two bugs:
> 
> * The allocation may fail even when there is enough free memory because
>   list_insert_sorted() sorts the list in the wrong order.
> 
>   When the list is full, the largest range is evicted rather than the
>   smallest, the final list is not sorted by address, and the smallest
>   ranges are used first.
> 
> * the function may report success while it reserved less memory than
>   requested because sizesum accounts for ranges that were skipped.
> 
> And overall it is a lot of list management and open coded range
> selection for no real gain.
> 
> Replace the current code with a loop that finds the largest free range
> above 4G, reserves as much of it as needed and repeats until the entire
> area is reserved or CMA_MAX_RANGES ranges are used.
> 
> After successful alocation sort the cma->ranges by their base address.
> 
> The new code scans free memory once for every range rather than once
> for all ranges, so it is slightly slower, but it is way simpler and more
> robust.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Reported-by: Ivy Lopez <skunkolee@gmail.com>
> Closes: https://lore.kernel.org/all/cover.1792032699.git.skunkolee@gmail.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

