Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78478606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mSGioadF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CFUQc+7b;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mSGioadF;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CFUQc+7b
Received: by kanga.kvack.org (Postfix)
	id 5192E6B05B0; Fri, 27 Nov 2026 12:43:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9AD6B05B1; Fri, 27 Nov 2026 12:43:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8EA6B05B2; Fri, 27 Nov 2026 12:43:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AEF76B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:43:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C6A71403DD
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:43:44 +0000 (UTC)
X-FDA: 85481621568.13.7AFA405
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4A15A160007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:43:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mSGioadF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFUQc+7b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mSGioadF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFUQc+7b;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jbohac@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jbohac@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795801422;
	b=lW7YvV49MKbqutnu7muIORnb8xpQLoKeKKF7uB+pPnasAVLqyDmLMSVb4QiXeLEScahrDT
	WM05teXPqHO/zJ/oe1h+BwiY4YiiMLNwfyx73IikRgirJC89YQlJcHayfoo+iSSn9mtDCc
	MSRAmlLVf1ao2CJ0ZRzoJvurz/LNyeE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795801422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4//c1y7R5iOay/1qB05dRfh80LMu6MjdD1lnRgqu534=;
	b=5F4lcsQEGCeMQeMw6Yvm0IAtXGf43LL7vU6VMBJGt85OWdAEaLDiu4+Jjg7gHyHNckPeBO
	c/1BACe6KgUCZlZXH+t7/dQXwPl+aZOrE2/btkjYANVQK1CD4P/v527MX/L1d4b8yg36gc
	SHWrJ4QGuI/k9kDRVeUpNxp3Pb8qBlc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mSGioadF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFUQc+7b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mSGioadF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFUQc+7b;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jbohac@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jbohac@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F22D01F7F2;
	Fri, 27 Nov 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795801421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4//c1y7R5iOay/1qB05dRfh80LMu6MjdD1lnRgqu534=;
	b=mSGioadFgU4HHFtRiF7iKYor+d4NLBHh6LqlX5JJCk+ry6KRDZAw+V+GNj2B7aKWTJ//KG
	6o28tanc1pGxfauhC1xZ14SQcWAcf45nG9SRJCP2G4Evog/tc0WKSksKX+7/BoBJ1mj87o
	nYK4MhBvR78SIoeEOF3PUYlHJufmlCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795801421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4//c1y7R5iOay/1qB05dRfh80LMu6MjdD1lnRgqu534=;
	b=CFUQc+7bZAUwCAsOWXF0HebaP0jlbgM+a6julN35p2Pd+Zj3B9I26kWH6mAD5WNM86adCS
	42QW15I9Oha5ZUDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795801421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4//c1y7R5iOay/1qB05dRfh80LMu6MjdD1lnRgqu534=;
	b=mSGioadFgU4HHFtRiF7iKYor+d4NLBHh6LqlX5JJCk+ry6KRDZAw+V+GNj2B7aKWTJ//KG
	6o28tanc1pGxfauhC1xZ14SQcWAcf45nG9SRJCP2G4Evog/tc0WKSksKX+7/BoBJ1mj87o
	nYK4MhBvR78SIoeEOF3PUYlHJufmlCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795801421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4//c1y7R5iOay/1qB05dRfh80LMu6MjdD1lnRgqu534=;
	b=CFUQc+7bZAUwCAsOWXF0HebaP0jlbgM+a6julN35p2Pd+Zj3B9I26kWH6mAD5WNM86adCS
	42QW15I9Oha5ZUDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8338134E8;
	Fri, 27 Nov 2026 17:43:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 13myKEzBCWsfHAAAD6G6ig
	(envelope-from <jbohac@suse.cz>); Fri, 27 Nov 2026 17:43:40 +0000
Date: Fri, 27 Nov 2026 18:43:40 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Usama Arif <usama.arif@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Frank van der Linden <fvdl@google.com>,
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org
Subject: Re: [PATCH] mm/cma: reject long-term pins of HugeTLB folios
 overlapping crashkernel CMA
