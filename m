Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138E9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 17:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50F16B009F; Tue,  7 Jul 2026 13:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02316B00A0; Tue,  7 Jul 2026 13:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0BD6B00A1; Tue,  7 Jul 2026 13:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94FF76B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:05:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C1221404CC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:05:39 +0000 (UTC)
X-FDA: 84962607198.29.2ED0AD8
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf15.hostedemail.com (Postfix) with ESMTP id 03BE2A000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:05:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="U utIYnk";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ns2IwfsX;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783443937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh7IO6rJY00utCxWkBxZI6oDTG8b9OIvf3pFDe9X22o=;
	b=zfkMNrSB5+7h9Px+fFlwbK51jl5qP/l7C7wYvZvMnCEFW0zQ9SbeFZUe9EuEbR0D/6a/ED
	RVpbeDGj3/kwe0mIgT45l2P457qfKlSR4/Fs+/3RkTwzRziXuRqp7ALgAEVzkdfV4LaoYm
	fePCYrghL8yKJGPGgZwOTXCK8OnyYPA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="U utIYnk";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ns2IwfsX;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783443937;
	b=0sbZkz4n0kvOtpprmgcMV1rfaClH54NvTXxIuBRQ3VQ0/SwuIHCR2D83QlDaIjI2De0vbV
	Qagoy/l8Gwi9ghf1Dsj+e7RJMHwkXcTGpFyMSP7WB01A3YmUL66BK8t1QVAB+QJW8VJ1bc
	J4m8bRq35yliY9D/vT+jGM0JwdY4EBQ=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 6695CEC0182;
	Tue,  7 Jul 2026 13:05:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 07 Jul 2026 13:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783443936; x=
	1783530336; bh=dh7IO6rJY00utCxWkBxZI6oDTG8b9OIvf3pFDe9X22o=; b=U
	utIYnkMUqBeYJ/0pyMM0v6Way1XFBWXpEjI81ZdzIq5ksYmwg4RHuZ8eOJL2s34z
	OXkIFtRPAWLdEO1hSRe2FG22YJPcUwDOmzh09uDJomBczCh9syMqywqBC+U5FCzu
	cEfZAtuBBjBgn6RLyJbKIPQGg2FH2wgzX84j311KZXySDde7hN70rHMihzJKrydO
	cdRlxnpIk4SdNZ38HHgISZSWNy/+ZPnuQa1Nj8HEeJEAIuX64Qw1cstKbgVo9I6H
	Iyw6Uox3gLirGjv7Sw6bt4A7FnMltngZCkv7GW7Q/gRjsXPfkdRAT3Dv+tBJhinF
	z9Ygngv7guvRkT+kiG6Yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783443936; x=1783530336; bh=dh7IO6rJY00utCxWkBxZI6oDTG8b9OIvf3p
	FDe9X22o=; b=ns2IwfsX+9pdi/X/uLuQhb7ryjY81q6v/qiNCTwO8lVsZj9qdvz
	icz+xzZViEdPkNAZtSPkR47iq3enMRFVz1nH7qwAtWyuSmEucQg87z/SuznyFwvm
	A1B0O4NVaOoc3bu7//Gbq9sMn8tYB9NK5u4fKpKcMITZgM3l42a4iwD7kEHlPuLg
	uL1CbIAE4ODoDLQQd5ilBc4kcEmnlfe9t8QvLCGMziEOGUv7sOA4MMP/6POuBNzt
	SOr3/K31Ofth6dKdZPRkJnl4Fz1+RG8Tn+vmyqcVEWpmxU6HxUaRsT4ayPeVEcIU
	dpNrBOd28gJBcIV3abSTNfFkQWqayK1JoPw==
X-ME-Sender: <xms:4DFNalCMtnaJ2xvShANHrYSwsnRSzkIUSVtZeTdFoROzmQs5JcJfOw>
    <xme:4DFNapC9KJJaGbQA2y4Ylg4fwt6EG2QUzK3z9TZ3Jn_bMIDn8GLLzWpTzXvzz69QX
    sFM5jsYbQP5RuJ60i26RRFHiMsmTbHXwVlhKqdiUz-jykWy671b2-M>
X-ME-Received: <xmr:4DFNao6tgthKXOngEKjQz1p1WhefLAzCojHVICjUlzzHS8w3JUKKi0jowdvZPQ>
X-ME-Proxy-Cause: dmFkZTEGSpDUWObu6TWZb4QSLM1eEyRYKmhxlPRhOVqLounqixVImzwTqjRlbYuMfaogN+
    kROBczESMsWnH4+pws8Be4hW1tms7ZIMwCL3biCzS7w1TMvCKK+7GkzosUFvTVFFeXhd6d
    9mj/UlpKJJBJVMg9txZEn/uZucdLzc4ZZQ7WX9/IPzzelQLXmpzFBLwD+Ly3X8HRedtMa1
    nJruo/mjZTWThclPzchFJES8rU61UDQVpSNAFlL8+yRw+bJwv0H3005uKjFu0WIo1N0gmS
    Nf+88WySWFa2gIPgyREiexDBebKGgn4bO2dEjrkVW8CIKxmsEBIxV6OZwl8EOv8xYJoHe+
    oZoZU2mFjTazV8VTLW0duM6T+OukXtF5MAxgUxiHPbipU2pxLQ/qmrsg2JHrjEIDql78/Y
    TcVRVgN05vhNHjGHvB/d5jG1pAV7kao3283/v2+mBIO4Lr7JtGLqmjRYInimNwjadLsKUA
    +a4TrMBSWPN5OXHtYU+cKRWsS7Uck3PgfsEeZGSc/db7A1dyMetUmS6ieRbgwLJtKGHhtY
    wXOERzFpHBrxz/ce/83WwD5glL6E3IHppgFCsn2WXRMvurjh2J3+43mc+I2pTzqtw1BSXj
    GK3OGSZ1hSnT1o4i71BdbvhvZ3vpOHEzwyR0NP6ewBOLYkMzqW4j33dCuolg
X-ME-Proxy: <xmx:4DFNat04MFZnoJnwSQA9W8XJD6Laj5ax7nN7sxLvDUNsc3sABfjmvQ>
    <xmx:4DFNasB6URuqjaIB0kV6PSVPJenfNXE6JEOHj3qajGRKnatQiS8uzQ>
    <xmx:4DFNalHNn5S4vvllsZGZL5CDoie9B8As5F3hbo-vxUDMTH4KQ9Bz8A>
    <xmx:4DFNahSPEHQj_yThMyj67bdlrr0Cw5FL5GWrVFqQ625I8CxqKMajUw>
    <xmx:4DFNaiFbh355b2orDABzMgFDo-gVttvz_Sipt0O1VkhvHox51pNoNBkx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jul 2026 13:05:35 -0400 (EDT)
Date: Tue, 7 Jul 2026 18:05:34 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, muchun.song@linux.dev, osalvador@suse.de, 
	peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/hugetlb: fix swap entry corruption when clearing
 uffd-wp at fork()
Message-ID: <ak0w7MB_wKJtBLNu@thinkstation>
References: <20260703161833.57416-1-kirill@shutemov.name>
 <678ecae4-cda7-4683-9012-ed7c5c5b879f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <678ecae4-cda7-4683-9012-ed7c5c5b879f@kernel.org>
X-Rspamd-Queue-Id: 03BE2A000E
X-Stat-Signature: pbjfgpgfbuc8d6a8qobjihqeorq11aeg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783443936-765294
X-HE-Meta: U2FsdGVkX18zy8lv+0RuFvUae/gd4UE7fSQ0ip7PAKzVtc5fmA0/Bx2xaL64RRtGFajcSDHOH5UJxxIM7vqvylLZJU1pjOtJvV2hFIjQyTyeV3ejyrbEi/aQry9YFZFFxINN4FiH8q27PRwhFXapW+QYMbsszoJMPR2VRJbBodXoxzZTxzBmCRPQYSjEzK2yZUxGMVssgvDtdU6vAj3b4bV4Pvq/kd0nAZ0Fj6Wp/fBoW+xDuN8oxh9kfi/cdt3qvcCiylHWlm0AtPqq+beOVQFTBHrnL5xJ0GLZ1MRRZXUeXHhULaP1wdpuRns+Ewywm+jRHpurb7q2z9byO/J4beljFC4SjMKMxqd1YCIUZdP9fS6rIxvw4hsrdimVcjq8yWPc2QeGWX1XU7nUQlSWxTLG35Xw6OdYawLk5fu4/pr41OW4uLln1//VgPxenPz967nrSi4ZyNeHnJ6Jfp3x8/oDc+/Mg0YEAdUPtPeSgP0qmkXxL4hRKe1o3t1sLi1MoreflZGxBKphUyWXD5LQM/MjWS6Rb3zufivxdcaxGBMTlvLR/hvPjcfiWVMkJynR0mp8gVztxpywhcgq7oePZN7pz2drPxqOXX3I9dkCBu+WxRsL8iNUu4DdAFFDnqCCr3N5iEJOIb7tzIYz/v696mhirHT7ZsASG32H1U1Wc2OmHcYwJ0C0ydvz7gNTRf4+IOdN4ad5wb1BRYRw4BLB9PR+upN++f/fr+Z35ft+j2Nw6osfujUZ5+xfM6D+3dSOeFzpXKWrJLe43d+K4xD5jqdemp3G9TMUI5z0wEDzayNZskp1yz1vExI3wEwEnJRgab1efoG1iEenF4jmQLlG6nWiR3dtY57f8RdMwPxVUaaO4r1cXoSrf+JWzrmP505ENWrc8uybRLNbJYasbs5pgyO3zPazzGVPKx7hIKcNBsuL2UxrwhX1u7kfHszc4V7iyyEfFDfj+CFpMjR5hno
 2xKFICgz
 bK0fNpv4S6BrdLe9cgPvFB8zkbsrHuWBvCCfviJ5OYM8t9UV0BzEtWaWmJUQ37dZxgYBFQcP2FjhS2vqKtFCBHMeik9Iz51ZxjzMRW1ogpUkzpDMahLLdPgG7vvBbuM9cxyGK26Zx4Ib7El0pPYCV2AyKj47Q3BvX3e0cGUF8DPdQ+ejwKbPVWFi3LzS0uLWhyObm3i0pgt0hUxii4+VRSp67w8Wk0KP2T8gKBDYCzmf8iMnCEbd8cfILx7yPt0HtJOf30+5tsoTcBHVoqokPF5E922TmtKlzaE4cF1/wqwM2WMw8/6xxScYc5hpQaVcoAnnwQEC58xcS77JJ5Vq19oWOku7OAw7TWhNt4tgfpRrI1KNsN/2vm5cGiW7o9OZ/bBzQRJ1yUV19b6Vi7gJueEO7txe5R1h6b4j/0ChgfKvMLYmPvDLM+ut4yZUx7TUxtfa+iI2pXrzlyFDzFGpMpuggXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 05:05:49PM +0200, David Hildenbrand (Arm) wrote:
> On 7/3/26 18:18, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > copy_hugetlb_page_range() clears the uffd-wp bit of hwpoison and
> > migration entries with huge_pte_clear_uffd_wp(), which operates on the
> > present-PTE bit position. Swap entries keep the uffd-wp state elsewhere
> > -- the same branches read and set it with pte_swp_uffd_wp() and
> > pte_swp_mkuffd_wp() -- and the present-PTE position falls into the swap
> > payload. On x86-64 it lands in the inverted swap offset, where a
> > naturally-aligned hugetlb PFN always has the affected bit set, so the
> > clear advances the encoded PFN by two pages.
> > 
> > No userfaultfd needs to be involved: the clear is guarded only by the
> > child VMA not being uffd-wp registered, so a plain fork() with an
> > in-flight hugetlb migration entry (or a poisoned hugetlb page) corrupts
> > the entry copied into the child. Instrumenting the hwpoison branch and
> > forking after MADV_HWPOISON on a 2MB anon hugetlb page shows:
> > 
> >   offset before=120e00
> >   offset after =120e02
> > 
> > The fallout is mostly latent: rmap walks match migration entries by
> > folio range and remove_migration_pte() rebuilds the PTE from the folio,
> > so a within-folio PFN skew heals once migration completes. But any path
> > that re-encodes the corrupted offset -- e.g. hugetlb_change_protection()
> > rewriting a writable migration entry via
> > make_readable_migration_entry(swp_offset(entry)) -- propagates it, and
> > an hwpoison entry misidentifies which page is poisoned.
> > 
> > Use pte_swp_clear_uffd_wp(), matching copy_nonpresent_pte() and
> > move_huge_pte().
> > 
> > Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/all/20260703140011.99E601F000E9@smtp.kernel.org/
> > Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-fable-5
> > ---
> >  mm/hugetlb.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 571212b80835..a4e6dd3a82f4 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -4918,7 +4918,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
> >  		softleaf = softleaf_from_pte(entry);
> >  		if (unlikely(softleaf_is_hwpoison(softleaf))) {
> >  			if (!userfaultfd_wp(dst_vma))
> > -				entry = huge_pte_clear_uffd_wp(entry);
> > +				entry = pte_swp_clear_uffd_wp(entry);
> 
> I think installing a hwpoison pte will actually drop the uffd marker.
> 
> hugetlb_change_protection() does nothing on hwpoison entrues.
> 
> So how could be possibly get a hwpoison entry with an uffd-wp bit set here?
> 
> If we indeed can't, Id assume there is nothing to clear here at all.

You are right.

I am inclined to remove it in a separate cleanup patch. Any objections?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

