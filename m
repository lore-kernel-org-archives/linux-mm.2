Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0FBC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7131F6B04BD; Thu, 13 Aug 2026 07:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4A36B04BF; Thu, 13 Aug 2026 07:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600ED6B04C0; Thu, 13 Aug 2026 07:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3836B04BD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:30:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EC98A0101
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:30:14 +0000 (UTC)
X-FDA: 85096027548.25.05A89EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7305480008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:30:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bIIYvDgu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786620612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9aopBS7WCREPco4Au3BJaWnHNfNUNrAPzSVqlHVLHo=;
	b=vvskiqY9CRW+xOYnHSkIhc/Ls9cRbAedh3MPKphqHDlkg6XdJ+5Esf4oMf2X3nbzYbIHl0
	ucE+u551vrONvcB7o62Bi+Pc/E91JTzOksWWt1fzSY6AMUXqj6dPvJ+hkpxm7pUVvT8hIn
	Kl+ET3fnPIVxaoHNkbLQ0tzWS7cl4kg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bIIYvDgu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786620612;
	b=bpr0ql+zi1IbwEYdpND4bqY0NDSn2/ZRq/2nf85JG1/g9oFvYvJRd4jAiCtfORPt3gVgAn
	OLi+o5kWwRTZuNZsOqGvF6qY5JB6zOwSAr65jfdTgD4dHavdQ5AyC6K6+vHoOZ7fxwIc7l
	WAPM8XBThBWChjoUWi7MWEXcC9A8Soc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1DD343CC3;
	Thu, 13 Aug 2026 11:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515911F000E9;
	Thu, 13 Aug 2026 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786620610;
	bh=l9aopBS7WCREPco4Au3BJaWnHNfNUNrAPzSVqlHVLHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bIIYvDgubqyEPdnlOWTu+Ja15dC+1f7Tr2+yhC4Y5fv7Nej555T05u/p0Wyfm9C43
	 GM3rOb8V+MA094qoew/BBBOo0wyXDOc3DKe3Y+yV28mZ1L1Anv8grTI7pGOfMrpDPG
	 zE15h/BoP7UPMsxQGHg7KNO596rp+ufNqFnKkFGu75mTM1gO38FneofbDbyWoM5Zby
	 x2EB1SxvmPhDdae9aXThdHuADsUzEHeYzNaZEgJK+G+x59zQL4YmHMoj0kyai1Ej1B
	 I2aDuWT5tOB8uf+cEf6hDBVNqApz/4QtYzmJkzqRC9pxpnGItt4uJu+UREOF1tVUUH
	 UkTdVZT0+d62A==
Date: Thu, 13 Aug 2026 12:29:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: replace custom bad page map ratelimiting logic
Message-ID: <an2juJMHR8r09q5u@lucifer>
References: <20260811172156.356053-1-pfalcato@suse.de>
 <20260811172156.356053-2-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811172156.356053-2-pfalcato@suse.de>
