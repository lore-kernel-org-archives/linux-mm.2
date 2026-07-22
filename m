Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 530D0C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7B46B007B; Wed, 22 Jul 2026 08:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8F76B008A; Wed, 22 Jul 2026 08:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19BB96B0093; Wed, 22 Jul 2026 08:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E53F56B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:59:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 689C5A0275
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:59:37 +0000 (UTC)
X-FDA: 85016419194.11.BF28E79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D981E20008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:59:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHkqNA+S;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icrLLQhuAoMMBcn0S+gJv4GWVoPCUHqQS5tuhEzj+P8=;
	b=A6na0aZYzgH0fFyhHfA6I88XdKeQ/0NgyPDSIT6XT4sBUw7f+7Lqr+G+mVV5IcURv7jlE5
	Afg88GHMdxQ/R0Wrt8bzBDXJ5dDOlJgQzriMjG1K0KPbuAB7BZvaYp4VfbhFndH0CxffBW
	KE6gPxrAECYitzT2D7F5rpUx6GdPJ/M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHkqNA+S;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784725175;
	b=Df4NfNnd9rD3k5K3xPMjqABUMgxJxcBOYtNJlwvEndtv00TErm7sj1CaaKQ3Ixi0SPxhKj
	CqQQex6osGB8bkfML6hrOIxKPdh3LXv9HJJCs+ZsBqUvWBmz+zNO8S2bk32NeCk01D7428
	V/4l1dBuySiz7B+wTi3sxnBHwOE+8OA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C71E600AB;
	Wed, 22 Jul 2026 12:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF531F000E9;
	Wed, 22 Jul 2026 12:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784725175;
	bh=icrLLQhuAoMMBcn0S+gJv4GWVoPCUHqQS5tuhEzj+P8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HHkqNA+SdSANlLAg1mmyPZ1gEYvTdBupa85eW5aZvlbHeIN/8ANEb6JE8o83tIARz
	 0upwQFZ5qROTS6MK88OcnqPU5dQtXOELCUo1Et2thYWG4kDmO6P+3vfltzASbe4e1n
	 Uq2iA6WwBrUan8Z9HNvB3TdtPrf5a/zd11Sh5z8/IlHvcO8MxkAnNSksVLv1OEh4h4
	 vTvImCvgtntXUIxH6Y8PUQK/VyraFgkS3d8p7hnpZJe5AIFzzz8fOhU1QJAIEQWJV3
	 yRt+Z8JMgX/9hPjywyKAxIJ0ICeqMR0hkUbdQ2V0YblkMR0gOyLzLpCaoPxdhYBXJ9
	 IbIWkpCZJU7kA==
