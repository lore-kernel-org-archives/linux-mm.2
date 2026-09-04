Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E93C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5963B6B008C; Fri,  4 Sep 2026 11:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56D616B0092; Fri,  4 Sep 2026 11:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BF66B0095; Fri,  4 Sep 2026 11:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B77B6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:25:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A27C4A0129
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:25:13 +0000 (UTC)
X-FDA: 85176453306.07.D0379F3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 88D2A4000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:25:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PQnp9ZT3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oUdI6azy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OSAW7qDb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/0JDl6m8";
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788535511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uegA/dEm0BMFL81peUN2ZxZ/uAgFp0QibfS0jKjF30=;
	b=s3UJ6SN9/Tw5dNvIbLZaLwoKItb7OtOUKui/4vJZEwrA7e3IlacUmFcS+0Z2QlRmWPkCXE
	LQoNu/PLohfPqEHyMl5t2lWkJc8fA+oteIZepTRqqJB68jOMu9jHf0BlwaShNoVifAaYLh
	VoQnZmXB2O5ts6ihwcJHSQW0ViK+TbI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788535511;
	b=WKrIgrRXzYqJMmfmtrfl/Zg4UgiJ9ZiTz26k6cSYAhOtzn13AJCnQ78q52LghmlRTxE+Xe
	ZlIOqnBNcvX08Ij/q/IC4E9tlzxlULHRIb4vHtCAj60dK1XYsUBvrE3UnsnIPVVH3FJiI4
	jFeFezgWutXYS8GKBBFPd+7A/fbg+Lg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PQnp9ZT3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oUdI6azy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OSAW7qDb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/0JDl6m8";
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B67401F8C0;
	Fri,  4 Sep 2026 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788535505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4uegA/dEm0BMFL81peUN2ZxZ/uAgFp0QibfS0jKjF30=;
	b=PQnp9ZT3hHw+piKXvGyV4Lwj4X/GkvOuYhqt8qPFzJDLekXnkVVi1Yy15nmTvLl4Pc/gYE
	3lgnZGjdpBd1CQ48Mgu33rGT8vxbYWy6XiO9QKcr5iFFlEfrHNRXe6IqcwSrxTe9UyXHp9
	jiMeF9GzBs1nhnwN7Aasz0XjwVk8RdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788535505;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4uegA/dEm0BMFL81peUN2ZxZ/uAgFp0QibfS0jKjF30=;
	b=oUdI6azy3DEZZMOxggEoj+qxOzOfU/3si4iKli3LjdvBgfe90ZWpeLLeMnkjxJ1yCVohM6
	qII66s/hDabjttBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788535501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4uegA/dEm0BMFL81peUN2ZxZ/uAgFp0QibfS0jKjF30=;
	b=OSAW7qDb9UllVJbDZJH9jLc59GfVrtVtYbccNcTCFH5sN05qgv6qjDTBfEnZKLIwieE/u+
	aYH96yC4sLu67ljvJOjqMjN6PjxmZhCoN6tHwMjtPeiuvSe2FlMY4Xdt/Zaeyb00RqsfJR
	+jdTY7p3q23jzkOiFtHcD9V++vu/4Kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788535501;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4uegA/dEm0BMFL81peUN2ZxZ/uAgFp0QibfS0jKjF30=;
	b=/0JDl6m8kBmKKAoeUdRgqGF1pkgFIWiKi9yX3LQjW7zB7Dt6SdbLMFZV1EXZwOUGKENRUp
	bfyV8+WP4zCiRaCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4BA413726;
	Fri,  4 Sep 2026 15:25:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WjKNNMzimmpRAwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 04 Sep 2026 15:25:00 +0000
