Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B38C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 14:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70616B0093; Fri, 25 Sep 2026 10:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D201F6B0095; Fri, 25 Sep 2026 10:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FAD6B0096; Fri, 25 Sep 2026 10:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1206B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:23:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FC33A6BD8
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:23:19 +0000 (UTC)
X-FDA: 85252502118.11.9C5395B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 14CE1140006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:23:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Zh3hLqsx;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790346197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRP489v0Hp+54pLfsUHLnZ6k0OwFlD02rAWsJY1XXis=;
	b=nTVLOFjq7x2DVNQbgNthhI/S1W18USt+nnjMrHVjQWC7oyd8q1P1PPEXYxGuJXHORJb1S6
	50k5VsL/r7JtDx/pCj+ILvZT9SLh8zGH1sS/yZvfh3Nswc22VzJtIA4WMYWzlPLD82X26Q
	yCGHHqDjeUdzcTv/hiZyobuKRAJtTws=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Zh3hLqsx;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790346197;
	b=wxvKsd49Drvkq/ctHbJetGnVKGKrv7wd6vEdw5UePZLXkOSyBzeHavZNfBgh4xD6yf6fhb
	PPSVd6WIjo9GOG4/UqBdA6ugryL4ucybTtiwYhtp0ZBT6LtVlqtUwWHnnOfbY9dhCWWy4U
	kuPr+0rHCm2lhSKTVG4EFyQZVzeUABI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 562FB169C;
	Fri, 25 Sep 2026 07:23:12 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81B7B3F85F;
	Fri, 25 Sep 2026 07:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790346195; bh=p5M52w+o5HEtF8yjYDd7ocLU11nT7BYOmwbTMgf/3oU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zh3hLqsxZi1yCHoYIty8FRF1DXZFW3bWWJPP+naPNiaJdyGaN6QgpCy8jYRtcIZi5
	 DbSpuKNNjKL2MEbq8/YFqvm/qJklH2xHIxWOm5Eu2JoDbR9u6A+nkSPqAlflAa3QZZ
	 qAlbHMEqQm1dDCO1yzWfh+M7sghx5++tXcnxX6U4=
Date: Fri, 25 Sep 2026 15:23:09 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
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
Subject: Re: [PATCH v8 2/4] kselftest: mm: replace usage of /proc/self/smaps
 for __check_pmd_huge()
Message-ID: <araDzcqZMmne_w4Z@e129823.arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-2-cba7359d882a@arm.com>
 <bde32459-31ce-4b15-a129-4641ef1c6337@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bde32459-31ce-4b15-a129-4641ef1c6337@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14CE1140006
