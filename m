Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86BAECD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C616B6B00DD; Mon, 11 May 2026 09:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C123F6B00DE; Mon, 11 May 2026 09:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B286A6B00DF; Mon, 11 May 2026 09:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A56326B00DD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:51:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45868C0114
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:51:37 +0000 (UTC)
X-FDA: 84755276634.02.6F410B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 87F4140007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:51:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umnW21h9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778507495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xk1U9bLHUI6bK3/RnT0iBe76q/xWXiaIwovxf3NaV3g=;
	b=68C9V5Y9vnfkY3LK7y+/BAnaxRifcrARrHY1JIp+FmkZPxjJfwZUOCFaoaPD5HWQ4oi24C
	C/YhozyroXUCxo+ISEYzJVPCMTkiHevOuaGXmFhag2rRKcCDYbMTZm2snfu3xURNd14GW7
	uYDsm7OYjkrezJgZGeiRto/5XW7KEzI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778507495; a=rsa-sha256;
	cv=none;
	b=GBQWeO1unFDTqlPCiJls2jSUYa/LEyEGVBj7Pcq0PXrm6P50ElEJfN2sjf7gc1wuZBPHgq
	2b0aR6ihLNCZ6OVxP54TS103ZEXunAfLgA9+hNAegNQxJ+HOJ+nQ31OXCFAs4pJv1SIV+N
	Jot63Jd+AQD1QKiG0w+GbPUdye8/3qg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umnW21h9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94E4740ADC;
	Mon, 11 May 2026 13:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5791C2BCFA;
	Mon, 11 May 2026 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778507494;
	bh=uC5bfHxmQ5U8mVphofqZMyzonZuP8ye/EHz4NgpIM2A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=umnW21h9/XnH7XSpLYW9KZ4S/xlKkkdzV1m8oq5Rkh0Amq/72/y/pnsKpRxabxu7V
	 q6tfiBxdfIuq2UU5fh9f7hYOLRr9urF7vG6S5Ii7j3XkiFYEUnh5t+s+XF1jGzYgWa
	 sIgYz+Box1fhiUSQu04Lc6Jc4LIMMPdP7B+RrH3GKdC3HQ8E0/RPRfO3q312Cz05iQ
	 BsRwmDAwfspMG4tcSa4w/erMBbw0vLOJba6hlRGduXnomH4tarzmcwbOkR2zCzQ23f
	 /J5qUJ858GGaB+2gB9qNj1kx5Jn4Qk7LUZKBNjldL2BOJjp85XmmNSQ14OQW2aCEvc
	 cwe0v1ZRVj8Dw==
Message-ID: <f7ead2e2-69b5-48ae-8f85-f875765c84c9@kernel.org>
Date: Mon, 11 May 2026 15:51:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/22] mm/page_alloc: don't overload migratetype in
 find_suitable_fallback()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 87F4140007
X-Rspamd-Server: rspam04
X-Stat-Signature: sk1871d4hsqcq1ebnz6od6a8qq66u9bt
X-HE-Tag: 1778507495-722258
X-HE-Meta: U2FsdGVkX189yJDuHCJt7E9Kgpszg8nEydM6Pm6ZE8zTK+f8Del1RnmsQNMOUikXglUV2WbbeWictGGp2j8MKzpTyZqnpeLAXzizIIcOnvlWAZ4MfZflwcdkACVleTKP8DF0h6zlkqZO/uBb/9cZhLQmphnJ9z9qr4ojLv1XxWyPx+M96I78QNThTEauSl0XBsMjILxJYrjUsIUd+IVMoGtxN4q9seB9WKIJYn0lJYbPb+kgeQ91q4/qz1+1jNgOkVxqsx9DbS1eyFnExK1CX+zgsET8/IO743zIJUpC14Qam/vaIsz3mOkDY25TfjlCp0c1RCsBw2tHPBVo9F6Ath68sYry/XmjYWICTNdLcSIXI7obJFPsksZlskP4mgFT009qCHRGL6UoeHGyqFfxtrjARDfZwwSkWRKXu1kaVsoCc3yLNyjMgB4u6a5+dNx/s7YFUirOnCmqBiwndgYixyB4Gvb/ML30fOT0Y/Mnk78Ks3bCu/We6jBTI74QRYfM41pc+253oDL83StuHdLUlG27v7FGLXpypPUAu7YgbPYwal0bfYk0QdbWiKHIwESQYk9UV5HVwG/mU2OtPsz4KhsXKBvli6/mEhOpusdBI4yQCjrdFTMwLJudUegX+s6gROwHDpfl/gv9LV6t8/aZv9O5kRCYCbKuNoqEvZ5sWJwIlaCxS+gtr4J6+/9vwPLP42lbbgEt5zNzelnvZY1VivypN+itwqMvp6e/gHO118Gl8ja2ijbjUVp6Ea9asQA4MydJ8mBc5bdo7M1K4cIysxapI5jKo1/BI/xW5imvhCG/K3LnRhAnSfM41w1NrK1EmnEmhgr5NTtho17owTB4+xD0RN+K08+2tKrbzNPemj3buW8+c0FAXpRU7HD4ia/4MA3YvfZwMwIDMW8Z+QQSDQJ9PCipjlKlP2MYpf3kzkNIUHGDDd0rpYMNqooPwHGp6N2SqcSqDJlRaGEh0Rs
 FQwuv8Ue
 xrocYoNj9NdXRbopK9/Y6/Dd8cgHg5aEzSblRqnpkdfv5ohe0sU5FoKfGbLjYSDPjbUEfSKEi7TMFMvNTgNXiFE09wkoEbaXdjeQd3yixkaQ6xYfeWYJo0ISvSTnHzRf3usl3PtahZk5HMwfLfwFrdWu1uvWdX9P8JXhsKKgjTv+dAKGaKTBc2Ao+D1KO95Z0Ml9Z6AdK1BByiD+IP02Rlf0Ch2cgLcBQlvhWlLZVUQ3mBTSlZmMR9XZxVZ0X17gFojPkcB7pqQmvnbyXL1lGDf4iS4Y5marJjiGsN0cL5PotVgMKYi/+eKA7TdVBFh2QPJVLMieL7VVxHFKDMzNHbyGNBKtOq7qwNLxES8c7lP2upF0R6VA1aAUBwiz7WTWwHjMR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> This function currently returns a signed integer that encodes status
> in-band, as negative numbers, along with a migratetype.
> 
> This function is about to be updated to a mode where this in-band
> signaling no longer makes sense. Therefore, switch to a more
> explicit/verbose style that encodes the status and migratetype
> separately.
> 
> In the spirit of making things more explicit, also create an enum to
> avoid using magic integer literals with special meanings. This enables
> documenting the values at their definition instead of in one of the
> callers.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


