Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E23C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0032C6B0519; Thu, 13 Aug 2026 11:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D2D6B051A; Thu, 13 Aug 2026 11:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E329A6B051B; Thu, 13 Aug 2026 11:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B53DE6B0519
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:03:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33D8AA0188
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:03:58 +0000 (UTC)
X-FDA: 85096566156.17.212FF0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 65FE314000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:03:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kwjSEXg/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786633436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lG3zV3twxP6cvWSTtTMCxPV2icRp16EvfrWsqb8CIS0=;
	b=tRDFw9acKPPVQb2SxkPjNJhzwsUNBCrllOWU+wjwZmov47BewzTlozK9hFa24K42FCHvSQ
	41Qdd2Qwd6M9CtMbWyshlkiuQibpEF4/J9TE9YlW6uoqu3ru4dgStSNoPgqiZ0UsVtbWFh
	uB7KqvCi+eqiYxBPydWJP7gdPZa1UQ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kwjSEXg/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786633436;
	b=MRdGzQJ0qHasigtuCci2FKTHT+D6dl48LuDjMIRx1zXZj/D3viKfE2qucntLmWtTs2fBvO
	WcsXqYSrlnRuTOnmshDUG+M/1xT3K5T8T0ms1BJEdBZbCNAONlmC/Vdv5OFFzh6VpFhSyF
	SPEOG0HonLj155gEgyp4rDhY0mYgnVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 901A940AB6;
	Thu, 13 Aug 2026 15:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CE91F00A3A;
	Thu, 13 Aug 2026 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633435;
	bh=lG3zV3twxP6cvWSTtTMCxPV2icRp16EvfrWsqb8CIS0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=kwjSEXg/X7sDQC7OSUH1Ll19xo/z0ISD7nwzmG3Zmb57M2KzTPKmNd+XmIRZYTKuj
	 anvGPML9EN5xmdQVniMrvI4+xQIrNDv0uIGPEkcTE1iRTbOc9OBMgRwytgGQ3X7lMk
	 wv3sb+mLUrsYv3SBuvRbLiOqhF2MlUaiglgdfyOkpJg+J89YxhyPp6Be/hqYLjNE+w
	 C5ux39OVWqcdatrmunlw9D60/hvzb0jJdx/60jzrZPsrGOn6CTHUVmd+AlXR2JQHbu
	 dqRQOuyqyJegjG8ZLf2cb4QzuXgeGB4VTsrwJRQyoc8CPYiuG9n4015cKPGnl+PgLx
	 A6CCG93oxtNJA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 03/18] selftests/mm: scale khugepaged's collapse
 wait with the PMD size
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260812132304.199287-4-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-4-kirill@shutemov.name>
Date: Thu, 13 Aug 2026 18:03:34 +0300
Message-Id: <178663341429.2230969.16814293811889477740.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 65FE314000D
X-Stat-Signature: xqrinei3fbwpx1masxba8nxircpikgbs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786633436-383644
X-HE-Meta: U2FsdGVkX19DSS6CVKwEGVtej1tQjO2GhnsgxHce3+w/gFBp/LTV/k2bMnRl5Y3776d1uFLKQU8vzQPgZtbdScccdHlk3dCD5q6tZ8XFgTauUWJGgvBn3Ky5uGO0AQv2JBUPpTg0p3+pq57JGxGBh+rC3cgG2QJXzZldQM7vWfg/XjsEjsDcelc/KEydvtVmprIKw6B/MA5el46ZMOc5e9kHWXcxJpkuznxMGDXqlwUDRSQBergUArh8DhWFUnYHSRx73n45byjmNpiZXxFrcMKeDkP7rrs9CKZPiqziGCzpIT7U4u5hbLytrOFj6J5mothVdrClINMtIRFulQMjqt7PpLNd1JoSYkz0mXp/KclJQXzkkd5z9x9PLwEvLreBoefdrWcQPxLmbHMNcXkvb+vmigZXh46lvjjspdkib0igGkuKS5Fj5wmD4yYUaBbPHivWRxUHRstjBLQnKZSXgkg78Ivd3ZvYKelb49LuDyoOpdlCxYjV1d6ZzZdCwoLyjRxGCiDGQOwL2gaigari+CTK+pdYwx7W1oqZj1O2scMfCh48/8Pc/wUyINmBynK3nXxSPLU7aLw18pvrswhwKhnUlx5zX2GzfiZlEDI6rLEgirEwZpCr0MiASmPRY/+fquLXxDM6jMjCAbB195P8Oxk32C6DHWUVBekVEN3WSni/5BEw3gUnHzduqmVh9FTvHMMauHTbR6DECeeZBpLdVKlSnP36hOWUdUqKWyz7vhMO8FB7eizGHDFvys9SHWmbf/VNVcsB6whu+3Pn64G3zmuylEvmJnM3dqN69/QcUw3Vpidd0bMbCas6MhwZqjBP8vAeP2k4YmaZ/osc8kNpYmrPVhMlWAlfHbcx5jk6ayzuNvZPzhMT961ndN2D9ycjECkhgPqh2G6e4KPOlX5accqcB0aa5jVr44VR8YJPAHUGm0BVqB9+YGdatrb8I8+Ss4C8QbwTd2M1qhVG3C5
 7btMJtOb
 BHZiErMDPTXOToaEslzxOqobPrFJIWULOmviJfGOsLZN5o57uZB7h7ShuzNTZP6qrdRKxJMFM025QOVbCrEEf065nwWgZ+diqF5rPJOjLuB8YQuxaNBQk96aT1qPxeD/wvrF4z6q8UX0uNYInvLuh5mfkv5N+P+0U80/Ne9bIUl9DEg68a/uMo1FM6m/EljwxsM55yYUnOK7xBuCgYUVhjSQuGJDEs8ayDP6I1g7vLpCX6jdPdGGuaTRMBKo/gfyp+o8TFWJtPRP7ZqTh+mcO6+XcQzvvFQ9GvaVLV69pMEtjoIXYnJdNSJJkoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> wait_for_scan() gives every case the same three seconds, whatever the huge
> page costs to build.  collapse_full asks for four of them: 8M at a 2M PMD,

collapse_full() please

> but 2G at a 512M PMD -- arm64 with 64K base pages.
> 
> Three seconds is thin at that size rather than generous.  Across 80 runs of
> collapse_full on arm64 with 64K pages the wait was half a second in 73 of
> them, with a tail to two seconds, and the case has timed out in a full
> matrix run, reporting a failure for a collapse that was still going.
> 
> Keep three seconds as the floor and add a second per 128M to collapse.  A
> 2M PMD is unchanged.  A 512M PMD gets 19 seconds, which is headroom over
> the observed tail rather than a measured requirement.  The budget bounds
> how long a real failure takes to report, not how long a passing case
> waits: wait_for_scan() returns as soon as the collapse turns up.
> 
> arm64/64K: khugepaged all:anon 21 pass/1 fail -> 22 pass/0 fail.  x86-64 is
> unchanged.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 48eb74c255f6..a5ada78d90ee 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -583,8 +583,10 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>  		int nr_hpages, int collap_order, struct mem_ops *ops)
>  {
>  	unsigned long hpage_size = page_size << collap_order;
> +	/* Three seconds as a floor, plus a second per 128M to collapse */
> +	const unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
> +	int timeout = 6 + 2 * (bytes / (128UL << 20));
>  	int full_scans;
> -	int timeout = 6; /* 3 seconds */

It's a pity we lost the comment explainging that timeout is seconds x2

>  
>  	/* Sanity check */
>  	if (!ops->check_huge(p, len, 0, hpage_size))

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


