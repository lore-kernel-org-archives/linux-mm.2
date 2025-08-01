Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72B7C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442156B0088; Fri,  1 Aug 2025 12:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBBD6B0089; Fri,  1 Aug 2025 12:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB1E6B008A; Fri,  1 Aug 2025 12:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15F726B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:41:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A89A14029C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:41:03 +0000 (UTC)
X-FDA: 83728753206.03.E946698
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5818D40004
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:41:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=GJ+euBPH;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754066461; a=rsa-sha256;
	cv=none;
	b=JwtdQIAgGK3lUC/nYrWPYmurODoutHylKd0LDbUbRIHzvuv+DU6AxSl2casB8mY0oBwoj5
	0L/YowqlCLvoX1Xk3A8VGgLWLj4ur7fMRFW/ZdFnjO5XRRw7a0ODSdcGM9dtIhDABOD2zE
	Ao1ZdrbkZg2IACKiFvb8lyGv0qwjbMI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=GJ+euBPH;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754066461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0ddBwnOmQZLVOzE3sU/BJSF1dO9mMLzFrijfMzZ/2w=;
	b=3eu0Nxlk3AHWCzC2bwMGkyN3khFcW9UbeAAoSjMKMa/f3PkTTtl9wreXEtpbq2ECO7kDCG
	Wgx1iMHVmYfRDX+jvDjamWIGhoQ4cwEx7keHSZfLUCU/VLDSwt/AdmbCzLeF6VVO6akuKI
	07oDGOnGM8co2hLOJgHknpnmMT9Y/ec=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab61ecc1e8so7143871cf.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754066460; x=1754671260; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B0ddBwnOmQZLVOzE3sU/BJSF1dO9mMLzFrijfMzZ/2w=;
        b=GJ+euBPH2Lz2wYy8Yldj7ucAh8CV/C6M/QWKV/AKr6EJBPrBCGmrYLu3v/FDSv/Zcq
         +4SVL62zFWxrL9pFqhOurJttPUPfyjKxI9KP+EVXhxKpO0Gzfz/NQJKrSJzAn+P0oLc8
         UMSR7dvH/1TJjxUexd950lxjCGXInJZQMBTmo0Zw5KFJ7KYrk2qlavHrjyQMhOJWjDAB
         7QiFoVsGfjmclyHsbnBMfpjnRpEymdYlVm9aOLwV37zM3bs41gybAl2WYnp6jJKQqRSL
         ripGSBWO9ryB7jRVUIFbs4FLhHIzdrUya0pblM/ng5+tS5MofZCw2DwUujxA1DeTCpJ5
         BM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754066460; x=1754671260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0ddBwnOmQZLVOzE3sU/BJSF1dO9mMLzFrijfMzZ/2w=;
        b=C0mIN5rFUzSOHlZCMsOiCBKmVucinARZuAQmBDRl9LNRzJS+Lx1/0isXYX2SFo48WD
         aqZpJaRXhdojjx+IhlC2ru4Pa6rUSAr1eRxPVjtB1sW3ZgFyaThB19PI155q6rYpG6on
         GA1Q2iXEoTH1EO+AAswJjOoj7vGqwY9ATv7eVZe2Ctcx3viK4aAjxa39HtqiOm/qXbZP
         MVwBtn6uesuILCLDaOivIyT+bqprIRvzeV+LDC/vFXtDEXuZIFIaYced03b/7gj2WftX
         4Su2sihN//Ue7s5F8F1OUvclZAIC2apn2HSKPhuaeBfDxBQ3QgEElpD+/17zvWt5yY7q
         5jfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsoEBHlWVliHq4k/EFOezLCQQbWKpOjJA+fGCr/iq9HqwjDMzbfiKHiVUwRyt22mMSNjtAE5/ADw==@kvack.org
X-Gm-Message-State: AOJu0YxW880m66MYQbxF0WwNvotSrNnDlpw8LMEbY+xUzcbTP1lq+iIC
	3Y42G6DMJOxX7lUUvbhJQ0IEsYNmQH8Yc5HCJO3zEYa6Vod8JdQTBN3lIYUpA1Zhzz0=
X-Gm-Gg: ASbGncsQYsgEfTiRjqva2cdqM2eqMi+2UtJHvWqUaRMHtzfId/+X1Yrx8A6nuxPQGBI
	ZLgeVxOqEBInzT6aTz9FVKSyPeXgczRI1wMYIWNykiINZHHRZA6QkvDj69K0a7v2YOj12HzulGi
	HXOJdAJ2XZRjBaOm0UfMagwoyhOSDzOoGR2eGahhr6RRHzVqVosTCWTg3HV1urq8lQKJcLf3zn5
	aL7lxeV4ei+essQPeNjJItVHmw9i0u8LFwZj7Yad02cUWRFbA/d1ScBvEKCptMRSm19kLyZK7eq
	JuppUEzDwEzotTR1monww/8sFf4tLe88lv3AtQXhPHK+rHivP/46aPenSoiyC04XdhHWuvwO+6o
	R+bOOpk+5o1N78EFkiR22HA4O2eHB188Gka34eIQZVIOhCcQ4zAK9GVY6P24nm3IsPGqg
X-Google-Smtp-Source: AGHT+IEy3UJJEisaAsFYVle9oO+qAAIDl2Jx71tj+7ZpM48o/4SMC51lEI3qAmHkBEbK3gRlxWE1yw==
X-Received: by 2002:a05:6214:623:b0:707:641e:e4bb with SMTP id 6a1803df08f44-70935f66fcemr4291156d6.17.1754066460081;
        Fri, 01 Aug 2025 09:41:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ca5c23csm23275996d6.40.2025.08.01.09.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 09:40:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhsoU-00000001379-3cXq;
	Fri, 01 Aug 2025 13:40:58 -0300
