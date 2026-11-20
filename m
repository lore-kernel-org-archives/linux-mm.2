Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E7E606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YmdsWDPS
Received: by kanga.kvack.org (Postfix)
	id 9BE9C6B05B1; Fri, 20 Nov 2026 12:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FF76B05B2; Fri, 20 Nov 2026 12:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861276B05B3; Fri, 20 Nov 2026 12:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E01E6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:39:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB2F6C0135
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:39:22 +0000 (UTC)
X-FDA: 85456208964.27.0F9B150
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5670040004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:39:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YmdsWDPS;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of BATV+de1156368b985c5aa289+8489+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+de1156368b985c5aa289+8489+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795196361;
	b=eMYCWKQg7DCYa7hyOTBDmho6p5mLj/xozPbTWinmgWMYULHYYtl/a4cx4Z+Cr3xTm2sI43
	7w6IX6srEebn1kVE67r8Se+9h8vAU2RYvCES6qiDf9wJU53ebce5A7z8f6rKJ0SWgOdzgM
	Wb2ZO6nt4963wUAFVxs7dfJMuG7RgXk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795196361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFeXigSPHuPYCYu3NW90s99hrfhUDEc9Wq95RVe4MLc=;
	b=FfkyaQMjfRKYIF0a85hJ7UzWkezLxw0uYPkWq+xAuJQ4l6zNuOeO6wjB3+bAYKyR4jMx5/
	gql1LzOOnxiOUclxZgkbiC9LfRPzpYUd2xk0vU7ow6qIzwk8iDaaOp26R7HyEp/VFYHI1J
	UtOPxNNkHswnxfIYdvKzS1HlXoXZQ1M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YmdsWDPS;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of BATV+de1156368b985c5aa289+8489+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+de1156368b985c5aa289+8489+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zFeXigSPHuPYCYu3NW90s99hrfhUDEc9Wq95RVe4MLc=; b=YmdsWDPSbQ/nrh388OQixpRbGu
	8q6rxrtdzP3EhpW9ey0Ljheu+QAVgtPc4qMRqrETgZ+gn6sP7cq20mYXwOqzFFoU3CfjfoMBvbQTP
	GnPbrxLY6QmwDoE3AFmkRQnF/Ml8gq3EaAU3K5Z2NxWfun3Ka8+MbPTjVB4hFGIBhflewJ8IMdGex
	V1AxHXeR4nwtsc1PqzSEfUHoNwotp2T121ayw/7rexRDi/j8FWVVbq2tDx28i3yeyJP6biY9IYGfF
	TofvKsC7OoBvMm8OZ23BEVfzWPwYBYLNnHfjf9FwrWMPx7yH8JgGmgROWTMphL8QD3kzZgaA1kcR0
	jbfodbhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUSZi-0000000FjqO-3Oxe;
	Fri, 20 Nov 2026 17:39:06 +0000
