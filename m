Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1016BC98303
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9B06B0005; Fri, 16 Jan 2026 21:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467996B0088; Fri, 16 Jan 2026 21:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349386B0089; Fri, 16 Jan 2026 21:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22B396B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:40:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E083B7F9C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:40:01 +0000 (UTC)
X-FDA: 84339901002.05.32A2EF3
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id B261C40003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:39:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CvSPXQaM;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768617599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiwGrsxjbifbnJtJ/0cc2n6hqCX2ehd2olkJ6gGBbRw=;
	b=ssbQM8dYoHzvXhtZg3E/wl4Km0CDwP+qhr3YWdqLIteHZgD8QCcUGDcM2PzLATB8JdKV6m
	h+0FUlVoBxJxY0UTvd9wy47Yb1rSFNNmJJ5bn+f+lQQLD8/s59r1FUYBI8vgPozCK+Li3k
	J3cAddB7Rhs/9q+wvy5W4N2C0nSk3HU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CvSPXQaM;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768617599; a=rsa-sha256;
	cv=none;
	b=M76bR4kpzFwvIelTIziwgSFNUZYGRdDF3WuIRYZcESwV82rU293Ow1pEpHFFv7/GF+/ca9
	zbVBNhn5uu7+fbcawDP+Pz/RBMXbGoU6BM5dZxWGVxRygl92yHTNTf8qYoRAZJN/MlHBya
	sjXiKPgX+1CGBuajEHap6VKDVBw1NTk=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a0bb2f093aso16400325ad.3
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768617598; x=1769222398; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xiwGrsxjbifbnJtJ/0cc2n6hqCX2ehd2olkJ6gGBbRw=;
        b=CvSPXQaMCGA3VBltHvSmtZBhQ0JjE12WdP/rvHqrG69DShnOZq3Q+nMTpnxM5lnHKl
         bbqGduCiTMcAbR496C3cYbuwD18Vd3cZj3qQZGTvdJx+9TIT4XZMyvmxRKzFbGedKqCu
         04eS8qe4mm0PX1fuA9zuJSqei1syH9wWZsB3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768617598; x=1769222398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xiwGrsxjbifbnJtJ/0cc2n6hqCX2ehd2olkJ6gGBbRw=;
        b=wTJ2nvPYDw59UKzyKtHnhZHuhpu3R9qJi3dnALXXiCLsgQQdmX/ODsJ2oesiqHkctx
         pUZW0ZwGmJ+mZN5zZnrfmpTx2rymKTJtq4OQelAQL0nq89GpnQUPJE112MC6MRCBcvyH
         Gx70RFxJvtFRRZNVkXbA8SBNqtiiSMbyaYlQuOEh0whB9C2dsNzsvmaYVIzKqLBSFwiI
         Ha+L6Ah0LjJ/2YZlhOTSDiVk+hacMGpXFTgUOhV2Kdpg5cs2en2Saywn7HvtZfZrernN
         U+km3gQ45Ejg2kk+ADoz6hCd7vuOd+wCFRns/ou2w4+4KbVEYJ/FUh80+M+jTvw5WQX+
         viPA==
X-Forwarded-Encrypted: i=1; AJvYcCWRLQD3wVr6Zq1JqlSHdeuyDtMRqSuIZKuDbCaAdPlYnBjrF07pISN2KJ23A+6jPCGdnhnGe+m9Xw==@kvack.org
X-Gm-Message-State: AOJu0YzWooNo5xiSh35P86lGxjPPuK0k571ar+xKWQ6dTu5dkjMdsXiK
	guFmYjwHL7pa20wurYekL1KQXTYtXXF2akljBjVeHdQhWhFNi25xVWVUoKIizFqUkw==
X-Gm-Gg: AY/fxX4/0t5y47jIy9wG6oc05hx7P/jHwzKXgv0TdLnCaUObfmKR29mmcWyHEmzKVkv
	q1jlAhsV1ajWy39ktgvGoZIIhonRWYsCXeruvOoQ60g4wr0QndkVd3/lw8nPwvaIq+bmxi8eLuz
	LbM32vMpsq0JDVpQDLpLeEZb3tcYAX3rsBXuyDHIkYpAlE8kmsD205Pbxy4Hh3EowrESxbuk/9W
	5nTEnN4VWZfszOKvOv9VEvGX2SOk0uQz02ogkoZ7xaYlZJHbhZyB5LY64Sn1N7fRGVS+t1gcBAL
	g0HGjVE2DjOQNkRGb7FIj+3XleIJPHSwuYItNf33Kj5KnnEo/JDKHI6X4IC4hUIuPTG9acVnY2B
	lcGwrTZRumB0Y3GVwQfDTWtJZCrn8IA6Q6x+yQo4FHscYhaw07nl2CMWS/QtEjQTpx3wiSVdTJw
	haHukTyp/yJy0M+j0I5pbjb8+UGbu1AKT5INeu/i0kL5Av6yvQ1nU=
X-Received: by 2002:a17:902:e949:b0:299:e031:173 with SMTP id d9443c01a7336-2a7175a639amr46914495ad.35.1768617598537;
        Fri, 16 Jan 2026 18:39:58 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:fb0f:ccef:d815:5581])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190c9bdesm32266705ad.24.2026.01.16.18.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 18:39:57 -0800 (PST)
