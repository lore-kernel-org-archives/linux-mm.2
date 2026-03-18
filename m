Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA63107BCF2
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083796B0161; Wed, 18 Mar 2026 06:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0349B6B0162; Wed, 18 Mar 2026 06:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65456B0163; Wed, 18 Mar 2026 06:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEE716B0161
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:31:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 886D41B8664
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:31:58 +0000 (UTC)
X-FDA: 84558818316.13.5D588ED
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73AC920002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:31:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oCKoKfFz;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773829916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8wD0P1L1/QznoydIS+U3CJmXHsg8fPNvVB6covSKFM=;
	b=lhXlONVtISPImBrbD7mQMk3b/6sK84YE4ALII891lyB/tqIkbT/f50ZXOYjf06QrJH98hy
	gMDFJbwwoNlG6hd6PlNSNrnMguhY+on8QwE/kklZbr5fjQKa57RQQiZfhzLcIMxcH8WxHe
	nbr27YXygETVA8XKb+2gMxDjLvw/PNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773829916; a=rsa-sha256;
	cv=none;
	b=sQUer1GeneStRpBjCO4xDJpiUKf42nN2dNSNP0113W9pf2P/r+hhdU4BPa7+Qp8RfkFBYv
	go4m1hZ1rsc3RgJL5SMEik95mwtNrudGBQI960l5vM4bFx0MdGj5iwOWSCPdR2zde79QSt
	x49e8DZhEatcYilJVfllrx24dG0fOwc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oCKoKfFz;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aaed195901so31765405ad.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773829915; x=1774434715; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w8wD0P1L1/QznoydIS+U3CJmXHsg8fPNvVB6covSKFM=;
        b=oCKoKfFzyBmsXDZsamffRxSnA4nzXQDAMO7YCe/Hc1dMUzKwvGlWdfpSyiVIdUkTkD
         FgmMCgcAkxU8zlLI8cdl4RPLwYBGq7ATXl10vrVfc8CW6Ekz7EyH1Y6wanGhWo1PFin1
         +2JQ1Z/Xv079pyHDK49qdtQaYwV1oJs0j7/2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773829915; x=1774434715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8wD0P1L1/QznoydIS+U3CJmXHsg8fPNvVB6covSKFM=;
        b=JeFoMts6TCsSGNIitXJg6taJ6iqO0B4nBkR93Px0E2MYZJMUM+UuQK1LIlRAJZSlUj
         fXQtLaHj/k4dIRLiSEW1Qjk+1FjWKFn2iGmR5KA4IUAV7mdi1Zx4IlEJzPjhXlLWY9iV
         FXp+lJCHVpAPz5XbmY7VLjGFtHY4FAXBpzUiKoXsb0sN7djDBZbQnjfhY1lLl27UvOSu
         voYzr/IzFWTqD4FC1oeTNaMJf8vp6yKh7DT6xsvHBT+vu8jar8uZUHTmTKWLhQqThkZ4
         Y1uc/+7Bd8RxBI4VsZOiji33mv8aIUZUtNpaECOJlE0mc3Lcr0RAWM1L+ro1gZDKd7uy
         NDDg==
X-Forwarded-Encrypted: i=1; AJvYcCVFwRHEtSy7wdGj9rmsGZVqK3971sMmIY4MxzQJd9P27YVVNawSWZjvMTPOO/INId8kF1rlF96l4w==@kvack.org
X-Gm-Message-State: AOJu0YzhP+9pTGBrzxH1J4YHdL6OwZ9MLfYvv8StjoouRXUkDtLIfv0I
	V0CyvbQVu1qLdSs6TXT1BLgCIITYGDSvpvCyP3NL/tyq1eR3K+QXY6fQmXvOgOd5Hw==
X-Gm-Gg: ATEYQzwP1C1LE9OLqbIGz1oS5eRSCZBqF5UkWr4qO0n9HKRdoQjj4z90n55bCEkooyY
	QwZoFI63CPBbEsTKZ7GtxaCND6eEtcto7vNs2fU2J1pKZDIFgqUQAFJhtrYObKO69Av83+zY/k4
	75GRY5/izgtURgXiKJwGch4HPJhBfm4U4m+iK1zIB9xnUmWVM9tKQb2BThN+4owsDvk8q5sWK2X
	Rl28b+ZWH9tXjCWt+s+9kEyQRyehxMKndCRGKcjhWIZhQJNqMgJolMJ2RAGHrEErpTRRwGwXHmU
	msL2TD49lSjYKLf7wwy0a1vaW/oPvRbD9smS6xqqGNKrXnnTD8f9BPknwITVeik3LxBwSUj5XxF
	h49bd+EzjtR/t1ThNUnp6G3WiI+scoGI8s2Go7phZBVKfcLokowx3o10XsWrWHjtNPbsFvDjD3L
	nqn6MEMEYN3EwkIrKGfs6G3V6O4YzRF6E4DltKOpBYQDT0/LkOcWJ8Ja8HQJFnZ1/Hr0UMkQ==
X-Received: by 2002:a17:902:d54e:b0:2b0:67a4:fbe8 with SMTP id d9443c01a7336-2b06e418997mr28318995ad.40.1773829915235;
        Wed, 18 Mar 2026 03:31:55 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:2eae:ed87:1d:8a5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e632418sm28236915ad.81.2026.03.18.03.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 03:31:54 -0700 (PDT)
