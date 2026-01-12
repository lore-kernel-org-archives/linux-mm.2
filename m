Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2CBCF45AE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5776B008C; Mon, 12 Jan 2026 11:50:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CD96B0092; Mon, 12 Jan 2026 11:50:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F486B0093; Mon, 12 Jan 2026 11:50:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33B086B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:50:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D43B61A0753
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:50:05 +0000 (UTC)
X-FDA: 84323899170.24.75A6343
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id A8D901C0012
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:50:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=RCleqBd3;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.48 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768236603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAxh70JY3ShLNfnDxBWsRZWpalCHcaRfsM5YzKZ+W9w=;
	b=0gF9sOkH9CozHypcLyzw1E+w2oadvQbki0bdFe4pbRQKjqEVqnOTezAPTwsZk8YxnD1ITL
	4xBLo63QUHOATRAm06ix/uwxiDmKs34ifJ2mhPZ9bC0YiMu7LeDpQ+eb62XgLLjNdAKh0n
	heqp4GiyfRZnxhlhWUxg8iY3/l9qff4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=RCleqBd3;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.48 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768236603; a=rsa-sha256;
	cv=none;
	b=xhjoEPttCFlFzyBla6rhy+j4lRION0q8hAXc1PT3uWpcYzK/uqQfZEcsiAKdCG4Tr863ol
	/fRfF5p+YVTKqCq7waM5JAq8p7KFwhPDfP6zlaXj9RKWxTlxuLUHm6/d8F1c59x3AcoE6z
	xYFW3qd6YMoVsCDGSmkAmhcaPGIAjGw=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8887f43b224so103613176d6.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768236603; x=1768841403; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eAxh70JY3ShLNfnDxBWsRZWpalCHcaRfsM5YzKZ+W9w=;
        b=RCleqBd3xEA0PhRxvGVk9n1oe2uRiSH9K8nFWmTgxPCucMKuE3JMBy4O8kWFW5Cy4x
         hMWAnMsIdmKeNovI+KkXms4HFD5SI3F2OhI4dI1QLJku88P+ZndbI34HCAy8qOq9ku2f
         pWDrdJ1yB8UWD5yIT9aehlyo5dpoCYVc9mpYUXy3Jk578hy7vNMqILxsqL3GK/Ioff2G
         Ywh+M1KkzekdLiQZeqXsA84EdyVKqpUTRjVYEOiALett0ZzCPgYXCVek6Qd+1Zwt/QTC
         FuQPHSRniucC2JcWduHMtguxdo3rC2iKP1ag2byVhhekjYTvgjyAQ9nm/g4svt4ekPq8
         I3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768236603; x=1768841403;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAxh70JY3ShLNfnDxBWsRZWpalCHcaRfsM5YzKZ+W9w=;
        b=FOppGXtmYImJd/AnSqYiYlqncdzN8qB1UG2dR+PpHiy9dJbRRE3fERQj2pIOezVpCi
         7b+zU46dzpYAakN9vRZTVGzh5K3j84Ra7vaHhEEtzjzjVnGQUB5uy5tWSTJiFG3tNe3p
         Ys8DCfvcS1ItdkDb5AcoWRJslncKUQZoISsRCJGA/EvhxxS4vnuC6uot0E+qmi0BG4Pz
         tN1ptJpR5CBPy6OJAp2o+dg3+3S5WBCxztuKzZ1x1C4rPmqZzaJP+mELElekmyFhPX0W
         k8sAbYD1jJtuYC7IvEcyEMibbZcpLn09h3fsYQHzEuy676KcXM1/UVvHIymtySYOoQsY
         LgYg==
X-Forwarded-Encrypted: i=1; AJvYcCUmbByjbK5GjCxIjpgtvfiFfTYOUXmBWzsy78EvnRTm4PJ8KP1RgxLvQ2BGug9PJqU09kmJxnOIlQ==@kvack.org
X-Gm-Message-State: AOJu0YxiyPB7gmwGOLWANxq/NrywQjm5rXH72kctuGFP8esokhaHrxu9
	wtKCQ5th97mmnM/RKzhXL68IlknfFH5782RYsthG+RsmdM+6CSIehirvuQizTYO/2W0=
X-Gm-Gg: AY/fxX4MCpSChRId+qbqblCGJXyYZeeUnBooSIyJHmJR35Yc9B2xa9PdLhVBoJ8oNSG
	P8YkuYZrsfa876QcZQvxwslZLVtW3FQM3hTBnWLyfWUx7ndLH4/rNoNYPG8MU5hw5vm/pr+LNF3
	sBo0macE7+3ggMLgVXlQBv89YxvNuHSyOzcM3VM2qGZJXIpHECjT/o/NOgqAjiGofYV6ARg1EwV
	Dh+0eO6Uv5/ySJlM/1aJThypd2i54ILATMgXrB/mcl8G36SxiPIVisg9+wVEEGUTQGTUSynrlEh
	cIhKdidhLro9IbLpJg20BjhLmvVQjQWEbxzRC3hujuj7q4/lb9dYijapKbuFtDmnzVfEzOcyUhL
	B0+80RdD7P2z76N24WLgfNq2OeN6Jk1Ra6jShEClL5X73nQNuc4+B5+ni3fu8drktHGdgTumSxU
	fbMQgtcf35K0r26TZrj4beG3/G4wI7Szb4nyDcQZnZVI0gIPxIurXCK0lKNDU3lAA9bT4=
