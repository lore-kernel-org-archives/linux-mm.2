Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F29CFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581146B0088; Thu, 30 Apr 2026 09:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F4B6B008A; Thu, 30 Apr 2026 09:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EA96B008C; Thu, 30 Apr 2026 09:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3627B6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:05:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAECF120BA4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:04:47 +0000 (UTC)
X-FDA: 84715241814.07.1D5E45F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 657F880007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:04:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XBARaxN7;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777554285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EfeWATGG5daetRgYzHsxFq0y2r373pWgwQp49kZAEc=;
	b=NXx3ItP2HRfNslUq8GCKDBq7kSncnEyBimeBTtHE4lMpwFCqXB718WzOuVBKFOjpPh4V5k
	Ld0X6yZTjImOt0E2gIQ3S5Oc2jaBW5V4VY6ZMtv3P2v5i2SqLGXruEBQ9s+PDKcy4HB0Uk
	NIU7IexzRIBdX6BxBQ6BFIxJiWfcjdc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XBARaxN7;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777554285; a=rsa-sha256;
	cv=none;
	b=189RspNIEc4rpvzetM/MyHHazIimYujsN1g1nwi+agODRTxFgzTDAMPVbtnOWmQq/yKRax
	ACO30mbIgF1FWndR9aDsFDnrImYV0QWnP15o/ZMzXYb6A3PE7d5f3Y6qHksklHGiCeVjNh
	xsDsGfo2L9YDwTQ2jXxKCqPiBJBiVSs=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so5853605e9.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777554284; x=1778159084; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1EfeWATGG5daetRgYzHsxFq0y2r373pWgwQp49kZAEc=;
        b=XBARaxN7YeTTVHNR1JGunLKZliORk81pSDQw6jC5BEann0uvDondoKQh4debn2rXL+
         k9PMwZO+QxYzLwdJ9zUzLrusWN+xv1G2x0//5EphO1waCtUmcdBLJCdjGIPzhJx6aWoi
         /O/0RKpA1j7DmgojxVb6nhPRgztWcrVmsX8aPiXGsbOkm39f2xIEhNzDQA8f7q7UjOCf
         7/yqQTSzBSS+3inW4o/UNfVt0KLJiT6FU8Hj8BsT64oTXc/njhjG6LqDSMzaNN5kCO/S
         kHTNVWuI6HOq8zpNQo56itU8KHXlNH4ATfxRSjeBnEGpN+IBsKJbz3IkPOJTfQk1HYdH
         MMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777554284; x=1778159084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1EfeWATGG5daetRgYzHsxFq0y2r373pWgwQp49kZAEc=;
        b=dMx9lm5bkQTbJ7tzFXZ/UyXRRbvpb/vUMEo6HcNA5tzcg0ltXPWLMRXT//Z1wRaoDG
         EJYQqSkUBr8+d7iL1HVwpDCTn7NZbXc9ROtR6p9JU9FaI95E1uVmkICAN/LvzRh3ArV7
         hNrWRAucl8ZZiHFc9Txs2LWJXdpFyRO9OFKDiuPBN+UwNV17tavZZ8vszRT4Jyvi/c/b
         oOsgASVgaeTYtdOSHRfQaFbAVRV06z7pxzaHEpkps70GZX4gyr32QzgH27cZTB3m9knU
         hkN30Xmb5eG3Rj9nQf1J64LNMe+Uh8uQRcV42zvX/sspC6QqJJpLu5EeOgnfCfTmpcYy
         ESAw==
X-Forwarded-Encrypted: i=1; AFNElJ+4C87KzUfNEc0YKvho9B40cQhGD65+lRF2Wrq/AIlzG2asoH2JWsEhjYZayC7NfSPvJQ2yIRT05w==@kvack.org
X-Gm-Message-State: AOJu0YwR7ISy7LpLTYeI/uB9FtAs1Cl4K5jNY6OCir1U/+tqTRXAYc7g
	W0r7k7YxOoB7jo7WkAcibenAPwebkieoIbYm9I5xEPzKdhQc/upWc1OknFRItsbLQDGhZqDVJlV
	2eQ77sm4=
X-Gm-Gg: AeBDietiGlmB5mmO75brce4cuZ9pU9QuqhvLKlE5Es2o3nVMjY6N91C6zYcfpg4mNsk
	uchvrytBjhlVBphyCgVx0ajALWuC8NWBytSrAtKX0VNELLTNdmGwTJgkAVcSs3KDNvG5/cynHnd
	z13w7Lv9Rx198VnvAYkPC6bgebu+KEECgreUhoPowGXs3ZT4mcb08bIVTFIluvxRPpgw8cuv9HX
	NtaX2iXnHZU/sCQJN3ilOFZnps+eK+PZNu03aO86MB+W11QqnEy14P7d7bmTKneq6oKWmU3VAMv
	ROWK6QEbKWnnS5J0brbSy7Wom/X+O90NHkQB8xHU5blcwKLhRxvmVGvxW0beFD2sz9rcY8MUkfy
	+wwlp4SMC28mBxLHPH7f8eFe5TOssEO/tyBfhZq+/NqTH8HRZGAXo5UsQwZGGgmuJZXRCOB7vWc
	GW7+26y1j1G4dXUh2zc0SfgV6d+5b6SHS+IxBJ5MERaZdeDSA=
X-Received: by 2002:a05:600c:548d:b0:48a:534a:eed8 with SMTP id 5b1f17b1804b1-48a85e17294mr36683365e9.1.1777554283392;
        Thu, 30 Apr 2026 06:04:43 -0700 (PDT)
