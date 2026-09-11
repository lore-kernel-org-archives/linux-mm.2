Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B791CC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDEE06B0099; Fri, 11 Sep 2026 11:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D8D6B009D; Fri, 11 Sep 2026 11:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC706B009E; Fri, 11 Sep 2026 11:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8D96B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:48:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD131140274
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:48:29 +0000 (UTC)
X-FDA: 85201913538.30.C3764A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E57318000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:48:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZXJpZCg+;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789141707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSE0RFPcW66QetBMRHN3NYdbRmSwi1ygaMp/uike9ZY=;
	b=7uXvK70W6jAwl5FJIJuUY0HgGUc6CFIUpjkF2878BX7T02dIL9AKex6juobDHBsuKe4LgV
	qnVBwOdExeAT7vZQWfn4o8ZJou5ywNaq4SoIo45ENCZj/czlAEY9ulTOdAcCvfDaTpSrIq
	6xZTwQPEI5g34vd6mC/XBM8wors4Va4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZXJpZCg+;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789141707;
	b=Sp9VFo91i3sNU0nUBG2MKxM9NdPGrspRCW7MBtUKlox6AscR5BxzSvTLI5UgK3NcVorF9Y
	mhQgF+0nis1YMOyWXjZKzGPu/pb3PxxAeUWuM10jPSMFO73tWJQ7p0qlvnr+eatSsLL+bP
	mQfBSOlk6LiKmnlxX1j6ort0oOZvR8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3094560A5A;
	Fri, 11 Sep 2026 15:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B345D1F000FF;
	Fri, 11 Sep 2026 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789141706;
	bh=kSE0RFPcW66QetBMRHN3NYdbRmSwi1ygaMp/uike9ZY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZXJpZCg+Ka6sQVyvZMjIrT6bir9r5OrfoCjNypIUJsiKw3rmpiJr/dBK1p0h7Iwu7
	 sQAv+3e4cowP0A1D8qIKRj7Qi7F1x0NTMyuUYQME4Zr5xXRhG3glI476rxTAK05/cJ
	 4xhnU4imQl9Bd3yjIDZtueffrWuie/DtvHk1WIpOJeBH1ulLzFpVkCu0+2kQg0/TWK
	 rvEC3zUd9+3bB8gWMOGApGEME1E8UUy7KQ8VpN664AP09xRrVEZ/+h+xOnk94T3ko5
	 x4uwefjYLsf5zmgGZk9ZfLa4379XjfnvbWCDRrIZP/OUnuwdpcpuRGBPV+nPL77W4z
	 y0JQ91PEULNlQ==
Message-ID: <891915e3-3333-45f3-81a8-1ad38fa7ee37@kernel.org>
Date: Fri, 11 Sep 2026 17:48:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/6] selftests/mm: add a GUP selftest
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>
References: <20260911110950.200240-1-sarthak.sharma@arm.com>
 <20260911110950.200240-7-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911110950.200240-7-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gzx59wogbmo17uf6484i36pofu8cbfm8
