Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6954F606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JhmotoTd
Received: by kanga.kvack.org (Postfix)
	id 919806B05B0; Mon, 26 Oct 2026 10:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA106B05B1; Mon, 26 Oct 2026 10:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFE96B05B2; Mon, 26 Oct 2026 10:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B18D6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:22:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF1B3C0761
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:22:50 +0000 (UTC)
X-FDA: 85364993700.09.C378663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4354218000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:22:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhmotoTd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793024569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKt6+bsKfLK53L2GaRA3WWqLfNzUo0lW3V0HdvcPXJI=;
	b=YqZgkhlxcIfRF4Va2fAaBx0417Q9cnObmu+DlqHFHQUORaEYmavPpkgK2kTM7FZsTLIixs
	7r1X49sDrsz3px9IB4Zd/iGgV2lilMHhznSzQ/uCK6c/4dTBL7qTCBp8i4ddzZwk6PpiXT
	3jt+Mbl15Krk+3co4kjUKEcMTcQwtXE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhmotoTd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793024569;
	b=kEAskauMMZ4rMoHQPm29EalOiUHTrrex2WH1y95mZpOwmzLx2yDGu34whRL8QzkB0e0TjL
	k7Sgc6QTvNUEedGO2UwtArz4ViBPBFCHffzY5ejkiSHygOPvL+OUf9RGgu9Y1S7aPVrffF
	VUz3CQYdGGTZpAnAdOyMK4o0MlzAJ+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FCEB43DD2;
	Mon, 26 Oct 2026 14:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9813F1F01825;
	Mon, 26 Oct 2026 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793024568;
	bh=aKt6+bsKfLK53L2GaRA3WWqLfNzUo0lW3V0HdvcPXJI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=JhmotoTdkwlq5uP+ikQwsrku1uYQ8w4CrgqDBBQGrnSQ8fncJUV6Sg905Qdo1IWoS
	 5RyHMQ7joXXGnvEG/1EEYSGiS+fLiKMyOC8UeUvJQZDWmT+oo0byF9GStp/mEVtj5E
	 ChnLqvVcXxkRNtJxnlqXq4hdQhEBH/HXm1MRVUSwBiRAhXMf5D/fnqlFHX2ADL6hI/
	 +qHBoI+zrEtXkaf6vly/J70BbMg6yeiklwe2d7rqLCbTkhql199+pp796ACDzhd/9v
	 B5ceaRbvY0LkNByK5/2141SWcFvqID77OmSGU2mRIkLCzh3iZzeWxIqW8xyeft5E08
	 jl44bha+xgC6g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: rppt@kernel.org,  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  graf@amazon.com,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: Skip zero-sized bootmem areas
In-Reply-To: <20261026131851.9942-1-cp0613@linux.alibaba.com> (Chen Pei's
	message of "Mon, 26 Oct 2026 21:18:51 +0800")
References: <20261026131851.9942-1-cp0613@linux.alibaba.com>
Date: Mon, 26 Oct 2026 15:22:45 +0100
Message-ID: <2vxzld7kpmmi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4354218000D
X-Stat-Signature: fph4xcszjesmde88g3m94f4u51ye3g8o
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793024569-685156
X-HE-Meta: U2FsdGVkX1+4rACSQ0Ddq/NAp2wdZlmylwsS6KcqdLgi9iq4GOvqF3OxHqp4l1qF/UO3jKPnhqHaaE7zxbhdV8yv2IVkAYf663qHmrB3vH6P4OffClzwO6gJd1lSJVdIlTSe02LXwxT/MJmC4nf/A8VFxzE4Fe1iKfg+p5+1UH1j1SFQR6BRqNDmyeKInZiki72LRe55wuCFgDRP1OxN+IAIF4iJZVu8qQf1KEd7on+6OWr4lP4XMdxLBYBKn5tSUAUMnQsWSEN7/IpsJMg2DODoYyTbDSmbPrfUejeWiW4nB7EpBd5Lzrg3iqARYv4udoQPhKi2lm0tHVfbI45Tsb17U9hcqTc4pW01EIuuhYY5jwqOwnKlehRRTKC7XwnR4jFLzuo9iE2Q0A7okBCBsR1qCKvqD2faUMtVfsZJZTmnSf7SlG8e2EcNPA30dtXVIiwhI4wwG8TtTL44jHRm7h71jTr1tUOnAnC5vdzYv5qcu/YLJBhT96qQ05dzWYjM+VteejNR8qR3RnliFnGllVJmQ79KNaVIu0agHkGf5eDc/chpOeZETH6VzAw7unVSob/zNOnfbHXO+7Yv52/tg/Z0ei5sWioU/xN/5ztkNw55Z5eig78yUjZsn65Od5PmaoHR86PMLUxHuwvc4DcdB1AOS79UN0GAdsEIlxNWJ+E01RLqPFIIkoJvPdkpCCorAQnELaGXzIAbRzAAZHC7Ha0CvNOtOgN64BpLzAjX23chR4H+OZjUjCocWLLbCryPgMw0Hb013VWmhQKLP0RYJ4+4xyK88fGeJQzSghnLIRuwsveO08SwaiRe1EH5waXQsHCeXQOc8nShTvHuoPdnUlABSsN6NxbLrErxoWyqqsMy5C6R1L95a6zO/jSIBV5rgJg74G9QHE2ZFws7D4Nnvoc2y9nnNx5l+M0tcn4kckR/Xocp6JOZ4UqmniN99t8u5pZ48j12o7eFI9I8yVU
 HL3+8nhm
 k5fpkKXiSNKosHszJJ+nI6X6AgodUgd/CQwMgjZusWP0hYWS9hKVGXzQOD9SGfp9QcsY+tRWIxeQ+IelYXGUcfhHY3SKgBlYkJ2/N0U/raIjlwBxm/SR92U0lqb/PoHp+UtKeK49weHamSHgYJY4j7wegLD/MFXDmRx6xjnRZ0AJES/ehBDsD6sDIXxbd1WM1x8IKaY3f5GboIU3a3PdSER9LgDafiIzv8n70jsGDv6aQlq4mBhyu74WkZbN4QK4lD8pH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26 2026, Chen Pei wrote:

> The lowmem and the global bootmem area are reserved unconditionally,
> while the per-node loop below already skips nodes whose size works out
> to 0. Either can legitimately be 0: the global size is the scaled total
> minus the lowmem one, so it is 0 whenever all measured reservations fit
> below ARCH_LOW_ADDRESS_LIMIT.
>
> Reserving 0 bytes still succeeds, so an area covering nothing gets
> recorded with a valid address. That is not neutral:
> kho_bootmem_overlap() reports an overlap for any request straddling
> that address, and memblock_alloc_hugetlb() aligns a request to its page
> size, so a 1G hugetlb allocation retries a free candidate on account of
> an area that holds nothing.
>
> A machine whose memory all starts at or above ARCH_LOW_ADDRESS_LIMIT
> hits the other side of the same code: the lowmem size is 0, the range
> below the limit is empty, the allocation fails and KHO is disabled
> although no lowmem area was needed.
>
> Skip a zero-sized area instead, as the per-node loop does. The
> descriptor count stays consistent, as kho_populate() derives it from
> the segment length that kho_fill_kimage() serialises.
>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

Do you see zero sized lowmem or global scratch in practice? If yes, how?
What's your setup?

Note that I already fixed this for per-node areas since those do end up
with no allocations with movable_node set [0].

[0] https://lore.kernel.org/kexec/20261014131547.259138-1-pratyush@kernel.org/

[...]

-- 
Regards,
Pratyush Yadav

