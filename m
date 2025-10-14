Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90209CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 19:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD588E00D4; Tue, 14 Oct 2025 15:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD55F8E0090; Tue, 14 Oct 2025 15:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D120B8E00D4; Tue, 14 Oct 2025 15:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFD6E8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:17:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F2B31A0A3E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:17:33 +0000 (UTC)
X-FDA: 83997678786.22.7194DD4
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99D5F14000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:17:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IMxkfZEz;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760469451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uDSBrC8cLuTSNHDyZiLCu5ZpZO8rOAjsl8ZFn/oXgY=;
	b=Tv/RtfdTngSu4oZcUVNfKUvz9SotACcxmahoHE9na0F+eoD8IJxL4AL2lau9kb51YpKHMS
	/p+r0YPeEDSrFWHdXi7+9YnsS7Qnn1OLdssYkY1/ynOmlbR6l/LPRa+gkW/2eu6c1lQg8T
	jC5CuGDoaFlxaxYdBcYhyDbtr/HHnXE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IMxkfZEz;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760469451; a=rsa-sha256;
	cv=none;
	b=XY75VCOKuvHtqdznt8n2xJHZQb2RPGlfI11pvGQWbRe2tyJZyBN83idQYsFG2e5Tg6tlbM
	463dfMHs2u159hJXCz/R1PCKChHNOEOiIgDWJN7CblZ6HYOpFBzJoPTUa+HFPcxGNRlmLK
	TsNtiUyHmIegCDp9EouMCYPQ1AJsXHY=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7815092cd22so12160257b3.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760469450; x=1761074250; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uDSBrC8cLuTSNHDyZiLCu5ZpZO8rOAjsl8ZFn/oXgY=;
        b=IMxkfZEzQU4xoxvYu2M8qAvqBzB14UXas5rIFCzaFRYoJBNdzSymIhpQA9lbgN4W3C
         IUbAi20nIAo8rGj+Igqgx1eu7OTT7en3LxKsZIUkIwWkhC6s3YwfK3HaZPBlx444xWOk
         8yoagwFUyJF2kY23xc7sOXEh1U9IARKwh0hzsaYVJEVSQoaKBp9ESb54z7W4suYDZPkt
         2hfC2ste8W5MBbobbYicWUflrDAkoNnn7rKBxASCk9PvKwhnMNbh+TsNDCnYRJ/uXgvG
         7KuN+HFpL44wQr+7oOJfB6cHqXg7hc3Mx97nfpYEuD6/ej/BIX0VRUqT3V1NOUuOFNd8
         NHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760469450; x=1761074250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6uDSBrC8cLuTSNHDyZiLCu5ZpZO8rOAjsl8ZFn/oXgY=;
        b=ZCKe3sr2GiFH2SAobADPURukYJWwOBqc8wqzYiccG9njM2v2mIjcCvtwhqrrmAAB/O
         l5/PRxx6M3tjaIw52vwohExEkcbVstvOnK9kPmEBBnPf3uZ7XHHex+EaAubJB8Fwc44f
         R8OB3Js5tTbP8kgswWHrjR5TqH69gEABXjHXlrk91cFApiAGx64ZO/YTY6VdxO6h6Kv2
         nbG+8PgA55LiBf9CoWJa58D9MMUQTe+925UVc7eizlkYc84bUzNk9ohWyfgU1OxK0f/H
         5wctU91hg8eFUgYCnFwGSbLoFCUL6Mey+1b2z5tmI1m5+YanhKSWIucMsVBwllSJ//fC
         LlXg==
X-Forwarded-Encrypted: i=1; AJvYcCVMLXApXPucwjaJLKSqiMmjOQJm//Oj5T+6PDyyHqztiZ5oSgqhVF6DvkVMx44PvqrI3DS9yKysIw==@kvack.org
X-Gm-Message-State: AOJu0Yw6a/ZAJMcmIhnCbIIqFHjwcgFSXA7FQgan7dT/rTGui1Gc1LtZ
	IzXDtXZX2lnSU0q5gQGeU3h4eckr7qG7sdKBayOGHP3kMMz4NmJstc4F
X-Gm-Gg: ASbGncu9sMuEspw2vUQCZpwhMrf77rn7ybbTnVvgKkFZ5ZLTaGTlMv9P5m3eSvPXbZd
	ruS+6C3uF467Z5oUqf3qH8AuVoB7FZt5ZJZV2lqBuG5hQDh9Fl2a798R3lJpRKpeXOpVA8AKFgP
	nA4TPpY1uXXWwBuD6vEMkl57eYs+d1H6UP1Hh3j5T3jJsSbLqzH88fQvt3exM9cCZL1JSJ9HCTe
	GHYXhEhqhksOGGoxLD1ERs9JiiIxTplbDnLTKFXrl8xbuzkRzUIXysLCTquXOlhMG+GY3amVXPz
	A9qx75I2FvjRemPC04lJBd6FxKinf1WC2bwlwHc/UEyk+kP2vcrEL7eMdBpdsCjbadtX0v6r76s
	iHX2tDjoMKaiXyoqAykfF1QqnLfw7CfpELLw3N532949VOFE/D7T69uxg1ljCNRNXDVqHMn1r07
	a8iL4Lq7BftxvW8lPIs0A=
X-Google-Smtp-Source: AGHT+IF1b9AAnvNc6gLY8LoyIsmgjxUrlXEDNaP9TOJPUcJClAPAZoYgKHkl+ZfyW0Pn5VZag/Uuqg==
X-Received: by 2002:a53:ec89:0:b0:629:9c6b:b3ab with SMTP id 956f58d0204a3-63ccb825baamr16716867d50.1.1760469450484;
        Tue, 14 Oct 2025 12:17:30 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:74::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63cf0ee8ccasm3560031d50.13.2025.10.14.12.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 12:17:29 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 0/3] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Tue, 14 Oct 2025 12:17:27 -0700
