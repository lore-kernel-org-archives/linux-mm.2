Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D94ECA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49748E0016; Wed, 10 Sep 2025 09:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21548E0012; Wed, 10 Sep 2025 09:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10208E0016; Wed, 10 Sep 2025 09:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCD68E0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:42:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3546EC0941
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:42:53 +0000 (UTC)
X-FDA: 83873456226.11.1C93077
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id D3C881C000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:42:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=wqChtXwu;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3qjo4wmUBfQicHBvmITf72ixUInKSEILfcLkw3UTyM=;
	b=aqpjc9iUsCVy+0sGGOQZ6uqZWO9xOldDgQEM6qIw5g3BVu5aXWJGQqqj/13LsiCmCEpBGs
	8Bt8q+/Dse1T754Me8GbqUYr87I9e5KVOpetz0J+MnGg3JQgqb9S/o1tfL1HuGVX/h1aqC
	ZcuIv4GF6Hwg+OP4LnyqYFLIbrIodfg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=wqChtXwu;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511771; a=rsa-sha256;
	cv=none;
	b=BCWx3Cq+F6Bodw8dJyoAPryHW017ch2JKYQS19rAPB02zar8nt2PLX3SPODEemJCc52RYv
	QtEjVlCVFkg7kGIwgUNao7AHcX8O2znYoGXWkxXy3jSVx+4IeQJN/rvHVTLa/913EjZccE
	Qyj8i8FyZx+I7SM3nz3AWYyzeFdlXEI=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-754f16d8feaso11597696d6.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757511770; x=1758116570; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s3qjo4wmUBfQicHBvmITf72ixUInKSEILfcLkw3UTyM=;
        b=wqChtXwu+gm1KRpXOOoxdCTFZ4iabmaWJtCOo3xHizvmbgspAHvM0hnCcJCoAeUVPe
         qsUzZC6/98L6gBAKK+Ord92zBH6APn7YC9QObQ60HW6x/HhZGvfjHDM0gTbeSiH+wj8T
         4JLkQgObsieP0lra3FZmWSpUjZV4xKmAV2Bcd3XijKjOMXrIe2xulsRNEAjFvonX08OL
         DWf0LbsfdJeHMR1OYuO8IpQDDoz3jcRr+NRaqAWlntoQIqZ+IXX4kiOhWQHpuXHmdgie
         GD9XvoRI1wt2j7vMl1eaxXlsdu58+5H40Y992fzynZBX6QkDkMc1Ibd/rec69n1pNejZ
         nLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757511770; x=1758116570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3qjo4wmUBfQicHBvmITf72ixUInKSEILfcLkw3UTyM=;
        b=bgBy4sgObKQnb0WzrWB8I+pKdy6JzPLTElkLyra0NFfzZwcJoaFxOF1dzQdBf4GBvy
         wo6EzLlZegrtwYdL1q+nskLF+xjOJAbpOkQIPb4K8rE5J+vZmB7h4Sx5kDvNMGgimPdP
         n1yfafmc5FOMJE7RdbZBB7Y43U7L1AsPSgvhjiwUSpTcCCq2MYnxHQnRFbqBzHsDseJf
         7uXz/t1oBryeoXpKU6cjqjFGe6nF8/EdWVttpD0i60riJkmPRwtNvOo1hHaXGNWw0wFF
         PdmyPjIYD5Zqhukk01PWNOVTZUYGY5b1uHlAmACA/E64w/1P0SVB1YWarlGpsOjn+hF3
         RDTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0ye/LGpPPV1OG8Y0AhPLY7BYxB8mIPuyMMAxVqgsappBzvEh257YdY0dbaxf+xPgONSYSQ1/Xtw==@kvack.org
X-Gm-Message-State: AOJu0Yxq+OE+4u0OTBLAZGMmyJc2vTr6qWHoR3++onttyXnzNa3tgTnm
	u9vVtmi4pXk+Kb7kwE9Q93RyJ/T1BDRuHT3WMZ7B3fkzU6tJr0q6VjEqs59d5QwOl9w=
