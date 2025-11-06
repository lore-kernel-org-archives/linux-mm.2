Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1E9CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E768E000E; Thu,  6 Nov 2025 11:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035328E0002; Thu,  6 Nov 2025 11:11:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4768E000E; Thu,  6 Nov 2025 11:11:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB5668E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:11:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B38BFB5CC1
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:11:22 +0000 (UTC)
X-FDA: 84080672004.27.F25C16C
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9A3184001C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:11:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iz4wuFZY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762445480; a=rsa-sha256;
	cv=none;
	b=K9EG/lg0uliCmaq7rUkyZUM46xADhHa/Rp/5xNw/ke/0gCMwmtrIICa8K1JEs/nS7tTmEs
	gkoHSmQtKfFNJQBHYUCtByO7BVk0piMCdiGLpnirUbJ0YM3b/3ytp3QSUPni35up+foJa6
	+xE5S0vkSJmpI6ut/YJVpxahDl5qcxg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iz4wuFZY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762445480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m75i7vNoimficFnnD6P1eh7Qm/0yszGY8TVBpjGyd6s=;
	b=OjpC9qOZSolSEvmhqdfoGIgaYaAwWYBr7NZmeRXXPLq4GVqw9qEvLNY04obYGw3iX6ktQC
	Tzuf3o8FBC0MRVBnkyBLzk9k+JoErX6nEah88ien1XNyGg0ft5MSk3cb+0CinxR5UidqjA
	mPT+N9dI8zYPKDpIBU9ujCc23FL2Uw4=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59435d82c1fso1282256e87.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762445479; x=1763050279; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m75i7vNoimficFnnD6P1eh7Qm/0yszGY8TVBpjGyd6s=;
        b=iz4wuFZYewLwhuhqylerNdWrDzGtSx9twctkvWc7Hlgjautylo7sldAbAWTDpjS6Pp
         KL8MNrIPJyGFvgwJ4ifWpkk229M2+tpUcItMxh4V8yYJgfrKKkYZczNR9fRFumdQmpuV
         hb9iXJIX250udXmndkOhO+O5qp6Bzn+FRMewqhpx8acggJXULGVMVfQFxg03eJg6Ggd/
         PEKx9s5U8iFB8XO04eoeSV/hwyKFYHPSN3OnlpOFBhcU1cuEFBnRnJWj85Tmbe0/V5tl
         5FYZta+go6l/fD9JiJ99YPpEik1Ryvx5a0JWN4toburcmgq3iwGL5rIPdI7kg16ryNwm
         po8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762445479; x=1763050279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m75i7vNoimficFnnD6P1eh7Qm/0yszGY8TVBpjGyd6s=;
        b=ZSdGYWAyeBHNJVnvVRf7dduL0BgPiGagyrtbiKDalWNTrZiXuzkNky2zwe8TVDYy26
         qNfu0QK1V5lxONuEYeKm2NRwCIpLVVd1J6rx5xUtPsq9jIK/hhsOQ6Ase97nL3ce3eFI
         B6trRvOWddAAvtwBOlyYyU5zdJtvkp91NUaKkJpzEB4Qv9Keh1KI8xgG2LiK8LmPtFxU
         e++K4Z5hXSYb/leCmr5H84QCyNEkDqCiqFg5b2yelEo2csu2th0TOQ9jaJ8gDmrqFdaw
         GeLYcRqWqezcTgSuXOnwcsf1wtRFcAKGs8vz/zVbSDYlPKkIkVReNZYuVWDibNIQaLJ2
         ksDw==
X-Forwarded-Encrypted: i=1; AJvYcCXiQA4cu9JWgZb+Vx6NP9dBGJ5VworcM8nuW6EFvCB5TCEcIqS4UtNGUyypmI6Riozy6uggxqWlng==@kvack.org
X-Gm-Message-State: AOJu0YymXQLZbp18Mhg2+Dv+HDWpb1t5TPyL9U7mnQmZNvV9qwzaoUcL
	9fZq2ZRcrJVM4e5mi7uFdhHhJj/gc/GnQSyji0FVqBfRGIOrKPIHS0hM
