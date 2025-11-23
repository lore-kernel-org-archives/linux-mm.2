Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D15CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 09:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA37B6B00A5; Sun, 23 Nov 2025 04:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B4C6B00AA; Sun, 23 Nov 2025 04:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C995D6B00A5; Sun, 23 Nov 2025 04:29:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B46866B00A5
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 04:29:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6537D140B1D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:29:16 +0000 (UTC)
X-FDA: 84141348312.09.1CEEA43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4C5C180004
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:29:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khHRGrer;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763890154; a=rsa-sha256;
	cv=none;
	b=MPvEmU1LeTrfFORXyWCLOjg1R8GNciQeXmWP4nXADIvhP6VkN7pAO2YeAIdUEQ6THBTwbl
	2yYX4mxvwIMReJfNgnmWNpKm1jnMF5K1vEX+C9pHtnDQ6/o3bfZlV9lgTYuQjcfjr5oawL
	ALqul/h7uWHBiqzAh99p8MCZbxz3o6k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khHRGrer;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763890154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTn9qJIq+mYgVyaCUq4ZKMpQcmCFxb1ZUQd0WnibQp0=;
	b=JDizuUZTmXajFkBWymOqrMvMG8VXCIj7Wt2CgLSHSu3dMoqQRMo5UDecq76TgnkkOdVHQj
	6Z5yPwydb9VkgRNkFtJwGmIqEEQeE3wc6dyC/pPAR0TfihbY1MPhAgmQBczumDiGwA+q8o
	eiDoFfD6J3JjJeIlFrmuC/JVsbsV7bw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9861340E31;
	Sun, 23 Nov 2025 09:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9630EC16AAE;
	Sun, 23 Nov 2025 09:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763890153;
	bh=BsCF5Vo0XWlxKJ/sd2YtUXNzzKo8ijMIlbF7CAcmddQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=khHRGrerO0B4QAeiYUvcoYrCRZ7uhsJTe+ITJfW9iphjYhW1N0sKuW0fM2MRwJw5g
	 l5TQWitHCTush7XpYYXn86yoAgIkRd9Jwskf2hII2lEiVCE7zf5OOfdvlMrwa8vZjW
	 Ik5A1AzJIUJHNbsmi9XzwA+YcND1G9ACaXTYc4WHni5+e1Z1jhbXz3uCmnpCgQ2m3H
	 xVSHgwZBltr02JD/bKnR+CeUVLQl/hSqnsw87N+adQ/1gUneAjaJhpHJc+n/0k18+T
	 x1fX5UifmLzM5F0ekSp9B9Kvbm9Hhy2/LQg7y3Qe21gYlJvr175L8foN4YrQkfmFk/
	 c90tmT+r9YtYg==
Date: Sun, 23 Nov 2025 11:29:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, mhocko@suse.com,
	surenb@google.com, vbabka@suse.cz, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, david@kernel.org,
	akpm@linux-foundation.org,
	Vladimir Davydov <vdavydov@virtuozzo.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] pagemap: Update BUDDY flag documentation
