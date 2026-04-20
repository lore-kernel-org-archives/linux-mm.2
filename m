Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC59F36C24
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDCD66B00F6; Mon, 20 Apr 2026 02:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65F46B00F7; Mon, 20 Apr 2026 02:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BE36B00F8; Mon, 20 Apr 2026 02:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 931926B00F6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:49:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A800160949
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:49:20 +0000 (UTC)
X-FDA: 84678007680.10.A4C2352
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9038140008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:49:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KH/VEjJW";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776667758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNonYmey8PIO1muUET31smFdUU0KGSOsTi3PZpC6kEg=;
	b=kpXX6E6sZ/fvt4Q1Sb8YMmnMLFP0qdMAq4E6vwFehjD1+BFmuYzDZX8AnTCO7naIPIy0MQ
	tT11fdoyKsaMkYLP2SwidDsIFyplRAK/5IB4iDie3MJyxF2HVeHERNnXghxU2LeuX5vjDa
	q12BIDBb/aDkhjp0fjDAr8XUUhiavrk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KH/VEjJW";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776667758; a=rsa-sha256;
	cv=none;
	b=hp88JXjVDkXKhAVoNHbAyQgc/D9qGUUfHaLEgisKt6SQwKymKwdFcA8NxWGeCeIo42k1Fe
	f8GfYeFEZMkXSfQ4/Prw9PEu4tbIN13WKkJPeKsx7vFZIeQqzlyBSeiPlGkv8ADoPcNfhU
	1S15ZfR3CzY350Wots5uEOd6SmyM6W8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 947AA401D8;
	Mon, 20 Apr 2026 06:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EBBC19425;
	Mon, 20 Apr 2026 06:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667757;
	bh=XKBRNKWvCcL815VBJgoKOgyMCtKkS6DA4WP7oDq9m5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KH/VEjJW7x+1+vKIiNbh0wXM5dynTbaDtAmmor/UYdeDtWZsO0JhjFxH0r2Jv9iAH
	 AVYVKb5RryzAVIDpfzpzeHwRyawkDGzjYH5ACk2+azwdxI2Y2UcEcIcJS7TE4v/wQp
	 vmmhqnPKxJptPL18YXDTx+gsAzIiDx3eTZiu9PSNUybGtPn6R/2QEbK00Vr9TY/1X+
	 ELOfZVnE14I+IbT3OuVddeqtDxMtu3ul7LDS3T2XjBayIhqXAM5hsLUlw0k7H6TFei
	 yLoUfn4gVVegauS7xq1/i8CAJUwgW3pMXb/YH+amIvetlydimO6CI1Vd3hMYgXe/uZ
	 ngFpcHqpzmVBA==
Date: Mon, 20 Apr 2026 09:49:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm/sparse: remove unnecessary NULL check before
 allocating mem_section
