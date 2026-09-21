Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9466C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AE16B00D9; Mon, 21 Sep 2026 02:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911AD6B00DB; Mon, 21 Sep 2026 02:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E686B00DD; Mon, 21 Sep 2026 02:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9696B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:02:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70D6BA63FF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:02:47 +0000 (UTC)
X-FDA: 85236725574.10.7FA609C
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5CB458000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:02:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EWhPzXWv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789970565;
	b=4cCjCYfcSXWcbO2l7UvM+SuvkIBlYrGbZ750mJI1p2Jsu8/HZBENgZfvVAEBHYUzHy/v36
	XFwx6A6FShWXpStNpLeuRQ7uUZrV5/DrU+QBmlNlDVJy5Ha7bbJYgzP4rM38X5hvV+/L6p
	7oTnXRB+TGR77/NTcqEIcRmSon23xg8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EWhPzXWv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789970565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKorgmJZ/hNPXKbpIqBxQQxb0y5na8M7PnGaVplvaP0=;
	b=TQXHSFAsF4VJ5soNXwKCXdQtEBHubRybDecNvnlDqn/rAlYkiL++WkNWATSdc9KQPGFSsM
	2vSWvg9ZxHl8kjWxIHUq3fgc0XTMDCuKJWJBC10fYEUboFt1gN2UsJwFyA9onpywc1enGJ
	X4CAk+8dHDQHvy2CQ7cRjK5H9OQprCc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PfaHpE1ReZ1v+qkpOG99rma3BnJ5b9o8YklSIsQbmDI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789970564; v=1; x=1790575364;
 b=EWhPzXWvUVnLorbPKvbRGme95f8+50nf2qubpgK5CbqYcyKGyE3YFPrmtKn0clGq2EMRImKM
 HXyIoNFmFrjnHzUJP44fa75CjaajYYxPX7Ep4hsxIV9Bs6cqgA0YVou2eeNgKqBfDhT/tJHPQXl
 eHEPZxWxLZYNp9tbjr2vKCcE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8c663889e002f29c;
	Mon, 21 Sep 2026 06:02:43 +0000
X-Mizu-Trace-ID: 8c663889e002f29c
X-Migadu-Flow: FLOW_OUT
Message-ID: <58fee197-7baa-4507-948e-13b58bc3c6fa@linux.dev>
Date: Mon, 21 Sep 2026 14:02:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/17] mm/zsmalloc: replace PG_private with pointer
 comparison
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Alistair Popple <apopple@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Michal Hocko <mhocko@suse.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-1-bb68b6a21869@nvidia.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-1-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CB458000A
X-Stat-Signature: cj3g1q196d9wqqg98mjwpzcrbakkdtf7
X-HE-Tag: 1789970565-703818
X-HE-Meta: U2FsdGVkX1+Fo7LiUocSQKnCCxqeaigfiOnzKJvOWbZg8H9L/MN76u0iVoIX8iJ3M6M4ZSgWF7xWg8FwOerdts5gZl8U4rjNugKdLvsgtsqgASOpNnKlSrzBpNhx0cSDBiuB8TL7rf9qg6pJM7yTUQirZyGgVis+i+aRLRmw1qx2C5APMImzpNbbzdgskr4YRd1C0R+pBUDT1O3+jXnIKI0bvZM32rFwv/5yXm8I684wVJJG835ewHZiAy/Dw4nZOMdd40PtRLviqiAzLybiRRUVJi6eqL7ssFZe8riuEMnAE9k3vKUduC995AF14wI9v5DDmsLxrOsJMRZroOkUssUojr8lmdXq84kBRxbgZjW/HodRQ5RFSHQVY6KqmE5CefQUYdk+ZrxDCNqTlLf6+k2ZfY8yq5sN8cmiPNxHOYFpDBKaY8xPhFo/4i/Nsja101GANnmVkugYKVOb2aDtBMxdlGvVyV6i4gJQvdFzIdSQeEX1eMcrG714cQXxpf3N1ABT0nemDk7QUZiP06V0F4WQ/UuPRbcueYxlM4PzReJ9LgXsvUIysXZO/CC79tzj9CS+C/oifzQZCRAQ5ERgH81gSRbpaGQgtMgr63+G6uR1EQhR+If8aJSg4E5Ut3n+tPKyxZtD4dIwq2eEpAIHbN02xkq7ANv5wk3rpYffZB2DPrwqyr+48PzVo8yUNkA0FiRLnhQAJA5cyLMPPSP2Lne7dpVjjugUN9wr7L+5GQBqqfT3WpBomiaadDnC3VJo+y6ATsoUDTmnFMdU3QDOGNHfzJ04JFN9xUDsby0jvvaM9zqCAKlBXJdejSf1HFGs1I9Bvu29+SWmbTrLazjnLrFWQZIn/3LruC4R6R8T2B1XZLy8ZMeKM4gS9RZ3L6pfcaLLEs1lNyGytIvTwTYBsM7iALo6AOnbJGbradIRIzVWsH43P6rItLuKHccYaJLGA09P4ZV3CPaVvsdicPv
 SLI2yqRe
 pWJ0eSXn2QNmdQ8Q5DjS+yNQthe8uf/tfmtT9vze6YfVbjUQtdKZgezwNkjsGmq7j8V3N0mq06e+DeQVKlCrRaRbLkjkc+jiLJGxGQpvPwbBnmwWV0Hj8X4OC+aOqzac4jvPiiZtY1G05Xd3tq998KeRS1dtcYVGGN6DlBWHzPqyuuDWjEyOvo3Z//nqdTPhX2B5kE/jX4XV6ehKnuZ7jAZxTgUGWnLG/HollbU3+1vdT8zVci/0/fb+xtciSb2sRca1aOPaMiFvN0aTF5UZlZu8CsLD/nxLAqMcVhg6fQEfb/x2JMKY4IOrPe24amKzmMiw7+TgxyIukyyQ4xe0+5uoa5C+LlQfDZDvdiXfnm63vx9F9PYmyzwprNEFTiOvSyBcMK5FdOmhZ+q5FrHGECvmMgTMNLgMm6zDtjXe9YlCKF6NO8pDP9NiOi8WmkKVzRAj48kRphiW4l5UABXoQQmf9LU8JJ0yF8szfsGPWH53CQvh8P+qSczVDc33mUx01EHFogqlJDOsNZlqv1kXrfAqSu3GbN2Nnwi/H09q6Ysc73XtIIIEtcV14pp8EaBmIJkZX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:27, Zi Yan wrote:
> zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It is
> equivalent to check zpdesc == zspage->first_zpdesc. Replace
> is_first_zpdesc() with zpdesc == zspage->first_zpdesc in obj_allocated().
> 
> For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
> replace is_first_zpdesc() with first_zpdesc->zspage == zspage, the second
> requirement of a zspage chain, where all zpdescs point to the same zspage.
> 
> is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impact
> should be negligible. While at it, change VM_BUG_ON() to
> VM_WARN_ON_ONCE_PAGE().
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Minchan Kim <minchan@kernel.org>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Nice work! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

