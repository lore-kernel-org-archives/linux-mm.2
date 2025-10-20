Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF398CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1598E002A; Mon, 20 Oct 2025 10:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362868E0002; Mon, 20 Oct 2025 10:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277C18E002A; Mon, 20 Oct 2025 10:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 112658E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:21:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B20748508A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:21:04 +0000 (UTC)
X-FDA: 84018704448.08.0CF8FD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id F30608000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:21:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J33kZ7Up;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760970063; a=rsa-sha256;
	cv=none;
	b=v+fA8SV42wLB9X6bB3cZqMPnYhJ88WiJGqKG3ROf6s2h1GDEuIf7+/8LGpyth5j6aCZnv/
	eYPKdYrJJkZ+e5X/ewBZ248iKKiIjjsa176ZAGpN/OyjDToh9CokBomnyfKWpDCor+57+1
	9BZr9eK7ONWUbhevOgYD99fhJKdXGho=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J33kZ7Up;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Ood1pgSd60hbkJmwFViyKQCTha8aHKgGXnIb0wfkAY=;
	b=3JYJ/2rVAPKWYQz7+qQ+yA+BM7q7fxUSeM+XzbSC57161MxwL8gowA3gncHqOCQmHMh5ZV
	vFU0SZf8SOi8EVx/Q/S5ov164gmbDS2zQzSDMxU8F+NLv1IvOYROvlsCw1NY/d4t4vLS7m
	Te/6sa8pMtmxfdt5MYNgdYEqGzZdbj4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA4D044C18;
	Mon, 20 Oct 2025 14:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C3DC4CEF9;
	Mon, 20 Oct 2025 14:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760970061;
	bh=MWtJ+mpol8+yVnzZuaWPr0ilzSGNIoshaV8ATYd24wQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J33kZ7UpK1kYx53YvkuMnchUUU2VJ+k/E9KevIEcuOA4bxT6fp2jPJtrhZecGPERn
	 FJKvDzUWqM1vuz3JX47N9ZRM1e97PQ/zem/dxC5PD+sERJjdVbXigkWYjzEb8IltGl
	 9cXi0UtO9dC0tpVF3yaFhX1y1ojvaBfb1JmdTyphLkkplys7hwy8D2JXqKPpaixn1t
	 5IN6lo+TbDiTVVmsEQMY++GO9lUfM7nEKW0NHpyPola5hSVPUtU2Tz5TFOEsSwj6g5
	 ZUicraVH06nuF0Wy5uVOpucM0rJ5cRaHHT2ZRQAYjXUX2Rbj6t4DJV1sWOjGTjXWNk
	 MWaCY6a8Y6QCg==
Date: Mon, 20 Oct 2025 17:20:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
Message-ID: <aPZFRJVEhSFlPDuE@kernel.org>
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
 <aPT0zNMZqt89cIXH@kernel.org>
 <3301af1f-c24a-4e43-ad59-402e244d5552@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3301af1f-c24a-4e43-ad59-402e244d5552@suse.cz>
X-Stat-Signature: dm6beft7inzy8i8dyf6bpdap158hb74f
X-Rspamd-Queue-Id: F30608000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760970062-418245
X-HE-Meta: U2FsdGVkX190wjoPfh0Pi4gz2NW6s44mW4PO3Wzr6Rb6sIgc/wDK47hocK9UnwkH5ZB68fw/JZXyLI4uvaJczce+5qHIGiFFyYvZ14RPlUdceFAchklbSQPwpS/FUOwx3jToZ1vEvh2zMorNIAEgm36Dydu8KeGFAf6LaNsuWsb18UG4Q0t8QUKaBT+6C6Dn9Hn2VNPBtp6+h5oi5LtgUYNCEXG3kK6ONEINtPOHXXe1nPbXXTQUqS2c0mV54FRfMqVxhNYgn8ExKORdhZnxqF36fBXhBMeIfrudSdVAKp/ys/p2d3FXscXD1BPy+9eZLEnn561v3lyvcnrANZAK9a8Qld5Qq89segUPDyDRCc1wMXYiAfUcryueT+slinZzfpPDjrMMEVILHHrAfec87TNU3B/8HwtnA1FHh04de6dT3QzZ7mZPEBgO9DVau7JtM/FPLKGpr0bnzR21leldbzrVSr7lOQ/AzPV+uzeHM+tcdF2kDgRi9C/4GIIwneHkcv+4FbqRjZSIlMG8/b4n65TnY/0tIMvrvIEEvF6v0iEahhCYHqCiEJABcIokZrPHeMTaQue4XCIetSgrzT4xq6IeOn5P/VPfxvg3CebdKQUUhWUuDT3bi3uHqTBCYP1WAdgykmQnNottP9/Qv+DzWvcw4OHRreKt++y8M7rXinS9NSI8rG/T6WOUhp1YDAa2COlyccDmda567FbgeAF4uimOZZ67wrawrG7uwCU9Fq2A0LSe/6TlpOo0U+z346EBmtI+UAUUlduMDCAdXvVt5M4Top9nSScqteEh0AF9i1yxPO6XiFaQECRxFw5aHWD8a+BKFZefjIcCa0+AkajobCdTSKHUAoRK67Q0RHkRFfaqGjM3hgc3xjmgFaOXFNpws2flLp5+aRen0aa29GMbQUmkV+GQysjf2yZtp6UYbskzBJ77cevaCKjh7NgmmABwmEhfBiPtD6/esilJsPB
 9ADf3rR/
 uc0x3VizYH+4TkMnTxJiIwsMvvkIvaACOdlKIE/jWKVsNLWfrs6MXy+OfXCq2RVJeVmuyyo7VvzFoJbyvK479icWzPVR30g7QU1mgJujjtYePxEQhHpHsevt+95dIIJvuQ8uDsMaYztPfhBaOWl6BcMUgGKoepht2muMK/CT/l1vLN222I5u/S/b3Of8HX+8uV0qly5MTzBoJqXZdiTv41SqE+QpM2xo2xK1nE15nH3sV0UtKZ+O3sSihxHPImAzT3lu/prOhys61XxL13As2pIRNwKa8sWQgXP3LvcJ9Js3dj26+nUG10lpAFsm9XYqjWedkB3vouQCRi85YjF4acugtEkWjxVOgnoE5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 10:54:27AM +0200, Vlastimil Babka wrote:
> On 10/19/25 16:25, Mike Rapoport wrote:
> > On Sun, Oct 19, 2025 at 01:30:47AM +0100, Matthew Wilcox wrote:
> >> On Sat, Oct 18, 2025 at 12:29:59PM +0300, Mike Rapoport wrote:
> >> > Vast majority of allocations that use get_free_pages() and its derivatives
> >> > cast the returned unsigned long to a pointer and then cast it back to
> >> > unsigned long when freeing the memory.
> >> > 
> >> > These castings are useless and only obfuscate the code.
> >> > 
> >> > Make get_free_pages() and friends return 'void *' and free_pages() accept
> >> > 'void *' as its address parameter.
> >> 
> >> No.  Linus has rejected this change before.  I can't find it now, it was
> >> a long time ago. 
> 
> Here's a lore link
> https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 
> > If it was a long time ago, he might not object it now.
> 
> Did the circumstances change in a positive way? Using a semantic patch might
> make it less painfull to apply in a flag day manner, although depends on how
> much is that "a bit of manual tweaking" you mention.

Semantic patch missed a handful of places, other than that tweaking was for
formatting, e.g

diff --git spatch/arch/s390/mm/cmm.c manual/arch/s390/mm/cmm.c
index 980d2b302937..7212ab4f0eaa 100644
--- spatch/arch/s390/mm/cmm.c
+++ manual/arch/s390/mm/cmm.c
@@ -74,7 +74,8 @@ static long cmm_alloc_pages(long nr, long *counter,
 		if (!pa || pa->index >= CMM_NR_PAGES) {
 			/* Need a new page for the page list. */
 			spin_unlock(&cmm_lock);
-			npa =__get_free_page(GFP_NOIO);
+			npa =
+				__get_free_page(GFP_NOIO);
 			if (!npa) {
 				free_page(addr);
 				break;
 
> >> Most of them shouldn't be using get_free_pages() at all, they should be
> >> using kmalloc().
> 
> Changing to kmalloc() would have to be careful, what if the callers rely on
> doing e.g. get_page() later. It would however be useful to dintinguish "I
> want a page-sized buffer" (note that it's guaranteed to be aligned by
> kmalloc() these days, which it wasn't in 2015) from "I really want a page".
> But many of the latter cases maybe want a struct page then and are using
> alloc_pages()? 

alloc_pages() users also not necessarily want a page, there are quite a few
places where we have 

	struct page *page = alloc_pages();
	some_type *ptr = page_address(page);

So ideally those also should use an API that returns void *. But again, as
converting get_free_pages to kmalloc, it's a case-by-case audit.

> > Don't know if most but some of them could. Still, we'd have a bunch of
> > get_free_pages() users with needless castings.
> > And converting callers that should use kmalloc() is a long and tedious
> > process, while here we get an API improvement in a single automated change.

> Maybe a more feasible way would be to rename to something more coherent,
> while keeping the old interfaces alive for a while for easier backporting.
> because __get_free_pages() / free_pages() is not really great naming.
> If possible it would be nice to also make __GFP_COMP implicit in the new API.

If we shorten "page-sized-buffer" to "p" we can do something like:

void *__palloc(gfp_t flags, unsigned int order);
void *palloc(gfp_t flags);
void *pzalloc(gfp_t flags);
void __pfree(void *ptr, unsigned int order);
void pfree(void *ptr);

I'd keep the order in __whatever_free() for the first step, because I'm not
100% sure we can use __GFP_COMP for every existing caller of
get_free_pages.
 
Do we also want to rename gfp flags to something page-sized-buffer based? :)

-- 
Sincerely yours,
Mike.

