Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74475C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13EF66B00A9; Wed,  1 Jul 2026 11:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1164D6B00AB; Wed,  1 Jul 2026 11:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054216B00AC; Wed,  1 Jul 2026 11:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD24B6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:20:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 316B08DB89
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:20:58 +0000 (UTC)
X-FDA: 84940570596.06.D0AEDD6
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F766100004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:20:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cSVyF7Xw;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782919256;
	b=Sw/3iVsP4F68DhAwcTzGmjXaU+J1Mn9P2j8FE8Sm8jYYzyWnmkDfRmfsMNrl5SIWRAXhB5
	1M9uqr5FEPG4a5A5XbYXJLKGsSPi4GSOUh1+R0d9zKaq86GUpZeoQwwVc1RT9men3O3nUj
	BYneEUcsAvkJtG2dRj86QG3TUb/Odck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782919256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSMdskJ/XVsebZBQ8sHZxAPdt7ILVugrW/olreDrl4I=;
	b=nRXV7n7b2wneEBIvbOJjwn3JVXA5lzDkLIYbn660s7+p5AU2AFGzc9NcUigrT9ETEOxYlh
	7j2cbAM4kGk10zVUU1cYd1Y7WM6jEixk7i0sj7OSzoYOHcAmRihoTqyY5aWUeyUcDKNibe
	BHN/aPn31+8IAQI9rp3XAOZ3yDbjUWA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cSVyF7Xw;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e65e18969so57889185a.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782919255; x=1783524055; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zSMdskJ/XVsebZBQ8sHZxAPdt7ILVugrW/olreDrl4I=;
        b=cSVyF7Xw3Y/pRfLlDlX0sXWlX77cihQ0cm10k6TZ5sbXDJdyVqs9jhwo+stqguXLu6
         2ecb2shTRum7mGWdrITqc6soR0BfIbRafU9cI/s83m+COOtYHAN57wucaQpDGM6ytYe3
         2HnelxUdlTBEqpAnqoWL19hmKWHHgdmDfuko7gQTzEUe6q/GY1JjUWK2gADvU/O7sCv1
         b+UFeNKpZMjN5hGR7lcTF7lMjgr9T2/GkQ8hU8noLhNpvXI0oz+Jg8h2cEEt3gP5Msnm
         ynRHhhHdszfDJPVqljZ0nqoMq7QlE3TRsDqXajkDhftiy/k0dz0wxwz9jalsRmSJrCnE
         2Uqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782919255; x=1783524055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSMdskJ/XVsebZBQ8sHZxAPdt7ILVugrW/olreDrl4I=;
        b=XkOGJilFl1QlCEN0LoUO+By7wq3wyiKDNr0p2KE78RIYrvmRrUBY53y3bYyXw0ojvs
         SDp/7WTEflY7bo40Q17Ktu8U5rN7J2siq7HfU6MVNzndJXpR6pP0U7UIZBSx0Ig0iY6d
         J690fGdRl6swz3Cgy5Euori3vZEQWcEJeX+FFK+8/apJ4h4ebJF6mDxASbfTDqeJuhT6
         OyBYARmhBEU46jvoW8hgyUTEIM5OULnnjVKYjS2HYV/Uyc+QBI+XRL04gMI3Hmy7Re40
         SetEmRkI+o0kY8ZO7i2d0GOAZA9qvsDFKwv62wdv8U7/48cNsLByslvQrkzpSxgFoJ6w
         VUww==
X-Gm-Message-State: AOJu0YxjUwhQioyPt+JX/3brzYjaZKNFZs3x9NJHCiWHJSlDd6VQb4oI
	1US52hY7MsnEnropyFGpyJ6AQsFZELhoESxphPnNKEG3KE/fYfbw/vO1KeELuftT0Ck=
X-Gm-Gg: AfdE7ckD2BqeTxLm5IXLT1vU1H/c336ilgoIX0Mr+N1lHx3R0kqy4ad3LEIfFN2nU1f
	mt4Uu5ksLQ1MXJgWrTyi0la7Jp0ULV4APNhPQPOOguh00YxQl8kca+rpfO21O6XpXdw2LGgnQxf
	6hY6w7Ied1Ai8DCUF4aJNK7YjdlWCjt/y2JQMntG5WGYx0udifcNzvSZW3dgf8b/bwboeXsafjT
	LVnBmnXFrCIHYvQNsveQ0zCGYjNp9v9gSmVxzCg7py8vA/gH1TCU0FleWVPEWXXVG9de0bXz+c9
	iSojg4DL5/2YK4tHT9ksr7pGwMnYGvVBV8yNDJMESZcod/IKAqt3EfAqkcF8VGPMhSJDv8Aljlv
	u45bMNk0xP1Cg77H2nv62de8KEKVMg9JGVcoMPA3nru/oNvvKJ5utZXbMvKXtjDn6sRABkLpU9F
	3Uriv5wh992pnOvK31y4kX7a/3F8Cd+34MJ8iVYCvA+4eWiBpU/ZUWO4KkrrHGYvat7Hvh
X-Received: by 2002:a05:620a:178e:b0:92b:f1ba:5fad with SMTP id af79cd13be357-92e69821ad8mr849855185a.37.1782919255344;
        Wed, 01 Jul 2026 08:20:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e623379easm595581185a.32.2026.07.01.08.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:20:54 -0700 (PDT)
Date: Wed, 1 Jul 2026 11:20:50 -0400
From: Gregory Price <gourry@gourry.net>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
	osalvador@suse.de, akpm@linux-foundation.org,
	mgorman@techsingularity.net, hannes@cmpxchg.org, vbabka@kernel.org