Message-ID: <awnBTG3budAQqfSq@dwarf.suse.cz>
References: <20261125155108.24098-1-ekffu200098@gmail.com>
 <f79014e3-3c81-4b2b-87f6-df0c2d946357@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f79014e3-3c81-4b2b-87f6-df0c2d946357@kernel.org>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A15A160007
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3xuahaisf4uirrb9o3zreesdgt6fuzjh
X-HE-Tag: 1795801422-609988
X-HE-Meta: U2FsdGVkX18G7wfv98IJcfH3VhJCduxF6t1qlfoO+i0aIeVzJXNapJcKoBuKVMC4IC/GId88yHCx2ggf+ISUOaPCq3Gdm8aIvlQNsKq7OQbQH4KUquKava2i8fdsxIYmbMtc0narO3/ojQCi+dmm7W0lwio7JM5Qq6jp1Xvur1oo31/U2logYd6Ugb/wopqhU7/9ZUXom1Cq6Lzm0NzVyEbBWGtmYjKeqBCzeVBD3hkU2eZ45vAkZpYkB2f67XDhxdabjRHaNd6Kq7Vq0qK1JjKv+5Q8zuFHGUuMV+Fgp9ovY12pwPI6EV8xCXG1Kadvxw2es5FXg3jVySpozncVrk3CKL5ElX1EoYHpyK5CtNDlWZHQUTk3KU4/8rN1pZU/E6jPYK3P5KFWBTRUKG8RnSaaHcLHy+r5VydYVUTQvStvHXbTIAgGD39WaSvRXk4BrbwXyXifZsdoRzyV/pk6zvxJbdiXI32Va5dCLxxzswHp6/XxyImZhO9Jx3w09LUCUW32vEj0KYmTYlLI4hZ+zTIzy6/VQrnhixujp3M9LvRWuaHlDg8h4wwOOVgoXV44r24lsAlYVJk9kaScXelKHD8ffnQWZWQJCWegsq5DHZI6QHPk3vSzmx6mmD2h3V3Oewu4OHEt7Nk5wwfPc3oH6kVJczjnBdVBvClsK1yUz6nU7n2sgbJloW+aeNYgUdn3dSrds+OeG8Iy1NArgQBgVGlKqpKfByXZPDf10wD9zFeTRjPULr3IqHhT+TNYnyJkATlaXvAAytUYp1w/psn0LxMCESG006O5C0skgGCuuiKpn3lG/c+AWBUM0PcsU2FMWe7f9THcAZxoObvizoY7lthztzxAP9EuKm+CMX//GQrSd0sj/4VpHWlJCMkTE+I45oRqRGxZpLlfJpIaDaTRnH9KmwlCuZuYUNnsn3FnWmj9CQ6A3gDCjFmY9LoBNuepaR2v/z2iKiC+OSdVKZg
 aH2tkWIe
 kAbThtyf2lG4KKkoj7gmYSE1Ybv3o9RN19pHg3+y2rZpi9ZbgLmHv94uE9nEivfCiO713se2FQiozpHh44oox7SEC1RH2ol+1/qWx3yKGw1hEwRmvXV+cGhvh1uUPgzhseeL3cJiiPoHdTyqF67ql+P9IRNecs6c2Ag/G5xbGgAGBcagmtTVTvpPS29G1Lj1rp1VvjfKvYvQSEE1Gt/oI2W383uTDPZiyjZ8JIn2eKvBB48SPwaZVt2+6Xzx5GvkqpkESAt4d0FoUP8wRoAPJXrhLU89DOAyWyfGX1qc9MkjxD9m/zkic3FitBIBGeNgTbxj+qIwIhUJY8bvog5j7sC/5ZZr4cK3rUOnONGuQ90CnUa0Na0jdDoGkcFe4qbySCSpKLqXW/JabP8jEbXOhJT14Cd1qH+absY8YuoaXaFMdHJwrPqYRgSk6KsXbKWCeRxRFrIuufHTuCPwRN23T+pqyZiBZevZ+kNxty49AXWhlBizglcsuEvNviA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:43:40PM +0100, David Hildenbrand (Arm) wrote:
> On 11/25/26 16:51, Sang-Heon Jeon wrote:
> > crashkernel=size,cma uses existing hugetlb_cma memory, so
> > crashk_cma_ranges[] may contain HugeTLB folios. HugeTLB folios allocated
> > from hugetlb_cma can be long-term pinned without being migrated.
> > 
> > After a crash, the crash kernel uses the memory in crashk_cma_ranges[],
> > but a device can still write to a long-term pinned folio.
> > 
> > So reject long-term pins of HugeTLB folios overlapping
> > crashk_cma_ranges[].
> > 
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > The above scenario is only possible with the two patches below applied.
> > Currently only linux-next, which is targeting v7.5, has both of them.
> > 
> >   "mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory" (kexec-next)
> 
> I think that's a real problem with this thing.
> 
> The solution is not to disallow long-term pinning. :/

This patch does not disallow or break the long-term pinning. It just makes
sure the pages are migrated away from the CMA before get_user_pages pins them.

As has always been the case prior to 
  "mm: gup: allow long-term pins of CMA-allocated HugeTLB folios"
(in mm-unstable), which introduces an exception for hugetlb CMA
and allows the pinning without migration.

And this exception breaks the assumption that CMA does not
contain long-term pinned pages. The short delay prior to kexec
when CMA is used for crashkernel is there to wait for pending DMA
into short-term pinned pages, not long-term pinned ones.

Including 
  "mm: gup: allow long-term pins of CMA-allocated HugeTLB folios"
without this followup breaks this assumption, which we discussed
during the merge of the crashkernel CMA patchset.


-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia


