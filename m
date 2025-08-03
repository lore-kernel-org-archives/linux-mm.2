Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152DBC87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 15:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6C96B0088; Sun,  3 Aug 2025 11:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0575D6B0089; Sun,  3 Aug 2025 11:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88916B008A; Sun,  3 Aug 2025 11:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7D626B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 11:59:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3024614076B
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 15:59:11 +0000 (UTC)
X-FDA: 83735905302.12.07D9B8B
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32F9AC0005
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 15:59:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=aAgGtNB6;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754236749; a=rsa-sha256;
	cv=none;
	b=CtrZ0aeO4u/E7pSsQAzfVy6y4k6ICC5tS6Rd/tFDYsyCCh1NPNcGvgVUri3DP12GVzAZGn
	sZizHqqwfzenZYCzn5n9DayTqKp7OKv/Hvm6Cm3STmbkjOpa2OjjN85v71RB7TkOg1cUtm
	vgc/v6Np5afDU6uVfmxIwuRsvuX8Dw8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=aAgGtNB6;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754236749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8slyx6E/zt3CNU5aqFjzFMTLA7WC2ifuj8UOdB6q15U=;
	b=59wJf6jfWkgyw33KYt2rKeogGa2x2yTNFJqpCmjklqijUcbc75poCkrIM6WnsiQ0kYXnNO
	q8tnArMrssf4a9p4RBprJfwe/vlLP1Egpq+3TazFZeiKLv/94byaauzGG1iDT2AfSQBxPD
	+ERt5/bq21KMgy7CoP9Q6m0gIdSweX0=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab61ecc1e8so15770121cf.1
        for <linux-mm@kvack.org>; Sun, 03 Aug 2025 08:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754236748; x=1754841548; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8slyx6E/zt3CNU5aqFjzFMTLA7WC2ifuj8UOdB6q15U=;
        b=aAgGtNB6RBqxtebzeMKOWPBHwSa+BJ7orF5Ihu3o58P9HkzJMcu2PBFN2Mp6EcTVhU
         vA11Ew0duFSLH8eT+zn4IV522eWXtYF5oTkI3+sS2k9aP6yLof69uGjTxK9W86Eevkn0
         nqL7ZNM7n5FG5F238BVGWLMCuFfH3WIisDOYUbqe96LzA7jlB7M+x+Qcd6+B6X642J/L
         lORs94ju2yOhGWEP9Totl8WfjbQlO81atjIpiGpfqxEibI48vbT1h2lvcKBrSQuWHMUS
         5/+MmZ9v7yrsik02NvNZgdubasnvmdYXE25sKx2UfH9X+Ea6Z1T87rlNw3bdYAJ9DW8R
         TSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754236748; x=1754841548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8slyx6E/zt3CNU5aqFjzFMTLA7WC2ifuj8UOdB6q15U=;
        b=pzsmkKofriaCTlKRqcdcg2586DqTKmW9sZcVwfo2TjhN8x1lymnVkpTOwuPyEJWApd
         pbRLCKNFQQNMdHtWAp8TOvfoIOzR1xH37Fr/CCQpn7qsrAXEuLOdBUlb/I2NPc7yPKz7
         Pmox7GZsw4jnko5qrPtX4WNFW8Nn7STta+/Z8wkCzBOxHn3hzdvhWVqrWPPBEtncjlFn
         a5DtGhD6+cLMuqPLh1IcKlpwA2QiAgzGOMrQPI0P4EiOOuSgYliQAr1k9Kn5JEUW09qt
         Ls5sy7FYBXxEJZIUUpeo05uqvGAZ5GqNgm6/h0k1Mmm8MGp8jd5s031IIxEra7kFX6OS
         vvfw==
X-Forwarded-Encrypted: i=1; AJvYcCWpVQmz/m347sttdolQL9+cUUP6ojrKgzRyU94OCxpCaKNW7oXvbFWIBYDwkXTvfmHd5v0kiLyYYw==@kvack.org
X-Gm-Message-State: AOJu0YyaTWu1rL07uJdhoMsUp3sdkeJzwlNX4mFKzTMp4YjsVtPfcyGW
	PXdC84dB5UXtA+E+s2VvWBCzaNtPxjhnZMMvQoErVLVPFIjZqv2kMpa+A0RWJE60OHw=
X-Gm-Gg: ASbGnctNgsYSyE4+J3H1aqxjfEVcJ60ZG5odjETUZKRmtL5lDR3oyefDQblMFApmcca
	awhN4J17byWvvv5+Z2aXZ/KzlAakGtg42Xu3OKHzaVwzpZw4n38fJQEeNLO2eut5CSEbvnMnqc0
	vnRNrb29mw1wkwVbJPcIlc5n6coBD9CqiprtwxV74YoupAEnDigTvhoNu1/2MJEHsgJGhCLHqCe
	vfXGHhAsaBgEKaTQWhA+0lriWSc5wES5VIJhtpvf7fF/sw33YjBxgDinxT4U/MP/JK0RG7L6w2O
	sE2kcU+Fjmeu/Q2C0EKO4wzxjOdzYKuSrykSooWW9XFK9PztJwdUKjXLzvdkr3cx+ZhRSMGLG1F
	ykYuqtT1/xtD2jO6n1tv4XFXJyoALSdW4masW0WUZCdlrIy4147uSDL+/GmgZIzUoISFO
