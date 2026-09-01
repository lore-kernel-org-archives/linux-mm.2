Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 307CCC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15CD6B01FC; Tue,  1 Sep 2026 10:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC7B6B01FE; Tue,  1 Sep 2026 10:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AD56B0202; Tue,  1 Sep 2026 10:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88AC66B01FC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:23:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE7E71A0413
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:23:17 +0000 (UTC)
X-FDA: 85165410834.19.DF4CAC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 45706C0012
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:23:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPHfjvFX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788272596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAnWOLBaYdAhbX/W7o4srvf+nw40P/4MunhygRfNOJY=;
	b=ZcQbHifwK2ZJC5t0vv1JGYK+Y+iDFLvg+sBrrFdMwMwywtb4XG/DHdGhfGZm/w/1sSXq1p
	zwn3EZrK5hYL9V32GDxjgLJCtbPi0dmKhtkUShOViQBHvBax4/3zyuf3Dubn/5tGclI4uF
	Ktf/im6QB2B3U0DlE1XZVqk7nJYsXow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788272596;
	b=6NKseu5bd86TJ9C85bWL6jKvdXgCb6uuYwnQZf+Yuz47oSmChwP4cbsR5VX1sbFRUSfSSV
	ISlDiqoQmv4k0/PNkd9KOZHoN/Z420Oigab/n55NiFZKr/gj/F311LI/x0hEurmNfml1ov
	vWaNkdZGdfM21vjuWt8fdgyk1nkn934=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPHfjvFX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4809440F89;
	Tue,  1 Sep 2026 14:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98B31F000E9;
	Tue,  1 Sep 2026 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788272595;
	bh=HAnWOLBaYdAhbX/W7o4srvf+nw40P/4MunhygRfNOJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPHfjvFXIyEpaCxKqRMtNK5UBj6fVVRSReoO7SSt9q74/XFmvDeLdUHGkjCfl7T88
	 dHNnM45LM7ZeVd+cCgot6x0CHgRLRUe1BYxTlwFUQn5QBJRE1mqyiI9N83vKyddo7Q
	 LMKF0fasYGqgRbWMG2WvXU1GDlOA6ZPV7Jc+zMW1+OGN5NBzDYUd051dkc6mNowGvA
	 XUMDvHlQqyTKqFZ5b8Fm5zmXnj50AbxlgTkE0WiDXaT2GQFC2HTZiyzZ6YGnw/GBY4
	 4bbk7HKIvRif63485w0YiniA1/cBiycD2iiuH/3on6ou4nJQTP2OwYMgVIWiG5NNP1
	 68jliECJSBwEg==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Tue,  1 Sep 2026 07:23:07 -0700
Message-ID: <20260901142307.100701-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901065847.42869-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45706C0012
X-Stat-Signature: x1f6bw95r7gujcbygc5me51fdtp5fwy1
X-Rspam-User: 
X-HE-Tag: 1788272596-261505
X-HE-Meta: U2FsdGVkX191pRN7kWRdrrYrX6EY5M27d9+MwmPmkxjFNImSBXOgceSjaoI7eppK2XBd/DjjDJK5L3UEV9SQvKLIyUrg53c0rgjRK+1Ec1cfubryS9v69e5id1pSFibdsJPnJTyXDau5z0gWcaxdGvdeZ0h0mz7AB3Zyc1rlafQHexFJPd4rf2bD1TBCeuXjOWFi6Awes54h6WAeHRdV6HObcdeP6gc4+FLYGNvtpQeHiaOuK0BSXweV7pHTlHiy2XQhx9IwMplbckSINSE+z48OnNd8RRZA5Cy9fcw54zyJV1ZqRA0zy1r1zZ6BIzmfr9kXuHyg+WuhH7jvM+fVf5N/wH00wCs7poeozTYSmUDalrp6GHN10aUbC7ZW1E4ezNSBl2HrMt80sb0MpV4WYeUWTzcEqg5iX8SGwYvKfXlPTzaCbK9STgvvMyGOdKs9nQ9bzfYw9XOm6ZLI9IIPid8of5KMnNMTXh5KNbIlBojISBUNTFuiK0WeowquqNDts+0A7QMQccgJfF6CtldxjUmTmhQVzTA9/j88FsV56P6H1C7c6CaL0XrpF02uZYw6icBRcNSg91FE6y2elMhczMq8y58B3FMO1bu4imJS7VYlCu+mkscehAl63SR6hTUcuMiQ1ukmWUQgbu0XglAMzimJF98iCaF6MLo/alHcUnh5RF+VxmxgbKI6MzgHLzfqOhJomCx6H6BFMWcNw7qrO3GGyWWUZV358JVZwB9uKj6ntLcZ9lJqTgKQR9XEWLamiYXeGageh+4zRGV75SsdYPHNG2pKs3caTcpw2zmvRGkS+WbKu/HIffYaoRHy4KIrczh1QGWt1fmnY0soYD9S93Mi4E+KiV3+3sCeKlwRa8HHBIG/TEcZvR1tXe//Buw+SdIgWU7TzUJCYSEidKHIDAleDdMWeXKcna2q4YhvSsb+d9cHLLi+z4JJiiYij6vEkvdWntqdDGtH6gtLweb
 wdDqLlJk
 HCatt9Bcw2XiIhObrrqIAYLyijjAEhUROhKAe04ILfSbwt9Gww/DTHX1mngeG2GnYwebCk1CefiXAcpNuXxkd7OOimpUdL+gDMDrGyxVG4L5XDZ7RHKG28HMtKxaI0pbBUc2f38z6plDoWhAZXN2I+P+vvgn7WwcPW9zbk5P9pyeA5BjU8bUOyeDvyqxWGVVwbIfHSaqQJVvHMo2Dt17mh/dQLSOJFHFdhd9pGQ1X3XUFgEfGOxZi0/Q8LdBunntNQufG2RsQYJgSA+oRylETuS4RFuVsjXe4jpmw29an6Xh7HqPwEerYsggAnNJu2NBQoDlcnH5PkwDjQ8s+ZlMzfSRdVl/zbfOMeUyRhs5I/7xbuOgmoMaOXkH5TSxvv4ubr11d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lian,

