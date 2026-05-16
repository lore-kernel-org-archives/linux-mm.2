Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3676CD4F21
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 07:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F1F6B0088; Sat, 16 May 2026 03:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0136B008A; Sat, 16 May 2026 03:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8AF6B008C; Sat, 16 May 2026 03:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4EA6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 03:39:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8713E4031B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 07:39:52 +0000 (UTC)
X-FDA: 84772483824.10.E1AD712
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DA716180002
	for <linux-mm@kvack.org>; Sat, 16 May 2026 07:39:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SOcGyOP3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778917190; a=rsa-sha256;
	cv=none;
	b=I3tIbiyw5ElNZAuoZKuj1YHq1/g7RjGwqsRW1TlK/C5sQtUgycejyZcxyKPA28zelhsWzk
	Aget2yzJCeEv/21/2VxG3WEOfQO1BgcUgTENrVwTMYLF8UANCPNZQcor12Sred2j8i/WHE
	gie/j8CPqY6oi7c3xipwu9nA1x7dFGA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SOcGyOP3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778917190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2w+A10RNn3haPdSCgGA8e51o+4+IUVl1uiDV7wnVml8=;
	b=50d8eigdzLEg0IhlTXPZIlfy/JfjZxenKcxI91wWu6D53rQ3J0mJHhGEVma3PoHUC9dDct
	KXDJiqQDVSDfPwUPZ9uxKAjuPvKSvr/Nyf/40R2y3YKlmIA09ejSxrhCjUH6j3IcYhIPn5
	GG+AXOyTXwTy+dMLCZSggNS770TeEY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21DBD60138;
	Sat, 16 May 2026 07:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A082C19425;
	Sat, 16 May 2026 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778917189;
	bh=9s5hcQU1qJOng7EpP/1GD0C/FrCAs0eJD5DJJG+YdWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SOcGyOP3uRqRREsFCbj4kXH8iRAplLOSa9T+BwriiMyUVZeM+FfujrtfK2JKkSINy
	 SSWvrbC0Kuv8LsFRvtH3OrIRSdrrenlj56oLuZviMLTO009t1uXT54+CY6bj52Q9YJ
	 jX7dJRSJJf1rQuG7sVEFRL7OB4xaE00YsZDR0AnA6/IYwySA04l5XmeVJwOl1FoVVv
	 t9h7//o80okplijw+v2OJpIWSUs7Dql1EmKoqpNNwENUmwpYvMo7qWrvwUTZGRoA07
	 d0zVHd53GPaaX0UFCr9jMyhqrZ0c8s4B0lgoZp0AV9E5NOayydAJqrTb7zL5lpYaWv
	 J1lUcJCNSx46A==
Date: Sat, 16 May 2026 10:39:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/3] kho: Add kunit static stubs
Message-ID: <aggfP-0A-i-bYlP7@kernel.org>
References: <20260512195135.804833-1-skhawaja@google.com>
 <20260512195135.804833-2-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512195135.804833-2-skhawaja@google.com>
