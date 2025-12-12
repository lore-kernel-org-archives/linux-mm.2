Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D35D4335B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 01:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2B36B0005; Thu, 11 Dec 2025 20:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183726B0006; Thu, 11 Dec 2025 20:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0991E6B0007; Thu, 11 Dec 2025 20:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC84F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:53:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 718971349B9
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:53:35 +0000 (UTC)
X-FDA: 84209147190.06.1102DA9
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id B9EFE100005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:53:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bpxGCflW;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765504413; a=rsa-sha256;
	cv=none;
	b=Az0a6gzDnp+xGr6hVGKa3PVK6MAiESfataL6IHCIeCjfDHB80KBDgD8T/ay0i79cAUd2Jx
	B10y0axfhp+eb95QW3hwgyipMnR5UEECLCKsUmrDpTvJgmlxVpi1Bp4+8Dol7njQ+5uWy3
	8k3oVOf4djMAsyt5wDw4J/mICp80nAw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bpxGCflW;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765504413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYCbe3d+U5qodPL2pi+jegtHTqz+qNWwtE+Getxtl50=;
	b=8Qs16RonfG9m8dKbW94vJAmMl3N5gZm6cFhiyBCeP+2fviiRVWokr9KqI3SLrZ+28r+4Q1
	Y78A0hpwzXtm01dOuEIBecQRM7Zw15uvQ03zK0yvngrkAjY0qBhMOffGGOLsH6U56iPC6m
	pyX+W+wkvafCV9OZiG/1ovhIC4ia6j0=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6446ba3d337so634426d50.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765504413; x=1766109213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYCbe3d+U5qodPL2pi+jegtHTqz+qNWwtE+Getxtl50=;
        b=bpxGCflWOdjmZszfRhwAFxIoDdSkAk5fxY7UbyOSfPN5eFGeqcN+UXcRhFyC9zZKY8
         CFs/gwyUeP4/LNVyjIZmb2YliEYuPfAjlRhVTmbrBbUxgcKlJAiRntsPlVh5JAXGjYtB
         0fUaNx4VbIj/JjAnUIaiAJCFk0wr1UOJ7vExGAA6m0/L+PYJXRP5nX3J8n8icpg52HQb
         VjBFhBuK4nuRg0iNE4C9wt+tdHqjAYUvCE9hNW9CynC+TkEUBH5YD54KocG+2wcWRue3
         OjdwFXI5NxYvpkqiR6xK+VOEAAKnWLWn6eqYWfZy4lKdqfvhDvP9q8pdz1qFubeIGAbf
         JxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765504413; x=1766109213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fYCbe3d+U5qodPL2pi+jegtHTqz+qNWwtE+Getxtl50=;
        b=sQddwejeijO1Fcyg10TaNMTm0YmftqRbs88cAkItAPm1Qvh3vQ0rgWNFqdOaye+mQd
         Mza9yv0j6B31RaWNLTxKIgB0atrUTuGJm45RkEqKIQLCbrO4DbOoKPTq2BEYiqQ27Wej
         EuAZSlp0tfJuGjFuhd7d3Mw+jCKhJsm/zQJL6Ha1kpcb86msWWmsujkp2eENmVzzhGs/
         VtUUJgbsTZqy/yQSGS/EAbX+27RIkXfTD+9wvXvThbtg5smYGoNDmgrSsGAmNVuJvaur
         alrxEvbWnVqOiepYZXZhwZmXbOJ3zNcZdz1FcOrid2JfDxJo3sxVSDGiX0bN2cordWk7
         pWZA==
X-Forwarded-Encrypted: i=1; AJvYcCX268uKHpVfHpMndMOjPUKHNsRXMb2z3ykmW7QLGo1JBp2chO+cylmhiwmj+jsSQR7rr+gBDxltug==@kvack.org
X-Gm-Message-State: AOJu0Yzy6/0CUMGVReyEQZUyE17ovlYjEudqzUtBI13kM33FYRrrd08N
	jVxHF+kq/SdPpqLSDc0AHwVIHJQ7eCFhn2iTcaiyJulIJx7oMt3eTNji
