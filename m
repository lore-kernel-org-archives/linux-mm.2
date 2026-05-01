Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A8DCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7426B0098; Fri,  1 May 2026 10:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5984B6B009B; Fri,  1 May 2026 10:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D56C6B009D; Fri,  1 May 2026 10:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF5F6B0098
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:57:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02CC01A012A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:57:17 +0000 (UTC)
X-FDA: 84719154156.21.E579583
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C7C41C0011
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:57:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cCXW9Z9t;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777647436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUasSz1oYm/BUsgpZce9jPH1K2tN84pYU1cjF/t+pXM=;
	b=LZsxc37n9FrxclvBh4baPb5eiKOtoMVBkGAXMIKB07lP5nTO3+LSJ9NhE3oQTS1Y+D2uwz
	SgXNkYRTmcNJ7N+ZEEKUO8XHh71mm6s76wpfX2WfEbt2Nw4KQVp/mEog4AZkUUMKtTdBfB
	32gJtovzl7yAuMaNcgWvmu2+FijnV3c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cCXW9Z9t;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777647436; a=rsa-sha256;
	cv=none;
	b=rPC/H/gzcmkS3hr+oeNPgkfyLwujmwZqwqUYdGQgYgMMR+lm4Oi3dYN+3RTqbvyYU21NkO
	iFg6mbBJBKcqdNJ6GOgJBEqn7jN2dJ7ocazZurcCDE7luJ/WleukDLqry4T2vKjO0L4bJJ
	4aevGEX4/RoMxjLkOkpXuseerWT1XrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3959B43FEF;
	Fri,  1 May 2026 14:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F265DC2BCC9;
	Fri,  1 May 2026 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777647435;
	bh=cD5tD6Wwp/+XKkn2/rBqtCfExQPEk48vj4DKlX6CW9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cCXW9Z9tOVe03lA5sgszdhSe3z6mCYcfYG0AhmgcZmKLHVI1weSZqUOT2a/Dr096R
	 ZUnhgc8ihi5Sz6gs3A74A61MX57bHeyUxkUoeVzyit8jQ4alTeF6ebHGokrtwNZ/NY
	 8FOXS2r9IpDqg9IJ8Op765OXW/8sQOouw1Zx7n02k5wyo7sptnmbOQYeHYEZCBnUEh
	 MpngsAQckEn4gsyWJ4fQWP0m/Dbe722l9hBxWaC7agEEmNpM2HzEdfbajx8IZNEeLk
	 x0qK/zpv5NgpFBxm1uabTmBShwh6elIf+GBqbyjqkCNiNxzuHo2LuaMX5RPP9ZphQE
	 LOnB1EM0LhLQQ==
Date: Fri, 1 May 2026 16:57:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
Message-ID: <afS_RKHNBuiDoR11@kernel.org>
References: <20260430113512.115938-1-rppt@kernel.org>
 <20260430090110.f3ed78910ea7cface7d73199@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430090110.f3ed78910ea7cface7d73199@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C7C41C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: hqmjssa774c9yrwwoa1iribzqdnsgwoa
X-HE-Tag: 1777647435-879236
X-HE-Meta: U2FsdGVkX199lzn/LpqNg6yO84+I+FJJFJd3DLhgZtcqszGqfk3sveeBdkvBWJt+R4QEDXkvbYeAWvAWo2DfUnaZsWGaRT6gd9Ntkem/TP0gCiJhZa1FVs8Al9OwyJxwzhCX++fjoEkOQz+3muEtLyZpg/DeJBlqGL3j1W6VXTXL+kv1rD9HUQnb8/gTDZrXqd73TOrbjU4SSCMLB7rkQ9kIbSdrSuqibEEfbFqU/wbKEoGOBTBW8MAEaPci59FJFimAyBExrlIGoVakfSBHdDjSPpnYktPEaZ01X9BeER0ZFwjuxomroXrxEXE6LMcO5HVYzqVBH7oe1i1ociK4L3AXpxGuckGhQAhcStXcKr35oBrkPjAYYXDNILCQZzHK7NZqVm8aVnZQS3z9us3uyNKzJiIzyVQbPbOm1e+0F3bTSsQs+nR+FAKSEmQxDerltE/JxFVlhXyYIVMCNodmT1OUuYfAae86eUVZJatF3b/7jPwaBxZ6Mhbc203HaMVv/vhWSx398wOLoPfQY9SWLSqSRyR9M3PwHtkNgyKsNgtVg+Q/l8sKT489nVimiy53JSRCrcmk92uRj1PH5DD2TLULZZ973CTtFcZ+xMkKRkTMtEPNYtXB2zXHKwysJm9sLlkkWGqWjSyZCF5Dch0CGM7jPapK/5aaCF3Lg+k5HRzy3c+04RlddAD7XdKQ8nU6u/GjetV2zqNSKhn2AOV3PEWErBasWWI5SL8bOt1Fa3udOvHgEpCQZOMKPumULYFpRKyzeA/JnwGAaKIm03dGx11KL0bZUjb3sEQrpwfTYQFvX7asKhLnCK3+NUOzSIVGIEOoQUWDg13xcXxxWw5zDeb6LVCTetq5pHOn95b6MHr7p/Fg2mSxgqniu/78lvGzlw6QbyOoWeL2UxYYoBnDf6Ogl32kE4cUIJY1dhkn8Eio/ZKk17h8V7dQb6gjRU2u9VdK+LByhICdx45altf
 tWS3QJ9U
 7JYJ9eiEjr/y2csxReipj4NSsppZuxdWV1pE8+PdZWpfeD5vagyGSelzOsQwhvLb6XxMiHwHyS+ydHudyEd+e660ESRIm1P6K+zkr6hKUzsS/MQVI/4W4G6aOx63ur/MWXyo5Oyuzb6mto8y+ViDq1XacWvk9nxBN69qSFZm+CspJx8SIM0H505iBFNk2iRMMzeEfllXebAS5qSQxVPCqEw46zOId2wiZe9POaIyZNXZnZeVKpUWbSenE3G7yaLsL8RzABpLclmKfyebfBwwwn2SiUyXBfU36o4a5pF+cDtaICUSHNQzxjz0IrQioxEU90Fydd6O/7RBs9UiLZG7R55ejQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 09:01:10AM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2026 14:35:10 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> 
> > These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
> > functions used only inside mm/userfaultfd.c static.
> 
> It's kinda scary how often Sashiko finds existing issues just because
> we made it look.
> 
> 	https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org
> 
> Do either of these look legit?  If so, it would be better to fix them
> before doing the code movement, for backporting ease.

One is real, another one is not.

> Another issue in the moved code: the ctx variable is annotated with
> __free(kfree) but allocated using kmem_cache_alloc() from the custom
> userfaultfd_ctx_cachep cache.

@Roman, can you please explain to sashiko that kfree() is fine with
kmem_cache_alloc()?

-- 
Sincerely yours,
Mike.

