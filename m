Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA42CF45D4
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 23:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551C46B00B0; Mon, 12 Jan 2026 18:32:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFF16B00B1; Mon, 12 Jan 2026 18:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AAED6B00B2; Mon, 12 Jan 2026 18:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28A266B00B0
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:32:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE9271A11F4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:31:59 +0000 (UTC)
X-FDA: 84324911958.27.924AB6D
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id BBDC3180004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:31:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=EPZUkAuP;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768260717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIO8dQifpp5qZTd7WcwNdFqrDRKIKFleYoHUkXQdAb0=;
	b=l2PIS0zV9rrJnWBBMvFAubAZQMSkq0DHBGoTmkurpE1aDhl7PoriWI9SBae1kA2yvGalry
	aZZnPXaNhPkJeqC7ovDn0BUrgZhn7GmHRMMVjeNnIhwxjhlIKDi+bWU9wc/WIRdEBQiu9L
	aLPNmCM6k8NadRweoVoSXXn99anJEiY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=EPZUkAuP;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768260717; a=rsa-sha256;
	cv=none;
	b=EI3Xaa19DyU4lYVcycElip6jzP166eWzNO0g9QeMgSa3hHJaDfv8wboyU+cFt9W12VMbP3
	iiOJQFKHmBO9i4+xTwaFJiup4EcC8O5HX1DWf6uLArALQtmsFF+fx1aWmgjtL7pxfMubqo
	TMGEQL05P01CmZCxBgFnyut5jbzzCsI=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2d56eaaceso794826185a.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768260717; x=1768865517; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pIO8dQifpp5qZTd7WcwNdFqrDRKIKFleYoHUkXQdAb0=;
        b=EPZUkAuPGJAEGkZ7NUwrvq1dMN/tWFZBUqtON8OWhVf58BAtkaHvLyEcicSIBTlO7H
         x0GANNxRv543i2yw7s+G7rjUNq7tbioXiR4S9KDGP8UBG7b/EXQRptVlqH0oj6h3fIgz
         WiK1XLUfWoRmC3NRZDAihFRV3yURyGf55py3CflBcQhMMIkTPWxScwGE8KrRWaXMewzA
         RIpz7bQ1O/Nxi7aiEoB8Equyk0WLWuF+97es6nWpmci8ZuxiC+Ku/NiLGM59Umr1WVml
         AwTlobc6vzzWt7dOevF/QHMVIDREABc9tCT98CuzhBKD+4nyaCABma+mWp5aw5Xy26gu
         qtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768260717; x=1768865517;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pIO8dQifpp5qZTd7WcwNdFqrDRKIKFleYoHUkXQdAb0=;
        b=JBLK/ZRczZQ5+LL4NWvOAvqlVk/BEKQaiRmmHCTg+Mo+Q5lVu+SBEL/jLKzi7TqerT
         HE+9pmv47T6dyxcUCMnFO8KKk4HAjun9J2ByH6SJl8Q6oob73NTQomuVvK/TPp2wvqJ3
         HkbJpxdAqCex/HJTjiqrbXv7+gvs76VhXBEc9OgXqihUYw0cgm/7UdavpWax4H1rvsaD
         qBH4CMjudPs7JAptf15KWy6Nin0hSaivQACCo+hLVt2/llk4SIBhMZvyZH2RElUGk9zT
         ceuksYBrzGxRT5hhZ+jJGx+upXjLkYOcEWglMtI61gaUb6PFYdy965Sj4twtS7CA4Xd0
         Pe2Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/FE/y80z85Ajv7sonq4W2hYRjvMDtBWsok3+ZVONR5T97akYZVxjFw81nCynqn9cbXm+du/QO3A==@kvack.org
X-Gm-Message-State: AOJu0YxtTyxIbDYoTd4rrMWaReuVvtQNLkASGxmEyGNotBiQwx2gJZUn
	t6ts7x9R//5E9+COMyd5GE570na/hA+M9xeEPeyUrCfWQmHO4kJpEdz9g0SxVAOBC3k=
X-Gm-Gg: AY/fxX7um0n9tq+JecjieNUfBDcQ7tE9XQula5MhapaQqwVLvxuVhtMm4iwehHXkajF
	xRKAwej29b0+rMBOPH/Akf3ZgXjJ3a1VQ8x7wRYcUgSmT2mh4w0INiIMxJH5P0XHog3nBx0lfCm
	kwG5qstAEi1B0z1iqHf0973FQrJzMcfeqCk1DshC7WRS/fGiin+40JdII3UoC8RdU7y/4X3CsMs
	XIRNCkuG9NRKPAFQvDGgcEEH8e+IDbiS8o8EE2qAZCDxoYkiAfx/akuIQtUJGprDNLoShCWkuVU
	+hMOJjWwQcWEdEgb91JXjiQcr+SiBuRVO/xUNwJ0BJKsnJ76RRX+c2dFCEdn3aI9v+ppjPlHFQc
	A47Nl04PS2KAGxWHHhbj8cvJgvX6wwPXVS3BbiZID4RrRSawXmAEaW8TCAmJDrW9DknJvOAHg4K
	nO412iHEO0MKMfyrBgkVskeSCtiHKg/qinC/6ivcCIk2yCXdddCj8iTPSLtTx3v94GnPA=
X-Google-Smtp-Source: AGHT+IHEv3oyWJcb06Rw4VjhDeFEk4R9SXi3D7aPoLG3khcVAljGyaq9fJ2LebD88CvTcTHK3Zmx+A==
X-Received: by 2002:a05:620a:3952:b0:89e:99b3:2eaa with SMTP id af79cd13be357-8c389375870mr2741069685a.8.1768260716611;
        Mon, 12 Jan 2026 15:31:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51bf8csm1591462585a.28.2026.01.12.15.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:31:55 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfRO6-00000003evB-2tne;
	Mon, 12 Jan 2026 19:31:54 -0400
