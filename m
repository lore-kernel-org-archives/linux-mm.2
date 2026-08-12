Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F1DC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2496D6B0202; Wed, 12 Aug 2026 08:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA676B0203; Wed, 12 Aug 2026 08:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112EC6B0204; Wed, 12 Aug 2026 08:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4A556B0202
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:49:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D97C8034C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:49:09 +0000 (UTC)
X-FDA: 85092597618.18.097DE2E
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id A8D4A8000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:49:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wUDBSTVo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of praan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786538947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DlA54u08QSleIzxXC03qMaWaKXGBXVOD3RnOmcy+1U=;
	b=mkBAT9dRqBk9yJVdVvBscHjzU7BDJsL0iUD6ynmIfN1rWlxBfYxilRTUCXvCkg7h2rQ3tb
	ZmorejxfI4pS/hNUAbPk5NYnt2UF90tWC/df851MIZuP0p4duZC1Ec6CdPO2rt46nVKosz
	qzGiwNNgM1dNkLODnXeEd9lGO5g4JmM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wUDBSTVo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of praan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786538947;
	b=d24Camd3lRFUgohRctF0RwMwMr+NIJPemQEIKWZfEfYqMC97WPHeh7kDhYT3RYJgqHbkkq
	DKLUTEL13jyMPiLzr7epCbklTsUcHy6si0+nIAUn18NFeBSZAg6o57YxTbZhoveIuHHrhE
	ha8pj7TBKJIpGn80qyWzfGl7FNj/DyI=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cede6375caso85155ad.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786538946; x=1787143746; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4DlA54u08QSleIzxXC03qMaWaKXGBXVOD3RnOmcy+1U=;
        b=wUDBSTVoCMpqB8hyDRoIQHgCZ2LURhhgRLoSETKjDUOpN6NIlK3bK4K+9h3GjLY5Bf
         CsCOpQwV0TKpg+T0Eo/soo+OlJ0uvBBVR7lGf6dt/4XhptVX3/nz8g0lB4Ye556hCtGn
         XUmX9s46dgO1lUNJzfezqDQJr6Rzvi04UwZ9/FTrgIz/7dLUKeOQBJxjmrFfTvO/ol24
         I/WC+WLb/pqvJXG6hsxQOX0YF+dGuSl4wgcFk4GLTmOEPYEonhFrMJx51d34sWC7VrEi
         UsnVLvxqrfXON7oCPJLgF5swaer0SWeIoMMGY2A9oVnv3efh1Ezr42qg3p4vwdyxZx+v
         YkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786538946; x=1787143746;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4DlA54u08QSleIzxXC03qMaWaKXGBXVOD3RnOmcy+1U=;
        b=TzOOqv+oULLP6USQK/JH5lwXYXcoQYrbcc977QzTFyQQzIUDzZPPAhsxu/3gplMTM2
         n7VGVn5fykInKT7Z3EwwNlbwuuHyFDO/9qBhR43c3nBFqyjq8BtMVsQmli2NkGSd0w98
         IoDXi9tYfjPP0l8VHyAcAR5ZuZMRCR+uRqzpPE/oS+AIxDSIICTR9q0Iz2yXYgfRxIk/
         z60VR0pHV/B/4nWKSDauHIAEAGxkqztrYswLvf75SZNOINm/hknLC9RKEiy/MLoIuBre
         pSv5chH3ll6z/5usdogbbbvwJwoEKALiWIW4HDlrKgUfN6s06XH+dalxF5pDP09pAXf4
         /rjw==
X-Forwarded-Encrypted: i=1; AHgh+Rrolql2fokM4Q6gMQ2HNTyELdTypzQ48LQgHSoyPItmEAQ+K3uL5pOTG8vvqWNZIjg3FydLvPiD+g==@kvack.org
X-Gm-Message-State: AOJu0YyE0gvRpBGMeFoAr2zpXQKCTHODk6CNNgP7EsB6P14Eh4PPLbHR
	DKayJJahZb542RnAI7/9bwp408Hl6fM9SPeghTmyRnH6oo8hPBjMwS8Vs3RCCdgF4w==
X-Gm-Gg: AR+sD12wWc5wg5FkG/O/YyDOkBNc7IPVwnpbTXrq+XuOxKezWwIEozSODAoNLSzM99y
	kYlrhrL7LqY8n7PKKJ1nGuW5pVsh0wBbktT6fHwrkRk4beFdlqSVU2FKNwrdohRDDW2hyf3GUtJ
	UYC1qyjrdz+zEs2LwiGiFrrua3HT4DNwIZ1IL9i26VhW0B0HhEVknDA0pqTtrGO0o9lSHl+WgEB
	4BSDVU5oYCouHg97haLlt+YAC13aiPv0xRf7gjDiHBKSh11zaRAulIPPpoEYxCJH1d8z4cX7N5G
	CGA4uqau/j4xY48rQjA6s+aj/VsBOzTrtuHVvXRvK3KCiUe5ctxqr/SBSD6Ki7ycLdBM++YQKlx
	v7ahYzidxsOoCC2FTofASPmhuxE8OOstDXxVygIrChD5cf/iWqmGisPU/UC0hQJ+jGXkOWG/2R5
	twR09aoO9EpGwsGuCbMnOpsy2vcEUBcOSgzjNL/vjfI/NrixBFKs2JTVWGWm6mNdPCRPB4nzum8
	cfVDYd9SsuoAK9HoFcJ2nA=
X-Received: by 2002:a17:903:19e6:b0:2ca:e0db:3cc with SMTP id d9443c01a7336-2d34ab72f8amr1230025ad.11.1786538946152;
        Wed, 12 Aug 2026 05:49:06 -0700 (PDT)
