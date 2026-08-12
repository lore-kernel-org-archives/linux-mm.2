Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E92C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1659F6B02CA; Wed, 12 Aug 2026 12:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1161B6B02CB; Wed, 12 Aug 2026 12:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C106B02CC; Wed, 12 Aug 2026 12:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D40456B02CA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:35:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57F8FC03BB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:35:29 +0000 (UTC)
X-FDA: 85093167978.20.42CD494
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5FDAF2000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:35:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p32sLKDB;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786552527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSUpb+6RTJo8/wzaYanzl+1PtFvc7EMmB59ikEuyXy8=;
	b=J3s7aPYO4xX5VjgD72P1lXTw1NM3OgZlFxlT5fvDiGHVX/avd2rAh04pfZ5XWwjIK2Za4u
	e1M5K7u22zZtHgTIsecEfY9IRinrqeWW2VxwVkVpLpp62sNHruJPcSBGFtGvyvNc10vW0Q
	Sq1dAXwSW21xUuT2FR5P4wHtI0O3TbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786552527;
	b=x0D4s9poUAj7s4w/k/lzdbvXcG8b3QGS2EzUNGTplcKpZmlSIxKZ3li9X4O3FqSsyWsaTP
	3zZyxQFGfG63GI0BjZ7wcSaPuFjZxvWO0JCQorOTjYyk9AlsZBsZF9ES9R9rdYecK0rKTl
	9S4yFJA8eDFrYOP1n+MqkqQtsGFm2fI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p32sLKDB;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F2C31596;
	Wed, 12 Aug 2026 09:35:22 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A69D3F632;
	Wed, 12 Aug 2026 09:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786552526; bh=vAzC+X//h7RK+RdYehEeObcWvbQXeEefa6AO2LuUd2U=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=p32sLKDBQEa8FZowC/IPTW+jRnqWB6wR0HJwddeZPIupI5zuWI2RDJ2GDulX9SC0j
	 K/0N3zp8pNXrmuJkvGN3GgIQOHS+JvDVws0V+pE30ns7ZPorEfMmBTfzQnVF3I6B9y
	 j1bCKvzFsVOpOGAt1Y90XAdlwMKJ8b/vVVE8oPhU=
Message-ID: <4ef8b130-6c36-474e-904d-901c0d967c38@arm.com>
Date: Wed, 12 Aug 2026 17:35:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, shuah@kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] selftests/mm: emit KTAP output from ksft_kmemleak_dedup
To: Song Hu <husong@kylinos.cn>
References: <20260812132142.582390-1-husong@kylinos.cn>
Content-Language: en-US
From: Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <20260812132142.582390-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: hm8u9a5o3janocuczhs4637wzpr54c6t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5FDAF2000E
X-HE-Tag: 1786552527-624163
X-HE-Meta: U2FsdGVkX19tc/qmSlaG9+63NTDBmE8tS7WYVRSpo7cmP6OxpiMgyrBcpI+oVgORCnjmbIhLPJG3+ZKB6a/Zg/5Ge+CpplRtlMl/zTLIHoa5SQEMxMEW4pZpQnQKuAgdN4gzPwGFlNILRp3SJn1yxW2V+EiZ7UNPlFqNAiY+u5U/Q6T76K/Korpsi8BuHb+Fc+oaZvnQwv+f7ws9aK9ALfjK+BBmTHUSWRGYz0QVOl+shL9yHiI9SeFRpmK0UexW/eQeeJJbHk0wL96bGymzpxupixk+2B7rjFJv1Zy11QJ9rNMv2WdfPnhRclqgv0xBMbSUQ9x+Mo1ih8viKD/VqKFfM/TX2+zFpga8kKZh3+IBTIS35PiJSb622pHZ/Cix/D5cs+RT84tnfeGcsqVTZ1M1+ugGdfTlY1BBSuwo6k960zb54wci91lSO+ftSZ5OGRuqSpJuTcxIruDYcbElRFhend9b47tbtRVUtor4QTy7cwapz9j7k+tokseelbMxYu2kXkzm2Ps0fexIkZ4HqbMkjFEupFIC5WKZlklC44IawyY59AKh8uYNCS1HxmaFShWhpHhgSexOBUmEXSI6CzB0SI/5KI95UkwqvPoqGOnAzrcLOZsPOCTZi+uK2ttTxXp+o3Rdv7zj4i31Ws2v9SfXzUw9QyXIHsnbkk/SKWjod64JEd0t2f7KRODn7Xgeuzpv4FYTKEdYpnvdWq0ciCZ1kHA2EStnpwwDhzfkM2ONB3yZHL1D8iE+bQWcwoUVyCFAKhYJiZTpugFgD1Z6n8JQAf6KJFZ5ZRxJBwFhqhCaE6zqExzwWeNMwt48QJ6Q748RUhyW0znWjjKmD5N9DfAd+ER6fqiLQsBFsT+rjWR9LqonLRp5pbaJgb2KHW7GFwrnE0Yo3c89xSxv3TUFyHXtIVk7J1P+Gs6HRBKw6TPyyBHgIMHiPVaH1tSrlN+jxAbyNfqTWrwfZw4Gi0x
 HPvq6+Di
 r97tna0Aw0RkloL/JbApG6r62pBuL73kkqfQOiw8PBGaCmRGX1XPBStv8ls1/3JQ2mR1dbS4QZPMbDhur8pQglyURRZ5LNLipSrrW8F3aqi3FVOJBa5B1tMTmXCG4vsP5gUx2K0yllIWP02OwCmW/aW4tSpm1qP3bGczYfFbd3SSIKbvbzwwn4IymXkPz2XLZur5FanGSIitS0i+dDf9QA8LUrpJp3c1CC3L7h2mTzYMTI7Bat8rs3KwhMyiKvQ2HViJ3vsncxVMaMxCMstNnHDFT8b/kHAqQ+qEWvaDK+EbZdZXq4wEnVwRjSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/08/2026 2:21 pm, Song Hu wrote:
> ksft_kmemleak_dedup.sh reports its result with raw "SKIP:"/"FAIL":"PASS:"
> echoes and bare exit codes instead of KTAP, so parse_kselftest.py cannot
> read it.  Convert it to the ktap_helpers.sh API, like its sibling
> ksft_kmemleak_confirm.sh.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  .../selftests/mm/ksft_kmemleak_dedup.sh       | 20 ++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> index d01950244490..2db7f006808f 100755
> --- a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> +++ b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
> @@ -19,24 +19,30 @@
>  #
>  # Author: Breno Leitao <leitao@debian.org>
>  
> -ksft_skip=4
> +# KTAP output helpers (ktap_skip_all, ktap_exit_fail_msg, ktap_test_pass, ...).
> +DIR="$(dirname "$(readlink -f "$0")")"
> +# shellcheck source=../kselftest/ktap_helpers.sh
> +source "${DIR}"/../kselftest/ktap_helpers.sh
> +
>  KMEMLEAK=/sys/kernel/debug/kmemleak
>  VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
>  MODULE=kmemleak-test
>  
> +ktap_print_header
> +
>  skip() {
> -	echo "SKIP: $*"
> -	exit $ksft_skip
> +	ktap_skip_all "$*"
Please use ktap_test_skip to make it generic please.
> +	exit "$KSFT_SKIP"
>  }
>  
>  fail() {
> -	echo "FAIL: $*"
> -	exit 1
> +	ktap_exit_fail_msg "$*"
Please call ktap_test_fail instead here to mark the failure.
ktap_exit_fail_msg is usually used in unrecoverable error case.

>  }
>  
>  pass() {
> -	echo "PASS: $*"
> -	exit 0
> +	ktap_set_plan 1
ktap_set_plan must be called for fail and skip cases as well. So please
move it to the very start of the test.

> +	ktap_test_pass "$*"
> +	ktap_finished
ktap_finished must be called for all the cases (skip/failure) as well it
prints the final line that how many tests got pass/failed or skipped.

Please look into how other tests work  and then refactor this test
accordingly. 

>  }
>  
>  [ "$(id -u)" -eq 0 ] || skip "must run as root"


