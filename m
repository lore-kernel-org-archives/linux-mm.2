Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 016C8C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 01:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024A46B0088; Tue, 15 Sep 2026 21:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18C26B008C; Tue, 15 Sep 2026 21:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E3B6B0092; Tue, 15 Sep 2026 21:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C94C96B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:46:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68A791A05C8
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:46:37 +0000 (UTC)
X-FDA: 85217936034.20.C9487C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BFC8E40002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:46:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xe4wnLPM;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789523195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUYa/GvKq0t1HPLtH/seZWJgrC2GfmJGoFRdt2lTvSU=;
	b=agri19r18qoDpnts4FNOlib0Ai7Na/7RgEKu4nhT8xUWdfQqFQI496JadXLy6gZoGg0Wey
	B200AA3HptMAUvBkrOy4rK1T3OkJqUb1vBSngjP92+QouiWGtqVNcj2Fjq607Dazn0Xc96
	n4mRjSqHbNIeU3ort1H1Plp+tj70JCM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xe4wnLPM;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789523195;
	b=ME/GqWeFST+GmZy7MDFTIy3mYyQIOOeZxgPsC2sT/PvR5SRpC3ROgQnzDA1ZAI23Dv0OGF
	x2A8mI4paKrXIVB9akyvvCNMW4Wwf4JLVFCiY4EiJ+B3VVrdZpqfzqYqdT5CI6+ZlCVJWn
	WfUellSbKPx7vENXfklw/BCVf+a4oeU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC97560008;
	Wed, 16 Sep 2026 01:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4978D1F000FF;
	Wed, 16 Sep 2026 01:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789523194;
	bh=yUYa/GvKq0t1HPLtH/seZWJgrC2GfmJGoFRdt2lTvSU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=xe4wnLPMzAF02PpoBtQdWpAESwFpnQgwqHUHHMwArKEQ3kVC7isdYXV2pWRF8ZeQW
	 D8+bH/HFkmCtEHk2qeU9BcJuDhoUKKswmdshZhvxE/RT/Qinu2ONkvRa+8SO0iCfKZ
	 LhOCPmhz4FG8PZFU9nRsJ6OBYvPcr+vFVAaHf4H4=
Date: Tue, 15 Sep 2026 18:46:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org,
 jannh@google.com, sashiko-bot <sashiko-bot@kernel.org>,
 stable@vger.kernel.org
Subject: Re: [RESEND PATCH] mm/madvise: use folio_trylock() in the
 cold/pageout PMD split
