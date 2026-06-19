Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9A2CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 17:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40956B0088; Fri, 19 Jun 2026 13:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB0C6B008A; Fri, 19 Jun 2026 13:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D930A6B008C; Fri, 19 Jun 2026 13:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACC0C6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:07:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38B7516697C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:07:10 +0000 (UTC)
X-FDA: 84897292620.20.29A07B6
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F360A000E
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:07:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=PlxPadbn;
	spf=pass (imf15.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.54 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781888828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0p8Xg9lCiPpDoy4o3VOnxua9XkNhU5aTjFKL7L/TUUY=;
	b=uE3USSBf11JtDF/2oYTMVBPEhyrbohIXOQMbPXUYM6a5+lp7o44BAshzoNnaM+2mqX0xxq
	74wCUUBJDxNqQWhzm6n7PP2R2TRRsLIt3WbU2y4PLijirwesgCXzVGyxzYwyvH+nEePF2+
	xQGhpywNOfxtHSjK0hu/+JmzY1Gl9m8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=PlxPadbn;
	spf=pass (imf15.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.54 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781888828;
	b=JoT4+JtIPLC+FAERHoh6tSiyuhdfKR1Dt5Kzo7kbqwqLhT4hHDLhXVtbX94OZFFZSaUopo
	Os7OnXVWv3T7oZWSzrqN2etc2DPXSB3u9j1Uq99RCSeK3Xxb+O8GBn91JOgmYMzeLVwIVo
	CXadDGhY9gIrrdTlAfuFtM3jNnbXyCo=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8de0fff76d5so13066146d6.3
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781888827; x=1782493627; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0p8Xg9lCiPpDoy4o3VOnxua9XkNhU5aTjFKL7L/TUUY=;
        b=PlxPadbnOXaMInS+B02d0G+XsTqLP9M3VXd2sJYevyrhJ6V45DScBovOo1APjkEzaz
         MKaYSn6crQNIMKo+TygsMBE1AkL02/GpCzvJ7Y3M4QxvKVvP0zGI1kdxGNq37dF6nDm7
         OExrCUiYivgtH7HQWfmoIaF4uayjTdwtkYkyPuj9BCD8mtdlA6Qlv03Lzs2m9Ee9VrRD
         vhWyXKxUiGVU1XA7KgnsZR6+kjh4KWtzqtkw+pi9sfC9pH+W8QkUETCGCxm19uGFBd6L
         JJ1XGstjX+79cTHhaV3DZDwtsD0cV2e1wRWejB765REK1Xlh/1wfuMyFN52IaAB3hgZs
         4tsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781888827; x=1782493627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0p8Xg9lCiPpDoy4o3VOnxua9XkNhU5aTjFKL7L/TUUY=;
        b=EZgfApLGs9STvETJ8pbu4vT+BiAk5gDmFRE7umMjZYDchMRcDIW6e5WwS9tAGY7lFF
         QANmbWZD3relirqWupY64H74Tb415jmrejOxxpKLiTGcWvG87YDFQp5UHau7ii1Ab1zz
         pSqZuwei25/dodMzMEXKlsY/G0R2821W+pS8k4pU6kc3eR0YfLG6V2kF+SV5YtLWhYRN
         WiXx9fRg79trQf9qJQGapvtqh2FEVQZi2mZsFlddEIDQJYPum44FmYPJwahaPOYCuJdB
         eE0o4k4IGf47Qumf/trmAtvfwDC8z50tHBqT4IZZjcHr6KbMF4mKgSs5W3tD34vBwQLu
         dviA==
X-Forwarded-Encrypted: i=1; AFNElJ8W9a6y/puRGcaa6/CeadoygB4qIbWS10WPB8sLS6yoTwyVU2+UqBGl1MDdfKjKRGXNQrZFy6Q6Hg==@kvack.org
X-Gm-Message-State: AOJu0YwquvskKpz587Vgbs8mdwXbdcc7jYXqdSeqkRJRSxXdvUtpzK4l
	uqqC7YyTS7TIhz1CVB4PpES/hjSQK2IslFqjl1Ro0QGmaF2WxpfzrTvLUMSndYOD+Es=
X-Gm-Gg: AfdE7cnlL8Zbh8i/gYs6kE2ytvLnPutxKnbAzYXMUyqcUvZeqS2mFceUML4YSFAnBRs
	n72HVphqt9q6ngMI9lxbsq/J4t/ZhmQPe2LTvftCtul+h0IXIxaxxuGlCPKfy/nrqkM4nbyI4wS
	7DomBqUu00QlYwqbPNRDMyT5p7uedEVhsXlonRWmqVUeP5K01Nq4KFt8NnrxrNSRPC/CdIbOmAh
	AjE3oDmM8tlVCkzOz1ZzNEKcramcPki17Com9BkB4v3Vrcw10w7RX5G6DA+2CiVSgPZULVNc/G1
	VeXBJw6j+6bfOnzcXAR6toil3Alj4BsvocMl5dTgQKwoN6bscz+dA2055XrwRrCW6hSCgY4nBcZ
	tNduPBHD75+lmacFkBbcgsGaDkpMurmTTf0N9eS97KQCZD6jm4pEWN4dZbVUSge9aBrBSEVkdnF
	CHayOgTRRnVzxAda72RroZxW0VwpcGtsP3/Une8cUkam6AqR0Qqc2GI/bG45x4yJXWENqy0oKSs
	xnXPw==
X-Received: by 2002:a05:6214:600e:b0:8ce:abea:4735 with SMTP id 6a1803df08f44-8de42557067mr63574476d6.39.1781888827132;
        Fri, 19 Jun 2026 10:07:07 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df81cdf302sm5331856d6.30.2026.06.19.10.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 10:07:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wacgL-00000004qqF-3F1f;
	Fri, 19 Jun 2026 14:07:05 -0300
Date: Fri, 19 Jun 2026 14:07:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <20260619170705.GC1068655@ziepe.ca>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <20260618152805.GF231643@ziepe.ca>
 <ajVqRiAMG23QGseC@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajVqRiAMG23QGseC@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F360A000E
X-Stat-Signature: 5591afkawfff14zxttmnyhuc8tqg784i
X-HE-Tag: 1781888828-11004
X-HE-Meta: U2FsdGVkX18Cn9U4MJTkuOxU7Xz5U+lyAuGILloAlvzK3h96ADW3m6Pu1Et3wU9iUmjW72NjKZ5bjTbOYyCc+4MLbHWtVGm5xnLKbfTU5VEHPSthE6EgCwS/lPfI81fZx6jfeZIq7G1T2h0y26rxf28+hQaOmXaITfldMlLM04gKT2Q5Tc1vFOwfaAfDU/yW4GKnQ4W7b5DJamxzGs44g0e7ZUGuGYndSM6lwEi76zPZvOF5z7MrB2bhh3ALx0oiICEPbJKiTTToTD1EPKPsRxEwSP20HBmzFDREf6dsICE0c+dsIr6PpYtDQSJ+ZmyRBFIHsAxOZqyUpVIY8BE0pob9qr/KVDw6cwWrtyEyQ2W8KRxnHIZOracF41wraBcpdOfO7lwfdNqAIWwjC18BwgELkQkRIZUtU2GaATh9ekNS+eWxZfx/B7lgpaKnsFHn7fVc1AC9l9LxgGhXRPxB5L8qYH39I2xENORSljXeBxCKw0teI2dzDbl1+tWW7vst06YnriDaNkhIH6I6WAzyXdrY7+A+l2GQUFLBXsT13u/teOClMxkngYcENVk+2pCKKxHenAfTI4mP0sv1VgC/uFwu+VfvOFWBIsUMwIZifSEo+PXLkhqsSHOlXEFHzsV5gNL8jsIkaJagI91BQG/dDlho247T+cVzZA7LnixGeHdRh6sVPSmIZbv0LwcAR34aitGkjBx87h1KDo0KphrUQoLTzho6g630LwFF4vFLNkFLKacUQCfjyXpKIQeqbIhb7dCj4Gxlqybr2BcoIziZr+XkGOiLQK3JqLOflYZr7137fij0pKZRE0/Hk3svck8ndrHOHjrgZclo3J3ht17iP9yM3svQCBtplnQEpJllz/HyBMPr5dipfLbbjXMdhm4+7l4iVLDu3gJi0bJxkvlYHIezcEWPmFo14d+usqvt1FkdOHLr4Iw3nZ9dzUR7kRnMUegptYXlaqEDWGrT9De
 rGP4eTKC
 5Sp+s8e0b+dVjMhPnjPLn095VwbGlx23FIlFO62UpsumzOfuSoeuJMkSKypgQgtP75KVer+QkGCGRd8FzmExTLDw7g+3p9EaH3hpsEZg5AeTIu/2cVBG1CJ7p2Krh/kUu6QA8IwyNheVhRfSNppFcKwjZEz050fCYIjWqudw6s6uUrmOGspwgu9ypSQGYPnjfDf4Q6ttQuON9WstblAwwHeucWFH5exaAPziym/44m49SdgCvaW5lrL+8ZYNfrQKzQ4Nus0gqQc0W7xKxHeQp2t7fJTSeuuehdtFU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 05:11:50PM +0100, Matthew Wilcox wrote:
> On Thu, Jun 18, 2026 at 12:28:05PM -0300, Jason Gunthorpe wrote:
> > On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> > > Can't we figure this out from what the driver tells us when it invokes an
> > > mmap_prepare action?
> > 
> > VFIO installs the pages via fault handler so there is not a naturally
> > existing way to pass in the pfn?
> 
> Is there an advantage to doing it this way?  I understand why we (eg)
> demand-page pagecache, that's obvious.  But I've never really understood
> the advantage to taking page faults for PFNMAP areas where we don't
> really do anything, just figure out which PFN needs to be installed.
> It defers page table allocation, I suppose.

VFIO has a model where the mapping can come and go, so it makes the
entire VMA SIGBUS from time to time. The only way to do this currently
is with faulting.

The mm also had races around populating the mmap in the mmap callback
and using zap on the inode, faulting avoids those too. Lorenzo may
have fixed that with the new interface though

Jason

