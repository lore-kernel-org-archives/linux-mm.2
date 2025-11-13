Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EED7CD8C97
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84AC58E000A; Thu, 13 Nov 2025 11:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8222D8E0002; Thu, 13 Nov 2025 11:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75EE58E000A; Thu, 13 Nov 2025 11:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 655BA8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:14:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09F1B4D575
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:14:32 +0000 (UTC)
X-FDA: 84106081584.15.0E1CC87
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7D62180011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:14:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WMyGg44a;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763050470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D69TLdbxnknJEodHNFVGBdjN3TtjlITr7+VI+AqAV5Y=;
	b=oYe50tBqA6OHc/t54xZI2dFD9Eks1VfVcBMoAMnuU1vhkP6e/fjV9rUCwLbTuV0WAz+UYt
	yrzOtlUCN+VWansKs9FKuSwqb/iiA9nATt+2jWcKv6A0Oc6QVYGrENeGyyn1VEtjkFrVhh
	iYQFlbxVzR2QgGZf7CnCFw3YsT6As0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763050470; a=rsa-sha256;
	cv=none;
	b=2pHBWXlJ21fzDDq0ZO0RqGSwTiOa2M4rc9UE8HMBMK6IqjK78ecLEwMC0iNk3xFU8yTF1L
	VpPS3Ec/4XLYBtZhlw4RDvGI38kv1Bgu7bfb4LhoUYDIHjiIDKyyypxzfb76NjK4m2g7nC
	pr9ZDi9HqjEq8r3Cm5K2ORsimpinCEk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WMyGg44a;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4edb7c8232aso13427051cf.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1763050469; x=1763655269; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D69TLdbxnknJEodHNFVGBdjN3TtjlITr7+VI+AqAV5Y=;
        b=WMyGg44aRxH7dj5ukTkwkFktLh3vWJmRLREzF84j3khfcaZ/W9GkwG6hDHqs4pvAMC
         uJFD/BX7FhGnn+NcVxA5s9dHYmPwQC4DLEgwkv2xnZYgjSzFR2q3+6+iTcBaBjdUAPhF
         WJOa80Ka6ND8fYCQNijqIHD0w5QT8WpJ+keaBhri+atLiL2kTyhE0pFsStUIzVCwf0tS
         Kzc4a6K6jBGbXUttCQfMZuULR1ZVZ5jskXjpu9YM0pA0TIcmU+Ooms0wI0WHOIT+F7Kh
         ID8r2N841BA5CSpG9G6CkQm+IKgqstPJLi2j3WdTS/OsnHoNEFsmMcB3LhtJoFim0KuH
         uWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763050469; x=1763655269;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D69TLdbxnknJEodHNFVGBdjN3TtjlITr7+VI+AqAV5Y=;
        b=pOmd2XPMQ1q9WyF7yOLl7vbQaoLHBvvHUNRsRp4PqAbAnytLyj8aL+SwBsMjonO+nt
         wnwSpMNSL1L1K6avTtB22uPcIMrCVD5n0pbpztb14VoxOKRSg1eJK0v5Yvp9oHlB/4/K
         mYahAbAaeWZvpOta5GxwCyM114e4wzPx1yuHGif8+ZQcMHeacDp1aljKZIqUnu44WpVN
         jZo1JXlFKdU4N6BM341LNcZiaGq0/VEr1Umekfmuh81lCN5Hp3AK6k6tGdrsOZWwoGQf
         oRl1V33VDbeArHVQJW11/iRrtRKbzWzTenanc+mZqle142speTDQzuleoLrB8aqHGqp6
         1hsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWavwxE7Pkbozr9qANkZ9vDPxq8Gfgs6xgIzAOsr+abOkgqnenlFYQEJacvME9+GHOpo8tAfmIE1w==@kvack.org
X-Gm-Message-State: AOJu0Yz+i8gxEw1v6VHyZqsnU5ZQdi2kkKpHhR2v0MsisMfOhIZ4JOOz
	+EbpalT8k9eIwh7nD+H1BSYgkW8KRBuNG0Zmp1HQuLYo5WF+oMJg5dK6qPyJh9SB5yM=
X-Gm-Gg: ASbGncud8lXmtRmKUmCit19TXVOTmlyRtITUWmE+JVdOylSJQvhPApF+bhWnXAwf8yP
	oFVMZT1pQAVvN4iNcbloLPicJbrP4xrrNy9u+nHL9Dcgh2zyuIWHCTtt1YZopbOoe99k7GREo/J
	6PJz0NgSwZK0X9YTMlH/azr0RLPi2DkzyH3/hMbiyPcFutH+MfAHpk+FlKYXEgKFyMfbpyd2Rnw
	cAbHAmlzfudmOEZBL67jaTg9xraK7RdYQW33R4rWICDNbT5IDmqoY42pDSCDycN7Hl7ExkW34B6
	kfVxF8cmfUdptH8Y0RAJL3hMsi3LKlnizu3eUKK/EqR8C7Va5NoD8UiNcHNonaF4i7XJpNvc3Z5
	HgoJ/slYBfEpgSeC8cZSPRKf15clKauQQRvLU49wPKPsiSrTIlOXQVX1y4LY+74R0OgXf2neSIt
	l+8QrIU0lj9A==
