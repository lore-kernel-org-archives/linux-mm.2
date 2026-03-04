Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F9EEB7EAC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673696B0088; Wed,  4 Mar 2026 04:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650DF6B0089; Wed,  4 Mar 2026 04:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FC36B008A; Wed,  4 Mar 2026 04:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46A036B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:09:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E13701604D9
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:09:41 +0000 (UTC)
X-FDA: 84507807762.16.AE24FBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4BD0F1C0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:09:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pMBbKSFW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772615380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bf6Jrd2glLBARvo4qTlBn9dmpgmf3FbqfUEPkdBzr9o=;
	b=L3QERydO/Q/AjCTHroCyAi47VosLgGiJQiTH95N8LyhJ0teTzeoIO2rClHFNQE3cGxJ3py
	Gal1yrDGomwTpJPgvA4J9u/jtnFSH5ivpFev6+/LYMIDEk/iVU0dL5w+zsy/dK7gAJykhS
	KCNYiuXHjOq0pJF12J4zvdBrU2yE7us=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pMBbKSFW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772615380; a=rsa-sha256;
	cv=none;
	b=YEvajEmon1ON3dswvJxRUV3bYOKnjbv6iI9SD22oqVZcCTV+LJ8DOFJqZnAtpL8LpEN/Qh
	QODI24XGRvA+NEIvgCDmykfIIrKHBbTXNCshmNwgfXvnwi+96yBfjE3SRBo9HKcO++GUq5
	H6zDhnRlblMoZExPfeq3bvGnB7M8JOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B10396057A;
	Wed,  4 Mar 2026 09:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05BBC19423;
	Wed,  4 Mar 2026 09:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772615379;
	bh=q+2F3WUwzo88U+l/P+mQvKhmPYhLgLIReOm9O+Rm82M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pMBbKSFW05wRd/QFBHktyYjvbaZBPT+tThzOTDHri1FMprTjyuKoQ4jN6e65ntHiE
	 dlQdKHsaXIjEjIPXReFptvmTVLkhmDNo5c0GRwZBERh348gGwuWJpOsIgkfVcL5jJ3
	 i/qmQrUuiKm5cpu+UffgiGFLD1MVFP9xlsHPb2+NquBL/LxqAyLSSBhG5f3xjkVtrG
	 1z5aDsEIoEaAGFpjx2DUMN/i1qOSXLAUcvoHO+XbMiWJbnVgoOrYFnR0y0YmxP1buZ
	 /C1blNCzHuG4pe04XQ5lrZ/iEmNZ0DcHm8eCqlFw15eqv8UUZVc5j8105imFU9QcYg
	 hkd43nIJzueyQ==
