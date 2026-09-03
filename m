Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77A2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18646B00C4; Thu,  3 Sep 2026 07:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEFBB6B00C5; Thu,  3 Sep 2026 07:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05B16B00C6; Thu,  3 Sep 2026 07:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9526B00C4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B1631204E1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:41:01 +0000 (UTC)
X-FDA: 85172259522.26.19D9C84
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C78914000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:40:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DWz7o0TY;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788435659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1q2gO8xl3Q6DdOERvb9Z9jUNka0LXFKY+Uo80RiAnno=;
	b=LYrsGEeDvYqMZDugIr++6syyIDTFqctiw3WKKI5iyoS7qOnkoXLkBfvgl9EeujkGHoi7gh
	5Iawbjxsb5FzXccWcxOORoSnJtlqRYVWrZnWf6sj5RNeSloMyhwQAD2pGzLax+vud8u2f8
	3wFm4dIN2PqU1q8tjSmOoSHjNFOjZ38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788435659;
	b=UcG4ilyRiSVCzgWRJZ/6f9Lc4dMa94dqnbsm+PnGF/PtPRG4F8g8gq/ai1GO5wm50BK1yy
	GXnBTK17jYzQlVNN4HiQkCGJsGjzQsWCh1nHJfu02cJts6IcMclQ1oN4Wz9xFRcmdGD0RO
	Ez58/Z0yRsW8CpLkr7cI31fcnI17D9A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DWz7o0TY;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36EB91596;
	Thu,  3 Sep 2026 04:40:54 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA8B03F7D8;
	Thu,  3 Sep 2026 04:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788435658; bh=EMBeTImvJnNZfdUizGQ85PK2JMB9YX9D70xQZ2VPWYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DWz7o0TYxCiqmCVFI4i95OMzzFJELJIhGrqsXSzffTdbn99riEXH11OBH5bM5dXGY
	 /4QhFYo8PQSuCjouR+QtfCj5xKO+UmHxc0Y0wXH3xI/3jSVTtJLb8Nbsfl3yYRR9HQ
	 cESHc3Cx+1uXiHcsWRLhZ+AncOaZma93SrnFR9G4=
Date: Thu, 3 Sep 2026 12:40:52 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Message-ID: <aplcxIN5-9KANi0O@e129823.arm.com>
References: <20260902175611.1241118-1-yeoreum.yun@arm.com>
 <7108538a-5581-4586-bc12-224683d0c25e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7108538a-5581-4586-bc12-224683d0c25e@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0C78914000C
X-Stat-Signature: dwirz8qggsftucup96og6ha11aidnqot
X-HE-Tag: 1788435658-538186
X-HE-Meta: U2FsdGVkX18pp9Luaw4DhsmpXyTcTdrCYojrrizBccy9BV0fJ81BfP/qtOEe9dY02/1DUSmsnBQsjm0RECMTRtJKOhwHKLpWNxKKZPvIx6fj1ZidA01+mVLyztw1jh/de7LBVDIFZVePOrjnbejSzx5Yzd2Df73t/LDLBx+//EQ33eP5D27UruIwndMqxnXqVPGFAuXE4444qqzQLfVfvjYPdnTV8vSprXV2T+0JX6uS9FGtzredcBXWc4gUW50COh4LGiJHeaV8Sjcj+RDH3pGpwcsmhOOQ3h/RuPw2QR4b8nha0CddoYTJOTzOb1GKvSg8rh70fbYHkFcbPB7FIbT4IY9p/qPZVNTiQh0HFRajn7IdLJa5slAzcGBvW/A73dIU42dSn6w9+6Ukr1zm1DOI2IiZYxZl1hD5BGpKuso/7hHKUF3YLoTiigXO13+5qGqy9nFArcu6UV3h4llT6sL9k8T8ydfZZijsvWclnQAiAS4eSf2fqfonKXSZqmgCrrZWTs9eP/breDC1o+anJY+1SZJsW4Tj1q2vRuPyuUit3Xa9rFBsE4PyOs3TG/LZ5/AUn2gTtbDLgUvTJ94KIjA9bU2VwmAdmhYkGtuKYp+ozYqMDo1IpxGhZq1LN88g4H5Tmktdw43D4DBm1hUyY+lH/JhSjqnrjbJsKQloqbfzMDzYGuow37Y6MMY8Syd87I9Lxk0KG3BhCr4BxTqW7XM/haJdl06hbTafr1mHa/geHqaKuoL/9Oa+O1QqgY1qvpYuJrfOYXc6jTd2IwxyBkE4n8u2F59Bg7KpBriGs/EPVw2VVsFzRmtMw1GIsdJBVjO1uN462ChWWonwM19lwG/tl+P4djdIuV/BP9Yd2J2UE62nCz0swLRUwYsrbKMHAP6LXy9KtyNHkWdOVviw3jYTE0l9MS4HUsm+Zvaa8BmHdmrQHJMhAKoc5TljSqFVN+utYJtW/c+ioZBb7ra
 UI/GzX8G
 wpUOpuhhhh0Fw/+BwNxhJCsjLTfskPZsFjwr5cE6hZQj4NiEVvp1AI+K4d73jL9Lr783ZNwcjIur91xPZPmHZbi6YPomDCExk2Bjvbo/P2oln8fpEcH9fE6PZH3ffOQ0Atk7lOn4DrB47Lq9yQaAdeiqW4NQ8n4a5Mi+nZOf0cKG5T6au8E9f0Rh2cD903H2M2LRZYkGDAKs5ihOBogyVcNC76Ch+EtdMVE/2/p0Sz9sDmAdfxI+BRXO/ByALVMY2rHC1aO/YDLwzl8fj09c0OjQYLAIQp3oXoIHiyOcX9CAACx7jDvRervobNsrUj59y6+m9rkmaAJzMc1xlotXQGedd9d/cEslf3Wnmt+lDjOMl4eEIF+PWoWhWPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

> Hi Yeoreum!
> 
> On 9/2/26 11:26 PM, Yeoreum Yun wrote:
> > HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> > When this macro is used in some test, test result would be strange in
> > the system where PAGE_SIZE is more than 4KB.
> > 
> > Here is example with transhuge-stress test with 16KB PAGE_SIZE:
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
> > Remove the HPAGE_SIZE and HPAGE_SHIFT macro. and introduce hpshift()
> > helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-exist
> 
> Nit : pre-existing

Sorry for typo ;)

> 
> > helper, read_pmd_pagesize().
> > > Also, do KSM_MERGE_TIME_HUGE_PAGES test with size of 512 MiB which
> > is the LCD pmd_size among 4KB, 16KB and 64KB page_size.
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
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 4821a3563036..4332f8fb2104 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -21,6 +21,8 @@
> >  
> >  unsigned int __page_size;
> >  unsigned int __page_shift;
> > +uint64_t __hpage_size;
> > +uint64_t __hpage_shift;
> 
> I was wondering, would it make more sense to call these __pmd_pagesize
> and __pmd_shift instead?
> 
> hpage_size is used at places for mTHPs of arbitrary sizes and these
> values come from read_pmd_pagesize(). So calling __hpage_size as the PMD
> size seems a bit weird. Also, there is already a pmd_pagesize variable
> in vm_util.c, so I feel the PMD specific names would be more consistent.

That seems better. Thanks!

-- 
Sincerely,
Yeoreum Yun

