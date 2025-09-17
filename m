Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C11CCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8978E0075; Wed, 17 Sep 2025 17:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659EB8E006B; Wed, 17 Sep 2025 17:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FA48E0075; Wed, 17 Sep 2025 17:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 455528E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:15:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1511C06AA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:15:32 +0000 (UTC)
X-FDA: 83899998504.08.DA8887E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D872814000E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:15:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rUbvzeb6;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSvjqxRlECFwDqET9N8+cBdQWS5NnTu3eZ3l+17+1P4=;
	b=BWLHkCMVRpQ/ZrkvJQ72x4El103zSB7VUBJba1NQOaVPhJ3v2WxcFs4m/hWtBit4mQpqc9
	zcYf5ThrRAhK4awRf27a/3+7nFG8WLOGPUCxyOnGf8Teo48z8enTVDG3NC4izjYGukC/9x
	lgA3opHjSZhDHoEvZps2mup/u39OQEY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rUbvzeb6;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758143731; a=rsa-sha256;
	cv=none;
	b=Y1TTtlZmb2JEcQuMY9WztFxmLzWjzMsU4tzo+/gBHGNQngeVTa1WLyVk2T7PV+eE9/RR6z
	dxiL3Xs27e8ACgt3PGtQHkVqikXjYdzG7d3KBj/QkTmmbYbdirKT2Y0VVNXJ5OPIfnFgRe
	3dLBsfKCeV0VZnYUgh/k+M0RO71zcTE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89D8244B83;
	Wed, 17 Sep 2025 21:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA83BC4CEE7;
	Wed, 17 Sep 2025 21:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758143729;
	bh=DcxYPaU/C9Z8kxq2ijoz5I5wq5YK+7WzAtenGXmcCw8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rUbvzeb6lTZ+Whs/55k7lgnRyrOb9pGJ8yrG1X4a738PSNve1uqUlZcQLNspuugE5
	 igqRsR7m7ZGW7YhWZbOsdqHura7PFNCHH12FdrnOJlBb9p1LgYcJsXXfuvBQcK1aBL
	 Zpue6/TV2+E0fX526TLpn03YIXhPqX3qMwZoVtXo=
Date: Wed, 17 Sep 2025 14:15:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>, Changyuan
 Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>, Jason Gunthorpe
 <jgg@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush
 Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] kho: add support for preserving vmalloc
 allocations
Message-Id: <20250917141528.cd619a95a19a33d71dcc4b1c@linux-foundation.org>
In-Reply-To: <20250917174033.3810435-4-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
	<20250917174033.3810435-4-rppt@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D872814000E
X-Stat-Signature: iniiafkdjnpuqucyr4h9o4p6r1i9xf75
X-HE-Tag: 1758143730-987618
X-HE-Meta: U2FsdGVkX18kLFc7keYYrIU4vXqW1naXMOrHGmtuPncBQ16gbLiKTlxfLUO2a563yVUZclO6U1bM7cV8EzEg8S9gtA6fIFWdRtWmcBZao8WKOWxt5MTbZwTvbSlQo3bLDsq8q53H3HD9Tdpg6uYz+30OFj9SZIZudsRtwCOxn2XW4mNRckEEtUmHT8k2TI77JuqyWWM7bxfTznp/XRKMXU/dyAQDqMWdDWONYFBmnQPgIOGsBTf1XU/p2CpDMrRi3Frw/3zpoHTbrvdUCDtzg8+I/nCLPXzcRYvSJMLuWrTk4Hw0vlzJWv9YvDOgOFbz088+toLLblWu9NrxnV8yTaGTZqER/51+vzslDoTDEGeY76au8StJdlKt1rTX0VO4X4FMxOyjO3MEycR7DN9RZjKjMP6FR0TFjk46btQmD1+3hN0I86rYkBHtGOuNtpq9kazIGLrhD1r0/Pwy1gb35OJM9FBPMnxMgmOZRDX31xnO4cSWfP9DZ3C9z0/zukHk//EKYFNYp9YMYzCRdRbRL7c+MukX8uIcwIR/9jxZKQNXxj+Q7FX8p6JO16KEaZSiskcSOyxojtEej3G7WBmSYBSPzgxL8XrX7sFD22AZ/v6C50+PjZyr+FtbSl6M1aaBdsmdkvoGLBc2psOpC8GRFUVVTsS/7lleEqa2htKGUB8OR6+dsFBhX7D1S/EoTAa6Sa7eouvZY9Vg1+U7oV1bE8aKVisfcXxpoj9ZNCahbnHfq/YCTl46HrwLCUxMIAXRxtmJTgTO5eC/LCbDRjZuhAr0nbSVC8E+DMx0YGP02tMLSiBsWSdcJXGbg+OpOHsLo4IzDLSIaKwZBJWg1V3z+nUoGXGvGcpT8pxHNv7OB7SL700D7gGgoyU1aK7CYcOjhLq6wUBHMbceCZj1XiOxGLn2fGtkf0sDUO/bTFFQTjoxxwmE7p3iETOwItQnsNH/EfOvkK6x7W+6hep8qfk
 oGC/oPCo
 X7rj37wc4fCiI7jQnaynXB2bYr/GbsFY5SGL0Qbr/WvNP2eTEoNE0ILjBBaLklfmFkhDm2kYhYz9KCR9ItyCnaz12r1euAriaMw8S4UNFk1dyYAPe76KqeQ5XP0etysapfnEO19sa4kGqK3F8/ZEC7DPI8njzG4NG+5TZFAJw/DVsOdVE7ieqeoLDOkF1L9nq2wb/Cl3YbQfuGt2arVTLjm8roZ0nm0E9TCyTWTQOG7BGDrI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 20:40:32 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> A vmalloc allocation is preserved using binary structure similar to
> global KHO memory tracker. It's a linked list of pages where each page
> is an array of physical address of pages in vmalloc area.
> 
> kho_preserve_vmalloc() hands out the physical address of the head page
> to the caller. This address is used as the argument to
> kho_vmalloc_restore() to restore the mapping in the vmalloc address
> space and populate it with the preserved pages.
> 
> ...
>
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -39,12 +39,22 @@ struct page;
>  
>  struct kho_serialization;
>  
> +struct kho_vmalloc_chunk;
> +struct kho_vmalloc {
> +        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);

offtopic nit: DECLARE_KHOSER_PTR() *defines* a union named "first".  It
doesn't declare one.  A better name for this would have been DEFINE_...

And the world would be a better place if those three macros had a bit
of documentation ;)

The code looks nice though.