Date: Fri, 1 Aug 2025 13:40:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>,
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
Message-ID: <20250801164058.GD26511@ziepe.ca>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-2-ymaman@nvidia.com>
 <aHpXXKTaqp8FUhmq@casper.infradead.org>
 <20250718144442.GG2206214@ziepe.ca>
 <aH4_QaNtIJMrPqOw@casper.infradead.org>
 <7lvduvov3rvfsgixbkyyinnzz3plpp3szxam46ccgjmh6v5d7q@zoz4k723vs3d>
 <aIBcTpC9Te7YIe4J@ziepe.ca>
 <cn7hcxskr5prkc3jnd4vzzeau5weevzumcspzfayeiwdexkkfe@ovvgraqo7svh>
 <a3f1af02-ef3f-40f8-be79-4c3929a59bb7@redhat.com>
 <i5ya3n7bhhufpczprtp2ndg7bxtykoyjtsfae6dfdqk2rfz6ix@nzwnhqfwh6rq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i5ya3n7bhhufpczprtp2ndg7bxtykoyjtsfae6dfdqk2rfz6ix@nzwnhqfwh6rq>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5818D40004
X-Stat-Signature: se7wmu78i7djutjn86q8t6mown361nbo
X-Rspam-User: 
X-HE-Tag: 1754066461-119729
X-HE-Meta: U2FsdGVkX193NsguGeR9HSNiyIMIqdawzHuxAgaCNCSXgecTSB3pVTSHpt3+j/5elG+8hZKP7l5m8w5JfD3b/CzEBOaZoeiPZzP2g4yFGl2JjYIH3pObPT0TKdWefXRMG+mJ19K8Wt0QbNWpkwm/YKmLvI3wVqS3uncBTrKP35GYboab3W7K40sDJoKQdraNrpC3GhGiiDem0I5HD8dk6xkldTL1+l2KsRSC91JJNWuxDAaO5PfgMqOG431RB93lceifTkAKTX4sS8Wmuf4abSQpiHCl1QLsIT9VOCO41+3jMg8OWuQPVF6PYkz83wkvc1M4NRVAl1GOiBuoJ4AqP3Xo8V9tlgmunr/NDwLfeADKineJ9+8VLJDIhRCiU8vnneByHhSvXmXA2R+YHTbzn0/Z46/+wyiLpFvhamqaGf1t6FzLP7VZJ+eycV61mdgIITAXje/n6cZ67yBXQQPuMRKUJpxNV8iTP5LoDKZmMq3XChFZfD2AcmSa/Z8IE+2bZSET21ZRCXAu+3bVz79YXG6gs59As6/X/0yhJbS3Pn/HoqtJROl5I+V5eCdA/N+ajcQchsNWKa/I79pml5s6PW4mozy3TrU+7uU1cTZiQz56xQeZdnSQzTimoWkIQREgqnW32n7zWEVixlGdrDb/6WhVHaCNQnah4J5G4VTLs2t9YZYzfVlu5BikjJnxwE5Gg6T3GIjTz2wskrvDCOrpi1DALxpmNVyTgkx90aUjVD//ZVyXpCXANAcmfthBvp7uDxc5pfQ2KRJH+Q+MFN9brFLwjmnVnBS5Y+1talxtgzAA3HMedakLEchKkaD5xExhnIQLL5FmW6SI/g5Q74q8Sl31mDEhwfO+EVyLmDWPrh+E85FD3t5H6hW0PXoAGRRIrlckHsNAOvFlf8NzidKJ3NVIO19GpAY+ufkgSr5b//0bYosR1MkA24VTCNI1wjub/7k6FAgpmmSitcFE+BH
 uohYFC3W
 Jtpe28OhP1ANZE06IAlIwo15Y0/RzDp2nTaHR0XjJDIjVckz/xeZW7UPoW0MqDM9atCAL0q1UfYBTC36zEIadRimfDoCu8+GXDR+sKblJLkZMMGjCzjHS2NKvK3wAT2yop98dCNFYKEvuRjbDX0aD1ielGeSYo044yUG0TROws6nmPUOye3SVGQhdZPmtDoTjc9U3mkW7GQfI85FEP8ldkxepJ701DWcb1Ty6EPEBNRMw3kQN1vuj6dgfzlFJK7KUZ+61MNt/geRfTh4bQD6CFUhKldyeuOwTBX1C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 10:31:25AM +1000, Alistair Popple wrote:

> The only issue would be if there were generic code paths that somehow have a
> raw pfn obtained from neither a page-table walk or struct page. My assumption
> (yet to be proven/tested) is that these paths don't exist.

hmm does it, it encodes the device private into a pfn and expects the
caller to do pfn to page.

This isn't set in stone and could be changed..

But broadly, you'd want to entirely eliminate the ability to go from
pfn to device private or from device private to pfn.

Instead you'd want to work on some (space #, space index) tuple, maybe
encoded in a pfn_t, but absolutely and typesafely distinct. Each
driver gets its own 0 based space for device private information, the
space is effectively the pgmap.

And if you do this, maybe we don't need struct page (I mean the type!)
backing device memory at all.... Which would be a very worthwhile
project.

Do we ever even use anything in the device private struct page? Do we
refcount it?

Jason

