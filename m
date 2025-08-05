Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0305C87FDA
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6D58E0005; Tue,  5 Aug 2025 10:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E779E8E0001; Tue,  5 Aug 2025 10:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66798E0005; Tue,  5 Aug 2025 10:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4FCE8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:09:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CE3EC07CB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:09:30 +0000 (UTC)
X-FDA: 83742886500.16.53CE314
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 743938000A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:09:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="OyTHf/YV";
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.179 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754402968; a=rsa-sha256;
	cv=none;
	b=vTEMC/k9xGaQmKV26+e5q2as9HgjvTApE7VazzdWwQHytIU6TCSRDcIB4Xo4Tt/tieYIFQ
	2emA1RzZNUFdWr6V4h93RvsFiAVS2QJMyCRKFwUo2buCpNs+NKoPGD1JG8x0DkdqDqTpVD
	0EedKE6ltxQUCyqngAjpnsx8ar4HHn0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="OyTHf/YV";
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.179 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754402968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzAYIR/shPSYacUrOQJo0K9+jh4P0UFNjUkTluGngLM=;
	b=vxX4deqVrwKwZiZxEC0r6Jz5lgLjBvkq0st+MoMOQ7kSTSYDfWj8TIDL3RnKqcSkuz0Smh
	gXcR30h2kFj1R6wPx0rZ2XUFMF5lutPcp2iBEadcIzzCDY8yg7RNhBf+xO5LRM3N1MKye0
	gV5F3IBo2yLc0ACNw/oA/0NtU8ftp7M=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ab61ecc1e8so29041791cf.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754402967; x=1755007767; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzAYIR/shPSYacUrOQJo0K9+jh4P0UFNjUkTluGngLM=;
        b=OyTHf/YVyAz/bef4rJiAx9mYrW7m6BPLDYeXx6NDBGz6tCJxx2Kybq5jAyibXG9tHU
         uzw6kb6mNs0W21z5NNrebm86x+8GK/E2Qoig3SxF+as9+74aPfTf4jud4f2GylGjIIV+
         PhSXm8NbZy24L5vom5GcCGpaZyrtQRY3qLkRt8x0zGVh9E9+BKbrc6iHOJrF7VKswbC3
         mcPSMSl0E24R4kplaS0Zoi6UdyWGnlk1APhWauJWpechHXTP8oGiBlcPsrnEmshCGatS
         KiyM6+3C3Em80iHDaRolrW2b1FxqF6z77iOWmQbhwHJG0ZPoD5RYLvNjguQ3IVnvwEHY
         PotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754402967; x=1755007767;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzAYIR/shPSYacUrOQJo0K9+jh4P0UFNjUkTluGngLM=;
        b=d773WaViDBbuZmbIQ7dYKPjnaMs9CZCGoPdDb9EAtvMZDhfEXJjtf8+bWj7VmLP79D
         7aqoCQNKB9msWPrYoWzTWWTH4ZKoylKtyoyPKc4uNUSR/f9+dtK4xgBCAO1yfQMCakrk
         dPPp7w9RLGdHR+5L/eJCE0NXTnQAQ6pATTTYzrcaD7L55jdvOFKc3RA3hBj2JOybGlPF
         WjRwo+c4lx+X+3ihweeYfWzvhiWzjGFlKKSiK/ScxthOUbdS5Tbj55SKaZ4Wu0fzXMv9
         mgTgl60yx74PcYbvFJUnUATlWgq0y/dhwE9wty8fzLbPgLUOSAvo07Aiae1az1Y6phoR
         DvNw==
X-Forwarded-Encrypted: i=1; AJvYcCWI+/PKuzY6x1JZ55P+y502eCRDfubj92lAaBzml5bKK1R5ik2w0hFdOdQ4kfLito48vaWhpuOz2Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1H2Gt6KzhPRjjwmPxYJh1ZkIx6mGfY6bsVb38DcJbRdmUzapn
	Yw8MRsbdlWWITVrf2bgBoQ5xyVcJz/tq8v6HX+7MoiPv0KYEyCCPoFyQPA2Lb4JjPi4=
