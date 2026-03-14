Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA5FFD88ED
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 05:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0906B0093; Sat, 14 Mar 2026 01:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7E46B0095; Sat, 14 Mar 2026 01:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08D06B0096; Sat, 14 Mar 2026 01:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B68F6B0093
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 01:18:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A57659A0C
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:18:26 +0000 (UTC)
X-FDA: 84543513012.05.5866CAE
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 61F54100015
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:18:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="V6Dq9J7/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773465504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2XHqajDXsgyk0pau5z/RmGDX7ZGwwu7itA1VuqFfAc=;
	b=Mw2sbSa1dEwkP7hdzpMavyuWJCbZqnhRPo95AwiNIBBQhCJPxDWhUj6ekssz3hl7JwYaAs
	x5OHvbQTF5EMRUFn/zA9Pdb4sX5/oGZqycyTfVVTq60upvIZ+/r/dID48vzHTULwLENtwZ
	ndh6mmlhqklVLDC+SKiEKYpdOJ/bmek=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="V6Dq9J7/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773465504; a=rsa-sha256;
	cv=none;
	b=YvS41sBK+kpc/pZGiRCAOlXF28dPqBja5att1YUygrAR/Br2YWU4xm/rIgsaViPlBnlZN1
	DIkXg3eSoGk987jPqAxE+sq7E/plSZitxS9xcWen8nYESDM2Rjbq6Xuva5C4DK6XA6QfHD
	E27nz15ZVA+351KtNevgzkTpIcQ8vac=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b6b0500e06so3432176eec.1
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773465503; x=1774070303; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2XHqajDXsgyk0pau5z/RmGDX7ZGwwu7itA1VuqFfAc=;
        b=V6Dq9J7/RKljdokuOqYWhW984VfqMMGU3ZEK9MCsTRb3TMMTjDGkLkSopPs38kSHAM
         oSoTBRbNQuWCftwHRCAmwhMU//K/JfooNk94wqQzRvpYzKYQ4emmfRLKZBVJ4X5TWG6D
         xelc5LIeM+wTR/BQFOvigdXPC4IbiYU/QupFGW1cuK1N3T2ucP69RTU0Lz9dfrbYHx3q
         ZUvXfFJYa00dc12Rn9mhI4FyGwvPzP8utOhcU2cIYsahgC6Og9QMJoHdD3jow+DMOa0z
         pZYPwp32AIyCiyW5fs+ZHzl0XeY/T3k22UEgp6XboDqQnrC5rqhuRVx0cowN8B+rD5Mv
         MDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773465503; x=1774070303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C2XHqajDXsgyk0pau5z/RmGDX7ZGwwu7itA1VuqFfAc=;
        b=eqZxHManLZ/dtd8v+cKUCm3rWxr5sMhsE2aVxZ7ATp3ck7ejLAvLsSsaVQbmydeaMm
         uO9Ljd/hV5+tfRkRBjPpeWMcu31lUaPBuJYUFQwOtCatUBTp8oY6qbnViMEa0BmATlh0
         HqtzuZPJjOvIiBVSJRKsxDH9xxsu1usgctmXuuAneHVPDyZ+w6zr+dZZbldeY2S4kqNn
         M9qTsmg/2V3yqOJdcwOl/nV3SlYQ9YkJWg13N9es1rwLu6bruxG3vuXYsbwPaOBCbd2D
         V+ag8/2dJeeQQXuTW14CNNOsgECX0GjH43zAt3fF0HygNKRuHyuTRwyNbF3Mdlwkr8kW
         oOzA==
X-Forwarded-Encrypted: i=1; AJvYcCWWlu8ihztYmdUbP6ILxEalrH/RD0/vkYyQDa5e6ymxxDr6qI5kPKmQcplM8Achuj5O77e9ckFW5g==@kvack.org
X-Gm-Message-State: AOJu0YwqQEfQ/hOx9+EHLeEQ1Fcqj7eltyiPy8HY5iR1iIXDW2YMdzmi
	xpdASM2Ll6uAYLjmVOP5eDpDVV9WW0njeOzic67ulC/3QpJcW7a/f+7A
X-Gm-Gg: ATEYQzwUp9YpMJstcMUXHGFHaEKS+dAP4CTqzR/pG1+28EuMSsWNFVogCRRefQXZkD/
	Xq6Cjovgd18vczRMWP/984B6aMpbx5Ngq1L1ChBfXNFXBXOPczr0f32la66NINtKpXjQ12k3T16
	Z0Q+YtSxIW96N7sSt58Fie25vw78sFi8MEId0YV0JpF98zQ44s2f28SQGrOlbvB8ErFtutqgkhf
	W1S2k0kw7z5srYTTbQq+0LeTyp5ZVDCD9KJHqhCQf+tsFRggJ8/Yw9Nc6tk+RL7WC2s4ZOcip+2
	syWeoVVLOXUt6WyAXjyUBs2F+11lM9XF8S6MB++7QQBxykys25m2Q2BpUb2RYF2q8b2COsFlBPd
	tLDSaMGU/JnA8BwG9DRkZtsXJdEBoKpWn3FdGVFT9gImro0Kk/3kXJ3rCEJSAx2Ryh5KKc4cg4/
	XxcnZw2u8zLNMOkZGdeartUUs=