Date: Fri, 20 Nov 2026 09:39:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <awCFtlgTeUFaqBS-@infradead.org>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5670040004
X-Stat-Signature: 7mjji7yrry5j4rzseayc7xeazc4g3b65
X-HE-Tag: 1795196360-450612
X-HE-Meta: U2FsdGVkX1+VgYAegvUjPUm9l8iZh5h3E6NbZgkWJl+m9nkAT+FIhTcfQCvV/YWMkeo5NV6De0qb3pKaJs9XjtQN3hLv4mNzWwpf5ULiEutKLgKcGAyFo0tulQkUaylwsGEI7Za4LvddsQg2bqFJFZybTp9C0Nva/0BUzSzYLBeCUV3I1FWUsI4YXZfCBioJt/QAXeE8OwA0e4vY93PWEAf1b0jxWu5OG+dtLIn1H5xrGLQYijejF/ewFqJZbCc9RJwsPSfim966MfM2AOxx8/sCd16LLUh01VBwOUcJS5GYR49if7VfFcUrtLtkhUYoTK/b/sKoXDBTbS5MDL7TeWwYQnDY1kPTAQQnEkjsoSMlysbXg8ecghGw/BFFtjBnNg/qoBw+I/fPsLVpaNmXzKQZ7II3zplxps1gwHSfFuyqeROfyOWDS5rjsl8kdQwpO7jXYA3QIwlwhYBgVyuiXpCAEWRYAjhtlFRp9+Wg0RP2Kxcwsk4o9o3UbMN2EkSG1cR5oyLsQKgS7dSIGMwtlrjqzBb5LYSXrkoMiM3Ov+QvYuYoL11xLpu/yaNOrRYVkCUH3FW0MV7WMuOzC1Oy3ObB93CimpCIGEVdOu3B3hrw9Vm3cWlp14a6cbRQnDqSPqSptqK98glyEbvQ8AyOLmpYGw2VDPkpnSlhiwWZGiFjIi9+et5HY7e69Af0Zv2Reiyvj6WEHdf+AzUJp4hIpVQYMh8jEo1qa5YgYss3R7pnO/eHFeB7u23Yfe4q6C32twhV05tEt41DPk8sXHFNELAgl69/6l5HlBX47U9T8dZp1w+Nb1dyJYGFi5Olt0l7rF38SurA2rZAxh5ZhtxzgakED29BV49exh5trbcuPU3S79r6ryjHXbkNiCNWCurIhDhrnaThu5RpCRS6lA3ZvCmt1VheB3gWO4mA63uoB5CAnDs3rm935Oo0uf28bNdLtKHQC0ipd6PofEg73Zm
 0WjKNKw1
 W1OjZeS6iQN0FOMdCD86jV/3+n4T9a8aB9kkZYpItPjkkxMw6QDkq2biQDnvvNVaqUsicQXls+Bl2Fcshy7XPzudtOs51M+venTeRuf3jVh7fE0jZ8h29q3pOKHavJj5BAIcofaewm36sZGk1vmo5/YU2ukpAw7NbMPRa7VkmxDP6te1yObNM0OuNIikV4reRWSi3wmh1PiNkuHoKe6c8jWfNoS3Ax9/rOUF3ODWPMCBVK3gYVvAZyIKbQOqvBuUbgglOxrvSpWQwo+GyT2h375ju+cVl50vfj02/PtxkdSJqvadMGUutMPqGO+Ret5A+HanAAoYdXVbODpdwj48/Cgzb+kGme5VF0CNaEFo3xJUpFBmbEBcvDMWGnKcAuXh1ud/E6asyUu0/54fnAjl4+zfxoOQ/KfNnEh6Zy4nnAIYmNjQtUG78dRCn9fPIx0ijq6Q7tMKyJiZaf9mBmHW9IMoGgU+W8G8j/M6gFiA9Uq/6bnQwRRru07BfJEG1obivPA88l5ohKNjzmfoWgOwxonPyBPVTSOHVCBgSzDTExXaC5MRHyka29jEuls5wVDzPZ1JTliWjh0QpWmhLwIXjQgNhyyTfBuLrefhJUwSvl12/0mvXhFjXU8HKNXhqEveDdkcn4YMZqyPFbuASfgRK2Ut55t2HQRnagHaHpJ9G0ike7DUarOqXlNBRiZ5jVi9YuJII+WeyqmvNndSwn+KhP3YftYVHhDnPWqXoKPpHiOuaevS2uWywgPX+uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 08:10:43PM +0000, Pedro Falcato wrote:
>  - there is no problem in usual IO submission, but issues start to pop
>    up with GUP, where the code flow (roughly) becomes:
>         [get_user_pages(), etc]
>            ->page_mkwrite() called here, or before
>              ->private correctly populated with whatever the filesystem
>                expects.
>              folio is marked as dirty, initially.
>        *write finishes*
>        folio_lock();
>        folio_mark_dirty();
>          ->dirty_folio()
>               dirty_folio expects ->private to be populated by
>               ->page_mkwrite(), ->write_begin().
>        folio_unlock();

Writes through GUP are known broken in this an in other ways.  The
fix is not to create band aids, but to phase out the remaining
writers through GUP.  Which is really long overdue, and I'm starting
to get really pissed at the maintainers not fixing that after years
of knowing the bugs and having the infrastructure to fix it.


