Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1174C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879EE6B008C; Mon,  7 Sep 2026 13:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B126B0092; Mon,  7 Sep 2026 13:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741156B0093; Mon,  7 Sep 2026 13:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5173C6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:38:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D97F2C0280
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:38:31 +0000 (UTC)
X-FDA: 85187675622.12.E530B07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 31F85180007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:38:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzMW3Iuw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788802710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYtjFp3g5gdPUFznyNGIYCvkhRU+oOhyCAUXnEZTtCo=;
	b=aYZ/0ZlVg71ZasFhY5rDUHK0msfGkogkkmiIr8shdAXnxUmyTZA5/pJLO80snnUkkWxk+m
	wzULtpa+D5WWu9TwHX3WQAY3ri3TND+zZrjlTqE1KvNIIJlgwEy8fOjau6+aT5GAeCGN2f
	+6jYuwKcXFIg3nP/QgsBXEwxVSWyd5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788802710;
	b=ANh0JNUPyUejV6ifmLKr3JaY8KauXcVZvzEgeYZDHsT46IqW6Jwv5Ybor293tqW7NkB/Re
	x+K1YfzTctj5xPv1XFcexhdeUpTkKw4q8meJ9dZ0QZLerD6wlebMgSwwHIQCDyr8NmWErW
	YT+il3YH+4AAydbkFkm8nCSIWLQKbX0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzMW3Iuw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93E2B41B3A;
	Mon,  7 Sep 2026 17:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BE21F00A3A;
	Mon,  7 Sep 2026 17:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788802708;
	bh=JYtjFp3g5gdPUFznyNGIYCvkhRU+oOhyCAUXnEZTtCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VzMW3IuwBAg0OTqQvmPn74oP0XsjLtq/qrNYYzxcb8nBQieMLuuNv34LCDXblb6dd
	 h/+fzPZzyMdUTiZvrTV8VGZ55uTkC/1tZk9TrYYk3rOSFoDASk6wZWlVmt5cmNApAH
	 JLSj1hCAl7D4YduZxjCE7Epw5GcJu5YyF2NN3i5OXGrp9JirRJ5HoT6KnWSvGX7AYZ
	 aja9CsaKR6GbO/BpEntARV7zMTsVDyD6NbjUsewLkDd7tHNBbEaUko7Onb6f6mxCF2
	 Zh2gq2ncPA/L5Z3K0jmjY+aO+R+7FbIyYg4erGHvbfD4HCGGwEjQHZXd5VaYoWRmZC
	 Kj70uAvm9nifQ==
Date: Mon, 7 Sep 2026 18:38:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
Message-ID: <ap71GOPAeKHfHp5J@gremlin>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org>
 <d6dc52e3-b27d-4663-848c-a2f270fb4c5d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6dc52e3-b27d-4663-848c-a2f270fb4c5d@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 31F85180007
X-Stat-Signature: pp7dr63n9h5yh1cku9y1wdhbnwerdxxq
X-Rspam-User: 
X-HE-Tag: 1788802710-163481
X-HE-Meta: U2FsdGVkX1+NhaTwzaYC6FI5xkfiaV0DAHJ0NXslfkZclU5kWDhY+uMgJCLrYxDFfuiSHTzoLnvb74WrL0jQLfTX6QrdiSnoa4aBtA019n22DHYY9Tbg4+cdIABu3mCkADzwwI+yL9Cxg7+8Bx3gfqi+jokwmlDPWjlWHELtLFHDL13h0c2OTjSuztOpm4tRrJ+37jkOArCn7uY9EC2DnsQz+o+7cBIyXjk7cavYU36+qjjfG0o26uoCSJrygJnYklFQ3gbbO31iJrjLXZhzwg5P4v6Dv8oiF2c/XUSEqA7UOH/ODKbrUjEb3qNp3f5PJg/8OPRXUG7n42oaqevwa9HfYnGpXANXtZL7AWIV3gHWIULQSYlpB076o4APs3FEVlUjN/0IJuQk1Ox8wc+GaXU0v9Z6+t+x1TDG+GFtbGp4Xne2bqa84mYrN/IEZTtwTHka4YM84iJc3r9HO2uO24N0NRq+Uj6Dz9OEykKcCPlpWe2WbTv4q5y8jDZqjWEYTbfzMq5XIqL8fp6ZCMW9Wpw0AK0c999ev7ywi4qw/pZzaGECEYWC4NT+5OgTrInAcSkBmNXVFZHQdZoYOsp0pWJddvyL4LTmN4KVzOJrL85xRES7UeRJN5T2hVTy1O+QrlxYJwg3Qo+hzNF7UmioGofZm+PgRLBWbrOfNLrg4hlECW/CSlkZjTmAdAq8Uv8fxDPpdlmQJGLZuuRMzDr7rSjOan39NTI41bR0ECkSKtMLJ8E1uoRyHFHZWW2ZjnIccKFdm0iGqEwE6C1yPMBgtXE+EExgmt+YuaHsD4UCUbgpTIJsOR+RH2L391Ei47bTBGErGZpp5mQHPUshvyj/0bEkIrOB2yLchK/q4sMd5MCW3pKdNDloq/Bx7b/wydqrhCUxsog5DkonzByN+HwcGLzYnHEBh+zQIBy+UAiOP+Bo/QRh5xWKeIuMRvKlle2Rga82AAW1jDMKYhyexbe
 YtIrsKYh
 e+w+1UjkRLmLW6cqQrf7mP216+gm3bIM3z8oW6T794Je1pV4EDXjz48aBjvannQkV3R4I4H4FLrrDzQDzCAly/xt9sJaHgeXwFAc7LanBYNYoOu1FPD7NxuM8zh8SKhHOuJ0RHpHnipQLChLqgBeOq3Nb+w9MELrB7by7ydrWO4kKp/Nq+e8Ngp/G44wNG1fC9Hb8121vy5vJXqne8vjJSQyg4mHYDahlZkvQrnMJ5YvoB6gD6OJIGxx1u8xvt2vzZhE7TepQCD13jaxdi2ZuBobQ/mkV4ZSw+kbrHg7KMxrd+7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 06:56:51PM +0200, David Hildenbrand (Arm) wrote:
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 35e7a64855fa..4b8d430d9619 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2621,6 +2621,19 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  	return 0;
> >  }
> >
> > +static bool map_is_private(const struct mmap_state *map)
> > +{
> > +	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
> > +}
> > +
> > +static bool map_is_anon(const struct mmap_state *map)
>
> I was wondering whether we should call this "map_is_private_anon", due to
> MAP_ANON|MAP_SHARED. But looking at __mmap_new_vma(), the existing "is_anon" is
> also limited to MAP_ANON|MAP_PRIVATE.

