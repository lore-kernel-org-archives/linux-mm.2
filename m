Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 406AECC6B35
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 09:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02D36B008A; Thu,  2 Apr 2026 05:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9B16B008C; Thu,  2 Apr 2026 05:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916F36B0092; Thu,  2 Apr 2026 05:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81FA96B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:05:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BDF9E06FC
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:05:36 +0000 (UTC)
X-FDA: 84613032672.10.C2EF736
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 61A8B140007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:05:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=efM43sZ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775120734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfHUvvgXQutH0PejSYAx1kYrHzNDD4c4DofRBzeLTh8=;
	b=Xo3jR+5H2nXxGaZal9XZet1pF5kqONBYCn6EkH2GvIOmlvmcCtI9rXi7AQWbYyMyvpxqiL
	eRVn2Kp8cL4Tqh8yVBk3xP/WYi/uHdB3JU+2MiJMr6OYFnAPrCCUjNmah71dSkVpDqr7HJ
	z/fRt2dlt7OEBtEkUqEdJujnZ09+vH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775120734; a=rsa-sha256;
	cv=none;
	b=v0QyzYCp78PDrtobJW0yV98T3/7FqX1mY6CW95Fs12DssQIAiqPnbLwM+GXcrecM5puyVW
	oFpcrmFA+K58D1iqnpqgn1t/r2q60/eyVRi78xzcLJXKud2MLsblLlMh9rnO+B2/4HChcT
	oAZrtM7blrj1WA6tokSkXelAKzsj65U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=efM43sZ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A35EA61862;
	Thu,  2 Apr 2026 09:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24E7C19423;
	Thu,  2 Apr 2026 09:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775120733;
	bh=yfHUvvgXQutH0PejSYAx1kYrHzNDD4c4DofRBzeLTh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=efM43sZ2A/ZfqyTCE6QyXcUhTSqKNHMGoc0DNLI6pUPvzYoAPSciVsLz8B77AduZp
	 w+XxRaaVCxnlnepcfCZi93QgTadPznyIAojrLQDjc0NEs094/tdyiDFHLPVIluVQLN
	 dipx3TePpmSg2cPvw4jD+xaSFkoCNdM3v17oS7thDGheJQdmQohtZGWj51KOJ2wD/6
	 TnyzywN1U9/A1hrwLZqWF4gymmrNJb78av1IMn1MO+0ayyq6AaX/MnvziDjvFty/b8
	 N0oBHp4YsZYN9qenBb1q0IlcfJUAdtCvlC5pzag7GOrwMpa029pRCbadCwq0cnIC11
	 25jESRIAdN9bg==
Date: Thu, 2 Apr 2026 10:05:27 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sayali Patil <sayalip@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v3 08/13] selftests/mm: ensure destination is
 hugetlb-backed in hugepage-mremap
Message-ID: <0a1befae-1037-4bbe-b976-352ef4607d2a@lucifer.local>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <3b6ffba238a4b59de891acf896fa25d7d3193228.1774591179.git.sayalip@linux.ibm.com>
 <ee15d52f-45df-415b-b0d9-3d267d147e5c@kernel.org>
 <b590a17c-13ed-45f4-9f51-ac662d00e7bf@lucifer.local>
 <066a146b-7dbb-408e-bbc0-542bdcdd6681@linux.ibm.com>
 <86889304-c450-491c-8c06-48ca9c973531@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86889304-c450-491c-8c06-48ca9c973531@kernel.org>