X-Gm-Gg: ASbGncs1HsHqW+3cj/b+MMl/MB2mhbm765SbQ8C80eI4Fd7BJNQ/GZ4mhZrpEEFAVTv
	A/nO78VKqxNx05BoQWpqnmN5asl5mrYwL8+V3XPioiRv83QHW+GzwI3bMwCx1alIVZKFg8pKG67
	dJGlqVRGJeyADLPGMGPEdgTthN+JXuw1qyMqo0pRA3+aWO0ikh5COt7wQhTtBdo9Dt1kmBrOzzc
	I13O54FN089u1oUCHI9lto1AqXvyohcoIuvrOWsAiiRrTLQJqOix5yk036sabx5Ohpbv7l6r/M4
	OfLukJeTPSZ+IcHUzN6nMT+uaqaAPigPJ/XfboOgF/q2jHrJQ8wek1rhiDpvrkZYq4+boWRKhbs
	MVnLHNmQuHX6nMOwxVslQH2vLkib6YHqUHDZvS2V77q+stL7B7aWESg==
X-Google-Smtp-Source: AGHT+IGIIseZixMOo3+aCxB6RpKiM416jTA+ZGYYPPD7AoNcC+HpEflzewL39yo9nuj+SpbBpbmOug==
X-Received: by 2002:a05:6512:3e27:b0:593:4a:a5cf with SMTP id 2adb3069b0e04-5943d814658mr2204519e87.56.1762445478234;
        Thu, 06 Nov 2025 08:11:18 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5944a013cfesm811133e87.23.2025.11.06.08.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:11:17 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 6 Nov 2025 17:11:15 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aQzIo1ceCt3xP10o@milan>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
 <20251103190429.104747-2-vishal.moola@gmail.com>
 <aQopoAj3i2jdIX6V@pc636>
 <aQvknlh6n7ncfAlA@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQvknlh6n7ncfAlA@fedora>
X-Rspamd-Queue-Id: 9A3184001C
X-Rspamd-Server: rspam07
X-Stat-Signature: 1535bawxi8eyurpkj94ajwfbrxqhu5pc
X-Rspam-User: 
X-HE-Tag: 1762445480-576926
X-HE-Meta: U2FsdGVkX19fj7OvybMEaASI/mkP/0rg+TjrvcCdt/IqEg/7AyuZqeAKvDuO6DI19exlghIyPjcaieOIXrPElv26aXmLBRrY3DcZXjyLHjR4HxODjYt52bCohvlpC8a8EkPLqq9fgZg2VV6bw/nvKUfIr1C1nb9XKEc+/7PGcmbflwPqGBkPp45PbQsBIpk+Y3N2XvAx50E0P8WPbpM6lExEvbtZjShKep/dd0lHKWOchA8Dn5a5Jtc80eHJp3VPnAw0S5IW0ZEuXuU5HNEcOyjzYZrzi1JlGADxl4+8+YKukpH7FfQCeqU+24HP9Qlc1SQNsibsrP7ur1fAyc98aAC6mroGCEBv7qIvNLLrFZMghcnsCjkwufbVIZrnUU0WHcIZwUwU/jtEHQxbbP87Lf9XOCA7MVrrJpDH3wtwuAkOaOZuUazSmsVEMndOPp3WUcDAIiYaoTMJUxCbUhIbBKYwjOCsXWllBBvRcG71Jkks4z6zXnxpjIGWeRIvhP9JKbDFhMuaJiaWX6JHs+VAUj34CbwHbgVeT2KKklKk+HSCpzD3n8RXtXPTEd1qlvwpvK4xi+ePPYuveJN4webd3YkshWLzT8X7yW3WBKwBNOEpv7AiDGNjs1vs6lGepVYGFl22nFXY1q4z87ssNDsq9MQUZvJmNyv1O8vLjzbXTW/hXFaW6OS/TyemcC6+E9y/NwgW/hu683YybjKSGauwthabBI6FcS4hBMyx18OatX8nLm4DuDu5IGVdiFP9qbBXNVNeRJ5BUPtuzhUP9I5WBjRM0C6lJcZhu2CCRf54yNKguQ4vJv4GMbmb7iWjZhAHJPkaAmXHOwFI8CO/FnuYYjxHvMy25wypUTZFUos6USZH3H/aSl9k70rznlV2HzDsfTPRm+C9tPzS6l249sj+TqIMYF9huTgt2rc05XHXamo/v8AxoC661iIugN7lCRR/Pdcw/w2S1OoHOOfBREj
 Hed4U2Oa
 1MDzsvgukFX5ZtrHYti5uiyNayGD2uZLBXC+3hRXdBcylGhTKeGlNmBrJqR5ALhvgGdtuFaKeG7yq1DkOpZCkdYbembMcNgIfXYefc3zbQreOpXQkzcABF5TeTzlj5NY9bcKMBv06WhFS+kvI1cXZcllQbLI2HRe7LdfAbpleIuTnkt2oOeHIxrev76l3evV1eFrrhfksPD8h1cb/pZXd0X0KSjrXzzt2BWlSM8DKHZbqC1pSTNFqH7Vx2gE2978oAS7EXGctCw6EGdyfKlrQOM4n7hrEqn4e658cmcfw6PA6Qpzs/MSoOQOjHa+AHjUv2t9i41uRSYCkSwdx248W0ZzIq94Nzg8krN7DuFcrDcvNoGp82nW8uPeeYbgsqCBdOLLf/oQAmTtYrQ5AoGuuh1jj6KoZKDYRGJwVwy1iScZU//YlPjUq+zP7QRJCy3XF5Y/zsV/PQLbHZ8u7fDQ7T1CftEm9T3086v8E2RL1sB8ZiHZ5/wZfHWoRIasqSdptAw8jrmqhbcoTkl/KaMrb1IqUDjw/LofQSMOWX1l3G6OPDFg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 03:58:22PM -0800, Vishal Moola (Oracle) wrote:
