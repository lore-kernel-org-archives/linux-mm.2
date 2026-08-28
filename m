Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A18CFC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58AEE6B008C; Thu, 27 Aug 2026 20:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BA16B0092; Thu, 27 Aug 2026 20:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429E66B0095; Thu, 27 Aug 2026 20:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 142106B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:41:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88671A0248
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:40:59 +0000 (UTC)
X-FDA: 85148823438.20.499B1C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C5DE3100003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:40:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0v7eLd9;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787877657;
	b=SPJZxuUfKWuIHs2h2TJZhfhFRWsIUr+W3Fj5HuLOOBFkmlK08P21LI2IfD6oeco/swpnWS
	m5C6Ocfvr9O5vd2sLCgIWZD+FNiVxJ62g+L9ifxqMAuNkEvYtLox++hZVJvyXghO1MKJVX
	7Hyr82b+FO28wyKvBSDsxKmqrnR/C9w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0v7eLd9;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787877657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3dYuQBwRk/xR09vNJREZ7Cj/0z5bTktPZ0KJHmO4nE=;
	b=pEPWNrPcSQ+MuuCAAWes2XFMHqp4TWYNvHJ2TC0q6FBv8qO0WbHatHBNCtdsrHaekwowAi
	aWV/8pl1yXhQwJbtc3aiu2h9f8shfCPqZzjKChxdMlWi0cAJzaeBhAV8HVJOg4LfGwt04u
	VUK+2yf9htOxIcjlHuxAjsy3m9K94sM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7C7D43753;
	Fri, 28 Aug 2026 00:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6454F1F000E9;
	Fri, 28 Aug 2026 00:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787877656;
	bh=C3dYuQBwRk/xR09vNJREZ7Cj/0z5bTktPZ0KJHmO4nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0v7eLd9EuTh23YcZbaWO4XrOIMVKWuFnMqXs9EyOKVDR16db5yb5hnCDj0jjGgaz
	 91cSy0G2tEhgOhtlwU/D9jwUIK4oEomYN3oLHX2anKUuG6GoP439kfjrCDCsOvb20z
	 7N4r4MHPD1jwFoESI6l9WYcpYp3Q2Nj9V2sVm1R/EhN1sc5pvRjyJwiA5ImoGtI15y
	 JytMYBFzprHqP/B/rvaoDLfywpsXO5C76QdkcEgdK+jABlbSkuWD+kthvWJgzyjSfR
	 apK1rR+JTfs/0SZuN8fO/Q+Esx9xxa0Ewi1vDHXe4C3ki4C3UnPkAyEETcBZbHxdyu
	 HsBH0IK5oKrrQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Thu, 27 Aug 2026 17:40:48 -0700
Message-ID: <20260828004049.62386-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827180822.4037-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: u7er6iy476ftkftzmpkqs1xk73ch5u3i
X-Rspamd-Queue-Id: C5DE3100003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787877657-2426
X-HE-Meta: U2FsdGVkX18Tz2SKFxlloEj93nRsGgTu4rZyleawIb59tsIfzMeTfGarIleopP/2s/c4b5vu1hDIV14HHQhgmiGlYCY8+dS059RlQP4UiI8uP00R9yc9jDwNG3C/ppQuhPb7naIGneo+IminnSAH5rObAFYZTmqy5QmbFACjozWOnP3AoPt0TM9sfoYT7KVb9zbSm2GVsPPl7eT5GaymEbP7I6nkANrIczFqeoqUKVFb67DFqm5CSTtxrefZrLCAkFYxXg3MQyFDLSJkcseBRonQu68AfGQ3G414SnXn0N3Wj+77RETkSPgKzEDGpxOVTlQv+AIONtfwE8WkDtE9awcrM7qEsI8mN82G9AXksI9piXj9hFLccm+CndycYRFdwqAAItNBc9580xGE8FLMcxaFSaDHeUx1MSkAnCd0KaPVjXnK/2WayoAsJDSeEJLucvoMmgSrH1MTSLqppkn00ErJp9XCSeIX8mvo19K72sqIwx42WogmR16Jkgq+wQxY2L7ZzcMW+wT1GfMOnVliu28SKiG9/ScUx6RXhwM/abpKWF3DSQ5yk2YBQ61y/dYW635ZCTqYieH9CFVO313WPJT1MWSC9uJ+LohJ9N3ZntzeZuX6g5YnEp5zS3h81dOegT8ZIaOjDFgRzSUjEmKb+/3gIKxbQ+8UErZfWmvh9G3yB82UV20d0kLK8Tmr6z/oSLmF4hy9+lY/AZMEaC0fQwB6BwaYGS2Z74SzfiHwwRV7erbAkbvLewRZfBX2rGmgLvwxU57Z+LqGekBy6KO1O1hyjo4b64+VZVdfKJY6UbE12FoWlu1E7gVkvaCa1ne+G7WWG1uwNbaF9650bq52QbiSZXn8T/EuR+UcIakI0gw84+eXUhM1YQd0HXRIkhcR/vbXPMLgMhb0PLWtCH6rnqOQNGT3CfjbdAsH/wM+P9xhi5TmCntM0363us4fLg6Sabe6dMjNCP/9IBOssrr
 +lipOxx6
 kLmiQQwiQiBilSv8VZjPCgUClsuny/+Hx3yzra8T5/lNwjiQfJLXHNIa/p4XHUXreapgckNIraj3daLKrLnLkQdRBemxANrFgZZZAFLx07SmDgvTN6oweyb/eAPi+n57YhVCJw4vfifZS621yxRgNUoz++ALPBAuRRI5q4TBul731k5SRJ4pV22a1/oXTZYki/rer+puLDxf8srj9miihmVmgl/H9syKwrvN181M7WEAFLdgYcwFiAJVI40PJn28PF1hD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 02:08:22 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Wed, 26 Aug 2026 17:44:38 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Wed, 26 Aug 2026 07:05:08 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Wed, 26 Aug 2026 18:24:13 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > On Tue, 25 Aug 2026 06:54:57 -0700 SJ Park <sj@kernel.org> wrote:
> > > > 
> > > > > On Tue, 25 Aug 2026 20:46:16 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > > 
> > > > > > DAMOS uses charge_target_from/charge_addr_from to remember how far a
> > > > > > quota-limited walk has progressed.  The current implementation has two
> > > > > > problems:
> > > > > > 
> > > > > > 1. Once set, the cursor unconditionally skips and resets at the last
> > > > > >    region of the tracked target, so the last region can be skipped even
> > > > > >    when it has not been processed.
> > > > > 
> > > > > I don't fully understand this.  Could you please clarify more?  Maybe adding a
> > > > > realistic example scenario would be helpful.
> > > > > 
> > > > 
> > > > Problem: Unconditional skip of the last region
> > > > 
> > > > In the current damos_skip_charged_region(), there is this logic:
> > > > 
> > > >     if (r == damon_last_region(t)) {
> > > >         quota->charge_target_from = NULL;
> > > >         quota->charge_addr_from = 0;
> > > >         return true; /* Skip */
> > > >     }
> > > > 
> > > > Scenario:
> > > > 1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> > > > 
> > > > 2. Quota is configured to process only 50 bytes per window.
> > > > 
> > > > 3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved at
> > > >    (Target, 50).
> > > > 
> > > > 4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is full.
> > > >    Cursor is saved at (Target, 100), which is exactly the start of R2.
> > > > 
> > > > 5. Window 3: The loop reaches R2.  Because R2 is damon_last_region(t),
> > > >    the old code unconditionally returns true, skipping R2 entirely and
> > > >    resetting the cursor.
> > > > 
> > > > Result: R2 is permanently skipped even though it has never been
> > > > processed.
> > > 
> > > Ok, makes sense.  The user impact should be not that big, though.
> > > 
> > > > 
> > > > To fix this, the patch advances the cursor every time a region is
> > > > walked, regardless of whether it is applied or filtered out.  This
> > > > allows DAMON to accurately track whether the last region has already
> > > > been visited, eliminating the need for the unconditional reset.
> > > 
> > > Sounds like a big change compared to the problem.  Why we cannot modify the
> > > last region case?  Have you also considered other possible simpler approaches?
> > 
> > For example,
> > 
> > '''
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2686,14 +2686,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
> >         if (quota->charge_target_from) {
> >                 if (t != quota->charge_target_from)
> >                         return true;
> > -               if (r == damon_last_region(t)) {
> > -                       quota->charge_target_from = NULL;
> > -                       quota->charge_addr_from = 0;
> > -                       return true;
> > -               }
> >                 if (quota->charge_addr_from &&
> > -                               r->ar.end <= quota->charge_addr_from)
> > +                               r->ar.end <= quota->charge_addr_from) {
> > +                       if (r->ar.end == quota->charge_addr_from ||
> > +                                       r == damon_last_region(t)) {
> > +                               quota->charge_target_from = NULL;
> > +                               quota->charge_addr_from = 0;
> > +                       }
> >                         return true;
> > +               }
> > 
> >                 if (quota->charge_addr_from && r->ar.start <
> >                                 quota->charge_addr_from) {
> > '''
> > 
> 
> Thank you for the example!
> 
> While your approach works, I am curious, why should the cursor be reset
> every time the function returns false (does not skip)?

It doesn't.  It resets charge_{target,addr}_from only once after the regions to
skip are all skipped.  Am I missing something?

> 
> In my opinion, a cleaner and more deterministic approach is to reset the
> cursor only after the target has been fully iterated through.

So I will be able to give you some comments only after the above question is
answered.


Thanks,
SJ

[...]

