Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1AFCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBC5D6B0096; Tue, 13 Oct 2026 12:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D706B0098; Tue, 13 Oct 2026 12:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38066B009B; Tue, 13 Oct 2026 12:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 701406B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:47:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F16DAA0D85
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:47:06 +0000 (UTC)
X-FDA: 85318182852.24.B422BF7
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1D4D540014
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:47:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h7Zsl+yf;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791910025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7ehum626aRdlGmi7yPsx5ujCWqhQvPjIn6TPtUOXnM=;
	b=5SvevWb3T9w6ljp+SpOI8Zn9CLHDq0qkho71pTm+jVbe6nZYyvLaY/xa3bp4XQvgAdUzxN
	kDzIcqUliRGJVMsUjWmITlv6p7TgKO+3BojeJAnOj6sSa6RY5/HufzvO5YQW4JMqmlhRIc
	T683mgNnm3eGr9hu7YlonZogpAhyrm8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791910025;
	b=E9rT3sPid7+NeNknnBV55mBonLRpS4iQbm8gKSCBLT8Wwne9X/cBlptziS1grbgF9TiPSR
	TKMw2HLZu8bCsaKmTjESouJr0SAzyur0dsU5efAg6UPuC9NLA/AdXELyfb1N79fMFgfNaO
	bdrmL6cR58SbeAOwHUVQv/FvmLfF/FY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h7Zsl+yf;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5ba4180a65aso2781385e87.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791910023; x=1792514823; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=W7ehum626aRdlGmi7yPsx5ujCWqhQvPjIn6TPtUOXnM=;
        b=h7Zsl+yfL1ZOJQ5qQWZ6NEnU2IWs709H/udfDzenXjicxzsAtSnnRUQW39So3hprZc
         VsBW0To8uRIIHerPW6sK6GX9ie7eEsKIgzwruWkEOB05j3W0wc8kpP7PYdpLro8uFTA0
         AgkF5btpHzlehkv+yJzy6pLWCfGUDkE4OwcXNhSjcMJwiR3SuGazyHiO0lM/yOH1wF+h
         OK06Fn79Far0iVZcHAwuW1PG69JJCJh8MtMwh6blb6iCSi05+Zgb04GJ28hrmpL1KVZ4
         3pAZeyZSmitkmGFEnHjRDMxpEKI8k0M7krm8HN02f0dRiGO5533kYOTdLXYhLKYdka3P
         9vYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791910023; x=1792514823;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=W7ehum626aRdlGmi7yPsx5ujCWqhQvPjIn6TPtUOXnM=;
        b=G9pt8AIecq3E1AoPgDZ0L/iyqwwyLm7M5/zqZwvacYbcIHqjnZd4A/lW1qaqSqoEj6
         FbP4pyybWdWrVyqdvYtIURynerRwhQAIdIZ+dzNmioAvZWdr1J+LJnNyBU/QYHx8/eJm
         O4HcSlPQm7Bi16//C6/6hxRNKO/76xj4J6zvgOCjy992Elvtdl+0wk1lt3w0SlqPgOb+
         CltzNyr6Y4Kz+2aim+v7k883Uqh9rDz8ISj1SJYb0IkGGLM4HgkUULlczu/vcA0K6N27
         /vXOo9CruMBU65m6EnzHZ7NjKqI166tI/tVp2ma6v52YrMMwxYLzYEIQxSRcaXKkvCZJ
         yrsQ==
X-Forwarded-Encrypted: i=1; AKwUvByKuUfJFZjNkuC+EWFlacXWzfwJUdyIkrUofXwJbOfdih/YOkOyC+4lPhBmJuJPDG4uWz/R8x3v6g==@kvack.org
X-Gm-Message-State: AFq9FYLSg5LVw3V5QRqOss1BuDnTtD8sMl9E30wuSlW/d5gWVgFmaink
	epMQHG92yG/TnuXTNFoCcwg4LgEKl2XyZfeRLeJMYv+ed1ZxCzH9kCZF
