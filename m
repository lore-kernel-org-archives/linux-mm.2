Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17728E81A36
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B7A6B0005; Mon, 16 Feb 2026 10:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17C46B0088; Mon, 16 Feb 2026 10:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16586B0089; Mon, 16 Feb 2026 10:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7F946B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:28:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08A855CC72
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:28:43 +0000 (UTC)
X-FDA: 84450702126.26.6DF5CF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65A6E180010
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:28:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArN1zwoL;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771255721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxO7Pin/nTEWuZLbQzUglcF3w2g9XeNjr/WpXL1UyEw=;
	b=OjsVZIJLhsCWngLYXiD3Bwq0jWlgGMamrTLmdKWCutsiGpocidaupvN4E1dbeJHjpbn9s+
	9zF+8i+wC+RLhbM/s9A2n+0T2ZmwsfF5EkRQq1PHQeSAUnvX+Fb5VBIdZN7JQCH2Byum0m
	RMaGSM5QL1+hzDN/ib/jH4l/qHySVUc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArN1zwoL;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771255721; a=rsa-sha256;
	cv=none;
	b=ydJAHjN/pHww9pU3Xfet08vH3zYbSqO+tIBIn/LvsQRbllotw+D6cF3vT5i0jp+p+AKJAg
	bCF9PlDCqIzGfF9aO6DhHl742IQm+Yn4wsW7NIQPFh7RYEW20GU1tNrhq4544kFTlZ0HqH
	97btyJpYvyNV6tPbEu5b5O8N0kyes+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D90D260133;
	Mon, 16 Feb 2026 15:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73E8C116C6;
	Mon, 16 Feb 2026 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771255720;
	bh=nuGrUIFufm3nrjT4Umq/lxOkbdAYJYG1c/XV4oSIK4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ArN1zwoLYBVgLTwyoREinGMvhrr+I1uKljFodu7FP1qIuOw6Bpwur3T68GU/YUXL0
	 E4lfBrOQS4QD4TleciJgpal2vczXRAA/tS7p3Dzbka/PVLgx421YshUGCEn2PvDcL3
	 Yv8HnwjToYRjb/Y7KOK6KBOsiwwTTsgYa+ioAaZYVIy+ZGzxV4ocb2fsjuheeKnQwY
	 XAoFBSSrrikAMFnsGVodamo/OLG2J+y2T4ny1I0YofsQUUWvg/EiIdwR2LumWkB0Oq
	 TCMbYdOYg4Y/blwlNjY2zw3oio7hidBQdzdRTUXMM5bSgpaOMtRlKzC0LS720Pw2N1
	 PSoIj1JAdvzdA==
Date: Mon, 16 Feb 2026 17:28:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
Message-ID: <aZM3ota-JFJPsa1M@kernel.org>
References: <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
 <aYL3zxuTLT8N7C8-@kernel.org>
 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
 <aYXDeN0WGQG8-cxe@kernel.org>
 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
 <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
 <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
 <aYtBctm4TlHGnzXV@kernel.org>
 <1e83d9c3cf11ba825237dbc7d6a70ba47ab328cc.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e83d9c3cf11ba825237dbc7d6a70ba47ab328cc.camel@kernel.crashing.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65A6E180010
X-Stat-Signature: rk7ysc3nu63dcwhjssitg6yefkgewwmt
X-Rspam-User: 
X-HE-Tag: 1771255721-929601
X-HE-Meta: U2FsdGVkX1/T/T+ESREL84hmrWZwuB17iLzTXkts7eqi5h/OcibeVBy1WAKy8NJSSFMUyXAijCKK268mUL6IRnlO5Uyd/6ilRaDSeaefnlrh3tPDpoVJSs2AXgpeLxoLcRcw9+dhgbqigYkIxmNhpEcbweZXxMW272bpS0T/TYIKH9Cfz5m2A3T9mU+mh/Duavu5P9Lb7J/OlsRPjQy+8itPouTjEyUuvh1GjXPig3+e5VYUW5fK2IdEHM9g9irQH1T/hpgIn32o/lkzuFvDCKkkLT2ndHxECE8DM5MXupMvxzLlGR6dntjTYRraoT2UBgFXGRqOy8Qtogs3X2WHAN2qrxIgzV4Vze0GkQI3s93KwQ/gnxROzUrBguCe02Ar/gXIzy+HYkkYvrPsa/C0UWvHCxgszBBb09nfcyEHqtS6DQDrR8AQmGP636NphK1QE2du0XezleEHdYqtxte7SYHY7H1aleXsOvxFzkDPt9lvDQEjhrvuschCQN+dFUcWkodZyhUTx0LEozWZAo8Ga/2rnHsnA1IbGUPhvAk2UBeyxoKpL0PMp7WQ+V2DchCaZuwvp/10UOQCWu3++IZG45CbtHb06XgP3dykhkapzXWVrQWnA+kuNZVRcvXrsG6MUpc8OD+HEQOasDvvGhe+x1Z1OY4H7A9bYjpxQiaJjYSrjFnDyNzgvlLX/ElZIQbh4UhQurThI7YPNWZRxvnyRVAo0t4todIUsAxXwxhtZ5wwgInDQ2cYNACQ5yOUF+zarUV9sKlR75bRkGhz89a8vi0blcp2tN/gtJl7FaBTnS2OYoS6OfAI4RpkSqiLyA9EajcxuDhsDUypfaeNhncUo1+K95LAryv6XzBzjPgtWlAMncM+T9YsxYxZh3G2sp+mH0m6Gi3/0JlbmUbkTH1+/HNFsEYAVvsZopljSRvkqJwMvTBrzVhJo8rpr2r8xMwhYxT8zwSNXoMq4xB5FWB
 xhySU/EZ
 FH13LeDLgTifIoya3bORnYn1qSsSKag6hR9fw6Kz2288VubkjtUNYzdS7dO/zdtXaS9iqRtdK30KzVE8r4D4KCq9ZMqdB4mYzxITT3QVaSJahDWT9qFWTzIiH0T3bR4f83MLVHXBavZhuf3t29hzddNhgxeSVIoPzCeSISeUaUde/W+2x2k0o8m2XWsMHJU1VdYH7Y1gnGJ5SKtIgbxo7zkJ3BJ8xEHpJz4LDv9xYsgfyi4hpZd/pJjlRFzWtthtSggbCw9eFsKBz58+WWYMnyOI7MY2m+iwLSUTOp1CuBo/qnXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 03:53:33PM +1100, Benjamin Herrenschmidt wrote:
