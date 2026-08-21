Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98302C5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 00:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79DC06B009B; Thu, 20 Aug 2026 20:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EB26B009D; Thu, 20 Aug 2026 20:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C866B009F; Thu, 20 Aug 2026 20:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 453FE6B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:26:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 572151A032A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:26:55 +0000 (UTC)
X-FDA: 85123386390.07.52EBA59
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6ECFF20002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:26:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OpB9Z52b;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787272013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haewGvRrqLrw7gzI1I68E3Wusy8MXt3MWlVEI57RI7U=;
	b=ofREv8J+uw0hJc/nnJdYTCl6kgg+BMmWQAxoRGKqdrwwtIoz/84TSelTzS6dGs4pZrlfS0
	AC+eCgqcGVfHwtOFaCBj/5OpCyTZ/epx41gi9MxoejRcJsE+reMgHcTh8hhAgPlJOiPAc+
	n1gvFsYoj3rEsWyS/fWVA3eD0Z9pD6g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OpB9Z52b;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787272013;
	b=yEHG10ujRdzzaomI5CU40nIAKwgmblqyqybGqGu9L2uSx3QWQS/zGjFmG+qU+mm06ZjQ7Y
	yXGRzQvvqLiqjG9HZgLse1Ts6rEB/8I2KqbgOtJ0MPhYqIkUesq/tjZUJUncECiKQNpyxI
	z9BVq0+68WT4vCJ1tWuNwfb5YFYYnhA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AC33202C;
	Thu, 20 Aug 2026 17:26:48 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7778D3F66F;
	Thu, 20 Aug 2026 17:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787272012; bh=rZtzriMNQLdFVOWizIVfqbKh0as8DbXMCiKrEQ8ecIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OpB9Z52bMX+u/hTZY2vChYPYCd1qlV0jQCF3mgYzesh4wViGlYG6Xl+gbXqySp7JR
	 eqW0aDi78KPuR2W5srPpKsUWliPqtXW1gSVewlxs+004FHq/Tj48UKbjcRsM0qHqB9
	 BTaElZfW9yVhKEGypc9R+7NE8wX4L1Lr4rtjNMwg=
Date: Fri, 21 Aug 2026 01:26:47 +0100
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
Subject: Re: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps for
 check_huge_xxx() helper
Message-ID: <aoebR7VhQH8kU-xJ@e129823.arm.com>
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
 <DKU1AFIKNMNE.2A0JUVSTKHHLC@nvidia.com>
 <aodxH5Qc6_zVay-M@e129823.arm.com>
 <DKU6OCPNSECE.O9BZZWTSU1H4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DKU6OCPNSECE.O9BZZWTSU1H4@nvidia.com>
