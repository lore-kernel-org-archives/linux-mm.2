Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DACC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601D76B008C; Thu, 10 Sep 2026 06:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7E26B0092; Thu, 10 Sep 2026 06:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514FC6B0093; Thu, 10 Sep 2026 06:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 353986B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:32:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33F9BA4A70
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:32:05 +0000 (UTC)
X-FDA: 85197487410.29.FA29EBB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25685100004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:32:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CDPjjO6E;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789036323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RH5LHJSgJ/oTO2GxixDbSmZkp/QOIp5w1ITjGkLHdcY=;
	b=vIEZHc1UgfIlNwu6NIffzvC//X9eeCbNWcFD0i9BPHiXlTthOh0Jv/s5YMfKODfrQUd/2V
	4FPBEnX+HQP5zZ803GT2qrQzKu4eioZIipPk84jESl6ZMRrWOwkbMu/jIjWh1b9dnoZFMA
	/z0eaXJ6ACA19HhqkkVQnDHSzjRYCms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789036323;
	b=tANjyhrRkhRWsE+BAVXaa4yF1R9NoG681bku8FmESJ1KxSsAeFdZtHekyKozHmRDucjJfg
	C9ETuVP/9Z62PvJ69LkYu31+x75zU8i+vkTO6YNUoe754urJSgqzABLhLuZEAQYL1C2Tbf
	tnMB9Ca6DDxHuMyVh9dJy2b/DawgcUQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CDPjjO6E;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C23D143D;
	Thu, 10 Sep 2026 03:31:58 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BA793F7B4;
	Thu, 10 Sep 2026 03:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789036321; bh=IJITZrrt2zEXZ32wbq+QH7wuDa0njOtO4c73SNtm858=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CDPjjO6Em49wTSXUqIvdn3jp5muCpT3ua9fqMM8tKJpqwyGetLZMKlfpHQ+qVh6Hi
	 8LGMz2ByUY3yc6yei07ZAu5ptJ9ER8pFXzwPLZJneyOxpyTZy6E7inUvtOJCpk23n+
	 XxaPElyRDTa4HYEa12Ksa+fMK9uZpuc8/ErKPjy0=
