Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E75606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VzKb9Hjm
Received: by kanga.kvack.org (Postfix)
	id C12E26B05B9; Mon, 16 Nov 2026 09:43:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2B86B05BA; Mon, 16 Nov 2026 09:43:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2FB6B05BC; Mon, 16 Nov 2026 09:43:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86E976B05B9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:43:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20664C0108
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:43:06 +0000 (UTC)
X-FDA: 85441249572.23.CE328E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 59CA8C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:43:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzKb9Hjm;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794840184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5WAUZ0iTMrFbG45MzH2WhaXFaY0UAYECCJjbW+xqiA=;
	b=4xDh21OLBIoN3mMUCgLgjY+byw2t6klS68BPwJdC0jOGJY/4PDktOHT1nYL+YKzj5I09yd
	HyuKISxGtTghh3cgXtmZb3qfbfMZTM+VnWVgHK4wHdZLcllQdpxVDKbdWIDb+SEbkprYN1
	VyaL0v+AQRlIzt8f1wyfIgphtI9mJx4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzKb9Hjm;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794840184;
	b=ze9gzkl5sDCJ3O3kvDQGuyIgNeEIuoVA6HIKrO0Zes1jYM91Bbmnre2RpPR7k2PNmSYv+0
	ft+ZbcVXJHsIQH4MFGit5JSn4y43OTeS8ardB/InZ2mGrEjhaEhDfU85ScA7uj/o1mcfZy
	K9MP8CZVSEt9jQCDpVVZ59Ke034+0/M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B924561D12;
	Mon, 16 Nov 2026 14:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4CE1F000C4;
	Mon, 16 Nov 2026 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840183;
	bh=H5WAUZ0iTMrFbG45MzH2WhaXFaY0UAYECCJjbW+xqiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VzKb9HjmmBkyEZ4KIpHhIBbGQOEabZMQ85PqbrRJmD19QyZbEbdSCbEyig+iXh23O
	 O+QiOMpcMTKltLYJuQn6uMCw1lZi7mG5/kZA8who5MrZa+OfpF/3qQB20PmKeXVpmK
	 tXx/pPqiTJD/BMmDLNLHeu1TvgmVQjilffpNqbgZSOkHVG+l6d24ESLAJ2jEqoLYyV
	 KKlwj5M1rrPkDnTQD7HE6EwfcOLs9vmgAwfVR6A4bC6AzJcUe4usAEp6Tg+dHhDwQr
	 tiYyhKtuFkRNUELLJBOWSWrATlee8METpbtEyBb3zhnv0qpPEk0BUc3RpRXTmWAnUo
	 mvTQHZkDS7kcw==
Date: Mon, 16 Nov 2026 14:42:51 +0000
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
Subject: Re: [PATCH 12/12] mm/userfaultfd: check hugetlb end alignment in
 UFFDIO_UNREGISTER pre-scan
Message-ID: <avsWSRC0zw-zD56x@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-12-00713d368976@columbia.edu>
 <avYVPp7fHNg8WSUB@gremlin>
 <2e812a10-e937-40f2-b250-74ccee5f143e@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e812a10-e937-40f2-b250-74ccee5f143e@columbia.edu>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59CA8C0004
X-Rspam-User: 
X-Stat-Signature: cjfxoxfx6uqr4eo96psw33ww1hh9ynyh
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794840184-628913
X-HE-Meta: U2FsdGVkX19Z6R5PqK9eCAKqKAQ42a7yuU3/mNZHwRkDTAXitp78Ru7ayYsZmoXj1hkzUskaqUMUhacJNUvdvNEaJdKHbfA3fyXgkrb1qKo0LEDlGQoMtzawJ8w5Jz/eKktNVTS1PN+6LdzKz5/ADrIdRrb3u77kUTtbWlzAPpIwZhKe4BBXhHDWTiA+CiqxNoSwhBX3wRwaDf2sl4DkSkklfj84FaugjqmB2zxePiXpLmO1yUsGLjIPN6oOp6sxP+tYq021RUttc2acijYKj8It5trYUXCv5AU4kk3j3X+lXh7IQl1E/8etEz12y6BNo/MyQjQflqL3NZVjl+dJjpvrR9PWgHS8D5jofKAxUk1bb4hQs8F4fJ+vokpkeL0dwZb7ubeNMoHAtW14NPlqapKiA/VjYBedg28epOr7lY+FU5FsZsbe512PHKWAGI+l1tzXP/Ge+wU+xxFMEb08UQ0YTGTnpg6V3l8JplYK14BkGIE2XkCo+eLiK8ENnDcFACIuhu7c5HsVKFhJxxG6B4EeqfCus2i9Spcj9a0keQhnvH94YIW2VNxl8mNVvW9bXzZPNXdfSLXChCWZ+YPTONMfNGCh+J2iX3/nIfkY7pJAzOaWCI7DdXVkK1AhknqP0vbvG8Lnbrb708/YSmnc+PsseFIHtATDvMbienX/xt0LC+HHcV+w7L9IQEzKtwKwjYwV5dKcXKHKSGaVsCzPHH3dXAlNtqEtN4Bh4VCkGoGbzfK7w0mYJSPeQhVzeLOfCvwsEUaMo9qjpZKcJCOlorzld4Mh2UyRJwud8O2FobO9KcUv4ZeM5UQZr/6IvuanuJgSLMNFuDTeb/wUX28HG23Tjf21zYUBoPA54PbS1auSsELRyeEnTGPA89Mmls2gZdCj11EISLttK365gRozXvmhTeOzXtKASgLCxxOUOXzQrlVGZeIuXS9Solh0hzTKiTkkgnbmEPcR/ukVzAB
 r6PQ5R+D
 MEyVGtVBdETrf7548IePKPHDbxq7xibPtPJE4WFwA3iStXHjkkUVfPeVwHJYMRVKBC4zYHr46KFP5YPufAT32CvrTsoUofJcuFzP0bTGtLw0VUI9TEJBbEzRRlgSveRM5eKjiYzgHiK1sP49Fg5ufwk0ZhmyJAsmLtcwnyGBs3FbjLNCkLk1lcel4ganVueRMb40cg2BB/6X/Gc59FzS0y7MqIBuIAqLnZOjGphjR2PCAhZr4pGb1EyR5f5rWaPPuakeVVX23bbQ77qKUSPqJgQWCOH6cwPzUXq3zNtZ/o9s9R49IGBs7mjmOaoDULjZCh2jU2b71x/J4sVADTG6qODfIGLmn+cENQHYArSHTOK4W3SKei9MEig2lgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 05:34:51PM -0500, Tal Zussman wrote:
> On 11/12/26 2:52 PM, Lorenzo Stoakes (ARM) wrote:
> >
> > hugetlb vs userfaultfd is a bit like the alien vs. predator of worst mm features
> > of all time (TM)
> >
>
> Alien vs. Predator had a sequel... let's see what the mm version of
> that will be :)

AI vs. Maintainer? :P

>
> > On Wed, Nov 11, 2026 at 12:55:20PM -0500, Tal Zussman wrote:
> >> UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
> >> before changing anything. For a hugetlb VMA, userfaultfd_register()
> >> rejects a range whose start or end is not huge page aligned there.
> >> However, userfaultfd_unregister() only checks the start.
> >>
> >> An unaligned end only fails later, when vma_modify_flags_uffd() cannot
> >> split the VMA there. At that point, userfaultfd_clear_vma() already
> >> cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
> >> stays registered, but accesses to its pages are no longer reported. This
> >> requires a caller passing a misaligned range.
> >>
> >> To fix it, check the end of a registered VMA in the pre-scan as well.
> >> The ioctl still returns -EINVAL, but no longer unregisters the VMAs
> >> before the misaligned one first.
> >>
> >> Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
> >> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >> ---
> >>  mm/userfaultfd.c | 12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >>
> >> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> >> index bf42fabb5afd..c0076c8b4e9d 100644
> >> --- a/mm/userfaultfd.c
> >> +++ b/mm/userfaultfd.c
> >> @@ -3983,6 +3983,18 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> >>  		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
> >>  			goto out_unlock;
> >>
> >> +		/*
> >> +		 * A range ending inside a registered hugetlb vma must end
> >> +		 * huge page aligned, as in userfaultfd_register().
> >> +		 */
> >
> > Hmm I think this is more or less saying what the code is doing :) so I think
> > unnecessary. Maybe worth using the words 'cursed' and 'eldrich' here to describe
> > what's going on? Or possibly just e.g.:
> >
> > 	/* See check in userfaultfd_register(). */
> >
>
> Will cut it down.

Thanks!

>
> >> +		if (cur->vm_userfaultfd_ctx.ctx && vma_is_hugetlb(cur) &&
> >
> > This first check is pretty horrid to spell out loud, maybe do something like:
> >
> > 	do {
> > 		const struct userfaultfd_ctx *vma_ctx = cur->vm_userfaultfd_ctx.ctx;
> > 		...
> > 		if (vma_ctx && vma_is_hugetlb(cur) && end <= cur->vm_end &&
> > 		    end > cur->vm_start) {
> > 		    ...
> > 		}
> >
> >> +		    end <= cur->vm_end && end > cur->vm_start) {
> >> +			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
> >
> > Could be const?
> >
> > Also is vma_kernel_pagesize() right? If the VMA is hugetlb, then that'll end up
> > as hugetlb_vm_op_pagesize() which is huge_page_size(hstate_vma()), but it seems
> > userfaultfd is full of this crap and yeah ok. Fine :)
> >
> >> +
> >> +			if (end & (vma_hpagesize - 1))
> >
> > Could do:
> > 			if (!IS_ALIGNED(end, vma_hpagesize))
> >
> > Instead?
> >
> >
>
> I just took this chunk straight from userfaultfd_register() and added the
> ctx check, but I can clean this up while here. userfaultfd_register()
> probably deserves a follow-up too.

Thanks!

>
> >> +				goto out_unlock;
> >> +		}
> >> +
> >>  		found = true;
> >>  	} for_each_vma_range(vmi, cur, end);
> >>  	VM_WARN_ON_ONCE(!found);
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