X-Rspamd-Queue-Id: E57318000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789141707-947740
X-HE-Meta: U2FsdGVkX18aLcX5C8ANWWME6WC7m1++SRoqpPllFOJ6WDOQs2MZASeS4g1WGO3C2Q2NU5y0piAmzufCBtP7m9TuaEe4qkXMGoYXWOZlPpX8zaHNPqMTEaNNvsq5Jpzu/gX/Af1FU7U8owLQ0WnbpCX7i9odHg+iS+ezYheLPhp8aHadH0ewdz6lke+U9JlJC/jZpknlYrUTL03iA28yobiJp6WIPriGfddn/Fg2I8MyBPx/yxtz0O73k0acezO0bmYY2Knl+NJBk/J6cKUkir1RJdajJGNqObYlWL4AOUTA7xZ1MI1URtd8wfGgDLXubsV5w4PSNhdKyTqoK/ACeqiwI6XBiIYwKVGr3ykSS7r3Kh3//78F4PxDFpChF+3WhtW3/GnbgQoSZnR7Yfxprrpuq6qhBQcQBeZLsQ40dNGITZe5lLZ5FBIWDwnVR8itdnMeUscVlHNJQAgg7ZkQpjWC8oMPTTbcBuiqepKEIczURdqHafkMVhDoYyQBpNXMWcAMUraBn9w16bE/Q4pYCFCR5eJBdLGVXCCnkPndkyOiUHezvFBiThK6W1S5b1+kLz8JbZqRLdBk9Qy4otqQHlphpW1A3OOrgYsuLDTEA4BTPsi10dQoA+YWbaQJ3sBHIF8TONY9WfwEFPT2JmbXpqoKgeX3qIA9xBEevRr4Thv3mCg4zSzedsdSTfI+ZUzrKvcXlnqcCDv8iqbUAapDgZ7tX/Zs5QbsJGiV1MIBQSfbLvqM6SOrxEMB9eNMr2VG+NsfdSLVMoP8zXu4nNWTR/qf2fvHzlt4DWAnYyi7yPx7cCWeKGXvbmZwZ1lJwOCILsIOCQlvcxg5CZgdQdMYbCxXJkYp+EiPqR1lLx7u2UIsd360UnU5ur7b53o49101wFOjUb/t7ipTlN8w9O5rRC6t8fR8Hk6TRHXqgH9tKw47XhYkNhXfTbtWWqyvJ5O1+PnGuRF0a0yOujWUcIB
 dkL0l88B
 l8lstHBeO6xTj4AHT+h7To/P0aekwI4Xhj5BBion2uuaIkHz6I50viv1yj0j40Vpr/3yaMUCB4DS6bGfEXAb4omG9xXIPOAaK4XsXlzhG4E9CQFuOW+ZOHqr0rOBJRGykPij3y+Y/JTCBLYtqJoYpQRG+wozd1jy8lB9N04XYKOGW2R9skVZ/2e0FsPnYwFBwnWn5OeQiqzs68op/zTtjj4JtffqBfQeM9MNxwEYPexRokxzjxwZM3CEKARK/fxz+GEg4binTVq8qXQREeIPJcCaGpdFcMSM4JI3DZNtxVqpjDssWIrH+wg81fqlAkFtpNL63yT7ykgAeTd7l6hg6Op8hKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 13:09, Sarthak Sharma wrote:
> Add a new GUP selftest which uses kselftest_harness.h. Cover
> 12 mapping configurations: THP enabled, THP disabled and
> HugeTLB, each across private/shared mappings and with/without
> FOLL_WRITE. Run 5 test cases for every variant: get_user_pages,
> get_user_pages_fast, pin_user_pages, pin_user_pages_fast and
> pin_user_pages_longterm.
> 
> Use two default hugeTLB pages and derive the mapping size from
> their size. This exercises GUP both within a single HugeTLB page
> and across a HugeTLB boundary, without reserving an excessive
> number of pages.
> 
> Sweep four nr_pages_per_call values for each test: 1, 512, 123 and
> all pages. This preserves the coverage previously provided by
> run_gup_matrix(): 12 mapping combinations x 5 GUP/PUP operations x 4
> batch sizes. In total the selftest reports 60 TAP cases and issues
> 240 ioctls.
> 
> Do not carry DUMP_USER_PAGES_TEST into the new selftest because its
> output is written to the kernel log and the selftest does not verify
> that output.
> 
> Add the new gup binary to the selftests/mm build, run_vmtests.sh and
> MAINTAINERS. Update mm/Kconfig to describe the benchmark and
> selftest split.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  MAINTAINERS                               |   1 +
>  mm/Kconfig                                |  19 +-
>  tools/testing/selftests/mm/Makefile       |   1 +
>  tools/testing/selftests/mm/gup.c          | 263 ++++++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh |   1 +
>  5 files changed, 273 insertions(+), 12 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/gup.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cae3af861a7c..c47e655c4111 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17188,6 +17188,7 @@ F:	mm/gup.c
>  F:	mm/gup_test.c
>  F:	mm/gup_test.h
>  F:	tools/mm/gup_bench.c
> +F:	tools/testing/selftests/mm/gup.c
>  F:	tools/testing/selftests/mm/gup_longterm.c
>  
>  MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c180d40cd671..61ab1b8a2ebd 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1291,24 +1291,19 @@ config PERCPU_STATS
>  	  be used to help understand percpu memory usage.
>  
>  config GUP_TEST
> -	bool "Enable infrastructure for get_user_pages()-related unit tests"
> +	bool "Enable infrastructure for get_user_pages()-related unit tests and benchmarks"
>  	depends on DEBUG_FS
>  	help
>  	  Provides /sys/kernel/debug/gup_test, which in turn provides a way
> -	  to make ioctl calls that can launch kernel-based unit tests for
> -	  the get_user_pages*() and pin_user_pages*() family of API calls.
> +	  to make ioctl calls that can launch kernel-based unit tests and
> +	  benchmarks for the get_user_pages*() and pin_user_pages*() families
> +	  of API calls.
>  
> -	  These tests include benchmark testing of the _fast variants of
> -	  get_user_pages*() and pin_user_pages*(), as well as smoke tests of
> +	  These include benchmark testing of the _fast variants of
> +	  get_user_pages*() and pin_user_pages*(), as well as tests of
>  	  the non-_fast variants.
>  
> -	  There is also a sub-test that allows running dump_page() on any
> -	  of up to eight pages (selected by command line args) within the
> -	  range of user-space addresses. These pages are either pinned via
> -	  pin_user_pages*(), or pinned via get_user_pages*(), as specified
> -	  by other command line arguments.
> -
> -	  See tools/testing/selftests/mm/gup_test.c
> +	  See tools/testing/selftests/mm/gup.c and tools/mm/gup_bench.c.
>  
>  comment "GUP_TEST needs to have DEBUG_FS enabled"
>  	depends on !GUP_TEST && !DEBUG_FS
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 11ca9b11fef1..9c03624fd293 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -58,6 +58,7 @@ endif
>  
>  TEST_GEN_FILES = cow
>  TEST_GEN_FILES += compaction_test
> +TEST_GEN_FILES += gup
>  TEST_GEN_FILES += gup_longterm
>  TEST_GEN_FILES += hmm-tests
>  TEST_GEN_FILES += hugetlb-madvise
> diff --git a/tools/testing/selftests/mm/gup.c b/tools/testing/selftests/mm/gup.c
> new file mode 100644
> index 000000000000..31ae38e09136
> --- /dev/null
> +++ b/tools/testing/selftests/mm/gup.c
> @@ -0,0 +1,263 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define __SANE_USERSPACE_TYPES__ // Use ll64
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <dirent.h>
> +#include <sys/ioctl.h>
> +#include <sys/mman.h>
> +#include <mm/gup_test.h>
> +#include "vm_util.h"
> +#include "kselftest_harness.h"
> +
> +#define MB (1UL << 20)
> +
> +/* Just the flags we need, copied from the kernel internals. */
> +#define FOLL_WRITE	0x01	/* check pte is writable */

BTW, it's odd that we support passing GUP-flags ... we should probably switch at
some point simpler attributes (bool write) or custom flags (but we don't seem to
need many ...).

> +
> +/* Page counts exercising single, THP-batch, partial, and full-mapping GUP. */
> +static const int nr_pages_list[] = { 1, 512, 123, -1 };


Would we want to calculate 512 dynamically at runtime using the PMD pagesize?
Could be something for a follow-up patch.

> +
> +#define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
> +#define NR_HUGE_PAGES 2

I'd call this "NR_HUGETLB_PAGES".

[...]