Date: Thu, 10 Sep 2026 11:31:57 +0100
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
Subject: Re: [PATCH v5 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
Message-ID: <aqKHHWKvOonYZPy0@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <b923f63c-db7c-4ecb-949d-368bc6311626@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b923f63c-db7c-4ecb-949d-368bc6311626@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tjarhsfmjnhwg7et7wwnfgnqpoag351a
X-Rspamd-Queue-Id: 25685100004
X-HE-Tag: 1789036322-570328
X-HE-Meta: U2FsdGVkX19XUkYl7H7a/uePDHjhbZp10aXFRUsZUjao5ya0Y0q34sAhkqtlE3y9DZipDGQboqYPf4TiG1oYrKB6IEg/RinidnpqowO1oNIw6FlXA3XYCd7t6WPFtUcP6G8zNTOycslSSNSJbFSXJ5kCBU1asUsRkqZfQ4msU3cGgj0Q8u5k/rA+jFcMnf9p1G5e5ghpZrUpUle7Jq73V6afAC35XOFqBhykZ2yMZtRoT09Ee32WbvAZq9mWIyb58HStBmlgEfu2Hc3eGlgppeCQmoef4lWQrfmNTOAcUWNXE3uEnwSUmt5ggsQ4AoxeXMxB5OiM0sNPVqcOqGz+XUwm0AcHbTYylRC+jLyjQ+vA+G7MkDrPPb1CNJjLXoYearsa4gwNqR+L9EctJ6tfyamKUZ+5wlCTR/a984/7f7JXdLbZ01YveRjgjm+7bAsgbZwNiJ7dEQvOUUBfZzV2suGxmF6RWk3IJrs3kTF7x1RmU8/g3ncOghSnWjurp0Cpvj0CpJFujE1VxehE/25TFUuD/J2EKRvVRSShXu41/11HsA2YBDhuuMguZPvVmVRLPVCAfIUNcRMFUVctqX4YefbT/hwjYP+ubLZ/WE+jn6pI1minj9Ah39TcjSc56aRw05mXUEmvajwJb0U21ks13F62Mapg4K6giKzeFYSD+1//zH22UPWoY6Oeudl+EfPXDD9Q/AXUGsOR37iXbTtzDWGwmVhBtO7d9D2pTAg6+NqN63a88QozBXNYIP0BeN3Uqh+2bndxCO6AyqKhE/pivrrx7mLX+V+y/5ZqMPH0dpEkcRnyHSbhRf0XirlVaIGVU4KVHM99P2Qt8Kj2fVIt73zBwpDM3bRkEk5SLvQ2I4Dnh9Jkw79Gp+42fQE2oKX9I6QTFUjKvmtYyqYtaLzursehPcMHDbhMb+rCu6jBkV2xOtgVfs26Je3+JcZ5uiiXCg8QTqy4GHc2IjxREBt
 +Z8/C9It
 vlubjBiIyt1l7nrDQRwVlofcjOAPbz3hPB2q0f94whvj3la0XZ7fFk+YSSlj7z2Gd3njynXzYe3PV10pF5aKtOG6CP3Tkl7Q5+Lj7E+o0/tNZjjTzFmz6cEZqTJlZWKTnbL/r+6s1TNnIJLFz29VlB0JVKLKRCDrrLz/7eBuKbO+oE4smjGMgfS4ozyIN0GpAs2NhgpzMo9D7fj+eFbNZWrfEgSs8cKCqhgmj6iIi4Ilzp0/l8+krId6O9uMToY/UmwR3k/GLwjUyrh88J1wDH2NuKum9cJiH72Pl/CoJD7vFyiY8iJHtG/ZP7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 9/7/26 10:19, Yeoreum Yun wrote:
> > split_huge_page_test can fail for the following reasons:
> > 
> >   1. During the test, khugepaged may collapse previously split pages again,
> >      causing intermittent failures.
> > 
> >   2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> >      glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> >      made by memalign(). The underlying VMA may start at a different address
> >      from the aligned address returned by memalign(). Moreover, a subsequent
> >      madvise(MADV_HUGEPAGE) call does not split the VMA because it already
> >      has the same advice.
> > 
> >      This causes the test to fail because the check_huge_xxx() helpers
> >      incorrectly require the address returned by memalign() to match the
> >      VMA start address reported in /proc/self/smaps.
> > 
> > Address these issues by applying MADV_NOHUGEPAGE after faulting in the
> > huge page, preventing khugepaged from collapsing it again, and instead of
> > relying on /proc/self/smaps, use /proc/self/pagemap and
> > /proc/kpageflags to detect huge-page mappings and large folios:
> > 
> >   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
> >      using check_large_folios(), since only the mapping type matters.
> >      This identifies PMD-mapped huge pages.
> >   2. Otherwise, use check_large_folios() to detect large folios. This
> >      covers mTHP cases.
> >   3. Check the folio flags according to the type of huge page.
> > 
> > Also, current usage of memalign() would result memory area may
> > unexpectedly merge with an adjacent VMA, causing tests
> > that inspect it through /proc/self/smaps to fail.
> I'm not particularly happy about this.
> 
> Relying on VMA merging details rather hints that we shouldn't be using smaps to
> query some stats/properties.
> 
> Which exact things are test querying through /proc/self/smaps? Could we convert
> the code to just query that stuff through different interfaces?

Well, users currently for using /proc/self/smaps are for check vm-flags:
  - guard-regions where using check_vmflags_guard()
  - pfnmap test where uses check_vmflag_pfnmap()

AFAIK, there is no interface to get vm-flags except /proc/self/smaps,
we should add new interface but I'm not sure whether it's useful except
for test purpose.

Since for a testing, the most chance for VMA merge is when using anon
private mapping and this would be enough with allocate_isolated_mem().

-- 
Sincerely,
Yeoreum Yun

