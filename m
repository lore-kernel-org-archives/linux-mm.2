Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B25FFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90CB06B0088; Tue, 28 Apr 2026 05:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDDD6B008A; Tue, 28 Apr 2026 05:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD636B008C; Tue, 28 Apr 2026 05:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69B6A6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:08:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 157F216051F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:08:10 +0000 (UTC)
X-FDA: 84707387940.10.4E076C1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id E072E1C0006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:08:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1cCZAQoR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xXWEmrhn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1cCZAQoR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xXWEmrhn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777367288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PLcPEDXVXa0sOl5og5Impq8NYwy8sl9J86BGnNXg6s=;
	b=fzzuYUkYyyzQEMZbmjxYfEpJuhoBIlH+Eau/ahO0g9qfFQlHmCJ+AddaybZCJ2A42sFCxn
	wg+onZpYyOh8C+Zkbfc65WMQesu1QADZm683XL5AJbW+2LXg/5BRMNccSKvKMbaZzBStSY
	eVjyHJTyiofvFZhTA3xNuemYHNPCmCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777367288; a=rsa-sha256;
	cv=none;
	b=k21qBlF9Zgm6Ag2RcrW/zI2o8Ak6FyRLBd+G7tlYw8ESiLh433xMZmEcGQiGsI9oaCNJ3n
	rXic8v/P//zzUMS/RnyOEnDUSRcsQHPJA3ax/EGle8HSbItRjgRuOtJa/FDWvFP1Ume3py
	0Tk7gSFv9Wmov5ih6IG/O2SZvBWdrqQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1cCZAQoR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xXWEmrhn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1cCZAQoR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xXWEmrhn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 40BB36A81E;
	Tue, 28 Apr 2026 09:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777367286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+PLcPEDXVXa0sOl5og5Impq8NYwy8sl9J86BGnNXg6s=;
	b=1cCZAQoRRx5NF2kvJSPKgnH/J18umo8qqCqECuqhTE63VxfxrWE7MTGciczpUjG8R7xEIF
	rzMhL1zInW7VMwY14BXqBYIySvHkLoW3Y4XXCGH45VOxuMa4/0G8XQuPQXYW01+sV/QgPp
	FGaacetOTTI0GtUnMDxdW+O/Kid0+VA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777367286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+PLcPEDXVXa0sOl5og5Impq8NYwy8sl9J86BGnNXg6s=;
	b=xXWEmrhnZVZwZjmZPwV/Ub7Va0Iku6foqi7SkqJ7tB51KSM+Vx7pxwkyfVC00DWy/Oc20G
	tL+/TQ3R5TA16dCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777367286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+PLcPEDXVXa0sOl5og5Impq8NYwy8sl9J86BGnNXg6s=;
	b=1cCZAQoRRx5NF2kvJSPKgnH/J18umo8qqCqECuqhTE63VxfxrWE7MTGciczpUjG8R7xEIF
	rzMhL1zInW7VMwY14BXqBYIySvHkLoW3Y4XXCGH45VOxuMa4/0G8XQuPQXYW01+sV/QgPp
	FGaacetOTTI0GtUnMDxdW+O/Kid0+VA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777367286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+PLcPEDXVXa0sOl5og5Impq8NYwy8sl9J86BGnNXg6s=;
	b=xXWEmrhnZVZwZjmZPwV/Ub7Va0Iku6foqi7SkqJ7tB51KSM+Vx7pxwkyfVC00DWy/Oc20G
	tL+/TQ3R5TA16dCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB8C1593B0;
	Tue, 28 Apr 2026 09:08:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7okNM/V48GlKXgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 28 Apr 2026 09:08:05 +0000
Date: Tue, 28 Apr 2026 11:08:04 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix subpool accounting after cgroup
 charge failure
Message-ID: <afB49BIqmLL2RKHM@localhost.localdomain>
References: <20260427145247.84157-2-enderaoelyther@gmail.com>
 <20260428030712.66256-2-enderaoelyther@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428030712.66256-2-enderaoelyther@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E072E1C0006
