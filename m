Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF56CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 16:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883F16B0088; Fri, 19 Jun 2026 12:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834016B008A; Fri, 19 Jun 2026 12:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FE306B008C; Fri, 19 Jun 2026 12:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4401A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:12:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEC4C1669B8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:12:01 +0000 (UTC)
X-FDA: 84897153642.16.F6095A4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC541180013
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:11:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=J8ZZ3toM;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781885520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzyfc0EV0DVFxoCXoE+wDAyuQ9YJFC9tEGOxfy5XavM=;
	b=xPUK+8pI4yrks7PWlOvQTEyPkWrXal5/pFLRd44yYMUX1uw+fi+BLY+h3NyW4oV7DImyl8
	5/TZDDNGd6/EmZ9JdNlIoXUrGgW7rseOIpkMgpL8BrnTMzU8zSpiv99RCpQi/CWtj6oYXa
	PveJcqJ4R40ku6m2/1dboX57Qg9ACr4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=J8ZZ3toM;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781885520;
	b=GNtTy10booOEtMkVW6Adq7CqDIM4NzGJIhyu3bdB/8EH3Q/isLsfAcEtvz7Ys7CPQZno/W
	O1fgTvMpJxtqlzkSztoV0Fhm+R1buTmAHxN0KhuzuoYhmD3BSl5GHH/aOrR0suLKnOPuIe
	HYnPV74ed0L2pZdsF8loMkEQzbOXGl0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pzyfc0EV0DVFxoCXoE+wDAyuQ9YJFC9tEGOxfy5XavM=; b=J8ZZ3toMwIYOXPEDK90lLyAsYu
	soePp3G/naanNY8eL5d1gaoCWf2BSEaWww9XlJ2NtwEtH3wJIUkD2Xz7WoHEKj/K0YCXIrPXRFmXy
	KQssQMTI5BrMTpJA+P4xx9U7BIHdSUZsRXa5e52ui+FrXuTFkY0GIl14piQLe7NGC/jtz+YxGjFsq
	IA7oS+DGjhq9gbC2D67cwtfJrAdSiLMfqqFgwASF5wBCWfYnDU5RYxJVJLcwQqnKzGpqIZw47V7G/
	zv+JLng5tc3D1XlW5Nw/swlNDgH5O7KkGXxrmvbogkf1Yw01EGJcWO63vZrzptSU92LXL9xmzSBVJ
	CxDMjbzg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wabos-0000000GVXZ-3IRi;
	Fri, 19 Jun 2026 16:11:51 +0000
Date: Fri, 19 Jun 2026 17:11:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajVqRiAMG23QGseC@casper.infradead.org>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <20260618152805.GF231643@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618152805.GF231643@ziepe.ca>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC541180013
X-Stat-Signature: hjxh9apt4mtpy7j56x79is79n5ax4bzk
X-Rspam-User: 
X-HE-Tag: 1781885519-158540
X-HE-Meta: U2FsdGVkX185ZFN2kKFRC8bXH0fLEPMfanj+f2CIy9laQL3+z/smshNbboWaVyzxEu84jlvQGYMMhk4m0oI/zvJHjz5cBRFn+3ya3rjyFSfuAOZQWU6IVNdzK4rCw2GM8WVFoC2dKFTdh4T/JmoxZfsQXUJJpm4+0AzBhplpj732nCPApVjnFOdxeogse2VPOd4D/s8FNnGJPpsnRGmKkj4Yu2bmyXaK6fEEZlMrXEYp6vC1MehElnUg0sokb+xnOU0IOfY4BW4rboqLMoHR1dulLqig2cSmWmA1T4ggGRh3z0Ey+mEmSdjuOuHODMFJYAewbMjTyFFaM7g/Vaks1uRuNhFxcy6zlgQ+qZyyJOI0G4HS8hDTBQWI1eOru2xtxT4ijgV1Dwi9zxM8SRE/bQYXcgqO271xGsIHmM6cKzw3fTu2rN9sDokAWQXjniUeB/TJod8B2yzp6BtLl8G8A8Yptoy3rBJAKETHHSZ4ageL9KijykTqsVr82JtNCBB06fSO9HWf2pwVfKZMoCvdCqVmLbR8bnWVdOoDQ/wkJL4SjKgBtjUp19sWi3t5y5l/UBBS8IgupGUsiWFYECuX3a3Rmh+FZG3ueBGrTyqG3tEDkTUHDP2h1GvQT/iLmZtXkW4RRkoHxEJbXYrD1gAD7N92PcqEqo/IqCcVhLdhKZIUGgzw4WAmi0bSSu4Vo7B7zuEAeIBq9Uiw9Uhctza5EQzJiECPJyHqN+BeE4mulYxjw3PoLsfYdhv+o5uhREL5/chs1PE+7sx7lW6Ta5IAsX92gaGbbdSKgJQzYiq/GAmMwWGGPw0rFjxBMsCD1ShlEO0tEiWhY/ZCw1H8AsBgIalWjVXdfNJFvyxszRohBUXgDp9gxEmK4igyPj7Ime/Xz7xKNugFefCNquan/0bYGvRGg3y/t6GCaSSztnTQm8I8eTErY0feIhuuvIit606RSUGyO3dcLg2PjMoaja/
 d0sU0fll
 oUDfVHXZPG0G42jztggD3+w2rMFLIneUzKTOScd+az7vXHm1I0+a1K+j8cul5h/QRgZLD8ZyTTiPZ5TVpySCh5r75ZSfjg3IBXSG7SApIYhZiVER001khEsJ/Az4XS7yw4f7Fro9E1n1mcSHANa73/c5BcHhniFQIum7Kz/LAp41ukUbR2UufDxIQcYi70LsDdA8OFckgxqlswfLXuv1NCFrVHfupBYrvBL8n2QEdtg/8rPKnlgIOP4/JXIYykFC+/5ku+KpZsHp2UN5NAHJF5ASTmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 12:28:05PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> > Can't we figure this out from what the driver tells us when it invokes an
> > mmap_prepare action?
> 
> VFIO installs the pages via fault handler so there is not a naturally
> existing way to pass in the pfn?

Is there an advantage to doing it this way?  I understand why we (eg)
demand-page pagecache, that's obvious.  But I've never really understood
the advantage to taking page faults for PFNMAP areas where we don't
really do anything, just figure out which PFN needs to be installed.
It defers page table allocation, I suppose.

> > Not in favour of that, fear it'll be seen as a new go-faster stripe.  Ask
> > somebody how many free pints they want and they may veer rather towards the
> > upper bound :)
> 
> I think you need something, otherwise we will be aligning VMAs that
> never have anything larger than a 2M THP to 1GB boundaries, doesn't
> seem good.

If Lorenzo's willing to move the mmap_prepare call earlier, to before we
allocate the vma then we can do it that way ...

