Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0FAC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E726B0092; Wed, 23 Sep 2026 11:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF186B00AE; Wed, 23 Sep 2026 11:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F56F6B00AF; Wed, 23 Sep 2026 11:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DAB76B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:49:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9224C140400
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:49:23 +0000 (UTC)
X-FDA: 85245461406.13.B2CA8D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C577C40012
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:49:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NF9rOOuQ;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdYD+vj0PQM7f3DCwjSFaWjl/2i785x3uECVm9fqvX4=;
	b=tYy11TYgShHbJBcnGvmcfwXwL0PGPeilzBO4dmEFpv54KJP4cQrJRc+bQB5PwjSijyQeJB
	dq5rRN5NRq1AAiihKtWPcoyMg0QxgY44BzdNQAKxvm5NlZTmklHmO8ECZJmRKI7nyVnD9C
	D7YyzSUuNgaNJ/wlxWHJRCDXkwaDZZk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NF9rOOuQ;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178561;
	b=qpXvJh/IMinDd3CRzSjrao0NPuLvi+5ZPZu5/RlzOI7uvuIaqekUtORGgUmZqyWBulTKMt
	UQ4acKzDUwVqq6sIC9u3S5v8Bl1CiAI2GvQN+zY7qiGvQntW407+lNWvSqo/JyFk1BDPr5
	6S1uF6n7LqD6C27G4kdp0ZlHxGeg2lw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B6F643BF0;
	Wed, 23 Sep 2026 15:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1710F1F000FF;
	Wed, 23 Sep 2026 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178560;
	bh=kdYD+vj0PQM7f3DCwjSFaWjl/2i785x3uECVm9fqvX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NF9rOOuQbMImBXu9fSoDsF2ga1YCwZqktAjLh65TNe4SO+7mG2BXJ73Xz9JHVD3NV
	 3RnSWThnfxr49VoX2PLuT1VqbMqMlKAbBkQt73/vtbJEBWQESg2T5w8SSjEYYLJPNp
	 9cMlOCcjeL2yJHBGQZXaG6vbwuDEufoP5w54pV+RMrOID+6Ti4KV6biI5sUK899cI6
	 RMf7CaBYCMD/2gTBlDyeGG7657XzzcMgpeZKHChe2VjTjpaCBZpLQPyxOy2hk8EYsV
	 CbTsOooIx0z6dlxaHTlfJh9M2CuHFG+s3WKxYhSUecotOXu8iUMcFWHml/Sj+AeeaB
	 BlEduBODYdeOg==
Date: Wed, 23 Sep 2026 18:49:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 4/5] hibernation, KFENCE: explicitly map/unmap KFENCE
 pages
Message-ID: <arP0-maAEi5yeNnl@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-4-7f7dfae3dbe0@kernel.org>
 <fec1931b-1173-4e14-b74a-7b3987a9b7bc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fec1931b-1173-4e14-b74a-7b3987a9b7bc@kernel.org>
X-Stat-Signature: cuzyydme8dzyem7fbwoutstehus3b96u
X-Rspamd-Queue-Id: C577C40012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790178561-239543
X-HE-Meta: U2FsdGVkX1/GjJnawKDNSwKY5xrZcOBiAwUUSVybkLUY6fqIEcprXIOiQ7+9Aa1l/1wV48UM91cgH/UfTbVYB6z4lWOGSmyguPqNDotgZ+cNsPLcSagdLwUwA7g0ASdY5T1Jsd1tKScKGhm13Ndrf9lHjEeox2WRRJCXry2IQdTcm8ED9GLYeG7SyYfOgBQbT9vGpxx+/DoDHswiEsMFz6tSgR6KufAlnaI5o5+YvJgpUuYEHjCAW0tJAvrjuywQqJtlu1UsuT+eorejRJt9fSsCS+YT408NKYgLtWz7NupRciJztcdJaVj1QKy+6RpwsUjA8M113ofbAoHrKVFCqEX59B8TE6HhCjWRreGOebGBQzAo7zIcdjJ71VPL+G3DCM407Ms1fEIubAEVQ1RYrwuQ+tMPaso5h0dQ776pKdeUZxv1Z9I/vAPCqpl5TscdQNOIrJOKV6hNVxvGD2YrUHBgn8uSYdp0TtBTEEMFH5CgtSIxfkxBYQ1MkbdKIvxBVHrbXbmtrfbVUBIFrMBMUB2iCeDuiGpwME3AoKtaINxP0uWwINEORr05u+0YVVUy+iKj/oKRuuWrQ7JVMc4z4NaAoCUB6dGZ9XgcXKdTjNkBQnPCdXidSyiP+Jr0fKxv//RYCNldHQw1xcvCoHnOp1qVSdalCkd0osjtUyghMrlQXku052PQhck187CdE+lcqwfFS7A72Pg1pmjRxXc04OVQWMdmj7pZ88qoixPJ5NKZyzIHvr8dea5YuQVEvx6+TAuPfF97V5KAg5NjcoD5Tkb5WOI4u5vOSAb2Qulx7yXwk6jKQL91xW1tNtOrNzcuf8+e41zh+f8tEaZv57PedRFREwNyk7XTxdYRIPu3rOL1l5iMwHI+eZxwtKpJ/s3zh4WPW/FyHx4kdmW8evEog+6KY6q5OPS6u4drmesmw8FcZfpKWHzqjlqYgxn5hd1Jw+o+Nz9znrXky3ovxCp
 2gqaX1fA
 1tiuucShErBhvIjXHP3vyZ0EKYJlB8dpiwpzFP2t2GxTN7zsOFciM92pCyMDgUH1B5xDaheH3Oqy9JcktAF/GuqHad9UTCxHA59buyYiyL1oPFo8RvvM98rMbdVf3l85ptmVMruSQsbtLaiixofJDe11vV43tGdxm2ANf7mS1tRk4Pu8AFtcdyFjx1w2dFBMlt9C18J6i0ytK4V0y3FqFTKXkmVzg7tsGEH9J0ys5wcfJ7+yO0Xuq25mEapviil7d195EVsTune30pC1z/cvZH/0P8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 12:31:26PM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
