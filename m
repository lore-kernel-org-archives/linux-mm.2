Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C59A8C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAE36B0098; Wed,  2 Sep 2026 00:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64AC6B0099; Wed,  2 Sep 2026 00:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A9B6B009B; Wed,  2 Sep 2026 00:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBD26B0098
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:23:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45A691A0753
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:23:54 +0000 (UTC)
X-FDA: 85167529188.30.7FD7706
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8FCE020007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:23:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=efsMFi5D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788323032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/BBp1rCaHO25EnmCw/gRO/quORSiIRxHq89BaWHrqY=;
	b=RvX3ejqE5qDr2P0Nx3nXmTSgvx5q7wi2+uADyRI7KTFHtGqN8hnfH/ryOeQCJSSp7/CGq2
	MOkp1JmHOoOBnsz6EYoglrm9TyrkxG+Q0W0yAKO3mgVqs1LOCVjcRbrveWsckraYPNdm4l
	e0poKtPh/UzJJZFGzR6oTsx5JGdSkW4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=efsMFi5D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788323032;
	b=G+6XSnwlsMEJxxisRHy4/u0b6G0cTSj0LDA5H2OiFRIEg0W2QhAoX8pTi84QJvrRf7Yt+T
	eDc/8KlRnF9y8UpnCpIwnV2OCT0eA30TCXQCJlcUWaaivHlGPlSryjkYhVpBnI3Y/ZqUdo
	/niIsCk7Gi9ixZ5GRl4kUk9Scvtub7E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6B1443E92;
	Wed,  2 Sep 2026 04:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462301F000E9;
	Wed,  2 Sep 2026 04:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788323031;
	bh=k/BBp1rCaHO25EnmCw/gRO/quORSiIRxHq89BaWHrqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efsMFi5DAOQl8K8tkDMkmeesth1Zr+E8qUFuw2SYFsiGrIU5k3mZKlRmHVjeoy5Up
	 Mh232iQJOWIKNzjvGZYNeoeShVNyaDTa6lGsyyoN5DD9V/Kv85+QJDoFcN/i/D1jIH
	 cCJGtC33GLJdrgibBOLbgxgMtziisfzeJY/Dk1K4+BNlLYGE4vznMbGd9JneORDsbl
	 StPSReyIi3VT4KJ0syn8fAblDFXb4Dt3K59p4zgx5HO1lByfwnekQb1A+q/CXHVK/J
	 DwPmaEabtuXNBgYMDcv5bKId6yA4W9hyeVShopEBuaww7OQsJN101tuGEQOcOO144E
	 KqSYVzKqpxv8A==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Tue,  1 Sep 2026 21:23:43 -0700
