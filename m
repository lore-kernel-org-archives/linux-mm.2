Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B64F3D262BF
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A4F6B017E; Thu, 22 Jan 2026 07:48:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128CA6B0180; Thu, 22 Jan 2026 07:48:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000586B0181; Thu, 22 Jan 2026 07:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4FE76B017E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:48:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79AD7160283
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:48:30 +0000 (UTC)
X-FDA: 84359578380.23.986506C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6F8E8A0003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:48:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hwig5yiG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFvEYO1Y6ScpqGsO+ETZq7M/vyfIjPfoUktbOxzoWJk=;
	b=Ro9Pri5UOWueTeVsvH4T2Atjt9SqLnSYz9ggRQ+IPtQwTYa5W/pmePEeMSzMfEh0D6iYKE
	5zl15lbAFgkbZ+eFgOe/IlKmHrlR9DVLMF8coLst7j+mxMHlZD71cvAaT11DORHO6iTKnf
	YwK1/dPXxIBHGItO8+IE6/v8w/kbQcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769086108; a=rsa-sha256;
	cv=none;
	b=My0BFCzZTRppVBa6fAhgAuWRaQ1xdbhDcyYBVXGXb1OE76XqzKMJARiWlaTEdyWbxxTzKu
	+Ry5GnwbKrB0phSqFYjVWz/2ye3Jq7QfljYvscdqa0tKftTkrFa6bcW9NUlwjvMfWn6I97
	cmVc0RBQuZLXNB6DhALYiswdV/Hg0Cw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hwig5yiG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B137436B4;
	Thu, 22 Jan 2026 12:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99159C116D0;
	Thu, 22 Jan 2026 12:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769086107;
	bh=XakBjuBXojiy+bHqbnq0M9HVpyzFj/6SSmtXTz/8WSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hwig5yiGmNbF3J8rJf4aQHvL1/VhfY9YyNF1noSCKpZ/pOhmhddne9G2/Lo8nVNN/
	 oVxxYWZMVVK+E97wikNkZPIbA6pz0Hb6AHB6iTOxQF1NhgHNut4c1Woh/QC/iiwGC0
	 B1RC2M+doPnowNPdiYsr7AAYMKIf5sUctl4/w3ZDStOi38KfD+PJ6KkcFFkL3R5+pZ
	 BV5P7N7FlH08HUS/u2NhXQfBcl8f0zz6+5k3tPBKU0N9VcYGzcMZTlETk1ojAW7voO
	 KKf9ifSFoKK+kjqgbrqp0YaEbQXuqyWvHvpe62uH/N2l1rk7muuS/wIaDnbZ99UWrC
	 1HML6ZmeEHEpA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id BCC57F40068;
	Thu, 22 Jan 2026 07:48:25 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 22 Jan 2026 07:48:25 -0500
X-ME-Sender: <xms:mRxyaf07nYM300m4gkNaHVnaCjPgEtFG54FV7TczcMF-cpLZNeAefg>
    <xme:mRxyaZf3Uh_Lg9hXAHRx9Iel3o11mcfhTLTMfHzPtYr3TJt-HskShKWJrxy4Rf-sm
    dlAeXtq4mLb4v4tNgUG3vVSPxq9Yg-OQPTuXC_e8djrn3VwW-qyKDPJ>
X-ME-Received: <xmr:mRxyaZQbqj6i1HzbnPIkL5N9JFggpUV3BLFbIrKjAvQjxiHukFUCWlXJl78LRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeivddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhnghes
    lhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepuhhs
    rghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepfhhvughlsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:mRxyacn9D7tHxO73dCr2PVDNBWZ_3BLr64tZA5QcxHz95v6v_ixPpw>
    <xmx:mRxyadqPxkwzYfYU1oW30JieKjzGKsLbX2h47WA5BA-eaDKycsVn_g>
    <xmx:mRxyacZFJl10uQZTwAGdk4Q2Aq7cYMSsUKEKoj_eS7XmjLUkmWSoCw>
    <xmx:mRxyaZxjpdon9XMRbJpji66w0Ew4gdcXgBVa8klsNKcQUJrk50xCtQ>
    <xmx:mRxyaRjsHZ97UOc1TLQZdQCca8gXkbDB_uuRCitETwpj-f8D15DbUN0z>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jan 2026 07:48:25 -0500 (EST)
Date: Thu, 22 Jan 2026 12:48:24 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 10/14] mm: Drop fake head checks
Message-ID: <aXIblgtZ-b9SCp7O@thinkstation>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-11-kas@kernel.org>
 <28A56ACE-55E9-48A9-9EB6-696695ABB254@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28A56ACE-55E9-48A9-9EB6-696695ABB254@nvidia.com>
