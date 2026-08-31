Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC90C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D3E6B0088; Mon, 31 Aug 2026 05:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5974F6B0095; Mon, 31 Aug 2026 05:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461E46B0096; Mon, 31 Aug 2026 05:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 228F16B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:14:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A475F1A0437
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:14:22 +0000 (UTC)
X-FDA: 85161003564.10.FD15AB4
Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	by imf01.hostedemail.com (Postfix) with ESMTP id 299CF40008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:14:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cNYVh093;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788167660;
	b=yv+elw+jzcE2d64V6q2z8DRW9wmzqdkwmKBYAhnBYDqlDdTwWjsA5iefMtsuVYaxiYz6MZ
	m/Dc5JKtdEgkflnbrccyRrJsQruouXj3VTjbRxlOZATEe2TNRz9HcFWetOGKyXODsstgnY
	XDcg07rwGL5KW832Gw2G0PP16wLM/QI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cNYVh093;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788167660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOxstMuNhjgQdO5Wf0RblTmBdSQd2loFpIZM3jwkxLY=;
	b=7GXDztfgb3sO4zBWhWKcasuzhaC63l7qzKQCOxTt8VF33jUs/qrkWbZrtiFIwTzjuWJLyg
	i3+v6kKuuQmSUJyZnXqo3sFMxAc3f5pWx8gdNXwxQFj/QJZDYHeB2DXmTVpOQOdgWRMRQC
	drtdt1h9TjioB0Cvest9EWfgLeX0Fc4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Iiu36uPx5BDwkkFBUZed46ZW7Ls2oZHtivqmUwCVh+Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788167656; v=1; x=1788772456;
 b=cNYVh093wxUgQ8JJeKoLaxbyJJR172a2ECG849duc7OhvzYrk5HCHk6rpTilDHD3z8lFd/Rj
 uSBVgVoFrrkgXfAquSC7U/WmcJ8jZFHekxw7FG4semIX3t51H8S0ywESPC/XTFFnS767Bd/N7gz
 6sv4rabbxKi0nhFIAoIRUgTw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ecf1c50fc97867e3;
	Mon, 31 Aug 2026 09:14:06 +0000
X-Mizu-Trace-ID: ecf1c50fc97867e3
X-Migadu-Flow: FLOW_OUT
Message-ID: <34412f02-d2b7-4717-a9de-cbe1acbb7a87@linux.dev>
Date: Mon, 31 Aug 2026 17:13:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: remove stale hugetlb check in try_to_unmap_one
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: riel@surriel.com, liam@infradead.org, ljs@kernel.org, david@kernel.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20260831082849.3573957-1-dev.jain@arm.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260831082849.3573957-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7nsbsg5pmwkxz4ngn6z6iktnensny6au
X-Rspamd-Queue-Id: 299CF40008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788167658-353074
X-HE-Meta: U2FsdGVkX1/Niia4cwPUIlN8TI1PCGDXlkTaIDBFrZOyZjpB86ehdPdFgWPmyCX+e8jFdCZQKTGWmbEWJRdIQIk2rDv96vjHOtWw3rj1QdcsyrUOy1p+h6QYwUU4iZ/v688EeqsvQ4QaU2U/hLURwxfGBOIlEGWdQmBZhtBM4z60ZYG/v0mxUOXZcn8vu4GyWZG/kzZrGFqhS7sGrbRSf92LT/dlxmSMPGZhbEPZnUl2QPLZPq9H3jniQNwQA80FMN/Wip1fZT7UvdV91JcmYXmiQddioWgGZbTWBnjh12KMXYzoTO2hv1tWv5Qu1aa30UiU4Kq2XMYDEBIHlKKxuAu7hBuc9UtgPHBODWXnh1wnjSGT/mVCdWgvKxbUionvaeFyyrIEJWpItC1Cfh53n4hHBUJvdQYJRrXBkXT/6WfIE/4eZt1KMNjbQDi29ppQWXLf4OjZhcc7EnuQ+Agjd6aRKh/Rzr3LysJjH6gJNxmF5xMHSMLJbcM2mRlQ279qvdsdxEBY13lp5ZAT2a8rkpGXodONR9aund90/Ne7tXBFBDc79i2qmiLgliPlY8LA7uF17WAXI6T5LcHhc6BRt1GFCzCnX4G++HwuVjdCvRvFcxV3yqnMhERgNYK7BL5XeD3/VlXGr0mqZcq3/V9UHvpDMoRF8QUMgKSeuXyGOl1s+VDtN/ywBay/0/KUke+b5pkv8cGGf5/ERsp/0lnKX8Hmm+pA0JDPnUgUYi63pTjOhr1gu0xirTRgYt7so7avE8jntXNeuyaV4sVlaIhOvEY2ri+x1hM/y/QKiY9aQJf07WmF5eyTdeoxHrGibzT0v3rkecWCqkk+g0n1mSdo4ASVfESf/z4RcpWGU5MOBwKcS1j2H/ews4GrtaRoHBLxezolfTE7qigk2rW1akzoBnPhHaPEGtndc/2/ixQSsk+TVWHSWKyHd4mGMcpQrDBZOIz0EEghpY7w7uy5ZVS
 7xgroAI/
 /AlPOAGdhn2QQCjO9fnEalaqc+Rt9IirFfLjFSDiauLGuTuE3v856UczZAIlsM/eRw5HWTJoIe2G1cI1SYM760xKsCLAHlEcr4M/lCkuMdM6b1AIwq8Q6jUz/LRtKrI+f7wdAwGI6Db+zGlp+kYwApJ1l9T4/ruhVqzcviyB7KdyqaqNsVoOaJir2XJ1953wzGb7GsKqze6cEO6WjeWD0U9cK+Dj4N+rDPC5nBvdFBuZOAa4mYbl6BtzSSlAoVXx/WXe8mACGHoiyHT5/kWv9vrDg5pLJthg962LXovJxS7Tgha+IgYEVhzI1Kyiv1d5sSoifmI7jrhq03fFyRxZv5eSwS1EhutYww54JlOcIIT1Lz1XTftHeuPnPkpUe5+WPPrnI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/31 16:28, Dev Jain wrote:
> Post commit d4ec5572825a ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")
> try_to_unmap_one() cannot be called with a hugetlb folio. Therefore remove
> the folio_test_hugetlb() check.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

