Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2943F30280
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3494C6B00B3; Sun, 15 Mar 2026 16:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3098C6B00B4; Sun, 15 Mar 2026 16:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C316B00B5; Sun, 15 Mar 2026 16:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1267A6B00B3
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:00:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D100E160C90
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:00:28 +0000 (UTC)
X-FDA: 84549364536.26.C7243B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1236C140010
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:00:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvkL39AK;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773604827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tY9z5u5iNCirbdu1dasS+ovDSmnp2HOPCNGXIJotAA=;
	b=ldyWov/z0WkgwCLk21dYoTNLL5n1noj/881zsGjcZEVrkEsguFoBwmr1aHeOprZL6f3/7G
	UYeRjJ8NHVt0NLeduYwRPqtV2cnSPoIb3s7ycuvUysEqRWoo4SpcriP6pZ8ml5NJNI9jxt
	Gprg+bXbM0T6JGTWw0FTH/ehHa+m+ho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773604827; a=rsa-sha256;
	cv=none;
	b=paj8cUXVqfpqtwyzqzMh7FEx0L7HwkMlrYgRepGAK5hegY9vOxjYmiAErWsSNE/9OlV4qY
	eZK17B2zxeBsdq94LB1p0CKEmtcNk90LAUluLj7dLVZtcGSueFGjPv2MzH0XuTB17UwjZ/
	LCNfl79v+O1jYnltGycnouPf3Is4Ijc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvkL39AK;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05B5E409CD;
	Sun, 15 Mar 2026 20:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABBCC4CEF7;
	Sun, 15 Mar 2026 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773604825;
	bh=J9pDEzjtYa3DToQjgPpIae13LOkifdux6SX0ArC5xeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RvkL39AKyiFEpOJuefEub8AY0x3Q2qxf8z3SJgt6teW+RYuCp6NdXiSuXBsPzZ+L/
	 2Q1vbVnHRF4Vxmfe0QYwXeobwvIe+GKh4KhqD4UVyRg4TJwp4Ox8oZcQ6NBB5wtU2U
	 CdOIPmAnCJj/cVaz3+CmczlRcTySZippB1GRI3lwwDDxhiCR73q14ZWvc8nnjrYfs4
	 3OM5Fu2dFnJM1s7LNAohDNVsnhuD/e234uHKX2wCwcZNmdnvLBTdqjZm/FsA0ZglXt
	 PioWGb/6fF7EHeMFAMdJvuMywZ1sbRFLSQ6Pdzz+rEsF4LtWzyhcI/rX1EAMdRtNgh
	 KosX6lygEzKqw==
Date: Sun, 15 Mar 2026 20:00:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, david@kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
Message-ID: <aa646958-9021-4062-8151-4d1a1fac94c2@lucifer.local>
References: <20260314152538.100593-1-xaum.io@gmail.com>
 <87ms0ajtvy.fsf@trenco.lwn.net>
 <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com>
 <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1236C140010
