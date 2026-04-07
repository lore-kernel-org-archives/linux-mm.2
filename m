Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F6D7FEEF4A
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874826B0089; Tue,  7 Apr 2026 10:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824F56B008A; Tue,  7 Apr 2026 10:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B9E6B008C; Tue,  7 Apr 2026 10:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 642AC6B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:00:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 841665B36A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:00:33 +0000 (UTC)
X-FDA: 84631919946.02.24088AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A5970160015
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:00:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CSA4SIBb;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775570431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6aRPWvVmWResPX+fq3oDkK6BzfdDvsvMXWXcXjhYOA=;
	b=RQDCr5TiZCpMbW/UIMXgr3spjJcTGAzUEz7OScI26hsQ62phXr04rt5LUBwAOgIAsPWxuz
	W31fYwXUAKAnYgnKUgWnP+Wxjq4CJlW2Sq0rRrhnQ3f9nVWK9dvDaWtFFfQmGoNtSTI2pY
	AkxN7UcMLoqYiQG7dPaHF+93Az9Fh+E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CSA4SIBb;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775570431; a=rsa-sha256;
	cv=none;
	b=LaXZuBvnHBWzNzbVguyrKCFKWrBg0mup11w6ytaTQEY7K+banrTGFo5ABEXTne4uYucf1Q
	EMpzOg/TpSU1m6avqCJwTJF+JuJbhaxMJcggIUscLaKKLbDKC7XFpff0nm8qDao1njIxal
	Jlcp9zj1NIVmxH0xqRAYbKcTGb91WhY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 982D560103;
	Tue,  7 Apr 2026 14:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4DFC116C6;
	Tue,  7 Apr 2026 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775570430;
	bh=ylwpwEG1Zp5ZmJr6ruzUlXPmhqsMVhkRkVSp7KXDk1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CSA4SIBbZwcUH6Wvq28nMitrw6feeDhAG87iwCA0o240/79+cYbvNWxU0JZpEUnRj
	 zHXDoEzBzHUhIuJOAFq/8jZ1UahrfJNsCQWIH2HzksUb/0FZrDqWxq45x9wJI6xMAE
	 mRm1918vlQVhqopG/gWAHwoH8C8CXcj+uzpeEGFb4NhswoGHwT9cPbvBvGYPsal9h0
	 l3YZ658hIJCu6j1n8jay2QbR0vBAyWTYoMvhYs3ahv55X4A+dP0CERPVO/SJsHJq4f
	 90hJnbMNri3Jbeafb+97/wsJe0tm1kbZAYoyTM0iLaI1WYF6GBzgZ/x7rj4ajosGFE
	 vMzLYTTe6RugQ==
