Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9818CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A1D6B008A; Thu,  1 Oct 2026 09:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBA16B008C; Thu,  1 Oct 2026 09:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA716B0092; Thu,  1 Oct 2026 09:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 921D26B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:52:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CFD71A03D1
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:52:14 +0000 (UTC)
X-FDA: 85274196588.22.CA54A4D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3F7EF1C0003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:52:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=avLvr1eT;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790862732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vi4iHS/XzApfrPJ1Qi6sByTaQytDHSrkS++QDrCidnI=;
	b=EsEaxmNl0S78TkX3L7TFxKkY1wtAhNM7JZxlU0MApcl9Wtd/YCn7S1vPOH6NOm1ruAjFka
	kke/x0/+//JMZuRf8cgTKCUuhMSo8Rb47XzbTgYgoMrelKpwDDESZk3FBsResN6WmxNipc
	4tdqppwLnHGRTUe8ZUaDvwtb5/N9iCU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=avLvr1eT;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790862732;
	b=jtaECGkLjq951Q/pSCsEsjkeMsEzluKw5szRrfUsATk/LHZaJqYfX0gTghfYMKIcvNGc4v
	Sy+o4ySmsS2AVNDMAE9ky8sK4QyAPBeirDld9KfwkkWJsBnVA+F/n7JlnIFJm6EESShXiC
	LxaeQtPgDUJfGkSVQxTW0X9ba3evmDQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97F87497;
	Thu,  1 Oct 2026 06:52:07 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 572643F86F;
	Thu,  1 Oct 2026 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790862731; bh=BFYsSQEEDW9ivKme2GW+ybv9NgRrwNxqnlj2UvnfFOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=avLvr1eTGOHRMC4ainKq32M1Rv9qJhzcdp8ui1a6bT05iOwUQqOjMwV6ahWU8ss3M
	 jdv6uqw6vGM52rUj4rOlVEcanprQmJ311rJcSCmQcbBoyOGAeEvbbSnKj2j+zpn10K
	 uKUcHHRSK8QicsnORjwxzMBcM3eo2FWE3bVkDB3I=
Date: Thu, 1 Oct 2026 14:52:06 +0100
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
Message-ID: <ar5lhhdKlK6NwX19@e129823.arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-3-cba7359d882a@arm.com>
 <16f16e77-05ab-418e-ad06-8f48fb29375a@kernel.org>
 <aruMgm8UZ_t2V_wh@e129823.arm.com>
 <3e03425b-7962-4c69-93aa-96168fd7168e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e03425b-7962-4c69-93aa-96168fd7168e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F7EF1C0003
X-Stat-Signature: 4hjooiijtokepq5w9mhgn869cubhaetp
X-HE-Tag: 1790862732-729852
X-HE-Meta: U2FsdGVkX1+ywex8L2zt8ZipP5WVLmntQzgImM3a20Oj7Z5ImBm0HnnnzgZDS4mcGx/wTAXLrRJPPCNl9KJTcIM3ycLqBWA7PzoEuIWVCns6zuKFNFoBIBDeIafErJm8OavpR9HNlEvtjmCxobIGCxBjiVqOLWdG0sGI8B+qFMprjNCfYFUip3flME0eiXHdvJiUuoNsoDeh53NkooAl/M/0DaHdg80mmWdP+MGkF3tyrXeu99e1QMbxgS/cQtd1tE3Dby90Oxz8I1XNzTdlJzHBIUfNQUqDYR48qMYots4I8lzlKORMrCvo3vPcktnxGnikK9mELphYHdLGxqcxJqsAEfEknYEXQLwNMHaRykDIk2VwOBkqSjtAr9qH4h+ennssUPuhoWVmlb33SK2pzDsXzI6r8KRx9iqU69dkJJjBHEtlxNK928K8JDX/dzHp3fk5PAv89GjOLnkqIvFM+/kMO7iFOB05+HYRnfdRHKBVocebRKrmRRjvTxtsOyv4spcUMLxs3tL8xXr9j9K2REvjd7pvNxx3zv+0k//kvu3W9JmaYPPaPtybrq5TVJAT0stqLHas5K2Hio/3ca/wBHF9PGIdH5Iq1Ys2Ad+p4+KsHa/V5e+Gji0bhWmqXPPuMMN1O6955fNrZfy83yHZ+YOMl+lGbPv6eKHd+6GTJa7UZof7qaBWpz2ZZHQabmJu/tZZtmiZ9JhK80gndk/YxAROfCePrxba3ZBA2Jn9jJAXuUcT16Q+aaW9RGHlXAhrVM26158EFabQjrj20Yu76YhYQnPTs90/2CHgqWKUzfU0rle3p3nXvP9KNgudfHERkyaa5CYMh+bijqC01NwNaAmcOckJklp3sSt/a4RDxrSgFJOsrEurDA9lZYZtzQL7ZgrKt3tvQORGflSY42qaR4Gs0gprKtmAKtXrqKPlJ1jW2dxEP5roxVAr28biIcs6xwgMORVkq77C70l+gBV
 /rNahnt8
 KRDjIuzJ9T2yN7+vEajlmMKbmRFBRfTMnFu/T7quFPW8ykMYwZKmDSDvYh85JnN6njShVBzMFUH6AfATc5a/M0gGWpQpqOpTDulZe5Z0zuOKxyb9F9mjsppOvGafyL1HYcs+S4Lr3IcqOcw1nufl7cKU1DrkYUiKKe/LL1M3eTsxBPo8Ib4GbXIjg6wKgstB7OtH+Sg+l8hx1f3+BUYSURF3SuyTdTHsoQAZwGlcZnDY0DY2QUnF/UCqRSU1FHTLRdZogQPuRNiU7CfG0ZmFD+Y5M3q6IK3wPcPVzG6HgmMs9Q20hsWLZ8EEIvJzdNoE/o6pJJzy1XDPsXiam561HI0Ndmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 9/29/26 12:01, Yeoreum Yun wrote:
