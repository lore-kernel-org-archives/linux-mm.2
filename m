Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D77DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39CE6B00E2; Tue, 30 Jun 2026 11:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D118C6B0110; Tue, 30 Jun 2026 11:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E2C6B0111; Tue, 30 Jun 2026 11:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A49A96B00E2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:01:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B6D3C2444
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:01:26 +0000 (UTC)
X-FDA: 84936892572.21.6994CE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 70E8C1C000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:01:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6lqx7xe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831684;
	b=LjsQgM2t1EHGTC/uSsT0wnIku1Pri9MXzb4vY0NCbjE10QAnH8a6MvT94oJNEln+KdC+bM
	Nf4UXOyjMiPq1dnv0mtwl1N8G7+f8TlwaWlVe9zDDJuvpZUgVrg6EY6t6iJssHMpsVhL+S
	0iQJOhFkPZN9IGpZiDRQhqlK5vbhnyM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v22ZwceD+Hle0zDa72UrwGJHemOkLfc0UBG3SW36enI=;
	b=twmvK2uaXlI+X/kQmtkuq8R4fYr1NEhM22eq0iHYTi83IKaO3qheANpbewAr8CEyNPpsgG
	9EHHtvWGFbHj3lTpJzbCmNtzNgi1yzrxp/Pldxn3WAL2I3c+q9x2diPrzHeQgf1GwG0HMr
	xhp8ZJ5ZknOKqDx+fcxI588xkvSf1ZI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6lqx7xe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80563416C8;
	Tue, 30 Jun 2026 15:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4CD1F000E9;
	Tue, 30 Jun 2026 15:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782831683;
	bh=v22ZwceD+Hle0zDa72UrwGJHemOkLfc0UBG3SW36enI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I6lqx7xe7ArEoBeN2UysBFuosgjtJd5J+5+JeOIu7nS7HkHEgOhZKD+NYpCgObeHQ
	 yx2gWe6NnthkQSUTweAI36dYEHA14aVvXYEOst62rLvNCjMo1jTB8pbeCqQzyQJzGh
	 dEuhY/mgrlzj09HUZxkcxAwvKcS/G95M7h8YF6EN5a3vmMQWrodWMlnCJnCcW+OlGf
	 ehGlUmxiDsExBPFzuMKvrjJdu1MxfULg8BOK1azZFEExpSBfKc+/rNWw7bQQAuNtXG
	 DrymVoUdkO1du/sPhAAjdKEL71Rpaih6H9vUFDqbg/ndhd54OWQjJCJJYfXrmFzny/
	 hmv0rm2Hnf/kw==
Date: Tue, 30 Jun 2026 18:01:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Message-ID: <akPaPaCJdYINBEEV@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
 <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
 <20260630123150.GB7525@ziepe.ca>
 <akPaAp-0Zul8uVga@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPaAp-0Zul8uVga@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70E8C1C000D
X-Rspam-User: 
X-Stat-Signature: 3d66cs8yasu8bsw4g9cqujaktdinndo5
X-HE-Tag: 1782831684-637859
X-HE-Meta: U2FsdGVkX1+xF0dh0DYK8QeVziKzNFVS2QaAnnYGZZNK35eQbC6d6vY/LFWX8kkcYc27UL31PAIdq7eZovEUCAb2ZojIg3q8QlUon7e5cx6j5LzwguJi3sLjYTGPADh2XPxmmXNJyK0gdjyxnvhFnK6zSd/M6uBdR5UDE/dAJlvLgGyrBQmqGXWJohIuDLbeRNu9tGejqEg1NFQr8x+4NT8S3DOIkSGfGDHnAUSRoEtW4Sw6zZuZK/q5Fy1cq9sz69CLYboEhUTleSMN6vuDjGClJFftx0u1wmdRAwo6SQ6OqIZkcn1hHbdhYqeeIDs2YhxPnx1KUyBfp1JhFKicfQqytjhr0H+5WgGm/xnkLrmiisqXarjkusvopLeQ+V7xAIUhklBoxzrxKp9nIARrEP9w+MHEWFi5wMsMcdWSrvw7ZtYNYrjhWSorSjpMr35AVMNBYhSvuqo29CvwbMKgxBdLU9e1aYTV9lyyQbCT+EIEqXhSvPRVHtkyGNxvgo1u7TZKLrbL3DM0FICmyli5QWF1HJpKhvXEeq4A/BVAASdJzx7bIr7g98imwAkesSs7ZvbL3YrCu2eaDDcmRVDHXZH7jNrQKQxV090cIBzwlmrPAfZgnDFecJ2nyqfGX8VJ0ZaTG2LbgQVepdresCHbpmgJLwP0am/cVqhHl1wDsqrwl7eUVEicR5cHfm1mFlNoLrrv1llgfMlptAzrID4OOuVHMesVNZKkhZc/gojFj1wbOtyDba3iIi5V90y5cU4kWy12r6Obg5ZMRgnV4hNS+RbjAubKZBv+nAaPcPEJMc9dCsg2ZCBM0sU2yS4056JXuZG31uL2dP4evH8ZNmmEBYdOL5TOeL2TiCmd/+yOjPEj6Vl6qE6zbFO5VcizbnuE4SlNUGL+UnoyLy8kPv3uVsCOars9DARQSY5OecYzR1UQxFVCM2UKpSJLYJoqKRW3my/RWxCpR8AO3FTt0Vf
 pL96SBqN
 qX7UpfjagnecWFypDjrO4WwWs9N+0qCaYGExtNx6v46kjiW6Mde73vBNLcigm2gzuxvPm9fSAUJobWKi17R67vYhlZaLDzC6yRCMo/mX32h7vXfPXbSfXcsKbNQIpb9EdEy6G6nDNiJZKBYjTsaQTDDiMwTZteQtODEDidnFYhWaIhxAswLJCynWtX6U0Ebj+I+B8gpYMYIymvnOquwABeHkJbXsiwQ/jICCqHOGopFrVVGlwJMbD4nnxQr19DVaDK5A3JdnwVXm7w6Xja7mn/SoDh0vLaGPAmqKHUlFiBfZKQQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(actually adding Vlastimil :) )

On Tue, Jun 30, 2026 at 06:00:24PM +0300, Mike Rapoport wrote:
> (adding Vlastimil)
> 
> On Tue, Jun 30, 2026 at 09:31:50AM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 30, 2026 at 01:52:29PM +0300, Mike Rapoport (Microsoft) wrote:
> > > ib_umem_get() allocates an array of pointers to struct page for
> > > pin_user_pages_fast() calls during memory registration.
> > 
> > A whole bunch of these use cases in rdma are really "give me some
> > temporary memory, I want it fast and as large as possible. In a
> > syscall context I will free it before returning back to userspace"
> 
> Not sure I follow where "as large as possible" comes from. Here it's
> explicitly a page.
> 
> And does "fast" mean that vmalloc() is not an option?
>  
> > eg we'd be really happy to get any kind of high order page here.
> > 
> > So, how would you feel about a new API?
> > 
> >  void *kmalloc_temporary(size_t min_size, size_t max_size, size_t *actual_size, gfp);
> > 
> > I know of a few other cases like this in the kernel at least.
> > 
> > The implementation could try to find an available high order page and
> > immediately return it, otherwise do a small reclaim allocation?
> 
> How do you suggest to decide how much of reclaim should happen? With the
> usual semantics of gfp?
> 
> > Jason
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Sincerely yours,
Mike.

