Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D055CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD376B0088; Tue,  9 Jun 2026 03:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4826B008A; Tue,  9 Jun 2026 03:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1AC6B008C; Tue,  9 Jun 2026 03:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A11916B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:39:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D7CA140453
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:39:35 +0000 (UTC)
X-FDA: 84859574310.13.6AD0A1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CEC8D140007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:39:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DubfFkfR;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780990773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQE1t/ieDrjC1fAAwsFvxI4Fd5+P0C6DgKtKpe3mY6c=;
	b=T6Qr1z1JlHzDFA7GQGzoXgzAjhsTqvCk6hfVKov76ez9JYOC6hydcDZa8MdUS49a+fL+md
	lv2YWy5zMhiHQjcz6DMJUqL0arysujMcmElti4eCO8flDWZMS7KZqJJQd0hry/wL/yGjCs
	dfPuVoS2dlp2U5+9PahKSqbKvfPKj08=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780990773;
	b=zc7IGlGmOHv/o1Wib/+u89XURllRlevxqGdgSGQZ1YQ9yFGOndZv4w+PWnR1ocmSKKI1To
	0T5PW1qJq65vF+2smK/2llUcU7jmMECKVsQYm3eX8pJ0HPymXJdJIsbe/kpmXSF/ylXd/n
	HGvtFVxuas5AWKDWV+IDr4lOZQWp430=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DubfFkfR;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FD1C601DC;
	Tue,  9 Jun 2026 07:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0AB1F00893;
	Tue,  9 Jun 2026 07:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780990772;
	bh=sQE1t/ieDrjC1fAAwsFvxI4Fd5+P0C6DgKtKpe3mY6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DubfFkfRDUFI7ViPOVaV3zGVwPvjnb2X9+HHYLnScWee309w/Y1qf8KisJqvb9RFR
	 fOWBy1xomYW3gCMTp9chlAshCO8Z/KEaOIZNymsVZ88qcfF/NqnxM29fEJTdsI/Rq2
	 hdX1HFB0AdJBLw32uj16c/9v/DRRbKQ/YDIyVwG1U/BGVPTgUqwQvPRNPf6FRWuxeD
	 QxPB+bjsbLchgy8IJx7d6Tos3u/9mgmI+Hiu7hNx59goqMhCoJ48xSQYHA+t3H3HGl
	 W1digrZq3ae6gBDy6N42Z39GC5OyLZ0YoeqTC4x8yTNO3cMuMIAx4ouTeBzc5w0Vim
	 Rk0bzwZ9bW0kw==
Date: Tue, 9 Jun 2026 08:39:22 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@meta.com, 
	longman@redhat.com, chenridong@huaweicloud.com, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, rientjes@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and
 alloc_context nodemask
Message-ID: <aifC9s9X6hLWdKkd@lucifer>
References: <20260609002919.3967782-1-gourry@gourry.net>
 <8C4E5377-F5CF-458E-BA49-3D962CB75477@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8C4E5377-F5CF-458E-BA49-3D962CB75477@nvidia.com>