Message-ID: <aSLT4J4UNh-0xiXN@kernel.org>
References: <20251122211920.3410371-1-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122211920.3410371-1-richard@nod.at>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4C5C180004
X-Stat-Signature: kwgihijpeguqpk4kzo9e6ksjw4dei7tc
X-HE-Tag: 1763890154-474046
X-HE-Meta: U2FsdGVkX1+I85gAeCepunj/TbYLEhRwo88CFSDaMFx4ZJM9tDOUb/y1OIu6clQM7Ie8tgmEB5wNUGL/V2bSSZEUY7HpNryWTPgmxxeasd9IhVpSBU1mfKVrid2uENLa6rSP+/vkT/tPZOvrMLqfphJAAATl6J5cA7FYmK0FhWRmIypR4E1Skzka4X01VtDxyDwYwbsAB3tcCgt6oD61/TJuyA6oBvBkIP1ZAJnk7yHJ82ZynAJzcTF9kgL2+jMaIQR3FWYMPCfJN2EnjkB17klUVlYmvoZYZTMxvdqZnJa9K/QcIrBkNvYgCNmo7CabGrl6y6X2qBbPZPFR+7GfwHC9/I93EZgtUQuI5UkN2wOr5gAVZbWFQQAi469mgkvm2fqNUMDY9fWEDOKsNQxBWd2wQX9ZyahQB3/P2VN0lHHvDdGglRvbR/0tTEcWVoC/xUHZFLSCm5pmFlBNfs0vHKKeQyWTcg1srS9KxZcHecpkP/XN4r/vaqJbpk5huejIR7kGbj/87Nvd2PuCrmdRHPHG+uYscKjHXfJIXSJwf3PalSaRY1DqCuBeeVoztw+royO+drGqEb2MrQ/nrD0WVvMxb0QBvX35i33VbEOfHyCO7SGQMHVZtOmMJLqMyK5TGS58lTuDXVNuLttoAVfPdUZ6nlr55XohIUmDPsH5f8z2gBzijgKlmP9NCs/bOAxQuPnoggRxgnlMMkCLx1s3IOYMDjKV7DZen7uK99Tfmicq2Ai5PkGHnsiAtxgTKkH0QCEjjjTkdg9PWIJFxX4CsGiEPC2VBX+87tDP2Oxifqc2501N5zhYqh33LNgozDPYa35/XM/A7+2DDiA+yaNH/prBd0vK/Y7YNj2xztJciUG++IRpA7piXCCFoA1asddYWKQp46G2mNqFpI21vi8MwtVj2Z6lnoURomXwqcW+lPvb1UCtsTnaCaJpTJMNG3+oTFeYlgvaeFfSHpM0Sjw
 6u9phhen
 yaDrqTVzNz+6DpTOE/quSVlrAidcZRpWqVoGJECW1T0jILZGJENg9V2Sgl0yRvjLD6/zx5IyGHwo+PgWYdKDzk2AoFJawB6ikjkqq2uffnHIqMWOLBhk4dKlEfCrPqNEmb/5OV8N/Wxp8EXOvSV5VUYJL4LZj2jpw0yreX1K20/e5N3rZaUeMi1LIF+KYaANNkORIok43U4dRpN8EHamPbAqCsbfRUkDnqKzB3DGU1Bqx+PHm3RRwish2oqxtbkEVSsolqFvOeBh43qO9ANUJetNCtFQ5mCGEbIJIptpumtFpLUKM5HYb7QA3K3HeE8UBLQomXzI/N6QE+EdKBZ2eK2QxO1A3t8v/7xUDoBlNqF+3yfJLUH2opSsZlhrLT5/VudHdOv9jZyAg096knkXCdFTdeD+Ae/Y7i3mOC4i+qBy0sTFyLUp5xMA4eHeadgO2NafR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 10:19:20PM +0100, Richard Weinberger wrote:
> Since v4.6 the BUDDY flag is set for _all_ pages in the block
> and no longer just for the first one.
> This change was introduced by:
> commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for "tail" buddy pages")
> 
> Strictly speaking, this was an ABI change, but as nobody has noticed
> since 2016, let's just update the documentation.
> 
> Cc: Vladimir Davydov <vdavydov@virtuozzo.com>>
> Cc: Konstantin Khlebnikov <koct9i@gmail.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/admin-guide/mm/pagemap.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
> index e60e9211fd9b2..c57e61b5d8aa8 100644
> --- a/Documentation/admin-guide/mm/pagemap.rst
> +++ b/Documentation/admin-guide/mm/pagemap.rst
> @@ -115,7 +115,8 @@ Short descriptions to the page flags
>      A free memory block managed by the buddy system allocator.
>      The buddy system organizes free memory in blocks of various orders.
>      An order N block has 2^N physically contiguous pages, with the BUDDY flag
> -    set for and _only_ for the first page.
> +    set for all pages.
> +    Before 4.6 only the first page of the block had the flag set.
>  15 - COMPOUND_HEAD
>      A compound page with order N consists of 2^N physically contiguous pages.
>      A compound page with order 2 takes the form of "HTTT", where H donates its
> -- 
> 2.51.0
> 
> 

-- 
Sincerely yours,
Mike.

