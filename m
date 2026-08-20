Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B781C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 23:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC016B0095; Thu, 20 Aug 2026 19:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CBE6B009B; Thu, 20 Aug 2026 19:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47AB66B009D; Thu, 20 Aug 2026 19:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CBD86B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:55:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8026C802F8
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:55:15 +0000 (UTC)
X-FDA: 85123306590.09.F26518A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9040F40004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:55:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qirpwY7J;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787270114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QANigxopAGj5Sgp0zL8D1Jq40dFgt5D1sRXVayRsoAw=;
	b=hCJcyIQVyGw/iDYF+J8i+LQqHWJ+kceRF7W1cXetqHzsHeHfdwLdwxkbBvR0QzSJNyZ6wu
	liH4GPvhZGXWzPsiCDhgus20+FihUoJjPbGHJyWJjbKBtqrcF6fxO3ZT4VM60QfxtsLBs7
	LE9W9E6QGoVWjjpDjAtwDNXKHR53SwE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qirpwY7J;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787270114;
	b=KoRvRbeJT+CY8gTkcRhuhiCk4t6UXTNeggh3LW3vvf7wRXbknS2jKwMztSFijh20YcEtSP
	zrP+m/kSa7DvEkcSLlzPQuJJ7942yKtWPYi3r4n6RD83wV/m9e3NjgOqXHdlneDejS7uGj
	hI3//Ca+BUC3/iHwwnjhEQgVMSBZkQs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE2B2202C;
	Thu, 20 Aug 2026 16:55:08 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DBA593F763;
	Thu, 20 Aug 2026 16:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787270112; bh=4+BZj3wyhMud3H0fEhJlwSpOhdep4WFqybBIHjkAz4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qirpwY7JuwpTBV73B0QJEAtK5Uvt7oAYQFk3fDBx67xN6AknH55ygv3UEGwdt2AwA
	 FpvSUe8EU3y4YAE3Sg+lB68UqsAAj6I7bZJRjBW2vDbso8yKBFfa1Bq6urfEW3rplb
	 053HKkoKGOziRcTdQRgcNZqiwGHoakjZCt8GVMSE=
Date: Fri, 21 Aug 2026 00:55:07 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: Re: [PATCH 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
Message-ID: <aoeT20fPw57DtpGe@e129823.arm.com>
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-1-ab430c58c7cf@arm.com>
 <DKU173CETFYO.1RJA1CSOC5S99@nvidia.com>
 <aodwNr_zgOn55z3W@e129823.arm.com>
 <DKU60290OED0.12P9UF0Z97DND@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKU60290OED0.12P9UF0Z97DND@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: pocjiuury81tgdsqxwdxpctgdeadtibh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9040F40004
X-HE-Tag: 1787270113-812918
X-HE-Meta: U2FsdGVkX1+fYRxIb8UWs/KDT56DN+XdkielyFQgveZoZj4CacmYOxIPuFVgdd51S5hFHf/niMnnzbmpHepIqZYP3+m4SkVUQkr0xuNmUz93nmNZj8D8vW+ShPoxqgjZg1hWii2Jyi0biMF812xQj91bJbtYhJOMfgsj0CmPoDMW8uU/fHT7gwTEZmTZNmMFbHNfKIfVU1cA3qZ2rnFb6sV/yW8Q/8XwznawujY3lTFYO0g/GXUL0LpyRiLflWVJT2ck1jI504u7uS5gtbukaGn2xGyXfRAAa3Ssywq0IDP2sOrrw444V/Inu/M10Fq1OWqOBu5dUJBA/9OcnKmH/TuYB7zNMkDUBRtgltO4Erj2PyWwRSrV3L/bOG4shAeRybnCQ6A83RuLb31brZD2Wg8tN9m/4nYJEYUQHTTJLL5lailFoputzbLHEA+0KPzYzndEIdxOgt5Kj2CAFfHBU/cvZLvVJ8K+9cqphq0kmeF45X0wPZQb3i+GXY8lJN5OX/0wymNo94zvb28V1x7EORBfzNF17c5SEkSoh6+0Ruys/aQz7TBRs5/HfDIHJgtLPJmsQPWkPeU2FAlXM8ubIGoCNswP9sxsVSxL7OFU3WPjgr6MDOQt/uX20JCeCgBTVxfy4+LoZ7KvoU+p70ELr6zLD87ktoaxOQ623L4noglRNKgNe/AQw15sJcUIXMygMtOhm7vIbgkJ0TPqzy/VUM2ZHofU7HWkoBfklLAbckOYg9o5FSgfMQ7dLPGrEo5BgAdBB+eE1nGfHBZOLls3RHBKVKea4QU/hn1rsGl2lwVYRz7EXit01db/bLhirIomqmVc3GY50JwSuLnEw7WCE4rA8BHU6902OOAMEAHBJMNVZnvz09+YTwXyE1twIJxUJWAF8QdSQxwJVrNRtdp0+tGRfDpnYW6jUgbMcoo0tp7g+xd0LGNbc02hOhGLAebrKG0ANus4/o+GbriotOz
 4xkM82bf
 Yn2pRqDSg1GnfSqH4Nso1znuP7mvPuC6wTKF3GxNgKtAL9UOj6wXx5u6xafPm/h/LpapS+AixZYx8iMb9eLXHAeNUkaEE2m5v4Yuj09JmudeQzAjQqU/OmvJQbdKjp6UDGuAsHM5HLxAv9jCRVC2x6ULBdFhGGJbt1zv7FWZejoOTZgDpzMrU5tXttqM2OVrz0P75TOW/xNNo2R0zBfYHk7CsFOkrIDodhdgfibpVtWVEkJuncLGVCBpoe+s7xtFgSy00
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 07:37:29PM -0400, Zi Yan wrote:
> On Thu Aug 20, 2026 at 5:23 PM EDT, Yeoreum Yun wrote:
> > On Thu, Aug 20, 2026 at 03:51:34PM -0400, Zi Yan wrote:
> >> On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
> >> > There're some random failure for split_huge_page_test when khugepaged
> >> > collapses pages into pmd again which had split by the test.
> >> >
> >> > Prevent the khugepaged's collapses for split page by setting the
> >> > mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
> >> 
> >> Why not disable khugepaged using APIs from hugepage_setting.h?
> >
> > Well, this also works with hugepage_save_settings() and write the
> > khugepaged/scan_sleep_millisecs with the maximum integer.
> >
> > I don't have a strong opinion but since it seems more hackish way to
> > change scan_sllep_millisecs, I use madvise() with MADV_NOHUGEPATE.
> >
> > Would it be better to change using APIs in hugepage_setting,h?
> 
> No. I did not realize there is no way of stopping khugepaged completely.
> 
> BTW, I am curious about your khugepaged config causing this issue.
> IIRC, khugepaged scan interval is about minutes and
> the time between madvise(MADV_HUGEPAGE) and the second
> is_backed_by_folio() should not be that long.

Yes. it's relly timing sensitive and I've failed to reproduce in the
real hardware. but in the emulation environment it often failed with 
the scan_sllep_millisecs as 10 seconds while the test running.

> 
> For your patch, maybe you want to check the return value of madvise() to
> make sure it succeeds.

Yeap. but it seems enough just worning message for the madvise() with
MADV_NOHUGEPAGE.

> 
> Otherwise,
> 
> feel free to add
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

-- 
Sincerely,
Yeoreum Yun

