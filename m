Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 218E9CF45C9
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5AB6B0005; Mon, 12 Jan 2026 14:28:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CDE26B0088; Mon, 12 Jan 2026 14:28:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378406B0089; Mon, 12 Jan 2026 14:28:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24A7C6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:28:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9DC5140B3B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:20 +0000 (UTC)
X-FDA: 84324297960.07.2C38094
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id CE76D120012
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=L2w+Yjms;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246098; a=rsa-sha256;
	cv=none;
	b=lY9o3Wplpt24Sv544fJdTVPMVxt9QodVrLbSkh0VTAN/8349dx7U5d/oYBzcpFyQsoFVv7
	Vr7TcQ57hlHi5r8RDOqfasABTYuS5gt7LK3HyV12U+ajLEvSwYe6yNSxYmMJlLAT8iFVQr
	R5WLbRv4GRKAnuRqjUcyiIvk/msEYqQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=L2w+Yjms;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9AdLI7uJUYtOYd89GixDifcE7N5970uW2swaB6ncSw=;
	b=hdtFlcTscEv4Go41rp/pxsA4Dq/uIaWFuTEsHhhZ0h8Jf3kSNlTQEvZwrubApue2iFZ3Ac
	21H0dV3238j9RN+VvU4gO1oiEAEUgNInrUIjoGcXNRy+y+UcjGitd2QBQxcz+Pp3qqJRf5
	wqIFYz6W2DJlajURrpn/5z/2bn43X8k=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8be92e393f8so608773785a.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768246098; x=1768850898; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=a9AdLI7uJUYtOYd89GixDifcE7N5970uW2swaB6ncSw=;
        b=L2w+YjmsWSrYkSwcchYmO68rUGY5/LAElTdglUO3JVGEofj2YwxdB2cdxhP0mJ+Q8X
         JO+i6VEyQGnW9rvleUj9BDyu081J7PIqarXeSj2VwHzVi1Gu5qe39ssoPwxC1UYDqosq
         cRInkEDlz5NDWtEEiuxDP1yY7TB9LEdhsz8tZSvK//bsS6BR1TmLmgefiVDZHtcowXlT
         rh4hhIQl927oAFIMJf9I6sD3LDYX0vFLkNjzuV6mAldCpcmJQAsjGHv164ibjKEBeFlR
         sHEitJ+6Phm0iSbHO9uTU8+fF7hJ/2Zyr+ZnFsHSip+VMO1vG1lspi8Ydu2Y4d9z+GA6
         qf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246098; x=1768850898;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a9AdLI7uJUYtOYd89GixDifcE7N5970uW2swaB6ncSw=;
        b=jQj4U0Y3cbAYTgDOEE1iIXpgR3wiL4D3WN1td9dODcpbIC0TS2hwIWzex3JrObkgcp
         FlA/lRX3ts/xRfYbYdJI0BrfTUqkq23af03Dnmjoob2vYKgBWaaQJWEVCFYzbk+H65gR
         MnB6tnTncGjAHjWzC9/WsisI552jtnLG5M8YCV8E6OJNtPadWulfqOIvtfleF8BYUjyb
         rz3Um0fVPS+MnGRNR0NkMiyEQcO1qCGLwPotFI7Z45eCPYzdMgMGWLeXK7LvWavxyu6k
         sDSnVFD9DV8tewXAqeVAWafchTVYY9hbBq4CHsJyL+5zWUKTep2oKeJxXWjRmX1mFq8w
         EP/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0/AsH5DQ+z/Kc3egnsZ44N8DvnDDTT5hlJzvBbvCdormmKar0VZCkILJxfHkSvgMUfnYFX+C8dA==@kvack.org
X-Gm-Message-State: AOJu0Yy5htpf4Zcoy3Xl6EAD7CxiSkT2uS6voJTTlHmn2FDLVa6yp+cK
	UoPxTB8FIqjQOUdII5sbFCYhDjHYBtHR5MApbOf3wqUuC2yqGPPqI11OoM1Vk6/hMog=
X-Gm-Gg: AY/fxX5AWBrSyBoOdU6m/ci0r9LNTs0Nf6r+OzKSbT+tEIZd94tdA66vlA4xyQKjcLO
	c9gVJTEEggU9jhwkH/y3nF5awQSGkV2/92oaf4TUSg74K00inFkuP1qNrHXIyFkhVh7bYfNX+EJ
	5XQJdK5re1h2QMG0RddKnCD1kB4zITFLiuB2B6nSVvJ0i6a7cKc2DCOCXlvtzi8nvmCZ9noND0g
	EMYuZakFNMBHCoaii3Ad+1NdETGr3o/OMEikV62DdF4Nxbz4CC1hnJows7SW9p69MYg3uN30OeR
	Rt84UylCL8p5V9HbJQWpyaZcgTZywI1RRa+OBUcc89YZLcCqx7sm8PTaGxujvcjRko/nrpCdYLi
	49PGI1zydwcKCM0jAkqVBYSN5UbQg1gFZxr3Xu3rymtTUjedynk0DrsDKGLz+pBaQGqEJCktRPS
	8gq/kfr3E2xBS1g6W5HX/BEoc8o6rblt1YVgxGBcXaBs6iazUMT704NMJPPmhEgQSp/UM=
X-Received: by 2002:a05:620a:1726:b0:8b8:7f8d:c33b with SMTP id af79cd13be357-8c5208f18e3mr71372585a.43.1768246097807;
        Mon, 12 Jan 2026 11:28:17 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4cd7a3sm1609425185a.24.2026.01.12.11.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:16 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfNaK-00000003cxB-192v;
	Mon, 12 Jan 2026 15:28:16 -0400
