Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89B2C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65616B0095; Fri, 11 Sep 2026 09:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0266B0096; Fri, 11 Sep 2026 09:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5CE6B0098; Fri, 11 Sep 2026 09:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B241D6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:32:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 594581A026C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:32:42 +0000 (UTC)
X-FDA: 85201571364.20.9B8F8F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B02DD1A000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:32:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fi7eT0Tk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789133560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4cjZyg9TwtoYS0w3Uy/aHxv7zEHGwy0d+Cmi9Q21fg=;
	b=N1u2WFpunDkqiBbkE1lh42nUhdfkBkY1GKxLk9V01401gXu5xxPGnsnHNF8Dk4S9xhv9D3
	ARmf0inx4YSLV8Fj1J6KXZYErcP4dS2uyorSL4CkDnuubQYIGWh/dImj0HRvI4tHcxQJwC
	VM4xrhMaU3+Go967ZYVumWy2OUBo2RM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789133560;
	b=HZzpeP4vtLVUAT2NudwxlpDAOLiRcd/QCKJr7rHX17JnIF7SoYPcJFmPx6leMmxlYSSsCj
	dzm3NRRzov9AzzOihpolfLHmpWaqSwxc/KgGYokz+UIbBHMl4QK1pAYzhzVtcEglUdqED5
	rFUislHAnvoRjpwwaipLiD0220GDSoo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fi7eT0Tk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96EF441A91;
	Fri, 11 Sep 2026 13:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0081F000FF;
	Fri, 11 Sep 2026 13:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789133559;
	bh=N4cjZyg9TwtoYS0w3Uy/aHxv7zEHGwy0d+Cmi9Q21fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fi7eT0TkQmppnxyAyCkikpwfZbm5O2/Wc0O4B/TIREOKCFn/Xltpt7fQgsfD4/4th
	 b07wACychsuviIbE+qwjxQzwfu82D10HimieReg+VHnUeWDv8pg/+tE1MufglZgstR
	 IkczmtJVwza2MIbD/Y2A4YEKuL2Egssl1RiQg631laq+B4WCzXVMAxreGnpMTv5gFN
	 KLyJjtkRU7MzlZckZtXiW2yRE/JAqIp49p2qniT//EAyY/T2ts5R+sQC994QdQFOhr
	 mYoQrBZCHa6x5nTW3tb6K3RXLkC5LXD6EoiWwhPC/Zi+/CUR3rQ1UvFOmcPED3v7DV
	 xnQHvcY+e2pZA==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 5/5] mm/damon/vaddr: support pgidle_unset probe filter type
Date: Fri, 11 Sep 2026 06:32:31 -0700
Message-ID: <20260911133232.91581-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911100427.2804601-1-kunwu.chan@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B02DD1A000B
X-Stat-Signature: jmuxs11gf95cm6qnuhb9kyh8yrwjxd81
X-HE-Tag: 1789133560-755297
X-HE-Meta: U2FsdGVkX1+iPG+VqyFzc2jhmGzC6ECt73YOjlACpCFi83ANZ3kPYguxyq8dQTSUyaAlE+Wp5Y2gLyB0xFJEPNQjv/BirTkfElWuWcRC+nPfqTbfMGA3z28dR6CnEwFzMhNtGl9w3MkQD2SDk1a1JzV3mrNw2IblFkElaWTB25+qrCj2UMXOy1IJgOSiWB9hf4qJnzj2RbsXfZ6lwkHScoWlUNABBsLBMEBfE6PPq+gyjBGwoUfu68ZTFWpdCSkqPnxASwlUn8usNyxIHIOpTF6FKoHCWf6MsgsqOc3YHppn+Qdp2Eipm8e6gHTCL2ulfFPeWOfk4iJDkujXOT7IB9JTd03W/lpKJWuvn1Mki88XSwi5jVc9E9+QlHKUQkNsu3lp1n7iUNmkQn0O4uoc+BkkpYEFnbdP2CmR/uwXLqMfRh3fcdu+XAiJ9s3wvK9jevdfHe7fbgf+RiAhUOjWBj4vozqSnaBNY0TlMp/KT4tLdIJG7ZXiSYlpmNPAzB5dqPllkhvUd4y8oW//BeozZVHMJxOwW5N/L2V+1Sz0JaqkyfQ8Q+Nd/N68QuGXHhxkiuG7I2tmZtgBA1L/VhlLQvhluGWPWl2B6nrsdjAN4HjoqEnfi0p/3wcwZ4Rw6gomsirqn8ywK/cHy/UELcWKnKqNxYRUDJrXTddOJ87hA9kjdGdMNqhzRgk4eiyFw40XOmmwSLev5S7EcswHACsIGRyzWsKmcuxt6SzcA3KhPuK/vzOS2mrawSt08v0MewkUaMvoqv69ceXNMEpAX1FPA9uy9Q5h7fpH5Fn82XGyK2DzVpIdYtlMfxbAWrSBb1nhe9KnAyPzLPmsMUmtPeLah54ko0gTn6BtZiozLEkhOKeWvu0j3l3hytqPQfvHEWHZ9OCFpkWR5HWGCKrXiw9bUbXx7QlHstOo5pxF0yJ//e0CF+Af7m618be9l3Oj+IBeagCkzJ9Q4tOFIcVFo9L
 3XVza9Va
 UGGfPzFYvhDABdWFxko9npusWAPmb39SsgGvmQ86vDubs702QPJZrb9Rqr2R+zuFp7hn+PiZLV6pURrOQMVPhXl5uZMoP7ovidJicUGom6lFOgBsrV04xHqfyEAbwLNafGTebBJlE7S6LQr/APYfEFYzvoLXI41vpER5dp+otI376IshIyqnXPQYLpn8xZEMdLniYIZEUKjwtpo6AB/UxnL9KJFDfK0e7d/BzX0vJLM6UrLfYxssgGCmd8+ITnKFC5WNR5DfO9BRW+JNTI4GHu1AzTTcooYt/w+ko0L/Ly4lxQYDPwzqsjdOVxS0h9Mnj7DrY8+uq86TVHX5Z87+1XAJs16lHrA1JTlU5n/v+IcniNn/kJo2QdSHGZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kunwu,

On Fri, 11 Sep 2026 18:04:26 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> On Wed,  9 Sep 2026 07:04:07 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > DAMON virtual address space operation set (vaddr) does not support
> > pgidle_unset probe filter type.  Add the support.
> > 
> > Signed-off-by: SJ Park <sj@kernel.org>
> > ---
> >  mm/damon/vaddr.c | 55 ++++++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 48 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index 45239f05e113b..9a38dc89a156e 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -522,13 +522,49 @@ static void damon_va_prep_probes(struct damon_ctx *ctx, bool set_samples)
> >  	}
> >  }
> >  
> > -static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p)
> > +static bool damon_va_young_addr(struct folio *folio, pte_t *pte, pmd_t *pmd,
> > +		struct mm_struct *mm, unsigned long addr)
> > +{
> > +	bool young = false;
> > +
> > +	if (pte)
> > +		young = pte_young(*pte);
> > +	else if (pmd)
> > +		young = pmd_young(*pmd);
> 
> Hi SJ,
> I see that all callers already check pte_present() / pmd_present()
> before calling this helper, so I don't see a correctness issue here.
> 
> However, the other DAMON young/accessed helpers, such as
> damon_pte_young(), damon_hugetlb_young(), and the PMD path in
> damon_folio_young_one(), keep the present check together with the
> young check.
> 
> Would it make sense to keep the same check here for consistency?

In my humble opinion, it is already consistent as long as we didn't miss
present check in callers.  If you concern a case that we call
damon_va_young_addr() without present check in future, how about adding a
comment noting that on damon_va_young_addr() as a followup work?

Also, thank you for your reviews to this series!


Thanks,
SJ

[...]