X-Gm-Gg: AYBFou1lNUEKMePblnZsav7+g3v9lch41X4vOjOG4+LXGqPWln7DsfZdEQ1XLZfTX/I
	pOr8NzFaqX71R/K4LoiTWPVAvuQUdJhuP4E1GILjwvBRde6IJ+P24k/2qF4eMio7I49Q6zsCXAr
	8bIcI+1Xb3ku6jTpmDl62kiHZLvC/spAIWE79xtB/pz1uhn0RUXV2nSPbqX2wgHtQeMmDwPNIEa
	8nOwvSPZRwC7AFfG40yGCZmiSeCjjFte0E+Z4kTcK9VaXXuXEhCVkJ6d2Y1D2XLakIsC3gJs3v6
	xmJJZNG3ktbpfpVrDI7mnTnUZLOTKo+xiNwejixPlTIvXyYWh+2QpLuXPsDNL1mDA3ZtnEgm4xP
	QtGtqHtyQ0lVGf27pNjxN10h7A/9ZYuE1xQSoipFo/aXzEuWY0Kkl/Y6Uh+/zqiA0JvF/uKywiR
	ZOedgAb6BbHimh40lAIZpc7DtwPl2FCjXIR1lTRZA6ppOiMKLBrjQDH5tAhkYAc17lCdw45gopO
	ZEVXRB5rFivrHa1Fj1Y0pu89+uNS6PwLFY=
X-Received: by 2002:a05:6512:2243:b0:5b8:f202:7749 with SMTP id 2adb3069b0e04-5bcde8dec4fmr4962852e87.59.1791910023287;
        Tue, 13 Oct 2026 09:47:03 -0700 (PDT)
Received: from pc636 (host-95-203-22-87.mobileonline.telia.com. [95.203.22.87])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5be33d85b40sm52801e87.50.2026.10.13.09.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 09:47:02 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 13 Oct 2026 18:47:00 +0200
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/4] powerpc: drop redundant unmaps of failed vmap
 mappings
Message-ID: <as5ghOejcvM5zDOa@pc636>
References: <20261009063619.112313-1-hao.ge@linux.dev>
 <20261009063619.112313-4-hao.ge@linux.dev>
 <CAJuCfpHjX+_AvwgqV3XB_QQuorvnegvd_YjQ85JZWfSk-ckUHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHjX+_AvwgqV3XB_QQuorvnegvd_YjQ85JZWfSk-ckUHA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1D4D540014
