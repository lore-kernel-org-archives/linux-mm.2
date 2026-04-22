Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEC3FA1FFA
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 21:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15AD06B008A; Wed, 22 Apr 2026 17:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1325A6B008C; Wed, 22 Apr 2026 17:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021096B0092; Wed, 22 Apr 2026 17:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E90A76B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 17:20:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7D598B344
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:20:51 +0000 (UTC)
X-FDA: 84687461502.05.46BFE33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67300A000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:20:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPoEnCJH;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776892849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AuBD0WIXDzq4C1LKbO1zkVvixca9JBQuddXhofRNlk=;
	b=kizZ5bd1rMRimOSladu7udlN6DSdht1W2dcYixt7E3nVNqA9rM1VdvdzaIMp+QSocR23L+
	9nxdv7kq6dcKEd0htBQrn8zU0Nh04rfE7zZisXgXaBoK50jQPnN3VfSBw3E2yOPV95nDoA
	FK+GHJDWR+Xc0XaBiM03Rpox/Gb0O6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776892849; a=rsa-sha256;
	cv=none;
	b=HSxg0vsqPltUlWBNMqcuaq2Pd7jXwpSkwLeEY5/9pjI3ExIBh2RZioXnJ/WruT8qeCcfZN
	Qs+NdswFZ+EbPr5mPgKB8zgDA0s+cHWKGtJH1BLbujjQd5vSGz4Bgi42KlM/N4pRDHomHJ
	suOzlTRyg/oXvlVdIdf3CpIA3O4n9V8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPoEnCJH;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776892848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0AuBD0WIXDzq4C1LKbO1zkVvixca9JBQuddXhofRNlk=;
	b=hPoEnCJHIeYulyJrfd5Nhj1sopnC0AI+WLv6Wk3s6psKAa8PJ1YpsqpQ6AVGGu0ceogVTG
	Txc5fADmoH9GzpQZZxTlcRJKpmVlojDYbdl03KGgndsvUy3T0nFPH7oHjAIaZd+Xkidm7c
	QLG4336WuHNljAhcUzQEl0F1LL0NSLk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-wxaS9kLiMIuw5xHdkQUIlA-1; Wed, 22 Apr 2026 17:20:35 -0400
X-MC-Unique: wxaS9kLiMIuw5xHdkQUIlA-1
X-Mimecast-MFC-AGG-ID: wxaS9kLiMIuw5xHdkQUIlA_1776892834
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488c0fcc6deso34769535e9.2
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776892834; x=1777497634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0AuBD0WIXDzq4C1LKbO1zkVvixca9JBQuddXhofRNlk=;
        b=qmgg0dvoEggd8H8o3mXDGDr3YO1uMk9eDvdoDG2pWbLHulngcNBR2AuP7N5CuZIk05
         vVlqDkpdNnbQveDBejyRxOjW0UkiOgMY63SqpT8k9DIW+x8SR8rHqeLbH7kXXQwQ/T0Z
         ILLZgyG6/Y9B7nGktJObG9IP9hdo9rklArxItlQJKtGw3jJmAbjaitFGRS58M9A/pCzc
         8agCTHvpFeiKNELuqMY32P/zJQaYqKSqiz4ieY29S2Dj0zf0TjbifVw8jFfaLrZ+zQdm
         GkwH4aQFOFk/7QBui9TWnws/vOYsMHHfJXErfq3DPAmXRlcJxHGECXGRSau8qI0OCiKQ
         ExoQ==
X-Forwarded-Encrypted: i=1; AFNElJ/8ji+0Lwz12Pm7TjIBhLz3UWyOXFPskF5MzpJE5vfvTnkSzaahvSB9Glk4g4HHQOnxWjW6lyIJrQ==@kvack.org
X-Gm-Message-State: AOJu0YwQVzxwCV1pVUhdMc5Y2QmYh/AYhdf6qQ32u126mYLquebzV1aQ
	VpTSh7v+aBcLe8Z0Ds50k8ON+t8SrXpEu4WROq+OMJTqwfYJJ1xunGzQFsBEiRxGN1u9Zu2MLoS
	bE7h25FdmBIkamxssrB4XpaIFD+xQw0rTom6Ae0/TxaWZoDW4YJ0L
