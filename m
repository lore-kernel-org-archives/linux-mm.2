Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9961EC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11C96B00A1; Tue, 25 Aug 2026 06:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9146B00A4; Tue, 25 Aug 2026 06:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF3F6B00A7; Tue, 25 Aug 2026 06:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 729456B00A1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:43:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE4161C0EDC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:43:34 +0000 (UTC)
X-FDA: 85139455548.04.B1F73A2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC3B31C0002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:43:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V613aVVl;
	spf=pass (imf18.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787654613;
	b=IapTATZ8UUjuEtvG/wSTmkZUbkl8x+SIshMXlQKAowMaGs+btuIsJyiGpqugqH2LVIh8mW
	BYqEuQ/Ezf9nj+nxL6QxUKnqp2s/JX/8UTMsUhJQdv2vQRy4iVza5F5v/aqGWLtOHGFmqt
	iQHyv1CwWOJJYl1TDDt0kiEIk7+0920=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V613aVVl;
	spf=pass (imf18.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787654613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHkPAl0U4vPtqSHJC7sCUx31ZtP2dRbEnmShLBYvsAY=;
	b=aTFphfHalyE6wJHkpG99BwXbgalFRxc3dR1Gc9KQurHoopoz5w5V2dFjcA//7kPrKnAnJb
	LtrgtZVXQjPtq3KGn6f04YFTAmkV7R98vHTnGYl8SQLnJzTo3UBiZ0jmrU2Uc+FmUbbXQU
	Y2eLi77SWktCq7iPRQPQ3+xFQWYkLlI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE9BC1688;
	Tue, 25 Aug 2026 03:43:27 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A343F3F7D8;
	Tue, 25 Aug 2026 03:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787654611; bh=uVSJqJyxJ0TvdMw2vUR0bfwbD5X00jM75IHxQv4s/ZI=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=V613aVVlqKJ2ocqhG9J6MMdQH/0WsLyws3H8UwiHLi2n7Mp+K+qmCkbIUq5kBdgMB
	 DqW5nwRjbGAKtKZlf5GhKPAaZN1VBJTd7+BCrAlYSznOkvmQpDaBsmbkAildTpJp6W
	 6GJqarGfUwx7Nj0H0XAhHPZeWODJWgsTsAYhNXEs=
Message-ID: <d63e0faa-77e9-4598-972b-d7d9125cfc23@arm.com>
Date: Tue, 25 Aug 2026 11:43:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v7 0/6] selftests/mm: separate GUP microbenchmarking from
 functional testing
To: Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260813181230.483746-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC3B31C0002
X-Stat-Signature: mwgp3awb5onwxd9uu5s1ae95a8reytjx
X-HE-Tag: 1787654612-429044
X-HE-Meta: U2FsdGVkX1/q8SjpsDN9Bc8tzojsVznRENWMQPAKqEFxQoQ2/qxOttNlpT7OkbRze7oViNrgeLmSNcdL3vySa+753q18lobZRfcOyeppll6olfS0Kz0kh2BqWp2pq2qgdmuEj7h6Mym1WUKHGsKvC0Latei8rni9LjkEGWHJ+1HRb6UTVJOxMSTp+dBJpVGF8IIfI9aUq4qLH2yGcOsRezdocHQpCET3I2vqAphduJBh7conz+pbyU1ABcAVMTRduyHTasvlKpnBZwB+39kFsrRJ810SJLGiLPVKQk4vDJRkjnJPqxluO00kGQvvsq5lftgDeGeyBUaoPKcV4a1EcTJMoQSWLzu/YSY3083Ew16G2p4TvH/hNSDsPLW/tZihl93ougf0IX7CE/K/LLB4LXlau6WIhkz/HkU4UCCLqVtCryEmroAY0IvFq7A2Nuptl/ZpxnfPeQ4Vxlfyeex8Tdp1QFiKc7AqaTfbWPZLAPI492utHU4+qRR0crwyxCxIrhYmz81sOBEwt5G/yHiigYwwYxFu3UFqWgp53qL5UUZlELKdthoW6ndsgNl9vmHpVNkw/CybIsfeP9dZoLbx5u9P+KHkWvyMn5ddvqa6x0y0jJGecVFAiAiVAbjRz97p8YyDRcloaCKDMFW8aAtwATXObY+AlUwicHsdIQeaPVFjVkHSQZATrWKXiEeWpsK8oyE4LbklFOcYfH9MGWzjUGfWC8gtIjzZBMX106fJc15jltPYQa7XFPF5mhxqMCwkR0t8aroVar0wFFxFJbwb3STjJDfcxRiWcSbhSf1n2W1zEYSLfR4UVyqxR1aqRfhubKQbVvqW5BvKhug3SoWkMPZlNl/BJcwJ77QvqbUHjDUnSfWg4x2oij5T1hhNXtdjPhna8rcUBMotRCTsbX5/FxYloHYC47z9jgomliPADBk+xuZOWaYsblqHsjH26Y4pQuMfm/FJXMAdoyHOac3
 jlLmD6m8
 Xfkgf0ZBuVt8VF6+zqmYdLVoRY6vhkhstHDXEFt20zCqvOZTdGP1sRYy+KoYBAe5SyGh2JRLSUkpPoVhhAX3belZbozIJPzXMh1WwVB7tZvrzxjKb3Ge74XcnSDdhwssSLoQSUes3FAA0TICyxMGHcXfukO6WEXLi5T4HdNozTc+oGBmba8HV0Jx9KtBvQZMhrVnY1Pt94Q+dPBMhzW5zoBYYFNXSo1ViIRzhWzptTy3mw/RxMmUuX+I5hVLgYQD+vVfKl8+06X9rYfILpmVUAxO8fgvfGthAgx0B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/08/2026 7:12 pm, Sarthak Sharma wrote:
> gup_test.c currently serves two separate purposes: benchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK and PIN_LONGTERM_BENCHMARK) and
> functional testing (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST). Keeping both in one program makes the functional
> tests harder to run and report individually, while run_vmtests.sh has to
> invoke the program repeatedly with different options.
> 
> Separate these roles into tools/mm/gup_bench for benchmarking and
> tools/testing/selftests/mm/gup for functional testing. Move the shared
> file and hugepage helpers to tools/lib/mm/ so both programs can use them
> without duplicating the implementation.
> 
> Patch 1 makes read_file(), write_file(), read_num(), write_num() and
> write_num_ignore_einval() return errors to their callers instead of
> exiting. It also makes read_num() reject negative and malformed values
> and updates the existing callers to handle failures.
> 
> Patch 2 moves these file helpers from vm_util.c to tools/lib/mm/. It keeps
> them available to the mm selftests through vm_util.h and adjusts the
> selftests build accordingly.
> 
> Patch 3 moves hugepage_settings.[ch] from selftests/mm to tools/lib/mm/.
> It also removes its kselftest dependency while preserving TAP-compatible
> diagnostics for selftest users.
> 
> Patch 4 moves the existing gup_test implementation from selftests/mm to
> tools/mm as gup_bench. This keeps the code movement separate from the
> subsequent changes and makes it easier to review.
> 
> Patch 5 removes the functional test modes and kselftest dependency from
> gup_bench. When run without arguments, it performs one GUP_FAST benchmark
> using the existing defaults instead of running the whole matrix. Other
> benchmark configurations can be selected through command-line options.
> 
> Patch 6 adds a new harness-based GUP selftest. It covers THP, non-THP and
> HugeTLB mappings across private/shared and read/write variants. For each
> variant, it tests get_user_pages(), get_user_pages_fast(),
> pin_user_pages(), pin_user_pages_fast(), long-term pinning and both dump
> modes using four batch sizes. It also preserves the existing sparse dump
> coverage for pages 0, 19 and 0x1000. The HugeTLB variants share a one-time
> setup of 128 default-sized huge pages.

I tested the full MM selftest suite before and after this series and found
no regressions. The new GUP selftest and gup_bench also passed.

Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Thanks,
Usama


