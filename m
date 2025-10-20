Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42897CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 12:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DBD78E0017; Mon, 20 Oct 2025 08:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98BA78E0008; Mon, 20 Oct 2025 08:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853858E0017; Mon, 20 Oct 2025 08:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DEE18E0008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:29:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F9011DB8D1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:29:14 +0000 (UTC)
X-FDA: 84018422628.26.6C000C7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4EF3A120011
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:29:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=q8iqZtUQ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760963352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2Kl2pqSvM/DwC65xqTX+wH7gL0SbGwP8PQ2xts6fnA=;
	b=V50VDL9cJfODk7ZhNaOiNrBPo+5jwjCk6PrxCXnJ04u7jdFJJZdVRPkiJFkqijyF3w3moJ
	QMrjfwYkVNW+9QEEESoNJO3n9vY/FPaBLv68r8E0bozC8q6dqgOKG6/rafLVTekI/T6tIC
	ARNXpKuUZ3d8uX4UmXQ8Ee8bU5z2k1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760963352; a=rsa-sha256;
	cv=none;
	b=Jeh2IhBEUD9OlbHbLsux1tGgrHeNN2UZWpppWN/R1oe+g8WRA40l/5oc8W4Oa0PDEP4N37
	kV7nlsAwpihNX7QzHnQ2A4FIbrSzfbAlzKw/nGBwsCuZZ751paN5xz5E5Wo0JlKOMkB3w9
	TFwI2rVI59YdH1bPmIxlYB2lwgnjsv4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=q8iqZtUQ;
	dmarc=none;
	spf=none (imf29.hostedemail.com: domain of BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D2Kl2pqSvM/DwC65xqTX+wH7gL0SbGwP8PQ2xts6fnA=; b=q8iqZtUQMhHpWIU8trMyOMnPX3
	BZqhJjT2rj4YxZ+9D73G0Z+YCyz4jXlRjVJ4lNjBgB+0FK5YxXT42bnIWmrUvlkPLXRjcdFhbHoBB
	kFsZBpieGZtmo/cO2AmeIBYoggTgIhkLMHFgZ+De0ZWfyJFUbUlozwhj8XDQflAY7e4QFVaPMyrf+
	OfKOJzjfmWZ7MedU2Z5uSI0/WGgtgyyw+nKi7sc0uEUSOgNlGDQnCF0v01aztMT8zBXcZkgZnb9iw
	ZagOlv7l1/BMHvqxSRlvgGCW+ONU1nBe+emsYjFrL6+N7nySloF7g9v/Y48V2dOI6b3xoyUvWc4+l
	c5fu9esQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAp0c-0000000DQ8I-3O4V;
	Mon, 20 Oct 2025 12:29:06 +0000
Date: Mon, 20 Oct 2025 05:29:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/9] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <aPYrEroyWVOvAu-5@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
 <aPHi2c2BQNB4eqm_@infradead.org>
 <20251017121447.GH3901471@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017121447.GH3901471@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EF3A120011
