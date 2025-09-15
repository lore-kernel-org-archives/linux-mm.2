Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B4CCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB968E0011; Mon, 15 Sep 2025 11:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACB18E0001; Mon, 15 Sep 2025 11:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68A78E0011; Mon, 15 Sep 2025 11:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD99E8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:36:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FBE21A0204
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:36:48 +0000 (UTC)
X-FDA: 83891887296.27.1329C58
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7901B14000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:36:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=FQCr6WJ+;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757950606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0q1aTmJzhVKCzLEtotPA3ZHCkECo3p9tyTLfevkeiSY=;
	b=zY+8f5NsOcOTgdfGTqhO3peHqdzPo66n7idtV4xIEOX9H6SrLonbI8C1eH+2jc4K2titjX
	6FR8i6xcwH8AQhIAiuLge/jK9UBVmfUUMfw8/GZSJZjOlxkOGLpTpd01xZq+bo5/p1SOzJ
	oy5h4B71rwgXVxADDcj+y2xdfEPqooE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=FQCr6WJ+;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757950606; a=rsa-sha256;
	cv=none;
	b=4Lk4tCeERFA1QiChuuLp0VfqgX1bke7GwjcQjxLMfFuob20KVl7sKFKnqYQBCo5EHrLujE
	VZQS7wsZD6etkhCf4B5PG/Ruvg9e41D1rCjAiQ0cKrmCZfBVlgHYu2wDAy/DDhwpIEpEhv
	SGABtlxqMZyvVttezvkNKB9JP9uAmsg=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-828d8d06630so168074785a.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757950605; x=1758555405; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0q1aTmJzhVKCzLEtotPA3ZHCkECo3p9tyTLfevkeiSY=;
        b=FQCr6WJ+E3xXpoeAFY3iDfVezoUKdcfTuBEI613aNLXF97PKFY6YFKGHgM3c3P3dUg
         FWy9V8fXGkvKq3EA2DpreZjAbFz+NJ502LmErzbvJ9LACC33Tj1DjHseGi47qU5U4o7F
         YlZM8hZsD7CH07HWlOUtRqfvNy5WQQrhNuvRppVvtsDd9gI3sm6Oe7ztFhi8pyTtdjVi
         oIf2IO2qr6No/7xC0PjMhtaLhkm0QgO42m+txzRypG6ALI6jPpj48+lS/qDNMKr4lR3v
         1CC9tHVS6uPhX0sEAWyceWmjdFm6b4+nXf5xD89BG2kT4ukEWrFAINrbS8Cz6FRVLsy6
         vh7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757950605; x=1758555405;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0q1aTmJzhVKCzLEtotPA3ZHCkECo3p9tyTLfevkeiSY=;
        b=CZENGYf0opf01nFzZi5LgtLM3fVVwcJCQqgQhz7Alz4iszC+dMbwRUOCMbNJluBEuv
         eRYEY9jUFjZFKnXRujuJ5gyfAA1UtBNZ1Q2Qaqds1o/bCtyxHPjdP9jFnUyfpan2tW2M
         Ya1HX66FmWo5quhZbWNA8WWuVqegH8Tw8D1r8v4Hy6beQxdZ1xEkC+1g4ZzBRcOaKsO9
         G9UZ89LzpP7dpPFDvMycTVd/ckAmerQdb3UKfulvmpIckEZjIxP2wdAmkBRWPzAW9dNB
         htKwkj8eKjX9X+qMpVi5Fuis2gcsmy1LwAV9YiDt2TBpOqGoWGd5iz7oOzWwZE6Weg5e
         AwJw==
X-Forwarded-Encrypted: i=1; AJvYcCWDUkWqmj4jTNoXmlyoNCqHwNJxBGc1cJiOEzF12H+s47UUBbcbOKyNmLslF97khubIPss281wVSw==@kvack.org
X-Gm-Message-State: AOJu0YzpvBsGxUDZe0f9okWbUO6nfA3qf+1tuqJ07C+BpUU5h9Dc7sVn
	BDiCE/HheLnxt7SKdWURCfSlPecOeRehB3nMy4qUU8J09pUgl49cpdcHmykP4nYowvs=