Date: Wed, 18 Mar 2026 19:31:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	teawater <zhuhui@kylinos.cn>, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH] zsmalloc: return -EAGAIN for zspage migration lock
 contention
Message-ID: <abp9uCoPwM9EhdPZ@google.com>
References: <20260318073114.34858-1-hui.zhu@linux.dev>
 <abp7HJRZQi35wHn-@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abp7HJRZQi35wHn-@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73AC920002
X-Stat-Signature: j3t7jphs5cadnam9c571tcg7wj863s9x
X-Rspam-User: 
X-HE-Tag: 1773829916-559005
X-HE-Meta: U2FsdGVkX1/9Lym6iJZ4JJHLOIj5V5TSFsnDLnU5ttj7ZkM/vp/5lBxdudf3ZIKJF/k5BnXeei0sVf2KsWkcP9sjIpJzpJOaoGwMGuUnkNhiz6NDiMK88SAetVKas3yM7lok66SBgp8F7zf1s4kCfL19Lwu6Q8k8OQ+Be35l1bK8y2PIw/eBROpdYQwO3LQPYm0bvRqPJQ6wqAbo1tSOSU1/7u8tIqUrjw3/aNADR+LKyE5EzzmnLAE6mjbNzYXmlwRmuLQhWUEI3b94STOdDiWTiFs3el+9LIBPlncs0JUarXO3knGLFqxOLNv5av+16SMN2G5oQJOgLvLs7rXByCYv0oEwwn8k0WEkboRPdNqhfAJH6PZfKk8aFQCWtPA9fFbf8GME9TwF/TUcul4kSmztWhXMSU1Wj9cYhQKWLX+h/5ZLMeR/3i8NRLopyZ1YqAdX6h1Igpdv+63cdHoALQ4iSZNwYLHLAnXZp+fLjSPaFqEjLaNdkSmUY00XQxUOtIpJQ/WT9OINxoukfxUlvs4K7FAnbQAFWkcYs7yCpx91yqmU9MBYGAp4Vaa5QbhqdpVyk7jwZNKVlWe7F0fId9DjaN+2Nw5sykL+xxBatmfdLeY5slzjdeQfJICR+3Xn7nrKMWnIP1ttt12Xh8cSjlUCNm8EP8R/jCMLdoDpbzMCMAooXgOAdRPHbr3UvJdaOVmvRTbt2wNsWwJm+nlf128iT5rWxC+cA4b6hNXJ4twslJZhslBAm6YlKMUHgHBX5V/RW2bIJZZrOsSMCgkAKgDg5UI33cVVQtqYKrYE6wiob0jGMID+sS1Dnc3VJzguDrs5nFbP48X51ewxbHrmnyTCOKCUoJj1fMcikEDAuiQQ1fPa1bATFJpcDWSK+wqPXpPQe4VeM1N82BxO30GBoXmVg9W6JDxpY+PE+I6/FdJdFP0rYKj2I755EIpweTzSePO8VYPBoXqf/JFWpB/
 R9q6xg3k
 qwjGq0fWyl8jvAV9RfpxrMIS4PGK/Oy8U0sZ3zUbKfEdimaJDzi1NveglIVX5DJk/z4ve5UpFbTktKMVrAYRTgAvEBkAt3FiWVTeOMd7a8krFF42zYlLVBt95dKOpnwVUCanNmKfuFjTAdPM7wktNWLbM7Um3h+1xP3kPpcaw7fSxLute9zbKbyE354jD7OSRuoT2fnnikSZJNZ0s4dRlJ1XmKo/qZ6vHIUJGybz/QNPtAvRHT4CL00gd7C4xjfIeOlXVQHN9qFI23jFvyTWeU/XINo/e8t7URl0DDLoI8E1z4CtbcG5BJtvhxwND6cXV5uxpIIifuyeRLHQhietK62Grgv6NAH2kIWmCWVIh3VwvZIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/18 19:21), Sergey Senozhatsky wrote:
> On (26/03/18 15:31), Hui Zhu wrote:
> > movable_operations::migrate_page() should return -EAGAIN for temporary
> > migration failures so the migration core can retry. Other negative
> > errors are treated as permanent failures.
> > 
> > zs_page_migrate() currently returns -EINVAL when zspage_write_trylock()
> > fails. That path reflects transient lock contention, not invalid input.
> > Returning -EINVAL misclassifies the failure and can reduce migration
> > success under contention.
> 
> The zspage's reader-lock owner can be preempted for unknown duration,
> so I don't know if returning -EAGAIN is safe.  On one hand, migration
> attempts are limited by NR_MAX_MIGRATE_PAGES_RETRY, on the other hand,
> those attempts are performed basically immediately (?), I'm not sure
> if we have good chances for preempted reader-lock owner to get scheduled
> and release the lock in time.

.. or reader-lock owner can simply perform decompression with
a very slow algorithm (e.g. deflate) which can taks significantly
more time than NR_MAX_MIGRATE_PAGES_RETRY migration atteempts.

So I agree that -EINVAL is not the best error code to return here.
Not sure if -EAGAIN is the best one either.  Technically, -EBUSY can
be a candidate (this is not exactly what migration code expects and
-EBUSY is not any better than -EINVAL as it's still going to be a
terminal error).

