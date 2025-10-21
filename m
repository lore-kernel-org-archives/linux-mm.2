Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D2BCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 23:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68CA8E0006; Tue, 21 Oct 2025 19:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40278E0002; Tue, 21 Oct 2025 19:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D128E0006; Tue, 21 Oct 2025 19:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B87F98E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:39:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CC2F1A067A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:39:41 +0000 (UTC)
X-FDA: 84023740962.30.E48043F
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5BB4640006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:39:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=wF8E53z+;
	spf=pass (imf01.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761089979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ekz2VvXis0CGgykoGefhdHPuzvi4qz8tP9mZjwte4JE=;
	b=uUaWnaQ8gHb0rv94B2v4sOhE8UZY+xMBGM5OpZKaXizjNIUDEeLme1JPm8CxqfzwOAs6C7
	8HCaf9/FkbvtMkRRSBCyBK+2PWDW9HomB/I/NgV0WvYlFakwhx+nCKlox3ZMaYnvjx0o/L
	3yqV+CuLP5acrMzPMXi95gCQgAP8uhQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=wF8E53z+;
	spf=pass (imf01.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761089979; a=rsa-sha256;
	cv=none;
	b=vIge80hsZ3e+a6EeNeuKU0akNJPik9xBd2U8TqVpWhBBe7ZZ+KAMYHbDrm2AmQYhtRU8vS
	AWjIcz7ONG4JuLq1UFqIc4URwlLpbVLubnI4tczrIdFh2gYNUFRJyuVSSuYxOsY1lTkDeS
	3GYq03eRCk+WZDAETh31h3unBNfL5GI=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-781db5068b8so4761229b3a.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761089978; x=1761694778; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ekz2VvXis0CGgykoGefhdHPuzvi4qz8tP9mZjwte4JE=;
        b=wF8E53z+gFLH2nn/+pRXs8W27RUo7Ub/+9nBuQycbpe3XUhW9yxCfLJHJIwGXX8KQE
         ZGVbg4LZc6XTIHCJeIfcR8Qbhw9LpLbCrv/RRZHXSP0M+7Cj3Oz3ar7b29PoHZ6L7JfP
         fa2PWnTYoOfAYFkyB6ilM9Jtrcywiw6HUiR6/dVFLeqA8e9lF0sg3o2O2FpkamF8x3zb
         O6aiXYYwhM+5MCkOTECWluf7kOSN+PEoRqeW0Foe17oLZuAdbphowhVmj1opSyhPw11M
         Pq2a8rMAzL4yuZEh0SUY+ojFqlWLn1VsMYxsujGM4D5bUy26nUgmSAEfa6ylMxjKf56K
         C9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761089978; x=1761694778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ekz2VvXis0CGgykoGefhdHPuzvi4qz8tP9mZjwte4JE=;
        b=nM+bTcqCSjakWPORAkea/kpJQjPmFD9yJVuE6ZgXHM5dVdaxF4Vd3QzlfHm34gDiLB
         fFXjNGs6gaoaam3LuiIxy+oN5KrY7go+T9GrF/uUJ40gpYI9D5NMbt6f/UDyqCTgY6KL
         9Kf+Z00EonGKf+5XBAYJtrXPggulSwtKdEEaxrKeRM8FCjTP2GSwSDk/3LGXCbOQTuer
         1jjG0yMCXy5wamY9QtD7cQbAyT5njsvysXYvFbFjQ5dkpdkvT+LAI+DhXEVn5YTHfTCD
         wLSYhTZG6OP16k3eo/d9uEKvPsKZprK4lFmrBw5tc/3eIxeLjLuOg07AKzrgTHvYOBNX
         4r6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLFE9CSM2n7np/wxx56srjpbCqGHoJMMzadb+VttKZQEDImvFLyqPAgOPjyFF+BMsqFyI83WAGlw==@kvack.org
X-Gm-Message-State: AOJu0YyGHrxkL9eVQqi3B60HSZANFdl2E3xVJnrzN4KLA3vvuXCnUXOm
	9LjEOoQBhaX+bKlZcMEn/bwdnGvxBLrBW3B78EdoUk4SZmy1/K75KsiUKgwMDO/QTMs=
X-Gm-Gg: ASbGncsVjivtHqIcDdwy7swXG3FFa7guIsIk1xCwj3ofGFEF/WH8UeZflqSLDwAmIxU
	G357FZmxmhCnVl74A/P2oxrPpPr05gGwfs5YmmWXbn0UXLTJDj7ntZv1tTb6IU9D8Lsjoc6lBYG
	8DdbQpbEQdpA+7MocxCmePexupMreJBHTeUGzZke5L7BEXPXHNINnzJhWEmVN/fC7uaoewHkttq
	OtwrZj3dWhaN1yqSxhZfN0rAjVT6ZggitlhKaSf0DBzPF1Q9yQ7geNlhesSXajefFyHf/1iW711
	DQrSAy87oFhladUDdFNArUF9uGLy9TmNuJoztLH+wJMExc0OnsPidVYoyNYNW8UDoTp9AiURRkR
	X0eu+TyuqB/hKLUj738RJ5LnU6XOGJC94xoczdJw7RHC3f49mNGOBBnYwf2kbmQ7arMotIOmQb5
	QpgY3TzmoXOxCQmAqZ9YMwCfQAmAZrMlQ2GRlOBMmK37Lx86ZPXe79bC07zsk28Q==
X-Google-Smtp-Source: AGHT+IEeKxOQzdS4L5wZVGG2YsfGQ4VfOG5WxuGIyPNKK1Wog0FyGOuQbFK7NwXfAtyNg8VMiQjC4w==
X-Received: by 2002:a05:6300:8002:b0:33b:1dce:9941 with SMTP id adf61e73a8af0-33b1dce9c71mr125201637.45.1761089977976;
        Tue, 21 Oct 2025 16:39:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff15c89sm12888451b3a.1.2025.10.21.16.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:39:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vBLx0-00000000NAO-1MVp;
	Wed, 22 Oct 2025 10:39:34 +1100
Date: Wed, 22 Oct 2025 10:39:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <aPgZthYaP7Flda0z@dread.disaster.area>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
 <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
X-Rspamd-Queue-Id: 5BB4640006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: n38fetnuas1a5cw6x7qyt5fzin5j55jo
X-HE-Tag: 1761089979-213206
X-HE-Meta: U2FsdGVkX1/ESFGyxdeMVNX9YWDLgdTKWYSh0uAySSAsIF1pqscOlGO/f0yZMRs6B0J/aux5pdv+iM3OL1BD/FzW6ncmQVxUsH/irAWFVcv8QCLxbPndFXqTVoifSRfQ8bQEtkl5aL+9kVqSZDElRJufuj1qJMKQx8Ub57GFjGFWUymEEMpMW4slfVHAss+bn/A8vvmTJVSIhnFhUUmRJniGduwvh03ABuSpkAQIiNmmmy90DA6BzKw5BVhyqtTdOP4zv8El3TpQtZiqQhhfhyvlHGCWPQ1IG64tinYrsxqvBOZA3GvGkaBoWu+BE0aPbg4A6uh2QNbGZ2KvXLo6RlAoNCQlUgtE9MAFMKDPR3LegusIkHG/Uq3qlRC1V/ibWb3OYv1jOzAnOZmQ3bmrSYuYdv9wHygDIwVPkHu0uxh+omkJGoQlNZj8iR4Qn+WUX+AKmHlEvDpNVR7i5Ij+7WQO3Y3x2Yedq+0cITl86faA8FUA/4ZC3FXon2AnzNvuXNV/RmiwnWdsj9d5EIuHnB9mkl78Gs9n6uuIhe6G7abfii1VmJ3cqLIxy2Y2dpFnzrOUflITz59pNjopkik3w/sjQbNUsCklyz6CN1j2kOiPrj+k/4Tly66clF1PuIL2EhxGlnSnUxB7S/A7Sk3bFpDd6imD8Ipkzf6P2QourwcLUs20as9kDg0AK3Z9l84xSa7rFDyJ58X0Vbx5Jn1Cf1lU0ttYNuXTmn8TDO9hpMt9Jb6FtEjaaLWFELHefMK5yCGEsTQ6PReU5+rzoE4oZo5rRzHVAH+GY9skRSjCllvXhtVqvpr4391oWJ+kEkQPNxe+4691NrBPvQNUGMdDRrp7N9d7JScNGmbMmjyQTQWxrHAahvMf6ho/Z7wf9pcHucHKGKgnvpdMYZBdra5x9I17zOxkhJevn+/leh+EzYpJzJf3x247hL1hk0iS8Cx4u5et0vCVYM5l9dOxEx/
 cr6DimxR
 zYXAOgDrgyBfFapl2m7Ae2i8LPYecqP8UFTLQY0ek1RK7cKSE4mPCRrDmPh5Riq9giPxQvWMlldj1M+I09yZlApR9nwCGTHDP1iNJhNVI9CB+rQkQxZwhyxr95ENau9lK8PrOaGTidyEP7FJlSmwR5FHV928DwPREpYVf6GrEQbpJrxOOaIVM2XvC386rZNZvU/qFEljw35yiV8v5niB/8lVvUk8Vf5h//VF/TV6WHmHsKKkaY4ZQYhahwswpnWXfQmbBg81Pp15H6L8aoBjE5sJtKeT2M0DfoZGU9AigmCxJOmUz6g+3OpX8S6xmCqcqNdhgGDdx29xif7u50mZsxeyJZ5qZwciVaxfkqLLIeT7woVelKeicVNxkLPn6HEXNOOJ1gBoI+4nlBJsk+FdcLHm/A/tHw8q8pe7hpaDjNUtbv+vmpvaaLyLtE1KUePw5K8MIkW2E0QYaDtuS0DoQu+Du9nEhLQMsJTdL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 12:33:08PM +0100, Kiryl Shutsemau wrote:
> On Sun, Oct 19, 2025 at 09:53:28PM -0700, Andrew Morton wrote:
> > On Fri, 17 Oct 2025 15:15:36 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> > 
> > > From: Kiryl Shutsemau <kas@kernel.org>
> > > 
> > > The protocol for page cache lookup is as follows:
> > > 
> > >   1. Locate a folio in XArray.
> > >   2. Obtain a reference on the folio using folio_try_get().
> > >   3. If successful, verify that the folio still belongs to
> > >      the mapping and has not been truncated or reclaimed.

What about if it has been hole-punched?

The i_size checks after testing the folio is up to date catch races
with truncate down.  This "works" because truncate_setsize() changes
i_size before we invalidate the mapping and so we don't try to
access folios that have pending invalidation.

It also catches the case where the invalidation is only a partial
EOF folio zero (e.g. truncate down within the same EOF folio). In
this case, the deletion sequence number won't catch the invalidation
because no pages are freed from the page cache. Hence reads need to
check i_size to detect this case.

However, fallocate() operations such as hole punching and extent
shifting have exactly the same partial folio invalidation problems
as truncate but they don't change i_size like truncate does (both at
the front and rear edges of the ranges being operated on)

Hence invalidation races with fallocate() operations cannot be
detected via i_size checks and we have to serialise them differently.
fallocate() also requires barriers prevent new page cache operations
whilst the filesystem operation is in progress, so we actually need
the invalidation serialisation to also act as a page cache instantiation
barrier. This is what the mapping->invalidate_lock provides, and I
suspect that this new read fast path doesn't actually work correctly
w.r.t. fallocate() based invalidation because it can't detect races
with partial folio invalidations that are pending nor does it take
the mapping->invalidate_lock....

I also wonder if there might be other subtle races with
->remap_file_range based operations, because they also run
invalidations and need page cache instatiation barriers whilst the
operations run.  At least with XFS, remap operations hold both the
inode->i_rwsem and the mapping->invalidate_lock so nobody can access
the page cache across the destination range being operated on whilst
the extent mapping underlying the file is in flux.

Given these potential issues, I really wonder if this niche fast
path is really worth the potential pain racing against these sorts
of operations could bring us. It also increases the cognitive
load for anyone trying to understand how buffered reads interact
with everything else (i.e. yet another set of race conditions we
have to worry about when thinking about truncate!), and it is not
clear to me that it is (or can be made) safe w.r.t. more complex
invalidation interactions that filesystem have to handle these days.

So: is the benefit for this niche workload really worth the
additional complexity it adds to what is already a very complex set
of behaviours and interactions?

> > > +	if (!folio_test_referenced(folio))
> > > +		return 0;
> > > +
> > > +	/* i_size check must be after folio_test_uptodate() */
> > 
> > why?
> 
> There is comment for i_size_read() in slow path that inidicates that it
> is required, but, to be honest, I don't fully understand interaction
> uptodate vs i_size here.

As per above, it's detecting a race with a concurrent truncate that
is about to invalidate the folio but hasn't yet got to that folio in
the mapping.

This is where we'd also need to detect pending fallocate() or other
invalidations that are in progress, but there's no way to do that
easily....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

