Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF14CCD18F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335888E00A1; Mon, 13 Oct 2025 17:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6AE8E00A2; Mon, 13 Oct 2025 17:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AEA98E00A1; Mon, 13 Oct 2025 17:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E60BB8E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1ECA1A05F0
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:40 +0000 (UTC)
X-FDA: 83994450960.13.6A978BD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9CB694000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KTGXnn5K
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhCn2KSyb7tmfiec5a5x+4NLc4rqOdPBeGr9lcN4QSI=;
	b=Rq00Sc1zx5YBTP8EW4WWompJ4X4UXUWrK5gqZVDsHl4yMmXb537FNmbTLzyNVrQhptRfVo
	HS06EWKOIAcH+3xJSpstrrksqdwMHjjZs+xM4+t8YGRmYWZ0FzC3DmB2I5MsYrlwi5P3mF
	pioAp7ljTACpWTYnBdmEn4Gq9/Q7Zcs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KTGXnn5K;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392599; a=rsa-sha256;
	cv=none;
	b=vDV/7CDUy+cK9bkE3IsMvVGw2Awb6Wzh5ylUmo7YQke126hWFTZ+pvH5ajmoTQa2PRpEHb
	47YAB646d+Btx8c6BylpPjPN5qbtn2eiRVRqsYCOuSW0EUKUIjJtoP4qTlOBwjhbjiOETq
	9z2VtBXdLYvlfkVqUGLPpShHk7TyhbA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KhCn2KSyb7tmfiec5a5x+4NLc4rqOdPBeGr9lcN4QSI=; b=KTGXnn5Kkh8GuuVZ+yDqB/nMp7
	9qZbgtKKrXNedzKoDYnX3tzZhb9uDwdn2hMcprdjumK9Z7xg+vsBopb8QwAE77Ef9qWG1KrcoXtPW
	aUeK5DzGTpXGXz3SK6b2RMWtU76iQpbXrOFtDgTeXt2eLbt2bcVyg+qWrO670+aymw9gY9dbxP621
	feLZAf8tsnqlFpxBWRjO1BcZsP1VQtFs4DdvnweBQnZ3koCzLa1eFms2i0JtsMshkbVDRQq7bcIEP
	CaAiPgNmXtRwt0hLxXjKE4A2ePhFjxgjvsmEbyBLF7eCUVT9Zm7CDlOYOEWi0Ou9C0Jf3JiE6SBeJ
	l4IMOG2g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8QWs-0000000EcRu-2ayi;
	Mon, 13 Oct 2025 21:56:30 +0000
Date: Mon, 13 Oct 2025 22:56:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: netdev@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Huacai Zhou <zhouhuacai@oppo.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <aO11jqD6jgNs5h8K@casper.infradead.org>
References: <20251013101636.69220-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013101636.69220-1-21cnbao@gmail.com>
X-Stat-Signature: j6yog1faye6f3ahz76zqfbsdhssmw7mt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9CB694000D
X-HE-Tag: 1760392598-160147
X-HE-Meta: U2FsdGVkX18ztRQwoq/1uDqENV/zqlWh2LfBA98VD+jT0I8GmBI7b7lj/AnoBQvtgSA0HdY9z1sFFnJb+WyOfqccaS5enmwza8wNujwVREdOM1oAvady9q76UcTA7Q/Zhwjp8hjDQmiEZ8wAGXSwtdneSb8WgVAn+H/GY718f7gpCFriieAwJzjyc4w2SJ61YOLc9ak6hYGJQyQSPCcbL76L4gtVPVhfVVMc1+JfaiNebzf0Haj8iKJll+u+irkJhSSg9Eatcm95NEzZkumpGlsNMl3+5TwY8ixo3r3n7F2EssEsmFvYxq/l3kA/S2w7xEi5pH2xCHs/8YzUsDM6bwkeQnd6u7AOm9cr8VE1oKou7Dh18MX+WYZDIMr0e5/jsLD66UOUg6VqKKPKih+lsQZB0YX5yqrxp+AyVyIAZu0F/u2noegG42eeY7zMvlKW2mjXy3joyv6arLRnMnrbMB2tNaHWwR4f3SGc9ILdJp6OAvEFoqJKVFQvor378aUly39ppF91fcL1wViXvqZW6S8Je/C8BTKRXIeJX3Yq29BxywBIhoRdU5Xa5R6Dje262nV2NocGprl05w5DrNJUacH/A5JxSJ8VDp/Ablj95ZRNZ2rJnyxFI4mQec/KJv9pVsZkZMdIOUYTkjzxjEVRvXEQNldlfULo98hUiTS68b2Lp1yHN8y5qje2DXI0vRAp6F/0Pe4nmzRimysG8fZ7XSRTahYCnEJ1M/2CPwZYaULeEntrg2i8JA4R0sb3u+KUxDmPzFeizuHiLTtjflCrr+F/ub0p/PXfH4PkJMVmuQ20rhc40HeelcsebbDzVIq+K4ccZ1iHCR1lH4Iex97L31y4F9R7VDUFawc4k4wvS4Wn4lJ+SX+ur7aOPZpq8ebiGz3lpLgdUnTTXh8LxIa2iVVEl0DnB1IwnDMhBPDmqGvHSGPaxfG0ze5EAs3Lpw2qDCq32X4O6vIxkkBdLug
 eJyDL5D1
 mY/WUnWgC1jQhQXTrnn+hboMA30toxoqwkW8aWIhq5aBUAIewuMca60R0Sf0QqTc5HY7PySOsKmneoVCDdX+6WlOH0LIlDym1KBl5khFemrLcUQfuU0zAUmhbbIv+PgWV6vqQc+qlWHaoGuvwFgIilsaMByLGuV6hgivENCTu/Db8ewTPcOKHvTB/iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 06:16:36PM +0800, Barry Song wrote:
> On phones, we have observed significant phone heating when running apps
> with high network bandwidth. This is caused by the network stack frequently
> waking kswapd for order-3 allocations. As a result, memory reclamation becomes
> constantly active, even though plenty of memory is still available for network
> allocations which can fall back to order-0.

I think we need to understand what's going on here a whole lot more than
this!

So, we try to do an order-3 allocation.  kswapd runs and ... succeeds in
creating order-3 pages?  Or fails to?

If it fails, that's something we need to sort out.

If it succeeds, now we have several order-3 pages, great.  But where do
they all go that we need to run kswapd again?

