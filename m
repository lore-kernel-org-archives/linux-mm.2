Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2836606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RF/8DK12
Received: by kanga.kvack.org (Postfix)
	id F04C16B05B2; Fri, 20 Nov 2026 09:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC0F6B05B6; Fri, 20 Nov 2026 09:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A6E6B05B7; Fri, 20 Nov 2026 09:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2DF56B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:36:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51D4180FD8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:36:21 +0000 (UTC)
X-FDA: 85455747762.18.BE196F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 893F140008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:36:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RF/8DK12";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795185379;
	b=iuqXO3A1lQSLi0WnDdYUsDMVZHnxfdZIFeP+1Jk+iBXPMVFQy8Ia8Jel9Mp68OaR54oJM0
	JMoYFt1OLKRNfSuS2f5GUVyqdITk7RHF+2LJT7tZR0p4PHJ0XOcANNAST8Vl4CtPMUnNar
	gCis923wZp1ECaHb5l7Gpu3Pk/B5rSw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795185379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMOyn5lZK8F+FC2nwU9eJQ2Ic0u6hcRi/jhTZjj9Mvk=;
	b=T6QgKU3Gh8TussdSy2vqc41MaNw16htLB8el02oJmMj0xbnGjN+fPC1xJjJg09phTGjQa+
	x7AOCgLj4HCB6q5q42AVSkVsfVccFRZDhsCJnNeSvP4Ua+t4/+rOGXinKJwkcrQQwQT/4L
	qxi8MmaJFeXfyl8HychUJB5r/AQ2t4I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RF/8DK12";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 684AF460C1;
	Fri, 20 Nov 2026 14:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634851F000CA;
	Fri, 20 Nov 2026 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795185377;
	bh=aMOyn5lZK8F+FC2nwU9eJQ2Ic0u6hcRi/jhTZjj9Mvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RF/8DK121mnm1zavjVGPB5fyWIqpsPt3RkMcjQSO7nVuLPyzhULSY7VJ8tgWd92Wp
	 m5/EkyNoU7Wy4FnigM6acB0fR/zU0d3cp8AC20ZBhGM89M7sbu+VtMLyw7smiDGJ7o
	 qmEKeFVaAhuRrAiQ+TtwLA1QhlytBk+Rsa/JEFprCx9SYgRIT8gVSpAjDxclmIO0rp
	 GLaWW4nrUAxaPB1Jp2uViccsPQI9r+3tNEFsHjAkkI8hAsb+Y/lNbK9SIufkMhzsWe
	 1kZV6p0c5oYrljsBgA65aUmPYzUz4Xzgg/0LNXnoqGa/PAie0cI8Ui6afRuhiln2Dv
	 Hox4znu0xNXxQ==
Date: Fri, 20 Nov 2026 14:36:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Christoph Hellwig <hch@lst.de>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <awBaxljohIuCg-UY@gremlin>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca>
 <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
