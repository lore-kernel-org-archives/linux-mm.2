Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA39C624D9
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77466B009B; Wed,  2 Sep 2026 09:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27FC6B009D; Wed,  2 Sep 2026 09:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9A86B009E; Wed,  2 Sep 2026 09:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 909BD6B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:17:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2570F1C0D0D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:14 +0000 (UTC)
X-FDA: 85168873188.07.79E9818
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A2971C000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCmlo0IB;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355032;
	b=PFybq/LLDidD0xh+vdbbwqPAXsNRF0E0JI2/7gR5uYEf+BHmwlWKSz5x57xxi2ycguXxQP
	zMRz8K6v8yAFW6PedeCaZTvB2X2OUbxGZ/XyJn/PvxSAOkImCJvgKJ4+HqXnDStNxQxnuL
	50rvRhptVg35lKJ6kQbbbd5b0kdvogQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCmlo0IB;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXBMYuHpZzsw8EGad/hvSHpqzpcAdq2l3BIwxOjmYnc=;
	b=bzSVpK9tJCzohY48Ct/m5S3Zqbu/o6VEzUpFgS4d2yHiHrN3EWMGY3nabsxMXznTjZ+gSF
	euhRn5xUwjt+fvOC1OoxAAF4b13pMvGg/jGMWcjMntGGhymQuD4QNmREBTOG/AbQs3oMLm
	3T6gkhveMcFMRLrK5OdZTAoSWJPFH6A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0EDF600D1;
	Wed,  2 Sep 2026 13:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FFE1F00A3F;
	Wed,  2 Sep 2026 13:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355031;
	bh=bXBMYuHpZzsw8EGad/hvSHpqzpcAdq2l3BIwxOjmYnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CCmlo0IBLlh99KpsraxIshQySbpVOt7wo3AbgXvMMm64IlRuM8+U/mJU0jkD3S2vd
	 X7qJ+g/Is1lBaZqPXMtdfb5t8p5ByfyeWPOOPbvCcxq7LFOn6muJpVGJ/EwRyCrFf1
	 uCUF95sa3LdhmEc9e/R0lELT8YFOBwtWPXhOPIhdXTZImP2XedR6LTaSOfDo5gpq0l
	 gaRQgBFj2G/6mJ8fIdlUnMJS0f8+O0wLVB7Cy0+eD7lyvftqdBBUUslyiFcOvdeNTA
	 9Nbp/in1vcFKDSfw3Sd/6+cncOjVKHVHet75vXYoVVLC/vHHmtoCY5WEIq49+tJdy0
	 R8L/bjySoAZQg==
Date: Wed, 2 Sep 2026 16:17:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: s390: replace page allocator calls with
 kzalloc()
Message-ID: <apghz4XAgv0ro15t@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
 <20260902130612.41500808@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902130612.41500808@p-imbrenda>
