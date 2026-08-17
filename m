Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35CBCC5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13FE46B0901; Mon, 17 Aug 2026 00:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1186B0903; Mon, 17 Aug 2026 00:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0074C6B0904; Mon, 17 Aug 2026 00:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0A4F6B0901
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:35:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 643FA80635
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:35:26 +0000 (UTC)
X-FDA: 85109497452.12.7394157
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5FD42140004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:35:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kPcj1zQl;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786941324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJFmveu5s3Kxu3Slqv/wqtGi7A6VRAXoQNbgiOZH5C0=;
	b=fZFG+swq9fXcnqVQO254C27tk/HTIR20CG6OyOJq7oiLASvMPqKUD3GB7VIjn9lEMT3TuL
	PX4q9vobCg6xDmk4buYksK56/wUXoXcdE1Ct5WPlmByeggiVlp0a19f/RjvL9NJ7E4YE0g
	aWcL+e8uu1KHsD2dKy2tO2X4i98/Kj0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kPcj1zQl;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786941324;
	b=Ge1CocVj2MQc1c1YWmspkqn6DeCO0O8IQlM+EkQOgVVVLIJ7Ebq316p0IU2pAEfDzPDkrD
	ippNBfqxB/kgpHdOI+vUEkm7vQrBjYYumyjXgR6kDiQcw9dy7K+xEKJcOyqUYbk+GCiNKl
	81cDQ9mWSyjM7Tilkwq2P1jH95Os5T8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TJFmveu5s3Kxu3Slqv/wqtGi7A6VRAXoQNbgiOZH5C0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786941322; v=1; x=1787546122;
 b=kPcj1zQlJ20imsqxTrELkYLuRunB82ZBWtl+Idm6zk4DJ2yij5DiTvjh2kHdx6B8XCHpjeQ4
 jYuI4MkdfYO2Ug7FF2lhW2HdkcbyLJoaeFPFvzfVZHlJVJogAJtVO0vuwHRyRIZ7VGJ0nsYreiQ
 oA2Tez+NZNJzE4XZ7OaApTxw=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id ffd4f95ea8158cf4;
	Mon, 17 Aug 2026 04:35:22 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: nico.pache@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into folio_pte_referenced() helper
Date: Mon, 17 Aug 2026 12:35:14 +0800
Message-Id: <20260817043514.82725-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FD42140004
X-Stat-Signature: mpzcr5afceyix17k3fci6aueb8w8sx8a
X-Rspam-User: 
X-HE-Tag: 1786941324-761957
X-HE-Meta: U2FsdGVkX1/gsaAF3pWjSkuXXSWkWSxrxe+sZmXcHnciKV6TiNmMPMe00z8qXIC8fz3jAgqrxUgNJJdW6xVyWEBWA/nBGjXq6GvI44HK8hi7ujsVRRCoxgzqlbAKOJjauwwp7eG/OSV+V3JbMEjerE84UgZp5/KODxky9uHmYk7e1djl6tNU/h8vWQBjWUoG05rU6jXoUR0sBK7cDVcI0AQz2FK3DFpFoIBYzD7K21SNhF4z4ikRa6Xd1gqA7mch4f9y6wJtbDyjK0xo2NoW8w96GhO52HBNAP/KzbwhZQcyTN+GClHB65xD1gO9g9ssJdK0GoBfjA2aCz6j1xlb6uOH0Wth8b4leGB9vPCngkSp/SbvDY0XdfXFh9rl6pKWSwt+aZKSsrVenRsryhss9t6rSSHZ5eJNWROP6aTlb/89ewi18vJHawQJqh6hsdLSRuPi7tyTH0q2QRd7K4zW1UO1SW4bcREJizZtzc0b0dV8FIT2Y+avQElrSZzDLuEJOzRMo77tJkquJ02nhYl15dXkIEsDq1ObRgGFkKCEImrJ/tMqyBbENYYPHxGHCNkxfhiMXIDECzXOVawP+Xo9sj59De6fB5Rirz+4SntgoDXiK+dHOhlaCCg8SrFpFJhvEN0ErC3xlaWgufUwxyRQNJ/LtxoHsVKwJTL64e6826kbtt9/B1UZtNZ60ytEaSmFINPJ3p/1nPMrCbH75fmm8kKLNPG8thQR6mj0lcNgaOT90pxQviAfkjhMGxWrZzYycCBceBShDjyzb6gh6Ek3bGyjuOxo987PhpLgt4Xwsx/n38TG+fr2els3xv16/IBbZJu1RrCCaEfRJeiPk9LcJFxwLa5yNYd5eaMpWV537P6w+ip9ylVLyn7JsR1r69WsUYUkvduGGnyP44hgD+xyeAalMqkUfSs0Igffd1Jnk1Mbw197ynd+e8mAqH70GB/4nhO/3OrYAFF+Pday1m7
 nBnad819
 8PY8DFweFRIA3uT2jlr7YK1LczTOlL1TbdjhCYmUj/+qjCA1iFddWjRrfqqLWs0bnEpIbOvsCWYRB1IYSSHCCJJ4AIKXIeLuNW4rqvwFrQ50kIfsCiC03hgppdyH0Vu+ZvB1JXLWrXaIuqgydrpqo5M5GBBQ92iaEe2JgXSCQW6wvnyorEiYCeAgEQDjWu+L1lAc4qkuG0sFWMF6fiTskqmuCdXh+GqEao0AO3hkwtsM7AfH8TlMAz2fIaXtxolnA6sosAcTaqO3jI6mU4gqZIbLP3myxZYghn7sMtWehK5ZSGFjRwXzSjkdt85kE4hJhn2DZRhA7cRl8ZPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 11, 2026 at 06:48:34AM -0600, Nico Pache (Red Hat) wrote:
>This change deduplicates the "is this PTE/folio referenced enough to be
>considered for a collapse" condition that was repeated in both
>__collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
>a single inline helper function.
>
>Also move the comment and use it as the function header. While we are at
>it, updated the comment to clarify that a young pte is a recently accessed
>one.
>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