X-Gm-Gg: ASbGncvBPhNGMVKZR4mXmyTZwvcRocvn5x5xKAz68jn1RacMNenhuEe/df4YubEcHgJ
	B/r5C08iKaYOAdYpzRVSnnixlbi6exKNxD5LDDcPGHzhrokQPub31LaxZoeJPXdvm/BDIkBm+jE
	YvXOnon+WeHxVxovNXSlgr+GDBVHwU1XCJQEIM246952nyeOZkydar6d28ywUaTsk3eqT37wly6
	B8jQ7lEQzJzDkI9nLEQJ/Z7/sE6zpqp3gUttyCehTrgAC0hn0ku95whq4TVc2gu6reZ2/8bOUDo
	bVv1I0GdF/KjUvfN6lMFmqYswG7wF7CYoeYkj+G5w4aseilA4P1VGAwAnQpn7ftIZ9KIvDghsQw
	3gjTlCbKiTOi5WvvYruzXUx9cLMxCLusx4zCxGOZ/p/BFkk4cbJnDutrRlStWsxDXZSX1vpRlmb
	vlhL4=
X-Google-Smtp-Source: AGHT+IHL+J4sqP2SxcyYA/bm344OksrCpi3leJPwTfOOG1s5eCheuA6YOXSpbD6tw1CHk8ksExeFwQ==
X-Received: by 2002:a05:622a:4a14:b0:4a9:a3ff:28bb with SMTP id d75a77b69052e-4af10a1abd0mr240543491cf.25.1754402967223;
        Tue, 05 Aug 2025 07:09:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeed669c0sm65687951cf.33.2025.08.05.07.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:09:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujIM1-00000001XVj-3WEg;
	Tue, 05 Aug 2025 11:09:25 -0300
Date: Tue, 5 Aug 2025 11:09:25 -0300
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
Message-ID: <20250805140925.GO26511@ziepe.ca>
References: <aH4_QaNtIJMrPqOw@casper.infradead.org>
 <7lvduvov3rvfsgixbkyyinnzz3plpp3szxam46ccgjmh6v5d7q@zoz4k723vs3d>
 <aIBcTpC9Te7YIe4J@ziepe.ca>
 <cn7hcxskr5prkc3jnd4vzzeau5weevzumcspzfayeiwdexkkfe@ovvgraqo7svh>
 <a3f1af02-ef3f-40f8-be79-4c3929a59bb7@redhat.com>
 <i5ya3n7bhhufpczprtp2ndg7bxtykoyjtsfae6dfdqk2rfz6ix@nzwnhqfwh6rq>
 <20250801164058.GD26511@ziepe.ca>
 <b8009500-8b0b-4bb9-ae5e-6d2135adbfdd@redhat.com>
 <20250801165749.GF26511@ziepe.ca>
 <vscps6igy42u5limiigiok6y35mjx6acawi3qmvzbrpvltp4qp@mkydml7lz6fu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vscps6igy42u5limiigiok6y35mjx6acawi3qmvzbrpvltp4qp@mkydml7lz6fu>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 743938000A
