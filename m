Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BE0C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A623B6B0096; Tue, 29 Sep 2026 04:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39D76B0098; Tue, 29 Sep 2026 04:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928A46B009B; Tue, 29 Sep 2026 04:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 662496B0096
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:18:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAD051A0421
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:17:59 +0000 (UTC)
X-FDA: 85266096678.11.238EEF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 213061C0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:17:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d8gHhrqH;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yz0jiAwudK9OW80keceLOYRv/mXKUZ2PZm0r7rgGpDQ=;
	b=YPhHtBhMcFGEI7ijqq3F6kAfqF+i6F0noU9iMu5DGQGEVLC6z/YKJNwXk49iia+aQdYEr3
	U4ejd55Y2zKiIPp8sEMQ+UFQiCgLdTGhJ3lpDz+xIS1JhHoTuIk68wU32k3Etz0P77RMip
	uBRlSj10f9lLjzoC2Rj79e43W1N2vQc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d8gHhrqH;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669878;
	b=plUyi3xMrthm6V3g/NaxBuVECLffHVgUI8kCp7jI0mbzf59AlUryii5RptF84d7msLNZBi
	q2GCsjjA5G0X9MFv3VNkCmZ8uExoC+kfgCWFtiFLxrZ5lC06vU0Erj60UFADRSya4Mmb9V
	07wRYzOiE7vLI2eViV3463WKlv07Wg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 590BD40966;
	Tue, 29 Sep 2026 08:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702BD1F000FF;
	Tue, 29 Sep 2026 08:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790669877;
	bh=Yz0jiAwudK9OW80keceLOYRv/mXKUZ2PZm0r7rgGpDQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d8gHhrqHVJEOUzsa6bUhJydt7Kk6k+QGl3qstMrjo1Moa9IdIQ+hGPaTnG68pvM8c
	 6rY0mPW06vljN3J9Mhtd3s09LgV43cXdQPUBm54cVJt6BxFbrvbZlqOReKwD7uPQzf
	 Kx7ZZNXuViXEIUCO0hH8SfJ8L8lbEWH6lKV74QnkK8HaMVNdMLKABYcYaRFtdSuY7k
	 /JykC0QMD2G4/xT4jAbmiGfukp/bozir8K6aSLgV6va9zc+aSAR8xLYxzWuBi9Q1w4
	 hXoJN5CdZGH25i+uTz+vFvYJ7fwRprbX329EuxLfmyIq4VvaJQQEyyBUpQBnTnAwF2
	 Ux1WE11eJAmIA==
