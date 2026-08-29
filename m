Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D6DCC61DBD
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CBE6B0088; Fri, 28 Aug 2026 21:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E5C6B008A; Fri, 28 Aug 2026 21:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433E06B008C; Fri, 28 Aug 2026 21:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20DDE6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:03:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D902A409B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:03:42 +0000 (UTC)
X-FDA: 85152509484.01.1EE5112
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 88739C0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:03:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eQwi8PNY;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787965420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFyln8QEmRs5uikiP3R7oCsripVvL4fOG8PYbkvVJso=;
	b=PxAzCbikGzTXs1lrMhJCzQbe0FVZNIf/CGl1kIGDFq0MMaAUkqvSyQ82EFtGT2dNQTg3GT
	5J5MlnnczYspL06iXOwpF/YYPAR/nm703j7hanEQ2EJS2hypkMzcLNRdDyd2/6O1YfWBoz
	CDf3vxnKwbPQ4ZVolkVvHish+nA7frU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787965420;
	b=2PJ1ro4VjpS/fHTurEU+zsU4ch2Dycx99i5GLAaUWj0QdKEWc8zS1p6HB60yahHKt7D3ZP
	icpBvacMS44mcwlhbucB+J8dYtaZOFSc+aczjYnOaSRo7I1gVeMZVCanawY28fyw69MDce
	g56U7v4FVkBaWhat4fVfWtHGqwSfSmI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eQwi8PNY;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8ED916053D;
	Sat, 29 Aug 2026 01:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E994D1F000E9;
	Sat, 29 Aug 2026 01:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787965419;
	bh=lFyln8QEmRs5uikiP3R7oCsripVvL4fOG8PYbkvVJso=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eQwi8PNYwht4MHbQ1LuAdmHY+ZwV2eJWmjfwdMsNOuFIEYnKT/CABsi1AMO5LQsl4
	 wH87a3S9v/spu2LY+5iXkE8GuZLou2B7oj8Ih43AWNHKHSUU9luXorPmcYtAt681+C
	 1zYsnMkBG9SwtSqkQ1DvTIvEqSHmgpVL7PwpjPcE=
Date: Fri, 28 Aug 2026 18:03:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, chrisl@kernel.org,
 kasong@tencent.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm, swap: Fix potential NULL dereference when
 trying a sleep table allocation
Message-Id: <20260828180338.0e62379137b832bd66d48b7d@linux-foundation.org>
In-Reply-To: <ao_ybL9yRO_pHphW@KASONG-MC4>
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
	<20260820115505.20027-2-shikemeng@huaweicloud.com>
	<ao_ybL9yRO_pHphW@KASONG-MC4>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88739C0004
X-Stat-Signature: m7fbq96qbfow379thsheh1m9un3gj9zk
X-Rspam-User: 
X-HE-Tag: 1787965420-609826
X-HE-Meta: U2FsdGVkX18QuqcPtIWpiftUz9TIyHOv3mw3tLLsoieIU/4G9qqgtQ4xPW4icxoJndbtuGtbwahenBXdMzn6yv9kx20lZ0Uo68ErhobgnpJcH/pf+Zq1WgycF+98C7cAClzDp9r/DGmExhA9a0oWA4gzUandGTIpFpHlc7F+y4YT73bGzazwSsk2KWYrrPteK4uIfhY9JFTjBmwJbsS0COqX5XZ8zsfJoOAiY1A0DSm1L182ymfMwkybhav3SYIEKHOxRTywa95laa6hKw7iJA4Jg+XcaNmv7TclpE+b/LmTav6PVBiMwAjuyLaAWxyVER/uazQLW6W8sUPg9YGFnlIAcwGYvYIghH39wrhBelNpjy2X7Yu+uXBeM1y+t0FcBkLvynD67HqF3JKq+anjLcRMvjAqtHaILCRhzL3WyPLncVp0iah7LOuNi2Lt4eSsYgzot/MN6WzW7GYrBJE5NQmYgifTQMhLRaF+/XsjkaLp1gnFQvbw3UZW3kSDNkz8IefSlcabrEztsLoi3pfcRAN4D2ipof5JlosJMlzdzX5fsQcz1TyP83CvIgu1cj+ySInSOQfMtS3AqLsWnMysYyIs4XZmuA1lk562KoiMW3ckiOmZ2O4H1C3hH7kz6raf0ad8E1aVlzyWGCLZ75ibU7lT7YgdtNlQ4L9oiA7TUkdI3yv041ZCRMQ9xdzkRK8a0Uom3OWX8wh55CWs5Rt0WS1V/N3+e47MBoMdOZdGADdRJk130raj9hzdYU2I7Hm0GV7Q+wT8nStQjx4o/1IlbSVxwQybI0A6r2bAIBkKBicVe6gzAlV0/G34/uTGugsd8+jyoMgMsX2Z2macJRMnZ2BUGFpvdTwMURcMZbJg6Nk6dwY2iPMtXxiKAy6IjFN5lmGxSB/ZPQO94edwv1uNasl/nH57WYQTSAPyEMcIZfzmXKnGHIHpfBQXf6FMNyafGtnOEvIIJIgFG3qAwQm
 E9G6QbIU
 hKVF//tCq/LwFEquF9ZNkkx9jVAAmVHXEYhYMDUIqvFfucmIlgNO3QOdLlBSD5zFLPaFNKTpP/OZHUFJlebT77P8ZCfOR22O1U/7pDo/XfYfbfQuJnwHDxTjZEu64/wON9m9pt6zQX0K5nm9MtLefTYEAU9MLGj/G03DHSll9SykRpL23YxpNx7rjX1OoQIDzpCq/Y6e7nL/u3PcXJpscZt4v+HiVC9S2Y2OsrGiyNvbileLlT8nQaGYxEGrJTMdHhzfbVA2UbIWm4ozQCYz2zcdCQ6yBH1AxZSKgkMwOJ80zgXrjbf14IgYXvPJ2X61BBVjIiNz9TFSgS1TQyNP5pXAjKXlFKEhoq6Z5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 17:10:54 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -466,8 +466,6 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
> >  	if (!table)
> >  		return -ENOMEM;
> >  
> > -	rcu_assign_pointer(ci->table, table);
> > -
> >  #ifdef CONFIG_MEMCG
> >  	if (!mem_cgroup_disabled()) {
> >  		VM_WARN_ON_ONCE(ci->memcg_table);
> > @@ -487,6 +485,12 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
> >  		return -ENOMEM;
> >  	}
> >  #endif
> > +
> > +	/*
> > +	 * Make tables visible to cluster_is_usable() after everything is
> > +	 * ready.
> > +	 */
> > +	rcu_assign_pointer(ci->table, table);
> 
> Hmm, but for the error paths above, they will leak the new allocated table?

Sashiko thinks so ;)

It also might have found a pre-existing data-race which seems
sufficiently on-topic for this patchset?

	https://sashiko.dev/#/patchset/20260820115505.20027-1-shikemeng@huaweicloud.com