Message-ID: <727cad61-9df9-473b-9a79-f70ad1cd4e3e@kernel.org>
Date: Wed, 4 Mar 2026 10:09:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 10/10] powerpc: Add MMU_FTRS_POSSIBLE & MMU_FTRS_ALWAYS
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <c57b1c00145a2db1a1b4feec94cfc2917e4877af.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <c57b1c00145a2db1a1b4feec94cfc2917e4877af.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4BD0F1C0002
X-Stat-Signature: ji5g6hen7wryonwxtt91z3k9itmxszie
X-Rspam-User: 
X-HE-Tag: 1772615380-261837
X-HE-Meta: U2FsdGVkX1/9zr/ApMaLBYtrXbfl4OqX7C0nsAJa0eysLZqsN6MnnCktDjCNO1Jn3u48cZf08Cm28DnWnzmttaFGNWJT6NjVFA5SAj2DqV3SaOcrOOxjXFe/AEgDjQRFB1VaZTUJVGPAAsf82MMAu0mWUXBtoT7cGGIlfU598ghmjvYdUOdnDU4Y/lXwDgSTJ2RvDApDKhR/wkGkViqOcOuR52dKZ4TXsIydq+zXDWl1xN5+VZ/n0uCSj9WV/h2zXA1dhi2uuJ+XsNlTJJtldf2lfXYnF/NgZgFv1IH7OBIspCz/I4dPelhKhzd82eEarXKbiR2gAUWIUh60c9ODdpRnsM5WzWvfojBZn+sKe6FtQiWOhY7gbryOY6N1NPDIEIySK/Jnb0M+E+rAntzHnxc3xkabz4xLLjFBnWAs2+lZNCChLVQbYPmgHSaETmwFi2Yt24X/W6SRTzQ6+ytZU1aiLldtbCEtJwS4vWU6G9i8AODrshwFIWS/hiS69hl14/u87vTRrnWARX1jKkIprIwDV0TUOJSRvVtyWN6ZInXFROeC4PMCtE390pGBlZSi4s8PSsj5puya36+j9Ygp6bOKkUSIFC9i2rG3oVUs07ZfHO2Y/PQAIYnl899lihsEq3V/ogd9VLp+xjHk65h3wkTJzCwzZoVvivFjU84+BAcU96iA0xzylZ7i45/3SifzAyp7nCo6nAgwUNl47H+haZyS0nIKFP2V72luzzcw4cCFoc85iESoFpNHGnqUkgXcE7k42E9KoqstS88qV3fOfK/oH0UuhfKkMG/XfoSInTS/W+7V5U+nDssXc6BATUICAlf5lZdv2ZeUzC4i5I6gmH2xSi4ZzvzEPxdOAdQcVdZN9d/krRknu4Mlpf9M+XOWIhrf+6BBoEEuAfoHYWuhTIlPxB8+cQfaGYCo1aRciLYJFdVKZuIsINwdLhxk+usa25HqC4Hs3qdatNFbSZP
 j0Q79rce
 PCevkHW88VpT5DXvaNTb7nhHux4g87yqDaJDoaX0RRrvRS4z7QkmBHsLbCkHZS5OXk3J8GVBQtwVogZGZYk8RTP8kfz/Sb5MCmpsyJlFSaeRpStPbra/E1NPFvehAKlpKsAplktCWCPKW932zOeCjX28wb/a14j9je//lKBOk3BKMCoOpk+TJgDaBJRd6iaJV8GwTYNenzL8WJKQ/1zT6TL//31WnLMQ4uw7cByB0IhFZHlCIdwlcTQoNpGSFu6cYTr4eaKh1rGKObVkSLmLHikch1efzig6DSfZpa76kGev67QuUGvfGI8AO9keb4n+fl/npR1t0pR3RiYAv4S/uab//z9d1lX6ks1JuYffhKXY8Gvo4muzJDDamW3FCiZKJFCm7riyAqexnjcKeWH/OaqzDUhSPJ8Q4MKKxZHuyPDB4tkeml4hNnzlELrqzUysJIsJR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> Similar to CPU_FTRS_[POSSIBLE|ALWAYS], let's also print
> MMU_FTRS_[ALWAYS|ALWAYS]. This has some useful data to capture during
> bootup.

The patch subject is misleading, should be something like:

powerpc: Print MMU_FTRS_POSSIBLE & MMU_FTRS_ALWAYS at startup

With that fixed, Reviewed-by: Christophe Leroy (CS GROUP) 
<chleroy@kernel.org>



> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>   arch/powerpc/kernel/setup-common.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
> index cb5b73adc250..002b312eb7e9 100644
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -866,6 +866,10 @@ static __init void print_system_info(void)
>   		cur_cpu_spec->cpu_user_features,
>   		cur_cpu_spec->cpu_user_features2);
>   	pr_info("mmu_features      = 0x%08x\n", cur_cpu_spec->mmu_features);
> +	pr_info("  possible        = 0x%016lx\n",
> +		(unsigned long)MMU_FTRS_POSSIBLE);
> +	pr_info("  always          = 0x%016lx\n",
> +		(unsigned long)MMU_FTRS_ALWAYS);
>   #ifdef CONFIG_PPC64
>   	pr_info("firmware_features = 0x%016lx\n", powerpc_firmware_features);
>   #ifdef CONFIG_PPC_BOOK3S
> --
> 2.53.0
> 


