Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97BFEF31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED086B008C; Thu,  9 Apr 2026 11:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76DD6B0092; Thu,  9 Apr 2026 11:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65976B009B; Thu,  9 Apr 2026 11:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A25276B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:13:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D16FE2FE0
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:13:28 +0000 (UTC)
X-FDA: 84639361296.19.68C1C95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BC6EF14000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:13:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l4EN9yu5;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2QMlCtoKLpXskJ5NNcUZvHq8w4T3y66tEiAUyTFkpw=;
	b=6BYlWvpz1lF4g8hNS1pZeLAQ5bI71fqgySZs2vJ2jkCEtv0wvzq4PfPnEijd1MQMuB2zHD
	4OaqzF7LqsqA639Ywtkpx2rOosRNl+U1vPQbEjSTyfRbCN3JCaONaiZRNZOH1sq+Mon+OO
	SUivPK3TYAMb6FCRcC8Vj4nRAr8MVr4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l4EN9yu5;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775747606; a=rsa-sha256;
	cv=none;
	b=BlkTWC3lUDRbV8aNzeaknhto8bRjmKmKcANWsWNM3IEGfpVlA8ViQ2jNxEOPRnsei1LfC2
	vfpyXmkKsWwBrGEzPzxT+15HgCRfAhn73mpxNJcGe+UkagsqNyFqwV7g4U0aisbmebGOfY
	i3VrYTBMaQucLYzm7PszYofy4fql/FU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CC8043332;
	Thu,  9 Apr 2026 15:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ECCC116C6;
	Thu,  9 Apr 2026 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775747605;
	bh=owesWMMhEZ10jRbXPNEnxMG0zX+QmTfFOcYuaS6Uh0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l4EN9yu524R4fMKtvtcTuJmGimqWFPvuyMWu5Y+SlnHXdSp+SHpy8AtM2EXrf1522
	 rXrnFY8/E5aAHwDVA0tlaQk+rsUzOydQolkX2P8gn+nAHCetUtkzB2mxwLJ2dWaej/
	 SevoiQOBFet5p4dBRVg3GCjZ8t6KTwvFLfgV8O48llfr3A3yO2Kz+JlIzNhP0uDSw4
	 mtdrfqI8M/fsL/wa33uQffEvI2UxZtt2/8BOTJeLX2Tt6fimxeCAfaS+gAhC71N6EF
	 ZUcN9x87gzSTFDol4yR+vKH1kft72K1FWXfiSoOlNpzr310/3F5quZSDr++OwnN+2M
	 u5BEbnaY47OpA==
Date: Thu, 9 Apr 2026 18:13:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: harry@kernel.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
	peterx@redhat.com, pfalcato@suse.de, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	usama.arif@linux.dev
Subject: Re: [PATCH v2] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <adfCDR9Rh9p6aZun@kernel.org>
References: <20260409103345.15044-1-komlomal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409103345.15044-1-komlomal@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC6EF14000E
X-Stat-Signature: pzxusips5fsfbap4dxgihfqiee6oxbjg
X-Rspam-User: 
X-HE-Tag: 1775747606-789791
X-HE-Meta: U2FsdGVkX19Gu0n1+udsc3C9InZH/VU24p1fxpiV5akKxU5Ubdn6VVn1Cac8sa6DDXRTKxy5+kIGmMW1y71UD3dU06w30ja04AixMLJhS2k18V/A/EA53O1N+6On7zLxNfxOoR1VxotxDQ8ISfTJ6yEFFustu0JxGvgrVyxgQXNsodzZipv11C0NqEwSnXIOFH2JR0s+QbXKCtdni62RY+5Wo4HQsEInwg5IiwCkXAMVqPdvlUanbIfSOGvOHGRypn10kpwGAvTkYnbWd2wOgUEv0+2p9osr7NIVgZDBAg/FfDPwq0GSz9oGthahJcMWba312ZX0wEn9u7c5Ia75dPij5mifZfvddKawa28X6P/VbcKX93KSc0JbnB5tBAeuulqeFAFeXMxZKi4/PdUFvi7dG8PqmogyxxPWUFTlnUPMG+y3eHLoHrUsYpWIM+TS/OqFrJJ9CLrSx9LrAw0jq8w/x0Y8JxC9iTk69/gzjX79vAraNImPtIEMPshYljXbLHpbNoda2OYtQO5IFnBbLDXUqylK0S1kZ2ePD+RHBkvC6ioZYNGky+M6ER4dxre6AvpgiqzAIwG3ozqJki8RK+NyK8tLxTBc4tQd5sgYSZt3hArfPSLCQ0pqCYBTIxn3xi2rZb28jqbHckA0x77UPGUb2XDLj/UoM7PhO66JmL8YXNuHTPkFf5cRbqvFB/r0QF1tc79LzqAYisOR30EGyqRGhBOBQ+M2UFlH6PKMapORWbCGFKJxYmt1z6Pv8ZRhNHifY/VuOewhReSM1Fz90LUjL87KaTl8sIGnlVjj0QO6gxn884zkjJihWOrhynd/YpQWU7rGFoUbbUI62wbhr8wq2L/3rKWKB9xAXS32ZnF/7KmEw5L49Hq97XVR5PAZYe7Ax8qUlUT40h2Zv9x+5eVTUVe96Pt6YXe2k0rUJEyad55xMW+nWVby2jGrcUVvkuGRIgjfwYIBKa0ONGe
 TOWkABHq
 FPZkJ1yjJCkZ/SqOYg0e1jKAkruDUKLAcJAINy+ywX6FyRzzVRxGMZk6RJDCiDT6ILxR2Xyh2xRXlySoQHAhTN5zvkrhAlNYiZImyjgagCgnPMFfBSLsTLCPnqMqLPV8Gv8Y5N4tFDBccLEEvp8QY3EwHPz5lDBGjo4kmz1bf7F1blXxvaIGf+oAlT+vUw8aHZooulKL6fdY03m438nqukhEjgZ1O2wBhXOVv78lhqvl0eH7VvAzMWBoCkTb/rUtPnI9uxLNlW3fzLWXHV+8/ObyANgIGe5KB+m30scw7aRqsP3Bh6SypZ1XnpRFPi1eDOmyoaAxYSZC654783W4GBiCZ1s5rZqvnkb4b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 01:33:45PM +0300, Denis M. Karpov wrote:
> The current implementation of validate_range() in fs/userfaultfd.c
> performs a hard check against mmap_min_addr. This is redundant because
> UFFDIO_REGISTER operates on memory ranges that must already be backed
> by a VMA.
> 
> Enforcing mmap_min_addr or capability checks again in userfaultfd is
> unnecessary and prevents applications like binary compilers from
> using UFFD for valid memory regions mapped by application.
> 
> Remove the redundant check for mmap_min_addr.
> 
> Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
> Signed-off-by: Denis M. Karpov <komlomal@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2:
> - Remove the check entirely rather than replacing it, as suggested by
>   Harry Yoo and Lorenzo Stoakes.
> - Added Fixes tag.
> - Link to v1: https://lore.kernel.org/r/20260407081442.6256-1-komlomal@gmail.com
> ---
>  fs/userfaultfd.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index bdc84e521..4b53dc4a3 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1238,8 +1238,6 @@ static __always_inline int validate_unaligned_range(
>  		return -EINVAL;
>  	if (!len)
>  		return -EINVAL;
> -	if (start < mmap_min_addr)
> -		return -EINVAL;
>  	if (start >= task_size)
>  		return -EINVAL;
>  	if (len > task_size - start)
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

