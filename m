Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B4FC624D5
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7936A6B0092; Tue,  1 Sep 2026 20:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D316B0096; Tue,  1 Sep 2026 20:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E46E6B0099; Tue,  1 Sep 2026 20:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5C06B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:16:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A766C14058A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:16:21 +0000 (UTC)
X-FDA: 85166905362.24.14692F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 087EE1A000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:16:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pc+Ax/jZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788308180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEjxeO79o4Ud75N6A9+NJyFbf3L9Zkn9+XJuWOGF7QE=;
	b=dDNwZ9DszxOgxTYVqj6siuOznWXFRkFlBDdK7wBK1fnr3hsufYhlb67xqMjKtpFnKaBZg9
	nwpbB0wcM6qJ1qMU7juv/RXNAIR42pEQmJzh9H/gImbPWcydYeOmTatIuk5m6yFsA2III1
	3KX2QRxb9imTSb7+bKAcRRzuk4pidNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788308180;
	b=DHYWKH8mDeaFAvHPWvBYAlQOh1DS4SDkmRx2KJEkahvOgbbVfZ+enPXfG29Ay2YqADoOTU
	1zvYWg7d4raFKwrPtxcQqp7XgzcbGsa6QrTDqzdZdnD+te/d3KYXefrFg+9AWlnepPcJdy
	oGo0B/paxDm3c5t5cf1HUntDJN2hvb4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pc+Ax/jZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36B3643E29;
	Wed,  2 Sep 2026 00:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C3F1F000E9;
	Wed,  2 Sep 2026 00:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788308179;
	bh=OEjxeO79o4Ud75N6A9+NJyFbf3L9Zkn9+XJuWOGF7QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pc+Ax/jZ1ieQp/xsoeg17BqRC4BVaZJW84zbu27ePugyNmeFZqHKm6UQEAUDvrSn1
	 S+tcaHGDW2c7FbIT5snJKz8hR77BFFZMe29di0HS/431XrSXbvVwRRq2A/W4gZ3G/t
	 ba5BEHIpE+quFK5HU12YBN59UoCwppdNeaXMQsdOodQq3sdfXT2w9VNXkn8GVw34Yu
	 MjJexwlAlFAE3a4BbFSGjKFI4/X6gn98Ne7A/m6IQZbz3R/i3FjB31QrD4noVXrUQl
	 Xbt9MP5+0Xpan5/gqs4xEoZwPz+WPlMt5ZzQsSBEzSJqhJ0nOV+jlbZsXkt2a37A16
	 1yqzhzq7vGygg==
