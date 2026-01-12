Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D351C9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF80D6B0088; Mon, 12 Jan 2026 08:33:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8EE6B0089; Mon, 12 Jan 2026 08:33:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8006B008A; Mon, 12 Jan 2026 08:33:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A85676B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:33:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EB81139CB9
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:33:01 +0000 (UTC)
X-FDA: 84323402562.10.B0C2F1B
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 60D0E8000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:32:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IwLz+ZTy;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768224779; a=rsa-sha256;
	cv=none;
	b=DTGj2jyRfsRGzftVV++Qn94d1+8EFHQ6vgT3ebGGUqOgueYBbHxr4wz0fuRbBTXYNMgvn7
	uNP2e21QV40ONBZorsE0wXg8xWCfMEQNVmQaZz+02DRnOiQ4KsZCJn/PfXpxWNvf9wyYRA
	PGLnH1Diehs9AaZ6MRvuFKjqqxbRt24=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IwLz+ZTy;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768224779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3OlMjXUkwUyc3rlyrTigWpD2j2oxQCnKlM2MHwQt6I=;
	b=2a1Bs7D1ItMVKNma5EmzCa8590ZqWiPbfGOpZZhejvd1l9jKh7++RhH7p480qc79qy0khi
	TmZKEBoiiYYBdjQTgYkfyNtw2/UCSV4em4UD6GYkbvnm+d3szrm0nbyi/XWcQ5ZeEtodpu
	+eC1tHya5cwZOSe34Z7utjFdtdV2FLQ=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4f1aecac2c9so65956041cf.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768224778; x=1768829578; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/3OlMjXUkwUyc3rlyrTigWpD2j2oxQCnKlM2MHwQt6I=;
        b=IwLz+ZTyNrJRFG4Ywb74vZVMKB8EO4RptlwsTU4175ueObKt9ETrDogCzVzwS6i/d4
         cEC3TWNPBbl0b1cHgb7AP7okEhdKuzPAAFYF4KCNwxK1JbFguFj4D4DGnYhMLqqTJbp1
         fZcVsgnpqP4h0BwTcPHdjKxYSuVu4Tl003DzOaLPgRjYFXVGpnx6StUsK5kHYJ0AierW
         0NdvEVYMM/nvNmH/5fgKFFxOw8lCx9Gfg0plZtE6u28Kf6YfnvFZHkegeVogl/ROJgOg
         ZytwUcR4fzOGGXnRA7qdY5Opk5ezWcuyGN3cq/egUFG64K/ImMDFw0ubY1OlAYTaPpkv
         NKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224778; x=1768829578;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/3OlMjXUkwUyc3rlyrTigWpD2j2oxQCnKlM2MHwQt6I=;
        b=bbWoEuLWgTaPJ60rK4tx9PH3jhe3gdehLu07oNEQ+C9syORAuot+CX/HBDUZOJQxcq
         t4B2tgTvvYTj6lNyaUvBgVJ2W7wsXkd+EGTzhf1I8Xg9LNirnaNCOc08up2IpKeYcJvQ
         Oghu4sNqLj5FG1uBlNbDbbCfAPv6vjOwBnBhyVtGCFRCX8XsTf6+R/S1mt8Io5vCOlpR
         VMtbAUv9gT0J/kBspDwXvJ5OsIt1pLP0edAkbdBkzDEQg6PTySlPr/4dVuo00MLw3bZn
         F/0Bt42Qd7gmBKD9zW9k2K/WPMn/vDAgE2G1H4HCLWy9HZYwZP2sHcSyzLA1dvIUVIHv
         E4xg==
X-Gm-Message-State: AOJu0YxfVK16N7jDOCu/Xm9diAm4QpAbMPKdNmAI/LCH9WM6mwAm7AFe
	B321wIuJ/wNdnTUIR3sh6DHaesC4NqgRjNTgHrUqnNKhHc5DoHTLv4MoppTuTvYsStc=
X-Gm-Gg: AY/fxX5nqHIpRtDsUsAB26FTKOjrd7rnInbnWgxObb8apPjvOzzD8bUlqdWef/tVJS7
	f15cPn/uU2TTaxwgj/V9C+dVXtnmkRqgZWzDVfSesGH6fl8SYcwEULQDX0vtmbE+jhXoTELkXUs
	QxEUXb0xW/BruhFJ0Enp8JbnJY8TsDFkcqp4CEedoqjV7iOkPQ03msUpMqUbzS+/5IV/3q2EO2o
	kRGesMVhOr4ugKNvlSB/3ewtRvspZS9uVLhfi9BvvE+PZvRFH5wQRQHo/iDCEr/rhFdOeyNX2MT
	WWM6vj9i0Xdj22n2RUBXXWwDiCkXVmVc/Y4qxMtmE8fWSWJUq5RVzYNVWHrksJW4tMucxOOdFai
	erw6vqe9ODuDSCSlrz87WvF9l7DFo6ZurnMZNOgxBRbrkEsNi0Z4CT+YnK1NRTfcG2hITVy0YWk
	npHslCFnjfNU/SxlkitrhWxK+MEJ8gOlrTf8PxKx3E6tO//Dv18vq4ph7jlpNVopycQUTY8+m8c
	oUOrw==