Message-ID: <86f16f56-c204-4629-b2b7-460ecfbb6dda@kernel.org>
Date: Tue, 29 Sep 2026 10:17:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 3/9] selftests/mm: mremap_test: fail unexpected
 mremap successes
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-4-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924050009.19974-4-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 213061C0002
X-Stat-Signature: agyyp1wjgpugpe81sced1y3aayxu6c6x
X-HE-Tag: 1790669878-484721
X-HE-Meta: U2FsdGVkX189gPfXXZASF8dY5lPipMhRNADrYGwfaRa9U2RLkgCTFU6OauXdLprVXnN8XRnnTO77++aNQvT/YHp5ZCdjpUBV3wweXjBHJkW4CxBnFkCJmtFcH7P1ND2ROtXWZ9JVNqnUwO1jpYGulvVIzaqf1Z+7OHgOuuiwJNlUHqne1PlmaUQ6QF6UQ43rvVBchkLIVqRe/d9/koKfp0HNTqKfyW0rCcjzcWaZcHoEJqnJvS9xKO7VVbRemDFZxv9oGD6TKLn7E8JiYQTLC2zeswpMuMoUxiAuuE6uZCJog6H+wziC8aZE/RniyVDBVXocQkS7/5F+qHrXI8mb7+xUWt6ZI5TSE+jkHhg+/roOU4ve1OoPQW7lxkRD3TWrlWHh3u2eS15jC4PTH+7n+BlMjv/V7tWByjDWiig8qa1jKLfuCEkOM7h1+BFL9IF0bZv7HpLpoXd0QOZW3rpxD9TSrXn57u9A6MWEhXKBFfcHmpFhmk84XtQN8E2GzTU6eRMcZa3CxAujc57rQXbsRu2W36wYhfbcno3Q3c5GvIMdR3apjPhpufgW6WuRxvWYD9QrWkfPTRc067R5+sf3abAtFkssiVko5OlutDbyK8UAYX3xaWvbRV+Zu5b6QA8CmqKSkGue3Wb9FxUKCMY4UJrvEyf5VYuoKviXhaob6iqPYZIg6ncHYCQGqj3vsQi135Q9REvzE0XFa78YnqxfcLwwdLUDdtncUIEFpozwBzGAMQJFuHxxHAtnaDIanvoMBQ0N9EZ4gViDtsKKyPVJ+C9Uz+5yeFa4HlOzTjB1Yxzs4nLbTaoO0hRTSgWfG4W76NoA03upmb+etNg9l4j3s6VjQroeEkGvBTLKpW6A00LXtcY1JkJPFRncCPOhAiffjsDG24K0hLpMZm4bWOIOhjkfRZ9OBAZLVoYwzVtVnFlgVKLwu/MyvGjP3mV1Q35cLTCeE1vyD/nya0qZL9h
 X+JwKqBf
 UjZpjlO/0ld0YwA0TqT5ffgiNv4VMXL+rOn3t8LKQEucq7sfg32EriF+0ppNG27YYexBZDfk0C6wHO2hOQiNQghE1xge2gKXvBMRpkVrK3oj+RSSOdIxGlpv83f0TB5xx8TfZ76z+jIj3HPzRXyLucRXGWPDTnQyZXylC8mQNX0CXp2KdtYF1opFvSuoXu8r+g7+pJBwPNbkRU/U2zJUG+NcXOrSdJ+AxQtYwWqLJaTmVU8DNuO1SFh0SNJmtEm0psRCezWZVBcfALCLwYWXKjVA68ckPx7oHq3SvfRZ4JXbVYmLYei9yyOL4rqdNv96hnLysjBDdXXpRoW7L0YaJhsXwAOdwqe9uh/vNo3DbiP2iBcVfTiCIPp2Ww+2nwNO/Tmo9ihNSqEXnQJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 07:00, Sarthak Sharma wrote:
> run_mremap_test_case() reports a test as pass when remap_region()
> succeeds. But if the test was expecting failure and remap succeeds,
> it should be treated as a failure and not a success.
> 
> Check test_case.expect_failure on the successful remap path. If
> it expected failure, report a failure instead of success.
> 
> Fixes: 7df666253f26 ("kselftests: vm: add mremap tests")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  tools/testing/selftests/mm/mremap_test.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index a5813a5e8f5b..ba9b7f7566d0 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -1138,12 +1138,15 @@ static void run_mremap_test_case(struct test test_case, unsigned int threshold_m
>  		else
>  			ksft_test_result_fail("%s\n", test_case.name);
>  	} else {
> +		if (test_case.expect_failure)
> +			ksft_test_result_fail("%s: unexpected mremap success\n",
> +					      test_case.name);
>  		/*
>  		 * Comparing mremap time is only applicable if entire region
>  		 * was faulted in.
>  		 */
> -		if (threshold_mb == VALIDATION_NO_THRESHOLD ||
> -		    test_case.config.region_size <= threshold_mb * _1MB)
> +		else if (threshold_mb == VALIDATION_NO_THRESHOLD ||
> +			 test_case.config.region_size <= threshold_mb * _1MB)
>  			ksft_test_result_pass("%s: mremap time: %12lldns\n",
>  					      test_case.name, remap_time);
>  		else

That sounds about right to me.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