> > On Tue, Sep 29, 2026 at 10:07:37AM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/24/26 21:11, Yeoreum Yun wrote:
> >>> check_large_folios() only checks for large folios without distinguishing
> >>> between anonymous and file-backed huge pages.
> >>>
> >>> To add huge page type checking, integrate the huge page checks into
> >>> __check_huge():
> >>>
> >>>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
> >>>      check_large_folios(), since only the mapping type matters. This
> >>>      identifies PMD-mapped huge pages.
> >>>
> >>>   2. Otherwise, use check_large_folios() to detect large folios. This
> >>>      covers mTHP cases.
> >>>
> >>>   3. Check the folio flags according to the huge page type.
> >>>
> >>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> Suggested-by: Zi Yan <ziy@nvidia.com>
> >>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> >>> ---
> >>
> >> Instead of merging both things (detecting mapping vs. detecting anon vs. file),
> >> could we simply perform the anon vs. file change separately?
> >>
> >> Doing another pagemap walk that focuses on that should end up with something
> >> that is easier to read.
> > 
> > Okay. I'll change like below in next-spin:
> > 
> > -------&<-------
> > 
> > @@ -411,57 +400,78 @@ static bool check_huge_type(uint64_t categories, enum check_huge_type type)
> >         return false;
> >  }
> > 
> > -static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> > -                 uint64_t hpage_size, enum check_huge_type type)
> > +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> > +               uint64_t hpage_size, enum check_huge_type type)
> >  {
> >  {
> > -       int pagemap_fd;
> > +       bool ret = false;
> > +       int pagemap_fd, kpageflags_fd;
> >         int nr_pmd_mappings = 0;
> > +       uint64_t pmd_pagesize, scan_mapping_size;
> >         uint64_t categories;
> > +       unsigned long pfn;
> > +       bool check_pmd_mapping, allow_nonpresent;
> >         char *start = addr;
> >         char *end = start + len;
> > 
> > +       pmd_pagesize = read_pmd_pagesize();
> > +       if (!pmd_pagesize)
> > +               ksft_exit_fail_msg("reading PMD pagesize failed\n");
> > +
> > +       check_pmd_mapping = hpage_size == pmd_pagesize;
> > +       scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
> > +       /* Some mTHP tests check a partially populated PMD-sized range. */
> > +       allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
> > +
> >         pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> >         if (pagemap_fd < 0)
> >                 ksft_exit_fail_perror("open pagemap");
> > 
> > -       for (; start < end; start += hpage_size) {
> > +       kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> > +       if (kpageflags_fd < 0)
> > +               ksft_exit_fail_perror("open kpageflags");
> > +
> > +       for (; start < end; start += scan_mapping_size) {
> >                 categories = pagemap_scan_get_categories(pagemap_fd, start);
> > -               if (!(categories & PAGE_IS_HUGE))
> > +               pfn = pagemap_get_pfn(pagemap_fd, start);
> > +               if (pfn == -1UL) {
> > +                       if (!allow_nonpresent)
> > +                               goto out;
> >                         continue;
> > -               if (check_huge_type(categories, type))
> > +               }
> > +               if (!check_huge_type(categories, type))
> > +                       goto out;
> > +       }
> > +
> > +       if (!check_pmd_mapping) {
> > +               ret = check_large_folios(pagemap_fd, kpageflags_fd,
> > +                               addr, len, nr_hpages, hpage_size);
> > +               goto out;
> > +       }
> > +
> > +       for (start = addr; start < end; start += scan_mapping_size) {
> > +               categories = pagemap_scan_get_categories(pagemap_fd, start);
> > +               if (categories & PAGE_IS_HUGE)
> >                         nr_pmd_mappings++;
> >         }
> > -       close(pagemap_fd);
> > 
> > -       return nr_hpages == nr_pmd_mappings;
> > +       if (nr_pmd_mappings != nr_hpages)
> > +               goto out;
> > +       ret = true;
> > +
> > +out:
> > +       close(pagemap_fd);
> > +       close(kpageflags_fd);
> > +       return ret;
> >  }
> > 
> 
> I'd leave existing __check_huge() mostly alone, and instead have an additional
> function that checks the type.
> 
> Essentially a __check_type() or sth that we run after the large folio / pmd check.

So, You mean like this?

-------&<-------

-enum check_huge_type {
-       CHECK_HUGE_ANON,
-       CHECK_HUGE_FILE,
+enum check_type {
+       CHECK_TYPE_ANON,
+       CHECK_TYPE_FILE,
 };

-static bool check_huge_type(uint64_t categories, enum check_huge_type type)
+static bool __check_type(void *addr, size_t len, uint64_t page_size,
+               bool allow_nonpresent, enum check_type type)
 {
-       const bool file = categories & PAGE_IS_FILE;
+       bool ret = false;
+       int pagemap_fd, kpageflags_fd;
+       char *start = addr;
+       char *end = start + len;
+       uint64_t categories;
+       unsigned long pfn;
+
+       pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+       if (pagemap_fd < 0)
+               ksft_exit_fail_perror("open pagemap");
+
+       kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+       if (kpageflags_fd < 0)
+               ksft_exit_fail_perror("open kpageflags");

-       switch (type) {
-       case CHECK_HUGE_ANON:
-               return !file;
-       case CHECK_HUGE_FILE:
-               return file;
+       for (; start < end; start += page_size) {
+               categories = pagemap_scan_get_categories(pagemap_fd, start);
+               pfn = pagemap_get_pfn(pagemap_fd, start);
+               if (pfn == -1UL) {
+                       if (!allow_nonpresent)
+                               goto out;
+                       continue;
+               }
+
+               if ((type == CHECK_TYPE_FILE) != !!(categories & PAGE_IS_FILE))
+                       goto out;
        }

-       return false;
+       ret = true;
+
+out:
+       close(kpageflags_fd);
+       close(pagemap_fd);
+       return ret;
 }

-static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
-                 uint64_t hpage_size, enum check_huge_type type)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+               uint64_t hpage_size)
 {
+       bool ret = false;
        int pagemap_fd;
        int nr_pmd_mappings = 0;
+       uint64_t pmd_pagesize;
        uint64_t categories;
        char *start = addr;
        char *end = start + len;

+       pmd_pagesize = read_pmd_pagesize();
+       if (!pmd_pagesize)
+               ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
        pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
        if (pagemap_fd < 0)
                ksft_exit_fail_perror("open pagemap");

-       for (; start < end; start += hpage_size) {
+       if (hpage_size != pmd_pagesize) {
+               ret = check_large_folios(addr, len, nr_hpages, hpage_size);
+               goto out;
+       }
+
+       for (start = addr; start < end; start += hpage_size) {
                categories = pagemap_scan_get_categories(pagemap_fd, start);
-               if (!(categories & PAGE_IS_HUGE))
-                       continue;
-               if (check_huge_type(categories, type))
+               if (categories & PAGE_IS_HUGE)
                        nr_pmd_mappings++;
        }
-       close(pagemap_fd);

-       return nr_hpages == nr_pmd_mappings;
+       if (nr_pmd_mappings != nr_hpages)
+               goto out;
+
+       ret = true;
+
+out:
+       close(pagemap_fd);
+       return ret;
 }

 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-       uint64_t pmd_pagesize = read_pmd_pagesize();
-
-       if (!pmd_pagesize)
-               ksft_exit_fail_msg("reading PMD pagesize failed\n");
+       /* Some mTHP tests check a partially populated PMD-sized range. */
+       const bool allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
+       const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();

-       if (hpage_size == pmd_pagesize)
-               return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-                                       CHECK_HUGE_ANON);
+       if (! __check_huge(addr, len, nr_hpages, hpage_size))
+               return false;

-       return check_large_folios(addr, len, nr_hpages, hpage_size);
+       return __check_type(addr, len, scan_mapping_size, allow_nonpresent,
+                       CHECK_TYPE_ANON);
 }

 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-       uint64_t pmd_pagesize = read_pmd_pagesize();
+       /* Some mTHP tests check a partially populated PMD-sized range. */
+       const bool allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
+       const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();

-       if (!pmd_pagesize)
-               ksft_exit_fail_msg("reading PMD pagesize failed\n");
-
-       if (hpage_size == pmd_pagesize)
-               return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-                                       CHECK_HUGE_FILE);
+       if (! __check_huge(addr, len, nr_hpages, hpage_size))
+               return false;

-       return check_large_folios(addr, len, nr_hpages, hpage_size);
+       return __check_type(addr, len, scan_mapping_size, allow_nonpresent,
+                       CHECK_TYPE_FILE);
 }

-- 
Sincerely,
Yeoreum Yun

