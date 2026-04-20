Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ADE5F588C3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22946B0088; Mon, 20 Apr 2026 09:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA326B009D; Mon, 20 Apr 2026 09:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0FDC6B009E; Mon, 20 Apr 2026 09:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90AED6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:26:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A59A1B8F6A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:26:43 +0000 (UTC)
X-FDA: 84679009086.21.652C742
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 72F90140010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:26:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cMhAXxqf;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776691601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZK98ieIRG457WI8zfD0fDHqFblKktpbnpJAvLDPkbM=;
	b=uHLwWER/Nx0zaolChKnm9DXtYtgqXkBEWFqRthwnQUsYEHcwcZwo74g6vrgyZT6cASjtsI
	NRlr61SeJ3jCWlJ2UVWW0FWJ/lKocGyuHA8bdRD+rtMlTv/9cV+qQrRKnGo9h3pb43L9NG
	OrnEQPDMPf0diXy0yNGFY7es9raz0so=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776691601; a=rsa-sha256;
	cv=none;
	b=SWP3oirCxXFhlgnlM4Qhzk2rj8i9ie3owGU+T6pUH6Xi/20yotNhR4HN/u92TVlfGSEx6A
	8g+PKs47wVgKe0I1bAmOFgxPfUpzxARQvX1IOHrJSQ1dCjG2Vfovb9KX+2Ifolzdobw0wl
	uDmjftwZDYk4OO/bi+wEtEDZW0kYfpQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cMhAXxqf;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8d68bcf50fdso363096285a.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776691600; x=1777296400; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZK98ieIRG457WI8zfD0fDHqFblKktpbnpJAvLDPkbM=;
        b=cMhAXxqfs5nNN0VL7KfA+r1FX0y5QIIz8bq5IA5U12cWmq6dXngJ/6/QxR3MNrI5+v
         ha3Al0pTtnL7SrtlAEMaof+h4mSNSxLe8rBhzozTvrkBtzhlCG4w+RUdBMlZ8acEuRHD
         ZJQ7YPsZHePyKzBTepUUVr08U16BKOIdFEHlsWvRSzctPu/G4iEScyxv7h39nD4FJWb1
         Q+LEi+uvNYgO2FzXnbJZ8YCaTek+o7lTe6tWM8X1YFbWD7btIhrV81cwf+LMI7S2xiHQ
         YDkIcc0baPkuecKpMJAF/z0XO4mImKIrgvufRY3aEyCl0i21lUV5f0RK+XPNf80GRuOg
         uEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776691600; x=1777296400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZK98ieIRG457WI8zfD0fDHqFblKktpbnpJAvLDPkbM=;
        b=JWzGvl9bKYEvlOUuv1XqYaexBn3eUqN/mViPH8uiZwC9PVB/+qIe4skHbHpyc81ptv
         RmkYgPunqbvvJPZfv0JQALsoPFOneHFdnA1j+JHO5BfH7NzDeAX55Dz3cCGIk18wM5bd
         lNh70le6uxATrelfB0s4vzu05SxFlb0k08c7yWMkOhcToGZfC+Pa33ybDIWJmG6Q9VVs
         4Ke32T/k4N2UqF5cDmN6gq+XgbiZ7Rb1NIaS2QBQas3IJ71Srsh01U3ukXXkTYAVKHNt
         TWV8qz9JdkxQ/CS0buV8lkMG1cW/2ZauVwkBSLS7B71Sgy5VayGwe4XmVKSUZYmO6VGb
         1i0g==
X-Forwarded-Encrypted: i=1; AFNElJ8D9Kuy3/Vuh7f3ZVlq1b0P9/VM0+XUbLl4Hw8X3D3elDlAfE5eBBL0tj1a515DMEwdBDsvSzoOag==@kvack.org
X-Gm-Message-State: AOJu0YwPM4kdkp7VaIF+6xZ00DJj2EMUKdcM73KlUTy8AgQhmJFHuC5+
	Wbu6m/FTF6X8mufpmzLJJpHkkNL7H5TqZYkxn3yAldOCJs9Z0JNeUXKKf02gjd74ptk=
