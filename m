Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A4AFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15936B0088; Thu, 30 Apr 2026 11:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EB86B008A; Thu, 30 Apr 2026 11:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966DC6B008C; Thu, 30 Apr 2026 11:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82FF66B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:04:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C301BA7078
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:36:42 +0000 (UTC)
X-FDA: 84715473444.27.191E3F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F2D4C2000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:36:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=By1fd0Wq;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777559801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXcXzt8QrrvHb21Qwt0dDewieYK9uwdZ7cQ4m73F2gY=;
	b=eMLnN0bIh/ofo1LhyixFu6CWpPzFoksgU7VH1JcEqnxoqdLqSeb+OTbJWQAJb73FxbR+pL
	xsBvDANCZv/a0eFqoTBRl1nkUB6tKGUQuarjRpkgWKzz0B78PuHSAkqY9kwnXBF18VeKJ1
	IQOtKZ1MPJa0nh55ZXiTj6Y3tW9MePY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=By1fd0Wq;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777559801; a=rsa-sha256;
	cv=none;
	b=i0hnkIjtRCtsAa823tSLlv1twdowTnVAOvNhPXn75VmXSL6vS/NGvOeo56dn+zmcAGl8EN
	n0v05U9HyI/JoHUL5rfiL/2Jofq8/qK16GvZdVcPmATcGNeS3C0S05EIqtbrNQCPkZ9MVH
	UPwZxZpOYs7PWvzck3GBTKD+cZVdU/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D39534017E;
	Thu, 30 Apr 2026 14:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901BBC2BCB3;
	Thu, 30 Apr 2026 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777559799;
	bh=as939qs8wfsBTGwXp3ewh6inHqVYfZy+nWQOmM5zTpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=By1fd0Wq3wrNKuKqgvh96v2vhcfbQj3bGDgXXhGVNEIz0O0ePdbmHtVsxWnY21sT3
	 Z7YVI17zupg5zfDfoNOYxv+96OeWMX1JcJlfxbsyhn8oYqssyCFk4zPMk+rdKVva1S
	 9gc+XYWnuaHtRzS8gq+3AmQ8fZ1TBEs9TXJmDzdQgjjVaqdOtXSvcsETxUPAN56y3R
	 hZkdz4ukPN1bdqH+Hy6MssE4QND7B2SYyfxtsG4IneoJocwAJtokbNITRzRC/CdD+J
	 7EBRWBEYslY6iitGnu1nnQX/xH6xRYCgeyuozkC/6PZcwvNJuKWJfZ5eVnnuZYY5Uq
	 4TXElpxlUlj2Q==
Date: Thu, 30 Apr 2026 16:36:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 19/54] selftests/mm: uffd-unit-tests: use kselftest
 framework
Message-ID: <afNo6xaWtlTofW4w@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-20-rppt@kernel.org>
 <89382a73-4b9f-422a-acf2-02f77e5bf547@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89382a73-4b9f-422a-acf2-02f77e5bf547@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2D4C2000E
X-Stat-Signature: 9qmd5x9ae1z4rxieiy1ht9jyx38dsd65
X-HE-Tag: 1777559800-71665
X-HE-Meta: U2FsdGVkX1/qgoJ3E4bpZro24XRBaUX6R7LeGYEouk3mNeS4KaiBfsj4QQ8Y5Q8J7isHTYNShorbiIzviotKsy430qEyADwFHo45/KmenZ0t7s+vxp9B7Cxr9FK5kJ9P/iZskuEGgWgDI3nm4NupAC+Dc3iRJoqtCBmgKDvCWn/P/qo6NgZcGOnP1Gnjv4zdDcAmizX/hsIBRT/a5w8E06F6ZQXrZ3rWugJuAKubvbaec6oldR5A6WJ2q5nfdMWfm4QREgRlc8jQT/tdBlQhAcIuj0nI5sEzdBCqIxwmu8E6ojz6hFuEy9GoReoKGRmFvFyT2EPgCldLV3NRuVYn+lR4sUwG89RqlLs/sSm9sbCWg9xYMglBIOPGyW0s2waUefPxzB6T1od86SQwMZyyP8XbLBFwKl5UAV7VMgz3du3K5hl9jdHsfoCsMszkZ95xnDjDIUT98CAi3DJ7TCjzgOri2q4XiCS35xTSZJzZHUoudIKOnnOe6tXtUbHjHok+aej/7Tirzf2vxvpl0agO6ueJvlYW8MeDJg54uvDh3jyqb87XjXKHbJKCAUIJWPBG/5PxSVmNAPuYioTg8GDb98QuzXnPRFHmBL6PqQBo7oDBnV0WptTCZQutCViFInCciVEWfnXnpW//OgCTXy4W1EfzerYKRLcDXw64Mvu+SyYF+3cLR/nvbe4+Wo8zn86gdpMCDuOszdCRQz+hypfl57uvgpw9+qgi7jotldlrEk9axQMoNPiT/cuRVyGbiQrhX9RPBLDgdX0910rjiM0LlbF7VvXaVXNgMLliTndaexFxrbVaqLA4m0wxbXF7nSRfgTV9HKGePbmylwE75LjEppNt7JieOK/M/oDsAscGn86DXPN7SKacIrAAFu9N6wsC+4KyC2l5bNQSY9vA/RzCAK7IhRsvajM0YGCGYeOorex2U4HHmiloQQhF00vTQUuS6bTxzCrEnlkswMuxTpe
 N2W6Wt0u
 9YHIf51ir2ndmGpaQOzZgR5U2OaLxUcYBAD6H4ZdXbUGHHGwY+QvtRqO1n5QxjQljTEDmOssO+TIQP5NoEk1fn0F3yk7LrIuzygVuEzl4SrpciiGyvGPUaR93eCiJuAEUk7XKLVn5Aq11rDZVIdwo4j5eP8cWB7wDXVoreRzRTfuSZnkWul+KjBgavCyz3Wbch+G9L0zDKGZZkq1uSpYXynj7GNzP2HiSDOhdOyEN+aY52IBCtYoqlDF2zTFU4quM2ygY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

On Wed, Apr 29, 2026 at 06:43:53PM +0530, Sarthak Sharma wrote:
> On 4/29/26 2:12 AM, Mike Rapoport wrote:
> > +
> > +	ksft_print_header();
> > +	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
> > +
> > +	if (!test_filter) {
> >  		has_uffd = test_uffd_api(false);
> >  		has_uffd |= test_uffd_api(true);
> >  
> > -		if (!has_uffd) {
> > -			printf("Userfaultfd not supported or unprivileged, skip all tests\n");
> > -			exit(KSFT_SKIP);
> > -		}
> > +		if (!has_uffd)
> > +			ksft_exit_skip("Userfaultfd not supported or unprivileged\n");
> 
> If has_uffd is 0, two test outputs from test_uffd_api() are being
> printed and the third output is from the ksft_exit_skip(). Since we have
> declared the ksft plan before this, we are getting the following
> diagnostic line:
> 
> # Planned tests != run tests (67 != 3)
> 
> If we remove this if (!has_uffd) check, still all the tests are
> individually being skipped with a "feature missing" message and the
> planned tests are being equal to the run tests. So do we really need
> this check or can this be skipped?

Apparently not :)

-- 
Sincerely yours,
Mike.

