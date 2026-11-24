Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0735A606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwd3SkJ7
Received: by kanga.kvack.org (Postfix)
	id 2568E6B0645; Tue, 24 Nov 2026 03:42:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E8F6B0647; Tue, 24 Nov 2026 03:42:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144936B0648; Tue, 24 Nov 2026 03:42:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8F996B0645
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:42:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DE24160ABD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:42:19 +0000 (UTC)
X-FDA: 85469370798.16.24BA726
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A1D1340007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:42:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwd3SkJ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795509737;
	b=6OERw2mAcTE49MuQ9ciXl8r7BFNCg208+HdW55Hl6Ko6/cTGspxJFdxyWjHP7RJ0H9ninO
	lrAyTa+nrHzJUfLXU2oM7tCT1EZAzqNYhd3D73SwAasfhY1LAey0ZGurNxi/Pr/cYMenBr
	WqWc8AIQyFKl1z1Sq6GR+NW7WDvQJd8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795509737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nMeElnKRibqtyS5IiENRQlfWIoBjOd/mPlC2beLlZM=;
	b=Z9IIlbQjGLtTHyfbhqco8mCx6cAw8sGVfYAqnuMUUzystiIra4BuMAjksB94qVq8g9IQd1
	LoSC0Y7FwCug1RFgbsgmZlPxav0X6WOxHt881n6j8VvredGIBea/7U8LC7HaESUpLQBbPp
	VUNefS2eAUWXCYmU/uQNLLC/CQnBagk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwd3SkJ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5D3E60DF6;
	Tue, 24 Nov 2026 08:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8371F000F4;
	Tue, 24 Nov 2026 08:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795509736;
	bh=0nMeElnKRibqtyS5IiENRQlfWIoBjOd/mPlC2beLlZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bwd3SkJ7haIZ/Cr8gWQ11dH5pwy1TUoJm2z6wMy0sZn6MstoyKpI0XBlYB84j1iH8
	 CZU7anzWQ7ozDIr84f0soz5d/FonYA8gqPtYpF4j2cUfrS6PM7ZW+RdkBQcaU0CE1M
	 jY4KCFjXYKyu8rLsXVi7HehMMEAectNQp1CxAiiZ4TUJBfMXLrg7Y6F61lXo/eGjoh
	 uUdP+cbjd4kG+lwesez4t+XE3XPY/hWxnDiB0pyb5DRJjqoQpzRk3qdAYX/f3oi78a
	 29zx+BkYiV/a2nxg7zg4fI2uIQuk2c4j/qVN7NWALVE+hmmh8lRQrKpKHQLes5Q6YL
	 5faz20hdUSIgQ==
Date: Tue, 24 Nov 2026 09:42:11 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/hugetlb: fix NR_HUGETLB accounting for kept surplus
 folios
Message-ID: <awVN4-v3zZ5fTkI8@localhost.localdomain>
References: <20261124-for-gather-surplus-v1-1-231e5660f3d8@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-for-gather-surplus-v1-1-231e5660f3d8@kylinos.cn>
X-Stat-Signature: n8113bprz53cjq1dyo88up3uewytdzjf
X-Rspamd-Queue-Id: A1D1340007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795509737-797315
X-HE-Meta: U2FsdGVkX196uG6sdmREXCyMVltHntzqzz4T/jEflgBfGADB5nUhsBm1WUzzsvwZEAbLlDDfxmnCMfOWuMYQmXvCkPtr2+qT+vEq7v39SqKaQOWdJowK9L2FdCTJBYOjBrOdUzpwyGnA7FeMe9Aa3MLilkfnozXE71KDJ2V0a7oLYoTKCE3MgE/yPshZp/jDKSV/yg1vCIto1NH5dmja+MAhPz/R53Exv2qgkTzP3PC72ZN1iX1ieTPYIEJCUYQcqp1qRIzbvWJNc5aqjYOGP/R75Lp+rMWtPjSAmo33lkH9mTbl7F6hsw1Dm0QGLSCmvD3MruDy2VtvfVMpbp2dowDlSniJQnNYX9EqNJGz7MSYbQyzHSZi3WGXLmSqI4sgr3/p3G2z0b+uPSwpCx0s87CiXk+2EMci78xDwIDry021g4rrfOmA09+6P06wWdw3dgWKibLtWm5mZBs0wUJbF4f5ai3d59sxf1pqYHH9a8PmuLwOiI8YW63VXP/6TdDtj9fj1YFZk2pJzazZHB8eaT4cFk0XB7EAZtqZL20moXmC9ugfBkdFkw907p4eCOMzoiclYel6AshzR9kPIxFgspyG16vVVOsmNCvpSebyxgmOhXZvKCnyTjX32tIxVn+blQFZSCZtVBl41mgA+O3E08V5uGLtzBV/HAmP2foSk+9gVsqA+rT615LC27xOxs2DoAbDEVJOCoK6WZ5YSRUdn4NYGz7rzOLvNEKZijk7hIcVkoOEZECWkLtHlhJRq7PeX7HVUleG0ezAUNAv7JbgQacHKVC5g3+X0jjM3i5CKpk+gk62arSJGJhN84v2h7upnMhymJNdkyYPDJZXch2j1os/gsbJevc9Zfsg1VaCjFACiVfNprJnIR6BSwi3eV/6wPHc14+n76krDx1UNF5oHkWIoVxuEeWGhUZxUOfwk9qSdrhHXO0/Mo8HrdzvUOd4GGc76ZDZlcrmDyTxEi/
 EPPuCX8Y
 YTVeu9JvhM1Qg71xKVKdVyhSCv94dZi9xH9tD1QfONHB07LAe81DDElp72fDwPtgsG4Hp56CsQpVDlsuL0O4d0eBG+jgaggm4XFuOQ+9Ib7MYOKj+8olPtCwKZpCs5fQWspyoOtJv5TrE/144nQ6AVzFDwHPbBBPPj2JstOiVE/4VYBEdwH5BzAsbkfZxV4R1oxQlbexDLzOztb2KdPbKk9fUdhvfCPRSzBEVawNy3jYlK9GWPQxukAjcTxDJPfNSmVoU+3NOSCpjs2GRCjsJDv1Klovn0tJM/zTuRhfAMEqgnUypR0oc5dWUZIoLOG95C2cs89j2vAHf4CiJmhwkc/n+b4EHq3THdelS9cBeBRyVYlJVZ1V3gh2Ey68nEP40olSm2f8/Vecqpk6Up8obW8/JIZsbRAoGaPwSBYg5jr2Hms7ycZul9/c20psXSCJ00FNatpm4tDtqqX5FV3EwW4rtYDwfJTuCXwySjsg411cEgW+WQPZ0LX5MikFdGM5IirQF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 12:41:02PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Commit a11a13ebbc5d ("mm/hugetlb: account restored reservations before
> freeing folios") reworked the free path of gather_surplus_pages(): when
> the pool was resized concurrently, folios that are no longer surplus
> are kept and enqueued directly instead of being freed.
> 
> However, folios on the surplus list are accounted in NR_HUGETLB when
> allocated in alloc_surplus_hugetlb_folio(), and every other path that
> returns an already accounted folio to the free list decrements
> NR_HUGETLB first, as folios on the free list must not be counted. The
> new enqueue branch skips that decrement, so the folio remains counted
> while on the free list, leaving NR_HUGETLB permanently overcounted by
> pages_per_huge_page for each kept folio. Nothing corrects that later,
> whichever path the folio takes next.
> 
> Fix this by decrementing NR_HUGETLB before enqueueing the folio, as
> done in the other enqueue paths.
> 
> Fixes: a11a13ebbc5d ("mm/hugetlb: account restored reservations before freeing folios")
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

