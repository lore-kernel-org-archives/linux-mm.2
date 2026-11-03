Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A7F606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tm2Ms7AR
Received: by kanga.kvack.org (Postfix)
	id 704C66B05B2; Tue,  3 Nov 2026 14:05:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5366B05B3; Tue,  3 Nov 2026 14:05:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC176B05B4; Tue,  3 Nov 2026 14:05:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6C66B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:05:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8F8F160517
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:05:55 +0000 (UTC)
X-FDA: 85394737470.17.36FF3AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46BFBA000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:05:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tm2Ms7AR;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793732754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HeJNsa6cJ6QNpsjilhgs8PG10NtpxUmbMSyIykHPOow=;
	b=JucB7byH2eel28KyvOU/pffa6e8Axbl79bvVtlk4J4t6c8ew89k83NC4V6an3Em/nEbqPv
	hfh+2ch1cECL+g42OBHwAgSfvpx5H6Q9eLcQhN9m2K0Tm/V08vAryljEXQEapudYEYirB2
	XR0K2wt9YhNOmFw+EVFOkHPcWgDKlBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793732754;
	b=auFIiU8UELHRa64PomoHSlbovVDTZYaRpZV7p1LD6LZKT7e90Gj8X4sjmU/3t3ATtvaE7D
	UKybNXF004x3HpVbs/vUN01IlBiFuK6MRTC9m0W/GxoKvnHzbFUTldIyFJ+k6IKPAWbj/k
	PrI478uKHMu33BqVQ19RrKhuWsgE+MI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tm2Ms7AR;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C54B76020A;
	Tue,  3 Nov 2026 19:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4671F000C1;
	Tue,  3 Nov 2026 19:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793732753;
	bh=HeJNsa6cJ6QNpsjilhgs8PG10NtpxUmbMSyIykHPOow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tm2Ms7ARRWfmr8ayv6N+1djm7L5xFdCVSz8tSi2mTXHAowcCDGbvK/lDyvmEqybsd
	 YfDAVqXOvWa4BDymDjqjfclHOqtSr8ymzmt/0+WPxd2iF7sJ7/p3FXEjFN8WVgKilX
	 i5Iiv2pQfvys9YvlFvxuZ1GCEyDMpBJqr8P3hSl17H4Frg1xvFViFFe0dCySAvB50L
	 oUnoQyhIS1hdArWYWvLM8NYL+liPREMfvy6as1ttb2ndB2mzCduEvcwdrzYk21GksW
	 gjlNL7ArZ32XovBSVOh8Ce4gWgYE1fqxdDx77occRhf9rMxbebHhcEQV9rZYSugPPx
	 4RNHVFB4PRPsA==
Date: Tue, 3 Nov 2026 21:05:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Umang Pokhriyal <umangpokhriyall@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/mm: test a uffd write-protect range with
 an unregistered page
Message-ID: <auowiuwkogQ0-g7V@kernel.org>
References: <20261102103621.156928-1-umangpokhriyall@gmail.com>
 <20261102103621.156928-3-umangpokhriyall@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102103621.156928-3-umangpokhriyall@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 46BFBA000E
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sor99mbcfya35monsku3qm35z97mpibu
X-Rspam-User: 
X-HE-Tag: 1793732754-49993
X-HE-Meta: U2FsdGVkX1/s3t2nAuxjXxHoUTwawFgw4C3hzkoLuIdVLPbtWCgziczDM4VHoihNaFKHpJB2epHDGXGBDY1O4wJ70GDoUCklyHtx3t1k516A+0v/P79akQ8rrkQmqhA2PJpxTLvrvqf1vIl5m8KohLzzttU/eY4QfeIMO8TR71MfcWVZzrsWu0i47ZKhsXoEYKRkYq9dP+CqYhUXRT4GOdaXdgB4fRZhBDHvbKSjxxuwqcy8BdIJPeBqxAGdXUDR0D+oS3J2zeH9KUX3B3VAB6ojepiiXdyNy8xiJAndncNDUg9YwO0TwFKd/ldl/tIt0C0gngHeqtUQlhcFq3u2LbKcq7Hw5KWH1Bg/spM1BM5MUlgV10n1at0ezOZG2f0AM725SGrwXuBmfR2nuzAbsKHWZ5NxfKJpeYr3hM/kM9lHFlS/Q/spJotHbiLBss0AtCmuOUI+liuhnH2tjTTe4XAk7QlHSf1+JkhumLT+nXRyjnDEaW+sIK/r8Ld22XwJ/7SV6P7DQ9TevftKgYmnUYg1twtQnVXAdSkqN+84eUZULkvtF75nSQzF5Lq6aTapmtmW9OPgcZMmgpD81QYk1y0BDdgdVpxzvT3nE+5r/88TWZbrzmX9I1JJxN2ekPxFzYTlZoEFOvkEdl9oy0GwlCYudgjMR1JXXvF5P5eymFFUM1BW6+10tLwaK9AZrlcSaV3VkUtucqgaOZt2Om89ydV/CvO3k7sKfMfapwehIC4pkhJ9YcQ2HcG7UdL3GExJnb/rjce79awpilOiaG55T3RzLF3ueLD8AzcW+oMAw3zuSwOEVXQyRIUhKLz94C4tKzzhjwbNDuqCV0nc3ucg/8ghuUYembwzuHOU91M74iTgmJzTyDWF1l7r+ocM+Iffar3qLXTk2W2Sfojkauuo8amA6C1un8coPCml16NsuYvyBycGGVCD+Cam7KN3/9E1RcIydnDplX62mRU31/A
 7NRN877k
 tQfg2jU+kLBnb8zBvxZ99jTthYN1W5Xb6a5eG6OSgd5FZyaEqVl4CB3ap+E36ezQDTZdWouy2wu9blx8S/2uXoKStHluw2I2qZYk4HQAUrMOKJDUxrZsdjKkB6WzcgQUoDuRy8ZGP0sRmUrvSv42KigBdUhah6gccFgVR4jBG+EjgHUmQ12KOhy2QJTU0iZG3uerRSEBBwNEJ47MMBM+V0k79Y/2K6AEkosxgsp5Dvp90l8GQ/iFEz9wcI1IJcDTMkFbapjhz00Cj+gR9yGQsH+qSvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Umang,

