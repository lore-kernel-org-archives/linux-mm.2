Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CBB606EE80
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=k8ZQY4DU
Received: by kanga.kvack.org (Postfix)
	id DD84F6B05B8; Mon,  9 Nov 2026 09:52:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88F36B05B9; Mon,  9 Nov 2026 09:52:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77AE6B05BA; Mon,  9 Nov 2026 09:52:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA4FB6B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:52:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D1E91A06EA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:52:54 +0000 (UTC)
X-FDA: 85415872668.01.607BB54
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53C00140007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:52:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=k8ZQY4DU;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794235972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMkO9oL77p5sRlwGpFl2L+7RNFhj/mskLD55QzNXito=;
	b=wPYWyhEPMQvGFBddFr7eydpNVvV76sVv20LyXaU4meVp3wwwatIepqYYJr8fYbe0NTpYL1
	epJXJVQ7Pw2WlXtxRzGuZPYyLBOjhxdX3cjM5iX0K/At0iHysEdxhWi5Kqu6r8c+8ROQ5K
	/p9ReqVYnajo768a/x4IfGdGnN10OB0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794235972;
	b=7OyuC1tb00I6coI7NaJF07GKtCrMoFYASwBqPQB9916Sirj2wiLRnXrviDuy7lpshxzp03
	jbQo1PQ3wwnTQuDgoBzBkG5phJ0o2bdST4fCjg08DI/bRql4KCs/6NLZoJ0wUG5jfsqN0o
	1jFiK31670JYU3BePEGBibUA52dcDfI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=k8ZQY4DU;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-537548b811aso7494251cf.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 06:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794235971; x=1794840771; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RMkO9oL77p5sRlwGpFl2L+7RNFhj/mskLD55QzNXito=;
        b=k8ZQY4DUus8O71sc1QYvnlTHAx2TymR4kw2flvdYQ0rxmzQHTrWxPE2h+xPiCYmQ6O
         i2T12K1gWpPPPHoOVSvFDNYu5nVtGfw6yO3OuViSqPmeEtokkqJNpGETuWhrGJnNVhLT
         heEuJQ08Tp5RH2ChAeRD67yrXgFLZW7FiFU1EsBu/oi0oaiy2yZ+kPGw9v4wAdBUfG96
         yEHyPwirSszFB5nCyVrcR30tH3RtkHhuxC2iCa3ThRwiaNv1XuNRj/Mn2/+xuNz3hh7W
         SKuXuKakH6eU3mL6Gl0EHMHxFT0+C75qCuUnX9yPm0e2BcQZmbyd7QTDtgPj+RsNrLDR
         kkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794235971; x=1794840771;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMkO9oL77p5sRlwGpFl2L+7RNFhj/mskLD55QzNXito=;
        b=1NIwIgM0VoYn0Eba+jT767PJbTAYOr1/lze+vY9ghD78IZe+0iKc/II7dCMQYlWHTs
         UmmAQHJGG2rLUyBjVCmz717VWuUTsFBuRP8MWJtA0RDK2D2bx8g19cYALV9zL/ybTjOB
         LD8iN3oCKYeP8OWiNG51w/ncx+pUEEyAd9FcEjN3oKT5jxf2lWpf053lGJjy6cg00NhA
         tqWASnPrQAvs1CjxOYF88oaNlbtZ7F4NNE9Pgyrktua72Si5xvf7uJCq0D5rxIDg74EC
         3fUXRezwZznrSzu9c2CROWQ9JNTCNjPd8IVT+kDuBWwB6UqtMicy02Q+Sz7ZDTMRLSlA
         tQsg==
X-Forwarded-Encrypted: i=1; AL+hErHaAuQ6x6EFNCpG1kkQhLv6hwGHwVNpqBWODGS7q/EnsDoJCyWymoAUgOdgAghj4L0Rjd+TrKOSVA==@kvack.org
X-Gm-Message-State: APuU4Z949TpPCAmXnNMolFVRDu4YIZSNhaNWUST2bfx9y2FgkAYT+ugQ
	dRucDszQqGLw2UMkDkMvT1ClFEr8aMsUQEZVHwgo11L3SaHnykaT5vjKolb9qqFoteY=
X-Gm-Gg: AYBFou2kRZAZ9dFjd1oyr1Y28Ra0oQYD/6fZ3F93Tjoud7JCcjI2j0mh57PA4SH2rzI
	fsWZ+HQjq04elp+O4bFYNW0weyUunR/a1J0rY1CdeXT8XrEhi9zQHRxR3AA66SneGQWWr+JvpDE
	AmKMDQv/mIZbBvvJ8saquSP4U1h4mcLvjtKB6nEhY21/eMxBtHdQ8nqgvQJMUSkM7bfNheIQgI8
	ePVHxIRD9E15hY2usLyw06qZ/VohoYiK1X//5YoOsbqAGn4++Bs3HavxfGwpnwmePup3LqnBCAf
	ZJ1kcveSG62qx4dY5C/a+CxJkUethimeBbmoxxdo+3N2mcw4j6hTh8M3SVXFDf6xiJioMvW5ttL
	WsxRPGOM1sup/rDEYMXI9a5/UsY0OI/AGoSDo/OCX43I4ixUarJy2URdjp7GBoIcilNBgFLWD3D
	Ythzu5Iy5Iw3tm9lr9nR1JEYk5mEEcLk+s/LAc8eOV8Lagv+LsKL9BpeMsBqjdXDgY41A8b5Qv5
	f4umETwJhq08ercM0ZxmJDvwex8Sr9yRs01sTLhD5pT5MUCrWOCq4MvWIoA03Dbq/mnwousA/wn
	4zrinfVUnjV8Wb1Iii9VP4ye84D63TWopQCmwv4zPxoU8RFn+4Y4zwxq7LX9iLKaXTKYMVZ+CDc
	bCe7q5HE7Esjs0l4EqnBft4eHrZjbIRo=