X-Stat-Signature: obe8m1feftxyzfsogcjpp4h1uo86jysm
X-Rspam-User: 
X-HE-Tag: 1790346196-217965
X-HE-Meta: U2FsdGVkX19SP5HUxykJDQ3sdp8SQy51/xnngJ43XbouxU5/LuYbruxBDk6t9Hd4NTejvS2e6viPx7qocmVjMUCz3fJfonR9F3gS6nUHe3Py7oK5Vc1wZtwr51JTROw+Aq21wP4oa8Z99gM47dd/dh/QzTkYYO3v07TA/tykc4A+Buk6oVoYFeyObh5SAHQgMuhZdn5BVmRwX4Iw91jJANsA1NGnPi6BaSzmPwRLosH0Pm8ayyIf+Ij8IRtzOJqL8MZztr6zttH9SXNcF+bXAy+BYKKG9KdKLF7AjavGDKFw3pp5YKy4UfiJliJyDjs7L2jo/r7Mlv5QZ+TbsB2AP4ah31M8Lg01e0/PJbiotR3jWkJNzALlp5LJzu1HJIi3UJZbnUzqdMTX93J5iHd0AfrbA5EONHo0gSvDZQojWiEL19hy+C4eL7FU0mddzlIpX3cM/kOsGQBCk5+THw97rI9/hr/kC7zVZVfM0b8nUgFDv9O9k3RNPG0mkuxVVfWdPgr0YN9Ze5kkfOGDhS2I7jRTLDNCP3RwSpX7VxCJgpHHEQ1D9HALr5xVBxJQ8rkIJLt96CvaupDXYqLTRyMPDzUZBPVlj1cRgGbimsFqjRio0u+uFMaFKtaSg4YlVNxMmnO92wlG2ySN2p8/0pZPlr7vXRLo7wqdhsMFMYhG4QaxHgVP+4j3u4GgM3BIB0+2pQdJdAONFuYoN43eI45bF04txyD5YAJ5RHyf/EQ4HTYvR7y5/l93dBrAbIZyzo7XD7CUiWsos5YFPWPvMQSq4oLx0wePNfU6UQ2h3O+s8Y+UFNBsxRDkYQwuU7iU1q3RfYODX6S67/CRcp6oZ3jt7CiKYec90I2FUzipAQK75DPd/if7sIgR2S8hLBqG66H0tR3IxlYEI5TlKQFHlDQsAm5UYNObBLVygFt/VWexwUx7uoN8jqIsF6ebyumysGncvOhEh0nJnT7aCQlkI8V
 khReRVyF
 07+kMV/wzdi89rsou2k/elj/Uk2R9g+yZfgNjmoGsuarTb6QXYtUcppHVCBpbgdhLWsyoBpLjDo+9tTLceDTldytdUOJRfnKY75RYC49IMbZhFtjVCJdJC2+ibokDySNNK/vrFhp/k8wr3C5iOXyYPxb/VSdpddkKcDEkTMOBasHcGu2Tje2vbiSf9hV6wPMcMWwKOBsjej5mjIYGghQaDWiABoEvmd2mj7D+o2wQhWae1uSDkqcnEW1DU7o/pQgmUd2zFWLnMWZiet1VSY075Q11+1texjZdccnvqaWS4LLZ4TO/DaPxq9uPmbA8m4vDi7g3TpXZ6JT/+lfJx1xLiMHmRblbFp3XmJCAiE635vGi0XT15VJUtbqTGsiTRzaViljw4egcxXMp1bk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 06:08:44PM +0530, Sarthak Sharma wrote:
> 
> 
> On 9/25/26 12:41 AM, Yeoreum Yun wrote:
> > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > made by memalign().
> > 
> > The underlying VMA may start at a different address from the aligned
> > address returned by memalign(). Furthermore, a subsequent
> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > already set.
> > 
> > This causes split_huge_page_test to fail because the check_pmd_huge()
> > helpers incorrectly require the address returned by memalign() to
> > match the VMA start address reported in /proc/self/smaps.
> > 
> > Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> > /proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE
> > and PAGE_IS_FILE accroding to type of huge page.
> 
> s/accroding/according

Okay.

> 
> > 
> > Since shmem pages are also file-backed, simply check whether the page
> > is file-backed.
> > 
> > Fixes: 642bc52aed9 ("selftests: vm: bring common functions to a new file")
> 
> Checkpatch gives a warning saying it requires atleast 12 characters of
> commit SHA.

Oops. I'll update.

> 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> 
> [...]
> 
> > +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> > +		  uint64_t hpage_size, enum check_huge_type type)
> > +{
> > +	int pagemap_fd;
> > +	int nr_pmd_mappings = 0;
> > +	uint64_t categories;
> > +	char *start = addr;
> > +	char *end = start + len;
> > +
> > +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> > +	if (pagemap_fd < 0)
> > +		ksft_exit_fail_msg("open pagemap fail\n");
> 
> Can we use ksft_exit_fail_perror("open pagemap") here? Will help in
> diagnosing failures as well.

I see thanks!


> 
> Apart from these nits, rest looks good.
> 
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

-- 
Sincerely,
Yeoreum Yun

