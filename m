Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF31C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9FD6B009D; Wed,  2 Sep 2026 23:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1546B009E; Wed,  2 Sep 2026 23:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A2F6B009F; Wed,  2 Sep 2026 23:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4DD6B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:02:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E209A0439
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:02:25 +0000 (UTC)
X-FDA: 85170952650.21.8DEDC65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D58140003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:02:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t3iiBiFf;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788404543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6fpnYgQzDhI+g8OqpnRixNH2BQW4d1tJxRUcM7JXB8=;
	b=fU6c9h7vXv+ULlz9YM+e2PRifCFmcVTCmqfy+ZY5I4KEGQjkwyEtSQcsKohHPzmTMpuvvp
	/9Gq1fhT70hjJf55csf4PYNZvdDjpjB1LuGxL9iFMJXIg3jTMQo1z6dMzvqbggKPmPSd0F
	06saew5pYx4n6wlzA2FaOhPlVA1MS8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788404543;
	b=hQvgHIfYqyB9sWZ0OOz8MDgrq16M27YuF9yU/JTeCQVTXmOzCzdIGnvkam3UpK+oAz67/G
	La+HDFoPo8AbkKR8Qa/YwtgMVbdLBTZOPlJR06+fKpNU3B3X9SBYKRe9A7UhnjspGCcMBA
	1vjESJ3aykSaSgbNgRxUG9ztizl9te4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t3iiBiFf;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 114EC600C8;
	Thu,  3 Sep 2026 03:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487FF1F000E9;
	Thu,  3 Sep 2026 03:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788404541;
	bh=E6fpnYgQzDhI+g8OqpnRixNH2BQW4d1tJxRUcM7JXB8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t3iiBiFfRRLEbBH6VG0Yzu05L5kwyfurUSxpLlfb2DiO5C+lNRJXCo0xT/W9NQH+y
	 QyKASfWpjDvvvMzQzM5Ji1ORGcIqNRBgLxqEgzCHT47Id1NnnQJ1g7YBfaWfTamDIq
	 47vKTtt86AodzSavp4ePH9BN463gU6ZN6n3amXCI=
Date: Wed, 2 Sep 2026 20:02:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lance.yang@linux.dev,
 Kiryl Shutsemau <kas@kernel.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-Id: <20260902200220.408ae7e8a28d3af4e82fd060@linux-foundation.org>
In-Reply-To: <20260624082359.2869-1-richard.weiyang@gmail.com>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5D58140003
X-Stat-Signature: hnemwhe9bys66qzcoqnheem9wjpt3erc
X-HE-Tag: 1788404543-436169
X-HE-Meta: U2FsdGVkX19obv8Zwe1NJxCt7ZKCqLXeY+YT4Vr+bkbWOVjh+1Zbm3djgHnxkOAzKMtn0gU5znTLTcRx5YaFBKWy5TpxO1n6KfrNtwtKKcMVF5MpF14Wlk3eaACvFl2n8QSGV9YNxGooS8mBoAAwgsfdI2zzo+lSC2mxrBd27Xl1KVXfI+/KXkPEuqn3JhiEWSJudFIVMJFERazKf2+X3NlWSB8u0xoDz1rOoab9kXSTwcNQ8AmCis5V4gT+Kbg9U5UkRD7CGH6IU9xmicbw7lmaW6hQxevVAE3Ni9zhO8luJeQrQyyFaW54n1XC2ZwEohz/lBWRu8jWm7htb2R3MrtjE2yxGeTdhBJsC4IindnkdrmshQGlpigh0r0/0LHpSmKZKnXbv+ogZwdBa1ev5mQpNlfn/HawKj2nExkxZ4TQnXh3T0oIdjsm7XWmUnJ6aI1jqE3x/qxt4+os6oHL/eQYu/00b2kVAvjCq9ASZBx/9r9SbWyqLBrA6siXV/0pFv4igUVOT0gQhEwBUJ2GjStDrRrKtE9UHSHZ0aPqVVD+Ro8PcaF6X/PpW9tfx5pB2y14ZUNr2jXc45BanRmzIZGrPWftFaLC0870hVF3+7ZlnC85nv0bRdV1kUIjUopULgYiM9XNPB0GXg+O/wd4/1SfGQjjeM/sr2e3lzYiNxhoNfqYjpRXZTLRPJhZPA8FuxvG6YaC1lfsHDT3x4xB5XXLdMOi3v4/ta8Cy8GMuN3uROGiBW0vA8s08GdpXUVU4OYO7S/21NlIVCSW7w4SkHOHEJnsMMa6PvqaVnlFHkbQBrBKA8odCTRb6rDDzQ4uUJDM46hgwn7vwD75qzEiyD+RYssqfbn5bx5CCCB7rhCc1K8XbNl08rotQprErqtxdPd1+6N0+4p14hGY9R7GiKWPvZ6hdu6NUPiRsFBLo8oewqMPUmqqNFKxEPP6fmmai0bCB5K4QhO9HXRTpR3
 nbITrS5F
 eodA+WHcduJ3X7V7ZSMzB0kZYKNlo6dKCrmtbi9q0zpfyfF8rNCV3EQnp30wXjY0jCoV5YLybW9ZAxxTCMInz5ZcZ9guAfL5NxTNrj0vJzQIblSoE/mqhqZtfg0lq3cYO36reTQX5xtRxspuZA7e/mmgUHphydetp8v3gJQGOj0oqOuKowVBUdT7e+CrMVkovk3M7shZ9sg4ZkgLnzTr10FrU274R6zGDAtOrpAcw7U+yD4MzzO/MbkATgaW5PdZB5Gbj3zS7ZpRB6W2uL0g5bvbZrW6BQS5x4nO85txkK0na4yq0jhu5osBHKFYTfvzewryOwCrCS5YOxbWIMZmPjdEK0YB54AHs5DOXO/fZauhGUioo3PM9Vy9CvybAKMZgmKjFPcjzNZimZYLlBypt2MixLJKJ3Rht01zmXCTRiLZRZRZ0PeZ8anMQh/SOHJ809YfnOT4IsIGM/lMd0tYO8A4/QgOft8aZHwmtOX8Xhvv78KqUJFhedin5dWX73AlWBNKXuKQ1jJjKsXKPFC8jjMfmNr6N+/RuFik/rzHu9ZbIKq9gI+H1EIk2uQ==
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
> 
> [1]: https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/config
> 
> Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
>
> ...
>
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -136,6 +136,7 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>  	return true;
>  }
>  
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
>  
>  static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
>  {

lgtm, thanks.

You provoked Sashiko into talking about memory corruption and kernel
panics in page_vma_mapped.c.  Usual stuff.

	https://sashiko.dev/#/patchset/20260624082359.2869-1-richard.weiyang@gmail.com

I'll cc likely suspects but boy do we need a way of being more
organized about this.


