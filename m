Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF429EB1048
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E9B6B0088; Tue, 10 Mar 2026 06:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CC96B0089; Tue, 10 Mar 2026 06:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48A56B008A; Tue, 10 Mar 2026 06:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 911586B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:32:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E85C1B83ED
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:32:18 +0000 (UTC)
X-FDA: 84529788756.23.5591873
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 910584000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:32:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WLBubtiy;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773138736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgTzzrmoxXkxxAU7wnjcLS0dqIIdLnXdz4estcKKu7M=;
	b=TOGjgY8wSym1fBnsUCZWaLsk1AKkZsMZ4G3ZQN0OpbKkZumKixUeBoUsiHgL4Jxu0UVX6E
	kD8AoScuQfdM35kGYnIiybg2YgpTcWOAnVKwauTJvRLbLOopXGTjj1Sc1SK3AVV00HmFYs
	DqNsU94b38pc6ewk9guJDmOZWui/QjA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773138736; a=rsa-sha256;
	cv=none;
	b=thLDFGdcSYqslYUnfAZqG7p3MzL6n1tgpMlopwCEZ+zmEmg7TX7lIPgldKvHwwIEGYvRO/
	Bu6mk6zgs46Xm+jYgiZGdwzU8AK5ZNYuB9bN1eZEZf0x50YQyJvCIlVD0pkUFmT3jcfWj2
	xSFgN9QlBP8a2mDMNVxOmIt+Pwc3qnk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WLBubtiy;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B4F243A73;
	Tue, 10 Mar 2026 10:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01C4C19423;
	Tue, 10 Mar 2026 10:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773138735;
	bh=ZAajPCZBWnuyiHXT/HC/E7AWtxibfHeRxEoqFvx/SPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WLBubtiyvjjuzUzuIpOM/fjq+FTbtXBIm8ZoTRqrnLL49dgS29NGyxzfLRF9Rgt4H
	 fc2qPAsrsr9xDCUf2rMUjN4NeZJnOzz5ifzx7SKfHviwG033YS/VwBY21GWr2zpoy0
	 nNIrTb069ljo1jW6gaFoGlwakT0BR+PCuNAbh4YsvXIKV+ItLIdKNKL9dZ1awtRQle
	 L/eqipk8Mq0yUMMee0XueXnXiM1Efio6OHyzySi875QgfTeq1mvntAI7hA7m1jTxbr
	 EgjjC6OS6t0EpjGgn1DbWBJa4HW196mKxBPFsjPeMtN+Fa5mGlFqhQxtqfM/FqaF/F
	 7sl4bVYdv1TYQ==
Date: Tue, 10 Mar 2026 12:32:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kho: make sure preservations do not span multiple
 NUMA nodes
