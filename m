Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE8A606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aM6g4pbn
Received: by kanga.kvack.org (Postfix)
	id 4AE3C6B0B25; Wed, 25 Nov 2026 17:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486BE6B0B27; Wed, 25 Nov 2026 17:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BFE6B0B28; Wed, 25 Nov 2026 17:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE6EC6B0B25
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:43:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 444498017F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:43:52 +0000 (UTC)
X-FDA: 85475120304.28.3CA6DEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 816A1100008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:43:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aM6g4pbn;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646630;
	b=41gK4TmmZEiEblJmfI+WuhX5faZpGacVQ1JpBn6YbMy40T4bpGSN9b5lbXK3jRRh/y8yl2
	iPrEitLyssIsYKc0FoflHJWV80tmzItvnLaGlst1mZc+c6cJmgt0EXSrSG2sqjGGH6Spw8
	hfNn4vnm5peE/Yjpj15ccnYgEOFzf+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rs1HN9vCwz6PNJ9aUfg5Y3QcmGo7HtSHwQkPXAqBJKE=;
	b=oJvc8Ql2VqJ3U2Z08ia6FxhAQyIcyFVart3gLgSgV8vSTSfzx/abE+KpjCSoFlIKMjJBLt
	5qO21k3+ZWIAYoLGmDGKqBmmHINHn1Xce3VPx+vvAXqsMm5DGMqgPy8He9rp2Q2mt/DlZx
	6UwWCxcXH35DKFXsA4bquTNwfcYRJZU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aM6g4pbn;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E570F60180;
	Wed, 25 Nov 2026 22:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC641F000C0;
	Wed, 25 Nov 2026 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646629;
	bh=rs1HN9vCwz6PNJ9aUfg5Y3QcmGo7HtSHwQkPXAqBJKE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aM6g4pbn0tnEc3WXkPsiTcXbY75AA47Eps0qDQkf8Awmqc9srBMfHP7fHwLoCe3Sc
	 tK9D6fj0AhuIBsd8fZw9kW2pkKBko4xSFCjnXkarIH5cBEo8jgqvK0rEXTqgF4DdhS
	 Geh9CjQEqO9rcPNZeeazGp5Z0iyEmqJ6WxuR1hyJLsyyxWY/h56Mi/nN6FfFUOMUza
	 pkAoFbZDWJcBhN9MuQuLnmaI0F0SRwJlNfIJ5wVJh6faA+pJnB+NbjaljqzsMknYeP
	 W9PGggIrwDFWDfn0rdnKbgRP6geHP5jzB5X2/bzypToHQ6BPX87zDY8PIp6lROYxc9
	 RXUlAx9DAf9LA==
Message-ID: <f79014e3-3c81-4b2b-87f6-df0c2d946357@kernel.org>
Date: Wed, 25 Nov 2026 23:43:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: reject long-term pins of HugeTLB folios
 overlapping crashkernel CMA
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Usama Arif <usama.arif@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Frank van der Linden <fvdl@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 Jiri Bohac <jbohac@suse.cz>, kexec@lists.infradead.org
References: <20261125155108.24098-1-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261125155108.24098-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 816A1100008
X-Stat-Signature: gmbt7kymykf67xxdkwiwmuodh4dpb6hm
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795646630-311392
X-HE-Meta: U2FsdGVkX18iXLLxTcg0t9D2nUDDl9cM4Ww8M8POyUpn55D75zNBh5E75xlnCdy9zARvsx1pOEQUBe6lRQvLzUMi/1P3jn1uG54Ej56mPDvQIbDhh6sny79eIAWXWVNE4xKLmPu2s5X3t5YecokStN2lJhJlxHjulIBuFxJaLj41EIJJZ7m7LZM8t/yJdGeXM4Cj/7OQS+p4emwdTysg9rtRtO7RdsmO8HWTZO26NFOHO+13hr6IWk+cYUj5a/9LN3AH/a3P9IS9uyKKRIPjMzloP4c9pOf4Tg3IoNvYUn+EM/iz6LEwb9684wfqeQXcIWqBZXge3vdz8ORJF59jgShqZnnAh0A3ZtaOjEmO5Eui+F4FqLYB+P9BK00qfe5V1tajplyjYYq752hRA3MqtBn8LOwUjNUbb2P3K9qv05VjE1HBuR4i5OtahvZ3byf8j3KuZgMfBIZL/dZvcwh893X8QVbHifbmgcSZ55WYIotWoDmOUA7QERe2R9d7HzSzgDjWpcu+gEMnLfc7KVlBzqC6OJDJiSNSZeTODuODF43Z63XeMCvlXBTI9LfDDibIbvldPBOuUbc8xUmRlbVO1xtpNnbsBsalWSTeNy3VtL4FlsOUep0jJaQ+MzgRYlwhQEiuEWgQuaIJ7pwOtvksJGWq9prp/dDgLANR+mUjM6mIr4RARtPh8FJthsXhhCEm/uoO/gikeJBYsBiFLXNPpGLcaFIyLgzOWxeXk3GHu0mPAkplRXofE0hk3oqyHgKuLCta5Pj0l+S08Xn4YLeFi4DZusHYvU4flNUrimj+0yCUwdLaibg2ArhSPvsl1u3OYskstzEugSfKCM19vZh1wnCaqJchlgAmcBHJNCUiBfOElp0iVAQ404uwrxdt5+7dGbKwyQctRRF+O9Azi5/39qUP3J1f8NwudyhhFxkjYGU3sysRPpjCC166HPswCvzFMU3KLcSZZhnpZMEFX41
 QxL+fnCG
 xNq1iuInlCaJXRxVr+H9vS5zDtMinNzeCHhHwpOyUWP8HCh8zqzq3xhAq24FttFtnH1efWh4ihIUqXpiLMPoKfGmjpyB7OsRU9yzFDC0/fUdMzMtr5deL9QCmGOK3Uh6KX7lk1K8nQmLpM9E3NilY8SbCWbhBQvwhIGzk7QTCnHCIJq2KBCTrFk04SqKh9J8uSH15xULKucJlE69QBYmyMWl/mZkJ/LGv567k8HYeRB6o5ynceYDCFvAcZ8Gu6uNKQ9KIzRzwD1ieCWxN61KZ/lwbACzSelUy/LrDZljH48PA1I0YLC4Vy45i2vRswwlkUY0nybVQSnKPmuNn+4diIuqbIQ2so6DAS3l+GGty/EPtTRoBXiFXwdxLF3uWoX4abeOiirB0/2dKqXsDOIgBRK9eDiL1sQLhCNNskkDWgg92qVL3MJGzHQsl2g2ewEiyqSqgb2ETSRKiI4VgQqvOXXb4GtHzdenp+Jx+40nuG2TZDs92cqAJvqW1gykCbPoysDyX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 16:51, Sang-Heon Jeon wrote:
> crashkernel=size,cma uses existing hugetlb_cma memory, so
> crashk_cma_ranges[] may contain HugeTLB folios. HugeTLB folios allocated
> from hugetlb_cma can be long-term pinned without being migrated.
> 
> After a crash, the crash kernel uses the memory in crashk_cma_ranges[],
> but a device can still write to a long-term pinned folio.
> 
> So reject long-term pins of HugeTLB folios overlapping
> crashk_cma_ranges[].
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> The above scenario is only possible with the two patches below applied.
> Currently only linux-next, which is targeting v7.5, has both of them.
> 
>   "mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory" (kexec-next)

I think that's a real problem with this thing.

The solution is not to disallow long-term pinning. :/

-- 
Cheers,

David

