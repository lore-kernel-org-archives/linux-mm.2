Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374ACCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DCB98E0003; Thu, 23 Oct 2025 07:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864C08E000A; Thu, 23 Oct 2025 07:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705928E0014; Thu, 23 Oct 2025 07:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7E48E0012
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:10:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15A9713C0C7
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:10:34 +0000 (UTC)
X-FDA: 84029110788.06.EC5019A
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2663840004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:10:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=nmWmhWK2;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf17.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761217832; a=rsa-sha256;
	cv=none;
	b=do/kmrAu25Ok0MuFzevfYz4LyIXH68zLoSdpL/ljHzpPS3Dq0YIMTFnNpUcpF2EeqWUFXO
	wfddh+aTWG28vPM/BgdKrfNEHKmasGg20z9m34KzYqjK/XMSDcdndhsrmM8jApM9bbPdVz
	7yH4WDB/9GiyD5dr485MU2y14vMBuMQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=nmWmhWK2;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf17.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761217832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYodpbyQD8BgZF0WGadbX6rC3JbxgU0ZmWtjqSGv5Aw=;
	b=NbXvTVTcGawkY7DHgS3r/cjt57P9df2OMK99OMvgm4uXn2Zv2lPyHiyzMu16f49ile6b5j
	P1MPFtP3YQO46MW0NeD+9/pfJJ1qkEnFVivLwt8nvxLl9+ZMl5Y6VJxkWnWkpKsOp5Kiiu
	rfmQvDtoQqL5ZShJ/mBcprzBKtAiuuY=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4csjxb4yYzz9tPF;
	Thu, 23 Oct 2025 13:10:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1761217827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lYodpbyQD8BgZF0WGadbX6rC3JbxgU0ZmWtjqSGv5Aw=;
	b=nmWmhWK2I7Z6FVqbm3fmwSHWLaFv7Q1u8sKzHlojkBMqYpkvX0RIn6dB5ditpNeSnS3ZoM
	JezUagEeVhbKHlsh5wcSq/3Wm+4XTcjnyG7BsrSYPKmWe2nEqTY8AbYFrgVB1pni+zuZuR
	hVq26wI2hDJ2rtRurszzfgCxbJsWoFVOyzWorIyxf8RX3TKshZm4NmmHzKbMvirhWJlQ8X
	IzwL1nXSJCYMHuqm1Iyw7NSgYQAKU7cZtGs3AeiN/x/E5N6xSVyhH9zsKXrZiVGqI3ghuO
	0Z0VKsUxWS9qnzV2sieVZt5w/ZwcgKG6cjkVmwnvjePhq4IQpi9Ua3Rtr7rY0A==
Message-ID: <d0362c9d-67f9-4ea5-a5c1-792f960da70b@pankajraghav.com>
Date: Thu, 23 Oct 2025 13:10:16 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
To: Zi Yan <ziy@nvidia.com>, linmiaohe@huawei.com, david@redhat.com,
 jane.chu@oracle.com
Cc: akpm@linux-foundation.org, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20251023030521.473097-1-ziy@nvidia.com>
Content-Language: en-US
From: Pankaj Raghav <kernel@pankajraghav.com>
In-Reply-To: <20251023030521.473097-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w4wyyby5cozji3uf5o46nnxfhqb3z5bg
X-Rspamd-Queue-Id: 2663840004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761217831-656659
X-HE-Meta: U2FsdGVkX18Uwm5ESKFPtrfKetg68GWP6pAb41ttw3KJDNnux5/U//QCOo57VgrdmkUndhvObrAanMyOIJmNLCvCq5g9HJSSoBtIqdRYiGVUrpRVnMyywOeQ8RvDRwQdG8y1SH9sd9m5ngSOKFcHvUZ9gN8/8sMOtZZZFGhZaiEPNH0FG7FRarpLUpzayo71+yFu2fz10kbzudHhQqWNuL/CsjU1QFR9lNbioYiPumgzCcbhmM/IDjF6ymSA+t6zaKgPnytgIC2RgmNeG4WdLdQUGJlWsYpnvx1gmxmex6jP1hfTMqwlpHO0Xh6yATheHiluBhIg5b5nYMM6SjuoS0iBHc4nlvtELFEsMcHfLVdAphYJgp4LgBQhhUUfL9ek87bXk41Eor/dV8AoLMXtvZKFWF1LopPSFBKLX7Mnj4uANdUZWbULBxgfF326Qv3I/bBXOoy1FVnZJmutAggd2Dz0U9eOZV0sEiYxLZxY/s0EFOKzwm7texzZZRUjf/CF4iLwSuw8mUu2DVKskO/95O8bjtbAb+rUlUgUIg3Jnj4tYmDJ77yAiKMdLP19PaB45Y7LR8IWZZRye8Y1Qv2QqfJ/EvyPDPHWAb6GjLNIvMFY3EnitJR7HKMFcuT7Mx9DOfpDGNA389mZ76owUYmjACJG+KNcNI8I1NllvDwJOTnH3PK5KuU4HVHrpsfOjd8eg+S4jxb7XpglHHH6wWZxDTA7beToyY7t0cmeGrSTXjXOIYlxnHmYp8QjHjB8d1BFvxvh1HDsQ/jZzyAzzJ8ggZN0+npokee9kqtZjWq4VioT95PHisX5k+9x2VztKCGK9SOtKELiALzz5hw2wKJGLz7YPFkFAI5lWj7qPVUyxwLgScL7nf9nQH5pGrUpJQP5sGp3Ur4jdzIslVxmMGcETvBIXMzw7ZVokWN1jMhvwuUoU11/xBZg6TiZR2aDCv8TjJOvEmbpoHvFr9wAtx3
 dKTJzHHw
 SvTq0Whg5BRbrmi2RYqW6f4V9t9R4Fekou/54TbXujUr7+1e/HsdeqfuHUFacqikFsI5IQc+gB1cuFGsxDQpyPazLisTV8bqWSWKuPjd2+QES76Z3JQ+Lbv6GzH8SayxnHUhHjUBjGhOXeGmbVc32U0qSfhEM63an7LvwbTUTc01D5Y9jP11EbI2D5Zwuk7OJEDj1axsueGWhvT+WDX/2XlZz9QyCXYaJYXcSQGXUFp1KE2RRwEn3/v9KMwaE4bhtPVPA/6Tkeg3yjCYnYdQCUov7UBpPZYS+5sIEgP7copRt0hguTklokWovTdBv2saXc2GNz7SdtA6W9USnXwHPRRQ/ot5LNcwwRQzTKKdAfbx6jR5UEvmuV1aTL4o4lWdM9p0izGnup6NT201Z6bal1YNDOeFFSaqJ92tzHA5AxcDjS9s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/23/25 05:05, Zi Yan wrote:
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio is
> split to >0 order folios. Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
> 
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact. To remove false positive, caller
> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
> do the scan. That might be causing a hassle for current and future callers
> and more costly than doing the scan in the split code. More details are
> discussed in [1].
> 
> This issue can be exposed via:
> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;

Is it easy to add a selftest in split_huge_page_test for this scenario?

> 2. truncating part of a has_hwpoisoned folio in
>    truncate_inode_partial_folio().
> 
--
Pankaj

