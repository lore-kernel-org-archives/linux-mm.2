Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41F210A62D1
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146286B008A; Thu, 26 Mar 2026 22:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7356B0099; Thu, 26 Mar 2026 22:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C7A6B00A3; Thu, 26 Mar 2026 22:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1CC96B0099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:23:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87E97E13D4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:23:55 +0000 (UTC)
X-FDA: 84590247630.14.0118B4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D07B710000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:23:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mOzcA68l;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774578233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHFKoGYxq96pwKL4VkixM5/5yY6HqI0jZQpySB4NhoY=;
	b=sAwKSdtF2f+/g3RfevMFjVr1it/llyiMnnXxGOYITY3KU+oevg4w429mkOGay0xhHISDKa
	ss7ZTdwD008EwGOnHIkmOqmhwkPWrm+P16bT0W15sgk02+2ADU2hk8Lqd+Ib2x7B1gYuZO
	73lz0l17/Ia2icEcF6xyrtMiq37GH/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774578234; a=rsa-sha256;
	cv=none;
	b=ELCwkOwCDeKDNfv67wKHUuk3v0sM2x5tXLoZoccI5ZI1z957dTE3akpw12WCVMCM9pmMte
	xr/SqOiwYDbvaT08oLVyOvS4x3nlsJ1VIh8yy5fpYOYLPnQZge4JUtRpOGNlVd3PHp/8k1
	vNsH+uUoCEW8mGTeZiqxNLQmVjFYaLg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mOzcA68l;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAEA543236;
	Fri, 27 Mar 2026 02:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604D0C116C6;
	Fri, 27 Mar 2026 02:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774578232;
	bh=Kmj5bybZqcuY1bMfQ2d7AFuAZFz/iSD+579cXDOYoMs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mOzcA68llz2krPlRZUaF7lAOqkKen7l6iVH5GEzfvQYYFX9JD9Tpzf6mE/RkY7Zgw
	 SocGwv5ATc39Ww0O/so9+wDa3dODLQOXJT3aHMlG/OhpKvITY1Vl6L/jXIg3kKtphR
	 3qJWg9Zf+npVUmXirsebhenlSZrQObkhsqgc4epg=
Date: Thu, 26 Mar 2026 19:23:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the
 pool.
Message-Id: <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
In-Reply-To: <20260317014802.27591-3-kanchanapsridhar2026@gmail.com>
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
	<20260317014802.27591-3-kanchanapsridhar2026@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ftff8hgpybu3zkroywq1p1byzbs3jj7b
X-Rspamd-Queue-Id: D07B710000B
X-Rspam-User: 
X-HE-Tag: 1774578233-312921
X-HE-Meta: U2FsdGVkX19FFkKDcDH0LsezzKLDCW2gigrU0XDxOO76HhBBexAC/hSC+8cWOkmSlc6LXGLwO34X8FGwWYnjYFkOgAUMU3/1rbVvjviLPwbbcpzADSFdLa5P1jFTTSYFJvK27p/TOQfSqRz00hfde/Yn6jMq5/cHRZnoiEUwljnDwFfRsb+4AIZAvvK/QSXZpW2+B77bSaLy1hO7cHnzk3EgHomgs9S1G95cvW+tgY3yA07VF9tPGB4DGEN/Ghb5PvmVTPZfbbHCohloargbQob9bu5PGvohtRYptgtJVMXwtoZ1B0Of5/E1MEljxoDUd2lD7C4g3ssdigJvode1lvjEhNcr18KNnEqfOWb5bTgI3qqmG8SPhJ5gHN7EPUxKtjj9nQd+euDb5HlnliUhVxmedFfICNrWlY7RnvXRvbrvB/rx/EdQV670AO4wyyMRjmf4JNgLrqdP3Me+dlScHhaL8OT/kFLgfrKzmKkxWrNa7CoqEclEPxmCiEt1X/qyFuZp5V2yQLxR744Ic6pLyFnajb0xRWCHHNUPjAPgKmAA4A8RWe5rkDB6J27fEnJOYlfkxl5AlvylLq8pCHyqtOzipF1kzaEy4o1QFR1n4haVUHa6ll2zH5y4SPIkIumGpzAP0b8P0uHOvmaxYMw9lrxvjh23upHgchOw44Ruiq7jVT7VUMwdSpMFAZRDvBXyo7/PAllLcehuzHC/eVKkRAYuRQcUEGhwxnjmEovMQJhfCzYRUxh2Hb/KPWLOWVpF0GVJRoH79WLrYReM0HYXQYMpl/Wgxru1VC4J8RdZxWqRP88OXWYEIEm6v2dRNihcWBHrpgmYueBdfvSzA1jc3rRb8IRxQI7HPDFPEblnQS8O3B4kOVe9ms+t9GkVwvpaoENRBosyzDSFtkvelv8mCDgemwpH2XcgwGa2XzrckSBRCqZ6+lRnGScqXbXLIdthnTLJSakqOsi6PYAl9Kd
 JGkOi0Ii
 cr9Bsy/E64wnbTJsImfLDIgARNKWKpdU8w+nSs9531Il0LAmtwNcSaWuvwmFzGS0M6wNm18QTMRIInsGKrAFfG0UGsUjZWmQ0y1QOFPBirnQbJ62Yv/arQsvdinIKA7TrefNAwqPs8y6gDO0mylGihKbf58ItZnBRq66WaiEiCpu8SM1Ne54KBd1qH190XcuuILOPkJofNZiF5DwMm28GrVTAmFRHQ22OBYVVjCBJe1kNnBgvq+s/k/gfbSCkKSHePmNAX7jCmNXuLt2x8Zc5r01RCxxCEaOZQheBJFJTP7/75TIVXcW25sgW+qk+wCJJ0c6A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 18:48:02 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:

> Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
> hotplug, and destroyed on pool destruction or CPU hotunplug. This
> complicates the lifetime management to save memory while a CPU is
> offlined, which is not very common.
> 
> Simplify lifetime management by allocating per-CPU acomp_ctx once on
> pool creation (or CPU hotplug for CPUs onlined later), and keeping them
> allocated until the pool is destroyed.
>
> ...
>

This is a tricky-looking patch and I haven't yet recorded any reviews,
so could someone please dig in?

Sashiko wasn't apply to apply this patch for either the v1 or v2
series, so no help there.

Thanks.

