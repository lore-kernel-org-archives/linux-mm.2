Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B29C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7DD6B0088; Tue,  1 Sep 2026 19:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E720F6B008A; Tue,  1 Sep 2026 19:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87DE6B0095; Tue,  1 Sep 2026 19:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0AB66B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:15:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F2F51A056E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:15:39 +0000 (UTC)
X-FDA: 85166752398.04.5DF8730
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 61DAAC0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:15:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qatFfxxL;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788304537;
	b=ZRlijtQq29VgLUuWVL2OMLh2EMNDONRkeaCAFJgne9IdxDtUMbH32VIHYexzee7bLnKNWX
	YminQXMmNbkWDZRCf7mGxRuFFlmvD5paFTY1pVWlpUrO5pIGWSJJWD+psA5+bpLctq0/ce
	NQnpHSWWfL5pH6a7X8L4gq3pXzF066w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788304537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=641uvQa2RnfIvuFeR+FjSK3wz4QeS4TjUN3ipgvblAM=;
	b=RQ/1SkkKLT6GrpVesTZwQXKJ1/LDdi93tAsfRq0ecxeLTr/O4dGhI6CeIB/Wps0RKFn2oQ
	IdcCYjujUszx257dbR02C5i+TE/hX+ass2Zma/lXq1f7b6yzJ/HukR/g+Ub221DdzFUMX3
	MJtmGlgYAW5hgcEgZDc07SU9e9aPFbw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qatFfxxL;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9C7360052;
	Tue,  1 Sep 2026 23:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0097B1F000E9;
	Tue,  1 Sep 2026 23:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788304536;
	bh=641uvQa2RnfIvuFeR+FjSK3wz4QeS4TjUN3ipgvblAM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qatFfxxLwnXhAEEO40/24Fp7qE6ioZHuEqLjp7MOJFSl/gcDd2kfuO8RAXhYqYFsG
	 55p0LqfE+RRZfkxKqM3783D6v8MHv0FxHCTCbgnO0ggPocYkbIAroxRJ08xSs9qzKk
	 zHY2Ve36wVg4E9xhO9T0lB3pIQ48l5wyybk3tktQ=
Date: Tue, 1 Sep 2026 16:15:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Chang <richardycc@google.com>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Suren
 Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>,
 Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko
 <mhocko@suse.com>
Subject: Re: [PATCH v4] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-Id: <20260901161535.70d685be6a70fea1f6e05b18@linux-foundation.org>
In-Reply-To: <CALC_0q_cap88s5JBzU=bEkN+66VvMi=e+2M1b_JsiTYmV2t21A@mail.gmail.com>
References: <CALC_0q8rz7U-8x+syTFcWS6Nihxvzd00ruzOThb90P+cDqi=TA@mail.gmail.com>
	<20260720044103.905191-1-richardycc@google.com>
	<20260719222306.540829de219e12e21396d260@linux-foundation.org>
	<CALC_0q_cap88s5JBzU=bEkN+66VvMi=e+2M1b_JsiTYmV2t21A@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61DAAC0008
