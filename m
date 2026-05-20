Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFF5CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED56A6B008A; Wed, 20 May 2026 03:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC986B008C; Wed, 20 May 2026 03:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9686B0092; Wed, 20 May 2026 03:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D12D46B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:32:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58F96401E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:32:28 +0000 (UTC)
X-FDA: 84786980376.13.47B1808
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5ABD816000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:32:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TuSKwquF;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779262346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FrgwpGM2Ey9DAqvdXlbg9+ub1m+pVkWeD4ut37zc88=;
	b=zs4Ly9kim67hWaBbRyj1nULMOVCa+U17rArm8Ru7oDqSJYQeKua9wn4XWp+p/NKlzmGQwg
	H6ubGsgiMeZNPKbwLXUgslZymQRlWlZpGlgtZPhlZaDxQd2lLBlBpYgMWXVU6RLXl/iWL6
	CqE3u/g5QA5ffHQkIRBZX8zTtHxSJCc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TuSKwquF;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779262346; a=rsa-sha256;
	cv=none;
	b=LGpvterx7fcWFlAE6WQ52stvspu1sM3NdX579BMVN+Nrayizwpta1dYgaelKOKQIKP1N/p
	PM3xjp8v1rtL9GqQ1bNNu7FiSmY1y9k55Id2W35zdILobMEJrnSy5h1AlPM38uY6qD4wwK
	TLBhRTRmAJklCZfRvLWQTNEhFyXvgKw=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a62f43b76aso4747210e87.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 00:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779262345; x=1779867145; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+FrgwpGM2Ey9DAqvdXlbg9+ub1m+pVkWeD4ut37zc88=;
        b=TuSKwquF8mY6ENnyjONOkdmM68io/uRx1ei+NYvuz6gmvxmvCDlZlTBHMUoEqyRdA8
         MY0rZv3bYv+ZnYdk/DD+YjpzMG2YK2r+YcnGKZvzhdYj+9V6lc3LTK2ktiSvpWVUu6R8
         RzHlz3jpF9FvlC0w/kZmPQ2EhBHrTvLuZWTJI7Z+MxgBShdUXBFZOTtZ8HFVZGQpu3Lx
         73J79xqhP00hzJlDeLkcw+9S6Fr3CHp5YyJB6QjSAlOiLTaW6/Ciw39ra03eBNJavE4c
         Dr241Adwx8ywtHHhxiOmfzvzHIjx2KJSsCy9oiu6CFAg0UmU7xxUECEBjFy84JoYhgAJ
         JzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779262345; x=1779867145;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+FrgwpGM2Ey9DAqvdXlbg9+ub1m+pVkWeD4ut37zc88=;
        b=fIFTK8eH7C22ywDprYuu6iAoCC5LJLGqhitHWm5MT44XZeqaKqIPWXryJXdmmiyVSS
         mB0kuVy2ZPVVuCKBFzxyADiDNzfRvTuCd1+cGDkpa+VxRWjMuDpBIH21H8AME7WmXrQR
         V3uvYe2Aq40GrRc5SNSSi5n9OpIpXS5VjWfcQwrJQRtHsUCy9+m3STRA5ArWLBicJ2TO
         qDWn8wwHLVpLtuhPxzbPwx6yCm9LED10aQk5mYxpfga7RTe1a3dfpXy/hANNf6UNT4J4
         Dty5S1rRbBVLeylWNdM/T359LqvMsWljuyr1JriSZJ0Z6JmmI7WRoS04Hw57h0AyUwTB
         RTvw==
X-Gm-Message-State: AOJu0YwesIBugbwI7QNPv4gsrk0jthKWiHRVSwctHyHJiMGfVYeWcPTg
	eYqzEyzfAQAmxvlHWq/T4x6p4GSCN+JddT4InCGXWDmTo4tAoxtoYkNA
X-Gm-Gg: Acq92OHW3DuIc0c7ma5lNz2fCv5DNnZYEieVYFEASuH5BnGT/ZfaJqg+GkvrD5VSokI
	/aiK/7T8tlWHkBLTMi7XiVEKZzfFBDClpsOO7xhV3TyIR+TaUQTT8bT+lBFLyile7Gp0GB2Rkpk
	rRtsTfH4wa5VvEpvob5N3lH+HSJELUr/xGtnG+TqikiECxiF/Szo0PitU2C8HiVnUW8WYJqDPml
	3p2tj9ZeH49RPOfDcsmCJg4q6dq/vEdExiRw8JaaJZfRwgB2+QUDKyoUjqkgycz3gvJn0GW9Vln
	7/oLx1VsJWANgfStB+mQZRQavAGI+5VfEajahs0eYiepw3c+fgsm3+KfHspZ1Uee1i5blHoKUBy
	xZ5mI3bUFZjSEhgmqJXGmXfAkQ3d8YyCSZ691XSmckMgvdATLaVJB9elq/ctjgqPG
X-Received: by 2002:a05:6512:1291:b0:5a3:fcb2:c6a1 with SMTP id 2adb3069b0e04-5aa0e614047mr7302936e87.13.1779262344292;
        Wed, 20 May 2026 00:32:24 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a9164bc462sm4733129e87.45.2026.05.20.00.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 00:32:23 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 20 May 2026 09:32:22 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org, Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v2 6/7] mm/vmalloc: align vm_area so vmap() can batch
 mappings