Date: Sat, 17 Jan 2026 11:39:52 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] zsmalloc: introduce SG-list based object read API
Message-ID: <nj73lvrjul6h7p7qx2t2pqt3zmcrn3zwdvb7ri7rgzfntjzv3t@nghi7tgq5zvn>
References: <20260113034645.2729998-1-senozhatsky@chromium.org>
 <wb2shm35vigisxnokcp3pw3yzu32kezo3ox2v3xu2u5lnxo45n@ktccxxzg2vsc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wb2shm35vigisxnokcp3pw3yzu32kezo3ox2v3xu2u5lnxo45n@ktccxxzg2vsc>
X-Stat-Signature: rxgdpaofc63bz56jgdrk68f1q8i8n5jr
X-Rspamd-Queue-Id: B261C40003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768617599-222978
X-HE-Meta: U2FsdGVkX1/VsEWo/tZI7b7p8CBJkpFXvjrgHs5VY8oOrzPFeZGUIhBioN9FGSCNoJI25YtYd0glusqgMZauoD+joQNFunfk/3B9zUTuWvr2Z6nZEHaqJfi0SaxKC+asNqgig9ZdRpgsegBuNdBZ/IhpcbBOyEAQm9Fa5UJeg2W980AaMCcO3eZaW9rNxWrGtexC+p8BjimYS8iWcS/8qt5sBiS7qb7ojQjkT6OYKIwIk8fSHlkBVOyDugBfpL/ObtrHlu43CYH9R40ap470gJRrYbLbBNXgkpoFsrhIFEra7Dq5IrzMekSKL/HvVvuW79rJYCsJOssAe4M+EyBLQYePMUMMl1NJ2P957ZTLsx+5NAcwnnjGIgo81MBhMyr1/x//lnFzL82j4bYXTHRCSN+xiC5vlTgaUEFUfD5E63c/UZnT0AAcMEBok37zrpPIkeZKRYEIW9yLzhN6F/rjtCZ0NVFKDK0r2Q+tbk+GO44xEOB7f+OFefPk8Hv7BwRcve84u0jhZ0znrt+WIpgpTc9ybQ5yq+kRuGHy0Eg46lSoEIDGADxjf/dOUXr5QFBGZL1OeGGSotU4gYwYYjJSvkcCksDvxfBjuzvk/Tg3UvLSy9fMibmKqrDebm9lZEELhXy5bBHsPL33GqxRAuqEDky+5iKaFfcVcQk+WWFb303f+QJqj11vp7ashgDTtUUZOdjy4J2XMNxxV0i7O3hUd/X1GfJLhI6hIItRRe5WyyR/yOcC7orRKhp6P8eUijZNmBgSrEicW9+S0tssvUp0M5fOYa+kL1R2BRcPwq6EkW9Ho3JAR1u9ziBbdTO0I5uM+c7gJu0FRfQaQrzu5NUxoMERinPnc/kfRmdA/eJ1EEeXAH++QOTRjZqptObPNrAuaYyMkC8hR1U25jEMRkURy4o+QaKLJF/uGVIwc2r+VzjbNT89Enf+MSZPE4PRewbL1agMGsWXM/nVC3CoF1t
 eAjABHmw
 kRnO8Sbmo3t/XkLrwL43e3AYHn0YIM0f3jyWJEqaM8riUVZUxBVXTA0mQyuwk54MGX6qsPgjWUbMwvFKSXsPrHvdzLOwuVRcV8h0Bf0xN3KTlULZznmnBTJk0SMym05SyPOxSjDRm07/uWxsiIO1tbDOGg8O0xLrx9tHEpuAJitMbQ+nCyAIBAZkhmH56/JGdSrZMzwVwYVtP+Bt22ZGJe31cC8b12gdH7+tG+Z2J4MRXgktsVhuEls7MtFIwn0MxyYCIF3SpM1+W3SeIoo+h2e+aKXt76Dgfz5U2gwUVX456FRhPQ5b+YUvd6GHSrh9lgawCWdFJd/tNtC7t+X/xX+3QVzgj9B8y6vI1Wzg9K9sHzkzWCFy1F94+F0SiyO5JdUY6WQmu4aCO+xPFmkyfeg0eMXxzo+yIcYq/D2oH5qWeVn4ekBYLEay0nC8KA8I4w1Ox
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/16 19:53), Yosry Ahmed wrote:
[..]
> >  struct zs_pool *zs_create_pool(const char *name);
> >  void zs_destroy_pool(struct zs_pool *pool);
> > @@ -43,6 +44,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> >  			size_t mem_len, void *local_copy);
> >  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> >  		     size_t mem_len, void *handle_mem);
> > +int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
> 
> void? The return value is always 0.

I thought about returning sg_nents().  Probably can be just void after all.

> There is a lot of duplication between this and zs_obj_read_begin(). I
> wanted to create a common helper for them both that returns the zpdesc
> and offset, but we cannot do the same on the read end side as the unlock
> needs to happen after kunmap() in zs_obj_read_end().
> 
> Putting parts of this code in helpers makes it a bit obscure due to the
> locking rules :/
> 
> I wonder if we can drop zs_obj_read_*() and move the spanning logic into
> zram. Looking at zram code, seems like read_from_zspool_raw() and
> read_incompressible_page() just copy the return address, so I think they
> can trivially move to using the SG list helpers and
> memcpy_from_sglist().
> 
> The only non-trivial caller is read_compressed_page(), because it passes
> the compressed object to zcomp. So I think we only need to handle the
> linearization there, something like this (completely untested):

So I was thinking about leaving things as they currently are for this
dev cycle, because both zram and zsmalloc have enough of new code queued
up.  If you don't mind let's remove memcpy() API and convert zram during
next cycle (after the upcoming merge window).

