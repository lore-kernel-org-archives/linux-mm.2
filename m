Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50CD3C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D74A6B00A6; Thu, 20 Aug 2026 04:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE016B00A7; Thu, 20 Aug 2026 04:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBF36B00A9; Thu, 20 Aug 2026 04:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14FA56B00A6
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:41:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92A95C06B0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:44 +0000 (UTC)
X-FDA: 85121004528.24.CB90095
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 021DC18000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rkn+3slG;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgMVYj6pSn8hHC+0OFiCWoGGfzQGeuq+YzQcBDvrKUA=;
	b=5glOAQVNzSnFljojoTdNOSq2CttuFeYdo8MY6LTm5MS4hV9N4iasVslktNPCNVT5vFFm9g
	vZC0duKJOLO27UNijO54ecHC4d4ZcQYPqCLf0+PMyb89dQ5csfadsuBnVLtS+IVnpSM9Hs
	Vcpr/U0/rjHyS3RTBshO9NnTknPf3Yo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215303;
	b=gAygY+nWmnzIXKbcOyabne8X03OYxts1+jR6Rcc78Woc0xbKH/S/o4G8wVnKdmC8VJjBkP
	iSchhx/62TrKlvowphYYORfShAxCiQmafvb/HPKnm0ztIcfHP/UA+saSzTY5O6xVxz4t6l
	U4P4A+VOSKhwg5m7gj1HcWv2Ovp/V3Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rkn+3slG;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13067419BE;
	Thu, 20 Aug 2026 08:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5AD1F00A3A;
	Thu, 20 Aug 2026 08:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215302;
	bh=JgMVYj6pSn8hHC+0OFiCWoGGfzQGeuq+YzQcBDvrKUA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Rkn+3slGUAwpwbgVDe1i5YsP+M1oRKUmAmINtSB2sHiKfOfk0e9h/5PCj60MpfUSg
	 78AVlYHJj5fLr4TU6XUc0QgRND397FRzLc0a5FSaeohzWlBp3zvkTNje6cJuQPjRyo
	 CUu0KQT58Y9W8IhT1KVt0C/cFdA/F+HwVXSE4gO70SBkFVL7+4EUEas2nwmKGS458Q
	 RTAYqBArZY7wh+3o1UvHab30sn5mnZx8JdOp1tKGTefoHT06BslHWyo/200/ZkaG/p
	 h2CSplMikEem692BFSjxUMGAe6MSMTqjNCJqtFDDiFWBsQ++D/vbAcQknjwT6GKab0
	 hpiVZZDRZHvNw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 14/19] selftests/mm: run every supported collapse
 order by default
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
In-Reply-To: <20260815015901.1236937-15-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-15-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523517.2799959.4743479069072747086.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: qsjixjax8ty7kmxecsszb567jdyno8aa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 021DC18000A
X-HE-Tag: 1787215302-719584
X-HE-Meta: U2FsdGVkX1/hK7DU8lf37tdAF/IljQIC1PJdPwo5k+PczreJn7QtEr+3IUvK23Ykb7n+156CqOmJ7srDn2XHdJMH604F293UncBi0Ag/iPXu7Pi3atxOm/3Xhdg1mJMnV3dGnarJmoe4cNh9iyKggKGPiEqyDx1WmaLAeJ3qE5Zje0hUNzEogx3LUEPE4v7QsgjWIsKr+kg57XB2VULNS1E0g7b4T9L8GkLnhfm0gHOwbcxqc2ej5DNgoLgdaMStc1aLPnndS81Q5ZmRu7UVFG95s1nrBxR6Z3MDiRLq1KvEwNhFSlanHpu2UPu8DucEowEPoEM3HHBWUd+iw4LGM6EsMPpQsfLnUoh1uEbFedqNsmnSENzIMEghAYpzcXQJn4knUMdldU+hgxbeFbT2aoiYbmRw31ZpRWp7UbrV518nult7OHO7yZUZy7CtESpwzxNYVWtaDLgmPshcY/aRVxQEXkw/q4p+IvAN0wPIggJmeL/g0esYxW1UAEPgf+nLfubmYsSmLNjVR8aWmF1EowoJDrn0XR4lwkgE8Hl1RUJ0NWW3MhQXTYaceUUUvLiSmkfXIaE+9lD8A05CHLmSUSfMRshFReiONPL3C8uq5ysOHiIYNd2n2XRdj1l5RYBdzkq1eeUbOB/Wu+mDmWbvrrFlbBXSpZk7QiBHDs3o48mlH8ulfzrnK8F9itA/qbmH6GK12VTAG3TPXCYESUgwb7CcLoxDRGD1TOxLqFGJFOnxnc82DePvOSF97pQ7qSODMk2tYTL5hsPyWhgQq10C7O7iBn+zoN1x/D80FfbFXrMYdoi2PzA2jRyZ5kVaRXZbtqgH0bb40pldg0uf30/PDlDePSw+bj32M5ywiWfUJIowwpO8vVNtA/RC93bylMuiBK4LpsTZB+rAyr1FuD8NC42lj/H7oACJudjIxo2jLpJhZyA5eV9s4ySbbaXzk4L1/EAUFOOmf4/epRttwk1
 9Prqf1g5
 h8rPVpiJ+yHR9TttUEML+srfLI9JjSRZAu0Qh18IKyHVl4ebEpfr0lNL5umDdVxudu4nGr+18DjXYF6+exYtgGkWFb1mo2VSVaWYU2UkhyfGEVdR1bq26YTVR/1ZzY78PBnFTyOZ4nE08vA29OC2aDRAhK723vas2Xm1wcUb3z77MQXdtsu+4xKkV4GQkGHHQuZHv374wN0vVK739gXWdP0jV9Y4vkbAGj4U86cFUEPmI75yYukcjS6VXxdHq+ShZnqUIlVJwV04jlcbOEtAwrSx8aaqB4Hj9fZOtRtFp1yi9ajE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The mTHP collapse cases only run when the caller names both the context
> and an order, so a plain ./khugepaged covers the PMD contexts on anon and
> nothing else.  run_vmtests.sh pinned order 4 and covered no other.
> 
> Run the mTHP cases once per supported anon THP order below the PMD when
> -c is absent, and pull that context into both the no-argument invocation
> and "all".  Around that:
> 
>   - -c still pins one order, and now says what is wrong instead of
>     printing the usage text.  An order at or below the -s source order is
>     skipped: the sources would already be the size being asked for.
> 
>   - Both orders end up as array indices and shift counts, so -s and -c
>     are range-checked before they get there.
> 
>   - The mTHP context has only anon cases, so a run that names a different
>     mem_type -- "all:shmem", say -- drops it again rather than refusing
>     to start.  Naming both explicitly still refuses.
> 
>   - A case carries the order it was registered at, so a result names it:
> 
>       # Run test: collapse_single_mthp (mthp_khugepaged:anon, order 6)
> 
> On x86-64 with 4K pages that is orders 2 through 8, and ./khugepaged goes
> from 28 results to 77 in 21 seconds, so run_vmtests.sh can drop its
> pinned order-4 line.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 1d357143258a..ba3dc1718e28 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -31,6 +31,9 @@ static unsigned long page_size;
>  static int hpage_pmd_nr;
>  static int anon_order;
>  static int collapse_order;
> +static bool collapse_order_given;

Maybe _set?  _defined? But surely not given ;-)

-- 
Sincerely yours,
Mike.


