Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4078010BA420
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58F786B00A3; Thu, 26 Mar 2026 23:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FCF6B00A4; Thu, 26 Mar 2026 23:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47CB76B00A6; Thu, 26 Mar 2026 23:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35D996B00A3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:20:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD0FE160F45
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:20:01 +0000 (UTC)
X-FDA: 84590389002.08.9694688
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E3AFC40003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:19:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Nm8XaPoE;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774581600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=byG0/GC1tLCnqfQOH2VXIvflcSzdYAjehV1sM5sjbmA=;
	b=GnWNXrjOQxfre2KhYAUYkXY16bk3k7AyB+fznqNPxjnG6nbt8wZDAf7CXnY1upJ3M4X4xs
	VPK+hBBHbSi710qFeVtWhsJZCcYPDS+kpb8N1UgxATsTcwBCKEEEsRYBIlXBw0M0FZrUMt
	bNJlWpv87v5Yw7a0qn7BTs8qpFDsb+0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Nm8XaPoE;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774581600; a=rsa-sha256;
	cv=none;
	b=Dj7Dz/bGZNkpsRGJTzyfbNblhCVTthKbjHzpsIS6j41bPYPTM1X9mEbdous+5l3SMz4Ydj
	adxSTAEQZTZJqMgnh62zlGZ4t31YIr9gN842aDw+DlVPtg9w47dfFA8SrgHLbpI2Wqi7W7
	23+5Wt4BYrRhoXqjcPScXdVcvtyVe1Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCB44416F8;
	Fri, 27 Mar 2026 03:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90605C116C6;
	Fri, 27 Mar 2026 03:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774581598;
	bh=uslss0Q2m2BhB3EMWw1UIGYfQnXC0XxVkAweZzqzFsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Nm8XaPoEl8Lns7kP8c3g7ltMfa0eg6WKI7mu9DBSycHgh9UaRKmhK1J3E53pTVQbP
	 aEy/wxWTL//5S0VWVv33bgE9VLcUk65nh/IFZ9UBtdVor39nfRFsgVKdPdT79Kp5JY
	 9r1tHgAbzRcuH8DW80ZBSjcT9KWj2aJlIeCr0Nas=
Date: Thu, 26 Mar 2026 20:19:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Junyao Zhao <junzhao@redhat.com>
Cc: vbabka@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/page_alloc: fix indentation for VM_WARN_ONCE
Message-Id: <20260326201957.d064134395f3b832de29d048@linux-foundation.org>
In-Reply-To: <CAMZL0nYFrtfQbVs2F63S3y1kDnLGeQpURxd+OqGE3YkZ7Ad9Tg@mail.gmail.com>
References: <CAMZL0nYFrtfQbVs2F63S3y1kDnLGeQpURxd+OqGE3YkZ7Ad9Tg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3AFC40003
X-Stat-Signature: jgeg6j3ijtpq7j8b6rxmi3urkoohb7y7
X-Rspam-User: 
X-HE-Tag: 1774581599-111029
X-HE-Meta: U2FsdGVkX1+9PjsLTBCbWkL7qz2+D5t8m/GCOxRBCzPu/vuKeBiycr70algTpM9UurKNLY3RRCIHOWcDJpW+es8F1iBWaEJInIav/xdA1/xjDML8sFqJztjvT9CUvHSej1BMkKRAru1rH4WHeMCBqaEL0+mX6jT37S6QRAH0T4p2opLz1B1SueJljp3TA/6a5bVON/FlC4t7FRD2seDjAMdIytKkyJTZ4euRyP0wggSw5VT4SnXVikrEpiKI5j73waLjoW/BO58iihEVprHLnnIFOw3ZsznyOuaGbIIzhjsHEMSzKj9x0kqJNshWzQmxNEF6VETfK9CjRCOcpKt4xIETXR0VNuItzn3kHjCTz0zXNMwdHV3vpNHU3FSGMDrCfGHIuGelADyQB2Ge6mDitwIO8LwxrULRIPBTI0OldZj6U0PKZGuPLc1yznhp7RchvvY4sZ+rweEH/a7D/c13MGaa9H3c9LW8MXRvqZhhZbRO4Ic4JT5BjtfftiG04hVcZc5VvvNk7S4rPGN6cDUlKAbyHF/IGUFnTOkmmkPbsM0rIuFe0cJXbdpdT0rvryFowGA29VMjKvDf5hmhIVvs9A6rkMi0DUdazNn2xYIeeYG0P4P9OjFmQifiubligDwHApML8Lpi8vhQPY5bxBfVKnJ7/e/hglDPN0kBShVpa3SnHzcjheyJFMgbvhSDpm/j2YOS3yBv1tgJH7IVA4XuVYkbxz3Zbb5R6xqLG+zqUzlKEjAMaUSLWaZ2/6K6GR1gS4IyNL/4ghGm4hnx+we51zdV7LVO3gYECpfvX/8GbV5q8l33Np2KlhcJGuAkxU01r/rxcc7xBCSIBKr4LEXUc7niy6r2LJhQ/CgT1RpwbM+mCbKlAj50vNzTqS+zFghiDehhpQOsiPbd6Q3pid+qRJOfbStXHJH7lslQZ9oWlf0bkoHlYNiszy2Koed6g61g0FISXgehKz125hMAsQz
 VIF17gF/
 1TeoOHWOZE2l6rp/MBn/GoBNnC62XBVXnkvrDLj2qQaLLgNxwThqYHx4NjBwcGNM02qfPE9r2aLNsm7191O9LMYgFED6JKDpo/G0giiYsuLISNwU9mlVWe4lbqc2Tb69poEhKmiBBKJZ/cJ9XiKlI65UW68ormlLNJc/A35XSGneFa+i8UzrVHXlWlHQHE4CRCAbFYMyIHAMrYIqy6anQO6Tf5BEhABnJ5CgTcvbF6nebPAYwsUBBrXQCBf9DC0rJdeaCTag7n7K+XOVgyU06fDDSkV+uuxqrTn+kEGlrh0XNId2ni8UOsoYhHwS9SbO74h54
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 11:00:19 +0800 Junyao Zhao <junzhao@redhat.com> wrote:

> >From d7442d455218ffff67f890bb39d273d7555bed1c Mon Sep 17 00:00:00 2001
> From: Junyao Zhao <junzhao@redhat.com>
> Date: Thu, 26 Mar 2026 04:58:14 -0400
> Subject: [PATCH] mm/page_alloc: fix indentation for VM_WARN_ONCE
> 
> Replace leading spaces with a tab to follow kernel coding style.
> 
> Reported by checkpatch.pl

Thanks.

This is rather too minor to add, sorry.  If it was modifying a whoops
which was added in the current development tree then OK.

Also, the current development tree's __del_page_from_free_list() looks
nothing like yours, so maybe you're developing against an older kernel?

And your email suffers wordwrapping and tabs-to-spaces issues.  Please
fix that email client configuration next time.

> Signed-off-by: Junyao Zhao <junzhao@redhat.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..d2e04ecddb8b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -884,7 +884,7 @@ static inline void
> __del_page_from_free_list(struct page *page, struct zone *zon
>  {
>   int nr_pages = 1 << order;
> 
> -        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
> + VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
>        "page type is %d, passed migratetype is %d (nr=%d)\n",
>        get_pageblock_migratetype(page), migratetype, nr_pages);
> 
> -- 
> 2.52.0

