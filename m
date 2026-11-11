Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2CB60A3812
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=cX29iSql
Received: by kanga.kvack.org (Postfix)
	id E54456B05B4; Tue, 10 Nov 2026 23:45:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BB56B05B5; Tue, 10 Nov 2026 23:45:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44A96B05B6; Tue, 10 Nov 2026 23:45:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0DF26B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:45:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 351ACC0209
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:45:58 +0000 (UTC)
X-FDA: 85421600796.28.E63AD09
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B55780002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:45:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cX29iSql;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794372356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxBc7udt7i3/+ft4HX8pY2dwrc5+goW7dVLwPsErWuM=;
	b=bWmxJfzes0v3dvwm1e2Ubp0dyIdnQO9rsMM3WawIUwh7Si0fv1HmlpkmEJECZx3puHW8C5
	7jC9/Q2YmgWB605GrGXHwcfgAuqqOfIDQl1O88aJcVr1JclEe9mDXGiDh8gCPx/AWdVzBc
	B7d8CRWEVG1nRCZSguEkOT9ATRbjai8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794372356;
	b=VRBNohN9VrOxgrQ1SOnLaGRB8ZtoZ2C6Lhu65OxRQwd8D4jUmDncEZ1E6DYbpMrvThX+n0
	rP06iLgg488KzB2SbByC3CEgICh1DWEgW2CUHBvNyTsYTPcnXIotB46Pt9Gd80GnUCGmZH
	BSV1eg8kwzmxXXW/YHh++8bMN0mLPWg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cX29iSql;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b10ca4e3f9so1598542a91.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794372355; x=1794977155; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OxBc7udt7i3/+ft4HX8pY2dwrc5+goW7dVLwPsErWuM=;
        b=cX29iSqlWN7OH6O4tu8VilY+rP/c9l0p6IknrVNm4W39PXn2YL1L/ZcKffUm5d8CzU
         4XufBNn/kSbo9lHINwGOXD9P/9NEFE0uxwVj4IdCtXaNanU5sNzw3MRjcLRG0zQ6EbdI
         CcKbbWlKhGIKQplQhdpDuz9y/fCH+aceV/nqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794372355; x=1794977155;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OxBc7udt7i3/+ft4HX8pY2dwrc5+goW7dVLwPsErWuM=;
        b=tuZamnXsrMCP/C6G3x7H2PkOgZOWY+EPIkJg1AOE7PUA/EKxpb26mRI/XzwHnZkLq8
         hdKAIjuAlFLI8FiY3rbsGgJOP4hI8Xs8WjbBAjc7zAVEW5xJDkU2zVmqZiXU3ZzEDTO8
         9AHcWojzFbeGdUNfW8NhD/NVYYe0Iw2c4aKX8SFWqzVMRgd79haxUpVYs9WaORNlGkW4
         aPqOloDGCg3Iut9n9Sh/NQ3/O8xeTr8vuu8gh5ITVae4xhgp70kip1ujeFqkob+/AcgN
         453D2PF2gzw3/+IwL8i622K8Nakpk29FddYPD38FoVKTfTehpsBwuGglICzS2O4nVPZu
         iA5g==
X-Forwarded-Encrypted: i=1; AL+hErFdgqT0p2CVFzGFhx95U292sDngYHCXmQur3V4msLuL8dn8r02KlpXms9LCREEnhLlynWXoNdSfIw==@kvack.org
X-Gm-Message-State: APuU4Z+jg8wKo8U1FrtrdUHU2xfaDLvuW75MSiTi/aDk+qME33WohXUE
	GpW3sjvGEcOOsxdnGznNQmDH/SKIbP4mOGkhj8h3zrQBfAEqo4gajM3H9rKjTbdGcA==
X-Gm-Gg: AYBFou3+WnTsswWBzn+NA2+Q+iUhen0fCnOTNnTOl2qxqNlUzoWDddHwFaaytSJQC9I
	03l3c2UJdx6ixOqGdw4vEvjisbXnzcqOR8FG8shhhMn5ZGGgPsb3DT2Lk714mORlQIppaOFXmD0
	KgyIt8vydPpnezguq/hrM1D7qmZBDotCTptqc4IPInoZ6VaTkLVlL4CYiRjjaTizrIV3veyEmlq
	DHvUjvCaz/zpPj5ucuCJL1FLQ/0ubFTpn/Z0p6RjsRZaDrX6LCdcX8H9x6TNa7qI7UoMgIedMUz
	PX7nCSoLxHQ+Xh+F1oK191NZ4KpVB7r6byYfHhhgeLy1bp6EquqfV483FV52wUXWYwKpDY4To1q
	2n3fo1hekF//SRxEFLFuG7Z9R5s5DLPfzJj9vwjNSLanUHPBhbzPw+zn/q0GfVahKURfw+b0ENc
	ONoWf8N/ojRkh8Jg5yALi1gu0sHWNqfTO297iupH48RDXr76oAVvy0lTLkE++b/nZOq31ENcXSC
	hZC4DJNiRwtl/4bkGvULjbmcBi8oIyorNSuC6imgrUAYyIYcC7mPWaOzRhGvipUWbTwfZQu4Tvo
	lmxAHeAvQK2v0gtW54kP2p91/9EB9RGMKBXvCfqc3Q0uY0cLIHBzeaXh/k/No7jUOWVgzn6y+nW
	9l/+UiK0ANSavYVo=
