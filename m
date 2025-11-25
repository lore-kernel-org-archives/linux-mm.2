Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA15CFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 08:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9CF6B0012; Tue, 25 Nov 2025 03:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769DB6B0023; Tue, 25 Nov 2025 03:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631C56B0024; Tue, 25 Nov 2025 03:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADDE6B0012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:45:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E331C14070F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:45:43 +0000 (UTC)
X-FDA: 84148496166.30.9CB2BC8
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06B98C0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:45:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HOCidQRj;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764060342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/us/xTTsXCE3OxKdXuXs4W9Y8ylZDz45I/9OsD00hQ=;
	b=pUBBK9+2ICcSK8qlsUFKna43zjsM4TYkFyw/vpRaKz36PFH3IqI0h6f7wJoYiu7mEb9Mmf
	XRjHs31B9NdFzNpA2bxotynib0qpADfjsqItoP8fVB+ggqxS+SIM5FP5UjH2N9/u5wvnDJ
	SkPkKO0G9f92N/TiyjOP0OhC1edLhcA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HOCidQRj;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764060342; a=rsa-sha256;
	cv=none;
	b=Cx9VwUnvheTneHP9aCWkKZBMwzmIz2gTmjTzpRMI8BVuxWDZgF5p9wHpeb3f/tQu7qTCOs
	12twrjhjxU+Ylb8GKfAq1KPpSnP8afMuLU1LPNfrQytFCwx7YryhiksNWtvRVlujAKYRjt
	NE67dvdwBUc2Gis1/96TRZ/KP1xVXBE=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b31507ed8so4406094f8f.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764060340; x=1764665140; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y/us/xTTsXCE3OxKdXuXs4W9Y8ylZDz45I/9OsD00hQ=;
        b=HOCidQRjc4npEK1asMVzEHNVzTCHEWg/TYrLe40TAcGPHCokO27rCpA8MzDqB1cxDz
         XM5Z9jeFr/yiTYG+Z3GSKlLN4boP08kwqy6S2RcoBJejGEzlLUdVXVWEHf/Ai4Pa33BY
         0+oMEA7kjF25UI9QFGB0voYsT1wyjQvbJJmeqPS7Dj+rFyrI7YP9vLvbAhYM290eHs1Q
         whezd3sR9CpH0z4+Xe0J+gR/KPwRNcPynLoyQzf0d1yIRFFAFndpGUikEnaZukE1Fd3C
         ANYSuoSMOogj2XBsKWCsEJq+090vsaYVhnCToFfwQbjxiwF5SVoY3wcYdkyHYWnDJeXF
         8BTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764060340; x=1764665140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/us/xTTsXCE3OxKdXuXs4W9Y8ylZDz45I/9OsD00hQ=;
        b=Cb9sii9BE/lgcr8SWSBwm8EJKKhnJuNy4AHHE9YjeIkYWI35UXCvbi1Yr12SN2ESyc
         UpDeRjnOMufbkpQMx8CsszGiea7zdJ/H5PpOFzYKDKOE6Ky8hGeTpHfkyCJ+EIKGTKaC
         mQiwbQSYLGsXtrXXvNnyihZjtsWmgBOEBTitCupJtPYVrtW+pY+RZRE/XPCI0cDKp/YU
         MUAOwWMKGIj3JRyu2Nw801yV4DgYzYPOx7Uh438+FlsqgAwJPQvWWIRKrWr58YA4cM/n
         Oxu5Q8iLKaPm6S790hw18/Xel9GYiB2wT7LmmfM/z5j+LlrpSuHXe4+7ZRRlU1cKnugu
         4ORw==
X-Forwarded-Encrypted: i=1; AJvYcCX4xRZ9vCUCCKaZXbBQ2E5Fx/cyf5V583U4cR8wJX2Ypnpgj5IVgmz8Kf2ZV2Rr2MP24+x1WpdfXg==@kvack.org
X-Gm-Message-State: AOJu0YyRt6KZ7TQ21ZJT3neWZbpHByd0soKhlO6CJZcS8ohcJnKZlgVP
	zIdU9bF9CKWH1jqEfc+gaslVdIVThBPIR0OslBrtof3igP0HFBopEIg4wfg4ERC4xYg=
X-Gm-Gg: ASbGncs5mYKdNjTCzMbLThq5gz9lVtFXV90owbcgcyF0csXVlaRnuFQPJq1m0AS+P/A
	P1BMigET9WGP6ngNww8TOKmo/68RUJwSShJPAK8NpaRJqOuvMMLUaivumijLyUgo6FFA+YqhVoP
	Vk2IZWJuE/gxkDZM5lzgPlzGHSzPp1Cds5QqLIlziDatL4xL79yXSms0NXnEn9GeO390aSA/Ekk
	tkNdJ7cRP//5nQuLmPnIIsSnpciOVuCDpUlBm4Tx+8iT+HNGjWiuUENBf5IHMFdGn9twxa8r66h
	l6+lkLBodZ4sXp0NaL1bTjPMHWuQE59Jebvfzzg94EnryFdYLvHdygApj4AsLXgsVfv4Psh29Ra
	EWENKSaoQbJUrWNJRWUBtyV0HPinv/j5epFb7TA6hs8GhL+Y29hUXoQxL/FOolBa3i8GEZUJ2ue
	pY+YGILRn75ZNYo3FZWW/1yyi5
X-Google-Smtp-Source: AGHT+IHMjBFdtNYYNvnOAD5G/tRUlSQ1uj3cBJOAnIP2kqKwUe2JdEmzTbnrL78fa+JitXbENwTdNA==
X-Received: by 2002:a05:6000:2088:b0:42b:4951:8af3 with SMTP id ffacd0b85a97d-42e0f35679fmr1584236f8f.43.1764060340572;
        Tue, 25 Nov 2025 00:45:40 -0800 (PST)