X-Received: by 2002:a05:7300:7303:b0:2be:6a7:d54e with SMTP id 5a478bee46e88-2bea53fa143mr2507060eec.14.1773465502924;
        Fri, 13 Mar 2026 22:18:22 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab57b1d2sm5303069eec.32.2026.03.13.22.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 22:18:22 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	kanchanapsridhar2026@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	senozhatsky@chromium.org
Subject: Re: [PATCH v14 23/26] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
Date: Fri, 13 Mar 2026 22:18:09 -0700
Message-Id: <20260314051809.17960-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260125033537.334628-24-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-24-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61F54100015
X-Stat-Signature: h98ip1bptbbjtroqnq3437xocdtp7d9o
X-Rspam-User: 
X-HE-Tag: 1773465504-190701
X-HE-Meta: U2FsdGVkX1+jZrxWgRufHralbKrApyEtJ9tweumfZD/bPB0kcTtv7KUcDnFdDUSn5pfPWBDY1Ew4FPQvIguE4nmEIaTiofIONEVDUgLvYiwN2ZxSxBZSXoH/DgnDfmgckUV/CrxfbtpUUlJBTcgBlcDPmJAkc0KEN5jbmqTLgmL0BfNB6MT04dcQ5yniaRwhSyUAy/NPXhIhu2SRdQKDcByVWK+12R5ZPBZepKeCyQmJBL7vaebjjuyStHPYJjnFXcvMDj6tYmAcb5ITA20GWvbnFgh4qq/HzxxddZjZp733O/XVn94la6njbs520AIhMffFwy5mRDQUWTavx+IwcrFq8jOG1seqwk/lHJ460P2eWj8/TgIBptusaE5dFewNdP4PSz8wHqjO2fCKmunNWWJLmU9L9fqLO27rYux5INY57aNLtdlwZ+bhUpn/aKrEtO+n5NrGv4J1w/CNxNNJBF5MEBr1a7o7bfxlD3fu5wGZFKgYFPSjBViq5cKBd6GzQfTioecx3iC5a3rJMMLGPuluDSiLYvUyznY4KGJMi5NjOqTUiJXMS/iPOeREapS1ll+e4pPOG8cmVwDzmNojOEtiLvCUD/JoUlNjNoSJooDxemH54lFd0gQMuesIT6y6D9XCLjZ+juEgJd2XUtYEi4ecVzsAWsbnei4tIGdfs29EJLXkur53rCnOlcVpkEME5cPhBzB9dKWuirpR3Q+N6c8r2Tx0tlWiH5y8fZ0r9qYdfp2nFDzOY86xuWRRBM+60/qyRimttGZSbCK94RxQ7sJqfU9nK0J0Urx8OW5hx9nk15Ht8qAbX19/chrZhtnkwOhZlhYXWGHtgkc/mE+lMMDXqg3S2glsbe1VA9/DHY0k5yOG7D3/ONTw08GFfnGbZMxOHgWZn61eATRGcn9PwBrbUqn5NU6v7M1PtQLSrG+noFOwpWBwASuWA1J1ZTQLfk8DjcQG/CZp+rHlElN
 rwPRh7Jt
 By6vaVKjFArl4zXNQ9YTJ13T21U+oyqvi0sVXkSuYfqxLMsYU+km8YCu+x9aqX5clkfF1h9c//tcIYefeZizK8tBRIgXny1bnhXUHJVp32EvZt5k1w/7V7h5zFDPyZ2OE3BCVuGFJUaoMSAJRxvq/cRyRaLN5xDodW8hfrFwqGhsvv1DGhPK6fFX2mszJG44lZEiu3O+dz+Wq6XGZpy3NRNd4ypkKXgBBKIi4UyvzVYGPBJo8hXIc+JcKI1XmO0dao7i9FUjJxK5Wu13gB7ipAswjZHBrXc149nG02YqGIrZxdtSt70r+PDMO5QdO98dDbhJ7LqMEqkOuFys/CU8IInTbwj9LBUdF3KB+NvfuPufKhfc5y6bxj2TN/lecwi/KYIlnQCOH6yG65ZM1bOUlPFMcgUVCohk5qctPL+wM/P0jcnmEFWaCUh3bKMHDnHjjAz6ZtZf2Z55w5o4/bb3gcXSaDZKTI4pELkp8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026 16:29:35 +0000, Yosry Ahmed wrote:
[...]
> LGTM with a small nit below:
> 
> Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
>

Thanks!

[...]
> > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> > +{
> > +	if (IS_ERR_OR_NULL(acomp_ctx))
> > +		return;
> > +
> > +	if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > +		acomp_request_free(acomp_ctx->req);
> > +
> > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > +		crypto_free_acomp(acomp_ctx->acomp);
> 
> Should we set acomp_ctx->req, acomp_ctx->acomp, and acomp_ctx->buffer to
> NULL here?
> 
> zswap_cpu_comp_prepare() uses NULL to detect that we need to initialize
> acomp_ctx.
>

I don't think this is needed, because with the changes made in this
patch, there is no scenario in which zswap_cpu_comp_prepare() will be
called *after* acomp_ctx_dealloc() deletes these resources.

zswap_cpu_comp_prepare() is called only during pool creation or after a
subsequent CPU hotplug operation (for a CPU getting onlined when it was
offline at pool creation time, or, due to an offline-online
transition of a CPU that was online at pool creation time). In both
these cases, the per-CPU acomp_ctx members are either NULL or valid.

Thanks,
Kanchana

> > +
> > +	kfree(acomp_ctx->buffer);
> > +}
> > +