X-Stat-Signature: uss8hqja1soz9orjbt5yrzn56erxje5w
X-HE-Tag: 1791910024-53447
X-HE-Meta: U2FsdGVkX189IaGP8zswd4ZWR2qBO4nST94nwdh+w407zfHI9arpMM35/DQsPr27gYKBHnF2WNgYISNcNtdiOvxEgGrASI3mkQii4MZJkbolzsSzYhYZWMiIhF0q2V0HuBErUtNpSDFwwo+B2A+dO0b+5tN6A9OH6gpM4Er6dpdUEv/AnVRarRo3ci4+Jt6BZSUiFFPiaEDYktR88HJojI156THa0pjr0pdhrPS3tkqihkxYOvZ3VGHzQXGsHP1DrZeQTd1cQsKEPpURiNr9Zh3AeoJo5CwGIIB70yTJsC/VX2fdhpmJOxyHEeIUNNRt/fAVQHWrzLBvM5uA7zypF3whVwcItinWd8xy8+/T6qEQeiNsv0fdB8aUDme96mSqRHhIGm7h0IzJ9XknqdznoRUR3Qw+wR0NjdtQf+hbWPO8ifiUL2AwsRRKb1E3t5OClEID+Jbyn168bT9Nzz21gj/6hUFvvOkihBlRhJqz5KDn9xOVYqXwu3XsSlzUEZHAljosCxKO+rxyArDI+Q2/SEtUUnh9KwXmkwYNk9Te15pSOApj2Aap4gtIHLgXHZTQyYtmMEcz0WbLEUNSFlpZz7bX1mWLnD53kBXH0yYkr3O1G80/02/BrOx3CYnU7QckJXs0ErEb+il6xV4uozM5VRVmYv5HmxQC9Ilrk8LEv5iMGGLt748K474QvuouwgZK5CTmgRbiCUUkuSGT5kjkKxt8QIYVjPHS2BXzeWWgmelzSPnLs+1fdXG1cL5G2JLbWxF0gWTI8Q7kO0Kk/rrgDAifoV+OSefjGUmmewiAzcJySO6HL+XLq2APtFNhdSdMVlKW40qom+Os9VjY+hWLeQUNWFf8F/UxhXhpAFVV6oXSJKXrzJ3JTzxELtV1IIU9t0UK4Nn4x4CJ97cCBEPfMq5fTELWvw6RTkofI1rgymeFLGHkNKO2X2yQgTnsBJxPBSa/cnIcdLW3PukgPLe
 y+LoFVwl
 RVpZ54zSA8Q8y3sfV4inkoYplbovptqwwuUrVLBlTYOBY4t5tRyYiXhQvYSRcvL57A4SbOz1mdBz9j/UzdDVKC5hxzPseZesVBi2CSVvNK0prne5NHpMIPVsfuAVewNvXM9S+gYVQbBFbvWQ7M/T1LphGjyWRT/fh9oq/V9sz7OZwwzZLj7jIyR/p+x0y2pilX5zhvzY6217oDHLAk8uMCIuP8FyIHZ9+CRnYpyq3cguIuJVir9OOqf8xQ6HQAO+uyh0BaPAUroy6nDEjIo8/qQy1FXM+3Mr54znJ/o43HCqdO/yrZz/ozuzFbG6WS6faz4nyDytwtaLIkCJcPEDYpQ/Mg5VbMD7/KW+7mBQmPH1GMkoe8IDbxv62ReY84XwtkfR1z7Rb7NImHHbW8Xa/NFeK7uREnVV1TqwoCwMNaU5/glb0h3h6E6CCwm36OCpuQXhy5hZhzsIkNuJOkpR8fPSZOJ9bV/e+vN7q65UKytK+vNe2f8+qfveooPRy6JsdZFiz4kq0WYYujZ+FWUrrCWKUUPQgzs4rxzxW1ttG1n2rjcvstbQwGWVvDdZWj1vBFjEbHV4W9Emaep8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 03:23:41PM +0400, Suren Baghdasaryan wrote:
> On Fri, Oct 9, 2026 at 10:36 AM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > vmap_page_range() and ioremap_page_range() clear the PTEs they
> > installed when they fail, so the vunmap_range() in remap_isa_base()
> > and ioremap_phb() has nothing left to remove.
> >
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
> 
> > ---
> >  arch/powerpc/kernel/isa-bridge.c | 5 ++---
> >  arch/powerpc/kernel/pci_64.c     | 4 +---
> >  2 files changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-bridge.c
> > index 5c064485197a..93029d85e6ea 100644
> > --- a/arch/powerpc/kernel/isa-bridge.c
> > +++ b/arch/powerpc/kernel/isa-bridge.c
> > @@ -46,9 +46,8 @@ static void remap_isa_base(phys_addr_t pa, unsigned long size)
> >         WARN_ON_ONCE(size & ~PAGE_MASK);
> >
> >         if (slab_is_available()) {
> > -               if (vmap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
> > -                                   pgprot_noncached(PAGE_KERNEL)))
> > -                       vunmap_range(ISA_IO_BASE, ISA_IO_BASE + size);
> > +               vmap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
> > +                               pgprot_noncached(PAGE_KERNEL));
> >         } else {
> >                 early_ioremap_range(ISA_IO_BASE, pa, size,
> >                                 pgprot_noncached(PAGE_KERNEL));
> > diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
> > index e27342ef128b..f74269636d5e 100644
> > --- a/arch/powerpc/kernel/pci_64.c
> > +++ b/arch/powerpc/kernel/pci_64.c
> > @@ -139,10 +139,8 @@ void __iomem *ioremap_phb(phys_addr_t paddr, unsigned long size)
> >
> >         addr = (unsigned long)area->addr;
> >         if (ioremap_page_range(addr, addr + size, paddr,
> > -                       pgprot_noncached(PAGE_KERNEL))) {
> > -               vunmap_range(addr, addr + size);
> > +                       pgprot_noncached(PAGE_KERNEL)))
> >                 return NULL;
> > -       }
> >
> >         return (void __iomem *)addr;
> >  }
> > --
> > 2.25.1
> >
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

