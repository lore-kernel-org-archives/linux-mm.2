Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A186C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F576B0109; Tue, 30 Jun 2026 08:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4576D6B010B; Tue, 30 Jun 2026 08:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E706B010C; Tue, 30 Jun 2026 08:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1A816B0109
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:38:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DDADA04DB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:38:36 +0000 (UTC)
X-FDA: 84936532632.06.543F901
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9C70418000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:38:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYOoUh5Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823114;
	b=RiDaKssFvsSHkLKUwBePuOSit8JaVzA7W541Bm7dGj781427xxk3xcObe9wxhzwOYkLRYP
	hua2vtJIcKPQfus6RlU8Hfb31e8NQ5mO2TjlhwHCUa8ybr0XE8Skm8QAt4imHR59m0PUFS
	LdmwCpySTRkV20Z3LKq8RlfyTBrodCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5Tibj44/m1ZvU3iIXqa2lDGGXNktBN31mDVj9AY6JE=;
	b=wA76xsrvF2mr7tcmnZfQPj2vsqKJ6NLNZpXh995Ol8eDvq2Ps8cOSvIJOkPP1b3XewZLyK
	pB7Xfi2Pnycpo9IwZWtG/dJVvzV3VNJHyBDfi8YvER0HY25Mtuuy0ui2+3GDCulJS11cRj
	pWRBybxH3LoZD64IHpRuk+WGfByMTnk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYOoUh5Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01A27600FC;
	Tue, 30 Jun 2026 12:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE451F000E9;
	Tue, 30 Jun 2026 12:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782823113;
	bh=U5Tibj44/m1ZvU3iIXqa2lDGGXNktBN31mDVj9AY6JE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IYOoUh5YM/N1Jjdq+kUBFaYBblu4vOkSncla9ZgJ0xlWkOpCpWqotDzT50YTdWDvt
	 FhvGI1FOquNOllWuZ/hzw9PAj3G2yUZ8Tf+P3WNihotlGMMKKiqkIlWesKq44sonzN
	 ceow+soxPDMXZUJNV8qBnap0fto1eoXsAhKf42CpVq16s8ovhsY6zQWyodIOkLV9yq
	 vlCgmUNEw3tVzffijLspaWHHuOFqfLUDdBa9utjBXdD0IOQSpVeG6Hgmss0tS9P9Iu
	 EdHICN+X2W81lUx5lrbVnUtstn/YkmML0X9zmCVsDgcTo+13vyrJW6+BB9Bxz9g4Ew
	 zwA6NNrNhxd2Q==
Message-ID: <5dcdd1ef-21ad-4ed0-9e8a-0e5cf96b4392@kernel.org>
Date: Tue, 30 Jun 2026 14:38:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/16] mm/page_alloc: some renames to clarify
 alloc_flags scopes
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
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-2-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-2-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C70418000A
X-Stat-Signature: nbmacp1rr83u6xu35byhkbd9scjzn83o
X-HE-Tag: 1782823114-873401
X-HE-Meta: U2FsdGVkX199UETkVGlLNEl6O39v7OMTCKNfoT5oCjAMDto8DuJ5kIULyGGwi61B325b51wPA5eFWrNedBJYnA6N8cTy61BdM5eRMgU0Cg25fqpvi16mozuJj9WQ/8+KvDdbj4Pex640qy2Yo6+ukjwhuBvkTupAhXVS8Qb7lIt7eYEXtoKpHTeKB2ONuGFxMQb+bIg1Q2VP0q43fCJFf2A5giC7ptAHeBioVAvDqnhHTT+B6TcFM/0N93oN0DQuO07Sbg7qVRcTMYYCXgvCoN85jSe1EwWkpataZymBfqzaHrL4YtGve10gQ9wSAxEYjhiNzvMf4D5IC7p5PRPXriBtStup7g1LK9cAePhAlBSwuDApiLvka7MnTPtMPpog9peOxw78Ef3wgnfBzNDrMWFkG3EqqOw3yqnxBQOKfQWudnZtIKL8phcGX7JP+DampdGyrv98BJ2UhqtMHX+xiMZx4zrXHdPnCR0p87atpWOTunA/erp80ZjPMe9lkTwXH/+2cc1RM0Hu9Wk3hThyAecC+pzU/azj6ajKe4XKoyHVon2zUw76fbtqe8d8SP/JJuB39hzd4+NCVhVD9t510i7GywHuzLvn4NGtyVrdgZJv8cG1TWW0G3jvs8+49/jm8gAwKhBJNj87SfqT3QuN0h6z0KZdeRbx71a9EGFd3TBuV3TB3+/JltnoqUnYWbK09Egky8PdwLwfSA0bscu14cqrCMZYvbrrZdUQlMjmXywZ0XptbPvxavz9WpH7pPLQore3d+t1Rm5PuWtbOYokNdhEQ4PqaC3jvRtTslND5pn6g4DP/qa/ZDbAlVif84SMi/rxeprFFHdg5/G2OnrKYgy+jpCSM5XikTjJUhQ9GCjhIp8B8DhSlHNQxfH1sPWtguTcpNZffJLPy/8VtTgldzNs2c1X/W4fbqTYJ6DdLZSxBNeXKVz8CB+UTPUQDgNV4PPlBE9DfqHTuT1quSl
 gbHUDvb8
 ZIOiiAnJ+Tkwt5ZzG9mX77GiBHDoyFR0ovZTD0nrfkX45aLfjgD+hsi9agpjJchiUBDzFkj0X6oMU+if5OSbaLAW33yMgxKt+ENe8LJnAyxv+DNvFKiou2ZfuHDFQE0lRVYXr6360n8fKAjnA693z5VmIs5Fno0azvs8vYiP56pF1c/qLli3luJR+1nDpDB4wI4FawWiyy2rBSgSRZgiWIXpCFEeUoJNt5fl4kHzslqY3Vmz5xfUapCT/1rgthF24I7miS7ZeliqZxIxjZupgwBF13RGdzfACg7MyPyw87m3GwtaELE69gyxHr0XQH5cALDEIy87wBQhTYHP5Dcwq9ukMY1//uoLum0dY7W1ZlwSvZfbVXKHMxRxqVSrzdmxjCgu5lgrW2HSE33Hj7erDrqd5D08InYHUnipjRO40pyI7+4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:11, Brendan Jackman wrote:
> It's pretty confusing that:
> 
> - The slowpath and fastpath have a totally distinct set of alloc_flags.
> 
> - gfp_to_alloc_flags() sounds generic but it only influences the
>   slowpath.
> 
> Rename some variables to highlight which alloc_flags are
> fastpath-specific. Rename gfp_to_alloc_flags() to highlight that it's
> slowpath-specific.
> 
> gfp_to_alloc_flags_cma() and gfp_to_alloc_flags_nonblocking() currently
> have perfectly harmless names, but to keep the naming consistent also
> rename those to the alloc_flags_*() pattern (which already exists for
> alloc_flags_nofragment()).

How annoying that alloc_flags_nofragment() doesn't have gfp as the first
parameter, unlike others.
Oh well, must resist too much OCD :)

Uh, more annoyingly, alloc_flags_cma() takes alloc_flags and returns
augmented alloc flags, so there's stuff like

*alloc_flags = alloc_flags_cma(gfp_mask, *alloc_flags);

Since we're unifying, it could be make to work additively like others? Then:

*alloc_flags |= alloc_flags_cma(gfp_mask);

> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Otherwise, LGTM.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


