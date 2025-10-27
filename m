Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3290BCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 07:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0588C8001C; Mon, 27 Oct 2025 03:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A448000A; Mon, 27 Oct 2025 03:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89178001C; Mon, 27 Oct 2025 03:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D48238000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:19:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83FEF12A616
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:19:54 +0000 (UTC)
X-FDA: 84043044708.03.D10DD1A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA04840004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:19:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nsoHJ+bM;
	spf=none (imf11.hostedemail.com: domain of BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761549593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8isuxF9+HzRUnIUyZzMqC3A83K198wXQsRPVcNAqodI=;
	b=xMl3AM19jT7J4B+jB66sLqc2FLKLTCMVKKWIclPrwZSwcq48oK00iXjyJGNQbN+ju4CTWb
	B3NUItKRKwv8IqYtQJddSPkHdp4GvmKdQjOjQI/0K9P2rBw/Fr91kj4LtYeK7CphUQbjjb
	7k2+z0XuovTNO5dqWB86bCi7nzJj7JA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nsoHJ+bM;
	spf=none (imf11.hostedemail.com: domain of BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761549593; a=rsa-sha256;
	cv=none;
	b=cXmppMt5oAIoZjaQt8TEAxrUcn8iOgVIox5ZeeXspfGawOaNrBQbUxwLVJxvmMnKm41lQQ
	HFveDZFG4U6zBePHTDWg7ziI9b5YNujiJhuwg3+11XVV6BAdPdstHQ8+kbAq22UeXuXerS
	ODYrtUPwYINyYZ6Ed/vepvIrszrtf+o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8isuxF9+HzRUnIUyZzMqC3A83K198wXQsRPVcNAqodI=; b=nsoHJ+bMFDWRK1YdVtaeNJLZlg
	lMQj6nDziNAYiIIJjXjAWxv0KOKwn9qrbaddNSZG1Me15w/QvFOt6EwSR6SV52SR4vCLRfIuHgBkp
	njxEA5htbhv3qQviL2/KGKqHHYIvMOESrkfHMFZoZys05vQqhIoo2RnZdrZyHMpYc/PrSDIvE7LUK
	RkAGFAWSL4OxQbZr2PzZQK6Ym+PbNjyoE+aMtKuK9eRqPJoCVHA6e6NTzp3DgA/H4QsS/ujl+C65A
	l3SOUoFbtjk/aL9jZgGIgeqeBAsG7q/AcuHqhLYODV1C2PeISGtyGxejeZr7/COVMnSAy33Rwwz3F
	91qQSEwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHWB-0000000DGf5-0Gt8;
	Mon, 27 Oct 2025 07:19:51 +0000
Date: Mon, 27 Oct 2025 00:19:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: manually uninline __memcg_memory_event
Message-ID: <aP8dF8y5uB7qwIUd@infradead.org>
References: <20251021234425.1885471-1-shakeel.butt@linux.dev>
 <aPorFhxQc7K5iLZc@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPorFhxQc7K5iLZc@tiehlicka>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: EA04840004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 45cgoqjya6au6xf6ajns54wy8io3461z
X-HE-Tag: 1761549592-556913
X-HE-Meta: U2FsdGVkX18Xe9s39HZOgG75UMtei2RnChvt1/QMGMjlOKzCkbiVCTJ0LwKINJTSGXPRtORUmxPprI1NNdaEs7dBKR+ohDrNrGmZPv7pRvFuRky8V0oMkADQm/Msmw1ao0395hDmaqc/SKeMC10atQem+utcMdtGZeUW7zhqK0zANeDYTSLCz9Tg0D6F6fs/9b7hc7U9NANAQAIDRQzPRaEgWtlE7GyzLvUef7GnFfulWrOzYVAEG7n1yYmAPYAGES44gROtmidYphty3D5Gndy9dpDTLeX7Z5jyZ0AV09ukiPzLy2vy3Rvr35yvJpmvGfWEQRS0PTTn0uNbHoPFX5obc6qvg/qR9O/08m6qiuHPBKqoMt6oG7gfdtrIwVvRefS87SaG713CBCqEj6monTK+aRrBgrDbXgxVPIo/hQFL16JXmeugwjvBVrSkRAD06VsDpPTa8Df8mPlJXrNrJMkWivsJtkTLf6EQZS9McfM+m4hpb5PyTqZ/wwx20Etuf5wPsIdBr/RZtjB15dSTMKKEo8YEU03z4cL43F8KSrUTqBhaqsDhdICrUCPHhpB08lZa96R2bDxZbCaNoVB6ooJOPMKZxDdYwaJauYaU/6JZTi5O6iM75kH37GOhWzTogdlAH2okhZn2yxTBdhS2GTLSrJZF41aj64vntNPinwRmYV4NBn/LzkCloNPEZmCSXujwUNXIZx8O8ZAzZXn3l2Yy7qdsbK4RnKh9vcbTWKOzXf8O/ttxBhSFIWlEREGCXhuJ+l6xEz5/U3bzWQwzpq7Ak2or0IC6N+aGisAvHx+q6Qn+fayP1K0os77ep5I2w3XY/r/NVCgJd5TwDOF1614pDaqWwq0s8mubL1Non/6AaPdLfPFkaR4e5X83kqXkvx/RN0bxuKaNSRaFIZ7xYw3NLpmR6ojfD7Gz2vv3ZWjRCz5/MEpiGgpMeEuz960w6bt5Zb4X6eBpxNeC//u
 T50NbzQ/
 UkRhpBdujikdkvnk3wP8+/ajbXzjaDnp/2wYMEkHrXlrGa7H8oJ6zB4vpZqns2Ks7vua5xYHerQeVJQh6nlWNiyjQ3LMwVAJjHwr+B1jN8YgeNrzTLCCebhwXnztlXOP0X1kGiCMfxhixguq+MakcCKh66kivzgJjAlfBunZ4EXcucLXa0ABBEF4opTTxt/jnwYFk8FT4b72PUm29SNJsoEXqS7RRBMsC3JITCXLiEbBe7tF/c32yuLoiNb3wnvAwimbr2OSuUYJHqytNNL03hCimzr89yZZpFlplE5bwPl8b5lIhF2dbl6vpAE9FTpX7CsoU2iRneU3aqX8quTLBRsy+YT/rhzuh1QUD/SNbhylSl+mM85boImR5JDj1DGcmi4TLb484pO+pA9ynyPvqdGJEQcIWCgEbkf8JWxfE74k0beXRwOByyjIt8vQ2FPmxXq8ArxtKTa1V92IdunHlbob4aeILyvJRK33mssfSRUoDZDde1qXKMDqONO9zHfuNEm8udL7K+HbbIOrW4AtvzG/TGbInpdhb0uU55D0sHQSPSCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 03:18:14PM +0200, Michal Hocko wrote:
> As the only user is in tree should we make that EXPORT_SYMBOL_GPL
> instead?

Yes.


