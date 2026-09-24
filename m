Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18E65C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 16:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6FF26B0088; Thu, 24 Sep 2026 12:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E205B6B008A; Thu, 24 Sep 2026 12:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37166B008C; Thu, 24 Sep 2026 12:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8E1C6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:02:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CDAD1A03FE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:02:45 +0000 (UTC)
X-FDA: 85249123890.24.CD28200
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7BFC3160012
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:02:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCVCgE0g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790265763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTVNxkLpxxqWMqUQZ0iwgzz/ZL7tmFRV02wmYrTnaqI=;
	b=vUWeQBJTs0m8fahnxsPPek3O+kX+1cruBM4ebgPXkwm91gonvjRZJAECzrN4aZIMDxIy2K
	jvSPmu489UOJkMj53hBTW6DQ/FcxvvZofjZ29otVdfuosH0aEJCAtJh/h1vcAVXhv8R0cb
	Xd3lb3IUmwgF/UZqJrkdJAiaj3BeVUA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCVCgE0g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790265763;
	b=62oCD7M6tuCEDP/pdXeoRLinpINyKToj88VuuZ/kliMtxAdi1nbaE7fe8qNMC3khaEHc0i
	Oumsh6yr6DIZbUvbSY9fUAQ949yWY2IeXkUlZmdT9WZRHWhu7ZELoh7o6fKceO9PYLISxR
	L5HewuoPAx5w3lyRi5GZl+RtWQUF+r4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03E3A601DE;
	Thu, 24 Sep 2026 16:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7769E1F00893;
	Thu, 24 Sep 2026 16:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790265762;
	bh=LTVNxkLpxxqWMqUQZ0iwgzz/ZL7tmFRV02wmYrTnaqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JCVCgE0gmJUzhASH+5rtu/5xRKwTuLgflc/WYMUQqRPPnF9eI+KOFeYkTO8Hj9Asu
	 lbIam1iYoMGzFAljxVrWwRbgIxINu4lshZrJIGGYrNa7OLMnEogLxR8YWuzOzCddZN
	 4rjqCo+1pd+4rkDWcIyXhh3/E0Ly+Hz2ffau6jPxiS9hnkwG1A/+v3o95vWGPGZ/9R
	 k449H4J9d3LUcEk72NCiYEiPVxoaoWNgviro55RD1GvOrIxfXrdSDJXKkQzOPTGyE8
	 4/Gk1eVUwiTQLWHPl9yE2MN2pRY8uPzQPcGVf/FHGn7+apyRqj7iMM151m4VIRGFJB
	 PlnDtnnDfHEeQ==
Date: Thu, 24 Sep 2026 19:02:35 +0300
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
Message-ID: <arVJm8CiLG6vpy9-@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-4-7f7dfae3dbe0@kernel.org>
 <fec1931b-1173-4e14-b74a-7b3987a9b7bc@kernel.org>
 <arP0-maAEi5yeNnl@kernel.org>
 <d568a29b-5745-4214-96d3-1b635cd46c15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d568a29b-5745-4214-96d3-1b635cd46c15@kernel.org>
X-Stat-Signature: o71s3g9tm4ibqkuze7xy1rwr9h6trsy7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7BFC3160012
X-HE-Tag: 1790265763-751112
X-HE-Meta: U2FsdGVkX18gYkEUB5UQK2bE0Jz+0cL3s+eMwf9xSlwaLNGr8lGaWixpSAa7iJkCSRPlhy7p1l4cpdYF53shHEUjQ1JgGabZum65vDlQpEop7bqg1ARyMClc5OpK4RhKiO2XHzLKdpyO+qRfp51QPsaqZ1agMc8yKBH9SJKwrXKt1/V/nvKj2hkPDvSAH3L283qb06M3nkmTLs8cZoXCAPt0zh/+EHXSi4+CwaYPYIaSIPCLO5Rw2uUThxAw0jnTJ5un24aaDOOL64NRWe5QFsHiXqQb9A9r3QTpB74ca57TTuf8ZrKnUNUB2PY8c6qhV2QdX7u7JR9QLjH8JTrEfd34Uk5l/2I09mWBjhTsIhGCq8bFS2KLL61wN+dqgkc5ROWx2K7QF+5vDqvWLmESdsBjA8AVBUZBRp3H/wQuWiwF3EA0v92FBrxpv8PFpJhqxmuJj6USsY+kYYMkLhS/NxWZ7GMjOoUnFtziiYKnuZVGUARD01LGeFyUCSG4XlatVnt7gSfmjyIYe3s4tbRtt2g36TLCJE4YJ4aug6P/7+4HZ2p1xpWZ9BwaqGQR5bsSRjcLjM/g0x6cfa71M/o+v10APGbdq2ShOxzmV1t/2LlA2c+0rjG4U+ZixpvSQuAwQf3/TNmLh7yMI2XXtmD62/ap0ZjtGDDCKK2bnJqibWB5PetknYyUNKE0EMUuUDSXtiDs2RhJ2dZKt+vCWfJIcq2W1sRiHj/GH5ifCAfUcQehAMffq8nYi6VqWJ4mC6l9bqVPZ637ujtrV6ackUUzvapdEpqB7JIYcjQ1oHI5bs6Tp4KRF9nkRYiE9elyRPImr5hQvqIW5rQj8IvjIWaqefecCGjEzMqgoOR1uMbkN1j9pT3wxiZEAztNofo/OmsLI2esiq1Rx9l/iyd9TJC9IZFIkDsy33bCa8f7Jso4qfao4iROMb/7wF1vm28AWkXbUykSHGNlL58jDL6eMZy
 xAVfJMts
 pLKMhBoxvAbemM2yycSWG/iolNBtNtUfILUEZKGalBSqleZJQfl6d6oBddmxycnSdTGCwidRu6ekWrjTd/xGs/MnpFOFrZzeifoHGEGgXw04svQ7S8xMSeJ07Z9aIk+XSgLuB0P1O+d7Jeh8idP7JE95s94SRZ5zhDSAT5GZFijYHx6ocE3FkXlgw/0CLCH0tcenQyVKt2MJbhBaRH29jezPuzuef6JuL8bxLbJb72jzY8FVXwKxK3xuJJlaX71fR9uPfYBQn/I6Vh+gFAS7nNAGTzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 10:19:33AM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 17:49, Mike Rapoport wrote:
> > On Wed, Sep 23, 2026 at 12:31:26PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
> >>> The pages protected by KFENCE are removed from the direct map.
> >>>
> >>> safe_copy_page() temporarily maps and unmaps them using set_direct_map
> >>> APIs, or, when the stars align, even using debug_pagealloc_map_pages().
> >>>
> >>> Neither of these APIs cares whether it is a KFENCE page and both blindly
> >>> perform the update of the kernel page table for any non-present page.
> >>
> >> Agreed, we should route this through the actual mechanism that modified the
> >> directmap in the first place.
> >>
> >>>
> >>> Ability to use debug_pagealloc_map_pages() to remap KFENCE pages when both
> >>> KFENCE and debug_pagealloc are enabled is an amusing coincidence.
> >>>
> >>> But with increasing appetite for using set_direct_map for hardening
> >>> purposes, it becomes too big of a hammer to enable saving any non-present
> >>> page in the hibernation image.
> >>>
> >>> Another gotcha is that loongarch that does not have a direct map at all
> >>> advertises ARCH_HAS_SET_DIRECT_MAP to allow coexistence of KFENCE and
> >>> hibernation.
> >>>
> >>> Extend KFENCE with a bitmap that tracks which pages are protected and
> >>> provide kfence_force_mapping() and kfence_restore_mapping() APIs that allow
> >>> forced mapping and unmapping of KFENCE pages.
> >>>
> >>> Use these APIs in hibernate_{map,unmap}_pages() for KFENCE pages.
> >>>
> >>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >>> ---
> >>>  include/linux/kfence.h  | 29 +++++++++++++++++++++++++++
> >>>  kernel/power/snapshot.c |  7 +++++++
> >>>  mm/kfence/core.c        | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
> >>>  3 files changed, 86 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> >>> index e5822f6e7f279..33a126cb6d1b7 100644
> >>> --- a/include/linux/kfence.h
> >>> +++ b/include/linux/kfence.h
> >>> @@ -222,6 +222,32 @@ struct kmem_obj_info;
> >>>  bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
> >>>  #endif
> >>>  
> >>> +/**
> >>> + * kfence_force_mapping() - make sure a KFENCE page is mapped
> >>> + * @page: page to map
> >>> + *
> >>> + * Check whether @page is protected and map it if needed.
> >>> + *
> >>> + * Requires: is_kfence_address(page_address(page))
> >>> + *
> >>> + * Return:
> >>> + * * false - failed to map @page
> >>> + * * true - @page is mapped
> >>> + */
> >>> +bool kfence_force_mapping(struct page *page);
> >>> +
> >>> +/**
> >>> + * kfence_restore_mapping() - restore mapping of a KFENCE page
> >>
> >>
> >> The name is misleading. You are actually restoring that the page is
> >> unmapped/protected?
> >>
> >> 	kfence_force_mapping vs. kfence_restore_mapping
> >>
> >> is confusing.
> >>
> >> Can we find a better pair of function names that describe what is actually
> >> happening?
> >>
> >> Maybe something along the lines of
> >>
> >> 	kfence_prepare_copy_page
> >>
> >> 	kfence_finish_copy_page
> >>
> >> That rather expresses what the caller intends to do.
> > 
> > Naming is hard :-D
> > 
> > I feel that _copy_page() is to vague and adding hibernation there is to
> > mouthful :(
> 
> Yeah, I wouldn't mention hibernation.
> 
> 
> 
> > 
> > And these could be used outside of safe_copy_page() someday.
> > 
> > How about 
> > 
> > kfence_set_page_present()
> > kfence_set_page_default()
> 
> 
> Maybe spell out "direct_map" ?
> 
> kfence_set_direct_map_present()
> 
> kfence_set_direct_map_default()

They are not necessarily in direct map :)
loongarch does not have direct map, but still supports kfence
 
> But yeah, something along those lines is better.
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