A 'shared anon' mapping is not anon at all, and that's handled early in
do_mmap().

I wish that we didn't confuse people by allowing MAP_SHARED | MAP_ANON as a
shorthand but there we are.

So I don't like to make that distinction on the basis that a 'shared
anon' mapping isn't something that exists :)

And then imagine vma_is_private_anonymous() vs. vma_is_anonymous() etc. It would
get silly, quick...

>
> > +{
> > +	if (!map_is_private(map))
> > +		return false;
> > +
> > +	return !map->file || file_is_dev_zero(map->file);
> > +}
> > +
> >  /*
> >   * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
> >   * possible.
> > @@ -2634,8 +2647,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >  	struct mmap_action *action)
> >  {
> > -	const bool is_anon = !map->file &&
> > -		!vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
> > +	const bool is_anon = map_is_anon(map);
> >  	struct vma_iterator *vmi = map->vmi;
> >  	int error = 0;
> >  	struct vm_area_struct *vma;
> > @@ -2651,7 +2663,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >
> >  	vma_iter_config(vmi, map->addr, map->end);
> >
> > -	if (is_anon)
> > +	if (is_anon && !map->file)
> >  		vma_set_anonymous(vma);
> >
> >  	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
> > @@ -2669,6 +2681,10 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >  	else if (!is_anon)
> >  		error = shmem_zero_setup(vma);
> >
> > +	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
> > +	if (is_anon && map->file)
> > +		vma_set_anonymous(vma);
> > +
> >  	if (error)
> >  		goto free_iter_vma;
> >
> > @@ -2777,6 +2793,10 @@ static int call_mmap_prepare(struct mmap_state *map,
> >  	if (err)
> >  		return err;
> >
> > +	/* Hooks cannot mark themselves anonymous. */
>
> I guess this comment will be stale soon (after #4 where you drop the
> set_anonymous part).

Not really, it's there to catch drivers doing something silly/broken (likely by
mistake).

I want to catch that early. I have a 36 patch series that extends this kind of
idea... a lot :)

>
> Should it be
>
> "vm_ops are strictly required with mmap_prepare"
>
> or sth like that?

Well that's confusing though, because desc->vm_ops defaults to &dummy_vma_ops,
and we absolutely do not require drivers to set vm_ops at all.

And as far as the driver is concerned maybe it's NULL? They maybe don't realise
:)

So the idea is to say don't allow them to try to do something they can't do.

>
> > +	if (!desc->vm_ops)
> > +		return -EINVAL;
> > +
> >  	err = call_action_prepare(map, desc);
> >  	if (err)
> >  		return err;
> > @@ -2799,10 +2819,7 @@ static int call_mmap_prepare(struct mmap_state *map,
> >  static void set_vma_user_defined_fields(struct vm_area_struct *vma,
> >  		struct mmap_state *map)
> >  {
> > -	if (map->vm_ops)
> > -		vma->vm_ops = map->vm_ops;
> > -	else	/* Only /dev/zero should do this. */
> > -		vma_set_anonymous(vma);
> > +	vma->vm_ops = map->vm_ops;
> >  	vma->vm_private_data = map->vm_private_data;
> >  }
> >
> > @@ -2882,7 +2899,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  		allocated_new = true;
> >  	}
> >
> > -	if (have_mmap_prepare)
> > +	if (have_mmap_prepare && !map_is_anon(&map))
> >  		set_vma_user_defined_fields(vma, &map);
>
> Ah, we have mmap_zero_prepare() for handling the shmem_zero_setup_desc(). I was
> just about to ask whether we can just get rid of this here.
>
>
> But, hold on, do we now even need that? Could core-mm now take care of that as
> well, and we could just remove mmap_zero_prepare() entirely?
>
> That is, we'd make shmem_zero_setup() in __mmap_new_vma() take care of this?
> Then we might not even need shmem_zero_setup_desc() anymore.
>
> Maybe harder than it sounds at first.

I think I'd rather that be a follow up :) this series is about eliminiating the
one last (I hope?) corner case for anon VMAs.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

