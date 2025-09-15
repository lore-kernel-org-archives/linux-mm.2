Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CD9CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2AF8E000C; Mon, 15 Sep 2025 09:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA628E0005; Mon, 15 Sep 2025 09:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7358E000C; Mon, 15 Sep 2025 09:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B78C8E0005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:58:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28825C052A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:58:06 +0000 (UTC)
X-FDA: 83891638572.29.08E12F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4600EC0005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:58:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hAj6E/Ir";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILCtKFmfYnFvId3j5b1uDA9fz5e4kRdNZzLTAH6mDZU=;
	b=S6OaayenbvmHvbdi0w8di95s9LLWJgGHTRpVtPSmNbH5c4qXusT8xqr0iNBmuSnQsF3Kkf
	/Zg/xr8a5nkcoTnkGUl718nqXrzIcM5s691l8zXOAiNjKKpbWKNmOJnv85c/rWyVXnuxiu
	zjvLzJaIx6c18h4qpLT2oQHaTzfuwMM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hAj6E/Ir";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944684; a=rsa-sha256;
	cv=none;
	b=IX14f0m6sjRA+HxWCdcdGM8O+LGh0mJHUici5DF9A8pv/+qDF+WqSwdoad06Ug7BVniP+f
	BEZdOsVICzqrcRYaT84sXAxMyNb2N835l1ktfEvqx1cnbxU29Ejhs1xZpNooF21PBNHFdy
	T6p1hHSsZEkE/f9G6YadOb5h4bMh89I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0F3B401D1;
	Mon, 15 Sep 2025 13:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB065C4CEF1;
	Mon, 15 Sep 2025 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757944682;
	bh=zfhyJFbpd+KywjV+fUeZ4MHJ3acyIVGXF5VDrBR3oqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hAj6E/Ir4AcO15gg4WswXPYafaVEjYoICbCA8Ag7OHWX6rZwizZktjF1JXf7VU6xd
	 CEUGAByV8DTlJ+KHyVddNKEdEmTI4oj4QL/FLCdjtOUkliPSnyRG6jVALUuzJj1VP6
	 CSLvcbzXRP4PWdf0ExQYFaIC3Km4yAfiJiV7PblSZUJj5iwtiXA3UfdP8UJ3kRQEIC
	 sbhpRwwwW5KgSgMQqG40XiL37ebky3DEBtTGVte+j4bIbtbTh8GweS7XL5GB97BkTO
	 cLM1lqDdieaRdNRGieHhWZNXbMwPsXIeBxXGo1M70cjoPlE+RCLHHI5xoe0eoU/aHj
	 /kAJkO4XoPTUg==
Date: Mon, 15 Sep 2025 16:57:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kho: add support for preserving vmalloc allocations
Message-ID: <aMgbYrYwxKjiW6Pd@kernel.org>
References: <20250903063018.3346652-1-rppt@kernel.org>
 <20250903063018.3346652-2-rppt@kernel.org>
 <20250903125620.GG470103@nvidia.com>
 <aLhg2Jli0KUe-CXC@kernel.org>
 <20250903170631.GK470103@nvidia.com>
 <aLiWDl3sq3RTkdfJ@kernel.org>
 <20250904123032.GM470103@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904123032.GM470103@nvidia.com>
X-Stat-Signature: fa9otcc9tpodxp1rwdoijhqzo9wnb59i
X-Rspam-User: 
X-Rspamd-Queue-Id: 4600EC0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757944684-684423
X-HE-Meta: U2FsdGVkX1/xt47WTRCRGlLEBB2zjN4m5zfQgyZ6gVXOkiiJVFf6UT7G2LXKv3o8VdpImV/kAL6B/gRCa0Fowde51d2OxcCWCOTxbLcDxh6dNR70ugAeKNpGqJHAKuI0dUKiNeuVgFd91wfeC3+/jLHUro16mp6Egf0WvZgtBJVVqx7fdRr1RDqBXNgK3+hR9dTlGJ9TmYe517tdrkVzUKpNILVpvUDKHrkQnwCpbS3OB3j3I0yjTyESTMv2Cd5uq4+fx+yxi92oqbtphCgOawU4GqCRy0TdPi4OOAH0J4Yd/WT6dO/ZXyxFXQKOu4TgOYmDd07NSNAy+I0MREhQDljXNB+wKHcrn+FnAK11xjN/w0+gnCeRDFyINaV2mm1y5fXMaFgoO2ypNviLn6ECXNUFwAt+Y+zFwBUBoiBc+jllVjcjozHQ16dmt+aQBmAm8QJ+Kh8Q+G05GORIWqQ+nNyGYcWRw+HsNOTeWpYlfKlI0qQ089QhiFehODEVFdLXVzHu2NjtBJt+PbkRp5WNdAeaIZAeEjQXYikmXBuuh4U38MRplFulqd8H9UqYG4mU6OYRwPfOR2nduBUo8q2oyyd+Cu+np1/gS8wb/82FXoVKXBlRDnDn38WOxo6q2VUqbq8K1IfoHouv1YlInwovsErc9DFWlp65G2mcjYEcM5a5AmOkq562bWw7ukDsHVsFFScI5iCTJbismNGwYMCVTL14yI+oENCNUc4DY9bEW9/jYmBttRTHWCQukmDrjnOigUmm1NvUV7UO29UyDMSn0VxjQxbrpDE/Tl+yQYFnjQsKb4+PgkV+auBHO4psZLymL4Fn32O3cLQAFQou2D5Wwi8Fl9JDF40N+KkYkWtg8xUt9FHJqkOPzEDg8B3XpT+avUGyqFsUVQTbvOGxr8Yl183sAP1rexrpdavafU12Te6BwXKOtz3OaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 09:30:32AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 03, 2025 at 10:25:02PM +0300, Mike Rapoport wrote:
> 
> > It seems that our major disagreement is about using 'folio' vs 'page' in
> > the naming.
> 
> It is a folio because folio is the name for something that is a high
> order page and it signals that the pointer is the head page. Which is
> excatly what KHO preservation works on.

kmalloc_large() and vmalloc(VMAP_HUGE) are not folios and won't be.
 
> I don't know what the next step is when folio is split - presumably we
> will get a new type to represent an abstract memdesc head of a high
> order allocation that the lowest KHO primitives will change over to.
> 
> > I'd rather stick to the good old 'page' and when the time comes we can
> > 's/page/memdesc/g' supposing Matthew actually plans for it.
> 
> I think you should just convert from the vmap page to folio for now
> and most likely vmap will stop using page someday..

This is wrong. vmalloc is not a folio and according to memdesc plan [1] it
will be be page until it becomes memdesc.
  
> > There is a struct page for everything that's memblock_alloc()ed. And we can
> > do page list, but for large  physically contiguous allocation it does not
> > make sense. 
> 
> Arguably you could make them into high order pages and preserve those..

They are not aligned by order and they may be partially freed starting at
arbitrary page. Making them high order pages will be a mess.

[1] https://kernelnewbies.org/MatthewWilcox/Memdescs

-- 
Sincerely yours,
Mike.

