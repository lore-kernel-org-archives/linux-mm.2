Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E2ACF45C2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BDD6B0005; Mon, 12 Jan 2026 13:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49736B0088; Mon, 12 Jan 2026 13:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E426B0089; Mon, 12 Jan 2026 13:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 807996B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:27:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B7D28CB7E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:27:26 +0000 (UTC)
X-FDA: 84324144492.17.91F715F
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 596A9C0013
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:27:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=BlfKndVm;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768242444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cR4YX7Hi9OUrcU/fLtOMjymyJE7wlwEn/EL+XWyumw=;
	b=A3lYqehWn1RFdUi/HxCIwiDYWMmV7Efa9OZDthlcem5H0h0J2KaFVZIe9+7ucxm08b6fSd
	YUu0e0pXEJAt90GLLNlQctpy30J0z+CrPEGupRQjwKRS55yJlR6LbV/SvK/U0mNfaMPcLn
	JhOgtUF1UpyBFgCIlRYPP0XJ1Ln6cho=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=BlfKndVm;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768242444; a=rsa-sha256;
	cv=none;
	b=17+q/ZG0zTRaO1fnoHR0b5kWn9kqet6iEx54S3SE3zJiYpn8iYPeUez+b8vemiQB04riRI
	Md/OlTbvuepAz6F+mhJazAXEvRUYJBrxnWKzffN68nfgXFFMrLCgTUUmRsA2+3FCsZdDG0
	+R1x88oqlAJNaex4FF+xzEzZ5Vm7x/A=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4eda6a8cc12so77618891cf.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768242443; x=1768847243; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5cR4YX7Hi9OUrcU/fLtOMjymyJE7wlwEn/EL+XWyumw=;
        b=BlfKndVmtsQ+CpXOY8L0QREUT4qSQI71rw1biVWeUryoT5dSBNT3Kz8olNti/uFPVk
         y6AL16vz786+T5kDJu6+C4SBj6PqmVAkVVICDJWWXCBhufC5Gex9Wk0Z9hf7RGxE5h37
         5KGqpbd8RkNd41ZNXEZiFiOjns4eWuH2tcwd7nv61On2RN0KMgiPKgNvfiJDDzRU79jW
         /nEf3bwGrRi9hWAMGnbNLpeqMK/d6GUyBYSdVI2UmOCvv+wxjdg6xldOisBNPvad4FZc
         ZkIq7ybLoQbLaf1x5de62Z1lVZwbSlExxFShRGx40BlrVLHmjL6btj+1zsBrbO4nhOUN
         mf3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242443; x=1768847243;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5cR4YX7Hi9OUrcU/fLtOMjymyJE7wlwEn/EL+XWyumw=;
        b=uF4LADB4ArNYN7D30zaJYe2/ghlHz+8B2NM3/m09zCe2gC8IBRMm1T6ZsMY10HeEsO
         7TJVjrAo8DgU7Wfu75kg22YHTx5cGCvD52+2aKq6BpkQ5Q2hXdSAiQO0EW3NHCpLlz66
         6YbXxPx5ohYeH5imeG3PugLYAXjTVuwK5C/zFA7xCG/t4BKQBPZJQxdB2M8AhSJUojos
         6f8xToPS1d5zizSOLeYJtzgNIVhK5Gb1WxzN1gUDaSj/vT6bIT0shCcnwMjd0VeVMzHq
         vMl6r7JvHhes3BCnlCPITpeFhsTA1IUPVD99IEs4CNR4qApFLK5+NpmKNDGZNC4bu8J/
         RFIg==
X-Gm-Message-State: AOJu0YyyqX2zRn04jSSRPxf6S53SBoMK13NQNQGM/DPXKKG3PGcrdPJs
	sqof9Jn8L2hFT5beIwMPM3Mwlc/YGeWqSEhWsNZln3t6tZrW3pNJgsR6+lEiqXWDtas=