> (stripping history)
> 
> So I went into a big refresher (or learning exercise since there's
> quite a bit here that I never really looked at before either).
> 
> So here is a break down, in chronological order, of the setup and
> initialization of the memory map, and how the reserve business
> interacts with it as I understand it from reading the code.
> 
> Please correct me if I missed or misunderstood something :-) 

Your description is correct. There are some things that moved from arch to
mm_core_init() just recently, but the order remains the same.

> Also maybe this is worth turning into a piece of doc ?

Care to send a patch? ;-)
 
> Then some conclusions (I think I know why the patches crashed).
 
(trimmed down the description)
 
>  * One thing I have NOT yet figured out ... do we have a problem if the
> page is in a hole that lands outside of a zone boundary ? I haven't
> really got my head deep down into the details of zone initializations
> (especially as we adjust the boundaries here or there), so this could
> be a problem.

Zones boundaries are determined by addressing constraints (DMA, DMA32,
NORMAL), node assignment and actual usable memory in memblock.memory.

For a machine like t3a.nano there will be ZONE_DMA up to 16M and ZONE_DMA32
from 16M till the end of the usable memory so there should be no problem
there :)

In the general case, I believe it is possible that some reserved memory
will not be covered by a zone, for example if the reserved memory is beyond
the end of the last zone.

I think that this is a really pathological case and we can dismiss it for
now. 
 
> 99) Conclusion :-)
> ------------------
> 
> Nothing firm yet here but a few hints at what could possibly go wrong
> and one obvious issue with the previous patch(es).
> 
> First the obvious ... the proposed patch that just makes
> memblock_free_late() call free_reserved_page() is missing a call to
> pfn_valid(). Without this, it can (and will) hit holes in the mem_map,
> and that's probably one of the crashes I reported.

It can, not sure it will, but we want to stay on the safe side :)
 
> Now, it would be nice to then go allocate those missing bits of
> mem_map, because I really don't want to give up on that memory. Small
> instances are a thing and with the current price of DRAM, a fairly
> relevant one :-) But I'll look at that later.
> 
> My original patch had the exact same issue btw.
> 
> The other potential issue, for which I welcome your input as I'm
> running short on time for the day is ... the impact to zones. I see a
> possibility for those pages to be outside of any zone's
> zone_start_pfn/spanned_pages range ... or not ? As I said, I didn't get
> my head yet around the zones init and spanning adjustments that
> happens, so I don't know if we really have potentially "holes" here or
> not.
> 
> This leads to the question... could we work around a lot of those
> issues easily by making the early efi_reserve_boot_services() *also*
> add the regions to memblock.memory in addition to memblock.reserve ?
> ie, those regions are marked as boot services code/data, so they must
> be memory to begin with, and that's all early enough that we can do it.

Adding the EFI boot services to memblock.memory would certainly solve both
potentially missing memory map and (unlikely) missing zone span.

More broadly, it would have been nice if e820/efi would add *anything* that
lives in DRAM to memblock.memory, but last time I tried I could not
convince x86 folks that even memory that's unusable to kernel is still
memory :)
 
> We should still add the missing pfn_valid() of course, if anything for
> the sake of any other caller of memblock_free_late() ... or we could
> change memblock_free_late() to only consider ranges that are both
> reserved *and* in memblock.memory. You mentioned that might be slow
> though.

memblock_free_late() can't consider memblock.memory and memblock.reserved
because it might be called after they were discarded. 
And pfn_valid() should protect against accesses to non-existent memory map.
 
> Opinions ?
> 
> Cheers,
> Ben.

-- 
Sincerely yours,
Mike.

