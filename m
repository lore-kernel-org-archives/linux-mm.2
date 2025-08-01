Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426BDC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B826B007B; Fri,  1 Aug 2025 00:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3AA6B0088; Fri,  1 Aug 2025 00:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C304C6B008A; Fri,  1 Aug 2025 00:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2C8C6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:34:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65DD013470F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:34:33 +0000 (UTC)
X-FDA: 83726922426.08.EA928E6
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA74240006
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:34:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lVpxHE3t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754022871; a=rsa-sha256;
	cv=none;
	b=nX48aoLrm4rfMiF/WCcDL7cFOc94ZkmwGT9Q37Co6RK6JoDnTd+Hr3gpfhEXQqiO1A3cGI
	I5eSOeZc4Lbsn8UxMDO4jcHq9pqEGly/bazbYng+/cKO0gZ/fG43jdsm0Kr55ItPeo7+la
	ur+SArWzQ9p7FXlJAr6uIWWrE11uUCY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lVpxHE3t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754022871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Hvy1+S1s4fKJdVyggMwF0uoMUuYMvpNuWclsNDW3SSw=;
	b=welnaPj288OHj84WpC2FT51/J3NfJnpJqsIAMlTQJjghxZmqVS2y3MVR2j83Fu6BtPNMOg
	bBPTtMv4SUZz58+uKtl6sleZ8RmtnNBLkuO2ptZt3M8W2Rri5WLZSDk7qrQw9iIRUOgmHA
	OvIcPPLmz3vWyu3lmBMjuXdy5xQWHac=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-23fd3fe0d81so11957835ad.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754022870; x=1754627670; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hvy1+S1s4fKJdVyggMwF0uoMUuYMvpNuWclsNDW3SSw=;
        b=lVpxHE3ty094vx0CBsJmIUkNyk3Y9wv9GbnRuM1PmX/qhAf2+Q0pAkCRRPKLm+Hriy
         H3Xv1KvRbqcMiiHWT3CL2XghxSyvOjqVdpnmAZ3Sj5EmX9Us5ThYW+gowuZ8GeNzM479
         pdwyVQuR2LlMvlg12LQNceNKNGKbCAdYUGSWmDxjfvgnr5K6k6gnfh2kKpSl9t9UDEtS
         jevHokjbynnd5UHQ5hOW19x93tQrRke3sJ/LBamlyoBwd6S45N3q1aXy6HFNetKUO+o0
         BxJoODJDdaO4bCTsZT3KMFI919pHGbKNJ7DlSWXrRySR4tz9dxsrkZy/3Gu/w262E4gY
         RSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754022870; x=1754627670;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hvy1+S1s4fKJdVyggMwF0uoMUuYMvpNuWclsNDW3SSw=;
        b=k3huYkLY7VtrFRReAQEVDXZobc3HMTh249dHc9jGIwPy1GFKku3QN+6FJTRBmvMNRI
         FNubVaH1qtDalTHTAtckv6QNJy2N92OnwJjqwRNT5sw4pZUhpn7RSh27cV7mquunfOQF
         Gw1Z0rans77meFwYH0fFugAAictD47cLsGDFQvqPphdrlCkazdffmaHrmtJAbHq9KV3j
         8GDpr/YFNCnUjJas1f1G4Ll1qsbi+tiSn29X8spXC0bj8sRMaUIwQDvXItnVaUynxIgc
         l8kmtEZnFxPPRzfHCcqmg2yovwrrYWQaZ+a1RScWjKxXY2Ul4xm9eKHeMCKPaMoSw/oM
         ZxMw==
X-Forwarded-Encrypted: i=1; AJvYcCWLvcsmosAn9ssOvz9oFgAjJ+Jj5z329iYbnfRsV5CmaPCWr9Ptrh/LftILZKXHVAonUPY6vqxelQ==@kvack.org
X-Gm-Message-State: AOJu0YzRj9ecN+D/jzN6PFmZk8oe3JLZaODhYYlsaV9kf/N+0jcU+0mK
	FjQoyL90tSvyQR9bBJ81QIZ/tQbnIRMwv8GM5DJTlYBzhCoSls7CgbEx
X-Gm-Gg: ASbGncuzWL01l1VBXAAxTCqFQmiImTIiTOVhoDZOFS7oi7kAWTkARw08WTNFQ6AwuBC
	+xwcvzbbG3GesWxC8cZlZ/TixeKdwp71jaFnVL4reRRxw1a1TmwD+ud7RQyq2H+NrBHqn5hxJnY
	Gn+GNePMSIz/J7CvPdSLG9Fbx1CUFqfKrZGUH5uoIgI3mTZvvpsDqOQ1cYnzA8p0EqaRWJFXNjd
	TAPqBa2F58Q9XlmQ3ROtf+TP+ZJ7A+GJLFwUatd51XcKGWYT14wVQ3Jh2Kuqna8Z1PQl2DgcR4y
	WhVphF3PK9tKVT9+I7tgrC/cioWviYArSKz/i0dv7LcVEXW3NtFZbpi2qQY3qCkm9lEvVdLKth/
	HfqWy/V713+yRnb4=
