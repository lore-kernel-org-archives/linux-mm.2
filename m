Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067E6C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94B946B0098; Mon, 27 Jul 2026 08:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5946B009F; Mon, 27 Jul 2026 08:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0676B00A3; Mon, 27 Jul 2026 08:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDD36B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:31:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6CD0C06A1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:31:19 +0000 (UTC)
X-FDA: 85034491878.10.2553840
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 01346C000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:31:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JoTWzgdQ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LqId8m1vq2FGslYePEEUuishiJMVsFHV0R9ARG65yI=;
	b=JOiwAT/Ft2iEgNAHpc77iPwWk3aI7cti28bgt4O+QZaFKLz5lpF89WLy/5A73EpoE67NHM
	+YdpmBjITCGdw/xhArJvtFMsSvtVZoW1+MccrYuUfp1vZCdISmGgb4NsXUENUm7a2mL8jP
	c1y+m6zvglh68Or/4RNDp9C6PtUAPHY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JoTWzgdQ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155478;
	b=gqVvO2GPHZaN0fQtaewTIYlJwhQlGRI9ALdT/XgQUqf6Vr2lh0H4+Jf0xdVK64HuvE4BMq
	qTIqutlUQQpHusvFn6r8d6SNlYztbD4O8saWIz0Q8BV3+y3E2mql2nqjr1xalhpBXirCzO
	t0DIexgNpqSXlpmJw6LBcXXcl4wkNRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EFE5601DE;
	Mon, 27 Jul 2026 12:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBFE1F000E9;
	Mon, 27 Jul 2026 12:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785155477;
	bh=1LqId8m1vq2FGslYePEEUuishiJMVsFHV0R9ARG65yI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JoTWzgdQGhtdQmvGGNiKuhMTuSefXoyFJnOl+4BRdR7ZK68BBtaYSZkKoUiR2n1Dq
	 nZCU18j1nkp27QFu6JsHHVz4qhzYE9Fsffiibsk1YhcyAUMXoabkjCA8UlI8IJhM+3
	 35uQJvVNzO0V/QiZn8v3nqjVmhsKIgrmrlm7EuKGWuX5KEB+LuwuCjABvJE66Qzek1
	 B0CrFfRyG9mMKQDy32LU3tAIUIMqFrnKUvN3gbGPeI8agjBGOlR/GKK6cMZD0e5R/t
	 4SnXCiPCrvneAX6O4FjAuFp8R6iyjQ7pnRFt8icskOMGeYud0ctHrcsoB9+4PqMvYV
	 2ORyxsb4ecNLA==
