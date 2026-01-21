Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E120BD262B7
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 03:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542176B0005; Tue, 20 Jan 2026 22:49:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBF46B0088; Tue, 20 Jan 2026 22:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB716B0089; Tue, 20 Jan 2026 22:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31AFD6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:49:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A65CD1A07BB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:49:55 +0000 (UTC)
X-FDA: 84354592350.25.9C715A2
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id C1C82180006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:49:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XvralPB0;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768967393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XwGs2NEQShmLPNJ6sytAfHG5WIwbuteNH1FDfQ9bB0=;
	b=TWG2iJjtM8XsGiUyYDQgejy7m/cIBwVj3rW0A+N5iJf9h2yr2jMDuEK4tRoVOh1fIPwz7S
	pTO+q6PexOehH5MYTk1ZpbXVPmEtW96h20Qvg/6xZOcYK2XyZ3DYpY34vSrbQyJ6EiWffT
	9laRY/B+8QyCZybZ4V65ZKkALZtdeQo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XvralPB0;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768967393; a=rsa-sha256;
	cv=none;
	b=xfrkY1FUuKTxgN0IjeVDKmxD1H6L2zQ9p8/2emMDNIOVAw8yOzS1aLjQZLkRqynDR9DnTw
	gzjdHCayS2fLwJCBHz4P9JBqq/02OGcAwZBsA5xxtEBv2HX+bi2YabehannxNSwCP8nOB2
	IxjCcM+dw+moBF+pVukfPymW+nsJSL8=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-81f4dfa82edso2931122b3a.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768967393; x=1769572193; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7XwGs2NEQShmLPNJ6sytAfHG5WIwbuteNH1FDfQ9bB0=;
        b=XvralPB0rBFbUOgiyRust7weYku/877nY2hixBYpvhjYFEgdo1yUjYOM9yF1GivYaX
         Bdv5Okupm8MMn4FbRx2hlE1IRCA1sYOewd5sokNhUcjWNO8J0gHGhszYTmmNwHkt2ZZF
         2OdpKqx0dKE7PzV0Aok3CkIe5nU/n7ZIE+zTw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768967393; x=1769572193;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XwGs2NEQShmLPNJ6sytAfHG5WIwbuteNH1FDfQ9bB0=;
        b=duGqJrmUk+77wyPfIUJBBRanS4lik+8WwMyyMdtUxPoLyDz3zVTVjR/xmV43/elScG
         yBXY9u67P6xsEGHii3pUhAe17TUYG3zPXeH94bZ3wsTg/2JvDxW6FjJ2mBxVmfn4UPht
         F/EkCg9C639keYij8MKzWIIqSBWVaRqk8m4zMfjFigapXfVHg7EmJp03fcpPMmw/4Xnj
         UP07UVAEK5Kgevb4gJqzcAbI/4mC7RRrOqCtMRJp9S3QMllfvfIx0GMf7nAtQIAXNo2f
         V/VQyWfCcfTQZ9/HGbIYTwLJBE0raXHqr+QFAQCvjpW486JDSTI62nA1vmSHI2g44B5s
         x46g==
X-Forwarded-Encrypted: i=1; AJvYcCUes2aAkT8u4fdRUcQ5q846tOPVb+f3TAYodm92maTdjl8eO2jRkX1aW0esNUNqDeK1+2RrPXMnBA==@kvack.org
X-Gm-Message-State: AOJu0YwUXbpO3wOVNVh0fnVKFVtjms32bauUX90QHfvWhykHKVM46Ezj
	MpBgcySft2tetNz/Cd7daa+uA/ONODjo7aI46SQ96b6D/JHszUOuZ/b0yktRlLCdyO3P6OHum6Y
	HFBM=
X-Gm-Gg: AZuq6aJrDNKJ9R5aXi/xDGQopbF7koLITVHLNHEx2+ph0hF6pGbp+Jmee2Uq2cgSdRi
	fe01hS5EV8caXT3cIJ0Z+l7+4QQ/SoMNGreQ/M3YZGWl9x23wQWfsvBSu71AQx4cDVB4vLREpH2
	TlPWPRIP1/BvkjuhANFja8BoRYySILnGzyA5xHJQR50btJ+gp+9FdU87f2Ea5jw9+30uh9mEgws
	qUEegIzDDLEwzO9MBHpBrw9ANy7uaz5I0PL3mjJwJ6Hi1BCJHYIZh5BSd6syIgGOhAcOJbUgN1B
	iFNLSVPtblkPED+qNeJvIdf2nLK5FarOISOwLHEwAaBmUyYzPN+7ImO0FD1u76stbERsPg+fe3M
	9HchoIFTVrin3ljNkbcZwp5t5qLqM4frCucMDAtPiplAqmVtSGdiKNJtKrHqi3D0Yth7UIfjQw4
	+9ZwICL4dJOPtCP7s95OkRIMmJB2vxd3tas9/HywjKdfzYG3xLxA==
