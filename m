Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE3B606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kX3sdO2/
Received: by kanga.kvack.org (Postfix)
	id 5317B6B05B4; Mon, 26 Oct 2026 13:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509146B05B5; Mon, 26 Oct 2026 13:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F906B05B6; Mon, 26 Oct 2026 13:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3E76B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:40:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02C6D1A05EC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:40:04 +0000 (UTC)
X-FDA: 85365490770.30.B44FA68
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1DE5FC0008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:40:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="kX3sdO2/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdZI+A/T6veaOF7Fsd3qi5AF2bBsWKQ3dAj9xuoYJUM=;
	b=JAZWP9SwF9wWbQDU98g0Z7OIaesrUfozl7/0W+z5Qv9u00geg6dDGIfrAVPXqHX68ykWXd
	PyZBsvEKWa83sKOb+D5e63fqfVWpf7FjUdz9RGnSzCEPIXxGyl48x2ld/nrsYyiISeAOWX
	J/w48MIWq5lWhPS0DwtW0GDGfe40aMo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="kX3sdO2/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036403;
	b=tb+fbtGij6nbTZnxN3bRZp0L9MyrizqfQMhNnwFlPL3Cxhw89zi2x2GQRm/AOvUT5sUSp1
	VXTeIH+kN++Jgn94DDFjxVl1sjxuR9aLBcvKtF34W5Q8sR45/nuaRPiySxDgIAuQr97SGB
	L6LsYS+rszU9DzEZSaFaYegoTGSo6So=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b1aa2848d2so5335211a12.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793036401; x=1793641201; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TdZI+A/T6veaOF7Fsd3qi5AF2bBsWKQ3dAj9xuoYJUM=;
        b=kX3sdO2/vkWt12oo2ADVuCJSNQds5D8qXjsL24W094U6sdedbYTcptNRCm6GGgZKEl
         rorZAJeJcf7x+NS/+0Eytq519xDOUzqucODayIuqs2gsfjLUKUwQjESIkNTiQy4Q4Ehd
         U4D/LynyfyFsnZx7fcAC95glaekc7Srid3LOBTzDFgRKPcrDOHZ3D6dEt7J/7aAlbhKL
         SlpFWsW5+F3fI7crRXKS+AMh0DvE+5oBYQNAAtm6VOkiJP5F8mvQgMHpvrOXEnH4XM8x
         7M0hJ0X2fY4E4DfqGWxU0aRGJmEAnaRW4Dgs704+q7ILy9JIW/pmS1914Z+6yF+TOy5x
         zSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793036401; x=1793641201;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TdZI+A/T6veaOF7Fsd3qi5AF2bBsWKQ3dAj9xuoYJUM=;
        b=bNXny/P6ZN/xf1CJ8veYot1IV3WrEo6x70hnwc2+noc8C/BkIwmH8hom7cpWvKQKHe
         GPSOdl3EMunabYe+6QMmLsQ4Tbo3lJIxr/1PAgo+GY5zi++exhK6U7+FPeVLYnAlYagI
         SINL/KzfRFRHIzeL9s5Ff7kJFTLqIBfd0/Ww1984Xe7s7oydctB1q3AV5snHhtYBIyzz
         w2K9yyRprSlfsOdXVguI2ZU2rkp8/eLVeQa8U9RM/Rym6fVlKy3JX0Ro85FKLz0Tn8fM
         kfe2tpyKPVfI867HlKjqLkTYFzwTJtNrftQPNsYrbe6dz+BbBv5mUUPOPQ8u+XYGv2Ui
         eEqw==
X-Forwarded-Encrypted: i=1; AKwUvByWnrpzHLeUValuj4QO2y9Wzgf70OuepULzI84UM+qW52+RnWzxWO+dbCvlVmiizgf4UkIMOokb8Q==@kvack.org
X-Gm-Message-State: AFq9FYIe6rAevd0JiHqu6VpqwaUdtqAJdjyMnG9dYBumnkThvDC+wOH4
	tvCSU2j2C0f15MTqy6k5XcZAGl5L9e+knrahVGxXqbuxCd2YkJpbPZ6N
