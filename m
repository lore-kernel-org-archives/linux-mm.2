Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF52710F92E0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C33F6B0088; Tue, 31 Mar 2026 12:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CB16B0095; Tue, 31 Mar 2026 12:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56A06B0096; Tue, 31 Mar 2026 12:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE7986B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:53:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A375E052C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:53:45 +0000 (UTC)
X-FDA: 84606954810.21.1A36F03
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 96919C000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:53:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ur/lcsxR";
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774976023; a=rsa-sha256;
	cv=none;
	b=iM3XMA2CUndujARjfqFEUYSE5M9W9GB4fnS+pWtaABCAmUH3vJYd/eghlWWSdmJBaeJAkL
	jxf7r7ukJPZag5Hdda+6+TBTAfCeLOIFtve1EZFXL2GWfSliiJDwCM7uG/4ei5ylZc5rWJ
	/1oJRE7InQ9TRT3YQJBJtFvw6CRvVU4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774976023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aauTamozqKzQn+bD3WjE49ERKIyZisiImcibDa0IHF4=;
	b=5zzlQtCv+S+dXYlRLyzlmOurhWZQWVTrzqdTY++Q9CIahO32fkIz1xPdJH0eyv595JKtlo
	J8i8Dwj2oOkIpJc8UpHrGMviZOAK7fdYf/xzlwCbnZnu1gylcphe8TqGPZfFEShERqjH7G
	Y8YulRiiyyVJKwFxLp/AIlgtk0k+5i4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ur/lcsxR";
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cfc2d1fdbfso499291785a.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774976022; x=1775580822; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aauTamozqKzQn+bD3WjE49ERKIyZisiImcibDa0IHF4=;
        b=ur/lcsxRfeqaQ9sok6u7RDcNN18juMMyilt1Py1x+wzVKMsZFnkdmTSNBbHfj2v4yu
         MrXlwutoANvmqaZIU0meyMYaQbNbDxzV8eStcqe+qt5L65RmYisUevINXZf63xg3bIFL
         expCy3Cvx/EfbtZRwRcPZS98dhDnHR/GMUJ8gHsGSDft6o9djhzn+5fN9JJhqxyqmzFK
         T3FWFuXtGTxsWUoW/K8vtjcoBz6Ux0JpJLfxPaBCyrUU7PExVRhvP2A8XzprHcaYO3XB
         JZM0eivXY83zxFsZe54ijOlhnnly9Y4UQxoE7dfWgSGYJaOWjAx/hZapN7658pgu4ccN
         +3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774976022; x=1775580822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aauTamozqKzQn+bD3WjE49ERKIyZisiImcibDa0IHF4=;
        b=CJpy0zQQhcScBlRGbGA4q58ie/8hgc2grexD95cWn5RlrWvn63iOz9+t+BqWUcwxk3
         aw5cAa+9+p3NmpvPOY66CqLCZItrajnbVh8EMTsw2xjB9ctBLqQNCedFxPFbhtGGmq35
         fLR0mSNChXwn4qRegtRwz96vq2UEqyC9RnWFTLfnKBEwxTJt5K/3oAyojfOyz0mcbdax
         0+5iMsjEsHw9sDYIqdxvwlWA9Qv9lqTXdLRWRYCKFaXtwbHv+4LFYRj8Sk+KO03lla55
         7eX62txbsbxXDbHouB1N3rn5AX1vUY6wrZ7VA8Z3yyUMiyxCggm7LuGnn5EYMT22O3zS
         xN3w==
X-Forwarded-Encrypted: i=1; AJvYcCVHnqsBSdQLKV4BFUlQ8eNWkRV6R1Choj9GCznko8n9SLh/GxzlqbXRUxcgNNrlbSs5h5jTlvx1ZQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0Q+hGVtDSmddBWwhOfHsfSYQ5VsyKEH1SM5DAbZf9tSrnTndF
	62DqtN84eI5evOLMlrO/L5r4Evk7TvP+PuMczdFoA1+kEnkVcZS0x2F/Xsz6L8W4K7Q=
X-Gm-Gg: ATEYQzzhxgg1eV+iAiodJBe5un3BCzgXSvy9OwdsdVivuDaCv3Jfkg8pCs/GgILKkQF
	lVMs0paIFAusoIFZOwgZnZO5bn7ak1lCZEpbeWQBI6ivYF68oxbv9dzZA8UgA6SW9r2Hb0VXnh1
	bZAvQHpP7xyg971QJJtJau9n5Ncdt5xEuRwCs0HnWi+L+dvTFtP6Zmmpwj70yqebWtkeZ9oJzJ2
	SYE3CxPKIJBE91C4+5C+hGMsl2kkcECTyRhRz6QZmQt6HWpHSULBw7tNOyr5CvevqVIR1LLwq7l
	Oqxk9xTtJ0AKCYCVTW/F0kqW5v4KexhQpQVxbMtSsMoML9AZIjc3yAkR0LHoZ7SzkU543nI5V6f
	kgnUY7ROBjM9VxveOYBEj7AtjMxTlksg1IieELDALouwAdYQLALvCwlkpFhx9qLHlrv5DSx0wXg
	+4CnzV0tBVKD5Ir0rvlqc03kLHJuwfFSqDxQfABL+kdt4zb98NAivZceSeX6kplLWsNRVECV/ct
	KSOUa4=
