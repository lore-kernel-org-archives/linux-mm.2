Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44B5C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955636B00C7; Mon, 21 Sep 2026 05:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D0B6B00EF; Mon, 21 Sep 2026 05:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE126B00F0; Mon, 21 Sep 2026 05:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5EF6B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:23:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A3A3C05BF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:28 +0000 (UTC)
X-FDA: 85237231296.24.AA31839
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5FFB1C0009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CX1Khkoi;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmGQbTYQrBc/wMBY86PtsPV5M/jnYRJ0YBwYEZ5LaXQ=;
	b=svk0uKobIyeXDVP86zANxp4m861RZiS6OLj32eUIdHwVso6VqbnivF3ciR4PuF2QIcucUF
	Euo+OswP5KnZ12k+vPDW0Jd8j0cX88Ad99JRs9k/lVhapulpUl5o5hhHORIurPaciO0ovt
	fkwUMeHYx7RVQHAhwRQHcXAAGeAj5JU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982606;
	b=tqXg4kH2+55oBhtJdzgrzkOaHQvkYwIjAJ1MzXLK//CChbiA949ZUgYz6TVEMY2P0Asqlv
	QuRWIhKXdhjyNcQQ6Mf2EYxWkRiq3Te/XE2PcMQptIIToCrW92M2F3Y2JPWehjPZX+wVSp
	ZHdeAosyFIgyQRf1Wev4aalQj3y7Es4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CX1Khkoi;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADECA409DB;
	Mon, 21 Sep 2026 09:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8491F000FF;
	Mon, 21 Sep 2026 09:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982605;
	bh=vmGQbTYQrBc/wMBY86PtsPV5M/jnYRJ0YBwYEZ5LaXQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CX1KhkoiqhnlpTPXYdMrjxS5M9/ndA3/lhBfjA7kaRJXiN1aoHswaXBkWmHHO/ybd
	 iOsPNTwYuYjIlwcRzIccay1o0Pohlx5xtthp8Q310yiPgOow+9x5CQHXrJ1+/6a34S
	 jZ/x/PWJi0SL0MY6Ok2nR9Mbg3SNZBNfh+/zHu4KM9SiyDHbpaVxlqv5TUu7Pcv22Y
	 9brd8q4OPVNZp6mnJSnRurQLLOTEXlLj1d4BLqd2QK791VTihKjcJwSxXe13j3UJag
	 sJQkv9CjIb6LIMaYVBYaCi6gUBRPlJDVxzBl0ADDERnCLmXge8wtI+MeB0Ckd8Q2q9
	 AMmrT5QFaaRqQ==
Message-ID: <7c942b90-7fba-4a3f-9701-41501cead240@kernel.org>
Date: Mon, 21 Sep 2026 11:23:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/17] md: Use folio_alloc_buffers()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-13-bb68b6a21869@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260920-remove-pg_private-v5-13-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ipqxn95upsgpit7ibxa4faoxmwzihp7c
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FFB1C0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789982606-399992
X-HE-Meta: U2FsdGVkX1/rKaa3MnNy7OuHhD/D7uUtVCVA8MlqA0clcACNyi3fvLZxgmcNvFZIP+hJzJ/y/x3r0gBcyxQ0t1OqN0jlX2F9V6ft4oekPYTdsKwmsMFdj6VFOubiArCifSxI072JjYmjXVIn29A1ADDn1otzC4OQKyqTT6i3a3DF2jzilp5sluoulSaBmG7ZX8xdf2DA7PdCNS37EahttjXDNqaeqdhYLXS7YEzEsEw+jsJnZuxckzhMU4ypC0RD5oZDWMy/NgvYnKf1nTfKMP/zQUris8w1txVx0J7FqPSZH/M0IkyqzgZTcK/esSPX73xTHmTYIaVOIE2n+yiOmJh/SOXxIg30pLMhs6rXAnroj3r2+pcqbY98kn4dPAJs69zHWCEBlkzeEgYD5BPvrXKkd5C49T/RlC/L+PXPmR3m4d20hYoIhdElhqgi9iu/J7dpbul6mBRm+zanCNbP9sZ9opS9IB2+v/5ulBsLJQKjJQBOYRnnlZ47qxLPe9llhuMCIXqFjqzA3PJHKue463eigRK8QY8g/IUyNmpy3lDysNnRQeIvwgNHSOmWnEBzbAPTwtvMiFSJ2ZZUtN5nVdQaliR1/jKBc7q/wBzsH30z6nJyJRrg91jkPgE95hK/7slV/FxmYYOCBkJlxKPh2a2sPFjxQ3yHrvmGZXvX0fYMljOzZUtuWtj183HMBcSb8KEv6liFKctw4p4bbFVWg/4hsnSBcHdk9A64aAQxOcQF0FPflbQzfd+j3th680OpOfaZCDqsbTaRdp//bUe006yNLE/yjT8Ja2GLE2Us0iZZ56jRPcXt0IexoIBAIcX4i8B4OMRWqTJoOlnRbBseTu3s4sor6czFnTth57CLSmkOXo+zW/DGJxiep4pMpHOmNS/9dZh4HpjwwuP8dKUWDnZnUjfRmTRsOAeG3bLxF7gx06pO+Qse8PXdcN7Nl/L07ExYJtbphj9uWJ05wtl
 JT4kg3++
 rKACGb8wOqvipgGlO+WHbZ+TfDFH6/u08ca8kkRKuosMC/jbtRRV6a4FHLWUOf3rkjOn+L3tDQdxcCC/9Mznl/FBo7C1nv83MBqtXWOymv/fysJoijqY9FLYEhPQAQ4NIQANK7+an4otuzzpzp6APnlXY61W/vK26sWuXkisb6mzeCjWBe1n6zbQxZ9MbYf/RNYSpTaDe22iQNyYYA/hVbUaZGY/A+kFdXK9Yhp3cM49nkVhza8103VNQ2Lq/vUKZjdyHQPQe3B+mUV9x0oLhJQJ6gCSwJNdpq4N70GxwpqR2ncBSaVUmEAYMpX9TikvL1WqDawzA1vmc7TnqhE4s7nvMq02s7b0dx9XGdUIzeCj/r3d46eDdK3HqWKcaR2iT9/jggvQKEtnW+FVqSlvk4PT2n1IqjNxCe41y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 04:28, Zi Yan wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Remove the last user of alloc_page_buffers(). Use folio_alloc_buffers()
> instead, since alloc_page_buffers() is a wrap over it. Although
> the pages used in md-bitmap are not folios, as they are not mapped
> into userspace nor enter the page cache, but they still have buffer heads
> attached. Cleaning up the code to not use buffer heads is future work.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> [reworded the commit message]
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

