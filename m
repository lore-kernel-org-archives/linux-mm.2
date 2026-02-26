Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06703FD8FD3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FED6B015F; Thu, 26 Feb 2026 11:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED7B6B0160; Thu, 26 Feb 2026 11:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE9F6B0161; Thu, 26 Feb 2026 11:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35A636B015F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E97BF8B251
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:29:58 +0000 (UTC)
X-FDA: 84487144476.18.FE75977
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C5562001A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:29:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OB3FKG2X;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772123397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yh64DWzjn3T5tbVdG00bnLP2a4FuujI6RBd/LRsFLSk=;
	b=C+Xbi+wfpe7r0U1D3V3dEdeZfDBwZ2M69XWnnOfi5AXAiRtsrbGHr+z5adPDYytRpD+1qG
	jz3eeCVot+V7xwq0oPKNwyS5m7MseT14m9By6ynwfyCy4WGOMyMlBdAOJPS8thfwFtHI62
	Gw37zpbC/51aD3QBxR4+0LgiIGbHW0A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OB3FKG2X;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772123397; a=rsa-sha256;
	cv=none;
	b=aiMkrmMXjUPXKz8nZN9oTUcY2KTo+Vpza5YMAqnGE3ZZ2/CrPNGYlYplU36LBL6BweU8R+
	tQZdmwWdcfNZVX5X9165mitRgS1FO5iHQLXxIXJ2tkdVhEuZoYvB1KEQAtulNt3cUUTXon
	oEph4+ZFnsFDaglDBs2z+HRyv37urE4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FA4043641;
	Thu, 26 Feb 2026 16:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519A4C116C6;
	Thu, 26 Feb 2026 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772123396;
	bh=uMFN9RkMbM+7SbXyhkLLyz3IvEzev7M+UJI2j68H1GU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OB3FKG2XQBSFfNl6yatDDLwkubGI3MTeie/zNm8/qluN6mhVq7k9oZd6suBLz8So2
	 mlXSyzGb4JjZkOe0yU1+kIdE2dygihuvnRdZJPvYuUhP+qDchhw5aUOabPa+90pPcx
	 G9m1RMch34bOWQkpgakTvl0tQD53nVdMOM6tkN7yYCbyC2/HwNLHzE3PTPuUg0UN3l
	 3lfjaRVHX2n4RXWidrSrCFN+aPduJNuWAfZifP3NofAopZvQXDrIVghRcCN8UGGjGf
	 SdamrQWFZfXGcySWnN1d5qiVmwA4jx1gcHocmJhZrcBnE1Y1XxPFWyPHEJA6AGNB18
	 tJsCRrNyw/jVw==
Message-ID: <cb38e860-bd1a-409e-9685-de8dbe9ee54e@kernel.org>
Date: Thu, 26 Feb 2026 17:29:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: Add UFFDIO_MOVE huge zeropage PMD
 regression test
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aaBWG4fajXXbjpVN@chrisdown.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaBWG4fajXXbjpVN@chrisdown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0C5562001A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: fbxrz5xug1a3xk5fssb4q5fsymckuwru
X-HE-Tag: 1772123396-873242
X-HE-Meta: U2FsdGVkX1/PEfLyYgHc0uYKPUj+Af42bvEhWgEOx1h026xOeS8l5PuR/t0YFfhBCAEWwJ/BwCNch4DQ54yXisPJ0boLwYTbN/wm1clkZIoIsIat51hPb8jUapAAPvNqZsi08f645YnsPrF/RRRDYwp9QMeWmbmPIGZtwS3NE0ygf8YJHnGQXrkn60kBe+LqFDaWIM0KLSGdgWce11/XPeFC+hp3lViDiMG7s2/Ktr8atopmkzvIpHWmEhw+EmjEaFiwpuZxb41G1wmFuaKCofjF8KA1jz/vvVTYA6aivc7I7iRlUYBEr1T7TxeimmG897ikT2HIbmZDF7Qgqs73SBjlq9szzJ+OdV4bD+E32VY6cl/DGkL4F9SP/HRDL4uzDYHFp0BStUZoaYzm/08VlmB9CGL7ocrHWUBVvDiuPbi4exHZ7MLP6O/3pPZ6lSCEzLb7PLex2hsycmDSm8INyAXqQXoEZ3emfDUKexjuZ2gslNhW4+Zajr/O1aZu+SfN/PLtGWCA/O0N/+dA0iACoztCMsVuDok7vQBLucqwcVv6LjnSyyrp0KoLDOs/LYnp4CYWWmWSS39eEN0BpN8qfQHg/jPKOEsKRcp9221fGFf9hRZex+LTRjVzUIvXrInl0OOgiujq9DTkCCed1+vX8eIOjfeLebig8Xa67d9dQZspq5NB3gDPKFGZYdGd44MKz0ma6FD+HcLVW2k6t93ILjht4KzSIhI9MT3olW1YHeaPJWFLfsV1rm2gw9070R9xlXH1gWJ0KFzxCR48Xnt7Yax4DkKylpINq+5bod9scX0Bea4WYju/K8xTE4xXF35Q3E9OnJK/qhY264ovxhfw0l1LQ66itodHXsMJuC9HgYKDyvPMbNkiLmW3HUo1XuSMcO/Ptq7YNJLpoX42pf2Mdd3XeK4jWBEEw7Ep4/jAmin9L7YN1WhiQzXxAHVIEm7xl/rDrO8X5gtc0CD/uIo
 zU+X1WdF
 M0/GkQeT9+A7coa/YryNGTVFJ2d7FNnXC7LiPtchTCL6LgqenC5vA1y76gTBk7L5Q6NXLK9Pwg/rTEOhE5P4/+W6HewjkPsyCVexVTdIYX9t0dK9LuxuLX9D4XXesyCkw9L7vtvLWjjb2eP/RN+nBOp+jJyPIGk8iAO6BOv4Gz//9vowx3dZulJi3ZqsrHtk7C6wUfycRJFahFoqEPblP76gfxLcZLoUUFfv3SH4GqCLyq8Q6zkH/d7cUccv/2ZAPw5tZJABXhtBi8/dTXMHC7JNu+gpMAL+vlTlzNIH5JPCFyrXro6P7HqwbYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 15:18, Chris Down wrote:
> The existing uffd-unit-tests move-pmd coverage exercises PMD-sized
> UFFDIO_MOVE on anonymous THPs, but it does not force the huge zeropage
> PMD path in move_pages_huge_pmd().
> 
> Add a dedicated anonymous UFFDIO_MOVE PMD test that exercises this
> relatively comprehensively.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 176 +++++++++++++++++++
>  1 file changed, 176 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 6f5e404a446c..372619e3906d 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -203,6 +203,62 @@ static int pagemap_open(void)
>  	return fd;
>  }
>  

Thanks for implementing this!

[...]

> +static bool uffd_pagemap_scan_get_categories(int fd, char *start, uint64_t *categories)
> +{
> +	struct page_region r = { 0 };
> +	long ret;
> +
> +	if (!uffd_pagemap_scan_supported(fd, start))
> +		return false;
> +
> +	ret = uffd_pagemap_scan_get_categories_raw(fd, start, &r);
> +	if (ret < 0)
> +		err("PAGEMAP_SCAN failed: %s", strerror(errno));
> +
> +	*categories = ret ? r.categories : 0;
> +	return true;
> +}

Can we unify (deduplicate) that code with what we have in vm_util.c, and
then only export a function like

bool pagemap_is_huge_zero(int fd, char *start)

similar to pagemap_is_softdirty() etc to be consumed by the test here?

It can simply return "false" in case the interface is not available.

> +
>  /* This macro let __LINE__ works in err() */
>  #define  pagemap_check_wp(value, wp) do {				\
>  		if (!!(value & PM_UFFD_WP) != wp)			\
> @@ -1227,6 +1283,119 @@ static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t
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
> +	uint64_t categories;
> +	unsigned long i;
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
> +	/* Materialise a PMD-sized huge zeropage mapping in the source. */

"Fault in the huge zeropage"

> +	force_read_pages(aligned_src, pmd_pages, gopts->page_size);
> +
> +	pagemap_fd = pagemap_open();
> +	if (!uffd_pagemap_scan_get_categories(pagemap_fd, aligned_src, &categories)) {
> +		close(pagemap_fd);
> +		uffd_test_skip("PAGEMAP_SCAN unsupported");
> +		return;
> +	}
> +	if ((categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) !=
> +	    (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) {
> +		close(pagemap_fd);
> +		uffd_test_skip("could not materialise a huge zeropage PMD mapping");

"could not fault in the huge zeropage" ?

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
> +	} else if (!uffd_pagemap_scan_get_categories(pagemap_fd, gopts->area_dst,
> +						     &categories)) {
> +		uffd_test_fail("PAGEMAP_SCAN unsupported");

Why should it suddenly be unsupported when it worked before?

With the pagemap_is_huge_zero() helper, this will boil down to

} else if (pagemap_is_huge_zero(...)) {
	uffd_test_fail("moved destination is not a huge zeropage PMD");
}

> +	} else if ((categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO |
> +				  PAGE_IS_HUGE)) !=
> +			(PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) {
> +		uffd_test_fail("moved destination is not a huge zeropage PMD");
> +	} else if (!check_huge_anon(gopts->area_dst, 0, pmd_size)) {
> +		/* vm_normal_page_pmd() must continue to treat the moved PMD as special. */
> +		uffd_test_fail("moved huge zeropage PMD counted as AnonHugePages");
> +	} else {
> +		for (i = 0; i < pmd_size; i++) {
> +			if (gopts->area_dst[i]) {
> +				uffd_test_fail("moved huge zeropage PMD data is not zero");
> +				goto out_restore;
> +			}
> +		}

That's a bit excessive given that pagemap told us that it is indeed the
huge zeropage. So I would just drop this.


-- 
Cheers,

David

