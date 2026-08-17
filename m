Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8354C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0249D6B00C9; Mon, 17 Aug 2026 07:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DCD6B00EC; Mon, 17 Aug 2026 07:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C6E6B00EF; Mon, 17 Aug 2026 07:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE1036B00C9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:19:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37E851A0765
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:19:41 +0000 (UTC)
X-FDA: 85110516162.20.0CAA3DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8BD9710000E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:19:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4zeGcmT;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786965579;
	b=51WYlKPNGd95LHJT1Tas1q5YsTipoUBg/Pef3FP4y5iXLVjdYb4q+znGw8xWc+4Z9QSomu
	0k8AiWptZYpCTx/XGsIHIXcpPz0TQlQmDoXS41kGi0Zpthurp3BbKe8kldmwD0A6XJma+u
	27GSK1VNXuHqcq8fAZQDNmhAdlgT51s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4zeGcmT;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786965579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wjAZePGPW+1lTeTzAWETwTnmwk0ye6Pox92ahi7Up8=;
	b=WIvyuSJI2acbwG4nbPmTagOKzLRKwPrwiXdt23BpykOgbVxVBFGG6r7nyzkyGmM9CEv29n
	d/ehLkAAreEyp4MCPcuQh2K7Oc5BODGfxgpQmO3Y9KmkQQ8NTmajmPeDkXumrBEXrwWMXF
	lKI2PmGVOpUrFAYa0cCc4faoiR7/wRE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A6B4601DE;
	Mon, 17 Aug 2026 11:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F400A1F000E9;
	Mon, 17 Aug 2026 11:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786965578;
	bh=/wjAZePGPW+1lTeTzAWETwTnmwk0ye6Pox92ahi7Up8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z4zeGcmT+UuQPCMGh2Qb1ampLn0x8kI6lKKajPy+kHr/YJdDeQZ5PUvwAVY/DMOi9
	 eZ+DhB2uGw0nOayDEqNh9xGOlS8+qeJ40L51RIC/DeHnHs36kagJgiIm670DUy+/OC
	 YuaZTE57Riz1BHN8QGFwLslEOQM5DY0NWlS9XcVjB9XK4jWL5CFtbCIIX85OmtjjKT
	 ikX9U0LnSac9ik3xEwuQtUA3RIvW3WcWWK8XBlmaEb4gYGr6f30AGPgc2EUDhEQCgH
	 +Gi9sjIPEQ7DoBafyqYdggJkiO9TPteLICZ9YxYO6yHaLR8+KZm18P5/4Xdh/ns77A
	 pjwAdRGxvraFg==
Date: Mon, 17 Aug 2026 14:19:29 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: khugepaged: consolidate error exits via
 kselftest helpers
Message-ID: <aoLuQV-mGq-4wKf4@kernel.org>
References: <20260817061955.45454-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817061955.45454-1-hongfu.li@linux.dev>
X-Rspamd-Queue-Id: 8BD9710000E
X-Rspam-User: 
X-Stat-Signature: n3ou8ujzeweks87eamhbs6ec8zgeguys
X-Rspamd-Server: rspam06
X-HE-Tag: 1786965579-891638
X-HE-Meta: U2FsdGVkX1/c52jKj0yaN8ypKkVwVm26fhriSx+0Phkg/TA2jlhoPubeiGoeAl0weiDWRAqsdsREjngcrnYq5aM0seKmJLiBF+npXyWWC0ChdIdd7qnpDCF0+u0A1dZE0XvhQHZzhMgp52tZ6jj74h+WZORhJLVbw1qDIV5656V5amDVOPhfmjYquC/a64Nkvb+vYtz3mvR6rkacbQaNMrqn55qISTVn7BbRY3FBI4i4zzqkdq/+cp/5MMVJYDN2pWhxUQLPDFT//s/lVppKWuRim3dpL2F3GGgO3T93f6AHaRjRgzrwV8t1jfn+q/lib/9ZNSpOpvaJJ34iTouAD/r5uUv977CGVLDGAIrazEbYgcDLVXQE26EH/nKbT4MGTW66Nk7/ZoyGrLzg4aNbg89bPV0d0rxIKSO3XFE633UAi08GAZkkEpP4xnU+xLfAR+0XUsyIE+dRBSQx0dQqKeAjzo+yR3o/K6X6pHHn3k0ETGsZtZH8mW1vMJLwMcOavcmLtifAa0Ugobl6RqSU01ngd0WYwLt1foEmkh1CRIjWrFfI4Ja8z6WbruRCWKwf5YdUMKBAC0Ycd4r2F+6CZ20pkWleSpZ8a7BZqycxJkHkDmuruFTfgZf/Sw8+zBfOQb2zLv1N4XbIBO0L56s7aFT+e06uVwDYK5/Bt9PcbgVXUnDAyJNs3TYqS0v3ebxDspFtG4amM5GIoXrdSVaI4BEHbSRQOw7z82TLh4kXKKvrdXRIU381iNvz1Xzt5GZ5NeNQijE20Lx8+++33Y/fM/yexO8k/3rLSlq2CHwDQ0zltUnHU4nsteoc5LmkYsb+F9U3t5X3E02lu+W944EU90/iKt6YWwSNAnbAO997W8CtDxGJ3WZogJqYU6HV8A48zD+LSCawP4JXneYOyZJKJ4EhDR1M83iZeBR0wLQQRkOe8Ue7pKBjeIb2sDCmRKbv0ymEsbYMlM+qpKRGU/m
 0CwFtPha
 sh0TwXbF6Xo17saOAz7sCPELYNIOivfMB7dj5LGvhjKTaeZtD2irkeFMY14U9lFVnU5ylUvLMSROL4abScVc+m7htsnWOjQK13GTBOasuHvKtHAPfRp0hfAsvjAf27lVhWfnhmdRq4jVqu0wlGXf3QfYrjbEd6m5wLUtoWXRyOd5hpMaQw+JWfKRavtje8bm+cxSwdNbX8mNrcHXEJ9xpOe93N8V2YQM40fI7wzA07ePYscEz3ym5oW/gQJFCZVJXpMBPsdifdy5yAemgALT3Ybsmtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 02:19:55PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Replace the perror()+exit(EXIT_FAILURE) pattern with
> ksft_exit_fail_perror() so failures are reported through the
> kselftest framework, consistent with the rest of the file.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 0d6c71ed2fae..8d1b87f2195c 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -358,21 +358,15 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
>  		ksft_exit_fail_perror("open()");
>  
>  	size = nr_hpages * hpage_pmd_size;
> -	if (ftruncate(fd, size)) {
> -		perror("ftruncate()");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (ftruncate(fd, size))
> +		ksft_exit_fail_perror("ftruncate()");
>  	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
>  		MAP_SHARED, fd, 0);
> -	if (p != BASE_ADDR) {
> -		perror("mmap()");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (p != BASE_ADDR)
> +		ksft_exit_fail_perror("mmap()");
>  	fill_memory(p, 0, size);
> -	if (msync(p, size, MS_SYNC)) {
> -		perror("msync()");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (msync(p, size, MS_SYNC))
> +		ksft_exit_fail_perror("msync()");
>  	close(fd);
>  	munmap(p, size);
>  	success("OK");
> @@ -447,7 +441,7 @@ static bool file_check_huge(void *addr, size_t len, int nr_hpages,
>  	case VMA_SHMEM:
>  		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
>  	default:
> -		exit(EXIT_FAILURE);
> +		ksft_exit_fail_msg("Unknown VMA type\n");
>  		return false;
>  	}
>  }
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