X-Google-Smtp-Source: AGHT+IH3hwA2OpRbr/zHoWNUCy0aIL06wDEuaRMcP/tc6VQhVRBB71zAOlOqZeisNVx6p6jZ1hMqIA==
X-Received: by 2002:a17:902:ea12:b0:240:a8c8:5f6f with SMTP id d9443c01a7336-2422a6a7c11mr18344715ad.27.1754022870462;
        Thu, 31 Jul 2025 21:34:30 -0700 (PDT)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0e7d8sm31815305ad.42.2025.07.31.21.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 21:34:29 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org, x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, kernel@pankajraghav.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC v2 3/4]  mm: add largest_zero_folio() routine
In-Reply-To: <20250724145001.487878-4-kernel@pankajraghav.com>
Date: Fri, 01 Aug 2025 10:00:27 +0530
Message-ID: <87seibr7do.fsf@gmail.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com> <20250724145001.487878-4-kernel@pankajraghav.com>
X-Rspamd-Queue-Id: BA74240006
X-Stat-Signature: 6ge3nzqgaxe15qsfm77kjhqodji77ojw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754022871-137750
X-HE-Meta: U2FsdGVkX1+Kk75PYnG0g/HB5xjGzL71+ICpw0BfXYh6Kjx4a9P9R0w2tJM+AWYUxBvUZwHZKeJ714YUfgPMUvs1kNvJJXhavfkdgaWkQ44aRqDjqUoatE+Ly/nh92q+13QgiIX8dz/xmlnVUS3OqfiTKTUpO6+/HIynLKpXc/OOwmAkgBHUDEWahlxN4GMTMAioYude7PDWCqSdyMGKUJa40t7LyLGrfJg/DTCHUrKIk59aggWEzc1sdIfXmcucKnkjs2ydBzE0jmUHgMjDF6WF2cMMiFF1M7U9Q9QIwZs5CFv8iSFCG/p2/hi95H2qMrOJs0/4u9aylsht2fCWs/6bfEVcQfeNa5I2GI8fkiZ+CroJQ6AwglPHm2qevn32AYa9n5+8NYtvfkZLpsePt2il1dt6zMquCKA28vqjKCTwNtoTJehYAK0VpOJRrgfsa7J/Xxr49v5Umv4g7jYHHOsAmpz/7S888H+mkxdD/+G/rxG8vOqmx6E8Vm1uKvVM5sTWnRzt7NK7mDyysU91v5Ad7FKHrQzcusgCvI/tUDoe3A4xuQ1vbpegVJAZfRLvNxQx+Fsmd6g/KZYikDFBkchA3d08QiCLiQq2WUcvCmrGaX0vtg2OTWDmyhNszOZfBIlRTKPKujDO6tWGKFICF9iH4CC/afaENROAX7RoFUOeeJXkot5EkzTycnl7Jajt9lpZCowARCCZVQecdq7yJrZusl6gQfCdXr62uvIHT1EXPZt9FzEr1O1d18qxcLDOJrhkgbmcEQ6lRcnu7v/PlPQ9dN3zjRwsJV8t7Wygv4LekjVm/qLfjxTi206oo/V8FPa8dSWlnXm944qvwkpG6qwt+kmirtTEEGfG7im56BCYMJ+sZwsicnwPxdYWLWecZzPVU4dwDNTZmU2H0gCM7twNtfcEnJlzoMdM0YCumD1ae5VWXMtoxyihjxEUgum2Hu/2kUvqEhVqvZaT4lq
 7TERY3/C
 elRYfQY1r2R38jpyTrIOBYv4NxVNV1ZPB2OR7UHL1MVP2BdT6fLe35r/6+tMZib4u8IZ85mLMja5AwU1/yK7FylXncY4+eAqYJxmC/Q3M46TJAJtXrBcgaoYu9GAiSysTkq4THWXRYN+LMR7h+HZFkHzn7oPpgybMCW5eJcVu3+97vis=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com> writes:

> From: Pankaj Raghav <p.raghav@samsung.com>
>
> Add largest_zero_folio() routine so that huge_zero_folio can be

[largest]_zero_folio() can sound a bit confusing with largest in it's
name. Maybe optimal_zero_folio()? 

No hard opinion though. Will leave it upto you. 

-ritesh

> used directly when CONFIG_STATIC_HUGE_ZERO_FOLIO is enabled. This will
> return ZERO_PAGE folio if CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled or
> if we failed to allocate a huge_zero_folio.
>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  include/linux/huge_mm.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 78ebceb61d0e..c44a6736704b 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -716,4 +716,21 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
>  	return split_folio_to_list_to_order(folio, NULL, new_order);
>  }
>  
> +/*
> + * largest_zero_folio - Get the largest zero size folio available
> + *
> + * This function will return huge_zero_folio if CONFIG_STATIC_HUGE_ZERO_FOLIO
> + * is enabled. Otherwise, a ZERO_PAGE folio is returned.
> + *
> + * Deduce the size of the folio with folio_size instead of assuming the
> + * folio size.
> + */
> +static inline struct folio *largest_zero_folio(void)
> +{
> +	struct folio *folio = get_static_huge_zero_folio();
> +
> +	if (folio)
> +		return folio;
> +	return page_folio(ZERO_PAGE(0));
> +}
>  #endif /* _LINUX_HUGE_MM_H */
> -- 
> 2.49.0