> On Tue, Nov 04, 2025 at 05:28:16PM +0100, Uladzislau Rezki wrote:
> > On Mon, Nov 03, 2025 at 11:04:26AM -0800, Vishal Moola (Oracle) wrote:
> > > Vmalloc explicitly supports a list of flags, but we never enforce them.
> > > vmalloc has been trying to handle unsupported flags by clearing and
> > > setting flags wherever necessary. This is messy and makes the code
> > > harder to understand, when we could simply check for a supported input
> > > immediately instead.
> > > 
> > > Define a helper mask and function telling callers they have passed in
> > > invalid flags, and clear those unsupported vmalloc flags.
> > > 
> > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > > ---
> > >  mm/vmalloc.c | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > > 
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index 0832f944544c..290016c7fb58 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3911,6 +3911,26 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > >  	return NULL;
> > >  }
> > >  
> > > +/*
> > > + * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> > > + * This gfp lists all flags currently passed through vmalloc. Currently,
> > > + * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
> > > + */
> > > +#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> > > +				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
> > > +
> > > +static gfp_t vmalloc_fix_flags(gfp_t flags)
> > > +{
> > > +	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
> > > +
> > > +	flags &= GFP_VMALLOC_SUPPORTED;
> > > +	pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
> > > +			invalid_mask, &invalid_mask, flags, &flags);
> > > +	dump_stack();
> > >
> > WARN_ON() or friends? It prints the stack.
> 
> My understanding of WARN_ON() variants is they're used for internal
> kernel concerns, while the pr_warn() variants are for situations like
> this where proprietary drivers can cause unexpected behavior.
> 
As far as i got, we fix the mask if it contains buggy flags. In that
sense it is absolutely OK to warn and print the stack of caller that
violates the rules.

> > > +
> > > +	return flags;
> > > +}
> > > +
> > >  /**
> > >   * __vmalloc_node_range - allocate virtually contiguous memory
> > >   * @size:		  allocation size
> > > @@ -4092,6 +4112,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
> > >  
> > >  void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
> > >  {
> > > +	if (gfp_mask & ~GFP_VMALLOC_SUPPORTED)
> > > +		gfp_mask = vmalloc_fix_flags(gfp_mask);
> > >  	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
> > >  				__builtin_return_address(0));
> > >  }
> > > @@ -4131,6 +4153,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
> > >   */
> > >  void *vmalloc_huge_node_noprof(unsigned long size, gfp_t gfp_mask, int node)
> > >  {
> > > +	if (gfp_mask & ~GFP_VMALLOC_SUPPORTED)
> > > +		gfp_mask = vmalloc_fix_flags(gfp_mask);
> > >
> > gfp_mask = check_and_fix_flags()? 
> 
> I just mirrored how its done in mm/slab.h. IMO its cleaner to keep
> the check out here and have vmalloc_fix_flags() stick to one thing.
> 
> If you really want it as check_and_fix_flags(), let me know and I'm open
> to changing it in the next version.
> 
Well, i will not insist on. You decide :)

>
> On another note, I'm now realizing I forgot to mark the check as
> unlikey(). I'll include that in a final version once the other 2
> patches have been looked at.
>
Sounds good. One thing i have noticed, it is below peace of code:


/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
if (!gfpflags_allow_blocking(gfp_mask))
	nofail = false;

i forgot to drop the __GFP_NOFAIL for non-blocking flags. But this
is not a problem of this series. I will fix it by sending the patch.

--
Uladzislau Rezki

