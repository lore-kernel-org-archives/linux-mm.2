Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6931EC54F5C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D78B6B0098; Tue, 28 Jul 2026 15:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AFC56B00A0; Tue, 28 Jul 2026 15:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7396B00A1; Tue, 28 Jul 2026 15:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD796B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:29:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B5EF1204C6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:29:30 +0000 (UTC)
X-FDA: 85039174500.10.BBB242B
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf09.hostedemail.com (Postfix) with ESMTP id B3E4614000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:29:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=PDZrjd53;
	spf=pass (imf09.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LKyk6xHAbhyGB3Sd8lyBjhwA2Z8lPErhOcaYmR0I/o=;
	b=ExqIya+QzGvS9GwmNjpxsykvd1hUbXuzFxXdGjydVlNVDEYjYnkkqe+Qs3Qqyh1tyytLy5
	OjZe2+0hAfWnefLwjcnBkfy+G0I6R+34Zaf30HnqLsP7ovSN6u0PvaL6B6Te1xtZUI8hM7
	ojaZcBp+VXjfJGbC9cIPTNEKK+/eEjo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=PDZrjd53;
	spf=pass (imf09.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266968;
	b=qBn43jJ7A1Y7cHBM7MHTqFBDsE9dIABIctQsFa2BgjCrUd3TwbZLnyi251FKJo938m57w8
	nmEubpnJYvrr+IscP/33fZrMvL5LhmTdMpHzYjqFM4xCW7hxMkSfmLm/lxsxPTYui3KaNu
	yLnnk7cNPWfLGObempCAd82XncMLQdA=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id 2AE8919F57B;
	Tue, 28 Jul 2026 21:29:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1LKyk6xHAbhyGB3Sd8lyBjhwA2Z8lPErhOcaYmR0I/o=; b=PDZrjd53JPSI2wuii4RDNuoDHU
	HAfyMoyOz/APHEMe0YyJ1go/Bbjmk+UiDPVB4LZgynQZ66GGnKi7XeEYeRpjJC+gNO/mYUw0PTBru
	kuz/lYOXe9cORvLqrtdCz1mAef9D8/a0obtjXHtPGnFOs5HElVS/eNfjXQk3tNn2hZ/k=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wonUQ-00000003rCj-2LVU;
	Tue, 28 Jul 2026 21:29:22 +0200
Date: Tue, 28 Jul 2026 21:29:22 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Guillaume Morin <guillaume@morinfr.org>, linux-mm@kvack.org,
	muchun.song@linux.dev, leitao@debian.org,
	Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
Message-ID: <amkDEodqJpqQqV1P@bender.morinfr.org>
References: <aleRuVBaWu6eTCJb@bender.morinfr.org>
 <17658f3e-dca8-4e8a-b57a-328a46306890@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17658f3e-dca8-4e8a-b57a-328a46306890@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3E4614000C
X-Stat-Signature: 4tbqoim6u3s18kh46kxhnn55qs6isrbn
X-HE-Tag: 1785266968-264146
X-HE-Meta: U2FsdGVkX1/PArPG9EuIAOIiSRo4TGg3ap/nNn3Kc4i4zEuQCAVJ5mfgPScqdS1S5Es1ilfgTxzeZz7IPl00LPn05d0fAztzNMmVpi22Y9FZ8rXZyMCaNFwbyCIGHuIAYg7xdxnViUxQu39gxP4M6oMbAaQ+Z3vn1B9ss0eXq7AFnTuHsO8SMEZmFK1+vqI2CYWya2c9QKJvizzlIqOXZVCm7fpnZULTQZFJVuT7ngFlfO3GHvY/xR/YTcmEb8SeBYM6XYK0BqAZwPfK6u1QEuLCXKZGHv4jAo6oFJqrTlENVXeVaHInD0HMaaSWr+NwAskOUD0nZa/5tS6JrlqzAPEtjRuwA8D/xbhJrhmnJ+vanQ6DsWEfGyoOQhX1IEyciiS2VU+FFP2s8Ccu0jqllgPY8ezB6S+wCN40xq2F0VRWhV7VBTVbiZd+RKzy/UfYLXr8xdgyjb0UklPq1CnIzWN1G0TQ4Ndpfh0Xi6DMHJA737wQfOvR9ZEpv1RF1UxngTMusT3L6fjCkhdCXI9KZOCYMJIifPSrm6JwTURJ+STXqD52JxST7c0qPiWVk4DASPDHX5t5ktHXTwPzFDMe1TYzPhFKlyz8iNRUgsCx9HFO6woKw9yDxNW+G3+FfG7wMOmBts9BhTaMoc8XFwZGmLvQUY39OgTRE8dTFwzQm0wTfpK/ai+AjWNn1va9+cr0J8IuwJOt7f8uac1UV8yhrfyhUZTYGAJBkd+L093PeQlKdzm77S6t5UuFu7oPNKvp3EkhD0CBjJDG8ye6Kn4ELE0mgaSRX+eQPaqQiQZ5TxdWmUruMEvH21tWUVUnIke5gu0HOu/f+7swcZM53T6xK6ojnLpMRO5HfIkYik69YndDaQ2NcgnOpkXA3X1wF/q36XHe+AjpYkoXlu3n2nY6D/yDUUrZwbV76W+CEGkks9ZwfsvG2+Vn7KJGazqvHUIN+e8bh66ATK2jCZcQEei
 j2AV+Wiu
 mytAo7+9nG1OVRsrohbsbvbhVIr8ZMFVo93royZRmhnqMHIJAhKWR7s1q+lqs9Jo24neE3SLnff1EjmWTaPcGF1/6A4XgBpgK9HwA0BltQsXURG1giNp7YyXRP4VE1xAOK/DW+YvPnS2a8z0OovWh/xXPogkVu2CSAiN+bRbMD7Lr1cBo1PDGaj/ZWdoad7HSFIF4NYwVgONzKPwB+BxCFYBRa0HP/232/ZviBViLvs42eVGFMtsPue8biY75UU1fxWbaMmXQXCac3xB+Z2/Q/bq7CZv16uMx0FTMqT+sMiO4F/Ds79uxgDclKmeaPS0Z+obM73B/sF3xGXMNEhphgVfswuM9eYDd9ge4OefjHQ3YMu8B78WNLS4HCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28 Jul 17:08, David Hildenbrand (Arm) wrote:
>
> On 7/15/26 15:57, Guillaume Morin wrote:
> > Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations. In
> > the case of folio mapped in both a parent and a child, if the parent
> > unmaps the range first, the reservation adjustment will result in
> > an underflow of the reserved count. Once the child unmaps the range, the
> > count is restored.
> > This patch changes __unmap_hugepage_range() so it now checks the
> > mapcount before adjusting the reservation.
> > 
> > Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> > Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
> > Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> > Cc: Muchun Song <muchun.song@linux.dev>
> > Cc: Breno Leitao <leitao@debian.org>
> > Cc: Rik van Riel <riel@surriel.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  mm/hugetlb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 571212b80835..c0167a09a0c4 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -5252,7 +5252,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  
> >  		spin_lock_irq(&hugetlb_lock);
> >  		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> > -		    folio_test_anon(folio)) {
> > +		    folio_mapcount(folio) == 0 && folio_test_anon(folio)) {
> 
> There is folio_mapped(), can that be used instead?

Fixed in v3

-- 
Guillaume Morin <guillaume@morinfr.org>

