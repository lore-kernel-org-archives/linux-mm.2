Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359F4C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2B16B0098; Fri, 18 Sep 2026 17:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A25D6B009B; Fri, 18 Sep 2026 17:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3964C6B0098; Fri, 18 Sep 2026 17:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10D1C6B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:03:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 788F6407F5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:03:36 +0000 (UTC)
X-FDA: 85228109232.17.7AA81CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id AEB3580002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:03:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KQLxbJdk;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789765414;
	b=MXGCUAZGC+nT9HXLiVydnyoIKscVhcAAgWC4SxX3Ppa6RhhSnOnixZXSUxX8M4g3UGEE/7
	mFJAFAOzu6f1HbxG+dqEL2vy9g+Fyo33FKf2S8CrcyyZOXYPvpTXpCeDQsPj3fPIxQKdHC
	U8nzTUcCuulQ9z/dbW05e4dogWdLUXI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KQLxbJdk;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789765414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdHsBxrNLtvJ4/FdhkNZ5zwsyc2gh/05XB3PW7TByTU=;
	b=5jhcs51cq47NWPcORRHZ4+TvkYe+VWQnqvjlFWF2L95fdCM4s7kvD4IMgCJ7KIj7pRzwB+
	I6bEX7iiSYr1wNrvuTTF20v/GszDxO3XH2cFwcVrBE54Ncq+1xmTQ9HXdbNsw2b2sq3Foy
	SPo596xhX6ftc1KD24QD8dBVXkPGYik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA2F2433DD;
	Fri, 18 Sep 2026 21:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA2A1F00898;
	Fri, 18 Sep 2026 21:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765413;
	bh=tdHsBxrNLtvJ4/FdhkNZ5zwsyc2gh/05XB3PW7TByTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KQLxbJdkOsTJvYJI0BJre5tEn9Oto0apusUJUleZ+V810Rg/ogqiV0RZe+tL/myou
	 5WrrtWljCXr70qAKFnw2aTCM5RojrLlAfvdlse+8t+YKjPoskj9++/OUkn2tdsmo4e
	 RCU/WjeH3G5+HX4oIh3Znh0GTvYAxOCmKSkztly+4oDNLz7fPAGSMml3gqlaBIEJ85
	 /+x7CMyur1ROk7ZqUlDWwIZOwnZO6UnGcmywiUXVY4uxYy/rrWH7UwrNvUARnzRPnl
	 UKA7vQfrOy8/QH5Yf68z1c6xj7fXwdrbHGiqUD+JARCCn6ZpDPKVfRgNhrqGca4J1N
	 0oeut+71+2VSA==
Message-ID: <873091d6-52a0-45b0-9dc1-12e9528297e2@kernel.org>
Date: Fri, 18 Sep 2026 23:03:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/17] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-15-39878b37dfb0@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260915-swap-thp-cleanup-v5-15-39878b37dfb0@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AEB3580002
X-Stat-Signature: bjdzan94mocb3dayyjhgzaf7kx3ffaps
X-HE-Tag: 1789765414-177135
X-HE-Meta: U2FsdGVkX192OrETCRMLe19tVNyF+GurJJMKJTzfjziT0J3mJsBZ9CSmhGz2tpXkXmFupVolKP4ThfruSveizhCn/fE5wBIWlarTRNiUmtoDSuqJdkOpPtuQobZFqSMvpVFmOir7POMPdik6YVRdONfgNB6Wjl73R+INMPyyCX78wm3fgTxP6k7hHtIjgpq41/Ld0PWs0M0+zQ6DqHu1X8X0J+n9edl2+t2F2zaVe14EWGVknxa2+7sUuFGaVGnsWcJf4NB8m5GRnNFucQ6C/7A9CtVmsnbPrkR8EantsRcMjrEZe13G2v1sCR1/UsACZ+1OepaCD0NHe5fkKfWDaCUhI6pRuueeiJNIbjVUK0DFJoaOnbWBk8Lmq4PAPMNCo915ZMRDz4+N6iz/SUlMsDh6tCFsrx8Rwn1sxXfzl3MIZDXGgiCH4yTlIjm+fVcpvGiCGrXuq+ylP/wtOfPuBix4lUc1lM+EBDib3qzkMNXo0Gfk7L3mPdwzwUbGVAFDfB5DVEEOqclXv+6CTONoQR1ogzMlxcfZlVe/x9j+lnVNOZoYjjcYgQEUm1d8RAhWSgFoC0j1ygitq54IS/+678/ghR0xSZNMly8TzU7r6EoUxC78w3MkYCoz/DS+SnnA2f6hJBlQ6aNgUSoajq9MfxK8439cIEgYl3uMK5TSW92mwT0R3+lv+TkCB5+Rrv9+JiftX/9LmUxDC7jCru5NLS7Nfv4wKQ8vt+YpzK1R/8+IVb88o1/LUWZuNjR+5KmL4UrUtnw8qy3oRmvzMhKvjGyHdzT4cTqG36VTVoBEQjWnOnVwjGokqIg2qbZ+4rYEFoXbPXnxiSSTWviJu2W6VvFgXES8ge5lDC/HJV7dxft/jXJtXOnbwzNl4ANe2W1QBxD7ArWTdnjnNQI1itZ5lnuIQmzH+MGorBAxiyVUfXVZOi6WUq9rwNiZzo+xRUnRK9QXDAU21fXdpG3oL9O
 pARwnYUi
 NXzHGtXFHbb2aq8mEPYDPdxUL+U/3nMOYEz3PZaCqEcNP8QcwTarxtrP89OJ+6isvRcJfCR7YCSd/OCeJG6zepp2eYbRjpAEOra+wpkp3tU+DavMxeau2DfM+BODcx/rrx49jYs2/zktFCnSwQu1HNiKwgV2nsLs5MhtMF5qo5UtHdUbFSdyVh+9ky0At8yq2j6dIrFx/NV5shOla8r9uVZYgcMkr0m6jAnQzwVIub98FI9npGN12jF5mHCShp0G719zCDM6skSxb8iBTpiAzEr+bsp1NgOKZNIWZHPtIqt5ogD5PXxoGfM48NL/++W2mWRSq3fPqIxK2vvSIpBT3xEec4b609mm122rIFcs6D6b22Nx5n7f7wzRIqH/5X1dIyUQcjQ7zJzWbYCE7guTpFzdxMVQubPj05xiUYJyZKoyUX5CXW9krpSDCR5zAZAtDICl0Hdq5Y6QqOZ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 19:14, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
> and folio_put() in the after-split loop.  free_folio_and_swap_cache()
> must trylock it again and re-check folio_mapped() before freeing the
> swap cache entries. If the trylock loses a race, the entries are left
> behind even though the folio reference is dropped.
> 
> The sub folios are still locked here, so just directly call
> folio_free_swap() under the lock if it's unmapped, then unlock and
> drop the reference.  This makes the swap cache freeing deterministic
> and the reference drop explicit.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

