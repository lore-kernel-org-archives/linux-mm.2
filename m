Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69492606A8AC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xd6pqgjh
Received: by kanga.kvack.org (Postfix)
	id 81BF76B05CA; Thu, 12 Nov 2026 07:23:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3BE6B05CB; Thu, 12 Nov 2026 07:23:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FD36B05CC; Thu, 12 Nov 2026 07:23:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D19A6B05CA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:23:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E0D6A0596
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:23:09 +0000 (UTC)
X-FDA: 85426381698.16.CA6D0A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE81780002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:23:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xd6pqgjh;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWlw4c7qfDg3OW28iHlk8qt/mvenvwkeKIlZQ1FC3mw=;
	b=1RDGsja3ME2sKhHbloOB9Al4H1IhScfHJv/O1WId4bQdLMTWGfPx6XKnWaG7ZoFjKp5mog
	BuXVbnVi1r85UQhyr5hpCmNFan5MEmxapMx6KnNz8vk2xX+tdgVC8XiycRizMXLe01vSw/
	oMq3In6eM6ttUx+yOvM2oMJW7+vf+Fk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486187;
	b=5htYItVaaYeWSZme3P9h8kaDamedQmW6VXetAWpU65GtEcC5jNq644DLntCSLrsh/HPkUD
	aSXefHzVCCYXGvZ6bMYw2+CMKO82YZY4VIqYxU15gfCAYJFACcfy8jNNH9Q4scu0qQZlts
	dxB8mHObu7oLsbboJ2xzHHujS5ysHQs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xd6pqgjh;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A9BE60DF5;
	Thu, 12 Nov 2026 12:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997111F00A05;
	Thu, 12 Nov 2026 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794486185;
	bh=lWlw4c7qfDg3OW28iHlk8qt/mvenvwkeKIlZQ1FC3mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xd6pqgjhgMlhQ6hVKaJF/N4Xr+guaVNesjZMxo7k+RkYUnsVMo6cJ6/c0pqj++MDS
	 pVvLZn6pkeYtDjLQKco9aekFMAmLwm20qtCrLZ9kC/eRWl+eYHt1zRS7k3/RIXJ8kW
	 2AhCyeove+V3rQfwaTpi6OusY4wQ0uEm2t0GBfn5AnKyK6V3npnOBQt51dmbXUr3Iy
	 mtOwE1wCrPpQmzQbToI82zpMgHTTEOc61a7IXFohHd6biYeQQa5PXzx2W95jcw+b00
	 XU2cuBNNUi6df+ytz5N024IKdrObe2Ad0NsLLpypl+ozGtsFGvlk/9Q3jx7s+ozcbD
	 N6OzO+ESTJbQw==
Date: Thu, 12 Nov 2026 12:22:54 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 03/13] mm: cachestat: restart the walk after each entry
Message-ID: <avWuxs25RmC6PvVZ@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
 <9b795d3a-1818-4265-a364-58fba139c651@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b795d3a-1818-4265-a364-58fba139c651@linux.dev>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qd4gpekqsro9heokyurq4zgkarjkunak