> +
> +FIXTURE_SETUP(gup_test)
> +{
> +	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS;
> +	char *p;
> +
> +	self->size = 128 * MB;
> +
> +	if (variant->hugetlb) {
> +		if (!hp_size)
> +			SKIP(return, "HugeTLB not available\n");
> +
> +		if (hugetlb_free_default_pages() < NR_HUGE_PAGES)
> +			SKIP(return, "Not enough huge pages\n");
> +
> +		self->size = NR_HUGE_PAGES * hp_size;
> +		mmap_flags |= MAP_HUGETLB;
> +	}
> +
> +	if (variant->shared)
> +		mmap_flags = (mmap_flags & ~MAP_PRIVATE) | MAP_SHARED;
> +
> +	/* gup_fd has to be >= 0. Already checked in main() */
> +	self->gup_fd = open(GUP_TEST_FILE, O_RDWR);
> +	ASSERT_GE(self->gup_fd, 0);
> +
> +	self->addr = mmap(NULL, self->size, PROT_READ | PROT_WRITE,
> +			  mmap_flags, -1, 0);
> +
> +	ASSERT_NE(self->addr, MAP_FAILED) {
> +		int err = errno;
> +
> +		close(self->gup_fd);
> +		TH_LOG("mmap failed: %s", strerror(err));
> +	}
> +
> +	if (variant->thp)
> +		madvise(self->addr, self->size, MADV_HUGEPAGE);
> +	else if (!variant->hugetlb)
> +		madvise(self->addr, self->size, MADV_NOHUGEPAGE);
> +
> +	for (p = self->addr; (unsigned long)p < (unsigned long)self->addr
> +			+ self->size; p += psize())
> +		p[0] = 0;
> +}
> +
> +FIXTURE_TEARDOWN(gup_test)
> +{
> +	munmap(self->addr, self->size);
> +	close(self->gup_fd);
> +}
> +
> +static void run_gup_cmd(struct __test_metadata *_metadata,
> +			 FIXTURE_DATA(gup_test) *self,
> +			 const FIXTURE_VARIANT(gup_test) *variant,
> +			 unsigned long command)

We prefer two tab indents.

> +{
> +	int i;
> +
> +	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
> +		struct gup_test gup = {
> +			.addr = (unsigned long)self->addr,
> +			.size = self->size,
> +			.nr_pages_per_call = nr_pages_list[i] < 0 ?
> +				self->size / psize() : nr_pages_list[i],
> +			.gup_flags = variant->write ? FOLL_WRITE : 0,
> +		};
> +
> +		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
> +		ASSERT_EQ(ioctl(self->gup_fd, command, &gup), 0);
> +		ASSERT_EQ(gup.size, self->size);
> +	}
> +}
> +
> +TEST_F(gup_test, get_user_pages)
> +{
> +	run_gup_cmd(_metadata, self, variant, GUP_BASIC_TEST);
> +}
> +
> +TEST_F(gup_test, pin_user_pages)
> +{
> +	run_gup_cmd(_metadata, self, variant, PIN_BASIC_TEST);
> +}
> +
> +TEST_F(gup_test, get_user_pages_fast)
> +{
> +	run_gup_cmd(_metadata, self, variant, GUP_FAST_BENCHMARK);
> +}
> +
> +TEST_F(gup_test, pin_user_pages_fast)
> +{
> +	run_gup_cmd(_metadata, self, variant, PIN_FAST_BENCHMARK);
> +}
> +
> +TEST_F(gup_test, pin_user_pages_longterm)
> +{
> +	run_gup_cmd(_metadata, self, variant, PIN_LONGTERM_BENCHMARK);
> +}

Heh, is there actually a reason why these kernel things are called _BENCHMARK?

I think they are really just tests that can be used for benchmarking ... the
measurement logic is entirely in user space.

We could consider cleaning that up as a follow-up.

> +
> +int main(int argc, char **argv)
> +{
> +	int fd;
> +
> +	fd = open(GUP_TEST_FILE, O_RDWR);

Could do

const int fd = open(GUP_TEST_FILE, O_RDWR);


Thanks for doing that!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


I think reasonable extensions will be to execute tests on all available mTHP
sizes and all available hugetlb sizes, similar to what cow.c already does.

Can you look into that as part of some follow-up work? mTHP support will be
interesting for testing some of the patches Rik has been working on.

-- 
Cheers,

David

