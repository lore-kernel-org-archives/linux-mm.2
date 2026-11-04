Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2BAE606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wLARo31D
Received: by kanga.kvack.org (Postfix)
	id 059E16B00EF; Tue,  3 Nov 2026 20:09:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B086B05B1; Tue,  3 Nov 2026 20:09:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A3C6B05B3; Tue,  3 Nov 2026 20:09:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C90536B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:09:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43053A81C3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:09:07 +0000 (UTC)
X-FDA: 85395652734.18.C5E2446
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id EFC1F180007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:09:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wLARo31D;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793754545;
	b=OdG49o+AkJjF04YQ2z7TlSrkrzK8fGiycdUZID5o/sECzTxzZ5kSEogzBPW+5bfLzM1geh
	x7s2+NrsSP2kxtAJyKNplcYZtOiTM3CPt6kvanHOhLKgpNP8TJXYBvL/dPcI6ynIwvGIHH
	Yr1SLcDRiEToDUix6MZ/SCA5a+WRPJ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793754545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNwT7MNivvmsp5v/G1sivGjjeFDSrEE4yVOfX4tFs4M=;
	b=KgbWBnLsnt3ZgdzMhmxFdQNPuS9LTvkZwYuGay58JjAT7U88qIcOYx+MWiC1BLZ2cLMOmR
	56ilKv08A+Vj65+VRfWLMBM901gXhxMZme+Z4ANXvHY3OOK/FlE9eLTp7tIG3hE5MtC2y2
	EazeN4kIuEFG64IgKii1KSTARQVnMfY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wLARo31D;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UYbkNfTSJAbnMkgRK5RbseIFJJx2cVqZzvm9C00qXZk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793754542; v=1; x=1794359342;
 b=wLARo31DHaReFtavynBp863pM1J3r5+hVQ6MX9Z4rPoiNHUjDwjqMGFWXSluNureUdJ+52jr
 sn4+Joq353j/BgLkZgr8ne8hxIhVJ3vW06opsuEyiIBkCHwMOgWX326pNDSZp+cjKfwVtfrW4Ln
 gY7QvlD4hYvMpiMFMrjyq0A0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 09a24c3c5e0efcac;
	Wed, 04 Nov 2026 01:09:02 +0000
X-Mizu-Trace-ID: 09a24c3c5e0efcac
X-Migadu-Flow: FLOW_OUT
Message-ID: <d3c8baa0-3ed9-4f3c-805d-86c98a6bdfe7@linux.dev>
Date: Wed, 4 Nov 2026 09:10:24 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kselftest: alloc_tag: use the ll64 types on powerpc64
To: Sasha Levin <sashal@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>
References: <20261103155454.534649-1-sashal@kernel.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20261103155454.534649-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: tkqc7bdwc3igcihsmzkixo1p4bm5yzr8
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: EFC1F180007
X-HE-Tag: 1793754544-724204
X-HE-Meta: U2FsdGVkX1/cnp7djF9QUTVD14MpMHqspv5/3Sxtk0dF55jIJ8asDd9DGig+Lh447qHjL4KTtFQgHr/yJ48fQecudWqh3rWdhGulf6+Ho9vqrT8T4/ntNQmE56qSDoRovKcWklQzw64Cjw2rRsfZrLdUiZlIm89uCMwcpXzwRTm6cl/ytVHVIO7lSXVEC9q/J93cRmKhN8IVkfuSXzm8IfjoQ0Mr4FOsSsCkrwdiC4GxzIImV1KOlbFxudceCa/2ub/IW0qNwNq7GcnBm+ZMxCO2zrefU4buS0pIz/x4RPjcbonF4lac71G8cHQ3GHvF1hZjtX/yb7+o9H+WZvMX77sFUSmf6tvBc4Au03dx1fBgDmWv2I29/wT9p+lKFNAZGjk9BQMhI0hsMMiy6LcpFlIMY1MzSqngh18DdHGXq+a784/rzsdMq253ENcCvEZD9csVhx82K3Wr03ixL/sQFcDy3N6IDO+EgrmqWz5T9fVfqyhuab444Wez3pd9DfVoUcryfK+NMAVJy2ygJL0RFhm1ZYi98uJMNg4yK9o5K5GMg+qvxc1csQISggVWs0UVtnE7cfLsibP8h5gGeaIDDjSQ/qwes6G9TP4pLTjfP7rzSOwseCYK8FG5BRt5/Aj+/IqoAcaToeDJRP3WBlB5FE0KyZl1vxTY1ynuD6qW3kEexTZSxsMu3lJMTlXozJ+inUIhvYUiQBCvWeGYrM8Hj3bWlXxX4UcXpGVCJD25nX52gGOEGsw8HbqGvSiPuvmsZ2VNg4qx8l1H1ObfY09/cdom9HT5XOFV9nzSa1DrqR4Vb7q8unZ5k2SwAGlNJIxZOpatsReX4ySSMu6v1rCUMUdDyp+qhCG8L4XLADAQdOsl2ZapdJPYulGpOfX3OKQcpL3Ne0AUVLSXQvOTNrIEX3RRXQhqIqdZhRu+LHOcpqqL0z0MUGlbwEWikfwrQaSK9xQFgdRDaoDxItPnBlJ
 qCVHa5zy
 GzbxCXla6yZTDPgAgpZCa0TlsVkGqLnyvEJxhlvhuDB8LFhZj7AqgxhdHeU2H/LBxhEZyHWpLk+aVK7RVIfBPXtjADF5wMtXs4c7cgDJJcDx2QG72GIDXWGkjTUK61BYYhnseG5pV+h9bnNB1bw7EVtseX4HZfAxJGn6pUWCz1TxH86outQB8HA3Hqk8EeIa9O/TsvNhwqMlxY6zGix1hlEQsKls10kR/aSIl/BvHU2slCkZgUwMd0XGs6ShrJ00tKZYksixIjWGM+6LC8OWJDJnYoJPwVi2XFJ1/kCOcXg5/Ldh/GSbenlP4xPMM3q27USiEpHer+4evVnPDTe9EsT8/AprMGflx62JachCmekb4rFLd/Db+MG/TGntkvbmNxTYgJSiZgXnz/xHKC8AckbIlVG36/jA9+aNmERgOkLZBms9ihupM/LcR8hVT0FKfXIMX4YsuNdQUnPNFrQE9uyZM4eOmriKbLXOldkQRj/7DEX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/3 23:54, Sasha Levin wrote:
> On powerpc64 __u64 is an unsigned long unless __SANE_USERSPACE_TYPES__
> is defined, so printing and scanning the __u64 fields with %llu warns:
> 
>   allocinfo_ioctl_test.c:93:73: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 2 has type '__u64' {aka 'long unsigned int'} [-Wformat=]
> 
> Define __SANE_USERSPACE_TYPES__, as other selftests do.
> 
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Acked-by: Hao Ge <hao.ge@linux.dev>

> ---
> KernelCI's powerpc kselftest builds show this. The define makes the same
> change on alpha and mips64 and none on the other architectures; the
> x86_64 and 32-bit builds don't change.
> 
>  tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> index 74fd64b2370cc..18c761fecfde0 100644
> --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -1,4 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> +#define __SANE_USERSPACE_TYPES__
>  
>  /* kselftest for allocinfo ioctl
>   * allocinfo ioctl retrieves allocinfo data through ioctl

