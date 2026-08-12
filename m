Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0452C5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 02:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ADA86B008A; Tue, 11 Aug 2026 22:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DFA6B0092; Tue, 11 Aug 2026 22:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FD46B0093; Tue, 11 Aug 2026 22:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 384BE6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:33:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABD08C02D3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:33:41 +0000 (UTC)
X-FDA: 85091046642.10.E684D3F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5599100002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:33:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gm7GedII;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786502020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOUvcMpOD7o4bM448gu1WuXnyCVTQbd3eVocfGzWRWs=;
	b=tLmu2j1s2s8evuDXn4wsNrRBxaySu5Yp1vQtn9yHib8qOZQD6GtCyxsFw9PpWZmpIy6J+w
	CXOkvcXZTt8KrPBz4ObDxQVWBHMnaIYIOjDwIA3P6uoEk9N2VP3ao6sZb3A6JZaLILPumr
	eGl1+n0eHwsB341SYC+y8oBpyHzEesE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gm7GedII;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786502020;
	b=hSSKWZTo+1Q5ascDWzhQHSkhXngxZGxbVkugx6dg6mGRQloCKBZGr7CmY6iM/rFRkIxgWf
	y6UKe1sxSXmRC0nYn3x5h5oxc2VKg2hLIvfvmMFz3hcY+mrZ2JhdR7RULCXikNjO9c8NLs
	lQPTktjwrASyCXYLvj3EldzGz6KuluE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 826121516;
	Tue, 11 Aug 2026 19:33:33 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C591E3F86F;
	Tue, 11 Aug 2026 19:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786502017; bh=I1/vSJ9Qb76ZtUvTgRy1ooNxWqENw3nHX0V5zhE22bY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gm7GedIIorUPLyBhPS5niPq93LLVW9k5r2o7AlI1nh61cX3lx3MAKeWKcLIi+UvjN
	 BBUqgn/lI8amZCy1Sr65v8R2dQdUU5qqNYIn7npIAZww206VT0z2W8yu8ZODZsqbYe
	 snbDPrvByhfGPQW1mF3X4RcYLevGcg2uTRARDVLY=
Date: Wed, 12 Aug 2026 08:03:34 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wilson Felipe Pereira <wfelipe@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip
 test_no_kmem_bypass if debugfs is unavailable
Message-ID: <253tvq2rhxl4yedcacabve4x333rajpcqvqwlot56ddtvpgrl5@5ifjgjkfgza5>
References: <20260811051434.3805648-1-wfelipe@google.com>
 <20260811190611.c72f19ada3912791a81a7a90@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811190611.c72f19ada3912791a81a7a90@linux-foundation.org>
