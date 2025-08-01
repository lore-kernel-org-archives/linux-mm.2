Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA086C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6DE6B008A; Fri,  1 Aug 2025 12:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87EB96B008C; Fri,  1 Aug 2025 12:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7948E6B0093; Fri,  1 Aug 2025 12:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7B06B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:57:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA2811A02A4
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:57:53 +0000 (UTC)
X-FDA: 83728795626.29.F3C018A
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED4C4180011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:57:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=nn7OsEr1;
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754067472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDG0NiUkE6aQQh2+3vtxR81GyiRPYX8OvGtHO76jA4Q=;
	b=1+XL4sL7/S5tX2S8Xj9fG2NJ6UyO0ssdS5szAXw2baYYfGCxCcqlvilCBun7GaiFR1kTSc
	Lm9NVtkAWPETGsG9BDyFt2VXVH587l9kdLBumf1nTDUx3EQyxN2MCkbE8zX64iSraL4xM4
	nFlvl5bd0C8WSdxCePQc+oYlj6HGxcc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=nn7OsEr1;
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754067472; a=rsa-sha256;
	cv=none;
	b=188G3jrSCompJ1N1Jo5Jn1047dKEDps2qEz3DZaz7ATqRtdFkm3FDynPXs40kwZet5yeVo
	MlN0AMCWnlmpkuav76z1bkJXKrsiFjYOHhg5/SpXxhxDACX2FSVSCB+OhWPYs9JGWD4iva
	y2NXrGShvzPi/P8Of92qhKXr1oQQTgA=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7e6696eb4bfso107924585a.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 09:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754067471; x=1754672271; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PDG0NiUkE6aQQh2+3vtxR81GyiRPYX8OvGtHO76jA4Q=;
        b=nn7OsEr1jYwS+qPl1O+boIglHKhU+QH9EDPzEyFcF9Ykk/PEwS/M97+7HFenNCyRUM
         d53hV/7YniEa8NVCtPYPbSJkrR3e+4PxQ1Ii+CW6eGIwgIQLlk1Zdet2ZZY+wD1ntfCQ
         zjYc2gLqs3MpKWPr+kQ4MkUcFCvGe/126/z22ukZX3B8fLuuZOA1fSrjIYidXTBsPPXp
         GP/Z9pWEGaolmVHptg7FC6IQgYYO38DkarcVOHPjrEfvlYdTcTop5qNtLIK3+9hHkt8x
         JQw5T/7uiKM/rCseDWmc0+KzOyM9ANm+oESUZDTQqKX9kjUzlDnOdZsI494DHbFpKUIv
         7LNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754067471; x=1754672271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDG0NiUkE6aQQh2+3vtxR81GyiRPYX8OvGtHO76jA4Q=;
        b=k0BZxct2ZtaMjRMrncFqqXSvQp5xGxZ86QnXT0RvMPNiLPUsLpIlIeQy/LhcRBkzUA
         2uSMwLOEKEKXjbIt3M2DuL21W52JukjVmQ0TAJ5NewCdZ0PK8SVpPmzYxsjw6qw2Ls/y
         I4RApHJIA/vQ1sta+/O4W9qd+7kjFhxvGI2tChB3Ttc0bRQhY8iFsnoCByJRSVfZJ0sZ
         e8Vv66ovHE+aUbvIdoRXRqa8dt069/8vjvmoN3zgL0qL2AaP4vmQ/QaslDqWCfB/GIMT
         ohEg60iArKStQ7M454HMhAz9aE1eperXKhVEw3laOIklTw6ZhqEyjUuLJT8tIEOMrIr0
         jpHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUitRLlij4gymjTKdF5MPf8aNxcq6hrDi2I9xujATtPWmMl03ti4MmDlOJjoZA77xEuqbX1dlg2A==@kvack.org
X-Gm-Message-State: AOJu0YwouxuZ/2wNXBO43u9jRRnKdAuLgthTFwK/PzmEefctqhFK89xD
	kJnWafVB+7POz6RXb0UvZW+GRiIT3Le5isSGa4gilDsHNpzKcKdZay99BMH8922S6Kk=