On Mon, Nov 02, 2026 at 04:06:21PM +0530, Umang Pokhriyal wrote:
> Register only the first of two pages and check that UFFDIO_WRITEPROTECT
> over both pages fails with ENOENT without changing the first page, when
> protecting and when unprotecting.

I don't think it's worth keeping the test for a regression we already
fixed.
 
> Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 56 ++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 298609544..57e442fd2 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -375,6 +375,56 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
>  	uffd_test_pass();
>  }
>  
> +/*
> + * UFFDIO_WRITEPROTECT over a range whose second page is not registered must
> + * fail without changing the first page, in both directions.
> + */
> +static void uffd_wp_partial_range_test(uffd_global_test_opts_t *gopts,
> +				       uffd_test_args_t *args)
> +{
> +	struct uffdio_writeprotect prms = {
> +		.range.start = (uint64_t)gopts->area_dst,
> +		.range.len = 2 * gopts->page_size,
> +	};
> +	uint64_t value;
> +	int pagemap_fd;
> +
> +	/* Only the first page is registered; the second is a separate VMA */
> +	if (uffd_register(gopts->uffd, gopts->area_dst, gopts->page_size,
> +			  false, true, false))
> +		err("register failed");
> +
> +	pagemap_fd = pagemap_open();
> +	*gopts->area_dst = 1;
> +
> +	prms.mode = UFFDIO_WRITEPROTECT_MODE_WP;
> +	if (!ioctl(gopts->uffd, UFFDIO_WRITEPROTECT, &prms) || errno != ENOENT) {
> +		uffd_test_fail("protect over an unregistered page did not fail with ENOENT");
> +		goto out;
> +	}
> +	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
> +	if (value & PM_UFFD_WP) {
> +		uffd_test_fail("failed protect changed the first page");
> +		goto out;
> +	}
> +
> +	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
> +	prms.mode = 0;
> +	if (!ioctl(gopts->uffd, UFFDIO_WRITEPROTECT, &prms) || errno != ENOENT) {
> +		uffd_test_fail("unprotect over an unregistered page did not fail with ENOENT");
> +		goto out;
> +	}
> +	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
> +	if (!(value & PM_UFFD_WP)) {
> +		uffd_test_fail("failed unprotect changed the first page");
> +		goto out;
> +	}
> +
> +	uffd_test_pass();
> +out:
> +	close(pagemap_fd);
> +}
> +
>  static void uffd_wp_fork_test_common(uffd_global_test_opts_t *gopts, uffd_test_args_t *args,
>  				     bool with_event)
>  {
> @@ -2403,6 +2453,12 @@ uffd_test_case_t uffd_tests[] = {
>  		.uffd_feature_required =
>  		UFFD_FEATURE_PAGEFAULT_FLAG_WP | UFFD_FEATURE_WP_UNPOPULATED,
>  	},
> +	{
> +		.name = "wp-partial-range",
> +		.uffd_fn = uffd_wp_partial_range_test,
> +		.mem_targets = MEM_ANON,
> +		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP,
> +	},
>  	{
>  		.name = "minor",
>  		.uffd_fn = uffd_minor_test,
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

