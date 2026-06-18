Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D2CCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A7B6B008A; Thu, 18 Jun 2026 08:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEADD6B0096; Thu, 18 Jun 2026 08:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAAE6B009B; Thu, 18 Jun 2026 08:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A39AA6B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:27:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B5D81666A0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:58:13 +0000 (UTC)
X-FDA: 84892582866.05.D31E2D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C424C180008
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:58:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIS8zgEY;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776691;
	b=fB8R06rf1zAExwmFIDQuBbVQA4nEt81Tdawx+qitDACs738UyBSKB8mZ7Ytq8jr2c9V7uN
	pS6REYa2t/3j4ljYTl8RGNduZ2paEMABzrDh1tYv/0t4JGt1bjbiKCoiidpvR8DqwduxBF
	wDX5lMBPCGwF2NmZy5AH/DeUjrbaG6g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIS8zgEY;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiNVS9vkzE9TdVgyxNQuAslrVNFTDadDu+nPGoDezg4=;
	b=i2CwkzFz+sXcjmgs1exou4bCfB559RtTOiXzIqvMB1ZRvYBMIDHnaaKhV7N8j65Yx/RrG3
	yfzMqzYRuYTXsUZ7/i/zzTBrwU9DFzgJ5dgahhLXK4iBQYP091HUezzmUXzJiB41131pdG
	v2ifM1XNMh6EimA7q+YRrHJgeEdbxIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04BB26012A;
	Thu, 18 Jun 2026 09:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86091F000E9;
	Thu, 18 Jun 2026 09:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781776689;
	bh=tiNVS9vkzE9TdVgyxNQuAslrVNFTDadDu+nPGoDezg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eIS8zgEY0mshL+1CaTXP0EN/b9Ga4VR/mX1OrV5Z6f91jnBt0gg7xwzcBy5ePpSob
	 wwolzpxTuUSZ6DBpcCTCN5GSHypgJZowuMkzuz0N2cM/Edy+gvQA5jUhWYWgZ/0Gov
	 ADoJcVCU2xlBwk3AVX3zANkmQTOocXctyAEDRKJ/NemmiQ2MPGKPmWkQtGB42CCGB2
	 fTpX5Ee8++WrXhnS0K9G8E0zsnB5NECgadtDVfst6TEC9s5FouJVamFRwNJiRz2VIS
	 Qzwz7JpWVUDW/bypyDIylmVl0gvqkVjcbY4lbnCmPbEIJVeVo1oTirQlXld/qCxEHN
	 R/Eqe2T1gQrvA==
Date: Thu, 18 Jun 2026 12:58:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_numa: remove redundant nodemask clears in
 numa_init()
Message-ID: <ajPBKyhjzeDWKhRr@kernel.org>
References: <20260617163919.2544899-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617163919.2544899-1-ekffu200098@gmail.com>
X-Rspamd-Queue-Id: C424C180008
X-Stat-Signature: 8zofnsaujt17pj7c5ccckkc7p98aio35
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781776691-682812
X-HE-Meta: U2FsdGVkX18lBy4EjCEwZRYKEOd5UuKHEMOOTiuUb8VHftJksEniVT7ly13OmIq/zn42Bk5lLDrzat+T9bylE0U17qf71wiSINKWJqFz31JLaCcHqnnLiilvoILM1JqtdkiNYd2ZVSe2mhSwzXwc+RFz6wZRlqTXUrEsc8615zB7pc/QBMwHbia2ZHftyLD6w+wBltk5EmTyKIB5vRv8rOoBfDtUD0C05A6R81LAjIxMavUyaSuAhbAW9JgcTVjN/4fePUPyqeBw0uy5bfZVtREsS5c1OFQxJHSZsnoGJNK7WYEbzGETUMZdRVD3nD4+kO9quLgZQGINl+j+mkLJF20gvt/LMiC1Soa+ZfFMjA0F1GTELKaSSzZ+258Gu+MHQxDaQrchxOzFmMXGMBNkGSF+AFpKpAs4C/WQPcpAjSdXVEBVfHNkuYwwZJfIYpmgaEbJI7i/CKhH/MztUMsbuuNnC/5ll5rMpE+r+XLiDxeSMqWw+lhD3P2RbpvIkyBwBAZg6+YxNEQ2czJI8Fayt7U/8WOiMLR/MuhdQz7xdlPOhAzhS938e+BGNVAgN3e87oxTgTJiU6oEy3Kxlf0xAyYAuKn829VPGyupZqqAUhs8HyCaeKdq8C8IvajqoPO+8MC4ZQ8qu0PTcl5XXwINXuXuIjiFaauunbK/6qQGV58xJzToG+Pu6GJ38a7hCOgzZaWIrlPzf/ufX+4bL7EPUerrNuQHoSB7zrkLN1TvMaBOem+aq/7dvh00cFVhrgQnxdFBOwhke531xACzkriPReMg97p9HQdqFLljkAurZ4cgOajOvgGxtw2N1222V5YMotoMRO7VBFEuQ+8StXzKt1i2EbpulocYygW7LdnsyJtNscUhQfrFcoOiG5wztX14E+bI3FvDmlEAXKnxJuu5iQbdJMSS0eoXaG0NBS1rqpWo5svFRwvqXGkQOU/8j8cJEnjPD74I6yttlJ9e/4U
 vXRe5Z2D
 gr5HTL5ajQR0ZshXXOh+I31hQn3Xt21EpF3THWWYWcRC94QviYENx7LoLKML62zV08/j+k2m8kVR9l53WhfJOjTV561j6B2YZzZ6ETk1wkDRUyIUGVcaM/aijHcXSKiNZ1byafYPbRunk+yaSavXxisJ056xU63w6XlYMHaPY8xVs/DKkvzjSyp7CLsywYFb1ZZYTmTt3BTEEcO0acx9r1bJAx5DSiBS0RWCTGfwmhw7xXHn2Rkq02un86XEaNswVcDAQpwO/8hgXk8ngwD4C4tThHn4mjTDo6EOE+DBwWz1AfNLT0A5oGgW3LCZconzhSDq2kU4gmTEMV/7xE9ccDcO4OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 01:39:19AM +0900, Sang-Heon Jeon wrote:
> numa_init() clears numa_nodes_parsed, node_possible_map and
> node_online_map, then calls numa_memblks_init(), which clears the same
> nodemasks. Nothing uses them in between.
> 
> These clears have been redundant since commit 767507654c22 ("arch_numa:
> switch over to numa_memblks") made numa_init() use numa_memblks_init().
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  drivers/base/arch_numa.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
> index c99f2ab105e5..442ea239bba7 100644
> --- a/drivers/base/arch_numa.c
> +++ b/drivers/base/arch_numa.c
> @@ -231,10 +231,6 @@ static int __init numa_init(int (*init_func)(void))
>  {
>  	int ret;
>  
> -	nodes_clear(numa_nodes_parsed);
> -	nodes_clear(node_possible_map);
> -	nodes_clear(node_online_map);
> -
>  	ret = numa_memblks_init(init_func, /* memblock_force_top_down */ false);
>  	if (ret < 0)
>  		goto out_free_distance;
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

