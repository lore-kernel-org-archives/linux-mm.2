Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E935CA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 02:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE346B008A; Mon, 12 Oct 2026 22:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADF06B008C; Mon, 12 Oct 2026 22:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA3A6B0092; Mon, 12 Oct 2026 22:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00EB56B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:28:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61661160A99
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:28:38 +0000 (UTC)
X-FDA: 85316019516.22.7C85B12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA8021C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:28:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vpmcDywG;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791858516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKylga81/fMMmRtBFAQ1W3QCN8phgvUppb+ffP3/CaI=;
	b=NHyPnd72UYKBZualgujqIhm4gQciC578+xri6mEL9draA1jkBeXcOzwvVb6ERL4bgYFA/u
	LHaD0rkWpnEdTry8iAZp/bfOBOPCxT/dlKkqvlrMyGhV+ET2Ut6KNoyPQBaN7trG3fn6hX
	rx24/dDcjKcoRqi91pExPdwazcohahg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vpmcDywG;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791858516;
	b=xEiCTn7/Q3So/l5FJvHfXybcZvIhDzgQONb2Ztxw0bWJ0t6pQqrMWOpvJfeOkQ3KpmOvsL
	wVirLV7Z6ooz80ARR1Qaa+fbJevGfGybSsuapmweuXd28JtULmQa13FXkjUvpkjBcNXJq8
	vxhjAApYReiefBCPqDu1ZbMOZ3a4JWU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BD1640A40;
	Tue, 13 Oct 2026 02:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11621F000FF;
	Tue, 13 Oct 2026 02:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791858515;
	bh=jKylga81/fMMmRtBFAQ1W3QCN8phgvUppb+ffP3/CaI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vpmcDywGR/O5t9GrEkNC7RsvhGFadRRn0/HR5Y4LXy2Oli02WCbqfwLqIHjmDRqLN
	 ozTD6JRQymveRi7jcSxPFOT/Lv1n2pVbfJ1bgCai5zrluhRhkjnVzyK2ux61pxrbUS
	 eNMy3agw/9ZuOjgougzj4G1533G7Ky7wTZit7HI0=
Date: Mon, 12 Oct 2026 19:28:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Harry Yoo
 <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-Id: <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
In-Reply-To: <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
References: <20261009125503.126202-1-kas@kernel.org>
	<15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA8021C0004
X-Rspam-User: 
X-Stat-Signature: dojnbr8u5kbbykz589arq91wjkr1opug
X-HE-Tag: 1791858516-72041
X-HE-Meta: U2FsdGVkX19lcfbwUA9MF7Wb0RDT2MAs6rqbUu3IyzXiYm+pqiYxw/2Ngno9ZuxnEm2LWvsR7WjaLLwklskrGFHrAb7Ek4bav254AmGGkHxaA5SDlCUL/kB1+1dfx8iHSNoua1xA6n2/gagK7hn5Dj8edfkMT4sK4S1/PIIEsbx49dLQvCmOrkRCf5EUmwuTDeZ3rreXtCIvHBnvkDDgwKgmiDjm7d2W0N4ZTq/r+vhe9eqIGq2UkqSvvg3v+NmXF0h3TA6aVk098KxDwcr6KG5/3+cFQrkopXlWEXIRD9JVdJZw8BU+Yi8SmMppLgZqyBOvI56i80rrzJCcTOdwVszYyKoN6WTPsjt7FgZb1Tvzm2CD28U99tyJ/MB1gaFUdXDZXHeG7YTkGAOikuxv22cCe5XkYrQxjH34h9VdJiP5nD2GTGNuBrgFNeXaCdrFmCnB04Z7ZhnvGtRAvsFLal+xZKzGCxSqPvOB3GDD/mBkf4rUK8H6FKi2GAxyjow3yf53GjF1AAIEf2cje645PyQp3dSb7QDHTpymA1WPD07nfDt+817v4uVj4AqGmbqKv/aTZ18HZKdLVZdNaXpN1ChPSkL05IYzc+0QcIIUx/c4t1uU0LGD0uCU1oaxYs8FQX+8Tg1WDJA8Gfqkg9o0tUPCiKKggVyuIKexQ6g4cvLc+zKSKrNekvjBbsJoRzJAC2acYE4BOhJlkOiN1chhQMFVFK2mFfom/ggb/LqANMpeJXFDMej69TjgopHNEiqGl52nPRHWbsrZ+ZxELWIUnCw8NEZDaxg6lj3/pOur8AXGB0sPWSBLw03ZN4uiANsachsD79MOLW5KwcYKmAJGS6PFUdZZm9CfaKaDJNhUR9uh7XyOokcaeENy871zw69L/OH3IAppSuu8v3WsrgXlzFhtJ43pjUYT3THHkd/7kWPZIKG17x8yBgcN5vobDJ4ILK7LbVW7+kVgr4d7MN6
 O3m4bvVJ
 qPgwGC1VfeEh9xcMu38sTULFfnKnMHu9TU54VMf9qzu8LvPRbEYHFaBd2b52p1nYO3lVqC49KYmwKsobmMBSS0ciHtj+6sX4D/i/k2pkOXqe4pAL6J9jIJkIaVVwG1ylNQEohz8Xf+vtk1XyhzKZmYThHkxP9DJjv8Q90RYfxLnrud1opGYBHhZzmfuJKkjn9/v+XVWiX5/uRydncw9q90v3D6M51T0gu7mPI8htyRb0P7Rhyw+5S6DrPRjaslCu8+KAM/DoPvCF9aIABth/8n5+MGS30aOV3+HQFAf7jcIXuAOy1WP0xlTiCcf/SDzjt471c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Oct 2026 13:40:36 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> > In a VM reproducer (32G, defrag_mode, inode churn under memory.low):
> > 
> >                                         before    after
> >     should_reclaim_retry() calls           63M     293k
> >     peak memory pressure (PSI some avg10)  99%      12%
> > 
> > File creation runs 5.7x faster.
> > 
> > Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
> > Cc: stable@vger.kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 
> LGTM, but I think we could simplify and get rid of all the function
> parameter additions by adding a field to alloc_context instead? We could
> call it e.g. reclaim_compact_order.
> 
> The function nofrag_promote_order() probably doesn't need to exist, given it
> has just one caller, could be just open coded.
> 
> What could be useful instead is wrapper for comparing order vs
> ac->reclaim_compact_order. E.g. something like bool
> order_nofrag_promoted(order, ac) ?

I'm concerned about the sheer size of this patch.  It fixes significant
issues, but it's not going to be a simple or safe backport.

So for now please let's optimize for simplicity and backportability and
defer cleanups for the -rc cycle.

Of course, if the changes you suggest achieve that then go for it.

Perhaps we should defer this change into next -rc?  It has cc:stable so
it'll eventually end up where we want it.