Received: from google.com (21.168.124.34.bc.googleusercontent.com. [34.124.168.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d35115103asm5901835ad.28.2026.08.12.05.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 05:49:05 -0700 (PDT)
Date: Wed, 12 Aug 2026 12:49:00 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] kho: support preserving high-order non-compound
 pages
Message-ID: <anxrvA3z3NUkWvnE@google.com>
References: <20260803113944.3694290-1-praan@google.com>
 <anr4-F-e5_vHEar8@kernel.org>
 <2vxzv79f39za.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzv79f39za.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A8D4A8000A
X-Rspamd-Server: rspam07
X-Stat-Signature: we6mnb7xx8rpxft5q9nyafs33sew465f
X-HE-Tag: 1786538947-533939
X-HE-Meta: U2FsdGVkX196qOeTqt58H8toG+xsW6Qo/+CIOA8iKQFTLQgGJHNuNhoCPJBHGWyuEkd2MkWVpRAoM4YNkXe8RXqSQHDjy01M+3FYwveta07gzAG0GpjdkYx5+1+fboPVpeKJrizrME1FOUuTnvCLTs9BMrOCc0SeLYSQY0iMBIrlnIyB7gGPT6Dx3a9n8RW8tNTqZe9acOAkBTDeLR2n3Ko5WkGK8647ktvDdqWK77hSDN5ogwnXFpcSqaUKChjWEauLrzwyBjZwPh6Gf/UY+G2UZY677FP8zYpoGvhIu/Z3hpyP9gEDftit/T0/z++P0Rn4HPjbE2MQTEWxCLPbyVfxPDRW7sJbi5SoiaDzf6jO18SdUUHOID3ca1esKSSU+sgvKZZRylAuLajxlo586jWVDeOljFSZScP0qlh+9r5Geag6IhwL1HQ6SIC9VB91lHIxTo3MOTGX/xqplyZAO+vIz2+E//TylNeUTqf0UOrdkcbfmf+3hEl9cmG0cRICIjy3Bru48q5GGCQKnrYNomZoJky7f+2/5Q2uky3OEtJtK/kZGyXHEYeN/kjVufCv84e+ZxavPbp+HAaidKOqI8OmOxxz/81eG7ZzxIiOpjUmw85DPFfCvdDhXXxZjvBCfWV1VgtPFgwtKhPn8C3q/02s/ExYQE5DxcQJfeSB3NyV3bfM3upRMgyQ6+diXYpz7wvEpT0P+JYCwNY+IcZfkP0hMar+UPq38THLUZFupnd8X/F7v3A939RyVPdK4eDA+//vx2ehO3P+vsZVePCvSLdodQRreli3LrSWyq1CB/fkfvNY1La+aOVIm3GPsFaXQJG4bLNgU4ZWAmXix1x/ayLJM0Kvy7CcWKhS4BqmqP+l9iuJ4grbdvs5jK5N7O8+M5VuU05O9aeb7ZFnhhFfrktLHICKCh/yAnLv70o1bwtSij4UNf1oficuizNwBj3XhsmmGJMuXgNL32HOHJd
 kxwuvjKH
 aAVTN/OKQkEfBOJ6BTY1qk5QuOFr831KRgZLf9vl8GXuIIRJs1VXqMEz2aluSo+qzDxp0HsnUqdNSOcmO0LkLUQeGp/jtdVChQ4EZZbmvhabzkXvId459cQJIh/gBDlwD97Be9v4kQ2EuEjPuKlm0Ynk5+/xQUG8iUUoP3EHd6pZgzb8tueRAC5lKEdezFPCKhhWjzDsF08r2NBVtQjow9A/swqNdvn/piFmATYhEPbLO9kCylCMxdPmeSn7lnischHM68QvxJuN4VsBMJpRl5Ihs7oWZ/Zia+ffExWOW8JTsdR31aM0zf4A0p+huqP+BioviiYaAhJOqxxE6bvltzapODQW/nF8DxhXS4sxogS0z+I0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 12:32:25PM +0200, Pratyush Yadav wrote:
> On Tue, Aug 11 2026, Mike Rapoport wrote:
> 
> > Hi Pranjal,
> >
> > On Mon, Aug 03, 2026 at 11:39:41AM +0000, Pranjal Shrivastava wrote:
> >> Introduction
> >> ============
> >> This series is required for the ongoing effort to preserve DMA allocations
> >> across KHO [1]. It addresses a fundamental mismatch between the current KHO
> >> restoration logic and the physical reality of high-order buddy allocations.
> >
> > I skimmed through the patches, they look fine to me before the in-depth
> > review :)
> >
> > But we are really close to the merge window, so we'll anyway need to
> > reiterate after v7.3-rc1.
> >  
> >> The Problem
> >> ===========
> >> The current KHO restore implementation treats all multi-page blocks as
> >> split pages during restoration. Specifically, kho_restore_pages()
> >> initializes every 4KB sub-page with a refcount of 1.
> >> 
> >> However, many kernel subsystems, most notably the DMA allocator (via
> >> dma_alloc_coherent), frequently return high-order non-compound pages.
> >> In this state, only the head page carries a refcount of 1, while
> >> all tail pages have a refcount of 0.
> >
> > This hints that these patches could be a part of the DMA preservation
> > series, unless you expect other users of the new API.
> >
> > Generally, we don't merge new APIs without the users and if DMA
> > preservation is the only user, it's better to fold these two patches there.
> 
> Makes sense I think. We can review the patches here, but then they can
> go in with the DMA series.
> 

So.. IIUC, I'll post a v5 here as a standalone series till we get
consensus, and finally the reviewed patches can be folded with the DMA
series?

Thanks,
Praan

