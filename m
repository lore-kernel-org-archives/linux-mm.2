Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC0FCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F548E0005; Thu,  4 Sep 2025 19:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5C68E0003; Thu,  4 Sep 2025 19:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849988E0005; Thu,  4 Sep 2025 19:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7456F8E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:49:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36963B98A8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:49:43 +0000 (UTC)
X-FDA: 83853212646.10.F655CEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BEC0440013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:49:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lyL0oixy;
	spf=pass (imf11.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757029781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXe5ay+6i+g3rJzW1RcB2PTwCi91i1l+IAL8/HR6JxM=;
	b=5OiiGkVowJnVaV9Z3ccO3Z9butrrknkPJ8z/nA4jmBEsr38UW5PfLlHx04rdsboVVg82hq
	BcVufD+bQOK/I19w0OSIAChg83zJkETodHBUSAjzovYjjKWFAnAYZuOc+SlLVH1267BCrU
	Ui0kYxKY5Qc1I//vkyNqN8qzim/f11M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lyL0oixy;
	spf=pass (imf11.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757029781; a=rsa-sha256;
	cv=none;
	b=1efv4/VCH/6KMr55isDgZ8pZ8YxnjxnEsjw4oBee6d9i3m/FdVyh2tuyMSsijTC+TtBqMX
	ihcLnqgTy/dVFJp4ZtGLbby5F746X8w+qiJ/+gVqKWIX8BckreLwm4OMtIottNTn2iDmAV
	whxUdsde9AfB20Odvr3FoC4JLAirJLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB28F60195;
	Thu,  4 Sep 2025 23:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615B8C4CEF0;
	Thu,  4 Sep 2025 23:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757029780;
	bh=BD1dRu8L4G2KUFxQwJiVulBBTnT0MQ8MPDUK0rLqLgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lyL0oixyw2+2ovVX0RfwivH+ujiPNHbLZ/YRrFLypBiwysp9N1M4+ZpKXg2R+a1AQ
	 krj0onYIblEtFtdTgN31HH0pse/2cdaNDhR5DR9o8PrgP5yuPHnlXaLyyHg/rLKlG5
	 xe3vPxDMRZAPWS+wV5KhLaxl2rni2j+BlZmMvGEH02hs2eOoMpIgjYLHQs4oV7R3AZ
	 REl3u6FKW2tDdkvIiAs3xtRqp747bFMe1gmeVFNSuaLRSW+0UJLiA5AWV2Ivlm6MTA
	 RUUo5dtFYRKfvVCk14OybyeBhQauatAkvBk+g7/bUf8dCGCLKs4BlVJv1FbblhTzxQ
	 gvi2h83st+Aww==
Date: Thu, 4 Sep 2025 16:49:38 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/percpu: Add a simple double-free check for per-CPU
 memory
Message-ID: <aLolklCw7wFbXrSl@palisades.local>
References: <20250904143514.Yk6Ap-jy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904143514.Yk6Ap-jy@linutronix.de>
X-Rspamd-Queue-Id: BEC0440013
X-Rspam-User: 
X-Stat-Signature: 4cq1t95mady1j8iu4rd4egthdpa4zt74
X-Rspamd-Server: rspam09
X-HE-Tag: 1757029781-875820
X-HE-Meta: U2FsdGVkX19TWMuxHfoJWn/iFcgXS6uzUFM6ucHSEfCP5zJUebfy/nP3v8lMMCqV5KxXjHnEtJ1kGC23AMhHSA1zPAuHidv4eIS+XFWfJwRUkCG8AWf8i8FwliBpFtYqX30KpsfydMJY3Kqkyx50lNdWfenU1pwbw9slmmGYJLEH1u1+hCZutLQ0GhcCjEmiPxdSKFsNSLSe/mx00Z3ipuhGDo5jeuz2JfOPY7y6YAkcl1pD6sOMg4kp4pGNe/YWSPdbBWwLz7P5fI6BIb7B+SKZI0TMN88B4e4diTP8YeHiA5nBsDmCWZGkFEQisK0dlxBNW3Ee4ZB/apBx3JAqByMHu8kLDiJUvsU8ZFNZu6Kn0zVj28YhC+r2IJVVwXlA7RzJrj4LYOMrFKqW92Yjh2xBV5miDQfAFuNoJiyhdHmzq53E/I6UcRjn/7gab3I6XThKe4ZYaVe3oQAfGyPiCuZYJjHdUf2cHa1+BoL0BwepMUVX/iE+wKNkRyH/vTqjg0h3HdDBklBEXCO7mTzVX60osK6kjo5pOdiulOmCOWtnqdbDiUUkBuhYXzVsjNZk2sL41a/QaeOzQTc+nGgVXGiQFamNnLIZjuyS03i4nt91sGH8drCc3EsPmXyCtCYQvRbU5yHs8mhyL71Hc5e4XovwbFAo1K78CRCSgUc9Ve4yKFLdYLDW9tnIEDickU/fyXvkU5bt5a4Q+oiAYjF68oPYyUvZYj7NDx6ehUPm8dTE6j/XcPcMMQEr6QyKe0ymidhA+5EcylsxCr05JwxPKSNUUk/36oKgjo1UWOaDRSvUggcSv2eieSOONFVjvM6J+MbN26lWspKFXshIu9RTYU/QjlMQyedZE9M4ceIxjf0++3MJfuJ9/luv/B5cZT9x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Sep 04, 2025 at 04:35:14PM +0200, Sebastian Andrzej Siewior wrote:
> The free path clears the allocation bits in pcpu_chunk::alloc_map. A
> simple double free check would be to check if the bits, which are about
> to be cleared, are already cleared.
> 

I thought about the double free issue in the past. It's a bit imperfect
because the same pointer is handed out with no metadata for future
allocations. Worse, the whole percpu chunk could go away too should you
be so unlucky and then the whole path to get to the chunk goes awry.

> Check if the bit is already cleared. Issue a warning and abort free in
> that case.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> I managed accidentally a double free recently. This would have noticed
> it. It looks low overhead so there might be no need to hide it behind a
> debug switch.
> 
>  mm/percpu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index d9cbaee92b605..a2abddd85294a 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1276,7 +1276,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
>  static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
>  {
>  	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
> -	int bit_off, bits, end, oslot, freed;
> +	int bit_off, bits, end, oslot, freed, free_bit;
>  
>  	lockdep_assert_held(&pcpu_lock);
>  	pcpu_stats_area_dealloc(chunk);
> @@ -1289,6 +1289,11 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
>  	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
>  			    bit_off + 1);
>  	bits = end - bit_off;
> +
> +	free_bit = find_next_bit(chunk->alloc_map, end, bit_off);
> +	if (WARN(free_bit != bit_off, "Trying to free already free memory"))
> +		return 0;
> +

We might want to test_bit(bit_off, chunk->bound_map) also to make sure
we aren't accidentally doing partial frees if the region becomes say the
second half of a larger allocation before the double free.

Possibly good to move the WARN to free_percpu() and exit early too for
the other hooks rather than do all that with free size of 0.

>  	bitmap_clear(chunk->alloc_map, bit_off, bits);
>  
>  	freed = bits * PCPU_MIN_ALLOC_SIZE;
> -- 
> 2.51.0
> 

Thanks,
Dennis

