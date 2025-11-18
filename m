Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A98CEBF61
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 01:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BACA8E001B; Mon, 17 Nov 2025 20:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1434D8E0002; Mon, 17 Nov 2025 20:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032188E001B; Mon, 17 Nov 2025 20:16:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E32788E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:16:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9075F12C73C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:16:51 +0000 (UTC)
X-FDA: 84121963422.10.C4860E3
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id B01C2180002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:16:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UXi2IECC;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763428609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/zaQaUgcusdFX7nIVvdS4Rs3VOW44H6bNGVPWT30wg=;
	b=A/P+roM23RUEHFufuqS7k5DcgG2+7K1PXHldnCxSrho6QDq/e3Fataky5EGJLwCfZkHWr3
	xQXUc7Q+pMFsHoMydZqnzB1iLc8EiXyTeKPB3e7xI9GehdUarHYjI/mDufDT4HmxzNkD1j
	spENoIjdtuFxkAYujlnSYhtyUq6Ybac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763428609; a=rsa-sha256;
	cv=none;
	b=yfOui3RijywsHsPkL65iy6D032pwG9fYaCZsKY0VkoRxF+NqBEyNC7DJGbVwXJzm4P6Cd3
	kvQN72ZykiL1hXonjuQd4J0JX9nkzIoK9HkRBohfa4lYnDXJwL2PLURuga4lvSn1HGcbAq
	J3aU8bM21K3VDPUu2OjL/5A0EtOzrR4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UXi2IECC;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b9f1d0126e6so3147096a12.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763428608; x=1764033408; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/zaQaUgcusdFX7nIVvdS4Rs3VOW44H6bNGVPWT30wg=;
        b=UXi2IECCxt7tU7RnR5t3E0W2SHFm2AL9OH3SWyT2FEBbA1F5bSWfc910GS+aQxgkF+
         7D4n6vWYhum7idJDR4zocalDLUBV6DNMPGUWvPT9E9qSmmX+VgInffQL/bgIAPqnTMhn
         BbX+5G6SmaH46uzjCTL4cuA7uRf6WuWF6n/eOuXjISk9a2aHE/dBDCIqc0a4SeTrgQz3
         q74p/o4k4C2vueS9vHv85EQGA828Wd8Gx0WjGTtMf+JxfxOk55UJ0ybC4TjOYML3w80+
         dGWmyR7Sm54s+fpW7QbMlGgXhVNob6zHrjWYROu/qo6rM7BhvvrwZuPMRZHORVap+eS7
         /PFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763428608; x=1764033408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/zaQaUgcusdFX7nIVvdS4Rs3VOW44H6bNGVPWT30wg=;
        b=Pq4bKFsIs6GS/bO+Oh7LvL2Z5iH8lM97jw98o2+ia3dAOTBt/pEpweFc+QwsNBbqoo
         xiJYESDl9gXRdxDdKLnXC8cT/femJ7u+RcJvfbd+Z1s6NrifgDqCm2u7xl64ys7ewYLz
         XnWv+2JHaCZwmJ4jbEJtQkC9SNZOkoUk/nicgau00IXtIeUZffJvxTmkvsRKsflAxW2r
         bE33SQLN6yJEqqpAGfqVu1xshxBHD10P7nkz57H4pEbDrI0FEBs3HPuQjpmG6X073AgX
         Vfv2LDV/+fGIzU/SKQoD7Issf90hRoHWLj67cORqo2dhiBnTVq8uL3bEpYOgAY1j6nCI
         7iIA==
X-Forwarded-Encrypted: i=1; AJvYcCXiu+wkMMSoxbKFRHNeuaQMuHiSWQ1hDtA68NhSmEaxhbEudnaU4q1dHcpUaGuf1O0PgBWgzziB1Q==@kvack.org
X-Gm-Message-State: AOJu0YyncI6poE2M7xHDze3iRNsqsCcjmCFtQViWtRDeYU5Hv3AQKEeB
	Pcxh+W3uOgvwlkg4CdKgDYJLfulJkD/ASb0O5/lydqt0+KGx3BdqxgEi
X-Gm-Gg: ASbGncvcnEEPQu36fBios5/eQXbhL5rqn1KfuogJQqZQtS3b0NaRbfOT/zOIRheHxtx
	8tAFGXWUB8r0vv5ASM7JttJ9Q5Td0X1pX8TBN7dmcADB73vp9eewOkAvLuRKglKE1NrozJIdMvG
	L9Tlk2YUDfD7JTe3Tj83UtD4PrYDY/ZFBU5nBiLrArTmmD0umU//CQyHRJbmieflCtU1VglIBtA
	F0pPp4irC/ZjwlNyoA3ox79Cfy/jXMwTXEhOJI+I0KKFgg8aMewetXITCEmDw4lXipShEG9RYFL
	AYb0snVU0VXHAQ6ifmuEN0OSJVPyzSOBLogAGRiMTeJ9dZ4vmTjgMjxKOGt53XUpXvdFqkZBcBJ
	7pQ36MFEavDhJD8gzHFTAOXw4j6Kg1Ej/4zuDhJKFgjRcuUTVoEoQKCgm6IGN/Kmj1VZPTy6mH3
	bb/AM1iNnkAHfkxqjOAiNpGCKyXS29a3QlgpyBf/pK9Tnjp0Jpz4laQw==
