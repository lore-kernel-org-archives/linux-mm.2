Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD0CCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD2D6B0099; Mon, 11 May 2026 10:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D6E6B00B6; Mon, 11 May 2026 10:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893826B00DA; Mon, 11 May 2026 10:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7854C6B0099
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:20:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2863B1C005A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:20:23 +0000 (UTC)
X-FDA: 84755349126.25.E1B32FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A88018000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:20:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FK+0gWnz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778509221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJ0SCAbWbCohm8mfzXFxT7spyLrcsostH3O42qFnLTk=;
	b=XfME0ijoLHFQoCGoti2mD4PPkdvxd3wFIc/Klx9uuHI2LIKZOM9IHYveVfjwYmA86B4yPU
	XvJoRN+YFSLtNypVM8R/TWxK5JSQTyxL3eva0wgsau3hxnBKpfwb27uwakm4QrgqcNauOT
	0HARVGGeH8H+p6eULhwzXCWXhJim1NU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778509221; a=rsa-sha256;
	cv=none;
	b=eMkf2ZXDZW6zjIj2hoUAWkUq3akWZnlHktE5X2/ibdtXk+8geelNuinWpXVhf4LKKiz47n
	AXQd3kARx6Bv0Pvu3zxjSRGHvPqLz0ZnrEiMYQc0oXkql90c6Y1IkCENPpP6IvchfmCjvF
	XPhZpYANbQiNbbj326DzsPnWm+ZK8mU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FK+0gWnz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75DF840DBA;
	Mon, 11 May 2026 14:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8224C2BCB0;
	Mon, 11 May 2026 14:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778509220;
	bh=HcevkjlxcwTsli3Kr4LstbtESWEHpSWmJVTxiT0CtcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FK+0gWnz8Ifm4i9roL53t7zmULLZRcjD3IWaqWRck4C2wro+hibkQheqLlXMGz5ga
	 0021BfOqwud2fxHpOkfOFi7Xv+4EoZgICCvyCOzQA/tqL+9wGicUbk/6mBtEya+SDS
	 5vKoXtV/nKXMHD9tg5xrS1PbLzBOLXHuYzvUYAAAWpFGkJiBFGLlHPeOhHqHkbrHbT
	 iA6owS/6T2js71LUFiAju0OBatTqRJwO+aTDdMTHmxdvAcZA8d0GzMp9BNpZs1TtoN
	 zuiTeFNFFKCAHFFtj3seDy8LI0QN+qb/4E+hu4w9lxadKZU3zkwEI6/WG9RF+USEAn
	 uoWBXWHblOBIg==
Date: Mon, 11 May 2026 15:20:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Xin Hao <xhao@linux.alibaba.com>, Ye Liu <liuye@kylinos.cn>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foudation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag
 due to allocation failure order
Message-ID: <agHlL25pyqU5_TKA@lucifer>
References: <20260511025408.54035-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511025408.54035-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A88018000E
X-Stat-Signature: zurkibhgwadpjefzujymqepnn6az4x3n
X-Rspam-User: 
X-HE-Tag: 1778509221-790686
X-HE-Meta: U2FsdGVkX1+/pMbKjZRnZA744/XOOZ3jC5+DCueH2gQ0SezaD2+f44cmIlRrMbgW58CXCSKOJufTd2gs+N2cZqSiK8TvtPzGxCKnUwW2k+HXTVD4voucbA9a1tc8GIvkCyAQsTnW0iMVH4+IwaGedyiKZqh/yz5KKBcAKJIcmrl5h3KrhWo4Cj0LdRFjFs8pc/d/pbpNuJ2342FW94Xhb1/C+01USE0SBiyoiYPYeSq/V2v5li3wqPjQG2JH/hio4fekSMBf++U5CGLLJ5kjiWPwNxdt1m85KCtGsk5tQBm7jEzwz6MGP+QvUOpzz9sBMiWSuKiaHxixrK8/DVX1vmI0pJMw0mUtKIaLqZHYijM6/M+CEp8KfY4cIKlQsZtmWsZTiXh18OAiwNEs9qwZGV3ggxpCkz9rf55gc5JdEonRPkRoFyi/PddcGOg43SRyGWH2LHchd11wWlXVlxLToZtrcQ6WJM1Ej7aJrLcgT3LyhYl7UpK/n5b2SQxFo7CyfNjaGhktVlEdqwFexwBYaSeQKUULrRQCnRUpbM/yu+dK0fTklIGzyq+X5fpDm6H+31dLXGFLK1MRa1nWZSw5Pu5FMtUyC5wiFFAlipMhhdGeNmskQrdbyAjZGmlDKx18QihNfdE+S1LxSpqBoRvuYYX4seC/46EGYVf6Rn8u2KdinQbGiWC0a8Lb9f6+70Jf1uCxhdUOt3yjz93I83zJ58q8UuZbnqJGzRPvUcD9M8vUoCeYJKnkF31B2SFWn5B+ItjMA6dLmdW99WNwmXOyk4IYCg1iFMD2EEq3ISBMRJjKB6kWhP1JctiJ+IvP5xZyq2qJKRY+YtX6KLfG94gMJDSVSsrN9IFagxUkr+iZZudp8PonC+RE9epPMMUxbh65SJ0UZ/2odJqs71TfrfixemPVRWxY+C1wGSUZWwnq9bakCXMHfjB+VthM5IvHAo54/CXNWcr+qKwMhwAigWh
 2ydAgsRI
 nC3D+PMWgUiXWMqZv2zJOCcQUpY7zH8/5m5HhtVlNqjCXMtzfoks+CvErSYultLiOOKxEx+FbwbT9fZr2tWjrzLnjSMoI8w2q1NDWXk8FlxbHvdHDbmJASAtZabb7GhFwK3f2IvEu7Xt3MwbGWJa8raH09i3e84pL+lGnK8GOCey9qCJFCm922iEoRWpbFWG89XnQyUEhPy9hTed2+8s1SXOdCB6emv1yCCCMYEsmubV2OVIe3apboQ2ZgWop3a1qVDT6sRofL0HQLzfAHA7PGI+g2oEPlaJR39fMt1+hoyO9wLGxWrTXezaaUmNOv4Tpz7Jx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:54:07AM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
> corresponding mm_slot.  If mm_slot_alloc() fails, the function
> returns with the flag set but without inserting the mm into the
> khugepaged tracking structures, leaving the mm in an inconsistent
> state where future registration attempts are skipped.
>
> Fix this by reordering: allocate the mm_slot first, then check and
> set the flag.  If the flag is already set, free the allocated slot
> and return.  This ensures the flag is only set when the mm is
> successfully registered in the khugepaged tracking structures.
>
> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
> Changes since v2:
> - Reorder to allocate mm_slot first, free it when flag already set,
>   as suggested by David, Dev Jain and Lance Yang
> - Update the subject line to better match the patch.
> - Link: https://lore.kernel.org/all/20260506012130.9306-1-ye.liu@linux.dev/
>
> Changes since v1:
> - Add Fixes tag as suggested by Dev Jain and Lance Yang
> - Link: https://lore.kernel.org/all/20260501075708.327217-1-ye.liu@linux.dev/
>
>  mm/khugepaged.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5f4e009593e0..78735f34250a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct *mm)
>
>  	/* __khugepaged_exit() must not run from under us */
>  	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
> -	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
> -		return;
>
>  	slot = mm_slot_alloc(mm_slot_cache);
>  	if (!slot)
>  		return;
>
> +	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
> +		mm_slot_free(mm_slot_cache, slot);
> +		return;
> +	}
> +
>  	spin_lock(&khugepaged_mm_lock);
>  	mm_slot_insert(mm_slots_hash, mm, slot);
>  	/*
> --
> 2.43.0
>

