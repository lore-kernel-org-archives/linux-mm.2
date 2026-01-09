Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0823D167E7
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450E56B0088; Fri,  9 Jan 2026 04:31:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF3F6B0089; Fri,  9 Jan 2026 04:31:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E01F6B008A; Fri,  9 Jan 2026 04:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCDB6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:31:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A09B6140364
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:31:27 +0000 (UTC)
X-FDA: 84311907414.16.D03FFCD
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6A5F160003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:31:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pVsu4ZXK;
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767951085; a=rsa-sha256;
	cv=none;
	b=Afvkepe/NQ5eiCNzEAApYFtuvqROAwdpdf9Zu496FxpB3Nu8RxfVbEQ/hALiXfMlecNDrU
	HVNkGlQPtJEdPWFN5l+Yo1Vmi7F11xrdTjzkras6Se6IvVuAq8tE9fD2e/hlIQOSvroBBD
	lEnL98rPOraWgx9pHv/p4tYzK+rU0Fk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pVsu4ZXK;
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767951085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHnWhSbgGLtJHz6aBPfGHzXRQNyBXUT1iG+fdLJ00Bc=;
	b=UWx9a5MOnSSNW2YLPDIc4YnAWZjnDqC+hYY99YZhcIcp13BQK3bAqYzXCgQ0DOAwaf2cL3
	X4yI8Kn+s5BY4/Pnvhi4gJdRRcFKzFA94n6MrTvAP9vMpzY9izfNm3+td+FaUNEmHW6A12
	j93bf4+7EYScruC4e7VcACR3B1aqb3k=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4eda26a04bfso46593651cf.2
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 01:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767951085; x=1768555885; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mHnWhSbgGLtJHz6aBPfGHzXRQNyBXUT1iG+fdLJ00Bc=;
        b=pVsu4ZXK+31GwPS9IXo02VLP83efdHvZyXsNgkcqP4VGH6c3RdTmo5Rl06iueAFIfs
         wTA65J0dlE+mdmUmIOHBEV3hgIvdSJrDaUGDvT09eCW57YjtdjiUKEUiDrZhOdYocIiq
         5Pqv+1sbfTn8kQDol8gQo7yBIp9VD1Qjkan3S9ZT+iiB2NtlET81GnrUwyPJVns+X/xD
         k1EHNru7VUSQ4i2HC62LGu62vdmeFdB6y0SG+qHtB9F9LzKYuzrS2RcDPiD2gj3fj/rf
         UQFaf7hCaCY8xllIEaTvNLoIjSLODoRD6WkxEm47/FuzOHX/1IdEqn4WW2jCE9amU5F4
         QNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767951085; x=1768555885;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mHnWhSbgGLtJHz6aBPfGHzXRQNyBXUT1iG+fdLJ00Bc=;
        b=DTmg+uCll4WDXr1aL5U+eutqeh/Beqx3RVEhVpSwyFFMvQdPdnFUTUE5vDs6GvIM+r
         JtTN68WkKt4NSIuWwqfD+vTfYrddP/yWUubiQ4fAibmvjYKXUd+f8jy3x2NxyGW5khas
         fe+HVYasa6C/Aaw0cOZEnPVHpX23naLlMk8/8f2FvggaOQeKj96k31SwT1NLLcDBzGgQ
         lGJXx8KnjKZwU6Za1qEoboCV0KMA+SP5s+eCIllilHeuXiYyrdgaCzv4BRMNExMRGnpK
         drJt6K43v7Yy4kNNbpbkFP8Nd1t/b0UI5Licklw1LN94UPadDiprKQ1QgO87m+PY9qHT
         SEFA==
X-Forwarded-Encrypted: i=1; AJvYcCU7QxpQ6XxdxIkHQJMYV25YPwjFe8xtrOCLA810uXHUvg6j0qhSE5u7afhJRNfYdTqlt1FKtv118w==@kvack.org
X-Gm-Message-State: AOJu0Yyi9ywgFrtFxoIQVEOC4Tfcf2zDgmO5oFsE4C3kzJblKLv+jmKx
	zCcaN3pgeN0Pr8UklLPCV6tIjUnuuhhktEBGuH2T53hBzlq5x1C+QRUGdQP/auEAJEpsBCtr+9O
	l42WasEgxRwNDNYN1RdcLIYviMMULcA0eCcTdlNN+
X-Gm-Gg: AY/fxX7R9JuqXDJYhls4s8NaAi8NkIRT4/VhwRg5FIs1A0qgDtxbCPTun8szX9HD3mA
	QMMnZWwr7hFEwfl0bVYkVy3UvRXyVSdD1/dH2Rvz7qEaWLAVLxgXNqjZh+HNyDuGcesqU3D3dhD
	71SlxJTkJ46oDXrcWI0cZBTO9zMcBYL4Qmxmd2Lfz0y6q+jBBJPZYMGvDbNYWNl8DC8Fy5X1rYe
	IqlrR14GQg97W9wh/rrzSYF7IDQFHqR2ZWIEde3+9/fEdeHXTUaCOVm+IbFalzS7B+Vr0U=
X-Google-Smtp-Source: AGHT+IFuFRZsFV/d44doIWgLvsMS/CZDqe4Cye+eagGw1hb+ysMh9BDNkivJ6fQHv4v5oqRYdhbNmI5coNvj7Pn6Sz0=
X-Received: by 2002:a05:6214:485:b0:888:8088:209e with SMTP id
 6a1803df08f44-890841a3ab6mr123084486d6.16.1767951084728; Fri, 09 Jan 2026
 01:31:24 -0800 (PST)
