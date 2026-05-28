Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DCABCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D486B0092; Thu, 28 May 2026 04:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34DC26B0096; Thu, 28 May 2026 04:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269ED6B0092; Thu, 28 May 2026 04:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1711C6B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:53:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6FFE4079E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:53:32 +0000 (UTC)
X-FDA: 84816215064.13.66B3BCC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2183B100008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:53:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=WMt+kwP4;
	spf=none (imf05.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779958410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nu+2uJB0bWOahJZM395trqlBX9jrloGHIPyChDFiT4g=;
	b=g0rrg75v7DWuZEgdSBl1NhT3FT8GWagShw9vUi63M0oeITA3naukJSD7W/5+16tdMULB0I
	5oJ66T0GmoXn5Tj6xMUXWwwKnzdHbKglEQxgeIx8CXlN3/1Ob++cBJbMZZ13MKxhnoOGnu
	yqzHOQcuA0MI2z6URH5izVduY68YL1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779958410; a=rsa-sha256;
	cv=none;
	b=7WPQh+WoiHjlyqLWpqNwOdZ18o2k4pBG3ki8vWxPXQ2M0mlZkxh0SsZZ4NJiWwiUdVQUGF
	6ltbfU97+0OR8eLdhURdmn0KZ5Ge9LbkN+LtxyVLiC0TjK4E7N4l/MGekD7wQBOWldRFxO
	ICAfj526Bu/eh6giMVI3CRtneY9TDDs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=WMt+kwP4;
	spf=none (imf05.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Nu+2uJB0bWOahJZM395trqlBX9jrloGHIPyChDFiT4g=; b=WMt+kwP4HyNu4MxGTFi9A9bWL8
	I2vaJGQoRhwDX6g/0qB7yDnua1YQSzPQrViv3x1dOgw/6NIGCo7mJd5eVL0Z+kChl+oL7hNbxm4+q
	QKA+dCZ9jIJ9xP5nt5FvZkhvJH9HWs3Jr+bDnkv0cHQbPzHvs2nDIJK0lueoPxhJip9HsUmtceZJc
	O8Dew8VdViDsT/VjNjWBFVK5IcdIaj7eQwmihQsAd9IU9B4aWaMTdW+Tj7fcuXOZvbyUoWCz7H7rN
	zDBZczW/tM2JZZ4bpnCzeYHzJ21k5778f+4lirKrTNNFKjGkU+vtA+FH4ZWN1nwTpkVLBQply4LiT
	YlfcTbfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSWUQ-00000005RNi-04pb;
	Thu, 28 May 2026 08:53:18 +0000
Date: Thu, 28 May 2026 01:53:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@infradead.org>,
	"T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, mripard@kernel.org,
	sumit.semwal@linaro.org, lkp@intel.com,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
Message-ID: <ahgCfazNTdk7Em-K@infradead.org>
References: <20260522225853.878411-1-tjmercier@google.com>
 <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca>
 <20260527181549.GBahc01Xflm2yo5OqI@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527181549.GBahc01Xflm2yo5OqI@fat_crate.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Stat-Signature: gzs9iwo3xopgmzoks19woge17m87d8gk
X-Rspamd-Queue-Id: 2183B100008
X-Rspam-User: 
X-HE-Tag: 1779958410-848882
X-HE-Meta: U2FsdGVkX18Za8EEpktCxsS/LhEkbGiM2WT8ZSP/5nVUzUX55mRahUjeCMmEymYYi6/Z/PNtKCF3QOSt4Z369po+y9QDnefbAWNn2hzmgJfEr/CqhPKTzKz+Tgb3+puVtArtNJSscZfmpgHup5uefESKyJ9iOzqHBTbATYS720QsuBZ1+qfIdGdSVBGQVX86PK7A57bibMuxSiMZ62F3ztOx3THRQ54aZHFCWr/Tl05fHEnp9G1daw6YppK2Uro7Yq5VgkgEGx+x6LjqnOLodq6oZAzpyxNj2BX9mLcLGWAM8ahW5YixN8NiUQnrbsM/6k9KRcQd+yh0eP/S0LwfBFrwcLLBf0bJre1SP/PEBtFRTXTdg8hGmg5MXbxymJ+u0aga6NtGKzOqlXJOTC+nhK0w6N61aXrkZ/ni5GSIxnlG4yQbnbW2nlXTslZG65e6TYPhC5zG6oOYnRFRP5tw9/HQqzYlIygdI6h9jEK5Awq692rsdjVzqBvMmd8MVAsWsgG6f2WDUmcvO8jHoIC1eRSnKPcw6HXsx5SxrHjYizG/LW9LWQL3FakLpt7Zx/5HdxKMcLmgC4SregjD7P1A7tfvKL8u1OyRfrzPvA1DeIM20JRXzjp17IXdUQo2zjD7x22c4krGtHRJaFxlfQJF5XvUHVU7AKwas3wbTKcbtiTaSAtQMeD+ulc0rIaXukkkQNETvlJrilufiTKHAfSlhDN02xOUS3NSkjiXs83SJUHxUuNwMIvm9B2mNuT9Uqse88H6iwYaFYuUE0+UmApCu0bYGHaQQkYX4/60xZ2tqJs1Txe0BtPmyr02Ks/23R9FoMWvqRXxMwTKnieILq/bqVSw5fgItaEuBNqm59HsoFBmDR3zHNf4YV/stiK1v/sZWB28aRp5Vz5jozg9SgjXVlkUDuY/atCqo5h0DW3vRINYpLhy3TYCyxpmXtj7pD8or8qNR7TnCaff68eSVOW
 3tget1P8
 ZKubilIgErpFd/tDO7Z5D0L7texizH57pCqAPX2dumblS9f2GA2aQkJlU+4QYl0o2Yungt3eQn5Dz3ApomSU+C98BDAFYwA7SSlHqHCgn2vwOavZWTtou6nk2mTfdVDvKnm4Igf5ow7P/wNPcVKVau3ihDO8a9kGH/woZU9VQXF0oJl8kKnACDTnrI4ZMSpYnLF/1TXDN+g7WWuDjlPzCEpEJ4UruJ/Tb0cn2+7gN1H1E1uarMQhlbd93ESzG0d/zqTkES7YTcg0h8CnY+uZdM6DsYftywMayVoVdSmwnAx0K5Ts3XmtKZpmEJ6F8yYl+PODl0hQ8jFnamBFpbByu8HwD3ErPJJGuQpPDZqhIkH2oOaLJPGqwB6T06+7/9li9+u+byjwg+xo3CXGcLyFRDOSx8WC4LnHki2zb9yK2IjN/6tOXpDdSkuLsLnMWpmyKRzyvlTCd5+e+lnROJ7oYWye6o+bQwc3yz431PoK/M6Uv3wQoDSr+01Qhl+2G5xa2jgx2ut06FHx4Bg9OAOM8oAriEUvgp5WpAaFEDFmwHHwv/PE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 11:15:49AM -0700, Borislav Petkov wrote:
> On Wed, May 27, 2026 at 01:07:16PM -0300, Jason Gunthorpe wrote:
> > > Setting memory decrypted is a dangerous operations and should only
> > > be available to core code.  We should have various allocators for
> > > decrypted code, but not export the functionality to random code.
> > 
> > At the very least an EXPORT_SYMBOL_NS.
> > 
> > Looks like there are about 3 modules using it already..
> 
> Looks like more to me...
> 
> In any case, we exported them back then for some framebuffer things:
> 
> 95cf9264d5f3 ("x86, drm, fbdev: Do not specify encrypted memory for video mappings")

Which is exactly one of these things that should not happen - mapping
random I/O memory without the proper helpers..