X-Rspamd-Queue-Id: AE81780002
X-Rspam-User: 
X-HE-Tag: 1794486187-858807
X-HE-Meta: U2FsdGVkX1+dt6na0fHj+CAnJLvGyV1+F1cKpK5kJyUkQqDXiP1XtdzrnFSvzz5j1lMo2FSdEGuTbV7Gt+Sq5iZuYhtRbndRR1pB1QNhWa2lOJ1/lSzp41QxuCH7p0XsFv+B63tTteTWMrZ5ccTvgQ5KoyvFwTW/H5+zUwn4ZdJnr/X+x63TbhZIjwnBxrfPHMUKAS2nGQo+GMNfiK/o25R7jHmh9xlazuUl7G9Jo0t+TOJlhso8zQxnRFpm1oNYdPI2Pve7iybFzkYs+X/K378+SRjhRswuSRWYexKsE6CfB99fK2bSyc+tZX2NiCzGLxF9wQdx+jyuupuqTMBtCw4UKwBTVzhPcTF7H+I7Lm0kee1HfpFDrRlubhj9250sI2vHVmu+8n9kCzyOOjzsI4Jo70Qr5ehqzhrqhCjVV6C2iaV2I1/eFcRS34GXGHvZ7olAJ1/AtN4pVKImSOJJaqpB5z0Maskxe0ZvufYesS21u61gZN87R4aD4kQEzRVtM8vESMVbg+7S7DyXhW4mxQocUuc0JaWCqAraH4A/Yef8LoHL6Hva2du2kfPeZQKntE40xWEoD4Uk3S8DaatURjb6YoA/XNBmfNQ8cr21lf0jtl0FuIrGUwJ8fcWbo5FeFLYPczdCZVhz3P1g3JEqx6alLNlMKcRD3uI8/nBs6W1+Ni40/9UO+N3FvHMIkAjbIQZWduoV0oYKTQ4mjWx5uIP7snJihrT+49sIAb1bUvd+Uc/cFgNwLtzsnGM/nScYCld9kGJ5RHTuVCzSiih5WGyE9DrW1d+l6gDclD/8JHfcnIKNesX9zSTCNUrbgbUW5mcTZdv+PuMIryjOVnHmoHI9DZIfUVMjP3l2lgZhhs3X4uvn999Shsrd+/dhrau0u8Pl5YU4ZTOvc55jwKknxCnJV7XtYQIXHx1m4xaQZGHePbKk9e+SjrKBWpuGKtqozNF4NOC6wIvT/IOD9/2
 ujgVQ9vS
 ro49tlwE+2IcRMWlG+Yl0q1a+rlSryipGqQXROn8KkpZh9OH9BY5KIUfemQ4J6deY4yrdV4qBkfk6/nbUjnXmTTUxKmMkBs41xbmL/03XwRTOhX21no2hU7jWpAAdytX/Dwa8bflqmWooqtzZlREPrFseznYnOc8UqslWhuG71o0R9ML0q+cbAksztrFs+HMN/u5Irp0c30zlsfBQjj5PWZdlMjyuc7i4/Tsu8ZyFT6HhQvtfX6MCffIVl5FLtSUzZxO2PEg8K4D/99IrDvwqKtYan/OSI2EPxFWGe1sWgISZn0ccvYBhiI/FrvAHfuvM5ioI52PkZlnOt4c1kaJdSADBxatQ0QrbtQEd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:38:39PM +0000, Usama Arif wrote:
>
>
> On 11/11/2026 18:13, Lorenzo Stoakes (ARM) wrote:
> > From: Chris Mason <mason@kernel.org>
> >
> > cachestat() can leave cached pages out of its counts. This happens if
> > the entry that the call has just counted is replaced by a larger folio
> > that starts in the same XArray slot.
> >
> > The issue is that filemap_cachestat() walks the page cache under the RCU
> > read lock, so racing concurrent collapse/split is possible.
> >
> > Thus, an entry can be replaced immediately after the walk has returned
> > it. When that happens, the next xas_find() skips the sibling entries that
> > point to the slot of that entry, since ordinarily they belong to that
> > entry.
> >
> > However a concurrent collapse_file() or __filemap_add_folio() (when
> > replacing a shadow entry) can store a larger folio in the slot, in which
> > case the sibling entries belong to the new folio and the walk still skips
> > them.
> >
> > Consider:
> >
> >     cachestat                         collapse
> >     =========                         ========
> >     count a 64-page folio in slot 8
> >                                       store a 512-page folio in slot 8,
> >                                       with sibling entries in slots 9-15
> >     xas_find() starts at slot 8
> >     and skips slots 9-15
> >       /* 448 pages are never counted */
> >
> > Also consider:
> >
> >     filemap_cachestat()                  __filemap_add_folio()
> >     ===================                  =====================
> >     counts the shadow entry in slot 0
> >                                          slot 0: a folio of 32 pages
> >                                          slots 1-31: siblings of slot 0
> >     xas_find() skips slots 1-31
> >       /* 31 pages are never counted */
> >
> > Essentially the fact that large folios might be present means we cannot
> > safely continue the XArray walk, and must reset the iterator each time.
> >
> > Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> > Signed-off-by: Chris Mason <mason@kernel.org>
> > [ ljs: squashed 2 commits, fixed up comment in code, and commit message ]
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Oops I didn't even include a 'fix this by' even...

David/Andrew - as per Usama, could you add this to the end of the commit msg:

	Fix this by resetting the walk in each loop. This incurs a performance
	penalty, but given that only the RCU lock is held here, it can't be
	avoided.

> > ---
> >  mm/filemap.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 7c05e4fad081..c4e82891767b 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -4731,10 +4731,11 @@ static void filemap_cachestat(struct address_space *mapping,
> >  		if (folio_last_index >= last_index)
> >  			break;
> >
> > -		if (need_resched()) {
> > -			xas_set(&xas, curr_index);
> > +		/* Collapse or new folio spanning shadow entries needs reset. */
> > +		xas_set(&xas, curr_index);
> > +
>
> I imagine this will be a performance hit for the call, as each entry now
> needs a traversal from the xarray root. Might be good to callout in commit
> message. But is the right thing to do.

Yeah good point and I did try to find a way not to do that. But it's apparently
(says AI overlords) less bad than an xa_for_each() implementation :P

> Acked-by: Usama Arif <usama.arif@linux.dev>

Thanks!

--
Cheers, Lorenzo

