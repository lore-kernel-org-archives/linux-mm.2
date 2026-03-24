Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 420A2FEC118
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 20:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33AFF6B0005; Tue, 24 Mar 2026 16:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC7D6B0088; Tue, 24 Mar 2026 16:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DACF6B008A; Tue, 24 Mar 2026 16:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3D66B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:56:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F50EB931B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:56:51 +0000 (UTC)
X-FDA: 84582165822.04.2CA65AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C25D2100007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:56:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f6Poctri;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774385809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEM1kwWQ+mF9wiFGAPSZEFY5LYihg214naVwgduLaRc=;
	b=3dztz5I8FWH1fS85b4UTHvWeDxFwJxmloQO7v9+2jFBPOTYDOqpJxso6GBHJZ64Q+/hWnT
	AZjy1VXFzJacJfZB+JXaqERSI7NIGQXDG832nqm7cjyA1xjdm6l1eHseuH6Mv9q543QYLD
	OOfDyJowLpOQzhUP2kP7znOBQ1RdD+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774385809; a=rsa-sha256;
	cv=none;
	b=b7UdZdYdQulWSa1B5ia9G792BSrExWg1RxVG4tfM+/4BtGtEavYZ5H+Mp8coofQb5n2ij1
	cypsHVkKxFdSrFSKF7HrB5hVSwAdK5Ah/Ns6FCpopwkO5KHG7CePczMOABI3oHi5d53ZCm
	HxxlnYZDpk/M1xYUsRl+Rf8UUZOcIJU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f6Poctri;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1571260120;
	Tue, 24 Mar 2026 20:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E48C2BC9E;
	Tue, 24 Mar 2026 20:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774385808;
	bh=Qo+ZovdrQkA7kuzporo2AYwDS9G8g8sICjIZiGOAKnU=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=f6PoctrisWs98te5iO4xZq2aMrivny/ZTKH1g6lAJVKqCu4up5Jcvk5+KYY6nHk9F
	 3qCodf23wxz+kbD9cCp2cSubZ/Dy+JrdOV4sDjqhCCPXva93kN/UIDxXcj1+Db/FEp
	 FEmZcQTFAlb5JRMgUG8NJPTDz42ABtcAg7LK7zAaAvQZ/UuqKh29rEgunQIRzjuGIf
	 ewfpTCdIBi0YDqg/wD+dAHAtbj5IqsB3x2klBeK6+2V4vAIUXkRCGm0n6VbF1+BN0J
	 bMwciUWDai06Dzyf4612pObXLHKPJvtn+VUkp2h/8Wss0jNMqxah5nUeiCrMHwkv0o
	 IMHTkGc+zl8og==
