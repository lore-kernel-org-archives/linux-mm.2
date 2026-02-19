Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352DBE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 04:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704AF6B0088; Wed, 18 Feb 2026 23:08:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2AF6B0089; Wed, 18 Feb 2026 23:08:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEAF6B008A; Wed, 18 Feb 2026 23:08:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44B0A6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:08:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92E761403FE
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:08:53 +0000 (UTC)
X-FDA: 84459875346.27.EC3AE41
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7D3F112000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:08:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771474132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WM/6RtOJAEdfb1Mk/qnMQOzYCprq15u5KpzCImvqTdw=;
	b=vbo/lryEMffM/mbq7F3oxP/7nOz1qXGPQDaB2W2u4NPBjJ3+5IfIM51r66soW672QfySGe
	N3bOG2FDLIoyIHC1rSsfBIqzo0MTuNGwgvd9ko0N1dY2ZnzxeFQEBTHW9nZx0ZetRQ6K/H
	6DfiwvkEObyQoDw8Wl2gPOOueoFFyQ4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771474132; a=rsa-sha256;
	cv=none;
	b=qhPF/TrBgQF3xAyBNE57o/3LKmOV5/UxaxTlQ8MU4bNMQijVOGXUMGHdF/CpnwTumrZEPz
	Wz/xnpmbRIdxTWUzD7Snpfk3+M52pvuZ4mlkhQMKjRYABD1yx7SWLa7H6gDNT+NMflGuRA
	ClN4CQwumdlUDZaXXq4ikZKXUYcZifQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26DF8339;
	Wed, 18 Feb 2026 20:08:44 -0800 (PST)
Received: from [10.164.148.42] (unknown [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 272813F62B;
	Wed, 18 Feb 2026 20:08:45 -0800 (PST)
Message-ID: <e7abaef3-be4f-4ad0-9c4d-fbec022ec29d@arm.com>
Date: Thu, 19 Feb 2026 09:38:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: skip migration tests if NUMA is unavailable
To: AnishMulay <anishm7030@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260218163941.13499-1-anishm7030@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260218163941.13499-1-anishm7030@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D3F112000A
X-Stat-Signature: bejsdh8o6rdu1ockh4ifjadck4ngasz3
X-HE-Tag: 1771474131-420703
X-HE-Meta: U2FsdGVkX1+VzbO4cFfQthp5dlTDgs0n7KL4MdPEPeTVZuqp25bM+nVhRe/MKyH0HfiHcq1HJlBLNa5pX9aottzKnRbBNBnnqJraf3sf7vuV31z4LIIjscaacaLARLXno75X2pH3rSs1P+hP3FrCd0Yk92uIkIYfFRmILWyz6eyIokS+qUh/o5KFfdgd3//U2qzEGuluJgcBbp2aRoyVOfSw10MyeLuTYRWdJHZQwpaaVonRkG2g+W7HXgWi0oiLDbeA/v8f02RgsGlr1pLmD9KT87Vc1b000s0QREIuNi/nQxuw0FGjeeO9v6x+lhlSxxxxScuZuHA9qDWiedYOC2n7kSE0csaMFMCJLsMU71Qfxxnsar04eCl1P6FMmzM4A82EB4BmVR3F14j+PSDZyJKOxs/kcrZGL+uMDtxoEQIwFZpOeU19SYtoHfaGcfPmTevIxWcYmegT5n3rjRBnR9uYYWSvXEEj3gkVtheGUwiH2DuBgqbKOZPVvVkeZP4vBYIiwgJ++cG8F4y3Bcu6oWzF/sapJTKeo8K1dLu81P2dB92Yljcv6Cmous8EcCUJitkkZIZTjM6iUQvDEL/21FTGrZmhTBOHgBXgLRTLbJLvdhzs6R6ofhkHylOGzeuXgM1EVz2+BlG57/+S6Lzrd3khZgVwa4SR9PG/ofOIVMlJM2cZB6gIbtFlv4bKHp3kyT+DQdJ1P7AKWJI2td0WYZoQYZuOF2nYeUc6MPQfH6pturGxOfl1E0dz+COpsk0QyaRZrA03nf5VUAst1MsnqhzykH/LzvKkrCezDZ8Ses9/RFDfYe4l7vEirDHZJKFtzwx2ruKtK536/4yXF4tAt/Sbvp5oUAPEV7tvtScq34jhEgAvD+I0MmALcXW5B6KjcDeVnKsqQ8kaDMA9hnDnb4s2EplBXyqGJre8cfXG2gz1fDd84N3HfgyhNVl0YIF1NxEgLJLeNYKiJm1D2Kt
 IiOuT/pF
 mgbKmMgkIJiVPE8eo3b6d1WXvFC90w4ODD53bCxcpsDUADSUblIdO0uac0mXKDvHdeYWgp8b9D8yZLqT9/iD1ooluNdrF8K/4WZFAMl+Ag33jZAEDR3lGIYJbG5YvUKQ+cxIiTbKFgLXxBH4wvz79NyW6C+NnnRhyVHpNPxA+vJreCm+Jqr+DZq0uyQLdPCqnLXu5BHsDMpXoejm8btnTqtrSBKx/rrEBlUsh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/02/26 10:09 pm, AnishMulay wrote:
> Currently, the migration test asserts that numa_available() returns 0.
> On systems where NUMA is not available (returning -1), such as certain
> ARM64 configurations or single-node systems, this assertion fails and
> crashes the test.
>
> Update the test to check the return value of numa_available(). If it
> is less than 0, skip the test gracefully instead of failing.
>
> This aligns the behavior with other MM selftests (like rmap) that
> skip when NUMA support is missing.
>
> Signed-off-by: AnishMulay <anishm7030@gmail.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  tools/testing/selftests/mm/migration.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index ee24b88c2b248..60e78bbfc0e3e 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -36,7 +36,8 @@ FIXTURE_SETUP(migration)
>  {
>  	int n;
>  
> -	ASSERT_EQ(numa_available(), 0);
> +	if (numa_available() < 0)
> +		SKIP(return, "NUMA not available");
>  	self->nthreads = numa_num_task_cpus() - 1;
>  	self->n1 = -1;
>  	self->n2 = -1;

