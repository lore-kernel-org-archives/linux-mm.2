Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDE6F8E4A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 04:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B07A6B008A; Fri, 17 Apr 2026 00:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A486B008C; Fri, 17 Apr 2026 00:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3296E6B0092; Fri, 17 Apr 2026 00:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E06F6B008A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:13:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C22821A0B31
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:13:44 +0000 (UTC)
X-FDA: 84666729168.18.414059C
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6E5F18000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:13:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mETVZEOu;
	spf=pass (imf16.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776399223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUaK1uP+6uJO3z8Fwm4PBPbv5RYUn9z279QbRwk1wDE=;
	b=Lwuqrt8B5eebdKrO2J0AxboIzJksa9dzrqGaOhVh8Xd5v8HRtcOIrtr0aox0R5RzJnhXMM
	VpEQu04BMmRQ465XpAVv5OZbRWFNHamUY9z5o8h1TTr+Z3AhpfRJibSWzc1cIGHMQT+Ux6
	R5G9QcVX9mOszUDHVKia0ux49eXhuow=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mETVZEOu;
	spf=pass (imf16.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776399223; a=rsa-sha256;
	cv=none;
	b=iHQdnN0zFgbzxH2XjHRnQ2ISZzqf2wTsFw7rPxR+KQMSB4moLfJjhymLSaDgDNnlRB+rUa
	3mLEcXrCizIGWCaZU2rBpdF3ThQ/9DMa1MfNFdPQCQWrDVFJczJ1eBj5ONzWxTP+UuuTx5
	80tnWOvNnIUMbTpsWHCpTNy2T2imxNM=
Date: Fri, 17 Apr 2026 06:13:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776399220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XUaK1uP+6uJO3z8Fwm4PBPbv5RYUn9z279QbRwk1wDE=;
	b=mETVZEOuB6FUvW28gEH2W7joKSOQVVwk9uQHP8vGpER0/3RF6zLF0Fh02TiaJ9+zynry00
	064wsNt5G4t0VMJBo81UcDM0aj0XeAuIPxPQLhU0TBul1ZV7tCB097AWL9XRcKyz0+E0Wn
	vnc8A8/LBLEIihoRIRj5Pcq+dRP/1Pg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <2dmo4my5rml4ymfuw5afc2fnbcxn2l3w3bz2boj4eevognilni@vgy4vwlikqx7>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6E5F18000A
X-Stat-Signature: 1oeaji9se6yf81s13pb1o83phkz3mmu1
X-Rspam-User: 
X-HE-Tag: 1776399222-109232
X-HE-Meta: U2FsdGVkX1+1HRvi7/Z4mNCuTyOfjeXHHWRxJ3THZIKiAIUuYZXkcEXEapWQneN3LZkXzuLCuUkA6Oy9Z0t9D+8nSBavhrchq5RTC4pv7o9eEqHT4pUXfJ2vJ9mWYUXVogLSqmsm2p4L5tTS3DX8fKiom5EcQl38dYEIjKzhDBc3FSmcOOrLXF8jRnHvHK6o85F3rQPFlpTEnOZRmTNHtOHGL3kcVUoUSgZkI4KhdjYKZoOeL3zC1KQNS7qsvOdGJFgfJVC1oeKzTAOvzKoBAEB+aVYCMyk5BShAqdJ3dIEV4zjUEZBEvBYKIuGzUMSg9VRk9CLHXpJoE0pNwhBORlo1taarlGzLJcJgmiOK+ZJg1v8Z0QDSBLkzrP62IfZknN5nOsqBtIzzzzg2oEwtLV19KSvNqBPN5WnBkf+uLUY+Jhze+/YYhfbatzLQ5bY1TSAhemviMsMQYGX9eDaAz9nu4wEl74yj7M3h0drJu8vu7CCvlmoDgluTSWPlQVvR3xTbSza1DIQl1fNbFYobB7YgEL0176e0p83sg/lhJo6pAlPir5h3MoVRiZLvfdtmq7qE9vlLVPQ4doMsbHXvATLEnB4Vd0G53VRXDkmBtUjRyotkAlnBpopaYO0ekgP7mGoVFBPehrfzme4Ws5dSfM8ImzpVTpEoTqcVnDMRuR3DQAGmf5GeAZLleN6r9pCnpFgtU/3DyHBLry4wnxJ6blVqOr21h4gBuJMWKQ0Ki1ExvSKz4eCCb8ErdJSF40YOQFBNkcMqBy/14qzgvsQ/rpYoMTiSq0zVEkwNqmJvUUDE2d6kIELLkO3qTTEZeH4H+dQrhnOoQAPo9+alzk0vbYU5kHNWzDemyhjzVubQVUXvyEH9fiK2sqNf930VvzPcEamX5QQpcQEz8HWBC5czdoB273MDThR6xWFJSh1Gxq3AeYt+oi1GFAa9iMzwHnTx1bNVjAlUkUVor/hFupW
 zxaOnZQw
 4TGF2Vg16EpLvDiuf+cLIwIHYGpVv2uFHGQ5qpdbipTAA3WOYQED1ZJRjy1wrcd1yZD5CfCeebTc+8A4s5M/oMk0VZeorSpSLe2guarOeEF5AoVfbM1lWtlkNcZ6M1eDLaJkMwoCcOF2PaA0Ov/Gr1nrIe+NeukE3l5pbqXA6hN+WSV5UH3uMGahGavtunEUG85myAPnVHsWZ8gjTUo62HbhwEXIGF87exRHCi3yj/80nd7cL5XgLKhyZghKxtt+uqTtq5LvbDtaEq+7WNJ1bJnTIPKvUUkRsrabra6OTSdWSG/NN5UgYOdghE93ubI1vfeS0+7TpizLvVOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

<snip>
>   3.3. Wait for any current writeback to complete and then call
>        folio_mkclean() to prevent mmap writes from changing it.
>   3.4. Start writeback on the folio
<snip>
> +
> +/**
> + * iomap_writethrough_begin - prepare the various structures for writethrough
> + * @folio: folio to prepare for writethrough
> + * @off: offset of write within folio
> + * @len: len of write within folio
> + *
> + * This function does the major preparation work needed before starting the
> + * writethrough. The main task is to prepare folio for writeththrough by blocking
> + * mmap writes and setting writeback on it. Further, we must clear the write range
> + * to non-dirty. If this results in the complete folio becoming non-dirty, then we
> + * need to clear the master dirty bit.
> + */
> +static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
> +					     size_t len)
> +{
> +	bool fully_written;
> +	u64 zero = 0;
> +
> +	if (folio_test_writeback(folio))
> +		folio_wait_writeback(folio);
> +
> +	if (folio_mkclean(folio))
> +		folio_mark_dirty(folio);
> +
> +	/*
> +	 * We might either write through the complete folio or a partial folio
> +	 * writethrough might result in all blocks becoming non-dirty, so we need to
> +	 * check and mark the folio clean if that is the case.
> +	 */
> +	fully_written = (off == 0 && len == folio_size(folio));
> +	iomap_clear_range_dirty(folio, off, len);
> +	if (fully_written ||
> +	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
> +		folio_clear_dirty_for_writethrough(folio);

I get the point where you want to prevent mmap writes before the current
writeback completes. It is not very obvious to me why folio_mkclean
and folio_mark_dirty had to be moved out and then we call the
folio_clear_dirty_for_writethrough wrapper. Anyway those calls are made
after we do folio_wait_writeback right? 
Is to cover the cases where we do partial write in which case we don't
end up calling folio_clear_dirty_for_io? If that is the case, then a small
comment on top of folio_mkclean would make it a bit more clear.

--
Pankaj

