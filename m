Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D8CC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 02:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8EA6B009E; Sun,  5 Jul 2026 22:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59A06B009F; Sun,  5 Jul 2026 22:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6FD46B00A0; Sun,  5 Jul 2026 22:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 714756B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:50:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D72AD8CDE9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:50:05 +0000 (UTC)
X-FDA: 84956822370.06.53B7522
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E167140003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:50:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LTliYF69;
	spf=pass (imf23.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783306204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5x1wjFv75jgxPUO4LcE1UoPqAki0+kcH4/30AEBDkAQ=;
	b=ija6/TBLnAjadLzQLkitaB6aQXX64xhOENsTK4ow2EKL6cmllBF3CGG+7YUBVUNrzv+RMK
	yXxhOXL+24ZX4CIVqwVxUycvp8kLeFOfXhHm+Ea1EUe1YngA4GWLlKNfW9U06eNEw0+chx
	MqQVwuTwGkjwZj3US9ed3HvBIq8Tl6E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LTliYF69;
	spf=pass (imf23.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783306204;
	b=SYero3MXsZwPk0/+f+e6XUpD01iFxFrKoXrzQb6bmwC77n/yszu8boMx/Jiny2dgrx0Q3K
	N/g77PSCjkbVuY2wEqq2ZHNUiOvMPc8wRBu6HRPKSrDHfb2QwpqutI6s5WNu0wmQudwcrc
	EkjG86vte/QavX0NgdEF1nL89BaRV20=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c9e7391839cso2333000a12.0
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 19:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783306203; x=1783911003; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5x1wjFv75jgxPUO4LcE1UoPqAki0+kcH4/30AEBDkAQ=;
        b=LTliYF69Jrxyc1ovzRJl13TX5Vw4PjioSxpoFcWKkaVMUC8dLDJU/P1a6Z7Kkw6qvy
         OGtjGb3xSmJ+h8gAOgHcIZYwyi6H6WhO5vpUUAIQuu6pBldiJQsnQjilamgLdYsXAzCC
         DiJceowf2ax8Bi5ufYCEHVKV/Xg8HnWU6fGTEU3j5TLGy1EdyeZ1BbPEIo5zm2NDBcSd
         dobxv9jXIe+Fbr+UaiVNvKCLntFbUH8A+MF458X2F6gZVrRGS7OhgLl4iEn0PJP5lwyo
         O1lptK0CluiM6mfNYiKxxdXcka9S0It4xV7pRm7ehCN48ZPHTc4UNvgzbD+4OagjZPLJ
         ivuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783306203; x=1783911003;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5x1wjFv75jgxPUO4LcE1UoPqAki0+kcH4/30AEBDkAQ=;
        b=n3aEf6B9dqKo4Dw3Z0wEO4IkfT7NqdRFGfsIcpw9cDyPZYlxoL5Kci5G/lBqykMLdx
         LmjJUj+kL4H75z68CHdpcUSQVFhNkkXvacLg7YLD58E+N2jkYfHuq4gj9jem+GWHkDbZ
         bqWSKNNMWimA05jpiBD0cxup7w2QbE4wPRvfdcFMeAkrn+5W9j2d3E9ZZqPrpqhWMnM2
         4KmBYOdbGwg/Qh+vMucjTjxhDgFwcCWFmxzpfDBwAEZ/OZt17C/ys5TESYpZ5oOXwzOq
         IEpE+VXxRXEGL+5B47yn3CsTquCfJZiU9sLY5rW2N6HOG8zbFW13LyF/vH12AYOMhs8R
         df8g==
X-Forwarded-Encrypted: i=1; AHgh+RrjeaZCDFPbFYDCX4sfOhXENCuhMnUI2B2XXWASXPhxchrKlEh1KslaA70JP2H6TU91Xr3ZCfYgTg==@kvack.org
X-Gm-Message-State: AOJu0Yx1CxDKp+14steDkR3L5mWn1ArJgj0RxPXuqPMDIEAwylI7hVHD
	AP4f5Lm2GRm9nkmn2zrNNtSc45O4fnhTr0Bd8vJK94DH5OE5DKNKZqrA
X-Gm-Gg: AfdE7cmrdF+rfhfLT7CVchZrpugx1pf7SPcaTI1QwZrzYqKebqbWzobdT8IvYnyWPx+
	vFha2RMiVAI2wCW2StNbo35+xqPNxiVT8jWJzs1qrRLmOJrM9L1ZSs8FLilyYFwK1HiD1zTCkIY
	cV765Ug/EyCLw/lKt5+o9X1YoZq2D98pCgf0LYWk8p+X375k0FTzbVR1qFdtB1/9tzn4QMoRet6
	HsYvMAIRf2wWroTXmjbZI/nP59wM+onitEHgZ8KF0qTMrSvGOwIJdP26ootXTAkW2KEzC2cB/80
	iaUQMZKYMkYWLPZrWqgcCqpGUgL+vYo+isczr4JgxpOA1cbpEQPkLYmR6filI3S4GMuTIniVass
	MKwLohgvpMAUtLg6WosuV821VInFkBz5rI54gL70TvlmFLjG/y7AGgerK5rrvojUW2RRjpEOs8b
	3qSielgw4p9sxcyCy4gnlTqLoaEJEmCQIPU+eSuk6wuBEtAo42XQUcOI/fhwhW3r7yqfEqGefG/
	NxaOqGTkq8W
X-Received: by 2002:a05:6a21:494:b0:3b3:fdb0:2295 with SMTP id adf61e73a8af0-3c03e1a89c8mr8893007637.6.1783306202992;
        Sun, 05 Jul 2026 19:50:02 -0700 (PDT)
Received: from mars.local.gmail.com ([240a:61:3285:c322:28fc:365:cb6f:6417])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e91b09942sm4994194a12.17.2026.07.05.19.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 19:50:02 -0700 (PDT)
Date: Mon, 06 Jul 2026 11:49:58 +0900
Message-ID: <m2pl10u90p.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: fix the error path when vma_iter_prealloc() fails
In-Reply-To: <c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime@gmail.com>
References: <c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime@gmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E167140003
X-Stat-Signature: wbh54fe15p614rui8qj1n5ge6nt3np1q
X-HE-Tag: 1783306203-118389
X-HE-Meta: U2FsdGVkX19nmJbh61jcLS5+l2R71SGu8lxpKdRCrhP1ihYBvjPoKofomB9isbZKozkYKkReLdjJwJt0Zef1RWslGMgO/8W0/4nst+QJP147BEeKv82N9PelN11OFkt8HIggY7EjY66uN+bdL1lHDyXAr/4Om2+1jLk7oAwwte0xJFaJN41O+nKmYdmORtoQPKlbkGIEmtJ7181OhgnXdAGVS2b6kXE9mnmlrab5Hu/HAFbNnI9C/Pi4Tn05MWm6kGW1deZ+3CUXBiiaGGbEfVAb3IQbb4L8vKwYrvECsNzJUq9J7zAXn4Q3DNipbVf2vwf8wly25y8Nxbsr3YaSIkVVrWGcVdfD5gaHNJz3jmNF5WoKajFEFmuZtjKC8GxSM36x32ek6AcxS2DW9U0Aa29dGnC+TNJ45dsfJeO0aFEfA6UtsdWoeTLZCsB1j37KBscauXkG5a/deOLhuUtLuOYr+P+/4DzwzxILmyYpZZfepjmfUjsfGaVz4WkcuH9C9L58gvGvnRcj2UOYTYWN+6qphccCu/odhbUxl7SMB90DihSIakLlt5TRM0k1AmpOyzRE0SPCXib8HEkrFonSIkIoC6ZwlEnSQ6HWMWhh7h3wz1/b37IvbdPE5adNUTqwRdjjT4VZGKv0+dQJ0qAUzmAhY1OTUGu7i39Jt30LoGpPhX4LahOHZrKhIwNty1qQ8ZB2OLgvTpH+Kte2yOFj0J37/JvSzwnf6ZvyphzxqbrKU/TyRZGRcm/zmKeVIv5MN6OiaAePa3wCaAWp2xvX+zhgbPNmr80qG0uwaKiDnnTkPJFzAxTDt8uZk6OppU/pI+EiJzpy/QXRQ28FqqUoPuhfT7lnFph5Evn6HD/QCiJZ8jdyyqZZP9ajMRDXxPCDDNkXO2N+AqdSyD7ZXfzPrbCL+ZD6yNsXNYcUKddivF4JAuB8XH2Ydw7Y8w8GrKKGaAgEBlBDxv0WC/svZVV
 GjKEv3Rd
 HMZNMz8pCjl0tpwdEtjhK74ZLGoEFzX1GaCnOY3WK56Ku1quJA/RDoENi+gchbDL8dhf4SpXKpk2ew67qiwRI1yIlT1xo1DJTCBgYGUXVtJWXDNNoV6rwTHg13aO62KwoFmW/8jGak9g3k+CbDyflQgMs+P2XvR/pk1Dcs3bOHi3Nck+Os0LAGuehJOXiadgSG9Z9d7JrBJMCjOlpcASiChp4VaJp0DLEGRuobdgGyHFh2ptcSwEZVPHYqLqINFvgow20a5L1gAFQqcvOaGBDYs8wS2DOOhPvcXff5kFJfGpcT3w8sQdToc1UKoankL5uK5wbj9+zMhZ73uvZiXo/WgsRaZw5VHGShH55pI9U9i75Bb8ZNYoWjJGS5iEfdTGE7MnOGYCEewt88BfqWMU3OirS+dgaHxZeXpHYaZ0WZ4dEeNvEm7sJO+XvXhiC1cVEu7ygcX6jI/cDfX8MErSGZKGr9j1YolfHiafRiv564N8vboChhnvbjxd5fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 06 Jul 2026 11:18:46 +0900,
Hajime Tazaki wrote:
> 
> When vma_iter_prealloc() fails, it jumps to error_just_free without
> updating ret to -ENOMEM, meaning do_mmap() will return 0 on failure.
> 
> Additionally, this error path unconditionally frees the region struct.
> Since the region was already added to the global nommu_region_tree via
> add_nommu_region(), leaving it makes a potential dangling pointer in
> the tree and may cause a use-after-free on the next tree walk.
> 
> This commit fixes those issues by updating return value as well as moving
> the region updates after the place that allocation is finished.
> 
> The issue is discovered by Sashiko, linked below.
> 
> Link: https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime%40gmail.com
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

hmm, there are still several issues on this function, reported with
new sashiko review.

https://sashiko.dev/#/patchset/c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime%40gmail.com

I would try to find a way to do a similar review locally, and will be
back here once I don't see further pre-existing issues around this code.

-- Hajime

