Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E4C8C44507
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63DE16B00E1; Fri, 10 Jul 2026 17:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF8D6B00E3; Fri, 10 Jul 2026 17:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C6E6B00E4; Fri, 10 Jul 2026 17:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25CD26B00E1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:27:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EE051C89E5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:36 +0000 (UTC)
X-FDA: 84974153712.18.90643D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78940C0007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kRDHNq0u;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiyyVcn2UqFKOg1zBLJ+Bsw1sKHO3ZSjaN+8rEsVvVI=;
	b=F7WArOYE35vrPASpQSUFCwZzC5Jx1Vb/tHdmj+jR5udLBaoRwqwUXLEwGJ76pRqsRmkSSP
	+M37RO33j9+iUEA77A2Mv2vksadNu/MT3yhgqeG5/wrmWQLw/QNBq5o6lkJF1cNoFYn+9R
	7DU1FyINUvsS9g+2hVXcxrtDm0bpnlI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kRDHNq0u;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718854;
	b=iAb0XZfYODwMViHc4yu5/laRLBT6nb5erRCK1372ffvz1SWtMO+XvgysUYHDDvidIUMaxM
	AafWGMQI35bGDJSXttlkGNveGcOcXtV9uOkUFaG5+DEHVNa1EZBoM2S+8t9N9HI+5wVbTg
	bNjz4+2sngcz/i1QFqY7ve1tOE6nb5c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1198540ABA;
	Fri, 10 Jul 2026 21:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9A31F00A3A;
	Fri, 10 Jul 2026 21:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783718853;
	bh=UiyyVcn2UqFKOg1zBLJ+Bsw1sKHO3ZSjaN+8rEsVvVI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kRDHNq0ua5ePotcdg63BNTvGqVO43cRwnxkm7ppFB1zpCwfOddOy6gUdn6pyqHVAG
	 wvdBcqyiWLBOGq/JyrBsvE3er7NSCYiqpzo4F3zs0Ndy8DZZIdkP93s0Uhqj7kQ1oV
	 dD3PTW6N+JGGpGMjQR4k2qEzEg4+08jnjpRN2llg=
Date: Fri, 10 Jul 2026 14:27:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/9] mm/page_owner: misc cleanups
Message-Id: <20260710142732.e4b0a719d5247e693f7a89a1@linux-foundation.org>
In-Reply-To: <9d8627fe-1fb6-47ff-9ca9-ff3b90a12bd8@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
	<20260701171115.79148d1c7e4f07ebf419c185@linux-foundation.org>
	<9d8627fe-1fb6-47ff-9ca9-ff3b90a12bd8@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 78940C0007
X-Stat-Signature: h1cy5yjfi9iwtkheqhi9kmsw7nugxmhp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783718854-853055
X-HE-Meta: U2FsdGVkX1/S20LhlOKBv2PXOLqrnU8sIe0vDKSZf1QoAgzDxyEpfHC9yrTi4vNBDfc/Z1sO461GAnICnNWmx+ubMo/2GenDSWXREkmQmWoIxwrW6O5m6nyraWjn8co1XtwhPtRye9uwiTYUg4s2b4mEXH2HOLXPbvFbZp08tGOfjVG2TQkFF8sN5DaaVMVlWBIeCfCJA4vc5v/sFemsxA6OhofPZCDuc5EZsNgB5JktdDyd7t3ci3IgXRA5W1f+k0t0i0XEwYQqyDCVpRNDhEt0uc2caEvy2n1GH6pcj+4KNCL5XjR+JmEMVVMf2oItzDVa81V5LClcgUrJ55Fp2UKqCPStpzQPe4fMrzYlcHCl9uxkI/xjos8+IYpor6UU4T3J0GeUC6LVxM/ewa7Imcy6vnwtTLjnQ8ioWODPiFrZYVHgtYf4dC86PFvi+CCNYRldfk+iC7/v+Y+iksJLEq0fcI15vIGfo5xcE4Xnf5whSrFAY8FtU4H1yTTGj3j9JjNDQhx6iW49lbJfHIKLWX5oWfLUImzuYag8CuX6t3n0IFmQ7kpHTh2stkAZS3GbKvZ0xdg2LkT7aKdHcOoa65Q1KHI4cS9vTSTPNZj4Y5pcLyPAum/laqNCsUfGesL/+Ij9EeZ0shDQEjGYORPGU1VLkrS27QtfjIUluco3uwrcJzluFj4mN2G4vCsKeaztZuiLDNDrXzNsScdY5R9sOEBnpFY4NanwCsY9Da2mT8MKSH2Ghlo9exAanX3gpsg0jLtlBj6qaqLrD66LRVQQhmf0f8+Cilw/7EC40rLDu5LS3zav/zIz7tpyKQQ82eGTcv5oIxunwcb1uKjTaSXDiSUCChb25jwEbVPnNgJ6jQ24yo+lurxWKpfJBcnp9pBV9qRGXT2YHI6/hX+qKimrNT0bcPgoWRXq1DU/JFEcODWlsx44jgJjwL0UfLiVlrryt3/qFvpx6/0r5qY/q2o
 ZGMiTL2X
 Zy/lH+cD7b8PsCUvTzZw21nm3d098ss6w7uAPWUdSkQOMqDhiCMusFf6D+iCKO4o0bgCC6VsZ3C20bjVMaTRI6BIoSXqvfmuvNn3cux7YmTqeyima+mDAKwbc3RWCBdsO0pJZ5efG67v9L2/sSFzeaXn6n4ivCKsb78wLEeDyOUBPi8c6diSt4cCuCsbNGlBCu3Cgz+fgD2KyUvbONXFUYi3nM3AJ9SnxBWt5LtCbFAjtHzGKE/uLzF7xZHMKu5/AEwCtZrwzbr2qA5vkSCrArKfvhhxIw+5XcTO2Zsp1cJSNR5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 15:05:18 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> Sorry Andrew, I had more time last week and updated more frequently.
> I will wait and communicate fully for each version.
> 
> > btw, it's conventional to place the what-changed-since-last-time info
> > below the ^---$ separator rather than at top-of-changelog.  That's where
> > we place info which isn't appropriate for the mainline tree.
> > 
> I also have a question about this. Is the changelog placed in [PATCH 0/N] 
> or in the patch [PATCH M/N] that needs to be modified? 
> I've looked at some content on the mailing list, 
> and it seems there are both options.

Please do it this way in the [0/N] and in the individual patches.

Anything which isn't to be kept in the permanent upstream record should
be placed below the --- separator, please.  Low-level development-time
details aren't of interest to readers two years from now.

