Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC060C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 16:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E406B0095; Tue, 22 Sep 2026 12:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC77F6B009B; Tue, 22 Sep 2026 12:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5D86B009D; Tue, 22 Sep 2026 12:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75C9F6B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:45:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F37FB1C3088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:45:12 +0000 (UTC)
X-FDA: 85241973264.30.F76958D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5EFA540012
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:45:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKDhZi0e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790095511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMdG76MeQldYLnCdGPtfwF3zaPMlZJI65YPqsh9aHeQ=;
	b=27k+gB8GKKDGyYh7uqzEl/JkP9TFEUSnP7PGni2Zi2F3TxSJLnTztsZj7K0csUQhJArDXu
	BefNdAJrpdjMkfvCRInSc7VURKj20CePexMajt5D47TeK+WJN/GPmIxNRD2rGCZWl3yT7b
	qfDyl77N97hzzA566uzerX6UTwlF2Kg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKDhZi0e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790095511;
	b=qTtBGh7ck7RF3FFOCJa37Prp3QvpKi/RBAjOUxQZBviSj4So+z2OsW+A0VkeTS5kC1TsMW
	Wzo4UTjbLPWqwlxYtkkeF7x1F0/owllB4x2lIxO0ZmDy2AhxA5ACRc1acg04GJDGg4E+iZ
	vdzFvTa/vz11ysni02WbhkJK2NLQOiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F0796022F;
	Tue, 22 Sep 2026 16:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125AF1F000FF;
	Tue, 22 Sep 2026 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790095509;
	bh=kMdG76MeQldYLnCdGPtfwF3zaPMlZJI65YPqsh9aHeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jKDhZi0e73h+nMW4g8pA7A9NUbYmjT02T7buH0UC9uXaYZrNO8Zr0PPC/SZI602aX
	 XwxgYZEOKWDRu83nzrVKc/exGZR4LZdIPb/RkR0oOsdzxezkAfu5fSLqH0DoipprD5
	 LTJbHmlmHh615fAE3i3BJAZDNodtmagudfF3gkkZ8b8RthU/SuIRAE+84Z4dU3isyX
	 y0ylSUjpU1c9tVmoTmrVAOhlTxpKPVcD8JsPmJR3/F5S0uuxxxL7GoKgXCqDUkHQU8
	 8gVFLt/wLDCGy6Cv+0PHMRmkkW6Go0Lby5jDKJ7o2i9Yse4qbE87NPZB+s9tgU5ItD
	 +5C0mo8nWChVw==
Date: Tue, 22 Sep 2026 19:45:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>, akpm@linux-foundation.org,
	peterx@redhat.com, surenb@google.com, aarcange@redhat.com,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
Message-ID: <arKwjZ67hJFBunSd@kernel.org>
References: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
 <20260919004630.1159895-2-donggeunyoo.kernel@gmail.com>
 <49208ed6-6c20-49a9-9c0d-0e1cffe1898f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49208ed6-6c20-49a9-9c0d-0e1cffe1898f@kernel.org>
