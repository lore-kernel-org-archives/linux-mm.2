Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6CABCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941476B008C; Tue, 13 Oct 2026 05:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9189E6B0092; Tue, 13 Oct 2026 05:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82ED66B0095; Tue, 13 Oct 2026 05:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F45E6B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:18:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE164C0A49
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:18:27 +0000 (UTC)
X-FDA: 85317052254.01.1855C22
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id E036E180007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:18:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j1hjgoF9;
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791883106;
	b=3jtN48SCiHJQUFGgPMGH5WB7pPSuP5/cQxQ3fWgHdms6Dwv5GMkqYtGFYd7sdP8LB4gBmH
	HCMnTA2Bs5gxf0C+pJ/mr8Joxv8G4apqRZjVfYoKaKN70HMOFFablj+DCTjZ7OHl+veeBL
	G1QNB6zIWMOwX16/h6GXOcrsHcWPMOs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j1hjgoF9;
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791883106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LghFxOzFX5561UyRw3PoliNdFHX5xv4WfaZ0X8D/DpY=;
	b=zky3rLiRjSIhguG81/0OQurNEHQ0kkZrJbIoTsecMqD2+AMyZC0N0c1pdAwmu3qpF/hBzP
	Pb74XqQeYBnuaHrRo2yTKsZyKz5v36rL27EjG9s3L57kjNWNIWgiwYjG5h6He/DROe/h12
	9AFAqC7mg5HELxUYT4JWQMqIo8Pzx3U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F9E3169C;
	Tue, 13 Oct 2026 02:18:21 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 724B73F7B4;
	Tue, 13 Oct 2026 02:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791883104; bh=EOkC7IxwRjX5sV7VTQMqZrlCovHAjCLACVvh+hdQqTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j1hjgoF9HlQ/oP+4K7eHi4L+8h/Oz32n9SCYza9/O6FSh+/whx+zkwfXx/GApokxV
	 1yG0fCmEIYQCchZDyiqyqHeBzkJqZkj8TyuKKhsHKv8GILo4p7TAzJfji2JuIz2vFw
	 DG2fxW3PkXrceMTJEiu02y79uPY3e4o/Au5Nb58g=
Date: Tue, 13 Oct 2026 10:18:19 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v5 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Message-ID: <as33Wxv7t_8UO505@e129823.arm.com>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-2-54378ae45add@arm.com>
 <askfkwPaItOw30-r@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <askfkwPaItOw30-r@kernel.org>
