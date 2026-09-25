Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B1AC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788066B0088; Fri, 25 Sep 2026 04:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738776B008A; Fri, 25 Sep 2026 04:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E476B008C; Fri, 25 Sep 2026 04:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 423EA6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:35:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1469A05C8
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:35:17 +0000 (UTC)
X-FDA: 85251625074.19.9CDD74F
Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id B7BB9180002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:35:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PUNfiiLV;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790325316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDv1NBOvOnF/Xs/Hh4+9hUPNuwqbSlqCA0YkWfs93sE=;
	b=jFOrgnwBchpjG5KsW9V+d70bGpyrxkoAUxCfVQsIywxb5stAac1X8cZD+uo75JnRA8bGsk
	lFZRKpKQk5kZCDg2cU9kIIUgjHxrxMfCR4jDWFTXCBYJmUEjUQ9rjUMfx8mOnshCQ3Wern
	7X1RiSrEmCK/dk+k4yRp7uIEQC04uM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790325316;
	b=jRz4K+bqnKsHRlnm3GGW3OV0l0w7woaC/KbqTQVoSgdP0g5l/s0tj46hj+nKBHuaJ/AEyT
	xQLZEvd3u/FahvAyhaoqr1O/gPPNf/Mnpoj/rE1FbG08Ww30cBxsdKBdbVRc9RAkYm6pmn
	lNYyZmogvqQfcPxajaVq9ZBDL4GDWxY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PUNfiiLV;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=P070X2Db5gT0xjAhrfG0+0oxaFmkGwv1YHZV5sftYO0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790325314; v=1; x=1790930114;
 b=PUNfiiLVQ17SaBkQ4YQp25HefyN+ThfNVm1Ldl1euY2i1pLWBK2bLHN+6cMF8wOOrhOXwPWD
 ZPoXoqK0ck54f3cyaRDBR6Tq+k4VsAy+bNVqFWACJf6L7psCNQH4y3g6/ZBAvAfx2/rihTrmwy7
 7WTlE8pYEXl9h1edMyg2v/3A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5a9ca629ca05bdbf;
	Fri, 25 Sep 2026 08:35:11 +0000
X-Mizu-Trace-ID: 5a9ca629ca05bdbf
X-Migadu-Flow: FLOW_OUT
Date: Fri, 25 Sep 2026 16:35:06 +0800
From: Hao Li <hao.li@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slab: Remove slab_folio()
Message-ID: <arYx_PN8cY0pmI0w@fedora>
References: <20260923183655.3364885-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923183655.3364885-1-willy@infradead.org>
X-Rspam-User: 
X-Stat-Signature: mk43fp77dsgg1g6cqg1q8d53hjsrakzi
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B7BB9180002
X-HE-Tag: 1790325315-626820
X-HE-Meta: U2FsdGVkX19xt65T3hOO7bze6Wjct9WJuYql+1Y2HJ+qYRAi/nkqgvtMCDLyGftmh77UFg0bhxpElnHMY4qwzoh9BDhed8ugWGx9REa674R9WrQSw4IjgjyACtkN4uU/y2E3dDcpuNFcVZbfh8Rx3OMClCqAKKt+g/C7rQfXSZKdo2EvBysSgByO2VcWUvW1DcpofDNGufEQgorJJ9oux+PRF8qWp29jupxy/K3X69K65wJ/uvrs+mXzQ6j/4Kt6e7hlPMxekbGLri2rqFHZNlr9mBNWpDB3Tz4Wk/SYVBvg7NWxXZW45+QO1CZ3CArWZU8GkNVT6g3TbbiYbFEhQxj9D+PScIc9+Q/hJRzjHVHa1Rivn0u9yH7dI7g0PYxO/FPTz2jvv+R2zSdhGwWIVVikfI9SFZXRiC6G7/yXzGTWqy/ZJ/QDy3vy/kyV0B+Fy2J8hw35chBGCYB9kLKRdF5A6Z6y3KHBriw0VXl57TeiFm2OmwugV3LzT+Nn3Cru+vh24L+vq+2LHra3NW/pq3MV1t/cex6povsi9yD0JIyiNmz5QUhJrYzwIjr7ILpdnUSp9xNbXAlcc6T3gtH7x4mS3gQI79yMA7CpfCEydF6ARSOibdJR6C8lEddpwrKj5fRxmaY2vOvZB93HHf1LUxHwC0Cs2SOYnrpVkdDE2b8SM+owsxrPWZqddGqOtl75Co4UsHfBz2i2ZFT2uRRBv7/tXD4yQo4bGSgtSi9nxTPuU2I4go2xxBNmiterfJDUtgp8bWu3KnIhwgLsgHpE44b8G4WlI5uoGCVFitPfAjTaFbTsZTPM51NGrB0sVJEFl1K9lPuTg/3SREQGhBlO5u7Nw/l0Cd9h7SzlJQKBBxx+/0hLwUjFb9VG6wFvWJ0Kvard2pSLz5i4Uxx6bmv6qy1vwmppx3xavVOP1P/O9vN/KoV91xHGWBes6y0eZlhrUzDASG4eoaHrZmmJjYg
 S/mv6wCJ
 z024wAhCZfWFSZIfbp4gKLA3hLsmbT0LG0HveNHleu7FEDQMs7X5G2ZIi+cnno+rbFcPkzgTSF9zw1kefHdRwTsSpsdanb7soyhHCC8IT/nrn7odx8LfZYXv1hgIEG6lWciaLgeoQnJ5DP3nQ53oOg+N672UO+g91Je6Hh3/Hf5AIXwmE0F0lycozaFzoZEO1i4HRjfbRSaf23zTbdXMdkFTl34lSHA4Q3dZybg4B1bpUShaK3PwHSwQAOFZ28edZKzFgTyvoqiSl1iw+yVhWUvcHuCu+zntYsXXm6c+2h77qfjE6aWXddOBw+0mi+wjpF4JZEdwtDkXVreBu4yyYEenxlx3TSBPUJA7so1ANGZhKR6KgS/mHEjmeuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 07:36:51PM +0100, Matthew Wilcox (Oracle) wrote:
> This is the final step of divorcing struct slab from struct folio.
> It's still tied to struct page, but there are no more mentions of folios
> in the slab code.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/slab.h | 28 +++++++---------------------
>  1 file changed, 7 insertions(+), 21 deletions(-)

Reviewed-by: Hao Li <hao.li@linux.dev>

