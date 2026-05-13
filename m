Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E2CCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9026B008A; Wed, 13 May 2026 02:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B02A6B008C; Wed, 13 May 2026 02:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6656B0092; Wed, 13 May 2026 02:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6AB6B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:06:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03BFEA071C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:06:30 +0000 (UTC)
X-FDA: 84761362182.07.53F3C61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2C2D8160009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:06:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q/FAgAGM";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778652389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxBrS+IFF7dJk40Opam09P9QLR19vLoAPcuSL+vymzk=;
	b=0sdqYs9aOfUvdIqbiBF6kRpUIc1VHlGoBIPyQ//7ulUWvdagOprWxOCTIJsnIAshNs6DV+
	BYFeSztzAJ4LydAKW6w5Nc+P1vmM5MWA3mmbUwQiDpd2AG1/bt03ZfbYDyYfRFd+koOk0M
	h1BcfiJiXt+sOylYMLskSS9qXVg7oWQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q/FAgAGM";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778652389; a=rsa-sha256;
	cv=none;
	b=s1q8kDmOV0ti6/Q0rLIAzGi6EHJOPrLqzT0w5VGIjQkELVL+tVf1xP254lxWAottd3ANVP
	WQDJ5VsMx3DND3NNFJDNGmLt1A+bF0yNrKJ0ZIOJRIU7egqCRv34OrZ3SdCESrm19c8LYJ
	bE8EZ4vqLsGCibw4EZ8GqzGrtR3wIjw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ED8960123;
	Wed, 13 May 2026 06:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34381C2BCB7;
	Wed, 13 May 2026 06:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778652388;
	bh=zk+jyEY+gvdAJSWh+sBXT03TINreZu3ay8x4kAlMhRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q/FAgAGM0l58W+Z92pbTYUvV+bqtfoF4TUZrVpuU0wNm68hp1U04Vfkrurb/AkWoT
	 yiAadgZNKkLKtxvU2hpfRpneeQ7Q9P92rgx3t0tsDjXqZt1e0Ff3bjtlJDv/T/EtsI
	 CD8IGCk1cACSkG9B79Em9o1Y88TIEkufhhZqVBPiT6B6sWCf3my/6SsbniJbud8zWC
	 yoqlSx8hyZjHfgLJxRKFej6Wawv5eC2RMlPPdiviq4oKjEm+dSUALDaJmAlmTdzfqH
	 HctYJ78TjNxdW+KNSk2wM7CiCq5VbaBUCD9PGDS58v4bLhMLrvzNdFvkrQ9GqlyJOj
	 lW0rSVETiyLDQ==
Date: Wed, 13 May 2026 09:06:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 13/14] selftests/mm: add userfaultfd RWP tests
Message-ID: <agQU2c2b3VqpYRdi@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <e097db49bd0ada5f3c22f9c98c548c3b8ca24ba7.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e097db49bd0ada5f3c22f9c98c548c3b8ca24ba7.1778254670.git.kas@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C2D8160009
X-Rspam-User: 
X-Stat-Signature: dugqie9csnqgzgpu35m74hi7o34oxgbr
X-HE-Tag: 1778652388-794315
X-HE-Meta: U2FsdGVkX1/bUVQJ+zDf5ht+a+0ueqcGYxK992LydjpZ00bgP08RiKyPs6ApX+JPCdSZp5yLqfPqORg15tVNTE9QdJR7E2SCi4PF+/ATjA5OwdjiV7On8oDzrh4Wt4n5vwboloHOydx+2v3C+GUw0v8HmXneXD3hemL0fxqVi1Lj2vlcSlvZpHFG/pGbhLsEppStvxURdYYQ7W/31r5N3tBO7+YHsVvOv1pB4OjnBJkYbznHWev7u+TSZ6L8qL76wd7emcKCtZOBH+Y5D9b2G6Lb+Kgmsa9v43S6bEkrdnC23J688skcfL7JzZ8i3HAd13rl0oBt2GTAKYb6VUccmAPR3wKiS4TPRcsWEh//V+uZODoR7YKFFQKtZ23m0yb42zgyT91b65L1xBS8N7ys1eswOPbIUoKxKlGL3uAjIu6JVYZ4Umxcdf4ce8ANSiku4VhwOWUi0lSCFegL9i6/v//JuoGNzEasgm2rAzid4nHnRhM/d5784V9ywRUPjqPRhgyEUXKbCtQZe40ZwXinT6Ck4FX6EuePwTv6T8YaSLlWRhn1LeV6nb+b9yY6SZayIS9vqpa0pJbMwFRmb+aIFi29MCW0Sq+ocOtNqwYHSX84XhxohFLAy0Chgk7d8/u1MZqFcyAkx3EYRExZpMPVRW6PqcPCwVk5eFDdE3siAmWEwt6xcNhhMpFtrYyNkKio+nps26xePyH/C9d/FuGhn22Eo23kdlqkgRjNCJg6Nv5F24s8ZZ/8Dtcs0yiX1TRShmgOyDrwUFpfX9gdU/5MqW7Y+Y/ZgegsSGqp62WKFfZ8FRjvf5MITwNomaeQ1E3H+C7T+CIW3yTWXNwrOkrWYb8771mDG14BS9+0M4TTCLIsTyJPZiDEehuBtfjnncvQNxk2TT3gJ0jpX7BDrPDHVJ9eHKHTFKpG0JjZHPdlKVAeCVf1rUvMIM89fl+eX5N9KosNbOKagWDRsUkoXK7
 1fum7Wsp
 pzYzV+bDrhqy6Fxl0WIHRYU33zCVfr7BlbvQAMaGqUT5mcok9OqfuYG6gdTCXcJV24iFXK9mjRiVDic2JvVO6nAS3q00BAX+HBdscjXr6zipuQQIdM6NK8mfbf4xXpBZV8z9hmUINJ/YIvPyEq16f/dG0S0k/uavL9oIYX//7zFWFfUA8trkCMs/9GLypNlJrt3fCyDsiAIHxQVCX2ZglBsi1risZP/bWjX523ibf43i6X7tg+gOCAxgVByh3gktxRZH0Xwu6qzhJAVmr1ZpMZp7+lXV9a3TZYo5D5EndTDhJ0gplrifbsFDMLFWrzWxEWeVGY506LovSZaJnoBI9Mn/zMysZfbn0uF+QX2o0utPdVxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:25PM +0100, Kiryl Shutsemau (Meta) wrote:
> Coverage for UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT:
> 
>   rwp-async          async mode — touch pages, verify permissions are
>                      auto-restored without a message
>   rwp-sync           sync mode — access blocks, handler resolves via
>                      UFFDIO_RWPROTECT
>   rwp-pagemap        PAGEMAP_SCAN reports still-cold pages via
>                      inverted PAGE_IS_ACCESSED
>   rwp-mprotect       RWP survives mprotect(PROT_NONE) ->
>                      mprotect(PROT_READ|PROT_WRITE) round-trip
>   rwp-gup            GUP walks through a protnone RWP PTE (pipe
>                      write/read drives the GUP path)
>   rwp-async-toggle   UFFDIO_SET_MODE flips between sync and async
>                      without re-registering
>   rwp-close          closing the uffd restores page permissions
>   rwp-fork           RWP survives fork() with EVENT_FORK; child's
>                      PTEs keep the uffd bit
>   rwp-fork-pin       RWP survives fork() on an RO-longterm-pinned
>                      anon page (forces copy_present_page()); child
>                      read auto-resolves and clears the bit, proving
>                      PAGE_NONE was in place
>   rwp-wp-exclusive   register with MODE_WP|MODE_RWP returns -EINVAL
> 
> All tests run against anon, shmem, shmem-private, hugetlb, and
> hugetlb-private memory, except rwp-fork-pin which is anon-only —
> copy_present_page() is the private-anon pinned-exclusive fork path.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 774 +++++++++++++++++++
>  1 file changed, 774 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 6f5e404a446c..a35fb677e4cc 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -7,6 +7,7 @@
>  
>  #include "uffd-common.h"
>  
> +#include <linux/fs.h>
>  #include "../../../../mm/gup_test.h"
>  
>  #ifdef __NR_userfaultfd
> @@ -167,6 +168,23 @@ static int test_uffd_api(bool use_dev)
>  		goto out;
>  	}
>  
> +	/* Verify returned fd-level ioctls bitmask */
> +	{
> +		uint64_t expected_ioctls =

can be const uint64_t and declared at the top of the function to avoid
extra indentation here.

> +			BIT_ULL(_UFFDIO_REGISTER) |
> +			BIT_ULL(_UFFDIO_UNREGISTER) |
> +			BIT_ULL(_UFFDIO_API) |
> +			BIT_ULL(_UFFDIO_SET_MODE);
> +
> +		if ((uffdio_api.ioctls & expected_ioctls) != expected_ioctls) {
> +			uffd_test_fail("UFFDIO_API missing expected ioctls: "
> +				       "got=0x%"PRIx64", expected=0x%"PRIx64,
> +				       (uint64_t)uffdio_api.ioctls,
> +				       expected_ioctls);
> +			goto out;
> +		}
> +	}
> +
>  	/* Test double requests of UFFDIO_API with a random feature set */
>  	uffdio_api.features = BIT_ULL(0);
>  	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == 0) {

...

> +static void uffd_rwp_pagemap_test(uffd_global_test_opts_t *gopts,
> +					  uffd_test_args_t *args)
> +{
> +	unsigned long nr_pages = gopts->nr_pages;
> +	unsigned long page_size = gopts->page_size;
> +	unsigned long p;
> +	struct page_region regions[16];
> +	struct pm_scan_arg pm_arg;
> +	int pagemap_fd;
> +	long ret;

...

> +	/*
> +	 * PAGE_IS_ACCESSED is set once the uffd-wp bit has been cleared
> +	 * (access happened, or the user resolved). Invert it to select
> +	 * still-protected (cold) pages.
> +	 */
> +	memset(&pm_arg, 0, sizeof(pm_arg));
> +	pm_arg.size = sizeof(pm_arg);
> +	pm_arg.start = (uint64_t)gopts->area_dst;
> +	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
> +	pm_arg.vec = (uint64_t)regions;
> +	pm_arg.vec_len = 16;

ARRAY_SIZE(regions)?

> +	pm_arg.category_mask = PAGE_IS_ACCESSED;
> +	pm_arg.category_inverted = PAGE_IS_ACCESSED;
> +	pm_arg.return_mask = PAGE_IS_ACCESSED;
> +
> +}
> +
> +/*
> + * Test that RWP protection survives a mprotect(PROT_NONE) ->
> + * mprotect(PROT_READ|PROT_WRITE) round-trip. The uffd-wp bit on a
> + * VM_UFFD_RWP VMA must continue to carry PROT_NONE semantics after
> + * mprotect() changes the base protection; otherwise accesses would
> + * silently succeed and the pagemap bit would stick without a fault
> + * ever clearing it.
> + */
> +static void uffd_rwp_mprotect_test(uffd_global_test_opts_t *gopts,
> +				   uffd_test_args_t *args)
> +{
> +	unsigned long nr_pages = gopts->nr_pages;
> +	unsigned long page_size = gopts->page_size;
> +	unsigned long p;
> +	struct page_region regions[16];
> +	struct pm_scan_arg pm_arg;
> +	int pagemap_fd;
> +	long ret;

...

> +	memset(&pm_arg, 0, sizeof(pm_arg));
> +	pm_arg.size = sizeof(pm_arg);
> +	pm_arg.start = (uint64_t)gopts->area_dst;
> +	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
> +	pm_arg.vec = (uint64_t)regions;
> +	pm_arg.vec_len = 16;

ARRAY_SIZE(regions)?

> +	pm_arg.category_mask = PAGE_IS_ACCESSED;
> +	pm_arg.category_inverted = PAGE_IS_ACCESSED;
> +	pm_arg.return_mask = PAGE_IS_ACCESSED;
> +
> +	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
> +	close(pagemap_fd);
> +
> +	if (ret < 0) {
> +		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
> +		return;
> +	}
> +	if (ret != 0) {
> +		uffd_test_fail("expected no cold pages after mprotect()+touch, got %ld regions",
> +			       ret);
> +		return;
> +	}
> +
> +	uffd_test_pass();
> +}
> +
> +/*
> + * Test that GUP resolves through protnone PTEs (async mode).
> + * RW-protect pages, then use a pipe to exercise GUP on the RW-protected
> + * memory. write() from RW-protected pages triggers GUP which must fault
> + * through the protnone PTE.
> + */
> +static void uffd_rwp_gup_test(uffd_global_test_opts_t *gopts,
> +				     uffd_test_args_t *args)
> +{
> +	unsigned long page_size = gopts->page_size;
> +	char *buf;
> +	int pipefd[2];
> +
> +	buf = malloc(page_size);
> +	if (!buf)
> +		err("malloc");
> +
> +	/* Populate first page with known content */
> +	memset(gopts->area_dst, 0xCD, page_size);
> +
> +	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, page_size))
> +		err("register failure");
> +
> +	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
> +
> +	if (pipe(pipefd))
> +		err("pipe");
> +
> +	/*
> +	 * write() from the RW-protected page into the pipe. This triggers
> +	 * GUP on the protnone PTE; in async mode the kernel auto-restores
> +	 * permissions and GUP succeeds. One byte is enough to exercise
> +	 * the GUP path and avoids any concern about pipe buffer sizing on
> +	 * large-page archs.
> +	 */
> +	if (write(pipefd[1], gopts->area_dst, 1) != 1) {
> +		uffd_test_fail("write from RW-protected page failed: %s",
> +			       strerror(errno));
> +		goto out;
> +	}

Sashiko (https://sashiko.dev/#/patchset/cover.1778254670.git.kas%40kernel.org?part=13):

	Could this write() implementation be bypassing the intended test
	logic?
	... the write() call here will trigger standard hardware page
	faults during copy_from_user() rather than the intended
	get_user_pages() code path.

It also suggests to use vmsplice().

> +
> +	if (read(pipefd[0], buf, 1) != 1) {
> +		uffd_test_fail("read from pipe failed");
> +		goto out;
> +	}
> +
> +	if (buf[0] != (char)0xCD) {
> +		uffd_test_fail("content mismatch: got 0x%02x, expected 0xCD",
> +			       (unsigned char)buf[0]);
> +		goto out;
> +	}
> +
> +	uffd_test_pass();
> +out:
> +	close(pipefd[0]);
> +	close(pipefd[1]);
> +	free(buf);
> +}
> +
> +/*
> + * Test runtime toggle between async and sync modes.
> + * Start in async mode (detection), flip to sync (eviction), verify faults
> + * block, resolve them, flip back to async.
> + */
> +static void uffd_rwp_async_toggle_test(uffd_global_test_opts_t *gopts,
> +					      uffd_test_args_t *args)
> +{
> +	unsigned long nr_pages = gopts->nr_pages;
> +	unsigned long page_size = gopts->page_size;
> +	struct uffd_args uargs = { };
> +	pthread_t uffd_mon;
> +	bool started = false;
> +	char c = '\0';
> +	unsigned long p;
> +
> +	uargs.gopts = gopts;
> +	uargs.handle_fault = uffd_handle_rwp_fault;
> +
> +	/* Populate */
> +	for (p = 0; p < nr_pages; p++)
> +		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
> +
> +	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
> +			  nr_pages * page_size))
> +		err("register failure");
> +
> +	/* Phase 1: async detection — RW-protect, access first half */
> +	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
> +			 nr_pages * page_size, true);
> +
> +	for (p = 0; p < nr_pages / 2; p++) {
> +		volatile char *page = gopts->area_dst + p * page_size;
> +		(void)*page;  /* auto-resolves in async mode */
> +	}
> +
> +	/* Phase 2: flip to sync for eviction */
> +	set_async_mode(gopts->uffd, false);
> +
> +	/* Start handler — will receive faults for cold pages */
> +	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
> +		err("uffd_poll_thread create");
> +	started = true;
> +
> +	/* Access second half (cold pages) — should trigger sync faults */
> +	for (p = nr_pages / 2; p < nr_pages; p++) {
> +		unsigned char *page = (unsigned char *)gopts->area_dst +
> +				      p * page_size;
> +		if (page[0] != (p % 255 + 1)) {
> +			uffd_test_fail("page %lu content mismatch", p);
> +			goto out;
> +		}
> +	}
> +
> +	/*
> +	 * Stop the handler before reading minor_faults: the last fault
> +	 * resolution rwprotect_range()s before incrementing the counter,
> +	 * so the main thread can race ahead of the increment. Stopping
> +	 * here also makes Phase 3 a clean async-only test -- with the
> +	 * handler still running it would silently resolve any sync fault
> +	 * the kernel erroneously delivers, masking a regression.
> +	 */
> +	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
> +		err("pipe write");
> +	if (pthread_join(uffd_mon, NULL))
> +		err("join() failed");
> +	started = false;

I think 'started' is misleading, would "running_sync_test" better?

> +
> +	if (uargs.minor_faults == 0) {
> +		uffd_test_fail("expected sync faults, got 0");
> +		goto out;
> +	}

And it seems here we can just return and then started is not needed at
all.

> +
> +	/* Phase 3: flip back to async */
> +	set_async_mode(gopts->uffd, true);
> +
> +	/* RW-protect and access again — should auto-resolve */
> +	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
> +			 nr_pages * page_size, true);
> +
> +	for (p = 0; p < nr_pages; p++) {
> +		volatile char *page = gopts->area_dst + p * page_size;
> +		(void)*page;
> +	}
> +
> +	uffd_test_pass();
> +out:
> +	if (started) {
> +		if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
> +			err("pipe write");
> +		if (pthread_join(uffd_mon, NULL))
> +			err("join() failed");
> +	}
> +}

-- 
Sincerely yours,
Mike.