X-Gm-Gg: ASbGncuegY+xgayL/XfQuxVYotbUAlgBQTUuBHGkBKDLFTzfyPH15myle04Y/Y6/jpb
	hmVpoEHB9+SHQSWOiXNHcXyXOHPHITFG2iiVPLwAcIR/dNs4KBpA1bp87+gFiyO6g8B0x+bQWGj
	+z5E1lYxaMAuN5ZXcgzMi7FENOO9LQ3W511nN28dCqqPNpERl+HsIKG2/qQfctkBAE3cVrYqxwE
	rKKV8B5/hmGAtM0l4B3ucHH2oy7Rm0oSMCmXkrZSaCC17lVdv0acf3KqOX7hamGqoOaWg/jv3j/
	2mY8HdJPpFSpLSTUHmgQIcPsRknG3eENkvxv/OV6yI8j13OHOSQoWBKyacCoxAavyr1jX47CXTi
	iMA==
X-Google-Smtp-Source: AGHT+IEAT3o5C7Gf7qk35CltddL2BbFIvyxesOkWR7+WzvDnJ4VN07flllbdjhyr6rnI0d2t9+30Xw==
X-Received: by 2002:a05:6214:2aac:b0:70d:f64e:d496 with SMTP id 6a1803df08f44-73921b39bffmr163174036d6.2.1757511769681;
        Wed, 10 Sep 2025 06:42:49 -0700 (PDT)
Received: from localhost ([2620:10d:c091:600::6ffa])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-72bc240dc3esm109663606d6.24.2025.09.10.06.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 06:42:49 -0700 (PDT)
Date: Wed, 10 Sep 2025 09:42:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: zswap: interact directly with zsmalloc
Message-ID: <20250910134240.GA1111@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-2-hannes@cmpxchg.org>
 <r3dzlbqyvhaho5zuac7eba6pxz47zy3cz4lopxza3ls3ibadlh@6evm5aryyuxp>
 <20250909150156.GB1474@cmpxchg.org>
 <46xtfjznexpdlemxjwykin5k74oqomedb2fyli5jrb4xnquuke@ztcmxhmhlkx7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46xtfjznexpdlemxjwykin5k74oqomedb2fyli5jrb4xnquuke@ztcmxhmhlkx7>
