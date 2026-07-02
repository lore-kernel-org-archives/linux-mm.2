Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103B6C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290486B00B9; Thu,  2 Jul 2026 20:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268666B00BE; Thu,  2 Jul 2026 20:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130B86B00C0; Thu,  2 Jul 2026 20:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CED6C6B00B9
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1FDAA140185
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 19:36:39 +0000 (UTC)
X-FDA: 84944843718.28.E06A872
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 846A3C0002
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 19:36:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAFXpiM5;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783020997;
	b=WOKOApwqnsXAa1cVBdPu26Wzet1tQspgO9VTGDzWM92uKyAKoeTihPZXc43KK0oPXPmtuh
	JcpF5BeMqwRp2fwJ8lh9WycVxQR+YjO2X5JcwdgTISI+k1BcMKe8sbLOkyei86uiSIiV1V
	L2tqMMTVn3mo80bBnfeqeYU6C4mVUrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783020997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MY2PvaibwGLXUsakAE8KZoj1YpuVr+KpHhe3HAZG2cY=;
	b=GDKEuS0h1Tp7H+gMZct/NwIV84PM9kGujwBwcN8hdSR5NDCheXi/QRBNYDy2bmT72WAMr2
	05aSGSWAgw9Dgj2Sc8mPlVt7koubZJe+GAP+ICQ2EpP38cuq8wxhPH29nvZybMNnwUKHTB
	MzO4f2sRJl0IVqQAAIiAY3nHd8W7jJc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAFXpiM5;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E026B601CB;
	Thu,  2 Jul 2026 19:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1472B1F000E9;
	Thu,  2 Jul 2026 19:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783020996;
	bh=MY2PvaibwGLXUsakAE8KZoj1YpuVr+KpHhe3HAZG2cY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LAFXpiM5yXxtgfZHPm0Wh6d4EBqzikJlBc9DZIxvBW///LR3ZlYwKS8VEPhSwMLni
	 5Ff1rr215W1jtQ9H2DzGiUboxwvpI5gOpyVzV3hYRsJZFbmnsbDraXswJRf4pSPpLh
	 AXpX69ssAn2+z4jkrwG0EjeH/PNCQbHCcU5pREN4CTil3KOkOfPs6UlTytKpfCdd8E
	 ZU81jx3RMsZqYWVMkj0rldjftacBQw2G39vyw/9rZNMDDec1AJu1aUJuaGgTZNLRTV
	 DXTsecJkTevpSvOEketwG0h8D74tZ79onp22LrWroYO0H2YtdHcq08iR2P6uMWX6Lg
	 dC21cEPa1sOaQ==
Date: Thu, 2 Jul 2026 22:36:29 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Dave Chinner <dgc@kernel.org>
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <aka9vZSViFlzBrwW@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
 <20260630123150.GB7525@ziepe.ca>
 <akPaAp-0Zul8uVga@kernel.org>
 <akPaPaCJdYINBEEV@kernel.org>
 <20260630153638.GG7525@ziepe.ca>
 <9cc11eeb-372a-49fb-ba89-486333ac71c4@kernel.org>
 <20260702125516.GO7525@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702125516.GO7525@ziepe.ca>
X-Stat-Signature: sxxs4t3yb4n3xehqru8fx9maewgtxuka
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 846A3C0002
X-HE-Tag: 1783020997-898795
X-HE-Meta: U2FsdGVkX18KA3IdkKMzOQozz5ohngauMzeX5h1WVTCULcf7u4OeyzSnIW7DJi+znHqG6SYGGwmJKMjUxRa9i88A/MqX/hDi8yTlOu7jYGFQnkeH11Cdwi5kfEtKwFXysp5HgGTXiIKQiJtbWJHK5pIJxNC60UnmBtJfocE86caCkZPAHUvEcIiHlCBlkyRridKwDXfJ6BxMv9Je3nRB5pD0riJsPyg6u2EUcOXYqfbApeA166qolb76roQbadsFVhmz+ih87W2yv5J0WgfXvtZ676pcBdSHkgPeT0ShxrSgJFTrATCAAQjQLZwAOO6JyrKLkEEHgIYGnJvfifF9j3QEy/Qf2m3akFBKuKzF2iLp7SBHAdQLmzstDBUSsBty/y3CqCaosYFcazh8a03J0PyZ+3XgPuWzLIRg7C8Zlw+GZOuk2kOl74IOkcWvczGAsk06m4vio6QCjaqsvucaF/fBGKc5Ld4xgLkr31oTtHIboEgtcigtsTNvqRkWBiXAFlWQVfReC1C9NAZk423z+CviUEhkGuwv7VimsdHLZaD+mQiRh5C1O6xF9qXZC155dzXIWnDkbY5mdVKsFx0BSpkR6YlsyX8OjCWSe4cTEKX9vCyu3ItNAz+W9/wLjqiTHHA/RLEM6ij0FmhAKR8b8N6aIJW4PcLi3NZIYsHAQ5KtD8TijwG59xwvdsLIkOqp+9v0Ypke1tNcIjuA/pDFvymCTawQZuBw5GyBG/e4gIZus5isInzLpUPAUmsHkjvo2KC2rCXCaMSBwLGZHMOh4asshudravS2Qr7DgD6Dp6WGZhgZVMsU8JV33SzEZInp9i9Eqp6y20pP7oe05ocyBWaUbEz6ktZbgfBRMFU5l49sy38SfViPhoTQc7uemL+psdCkeVVWnqknitX1/rUqBg10e+NeUuEgTHb8kam+6pyQCkHyw4pp6Gr8u+2M0Zaa9tagowszz4pD88qzGbx
 kAcA5cPy
 SRBfkl03BK33+QMw0RZE4lz+fZhBpkibo3pKbFZgFOkXYblZyFXamcnaRnyi+hxeDwBlCteQDQaSdtwXIxvAFiRo6DOGQQSuFMZqFEtO9o/yYjK8mn32IwuwgEd/SIq+7OLsbJiEZ1mPhjCwph2caJTJX9zgp+j/kklvjg42ifVW/XUB7/HwnotMvaLySns7UFSQyvkNnqChlEAS63HoyTvIXJpa9H+2jHkVLJXPRuge3aef/fEqLdmm/E/vKTLa55oI4fabpfJ9Vz4pIsTtHJY2GgpUfLX+tHA/32aiuFx68T7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 09:55:16AM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 02, 2026 at 02:46:46PM +0200, Vlastimil Babka (SUSE) wrote:
> > I think this should be discussed more broadly and not block this
> > change.
> 
> Currently all of these get_free_pages ones in this series are this
> special need, so I'd like to not loose that marking somehow. Maybe a
> comment or maybe a inline wrapper function.

Comment is easy :)

As for an inline wrapper, is there an appropriate rdma header to put it?
I don't think it belongs to slab.h.

> Jason

-- 
Sincerely yours,
Mike.