X-Stat-Signature: xfgzoteb3g3hwnzwdufa94os9ywo69do
X-Rspam-User: 
X-Rspamd-Queue-Id: DA716180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778917190-813699
X-HE-Meta: U2FsdGVkX1/wRzz25BLlCyU49RpXop/XRbVaiSAHXuprYBRQRpSN1b1z0lN+KwimaiN1VPNV1qo8zen3hGrnuSnuRudQNq/BGnwkrCLEJAGFv6sRbojZaB6M4TRW+1RWA3S7CIpdj9a7ynDiGTsLbBDGd8PQBS5rlYg4m7ma+opzHJclcMWKBhU6ysDLC3u2h+7OryraNuReJWi9RoPj8YLF77Qpu2HTCDQtWJoLCF6axXvwRYY6xGTtXiAr5jjamCpb9uzk+nmZTdAhXEN1WGJ71UQ+F/nPE5EIQjyMKhatO6va7Frehh6IV642vv1A4nrxxWXujFHiLiCZICa5HCIS+XvVPIw4Mj0Gc1Ye4/VDcjKUc0KHDIlnesJxgs99B8XMWMWnTRDEvPAO2LQL36W6aR9bbAbZ3f2HStZB1m0BbtwQrKgSqvX94BvdeSfu+oQEqny4tzNyfiGaiTFloOvp2EXhQ63F79hR/15PJH4rEeFGc59QMixkj2eGZEn4SqM4yLZ9I1AyC4OKGUrZaKGYwIMCcWx+vQGrf+Zzu38qdDFVWlLck0kXyn6yJkjoXLS6yAhZKpDDv8s3yoQ5nY6GuHnDdz+a0VifKS5JuTfuDZeAYWAFkrNKmUgLujBNKe/4NlbU+SNlWXdlxjAj+/KaF1jvR51dwNDOhxlhVrRiL+Ov+xv6NrJv4QeugR+G+7E8qzWNEOyaszT9DfG2E+YjZEd4EJpLZSgFbr+SrOusF1ml5AEY+kRyagOnLEXqjyeUak1YKu3REcDAv/2/Xb75Bjzvep8nqryDgmrxgEyatuU4SM9pcLODUjnRu5w+SIwWsZnQrUBOw2+rxtNy/cCWktcDc93FD/gOAfijXeoI2L4iQrSsd2AfswZq9BU1KFo8QDPKOHdvkgl3BztIrgnG9FaoX/WB69M3yhDY/NwthvsfxJdBAasd3N/xo6ZkkyWOPpaAQ7ooxBdnh4f
 5wovZxJc
 Lmlw/QOrHmf6sHXZtlyU4XmAbOCk6K1d1uDO7/NCJK86ijlI4v+N7bKXyPi9ipCXTwUdrMo6dDWxJCK7XxnMCfajLaqz1PT26XPMZCDHl2qaqmk2bGEH5YvU9Xd3rBwnuxzZvcTAb11oLqBry0/Xnwjx2xbmcdVLGe+A9ZpS/CiI2SW9yaSFwsq3TM8p1RJC/4uIlnu+1a52LrVRVZL3jTWC5GuD/t0UP7Jb4xCri1K1zSAAv+mLP7lyMAx48O62YJdlFLfLmgZ0MIHhqsOJkke0moiNaz5SoA8VWsdwrDuKtxzVJdvBv/pP8YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sami,

On Tue, May 12, 2026 at 07:51:33PM +0000, Samiullah Khawaja wrote:
> Add kunit stubs in kho_restore_folio() and kho_restore_pages() so the
> users can mock these functions in kunit tests.
> 
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index d5718bef6d4d..1375291d9b07 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -11,6 +11,7 @@
>  #define pr_fmt(fmt) "KHO: " fmt
>  
>  #include <linux/cleanup.h>
> +#include <kunit/static_stub.h>

Can we include kunit headers before linux headers?

>  #include <linux/cma.h>
>  #include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
> @@ -437,7 +438,11 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>   */
>  struct folio *kho_restore_folio(phys_addr_t phys)
>  {
> -	struct page *page = kho_restore_page(phys, true);
> +	struct page *page;
> +
> +	KUNIT_STATIC_STUB_REDIRECT(kho_restore_folio, phys);
> +
> +	page = kho_restore_page(phys, true);
>  
>  	return page ? page_folio(page) : NULL;
>  }
> @@ -459,6 +464,8 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
>  	const unsigned long end_pfn = start_pfn + nr_pages;
>  	unsigned long pfn = start_pfn;
>  
> +	KUNIT_STATIC_STUB_REDIRECT(kho_restore_pages, phys, nr_pages);
> +
>  	while (pfn < end_pfn) {
>  		const unsigned int order =
>  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 

-- 
Sincerely yours,
Mike.

