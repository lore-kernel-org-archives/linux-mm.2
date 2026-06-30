Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07766C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FD96B00C9; Tue, 30 Jun 2026 09:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29A06B00CB; Tue, 30 Jun 2026 09:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2746B00CC; Tue, 30 Jun 2026 09:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 841996B00C9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 167331404DD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:54:39 +0000 (UTC)
X-FDA: 84936724278.18.00627E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3FC8E1C0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:54:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uc47acV/";
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782827677;
	b=zJblWn3NCfafgaAYYK+1zDlfQU1Qa0ZVwKro0bi+J5UKfHjxI7zswmgWP3RIdS/qyEWctV
	ZtR0WQ9m/6JD949Delc+QN4+GFJe1Yzgju4HOJbka8LJjdOwREKiJ2RuNk/E8X1RqN6OQc
	FVJsXghPi7vHh55LtKdSBkHacgGWw28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782827677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nm+W9EoXezR//SP4FATVT/5q+9xiiLfN2WUuIgEUB5g=;
	b=KUDJbbgNeG85AyOvZL/fsOcdbCE2EasbzyTg8K1b6I/r83Yey9Gk2GV8wtrS7YK06opZzf
	AFZDQFrG0zGk5IbxPrtox+Hk/OUp+XjLZJTB0CxA8Uhp+bsrLl4Z/yNARF/mnZFy+DpNpH
	LOO9gUY1y+COyK3eBw9EHCr7myObjuU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uc47acV/";
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FD25407D3;
	Tue, 30 Jun 2026 13:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D915E1F00A3A;
	Tue, 30 Jun 2026 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782827676;
	bh=Nm+W9EoXezR//SP4FATVT/5q+9xiiLfN2WUuIgEUB5g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Uc47acV/DYzY8Gf/6XIZaaeIF5gEdCzeI7i6SwuLhpKiqrrT6QAklYPn/KFk42Yu+
	 ZXeTCgiCoELxb77VUsfFE4OZUH1BvpA+oQWKXnt0Y/0I33kcfLbgoHSn4Kgl9FEdn6
	 96DXwkGGqpjAWzTZv969LoemrJ7V7VslxwUvPfipStRhk5UHYjQn7X6+bCwwVr+ctP
	 8doP/4v2JMbhEGimExoIbxld7jKm528j0iZBwJwWnXwwReenSlsKDwaSKWIwBtqfoe
	 NStwReTplomIOmtMcWuXbv/YFhF+XWJlqRD/Ec1PthmbX+yu5VL3mGXdh8hV2gUnpS
	 3xMegB38jyy7g==
Message-ID: <50ade287-dd07-441e-aef5-523fffd2cd35@kernel.org>
Date: Tue, 30 Jun 2026 15:54:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/16] mm: Split out internal page_alloc.h
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
 <20260629-alloc-trylock-v3-4-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-4-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3FC8E1C0009
X-Stat-Signature: w8oyuqha79wqcdqg6ro3166k79njuk7b
X-HE-Tag: 1782827677-289275
X-HE-Meta: U2FsdGVkX1++sludBzn1b7VTgkGwExK27oB9Q8ZRcZPmm1KsDa9YME1qxBLMsRSUcJ2D92jnh+kKEZJtDRHPEaYAUh+aEcA0q8EVbFuWtTUfEdoyKYPwMwu2xsrCunNCscT2FSxT16s8ilgtpzVva/vaetxhHj6byGYYfK08FqkKKy6RotcSN3jwFc42mi5W5HzxecjrL6HlkNTkj/jpOhbVD6cunVExj3/4FBCDClADOerzazGMfD8ISC4TxhXSq/eEkasuiPvygQ4CPRTVaQMFVro5igpc//d5RGIBZhDF3HBUmBilRppbAinZU636Mnaud5WheiFTEUI8ZjeCGIBI8LJw8Uj57XL8fefi4B0vDPWhl+aieag9kDdWOgx4d1i0kWaXHpWoiMKGQpK32GWW/J1zk1xf0cFfN2Ygo+pt446wfLAVxEOgB0m36InJv6Y+C89xqwTHc1VrkltEbixH+pJgUEIfTJUp7Q6sRDtuRXmo8D4zZMyX3mwe9aPK5wIn7hLi77s45tkGdCfwviX+9H+jazlvH4hkb6x17HNHs3nH2UdSo5xWqeiH5d5m3QAemYWI/PxdmY3pR1NPzldjZ9zvUon2sIvHGXYPvPdSRYmZvWN4hQOCQPbPenFb0Z1FiyJ1YJxNMLEltbd9Tiv6LKcrcPvw/5phUaedlw3Tuu7/aQKCPpBSJZ3SW5Rqd2I/kscb1hI7ebRu1tQ8FHu8Dqpz0KxQGbx5Cqbb27VPKwAXBcsC0ppLKlor/E2Xb8kVsWXGcQNUMlPCa72hyZURMqoPSZ9PwfKFeAxs4aqKWGzdfW0NNibcGKx1PKQ2Lu6ZkoywueFmgaHoLJ85yldE5pJnsOgoQo2aQkMfweaexuPKSCA1xlIZGMNPNJMY76aPmKrFQF+J6XFjFyTlJySqkeqLrVJWvy1T+TJkmHWVyE62lTF8yyzncrAto+35NCsNiOAR+Mfu7VbuY7q
 sXcEr4JD
 ms+9xGaNWK85+BcgMXZF8eN/OzClpyT6QdyDA4KIEMNiM4qwJYXh07IlNNuUW26meppKiI3GXU9iBtBls3sC0L3vHLlFSRqVY8F8nZmGKiz4zHlbEKhI2EiSvwbOUWmaOEKbvVEQ/RFe5/ZleJQoPReWVMTn9jKiEHAwV5xb9s6Pxk3QM/A3xdbWEF3oIx+KiVNdj/e8/1CzR0JjgWMTnQwgwiAf5MZAQ75Y8pnWIBNBfV+Kwms9ExM+J034qjPd7pYp/LIaWbZMpvLyYUnj3TNdoU6Ijf8Fp3J/JY8ct9pM8pJ7N9V9QdPzxTRJCvOgTZOwIHIAvb2wSM1C5nIKODt/+lsK3FzdMPAOqioo9uEQL2O9PpARlZf304hyutH5oZq2+bUrz2iesbCO6dz+FXVvfuHJTd2hkYQP6vlXLuTrTNwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:11, Brendan Jackman wrote:
> internal.h is a bit bloated, seems like time for a page_alloc.h.
> 
> Where it wasn't obvious, the heuristic for deciding what goes into this
> new header was "does it support/correspond to a definition in
> mm/page_alloc.c?"
> 
> Only need to include it from 15 .c files out of 164 so this does seem
> like a genuine reduction in scopes, which is nice. And there's no
> circular internal.h<->page_alloc.h dependency, so it seems worthwhile to
> split this up before that inevitably emerges!
> 
> Suggested-by: "David Hildenbrand (Arm)" <david@kernel.org>
> Link: https://lore.kernel.org/all/41e92bab-6882-401a-8de9-154adbdcfb36@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Cool.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


