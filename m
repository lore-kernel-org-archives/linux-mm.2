Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC83D2502E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD936B0005; Tue, 13 Jan 2026 10:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B45A6B0089; Tue, 13 Jan 2026 10:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0816B008A; Tue, 13 Jan 2026 10:08:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2E26B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:08:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF20B1A72E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:08:32 +0000 (UTC)
X-FDA: 84327272064.29.5184061
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE0FA1C0017
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:08:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OB5JUsuE;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768316910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zby18NWIZd9LikNKagpy2NdD5nLGxACKPIZ2QhLKgIE=;
	b=MTS8me829NUbF78WKyC35wbj+l55efmTpn60vrM+sa6x8FvGUTpBIBOXZY3IMZIN3+kOv1
	x1qFTWsXYLPQ8vBG6b7Pyf6KulEhsCTs6b2VOu5Bb808CdvTB+gn5pxnO3/4V/HzP+yxCT
	9IidYufldnFLKR3XcU4Dvu46O1FQj8Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OB5JUsuE;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768316910; a=rsa-sha256;
	cv=none;
	b=h+d1lubNnzqwZ+vma17Ry9vTkex9T/5cJMinbP9hDJSSOQClZQEvInRPhwsBalcdDqCLDc
	jYRqgofVsodzOm9nN3xSptiKCOQekOHoWxIntb+eXZ/i/HDktTctW5j5JW5xK2Um4+6T2t
	+QLLnJryWSEgEacOE50ZnQceEcXH3yE=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2d32b9777so1152471685a.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768316910; x=1768921710; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zby18NWIZd9LikNKagpy2NdD5nLGxACKPIZ2QhLKgIE=;
        b=OB5JUsuEqaJH0vlpRfW9U/3jnCZYxdBA9YhJKaYIR6dbZ6kFp49lyMmMwJgkp8OaU4
         UU69VohDAfmc5Agg1F/rHWVyN403R+2iTRx2g8R5mE4jWeQaezUzKiVF+Yd4lQMZBTW+
         uCCTjB5whUx9M57/eWz0BdEfiKxVZb0HWqGSWUPfCQVKwTXjK9RpSeLlVDpLAtmXrH/J
         FTDNbeoBYArvX6oC2Fbi7FSfqTuHAZ7bl77KcovUb1/bA8Vi7EeeAIGqkx+V1NIMTwzw
         LloGd368o29x5VDgNi2anvHJuJWpbLHL79AlbSt60uQCvVJd4jLyEnpVuU/LTxabHHOg
         ZdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768316910; x=1768921710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zby18NWIZd9LikNKagpy2NdD5nLGxACKPIZ2QhLKgIE=;
        b=Dg4n+SW48PFuPKM3kuKt+24LQEDexjOmt5RyIWmAy7StlcghZL0TPfFk0xK24euZgK
         qFrE1CoDjtEg5HkAOcZFA11g1qCp2TplvViAiTWwZq8vIjh+hJxqxL9kr1/arTynFTfK
         vWxDYRQyCyj3+95mr/shUJwNvGXWHzLWuAZNi8VbvjzuVzYHsb8l9Qb1QXkhq6wPZ1qZ
         K3WLuE6IEwUAjjRHv3Uj9UyNvtUB7edkanCdC4k7GHU2+1sYAYss/vltXHVNU42aB+wV
         VRnmeHxSJBQVrkJTFfv3ZcSuJv9f5Nv8UrOWG8gBvFOsIf6EB5DEuKU2ZGdPuZvPKjC2
         sLow==
X-Forwarded-Encrypted: i=1; AJvYcCXYD+/XpS0VZYLAcsr2HdxG2v6wNxsoTAauHi2jEM2eqUX572Sf2M22S6hdjhoUzWmbrcauPmGEbQ==@kvack.org
X-Gm-Message-State: AOJu0YyA9U/bcoAhU6tabaS+IrFH2ljNBJ+5mZCuXL9g7IMpQ5+VWndv
	J1nv2vGokxDJPRiS5lAiAx5k+O5Yyms1Xj9/EzCD19C48kcnt550V0z9HpJK708+ciY=
X-Gm-Gg: AY/fxX5tiHKHOTrQ8aHUMNAg/LykE57cVMWYWUtkhyYKvDJji+6rPENBNC5KFWnhzQo
	9OAUjhIT9SpkjHUzh3OcCdegFpjQUsHGrdrc3WpUDqLoKpM+qijmL0jDFMJXcnr9Esg8m55HSlC
	KvXTlS5ch//wRtGDpZX6nkkHnl8EoZ6gzU+YXfIovse7+KjGoQisjUasRVsOJqbzAaUhfJdsM+F
	TrQPI9Da6XXcMCV+19jwNemhprmrxivUf7xFyGqGuSty33awT+ydg5PKzTk0lU085jiLZiKLrKa
	bmrymDXIe+uTDaR6TXeU5USkIz6Q2fWk7qfxbWyR0H5qofNif8kLk0HuFaY5m95VDnqJqzb+tcF
	lGDATbcYptYWUe6TQMcJDqGpmFO6DgCQxXmPxx6SULuHaJ1RTzj6HziXiU6YKQHZD5lpD8T35VI
	2mZoxkxg2sY4hhS0ovbqguYjjXRAr5YMQt2jWZhstySR1IubMofdG7VXhhQaHXZHHf45U=