X-Stat-Signature: nbwtxtwos1mg3erxtwou6okz97xobhqn
X-HE-Tag: 1754402968-910924
X-HE-Meta: U2FsdGVkX1+ig7L9+jP01fIqq7OB8hV5ze3p5YchYKU230/eFGQy3dFq0iYfRrP1tUs/QjsOjkvLKxK2/3CV0+NlJQ3VRLEOIlXBfi3euwgZe9dqZKaM3VhbQ0y4SAyQTEPg/6wAq1izRj1BzWj3AdyVmfNsCpIRUuJqYd9TjTzoWG+aPcNG4x/n4IgwA7FwNcSJeSfN6zBU5clOOfwGsVfm5c6vThCH1oS0Sa3FbZMl0RZ5M+W2r/ZcBxjOdkTmwaf+RcMEQIG2sFt3C+V4r/l2QrdaUcruCWRDmLJvISLt3aQghkc+7xMejY4vs5cn5xtYdlZkbWA2HnA1GH584D+18ofjQx1BN2gCVzjF/dYVRX1mSMGMZglc5BMkAx1XHZW1eL2AlABxQR77SQEEbFJHS3k5fPqaHBDv1gLEpWEtt90kpWBXpeTRB6qXxe9XGvPZrnWa8wNiB6xUOrq9RVSBFdso8II90mv0CxTqHufV0kCYKNI2NuAPgkpnhUOweTT51jNfiNW7GM7Tl9+SFHr5w4QiipElpBzKva/XJSOj7AFl9Hc18eQ0ysBABsC+GUEItL+l+/j4lyZVyy2eHi5AeSLvKqDmEp/SX9kEpLJ+v4TdzOVqptAg8hN11K+UzTd8pdLjMmLodpH0n8f7QMUWiDrp6DToT7pooOUhHXjWYJ1GOB1tIicyThLYsIpLIi9gSxIIQ5HfkDQxcbT7eHfhjmoNUsnsqCvCqhB0aQWInN66LU7SxW8vMrJdex6eVJ+hPTbMBuVOA202pZhDhU8KUBQIIkXYP0Tp6a9kNLrMGM29l56uRZ4Sk8K4oYWbItMB/XLJhyEeA3/fDSjlxOXVPYET1tPLY/VNikUu4w0oSpDOUgOcU40uBLv1YAYFL1X4pdxng0YRxIA6X1Tb8MlI86Z2ZxC3nQ2qmt6Wsio6obR9Y6KtQdsMBMcCxXWPpI4vugVfZdMy/X1AvYX
 feayzs4s
 gpZ9iMsna7aFJbpnX/Owx4+Uzf7x62MMyeNCnXGLe6VB/MxTbLWqKhM/koTbK/AB2zVlAPsDwVbgleZbF477yew2n4PWrAeq9fAYnO31NgDKq+TKLtYOzNRJvlsT32IuGYEgexVbnEfFwpqtOCjnEXIW1WouA4rDlaiV9RJ7qcfqezaY6nL4nBUWHbZqIzyfX+GBIDX+EmGa1ObHqKSv5EsKqJZ2igUV0fDBjmlEIGCLZxFZb0Iv8DbpLiIj5r35fhP/bQqIdfWeL+NYz2iUDyw4B3lcwYLiYZ7W1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 11:51:38AM +1000, Alistair Popple wrote:
> On Fri, Aug 01, 2025 at 01:57:49PM -0300, Jason Gunthorpe wrote:
> > On Fri, Aug 01, 2025 at 06:50:18PM +0200, David Hildenbrand wrote:
> > > On 01.08.25 18:40, Jason Gunthorpe wrote:
> > > > On Fri, Jul 25, 2025 at 10:31:25AM +1000, Alistair Popple wrote:
> > > > 
> > > > > The only issue would be if there were generic code paths that somehow have a
> > > > > raw pfn obtained from neither a page-table walk or struct page. My assumption
> > > > > (yet to be proven/tested) is that these paths don't exist.
> > > > 
> > > > hmm does it, it encodes the device private into a pfn and expects the
> > > > caller to do pfn to page.
> 
> What callers need to do pfn to page when finding a device private pfn via
> hmm_range_fault()? GPU drivers don't, they tend just to use the pfn as an offset
> from the start of the pgmap to find whatever data structure they are using to
> track device memory allocations.

All drivers today must. You have no idea if the PFN returned is a
private or CPU page. The only way to know is to check the struct page
type, by looking inside the struct page.

> So other than adding a HMM_PFN flag to say this is really a device index I don't
> see too many issues here.

Christoph suggested exactly this, and it would solve the issue. Seems
quite easy too. Let's do it.

Jason