Date: Mon, 12 Jan 2026 15:28:16 -0400
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
Message-ID: <20260112192816.GL745888@ziepe.ca>
References: <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <218D42B0-3E08-4ABC-9FB4-1203BB31E547@nvidia.com>
 <20260112165001.GG745888@ziepe.ca>
 <86D91C8B-C3EA-4836-8DC2-829499477618@nvidia.com>
 <20260112182500.GI745888@ziepe.ca>
 <6AFCEB51-8EE1-4AC9-8F39-FCA561BE8CB5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6AFCEB51-8EE1-4AC9-8F39-FCA561BE8CB5@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: pjbd7psh5pextb7jzmaomfwqhcebjdib
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE76D120012
X-HE-Tag: 1768246098-488726
X-HE-Meta: U2FsdGVkX19RyDwbt4cWLrdnf2S7m9BEAv0E15wV/cKWCmDc6+k/9uSqdHCGF+nRMbFDSnTfYPIMyhXfnw+Xm7d5j6+Utyw/Z5M6+iRnYqUr4Atc+21OMeppCnY3FteHQCWt8AMd1GVDFOx3vfZFgnzyvPGy/p52c3BOocsyCU8bbkKHX9s2hvKy+tdRGJkX4ci+Tpz20FRENK3JwgCkmX5oFeFEPvwQ7osQGdMM4TqVNiKIwkvL0X5wL5b10Mzi8BQESwLa594jIqJ07drB71gKFXqGn4o0eNL7DkANuGYK5Ba+ZkSl2flkhhiXgUZCEF5LdiXXY/ioE6eSdTgZM2qY6FePW58KMVleAs/vCKqkgsFU9hDGKesdrcmsR/mUM/AhTytxrIBXhkeAifAd45Jfw7nwwR+uhMBrFc5CjSSfhximZ2ZGGdIADEqjNm+ACmfC71HD+ZqGcBuDV8vxWV3IRyR1HVmMO3cLVWVPqV9PZtQL9YQSfmNQMYLuUeXj2kcbH6JmSFtHSyTQtiYwHgM2PUc2/UFpEvgupPM06ieWyPGyYjL5F4J+j1TeZ8Q+QzVaQvIJIm4TYYUl3YTDszWyu+OJRRNDBuu66h77GH7Vv9Nm16GqPUxRp6Hx6O6Xj8yDAHKj9fal7+evZJEtmajRxRraJ2DbLP93oIoO6SikK1hIowA4NQq8k/tmWkt8SsdJgND/b+M4hvAuEFWr+lp+zl0F0vEpyv9y43P40B0AK9P5MNIp8+8Jm6upR9C0FFKHi1sQIP/hht3y4UTQhsK49C4MvSbnOpZnvwQ10E7RWwW4hfA9em9/VCO2KXDwezHfnCzkVhL+NKXKcT11XzUURqT6qGWkFxL15uRyBhl20k9vqyIxWSChhCuTxU/bYWwNhdDgAUp+ydfiaLmYHIR/iiDXUlCErc/8Qfa+Ea0cNMJ3mfXN/yh/O79YeFrckrBjDpYReK8X0Jgbj69
 HAtUq9BO
 7TQDuSl+0XG8QhxYFNoXwa/QssRPbI+qkE3lSwhmCGYQpML/ITirmxC1adxU1zJtRRCACrbn5FtN39AOf5Uy68eDIBaV4vGc5db0r8esBZ8l99BOKQ90pp9JQkSBQZ2+waqN9jk29mNStbMxf2m0HLFIPrgSME12greCi3ugfe3+n/y2XSBh6EBG6yLqX/AM1oKPhNLzvD/uXyd/1J/AdWXJ5UfGMJgZN3DziX2La4AmqZYSFLxCuMwN+zH9VeWFfricF5jTsJViGJQ1qeL4gfT9VU/zfzF2FYqXtDV1o/q+pT0SFpn9TI0/buXsfGOMMYcLHGBkEhtoghizyJGpniT2kaZkIcN6YW/Rhg0QBdHCQHls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 01:55:18PM -0500, Zi Yan wrote:
> > That's different, I am talking about reaching 0 because it has been
> > freed, meaning there are no external pointers to it.
> >
> > Further, when a page is frozen page_ref_freeze() takes in the number
> > of references the caller has ownership over and it doesn't succeed if
> > there are stray references elsewhere.
> >
> > This is very important because the entire operating model of split
> > only works if it has exclusive locks over all the valid pointers into
> > that page.
> >
> > Spurious refcount failures concurrent with split cannot be allowed.
> >
> > I don't see how pointing at __folio_freeze_and_split_unmapped() can
> > justify this series.
> >
> 
> But from anyone looking at the folio state, refcount == 0, compound_head
> is set, they cannot tell the difference.

This isn't reliable, nothing correct can be doing it :\

> If what you said is true, why is free_pages_prepare() needed? No one
> should touch these free pages. Why bother resetting these states.

? that function does alot of stuff, thinks like uncharging the cgroup
should obviously happen at free time.

What part of it are you looking at?

> > You can't refcount a folio out of nothing. It has to come from a
> > memory location that already is holding a refcount, and then you can
> > incr it.
> 
> Right. There is also no guarantee that all code is correct and follows
> this.

Let's concretely point at things that have a problem please.

> My point here is that calling prep_compound_page() on a compound page
> does not follow core MM’s conventions.

Maybe, but that doesn't mean it isn't the right solution..

Jason

