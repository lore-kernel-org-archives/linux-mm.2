Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15916C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC8D6B0099; Mon,  7 Sep 2026 11:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84656B009F; Mon,  7 Sep 2026 11:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73526B00A0; Mon,  7 Sep 2026 11:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965A16B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:15:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AA17A3C53
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:15:31 +0000 (UTC)
X-FDA: 85187315262.07.CE9715C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id BCB72C000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:15:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=euGPfO0e;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788794129;
	b=wtj3Hlvnm92ZzvJaolJv5YjRLnYibFf+aeLQvO19OC3W2NfAj4srr+01lgFlPQNrO/fWk1
	wkbAInePTAy12LiRqBCCODbcQGAxHO+ARLU4Otk3W/nZvJlR17yM0r1Oyy4AhIJGZ6mMru
	XFGbWNnPSp3DeHGMiEJlZ/1RKplspgQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=euGPfO0e;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788794129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LI25JDv6LdNw5GdP3MdBucH0tpqtW3EinfdRXPIOwiI=;
	b=hHX64sNTm1Upg37VlFSbXELo+4Rlo+Z7CjgrtQ9MMBicI/iTFJ7RO6Kg+gCNRlzKTzzhk6
	ZN/ChsnxeZjFSgfzte2PjLf+y+PTyokfbyZ+U62FYO6wtspep+sw89tBDnpRt3lhHDCvby
	fz7GcMeV0wSBk/XJS1iAKyxPdPohQ+U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16D8660D87;
	Mon,  7 Sep 2026 15:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE94A1F00A3A;
	Mon,  7 Sep 2026 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788794128;
	bh=LI25JDv6LdNw5GdP3MdBucH0tpqtW3EinfdRXPIOwiI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=euGPfO0ehic5DgwGGkfjKu2JXIQIkYF5QqhsNhhQ8GYQ6fP8C8RvWTRpMyrfYxOOh
	 VLCa5/GQbIbRsqek+3ZUjTVrd6DJqgCtI/fiw8SJWuTVbR/d9LHrA3tCX0kW/cmw60
	 WDm/ASKaufbBR6jq781kYTujJNTKx/CePweRVq5wf0Wo43SaHaRNfSzx59dXpywJ6Z
	 jIanAfMNDKZwsax14FRMi5tpTo8JYLLlvJ34HImhgkH+VtNrZY3TDhV1kdRpx8rJO+
	 NPQznX5FP+rFbTQ0MgfjxS88Wa0zLAnFJuqbLkUAr1jkwBYAXKytu1k4lhP7ZuiqdO
	 JKzXdjX5y2mTQ==
Message-ID: <b0400430-c3b6-40d5-b476-49189b1cc292@kernel.org>
Date: Mon, 7 Sep 2026 17:15:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 6/6] selftests/mm: add a GUP selftest
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
 linux-kernel@vger.kernel.org
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
 <20260904123631.198697-7-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260904123631.198697-7-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5xf1o1ms75cbz1iwm7yc3xrz1izr9bj8
X-Rspamd-Queue-Id: BCB72C000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1788794129-765392
X-HE-Meta: U2FsdGVkX1/rLNbjANuGCfZlJ25WU+8NWrudk6cI/f6EYJih7Gc9IVOV8k4/BdK8y0uk/G/9lKLBqx9Akcytwa+975FG7dhtxN2F5n1djqqghlByfxoIoEdIpJJKgv1lMQHQYcxXgNVMbmqjcMMA/8o5a1HWP8yo6igUM8d3de6WzugOBi/l2Od+D9gpuvLEbGmmDGOjNpctb9igVN4K457go+pE6kWCldT3lwwr6KBFm49VOqO5RQn0mNkzXRBC+aDJ3sUEq+lvofHH3/tvUSuszgPBKfv7abivq6zgm9n5YGHW9me30jfCYcYwolLsE+E6rRgdS2JHqRkwGcjaC0m/btltJO1mlmst8JwRUYVX7R7s4u1jE25vLiNAdWImR0rSJvChwVbiFpaNbN7XWiOAGAD3PyQmLZBOlQV0TO9RP1Y/fRhUDlp3UScZyMw2XprDvTNtVT7FNSGn/xEDGmk88HGmC9r0iI5yM84ya7iXErS/laX6aKukzfFl1vGHAJlc+GeWdDHQWMBKqikN5BC4hXboSc3Nsun5md4euaQRjDHsNg8qyBmNcAhpCMBn2/6+rnWMhGNpiWOrgcPXGLyyICID9/8bEQTUdvbgreu9//avPwV+XfEAETuvZ/M/kcf3rdN3WvaaU9WQpgcs24/ZU8dv+b3YbplzVQG+ZdsbqdpBtzv55aALcMVYegT133UxRgrjMU5Lpq2I9qkvMKTzFZDI0512X6m7ae8aDbXrERE9i9QIWgQzOX3RqYgfCUKAqhOuOpgFaxWUHkgaMsSr/BA3/VXnguBoeZAbuSrWhKfWAMLmKxQqd6+7xEYb71YJXWpTrlUl8zbhk4HCnyLWT1ZtxeJWIJrpbtS/Y6ooVmB4baXesuzuyIFRbqyQahKddwgGDHvIGD0yBC+mgWA8kGyume+f7PEZ82p6w2+YjAvH2mJdRCiLSO+jMJeF6GB9bq63FLAmc08bpD/
 FFBchKx5
 UfaHVMULZZhb9hp5ecyca/Vq4fjNACJMNyz/kPZHCVQUtpZThrrvN6uNdSF1PYTxUvFdpBrXG4F14aRIMGNGQAYU46bPVqb0XboUYpTMehyBvEIvsE1vPy9V24jKvSkiBBfTILRDn3EGs/ebZo+pD32yllr8L2UfWrHYjxF7gRs9DdeP1ppqBIoXPgLHoiLY0tCisXjuGOFxHaBYsM/lweqpHYjOJw0glLg7Jd1YQOVa0sL8MAwYbf0Vh8VICnrZ8NWq/fSiWsui0Otp8Pkhlvt6nAJ1IK9YVXLQAOtcF4QuI12RVI+ejKdyEnhsFcyMOpDdhjRnoeojr/TwIEqDV7uabqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 14:36, Sarthak Sharma wrote:
> Add a new GUP selftest which uses kselftest_harness.h. Cover
> 12 mapping configurations: THP enabled, THP disabled and
> HugeTLB, each across private/shared mappings and with/without
> FOLL_WRITE. Run 5 test cases for every variant: get_user_pages,
> get_user_pages_fast, pin_user_pages, pin_user_pages_fast and
> pin_user_pages_longterm.
> 
> Choose the number of default hugeTLB pages using a 256 MiB target,
> with a minimum of 1 page and derive the mapping size from that
> number. This avoids reserving excess memory when the hugeTLB page
> size is too large and retains 128 pages for the most common case
> of 2MiB hugeTLB pages.
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
>  mm/Kconfig                                |  21 +-
>  tools/testing/selftests/mm/Makefile       |   1 +
>  tools/testing/selftests/mm/gup.c          | 287 ++++++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh |   1 +
>  5 files changed, 300 insertions(+), 11 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/gup.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7a146b093de..1ca7de3e440e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17189,6 +17189,7 @@ F:	mm/gup.c
>  F:	mm/gup_test.c
>  F:	mm/gup_test.h
>  F:	tools/mm/gup_bench.c
> +F:	tools/testing/selftests/mm/gup.c
>  F:	tools/testing/selftests/mm/gup_longterm.c
>  
>  MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c1ddf59c0d71..79163b7d795a 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1287,24 +1287,23 @@ config PERCPU_STATS
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
> +	  There is also a test that allows running dump_page() on any of up
> +	  to eight pages within the range of user-space addresses. These
> +	  pages are either acquired via pin_user_pages*() or get_user_pages*().
>  
> -	  See tools/testing/selftests/mm/gup_test.c
> +	  See tools/testing/selftests/mm/gup.c and tools/mm/gup_bench.c.


BTW, I was wondering what it would take to:

1) Turn mm/gup_test.o into an OOT module (would we need more EXPORT_SYMBOL_GPL?
EXPORT_SYMBOL_FOOR_MODULE ?)

2) Move it to tools/mm/modules or sth like that.

3) Build it with the selftests etc

4) Remove GUP_TEST

5) Try insmod'ing it from the tools+selftests that need it.

[...]

> +int main(int argc, char **argv)
> +{
> +	char *file = "/dev/zero";
> +	int fd;
> +
> +	fd = open(file, O_RDWR);
> +	if (fd < 0) {
> +		ksft_print_header();
> +		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
> +	}
> +	close(fd);


I'm confused. Why do we have to open+close /dev/zero?

> +
> +	fd = open(GUP_TEST_FILE, O_RDWR);
> +	if (fd == -1) {
> +		ksft_print_header();
> +		if (errno == EACCES)
> +			ksft_exit_skip("Please run this test as root\n");

Wouldn't we want to fail here?

> +		if (errno == ENOENT) {
> +			DIR *debugfs = opendir("/sys/kernel/debug");
> +
> +			if (!debugfs) {
> +				ksft_exit_skip("Mount debugfs at /sys/kernel/debug\n");
> +			} else {
> +				closedir(debugfs);
> +				ksft_exit_skip("Check CONFIG_GUP_TEST in kernel config\n");
> +			}

You can remove the } else { part as you skip on !debugfs.

> +		}
> +		ksft_exit_fail_msg("Failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
> +	}
> +	close(fd);
> +
> +	hp_size = default_huge_page_size();
> +	if (hp_size) {
> +		nr_huge_pages = HUGETLB_TARGET_SIZE / hp_size;
> +		if (!nr_huge_pages)
> +			nr_huge_pages = 1;
> +
> +		hugetlb_setup_succeeded = hugetlb_setup_default(nr_huge_pages);
> +	}

BTW, why are we using HUGETLB_TARGET_SIZE instead of just using the
default_huge_page_size()?

> +
> +	return test_harness_run(argc, argv);
> +}
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 8f1e828e4f39..ae0ab5efabae 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -251,6 +251,7 @@ fi
>  
>  CATEGORY="mmap" run_test ./map_fixed_noreplace
>  
> +CATEGORY="gup_test" run_test ./gup
>  CATEGORY="gup_test" run_test ./gup_longterm

Nice

-- 
Cheers,

David