Message-Id: <20260915184633.e2d8cf719e5eed186d087a8a@linux-foundation.org>
In-Reply-To: <20260912110540.3203010-1-gourry@gourry.net>
References: <20260912110540.3203010-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: byzkp76ftncb4qguue41fus74wojay4j
X-Rspamd-Queue-Id: BFC8E40002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789523195-200360
X-HE-Meta: U2FsdGVkX1/X0H/RI50KE8YguaZC24gwctrn+0ioxpxKe9lltfgnnQ1nC1Eq39XzJRM8XLOwxAWgor9X0cxYw3/HJdADR6/uQTh1zNh+j0gC8I6aOIFbrdVLqB4ZGKSCGoAThAGI6VqGJWmAG1kGwdU2AQo8xzRbecEQGo4CAGaIxHbglrjAkpDOrwEpPEJh7Vr8COYh2SMx+NLIilRQy0bPF06iaP710EyVvzZSERiqCNe4MmyIW73fOpyCgoGQW6XHNdFBNgtn3GvCH857d2UGLHfNaUt6TIKBq1gOG0payX40b2TZxIspA88ocLvnDGOvo+yWqEC6IGIgm1Ze+tFsZtfh+ojkvddIskfLvbQlHmIqf4dPy7H7cQGpf0XEbgNP9cPAtRIF4doMK7ExEJr67tYdWHQgpiCtIhAP+KZhXk6O8oEXQZgMmjzgti/t6ngRMP5O/2i+nKPO32/Eb6cte3+7atUk6+yOewBWPK0/jxbLxp71HAoGu0biK9w30YEDCRyv/IKjqmREC2iJpZ54skvB4Lg8LoCVsj5alw6XLT6qj6A1klg/6nIwmF2Xp3RLq7M6/ZYzX6t6SZPpua/AAkBSzvJYj/MKURIlEhcdPu+KV6Vm/TWzMMWCCMcCcSMUNrsWc+niztHr0yG736q0tGoS9puxWuca90ySHPw+7NQjXfsKXsxIIx2wLYrIJRVZ5xuOPAnu7sQv+zswCr6edbIXG7uOacnuk3ZsKabbxsa24c/Qzypq8m1cvw5dK0HFmO94kcuRMBrSKk41uBouM809rzMbNMx8WVzP2An/7t4kSiqys0W+/g5rV+LB5x5UtYQcV2fpkJSOfhHOU/CuoLic7bcAONd482E1E6DIa+awzfx5VphZUd+0aBfJAFLGWCowOE+kSXyMG5xen5opIIdUY33BSFemfEmh8+Udw/Xf8ZEAvv1vAWYK9HonaSbIxc6p+OGSpjuQc+u
 kykTjq6Q
 p5Ywtl1nso8h15XbFflbhmqZIzlNsrN3RMX2+vZgROwqxxF2fROByWxXDfrinFTPqxomzZPkKUCwMRqSYnTscx3oNmSsGDpX0KFG8gFlvlCDLUWOXGBaObed6z1HXX8bUAqPcb2Dg+yk9teFL5+sWBHfHxmyhDIzQAJq0z83cQhGm2SssMJI2C5M0C4Kyr52H6SLsAx9IuVwYeM3iNkwLxdLNlFvbFzNDEth/PyD/iIIPVyzaQjDM1ta5lm4U16n5YKoA24rYFRP/mpMIwqmJsAp6bwjrZNDOzK0fML3UoG8+RWNJD1f5SVQQv3vjBqAOuNPf+PaE8pHxwNQITlLWTL8q8dfMR2UeqU2nR/zpNtoadAOkBDObF54yyN5+Sgss15FlxB0foOon/sXeb4wN766TcrgY/hBTb8vt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 07:05:40 -0400 Gregory Price <gourry@gourry.net> wrote:

> MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
> madvise_cold_or_pageout_pte_range().  Two threads doing that to
> the same THP create spurious failures.
> 
>   CPU0                          CPU1
>   ----                          ----
>   folio_get()
>   spin_unlock(ptl)
>   folio_lock()
>                                 folio_get()
>                                 spin_unlock(ptl)
>                                 folio_lock()  <- blocks, keeps its ref
>   split_folio()
>     folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
>     -EAGAIN
> 
> CPU1 cannot drop its reference until it gets the lock CPU0 holds, so CPU0's
> split always fails.  folio_trylock() makes CPU1 leave without ever taking a
> reference.  The PTE branch of this same function already does this, as do
> madvise_free_pte_range() and madvise_free_huge_pmd().
> 
> Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
> of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
> /proc/vmstat:
> 
>                      thp_split_page   thp_split_page_failed
>     before                     3186                     860
>     after                      3200                       0
> 
> The short before count is rounds where every thread failed and the
> advice was dropped for that THP entirely.
> 
> On failure the walker returns 0 and nothing retries.  The PMD path becomes
> best effort when the folio lock is held elsewhere - same as the PTE path.

Can this result in more EAGAINs being returned to userspace?

> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -419,9 +419,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  		if (next - addr != HPAGE_PMD_SIZE) {
>  			int err;
>  
> +			if (!folio_trylock(folio))
> +				goto huge_unlock;
>  			folio_get(folio);
>  			spin_unlock(ptl);
> -			folio_lock(folio);
>  			err = split_folio(folio);
>  			folio_unlock(folio);
>  			folio_put(folio);

Sashiko shares my reaction, "dear god, why does that function exist".

	https://sashiko.dev/#/patchset/20260912110540.3203010-1-gourry@gourry.net

Like the entire function, that random mix of "goto foo" with "return
whatever" needs to die.

Anyway, please check it out while you're on a roll.