X-Google-Smtp-Source: AGHT+IFMoZ5CF2EVUYFz6bRcYn8UYY+zeUZ6tQhwL5YOc3+o2Saf1JPdJPogRlkyrwZ23BIM4+DEVQ==
X-Received: by 2002:a05:622a:4f:b0:4ec:f073:4239 with SMTP id d75a77b69052e-4edf2048873mr2996101cf.6.1763050468712;
        Thu, 13 Nov 2025 08:14:28 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ede8816ab8sm14289731cf.26.2025.11.13.08.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 08:14:28 -0800 (PST)
Date: Thu, 13 Nov 2025 11:14:24 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Message-ID: <20251113161424.GB3465062@cmpxchg.org>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-15-willy@infradead.org>
X-Stat-Signature: chfyktaj3ejp9r3nnhcbt5az9mq77p84
X-Rspam-User: 
X-Rspamd-Queue-Id: D7D62180011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763050469-924889
X-HE-Meta: U2FsdGVkX1+Cm638u1UapOz+nciOSOieCDOJT7trpzBQdZHqbByR9yp/4T0jCvpKnPIkdBG4pl4qFeKa2iyOzgWKQwkF5m2DXW44Huib1y2vYbrGZNFjJORzlwG8e27rmwkwGi7W99COprMzcYftR+lyJxo/qmkZXnrvZqAif+oiDfnXL+O2x/+nMAIIDyN8vuEPq2mGZ2/zUoRxBaIHothpK2tn58wakuXbU9iT2poa1vOxHTXd5Y+FoBLmQ4eoNDOR8ahatmiw/k6sxtVELPeWInKNnA0xf9cKpMMtajmyMkzq/Wx3ABwsKXrVZ+u0Wa9EuQ95ZJmi/xi+mO2kAds3mdZyYq/nFxEyzJOlejR4BTsTiRlmivDQVcgUHaXTMqF6MW2JW/8f6JAXcQyVExFNYH2QqrGVhko+oglp4x/IUlqiD0hE1yrrdY6tZ2gGuukmf/Qb+Ieact9hNRlYyp9LCuDPL9rEqV3HC/bKb/FlrICY/NYmVRCKXDAaHBVGfDQMH+wch5IFDzgF5CvBoc6127g/pMEYaHwDbJ9LL42ijJVgY0LGeQBfQZ5zu769CO/D8B8GeTsT0QguCI+yYsEBS7kpJ49L89y0nm99qDvaUC6KZQflqsrKj0BlXSomfVCPXtLRlIItThBCQwwDPRsBIJuffoIT33GF8XQZbxrFlfkCVLXTVfeDcYpmhwdn24Myy2pWXZ+ZOyMOhWAO6I9TbLtDyiUDS5L8o3M1sRmwZdQqC2qVwjW9a7mIFoJojQ5AdeIk6JwCRIxp7bM9WRjtgOmyxlYDyDayCaK/Mx6AvEBwesHaFiERa7UTKGuhPZxAvlQBIU03Jdr3ZmZuwcwJwpb4x4XpclUI/5xs4wpINe4RWqUMOY++NYq/pMUVhrZkCtVid37G+sy1b4zFM7pcqz5Dlr7Dyy52oThCFHYBmxpImxX5jdf3Z+pZIbzY7tINUWsWfDPPoRQz0b6
 PJtP/2S3
 5iP8T5OccKdTHCF4sku4Nzw5msRv327fWFkMnQ+e9SsGmCHgMcWQtLHX5J4gOU7it5iSWcV1Sungn4aGRQbF4WyZAuEYXpOyokRAdQo/9BHxP0zAqMC8HOFFTZAjpmXwykCVVwbexBx3aMJ2ak2+k2KOcrHwvMOn+ucD551B8WHK6u/UE0ux1ZP2AU5u9hrxH7HHcw8Uc+40QZjD6bwQH7lEOQ/n2Q5TDkoRj9rZksj1Ct4znLnBPuEbCecCIbbxoZQ2OzFYkYfPkAHGmVk1eewbVz6G0c9fNCtX1LkbcS+qFT2hTqSp8yoUnvujF+bdbrKiTEX6Hf1K8Z4pS6yGXFCUeXQBMhOfkkrul4FJK/EWf9H1n3F4If4WPcx3odnxtYcmkTMvujZ0aCeUEPQVeHggTcvrg1je92GN8uogWx0mXfp2VRLuFJzPqmuvz4ToIsYoP2m7NAPUwWaU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:28AM +0000, Matthew Wilcox (Oracle) wrote:
> -	/*
> -	 * folio_memcg_check() is used here, because in theory we can encounter
> -	 * a folio where the slab flag has been cleared already, but
> -	 * slab->obj_exts has not been freed yet
> -	 * folio_memcg_check() will guarantee that a proper memory
> -	 * cgroup pointer or NULL will be returned.
> -	 */
> -	return folio_memcg_check(folio);
> +	off = obj_to_index(slab->slab_cache, slab, p);
> +	if (obj_exts[off].objcg)
> +		return obj_cgroup_memcg(obj_exts[off].objcg);
> +
> +	return NULL;
>  }
>  
>  /*
> @@ -2637,7 +2627,7 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
> +	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);

The name undoubtedly sucks, but there is a comment above this function
that this can be used on non-slab kernel pages as well.

E.g. !vmap kernel stack pages -> mod_lruvec_kmem_state -> mem_cgroup_from_obj_slab

How about:

	if ((slab = virt_to_slap(p)))
		return mem_cgroup_from_obj_slab(slab, p);
	return folio_memcg_check(virt_to_folio(p), p);

