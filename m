Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3989C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 08:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1466B007B; Fri, 24 Jul 2026 04:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572746B0088; Fri, 24 Jul 2026 04:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488696B008A; Fri, 24 Jul 2026 04:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 256176B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:22:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A037112021A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:22:14 +0000 (UTC)
X-FDA: 85022977788.14.3FD0AB1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8640FC000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:22:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AdMMi+Al;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784881333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzFh7CcpBCrPwXZDhxjoaOcW8ZjrFDk7RHqbv99ICuQ=;
	b=J4a1rUhhDWYZw+3vl55AC7X//0UigyB+ozPWiobWX0D6Vjmfxhw4BrXSXe19XCQWApHDCc
	OnTxyk1gyzE9Y9jBEfvKiPhmd73QUj+ZzzbuaFRkoT72bdnBAGIjBzb5sfMd/LTkJOjYa6
	/Y5c6KyrKkxZzeUd58vBMxhPe5UssDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784881333;
	b=pP1+qyo8CwKdHDwVUZ23h2etX9KQ7G0DHANB7wp0Ts53SL4ebgVN0ZSTwK2jvsir6CLp86
	7c+R+oKae6IaKd+uF03Kvgu9mge1HAHL4n/jKKsXKmZx6I44EO0KW10FIAZTE+DiYaJSRd
	6av/eHLPZ+MXa53v54sk9L8zl0JCkqI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AdMMi+Al;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A672C1477;
	Fri, 24 Jul 2026 01:22:06 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCFBD3F66F;
	Fri, 24 Jul 2026 01:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784881330; bh=mw8GMJBoAr0TSzOlQ2s8pvtCmil3Xo8vPxz6aH4bq30=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AdMMi+AlHl7dxWpvlR3U4+adYGUgCFMySue09WG0pcsg7WANzAfxP+jBFrmLeXmHa
	 Twshh24OCU7p7LMe+bU2EJ0MYwWbHEjB8iJKgJCDbQwu+LpnIvmUM19kK+vrUx2ugh
	 Oz89jPMLUfYSmCAPTkN8M0tpKQjYidHFO8SETJcc=
Message-ID: <b7f59901-f0d5-4ff0-839e-cd45440b87ed@arm.com>
Date: Fri, 24 Jul 2026 13:52:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: fix gup_longterm EINVAL error message
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Sarthak Sharma <sarthak.sharma@arm.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <8A3ADC563A32EF67+20260724065929.1474539-1-zhaozhengzhuo@uniontech.com>
 <23557F4CB8CF36FF+20260724074603.1479243-1-zhaozhengzhuo@uniontech.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <23557F4CB8CF36FF+20260724074603.1479243-1-zhaozhengzhuo@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8640FC000A
X-Stat-Signature: 9zeizgqtjdathuxkxzj1if3nrbjrbgf8
X-HE-Tag: 1784881332-253758
X-HE-Meta: U2FsdGVkX19zau8cR6Z2zOTZg5ENESS30u7U7n8m68VOWiwKUMOQgEHXsvPOl+G6UBb6ynX2cGDcLq2SzpgtYU7JBDER2Ld9kC3LxyrLdVBwq1y51t2MQ0vIKK0VfU5L9sO6CDejOoBLR7D4ewFmdKQTL+Ujz4SjUge1P3UjGUw7dv38jhTnIof9JUHGx1poawyYTFGF3WCmVeNleLnZrl3SnhCdTt8ISb/h6YbCmCwpaTTOi+mKN32bEGn7F3+ES0l2EppTszj875aNMAIBnvCi9OZVIknmGy96SG5Kjs+kZA+osnpewG9W6Txif3F5KwB33Z3M89tuuTAvqPp2cp9HN/83rZAfE1/4j7kNvRh8+yrjEgoDNJLuWS2xvljMw/9JieOwPPzAO3+L0+r6Xl58l9PezsmO8IC3Y2bAhmLAUN/5itzBscDxi7L6vvMHA/CkQ3AdHHnyMb0ZaL89xwQ8+DM702R3EgeMXnlcHfr0Omvp0paJEaPfG2oA/+QYGircpTFHrsVZqFQJWT3avZrWPXPdCFk2wedDRSWqhy4DsjbicEz/IFtvl2u6wlaVLouVeG1PxG5hF5GPWJeIL4HwQLyS1W2e93Mnj2TIdwdi6x1TMydoijrZlVM1gVpHQJrEqdKkqpDOWWX+Cyvx5i5QDZfqiYybcDl/Mkos1ikTTYt0yP5x1Hm+MigbVPrgVRCRNsc+NUA/Nn1xUrr3wx6dWTwnVNSoCAPSqI0VcGznsjnBbvtj8lGi4nyPmkpmA8QC+XH416xTRX3b17f/CN1QkeFmA7RrBQwin88awVq0GPkpLjTNFfOQX8/gAOTQGJ+AN97Lb61zOiW68xye60uSlohF6BIasV/WxzL79azRWdXy92r/NNq8E5jKNSytVQRtNd3L1D5pa8ac5b+Don/I1k28glo4qjL66fF4zKnbUY+CTfTzszrepwuiomM13GvfIvyQgP1bPythbRg
 TOwk0fj9
 oKEn7yLEOnpIvBZJlsT6B6y+U4w62zWt6dfIC0dhYkvYGMIBrtEZVQY4aTZAgHdtQudNe3ODqtg4QmvpBHtpubUXyzJVgd62D9TmmEdCUUzkiEEO7fCXaOntZWP/u2jhvbsZtInzohbh8l/lkG09wjaah6/T/JmfRz+J+3dPOLdmKfVsXqo46q+4tozg20BOh/JjOQCOuf+FUxtFN+XqyfHiFEo01Fchal9zCFE0VzgDoI2OZoVA0wSYG72opehdElTxws6ykzYgvQJrYehXiRWQSN6/iZ3SuUom/uRPdBmNmJ8W3rabXxAwe3+8XXoLudanmP3Tzejy3Vn3C3PfmOJyGSgG2w5i4tqOx4Iywj+Hop29ALDrj2SKeyl5/SWDGdf/MPDVW8N7EkckSK8Vu98+upw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/26 1:16 pm, zhaozhengzhuo wrote:
> The gup_longterm test prints a literal "n" when
> PIN_LONGTERM_TEST_START fails with EINVAL because the string is missing the
> newline escape sequence.
> 
> Print a newline instead.
> 
> Fixes: 800ddf3cd74b ("selftests/mm: report errno when things fail in gup_longterm")
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

Thanks.

For future, please send the next version of the patch in a separate thread, not as a
reply to the previous.

Reviewed-by: Dev Jain <dev.jain@arm.com>


> Changes in v2:
> - Add Fixes tag as suggested by Sarthak.
> - Add Reviewed-by tag from Sarthak.
> 
>  tools/testing/selftests/mm/gup_longterm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
> index eb8963e9d..c03b4f891 100644
> --- a/tools/testing/selftests/mm/gup_longterm.c
> +++ b/tools/testing/selftests/mm/gup_longterm.c
> @@ -196,7 +196,7 @@ static void do_test(int fd, size_t size, enum test_type type, bool shared)
>  		args.flags |= rw ? PIN_LONGTERM_TEST_FLAG_USE_WRITE : 0;
>  		ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
>  		if (ret && errno == EINVAL) {
> -			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)n");
> +			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)\n");
>  			result = KSFT_SKIP;
>  			break;
>  		} else if (ret && errno == EFAULT) {
> 
> base-commit: c04df384b55dd9dcf72c36b661becb5aaba371a9


