Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F735CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C14BB8E0045; Wed, 29 Oct 2025 12:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5BE8E0042; Wed, 29 Oct 2025 12:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC508E0045; Wed, 29 Oct 2025 12:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1768E0042
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:13:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5880513BE9A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:13:31 +0000 (UTC)
X-FDA: 84051647022.03.F12C763
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F186100017
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:13:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dMMIRZF7;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761754409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4s3im5+fiFWn9qRiTt1Snvq1vFYWks6luFn3lrLu9pM=;
	b=8POu8C0iIExOzAg7Esm0KiRYpHoE+P8UIO6EScrFgR8TgWx1fgr7mDrWzrH1rUtxPKVRCK
	TxKN0HLxZpf2MlOFkgaRkdi768dFfDzkz/3jmrGIRB3JWTXYkzalAw4VJ52QTfxD9T8cEU
	xPghjTjkw+0XcNkdol9FpyYsaIbANUI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dMMIRZF7;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761754409; a=rsa-sha256;
	cv=none;
	b=wq+hW4ljgH0usBvnYqOv06cyOE0Awbue+ly+6kjWL1D2WAq/tiIHN/+iIZN8WazUXMkELQ
	iikIobPUUekE4C5pt8t0NSDJeL67x74wdTDDKXxhQc49xzgEqHCdtQRlYejURK4IErllwW
	mSrkLU+mGh+UKCfPehn9EL5zY5RZzoE=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ecfc3f4a13so37126591cf.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761754408; x=1762359208; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4s3im5+fiFWn9qRiTt1Snvq1vFYWks6luFn3lrLu9pM=;
        b=dMMIRZF7C0e7Xp0mxazRxdaKLVf87SWxWptWZ00lawWb7s169uzR/eZVTOdHkHzLim
         46bvm/3ZQHUeSr0wzYesCPRCRD8XRztaDtz9jV9eYXMTiQ/siKILmtxJro9JqqQYGbDc
         cvrG/iERurdL2sgBu8zebAcsbZMEpv28L8ty9eatVYumYyGSNlKS7evMvlGMKAYUAi77
         NC8fWvopR1ZSHZ27yujD+rK/gdF5hJ7jBs4sxkvrHboxBfQvRauUsPz0ptQbuBdCjc69
         FiKo8hrAflcjjX7UnW6PBLo3OerLaJUKbYXVpXxPjXFgftlqa+sh+P3hoJtB2FU3J1zo
         0m5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761754408; x=1762359208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4s3im5+fiFWn9qRiTt1Snvq1vFYWks6luFn3lrLu9pM=;
        b=KKfvsPxQB4PFRqKz/AkTnHaEXZ2naDD0A5Jo40nXRby23Z1egq7xXGaIB+gXiLpsEo
         UwhheZiizBpkCjrvjWS4Xf8VgDWy+OIiqfEXgATbfZoH2NmidG7M6IvhHCL9145etcJJ
         akt3OdSUYaKS4HMjTsSK8lRYhFm9uCcpbH244xKRBVBgTAW0sXk45VqxhhdHazTyAW4n
         qPgIJMvZ0bCeC/9X90djQ9qaZe0UJJuizIaN25eaSCrlgEQZeVxRp548Im2ZpW9TXmCO
         jeY8i70pxIugOKFmmWbtFiJML9QotzsbcO/QlAHWLbW2U6oXIkcEx2kQa7+/fvvJZQPg
         5ghA==
X-Forwarded-Encrypted: i=1; AJvYcCUGjAnzTtUoMVMfr+JeHEQbGhKyUUpSpwpxbf6In+rfdAO75THmO/x61pacW4KCymaP2beVJvE/aw==@kvack.org
X-Gm-Message-State: AOJu0YwnCqgnHrVcXzjxO/ola31whxBXf1t/7HtxYhLiyPtT03Wbz90B
	AUSVcH6L3W1IP6Hg0qNg7Ky7SsXz7g/xuTqoBBc8EAmfS01AA/X99gzy
X-Gm-Gg: ASbGncspOuQgkNQiKZ9R7YJsOpyCI8b6zYzNudPz/UgSypmYeq76tRy+d0gc0V2Cztj
	1DhOWc2UaOhe2rtjEHaz1s4g8/aN+lSZIOBqc6ZAmdUL0cxjAeLwHvK+ezuvkevPUu7CmYgbLCC
	vavvs5t5t7VgRdJAN1t8W2TblVfWi9XPwTnFUJT+sgYfo9qOwZw08CWnnswVjkwWV1zCVNnfmPA
	kkU7B5vk/iqwNPfPTuwR/iZTpiRBqYBWGEr1jH7/t5JD+Bs815AbTudGsYb7L2WY1odQFe/HKUw
	KjaiModVoJcQU9LcZ00+y6KiSxS48ualzUr2I41zG/eOkVZjnprz0rYz7OFMHlAE551/HjiurDc
	T5LmewwXmgPu4unjGvO3OJK56BlL6UtpjLiY7aiNyIsz1GVqAzQP1AgiTOa7he2VD+CmhZZaf4M
	gg5gMNfzXr
X-Google-Smtp-Source: AGHT+IEu6Ro+MuXs+hWqIbxyO1xHx1t9vPYpXZvCaly79Td2SvZ8RumU4Y6ARUWsrfrc5qd08NFFIQ==
X-Received: by 2002:a05:622a:19a3:b0:4e8:a8be:5857 with SMTP id d75a77b69052e-4ed15c20e2emr41631151cf.55.1761754408404;
        Wed, 29 Oct 2025 09:13:28 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba3e193bdsm97513241cf.10.2025.10.29.09.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:13:28 -0700 (PDT)
