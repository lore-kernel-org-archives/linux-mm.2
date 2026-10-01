Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24147CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 21:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D619F6B009B; Thu,  1 Oct 2026 17:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D387E6B009D; Thu,  1 Oct 2026 17:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B836B009E; Thu,  1 Oct 2026 17:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94AA86B009B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:19:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFB4CA6F83
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:09:46 +0000 (UTC)
X-FDA: 85275299172.13.29B9B84
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C69991C0006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:09:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dXSalrrG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790888985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOnyNSnoHtU+joSumAeXoaA5/hNBWXuK5gg89nL6Wd8=;
	b=UerSqhOsr4Ha74D4R/O3fkmhrdbqMErRr7iMcypvwjrUVLL6bLepUOiZyLNaY+1bVlkk+b
	ZLPHLBzkxX4yrmU0APsrCha31hNXh9pHrghnEHNsD4eZdz4SEkXe4HZdwnbuUdQgVABM+F
	O+7dGMUaiJVUFKcjEeuimX4eF+SgWHQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dXSalrrG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790888985;
	b=mUss7IVMC2taIoSsiwY7zT/HmznU6DYMoIl4fpe9nhus2kFSOmBJOfft+wtN5wPPsXezAd
	AxVmIXQozvy3tw8oWH8sGmjpjGZybBT9cxmf+UCC46rF/qDIiWepFv/nh0uNdUmY9rwypa
	K0pgHME9oQRYIJSF2+3p3Cvc5Iy2KKU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B42C497;
	Thu,  1 Oct 2026 14:09:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 802F93F86F;
	Thu,  1 Oct 2026 14:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790888983; bh=6UxZiSMXOZ2G2+H1G1Efxdl+y1iSPxd/HGooq6Ez18w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dXSalrrGGT+/wYVtpiKsAv3e9vNf4B7zYrCJ2/ujeL3rpHLfJSmO3OeLVAtjoaVaY
	 J8ZXO6HNNqGRjwaPtFSAK3/hsL5FVHTBDaJVZGCFcqYJkKFVklzyNV69sfi+X395NY
	 Y7sNaIO28zT6AxELiD9yryQnajhutiuDUk8ySJUk=
Date: Thu, 1 Oct 2026 22:09:38 +0100
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
Subject: Re: [PATCH v8 3/4] kselftest: mm: integrate huge page checks
Message-ID: <ar7MEl_EBWSNOO5F@e129823.arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-3-cba7359d882a@arm.com>
 <16f16e77-05ab-418e-ad06-8f48fb29375a@kernel.org>
 <aruMgm8UZ_t2V_wh@e129823.arm.com>
 <3e03425b-7962-4c69-93aa-96168fd7168e@kernel.org>
 <ar5lhhdKlK6NwX19@e129823.arm.com>
 <a3a4ae76-c09d-4e9a-a84c-acea6f5fc437@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3a4ae76-c09d-4e9a-a84c-acea6f5fc437@kernel.org>
X-Rspam-User: 
X-Stat-Signature: xbnk5zar53erwtmtjgoyusojpiboqhyw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C69991C0006
X-HE-Tag: 1790888984-640756
X-HE-Meta: U2FsdGVkX1/XgMRnKXHmxBIyllNQFwj47C0FOQ1bhJssqII0+jCpmynYD08WvXBfT+gVGSUdc32zyODOlYlFCoH3zHzgJdgb50D6wQ3lEx2nbrE8fcbkLDFuz7BgFRynCmoywY1/SPC3GSJcjn288GanPrkgO9F8t+ZI8qc48Ox3VeKDNARLrjaxdOU5EJ1ODqtNDLf/XaGFX9/Ds+lPSV8Z/+mkDbp4ZbgdHcj86xRWZ8rWsvGMKfQdpvFLr6rbJ89jxnlXyPJcTBiaNq1M51PWjAWZ+yODr9IrI7sn8Qy7IBcK+HmgGrZSLJ22BgBXJJOl8Zsb1Osn7/J9OZyjJDdn/ZJ0/gEzG3Eqzx08+QWhuia98iTc5ZJQ1/w5rRa4kpt6bWOUAjU4GuteFbqguAOrm3l0uzp8fCHrznAh6b1RhPC5CkvNkLL1Y4ek8fTfZTNGBGYHBcnXdgKRardNgbkU8bEDjAH0Bpni4PmHKES0LCtb43WokF3yt40TsWm91dsHwvxDZktdZ8mMeagdhX8RhPFZtVoH8JYT6oxoVpi3uOnrpAhw3t/sr3j9TdkeAYU5jkxLrLbnp/MF6zuvKNlDDSzP1SN1Wg9XPncU9cXzQUfmx9/AGRJ+dr3uSQe2ltfzhY3zQyRka7w4G6IKHgePbXJa2qKM0xpar+NyENQh2BrInlTqxPc63Es/oU2ixLrFLhHHrMxbqtUUmt7LvmaSP5CRJXPXVjcd4ISiJVFcteSWaN1C/pZLWTvtxE1enl8Ov6LGq7oHk8ZxprgGg6EbXpMPNXu4WwYvcNrnCK++gjf+3b4zLf9L/I+TEYESbbS/ifSv1FOC+/JYmrdT6kZK4TMbwMX4XAun1oaB0iZZkdOJlPfxHe9w5tZJoFc/MkWw5hztuzSmXbcly4CY7Ooj+5wMWRk4OVizlZwlZkEZ/N+U2syOVz+19prZS+aHMX2gPhaY64ktk/bzRvj
 2w8tOQJT
 g3iJOM+wPg+67yBnfW9pACegIQRPVUOZbHDOlV4vcuTZyIIIy1Z0ML/PCxkULT3YYhYon9eHqGY9kXRTQkmVcEOtUKTaF+j0rpHpe9N/0DpAhEBujY+w/E2NQbqTfz39eWaWMt/VVd+ZgRU+wuWCoy58twfSRbaShVcxqjThV+bTwpa62pF/HcaJtTrILsjR3oJJNHjxvTJRNMQsnn1jesh1pulSa+heWsgaed6q7ZNtu0SA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 10/1/26 15:52, Yeoreum Yun wrote:
> >> On 9/29/26 12:01, Yeoreum Yun wrote:
> >>>
> >>> Okay. I'll change like below in next-spin:
> >>>
> >>> -------&<-------
> >>>
> >>> @@ -411,57 +400,78 @@ static bool check_huge_type(uint64_t categories, enum check_huge_type type)
> >>>         return false;
> >>>  }
> >>>
> >>> -static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> >>> -                 uint64_t hpage_size, enum check_huge_type type)
> >>> +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> >>> +               uint64_t hpage_size, enum check_huge_type type)
> >>>  {
> >>>  {
> >>> -       int pagemap_fd;
> >>> +       bool ret = false;
> >>> +       int pagemap_fd, kpageflags_fd;
> >>>         int nr_pmd_mappings = 0;
> >>> +       uint64_t pmd_pagesize, scan_mapping_size;
> >>>         uint64_t categories;
> >>> +       unsigned long pfn;
> >>> +       bool check_pmd_mapping, allow_nonpresent;
> >>>         char *start = addr;
> >>>         char *end = start + len;
> >>>
> >>> +       pmd_pagesize = read_pmd_pagesize();
> >>> +       if (!pmd_pagesize)
> >>> +               ksft_exit_fail_msg("reading PMD pagesize failed\n");
> >>> +
> >>> +       check_pmd_mapping = hpage_size == pmd_pagesize;
> >>> +       scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
> >>> +       /* Some mTHP tests check a partially populated PMD-sized range. */
> >>> +       allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
> >>> +
> >>>         pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> >>>         if (pagemap_fd < 0)
> >>>                 ksft_exit_fail_perror("open pagemap");
> >>>
> >>> -       for (; start < end; start += hpage_size) {
> >>> +       kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> >>> +       if (kpageflags_fd < 0)
> >>> +               ksft_exit_fail_perror("open kpageflags");
> >>> +
> >>> +       for (; start < end; start += scan_mapping_size) {
> >>>                 categories = pagemap_scan_get_categories(pagemap_fd, start);
> >>> -               if (!(categories & PAGE_IS_HUGE))
> >>> +               pfn = pagemap_get_pfn(pagemap_fd, start);
> >>> +               if (pfn == -1UL) {
> >>> +                       if (!allow_nonpresent)
> >>> +                               goto out;
> >>>                         continue;
> >>> -               if (check_huge_type(categories, type))
> >>> +               }
> >>> +               if (!check_huge_type(categories, type))
> >>> +                       goto out;
> >>> +       }
> >>> +
> >>> +       if (!check_pmd_mapping) {
> >>> +               ret = check_large_folios(pagemap_fd, kpageflags_fd,
> >>> +                               addr, len, nr_hpages, hpage_size);
> >>> +               goto out;
> >>> +       }
> >>> +
> >>> +       for (start = addr; start < end; start += scan_mapping_size) {
> >>> +               categories = pagemap_scan_get_categories(pagemap_fd, start);
> >>> +               if (categories & PAGE_IS_HUGE)
> >>>                         nr_pmd_mappings++;
> >>>         }
> >>> -       close(pagemap_fd);
> >>>
> >>> -       return nr_hpages == nr_pmd_mappings;
> >>> +       if (nr_pmd_mappings != nr_hpages)
> >>> +               goto out;
> >>> +       ret = true;
> >>> +
> >>> +out:
> >>> +       close(pagemap_fd);
> >>> +       close(kpageflags_fd);
> >>> +       return ret;
> >>>  }
> >>>
> >>
> >> I'd leave existing __check_huge() mostly alone, and instead have an additional
> >> function that checks the type.
> >>
> >> Essentially a __check_type() or sth that we run after the large folio / pmd check.
> > 
> > So, You mean like this?
> > 
> > -------&<-------
> > 
> > -enum check_huge_type {
> > -       CHECK_HUGE_ANON,
> > -       CHECK_HUGE_FILE,
> > +enum check_type {
> > +       CHECK_TYPE_ANON,
> > +       CHECK_TYPE_FILE,
> >  };
> > 
> > -static bool check_huge_type(uint64_t categories, enum check_huge_type type)
> > +static bool __check_type(void *addr, size_t len, uint64_t page_size,
> > +               bool allow_nonpresent, enum check_type type)
> 
> 
> As discussed off-list, maybe we can avoid the allow_nonpresent handling!

Okay. I'll change. Thanks!


-- 
Sincerely,
Yeoreum Yun

