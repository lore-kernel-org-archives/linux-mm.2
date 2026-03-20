Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 626F3108B901
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98866B0089; Fri, 20 Mar 2026 07:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49336B008C; Fri, 20 Mar 2026 07:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64526B0089; Fri, 20 Mar 2026 07:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1E8E6B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:37:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4446A139079
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:37:10 +0000 (UTC)
X-FDA: 84566240220.27.3D872F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BC0211C0003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:37:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATiMesD5;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774006628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JaPgSluvwp/ijj7VXv49o68dSdpBNbhcKJTSqa7ZvmU=;
	b=GMdNv4E4Xc6dRqmbb7lgsi5v1nOVyZ1xC4/LY31H/+2jaQ9jddeC1VY2IkgKX6ExpvEHsN
	FqHqlkRkahYR0+SKXVHkgdtjrsZR5EG9Mz6U1Gt+zyI5+na5PrDxA+uVb6CCb/c+SWND91
	ywQJRAHoGSx9xUBaIRutA49Xg7MtZyM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774006628; a=rsa-sha256;
	cv=none;
	b=8O+BEAsUKTs1RA9KIo1v6G/dkE12ncsOr1o9tiQfUSDSsfcf/WX5fI3IKMnhIAPk0lEWxc
	f8XK+GFWmdbUDOy8Zz7i7DVygIMJ6uLbWbNeRKuxO7QTdDOGJYp/fa2/lPd0rTcmy9bzKI
	P2AUEch29ogT69Bigk8OCTPb8HoTbjM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATiMesD5;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C100B42A86;
	Fri, 20 Mar 2026 11:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082CDC4CEF7;
	Fri, 20 Mar 2026 11:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774006627;
	bh=ODUX2J4py669jbR3MwFlsEzBfVh9nwBiRsgKM8tmtBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ATiMesD5y01atO3/tS3Hw5QUIcvIspmzjXBNvUHBDF4ttzIxVhVAIM+RZiryMqH0j
	 em8L9FX0QnowlymU12ASvGnZsKMDaDGRGNx0WhWUmezu7eC/sfjiX8oyHPc7t9e927
	 q1AbpOZWH+m0lWlnqEEOHjAeoVWO7FaTUHLVY9YMDAboozyFjS5aDAfjT9NXB72Veo
	 CBBHARERFsuQPgbX0z11B7Iv0ImW0kcfb97Zt/fnucfG3NT0QbIV+DzpYK0QYy13G3
	 kVpF6nYMRZt9V0adKOJ7b3ejPFT3SL3msJ3XERIcMdV9wlsSWM1oxQto6OR55n9jka
	 S80mHWrVxEp0A==
Date: Fri, 20 Mar 2026 13:37:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 2/3] mm/memfd_luo: remove unnecessary memset in
 zero-size memfd path
Message-ID: <ab0xXX051uk9S1rl@kernel.org>
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
 <20260319012845.29570-3-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319012845.29570-3-duanchenghao@kylinos.cn>
X-Stat-Signature: jqycirypa36x64nn6ym1enar7jkjqmq4
X-Rspam-User: 
X-Rspamd-Queue-Id: BC0211C0003
X-Rspamd-Server: rspam12
X-HE-Tag: 1774006628-238061
X-HE-Meta: U2FsdGVkX19ZjUDnJMYRhM/3h4x/RnuL+pue1V0qLd5p+2zEguFyomKhS/EksZXkSG6Xn+yaj/Ryfn996CuxIj9IxFlGYPmutALCRcDHW03jz/LJCuVzoR9nwhOQ7gvxctLbaHq6/VbJkm/Ks/rwF87uIoHLMIaDdyb+awglJnCY+1CQ6mnqwf4GDqXTaLmKdVvbcFyoqF2LC3wn89UJ7sse4+9FVS9DJG13S1oRYOrYFxeA5XGx/wthoZAlZaIdwQlsh+HpAxTPeEi8OTN8Z656pnxk+dyZFbmZVyUoWV/ePtyX7bEj+5YTkXfaKtwjZ+exDDVBDxGsxE+zB0RStCCwyuEP1RY4y0bfzfhkAWHJQQGo3pNhs1bO8tmqEzqKOG+BBCgJaFpsDTRQxPpgmwFla667jdQvW53MV5ZlpSGc1COM/1O4zbSIs7778siyNSTEqPkIEIxTxN7NKulAZFtinhni+hPIlAnyNrTznvig9bpLgw0Hmx3/j1AWiJhpUwOkU7pa0cmLM1n+gy4E1N0bNH7xe7KjfJt87cd6hA7VH0fBNUCE6XotG8uSBfzwg9CIM4jiYDFHYtEHKshVFIcvak03qmI4yTJTGrTA2aQ4WIdmmqCbdByPjoRrILztsz2Aupi53ixaSOKqx5pNOAJHDYkfHwoTaWWPHaVgY1es5d5ttJD05RRc7NlljZqgGKTIS29F3sF+Vlss5sXnytl7tNQ/x/ltpvXzecDNssJEacJ3EdKiPcHpVmUaAGR0s+842NDo//f3CkaHsWawrZOHvmgX8TabzseVzdgRWiuJMO1yL0prp+oaRiJohrUvVKxzFTSimDnhJEZpdNKPVm46tXEpE5Vx4DdJstq/0gE+pSL8nTrgpqY+5ExqQ3mrUw3wHDyAzBAvJBe8RrWFTTuKVxxrkdrlb8wWJfUxtbCLo0AcbkqNj5U0tGKUKjp2vLarHJrGdbfEj06XFpS
 aq6Q16GT
 4NCq+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:28:44AM +0800, Chenghao Duan wrote:
> The memset(kho_vmalloc, 0, sizeof(*kho_vmalloc)) call in the zero-size
> file handling path is unnecessary because the allocation of the ser
> structure already uses the __GFP_ZERO flag, ensuring the memory is
> already zero-initialized.
> 
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/memfd_luo.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 5ddd3657d8be..413df8c75c1d 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -103,7 +103,6 @@ static int memfd_luo_preserve_folios(struct file *file,
>  	if (!size) {
>  		*nr_foliosp = 0;
>  		*out_folios_ser = NULL;
> -		memset(kho_vmalloc, 0, sizeof(*kho_vmalloc));
>  		return 0;
>  	}
>  
> -- 
> 2.25.1
> 

-- 
Sincerely yours,
Mike.

