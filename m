Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F85C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6814B6B0089; Fri, 25 Jul 2025 15:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631B16B008A; Fri, 25 Jul 2025 15:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520E16B0092; Fri, 25 Jul 2025 15:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE3C6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:39:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AACA2C0928
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:39:57 +0000 (UTC)
X-FDA: 83703802434.06.8055A7B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf04.hostedemail.com (Postfix) with ESMTP id 101C040007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:39:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z3Nop6OW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753472396; a=rsa-sha256;
	cv=none;
	b=0SY7g0n9vLsqH+yNLfokJqzrxb/WrLQ2nsIPiXYhDhwtbxgOUGyWaPkF6Ey8cM+7DjD2mT
	X/ifnufB/sE+NX86u5gXRfPKApHSUJEGt15/Qt4BbNtRH4QTVWk588T3XgZ5iWy7inKd+O
	x+ORJlr/KvLB0plnbsJUtLswsE0R7EY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z3Nop6OW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753472396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLGlDYryathO607m++rOwKc5yWUqQUZkHpV1hRXUyO8=;
	b=dOUu0HCfed9pYe7QEWVwnrC5uGxhm7ngWagOoW70nmC9X8W6mw8/g4FHNLIOIRm6XDxZhN
	kXLcD1ax/4o5xv0mry3ZrWkj9fYmA3TO7NB4nvo+B/kF6MzAe7zQQW5IZuOsGVbMymeGdA
	mtjO6xFDWBFfrTZvvwb2dPqm/i0Libc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id E51C05C58E4;
	Fri, 25 Jul 2025 19:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2A4C4CEE7;
	Fri, 25 Jul 2025 19:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753472394;
	bh=uj/N/bSRAAtErIC/6xB/eoKkqvtlQGzcmsA0lQ53fm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3Nop6OWuWhO694lwWd7a6lOzCzOaXZBZWF6ohngBLzTTTTkL7HzywkhlVG5290+P
	 W82DK9Whc4fPHjcoG5v1Di2DkwS3SQWoIwgnhjwcRc8tvtzvDU1ecUbfXcNN67pgOk
	 EmsQvz4ZzHFor/lk3yHY8sdmt9sQt22AScs5B/i7aPXjNfcJ1eUFD3EjeRsneuZAZJ
	 uSUvApM1ESn6ccy767IQyN3h7RRmMpAeP+mrfmaTuMSnMkdDr8+T8p5MtuMK2TDWsb
	 hlrxdAUiEKz18a9rgl+1srekdNNm/WKjnTRHFib7MEnrRTVhmy7+YnSqZFQg6wY7xv
	 IMvK74uGofcfg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH] mm/damon/vaddr: Skip isolating folios already in destination nid
