Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C79E1FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8186B008C; Tue, 28 Apr 2026 05:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F5F6B0092; Tue, 28 Apr 2026 05:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5E06B0093; Tue, 28 Apr 2026 05:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 201776B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:46:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCC3C1B9422
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:46:56 +0000 (UTC)
X-FDA: 84707485632.05.E606EAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 391971C000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:46:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MjcSMSxs;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777369615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZX0sIfe/OVxI3cEaL2dwOMgGfvTdGSug1QHDDXbk2U=;
	b=N0/s/rqagbi/mlcHa1iGSJTCiPavdOsNAOayFSoEVWPKTwDR7UFLAXGAxnyD0hMPpVKAtH
	WsXgmJ5alnrzhuW/T3AYKSr5IO0Pe18lmFSASnwM/IdFgzoKMGXglljNL+ooNc+fTxFgsl
	PDuCfj3EQuEaiToqGSAbaMkx4JM6zvU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MjcSMSxs;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777369615; a=rsa-sha256;
	cv=none;
	b=D9v4Oi7tnMvtjsE5vUXs+1YkTdnXw0L9UKGKhf2nJkLCD0pDiP5R9FyNijZUuGWnj/1WPB
	MZGgd9Ojf38a77Lfc5q58fV2DYuSNPpnhO2Xb3HCLjZH5KIuwzWrDXq/E9rnDZmdg1ANYf
	qNbujvVgeGpFaANW9+3bZFkX9IIKfeI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EEAA60141;
	Tue, 28 Apr 2026 09:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F83FC2BCAF;
	Tue, 28 Apr 2026 09:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777369613;
	bh=NuCzlS/M+0qb9wYmyxAdJZ1X0Ei1vmHAzLdDPlKd0yU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MjcSMSxsedoT4NYhHO4hgQYknMa2fzyOyKGwVmjwecRlEcx7oBgR5fGxGFgqH81XX
	 QSjJRaPMlET2l4yyLaXwP+hbLXftS0dJZCWO6wzW85RXD9eWOYsNaiu8Dz1D5+EA60
	 utpi0XZfQJOC9FNp8gK6LB6pevLsLde5Y8JtfloNAXp5h3esC4gsA4vT1ZkzT9BW44
	 pWaIR23pVlUrgodkQDPPpfyfjMlw6jZI/P7s4hQofiCeVKAWZBWOWM3u2vch4+NYLj
	 gNHsKdHUJ6eGyi7a5AclBwYc5PqlvsQnZcs7vdFYouvwVXYHYHn4NRfqRHX+ep6fk3
	 mOGTiMv+hF/Hw==
Message-ID: <548dc617-ca19-45f6-852f-adebcf8d3a11@kernel.org>
Date: Tue, 28 Apr 2026 11:46:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: khugepaged: initialize file contents via
 mmap
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
 <20260428094356.60415-1-agarwal.vineet2006@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428094356.60415-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 391971C000A
X-Rspamd-Server: rspam06
X-Stat-Signature: s6tdbod6hxsow3zoytrte4boqognzqcn
X-HE-Tag: 1777369615-388469
X-HE-Meta: U2FsdGVkX18SMqF99UKLBRY9SbTTZOFIPcym4IiRFoihRMo7+3pAYl+1n4CGw4+KysgPTw6OM/19C+qKtoNEUQS6YwC9UujbGcOkL9ZpRvKsGwlBtZjHD93IKSCk2i7QD+DbKt3bw5oAHp6ftL82TcqlakGSquvii1LEOL60mYF2nUY8WKCmMS+0lprElwKOisuT2cTNWcLG30+lqrVZ9hpRUdHt8lcvMHdCVVUYKZFlUQlZujaKWnyJrR6KCHKLp9gyDinU1qefQMVMV6xR16iVmMBaXliZYiWHFrzEjF7CogFqUYFgJJMrq64gwHwsfu823WJwWuMFLT5HCxt40oy6RxVyRrjimqxoG0QIFA6tVYR/TLBNzVGgoVa0TiDll9xp4lHAJj2RJKO/pSpbpm2UDlN/7lOW7TrsgEDOR4bcD6mVuPIOlBmoI5UmPO6MqCsPVbKoEAlAbzMNHd7q6wbv0b1T2MFmBwyUCTROAvidAvrpvTsPP+/Hw9smhxeSLCreS+qsSVOIJ+scV7D0TUNlzy3gMZ9AiJteaWLPT2xrbEeFfcdO5UQACTr/DYgaXOSquCA7bVWoXQTN2ALUJp7yo8HdLHtzil6NRK5bu0Kt8YCjlyOB32gG1tosNrOrxIIfpcWuSGB4Q4C+FhNLdKV9wEgw8y5zn78eozb+5b9BcmlBMkVy/S3sDchOtTGXYvCrNNdD0At2cXkHj3edHGaKsQxBI8KrWCF/DQd7E+JnmztqWs2hAu8ozyohjnCkUZVrnZ354JXZPqD1BWciBv/LJVcxl1nqAxyQtth4RW60v59DLmGhseZm9vYeU29oSk+UHd/hy96wH5PMv5Wl+a8KThw6HV8XXafMEegpcBUNRS8esTqTI6s5KtpWW0nPuwMYkKI/Pd0tpGq/sX0ohezYx6NXjJIMd1Vn9FwcDRjpqQBQP2B+wAUCmDakey3Udiz/Xy9jZHnRqblivgU
 AMz4CWQN
 0TsLey8Ppmz9BJDi+hokNlSn8/uV5ki2L/C9uGE00Qdt4My8QdKCX8ho3AQtU/gIcfIbD3oJYUfsCI8IGY5ljZezNJGJNPe1d0U4YJx5ipKGrBd+Q4VCl7YVhEJpDrqqEWTvvWT2w+YO7fsU5CcC2AIc85EHdmfOG3ZlOx/C6azPHzLruAftm2QN3i8owdaLIUp/Sx3v9ve3zfvGAIIay/lHuJQjEgQFJHSh8qMrdZXNpn/IzH5YJxZkkKK4d/vvUE8Y6TKYNh2ZsCt2yQZogGY0R8xVWQy//1aXFh3iCgH12aS8hpmkCzCZiD4xYr+DrQGDnmONIIJc/8cO6XwyrOz3pmaCNWW4h0rW6sa+BsLiHuR9BniuzdKIRPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 11:43, Vineet Agarwal wrote:
> file_setup_area() currently allocates anonymous memory, fills it,
> and writes it into the backing file used for collapse testing.
> 
> Instead of copying data through write(), map the file directly with
> MAP_SHARED after resizing it with ftruncate(), initialize the mapped
> area in place, and sync it with msync().
> 
> This simplifies the setup path and avoids the need for explicit
> partial write handling.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 3fe7ef04ac62..f6e171e1da4f 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -369,7 +369,6 @@ static void *file_setup_area(int nr_hpages)
>  	int fd;
>  	void *p;
>  	unsigned long size;
> -
>  	unlink(finfo.path);  /* Cleanup from previous failed tests */
>  	printf("Creating %s for collapse%s...", finfo.path,
>  	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
> @@ -381,11 +380,29 @@ static void *file_setup_area(int nr_hpages)
>  	}
>  
>  	size = nr_hpages * hpage_pmd_size;
> -	p = alloc_mapping(nr_hpages);
> +	if (ftruncate(fd, size)) {
> +		perror("ftruncate()");
> +		close(fd);
> +		exit(EXIT_FAILURE);
> +	}

Why is that required? We write all pages.

> +	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
> +		MAP_SHARED, fd, 0);
> +	if (p == MAP_FAILED || p != BASE_ADDR) {
> +		perror("mmap()");
> +		close(fd);
> +		exit(EXIT_FAILURE);
> +	}
>  	fill_memory(p, 0, size);
> -	write(fd, p, size);
> -	close(fd);
> +
> +	if (msync(p, size, MS_SYNC)) {
> +		perror("msync()");
> +		munmap(p, size);
> +		close(fd);
> +		exit(EXIT_FAILURE);

Why is that required?

-- 
Cheers,

David

