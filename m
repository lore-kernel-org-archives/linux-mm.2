Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC12EDA686
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801336B00D8; Tue,  3 Mar 2026 10:34:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8DF6B00D9; Tue,  3 Mar 2026 10:34:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4F36B00DB; Tue,  3 Mar 2026 10:34:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB656B00D8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D83989C68
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:34:51 +0000 (UTC)
X-FDA: 84505149582.25.1D4F241
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id DBBF514000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:34:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BNOnXQzD;
	spf=temperror (imf23.hostedemail.com: error in processing during lookup of ak@linux.intel.com: DNS error) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772552086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOzTlA9Q1Hh95wpgJXpxS8PX0KPJ9xZrKE9BFwAgi/g=;
	b=B8kCwSpgJZRcagSBOPtwrV6GtwR4do54IdyGKXAiJpi6WGkevIjVvkNzTyKkwsdSm46u3g
	oOIdQq/6iLr+R2z9/P6+z0FdklSUlUaGrKLsfujbOy85j9Sn1PcLmJzwTIxnC1mp5A6AuY
	4WXK1P2VYsw6UnHojYKHr9ywCiHAuO4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BNOnXQzD;
	spf=temperror (imf23.hostedemail.com: error in processing during lookup of ak@linux.intel.com: DNS error) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772552086; a=rsa-sha256;
	cv=none;
	b=bJ7PFT4rn9XNW8GzXY2qH3VZB6kHnouMCOmyoa6BQ+y6afC6Qchq5Gpd9HsNwPcJlJ+LK4
	u6l/npyMiRkcbxXIBtWUk8D/Bf0yeZQuvLGHgqAoqusGDwbUiCFcBX2VFcB0oPLdMPrgYp
	PyypJ7d5gu6hgxEQgMX/Th1Zdy6qB68=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772552081; x=1804088081;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SJ3H5MuWnPGJaNMwps3UfGolG6H6CdjpYf/y1cQ5PJ4=;
  b=BNOnXQzD3jXXMZSNd0+9Bg6YFYaw8Gx7DhVBN+Ent8ZUYSDzAr690deu
   AfAC4AtcHF/gEOS9TYlBMG4dwDB5pW6dXu5JJsexp1TCjTu8upkkh9cNq
   WiqwXwcgV8vrlKWf07DXn4RJwW9uyiInHaMmTZ5JS3A/eJySiaYd+gdAA
   48cwUl34pSfZhiH15HoNbg3gaPo151DL6QC5NefBkZC0rFlwD3AMrnctA
   +tyh+WHRqQ73avzkMwKPblP4YIgfGS26ZApYzN2HRRyPS1P0/VgU+qlVT
   I09i62pevzJpoqJk/wFFEdZKramuI5lD49aRnt2GeR7WwlOA0Ftw6Dc/K
   A==;
X-CSE-ConnectionGUID: Ws+B2C26QX2oyupagNFM4w==
X-CSE-MsgGUID: UE/p/fyzRWybMjER6qe64A==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="83931180"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="83931180"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 07:34:37 -0800
X-CSE-ConnectionGUID: iVp9sCndTqK96kxZPvYD0A==
X-CSE-MsgGUID: rsYFXQKeRx2/z7GYR6AU+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="218144917"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 07:34:37 -0800
Date: Tue, 3 Mar 2026 07:34:35 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <aab_izbib9GzSeRc@tassilo>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
 <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org>
 <aaX2B9Efh0dBed6c@tassilo>
 <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org>
 <aaYFpEmiH99dryA4@tassilo>
 <72667151-816f-49a7-90e7-c68db3ac3390@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72667151-816f-49a7-90e7-c68db3ac3390@lucifer.local>
