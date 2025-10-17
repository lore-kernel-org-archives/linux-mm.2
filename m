Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCB6CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700468E0031; Fri, 17 Oct 2025 17:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFE68E0008; Fri, 17 Oct 2025 17:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5779B8E0031; Fri, 17 Oct 2025 17:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41ADC8E0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:43:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A0A21A0335
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:43:22 +0000 (UTC)
X-FDA: 84008932644.29.A8FE668
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id F05D1120008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:43:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Pb3rtC4R
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760737400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7o2YWfTYWvvpeEx4JrqhbgEy4JzUWFniUNRW6oSBlM=;
	b=NN8El3Lq03O68d9FOxDEbT1507GWHYJvu8yyemGJphkgvCfSz2ObX8cOv7PG5u550rK3Kg
	Yb+F17prxPlAFupWnQjYmkrXJdBqbV7HN23gJq44Y8MjqqNdlwB2clY/dj6wsEN9rkijGe
	tf8zTaH/bZCyJmIgvtUMLZeZzU0ZbD0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Pb3rtC4R;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760737400; a=rsa-sha256;
	cv=none;
	b=TvmbPzxutAwT0mcR7yfQTVtfWmyBNzMIiLXJpd6IMTTBMLsLKJA8LGQcoJcmLtq+JsH6WZ
	2wPu1S+hxIFpvpHTAszRdun9KCJ2hd//aFMqAsvbyTumV9HVIQHtY+GOJgZ5isHhckPIdK
	vUv44sP7v4h4sLSu7O5uTlVnjY7zZC4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=x7o2YWfTYWvvpeEx4JrqhbgEy4JzUWFniUNRW6oSBlM=; b=Pb3rtC4RdF2NsCYvJ4A9cC5+o5
	DV8vVeeFeVXh5fcNYXzcVmqJP8Vx6kBRhiYXuemDo+IX6LkKZWcKJRv1Ej0vSH3AVNBFG40U6V6Sa
	oa2CFHVvwLl+7WzdLCg34ITSujSABfuuu4RppYXDdrzwkuVJlveiuSnDFyloJa/RUQ5RZXDRHfqqh
	1sA6V+g5Sh/ypi1O6y0ntVjA7p+vo04vGDBaHgx2B64xqSD5vNazWjdpKGFtbuVHZbHdJyvqOZe/Z
	VmlxTUMp5if+N3N8KH+I9ZTl9Ohdc46Zq18kx5udsjizL5owhw8t3q1Nkr5Pk9ZmAg+2N4qM9JZHs
	tv/Vsh+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9sDz-00000003bne-2gZi;
	Fri, 17 Oct 2025 21:42:59 +0000
Date: Fri, 17 Oct 2025 22:42:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: =?iso-8859-1?Q?Lo=EFc?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
	=?iso-8859-1?Q?Ma=EDra?= Canal <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?utf-8?Q?Miko=C5=82aj?= Wasiak <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v4 03/13] drm/shmem-helper: Map huge pages in fault
 handlers
Message-ID: <aPK4YwMmYTDsKHcL@casper.infradead.org>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
 <20251015153018.43735-4-loic.molinari@collabora.com>
 <aO_ZmA6yoqbzTKt9@casper.infradead.org>
 <f564735b-7cbd-486c-9dd4-a4555e73edde@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f564735b-7cbd-486c-9dd4-a4555e73edde@collabora.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F05D1120008
