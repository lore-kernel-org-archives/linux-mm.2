Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A8D606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iPYSnUUT
Received: by kanga.kvack.org (Postfix)
	id 86C066B00EF; Mon,  2 Nov 2026 05:08:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842456B05B1; Mon,  2 Nov 2026 05:08:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FFD6B05C9; Mon,  2 Nov 2026 05:08:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44CE76B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:08:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 664D5A8AEC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:03 +0000 (UTC)
X-FDA: 85389753246.29.84A8BFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D62DF10000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iPYSnUUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHGkVJUa8HZ0EZXHtvtoWcBsgIqIizfSFjqQHTffook=;
	b=KzIxHkkPLRre2+S6GrigTONweB1kKCHkUnFk3vj2VsF+uI2xNYrnR3NAPC2UKGeA/cRro3
	6Icuz17g1El0C5aGY6yRm4a/unq13xc0KrwkcPgZnH8V4xyE6nP92STTeBnOXNU39d7N4W
	m/ji2GZhH2xFgVGXzR6TAX0sYYegfSw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iPYSnUUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614081;
	b=ZP7OkAqZWS+FIkrrmPJVpTv9BWKSYFaSgA0v1Qxhg6AZ8K8R3N/5nmg/Bc8h0DhlCIMFj6
	+JTtxLOd1CuFYtKkewjfBe/K3GofFSGY8PEzV5CqqRjNTPXC5lJRHG6M0VQUd63PpahtkF
	iifGa4AENJTas4Rk/uJr4glvf0Yw0WU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 573B860F1F;
	Mon,  2 Nov 2026 10:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AE71F000C1;
	Mon,  2 Nov 2026 10:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614081;
	bh=PHGkVJUa8HZ0EZXHtvtoWcBsgIqIizfSFjqQHTffook=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iPYSnUUTD7dz8nPcsslscQX96/YM7XFOPcKFwif1kzlBcgxqvNAMCrVFP3QT6/mJZ
	 H4VRAaYJzIFAyHlW5W1jLO3NPMD+c7alEhiQmcQJo+OUkp/auAy/BT+u5o9cpDVicR
	 p9fAM54yUdtbuB81DDxcYdF0dj4wOmfT9f70NL3ZyZHE9Lm9PsFsx30ljFlCCZ9xU2
	 QViJXiddc29ptMiRWPuA7RjV29OSdK5nN+kph0hj6UopE8NUZ7NYGF4+RJ5ctqT9VH
	 xalu0NI6bpvoTvTg0ePb8jy898hnsvd3z6I97tBZ5f9Zx7neuXHAP6Zaz4MoUb5VX7
	 RbtKVBHSplV/w==
Date: Mon, 2 Nov 2026 12:07:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 2/2] selftests/mm: add a uffd test for re-registering
 during UFFDIO_COPY
Message-ID: <auhg-HLrl4jbpaAT@kernel.org>
References: <20261102081140.201987-1-azpijr@gmail.com>
 <20261102081140.201987-3-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102081140.201987-3-azpijr@gmail.com>
X-Rspamd-Queue-Id: D62DF10000C
X-Stat-Signature: fsc7ez7tqe1w6mim4fh3j3zyu6xdqwjs
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793614081-77625
X-HE-Meta: U2FsdGVkX1/roab0qVWRmgIQ3NWcWuAjirEb9AGQZ9K/qJhyShcuGgpC9J3se+R3WZSF6Hm6KQXw7RjRMs/n35orAs0vAx8r/sMLbIUpNwbgaXRejPOKagN51YqKRngmXKcD6L+JihKyh4QplilLi4tmE+7S1xJ4RIE9gMeti9YkpdckI7wi5T2dKX1okhCqZwbczOtD7CbZ1XYHm18BqlyMjw6ySEjWr9ZwAuLNOIzjFlvKjJL9WEW68WdEDj/38Y/14jWSej5atpeKVzIFhYSane1T3lsy5Ly6uf8Ukde7tBJ820aOhDzUm2G637334XDSG2NK3wz5iLTNjnWIuhQnbSvXlqaB6mYjo5AV883ds22eeCVx892uaHy0CiKDjkmbsNbnck0pTBwU2MR2tg8HGy1yh22kxN/uZXxJL4cvAuWlfR6X4mTFEk3pEGLMsTAM4y4MG1NjObWcXEfsFG/xCR+Px9K+kbJ90ORP5x5SOY74E5uRv8Jw89o0IprkCBsydcImU5IkIaOWIYFajPNc4bYROlUwODX1S+ADb6nmv73Ca4NbgliyebsPwpnIXXQk1MOIeBbwU3BeJTMkaGhTSwqeZXxNY7uT+zGYUVWv5ShLprI01Mc94rfpXBQmI2+Gba2d+N1pj4d4y8t8vZz6iY7AuudcjghwqUgwCBJOtSj/raZQXALhwk2R+2pqBQKmVdOINSc9gfilNh2ZZbwU6IgoUxmIH0WJBKJj8BTp+0GGgg/eXXzoMq+2d7sVOJjhmK+koQ3Uw5pju9gNmBs2BMYSv1fhNITmSCFEGu94a+vEguAMWmdHv3K7AXJOgfccmdrbecrK40Eiq2mZjuYLQKH2FAPgdFk93XX9rFcAYHXBZjLlwgbXUg+VyjQOW8b8KFRTXWq8KqBTIdN52XyaxxhRf5xPz/FGeudDFQ/DPk7s2lvtmHqNWTi+Rq4G2JQZrSkj73EpruuN5qj
 C1Z0Xuv7
 IbRtKymIA/0pEqUSpWZRG35rjCPOGnC8uFMXqAE9fpqQPicHANqibYGg8P6tPcANwzX3N51DIg7grQchfz5u6imLq2Hy3kjJu5ff8dXHKqnc/0aCnqT3BxJbEDNllC9Jl6GhsoaKkGy9QqSNbImmbkVB/Tl8PrLbxZBK1+lXymZqvEm2r+4gTBQAZJdbP3WZieEqtpbc0kRBIcQqeoxNREOJVIo4Y17FKQY7A+4VlpCcocMKLyuti+I4dWlz0aMJkJCvxYZNeIKbLfUcWwTyM8tfavHhLz9PtxjnLcBrZ0GVbfkdCiuQX0UN83fy7wk96pyCQ2Zr09LW7Ltje1V6JK+uI+HbbGiJOqsnI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 09:11:31AM +0100, Jose A. Perez de Azpillaga wrote:
> Re-register the destination without WP while a UFFDIO_COPY_MODE_WP copy
> waits for its source page, then check that the copy fails with -EINVAL
> and leaves no uffd-wp bit behind. This covers all memory types.
> 
> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes in v2:
> - "all memory types" in the commit message
> - rename copy to result
> 
> v1: https://lore.kernel.org/20261029221129.89068-3-azpijr@gmail.com
> 
>  tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
>  1 file changed, 105 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index 2a97ba1d6feb..cc22b4cde621 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -375,6 +375,104 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
>  	uffd_test_pass();
>  }
>  
> +struct wp_copy_args {
> +	uffd_global_test_opts_t *gopts;
> +	char *src;
> +	__s64 result;
> +};
> +
> +static void *wp_copy_thread(void *data)
> +{
> +	struct wp_copy_args *args = data;
> +	struct uffdio_copy copy = {
> +		.dst = (unsigned long)args->gopts->area_dst,
> +		.src = (unsigned long)args->src,
> +		.len = args->gopts->page_size,
> +		.mode = UFFDIO_COPY_MODE_WP,
> +	};
> +
> +	ioctl(args->gopts->uffd, UFFDIO_COPY, &copy);
> +	args->result = copy.copy;
> +
> +	return NULL;
> +}
> +
> +/*
> + * UFFDIO_COPY drops its locks to fault in the source page.  Re-register the
> + * destination without WP while it waits there: the MODE_WP copy must then
> + * fail instead of leaving a uffd-wp bit in a VMA that no longer has WP.
> + */
> +static void uffd_wp_copy_reregister_test(uffd_global_test_opts_t *gopts,
> +					 uffd_test_args_t *args)
> +{
> +	struct uffdio_api api = { .api = UFFD_API };
> +	struct wp_copy_args copy_args = { .gopts = gopts };
> +	unsigned long len = gopts->page_size;
> +	struct uffdio_zeropage zeropage;
> +	struct uffd_msg msg;
> +	struct pollfd pfd;
> +	pthread_t thread;
> +	uint64_t value;
> +	int pagemap_fd;
> +	int src_uffd;
> +
> +	/* The source fault comes from the kernel, so no UFFD_USER_MODE_ONLY */
> +	src_uffd = uffd_open(O_CLOEXEC);
> +	if (src_uffd < 0) {
> +		uffd_test_skip("cannot open a kernel-mode userfaultfd");
> +		return;
> +	}
> +	if (ioctl(src_uffd, UFFDIO_API, &api))
> +		err("UFFDIO_API failed");
> +
> +	copy_args.src = mmap(NULL, len, PROT_READ | PROT_WRITE,
> +			     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (copy_args.src == MAP_FAILED)
> +		err("mmap() failed");
> +
> +	if (uffd_register(src_uffd, copy_args.src, len, true, false, false))
> +		err("register src failed");
> +	if (uffd_register(gopts->uffd, gopts->area_dst, len, true, true, false))
> +		err("register dst failed");
> +
> +	if (pthread_create(&thread, NULL, wp_copy_thread, &copy_args))
> +		err("pthread_create() failed");
> +
> +	/* Wait until UFFDIO_COPY blocks on the source page */
> +	pfd = (struct pollfd){ .fd = src_uffd, .events = POLLIN };
> +	if (poll(&pfd, 1, 10000) != 1)
> +		err("no fault on the source page");
> +	if (read(src_uffd, &msg, sizeof(msg)) != sizeof(msg))
> +		err("read() failed");
> +
> +	if (uffd_unregister(gopts->uffd, gopts->area_dst, len))
> +		err("unregister dst failed");
> +	if (uffd_register(gopts->uffd, gopts->area_dst, len, true, false, false))
> +		err("re-register dst failed");
> +
> +	zeropage.range.start = (unsigned long)copy_args.src;
> +	zeropage.range.len = len;
> +	zeropage.mode = 0;
> +	if (ioctl(src_uffd, UFFDIO_ZEROPAGE, &zeropage))
> +		err("UFFDIO_ZEROPAGE failed");
> +
> +	if (pthread_join(thread, NULL))
> +		err("pthread_join() failed");
> +
> +	if (copy_args.result != -EINVAL)
> +		err("UFFDIO_COPY returned %lld, expected %d",
> +		    (long long)copy_args.result, -EINVAL);
> +
> +	pagemap_fd = pagemap_open();
> +	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
> +	pagemap_check_wp(value, false);
> +	close(pagemap_fd);
> +
> +	munmap(copy_args.src, len);
> +	close(src_uffd);
> +	uffd_test_pass();
> +}
> +
>  static void uffd_wp_fork_test_common(uffd_global_test_opts_t *gopts, uffd_test_args_t *args,
>  				     bool with_event)
>  {
> @@ -2403,6 +2501,13 @@ uffd_test_case_t uffd_tests[] = {
>  		.uffd_feature_required =
>  		UFFD_FEATURE_PAGEFAULT_FLAG_WP | UFFD_FEATURE_WP_UNPOPULATED,
>  	},
> +	{
> +		.name = "wp-copy-reregister",
> +		.uffd_fn = uffd_wp_copy_reregister_test,
> +		.mem_targets = MEM_ALL,
> +		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP |
> +		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
> +	},
>  	{
>  		.name = "minor",
>  		.uffd_fn = uffd_minor_test,
> -- 
> 2.56.0
> 

-- 
Sincerely yours,
Mike.

