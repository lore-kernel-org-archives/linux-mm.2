Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E84FC982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 17:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DB56B0088; Wed, 16 Sep 2026 13:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40836B008C; Wed, 16 Sep 2026 13:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E559E6B0092; Wed, 16 Sep 2026 13:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1A4E6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:28:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52EA4A600A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:28:49 +0000 (UTC)
X-FDA: 85220310378.01.1357C96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B3DF240002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:28:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnA3Mnwc;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789579727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NtqovApGf8dvKnjUST6br5s7d5zKceLLw06RUJrpIw=;
	b=ctLmaUFTeFFfgH/zvp3pAHjfx8NHmXmH4zprqTrS1GzgnG7VJg2WZF2DQfcqcUTh7gacUd
	bB5RSTCB5Zvhiqy6Bih5pzpV0Y1KKXKJeH09DkAXvlVqhku2xe7Eh84EYTTouAbGL0FOjn
	f18H+ZsJ2w6CdHH5gSLdF+6Gax2PnC8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnA3Mnwc;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789579727;
	b=Ea+oK786AXmFvrLNEyloaoJOCD2meUTrPQI6slb399bJqXp6eAbkHzmS10TalcMd8RMBxh
	TfVyzA7dq4C2Xwes5zLpXercUDpKTXdrPyNNxcif+fLNLSSCioOUgk7tZNsfuy4K9mViyg
	uPQFl/AsxszeKAXInk1ysH0pcBAAWJw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ABAB600CB;
	Wed, 16 Sep 2026 17:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD261F000FF;
	Wed, 16 Sep 2026 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789579726;
	bh=8NtqovApGf8dvKnjUST6br5s7d5zKceLLw06RUJrpIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cnA3MnwcbVLsJ11I+8hYtmzPV27C3NRL5NVBmMMsbRrnYusv1fuUyeDaEcrEylZ4Q
	 TPDczkYw3kZbarkCsiptbpLP2ywaNSrq6VJL0PtRbMwBnbC53v0hDsYqujLYQL+YIh
	 itAiwVGFDPnTEmWE6Fe2qmgdBc6Zqi7Sd98tgG0rMD8CE0BccS9nbJf4SAY37iQU/M
	 5XbvEAV2bqAZf2L+E2GrKEaR2M58wnZUBUIOzdw/Lg63m1e0IYJVjq3WPaqKaxO+wP
	 zMpQyU3Acqw6M8uuLPRGlXbJPV+B2zZbWYlphDkAFDyYkbFa9BzLOeZBiGJ5r+gN1N
	 EVY6U32ALGvBw==
Date: Wed, 16 Sep 2026 18:28:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
Message-ID: <aqrRewVuKfPk7y1U@lucifer>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260916035222.GA19557@shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916035222.GA19557@shakeel.butt@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3DF240002
X-Stat-Signature: u9g1kxwyxduwnodkd6mtdsgqksjqug59
X-Rspam-User: 
X-HE-Tag: 1789579727-629167
X-HE-Meta: U2FsdGVkX1+QWhcU0+obE2TDbzL0e9hy1pCHk6akdbAmHeRqSkKYFL24Sh6ID84f/BIi0Bcv+phBdyJ6o63gS1ZS//jLkI9krMHGv0w5Xpg1wlJKPDH9JxXfsL5UiGad49a6EMfSbMYOz+Vudu2pguXReJKtzoKG7yhq+gEcaJ9KNCzCopNMPmi3Xkw0xdyoHuF1ltSUSr3dbR19GE5lgSu9bVvCIdc33Cj1MbQSjML5PmOcENsAa0Xg+MbigtpNKT/9F+iLhMu35zxpDnKQjJA6u5E0JDHAsdAkAg00ZcVtzNGuACCEvt69lFoVstz0vh8PHIjC+/1iIrDe4fhhZ5RYFYXfiuRnDousUHjTNPXJClB7XcvtffP/zM3xVbGuTGpr05vUY3JxW15vg8tQ0btRb8JZp8aiVzZwEffnC84JOyOq/PfmY2J035kgFxMt5A+zOrzXn6Ckwpwf6m4IkYIt5/wSEpCNP/oxOVOreeWaT2jDe2JNRY2JtpA5JVBQHOTd/KFfJi4QL2n8eTo+NGziMLSGkpXrXyPu2Mgr3yKqk+TAQUq2ijHi3uy4cXe5MewTa1bx0Wtso+i4WAas/x9bv+jWXMAvxZWkR8nQ38yOooePTA2RDLjm8Mme+oRJxwq5y2RD6r9wg0vN/jDjOpXfuPHi9wmGtVx8h9Z+dPNu5Ll9If8j6oyvq/G4WAjEXZJ0ffSKGoKOdnv0HRCuq26m0O1zSF2j+WHOiip1sot6a5hA4rDgTHrETQSX/fMSd8POq+r2zm9SQVAqurgmGohkEJSvlnd/+pKxec7Hk824WulnO1XBhM6wdd92xAP2dVrge2E4JdiLg44tQHLRkGQPXG+koq0a260IDREdBdONVj7w9az92EglhLNtAViIH8thUZJc2kiufJ9XvDqPKsBrxvbk52U49Zd1sPMLYDYGRZ0A8nkayH5LHx76exi8OfoVvRBZm4zcXaBYeci
 oL6nHcsO
 uvS0maZ7YWsmn2B8N8FJ4cKQj6lCk25X2OTWuQd2NpZv++xdQMxHogxUzxG9WGifjygUyiBtZV5IrcPCUWqZsABo6gKvZxWe6vssusAg96EJbiT4R5Y0tltYl+a5VxdcxOZlLcXvpp2/rBrH94YvI89D26RP0OF35A7W2leDiKa/oOQNGQZx/yceUAcTna6rtyuxReiDfnEowpeQzDPaQ+dfkg2UD+iJO/tGorGpmFAKumkNGb52sFf1As3aZmddqIThTnXmI9rhXMdSXBvUk95rkONZEduQ6jP9r2du3YUPg4OzpHJL0Ba7vvLP+VHr1jqzLXQaZPXV3sCUz2J3F72vqXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 08:53:10PM -0700, Shakeel Butt wrote:
> On Tue, Sep 15, 2026 at 07:20:04PM -0400, Tal Zussman wrote:
> > The memcg accessors, lruvec helpers, and stat readers only read from
> > the memcg, folio, or lruvec they are given, but take non-const
> > pointers. Constify them, along with the page_counter readers and the
> > swap I/O blkg helpers along the way.
> >
> > This started as a follow-up to [1] that quickly grew in proportions :)
> >
> > [1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/
>
> For the whole series:
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Oops, I replied on the v2 with the same:

https://lore.kernel.org/linux-mm/aqqaaDqTDahlZ7bR@gremlin/

but obviously, equally so for v3 :) thanks for doing this!

For whole series:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

