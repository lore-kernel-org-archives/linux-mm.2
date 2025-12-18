Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A41DD711C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFFBD6B0088; Thu, 18 Dec 2025 16:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADA96B0089; Thu, 18 Dec 2025 16:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F316B008A; Thu, 18 Dec 2025 16:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9973E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:32:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 531891A0376
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:32:48 +0000 (UTC)
X-FDA: 84233891616.29.DD12870
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 70C394000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:32:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lCyQI6jT;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766093566; a=rsa-sha256;
	cv=none;
	b=Gxx+RG89UNR57vdYSvuyK+IWL8+mrVc2vp/eqUYO3vjoh88lUYfGbygm8FtQ0PvBtvMgAe
	cd9em6qBNfeexON08jDOJDKBpPUJrGB6OQ26P5l15LXYK2m+kPdRH5OYtb2FG7gO687khk
	CLgw4VQtE6Pzd9fHkACWhusd0PKy9fs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lCyQI6jT;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766093566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsqS8JZLvUNfWXbK6I+0m1K85/BN0I9qut0vlrzqpz0=;
	b=fkARzem2SNB6OzzuWz0sB9pLXw//2YvDd/CmFC29yixNhK2xNirhU+dRtDUc2p810ZXF/0
	8a7wduHOns+c9VmCNUxErwmORtDVa7KFC+4AffiGfm+pRiJax72ioQdVBfwe5enWdpUmzg
	AdzjiYowkZCHEJiE0hoeEDuT+l+/zks=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso10867311cf.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766093565; x=1766698365; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsqS8JZLvUNfWXbK6I+0m1K85/BN0I9qut0vlrzqpz0=;
        b=lCyQI6jTfLcD8070ystmHoQkLwKWu8X/GfFPPfFPwJdOgUH0suqpYYROQ+owqyORe5
         i7xJj6w/Bkw9K41LIRKe/R97iBVGQfXeu2B5KMnRzxcFHh1PZ2nF/6l0GSkIqJssy3aF
         VphOLvw2xB085l2M3ViuwcCZc74ULdcvmGwPqhQK2cHWVkz2mIiuo6ltxj2RCCLnHpyV
         Nwel4z+qTc4gvTsWJBLTlYnkdqlOyQr3DX869tL4kNCkySsnaSJ2wgVfVbSE37OD9LPj
         T5BWotym6kKUnetUyAhLTbEirm++KuKxkcu8+vT2Q3LZX+il9WSF5AZZ93fgru0wfNCd
         v1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766093565; x=1766698365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsqS8JZLvUNfWXbK6I+0m1K85/BN0I9qut0vlrzqpz0=;
        b=WSl9Gety4hi7hSYZWVpX3EoPgAkiyWupcsBgWAwURmx2QFy07adCjarl95Zq9BRwRp
         jgHy0zHNpQ4O9EwrmUxs4zTrVfcwd+g7iniD8gI8l/ORjDv2+gMUhKMgsa+MHFqCh9zl
         lQqWtB4RqoEKjjCp1/ad/8q9SNgO7uZMnZbmjbPvI7doEGnYoezV3JDPn5zseoMFjkMP
         qGkvbkgg2sBCLOgmaIO7xOGU9uOdOboYLncydtlvnCKMcX9RI96s/wYZhgGGSsx7893K
         Y2oST7l9tTLUuifDEc9u6/ZbyQdWt4ahG56m4KEzbrI4Fcr9Puj7XoU5CVibijkDCB+c
         vi5Q==
X-Gm-Message-State: AOJu0YxWMhnsK0/mGGZjE4soPGXFN9IN3jsU/ZimTQiS49rA0jHygbsU
	LEhaF9JARQ4seniqrohZ44HabW8TzpNiSGkJRGzIezGNVwTocX9gFh5RCdt8PSlVgMc=
X-Gm-Gg: AY/fxX4PMLLQLMa9/SYFDqUIn8PO2ipVPfqx86rrri8WOqIdjUukMgBSav+GWwSikN2
	pOd4yRMokidZc78D6VfBk7CFRaJhOJWRoWQN6cdwUD3T8YY0sIu62CyH2Ei0QrcPpsuw6QVC4up
	X0gPD21/EucL1k3CSkK2/Nf8dlTal5f2jk2gsenkJZx2pFcJlQ6IjBFv1u8nj1YHBGk28y3GTMY
	2IJX8iGOQaSLbE97MgFwTsqCxOlIpgelSSxj4oJXHimlhUFbkEjLaHYG0ujRKsPAyLAPWiKqTa1
	hNu1/nkQqNiAB5I/zvF4KqY6VlemKs126H0vH1xFMTzGhmLiq5VDQ135CDnLitJ7CSFeasnqt0o
	X1prTzJ5io9cRuFlwh1BsMN0Sil/h7cSbY5QjiSGUTdi/Q9cnYfsBYNhTh35GXQFoET5WMRRI8u
	+VVV+mUv9uKi2I7w7GhXwbENwqsLwxZaKgvrOJVDc00LFAIidVAl+oZPLtmbbpogxmMAl5cA==
