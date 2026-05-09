Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006AFCD37AF
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6386B02D2; Fri,  8 May 2026 20:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86F96B02D3; Fri,  8 May 2026 20:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9CF56B02D4; Fri,  8 May 2026 20:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBC436B02D2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:44:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CC241C10BB
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:44:28 +0000 (UTC)
X-FDA: 84746035416.09.410313C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C68F41C0004
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:44:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PuEMf6At;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778287466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0S3YUlF6U85lNBknchVNmTD4iYnfMev6Cy4lkPljxM=;
	b=DZzFasJcVz8GO2OawZvDUywDhZ/D1cQnbLMtzslzO2wRdsaLk5Eu9GIS3P6ckLI+jWGRM3
	iO8WTm2GgPnvl+O/1UWCEIbu4iYEwBPsrBhV6N/zht6m4NhNWD3txM3e1Euz8fRuvNGD6m
	/oqlEJU2DkYZAEzzgr8sFEuWklhsQ7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778287466; a=rsa-sha256;
	cv=none;
	b=SmUszzVBwn9VH3PpuO0rn9ai+xX3McBo0NbvA7JFdJLCFDXGKdsHVOdmdCD/ozfLbgIf88
	+o6VvF3/wIx8DB9nGYjBN9ua9SOqLeenVm+sw5bvhr/Iebs5jcS7zVzlKm9w8RXX8mKhds
	TntVWdskC8r2Gmtbv/NX4F54de5AeSw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PuEMf6At;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89F0F44311;
	Sat,  9 May 2026 00:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036EBC2BCB0;
	Sat,  9 May 2026 00:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778287465;
	bh=NR/CaPbgl/jD4rfo3od8KQ9d3FEAg90PeAHOB5wRLrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuEMf6AtI8QzRcfsbo3mHuGbkjmz/DTjUH1aEAZD5VVpL1IfphrET8f0zOxDbL4nE
	 JFAmCHO9wrYLr3lTTgPBx9KXNlYZnr08aJZIbZIYhIZa140islwBn3iwKlG9vMIp9q
	 fRlDOrrQ//APYsT9YhwnlryJOz+4FYcyWRHX/ddFQXx+bPgia1FVtGCFRpsppWd+jv
	 R/WdLJqukKwcGDGOG4lYw1fIkf/ppQaeWF+5w0S34vRJsnckN6EPFKvKeg1g9kMUql
	 jtLa9gXNQlKdhhYdXby8PyoVvwwZsQywIMfX1ArTGl8CxbUiYyz357lszu7Banc8g4
	 7qVtz+2sfzyZQ==