> > The pages protected by KFENCE are removed from the direct map.
> > 
> > safe_copy_page() temporarily maps and unmaps them using set_direct_map
> > APIs, or, when the stars align, even using debug_pagealloc_map_pages().
> > 
> > Neither of these APIs cares whether it is a KFENCE page and both blindly
> > perform the update of the kernel page table for any non-present page.
> 
> Agreed, we should route this through the actual mechanism that modified the
> directmap in the first place.
> 
> > 
> > Ability to use debug_pagealloc_map_pages() to remap KFENCE pages when both
> > KFENCE and debug_pagealloc are enabled is an amusing coincidence.
> > 
> > But with increasing appetite for using set_direct_map for hardening
> > purposes, it becomes too big of a hammer to enable saving any non-present
> > page in the hibernation image.
> > 
> > Another gotcha is that loongarch that does not have a direct map at all
> > advertises ARCH_HAS_SET_DIRECT_MAP to allow coexistence of KFENCE and
> > hibernation.
> > 
> > Extend KFENCE with a bitmap that tracks which pages are protected and
> > provide kfence_force_mapping() and kfence_restore_mapping() APIs that allow
> > forced mapping and unmapping of KFENCE pages.
> > 
> > Use these APIs in hibernate_{map,unmap}_pages() for KFENCE pages.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  include/linux/kfence.h  | 29 +++++++++++++++++++++++++++
> >  kernel/power/snapshot.c |  7 +++++++
> >  mm/kfence/core.c        | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 86 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> > index e5822f6e7f279..33a126cb6d1b7 100644
> > --- a/include/linux/kfence.h
> > +++ b/include/linux/kfence.h
> > @@ -222,6 +222,32 @@ struct kmem_obj_info;
> >  bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
> >  #endif
> >  
> > +/**
> > + * kfence_force_mapping() - make sure a KFENCE page is mapped
> > + * @page: page to map
> > + *
> > + * Check whether @page is protected and map it if needed.
> > + *
> > + * Requires: is_kfence_address(page_address(page))
> > + *
> > + * Return:
> > + * * false - failed to map @page
> > + * * true - @page is mapped
> > + */
> > +bool kfence_force_mapping(struct page *page);
> > +
> > +/**
> > + * kfence_restore_mapping() - restore mapping of a KFENCE page
> 
> 
> The name is misleading. You are actually restoring that the page is
> unmapped/protected?
> 
> 	kfence_force_mapping vs. kfence_restore_mapping
> 
> is confusing.
> 
> Can we find a better pair of function names that describe what is actually
> happening?
> 
> Maybe something along the lines of
> 
> 	kfence_prepare_copy_page
> 
> 	kfence_finish_copy_page
> 
> That rather expresses what the caller intends to do.

Naming is hard :-D

I feel that _copy_page() is to vague and adding hibernation there is to
mouthful :(

And these could be used outside of safe_copy_page() someday.

How about 

kfence_set_page_present()
kfence_set_page_default()
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