Message-ID: <aeXMZzb_zECfEayR@kernel.org>
References: <20260419144225.2875654-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419144225.2875654-1-ekffu200098@gmail.com>
X-Stat-Signature: ppo7t1fcjkebgdaqjiq1cxawos3j4g8k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9038140008
X-HE-Tag: 1776667758-961666
X-HE-Meta: U2FsdGVkX19sHB2BHIV0dDXje/7sk2FcgBr5YiicPuXum7QwecuCJJrohfCYnitc2/Fc5gmUHinWY3rV9tts8sJYqzh4j5QRYMxoBm/QqYreI7z5qs4dI2yqd7OtALq6Jp1DBMlJRIlGu131ThjwFaqR4oW11s05aOxSrC8XPwq/wHJXS0V4uZ7xoI/OViWLR23hkNvqdZlkouth4l4DMJd3Q8yex6MnUbhMhwDdMTmDz652c7fhtDfKvYKLyYEmXNS3RnW1cM0/+cKHyy4d6pZQMbawYFNcxJgZTkp51ONt73I+U+NaMreboz6yZdQj/M7lBu1BRP+210uZGgZiBSfcXJaQKX+2yDqsuNjYyaR0oA+c2HdWf9acxf1Ahz0ozWHPvZs6gPRxS8WnAPSqgujeCLvLe2DDwnKn+8DjV27s3amniKZDstAicjKZuyVLr4EsEPLrh+cT5GZSZRFCnOqep6ru1IUF6M0D2qmlPUggXs+/hahoCuu8oMnkycACCriQpoEiWua81TG8574MDyzn/xrNNdqbqB+fvkFGMvgD4XHPMDbDZI9Zd18c+CdFkR/lL87ch2PbpYfoHbFnwE4PfiExBMMpoEY1rIMU16/8gol8aJJmkQ/J1EomtYRZfywX5Fe/lEuRzpo7vAWW/V99CWDZcmWWPis02nlkVhwW0B0UwmGEqUcpSHAF7IeOuX3WoZm1AuXh3OZKfhCCYfhncrSwHnf2GWJEudh1GGsv5tKDgjAUViSG6LFkZqS15rAiMelSp2wBm/8+bzb7MsTf9USSzLPfDdV33PU8zUC6wEwjK+8A6jzMW8ozJ66BrXW8W+pNNf04DONHlymx80sdc2zlQT+/lc/NZ8RVkPve1e8EwQvF8AexDSlpuVR17SFaRHF5EP/f2vg3AREaLyaLJBqcKjpaiqSw5YU2wIOfDXv0B4RdavQ+TkP6nkF/6QxpYONS2s8aohk2Hnd
 RyKEKE6f
 VnqnAlR9LjdxRdexPxiHIYs0+WQCWx+FGJtuYv/axvD/Vn9sdHIyNmCXTr7/JMDcUBjZ+dofO8kHoo/0di+L/9mJVV1WPbAcw4f2iki7j4Nn//j5AMR0idSRsRVEdj6V2/S7vRRD4O6cNVbJMhVvaDjaC4y4NSqZj+OAqiAJjuDk8NcSoFaI+WP5zEtkbRFmDKrmFVXobjrxdcVznA6/haMKvtGqNbb80rcYp0eqPoTW94fwbrhXfKHvWr0WnslmxpLSACRki5cRc1SXlXYZ7Zn7WFWSA77jLZuvcAXmQbSayzU5O0ss9aQcFaC6vyy+evMg+f/tUetjCcDjX7izo0cPwRR+RnaH4g/mZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, Apr 19, 2026 at 11:42:25PM +0900, Sang-Heon Jeon wrote:
> Commit 850ed20539a4 ("mm: move array mem_section init code out
> of memory_present()") moved mem_section allocation logic
> into memblocks_present().
> 
> Before that move, memory_present() could be called multiple times, so
> unlikely() matched the common case, where most calls found mem_section
> already allocated.
> 
> After that move, memblocks_present() is called exactly once from
> sparse_init(). Under CONFIG_SPARSEMEM_EXTREME, mem_section is always
> NULL when it is called.
> 
> So remove unnecessary NULL check before allocating mem_section. No
> functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Hello, 
> 
> While looking into boot information, I found a minor enhancement point.
> If I misunderstood anything, please feel free to let me know.

I would say it's more a cleanup than enhancement :)
 
> Thank you for taking valuable time to review this work.
> 
> Best Regards,
> Sang-Heon Jeon
> ---
>  mm/sparse.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index effdac6b0ab1..e13f9f5fa090 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -201,13 +201,11 @@ static void __init memblocks_present(void)
>  	int i, nid;
>  
>  #ifdef CONFIG_SPARSEMEM_EXTREME
> -	if (unlikely(!mem_section)) {
> -		unsigned long size, align;
> +	unsigned long size, align;
>  
> -		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> -		align = 1 << (INTERNODE_CACHE_SHIFT);
> -		mem_section = memblock_alloc_or_panic(size, align);
> -	}
> +	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> +	align = 1 << (INTERNODE_CACHE_SHIFT);
> +	mem_section = memblock_alloc_or_panic(size, align);
>  #endif
>  
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

