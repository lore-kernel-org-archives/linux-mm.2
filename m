Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB4BC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9AF66B008A; Thu, 10 Sep 2026 07:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4BC96B008C; Thu, 10 Sep 2026 07:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D666B0092; Thu, 10 Sep 2026 07:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B09816B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:22:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28EACC0285
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:22:29 +0000 (UTC)
X-FDA: 85197614418.17.2B6F659
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5944DA0009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:22:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gNyRJvPv;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039347;
	b=6pmcLo6iO42zugZsyFcPo3YwFcbyFxEt2VWNG6EF8I8ukMk5kZilfD5XI9UgkJrLuoK2gO
	qs0sRysPigudws8VB1WRx4dk7YLu1ubzTFLsbYFunMGw5R/LJrLoO8IPVSsLnIitMNf3ov
	tYLkwMnv3rc+gvrrPWYmvMneyOlkhAk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gNyRJvPv;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ws0rXfuRmoTR7x5ntUwQBKIloOgySdJF3YXvYkohOlw=;
	b=enHvW7FWKiR6MfxYzdj38ZzUUabc4LIBW5TiJsF75KpFwgCjYhcRkbAt7YI5LT9aj2h9Sr
	fRj8HNOfP4kjAgsbP4wJicmG09maeAhB15cQvlaY7nN4WmmpbYQ5HcKiNmu9ac+LOrAdJp
	L+mTuFrhy7FhcGH1OUSYb4tDYp6ZIv0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE457153B;
	Thu, 10 Sep 2026 04:22:22 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED7A73F528;
	Thu, 10 Sep 2026 04:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789039346; bh=38/OLHfK+M+1zXHjINgFF+BX6QfD20XmuFGEDGmyA0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gNyRJvPvTorSclWHavC3DluONl2GqzDYewmuGoFwfuSu95jgspzfpgyIeNA5lq8U8
	 2FENBwt8PF8W4hLeiuNSCZvUO7KTGzv0/LxQ42Zm2/QF8gtjerY30MPZpvnQV1+u8K
	 qE7nMiXoExbF3ZBVGOPVjxGpcw/SpJ734ssJvuCA=
Date: Thu, 10 Sep 2026 12:22:20 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
Message-ID: <aqKS7CP67X4h6NiM@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5944DA0009
X-Stat-Signature: nkur8z8xe3hupd67pjxwrhqi78ets3jg
X-Rspam-User: 
X-HE-Tag: 1789039347-760890
X-HE-Meta: U2FsdGVkX1/JlatatTNtI2WhOXRfYhPibXxhgY6okwy6Iznt1Lzc7FIurx2fHRQsbp8Rs407To1bOIDxnljqgOMvB53vxu1YEjX3XzQ/ZaWt6oNY7+VKKVyRVr18JvjBeTvJp5k3zQzTePfUFuudrwsLBkY6QjXWMIIMri9Weta3HwlAIX7zt7uiZbihSYCly9ZeY72M7GP2845/r61x0IPdRT8itFTmdJsNL6YjJCkwK3LlGeXetKZolznubni5lotrcCKpTtrXWwmWDUAHk3z1qO6I3sASyW7CdMw+Dfcd83KB+wGbfRfPWbCkzQE0cFYM30j5PmeibDntbZbMjieAH8A1zdTVNU7K4Ql84GtRCjO0miGENbB47Z2d8BQNDt9hTkAS/ItnubyVSw/JDq92wYfD7pcYmPbF6kYJ5yao8szX8v60KHoYkB7hABUBSIDoLFZrozQlEKufY8tdhMcSsNSIu+W5rNte0eIT1m8LT79SzL7QtaT7brlo0Z+BbhULNOUSW4+aucRSeAlztZ25nRHUBswHwxqdDKaCeUD4BesvMr96VQ2vPSHhFbTIOZF1bzlOaF4/w6+brCiiH05EohuYPMS18uBpL1yG/AgCR8Kj+mF/bMoAhQDvpMDA1+giWluPnc3JkAdxMHIfmMyidz09F3MCKQujCOrXPSUQFQ+8VZqxyqxLc0BJCVdQC3bNSDD8/eyuDnCVjIW1+bKvLtq63AXd7un0anjQyswuCvzSSU964eYbwK4yigSGBgIR7oR46EFgmZfG25CzxKZOEGKRdUe94Prn3nndGACRmCQ4fqNss6srZvX6x//xt6AIDr+r2kV7rJI8K/A9Lh1nf4kX9s8A7VO8/f+bMfP6XTm/ecs1nlaTIklulLMYL3ZYMVSPtunIzNOz2RihHS6Vrtf06DFfIHX0y1dXol2R9STrXG5c8XutnhCQNuZg6z4lQQQgJNuOFlOZswU
 OhLwnDNK
 BmOiy7AE/aEceAyrLlao0x6in5fw+x6EI0HFXy3dX1uJfigtZzac20ceI0+yHtFmuxT8irG+kBEa3EDvcSq38AEFltF1Laa9lMtJqEqEtkcwXR5gDpvSSjOkBHKGMAWAYgmbs+mGeqp+d+E1hglKYTu2Or//bQ8mtj+pT/dmTlLC0zoKyNSdiMQ+ApnustG/frNEIuL3xXvD2wIDPekEnDKZ0GT/fD8Ahwd9xEACcEeFfSnu/UK5xkd6JsDbIdzWWqRhvMS9Ja/YJGl5hu0F0l13rs0TAKOHSccl064B/bkXaEgBT4anDiJVLmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 01:14:42PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 13:02, Yeoreum Yun wrote:
> >>> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> >>> index 5f278913c4d7..b6fad38c8bee 100644
> >>> --- a/tools/testing/selftests/mm/soft-dirty.c
> >>> +++ b/tools/testing/selftests/mm/soft-dirty.c
> >>> @@ -92,9 +92,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
> >>>  	if (!hpage_len)
> >>>  		ksft_exit_fail_msg("Reading PMD pagesize failed");
> >>>  
> >>> -	map = memalign(hpage_len, hpage_len);
> >>> +	map = alloc_isolated_mem(hpage_len, hpage_len);
> >>>  	if (!map)
> >>> -		ksft_exit_fail_msg("memalign failed\n");
> >>> +		ksft_exit_fail_msg("alloc_isolated_mem failed\n");
> >>>  
> >>>  	ret = madvise(map, hpage_len, MADV_HUGEPAGE);
> >>>  	if (ret)
> >>> @@ -130,7 +130,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
> >>>  		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
> >>>  		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
> >>>  	}
> >>> -	free(map);
> >>> +	free_isolated_mem(map, hpage_len);
> >>>  }
> >>
> >> smaps is really only problematic with merged VMAs when relying on exact page
> >> statistics. For other properties (vm flags, MMUPageSize) it's not a problem as
> >> long as our smap search just finds the VMA that covers an address.
> >>
> >> Assuming we fixed check_huge_anon() to not use smaps, why is this change here
> >> required?
> > 
> > Since there is no interface to get vm_flags not via /proc/self/smaps,
> > It might be good to have it for preventing unwanted VMA merge.
> > 
> > And might be useful for future to prevent unwated VMA merge.
> 
> See my reply on why vm flags are generally not a problem. Just like other
> properties that are not changed during VMA merging.
> 
> Let's not perform random code changes without a clear picture.
> 
> And just to emphasize again: VMA merging could already be a problem before
> memalign() internal changes.
> 
> (also observe here how we do a MADV_HUGEPAGE, so this is all rather arbitrary,
> which is not good)

As I mentioned in my previous reply, what I’m trying to prevent here is
a failure when checking, immediately after memory allocation,
that a specific vm_flag is not set.

Yes, I agree that this could have been a problem even before
the internal changes to memalign(). An unwanted VMA merge could already
occur at the time of memory allocation.

So what I’m trying to avoid is a test failure where, due to such an
unexpected VMA merge during allocation, the subsequent check that
a specific vm_flag is not present fails.

I probably didn’t explain this clearly enough and ended up causing
more confusion. Sorry about that.

-- 
Sincerely,
Yeoreum Yun