X-Stat-Signature: 5bgrmw3ft4hi981dcjrwhpoqi9bd89cs
X-HE-Tag: 1773604826-609217
X-HE-Meta: U2FsdGVkX1/h4QT+igA7kIq1Y5BAR6M+9gvXQ48Eg6dz87G+2ok0v2aJzg/258C7kyKeaBFx7yaqaxn9YiXuAzojDIGz+xcn932UasukUsitNh8zOc2IYZHzuq9E7A4DyMuEKkuiuduKHU2L1StMvmEyPAeAGFNzBIWlO+7Xx0+ZAhzNxGqs9X/licn2is0Abj0xbpjLDL0Xw/XG2K1qmewqYGMSY90QsEGswmoGnSLDsb31gW1l/NDVYtgZm+1c8lUub6tUZh3P1+W8RrzVcmy573rTyUrpcvcmETg9aG2kMK/BiWpm8cUwZSO1KntcUCp0Mf9mIJaCPN5cfrFGid+xxSmArDQxNhLdE2yxu9/1+rmDuvwTY2bghu1aVH4IEMTpXg2o6Xy3iq99qMrQnzhLcv1/JXGNqE/Z05WtfeL/Z9bjaimFWWtqzSKr0Hytw/QzcCqQ3Vkh42vvcJyEbnxVzn9lz8qaGo7YTBrxW5gQTRkCt9p56CCtsmQV8JWeSouSl7rNwNRI4V3NlcvxGGNIj+Kn9nEmOIqpBFKOvauJBJvsjS71SylLXFyhfvZA/0U2QGiOEoEuCKthA79QtXiU/eteQnlVBKz9SPy2bs8rUR8OtfNy2pnXnlMg8c9OgKZIWk3RZWNI49u4n8T8pd7YLRikBAub648zulklCycCsJPpxvWzaJxKdVjOCpVjjOGx711qv7d05O00Z9yd9/lgkR2jYf+AN5imQ0D8LzcMRT0oznJD65lp7HqiLN3RWcN1riTq2jW+BGziikyVfk/Zf99FRo647Xi3VD+uJahTUhlhnh2v7ZadcNqiLqP7cnH1PquJWfygeW0Nxs0EXX0xHG44Ccnlq2pFU2Iyv2+HZQB4UVJM+G6zu0U+p2FrHpM8Y59ph7rnmVEhWj2MT9id4miG35kXh41SQxjJAv1ehow33F6a0sbP+z++EU+Jwln02gKrkL3L3ktEiO6
 xGsPAow1
 FUc8U/aaXtAP7a7GIxJ5rf/JZHsYRZ4Lu2sND4Vv1iCNkYUHxRGyOlhqg1oHYrLq+zSwucV8xyMpBq1b1baZU43SHTuaUOYvlmJQJXi46TuJwDBQBADlRe5nm1mka8l2K3cilfJGUlOX4Bs5TkeH9y9OUoWsGiRApVlWp982aGyX3ZIgvNcGFoeEDaW5UcIfjSsfj+gWgWlxXhzMOP6rpFOXnBnVwB8chyqRRY3ynMlXdDDuv1s4MYlnU0Zldpmghi8ezZl+LZO6HvPTfrPdiNnn2A2uoV8KjIIJ2akwzWj5VLOAxwDw1u+tk26cwagmOpfK3MiS65SZDA2uhoX9uFfsZwVArLDdPhMYT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK to this and every patch like this.

On Sat, Mar 14, 2026 at 11:17:57AM -0700, Andrew Morton wrote:
> On Sat, 14 Mar 2026 17:02:47 +0100 Kit Dallege <xaum.io@gmail.com> wrote:
>
> > Hi Jon,
> >
> > The material was written with AI assistance (Claude) and then verified
> > against the source code in mm/shmem.c. I read through the implementation,
> > the existing comments, and Mel Gorman's book outline to identify what
> > should be covered, then used AI to help draft the prose, which I reviewed
> > and edited.

'The material was written with AI assistance'

That reads to me like Claude generated this and you 'checked' it, but
absolutely none of the commit messages give the slightest indication that
you understand any of it.

In fact they're all useless, lazy and seem auto-generated too.

You have no previous contributions to the kernel whatosever, let alone in
mm.

So you are not well placed honestly to check any of this, and are instead
putting in low effoft and expecting finite maintainer resource to review
this for you.

NO to this.

I can go right now and get Claude to do the same thing, this is not
helpful.

>
> OK, so you're saying that you created the content and used an LLM to
> assist in finishing it off?

See above, that is not what it reads like.

>
> > I'm happy to rework anything that's inaccurate or doesn't meet the bar.
> > Should I add an Assisted-by tag to the commit?
>
> Yes, Assisted-by: is appropriate and useful here.

https://kernel.org/doc/html/latest/process/generated-content.html

"As with the output of any tooling, the result may be incorrect or
inappropriate. You are expected to understand and to be able to defend
everything you submit. If you are unable to do so, then do not submit the
resulting changes.

If you do so anyway, maintainers are entitled to reject your series without
detailed review."

>
> >From a quick scan, this material appears to be helpful and I think it
> would be good for us to get this into the tree in some fashion.  Which
> will involve asking the relevant MM developers to review each change.

It's not useful, it is doing something anybody could do, and delegates all
the work to the sub-maintainers, and there's already too much review in mm.

I do NOT want this precedent set.

>
> > Mel Gorman's book outline
>
> Well, Mel may have an opinion on this - hopefully you discussed this
> with him beforehand.

Mel's book is fantastic and Mel is great but it's very old now.

In any case I question whether even this has been done, look at the commit
messages. They're as lazy as they could be and look auto-generated.

Kit - if this is sincere, please take the time to try to understand what
you're describing FIRST, in DEPTH.

In fact I don't think it makes any sense for us to take doc patches about
mm from anybody other than somebody with actual experience working in mm or
who can SERIOUSLY demonstrate understanding.

Thanks, Lorenzo