X-Gm-Gg: AYBFou1RZxRrLOKP7oe0qCoB13xlIf+9cQcYak16TltsjKa3SvqI7QoDDMyW7fpNLhZ
	u71D3mSGDLx8a/95QyqqOh7wTRV7HEG0tCxRogzFjQLM68B7awcIgu3yJs25UXzfPHaNbfNQEeP
	xfVj4tK/P2wRrOpIoL8NcUHSHP7Cy6YsyCYKUdKF+hYH55XKI09flkSYUP8sCvyyKUM4zo7CGIs
	DVK8w7i7ONwhZnWUjh5Rk6hxpSpbGc4IM8n8shb70DJtSzbYsPf8/SbZt4VrqN+aQK4xNs01JGm
	AQCBVWwxqlzHdVKEPq5FWub4Os6S4jLVkGP+tnTB1DA3ysUiYiiFGPs9RYd7YSPtS1L+IuN+mPF
	44caWxBdZFAjKn4q2onSsK+u8WUVx3DPhLy8Ktg2Mc/5RfiWs7BuGZXKTtGfZFPmDkxWI/g+bMH
	99+nQoLNPm63azXWlZPgHsKsI/9adIjkl83ODWyMeVPJrchbjPGWtzXbr/tiIc67XQanO0z/S7p
	Upu73/sEDG2OwAlsE7d
X-Received: by 2002:a17:907:944a:b0:c29:f5d8:9c6b with SMTP id a640c23a62f3a-c46bde4346cmr829233566b.26.1793036401209;
        Mon, 26 Oct 2026 10:40:01 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c49954c8ff1sm101721166b.78.2026.10.26.10.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 10:40:00 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 26 Oct 2026 18:39:58 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <baoquan.he@linux.dev>,
	LKML <linux-kernel@vger.kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm/vmalloc: Bail out if in softirq context
Message-ID: <at-QbgvltXF0pmcd@milan>
References: <20261026102503.30860-1-urezki@gmail.com>
 <20261026090421.e4bd83f3e20fb82852abec4e@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026090421.e4bd83f3e20fb82852abec4e@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1DE5FC0008
X-Stat-Signature: ypx364g6imne3iwgow45zm1e3d5frpwn
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793036402-294745
X-HE-Meta: U2FsdGVkX1+RFMNOqhN4LSdWM2cGhnDzahfSI7cbd/0sNLb8q07iVSFkGmg8wOzjozOhMz9E/oWhVa+DYMqZLN/NFznH8VENHsLkcisUO2iy2O5YbogHQIDq3bVK5Zpu9UvNkm1CFezAPLDIwPZ8vmiurE/al6mLAk7vbYf3jbttSIPGWgLAay/hI++Oteqq2mVuerbZkrmqlC/uEP9aUF26snk2ccearxg3hNByHqu58EHTvo3qaKCkJbJycynhszRysGxMsokt8dT2eu4tgJOp2Z4r8xpiBInyVoYyDkum0U4TRFZx1g1d52iajS1BQ/d09ehO6YLJzAq9GkRjxB7heshpy0sXJJCTJ6ilIYvfBX+z3UXikMKKZKGwntTZ9iNKDsVHt/PhxW6L80c1KitoV7wt9h8whlZasd1iUc3EtFPkniB9U+5/bzMZtL833zk1ru1LNcbeBiRFr3wTEMT20s02ZXMAOuFiOF0dxqYK5X+mMGkuqZb0a5lnjwKGS1XVpdF3d/0JwTS2J/UgmC8Pi0+FA1MF3FOLMvrieyJKfw+QMc0Cc3nCXU9iyc8Ht+sOeAGZ4OE2z3bDPE6PAM1WnsZpWQVnosv8lWL1yAE4QjIX+sQYNu94r3l8BYryM7rPDDxd45d3ZuBon76N+Qq+2CiGM6q4mIQSIl6xqGIshIXaWVReova7P5O/t0JDFx2GEIrog3c69x09z2169PLZEKdG0FJXIT1KnZTRNU4NfQXtqKii8EJ6D2vWHYtq9XMAUHWkQQwen0J17cRjNKCURWSB9V0uDZ/HXPu4yKfXhKLJEajEPTiFblee5eJ6hmqGmN+hkHJ1AhOBFOkUyM5phTZYBzxXIlj46JE81Nj3wAG5Tsk6UfG+mlw7jzXGuL6M4CSJVaIPcUm8C7XrpCL8oTbVgtdGaXU+8807WCO+aW6OpPNk+6lIfhwaIyEmzFOP/EmAjBQNjrir4wx
 xMpTDyoL
 f5r6J5RZeEj6ZJ/yy1nkqNMkiHh8GjWRcKVhX4NEiqEiv5PHb2Pczu8B53w+p5CDWl2ufh/7nBrqSAp5+iIOOr0RaFS3bIaQnaj5p9gd81XHDc+u3ViOQ5yQKfexwRmhjpeCZAeG9hhVIWf/A5eJW4R+58SJ2iii9z+6J26l7uwp7y+HaH7PN+rdz3vWoQYNRWxdLaonbQlu+B/Ub/K6DhhKvRLyO4FeMOUZ91x3m56JmDtK/ZU7Ll/uuiFftDqubHESCtDKa8Jq7kB72nWE5tDFFpkYHSUgO7r3SuAUlaqSItNcrWz3TPqs7IYWfD/npSBwCCtPtTsujYf8yE1qrVIZEBKtwpKSpNYXrWMCx3HlSAjJgt2GZOhZ6CIRABKptj/IyMZLx7NQPDCIL8uBunI+M/zli3cZE8Mu46HyFdunp9TMiwnpkyC3N3IHlRlb2dHPWjriQ2mrHQhWqMkSFA8rtjA4zBNUi3ymVyLriEHlj9kk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 09:04:21AM -0700, Andrew Morton wrote:
> On Mon, 26 Oct 2026 11:25:03 +0100 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > vmalloc() is not allowed to be invoked from the NMI,
> > hard-irq and softirq contexts because doing so may
> > deadlock on internal locks.
> > 
> > Commit 04aa71da5f35 ("mm/vmalloc: do not trigger BUG()
> > on BH disabled context") replaced the deprecated in_interrupt()
> > macro with explicit in_nmi() and in_hardirq() checks, but
> > unintentionally dropped the softirq context check.
> > 
> > Example:
> > 
> > <snip>
> > vzalloc() in a task
> >  spin_lock(&vn->busy.lock)
> >   <------ Hard irq
> >    irq_exit()
> >     process softirq on the same CPU
> >      vmalloc()
> >       spin_lock(&vn->busy.lock)
> >        spins forever
> > <snip>
> > 
> > Restore the check by checking the caller's context with
> > the in_serving_softirq() helper. Note that, it is still
> > allowed to invoke vmalloc() with disabled bottom halves.
> > 
> > Replace BUG_ON() with WARN_ON_ONCE() for in_nmi() and
> > in_hardirq() case.
> > 
> > Cc: David Hildenbrand (Arm) <david@kernel.org>
> > Fixes: 04aa71da5f35 ("mm/vmalloc: do not trigger BUG() on BH disabled context")
> 
> Sounds like a cc:stable is needed?
> 
Yes. Should i resend and put cc:stable?

> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > ---
> >  mm/vmalloc.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 7521b9b3bfd2..36e6e3be6ba4 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3252,7 +3252,13 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
> >  	struct vm_struct *area;
> >  	unsigned long requested_size = size;
> >  
> > -	BUG_ON(in_nmi() || in_hardirq());
> > +	/* IRQ re-entrancy -> irq_exit() -> process softirq. */
> > +	if (in_serving_softirq())
> > +		return NULL;
> > +
> > +	if (WARN_ON_ONCE(in_nmi() || in_hardirq()))
> > +		return NULL;
> 
> WARN does a lot of stuff and I rather doubt that it's all nmi-safe.  I
> don't think this matters much - it'll probably work out and as long as
> *something* gets printed, it did its job.
> 
Yep. I checked before the kernel sources and saw that people use it
with WARN. I thought switching from BUG() to WARN() is better.

--
Uladzislau Rezki