Message-ID: <20251014191727.788875-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6d62386c-242a-4735-add3-fee9c6e0ba96@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c11y836uwda3655aextj6x18n8j4z574
X-Rspamd-Queue-Id: 99D5F14000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760469451-465871
X-HE-Meta: U2FsdGVkX1+ox9vTMWtbQbqw0fVO6yNgREwM56fTjnGo/fasWHO6ZEZoLoVhWbwhds3rt4/S+lkEI/qryiuFeMwisu1854/+Lv9jT8pDHAGAEWaklHZ7mOn//K/c2eSbBaESVwNVoILls/hYMAfHlrlbZc7ykO3zYOj/RodZ9izG5gtgX+h1dSesOPEtP2Jl/dTbHhmpTtsH+BEpddCKwahvBf659P5rBNseY+jA6Ju96W2PTxh73fRjXkgJXpuB+2DELrk/jLR7wl6JVWmN3GAwZ36VfWMdYDdF4djtgvWN+Pvo3pQ021lNAKiRHZFMFd4k7YHciT32uEuVPwZFWnHYBZR6l3iFnj8ritrX3+xTHScX3EtuaG/fo1lCBDi578CBqfl1dvre3rIMJb9xAOne0siEp1xrSrA7bq132pdQtLtFmXnWrdQDvU9DD6FvgyUDfa0/WAvBNnNwx56blxQLm48+lxGedmLizYhfKcmho8+BHg8+3ShiFi/z6Hu95vUbuHv+5qJL59Kw9Yp87dlFurE+3lSiHJasDur+8KtCPGPtQ7w2Uyww7TCgEYPivcgHuhz57cFqzPnSIlXFMZJloYleCbDeTPT0puAYZarmiyYw3MkTta3yaSaT59BDjuoqyu+cD2qEigvmLLLOBnZJuHhUQYwaTTBxUFTFrxyZSmhwHGYZz36+3pKfKyzknIjFbyZyDHdFi6++oFiEtbIogrf/BwmRx/aR/Z773gaQT04odaqJIDK9xesyyru/YkHKTtqRGwg7ppxBwfliB8XCKagG1dau7l/3ADiHcbpiChJsx3CnXh7UmDyWVsRX8nl34AUI8LKZUwvxcarU1RopEhEYfwUBDkeS3EEO6kANnIyd59mKiZTWb3k6IHRW5KFDZWgCKdGibpNL99jovEwNWGnaXeo9NTCfe6gzenwLE3ZqkqDwtya5buXhg284bC3NW5qdgCq3h7E70td
 I14AW20a
 M1xA/TorwCPjcu1qXsdOMvHmTNXoj8+LlO7JmSQZLfhwrToCwLSoni6b4m6vfha/GHHDCudBHuTjqyzjjg3knimXX0VbiuL+9xd93UaTqoavYXMi7RJQoL9QP1ewblbMSHmnXkiYAdC5YEIEfsPGl4FishJnDtO5lCl4g2GUXpWtmnl7ng3Eb7PepPEJKoOmvy+UNKl6pTmMarVIUgfpjUSnWnSVQ+ol3t9j+1DAmPp5QiWp/F6vkUsZG1fXH5Az5cAc4nX3r8FfylpW51A+yHPx8JWN7FaprNKZ1D8LKxPHImfAMcTt4DHiMpJlpezhEkFBQ1HM3eiOIcnd8pMBQqBQUz9AsYRPtUC9PO0rXmVG7B5ONAoeWvk9/4EvPHxds1bR5P3nwUuCrhGGShMblO8OLuJ1eIbDE12l6QkkT+dLl2KhKWRQZfh3a8lvSwz4xEZhwD8UE2ESIinBDzKbvg9Q16gcWbvQ9hCLwHntOxcC/90zJlKuYMLjBzX2ogk1AvuLMpOD1X6b2HUsObZhvfLjNm/G2cAn4awMD1c9VvI4lH+gVGGa2Gjp1qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 19:54:28 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 10/14/25 16:50, Joshua Hahn wrote:
> > Changelog
> > =========
> > v4 --> v5:
> > - Wordsmithing
> > - Patches 1/3 and 2/3 were left untouched.
> > - Patch 3/3 no longer checks for the to_free == 0 case. It also now checks
> >   for pcp->count > 0 as the condition inside the while loop, and the early
> >   break checks for the opposite condition. Note that both to_free and
> >   pcp->count can become negative due to high-order pages that are freed, so
> >   we must check for (to_free <= 0 || pcp->count <= 0), instead of just
> >   checking for == 0.

Hello Vlastimil,

> I don't see how that's possible?
> - to_free is decremented by to_free_batched = min(to_free, batch); so it
> can't go negative.
> - pcp->count indeed decrements by nr_pages but it should be exactly zero
> once pcp becomes empty. It's true that internally in free_pcppages_bulk()
> the count parameter (where we pass to_free_batched) can go negative, but
> that doesn't affect to_free_batched in the caller free_frozen_page_commit().
> So testing for <= is unnecessary and only looks weird?

You are totally right. For the first point, that must have been a slip up in
my mind, for some reason, I thought it could go negative after looking at
free_pcppages_bulk, but it obviously can't since we are taking the min as you
pointed out.

The same goes for pcp->count, I realize that it cannot become negative. I think
I was being too careful without really thinking too hard about what I was
protecting against. I'll send in a fixlet in 3/3 which should hopefully be
folded in.

Sorry about these mistakes, I think they could have been avoided had I
thought more about the code. I hope you have a great day!
Joshua