X-Received: by 2002:a05:620a:4013:b0:8d0:3cba:ea1a with SMTP id af79cd13be357-8d1b5b24b7fmr58497885a.31.1774976022583;
        Tue, 31 Mar 2026 09:53:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-68-72.washdc.fios.verizon.net. [173.79.68.72])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d0280374cbsm937456885a.26.2026.03.31.09.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 09:53:42 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:53:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Jackie Liu <liu.yun@linux.dev>
Cc: akpm@linux-foundation.org, joshua.hahnjy@gmail.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: fix memory leak in
 weighted_interleave_auto_store()
Message-ID: <acv8FJBVieQnpYT8@gourry-fedora-PF4VCD3F>
References: <20260331100740.84906-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331100740.84906-1-liu.yun@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 96919C000A
X-Stat-Signature: 1tt8we6mi1gzywhnn157xrcryqcu9cwu
X-HE-Tag: 1774976023-114659
X-HE-Meta: U2FsdGVkX18t0PaJFhvKAG9Pm0ImXYAd140jRDgY+MJk9jtV+ZvOsnrT/cwn+BUYqE2sflnQiqulIoYefqrcNjyLWmxwjlnDV8Z3GHm46Kxp5dU92VsTPG0NKYTrTqVslVQGTNFT9RfPtIVZ+W1uiBJT6jIJ1eky8tpKRv+gLIbi3E8Es4g3YqloMPs+3/SgKOB7RljsioVjjEbTfw4Ln3vHQZnlYHuZxHyYCrXjg+pkL68dwFGzh99Kj9+x/18//xQ53m13ArGToZ22O610hrCTtnL9P62uGKfb4EZuBWSJJPDYKDA0lL+Fny0ez4NrsS5r+sTZUGsjwKVbbsSFzlwL2dQBvAKt+BrUt2HlACuNKG4sgc593H8wtKvtlhHECvgrXtWIFJoJPvg0e6vAmxtt3AP1z8qjt1icNt+W/pq0CDhsK9EiNlZdvuqya7FV2qC49E+NrUHOtvreC6AxEJMR0J7q1Jy/gMiJkpL6q7X+W7MlD0fxwFFiEsLFrPSz7tO6vwMMwvSOs3f+4Y8emc+dlOjjc1B/GL6fwXPGrT5R9VSrffcxjbeVqA8pIaQrW9l4P4dbUoZ/fyUhl5pSgl0rF8VpKCIA++3j1V6N/PJ8A4gasY6c9a+y97SsxLOkDBBCJzbp3Al56YU8RdCcjWYox3g/NY7cgDmEG1pMeaBRjWC1rHabbS0iOLF04oJMWphEu9eR60aG5LEBSIwzwk8+20Nh4Lu/S3v25PH/hSdSg+u/oKJNp1O51UG2eaVkldauBIbV/yCDubW5ddW0vv0pUxPHuUh2O7ZNujaFRVvj+rSPuQqU/b+yt+oWaQaTIIzkfCMAAVfE/ELP//1qWPnIozchnC6k0GsxWWEr+FnpYIOyM+fHkyF4keSZadaWaphc2DOGPHWVj4zz9qU6WGKGTzJHRw6ZkfwjZa5VuLIib8GyAsNIldICFLOlmvgYGlLmHSRfr8f0V5fV5Ba
 lyZZ1oLl
 iz4y0gd9CYRdaWBmzK29wCFiAYpA0Vtow+MHdPDZ066MnQlVoRIIilPq7p/vvn9W2j9L7CL90TP+dRMPC2L5waXY0CFlyHOb+t1nmXDog2DXliTmOC/LrbRwrbXLDn1SO0wXp6izjcvBpRqCQRbIMChKeyTgHDJj1/GajirCDpDmo/I4TbBy0JSd3QmOh4YcUca1i1PSsGzosQB5EvJJvCeWaCIruVfbqyu9oimnjL5IJN9noQl59MgA/NW8YqaHjeW7HkWlvE8md+1Cyk0KR16Lg2Gc31CS+gOxv7wo/BLLQQA1e6lvGjub6SK74Ch/eXb43guUDYxfjXVerM4cL3+MOR4uLR+lFdslMth+etxc9EZijA8AD3wLu7lgTiM8qGCh6DZ5CB/bUt5M8v93bZlM5yWaHgvqmUK31jl1z1edr5ziaeuPP2NkYP448x+Ile1trG6zpMwtis7gr0rv6+5vZEOt/oQheKK4MhI6Gfegkh9lp+HiFl7s8JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 06:07:40PM +0800, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> Add the missing kfree(new_wi_state) when the auto mode is already set
> to the requested value. When a user writes "false" to the auto sysfs
> interface and the current mode is already manual (mode_auto == false),
> the function returns early without freeing new_wi_state allocated at
> the beginning of the function. This can be triggered repeatedly from
> userspace, leaking memory on each write.
> 
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  mm/mempolicy.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index cf92bd6a8226..9ac74178075b 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -3713,6 +3713,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
>  			goto update_wi_state;
>  		if (input == old_wi_state->mode_auto) {
>  			mutex_unlock(&wi_state_lock);
> +			kfree(new_wi_state);
>  			return count;
>  		}
>  
> -- 
> 2.51.1
> 
> 

