Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36FBC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00FC86B0095; Wed, 26 Aug 2026 04:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2AB96B0096; Wed, 26 Aug 2026 04:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68166B0098; Wed, 26 Aug 2026 04:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4AC46B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:42:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 334BD402FB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:42:23 +0000 (UTC)
X-FDA: 85142778966.02.8168B11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A01361C0007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:42:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTlJ4Wu+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787733741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B87NBdQTr/+4nNDjbBWebVkttjgeA/nXGSCmd12w5so=;
	b=qJYuG4lzekEqL3GjGjiCRK0iq1ezdrjhpp+n48ORKQ00i+tqMT6art3SjsdvG6zx2OFnrp
	l6T+UICVK3WRL3IqhxCjvs0BNo21HCUVRjuVsH2DVsEX6w4jgeBhzhNXHAaH82E1G+hcj5
	SqR47YHmT8qg591AdSGLJ96brf6J9Eo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787733741;
	b=yLokGKs8DQqpaRkeEAuesVip3N/LhPZwGmHvFqhGXNJXk9fsXAeMzO3PlCj7S/6GFbP6s1
	RtCNL8HAFSSHJZxqYdx7fkYg9LdAyyEzEqwqfOxGDb92FdAohHl3bu0v+2IHELsol7ov6S
	7v8wNK961hiz1xOjM4MrAT2SkOdt8fE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTlJ4Wu+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25D3A60A6C;
	Wed, 26 Aug 2026 08:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE4C1F000E9;
	Wed, 26 Aug 2026 08:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787733740;
	bh=B87NBdQTr/+4nNDjbBWebVkttjgeA/nXGSCmd12w5so=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lTlJ4Wu+M95u14eDIEgbeePfnTOioVhPOq8hrYMLclOeCve2higYszBR5GdoE7/Vv
	 eL4fXmw9Z4Nd/Wbh8O27k3Pe8jBrbJyZtqcnlPKKKkrWuvcgC6UM/Qd+V3kARn9O68
	 nQPgbAYzl2OG2/HiXhjvlDAbtrHUuxyqQYo4T6nRr8LTprhsRYpz4kmK76FoWFdfOj
	 PJTD1/WhoAccxq7HElCVcPqSakTnr/Oza9Pg7pu62svNrVdj64QvPC0w0cKIyJ5rzH
	 vRlWMlGlvBvA5T8BTWIyFLEaCVjzfH31lmo19uxx/b1scTA0JoQxz5s92GgkvcOWo9
	 Pab0i7KlNOBUA==
Date: Wed, 26 Aug 2026 09:42:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 2/3] mm: khugepaged: fix folio is used after
 pte_unmap_unlock()
Message-ID: <ao6m1BQOpl5edwrc@gremlin>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-3-vernon2gm@gmail.com>
 <ao6f4773bhQb-CtQ@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao6f4773bhQb-CtQ@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A01361C0007
