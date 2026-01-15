Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A43BD46600
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9256B0088; Thu, 15 Jan 2026 12:33:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587246B0089; Thu, 15 Jan 2026 12:33:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E876B008A; Thu, 15 Jan 2026 12:33:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32B5D6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:33:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAA3314041A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:33:20 +0000 (UTC)
X-FDA: 84334894560.20.09635FD
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id D2B15140015
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:33:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ovV1I9h9;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768498398; a=rsa-sha256;
	cv=none;
	b=skqJCBDnSC6PNlvElQSZy6ShPzDuv/Fiktky2KH6Otyo7hnYQQfMvKJTxBPL/74Ss24ZoN
	V4DeO7hfZ+iHin7mrc/PW5xIknRbkfOT0rnXwuxISLwTfvVxuAtAJWkrWAtPNU8rQDg0p8
	vz1yXo211pgdD9m1Br9DVCFG2yftqVg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ovV1I9h9;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768498398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HELVBq+JbyCXR2ZFI5M9lAV4vG/kM2Ay1hf/o0jB9SU=;
	b=h6aC8Wgj7wKWTPng/zw6JPRpEdcyupKwzU61mPWeP4zltgeHdk/Xsh7nbbU4uLrVHV6tGc
	t1neESKujdcUqplLIxVAY1IfuPihW0sKYa3X8b9riE9udkzLC3Bz+ynTv7yiM1yiBv+jlq
	ffrtHO6aZWXlj0U7BO7m8sPMZtocYAI=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a2fe9e200so10268626d6.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768498398; x=1769103198; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HELVBq+JbyCXR2ZFI5M9lAV4vG/kM2Ay1hf/o0jB9SU=;
        b=ovV1I9h9ABF6CYMSoh3cmjoIPemJmrseypCVgXDy28bDsXHNeyv30gpBJWm4IEXl1P
         CT7kElFMkDhYurU9ecCduseM/x18yfMdP6A/YfY2iEIjRniqmJ1eL7tApM9bF5R6EiPb
         HJRK7KCUnzyxO2Ilg1m6tCEDdoHJ+knb8iMJkBx3JkTkxhAItbsQQOUe15XYFAHgN7oC
         QNocMKjDuNlQtmBdkodIdDnag86AZkg/ykkNHSyABnQVvokHqwtciDfJnQ4RKCls0dQl
         hus3aBzKuBAfOl9rTeo4wvfbhAx7ackZ6+ndc+RHiQE9AyYXTlY54BsCd6faxW/Tf5Kj
         uTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498398; x=1769103198;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HELVBq+JbyCXR2ZFI5M9lAV4vG/kM2Ay1hf/o0jB9SU=;
        b=DDOFY/OickstQUc948XTM5c91blc6EWG1jbjXZ1n6ilO1Jz7t2AdmFfgGCSe+wnXtA
         TzcsRUaeG/NClqlhvdLhrc6FeV1wg1spy+YnUxlXTj6QiZj8w/rC4TKSZKhBGHzJWe9n
         P4iyzLpi35Uc+OD1cO+1PvX7cCcIYcTPkozVaV/GHjGVuVmEeEcpv169XrzEahsjj7tV
         E3epSoPVGQFZZOsgz+lg0NIxws/bSKISUXXvikUWYPR2cV5mvsTXVGh1JnGEWBjNTpMG
         NIXEn/PmrSB6QkSDBLyGSs0/ilXPVWmEpAgDl8s07SD4xtRaZqHyDcdLChaiinSX+0Xm
         N4tw==
X-Forwarded-Encrypted: i=1; AJvYcCWj7iiUySEjqEZOzK2quMlwh+izACEU9TNpyFjBzzzj7gzsfz4mVoNTXInxImJz5P0eHy25uo/GYQ==@kvack.org
X-Gm-Message-State: AOJu0YwmienXqo20udKspn6PFyHJTdPblYFUxMW/PTh19Z/tCB8/IXns
	oNhqzFpzG1F+5lTCWg6NQ5d28NxGZwTD/E94hk9N9hjPsK9iGswwsgtWwW6I7y2ljZ6TgaOlySp
	DHbqVaAQ=
X-Gm-Gg: AY/fxX63bIagP8Q6yC7fqjSxzTt4KnrowUwM/YvPrwAtAtmM0tABquloaF89fjp8kqy
	x4CR2y2o3gRNNrV2gZwot1GL8LeZ/iYzVxNzt5PBBaL/+U1T32sKr8A9Qbczzs/KQ8imHSCaz+x
	6bgbS9wcbu8eKsSZp0I83BN06Dq8T2F1VMkGGhKdHRBaZin6CCEyWxjW/DPzuQg1Uib55Eyb6WM
	lNYocz4bZTWI1OG7tfoGLcvvRZ7mX01AGaxccuzTIdJGAlFF+fzNxX0OGuMbQIhH2Aa18Ghcobo
	cucGxRhk7v2LoDG1Wv6psbRADMsm6SjaLLHVqRIyFALAfnbnbMTLxfF9I8aZB9A436tUX+540BV
	D3CdKLG0JEqo9Sna88dTMOwg2nCIjeTOE6wxEozGnN4uGGO3qGKWPUpbac/vf4Uoc4mcFj9+JR7
	8Tf2GgEgdQ9bts/ZI4pDsu3uCT0gFqjCsDsLBWKRBCiTSXx7Glb8FaQC8iSxNiZrI5qfZ8Mg==
