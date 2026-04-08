Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CB6105D99B
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 03:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EC46B0088; Tue,  7 Apr 2026 23:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF6C6B0089; Tue,  7 Apr 2026 23:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115F96B008A; Tue,  7 Apr 2026 23:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F393E6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:21:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E6B51A0971
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:21:11 +0000 (UTC)
X-FDA: 84633937542.18.4B203A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EB28F4000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:21:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLEPRTWT;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775618470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slr7IK17CaWYSyalInYKoii9g5wch0RE+FjGRJ1lOuk=;
	b=Kac4gJdW0WF2qeQTJVhTkreOc5i88V2b+YKLkpsRbeTJIBryB2nJf/0zrl/G7Qu0g679Ek
	JM7BlIwGbXpj0dnuwi41AjwpPwEY7B+lWirZQD/brVch6W1e5Hv73PzeLIV743tkif9LYk
	zjcsbp7gw/nEPvi6/Tb1mRLrWnN+oDU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLEPRTWT;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775618470; a=rsa-sha256;
	cv=none;
	b=4Y919cIny76M27iT56eTEd7/7TwItEou9oK7MD0CNnuqJ5AJdIuiGz0HS94Yc7RWIqq4yb
	xlTRtNr6z2vDhOx7m6oCkWw9EMcMNWY/NYyvff13Mm/jUwQk8b1b/PjVltBC64n9vX1Cy3
	Nvk2TmWJMgw9J8/FC7OeCSuBIBc8NGA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C44C74434C;
	Wed,  8 Apr 2026 03:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D6FC2BC9E;
	Wed,  8 Apr 2026 03:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775618468;
	bh=KnNKUv3eJ5Gv1Q9yr28xE3tQt7BYIq2Uf+I/m02aYU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GLEPRTWTWMuvM/pn2Zr3e5H/+PLyJBECnRsfx1IGeGWsRnf26c+Oi0w/RvsESOVHG
	 7S6pzzD3w5uEpO12RHBP1XtQYody9cJRCesG7dUo4GzeMtXVwmTgAfFSFt2l4GOwpR
	 PVha60LqnCGgwSU4v5KZEMFpOqENdbT2EX4MAmcxDtlorLrkPkv0+huBcH28qH+NeZ
	 UlOu67M81w9Zu2+ad+L+6cftiWIjQNvBqUk2YlIcW5bPrGuRAu5VZ7Mb1LbVME+uqT
	 eOKKLRs4RFg8U4iqZa8vWcu0RNR2zeyb24O5lF3My47GN7sgy9q3aHitw6UO66K0WE
	 eNox0fC2T52Zw==
Date: Wed, 8 Apr 2026 12:21:06 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
	peterx@redhat.com, pfalcato@suse.de, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <adXJop1d0QdH2Mwm@hyeyoo>