X-Rspamd-Server: rspam02
X-Stat-Signature: csp9jh97njun3i5h4hc3g6m9h5kuiyfi
X-HE-Tag: 1760963352-609351
X-HE-Meta: U2FsdGVkX1/8to5DVLxCyxdhNuFsUEhvk5UspSRxcP+r0SjfS5UIdlnuCqMvFvoWhk2MU0i600yLPFYoz7YA5YL5WZEnansWeO/tR0O/EqVLV/rH9pDxDUfuaZlkRI1OzAX8e/8Xm5B6g4ndX0RijwfzeFvr4XMnKhB2o/63wt/6vvCbLTEhmRwU9kJqfPy+02k9JnjUuxLHV86NH7BIU65g+XbBZpazM0Pnl7NdMwruJQPSPtky0PM4YXb6Wg7ZzuXX22H9ka3RkauI/BM1y3LKZyIuvY8Vj6AcVKIIAwfiTz/F24upQ7bh3Z8SdjTJPcloVqvN78r6tTrYWB/xKBUE5eC9n2JlOPOS/pqs2gGTdQqc5uuTPeclB9+hooZgUwKCu2lk7mC6R1LfllZec8Hil4T00513lFW1lPkVuWKS4DHJucOAf/UlM62rmwuwXVreOHj7gaY2njqWu8hmXaxvnOWOv1asNvgZuR5l3mvgEi18uKjtbfXmLuWmw9T8GA9VZ8dkia7zmDY8xOQUEPxgJTtMJ4JbwgTjTZLRbJ2m2ETOz++EAemgseckh3+sc7kGm+MfoS9DXArJnUR1jylN7RRcxwsOF1xr3M1zBfYdB78AmZIUsZP69w1kyfmfmTX2T3WrUUbdbGq08ZRYZ6iTrrBf0cuCtZ0PKwwPnIgfBGShIOHExUeruFY3JeUTJGu9RFXkV1lDD1sQlG4VMPnsR9dClnakrBsK3SFZ68FzElE85Ix9De5PJlFyn8Ti1QyctjBvRpVN7ZmZxLX+TKnW+/pyiR4qfJSfAt4H3loI7YdtK3fTyA78tO076C9FvcLoQAVtMVwRpJYd63PUb4r5sMG94VCylrEwv6slBp6tK8P+g+WeHRbZGM/wJf8qvZ0r4aISAxylhhD1+qkRqxOLlxWaH8r6eUsfxjUfUcCX8S0vf2rX4NPSbBDDOv3suLFl171JEJJMa93jCWy
 lRU3tfvH
 y+025ia8K/Su0hio7qmOuHYsHBKXLMHfb0t11j5vASl0A9s5MBH3t/NqNmIttq4ZR2tkLQ17VlsNXHkSNiIWghTFzA/H+lBDwF3GE5Alog1RoxU1yBEJY3blmfYDa/swsOvxNZSiH6gEOzb6X4M7k86pSEpHOvDPJw3XGfAufjCMmqVkF0IUgDHD5ZRFQendT/mdHbtmbV4v1C0bFy5fSmHXMeBQbN/41FJAxC/l8XGL8WIIQalfCQInjBnE9WuFOFqOpDtcpISUO+xWlGnxoLblaHd5FErKtynavfLQCS1c+4/uYP1AZT1ESuzOGh3CHi2WVDOPHGN/nFZex1wGDDAoDhJ6t69GbWmN0jZCO7llEsCS88Wd+g2jm7FBnHwY3BnpgwcPs82nOmmtzu4npj9awTlBMsYhlF+xVUfAAMW2o+NSdMAccXgHIUtCnI2nUmOlL4fzn6P/FRG+j9xGx4XEK1ComXKqlEDAgluZi+DmmdBAuX8ob6j1fuU+6qZyeNcS1ie6pg9wojVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 09:14:47AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 16, 2025 at 11:31:53PM -0700, Christoph Hellwig wrote:
> > 
> > Nacked-by: Christoph Hellwig <hch@lst.de>
> > 
> > As explained to you multiple times, pci_p2pdma_map_type is a low-level
> > helper that absolutely MUST be wrapper in proper accessors. 
> 
> You never responded to the discussion:
> 
> https://lore.kernel.org/all/20250727190252.GF7551@nvidia.com/
> 
> What is the plan here? Is the new DMA API unusable by modules? That
> seems a little challenging.

Yes.  These are only intended to be wrapped by subsystems.

> It looks like there is a simple enough solution here. I wanted to
> tackle this after, but maybe it is small enough to do it now.
> 
> dmabuf should gain some helpers like BIO has to manage its map/unmap
> flows, so lets put a start of some helpers in
> drivers/dma/dma-mapping.c (or whatever). dmabuf is a built in so it
> can call the function without exporting it just like block and hmm are
> doing.

Yes, that sounds much better.  And dmabuf in general could use some
deduplicating of their dma mapping patterns (and eventual fixing).