X-Rspamd-Queue-Id: 61A8B140007
X-Stat-Signature: shm9i1ncconaqeposjruhumqzd1bonfx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775120734-987470
X-HE-Meta: U2FsdGVkX1+haMj/TCVKPGKNKZ5/lv+WqbymemPWYpQ/dhFrr+wm+p2CpdDkOJdy3MHtcnwhLqvEfHvDt9wUnVe5UkHbUcFkoDkoDATHp+t3p63VYAJhFt7JZgMMcwkB0ep6Vsm2A8lii87eyOshpMTybb/OMM0yJPWfgBhlCXqa4Mbz6MWkmCG0zLK2WV57RSx0sEzF5y6qjJTKSGNPBEF6+gR66548dKvsyIswh+TbS9in39DObjofVQwawC8+rHBU9xHUoRpKvuhrlgZH+Go5r/LpsbL0Xjyiob3SVuRm1yB1mztwMEk2BAQ5ajlC+RgC77fVoTRmGiBcQ1A3i29ftvcl5k1JtHqiVc6OQZ6FRb7zFmWXmUN9fnJi7WJtq4rOi9RIXyOu8OoaDSiLT6RtD2p/r9oxkv7qwDfLBiL0rFUJmbm0WJ5Mx3Pe2ghzgkA9+RiiGwz/4LxwL27u0A8jyDYWBddARqyoK6+0rHPoNowfswYK7O4tjBU+EGw9/ee9n+OeLbmoR2vczr5kkx9JCnrK8xvJuwTwXL208TnfYFSgN+22c0utL2eUUOPBUaF/zhyECkoCPrKbasTRqOIxEDXS4KP0tRIpXmnmLSwHaTLD1U2GLkwn3GLpbcsfywN8hUHh/odKmdxtACumWWzSiKkg/o/d2nTNhOrGfHwqVqAoTSpgjJtRG2EyYkocAuncHm1+MZjE7fSIMZLUJBS+Hd2/4AT/LZdASKTHax7d9fYTXRCRwKKqXRDAGgLglavq9AOFI6mSSwbojzJUjrqHyinDA9MBmBQnodfaxmNExqegz6xv13PeSG4l5KiXIuu9Iqf1X7jyVTE34XPEBGg5+o/U9BapQU6UN6ESGrHP/Wpd9xkv/OKGtVWt4sWG5rXxUXfM7WqaAdvm44uXaq+tcqQZ69PE4pjquyp6aBgQI0G9r9i6MlzunE6b28sZ90BwZMx0eNEDWxNRTVj
 c7BMhYrv
 GTRq6my61UBvEYsbDH/aO0er3zTGyS2p0xFVg1unM3zD+M1f1kW8OWCoOteTu7nIFvGoakPO+IRjyIOOckQeGnVZMA+zdG4232TYsNHANACQfw5DN+qMjWI47ZeRjW3JwnE+5Gn7CiYyzvJ8BpwwmsBWBSEaDIANADci3j4jDIv70jZ+EBtqfxULQU6ZPaskhSE0/rNxCOM8h0fqm2EiwsKsoC9A9/GlLSBAlhjo0xvtHp3RhL9DeHYNQJO5PID7ZsXno3kSd+aeuZT4EhrJ8iT/eSdSGVr4Pe2dmktO6HdEIwZEozRuhKi7ZBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 09:33:29AM +0200, David Hildenbrand (Arm) wrote:
> On 4/1/26 22:39, Sayali Patil wrote:
> >
> >
> > On 01/04/26 20:10, Lorenzo Stoakes (Oracle) wrote:
> >> On Wed, Apr 01, 2026 at 04:21:55PM +0200, David Hildenbrand (Arm) wrote:
> >>
> >> OK so digging in:
> >>
> >> mremap -> ... -> vrm_set_new_addr() -> get_unmapped_area() -> ... (in
> >> ppc arch
> >> code) -> slice_get_unmapped_area():
> >>
> >> unsigned long slice_get_unmapped_area(unsigned long addr, unsigned
> >> long len,
> >>                       unsigned long flags, unsigned int psize,
> >>                       int topdown)
> >> {
> >>     ...
> >>     /* bunch of checks */
> >>
> >>     /* If we have MAP_FIXED and failed the above steps, then error out */
> >>     if (fixed)
> >>         return -EBUSY;
> >>
> >>     ...
> >> }
> >>
> >> Is presumably where we hit the issue.
> >>
> >>>
> >>> That is weird. An mremap(MREMAP_FIXED) is really just an munmap() +
> >>> move.
> >>
> >> Yeah the weird bit I guess is that we _still_ invoke
> >> get_unmapped_area() but
> >> with MAP_FIXED set to indicate that we want the specific address, so it's
> >> subject to the above checks.
> >>
> >>>
> >>> Are we sure this is not some actual problem in the hugetlb
> >>> implementation?
> >>
> >> It seems the 'slices' check sees if the _target address_ has an
> >> equivalent page
> >> size, presumably hugetlb-mandated, and fails if they're not
> >> equivalent, so this
> >> change is just accounting for that.
> >>
> > Yes, this change accounts for that by ensuring the destination is
> > created with MAP_HUGETLB so it has the same page size as the source.
>
> Okay, weird, so it's the right thing to do to cover all odd arch behavior.
>
> >>
> >>>
> >>>
> >>> But then the test suddenly requires more hugetlb pages, no? I don't see
> >>> a good reason for the MAP_POPULATE, really. It will be discarded
> >>> either way.
> >>
> >> Yeah I'm not sure about the MAP_POPULATE being all that important here.
> >>
> > As far as I understand, without MAP_POPULATE, memory accesses would
> > trigger userfaults, and since the test is single-threaded and has no
> > background handler for the uffd, it would deadlock. MAP_POPULATE ensures
> > the test runs correctly by prefaulting all pages, but please let me know
> > if I’m mistaken.
>
> So you are saying the test would deadlock if you are not adding
> MAP_POPULATE? If so, please double check if that is actually the case.
>
> And if it's actually the case, please carefully document that in the
> patch description, and probably as a comment above the MAP_POPULATE usage.

Do keep in mind MAP_POPULATE is not _guaranteed_ to work :)

For guaranteed populate you need madvise(..., MADV_POPULATE_[READ/WRITE]) or to
directly fault in.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