Date: Thu, 30 Oct 2025 00:13:20 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, gunho.lee@lge.com
Subject: Re: [PATCH 4/5] mm: swap: change swap_alloc_slow() to void
Message-ID: <xgj3sxgxcwi6lflt6oy63ifq3b3bcle7l2543oa7aotw3qpm2y@cfqwh54n3737>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
 <20251029085659.2005942-5-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029085659.2005942-5-youngjun.park@lge.com>
X-Rspamd-Queue-Id: 7F186100017
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: skxop97pmhhr9cg37ihwfizuub5fsm13
X-HE-Tag: 1761754409-260826
X-HE-Meta: U2FsdGVkX18+Gi51tN+evIf+BMkDOsL47jRMMFsMuAc8SdaNLkLx/ZvNyc6dBRBUyOp/YN882HixMlsfawEXmZLl5vrm34CpeSPoZOoDmJC0vRIXYFzkiMhRIH1VXqMnrLJJu8zP/cuU303fVC5bDqR3x0C/fqxqf6fEsbbO5yvQbmOQjcGxrmEVpgVZRfaPDbbiVK0aA9j2ybbCLCjam7nkvMPZnko4XcEWnmmuuwNP3cImPTfDZR0Lgg4vpSOgYwHCeQa7Mba2B8DrCQGTfKNk+8llHb4NIOraeANtERhKDo2y0zKdEaKokz22svGnZGQZzez7o+JPTbPUoIpJj/UAR6fhvzk4AiGDqRvl5gk8fcmcqwasMUunQ4yjrNtB0vHAx151QGdhopFb0Ddu4RA1jF6nKNxrDOoIxDM6LDvryET9N+DsgrUWCLMCc4XGBmrPd3bYSwOzYdEd4QZbKUh8XEe7+FU9grcCaAoLsOc8CugHKlovIaIzRVeIOl1VDpLEEjR5oKpaQJnT8KxsOEJAXk5NVve4wKHow2DgQvkKfdKRqA/s7DBd6p6tzUVuxqEObT03gHPC0QOU/AJvI/X1OQgzzNTXTKjE16bqYj3al8dMS2LRwUH1xdcdFot3QfvmD+T9+LtXJtXXLWsLSiKadeYU5h5QpEdVEfHrUv7slaJ7fkC/xnsyXOn/y3b3Oo2p8IF51WdprDIc3I7hJU4fgaioHLWrZ+D4tetVd4n3WYYc6rlbrBw/f2mKE0fxmue5xHaMNIXU2xVj6Y+s/m66pFsatQLNuQ+Yakmn8x+YZg7o++PqTUoIQZjI5dKShV/1jBlVIdBmSCFN6JoUCrAFHslttGEjuVPO9Xide/7kMN+ZetyhXkHMuIjEjrSlzABOs6nUmrOrW17QY3WqapcvYIw9ZjoIo6lfrLOWu07SfS1ldBCxvSjMlugLNOwX4+KL2At18nIGBWV/FXJ
 P1SzGOrH
 XU4RNhBrxur6t2sglCT+WyCFNeGhmyNXmDPH3KpP2Qei5tC1SHsvVxF+tycAK8Sp86jTGefgPkwRINUS2noOu0YDnMwELbhKRRTplJxnahGLaxXYegZLRO8XeMJx5jYEZI0aJ0I6GivR34fxXScAO8WT6Pnvlewoc0vmabfatu4MwOT9Bjdu7RRU4QsddQu5pWdNDm3GfeLKomkVDGyRTKsfQfCLyjfqkc6rc2owpTk30THYy8i6pQd0RVvuKKaIRpdV9QejxHBOaB8QTR0avaETO36RF0UDevObJi+Lm/V55bwPi70SHcW8lbIaj6Eakolh05oOh7kpK3KWysj+FOxbTGBg6M3z5FOPgERf4fuWpRV3ULaZ7Xy/Myp9lMlTjnsJbIzhD3ATGRfgzGi79l7Su8LjxIUHo2JYLRl4yfQO7s8K1dHEzsXnAgpotv8R838xUuCmM3FTSOODG7BwUFA05P5Bjnm2xPzJx2gqfsFXTH8aBXtgeNY+9/w5SHdp6iGVqYzzHPbOusAwdOQyO6DvqaFobIUr31yHJufuVmrkPVKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 05:56:58PM +0800, Youngjun Park wrote:
> swap_alloc_slow() does not need to return a bool, as all callers
> handle allocation results via the entry parameter. Update the
> function signature and remove return statements accordingly.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b5d42918c01b..89eb57eee7f7 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1339,7 +1339,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
>  }
>  
>  /* Rotate the device and switch to a new cluster */
> -static bool swap_alloc_slow(swp_entry_t *entry,
> +static void swap_alloc_slow(swp_entry_t *entry,
>  			    int order)
>  {
>  	unsigned long offset;
> @@ -1356,10 +1356,10 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>  			put_swap_device(si);
>  			if (offset) {
>  				*entry = swp_entry(si->type, offset);
> -				return true;
> +				return;
>  			}
>  			if (order)
> -				return false;
> +				return;
>  		}
>  
>  		spin_lock(&swap_avail_lock);
> @@ -1378,7 +1378,6 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>  			goto start_over;
>  	}
>  	spin_unlock(&swap_avail_lock);
> -	return false;
>  }
>  

Hi Youngjun,

Thanks for the patch.

I just found a patch from mine series is doing the same thing:
https://lore.kernel.org/linux-mm/20251029-swap-table-p2-v1-15-3d43f3b6ec32@tencent.com/

I'm fine merging your cleanup first, the conflict is really trivial and easy to resolve.

So:

Reviewed-by: Kairui Song <kasong@tencent.com>

>  /*
> -- 
> 2.34.1
> 
> 

