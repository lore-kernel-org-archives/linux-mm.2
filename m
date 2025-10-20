Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6BCCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3F78E0031; Mon, 20 Oct 2025 10:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB178E0002; Mon, 20 Oct 2025 10:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF83B8E0031; Mon, 20 Oct 2025 10:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1D9A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:34:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D51885689
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:34:31 +0000 (UTC)
X-FDA: 84018738342.26.B183EF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD540C0012
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:34:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aljLVya/";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xb6pHzoMqR1OnrX/HEO3pMqy6UQLo0BlQTOiKh4rGF0=;
	b=1q/V6i2wr+VArbHwrq17TxfnQfzJAC/Urpcia2cmf6HwAT/uq+mvfQCRwbRk0RWOUq3Sou
	ApxuFn68vI8xKuTGGOMNdGzWqv9eaeTafp5bgtOgZUdj34nqLQfkRLVrJUjdlGqc2yiqp3
	s4heuLKCKNVddtYyKH37Ue2m6bb966Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aljLVya/";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760970869; a=rsa-sha256;
	cv=none;
	b=NvuuVyLwiC14UYCwtiPb8L3WcWN79nP9u7+Tol326w2by/0hxdaiWE66iobt7CZoEYOMQh
	USN0xAFNCKULEAEHYY95szzj+5WYifuG5cRD8ZrElIiDcNUacIh6Iz1mDuXni6m7fcrpLf
	juYK+gfBVkGuKHf4I/sof3+9EQm0fxs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25AE6601D6;
	Mon, 20 Oct 2025 14:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB87CC4CEFB;
	Mon, 20 Oct 2025 14:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760970868;
	bh=njSGw+0+bglBesMH3eSgGR66DivVvfBCHj+lOiAEjgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aljLVya/4TOGXrYvVax2nTnkWSGgKHojlTCuHaOI/SinO887lk312rso2SZOliykQ
	 dCQ/b6+ZB3npTtSzYIpiPm1meM2RfsDOTqtKh0hiAAi4DyXIU/CJ+JwgNgNrPOMXUk
	 yDkl32KaymPCP3FRTwinmzEH6jRnzr8GEDrP08pkrpG7h4CKbBUxWcOaZOz034dXZ0
	 hgrjbrSFeiIRw/K3wDgNVCNlaHKR8vxp6sjeggaGEQ/f+HUlo1ITx3NI2sGPyc5pig
	 5TI6QKIXhCABRL+19wlcMfmoHyTIks+vF/0fqSnePQbFbXLe8A1f58uBh1n8IRW+Zh
	 qrfnOHsborSGw==
Date: Mon, 20 Oct 2025 17:34:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH V1 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM
 CORE section
Message-ID: <aPZIbRrk2tl3zBhD@kernel.org>
References: <20251019072509.9488-1-harry.yoo@oracle.com>
 <20251019072509.9488-2-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251019072509.9488-2-harry.yoo@oracle.com>
X-Stat-Signature: 1qm13qo3ewiy179b4wa6qoq1fy4ja938
X-Rspamd-Queue-Id: DD540C0012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760970869-104919
X-HE-Meta: U2FsdGVkX19YPeh5pKdRXkcYLM57gn+nH+4bY2KVjT8m/J/wrkanIqGBmdS8C9B3IalM0br0HdB7sSpZaJ8odjEb32hBOxXQtCCmPyPH19R7zB3IQq2dR9rkFCkmxJ/C/S+06eXHa3Jmmv3G5MxGrsjR0hwlSCUDNx3AtWb/XduCfpvSBJ2lXecaB2Xpc9lD1R/6rQBD8FxwfXAscUPmTtT0Ra9E6Za3FQPcMJD1tqZlK6Mifx6RMaKnIrBcKYCcKii6IYHC6K1o2QAINCptM32jM3b/DfapLXa4Gafz2zEE7VxLLURPDV7YNQ8trHsvpJJ03/d4oA+jhLWhKqtFfcO5KH6E91hRiRoo4oXcbuHEvbngUxPQ3+vsikZB2jcUPhfeUlBoFvB348BRQqKb1/Yd1QbId+q1W7gOsV98iYUsFtEHBK3FhFgRetrW8I7eT2afk36DsQLYnDCOMfY71FNQMrZnit1cVA1rN93M/HoM7xiSeap80kqbbJqoyIf6meVq7nMBXI+5BCnqhhzs+GkGQyBqB9St2RjkKf55upA7GEIDSvZHcZWTkZl6TolqtiLCgGdTKWGg/f2zGw08BaNOL5GgfrPeOiFLbQG31W+d8ShJTqLtoxJeSnkgtRe3WHfT45j0e82kQOuQ4MBq6W8CkgeUHQRaIXOxImjCHlAsHT0snU1JGvcovrlqCuJ1or5ZOncQ8F55AjR5809t6DgVQV/c5pwO9pEcP+WdLMywVgH7twC49mtbaytwZN9yCrT5WfnpRNjn4AODVWHHjkf/+x6B1f3q2c0OUjUkF3iT0Y3HLE6AfXS4aXnHMdf0Sk9/ind+s4/X6OgerHgfiuTj+OEz/ZfPPI5l4QJkIafCWsOku5j2wppZZbJ6puxkw3rW4WcLDVmakTbEzSCjg2U3/rmDdMagAr9EOZR+VuyAgysEh8QpSnVPxkb762LrIgeFhYU6y72YX5x21sL
 mH+2uQ9e
 w4guXOi5Jo0UB7osYmcMRnqFpy/JXZ1DUdvflmUSeZwzhbjj06mysea6Z2uNHoM6GXWz5HTcF9Wncubi2p6bLNk/Jlmzk6ft5rccyatJvTyrQcJNl6bPfSxVysMB6lcjNFVHT/52a+exSIBxuqPL7WgwoCtTzDzrV/CLwk/hLyya83no0nRedbFJ6yXaFvExIfqDKyRt5L90lkFJ+/MDAO4eJGliJkd0RYovgzdnIEBo0EZos3wVw191vhlx/2hEKwy6bbM/HJmJsgQ7lip1PahTwc6eziOw5iOjlD5uCYnmzi9i/Cwm12ZtYEG8Sic1kbeV/80G0IxA5X2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 19, 2025 at 04:25:08PM +0900, Harry Yoo wrote:
> Since include/linux/pgtable.h is already listed in the MM CORE section,
> add it to the section as well to keep it maintained by the appropriate
> maintainers.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with the alphabetical sorting others mentioned :)

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 46126ce2f968..dedb9525c2bc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16249,6 +16249,7 @@ F:	include/linux/mmdebug.h
>  F:	include/linux/mmu_notifier.h
>  F:	include/linux/pagewalk.h
>  F:	include/linux/pgtable.h
> +F:	include/linux/pgalloc.h
>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

