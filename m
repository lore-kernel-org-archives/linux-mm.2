Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E077BC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6286B008C; Mon, 14 Sep 2026 12:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F936B0092; Mon, 14 Sep 2026 12:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E2D6B0093; Mon, 14 Sep 2026 12:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 854DA6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:46:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FCEF1C1556
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:46:45 +0000 (UTC)
X-FDA: 85212946770.16.D4A927E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14BDF14000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:46:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uQlLzw5h;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789404403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5QcKmeyAMwJjFlRZ2LyOKih81w4kFzaKRYI/GcEvuA=;
	b=Rw2vI1Gkdtd/vs+52kb3RpH0b54jd/u1i8RERObapponIWWFscbKdU5Ba61B0r4gG2/qGF
	2qkew0IXut1eVFbdNFsNRS/9SM8CNlPfyLZ4dvTzbTbC8fvfa24Y08X8PxBdpae5M1sD7N
	5ZaYsf2wnZGPs033V1vdU6CQfMNqpew=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789404403;
	b=U92OeR9e3JSJ3vGqrZYEx0uBIrAsEuZhOSdXX0GE9RJLFPWJbLZGBLo57yUeGRuprBnMUy
	sL1DrjoolFkhK1cLov6D+WEwvKMIRE5H3N+TqZORb49qgfYpV8UEodhAmpJ3Jb99GS3wc2
	ec03m4LkbPqQ+Tm1AapZqIHrsS70kWU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uQlLzw5h;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64B02153B;
	Mon, 14 Sep 2026 09:46:38 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2B093F86F;
	Mon, 14 Sep 2026 09:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789404402; bh=1r0rw5uXWXH7+bTv+MSPJvopnTN1PMSJsWeAueQ3OIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uQlLzw5hH4+y/inqoVF5LI/F5v/0OKn3hBu6YiJiF5RclJSOU30kwx8YQiz+Vd6PF
	 Kv7GPxXOdE5fNGfmy84Lk4zDUWKwNpomuiIOPLKBUe5upqoT8HCMnT9CQccy6wU2yp
	 spL1qj8fM3HA59WNxLYe00SO/h32opTmY4jE0wkM=
Date: Mon, 14 Sep 2026 17:46:36 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
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
	Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v3 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Message-ID: <aqgk7EVV1K_3Pc86@e129823.arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
 <20260914-fix_hpage_macro-v3-2-c9a305a01d39@arm.com>
 <08d3313b-d891-4202-b460-c5cefa96bbce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08d3313b-d891-4202-b460-c5cefa96bbce@kernel.org>
X-Stat-Signature: weoju5yj41suei9aytchs443cbhzkpnp
X-Rspam-User: 
X-Rspamd-Queue-Id: 14BDF14000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789404402-237346
X-HE-Meta: U2FsdGVkX18xqSM3KzwDq6sE4w5Kda+ZYLpEBKeZSql5ipQQCJLFfcYUS8DL835khhccSe3Eb0wHXKxIWU2wp1zf3dhpvNRBbDvZa1c15/oiHjxX7ub6falGfFfxMH8i43I7qWYPMx3DYIv4rBE54V4Er2jacfgD0UYG1/ZVb9DJz8OWlwSsfkMS8p5PM0klhz90IDYbfPp3vwia+gKb9VnjBc10q/LuAfc325ZnFzDERDAhYi6tc5RLd0fAAvi0RibO0qxN/rPtpYs9/Yf6t8u8J/MARky3cbyOG2Yhcb/saDP2M/prOicTrzEK6UoowQSWE6h4oQFBqiRpiEffw6E0NBjVDyWEbiJADu53vCcuyaggLWm2lGetQzBsTXtCRwv4ooP73GqvgCV6YuptAMf2iVCV8mShwr0D+Z12nt7A4B6FDBYQGfG0xLpQOcjukrPbt4wTeAw/gZQ2x+4ZbdAURJEQGHBjksfDgvyyRD5LrfJjhqQ1jFRXf+NTp0gRwSiNrhQt6orQN2r8oC/JbNDmelg5jeNM81TehtBlJ0r+7jQf0Ia7ooLYU7IYg56jnIEYv3ce0UZHvFdFs9cKpnwfbvP5q6cy9KzCb4SXiI7gzC+oNp6nJgUk5Y6DNomsXK802gEjCrYmusdeyMl8OizuOCmzIr4FrLG05/8pe7F2fAXxXlSNDCVXY6Hke8CgrRqmcR3bfsS4qFNMCJzgl1qVa/nIomjSjublrKb2P/AN11PAcJsu+epdDFRH6F1yN9DU5la4GqfOeNjRrR20jDoZYAuWCxa80H+h9irMLKHR2mw6LGHoge/YLo+P7IoAvbuoikFCm/6iC76Bf2vPWxeQreXe9OZCUvVd3EcjpuLDs36B7WE6f+OmJmu/CibaI5mEoujmEp2VtpSyiQKAPC7rw+aV1R1miaYsiZqLmvxgrxTLfGY6gWBFeMwHZgUMlSZ8kehssqldhoErA48
 zdpret0N
 5bD7teSjmNg6uAFLl8fp0sPJK1k/h8hFcv/BQ5ssg1XY8nufYv6MXOoshSCz/AJ4s5JCfSMbOrNyAEbErXDpuWukJJrOJvk9uv9FiIDXH9yGZRbewlhJcX5fzPpEO0nxE5ScY0LMbCaYvmpAQR8kFMVYTNXWyl1rLcABTWro35+zIiuavyq7146WAS3/vDoaVT+H/o4lr1pPQa5Oc9VFI9iCfrBcqYV90ddulqfGgmCpz6KQ8qnAWERDXOrosoFeuMciS9WLqwR+sGY89sXospL7GgrCLJoh5evwqH2chVpwUn1HBVwUW4/VIB3p5RyG6cBgCulqHaLcjF7dEmGRCz0XnY8zO2FPdNhr3a+63RskelMISK12MgOa95g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:08:03PM +0200, David Hildenbrand (Arm) wrote:
> On 9/14/26 09:30, Yeoreum Yun wrote:
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
> 
> [...]
> 
> > index e712a980851c..fd1432dc6152 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -21,6 +21,8 @@
> >  
> >  unsigned int __page_size;
> >  unsigned int __page_shift;
> > +uint64_t __pmd_psize;
> > +uint64_t __pmd_pshift;
> >  
> >  uint64_t pagemap_get_entry(int fd, char *start)
> >  {
> > @@ -161,6 +163,9 @@ uint64_t pmd_psize(void)
> >  	char buf[20];
> >  	ssize_t num_read;
> >  
> > +	if (__pmd_psize)
> > +		return __pmd_psize;
> 
> The only suboptmial thing about these functions is that we keep querying
> repeatedly in case of failure.
> 
> If it failed once, it will fail always.
> 
> You could either add a new variable for "queried" or encode it in the variables like
> 
> uint64_t __pmd_psize = -1ull;
> uint64_t __pmd_pshift = -1ull;
> 
> To then set them to 0 or the actual value after we queried.

Okay. I'll respin it with above.

Thanks.


-- 
Sincerely,
Yeoreum Yun

