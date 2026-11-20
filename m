Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9513860A261E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=UOqy7u37
Received: by kanga.kvack.org (Postfix)
	id A2D0D6B05B0; Fri, 20 Nov 2026 08:41:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDF46B05B3; Fri, 20 Nov 2026 08:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4656B05B4; Fri, 20 Nov 2026 08:41:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C43F6B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:41:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C50340F05
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:41:15 +0000 (UTC)
X-FDA: 85455608910.21.CEFCDBB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1EAA616000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:41:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UOqy7u37;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182073;
	b=Fdwk6ynfMno3bMrcbbOzsgw0ToxaR+uFMb43snSopXN3C6vKh1b0CLID0uQ62dfjKO7Rnt
	k6IbHBOvxDnKaDmhqfb9J681H9jfvyfHozsM+HPgqYnhIOOVpl7Ro/GgTrJMBoNs0rEodq
	+VqvLNJnN0Nb4T931kXD6HnxZ/fba5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwxNyVQvyR6u1ITlGByMJm+FIMkbiLq8smwLlAPk+KY=;
	b=wL/4qDK1eWlVOQNlvrkvdo+inn5OUBwjv6+xLvPZGo1h9R5MZtdTOUyw1+Dax/bG/J75bz
	veuB80ZTbl4uZa+vWgHpNfeaRqSln5KYGeLAnEewQi4EXC8klmWpsNBTLMCqLZC84XIUaZ
	HGPJA5oIiBnSwB8hwDbOmz8zW7ctsKE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UOqy7u37;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FwxNyVQvyR6u1ITlGByMJm+FIMkbiLq8smwLlAPk+KY=; b=UOqy7u37mhnP61kkn7RZKKf6H9
	ZaRrcOD2JPqTkLdVXkZFf7j4ccv0mAxGi6d4e2WZFmka0wbHvdEKRRkB35KpnDNy4RcWF5720e+sy
	6QjfODHYDOwWiXb5CgpNQW1shlCFB71Kw8AVusaWKoUw1w1k4UVKwYuWmoVP2AL4Cb4pHMKrYpLYA
	es9IbEn1MJdQ4UkrL+xJgrF9FR/qlmTXq82cGmIkR1JOOiZyNE+Kdx4aauaHlWFzcp9eoGq9RXFOr
	mht4nuZCmfhBYCmGxJLYGNCLJZbGt1eYE0NApUE3fgoX9sHgUA67S/rDvOzaxbQYNBKZUZdVjAAe4
	mChXJ0dg==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUOrV-00000005Gv3-3N0b;
	Fri, 20 Nov 2026 13:41:09 +0000
Date: Fri, 20 Nov 2026 13:41:09 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Xavier Xia <xavier.qyxia@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	jack@suse.cz, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: batch per-task lruvec stat updates on the writeback
 path
Message-ID: <awBN9VvV6yM6Cjut@casper.infradead.org>
References: <20261120095559.429515-1-xavier.qyxia@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120095559.429515-1-xavier.qyxia@gmail.com>
X-Stat-Signature: rapb6nk9ajb8rb6wr775axk8hwwcwo4m
X-Rspam-User:
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1EAA616000D
X-HE-Tag: 1795182072-865512
X-HE-Meta: U2FsdGVkX1/A5HhRF3r6pf2dezz/LivOzDM0HtGmC2YQNuOjlB0sbBJ4zogtdmxYIa2+v4dAUQ24v9zmFjzhPx3+/mt4nEJ8jcp9D2BuuSODdGsYmX8iXdQ2BbMfzxnCCC2QPRAHbJ1R+4xlEGvMfZGZpBENGGBC3BM29UzRnGNYO+MWEX5p/1jPoeadfO3b0dIOp+IEEBsUKkCb0Cxu1fniDgNOuBjpDWh15R29O99kAN/drCi+yWdklEbnUeKfaYH5htPhOOqoIvh0IH7RLWIGHhpHppyB9RfotGvpCOUoB2l9odpIQW7769GShF9orvFJjf9WjlXFgSIcwsQVWbD/sU4z6eyb46pUGfsfwJO+zFVZ4UAJ83dBUJkmRMyr7LPoSXFf0YAxrw2ffG/Y4+WU2SI6XlU99+T2xQackiX9XBMpgtDx22JayQvywB5IIVlyahCbd4rtFbgHGK6xcXJh4t1Oe8ymAoaDS/FJDe27veHyTCLuhtUVgbyIOqh77WtFipZwAzIyzaTdPJxEJqXeJ8qH7QqjJiL0kA53mrgSteNAoqdIdL7ivPywXvML4fViTgjfZNuFv6gdN9wZG98iew+LkFF315TTQ5Std6fHarMkHr5w2RHeThCdxd7BXpp2dR5mj/AgFOaORZXtmdXCVoXN3ACkyADOBPqFQ6Kmpg+5JBlAb/Ly0IHAaWh3/vdnRjgXN+O+g7rVxCCgrwPyLYZlJvKL6e7wxHXBdtpuFdCuEfxYOj7OsByt8ZmnU//4gl42TNjIUxGF60e1+MrbtiZpSKM2GNMDWuBjVl5V1w1sAlDWkWGKJfBWd37/4PqIuboLTnj9komfhQszRhh8w9FHgqPh4CLh1jBpn8Yhtvz6ozfrMbGZo6PBSJxwEWLuX4umgKkQNOAbPdcVDi3SblvUGQIPWCaaM0AeOk+fIft1/X4lEjK4ZryGfgL/1IdYnxfO0NcxT8x8BvT
 LnLQAP3E
 qN6BTO6KSpUHAU5152gVJ0RGv7x/KOUSsQnqOUyAL7DG/08NtfPlgqoDdPGoTJwaonUILvcP/VBRrndM7bmEVVbQ2el4zjSUAS+i9BARKjSM5O/QswhX9MZMJ45v+AGnoBF+7l2omWrs/vUIFCkdhVfmwFShlErs8Yt4QIYkZgyPGC4eTqerZ8o25tBVdxpnfO6keDNTOUbDz+Vah51gi0fLWp7pcLgp0z1jENSJtDIt8TLgB8fZOnoDYqK0iVYd2vmLt8ZL0X+Yd997ake4gYvu7DljX1L2+KCY0ilvPPWkgZc5tnhAaZ9Bp6bWca5BDET6mHsCcBdH1Jhlt6R8Twg+HxByNIPajN/MMvuW1eo3HlzKC34TQqPcLVa/PqmHQzVAHe0x4/amP/d3MA2eLMH/l+Y9hbGi5VEWbPzjQ9TopXQwQ35/iwYnbg9dvvhIEJsbcuKh6/5wt1ci6xBkaWaPQpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 05:55:58PM +0800, Xavier Xia wrote:
> The writeback path updates two lruvec stats per folio through the memcg
> rstat machinery: NR_FILE_DIRTY when a folio is dirtied and again when
> writeback clears it, and NR_WRITEBACK when writeback starts on it.
> Consecutive folios almost always share a lruvec, so the same counters
> are updated over and over.  On a 4k buffered write + fsync workload
> __mod_memcg_lruvec_state() is about 8% of the profile.

Is this a realistic benchmark?  Does it represent some real life workload,
or did you just choose it because it shows the best benefit of this patch?
This is a fairly significant chunk of extra code, and it'd be nice to
know that it benefits a real-world use-case before applying it.

If the real world usecase is more "there's some pretty high overhead
when flushing accumulated megabytes of dirtied page cache", then there
are simpler solutions that don't involve messing with task_struct.

