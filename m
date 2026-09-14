Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39365C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5006B0095; Mon, 14 Sep 2026 09:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BEA6B0096; Mon, 14 Sep 2026 09:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392636B0098; Mon, 14 Sep 2026 09:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 205B36B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:12:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB8B6160127
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:12:38 +0000 (UTC)
X-FDA: 85212407196.17.1639680
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F4113140007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:12:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U9l6uz2y;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZfwqBdvOFpQKew+Hh4SK3LM5/rd4AbqHnwLPn0HUtE=;
	b=tNno3VW9+oZrpNvkxhnekfldMGUsPj3aMeSOC2WJpveusX/+Div9XaAUY4qMUci5K9QTrS
	d1j3Q7/DDKWjS41/stMqAtxqiQWMIQ+LlOVmi2aMGBWIWmzbny8PRVwOFEWyF1UfzxPXcU
	AjUCd2ZitVP3DeoOQOl/fxEUhhBtGlM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U9l6uz2y;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391557;
	b=mbJtLzslB4syj2fVUtRIPrsruYLE2tywbm74NKsrU0E+8MztsVgtzn5dN/L67cgby676/D
	1Hi9LmedscJKOBwevfXAeDNJISDDUrXSK2OUYqxvlPgJT6PadsDMmBJdoj4gLLscmbDfEA
	YHJySmzx94ULHhAAGwYpwinGESn5Ihg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C97E60120;
	Mon, 14 Sep 2026 13:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F2B1F00893;
	Mon, 14 Sep 2026 13:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391556;
	bh=vZfwqBdvOFpQKew+Hh4SK3LM5/rd4AbqHnwLPn0HUtE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U9l6uz2yNakdSuy2bAOFywFnasaDqMo7M7iuS2ZuOFlmA7iXFxZ3HQOrSDdiCiPmS
	 DwfZn50H/wewrGGL7Z2bzprqHQj+l27pinMzT1CPgCbQ4CnjLVRLyKYaYjcHn0v7Ok
	 WkfIne7vSOcevZKRNXci5De3LGHv8skOXI9AKZK6BZYlDejlluJryTC/AJT0d3GuNS
	 c3RCMXn7lhFrx9IznJ6g21XHECoccaF0X411VpnLhGBngMvbMr8ai+VYSxVCMXaLk7
	 XbFTA0jSaYqGWo1xJv18F6NdQl03lqWARNJAaIT5H9k4QwvtTS+bFtrma20VRVWdwT
	 1iv6xlzBULprg==
Message-ID: <7efaff54-3f19-4c0c-a8c9-fcbacb1aa4e2@kernel.org>
Date: Mon, 14 Sep 2026 15:12:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] md: Use folio_alloc_buffers()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-raid@vger.kernel.org, linux-mm@kvack.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-1-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914041830.2072626-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F4113140007
X-Stat-Signature: 7ay8qzdyxdzac7d47bbbnst1qmogrwru
X-Rspam-User: 
X-HE-Tag: 1789391556-947456
X-HE-Meta: U2FsdGVkX189W0ENum/V8JeWGI3z2/eUQC22oz8cidkhV9wkjElz2tUp3mrRlECHTTd3BbT7puc06m5JQ8BC5sEYZb4e4+xscjQKErEH5u7qPqGJSi1ckZVT3Z7R64+6mIWwJYggI1xIyOZTx5MOQyyuZqwfLibLJW7HwOhObB8tmtHixpHvw8QFBMn6v/YJX2qmAdJgP9e1fSYe371qf5NMNc7Eh4pYGa+yNh8qkCgE2KeD1OLmNUzw2S4AuPJqQvv8KN78vGIdkH9MnYMst6PcpTExpLDpGZVhPmPSLO9eWsDcC+tci34pP3c737HWDt9UgBDBHCJEKMatc2KFGKyyjudzLXbVrZ0mXMJwxhwBzafKUA+tRB09kSyGjRbcemsoIKLJVdUUa3uAWpYuovQ54ItLtmpnRKinFheQp9/XbjsI+SDXBRpp5gPU7jt0qUa1B9kmVn9SzXSGRndP7tbkpCEOVM7UT0gpaGGrhBdsj6ZL9Zuvq97lJXstM4vddHdo2GZEqphADqmsziMPKaAELJ/NBF3VqoquuVv5WzlbDjHy9eBqklJE704Jssz78qDxjTMysNPyHrWIeRWp/5CGW4sE8DN8S75AR+lZdGtCcCvjULrce60My0Ed6MJMtkxZ8+RflM6a4aQopaEv3hcL5LvYMPIoFPTVWLPwrRO7jRg45RIki5x6nRJd4J2BGViYgYbwxZNJVN362lJIjozW+2w9QlEOm7C6W8KTwa8+Q9lzwincwRyMIRbgj8uZk5n6E64pD+RTPSap+p6YnK1+6wVLLw015glrG7uXsZDoh4MRoaKCvEi7nQToU3UzhpbaWs3cc9Xzd7oX20jz/WUxGV7Y6z7iY4ZLQfzBPgqCRLznjpeyoOKWaNlGkBRbrwV0RQE5Y5FDVsaHZyh6UC7Er24AO2lN2C1BrAfHXejt4GpiHUO5Lmkd2xOgGKECA54pExBNt0Lqtml7Bfk
 94qWXxJK
 XxdifdhBUh9/U+ejtvGldOtf11+uJh4DL93DhzqSBRDE2UMdcIJkYJjahiqBDP8VGhSKvo8KqcPH6GhUjFB85yG8uJEiH9KxPgLmwPPPnxc+gq5tnHJKjrbGvYgmJVPLprYKBmWUDDJgJkDTrzDp7XOsRZ96+635QoOVw2Jj80l1DQ0OOE/1aWMCGwCSrR7PghhOpmGpZIBDnpUQ8JGavw/r6H8U1flbNIZHoVeN4XTeuyneAUY2BGv6xcElEQkCqSTCy7XW0rBUntDcWp6iXPiI9l2UoajnlLv3L6Zp2Wh496v6E2Z1O5qEgVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 06:18, Matthew Wilcox (Oracle) wrote:
> Remove the last user of alloc_page_buffers().  This isn't _great_,

You should tell us "why" this isn't great.

Because we're allocating folios although these things are not actually folios? I
can only speculate :)

Code itself looks good.


-- 
Cheers,

David

