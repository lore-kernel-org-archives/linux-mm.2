Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90617ECD994
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 17:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C8F6B0089; Thu,  5 Feb 2026 12:36:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A407F6B008A; Thu,  5 Feb 2026 12:36:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976B96B0092; Thu,  5 Feb 2026 12:36:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 868BC6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:36:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FE2516064C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:36:09 +0000 (UTC)
X-FDA: 84411106458.11.197763F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 65D7C80017
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:36:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ohjzoPaA;
	spf=pass (imf02.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770312967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yw3PrSiEzyr4U3dwUrPPxGu06OkrTvRCG8lG608PLH0=;
	b=A6iYt68dRiZ2ta0Z5u3210e9YlK4nj1n8EnyEFEcsz4/ALeUd+VwcxtITbOH9eCD8ljLWu
	FtMU5oVUsGGZ8e1HiFTxjpG5ZQhuvqOfYFeUp9GuVH1Ss8J9BBrT6KgX++IP7y9v5vbfYJ
	4RGS05I2KKH5eOEul4Sg3a0x4rCEx7k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ohjzoPaA;
	spf=pass (imf02.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770312967; a=rsa-sha256;
	cv=none;
	b=Nw3qeJgzcPW4jPKmok6YHnuoXxnjIInaorRX2QbTC+l7oB9OShZ5Ian9GxpKl/FKGP8tD9
	DGq+UXwWjDURfiuz73C7/htkaRJIqt0IEQB2EccnjBvVmHj4I6RsJlyA/cK5bEkKDdOPsE
	nHPDR6nV0XPmQzD4Sch2wu4zx94Jiss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C936B600AD;
	Thu,  5 Feb 2026 17:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE63C116D0;
	Thu,  5 Feb 2026 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770312966;
	bh=ZzYwZ9aeHMDagYomufrx0l2pFxITK8eMYatS6zmJveg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ohjzoPaAoHaZqWla6zDANFVs570eMbvYSS2IqUyPPBr0e3GNtN8+Ep2it7mqcj1Ni
	 k0im7ADRSHJ23txkpXSJBM3N2ENwS/aAs+iPk0eaFtYwv993i5ztRJwYY2/cmr2rTg
	 Prznp4J3JWGeRoR2fhR577n5qlQb/zy/J0CnXBxPutBpl0Ixoj0p+eUicQbfDXSuKC
	 6SgmCtxhVe0vdcrhv9YvHz/oLGKzrVEWx7YDapdAooWC/3idLg+84r7PN9zztmVM7w
	 092o1Tjt/BsUBJhJaoHrwN5/1Ev/39DLfPN2ao5Z0XLeSWmzYFcM4zmQhFNjp6+qfd
	 cV7UpK2DXvAZA==
Date: Thu, 5 Feb 2026 17:36:01 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aYTVAeMm5cFnuAL7@willie-the-truck>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aYC6_lSm_eJeKIcn@willie-the-truck>
 <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
 <aYG-dGzR6MuPSQBK@willie-the-truck>
 <a4ee7faa-5b0d-4ffa-bc06-939d95ef7680@huawei.com>
 <aYSp0--x_QgyiUWL@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYSp0--x_QgyiUWL@arm.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: mri45w74cebhc8emab9n7pmboxw9d3ik
X-Rspam-User: 
X-Rspamd-Queue-Id: 65D7C80017
X-HE-Tag: 1770312967-185741
X-HE-Meta: U2FsdGVkX1/KtkT2Ix817m30NNYl6mdDmVtAYvjfexRvC9npvoVmPNcB/8SrMgLm4qW3PwM6yqC1QnW33AT/DWw/JuSbneF7/ukQklwgmW6CxaQw76Jm0Px0uElYLU4PppgLUyExrLeDzgDuqfyk/+PNt+7tL+4PGjxjH7M+LDVyMtPc8g5w/y7L+6U1ahzQZoi5KXkshbFbYpnymNw8IAzDl+8G8WaslQJZge5yeoDSoTMPorhaxfrdo1RrXTyLGtyb5BSL7cS2UsCJvP6580LgpnaSyR0ErjwWNkeZzce/0q/mTETKdltkx4bN4KkidDQmfu4vWfgxE3SDxgYDUqGqieDA55GJvq2QmzfRFGUIiVjvRsfm7rIcU1/j4W1J/z5juTuUCA202zJXAj43J8WV1DhN7EjgZrrrE+gNNrdhYM2N8tMI7iZD0LuwForFZ7ylAydHH+85Lfe1Wh64DMHHKLo1TmydlXLwEDzIcoDZPJ8mtD/+nMnEHhNfd+LiuSSVvwxE6SgZm67FbCmS1w5v9PizE6CG5lIMS/efg5rUu2nZQoIJsjMPNFQJ+rmQIGgPYvFEiSpUWDNbAOBwfW76sdBAMZI46gDLRtQ6GOnZEyXmvSr5xwjuR2Uri2bZZRpa084YzsJZ+vx8SgTniFRdaItmhhL5QVe4tq810IjxeKn6KRfX2uRZkXgNAzK3Ls2fHc0nCdyOUU69U+uoEw9RXkusOdpBhwfO2PSqnc+W90i+7vuWwH53yNN26Wi00BPunBlcBkkakUf3j7hPDCdzBQS9C/VSNpb1JerEAskQUNWFTr6woKC+2R/KCxUQVXDF8RupI0kUQg8VUWtRDRYMgTsk81luLbfu4IfA22Iu/y0gWZXWWOmHNKQc/jPWK/9uepqBDjybH9851dDqI69yACyrXZdYFeppO2u1h3cW/1UxvJxCenGpWwoDvqxYUGCt/c6zXjbTE7TkAEt
 mBNSiqku
 DNOIVEjrfBufQW32moA/JYvrEQ5mjxbe0xbaTNNohW6DFclcTyraE4mUrrW9Jy/OLR7oWjOdv5Yaxl3+cWL1YasDl8PMIydSvleAmt6rHh1UkbFjk8lzV/BXnh8KEwIvRQQRuE68gzELdedihuw1m/WWEOhGGYfW3RkUQOJRcJhUVHYNmpai8WMbCyHgD2w8+AWREDSKtQCEKKFc49Jub/BgiMhkLDw4EZQ2sUimuGC7gt1apqtLseC9/fXShmejug8z5+btyg8/8vChM659AXYkAixoZHNUfuUw6zMrzeAxVYR0DnnrWLef56XjMqSekwXIH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 02:31:47PM +0000, Catalin Marinas wrote:
> On Thu, Feb 05, 2026 at 03:23:27PM +0800, Jinjiang Tu wrote:
> > 在 2026/2/3 17:23, Will Deacon 写道:
> > > On Tue, Feb 03, 2026 at 11:38:15AM +0800, Jinjiang Tu wrote:
> > > > 在 2026/2/2 22:55, Will Deacon 写道:
> > > > > On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
> > > > > > +#define arch_mk_kernel_prot arch_mk_kernel_prot
> > > > > > +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> > > > > > +{
> > > > > > +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
> > > > > > +
> > > > > > +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
> > > > > > +}
> > > > > 
> > > > > Do we really need another arch helper here?
> [...]
> > > My point is that we already have the helper: ioremap_prot(). Just fix
> > > that for arm64 and cc the other arch maintainers if you're not sure how
> > > to fix it for them. What we don't need to do is add an additional helper.
> > 
> > ioremap_prot() may be called outside of arch/arm64 in the future, and I think
> > most of the cases will not pass a user prot to ioremap_prot().
> > 
> > generic_access_phys() is a special case, so I want to limit the modification to
> > generic_access_phys() only.
> 
> Or we can just have an ioremap_user_prot() (or some more meaningful
> name), defined by default as ioremap_prot(). It's still introducing a
> new macro though, unless we go and rename it on all architectures.

ioremap_prot() has exactly one caller outside of arch code and that is
generic_access_phys(). We should just fix the arm64 implementation of
ioremap_prot() and not introduce any new macros. If a new caller comes
along later, we can figure out what to do then. We could shout if the
prot isn't a user prot so we detect the problem.

Will

