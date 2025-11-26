Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1B2D10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515006B000D; Wed, 26 Nov 2025 10:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC346B0012; Wed, 26 Nov 2025 10:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402966B0024; Wed, 26 Nov 2025 10:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC2F6B000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:01:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA46059FE6
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:01:53 +0000 (UTC)
X-FDA: 84153072906.05.3D9BCE8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id D88FA180024
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:01:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AVwSH+d8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764169308; a=rsa-sha256;
	cv=none;
	b=0vyXyhI6RZJTHJnzKg5Ggr/K3FIVH6MJfe2y28qlz0SVRqhpdLjomv8ZlQILlluUSKO+x9
	okQBMm/6ujLDUcKCTdkn2hYMUxOCUBaWnsvp4no1KvQa97NaL8gsorIti+PHiav4btO7Gu
	+3gOXPbrtYYz4aY3bkV2C3lDMXNgLSQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AVwSH+d8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764169308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1n/vpQH5pSBx590uYZckx32zzKrdYz9v3Ax1z+DHcPo=;
	b=tpqI4b4Gdh5AWTOA804WzD7Qtxkfx0cK9fPHD6nXvCBUwiKyJsjRab9X1y5ddpeNwm8YkC
	UszSOmyeayELsTN9kaHusN+fvFWM1MGrq6bZGR8TL3efEecc9Cq52zjbHLtE0YCvGagWpF
	LzYYadHza/OgPTYbKm2F3a6fDqDOE/0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1n/vpQH5pSBx590uYZckx32zzKrdYz9v3Ax1z+DHcPo=; b=AVwSH+d8QxPF97//ogYT9DX/SS
	dlQyy3nrDZ3KghcZUCpSV/td4REyV8qHXynvojouNuJNcW1fEzvHKjQ1FCenRtp+utBZGyEjR1yCI
	fgkdcda0FwkvW5AB6EURDojxqPeXF4zRlcu5ZurOgm69NL33DEBv9r1lleKKL4hbzBNLbwlRkHjgF
	p2RNW4i+ThGp8QQOQQ0efRo+IndYR0sdZAVtdNmX/LmoaIE5f0yW9sacaRQn+ORxvIzDc13KX3Y2e
	+ZtniJLjVJb0dA6PpAnzU/DBOz93ud7tKBeQqpWXN1o81B0vSwQfJr7yXLehYRA4GA+7Qhjn81g4t
	B9V56A6w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOH1Y-0000000AGs2-284f;
	Wed, 26 Nov 2025 15:01:40 +0000