X-Rspam-User: 
X-Stat-Signature: nqppfa5ys37w8e1qddjs8zrzfy4tmexo
X-Rspamd-Queue-Id: 8A2971C000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788355032-384430
X-HE-Meta: U2FsdGVkX1+DKTB2RhnW+pJiCUTEM9iJnnUUj07Fqlg+sw80X5252/y1SWWIifxeGO2ciKbrjBjra9+aNMNHDOO6tBhocSSv1vYxojTJxezFGuTIz5un9rqlD69CUKcVk65sgQbjAjNnYBDF8lF7aeGR4ggo3gJypr7wdCIVcX5+8cwuGMzj6pKfWTjxqUmtERI3co2fDIKT6khwUeEFWrTTPrwD7LHeT8PakyNVU9nLOjQPfFkXNas1amSkhfi/YmhblIig3awDj7OnuzvUNX3UcnkxTw5XUYRf9f5qkQbwwp8MJnjaYk2wHZXK/bf6cy2QLAn9Y2839yXRh4CTsaCdxxI/NQnz9wudiVhf+a3kZJYFkX7tmEGrwnJPbtPEgU5hCznOYQQwBapYkhRTd3Ib3DCjsfESx+DOECucM0O3hqGL0Fz2vGA81qAkbgDJpkCrS3ee2n8Mz/cHdLUf0I/lrX/lOQ6EB9yUjElcor+mGS3vY7+ATi2DHUNkU1uH8WQORVFZH1iS5P3bp7HX0C9cn2EAVYdfQkRfdKCXSPN01VPD4aZ0pDaY1FM97TDmkeeyL7t2Yqx5zgzW88losQ/8R5er7f38cy3fKtP/SgCkUtPFIAnejyZx0CzhuAjxrpMEFwnHzMHZpwKnetcEhFCHJZZgJJW6CzEcRpDQBRPh2Rkacng9XeFcvzVo1pyeke2X1a3FmLg/ewaWEJqnswrsDl0Hs4OfDOuQ8XpCLnt9uKZ89CQLbDG8K4cqNNDTxJZfk6zbKZe/b6MyoqW1YI12LBf4FrBoAHFTMWZZmesuU4yFVcFcRZC9VFnJQ6AIenuCSvoSg0zWe37FAP1bo7l1rpCgUxdQuxoo8ArxCe3nPPKkCEQ4m/xBx8sC4Lctg0KxC23xgNOtmP+vuGp4saLQldaysGvEvqvcuGFTHyP5sNh1lZHBrqKp1cl0rRyLJ5+J2CvMR1GCjdzkkE4
 8/Z/RDyF
 gxYTXkJAWiLeJ2VlKSWpdCLvSZ9116l2y3n0kKSFMT6JeITzHIOIZo5SR3a2q7dYapCEVALN6I5P39WcHnWL1D8YlTxpnVln/83imAb4nYYWdUaKShB4bt2BZ0hSm5iHqNJ9XulGX7HUVniu8qm89ALNmbJJ3c8xA6BX3zkrlicvD6iEGX1A8xYRoVQseSj0bsTgBmHCZ5fsbbclcZMpOaepZH67xiXDz7pF+5KYMKxsCfD+6bykTTBiNze4wk5/96q+uB+sMh+HiK3UuOAQLr1XHlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 01:06:12PM +0200, Claudio Imbrenda wrote:
> On Wed, 02 Sep 2026 09:15:12 +0300
> "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> > This is a (small) part of larger work of replacing page allocator calls
> > with kmalloc.
> > 
> > My initial intention a few month ago was to remove ugly casts [1], but then
> > willy pointed out that Linus objected to something like this [2] and it
> > looks like more than a decade old technical debt.
> > 
> > Largely, anything that doesn't need struct page (or a memdesc in the
> > future) should just use kmalloc() or kvmalloc() to allocate memory.
> > kmalloc() guarantees alignment, physical contiguity and working
> > virt_to_phys() and beside nicer API that returns void * on alloc and
> > doesn't require to know the allocation size on free, kmalloc() provides
> > better debugging capabilities than page allocator.
> > 
> > Another thing is that touching these allocation sites gives the reviewers
> > opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> > another size is appropriate.
> > 
> > For larger allocations that don't need physically contiguous memory
> > kvmalloc() can be a better option that __get_free_pages() because under
> > memory pressure it's is easier to allocate several order-0 pages than a
> > physically contiguous chunk with the same number of pages.
> > 
> > And last, but not least, removing needless calls to page allocator should
> > help with memdesc (aka project folio) conversion. There will be way less
> > places to audit to see if the user was actually using struct page.
> 
> I have some objections to this series, but not because of what you are
> trying to do (which is actually nice).
> 
> I understand that you probably wanted to touch as little code as
> possible,

Yep :)

> but now since you're rewriting the allocations to use
> kmalloc.... I'd like them to be converted to use the __free(kvmalloc)

You mean __free(kfree)? Sure, I can look into it.

> system. It will make the code smaller, easier to read and understand,
> less prone to future errors, etc.
> 
> In some places the whole code flow can be simplified a lot.

-- 
Sincerely yours,
Mike.

