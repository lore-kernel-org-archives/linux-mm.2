Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07568CC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 14:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5F16B0095; Tue, 13 Oct 2026 10:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56926B0096; Tue, 13 Oct 2026 10:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46476B0098; Tue, 13 Oct 2026 10:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97B616B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:11:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31C89A8B0D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:11:49 +0000 (UTC)
X-FDA: 85317791538.23.42AD1F6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id A3B691C0008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:11:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=COwDhIpl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791900706;
	b=HElvlyCjrZNV9ZA1q/aNoLDlv0YSHvWuK5Iqt2z3ItXeIkZBw6uJlAKs9ZKjP8/Yw0+h1k
	LEnjGNHax7Ury/bvRzHK/Wi7WYCG8dHjLK1EgJoEpURELAmvea7GIRADwVLrT3dURJRhq8
	mKHR2k1xJqfuGW+RTtMVdkQuMXCmkv8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=COwDhIpl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791900706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTpf2h9vwBKdN/hdiV+H5zAxtvwmCU9S1J/VT2WJINE=;
	b=ojOQ36s+FZXdsT942MTlaAMekptipYHBAEO4TWjbyVDPbbUdC51FC9w7FtJz7ztt2CBdMH
	RK2by27TaxhIwQBkf8KsPCobsxdV3xxN45hvo5FlZd6qaNnLCXz9dPTk6KAMdsyMWfrEMX
	cxPbegAXINOMvfU2mYEk0srowYDAgWY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EE65169E;
	Tue, 13 Oct 2026 07:11:36 -0700 (PDT)
