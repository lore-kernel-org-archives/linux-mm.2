Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E9BC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82D96B00F2; Mon, 27 Jul 2026 09:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5946B00F4; Mon, 27 Jul 2026 09:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD596B00F6; Mon, 27 Jul 2026 09:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55C936B00F2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:53:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2D4440749
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:53:48 +0000 (UTC)
X-FDA: 85034699736.17.E41A14A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id F2C6420008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:53:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMlM4b05;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785160427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qz4bHznQFYHtYd51Eh25zSS8E1FWwIIvc+FleuDk28o=;
	b=bzzfNtCxCXvVTTRmAZxYnaDOWQJkhCpo7ahex5tmQ4ODBywN2yiIIchNL8cafxDNkdZSce
	QcBcVkMLFHsHkrSPFwunjWM24b2wMJqotb3/5RkWSGcQpxyMJMR5Ok9uED2ilTvTzRMFvV
	f42u/HqTyds3IaZ5JHWMl2mzxG1oM00=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMlM4b05;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785160427;
	b=nqwJv5kfqnaKrhN1TOx6M11t2/hHZn3ro09+dyJtsIy9uLH8OEK8qj0t79qusm2usKBClG
	C9paLMuac1LK7I16XdgpdfjpzJl/7j5OWPZT42HgtEYVU9I/p+S0Z1VveNABSwmUrWIwVj
	KUFslNIlG90CdAVAgWAcRs99zxwymwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B6CE40384;
	Mon, 27 Jul 2026 13:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2E31F000E9;
	Mon, 27 Jul 2026 13:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785160426;
	bh=qz4bHznQFYHtYd51Eh25zSS8E1FWwIIvc+FleuDk28o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RMlM4b05xpO38SPzaXPcJTSoOSEcy/MZaiBNgOMb8gnKZf2zZ77tYoNZB+UHpPjrT
	 k86bnFTtjI5HdaYkgyphrfdRHgUr0E4jV/axWcAw6gRkuSEznJAJAu2ScfShwo9AdY
	 gJbvt/M5CIlvJRfmUKd3GXRLVgItfoQIv0gQxPmRDFlB4HypSPS2qM6rp/ZkEM+oEz
	 GCZSLq+rZ9iyVHVglUv5+8BdcLrn4J7oiYlOWzTeQ3NQ1ImYCExNCD+Z6BkLl4ZT1X
	 Yda7xKaza6m2UggbBV6lx5qlPLlAY8lZQo9dC4pncFWiFO55BB1Sz7SLDPg8/IHa9u
	 BNk6+Xv8qumIA==
Message-ID: <7349d575-a1ed-4974-9b2f-2367cd58abad@kernel.org>
Date: Mon, 27 Jul 2026 15:53:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 12/12] selftests/mm: add a slow-GUP content and COW
 test for mTHP
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-13-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260724222934.1463812-13-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F2C6420008
X-Stat-Signature: x1jh6831hfeqozr85gb7rdafada5ydeg
X-HE-Tag: 1785160426-162068
X-HE-Meta: U2FsdGVkX1/Eo/J9nKr8d0rdiOW6P7IR6+5ztaTaWUQHAo8yKvlCfQdufAtSyTw4nHyZUke2JwOjnJrlEgvfTeOoLNrbKlxiTf/2UuTqxDVYFTfYa4cL1nJddVk+RI4W7wJEnI9J0TS/k/Fp7BjrMSvyo4MuDbqmGLD12A/r/vJUpFK7RoSIN7T78k28S2SLmVtLQk9MaNZVWnnTUxeLO1CScXazBHDEgE/xjFGVIp5ogDAq1w4dp2DEaxFbVJZwQUgHcstmz7x1Vyot1qAfgBjRp00wf5mTQoXNcowiJB0uurFumrWK8WRlTrhEtf88c4OqK8SEYzeV0ZWP8XjxxXLGzdlWtwunOmnXKAjuy2VqdwuTx6ltgwQvYdf/YuU3w+rCRW1YYIbiQKg7nbc04I33a5vpOxbA5hmjbsnudLjI1f5vBIUeXIo41Ma4U/wrKi879HYH6QNjvg5Qrh5HJvTaEOPk81cyzDgIvOC6NUk3MgV7tIbwNA34Z2gU4A2bIju52wYuFP6A+/WhUcsWQV6fzhWSmOWE8BdtjAx7aEWLnQSLp+viBQXco9WC+cBmQsHPzmYwaCzEdy6S3KvdJhn4j+YYZntZfij09m3wQkuZSiqMouju7TyOMBlBB3/L3AS9ubQI5RVm6WxAWifCLy2BUoEhRDu+lQ/vH0JLtustspoH314EH/Yz5kXLkOX/mAanC7Q2IUph3wYVrxQ4TOJL/usS9zcPaaOQ9yYyXc1fvK04W51X3JG6P069ckojWUArd8AphkkfyBexS/0CSojjU/6yfl0cYOUqjMB0jY/G7rNT9QC7P3MbjwaOV5xKlrWVnR2NBdygDPoQaVExdxsyQqGIjZAEdOzQaPdyzjSrqcyTKocevC+sVUGtoaEib6HETfxRWvRM5+OEnIZyNMeUzyItGonxcsEpfbJN1vfxGObABa4Igh+Y1j3U0oLDFqfPflA9jIfpC6PQTQ4
 kWGvn1pr
 nDX+GJQ05vEo9xjvwdlLT3HTg38D3bUrzHfFoLM9T25CcF60dHOuZUFR3N6JC/n0Kpy6kCtas1gpyyZhDs+vg/ScFkLsnLub8m00HaoHy0ht7Mhesha2YFiFrXpneWVuctOWQ0E4hIwWYIUaZj0AkMjmeeECl6hpLu4T1EWLQntHzVzXqxqi++S8EM0Fv4y/rkXAtf2Ixu7Zpc1IYsTB5OSJJP8l8f/3YVJwukqbzbx4hj1kPXq5Nr8DwTnzOob+OAdr/9+fEJm7RzYsRmgX1XeBDwvawPx8JqAVg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/26 00:29, Rik van Riel wrote:
> follow_page_mask() now batches a PTE-mapped large folio (mTHP) into one
> contiguous run for the slow get_user_pages() path. A mis-batched run would
> hand back the wrong pages or a stale COW copy, which the existing tests do
> not catch: gup_test checks only pin/unpin integrity, and cow exercises COW
> mostly at PMD size.
> 
> Add mthp_gup_cow_test. It forces 64kB-only mTHP, writes a per-page-distinct
> pattern, then pins the region on the slow path (PIN_LONGTERM without
> USE_FAST) and compares the bytes the kernel copies back from the pinned
> pages against that pattern.
> 
> The test covers a read pin, a write pin, and COW after fork(): a child
> write-pins to force per-page unshare and checks the copied contents, then
> rewrites its copy while the parent verifies its own contents are intact.
> 
> It also reports how many pages sit in contiguous large-folio runs, so a
> kernel without mTHP shows light coverage rather than passing vacuously.
> 
> Assisted-by: Claude:claude-opus-4.8

I'm sorry, I cannot be convinced to review this AI slop here. You should have
known better to no send such a ... patch ... out.

It completely violates to how we are supposed to write mm selftests in 2026.

Also, testing some implementation details is not really what we want.

Extend other tests to just naturally test mthp as well, please, if they don't
already do that.

Having a separate selftest just for this is just extremely ... odd.

-- 
Cheers,

David

