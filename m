Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BB41125857
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE61C6B0005; Wed, 11 Mar 2026 13:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E93AD6B0089; Wed, 11 Mar 2026 13:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C106B008A; Wed, 11 Mar 2026 13:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4CE86B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:54:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D474160305
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:54:58 +0000 (UTC)
X-FDA: 84534533076.20.FDA7865
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3514A10000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:54:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Rx5CbQWc;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773251696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBORJCSAmU4MdfkW4MURe7WkkGRHnZxTHtzIl30bPMU=;
	b=K7gsFZnpHbzA0G3TphppNKBweDicU6bkDmRBbtwSgvfH+D1OhXAzn6xSwk/KysOlMEDa+c
	4Mt5hkOkTzWABbVYuKevikR6iC8/XdbraOYTz7mhSq2yrduSv7mKw8jcHbz9d92rISMJbP
	4I2pbG78LnRWKMLyxo0PpUB03dhP49o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Rx5CbQWc;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773251696; a=rsa-sha256;
	cv=none;
	b=f0x4Beihv0PokCfHPM/9L0XVLhbvr07T0X/3Es5OkeKTzbTSbfzzHJE8UcWA2Dp1oC5MZ/
	LbllhVVauQeElhyBSAdlyFpS2pQaB2tDq58XrceWXjlmM6UckZbksPCuXW61T9chNxv8PN
	FE76AXHsefSp6/V+gre01kSbgso+p5k=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cd8c6e365eso10354685a.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773251695; x=1773856495; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XBORJCSAmU4MdfkW4MURe7WkkGRHnZxTHtzIl30bPMU=;
        b=Rx5CbQWclnVvbuWtQXLVIuClQwtrOYaRT989xR1sPclcPlXBxQ4u1C65GqVhmfbPo6
         xyyMbkeUeYC77EGdDXiqiStVDhLNc77V6Rz+rKbHmkakENusrRwRJZCsfKlsZXa7QOhO
         AxsZHCIqWJphnjh6txouKjrjbBTsXUmMC6ieMC3y4VAf9Zz+ZwzagPn9Y8cQmBp3mxjr
         RIRjR/L+DSxrhqIQxUnsVNaihu9XRDmcDMppcrHVksZIG1aZGR8EydSXpMLiwf/e5M2L
         NReCsuDAnuZnju6c2gsmiYygnM8VPNT3e9tSEV+0rqYw0JJ9X7wsVE5NQvuf2O0JmE/k
         QSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773251695; x=1773856495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XBORJCSAmU4MdfkW4MURe7WkkGRHnZxTHtzIl30bPMU=;
        b=W4xUqRQlUNgqAiVr26iAZMeSGuAat+oo/ragyHHY+HI28YNiMdRDZ4w+l+tQ0I3aAx
         mVRxmU5gwhgb/YkNza8Xrm6Z5MYBXiKftWvTC5QvRPe82GrBBvHXCTVRAKkYhAgQGiVX
         io9A+dtCb1J8TiwkvcAK3qvkoLq0NJwMR5gBZTkMQh2Xd66ITYRK1sxY2zLyKoEJU5Qs
         DOK7MSpmezELefG81xr9lDtM7nN0mywLaiSC/lHKnJwpqX3lT93qpjbs8lJ/hL8Jvx4g
         ODsV/RzrkBxXnJB8uo340AHMxZFowUSI6vZN+jwnftZLdDU/OaRGaZ835v3Kih72AmRI
         UjTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXu4BBCH4xF0j2SiS29X0aG4KiYdvtr5O+P/gHl049nAXuSu5IGpiIjpQMjGik6slL9PiDL++axWw==@kvack.org
X-Gm-Message-State: AOJu0Yzmbu1hOXaoRFADpXlxhNHqhUL0dXv67bH98MsR3rQ6tLl/sJ/1
	42wGRUp6MB7YOPAUQvkzaRiT6Z4uH9pne2o32yscu4jLnWH7dbPL7QtpqfrfKxdTGWM=
X-Gm-Gg: ATEYQzwSbm3b8/9xyey7DKja+zDOAAEyevvKzGcm8WQdNzlGufVZK8c70YyQyOD3HPm
	lrvPbURfLO8RpMOli08OMcXby9KVN8xsx3WRc95K4ULfHj497yaG4rSP5i9p8ySlK7L6T9HNSBA
	ZPlU10Z429bBJGXJql4OJlYNXdeacMyi1vAVbmFXvxi8js7woRYYVTKKoXXYAf/o1zGLqXzBrcl
	REVpJ+8iAH8aA+sP2S6db6o9NafPRRG0GoZGfCXH+cy1OGGhOpyv3kLdjbtIZKyRM9YcF5J5548
	VRI+a73Hd2qsfcKM8Q+vnR154LZDo85JFyYzceBGKPrPLNXYw0qEskGdhWm6OoakCpaHupqnO5Q
	/W0z0ValHh/ZcgaHh8olRGW+r6d6Ixp4tDCr0SE3cq2ZwqpGhDj9t+PeN77YV98H5jfi2srWn+s
	6JiL5zw4opEvyBnvuz1RA3mg==
X-Received: by 2002:a05:620a:46a0:b0:8cd:78fe:35e4 with SMTP id af79cd13be357-8cda1a45948mr470255485a.62.1773251694997;
        Wed, 11 Mar 2026 10:54:54 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda21100b8sm181981685a.29.2026.03.11.10.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 10:54:54 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:54:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, alexghiti@kernel.org, kernel-team@meta.com,
	akinobu.mita@gmail.com, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
	joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Bing Jiao <bingjiao@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/4] mm: Fix demotion gfp by clearing GFP_RECLAIM after
 setting GFP_TRANSHUGE
