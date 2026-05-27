Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64228CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7306B009E; Wed, 27 May 2026 08:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BEB66B00A0; Wed, 27 May 2026 08:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8231D6B00A1; Wed, 27 May 2026 08:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 745756B009E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:20:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CFE2A05A4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:20:19 +0000 (UTC)
X-FDA: 84813107358.12.14B6136
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7888080010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:20:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779884417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZA8+TmQcaS7R9Nc+YydDgTRxXVQD8DuYCNsMGFhSyME=;
	b=5zFY9kRAXLTKqAlEdq0q8hvFWSOx8Fd5U7KWuYv1NiOqNjI9TZw1qsYMIjZEbcFuCKiUO5
	QwOcQYMt2zTwA3Dh+7ZmrDSTx0q00s4aOdolVBuxCoscnmLMlPrATkbd7yEHjLjLAOFij3
	TExv2yxhJMT/y6xO1n3WMQyxJrpgWoY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779884417; a=rsa-sha256;
	cv=none;
	b=LaneF/m8am5kP8pKMrxC6Ckk+QVhgqNKEs1ovb+lK8SZN7WhFw6Ik99umq8VBDy4IwyGMj
	AaJqD2L4RX/fUutL813NgKff1odzWiKw24lhj1+EHj84cBgMGRtK+uj5mkKslAyCL/39LY
	7ILWh5S2U6vu6Hxjoh01PmMDicz/ZHE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id F307A68B05; Wed, 27 May 2026 14:20:13 +0200 (CEST)
Date: Wed, 27 May 2026 14:20:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Message-ID: <20260527122013.GA6765@lst.de>
References: <20260527070239.2252948-1-hch@lst.de> <20260527070239.2252948-2-hch@lst.de> <f7f35169-f77d-4678-8797-a2ad00d89e6c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7f35169-f77d-4678-8797-a2ad00d89e6c@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7888080010
X-Stat-Signature: escja3w711tnhd4f5d9kykcnyum7srix
X-Rspam-User: 
X-HE-Tag: 1779884417-913546
X-HE-Meta: U2FsdGVkX1+45jlC7yyTTvxSPEG4+Qhi9iTXnxf4E9MYBi2nHkt0U6CrrkjlsP2ukXyOtqCg0SdJe6kaDRdzj0CqNHbrZHH0jZU1Jymt/mYXNcVrltkRWTFcOTs4jMWwwFNGMpSEkjs6qJZCIJ5R7FWTJZVKPXIs6Gl+OC0XUFJDcpo82m+MxNhxHJP+Eg+QXbM37spbrnHMG4YrebVrAhrfWU9PML50AFZqbB0FUdoLf8SqhCHnQx346CAbYds9v3SnDbzJL33JdXkkccIJ+ItlYkV4tfP7Mufk1oTUZgm8VBSMooVczCt/rT+sYITYiEYCJJCMxQ+0MIj67tJ+xM0J75fe/0AwYDUsbeMvZ/LwkkKawlkXmCyqLxUFeeywCFW55PC1oUv8QWLUstOdcVzS8RRZbUhm2qTKWd8RbWeeg4GPeBM6WNjEqu2zCXXW0MjFi9iGZd0p7ZwWu/6wXU/N362nQSlFmJC1HacYVnr1j796NrrTVNERdz/4IE4CNLOrf5/9mdISZ/ciki0pvolIpabDj5qffvABeByVSxtH44INP0MNA8KoImt1evLbfBUolfCA3HyYupC04oqjoB3yrxzbfu+sW8A17fqhCyTSNf/xKnEEbBGvWXddbXvxku7JaHDKqXDmxd0iiulq9vmQbq+T92eX6KOe/2DmgajXYbvbUD4rGF++K/bXMViowfu0QTJVQMPlQW8yvHEMCBNPiY6ek05ICGnwSXm0bcSNxakAALyuAe1+Q7Npk6C3Vi9af0Shl42RhjCCXLoDPD6MbF505lfw0Lqe9xRP479Hv/18/rwgwVUy9agdgvUZxbSDs3lUiajHGSWcRy7dyhJaY71FM518YKV46VQ75JfM8ouBwakSqTfYVxoTwTr7J+P62BixA6evKmzIm+kK+ILOF7xQGhtSqCuc6bNHBiED/r2krkoJfdMpBtSRtM1Grd43MYtfA7yUZZsDuqK
 yK50anx3
 rD0y8UsgKNvencAaCPyiWzexA3HDH58lQZU1UhGZKMigr5e/b26X3toKQ8dOlH2HxCrDH+fhW/Yvkq4havJvEFodVBZbmuJ+F6z/6ym25Syd6w6wOZ3seNhHNVwNPXqM75C7mKiQOHgDPsjORWhfadTdCv6UTqJE9uhENlxDZHR4zV+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 11:38:21AM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/27/26 09:02, Christoph Hellwig wrote:
> > The kmem_cache_alloc_bulk return value is weird.  It returns the number
> > of allocated objects, but that must always be 0 or the requested number
> > based on the implementations and the handling in the callers, but that
> > assumption is not actually documented anywhere, which confuses automated
> > review tools.
> > 
> > Fix this by returning a bool if the allocation succeeded and adding a
> > kerneldoc comment explaining the API.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Would 0 / -ENOMEM be more like what people would expect? I guess both that
> and bool are better than the current API.

I find an errno return where the API could not return anything but the
specific error code a bit odd.  But even that would be a lot better
than the current version.

