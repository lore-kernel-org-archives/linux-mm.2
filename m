Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1A0C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644BE6B0092; Mon, 31 Aug 2026 12:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4DF6B0095; Mon, 31 Aug 2026 12:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534DD6B0096; Mon, 31 Aug 2026 12:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE1F6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:01:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BD3A1401AD
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:01:19 +0000 (UTC)
X-FDA: 85162029078.18.A7637B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E116E180015
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:01:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nAW51z95;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788192077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsHPREOjkfveq5u4pxKTH6RiMoREQm761eR8QKvbfA0=;
	b=RQ+O+zmAvJSpis6gxwMA23ieU07woM4yKvxRr7ba8zuwov5t9cPypXgNfHzcPWlVOEYeqP
	cf/eMPyIZrXxVRq/T2E5fZRMjCMqy0gXPoJDQwsEN2IsfX3/1JA3vwbDSiDTa0Oc6W2nTt
	FycTxQb43CeO0/0buVY2E9kAsIdOKZQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nAW51z95;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788192077;
	b=mf7Vy1OGYePpkpdYDD83WAjtFLn3Sg4ldAi8yvf4j9vJTzxYvxd04bv07M4WRHiVxbra3n
	1BlwAmcO2i0HB92ZRVhuHvNDLi9cpOatIaEU1OVUvNK5BgaG4LCmHS0nQgSqHv4+mXenac
	d8tpCOp4wkfp9amYkFeGKm3FzUUB564=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 836FD602BE;
	Mon, 31 Aug 2026 16:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CFC1F00A3D;
	Mon, 31 Aug 2026 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788192077;
	bh=bsHPREOjkfveq5u4pxKTH6RiMoREQm761eR8QKvbfA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nAW51z95D3uEnz318yGDrWEoUKuoLgFtkETS1phm5cUVmixY6b5POwHbMjnzf8TsA
	 /w+SgRZP3fL9bXmeXC54QMk7EdBbSvhCymnLxNsknhtHH7Bra02fy6Gp8DSjEpt7yW
	 C5NvXvwuLVktykO6mVBthRJ+PG9opVnIzMJu+RkfCbrLTdMUo3ZUcYVPfvCzpTv/dc
	 NS1UycgWhRwMkzzLvB+6+DK+EjbeL16mRVeS6SqB8Y9uuEO7iwgv/YPpi91VLI/Or6
	 yMso8ECpHRo6kTMYCIkMjINW9n3Gkz83Z9iFMyPBsnyn3Og1wJ/5/hTnZPliG22BZ5
	 S+dxj6AF/0TQw==
Date: Mon, 31 Aug 2026 17:00:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, Kunwu Chan <kunwu.chan@linux.dev>, 
	akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, liam@infradead.org, 
	vbabka@kernel.org, harry@kernel.org, jannh@google.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: remove stale hugetlb check in try_to_unmap_one
Message-ID: <apWlLTa3oZq1wwvR@lucifer>
References: <20260831082849.3573957-1-dev.jain@arm.com>
 <20260831155913.2497152-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831155913.2497152-1-kunwu.chan@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E116E180015
