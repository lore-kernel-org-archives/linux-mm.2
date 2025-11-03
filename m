Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2DA8CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 15:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C468E009C; Mon,  3 Nov 2025 10:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464048E005A; Mon,  3 Nov 2025 10:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37AD18E009C; Mon,  3 Nov 2025 10:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 268578E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:18:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA2E8C0173
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:18:53 +0000 (UTC)
X-FDA: 84069653346.28.CFDEDCD
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf10.hostedemail.com (Postfix) with ESMTP id A25E3C0006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:18:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="G KVkfKC";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=q9+n6eh6;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762183132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4J/yAIXHqePkPtS7iPxC2+IJeE7T8ALXXo4jnVmJ2eA=;
	b=wMpzvbqBfrI5ecWlpWpubgtzFcDQRqMFtg24nJep3IAMpvbTIpz+up4cEZj3/xD7oYWfML
	uMchK1b2EF0qb0nLv+VOEpsL8ZLt7Sjk28qsAEu6PfYLyuTjJXtAY8J5TIU59gBpT9aoNY
	V5bP1rsg8EiJJKbW1UaYnhk7MZ/t3wo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="G KVkfKC";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=q9+n6eh6;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762183132; a=rsa-sha256;
	cv=none;
	b=GWHLA3RnTbVpPB/6m89ohmvLmKtlMKTzvt7eHCD4PJz77uoZVVhMo6yD5gbwoXRkp3HByj
	3756a2094rwbr+mzJf/dmGs7APaUxXBbooMuvNZH9TGv5UhC7toMV9YmJpdo+ySULSWa6b
	MCbOQ28TCJKsZ/LO4XTHxT8VjcfmYUw=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.phl.internal (Postfix) with ESMTP id 8942613802AB;
	Mon,  3 Nov 2025 10:18:50 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 03 Nov 2025 10:18:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1762183130; x=
	1762190330; bh=4J/yAIXHqePkPtS7iPxC2+IJeE7T8ALXXo4jnVmJ2eA=; b=G
	KVkfKCp3XUpsixALMrMjMXHL/XPGbl/tZhVvdyLsRrDIaeXlwzdSLgBIV9kln+xj
	w9euFJxbxx4kvirB0ZiS3oM0+Qy0ZPqCJV5lt7NqAcCUm2taV0lEIB6R3AOVFFcN
	/h4vSUlFnF8I1EhsRbgU4ZSagX7UcU01adXHKHYTFVcC4IIT32S6WVmbuGrSX0Ho
	OZEBdBORtda81bWO96DpEQPXPsDBGDU/H5YOzznpwfaFaOjLJl8dDwmPP3w2xiN3
	5BOLpw9amvOEA/byjWdsPqXLBC/l3M5ISk+/Wsk0/7QKm+8n/JPqiEOPXZLfYp6N
	6GVXO3SbtrHGmKuovwvAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1762183130; x=1762190330; bh=4J/yAIXHqePkPtS7iPxC2+IJeE7T8ALXXo4
	jnVmJ2eA=; b=q9+n6eh6upRvk7AnE6iyQfhPbMJFpMjwznzPN6xvIgcBCntDMBK
	2Bwl4YnRNcJoJvwPixpcGbkml5GhwZOfa/cs8csnf3twevU7NspJN+BVOq1wzW0w
	cIJ0oBjFvXBsJn1wrmIROzTvx2d2k/G2l9fDBv5V3EfmanWFlgcrNYz2/BjT0jBh
	eIaMoQcBgI3wKxqE9rHDvD4pSDnbDcY5OjcfxFQcNIJ1mlZR1nmG59MS+8zp/Z51
	ELlEaG2bkL2eGZnLkqIzud4LzxFYNe0NQYDAQu7zBTHQ8RP3QsEwxfI9ozM5hct/
	UwB30L5cNfzCALvpqqT0tXCmADksAmJcIFA==
X-ME-Sender: <xms:2McIacop7ZLPyDZmZqCMPtVoMLvvifWq26Fs7qPGKqbkQanPkaTRnQ>
    <xme:2McIaaVdX0fp2WbXiCudCKi9wk5pvQqScGJNE9Ma-vKhXApPdZgdZcwCIhSwsfDgr
    HuWHDQJfDC-_ouNBYMIVJCzcuCjE3Orn8uRBeDFcZz_Hc1GiZwZi9I>
X-ME-Received: <xmr:2McIaTYth94jE5bZqanVXwDFhwBivA3ZJeZpHesE5x6WFVJF9mATT3etSJy5ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeekgeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:2McIaSlJnnzurptzxwq4E1GE_1O5XB-hA3ZQQs6OX1L2gyuSlBsZ7A>
    <xmx:2McIafdli3EKWC8nSTp5CKgjEanm2RACgHBv4GYs85PAwodb1nUi4w>
    <xmx:2McIaYsJgv0ZCZ5kJ8xFt8KmpI9G4LL8QZFjEGfAL140P2c7Eq2Xnw>
    <xmx:2McIafTMZGmCeJqp6FmoQ8Cc5fAraSPSJjuG-tkEDXcn_JoEPsgAFg>
    <xmx:2scIaf2rnwk2Pg9KZiL9pc_3dCGYTNdLWqgatSC77gINN-ED8YP1AsSv>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Nov 2025 10:18:48 -0500 (EST)
Date: Mon, 3 Nov 2025 15:18:45 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <ctkrffqndi7tmw2d7vj5k7asotqe5z7ic4ux7wc3pqu6kyernk@sz34te5pkbmd>
References: <20251027115636.82382-1-kirill@shutemov.name>
 <20251027115636.82382-2-kirill@shutemov.name>
 <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
 <hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
 <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
 <aQWT_6cXWAcjZYON@casper.infradead.org>
 <xadc6rbs7fkk2mb5b4reobqwue2kveo736r3wpa5zwted4daua@rgasjiwwot3g>
 <aQi9zaPxwLBTneF4@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQi9zaPxwLBTneF4@casper.infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A25E3C0006