Date: Mon, 12 Jan 2026 19:31:54 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alistair Popple <apopple@nvidia.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free
 callback
Message-ID: <20260112233154.GM745888@ziepe.ca>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <aWVsUu1RBKgn0VFH@lstrano-desk.jf.intel.com>
 <45A4E73B-F6C2-44B7-8C81-13E24ED12127@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45A4E73B-F6C2-44B7-8C81-13E24ED12127@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: 4pu8hy6nugrmb5rqx7yuw1tw87jinsw3
X-Rspamd-Queue-Id: BBDC3180004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768260717-886259
X-HE-Meta: U2FsdGVkX1/GYQop07o0Gw7p1ZyendUqdZl0h63PhU7g+BygP+LhwG27xlqMLv5bqrofz0RSTOWOKhCMovMbLU8S9rGTvLhn91h/B3FCafBX6qeFH+KongcWBO6o5QMFebZer4MFT54iT6Vb6Ria4Qs7tqzXtCvfPCXyu+WXxGgDg1xZNN7NJMhBAwDHECROdBGLkdM72O+5ByWRBKFUNOxT0GhmPdO1rq5JhhinoKezKkrFHUGio5bETkgPDgbhsxRT3cWIu5nYvgnoeYwoati5dcYUjYWgMW7vIEvqI4uC03ZWP7VsVUvB/OCCRCGW55J1g99KAgCqxvDwzUnmaqB6Dudh7io53M7XH6sJ/RFUoGWjq3Hay/0w9+9D6VasEZYoDbFz3LT7IHfTSvZbV0qMkE7GoZ2rS4ah5RxuTk6L74t/SKJnkbv4HHxcQd5ja0LmMZmic4qE7vvuKqWwu8RojI5xSVSHAwkg2ujoJSMJBh0nvEmvnwAJWPGpx0svVQ/eQ7Kn5V678yNWFmKqR56YsKjI8+4Jp+ql2mNS0ySlF/OGaCzwjd/fgVH/K4Q2RG1KRSeX2ITMMuFKOHD/VMtbWV7KXNbdVNX6wWBYd8ghj62Efw0YdvkSlhFl8xRBxhem5FooKMt+dTRVLpVrIspmX3bsNcRxNbiZAbTvTmWLrstRy0YQUqtk/foyUoHqklfkIQm9MDBMaa7ZbhURbJnePlBREkkOgM7RjukVhtvZ2UPqZakECFjGWcqjJJWX4/PohV7GruQr6lkHMAZUlM57JyNrtQU84k19IG3rgyJbFDf16lw9L7hdsEwWRInaXE+GWZlmoU0sVIL74zR/XFbLsk8zF+2rQDQVduX2mGBGWgv+kqdVyN9yimGhatwPnUiwOYCh6WOlyTqN7oskQtpErIV2QXIdre7xuF4E1dZkq7ZmC/hscZ2JdnrhFpdRuS0fRc22JsxthEBxKB3
 MshRPoHr
 T0XBOxE5NYD8bDV/MQnx6uSBWt4e0L2To6wuOPYxStzZ4uL3SLkP1v/9/DGOR3at+KqoBTxzLSlJuMNp2H8Ye17Nd/Y+NXUoKQJt8RJ71ehasGcec4UJsgrIdnjElAk1FouMlSF2xQP1wjRGq8aaNUXj8Wr18V2kQNPScY/Gp6ndoMsYiUn2WW6Xjgjqpdf5bc9qPW1ll6dyJeEA0VrRyw6dIe9rQkgB9yX7awhT7GhBaVGMNFiP8CbM4Am4YLHaWQjzdvrRjTRHcvnRrxfyI/Psp3aIU5/WikKRFfgePw8ohAmeVG1xyGLptnYGPKOZQXuRG2s6Gzw6BGAIUVKrSguOSyL96bPhgDufsKb/2T6FMDsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 06:15:26PM -0500, Zi Yan wrote:
> > We could move the call to free_zone_device_folio_prepare() [1] into the
> > driver-side implementation of ->folio_free() and drop the order argument
> > here. Zi didn’t particularly like that; he preferred calling
> > free_zone_device_folio_prepare() [2] before invoking ->folio_free(),
> > which is why this patch exists.
> 
> On a second thought, if calling free_zone_device_folio_prepare() in
> ->folio_free() works, feel free to do so.

I don't think there is anything "prepare" about
free_zone_device_folio_prepare() it effectively zeros the struct page
memory - ie undoes some amount of zone_device_page_init() and AFAIK
there are only two reasons to do this:

 1) It helps catch bugs where things are UAF'ing the folio, now they
    read back zeros (it also creates bugs where zero might be OK, so
    you might be better to poison it under a debug flag)

 2) It avoids the allocate side having to zero the page memory - and
    perhaps the allocate side is not doing a good job of this right now
    but I think you should state a position why it makes more sense for
    the free side to do this instead of the allocate side.

    IOW why should it be mandatory to call
    free_zone_device_folio_prepare() prior to zone_device_page_init()
    ?

Certainly if the only reason you are passing the order is because the
core code zero'd the order too early, that doesn't make alot of sense.

I think calling the deinit function paired with
zone_device_page_init() within the driver does make alot of sense and
I see no issue with that. But please name it more sensibly and
describe concretely why it should be split up like this.

Because what I see is you write to all the folios on free and then
write to them all again on allocation - which is 2x the cost that is
probably really needed...

Jason