Received: from localhost (109-81-16-145.rct.o2.cz. [109.81.16.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7b92a0cfsm44017245e9.10.2026.04.30.06.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 06:04:42 -0700 (PDT)
Date: Thu, 30 Apr 2026 15:04:41 +0200
From: Michal Hocko <mhocko@suse.com>
To: Nyunwoo Kim <knw0507@naver.com>
Cc: David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: Insert newline for better readability
Message-ID: <afNTafWH7UUc3zl6@tiehlicka>
References: <20260430125321.5679-1-knw0507@naver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430125321.5679-1-knw0507@naver.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 657F880007
X-Stat-Signature: sb37ngufjtcp8egxcsxg8tiz7p9cokuz
X-HE-Tag: 1777554285-759375
X-HE-Meta: U2FsdGVkX1+Utzdo8CtuN8NgKegAElppMr5d80AhzpF4i70QsxbNDCsQzNoip8n8hWVYRLSZ88GtLcqFUjZ0F7/A8h8M377d1ZtcG1dhchCAEVtsJw/5xfgG7olbz/Gq57fvFpkzDWlwromXkJtxADnhCrWHTy52cA80nxmndeF1FLf6MvFPFyfjc6KCmbGir6h7p/OngmOuTDOXM48PHEd6PNUeyXgXtn3xGZCQ11bMWycHiDABbbZidyRhfNoveCdZ9hOPeCi1FpinY6otJS3yhGtjnV9TfQ+1DIDUq611WmxN+AsTnSDbNuCEjC0EwpTyq0ua6W+BPCFc1b1wMjs0PPSjnOR0AdgstVVLdFWTjgy4xf+lNv2XLwvAEfPlSclHxy/xLCHO6T7TbDlwp79c5Pl7Pteplix/0voHdpAYkZ5MHosCkZG8jB36VC9TLYXuIbpLKylTPnTcaHavrFPmhxm+dXecF11GVaZn+O3MzL2LQDlF2vW6eTx8cD4eocK1MSKguduEBTI1gvg04m129dBOnAbm8tg9SAzq6bDaMNHX0VZrVAZ8niIQihrjrbAL5JM75eFImfKM7Tp4ogmvZ+86PHc+g59sNx+5YnSg3oU2Jp7fCKwK1X18yoOpPVAin7mkW1p+JR1kJ+N3cg8omEDzss92bVqCWHH4ZwFFU2nJO1tLWoAx6TMPTw1gFA8+0C+21/8D0aLX9PFhTZ9vpPdhNxu6rEbW90745R2FrvvNy631vEpF6XdfrBWktcBeD0o1XirN1IO9lbRaLGpbsQRNAbjBCKBxDOCPa5Pt6t282fZf2gxLi1IbpwdI2kW3v1mQURQz4OfAjBeAYtNBEdzSyzhzhu8Qqq5GHE3e4hT9fbZ6M1MuLgXFcoPcUiI1uHd8xgxY/cmwE7Lhlwt46UTJiN4Japef8DY9waVSCAGfghJQU7arMQTZuIbvF8VuxmYnuFhjUQ/1VQr
 SUQoNqJR
 l2XIZJjM1PuzjpGnSadgISZVnQM1/IKQpVJF8HP3h+l98sBw+ze+Z8DmoCSpFxVVM4uiAdO4gNG9ACbgZWYY2ThtY1qowlNA1sVm4fW8D9INwRfUYwXnPhNEjVOPxzUr2Q72WQjyw7pLwDI+ovlHUDbx7G9g44Pgv2+vB3GyHBFTdff3acIXxHOxSpFocQEc7jg+VCmt9Z9yYVE46yOfO8VdBPugd2D7xAClqXqRl5TPCGaYTm3uICecHBBDfhLFgXJh7P/dRZRq3t4IJmYKu+Ge0D82hbVoNMCOBSVOkYJYCHlAPVEGpnWvn+wKg0ao2o4/2a4TlLqwQsNH2/J+EiAsBUsV5+7u4dbIgUvlYiz/iIWqBIiYqSCFZBVXpXYa9ah5CJy6+2c8lDH5XjL4B9UGIkgv1SdTmjHkvnfKgn6vMhbsfaYaLsQWMLqVgvHedxErwOMcUd77BVmY2EawGQmWWYopy8VtiCr9Hj/leV9WwpmVT4/hJT0igu0yL6XhimscADNgNfdXQvXPbRJPJdfqeYFY/nPrNT0+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 30-04-26 21:53:21, Nyunwoo Kim wrote:
> Insert a newline in check_panic_on_oom() for better readability.
> 
> Signed-off-by: Nyunwoo Kim <knw0507@naver.com>
> ---
> This is my first patch and I am using it as practice to learn kernel
> development. If this has wasted your time, I apologize; it was unintentional.
> Thank you for your consideration.

Patches like this are not adding any real value. While aiming for a
better readable code is a nobel goal I would recommend adding clean ups
like this one to other changes/patches that are improving the code
(either fixing existing bugs or making the overall code much better).

Thanks for trying and keep looking for something that might improve the
code.

> 
>  mm/oom_kill.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5c6c95c169ee..86a08deaa697 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1076,6 +1076,7 @@ static void check_panic_on_oom(struct oom_control *oc)
>  {
>  	if (likely(!sysctl_panic_on_oom))
>  		return;
> +
>  	if (sysctl_panic_on_oom != 2) {
>  		/*
>  		 * panic_on_oom == 1 only affects CONSTRAINT_NONE, the kernel
> @@ -1085,9 +1086,11 @@ static void check_panic_on_oom(struct oom_control *oc)
>  		if (oc->constraint != CONSTRAINT_NONE)
>  			return;
>  	}
> +
>  	/* Do not panic for oom kills triggered by sysrq */
>  	if (is_sysrq_oom(oc))
>  		return;
> +
>  	dump_header(oc);
>  	panic("Out of memory: %s panic_on_oom is enabled\n",
>  		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

