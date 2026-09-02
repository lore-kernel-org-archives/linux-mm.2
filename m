Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2875DC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A87A6B00E2; Wed,  2 Sep 2026 11:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F8F6B00E5; Wed,  2 Sep 2026 11:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295F36B00E6; Wed,  2 Sep 2026 11:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6616B00E2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:16:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A474E12025E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:16:36 +0000 (UTC)
X-FDA: 85169173992.14.D044EEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DD3A140011
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:16:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXZ31SXF;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788362195;
	b=tdCyUvk6kzdNGxXf4Ozrpx0kniG7OFyFqU4e1ncbtlyGvNkjbL9/NYnC5nf+CPRKkrcokj
	0aDfy0uuwckvWK0ivIpapxt1tDlw0zQw9cjj9UDlCC0RXXNe7zd9muUuuxMLR6X8VnY9+4
	PIheMvwsdaVag9mF9+roEWlSnt+VcnE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788362195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rQ7EcvByoK4DZLWp9NFal1KQajz/7yVumEJS4KpGI0=;
	b=FduDcoCymAEesfFX9Zp66okGQIn650OieXOVZyFsB1ogYoVnZBM4D/P+GYezn6hrwAMYbN
	BnjiHfqZ09MayecTNhjDtZ0hu/NXmFqOq4F5zRo5dXHF21ModrQpJTYdkJ8K/L8PeS7T56
	EB0Bjq92mnQgtvmLWWKCOen7wy4hzIg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXZ31SXF;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0896A41632;
	Wed,  2 Sep 2026 15:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE8D1F000E9;
	Wed,  2 Sep 2026 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788362193;
	bh=+rQ7EcvByoK4DZLWp9NFal1KQajz/7yVumEJS4KpGI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oXZ31SXFQeKa7qgBq6JYStg/0PJqGBLSHHohhrgz32lgk+c/BNuaqzvv3VETRiUog
	 J6ypkPHFnqifKoYj7ko/uPMsMQt8oDeQ6tkbdn2/Idw8/3gHz812zI0Sq5PIwz5Tr0
	 qK89oRDxGrxDas/68u3QtmLXYmUVsIlXmgIt0oBtSo4/cMHq7pwdCs0F6mMY9ktWez
	 g1W5VS5jLlM2mpaBbVds1crSoi5BGSXqP4RZbNXpHr4qjTL6BQCtpKkZbbj+fEgsd0
	 pBjCEhNDU7Bu6CrdoLsCTBxUmNyiFaCoo3Y7GYFP42ghQ/9UeLsrUiuEGg8ftDgQ7j
	 cjSH4pHVNNRKA==
Date: Wed, 2 Sep 2026 16:16:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] kselftest: mm: prevent random failure of huge
 page split for khugepaged
Message-ID: <apg9nqZFSosFyg4E@gremlin>
References: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
 <20260902-fix_split-v4-1-85f03905f7b1@arm.com>
 <apg7FNLtFO3Ea5qC@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apg7FNLtFO3Ea5qC@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DD3A140011