X-Stat-Signature: p3e4thbjq45m1g6kn9mg65xedh511zsr
X-Rspam-User: 
X-HE-Tag: 1787733741-724985
X-HE-Meta: U2FsdGVkX18qVMGRH0d7L1B1iYp/F+ocju3hfDdflUsmycfFRRsl4O3uvUIOCBlaqwIu8BHqlSmCHP/QeBMTzX43aisbBX2EVUduJyRe2pfhlALE9wo/ISMEHR4S49ax+FfgKofIiVh4LMyD9wsbyulOpKcRhenPE3uMtU2hN8YLKJXt8Mof6rnPfj/fB1GKwJurk9fVhDjBwUobbvx92CEJdAMetU5NoWGDVXXRletwrxL6g1Qf0bsM3ouzd2HIiyQ91vPdy0f4qV10Vb4RJ0N3IPIAOxVkGIWw4+QKAioNvlPfnpz9X9HU9WBfm0yW+ATll+VNcVgQRldxs/WRR/WQ+4E14hRTtmjV+Jg2cKmCuPhq5uH1FfKATmIEixYp8YkYWD/iqeI9zpFF6iV4VabwTvW7WILLJFEl/J4kOKK3Eip7LaHVj5P+IY6It2IuG8euSZYyyLrChsJ/wa8GN8Gg8n8akftWtipY2SdRBmORqEfmFTvJibAB0Rwxy1mZiHOEvxFJQVUD8Wz0B1OZyTfRqU+pxe1hqlOKhfPVTBrK3r5YehqLdFw+Lj7wdAEYlAoUL0vyq+GvaHELjmYhaSYm7UShVWiEHzKmteCD3SbXRUS+5EVBWhrKBn2+GJKetTyOHkPLVFSv01qaLv3XwcPeCo6VhvF3usQukqU4tlyZ50UrXM9xguo6HkuURSD0lXkHCoOGc+ZKtnjPRisDH92EMgk/e6KoX1GSKqLHT5FFO44uy2HruQrOptUdmibS9fq0xDB3m9BJPRdwrKyxmYRCGOweyJo3CoqMf7wNuZktEbKsGTdW/p7+GjprfilBLZlG/f0VHUDLOaJZE88dvnIdD8wcB3lNsFFInW7/5eq0cJosrVJfsLr374O2FyIDIqfkCt8sI1wXYr0fOeT3TGjXoOEaFr9iOJyZdJ+fYb4ZJXyjOKc4aXGwZNGC12AvssnWRr6Y3u+seImuxgX
 Wphe7x5L
 +OCrXIryQ1qpNztlDukc7mycSSs0ySF9ViLlGS4ET49LPsiASwTb67ANLe4LzMJA9yjCmJVMzwxULIPRtCk24jT1nsrRj1imuD6HfN0m//UPTPIz/cGmSBEi8XIypdtc8MjmkNvwMtsRbj2a1syp832GImdhiBxKnd2XzgYYGch86t0BCH9bsrR5K/SOrKmaOXsUoPzyD4diUdHSJNYrbkiPtdITXCCcFDMGInF44Y4JdTiCLxnfbGJR0KW18PmCcxKlYScsyYFiuB0kMfzHcnTAkiEfH5yEkGgGIEHjK4lDwWlrjaWN9Zh1it2vUiVlDzf8h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 09:12:52AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 24, 2026 at 05:29:34PM +0800, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > After the page table lock has dropped, the folio can be freed
> > concurrently. The trace_mm_khugepaged_scan_pmd() is left with
> > a dangling folio pointer.
> >
> > So using the folio_pfn() before dropping the page table lock,
> > closing use-after-free window.
> >
> > Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/trace/events/huge_memory.h | 6 +++---
> >  mm/khugepaged.c                    | 5 ++++-
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index 7b526528f85b..fa828967e1fb 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -55,10 +55,10 @@ SCAN_STATUS
> >
> >  TRACE_EVENT(mm_khugepaged_scan_pmd,
> >
> > -	TP_PROTO(struct mm_struct *mm, struct folio *folio,
> > +	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
> >  		 int referenced, int none_or_zero, int status, int unmapped),
> >
> > -	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
> > +	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
> >
> >  	TP_STRUCT__entry(
> >  		__field(struct mm_struct *, mm)
> > @@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
> >
> >  	TP_fast_assign(
> >  		__entry->mm = mm;
> > -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> > +		__entry->pfn = pfn;
> >  		__entry->referenced = referenced;
> >  		__entry->none_or_zero = none_or_zero;
> >  		__entry->status = status;
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 00337405c0e0..4e0fca5942dd 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1618,6 +1618,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  	enum scan_result result = SCAN_FAIL;
> >  	struct page *page = NULL;
> >  	struct folio *folio = NULL;
> > +	unsigned long pfn = -1;
>
> pfn_t please.

Disregard :)

With David's suggestion applied:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> >  	unsigned long addr;
> >  	unsigned long enabled_orders;
> >  	spinlock_t *ptl;
> > @@ -1780,6 +1781,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  		result = SCAN_SUCCEED;
> >  	}
> >  out_unmap:
> > +	if (folio)
> > +		pfn = folio_pfn(folio);
>
> And +1 to David on ensuring this is reset to NULL appropriately.
>
> >  	pte_unmap_unlock(pte, ptl);
> >  	if (result == SCAN_SUCCEED) {
> >  		/* collapse_huge_page() expects the lock to be dropped before calling */
> > @@ -1790,7 +1793,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  		*lock_dropped = true;
> >  	}
> >  out:
> > -	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > +	trace_mm_khugepaged_scan_pmd(mm, pfn, referenced,
> >  				     none_or_zero, result, unmapped);
> >  	return result;
> >  }
> > --
> > 2.53.0
> >
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

