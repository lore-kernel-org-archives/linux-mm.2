Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FF4EF8FFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F036B0005; Wed,  4 Mar 2026 11:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76E16B0088; Wed,  4 Mar 2026 11:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995BF6B0089; Wed,  4 Mar 2026 11:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8831F6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:25:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 325961B8469
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:25:00 +0000 (UTC)
X-FDA: 84508904760.11.3E7A9A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8CAC1100003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:24:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XfKLtNiN;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772641498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZHJkvemcIEJMpi29eus3Zoc4lMuqhQkrJBuTyq6rO4=;
	b=7JsIm0rqzT/HnbmNrCSW5SJUWn7Dn4fO2VCk4bP2CT2enOQ6UFIPg49TjdQaTtSLgGtIhJ
	yketCbHZM5qgJMUs2vKQ6U2ElIMY7ufynh9XQZ5A7pcpHQVnKp2sze99B5sRjOCSy7bb3Y
	2GGmDjnJAWSY+VhD8itfuuzyLaSBlUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772641498; a=rsa-sha256;
	cv=none;
	b=F/KfF73yfrk0/13ErUTk061eOukrn6GRP0xEXMy7kDlPMw8R19EM008J36wcfneEn4eTQe
	2fL1xx9eWCvm10twT2AQm5q6Ifk4GyDr5hvxDOPsPRJND6gvjq4uBVMIout6fV0Oy9zA85
	h60uPBzRLLX6T4wD0J9AGKvZzlWDJMA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XfKLtNiN;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2C34600AE;
	Wed,  4 Mar 2026 16:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EBCC4CEF7;
	Wed,  4 Mar 2026 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772641497;
	bh=j4hbTQdifMqORZ0PrgMoZSeSr+3dRg5OwZLs7vTvKYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XfKLtNiN+7cXhgOaY/4IIZr4wb0AwwH2qIi6du/TOf1O1/mrsfn3Q8GhUXRRWkm1t
	 tHogCZXYYJ/R7nlsZ+0kAadJyuecltdOxTq5OK9lSwsY5MLUI/lSi7qc7Kxy+dhU6w
	 SHx/+lncGEgD7T/UkYR9YLULkQAdShd5YWj12Gra4z8xi3AtsBm7ieFvHjvc/XHVuQ
	 o859Yfo7gI0iBBQvPEklLQW1Txl1H6xIBfOOTAeMNsL3Lx5OXnfuStqvUDR2dIk24C
	 pcu3FT5lI54AOKJ6p+aPdUCB+DvfpHDHW1GFE79MzkxNH1JJzEcIwr7slAddsYD4fC
	 T9IB00is680tA==