Message-ID: <ag1jhrWivbasi8Jq@milan>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260514094108.2016201-7-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514094108.2016201-7-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ABD816000D
X-Rspamd-Server: rspam06
X-Stat-Signature: gcpizdekma1h1b3wr96ob9rhkmzcbyfk
X-HE-Tag: 1779262346-877870
X-HE-Meta: U2FsdGVkX1+Vg0qfMG9rNvb2nrm7+McJHTZ9DKJkx5xGsaMsRv2E55lpoInzu3fM+eBrJ5gDPh/OjhPQtkLvAuEwNQ5qRGqyRhEYtxPOSc1nKrJEGNCbi8cYOHNbg2jIbp4Wj4jD1kDlzulDPNfYj5H1afRyhB7Jy/Hbyh5PsecQnZwR6qZs1+HKmFOZHz67/2KXPhbFNWCf+ajYSvltklV/xzcMMl7+pG1hLvKPvIhA8rhi4UMVuF20NsdwtuyuyQhn1teUx5qtqsyDIt/Ehv3vt5iYJ1GDkrlb2NwdAXNCDoEsl6EP8FSGxY12CWTB9TZJb0Zgz/xlF4noXzezF65eeDfOQ9THt+fHLOGNYyChKdsMwjRAF1VkDpgVGnBdoFkZKOVBoGmR4qtUHohDzoeaKJIgKRyToHvhILhm/A6bif9g7ocPOwith4haEkk/4+dEp9uxH6rAE0V3WbrkksoWE9VloCgmltW07ua/W6hak4nJB/vXeV+xgvZ8Km8m9Kpf+lijv+IAxgbgSZviCFAGOnPStyjZoKGNLeRaaKYlnGELFFtQb9GZRXNa4GvXchjbRZT3lxl6Whp3JnZ+TerbaPFIEupUiSfoUtUirMRK1EcSjnAIu1wsEbVRwSuKaC9pcWCb94zkRN3RJ/sDnX2mivR7P0yVQMnArguTsLVym+3mdZJbo/ARlYj4UnoyPQPBUdmxiFqFB0/uXFGzZRTsLfoo5aoQ6dIPDgZlg7QaEIikF8wfP0K2Z81bb1xB74Xw4iw+N8yDYa5CuMO6rBPHqJCS59rAp6VGIacwk4g0vBndyCoYOAGbiAxVKiDg7lMnlSHGyT/wW49nXJgRKezdoJRTBvR4BspaJwNg+1/StWU+ectNWy81VFxYkOOV3yrZNgYf+pv9SKJZx2pBiwDDd1kTs2Z0ryntAinLvUqDAk65EoSvcfj3czbeA7Dva6G0iBbcgutPYK0dJQV
 0sWTAR+U
 lgWzPB4JERQt+x9tFYJmWU594+tcx3lqdHDCaUVhRNkkdM7tL3WNQJNHKRPWaJySg65S4BBlp3xBHUbB94amN8EVDqgDIrjK6NUZT8boqCLnEO8eu292dCGyEz8dm+WDUzVjGFJzKfFBG3NvHAqVQk5IvUDTUUaaIfgdWu1bf6GlCEaKkW2PqaJjeLrU+lcQL1X5kzoMpNlzz02f1Z8rqNzD+s23ePQyJllDVxapsZzzKwaE+pIwB7hp1TLN4bmYDXQC+UKekdI/Moen1XAkBlrJsU3G9seLYnswRFNZ57tDSvexvdCKa9Vc5cosVIPPwc/BgrlUy3BSnECO0/hbkXk+RxK62DCAxYRtsJiHDfDgiYqGbqBrjjhh0KXnKoLAfUzNcVZtuzaNy8n2XVQ0WLoE1xzHzjyIQ1y8K/FlWhGYjJveJyE/lGar+Xd3NJt9arMUD2cjQMUMOvBrQWq+q1az4LNd3HLVT5fRB2TOy8vrJnt6fnTOzhEuHbDWcJmsEkzysYqIXhfNcJ+Hz2WlXHidzA5YnXFnc1SmqPZMmZCbSqBUm2hmqGbTCuQtJJrcF7hFw/KFv/3YT3tEYfjMWdKPUUSnX3oMkX/Ywfb3YcnRu67g+cju3xgO6Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 05:41:07PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Try to align the vmap virtual address to PMD_SHIFT or a
> larger PTE mapping size hinted by the architecture, so
> contiguous pages can be batch-mapped when setting PMD or
> PTE entries.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c30a7673e..b3389c8f1 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3591,6 +3591,35 @@ static int __vmap_huge(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +static struct vm_struct *get_aligned_vm_area(unsigned long size, unsigned long flags)
> +{
> +	unsigned int shift = (size >= PMD_SIZE) ? PMD_SHIFT :
> +				arch_vmap_pte_supported_shift(size);
> +	struct vm_struct *vm_area = NULL;
> +
> +	/*
> +	 * Try to allocate an aligned vm_area so contiguous pages can be
> +	 * mapped in batches.
> +	 */
> +	while (1) {
> +		unsigned long align = 1UL << shift;
> +
> +		vm_area = __get_vm_area_node(size, align, PAGE_SHIFT, flags,
> +				VMALLOC_START, VMALLOC_END,
> +				NUMA_NO_NODE, GFP_KERNEL,
> +				__builtin_return_address(0));
> +		if (vm_area || shift <= PAGE_SHIFT)
> +			goto out;
> +		if (shift == PMD_SHIFT)
> +			shift = arch_vmap_pte_supported_shift(size);
> +		else if (shift > PAGE_SHIFT)
> +			shift = PAGE_SHIFT;
> +	}
> +
> +out:
> +	return vm_area;
> +}
> +
IMO, we should get rid of this while(1) loop. It looks like you need to
handle just few cases. 3?


shift min value is PAGE_SHIFT, could you please clarify when it can be less?

--
Uladzislau Rezki

