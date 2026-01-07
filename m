Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3663CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 01:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0866B0092; Tue,  6 Jan 2026 20:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DE76B0093; Tue,  6 Jan 2026 20:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B976B0095; Tue,  6 Jan 2026 20:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7BD96B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:37:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91F30BEA78
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:37:32 +0000 (UTC)
X-FDA: 84303455544.10.D8C6423
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id A306D100008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:37:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M+If5O2g;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767749850; a=rsa-sha256;
	cv=none;
	b=51D6HxLhm3s6iGxYx2aqtOEsXttICXLaMbedq0HsYX7Uz364+4pJhEUO+C3zPwjPx9NodD
	noKFLxDIWRXa953tcRihiWXYvU5algfEakswlgAjtMCW3vzPn+eunOO28nvtMwqlq1HUGF
	RPc1ULCKLiSL68EQqFUWf2FDGwYVMRs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M+If5O2g;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767749850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyMxZBUbUXkae5qQ+B/HAj22TvrkUVWUDODjQP867aI=;
	b=LtO0SmR5E0VZ5M4VO7TTkej/iVYimO0Jo0ckOC9B7pxM6s6U+5Olxl8cU/q38SkGpNKsGq
	NBvTyrUR9hHPb03yY9Cstw/a9IeodVcX/5BPoQvmu6LbV0VvorfV2rlm5f2xOkRzJehnPP
	428sEatDMUHgtSV+tvQw3YjaVARD0Qs=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29efd139227so15719775ad.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 17:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767749849; x=1768354649; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oyMxZBUbUXkae5qQ+B/HAj22TvrkUVWUDODjQP867aI=;
        b=M+If5O2gCNJrACEsNoNG6qjx+OCYZOGpbAEkAxxzOMai3XchsQjE2GKPQlecOJ0hoh
         MN7+ZjZp530OEybisKNK5c76UWu4L4shLk92UliFqfYcHn5/dO9rGBoUuddrTuETbf7i
         VzhJZF4lSl6VwOMJ8mo3iCWOCJVtlxR5AM5Zo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767749849; x=1768354649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oyMxZBUbUXkae5qQ+B/HAj22TvrkUVWUDODjQP867aI=;
        b=tWuG2pYWGGdTTZUdYjERQU4Z51X4rM1oBdTH4dcIsHXjoqDzLomvgPqzqLWHcWck13
         KR13vFjW8gEEBvfi9Cyy6eZXDuflkub2Z35S3DYx0wo+1EQTik00o/3umL42vePEuqlV
         HshPpq9v8+vcNTatCXnpa4kpKt3uE+vadpNcNjyORYB9BhAFpHiX9goaooE0zldD/usg
         MrGDo6e/r4R1Ja9rwKCrUx9KKJh0Y88vEjDN3kngUfw7ril05X0QQgZBU21mpUPLJmUY
         jxu3lFGggdKM3pJX9luFYIGglLN/6HjNoLpn3VSVIgS2CnqcJg7ghqV1Pmzi7A3efHAk
         6NLw==
X-Forwarded-Encrypted: i=1; AJvYcCWI3pf8B+Pr+hhRbBhr0Ptgipp1+2rZfSkTFG+qJEa8ruVJoZX0VrdQGaWMgoyWFlJIeZNKZ9rJ2w==@kvack.org
X-Gm-Message-State: AOJu0YzSvYoJnG7WIcdamAyWgEBumZDP/nODbUnpLv+JEGWSJUe9cWuC
	g0Wfhvq19yrcMtMPhzTBb/8yBgCWnbQbi0BIA5SMK6/MhWdYZz8116t3/Ysifw953A==
X-Gm-Gg: AY/fxX4G6+vDaxCtd7+hUCIa8ioWQClFOnlW1bbOgUA+mg0X/T3ELR4Z3aenX+P8KPz
	/kOalGq9xZIWnBSrUuMX9PzHHOGAOeIncGjhVeb/tGHIgVckXY8WfNjNyob31+TNKLns+mHcasJ
	6p8O/wrjWhrQgb0Dq0YuINU77dvPD+BwbLGFEG4RLsjTKJjdHxwh8AElGwdUYGtlRUn0H8qi98R
	R7VPavB4YgYLHUUTjYvu68PyFugcd3p05N7+0//HhWRAGZb/RvHTVmomgPexOmuNU5v5HYYV2Ex
	Rqx3B2dTSWCEJB8cn6K+PClI0DFHnbIXcbolGdVcM9GSgFuZpMIrZEJhnh7ovdfpOeFv4ezXGly
	jT9zyOAzibjmW8htdEU+/HQBQjqD7ONnQ9zb/3VnilLN3DiiHC6MTnH0CgGLZENmWTK95BY/U8x
	wYM/o1zh+Af1dg6/Hz2mRaTX3Pmd2wcLMTQgXWky9Gbnf2DFSo+PE=
X-Google-Smtp-Source: AGHT+IHGicUegCTS0j1lve8WWgPsMFmdmklG8BUiUH+de+SK5jGi62PS2CVf1dmnAq8lm0/alFZlfw==
X-Received: by 2002:a17:903:9ce:b0:295:9cb5:ae07 with SMTP id d9443c01a7336-2a3ee4b5c00mr7511735ad.38.1767749849522;
        Tue, 06 Jan 2026 17:37:29 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fb64b3esm3291039a91.10.2026.01.06.17.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 17:37:28 -0800 (PST)
