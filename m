Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02CA2C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BACC6B0093; Thu, 24 Sep 2026 11:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C2E6B0095; Thu, 24 Sep 2026 11:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C6C6B0096; Thu, 24 Sep 2026 11:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C84956B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:23:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F1B3403A9
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:23:00 +0000 (UTC)
X-FDA: 85249023720.29.378EB2B
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf27.hostedemail.com (Postfix) with ESMTP id 478D240011
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:22:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="r HiW/DH";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ldzREHgy;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790263378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9829kPweuklhix3Z1AJfyPME8Dj1E3vcoJGw3M8wqk=;
	b=VaJJFg2B3HBl4qm1ig2qdVGfQD5FMcajkI26mRHgHxMhUuo36P+Dr7nuSmIdd5N0uqdSaB
	WSilnLrHw2R+acLhoqcnMpX+PUINvA1TNsvpBkNNGMXsyi9IJSkXb4IPaWDlsz5k80lxdP
	d5r6Cs2i+jrxdGavHy4wU9AiGjwFOls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790263378;
	b=r+aKKw+9afS9rjQYoWcehPg9qt84KAap+WvKeYiaezQdsags4FqsgbEqDZWY1t0d3b3zK8
	5XzQBTvUSUFZVGBHRFH9qLxLa01bRqt+vdAV4fcrbVcWRAlaYDIfKtQDveI/OZiTUbakAR
	ZyakmKoeyHuBMceH51ZL6acx09EBJ6k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="r HiW/DH";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ldzREHgy;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CEAF57A00F7;
	Thu, 24 Sep 2026 11:22:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 24 Sep 2026 11:22:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790263376; x=
	1790349776; bh=i9829kPweuklhix3Z1AJfyPME8Dj1E3vcoJGw3M8wqk=; b=r
	HiW/DHek+JmfrjHge6+5C9Qq7tzQKeVot5KGDx5KDOk5tTqMfrK6MTIm/uxK0DS9
	CuCwOTUvtLTyX/0bl/25EPfDPwCSYVOSVzlNa8mMvqdBVsuJdveRt1F296iDdBBu
	vCT9AYnoDTn5ubo8QggHHPcWpPGWn059EUeol9yFM/doqKWQjPOOgx3sp+VOkOf0
	Cv2yp3RiF77jwASVIitq9UMKDySW5O5FmhuHE6LiR0yrbBRLBJqmLEDLGZojj+JI
	4sJ6tCR81IwhrcAqF/fkMegwBFCAn6tGnyq++AsCI6iyoGzckbXIWJyoTqZspLYh
	ZA3z8Ojfn/8AYJ3JxJv/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790263376; x=1790349776; bh=i9829kPweuklhix3Z1AJfyPME8Dj1E3vcoJ
	Gw3M8wqk=; b=ldzREHgy8qn/M67eVWZG1M9WNO1oVErf0HZcYvoi6NqEQMUKbhn
	bOIAoaO3fnBQJ1WPq/JhdwNu4HtWJWR89hyjxbZqK5FgRiRAXp9JSLI2hYyP6lnq
	ZBx5YU8oQtzpqTaIOUY+AJVKidm3Djfk1r7VvsIzP287bozKM5En+/qmHQg110EH
	3340bNAwp/ZA6oXHEYbpS9l/EKnHz14FG66Lbx8opVCVAZFtsrfj02ECbmhwvmM+
	bacjNYbemrGG8plMCyNspk6r+KxNl+y0nPjzrv8x0dInmO+0aHDBbZac9cMLFIkV
	C4AlljPvACf5D3Lvhua8CkTI+WspfqUOqQw==
X-ME-Sender: <xms:UEC1au9yDacykCnlx_WP67kQpJSkPNWA5yLrV91me4eVDGaZLihJIg>
    <xme:UEC1asVk8Lnl_rcGxvYYBcjojy3rSvCdH6Y3jNkGe7N4XR2J4reHkLSrd9ZeY1CUr
    TrEqyqMzIFLAacv_OQRLJtkl0fvZFWVYE5JesBoQNI36lpluBQXvz1t>
