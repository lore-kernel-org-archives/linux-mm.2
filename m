Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00ECF606EE99
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PTARwSug
Received: by kanga.kvack.org (Postfix)
	id 1D6646B05B2; Fri,  6 Nov 2026 05:50:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB1D6B05BC; Fri,  6 Nov 2026 05:50:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9D16B05BD; Fri,  6 Nov 2026 05:50:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD5CC6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:50:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D35E40D8F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:49:39 +0000 (UTC)
X-FDA: 85404373278.18.BFE2D7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8FF16C0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:49:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PTARwSug;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793962177;
	b=PwUUEpUzIOCzvM2YFV2e0uZO9zdFc9sd5O40ocePg1ZWk/LP4S6GdraLZnnEGx6pEzqb9H
	nehmZkErcg8bWrzIt3czNYiEVJmG8Lyq9pE1lA3zGj4VKhD7iTNRJbdV2Y0aLqRRYIWLVl
	9M+AsOekFgOdUk9Cp9yaK1ZervCD53U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PTARwSug;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793962177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvQ15e3g/AD8lbRjQ6JUAGFsFKFusEgK6jSCW/w75+w=;
	b=o+UP5SlXsinN653Y38y5GVFAQUKEVZVujKBMoWsxbNLo4wshSIJ5XwafHuL2SFBsleHAEw
	E+q7xPraqz1cDGi9iG0Lrc8ddj0F79vejCqanQJRymaRa9QyTBax7uC63o+2e1ILmGoN5/
	UTUVF3lgcA1D5t8DamP8+K2Jj65F6uc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D073605F9;
	Fri,  6 Nov 2026 10:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9165E1F0089F;
	Fri,  6 Nov 2026 10:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793962176;
	bh=mvQ15e3g/AD8lbRjQ6JUAGFsFKFusEgK6jSCW/w75+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PTARwSugKACzchwI9R+JjOROV4b+HroR1chp7uSPikfui18Gfvfu+dEapvGjm2sfT
	 ZJJ1rBeztIqrZhw0OnqUbqbKI3Q7hz+Lww5ww1p/MLaw3/3Gahrb/ZOE5ieP98K3UQ
	 Y+dnYA8WW3ggbFrwgAD6tRWgjpk8iJvBf4Q0EnOZVVJYz2BgmjJV5GdPVQNjREy3Gu
	 ENZk5WkUZhdgklr/rwtQL60aQDa+N/X5jz6SHCXmlpBlboNel56RCNgQmVJru7OO0a
	 UxRP2GVwUWrBD9BxXkERJ99Tryg4zcvnQ7zJ6Pxc2bckJKjSvvsOBBFEAdfDFCClGC
	 mIQpIRrRmQO1Q==
Date: Fri, 6 Nov 2026 10:49:31 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <au2wjPw7PMD5veiV@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <257ab860-b408-4897-838b-e7b68f981d6c@gmail.com>
 <b48e1b6d-0286-489c-a688-cf751fb74fe6@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b48e1b6d-0286-489c-a688-cf751fb74fe6@gmail.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FF16C0003
X-Stat-Signature: 8hx95kydo66himmxp8upzb51t471pkkk
X-Rspam-User: 
X-HE-Tag: 1793962177-408411
X-HE-Meta: U2FsdGVkX194Shz6MBm3L11XdRaeaATdZMY9+P8A3geUnIVge4akGh0MWMt1C9Y4LH1DNznwX+DFiQ+MCwM0FrZuEMMQzT5kHRfEOlOXgxNAQmdgYlgiOVD522dm/F9t6VIgW0wh6nRnD85s2WPSbDO2KX9MavHKgYqn/D6Clsgy5A+m0Lo3cq3UZE842V7nbwzvMZimURGd+OQgP8t+WwMOdjsytVBtZbzlyBBwa7nJZrOZozRAQVuKXmMnlrTOSbZlXaxZE0WC3FVNkCvcIZex9WVtkZhlVDrJqNZMnzI85B1r2TinBINwS+ojzDldatVFxnvS1WhsW5QzaEXN9Un8GDrry9KRJYIiIgusNnnx2yGe1L/w+u7Rrkp0eNafTW3JpQJgA/pGG0UVa7aRT8mdTlYslKLwhOdglUqOUx4sg86Qifz0JDXRvF8bk3LvG6t4+LbnNlkXzoie6EzugNw65ryGJjPX6quX7ghHfuGBuLknEHeCGey9hQtdYx1KUO0BB4OufiBhzLooVk4ZJNr435cJaIVHZCSTRMO3WPgS6y2w1EszGIKg7c2mzEkr2JaOpgYuBOfUGvBgwsFvgvrrvzXhdoUetzfpsCmfJvJ62yrRQVfQWryPm4TDiFtm7nOlgEkz6+B0NSJBwgPmZ1exwrgGmuKeg4e2c5o5PEzAkSQim9QB5BbUcPd4kACGDRrXMFTYqCTnSb/r9V1nOJxN6ZydmQivhgakVclBXKKJ1wGBeXyVNqVwEV2XNW0dw1NR9k0RP5wXA1qvcMpjo/Vy7Kf2w5kLNbvqzg4gYWiMTTmSO7EIJc3Hl+z/90C78vrx+zt6bjkAmeG01Rh/rhD09WyOeBbdiqk3i4bqRkk1QP5BrwwRR+k6hn0q3Xf3eSaNQKS1vyyVmdd4WcSZil7AL0n52ksfOj5tuW5SSTectOvgY6ie/dxkatB40LwY3am0q4cyRLpAj60gInU
 utR3ADWr
 2ziiFxMIc/MNIeDst4JdgYEwpOUsX1iHZbrawvUUD41ijGD5H7PhWfXMs6gvn6Rbv4yGL8THGAX2cw3ypum2tG3f39umd+OT+h7YfdFc8+thAILshP/dD7fJwRwuP++8kLDXMxIKGTyUB4tyMNAj/nCI1q/rd7BC99VEgHm0jy5oKGsdGwikAtBuLDpHnmY3OUtRvqiTSzE1kHbRj/Xdy2A+fg51CVlpqJIRuGFC4uEJPQbH7pfQuEODuym7lFLAlqn5CsPM895BLHfWiuXdN548Cxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 05:29:45PM +0800, Vernon Yang wrote:
> On Fri, Nov 06, 2026 at 10:12:46AM +0800, Vernon Yang wrote:
> > On Thu, Nov 05, 2026 at 08:57:24PM +0000, Lorenzo Stoakes (ARM) wrote:
> > >  		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
> > > -			/* Unable to collapse, skip to the next candidate. */
> > > -			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> > > +			const unsigned long next =
> > > +				ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> > > +
> > >  			cc->progress++;
> > > +			/* Check for overflow. */
> > > +			if (unlikely(next < vma->vm_end)) {
> >
> > I think you want it to be like that.
> >
> > 			if (unlikely(next >= vma->vm_end)) {
> > 					  ^^
>
> Don’t read this comment please. Your code is right.
>
> The VMA at the top of mm, after aligning the end values according to the
> PMD, may overflow to 0.
>
> It might be easier to understand if this coding is used.
>
> 			if (unlikely(next == 0)) {

I'd rather keep < as it's the general form used for overflow checks and I don't
want to bake in assumptions about the nature of the overflow or make somebody
have to reason about that :)

>
> --
> Cheers,
> Vernon

--
Cheers, Lorenzo