X-Google-Smtp-Source: AGHT+IG/TBV+A8bmaBoikqNUtCPQowFYhYHjj48TCLGRnn+yJSpzeNPkOqlPll9rNNnNRGEy7v6bsw==
X-Received: by 2002:a05:7022:1e05:b0:119:e569:f865 with SMTP id a92af1059eb24-11c74883629mr519011c88.2.1763428608428;
        Mon, 17 Nov 2025 17:16:48 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11b060885d8sm58399516c88.2.2025.11.17.17.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 17:16:47 -0800 (PST)
Date: Mon, 17 Nov 2025 17:16:45 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: david@ixit.cz
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: warn only once when vmalloc detect invalid
 gfp flags
Message-ID: <aRvI_VU3NOUaxfvk@fedora>
References: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B01C2180002
X-Stat-Signature: ecj38rqxctajptex6zphmqic3fa9os35
X-HE-Tag: 1763428609-800283
X-HE-Meta: U2FsdGVkX1+EVHTHKuEX6BVL44TmP14YCxK/Gs/4Uyj1qMO3DCuFW1RpWEDfbFQZJnDtdiTDO+POhr2QRwagGPAbSHLk/HLEBD3EeVaVWcBCra837gB05DQiSGtaDS1ykn0159KUR/8/nuWqZREXNtofxB2DXM6wcHHIFhBTOfmm77Kr3BCxM8Rgtkrumya0FtgnbYx2hn23xiALMvk/jt2upd4QKlmyNuGwhrRatjEGHNeQwqLM32EWPJh4XKp8tKqVgUa9e62YD3em46QABOSEw5UUE0HKpemAjG8wXkizeNxEjX/JP8wiGKyJk0t9n7pAsWop//HhTg15VVyYAMIeRbCBc/DRYIk2FMiFVBdnlqd10xPIYLIZJPcW9KYQYB2Y0lffMKYFNg0Qn7jUOLd/CnLMK5d0/9X88bznpyjKSj+31pG2B5nU8iXiI8yb+rAPT7OW+HgfQdhXEg1x99EMuTXpDF+l36i2+sOXWRcV20KDpvxgPceDrtj/rcGBC1F4NtsJdPxcL1Zr3hj0uhQsMXQ+4DaOpJvEsadeJQQd3crCRAqFcyMVuOvaAIyK0sFHCRfETzVn5czFoOR+tN7PqGfVAI2Cg/0J2tLV2ILvCWITWuSb3XgecH3Mwp6gTPcWWipt0VtbQQ1su1TSjaDzdp28TPsegnrUUQN28gSEvS74GMqHJhM7jZvxCwRqHCCvyaekfoZujh3Fwkpg1lNFC2W+8AaJEg7BTnsb+3UqtDEVcHJdCjpcY+dh4GU084A7hkvVWDfHGvpPpKtahArK8sLj6dTLxQ6AeibXutzcZGs4KM/NilRL5MT09uQi6UOd5HabqrIXKzc+iR4Ec55wTj2le4GpnmfQt2Pn+Lhf+gWsc4KFLDx971gh1hRxx2vgzhKuvfD63tiNhc889u0bqS7LnwvG7IZUp7kVl0RbcjA0c3TutNUWKbSrNiAIVI8nOIA6Oc+XwupBVhO
 q0dx15oq
 Hyca9xYz9cUFer1t5J8gITVYoHjVawpSWFLkfwSfdYPio7ScS3+hYPkAAbnLVaXSfJaGP0ubT4XvD4SWbaHlXHu/SNsL5VLKtjrsaYysrRfprYpeILaNm4JRQi3nwo3x8hclt/kdazM159kaRacsYL8E5IrdwkWlq6rhps8ssTcwNrDpNbDOAkyYca3uyZ83sFt0iHn6/Qa3Es9tAnHMWS8lYvfOHCvwzFe8ZKatt2cCciRN8GBtY1jSChIvisj7byguYoGnfkuNVMpCC4cniryp1MFUvDW8Zmz4bBHR5do9xHpA35GMBiD7ncHJ/828BKyY7f49okWU/ZUxQZsW8ZhcQZH3jW86n6XMHk2yP130934JvlQjv4QvN7o/Q5Ig3QTANFwXibZMAcocxEIvFdLjF5VAxQsTQwbXyu5fYqYor6FKieSjQmm5rToPLzb25KpDMPzQ3KeVJ1/Kozavd75ND2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 01:05:57AM +0100, David Heidelberg via B4 Relay wrote:
> From: David Heidelberg <david@ixit.cz>
> 
> Without WARN_ONCE, the logs get spammed immediately after the boot,
> on devices as OnePlus 6T (Snapdragon 845).
> 
> Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> I'm not 100% sure this is the right solution, but having WARN_ONCE or
> rate limited warnings here helps a lot on devices as OnePlus 6 (sdm845).
> 
> Please let me know what you think.
> ---
>  mm/vmalloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 49e0b68768d73..2a3ee17093d6e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3934,8 +3934,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>  	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
>  
>  	flags &= GFP_VMALLOC_SUPPORTED;
> -	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
> -			invalid_mask, &invalid_mask, flags, &flags);
> +	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"

You accidentally deleted the comma here. 

Once we've found all gfp the callers currently use, we should never be
hitting this warning, so ratelimiting won't matter. Either way is fine
by me though if you still want to fix and resend this.

> +		  invalid_mask, &invalid_mask, flags, &flags);
>  	return flags;
>  }
>  
> 
> ---
> base-commit: 0c1c7a6a83feaf2cf182c52983ffe330ffb50280
> change-id: 20251118-only-one-vmalloc-b8d997045791
> 
> Best regards,
> -- 
> David Heidelberg <david@ixit.cz>
> 
> 

