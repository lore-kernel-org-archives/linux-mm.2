Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC4EC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 14:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9E96B0096; Fri, 25 Sep 2026 10:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07ACB6B0098; Fri, 25 Sep 2026 10:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E852A6B0099; Fri, 25 Sep 2026 10:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCB236B0096
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:25:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 484991C2B2D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:25:27 +0000 (UTC)
X-FDA: 85252507494.07.1A9B591
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 62F1C20002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:25:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YSAupVJI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790346325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iX+Nzo9kBgd7HmSLMVqN85Ewz9yYlhWUCMZK/k2fmk=;
	b=vEjSawHSIcsfoP/YNDsrmKYpnCQbWNW8y5lpZT6AfkRnjzzJN0LMjheNRDYsa+Gaarqh2o
	PntamseVEyT/FF8rHsoIeplNiNm4wO8gv9qwvi/e2vBz3bzoOhj6JWOHQPO20CglXPAdHt
	NKDyd0U/WnmcYvupGVlA4eX3Vgu4Npg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YSAupVJI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790346325;
	b=5ewc29q3hbmvTeZGm9h5EUD5vWQv0aHs8E4pR8Mg0k0S2suahqoqFjhoL2hFa2xC6r0y6s
	Tou9PFgRfBs7DeMMKOO6ZQAfl6l50pEauW6KRaXJf7ptvUQIMl+YZoI7lqqjip5onxCW6L
	TEqKX+HDg+U9DwtEq9rj+FC+y7vz4fY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD6522F;
	Fri, 25 Sep 2026 07:25:20 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 788073F85F;
	Fri, 25 Sep 2026 07:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790346324; bh=El1QITU3qpLvvUdEiQ9fxzYfH725rKJWjGdoB0s8u5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YSAupVJIBvAx9uHHYFskgna4GCDoxpLp26nfaAHBNg0Wc6F8sbHLSJ8Z1TFZBejl9
	 cmoy8SzPoCKDQG/qekljmEOJIVI9g/t75g7WV67KOLfA5/nerh7uLHWX8a730ZtK4Y
	 wwnWL5xCBqeR1PyB2LpdN5xTkawRCSZbgMzuIp9c=
Date: Fri, 25 Sep 2026 15:25:19 +0100
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
Subject: Re: [PATCH v8 1/4] kselftest: mm: prevent random failure of huge
 page split for khugepaged
Message-ID: <araET4RRCM2PxqaW@e129823.arm.com>
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-1-cba7359d882a@arm.com>
 <07f94688-55ed-407a-a11a-78a4feedf5e2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07f94688-55ed-407a-a11a-78a4feedf5e2@arm.com>
X-Stat-Signature: 1kyqgxygugxdsrydyjy9h5bfagrxxw71
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 62F1C20002
X-HE-Tag: 1790346325-411288
X-HE-Meta: U2FsdGVkX19jIO6ad794wZ2/HWaMbPoda6bNU5DImKxei1DdXepngAcwsOY20aLufb9225q//GT+yyljgi/U34jv5gmR26Y0fJUr7Qrs0O2hREE8d0+MiQc6hBcvux93IJnvSyYcwr7Y8+Xf1Soy/ykdJiaYzuJgoQYyDucLv4FURIWb67XUN7gnhpqUsIcMZG4ojA614Bfq0gFjz8LQWSkgYZ5NhsgdRXOzTHYsc7cZ46fnjqrPt40JyPK9Ghi28oSYqQ85CIwxKnWPgKpLl7otZ+njIdmGLO/7r1hHtWYc/q0GLDImnN5RpMHEfVvP94AW3j77PJlaXgf14i7BJNo33mthMMzj6oJvbPI5ZKIqyVbJ5Uscu/roBtqnKRf5Jbla++DVIhtlF6mfuUT/Sxte+hOjiRkP1w214sOtaF+vyDya+chBiG3Fh0JRQzf//FQb/9DUXmBUxW8mYni5VnCDdEZS5CEm528GgiXRmxA1ZN1AudGfy7HgKN04oIGJk/bIdpp1KsYFd9ICcH2hXlrFDrOvektOqkhi7bDKLW66ipKAm45wbBsgfB9D9VwfjsrgXTejHqBy0+/lsfFss+lV7uf6OHvP0esAR6Z7vxtPSC/T67K/2FatQFeN8uCaEMPYPD6K9JI9H9UDMW5nXhnaxYNvei/I3JBHCACBDlL5XiViKV916qHvs9PYA3TzFdWQmWtFc+M3i8JG0rAkzYpflbA3POylmw6K4RQqU+pWGkdTZBP8THPl1QaYUB896L30VY3w8Sp+vaVgCWzA3ThjHmfVjhPGOAx21q0suXShI6/jjrQOH3L+vAG8pLBD9/p3JLqQp0xAlWO2OC0yZ6DySTi0nPKPKr/S27rpVGT7N1kpfBRsguAQcJUrr3VmhL8MYjwpqPZOKWOOFrpdJL3i7UdTewndu/pHZ6TLQUg9skGk2/k/MIbIt3ArOTIqIto/kR/1qpi3H3/QIhr
 beQPdtrx
 flLfaF7iO32/uxnZ0eD9IJzGKep6EtHfzf1HLXsL7PWG6m1t6KL9s5j3yKmtCZ4QxDcxLHe2rQ2qGiF0cNc2Pmwdodc9s3vF4g0aDvIElYlk4Vm/IIBy5io9ELKxEEdGIjfbnikklVTAYQhEGHG0NBQnIGwGtcxSONZWcqzRHkcLAi8d7FIArXJzImy284gWa+AFy3NBbcq5bFf/2Jqy2xb8eWkOponn1huscLds1w+iMNCAwK0G3p4WVJvFevtSQ7qy7tf9UGcQG6uV3e6cUAxkg2YV/fdlcIitKiU3Pw9+A9SzchhhMd88Bt3tSSOFL5E4VxVCZWGmB8i61NSFDpm3XDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> 