X-Received: by 2002:a05:6a00:1c89:b0:81b:c599:7593 with SMTP id d2e1a72fcca58-81fa18906c4mr14757429b3a.60.1768967392678;
        Tue, 20 Jan 2026 19:49:52 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:a85f:a6d:c028:515a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa10cf1e6sm13284094b3a.26.2026.01.20.19.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 19:49:52 -0800 (PST)
Date: Wed, 21 Jan 2026 12:49:47 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: zswap: Use SG list decompression APIs from zsmalloc
Message-ID: <uhugzqn3k46hchtk4srsa3uoml4ach5qpl4xm5xqdq6egesvq4@7i7phlkyzjgf>
References: <20260121013615.2906368-1-yosry.ahmed@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121013615.2906368-1-yosry.ahmed@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: C1C82180006
X-Stat-Signature: 3c9dw8yzxcuwh7bach4efzmsrcr9h4yf
X-Rspamd-Server: rspam02
X-HE-Tag: 1768967393-455902
X-HE-Meta: U2FsdGVkX1+qU59ZNsTAgVod0X7wQJ/GEIGMRk9OLGYtq/1IS3MDn3TMI7Bs0cTiJp3znoGqdjkYTezEwSZDu5Dk7Px/CoAgmaEmxDkSWJJIKbLC2kBrjsFx1pZA7iahzK+5QF4zXe8eo4+MVKrevskC8c5TGgshgLxwK5IM/p5/8I8DrzN19OUGHmpCmyQouxcYlzShVVmSVV2h1UQ5PtI4QoksO+GnS4kKDSzSDFLnur2twNjUeH6JYYgOtlFhkF0/ULk1xK8JEZ/57yJOLtzIzPBOYF0Uo5OTgdLN/TYSIYY+UB1S3/MRaiQbxEvxs0D3/EFkZdJkJNtQj05F7DOrbfIRS2ENBnQ34CpR9pH4IV3WgRncqha7inaQovAqta+7rNv1bSYM902iTIGS/IPA2DVzQdkVrNh5OU5GV1xueAhTwBWHTMob6eE3UmQLiqPVigXMJ/D8I6kdA1Cf4KAJuhFAhehDfO18L71ZZKhcfyVGziUC2EkqB11zpYGTX233WFGwCX9ycSasd/ldYwcIhruGg56UixKbAO0k6eg+T/QzOpF0biZ+G8vA635C50Daj2i6pfuIQlrOQIjHSsjV9+1ayOrGzigSxoaiYkaKFcIjYPcjEkXDBBDjJHBfITrAS+XgRmGxzqxDppiGg5+rtrbQMeJeNrfwCASkwwF6jLRoIg/KJUoNvKKdNrJL24+kVWszP4q7Do1Kk5D/sPhxwB4oXG/ic6o+nuC30rRoYJU1+eI011upZ1lKL1ePSk7urGBblIN3TkBcniMc7qZQ8xuUyQeHbl0goLJfrBuBzDVSVZOf+QYCagiwFK8zypUIN1PeoR00sLiimoywVlZjRA75PcKBU7t1CGmGacmohFyCLFTNrcBXXHaC73R5s0Dbff+yWnQmID6uH1TeHvQGzmjfSkhbCVGwG5+aaZpxX4Z6YlJXIrw4ajttwoABXSDI4wH16+UV6Si2L38
 RdVYOq33
 zQQauz2Vj1TJy2/87m0NRxCEbQyhinFbCXWFPDy78rj/vILJnm3WazsEZu3RornO58mdFGSwgzU/85HRBffUhzwB22kEXbmO0YTnRDbKse86FTTaqhwr7XArf2nuY3rQ5ZOzOOvV9xPYUpewnrWx8rzIWNNfHlhrZcQZhW8pAD+19VdRNDPZxbbw6KxVmXaZoX9mnKWwOFgpD+pfg1hHWt+7UoITo4YhtTicH2LVgOJeaGxsoTvi0Csd9DPPWNuA8Uev73XYjOfi6uJVjvi1uumPmRkIspfpqJWSxQsMN4+BeA0K9xgTdm84VLzm3x3bmihhKOD+Oic+DlzY8ELRG+gjZ98YOorWZR36Hu5By/CAVzis=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/21 01:36), Yosry Ahmed wrote:
> Use the new zs_obj_read_sg_*() APIs in zswap_decompress(), instead of
> zs_obj_read_*() APIs returning a linear address. The SG list is passed
> directly to the crypto API, simplifying the logic and dropping the
> workaround that copies highmem addresses to a buffer. The crypto API
> should internally linearize the SG list if needed.
> 
> This avoids the memcpy() in zsmalloc for objects spanning multiple
> pages, although an equivalent operation will be done internally by
> acomp/scomp. However, in the future compression algorithms could support
> handling discontiguous SG lists, completely eliminating the copying for
> spanning objects.

LGTM.

Once the API lands I think we'll be quite interested in discontiguous
SG lists support in lzo-rle/lzo and lz4 (most commonly used primary
S/W compressors in zram).