X-Gm-Gg: AY/fxX5kiVnSzxJK+xfWOZ6InjWlAhmhFpY1VzRjgXTXe1AH0W4RR/yiyZYrwJE6Y/v
	e0xPrymD5bIBuMjP+O3ESESfDnLm6jxtjhYUQ07ldbJ4pdW6yCE4N9SW/jhdcqJN0QNoKgD6tFj
	GCES3SW3QAoLM5u25UHjZ9G9aXK3OIzmePgfWbXlBPlZfZlNFcQPAH39clxXY4+0ki+F0Y5AoLN
	YA/UN7waFrO22iTnwQV+l6Shr62VxjYD0QjSfrH7hDaPLjhNOsYbg0yGw+vpP1O9oWuLIRIDtU8
	A5nzs3dV/euFI9GE0tmZVXB8URVmPO/2RoUhT1x3orSPLOI4kp7HyMfb5gj8G3fOe9yjIdk4438
	VHvH/60kQpXShFXijjagRXAiCv1qLj2wzqyRF70vUyhY7Yro61GZ8Z0a+tiYux259wIrJEWXdLB
	Hkh7eClvN4FladGHYxnHG+ei5wIZj9c0kowi9myLl7qlIcG+zbBNSEePsgAPRIze2SsCE=
X-Google-Smtp-Source: AGHT+IGVmZqeY1PHuUlU2eCkElvqVfhg5QPHXOe+taJKVCxnMmnVYd9cOiuxymw5goLJl6+Yj9TZrw==
X-Received: by 2002:ac8:5f8d:0:b0:4ff:c680:1076 with SMTP id d75a77b69052e-4ffc6801d70mr196421351cf.7.1768242443368;
        Mon, 12 Jan 2026 10:27:23 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8e6ce5asm130263131cf.33.2026.01.12.10.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 10:27:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfMdO-00000003Sgx-1Vjy;
	Mon, 12 Jan 2026 14:27:22 -0400
Date: Mon, 12 Jan 2026 14:27:22 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <20260112182722.GJ745888@ziepe.ca>
References: <20260109171805.901995-1-smostafa@google.com>
 <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca>
 <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca>
 <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca>
 <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: p5hnzjw8zcxsrkj6nbrhrqkeas4xkkqc