References: <20260407081442.6256-1-komlomal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407081442.6256-1-komlomal@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: EB28F4000A
X-Stat-Signature: 1qmq5xm6jcpefbh3ra9ixdz75xk37maf
X-Rspamd-Server: rspam06
X-HE-Tag: 1775618469-633348
X-HE-Meta: U2FsdGVkX1+hA5+PhiOVnTbFbVfDblDkkdvEGZKimLQrZQLIiEmKHXM8yKGbPvlfufD+Ash89NHAV0sRq1N8pbs4aLKYqVIgr7VYUkn8TFZQyXCZJR3Ly86bPHpGH3r0tftOsumh0HY/EirsIUwbwT78U70mdREa0sRMBeFIH/eiWvIMaJNp9DAeVzn5QAXe1cdQTw8FjDQ6YiYWPhXFqoLOEvJN8ZqaIS1E+6qXIEpo9/4v0NRxZM7BDtY9wRgDic1botiBVlD/ClpiFy2KpDUzrVaflX7ujxo1a4rda1nac1ToEeIRf724paKYQtFl4IxjMbvguvmi/YdCC12b2luC9XwXIkMKEZN0C+2ndaRpGFDW7hZNLRbQ+knUjPWWn8Na1c+flYrwivewkjRpQ10a19bqja8qESRT4FPLnVM7VSe9yVY0yKKutzCoOGOM906/6n4w1q+2LCi/DCq3b1qgGwlx5vU53Yh/4GEo0oVVTKORG35SyFBp0A65qSuKTpEz3GZWUAoBckUB6ONOJWSS1E27Uucw3rsdB6wGwHvC/eakgZddWqXy6Ml0J/8ZNqWMV8OBvciA7kJkgvmjO/xx2q+//sTNJHv1kccRbA9bdhDuNmhfXLZpf7N/9YQQbRpylHK7gp57FYiWQrkDGhf3CDyhAF8uj1FemsTeEHhLsR0ApVKxPjyRzQNSLJnAbU3uuJ+uNfqaJnAhASNEeVv669VrC25CThXwwvj4lajfUZLW3pMVVPCDsgw7mUSjYD1C+1gAR7fMnHQI6Tzivk++6rCOZgu/vCoVM5TP4NVbvdTiFr/0B5hoRljSEu+4N/YuG/kSOnW+Fpw5JTgfwgA+DHzEFubeRaX+QLSUu2VtFM9LnCta7V19YiRGFXi8ndj//Jj/twMkxutnKSgFf4KvWtJ7KTSsz6qctGYR6fAKVNuFqlzX9pHlTPlz7/ElHetyLtwrrR5RFgXD09m
 E/oStSWo
 xpCR5uGQQv19QvbO4l1/1Nph2O47pNBFeuYs3gAhZe4uvD20/buyax/RsN0tX6h86T7pfejguuQMNriwjL9bs/ozq1dubG3U/mcUHuUdt8XaHq2yOg6uKqX9Qo36wyQzzYeXNfst4MWCERTRdw9fd1q36CuNx1KOgslRKX25t6W238wjBqPYM1HuRsLlgdB31YOA8XBHAKANlYCXDpNRmCjHqCGywpjbSdepLGuEc5z6glZuDjIU6oHFnLc2eDfVR0kYjDwgMAdOqIF0OckYJU1odj57W5RVQ3tObfZYoTb+XL9+iujza9Bht9dz3NZoch9V/RYqlaEMzb/D+vUNgD1S4Xs8hpad4AKsh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 11:14:42AM +0300, Denis M. Karpov wrote:
> The current implementation of validate_range() in fs/userfaultfd.c
> performs a hard check against mmap_min_addr without considering
> capabilities, but the mmap() syscall uses security_mmap_addr()
> which allows privileged processes (with CAP_SYS_RAWIO) to map below
> mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() uses
> dac_mmap_min_addr variable which can be changed with
> /proc/sys/vm/mmap_min_addr.
> 
> Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
> with -EINVAL for valid memory areas that were successfully mapped
> below mmap_min_addr even with appropriate capabilities.
> 
> This prevents apps like binary compilers from using UFFD for valid memory
> regions mapped by application.
> 
> Replace the rigid mmap_min_addr check with security_mmap_addr() to align
> userfaultfd with the standard kernel memory mapping security policy.

Perhaps worth adding

Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")

> Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> 
> ---
>  fs/userfaultfd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index bdc84e521..dbfe5b2a0 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned_range(
>  		return -EINVAL;
>  	if (!len)
>  		return -EINVAL;
> -	if (start < mmap_min_addr)
> -		return -EINVAL;
>  	if (start >= task_size)
>  		return -EINVAL;
>  	if (len > task_size - start)
>  		return -EINVAL;
>  	if (start + len <= start)
>  		return -EINVAL;
> -	return 0;
> +	return security_mmap_addr(start);

Hmm but it looks bit strange to check capability for address that is
already mapped by mmap(). Why is this required?

>  }

-- 
Cheers,
Harry / Hyeonggon