Received: from e129823.arm.com (unknown [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77F1F3F7B4;
	Tue, 13 Oct 2026 07:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791900699; bh=d/DaViX6waQjEqKz+BRXBRyPDQzNzOaSHBwWJqd0NxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=COwDhIplXug+N3BUuVPymIIemCYgZM0nKYl9fW62zWUEPhoodm3dfc3SR2KbznwZQ
	 bp/+qoTUhaPqE9NjEKwpjEc//4nUaIr178J2towXpIWOLnN8fLkTRXjv8G42EAfYfG
	 HNOM35+vziAgrZiRfnh7+ikSiq9x0SsbfOk0c7qs=
Date: Tue, 13 Oct 2026 15:11:27 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
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
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v7 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Message-ID: <as48D1SnImCro_Cb@e129823.arm.com>
References: <20261013-fix_hpage_macro-v7-0-3d77129e0557@arm.com>
 <20261013-fix_hpage_macro-v7-2-3d77129e0557@arm.com>
 <b3f2a0bf-7b41-4cc9-958e-34f1a88ff5bf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3f2a0bf-7b41-4cc9-958e-34f1a88ff5bf@arm.com>
X-Stat-Signature: pp1gy3cim7wxjaxwo47t5syn4cok1ths
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A3B691C0008
X-HE-Tag: 1791900705-204230
X-HE-Meta: U2FsdGVkX1/5PQWJrlZu2eumKl9mlELqlywaIzMqb+x7lm7ZgnW1Zq8pTZPDDwwQ7oFKxpoKa8vDIHQkV2lE4wCGCW2MEdB+3SNMJPSFciDIIkTqrVl+r8WJvUhuNEsXvT/uS0d2xzROjgAlo00bpjlpazz0h3sLyqP3AFulz8FehuRlEZAaHaslHaLiLskmX2qMNIK19Wc0ITvt7R78gmRoBW2qe5CLv3ENKfdZkFlFQsfDBaLrmRYKM1aluNz8wH1tjcMPEzRJFdu9oCR6tgvrdjGln19LwL+YnaMuNb/LEZ54zjSq3OYSrurO74BFrZYagoeEdiPa8E6INNlranwH9S3Bm2VMZY7q1aqIYhe692ImhHf5Y/xi3eHFUE4QmFVufYXtGHfXO19C+gKgKaHZqrGpbFT0bijIOZIsnXAd2XN5k5KyG5V0zFc5sd9eUCgL1jzewaDUfIjkzsdteh2sdGIZKyWzZzcobTS4h4y7bwF+jhcuwEvSD7cAiLC2LP5X2aGnDUejyq2JyMvV2IbQgFQiTVi6ORe9OAknUHQAFDir1ByLmI96T/IsrbNFKduQLw9Hw3Qud9kZA0qTp9TYUEORCc2ugMsoGUXzzzCmOSUcHBqmRh6+IeMVtfepT3/KNjNCF/0okT0poDeW6wcG93MubUqp6MWWw0QqmLU6IXM27wsIvP+NowV+C4l5tulELL3clPSNqgK2a7Luu+VP7GIgXP7geF3ZC50d54zyDYeG1HmN3PU3jw97Yxnr8M194YaxbLj4OqdCQHffpwtvXPnSA9qL7J3Yajqdwpkq1jFrU46GRd55AyHJ26QcHfnW1fUtdIAOPvbU3H1u1kkD/fXLiYuBg+3Ew43q4UB0ApFAv8SKhUjopFQxKTOqaI76/SqppMGWwsB6UU0zzMfhI7cJS9ZjA8u99psO9D8lTn1UzRSdhqFSME2N88aVAGsryolGpQdrtXli8kh
 659/Tv2g
 cbRKOckdpRm6M4/GrA1Kk+n/jYKqPIRulbVcBtGXc/hot0HslOKv4Apv50wO5C8gaJzMaCEFlQoqY2gqHqeIXUQeN4LNmbWH1fLEtunLJ5afcGQy960ECsuBZbA9S4KJf9Fc5+CblqspaRvYBw8eXICsr00GWYZgMhpN90qwbNoSaZyPg0TcWCG9BGT9De9kcrC+Esg5bSTF+G0W3GYSnGRM0uKaZpiDWg7EWQTHGIxaEzRUfDUvnrPdpgOOXj37xf2oTeXnnfxqc/F47u5LMTbZ+V54BimmdpyhHWCem+ocrfrYySCTrcRti7Or4t6dfIYHngu+ylbCTr+okZ/i3/iCK/J1xHFvVJ9UXznQnHwInkNz8j3AHS9nx0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi Yeoreum!
> 
> On 10/13/26 4:07 PM, Yeoreum Yun wrote:
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
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/guard-regions.c    | 10 +++++--
> >  tools/testing/selftests/mm/ksm_tests.c        | 16 ++++++-----
> >  tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
> >  tools/testing/selftests/mm/transhuge-stress.c | 25 +++++++++++-------
> >  tools/testing/selftests/mm/vm_util.c          | 38 +++++++++++++++++++++++----
> >  tools/testing/selftests/mm/vm_util.h          |  9 +++----
> >  6 files changed, 71 insertions(+), 31 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > index f7d53ea3c2527..02f69244f9a42 100644
> > --- a/tools/testing/selftests/mm/guard-regions.c
> > +++ b/tools/testing/selftests/mm/guard-regions.c
> > @@ -2194,14 +2194,20 @@ TEST_F(guard_regions, pagemap_scan)
> >  TEST_F(guard_regions, collapse)
> >  {
> >  	const unsigned long page_size = self->page_size;
> > -	const unsigned long size = 2 * HPAGE_SIZE;
> > -	const unsigned long num_pages = size / page_size;
> > +	const uint64_t hpage_size = pmd_psize();
> > +	unsigned long size, num_pages;
> >  	char *ptr;
> >  	int i;
> >  
> >  	if (!thp_available())
> >  		SKIP(return, "Transparent Hugepages not available\n");
> >  
> > +	if (!hpage_size)
> > +		ksft_exit_fail_msg("reading hpage_size failed\n");
> 
> I'm sorry for not catching this earlier, but I don't think calling a
> ksft_exit_fail_msg() for not being able to calculate PMD size is a good
> idea. Maybe call an ASSERT*() here, something like
> 
> ASSERT_NE(hpage_size, 0);
> 
> so that just this test fails, instead of the whole run exiting with a
> bail out?

No. The failure would occur if open() or read() fails, and subsequent
attempts would likely fail for the same reason.
This is also why __pmd_size is set to 0 after a failed attempt.

We don't need to produce useless failure log anymore.

[...snip...]


-- 
Sincerely,
Yeoreum Yun

