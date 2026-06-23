Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA12CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20926B008A; Tue, 23 Jun 2026 07:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB1A6B008C; Tue, 23 Jun 2026 07:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71EA6B0092; Tue, 23 Jun 2026 07:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7738D6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:37:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E547E16700B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:37:51 +0000 (UTC)
X-FDA: 84910977942.18.B77AC3D
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id E1CA4120005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:37:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UFaS/IGp";
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782214670;
	b=acNXOFUWQyRQQXXHmvf8Le5P+ZEySBNjVuTor7Hiz/QEQ/GzpP8P9qDiUeqo3fzt5I0L7g
	y2iTzwSoRh1dXorNDxejNn1JKXbcQje/KFNMH1r6Xd+hBgAFOHKX6nXD8uLIRcv81u9HB4
	vlokL6RuzmOA6k29TKmskTJJVXr2gxI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782214670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/a2x5Ghb20XmVHJR+ek7GnEWJsjkaghf0C6SjAspjc=;
	b=lV+4/SmhxXDlgAtH2/a6hFNBec3tv2kYvzQELWxiB+I9eIvYvYJ2ZE/C9Z/qnW25jvPHCD
	Cxzen+f8jGwC/LQR1CdHep5bDJ/xHt2qNfI1O5v7kbLC9ZPTjWIpmv/vM41hFW9ySieQhi
	F3qiHTH5pPW+Y6HTwKxDFmfA9oYkuVM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UFaS/IGp";
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84229481d44so2444110b3a.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782214669; x=1782819469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t/a2x5Ghb20XmVHJR+ek7GnEWJsjkaghf0C6SjAspjc=;
        b=UFaS/IGpkSYYATqHfG5Sk2HSynZzCFwAs1pmksneAKVU1XB/MbekgOGUp1IhK0E+ls
         yV95vS6FWhQB3I4qDfeJ/Mb1JaNKlSRwgZpX5yK83ocD0fFOL8cOUKSimp35yv0lb1tb
         BfmDW//Nx4R0YqMolNG4sgoHLrwU1p8gXNR1fDRq9lGFY/+v0lVKE9H+BBuBn7I6Ldnw
         lhJrqgQGMmIpos8lIc1SBJo2wk2tqcxbycyG8VzMgHA7yHsT14VoPYqlj3KwUW66PBvV
         SEClgv4a+rkLKf7VkbJJyLvVh8FGlP6mqb9awq7+7QxE2UllzJDuvzF3iz8loNot3oMz
         YgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782214669; x=1782819469;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t/a2x5Ghb20XmVHJR+ek7GnEWJsjkaghf0C6SjAspjc=;
        b=Wf7X+Ro9iQFPDwQoGu3PWzavj1mtqhpsAiYpy1vfKqtehdXAK0FBnuevQUNkkuFDSk
         xYgvHWC6cHgq0dyxaqH9Wkw/xUiyw+JMgHFT1+aErw1+/pzg3jdFBeQB1hTIQ3QgfHwC
         WkeLrgRS/dbmfKhH0siKTO38KrVbytOmlKMMhbE1qOuiYpuHF2KISV8zxKQyuPT6JtB6
         a9LUrMtLkUO4IiN4c6dtItS/tSIVWketlzLVueRPpO2EXBDpjeJOMTmFpRXn76jDMvaS
         aNVbODNtjtvl38iCrbtYIuNQK/w+ErSZyAVTm9prFjxvQJClUuvaX/SKiWQ2tQ709Z1L
         xUiQ==
X-Gm-Message-State: AOJu0YwmYi6TSM3r65clPb1XPOMm2eX/G9EwIxSAeNev3cOGmt5KetZn
	dbEmkoN5sWimHhd5IyIGjjacVaQqYnL4k3v+/BU+vTHQa+Op6ieTXvza
X-Gm-Gg: AfdE7cl3R1QFtys2PmcmFQEDOoLc6nUSc2paQ1/DQApfu+ejENgZIJDwIgh2jd7M79S
	vkU5LPCCMTQmhG/TSTRswEICMMS/zae3M1xK+Lxzihy/7yo9Q5yPh4E+ol1nsn6pY1JPRvj9S+W
	A25nI5XOs3TGbXHh9riJXRPz5MmowUnVtiNbTqgLnJkqitGgG7ebpX9j62C3BAl5TrXWnTdoAYU
	P6H+0FOsqoRuuATW75JzI0pvCm5Pe+amaKddmfra6H+KJ5T9jYL/ZbfJW3f7ru0tBKrQe1AGAJ0
	PPtRNE8cA/GgMm1IUpVWcY7miRpcpYPjpo+OQmve6QDUvyL3YFZceUfSi46cOjW9JdnvmqBtyqT
	hqyugJa3YV4+00nWFnWJVMhyz4qfg5E3eeqX2wsws11OcOFGuNjT41MPo1p1l8ueGFlaKqZssqJ
	JE03HEVZIht8JgJko=