X-Received: by 2002:a17:90b:534e:b0:3ac:8dfe:8ec9 with SMTP id 98e67ed59e1d1-3b182f63112mr1181106a91.47.1794372355253;
        Tue, 10 Nov 2026 20:45:55 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm2707226a91.14.2026.11.10.20.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:45:54 -0800 (PST)
Date: Wed, 11 Nov 2026 13:45:51 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 08/11] zsmalloc: encode 1-based obj_idx so valid obj
 is never 0
Message-ID: <avPy0QUkvtzNy8aA@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-9-senozhatsky@chromium.org>
 <CAKEwX=OhvH80f-6emK0fBhbm2d4Er0rQ8oXX=FmfG0vrTdvZdA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=OhvH80f-6emK0fBhbm2d4Er0rQ8oXX=FmfG0vrTdvZdA@mail.gmail.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: twnu35t69htxq9c6okxjjasy9jqxuwpi
X-Rspamd-Queue-Id: 5B55780002
X-Rspam-User: 
X-HE-Tag: 1794372356-308193
X-HE-Meta: U2FsdGVkX1+n+b9xlwW+rx6HwQxGi7ZlgBbwMY25hKEKDciJAP4Jk4OUHCG8QB22lSFPegcHzf5NfAi5mWmnSezvktVsQydv2Yg7EK/Bs31P7XoeDMnmRsqxoJZB8DgKpNFbYpSt8tk4Cd8dulf6eYwxDN3SqH90NgYVItgDHiGeYSpgpo9D25LV6mIpy6K90wuRrEH2Y3Fb28lKh79fwKNf2fa1no6YYUh62PHFa8MYx0vR0aKFopAPJrlBw8VfDtlcLGDRioCOwwEbOtpjSe8Dk9GiF0Q4yVmwMSAfoHL4tDsAz+S15rlKyN72ur+KUEHKUtSBQxyTFNAW0RpnxXYq0KyIjUFjNm4SUlOn5UM3hgmG6n6qScJrjssPAmBfWAJByVHQwhLTbvDCZ4Gx7k59LwwzbEmubK5Fzbrf4mgFHYGcvuHIVI/gvpGYJ/eYTlVJfpHChwgmcwnbMpRmYKB9joOFHS6kjEHb7QT5J6B8xT+u7WAZutOydB+YrvggzbhVF/3DT2PkezGxqNsLuwA/1PhP0glG8o42RKxOiWLShenm6CdtMI8IwBW0CuCOzolcGsOSto+Jhb2Y2GclIxv4NuyrVAQHacWDe12J7Ug7wRtgclS01DSb+q/2HXcXSPAmnGWmSu5LARaqOxaloqBWYm0rpsPiFEF67QdvnjFLrJUu4gSklMp2esKumac6VcK8aK0VBzdhXfVdMWjUbzfvQkvt8IQI2q5zZeiyKEr5Rex03rKn3aLDeXuQnNRHBPijgT4BtPrtnnlOw1Kur34kQERFnhSBOaKUhWCyrDui3G9dyyEcbZVOu8vn+D16as1hcBz6hWHNvAE2iI2vCT5rJ10ImocY/jTZ7GM2py4nSGcCkCNtl1GhintsbVSYqGnaKtQ0nKWINmNdOHwmSHoIHjUzq9K0LPuTZ+BqXTLHpdUYbaBQQQCJnnJzS0IPHqsL+NcNFt9uHqB+m4W
 Jywl22in
 uuXh/gisnuehAwB33fLxupgFdBzAMjh5vWz1AJLtOl9pviH7kcWXezADz1Kk1UT6PSUnbBDTguaYp0o3El97Lu7Iq8kw7/QJ0uq8TkCfDWkeBY+CgWQEoIzg6J7bT1nGHNCQj0x6NypwXi44zI8GB5aXtc0I09dZ6oEmWMtAAaliNoOaJ/t66435u9FlEB/igdv7vttzPHwzrc6mHhJbweynXrAOBYx0A8M9fvnqhDdGZs33QSYFMMeFs8yLgG61/T81S2MK5K+DUA4W8pnfcBnSJmG7vi7qyq8NQfe4jE1H3Vzrksn7Jbg8243WDL8ZTzKBRZUdnoZuKWI4EQXDXnUPxPJ0VWUZzRozZbV2lMAjbCXikUpghJSs8EceafTQLH/dOWbURb3B2z3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 10:57), Nhat Pham wrote:
> > The next patch embeds struct zs_handle into zram and zswap entries,
> > and a handle is considered allocated when its obj is not 0.  But obj
> > can be 0: object 0 of a zspage whose first page is PFN 0 encodes to
> > 0, and some platforms do give PFN 0 to the page allocator.
> >
> > Store obj_idx + 1 in obj, so that a valid obj is never 0, and adjust
> > ZS_MIN_ALLOC_SIZE so that the largest index still fits.  Unlike a
> > separate tag bit, this doesn't take any bits from obj.  zsmalloc did
> > the same before handles moved to handle_cachep, see
> > commit 67296874eb1c ("staging: zsmalloc: Ensure handle is never 0 on
> > success").
> >
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> Bit convoluted, I assume the this is so that we can use obj's 0 value
> to mark unallocated state?

Correct, 0 is for zs_handle_is_allocated().

