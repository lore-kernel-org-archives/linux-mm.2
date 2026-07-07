Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1224DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 05:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C706C6B009D; Tue,  7 Jul 2026 01:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20C96B009E; Tue,  7 Jul 2026 01:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B371C6B009F; Tue,  7 Jul 2026 01:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8F66B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:06:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D527F1C2474
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:06:31 +0000 (UTC)
X-FDA: 84960794982.08.A9D205B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf12.hostedemail.com (Postfix) with ESMTP id 034EA40004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:06:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783400790;
	b=8XpnmEA/qIYlmpmqPc75QacUPcKP/fCXuEyY01HNcSIdIkrCjTh7J7GumqqlKSaJjx13Si
	cwuXco9/O2B9JxOZe8qboxjTQiw4+kPgnXgDT2o2NRfuv0O6qSwfHvfbkPl0ucye+7cT0L
	mCeg/dV7JQxmegCNx/v6AMqILth/k6Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783400790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16d7MGYrUqikrUDpqdgMw9MblR401tuy1OFO5g1w2FA=;
	b=3zPG7pWiSFjOxepWgVizbI52znDq8glHTZOm92yfriRmHBFAlaFoixjGN58loVlPLLDIi6
	ADUGnk4c/o/ZafC9+T1mYsl4EiiFCp7M3w8P2HHX4flboLkzj2QQZcp7rDwI671Q07TBve
	0ywaICPdQhc2ahiISXpS7azEGYqsQ2A=
Received: by verein.lst.de (Postfix, from userid 2407)
	id A196B68B05; Tue,  7 Jul 2026 07:06:24 +0200 (CEST)
Date: Tue, 7 Jul 2026 07:06:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev, chrisl@kernel.org,
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org, dri-devel@lists.sourceforge.net
Subject: Re: better block swap batching and a different take on swap_ops v3
Message-ID: <20260707050624.GB12963@lst.de>
References: <20260706132206.935272-1-hch@lst.de> <20260706102118.6b6ecc0557edcbb2839e2ab7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706102118.6b6ecc0557edcbb2839e2ab7@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 034EA40004
X-Rspam-User: 
X-Stat-Signature: bme7x6dfmayf1hchm5q161qszsx5wsg1
X-Rspamd-Server: rspam03
X-HE-Tag: 1783400789-186026
X-HE-Meta: U2FsdGVkX1/nYMHscbix6G1WMjaNY50fH3X2MzmxQIdUEBx2KdhNjula76fAusX6urnIuEyqQJSRzeMjJsPAzRjf4TuFNYr3Qyw1Ak9aqW5sXUtk3yNzfXQZJsuqnOu09cCdN+zbNJ4076wu4Nrj5J7FR7GT9E9yjmtsHFb4UX/pmpG5qBQ2SRUhVspFvP6nAuk6JMdUD/UR/ZJQx8KZF1pucxKSBnAfXmPbIjLpeQfiOg8QQdyfu633rMAWTVAepgRijMvXNYEKcgSxWpGUsjGdUK2QrG10kupgQLPWEuokdUxQm8bNABt6HHmcYG7Yb1/TF2phMhuT26Q42ktXFgevb1H/6k6FLRM2Gks7LpgeOQVcXfA7LUnKQpvdWy8gPArpWjyC17UeIJVA4FuEqIMiCwQdEM9JL/GtgieuTI41pr4FzRHfDSkGVOovoFLhoI9gegdKzSADS/N9Ws1A/HERW4Fexa+HQsju05Oai3iZAP5LjBul3F+mBaHsEqUYesNdo6mhGa5v5Kdpc1LbENhQtmpbhymmcIbnRoY8CIHSszuP3D/MNoCjBQVPf83kxkCNFfS/lBhE/pEE3VTU7F5KTwU57zNPetOAB0E+xiphTK2y9S/62q+VhO2oP0vzTI+76RnvjkGnP2OeEvfyT3ThVB4Wd00gwdU5PYzr5v/D06WQ543fsBEfo3zvr26W/27ChtJlIZwKWJR+kNMnDsqyQKTOy9SKhZFy+pxlYLH230Cs5OTKL9fuCLq50pBTsx9VtVJfg2mS3JN0AEkPztVL3yGSyLdtOX3VQ7ZsOr/H7jsQk1EFH7n8vDhzScUI6eCqC7am4glmrAizliPL/EBcgmBm3RXCdjktKRR97TD+y42u/qFIWhzWTrZlflYMxs3AmWX0Kppf/bp9IR3uvXq1VfMCVkrYlokMRjG+HSRz9hIlvnF+kfHxYZfQbV/eXZfDEFiP0frVr+IBlXx
 HaZiKDr6
 HAl2sEMwodgL3o2mOuJAHXIV5A9xaaTfOkjDUignvoJ7L1crtRDF9kCxV4Xb2Ssj8t1rxI2trH2j3sHWdT0Hf0izLJISibePg77UjO4vMWy76bCc8g+0iJB4DuMWv5CErJ/ef5cM8/NEFqIKpn/tl91sfIQFza0Ob1PyMStIrX8XqG+irjoDo1zr85TzPvgMwWFaF78elEEhuIA31FFo96ZiMcMBK1SSBwjAxw4HyW2VjsBfveX4s6D77diuO0ocuaEHx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 10:21:18AM -0700, Andrew Morton wrote:
> On Mon,  6 Jul 2026 15:21:52 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > this series makes use of the swap_iocb for block as well so that it
> > doesn't do inefficient single-bio I/O, and then rebases the swap_ops from
> > Baoquan on top of the now very different method structure.
> > 
> > When running doing kernels builds, which is a workload that doesn't
> > really do much THP anonymous memory it still gets 2x clustering for
> > writeout and 1.2x for reading back swap in.  The overall times do
> > not actually change, though.
> 
> Thanks.
> 
> AI review might have found some pre-existing bugs in 
> drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> drivers/gpu/drm/ttm/ttm_backup.c
> 
> 	https://sashiko.dev/#/patchset/20260706132206.935272-1-hch@lst.de

I know, but it's not really relevant to this series, and the drm
folks keep ignoring it.  See also:

https://lore.kernel.org/all/20260609085534.GA12980@lst.de/