X-Received: by 2002:a05:622a:1aa0:b0:537:6f12:69 with SMTP id d75a77b69052e-552a6240a81mr63071801cf.45.1794235971214;
        Mon, 09 Nov 2026 06:52:51 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ece95b508sm43946716d6.0.2026.11.09.06.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 06:52:50 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xQQjq-00000001RUr-0lev;
	Mon, 09 Nov 2026 10:52:50 -0400
Date: Mon, 9 Nov 2026 10:52:50 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: Pranjal Shrivastava <praan@google.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Daniel Mentz <danielmentz@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Logan Odell <loganodell@google.com>, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] iommupt: Introduce IO page table shrinker
Message-ID: <20261109145250.GO663069@ziepe.ca>
References: <20261001230219.818128-1-praan@google.com>
 <20261002150844.GC3481470@ziepe.ca>
 <asMuigioXmHZmjO2@google.com>
 <avG97sxE2NFZFtvE@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avG97sxE2NFZFtvE@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 53C00140007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: giu958sqnqukzd4oi98wnzyanwxfa8wg
X-Rspam-User: 
X-HE-Tag: 1794235972-322765
X-HE-Meta: U2FsdGVkX1+vPm6Ymsk+B9uNyVbqlPlASEVst2gArXNRvPH62WpmPfAkRVz909hCsphlJyKEbnmPbp7uLCDBmjpijl2VolcThbVF/lzxbrFJ6Airi7t3YgVyXBnH30XSbcgh5Osub+vR+pebGq30DMVGyeZ2HXy9YNA246TLv1F34RD1F0vx65oBFNEilFa63IY7RGqcLZQMbPhWEvlH+s/dUa8Y5wSr0bIkPh1IIfxy4+yDK3SuykaW7M2A75mcrIJYq9NRCEGWWNo6cN6j3vN4awrMCtkyBt/1DjGPycGgccneuWVeG2Stka/4kaXFbZFwDGsg8cv+y5qSrxFnDN4oxn4I1fMHw0WS3d5cAN3drayjqyhxU9tPPGhhZKkDU61ZXeupIAqkQ2JX0poUL3W+OXghklQGiTyNwQFdBA1PlooCEDZTPkCwqu9ieTnu0lB1QQ98+fuJyAABkN6rvo0+dtFagtZgazJpPK7Hyv6FyXgf8WbJlg2gRt7HAd6A2G/HjxgJKPOIrOlnReqT+s4p1HsJfEAglY7MCh4MD/yf5ftdT7cZwnTb/NJRmsvuL8xN0hyHWvIQqVXpVAOvkuJ4rbo1nieNIeKn15INMuRUz4J9zLa00U1jblHPCNV9wQ72KU9nvYDn+RbAw8z04hvtTtTJf9Q+pHDlbBdIpZIROkO3QM7yARTX58s3SqpK+BTvjaFzkazZyARpP4Seo83keP/4CX7jKAxyfJdJF0ZwNIqYFqixO6zO6AF+sld73yPPOQ1iSSAtI/9HyHkLTcuUQzPMLrCVkeGTGTnTkjJcb5BrB2YqXytJiY1lU8NkzcU2fQcsdxbTiEj9b8WCG5Y1gRpzmFMno0vnTjJ3NYtkeaT7iYnMmDYOgMr5vgT+yJQZqQx7a7nu0TRVDsp4Lx5vI0Y/GBQiR2Z6d/kAhR6TlNCf52qSJEopnqFrsdUpqcz5LQJZGzu5sV5Or1t
 s+YRRMJx
 k0K5ero05jsBN+f/zjIeqRbP6RRg2hiIrf834AWX/Xc9VBgg7xEIpkOFKF1ZiFlNatkJz704XD1izHKyNvx7+1Bn3UyiXu/0DhgNzRR6sd1cBaXJFstsQMlPBFaHR8qHnvxpjs+qxzbXOAEdK0XS4w4As6rqx/xgX4OTEd4CUd5vvHrdNA05A5hOSpHP62tMWi1G2816sL1zXgPKnMabPkZbPpW/uJ7wlxeaDOHOhih5o+s3nBKehNSJ6RWGX9JRLPRYLj/Uo/qjxlErzihVfDS1k1AsYKK/KjlCgTkAHYSyTWnwFZiwebFNEiTx5ty7ESIorkoNgqxcjJ5VSosFqsElBKHEP8wArxtoy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 12:34:54PM +0000, Mostafa Saleh wrote:

> I believe there is a value in supporting other users beyond IOMMUFD/VFIO
> (eg. DMA domains) or even outside of iommupt, I haven't investigated this,
> but it's worth looking into either integrating the "iommupt clean(gap)"
> idea in the IOVA allocator or more generally rely on refcounting +
> shrinker (or other method).

The main point is to avoid the refcounting because that is going to be a
perf negative for everyone..

I think most people should be able to do a clean call, and if it is
routed as a generic domain function that would be fine too

Jason

