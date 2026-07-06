Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08279C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C736B00D9; Mon,  6 Jul 2026 04:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64986B00DA; Mon,  6 Jul 2026 04:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C296B00E8; Mon,  6 Jul 2026 04:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF5396B00D9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:30:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DB091A033A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:30:15 +0000 (UTC)
X-FDA: 84957679590.30.E8B6A42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B71180009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:30:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b7itPN13;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783326613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTrFljYyS5OE6S83wALD0aUeKqDQTwui0J9q9JOrQDM=;
	b=Xh5bnVMzHUGKKPyKQ0y3AO5A3HgY5m0/H9KCu6SkdGhcvykpiLI5Jvv6poV7priY8RlCrD
	5LlgXxOqrHHXyHGCAACk7YjZT9vak3g6OOlgnsjCHrScCzhbETeEEj+lwS6Gj//hKM6r36
	FijL9foIYep6WX0ly6db3jFW3G++s+Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b7itPN13;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783326613;
	b=SQ8AL0ZK4Nf1wpwNewDXnLxTPDxZc++NXttKlmE2dGg2fVkeqw9J9tgrTsHzN5YSM+djyn
	/NrflOhVgxRNvzEe9ISji82pEmfWYt3qf32yavi0kZ4lgWB5vhdxEgkzBVKRnNRfgWtCFw
	xWe46wBspizahcQshJGg8WOIHe235nQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ADD740D9A;
	Mon,  6 Jul 2026 08:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB481F000E9;
	Mon,  6 Jul 2026 08:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783326612;
	bh=QTrFljYyS5OE6S83wALD0aUeKqDQTwui0J9q9JOrQDM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b7itPN13bHPYs2WHzMteDdnLa9pncmnsWUtxUIle5nUPe0MkX2B3rT3kJEW3BzkWk
	 EFfqJL6sJ1KrahF0b2AkeQl7ANsApNln8Bm5NQqGrXh0q0hTFE9iv8R937bl4OEOeb
	 Q3j+IggZRJSwgZZRWlEiQDf64TcGYOZYJmqOHCnwkvtyQUFAsjY7SWvY3KR3/3Hlgj
	 h7qh++CUSTMfVXkuCiTnUllWNPPGhpXHuMZtdkAga8rRYrW9MBfpsI324TRSHkbTM+
	 FjiH83PsvBx1aWxwwjXrFKdlECQKaqo4+FAIiUuxi0YR5nqENYn+ov/m9b4FGl2fqC
	 FIk3FYEmAT5YQ==
Message-ID: <60d4dd28-1976-4f7c-ae64-15c2ac042602@kernel.org>
Date: Mon, 6 Jul 2026 10:30:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3mu5sxbtze78qomr1m8xqsfextgg9upq
X-Rspamd-Queue-Id: 5B71180009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783326613-853226
X-HE-Meta: U2FsdGVkX18T/8NxunPELP2pZJfX9E4ON7nP5FqTGxzqk3Yh3VuV9KPoVdk6J/8rsTtM0d+Zvwzs0hLGuhx6w7dxo7/qpDgz/qahSYFJEqKWrs+M3CptuIfdSELuEy2NfWdsaPXA0dWOh9XughmyEs5i/wfaR8RchvCsSXxC7tSDLSoVxjrVpRx1latprs9so5MzKhPiWvtYDmBChf0ndEI9QckPwLR2k/uI3UmpID9TRgI9cFCtWL4cQ5W0PPFllOXz4jyemnYNiyIBD6UDO2JEk7aZmS4Jlk5ClpwqxQRH8iZBgwTnQnT/k67Ne9NvGHfJXe1aiRdnlz2dlpd7Jpnr0LQBKpdY30WI3BMz2JPIJ6yd7udsOtldfh5OYFjaTc6/QijGQOHsjT809RNGtNFtW5/u2gBUu9RCg6G9XXtpPl3Qvb9pVIFT/NFcmkPzSbLR49aQXYu1rpR0ALkG55m3quxidDwNbIxds6Ttpktx6CisI/9l4WRMt+2qIp1HX76YEhswppS6zGs5Rj4KVJSoKjSR9BlvX7GOv46P5CNG4AiqVOG5SOl81iW8OxfApeizfkZSQN8wQd8O58NNFlVl3aNYGMlrfj7wBg2ZDDVLWXu5M/bgNHWCoTBaUQ4/V+tp52li0cEo2DE+LDXXNnhMEv8hnXr1d3mxpJmc/uZ8egHC/WyD0bpxeVEcuyZ7yecm0VrUmbix2CKJZvyyRilzZ5RP/wOPgYlm38es1qA/fzDEPnmhaQD3h8is5dyzaer0dl9GR8BJPQ25XDnlRW0X63X79Pyi/DBr8Kgum+x2e9gyuBtwiMvMmHUCKKKK1uePWwPiAD/XI7y4a++XdimudfzXVVJ1ykW6+LrfEZfl3HMzQO86tBbNLfnZHJOUYPCPsC8+Cau7Ev1r+oZg5ErzjKiu2cGof0lAHMDo7aPNy2TfDNXw5TOh1be43UTIgGEAbXi1b0YeMHYbAIZ
 xdm3Yhxj
 +jHZDsD47keVdGyWGeJUlJDhbSiVF4TgOpylzlGsXNdnZf5ii3x73ddyqo+CS2TTFoqoiWX2Q/w+7MkdZ5v1TKjHriZWLFb1rIs0f/J8eAY4GqypFaj1lQ/o3EKCc0KaSYINL/qceiTbLu0YYCudMs3F0RlIA0ZiUgWl8KHr5KDOmPZglcHBOJPxhbpTf1WwzY+AxYVB1xJVL/f46B2s5GTK7HO43bdPJvLRcvE+uS7DzlgZxGTGK9TyaxMFfS7wzECYO7in4D/BHMEIoL3i30AHURfOQJo6mEcdQ6g2lHmp9rX53CHZ3khqeo4hjSzqhYOcjnQ9+GwmSsQkDfe2+HZ2CGrzKqMb12ove
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 15:47, Zi Yan wrote:
> page->private should not be set in tail pages. Commit 4265d67e405a
> ("mm/migrate_device: add THP splitting during migration") removed it
> without a proper reason[1]. Add it back.
> 
> Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

