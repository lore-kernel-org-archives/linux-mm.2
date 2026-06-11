Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 248BACD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 04:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB0C6B0092; Thu, 11 Jun 2026 00:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3506B0093; Thu, 11 Jun 2026 00:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8D36B0095; Thu, 11 Jun 2026 00:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3446B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:59:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF4E78DF07
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:59:51 +0000 (UTC)
X-FDA: 84866429382.26.3FFB49C
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id F3CD940002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:59:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xVX77qgz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781153990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olVhfg3NEWpQLGN9PkoN1WiRMMqgtasFHpPNFq+p3/Q=;
	b=h0VmlREPtCja3Vx2gp6ExnGWNKOMGLBx+pBFVr+0F9xACe3BLqgxkdmoNpPz83PxgaQ9Az
	MlU1xiuqPkJCwCU+1+UYe6D5CN5ytXYA51thHYr3LJGSsz2ks9AKJXErdm+4/dt7x5TDA+
	C6x00V0zAiNW2+d7ltr8k92TTU8HIdk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xVX77qgz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781153990;
	b=Nk/JbvVRJxosfORxtDYn+9LENA8q/+44QMj0neQmWAW78FSWUxiH/0FsCraXcarhTvTGeJ
	Vaq5po//VQ91n3IvYHVpVTRTGUGUShdCvAguyJ83JeNcBobd3MG0aOzOdNtj5nW2g2gG0r
	KUVjQXTzkqdwdnqIJaB3NR/njXSNmyw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781153986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olVhfg3NEWpQLGN9PkoN1WiRMMqgtasFHpPNFq+p3/Q=;
	b=xVX77qgzzWpB2dtGel2aOvtMbqt0SvebFBcvCIySMMutTS4cLsb27X1Ygp9iUvEZRiDeG9
	XDZPDpn9RB2qwVHRMe2W03ZegyAu8dnQk2h8d3K18Ae+pTCLWvuUakWdym7gbhPt7hiAYm
	cWVUoDuAQ4jlrxrL//sg4vMVkkNzj9Q=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 07/11] mm: khugepaged: skip large folios that don't need to be collapsed
Date: Thu, 11 Jun 2026 12:59:25 +0800
Message-Id: <20260611045925.36457-1-lance.yang@linux.dev>
In-Reply-To: <9e05e5ca589e1156f75078951efe874118f88587.1781083630.git.baolin.wang@linux.alibaba.com>
References: <9e05e5ca589e1156f75078951efe874118f88587.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3CD940002
X-Stat-Signature: y74hdc1ddr7qr9e4x5n5ii7eejz5mcbd
X-Rspam-User: 
X-HE-Tag: 1781153989-509581
X-HE-Meta: U2FsdGVkX1/7Qq/T0LwapJQuArfgBJJOqxnhpiO0cTucO3d7tzP451Uu0klJjZjE/xRHc/obIrPg9VBi76TXqg156BiQN+uR4LjM99GEgNCfIWW3GywzB9My1o7o3rx4skaaynzgjiztnRWPqUt/s1XLwSKL+yathrifY7UaxmyUN1Vy3yd+wz2mwAzcnYh+GrGeqBZj22uoF/b5fPovEsIqK+dn8K5FbpTTJpvS5DQMG1aL5TP7YzYpXzqokb8djYzkjYIrS2d2k2X86d73iTH3U1OLjkrWL52Yxp66SSHkamaBFbIqV2dOywLnMsSbyZiIo2PZD8n0LIa+Yj3W/zvGQJGRF8ghatM+xqNTtULavCMFchjPYowaYHpWkhwc8LJxyGX+JaHtcnzZLRJO/9QZyqUxsr50UB1tmK+RTIiZE88PYu11fIlkcloks3TquXQbUMUkOVpD6jgRJCXMN+yFysdR/uybWqVKC2z3bmYGvbcLRy/gYJ9kDrdGM3bD5zQkByJundli/n+Py1g3Y1bLc2psK3BHRFRdfDgWm47Vw8VI4m6GaOMtU3Z+2I1YPSIw8QnztEQHBPHHpwh5bHhlR+UnCMcvUByNRAdMCFUjYY2OE48dkxUUbp1HqxDRbZJNjLiBLKCBKlMTPepTwvm6wnwjA9SeH2XanPnzAj1+KD/FNNsv+DsNAfy31pxCjLUsc7PZu5OKDeMnVDwgMQst3fM3hPNtNMp9KWfLytErOyjyw5aVkR/xakPTIhKibi2kk3oOLas0ZcrNXL6rmwMl1v4x9VbuXwGKLD6zvmQhilH4xd+RFVlmYBLdQ0rrPRZLGFIgNsYA9xYb0M8U9WUVNeIUr1/4i4XLBw0TL6GwvkD9kbd/JhUYufDbhwohzFmmSk2nenfAn2/yE2628LooRpZcs1KSimlz0moE8Ex5MY02SILA13tNc6lZIPVz8TB+055UOc29ZMV+Cb1
 lQUGlCy+
 I4V0Zz6dq+u60NZtcVRalse3iY4cWSWo64nvdU9/8ypLknWz0FhzgIqYe1FymFUbT95m09FYpAjmkJpTnvdTOwWMzqFR/PEVxbhnIGQusmUfJ1DO8T4pc1gA+ov80gObbX9DsjOKeGKp/PVcsITN3b8yybQtRS/sHwp6mc0UjBjGt74XB27u1s/fRLr2gjKrtTyc5/WFMl1Vr9/He+NDqMlExLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 10, 2026 at 06:29:15PM +0800, Baolin Wang wrote:
[...]
>@@ -2843,6 +2853,11 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> 		goto out;
> 	}
> 
>+	if (bitmap_empty(cc->mthp_present_ptes, MAX_PTRS_PER_PTE)) {
>+		result = SCAN_FAIL;
>+		goto out;
>+	}

This check seems to jump the gun a bit for MADV_COLLAPSE ...

shmem swap entries only bump "swap" during the scan in
collapse_scan_file():

		if (xa_is_value(folio)) {
			swap += 1 << xas_get_order(&xas);
			if (swap > max_ptes_swap) {
				result = SCAN_EXCEED_SWAP_PTE;
				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
				break;
			}
			continue;
		}

Holes don't set the bitmap either. They just show up later through the
"present" check:

	if (present < HPAGE_PMD_NR - max_ptes_none) {
		result = SCAN_EXCEED_NONE_PTE;
		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
		count_mthp_stat(HPAGE_PMD_ORDER,
				MTHP_STAT_COLLAPSE_EXCEED_NONE);
		goto out;
	}

For MADV_COLLAPSE, both max_ptes_none and max_ptes_swap are HPAGE_PMD_NR,
so those checks still let this through.

So now we bail with SCAN_FAIL before collapse_file() ever sees the case,
even though that code still handles both: swap via shmem_get_folio(),
holes via nr_none.

Am I reading that right? If so, looks like a regression ...

>+
> 	result = mthp_collapse(mm, file, start, addr, 0, 0, cc, enabled_orders);
> 	if (result == SCAN_SUCCEED && !cc->is_khugepaged) {
> 		/* If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp(). */
>-- 
>2.47.3
>

Cheers, Lance