X-Stat-Signature: 3iiwtaiqcyzzn94rdh86ka1dpkioq3ou
X-Rspam-User: 
X-HE-Tag: 1788192077-735762
X-HE-Meta: U2FsdGVkX18zijpJ3G46XDL1UFazX8PZmHE4+08TIlncyh9iUCGwcapQRIhGDTy5cnRTQ2e3ItDdjQWRlWr4RMV/M1XMTvZEQJ0udlqQYC5r0G5zYcF/2v/U32PA680RVnnUKyUW7LrIVgDv2tppBL/1GLHMJccwsU0Ia4Lt9ratqhio69+FHcK9Nd2iAz3ZJk/4qE6tpBhPom15KhDPI4OcInQAvmCZU9XTtg9WdflpFGyHizcZv5q0WEos8w19usNxIE7h8vrlxmkIGXXyNHwJ4FrP7HXMAogG0/i8XT2McFJt87GCgYY7YO7GYupF8sFD0LUSntKrCYYtalyPivWawgnQ9tTlPcJQMCmJJrYSrwPAMaZEew5HvklDJ5Ca7LjCo/fL5RgGlWC1a/zr3pDsU2LNxdGHbI9ttxieM8YMDSx1RfJZ0ICO9iynKbTGfBHEWSmJlKdoAaZMOiKGEumch0tDc73bVPp2kcqlzSz9H+SCfAtFT2jPsmjYlWRgsSiEqVY5hk6vxuDaKwOlmJadegQQ3A3AUaq7Txw/lFJVD4sn6gF8lUh5y2WLvdmbmRdvQYcC98404/R9u7aiVdh9a50ZaRdXnkx9x1E6J4cLBnG4/I0c/8OBN87WrJIMHTLsQBrOe8M/6zFJyM7D8zVBpVb6ySHBe7zFMellFbwJYjRpsrbqqgRswCZtSTAQHYRSnY+zP1YYd8UtwbjhUXeL8iU9k0h2TKqViqMUo6QUKPL0U4QCTvaVlRyTWGbAaQAxQq9IneH7l4eAit/QQqjVOfbv/rOE3VzYscxbQp6xQdZkmdPZ2MHjU/a1n2jKHoCReTXmaG0oNJxoNCU2cfcz+9duOznwokyfIf8T99DguEbH/NGMzyoCpHtlCEKcjwmy3fxMV87Cs417bn8nCbZxu+d8jzcooBqhh8/SiO0e4YcTTlV1vP6WV6Mzo3TRgx9ioCtdnyqEXY1rAkB
 YWfy3YvA
 hC/G2oryBGVejPDqo6opxJVY259Ra7GWFUrg+2JFRvq4K39qt7YPKTVNcwfhBJv8/bWpAB2my8nig3e1aKv0l+yhknGfNwng+U4GP5PkhWknIVdbxzEb0e2R1SYcQn7pz83gvTOibILv2rqisOAl3gB4hI2vHUphQHaSHC1I5E1+bKpbEm5UZyXmMPzM7qYcCYAMIQtjQFnnqutXnJAcoYVw1NKFgstIYQsJQtHub9rbQdKG3PHqj7or8mbNxROwAsBkoBL8k5VlItvVS6I2T3YBCb2mJ3Yebs0zgPo3JQ2ECnGBQxkBk9qOCB4GQLPlSSWTZUMez0W8qD+CU4RuYj8JxHIFQc465OLO+liCjaDHzExk+gMDN1FJ1PRttxAb+Dw3BHS2K16KRfQMrWP1WmTEIwy2AiUQvXso7kJjoWsfr6D1qwVJj3a5WQulxfH9bElQbu2AKiydC0ECAEos0Fai2aV4bX6qnFecyluZnFWZ6UXGH8VY+YMOTlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 11:59:12PM +0800, Kunwu Chan wrote:
> On Mon, 31 Aug 2026 08:28:47 +0000 Dev Jain <dev.jain@arm.com> wrote:
>
> > Post commit d4ec5572825a ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")
> > try_to_unmap_one() cannot be called with a hugetlb folio. Therefore remove
> > the folio_test_hugetlb() check.
>
> Yes, the d4ec5572825 change shows that try_to_unmap() dispatches
> hugetlb folios to try_to_unmap_poisoned_hugetlb_one(),
> so try_to_unmap_one() cannot be called with a hugetlb folio.
>
>
> It would be better to add:
> Fixes: d4ec5572825 ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")

Nope, let's not thanks.

This isn't a bug.

>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
>
> Thanks,
> KunWu
>
> >
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > ---
> > Rebase soup - my huge_ptep_get() fixes landed after the refactoring.
> >
> > This patch applies on Linux 7.3-rc1.
> >
> >  mm/rmap.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index d1819fd699380..606c8ecf31302 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -2299,11 +2299,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >  		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
> >
> >  		address = pvmw.address;
> > -		if (folio_test_hugetlb(folio)) {
> > -			pteval = huge_ptep_get(mm, address, pvmw.pte);
> > -		} else {
> > -			pteval = ptep_get(pvmw.pte);
> > -		}
> > +		pteval = ptep_get(pvmw.pte);
> > +
> >  		if (likely(pte_present(pteval))) {
> >  			pfn = pte_pfn(pteval);
> >  		} else {
> > --
> > 2.43.0
> >
> >
>

--
Cheers, Lorenzo