Date: Wed, 22 Jul 2026 13:59:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: liam@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH] mm/mlock: skip __mm_populate() for MLOCK_ONFAULT
Message-ID: <amC9AO3YoSnKewkp@lucifer>
References: <20260722125133.543441-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722125133.543441-1-chenwandun1@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D981E20008
X-Stat-Signature: f4do37u84h9u971xw37n1bx747uji4x6
X-HE-Tag: 1784725175-96096
X-HE-Meta: U2FsdGVkX195f8sffWwMtxnZ0tE5kWr20d0j/jQX4kmTG+qSTKmDwcAtusuTnD8GZOIKfcInWzW5bJl0TB5atTV+qCLD52cz4cYPjIV2dQIIfkmqt5lxPJuRTsDmOqlnOtx9N0Hi9tavWaX8L2tMECEAaX4zfaWt/6xmX7hGWIRlBPLNqWlWVFA0il64lETKPV9zRsR3RXS4rxrOfgtsno5y8Zmo00YByFDyZtAIB4aJ97g0TQ2Z6WBKWJgKLsJP5TK6Mf8xBdGG2HzBfDeeiQ6KpsX2ovBRv+WHhsLhwGiJQa/XYc8Ley7/q6aFl9f/3PzELdKqvx6fHVDR0fIbUkxMl6qxSBqOrjhR6tLVdVv8ZqQGZnhiOsVtEfdgIdioXZQTP6ShlaomBuCz6JznWXU7l5eySEeZN5oJxuR9iDZkrQ2JIGYZO09hU6N0U3E/h19rXbI29hcbrrzMjf1KpzJcvE/hEyoQEU6ypAjLONTtTTBLjOXF8Yfk9RUtt81gCCB00BcRhrjgVQRNFTBbLHCtItrN3OSxLVvK8QtXu0TjN0ySLkaRLv8R839FL2RKwLQhlHbjFLg4X3XRtthKGl5hBclHLFY0yQxtlfLZDpZK+Gcp0d1PdIsB0s2KcjUVpyTNOWSjrMwuT4bv/cZ72EPbjGNFM6uN1jOoExhoLTJZmlHPCCpbfq/ipEFvf7Ec93hYAoTYap6ZwPD+eFA1+lyE0/uN+HZf8luuvshpEvyyZG1ohPL0O33WEMmKIHQA7sPjTWd5G2zRbMjhxMZvTT2IYBOJMbT+zBm7moP2uqWBFXQ0RMAX5jwOzR0z+g64EHALEUsAcUmRhY348/3mJhfckdV88evMGOXPZiog+WBolqheu+YEm2AaOoEkh0wpSFK6pRtvUzHIWQ0n6OOJmRu8xVurmPErvrAzkmz8VqYox713P2R0QlPfNPuzCpFNQUK7tK3NzvHM9ssvJqt
 2wio7nkF
 747kk/Qi34TWEZephnVsNMwZzFZn1ZqqU/z2/iRojqVRhr+86tbA4IgUigrNeBBqScTUGex5ZUNjS/GK7TcTNgMe5XI2ODsbOn7vP7riIKwvlfqSEAZGRgk9f9TpXCFNo+g0PpW7HIZ4vgfqQKQVSf9bvhnvWFTw2OPlKsGtUG16dnYDXkumCi/z+UEfa82X3Cp20pNJSZ+HzGy+8YEdExrqfum2eVlxpWZUOGtVdXNmTlRFAdYXfEh+Yp4PXHR8EY3bn4Kx90r/QqP7MWA7P6YRhSuFisVkQrpUBs65RaAUnyQWOjAol/+3JwaN9XInKJOts6q9iuV1T3Mvkq1XU5VjcHK7tu0wHb2Wa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 08:51:33PM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> MLOCK_ONFAULT only locks pages on future faults, so there is no need to
> fault in non-present pages during the mlock2/mlockall syscall.
> populate_vma_page_range() already returns immediately for VMAs with
> VM_LOCKONFAULT, which means __mm_populate() just loops over VMAs and
> holds mmap_read_lock without doing useful work.
>
> Skip __mm_populate() when MLOCK_ONFAULT is set to avoid this unnecessary
> work.
>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

Well you take mmap read lock and release it (after having held the write lock),
hardly earth-shattering.

And this has been this way for donkey's years I don't really see why we should
care?

Do you have a workload that's heavily dependent on mlock2(..., MLOCK_ONFAULT) or
mlockall(..., MCL_ONFAULT) as a hot path that is seriously contending the mmap
lock?

I don't love how the VMA_LOCKONFAULT_BIT flag works but I'm not sure adding more
churn and code for the sake of it here is really worth it.

Thanks, Lorenzo

> ---
>  mm/mlock.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/mm/mlock.c b/mm/mlock.c
> index efa6716e4dfb..784bd4bfc3bb 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -658,9 +658,11 @@ static __must_check int do_mlock(unsigned long start, size_t len,
>  	if (error)
>  		return error;
>
> -	error = __mm_populate(start, len, 0);
> -	if (error)
> -		return __mlock_posix_error_return(error);
> +	if (!vma_flags_test(flags, VMA_LOCKONFAULT_BIT)) {
> +		error = __mm_populate(start, len, 0);
> +		if (error)
> +			return __mlock_posix_error_return(error);
> +	}
>  	return 0;
>  }
>
> @@ -778,7 +780,7 @@ SYSCALL_DEFINE1(mlockall, int, flags)
>  	    capable(CAP_IPC_LOCK))
>  		ret = apply_mlockall_flags(flags);
>  	mmap_write_unlock(current->mm);
> -	if (!ret && (flags & MCL_CURRENT))
> +	if (!ret && (flags & MCL_CURRENT) && !(flags & MCL_ONFAULT))
>  		mm_populate(0, TASK_SIZE);
>
>  	return ret;
> --
> 2.43.0
>

