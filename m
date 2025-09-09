Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BD9CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8028E0008; Tue,  9 Sep 2025 11:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77E38E0003; Tue,  9 Sep 2025 11:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E128E0008; Tue,  9 Sep 2025 11:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84FFB8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:16:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 337BD1DEEA6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:16:45 +0000 (UTC)
X-FDA: 83870063970.12.2507C54
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2795D2001A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:16:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=wbI8sUM3;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757431003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMVyNEMIYzhPHpvXp6Ti45drIfjgHT9dEeCQ/o4OoQk=;
	b=ETTsX/Xw+XqKz+1Dyrk0pOUogitsSEWrhQnhn55xvIojgoBNkgsqPZeNCSa7ctVkmcnzdl
	3OKOVDLZSskTPxcTjdXcOFT3GpmpQv5JFisFTqx5axYq4swagNzhyOx2P3LG4GN+/PROCy
	P+sKoA5oWaK04fc8qHgDt2LRQMKm87s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757431003; a=rsa-sha256;
	cv=none;
	b=FOuNH5nAvde65XXh8hbI1i07I5mbHYZXt6hG7jPy5laV8nmxUNl6vIVmTs4I9Dd1IaBWoH
	IJHbcJ+Ky5fPjGmsvXE0AWAzQBqX7/vVA5YbbVJ0Zeemd8J3I4N8S7Q3s/TcYrvpyu5a9p
	5pFEQVtzGbl0HNboozlWpXoSKQ7VYJU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=wbI8sUM3;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b61161c35cso30941531cf.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757431002; x=1758035802; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UMVyNEMIYzhPHpvXp6Ti45drIfjgHT9dEeCQ/o4OoQk=;
        b=wbI8sUM3ltnq2uP9MwUHNMEGf2TAaqv1ro+hb8AXiZI5xt/3vJpApQTb5000dIEs3Q
         j+6SeLKTPx6UvNn6KiM2u6XoI9FJH0xzxXDaWTLEj/kKotTobpbzTOWuoSRA4LZHaswN
         y7q40XpH0B6Ah5PNuC/q/gwRGztU0cJA+EzUWiZq9ShrnersZmKMBChaBU7R6rzIzggv
         5vw/jyWNeuFmdokRzNOx5pCLH+POHifvZ6CG0Sm8T6lS6opSq82o6R6HrvKilm0achL6
         OlaZjjp4iXacq0jatd51RubnsX+kPotqPGjtzJWZ6swNT63xnTzNPWogm71ZvYGkgZ4w
         mGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431002; x=1758035802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UMVyNEMIYzhPHpvXp6Ti45drIfjgHT9dEeCQ/o4OoQk=;
        b=vZ3BQiGMO40l8kXGRZH2v+pcA/UdzPWxqGmfubCB1wbX070KKYjRHSbGyQ/3boPz9T
         za8hzXqn4LzGiL4KDXbUKsgWgAnqrOgK4lg8ucccHw0SILRtizPUYClcpNZaN0AGTDIR
         Uul9iW1FQ2tqaMtdUA4deuu/XQX9bSyTTYi0A46gtclfGJLIgdyMhhc9oDHzzvYZPMA5
         SW9LMc7egg+TN34/ZWl4NiWACNGsTx2m+N/pbJra3otMa4LG2kxy5/eQVB1dx6GpusUV
         0PRsybFJlQ1kVX1kkSSAMLrV9nxOTW6UBXSoY+9g0WWuwOj8gXezL/AEYHD1VE2MGF/k
         sMDw==
X-Forwarded-Encrypted: i=1; AJvYcCU3tmjInAw++N5Jh/zPa42jcZ+tyFSgLgcY9tlJvpD4uI3mxy1W5BXBrUkrC9cGGsCLS6xYW1pihA==@kvack.org
X-Gm-Message-State: AOJu0YxufUkfwInu31x6GnNXuiosGD8JgOHDKXHFanCkTvvWte72tCxB
	vKbOeQzndGjiVk7+hclxjIYtjBSNmLBSiCk793z8TnXnlemQ/b+BmKy5pcYXVHgRLFs=
