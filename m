Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A88FCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2BA90007A; Wed, 13 Aug 2025 09:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA35E900044; Wed, 13 Aug 2025 09:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE07590007A; Wed, 13 Aug 2025 09:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF634900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:45:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89EA5160292
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:45:34 +0000 (UTC)
X-FDA: 83771856588.20.CAEB69D
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf05.hostedemail.com (Postfix) with ESMTP id DC8CA100006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:45:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lZX7OAEO;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtnmbZJ2E4MnFZ5JyBATuJlPVIa5kF959pZ9xSlJ/bY=;
	b=FHh8y6k6cuugX9uPRBbSsHGn5M0VeZoyhWmVBKDwVWJ3HeTO6+ziIByVcp2bGzKHkFqFh6
	0BmhGls8rJwiZgaSUZdRqr26QdioYxBygizTATjlIhDUo6FLo8iWBxrGjGWaK9ryxGslNG
	SDaYluFvSDTJjnscb41VwsCPmJ+/HbQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lZX7OAEO;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092732; a=rsa-sha256;
	cv=none;
	b=eHdvPZsy8/SRpa28gD/CzzRUZ7Ncckel6EeYgmylcmIbvP7ogBdxyAj9kAuPEOUPXXXJTZ
	W7ILvIK+Ppr0E89Q6ORwNbUkC/PBUMFTca+mFSwyjVKmIg7uYfRn1EXPcp2HWccvZ89+UG
	Tjy29OC4irQeC78Xu9LCjr/hnTa65kA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 41D1CA5760D;
	Wed, 13 Aug 2025 13:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E37C4CEEB;
	Wed, 13 Aug 2025 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755092731;
	bh=D0xx7031UZevoMdpdp6ryj7WTHkAul4ivyREJrKlUK4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=lZX7OAEO4iV5S1+YXwOnpNeXysrLeSryC2YE5VkGmWFuQ1wIf+WHQIRsPfY64kEvv
	 QzcQMAowqKlFIJSrHE1eEuBK6vW1P1AekwkoCcjrd4HOlzlC6jenE3ECVGpLYdDivk
	 qyjpj02i46dkWEnCNEDjQSNs/9x6Jd21DB4k9HTMhz5nsiU0DfPOYMHteLZ1wJLASP
	 qpUPUOOVkMdmZ1Z9ow7qaMytrTTWQK6SBmBQ51D/RRDYYx10iAwqrguOIiiU8j9v8N
	 4iS480IBHW3v/cY6/gPBGGopu5lpSm9aIIhXlxXD27EoChcg/w8dp4NObDJYFg5pZk
	 akcmTCNvjNGFA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,  Changyuan Lyu
 <changyuanl@google.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Shuah Khan <shuah@kernel.org>,
  Thomas Weischuh <linux@weissschuh.net>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 1/3] kho: allow scratch areas with zero size
In-Reply-To: <20250811082510.4154080-2-rppt@kernel.org>
References: <20250811082510.4154080-1-rppt@kernel.org>
	<20250811082510.4154080-2-rppt@kernel.org>
Date: Wed, 13 Aug 2025 15:45:29 +0200
Message-ID: <mafs0349vwd1i.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DC8CA100006
X-Stat-Signature: gjc6is3regnzfa6b7xucnuistwefssnx
X-Rspam-User: 
X-HE-Tag: 1755092732-549397
X-HE-Meta: U2FsdGVkX1/l+gWg7xjljCsa5r1gkaOrpivxr6eT99vyp+gblE8IMBu0fxXhzpWcRou5+SAhQSJ6ucqF4Repr85kjBfpt6ZBfwEUrJl5Wsb2dFrxgm7SkbWfBYHFeUmJsiDFiWxjj32c+s17h4SPtePy0HMVHGIA5zDxJjlyeLzdNkEDaAfXyqEO+x1SFE/Pthqh4eZaZ/isX1zJqS9CSOgV2pxTQ+dl8QXNLMrkmMKeFm6yUXirwpEK2HmwkHMs/VH0s+2PfywII+TOEx6wRwnW3tWSMyOt/+awDQvRQDXJ9c+2kaHKvI7swOWSXvStrLiZ+fydPi58Ms7eexu1sU/Or732i3qa00USZnV/MOYCLZ239pkiK4APwiCe0aLCG1wIfgLQkAxv6/QsUpGCGpHycftQ4IVbmPgz3ZrsY7wUmF4xp4DB3LLI3LmwK6og0jXgASwKdbvVdfTxtp2JKb/BiAJFmEwzvKtcbhbhSBtbYqA2dtb5M6Bjn/fthTOOl9AAAPUxo1GqiGPNR28kRWvmfNZSzbgMNrFimWjA+IC0m2hbJloDP5EWJc/cFuYy0jny9uuAmf+LPY/pflJ2yM1kjd5hTK/UaipzBW6scW0XVYOKw59GPi4kQUm6p1q5ms4/DBwTC31LeyCo6H8JijeSVNcNZpiGlBRZEzz8NaVa2d6oPFMxjaW7fV299oi4BGeGEHT0hqStAL5irFECreHkyPYTU2EjnjTninksSlvAntFSWj6X+3Cmyji966g4y2JlV+ZvgYD3hdiH3tMOI5JidjYqKwXWiPvr+WQVQeHfMp3VRduLY+UmnJIDZc1hV3lG2z3q7ciBA9cNnKDYXvjFYQk7swwxk5+BglwlsthDgW7qsDamq1iEQV1m3Dp/25vH6VFYYBTx6nc2RIqyXKh5MC/IPpf3MrhulcNaYcqN2+qMVXZ/B7vM6XsxllvhEIlH+ftPMB9FQv1ANAh
 31kk6E5r
 DStCN8RLUxBUBUwgYs62zjgNBgA4Nokf7SSizT4D/Lu+wpNTaTMd0ItH6/RfZzphqN8NIAPREza5nApkzhtl1FdM+1MROOO6zyWgFZ5vVxQuscBiiRi7Syp/caMbzfcK9pl3Y51xWnf7zSDY+p6qIQ/Ex7gTpVwFtsH/u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Parsing of kho_scratch parameter treats zero size as an invalid value,
> although it should be fine for user to request zero sized scratch area
> for some types if scratch memory, when for example there is no need to
> create scratch area in the low memory.

Can the system boot with 0 per-node memory? If not, then perhaps we
should only allow lowmem scratch to be zero?

>
> Treat zero as a valid value for a scratch area size but reject
> kho_scratch parameter that defines no scratch memory at all.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/kexec_handover.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index e49743ae52c5..c6ac5a5e51cb 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -385,6 +385,7 @@ static int __init kho_parse_scratch_size(char *p)
>  {
>  	size_t len;
>  	unsigned long sizes[3];
> +	size_t total_size = 0;
>  	int i;
>  
>  	if (!p)
> @@ -421,11 +422,15 @@ static int __init kho_parse_scratch_size(char *p)
>  		}
>  
>  		sizes[i] = memparse(p, &endp);
> -		if (!sizes[i] || endp == p)
> +		if (endp == p)
>  			return -EINVAL;
>  		p = endp;
> +		total_size += sizes[i];
>  	}
>  
> +	if (!total_size)
> +		return -EINVAL;
> +

Looks good. BTW, unrelated to this patch, but should we also check that
p == '\0' here to make sure the whole argument was consumed?


>  	scratch_size_lowmem = sizes[0];
>  	scratch_size_global = sizes[1];
>  	scratch_size_pernode = sizes[2];

-- 
Regards,
Pratyush Yadav

