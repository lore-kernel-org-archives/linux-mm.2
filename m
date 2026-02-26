Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981C3FD8FE1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBCC86B0103; Thu, 26 Feb 2026 12:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87696B0106; Thu, 26 Feb 2026 12:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86B96B0107; Thu, 26 Feb 2026 12:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2FCE6B0103
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:31:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6122713A865
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:31:15 +0000 (UTC)
X-FDA: 84487298910.28.D9260A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6D9614000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:31:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YOj5+TQ1;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772127073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utEdHbxPCCHaXA/Mdgqz42eN18S8ss1UIKvBZg1Em5I=;
	b=h+qCH/5Lg46518Vf6JsD7eqYGHe5V6NrfMZltgoIA4OPNNnS1sO8kyx9A9cgn7y98D8ztZ
	7xTsy4SYUAe2KbmhqTIq57gMLP3f3Urz7cln7fMuH7OxDI1nQgwNT8iV0QhqlQl0GGT7kf
	N+okboK7fwK/jPyFo4G4VotOITnocL8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YOj5+TQ1;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772127073; a=rsa-sha256;
	cv=none;
	b=02kh8T5JmlC/VRgYJGtZw8F6RWspox9snV0D2iPDTm7ARSmN1ia/sIy3R479uKo0UVLEhX
	BllXfZd4jLeu94fDCDqZqybhm2lcaupOdKhl6tcEJ1Nb5xcIvxFvIrHoPMi1h9lGZZNVZH
	C27JBQWcuehn4Dn7PPqTJ1Cl1FP9z4g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 059F460126;
	Thu, 26 Feb 2026 17:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D5AC116C6;
	Thu, 26 Feb 2026 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772127072;
	bh=/BNSe6YUqBvhE9PqCJP2oE6RP6zCNW4JLfTvSuprzdA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YOj5+TQ1nw5L7LbdrMhyCKdR2kBzdkG0zPDmKCx57/2Gb8IwxEXGjdCY9xlE6yBgO
	 Git2iNHM9k3pPFZ+3HQs8pQg8C0PnNbQkeoZ9RU2XenRXhYUHZU6QpzfGnS+mDg5+T
	 2lnzWz+qyqjwQ3+GoM/JCXkBycFK2ytNLZNhndJwknKnqLQUJzaoK0PtdBLgkXienz
	 KhimjQGZ4hLxLHuPLTvBf8CEFzZXLF+j5Jfbk2PsWt38uo1WOPFmQMchn9T0hQSZVk
	 2TmlVOmNqUW8Mu11C4Ew6pG6/FInX/yFHfRcPdnCrFLTnOaKRzhG0vFNxga99HXVot
	 B/tJTMGm4EQQA==