Date: Wed, 7 Jan 2026 10:37:24 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A306D100008
X-Stat-Signature: n3qe5ufysoz3kg6s9gm6ic67jkiscfgf
X-Rspam-User: 
X-HE-Tag: 1767749850-379282
X-HE-Meta: U2FsdGVkX1/fcEqnR4JXfbZCiB6kI9jow2TlbMGaNT5SJHYZgWNruOYwtLNZakqL0pN6BJyDnisKm7uwx60ykrwlfbE6yZ0/K8JH4yz3KHldbCG9Vi3jbNtW0WwCviYaZTMSIrPxYfqaOOYSPY3hwWsOk83clXAskqq/TZ9pwB5mFRyljZd4rgNpGd4oAI9iunk+2qHNXffyeb7+R1U0JU/A1QwRfZ9r26YZ1G6sVAH8OS7cpB6fhq2uN3vNHtHFW0X24C19LVbtr20D3PfSXQDQuK9MR5RPa9A6aISYRK+XLbBmLh7q8RuZH25ZgBRLZ6NHS0CbN7yOhkIiX0ilA1+AIqY57boQijsgxzFVeM1rCT7sPmcCVNl9tPEBU7reCX3tEGLR5KN902cpt7pcD0qqZKA02JV1je+TboomA7XA1Qn3HKxSKYOXcXpogoysTCDiF19az7yyamMVVBYk5lsjbb2dPXxARRilrCgCQTeMUAHb1705qymcL74bRp/x5u1EiiIYoQbzIe7zByGrkYihcSrv3popUJMHOkeecdKSpGi9yXKnn/O88zMzjISeXr0s2O3ajlv8I9vhynzWnMurTWGgp5muH+NSef02d8aQy+eQIFZ0nnlWTTyFC89Tq2arJ3aA6DXIggmaEkMJ1uyZe6I0zB3uEC9PbjcRMPENZnjHKTiEGfRRNrRvNIoCgXbxxMMVtPSbCwFqWymyY8gG+E+GJXikPu4zPUox0u4j1KdhAd13KJ1/Evxjjp2Z0dmaRtoHCo8bLv/0LGK7J3gx352T8kqvOXWU/sJwDmxe6jvf+YuSEXAMnEUrGxRTR0DHnUlVt+XZ8vPakBR4N98ebA1COhYF5MW/7yjJFReQh6MJxsyD2KHoNPrmwKXfbG5hwQ0Yw551lS9QRxsF8GnyM1nGqzAPkThye6N7m1uy5gRbv5eqUeKNvwCK0a0kc8Eea9/oNjef7WRFkxk
 zO2OZaQK
 RGgkpLRLBajomUi6N9KxBFjiws6nvhGG54qOv5btkL7jwhRcIGtN5/wJBNs5TacNj2JQs2Uz/i0qdnHmnLHgzatXaRFh6NUTA67xvbfwmJ4mEfKCPJVbL6mcYsChWq/8iUeAEFYBSfFoVazf35kylGITubJLchSyUWR4khqxwO1Gw2E5gJiBDLN/F9Y1ehRQehShR9yNSYYlBme++NI8gBeY5Eszjv2r1ofwlEukGQKljVvU5Rail1DdJzRGe3BTK7RswGxY744n7h+uuXfohiVG/8P5XG7+DCp1cEe4hlqLAneaN3i684tdzPUJA5RrQ25QHfINl2umD+qlIpkt57WtZSuUBSel4s9kvywHDOgb4fRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 09:59), Sergey Senozhatsky wrote:
> On (26/01/07 00:23), Yosry Ahmed wrote:
> > Instead of modifying mem_len, can we modify 'off' like zs_obj_write()
> > and zs_obj_read_end()? I think this can actually be done as a prequel to
> > this patch. Arguably, it makes more sense as we avoid unnecessarily
> > copying the handle (completely untested):
> > 
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 5bf832f9c05c..48c288da43b8 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -1087,6 +1087,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> >         class = zspage_class(pool, zspage);
> >         off = offset_in_page(class->size * obj_idx);
> > 
> > +       if (!ZsHugePage(zspage))
> > +               off += ZS_HANDLE_SIZE;
> > +
> >         if (off + class->size <= PAGE_SIZE) {
> >                 /* this object is contained entirely within a page */
> >                 addr = kmap_local_zpdesc(zpdesc);
> > @@ -1107,9 +1110,6 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> >                                  0, sizes[1]);
> >         }
> > 
> > -       if (!ZsHugePage(zspage))
> > -               addr += ZS_HANDLE_SIZE;
> > -
> >         return addr;
> >  }
> >  EXPORT_SYMBOL_GPL(zs_obj_read_begin);
> > @@ -1129,9 +1129,10 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> >         class = zspage_class(pool, zspage);
> >         off = offset_in_page(class->size * obj_idx);
> > 
> > +       if (!ZsHugePage(zspage))
> > +               off += ZS_HANDLE_SIZE;
> > +
> >         if (off + class->size <= PAGE_SIZE) {
> > -               if (!ZsHugePage(zspage))
> > -                       off += ZS_HANDLE_SIZE;
> >                 handle_mem -= off;
> >                 kunmap_local(handle_mem);
> >         }
> > 
> > ---
> > Does this work?
> 
> Sounds interesting.  Let me try it out.

I recall us having exactly this idea when we first introduced
zs_obj_{read,write}_end() functions, and I do recall that it
did not work.  Somehow this panics in __memcpy+0xc/0x44.  Let
me dig into it again.

