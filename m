Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CEAC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 17:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2D9A6B009D; Mon, 20 Jul 2026 13:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADEFA6B009E; Mon, 20 Jul 2026 13:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD566B009F; Mon, 20 Jul 2026 13:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68B606B009D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:44:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E37814025A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:44:47 +0000 (UTC)
X-FDA: 85009880214.01.596AB4D
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20B13A0017
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:44:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FsAwEkLh;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784569486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fh0Ky+WC8JAb92VghcxhTRFBn6Go7CAcxa18f3039ho=;
	b=Gu0i9nVvoxn+Spju1U+DMax+nsjwYiPAcfIOBWgPd4jVvV5NU7L6FxLdPZT3zaJjYn2DtV
	iCNBtcFAyBsrlwj1jcFG6/TCYoMg9R9gBLcS1mgXDM19fEwOH4+wYFawsY3k1BDQpEAwTM
	SEI3we7gMGPqHvOsN5L+8rFo7Aye6NI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784569486;
	b=zsmJ+xbsF+BQeKuWeYb1H14iNGOsUSrRN8JykDY3cPAtCh/Pao8w/vm7TueA2L69XbPyNB
	vIETpj8JW2tPh2BJMYqnkWsMvxPvCOSHoXKZGumSSR+ep8aB3z33zmEE6ijKQaOIpSoeeO
	XAVTO6C40DRdGAEm3RO6htALZULb1ag=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FsAwEkLh;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51bfbe05683so94789041cf.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784569485; x=1785174285; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fh0Ky+WC8JAb92VghcxhTRFBn6Go7CAcxa18f3039ho=;
        b=FsAwEkLhYHOz7uJX50Kl4hXAaymdy9EPVkjNn1obNyS1QDdrGsS6WOi8HI0jLa9iL+
         bjneWGtWVJmfBvImPsUccczBr3Y2s+tZLGGIWAZUdcSnuWNahT/G4614CNm6KPPautFU
         aPrdP2s17ruX0IHK+ir1EY7uOOoXC2VLwbVifZfWzxgNgmHDIBD/D0Pu+HujYh0fJo7o
         ICxIBLNKIluyezlW3QVYoDuqEadWGoTSrdf6xlleBZXcjE5dpTGQepCJvhjIP7d1X6cv
         H7zWRqhUOpslmck46e5UnOOGVG7li7ppjAJ995LGR8rXoHmpWUkunFuxoevH2pfo0CJb
         PhjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784569485; x=1785174285;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fh0Ky+WC8JAb92VghcxhTRFBn6Go7CAcxa18f3039ho=;
        b=HbXbD1tF7PY5U8BU2zpACq5ZCZRM04gZY5BqU2/S+gpmrIaSAPQwIY2aAQGDPsw3p/
         7ufQvEyxYjJZl/Pfd4eQp1AfbduLTaAclp9zVAcAoUyp1xF+M6pgd2i/HOZciYtnzvsP
         bpN4RO+8abq8Z4kNq1CfgG9aQ7VWJrtLC+NEXHOr4RFgwTZpuvh9p0Q0F1eAku8TH9Qs
         hCARK10qT+cQkxHmtHGuHdO1P4P2xNKAVJlNPG6YaQmRIw3EiRzhU1cUBjnmvBWR8xam
         E5oIT6a/QpD3ccsz1WMJLP/hc7l1CqL2XARMn/v7NKrCfAlsFg/7LoZ1l0fGcbIry2+L
         XXng==
X-Forwarded-Encrypted: i=1; AHgh+RqFeatviGP80fuCLzXFB4bD70PmL1jYAf1XARKaWsCNwtco8Nmiyv03GfNtvXEB3KNSqm3aSm9b/Q==@kvack.org
X-Gm-Message-State: AOJu0YxAI0oO6e5kbsVWMlgBHE7ZronRMWTLEJmgK7xnXzbUP/PSQuPR
	OPKlDmCoSOgAByiDM3i3fph/8LPvAikavy1mj+zlC7tJ3YL8/+ukwvB7rQ/Tn+uJpBc=
X-Gm-Gg: AfdE7cludT8Cg/A8sX3phfcZCTeK2jxN8vzN5+A7RAAlyw4qT1rS2spW1O7bKH7Rr3H
	yc1aMKE39/QX6CrHIJQZZq9CXMdEXFriGOAv2TW4bsZ2YfwmGI63zg1chESav9noOjqiUM1elrO
	XPi8LxZYe939qSeG9GoBKsvdYlRXj57lwr3XzkYXN23qli3kirWku93/PEDynjH1WKuuqn+9zN2
	hxzw+C1yZHptlhDl2F9m+0oNtsmNVfl7vyP+SBdhS9fJy+jIlP7jTFn8UjUkUbxKgzGKUWZdfSC
	gP9WMD2llfNdwiN0CnQztiRiKtjQpiNGuJUEX5SMlmTXTvpCk0Inw/c24MH1wJ9ZXwdo2UI5zS9
	ByhcAN9Z2pztIwNQX749G2AwcoXEV+ynLUax2SBJZIIVEv7pRBNcJ0Z2j6VEjgTjvumb9k8SVZ2
	KHT21gLddmXtNyFj83GDvXlXKy4VM8PtqlGtohhjv6f0fKLmAQZtwvPxpimw==
