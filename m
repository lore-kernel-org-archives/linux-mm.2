Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03EF5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87DC6B00B4; Fri,  3 Jul 2026 05:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A026B00B5; Fri,  3 Jul 2026 05:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28046B00B6; Fri,  3 Jul 2026 05:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96DF16B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:28:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07E79140471
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:28:56 +0000 (UTC)
X-FDA: 84946941072.29.B7F12B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 416FB140006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:28:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fC+DqggP;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783070934;
	b=RZBQZ2q8BzVEGuc64/aMryEKG2f0hZB7/DQ+t1odfBmYROW0NaoEP5Xj9NbZjyJef5hx1b
	LrNvPVerwxWKfaZxFBJ6wG4F3Lu409Ygi7sfbgsbwK0lTsyqJOonoqB4J9xKSam9ROsFgW
	VHear92qxhwu7I8ib/dkP5ne2kbqtwE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783070934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fR9SVKhicKO6uOCweG37siFF+B0al9faavWkILv7i6c=;
	b=DS6RsKmxsJ1ho+tEJL+xRsgL+SHxod8aMQOsGvZwoZSHGkMPE5aORPyW5ILFEBOfy0MudA
	5evEinwo/8g1GiJuL4V6hgV/tOtahPRzdcNvy1DSz5kdXtX2yalvLsucoI99RRtEyJdRXG
	xjuw/mJ0JnEb0SC5QFn8QU0jXF8cENw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fC+DqggP;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20D8B434E3;
	Fri,  3 Jul 2026 09:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF901F000E9;
	Fri,  3 Jul 2026 09:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783070933;
	bh=fR9SVKhicKO6uOCweG37siFF+B0al9faavWkILv7i6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fC+DqggPqakY98S+ZVt8XqSZElYAWuYnwf1/YeJoKgWL6aJlYmUOYiyvbNBPi+Pob
	 k5BGt/VQ2AMgWw4cTYXok4YECENGTqhq/OMd0yjGYDFphvFr5KF4V9daMiaWqS3dwJ
	 yUx7cskZ7eeMts2Q5xjtB0L9VLeK0TH3rGqKXqDCTooRT0xVE5kBfVTOkwRDbEQv+Y
	 bynRDp3eUzdkYMwn69vVYJtrkqzQ3GxQyFwURotoQuy6Shk6iU+ceir1e1/3st6P0D
	 4wZ+W88ja3j35imZ/Z74BtZwiuVjBZ8tz3jBirLKSELFUl4IXnyd6D8R9ChGGe29QH
	 Hx5HtSwozoIuw==
Message-ID: <76741b2e-5ca9-4983-b748-e0047e5e9436@kernel.org>
Date: Fri, 3 Jul 2026 11:28:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/18] mm/page_alloc: drop alloc_flags arg from
 alloc_flags_cma()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>
References: <20260702-alloc-trylock-v4-0-0af8ff387e80@google.com>
 <20260702-alloc-trylock-v4-17-0af8ff387e80@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260702-alloc-trylock-v4-17-0af8ff387e80@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: o4w3yr3nwg31figiak5k19n8dkqs5ip1
X-Rspamd-Queue-Id: 416FB140006
X-HE-Tag: 1783070934-261782
X-HE-Meta: U2FsdGVkX1/Q1Kd3W5GroTByQjqemEwh7B2CjVFfxmV9RXzfW7c8MGxqzyBJ5cE9XflBjOBWnWxs1Uaq2+n1IpHJ0ME5W6/1OgZCRU7OowehBdOKj9wjQlVV0Wi7BTn8LfZIMT73NvPhJ/u5sWLRjdDVHrKamiIbExqARFy3irRya3vPo+SUq4XKQ5jmoLSRVfkXlOm6IKi+a+AOBUo+ITlmseSP+qKVuJfXvkd7bp7I+MBLLOYS35zslNbjRBQ8l89oJB1dOXaAV6z2L2AWb2R9vfWKb/zVHW2Uxw4QUOOwx0sXLO75ANJ8wZJ8y8Sa6Ey4nUzJaxHNlKCTTR8FCnUAlFiHtm2IsxJeu5zLA4l1Y5XF2a9PxkqrjNpwgVXeJa0h3GJ63vyVoQyI5ZpXkucPitUEoT2OX5cO7At+rkz4EqZYoXLZJiZUL4QGSF0SGUuwAS4wajgT5LK4BkI0RDfMdhR7VOFY/JdKjLViIt0eNQGl4UudFKL6Fr0OHBCLKP/192AahZe/4nTt2/5S7tG5GETUt09s8WuR9XY5yiZp8ECeYEoR46JpOtaovNXdaNGM38WJacT1el1V50FEtyCY5bzNPPGptxA4ErCArZmQVoPgDh7HW6p7XUDPAD/olvu3VyYZLVygLLd1HR76f3DRYY/bX0U5Mnd3aBzABZtCnsKzaEk48i/iiDDUr4+QpV1dYwLMuc6KGZK8B7FJq12jg1IAvbAWi3rEYEt4ZUotBD9eQzprHC4jodB1zsfYBBeHMuhgWmnXdMaJPXHpTE3Vo99KZCPVuSKe3wFVCmTyyOBYOwalzNl1PimETzsJ9F+furh0F21mW+sBvAuYWln7mgvHtLEvBVoytZGc5NbkOqO78AsKAOLdSNwF1lrbou/2Y/c+1nFo/NYzZkEvXvSC3f2Y20M4u2fZYojFTuaQwosHkLK8x8/wTVcsZQsyjtZUTbqFj7KICBDAPtK
 LXv3Kx/R
 HIZ2fpw1WTmLPNqxSDULIF/AK+hyDpAFkOwCUksTSsx0Rp2+FiFwyXuTe9pt7n6ABOAsMxGQEpiH1vE1Ahjef1n+a/Ag1rXUvuxT35/guqeC3CQeUoDLwAmmEjIGVUdqwhcBOuokbF/vVA6Wp8YTab+dMcgWKG0Vs2maj44z3yfX6UJ+n2Hh8/XGK1XgqdL6WDrCOKc7OCXOqs4W5/COiYGQ5DMLTJ/FHs3GcJQYWHzjvXq5vBYKTutCAcTTag6eDXp03GN2OXLL+fglH6gAUbG7/5BrYbiCo4Iy6Vjz1B5NFWkd13DGXPibv4LajrBevh3bZGSsD/TCcSRGrmchjoQRvyY/8zRjAQA5yRoVLrIyEzjSsZEZSkkEkjAtByoggrdbDzeXKzkUDNm5zDF+PBdjkhcMlOG/ij3oABzZH6hBgRec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 11:49, Brendan Jackman wrote:
> To align the style with other alloc_flags_*() functions, drop this
> additive argument and just have the callers do that themselves.
> 
> Note you can't always freely or alloc_flags like these callers do
> (because of the WMARK bits that encode an enum) but this is fine for
> ALLOC_CMA, just like it's fine for e.g. ALLOC_NON_BLOCK returned by
> alloc_flags_nonblocking() and or'd by its caller.
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/5dcdd1ef-21ad-4ed0-9e8a-0e5cf96b4392@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


