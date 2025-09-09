Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 063C1CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526658E0012; Tue,  9 Sep 2025 11:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD3B8E0003; Tue,  9 Sep 2025 11:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F15D8E0012; Tue,  9 Sep 2025 11:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28B468E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:02:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE779BA386
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:02:11 +0000 (UTC)
X-FDA: 83870027262.08.29CE913
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5EDC9100027
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:02:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=IyTyO4Ax;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757430129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yh0fjNDYqjzdJxYcthmflSzVU8lAPQ437Tv8jqJmBNM=;
	b=VuORPQFc9L6VHNEQPPYBaxK+L0K5x0axaE5hrmZiXNTrntl5/WlsKbechdC7vnr94R4w/L
	mEn0MqGW31Cz2kdipuXGy9t6Kjvc7a6TLMGNApioWTju0lh8MjWrPy/oF1KtrqoT4kzVAS
	vLPzegmWZ43qD8n8NCUrOPGgTphlv+0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=IyTyO4Ax;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757430129; a=rsa-sha256;
	cv=none;
	b=TQOWQehx9VLLprAub2WcS7Fdu56wsMnoFiDHFpJEY4+okcw6+JFu7ZZIsmQxFcjmV6qApf
	Fmv7V98LJSt0lhz3wK/ummvWr0d2JXYrPDZRb6uQrS4bftSIxaQdLR8KNlGRETy66yYTg8
	2gZ7eq9AI48zzqQegIo6zXkGfEzX9N0=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-726dec342bbso52663446d6.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757430128; x=1758034928; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yh0fjNDYqjzdJxYcthmflSzVU8lAPQ437Tv8jqJmBNM=;
        b=IyTyO4AxZcy2OlkOPT6Amgiq3WOpQ0WfhXNF3fwsVqhE74TBMqGx5ZlPJYAq2o+Bgt
         JNipymOuJIZEWNZAB7HMhNiP0WVsPtogxnGBjAReLbg1GzPaTn+uametJ63GPoZUDWZR
         ylOiVfVx5wBdExBL2FTQXtHbUcgjQT63DbicOpBY9TwVhcjOAwcaOJwD3AnBZSZqMLCp
         K8IjJIG+aaL7sQQ+mqhtLnD6IqcRdYntY3w4giJSdujTDEbA1Ut1xY0xsN4Gz0P8FM9O
         8o01vofGnb3MTYlm24VONy3/0b4OPSE7nEAXjq8yytlEeNatwHR5J1qXulyIyUnhXm2F
         +9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757430128; x=1758034928;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yh0fjNDYqjzdJxYcthmflSzVU8lAPQ437Tv8jqJmBNM=;
        b=fQV1i22yyVMypXpKD9lSbXDwBdUIQerwKLrnl1zSUcT0c1TiVLErrJw6oeFviMuuu9
         Ij3SUn+hWgg42vg2btDcjN3J2h+x1zubizW+DwLe1WYL9F8sN8ha7waEGJalvS4fz8uD
         /H44gq22dyC/Ikt9FC3ByGaJ+9MaC+wMvHj2GOf6K9RC67GxK10OkZZVYbGq7qhB51xK
         5v227IqTt2/aTZxT/3PyECYJzJRQc7ymkas5aX5Xjpu/7RwsCJifWySTYFOlMYHc6Z5Z
         wPohLuKc1lJ5YxN1RVOq8nd308is4ly/8mOpOc92zssybppTjDTSe7c8BpKodkn2L1FA
         JFOA==
X-Forwarded-Encrypted: i=1; AJvYcCVgAU/dBMSZFn1EZh4vZJAMlHX6O0vUWcW3W858SPdXmNi7fw+P8waMONS+UV5mtzwzrTwK6/8H5w==@kvack.org
X-Gm-Message-State: AOJu0YyFt0hxoYUbLVdj1BMUYOk0tWqeqBW/6kwEnIhsAnG3bUDNboAb
	Nm+M1H38NvhG+K/AAVCbs4KSVdDb+6nAWmlNVTZ3igdU16ah/XavleYe6S7qBrO3SRw=
X-Gm-Gg: ASbGncsR7zyqekZVIghG32a/lOWaWknlAdgi6x2nVA9TL1RECPsc8zWhi9yFAc8gAZU
	++WV3fNHkhotOJm5EkU2s6hIAtgbmPTcshHNXagy4ZLO6GTU2CgEdnl+Wp72zUSmO9immMo/mM0
	oyQqcXUNSczAPwiK4H9cg7f+K2cyx4ZfVAxbdXDpgtayajBKIIUBltKZkJKCzpCLx7hEweZSFoA
	sQRPADrNkY41lsmWBwZzgYsa50knaogZtEkQqPSjW0qDOizzVioic3nMt/awhjppZCY6CqJOuIe
	A/UrHjT0C01M+N+tJXluEfFyXZB+kjd2uVU7NzfKD1gZR26fQ/EI0vpQ9itzLuOaAboKUI4PM7A
	kdg==
