Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AB8FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 14:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308E76B008C; Sat, 25 Apr 2026 10:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0946B0092; Sat, 25 Apr 2026 10:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D3C6B0093; Sat, 25 Apr 2026 10:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1000C6B008C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 10:57:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E6081C04A3
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:57:56 +0000 (UTC)
X-FDA: 84697382952.11.528F238
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A9DFA0002
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:57:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rEKeu3N0;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777129075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BT8q0DVs4qWRn3oOm4KcXx8o9fP0GCc6vrnmQnkq5YE=;
	b=NHijndBUINscraqvsq0NZxLYzxo8jlnou9GC27Hhhu91zlzlOVa3x86dsu1PKas/W1igVC
	fGrzqgHSpFUeWw9vNq7eO0aHrUdJPH9yLrJoK6ElcDcunHQCa/ya3CqlRkp75x4iPFjZ/j
	S63h+6ug1MJebNq0oLIRVgTsbSH/aNs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rEKeu3N0;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777129075; a=rsa-sha256;
	cv=none;
	b=Xu3i7Y1WeOFIrSB6aKUSrPmveAsOvSQQaJRv1f3vZzM/mNE49xQp3DVLBUvcJh95Hn52JE
	ZGfXbTO7n16YFNDHy2WNtFuGy7mCGvW1naUS2JPvEiHGkmjMDWdwOnqM8VZ9Ae+PoHV6+y
	Jq6yigaujN69WuHmZkNgtax1ALdCzyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CCF160055;
	Sat, 25 Apr 2026 14:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80DBC2BCB0;
	Sat, 25 Apr 2026 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777129074;
	bh=p9NIKZ3p2iPPLemB41z0f9r9GTpX1JVIj3yIsQ7bB10=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=rEKeu3N0k017FBmeBmrcD/bKroFhUGzm573E+hdrbA5/uv4T10BbkTgPrGjEs7QYc
	 XjHV2b71Olf2DjNTL850JXx4TicaA6oZYSXZuTYGFQM4S2LoCwgkje2ip1GOcS3SJ3
	 xHPn5X8BUK+Pz1UwCMQewaT/OX9zV2zyyFoBduq8=
Date: Sat, 25 Apr 2026 07:57:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com,
 Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH] mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge
 mismatch
Message-Id: <20260425075753.eab83d221fd6ad59241e0f1d@linux-foundation.org>
In-Reply-To: <20260330131525.630b8ff8913ade1e0e5c2054@linux-foundation.org>
References: <20260328065534.346053-1-kartikey406@gmail.com>
	<20260330131525.630b8ff8913ade1e0e5c2054@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A9DFA0002
X-Stat-Signature: 4ch1yuie1ggu8okfsnriwrqp57wcqc6n
X-HE-Tag: 1777129074-299691
X-HE-Meta: U2FsdGVkX1+mgiDQMEIFkIaM6mpfNSPxVKroagYo3TuHYOJT2iVlgeYq8PPihVERtC6FPJmnv8uZWrHVdZujuOhxw64F1YwZP4V0yoFiVP+PTVvBS/MxqbD+14wtZ9CZ6H9TiZfPI0C/250D2fyEgLU8OB/jcuN7S7EjmFCRZcYKwrIOqdlMNEnj/69qq+z98TG6wAHxbcMYZkD+w+m/er0hz9Bma/hZXKsw7IwtIeBYktE+ZPVokRU8kC4IZ6zkUgDcCDkW4iSxzE8hVQeMWVzlYxmg2JRRTV8kB3rgaSHRkha0/w2/ZF24QczKQEfjZx7qt6Pp39riCYR/+LBYAmPczTDe925xHNoLzyalyHyzEuQPksIJYxryxpytL1o/a8XHChm6klSviSQrqeqyVlj5d9LFqvB3Y1NZ5fFS40MoZqmQK4Q6AWrbRrJuJCLZqnjppxohqhc/PpRJNlT/M7CfXnGF5tprJRHfJEd4uHvdzSbkt9oLqmY108fizK2Twd6HkDLGAV4Ws/zw64yW7o3oI9VWTFZ44QiL+owfZprApLm13C3uBSaAT5QxOJMjSiPlHAq3BCTC7KK41cio0Ys894FdPHNmtB8EaZWLUjQfeQ8o9cwE3GB5Y2zsVHsRdHQVZhWIroIZn86Y40Hym7ofZMggyQrdNc9WqtkF83zE31kXM4l0OQaV1gl+E4uyB0k/OWEth7Qi4CanX1A2wPGkruq//NSR7Lrrdntogew2ilcs4twlUZIFEDNO9Q5t+kmqehEv9apBmQd9PR7x7HvfuR/BIMAyaE//hRGiXhrhlsA/EtGr7y60U6iYZwRAeapako1r2QzB1ViB71RrFf6Nu2Tnf7t5TyIuuWdsGyOjDnqyNqkoy/BHgINQeYYjYsBV9eD2XEcZyc5q/CEvb9qsWYtiI5/dvobNBwffvm5NfrCL8fOnS3019H3U5S0wLg8ASNdf24oDaw22cbD
 afilQ+oE
 zArT8+HvL1i7d03xxfH2jd2BYmg7uqBHKl5u6Nen38mffQeMinR2U92DA8UgSuN1/CImEyeI8mHW+/9xzkoSPgi9A1uuP23HQ7a1K5SB01Exdc7JTdSumVHw5Ksz84fAUWAtmmdDUNLKKB9CF/9j5flSPDrz+Xu0oZAZMBTHkucu0P+jKEFSaZ085ADGoig4a+fpWdG2PcIOe5pwc0CtQY/+esCUPx2py+ac8NlQTyA+MswPvuclJbHL0rgqF7cnycFZSH9/cN7Kg4NJd/dcx0wQgHyfUCwzbuLulL1783EB4Q1us/FAaFT9VmpVBLmABG81kSBgyFNnrUpVmNqw+BfErViQ90B7OfgwE9EMklO76uxAhK4H6FLKyt04fPzIRwkib59+9z6h/QygP0TGnrLUU9MOo8hiwq0U+CPXiAUcndtj2GwQIoSyfp+Rm+KPaCSknMUg0+FUaU+gc8SmTqUUrkbHpbKOVucVV1OwEto6gDz+CwDWlER+WT2xg2jYY2mBgDIxOfMFAFYi/2IIvMhRv2LuJW8c+Ii08FlEC5ftVs2bWjs3TX4+esHnj8BgJL2tbhNwOG9eYJrEcdxlaDcZ0Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 13:15:25 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 28 Mar 2026 12:25:34 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:
> 
> > In alloc_hugetlb_folio(), a single h_cg pointer is used for both
> > the rsvd and non-rsvd hugetlb cgroup charges. When map_chg is set,
> > hugetlb_cgroup_charge_cgroup_rsvd() stores the charged cgroup in
> > h_cg, but the immediately following hugetlb_cgroup_charge_cgroup()
> > overwrites h_cg with the non-rsvd cgroup pointer.
> > 
> > As a result, hugetlb_cgroup_commit_charge_rsvd() stores the wrong
> > (non-rsvd) cgroup pointer into the folio's rsvd slot.
> > 
> > When the folio is later freed, free_huge_folio() unconditionally
> > calls both hugetlb_cgroup_uncharge_folio() and
> > hugetlb_cgroup_uncharge_folio_rsvd(). The rsvd uncharge reads back
> > the wrong cgroup from the folio and decrements a counter that was
> > never charged for that cgroup, causing a page_counter underflow:
> > 
> >   page_counter underflow: -512 nr_pages=512
> >   WARNING: mm/page_counter.c:61 at page_counter_cancel
> > 
> > Fix this by introducing a separate h_cg_rsvd pointer exclusively
> > for the rsvd charge path, keeping the rsvd and non-rsvd charges
> > fully independent through their charge, commit, and error uncharge
> > paths.
> 
> Thanks.
> 
> > Fixes: 08cf9faf7558 ("hugetlb_cgroup: support noreserve mappings")
> 
> Merged in 2020!
> 
> Could reviewers please give consideration to whether we should backport
> this?
> 

OK, then ;)


I'll queue this up and shall add the cc:stable - that underflow warning
needs to be addressed.

I'll add a needs-review note-to-self.


From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch
Date: Sat, 28 Mar 2026 12:25:34 +0530

In alloc_hugetlb_folio(), a single h_cg pointer is used for both the rsvd
and non-rsvd hugetlb cgroup charges.  When map_chg is set,
hugetlb_cgroup_charge_cgroup_rsvd() stores the charged cgroup in h_cg, but
the immediately following hugetlb_cgroup_charge_cgroup() overwrites h_cg
with the non-rsvd cgroup pointer.

As a result, hugetlb_cgroup_commit_charge_rsvd() stores the wrong
(non-rsvd) cgroup pointer into the folio's rsvd slot.

When the folio is later freed, free_huge_folio() unconditionally calls
both hugetlb_cgroup_uncharge_folio() and
hugetlb_cgroup_uncharge_folio_rsvd().  The rsvd uncharge reads back the
wrong cgroup from the folio and decrements a counter that was never
charged for that cgroup, causing a page_counter underflow:

  page_counter underflow: -512 nr_pages=512
  WARNING: mm/page_counter.c:61 at page_counter_cancel

Fix this by introducing a separate h_cg_rsvd pointer exclusively for the
rsvd charge path, keeping the rsvd and non-rsvd charges fully independent
through their charge, commit, and error uncharge paths.

Link: https://lore.kernel.org/20260328065534.346053-1-kartikey406@gmail.com
Fixes: 08cf9faf7558 ("hugetlb_cgroup: support noreserve mappings")
Reported-by: syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=226c1f947186f8fef796
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-hugetlb-cgroup-rsvd-charge-uncharge-mismatch
+++ a/mm/hugetlb.c
@@ -2879,6 +2879,7 @@ struct folio *alloc_hugetlb_folio(struct
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
@@ -2929,7 +2930,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
+			idx, pages_per_huge_page(h), &h_cg_rsvd);
 		if (ret)
 			goto out_subpool_put;
 	}
@@ -2971,7 +2972,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
+						  h_cg_rsvd, folio);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
@@ -3023,7 +3024,7 @@ out_uncharge_cgroup:
 out_uncharge_cgroup_reservation:
 	if (map_chg)
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
+						    h_cg_rsvd);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
_


