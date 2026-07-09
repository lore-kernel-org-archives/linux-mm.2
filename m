Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46AEC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641A76B0096; Thu,  9 Jul 2026 02:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F16E6B0098; Thu,  9 Jul 2026 02:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA206B0099; Thu,  9 Jul 2026 02:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9206B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:22:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A03CC1F8D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:22:10 +0000 (UTC)
X-FDA: 84968243220.09.3429CB1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06D3B100004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:22:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UN7d6eko;
	spf=none (imf05.hostedemail.com: domain of BATV+3c9ebaaf6e714a689196+8355+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3c9ebaaf6e714a689196+8355+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gF6J3GIPzB252v3fk/nA4luYZs9h9zFcInqUmdwDTgM=;
	b=MA1R+WUGMSy5SGh1I5h0j4+q7Jbk7KzP5ixG74XKfrIEV+dPSYCFdyYvfB2t+NKOVhoZn6
	zUl5hc1A3KBn1C7QCrul9RmFEFvmX66c0Kt2mB+fVehefh1hg/a+nEG7dknHMV0zIUI/+I
	IcPzi10twDBqmu4FxwYfGcXGpT7Vg6I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578128;
	b=U3Z36uJE0BshP4KnVfhltlmrdHJ+rgrhYRuBAwh3SEJT7OoPaSQ9MZYgDiIFAtTqdeZlcN
	3A2bGAZy4nnbuMPUBGsuXhWFnDvH4VzY9TZV4IUSNLeqZfhAcuIBF21hhkX8H+8RCnKxhu
	O2XIiIHr18KpVjDQbJT1PCE9I8Z5ynE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UN7d6eko;
	spf=none (imf05.hostedemail.com: domain of BATV+3c9ebaaf6e714a689196+8355+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3c9ebaaf6e714a689196+8355+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gF6J3GIPzB252v3fk/nA4luYZs9h9zFcInqUmdwDTgM=; b=UN7d6ekoveglcriPTF826Jme+X
	g4JvFxZB7+4fw3Gop5HMmI7YU3DZKH7Ston2ie0y5t53LPIkN1ui2qqT2ZJMoNMkgslveG7a+mI6C
	K+RaR5qVmnS91IaTnWbBLjLAPinHcWCPeiimcIqM9tdU344l3rsALhgAD1qYoFSvmsHGVtHf3ilo0
	autVEdHMv0GM1+KCJwtvBx/8qEG6pRtZTw8IbT4gMNv6wU3ID6EljEvTP3wVEawo+CTvdjWZ12XJG
	oF0KyloGsu+Y8v0bzI6DpI0LoFm2AMq/Sf+tO3djsXwJSM1Xu8lnbXOBuYbYevROtuIe95/x4Gd9M
	p7nfV2uA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whi97-000000018qZ-29YS;
	Thu, 09 Jul 2026 06:22:05 +0000
Date: Wed, 8 Jul 2026 23:22:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <ak8-DbIaHk8awOaf@infradead.org>
References: <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
 <aj4iiD5C_yyLeb3U@infradead.org>
 <akevQfFVteCOD6LM@google.com>
 <akfAgy52s_Gch2KG@infradead.org>
 <akzsO_vmYX_7Umjd@google.com>
 <ak4A6IEmWNi27I2d@infradead.org>
 <ak44z-X-SKKhkBkg@google.com>
 <ak89YF6BS-iYf_e_@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak89YF6BS-iYf_e_@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06D3B100004
X-Stat-Signature: fetqd9d3iahr7whk78mz9yccjc7zbhkp
X-HE-Tag: 1783578127-518396
X-HE-Meta: U2FsdGVkX1+8zd6/p/Ca3LviPHPKKA8fB5T71lD9P95w1Eb7c9eZxIWqJ+7fywq/syWrrPoGR1MpVqgJOTkOIotBcxX4No64xWHWQ65syfpyHCzMfM64ae1qXsOQbnu91zWB+TnV5ePK1jcCoC+97XaXBVebc6pIaWFKL29MRPqJU6oJM9gzpzFzRgkIKgp+pv2xaksFWjIuLRGIje8UfE3M0GtABmzXWbeoiNMMNHXPyPmScobxyoxlAXnR7ghb4WBxgQrTCkOgJqC4OkYu1w9scF45R6Ewnhg/FD2aR6UC7q9Ck8Q3OdefvjLdFncmUBCZ2B0dTZJJNe1gytpvQonz/NzC8cLvEmT6XK94kJYVRbsWHQV2cVCoTuKNFOYcH53E37jzFOuQFF/VKifIf3rDCbnwun1OO+XyH306VQ1OYsc+yyfVBsKhf4fbbgrznYe/6gtamtyMjHlzLN+EuOrSEWYOjqYBpjGhlLS+Id7xhym2wzt9TCz/+gIE8/+G80kbIA7V7Dg+SLg/yXtlevOJXaaQ2oKzzYyX67RSE1twhhh4hzSotbJ1Qp+E4yXhkXBez37ntrSx2/r6Ww4FdfdXwkurDmPgobTF/7rXTiN1GxT7aFp8RK360aYPQESt50WkD5imG1st2BqOf3xBjCaH4H1FPZG3gRoexjc5/pUf+W8GWT6gzkPOdWxq71C0vDqvGkGtuADLzu8HOR16nXG/4G0sfU0YVZnolwaQ6zIHIPv0gwDJugqBXWyuRlTKQAgRP1mPkt/YyWqN0RD9yjrbaJhgLYp9QJa2cupwwQd2L+490Y4xoRu27/E7jTLRqiHE5/qiaz+HP9LbNS/eIwHL0m2g8MHe3EvyzgFPZYcae0d+vwbqzpEs/6BuucWWjA+pEBjsrLmRstzvEflzcOW/+zs1KbGp/goQoOtE+DgToYfbKUm6jvBy66UFPUxfNyRiZfpVJTK/J91NxkX
 j6D8f2UB
 vdIpS3Y7hlNGJZprJX9fvlAeS0HfqXm3CJMgqaMrAZVC+EqBIY3jP1ObS42OTDFvb2J2pyQ5Bgs2zVFlS7Zbh6nn/dy97o4YDNkQDJB58FgIv1KJ6BxfjdxRjRF8CXOYh+Wh+Qd0dimiqW5nW5BM6oOoCaRz0ZIgJgSzmrbG3ZlTsT94+Xi/03kDIFQRCjwLUhqPXbAYcjBYCIUEyz0XD5kSNKD6g9rC8plRJaNfheZXyEiRS9OM9FJeMJc+Qy8BvaLIuSNDZTu7lrJTgpteuwdGeKG3/1UOD3nCVLOYW2WPdHqNEGROpe+hpKtRsvCc1PwD02DDHvVFaHSO/eagw0S6HoGRFG3gP1oORjQ2UlM4GMXKnnhUypwaUOEoOsIIiImnZawLtnNcNbezwlLkVQeYnJ1zUGnvMEBI0CnHYPPXPNhUr0bNDjJdtARuxgv0PVKKUconAJAnwTNGsH2O6FfyjW00HKmvO4tdGuypNm47zQURsuQ56er2xKdWmFdOD2PIKLGGeV++axc02/1dLcg2NgujxGj3ZMFOq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 06:19:12AM +0000, Pranjal Shrivastava wrote:
> On Wed, Jul 08, 2026 at 11:47:27AM +0000, Pranjal Shrivastava wrote:
> > On Wed, Jul 08, 2026 at 12:48:56AM -0700, Christoph Hellwig wrote:
> > > On Tue, Jul 07, 2026 at 12:08:27PM +0000, Pranjal Shrivastava wrote:
> > > > Ack. I see! Thanks!
> > > > 
> > > > Regarding the page_folio impasse, how do you suggest we proceed? Should
> > > > I expose and use get_contig_folio_len() from bvec? Or should I move the
> > > > NFS helper into the iov_iter lib? (or both).
> > > 
> > > Sounds like the best way forward for now.
> > 
> > Ack. I'll reuse get_contig_folio len and move the nfs extractor to
> > iov_iter for v3.
> > 
> 
> On a second thought, I guess I'd try taking a stab at writing
> iov_iter_extract_folios and handle the vmalloc / slab cases for kvecs. 
> I believe that would be the right way to go, unless I'm missing
> something obvious? Can I take a stab at it in the next version?

That does sound good, but it might get you into some longer discussions.


