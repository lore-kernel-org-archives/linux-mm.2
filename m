Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E7FCF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346616B0005; Mon, 12 Jan 2026 14:17:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4736B0088; Mon, 12 Jan 2026 14:17:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200086B0089; Mon, 12 Jan 2026 14:17:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C27E6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:17:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 968D6C388A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:17:45 +0000 (UTC)
X-FDA: 84324271290.15.99134D2
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id A4ACE40002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:17:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IbLHIgYq;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768245463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79V8FU7VojpzuezWKGikKP+GBTJI3ooJk9r8kmAFP4Q=;
	b=aZD4FBagW9QofW+R9HnFxi8y9ONXJsLpv/ukUbMb/v6PIHTju20Tt9jWDakyKB6ncxwju2
	51ADx5yQs1Iq6vY+pul4TQczZeD8v2nYoosqyIlcnVlZdueOgbB6dxwgFZqRLRuYEd4aQW
	yhT5kSPchlrfbzZreawAdN5Apf+VXbc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IbLHIgYq;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768245463; a=rsa-sha256;
	cv=none;
	b=Il3kV6sKRC3fCW/cmIOqcryZlKUnP9YsjJ/K61sKE+c9k2kXjfF6oyAUcBP/4WzfH92LJq
	MUKyKglVbe1cjniYLnovMjbnoBiZsFoQ6pruICauJXzDb0WbtzMS4mumwBQl1zq1SDbltz
	c93Il5TsSxv1zNn2x4AN1r3aWASLkns=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4f1b1948ffaso45624381cf.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768245463; x=1768850263; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=79V8FU7VojpzuezWKGikKP+GBTJI3ooJk9r8kmAFP4Q=;
        b=IbLHIgYqSZ0YectbpwcVocnlL6tbBOafXOQe0HmcfIthXtFOFEDbAAYAEDFdWyyKkH
         pLG3nhOES+OIRLp2XgX5/GX0rxegG6Hccyj+4aMrrCqYxA1CTFgwG12wtizko3h9F71+
         LLzYflWRYT/d7pvJOeZ9k1xzjc8JOJdJpRqQhYxkV4oTiS7PhipTuwGCGuxYiMwpFYAn
         5N/Qla9uHa9zUnuEDyzZm+T7yZUN3+OtuBfQFV62qHxHu/k7Gw0HehNM+x5qkX2hzloC
         VLFZIzL38CUc5aqwhFXxgen1Yz+bY8Cy+86WMrl+ZC84uLknwuEWG+lUY3V4o00XXrBi
         nKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768245463; x=1768850263;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=79V8FU7VojpzuezWKGikKP+GBTJI3ooJk9r8kmAFP4Q=;
        b=w/YXMZ23nXXZkATOXzUUoiNhvNw4Iu28mrFkUW51OR+Bb/+jv3qYcGslfTTxWjk1gS
         peQrx5JmAMHMPMsZfARx0jg8IBAseOw0ZFslN2lVPFcvKFQLIr8OQsN0jyOdRsmdsllK
         jLF+d/dONhhQlwdeMIvcA6Rjx/JJ/oCYG0maF2v1bQmlJmNlQX9QH6b1sbrCBbiTefXE
         r9rUPkskS2Umodq8JLyrTqqQA6AvFKHcebbftlWsmsq/7Cep4i0JOABbab3DScPS5l7/
         WZippvc1KRSnAH2kVq1mggXoHAEJAkp1mZJ82L1eK6saowI1xjjZvMuFMHS6f/aK1Bmv
         /7Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWzNCeUdTNs2N4gBmO6JjbUSmmOlxHb0IRP6RuViR7WKH70s4ET04mxoGgy8+OF1swt/v+oqQkICQ==@kvack.org
X-Gm-Message-State: AOJu0YxqnEKI5Y49d1ew9i4D/uCB0TlZ03y0Llcd7+iFV2WaEImIJUrB
	XFWWM7I7SSx6Mzj0gCYThBouwVl1EXjDsvwo+gWROePuvzwBN6RVlrZgQK2Pa5zpu3E=
X-Gm-Gg: AY/fxX4tyx9X9qf82OQi7whgqWhM2VbaWt/UoKj2bTbzuIb2YZ+NAYZIJsI+H09SYjr
	fVLwjrPuL8DqY33ZVWbft2tmVGmo+eSGehc99YG5/tVPfmvZJMBnhc2rQ3eKLpwWwHf1V0t0fLk
	ME2i4/kRNVxBETtWoX5bOX1hmACdSj2Lyqn1sM5ZTDT7pYffitudorDGFQ+XoBotlFql3XcmMXs
	FL7ndBiWx1YKhv5lUu1q40DnrcijwBmNVIXKUofEXsVP9pRVqogrGBL9tcIdYyU/HYHyHly60tB
	czXSgcLYktONXZLPjRH4fbRROCQDlN/vxi1o5cK4QZ0lLvhcXMut9E1ppMaJCLM6AlFvVIa45/r
	yo54/r8C6j44pGZC2f0BLxDxgolCzQit/s4umczpU9BIrcAxl10u+O4khdfsG/qJUfFA+zmp+zb
	cjuuV/MI+VKDEOQSrQy3XgmXhuq54yIURG8Orrnf5AkQZOrBCtK1QwLPOFRCzahyX9jq0=
X-Google-Smtp-Source: AGHT+IG8g77fglBlqhZKMGazF9A00SKS0QmAPx/h9dmbnRAuIOD9kpUD64pci6T5eeVAY5Szu07Wsg==
X-Received: by 2002:a05:622a:4d0f:b0:4ec:f403:3019 with SMTP id d75a77b69052e-4ffb48fff61mr258726701cf.21.1768245462410;
        Mon, 12 Jan 2026 11:17:42 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8d3d92esm132795641cf.5.2026.01.12.11.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:17:41 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfNQ5-00000003cmO-22Z1;
	Mon, 12 Jan 2026 15:17:41 -0400