Date: Fri, 25 Jul 2025 12:39:52 -0700
Message-Id: <20250725193952.49563-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250725193637.49389-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 101C040007
X-Stat-Signature: d9mau71pr9cfgat86ztwqufyade66i6i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753472395-251342
X-HE-Meta: U2FsdGVkX1/JAZABn6Tg5718M2BLPUBw3eBKUN0EXUn3c9QGy6W7xKXDZOaB8ZYM9f3HaJnnFxPGvfL3LaWXgE43sDKccLKEnmtnch5QQGTH3p5s8CZnCbOS1mVBRLwpq5KNiNtIJBjlnrKIJLS+UZaGZiuHibbedCgBpD+6c63HAnvSqOofJCnnZ2+gksuPMR4xk+8iQGOgDofZnM/+Ys4VWGQ+xzwmrZ6TaJ6OQMYPDug5xzj3YPyWeopcOrHUtMaa80Q7T+ihXKpdYjAOn3FFvfgbMPl4bvLiu2fFQCDMgHAKGSMr0YpZIqy//YUemjQINHrAMtDNe7y2JQI0c/SRlu8P1F4Uk2ILx6rUTi1trPlv4xPlE7sxOnYhSST/PpNeGpKu6QSdws6FuUnthTQsv5AemA9JWylqd0APJgm+fUejuR1lJGHJJbkOEOWG62sHfdST6rmDz5C3mfGsDiXQhdPEB7HsNtiobMj1DyL8incw87X0BXaWFzze9fMWVAx9oWUPKD18+mK7cBtiCqQ3WZpDyl8JPLkvZCXliCstLFWeEbJx354aFO2H97SSLiSZQEpOYPTQPkQ6fgqfnAP/XWw4lLmtMt+0f1hC8AokHNgj2AcvYZ2MHIp4z3iU1v9jIashbb6g4JgSCcRk1CBzZNzpyi1fJPQ7U3L9AaglJkIGe36wXKF30y3R9fwQYpXbgDhUomUXkR7jc5Lc2mENMrcMyCwNtUhY3PyiITLW0VcReqlyK77OHBnl3f9USVKQafFOkdnR7SVjKIGp8qxNHduJxPfwkMyksNQYTJNIsL5s2MU84VhOqxm/EJ+uyN22BqJsqF/EfqkNxbP/64JTeA4xOqrbzvI3e3GA7JAnFKpEyBQ/XTR0TO9a+Kv0+RiNsxbL6yOUIIzzicRngcEuwz7hoxXVmVuu0/fybEzqM0DPzWXolJkXMb5RMCNGbLWolWR5D6Qw29FDcYU
 Ab3xWbp8
 Lq5qlvTwkXzDFbgWoLaua69geNKRDFZVJPlSq0igmebZ8gcTIh1wc+PfhWAyEk9uJN9KErdn8ApDTJ100GJg56MdrQbM1lKOiBOAQ57nBzzcN7ujSIE4F/S1wzHoHIR7GbGxAyaspeuUBzoWys9fUcjJc2PGcXzie2yzvgNGh2KqaMqEUFAcYFcOb2gpDXJM89XsA0kGQnQGZHMHEXRpMC+sst9Iu2IqpXavtLtL/gmJSUnROX5WxWF2J9nfHdfeq9Kl12Nv1CF0gR9DqL10w2dzBZPPfu/MUv7rODDBCYDLCjiIPkTNe4ISJTwpq3PXMIsNy3R7OExppfTAoxi6uc1nGVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Fri, 25 Jul 2025 12:36:37 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Fri, 25 Jul 2025 11:33:00 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:
> 
> > From: Bijan Tabatabai <bijantabatab@micron.com>
> > 
> > damos_va_migrate_dests_add() determines the node a folio should be in
> > based on the struct damos_migrate_dests associated with the migration
> > scheme and adds the folio to the linked list corresponding to that node
> > so it can be migrated later. Currently, folios are isolated and added to
> > the list even if they are already in the node they should be in.
> > 
> > In using damon weighted interleave more, I've found that the overhead of
> > needlessly adding these folios to the migration lists can be quite
> > high. The overhead comes from isolating folios and placing them in the
> > migration lists inside of damos_va_migrate_dests_add(), as well as the
> > cost of handling those folios in damon_migrate_pages(). This patch
> > eliminates that overhead by simply avoiding the addition of folios that
> > are already in their intended location to the migration list.
> [...]
> > Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> > ---
> > Sorry I missed this in the original patchset!
> 
> No worry!
> 
> Andrew, could we squash this into commit 19c1dc15c859 ("mm/damon/vaddr: use
> damos->migrate_dests in migrate_{hot,cold}") on mm-stable?  I think this is
> just a simple fixup.
> 
> > 
> >  mm/damon/vaddr.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index 7f5dc9c221a0..4404c2ab0583 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -711,6 +711,10 @@ static void damos_va_migrate_dests_add(struct folio *folio,
> >  		target -= dests->weight_arr[i];
> >  	}
> >  
> > +	/* If the folio is already in the right node, don't do anything */
> > +	if (folio_nid(folio) == dests->node_id_arr[i])
> > +		return;
> > +
> >  isolate:
> >  	if (!folio_isolate_lru(folio))
> >  		return;
> > -- 
> > 2.43.5
> 
> 
> Thanks,
> SJ
> 

