Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71A2C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8BC56B0096; Tue, 18 Aug 2026 23:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62946B0098; Tue, 18 Aug 2026 23:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F086B0099; Tue, 18 Aug 2026 23:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7316B0096
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:03:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35854803F5
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:03:00 +0000 (UTC)
X-FDA: 85116522120.12.ABDB53E
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	by imf23.hostedemail.com (Postfix) with ESMTP id 48246140006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:02:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DtKIy20N;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787108578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbEPc2Yny4QkZNn/OaySZ9eHHjMZyZ3itROegWg/+mU=;
	b=BRolqoaucIvZoKm5ez9zzYApmATLVq7x5c1JK4uYoD6WucL1BpbcrZtIXv67r45yaEiYY6
	MHqbYQcGyNwDxmmlttPzsIu6wwzBQ9ztXxWm+S86U9OlxTAfjcvNzHzF8T67IA+rtOHG7C
	ck1GofbqPstjzd8nDJqopB9bF9g96/U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DtKIy20N;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787108578;
	b=WEQSzfnk3Z3UWQjZ6EcP0hg+uqnbhnwUg5Ed4bVSHhQ2Cv9VjpknbcLO6gyL1u5Hz9wF6k
	bpvkwp3RexGXt2cIe5BAuUEZL19PrLgCdD6FcPSI8XOqBo+NZO3PZuec0hbLj0w8T9m7Z2
	qVaIg6wr9c9VqgMlDsxZLnaw8+mw020=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IRZQaGjJQtn0dDu7VssqvMPb2YwnLqTZZKLH7W11Xyk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787108577; v=1; x=1787713377;
 b=DtKIy20NuesmRtb0pNmaNhQx/15KOSQK/Gmd0Rae5f+wEs57e2dkmF9e4gOZrm+8StED2wc4
 RsvfiGg2bdtglp3dut6Y6nrf2CAHQd/lhMdgpvrequ0XFqxzmqm5JGyynuyBHxJQua8LEXd/SoV
 N14+PewkyOGEolGdOHFfNcQ4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 3a28c889ab346ce6;
	Wed, 19 Aug 2026 03:02:56 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: baohua@kernel.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	ziy@nvidia.com,
	hughd@google.com,
	ackerleytng@google.com,
	usama.arif@linux.dev,
	joannelkoong@gmail.com,
	hannes@cmpxchg.org
Subject: Re: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
Date: Wed, 19 Aug 2026 11:02:49 +0800
Message-Id: <20260819030249.96570-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260818225904.55236-1-baohua@kernel.org>
References: <20260818225904.55236-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kb974xk3qt117z4aijbkdumosahmpuor
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 48246140006
X-HE-Tag: 1787108578-78338
X-HE-Meta: U2FsdGVkX1/zgDdx19+T9N1SEx3hHzfj63leK9ttogB+/JS+SKCFxwb4CNQ3++Ni2hFuyWocWGAVJNtBQ/hJdZT53T/mDUP8PBfvdzQPqvwvmLKFHAty42u7QkFuHbTP+sJOTpDfDM3W6uinIrXl7KfRMSqd/K6RKzyRKr4ObSmR4BXhqozlWYubDl3CCMSttVHYpX1dFMtoJ7OQV93ioSPd1hYWqGLg2VIozFDj4lL8ktYrR+ulvhuegP9zhXj1DSuD5bIYdcn52z4mFsHVU7490dT/KhuEsKdHyFymtpJQF7BwOr51JMmbnYoY8rc0mHyR0lnT+85PlB84/FsWHPi6HdAVUcsLkYNJ7rq7HFzeGL6Qx66QVbK0vws4imHGFo4qKGxUw8xCzZzey3YcFGBVO5eU4ow7vhjB8T6uBBDNOxaeRBOGBGDaP/dN/65BThy+J8WvZwQdJt7zn2EljD4U7lHNAyKxuV1w+H6j+AFZ8+EOAAbFYntb/5FKBzL3hJpcHtctR5S5YuzY9HqNBLJq7qjVeVCbW1LPQ/SJ2QW2kce/2RpUnqEBBKYjm/+ngZNa+3umfQPZcBQdINAN6ECjx9AVJAUlK8BfcOM25RYoGQa+ehpRBZTEbb1TCQATxL7Ug9m8B8v6xBwaakrfrqmFrKOoD0+kl784HYZ/MA6niHO94lUOHLJBLQF0vkteSt4lp+i3sq4JTS3FeD6+DG05+PBV6AZTFiC6wICedoU82bSxBFe2WoOZ69TcSudao5wjiNMHBYSHTOjrf1HlYNDNRb4oG3x8t4hUisVa044J0Lg+0tz2ADcbitn3vG0T4aCggVQQUuci56fVGzmx8DrrP53YXjsQO6uf4u/b+6rOxQUyWhsgHxaYQe/N8tb5YwAIyXpF+cMioAs0pbfqeqZTsFLl9OFm4L77mPNk7ZNHAZ8WlFKUhbSI7Ze4z4ju8okmdijvvepKKPCbHBI
 e84MdkmO
 WAPBBJLGfWliaKSm4ptyjEsnYjwTf+BCxpWEmzr7jrM9r6+8RmgLcjzfxPzsaFOv8GH4+GCd+lcD5Gh+wFQUhW7B92POCeFyQSjezsyFSQE7Vl1RZ3F9MZJSHs6a6x0cIWQqKDBGALXe4qRlh21HYWRGWrOkY5zc1xsnxRE1nhenD6IjCg9C4mcy371foJ1OdR6507q23cdNj9ynVWzFubukcGNfdeoJIGQYEJaFKfXvypO3tf3dT/YcbHmuQf9XYLPbdkN+DV0qJ8xe06VpDw+4Bp5jMnfGoaeDD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Aug 19, 2026 at 06:59:00AM +0800, Barry Song (Xiaomi) wrote:
[...]
>
>-RFC v3:
>  * Rather than hard-coding `< COSTLY_ORDER` to enable the lru_cache,
>    allow the lru_cache for larger orders as long as the folio contains
>    fewer than `FOLIO_BATCH_LRU` pages. Also limit the total number of

Tiny typo ... should FOLIO_BATCH_LRU be FOLIO_BATCH_SIZE here?

