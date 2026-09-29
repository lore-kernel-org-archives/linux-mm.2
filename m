Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72B6C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9DD6B009B; Tue, 29 Sep 2026 04:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81A06B009D; Tue, 29 Sep 2026 04:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97F96B009E; Tue, 29 Sep 2026 04:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4816B009B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:19:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AAD1A660A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:19:01 +0000 (UTC)
X-FDA: 85266099282.21.055B70E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD29D140004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:18:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRcuYHBA;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWO0ss/zDd28rzucB/2zd0IrAHiHXnuFXdCJFizW22k=;
	b=TG4k7mmZOztsp0SmevgYHQ+t0SPtUsVMmlmtcSLM0u3ESnGAQAfYVujzfT1chw477/3Tx6
	WZW7X1ALtjznI/5McgUIuD+bFvTnwqSbal+vvmfB4D8m7t195u3zObKbobqcsi+FrjG84l
	udJoN35Ar4w7G7wWNfP2J2xv/lo15kM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRcuYHBA;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669939;
	b=x3Gsgt3zEhqUT2XXqVZni2cIbpE4Q01U8ye9ueFaNNuetl2GHEDv2k+MkLbhCIIQLaArVv
	hGllHYk4umtpoLWsdubbU128Cl54u7rZGCqruoO1ulscrsJhNd2mT7c+6w9/2wdGUH1ZMy
	73jBZRBiSfzpxtBZxnCMd/8DcnB8Z2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49CBA60A59;
	Tue, 29 Sep 2026 08:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA2E1F000FF;
	Tue, 29 Sep 2026 08:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790669939;
	bh=pWO0ss/zDd28rzucB/2zd0IrAHiHXnuFXdCJFizW22k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IRcuYHBA4xV4zUDI0KhjRizXMZXgHbA+hJHP5v8zjAMskG2DL85W8pp/x+06rfMbx
	 XucIPQLm7KLhQvcHGpOVoDLOVxSdOvyRRfAbUOUuai2MRFroes3s2xASo6lxIRg91z
	 MLa4l7GLlrCgpSAJKFZyn6WKguCIjG8+ZK45l4DbFeHFloGqGvXaNzTWQQn5zFxEIG
	 Q9I0pgpL3oMlauZCxaXGRa5PP2pakCkySWw20ubKu5gQi+pkLdykcVHkIKApSfhCem
	 uKAj9Yp79zeT0Zmr3bMVC1nqkyl5WZtScjDwWZzDN5aeYBmVKVoUwWiumGwJWrXRgI
	 USfOm5qsA5YoQ==
Date: Tue, 29 Sep 2026 09:18:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zongkun Lei <leizongkun@qq.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm: swap support for hugetlb folios
Message-ID: <art0PItp9LoUXIcd@gremlin>
References: <tencent_501F9D3CED07B66BAA97D5352FB63EE1A709@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_501F9D3CED07B66BAA97D5352FB63EE1A709@qq.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD29D140004
X-Stat-Signature: 1nyx4as5gbdo8khdin6e4rdaazn51tnq
X-Rspam-User: 
X-HE-Tag: 1790669939-76244
X-HE-Meta: U2FsdGVkX1/OzqWdBYes/xfcl/DQduk9CFaj3k85taYPRkpcbPz9873ey3wvM8GgUHrxfb3YntLWZ7Z6w+dgJlFR+OE7E7qXfh6ixRtroIg1kb9KVTBbmEXuyV9ADAvEIBLYfEnDJ2xjmdBjflG14BW7oeu6ZHCMhJm2nsTWRwHboWFa9FVqEqeycGcdvxhgwe7EJfoObkW0XVPJewPqjQ7DT1lTVRuM2Ne+NkCG0Qqx4vR3zvXjamGiEVJTFKFTaKKcPetk3iZAtP1uKAg5Z/4NBqCcByLCjjTydRoSSiC1x05sseSjCodnmj58iB4Mx72riVyZ8NsP+e2huwWNElO/a0kdpP+ZKA+T8M0CZL8KLE33eD/3slCSiDistbYxdFqvr2GTReV2OYGcJj1AbTbjYDdPa3ZSBASXbVQ45c42J7xeQjIXC+9JDRHCHFKUwWCLGU+pO3HQxYN9VH94Tlz1C13U9o3wyUqWTzPYs8rePO7xlELvgj9Bv91s0/SiuyLOXkTBVU4fg9V+QrpwT89QM55F29VFGaY9a21Vg41GCAiRI/p2/F9NZ0daXznzvWRx1ncm/4SViBlizo0P1KCiJRfcyriuDD1E36N2bk9hDbgU9CeqviDdcOUGpGGOSU9ivmt6et60FLY1MYV8sFwWpwjUIAgfF+0EW9jSbJH4J1sy3KWIDArQg8/3HWVLMIq1ivEQbxUpZj37W5yLeA5MnbPoB4nJcrH5pqpBb2UEGpDpYVp0apLKCrvXmo/1XdWsoR9YiriO0gN11oAKIFxHeK5sNvyztzwOitYjgE/WkFUaeN53aACIyGFX2HUGXbLUmWpAPDRy7mbn9qYJ5v4jPsUbavMsIKnZcZprPTtJgDVv4ft4FzPKPNSLIgxNs3yTcWvu9K7M+ZrOr5JrACA8iBoe2F7iIPlxVzNq2wcQg/Os40w9q75pIZysBrKIIAMbTYt989YCGE2lNkT
 SNoP9JQt
 U4Cso2rZwr/wLPJ71M/JkWY+T5l/g6MBoOBHhVP/2qsnL4WPcJuDB+5SdcdmcR0pm25mU5hroCuJoaqUs5Ra40qyCItF7vAwTdtUGMw8jYKpu1CrT/KbwbR3HGG8Q05MRX+O7+R1CkkJPr08DWsZFguGC/GSf7doGTO9oMJslqhyT2+Lfa1cgQ9tCJCUjhEBFNipForGO6JwwqPpK+bl5pu/kECr1Y8ddNDZ6bWUxsV84tBk0hQCMVxWnnvEIGKDOYjVdLB+RZi1whe2zQdTEHybfCHscDhtUetHJ2hPW701gNy8lZGTbG7/IppCV1v9LyupMwnqT2wntjVnSaXfCQ8wNKZoJt9N9/GfkS7hb40N/6Qau7hMFI7Fv3pXekSq3KXn1Xs2DO5on7iN+avCkPIKbFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

What David said - hugetlb is in freeze so we're unfortunately not interested in
such a big change.

Also you somehow sent the cover letter and the patches separately.

But also:

For one of several possible reasons this mail has triggered an AI
detector script.

Note that, while we are fine with AI assistance, it is kernel
policy that you must disclose this with an Assisted-by tag like:

Assisted-by: LLM

See https://docs.kernel.org/process/coding-assistants.html

It is also kernel policy that you must fully understand and take
responsibility for every patch that you send.

See https://docs.kernel.org/process/generated-content.html most
notably:

        If tools permit you to generate a contribution automatically, expect
        additional scrutiny in proportion to how much of it was generated.

        As with the output of any tooling, the result may be incorrect or
        inappropriate. You are expected to understand and to be able to
        defend everything you submit. If you are unable to do so, then do
        not submit the resulting changes.

        If you do so anyway, maintainers are entitled to reject your series
        without detailed review.

In general, if you are a newcomer to mm, we expect you to do smaller work
before moving on to larger changes, so you build understanding of both the
technical aspects of mm and how we do things.

--
Cheers, Lorenzo