X-Gm-Gg: ASbGnctDdDsfWc6Lq01szJ5EVmGFsVuzDmq7ZM+J3Jwp/j+cb882AAE5YnF0FnmdYGI
	u5Sal18eIjQwE08vFyVpcn0ANJJzTs3l+VnbU23zVu6eADJrclEHkjIx6zyWEWaUIbqYPSGcmmg
	AmYZwTAT19jbInjsHDAW3FcathaKjF2RBBU09ZR7kWNSXhpFwB0FqqzllTa6wIaAjFTMNTZHMqt
	mnTqeAhzSiVGYwuZRgzEnqPg/kVQpmnKycGYANxmS5cE1KztKGDeDX6Db3Mbc3iIoBNj2HTqDD0
	NTArWb8KhLcL4GQeqc7G8APFb7wqPd0rA+DmdIcH/cyvDeSdy/bAHp3l+v2uKdmDJjoEOkkxize
	Abr+Dq02loJHSe/EWyuDUE/crygMqvPtKaGIZezErovT4KpCt+uH5eHT5JELqiOSFql8H
X-Google-Smtp-Source: AGHT+IERBfIl6+3LPr31vnFrHmPwk8v4BHZ0fVqJ0PrqlgFbKe+fN+UuB/UkeSinm2wl6jaqpYu7OQ==
X-Received: by 2002:a05:620a:4093:b0:7e0:f7e3:7927 with SMTP id af79cd13be357-7e6962a98edmr81964885a.21.1754067470755;
        Fri, 01 Aug 2025 09:57:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f597e32sm234364185a.18.2025.08.01.09.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 09:57:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uht4n-000000013IN-2zx7;
	Fri, 01 Aug 2025 13:57:49 -0300
Date: Fri, 1 Aug 2025 13:57:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Yonatan Maman <ymaman@nvidia.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Gal Shalom <GalShalom@nvidia.com>
Subject: Re: [PATCH v2 1/5] mm/hmm: HMM API to enable P2P DMA for device
 private pages
Message-ID: <20250801165749.GF26511@ziepe.ca>
References: <aHpXXKTaqp8FUhmq@casper.infradead.org>
 <20250718144442.GG2206214@ziepe.ca>
 <aH4_QaNtIJMrPqOw@casper.infradead.org>
 <7lvduvov3rvfsgixbkyyinnzz3plpp3szxam46ccgjmh6v5d7q@zoz4k723vs3d>
 <aIBcTpC9Te7YIe4J@ziepe.ca>
 <cn7hcxskr5prkc3jnd4vzzeau5weevzumcspzfayeiwdexkkfe@ovvgraqo7svh>
 <a3f1af02-ef3f-40f8-be79-4c3929a59bb7@redhat.com>
 <i5ya3n7bhhufpczprtp2ndg7bxtykoyjtsfae6dfdqk2rfz6ix@nzwnhqfwh6rq>
 <20250801164058.GD26511@ziepe.ca>
 <b8009500-8b0b-4bb9-ae5e-6d2135adbfdd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8009500-8b0b-4bb9-ae5e-6d2135adbfdd@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: ED4C4180011