Message-ID: <aa_zKQr_yGKVJ7cF@kernel.org>
References: <20260309123410.382308-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309123410.382308-1-pratyush@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 910584000F
X-Stat-Signature: a5t14ybnffgybpctwjdywrruppqr7gpc
X-Rspam-User: 
X-HE-Tag: 1773138736-664143
X-HE-Meta: U2FsdGVkX1+4yu5uSG5l4rkLFMCs7mlhktid8ygBoeiFQ5uJUmgzstfeTUaUPLIadcvdNX6kyGV9Kdxs28I8dnqq6VpuW9leWVqXXcOxw+k3ibO0VZ3bX66/4nX1rPuTjXHyxcdSwdTNmUtttwQ/losHq8WcWND62hvg7MlMmrYKl9GlbYp36n1jP5CZhXADIUPZQYhUuUJg6ppEn8f8olAI5tTCJdiLqFZL7TUa9Si3CnCVkByNdgMqzU1Lo4sSXgcDsfxPCNZaH7FsABIzv68xdJjgCmM5gP83vpYL2u1temZP/tWg+HIzFr4onZziNdZkI1CpqJnR6eIzrXFOzxEstrvvaGgQIgP/oD6oUV/GjDweHur9fqplkq977kxXz3yx+4DmPNwMH5u7JNKPnhL8voDQhtZ+7TI/d5WjQtBY4x6XC8rNeF3ocClCrow/eBrCwK0Tq+bWiGsZxw+fUQ+nu9o/FrjSzd4tY6hAuw3cNCSJF/011zA4AekanhYMDRlafDTcKH6Or7FrLMe2S0tJPD2vnc7LxP+ugXKFY0VQHyIUpPpHFdhyDMgWrpge3o+yVPvXyQxKbhAfW1cB6cN1011AhsGnJmYIMr/aH4y1mQR3S8d1CF8EAEEPOYCULeu6Sxr+F5sWhZnjjcC9GlTO6P7Q79qJyveC5xF+QkMyr3b1RDyH01OTlwveu+GPidlFX16KhfjBIWl3fO7KYHkHIL4tXsvujncKtOYkSM6so27RIwdZdJghFZjL3tzcDCF/2gnCsrN/fnDpipmAKjyYkOX2RmHP15OP1YUkpBmY88jJkSfYI23a/dFUKuzwd2RKsqWWHP4jqU2CEsMFEbS8rlz2qgjq/w9Bf+yh1yshVgqNagJR8fSdA5jz2anl8Z34wolxnCh826PHzD9qzMSIgU0dv6IEYMVki1H3Vhflwb5MmEhOFtiZSWwOAy5jyH6cEM4Rr+yqpy2f76J
 HF5a2xFs
 I3ZDlRXd/Kbia0KoyqpNOfHHYqa4BJVV12rn6QsxLiH5NBLMkxvyPyTCYFNMd1NviIOfZR4M+SCOHTVILR7xSEN97q3dxBAU3VSKWVfKgzGC69fvX456n+21AOtF6fjPj3dsbpHE4dBENokPN5/Ay04WevM3aLW+HRlelfZG1wROddJurUTgSl0qQVFDhbMp1O7A2+jM8vOta3i08B0DntofUTL0lhcs6oe3kMTgpfl9mlAWWcpN3EzcRsojnXBcBJyIDCqVHecbI9XHO81pLnwrBTFgLYbsbnBd2ANnnfPh6NuNbFj19bSMc778KVHgAtuEx3hAD4YCH7BTei/+IlPD5xVEj0QgPQeB/1crTlVLq/GQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 12:34:06PM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The KHO restoration machinery is not capable of dealing with
> preservations that span multiple NUMA nodes. kho_preserve_folio()
> guarantees the preservation will only span one NUMA node since folios
> can't span multiple nodes.
> 
> This leaves kho_preserve_pages(). While semantically
> kho_preserve_pages() only deals with 0-order pages, so all preservations
> should be single page only, in practice it combines preservations to
> higher orders for efficiency. This can result in a preservation spanning
> multiple nodes. Break up the preservations into a smaller order if that
> happens.
> 
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Notes:
>     Ref: https://lore.kernel.org/linux-mm/CA+CK2bDvaGmfkCPCMWM6gPcd4FfUyD6e5yWE+kNcma1vT3Jw3g@mail.gmail.com/
> 
>  kernel/liveupdate/kexec_handover.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index cc68a3692905..bc9bd18294ee 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -869,9 +869,17 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
>  	}
>  
>  	while (pfn < end_pfn) {
> -		const unsigned int order =
> +		unsigned int order =
>  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
>  
> +		/*
> +		 * Make sure all the pages in a single preservation are in the
> +		 * same NUMA node. The restore machinery can not cope with a
> +		 * preservation spanning multiple NUMA nodes.
> +		 */
> +		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
> +			order--;
> +
>  		err = __kho_preserve_order(track, pfn, order);
>  		if (err) {
>  			failed_pfn = pfn;
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

-- 
Sincerely yours,
Mike.