X-Gm-Gg: AeBDieu2Eww25MBlkcmPLBCqmWcY89+58GvadMKZvXwNwXDiug7WyMxOgFutPQN2Nsi
	vMEoJCGpEdHh5PtXHhZWg4hl7xYrOvqu5I6nHNCXsVAR0q2056gnPdELmqEaTVmWClGwD6AfqC0
	2zJBHbNeKl6GW+mRflCLxFLA68eBBgo1bSQq01Kendcwurk+biPW1ueGB3rAL4bWb1e6hk62k2g
	L2RB/8e8KrKDYF8fqcXZ9U65de4mS7zM0IUjaj1KiNZIrTvXpOpRBIZ82O77xb68XMGO7F+lrv9
	5fSuX4N9xpWB+CMvBihtcDn+Q4An0Qmp0fzHVmfkn6HnYUenimbdY/mnPhe4yGfRumF2EnTJVd+
	BOtb27Uj5oaFwckUWfqTRXyE+1TLf4WZZSibxtWWHVb00UfeF2i3Rs9CYNBVws8+WwXb2er/w+L
	hpbF3KG/ykvQ6Qtxa/bedW8w4mOpb1UrwrhZV3OhJSZSfnK7bWw+qiF4YAjmx5
X-Received: by 2002:a05:620a:410c:b0:8cf:c729:a629 with SMTP id af79cd13be357-8e78fc29218mr1998016685a.20.1776691600368;
        Mon, 20 Apr 2026 06:26:40 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8eb61bc0d7dsm201476385a.24.2026.04.20.06.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 06:26:39 -0700 (PDT)
Date: Mon, 20 Apr 2026 13:26:38 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH 1/5] liveupdate: Remove limit on the number of sessions
Message-ID: <ttirtg6trmvhuaubix4ufhv2i7vl37n3ef5rgkpxp56nvfvwmt@ehghcskmjqzo>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
 <20260414200237.444170-2-pasha.tatashin@soleen.com>
 <aeXSEe9Bo-vsSkMH@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeXSEe9Bo-vsSkMH@kernel.org>
X-Stat-Signature: jhxmm7tyrr9361eiaa9f4wsuhsamszxm
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72F90140010
X-Rspam-User: 
X-HE-Tag: 1776691601-685379
X-HE-Meta: U2FsdGVkX19foPnRlSgffT2LhMxmhoHhNAdWaSY2kQziEQmgTihNlHeTQldFAeKBq/ZLEnJHqD6cWOvQ1OTFBrEPdX9zhUdqJByqblrkKfYRyEZNJjjrgj4dLbaWx0ChoByo3CJFiSDQVWe3SuBSVEfQxx2IykBG+vgLzi3sReiEtDaAmM9bc57iPsqmCG6wMKWpPjkzLGvej8Quh1a+fWYovrv+LB8PD2cWHz7Y283cUzLfWAHBqB1WuJLgI9g758nZk/WndpaK009WfteJ0eqU8Ng9eRmn7R+Fizza5raZwxUzkQMBAMuNqDpuFKNxqaaMXfglHvzeHsDisdDeJY5KPkrkR4MhKRhLvp/bkt+Oqg5+E84TdbTZOSy27c9ZNgyg1fGXhV6MJGn1df53dXm7mrsjzAWQHIGchTbad+QWC4lh+YqGUYwYK1BjLu5KsU3Xi6dyPzZjO9hLoOcLbgaCWdLobyejkknkJY15Xed28CFGUI3bS7St0d586g+Yu9vsH3UNAThj5Z9VdgqbmJwwJBZhpA2Q7pyGb7yIWd9QO3PayVz+rtM/3DsW01ksieGqSlmTQsnW5UV2aONFMekGau4svGVEe4utj6ChDIOGR0EFW47VT7GyZWpyqXJHydu0/2iEKAKkgzb2U8iC0cXuYxtjn9KfrTO1Bf5WPFH7UIt1+NTR7wc33MsfOE5W9Hrq6JD8ItA9lcAS5Ak0o9EjGWkTLYQoNGBPuO/GyD6iG4TO61jXChmz8O69y/EMNe3R8b2xjzZp5BmfBHqTvrxt/LPkdhrgH5UKQPTcn7LhzgnQvn4MMLjke1MmNF7QJlkYtMsmRJO998h+I5g4KgdM15a/SnVvQx0op9PrOXwuwD+ZJ22wLH9GM5LHwayK9vtdCMO6rNsoO4wmR5k5CyvxLL7o3ygtEk+7GqyP7EpY2Ek96Qrs+zfiQZ3AFdbZolLIekIDNMBb0F1aKhx
 Oo6IKcfm
 Xm0bknBS5d1m0O7qYp2bWb49e2mP9flQxPeJf+GHXhEZAk7BYqnXsa4E1VosoO2m3GKbyv9Bh+EB/exF0okqKSGpn/tP4PISFpyHxS+IEwgqEeV46aEerC9lXGuzOZtIz8KxON5oG+sBW3tFJ4V8KyMdLjeJfOndJ02y4bOeEBw6JnEuVlE/KcNY1HA8HdykJqxpp3/z67Rg72PGfOgu/ph0WAO40dfvj30+bCW+cxsajHod6EEMxZJ/ZpXv/deOqkqGsqHL0cGn4gZBTpeYwC3X15z56J7VuLt03LqNwjudaxassthqlEW5QdASNteK5ZArGbNXQuXxKAOU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-20 10:13, Mike Rapoport wrote:
> On Tue, Apr 14, 2026 at 08:02:33PM +0000, Pasha Tatashin wrote:
> > Currently, the number of LUO sessions is limited by a fixed number of
> > pre-allocated pages for serialization (16 pages, allowing for ~819
> > sessions).
> > 
> > This limitation is problematic if LUO is used to support things such as
> > systemd file descriptor store, and would be used not just as VM memory
> > but to save other states on the machine.
> > 
> > Remove this limit by transitioning to a linked-block approach for
> > session metadata serialization. Instead of a single contiguous block,
> > session metadata is now stored in a chain of 16-page blocks. Each block
> > starts with a header containing the physical address of the next block
> > and the number of session entries in the current block.
> > 
> > - Bump session ABI version to v3.
> > - Update struct luo_session_header_ser to include a 'next' pointer.
> > - Implement dynamic block allocation in luo_session_insert().
> > - Update setup, serialization, and deserialization logic to traverse
> >   the block chain.
> > - Remove LUO_SESSION_MAX limit.
> > 
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kho/abi/luo.h      |  19 +--
> >  kernel/liveupdate/luo_internal.h |  12 +-
> >  kernel/liveupdate/luo_session.c  | 237 +++++++++++++++++++++++--------
> >  3 files changed, 197 insertions(+), 71 deletions(-)
> 
> ...
> 
> > +/**
> > + * struct luo_session_block - Internal representation of a session serialization block.
> > + * @list: List head for linking blocks in memory.
> > + * @ser:  Pointer to the serialized header in preserved memory.
> > + */
> > +struct luo_session_block {
> > +	struct list_head list;
> > +	struct luo_session_header_ser *ser;
> > +};
> > +
> >  /**
> >   * struct luo_session_header - Header struct for managing LUO sessions.
> >   * @count:      The number of sessions currently tracked in the @list.
> > + * @nblocks:    The number of allocated serialization blocks.
> >   * @list:       The head of the linked list of `struct luo_session` instances.
> >   * @rwsem:      A read-write semaphore providing synchronized access to the
> >   *              session list and other fields in this structure.
> > - * @header_ser: The header data of serialization array.
> > - * @ser:        The serialized session data (an array of
> > - *              `struct luo_session_ser`).
> > + * @blocks:     The list of serialization blocks (struct luo_session_block).
> >   * @active:     Set to true when first initialized. If previous kernel did not
> >   *              send session data, active stays false for incoming.
> >   */
> >  struct luo_session_header {
> >  	long count;
> > +	long nblocks;
> >  	struct list_head list;
> >  	struct rw_semaphore rwsem;
> > -	struct luo_session_header_ser *header_ser;
> > -	struct luo_session_ser *ser;
> > +	struct list_head blocks;
> 
> Don't we need some sort of locking for blocks?

The rwsem right above the blocks field protects it. New blocks are only 
created when luo_session_insert() is called, which takes 
rwsem_write(&sh->rwsem).

For simplicity, once blocks are created, we never free them. This is 
safe given that sessions can only be created by a single privileged 
agent.

> 
> >  	bool active;
> >  };
>   
> > @@ -147,15 +222,6 @@ static int luo_session_insert(struct luo_session_header *sh,
> >  
> >  	guard(rwsem_write)(&sh->rwsem);
> >  
> > -	/*
> > -	 * For outgoing we should make sure there is room in serialization array
> > -	 * for new session.
> > -	 */
> > -	if (sh == &luo_session_global.outgoing) {
> > -		if (sh->count == LUO_SESSION_MAX)
> > -			return -ENOMEM;
> > -	}
> > -
> >  	/*
> >  	 * For small number of sessions this loop won't hurt performance
> >  	 * but if we ever start using a lot of sessions, this might
> 
> For ~8.1 million sessions this comment does not seem valid anymore ;-)

Fair point! However, in all reasonable use cases we expect to have at 
most hundreds of sessions, so this should still be fine. To extend on 
this: the O(N^2) complexity mentioned in the comment is really only a 
problem during restoration, which happens during our performance 
critical blackout time. However, it is used there only for sanity 
checking, if we trust the previous kernel, we can remove this 
duplication check entirely.

Let's keep this sanity check for now. If it ever becomes a performance 
bottleneck, we can remove it during the blackout time and optimize the 
pre-blackout session creation to use an O(log(N)) search by storing them 
in a sorted by name data structure.

> 
> -- 
> Sincerely yours,
> Mike.

