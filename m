Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43513C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 09:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26A106B03A5; Sun, 16 Aug 2026 05:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21BBE6B07FC; Sun, 16 Aug 2026 05:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131846B07FD; Sun, 16 Aug 2026 05:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E55546B03A5
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 05:15:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74AE31C1825
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:15:31 +0000 (UTC)
X-FDA: 85106574462.04.BDCB252
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D36641C0002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:15:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lVgxsH+k;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786871729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VGe88VAgYCJFGRjViK7Ut9gr8nKRTBvPXPBjJG3Wcc=;
	b=1yXIOIiqP6tiS1Ie4WtnqERrCgfTaFXNaUw8go0XvumuRwaBt/2sJnUnaovab8WEJ68bPt
	aXmqbwvyNBVu3hEx4EbF+xsSOi+esDLzP4gBM4bSOeowtilBEheR+LUsA3VWqAnToE2wxl
	GvKrgRwxqTi4wL9Ms15ThYGKzNMBSdY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lVgxsH+k;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786871729;
	b=w6HW9+YI6WdicHMXbziAgsWIZ5x7qU4cp0CGVKvUYioAGbmsi+c+EvOh3+rwG3yqVw9cLT
	uHjcYP5vPawLgJu4psdoQvx8NiWCB7bpc3yMTdbx1pHOvYNBI1usezFCP4mWwjyqqCjAyy
	v/46we9+gfPxkSh3gwfPXa73MS6Xxq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04A5E4178D;
	Sun, 16 Aug 2026 09:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9134F1F000E9;
	Sun, 16 Aug 2026 09:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786871728;
	bh=2VGe88VAgYCJFGRjViK7Ut9gr8nKRTBvPXPBjJG3Wcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lVgxsH+k0osth/xM2LJKAeiCBWztelADf/krHPlTt8D3crtjONIb/b4yVelO1OK49
	 EDxFptWQ05JYmd2xZIy9oC5cPLpuK1A6bzYylLM86CN5qI7kIyHeSt5tBGP78PAGcG
	 psDXjlVZZfLrZwPh+b3crqrr7/p/bvs4pRanOMcBbEYa89Ag6AVB5KM5+iFzyPTekX
	 xK3Fe+jjPQXrAvE2YwhMG2uL89F9f5PuIpibEmsLEn3GEoTNAiMzDZO20kYWVZnqgN
	 V5fPacuNF+444XAaIf+WC5qAjSypuUdzQFZHyExvFI2shLenc1iuy+MhloA9g3JG1h
	 bRJE5xUgCMGDQ==
Date: Sun, 16 Aug 2026 12:15:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Foxie Flakey <foxieflakey@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-ID: <aoF_qmSHiEgujaH5@kernel.org>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D36641C0002
X-Stat-Signature: 8fskxqat1z6zkfue6otrwjxra7gbkb6r
X-Rspam-User: 
X-HE-Tag: 1786871729-831307
X-HE-Meta: U2FsdGVkX1+hWZttNa7gR2T8iwiRlnyuxqCwBtRyPZKy2F6NNjgZhdrcRiSxzENvzHN4+oUwlct/LJsFW24rEpVA9uYZ7dYZzwWoOhgIZh8e+enf/FAf+eMPdfFc4F3tWPIM+vMRlAwWwjJMHWNz9L7sKKclzHoTJK5XCqeiOIF5ntLG6A5ObqW17st0QPJ2eWfydZxDiVtTCSGZ/l1SniqtcB1bkfTT0amioTOcPiCqFmkhVNtiObHyh0+R+euvSh772uVOmzQpkeDHbhqDbXD4or6mBhNQ+JGP2+B0fF4OvFrEPwxh3uaPxu97NvdOQAsF6O3I47Rb/hJnDZczQ8h6hQgrmlhRQS6uDucDLx5ZD47CzXK+5DObyxmFigA6c0tdTjgu/Knh6y4Sky2VqsdKukPvDg/TPmuU/N9ArpF2UvUMJvk4y1CLtoJ45vt+KHakaUdEJFeeacUbtAYMxTEULrAoDCIHVdz5dJNLdwyKZ2URAs5+aps9ZV8eWtPFwJao5CZ35c7yYjzHp/gmwoRHlyTsO6t/eNkU5edgXyuj8zDwM2ODOKDVbC4/m+eV6Yk0yXeFgsJV3G5NiQ6rnUT9x8O3yc7/193v7RcXuyQyk97T0hhhrwURj8j1koGW3ZLj9ga5r2hc7GQV49FS59RTCxwuZC6KjUUamwxNoO8G4veRlQA7xyk69HGAtQhxtxRMjbOVPfNbSOjGGtxdvs5x+uvpBRYVBkEhMh3LUyHOHXKQDW0DQZkOocWuBk3wD4zniq+LmreATdlNEc7MOLPaDKVRN1Oqb42Ib/VpfztCSkpBAYh3lbBPNListmUn0NeW++TL8FNBMsVhup8fqW6dCF7zimhawbR51obMxmMaO/Wc7AoXhyE/JUpzlLe5JREiVqaNVpHZFEGkcj+jMReVAogcj6DIG4XnjR4OeoUOqy7Zvw0ZrFjSBwZP2kPFnbQrjKlYopef4/HN7Bz
 aphj13DB
 b1X+iP37sBS/MCMJiH0Zqg3Eq9OUMj3AECJWci7ffiDmoZLmCIEI3Xc+WXFtV5SUxiwg2akuBoFEXm2Z1X0khhWo23fXuLdz2h08pTrMrkAwDdzsKvbAqoL9b786gwiV570wZdt5r5lh8mFe+bYpn1A8NfqIiW9d6fVtpuBxKxxKd2yiHshDwyLgiT6AjFD4AG2mds31RV2H4UlDuUopEl9rc+oqUBicRGGAoB7mF8FWv8zufvnUW28iSB8Y5MguGSB4Br9lMRRR+bztl3VDf0p5/gm6K0un3QAAn++93zia7x7AXJkYLCWU5Ysf6kVTk65yY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(adding Suren)

On Sat, Aug 15, 2026 at 05:42:12PM +0700, Foxie Flakey wrote:
> 
> An fix for edge case can occur if move_pages_ptes return -EAGAIN, later
> when checked and it is EAGAIN, outer loop would retry again on same page
> and succeeded but the err isn't reset so the outer loop would think need
> to retry again so it goes back again and move pages again. On third attempt
> move_pages_ptes will fail because it already moved and returns an error
> that is not EAGAIN when outer loop checks again it sees non EAGAIN so it
> dont retry and break out of loop. When loop is terminated it did not update
> the "moved" variable from successful 2nd iteration.
> 
> That behaviour manifested into this at userspace
> 
> Source:      [ .. unmapped  .. ][ .. mapped    ..]
> Destination: [ .. mapped    .. ][ .. unmapped  ..]
>                           ^     ^
>                           \     Kernel moved this far in actuality
>                            What is reported to userspace on struct
>                            uffdio_move's move field
> 
> When the previous behaviour is
> Source:      [ .. unmapped  .. ][ .. mapped    ..]
> Destination: [ .. mapped    .. ][ .. unmapped  ..]
>                                 ^
>                                 Reported to user space via uffdio_move's
>                                 move field
> 
> Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>

Is Foxie Flakey your real name?
Signed-off-by should be using a known identity (sorry, no anonymous contributions.)

> ---
>  mm/userfaultfd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index c3adedaaf7d5..595e7e232f90 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2069,10 +2069,12 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  			ret = move_pages_ptes(mm, dst_pmd, src_pmd,
>  					      dst_vma, src_vma, dst_addr,
>  					      src_addr, src_end - src_addr, mode);
> -			if (ret < 0)
> +			if (ret < 0) {
>  				err = ret;
> -			else
> +			} else {
> +				err = 0;
>  				step_size = ret;
> +			}
>  		}
> 
>  		cond_resched();
> 
> base-commit: 62cc90241548d5570ee68e01aaba6506964e9811
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

