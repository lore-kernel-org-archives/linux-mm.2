Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FA9606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJTL9SJk
Received: by kanga.kvack.org (Postfix)
	id 13B8A6B05B7; Mon, 16 Nov 2026 09:42:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED176B05B8; Mon, 16 Nov 2026 09:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20916B05B9; Mon, 16 Nov 2026 09:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB5AE6B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:41:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A86A1C006D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:41:59 +0000 (UTC)
X-FDA: 85441246758.03.739F913
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CBC4580003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:41:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJTL9SJk;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794840118;
	b=eNAXC8KdodlmXXcybgOSehZQtLcAdz19DS7A3OHCZFS6d9CstxzKjAmOr20MnljlY2E6my
	GfRrwaSiqa5TXivqepd9Ut0dUsN76c6SPjlcaasGLr6bF8gtq3zqVb6LAHfOUz43FhVdeH
	w0BtrrpPk5y+0TXJpKfiNX3vmk4rYXo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJTL9SJk;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794840117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2rB/nwDdGI8ixOlr0EOUE2EFObaBqdL/DrhKi+letk=;
	b=Wa96TfOHA8ZmvpaBW6Bku/ru423Bm9cZZKajra2yZRkEo0ouXLpvV3afunBvyMLgodu15o
	sEKCmtLdkxR0TaaEIZHEwHMYxyafxICgCnwFqaO0RYvoQJi9mRLIp6beO82T2+bCEdaGWo
	lRZOXKtGo5EL4pYAPenX2Skk9gvESjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5767262CC5;
	Mon, 16 Nov 2026 14:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CBD1F000C4;
	Mon, 16 Nov 2026 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840117;
	bh=d2rB/nwDdGI8ixOlr0EOUE2EFObaBqdL/DrhKi+letk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XJTL9SJk+Cy08wdednhz6VQ6SSMcVaNLKQlMBd67ucoGoTl40lG4v55tbaFyENQVL
	 IP5IlAucXgH1SN08irBinexfvsJNx8ulpjPdGehXaNGAUDw3rRgTfy2lQ/blIeTUmv
	 nw7td/3MFFkpqEV9Zq7s6xMTyWiy6BaBDSMs8/I6nZ2Tk/XF5q6BjKpMEeI+6zjRXg
	 2ye3z7v4ATUn2RU9QoMSWaGiJWdNcR8h0jGtKhHwc2OpI0wsMnE3Y7Xk8NeMl7aOqn
	 Uvf/Tt+q/62nl1bK8/w95YiTDDq0AVWsV7PL/SyiS7OOA502VghnC9aqOOgcx4oJUD
	 z8HweZmET6MLw==
Date: Mon, 16 Nov 2026 14:41:45 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/12] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
Message-ID: <avsV68cP0rp5mWSf@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
 <avYG7CtQ52v3I8tF@gremlin>
 <f28dc841-f664-4f97-9dd7-bffd2825115e@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f28dc841-f664-4f97-9dd7-bffd2825115e@columbia.edu>
X-Stat-Signature: mt9z8k5c5gm56gf9dnre17785a4ogp4s
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CBC4580003
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794840117-757310
X-HE-Meta: U2FsdGVkX1+3G9zqz4nHfe47DtLGatDJsU4ndTFCqdRsD+73BLCxyk4XrcwpxJJKCssZRf61aqZspKl4gH3Do3cb04lovGryWhXGLVQ/ZH+0aRT8KlFUACh2Yy4P3hxSf2bFc+oDuHfjQ1XjpB3bWCM/Anmm1bHnRrmBfmkBZmHPkmuvjEEyOVs9pDoRq0HPo+NjBDb8xPztiNKuM+hfShW+lotuY9KuJSo6VT3rsEU/AqcSs+M5W5p/KFzkZhxRjgrhhzuOLdzRBPjmVuwrys13Dc4/BOBp/3GhP+Vra8flVKp5bbGWtMeUBnVbM1Bq8Xw+XmNSvW9pGgsSWglBl3K/7D8KMhA+nC7kriF0IkUBvmCJflMM7whIB15kvRtl1stwbvo0ZUxBmhGJF5wC7gseXel44lKTWL+BG+mrg2ZUmk+Ghbrdqz1KiCXhm4VEHhMAjTkCR+bRnkklwZ6SFxPgqPHODivATu7SI9vGdBXv4roZhnLtRpaeHmrnyqmqKTPCy9A4ZCjiNKpMfD1RmiCHAyXP5+xY1GIIszHkb9BG/FxGphPZAGTpOMFAY8y5ImUq76nXH2kXgmYQHDXe9p/gKyuTX2h4hx8tX9sNrYKr0H29fXcwQLtZ6Y6kOUKdJFm9W0lHqj6/Gw3o28sFTWDoP8PAVGC4TfoKaFwuBnuGyE3SjQs9+P98B440tHVFrJLn00D1IhnG0Iy80RFceNRy6mB+70V8aSDn4ebSQ/N/kfFyP8087J4l5YdCXy+KqKeVPB15j0/ZRWGqz6J3d/10JpY0jpizmTzDgj4QNze7L5NEbUWYMRhyZ8lhS3QCkLibM5EDGd6BktZ22XSUNLa6E+geJnsY98kMq+aMYrUwzdO/X+9r5TiqW9X30xMvjaX5xZ0Kkj7Dx58KiRBmcyHXajliuCVz/1xjtJTWAYoCPYl4bWff/N3oVjxA9hPXWCfzjp85aJgoqQAyna1
 QE7YiZnK
 EjKZJNM0zBfO8EkuPcKM1uFFayuW2f1zxzGJDiMwEb/tmbCAuRY9fmPxPjCv8J6Fl05zqIvscB38pEbjC9K9KrtkH52KGAQfcNCr9T14/CXxA83AxoKK4u1p5tDpxjI13hT6p5iiptqhPIRDhysga1OUAQzPeEpIFbjU/3VdsmSaMaUTE++1jkl7NTrNKdz7h1M2QUo5j1wS/RjasFzorcuZIP609q4loNDZXWOIHfrK0NfVS8XT77V24eM4Y37x1eXwqSZLbqj1nTKdm40Ocle0bN8l1rL42EONPzuJXA3ObOVAvb0dGj6rqDXsxaSg/TcUh7w8QNjzDBigyqFPIM9Z/mvvhwA/F/WSK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 04:59:39PM -0500, Tal Zussman wrote:
> On 11/12/26 1:44 PM, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Nov 11, 2026 at 12:55:12PM -0500, Tal Zussman wrote:
> >> remove_migration_pte() makes the restored PTE writable for a writable
> >> migration entry, and only looks at the uffd bit of the entry otherwise.
> >> A writable migration entry that has the uffd bit set is therefore
> >> restored as a writable PTE without the uffd bit, and the page is no
> >> longer write-protected.
> >
> > The UFFD WP bit is such a terrible, invasive, broken piece
> > of... engineering :)
> >
> > Notice, again, the hallmark of an utterly broken abstraction - every user
> > just has to happen to know to handle each of your weird edge cases every
> > single time they happen to interact with anything that touches it.
> >
> > I do hope we never merge something as bad as this again.
> >
> >>
> >> An entry with the uffd bit set must be restored write-protected, whether
> >> the entry is writable or not. remove_migration_pmd() gets this right: it
> >
> > Sigh :)
> >
> >> makes the PMD writable and sets the uffd bit as two independent steps,
> >> and pmd_mkuffd() write-protects the result. To fix it, do the same at
> >> the PTE level, where pte_mkuffd() write-protects the PTE as well.
> >>
> >> The only known path that created such entries is PAGEMAP_SCAN. Now that
> >
> > Wait what? :)
> >
> > How does a read-only scan of entries create softleaf entries?
> >
> > I think this should be explained in the commit message :)
> >
>
> Will add a sentence... unfortunately not a read-only scan...

Thanks! Yeah I realised later the true horrors of what PAGEMAP_SCAN can do
with uffd flags (ugh).

>
> >> PAGEMAP_SCAN downgrades them like change_protection() does, we should no
> >> longer see them, so this change alone should not be visible to
> >> userspace. If another path ever creates a writable migration entry with
> >> the uffd bit set, the page now stays write-protected instead of losing
> >> the uffd bit.
> >>
> >> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> >
> > This seems like a super-weird fixes target.
> >
>
> So this piece of code was added in f45ec5ff16a7, but the issue derives
> from PAGEMAP_SCAN, which is the commit above. I think 52526ca7fdb9 is
> the right target, but can change it.
>
> > BTW I've noticed you've not been cc'ing stable, is that on purpose? No
> > autosel in mm so we do need to do that on stuff intended to get backported.
> > :)
> >
>
> I added stable for patches 1 and 2, but for this one and the previous patch
> the impact is PAGEMAP_SCAN reporting a page as written when it wasn't, which
> over-reports but doesn't lose anything, so I left it off. Maybe I'm being
> too conservative though.

No that's fine, if it's sensible not to then let's not.

Was just checking to make sure it was intentional ;)

>
> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >
> > The change itself seems reasonable, as cursed as the reason for it is, so
> > with the fixes target confirmed + commit message updated:
> >
> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> >> ---
> >>  mm/migrate.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/migrate.c b/mm/migrate.c
> >> index 28a8d7734735..d200f64b5f98 100644
> >> --- a/mm/migrate.c
> >> +++ b/mm/migrate.c
> >> @@ -399,7 +399,7 @@ static bool remove_migration_pte(struct folio *folio,
> >>
> >>  		if (softleaf_is_migration_write(entry))
> >>  			pte = pte_mkwrite(pte, vma);
> >> -		else if (pte_swp_uffd(old_pte))
> >> +		if (pte_swp_uffd(old_pte))
> >>  			pte = pte_mkuffd(pte);
> >>
> >>  		/* See do_swap_page(): restore PAGE_NONE for RWP */
> >>
> >> --
> >> 2.39.5
> >>
> >
> > --
> > Cheers, Lorenzo
> >
>

--
Cheers, Lorenzo