X-Rspamd-Queue-Id: 596A9C0013
X-Rspamd-Server: rspam04
X-HE-Tag: 1768242444-564920
X-HE-Meta: U2FsdGVkX1/lxef5WPhWLb1e/qd7tUxWdLufCmYppic2LjJ76d9DIblq3nfwlrIFevhycMyh3mfk67Rfe/2fP+sjxTsJvlMKlZJm64zlNt4oYo0YWfTUCwd5GMDRnl8uGSwhtsJMBMSOGdv/iwGlggCG1Yf3h31Py+ZhTd54SInR6M6jbjqMRDS2ke6Mr/euM+F+zXbzG487i8M+6vuHqCu3BIEzv6Qwko6gmObzzFqbGsfk6z8yt5hAfwuiAw1t9Ov48Lhq2vPXn+F7pYbixVcEifFcupiTuwXB0V6UimhTJShRBaop09rSHsQ1y8QrYQKE2Ce05j0bm+GaZGpcQxQ9z/QDxvAtUaOh2jB+qINigU66lyb/A4kqU/nA0ffGycXhNSeqAU8b0iwPf/huvn1nT35hUY2LOhR2q+GzlMRLEuNjk6zRFDVmsUMTbKxp7Of4Zc/Hh4ZYwPKhM+Mr0Bo+ZCrOA3HZix2L5ZObTHGPsdtAGGz5Mso1+AKHqGB4D3xW8I0B6NXiNcsauXz35JXHewGeom3XUrdSaSKFLdgkcU+VN6KUdbOzmDBlxpbjZ7OiI3ygGKA9MZmHTfjeW+bWEWOc5BieQ7eRqrhIHekgMGshSQmSDMVqfvsfzh13jA3hhEySxkV+DtBH8gXU+ILhz9z0wu1LFC5Am/5qfa/kBiFQUj3sdLzUX1EfpYLchjNm7pMEYDl4TyKI77hd4as7Knikb+M5LSDMYvh52fW5R2wz2Rnt3W5jvAIIFjPGJdBClmfkEdRtxasgYD33C7OqPZd+yfJCveBiO69GmKj9eRj4zq0QigFm6hEfBQea/05PnzWqJTvSSaMZUVx0Vo+tNjp5FcBJe8XeKw6IZqcYAC9ei9S6Ht+bvRXZr/7NcL8n9EYpYHfoYFSthw8NVWmJA7DydzYaHtswuHP9hokQAP9t3rIrkLos099spfqSoqqr3aZQGwDjYYbajaV
 ZIML6KpE
 +xTj8Q5G1A+p5VBurjdPGhXlJi2Ywq8XN2dDHsslXMBSVn2Gfjul7K6+1wzhSHd2CVy0d2G+shYbTJzQ0FQn4rwCirNvmQt4M5TMtvvClL62adWMFHKIFYwzK1s67mH15eKgJeey1qweyuugDqdrz5KwrBGlOQYLN8biAVzzqUCKenbeq79xWEwDeQ7x1I6g6J9vjkPO8oP+roDO/M1btlAg6nRU8rXGrvEaYDZiv2EnUfXYO6eeUpf2l5lnBEE1p6yAgv7o4Iy1s5SFvjqlNfyAaDkcI8gg+YKL+B6sJe8n11ExGbvUIQp2gBLqjZueYqZJ72xRtf9M3Lea0pynU7pdVZkdr7Q7oKSzl1ww3jOh3oTKLJj6GeCld6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 02:58:47PM +0000, Mostafa Saleh wrote:
> On Mon, Jan 12, 2026 at 1:52 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Mon, Jan 12, 2026 at 01:43:41PM +0000, Mostafa Saleh wrote:
> > > But I don’t see why not. from the documentation:
> > > /**
> > >  * pfn_valid - check if there is a valid memory map entry for a PFN
> > >  * @pfn: the page frame number to check
> > >  *
> > >  * Check if there is a valid memory map entry aka struct page for the @pfn.
> > >  * Note, that availability of the memory map entry does not imply that
> > >  * there is actual usable memory at that @pfn. The struct page may
> > >  * represent a hole or an unusable page frame.
> > > …
> > >
> > > That means that struct page exists, which is all what we need here.
> >
> > A struct page that has never been initialize shouldn't ever be read. I
> > don't know how that relates to page_ext, but are you really sure that
> > is all you need?
> >
> 
> AFAIU, if pfn_valid() returns true, it means the struct page is valid,
> and lookup_page_ext() will check that a valid page_ext exists for this
> entry.
> So, what is missing is the NULL check for the page_ext returned, as it
> can be NULL even if pfn_valid() was true.
> 
> But I can't see why we shouldn't use pfn_valid() at all in that path.
> I don't like the approach of using the prot to check that, as the
> driver can be buggy which is what the santizer is defending against.
> If we find some CONFIGs conflicting with it, we can just express that
> in Kconfig and disable the santaizer in that case.

That's a fair point.

How about adding a page_ext_from_phys() kind of function that could
use pfn_valid internally and has documented semantics for what it even
does for "holes" in the page map?

I'd be happier to see such a well defined API than randomly adding
pfn_valid() and phys_to_page() when we are trying hard to not have
those things in these paths.

> > That's sure looks sketchy to me.. Eg if CONFIG_WANT_PAGE_VIRTUAL is
> > set and you try to feed a MMIO through through that kmap() it will
> > explode.
> >
> > KVM can argue that it doesn't work with CONFIG_WANT_PAGE_VIRTUAL but
> > iommu cannot.
> 
> WANT_PAGE_VIRTUAL seems possible in loongarch which supports KVM.

Yikes, maybe that configuration doesn't run KVM?

Jason