X-Stat-Signature: bdx5rnnus6euy4hxck8iywbuzxjsckcg
X-Rspamd-Queue-Id: A5599100002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786502019-310215
X-HE-Meta: U2FsdGVkX18xiIzHHMF05vC2bgWBbPOrknYdyXxSOiDu7aIRVKpZWsG16qIdKj7YOuQUaPulXa7usdZcIAvEMLRtcFOpDrAEyBsRsLAuKIHIlCxNhIZ55xlcHEKFfUkGTnkZKdThxDu9eNQTLqaeefXOTVsuXJzDZ9jCwH7JGRY/nzixljL0PMCqQobpzSSg/bbWA69j3UB2ZkioQZjkNkSm09cOpwKv5SR5Eeq4A0toLO8vPaHzzFO6kkSmSQSbldFt2B627kIwphoi0oBkNpi1oYBliINjQk9JZPg4xxpdmLo8uog5WqsxBL5kMNT30zaMdZOYZIhgTlhH3NTk155kLdBYUhHwIpglToupgTRgZh/K4ie0+zXX8MJGVkJRKpK43oEe9z/KhBZ19GeZUIq/8BwFPmYO5K8LcZvxb9+5XexDv4/QiP1J1mvJLmnhHrLAG6UlnD96rDN1EV3s6anSMkWh6NrpMT6nFM4Cta2GUxPXdUa28MbgcFDb/cwakMeiqPcG8WYmXY+rpX7m7clx1R7FDVwP+eU3Kz4aEBzGRCNBOxrLbWMkmZOYe3OOs2Ilvz6bWrU+0FiluXmMIa4NEfEDzYDBVKNoWE6YhqdEWAW9UMDzpFrKFzqzYctRtmijuyjw9PxHU8M49yCZQHhkzLdxlRWutdpdznec6BcaZOBeHe4OEVCbg6qAnzjAqXC4UHMEKE31UDtIP5N88Nl62/b8cVMJGLkSp4toPO1l9oPtAdtsjH/6vgxaXSXM+eUxmMLWxxEWeT4b+ruaIcHOWPUJSYWJVrBQHFvcYIOYG2D59QcdVlGTPIvv8iOO6IKtdWlVJZbXxKZ4t44lQxdT/eNHPToI9x847Hm7qWnTwUGi8YYeaMs/BkzvT0qn8Gl1/4BwClrZYdk153Cq08q4T0hEWPQ9XfTfsL0i0ULBqjwBC7faONk8FE8iuL5T0IXtJHsJV6bGIDgw+PH
 H5oNaPn5
 wlF2Sv9vVNbHkRXx1pcMwSgqI5fEsCWrBbwIXhLpoZaegM8qbWdFVxsqoWYRB2IsFhlRrmOH+1XJ2T1qfw/E+lR6XctibmwfUz/yCOn2RhZrAjlxlQ+1traW5aNF+0ywYJmNz+H80AMUkbweJf3lZxU+HUwWaw1rtnHK4pDmIpRPi5+jOB+WHleVVUmUVpRDoW+fNOOh+LrI6c020LLHuNu+tejfTP17RXcJhD4GCkU9btsn9F9OlC2Rrh7nE7++z6SSDrINMF5juOzSCym0dbAW8/cXqkcu2jEWY8wa7tIYiCDlpRjUi5A8yxdxBKXwYTyQsGoK2xyrOdNqNBg4ojb+6hubZ7flH85ayQ1NfXZ4nBdQft354LEUe2MKEP7MKbmQXW6qcirvRUuVRv2FJp0Ya6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 07:06:11PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2026 05:14:11 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:
> 
> > test_no_kmem_bypass() needs to read
> > /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> > verify that compressed pages are charged to the memcg.
> > 
> > When running in an environment where debugfs is not mounted or
> > CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> > loop to terminate early and report a false negative (KSFT_FAIL).
> > 
> > Selftests should not fail if debugfs is unavailable, and it should print
> > a message when it is skipped.
> > 
> > While I'm here, also add a warning message if the test is being skipped
> > due to totalram size and make the check for totalram more readable.
> > 
> > ...
> >
> > --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> > +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> >
> > ...
> >
> > @@ -570,8 +571,16 @@ static int test_no_kmem_bypass(const char *root)
> >  	/* Read sys info and compute test values accordingly */
> >  	if (sysinfo(&sys_info) != 0)
> >  		return KSFT_FAIL;
> > -	if (sys_info.totalram > 5000000000)
> > +	if (sys_info.totalram > GB(4)) {
> > +		ksft_print_msg(
> > +			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
> > +			(double)sys_info.totalram / GB(1));
> >  		return KSFT_SKIP;
> > +	}
> > +	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> > +		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> 
> Super nittynit: "mount debugfs at /sys/kernel/debug" sounds like a
> progress message.  "I just mounted debugfs at ...".  I think the below is
> more clear?
> 
> --- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
> +++ a/tools/testing/selftests/cgroup/test_zswap.c
> @@ -578,7 +578,7 @@ static int test_no_kmem_bypass(const cha
>  		return KSFT_SKIP;
>  	}
>  	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> -		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> +		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");

This is definitely more accurate.

>  		return KSFT_SKIP;
>  	}
>  	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
> _
> 

I assume you would change this while applying the patch.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

