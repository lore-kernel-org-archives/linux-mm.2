Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D09F7FB3CE5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9A36B0092; Mon, 30 Mar 2026 05:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173D26B0095; Mon, 30 Mar 2026 05:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BDA6B0096; Mon, 30 Mar 2026 05:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E24636B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:54:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BA2313BA13
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:54:45 +0000 (UTC)
X-FDA: 84602270130.04.A626696
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E262E20007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:54:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=omqfLIJ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774864483; a=rsa-sha256;
	cv=none;
	b=papIj3n3faWJ6Rx0B8loviOHPek6JBRcKp7dXfgoIe66eWZN+Z3B5g0pDG0CaT0LnKpVHB
	6hH4vKUIMonNMooAqOFZ9y/twymc4E2Prgx0O6yTJvAlkZyJ0AJeLLJEJMTzA666Jn2WO1
	PbblKFD6NUO6XSr5Xp5EHQbXBK4fu5s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=omqfLIJ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774864483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bnC+8UUy4jr5ZHc3ab22DTsvcHDSAcjADdaDl16S2sM=;
	b=DESx+XPvppJ9NU+00lo9hliN6BueXwRrmpkxCu7JxJaJV15Q7gdTqnChk/zQX1qjvsAgU5
	KszQvC+EYxht7+ptHwGqInyZ292eMUcTcDjm0ubpnkRTc7dsXD8L7Zp9gelkSfkc8qu2xF
	bR0jWdgPDcfFJTyNVkymYv5L4qozpCc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FDA960128;
	Mon, 30 Mar 2026 09:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F84C4CEF7;
	Mon, 30 Mar 2026 09:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774864483;
	bh=P5+O18KEaXJRb7s7QQUjjetgg5oimgVFhgzsPVOEJoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=omqfLIJ3ogwBfKm/f9OK3gZb5PqY39BCCkmDJBraM0O2KAKgWnPYmXJbyWP3HA84x
	 c0k7yMJXYZqmdqwqt+fHBpkDebzwf8JpggFU1Fo42qt2zNh/8T6HeEK0QjnL6hBche
	 yiqX21c1tFAX7ZIPX3emaK2v7BRxMrYRvjv6tEsAL+4Zqrkme8YuVZhHwlrLdaDKyU
	 PfUTSLnyvNdivcZIFAoVC2Kr7wZZdH04cVnuvv1oHn2OevCMzwPznp1Xr3vkR+LgJb
	 BhEVUl/nPoQKlMykLef1y0RIYsvWunrcaHl1Fcsjr1b7HmctEYy1Kcw97RvGsgJ8u2
	 2QsasUoU2dt4Q==
Date: Mon, 30 Mar 2026 10:54:37 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
Message-ID: <9679449b-1078-4a23-95b7-e92e26259816@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <97a35411-3482-42d5-b0ea-31a5994956b2@lucifer.local>
 <0a917f80-902f-49b0-a75f-1bbaf23d7f94@lucifer.local>
 <CAJuCfpGe1TQ1Cv_ZtjQhjgQD-6bxk9uirJeDAZwhrSX=NqEw=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGe1TQ1Cv_ZtjQhjgQD-6bxk9uirJeDAZwhrSX=NqEw=A@mail.gmail.com>
