Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32AFCCF2E6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E82C6B026A; Mon, 19 Oct 2026 09:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD896B026C; Mon, 19 Oct 2026 09:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAF06B026D; Mon, 19 Oct 2026 09:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 199166B026A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:51:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F85E1C3F77
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:51:45 +0000 (UTC)
X-FDA: 85339513770.20.F682170
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E5172180009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:51:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kedHgPQ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792417903;
	b=WTl/ximfF7NSTFgf9Oh7+fuqCaq5FgVj7yiZEOE2YOcX3IgW5jX6jbkGWJ0EbmedxnT6qD
	oRn99PPo3WcmC3S2V82C9KqXUgXgH6d16JxV6U064R0wODqZ9OOeMm4l3WRasHe5ZWt6pM
	T9hZJSZXTN/RpeTbF8hbYnHlr4zTmoM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kedHgPQ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792417903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DoshP9R1xMB2Brh7195PJTWyn0JrbcznglLz6Oe4+g=;
	b=QozQWTMfq1TzYhecHTDcwj1qn+9YY+PZzcZfoQ2ztZ41hQVqHOXpYO55O7nYUBsVY6P74Y
	6P1qUiJ4aiwf4cWVEye7WezfCjrg+umCwbUNJQciOIO9xg4DZCPgsl4rYjWnl6Y8uDQgEs
	15NHmG2LigQTR11Er9SzzYAvz3r+Bm8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69AA460238;
	Mon, 19 Oct 2026 13:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD041F000C4;
	Mon, 19 Oct 2026 13:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792417903;
	bh=8DoshP9R1xMB2Brh7195PJTWyn0JrbcznglLz6Oe4+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kedHgPQ5/MjBobdknoNxY3rNJAzcZKbN+qUia8TMgugleJgbhHs+Dbuphixq5anO/
	 +QRf0JOMZWQd/mbSmUkqNIaQmNd5YXHMAEwZmK2qPW8g0vwFU5u9wlIqE3HGT1IRWa
	 MGNoyOF7/wiH2ocLaJIQuaSKDQ/UEny+B3o2Vn0TeARKFIIT6VTwdHL6gq5EKL2xBr
	 Vuc1dfGCoUT5et2QgVbY+30Q0rzdO+yjDKl6jtHTxqQjOAD+qmKo1pPKGvWcM+pVF0
	 qRrmSdP0H7dtmDTbKCrgz1vDRN0WxB+o1uM65KpnwemIG+JCjw8pgWUNdbIUHTx5gy
	 N9oK9JDc5SQOg==
