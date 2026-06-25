Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAA3CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280376B00A9; Thu, 25 Jun 2026 07:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257F76B0125; Thu, 25 Jun 2026 07:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147696B0126; Thu, 25 Jun 2026 07:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E06786B00A9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:51:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DE8A1676BA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:51:07 +0000 (UTC)
X-FDA: 84918268974.17.7B00893
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 920B840004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:51:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zp0mOr9q;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782388265;
	b=owx8QgVMo4bI38O+quJWbkBvzwXiYUpck6nmxzXjlEX/wcjXjHmhSHzVYNbTqGyGTrzxX6
	r5xnOzicwF9LdwoiQnEb9bLbvrSeL4GJL3hFCC6FqS2ZC68WMAYu+L3/JfCHDimdKG4amP
	mkJnMUD+2KReNGK7cHU+kHn2W09Y2W4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782388265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hh8oiOowWZMfYNh0sdl9wulo1T9jtJmItc3jEmb/BRQ=;
	b=B3TOqcPjqp36jPiIKtDAIrmbrdDJcTNyu3WkILUGxBS8LwmC8X3OdOuvdB5jdc67deU2vh
	rcdhur8+aqUWOyIkNYfO2/D0slm/D2di3lLdc3hnI4xW5/E0RuZR9ofzcHdfF1BHqi71ni
	S3LRsVBZxysVmFKwRKkSGhQL08rbL0U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zp0mOr9q;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 212376021A;
	Thu, 25 Jun 2026 11:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48451F00A3A;
	Thu, 25 Jun 2026 11:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782388264;
	bh=hh8oiOowWZMfYNh0sdl9wulo1T9jtJmItc3jEmb/BRQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Zp0mOr9qz+03Ut2IAL4eKFy70V+zu4xxF7zOUb2dMiEV9vt16RlHbXGQjkMyL9V98
	 wShk+N+RcCDDFqbuVcE+GTlWWUB6q1XfMc2XScidYrpVb09st/L4PCwBBWDendu9X0
	 F7Dj5BF3PTUWhJSDXugXl9U7iwka7wnWSEL42l7kmB5WuQxstKUEzBzgYlTiM99Xbm
	 18LXMeu9fwdI4OXrilzTIh9APTUu428rMcrSgBnx50k9kxyLkWIwAqpSa/aebbjE+S
	 3VbVWPgLsbImNMrCYd7vX/UFSEICqHmiBmmmz9Wlw9JGo0KMlZ3BX85TVdj03HEp2+
	 jMaBwadRxBTgg==
Message-ID: <b23506ad-544e-40b9-a940-66a6d899768d@kernel.org>
Date: Thu, 25 Jun 2026 13:50:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/mmu_notifier: let interval notifiers block THP
To: Yitao Jiang <jytscientist@hotmail.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Felix Kuehling <Felix.Kuehling@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
 <SY1PR01MB1059616E59F213B6FB4F4E3C5C0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <SY1PR01MB1059616E59F213B6FB4F4E3C5C0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wx5mihodddteeyyiqzgxeewjymku4hz8
X-Rspamd-Queue-Id: 920B840004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782388265-128189
X-HE-Meta: U2FsdGVkX1/VyImOa37LVHBSpjRaNc7WEgYtNFW5O7+s7/u04Yo89q668x8oksCLfupps2Neat3U3+3LuwThvh/ZUBADKnzp5Il1eKNsYsNwz7JQDuHPxbivFGwhndkmKuNkc4OFJLLrfDw1FGtUAGDYPMi2Ue7hL+yHx4nnY965lq8OkrUEgCZ2oCphuNoT/4ttmJYywM2HOv1Hq93EWMocYe6zxj2Uesi747VLGm1LQ5y9eA2WBX+8xSiZ2NagA1ZFa2udeJ2c9GpSz/97M48I1FeSUbje9/bz5nhalbL36uvSJyTfHmQjjCSC+X9k+RCpLB63fjyz976h+OKRGZ4rMFIMKnxZXvYnbP9gVDC2wOPkYuidbpq+C8zbdAGvG9PIHUP9v0YDOgEkRDtRJ2LpiyyhBKwmN3EfefTc6AxIIbEA+eyCYx7GjL3FhWBhu6sTIKZg5HBRhw+0xhut+LMpuOIBCIlKR+kN2h//sjYoHHPi7zWt09i5jaNBl7O3mOJna3rdv8zQVohjsZnAyG8g+r6PrfLFPYXZNakXFFS0umywJ5kUW60tG1JzOgfGcTuHGBFq55YWQZdwevXGZ5FivRHJDnMugNkNUT8fB1sbemQwAKyf3crKBIIIzgsJM5vZuNf0A2MEWNfdcSgAhSU8veaaK9/GKXcu4i9qlxYVO9TWg8ocqSjWXZJKklZpJFQ31Lp6h575zEH52I0WolDNLtx82OCm64TWu9XXkE/h8TIrNPsXkX81qdLNFNX3lDKpv2q9P7eKO5HE5BaSyNU4EExcMPKX16Q9jbICtR4RibwY4aRPt/SDGdCxjXo11n4OU5MlRYDRPaqJGO7lGwu4yOwzA9kwuD2Hy8/lc45MlpgjhD6z/9NdSN3zgLvus8ND3WiQFbKzXzflkGdYeqmFCd22YBHaPa62BQsx5RmP0RdGnxzJK+ZTVKBbEHooptI/hmhNebUtszo92vd
 K+h5IsQr
 FcQ8SHof0WJ4QLyk5Mb2IaWMbSU4eNr3MH8AuqVN/yXaZuP7UO420CJ61dXKvcFzDWygZkbr0oJr2LsazmWMEF6aHgpvaJ4G1QB7G/ERMCPsiwQCbpP5w94fsjESqGahp5FSoLgSCpeC9UTGeJ/b3kzw0+Yrb8Bq+9vhUFKDiZDg9TMrX5R91j0DzrzY2BN1wvE2J6l2/voBDOoyqqfjHdfWJwG9nIw441/ISYlScIFjG3DatYhTCSQ3vX8FVLjUU2Pd+GuOVrgJZHEwaNzw4KA8C7+COWZjLlKE1FZpeZpBNajHITLgfDTxtbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 12:59, Yitao Jiang wrote:
> Some secondary MMUs cannot safely tolerate a user VMA becoming backed
> by transparent huge pages after the range has been registered with an
> interval notifier. Drivers can observe the page-table layout change
> through invalidations, but devices without replayable faults, or ranges
> that must stay mapped,

Then you shouldn't be using MMU notifiers.

Use good old nasty page pinning. :)

-- 
Cheers,

David