X-Gm-Gg: ASbGncvGPyDYT7SMETMWxnBI7jPtBVP5gpeX9uZ7P4dj51CaqmyDGdEk22FdvPi/ZXK
	MR8bbAYXBG6BmL9OA5EdPb0PzN4C64M1ygG4KDhCqZ00OiphBo3FZ2/h0+rQwN4RFWgC4bkrLhk
	P2hTQ/wl/cHJTFNyiujqQ+5N9TX4Ul6VOR8sLZlj+QM+YtP2gT0EHE1wm3ivAqX+MyYZfvbuVyi
	YRi6zXdu1hwukY7uzZSmhSjhi8WcH0fnTaiYJn49evcknLTUFTv4uLuqf1pbMcSlwtHlUf86MOr
	A1rHq4crsrfdP/y4rfZ/p4fceSMkpVwez4kywwe2Y/Fvuw3NLH/bttcSv8OZTd9fxcGyEp9mb0n
	7yw==
X-Google-Smtp-Source: AGHT+IGY+axgPh1+a9hEq+zwI22+ok64znOXyEBd1T6ryY/GteQhW2JlKsyq2rpVFX4c62eRhoaYbg==
X-Received: by 2002:a05:622a:252:b0:4b3:8d4d:bfc0 with SMTP id d75a77b69052e-4b5f83b0d83mr141400851cf.22.1757431001762;
        Tue, 09 Sep 2025 08:16:41 -0700 (PDT)
Received: from localhost ([2620:10d:c091:600::fa4a])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-81b58d496d6sm134210385a.11.2025.09.09.08.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:16:40 -0700 (PDT)
Date: Tue, 9 Sep 2025 16:16:39 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: remove unused zpool layer
Message-ID: <20250909151639.GF1474@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-3-hannes@cmpxchg.org>
 <rcxmemdxbxuvtag2qv4sjxoh7ho4z3bz3od6i76rc5yholx2rc@vncn6iuuee7b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rcxmemdxbxuvtag2qv4sjxoh7ho4z3bz3od6i76rc5yholx2rc@vncn6iuuee7b>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2795D2001A
