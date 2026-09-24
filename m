Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11146C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6D76B0092; Thu, 24 Sep 2026 04:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE556B0099; Thu, 24 Sep 2026 04:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC456B009B; Thu, 24 Sep 2026 04:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBBD76B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:40:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30C73A59EA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:40:25 +0000 (UTC)
X-FDA: 85248009210.28.A4F3859
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 237D840002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:40:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="r/A95m+M";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SoK0CHxOKYWNiemqXSBek69K7OF/98M+zn1r0lnwMMs=;
	b=4iz3Tv6blyQiW1I8rQwi6vpQikADdL2gamv3CCbOBPJLcqiZVVJhZ/NNaxN3fW6eKfMdzf
	LQDeb8kdlUTxZ2VyHernvuI4pKazR7wxOzWVWp2Rrw54Uxhb7WBASPqaXpZHxwKH6Hp0Fa
	bVljqvTucyAU52NjV4rAhX115xn0Q/4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="r/A95m+M";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239223;
	b=rSsw3kxRtNC0MGGvDE/6JxA/5r84bST7m35sPcDdF2J2MVbZsoF70AlaRG1TKP8ZCud7j5
	UsJlN/YWucZXFf/KeZcBtvBisTp492wWAaTGY+rLR3g2YN5dFceT3qnKgWeTa6m0Y/50DG
	vw89pdH0Znth23pjkGLtDVt2ZwomHqU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A79981477;
	Thu, 24 Sep 2026 01:40:18 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D4F73F86C;
	Thu, 24 Sep 2026 01:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790239222; bh=MhBfAYuxvgKfiG3YkrVR2/wbxWCunlPFCUrfwTap79k=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=r/A95m+M/2PSch11YrrKkRkpvkDpNeDFxsDCMV8LiDUIHv1D+AOIumnheUw/cUBRP
	 mFpGM4PgceSqap/xH+4GiKQuqqj9ko5jIuQ+JWpkwmkbxCoRZ8HqghM9lAbKS4W0mQ
	 jAJzJnuTRTN7mwjPWS5sSW5U7YJmX+bDORIT4Eos=
Message-ID: <f09d40e8-abec-4dcd-a1dd-00de203dfb07@arm.com>
Date: Thu, 24 Sep 2026 09:40:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH] selftests/mm: fix mlock2 errno handling and false PASS on
 ENOSYS
To: Park Tae-sun <ts930@dgu.ac.kr>
References: <20260923-selftests-mm-mlock2-fix-v1-1-750b627854c6@dgu.ac.kr>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260923-selftests-mm-mlock2-fix-v1-1-750b627854c6@dgu.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gmyykhowmsaumf1cepech8u3fssagdmg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 237D840002
X-HE-Tag: 1790239223-840208
X-HE-Meta: U2FsdGVkX180Z0uRij2zhvwnCYq7o1lhgzimmvBM6qCCjwZtbfHsf0hMOBTRDvmsGASgHz2ESjZyK4T2KOXll2q3DONOHUPyHW/tVRD8rdvXSXjBcCf+avde8Ykg5FtiRBwIb140dlyRYN5Ojd4ZIsCf54VwYTmlJdR9fx35Wht8fBlwFOvtVcUsJqmmD5LRHRqjQfNZcEuOSU7WZl4d7LVX7nWjzFSc/MIFi406x9rJsVhDyGXlVOyouR5+f36nD4Apg8HzukzTFG7/pcHFl4s7Nohs8tQ2AhgUKNQz3+eVQytn6kTr+RjGPGNprPP8ptqgJWyryOKTZnrXDVHs5lgkIqMWw8hsIm+yEWi0z2oOvPvLncVZPxn5YMNzpGbtaU7PBm0tGagvdSOxwCmKRzWcTg3Gnu9KmItbameGAfu4IK2CBuBX93hQ2yajhyf/lA3b8othjvkTQrVHvO0C3Mv3Sud6gjQEviEkQF4KnlFN1ZEV+gffsTl+ijW4EIPqssxgTVSXge8ztBYgBE7j1fGPm2Z+0wOWePOUm1EvDLkHb//kAr5L9OpjZRm53nHhgYQUb3gQzOM9ofKbDXkkqPb/2d4oSY0fSUgHgnGDuFJilmzO5yHAI2FD+8eZ7RozAP5YtnKVq1s2p2fFsliHDKtNpEZjpd7pAmnCFyQYlSlzjBd7/5dZzbNKM755SwMS+F3w7pTR4ci7vn2ir07GsIEgSPACscRnOz6ggz+0uHbZiX3mmdnGpfT6c5WIpRa7EUe1N4XISRPpwnq5bd+QIFnLGTC0ZRpe9dGBI+K7uwVxZfDsQGzu15KptXyo9JYox/g1Q1ZPPl1E9VYXiSM/dA+Nw8/legHOg8YtahhfoDWFhLyz4ViBTUTk5jLqWPGgQSjhXxZUSEkNVt9ieehPMlRCPB6fBflhOmqBw8vlKCOGv2mnyCYRrVuPUoYvVwdpQP+hZ1kELgEQZd8TMm1
 CVpTws8V
 FRx3VzaOPxTkRU7DpRZ8n571qm6a4/DuAZ4uB/HRXAW1wXPzPqvj5dX2TRhUzF0w0KVKDyMxrIx9vnVLRCptXNwUZufn9vRMM6ns1C+zASN1+OoDSyvN0Vv5Q7pWFspR1wB4CdEzkUhMap2bdRcqAms7jy5ufkroi/2WY+zRQFuOQCCzIL1w0yzrxglKmJXG74TNzo0kCycpMKHFawd7nliunu4UM0esA3JHUZiLhnkHpwmZdlMFHvk/EghQ12v2seO+An6rpd+WK6xFyw6D8zZ599Sta9wSvlrU+qXT2CEk3N5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/09/2026 10:26 am, Park Tae-sun wrote:
> While inspecting selftests/mm syscall wrappers, I noticed that mlock2_()
> in mlock2.h handles the syscall return value differently from other
> wrappers:
> 
>     int ret = syscall(__NR_mlock2, start, len, flags);
>     if (ret) {
>         errno = ret;
>         return -1;
>     }
> 
> Commit 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
> introduced this intending to make mlock2_() behave like libc by setting
> errno and returning -1. However, glibc syscall(2) already returns -1 on
> failure and sets positive errno. Assigning "errno = ret;" overwrites
> errno with -1.
> 
> To verify this, mlock2 was disabled in the kernel (via sys_ni_syscall) to
> return -ENOSYS. Testing revealed two interrelated defects:
> 
> 1. In the unmodified test, mlock2_() clobbered errno to -1. The check
>    "if (ret && errno == ENOSYS)" in main() was bypassed, resulting in an
>    immediate crash in the first test:
> 
>        ~ # ./mlock2-tests
>        TAP version 13
>        1..15
>        Bail out! mlock2(0): Unknown error -1
>        # Planned tests != run tests (15 != 0)
>        # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>        (exit code: 1 - FAIL)
> 
> 2. After restoring mlock2_() to directly return syscall(), errno correctly
>    retained ENOSYS (38), entering the ENOSYS check in main(). However, it
>    then called ksft_finished():
> 
>        ~ # ./mlock2-tests
>        TAP version 13
>        # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>        ~ # echo $?
>        0
> 
>    Because ksft_set_plan() had not been called yet (ksft_plan == 0) and
>    zero tests ran (ksft_pass == 0), ksft_finished() evaluated 0 == 0 as
>    success and exited with KSFT_PASS (code 0) without any TAP skip header.
> 
> Fix both issues by:
> 1. Returning the syscall() result directly in mlock2_() so that errno is
>    preserved.
> 2. Calling ksft_exit_skip() on ENOSYS so unsupported kernels report a TAP
>    skip ("1..0 # SKIP ...") and exit with KSFT_SKIP (code 4).
> 
> Verification on the mlock2-disabled kernel:
> 
>     ~ # ./mlock2-tests
>     TAP version 13
>     1..0 # SKIP mlock2() syscall is not supported
>     ~ # echo $?
>     4
> 
> Re-enabling mlock2 in the kernel confirmed all 15 tests pass cleanly:
> 
>     ~ # ./mlock2-tests
>     TAP version 13
>     1..15
>     ok 1 test_mlock_lock: Locked
>     ...
>     ok 15 test_mlockall_future_droppable: droppable memory not locked
>     # Totals: pass:15 fail:0 xfail:0 xpass:0 skip:0 error:0
>     ~ # echo $?
>     0
> 
> Fixes: 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
> Fixes: 65c89684896d ("selftests/mm: mlock2-tests: conform test to TAP format output")
> Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>
> ---
>  tools/testing/selftests/mm/mlock2-tests.c | 2 +-
>  tools/testing/selftests/mm/mlock2.h       | 8 +-------
>  2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
> index e16e288cc7c1..144b550813a6 100644
> --- a/tools/testing/selftests/mm/mlock2-tests.c
> +++ b/tools/testing/selftests/mm/mlock2-tests.c
> @@ -502,7 +502,7 @@ int main(int argc, char **argv)
>  
>  	ret = mlock2_(map, size, MLOCK_ONFAULT);
>  	if (ret && errno == ENOSYS)
> -		ksft_finished();
> +		ksft_exit_skip("mlock2() syscall is not supported\n");
>  
>  	munmap(map, size);
>  
> diff --git a/tools/testing/selftests/mm/mlock2.h b/tools/testing/selftests/mm/mlock2.h
> index 81e77fa41901..4417eaa5cfb7 100644
> --- a/tools/testing/selftests/mm/mlock2.h
> +++ b/tools/testing/selftests/mm/mlock2.h
> @@ -6,13 +6,7 @@
>  
>  static int mlock2_(void *start, size_t len, int flags)
>  {
> -	int ret = syscall(__NR_mlock2, start, len, flags);
> -
> -	if (ret) {
> -		errno = ret;
> -		return -1;
> -	}
> -	return 0;
> +	return syscall(__NR_mlock2, start, len, flags);
>  }

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>

>  
>  static FILE *seek_to_smaps_entry(unsigned long addr)
> 
> ---
> base-commit: 518e5b794c06c0f0eb40df3e202274a66202c137
> change-id: 20260923-selftests-mm-mlock2-fix-fee59d31b124
> 
> Best regards,


