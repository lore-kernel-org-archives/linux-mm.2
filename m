Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB781CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3E46B0494; Mon,  1 Jun 2026 13:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264B66B0495; Mon,  1 Jun 2026 13:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180536B0496; Mon,  1 Jun 2026 13:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06F526B0494
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:55:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B354C2610
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:55:45 +0000 (UTC)
X-FDA: 84832096650.16.4007485
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 12E1340016
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:55:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BaFRfgqW;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780336544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1uP6wM6n2zIqzJIdRb8GLaszOovltVtTL4/EbH3E+E=;
	b=xwzFNJGeLLNLig3ij3rK2eOxxwgf5c3VRAFNHyBfB2RiOeu6TkZeTxKM8T6HMg9nkweyQ2
	CwG/ljrHTNa246+IFzbx94Nm3secSMDWNM/k/SrwXffuNvyBw6xl1THSO7tcWNqpgjMiHk
	jEWODC34tgwyKJfqQkBI2wvJd0Z2ilU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BaFRfgqW;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780336544;
	b=OL5Mx1WAmw8dMp9SfAXEkll1F+EeYOXHrfglUmxrhL+/G2C542SmO2E0j9j/VJXo4AMKTF
	//RQbGASXPrdHMox2TcIH0PZNItn7SrCUsGFiCSHvjT5nx6Z3AXlwxTjx1PMB984PcAV5m
	KRH3LInco/SXnXbD35txaM70zb4Pnt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8037D600AA;
	Mon,  1 Jun 2026 17:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4540E1F00893;
	Mon,  1 Jun 2026 17:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780336543;
	bh=U1uP6wM6n2zIqzJIdRb8GLaszOovltVtTL4/EbH3E+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BaFRfgqWdvMM76xeNkgTCsFwms92DF0Ho22NItt3VT9LuxmUq+JH3+7ySdKiXfb4k
	 34lEr+SKqJiYztRg1oX1HRJ9oS0rbrC9t5G8Y8J9uNcsFicggQdyiNvT4yMpybk+yt
	 oW2un0/6/Ebv+TYEpTfHhkX1yeidCQR+kcRz2ytwz/OsW5PjJGpL89Hta60QGmr9Se
	 krjWY+l2WFrPoovPeCymJrpdWpFhQHHN6UTD7N2IKJtipBY6nIozTOwR4K5HVyeSO6
	 0fk2FlgLQqTv/20O9APW80fOKTyVKImh0D27jjkXtc8fzL30+Pi/Q6fEQFOP3YYyQH
	 jGnaTIz0PqPQQ==
Date: Mon, 1 Jun 2026 18:55:37 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, stable@vger.kernel.org, 
	Sashiko AI review <sashiko-bot@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/6] fs/proc/task_mmu: fix make_uffd_wp_huge_pte()
 prot-update race
Message-ID: <ah3EQvQ_Ja6AJqzF@lucifer>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-2-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529172331.356655-2-kas@kernel.org>
X-Rspamd-Queue-Id: 12E1340016
X-Stat-Signature: ocqhramthn3oew71zzxsedudck3gancy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780336543-264405
X-HE-Meta: U2FsdGVkX1/KRvZ8O5q7NHx5d1a1wQIrTLwFGny8fc0FAhCubpxBBG2bv0bvFJI2Hq38BKO3DscjuMYULxNkTRU3SiqAbc0j/VgvK6qA8cZ4rryu3XVsfoxDvxTg5PS1T8ThoGA4l4ViebXCCbS1yRTzklRfFfiJIgsviHeh8YKQtLIN10WORAuC1ckwhIPzCrFJWP+4njV7AxdN5SetWqZ2/5HTlRETLlW8UZZBmqjG50sQtcyUMNK3UFVND62b3hj8Jl5/KJSLonMWfWfDamhXnARnM2jp3LW5JMaf7vxCrlsIxyrfXJyquHMLsR96cRm2s+X9LAa+9CUdZrHZ17vkdZ2BGNgEg0wIyZSG6U71aLzmLu+r+3fOeWa3CuEP5jsHpmREQMJAgpYiZlkJzfUzBsEM6pbfbpGlX4VsdBxzXlUO1/aO6P+/yruJ6QnYByWOEXiizin4IqNE09Lx7Jy573Mcky6LrwmUxqG46WpVaGPgdJgxXDbW9votUgFGtgGacpeHPjYiI2mZWJhkUVOgG0H3AyOVu9CRbdKoXvzizIloyA2DQHLcsD7afrOD3f7w+v8+p0YQyUAeHqBSYIQN0R9SzcdqHZiM+pNuutDiSFKwvZS1EZEQMhX6kntvk4i9dV0TcO3yFG0v96jm4UYb0pP+zK3j+Cu9VHRafWaYXDJMB9bTCrJ7X595CfNUJrQf7+sZmCrHbZ+IfwUPwICAby2WdcbwE4aYXv5DFz+KnyfdUbXeAX2aOM6arX1GaHMDmXDioXvu2D4F8KsdZ7cTI4DLSFvSfW/x+oPJGeSIdNEGG6nDN6rkcWpG1hkxp3SDuyNhIgRAGsS1YNeMoYI3qWtNru1jxypkYWC9tcfKLtQXwmhdI+ZRlwW2RRFEaNp0DlVH1BYYb/EnM+da42FZaIuWPwZw975ryh+HyvC7z4jfkGLYtsHicw/8d39gClcrl4OaOIuHvIXIDY2
 zZ9KwKtd
 zL/qos3diywcBtlhxZG+SNeuZrQvrP6IglGgKP8T1rDciGszdUqXHrzGUp1ho4mjl9FO4+XC45lkRX5cy/QMFfL5B09y8BNLThJQ0+aib2g8W9WFa7rywp12NPr5XypclKm1ztoSLsTOUOESr7rvsKV2u5Qo1daSoTjpmClOM/msnKy8WLiI0Dl5QaD3Wmsw5U0AstvtA7/UGpn9nYbUwRUCbivaCboEWOXEAT7lvZ3g5DNXvzs9vw+p7qyopdWQuOnyEjQgo0rgcExuAtG0UnWeqkJA91zGOCDWbbMZN/FMcAz8PvoRTX3TsuKB5zptfzn+g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:23:25PM +0100, Kiryl Shutsemau (Meta) wrote:
> make_uffd_wp_huge_pte() arms the UFFD_WP bit on a present HugeTLB PTE by
> calling huge_ptep_modify_prot_commit() with a ptent snapshot that was
> fetched without the corresponding huge_ptep_modify_prot_start().

The
> start helper is what atomically clears the entry so the kernel-owned
> snapshot stays consistent until the commit; without it, the hardware
> may set Dirty or Accessed in the live PTE between the original read
> and the commit, and huge_ptep_modify_prot_commit() (whose generic
> implementation just calls set_huge_pte_at()) then writes the stale
> snapshot back over the live hardware bits, losing the update.

Very pedantic nit - this is a mammoth paragraph :P maybe add a linebreak
where I did above?

>
> The non-hugetlb sibling make_uffd_wp_pte() does this correctly via
> ptep_modify_prot_start() / ptep_modify_prot_commit(). Mirror that
> pattern for the present-PTE branch. The migration case stays as-is --
> migration entries are non-present, so there's no hardware update to
> race against.
>
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")

I wonder if better as a separate patch? Not sure what Andrew thinks about
it, I do recall him complaining about separate-hotfixes-as-part-of-a-series :>)

> Cc: stable@vger.kernel.org
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 1e3a15bf46f4..e21a38ac745b 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2610,12 +2610,16 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
>  	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
>  		return;
>
> -	if (softleaf_is_migration(entry))
> +	if (softleaf_is_migration(entry)) {
>  		set_huge_pte_at(vma->vm_mm, addr, ptep,
>  				pte_swp_mkuffd_wp(ptent), psize);
> -	else
> -		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
> -					     huge_pte_mkuffd_wp(ptent));
> +	} else {
> +		pte_t old_pte, new_pte;
> +
> +		old_pte = huge_ptep_modify_prot_start(vma, addr, ptep);
> +		new_pte = huge_pte_mkuffd_wp(old_pte);
> +		huge_ptep_modify_prot_commit(vma, addr, ptep, old_pte, new_pte);
> +	}
>  }
>  #endif /* CONFIG_HUGETLB_PAGE */
>
> --
> 2.54.0
>

Cheers, Lorenzo