Date: Wed, 4 Mar 2026 16:24:54 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Message-ID: <e46c8bd6-9f6b-4985-bec5-fef6c8f33dfe@lucifer.local>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <aagSrIwiFM7GaL1m@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aagSrIwiFM7GaL1m@thinkstation>
X-Rspam-User: 
X-Stat-Signature: xfw8r7861gdfehycp5mkfnxt9j564z5c
X-Rspamd-Queue-Id: 8CAC1100003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772641498-615728
X-HE-Meta: U2FsdGVkX18wu9BLunGufP4CZJppmqjlu1OxPYhXDwM1aP+XT8JsTWIYjhc3MYgKEHjiCADT3ssa+g2xdAFvELkcL+k+fZFzwZZjklU8T0ALhUUL4E368hrjotnCTV/k5JdtU/1QBUoWkSdNnir8gbV7gt8beJa449vLzjGDzojeg7nqEaRrLH0xv1zwcNMiVOqNyjFUsaCzGDjvqdAmBIWAnQbcyrAdWL+P2FAnAXzfAHm+FKdmDW69ba6OSirCq5vxV2pJQ/bTaqpqAwEkTpNEdzrnkdPd0t5unZoAcU2zi5/721MgaMt1iCFw34ZC/CW8KmTA13NrX1DhP9nGfbYHiwXBtxGZ54WbuRTCw94qRAvlDFFE8RaEqz97NsquCSQrctIon+8+bIML2Z7PeYN35RPULCCpnIuyOQ5eJPAhXCcivcxeKFNomgGLGsElE4IxlUCxRXguR3DWRSXjm7NHY7U8frG/0UQrzNbpcsNc7JjutGVQwcQtgw8zs0MsyUYIXycWggFsut6XYe8q+cK6UOI6dkvsvzdjukDs9ADD27SozVDatNg/gCYMbXx+dsCTQg5SCikyetjwlvsZ4gVmdrRAyJ7EdDGjrYtv9f4X3YjSmt8z9Uaubci0hQlRuMFFAvq2ez48/y1mThtfROTFitsfufe+UCNGsnEHWz+4SLYduHVBKUosbreiTQlYc5/mI9t85tXEYdwWJH/pZCidzDmmsJ/z3rhhhSVLmWa+jyfRRW3ngTJQ9xapgL4tOd4pZ0CXnxN786gh7Fo/AabJoUGTwTJixIumTa42Sp3jCPYxnyUTVx+JLnh2F8LIO6FqQQMp3XSM2Mk2R4YHz2vZnWizoPw2nCCU8UCBzIu+NjUCJqdtMFehtj7O7i42lyE03bu+8afGq5ksgqkffbDKdN1jQI5+Rm/8ROn/J+myNdYC5g6dNFnFc4qjcasEcF1rGK4e6ZPEQrVDiqx
 T/+I2MJd
 7BgNUffj1z5hIa1Y0aK06ZN11sQoIyfo0JoBEBhdHoOm6vlt8oUh3dpqNJ1PDM0thf89jnISxwfL6VR96xBxIs5PFErVyYbQrcbDCUmXN8c9pug114oz6PoJ5HOEeZ6aoDVPQdKmkXTYXcsWE+9Tq2DXyrFDoY9Lmd51qNmsyrer7iHoISAtGccqvhgKW6UBXWcrMugMeh5mFljNDDXLRb1Kl3mYyQGw0oguFA5VeTwPu70mVEGJJy24no9OzU6Rm7X86
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 11:18:37AM +0000, Kiryl Shutsemau wrote:
> On Wed, Mar 04, 2026 at 02:22:32AM -0800, Breno Leitao wrote:
> > Breno Leitao (2):
> >       mm: thp: avoid calling start_stop_khugepaged() in anon_enabled_store()
> >       mm: thp: avoid calling start_stop_khugepaged() in enabled_store()
>
> I think the same can be achieved cleaner from within start_stop_khugepaged().

I'm kind of with you in doing it here but...

>
> Completely untested patch is below.
>
> One noticeable difference that with the patch we don't kick
> khugepaged_wait if khugepaged_thread is there. But I don't think it
> should make a difference.
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1dd3cfca610d..80f818d3a094 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2683,18 +2683,18 @@ static void set_recommended_min_free_kbytes(void)
>
>  int start_stop_khugepaged(void)
>  {
> -	int err = 0;
> +	guard(mutex)(&khugepaged_mutex);

This is nice :) we need more guard usage in mm.

> +
> +	/* Check if anything has to be done */
> +	if (hugepage_pmd_enabled() == !!khugepaged_thread)

This is horrible, better to break out the latter expression as a small static
function like:

static bool is_khugepaged_thread_running(void)
{
	if (khugepaged_thread)
		return true;
	return false;
}

> +		return 0;
>
> -	mutex_lock(&khugepaged_mutex);
>  	if (hugepage_pmd_enabled()) {

Can we race on this function call, meaning check above might vary from one here?

Better to have

bool enabled = hugepage_pmd_enabled();

etc. etc.

> -		if (!khugepaged_thread)
> -			khugepaged_thread = kthread_run(khugepaged, NULL,
> -							"khugepaged");
> +		khugepaged_thread = kthread_run(khugepaged, NULL, "khugepaged");
>  		if (IS_ERR(khugepaged_thread)) {
>  			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
> -			err = PTR_ERR(khugepaged_thread);
>  			khugepaged_thread = NULL;
> -			goto fail;
> +			return PTR_ERR(khugepaged_thread);
>  		}
>
>  		if (!list_empty(&khugepaged_scan.mm_head))
> @@ -2703,10 +2703,9 @@ int start_stop_khugepaged(void)
>  		kthread_stop(khugepaged_thread);
>  		khugepaged_thread = NULL;
>  	}
> +
>  	set_recommended_min_free_kbytes();

We are setting recommended min free kbytes each time somebody touches these
flags, maybe somebody somewhere relies on that and this change would break them?

So maybe we just want to do this each time anyway, but repress/rate limit
output?

> -fail:
> -	mutex_unlock(&khugepaged_mutex);
> -	return err;
> +	return 0;
>  }
>
>  void khugepaged_min_free_kbytes_update(void)
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Thanks, Lorenzo