X-Stat-Signature: wzt7wr6tyxyyttfexkdsoysq3b9aqkpo
X-HE-Tag: 1788304537-540433
X-HE-Meta: U2FsdGVkX18NyFoWPuLEBb6zBqX8PXhcblKrYuIJJxMqKe9yAVa9qfFnu8Hgy40j2BywZgWRZG8Ox81aCKRRMbECTapCn3OynlM7+IjTottPOh18mB6Q6oIhJ4wpj1SggU4sWFqLk+nVyetXtTkXOIkdxdY41bfEJNeC9lStkeMkSbmhE+ssgdhQxJeKhEMHPk1bTslUVWfFNWp4B/u5TeumN7Q7AUx6gfPY3kYzfCoQuAJOLKpIW8BazSXwvUH0X5mAPiRiC0ltsdWNZ94ly05zCWDReIiB4cUe5ghNeEG/EFCcZxdcAqGUcLohJ5LixlSWUf64EHpC76r3Sm88pCL1fa/2Gf32oZQZpDkOvjdo/t9fXQDhOY3clLFUZFa3L+mgGj1vF1mzprdn/KmHglumajYvgS6vkGxwS5OWZ82xxS5R/eV/telUogb4fXQ7jumlC+GoxT+rC+BbIA5RY+aM6C15a/djo0TR4Aqj/ukPnnx34svffijXLthtFfqNVhW78yd8wZ//fq6MV3uxt84vhzWgUHQYLG5Lb5W1P2B3K0/UBnbOcJQFmnYXFt8ZXBf7yEUX7z7lkbNCVrRHjHrBGSZy0AzSE1H1T5W1AZIHibZJLO9iuIu47ifUJ/EXX7kP2bE1bv8BzZw8/pUkPgvXnwm63OVRKvREffI+sneTEn1ZhqS+haESEACFcWI88q353PfIeBOPDHWKH4bk/+C/TagyR119ClZKbeb/eGEmkLalLzKeh2omRcZrfvn/Ic2sCkORAhuYegHGEUsAxPK4GrbLtq+mXShGQkGux+MKJkY6JNS2Z1fikonsC5400272RdGFDnKS/kXeO8kzvrdcNtWhdLD9vcuWHDGKDVvIZwXOnHCvfa994F6d1DIg53cC/n7jXC7lzn/VqoNmDC/X6J2YW+Uj1aAyPxvb59KS8vWsSDqFUkH3jScjMsfOBiA+PGsr1UMOyMGOC+A
 iGwSFTvg
 tjPuCFCAvtxx7zE0NdmY36xtxQFHC1/Jy1HxPMtMX2frNASVyaV/8y6hrWAliEqzWrlavdvD7FlMnMDWdSrpXg6qEJkSWc9O5VGQSttGl7aHt4fsAAXHGmaYvic61nNNqNNUFX9BVfd673WLhtXLSZtuVdTZUc8oY53ZEfGFGuiic/ZR3Bw8P/teSJKvPuKijfBzw9ajkAnmgoYpFhcWaJT0VzRa0Wr+dfLteJZUYnPP4quphFNGmKUb0ASrYpiJBq5fRaYXfmWQNF1MFqhLcSYFJEXSZlyK5RKBHUwEE1Acyv2cHGM194kpEcuxItVkhlqKKL9HavE8VieKg2mIMy4HB3rfTnO2rEZJk5iUgE1kMemthFau0/rOjvvnDLE2Tbg2e42pceb+eYMteAa4aKQkwAc3fDTwKIQP7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 20:04:30 +0800 Richard Chang <richardycc@google.com> wrote:

> Hi Andrew,
> Thanks for pointing that out.
> 
> On Mon, Jul 20, 2026 at 1:23 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > So 287d5fedb377 led to suspend failures on MGLRU-using kernels.
> >
> > That's a regression which justifies a Fixes: and a cc:stable, don't
> > people agree?
> >
> > AI review asked a couple of serious-sounding questions:
> >         https://sashiko.dev/#/patchset/20260720044103.905191-1-richardycc@google.com
> >
> 
> Hi Michal and Oleg,
> 
> The -ERESTARTSYS concern raised during the AI review seems reasonable:
> 1. Over-Reclaim: If a task has already reclaimed 900MB of a 1GB
> request before being interrupted by a suspend, an -ERESTARTSYS would
> attempt to reclaim another 1GB when resuming, resulting in up to 1.9GB
> of over-reclaim.
> 2. Incompatibility Node-Reclaim: Since reclaim_store() unconditionally
> converts any non-zero return value from user_proactive_reclaim() into
> -EAGAIN, it will not restart the syscall for node reclaim.
> Given these constraints, do you think we should keep -EINTR in
> user_proactive_reclaim()?

It's been a long time.  Did the above two issues receive consideration?

Thanks.