X-Gm-Gg: AY/fxX4OUqjzNPrZ8lG24k/QPDEiXKd/7RCyjkjPeiwwWk/I/i2zj2lW/PXrzHNr9vM
	lqPYtTXMzWIGCW1R4IOfw0rrXB4GEBzjF9b6JZZmItHNvkO+hf2LHt1ZXXz+mD9qreubUnug3qr
	4sd4XijDLRie/XeyK2XN8/Gw1lt9FvHH/uW4toHJS200JTzEGtAz5MksLHNELSDRxEjbuRtQdyF
	HHnMStOQ5e+YF2KCLUy3bD77zDQ6zbHzdSRIJ8964AG/sRsAXueuV4z3nSKc6soRfHnBC1fdqy7
	E+Rbeyu6c9xLFMcGXsxtQ/LgZE4WkKtRcE//Yz/jmAcvg726LyzzDLOLzk2/PM6BJt4WF38MrRv
	lzdpzBVWR9V5qjnyxgXwn1NTQR5E7p0kvTHqp/6yPicv68d02kTSpfsU73ulEwWgUYfsH054LOJ
	g8+COYsP0PrP6XYI5n+DWl1w==
X-Google-Smtp-Source: AGHT+IH19dNbm7Wo3cpL1BaNz74wDe5f7qHJ69iLhsgLjotUFLmtyxpNXblzx8Aqo8Np5i0jhQoiAA==
X-Received: by 2002:a05:690e:b8a:b0:644:3a61:eb5f with SMTP id 956f58d0204a3-64555666fdfmr274975d50.74.1765504412637;
        Thu, 11 Dec 2025 17:53:32 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:72::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e69ffb2c0sm136567b3.23.2025.12.11.17.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 17:53:31 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Daniel Palmer <daniel@0x0f.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
Date: Thu, 11 Dec 2025 17:53:30 -0800
Message-ID: <20251212015330.1874521-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251211225947.822866-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B9EFE100005
X-Rspamd-Server: rspam04
X-Stat-Signature: t5jdh5p6itht8eau8tdttu9p6moziueu
X-HE-Tag: 1765504413-331472
X-HE-Meta: U2FsdGVkX1+aslZp3MCg5MyvjY2UhUjB8e0VIzqcSsjoxsK3kPMCFo6n5MkBX4q2YPtMiFflNlZpzU3iFAgyKicAdEzJNUEvedIHIfa/xbtD3G51Di6LZhEoMorgv9BzLhiMPrhuwqGfH6GIDeRQKIXZMLrKJbGbYiabKl8bmSE1akqbgwAMIISiQD4IN2ELyR77hAmqgxm6KNwpTPeYOYqo1Z9Jzkyx0ppcdg+sAPHhWZggRCtmzcFtDcMNjP2f1x1/JSqPXv80RUuwy8hYNJKGlWG44BkAMcN/ig1geYUDfD2ECdnmPDn0rNyC1pTpN/cPk4jXvRw360mZWh1wB86v7RU+hEs3xvIvtX7R0cD2Rysv1xohTsgat0fVP31aZwOcROTTFPi8W/FBvXkHp3mPCD/cZhkT9pmqv1Rfl1jdYNi9vAgcdQvGrE3QL5V3Ymz7UOANaE0lajiBdA44IboiW8yBIYmQwV/+QSdt22wR/q9XbSf7f+ZiA/Y64vfEIxFFstRGvzDUs0eKRBnMX3oPiBunREvW+bPpCXInBNrD25SGZ048AqKFDAbee2VME7xLPGMpkylkeyL0xOeWRnXmaPkA4fEnaq+c8Rm0KL/6BkH6QgH/mqpRYPBjqA/kQhqW6Pj083x0kyDwPe3j+itex6wZoQ+0ov8I7WwHJfGK7stVb57Ij87Oh51GWCFp0EHIooIaYvviiWLwNSrzweUpFNnf82b9slFtpQbSvvWPA2CUU6One6mlLBnlYX7ZMCmsO9kK0qjoHqgyXh4n3uT0o6Mbf7nIaLdUxJntOljt2QPtIsUHkxQ+zlQsiiNkXfH9xAkC8jDooPOFfqXMIWxDMym1bREJdep0N8EJnfMKWjcTNkEMcZ/nLbj6ctZRcPyN+0YbgOOkcTKuplQoKCWS7dNoD/8pkX4qTLQ5+xIlv8TELWRsREp/kcpZqszy7CM58hbCkTsQpollGnM
 YXdPdzW6
 ZPY/8iWMNOjFNtDOKKJRV9uxG9ymAYJqMKqF5Y1nBtbaC3D4ib+mAyYkXJ3fS2AbQ0vFZbd5eOw59Wu4zPM3xKkxJI8sYL02bs0oHQQ8+il58B0L1IcjRWn2W1cYOFQx4H/rWGMFrN05ctJl4zh1qr3KLKbBwJjaRE6ZI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 14:59:46 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Thu, 11 Dec 2025 20:12:18 +0900 Daniel Palmer <daniel@0x0f.com> wrote:
> 
> > Hi Andrew,
> > 
> > On Thu, 4 Dec 2025 at 14:29, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >       mm/page_alloc: prevent reporting pcp->batch = 0
> > 
> > I think, maybe, the following part of this patch broke nommu.
> > 
> > -       new_batch = max(1, zone_batchsize(zone));
> > +       new_batch = zone_batchsize(zone);
> > 
> > Before this change on nommu zone_batchsize() returns 0 but the max()
> > changes it to 1. Now it'll stay as 0 and anywhere that depends on it
> > not being 0 won't work?
> 
> Hi Daniel,
> 
> Thank you for taking a look at this and finding that this was the source of
> the deadlock. I took a look, it's definitely an issue. The problem is that
> the patch gets rid of the max(1, zone_batchsize()) and handles the MMU case
> by ensuring zone_batchsize never returns a value less than 1, but the
> NOMMU case always returns 0.
> 
> I think your solution below works. I've also come up with a simler workaround
> which doesn't change drain_pages_zone:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d0f026ec10b6..9d638697cec8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5919,7 +5919,7 @@ static int zone_batchsize(struct zone *zone)
>          * recycled, this leads to the once large chunks of space being
>          * fragmented and becoming unavailable for high-order allocations.
>          */
> -       return 0;
> +       return 1;
>  #endif
>  }
> 
> Would this be enough? Then we don't have to worry about handling zero values
> from the callsites for NOMMU machines as well. But this has the opposite problem
> that I was initially trying to fix, which is that NOMMU machines will now
> report a batchsize of 1 in zone_pcp_init and print it out to dmesg, which
> may be confusing for NOMMU users who expect there to be no batchsize. So
> it totally makes sense for me to drop my original patch completely as well.
> I'm not a NOMMU user so I am hoping to receive some feedback from folks who do
> who can chime in on which approach is better.
> 
> > I'm seeing a deadlock on nommu:
> > 
> > https://lore.kernel.org/lkml/20251211102607.2538595-1-daniel@thingy.jp/
> 
> I would also like to take this opportunity to ask any NOMMU experts out there
> about the apparent disagreement between the comment in zone_batchsize under the
> NOMMU case, which suggests that NOMMU is harmed by batched freeing:
> 
> 	/* The deferral and batching of frees should be suppressed under NOMMU
> 	 * conditions.
> 
> And returns 0 here which makes sense, only to artificially set it to 1 via
> the max() later on and still do batching anyways by
> << CONFIG_PCP_BATCH_SCALE_MAX.
> 
> Thank you Daniel again for helping root cause this. Hopefully this fix works
> to fix the deadlock you mentioned! Have a great day : -)
> Joshua

On further reflection there's actually an even simpler solution, which is to
just keep the max(1, zone_batchsize(zone)).

For zone_pcp_init, calling zone_batchsize() should:
- For MMU: never return 0
- For NOMMU: always return 0

For zone_set_pageset_high_and_batch:
- For MMU: never return 0
- For NOMMU: always return 1

And I think the solution should ideally not introduce more #ifdefs...
So what if we drop my patch (and the fixlet above) and replace it with the
following patch? Happy to send it as a separate patch if there are any
follow-ups : -)

---

zone_batchsize returns the appropriate value that should be used for
pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
1M, however, it leads to some incorrect math.

In the above case, we will get an intermediary value of 1, which is then
rounded down to the nearest power of two, and 1 is subtracted from it.
Since 1 is already a power of two, we will get batch = 1-1 = 0:

        batch = rounddown_pow_of_two(batch + batch/2) - 1;

A pcp->batch value of 0 is nonsensical, for MMU systems. If this were
actually set, then functions like drain_zone_pages would become no-ops,
since they would free 0 pages at a time.

Of the two callers of zone_batchsize, the one that is actually used to
set pcp->batch works around this by setting pcp->batch to the maximum
of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
incorrectly prints out the batch size of the zone to be 0.

This is probably rare in a typical zone, but the DMA zone can often have
less than 4096 pages, which means it will print out "LIFO batch:0".

Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1

With all of this said, NOMMU differs in two ways. Semantically, it
should report that pcp->batch is 0. At the same time, it can never
really have a pcp->batch size of 0 since it will reach a deadlock in
pcp freeing functions. For this reason, zone_batchsize should still
report 0 for NOMMU, but zone_set_pageset_high_and_batch should still
interpret it as 1, meaning we cannot get rid of max(1, zone_batchsize())
in zone_set_pageset_high_and_batch.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f928d37eeb6a..95172f4610ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5888,7 +5888,7 @@ static int zone_batchsize(struct zone *zone)
         * and zone lock contention.
         */
        batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
-       if (batch < 1)
+       if (batch <= 1)
                batch = 1;

        /*

base-commit: e0669bdbba170f6c1a7bf5763f72df3f58a4945c