X-Stat-Signature: fp8g5pxiee67hg17u7eiyfdatkpdyy31
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5EFA540012
X-HE-Tag: 1790095511-689610
X-HE-Meta: U2FsdGVkX193lUtHc+/hS3xfiw4m4kfCzxQvyVL0dQwqmyCf8yJ82BCFoOwvtl8lHkds+LZgwf/QTmVGZXoeAZHsvFkEISZfUN8rVtVHI7UY/88WvK+MVSyIWI1YQJFhRrhj7GLdUqNziC/Uhwzoqdjc+5YniF4PNtOLpHhX1Iej9QdHgwff/x9M30T60Us8ayDSWqsWDiHePtEXAH9U06vYFUTJAl8LJb/oNMhNMb/4KRvE1gAkZLWTeUQEg2wiMiVL+Wmqbpv+MyQKZAPoO86kkoyYT5p6f4Z9v4wtaDUlQAp7p9UWKSAEQALWulD3G9vXMcVB16izDqwsEUEM8FOdIpEIHfFGm8hel669wfw0Iu7iRdtFMXOPAx4MMUh3q9prtvCSmEQo0BI4X1anbkUMaYnD68RNzLJ/NkhGO2WDEIjXqIvtfPVOnz2Z9Orunm8NT2t9maaOJzhurbuRk5Z9uz9iUboNJYr9vPbmznPaplPgSFCxQJclX2O6adWI0WU7/WcCochIGWRuYeFblGOIajzGFL6FmYonRSkPIjh0LK94kLqU35Mx4ZCbrzFyhICJf/tB8nGDJ7sj6OYfgacsmCVws7dkxSDLDzW6ygeGvH5DaFD+veG24iftcG2U5V7TJoHW/i+IVui+eVcWtO9IcoCC/UEw9PCAOoKwaHEw6je30CrkshEhUKWbjmcXkEzgj7Z8xvysFWyfA0mnrT5PpXuPusIpMdfp4134p5uXBPdN9JaSoqwTr1ErKGsycCdP9S3gI4SPKIRdIus87eFPgqAoYYqpAnKX9SZtveS32Ba+a12Q2xxROLb//mbOoXjqxOzRC7KpARnmm60eStFBy2oBk/MI2MaG6VUpV9rt2YeVOjeo70Ch5zN4am4Y/4Yix/NMMEiHhpb9L/5BcU6pkLxBr/Gn00yXxpZf3lCdit+A/8L/9WbSY3mkrp637JdzQSA4V/saxFwiERU
 4T2FrfRp
 c9USUSU5UljPnqJZSKiwdbMZzNGBW6aT88h8YJlp6FL1cWEkvL2jThsLc7GvDm24QN1iiZmEroOjY8ftiZJmUsgGhoA4WYD56JedRWYHCeZkUJjvmgW+86lOZ1jE36OO7Mgz0YgLoxRrzmZPPWWPJVbnDZUCi1UaDWm3PpbIZGUdIvnbg9UVXRCSUD9OUcIKN1DhaMT3HzoRzO9x+uIF+5aggNSStQPgdPUI0FMLJkU6JJxZNzap4SHlTNRoq7/WzY5iIbtA2lF3PgZbK8NjvYnU4bmRBbcd/TBFirZqnyvMZUlZ4ITt9SR8bhRNkJli+j18xAWPdHBtAj+0k2eQupWvwE/7eIRM8RGewa8Z6nEVrUuJjLzy/04OWxF+HLW8FVp5E0LzU8dNdfkiuDLbY9+MiHQqZNy32SS0G0lQlVApmTnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(cc Kiryl)

On Tue, Sep 22, 2026 at 01:40:51PM +0200, David Hildenbrand (Arm) wrote:
> On 9/19/26 02:46, Donggeun Yoo wrote:
> > UFFDIO_MOVE on a swapped-out page installs the source PTE at the
> > destination unchanged, so a uffd bit set on the source lands in a
> > destination VMA that was never registered for write protection.  It is
> > then permanent: the bit is dropped only by change_protection() under
> > MM_CP_UFFD_{WP,RWP}_RESOLVE, which uffd_wp_range(), mrwprotect_range()
> > and userfaultfd_clear_vma() issue only for a VMA registered in that
> > mode.  pagemap reports the page as uffd-tracked, and MADV_COLLAPSE
> > refuses the range while the bit is set, because collapse_scan_pmd() is
> > strict about uffd on swap entries.
> > 
> > move_present_ptes() and move_zeropage_pte() build the destination PTE
> > from dst_vma->vm_page_prot and arm RWP only when dst_vma asks for it, so
> > the destination's own registration decides the result.  move_swap_pte()
> > copies the source PTE instead and only ever sets the bit, never clears
> > it, so one UFFDIO_MOVE behaves differently depending on whether the page
> > happened to be resident.
> > 
> > Clear the uffd bit on the moved swap entry unless the destination is
> > RWP-registered, as copy_nonpresent_pte() does where it installs a PTE
> > into a destination that may not be armed.  A WP-registered destination
> > stops inheriting the bit as well, which is already what it gets when the
> > moved page is resident.
> > 
> > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> > ---
> >  mm/userfaultfd.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 74f04c323c50..6495666c596b 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1452,6 +1452,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
> >  	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
> >  	if (userfaultfd_rwp(dst_vma))
> >  		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
> > +	else
> > +		orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
> >  	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
> >  	double_pt_unlock(dst_ptl, src_ptl);
> >  
> 
> In move_present_ptes() we don't run into that issue as we create a new PTE from
> scratch
> 
> 	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
> 
> 
> Staring at the
> 
> 	if (userfaultfd_rwp(dst_vma))
> 
> I do wonder why we don't have to take similar care about wp ... I'm sure the is
> a good reason.
> 
> Code change itself LGTM.
> 
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

