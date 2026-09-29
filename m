Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71A3CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996426B0088; Tue, 29 Sep 2026 06:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947B66B008A; Tue, 29 Sep 2026 06:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D5D6B008C; Tue, 29 Sep 2026 06:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 657186B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:01:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A9E3C043A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:01:47 +0000 (UTC)
X-FDA: 85266358254.06.F4E4925
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5226B20010
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:01:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JjsM4U0d;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790676105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxVG9RZSOCy22oyakJbbNe+tJkEu36iCtj00c/iAIZk=;
	b=EZYQYhAORwbqWuLZTqBReqlFy723B05sA1H2sqd4ERaekSjDoISK1dYT80Thgt5gakeoi7
	VEMm3tDoDq9gWBOJy0H1FZf7By8fct7eX3ZirFZjdrX1/BcrtqFPjyCaRXPLi+cMERp8bw
	vxU+eBJTAHQysgdVJbyBnmHj7aHUOgI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790676105;
	b=VkDLeF12if14KiuKl+TdwL0zs2tNzLUDiIcX+j5ZtRp5ELepHaLK9I3joDLsQ6JhzVF2+l
	gj4HGRTdgMsV8PY59YJdn+8rNBzFWDSxRXKyHgbjKT22cu2u3LhrLFE00wnITG1LNKWaxJ
	fqby1tt/8sET27HIxPttx7S7Jw8Yz9w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JjsM4U0d;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 134DD1516;
	Tue, 29 Sep 2026 03:01:41 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57C053F85F;
	Tue, 29 Sep 2026 03:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790676104; bh=sOf1yxpICIHQ0diMdP7xrm0ukUMRWepHeq2vSRPG4qQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=JjsM4U0dCWQiwBxbACDJ3APXp7SAAY6WZjEcCJGR+fkF0lJD+DKExuMsMdh+XnBDu
	 i0z/7aw1bFIIV5rVltVcodA/qy/Z73WE/sqRztwIokaAaVcrTjcm6DLx8c/CDtsnYi
	 fzYfg2Y59P6spKNrcItxhEh8ew13b7ZcHr9keCoA=
Date: Tue, 29 Sep 2026 11:01:38 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
Subject: Re: [PATCH v8 3/4] kselftest: mm: integrate huge page checks
Message-ID: <aruMgm8UZ_t2V_wh@e129823.arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-3-cba7359d882a@arm.com>
 <16f16e77-05ab-418e-ad06-8f48fb29375a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16f16e77-05ab-418e-ad06-8f48fb29375a@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ohki63yoma4rnzgiicsggot91f7gno17
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5226B20010
X-HE-Tag: 1790676105-421587
X-HE-Meta: U2FsdGVkX1+QQhNpGZi3ZMu4/iRAAA8EOJzUgqtF0p7b8u9PAWhHa6aJ1QmFroaGuFfgF5vVRCXcb9z5dB7pAvRykzmdxOuUKlM5kcpeMrfJsNJ0dMurtKOMpf5xuce41kvZQjjaJ8pAsAPqfV+Bx0gREBITOV50sk4Z/T8FixCDqLFXSzwyMOrbpp9ZC39kNwndBEUlfvo0QSCMqpZL+ETyv1LjFDhYKO9pJrrjObgHlg9qCUKU3/6K4QQQwReTtLbgqwQuA7mqZgmcdY25b5yJCcFCUygPyB14eydm+2wnppxjDwh6ySXFpyaazbqnxaZhL8p10YwEx0QvMKckDbOVgvq0qswG0j3keQKaAbJr+mzucl7eYIsaKWU381YUXJjV9fGkFf1OpGhoBb1kgedmQmX/4CSRhuw4J70B8HsF7knsNhnB5E2b1pHfk0uFFca6Q0yd4CvtFNSLpJmb5S5z0dkYCwlA1Z+w8tUgNBsuD8bYj6Rlvz8qUWBQ8kVszpaWyKrvgn8xOH4Yu57l3P737/CdfPVPVAy4+Mi+AUJYzAgBQEGMt0K6qpKKBxrKcVp+lsM6tSo3AIzUaYGJT69Xm+EzRveEOQCSkjrhqSbtU+W9iMGwlO2lIe0fCYKJvqpyC+Kk9yPgLPIX+tiYg+PQHFZoQveHORQG+Nf16dYReSxGRlzgAzKnwJdpOd1HiE+j40yxmVJLNZ2SNq6aZLntGn/HNhNW97kFypPu+/Vna98lJ0uTLuFODfmI/6wh0FweUeJg4aK1XqRBKcQcqgWcbIqrKc9CEVQR2JSO4Pw7QjtkUHKuiu7aiRDh6ZFmmRD8JSU248li/dTlWJlkAgqHbci7tfGvfKkqOubYVbG7IYdDD/R4a4mIXDXmu6H94DU+RyS4XSV1yikZilk4TK2MUu3YX242sZlUV5G6l1sCTgjLm4ucNDM2k5y47l6oyJs4lRQEyOIBP0n8p6w
 bpEoSjHj
 f1GQjqB/0iqdwLll2Z6h0SF+19ncKuhSwKzR1Bo3YNH+kbNeu29V2fB1Ql7qkD0Xp3mJMO8AOGOWE2Ntem1ao/pDwzHlYhgqCR9UJ4uCl0+HWoOwSvUPBYQraGswIPtgh8TMltW7SJBD1hDQZ1lFtOwRnQUgyZ5Ua1s9BIf4GLeBirm11EMMBA32GAhGFEYfuGE3KBzMjzpA4x2HLnveRdb5idpJd87POkmfM3BRnpfyZYyAUB/7Yqq6s+6cIPNKmcdrfx/1UviIQ3yMdFvLtcOPvVNFpfKH/M46r5L/l2qEHtrKRqZ+eB2THqTNarIHfSqDWNycgljAGYW23RUkopPGopg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:07:37AM +0200, David Hildenbrand (Arm) wrote:
> On 9/24/26 21:11, Yeoreum Yun wrote:
> > check_large_folios() only checks for large folios without distinguishing
> > between anonymous and file-backed huge pages.
> > 
> > To add huge page type checking, integrate the huge page checks into
> > __check_huge():
> > 
> >   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
> >      check_large_folios(), since only the mapping type matters. This
> >      identifies PMD-mapped huge pages.
> > 
> >   2. Otherwise, use check_large_folios() to detect large folios. This
> >      covers mTHP cases.
> > 
> >   3. Check the folio flags according to the huge page type.
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Suggested-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> 
> Instead of merging both things (detecting mapping vs. detecting anon vs. file),
> could we simply perform the anon vs. file change separately?
> 
> Doing another pagemap walk that focuses on that should end up with something
> that is easier to read.

Okay. I'll change like below in next-spin:

-------&<-------

@@ -411,57 +400,78 @@ static bool check_huge_type(uint64_t categories, enum check_huge_type type)
        return false;
 }

-static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
-                 uint64_t hpage_size, enum check_huge_type type)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+               uint64_t hpage_size, enum check_huge_type type)
 {
 {
-       int pagemap_fd;
+       bool ret = false;
+       int pagemap_fd, kpageflags_fd;
        int nr_pmd_mappings = 0;
+       uint64_t pmd_pagesize, scan_mapping_size;
        uint64_t categories;
+       unsigned long pfn;
+       bool check_pmd_mapping, allow_nonpresent;
        char *start = addr;
        char *end = start + len;

+       pmd_pagesize = read_pmd_pagesize();
+       if (!pmd_pagesize)
+               ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+       check_pmd_mapping = hpage_size == pmd_pagesize;
+       scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
+       /* Some mTHP tests check a partially populated PMD-sized range. */
+       allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
+
        pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
        if (pagemap_fd < 0)
                ksft_exit_fail_perror("open pagemap");

-       for (; start < end; start += hpage_size) {
+       kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+       if (kpageflags_fd < 0)
+               ksft_exit_fail_perror("open kpageflags");
+
+       for (; start < end; start += scan_mapping_size) {
                categories = pagemap_scan_get_categories(pagemap_fd, start);
-               if (!(categories & PAGE_IS_HUGE))
+               pfn = pagemap_get_pfn(pagemap_fd, start);
+               if (pfn == -1UL) {
+                       if (!allow_nonpresent)
+                               goto out;
                        continue;
-               if (check_huge_type(categories, type))
+               }
+               if (!check_huge_type(categories, type))
+                       goto out;
+       }
+
+       if (!check_pmd_mapping) {
+               ret = check_large_folios(pagemap_fd, kpageflags_fd,
+                               addr, len, nr_hpages, hpage_size);
+               goto out;
+       }
+
+       for (start = addr; start < end; start += scan_mapping_size) {
+               categories = pagemap_scan_get_categories(pagemap_fd, start);
+               if (categories & PAGE_IS_HUGE)
                        nr_pmd_mappings++;
        }
-       close(pagemap_fd);

-       return nr_hpages == nr_pmd_mappings;
+       if (nr_pmd_mappings != nr_hpages)
+               goto out;
+       ret = true;
+
+out:
+       close(pagemap_fd);
+       close(kpageflags_fd);
+       return ret;
 }

-- 
Sincerely,
Yeoreum Yun

