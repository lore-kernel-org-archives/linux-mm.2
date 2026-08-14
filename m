Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272D3C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBC16B0719; Fri, 14 Aug 2026 19:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84546B071C; Fri, 14 Aug 2026 19:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B274D6B071D; Fri, 14 Aug 2026 19:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA8D6B0719
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:07:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF6D1400FF
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:28:50 +0000 (UTC)
X-FDA: 85101316020.12.A534B13
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 08882180003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:28:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kjO6iioS;
	spf=pass (imf24.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786746529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEOUg6UoxbxIuzn8yIbkhgeCbptl1CODXSgJsL68ae8=;
	b=Zy61YU7YyoPAbyceRK3jlu0RBnkKB/+yYpHGCYIp+GYfBvf65ihCua3My1sSY3qevX1t5L
	WJ/jTbIlcb0ONcTzqbqwlE/xh8u0gec0cB+ih68jK+s8HBccIsLchsVvjwiJMyIfNa3kpb
	QdhJ4olQBNBYVa8KraZnMSPG6cORDS4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kjO6iioS;
	spf=pass (imf24.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786746529;
	b=2tGm52Ab0PXt7AomrAr3GGxmMxkLTq2bjRrgqU0wjaowWuTJmFR5gYbJ+AsMKgIzWzN1DE
	i21HMaPUdbggRuthZfZhXAHD1PERC5Enhu8kZimVpWAHi21u5UJV5GTo2/s+XdpS6ZHq23
	Oo0EAQoYLUL+ylzCNh5248m9zyRg6IA=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d004f135b1so20708395ad.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786746528; x=1787351328; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KEOUg6UoxbxIuzn8yIbkhgeCbptl1CODXSgJsL68ae8=;
        b=kjO6iioSZL8BJQybu4EAkFlj6fol5uYup2r3vBgXu4mT3YGBbkiUrBZ1/IqIagGoAL
         6lJqhWZX0ro4/GqnfNJl8pUa4v6MnO1uzc5hC0XANtyfUEtZfdA7RxT0kdbQAFNuAc39
         ugfOgdfpVVdTPRNSB+5W+8h+M5yLX8ztuacbTdhrOhIwIEgX+ZXMy0qI0UyNuOzjqgUp
         CR0ylelyX3BtH0T3KhkfErvdu2OEUhfOUaLgTp5hov535ejVTolbHig9LzHQkSGWPXZx
         ZKq0PiyJFxUsvk4htOSSRuBCWL7wHxwfRuJdK0hIDHLz152qbhcTVqKp0HNDchcQJhbU
         ORhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786746528; x=1787351328;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KEOUg6UoxbxIuzn8yIbkhgeCbptl1CODXSgJsL68ae8=;
        b=U/sorbQzqVPyIX0GOJvIaAK9t732QUv0KvinXXthHdEp9oOU0joE3FhH3o2ouALOmI
         PUlXKIemvr07yY1g3R4FptBG67Lm6hk457uV4MFpGFSwoxprr6gZldgxJRaiJOKuFVPl
         yZl7u2d7wVHiJxTdx8zPdD8da7LVASNZ5vdIhAs7+ioKxPLQe8XGp8HiZS42oCIgrwwX
         Zjy1ENDsfIz990ZbegAfoTplmVwbTLgwJWvrPuRY3Yulj5e+aRSi8w7B7m4C4rgUbTl/
         +fnumHvuVFBNG4LiWu8athZOy0ivJQux4h8fL4VL3kWVxcf6AXjTnODmFS2VSPJn1VNt
         Z/yw==
X-Gm-Message-State: AOJu0YykP6O0HcHbAdDzncmwer1LjdDxBLRo7vEhRFwp2GqwWud8Bcly
	qDy3udf4F+eSZjVcRsJG2UiD0RrFTxaie4tryDw23kcrnkhRHCKkM6nGz66d1IUU
X-Gm-Gg: AR+sD10X1sQnAVg1rZ7JwSpDIZmoSk6GNXWaNJWXl9I2h1iRJLLFPdXpiDzHgJGFyEL
	g3BeTwHVLSPSOOyOdpsbloxIrepph1eWXH4iSHtGYeMrn+yrVcbzKFBVhvJOIJE72hW+JP4+GG4
	zlXEj/b3n/JgQdmzIvUoD5MJEUdgdxASniv4Wn+9K+tUBQht4U4C2gF1gYZ4dylukDkplo8LQyo
	00do2XEO7LR4933McvtfbZOMaIImHveTkBPwDc7MstQLRxmf/0+WHxAI98SSBtcA6u1hFKxHToC
	Jb8UfWOO2W4qHJt1aZmlsXpOimB10gSRYww2YuP7JIX/aVqu5IurVTEgK4VLd7IB8Li0JUE1uhZ
	pHCIVkQadWtNzPjHBeioH+ucgYXwkNGfONudAGqhGj6jpCouHdX894vEtQR+FJKvom9NG8yTRs7
	UEHOPQfUgJx6JVrQwMPeOH+ZCahNDCGQ4geZBt8Ep4wg/TAt4WBwZYszsn8hYfgg7OSKVSmus6K
	uJEIXrux3dsGcDS2kwcFUKf0bOFD1brKk8VhPgjo8riEDn6GtcAb2P0wGgfFYB1jodrhnZZAvku
	b1OOIw==
X-Received: by 2002:a17:902:f68e:b0:2ce:8e70:3210 with SMTP id d9443c01a7336-2d3b0ccb146mr81543585ad.16.1786746527564;
        Fri, 14 Aug 2026 15:28:47 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aeb7978fsm15330245ad.58.2026.08.14.15.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 15:28:46 -0700 (PDT)
Date: Sat, 15 Aug 2026 07:28:43 +0900
Message-ID: <m21pc0qquc.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	akpm@linux-foundation.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: Re: [RFC PATCH 1/6] mm: nommu: fix do_mremap() to correctly update internal states
In-Reply-To: <an77pELeQdW-sTEi@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-2-thehajime@gmail.com>
	<an77pELeQdW-sTEi@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08882180003
X-Stat-Signature: jqngfkph74e685ncdmkn7f7shy4sbost
X-Rspam-User: 
X-HE-Tag: 1786746528-921182
X-HE-Meta: U2FsdGVkX18TLPAGC5C/p6pxZYPtp1KE212TAHWeKLcOVW80gtGMIHlLaCi8ey4O5QsitNhKxUysThqjXA82PwZNz8Od1LpDkkCJXySs58+x3W5sgh+poJo8EBzu0IMcxMRxasT6P6lrG2BJdU0xtvIMuDMBi9riEk6RoqTSZY5kPbX9v2XKaX5rdW+292dtweymrKEU+bMbuOeYAHr2vKj1VeRbqlTN4ZhbWptIrHusDYeIf4gnlUAazhSwyp61HcFktw83lBUAqTL8q7T5H6y5ZA7SnamytaP1F8o8RxoaBh4AMFzwrdK3y5WFs44ysrdUv8TWg1Ywo6Ca89tmbQTc6ZLYxzyEMw8NtwMdJsANmRwHhKE06xuhjQHdZdmxt3cj4EfZ0IA0EMeDYt/S3SJiL0gtax8RVJypTkm9kFkGLvB9gmPVsPeOp88GyNF7cJgVjptRnuhXvoamlpwzJuwP1NgoDWuWshQpXojNT5IOjTL9yH2N5X9X9Ai/7S9aJ8ODXVUPx3n7M0p1eSZcAbunC47uVR4sdJ5qHP2XoxUpBQybeEgvZci1uAPcPrVvfOg1X8C9tCLkWlnGktb+zQbTeD1XRMOXHNP/fFS5zseZmRAzR5asdc+3OSMC17evQydU7j0kDsTeJ1eQKpK6N/k6EBywfxMP47cX8yJrwMEUO2gWkYkOudoDa0Ql1IiilIaoyIQTgvcjB/dbD61vDsoUfCA7siFZ7G3GUf580p+/fV2bk5z5dWG91nBiFOyQsy+nyovi2OoXWd9MlGKGqYSQxQ13xkY1MGVVhfFmLYUwHDts+JzyA3l8Ns1wknesO2tI/wtiIuxisS4uvGF5F94nOSl8ULQfLO7CyKgr1z/UznGWKTPZ58kskpvz0ws+qtRgu+o1DB3IOg4sYXkal3ywCnWO3sGf9NJM0o1oM9nOl92OpjhYthAtwOrynKZIdvvIQ3wHXinKRC5PUzm
 pD5z5wsn
 fUDnDGrvo1X07zizaf54k2iUKC/ourmF5A7vHtj5/TToQo0uqA/Iy4nqY3W95AWH25beeHWGgy1bIHeU2MKL+tbPUNP88PfcUNRcqvVlx56ltR1z4URijCu4tKmXmblbpPXDnInLxLio8YuY3JnMMPGdrW0yIjPRaag8uFJX9WrQ6hErJAsV5eqFgv3HzK5AwAqsiVy/VbVqq854I85U7ZtrlSy+GOyLbyIRPz/4RNMFD0S0eB4qF3EBzP5WlA8dz6SzqbdrVGYxf73Rqt8Ma4wHxntXcN4YJqwzf4T73wQaw2dki4uPIt0xAUuVXRN3GebFGAXxu0GST2kHc3JpefFUc8VZTiDZefEMDoSCkg3VliL55HOquJYZq6lVfrVZUIQttliRiZV637pezBuN8ANoMciTGYzci2gNuytENsBDPhXnBIwv0YyKm4r4zyrVJTfO4XReUgzTtCfOzkGQjlbpj5OcAe7gtbtG9xbutSQwTLOv6AV1T6ZtiEN+xxFHptR0LGEFEFEXhA8pDbnsLQPEafuxHh9Xpi2UjKWFXnQqP7PBLBJmtaIMa4AdcQ7QWDADYesDm4b5hR0o8mM40o47Lveg3bOGiEFqq8n/QbMZ0BWox4pARefUhvkd21hEbxK6XCUnrj+SYaf5SLYvdeAlRS0NYWhZ6QLWjRJaOWPGpWD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 14 Aug 2026 20:52:05 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> On Thu, Aug 13, 2026 at 03:33:56PM +0900, Hajime Tazaki wrote:
> > When shrinking a VMA via mremap, the bounds are modified directly:
> > mm/nommu.c:do_mremap() {
> >     ...
> >     vma->vm_end = vma->vm_start + new_len;
> >     ...
> > }
> > This shrinks the VMA without updating its bounds in the maple tree.
> > If the maple tree (mm->mm_mt) still contains the old bounds, a user
> > process could access the freed portion. The stale maple tree would
> > incorrectly return the shrunk VMA for an address past its new vm_end.
> >
> > This commit fixes this issue by calling vmi_shrink_vma() when shrink
> > happens.  Additionally, if a file-backed, non-anonymous map is to be
> > shrunk, it reports -EINVAL like do_munmap() does.
> >
> > Moreover, to maintain i_mmap interval tree, two functions,
> > add_vma_to_mapping() and remove_vma_from_mapping(), are decoupled from
> > setup_vma_to_mm() and cleanup_vma_from_mm() respectively.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <liam@infradead.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Cc: linux-mm@kvack.org
> > Closes: https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com
> > Closes: https://sashiko.dev/#/patchset/20260710021028.892645-1-thehajime%40gmail.com
> > Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> 
> Fies: 8220543df148 ("nommu: remove uses of VMA linked list")?
> Cc: stable?
> 
> But if you're going to do that, you really need to make this as small as
> possible and maybe separate out everything but what is required to fix the bug.

ah, I missed this point when preparing the patches.
Yes, I would look more carefully to past commits, clean up things, and
prepare a meaningful set of patches which can be backported without hustle.

> > diff --git a/mm/nommu.c b/mm/nommu.c
> > index ed3934bc2de4..89444ee2aca6 100644
> > --- a/mm/nommu.c
> > +++ b/mm/nommu.c
> > @@ -559,36 +559,51 @@ static void put_nommu_region(struct vm_region *region)
> >  	__put_nommu_region(region);
> >  }
> >
> > +static void add_vma_to_mapping(struct vm_area_struct *vma)
> > +{
> > +	struct address_space *mapping;
> > +
> > +	if (!vma->vm_file)
> > +		return;
> > +
> > +	mapping = vma->vm_file->f_mapping;
> > +	i_mmap_lock_write(mapping);
> > +	flush_dcache_mmap_lock(mapping);
> > +	vma_interval_tree_insert(vma, &mapping->i_mmap);
> > +	flush_dcache_mmap_unlock(mapping);
> > +	i_mmap_unlock_write(mapping);
> > +}
> > +
> > +static void remove_vma_from_mapping(struct vm_area_struct *vma)
> > +{
> > +	struct address_space *mapping;
> > +
> > +	if (!vma->vm_file)
> > +		return;
> > +
> > +	mapping = vma->vm_file->f_mapping;
> > +	i_mmap_lock_write(mapping);
> > +	flush_dcache_mmap_lock(mapping);
> > +	vma_interval_tree_remove(vma, &mapping->i_mmap);
> 
> This function doesn't exist in mm-unstable, it's now mapping_rmap_tree_remove().
> 
> Please always base mm changes on
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/?h=mm-unstable

I understand, will base this branch from next time.

> > +	flush_dcache_mmap_unlock(mapping);
> > +	i_mmap_unlock_write(mapping);
> > +}
> > +
> >  static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
> >  {
> >  	vma->vm_mm = mm;
> >
> >  	/* add the VMA to the mapping */
> > -	if (vma->vm_file) {
> > -		struct address_space *mapping = vma->vm_file->f_mapping;
> > -
> > -		i_mmap_lock_write(mapping);
> > -		flush_dcache_mmap_lock(mapping);
> > -		vma_interval_tree_insert(vma, &mapping->i_mmap);
> > -		flush_dcache_mmap_unlock(mapping);
> > -		i_mmap_unlock_write(mapping);
> > -	}
> > +	if (vma->vm_file)
> > +		add_vma_to_mapping(vma);
> 
> add_vma_to_mapping() also has a guard against vma->vm_file, either remove this
> one or that one (this one seems better to remove).

yes, I agree.

> >  }
> >
> >  static void cleanup_vma_from_mm(struct vm_area_struct *vma)
> >  {
> >  	vma->vm_mm->map_count--;
> >  	/* remove the VMA from the mapping */
> > -	if (vma->vm_file) {
> > -		struct address_space *mapping;
> > -		mapping = vma->vm_file->f_mapping;
> > -
> > -		i_mmap_lock_write(mapping);
> > -		flush_dcache_mmap_lock(mapping);
> > -		vma_interval_tree_remove(vma, &mapping->i_mmap);
> > -		flush_dcache_mmap_unlock(mapping);
> > -		i_mmap_unlock_write(mapping);
> > -	}
> > +	if (vma->vm_file)
> > +		remove_vma_from_mapping(vma);
> >  }

ditto; this might be too.

> >  /*
> > @@ -1351,6 +1366,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	if (new->vm_ops && new->vm_ops->open)
> >  		new->vm_ops->open(new);
> >
> > +	remove_vma_from_mapping(vma);
> > +
> >  	down_write(&nommu_region_sem);
> >  	delete_nommu_region(vma->vm_region);
> >  	if (new_below) {
> > @@ -1364,6 +1381,11 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	add_nommu_region(new->vm_region);
> >  	up_write(&nommu_region_sem);
> >
> > +	if (new->vm_file) {
> > +		vma->vm_file = get_file(vma->vm_file);
> > +		new->vm_file = get_file(new->vm_file);
> > +	}
> > +
> >  	setup_vma_to_mm(vma, mm);
> >  	setup_vma_to_mm(new, mm);
> >  	vma_iter_store_new(vmi, new);
> > @@ -1386,16 +1408,20 @@ static int vmi_shrink_vma(struct vma_iterator *vmi,
> >  		      unsigned long from, unsigned long to)
> >  {
> >  	struct vm_region *region;
> > +	bool has_mapping = !!vma->vm_file;
> 
> Better to use const for this kind of thing.

thanks, I'll fix this.

> > +
> > +	if (has_mapping)
> > +		remove_vma_from_mapping(vma);
> >
> >  	/* adjust the VMA's pointers, which may reposition it in the MM's tree
> >  	 * and list */
> >  	if (from > vma->vm_start) {
> >  		if (vma_iter_clear_gfp(vmi, from, vma->vm_end, GFP_KERNEL))
> > -			return -ENOMEM;
> > +			goto restore_mapping;
> >  		vma->vm_end = from;
> >  	} else {
> >  		if (vma_iter_clear_gfp(vmi, vma->vm_start, to, GFP_KERNEL))
> > -			return -ENOMEM;
> > +			goto restore_mapping;
> >  		vma->vm_start = to;
> 
> you're not updating vma/region->vm_pgoff here, that's incorrect.

if this (vmi_shrink_vma()) is called with split_vma(), it looks like
the offset was updated before coming here, but it it's not, yes, looks
like the value remains same.

I'll look into detail.

> >  	}
> >
> > @@ -1415,7 +1441,15 @@ static int vmi_shrink_vma(struct vma_iterator *vmi,
> >  	up_write(&nommu_region_sem);
> >
> >  	free_page_series(from, to);
> > +	if (has_mapping)
> > +		add_vma_to_mapping(vma);
> > +
> >  	return 0;
> > +
> > +restore_mapping:
> > +	if (has_mapping)
> > +		add_vma_to_mapping(vma);
> > +	return -ENOMEM;
> >  }
> >
> >  /*
> > @@ -1544,6 +1578,9 @@ static unsigned long do_mremap(unsigned long addr,
> >  			unsigned long flags, unsigned long new_addr)
> >  {
> >  	struct vm_area_struct *vma;
> > +	int ret;
> > +
> > +	VMA_ITERATOR(vmi, current->mm, addr);
> >
> >  	/* insanity checks first */
> >  	old_len = PAGE_ALIGN(old_len);
> > @@ -1567,11 +1604,75 @@ static unsigned long do_mremap(unsigned long addr,
> >  	if (is_nommu_shared_mapping(vma->vm_flags))
> >  		return (unsigned long) -EPERM;
> >
> > -	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
> > +	/* vm_region->vm_top != vm_region->vm_end when sysctl_nr_trim_pages is 0 (default: 1) */
> > +	if (new_len > vma->vm_region->vm_top - vma->vm_region->vm_start)
> >  		return (unsigned long) -ENOMEM;
> >
> >  	/* all checks complete - do it */
> > -	vma->vm_end = vma->vm_start + new_len;
> > +	if (new_len == old_len)
> > +		return vma->vm_start;
> > +
> > +	/* shrink only happens addr + new_len and old_len are in different pages */
> 
> Unclear really I don't think you really need an explanation like that I'd drop
> the comment altogether.

I agree.

> > +	if (new_len < old_len) {
> > +		/* like do_munmap(), we're allowed to shrink an anonymous VMA but not
> > +		 * a file-backed one
> > +		 */
> > +		if (vma->vm_file)
> > +			return (unsigned long) -EINVAL;
> 
> You break MAP_PRIVATE-/dev/zero here but then unbreak it in the next commit,
> this is a bisection hazard.
> 
> I'd just leave this check out until you bring in the /dev/zero stuff.

yes, the order, and the combination of chunks to patches are both
broken at this series.  I will reconsider the series to avoid such
issues.

> > +
> > +		/* vmi_shrink_vma() needs from/to pointers to be removed,
> > +		 * (mainly used in munmap) so, specify them.
> > +		 */
> > +		ret = vmi_shrink_vma(&vmi, vma, addr + new_len, addr + old_len);
> > +		if (ret < 0)
> > +			return (unsigned long) ret;
> > +	} else {
> > +		/* growth path: grow up to vm_top should be handled here. */
> > +		unsigned long old_end = vma->vm_end;
> > +		unsigned long end = vma->vm_start + new_len;
> > +		unsigned long grow_len = end - old_end;
> > +
> > +		/*
> > +		 * Initialize the newly exposed portion before making it visible
> > +		 * through the VMA or i_mmap.
> > +		 */
> > +
> > +		/* read contents of extended map from file, or zero-filled if !vm_file */
> > +		if (vma->vm_file) {
> > +			loff_t fpos;
> > +
> > +			fpos = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> > +			fpos += old_end - vma->vm_start;
> > +
> > +			ret = nommu_read_iter(vma->vm_file, (void *)old_end,
> > +					      grow_len, &fpos);
> 
> Umm, this function doesn't exist at the point of this patch so this breaks the
> compile :)

this is also same issue as mentioned previous one.  will also address
this part.

> > +			if (ret < 0)
> > +				return (unsigned long)ret;
> > +
> > +			if (ret < grow_len)
> > +				memset((char *)old_end + ret, 0, grow_len - ret);
> > +		} else {
> > +			memset((void *)old_end, 0, grow_len);
> > +		}
> > +
> > +		/* The backing contents are ready. Now update the VMA bookkeeping. */
> > +		remove_vma_from_mapping(vma);
> > +
> > +		vma->vm_end = end;
> > +		ret = vma_iter_store_gfp(&vmi, vma, GFP_KERNEL);
> > +		if (ret) {
> > +			vma->vm_end = old_end;
> > +			add_vma_to_mapping(vma);
> > +			return (unsigned long)ret;
> > +		}
> > +
> > +		/* vm_top remains unchanged; only the logical end grows. */
> > +		down_write(&nommu_region_sem);
> > +		vma->vm_region->vm_end = end;
> > +		up_write(&nommu_region_sem);
> > +
> > +		add_vma_to_mapping(vma);
> > +	}
> >  	return vma->vm_start;
> 
> In general you're making this function very long. Can you split it out please?

I understand.
I would split do_mremap() into 1) params tests, 2) shrink path, and 3)
growth path.

-- Hajime