Date: Mon, 19 Oct 2026 14:51:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: check MREMAP_DONTUNMAP mlock accounting
Message-ID: <atYgQ-K4oIxvCSUU@gremlin>
References: <20261006064120.6796-1-azpijr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006064120.6796-1-azpijr@gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: E5172180009
X-Stat-Signature: qxehktie589uyg9mxr6wgj5qgjydd8mf
X-HE-Tag: 1792417903-106525
X-HE-Meta: U2FsdGVkX193qFJpCXMSvIOnJcAh3hFgkJC+AL+zWsljjX6sruZH08V/hJXsjW1w/6aNMeTZvr6cQEZr5bPP/+IuKclKUs/QdkbCc/3NiZCotpv6CURKJH8Xl9VoK8nuJrTKHEGPHgRVvWzlQKxRP3pDMXceNdqfbQy0SRtUVQ6gXFA5LN08lE8XiPtIh2RrN9v1LMOOA0EvIn6DaWdQ8yH4DCPBPreddlZ+YyBZWlBElP4KFEOaiHCbYNgVyyPHsk1LT5OlpONWOH6OfBVHcToC3puSVlMqhO5uw2qJbbEMJ5UOaoPUwe48GQocTQjtLhvQiMDVPkFpYKJ4nyW61SSpOA1Q2Q27xETuy8QlQRrZU0dBiuFf5OQhzBB3GoAdU4NIeYoiLHIV77QPWc5qLtCataAkZPXMkZHMI4zfIMqv35Y5c44w50nGx7RvYtfX/Oybogo6YyCmPHHovgmRMrFyJVWfS97s30a9cjj9Ev5qk1oMFYYfvQjPZK0wpJKjto5739ElHyzW8Hffnxw0+BpQSYPGfhCOPDSO+qIxVLh9sbqGO+jPNpzLvoB0lspaea+Vg1+e5v5dRv46CVRzCYJ1wZTWO3Vy+xN3O5yKuHnleL2C7qwyTz9yjtWEP+5lmtmprtA2hKAztJqQoF//g143aFGhZqnl19ShKnZJEfGC4Uhfu7m0zeunFhK2DpapmAuSJGHItMSjGeZL3/TsGNh5PgWloYWIhgo1nRIfAoCfC4IEfV0ZpIAlYm7gpwLLO/kFC15K73JKB6GLJttPzLad0MEo+K6c2JkMu5ygAA4+tDu4jvLcJfTv0WdAddN06FHQHfkybCy2Rh9iJppsoQys2YvaJsu4ARuyUalHuDIroXv4dkbHmG5pXGvBH6Jr1tPxQzAdahLRbk7CnBiSWlXSdSJx1KoSRzcv/Pi1TCS1DE0q4lIsm8jHj5d2paTCg2J2d4WFPNJBpX2t6Lm
 MOrNQkL6
 pvmvB0BPNihudaSejfifAM0aq4V07l7nhdqQm2qpCwt1rUkxVj6PiD/k/IbQ3yhn+/wfrHE0BpkjmmCyHM6BcyRUhrpLZZvSRaKkTuZqpyJ/J6DeTKwSkPgBuCmPNV//bf9Z7tR3hy+wuI/lFASAdXMQuD0n/oFBSdFYhEOpR1XJclcIUtpbL9lJNhoBVmF9oL8ep98uRAnYheQa9HEdcAncsDBRdN73S3+huUurZwN1onuRvIW5KbsxdvuCE/KzPMF5ISPwxRrw1JrU0zRP6XTazeiwuG0/rx9K83k8eYSGFq2vNXye/aFPzbZAnkJUag1Gj79E8AbTkFjrpNbL0+fmHSJxH0gHPfybG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 08:39:01AM +0200, Jose A. Perez de Azpillaga wrote:
> MREMAP_DONTUNMAP keeps the source VMA in place, but clears its mlock flags
> while setting them on the destination VMA.  The "mm/mremap: fix two issues
> with MREMAP_DONTUNMAP" series fixed two cases where this leaked
> mm->locked_vm:
>
>  - an unfaulted mlock-on-fault VMA moved behind itself self-merges, so the
>    single resulting VMA loses the flags without the accounting being
>    dropped;
>
>  - a partial mremap() moves only part of the range, leaving the pages which
>    are not moved accounted as locked in a VMA whose flags were cleared.
>
> Add a test which mlock2()s a source mapping, moves all or part of it with
> MREMAP_DONTUNMAP, unmaps everything and checks that VmLck is back to its
> value from before, and run it for the self-merge case and for a partial
> move with and without MLOCK_ONFAULT.
>
> Verified on x86_64: the three cases fail on mm-unstable with the two fixes
> reverted and pass with them applied.
>
> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Thanks for writing tests for this. Looks generally OK to me, so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> v2:
>  - Reduce the churn (David): fold the three cases into one parameterised
>    test and drop the child process per case, comparing VmLck against its
>    value before each case instead.
>  - Use the file's BUG_ON() for setup failures and vm_util's
>    check_for_pattern() to read VmLck, call mlock2() directly.
>  - Verify against mm-unstable with the two fixes reverted rather than an
>    older -rc, now that the series is applied.
>
>  tools/testing/selftests/mm/mremap_dontunmap.c | 63 ++++++++++++++++++-
>  1 file changed, 62 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/mremap_dontunmap.c b/tools/testing/selftests/mm/mremap_dontunmap.c
> index 96ba537facf7..5ca33d9d42af 100644
> --- a/tools/testing/selftests/mm/mremap_dontunmap.c
> +++ b/tools/testing/selftests/mm/mremap_dontunmap.c
> @@ -7,6 +7,7 @@
>   */
>  #define _GNU_SOURCE
>  #include <sys/mman.h>
> +#include <sys/syscall.h>
>  #include <linux/mman.h>
>  #include <errno.h>
>  #include <stdio.h>
> @@ -15,6 +16,7 @@
>  #include <unistd.h>
>
>  #include "kselftest.h"
> +#include "vm_util.h"
>
>  unsigned long page_size;
>  char *page_buffer;
> @@ -335,6 +337,62 @@ static void mremap_dontunmap_partial_mapping_overwrite(void)
>  	ksft_test_result_pass("%s\n", __func__);
>  }
>
> +/* VmLck from /proc/self/status, which is mm->locked_vm in kB. */
> +static unsigned long locked_vm_kb(void)
> +{
> +	unsigned long kb;
> +	char buf[256];
> +	FILE *fp;
> +
> +	fp = fopen("/proc/self/status", "r");
> +	BUG_ON(!fp, "unable to open /proc/self/status");
> +	BUG_ON(!check_for_pattern(fp, "VmLck:", buf, sizeof(buf)) ||
> +	       sscanf(buf, "VmLck: %lu kB", &kb) != 1, "unable to read VmLck");
> +	fclose(fp);
> +
> +	return kb;
> +}
> +
> +/*
> + * MREMAP_DONTUNMAP clears the mlock flags of the source VMA and sets them on
> + * the destination, and mm->locked_vm has to follow.  mlock2() a source of
> + * num_pages and move its first move_pages to gap pages past its end:
> + *
> + *  |------ source ------|... gap ...|-- dest --|
> + *
> + * then unmap everything and check that VmLck is back where it started.  With
> + * no gap the destination is adjacent to the source and could merge with it,
> + * otherwise the gap is left PROT_NONE so that it cannot.
> + */
> +static void mremap_dontunmap_mlock(const char *desc, unsigned long num_pages,
> +				   unsigned long move_pages, unsigned long gap,
> +				   int mlock_flags)
> +{
> +	unsigned long size = (num_pages + gap + move_pages) * page_size;
> +	unsigned long locked = locked_vm_kb();
> +	void *source, *dest;
> +
> +	source = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	BUG_ON(source == MAP_FAILED, "mmap");
> +	BUG_ON(mprotect(source, num_pages * page_size,
> +			PROT_READ | PROT_WRITE) == -1, "mprotect");
> +	dest = source + (num_pages + gap) * page_size;
> +
> +	if (syscall(__NR_mlock2, source, num_pages * page_size, mlock_flags)) {
> +		ksft_test_result_skip("%s: %s: mlock2: %s\n", __func__, desc,
> +				      strerror(errno));
> +		BUG_ON(munmap(source, size) == -1, "unable to unmap mappings");
> +		return;
> +	}
> +
> +	BUG_ON(mremap(source, move_pages * page_size, move_pages * page_size,
> +		      MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED,
> +		      dest) != dest, "mremap");
> +
> +	BUG_ON(munmap(source, size) == -1, "unable to unmap mappings");
> +	ksft_test_result(locked_vm_kb() == locked, "%s: %s\n", __func__, desc);
> +}
> +
>  int main(void)
>  {
>  	ksft_print_header();
> @@ -348,7 +406,7 @@ int main(void)
>  		ksft_finished();
>  	}
>
> -	ksft_set_plan(5);
> +	ksft_set_plan(8);
>
>  	// Keep a page sized buffer around for when we need it.
>  	page_buffer =
> @@ -361,6 +419,9 @@ int main(void)
>  	mremap_dontunmap_simple_fixed();
>  	mremap_dontunmap_partial_mapping();
>  	mremap_dontunmap_partial_mapping_overwrite();
> +	mremap_dontunmap_mlock("onfault self-merge", 1, 1, 0, MLOCK_ONFAULT);
> +	mremap_dontunmap_mlock("partial", 3, 2, 1, 0);
> +	mremap_dontunmap_mlock("onfault partial", 3, 2, 1, MLOCK_ONFAULT);
>
>  	BUG_ON(munmap(page_buffer, page_size) == -1,
>  	       "unable to unmap page buffer");
> --
> 2.55.0
>

--
Cheers, Lorenzo

