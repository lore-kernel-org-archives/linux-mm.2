Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ECF5E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 08:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 020B86B0088; Thu, 19 Feb 2026 03:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A026B0089; Thu, 19 Feb 2026 03:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09566B008A; Thu, 19 Feb 2026 03:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB5976B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 03:01:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 725121C4A2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:01:12 +0000 (UTC)
X-FDA: 84460460784.18.2046630
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 87D6FC000E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:01:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=cj0Iz9Qt;
	spf=pass (imf28.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771488070; a=rsa-sha256;
	cv=none;
	b=paiVd3vZVwSJ6E8TNgbyiNkrAyFrQ9A7T1p1HOe5hzQ0mnta9O8hm31HOrRK1Hio4liNla
	/8kqhKkbCJ79Y5afSX8KaMUDgi33oj+ZZ5HXP49Guq56aKUGzmDlR/dkhTRWHBlFvzays3
	QQKPOdnnHLngeDEmcLwirl5bmUzgJSA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=cj0Iz9Qt;
	spf=pass (imf28.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771488070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uEQ27jPIjOmpNod7ihflopMRb8gsNhXOZ78DPDWRDlQ=;
	b=c/Qg8o7ds/aYX09gSp58ZGcm/yiW3aeMIoEvi35v0ptNUWRL4OG059tdxmQHeUh+deVddP
	FwWdM8BFy0ggolAm8jX9balG/lLYGMzI5PmrT3dO+2MeIhS2MPGyvWXuZVXbgr+ZOPkh/U
	FKt/eHa34a6EhLBDBjtvxp54s0Uxe5w=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483770e0b25so6569305e9.0
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 00:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771488069; x=1772092869; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uEQ27jPIjOmpNod7ihflopMRb8gsNhXOZ78DPDWRDlQ=;
        b=cj0Iz9QtD1rdWG3xZjltpV8h41cdUCthZLq8iR1SbEuaITU9c4Pnw4yqRbdIeRCQsd
         NgtAs2G4eWKMS/01plMXZNPA6j7xsa0X/lDqmStNH/2rAF7QCZes4IWnaBHBB6L1Oz5P
         DtZaxxjVE4gKMlyAu/6T8JHNQA/vS1hLbl1Lpeb0vuIL2g0zZ5OPcXKZGUM1Gz9CPFN4
         2cD4jOEYrwWgQTpQWv27JC9RIAMHzGaG7E5IfrKwc8qXHprVGkoV+M2k66Ba50Xm/6D8
         FdFJ+z2PT+NoBAmxauOLeqCQRO9EATwqXI3FgOyNs/Awu+xxmwJ++1G5R0ZU8rBUSl7K
         9vCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771488069; x=1772092869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uEQ27jPIjOmpNod7ihflopMRb8gsNhXOZ78DPDWRDlQ=;
        b=LDpS9Tq/WVFqtcf2bvjpVpDwQEXjbQKjFJyQcJCFRkFuUBNpIvFdFs+W7SxcKnedws
         nZJIsKWToVp2iWw44nd1g2ERUHfnqO0y7CnLKjJP3McIp6TdFN1AIdSFkd589AIpcUlo
         PG9AVvQbiEVkyTkTxastH32xS20GnYqfgVifZyQ8XGNDE6sjoV0LeSp5OyfRqUEBXbQd
         g6LyHGO1LpRVltpf9WtJpw69YRrPqM2ckwfeTDUN3m1CwYciwX5M6+eKZ7rem9dJq2PG
         +GDSBxG+aS+mWvU2gL3XUo+qjRipNVgBoEQVlNdeYlfaHbqtMEuZFHA70Fj7p6akoU+Z
         xmcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwTHIUJf2MWPyJSiV3DUoxJ2dw5EyGCy6nwkT7nmzN4e083wT9wnIsFQ0iO4rtJmpTKJfEW5onBg==@kvack.org
X-Gm-Message-State: AOJu0YxP9FOkEy7r6lQAQ9AYvyBQjHzyTNR6R4eU1q0nzuo0m5hoLEzv
	DlVhZYjc68UvSUUPN5H2DnlcbA4JHSvKRCiUu5/qiltJRB4mDpxNSnzApvw0vNExmJM=
X-Gm-Gg: AZuq6aL2YAZeldGpdvq3HGpze2DTr2o13Z3bQ3j9UhSnK8X0nPZn7oM5jDbxkr2HdB3
	b4zd6nzmk8ZNiR1lhELLxdP9S/pFhkpJPzAiKrX6ZHPoWLsyxKmpo30EJX2PidAuzDQ8QCKAVmP
	mHKQsBTUHJYWPDTOmIz1eEfmhw3Qfk2viPqvb10rWyLRiPXBGllRb78RpxwAumh3iYupe+bw7vB
	ym6c8yj5ougr/9qtppqzMMvZEpPUQHltZ/SDGCnLBPJ1WaVQTiP+IPVobHiZrWKcaqZR275fgWB
	hu7YumXTQeIyoHOhFiloe44zBbKW90WJxG+fYVM3qjl9grdGlGG/lf9BwZb9TYAbYC4/o+04Pti
	mhRaK72s0A8e6slqYXVpZ/pWkv2WLm+m5qSjjvcavWchU/SlsSmYdlgjaglFfOpb6WsZCdFuwzg
	d+L5ENUYp5EUTBfKVXYHpPU6SvsU/HX8XVI9+/sAg=
X-Received: by 2002:a05:600c:1381:b0:483:ea6:8767 with SMTP id 5b1f17b1804b1-48371098c8dmr309544945e9.36.1771488068588;
        Thu, 19 Feb 2026 00:01:08 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b68e5adsm461946265e9.9.2026.02.19.00.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 00:01:07 -0800 (PST)
Date: Thu, 19 Feb 2026 11:01:04 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 1/5] slab: Introduce kmalloc_obj() and family
Message-ID: <aZbDQLeMsHCv32X8@stanley.mountain>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-1-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203233036.3212363-1-kees@kernel.org>
X-Rspamd-Queue-Id: 87D6FC000E
X-Stat-Signature: s6u3so8h6dc97qdbzcqod841jsfnnmah
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771488070-634528
X-HE-Meta: U2FsdGVkX1+yJoNRAQjjYKct6lJ1VzuaQeoUKvNTlk9XcIvQwydMiNSTa2tYyjeejd/SSUGK4K08aLlF+hIVxIYR04uy7m549e+nfcdoSBUbFmukMJaXhbiijOQvMgWlfnJn8qn6gqYMImqtuiEUmVcv11RlcZgOpCDCPHLCqrgAhxpFPlUvj6tXYH8RU6dAr10hgNsE2IY/B5xJtZdbOMfxJNdppWEYNSJZxQzZmQaKN0em2ZuL6ow9C5YC5ATgChmwQIABQ26XTiktAj3zrHmESd3vPKoprrdZp/Mc0XdPmIUcSVb31aHycVFGJiWxewRm/dyfXqiREipUcFFkoIr59CqA1Ljl/xyAX5gfIwugSJ5AQgUA+W9EQSBtedogtE9Cw6qeI0XObXDAgsGbyOLoG+BFjkQ8jtAWCvh4MChmpXpJ8xdByu4tHmT0gBRfmhtmHBhNc/yoDDr+1SUtyaWH0znFguDqSjKs+G3VKlLbP/oK7Py9yTSwcVTTh4ZXn90wGLYzC3MDwftM9xqcOCS9+EbI4xdbMVm1eeyAe3ipeCh6LXhBgbeKJ4/a+YjaBYfWVYiNq2xh6BeBcsAR0LTKBu5ywl5FejTH1KJhbTt3tvsP+rKDcllWc616h5m9XxDgMbKryZfJ5r+rUgvGMaRTN16TwvRr/u90dWFkNKzIbdmeL3Az96uY4URAsnHBNe5gIO6/KAZ5HE0ctfJHSrnacQQcVYtKyDtMOnZkQ64/y2b2791j2+M6Gde67JSm2qxoMnAyjnZkcmIxMiZmHZxsf0EFr0QgMI+86jTGrqCcXLy+NmrbSuHt4TVZE4pfXHiQClYeVKk9MZFkrcvLwDLwZK70XgPykclZzRu4iz3eX5/O+mCJQfZ5txh5rR6pEEb81lNglkgGvjgqcEaI/VJwOaSZdShYxpyOylvH1svR1iJxjfUMg/MgTYuJKD1Ckedp2TZhXAyjouzwyYe
 isy5xNjI
 9oFMt19VJbVh3H2JJ2f7lklBKQPcCNLmJWiKOilJEXWGzcSi+HhhMenTS2aem+Jg+JQNfK9aW8+RcYVYlEeXY+XM637tktDggeuuCoXk+X2KkO3Ats20flyF3njR9nQ/VA6JoRCecGlyElUix6e1gXCpi9ALsmB70h4IpGKe2wQAsX7D/F2f8sKsth1yh6KhrWcExzLSgq5+b1RjDK6o/q0RlRejkqXSti0meEV2rXfEAvbrmijNZf+4GIGYqh0WYuz+gJCXJ46PGura7USo9CqZczdUvwB7x5dBFFkgnhE8FKvyE/dQOZwVeHXiAnkunzDeN+XE9JhJYcs1RaSKZNojVsHNYuJvM8zmjTAmr1k7MyqRMGrfoSDmaO1arBF9KmNDWKcYgMS9zsMroECyx9gLB2YAJAuHjZnx/PopPbXmjs5Q9MxJa1VUJz1UPoseC7ehB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 03:30:31PM -0800, Kees Cook wrote:
> Introduce type-aware kmalloc-family helpers to replace the common
> idioms for single object and arrays of objects allocation:
> 
> 	ptr = kmalloc(sizeof(*ptr), gfp);
> 	ptr = kmalloc(sizeof(struct some_obj_name), gfp);
> 	ptr = kzalloc(sizeof(*ptr), gfp);
> 	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
> 	ptr = kcalloc(count, sizeof(*ptr), gfp);
> 
> These become, respectively:
> 
> 	ptr = kmalloc_obj(*ptr, gfp);

We are already getting patches that covert these to:

	ptr = kmalloc_obj(ptr, gfp);

(without the *).  This feels like the obvious bug people will introduce
with this API.  I sort of think that "ptr = kmalloc_obj(ptr, gfp);" is
more natural, so maybe we could make it work that way instead?

regards,
dan carpenter


