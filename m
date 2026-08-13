Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC9F5C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011566B02A0; Thu, 13 Aug 2026 11:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05436B02A1; Thu, 13 Aug 2026 11:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1AAF6B02A3; Thu, 13 Aug 2026 11:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8D126B02A0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:12:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E126140180
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:12:40 +0000 (UTC)
X-FDA: 85096588080.26.244AD0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B6066A0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:12:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KE0pDsWi;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786633958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mx0MxRllchl62Kevt41rGLqe9TQSGfKjDVe1jsUGnDA=;
	b=I1cq+rRh2OD6crgUyfkcHVW75pFbk9XBUFy6fKTGGDVie0i3aSKa+u7w5+ifWWhyYGZlzj
	2v8dnt3KO2YuES1kUI8dwRFYSTzfW0agw4oShnSYLaNHcgpRwm3J2zKYmfI7gyh4Xomtfw
	+bUg5PjkmKLkUKfVn5hhynC3DZ4V1n4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KE0pDsWi;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786633958;
	b=ZcXg9kTw/txQvfSFoeoGvUe5ZGi1BPZz4GV1N7Cy12sMzBf7r1FOZYWWYJj1NOpO0Ct0jZ
	hvfMW/Q5KVnjBnX6dr5fQDm62Xc+168ntWU00xF+6iiryo6Od9lqKiZobgtTHHLGCZhUbn
	RhJJwB+MQb5rciU3QGvjJjpdQm6wqrg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D64060A63;
	Thu, 13 Aug 2026 15:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B786B1F000E9;
	Thu, 13 Aug 2026 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633958;
	bh=mx0MxRllchl62Kevt41rGLqe9TQSGfKjDVe1jsUGnDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KE0pDsWi0VHvtpwwCUK7kkil0WqRMnS9XnkTYhjQvgpWLMtedMJrB/zdxB43FOWPV
	 V3dUtzRGG6c6fLo/ehOpSrSce0+DsJYj10kWs3ED/K/j0eLMzTRquSkSE9B1oGxmBQ
	 MazZC0ilcmg89Mhhe0BKDWWNIWpmC9LEdpvfjXJNionwU7VuyAgD0/e5ajOfIRfXDb
	 zEw1iUuwbjQG8oLmBn7rODq9Md1PtoVi5ZSE464lrYjDeTcUpOkYhjpG60n5+98ojR
	 tjaTkkX9AFthobROfM7NcJO3zXQfrao4+mlKGUUDv6Wv0jevbIy99WsLND4a9bogz+
	 y0bdXvUQFbOiQ==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/4] mm/damon/core: handle NULL ctx parameter in damon_call()
Date: Thu, 13 Aug 2026 08:12:29 -0700
Message-ID: <20260813151230.104083-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c55a94f4-6ad2-4b60-b0ce-bf670dcc2f7b@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6066A0002
X-Stat-Signature: fydgqnu793aup4owjdjc4tr5m8hwcjq4
X-Rspam-User: 
X-HE-Tag: 1786633958-225243
X-HE-Meta: U2FsdGVkX1+auKKc7VbpagJ2sWqpz/UDuCH+UgOHFtaPM3OO4ePAIATO+QzYS0ZQwkXOh+lC82n1wu2l41xmwky5Rp0B4qyMx2i1vbCfgAFtQgZQ9+KvO13EK5UYdX1c9OBjGGBrZrabBf/6hj+gmDcBy2UhETJRRqAz+lAx8TLK/SFogqWlclsq3zADZ/37vy8Hgge4OoCkQXg0vB5Hj1I5vRiQSlHd19B8gsyoarfwuGVNkyTmtJ098F7bFL4U5CFqsqMkIHeFLsLQ0uzH7pvz6qUehj0nN8IChlRX6AfqenlWQXt5aKDw2FHBiJki2AC8qu2jKeIBQiJ4B9eGMlsgEVda41MdHLlyKCDIqaBmpqTg7fM8/OBeDvGEZCHSpvA28RWYcOPx1zwPrQYaTyP8XDrHCTeGLKBqXhtn5Ux2E0nORdGHDEHQPYBP9sdqkzeWvuaqPfMBffnp8NzzPgZeXUMtgS+4mtYLYBu1KkZ3xdWfHai9/gmCyEcykWKLnUUXYyIA28wCASf/R0JAJu8DY8KxhaLyhqliapba7n3zbGoU6S9L6UlLnviev5h7xQR8PVWE88fvhV+W4cNrOaDyS7x8r892FMLehIXZYiTjay17IGhDiM3eowc6KuYHQu+gbICwSHPk21EgFDqDZys8PTWU26ZIMM0fNZeboRz0Lq7nSGZh7BcUm8tnUQM/OwhseNZbmx3ai7Y2lJ6g0sfcnG4flwf54t+l4G1vO2FMI5lGFApndLUKc1B+/uoXiJKFGsIp84x4x3F9eL6K+p97cJs2gIL/w1jFvXFEOdbseYDtkwyi2BG5bSXM6il4cBv/SUuEr7ZsaVNFFwbOhwybpDfTjlCLQwduyT6O6Ad3ZgdDzdNcAqzw8F6UBkrMkAGCSmoktjhSgEipLWLH+B7jiOMXLRo5krIWXI1WStOfkYkYyCQVnVXEVALbwbF6O7+a5xAFcNrloUeuDgH
 UZ20Aesr
 LySRdxze72m4rPnC67LzJ9QIvy4rZzT/V8OuWwwox4BykPcBF+QOWiTbwMvxdiQFg7554fAITJ+Ahdg0Djai2VxtGmHocQMbY/Z1qX9iAQS3kSblAzhOKfZdKujigp17GOz0at2iAqBpT3f25LLgu9ae+5boP3nuW4FvHWYiPRgoXJrfnTTQYgv7duoBP0wAmWudmo46SqM5QqL/wl/WBqrCRZp+Mgp+bL50jYKwwdWCBYPpWu/4XsBkAJBy+WQyRdMAoDwFYa+6Lc8bMyk6b5uXjNL+Z57VTujC8KcUn9DAes2QIBgUY79jFT/BaNZXGa6E1JOtvwki+YL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 17:27:51 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 8/13/2026 4:55 PM, SJ Park wrote:
> > Hi Asier,
> > 
> > 
> > Thank you for your review!
> > 
> > On Thu, 13 Aug 2026 11:33:01 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> Hi SJ,
> >>
> >> On 8/13/2026 6:49 AM, SJ Park wrote:
> >>> When NULL damon_ctx pointer parameter is passed, damon_call() could do
> >>> NULL dereference.  The caller is responsible to avoid that.  It is easy
> >>> to forget, and there are many damon_call() callers.  Meanwhile,
> >>> damon_call() is never meant to be performance critical.  It uses mutex
> >>> and completion.  Add the NULL pointer check inside damon_call() so that
> >>> callers can pass the parameter without NULL checks.
> >>>
> >>> Signed-off-by: SJ Park <sj@kernel.org>
> >>> ---
> >>>  mm/damon/core.c | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/mm/damon/core.c b/mm/damon/core.c
> >>> index 92631a36d7b51..5882f9c94c47f 100644
> >>> --- a/mm/damon/core.c
> >>> +++ b/mm/damon/core.c
> >>> @@ -2188,6 +2188,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
> >>>   */
> >>>  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> >>>  {
> >>> +	if (!ctx)
> >>> +		return -EINVAL;
> >>>  	if (!control->repeat)
> >>>  		init_completion(&control->completion);
> >>>  	control->canceled = false;
> >>
> >> I know that this is a minor optimization, but how about moving INIT_LIST_HEAD(&control->list)
> >> to right before list_add_tail?
> >>
> >> It doesn't make sense to initialize the list before checking call_controls_obsolete.
> > 
> > I agree it might be more efficient.
> > 
> > I think my intention of the code was to to keep the call_controls_lock critical
> > section minimal with access to things that really protected by the mutex.
> > Moving the simple initialization should be fine.  As you mentioned, it should
> > be minor change.  I'm bit concerned if it will confuse people if the list head
> > is also protected by the mutex, though.  What do you think?
> Good point, I didn't think about it.
> 
> Given that damon_call is not called often, I believe user experience should be
> more important than efficiency. Anyway, you have the last word.

Thank you for the quick answer, Asier.  I understand you are find with keeping
this as is.  Let's keep this as is for now.


Thanks,
SJ

[...]