X-Rspamd-Queue-Id: 6F8E8A0003
X-Stat-Signature: zjftd66kbpimjid61wpa3z3ormiha5ag
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769086108-337890
X-HE-Meta: U2FsdGVkX1/WLsC/mQ5W7MIwPxxNlNpwAaA93jfLN87w5bKxdoOIfdAURD5w3JVmS+/mgcw7EZv4jTfF+LhGqk030uW6suPKA4DYUpL5eAd10EC/iw85nO1ldcc238HH46E5MdmQ+fiQALZAk1qzOH8tAIa9EFADEINkLeY+7r2rh6i8eu50ccxQ5riF05KriGFIGwIsSti2U2aLhtjp8CFphKkxv6c5Kg+V5H+pTpWaQeFKC7fExnfZGt+wsuIKkQF9AfYuAVDO5fy7bzJso9XwJ8fijN2REuGxrlDkXjQrl47ni0+O6XKEOJGtIq/khsuYK+g0NlBbtihrOvbGPOvih5dntP73yOCr46IE7a86s3bTCtfEFzH0ZVbzjlu06zCDHdOAPR9q9AWVAI9qIi0RDoJZvImkqMR0PMutRWmVBFIW1JBoTOY03x7LVBb7mY6dGDmWpUTHmLtFMdMvx+gY838VqYe/5Khubz7E4HNT0z1P1zMFKgAmD0kdQFdbJz0/N02CUe0k2sNWW3D77ZFOUJZmFBVjRDIr5jp+htRwkEfqLc+97GKnsTkoVaxoTUKKDwtfmhUhlnYp3VCWnWpp9P9t0rWS51t7QfMjqtirH0l85vr0cA7FCcBAKPA02nYpTbTuToRNEuCaKFm+Xwr6xi4dc4Iw9+3onpNnfz58eqmhiotHN4bUEdzxQTJa7Df2VNuLFszW0Zs3ZZnAuian3knD/ug8CEFCt7WvopmzG46w9Y9s0CG8ycrnrxugyNPpu4wi0gh3fNpCZC2uSIG7q23TqhpYD17kFtrRgnxRZWwh3sXCA0r6Xyi7xtjhZ7LYGb0Vngq80MS0W2CvvRtyVbZ7qbELI5cDqBrFAkFxziq8J869dYpT+EY/SyYo2BDaqGWylSoxLFuXaZm2ehBKPLL8Unhnx1d8MJhi8sf+xSsE4ZqBrsQN2QK/ZEMVVWvl/IgSvWblbV6ROjX
 /bwi+fQg
 nKFZMYr28XcPqOG1eiRtMYqvkn0bYpoDh4mucGw5PO/7Timx/tz60S7KBIXVQ15VxtGzZUQMg+WOH+Iyd7sMVsT6LvGzZR+LeQaAiD3ttj5FwoJzhzTFW/pFOnCNOCMb1KVSDd/EV8dHHVPM8JYB+DOFXhzOltDlvP1L6oZNkqGlj0dL0EkHHuSLOpXX26tMpOirli/d6E7LWcVnQ1Rb42CMmndglBYMznFsF5ZkBCCRx0dd/onY9L681cRYFNzIOEf6jmZQmDQoTdyhrDOhU0iYGW5FcrFMrPhnB4qGcinjdMR8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 01:16:23PM -0500, Zi Yan wrote:
> On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:
> 
> > With fake head pages eliminated in the previous commit, remove the
> > supporting infrastructure:
> >
> >   - page_fixed_fake_head(): no longer needed to detect fake heads;
> >   - page_is_fake_head(): no longer needed;
> >   - page_count_writable(): no longer needed for RCU protection;
> >   - RCU read_lock in page_ref_add_unless(): no longer needed;
> >
> > This substantially simplifies compound_head() and page_ref_add_unless(),
> > removing both branches and RCU overhead from these hot paths.
> >
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Reviewed-by: Muchun Song <muchun.song@linux.dev>
> > ---
> >  include/linux/page-flags.h | 93 ++------------------------------------
> >  include/linux/page_ref.h   |  8 +---
> >  2 files changed, 4 insertions(+), 97 deletions(-)
> >
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index e16a4bc82856..660f9154a211 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -221,102 +221,15 @@ static __always_inline bool compound_info_has_mask(void)
> >  	return is_power_of_2(sizeof(struct page));
> >  }
> >
> > -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> >  DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
> >
> > -/*
> > - * Return the real head page struct iff the @page is a fake head page, otherwise
> > - * return the @page itself. See Documentation/mm/vmemmap_dedup.rst.
> > - */
> > -static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
> > -{
> > -	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
> > -		return page;
> > -
> > -	/* Fake heads only exists if compound_info_has_mask() is true */
> > -	if (!compound_info_has_mask())
> > -		return page;
> > -
> > -	/*
> > -	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
> > -	 * struct page. The alignment check aims to avoid access the fields (
> > -	 * e.g. compound_info) of the @page[1]. It can avoid touch a (possibly)
> > -	 * cold cacheline in some cases.
> > -	 */
> > -	if (IS_ALIGNED((unsigned long)page, PAGE_SIZE) &&
> > -	    test_bit(PG_head, &page->flags.f)) {
> > -		/*
> > -		 * We can safely access the field of the @page[1] with PG_head
> > -		 * because the @page is a compound page composed with at least
> > -		 * two contiguous pages.
> > -		 */
> > -		unsigned long info = READ_ONCE(page[1].compound_info);
> > -
> > -		/* See set_compound_head() */
> > -		if (likely(info & 1)) {
> > -			unsigned long p = (unsigned long)page;
> > -
> > -			return (const struct page *)(p & info);
> > -		}
> > -	}
> > -	return page;
> > -}
> > -
> 
> <snip>
> 
> >  static __always_inline unsigned long _compound_head(const struct page *page)
> >  {
> >  	unsigned long info = READ_ONCE(page->compound_info);
> >
> >  	/* Bit 0 encodes PageTail() */
> >  	if (!(info & 1))
> > -		return (unsigned long)page_fixed_fake_head(page);
> > +		return (unsigned long)page;
> 
> Is this right? Assuming 64B struct page and 4KB page size, thus 64 struct pages
> in a page, the 64th struct page (0-indexed) is mapped to the head page and
> has !(info & 1). But _compound_head() should return page & info here.
> Am I missing something? Thanks.

The point of removing fake heads is the we don't have head aliases
anymore. 64-th struct page will be a tail page that. No special
treatment is required.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

