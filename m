Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D557FC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C566B018D; Tue, 18 Aug 2026 14:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CEE6B018E; Tue, 18 Aug 2026 14:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5516B018F; Tue, 18 Aug 2026 14:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93E4B6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:30:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DDEC140145
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:30:47 +0000 (UTC)
X-FDA: 85115231334.01.57A8804
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 70D191A000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:30:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O8374aHW;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787077845;
	b=jIHvO+WWVZiyj80lqK7mQogsBz1G5Ff3jGS/GNcwWo0g6UY5yvUJ4AtBOBJ702HXwG/3/g
	v5KU9IAVHtnxXgflKKzXaAKj2kY4uga23nfWOMxDuQEo0yFmupdE8sFP29n5UFKjrAhQ1g
	6ma0XL0fEA+d1VhpgiRAisNNJoxFECM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O8374aHW;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787077845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSXj30Cc4bmvN5zj0El/x/FOhUHkxKr00UzqKxKBUTI=;
	b=ENweUPEsvaNSsOt1+w3Snam1zzvP+qqLupALwLvfP/Grk5T1+7KCkwBv4qBhie7dFDaiD2
	hwsoredZOCMqyc0qZmM+L2OKe5qOUEsNG8G2T5zaKyA47zy8nB5gLrHPZAVODPsjla5fCp
	Jj5flKQy0w93wOpi3chv2S+fQDmYgGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 970AD409FE;
	Tue, 18 Aug 2026 18:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18681F000E9;
	Tue, 18 Aug 2026 18:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077844;
	bh=eSXj30Cc4bmvN5zj0El/x/FOhUHkxKr00UzqKxKBUTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O8374aHWwEIpB8vv/xQ0m1FNeDAEKwlQw84Lo7RO26aHb7Xkv6sMyt0AFUrdVi4Rm
	 tO4QoAB/9x/IVsbdh9XhzSMFY/ByTQVzQ4PT8NIsRKLbzSYvB0bSFN3IzDaoQjuW5X
	 YmpRYejAZqxKJJZWMnu9Jphxjj7+/bJDgmdLuGXRdBFy6z39EM6+6zZvVSsDawJIdl
	 5/O+1Km9e9sfPWZk05mSKMRXq/kKgMZ4lDeruxxyKAfuYsbicybncvqifQkYmvguYm
	 8vEhpn5b//iiuT/v19he/sjcqBpQLJAtEm3lEZmpkutCo2hwIs0XIMiKaVDzwrAvg7
	 Kpy89eo19Y2zg==
Date: Tue, 18 Aug 2026 19:30:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kas@kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 01/57] mm: add pte_folio()
Message-ID: <aoSj1bxg8zR_grwQ@gremlin>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-2-kirill@shutemov.name>
 <7e40cdfe-67d2-4ddf-a048-f33b2d590371@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e40cdfe-67d2-4ddf-a048-f33b2d590371@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 70D191A000D
X-Stat-Signature: f8tfre99hp4783iiiitzecmt3pe8mzx5
X-HE-Tag: 1787077845-256157
X-HE-Meta: U2FsdGVkX1+3AzxhKHUtVI1JSUdTGg5Y5hnibVwkyk2A+V2Ter4EQmcaWZ/kW3FOSsQZYQWqwLw4UH/SM+2Sg7Z4ohmUn6F5TDisDalGhIFYCUjDXYZKtq+gJo4dUuBOsfURxOxGzW4r98q+SiYbP/HbiIx0q4nPF6YgZRBfD4LqGbfTUegOYJphsXxYI+C6XqLyiA3NaNs5+H7MYdI0x4K47hs6nPyHbzIeztSNZeq5y/YDYadmEZ1QdVztEvFEY8JNH24JcoepNaQ3hhzSVuMMNHc6XQH3gX4Ilbx0s+jUeuRHYYBDoCyZoVHneMfxNBTa7SxMKUsEGbnYVhctwmg2S/m6/ijgvvKUOzllgiRrNUc+j+17SKBOp1TV5YgHh8yKPSNn9FPoSKpGpc8rEAhUsTsv348DTK55VVTVx91XaDROmfpjex4JJ3v+N6sjipUAARKjzMhdHynOAw9UmShZ8Il6uyhfL4n74zXN/vlf6rXQDU6Y1KFtbRmiqL0aIaM/6Ut9JDHVbZx3iXtN4riM0Oe1EUQMZlJLb/HsJyypt9rtzz4EavAWk0ERVS3+wFg/avx5CNwQH3JD2rohqL6m2aAKhvr6XT88gU4cXvX4ZtqaYJykXKmUGJk4JZVXPxs4J0bwxoYGeFzxStqAmc4tq3xHztWHv0vvVcByjPNdp9SGZ3JRFmtbJhJyo3nmo6FZomDn3chqdBnJ6ZM7AxgXEi4TzF9+4v1CDlQ5bb+AzoZsEOfRgFFUG4JsiF0NIjJ4pFJqBL0IMtpELBvMMb3GVJ5/UQfEW0cmmOA3oWlqSSUIjzGmm3hRfuj+yI5R6A/nKO4vHefrfnnHReHiMgwStfl5r+t3TqFu28ns6+rGzvgfw8UXrQ5Se3dITYdGzCFXoUjOmJzPPBsdNo2SmeDMQXAnIiof/nSh5AqnsRtr5LeiGXYJOJvUva81mmV6plJkKz6s8UB93IyarD3
 lMUiRG64
 KeRe4O5Rv+61i1n8a8nC2dtEyCOt1vd1HTSjkNCOiwXZEDuJ+yA+9FHNJYJxMLgmDtjDw1QpACi68EOeP7nXYY1iyhuWXW4rMb/zY4i9gHRjizTTM5fRjn20Ydd7LHAEogywHVCChFm96OMOOhmpPVgferHHrkUX9DkCh3L+h3JEnYs7uEMg5UW5Z5HM66NzLDOAQKW521elJ3ZBRZ1gq1CkaH2KD8sbzZNltik5qVhpcw0k8IHa4Bik0mc6YFMSPBIUNn9diCUvrJwMVFMkALsbrrBCujKuhec5kMi7bmXSWLFdlJtSOMuXJvGLYT4PaVyEa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 07:09:48PM +0200, David Hildenbrand (Arm) wrote:
> On 8/17/26 00:45, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > Callers that want the folio behind a present PTE spell it out as
> > page_folio(pte_page(pte)).
> >
> > Add pte_folio() as the folio companion to pte_page(), and convert the
> > callers in fs/proc/task_mmu.c and mm/hugetlb.c.
> >
> > Preparation for the anonymous collapse engine, which reads the folio
> > behind a PTE in several places.
>
> [...]
>
> >
> > +/**
> > + * pte_folio - Return the folio mapped by a present PTE.
> > + * @pte: A present page table entry.
> > + *
> > + * The folio companion to pte_page(); only meaningful for a present PTE
> > + * that maps a struct-page-backed folio.
> > + *
> > + * Return: The folio containing the page @pte maps.
> > + */
> > +static inline struct folio *pte_folio(pte_t pte)
> > +{
> > +	return page_folio(pte_page(pte));
> > +}
>
> There is a reason why most code doesn't need that: because they should be using
> vm_normal_page() / vm_normal_folio(), or need the exact page and handle special
> ptes differently (see gup.c that uses pte_page()).
>
> And other code that uses pte_page() doesn't really operate on folios AFAIKs.
>
> That's also why you are only touching hugetlb code here.
>
> IOW, there must be a pretty good reason for us to add a non-hugetlb helper when
> that looks like a good fit for common code when it's really only hugetlb that
> does weird things (and doesn't need the exact page!).
>
> If we really *need* this helper, we should spell out clearly that it is very
> likely the wrong thing to use outside hugetlb code.

I'm also a bit concerned about softleaves here. Kinda implying every pte
has a folio is problematic in general especially if there is nothing
guarding against that being used incorrectly.

pte_page() is more of an low-level arch-helper it seems to me (let's go
look up a PFN from the vmemmap modulo arch stuff around the pte).

So yeah I'm a little iffy about it too! :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