On Tue,  1 Sep 2026 14:58:35 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Hi SJ and Asier,
> 
> Thanks for working on this and for providing the server results.  I have two
> questions about what hugepage_mem_bp is intended to represent.
> 
> > Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP auto tuning. Add a new DAMOS quota
> > goal metric to measure the amount of huge page consumption to total
> > memory consumption ratio.
> 
> First, NR_ANON_THPS tracks anonymous PMD mappings, while NR_SHMEM_THPS and
> NR_FILE_THPS track PMD-mappable page-cache folios.  Therefore, splitting only
> an anonymous PMD mapping can change hugepage_mem_bp without physically
> splitting the folio.  Is the intended metric PMD-mapped memory or physical
> large-folio memory?  Clarifying this and adding a mapping-only test may help.

Good point.  I was just missing this.  So, hugepage_mem_bp is not accounting
anon mTHPs, right?  Since hugepage_mem_bp is for general hugepages, I think
this is better to be improved.  Seems using MTHP_STAT_NR_ANON that is exposed
as 'nr_anon' can be used?  Because this is an improvement rather than a fix of
a bug, I think doing this as either a followup or new version of this series
are ok.  Asier, what do you think?

> 
> Second, the metric is global while a DAMOS scheme can target one process.

Actually it can target multiple processes if those are in single DAMON context.

> THPs from other processes or NUMA nodes can satisfy the target or dilute the
> monitored process's changes.  Is this intentional?

I think it is intentional.  The user should have the control on collapsing
hugepages, or believe the uncontrolled collapse mechanisms.

> If so, documenting the
> scope and testing a background THP workload may be useful.

More documentation and testing are always welcome :)

> 
> The temporal results approach the 10% and 25% targets, while the consistent
> results overshoot the 10% target to about 20% and 45%.  I would describe this
> as control-response data.  TPS, latency, TLB, fragmentation and collapse CPU
> data could further show the workload benefit and cost.

Yes, those would be helpful.  That's not mandatory for this simple change in my
opinion, though.  I would let Asier decide whether and when to make and share
such data.

> 
> If I have misunderstood any of this, please feel free to ignore these
> comments and correct me.

Your comments are very helpful, thank you for your review and comments, Lian.

> 
> The enum, quota-goal wiring and sysfs exposure otherwise look consistent with
> the existing DAMOS autotuning framework.  I consider the points above
> follow-up questions about semantics and evaluation, rather than blockers for
> this series.

I agree.

> 
> For the series:
> 
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thank you!

> 
> Please feel free to Cc me on related follow-up patches.  I am happy to help
> review the code.  Besides my own DAMON work, I have recently been reviewing
> and learning from other DAMON and MM work, and I would be glad to continue.

I'm curious if you and general reviewers need or prefer to directly be Cc-ed.
I was naively thinking people can search and review DAMON patches by
subscribing to the mailing list or using the archives via lore.kernel.org like
tools.


Thanks,
SJ

[...]