X-Gm-Gg: ASbGncu5MXQgr2TBf2kW6vMjP1rBxqc4wY43pk4bR/0Hu22FD3kXFCl4GllB9smjnTZ
	R5KRenc+uaYgmAGl4JJSLqSRg7RWs/C2tYMrbSuvmwkLGZivCyo09+vjDY4HmBI8DGZbJqdI7HY
	KYeicJVprtvh2b+EJfOZRkAggz3mKjdCasXfHJTn+ddt7o7DeW936qLgyKOR5A0TRY0YZwW9KPE
	T71+xUmRbec0Zdq/zNzPefAHtol0PulYnMu1HzLeHJc3xo4qW84lEImWor3rOO9mA+E/Q8Y7F/L
	rTGm9rVyUhBUIebv84K+WapkvUib3ITFvoCfx59t1II+Bm+yMNOKjpPxTWUcORnltNkqk4D4xbU
	udOU88cOlXfvKMALM4P9E7ZGs4zPW0Ys4EJISSwMogzI=
X-Google-Smtp-Source: AGHT+IFW9KnCKRb5PDF5V208B6P3t0e7Q6CTOoRS/R//UBWQOsBJCExtXlGpi3IUSyGz8irfB7JJTg==
X-Received: by 2002:a05:620a:6f0d:b0:82b:269a:f201 with SMTP id af79cd13be357-82b269af209mr72205685a.10.1757950604983;
        Mon, 15 Sep 2025 08:36:44 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-8290e22eef4sm294192285a.49.2025.09.15.08.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 08:36:44 -0700 (PDT)
Date: Mon, 15 Sep 2025 11:36:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: zswap: interact directly with zsmalloc
Message-ID: <20250915153640.GA828739@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-2-hannes@cmpxchg.org>
 <r3dzlbqyvhaho5zuac7eba6pxz47zy3cz4lopxza3ls3ibadlh@6evm5aryyuxp>
 <20250909150156.GB1474@cmpxchg.org>
 <46xtfjznexpdlemxjwykin5k74oqomedb2fyli5jrb4xnquuke@ztcmxhmhlkx7>
 <20250910134240.GA1111@cmpxchg.org>
 <f5hn4awbmkelckl6khlaosw3tbfrwzvf5l7kn6mnqpbastsdnh@77mqvfjzyfys>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5hn4awbmkelckl6khlaosw3tbfrwzvf5l7kn6mnqpbastsdnh@77mqvfjzyfys>
X-Stat-Signature: 3fdzt7uciown19xruhfa3fuycojfe9rn
X-Rspam-User: 
X-Rspamd-Queue-Id: 7901B14000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1757950606-874028
X-HE-Meta: U2FsdGVkX185w91AQleeoNybKflREqjbjH/aCciWcCwMgN+sx0SPsVw6nbMGyFGvxwVShcT738uikby99aJ3/CvCAY0ebzZOqNlEUwrujEp7nesWS9PojEVTu09EQTm3QF4w1PsxJUtrIpriamEkH7uAArswfQO5gmR5xrJWJhAMNEZ4+U1+DOgeoVKBnoggmEP/1d0zia9LQRhzgYLYMrrIPUrsHxKdFCuxkhJ5+T1sw6FcpqBG3yu6pPfUXjuOiuTjbI93L6xQUPe1xl0YGLLoG76FLfFB2HTw33BiCQ38A9vm+DXbYNQMjx3XtpJKH1yiwZGueq4fSwK9TwAHUxT9gyDjGSyzg/J3YPS6aeFNELAYosQPCpf2pZDUFsisNf2Own9+q5wgwTTdj35oKclEPynxYdtL+KuoFAWoEqhZeRY5N+EIX6iSD0N9Er6ygKF9NAjumoblavPhCg/U9cdJI4hllAqonANZojnY98U/TI5hhzum0MwmfTXCVLuKU/2mCXHwonGbRXa3SKPxCSQAAkw7aWqNjlwC+L7Mv3UtxfaUE53/uSpLXowAwa/HN6VHYFA1o72cBKWE+JQmUj5zrwYcYtmyrJKX5dX3DdwSR4CQhCP44RPFlDLwGtiPA+GVe1Qhv/cSOUnywNM7VnnwANuYoJuvpaRlJ6MD5073o/NYJo3aj2C6c2gjxcV2X09cLebVxSugenSSSo41WOiDloNwCPQCViSneXJyvcPDvQuNNF27+B8VFLxOqmnm1ceEEYK/9DUzz/2BBL6A9a4alw8yNLgyZV5tlANnsisYGiuMr2v1HBZcVByIMGaDATk6EQ29WMrQfsc2TR/qRn8QrfLF1BD0Po2zhyN02CdOuLVp4YPhSVUDLcV+HwFEXLttrlmX+yujyhZEhBJ7TOZZUMcLuDDQZf1ulsDM6JgOirWr10MiHicAQ2WLkkXgxTP7UdFkGh2x9N+JMKy
 sDzzRhwX
 f05gerQWXaXu54CNqt3BJtnzzexYBbg01/2qOO3u98q4Rjvz9Lf0QCws/Hbhwf2wqmjGX3pnt15HRd0IthPk/ljCZCTVJMEpIYG97clDRBeaLAdyuaw/5tQhDiVA8yfd+FtqDSjQsATTCZ1+T16TM1x1C/BVLPSausJ9IfusGcxMLzPKS2ZTeevi37vyi1L8ztYCEvXHCIKa57kzRjhcIV1QiAVNR3aFOuo73wHuAtvie4472hlTZeWyLl3cB8to89BJ/ybdievitm0cbIEd+MDMEVJ+98lDA7dhquIEFWLxNzAd5TL8wH3jQUaX4VmdtFgTDtJDXkbQ8gU9W9qKd529/3UkqYNWia79PU2Ebw10tcv1afE7AokdOtVjK5Bm0F44LIyEu2cdm98GHTDM6jdMC8QrGgxRixh5PX0/BaZYnr0aiM1s6tnFehKTbslBuKP+7BZgIfMU810PB91b13UJ+tUQ+QUZZwq+IHfwyCwnL87Tj5wINHwqSClwrC/fG5HE/ksuFnDTZnaA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 02:30:31PM +0000, Yosry Ahmed wrote:
> On Wed, Sep 10, 2025 at 09:42:40AM -0400, Johannes Weiner wrote:
> > @@ -314,6 +314,10 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
> >  		}
> >  	}
> >  
> > +	/* Kconfig bug? */
> > +	if (WARN_ON(!crypto_has_acomp(zswap_compressor, 0, 0)))
> > +		return NULL;
> > +
> >  	return zswap_pool_create(zswap_compressor);
> >  }
> 
> Sure, looks good, although I think it's clearer (and smaller diff) to
> preserve the old structure instead, up to you:
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c88ad61b232cf..bbfc087792648 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -300,18 +300,21 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
> 
>  static struct zswap_pool *__zswap_pool_create_fallback(void)
>  {
> -       if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
> +       bool has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> +
> +       if (!has_comp &&
>             strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
>                 pr_err("compressor %s not available, using default %s\n",
>                        zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
>                 param_free_charp(&zswap_compressor);
>                 zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> -               if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
> -                       pr_err("default compressor %s not available\n",
> -                              zswap_compressor);
> -                       zswap_compressor = ZSWAP_PARAM_UNSET;
> -                       return NULL;
> -               }
> +               has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> +       }
> +       if (!has_comp) {
> +               pr_err("default compressor %s not available\n",
> +                      zswap_compressor);
> +               zswap_compressor = ZSWAP_PARAM_UNSET;
> +               return NULL;
>         }

No objection to moving the branch instead of adding another one. I'd
just like to retain the warning, since it shouldn't happen. And ditch
the bool, IMO it pointlessly splits the test from the consequences.

If you're fine with this Yosry, Andrew can you please fold it?

---

From b8fa4c7edd4f3c84853665b47acec8cebb4f4899 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 15 Sep 2025 10:56:15 -0400
Subject: [PATCH] mm: zswap: interact directly with zsmalloc fix

Yosry points out that the default compressor check only applies when
something else is configured and we fall back, but not if it was
configured out of the box but isn't available. Move the test. Kconfig
should not permit this, so replace the pr_err() with a WARN.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zswap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cba7077fda40..c1af782e54ec 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -309,12 +309,12 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
 		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
 		param_free_charp(&zswap_compressor);
 		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
-		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
-			pr_err("default compressor %s not available\n",
-			       zswap_compressor);
-			zswap_compressor = ZSWAP_PARAM_UNSET;
-			return NULL;
-		}
+	}
+
+	/* Default compressor should be available. Kconfig bug? */
+	if (WARN_ON_ONCE(!crypto_has_acomp(zswap_compressor, 0, 0))) {
+		zswap_compressor = ZSWAP_PARAM_UNSET;
+		return NULL;
 	}
 
 	return zswap_pool_create(zswap_compressor);
-- 
2.51.0