Date: Wed, 26 Nov 2025 15:01:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
Message-ID: <aScWVB_l-Hh5zGCe@casper.infradead.org>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <CAJuCfpEge7MJD1joXz=tKgcD7DQgPggjCKF9PLPr3NZEaw=ouw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpEge7MJD1joXz=tKgcD7DQgPggjCKF9PLPr3NZEaw=ouw@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D88FA180024
X-Stat-Signature: 39zi9r7tcpts561nffs6mggbtddsn3hh
X-Rspam-User: 
X-HE-Tag: 1764169303-328613
X-HE-Meta: U2FsdGVkX18PNc3WDTJIr4rm/NhddMoiAoOTQ0D1mD3q9hr6jlYhJbbgnvoCTvdjToMK/RHiBrchRJ0uuveTqPfoXqMM8tXYJL5THzM+Birns3HYsSrfBLrYAXCbdr/bBL2+5SnxkruvftqWUQbU4aBJScJbpmMHXCLvF0oMeAZnkW3Qg1PfkyFK2FCiWZBM+zjWnSo8kWkcdf019Ek/4DooDOusrXakdVMfVGZXaOQ9+C/otN9KK2qJ5giwsJPYQJZy/YWFEilIHdiYKL2+B+w9CfCcNNYnRHFTeafBpVFpHjjgA8nu/bgSWKF4Zffv3XI8U/0HW/0lEWXMHGMmqlqLSwjQtfUwwE0W5GZjjkrQc8nGe5quTq8TXVMVBf0c9uRlkjhN/8jfehXfuSqYQbav5G953VSCFasxn4TilTFSG3XpIdTP8EUlMMEN4fYJe5eFwPk3oo5rvGXk6uHW77UUbZvW9KCj26LfCLLEud/l5BLVLNCgXDgfZvRCp4tqOU15L9st8kJ/JanC05tXPoG8c9DGEF9744Jf37AAyTPcROO2sPvbJJlaGaiUL4+1+NS+6ifIaB9Xx8vJVzTEvpzU4P8yTqFpPh0vxvxg2xyGyAtF0PjyTIxShU0uChdlBdGL3MUNrs07gLuTlRsWebg9UQcJuzMQuhvNOzSbAvTOdjTS+curKYB2N/ax8/zey+Lp4PWqx1/MPQw4vYYluwgG4tJQ9A+5RajL85SANpR9NFflBvoEz2NLPbX+SET4TOWRrswZPXM2c/jmJ/F3pdx5Mo92Wcl6ubp7uNAMgltN/C0qv+FdAo60ZxyfMvlefl09wnWCZaAIVuR+S8TAG3b3Qx5ONvSZib+y3A7FHNlIiNw1B7dkza35N5jjV03eVPvLJjTnurTjUqPiQ8OVXItDNxqturzx+JbuitD/yhtJvg49/FzQU7D467AgroFG/aV8aicUOHzTTPxlowQ
 a6L45/6b
 //vnv3e9/8TXVIVhMcZtD2JSrBDTe/2Zj7Xwwsi3RZR/PFQYh4DvdnYnnzFe+UXcfm6BsxtmYPZ6Yqa7vmQzCqISy9uoA8R4jsx9P3GF1dxoh/HMqKdV7syjkuP3fX0NJIbLXY4IH4epCvdVEkNyS4T50G9Uu0JnBNreW+tX8dLb92lYPym3tjVjd82GsDgn2qQjvkxPf6Yk0L8FjB1SgbNnpuQZhltoYNSok45exn5/vCaBfL7yC/d/BCR9XgPO1P8H55B2HD6q0J8zGJnnusqbhE+vbdXWjsWJVGj1cp4Aq0l1wgXZrlUwNyRwMfTRsiI+d36uKRanhr5JhnMMJJOV7IQk/Jq7dMEdKVrzlNeIvJLl/Lt6vo8gMU3580UT0ej0jAzHFxz/fPSHoprOl8ZpbRN/c/xZ6QLviYgbVoe5lznwdNH6VWxLUP4R9JAoQQoMhJC3yDnPPFnYCxXfH3b8oq0oIcPfwIuQVTXs+ENl7mSYaDcuS+LjF4Efp4DhK7XLICGkXc0kPbh+VtfV0/y7HEvKhlWBpwOnaJo9VNyqjKWU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:26:26AM -0800, Suren Baghdasaryan wrote:
> > >         if (err) {
> > > +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> > > +                       /* Oh cobblers.  While we got a fatal signal, we
> > > +                        * raced with the last user.  Pretend we didn't notice
> > > +                        * the signal
> > > +                        */
> > > +                       refcount_set(&vma->vm_refcnt, VMA_LOCK_OFFSET);
> > > +                       goto acquired;
> >
> > Wait, why do we consider this as a successful acquisition? The
> > vm_refcnt is 0, so this is similar situation to an earlier:
> 
> > if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> >         return 0;
> >
> > IOW, the vma is not referenced, so we failed to lock it. I think the
> > fix should be:

Yes, I also wondered about doing it that way.  Of course, we hold the
write lock, and we found the VMA, so I don't think this can actually
occur?

> After sleeping on it, I don't think we should be masking EINTR error.
> __vma_enter_locked() result might be the only place where an outer
> loop is checking for fatal signals, so returning "failure to lock"
> instead of -EINTR might cause the loop to continue. I think this fix
> would be better:
> 
>           * If vma is detached then only vma_mark_attached() can raise the
>           * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
>           */
> -        if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> +        if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> +                if (fatal_signal_pending(current))
> +                        return -EINTR;

This part seems too much to me.  We don't need to check for signals
often, just when we'd otherwise sleep.

>          rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
>          err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>                     refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>                     state);
>          if (err) {
> +                if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> +                        /*
> +                         * No more users but fatal signal is present,
> +                         * still return the error.
> +                         */
> +                }

Umm.  Does the last owner of a vm_refcnt not need to do anything like
free the vma?

>                  rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>                  return err;
>          }