MIME-Version: 1.0
References: <20260105080230.13171-1-harry.yoo@oracle.com> <20260105080230.13171-2-harry.yoo@oracle.com>
 <CAG_fn=XCx9-uYOhRQXTde7ud=H9kwM_Sf3ZjHQd9hfYDspzeOA@mail.gmail.com> <aWBfZ4ga9HQ8L8KM@hyeyoo>
In-Reply-To: <aWBfZ4ga9HQ8L8KM@hyeyoo>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 9 Jan 2026 10:30:47 +0100
X-Gm-Features: AZwV_Qj86V__IEzdz2ouZQE2ozn-rnAWTPpJPtDCUGLbUdOgH8MfcTAHgVsMofI
Message-ID: <CAG_fn=Wyw-fGGQ802A1cUpkHHTnZi5gN7wZzRaF1s31SPOpC9g@mail.gmail.com>
Subject: Re: [PATCH V5 1/8] mm/slab: use unsigned long for orig_size to ensure
 proper metadata align
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@gentwo.org, dvyukov@google.com, hannes@cmpxchg.org, linux-mm@kvack.org, 
	mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, 
	surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, hao.li@linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: okyoa7xafjqw4ee9i8ojcw9g3chr6ccu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D6A5F160003
X-Rspam-User: 
X-HE-Tag: 1767951085-600598
X-HE-Meta: U2FsdGVkX19iGzwiv8IDQiJ1Rt+/hps+MZFrw08+RwtOwTiEAL2qMEcCtqD8MoQ+QH4vprzRjNeLHYV/ima1wUMtJJyIBR/s6a8LsLLoV5vc4EqR6SJgtagjRWy6azfxk0Sh413v6cfEhJDgom71k5Q5qn1HRLzkOH2am8b6NvBJcueFB4K9gRCjVyh1X8f3s1fvzdAlRA34l2QzlQ8XGqj6kiTV+t6yOTZQvzDFD8aN7J84lu3Bvo83yrFrq34XphQX36TA8Rx9DNJf4pgFG0c5YUTc1utFq3vRr8mpU0hp9ISYc8KLFTheX0YEChZ4DYfzIMX9UpkPdq2SQ0jGxWtKdh9chsMNqVhokk4XD2FdnOdubfEmYKB1V4xplPXsDpvhkHaT7muZ0/EAU5dX4pvqZSsRqGHCBKBPsgg3CrL5jJLcuhvPZXUmGzpdWPpVBLb8xmxkd/2e45TtubkFBFMyDxgO9oAHXZkchIvIZGOZ4ySqscffn1u3D6EmVw7QxMUVoZUmhX3mX6wla/DAbi/RBf3rqxPzUES0TfVt2+0cjjhEYf6WFjI9QPwxCC4smGhGKIgiZ/bJG01hPyg9c1PMZ1QjKXg9OioeUlRsUxm0Om/vZpyLaB78HQ9qZAecxy24BPLwAUbYq4ddNBo9ChNnM6yPMNJzFOJeop2QxPpyy12wJ1vQyDz9lVtiq3t7vNFAJkogCGfgEEo8o9EgzR79W1uSsyIXDmIsyL37G/t+w69NzctUhM7YdLNyIvVNqJrZZHyXmLvgKMd4DEyLWzZsd9QVvM5jdhf0H2g0CHEg3a5PsKKidBxYkfHvnOCe9WuEFW+kj+++PoTj8CVqNRHjlKg4VogPy6hvBtswk9e5YH2Cyq4HxfDVolyPG1s1Xu8VDS8Bsmi1Wpb/Z0hsWfKGPoduu0WdMDqLW1nOTbd7h60loHrfErb89u0ikOPRXX3A8yd4hZHAWdcBYNv
 bXyZx6d9
 R3Q3VeRtS+E94tObejg8H8/zmvo2wF0Aop6vNVdyNbRSzFy4wNVYKP1pxgyI/pYvERgZ+Qaixheus0MUGL7XUErhcyutrZOl/wtSH77lx7m1vsnU2Kg54mpOAPmMRAPq0IBhc8QAW4iS7SOkYhYWPqan1DpqQclieNexDQ2d3ddTPAFM6GbjbqOGBJWOLIOEyUFyNsAFfLrhEqDwbrZBE9WU9zkxhzWpcQpbnR2rweY1DKwRVyAItAUoJBFwLHwrnVAIss4GKKEhi8KibD50KyzVcN4U3FJpJlOLTFpog7eVMu6POXutPsdf/QcwBQsR2GTKwcGnAXsFntaGyysWEz1q6uA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Instead of calculating the offset of the original size in several
> > places, should we maybe introduce a function that returns a pointer to
> > it?
>
> Good point.
>
> The calculation of various metadata offset (including the original size)
> is repeated in several places, and perhaps it's worth cleaning up,
> something like this:
>
> enum {
>   FREE_POINTER_OFFSET,
>   ALLOC_TRACK_OFFSET,
>   FREE_TRACK_OFFSET,
>   ORIG_SIZE_OFFSET,
>   KASAN_ALLOC_META_OFFSET,
>   OBJ_EXT_OFFSET,
>   FINAL_ALIGNMENT_PADDING_OFFSET,
>   ...
> };
>
> orig_size = *(unsigned long *)get_metadata_ptr(p, ORIG_SIZE_OFFSET);

An alternative would be to declare a struct containing all the
metadata fields and use offsetof() (or simply do a cast and access the
fields via the struct pointer)

