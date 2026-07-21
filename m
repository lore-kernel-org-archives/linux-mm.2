Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58ECDC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7BB6B007B; Tue, 21 Jul 2026 10:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597B96B008C; Tue, 21 Jul 2026 10:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A4C6B0095; Tue, 21 Jul 2026 10:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 147516B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:47:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8371BC01C0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:47:04 +0000 (UTC)
X-FDA: 85013061168.28.832DCBD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD2A540012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:47:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BK6QNPtE;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784645222;
	b=M4ieCIkphU3q+mOH17U/h5/QRQoNMA4PEZ8p8W+hw6ah8PIy/ybJJD2lptRgpMC8UovtJn
	sviLg1H+PO+TN2yyDexcRCp0XCLLWNqKrkSH52C4PRoayd8YpJJEx4ZChaT4M8S95RALnE
	w+NsYa00JOeHkGtV1hfcjqRrzGN5gN0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BK6QNPtE;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784645222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rkbii2FJonBgXwo4P4xuRdlSQz3cCqK8xFFUoSBH+SI=;
	b=jbdvpliNv1SigKoBMg1AMWaLXEN3rxluxKBHQ4RSOZHpluqf67RXXQ8Coa4Hu/nwXnse8U
	n/VWtmxbdgD7wWGXGsHqIGRvsSZLnUxsIL2P/L5QX6X2M1HLPqMaqjFZ7XP7dvZU799Yba
	mQEW/u3GbJjFp6E7b9xyD1G7HbLIinc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rkbii2FJonBgXwo4P4xuRdlSQz3cCqK8xFFUoSBH+SI=; b=BK6QNPtEUbQ+F/EBiJsH6S5WPQ
	sxH0yc0kzECYZfAjOEEc9eqgKd2NyNH5BnmPrOrWq3SPROCxgKyW+9VXhR4FKkSNN46rVa/+0ymie
	+IuW5yy9re0nhKY1kUiCFXY7iodSnGPY1Nrw+vLbI8OZbXBYr+rsXee4cHcFZAxJ6Hr6eLWSbuf07
	xYVaU0LqFW+ykGtGVYK63a2FvWs9yw7JWB/Fop/9spSGylUzPafH2y6Nee+/NStRwdhDUzPBLMWOL
	v902UO/WBLgZeDjuM+1L8/hxiUfoFgkcPMDon70QYK/2uW4Ex7ASCrrvrwHHFWDOnGes+LzyUBkhn
	rTdoBBaw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wmBkI-002HtH-2B;
	Tue, 21 Jul 2026 14:46:59 +0000
Date: Tue, 21 Jul 2026 07:46:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, 
	Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
Message-ID: <al99cIaOIPriDQKq@gmail.com>
References: <aleRuVBaWu6eTCJb@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aleRuVBaWu6eTCJb@bender.morinfr.org>
X-Debian-User: leitao
X-Stat-Signature: dmftsc9racm1qxhhghgstsz9yyajess3
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD2A540012
X-Rspam-User: 
X-HE-Tag: 1784645222-863767
X-HE-Meta: U2FsdGVkX1935KQD0OSqpooRrhDlMSuADkYVDFHQwJT0g4MgV15Mmo9lwrOzJoibd4grCqMkUQJhodDIJ6AGBYI0oWDfT54dQ2tgPsPHb5PsSfVcLiA1GGPZNQHBDJbG7AFD4P3ZKm8shrzHTuLSl1Q69YsRxtY3U+gKYt5FgMORjSKAZTPih5K5dIyC6uzvbIYDA0M8YZzanN8E5JOj0CNj+oDj1XmG8DII5AEHAV2ASbtoRCJfN8onxZM1LZh3O3M2WHu0n26ph/OPyFDmc1LhfkeyfsSJHxYaHqh13Mh0f5YGommZABf6LZabOvDj2VLxWL6JBmrAAPPEy4xag+IuMgnPZczZOHNF62EvCHUuSCtFkamFG6luLLCwvPDOxym6uReFzLOXRnQJ58fjJ+Sb4+WVIjQQUI7DUU+cHKkDGBYNsFM3IpiBLcwlkCCTg1OCNC1Oq/9a4NVv0cjg7TDngPEXtdPyBIIdxu7GoG9gPM7iDmp3/Y3KpGd8qwgsSdVdai5+6VatguDn2mnMSqd97fiBwyH8Rkunn+t9VVbIQrUgRfoZMG8wjEO/X5/Mbe/3kBA17hDSbHdAzonqKwoe7pRnjKtREEPKIvLSOCP1CCnpt2dqdBr11kO7GMSuCujn0r0WeKMoajUehwr/K4byGjuyxZtGWsRIOjMGFxnyWZ82niBgLyj2QxrnfYVpMfiAceMnz2JkEUJV2ejuYFeSXRKfql7+Fd9b08/Hn4HOI+/T8L+pVa4gGLkYcOCfxzwjk3trLpkPe0JBllztEzDH7h7ATrNJP+9EHVaPlaDl4z9NaCb7hdLfZzFWC9Z/GnGb/HMGQeMQts5SZlaif3/ixrUx1a09ZL59iKk7wX+eKO1Cggq+QfM1155uW8pjXYUZP0bEAt25/ncBCdDwYd4KKWpAF8doTgQ1SsLiU8Gbq2KFkfpM2l+lFGY50TMAZ63L21iS7eXho0Vv8CF
 XQcojmzu
 IDRpu8nsIIu1WZZcSnbLzjlDKuxKBRA/d4WEcVmtWE/Xtw7cn4QKXhndTvEiTV61bpjzEI834n6AORhZicAbD6AaPacVUgWn69R9D37h3dfGUOm4GC6T1zPcve8IugP742+YC4ojBhB8K0L7BHzmmLs/gNAcFf1LjXORxLIfyaTogW4kHfbbopUN7hk5nEef2t7Q2C9oH1fX83l/XeO3sA5xWrRZ0XWlvjf3IWFVrGH93v6N/8iPuE+u2VJaBSQmmYwgaOcaosrrwSRZ/eIiMaqvItfptOCo5+12zEBuuns4CKjxollB5D7Pnpn/sL6rkp2zg+NqSt9UsTxzTjbA028ocgvijXwdQJgMJ+lfCaEBUA8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 03:57:13PM +0200, Guillaume Morin wrote:
> This patch changes __unmap_hugepage_range() so it now checks the
> mapcount before adjusting the reservation.

Can you please rephrase this in imperative setence.

> Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>

Reviewed-by: Breno Leitao <leitao@debian.org>

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..c0167a09a0c4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5252,7 +5252,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,

There are some comments before this section, that describe this code.

Could a short note be added for the new one, so the intent survives?
Something like "restore only on the last unmap, otherwise the owner
empties its resv map while a child still maps the folio" would do. One
line is enough.

>  		spin_lock_irq(&hugetlb_lock);
>  		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> -		    folio_test_anon(folio)) {
> +		    folio_mapcount(folio) == 0 && folio_test_anon(folio)) {
>  			folio_set_hugetlb_restore_reserve(folio);
>  			/* Reservation to be adjusted after the spin lock */
>  			adjust_reservation = true;

For what it is worth, I confirmed the original df7a6d1f6405 case is
preserved: a singly mapped folio still goes 1 -> 0 across
hugetlb_remove_rmap(), so the MADV_DONTNEED restore still fires.

Thanks for the fix,
--breno

