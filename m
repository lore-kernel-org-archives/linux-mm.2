Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69AAFE67803
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 18:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E066B0088; Mon, 22 Dec 2025 13:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82BC86B0089; Mon, 22 Dec 2025 13:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72ECB6B008A; Mon, 22 Dec 2025 13:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6480E6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:14:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F385C137561
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:14:22 +0000 (UTC)
X-FDA: 84247906764.13.24AD9B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 457EBC000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:14:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hN44Nm1D;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766427261; a=rsa-sha256;
	cv=none;
	b=XsZbkSLNATerv6vTYKQ1a6/OCPWMik9hVhvvga8pPbenlxcWT3J/plANj4sAhH63RsRUOC
	gLaN9/PZ/ahuXPwRb6c+dOj5/7usCE1Ji1LY5ahpx2Bqr+yAYZkCPC1MuARhPCGEmCO3dq
	/GAkXHjd/EZqKHfcpsA64itW0/nqBsI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hN44Nm1D;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766427261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25eJAgRV9sH4Jkc2i4QI341g6SnKSeBXkcNGQcnpxBo=;
	b=oa6lt2VMk7uuhgHVYLZDmGBYtyrDQHUPHJpKFK64nkOU7M7BjGmL8F4IXEoTSZzQuSwVHA
	VfzGPgzl/VT5tOGoVj4jYUiPINbYN9McRcOcdwxbUgY/JPx+H+kRuGPhs6+Orvy4H+qX+C
	zLmORxAI3pYGN2BsC6b+JapdWKe1NUU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B9DD40AFE;
	Mon, 22 Dec 2025 18:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F92C4CEF1;
	Mon, 22 Dec 2025 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766427260;
	bh=TNwUkBQTxZDkoubReHZFGY1GMr5+mKbYisyvE423Ing=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hN44Nm1DtA0TsRaNPP0YSvHoRMNhpn0mknicuCZXaA1cMwoM4vpY8ko9mS8kKy3d2
	 vV8oRDc78Xzgep0qd/jYv9FHehacIwFeZ4S3Q513J5h8oYGR42ocIYDJKCM/JCYlHH
	 lkiDhWT6wB8bZee2QxBTiAw0yCkkRDK806QYVSL8=
Date: Mon, 22 Dec 2025 10:14:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3] mm/huge_memory: simplify page tracking in
 remap_page() during folio split
Message-Id: <20251222101419.10e73a9f2b35df440abd8a62@linux-foundation.org>
In-Reply-To: <20251222134531.20968-1-richard.weiyang@gmail.com>
References: <20251222134531.20968-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 457EBC000B
X-Stat-Signature: paruh9rkgjucj34eeszxnfi3yxuf17yb
X-HE-Tag: 1766427261-578783
X-HE-Meta: U2FsdGVkX1/iKvZJZzC3cIcXrqzF5zWepv5MLbYdMMGfrkLVYPeV8aPm/+02Tp7RXO3wYJWZ0A02vctlEIYBTwbRGeEOgnZwhPh6e5SoqaBYfjZaadqXeqTn3L4pZoSWayZCXJnIyNGFyo30YouVKbpJxmNkbr0Z4VuXobM6RIKkKZIm4KWXawKsPGogQajFRe9fa7Kt665OtPFd9kRLgGOOIeY21SVofKFTtlgoQDJmjJODYOoHS44b75RTeoQUsk0GfOcz+QjdHZqYvLWG2Fhs7AG3lcArJtJTpgHhhglG9fZs+ME3OTsjqBmUvuIXQukVBYWn7Ut0K9zpiNh7WH2RJzru+5nwYPJ0xdtcOkeesMbxxnAn97PPcmdlI2f+Qx3ROTYNX7QWJsNHpcSPwvVI7kvh+lpJT6TMYiolXeKcwkQ2wS1NMzQVrmfmvNhlMpWPs31a9Uh5PcTmwKgRY/OTeNcWlY/oKCPl2EyZZJc/KfwL4fV5e3bInnTne0hTYXILZAgpgyPhS32kVAf47uGU2uptrNBxnyZvsIu16iRPAp2eP2DLcoPupmxLw1SMsp4SfAB8NJBtUww9oqgwzwbSj0n4hXpdrQkga/YBe/UbPPX063bKOEpWlWn3Qux+jTF1mZx80EXR3fA66Ncfn8TYL6z6EI9KWfsnlNW4ndQOJZCSZKh95RzGd4mzzC9DE/kqn16tlCZB8gbEAM2raRFni7btgpIHDMYY9QS0d3DCfoaKYc1JTg9gxLX5SUZYmjfo9W0fhsyQFmi1JC0cQdvY9lj23gjS352HpxU8FzH8AQPRH0TWFcWPAZ1Xb/yyISYJhya3ONoFXK6K4XidQjy0wEqUL/+H/SgAKpaAlGAXQzicNr01Cr73ucQJPmFvCIGnMx6EaeFCs7mf6KZ7h/jNmW9cnW06G5JA8/tcJVjw97wVyCZ7wfmrGT8cKJECz7gcOvncTG3YTHrqxn6
 JG5C6O8n
 VFejfDf1j1XqZCC2zIzSsFEdd+9JRn9aqyLSMymN8JV0vWpwNDIBuqjCcSpxOIEhnmTuo42IXGj6pC3+H0uYg8BztC+E2D5FH4hyuPgVt0Vu2Fe/VErEB7zxP3YKp1zty7+pSv8zDEX7cSK6+2MQ+8itZLzhF+hMFCp5BAa/j7InhgGLfHBLAtp1afvtbuYE3N/H1fpeFjQXcfru+U0wfbtTL/UpJ6kTZyGdU70ojHjq93M4qy0Oh+zA7Ew4zM0YfrOK5NOf0nl61G531jBSvqOIAahqjYiyCX/cdLjt/n7zfBCH1/QKEVEgWr/XZNz+chPwyIqxzfSHeQ/XEtQOOtytyEjCjfcxilEvIsN5CfwZzKUDeKuEe/R4CoqVy+Kyi2RzksDYJAPN8rxc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 13:45:31 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> After splitting a large folio, the resulting anonymous folios must be
> remapped.
> 
> Currently, the code tracks progress by recording the number of processed
> pages in an index variable (e.g., @i) and comparing it against the
> total. This commit simplifies the logic by directly subtracting the
> processed pages from the remaining count. This approach is more
> straightforward and reduces the number of local variables.
> 
> Additionally, this commit renames the variable nr to nr_pages to improve
> code readability and self-documentation.
> 
> ...
>
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3423,17 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>  	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>  }
>  
> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
> +static void remap_page(struct folio *folio, unsigned long nr_pages, int flags)
>  {
> -	int i = 0;
> -
>  	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
>  	if (!folio_test_anon(folio))
>  		return;
>  	for (;;) {
>  		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
> -		i += folio_nr_pages(folio);
> -		if (i >= nr)
> +		nr_pages -= folio_nr_pages(folio);
> +		if (!nr_pages)
>  			break;
>  		folio = folio_next(folio);
>  	}

This changes behavior when nr_pages was too large.  It would be best to
mention this and to describe why this is OK.  Or to check for
((signed)nr_pages <= 0).

Also, isn't it a bit nasty to alter an incoming arg?  I think it's best
to treat all those as const - part of the function's calling
environment.  Yes, C permits this hack but that was a mistake!

