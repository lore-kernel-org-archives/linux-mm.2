Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C25E9A762
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CA516B0088; Tue, 24 Mar 2026 07:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B496B0092; Tue, 24 Mar 2026 07:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8806B0095; Tue, 24 Mar 2026 07:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CACD6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:07:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1615D13B95D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:07:14 +0000 (UTC)
X-FDA: 84580679988.24.AB6A61D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5A716A0013
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:07:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APOR2RgC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774350432; a=rsa-sha256;
	cv=none;
	b=3y0A2bXQgYkd/XMK/nqpbnD20aws9OUWTuB6FklLXbiVVxxHSgjZ0PIkM4bEk3p8kCSc0a
	mX7URRpoHEz7n52t+xRpy5DuoJIt/uyjU2gaT7WsaCVfuzrdzFcPyNOaZHRwz9R7RrVgzb
	DpWOXTqxdXfWP5aqkOu92YZ1RqsDUto=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APOR2RgC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774350432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tp10xEWBhgg/NXudiBdgaGGJS13LWJ93cs67dTTmyds=;
	b=PYgs1epMtJn1QL8Njazy/1puhK8J6ua//vlxkkYPRa5CfCebSbZGdDXLxBta3UH+YBuEm+
	1/8xkRifWExM/UKtLqtGANQ/ohbGco+59PaE4TnTLu+g47YENiGFWCtp06V91z3b0D63xv
	p+Sx5TE/CWHDxg3jjVors7uNSXhc9DQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F9AA43EF9;
	Tue, 24 Mar 2026 11:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F2FC19424;
	Tue, 24 Mar 2026 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774350431;
	bh=ILZm6Nn3GFuzLoCBZNU1GwHqsoG1pMOD9cC1sT1BBeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=APOR2RgCYtJ6XNgp5jeQQlhpGq+v+0zpaY4ooCHV0bnr8be4l3iJLYzExY6mtTTE+
	 bu2g44hm9reWblXnOG+zYuVeyAheEQSra/zTH/RnWg3gnGnNvH3Z7TTQeMFRwF6WWr
	 rXewtFbZmAcXkIm5cChbo8Yupd4mGGbcNSZKZ1bQgYZXGaS4oW50iVGACLtRlp1fwG
	 yBhWHjKwjTCS5yC5DvOU0AbdjpIfTjWdwb6D6VwxC+VuXQ0cMqQrJ8bV+9I1ROCIoX
	 e8cpy6aJWt4slmN1C6DGmafC1DrPOwpFdnYI/Np3F0puW6uVQvN3jAhexUc7LpvtNi
	 GMGMa6ORlxjjg==
Date: Tue, 24 Mar 2026 11:07:07 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mmap: add missing space after comma in vma_expand_up
 macro
Message-ID: <738799c7-1087-4660-92d7-006b55938689@lucifer.local>
References: <20260324102909.26847-3-giorgitchankvetadze1997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324102909.26847-3-giorgitchankvetadze1997@gmail.com>
X-Stat-Signature: we7kuhpipw5q55nkyzczi9mqkitqdjth
X-Rspamd-Queue-Id: 5A716A0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774350432-18802
X-HE-Meta: U2FsdGVkX180tv7r1zvwxOPJ4cAfdpYvPN5H5wWfrItDdHUCK69N1DoG8XXOWTfk4rtG5u0LzVur0xObaJdUzKX4JQxcsxCwde0ZPWWits5nsXifNxW8M85/BKcHkdrCasmTMTs7o4sDFFI7Wy2wlIwytv7UQXiJVHy7lfPSDlhmWAovzzFiSwnGa+7jMxHP4y96j7N5i2GvZKL6hF6qWbJuO+aeCzGqNcn+2ufuvMmW95QZUx5+l4qyccKNlDbUFbWyIJ4ClKGJ6PiOkmNSNp4khGUjQaSNIJ+PbSLyPiRvcsZv1fuFvnYd4Otl+dKyUxaUb1QsErXAAnGp/BxR+itFm23SWALflWJtGbTRg2YOAEyadbQ7VK7d+BzHJswWO3LPX0Eua4dcEjceoodLOfXO5P9To5jedWIJ/+jufAW1KvxyqtlJfCpxkOoMmQOwLtnyEiwR0iSoHGylBUrYn0wVLbLaTeelILt9f0t0gdi5RS7msitHUeIorX0ZeCY8kF1lRRg+LXU5ywfKDSY88ug0VHyPaU+41KYJDYiyiEm39DniKDudIOFwz3IHbJI6/alSwL72yJBAi521OPVQXn6KXSspvu2KUE5huYOsJZrxnJfC0HML/EWUyDkOBiBFC+sms55gp5SgDhnDO7/NEE5ymBqZCr0ZWKdZEQx7pHX2daXOUMW1mr40VTfB/Gdz9voDFFR73AUIPCZv71x0v7ckYiW+rBVBvxHdRv2VtBA0xCyc/QB7kOu/zm6mIQGm6+ZMWoHyGB8+LgVlygMH32eewReWLhw5bSO051UjJAqo4BVghh8h3KS0M5O/cb7T3w6WlTDc5k1laRejq1HJQ4ydPoZDTPX3NrmmUDQkGTVtvu7O6JVh6C9e97y1bTjVVrJOw/gEC59nM696zWWmQt0/3xrr+Oi4gCtxyvDB7uN1RT3cb4RaikU9Yl9uP1IEIRVwdKuSB8DpxDcQM1J
 pWfuAcHE
 +q7LIDIavOQ48Rz27tzRKN0k3dB7jg+rpzLSZRE+bMbXC82dwL9GB513mt7ABiMI99vfdPpCl6CgnZ3uVCA8xkYErv93GQArkTYesb+UOpVqGqYk7x2g+xdaePoA6Wvxdo0mt0wGDzb60nbFdkSjIPfCzR1l228f+5fpsTUjxKfcovcfxQ3VdtSbVv5eAbym/5tPGv5XYzZ7g36P7GcPa+W4tNY8CvWW7XwReEJ7s7NRbgFfETnHtzOA2FRWFcH89VRIYNVK/ktkLnKKoOVmSPMREHVEoKJuRdxTl+TbCqyYgTxQ6kTLAZUWePA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 02:29:11PM +0400, Giorgi Tchankvetadze wrote:
> Fix minor style inconsistency in macro parameter list to match
> kernel coding style.
>
> No functional change.
>
> Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>

This is fine as an early patch but as Pedro said we usualllly don't take these
unless you happen to be touching that bit of the code anyway (or code near it
etc.)

But it's fine so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/mmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 843160946aa5..37414e4ea362 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1001,12 +1001,12 @@ struct vm_area_struct *find_extend_vma_locked(struct mm_struct *mm, unsigned lon
>
>  #if defined(CONFIG_STACK_GROWSUP)
>
> -#define vma_expand_up(vma,addr) expand_upwards(vma, addr)
> +#define vma_expand_up(vma, addr) expand_upwards(vma, addr)
>  #define vma_expand_down(vma, addr) (-EFAULT)
>
>  #else
>
> -#define vma_expand_up(vma,addr) (-EFAULT)
> +#define vma_expand_up(vma, addr) (-EFAULT)
>  #define vma_expand_down(vma, addr) expand_downwards(vma, addr)
>
>  #endif
> --
> 2.52.0
>

Cheers, Lorenzo