X-Rspam-User: 
X-Stat-Signature: tbi41wagsez1ijft1rjk6k365i5qhz6x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7305480008
X-HE-Tag: 1786620612-679243
X-HE-Meta: U2FsdGVkX1+t4uBAUGU+Q446XVOA8Iu3lzC2fqy9/4ft2LlyPipPhWWtO9/YZaaQAmo+BAAHRglTNykbFYxVw+cjvZRfXf/CLY9RshbyyNB0EJ/++EMjCNzf+MvT06DgthtL6PzvfiXllgvQTvRTL4U/HUcSz/YZpefculhin+qTT3uYPryZnEPSaIR+/lMVuH5NWYJpTbeVqf3glbrByU/xTutY9WxPT3NRMH/UoMKrIpHAkq58b1LHddEHQ2P/2VH20MhHFGLgiTYSTMqwm/tOpnBxbmJSg8uQv6vpQ99C3Uinh7QF0IqeEZXEgVV6VnaJxDWqJHk6XVEVeE1RhU996xMaPH1BfKoZMPse2Eo7I3j81LCEVRO68J1oY3MICU7KSdG/WNM2y7xOQB0B2psOOHh75E7QQziZL4S05v6jQOJz/Dj7ZltnSNz5I4N2HvMQWWIfeHdQlVF427UDwXqJZyYuEGKIxJvnO1W06iAd6ZloEbxU978vEqbP7Fx5DUjoBXR5qDlvRysl5CxpNOBZDw5c64S1Tg7HdPunnfJW6Y2MXvZHp2prll/chrgUEFyX6L+tv13sLKt+ZGne+97/dWyH1Qv6ZV20x/bTWfE9JILsbDXXTWhFz+zZLcov2OXgSu/gpkI5mUziGsrJ7Q7vqXG4P1NWg1W0jUpD5kQ+MCdVv3vhyiUGVsWtPhOVMP5bltehugRn/VyEsou1aUbHBWhtmFynemJ6LOWESQwI1+rQMJMoxythlK1RuP1Dw/YubFZ3cVBmcijBBlYTrMaJVOBGzaO3VMis7iazk0sM+7o5YxeyvTyDdGsiBYMwdZWPWVDVO3wAG0QDQtxTp+CMrdBVOBh+embry8vxF1q9Gq92X72rstTYqzRilE+MNYgBUV5VFnCHxgQJO+L0rIiILvbYVwq4be40TIm2xk7t9bu98sgtglrMu6AUFqq+oGt2dNt5nzb/uT3hUz2
 FzvKww3P
 qGtiuY3ZzK+gQwZ51FYcGxxUGPHaHD9poeqtmkPOfnH4vEd+E5ZDIKAj603XsHSM3NIQfEIXF+NGNWpCzTuGnIBh5CwQfiHpLTxuJGY/4g6puEjfFolSwsV5zGugyNe9J+4A5nF9mYFIL0gHNUcJ40QgfwEQWrrYb5esit5wkyC7yeA0gPsiAYJXnAodidbvzrgteGhWUyb9esFDDybzZMFgsLwQipaF0p7vzJLJmNNBkLggSTyM1HOGmMs2BemPwxROPI8gw7fT30qaGLQ4eS1fEmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:21:55PM +0100, Pedro Falcato wrote:
> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kernel.
>
> Do so. The only functional difference should be that the new logs will
> read something like:
>
> KERN_WARNING "print_bad_page_map: %d callbacks suppressed\n", ...
>
> But that should be fine enough.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Oh I love this :) seems __ratelimited() uses a try-lock on a spinlock internally
but I don't think that's an issue, a spurious not-rate-limted output on any
contention isn't really a big problem.

So LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 30 +++---------------------------
>  1 file changed, 3 insertions(+), 27 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 4134ac607ee0..b4be57b590ce 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -492,32 +492,8 @@ static inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
>  			add_mm_counter(mm, i, rss[i]);
>  }
>
> -static bool is_bad_page_map_ratelimited(void)
> -{
> -	static unsigned long resume;
> -	static unsigned long nr_shown;
> -	static unsigned long nr_unshown;
> -
> -	/*
> -	 * Allow a burst of 60 reports, then keep quiet for that minute;
> -	 * or allow a steady drip of one report per second.
> -	 */
> -	if (nr_shown == 60) {
> -		if (time_before(jiffies, resume)) {
> -			nr_unshown++;
> -			return true;
> -		}
> -		if (nr_unshown) {
> -			pr_alert("BUG: Bad page map: %lu messages suppressed\n",
> -				 nr_unshown);
> -			nr_unshown = 0;
> -		}
> -		nr_shown = 0;
> -	}
> -	if (nr_shown++ == 0)
> -		resume = jiffies + 60 * HZ;
> -	return false;
> -}
> +/* Allow a burst of 60 bad page map reports per minute. */
> +static DEFINE_RATELIMIT_STATE(bad_page_map_ratelimit, 60 * HZ, 60);
>
>  static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
>  {
> @@ -633,7 +609,7 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>  	char entry_str[PTVAL_STR_MAX];
>  	pgoff_t index, anon_index;
>
> -	if (is_bad_page_map_ratelimited())
> +	if (!__ratelimit(&bad_page_map_ratelimit))
>  		return;
>
>  	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
> --
> 2.55.0
>

--
Cheers, Lorenzo

