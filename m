Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE31C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 00:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810D16B008C; Tue, 15 Sep 2026 20:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C076B0092; Tue, 15 Sep 2026 20:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A7F6B0093; Tue, 15 Sep 2026 20:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 436E06B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:26:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC09A16052E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:26:18 +0000 (UTC)
X-FDA: 85217733636.01.1B2FAF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1CD4AC0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:26:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VSpPMCTl;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789518377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+ztgyIfOhj2tASJ/91ZyWCK6hnrxelPzrr3OzJFsW4=;
	b=aMjdVbuk+p2ryRqrU1/Yyw5B6SdgaV4xwJFvn8XvJXOffPV8TQvpVzMGGfHlTRoc/0xRCf
	B67r/xzxb9uSPM5UiHM6hG6nCRaeakIAYO/dPC0pw7Z8X8h1pKgzExbDVxm0Luy1/m2N9c
	cC6LNP9AJM2/P9tT3qiefnR1Z0EPwvY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789518377;
	b=rJX8EAcQNh/03vFX87roRryTT3vyjPvi9zOSt7ntl1V7x3JrMPnWkIPBhJzEXHA73HB4v2
	IqVLLI4t/dY49Rqoo4+4jY7qBpeZ6uHbCVO10rcXUQ9yYcFF5/6nObNaB9DoPol8bfcP1i
	1XGI1WcOg7wjQajVnnpEgBtqLJFzm3g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VSpPMCTl;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C48E40781;
	Wed, 16 Sep 2026 00:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56D81F000FF;
	Wed, 16 Sep 2026 00:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789518376;
	bh=3+ztgyIfOhj2tASJ/91ZyWCK6hnrxelPzrr3OzJFsW4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VSpPMCTldQ00Bk4kYwJJbuZtbwNpq2bfq71QdVaYl3Lmdd4wcD4Sw7gcBliD01fHe
	 S47da42zxwVVOFPq4pHa5LUINedqgmgrP4CCiNRCftyON91dF9CR3moH7pluYxp3Ba
	 K3mgT3K5L0yupGA2vw2gaTkB9xlTMUfs4wJl/n3E=
Date: Tue, 15 Sep 2026 17:26:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jaegeuk
 Kim <jaegeuk@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, Chao Yu
 <chao@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: use large folios in
 page_cache_ra_unbounded()
Message-Id: <20260915172615.c183c61c774f529ca57f1fb5@linux-foundation.org>
In-Reply-To: <20260915135909.1007-1-aa9736195201@gmail.com>
References: <20260915135909.1007-1-aa9736195201@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wam9wyebjnjb1o7rgn6ikqeydpa53x3m
X-Rspamd-Queue-Id: 1CD4AC0002
X-HE-Tag: 1789518376-194596
X-HE-Meta: U2FsdGVkX1+eQNRbSswEmCEqde+VkibtN24gCKzFlYaSccf6m34Tpa3/F2+By7Ry3fMCXH2xcOYwJzgehupdOJeRmeTjYUPQg25hh/SfwhiObZRCYePs9dWtLwxbrhzJkDLdUiNI3dsFyCigd6sRaEYA6Rsn2TOKA0pWfOe1y4TTUNWvvNAtI3mhL1aOivsnp5dwYp/lCsx44Wne7bKt9IZ82nLFRBqe/0o1FZq0ha0jkv31fpQKkj/trjOLirTMtmobXeAehwbUhW7QEPuFctYiH90sHIBdiVvRpwIc6+dhHAkTVS0ChjykNhO5dHLJd0sTz0I89BsxBu1LDW40li3fHnUhnEzNl7BQSYa1dkYbzrsLhbID6y3DVSlKUzmrW2Cxp8S3WFEm0fR342oGh8l+8CY45l79lVUmomcRaz0F/LPijug4B76UvRveuO2fSeFHoXPAHTo805Xw0HMfct3mJhrJ92AQ12hPVknbx0ux+iIta+xM2FMAdMbpx1Vim52vClIxKQLTj4m7XEab6wZwH++ZQoCuHOmuF6vxBZrm9H5CdhIBZGp6T87FZYFfDJ0LRCzhJI0GAhZ/iPIK+DiTT8AGZ3t214vLA4PsY4Oi8IfFX1SWHu3dGlZvI3Dl+KED1BCHgBus6a96J8g6Zfr3HMuk2pUjMl2jlsj1crbvGsX5l04YNUYAlftPzoeTpQi9wUYsyVmEQnCsCWFECZkeDq889hDkeXuAO9RtH8drORTvJuxqwNfFFMFxXJi3sLeADkKgEl6gH59O7r1fZuzVETLwC22Z83zEBP+WL+YpJrtNMLE0csaJqQCp8shgUQQCoroIN/2ik0iVTEsrqedmuNdLbEOH95K8AiqbWbcG/1RAP2N2qH/SfX8EuiM3NtcsWipanaJqyXU4RxhCKaEMxOuRnc+3v5+OuR/S20qjl51o6wHWJAkNn8Ugm23mavTMoIChGibf/pkrcv0
 KwssQfT2
 0zaY8X3rGacqSIvMdDQwJ1ha5jY8FiNr/GoofFOXz+5lLcvIevr0qek0y4w/Fjd1bDK5dEh+3REjtZncl4lVEtaRLBDnvupum9TN1TMlcxqmiwOeFUusLAGBkT7bZCaIYLdjN1462YnvD8yeKh2+l7pSbmJ/RSCaKcYsr+Vn4whkcV/4UHwPmBSxk3amG5JGwtOmVbi4TZ88h/hXWBgOu9MKK7X0R0RFa2/Bkc2WghW6uM0M82552qts+96CcBwrxizTvVrbeF9zi1hOYxLGuq0/M7osCS/UOHBfZ1tehz6EcJUvgnj5G61gyp0zuW9zC1i9u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 21:59:09 +0800 Yuan-Hao Hsu <aa9736195201@gmail.com> wrote:

Thanks, and welcome to Linux (I think?).

> Forced readahead still allocates one folio per page.  Everything that
> reaches page_cache_ra_unbounded() gets mapping_min_folio_order()
> folios, which is order 0 on ext4, xfs and btrfs:

Are any other filesystems affected by this change?

> 
> ...
> 
> Allocate the largest folio that fits instead
>

This all sounds great, but I worry that the resulting increased
consumption of larger-order pages will cause all sorts of unexpected
mayhem to all sorts of unexpected things.

: bounded by the mapping's
> maximum order, by what is left of the request and by the alignment of
> the index, never below the minimum order.  Nothing beyond the request is
> read; for a forced read the request is exactly what the caller asked
> for.  If an allocation fails, or filemap_add_folio() returns -ENOMEM,
> do not ask for that order again during this request.  If
> filemap_add_folio() returns -EEXIST for a large folio, something sits
> within the range it would cover but the index itself may still be free,
> so retry with a smaller folio and only skip the index once the minimum
> size collides, as before.  ra_alloc_folio() already does the
> allocation, the PG_readahead mark and the accounting for
> page_cache_ra_order(); move it up unchanged and use it here too, so
> the mark goes on the folio that contains the mark index in both
> places.

So for several reasons it's

- allocate a large folio
- check it
- oops, can't use it, free it and retry with a smaller one

People do all sorts of strange things and this alone could cause
meltdowns which we don't get to hear about for two years.

So the change seems quite logical but right now, I don't know how to
move ahead with it :(.  What do others think?


