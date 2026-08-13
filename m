Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0748C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49306B025B; Thu, 13 Aug 2026 09:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF98E6B0271; Thu, 13 Aug 2026 09:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A121D6B027C; Thu, 13 Aug 2026 09:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80E686B025B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:55:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12452A017F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:55:47 +0000 (UTC)
X-FDA: 85096394334.25.7BA1F3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 701AFA0009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:55:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yu23tjCZ;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4O5XEeZocNetZ7qyN1aDqk/yfr0Rg6N9g8gJngopdVs=;
	b=G3qFsXXIToO/V8PkRAPu6ljSu3h0yJw0fuSRTsXEF+4dTelK00TSHtaJBo7ojb9d1tT+IE
	7LYq7as7MTPc1iIxKEhts5RZhsN5ZppM4z3sE/N0fZyMKin0cLO8zd4IEfZfF5c5Sp7VcC
	bj2uH0H7MOr7lEU+Hnq9IWI9wtjmmzw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yu23tjCZ;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786629345;
	b=EnjWzk89mCEno66NwN2reGqtVlyhtEF6z9KoRGQ6B0AY+weZoMH222M0X4s7kjdbEsDKc9
	cwqvCjjYTkKA5Holng7rG+gO393h/PblZRVmBYB54anZtfuDm18xULCacQPOcBwixJhgXd
	zuh8J8vFExLUTvz4KKOFU8Hi759enkQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 418F841441;
	Thu, 13 Aug 2026 13:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ED21F000E9;
	Thu, 13 Aug 2026 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786629344;
	bh=4O5XEeZocNetZ7qyN1aDqk/yfr0Rg6N9g8gJngopdVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yu23tjCZTaClsSYTUZVBfgHQKBSOkirzVAcnaBgutxH09oGFlO3vY8s84vCwbzaXa
	 3MsipDR3OXfZAOzTfFYI0hveMI8pfrQe3BXkS2cnK5T0nlhFL+/1f45+MvwdHV23mO
	 FpPBVSPHVKd53yQpWkMPBVQ/Bk1LqgTdpBkwegnAgQJN8p7thuOYHKUWQE8HUnNXKP
	 9WptMNFyWIjSThMt7zIdF7QA6EUC5lyB2X0tgNffQDjWX1V0/6toschDQ86Po6vtQz
	 hhWsda0gXwtJO8rLG8m5BSiMDFMCGUz6w8pJZZT6rGL2AeirNzH+9rILcqIJkewFZd
	 1cGx8HeJab9dA==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/4] mm/damon/core: handle NULL ctx parameter in damon_call()
Date: Thu, 13 Aug 2026 06:55:35 -0700
Message-ID: <20260813135536.103668-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ed32d112-2873-4e29-9d4b-d5bc72b70f52@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xok75t7omnm4yba33wfyoepirgbun647
X-Rspamd-Queue-Id: 701AFA0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786629345-46486
X-HE-Meta: U2FsdGVkX1+UThGRM5oJMUbH3AsieltaQXSsEg0Dxxkckb3sfKMlNLxw9eESPUgIoDwCnYFyqOejoBX+Yp83Ivd0uFC17xFvDPQxbJkBnNhQHPwud0viq104p9OY3jcV0JLq9GYuJoO+RweybVTD9ctoBN9JDrGQnq6d/YUnN3Q1eQp8FC9a8JJcVFTe5C3z6KckxA7LMjZe1oMLUwjY6bO+gTzhi2Jvg/ArAWMWTq649beUNrC2O2LkaAbeoOmsHE8FCY13nfVDQumJts7crjZRcSnQjbrTB0wjTPEowvUkRZUCl0gc+xU4UFTT0fZ1oNpAyhubb5gjYGppj9CAXDLqxqYyjO/svnj0A6s/yxmucjcbczzibrjkdwunWOjDfAJx4nQlyjjGBP4dhgqmE+1Wo/tr4Lte5r/mHfcetyepZnx0tNYT8+j1OJ/XC04JYuEgOZVB9hleIfD168xIO6xP47AT9yGH699GsRzqK+AcaN3LAGXOIh+d2pioFKhuyoDOGmXVbke+C/GBE/OzMK1oJIlod1O9gEtHMPYEH32WtcX0Bl1HZ2QO32p9370FbdwWlA5mgyOCHhHm4A+OGLt3H8veHU1MJu6OPMDj8U1X0Dgu+QCX47AEIoRAEZQRnU6Vk5u0bgdGeI3fLOpZeL/cIfDgVU2GrZQqLyjv59qZBtSvy9mF8ce1OiMp6BENczNTaSvs+vpKtnlmQZeRHLHxHziqABdjD3BgCV4t5BzqLLS+2+AX//cF2wKVLqQaJMmlKPKW/3+q4yIOliVxpfMh/NM2e0wCIiUfprTjEssAmrbBZjmSXVAmOSCr7rSl8lOK5QYeBlYLRiJO0cY4/CQURgfs0iyWD+i+6jV8UBiLCiGYYsZwf5OHSOk0Zo9mPd7CHyS+Yghhpg346TV/1T8V6PMRMIgoi/E9YYauZPgDp3Msd140umwodMiVCj/9LMcqHB1BkSYGSsLwHIa
 LMxZmrDi
 It9LxHOSX3bn/Jt4oEa95LTCTXZA5F48QIRjEDsYG6YyTS8Fs97Z+VHOdPV80H7xZDL+hp1ODwc2UnHhI0CYGpHubGo25kmCnEWMrt9iNLYn43mE99ajgZ0cT9EnujWka2fapf7oS86FNDNvV2+jEoZX0naH9iDJnA8nwKnHg+PtErRuXr1X06ejl0ZDEm4GJbTpQalPdri8/fii3w3BZ1hEgmxbbOwax3f3xG/stlpvR7jiu9Ngj3nGcqxFY+UVSpW+bjZX8NMWP7TcxA0tJc5ERI27WhkqVKZvUkpj2B30gpMCXzFKCP/C81r03bPHoechKWFFHQAgBTdIgb7ohWaRweQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Asier,


Thank you for your review!

On Thu, 13 Aug 2026 11:33:01 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 8/13/2026 6:49 AM, SJ Park wrote:
> > When NULL damon_ctx pointer parameter is passed, damon_call() could do
> > NULL dereference.  The caller is responsible to avoid that.  It is easy
> > to forget, and there are many damon_call() callers.  Meanwhile,
> > damon_call() is never meant to be performance critical.  It uses mutex
> > and completion.  Add the NULL pointer check inside damon_call() so that
> > callers can pass the parameter without NULL checks.
> > 
> > Signed-off-by: SJ Park <sj@kernel.org>
> > ---
> >  mm/damon/core.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 92631a36d7b51..5882f9c94c47f 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2188,6 +2188,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
> >   */
> >  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> >  {
> > +	if (!ctx)
> > +		return -EINVAL;
> >  	if (!control->repeat)
> >  		init_completion(&control->completion);
> >  	control->canceled = false;
> 
> I know that this is a minor optimization, but how about moving INIT_LIST_HEAD(&control->list)
> to right before list_add_tail?
> 
> It doesn't make sense to initialize the list before checking call_controls_obsolete.

I agree it might be more efficient.

I think my intention of the code was to to keep the call_controls_lock critical
section minimal with access to things that really protected by the mutex.
Moving the simple initialization should be fine.  As you mentioned, it should
be minor change.  I'm bit concerned if it will confuse people if the list head
is also protected by the mutex, though.  What do you think?

> 
> Maybe this suggestion should go in a different patch.

I agree.


Thanks,
SJ

[...]

