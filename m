Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1871ACDB470
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 12:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68DE6B0088; Mon, 22 Jun 2026 08:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19736B008A; Mon, 22 Jun 2026 08:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C084E6B008C; Mon, 22 Jun 2026 08:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 993446B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:24:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F574A0114
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:24:47 +0000 (UTC)
X-FDA: 84907467414.26.D51EE32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 420F240005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:24:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jJqz/iPS";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782131085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFypkvBwJZwDBhHfwy/l7OfaSCVuJTkfYKSjY5iX7II=;
	b=3kHOi7khsosLHWzZrQ2UweEO77rPcc/Q8u6W+CqkB/EIHLes2kAoAjuet0Y4mAn17dZve9
	T4LRLZARNKqxqjlziSZ9R2uPFRPgS5ewaI/t+V2c4aJm+K6KkJpb5pQO/wutEcFoh5jqFJ
	Ekv0fIwGvaoWCGTMUuudxzjLkMBmXWY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jJqz/iPS";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782131085;
	b=puasQZcpvBcsIpSjfvfHvzMX5VchK18jl9FJn21RZMLuDIeWbnUUumtnq69xG0gr4EAScN
	KgZCmKIGyRoZYJulIcQ7GKtq7eNL8+fqiJbfRYMtST8esDixViWjEYAl+i5crs/6MPxT3a
	COIjJjlRmUkc0lrx1/7OWxFtEek54B4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5397F40C58;
	Mon, 22 Jun 2026 12:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170001F000E9;
	Mon, 22 Jun 2026 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782131084;
	bh=lFypkvBwJZwDBhHfwy/l7OfaSCVuJTkfYKSjY5iX7II=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jJqz/iPS4bf2mgAELDQSbYK32ngD0/Hpv+g7XjXagYQxn4E8vQc10D/GPMNIkRq9h
	 L8HdcEk9eaUCWxxuUDXp4/4i9ARkYTAIuuokOjnNYdqPRXpg9a8CXLB4zNNki2mASM
	 6ss0w2lhdv1pF+RPwQuNPg9fOVUHw6vQfapDZh/kpZK1Lk2zTAsEndkAlVWuWee2oP
	 /sA1uzh7wF73AX33A4+vrLdRGRb6/OMSYGmczfJjyJDtsRDGlHffiqvjoQlWA9B5q/
	 8ZTktaOh9Zr4HtQK4g4h/op88r84CrfSwgZyC9a3eKCTqXjoFQRNEcRpHYnIC+YuqO
	 SKGcgqhNW+8xg==
Message-ID: <41e92bab-6882-401a-8de9-154adbdcfb36@kernel.org>
Date: Mon, 22 Jun 2026 14:24:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] mm: Move __alloc_pages() to mm/internal.h
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
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
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-12-31f31367d420@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260622-alloc-trylock-v2-12-31f31367d420@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 420F240005
X-Rspam-User: 
X-Stat-Signature: eoccse1scksasaxf4u4yijcy1pp1k3k3
X-HE-Tag: 1782131085-617907
X-HE-Meta: U2FsdGVkX186v7rzCvGlI6T62D6T+WJaLYa+WIJIB2WLfOeTonrARpG0hycsUpJrYbESZcVDGygxcxNccbzsBNmmJCjeUfohvIvvYucbCD4Lw+ojkhkoDsOhZUjuLW0whFkGh/V25borMMPz6wvnyAYPsFNFm4Paelrkn4bUpFIo5txJnatDwEOMjCpqjZLIfwgTj3ugex58dS9nOnyeUe6un2/L1niwzApfUTOZHNbkxD4RfFzElHrJXpZPQNwnZZgDSV1sTOlEyptEdy+3CorYMcEjAjW4lWWgi6CGfCv4ZBfslPyn+mpkQRVkWZiJTy1jbcxR3tT3lkUbBLfqkIoevWH4n7H2oFWInz2YiUKIGB/mT0kyaTV9vUvotb85+gvRdHT/34/CKmw3sQcuynCQpo5OA4AG7hxZrlYW1GS0QJs44+LK2//Pwp0/lR9zhpezsMlI9ju6ufK27yttWGeSYD0O1ba5LtGfBFriTrVlhw+JSyRfgJlrIC2rsBXcKU42rDZ3bSRt24ZjJ3vOxUfsYaGpBNBYrrutwqiKR+0UR9enJb+UvAsXbWtmRC9EX71Nrd7TliYYzsbwYHdYcfI7dG/bUbqBx8Fu88em9PigvJDrJuxzDpZxvizUQUFgZD+nq3q8YYZcZyTcmhm2BTztNOM8Ahg1YjWfzo7bW3lLCgO6vAX3a9QufZyEulnCDodXyq2Xv3R4eYeWKDf8G2OJA4DXuF67v1siP6bHPbF1qPqqIRgn2rpNlJnYwQXk3w735RWCkEc9PNyROJ9U1HAC4zMISNNcAZuo5IQNPNX7g5u7AeVQNd1vlTCHoAas/J7nTJmS3JzoesmNvNjDnOqRP+3x9+S0yOeTyOOc2MngOy5jiFhJGSSWRrXh+uqhiG/tkDD1uRjg/jFe6Jd98agsycANc+tFA+N8ttmr9bNftpqYKsJUIEDjtzsPLlyd6UdQ06XVNF77avWldli
 ocI4Z5ks
 oUi+0A6WgiUYRNIu1dW4LKXit5+BLg7sLxZNh57rvJhMkLQ2BXiIK3wDiHu1jFVijLLBOQjDiqtf5ZA02qsaPAy77CGxRV9hwvXTGaCU3ZSyWKryUJzyWQUiGHXRmFLWAyqqqTsMzDIVVtNxG09IbmRHkXpGRdMH4ahg6vQQGch7tqVkIojpy+011afJGaXDJEfAyoyjw1u7WJ0Lgs6HI2RVuowQVeCiITGE9ry4zwNYscKu1f97U6WAOeK3mBz2q/D3eNGkiICWg459Nys4OAtXmzTatf1tjkpsziIQmihZVhWnpBPQWRtgzpQ6LptyD7ioTfGcInWSkk+XsgL2Em7BOMKFrtf0gdvyPuEJVieslhgkajBil1lMPof+Vlosbp4M00mI/C/lBA/WWJGQ3Mk9/1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 12:01, Brendan Jackman wrote:
> It's no longer used outside of mm/.
> 
> Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
> this also means moving the definition of alloc_pages_node_noprof into
> the .c file.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
>  Documentation/admin-guide/mm/transhuge.rst      |  2 +-
>  include/linux/gfp.h                             | 16 +---------------
>  mm/internal.h                                   |  4 ++++
>  mm/page_alloc.c                                 | 11 +++++++++++
>  5 files changed, 18 insertions(+), 17 deletions(-)

Do we want some mm/page_alloc.h , to start splitting up mm/internal.h

-- 
Cheers,

David

