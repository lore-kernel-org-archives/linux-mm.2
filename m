Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2639EE937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 18:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5646B009F; Sun, 12 Apr 2026 14:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D626B00A2; Sun, 12 Apr 2026 14:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792FC6B00A3; Sun, 12 Apr 2026 14:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0FD6B009F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 14:18:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DDF513BAD8
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:18:16 +0000 (UTC)
X-FDA: 84650713392.12.7E1BFEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C34914000A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:18:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Nk+5ppuS;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776017894; a=rsa-sha256;
	cv=none;
	b=wGk6LZOVn1GLcdYgJ8TUgLupyMOcn2bwYvax6gRvRiMVKqdSh2q2K2bTKv55obGtsoCAAY
	brQiHYsPC7rkv1KXR5R48VQ1X15xBPa8hmbBcqYtVOdAhHGChEtNdLztjFepLnJ+zt3nDU
	/SToNWjQ6+GyL7NH3vhtOy36/+x0+is=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Nk+5ppuS;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776017894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhUcROqYVrhOp0c7BPI3Mr2nJ+x4p3JfQhJngMhnVr0=;
	b=aEgLJYqlRKwaUJ7jCt+hdhzizJ4odF6xCAYMZ29k2Dqj0/CocNSiXkoHdcmFMgwrudAvyU
	/06P4ptlUqfpCrfNTE33Top4V1RybqnuvhsOasb89Gls86KownOYQ1gsVnuneyq7GMt5+b
	DdHgt/usrdLZIYCJ5FukJiKMkUECPh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A723860142;
	Sun, 12 Apr 2026 18:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258D1C19424;
	Sun, 12 Apr 2026 18:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776017893;
	bh=m1HogzxVR1Ef4cOOJK5L0Qa1mWVjgFEef8ioM1/IH7M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Nk+5ppuSiTQeOq2FwCiWUDwzwb6fS2FZt8aspI2LcvNSvaBff1TbkFAbLbyo87Ij0
	 D9NvS+5xY6CReMsm/7eZmA5kqhh8ogR4ISpfEG2oA4RmZyi/wE4L2lBdhzkaRNd0N6
	 2zpiR/sjIb4YnbRapqjHmXNpLVonvjQOFORS5VUg=
Date: Sun, 12 Apr 2026 11:18:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 rppt@kernel.org, peterx@redhat.com, surenb@google.com, aarcange@redhat.com,
 stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: preserve write protection across
 UFFDIO_MOVE
Message-Id: <20260412111807.42c3edf86d19528d7cb1bb7b@linux-foundation.org>
In-Reply-To: <20260409152822.1073083-1-gourry@gourry.net>
References: <20260409152822.1073083-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nhqh3e9qfjd9e1j9n64bqo1jgoe6bjjm
X-Rspamd-Queue-Id: 5C34914000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776017894-559833
X-HE-Meta: U2FsdGVkX1+/UDWhTIrC0JI72XurMPMRx8DZNTNBLA+mvRBCgT+2J3sjW2Iv/2lPXLNPjjLsvYTnGcGqFdT1TG+UZW0YjzzUKzX4XW9W/QFRcEt2xHzA5x+JcBmr+KTbFZKjr7BT+m9QxjeOGsdIcOJHEJEdLK6je92i5oVae3JgXf6WBv7Wq5ohou+wq54irnVLRmflRHuIURIAptTylIQxGBBM81EqcrMB91ObLJCelmX4gnuVIa7oie+43Ayfsn6C2IqVbC1OxuBb7m+KtcJYwifcFKtlBSw6M37laBLrheXOxMHcSslp0u4FR57QSFbjxAl18HqVK9jHd9rtmnZvi0Y6iTIOqL91gdaX19IcFl4zzpmqP1Uv5DernafmFSLqKWURy0K95JjeJaeIEhN9apNrVzliyic60+yjKEzRylcswN+e/dzKQun9m664xnRGVP9hHL0es93K1oICqumA26hTCVJ1AKGTmDnLTkWARycBm/Y/1t4eA7ZaP0Xw8jO7Io01GRgl6+LksjpfA2MCOBC9+Ir+z5cFGTxMF/IMyorhBr55lArwdzi/Jhcs/MpY0xQIeImNU9mitIbQbxCny4DOZjjfgGHizl+yXQDmC8+9mecjDMwh5v76gFf3bAVbl+v2gGsbx0t1XqrcWtwpmNrTke2vttZSr9FbzzeVjO0k40iXPA539PQCYGg8YBIIoyQRdZQi92ZpU6JkkG+ZaBGVybSZ7Nz1DNYIEL9f8xeylL4dREePctqyf1ODuCZmSprvotyv+tsfYA/VEB+QdR4bLpi+3E2y+dHMvP4zoNmjwNCD9VI9HAYzhRF6dFitRBK9WsDO9QjPNRHv59sj5ZuU9sfvORoWyLIGOvDTTB8+LmOFjbBfvS5vrKtFTnOS/qAQempADNj7jB6uZ0pB2kKVRED6DdjoA1P8X4KgFuh0IMmRXuKgYSeQxDfx2BsB6rYLpxJvvVARk27
 Pm7aHvwT
 BKjV2KteC/LMUHjby6e/5Gqi7h6N2nczqTfEK5vLNnsJ1Qf78XcNPBlvCtNHS3LQCMHbR1ofuA/pKi1PVPZrTWsVsbUq3Z3bSmK3CX/EG9ZBeKhYs+3L598a3WDYomGeGCdiSdUAPJ3LFqtYvPsFdLS9kMSIwBKPmVyXoubU7OjPm5ol1A+d4MGbLudjq9ODirElRv9RI3C5OsBC5CEn0gkF6zgJTlf/FMEeXdWr83HY1ZBh01JLp4vl8fVMkNWxtTVKeAYq1/uIkuUIYd/x5wqpp3al6efBgwD3yF7x7frwcyhBITLdvGHHwQ5BR13Ibvoq/zexYPhKvSo8TwiV9osLFY+zBYG1XI94uIeRc2i8N5w3fWwG5r+3RDNkL7hjYtaY4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Apr 2026 11:28:22 -0400 Gregory Price <gourry@gourry.net> wrote:

> move_present_ptes() unconditionally makes the destination PTE writable,
> dropping uffd-wp write-protection from the source PTE.
> 
> The original intent was to follow mremap() behavior, but mremap()'s
> move_ptes() preserves the source write state unconditionally.
> 
> Modify uffd to preserve the source write state and check the uffd-wp
> condition of the source before setting writable on the destination.

Please can we have a description of the userspace-visible impact of the
bug.

> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Cc: stable@vger.kernel.org

especially when cc:stable, thanks.

> Signed-off-by: Gregory Price <gourry@gourry.net>
>
> ...
>
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1123,7 +1123,10 @@ static long move_present_ptes(struct mm_struct *mm,
>  			orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
>  		if (pte_dirty(orig_src_pte))
>  			orig_dst_pte = pte_mkdirty(orig_dst_pte);
> -		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
> +		if (pte_write(orig_src_pte))
> +			orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
> +		if (pte_uffd_wp(orig_src_pte))
> +			orig_dst_pte = pte_mkuffd_wp(orig_dst_pte);
>  		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
>  

(presently wondering if this is backward compatible)

