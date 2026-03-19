Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A542B1090240
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B226B0510; Thu, 19 Mar 2026 11:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5C56B0512; Thu, 19 Mar 2026 11:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA356B0513; Thu, 19 Mar 2026 11:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD996B0510
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:42:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A718713B19D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:42:15 +0000 (UTC)
X-FDA: 84563229030.14.B965C1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F3E1340017
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:42:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z018L9Ma;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773934934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lc95fE5PcKpVoqjQZVE/Y3nTvuJLsNcMVpnAyeEHQM8=;
	b=jVF5zr9ZV9tCYe4D4htC4WFHaqxiWJ1Xn0kWLxwkORO7C5jeLGJdmO1kLJpgQdemWeqi4h
	vN+DY1880ZZqVLx4JFOB7oD+pv5UnpRbgv9AhYcYgim9h3WI0JflY801CgtSlSePcn7ADU
	b++0qwgFHoGI5HZRTlZtv+A8MTiszeo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773934934; a=rsa-sha256;
	cv=none;
	b=z2HOdCwEypKlp0rHAlgtk6+kMtqjjejvUFRgEI8TqUrV79pR9dAExl/Wk1Put0KsI2XVpX
	r7U0DuLttWJ/Yt/Y47bepZHoKj2SLc2hRJPchKo7nsF6g4p7usEgeqygsJGpkuhu3e9Qzb
	CirgFFRO2M3H9Ar0qi/MbevsIAeAP8I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z018L9Ma;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A5B060097;
	Thu, 19 Mar 2026 15:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EEAC19424;
	Thu, 19 Mar 2026 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773934933;
	bh=ddwCQSambwYhQk+Gsdfv4G9cQ4n4k0xN/Xf5jL5ONSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z018L9Mak6kJMccjvcDtf9kU/gKi2xvWqu3Nn24TK/JUCbiVBonRRqd9vGgzuKqc6
	 a7MZUk1D5gPNrtaqHxzmo7toXNDIsCnJgjlbap47KUZP52UrYfIlOcdn1mX340p3MS
	 o7kPN5nendZl6j4TQJQD0QAC337GqDQJrMnyOXi5tKmBB/xH4TFMhEgSXdrhYQ8d0A
	 VpTfsK862COAupBKT5D+iLtiIf1kZNqUKaKRXOycyq+RjGiZFSjTs7aapyfZM9C+df
	 NNhyAxNRNuOh4sarGLaHaNAET257IrdhIg1tGmDQjKglosykUDoKj4wfDyyrUAbsZl
	 wXPDOxkUEGj+w==
Date: Thu, 19 Mar 2026 17:42:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: Add UFFDIO_MOVE huge zeropage PMD
 regression test
Message-ID: <abwZTnbQ5QWSYvAh@kernel.org>
References: <abongwF3X0G8xY1I@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abongwF3X0G8xY1I@chrisdown.name>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3E1340017
X-Stat-Signature: 6mgymtrdfjk5k6qnqdkagnfouksyybgo
X-Rspam-User: 
X-HE-Tag: 1773934933-429097
X-HE-Meta: U2FsdGVkX1+3BkhEdI4V6me1kq5tcthfU7JLwWV8K4BQHpQ7WQ31ekboGCpLMaXyRoD5DmprChL3KKt136H0DYzPU/Fh4OkkXWXRZOG6swlWMEHY52wRLq6VJJ2EIgsI1fYXokCyxsoz1ePbEdn8wiZfePoC2wH80r+Np811yVtWbjNO0aqfTp/Q6N18/cN485UNljtndk0j52QloCw/vqKfiU30vze38wRycjsW4jvjWUyAnpJW2tY7iKVGL6QQM3whoxpqr3iwKYpl9Kx3QBv1/RRwTkjsNipjvE3IL3udo8XRW9rSm5n6ESBk0s4i95pI2e+vRprih9N3jNtwc6ADHc/NP4J/mAN8CZ7kEI2Hv0o8aJleAKNSRjOlisr/BjG4pa8eySIxWmdOGcQnK+ziaAAMD+gyfOrzKizvT0pProhl3E9UpxbW79pEgiQWKPbkLRQXMbPpUjb4a4r01q10ARz9tD3RZv6O7UKtEmOW53T9ZbqH0yN9fkcPRkz0KRoTQ8P19DcauR6r4VHEsH0RPDgRyz45yEIH0rU6eg89rOr7vzA2swP/6ltuKqUgLpftqy3nQVhDMKsihsqii6vQcfF1M875/9wZanmLmF2cvBU/sLqe4uIFmvs+AgfL7+tSJQj2cSp3uKq/aEKrYycPaALOmnyNRJv/LzmKC6Hswu5C/zFb9bGRYUXt8OUpCmt8hyrdbcRx2jEsNyRueZHGpTnqF0yiIZrg15KV1iDt+bVQ6iLKvxT/twkh0THFkM7ZqVIe2X8Px63/AfFm+LVQkpaBdo3RFNmDp+2wc1FYCllSCy59x2MChLj/PUOVSM3WSCBsC+HMobAS2itzF2451vHtqhP+pSbKNJBFkzbdBe0LT8Wqtgs814gkj85GnE9h5LqwhPxU9YkKpnMKZLc2wkcZPxXDBN86xc3S5KjfV3J/bwxo3+m/pYGL5HoQy5f4L3F62AVMUs/s3nC
 aPAXxaZM
 Px15CTC9ZPdRYq7BXBY0pGmeLpvCMNI/gk7l38vWwhiV6JmxL5+J6RE10pd+rQ2uSyAaw9P63ELfkn7STjz/7exezgIuYwQpvoE5aTn+qT7a3e6dqwMJpbiLOpe+00Om1evCq8RNJ28MA2+MHsbt/2ea4p5Iy8g/jhD8oiugUbh4Xxt8XyhZbHAnayhvucdKZ6GEmvWFdsrfm1rab/HjUcEEI2ps9X/sdlUSjr5arZ8U/4ScE24zYRM4a6EuLj9swF9hNb+FifbWvTl4EPj7PuhAn8HQ6pVgyWUsOIxFN7LSmIp3j7Oin3dydUhiNViFM/L2b2/ZOgVmhQlE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 12:18:11PM +0800, Chris Down wrote:
> The existing uffd-unit-tests move-pmd coverage exercises PMD-sized
> UFFDIO_MOVE on anonymous THPs, but it does not force the huge zeropage
> PMD path in move_pages_huge_pmd().
> 
> Add a dedicated anonymous UFFDIO_MOVE PMD test that exercises this
> relatively comprehensively.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 100 +++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.c         |  12 +++
>  tools/testing/selftests/mm/vm_util.h         |   1 +
>  3 files changed, 113 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 6f5e404a446c..9cc4cbab9a23 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -1227,6 +1227,99 @@ static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t
>  			      uffd_move_pmd_handle_fault);
>  }
>  
> +static void uffd_move_pmd_huge_zeropage_test(uffd_global_test_opts_t *gopts,
> +					     uffd_test_args_t *targs)
> +{
> +	unsigned long pmd_size = read_pmd_pagesize();
> +	unsigned long pmd_pages;
> +	unsigned long bytes = gopts->nr_pages * gopts->page_size;
> +	char *orig_area_src = gopts->area_src, *orig_area_dst = gopts->area_dst;
> +	char *aligned_src, *aligned_dst;
> +	unsigned long src_offs, dst_offs, max_offs;
> +	pthread_t uffd_mon;
> +	struct uffd_args args = { 0 };
> +	char c = '\0';
> +	int pagemap_fd;
> +
> +	if (pmd_size <= gopts->page_size) {
> +		uffd_test_skip("huge page size is 0, feature missing?");
> +		return;
> +	}
> +	if (!detect_huge_zeropage()) {
> +		uffd_test_skip("transparent huge zeropage disabled");
> +		return;
> +	}
> +
> +	pmd_pages = pmd_size / gopts->page_size;
> +	if (bytes < pmd_size) {
> +		uffd_test_skip("not enough pages for one PMD-sized move");
> +		return;
> +	}
> +
> +	aligned_src = ALIGN_UP(orig_area_src, pmd_size);
> +	aligned_dst = ALIGN_UP(orig_area_dst, pmd_size);
> +	src_offs = (aligned_src - orig_area_src) / gopts->page_size;
> +	dst_offs = (aligned_dst - orig_area_dst) / gopts->page_size;
> +	max_offs = src_offs > dst_offs ? src_offs : dst_offs;
> +	if (max_offs + pmd_pages > gopts->nr_pages) {
> +		uffd_test_skip("could not find aligned PMD-sized src/dst window");
> +		return;
> +	}
> +
> +	if (madvise(orig_area_dst, bytes, MADV_HUGEPAGE))
> +		err("madvise(MADV_HUGEPAGE) failure");
> +	if (madvise(orig_area_src, bytes, MADV_DONTFORK))
> +		err("madvise(MADV_DONTFORK) failure");
> +	if (madvise(aligned_src, pmd_size, MADV_DONTNEED))
> +		err("madvise(MADV_DONTNEED) failure");
> +
> +	/* Fault in a PMD-sized huge zeropage mapping in the source. */
> +	force_read_pages(aligned_src, pmd_pages, gopts->page_size);
> +
> +	pagemap_fd = pagemap_open();
> +	if (!pagemap_is_huge_zero(pagemap_fd, aligned_src)) {
> +		close(pagemap_fd);
> +		uffd_test_skip("could not fault in the huge zeropage");
> +		return;
> +	}
> +	gopts->area_src = aligned_src;
> +	gopts->area_dst = aligned_dst;
> +
> +	if (uffd_register(gopts->uffd, gopts->area_dst, pmd_size, true, false, false))
> +		err("register failure");
> +
> +	args.gopts = gopts;
> +	args.handle_fault = uffd_move_pmd_handle_fault;
> +	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
> +		err("uffd_poll_thread create");
> +
> +	/*
> +	 * One fault on dst should trigger a single PMD-sized UFFDIO_MOVE from
> +	 * the huge zeropage PMD we populated in the source.
> +	 */
> +	force_read_pages(gopts->area_dst, pmd_pages, gopts->page_size);
> +
> +	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
> +		err("pipe write");
> +	if (pthread_join(uffd_mon, NULL))
> +		err("join() failed");
> +
> +	if (args.missing_faults != 1 || args.minor_faults != 0) {
> +		uffd_test_fail("stats check error");
> +	} else if (!pagemap_is_huge_zero(pagemap_fd, gopts->area_dst)) {
> +		uffd_test_fail("moved destination is not a huge zeropage PMD");
> +	} else if (!check_huge_anon(gopts->area_dst, 0, pmd_size)) {
> +		/* vm_normal_page_pmd() must continue to treat the moved PMD as special. */
> +		uffd_test_fail("moved huge zeropage PMD counted as AnonHugePages");
> +	} else {
> +		uffd_test_pass();
> +	}
> +
> +	gopts->area_src = orig_area_src;
> +	gopts->area_dst = orig_area_dst;
> +	close(pagemap_fd);
> +}
> +
>  static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
>  {
>  	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
> @@ -1550,6 +1643,13 @@ uffd_test_case_t uffd_tests[] = {
>  		.uffd_feature_required = UFFD_FEATURE_MOVE,
>  		.test_case_ops = &uffd_move_test_pmd_case_ops,
>  	},
> +	{
> +		.name = "move-pmd-huge-zeropage",
> +		.uffd_fn = uffd_move_pmd_huge_zeropage_test,
> +		.mem_targets = MEM_ANON,
> +		.uffd_feature_required = UFFD_FEATURE_MOVE,
> +		.test_case_ops = &uffd_move_test_pmd_case_ops,
> +	},
>  	{
>  		.name = "move-pmd-split",
>  		.uffd_fn = uffd_move_pmd_split_test,
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index a6d4ff7dfdc0..55cc4cc058a2 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -120,6 +120,18 @@ bool pagemap_is_populated(int fd, char *start)
>  				PAGE_IS_PRESENT | PAGE_IS_SWAPPED);
>  }
>  
> +bool pagemap_is_huge_zero(int fd, char *start)
> +{
> +	uint64_t categories;
> +
> +	if (!pagemap_scan_supported(fd, start))
> +		return false;
> +
> +	categories = pagemap_scan_get_categories(fd, start);
> +	return (categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) ==
> +		(PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE);
> +}
> +
>  unsigned long pagemap_get_pfn(int fd, char *start)
>  {
>  	uint64_t entry = pagemap_get_entry(fd, start);
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index e9c4e24769c1..e0b6ae1b12f5 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -85,6 +85,7 @@ uint64_t pagemap_get_entry(int fd, char *start);
>  bool pagemap_is_softdirty(int fd, char *start);
>  bool pagemap_is_swapped(int fd, char *start);
>  bool pagemap_is_populated(int fd, char *start);
> +bool pagemap_is_huge_zero(int fd, char *start);
>  unsigned long pagemap_get_pfn(int fd, char *start);
>  void clear_softdirty(void);
>  bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
> 
> base-commit: f0caa1d49cc07b30a7e2f104d3853ec6dc1c3cad
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