X-Google-Smtp-Source: AGHT+IEXQELOkUASiIG47wGrsPIeAZgzyEl1xKDO2iVvMsRIfq+sXO7FgFplrL2YHUPM6Jt0YgNMYQ==
X-Received: by 2002:a05:620a:44cf:b0:8b2:74e5:b3e with SMTP id af79cd13be357-8c3893a9e9fmr3015531385a.36.1768316909508;
        Tue, 13 Jan 2026 07:08:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51b732sm1696908185a.25.2026.01.13.07.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 07:08:29 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfg0S-00000003udw-1o8a;
	Tue, 13 Jan 2026 11:08:28 -0400
Date: Tue, 13 Jan 2026 11:08:28 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com,
	rdunlap@infradead.org, Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <20260113150828.GP745888@ziepe.ca>
References: <20260109195111.GQ545276@ziepe.ca>
 <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca>
 <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca>
 <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
 <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org>
 <CAFgf54pbkfdFr6biE8BiNKBnTBFWxXGmvxsZ0E+C1C44c9AW_g@mail.gmail.com>
 <482f2f36-e906-492a-a80c-987bf7359d83@kernel.org>
 <CAFgf54ovfnTHmMuZGk73SEEKsP3k-_exR1wqUE4W9tLYKv_iDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgf54ovfnTHmMuZGk73SEEKsP3k-_exR1wqUE4W9tLYKv_iDw@mail.gmail.com>
X-Stat-Signature: 95fnwkpokwa3awemynqg8k69oyx81tbo
X-Rspamd-Queue-Id: BE0FA1C0017
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768316910-567744
X-HE-Meta: U2FsdGVkX19q1F4lj3UgFV7OBJhSatx53NtR6+4Vx4q2vpcda382OCgIVrLJSBw6lAPDw+WOBooNwxLXpofKyY9creT3uxfOAm+548M2xB7fdBXer1tJU4dKjpx03tMkMH9BbHzia20gz0uvui8cdU48QBLddg2cBqiQWndiBjE3LDGU+4v8BTNuV0h1qrdkSbWqTLI7WdU6LEHWTub8by33mcMwCeh7U1gI2oWnkK/ZEUOzMtrxatlI52JIQsdBzAQLED3G3NoKG6jEeTs+NU4BRvPn3n4i4QUalv/chB7bTpP74z3TQ7y+YpDOl6TGXMHALGgsx5MDQcMFfRsKy27HVD/+HBHa7B+qDwHGoxEVK1j1Jng9HA+uz6QJGkQTKmTWvlwCWfzyAWOEnmAETnOO6OTq+dAKDR/+x9WQ0Ug2SNbZzW79dOqoncQ5D0Y1jqsJLNZFv03a8oGnOwLurI7sOuLD/NPXIloTYzG2B2GQvfQ3BdiIts4DNH5K3d3POwUASmZ737o5Fx9eb2GTZ0PcyTXcUicsOOtKV6Dv++nR7YfGYvIpHuykhriKNWMSZS6cFLbBCsb2SNlSdd3RNFn5SG8i+eXgEiirzbh9thYCHZUxJ6BFSgvq1K6ST6J5Qi+ukJeeF07XKBCD0A2BWTrYr2QCRkcMwW9B59XO1VxQ4IEFirJVnUFdoTD4jUOmxOWqqOp9eHvZ69uJvC1GOn8p0bSufB3+XB2b0fJH1MxgTVogrydinjywu7YB9/7SUnaWTWd53gWqcnOU2p2K/IC4uTChS/AFR2JHVv0VEAJZSQYpb0UN4OwKyK++80MjHwirHqLIYKb4qHSgcDWSkRk57QAJL3w/n7NeB6eHZ9v8tBpbgFfC22PxdJwXuuQkKC26FKcYGw5at1jdmqn/NA8WCGJ+mK4YssL5zOGyEkwIESZgXykq0remjS68IEnpo8eZT72WFq56fW3qU2A
 6mxf80IJ
 sWd9r9W2lVubJbFvzluiV1UGRaUoh0KBc136ufCEJybwJbPpK+C4atNXqT6ElnFEl5+YTBMIKKgwdd3apVxbkgWFuPzir+QbOusHSwRnnj3ONtxplghXYMfISq4i1iQpAM667zMFrBizCGfL9X7Je8X+vD+AwQGOXSPayW6ig8VboYnIQ8NaZV4E1YCZXJvbTdR47akI93qmVWY0tqOa0Zzwnmls5DHjP/djg8+egXJ17Qf5hsB/1gIlVSIvvxXWTgHuMPEYqgPKF8Gj604+G0qbA1MFV0eo7b1rS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 10:49:28AM +0000, Mostafa Saleh wrote:
> Would you have a problem if we added a new function in page_ext
> "page_ext_from_phys()" as Jason suggested?

Given the hidden complexity that David just pointed out I think this
is essential to encapsulate it in a function.

The function must be able to accept any phys_addr_t and safely returns
NULL if page_ext cannot be used for some reason.

Jason