X-Stat-Signature: b1cm67jqab3ct41wkysjwinidb7znom1
X-Rspamd-Queue-Id: 6ECFF20002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787272013-586271
X-HE-Meta: U2FsdGVkX19Upk1789QFPCcaYcPXYFimpOpZ5KMH2F3nSgjEyFeuip6VAnzzHTKIaiqU4VzuN8NbBohxYS5ipmolmCgtDoY+vF5bP/Egm7++SV7iaOYc/M3OYdiLKTg8vAj9jD4Wot31kLrloA4DMbGCZfOWcnScTcQo1S8VNNPDgtFMdQbek4wlaj5cLClFmLS6ZzALUok/BMde1iI4vriD8fQc8DzPvDCFSykjiW1E6gFnnr5pz9NPVFca9MH9TZ9BfCbYnvcugUJYZxuDcbl4IV9bG7GvyL/+D+rKDj59rRQNlXGz1VuVe+d1XlXjeH60dIIt3F0dGz6qsg87yv8OF9HxCZZGz8j/O1ZuPu38re5bXcSiKJJwu4JIG/awUm8k7bETGsV0ZvvydR+G8wrnIkop01qtw7GeVCw7k7GqHSN0tKSPQ5OSY/YIBM3FNFo0GcTzrvDLkSXKflP1RzSKmYYVqWrZ9S1ucP/j4l9r+P07gW1pes9aCkDhhXMXXVNR0bKxxKHpcJxevrmP2MThUJcbyLvV5MI5HrLLH4zd8n9TRkUzbbw5YnJE4UR0neiaUlGP9dAd4u0oE17S3WHb+lBeSIElit5WwynCEA0xLFoP4SoLIV6B9IxvEQfMM/aqdLMOBrb1PklHWcojNzquBOkqNtOovBPBceCKEQbk6C8Wi3WsXlTHSgoTF3bV4YM7empX5X14Z8KdYZ+Xz8fD80Tx3VB5w1soZb3W8nKjxSByQmsw7tlsxagT6esy836RIl5PbFxK49dNCs3rTPVVtPqL+RgdMEWGEsZr7m0nMbZVXIrRuqMf3XXYfipVPGBbkLQ8tmwolWNzMJdL1xrtktqqCBmhWyZnqqRHZinDCEBKrk0v2ZRcLFVjZ4uCXmZm82cIxSB6St0ImKlpxczcpOr3nDtkoFTffCH7bu2keZxu5zl4zya84tc4GXQprMBVoIi8YK1BIAhu3Hg
 X8M0p4Qd
 EXqt+TxU5x05fZDCcGfXVwZyXpcFtboHFJaXVTVvJIfxoYFcgqgfjYea6SoCmxkdTYRiGRn1bpMpjI9QiLPXZfGhYMtAjbQoxpg4LEYu+x5excoBS2JVZmHO1c4j+wd8Fu0KF3Jt4YA/ImlsyS/ejlEN0cBaBRfiiTHM1cFRcmde/0Ti9bYvjbU2hqdajuH+R+RQn02jnSZprDBsSlEQZVdppyookqS180AxmwG+JSpAabqYcO2+/JLKELnoQoeg4+yvWMaEaVHe68cOIn/g1LjAF2LcDn/OJ1ncCEtHvjf9tCeWRIdMsXmjUHU6QJ9lm4J1LTdlb4aQYMYHKS38Hudg1g3/b2u6Yiq0w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 08:09:12PM -0400, Zi Yan wrote:
> On Thu Aug 20, 2026 at 5:26 PM EDT, Yeoreum Yun wrote:
> >> On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
> >> > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> >> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> >> > made by memalign().
> 
> I just googled the commit and find that Dev did that. ;)
> 
> >> >
> >> > The underlying VMA may start at a different address from the aligned
> >> > address returned by memalign(). Furthermore, a subsequent
> >> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> >> > already set.
> >> >
> >> > This causes split_huge_page_test to fail because the check_huge_xxx()
> >> > helpers incorrectly require the address returned by memalign() to
> >> > match the VMA start address reported in /proc/self/smaps.
> >> >
> >> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> >> > /proc/self/smaps to detect huge pages and change the meaning of
> >> > check_huge_xxx()'s nr_hpages argument:
> >> 
> >> Have you checked Baolin's patches[1] in mm-new? They resue
> >> gather_after_split_folio_orders() to reimplement check_huge_xxx(), also
> >> based on pagemap and kpageflags. Does it fix the issue?
> >> 
> >> [1] https://lore.kernel.org/all/cover.1785985999.git.baolin.wang@linux.alibaba.com/
> >>
> >
> > Unfortunately, No. since __check_pmd_huge() in check_huge_xxx() still use
> > /proc/self/smaps [1] for pmd THP, it still has problem though ths patch
> > series applied.
> >
> > [1] https://lore.kernel.org/all/56b16691f605426b33b5cf47319233de6127a6b3.1785985999.git.baolin.wang@linux.alibaba.com/
> 
> In that case, is it possible to use and extend check_large_folios() for
> all check_huge_xxx()? You still need pagemap_scan_get_categories() to
> check PAGE_IS_HUGE to identify huge mappings. Or at least
> check_huge_xxx() in your patch can share most of the code.

Agree. but TBH, I think check_large_folios() can replace checking
PAGE_IS_HUGE and keep the later part to check wehther PAGE_IS_FILE
and SWAPBACKED according to check_huge_xxx().

BTW, Should I do this after [1] is merged into mm-unstable?

> BTW, in your check_huge_shmem(), expect_huge seems to be inverted
> compared to other check_huge_xxx().

Yes. I've noticed. this was my typo while I change the variable name...

Thanks!

[1] https://lore.kernel.org/all/cover.1785985999.git.baolin.wang@linux.alibaba.com/


> 
> -- 
> Best Regards,
> Yan, Zi
> 

-- 
Sincerely,
Yeoreum Yun

