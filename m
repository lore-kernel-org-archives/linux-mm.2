Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D259C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45CFA6B0088; Tue, 15 Sep 2026 05:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5286B008C; Tue, 15 Sep 2026 05:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1FA6B0092; Tue, 15 Sep 2026 05:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA4856B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:39:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12055C0384
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:39:37 +0000 (UTC)
X-FDA: 85215499194.04.1D7C964
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4008A14000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:39:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LbFtepk3;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789465175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uhpvQmr+AqCToUbIpUgflGVW8DQQ+RYjBfUFAIbuyk=;
	b=WRsVwqNsjvC4iiUZYGX0ts1IBaPLduZRXBSr1J4z7B/xb8f9PWzoND7Z6xKJzrfq8VZjGy
	ys35CQ0JgfDUifjsduI1p4m1sLsHPduKhjLExewbmUq1CCNtuiHA/54KP+Mh0rxWIUYyY+
	CtRyWRNQP1Bx3U0+YY5k2OYGQPNWUc0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LbFtepk3;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789465175;
	b=BX5JM7RF8Wlw+Gx/c37ZqYY0vV+0pTv0BQXLnpUWA5FcbXxNX7YQGXcZu+cf3U6+hl83wM
	rQcpd/D+Z+rss+8NJqP6vrD3SJwzAZjXXw4p+4cLIPexuin1g5ZPXRLua6S6lwL3AIwkGd
	+OUkRk99yAYZqimlnZE9JRrF1nuGwAc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A06CB169C;
	Tue, 15 Sep 2026 02:39:30 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E29F3F86F;
	Tue, 15 Sep 2026 02:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789465174; bh=WvKg6yi0zy54Y7B92PbBMnpXp8kB6bmsey88lYteFxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LbFtepk3gfAVUJ6FMQ6DX7rrzqIFqKbksF5m7SwDJw6CtohV2sV6LZb3AxkRMAX3X
	 g8QbVXj0uGezWwbtv0j/1n9P7ctbLBAV6ujO1c/SuwFQhEmM7Xm3pKHr5+0BI9HJWn
	 mv99fdUM9uYHfo7tMlTA7cKnSKCBa0luxL+g8lkQ=