X-Google-Smtp-Source: AGHT+IHQzlqcCj9rb7vPUeyaWJGb8K4sNNB0JRSVczQHlPtEzp0q6mfpj4aeVQ4wRucPM8HXHJiWKw==
X-Received: by 2002:a05:622a:130e:b0:4ee:49b8:fb81 with SMTP id d75a77b69052e-4f4abdbd1efmr10764031cf.61.1766093565470;
        Thu, 18 Dec 2025 13:32:45 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac531fa8sm2536081cf.4.2025.12.18.13.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 13:32:45 -0800 (PST)
Date: Thu, 18 Dec 2025 16:32:07 -0500
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
	david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v5] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aURy1x9D8fv_8CoW@gourry-fedora-PF4VCD3F>
References: <20251218190832.1319797-1-gourry@gourry.net>
 <0E77F151-99B0-4F67-814A-4D79439C9A88@nvidia.com>
 <aURnLqMziaOilLCu@gourry-fedora-PF4VCD3F>
 <01A47A14-3B5F-408B-AC37-64E36AFCF14C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01A47A14-3B5F-408B-AC37-64E36AFCF14C@nvidia.com>
X-Rspamd-Queue-Id: 70C394000C
X-Stat-Signature: z5majxkazanch99u96zfrk9gs5oe1bau
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766093566-353500
X-HE-Meta: U2FsdGVkX18kvD7e6XS4oPlIfsYaVIq4CEirQmgmQh8sXAeMpMgANtWXDOAH83bQEBYdgHaee6Hj/3Y1Wc9dcbbqg1LAvL/fb9vIkouK/QcWZZIsC7syeXkQK3A28tqyUqmD1qYfAvfNJKZVZRKStfIUNt/Y7A3Y0GYoP9enjv9uo6Fc/FhVr4aBruBa2WL/ZBPgz5IvJzm5ilsAFu+TyrCYZl9dQlrR8AnlQc/5K6PHnScK5mb0wBaRyYeIjlHgetOdqDpSUiY6XVkoevaFqz4RJkSLXtvjnkIIjqrOhuq1UScZL4QjBclIeuoz2rmEQkr1Nka+g11UIrKbrVWO6E9A4WykeoxvEM27iyd6yMy58CBaAtd00LDGqHQdWjerUfw9Vj4v3ngNSlEW3JZNKiaeeASBu9MQ0D4DN7Rx8UhTEkuV9W3GkEXGqVlxmcYIDd8u4XbjhULTSOpLAu9RhhmbPOkTx6RiU39Wy2NRxfe7fUOykWO4epO1YdjC1vOnHC/9KiLUwcezFJzq1r7qqVn4WjIoUShkHtir7jH0a6/yJHft80vY4v7moHb/pScy/VTtvWGig8l+gxaZY+xnQUdVpK4ZZlZD27/SEBXN34NuR3DDsycin60p85uFGl886rbkf4jgzT1LCdp4GALpR/E4SqPIa9uLTVVOCZDEDczY8/6DD/VO88P+pAl91clYwbBVOLiF1varu1L5Y6fL0hbi0ge8uneQHDVpxUO+jx29t/OVdH2m7bP01dAldUfJhTxMfN8ur3H6nwijD7/kFCiVTA/Yg3oi6uMLRMCnLzpt1v0YmnzhWB7MU/S4GLUAIXnD1AcPoR+Rcb3utMFXypPycn5j7db2LijtY4Thx5v8kbsQag/ljT65RxA7COIB43mceEw1Bprz9aM0t/5X8Y3ELVZpVqAbCosKSqZLeKtEmA8/VZIePsy4/kwlwJy6KNSlhvKlhr0cIJ+g2nW
 y7jPqk2w
 YeXIweuc86am2jYnMKZ9G1NC6WmzANhFnAcgScIeF6mJ7XKqqq2ZcWRsw+kHihkFsnJkATp2ZMvUnRMZ4vwc94wL3KVDiPWsRtYGEnv30XSWETeSgSATXu8Xzsa8xdpgWPEihfHrjvPwShh8XzzV+cgQTlEOWCqWQAWOhpTjDWe/6w1L1MeHjT1bOuIUkm9UlZc5RYbB2ZI/QU1OCpB+7/qQs15XL6oeA0eeh8bIAmHbz3M1KgVdaB62p5+nFVrDR99PpQ4AU3+V7bid5M6vu6wpmyoTkB1Mcf9MahedDVYvOKDamtikHkZ4BD/HkPIO2460T4xUs2DbxHW3xO0KRdJb2d8x2htQY+5Usio4E+f1triQ8xBYY3GWfR472XQT3chT6NRixyvepvLjh1dxj2iCcMM9M65R0UNL6oWSxWIts9bJQNnij9+ArGeUhnrrPsa2wP8wNE2p3+AkPd/p/HJwK8eyWCCKkxIBu2DrrhfcLg9wzHmnAy29pPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 04:17:14PM -0500, Zi Yan wrote:
> On 18 Dec 2025, at 15:42, Gregory Price wrote:
> 
> OK, you assume hugetlb is harder to migrate compared to other movable pages.
> Considering the limited number of hugetlb pages, it is quite possible.
> Anyway, I will wait for your v6. Thank you for the explanation and the
> prototype below.
> 

They are harder - a migration starts with an allocation. Contiguous
allocations may then cause more migrations. We can end back up in similar
style search/migrate code.

Basically this can go some amount of recursive (though not much in practice).

We at least guarantee termination because we guarantee we won't attempt to
move pages of the same size or larger than the current allocation.

~Gregory

