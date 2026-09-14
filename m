Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510F5C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 18:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624426B0095; Mon, 14 Sep 2026 14:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D48C6B0096; Mon, 14 Sep 2026 14:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAA56B0098; Mon, 14 Sep 2026 14:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DCAD6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:19:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85CA6120213
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:19:43 +0000 (UTC)
X-FDA: 85213181046.30.457FBD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B42AB40008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:19:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1AbA6KGu;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789409981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsN3qekiQiOy09Vr8Cs8x5ZTMlfTLINzP6aEinGBmkQ=;
	b=Pm2hlqTZfN86s7Wzw4WHksURVnpdX179BDG6jNgqb+yxX+8hQoHwwthqDxU1Sxy9FPo3Gg
	oNVrePrjgZBeezXOMEzf3p1hJwFtY5UF7ZtocQu1ytmQYQkjlHd/XmdMnPmQ4TBZT6ZJol
	oWvUqWz1iNYNBPMIrXNHe8rNjGFLV5E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1AbA6KGu;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789409981;
	b=QLR/C9Ufy2Wl3ldM+vDcQXVBT6LxlQ3taPrUJvB6EcIwYNunryFxuogFiowUOoXfPHBMlu
	dleLd8ntljM+FBFXPYH89fvYXNdjwsMqT7DSfh2xmDFv9jN42ptW6LMT6wFYJ8HmtDPXY2
	iCbesTzr9OKqzGtygobtSa5u9BXDiO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 381B860142;
	Mon, 14 Sep 2026 18:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1621F000FF;
	Mon, 14 Sep 2026 18:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789409980;
	bh=VsN3qekiQiOy09Vr8Cs8x5ZTMlfTLINzP6aEinGBmkQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1AbA6KGuVDMishj6sWpf+J0Yo8lpG41mjxhzMvhE4n/2vzd6pSMPclU1hqG7IBrEj
	 wFwinYN1rKC+IPUWW4zmpuNC75nrU+ShelM6YUViiCar2Mr6EUTbekti8s1lj0Ibz5
	 lf05BQ8f4aek3KJ/cqOmZg1bvjb79gPZha2U3Ouc=
Date: Mon, 14 Sep 2026 11:19:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, ljs@kernel.org, surenb@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge
 zero PMDs
Message-Id: <20260914111940.f7e2c72eac4a2df97a646793@linux-foundation.org>
In-Reply-To: <f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org>
References: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
	<20260913072312.52111-1-lance.yang@linux.dev>
	<aqfRCPheDYTgTdAk@thinkstation>
	<f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B42AB40008
X-Stat-Signature: qz4c1195c5bxzf5aby3dsrkap5bk8rox
X-Rspam-User: 
X-HE-Tag: 1789409981-486384
X-HE-Meta: U2FsdGVkX19/0YDn+2Ib8zYAsQDEPxuvl/UKNr1pGqpM8QqQB4b5GXmyacKtbYHavwWMgq4UO2rwcisQ88lbQIfA8v8e6ele0yHUO6wmr2/k+t8vBDNbDAGEqxndJ/m1CD7Miwnncbzb5p62S43bY2bSukhLSZGZ/eKymwhaAzcH79j2Neq9RBJcl6eevBz2ZLwyhUkM3Ud9CZQ9dSB4AS7cvUHsCbJ6NJyIkbUZIpy6rGTHj9mDg5P9EpsWf1de3V7NGrFFtojPheLntezZ65p5Eo2Bj9BRg/2WDE0ZtM9Xv7umgHaClPhWkxUf5+EwZXXcng4bXujtoRtDog6Me5JjujPR9DquVGRFohUwG0Ttr0T79Xfw+CN0+C+KK+i4dvC1Xt4oKckws9HPdA68rDHY8LtqkBLHmB+PKjvw7g6a1A/mpT9IwNLUvxr+L/J0zVsw5rcMWLCUC6BCtGtTPgGJVIwHgEDIgx3egPfIvBUlvEWy/m4zIg4PBmz9Zg6bqoOwtaTjd1WHHoFZ66ygfDAIJCMHu6FmgF2a7nvvtnKlX6zVqeJEfTv09u5VuLrncg9awb5NwrErvf0PQinOJQRGVHcukNOEHHMkq/4woXmuJJnu1ZW/qPmbME/riLcU0CpryfEOIyvN33Wv7DWBaagOno0+q+HbxnOhE94ZPqGZeY2Viov0P0igKt40Lh3uyJy2MbS1QYs+ZBdBQBxHRcL037gteRhy+9mAZ0Cz8vLYHUiSE6qLNWOJQM3tfjYsK5cHqZjXOGkQFgN8ea916I5kbPB7OFl3uFI0Kr4Ei3YiY3VNoITmjFMC7sdw/mPQcLpTtmBxuy11DbCRdNc24a0FEalUCScvQ++dVNQvIP96GQB7TVawc9K7wsGQMgz7plKXyMV934YSOuLWdUXXroBd+9PLdZCRUUSA0uEylcr3dQco/t3DOPk5MAQ3hWL+5Qqgub8QCkg7nKv3y3t
 syLPHyrP
 NUl8yBLHp/ldYj5hfz1ges9Rto7Z/NxNrmQFSxOc2cyDeSKpSpwRUasHVpjUQNFM6sHV30dA11hNi0BNHB8kqSnpItS0W815puPaj/vn9C82EZ57cmH2nusUSphB+NVSaqJ1OWqAc5PY2jctKOaYp3IVlmNQnlqKGwgSAh2VKrgJWd9fMng7nQkP42yJcYXPKnx4GBEaARXvqoA597t1m3sxbjQGirHAsYSLpha+dzGTRB04Uj89GfdTb6JrdtWHsYA4POQlWdpT5JcJnrvvgbuNmepyIqEqiAni6QpEyZ8hAtynUmZwu6CvGZ7SMBpKhEG6ZvJqxIEB8WQ/mbwQ0Hj6J4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 16:29:00 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 9/14/26 12:59, Kiryl Shutsemau wrote:
> > On Sun, Sep 13, 2026 at 03:23:12PM +0800, Lance Yang wrote:
> >>
> >> On Sat, Sep 12, 2026 at 11:46:35PM -0700, Andrew Morton wrote:
> >>>
> >>>
> >>> That's the sort of thing we'd prefer to avoid.
> >>>
> >>>
> >>> How real is this?  Is there a reported-by:?  Do you have a reproducer? 
> >>
> >> Yes, I reproduced it on x86 with a small test module. It sets
> >> VM_MIXEDMAP | VM_HUGEPAGE and calls vmf_insert_pfn_pmd() with
> >> huge_zero_pfn, without touching the page tables directly. A full-PMD
> >> munmap() crashes before the split series[1] as well.
> > 
> > Ah. So there's no real bug upstream, right?
> 
> Matches my understanding.

Thanks.  I'll remove cc:stable, move this into mm-unstable as a
next-merge-window thing.