Message-ID: <0cbb6ee2-e4df-4161-9378-f2b63e849683@kernel.org>
Date: Tue, 7 Apr 2026 16:00:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260407125133.564182-1-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A5970160015
X-Stat-Signature: wmut6t671cske6g8j8c5xpws36f5cckp
X-Rspamd-Server: rspam06
X-HE-Tag: 1775570431-775084
X-HE-Meta: U2FsdGVkX1+5+dEdS9Cx7K2aJjvl/6zyo5KZhM4PnGWDmbt4OcYVBXcW0KRDgQyH8u8pfVhD2QE+Nk6SuZVYz9vf2NgcAjOFxedyxBsIYowLn8r+k5BnREHoPY/WgzGpetYI3yz1cxPZ1DnHfTmQBNQ8+h7zPyH8kMgFYR/lGE9MES2K/3h9/b5lTlcgxVh4hyorvJ7gLUZpJIyocUH6Yn/cOfww/N88HW7g2IOfeCqzEgvnFUP0tNt+8zzSgYH+AawnvuJwb7bAucbdGwPdJpctaVoklwAwsFvYikZ82D9bCH7/pE55d4n/ry5ZzrYbype/O8LpK7ElIxuD5hw+QC3dOLkREYnD163e91/WQuTddN07ogJe9rVz6yHb4+YtawNr4kOD2T0evSqcGhOIEh6OXTVTgRxO98nqJh1PiaXTIoLDdTuk6UTrYPCqmWQOtCqdTLSU6OS6Ukh6/uixnO43ajxZ6Nroq+zfR5ud7S2JvtmMZGES2+6Gf2HQ/OJ9ea/t6lKA4ZjKm7ogblYiqZ9Fv+sJuOp193/HDEfzCMYZNWP5VkXYPhSz099Q7AFZLKjw5CjBelcTcDJyD9GoGCSmb5tfzUYDxsyBNOjzg901tRkcUys4zusRIqd0FuyV7HaJ3OxPhSSxM8o1BCKw66to5OlaLRasQLcgAl1LPqW+QMoOAZLborr1RaSfvkwRwW20XxmcyaEB1iPNH2feoPW3WTByyFp4AF6ghunHYx7DOHbRpBMP9L4/FcNn2lJ64W1D/rmDLfvytL6GoHZEkdrNbhkl+QZKXQoSWWs3GGw1dxA9OLG9xYwGscuJaqQO8n4NUnv70jn9NQdmMghUQueufyV13QzMkJp4hGwjU/jqI0KRTXzEwynsISxh+JUUmvKXOEpdWaoUiCLmNFgbfVUq/7OJl2hlJKMGuzBXwus6kuu0arT+UZovnMYCDKiUYX6lCY+C29TRm+Fp4X+
 9jZwZ6UC
 JcEBRmoO/cBYwUeseMMEPiqlr8/UOYFOXFngaTBzTnu0pfWUDxCUBfKq0y3Bti1VTunA/RAsRWPJQRLNzJ7OdtemuZd5a60nCKe8TLz0gCZRHNIBWPkjM7jkedzqYWcZbuqiSsQylaBZKbqSu5aVykrJ/pCncu00eSJXfqml4uvlpuuk6SgdBBHNiYRN/JhoaOZXvwmNch1Lfo+FhJyBoqwxlAoU7beJApD3B8FNIq/rXNo+Rkc6+M6/ZApLDcNum5X8135EGZ7JRtltUs+B8psV0xAbSeb5uFEzmiw284+XTs1IYHBxQ+tdLdx8eQ6LFh0S7/nHnH1qwD51VrIRhapyJ3NuMv4k8fVBgnNTAIFroZ9VtY0EUNThYDHpveF210LRMn5VNpBrX1b6O/sRndo/OBCbWu90bgJnoPk/R6wxae7xHuJ3v4ijjSdOY5pqAM9FR21EmM2BJh/ig49hVQDWlstsgeB8mnmZORh8AMEMz6l+eiNSdrjYGwTD35KJoYNJUd+B+m8UunnM+aYrbBE7pzrKnCQ2i/XeMtQ+RRzj8n7vF9BIRHPR4eWFtCwlJA1XimNDUli5SVcAU2oT69797SCYHS/+br4Mp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 14:51, Kevin Brodsky wrote:
> The ProtectionKey entry was added in v4.9; back then it was
> x86-specific, but it now lives in generic code and applies to all
> architectures supporting pkeys (currently x86, power, arm64).
> 
> Time to document it: add a paragraph to proc.rst about the
> ProtectionKey entry.
> 
> Reported-by: Yury Khrustalev <yury.khrustalev@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  Documentation/filesystems/proc.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index b0c0d1b45b99..d673cad7dbe4 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -549,6 +549,10 @@ does not take into account swapped out page of underlying shmem objects.
>  naturally aligned THP pages of any currently enabled size. 1 if true, 0
>  otherwise.
>  
> +If both the kernel and the system support protection keys (pkeys),
> +"ProtectionKey" indicates the memory protection key associated with the
> +virtual memory area.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