X-Rspamd-Queue-Id: DBBF514000D
X-Rspamd-Server: rspam07
X-Stat-Signature: yc7h3wuhqotr8e7z8woa7yhqgwyxzsft
X-Rspam-User: 
X-HE-Tag: 1772552080-169863
X-HE-Meta: U2FsdGVkX193p2P+du8xh9Ici+HZYt9u6wNtP4T8bbdMIErFXh+u8bYALSNYhcpWBk1hXPoddyFDUzsE/t60ZExmOF4IqnC8fQfPwZ4Q/s6uwjhJfMypsPrn4Q+ilkDEIkkhH8wY1ZvtuB0uy/kO8RKWZwh1/LioxGB+Gz6qlFSD7UX8FEYlxfC5VIH5Hkmr8OVw0QAhkYRYsFUW5SIyYT7SzzsIgfovaH1IGrPJMNHQsrfy7kQXNME/5MLnQGnDjKFAPZNKFKnEakFHf7sTz/mORps4M9AbHYrd6pPHFHjplmAH7ahHx9foIzdZGwxXowyY09kpoqN5/PIm+QEHbf8jjxjxPwgyjNz5eRIC/WORFfGwKaw7CNlsKnewDgmX92wTG9RNDlSLeR7qQLRNvCzJZhbqXXn6q2ZrP5nJTkDh5Bt5WTvnIlHpBJL10lB8HJ/hk2AmMefYPpHmZUsTEf0ZFZl7Ujwv2921paX0L0miKj3yA/7x54aHkNANgkaeEeuo2uulJKITsxt9MJ1TD/GPfb2URAbIm47pypYGC3oI9WXeRa18HiByKjaeNXWo3mjZxm4cBjysoYmg1xCgfmV1diLzKm6EiIhYxytr+ryFL+ibJZSWNuhqOZIVyNadH73tyMUKSaoOiSipMXHcPllCeHjfu9nSTYztlzh3dxhANGGh8DIv6InGVZtLEJJIrMz/YsFXOyiv5GlM+iL0e4IXgdAgujCoo10Gk1rljOF/YIo7WDYVG6wLFDlJjRKHA1pClgejuVt+/K0/OmIdOCe3wKD8vXa+cm/AX7uoGmLEfLHQGeBONaIkm20tEfLibb9BPTh/uKUwBGSb1GnNcYyJ9y8/RbKCm+U1uV/V4pP8cp2ACLdcWNRryd2VY9XHEc1cNaWWrbmL6M53rhIW4/8oqiCXpuVkC5uMPeb9kohRmxlleg42p+YOcuIANqzm899L/sdBn7ENTqxfkre
 JY/KpCXb
 XfKwXnbJ3TB4t9SV7GPOpLD8qh2QBQV0NBTik1mlFGXsmT+t5qGorFgbSOJhKslTXcmRbYGegdTpQV7OkCsVXLSHqVM3zulKPIVo4ApJ0AdSKm4XnSiAZdCowSA+tPqV+mOQ/ND+49yQIisWI/nFPOhQU5sLT58pZwJ6mTVcAMm6hF5MfywAOazb4/oIdJJpIZiyRkJzIaUIvKcqQkEQ0uq3y9VURMUEaqu3M0b9X07CV28QAw6m6/xs3Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 09:39:14AM +0000, Lorenzo Stoakes wrote:
> > > actually crosses two 4k pages. So it must be aware that mmap etc operate
> > > in 64k, but the underlying emulation might be smaller.
> >
> > Sounds like a very contrived use case, which I'm not sure actually
> > happens.  From my past experiences most software usually doesn't use
> > complicated enumerations anyways but just hard codes something
> > reasonable (like in your example just always assume 4K worst case).
> > From their POV it makes sense, how would you test
> > a complicated enumeration for cases that don't happen on your
> > current system.
> 
> I'm sorry but it's a legacy user-facing stat, we don't get to change it or add a

I would rather call it a legacy user-facing lie at this point.

Labelling something with 4K that is only 2MB is just wrong and
incorrect. 

> > > >> I'd expect other cases where an architecture might have to care about
> > > >> the actual, smallest possible MMUPageSize it might be executed on while
> > > >> running the program.
> > > >
> > > > That's fine, they can use the min, or just the first match
> > > > (which is always the smallest)
> > > >
> > > >>
> > > >> It's a shame we had to add MMUPageSize, but maybe it might resurface if
> > > >> we ever support emulating 64K/16K user pagesizes on 4K MMUs.
> > > >
> > > > Okay, so if I follow that correctly you're suggesting
> > > > to change KernelPageSize, not MMUPageSize. I can do that change.
> > >
> > > Not at all. I'm saying that we leave KernelPageSize and MMUPageSize
> > > alone, just as they are today.
> >
> > That doesn't solve the problem that motivated my patch
> > smaps is confusing today and would stay so.
> 
> Except as you've been told you can find this information out in different
> ways.

Yes I figured this out by myself, but only wasting a lot of time caused
by the confusing and incorrect legacy interface. That's the problem
I'm trying to address here.

Thank you for rubbing salt into the wounds.

The crazy thing about this is that hugetlbfs even does it correctly,
it's only THP that is blatantly wrong.

> 
> >
> > >
> > > Instead, if we want better statistics (and I think we want) regarding
> > > how things are mapped, we should look into a better interface.
> >
> > I don't see how a new interface helps really. Some of the problems
> 
> I mean, you want information X, we're suggesting the providing of an interface
> to provide information X and... you don't see how that helps?

My goal was to fix the old interface to not blatantly report wrong
information. A new magical interface doesn't really help with that.


> 
> > you mentioned earlier could be either solved today with smaps
> > (e.g. handling the case when a folio is mapped partially and just
> > report the smaller page size), or are unsolveable in the general case
> > (what the TLB actually handles)
> 
> We're not having multiple entries in smaps for every mapping size, it's broken
> and ungreppable, and very liable to add additional confusion to users.

Okay, I guess one way to address your objections with "ungreppable" 
would be to report the majority page size in MMUPageSize and call
the minority page sizes something else that doesn't trigger on grep.

(MMUSecondaryPS or something like that)

If you don't like numbers I guess we can spell it out.


> A new interface gives us flexibility to do what we want, we aren't running out
> of syscalls or places to put statistics.

I don't see why a new interface is needed TBH. Can just add fields
and fix the existing fields not to lie. Yes need to take care of 
compatibility, I don't disagree on that. But just adding new interfaces
for everything instead of maintaining the old stuff properly isn't
the right answer.


-Andi