> On 9/25/26 12:41 AM, Yeoreum Yun wrote:
> > There're some random failure for split_huge_page_test when khugepaged
> > collapses pages into pmd again which had split by the test.
> > 
> > Prevent the khugepaged's collapses for split page by setting the
> > mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
> > 
> > Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> > Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/split_huge_page_test.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > index c5d96a4b1db3..ef4058662b91 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -108,6 +108,18 @@ static char *allocate_zero_filled_hugepage(size_t len)
> >  	return result;
> >  }
> >  
> > +static void disable_khugepaged(void *addr, size_t len)
> > +{
> > +	/*
> > +	 * Disables khugepaged from collapsing THPs in range, existing THP
> 
> Should it be "collapsing pages in range into THPs" instead?

That would be clear. I'll change with it.

> 
> > +	 * pages remain.
> > +	 */
> > +	if (!madvise(addr, len, MADV_NOHUGEPAGE))
> > +		return;
> > +
> > +	ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
> 
> I feel a ksft_exit_fail_perror() would be better here, since it will
> automatically print strerror(errno) as well. Still, it is not something
> that should require a respin of its own, so if you plan to respin for
> some other changes, you might fold these changes in as well.

Yeap. I'll change it with _perror.

> 
> Rest looks good, so:
> 
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> 
> > +}
> > +
> >  static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
> >  {
> >  	unsigned long rss_anon_before, rss_anon_after;
> > @@ -120,6 +132,8 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
> >  	if (!rss_anon_before)
> >  		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
> >  
> > +	disable_khugepaged(one_page, len);
> > +
> >  	/* split all THPs */
> >  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
> >  		      (uint64_t)one_page + len, 0);
> > @@ -167,6 +181,8 @@ static void split_pmd_thp_to_order(int order)
> >  	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
> >  		ksft_exit_fail_msg("No THP is allocated\n");
> >  
> > +	disable_khugepaged(one_page, len);
> > +
> >  	/* split all THPs */
> >  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
> >  		(uint64_t)one_page + len, order);
> > @@ -215,6 +231,8 @@ static void split_pte_mapped_thp(void)
> >  		goto out;
> >  	}
> >  
> > +	disable_khugepaged(thp_area, thp_area_size);
> > +
> >  	/*
> >  	 * To challenge spitting code, we will mremap a single page of each
> >  	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
> > @@ -482,6 +500,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
> >  		ksft_test_result_skip("Pagecache folio split skipped\n");
> >  		return -2;
> >  	}
> > +	disable_khugepaged(*addr, fd_size);
> >  	return 0;
> >  err_out_close:
> >  	close(*fd);
> > 
> 

-- 
Sincerely,
Yeoreum Yun