X-Google-Smtp-Source: AGHT+IFOGeEWrEyaAhZ9HLZ8ljGlKxieYtI7L7qfboXpXt08DoBi9j/dcjK8l0X0zckOHyw5S1Wt3g==
X-Received: by 2002:ad4:5aa7:0:b0:729:4be4:7fdb with SMTP id 6a1803df08f44-739435d4633mr118482876d6.52.1757430127822;
        Tue, 09 Sep 2025 08:02:07 -0700 (PDT)
Received: from localhost ([2620:10d:c091:600::1ad8])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-727b2c047dcsm112542926d6.59.2025.09.09.08.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:02:06 -0700 (PDT)
Date: Tue, 9 Sep 2025 16:01:56 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: zswap: interact directly with zsmalloc
Message-ID: <20250909150156.GB1474@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-2-hannes@cmpxchg.org>
 <r3dzlbqyvhaho5zuac7eba6pxz47zy3cz4lopxza3ls3ibadlh@6evm5aryyuxp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r3dzlbqyvhaho5zuac7eba6pxz47zy3cz4lopxza3ls3ibadlh@6evm5aryyuxp>
X-Rspamd-Queue-Id: 5EDC9100027
X-Rspamd-Server: rspam05
X-Stat-Signature: zp96gukhydoi41znntzhwwbs4sq6ix4n
X-Rspam-User: 
X-HE-Tag: 1757430129-292794
X-HE-Meta: U2FsdGVkX18CoSdKzcpJEzl8iQFc0TvV+pscOb49bNcPrWiCJSxq3chDkRcJCaRh7ePjdBAPt1jOlatfUfFVoXR2hsQKoSSThAVxogFd4Ku5MebsM+Qlj+V79+ycVbTgT3HCuIVI0p8WvceOBqm5od2R+NLwTjq/p6cKM4IcbVLPP5pxzGg3ocbjJ+bYks/GyBfUPDq+L5n0t7Yi+CrOEWloNj4/MexShFg4j0p6JLQ2a/Vrkji6rF19TFIKtvihzA1C8c2mgmov5FcFea4P3kjpE2me++gI96NTzmwOUTz61wqtKT4v08Twt1qnSMZFSARkRLyls6f1niXx+Z4M6UqiFprzXdG+pfP7GpdNCe/1/83BMuttsZtT6XxMjdhziirtCCtl8VT4oEuXMSt+HOK236qzz8b1HwSmeUl2TLL/O5Qa5q9g85vdlYoM6Ym374Ps/9Ok3NMnSJToSxeiiGCRkMh+4vtbQwxFlJV6JbgQUyTNLU/hN2KJB8r4EdBLsAJjLdg+MTBjeRsRuGuhwMkGHmvL160g2YwC97s0hDTnxWeqfRuEYeoOZHHJwHkrQSIyToR8yjBO8s1aaTGxuM1WS/N29qbNggRRDwEEZ8ji0E3JIu0B2kZbUyXrPTSQEkd0RyOS5hLsVOifxitx1UxPazCsnpw9eCx1XzO6FEh5nGH/bZgY1wPcXAU6jLB4t2+iaBpeEYscGa3Jslzej3hBPI+M9iufJ0J40ROZ3q+rPoOV2rLH/Ys2BXFkD3xnXISC4OgxbZJz4lD4Bb2FBMaAE0MwMo1kx1ME+ThufWLdowy5Dv9CkUjFZQn2DWJe3tzGobWEjHoipQDJATdbC5t+IwpfWT6YbkSe/21zib1qUiNTTvEGqlQxTB47GULyx5POyLGWqCBXFj/XT/0KjBw2Ny3zVQNpFKkytnGJ9CAVmeqxxcCfkJK6udUA4r0+08ttKLEBP+Kp5IRDpbW
 zEpqwbmL
 8De1w6XWxr+4ZDZYkcg4gQCbZIgyihjp+1P1/Inwc7JL3DFukLAy9+e7gqcCUElineOharTJ9CrIelBm452yPSJMKmS7SE9K+ljg4PeUXUNDKIXVbFnEUTT1csrWJrCpIgnfL2Ij/pYG+aLIuDuw41HsZVYlc4srIG3dozctLyQzXpDYfYIH6ZLT7OmCb/FbfCW67vH2/HRU6CIPhsk3GHJGm0b9bnEK6+mEpJXieazfhZ3wbmsxwLq+mDTZtjb6SqifPXIMzLb5Odk2tiPbfbWunjGqVCI0yy+E7GhtzOcg6iGw46HYiK2OJcHig8cPiYEpqlayITi75u/3mU0IBgPV2XZ/HahaWmrSJOMMbp9e5/OkXH4YYZOWnrvQmtZShr1eePUDJ2CvquozcikhZpDcqMVUg3Rn8SCmC7+lDwol+BHp/ILYlVWmlP2DeEy1bCpew0vOz4oeq8E6rPcJ47Vtj3ub0AzavMQ2qLA02y2uJObIqqd1VDRpgMu7SMZmUq67gaSo+0YW71Hc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 06:53:15PM +0000, Yosry Ahmed wrote:
> On Fri, Aug 29, 2025 at 05:15:26PM +0100, Johannes Weiner wrote:
> > zswap goes through the zpool layer to enable runtime-switching of
> > allocator backends for compressed data. However, since zbud and z3fold
> > were removed in 6.15, zsmalloc has been the only option available.
> > 
> > As such, the zpool indirection is unnecessary. Make zswap deal with
> > zsmalloc directly. This is comparable to zram, which also directly
> > interacts with zsmalloc and has never supported a different backend.
> > 
> > Note that this does not preclude future improvements and experiments
> > with different allocation strategies. Should it become necessary, it's
> > possible to provide an alternate implementation for the zsmalloc API,
> > selectable at compile time. However, zsmalloc is also rather mature
> > and feature rich, with years of widespread production exposure; it's
> > encouraged to make incremental improvements rather than fork it.
> > 
> > In any case, the complexity of runtime pluggability seems excessive
> > and unjustified at this time. Switch zswap to zsmalloc to remove the
> > last user of the zpool API.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> [..]
> > @@ -315,52 +292,29 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
> >  error:
> >  	if (pool->acomp_ctx)
> >  		free_percpu(pool->acomp_ctx);
> > -	if (pool->zpool)
> > -		zpool_destroy_pool(pool->zpool);
> > +	if (pool->zs_pool)
> > +		zs_destroy_pool(pool->zs_pool);
> >  	kfree(pool);
> >  	return NULL;
> >  }
> >  
> >  static struct zswap_pool *__zswap_pool_create_fallback(void)
> >  {
> > -	bool has_comp, has_zpool;
> > -
> > -	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > -	if (!has_comp && strcmp(zswap_compressor,
> > -				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> > +	if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
> > +	    strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> >  		pr_err("compressor %s not available, using default %s\n",
> >  		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
> >  		param_free_charp(&zswap_compressor);
> >  		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> > -		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > -	}
> > -	if (!has_comp) {
> > -		pr_err("default compressor %s not available\n",
> > -		       zswap_compressor);
> > -		param_free_charp(&zswap_compressor);
> > -		zswap_compressor = ZSWAP_PARAM_UNSET;
> > -	}
> > -
> > -	has_zpool = zpool_has_pool(zswap_zpool_type);
> > -	if (!has_zpool && strcmp(zswap_zpool_type,
> > -				 CONFIG_ZSWAP_ZPOOL_DEFAULT)) {
> > -		pr_err("zpool %s not available, using default %s\n",
> > -		       zswap_zpool_type, CONFIG_ZSWAP_ZPOOL_DEFAULT);
> > -		param_free_charp(&zswap_zpool_type);
> > -		zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
> > -		has_zpool = zpool_has_pool(zswap_zpool_type);
> > -	}
> > -	if (!has_zpool) {
> > -		pr_err("default zpool %s not available\n",
> > -		       zswap_zpool_type);
> > -		param_free_charp(&zswap_zpool_type);
> > -		zswap_zpool_type = ZSWAP_PARAM_UNSET;
> > +		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
> > +			pr_err("default compressor %s not available\n",
> > +			       zswap_compressor);
> > +			zswap_compressor = ZSWAP_PARAM_UNSET;
> > +			return NULL;
> > +		}
> 
> Hmm it seems like there may be a change of behavior here. If
> zswap_compressor == CONFIG_ZSWAP_COMPRESSOR_DEFAULT at the beginning and
> crypto_has_acomp() returns false, the old code will go into the second
> if (!has_comp) block, printing an error, freeing the string, and setting
> zswap_compressor to ZSWAP_PARAM_UNSET, then we eventually return NULL.
> 
> It seems like the new code will just call zswap_pool_create() anyway.
> 
> Am I missing something here?

I don't think that scenario is possible, due to the way the Kconfig
works. Whatever backend I select for CONFIG_ZSWAP_COMPRESSOR_DEFAULT
pulls in the crypto module as built-in/=y. It should always be there.

