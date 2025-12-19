Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B67DD78780
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120DA6B0088; Fri, 19 Dec 2025 09:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8396B0089; Fri, 19 Dec 2025 09:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBC06B008A; Fri, 19 Dec 2025 09:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D94A46B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:06:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADE6213610B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:06:02 +0000 (UTC)
X-FDA: 84236394564.07.2647AA0
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id A7D7680006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:06:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Y9GRk8Cc;
	spf=pass (imf02.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766153160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZMm+69u9x+z8ibStDNPIaAJod8bPs48RdpWzI/bCtw=;
	b=ZaR/lQXByPWgpz8rzlwawle/lhCPxac1VLkci4IDYHN0X0Ui9ztjFK9jGlq3NpqWAsjNyE
	RMbiV9YXp86jYzit3fkViHDCQJsNk3ef6R5Yr7K5esAhOTIl6GdJisZrfYGquPD9IrJ2fN
	mgqiqVwlKY5+AJD15f69+CL2Ccig/jY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Y9GRk8Cc;
	spf=pass (imf02.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766153160; a=rsa-sha256;
	cv=none;
	b=JBcJU8n1V2s1CfoNiDSpxFSlWw+5WSgnaKnN6p9lbvTuitrFFWUW0UG49s6OsOLr3W7vo+
	D7YKRNcDaOEF/lgcv5jck+CAEF3Qce7pOb+gM9RHQ1p7ZLI6Q3rTXgjFyTr8QVI0ekJHuX
	5O2OzQ3iyzZTF6cqnIkpaFsqrtqonYg=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8887f43b224so24534866d6.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1766153160; x=1766757960; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZMm+69u9x+z8ibStDNPIaAJod8bPs48RdpWzI/bCtw=;
        b=Y9GRk8CcAcv/Ii4ybwch8MXtNxh026sSrAG5eqGObYA6ZzdTiTTEc2HyilAYCZBBsS
         bdU9SWJWktJFFCqDQwB1GxyYdzCPkUuLkZuI+0Q+PRzLUnhcGl/CLF5+sjrh9m2xATu3
         sf9IP+3xz56T47tGtKzC4VxAr1AvWcwRa/XHmP8zv4p7/nGHqfAS6DzwZKZ1FbKSb2Yr
         QdcVT9nevv74RzH0v+kHErVvEpzUtrv4ir89d8frRMmr856xgL0WZL2Mz+xUM4WXHfsS
         DRPDQuJNSTx0VNvhqyZtjA6KT77ghgiRMZQCfmueWLtbHBbjjOJqmThKNDTrZNuUxhVn
         F1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766153160; x=1766757960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zZMm+69u9x+z8ibStDNPIaAJod8bPs48RdpWzI/bCtw=;
        b=FhmVqRLOZGAfE+58wFqYftyteOfL1tgQENT0GU03l6DPx9hr6qH7zOSKLOrrH+yckF
         wrCezBrrvXlFubJ1G04XgeY+hPt/CUcZT+AdZSsDnUEFkWujEsUN9V1FGAQQAQCKfpph
         8LJ1O3bE9sEd/e5iiLL7XX4VOKx6qnBnjzREZqMcBljR0grgSlPUUw2eAavFBOt+fjHY
         U8iG2em0aHGICg0bnNvMrwlZ8azvlMyPfxs1JfkTrzelV75AIZZKkprtpO06OZRtiCck
         tINT/MWJNgeE3szk0/QcDMI63fe3BhHiV5svsaRS5hvF2NKNYn3Kwp7lUdAb4lraKMXN
         hcAw==
X-Forwarded-Encrypted: i=1; AJvYcCVQRSpJbSRe34Oq1KpZKs/qvpJRUcjsYE6CTT49gQVuRRt9FA2I+IAYB93r7EyxT7NvuAvjIcLx0g==@kvack.org
X-Gm-Message-State: AOJu0YweXHvgutPTFerzeHlmRGPMnOa6LZK8dgAv7u2WQZRnbMnD0970
	bR0N8uVsJb7nuRhhMS+5bdZ5es9KbYu6a1t2xqJy3gPgqExK00QLx4WV9ElNFLOcg6RWoHwwnNS
	KAdUF
X-Gm-Gg: AY/fxX5cJ3GKiBuqKOe61l017izLYiwjogoVXx8Rka/YhuHR0nAmrbQWZtZqDVrRsHa
	yPq7BswBVfOUTJy4DXqnn36RDvI9YK8qeue/4q8+afyPA01vnPfpN2PTgPZnJOKXOGNimdZIE6N
	zZHti0JteY/R+eI6Q7ZlstyvcGYHLdUeuJMoxEz+10vYCf0QNJVZilkhpRne/r6GSzopbuppZwY
	C51iHeOsXOakZAiJ2xJs7vJz/TzPXkcllfXId//egQtuYFoKx8r9Y0pe6kB2vagHTmnmpV4z5m0
	tOWcYGDDZ3+zQU6exe25bibrQenjWUSv9CNJb8/EmGB8Dpac5oNO2mnYbkwgQKLyd7pgM6xKR0c
	Q+62cl5FeNjOjJDqiCPo3ujyyuh/7iUTRfn/XqebkEcop8lctF8HcipjAOcYDbiOBdhWxDdtFZz
	tSRKnIMJ44ZdN94/LxlHqm9aTCLAiTBmCVyOwM/rWNhavkPaN56qxLXN4b
X-Google-Smtp-Source: AGHT+IFvQBh34jY1BRicAO6irDa1zAgb1lDbuHzEzV01DhrEsnJRDHmMIYj0wyL099ZnzNEOzHLyuQ==
X-Received: by 2002:a05:6214:4ec1:b0:88a:3b1d:2f70 with SMTP id 6a1803df08f44-88d8166a292mr48660746d6.10.1766153159564;
        Fri, 19 Dec 2025 06:05:59 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0971ee182sm184273485a.33.2025.12.19.06.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 06:05:58 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vWb7F-00000001Y07-2SxB;
	Fri, 19 Dec 2025 10:05:57 -0400
Date: Fri, 19 Dec 2025 10:05:57 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
Message-ID: <20251219140557.GH31492@ziepe.ca>
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7D7680006
X-Stat-Signature: z4yi69thfh17jh99pffcowndkp4ah6qs
X-HE-Tag: 1766153160-199310
X-HE-Meta: U2FsdGVkX18wWbT+EKS3eHbpFZjJcGoeF76QatHheraLwqIRgs5v1ngugvO4qBd8DJqR60FsmkDLUerV7uJIZY2boLzekh5x/Tn8asjsuV2klKvbaueievdzGz9Pi4m1UbfnglSytWGO1K7N338MfxLarG6yv3N0L40Wrj/FcRjWDC38Rz9lUM+f29Us+C6jbT73nm/I/hC3xZPS0ewoM9fF/ykqeL7S1bjOT0P6CA4jZra3lMGmq73kh6Q9+lMsuNh5jasEZCQvbP0SC1hEoTdSJFb8u9Pj5Hcs+lAn4mq0THWrzYjM/7CNCjiDdRYTYywv4z1zLVuWNf0caegW/IuebuE0hp3B8uGuX2NWXjqcaPJ9ZcbEh6z6t0ouldfNTDKjowPtL6OU883oo1qN2lkyJChiVEXmrNNG38kwHI74eLW7dCBbxO48ZGHE27GTDXYfWm2T59k/L6f88drkvEzM/IFh/tm0uZX8ZIXhTMImkhqe0LXss6UdQG6JCLKhPZx3XBPufnnnvjK5OLExqoBjU1focV36ZV+PlhKLt5MDGtBLNIC1/eYVlT+8vuAtPymYBah11d1Zj3AreC6kddlNwm59/NfWGGnIWhBWXrtv2NGJLbCAS+czA4pBYxgupjljs/Wvh/NBRbNhYaBZB9nDUHk7cucswIV5sClPSUQxZEc5eTv5VFBKyR4xfeo1x9mH/pIcH4d4RAoEHaSU3VWWRzRmkmpADplYah+9JGZ+ss/OOXAELlXNQbH7N/bMi50cOOCWKPq6OCBD9JLoc4JM1k0Pk0c2Moian0yqTQYM+tyaRsmIEwQO7J/aVzrQ/0feCveB6aNrLiqTMyAWKR7Oe9V/laO03MtOo/NdV+Wvou2OMGHVkbHXdD+wyNZW7TjjmXDgfX9hi72lW8rj/p3Hmi1967IvECvMsN0D4hdbaZFXDQlcvTwsVEQwFzISLi6DekrucB7+de/WoUc
 3jYoczsN
 8TrvY6s4qcgezJc3Na9hpM3TaKcuirrTG+0FS9cFwEPqk2yB6E4y6V5j6yPlrg/NZmcKqRe2pBN9MzbIcL2QwFArsQct3ZSKtahM7KwfMpgAZaCtWQVVtd0xSXWtRDR1ARCQT996JH0UONpLgkMvGa6FoZCQda3hEl2XULLu6KjSOSt2rvpx5CM0uCjku6//y3hKHyBSnHIyGYgtoANcQVZca4bWb6Ghpv+aK7fDc0t77Xzkx7jo3vxIcpc+Q04M4MASpvzw0aQsN5JmgIVm6KyMTiIK/jKjWxUohpPcwLhsr3WMzcKaW/QSdLAIfNspRSKDCCXQfuUZWRbwW9YeciuE000U3IBADNody4dORnXUe5Y6q3rEPAh7YM9ksN3/9WOm95XUBsMnsz9VgYRQR1KArL6oUyxLcmjfZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:50:52AM +0000, Alice Ryhl wrote:
> +// For now, we do not provide the ability to flush the TLB via the built-in callback mechanism.
> +// Instead, the `map_pages` function requires the caller to explicitly flush the TLB before the
> +// pgtable is used to access the newly created range.
> +//
> +// This is done because the initial user of this abstraction may perform many calls to `map_pages`
> +// in a single batched operation, and wishes to only flush the TLB once after performing the entire
> +// batch of mappings. These callbacks would flush too often for that use-case.
> +//
> +// Support for flushing the TLB in these callbacks may be added in the future.
> +static NOOP_FLUSH_OPS: bindings::iommu_flush_ops = bindings::iommu_flush_ops {
> +    tlb_flush_all: Some(rust_tlb_flush_all_noop),
> +    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
> +    tlb_add_page: None,
> +};

This comment seems quite off..

Usually you don't flush on map, you flush on unmap. The TLB should be
empty upon mapping and not need flushing - except for the rarer
special cases of clearing the walk cache which cannot be detected any
other way than using these callbacks. Doing a big flush on map to deal
with the walk cache would be worse than implementing these callbacks.

The flush on unmap, at least for ARM style invalidations, needs these
callbacks because they provide required information. If the actual HW
does not use an ARM style invalidation system then this page table
code is not optimal for it.

Jason

