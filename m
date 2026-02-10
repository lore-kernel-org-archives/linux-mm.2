Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8C5EA3F2B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66176B0088; Tue, 10 Feb 2026 04:20:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A031B6B0089; Tue, 10 Feb 2026 04:20:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905BA6B008A; Tue, 10 Feb 2026 04:20:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 822886B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:20:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 280DE1A0448
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:20:35 +0000 (UTC)
X-FDA: 84428001630.30.589C9CC
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id A0E1F180009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:20:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cOOYSZv1;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770715233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RdTK/SFPF7zAPyiMLWbkHB59L5WIFQpZI67N1dwPQ4=;
	b=voQRvI9BGS5htoe7w4W0BXefnOF6SSHKfF/vngafcPJhZT0tQHOu3N6J7q+pve0y3Swj0q
	ix2jknDkHjnYwbtk2lsI1xdh3olmNJiG/gQCv7My0c3iv2+f3YJttGkT0+vPbeScmj1dbz
	+czrf5ESzKhUdoMSQ3lxCl4SC1mmjSk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cOOYSZv1;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770715233; a=rsa-sha256;
	cv=none;
	b=NjcEB941TWra6e38vw8JlAfFseb3ysQoLMq0JpVe6cfFF7CJezHecfRtafYWzy0oKY3/3K
	Jye2/+JVzxWNe50vzkmQ5uC8WDc9Np7Lgq0zkpqHOQB5aE6sE9VEZEpgVBWWpCitNhh6E2
	Lknj+6CmeqtDPbih+8fiL3GsReDT0nU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770715224; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+RdTK/SFPF7zAPyiMLWbkHB59L5WIFQpZI67N1dwPQ4=;
	b=cOOYSZv1qLoRVpuxMcioH4Je25y5b+t8KJcaACCS9abW/SUokxRYpxpgo/1EmTjOg9Y2j0ZMsTw7bWb8XTMEX/gFbZH42+St+d0M2IWiHFXDUDFB/KnppxrJhNo2aire3ASgltQDVHBatmJypaiNDP6oTDeCCSVBisrn96Zc5Lg=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyyjrVN_1770715223 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Feb 2026 17:20:24 +0800
Message-ID: <b8ebdf87-2b1c-4359-83af-729688994292@linux.alibaba.com>
Date: Tue, 10 Feb 2026 17:20:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/11] mm: shmem: drop has_transparent_hugepage() usage
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1770675272.git.luizcap@redhat.com>
 <66846ee3aec32c04d20bc7e0e823ba21d4ef278c.1770675272.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <66846ee3aec32c04d20bc7e0e823ba21d4ef278c.1770675272.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A0E1F180009
X-Stat-Signature: 3isxmt7nntomad5991pey884m9u4asxj
X-Rspam-User: 
X-HE-Tag: 1770715231-60660
X-HE-Meta: U2FsdGVkX1/F/VXYtlGw2OSV52wQut46vtI/QoreLRw1AgV6nhrfhGDy1U2tEHqC7tDbwvZaHRjeehrSMvQrygiLSiaY8vT0EjgYupxMKhZEepbCg7XY8J9W2Tt9fAsx97JG2C9SbOwfmbaMpNnESa1eHcr1FTAKWkl2W1WWhUEv7Op5PkI/tFomQQkqrEReIKLF1oLKdTBd6rsGWwfu6BsoRseBKvCNoQ+r2jQEzJQfQI71nit23fADKthdUcZexqlFb7Mxcx6zMZm+aapEr56HBfqRSlFA0XhjdolC3wbNrXrQY+Aoko6GRjGAeqHfoTG6ecIhgRS6zFmi8SqBdLuEJjofC7EQlYzUMMZ+olnc+dPeiF4LBu6HIE7iqYJ/6v3ZSEt8pXWRKE2skP61CrWLDIXNzlkP4/0dQ9AUUpXs7x6D5V2WViplyC7B8j9tLl4+lZU5IHmxAkAjWW0ugv6vM+vw148UqJYD1rdQ2oabxkMhmdTQ8p8zFp7497uT+j7H4eaz9livUtIxIxwpPUsB0Exw0ii4PnYmITG3bp5a15PTNnnugHO+CL/GOvEvJUFJTqGbCE8nQ0+aAAWIn7/eSjr1Qq8V/Fx1dqSSrxCv5fYx4ByoohG5XvFnatj8//WMVzAi8Betqsd8I0PKImioq4dqlRgdgKkKs2WqOd22ec4rmTZIZaoCJCDQazUiVUjC9dVHy98Uo2kAgqvUMeTtwE7FeKrPt42Dm8U8yzqGAQ20kYz8nVgfN3qN2tkwTgPfWYomVufUsmMWyvRFDf6ZSDKNJSPMmqu8rMYrYp+sqb7igFUgbhZhZ73NU8Y5XChCrq83y7eAlG9DkvV1HC/51A1jLs3PdSCTFDqbgmsAllsV9UW86l0CuPculvsKJrEFpRzCkSaDHg/6jL7vuJ1OtdXuVRYyi02KCF5pMDqAQ/tPDPzC57T43O3XYTjc97vrk81GyX9IFkfGQl8
 WrhCfsyp
 f6WCwuXv9h3DqfBy9kw2IpalgbHSFhenOYdDm8aTETPg6cGuDYfWBuhHoKzexEeiGaAaujHkB/Gt7yhkAAMoCkyTjW4mjR/0OjW80N4X89aHYLxz+DQIWeL99X7jXAiugJgQjCdCwhVhnxi8G3/xwRnmck0/LzzHv2j1jjKH2TPBO8qIbf8yCeEoWpO7nyaY+8TjhDDpWwnANgvjCx5dOW6Cy0OP535ybknZGcmVtDGKjrSp0gDNBj2UoX7WyCf15SS798Smw+IHxM/ogw6Ab65MxoZPI+2mecpnI6ZvS2JdWSm+xJ+3SZj6Sn54q3k3m3sJsTDIKuLJLPXI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 6:14 AM, Luiz Capitulino wrote:
> Shmem performs two kinds of has_transparent_hugepage() usage:
> 
> 1. shmem_parse_one() and shmem_init(): since the calls to
>     has_transparent_hugepage() are protected by #ifdef
>     CONFIG_TRANSPARENT_HUGEPAGE, this actually checks if the CPU supports
>     PMD-sized pages. This is irrelevant for shmem as it supports mTHP
> 
> 2. shmem_parse_huge(): This is checking if THP is enabled and on
>     architectures that implement has_transparent_hugepage(), this also
>     checks if the CPU supports PMD-sized pages
> 
> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled,
> shmem can determine mTHP size support at folio allocation time.
> Therefore, drop has_transparent_hugepage() usage while keeping the
> CONFIG_TRANSPARENT_HUGEPAGE checks.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Looks reasonable to me. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 79af5f9f8b90..32529586cd78 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>   	else
>   		return -EINVAL;
>   
> -	if (!has_transparent_hugepage() &&
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>   	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>   		return -EINVAL;
>   
> @@ -4678,8 +4678,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>   	case Opt_huge:
>   		ctx->huge = result.uint_32;
>   		if (ctx->huge != SHMEM_HUGE_NEVER &&
> -		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> -		      has_transparent_hugepage()))
> +		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>   			goto unsupported_parameter;
>   		ctx->seen |= SHMEM_SEEN_HUGE;
>   		break;
> @@ -5463,7 +5462,7 @@ void __init shmem_init(void)
>   #endif
>   
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> +	if (shmem_huge > SHMEM_HUGE_DENY)
>   		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>   	else
>   		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */


