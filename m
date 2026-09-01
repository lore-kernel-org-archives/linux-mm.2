Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D8BC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED2E6B01FF; Tue,  1 Sep 2026 10:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676D16B0200; Tue,  1 Sep 2026 10:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CE16B0201; Tue,  1 Sep 2026 10:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 361216B01FF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:05:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC3FD1A0414
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:05:38 +0000 (UTC)
X-FDA: 85165366356.19.A6ECF5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 377C5A001A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:05:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UI4TX5wD;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788271537;
	b=Wfidb4wlH7vh/IA2r29swgLG1d726txp6jeDlE8fCH7IpktkZKyVpIcTOf5U2lveOC0pz/
	aFPto760Xuh8dHOvqa0sf08WGYrgASFclWDtDVgF0J4+YEmTLAHxmVVODqnetGqLo5LugM
	8Fs62evtQLA0AAuLS/LxF3wqoNvDCqA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UI4TX5wD;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcrb6sbDX8NQf4xXudAfBvNwwKe9AztSJMBpfmSsyxo=;
	b=gy3Bc59RREO+zuM9m2RidmFrjQ6D0sWGrMeMwxTbP917Lu3vzK59aJ2hms0PtDCSbWywOQ
	YaWhEpHtxX/HwnHaXI0G26hTflpN9Jn993lSy9ot71yuTMxX8NnZ37+Y9KB1uUtpyTRsPp
	xSeDlILOvEQfBQf5VcQbcsV2PeMxsXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 509B4404F8;
	Tue,  1 Sep 2026 14:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0141F000E9;
	Tue,  1 Sep 2026 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271536;
	bh=dcrb6sbDX8NQf4xXudAfBvNwwKe9AztSJMBpfmSsyxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UI4TX5wDFdPchD1XedrjbbD26i6ZK6ISiCdqAq9XMEM+b/MIXgrjKE9b03bv83i25
	 nz1fDVKIy09MDCFDcZor9KgQtWzfiCFTbS7vsZUcYVcDDV6cEPMq9Ax2GkQ2ekf8ld
	 O174WYoT5WcV5/rg9wl7Ix84GP5ShYP04ueQsJ5asi5YiGBJz+vZ3VCqzh3c6HyRUB
	 QqIWLXKaIQi4VPmIzqtgaYqMzsGHt99c45je3yMSWg/PnLfvR+PuDD6CEaOm0Ze7gK
	 KOdiZCKGq9QLEBj1yO6zPu9GwdrPJ2IZF73TVuRVK/qlYaJS29vb99VoOsDdxvS9Kt
	 s2Uj3CLaasoVg==
Date: Tue, 1 Sep 2026 15:05:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: remove unused mark_page_reserved()
Message-ID: <apbbpAiai6kXuWOL@gremlin>
References: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
 <20260901-mm-remove-unused-helpers-v1-1-f092d086f7dc@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-mm-remove-unused-helpers-v1-1-f092d086f7dc@columbia.edu>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 377C5A001A
X-Stat-Signature: 9tei34btoqk1ziofqye76u98huw353c1
X-Rspam-User: 
X-HE-Tag: 1788271537-126601
X-HE-Meta: U2FsdGVkX1/X7+5R3WQ2bSytAlR8VajD8ilwUurB1m3OZ0BMlYUQJpmHwGZ87XBNV6iE2Qln113scnpuzMF5og73Fp4zLydUK7zolmXfpOfaA5T9ZmK092CL7UaThwAzqQhWjgutK4u0tyqcAPGeBwsYoUc7+Bmm/68tUOPOHhCTZqsDUsQNLuPaiP+yKJ0b+IFs7Yi0NT9dpCDxsSSQFOTRxQ8drpw/DQC74Z4IOeU/5AFIGHPqH7de2+JFCvywmp0ru9eu+/VFVMQL8ZveBYooEFwJKicquMmoukfx6hd6Iy1EYde5/2wrZrcHZBfQrRtPGOymeNTeu9fOuaTnMxZTWDJebJhQi+i4f820pG1uA3IES2oxSSPyuFaz6A8Bd9rt329UfgsaQ6Wh8aN5Ey4uYMdmnqct+sxrEMd8WHHcW0iyEEcsMy4V+emnWCHpwnFMypnvy7BnY3ImjiymeAlwCeQry80kqu5U2chkcYuwNFy/bfw3FKp2oNN0xr6c8CmBhHLOlGDCZN2FI1vqlABI29wz5cm8U5DXZrM7T4ur1ofY4nSNcUyg2Jc1q+v7rButWlpqICM50OoXzyISxjeTjipZbGG5rN0uaG5Bwdsj9N/da9K+5ECjfuBZq5TEoEb3+vrN/Yzu68QG+YQ8So0QXeiiz4TbVlhQ3PMuBTzwdZr2wPeHXG3Qa3W9VvdInfAQTWiESZB4SKYmCvdTqO8d8BAXr43qu5cuSySyfuzkL9jb0pW68SrI3vcLVRjGFgjYdOJ3Razdapyzyk0HzKWaCAKH7bCyr+jtL46ZjTNZ7M8sg9LcQVzzxLzUDM8fTniYveSXyCGk3BQ5NlD/oZDdK3BBsRXwYmxp/ljxEyWbewrIN9UEzdGFphO38AxGbjOq2/04oy/9b93dEy7NloviBCRWtzr+jwyhvo6QnuEWjCmwvXaHB3KJaBlfPiq+wUFjv9KnHivmg4WFgAe
 eE5jw2S8
 GtAuy/STxnTrfHpoEY9u50axoTt4toXA4IQF8AlLX1+q4D9T1sng9CiJ/dvUBPXsTn+Ya1wpoHXT3ylXQ9dhLP4y5IQzO41Pjg25BP7ZsfHslF8lLsbMbCUlEGRoMwcyvMFnnOYYZjGX7upNH0L8I/EwTdkC9xJlLuSFX+pNqnqx3xCLZi8kL+0vnIKiGkGl0MiRo3lok/VU61R8oKj1+oY9a0iCrwQaQtVSvBGJKyiLQv5emU0dstIevauybCeQ/p/CM/9jpeoeJYSFXZiIx3YyoyOw4OruexYoxi2ZoPzqleCA3jOEWT6XpBpr+zIDgmTii
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 08:59:19AM -0400, Tal Zussman wrote:
> mark_page_reserved() lost its last caller in commit 6215d9f4470f ("arch,
> mm: consolidate empty_zero_page"). Remove it.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm.h | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1b28e6fc8d5d..e3736c42c4db 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4080,12 +4080,6 @@ static inline void free_reserved_page(struct page *page)
>  	free_reserved_pages(page, 0);
>  }
>
> -static inline void mark_page_reserved(struct page *page)
> -{
> -	SetPageReserved(page);
> -	adjust_managed_page_count(page, -1);
> -}
> -
>  static inline void free_reserved_ptdesc(struct ptdesc *pt)
>  {
>  	free_reserved_page(ptdesc_page(pt));
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