From: SJ Park <sj@kernel.org>
To: Nathan Gao <zcgao@amazon.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v2] mm/damon/vaddr: use a page-aligned address for the sampling walks
Date: Tue,  1 Sep 2026 17:16:06 -0700
Message-ID: <20260902001607.107382-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901202556.39515-1-zcgao@amazon.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 087EE1A000D
X-Stat-Signature: h8ije8dye57tjpmgtfg7x79hrte8ogbi
X-Rspam-User: 
X-HE-Tag: 1788308179-282851
X-HE-Meta: U2FsdGVkX1/jS0ZxDDmP0sEytg/uTNcxiAUMHfk4YV+uVtT0/CB/2xh4BFjtzubZu8NL1MFKOfH/OfEJwxVLyteCg0CJAjNua6cp2M7N0BmJeM6gtnYf+NXYP3YNCxI1BnzZ9xJbDlAy1aVXqp4AIQd4cPkDiDL9coSK3rTL7wyhWyus6ScAI/GlWUel41ZmT9Qv1KpI+7kaEJpuvNNPNDoHJfZ++yj4lZWOqJRvt4ULvsW4TIBVLcCOpEHUsLN8bfWnBCTO/MppJZYCrlYwTgRt/X6o4LxJesVC0Ean7t0lm/h69czAAfz6wAodbSoC5ud6KIWh81bOnpu3ZCy24MNxmgJvMnJQwIQSjIO1eLClvqAuh4rg5v8rhm0AH0M7kZmW9DSsolv1mKZz/C2+K0oqzAQqHPb/Cladhw4KzAvw230zG7smarr1aQ0jS7JJCG2rzDsNftf36qFQHp2bBdeAh9UntrjJfLhwRRR+kdeZYvDZ9nTaYCdXnUcFU0uKrphcinoTJKspjzQOefYa7nyRYn+P1xsX9Hlstw82qBlqdlxWuyIsQWyYsbEc63H3KbLu4tck62zO/eJjMbZu7QjetHBiopjQgf2ASvdOyEvKuN7eFTjZt7xq1/FU7MYePKlrGvEuQGzT7voCnKwrVGsOlQ3SK8Y6FMWTpgs7pu6uNX35aw5rrCPvoiRbNHwyK+1ItzfLLybFvI5wqD+yS9BBGh6D2RvBZ0AY/p5TPcP8sqabj+eOqHqsz8vruXfPWwWgTbyqw/hMoU0OQlPblkfbdyyPD9JcgxdtRck6MleogVaZNUCaTnNDCY0O2Qr33s/yPpAWG+ohWKE8/N0Y1MedjiRUcn6OIjEf3f/vGOGbDXukD+gcyWtuOQQFqsNeUlcduGy0Dg1fwYo/3Q1qIEV9e1NsXbuH8weNu+gSPeqmfR+HK8NCfkTgA+h1SFDCULn7ZpreKLJwa6QozGg
 +ROYOVRY
 xLr5jsC3ROvAwlYk06LaeiMwk/CJH+FhoEsxvXjnMVQwhDJL5oQIluLyE4VkOc/Z2AuZxd+t8teSmhFVpUiXPZwSPTpq1wk17+qu0os/+og9vGWQhnXi8S9/fV+fLO2OmNyJ6YTdGVXCqXCvuBculzMvCKlXyn6XEQCuc5BGhISshqp1Zjqn8baPcT3ZKi1vXX3FSa8/FL6l6/EarpjGj7ISH7l9cZvyNdNZMZLKNgbf5au9B9ZVuCg6JrR0qoKPcDcMq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026 13:25:36 -0700 Nathan Gao <zcgao@amazon.com> wrote:

> On Mon, 31 Aug 2026 18:35:50 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Mon, 31 Aug 2026 15:11:51 -0700 Nathan Gao <zcgao@amazon.com> wrote:
[...]
> > > 
> > > Otherwise the page is writable, the PTE_AF clearing succeeds silently
> > > and the damage only surfaces later, in whatever happened to own the
> > > page, so the backtrace is unrelated to DAMON and differs between runs.
> > 
> > Urgh, this must have been a painful debugging.  Sorry about that, and
> > appreciate your great work on this!
> > 
> 
> No problem at all!  Had fun digging into this. 

Thank you for that kind ack!

> 
> > > 
> > > Align the address down to a page boundary in damon_va_mkold() and
> > > damon_va_young(), the two users that pass it into a page table walk. It
> > > is the address of the page to sample, so this matches its intended
> > > meaning. r->sampling_addr itself is left as is, so the sampling and
> > > region bookkeeping semantics are unchanged.
> > 
> > I'm still wondering if it makes sense to restore unaligned address support in
> > contpte_test_and_clear_young_ptes() as a long term fix.
> > 
> 
> I'd appreciate Baolin's thoughts here.  If it turns out callers are
> expected to do the alignment, it would be better to have a WARN to expose
> the issue.

I agree.  If we conclude contpte helpers are not the right place to warn, we
should do that at least in DAMON internal helpers.

[...]
> > > --- a/mm/damon/vaddr.c
> > > +++ b/mm/damon/vaddr.c
> > > @@ -349,6 +349,9 @@ static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
> > >  		.hugetlb_entry = damon_mkold_hugetlb_entry,
> > >  	};
> > >  
> > > +	/* Arch helpers can derive a page range from @addr; align it down. */
> > > +	addr = PAGE_ALIGN_DOWN(addr);
> > > +
> > >  	damon_va_walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
> > 
> > Could we do the alignment just before passing the addr to
> > contpte_test_and_clear_young_ptes(), which is the exact function that disallows
> > the unaligned address?
> > 
> 
> Sent a v3.  It moves the alignment into damon_ptep_mkold(), the only place
> in DAMON that reaches contpte_test_and_clear_young_ptes(), so it is as
> close to that function as DAMON can get:
> 
> https://lore.kernel.org/all/20260901201001.33271-1-zcgao@amazon.com/

Thank you, I left comments.  Please forgive me being picky there.


Thanks,
SJ

[...]