X-Google-Smtp-Source: AGHT+IE/A98Uf8f6ySXPvh9xamBlLANpUoYS4iXttzp8YDJn905I/7mcjcPxPkNVMXbRPnmf8UaJPg==
X-Received: by 2002:ac8:6f1a:0:b0:4ee:208a:fbec with SMTP id d75a77b69052e-4ffb4a1ed32mr255276771cf.66.1768236602551;
        Mon, 12 Jan 2026 08:50:02 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89077253218sm139285396d6.43.2026.01.12.08.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 08:50:02 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfL7B-00000003RcK-2R9k;
	Mon, 12 Jan 2026 12:50:01 -0400
Date: Mon, 12 Jan 2026 12:50:01 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Balbir Singh <balbirs@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
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
Message-ID: <20260112165001.GG745888@ziepe.ca>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <218D42B0-3E08-4ABC-9FB4-1203BB31E547@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <218D42B0-3E08-4ABC-9FB4-1203BB31E547@nvidia.com>
X-Rspamd-Queue-Id: A8D901C0012
X-Stat-Signature: yjda7sfe9jachqntyxjyyjq7wdwg136b
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768236603-573520
X-HE-Meta: U2FsdGVkX18OcP9TCVHodGOMW1ZTsvIMCQKbSQMlq4rs5imVmOwwD9hRTdJrchvOo6rg/5Fn7u1Wmk3Nz3jDCV8SUfZoOoUuiTvd10ix5PO2uX8LPQdJJsGAXSk5+1MKDdGQyxyh6iRQ3RA4eRPGjrV88LXTwQ5LgsSMgCLiWWOcqzrXOPkbXsjk/SSqdjLQ3Yfb61sQyGE26SBjbiZhlAZV0nmvSx1HxTwMiM7ILeKPjpwLjSD2OvOFy7XmFHx3Gb/8hel2hCYpTAay/5vDARB4kjGPuY4FGSApLX4EWbDZB4kLW5nLKroPuYc+SbHbHCqhDVEwDGaGl+jw40bTXiONRPviE+oQPet+I5ksDHqSNtmzqMgSyvZeRfKvGzDqbHWoyzSK9GLyGj+DT4VEuycT+1B8zX72KmA7HL30yMtdZj4PlvSv11WaXFE3LY79HUH2uFBGU8gCNwrf41xTPTYFbgXWxY3u43tMgYb7gQFI6mafxMl1/nwPcDGg7YdyqmbEVLkqlnjPt4SkrE3F4XVxTECGGw9DJ+VE+NB7991HW+dVdfk33iFtp3fsXbTWVBRLk9Ey9+/9zOYbXlDTeI1xzQRWm4SM7w/7025iOWwHiLQaC4o7IXck6daItm0K5csjMJS6Povl9wod4g+OW6hSYuibJLNVmwg/R1O3sD3iFJrP6sjLmd7UVdiD1L1ddXN9y2A7J8UIEt2I6ChiZxaa0P4HvZFeo/0EW6/ihY6HZL1OHIClWAIPFpeS4ZA2fNaXw3djDmbnta59mnKfcXb5XM2KsmEIkjbMgPaEsIZgUsdYy8BegfjjNU0h4cuwxdv/aScCbm9+QJi6CssCZENMpvQsnbkmJmgxQVQ052AZAGGrUBIfbBi5clUNtaGv8MY+MELLGxYSdyTdjetoDu9KkDGUCap25ptK0A/ypryBeqnDWGxfGOPMFRFETOuooJggESk9sSPQxRI7Bax
 ifqOmTfo
 SCSWh55Km4lm/4wb34SWjfgGhTRaRMdEMjOmR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 11:31:04AM -0500, Zi Yan wrote:
> > folio_free()
> >
> > 1) Allocator finds free memory
> > 2) zone_device_page_init() allocates the memory and makes refcount=1
> > 3) __folio_put() knows the recount 0.
> > 4) free_zone_device_folio() calls folio_free(), but it doesn't
> >    actually need to undo prep_compound_page() because *NOTHING* can
> >    use the page pointer at this point.
> > 5) Driver puts the memory back into the allocator and now #1 can
> >    happen. It knows how much memory to put back because folio->order
> >    is valid from #2
> > 6) #1 happens again, then #2 happens again and the folio is in the
> >    right state for use. The successor #2 fully undoes the work of the
> >    predecessor #2.
> 
> But how can a successor #2 undo the work if the second #1 only allocates
> half of the original folio? For example, an order-9 at PFN 0 is
> allocated and freed, then an order-8 at PFN 0 is allocated and another
> order-8 at PFN 256 is allocated. How can two #2s undo the same order-9
> without corrupting each other’s data?

What do you mean? The fundamental rule is you can't read the folio or
the order outside folio_free once it's refcount reaches 0.

So the successor #2 will write updated heads and order to the order 8
pages at PFN 0 and the ones starting at PFN 256 will remain with
garbage.

This is OK because nothing is allowed to read them as their refcount
is 0.

If later PFN256 is allocated then it will get updated head and order
at the same time it's refcount becomes 1.

There is corruption and they don't corrupt each other's data.

> > If the allocator is using the struct page memory then step #5 should
> > also clean up the struct page with the allocator data before returning
> > it to the allocator.
> 
> Do you mean ->folio_free() callback should undo prep_compound_page()
> instead?

I wouldn't say undo, I was very careful to say it needs to get the
struct page memory into a state that the allocator algorithm expects,
whatever that means.

Jason