X-Rspamd-Queue-Id: E262E20007
X-Stat-Signature: jixh9x5hqrua39agk6dp8n6ojamx465h
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774864483-980198
X-HE-Meta: U2FsdGVkX19xfXGz3H/mUKeuRtcvR4eFaxd3F6ynss5HnwnLpQialUsbwwM44upYgbdPB9J8HlzubxAvp3uJBE86EzdWoYxcMinJGcyWmE2qef34Z3Ot0cG3eQEueHQQFYQaYwv734pEARBADU1cXqFTtwexoiKB875exviemxSN3AL51Vh+1UdCKjc62NJwPyErlvFTYfHR+CzhSSC2X3YWBfhoyARKfN+e0+wDXArIoseaYeFP4WyiNK/GqzuwdGu4WoFWSyib/gOCsUSJ28HCpW4AgY4bEFP95dx+D+gs/9siD6Lf9G6Mpg74va7GQkZ38LOdZbJIOssaV/mWL+SuXVaMxuiBnXYMTp+lOCkPk1B3rEF9EjaAYl1ccjHBOLIQbjZCK5iIijogyypHBbpHA0l/cjPmMNPmAkyyiXR2w/gA8xHnVCSdZpftEAozhaojl/dgT8s/W2Ch0PKW/wXGnmYwXQJvLsVYOngE1slFRAdymxi7YLU6OID/78qAwOOkeksKHRlgHpS1z99TDBBDjnEmazXNVTBrKggDKS663CTOIWAI/fntuCadm4m2sdsE+1r0TWzrjKwZXRsRL7dXy/YkyyIB6cr0zsYjgqE+dJSuNujseI8novbNmr1R0h8PtXEo/0fc5xv5VcWG5mnLC60x6w7Mrs6zBShBL9yA2tVlIirGmxgq3u9BhlHEDGeLiDNxJcRwBMlsjfnHYx4iukDfGb5rBDlNJL/xTeMmQll/+GLWcfI9PuA3XXFfKbouj+Iop8KSnOd07KoSoeVkj8h9R0+4ZLqe7pnJXsA73MA28I6qnaxkUmhVZthqXNhFejguPUG2+vsk7vh3TAYHGGbEPIFuqDBntI0sAaP42Amm8B3167DvhDWsTIrpIEZKXk9LP1ThTJBEeXDfo9F3JQqdKeHWKAI5fkL8kI5AXkikmNS9EXFe5tqD71rQ+Q4ESjZIndyp0WpKumb
 8VY+IjCr
 +7RVsc8E0UGOQNd/XZ/XH9fL3lklGbtvfaoRjxn0A+BdVOCHt20V6WL++KZ3CZK3SFIwnor9PzXLYL5bTJOoqNcKRwMRZeXL2xhtDjPmvP0o7fYNURL0ygJGrbfluu/AqGPgfYHsexDXAQTkZSX50yb6DXWjIfjzmjdf7IVn3YCwhc3aPUrlLhGBWFc99Tjt9JTH09a7jkLGVoMjz4ThkKOwkmmYYqFtqRSD1dEKs4MVXgu9Lw6iEc9C705Vn+qVQp/sxwszpdBGDiTJw/H2hRZoUH6XQQbAVvcS94gXppwqNPtIGDzcCpC2CmFtjWkQya/B3H+VaCrAhgP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 28, 2026 at 12:54:38PM -0700, Suren Baghdasaryan wrote:
> On Mon, Mar 23, 2026 at 5:25 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > On Mon, Mar 23, 2026 at 11:45:23AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > Hi Andrew,
> > >
> > > Could you apply the below fix-patch to resolve an issue with us performing
> > > folio_put() on a folio before checking it again to see if a table was
> > > deposited, as per Sashiko.
> > >
> > > This patch resolves the issue by storing whether or not this is the case in
> > > a has_deposit local variable (as used previously) before invoking
> > > zap_huge_pmd_folio(), then using this boolean to determine whether or not
> > > to zap any deposited table.
> >
> > Oops this is wrong...!
> >
> > Please apply the below instead :)
> >
> > Thanks, Lorenzo
>
> With the fix LGTM. Overall very nice cleanup making the code much more
> readable. Thanks Lorenzo!

Thanks :)

>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks for the review!

Cheers, Lorenzo

>
> >
> > ----8<----
> > From e6d58747d00dd954c605201e97f8b769b2ba8cf8 Mon Sep 17 00:00:00 2001
> > From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > Date: Mon, 23 Mar 2026 11:42:01 +0000
> > Subject: [PATCH] fix
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  mm/huge_memory.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 610a6184e92c..b2a6060b3c20 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2397,6 +2397,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >         struct mm_struct *mm = tlb->mm;
> >         struct folio *folio = NULL;
> >         bool is_present = false;
> > +       bool has_deposit;
> >         spinlock_t *ptl;
> >         pmd_t orig_pmd;
> >
> > @@ -2418,10 +2419,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >
> >         is_present = pmd_present(orig_pmd);
> >         folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
> > +       has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
> >         if (folio)
> >                 zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
> > -
> > -       if (has_deposited_pgtable(vma, orig_pmd, folio))
> > +       if (has_deposit)
> >                 zap_deposited_table(mm, pmd);
> >
> >         spin_unlock(ptl);
> > --
> > 2.53.0