X-Rspamd-Queue-Id: D3C881C000D
X-Stat-Signature: rpa1qzexmrrizyz59e45pxwq56gecp85
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757511770-152218
X-HE-Meta: U2FsdGVkX1//D9fETYgoo4D7ppAMfKdQ3wbVOnZ99MWO5ndTnpM+3RtlUvgDAbtPUr1ouh8/CH92kOgaxZTZDRGCwmruqWqh+z2mtqWYcZDfu1fOoGD7GJO3pt1DxA+gr5zKmbxWJ84qcsmH+Sxc1tNhKFztBi8wzIN+sCfEZzV1YALuGQeoGr5DOCu2M5Sh+dOlB78TsCtG1ua+0JqEx6JVNgpVZGv+Jq4xOqu6PzsnGlaD5Vkt2cff1OCNgfsCNRpZRHeg70HeWtmyy66YMVJwhbaShY8PfdyWvuayJOn8sF4H7STkX3Gs8kPWY4DXy/Ty8Gf2Gs1gdQjkFOrXl4740FNuAOqroOMIRkceNRKuMW6TYBzq1nNC4FG4YT0k/r6yfnPnu4vilkoFBcLFg5G9k7EsxZOb0n92Stvx57M4D9wmiVqa/+VSK4r+kIRE99kfR4puVELCJ3bsPb6nlw5kCqaV/JWo6fFm53MzqC+KnDWk8db4kAA4osphpvuAP6U2UXAUosjzST7ivRAk9bb4y427tyLC4fKQ2X8EV2fo2ekbYPcBxYN9unkbWVABnpGW4Xmz0O9gghBuugl+cPhPfLrz4ibh34C5a6RSAmOEXIgYqzTnNTObgqEdRuCSsSDgz6vCH6qWZbDAzJ6XxxnsFMIs7idvdU924yn69Ly/3OT/GK7I2ouHusMtaML3e+y1O/zx9gruNfvJ5GVOacf91sEohEqwf0cD7/h2YEdh3YcHPK0ZjU1pXHb3jPzL3nhyDrFUEaRPh/8AX4GfJ3oEMBgVYvsOjJqInBA3kj4b8q3q4axdNVDsbZCK5r0IKokb8KquenMC7/rZUoTfzTRARza7T/i6raX7LmutaMSsLUUYI2asQlT22pTfr5B2kQX6IUJUWhD4sYqq4zFXie80dZ3kkSVaRn6Bt6meJa9mxL+3onHDMB8UlnfgBSMiNdfoOsyg6UZxGL8Tmym
 MbugHXH6
 OYpaDSmGtFp1VCdtiWBO2jqLCpwE4C325BN8+elTLzQskPCD1oXnAIL2zSYoIs4Bo1Sv3OERIViUxcSIny5WixqiA+YX8wA7Jb9HS5XYsuy0gL1L9iHG/5SjxYzAJ3iSc4Avs63X14mu+QiEzU3n022dXmgymqevA8M0FHnJjkhK0lY6KIYE5ffx0eDlicyosEVwegc3HWN/f7mJFmOlVLw3MALXLixC4RRRItG6iaNSpY/6283VhqRGP81DsNT6s5aaJs6Ba6XmEf5Jk44/cmxJFaMkMlXdn6w/l5CeFBvpdqvDtpo7Fn84SMplmaNR37Oz+KUjDy9P90++RATOPwrHZu2offAUSRNrVT/bXlSXsDSd40X4+NhYRTEqQh5PV37xZAxT5MKEkBm2pz9cR6JiqIO0bNScHfXU1QuK+zdbumqRdcIsb1yQwFer03UswMn+wMLeNHiRLgkTtoqo4OWFomF88xX8qA+VWazTzz1Qraw3WtwqBIe6ye9z1t4yQgz2gAhsOsiPGBwU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 08:10:43PM +0000, Yosry Ahmed wrote:
> On Tue, Sep 09, 2025 at 04:01:56PM +0100, Johannes Weiner wrote:
> > On Fri, Sep 05, 2025 at 06:53:15PM +0000, Yosry Ahmed wrote:
> > > On Fri, Aug 29, 2025 at 05:15:26PM +0100, Johannes Weiner wrote:
> > > > zswap goes through the zpool layer to enable runtime-switching of
> > > > allocator backends for compressed data. However, since zbud and z3fold
> > > > were removed in 6.15, zsmalloc has been the only option available.
> > > > 
> > > > As such, the zpool indirection is unnecessary. Make zswap deal with
> > > > zsmalloc directly. This is comparable to zram, which also directly
> > > > interacts with zsmalloc and has never supported a different backend.
> > > > 
> > > > Note that this does not preclude future improvements and experiments
> > > > with different allocation strategies. Should it become necessary, it's
> > > > possible to provide an alternate implementation for the zsmalloc API,
> > > > selectable at compile time. However, zsmalloc is also rather mature
> > > > and feature rich, with years of widespread production exposure; it's
> > > > encouraged to make incremental improvements rather than fork it.
> > > > 
> > > > In any case, the complexity of runtime pluggability seems excessive
> > > > and unjustified at this time. Switch zswap to zsmalloc to remove the
> > > > last user of the zpool API.
> > > > 
> > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > ---
> > > [..]
> > > > @@ -315,52 +292,29 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
> > > >  error:
> > > >  	if (pool->acomp_ctx)
> > > >  		free_percpu(pool->acomp_ctx);
> > > > -	if (pool->zpool)
> > > > -		zpool_destroy_pool(pool->zpool);
> > > > +	if (pool->zs_pool)
> > > > +		zs_destroy_pool(pool->zs_pool);
> > > >  	kfree(pool);
> > > >  	return NULL;
> > > >  }
> > > >  
> > > >  static struct zswap_pool *__zswap_pool_create_fallback(void)
> > > >  {
> > > > -	bool has_comp, has_zpool;
> > > > -
> > > > -	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > > > -	if (!has_comp && strcmp(zswap_compressor,
> > > > -				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> > > > +	if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
> > > > +	    strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
> > > >  		pr_err("compressor %s not available, using default %s\n",
> > > >  		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
> > > >  		param_free_charp(&zswap_compressor);
> > > >  		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> > > > -		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
> > > > -	}
> > > > -	if (!has_comp) {
> > > > -		pr_err("default compressor %s not available\n",
> > > > -		       zswap_compressor);
> > > > -		param_free_charp(&zswap_compressor);
> > > > -		zswap_compressor = ZSWAP_PARAM_UNSET;
> > > > -	}
> > > > -
> > > > -	has_zpool = zpool_has_pool(zswap_zpool_type);
> > > > -	if (!has_zpool && strcmp(zswap_zpool_type,
> > > > -				 CONFIG_ZSWAP_ZPOOL_DEFAULT)) {
> > > > -		pr_err("zpool %s not available, using default %s\n",
> > > > -		       zswap_zpool_type, CONFIG_ZSWAP_ZPOOL_DEFAULT);
> > > > -		param_free_charp(&zswap_zpool_type);
> > > > -		zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
> > > > -		has_zpool = zpool_has_pool(zswap_zpool_type);
> > > > -	}
> > > > -	if (!has_zpool) {
> > > > -		pr_err("default zpool %s not available\n",
> > > > -		       zswap_zpool_type);
> > > > -		param_free_charp(&zswap_zpool_type);
> > > > -		zswap_zpool_type = ZSWAP_PARAM_UNSET;
> > > > +		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
> > > > +			pr_err("default compressor %s not available\n",
> > > > +			       zswap_compressor);
> > > > +			zswap_compressor = ZSWAP_PARAM_UNSET;
> > > > +			return NULL;
> > > > +		}
> > > 
> > > Hmm it seems like there may be a change of behavior here. If
> > > zswap_compressor == CONFIG_ZSWAP_COMPRESSOR_DEFAULT at the beginning and
> > > crypto_has_acomp() returns false, the old code will go into the second
> > > if (!has_comp) block, printing an error, freeing the string, and setting
> > > zswap_compressor to ZSWAP_PARAM_UNSET, then we eventually return NULL.
> > > 
> > > It seems like the new code will just call zswap_pool_create() anyway.
> > > 
> > > Am I missing something here?
> > 
> > I don't think that scenario is possible, due to the way the Kconfig
> > works. Whatever backend I select for CONFIG_ZSWAP_COMPRESSOR_DEFAULT
> > pulls in the crypto module as built-in/=y. It should always be there.
> 
> What if none of the CONFIG_ZSWAP_COMPRESSOR_DEFAULT_* options are
> selected (i.e. empty string)? Also, can CONFIG_ZSWAP_COMPRESSOR_DEFAULT
> be set directly to an arbitrary string?

No, that isn't possible. It's a multiple choice symbol that forces one
of the options and has a valid default value. I tried to made it an
empty string in .config by hand, but oldconfig restored it; if I
remove the DEFAULT_* line entirely, oldconfig reprompts.

> I would prefer if the code behavior did not change to rely on the config
> possibilities.

How about this on top?

From f842e1338594c4b78456f878731a261a074d5277 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 10 Sep 2025 09:00:01 -0400
Subject: [PATCH] yosry

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zswap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index c88ad61b232c..991fe380c61e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -314,6 +314,10 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
 		}
 	}
 
+	/* Kconfig bug? */
+	if (WARN_ON(!crypto_has_acomp(zswap_compressor, 0, 0)))
+		return NULL;
+
 	return zswap_pool_create(zswap_compressor);
 }
 
-- 
2.51.0