X-Stat-Signature: kyxnbz79p478rkc8pf6tnz4mu5rwsx8p
X-Rspamd-Queue-Id: E036E180007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791883105-204161
X-HE-Meta: U2FsdGVkX18NGb/Xg2LGJSyk9WajuxpMSZaUdDwszyh/drsRMA6Pd0Bq5O0RrSBN8IBRg/1WkFGwViTQy8vn3f15Jj1+pQf9QwrOhozh1/NjesIyI+qVaWO7b4XK1QUOJwB5ogycNnGIHgC2Kfn0swO4XJh562XO/fncojP+VIzPNQl31nBFJG+10SdYYeM37bF9LNx8em9TBBRALnXSrsZrm3VHddu2G3Emo6ItSDfC8DkNtpwrS0tHUWscfoLPm0JeoUfItumaox7huLjpgiXLJsiJn045XYSYS9D71984HO/Wq3aYuE9ys3UGWMZ0qdwLI/MJtKja2OSWtoOAWEEiUnA3bQTKSozr23UOG+4ktErdLhKNiM+iXKR9kfJmYwPnD7SOJeMWcay5Fpo0VE66qCH9P2YcUOB7x+bR7ZTBW7S5wuXBliTGgjVsIpNUb87fnoteZ0MTUOuldBLcHZUYiuaohNcGye20olwPeHmYx0UiX4IL8Rsh5AaDhYsCxWInwMNUxkgCzUGHZfwwzP+e0TQsArSdGHh7I1aAJ66EqzIw9D6sQQrb6nrhOiiZOZkLq2jz8jDKhv1zS7YWD4cQ+zyDEMStQ3ru9U/M5MR0aH2eENU/8W/YE4XpiQxpa3h9GEgOvqImbAaN/XGkb0M3yuRO9rNNFtNNFe1H6CqIX+gShp5evezyv+VMmrFmNITUX6la6OmkyPixigJSKdN9lgFWNORTA88VwikeH4AVVoDNa2yQKIVHJrswEwhLwwuAYceefhD9aaFdY+VrxqIpS2eOHL3XvVtbhMUefCmLN0f7gMLd8vu9o0v0e8U0p1frusdxYgRUSZfqx4jdcQAgz/6sZldmbhMNoPxZerAC9hasfVErY3Kpyc0UfR8N2Dv+fr4JNERgreNs9siL9XGYs3i3Y4YvgG4WsZ620DgS+ZJ0cI7dHjQwtFelqTRYQAl5EPLRFWGKU/wAFsD
 B/eaKZ6/
 cQpRWd9ol4o3ZneGYFGPshV91GN64twCqZl+LlL4ZrgrCRYOVMtRyAtx9/cSavlMCF3ynfpq8VXjXcmEnQaqIMqc55FvZatH/JFpxZp4pr+2SGjeK11xYMzSI0pGQGEJ6EPHT6fh0pWVzWzjBhb8311Tn3OjdVOAzme+bDkw9OHXK0Vd2tN0+cKwd/NdZI3NC+bQGeppQdtGK8ecpUqCiMZfOJfH1nlEJnNFLAGxvgeR5+p7nmG+0vJfn5wVBj5PZGieKG7zzdAcNwnNuldLt9D3hKgyyQ4iyQ46WrpWfHeZIJSBfmetmjiZ760xxbyM7hwlGSBjyv4WMz3neoJCD+DuPNqRt0bUS73A9KkBgBc4ydFlH0E6BRkxyqjeCPTo3Y4NQkvQTN+OIRAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

> Hi Yeoreum,
> 
> On Fri, Oct 09, 2026 at 02:27:33AM +0100, Yeoreum Yun wrote:
> > HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> > When this macro is used in some test, test result would be strange in
> > the system where PAGE_SIZE is more then 4KB.
> > 
> > Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> > 
> >   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
> >     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
> >     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     ...
> >   ok 1 Completed
> > 
> > Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
> > helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> > helper, pmd_psize().
> > 
> > Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> > which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> > and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> > PMD-sized units, the test may fail with the previous size of 100 MiB,
> > which is not a multiple of the PMD size when the base page size is
> > 16 KiB or 64 KiB.
> > 
> > After this patch, output of transhuge-stress:
> > 
> >   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
> >     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
> >     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
> >     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
> >     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
> >     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
> >     ...
> >   ok 1 Completed
> > 
> > Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/guard-regions.c    | 11 ++++++--
> >  tools/testing/selftests/mm/ksm_tests.c        | 16 ++++++-----
> >  tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
> >  tools/testing/selftests/mm/transhuge-stress.c | 25 +++++++++++-------
> >  tools/testing/selftests/mm/vm_util.c          | 38 +++++++++++++++++++++++----
> >  tools/testing/selftests/mm/vm_util.h          |  9 +++----
> >  6 files changed, 72 insertions(+), 31 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > index f7d53ea3c2527..3052823b0eff6 100644
> > --- a/tools/testing/selftests/mm/guard-regions.c
> > +++ b/tools/testing/selftests/mm/guard-regions.c
> > @@ -2194,14 +2194,21 @@ TEST_F(guard_regions, pagemap_scan)
> >  TEST_F(guard_regions, collapse)
> >  {
> >  	const unsigned long page_size = self->page_size;
> > -	const unsigned long size = 2 * HPAGE_SIZE;
> > -	const unsigned long num_pages = size / page_size;
> > +	const uint64_t hpage_size = pmd_psize();
> > +	unsigned long size;
> > +	unsigned long num_pages;
> 
> These can be declared in the same line, or at least follow reverse xmas
> tree convention.
> The xmas tree comment applies to other declarations you are changing where
> it makes sense without additional changes.

Okay. I'll change it.

Thanks!

-- 
Sincerely,
Yeoreum Yun