X-Stat-Signature: csz3c14o5z4p8z7q6b8rfrzto7gqi6de
X-HE-Tag: 1788362194-888584
X-HE-Meta: U2FsdGVkX18/w+9kkbnkiCIRecgD5QY7Wwaa7Vd4Ybg1OVj22V4eFJDmN7wibcB6qYB7sMNWhfoYEXXsl7oj9kJltmXZzx6ZoUyNQqq8KrX80kRhJhNwoKfwp5lILr6p414n/KBzlUshDMistpARbcMR+MuVMzyrdmwgCHB03iwmhSI70epfHquU9W8lgW2VsjgtQoBP94iMTMzZGw+Csyon/S2qZf9M4R/aTK/ZcfdRXap96obtt4OdlIjaXXULPYZ0vBV7fusKlLdmKZF/sZtd9eYipY344DU6/m/QAxG+AJcg6SrR/HccwdDf920vwN5fREr1O0wIV4hsMfoFdCZ7uodURO9ufFl+ckLNtQi51CvpvZjaOAinj4gWegRmE2drV1hT9avhgXDbImXeC6iOf1BI7rdoSFUxxi8sarPUbR/fPhrDzFJgTFaQL49ygfUErwHAwC/+ePCYTUCvH+Sf8s1o4bmX9HHQaaq7w2s7IZdJ0nYcUjARirDRrpzNE46Ii7MDUpxRj5hdgrsYg5Mtxk1rP/gZBjxFB9ErPKbo+BvFRqVc7rO5cls51NxL3FsqJIBcJuDGVynNoP5sX6/xwUVbFM2H1/PqxN21QV156b495Mt7SNG9wPlKCx6bgPPbabtDeknxw43roetHH9Kr8sKdpglj8KtOS+xC4BMt+/Wum/gvZ+S3w0jZgqJTSATZZvp6lY8ouUQ4K7dcYlpkQF7FV7jKyfdsluFthXOgy752pn5/2Wkh+SsyQqtEfYBzm5sVLaa4MYPBgeCdAdzbXxYw17iDHvu3E+07FUeNlm7HW/HlboPoYyNCDH3LTcxNXBCbvgan3rs99fbgVsu6umIRriTU9sicHVzjmkOg7xWdTvbYXhg/TdI/wVClDcN2Ot+eByBRKn5nSGNjvwPYkfkmORtMwjdniZvysfICYXhNSxJnWH/LTXggHoTfh7Ev4t4vycuCBx/GsiF
 jvYqHaHv
 IqAKhySwnvzUfGs82kXAigig+epDAiWnr3N+iDcNG1tWC/VEKHVmuGokKguAFEFuWswgJaI3pdLgdqcJUUSy+6fzj3MchteiTFL28H1Xrljk8hcJxnBmFXFgJjL2gBcx+AmtVW0uMKWUSYEewwAXj2MFsFD5yieQLDXa8AftbIJR9WhqbtHxQAJQ9M5GvEL6zy4daWewRJ6py88WfkRZ51rrK9Hrphw7V0oS9/iM4mNimK9xkFi1Bei5JRcph7BI00hMk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 04:15:17PM +0100, Lorenzo Stoakes (ARM) wrote:

> Maybe call it disable_khugepaged() to make it explicit that's what this is doing
> rather than eliminating any THP pages in the range?
>
> > +{
>
> Maybe a comment here like:
>
> 	/*
> 	 * Disables khugepaged from collapsing THPs in range, existing THP
> 	 * pages remain.
> 	 */
>

Oh and with these changes you can delete all of the:

	/* Prevent khugepaged from collapsing the pages. */

Comments below as they will be implied by the name and explained by the comment
:)

Thanks!

> > +	if (!madvise(addr, len, MADV_NOHUGEPAGE))
> > +		return;
> > +
> > +	ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
> > +}
> > +
> >  static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
> >  {
> >  	unsigned long rss_anon_before, rss_anon_after;
> > @@ -180,6 +188,9 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
> >  	if (!rss_anon_before)
> >  		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
> >
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	madv_nohuge(one_page, len);
> > +
> >  	/* split all THPs */
> >  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
> >  		      (uint64_t)one_page + len, 0);
> > @@ -227,6 +238,9 @@ static void split_pmd_thp_to_order(int order)
> >  	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
> >  		ksft_exit_fail_msg("No THP is allocated\n");
> >
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	madv_nohuge(one_page, len);
> > +
> >  	/* split all THPs */
> >  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
> >  		(uint64_t)one_page + len, order);
> > @@ -275,6 +289,9 @@ static void split_pte_mapped_thp(void)
> >  		goto out;
> >  	}
> >
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	madv_nohuge(thp_area, thp_area_size);
> > +
> >  	/*
> >  	 * To challenge spitting code, we will mremap a single page of each
> >  	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
> > @@ -542,6 +559,8 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
> >  		ksft_test_result_skip("Pagecache folio split skipped\n");
> >  		return -2;
> >  	}
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	madv_nohuge(*addr, fd_size);
> >  	return 0;
> >  err_out_close:
> >  	close(*fd);
> >
> > --
> > 2.43.0
> >
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

