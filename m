Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81900C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCBF6B00A3; Wed,  1 Jul 2026 11:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4606B00A4; Wed,  1 Jul 2026 11:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34F16B00A5; Wed,  1 Jul 2026 11:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 804F06B00A3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:12:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4469C1F4C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:12:53 +0000 (UTC)
X-FDA: 84940550226.02.F8FF4A0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9C38120002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:12:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=s81qyGVj;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782918772;
	b=KnDv2GHIZAMFSjcd8PJdk2f3tVzp4l6Eh5z6i0h+gd/5Q3l/yzbkrGh0H2FIDV26W75G2M
	gOvqGJ7W1mwK9HzT6SWd0pez4nvwSR0RFVvUQGI7CTYPSFWIZesvdTi3JCNW3GXYRfVd6u
	4srSIkp5UKCMvsSbbVYR98D0jp3Usoc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782918772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJSjfkB8u87VnE4SEpbldG79jYcWKV5CqJWF93HUm6Y=;
	b=6fQUhdroZINE6xmYivuM+pk70gn3s60uWG12tn4Vq0Ww1djqngHC67UEQ9jYs0fvFol+su
	gOrYbi2q9NKWfsIr7hCt5xw9cPAgZ21atSeMkg2mPpF44HYLX1+v4JsSb4nESrAaxwNTJm
	QvKnjVmdYQ8NBNhjquIjjNRurvYkHqg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=s81qyGVj;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F7082309;
	Wed,  1 Jul 2026 08:12:46 -0700 (PDT)
