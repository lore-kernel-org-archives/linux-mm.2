Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A9ECDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 20:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6A86B0088; Wed, 24 Jun 2026 16:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57BF6B008A; Wed, 24 Jun 2026 16:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9BB6B008C; Wed, 24 Jun 2026 16:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0236B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:15:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02ECF8DD17
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:15:01 +0000 (UTC)
X-FDA: 84915910044.06.3A06C5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 01E101A0008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:14:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="m/31r4lU";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782332100;
	b=gGdtFfnp/6LbY7IcG7YAu/hL7U/sp0GJztHSQ13Bl7gtY7F24igCwp2sMxtKQdtoJgFtH1
	TiDoSVnueWgEYLflR36STRYmWdVTl8n8uiHGureIsvGnw/6GnyMoXBJCBepUTnJcsDxjr+
	fJ1zkL7UAS7POIa07vt67aAJ5lPUfsc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782332100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YF1E9A9j95RYF32v6gA/V22KvXKXCKGMa1Pt37MWNeg=;
	b=s3+Xn1lJLC/UxdoLVQuwnYS0olfkDxW53U32XK59BVvMtwlUST6RNjvspCAtcDB1jFq7xM
	IzEhXQRlaMllr4jvZHvvwmOWnMiQ2m8ojfthX0aDWw0wI7+2+fVx5NQ/WW6dEIZeJJXQAE
	GRJyNM9S039sIpdgANgOL6rFwKzqmlg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="m/31r4lU";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 205B5443AB;
	Wed, 24 Jun 2026 20:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF311F000E9;
	Wed, 24 Jun 2026 20:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782332098;
	bh=YF1E9A9j95RYF32v6gA/V22KvXKXCKGMa1Pt37MWNeg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=m/31r4lUWdbeEfzdyGYpyGj8SbO06MuTV7Q1+9m+BqdEt1g+/oFlfFdJXa6o8by84
	 776pwrVBnSkVMfCnuWeKYOol0K28OPkgR72Nr8/QhwIQ5HTFnzN0j3q0pT85gt31Mx
	 Z8D8Uqs/5LAiR/SqyxV8GguVfm9rOFUemekpn14U=
Date: Wed, 24 Jun 2026 13:14:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-Id: <20260624131457.ac81fbac373f78aa80a516e3@linux-foundation.org>
In-Reply-To: <20260624082359.2869-1-richard.weiyang@gmail.com>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01E101A0008
X-Stat-Signature: jjjftum7z6u3kaf9w46aytgj7qm5p1ra
X-HE-Tag: 1782332099-289398
X-HE-Meta: U2FsdGVkX1/6GoowWPLDK2jMGqqxkKXjCzoWOLFCAMF7Mmg2i/zaZuMhp3QZC40EjAf4X91mBTwKqbElfXtmue0UH8C6TtSoOE/dY8Z/ewvxwnDnS8wguzyXiNW+LiIKHYhTRmMEzTnDiTnlQEFaO7gqnGs7Zrff5OGGtU0Han+HFkC2idmERFy8aQOtZAUGol7JLqGoulqYKCsUiCdlutcD4LY2KsRao5Z350fRNKuqJN7xh4gGeHpcxMtmmZsZpitlp5nyHo//HzuykKF5Qu5ATxp6h34KW6oUFVZVTHWPvA2sMdV4wDN9jmjRVdCiq4ZQMgm1aQo2IxG0RSMfJ3y+CUDj9ViaVDr830XfZHZDdYqkAoLFKom6rVKzi4dedAP7iKdSZxyiOxrMfnGuR0IR9YqWCsZ3g/YimDmyUPOt8jvAmng3nvB6u2PZKN6iw4aP58HVDd+GhkIT2uTiwspXal6cr++aMKa+j2sKFqv8owLeX00ehJZ2cZVxstmFDnxckSh2WrwOG9eUvRbtQV1DAb1H3gnTR32CcW5TFIwfLm0AjTeu1m/y/0tC3jiQJspDJfTHcEu1BBA41Z2MgFCu/qH5/YQBmPE8ZGKqd3nCLOgF0eZ7Y++b8ZXrF/UQyedJ6iaTAPeoeIIYyWsqF+HwuzFSc253/DKEs3pSOUKkC0OimJE9XNP+U+gluE0YdxDU708b0tsY1nE0LvRnB6KyUqrNBSn1oYE6ENWsgTUD3B86ljlmCeuP5xCL6oOwbLfSHgt4lyP6MiLjG+VM+HtbgmPqQecWQBQKb3KSomQeak7nqul1uIF0W4ZDH9C8M9wR/3Z1lxG/7izwjMC4vMAPZAFJC2oRLLigCVW4dgf/lWgjKIzcQdFkAF2+NyXORr8flRZCW9AgRaZG4gZksL0FYhKoH0uIrT2D3KUAs8UKAag0I0j31bN4zZVD/kOTcjbONo5CAUbP22p59c1
 j3cjJZAE
 iqXvfHdrE0jkFxiVyIyGcLic+MdvixQVV9RCLeycbhRJIg9CKOTSuwQa92rYTZQ5h0Dsj0SGDX8tLXUXkJNRdDlQW/jgH5uVTGcdIHBtSVjSoISZrqgS3T81pLKVncJrAGptmsen/eC3SilqdlrunMpasFCAjMewwhIbDHwF6Pbb632siswvCbO13YgPTWh3Xj+0EgjHLCfnniRY8Rpy8z5OU/RS9EC3avm3oPCV2Z+bQb+HaKk7dn8dJjEmqs+VlLNKwspFCCx1gmak1p7+W5nxvtEECkkr8kBKv8G5YgETtBtGFEB1hKIQGamgFPu48h6TXas2ZjW/yNiSyFGbEizL+M6i17nJVu0RXkQqSG3ihK15hpN/8CS/KvGChpN7DDJap/y7J16GGmImbewKkjYpHeyaETHMat0JSOSLSl0Ic3eRub2EiyFafZpk2zrtM6wjx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 08:23:59 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> The kernel test robot reported a build failure on the parisc architecture
> when expanding HPAGE_PMD_NR in check_pmd().
> 
>    mm/page_vma_mapped.c:142:13: note: in expansion of macro 'HPAGE_PMD_NR'
>      if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
>                 ^~~~~~~~~~~~
> 
> The config [1] in report link shows neither TRANSPARENT_HUGEPAGE nor
> HUGETLB_PAGE is defined. Then trigger the BUILD_BUG.
> 
> Fix it by define check_pmd() under CONFIG_TRANSPARENT_HUGEPAGE.

hm,

#ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
#define HPAGE_PMD_SHIFT PMD_SHIFT
#define HPAGE_PUD_SHIFT PUD_SHIFT
#else
#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
#define HPAGE_PUD_SHIFT ({ BUILD_BUG(); 0; })
#endif

> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  /* Returns true if the two ranges overlap.  Careful to not overflow. */
>  static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>  {
> @@ -145,6 +146,12 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>  		return false;
>  	return true;
>  }
> +#else
> +static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
> +{
> +	return false;
> +}
> +#endif

I'll leave it to others to decide if this is the most appropriate fix.

Sashiko had an off-topic complaint about the surrounding code:
	https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/


