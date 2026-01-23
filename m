Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B91FD74EC9
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD816B04C6; Fri, 23 Jan 2026 08:25:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B326B04C8; Fri, 23 Jan 2026 08:25:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5586B04C9; Fri, 23 Jan 2026 08:25:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 642156B04C6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:25:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A9541AF976
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:25:26 +0000 (UTC)
X-FDA: 84363300252.05.4067E71
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 08D891A0008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:25:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HusFQjI5;
	dkim=pass header.d=redhat.com header.s=google header.b=nMQPm9pS;
	spf=pass (imf19.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769174724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dl7NlkiIvE4aCaKk0Pre5K+Ti7kNdoTw5jT1Cl5ZZAE=;
	b=H8Vpf9ATlEPnC7Q4MayBZ1jqrqWbTmGryFFr3w/OxpyHmb9fcF46MkgbGiCvQGYWIXu1/u
	qQm7zTjYtcpc3vgVsz9rqnS712dZYa9kNURa7MK6WTCfAgOA/RvVOqgzbntYEAepgvslxs
	JuQ2fWbQjrC3y+VKO+NPYEVaf7tXPNE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HusFQjI5;
	dkim=pass header.d=redhat.com header.s=google header.b=nMQPm9pS;
	spf=pass (imf19.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769174724; a=rsa-sha256;
	cv=none;
	b=wQfoPVaFDWygkQ6fp4E26iigqsjIjVb/zA7+ZwOloFHNJMIOrS+ID/P+B7rPEqFMFmSpu3
	tpn0+h3zIDAY570mdZSqOluraxLMw49oUYIYg2TX6qH01HKqGbon/49Vl5jzpifhsRAjki
	cuuHbV/x+gIPIT5uYXFISw7iXm/8Jj0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769174723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dl7NlkiIvE4aCaKk0Pre5K+Ti7kNdoTw5jT1Cl5ZZAE=;
	b=HusFQjI5D9Xt8EfLtJqPrl7nEzWku4PZRJ0v3Jzeq3QRchoPH80i8QDR4DJ5/68hqypsuI
	qxmQvggPFL8mlyxYVNe15bpQBeXoxULl2UGI62RdcTrDDDWJouMG611PnuxG7k2V9OOTNy
	ElSQDplGe7gOlJ54QMHBMRgoeqEQJvY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-BQYVFUXtNgqj9dktVQ9-6A-1; Fri, 23 Jan 2026 08:25:19 -0500
X-MC-Unique: BQYVFUXtNgqj9dktVQ9-6A-1
X-Mimecast-MFC-AGG-ID: BQYVFUXtNgqj9dktVQ9-6A_1769174718
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47ee7346f8bso14675765e9.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769174718; x=1769779518; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dl7NlkiIvE4aCaKk0Pre5K+Ti7kNdoTw5jT1Cl5ZZAE=;
        b=nMQPm9pS8z3t5gUylj9GCHTG2eTlWIAF7U8RVnNb4sz769XDYk2EMVa7qHZ2voe3rT
         4hgul2EOlKmf1kv4XlKPXGcRRkAdc0TY4smt11yPp/GsnDxOrnzSymTMyWG2X7jcgouk
         EtKsttoBzhtadcViybuAZythe8r/qqQegVd+uuLL/+YRtuom9no1Su5HO3zx1AwNSK1/
         m3E4AOaG6CBBWDSqcMSz+hAFJUPBPhIGiDaxq+hj/MTt2GZVBu2YGrlP+ByMT6DMHjP9
         yzl3sscS///USyQsRsRjQwS8DxT4l3tyiSVidXwSBVD9HeS0Cur/foJL30zqyxb4UUoH
         kYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769174718; x=1769779518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dl7NlkiIvE4aCaKk0Pre5K+Ti7kNdoTw5jT1Cl5ZZAE=;
        b=nIEUiNrrYgspp6JHfhbfx7/tlGvpweArjSEFFrI3Hvi2ZKwBgoFp8ScxOAOdK8IHWO
         7x45FBml53E8CuZY1DhX7i9EKs66zThJp68ofxlvm6Jy7xgEgp0538BpwWb4TYfmaqgy
         2YtZzXVU59dcc8aHDkxtBRVDiTEeCyc8CGoV/eNKZUVHKZ0tN1jrdSGLeKr6kGg8ugUO
         1r8hqBapqSWjBgKim2hJ8jS6NmAJlA3M2ghe/qcfgzME7rgkyRLhqaeqHscV0XjGmQK3
         J/put//y2LEDxt9AV2rbtYRHrmjIXnMhzWYQofPjxVTmc4C9NS+2S+PCSOu+Dt6O4rPW
         nAQw==
X-Forwarded-Encrypted: i=1; AJvYcCXks7j92bygKwIbSWq1f1InlYIVZUxj6BycuLgvqMssgNDN25ds+DZH5nkhJk3jVzsYX+H5zbSkIQ==@kvack.org
X-Gm-Message-State: AOJu0YyhNuYQe4diGM7ebECREBGPLw4z+7Nv3sdaYzTiHMtTovBQEkQn
	tfnZ8LbIuwtvibD8aBAJ7zB/j+xgaCZxjuvLeZqRAGEgO8epmAA7wXlUblrsQHUWl1Hgc1i+Hvw
	cRU+YdtMYTqdjxTUw2z4ZIUEfJrJlY5auT1WUyceOPOTmEFGW/2M6
X-Gm-Gg: AZuq6aJX97mVrPylapj3zGAMtO4ylkSppdcIT4YPiez+Qq0+UrLIGNPesAHop4yqYPb
	Mw8H407oK5NdxEoVxvGssgV0MyTgtEqYzsTdihDaib+bWuWovljoenHulWsG2np28DMkiFB+w7t
	Wgaqd/1mDL3ZlR3CscrG9uGoZLMDxVrxNLNAK6jjibYEcPrh7V8GqWk5DI37o3oI9OpcI9ZbJKX
	t1S1d/0SE5F5BWUXESMdteDEHI1nsRkhDpMtF25DprPOaKQnUAI9n0TgDavQqai/0YqrfzSx0Y+
	ETdhnwVqOqGmBBMFteqztxlzOmXTJwhY2b/T1UGsfA8efoiktPcZsucImzRBwQ==
X-Received: by 2002:a05:600c:c16b:b0:477:a978:3a7b with SMTP id 5b1f17b1804b1-4804c9b2113mr49821735e9.22.1769174718305;
        Fri, 23 Jan 2026 05:25:18 -0800 (PST)
X-Received: by 2002:a05:600c:c16b:b0:477:a978:3a7b with SMTP id 5b1f17b1804b1-4804c9b2113mr49821235e9.22.1769174717712;
        Fri, 23 Jan 2026 05:25:17 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804dbaad79sm21251445e9.9.2026.01.23.05.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 05:25:17 -0800 (PST)
Date: Fri, 23 Jan 2026 14:25:16 +0100
From: Maxime Ripard <mripard@redhat.com>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
Message-ID: <20260123-active-witty-rabbit-0fc5b9@houat>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-5-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="equ2x5ui66msv4bz"
Content-Disposition: inline
In-Reply-To: <20260122161009.3865888-5-thierry.reding@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08D891A0008
X-Stat-Signature: taa3hyyxhkz3hi6bfb6qzskuhp7fseq1
X-Rspam-User: 
X-HE-Tag: 1769174723-124776
X-HE-Meta: U2FsdGVkX1816arLA5dArWYVqDkmv4bTDvb66QY7bEb/mChlvtu4UFotHDJPL0Nhp+HZVgv+GOciBaS0ooIEPS/WT9pgrHUxv0EutJi5HX+YxaNWdf4HAuU1Gcdpm4Z/TQQxdfKY+DC/r5JalV1dv6vEEYAY3o3XT1lYZMfKGGFuLYqSKyLKavw3slHYyJdQubcibn9UFOnEMsSnLsWPGxYW3dRpCT+85zRdqwPElU44N5eqQ1rZXZVxJroMZQRSmxNUBPOE6lBLEV5l0Px9U84GQOtobFpJfO0KvPKKXEvcQ9guyjj0S+098Ygar4e1u6037c3QNn26OcrtBmEiL6Uo0LcpvYJc5c9HAEk7J+cGW6onBVAd5pFefraw54qlTrg3mBYk9u11ofITdES0JB9AD/qBCOT8F04TK0VGqyaIo/rAkxqNd7Wu67VQ6QsilDSVxNqN9MrHmSog4YGlHt/b0Wasr8lnEq2jkW2DOd+D+4gCmet1WtPR0dDsbgoUMcRJPjZcJblnSVi/vIfdCZtYVyagUzJIrl5yukhXsb1He3vjycjeOb0PU8xiw/yncHfnUc3yWk1dkxXmi/I3O4eKTBTux7BsKQ5b9g34N8EFuC6Q/XJZ5XWXcSsoeMxSwlEMJqLiYiKOmfzep2jPPFaDyXjRx7kd17hX5zJPrUdxkLHw8jbdnYDZzSOHL15g8EBcEC6y1We7Euuvcmx51CWkYJgSf+XVO3JU9QC2XD8pQ+rxi5wN/0s6yI2WOGIJPw0LlHTi6gMc4whJ0Wi8nKCs1V6MHYiYwA8Q1lR+pd43SI6eIQGKuZ/V/Ev36HLqfuH2hbAgUendRrRYzWwFr7bp7q4z/XGzSXO4yQJdrMcMyD2kEG6TT5JtHwHc27HAymAv52jOpBZ+ACy8o2fCJNBLoxGijdSGhaCrPmoWpd8Jkx5yPGQSz4Y9j6P2dqGHL9Xc5P5TvTJX6qBtNNZ
 +cAO1fvd
 /J+bVBGb0j3dUhIspblG7/8H30+sGQWQgfiFGfK0LU+MxfBLQqTSZQiUquai+hEcFYjIPtMjkX70VhQkirNb3xx+i4rxKwn33lLM6TqLsp8/S1tYeroVQVvcASZjRrLXHGO5qiSo2LNPIx00flj7pExNFZ6wnFpbJqaFBGGsAsAL/oj0epEjPPyOw2PTuEPFqJE1QNDTjq04m1ejNA59UIV3HTu3mBKM5Us+JLmJIDO2YBZRVND5wlES79QneIZtLxrJ6u1ujYxn/ZByeQZx8AjS8BrFH/uXOAbxIsOYJSNHahjuy3gds0VPm++5oS5auJjOL88qvNWUXmPiMgkEfSBH1aA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--equ2x5ui66msv4bz
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Thu, Jan 22, 2026 at 05:10:03PM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> There is no technical reason why there should be a limited number of CMA
> regions, so extract some code into helpers and use them to create extra
> functions (cma_create() and cma_free()) that allow creating and freeing,
> respectively, CMA regions dynamically at runtime.
>=20
> The static array of CMA areas cannot be replaced by dynamically created
> areas because for many of them, allocation must not fail and some cases
> may need to initialize them before the slab allocator is even available.
> To account for this, keep these "early" areas in a separate list and
> track the dynamic areas in a separate list.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>

AFAIU, this won't create a new cma heap when registering. This goes
against the recent work we did to create one for every cma region.

I guess, since you have a driver that would explicitly handle that
region, we should create some kind of opt-out mechanism, but by default,
we should still create such a heap.

That being said, it's not clear to me why the heap driver uses CMA in
the first place.

Maxime

--equ2x5ui66msv4bz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaXN2tQAKCRAnX84Zoj2+
dtsNAYD+XKsLdRQjkWGztlo6ccvGIarpCsAjHJYFv0zPbdpfdWvfyLFS1lY/kTQQ
0g9g6Z8Bf0j4St2GiD6RINFxEH7YvowARYnLD4kKLHV0CjY6XFcfRV2lK+cZmof9
IIFG/01OiA==
=as/Q
-----END PGP SIGNATURE-----

--equ2x5ui66msv4bz--