Date: Mon, 12 Jan 2026 15:17:41 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com,
	rdunlap@infradead.org, Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <20260112191741.GK745888@ziepe.ca>
References: <20260109171805.901995-1-smostafa@google.com>
 <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca>
 <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca>
 <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca>
 <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
 <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org>
X-Stat-Signature: jk6ahh5k11m99ukdjfseypsqce69ngq3
X-Rspam-User: 
X-Rspamd-Queue-Id: A4ACE40002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768245463-688670
X-HE-Meta: U2FsdGVkX1/9Y2vGIbq7ezxEOsBVJXbtlB6X7M/M72xOtx6Tt04d1WUhBQlumJr9wLGtZNe4S6mDUxHSstnyQftLhiMrkphwprHyVs54JL/oh4tHV7GY+3uLHDmYJSZ5sPTjdYtzi6z3LHQgzfLAYFWaWtn8xIBMhjSfZ1mlOIBb2bQq9Xa0WrPXlj4qHTmx4iIrEiCTcEElIe60y9ZmNyJVBi2k4wIIbiAqQpt35pnqPiZKAxEVAbk/QzaeioxfHJ8r9zY31IQT0SmeFhcAbbd4weRXlhZWs1CyFJIaLivC5EZwPy6iReqog0nhIKJnCStPUJc7EGPxMTAVt7YjnweZ/G3tSEgzVBnJpxKPsYRxtIBSbfFqMYiWov/NW9ZKmLpzjGNg1WMySQBX1B6exHrEoCpPQq03Lu24dmr2ggNAyrRQ47ekwCIBfGlEmV6NXdflkusR/5IO6i5VWjDbBdhzCh7WIqe7eiRIhVIqw6AcHWjGxr2WRHu7M7n7O03uXVkUVZBduYcmfAbeQbjVV/6mO8mSwTGdjhdI509Im/10rToYQnqRUFUU7uGmxWLjhBfzSHlUn5y+srTew5tt8h7pkpfK7s4rf4ZauhcUjrppbyDg8jYKHbfysGSHkkF1jpVWr4qEEZeAKkeiqd5+3ePBy4YvaM7g1iI8FDBIydhDWV50jHajlJ2vN9Iu7Dh5KmmVtRelNO4jNk1Xc7LReUbrUaU0TMBlHf4H7+0CqwVCKQlzVYXtrHSDgN8o3PCqctp8h3E0F2I3RG9Lf7I/yEVnejcp5VL34oUyDMD9XeMGJIFn9jyjKdRVS9DEtAAWc3b3BfBKS6+BWFfRRiwem36Ld50tiE2e/3obVsHRtg0heG3t81Emkmx+pm5+WWaGWC8nZuM/nC4hCspFm8Umjw1mJa1pJa2bWtmZ4avY81X8EGPEwMU+Tm9//HxjlUza/MoL1HT+2P01YU2XPjP
 9B7Vxrlm
 n/7etInqxON+AglDbZUJeX3gRUbjjqe8OkVqTHki8ingI6eVOKrSJmrzDG88abzapSf4jcPEd3kZ5aZEmgh6SjALxFtODJ+BUZ8Rt7vgBOMd+cdh8x06YQHLDUxBUrZ3vBFNPFUkbil2LZOKwNbp2VIXcOfrVl/SxTPQLi/EWVypNMymETtHSmoAh8mkjiLZO4j/EcueyezYPp9FrR3zRErM8ZKOvSZ6ZIVLbLWjVpBzb+LM0aHbk9bkh2IVkFoOgp11MHCLt88+dcILERoSSW4ADoLrXs2MB7QOUCO49NobrIP3sdJUJkEQnDwPszqDkWeq1CzZZWIQvOkhOiqmRm0puMDNh3lOiP/mDP0O6Yy8MQKRw1cQVEME0Cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 08:11:50PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/12/26 15:58, Mostafa Saleh wrote:
> > On Mon, Jan 12, 2026 at 1:52 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > 
> > > On Mon, Jan 12, 2026 at 01:43:41PM +0000, Mostafa Saleh wrote:
> > > > But I don’t see why not. from the documentation:
> > > > /**
> > > >   * pfn_valid - check if there is a valid memory map entry for a PFN
> > > >   * @pfn: the page frame number to check
> > > >   *
> > > >   * Check if there is a valid memory map entry aka struct page for the @pfn.
> > > >   * Note, that availability of the memory map entry does not imply that
> > > >   * there is actual usable memory at that @pfn. The struct page may
> > > >   * represent a hole or an unusable page frame.
> > > > …
> > > > 
> > > > That means that struct page exists, which is all what we need here.
> > > 
> > > A struct page that has never been initialize shouldn't ever be read. I
> > > don't know how that relates to page_ext, but are you really sure that
> > > is all you need?
> > > 
> > 
> > AFAIU, if pfn_valid() returns true, it means the struct page is valid,
> > and lookup_page_ext() will check that a valid page_ext exists for this
> > entry.
> 
> Not always. Offline memory blocks have a memory map but no page ext. We
> allocate the page ext at memory onlining time.
> 
> Also, I'm not sure about ZONE_DEVICE memory, very likely we never allocate a
> page_ext for them?
> 
> I'd assume both cases are not relevant for your use case, though.

They are in the sense that those PFNs can get into these routines and
still need to be handled in some appropriate way..

Jason

