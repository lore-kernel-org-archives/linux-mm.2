Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E563AFF60C2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 05:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED506B008C; Tue, 31 Mar 2026 01:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D796B0095; Tue, 31 Mar 2026 01:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C3D6B0096; Tue, 31 Mar 2026 01:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8DFA6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 01:29:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91D4CBCD6B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:29:35 +0000 (UTC)
X-FDA: 84605230710.09.A3E8726
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0EFC520003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:29:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LPPWc142;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774934974; a=rsa-sha256;
	cv=none;
	b=IfJk18HzwhRsbVVODlXAQ5Pwp3WoGpvimwh2II1Wf+XJtWSsKipD52W8R9lwWlaLNMmRvr
	l/2DpIyMS/3cKUa988IzB1OIgtx8krCDw4qoymqXlZRUbTIP42sZ5qGqBENyQPz4jV3P5p
	DTGW/RqeAK7/n+YvoJNKq0ylD/1VNQw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LPPWc142;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774934974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srKxrvIsugkMZWWkQDFXnD4/kpgXaLznfGz19EAT65E=;
	b=TYg/K6UvimVwY7AhlY0x6WvaM/E/z527YmbN0YEt8qX6bWL7qT8758L72yRSkI09pm7Cij
	bSQiOLg69YNPZe4aq52CWoSMkKhnmU6afe+R/7pprLE6kgV/yWXhBzD4yB0ZRAuk/9Umsg
	TqKcaePjnSYIYCH3FgJRr8y1uOdak8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60F1760145;
	Tue, 31 Mar 2026 05:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20A8C2BCB0;
	Tue, 31 Mar 2026 05:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774934973;
	bh=tEuorD7P4k0F88Y2/3UlSKoS5UGxiHdE86z8UjNtlT8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LPPWc142i4SCKqqkXT3ER2o4Air3R/3gnyEcgYDs/11m1tvEDnuCFLAxsF2m36G0/
	 nNnsWZQ0Yon2OsLJ63qLWvPcKm8M/jJmQuqERSxsp8XLiMapPlUyVvLV8zFUu7+aow
	 108/Jiobk6K0Gkbw66borcbzoZy5ZcL/C5l1sh7o=
Date: Mon, 30 Mar 2026 22:29:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] selftests/mm: respect build verbosity settings for
 32/64-bit targets
Message-Id: <20260330222932.a8c10bb3ea3e86581fcea8a0@linux-foundation.org>
In-Reply-To: <20260331040156.119158-1-liwang@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ao9w1fpthpm6j7usetq6sqq9ek3dwgu
X-Rspamd-Queue-Id: 0EFC520003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774934973-394718
X-HE-Meta: U2FsdGVkX1+PzugJK3XOjsAl3PwAoleVMHTS+Uwbo1XZ+SY6OUZGr5aeWHpUDR0PFPVU+CuXRqU6OPvOdl1jKdf2zaHU6AsQFoE0MzZIUuEqJ/e0/wt8q5VFLGq3mBgXZNiLiv+EXcB25AWkTeth5A54JWai8vxSnCkJgozkkE3MYBC9fAPdVx5GvoUwCRUv/xBg3jZNtxIVpQHSKMmPhcTBIATuDUKuehkNPxSEATB0aqj8UMC8zdQHX4Br5/56NViiLlD/Lx9Plu7LnYXiJDPtAp939q1e5aro7wQhdy7czhK6Vyqngr/quus3vFTdpVjXQqMmMN1f6X97u1VEk7i5+9Lo8vLqKhJYg79uS5ECk1lUnZ19Tmp8ATwKB05hLzHIlsYHidAvzrRezjQ1JnULJbjSvEGS9wwWhL938YrYPRREmczHhHXv0FpXUskdOhpKTeCBq7QmPFKuG0qwQ85cbA8w6/u2zcVLOAY0ZbknFTyYBZgicKX3j0A+Sufk6tAM4cpEcObf5wcs3S4nejUNbsYqH9jnDFxaDT69AeAh2X25l2iyJea8XlT2loII53FxBY81rVwCV9HYQKWyGHSjWf7bwKhGVW89Wj3AYN/7dy8zbv/+F+VrxjVhVT6sq+ZZjcc7xSBl9OybVcOOcVoO4SQzizJOmwNaf8dgagrtS/uY5/zMwvJ05fiCYjQtyA9h4qO0k96SU98gazcYa7GbJTuGEN4gNoTHxYE+/qtgX+sYSWwl1IfLiSw7lYL9KMw68FYO/RxVybpDIqYWi8axdF4FeAopwo/7McOpA/NAj62cb3lOO1U78E4fruFHkXGhm6utYWks/ifTrCW8lE1KAUtDpSyKHjQi2pCBeCxD5s42Ovqo1o2S+Wd/0vQ6i8406JnywZrybkoPKW7jsWDkRc9xN8fVf1xbSerILLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 12:01:53 +0800 Li Wang <liwang@redhat.com> wrote:

> The 32-bit and 64-bit compilation rules invoke $(CC) directly, bypassing
> the $(Q) quiet prefix and $(call msg,...) helper used by the rest of the
> selftests build system. This causes these rules to always print the full
> compiler command line, even when V=0 (the default).
> 
> Wrap the commands with $(Q) and $(call msg,CC,,$@) to match the
> convention used by lib.mk, so that quiet and verbose builds behave
> consistently across all targets.
> 
> ==== Build logs ====
>   ...
>   CC       merge
>   CC       rmap
>   CC       soft-dirty
>   gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
>                 -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
>                 -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
>                 -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
>                 -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
>                 -m32 -mxsave  protection_keys.c vm_util.c thp_settings.c pkey_util.c
>                 -lrt -lpthread -lm -lrt -ldl -lm
>                 -o /usr/src/25/tools/testing/selftests/mm/protection_keys_32
>   gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
>                 -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
>                 -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
>                 -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
>                 -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
>                 -m32 -mxsave  pkey_sighandler_tests.c vm_util.c thp_settings.c pkey_util.c
>                 -lrt -lpthread -lm -lrt -ldl -lm
>                 -o /usr/src/25/tools/testing/selftests/mm/pkey_sighandler_tests_32
>   ...
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>

wow, thanks, do you want my credit card number?

>  tools/testing/selftests/mm/Makefile | 6 ++++--

Before: 

ts:/usr/src/25/tools/testing/selftests/mm> make -j100
CC="gcc" CFLAGS="-Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..  -isystem /usr/src/25/tools/testing/selftests/../../../usr/include -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE= -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests " ./check_config.sh
  CC       cow
  CC       compaction_test
  CC       gup_longterm
  CC       gup_test
  CC       hmm-tests
  CC       hugetlb-madvise
  CC       hugetlb-read-hwpoison
  CC       hugetlb-soft-offline
  CC       hugepage-mmap
  CC       hugepage-mremap
  CC       hugepage-shm
  CC       hugepage-vmemmap
  CC       khugepaged
  CC       madv_populate
  CC       map_fixed_noreplace
  CC       map_populate
  CC       map_hugetlb
  CC       memfd_secret
  CC       memory-failure
  CC       migration
  CC       mkdirty
  CC       mlock-random-test
  CC       mlock2-tests
  CC       mremap_dontunmap
  CC       mrelease_test
...
  CC       merge
  CC       rmap
gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..  -isystem /usr/src/25/tools/testing/selftests/../../../usr/include -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE= -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests  -m32 -mxsave  protection_keys.c vm_util.c thp_settings.c pkey_util.c -lrt -lpthread -lm -lrt -ldl -lm -o /usr/src/25/tools/testing/selftests/mm/protection_keys_32
  CC       folio_split_race_test
  CC       soft-dirty
gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..  -isystem /usr/src/25/tools/testing/selftests/../../../usr/include -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE= -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests  -m32 -mxsave  pkey_sighandler_tests.c vm_util.c thp_settings.c pkey_util.c -lrt -lpthread -lm -lrt -ldl -lm -o /usr/src/25/tools/testing/selftests/mm/pkey_sighandler_tests_32
gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..  -isystem /usr/src/25/tools/testing/selftests/../../../usr/include -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE= -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests  -m64 -mxsave  protection_keys.c vm_util.c thp_settings.c pkey_util.c -lrt -lpthread -lm -lrt -ldl -o /usr/src/25/tools/testing/selftests/mm/protection_keys_64
gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..  -isystem /usr/src/25/tools/testing/selftests/../../../usr/include -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE= -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests  -m64 -mxsave  pkey_sighandler_tests.c vm_util.c thp_settings.c pkey_util.c -lrt -lpthread -lm -lrt -ldl -o /usr/src/25/tools/testing/selftests/mm/pkey_sighandler_tests_64
  CC       write_to_hugetlbfs


after:

ts:/usr/src/25/tools/testing/selftests/mm> make clean
...
ts:/usr/src/25/tools/testing/selftests/mm> make -j100
CC="gcc" CFLAGS="-Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..  -isystem /usr/src/25/tools/testing/selftests/../../../usr/include -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE= -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests " ./check_config.sh
  CC       cow
  CC       compaction_test
  CC       gup_longterm
  CC       gup_test
  CC       hmm-tests
  CC       hugetlb-madvise
  CC       hugetlb-read-hwpoison
  CC       hugetlb-soft-offline
  CC       hugepage-mmap
  CC       hugepage-mremap
  CC       hugepage-shm
  CC       hugepage-vmemmap
  CC       khugepaged
  CC       madv_populate
  CC       map_fixed_noreplace
  CC       map_hugetlb
  CC       map_populate
  CC       memfd_secret
  CC       memory-failure
  CC       migration
  CC       mkdirty
  CC       mlock-random-test
  CC       mlock2-tests
  CC       mrelease_test
  CC       mremap_dontunmap
  CC       mremap_test
  CC       mseal_test
  CC       on-fault-limit
  CC       pagemap_ioctl
  CC       pfnmap
  CC       process_madv
  CC       prctl_thp_disable
  CC       thuge-gen
  CC       transhuge-stress
  CC       uffd-stress
  CC       uffd-unit-tests
  CC       uffd-wp-mremap
  CC       split_huge_page_test
  CC       ksm_tests
  CC       ksm_functional_tests
  CC       mdwe_test
  CC       hugetlb_fault_after_madv
  CC       hugetlb_madv_vs_map
  CC       hugetlb_dio
  CC       droppable
  CC       guard-regions
  CC       merge
  CC       rmap
  CC       folio_split_race_test
  CC       soft-dirty
  CC       protection_keys_32
  CC       pkey_sighandler_tests_32
  CC       protection_keys_64
  CC       pkey_sighandler_tests_64
  CC       va_high_addr_switch
  CC       write_to_hugetlbfs

Tested-by: Andrew Morton <akpm@linux-foundation.org>