X-Rspamd-Server: rspam06
X-Stat-Signature: 9qhmahka7c1sdiuwexe85ine4wss89kg
X-HE-Tag: 1754067471-176735
X-HE-Meta: U2FsdGVkX1+LlWe6DMF434wZN/BCjRafmdtNBdHd+gMkwKXc8WvCEX/gT2HtrfZsbKwvznu1LozfPXa0qfVFPYhfIRTreAOVn1biLYaetp7f0Hrs96ELsh3H/K7jcdU3fxgOwu+mSA4oV0h3tHKdVOC0+lcRQQXNuDX3e/dLkTn6H4w/xF2VmmWpvl/DKYyROeNDi7sH4782mZcsSe7TK2Y3pREQZLkzlMpkmB5in9p+84RDaD/XftFUR1YHNxgLuWzIOT6mVEtB6pyZjnHml0gTlHT5iOaPxkTzMJYrFxNXNMuZpBUQrmUDlk1G0T5qm1V/tPsJ0cm+kFycY/ytEXZKK2Fb/igSB4w3nVMJ4SXQcPt160DpqBRWUd+Rk1EtKdAsizyVxPnjLH1ZPwEwB5U2K+JvgnFNvUv/jPSAs1XtVaAhLdM6KRbqg79NhvKXpuO0Q9Kdweah0PCBxSR4CO1msS2lDIopUeHkzSHhi3HSxI8T2qfU0jf9BTAhO8BbRoILsaTz8itXGsf04jdoVKVmEYU/QIAaaQdambGIR86O3ILvmHIpcD2wN9yIApSD+7Gnf+vLQiTSLmt+hw0QxavR3ABKTSuThizHuTJPMFMr/j8vI6o7G0+I5H5CjPQR4KOf01RC9tiRE3ijLFnjHmu83u2/mZInu4P8tIJMz7XpCZDs+2z0Jq1zu7sozLEWu8QDSrmU48LFGWSsVAT4ZSVXjMum8FwtqJqqMN1xNW6vgij97BLJpiLQvOZP/ccl+F4TnOdLOhecKeOh0aq65/vgKM9uKN71JMHC4h4pCfHyho+MgtniTDDAPHC4eYWG5FpL0EN75wkbt15FLlKuS5E52CB1ED8XSae23Qxpc3kHmgw+2Kkn8A7CZaXp61HePbCb60FYVGuFhHQQ6hF6Ky8kafXC+J5MAdJP19/usPRKDxAMNcSNs2aGU3uulhisKJc3gsp0qbQ27cnzKkZ
 pUKqWbpl
 tQa/gBu9IRoTZnGB0CsIJ9ZEbeWcCJh9isCV7QWEoMcRfCEKmKi3yzVHTgimCw9dN3ghSR2qntZPz707EngNAX8r1aXkY+wZoNZU3al3OKOW54oq2C3OfmtM1pVWcT9vjhCAM54eg03GVedbaCzkhpukyEOtiOLVF2iFzU1+cxk8tOZiBncJTmUm7e6R2Nf1c86Ub4KvyvpkUpEBhxOkAkQnKZNL+N60DKh+nTbsdLDjw6ZKzGs7nQEsXf/u9Eb4T5VzoKL4spmNS+eboYDHneotUplPsrAtvxGla
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 06:50:18PM +0200, David Hildenbrand wrote:
> On 01.08.25 18:40, Jason Gunthorpe wrote:
> > On Fri, Jul 25, 2025 at 10:31:25AM +1000, Alistair Popple wrote:
> > 
> > > The only issue would be if there were generic code paths that somehow have a
> > > raw pfn obtained from neither a page-table walk or struct page. My assumption
> > > (yet to be proven/tested) is that these paths don't exist.
> > 
> > hmm does it, it encodes the device private into a pfn and expects the
> > caller to do pfn to page.
> > 
> > This isn't set in stone and could be changed..
> > 
> > But broadly, you'd want to entirely eliminate the ability to go from
> > pfn to device private or from device private to pfn.
> > 
> > Instead you'd want to work on some (space #, space index) tuple, maybe
> > encoded in a pfn_t, but absolutely and typesafely distinct. Each
> > driver gets its own 0 based space for device private information, the
> > space is effectively the pgmap.
> > 
> > And if you do this, maybe we don't need struct page (I mean the type!)
> > backing device memory at all.... Which would be a very worthwhile
> > project.
> > 
> > Do we ever even use anything in the device private struct page? Do we
> > refcount it?
> 
> ref-counted and map-counted ...

Hm, so it would turn into another struct page split up where we get
ourselves a struct device_private and change all the places touching
its refcount and mapcount to use the new type.

If we could use some index scheme we could then divorce from struct
page and strink the struct size sooner.

Jason