Message-ID: <a811c371-ef3d-4932-a9d4-2390a98e1382@kernel.org>
Date: Mon, 27 Jul 2026 14:31:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: unpoison pages in memory-failure teardown
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260727095415.385026-1-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260727095415.385026-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 01346C000B
X-Stat-Signature: txwskixp4q9ad1rptypkbd99zixsu3g6
X-HE-Tag: 1785155477-281070
X-HE-Meta: U2FsdGVkX1/nppg8WA5Aobk5Di8y82tA6YyiBxDMe+SyAPgpxMHyk3c4N1BltgDL+qmjNA0VmDv2ivBL3RCdco46qEbdmzpQomiJ46nRYjOb7oNYlML9kfmaONQhZZQFF3AxU7nCaynNjlwC0UPwQJm3NkJXIHrMMTGadd7SkoXJYA6tdzhxV3Z2AaCdDlCusRJyGPmm+PXXvy2uuGdkYC771JCI19VONhr/ACjZKaqOnbdSRDra395JaVtpmTZzIJ2+uIiCCYQJQ2SVf7KVub3R7pkmQAnfV+QBnyZHkVL94h7Si1XpsYTC1Er9KXM56CdQYmHRZ3ALN1PhDyeXPyZj05EBoW7vnPKXyAZQVlUxLlY5MvBgdrxSX6PuYPqsaAcztMDtfm29SK4eg0/BUztBLRh6U/wg3vCviH1+feDKT63r7eBLSfZxUSye9XPZFpADGvFA+nRXATyLgP1T7v5BkFDhHxs9BSczOsUsJTkaRPwvUSniiN3l8SZCgSwjnw2F9Si3C6QbuRMOgG0iSGyrAUeTqIjdivn/zOeGiIjiCHFlz4KHKN5ARn7X2XkPKn7J10PGiweS2KcizLhepdHFhK3RCoH8FKSyQsurwGTV/DTzShzX8qYeaanVUwzmHbBywkIydaCA4ag77taiGZgdrBWeyfyjLO9XQOxSqYSPSai/LMXuVN4LKUCndC2aaXcAVBZ0kNqzNAWlULK9rb9baEgennN3zY2KksB9gnTF62yVZbCXymPRSQgl4+Wx+E7CMIu1IjudKUHIXVIvmjHejrZAUSBn7P3+6DakpI4jpOtUXjrCWC9LFV2G1zPlZmRF0QtiCEmQCbFV8oPsWHxNcwcQClWfw0T6DRv3gCfd17hHV7LbDsCWohC1cHrXyE0nOP+7bIGlRgxfmQ/B/wn1CxtRBwro+fgeH5UREm7EMECWZokJOnHJCnjKVOxE5WDDyBeKON63eJjdspq
 Harv/qJL
 ieRNh9LRwCb66cSXCEGNfxrl3oEv2kc0rrSYGOMVSLJADdiYX5Q9cr/0XrjLaUPqd2qwRH2mkzXEbGgi8yA+eSv2fSxpCY+jQ1awB+cx5Gy4Qj7N/R4AMHvBqyf7OJXPxnHLaklhXRssFroHoQSNgPIMVIVL+8EUTnifP4DyJ1HAxtgH+Y9zNUt1MUOO28AleeuUPIK7cyU03k/pBZqlkCfIaBUY7rxCCZl4cJGvjgDJ5loBtFpouw+U6uEjLpYFjf5R2/TOqFO407AJaw71i7Iuv7xKMpksh6Lpc6hYMSakGYSjRVwrg5hzS86tP1i4m+HSa27NN4aMbzsdlpShg1tccmmVp/PjzcLasWKNSp8g2qsrS8Pr1rEa7aX08968dzAmUjfY3yiwiyT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 11:54, Muhammad Usama Anjum wrote:
> The memory-failure tests call cleanup() only after all result checks.
> A failed ASSERT_* invokes fixture teardown and aborts the test, so it
> skips cleanup() and leaves the injected page hardware-poisoned.
> 
> Invoke cleanup() from FIXTURE_TEARDOWN() instead. Guard it with
> self->triggered so tests that exit before injection do not try to
> unpoison a page when no injection was attempted. This runs the existing
> HWPoison and HardwareCorrupted checks on both normal and assertion-failure
> paths.
> 
> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  tools/testing/selftests/mm/memory-failure.c | 26 +++++++++------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 5d00aab31f9b5..eaa8b9bd401a1 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -122,13 +122,6 @@ static void teardown_sighandler(void)
>  	sigaction(SIGBUS, &sa, NULL);
>  }
>  
> -FIXTURE_TEARDOWN(memory_failure)
> -{
> -	close(self->kpageflags_fd);
> -	close(self->pagemap_fd);
> -	teardown_sighandler();
> -}
> -
>  static void prepare(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
>  		    void *vaddr)
>  {
> @@ -200,8 +193,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>  	ASSERT_EQ(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
>  }
>  
> -static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
> -		    void *vaddr)
> +static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self)
>  {
>  	unsigned long size;
>  	uint64_t pfn_flags;
> @@ -217,6 +209,16 @@ static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failu
>  	ASSERT_EQ(size, self->corrupted_size);
>  }
>  
> +FIXTURE_TEARDOWN(memory_failure)
> +{
> +	if (self->triggered)
> +		cleanup(_metadata, self);

If the variant->inject(self, addr) fails, self->triggered would already have
been set.

Wouldn't it be cleaner to have a new self->poisoned that we set only after
->inject succeeded?

-- 
Cheers,

David