X-ME-Received: <xmr:UEC1arZ3uLBl3_ssQkZvswUtrcOYch5TPavc0S3BEPZEPOWuYntfoWMU-o8>
X-ME-Proxy-Cause: dmFkZTFOEUn76qAsDivzyhzaxVg7PBFGRMw+JOhFLqg+cNl/nhm8GytXTnazGyDSxwsGhK
    j/+NkLfyi36dqu7YdqiPFUiCwIsC1ecyqSlqD3Tm3hsRlecNHu92tTNpFDWN+dz3gvKG6F
    kN5sIFxDwtuWxWxoOY5Cuvq4sRqgoamTjVSTdtIc3wp8gBL3r56ubVMWhtzdXQ/CCaCogi
    3u0GJXH7g/d5NIYGaXEA/71nb/j3UTqjEE5ZBwkqiRSN6z8w6QuD75ih3hLZEhI0hzYuY5
    9UTL2y/fCg3Qga4bEbwRZkYBSwgzIa1EHyrLI7bgmDJR4jI8MMpa/XGhfqVoCL41U4VdPA
    3jolhBlpuiuG5Ou3hokvPOnz/Q89mLkYMrjPAYjITIbsEpktlB6Cg4Mm5mEVLFfU/6gQf8
    kklLUDvf7klk/P/ynJ3R9L9w+IMxpUNzHXVF5ENjbheqjRJzYBJmmvxXzkpErjl5zHRW0z
    63kXRk0zRkkKEe6BuHAbHnnC5chSxOxfJZUlk1b3Wgbodb+Kh7os4JoftfVzuIOy9tFkzC
    cqGP/6YUQ3FDRGn5Aurmxcgv01jUlsvAG2Why4sdj6Ah8fac1ngNEwwBAUyIbGqzP/ohmM
    tmuGP1q0Bx56xS8dr2K0kCqihfpR48oEVX3WlAUE4EXHWZHKoV23ua1WITsA
X-ME-Proxy: <xmx:UEC1aupICPxJWcKkt8t7vflDAD3oAj2LL1M3w1VwnAj9Y-Ikia5lPw>
    <xmx:UEC1aq7_qO5Oo-YzWV4RA46mTsJXXLnexyxh4nc59ikI7eDZLnl14w>
    <xmx:UEC1agWyou9GYHWILQj18DawbYQoIgCAnLZqsEUmHDBm6VJjfBo2Sg>
    <xmx:UEC1aguVsLFGZpdWn8wHty3ntBLcN048_hojDKhqnfXZNB6ILy9lwA>
    <xmx:UEC1amhavBbJoUeYNurtAFWp7GVDHeBBEeK-nn1jAkrNj7Qzvmj2hEOQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 11:22:55 -0400 (EDT)
Date: Thu, 24 Sep 2026 16:22:54 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 11/12] mm/collapse: declare the collapse interface in
 collapse.h
Message-ID: <arU8w9qDCvKod7PO@thinkstation>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-12-kirill@shutemov.name>
 <63f49a8b-cabf-4b93-a7e2-76b62c463a90@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63f49a8b-cabf-4b93-a7e2-76b62c463a90@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 478D240011
X-Stat-Signature: 8spgmiu8a6y6bmc6m9ifyogh9xk5iuft
X-Rspam-User: 
X-HE-Tag: 1790263378-621697
X-HE-Meta: U2FsdGVkX19bhtlt1xZ1HQV5Udi3avPNM2A2ylhL4iA9wTh1OcjWG7FLr/+DZsrq0gGYarTtbxVEOC4fd2WSW2LJjq4pF3bSn7H4JZRy7ax9xUNF3DXmNxX3Dx5rbrA5EwcXh2uo4swcM2JulzzPO4JcdEvKGLYNMPRDGMYUubWfB9FB+4/sQRm3rf4EVh7OrrIVHNS8VF4J071u5aOE+Gc+wpWWAK+AiIYU/yjhn1Xl4eV9HIDp8Pd/TWm4NwO5ISOIKoXQOXGr+eRZJO9NlHzOg+QehpaH5dWgTcAqMujOYhhCEjnJ2SE2NQ09MJo+Yx8rJz2J8SkqjVuGnm2pSlaJfL15m3dutjB0rgwhgsueeekk5hgmLseBPa2iHBBkaqagerY4FSxllUYjE91Zfq64ibivK4nHrogU8lE2JJynMNfjlDtgpxS2qk+auX00GYyn7wWl99agR0GHqg0DJSyg9DZ8hLZKvF0F3VEpR7tDOjrEJWEkVYDEjUHbocaf07agbPb5gHOTv+Ioph57vUXg8/+84je9NF08WsdOAEX0NI7/Z6iyz/m8YA+E9M+9/xRvw66rVASWPx1w/9DxSnhAjkfNtXrl3aWr3viuzRKoU0NxeHyS8t+JobvfCrM1ZdKCPOYNGMylq+h1GuPH0PR+FMpeOo5OcQKjjI6mzUSClKBgB7yLhzDKqLSexminLHaMFXE89p6kJT9+UXEpyMVP13tVCYvme31TcskCtpOmaJ1qL3eDwaVZ92lBAyKIpM2j327fFDFwq5WornrperwO3RvEiUCdqc2fS8zUgnoo8Nq9UZWIgMQpcS5FwFR7LZw6bPD4VK/U4CqXXFIvHrM/VT3uu+APRaQx42c4/2qGJ/TtA7PZ5xXMJ5TVl2lPsYcWrozBRNg5RitGWuFzs5lMPRUPLqhsC4R43gr5C5Hp2gp9cDLG/ilV9jsfh3RCbXjobWeQJ1+EhgRjxjn
 S8O3dy+F
 3ntwNoBRl4W83pxkyuFMrd2Fc8pZsb+MEENqrNdU95Z/FSnvdgYvRO2YnPR4SiTdLV5VeataISZTcTQf3jP6AcqUnhFr+LDOukLtVQ0nYBsZfbmE5KHAkwXwA789bWoPW+DXC1oElMCi+UY4ICmFPrLETDGnAsITm9Esmum3i0gDxE8sOAT+7yegVyYLh1V/AoKnrda/4QI4vQsIUeVCZqSuPfqyMSaAmrKjgYlccfCY3qWK6dJbCnmv/YVcQnxmrzmRKMDMdNNXKyXD62FxA9T0g95cSMzM8dx/1cIn0kx0cCq3Xi+4uNLZroalTLyyb6uTOTu609JHejzLAgDR+Ahyvqufuq8M5yp8k1XtSpNg6qRIcg9odtKfIHH7/oi4GSceZYj+mq8M0USCf3OIBBnWqZkp0u1g+eEKU5JmtvSk/k4EWV1cBrEk4EpTioUDHO7gsZ+Fwf6ueP00GOzDkebHCyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:34:11PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 11:31, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > A collapse takes four calls:
> > 
> >   - collapse_control_init() - set up the control a caller carries;
> >   - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
> >   - collapse_run_pmd() - collapse what the scan found, no mmap_lock;
> 
> As discussed, having a single collapse_pmd() function might be cleaner if that's
> easily possible.

Answered on patch 9: the two calls are the point.

> >   - collapse_control_release() - done with the control.
> 
> And as discussed, I hope we can just get rid of a release function that's not
> actually supposed to release anything right now (unless I was missing an update
> in one of the patches).

Will remove in v4.

> > All four are static in khugepaged.c, as are collapse_possible_orders(),
> > which says what a VMA allows, and the revalidate a caller needs once a
> > collapse has given the mmap_lock up.  No other file can ask for a collapse
> > without them.
> > 
> > Declare them in collapse.h, with a comment stating the order they are
> > called in and who holds the lock over each step.  Each function says
> > what it needs and what it does where it is defined.
> > 
> > hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
> > what a collapse offers now, not a helper of the daemon.
> 
> Is it just me or is collapse_vma_revalidate() an odd part of this interface?
> 
> You'd expect a matching function that performs the initial validation on a given
> vma.
> 
> Maybe we should have a
> 
> 	orders = collapse_vma_validate(vma)
> 
> that really just wraps collapse_possible_orders(), an expose that instead to the
> collapse users?
> 
> So they'd use collapse_vma_validate() to then call collapse_vma_revalidate()
> after temporarily dropping the mmap lock?

collapse_vma_revalidate() re-checks what the scan ran under: a VMA at
the address, anonymous if the scan went that way, covering the PMD
range, allowing this order.

A collapse_vma_validate() could bundle what the callers check before a
scan, for the sake of symmetry. Feels like overkill to me.

> > -static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> > +enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
> >  		bool expect_anon, struct vm_area_struct **vmap,
> >  		struct collapse_control *cc, unsigned int order)
> >  {
> > @@ -1264,7 +1264,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
> >  	}
> >  
> >  	mmap_read_lock(mm);
> > -	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> > +	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> >  					 &vma, cc, order);
> >  	if (result != SCAN_SUCCEED) {
> >  		mmap_read_unlock(mm);
> > @@ -1299,7 +1299,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
> >  	 * mmap_lock.
> >  	 */
> >  	mmap_write_lock(mm);
> > -	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> > +	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> >  					 &vma, cc, order);
> >  	if (result != SCAN_SUCCEED)
> >  		goto out_up_write;
> > @@ -2741,7 +2741,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  	return result;
> >  }
> >  
> > -static void collapse_control_init(struct collapse_control *cc)
> > +/* Set up a control before its first scan; cc->policy is the caller's to fill */
> 
> 
> Kerneldoc please. Applies to the other ones exposed as part of the same
> interface as well.

Will do, for all of them. The overview in collapse.h stays; it is what
ties the calls together and says who holds the lock between them.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