X-Received: by 2002:a05:622a:1107:b0:51b:fddc:1de8 with SMTP id d75a77b69052e-5213e67e2c1mr141645811cf.65.1784569485065;
        Mon, 20 Jul 2026 10:44:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214cda7dbfsm77462971cf.9.2026.07.20.10.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 10:44:44 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:44:39 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: move __folio_alloc() to page_alloc.h
Message-ID: <al5eCOfvXR3OZjVi@gourry-fedora-PF4VCD3F>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-3-5363b8e92d33@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716-folio-alloc-cleanups-v1-3-5363b8e92d33@google.com>
X-Stat-Signature: csqyp4xprabg34x37rjiqin1wg9nf96b
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 20B13A0017
X-HE-Tag: 1784569485-778887
X-HE-Meta: U2FsdGVkX18uI5ZOuGIPb+ghh2z0difDp1RRTuDIHi4X9vy0A0yuT5HVrjp8CquIrw3aczSNS9oFb2z7859FKwrMQx/XD9zYmwTaiWZLMVaHHGiFrXypoGbMaYU4v/uSdEw9aM8gizR3RgqLHiL2kjNY3a7Q3RyF0m2i2T/fGDEGNFBGTj6VMvKFhsYmVA5af7A5sqS+PstF/EMmJjEK63SXrjN9Xz0ZZXWKqmGtB3VprN7nSK2NYqw03ku+KX3vVe89e7JYG1xTwwLN9kagK/SJdVHFKdk6XAp9HptxFCPGOxHHAbWR6XeEe8I515NvPCVQGz9ewiqPm/ilmjlPBW1wWgJBhGZOwYP8qaSQCvRv6lTWss1xfG+3yPoyxm+2jlsjtqYxMLvB8T8ay+Td8XhyHfdBGJLmwo7ANWHIKMRKhfZPOqOXvGM7lW7ed4nCQ5G49b+89Vx6ymgnpuOUaOfRQLyfuK7BHYQTUApv2vuvoLIoiM8A0JOBzmboX320h/JLZY2ynWOTb01exMk7B0j7Hzf60404/Sa++v0h+PhqRX/0VkfiAt0/KfyS4RUUhJ1Gho/IN4XBBQv7gYxNHhvpEUO/NAE0U1XS44G5lkpIUl50T8tSOn7MnAcBaBseO7KHnKaIk47qUYlM5b9IJd8mHVZuA7sv/Y4OzO2SMnqx/CXF093Ry8Fxgf7Lom8TsVBeoUnp7/fsc2LTV2YT0/bFk/OVzdOgbO6Uwuoij1iV2erHrHwR4rFTtOXV0lSjQ16yxfF/lUsRs9/mhFhnx/U5yMC510jU7FYQOMA3yOI5fCY/8R1/wvGedC2aO5fXEXd1l6kp4J/FCuSri/EKDIsR6lKNAaVB697x7E+M/ptOFN2Hq0K1JcSLHx3PabGddiZAJpXL7RaduYt6nRO7EcKVXLwNFENDeugL1xPoPW+pMHmQs7vphkNIfrMYZhU7hO8New9ppW6CqkPSGT7
 dgtPwfHu
 VirIJRToM9L5o08poGTWwT6wXeAbIa+MYizyYW5FvUEATshh/dRDflJsf9i4h/+395tMU3SF1GB495Gsg/Vpz0DksxRH6GKbdPsqtaCVVrSovdI4WH+ssTCIUjdxOgh/tCsN2UssTOgyqvO1KVcGJL7efV294mNWuQ+Fr/roKcvAkJHhaf5/B45jlNIulfP6b+ELxA3xRs9OWkenSoKBN+IK866c4FygNdIZzjQ0aDbuEJKVoFfsftn/dprDm1eZeNHl8Ygxd63W6t1dMJAfy3+YSv5PLXDL8YIFphFUhn9KCnrVlxwsm+IrXBZGR0jdIMOdtBKTqaelSnTnVme1HpPJEQ5HlRe4FYugblLTjqdcZ+Qg+6OrG3yiMdj6JSd3x0KcvKb8p50zcoNkSlP7kNtxTjZwcikZ1VYWOOkrJm4kbQHKlIrenPenGJNjm0mKPnCbTpyZeA7C9JrZOwrOInMvmNh3Q2gtMunYi0SrA518uzcX2x7hnv0fGHydTralIuvIMEFeLv9tbnl6Xp1l1IPbe+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 02:30:12PM +0000, Brendan Jackman wrote:
> This is no longer used outside of mm so reduce the scope.
> 
> Ulterior motive for the move to mm/: A later patch will add an
> alloc_flags arg here.
> 

I have a similar commit that is coming in on my next private node rfc,
i'll reference this, but i wanted to make sure i hit a solid mm-new base
so sashiko picks it up and people can actually apply it.

> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by:Gregory Price <gourry@gourry.net>