X-Google-Smtp-Source: AGHT+IGXTSS5qgdnpS/eJ13tqSItmWfAUC8meUEvOe7mj0qBpcNtZfptB2QZRGNN4fnSPsBSKZwvXw==
X-Received: by 2002:a05:622a:1dc5:b0:4b0:6da3:26df with SMTP id d75a77b69052e-4b06da333ccmr13497821cf.29.1754236748067;
        Sun, 03 Aug 2025 08:59:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4af01e4aa4dsm29318401cf.23.2025.08.03.08.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 08:59:07 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uib74-00000001Hym-2XZx;
	Sun, 03 Aug 2025 12:59:06 -0300
Date: Sun, 3 Aug 2025 12:59:06 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Wilcox <willy@infradead.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
Message-ID: <20250803155906.GM26511@ziepe.ca>
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
 <cover.1750854543.git.leon@kernel.org>
 <35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
 <20250627170213.GL17401@unreal>
 <20250630133839.GA26981@lst.de>
 <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
 <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
 <aIupx_8vOg8wQh6w@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIupx_8vOg8wQh6w@casper.infradead.org>
X-Rspamd-Queue-Id: 32F9AC0005
X-Stat-Signature: jwbgzkw4o38bnfp3cow7qh7jc8n5g6to
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754236749-597228
X-HE-Meta: U2FsdGVkX1+c5tvJybZKgDrXdjo5+t73XS3ofW+Q0qr0vct/bh3DHlckc25jOO7RAuD/h8xLT6e0ZyjSR6z8lVXpfvI2iOw1fJZDAVjfNu0eC+K8qzM2OieUCo35ZjWzcXz9j1dAS+kmw5LGpr3Vt79DNWIvlY7ktDP9w1DXOnl27hsMlIoRH9aWOyz9kfwgIUpxB0yaps2q4gxWi1jgAnv09ETyZ98MsAKl3WDIhTpCZxLj5GotrNSbGZpYzVMwtodoqlHno80zZbJOCGawWgThHn4BrHPWlFm6C2bojZLTqb+iPgb/OIDGQygyQM8QjqPb5Itixa9i+RB8CP4GgroBnlkxFc3PxGMgZsfumhbuc4dpUOxuNTI5+33+L90oQilaezqeb88ihcPysWm4AXums8WzaWAQYu7FleE5F6jDAUZ6aUHiVjMQmuVtX7gxA6Tcbdr1TQIdhfAoxwDrwY1EG3esID+hWuH+MLnulLisw+ncyzju12ra+uTpUfD0CwfnRdqO4HbehiY2YX3JKFyk267DxnrGgHkWGBhmcYelAhgiSxMxGZWA5tchFejhqfJjVI7bPgYmAYIhN/NTreOTe5mkEAQH4pBzbXmx2wX6x8vR5yIcuRmi6RZvRDd3PBMssdgzrontSF8qzJTwypf/QqULDgDh8wUL2TJNpYJkOQh3phxGu+wgmBnLbnQdH9WOGUBVYH0OJzT8o8+ZPeO6BQymN+NRxxj1M7rMmfs6TXpb2686SfKen5hlTDQ8iAtxKENa33lXuAAtStQyecg31KM8hXnHheTfRoDe9islQF+15V2OyR5wZzyTp6LjvP2pPqAyU/8P2i/N1KBSj+ULj6lxfOtyBtcsQqMNvzQ39lTltIzmqARc81OWg6wKSUb9dYz46fPq5br3IcBw/GqaxPfuS5a0uxKbCoOLWyEHaDUdHRJ9c6yTVj7XiGbyCt36FOBgDJPa0cqzPaC
 UwImGxfp
 rHeehO6cOUg5KbJWMjcq+v0Ke/x4ck0DNXcNYo2qXqqwuxvN07LM0drIImonAaBwfzoApDCKf33P7epwkd3T2hGt/lJ9sbipjQ2sxVM/0u3ZcogcIG0Aujv5Ex0WmB/eGIU37UeMoLzHR5qNjRSFa895RY2g+CX41XeKPSrTlgocw7k4U8DStXiK2rXoxC42XmlBkpKon0ECx1KXEZE1MEY+njnhiMX/3bmW2ARmhkCVNpDT7U++8f+Xs2vVUQr5+t/ZAXSFUG/nb1aAuwH7oMxEpfqPxIxUPBiXS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 06:37:11PM +0100, Matthew Wilcox wrote:

> The replacement for kmap_atomic() is already here -- it's
> kmap_(atomic|local)_pfn().  If a simple wrapper like kmap_local_phys()
> would make this more palatable, that would be fine by me.  Might save
> a bit of messing around with calculating offsets in each caller.

I think that makes the general plan clearer. We should be removing the
struct pages entirely from the insides of DMA API layer and use the
phys_addr_t, kmap_XX_phys(), phys_to_virt(), and so on.

The request from Christoph and Marek to clean up the dma_ops makes
sense in that context, we'd have to go into the ops and replace the
struct page kmaps/etc with the phys based ones.

This hides the struct page requirement to get to a KVA inside the core
mm code only and that sort of modularity is exactly the sort of thing
that could help entirely remove a struct page requirement for some
kinds of DMA someday.

Matthew, do you think it makes sense to introduce types to make this
clearer? We have two kinds of values that a phys_addr_t can store -
something compatible with kmap_XX_phys(), and something that isn't.

This was recently a long discussion in ARM KVM as well which had a
similar confusion that a phys_addr_t was actually two very different
things inside its logic.

So what about some dedicated types:
 kphys_addr_t - A physical address that can be passed to
     kmap_XX_phys(), phys_to_virt(), etc.

 raw_phys_addr_t - A physical address that may not be cachable, may
     not be DRAM, and does not work with kmap_XX_phys()/etc.

We clearly have these two different ideas floating around in code,
page tables, etc.

I read some of Robin's concern that the struct page provided a certain
amount of type safety in the DMA API, this could provide similar.

Thanks,
Jason