Received: from localhost (109-81-29-251.rct.o2.cz. [109.81.29.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e598sm32381240f8f.4.2025.11.25.00.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 00:45:39 -0800 (PST)
Date: Tue, 25 Nov 2025 09:45:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/mm_init: decouple page checking and
 init_on_{alloc, free}
Message-ID: <aSVssg5c8mNvyLou@tiehlicka>
References: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
 <20251124225408.2243564-2-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124225408.2243564-2-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 06B98C0005
X-Stat-Signature: 6eda1o6pf8rwurfmy4c64disubctwy5x
X-Rspam-User: 
X-HE-Tag: 1764060341-163915
X-HE-Meta: U2FsdGVkX19vnaZdSoCDykPQ6brEhFKatHoCRJWWiHwytUXWEQmnmgwsqHGUyOoqsM6/jaAW/pE3NxJOrJcyS17cSagCunCMtzz2lMjP5i/N22JJ9QGAtA2RZNmF+FRZ8qzqHV7793m/ScOD5Glm6hvy52y7MWtRnftNXd9w5ESTRDUam91KGYo7SMirlYlZ5BVDdPMxgYOl+YY3nR6vVN5kU8CzlCtj9rAOiJfhARTpTKzBbK4UUvCtfVFd2ISMP7znwztk1gDzrhPl/eUyDpALfoDvfRWJM8nwtQNKdrZ0qj4AvMBAvJu9xkVCImDOqyP8W0XQsLOF5q8ADguce48nPP5PMQgcSxJzgVUOJzSuUHJ1hMb9WNPg/nUhSxz2h5PzW+LmLUKJxU8wf8/+8/ERedokOxaYsG20KWqhLO+jgj1+gHLvGAQ50eIVzd6dvnHpCTt4yjB/phGGGteQ3Yyr0tXNSUib/KakLCYOlrUbHi3fELdOzXrhO7TKa8CNdKqJA8rOtpNKzGL4BdPxteZ9zKrUORcGOapb5MEBUfIKaO2HvomudLwOhiFs9M7MzJrCsz1dgJT69ULvunjF8dYNIez6QxCqabOWQFa97gYZ2q3EVzGVAWgQNgE4reJycQ0UrBi8leA7IFAkif2C14agqf1fzjHmljJhSTQ1mp5ucGRZ6ZSu0pLiHvG2LqUwqMfS+5g2Cg3TFO4NUNfOk/5x/Uz+wcJt4J3dlHwWN+WdprnmOVR63wRm19HKIormIgZpF2ME331BO0yUdCqTGDBz94YQB/kb5bkWhsozVkRyqQ/XiMrKAqJpRJLJMviDaRjbeWlla38TEZGbjTMEsqHzkH9xTlFU4Jg0OAQRPrxXydM2k+us6jK2iE/jsQKBThmUi8hqZn02jz3b6/nxitYtr7GIydb+VckytqloU4m1rzhuMM6srlskOPuM1PFK8XT2Om1ZPVdUIAUWm9O
 3LnHj0b1
 rkLduD54r6xRM/sM3Va3LiV81e4pD6VFM3nD8lACXWQyTxnTxOXURtepmYCn6qMJsBFVcZgRCWivcR26Hy94o2Pe5RkMBbI0QDMb7j5uqSfPGW+jZ12skIFyiiUzKibUfSFiI89iUxFW0QDP5bSq6Cgg+2RlnkP/4ALgCmpSQ4w3uds6VtVfQ9AWu9rbvVgkbPmYK+25nIRl68c0pHaQfkpmQoNNLdR3JHO8s1L8Bz4u8YA6JNimNE2aJfnFFIPHwLvOLlW3BGg70pLRGgQ7gH4UG/i0IqIWkDGmfyyz86YO19uBE9SuyeOpmHx12hlIz3ZKFGntzXne9fIrSyr5bfC9CblYi5bCxjNyesnAP0leUbpEi7WIBvXab+et7uzEzslviivWQkXfMpqyyokwxuqLY+jBvtQZBYPq0/4pc8j0H7q+mnw9oNKhtpuOam3Adqq8QZkYHOn6gZTwvMOC6rS9tM79b9S9vowvs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 24-11-25 14:54:07, Joshua Hahn wrote:
> init_on_alloc and init_on_free protect the kernel by initializing
> allocated and freed pages to 0 on allocation time / deletion.
> Commit 700d2e9a36b93601270c1e15550acde2521386c5 ("mm, page_alloc: reduce
> page alloc/free sanity checks") removed page checking from hot pcp
> drain and refill paths, and instead coupled it with CONFIG_DEBUG_VM,
> debug_pagealloc, page poisoning, and init_on_{alloc, free}.
> 
> As the commit suggests, the first three turn the kernel into a debug
> kernel, while the last hardens the kernel against leaking sensitive memory.
> While enabling page checking is relatively low-cost and tying it
> together with page initialization is not unreasonable, it does feel like
> a bit of a side-effect, rather than an obvious consequence.
> 
> With page checking now pulled out as a boot time parameter that can be
> set independently, let's decouple page checking and init_on_alloc and
> init_on_free.
> 
> As a direct side effect, systems that have init_on_alloc or init_on_free
> will no longer have page checking enabled by default; they will either
> have to pass the check_pages boot parameter, build the kernel with
> CONFIG_DEBUG_VM, or enable debug_pagealloc / page poisoning.

How come this will not break existing users? What is an actual upside to
get for the risk involved?

-- 
Michal Hocko
SUSE Labs

