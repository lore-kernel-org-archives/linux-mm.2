Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E33FCD0431
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 04:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851B66B008A; Mon,  5 Jan 2026 23:20:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819666B0093; Mon,  5 Jan 2026 23:20:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769E66B0095; Mon,  5 Jan 2026 23:20:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63F0D6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 23:20:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC638C1A64
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:20:40 +0000 (UTC)
X-FDA: 84300237840.25.5009EA5
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id EF3F8A0007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:20:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lJaZAFrS;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767673239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nR20EMIwFVHhIbY46YlqFgmKZSQYP6FzHYmAxvSlSs=;
	b=BiO4dUJerz/Imyhvu2JRVlryjeY1RO7AxaK6/gB8NF8M6REHw4fe1hwGCeFT21M078xhBc
	SXlkjtkP6ONM7uITURJsDsbkYBBqR/TWrLV0IGG0S7kdThKJkLvQaimMdNBRL3UaLEtemF
	BJ6lbMwoeO5Z3sFq7rHZpRWzNaQeNsA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lJaZAFrS;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767673239; a=rsa-sha256;
	cv=none;
	b=CK+Hkxx2D28R1wwdZ8y0RcSOoYGd13pWtS10h17hR7gZAf4O3TwNnqRfdcnKg6SP3IGpUX
	HCqCriBHDq0Ry+4GOYeSzNdoLUmVTtZyibUbLs0t9YDJGpiP5YIHHPIZxVvf7vZnlM5aPK
	+epftnzF9R6a/OBEAKaFiZjk1QA7Mb4=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a1388cdac3so4973465ad.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 20:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767673238; x=1768278038; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5nR20EMIwFVHhIbY46YlqFgmKZSQYP6FzHYmAxvSlSs=;
        b=lJaZAFrSWH0LvosIQi5kIhxdizHFbEbgd+t4TtDY4exxcuTJ1TsqLe+5tZ1WBMLEoU
         +psGIVYpTfxIg6vhS0n1pMSYYsdoRDK0jLvy95tZB+GiIIbxLkWcFEPU55oUTGabtqS0
         yWQIlBztXXtUsmFMzSZyA3aQ0itomNTzQkInk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767673238; x=1768278038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nR20EMIwFVHhIbY46YlqFgmKZSQYP6FzHYmAxvSlSs=;
        b=U9FRdos/p8sV6Vb8tV74kDywt4YE7PGJ9kX835UFS76pNoyYG0uHfUMPIyT2zjjBR0
         SI9zetDQpLbURif/KePKRktWlcSmCrx+ZRiPkpNcrqoBzM2svULTK4TRZuoZPzI8Di5K
         F6uGxGloYSAmyY21CYLzD0oLjDwUIySCC5eD1Es8VhzmrrSmnb/V3Vv9Xm3gwRMhX/s7
         9FifTNtDPqQVLy/W9CfEuIRTr2b8P/iH6tmmEdzKZ0SUnzJiH6gwp4YX669TAnqZDWfK
         EyGdfmPUE6CRh9gXKKe8bEL/ISCtkuWp4pndPb3CkbjxiW/D8TkAlHiRa1TMJH7EFFnB
         es/w==
X-Forwarded-Encrypted: i=1; AJvYcCXb5rPTwbY6y6hpDOEOUH/1OZx8UGndeinqRFA3v2Z4Jp2QEREr6AkxbWb2D5zOhh4yY2odACQS7Q==@kvack.org
X-Gm-Message-State: AOJu0Yw0jRVovaNBtagQ6if/tbKESaDMOsQMzichoP+jrvlpPVAOBP+u
	HHA5SPjF3SH8Dc8q01wGwEAouC99CV6+KmdQooi8AdN2G71NQAgHn47kqfl5RrMsqg==
X-Gm-Gg: AY/fxX42sxQdSXVnmsoZFZLpR6fvK0TVcFswBQz6DPRD4zj08/YfTFdjwrmTmMtJfws
	qm6djyOPBivZKyBvCw/yJ/y3DOQG9RP7yfeHG2KOfeJowd7ZrXFZxfVeVHjanriMAD02qwePXjO
	+YMrxDwN7feML/JPkjGX/5UB5dPhxNofFh4magOWl0qNM17Yxc2lUufQxGA3Ywj1xXJj5/S9T7A
	LS1uu7hTlZ5CLDQGc0zaQzvH0HdWzJuS5WqFDVLsJYKplLmHv3UE5gLlMAyEmJno49MZw9kZm/V
	dqrPOdOO/H7nR6P38qnNgVqR+gC3hi3aL+zwhmH5GmXSwVNYI2vkwOt/YO4AgEj4DylVrArpgNO
	K+/hHSeyfIbQIE1Tjh+E9zt+G470r07yFdEkGF5NXYAV2xDDl0PbVyt19WGymkR4+ir0sbASFYL
	hZTCEPeq6bTqtFM/w5tjKUK49GZ/IMSFPPTFlrWXtzUYBRYUfxFpTiPO9uTLxphA==
X-Google-Smtp-Source: AGHT+IGNnwivwQjfmTqXJ2XmqpNnhVh1B7HdunE/wMghXM5//G0Q0PvZKIaZhQtM/yNZ5AiSG216ew==
X-Received: by 2002:a17:902:c405:b0:2a1:3cd9:a734 with SMTP id d9443c01a7336-2a3e2de111emr15868395ad.43.1767673237876;
        Mon, 05 Jan 2026 20:20:37 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:f5eb:5af6:e88e:8a77])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd4bd8sm6665105ad.102.2026.01.05.20.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 20:20:36 -0800 (PST)