X-Google-Smtp-Source: AGHT+IH4Dcu7h+OOktsvfMPjqqK1/8N0YWz6dlKvurnb+htQMqLWJDpjuBE6cizrKIHyOmLaaemzrw==
X-Received: by 2002:ac8:7592:0:b0:4ff:beb1:cb9f with SMTP id d75a77b69052e-4ffbeb1cbd3mr144089361cf.40.1768224778294;
        Mon, 12 Jan 2026 05:32:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffaac486efsm127185781cf.27.2026.01.12.05.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:32:57 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfI2S-00000003Pwo-2w95;
	Mon, 12 Jan 2026 09:32:56 -0400
Date: Mon, 12 Jan 2026 09:32:56 -0400
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
Message-ID: <20260112133256.GB745888@ziepe.ca>
References: <20260109171805.901995-1-smostafa@google.com>
 <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca>
 <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
X-Stat-Signature: 8taij6xcxoydyx1rfhthgm5ge8154rek
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 60D0E8000E
X-Rspam-User: 
X-HE-Tag: 1768224779-633231
X-HE-Meta: U2FsdGVkX19eKeraODp4pCxCwpYvXVixkN7uGqhPmSqTOXA+JlK/vrIhIOl8qS0zncifLlWJF187d3877v17W9IV/Zeh/1wPPokHIOpx5C7oR9NhMNoGPhUen0wTASLI0APVYMipWX+A0n0jczp+bkkV306OyB+LOBC8t8dY8R93gCJPfqNHkO+SBMbriyzOef6XGjSFJeQ4OlKHFRw3d2a6qBkmeLGarPjdMBTwgQoGL0NTdWzhZN5kAfj+SEK6Z2McCBW7Kq7gn1FC2ql0TyM9NHpruv6imR4bIjaM2qG+He+5Vb/q0axW4P0FqM5QU82uR0aDsb9X5PapUY5AixPJMZ+xhZBvYK3Y9gunCNiPaeauHn1BbUOZNPZh8XIDA5v4Y71A1pawBLRLSHB0s7RVrntYMnzJ7tfTl63LzZwgnh7IZz9Xw70NvzSRaY4h0ZkGSBBKzZZy87rH2+8FLbjeeC6Chjv+zvQ/2vNvM8y0lyL2+HJTcYbM/tU4MV2FflyYXtM1CGDtjSkX75UbtvP5pXi0hKS717l8tPhKxgpVujuQLSA+XAlFJuD6jnUH8GtL1F02llzOFYmuet5+6JP4PjtD2lJ6KcSWsPUtNJ9IhLGgp2kmm6Q3wLLP5QYrfSjNJ+ss2TipSFOikiV5nS5QFk/liAXs4slpaI32ZhmBfFOSucF580arPNvnGJfj7lvEBNGyYvf94DcG1unWdEm+MXmWY/spKTb4kEK0B2MC1J1ceiInEs2yrb64vbe9raGskzUZr1XBVXZc7WViahMk3SryFRrqon/0Q751EPcdCowr0KyAu5sTypDOWZksai40uWd8p2Kekiqbh5r+VBRzF2v4ElyCHnO3VKoF9MbSwj+MT/LcrtZwWQHzkf3TxeFlXOsi+r9oVkkt3bN7QT/hX+Av2Q5dx00V2oWe9iYjMt7mMsfnwx3ZzDOsTfBWI66oyOn2ypFK20fJ6/e
 E4jECXwE
 zmx0K4YnwWVljO9AUoKgjw5edFArte82BFHpbkdB3MUPfNJ/77A4hxBWjDPgVCmJlVPcHGzQDTFb875Z3UnF9UtdvgvCkgyM/wAVFsd8CTQ5U74/TQclSkp37r7lAPtL7hfUWfbUAEFv5TRQo/vOk3XcI222KwANs14Gq10D58bjlU+XCI9w5TmxofdsL0uE0QNdWvdrS5E1OZ66Nhf1UsIeJePP2lRjB59k0935PXeaXS4iIERbmDKKyAyl6z9ld8Y3ydtyZwzxeONinXyfYxQV1UD4LsE7N7nlBUJGuA7pXWbKzz+4CB8Mz0wTROJoo4YMl0oxQy3y+jNjuUsqrdo/9YfCIB1Wa8BuCa4aZpWby0oqcDl9FsQZrXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 10:20:14AM +0000, Mostafa Saleh wrote:
> On Fri, Jan 9, 2026 at 7:51 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Jan 09, 2026 at 05:18:04PM +0000, Mostafa Saleh wrote:
> > > +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> > > +{
> > > +     struct page *page = phys_to_page(phys);
> > > +     struct page_ext *page_ext = page_ext_get(page);
> > > +
> > > +     return page_ext;
> > > +}
> > > +
> > > +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
> > > +{
> > > +     return page_ext_data(page_ext, &page_iommu_debug_ops);
> > > +}
> > > +
> > > +static void iommu_debug_inc_page(phys_addr_t phys)
> > > +{
> > > +     struct page_ext *page_ext = get_iommu_page_ext(phys);
> > > +     struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> >
> > You cannot do this - phys_to_page() can only be called if we already
> > know that phys is a struct page backed item and by the time you get
> > here that information is lost.
> >
> > Probably the only way to resolve this is to somehow pass in an iommu
> > prot flag that can tell the difference between struct page and
> > non-struct page addresses.
> >
> > But I have to NAK this approach of blindly calling phys_to_page().
>
> The callers to this, first will check "pfn_valid", which is the right
> check AFAICT (looking at similar patterns in page_owner for example).

I'm not sure pfn_valid really works in all cases, it has a number of
exclusions that can be relevant when phys_addr_t can be a MMIO
address..

So far we haven't been using it in the DMA paths at all, I'm not so
keen to see that start..

Jason

