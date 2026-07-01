Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE8BC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACAD6B00A9; Wed,  1 Jul 2026 13:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D886B00AD; Wed,  1 Jul 2026 13:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773B06B00B1; Wed,  1 Jul 2026 13:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 502E36B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:00:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD23840457
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:00:01 +0000 (UTC)
X-FDA: 84940820202.23.B2785D9
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id C632C140004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:59:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TsoVnfWE;
	spf=pass (imf09.hostedemail.com: domain of ecree.xilinx@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=ecree.xilinx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782925199;
	b=0CDzZATttiUqKUmcG9XBLJg3ESpdsbAj/3ebSzO6Me+tNblBN1cF3+W9T+3/SdCPbJwH2d
	KNeKKxgfU1DOeD6QUddSg7MZ2qHEhmd/4us/US401ljLsBgpnRGkNQLHqO4/MFCwX8OUpx
	i/bT2g2F2Wjx/UGUmXHL6sN3VvGT8g0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782925199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PaapEG/0w2F/ZCT3Yos1qIyYlCxFdKMOGlwcZerx/iQ=;
	b=3KcZPoBKRZXqjLk444tjNGLSsqq/51jLQSG/IF6164fdXd/SRHcogxH/4oLKUnlxkGrgql
	aBXFiTmkP0cnrob0AEcQIID2j/pUFNZd9YmIi8PMj5LHBRGMVSKy/NFTHNkh/0/1BhZzOU
	vRvZ2c9/uPbgJRnaeSxynPcj+UK6QEE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TsoVnfWE;
	spf=pass (imf09.hostedemail.com: domain of ecree.xilinx@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=ecree.xilinx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c19bad03so6826415e9.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 09:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782925198; x=1783529998; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PaapEG/0w2F/ZCT3Yos1qIyYlCxFdKMOGlwcZerx/iQ=;
        b=TsoVnfWErpISR/ObqATzT8dZvRnk71eRE51SezpdoDP9rVWPkWykbxamc/+T1tdjN6
         Cpb3J1W2cvJG7a05U2T2leV8UVq4oHT79fGEjSzvUTfqXX+JFH6QUnXvVcumELAtxjwk
         xZ4Wq6RH6zDYxHYXG1KeSzq5GlDUUUEfrW9c3vCLXWhe76EdWrzBznKgpSaJ3YyMxmy6
         d9SSKOhXR69pXQkPYV8QCOhuQoFaR0a+DERxtZO+AEfIUF/EVLLQFBT7lQjWAcAd1aaY
         7rkHp0AX2DWdUbSyQiVzEqy1y74PdVvbZh3KYYhGUC1wYXCraGmQ3iaX5887AADPEO6d
         QZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782925198; x=1783529998;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PaapEG/0w2F/ZCT3Yos1qIyYlCxFdKMOGlwcZerx/iQ=;
        b=i1w3ZFMD5mVhEoHq2Thh7QmAUZxc2/lLa4THSmW9hCaiUc7ho/AabSQKDlTlAo1HT2
         vw349sfzBIzZhJGRFIR3+yKAsCgHTQdqC1Vco/H+/swc7sRF0B/DzB+6CHD1Op18WYmf
         oB8RjEBzUPLXSqWxZ9R183+6G0T4fBZPcRbh1gENiYdUDymARqoHrGEx4KpsfQNhx1Js
         L2bDci1DPW6EzTCED37XRvVW/vtTJtgg0ESImxhHmSAwGit2nMHa4dzrwfrTMy/gCh3C
         Jl5jBYQHORyevb6+44ChS11oWRJ6PbXyC9FmY/HPXqThur/2ReWKIUlFJzoLoYth2iEW
         bCKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9x8aRLYol+m52j4RzQCFEdNyMKtQyRXu0sLZ1g8s5WAeBmt1VsDXw6RAv+iLVXWKquq61gRI63wQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1tDpQiihGziEZqHqza2nJ8pZV51rXUj7+T5bt+OyuAkwWtUTN
	xmp0XirczKqhOxqGGl5uIX+4jWnCwGGmIxeETslcHobwY9eyXr3Kafx+
X-Gm-Gg: AfdE7cncUJrDRlLsfj+EUKP+AkackKcrbYikminHntMNG7JYfZPNAWUSn85IRfpYr79
	ezauDLw7QHqbOsjaOguC7zQa6nsx0iv68egzXfwHlKq6ZAJ/opIugdpGejeWDRxMexPeMGvOROw
	Z5luU6d/kD5kytuI07nAqnOcg47Fqcf0zrorMRw0PsKAXNO431XUE2ikttDIQhR2gulu1aGmaex
	EkK28/bcD9QB5umaXAL3I9OgLR5Vhd9ZEl3O4eIjIHNkPFuoeoOYfyAvZ4AThef8QfWExct89Du
	D3V0ye3BbD8L+hpt7z8zPmuzpLb1eHkEI9/at3qTkTSwereFGTTKL5j8EG3lrhiDAag2/OwIpaI
	Nzt1jWBWDeyXWSVwPJDdP30lokSGXDDM5Sw/AHbZYASC5ZYHqcPQt2XmSsOjH5XMq1OuRPLD40s
	ixuGp1MIiP6ZbSx3GR4SYSm1irQpRiU4YZ6/wvtHRJ146LJO0IEpgBelEHddwWCJNiVp4wZNZ/W
	Gs=
X-Received: by 2002:a05:600c:8590:b0:492:6f9b:572e with SMTP id 5b1f17b1804b1-493c2baeeeamr29176415e9.37.1782925198152;
        Wed, 01 Jul 2026 09:59:58 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be4c9f78sm92659965e9.5.2026.07.01.09.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 09:59:57 -0700 (PDT)
Message-ID: <df6a8720-fa5e-490b-bfb5-817ba53ff59b@gmail.com>
Date: Wed, 1 Jul 2026 17:59:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] sfc: use kmalloc() to allocate logging buffer
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Manish Chopra <manishc@marvell.com>,
 Paolo Abeni <pabeni@redhat.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Sudarsana Kalluru <skalluru@marvell.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-net-drivers@amd.com,
 netdev@vger.kernel.org
References: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
 <20260701-b4-drivers-ethernet-v1-4-58776615db6e@kernel.org>
Content-Language: en-GB
From: Edward Cree <ecree.xilinx@gmail.com>
In-Reply-To: <20260701-b4-drivers-ethernet-v1-4-58776615db6e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C632C140004
X-Rspam-User: 
X-Stat-Signature: 33fu51rg537shs5f83w3bcktotgm1g3s
X-HE-Tag: 1782925199-207484
X-HE-Meta: U2FsdGVkX1+VAPIYGf+HAMkXICUqGshNKobHBOfk7QRDWObFb/awJdAH2bRrCRb6WkFoKl0CCh0WC5yeOHuYkngLSj0mGBbQAel6/bFWjq18jlzL/rQlz1BZj8JPw/HklTkF5cyLQ57mXF/zl/Mty4Ny0r8fYPzQivzCrecX97IJqn7m3bgXdXDbKWaXOqltP/61t3O9plkJsuqnvpsTgG2jr3wyRdxgom4dt1JC6E/LjQqYKN68kb35AQwE58wtxc08Z7xPicoQ2sM2c1ROs2GmoTY6nfAS/tVlV0y4QPIWqInXNI+2jk37+Mm8zZNktBb1vAiX9z0+NNdC1S5cdCnLzWbrAx/xJ0aeJcQHYlsXa3tnVp48WvYz730fCZE8xjzfBuajmoJpP9/Dz+FDHUpjdGc0ABl8uQMxZanCFHeBQFRSylGWguQbWszJAJBmZqjLned8/X23qhbfQBzqHnwS5QRq+IV2e9GeXZMek9JXBepiOHxeRBtuRs9YgQjCfpxEtGfVIcDzTcBG5kcNQOI/AAfkXUyDSOd6+9wbTiDpfeyLKxPNOlcVJUVOQCAx3AENAom0x3J3pQIJCs5vq2tUPnuPtvZ5IkC8I8uLe6lQB1Q1G3txmQi5/jFIkA6CejgHfK5Sh5Hv+uCJLPBvYMoNfPtft8BmGDCaD8kTGQ9kkVDYiL/DIaCgmC63k+CVwXd5qpUOHRK7NvpTZc1XnGeUli1l+R5VDOUj1ssskJmTuZlXoTfYtWorOuRv3lubJHrzm37VFC6KY6HDEV81BB5XWpjyboEZ3X1lELsBCm1hac+H2yDMoS6vF8PvYNzhdzKOHb2QOWUJvOoImoRF4GXNe463+uTj93P25/gbia5Y8f3Mr9Ien1waQCneROpxJUiVJThwVUydEAjMwLlWDJk3D+cxZlUSR7Sv/dBsNNjCHZIbNW/5sCfB5eI3ATW9gy+acV3Lj+igGrx6CT4
 dDK6dCq8
 btB/nBB4Ay+wkEDxKYEMF7NrVnq4PFZhgvh84L9V+g2wdA0nUHvkC5HH6PwyauwgMYsaM5udog475Y/frg+ci90wUq0x7Rf5wQGLWcRafIVEq/PcvA3d6XPwWbp4YilG/Y5ziazquDpPHiZ2ibnWpc2ODGNlhv8pwwJ4KtpzZfdlmaPJ4pYjNwjldVo/Bq1hR5altra7pn+CDjfXAGOf2u760bx2mna6OntXYznv5FzvMGb6ZRmQhf/MRhxK5+e2YuBJBt9CqcdPWd3Dsj6hP1wI7HO2x/x1uWGwjRbkRyQONV6jOP4DDG3ns1+jnRpl5ZHPWEg+eA38oTAqgM6d789qXRYCi21TxkWJSitnJtA3ynRf9pB0nX2r18vHuY5W4JX9aqhlBjCydmAMGKBQFPKO7CQ4Uq+amGdUsLJ/yMnVcOE9ELOMVSnxvILPzcJGHLHKVxKo7qrRB9FF7hd9CW3IYUoYNJsXr6uh2wDJ6eLe9vQJUzbc9GBLBqi7rf75llQ9eXm9EQXEDytT6B5bCo106+VDQ7adrg55At9f+qK2gKx2EHIfrr5DgCdqyRT5FjMo9XhjbNgyK16QMOiZBootPkJbkqKgj3W58pnD9uP3qJdsLH+WP508eAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/07/2026 14:57, Mike Rapoport (Microsoft) wrote:
> efx_mcdi_init() allocates a logging buffer for MCDI firmware
> communication diagnostics.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/mcdi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> index e65db9b70724..b806d3d90c42 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -7,6 +7,7 @@
>  #include <linux/delay.h>
>  #include <linux/moduleparam.h>
>  #include <linux/atomic.h>
> +#include <linux/slab.h>
>  #include "net_driver.h"
>  #include "nic.h"
>  #include "io.h"
> @@ -71,7 +72,7 @@ int efx_mcdi_init(struct efx_nic *efx)
>  	mcdi->efx = efx;
>  #ifdef CONFIG_SFC_MCDI_LOGGING
>  	/* consuming code assumes buffer is page-sized */
> -	mcdi->logging_buffer = (char *)__get_free_page(GFP_KERNEL);
> +	mcdi->logging_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!mcdi->logging_buffer)
>  		goto fail1;
>  	mcdi->logging_enabled = mcdi_logging_default;
> @@ -112,7 +113,7 @@ int efx_mcdi_init(struct efx_nic *efx)
>  	return 0;
>  fail2:
>  #ifdef CONFIG_SFC_MCDI_LOGGING
> -	free_page((unsigned long)mcdi->logging_buffer);
> +	kfree(mcdi->logging_buffer);
>  fail1:
>  #endif
>  	kfree(efx->mcdi);
> @@ -138,7 +139,7 @@ void efx_mcdi_fini(struct efx_nic *efx)
>  		return;
>  
>  #ifdef CONFIG_SFC_MCDI_LOGGING
> -	free_page((unsigned long)efx->mcdi->iface.logging_buffer);
> +	kfree(efx->mcdi->iface.logging_buffer);
>  #endif
>  
>  	kfree(efx->mcdi);
> 