X-Received: by 2002:a05:6a00:4b51:b0:842:4327:6cfb with SMTP id d2e1a72fcca58-84597123e04mr2464203b3a.46.1782214668486;
        Tue, 23 Jun 2026 04:37:48 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564ef4c09sm11953864b3a.61.2026.06.23.04.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 04:37:47 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v4 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS via ARCH_MAX_PMD_ORDER
In-Reply-To: <CAGsJ_4zZBf2dGjG2SF8VkwwaYm-oFpmFEJ+Kx5-DuNk0ez7xbg@mail.gmail.com>
Date: Tue, 23 Jun 2026 15:02:07 +0530
Message-ID: <wlvpwqjs.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com> <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com> <CAGsJ_4yTY8g3M7qmpM7HeUq=E05e7v_QFTzk=2D5Mv3Vj3Usqg@mail.gmail.com> <33ydyd82.ritesh.list@gmail.com> <CAGsJ_4zZBf2dGjG2SF8VkwwaYm-oFpmFEJ+Kx5-DuNk0ez7xbg@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E1CA4120005
X-Stat-Signature: bakrnxg19u57eu5sih5pk8srsqd1kdn8
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782214669-490182
X-HE-Meta: U2FsdGVkX1+b+ecXgUx51d7o36Se/VxFjlIKwAWFJGNhSb3uQUvIJuCVfUa7FTQp30b0ezEQoL0aGESw2KZGEMQ1WIhLSYWGboJqJlyDf3nUuCDloub89gguieeV4FDtRuHLLxqDmQ1nmg1I6idylBp6nsAzIcMFSD2F4cU8NBNX9luJdl+p0Xw8YkRT5qZtHNWiukqPK5iVJEdBFOjqbAWV9iYLduEcs2yJimejfSRYYpzlUyvGSnHTjA912tbsMz+fpZ6Evi3Gcyj4jNYmcxpWLt0qB0ZtlFJd2VgOPOtfdHS+tLhV9MT4hmBglZ0pqIVUzdSToa5rsUOLn0wD1OJ1pMWM3yruD5gt64WmahQKlofnSTsIytYKX1LwnYAfKsCMfIfrMKouQ8B1ELWJgOxEDVwwyC5p9B3jdkgkZCcWyhM2LhgwsE4Pgt3wN8C0RB/n12UIvzXNKwmxhwyC+zYj/hNf9wn+Ax5b+9AJx5aftKKPJbagPR6XJAngUS/+ByP7uqLMkk6Ku/i4No8f+J2Cq3Os2eSnTYOzvjHfjVZ7zow4eSXzIut3UOS6Ac71VA2dnlfSdHs+uSG3WPSwriEw/OmXDTWK5HyH984kIaGR1EhSKRgknCyrP+q8Yk2iWAKDqTPyoSeuHr7ttGGKyL7n6QjgNWApodJn2V51UadvI4sj3UHIbh0qVSh6IVYRQAnWt6cQDgMh41WNoJ6gVeKdDeecF3QuUUpyYvgjI0l/7BQ0oUSWLDGKdDXwOfi6F8RmQ8hWOA10fifb/pgJ6TEDmyHNWi5GhzWDRLsDdaXAV5KzkfufFVpoFNqS12rJrrVJaa9n7ygRkxtYlSRv4dmw5UezWBqNHcPIjZmkhvngik2dsgrDiyIvXiGu1HxDwUlqys5kVE99TWrgnIx3kWZ88YM+CXwQr3tWobMy38QdU9fCxeC03hMgarvVsaafkT7o9ZW30pe+pSk/ipq
 z8XQCOml
 hnE43UW53pRZ5vo4tNkMKkEk068AuKoXkK+Ulo2cw1ANYfIJaWzPrcfeTYuhD+E8HKXu4OMwXnYG8OAzG2jyQqZpVq7ANC6gb+xE8yuu4JUcsvmwCbnB/CkeimZGWeYNPiXBmxS3/5g2ovyHRGzLMVfbOQ2QYSwJ3D7IS8V7tM0Dkp5XgIn21eAoiGWkaLhvL18QF9qAaYLPJZNS6hjTdGOpj8m08cXwVqW05xLN22wgquP+VCTiJefgXQt/i1ds3E2f3utiuOhOvkTUZ0k5vwSMuI3H3PXyd/wbNftcWd6/EZkSm89Vwu66oZOU+K1IzZs+BFbqpK3WGhQ51d2dCJ+RYtY6O1j4sOLQ1n04s27S9KKQcx9DRmWhbhI4mbX4NQiXHDyy5BaMri6lQWnmBiRA8a5rMSX+AcYm+/Jeyryvb09ppSzKYXN1umCv/DYH8gLHmG4VNe+gVS8fT+Cphofl4H3bBr5LJXr0MvrNgIPjfZrlxj6X2tEm9cnI4m9hYpeyAUsJCA0r0iWiXtdCJGEsu58Qak4JB8fQ4AjKqPEH2ytcQACvjRab2MCe5ZOAyZnZqOpRKcjuzkvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <baohua@kernel.org> writes:

> On Tue, Jun 23, 2026 at 3:05 PM Ritesh Harjani <ritesh.list@gmail.com> wrote:
>>
>> Barry Song <baohua@kernel.org> writes:
>>
>> > On Fri, Jun 19, 2026 at 12:41 PM Ritesh Harjani (IBM)
>> > <ritesh.list@gmail.com> wrote:
>> >>
>> >> SWAP_NR_ORDERS sizes a few small bounded arrays inside THP swap
>> >> allocator code (nofull/frag cluster lists, percpu_swap_cluster's
>> >> si/offset arrays, next array for rotational device). This currently
>> >> expands to PMD_ORDER+1, which only works when PMD_ORDER is a compile
>> >> time constant.
>> >>
>> >> However on architecture like PowerPC Book3S64, PMD_ORDER is a runtime
>> >> variable which depends upon which MMU is selected (Radix / Hash), so in
>> >> that case, PMD_ORDER cannot be used to size the static arrays.
>> >>
>> >> This patch provides an optional ARCH_MAX_PMD_ORDER (upper-bound)
>> >> override for such architectures. The memory overhead on enabling this
>> >> override is negligible. Even if we make SWAP_NR_ORDERS runtime alloc,
>> >> default slab padding could cause some memory waste. Also we lose the
>> >> per-cpu cacheline benefits (for percpu_swap_cluster) because it might
>> >> cost an extra cacheline indirection overhead in swap_alloc_fast() for
>> >> fetching si[order]/offset[order]. Note that a fully runtime
>> >> SWAP_NR_ORDERS was considered in previous version but was dropped for
>> >> this reason [1]
>> >
>> > Do we know the maximum PMD size?
>>
>> ARCH_MAX_PMD_ORDER will be 8 on PowerPC book3s64 with 64K pagesize.
>> PowerPC Hash MMU with 64K default pagesize supports PMD size of 16MB.
>>
>> > On arm64 with a 64 KB base page,
>> > a PMD can be as large as 512 MB:
>> > https://docs.kernel.org/arch/arm64/hugetlbpage.html
>> >
>> > One concern we have is that performing I/O on such a large folio could
>> > incur significant latency before reclaiming any memory. For this
>> > reason, on arm64 we initially enabled THP_SWAPOUT only for 4 KB base
>> > pages:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d0637c505f
>> >
>>
>> That's not the case on PowerPC. Max PMD size for Hash will be 16MB.
>
> Yep. A 16 MB folio might be fine, although I'm not sure whether
> splitting a 16 MB folio into eight 2 MB folios would help much.
>
> For 512 MB PMD-sized pages on arm64, one possible approach might be to
> split them into 256 × 2 MB folios rather than all the way down to 4 KB
> pages. That could provide a better balance between I/O latency and swap
> performance.
>

Fair enough. I guess this can be looked upon but is outside of the scope
of this work. For now Radix with 2MB PMD is the default on latest
PowerPC, so this will be slightly lower priority for me right now.

>> Also we still need this patch since we can at runtime choose Hash or
>> Radix MMU. So, the main problem this patch is trying to solve on PowerPC
>> Book3s64 is enabling this feature w/o impacting any other architecture.
>> W/O this patch series, we can't enable it, since it gives build errors.
>
> I see. If possible, please mention in the changelog that the maximum
> PMD size on your platform is 16 MB.

Sure. I can do that.

> In that case, the I/O latency concerns I raised may not really apply.
>
> w/ that, please free feel to add:
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks again for the reviewing this patch series.

I will re-spin the updated version (with additional details in the
commit msg as you requested) in a couple of days.

-ritesh