X-Received: by 2002:ad4:5f8e:0:b0:880:541c:8243 with SMTP id 6a1803df08f44-8942dd060f8mr2986496d6.1.1768498397481;
        Thu, 15 Jan 2026 09:33:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e47d897sm548586d6.0.2026.01.15.09.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:33:15 -0800 (PST)
Date: Thu, 15 Jan 2026 12:32:41 -0500
From: Gregory Price <gourry@gourry.net>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, bhe@redhat.com, baohua@kernel.org,
	chengming.zhou@linux.dev, roman.gushchin@linux.dev,
	muchun.song@linux.dev, osalvador@suse.de, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, cl@gentwo.org,
	harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <aWkkuaYt0cEyvbGj@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
 <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
 <CAKEwX=MftJXOE8H=m1C=_RVL8cu516efixTwcaQMBB9pdj=K+g@mail.gmail.com>
 <CAKEwX=M8=vDO_pg5EJWiaNnJQpob8=NWvbZzssKKPpzs24wj+A@mail.gmail.com>
 <e6eydzdvuiktmalhcmoiwsgzjbw5v7t4532fkbroylwr5cqetx@v6pgjaoxgmyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6eydzdvuiktmalhcmoiwsgzjbw5v7t4532fkbroylwr5cqetx@v6pgjaoxgmyz>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D2B15140015
X-Stat-Signature: e19w46ehuo39b99u99nyiuqrkf37sw8t
X-Rspam-User: 
X-HE-Tag: 1768498398-186186
X-HE-Meta: U2FsdGVkX18DZqoD1OaqpjMM9Yc8uh03EQs6gEJ1biSgK5ho+W/1h8OsYxuDlPhCZImr0Kdyp3Q5zVcowPxmt+UPSvZuAbxh74da+KwAl708QGnv0PQzZt4Fh9BGhWsYbXLlLiRSA/kZgv2SzUL1/6GwGh3/SuDziIN9UJY6hvv/VIm2rhYPyJOE0rmB0mJDkdP4u41+2if4uwh+ASlCWNW5+CGRIDH5HwrMK6pFX7txoRTpgPUmYWrfOQSLz57FLFOtdhSjAdHPgP+UHPagcCFtyhLIkCYeJfk0mspLqdY2xKLIq/I4gPyQUDXO3j6ZK1F0jV04ovxqwYuqrYAr2htnZTGOTKkCTYrIm1L+UH2u/lOClscbUvI2oVzK+waEGMKyNoqENt5OXzkMJn0yvt0HmQU+uv6wnpuxI48GEektiDc+P9P/nXXHE4mI/5l+cnHwfGw0IKrRBYvsx4DsdcLS6WsALxuwYYPnQ3j3OjKIM1WErGxxNoHtZ+i/XKl7hFgrc9rzbXV9Rqy/Wg0GGaCh8rL2wAKQ64e+4fS/7CdN/1/MTZ1ECE5ixmDcRSm0sjkejtitBKa8MPA4Wz+9leEccHtCY+2tSN0+y3nx9T0gpgM5tEijaeBWnkzmttQboXJFOR6ZxLLYh6SYrfKd6z8jcaotmogqnS9tzWdE8qC7RPfE2hiB7Zi17d1FjQ9qtUUzraP5bHT6+qYvLYqgY5mFVATr6BOgDsPcHQT04vesQVlCvRTH5XQsbGzvW2wtKnz6XTEFAQTQ5QlkV7W5/XBfDKMy07VrlfuHCspm1t/AEBLFZOzH5f6ATNfrDebFeUy8DESp97Zmilg3KtUn0ixqcqlwl2bAQc+rPXGZJLdntACzTKU+taoXSrWfpGTjsKPyUHBW7uPTwXp8/RtHZXKdNJZFrucbBI2K9acKfSF785bLkuFI/c50yToN8pVgixU5T/3pdsTYMZkxZX8
 0elLJVbI
 BXB+qKg2ANxgPesZnqnH2G44pPTDCVGl3o8f5Ewh+xbNpyvrvtbkAzPj8QCBPr3gBr4a3qV7YjzYAECkTBK5BC0x6vyQOjSDApJ9HRV12PCGLNLfosVC6wX4Al1q/aJh/JheHO85TOzs+z3qkH7CtqmSSRh7SauIEjzL66ngXpyB2rt5vAF0nXEfRvRltno2qJPTRNEofH4Y/9HRR07m8YIfX6ZAzfWOBu+FO0yq7yr8GbwjHMxEPLYQC3H2iSD2AjOZAVM81mO3ZJc6ECcoG+i/lLGqh3JDjzFfexcWYy6krTWlQqiFgop94031bKijN24JZl01XVKRgzEABj2D+4hGDWJOzz+RqMbfn92j3BGYtQ5NjaCnX+L4zj4cp9zBi2H+C/ZeTfuLstsfFXkV4Qu0AgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 05:00:04PM +0000, Yosry Ahmed wrote:
> > 
> > 2. Just enable zswap shrinker and have memory reclaim move these pages
> > into disk swap. This will have a much more drastic performance
> > implications though :)
> 
> I think what you're getting it as that we can still make forward
> progress after memory lands in compressed cxl. But moving memory to
> compressed cxl is already forward progress that reclaim won't capture if
> we charge memory as a full page. I think this is the crux of the issue.
> 
> We need to figure out how to make accounting work such that moving
> memory to compressed cxl is forward progress, but make sure we don't
> break the overall accounting consisteny. If we only charge the actual
> compressed size, then from the system perspective there is a page that
> is only partially charged and the rest of it is more-or-less leaked.

Which is comically fine - because the actual capacity of the node is
functionally a lie anyway :D

~Gregory