Subject: Re: [PATCH] mm/mm_init: handle alloc_percpu failure in
 free_area_init_core_hotplug
Message-ID: <akUwUv_rrgmRP4bK@gourry-fedora-PF4VCD3F>
References: <20260630214039.2263562-1-gourry@gourry.net>
 <akS2AYLzOzlJ8tIO@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akS2AYLzOzlJ8tIO@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F766100004
X-Stat-Signature: rijszytj8pi1sc9eugfnocuqkzzsgobn
X-HE-Tag: 1782919256-342397
X-HE-Meta: U2FsdGVkX1/2sK4syYPhGLhVWwi92SLql86NPoDCaJJ8JGNioSeL3uVVjDvEds2h7UIw1ZFuiw4Z0iBz8FlxHF253g+dtAlizp3xEovIAJHhR/CgCEDQu4VDvQhiq0UaGa+ZMQ0uJHYqJHxUjhIXsUFVXjtZcplkU5VfXc+uV7h/+DUu7oRxAF3PN0QBKKbPLGN5wpocr3BOT20XyWyId6kKqpTgEB3kEwg7Bakqg+67cMX2gMXQj73eA3PkrB717L18n2VptiDfh+vonCubCcSHCuXn63nFJp/obWSRko15NzRaPHbuXqrQ30ENKLY8ANQz9P7AWvx4rrv6DY9cQuBk7O/CnGSu9dngC6dGd82quQkTmErOUIA/9Qq9Id2fUX07BMPokDyXRgwuCtlrHD86mU5//M7MfTn4iEnYt7Aul6w0ZkCYXoz1klAUa7fB9hhx7Rtq/sdbBKAObMGa2boqZ/bPyvhYke5K48Sm7FT9kK0b+wqktzgKS2iuoycCTmvnGL/6fq4DJuLJth5oRCJHue44kpjY5gCp268Zz/RPmY/sZH6M8ExdJ0phljQ4oFexCehzejnSf8ZmFJ9aO/W2u9lF2L6JdP4bZpEo817bFryVJBmWuLvx6iYm5dXxjKulUfXLxHslTs51eBLBjQYoWphv2BhY/B5AOc9I+aN0kuW6n0MiwWvJZjzV8xlyPbaMMmCQf1e23UKKaJe49VdGy81bnYI2AVcllydwxn9jJahwJuf7L/7DgqwOE/+/yr35kl6xQ4BLaXgASvLwRtwOZNtIH8LC10ls2AA7wKg2g7rQhVIHgSJlSYEtjY+0KghodDF6imtAzTtzxfiEuu6VJeiNUVI94HHsN08cBCoHxfRKjmpx3BZ0DqyEOX3u6ZKQ3H+yOtfW1qKLKgncmmT6hwd0Lom02c1ZWd8itWEXMzs6XF8ObqNB/89k4H+ljtO2yzrM17PFdCDw7rQ
 UzppYi38
 DFr9o2sQ5bM9OIGA0PPFwnUDoQ1y7xIbzYSRgZHPZI5HHqI44REf8fFXTeZjkjQldF6TBiskSZPShM4ZF1UfqEcqmzMA8/PASMVMmrWoDJuBooFfNepwRUopmnx4XPkFae5dfNBZ5QMVYJmTdiLHfLibGRQwVfll0bzmgSAMIJEPdDGUYhc0VZDa7VM86iqh9T+3DLvYobXDLfsgGXNVrnXIoRrYuc42KSiXnfwEcScojJW7lWYJ2p/sIUE2jaRMwdd+iYmEnwxp7npCVrQTf7xU2y4Aeh/L4iiGLOu3KlFo+hB2+76p9TaXWJHd4PcGsoUCicZO4qAHJn7JVphE/bYin4ZHPgEw7aPx/c6hYVMDFf656a+pFqy/EkwFbjvHJX9/xslr9NsGfp+Jul33n0m5Zcj6TagvWilQFXxiSqFNA0XsufCJ9hPmpbKYFK0u0aYYxLZgGBsPCay4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 09:38:57AM +0300, Mike Rapoport wrote:
> On Tue, Jun 30, 2026 at 05:40:39PM -0400, Gregory Price wrote:
> > We miss a failed allocation check for pgdat->per_cpu_nodestats, which
> > results in a NULL deref when we offset into the per-cpu area.
> > 
> > Propagate -ENOMEM up the stack and leave per_cpu_nodestats pointing
> > at boot_nodestats so a later online can retry the allocation.
> > 
> > hotadd_init_pgdat() returns NULL on failure, which __try_online_node()
> > already maps to -ENOMEM.
> > 
> > Assisted-by: Sashiko:unknown-model
> 
> I suppose it's rather 
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>

I honestly wasn't sure here, Assisted-by is the tag for LLMs lol
i can change it

> 
> > Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > ---
> >  include/linux/memory_hotplug.h |  2 +-
> >  mm/memory_hotplug.c            |  3 ++-
> >  mm/mm_init.c                   | 14 +++++++++++---
> >  3 files changed, 14 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> > index 7c9d66729c60..f04b915678db 100644
> > --- a/include/linux/memory_hotplug.h
> > +++ b/include/linux/memory_hotplug.h
> > @@ -289,7 +289,7 @@ static inline void __remove_memory(u64 start, u64 size) {}
> >  /* Default online_type (MMOP_*) when new memory blocks are added. */
> >  extern enum mmop mhp_get_default_online_type(void);
> >  extern void mhp_set_default_online_type(enum mmop online_type);
> > -extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
> > +extern int __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
> 
> Nit: we are trying to get rid of 'extern's in the headers, even though it
> makes the declarations inconsistent.
> Can you please drop the extern since you anyway changing this?

yup no problem