X-Stat-Signature: hq66r7qxc5riy4kon49b5n1pzeamb48n
X-Rspam-User: 
X-HE-Tag: 1762183131-58198
X-HE-Meta: U2FsdGVkX19a7re9hLks8hJQ0aRZx7aXqvYHP3YWLMnZcXpuPJkDQiZnaGf3fJtvTQaSee3Po8JsS/7kpwjS3FE/eBo39PgZOj89nlbFpahIx+YI9rDGEybcGh8uF7tIUKZZ1fGXrqqPUv+2tGTDz2WoYrcPI//NK3M+1fU14C45TBWdQJ0ejMAUPsSqtoJKpj0/x+a5YcuCaxvyVVXzHDKfE/S57Yycdc460wwq1C8ZcQyKJITex9bn+V3HyKKaCmGGjPclomtB0nHq9jxGolEO0UHggMluIJpZVOMCJWY4Ae3Rzl+Z/dHeP4ExYtCTOFfu3X5mRF2zlOqLBXGfyrc9LiaHoL3uRvfmRprpEIWfjh0d18s1O8GgyfA6+DgPEIhn2vWew4L3brzNB9dXUqcMZHutcBkLL+jShYYNQv4hapxJjJZx1HieXnnKdpKKftzxAsX7zKZTI5S0ReFII49uhhGud7j+X2SQrzt3KOKSNAFuYljEkC0Whmv3tFFtDOnHAwG8lVHUHg8Rx8uWE6wUElEBX2iceY9BAFT2XJSb2sg1otwrHRYPtKjQcluzyhQlo/fm5pxp0EJ/wpLoeM/bK57E7qSI0Z3p08igcEo0giHKun76mzC4O7dCq9UjxsmhGyrxfbBNx0OSwUXUsEHcufTBctP6nppfwVQAd4Dla3OIPeEflJ4sRioPVJ2DquYQ9Z1kkzcVQ2mXJMVzWUety9pva+eswliQuBCAOr2vNSpBxpmjU5veM23aQRs2KhvWZ7bZOYPg0jwjX2Ft041gaXfvZmvFKlh1IB7Ybwmy96wlUhayNSR6AwecgtKTnl6HOg3iYTWj/lXooa50gD8AMFUY1/xXxcBmrjPeadjcNPjmE+2vBNjsIM6+Sp6L7CzLdMEoSoCIdZDSELVIhrTYUgEUpZ7pBm0w4Blq/zYYEWUoigcnkWC874VStb2zZyEVVrjTjJXFpmbkCtD
 jwxREltZ
 lcEm1PrfKXJNceITo/4KG9qMxv85ZVDhWEojMzI31fwGagkkg4VfQzGRV2g2FdVnI7cbBsAqh/Go+z4O7jxnGYqYXPomKzYvRs9Im2wRRlN4WKpKZDL0OaLo0PejpOOoRzPUWuv+sA6B+LwJSc6Q+XfNYU2d8DSUHYk/gtzdF5BZDWNWr2G/jvVJehGS9VTA3NBd5j+nKpDAkNceo70GtKGL7eltZ90MyirM7xIE5lAzxwMBG+R41jKL+NKQoVX3dJ8T4l1DYzUpJi8RboVaIXgVhtXG0fmV1Utr8nZmuIPR50dTikBsZtDvZfqrXfQ+U2G0fakCCJtVeBmuBNv3q6ot8q/VBbc/mQizJ1+JCjF5VZC3d1oYtoUenfsJSkUGe4Egg4b9LlU3jagHQY1ddVZKN9J/scVJPTQ5N1yOnOk0mnxGUoJwRdInHQ8efIdvgWPHSfKGA9AK85Dg3rgQYRaD8LLpPyP2poRwn5pEKDpCHNeef/V5eb/2ZYTHablmjK2a6xjnuONdqZQd/daKX5no8ANgBvtG9SFgg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 02:35:57PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 03, 2025 at 10:59:00AM +0000, Kiryl Shutsemau wrote:
> > On Sat, Nov 01, 2025 at 05:00:47AM +0000, Matthew Wilcox wrote:
> > > On Wed, Oct 29, 2025 at 02:45:52AM -0700, Hugh Dickins wrote:
> > > > But you're giving yourself too hard a time of backporting with your
> > > > 5.10 Fixee 01c70267053d for 1/2: the only filesystem which set the
> > > > flag then was tmpfs, which you're now excepting.  The flag got
> > > > renamed later (in 5.16) and then in 5.17 at last there was another
> > > > filesystem to set it.  So, this 1/2 would be
> > > > 
> > > > Fixes: 6795801366da ("xfs: Support large folios")
> > > 
> > > I haven't been able to keep up with this patchset -- sorry.
> > > 
> > > But this problem didn't exist until bs>PS support was added because we
> > > would never add a folio to the page cache which extended beyond i_size
> > > before.  We'd shrink the folio order allocated in do_page_cache_ra()
> > > (actually, we still do, but page_cache_ra_unbounded() rounds it up
> > > again).  So it doesn't fix that commit at all, but something far more
> > > recent.
> > 
> > What about truncate path? We could allocate within i_size at first, then
> > truncate, if truncation failed to split the folio the mapping stays
> > beyond i_size.
> 
> Is it worth backporting all this way to solve this niche case?

Dave says it is correctness issue, so.. yes?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