Received: from [10.57.81.2] (unknown [10.57.81.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08EDF3F85F;
	Wed,  1 Jul 2026 08:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782918770; bh=w1BNEJPXIDy9algqgCKAxD3B5zfQNFh2VUrM/S84y8g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s81qyGVjJ0IVzVYP6kgfRrvQWpL9l+uqqZm7X+9jKd1w+D7OUr1SGKAKVhYBxXyYZ
	 ABq8+8QLSHBgSAHpKgBQPiyFEnYv7x0xspwb9aG9eXz7fswyMYB/DrWoyWqEOXw7Z6
	 gw1tLyTU4RaNk2fMGekvwKRKsUuFaykZSz/rRAGY=
Message-ID: <fd31a9bc-f2be-4be7-ac4d-c79f2a117683@arm.com>
Date: Wed, 1 Jul 2026 17:12:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] selftests/mm: refactor pkey helpers and fix mmap
 error handling
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, keith.lucas@oracle.com, maddy@linux.ibm.com,
 usama.anjum@collabora.com, yury.khrustalev@arm.com, jhubbard@nvidia.com,
 joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260630073235.3802271-1-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B9C38120002
X-Stat-Signature: ugmuhsmyzerz4uiieh57dkrcuxa53ngp
X-HE-Tag: 1782918771-579454
X-HE-Meta: U2FsdGVkX1+qQQ5pPbyeX3RmdT1gSp8R3PtKuu6GUwgCfNdFHtH4T1Z4egwSCVP+7wGje1368yuHR45K6ctysLBel3+I5sjkeD0WN8OJkhHqYlyThEekgnSaYlJDfwIWBSDNDkMpozzdAqUZuAz+tYFnvYASithchCKMrU1L5bG6Q+oAAJBd5jc3R9/Dg9SGh+5U8PaScPOlwxnmZqKAt0uteclOHn64TzBwfySAI8Q/jC9YKlDoihBspLx6jW+zsTan5fxiCEL82+KsGnY6hXTURakw2Xa9+tt5jb+hwWNG/eW95oXRszESeMnuGKPiybEw1gRLXJguhK4GU0aFLPvhi5H9X8DbNkNBAZqeXB9SHdiR68CbyNFkZhO4TT5tDE6Cu3xT2bcdVIUFlQI4krlFRyi/B9sHUDQBMW2YrvCUao9RDyp7LVELK1hNanRL3zdD2PkgAz65iEtdrmKykZY+PRKYqpOZNypgpXa8eXSJdIkPDmxkFZKD/k5pslmSNrWWwrecjR5/RfoxiZBwmnZPYfAmB2/t8Sw5WeOd2Z09jtoRYaSPFAcSXuUzeUS0ZdxcXa89YjJGKakmamxqvoYld2yhB6IWRgD/sypL83nH2nKPczJeWgQCQ6hAQ1z3K29cVVnkNjiWmeOwsr5SW2pXYgx/d0Z/wxlX5GOdnA8hLSnNXRU89+k9mb/ycN//UahS8Zi3mHp7VHPGMkLlq886KNYVyqDniVMbUeRvGYulyjBUYZN8Q1tOArRhe1OLKWYpagB+AOvG7rAePaSFRYjuoHISWVIL2mStshXL7+VR2jnT/vTfI/u8iwT8ZrOp+scCqKZhlVUHwWcnSxJSMwFwlhTGwGBAUzeIliGo/V4EZ/T+WtH8np+hCKGkNvWtHLrWRIKkZ6q/sdsnVEPqC4oZeIL2H8pT72mEDTsNrhjsahdqKHTJC++URKL4JMObjvh9AXB2XIkFKoF83w7
 y1alP1Pe
 LGzyJxSUKuXyXgNENB9gReUx1fSZLWWGARXzYhyCCv3XJy7/H1ojDlVDKfQLhmYopmjopCH7He5sx422ewhWrsple6CukoLbmP2eJr04hd1I8k0ewKLsJuEAt6gof1EpP8dfsRoB3nQ347BOLGxvUf3TyRXUVrPa4X06fFuRAB0tLAUjro5JPxgj3qbD5nH7mlGziZ36Mx1YHklBZ77B8ySas2kxNMmDAKzGxoxPWJiJDive1/ByCzEWyFe7wawAy5kiebyF7rdAbtIHjoQz0ge8YIBcjA4KRkI528OdHAtCTqYUqM6aqt2fVxxgPyyhblHBD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/06/2026 09:32, Hongfu Li wrote:
> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and 
> per-test tracing for consistent diagnostics, and add missing mmap() return 
> checks with MAP_FAILED used throughout for readability and consistency.
>
> Hongfu Li (5):
>   selftests/mm: move pkey selftest helpers to pkey_util.c
>   selftests/mm: unify pkey sighandler selftest assertions and tracing
>   selftests/mm: use pkey_assert on clone_raw failure in pkey test
>   selftests/mm: add missing mmap() return checks in pkey tests
>   selftests/mm: add missing pthread_create() return checks in pkey tests

Ran the tests on both arm64/POE and x86/PKU without issue, so FWIW:

Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>

>  tools/testing/selftests/mm/pkey-helpers.h     |  4 +-
>  tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
>  .../selftests/mm/pkey_sighandler_tests.c      | 81 ++++++++--------
>  tools/testing/selftests/mm/pkey_util.c        | 86 +++++++++++++++++
>  tools/testing/selftests/mm/protection_keys.c  | 95 ++-----------------
>  5 files changed, 141 insertions(+), 127 deletions(-)
>
> ---
> v8:
> - No code changes (relative to v7).
> - Updated Cc list: added developers identified via `git blame` and
>   `git log` on tools/testing/selftests/mm/pkey*
> v7:
> - As previously suggested, wait for v7.2-rc1 and rebased the whole series
>   on top of it. No functional code changes.
> v6:
> - Add missing pthread_create() return checks (new patch 5/5).
> - In patch 2/5, call tracing_off() at the start of test_pkru_sigreturn
>   before the SIGSEGV handler is reset to SIG_DFL, to avoid leaving ftrace
>   enabled on crash.
> v5:
> - Use ret instead of child_pid to hold the return value of clone_raw().
> - Make tracing_on(), tracing_off() non-static.
>   Remove cat_into_file() declaration from pkey-helpers.h.
> v4:
> - Base changes on top of the latest mm-unstable branch.
> - Split the first patch into three:
>   patch 1: move pkey selftest helpers to shared code;
>   patch 2: unify sighandler selftest assertions and per-test tracing;
>   patch 3: use pkey_assert() on clone_raw() failure.
> - Use ksft_exit_fail_perror() in main() for mmap() failure.
> v3:
> - Use pkey_assert() for remaining sigaction() and clone_raw() error
>   checks for consistency.
> v2:
> - Update commit message
> - Move shared tracing and assertion helpers to a common file,
>   replace assert() with pkey_assert() in sighandler tests
> - Drop assert() from main() in protection_keys.c and add a proper error
>   message instead.
> - Link to v1: https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/