Message-ID: <abGsagHIieEobFbB@cmpxchg.org>
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-4-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311110314.237315-4-alex@ghiti.fr>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3514A10000D
X-Stat-Signature: qx5hrqb91k1t9xpjb768p7ja7yyhpee5
X-Rspam-User: 
X-HE-Tag: 1773251696-704570
X-HE-Meta: U2FsdGVkX1+csvYPCSSGa+QFK5CN8noTdAaHWp7fOJEmQOEzh+qA4F5JcHIRMb3McmrKRQRfhjpyg6OE+0WfpwBzMqEr1y43ZO+zcy06ov1uvzlaW8CMw01kuon4wGfJV6BPf/dIJOHcqBGjMD19cYZPI+lM2EB1MoGjK9krrT3HIBDhMCDUq3SIxu6xx2Frihnw/3DiRpNHX7DUhmEv4kY48i4k34BqvDLz7jJrJ3KOURSvWKUufYJUYIYxiymn62gvmD8NF6yVJLvD4p7OAtfl5OQw7/7WrF+nbl2I0leEn23RQ3WJ+eQrDecQdgZp5YCGwlbfiV7oJI23KnSIngw+0y4cAs56h6RXekafGWFLtTLb+bee9xkZPTX0jtsJ/fW93l7Et5LtfDhryQmAmgoqm81+883JzxMWooPLAPaxYd+DwplwvTyWFNjolsvc/5TyiC5f/5DTATnBfs7b4Afcgv12wvWaXP0tzsv/GZenwcVnvfyINoWGKtOuxqHkJ29vAlW5CSxSc8s4LODrfTSwdqXIfHYIWUAs9R2DS1Hya2ddTrizURiMIrkIjj4Kh59sE8A87m9YJtpZeo2buu4pExPxv55SMuWzUv/KisqAITqNyg7Tr7jDygXt+8gNxEEZBRPgti/H6+1oxoNfK2eHCRJC4nu98pcZaVosKkZPAc4XyI4fsQisM/dh9eIeNgIznJ/AKqGvv4VMT8lgquKwmkQ7Hnp5IFxzc4P9DSMo/SGwTXf6JNqyHrGCGw/0870uMNH83N1OdvomdfJNHGdoK2t//mxJ+nkVkXr3MUE7SwL6kK2Ve1j6fqyUOvAMG/BZLqy1EsifZdhDEdCcHsh0ngcaTMi8APpGKq7Yv3G5dBKU2dXQzJXCerhxPymQVnDpylY3RgajhnPU9I4lVHfd52C01ksGCBO2SQWpJTwuqcwuXjXJniCdItzihRLgyHv+Oph6XEnjXOQ4Rfa
 FGiAJfxi
 3BO/8r1U7NvHWbe+z/h51WxzQFfdoWKC8MvjluUv/ntGS620XQ6AnSvllIjFhgKRyR1zRvX/dwUeFqoXdI05ICsU88vYgaxHSq18e2oq3x9dXE3/QXzvd2bpbGJQH/437UXB4nyzJBzu5+kdjUEFmV7cR5ubhtfMbToaSNR1QM5KE4dHOSz4jOZdfDOrNhDOPgN3yR1cRP8gTXll87TQK2yeR+xbSE5rrsQAqrpJxb3ZFQvVnLHfvKI/yaQ782Oc6Hs8fYz5Jmaoo4mHqiU759jWjB5iLZZZXXzfj8C3EgXK5nLK5DaUtWxdDGt4qK0DvwVPet5Dx/+sPWuo8YcoFUT7UTWWVYyFSpoBEUcjhHdhonpdX5TL0fNxKWhzNVRkpgBHsPJfIIRLP/vt0AHPlNpqflCcvsvrTBOXT6qdcObh8aPe+RIoEyB+ypYhQZypkkNjzZX0NRdMnR65Bf75dNASg93iO01Ayz62n7DZueEVc/5GTUpoXMGULrekgPc1B1InJbuEockpPJpcrkHRCw89FTuY/X+tP05K2uB0Ss9rBgdSKBGqUoahzfvsqBFDsG9lp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:02:42PM +0100, Alexandre Ghiti wrote:
> GFP_TRANSHUGE sets __GFP_DIRECT_RECLAIM so we must clear GFP_RECLAIM
> after, not before.
> 
> Reported-by: Bing Jiao <bingjiao@google.com>
> Closes: https://lore.kernel.org/linux-mm/aXlKOxGGI9zne8sl@google.com/
> Fixes: 9933a0c8a539 ("mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 2c3d489ecf51..ee533a4d38db 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2190,12 +2190,12 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
>  	}
>  
>  	if (folio_test_large(src)) {
> +		gfp_mask |= GFP_TRANSHUGE;
>  		/*
>  		 * clear __GFP_RECLAIM to make the migration callback
>  		 * consistent with regular THP allocations.
>  		 */
>  		gfp_mask &= ~__GFP_RECLAIM;
> -		gfp_mask |= GFP_TRANSHUGE;

I don't think this is right.

The Fixes: did it this way to disable kswapd for THP allocations,
while still allowing the customary direct reclaim. Maybe a better
comment would have been: /* GFP_TRANSHUGE has its own reclaim policy */

After your fix, direct reclaim isn't allowed either, which makes the
request unnecessarily wimpy.

The Closes: refers to reclaim that should be avoided during demotion.
But if this path is taken during demotion it will already not recurse
into direct reclaim due to PF_MEMALLOC.

So I don't see a bug in the existing code. But maybe the comment could
be clearer.