From: SeongJae Park <sj@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] mm/page_owner: add NUMA node filter with nodelist support
Date: Fri,  8 May 2026 17:44:16 -0700
Message-ID: <20260509004417.84229-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260507064643.179187-3-zhen.ni@easystack.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C68F41C0004
X-Stat-Signature: p571rspnigmu4569xtom7ap9tsjjj11d
X-Rspam-User: 
X-HE-Tag: 1778287466-435240
X-HE-Meta: U2FsdGVkX19cyw06JTbivBaPM/A3MHLrcky9ROEwORY6OcP1nEq76La8+nio4AkVZ30UPNQoaQu4keGnwwV2TgHt98DiKZ1w4LHaJeEgCA5ijFmwypaBT53Bh7mLrdBQ3vJ5OM7Ognh7OR6NDjB9Sn5jniIf1xTwA0XEjBVi0+qdLyqZQ54QvVJZSPrKLKpaUHSTWnTtpxO8Kmzbwnojq8DNPJWYA5rmbN8gLrt8ph0D0UBzA0vo/FLsoNJunkbQxd5B/i1NRjfc8fLcps/QxR7yQKWdCqJ/BXlSeoJ6PiW4LoWf1ehddKEfbU16dJZGlgvUQeAepd4OH3KTPS9k9U19vb9S1GwbeZzIh0yQVUdukrkzjYAbW5nzr8J5j3a+Dtfy7INGvjqzPTXmhxEaSsdY2Jfm0DrKr1xcNTnUp7Hgv8OiW7CWjEfC7eqIR/aYDKfHX9mFusaqcHtaIaWOf1AXKwkY0aD7bb7hVj6EBwWEvd/sl0IQBfhc50P5lrnVTuT18avYwIKevqanFAtK/vz9XcOn43A2EYzxZzoqeQF5I/RViBmKfdJqt2qZoIu3NS5LNTdrtBKzdUnRKBRKZ9BpfstGH9AOkTiH8X0CnrYqsuZ3gw2TDinZNVVLTCa2FQIQAhD96h0ky/Aia8YJUBvbjMimau4WYBOOdK6Udive3yxZEQ1bRy00TZ9GFITkTVXSjpGnz+Z1uvGBQcp6l1oSZ3eSCg5Lk48sUZ6M+bUjKBUusxXaJXe0RUr32Rs/+3c4JhxzkyfSxTQcYOaT8jseyfHr7RIgYxyTmNyq96GdaRtQbTlWFe7WTw/ljF+h7NpDFG6ihOHc/ThXoNsLWgy0GNGWznj56nfpyW7ZMVb0tSZjJPonbBAROtuBuhosfBjw/mj7AgvKvkwKFV9QX1xn29tEUKEvzop1TKB53lK0KFReJ3xE9U5ABG1SK9b4G4k8fsp+qm4tPmJghij
 EyL40BP3
 WQobtHGuajHIlsEld0JhunEZCfluw4JjZEM2EbVzQcAqBFLN1/RJvqNyYUFEeEviQ3grGkL/USl9HDGZnyyA8xn10LcqR4YWNofx60PgoXVmj2FhfIHgnDbBDBaJ8f0VVerLTR1wwc10XPL97rEJpsA83nGAQ1LYrD9i6/31Km3EC6VBHW3x7i/e1ToMwSzQhebud946nKN5TLKytxL2scctq1WQAT97BcInm/w/Hd9Pnbl//KaMgo8TMRkErVf8nSNT0h9TqZlh8Fq593iQB59T7L2EMhNUGvabjLlN4n3YOpleJ5cfhfJ3DNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  7 May 2026 14:46:42 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add NUMA node filtering functionality to page_owner to allow filtering
> pages by specific NUMA node(s). This is useful for NUMA-aware memory
> allocation analysis and debugging.
> 
> The filter supports flexible nodelist input formats:
> - Single node: echo "0" > nid
> - Multiple nodes: echo "0,2,3" > nid
> - Node range: echo "0-3" > nid
> - Mixed format: echo "0,2-4,7" > nid
> - Clear filter: echo > nid (empty string)
> 
> The implementation uses nodemask_t for efficient multi-node filtering
> and nodelist_parse() for flexible input parsing. Empty input clears
> the filter.
> 
> Note: Access to nid_mask uses plain load/store without locking because
> nodemask_t is too large (128 bytes) for READ_ONCE/WRITE_ONCE. This is
> safe for debug use: low-frequency changes and torn reads would only
> cause temporary inconsistency in debug output.
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
> 
> Changes in v5:
> - Optimize nodes_empty() check in page iteration loop
> - Add __data_racy qualifier to nid_mask field

Adding links to previous revisions [1] would be helpful.

> ---
>  mm/page_owner.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
[...]
> @@ -700,6 +707,9 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
>  		pfn++;
>  
> +	mask = owner_filter.nid_mask;
> +	bool filter_by_nid = !nodes_empty(mask);
> +

Shouldn't we separate variable declarations and statements inside a same block?

[...]
> +static ssize_t nid_filter_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	nodemask_t mask;
> +	int ret;
> +
> +	/*
> +	 * Limit input size to handle worst-case nodelist (all nodes).
> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES

What is the 100 bytes overhead?

> +	 */
> +	if (count > (100 + 6 * MAX_NUMNODES))
> +		return -EINVAL;
> +
> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;

Would it make sense to use kmalloc_objs()?

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