Message-ID: <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
Date: Thu, 26 Feb 2026 18:31:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
To: Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
References: <20260225232708.87833-1-ak@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260225232708.87833-1-ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A6D9614000A
X-Stat-Signature: enbrpccit3tj6z1gqu4n7kxfg4a8ycck
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1772127073-763257
X-HE-Meta: U2FsdGVkX1/rsLCM+E9VdY/sTklC6P/YDLgfUcKNm1o2KCvEy+8VDuoFdlE66sSasBpwMjKH+Aa9s52wwRiaNA2jdpPgPjMcM0as6zQYy8HQPOEkxd07hpwL93Aoikyk2u7Ie6rvEaUdDr7TYh4y50peTc2WyyLzRWzAmNMTXGfG2flO6oq4JFUWcBBtqUxtvTHXoVXSnpY/m8WN7bHckMQk0eGZ0tf0rZs+iz7WiAGJUi1/LgBCHfCHDGduoOegRkNGFplVZjy5/YtSziJ8Z9+OmPehToyYtiT8NM2UwAZ1p5E5uPU5o2Le9NyDs6RbXDarDdNlEg6jT0gCbHVWTxmsFggwJnR82j7fVIwLWD0ZDtfBiwT0SWtuAO86Cf4tLpJv4KVpVjKYGK/rBP1SaLE32TBa1PURhbBdrEGSfnXBd7n0dg60MRC6yRPOSpjCLCFVDFtEYKt4Kh2tQ9D8tyglgymVZ3RifOTsH2QP91CJLngxrkjKqTJXpBoAbYs52Kge+lJ8aaXq3v8TSUzInmH2NBU9PJ8Lq+VEantSwfqkz7smBuQ9c82yX6xIRXWNn+4RjUMhZo11aOcq49eIBAlLd36LvWPZLyRRNJ2ia3Cz5y6Yda+i2crZjCQ6Oo0WYjlUX0xG9UbLqyJ7pSQq9MMSLFcRnYRZEMJ11ylzej2M+RGQ8m/4b5zD3gBnqZ49tD5lKiNt0zZk6y7NpoqehxLDpYFQoECByYeabgLJIqV49mxzdep166r4/od81swUsBo5YROJCff64wapflGZHRYNlsIgkpzjUP9WqXJz46saFl0CDvQa62aOmhXOKF9mztwVNamjT71MgcpXf7d7oFmiAlETtaR1JjGhEF84uOeGpvSazKiuP8MsxN427S3dM8s1xi+z7Y+BNO75YphxPuYe9M5c1+SDWlBFGxrE+hwKw8OnUSDBuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 00:27, Andi Kleen wrote:
> The earlier version of this patch kit wasn't that well received,
> with the main objection being non support for mTHP. This variant
> tracks any mTHP sizes in a VMA and reports them with MMUPageSizeN in smaps,
> with increasing N.  The base page size is still reported w/o a
> number postfix to stay compatible.
> 
> The nice thing is that the patch is actually simpler and more
> straight forward than the THP only variant. Also improved the
> documentation.
> 
> Recently I wasted quite some time debugging why THP didn't work, when it
> was just smaps always reporting the base page size. It has separate
> counts for (non m) THP, but using them is not always obvious.
> I left KernelPageSize alone.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---

You should CC people that were commented on earlier versions.

I still don't like this.


a) Just because a folio has a certain order does not imply that hw actually
coalesces anything. MMUPageSize is otherwise misleading.

b) Simply because you find a folio of a certain order does not imply that
it is even fully mapped in there.

c) PTE coalescing on AMD can even span folios

But more importantly

d) MMUPageSize is independent of the actual page mappings, and I don't
   think we should change these semantics.


Let's see why MMUPageSize was added in the first place:

commit 3340289ddf29ca75c3acfb3a6b72f234b2f74d5c
Author: Mel Gorman <mel@csn.ul.ie>
Date:   Tue Jan 6 14:38:54 2009 -0800

    mm: report the MMU pagesize in /proc/pid/smaps
    
    The KernelPageSize entry in /proc/pid/smaps is the pagesize used by the
    kernel to back a VMA.  This matches the size used by the MMU in the
    majority of cases.  However, one counter-example occurs on PPC64 kernels
    whereby a kernel using 64K as a base pagesize may still use 4K pages for
    the MMU on older processor.  To distinguish, this patch reports
    MMUPageSize as the pagesize used by the MMU in /proc/pid/smaps.


So instead of 64K (PAGE_SIZE), they reported 4K. Always. Even if nothing is mapped.

So you could indicate all MMUPageSize that hardware possibly supports in here.
I don't think it's that helpful.

We once discussed exporting more stats here (similar to AnonHugePages/ShmemPmdMapped, ...)
but we were concerned about creating a mess with mTHP stats.

For this reason, Ryan developed a tool (tools/mm/thpmaps) to introspect the
actual mappings.

See

commit 2444172cfde45a3d6e655f50c620727c76bab4a2
Author: Ryan Roberts <ryan.roberts@arm.com>
Date:   Tue Jan 16 14:12:35 2024 +0000

    tools/mm: add thpmaps script to dump THP usage info
    
    With the proliferation of large folios for file-backed memory, and more
    recently the introduction of multi-size THP for anonymous memory, it is
    becoming useful to be able to see exactly how large folios are mapped into
    processes.  For some architectures (e.g.  arm64), if most memory is mapped
    using contpte-sized and -aligned blocks, TLB usage can be optimized so
    it's useful to see where these requirements are and are not being met.


-- 
Cheers,

David

