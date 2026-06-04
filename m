Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70839CD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D056B0005; Thu,  4 Jun 2026 07:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0DAC6B008C; Thu,  4 Jun 2026 07:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C724C6B0092; Thu,  4 Jun 2026 07:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9B826B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:00:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E3911A0738
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:00:19 +0000 (UTC)
X-FDA: 84841936158.11.7A48D82
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8D5604000F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:00:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CajT5bzi;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780570817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HtVeA0z15DfvP0l2jtyhTbaRSfF8c39MlH3bNpNCuqQ=;
	b=hT7jL1I9m2KrwatS/NtPQYvL8oeH89VItnJH6Vpz4mQVtLGsL/6w3kFcb+aHIhaP499ROL
	qYq2dYOaXpPPguojb45L6W3mBHyqwbMk0SmChhuh0JO2CNi0qv0p0HF8anPhTTGwteUpXx
	CrIwK8LAGQvOq5kN1beKb2pPo6+Ddik=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CajT5bzi;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780570817;
	b=f8l/7mdlXywxSejh8ZYcp++wci5qHMVw12N2nwI/QDjnMmTjtvfJTZdYj+UA6IQ1sisNaX
	pJZTyHFbWQap2n8LB4FLfoGcrs7qEyGrxkw7oGXbavz5rHs3WmlgKcFkv6Qbkk/FuWnTdB
	87r2WT9HUm4sU8kyvKnj8wlsEuxdncU=
Date: Thu, 4 Jun 2026 18:59:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780570815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HtVeA0z15DfvP0l2jtyhTbaRSfF8c39MlH3bNpNCuqQ=;
	b=CajT5bziaVqd7yijafprktVDpTVh4nHx5XCo+oVUEXWV4wilaHQ3XCUvkCVICCVBLmoo9X
	PkEnxt+WaKoGlpLvlehIqjzBmYLXI6VHsH0uZdfe4GBVSyCR9cz+Ot4KlVRbJTcxJfIC3p
	tRVy3zLUzQg8vI2TPMTMU/EFHMTGfL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/swap: also use struct swap_iocb for block I/O
Message-ID: <aiFaqrUPeLvinf0D@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-5-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8D5604000F
X-Stat-Signature: kg9qcqgbtt7fwn55xj1b4tph7s4677bz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780570817-522459
X-HE-Meta: U2FsdGVkX1+3JPDZlXwxoEGCC0q0ZRw7yIq9XbS7u82tCnTe4Yf2hoEUk2SJsciS14z1OUuEACW93kTVugZNumhXAEyZZz3hzoRxhPiwLdq5AERlP6v7Gu4YFo+1Mh5kagUKUICiAka0ASPsqg7DQkCjTLDc7qke+vtUw0oPgYDXSvklKD4N0TqEVDd814NShT/lJXpecI+uXqeQHiMi1yDcgp5itneKerLBiYeLq4XungdGtlw/w/4fIMHtM0MlLcKCEwJnHFN2fP8/50podew6W5sHxDxa2Ty/EBT+40Nmh585H1+ZZHGLMyJ5Z+/ofD0boPC+MsnZJMS4dXWk/ApxU81cZMPA5xENE4awodyJFx9sdVcdP9hnV8+BigaYEzau4v9U1QyXFef3raa1cUi/jn1e8PR+0/heUw/ildUVs5FYh04XOt+/rqDxitshoBxuvDPBntIYm95mqLH7nDdPy9jT314p7N9lZdeIWkqseqA175nKzwufpWNiXIkcorxIi1U3ZuRDIAGVdhCsxJRZzdBJYlrBCkz6kl9KMzcQUu1mNiIOT70G0CU88qM0qbK/mdDxW2tyXaPGcotOmk7JwBHkZF1kqLLwUL9IsUwWgoTkK1XOpXQb4H45ixw4JOLyIvZEZfUa4G3vzDXQk8eya7j84lAjnrkzeTG7ZFj9LyWfJ+DBnbiRck3DbS+70QCZaTgHYY/4WQpQ/RB3LxRh/tXttX+O3RD+va97fJrpN4pS4YHGXbxzb8ut08cmydTh9hHMGmyo/ckwLErUjrf+1BRyHCCtcZVbDB3DRR7MxrJpUXrm+7Os/5CFZ17Ag38EEtCwwohXFAtkvghGvkqI4oAOTNMH7xDD0XvDFZnrXAdLipaaoBrBEPyQx4MWWS3v0KLyyq5B1pOFZSRAWAaDFGrYr71xYhSSIzzt/OszSWurfZ1XPMn/S76I9f8Kya5P8b/H4/uVzvHNdjX
 Dwxdtzxe
 Apopr1eIe+9ybCjXzJLMRx9cp5bF8mV4Z/m7xjsS6+Q+JsCYrO4uZy7Hi8Lc6WxOtSVwD1PrKqmKe8mPDD34bVRCNZ6Opwu4MFbAO0UXOfrltn2WTh0+DPWulh2clYSK9vA8+T8CXZRKd7rzr+YAjCVWF0ldnFW665VxK9bG9qAgLUit04hQZ327lQPjDDRdYFpzeK+o5QVyurm8k+Z1wK6efGCOdL61y5KwObfTI36QhFb9PgACLS0LOYqvDc35xLQ0YdeJ9/jrTy+3bS9eRLcBf/ZdFVDt7G7gaMrDCIJV7LP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
> Block I/O benefits from batching just as much as remote file systems.
> Extent struct swap_iocb to support building a bio on the fly as well,
  ~~~ Extend, typo
> and rewrite the block based swap code for it.  This especially benefits
> submit_bio based drivers that do not have the block plugging available,
> but also saves allocating extra bios for blk-mq drivers.
> 
> Note that the block based swap code now uses the same memcg-based
> check previously added for file system based swap as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c  | 526 ++++++++++++++++++++++++--------------------------
>  mm/swap.h     |   1 +
>  mm/swapfile.c |   9 +-
>  3 files changed, 252 insertions(+), 284 deletions(-)
> 
...snip...