X-Gm-Gg: AeBDiestyWmmQm7JdR1pEIyLzF11fPU53IoInVDHiCz2vEWCSCVYDYNjuGp6PQBxnWB
	o2lg0v77VOtF2bvQsNw+Bg8vaRZBmCaOJbSfIJ5vYLGCITPXGFEQCUpzxFmOhvBj082W1vh+Vcs
	k7R1AeYhrGilQWOPZWdaG9iCqGokCj61DqBxtFAdw9Om/0NVtSTcuX2tAgDEhBIM5VuCMt7Hufh
	078uThykCV5mix0wdBj8Qa8Evaaw4oXollHLgTmTTAsPfA39VTM7a1qjEU5d4nyI2Wf+qx94XL3
	XEUzigI4YfP1aF6frC7wVJ+YKRC2FkW10zKzQwyxh7bZB+RmTyrCyFglaJnIgmpwiVi5lxpj1WI
	Qx+EP6cUVoeXrSUOOxVS1p0JH63OPUzXLXy3tqvsN+MLuG16XBpbE3A==
X-Received: by 2002:a05:600c:8115:b0:488:ac01:72b6 with SMTP id 5b1f17b1804b1-488fb77d7d3mr296536195e9.21.1776892834254;
        Wed, 22 Apr 2026 14:20:34 -0700 (PDT)
X-Received: by 2002:a05:600c:8115:b0:488:ac01:72b6 with SMTP id 5b1f17b1804b1-488fb77d7d3mr296535725e9.21.1776892833712;
        Wed, 22 Apr 2026 14:20:33 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc10777csm537060875e9.8.2026.04.22.14.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 14:20:33 -0700 (PDT)
Date: Wed, 22 Apr 2026 17:20:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260422171315-mutt-send-email-mst@kernel.org>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pk1yOYEhTL8bcc4ob8GBeKdepkqEv1THLZkQ1KoFGJo_1776892834
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 67300A000D
X-Rspamd-Server: rspam07
X-Stat-Signature: pepms1jpabq4swrpr9mtzsnp436hoctu
X-Rspam-User: 
X-HE-Tag: 1776892849-63849
X-HE-Meta: U2FsdGVkX1/Bg6dGm0CBInku2VeY85BEoSO/UcyEQYljRc8M7HYUwTLmtu3X/bAUmbH1aB34CORVYPqTy17zjnF4wzgj+hfiDJ8B0Is7X/oatNCWMieaZl2KU2q8qDYB+gKylz+QyGw8Cpd/VkhBQMBW0H/SWGv87TbgUiB5uIWJgmM2KyEDW6anp/dYqyvAR9KkbipULJLU7ZNiUPBBOVZtxwDIoR3MTi3NvcWhuRskRGIrBwjEMi+Lq93uPr9MdIDtDZIvhbFnCLYLIq9y4HbabShfcYpC1KGuNJvJolIOP7cCMFyFsSKyHxD7VDA9PoyFPwDAO87+ZBCfmvHQ6GqQ5YSaB8+Kx2pp19WKXlLTPUNOIp1ZOoT+gNsg8LaJvw+sH4r8j68pXWs1vXyGwGZSui51ul0cA6BSQahLzVNE3N3J7JyNDeyj3OChLDKdalORqc9I7yEAgk4NtLK51AfiHqsPv5x2iUe3sfaEeD5Bg92eoVC7TN02dluFOJClhEDJY8itc7jfoqFdQriydbmurrQql0buxrgz4h6/A55rkaHWwzgdmdhaFGF3Osh4DGoXl+WK6CG0OVCZhSZhfKajAdyU21GozEOfl9qcJJdh/mKK2i2sdwNMKgJuaexlXPC1lmKGMBIW6s6i2JDrzV+1F7IF14r3vJs8BiYtasTR1ma0tTMdHOYqwgdXkxgGOqVJoRj1p03hh/NKkwCf8QL+hSLCMIQlUxD0ByCJbVR8ESucFD/pG+LatUrz5fzugoyR2t1ib1DwbzWeeCx+1bQWOXf5I6AfSWPQySfYynqi/zlw7GFDWU3oVgTLPE64JnLposzV+1iHyo6sFduk5xPQz62gg4ZGNtNTnTEpQ+QTJ4DHUMcfutlGdBlumk5Uhchezkb4f9oj0kScmhlMGFIEEm8VdeSRhsIZnO729PRPfXjoGU4X9TGDcm1xq00t/bbVWbu2b79xz81ezAf
 dim/KGKG
 S5bIhusa+A0Aa7NcYzp7rKgh+YLoFOGcb6VL+K1WChfEC0Amq6vgzVKsq/l79tMqmInsZE3G6sLxMzcWa3AtHUkyuEkSLIaP27t/VzgnhhyyftrDk7OO8XeWuCK11j3RB4veBYteo/uGXrfNdycruTzpALyegSaDVM9/dE9pA9ONmJlaXiP02w3ALpf+f+av5z4/fvCtpcUlfl44uAbm0hv5Fv3a9y58gMmUNxfY99iqPs7OpSxun7Rp0wlvB5I5wJqt0C5YAhqju6ImPRS73Vi4mFwKS9Y/U+c9tcW1ffZ9F3MiKjqnRMScrX4sZHj4b23KP9gIFkZg8DiIu1DBV5DVRHMK1WzABb5Qy/Pwc3WeXzR5h4Ng4Ty1mIj+NiR+vlPnfoDO+IxLnoP4cSgyTwkgOztzbGnm1Yv3K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 03:47:07PM -0400, Gregory Price wrote:
> On Tue, Apr 21, 2026 at 06:01:10PM -0400, Michael S. Tsirkin wrote:
> > Thread a user virtual address from vma_alloc_folio() down through
> > the page allocator to post_alloc_hook().  This is plumbing preparation
> > for a subsequent patch that will use user_addr to call folio_zero_user()
> > for cache-friendly zeroing of user pages.
> > 
> > The user_addr is stored in struct alloc_context and flows through:
> >   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
> >   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
> >   post_alloc_hook
> > 
> > Public APIs (__alloc_pages, __folio_alloc, folio_alloc_mpol) gain a
> > user_addr parameter directly.  Callers that do not need user_addr
> > pass USER_ADDR_NONE ((unsigned long)-1), since
> > address 0 is a valid user mapping.
> > 
> 
> Question: rather than churning the entirety of the existing interfaces,
> is there a possibility of adding an explicit interface for this
> interaction that amounts to:
> 
> __alloc_user_pages(..., gfp_t gfp, user_addr)
> {
>     BUG_ON(!(gfp & __GFP_ZERO));
> 
>     /* post_alloc_hook implements the already-zeroed skip */
>     page = alloc_page(..., gfp, ...); /* existing interface */
> 
>     /* Do the cacheline stuff here instead of in the core */
>     cacheline_nonsense(page, user_addr);
> 
>     return page; /* user doesn't need to do explicit zeroing */
> }
> 
> Then rather than leaking information out of the buddy, we just need to
> get the zeroed information *into* the buddy.
> 
> the users that want zeroing but need the explicit user_addr step just
> defer the zeroing to outside post_alloc_hook().
> 
> That's just my immediate gut reaction to all this churn on the existing
> interfaces.
> 
> Existing users can continue using the buddy as-is, and enlightened users
> can optimize for this specific kind of __GFP_ZERO interaction.
> 
> ~Gregory


Hmm. Maybe I misunderstand what you propose, but this seems pretty close
to what v2 did - each callsite checked whether the page was pre-zeroed
and called folio_zero_user() itself.  The feedback (both you and David)
was that threading it through the allocator is better.

With a wrapper approach, looks like we'd need something like
__GFP_SKIP_ZERO so post_alloc_hook doesn't zero sequentially, then the
wrapper re-zeros with folio_zero_user().  But then the wrapper needs to
know whether the page was pre-zeroed (PG_zeroed), which is cleared by
post_alloc_hook before return.  So the information doesn't survive to
the wrapper.

We could return the zeroed hint via an output parameter, but that's
what v2's pghint_t was, and it was disliked.

The user_addr threading through the allocator does add API churn,
but it's all mechanical (adding one parameter, callers pass
USER_ADDR_NONE), any mistaked are just build errors.

And it makes the zeroing path closer to being correct by
construction: every allocation either explicitly
says no address or has a user_addr - and then gets
cache-friendly zeroing or skip-if-prezeroed, with no possibility
of a callsite forgetting to handle it.

Fundamentally, David told me I need to move folio_zero_user into
post_alloc_hook as a prerequisite to the optimization, so I did that -
let's stick to it then, shall we?


This approach also fixes a pre-existing double-zeroing on architectures with
aliasing data caches + init_on_alloc, where current code zeros once
via kernel_init_pages() then again via clear_user_highpage() at
the callsite. I don't see how that would be possible with the wrapper.

-- 
MST