X-Stat-Signature: nwy4hsge8buzfmjkykn3g9md8apcw5d5
X-Rspam-User: 
X-HE-Tag: 1760737399-334039
X-HE-Meta: U2FsdGVkX1+2AWpRGrHUhBb7vlW8l+AMqLPDL9VXgVqhQGdjaEdGeucLEHRVSJBg6rTm+/daQQdb1ksR3lwjcybf3BmrCiwBaaaKGYTgYvYsv1dNilreYLtAy2+t1tu95g+QQDVcHHt1WA4fLdz8uW9vNjXOcWtIm9hfnkwQxDmHEChdZY+rU33TuHvUxQ0ZbTkhCNc4Sj3Zxp0VgogGrxQLDRZe7G/e8hK+SHcbUpNCGTTnHKL2aEQOhdaKcpXaauO2X+uZGqAMQ6Jpc5SXrVwiH5r2udg5yodjeJgqLGktka4qhMj0ZHJglcER9e0tPmzYp5ySFna8cSsBP+IlD/cyRR3RL1ZUF2qkevfwYQJbGpopsdgip2V2jc4j7KTVnizbdwkQfAxnM2CdC5dgEGlNS9HsJ9n+ECQ2hyJT99dnkDM3AjMlVl2g2EE1N1U5wUCdRG0fUqTEnVKukol2yogwUUV2/HqZPlKVV98FMDzYYgACvXidZJdlF8vCe0H0eFQ/0HacsXs/rbIwFbsfbyRtXbWLvmnTeZvIxVeH9YXLCigQfQvDV876YV1DiL59PBE7iDfyiYFVfbbtW7yRMuv7+LIqwta2gFXeXLAvPNrV1aftoSWOexQ1oP04Z6C62GoZOjDvsMZYS4YmojH4Kg6ALc+a8ZyaqXuUgz5T3oyNSjNXS1BKdpJK3n3fhDLg94jgoXt8Cw0VQmJEYpl76e40cs/HC19RVciNl78tr0I8pr01DrzZDyOsi+CDVplczbVhzVZH4C2YuS15dOQCejDiEvRqytV+k7O8ppXyVZ4w5xtjNTUdXnaDNpJc5TwzzHPQ4/mPifOuvmYic2STgo7bVMIJ2ylrDuKfkNJig6bvmhFIx8J3GFcZA5ug/zE5ng+J7JEr05nEO6hC53Snw7Wvqi+b8CcObox1ujjSaa7jlGCBdebWW1A4y79oRz9lFH9SlaF2sA9d3o1wDN5
 VbznCy9m
 /el1KvAbvfF/1jA2e7tNlrcJkQpzPX+Dl3XkKAl4IXqj7+56dbXO7VtHL9/F3qS0Ks6l15jvh3iwwmW/aLV0wQjIpDL9xFTyuwmuKWcNT2PFdlESd4kGI5qiERwc4rJ/V2qtmVZ0hjEt48i3/pcaPxkhhTGahBCbk3YFONjB6eB0jAGqFV2wZ0XD0Za5hCTnyVKvSAgwBttE3/Q8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 01:17:07PM +0200, Loïc Molinari wrote:
> > It looks to me like we have an opportunity to do better here by
> > adding a vmf_insert_pfns() interface.  I don't think we should delay
> > your patch series to add it, but let's not forget to do that; it can
> > have very good performnce effects on ARM to use contptes.
> 
> Agreed. I initially wanted to provide such an interface based on set_ptes()
> to benefit from arm64 contptes but thought it'd better be a distinct patch
> series.

Agreed.

> > 
> > > @@ -617,8 +645,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
> > [...]
> > > -		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
> > > +	if (drm_gem_shmem_map_pmd(vmf, vmf->address, pages[page_offset])) {
> > > +		ret = VM_FAULT_NOPAGE;
> > > +		goto out;
> > >   	}
> > 
> > Does this actually work?
> 
> Yes, it does. Huge pages are successfully mapped from both map_pages and
> fault handlers. Anything wrong with it?

No, I just wasn't sure that this would work correctly.

> There seems to be an another issue thought. There are failures [1], all
> looking like that one [2]. I think it's because map_pages is called with the
> RCU read lock taken and the DRM GEM map_pages handler must lock the GEM
> object before accessing pages with dma_resv_lock(). The locking doc says:
> "If it's not possible to reach a page without blocking, filesystem should
> skip it.". Unlocking the RCU read lock in the handler seems wrong and doing
> without a map_pages implementation would be unfortunate. What would you
> recommend here?

I'm not familiar with GEM locking, so let me describe briefly how
pagecache locking works.

Calling mmap bumps the refcount on the inode.  That keeps the inode
around while the page fault handler runs.  For each folio, we
get a refcount on it, then we trylock it.  Then we map each page in the
folio.

So maybe you can trylock the GEM object?  It isn't clear to me whether
you want finer grained locking than that.  If the trylock fails, no big
deal, you just fall through to the fault path (with the slightly more
heavy-weight locking that allows you to sleep).