Message-ID: <cd26436b-539d-44bf-87a6-0109eb8e26f2@kernel.org>
Date: Tue, 24 Mar 2026 21:56:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/page_alloc: Optimize free_contig_range()
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-2-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324133538.497616-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C25D2100007
X-Stat-Signature: kofphoj5eoiu6ahhetparan6s3ijs14c
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774385809-129909
X-HE-Meta: U2FsdGVkX18KyDQW+24Fyz2eWInKOC5aJVal9JMGVFGWJ4a9Pl25loFmPJmPzfhVOYiLOREw7ndONnXK0YNo9NBou58yYovKtHdnpz0rAHE+jfVzcs20VuHudH9uCOZVehcKMVmQz/IGuWsZfXWTTCG6oRn1Bo3AMKrzIasbHoP/QC+1lT5Gf08+0fFW4RosswsMI0Z+b2jL9cCHta0rFmbdC5Q8fdhJCbSGs/FfFqVDp3b0J6LjVjh34oNvSojD2AJx4HQiXgCd+6neZ4VCA8x97OshS4Gdy9WJ2SNiS3fV9VnCvWPgFPhYirCpBlUKx2lEVUF7gBEc+T3gKBOEnPGa8Arz4VlKxV8pv2LIspTDT45UJhr6SKcBAR9ogILQvbmPPWhpZE3phRHYEIqMtY2dH3k2jl1PpHNXu1rqCjxhd4mQ24R2rXJ6K8n9ebEXezUBccOAwD//qGzEC+hbeG8R3JQlYbUvCIWvYuOYBl/kuH9pDK5q7t/NzRgxT/Vexx5E7ASUT/j6fFSTW2ob7uouFQSFe1lChHBaVijf1Rdv+3OnhnPQFdWzL1Kv9yUeyPRl4x5aXdW6PkzcLijcnoYhqMqxiEGLYPAWOIPVlinSdgnV2az2wcA2etGXvG03gTRX8DZfFH8nXlRM+4abvnqJxwP5+vCG9YZv0RrKYWvM6PZrGZ6rDYYfeoQM7Oq3r9zMzncyawMsyO5qT5Wwuotd2SoQae+2IhNbPzr4mWWzEZid6IGkLwqluBDDEixryMsoqwd/VhloU3PowvVfg9d2SGPJTXJMd4ZsbkSS6pdEyc2F91zWHMokDVB8FXAvjyua2nZnHD/3PhYblL1P8n9dKeYDw/AnLRA0uIsNVmxNJ+Hhqu5HviNRKQJc4WtBYtgXDc77T8VJst7v7NXW9MrO1HJjoJkv5KXiWicmTeKm5YeVhe3eDjtfpw6zoS2Bzq6hWo6XnpnVBRbd7as
 a+7xwVaY
 DXCKE/J/9j6NxOYxekOneobqNI+kyYgUC4pl7IKzFMgwLfs86AoEP0exZS0MLrANBFjEo/X8L2Vo3CVd1yRG5Qlc6xk9DXvj0obZzt+rLlwyaPjVuJet2hFZYyhjK65RkSKkRaFeU3SDObhZDeHpFr6oaSu+2McqvxpohjPrBXMybwvZpweJFvauA3I+SbP6zcVVuVc6KnVWA+1DtA+nhp4iYwrRGR5ZOej9WZdKryZXtudrcwfIqyJEICzlTcCsb7AqNTyWQYxg10tJUCMENw2rR49HdYt1o/BQVsq2eJ8gMB8cu0q7i1wwkpN3IQBeIjJQQUPun+5k+XOywgmiYypJC+2eFBPFPBOngunB3srO3JSSL4wpwrFBKSfmVzOipNYDE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +	struct page *start = NULL;
> +	unsigned long start_sec;
> +	unsigned long i;
> +	bool can_free;
> +
> +	/*
> +	 * Chunk the range into contiguous runs of pages for which the refcount
> +	 * went to zero and for which free_pages_prepare() succeeded. If
> +	 * free_pages_prepare() fails we consider the page to have been freed;
> +	 * deliberately leak it.
> +	 *
> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
> +	 * vice versa. Break batches at section boundaries since pages from
> +	 * different sections must not be coalesced into a single high-order
> +	 * block.

The comment is not completely accurate: section boundary only applies to
some kernel configs.

Maybe rewrite the whole paragraph into

"Contiguous PFNs might not have a contiguous "struct pages" in some
kernel config. Therefore, check memdesc_section(), and stop batching
once it changes, see num_pages_contiguous()."

> +	 */
> +	for (i = 0; i < nr_pages; i++, page++) {
> +		VM_WARN_ON_ONCE(PageHead(page));
> +		VM_WARN_ON_ONCE(PageTail(page));
> +
> +		can_free = put_page_testzero(page);
> +		if (can_free && !free_pages_prepare(page, 0))
> +			can_free = false;
> +
> +		if (can_free && start &&
> +		    memdesc_section(page->flags) != start_sec) {
> +			free_prepared_contig_range(start, page - start);
> +			start = page;
> +			start_sec = memdesc_section(page->flags);
> +		} else if (!can_free && start) {
> +			free_prepared_contig_range(start, page - start);
> +			start = NULL;
> +		} else if (can_free && !start) {
> +			start = page;
> +			start_sec = memdesc_section(page->flags);
> +		}
> +	}

Simplification a proposed by Zi make sense to me!

-- 
Cheers,

David