Date: Fri, 4 Sep 2026 16:24:59 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Message-ID: <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: rt47hfww3z4bnene1dzmegzp7kd6xkpq
X-Rspamd-Queue-Id: 88D2A4000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788535511-355570
X-HE-Meta: U2FsdGVkX184sH4GCdsTwa4Lm387sXN7mhiW4FhUyrPEqDfZPGiPuYW8eZET3TJ4O0J1g+jilMu8w6YW+ICf9bB3kxkQAaJxJd28QXIeXCQFAPFpZfCs2NBqT6WdoEJ8U2cf4aa8DWGgggRFBtcwXU9JXcRSwpdTJBMSVgVmeoDIek1dcTbhZixo663rpoHYkEWlBBDDE7QGtFcI9XZyYE0NMUBVXOXEalPURmnV9lUqlVqj/540v8dEJFT4DlLU9euIfa0XjmFpqLan2ZyL5p5De9zrdYkH2ryLLICgJM020gi/K6ys9JwwR05M9JzMJ4QWlPMt9KksQgZ9k809ehSk9r+s3EP3ESveehvLt4cAf8jeAiy/7/vWyQBW9sR8WyWD0z5K9NAwlQRz1+lKoQXgGmMmqvp8i8o9Rw3w3LNg7Z+h4xQeuA/kSXK5C11MkPECiErzvHvwnWsZd5z2kVgi4gpy7uMo61ck9/AEwDbBUthH0vprggglYkk6Xjt+9RptopjqHPi3PJ8G5pX0E8hQ6eaKTsN5qWc5HjohvRZ3htUajgRYKa/W10eGkfX9zcApAVNQegtbTCdf0ExCLWNeMYu5OSxmIeuRrm8tMXUI2xVLAEIm1IIZkTuukufntvg/sKkIgZz6svpAZjcar9Uzx8H3IOLAwKvjPvWR9x2hzxPkVA1daO9n626/7nhqJCCvGCK2Y58ujPyp96Xbl+9rl2L35MPjnPngDwPv1qrY2B/kEY67Z7VkAI6Ka+lbtkHr/ntLVe0VdcT9cwaQWMWgshqeD4a4/yu6dCsrs9/v6G14PR3jp61/g7ovcoKBaKmKn1MN9oRzr1JfuIXgVHYQv7zaHyBAFaeFXuXqccUHQiD7osZMR5aVskAdYroHd1tkGNh6Uc1TtV4wEkvWyaf9LukkzjLe9n7pVGVBjq7a/fZT2tVEs5/WO9jQRez/0o0nS6ICTvEApVu4c3J
 v1X0K5zH
 e4yZwxQQLc/eB94vKQSrOzpWp3lNMtyqqB8c67O/ad2KoXlfk31XtpQujHBCq16yl/sYm56Mcn7JZxqz2ncV5u8HCpycHrz7WZQnqoyTadV+bQ8xWHM5XdhBmxZvdMGBxibVLDHTf9vh+gZLzpiyh54xn1ndBeP74CTiJlsRBQbOT0AmSNTbAa5LColWNcgcFPfjf+zz13MpK7GfIRSO3Ihi01D1q4ZD2dGsVxgvCKoDwDr5h0Yxz+z3ovtwHbzCFMMB5MPNhd1d1RAPYWYpqVN6SRSRbxz0DYGg60fIe226yMceUE6JtA6860WJaBOlEEDTzHn+Xcze2assvl8GJkk6D012790t4uAM7t/SPXpr+I2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 04:12:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> for the former and a tree walk and swap in to swap cache for the latter.
> 
> MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> as if they were purely file-backed, meaning any swapped out private pages
> remain swapped out.
> 
> Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> mappings and performing both walks in this case.
> 
> Since the logic checks for vma->anon_vma this means un-CoW'd
> MAP_PRIVATE-file backed mappings retain only the single file walk.
> 
> Reported-by: Mike Kaplinskiy <mike@recall.ai>
> Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/madvise.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 73c2901b9adb..d0510dd49dde 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -297,10 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
>  	loff_t offset;
>  
>  #ifdef CONFIG_SWAP
> -	if (!file) {
> +	if (!file || (vma_is_cow_mapping(vma) && vma->anon_vma)) {

Couldn't this all be simplified to

	if (vma->anon_vma) {

? swapin needs anon pages to have been faulted-in. Non-cow mappings won't
have an anon_vma, nor will fully empty anonymous VMAs (and that's fine).
Right?

Regardless, looks cromulent

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