Date: Tue, 6 Jan 2026 13:20:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF3F8A0007
X-Stat-Signature: s1ehrnhdigwa9aqj3ktebkxiiuo6os5a
X-HE-Tag: 1767673238-997954
X-HE-Meta: U2FsdGVkX19z+bb2jKvKJrc7RvHXR7Wf8uFArK67gOYewmEqly7kobGhbmXWAreLl2jGn4e0MmvTRiV6Dv3y3ENJPyVSUDQoShdUJ7ibaRvkOnm9pUGYaPbHWz4g5vN2kC7/IGjPf3M4Mi5h1qKlZuMg9HItSAq46mLAJyLgBRorKSKHapMSXeUuutakerAwKLmo2/hB8F9hUfBaHS5Gre50qXoMsFRDkRnBzLjD2TKs43L46HN8iPZmXAhIjbj06bsmrldHanbf1XK3cc3imvfiLj5ebAww1WiMIvULZNH3APyyU32ZRqqdtc1SZpi14zpw7pod/y7PgG62KZ22Arm7qVKhQQc4hmgDHDL+xCP/tL2Gt4wySOYIdgXAA3Xxnnc6PBPlM77xtcwALiK7HA37IrvvUQI4OuKS6HnsFEeiB//pn+QJx9tF5UcttlJLjf5irpACU1q3m7CUgJF6DjRd9sewCRcVnqPorqdZiYrOxGLD/ptIBO+5lskBcY7wqLYagMMPTRoThgZDOS5cKTo9Z9leq4r7f/NrBgGVHoeYQDjqjvqbRq6i2FA/J+61wYj4rDQLxj/ox/z2dWn694h/JcAWcy/gDUBFctUhlhbb08lnqQ/dxGcSrsoti5NQTZqxwKuV6rFProW7/16vY0UklgeeeLG8jJd7WP/1uyml1ZtUgTyh7AWoziMCQLluA/3D2Wvp5pi3NecDFhMJ/6wHb1tdC/3nGiiYlI0y7KdwobuW0nfHD/rG3WH+GnfHWVNBuEpZnnMASbXUfWfNJ+rpesG9woqVNVXx1XgQInavpdad8coMLSH3OZCU6nXXXY4YMK1XPWvurQLbtSinQZxPQi8VL6puIzrp2UtD2DQkNHBMs6+Xrqdam4u7CnIEDEW39Rjk10yfe751AOyPwAEepLR+gEWgKWXyU2pHiJhD+huTLLwsYZRt2+RgDJ4TbikICSwqhw4xWUeKyVE
 Faqr+FwR
 0PEXQ44meRkfnbJFYMMBWFA8Fa722I5VCyIbDmBnzA2aWV8GAClmNtiVvODI2cUeL79nQwNc58jxBp8tVyd/AugaBirZ2OLIqGZFEpLWNVcL0au1S/PnZHvuca7BiUM/B+aauKWDOQCdWwBJsvrl7ErkHLAp/+BpG0/ixk8RlED0rn6pnRrcrJ96vavf6BfHJDIABzJvFzSMvvLSxKgmfQuDYfz5u9y0R+RjrPsWgkI1GLAtHNOA4NdzIDntLiJSSAl7RbWnyqdQmcfXAULbfVWgiFbYc0hrM5srjLz5gE1EWIg1aAESrsgs3dC1DpPjG6sJsn7Nqw8OBmD6X68kuo2HmMF7Lnqt2rHyqdTLF5zGdEQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/05 15:58), Yosry Ahmed wrote:
> On Mon, Jan 05, 2026 at 10:42:51AM +0900, Sergey Senozhatsky wrote:
> > On (26/01/02 18:29), Yosry Ahmed wrote:
> > > On Thu, Jan 01, 2026 at 10:38:14AM +0900, Sergey Senozhatsky wrote:
> > [..]
> > > 
> > > I worry that the heuristics are too hand-wavy
> > 
> > I don't disagree.  Am not super excited about the heuristics either.
> > 
> > > and I wonder if the memcpy savings actually show up as perf improvements
> > > in any real life workload. Do we have data about this?
> > 
> > I don't have real life 16K PAGE_SIZE devices.  However, on 16K PAGE_SIZE
> > systems we have "normal" size-classes up to a very large size, and normal
> > class means chaining of 0-order physical pages, and chaining means spanning.
> > So on 16K memcpy overhead is expected to be somewhat noticeable.
> 
> I don't disagree that it could be a problem, I am just against
> optimizations without data. It makes it hard to modify these heuristics
> later or remove them, since we don't really know what effect they had in
> the first place.
> 
> We also don't know if the 0.5% increase in memory usage is actually
> offset by CPU gains.

Sure, we are on the same page here.

Another area where we potentially could apply similar heuristics
is size-calsses merge logic: sheer fact that two size-classes have
similar objects per zspage and pages per zspage does not necessarily
mean that merging them will be beneficial.  E.g. if padding between
class->size and smallest possible object (when multiplied by the number
of objects per zspage) becomes a large enough wasted space.

But again, heuristics are hard.  I'm fine with us dropping that idea
for the time being.

> > > I also vaguely recall discussions about other ways to avoid the memcpy
> > > using scatterlists, so I am wondering if this is the right metric to
> > > optimize.
> > 
> > As far as I understand SG-list based approach is that it will require
> > implementing split-data handling on the compression algorithms side,
> > which is not trivial (especially if the only reason to do that is
> > zsmalloc).
> 
> I am not sure tbh, adding Herbert here. I remember looking at the code
> in scomp_acomp_comp_decomp() at some point, and I think it will take
> care of non-contiguous SG-lists. Not sure if that's the correct place to
> look tho.

Ah, so it does kmap under the hood.  I suppose that can work.

> > Alternatively, we maybe can try to vmap spanning objects:
> 
> Using vmap makes sense in theory, but in practice (at least for zswap)
> it doesn't help

OK.