X-Stat-Signature: uenezugie85x6fbisu4ofjihjeqrmfra
X-Rspam-User: 
X-HE-Tag: 1777367287-354788
X-HE-Meta: U2FsdGVkX19JfCKYWmfPKD0BXnbEZ5fLsS/pGxxtASnUsl6E0Og3pxYTZ2UmKRHzYT7mQ5YRYHthy0995+mub8H7j+QpcJjkT4CX7TJ0lXhMZzEFVbySpjoFcFgpRGSLDQsOeTK3/JxzzWiROAzylXy4JfihRajmfFwm0PPCJ8Sgb2Ly/qZu3pbgWUOgEqtQuEZigU9c9eetj0yhlB07Y+Ip9GFic+B2p2lrF4OcWpHVZ4dWFMyqMHUAf6/JSXrIQF3EtI051pcBH8EO/M4rygmOhSViGS6mx4nn+2UpO0EXkHSrQUBjbCCG3ndMByuO0jBvLC6ZcrxlNcX0pTyHIn18i4KZJNs5FWHPsiodyyIjJxVE588+Km3X+nJIbpaGmQv6sVCXklasiA0Qssz07UGjOac7n0Kfz5ricsbFReggVQuBDoBwsVUBEZ+CveSHknqvmcwFTEPdls+aFa8zUOlyCGcIIUnB/meSw7Iv4ankQEFoVwj6x3543D95EuzSNbOotVqGzgUsKU8T+vD1VXAhMstiQNHOkK8bziDYPgxafYfIfGvanlltRBiq6A5zj+nrL/jeClb/GxiJIvMJCcwESN96oXTJi1UQGjDeQxvL59eUaR42f+OX9aVY1XsERlLv7Pjf+7FESTGzv3SBtwbusbBESpW4AFGTvtYmEXYDNTby/e9NhPHt86ycN13f3GeEulFxv8mAN4+bd8zopssH0k1daC3aIGderBbWNuEbztkYFOTJ9csrlwYK5f9cJq96eQMdgsSHQ+y3ftUm9TuHgXaK1aO2CnLf+7IG5VE7xg8QIEZy9Lqk7heZVX/hjYIne8a7L2u8f/yN4VSF/GI7mfYQ3zxwEobbWln+f+bMjU2rsQHELxQPhVnc0BOngCXIXf/Pr2klDzn31Eg6hMhAHqvW6PPoOhjiDaifeOE3NfMDHkIGLSi2CKlg8v6ikh/PbjE1eb0THcjjqr6
 LXRsTV3w
 4vmll0soPucBcI0ADhH/GT4ORijUzORTc9JcNKG1GJmbztpuDKVgQXp2L1F4Ec4RLD5fUfm1/3UlUWKPXHFrHTi14MFUuhcqJbi3Ckru5BstKlUyA9Ugz2NUh2hEBYCvgxxtOLAOCtCPuiujXumAIvC5iGhVEWKCGJjnKTS8av+GjiLEKkbGZp/XFAVk6azOq0imMSu84NNWmAHB+8mX2KoKd8Z7lm4uOHXVllYNdsCPhMXka1z4sYsd0znqRmvW4ZQO2CEA77rw4eAx85DLP41P8uf/dkDC5rSon
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 11:07:13AM +0800, Zhao Li wrote:
> alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
> is set.  For subpools with max_hpages, that increments used_hpages.
> If the later hugetlb cgroup charge fails, the unwind must undo that
> charge even when gbl_chg > 0.

I found that last sentence misleading, because we do not really care
about hugetlb cgroup charge/uncharge (besides that being of the reasons
we end up on error path) but rather the fact that we fiddle with
subpool->used_hpages and we need to undo that when we rollback.

> hugepage_subpool_put_pages() can also restore rsv_hpages if concurrent
> frees move used_hpages below min_hpages between the get and put.  When
> that happens on the gbl_chg > 0 path, restore the matching global
> reservation as well.

Well, that does not quite explain the problem I think, at least not clear enough?
So the problem at hand (IIUC) is that

1) if we took a global reservation
2) and concurrent hugepage_subpool_put_pages operations made
   used_hpages be below min_hpages, and so subpool's reservation
   was incremented, but we need to increment the global one as well
   otherwise the next time we pull a page from the spool,
   global resv_huge_pages will be inbalanced


> Skip the gbl_chg > 0 put when max_hpages is unset.  For a min_size-only
> subpool, get_pages() did not change subpool state and put_pages() would
> create a false reservation.
> 
> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
> ---
> Changes in v2:
> - Handle rsv_hpages restoration when racing frees cross min_hpages.
> - Skip gbl_chg > 0 put_pages() when max_hpages is unset.
> 
>  mm/hugetlb.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be047e..4065d66fdcb5c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3026,12 +3026,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  						    h_cg);
>  out_subpool_put:
>  	/*
> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
> -	 * during hugepage_subpool_get_pages.
> +	 * map_chg means hugepage_subpool_get_pages() succeeded above.
> +	 * If max_hpages accounting was touched, undo it.  If racing frees
> +	 * moved the subpool below min_hpages, the put path may restore a
> +	 * subpool reservation.  Restore the matching global reservation too.

I would split the comment in two parts and place them within the block
they belong, otherwise it sounds confusing.
And maybe elaborate a little bit more.

Subpools, reservations and hugetlb make a very head-spinning situation, so let
us make our life easier.


-- 
Oscar Salvador
SUSE Labs

