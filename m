Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38113C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A7F6B0541; Thu, 13 Aug 2026 12:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231E16B0543; Thu, 13 Aug 2026 12:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149436B0544; Thu, 13 Aug 2026 12:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E38566B0541
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 773241C0886
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:18:08 +0000 (UTC)
X-FDA: 85096753056.10.FB68498
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1182D1C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:18:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MK0lkLk3;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786637886;
	b=Qpro2wO46lQ8hoymTkNM+90MVZGXpHdTpTAq+7yN/dPf4hdSapDBdw9LWimo5WfJxekTx0
	+sw1s0RD3XNF+X9qDU3MAs9RF9WeRz2cPcCGGITK1x6iwfnX7H1zCTL1Vlk5WiasZKdeE1
	e3YJA47L56qJ+LIgJV35/TAe5qmL3rI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MK0lkLk3;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786637886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBKBRWns2I2cZRLW3DKc1q9hrHpjdI3rex/KjtzmnSk=;
	b=BknhatX9W6N6PhBL0x2CKIXMFWYthAjH6TS3nNnhNxwwl5AJzSTiP0AXkSuiw1BTqWeEBf
	csx3DQXIMuREXWuDpA8a3C4NZvNUzyyvaranzispKkVq+dFnmFNj3mC7MyU6UAe8vIg8lq
	dKCP7dpDeXdNvYdpOUMfKqr/akid6TQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QBKBRWns2I2cZRLW3DKc1q9hrHpjdI3rex/KjtzmnSk=; b=MK0lkLk3mBVXCwQ4Kr6pnmLA+3
	m4ku36pLiZN19oIORavpXHrZw6RCPNUUdFfzU13itqoeelQX0FrD96mvJ3LBSss+wirjoah6O0ldp
	lbuBgDMRBiX09yjj+K+b7d6KaoEzXQTxFN0Z8ylK4vf9Pxv02o0VLtACgSQI4crpeU2n93xFLjCiw
	wReKD8SXfSevlwzRFHpShAzQCA2J2HbAtW6IxswHrLuplWN9ZriPrCqOuurKM18efU6zz1mzc1r7o
	NkII4tY9Y7kNehs4HD1Ov/pzaqfzSiXerGszA8TMzUjD5IPiPL/BDi/vgM7XT+5f/3vqaLJnOu/vV
	z1kmv3Ag==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuY80-00000003qNm-0YWE;
	Thu, 13 Aug 2026 16:18:00 +0000
Date: Thu, 13 Aug 2026 17:17:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <an3uN4TAAZ2miXhe@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
 <a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1182D1C0002
X-Stat-Signature: mphuo65weyk8u41m47bxj6xgmz9dbr5w
X-HE-Tag: 1786637885-764541
X-HE-Meta: U2FsdGVkX18pHgR+bGYCCFZBCc7npdERKaHJcmjz6txy2Oo/gT5Af5o/XJz8X7rYrh8VRx86VZYTuDIy0r6NDmIdePqct07xmtXK4FlGYO032OOLKDg4TwOIaVI4c68gyutNdVyEEDlhh4tsTPEhOpuQ1r8RTAggpKIEZB9XHm8GctNhjP4/H06ovxqBDDRHXkdAI+KRNpWe9p4muGwm6JLhwGGVq8KaEQetsffcd6hzTHqibL4QkX0xAn227pMdw2JM28QQkUfypNlW9rXxo3/pFT3WuBWozrjOScloIL+Ccnfv1cQdkMkyDl79gXp6WmWV054EYExe21Ix5eywO5ZaqVKtjWx1aX0Vu92nhP0Apxr3LCVYNsOHQIu7kH7cYGo0/B38b/tAgFXyl88Edjy5007dhwJEi+ytMCIw3L/5OQILhIBgJfWXmrVK1WpGnVDAdomaU6HuPqJlNNni7UEC7yQN1/MejN75YZq/NzXFdXCy+JgRqBwMT4Tk1O8e3+crukVsdwhFOHHTEovTQ9XZrRn8r32H+KqEujE3viOIRvXDtv1diuz9pc5zExl2Homnd5nvQffcPzyKvXMkMrPoSzxe2LK89so9rzDmlNjM7RlSQv1Flf3j42+Pz3wm069XkDnvazhxSbYki23vix1+sz6663Jao84i1+CSlXnJgsP74VDv/lZMrq9E+SSgtx0Uy3i/G6CxYy2GIIs89cI7IppQzH0LVMD1NI6pa/vbPkG9H1c1AP6bTDU5LRNL7jcHkuO8X3pg9jIIoAD6f2WHmWPalFLualLUKKq+oz7hi5CExkLr+Fa1/7ozYU0Tv3XIH2zoyVhKJ6UhZzOt45ZAyKy9hGoSD4RZdzrxQ5Y6vB9fRdASSBqUFQSgBesQG4HVj446YJOR/yHH46BvrOlR4RhGxFmBAHwK9TPrPyRnhKHyoVZoBqqkB5kozogY0/US2xH1KAt3Ri872/t
 minnFG1v
 Qyzdg3plhZcGQUkOUnh2ejKeyIv92mNXN5bNELCLW7Pi8T9B23HBNuT/NiYJmXCqzqct4v69Dkn3DLT77GHgEiSYN6dS331rvVCRXl7hPvOpnnyDmFL01zrEfDazTnr3qTZKwoefw538/BzmjGtAK23d8CYBfHGcVkF/VRMgKz4krurmuIeUYyOTP6moS9WApxsfDQaolpXKeiwJmZZLIpSNnSEoyCigVHgWdmeXVTypl1Ei07rA6QWhtkDvizl35+Wkf2J0lSkhwsFJGmTXW1y4CUBM+57N22JisofKfNXHzQ18HFU81tzX/UjBFfpoBZ7inKqwekncm8sXBEf3jmQRQjzCilp81CLW98dVIsBwjhihA1QRlBhEDcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 10:29:20AM +0200, David Hildenbrand (Arm) wrote:
> On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> > Other large folios use the has_hwpoisoned flag.  Convert hugetlb to match.
> > This will help us use the per-page hwpoison flag in the future.
> 
> Currently, the first thing we do in hugetlb_update_hwpoison() is:
> 
> 	int ret = folio_test_set_hwpoison(folio);
> 
> So a hugetlb folio *always* has folio_test_hwpoison() set.
> 
> So we can locklessly check whether a hugetlb folios has the flag set simply by
> ... checking whether it's a hugetlb folio and has the flag set.

You make it sound so easy ;-)

If we don't hold a reference on the folio, then the folio (whether it's
hugetlb or not) can be split.  And then folio_test_hwpoison() can hit
the assertion that it's now a tail page.

> Then you write:
> 
> "This closes a gap where a page in a previously-poisoned hugetlb folio
> could be observed to not have the hwpoison bit set."
> 
> When does the race you describe become relevant? When freeing the hugetlb folio
> or when demoting it? in both cases, we should be holding the hugetlb lock that
> nasty hwpoison code could sync with (if it doesn't already do that).

Before this patch series, we don't always hold the hugetlb lock when
splitting a hugetlb folio that contains hwpoison.  And we don't want
to have to grab the hugetlb lock if we can avoid it -- unprivileged
userspace can hammer these paths hard, and I don't want to see this
lock be contended.

> I can understand that we want something that covers both scenarios: an
> indication whether any large folio has any hwpoisoned page. Such a unification
> would be good.

Right, and after this patch, we now have that.  Any unknowing part of
the kernel can test folio_has_hwpoisoned_page() (assuming it has a
refcount on the folio).

> But then, special-casing hugetlb *again* through folio_test_huge_poison(),
> that's rather odd, no?

Oh, I'm not happy about it.  But we need an atomic way to determine if
a page belongs to a hugetlb folio with hwpoison detected.  Short of a
complete rearchitecture of how we handle hwpoison, this is the best I've
come up with.

> (what on earth is "huge_poison" is this supposed to be "hugetlb_poison" ? Why
> "poison" and not "hwpoison"? Really odd)

We're inconsistent in our naming on both of these things.  It doesn't
help that somebody decided to reuse the term "poison" to mean
"uninitialised struct page".

> I'd expect that we actually get rid of folio_test_hwpoison entirely and
> exclusively work on per-page state and has_hwpoison. But IIUC, now it's some
> mixture of folio checks, page checks, folio_has, mixed with some hugetlb oddity.

If we could get rid of HVO, we could do it entirely on struct page.
Or, as above, entirely rearchitecture hwpoison handling to not be based
around pages or folios any more.

> I am not quite clear whether the change you propose here is actually required
> for the remainder of this series?
> 
> 	[PATCH v9 00/15] Use generic_file_read_iter() in hugetlbfs
> 
> IOW, do we really need all this hugetlb hwpoison handling just to accomplish
> that, or could some of that (bigger hwpoison rework) be done separately?

Blame Sashiko!  I'm going to ignore it in future, but it's really good
at nerd-sniping "hey all of this is already broken and you could fix it
as part of this series".

> 
> > +/*
> > + * Since we cannot split a hugetlb folio, we want to insert a poison
> > + * entry into the page table for the whole folio even if only one page
> > + * is poisoned.  Otherwise, we've split down to the PTE level and we only
> > + * want to poison the precise page
> > + */
> > +static bool ttu_create_hwpoison(const struct folio *folio,
> > +		const struct page *page, enum ttu_flags flags)
> > +{
> > +	if (!(flags & TTU_HWPOISON))
> > +		return false;
> 
> Why not keep the flag in the caller? Really looks weird given that we have two
> users and one of them doesn't even need the check and must fake it.

try_to_unmap_one() is already 200 lines and contains some tricky code flow.
I'm trying to at least make the problem not-worse.  I think we should
pull out even more code into helpers, but not in this patch series.

> I also don't quite enjoy the function name, and it's likely the reason why we
> need 4 lines of doc for a simple internal helper that checks whether the thing
> (page table entry) we are unmapping/migarting is hwpoisoned. This function is
> not involved at all in any kind of splitting.

I think I was trying to pull out even more code into this function,
which was when I named it, and then I found it tricky to do so.  And
I didn't go back and change the function name.

> Some of that code is getting reworked by Dev to better separate out all the
> hugetlb oddities. At least for the try_to_unmap() path that helper will not be
> required. Staring at the abomination we call try_to_migrate_one(), I assume
> we'll do something similar.
> 
> I'd just call this "ttu_page_is_hwpoisoned()", and add a short
> 
> /*
>  * hugetlb folios are always entirely mapped, so any
>  * hwpoisoned page is problematic.
>  */

I can rename it, no problem.  I think the more verbose description is
justified though; we need to explain why we care about any page in
the folio for hugetlb, but only about the precise page for non-hugetlb.

> > @@ -2423,7 +2436,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> >  	struct mmu_notifier_range range;
> >  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
> >  	unsigned long pfn;
> > -	unsigned long hsz = 0;
> 
> While these size changes are reasonable, they make this patch harder to review
> and are not even described in the patch desription.

I suppose.  Do you want me to take them out?