X-Rspamd-Queue-Id: CEC8D140007
X-Rspam-User: 
X-Stat-Signature: cydnjz1jh3z9jon9mmf6tfz9wbbit5m3
X-Rspamd-Server: rspam08
X-HE-Tag: 1780990773-987712
X-HE-Meta: U2FsdGVkX1+TlWU4SKWaTTx1sHw45vs6b5Cl22pXTNthq2TcHPa+lrPgaibY7lLDcQWzTLShP1ARk25JWp5jHKANQYW0/J+ZZv+/7d25tGU/divY7zua66YpkPoLrdSO+9NDXJsvGO4OKti0iziu6iSTR2ZXdSwQC1AwKEs0CHwcH3MxULWVDHJm2ptvX74ICzcZS3TWroWkEx8/+Tpcul3ULy7P1Ee50v/xlZG95XwFiLcVoSnkY1ABi6NXN3QgGNRS2ETrBbIlshkXspv131Ypd7ORymhR4wMXDA8NZUynEbiIjot4ukJzZt2F46Tllhg9FBa740Aj8SeHP5uIr2EWKKp2PLcEueKMNQZIzxTw5goTMUCSBqvlAIkFdu+JAUS9KlN8mZ+TutIxAcX66gLV/dHBQgJokhsxp1w04zmqN5EoEjZhjABfs4K5GFk/CDkPWpCWfkLKAjVgQt5YraWnRTvzjiUgB/V5b4ohCxShnWgXOYIPpsdbXjVK7OyEgfrCDf9isGG4K/vi7i/xsb1jlnjaBYQP2VlHdThaDa6KlUbVOZERadkuOp/wVjmTIna89wHnEuYOWa2CcHg1aQWp0oyN7l1jbNVNJqULUWr4C+WAILj3ZJib6Mr/E416mpbm8WvhQtuuYqVdBpBPoML77yyJLq6ipfNA9OKryPzh9STRgcMn9vSzQDHJQNTw6dQ5s/7j4ereRFnvjUvNdhyDV6dW5hiGmKeBiRBeSbc4ETxNFTw0ZRBdL58w2go6TGevS+ptmqOgIlo11NWo16chs5n/XJ6BVV8MGxWV5oizf2lrwY3ovCFiqZdo9ytVFrPKk8i8ZgK33Rb1FP7vyZvcjytO42ahQPPUE1KnJHY0agPF+NYMLb2bLI4HHiVN65nX7PAd0O6xAbVvxuUDeZhHN+/VmD3wN8mvF50zUKnIIA+cQr6icGXReVPRfb9RS28e6RZU8xsq0fQgIG/
 ORAMrEhd
 XGG+q8P5pRRQlU1dAKJ2rCLjkw9mJ/OnmxDBtXxzhVkuYgNQyAOLqc1DrqVqUbuEGSffQgsyc6x2kPRWQ0sz/BquP9KV0W0K0rEpQ8kZwN8cY2o0aOsUVgjyONKg8K+JJE/mk/MqNZKHZAhwlicGaI2BtJ8tm67hXml6k2zkO3yaLeHr8upDLzhwkr+WqIiRTOXznMXCb6chZtXcRJDn/g9HCJP4oP0b+JFYjCy/JGiFLLQ5kPLxYsyLq4Vsu+g27dTj55b8b0j6hdfuFj6o8NGsB37E+wTL+2nBTImtFgUJDZcM0v2tIgjUeNwTdTMjmc0Frh1CeCDFBzoPIHUaV/c9+JX2mLE9UhEAaWqeHRrAvfPS1vfNpHT7PhqXrovubLMEK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 09:44:42PM -0400, Zi Yan wrote:
> On 8 Jun 2026, at 20:29, Gregory Price wrote:
>
> > The nodemasks in these structures may come from a variety of sources,
> > including tasks and cpusets - and should never be modified by any code
> > when being passed around inside another context.
> >
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > ---
> >  include/linux/cpuset.h | 4 ++--
> >  include/linux/mm.h     | 4 ++--
> >  include/linux/mmzone.h | 6 +++---
> >  include/linux/oom.h    | 2 +-
> >  include/linux/swap.h   | 2 +-
> >  kernel/cgroup/cpuset.c | 2 +-
> >  mm/internal.h          | 2 +-
> >  mm/mmzone.c            | 5 +++--
> >  mm/page_alloc.c        | 6 +++---
> >  mm/show_mem.c          | 9 ++++++---
> >  mm/vmscan.c            | 6 +++---
> >  11 files changed, 26 insertions(+), 22 deletions(-)
> >
>
> LGTM and it compiles. As long as Sashiko does not complain, feel free to
> add:

I would add caveats of:

- Complains legitimately
- And it's about this actual patch not something unrelated

:P

(Not speaking for Zi of course, but I mean just in general I feel these caveats
should be implicit :))

>
> Acked-by: Zi Yan <ziy@nvidia.com>
>
> Best Regards,
> Yan, Zi

Cheers, Lorenzo