Message-ID: <20260902042344.83913-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902015616.57702-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ekigq6m6e99ngcemabxx7o3agm5yijtj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8FCE020007
X-Rspam-User: 
X-HE-Tag: 1788323032-894007
X-HE-Meta: U2FsdGVkX18DWBEXVhrTUbnMHbrDz05c4zKv32eVVKVQXhkt8dCjd60sCvR7lLSpjabyrOQ7r6bOG66Agh/R/MqHanzgNfZVlHVO8i/2lH/qyJCQe+wmtvEXnwIm6gDwpmsLhCNH4On1ncZQLKixQHYA0unxwhJdP6Uusy/JP/pqaKhgv0MTl8H9040igt1/JMQOInECoDqx07YoFo0dNFMmXr8XR36mdjVEnXEL2wVHgk0UKdjHJv0D0K3LHXliqu4Je4LzeS1JfJmdUnXZ1kHp0RG5bKDVnDZlLIkIPmAb/Ba0oEZI3WdTQuJ63n7m5Hvpgo4jzpHRX+aXSyrCe3Ad5cImvJittl1ZYqiNyZpA+KGGZgiBIHyiQSOwK4hZKEiXZTJ8IEq+yitgVg4ChHTxLMRm+Jw4hAJScyE8pDspFVKc6m6wcI4GgoHWVzvnVDMiUVJh5Vw13DzXyw+MTHSBn+AJPd9Po7XaPN4dAiHqAVZa+/j8UjVVw4Xe6mhtyrXH+ls55W6XstuV0H3aiupVF9mAx73y4CmuvHffon9rix13WTM7fvjDyEoDe4nicYkpGBDuTPFq/upAtD9IdjZrcYhgp5jlX6E2QHIVzhUcAzWc51bYp7mdJ/ljQsLzdhpZmDt3zeRNAkS6UiwphJOu57UkLr/kqXZgxEAQ0MTYxs2FOT4iECCi99L4+p0LVA6+oLiivjFMJBf57o+Hf/1dIRPKzKA8mWYhj0vaZOVeUx27iafUfgzlLw+6Y1Vl6LyJmbgeAViaAbCMIKegvukvScQlFbog6JHEW+z2AXghmD947XsSnBmuwoz1aL7vuEG3HM0t+jwxFLK7RKrRuJtxYeoGplNDIE41lXbIabNsjrnitz95x9VvkXEMKDtCsxr26UJAP+Wm4C6O0x1kAujszIMoNrj2ZnN0Bkgwc/lU1OetMDCNB4Tdv5h9L+wL9zGfaNgxxKijFb4Uosq
 IlGm82B7
 wsxNs0J17M7Fa7UM3F2L7rEB2r+KVtD2oJnJQVx3kv89ZVp9NLJOMpizoouPUYmkVxjO600a9BZTLlHXSvjtgPfjmxz97X2SDpzpd9ZfRUSr/+yavzhzu4Aillci76106RhnxEeve38UXCmJ4BJfNHO5hHw0CkkqQcHk/Y4HUZQRk3ZyF/wCB+PsDJmz7rDhnG8955oOTNfbHsL721LqHnLoXzsb18fBklwW09HkpJhqNzUKVKAJXRakA6kV+KqJeS7oYzOlwpgoh87nHw+avKJtIASzw+rhO1VNCIq8MwVWh5CQ2bevR7EFei/5h6Y1OacF0Hc0NQNAQOtsBQvQvIKKl3A8TJSrDMdo1heh9xlS/e1+ZCoKvTQxg+AnZA1CfM/IP7EGv8mLINUoZsio4vITxRbA8PFGsVzfiKLV+hJyPp3iySsagx7OLz8T2zaTg1PNknZ6qS/ewpoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 09:56:01 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Hi SJ,
> 
> > Seems using MTHP_STAT_NR_ANON that is exposed as 'nr_anon' can be used?
> 
> Thank you for the suggestion.  I will study MTHP_STAT_NR_ANON and nr_anon
> further, and document what I find.  We can continue discussing it by email,
> and I will be happy to review any follow-up or updated patches.
> 
> > I'm curious if you and general reviewers need or prefer to directly be Cc-ed.
> > I was naively thinking people can search and review DAMON patches by
> > subscribing to the mailing list or using the archives via lore.kernel.org like
> > tools.
> 
> I subscribe to many mailing lists, including linux-mm and DAMON, and I also
> follow patches through lore.  Direct Cc is not required, but I appreciate it
> for DAMON-related patches.  Because I care deeply about DAMON, directly Cc-ed
> messages are filtered into my important mailbox, so I can archive and review
> them quickly.

Thank you so much for your interest in DAMON, Lian.  But, the problem is that
my memory is so bad. :'(

I am maintaing mm patches review status dashboard for people who want to find
patches that waiting for their review.  It also provides the review status for
each sub-mm components [2] including DAMON [3].  Maybe finding patches that
waiting for your review from the dashboard is also a way for you?

If having the mail directly in your important mailbox is what you need, I
believe adding mails filtering rule for DAMON patches wouldn't be that
difficult.  If you use hkml, it could also help you monitoring [4] those.

Yet another systematic and long term solution that I could suggest is keep
reviewing and posting DAMON patches one by one, build more tracked records and
trusts, eventually adding your name as DAMON reviewer or maintainer on the
MAINTAINERS file.  All patches sent with get_maintainers.pl will automatically
Cc you.  It would take time and require patience, though, of course.

> 
> I am very happy to contribute to DAMON, and I look forward to continuing our
> discussions and reviews by email.

I really appreciate your interest and contributions to DAMON.  I hope it to be
continued long term!

[1] https://github.com/sjp38/mm_git_dashboard
[2] https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subsystem
[3] https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subsystem/DAMON
[4] https://github.com/sjp38/hackermail/blob/master/USAGE.md#monitoring-mails


Thanks,
SJ

[...]