X-Stat-Signature: xp1p53gy5j8f6r8dc4dswdmtcgffj6zd
X-Rspam-User: 
X-HE-Tag: 1757431002-43249
X-HE-Meta: U2FsdGVkX19CukwuRWHzsGeTp7Di9ingiKIFdT/o2FDCtxGUpWwEKhx7Q7+iFkJeNfQI0sfDmI3f3nIZUeK2Mu1aT3Cw494wcjN2M2Or4u5cAtcQCvHr1+ECYzZZN8NOwzxggx5z3q4bTatF4/dwMxsUeobBgs2hXtHP/5xf0B1mgK1BxIzRlVK8ap9xiMnCzBvCnRbsj53MkgTTOR+CPxVWvvjqqGXIPgEsAxrK8WtTlRgSig+PS9s5S6kC//ZSCeRk9bavSSnU/N4kxJivY5EryF2xuOoiV29Qy9bpn2tyLrx6RE3hbmMtSo3HhOSBTZbOIQ/nOoZSrUlZGVFL57/thyn+rT95xhEFkJrvTvhQ1CbFT2f0rjI1m2XQcXDm3i2/8U5+Juuwlj7isHVYp/dFql2iE00gnXz99gPxagjH6Rt7QwEpT0TJfBQDoqUobgBzHqzozqkMmxa7xkFv1zJA68O7p2xsBeUKzChwYsh0X4vJ4UNVx8TKsYnLkvUorZk6jq54dCr60Q4EsOsuBZb2Qnwo7RHmkI9BJWZV+XgNzW7OnYPHLzqFFZ4MH3IYdcWqywy2tufA9A+5Lenw/Y/k/sioEJC0MoXgbsQN7JWSaB9DeraN7xF/ZY4/NkQqfkBhPrJgnlGU3ztsicaA0Nyp5SxvDjIiCYBBPlPhZZSXut0enWzKj+CzXs2V9NXdux0RizkcYT5ddxmkpk9eadjmZxqFH2ZNU+HsEsHW6LSz1+loUt0DqiZEjam5gLRnR+MgQUHVB9RYKWPUSfCwXMY3nO8f9MYrR7iuRBHdoXgPE5thMLZRi8tKbxN8QwDchWpGEs5w2tyRv1AOELYDs5C01c3j1LHYG1jROzQEp28gf7wQ/13M4MBBsedBkLgtDTF4jyjJ3tudqmUh1DE4nIKcq6Sk3EO81sOrWNsTCQSjrXJ0KoB6JH70wy2fTvgAGvxXN5prTAke6j/ONnR
 bsvyrYu3
 fIQwzucwfI0nOr6bnhnDa8aqKSpHZ+sKM4FC6HVSUroAVorKAIkGGJtONDnYTEZ5h/yfCZYfViq19Aul6SlmsCMZWpS58RufDPZAoiTYZesHfXB8p8YYE7Tt8kteAP81C/ztjtcw/FkHYoONgFF6YPXk2aFzXd0jGaxUCaDfjBe6QEcv31pFOsXi2h1fQ8TKc3BqmGMaKuVt4Jz1JiLTy3fjh99N28vD22Wr3THtQM3YiOtsKxqrRYw/h2UddLFw54gOkupSa4Qliy7XOBt1HiJoo7vg7QzMqVnTigDrjUxUJcyfNHr+ujVu3n7FDl0vK5AbClkdz0ONQYw3hwmx3tsUnuI0L4rSlKVG4m9yjb2zdTHJBVMZ5agYAm1qFRX97Lo2GCIBOeD9ONAJfmJSJjmQ7G4cXw7TKGDmgRO/X0YFgDpSwHx/qxiouXgmBZ1IvG7SbIA9faFVhW/4Uw4ZAz85w20Mlzjzo0GJGQTNBkRmzXV9pPwhvgQxCGIwzxsSK/+62veN9VQmH4u8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 06:58:47PM +0000, Yosry Ahmed wrote:
> On Fri, Aug 29, 2025 at 05:15:27PM +0100, Johannes Weiner wrote:
> > With zswap using zsmalloc directly, there are no more in-tree users of
> > this code. Remove it.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> [..]
> > @@ -125,45 +122,18 @@ config ZSWAP_COMPRESSOR_DEFAULT
> >         default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
> >         default ""
> >  
> > -choice
> > -	prompt "Default allocator"
> > -	depends on ZSWAP
> > -	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
> > -	help
> > -	  Selects the default allocator for the compressed cache for
> > -	  swap pages.
> > -	  The default is 'zbud' for compatibility, however please do
> > -	  read the description of each of the allocators below before
> > -	  making a right choice.
> > -
> > -	  The selection made here can be overridden by using the kernel
> > -	  command line 'zswap.zpool=' option.
> > +config ZSMALLOC
> > +	tristate
> >  
> > -config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> > -	bool "zsmalloc"
> > -	select ZSMALLOC
> > -	help
> > -	  Use the zsmalloc allocator as the default allocator.
> > -endchoice
> > +if ZSMALLOC
> >  
> > -config ZSWAP_ZPOOL_DEFAULT
> > -       string
> > -       depends on ZSWAP
> > -       default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> > -       default ""
> > +menu "Zsmalloc allocator options"
> > +	depends on ZSMALLOC
> >  
> > -config ZSMALLOC
> > -	tristate
> > -	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
> > -	depends on MMU
> > -	help
> > -	  zsmalloc is a slab-based memory allocator designed to store
> > -	  pages of various compression levels efficiently. It achieves
> > -	  the highest storage density with the least amount of fragmentation.
> 
> Why remove the prompt and help text here?

We shouldn't ask users unnecessary questions. Zswap and zram are the
user-visible kernel options; if one of them is selected, they should
just quietly pull in the zsmalloc code.