X-Rspam-User:
X-Stat-Signature: 7ppm9fz6et5oxfztpcmjjqqj4jcc5df6
X-Rspamd-Queue-Id: 893F140008
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795185379-586539
X-HE-Meta: U2FsdGVkX1+3TeCdrF7W2xTeR1y6RtUQX/5yxAIfcjHFz4G/kaSNfQeYHtACynipM6e3OH6ic/d/6zLH9vFVwI53b00p79IbIseifegwlfmyHAURoxHM0+48k2STFZHONU8V4yABG2Nlk8oK8XfF5VwetnTT2UECrSJp+Wx6wxRc4WLLgXjhfYdf0ZePVG4lSJvH2Zpf0omQbvPoSHvXFOM5itjov73eLxsbfZ6loAo9V0A36YppL4ETzyWsI1y+ccqtgdg4MR/FkLmPAEPD8Rcp7K/Akpz4mmdFM4nsFNrNbTvpD5CYwpuc9DzmoxYTgDZPogHQw95TLQhE7h2giyy17HrZVtAS3JlXseFlYn1bD7Xjy4d7f9cINHeXEpvzvGBF6PnO5lKCrEHg26q68IILNdZSk7E7bn5ke9umJ/33yFqTNe3tmFKvESVpWSjKF9kJdqNK0wnFtRVCGcX/GEx99w1/P8DI3AONRYfcBZtNiclEd76Ps02FFrqcLRVArwjHcvPbEuwbXUvL/10ZaALrGMhZhXQQJfTetV278/vLDcWJqqATv5a12E7luNUeP9M3Owk2wPAw94RxukgIwnRUSasJ17NOPlbZRU5CPXWGnTqEC3cpojIB3q2aOQSNEkWPSlKc+9o8Dib1hxP2pYHwpT1sQ3BDbAqjSWkLYaKXhanswHCAkRYUbqgSEVVczqbfohTm7BSlAJO5FDPIir6D/UFjsUkR/su89JR+ytan1TSpKpUmETD1UlfTkUbucfR93tf65upNg8lUoEaKMWBUW+pQhUOqy2GQE1rPAwpTtxYIopL4SFT/FtUWjvz7odi3NXgKM5OB33LoQTdUvSnfbve+vi2DMGaUR5NkkylKEcN/PA9d1KrQ6AHPdxGQpLoSzbARx7HE/ZwswPgLxfxYYe2pPKjRAbmLX7HdMu1PiZ7MflT0Xzp1nsnikBDvOTayrZMLrggdKrwowWC
 FGS376YB
 8kQEY9L9THHVm3J49WltTK8q7NxWKczcWd2B+zuWVbI9wPURaNkS4cisudHEJNdruZOv6U1g3YX4siuePyCWs3PiP/LWooG07210QZF+fB3nETjeLUQprbMhH3hMsYCp4tTupiqtRxOFm+9m1UXUh9tkUonAxuQFeDbGxeAQ9Ywm35jS9ob8Gk2QmYvqrlBbpeFuI7jc9hyeGwKP3nZ3d7Gd8/KFlpCxRlj7EXzrtlfrm24CYcY6rDwH1vDtj/gRSsMeT3+ewz4DoCa8n5Zs3RHR5zBxCY5nkWJ4k24Sxs4s3WdLnVQTnEU5K34Yg6hSliW86x44fwFfteoRmCvUoDo7bmoh57qwdmU0beZvX7ltgdfjKZrfoviMdHx3t7w1fKvwZWwfliJAgWZzdqKCWs8fazKVR8tE57NAP6bmDyU6X1R+TjgcRNbRceqpW9juQgHVKz/QZzNAjMSLHcDs+RRO2ndxV68aRsHAWwu4AOUJrnaQP+HuiJ5gR8V+SvvAvbgl6z+2asZDRgLKq8GBDKdLnYusnPcruKdBQCGB4TcGfksP26Ku7cpNuSOHG/czAgdzdP1gClNU+oQeANRJfZWd43jsa16G00OcOHGu0vBykQdWD8Lzt9fOSoXdJRevq63TX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 03:19:34PM +0100, Luigi Rizzo wrote:
> On Fri, Nov 20, 2026 at 2:50 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > > This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PISA
> > > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > > Documentation/core-api/pisa.rst (patch 25/25), which has the details.
> >
> > I thought the conclusion was to just do this stuff in netdev pagepool,
> > now you come with an enormous AI series spread across the entire
> > kernel?
>
> There were surely comments claiming nothing outside net/ cares or needs this.
>
> I respectfully disagree, witness is the fact that e.g. there was already an
> io_uring proposal which is smaller, but does not address applications
> that want to use the standard disk I/O paths (libaio, buffer cache etc)
>
> Nothing has changed from the initial series in terms of size, use cases or
> subsystems involved. Large files are placed where they should,
> the series covers the same three use cases (disk, network, CoCo), and
> touches three parts which it has to touch: mm (most of it; it is a
> memory allocator
> extension after all), dma (it hooks into map and unmap, not a large change)
> and net (the pagepool change is a couple of lines; the tx path needs to
> touch more places because the current stack assumes all paths have
> the same I/O requirements).
>
> For CoCo, there are very fine grained controls so the bounce buffers
> can be enabled only when they don't pose a risk, which in turn
> depends on the threat model.
>
> Specifically, for network tx buffers or disk writes, the user-to-kernel copy
> is basically a bounce buffer provided it is used correctly and not leaked
> elsewhere (which is the design; of course the implementation
> needs to be verified and possibly fixed so that it matches the design).
>
> cheers
> luigi

NAK.

Cheers, Lorenzo

--
Cheers, Lorenzo