Date: Tue, 15 Sep 2026 10:39:28 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
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
Subject: Re: [PATCH v3 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Message-ID: <aqkSUBm_8LpIjAsZ@e129823.arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
 <20260914-fix_hpage_macro-v3-2-c9a305a01d39@arm.com>
 <DLFJ9GNOF56E.1PDQZVO24RME@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DLFJ9GNOF56E.1PDQZVO24RME@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4008A14000B
X-Stat-Signature: qxsxgxcbuci3qifzc6zo1geajbqff414
X-Rspam-User: 
X-HE-Tag: 1789465175-317081
X-HE-Meta: U2FsdGVkX1/4hW/Xpcc4mopa6OGxQtcTCNSTtk9RPspjr21dw4WIC9vKIkpT3QIiyJVJGxXTV06VCurjMF3v6hFDqKYZ24JBQ/4eZ8sRuraTM898KVsytV7XDGzcCt+BmhKTIJo+xLuAsvZl+u092YxvgMdM/o86v/S1b3br38OGdth8BnHaaOwmn+nV4TJlQDFYyFBTHKaX9oxB/52FIJUEfq6Dui9T8LcL4akRgtEFbyLhibmNPfujUKJvA63BB3g0oWCNFQcLfbYInCqg/XmnHo9V9yLHAaXjG8abHsnCe36g91FpBLVG7vT24s9uzUmOU36UoT+jOxfnm75efG9LD72SvOR87fCS+quKVBF6WzRUcRi2TrUFeLsA/xNLGtWuph5frxyuO44LeO8SUmNoMZLZcp+DKt10NKVG4GRBR57nIRKEsYsl2mb48TvtqJH/sWWeQXk4qYUBUfihHA5JDSr64fMwUYCdNmkHAf9d25jfsejdTkxlKIRbzcuYnvwCEM5wdPGpb22o4mgtIcK3XOlFOIxowkHtCC71ATylhu5gVATgDQ9OzS1cHC6j2G+Te9gVWulfnWUFyUI1cXigKG90g4FJb5Du0GGAQxRbj0BqfHKqgxlehiTAzWb0qDQsWhLWwXOjr5zxeiY80m2gtw2ODT7hJ1hXdX6fSWdiv/c/pbb+EFGUGp8iktX/c9EtS9NW3ZBO1UQUe/RlFY68Rr+9aOWqMgu0+9imAYd8S6D+mA1Jd3cCXEcOAOZCEf9liAYIAjvlKa7Dnz0VjOPsEfurwyI/bLgbMmhFNoNrclRAM9dPYQIGwgDCLMymeYRS6ybQKzwOkGnrJ7jcuSqz/rakuTfuSa6P54iXTAfdOevSOyLRdcguwxJmaYDgu3A6J7LAzDtiXD6tkm2O5uweQuy+fdWz3vdZmPaDiHkb7w6kuwavH1X0FKDjiNpZ0ZWyyboItKbU2AV6bo3
 YhuCrZNk
 +1LgVXAtgwDekBaQ5EvoknUS9tQavH/GnpgCgRv0V4NaflvjWQgc6muGTLvlEB/cHOvXOytCt2cadm72crqxRh0VDKbp4KJMZ/aRSOqPHzTfhMCtzhzXNKxmK60FDUpQHNTa/purqBkFOeNCILhTCYsztfjqaPuBm0lkwLF6jG3Q45sUMGj1O6AxDoItKJbUxMjt/JGKA/e105KmEzeUGOfR+ov2qhdISKU9/SO1j0hC6RMOx4ZyE+k0+lrSi/Gkq/kR1ZKPi3qzRWaeF4GF8S2kefv2a5UEeylTZYEUnxImPcaXvwhEqoGBejGpFojtJVJgnUO8d6Apw79/N2kxEIbYRBaT22sYJcypR3cMpx9LsVpbowq1ZkbmYlOIgF52b/bPf36fCcFdE8nP7ASUsSC0SOWOWRQEUscqs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 10:26:59PM -0400, Zi Yan wrote:
> On Mon Sep 14, 2026 at 3:30 AM EDT, Yeoreum Yun wrote:
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
> >  tools/testing/selftests/mm/guard-regions.c    | 11 ++++++--
> >  tools/testing/selftests/mm/ksm_tests.c        | 16 +++++++-----
> >  tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
> >  tools/testing/selftests/mm/transhuge-stress.c | 25 +++++++++++--------
> >  tools/testing/selftests/mm/vm_util.c          | 36 ++++++++++++++++++++++++---
> >  tools/testing/selftests/mm/vm_util.h          |  9 +++----
> >  6 files changed, 71 insertions(+), 30 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > index b724d62d2b75..eee29ef88cb2 100644
> > --- a/tools/testing/selftests/mm/guard-regions.c
> > +++ b/tools/testing/selftests/mm/guard-regions.c
> > @@ -2195,14 +2195,21 @@ TEST_F(guard_regions, pagemap_scan)
> >  TEST_F(guard_regions, collapse)
> >  {
> >  	const unsigned long page_size = self->page_size;
> > -	const unsigned long size = 2 * HPAGE_SIZE;
> > -	const unsigned long num_pages = size / page_size;
> > +	const uint64_t hpage_size = pmd_psize();
> 
> Is it better to use pmd_page_size/pmd_page_shift instead of
> hpage_size/hpage_shift for clarification? Maybe in a follow-up patch if
> you think it is reasonable.

He, I don’t have a strong opinion on this, but personally, I think
explicitly naming the huge-page size used by the tests pmd_page_size
makes it clearer. Still, if you think the suggested approach is better,
I’m happy to change it accordingly. ;)

> 
> Otherwise, with David's concern addressed, feel free to add
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!
> 
> -- 
> Best Regards,
> Yan, Zi
> 

-- 
Sincerely,
Yeoreum Yun

