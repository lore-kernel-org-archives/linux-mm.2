Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0152CCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E8B6B008C; Tue, 12 May 2026 03:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665CF6B0092; Tue, 12 May 2026 03:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C2A6B0093; Tue, 12 May 2026 03:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49E736B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:57:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED07C1C02CF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:57:51 +0000 (UTC)
X-FDA: 84758013942.24.7ECD36E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EEF214000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:57:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfXib73j;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNgVdkCgiGLlxCkxIn/YtgUppy3+phcaEm3m+9Gyv7o=;
	b=0mcYcQpcdo04uKhoc/Jh6Y1TDKPr+jS2XxruazdRavS9fxgCpPuTawt2Pkhx20/854qW66
	r7FDO3eXBqoNxd1AOQMApewIKr3Ue3/8ELgBd7i9uD9KZVqsjhATOu169dGJLPE3HflKx0
	gVz062kF6mr8LTUGzAESYQLhOzq4csw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfXib73j;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572670; a=rsa-sha256;
	cv=none;
	b=qeSqSnQqGAvVITJpIqLlEIqgyq9eiAZ0+9TKp48P6Vtoxo5BPg87QoSieXbIWDBBi0urqR
	yeB7zg3p15R8Tf9DNipft6rZRrAmVVrz8lWiGEGBtCPyxyG3UP8Alj5WOr8U+bf+ScJV18
	a6tV0yD0tWWLyDo8OujyxH95ii6ZSHE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF974407ED;
	Tue, 12 May 2026 07:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0C8C2BCB8;
	Tue, 12 May 2026 07:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778572668;
	bh=ssGnryp0Yilk56LJoxUY5bwY6rU1fYkeibtaHfhOsT4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KfXib73jarYe2Lr4MOreoqXOU5BgAIHmuRo+D6yRfWhQ7dMNDXdrCKBJUDoxusY8k
	 T8ErtVIZKfoG7ddAv0ooRdp49Cy6VbKilu4bzrOKb5iDWUyKf9wPJLNryvQu8UtDsl
	 A7kNI9oyhtUHUSQY1RUViCf1FLnoKCj4UbKJJB+AXrz0G9101ufHdxsv+qv2aOuiWx
	 Ty7Y1/o5I9cqayGNqRGgfWIi7NLl2Ii5NG5/fKFYFPsGzLOgdgSG3AloMWf1n7OxXV
	 zVWzNnKrZe9G9jUFZNc1/cfyBMKR3l7w0RQSaE/64Zg1VPTGLrjSLP4hyQC6iwhrPj
	 eyMenNlBdIy3g==
Message-ID: <da82de92-29d8-457c-9f65-40fc4900b922@kernel.org>
Date: Tue, 12 May 2026 09:57:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: check file initialization writes in
 split_huge_page_test
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EEF214000D
X-Stat-Signature: onkafpthrbenu8h1z4gdf3z4brxenqmp
X-HE-Tag: 1778572669-123852
X-HE-Meta: U2FsdGVkX1/NTZmvCbYGXLjqN+IKwWwhVlfkS6g1dEucWo3Q2NJi7l/v4Dtphzk0gw9IuIVfawnWw7MuZkUzGoxLT6SjTxiesjYmag1+g6ajeFVuAtdhYeDxU4M8poUEPwbGQESkKCj5A18c4D6abAxQR6ixLbsfoWMokaFVVGuI+VBvHIhqsb3XbP5An3axxYik/hxNBUhUsdwew/QJyEDMoe6XqVCy4CkN0nLp9UzeC/MeSeafJetcX66q6F5IqwF4M3bgFtfhjnzq+yxcA1SUphkxFeyaN2Z7P6TNWGo/in6lmMhhxpG9s3UvHNIfiG/i1HhT73ZkJYf785j/JO1SV1crEN7TOaKPXq2ckf+XcBxr+X27UGx2Bq2RG5uWZ1ftee76yVHRS2ZBWKipt666snbdinDn412iTRMfrS0A0DF4DUhWYK5gXBZxC71qiOG0t8WMTGkySnXgtD2TJpSxh/o30d1no50ZFWZm3jwKVfiVES3Fi/76CpyBwJilHqowE/cMP7DZ0Ab6hfut7xlHdT8MG+434YYciPYOgYxylmLntCa5GefJqi0FpAlTcTwahLxLvS6FcYSl3wjQGR7Lw0anCgcef4aRS1esvS5OSWtp7eq80fMWm/KpGU1fXcJqcKmrOf+15qjPXg+yah0DlITVLB7I/ktSWFI+K2ij+RxBe9wOMc9joMtV07daJZynFATYNwAoLb5WaOHdEEtGWGIT3wP+AudqYzBc+HcDl2mFg6jU1NpLUvFiPrNQzKD4TDVKwG2FFytnwIWbaWrVcM8rxJqY+SANNw9ggFjfBmQdX17GyAG3uofFegnFuKLPOaq/+e9FDKyBNGhD0IGCrhYYxDLPRlMhlbIViig5jVXVPaaB+TQz0q9FZrazN+9G+QsNVlLhxrWJs6jKz/KwAoR3Hsi8cbh5WBva6mrJ0j6D9rycyNPn/9WFcKvzRr4+eeZls5yMeqXEUgK
 SX566f1m
 5h0mcuTJn0GEQjjQd2rEPwGvN/a3Y1HcNmldqEw6v3KLOEz9i2KEr/RU3cIv51YQ5oDerXtwzFDkqPUUsKurQHYicdSgx6KZkG9/UkGQYRPrSHtPkQGrwLvI7mpc3LQt5oyXnsuDy8ydc4i1uwAMk/DIfTtazUFaHf0ECsJPnHWNvaL2rlhN2IyfI+CkcBwd/g3yiDcrCfnL7H9g2aHz/9azPp0qMyYZ+/mOwqiPD6EOJDkZyc/1r4bBeTYtCgPUmJUAe3xUQ425jjpmp9sGnM2HYq+2CLiCS5IgPlFc3sA1l3fvTEijIYx1YmjbjG1FzCQVqozTvy9osd1ogzMmSKC6PKn2w0XjE102AmC2GaGn0rU9NKPfO8BM6Ab3RhTVsGFVAgFWAN/Z2w9r+xYZjVySUdYC29FSipM9Mzt29bYLPBAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 09:49, Vineet Agarwal wrote:
> create_pagecache_thp_and_fd() fills the backing file for the
> pagecache THP tests using repeated write() calls, but the return
> value is never checked.
> 
> If a write fails or completes only partially, the test may continue
> with an incompletely initialized file and produce misleading results.
> 
> Check the result of write() and fail the test if the expected number
> of bytes was not written.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 500d07c4938b..eab69b0f59a0 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -609,9 +609,16 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>  	assert(fd_size % sizeof(buf) == 0);
>  	for (i = 0; i < sizeof(buf); i++)
>  		buf[i] = (unsigned char)i;
> -	for (i = 0; i < fd_size; i += sizeof(buf))
> -		write(*fd, buf, sizeof(buf));
> -
> +	for (i = 0; i < fd_size; i += sizeof(buf)) {
> +		ssize_t written;

Do you really need the temporary variable?

> +
> +		written = write(*fd, buf, sizeof(buf));
> +		if (written != sizeof(buf)) {
> +			ksft_perror("write testfile");
> +			close(*fd);
> +			goto err_out_unlink;
> +		}
> +	}
>  	close(*fd);
>  	sync();
>  	*fd = open("/proc/sys/vm/drop_caches", O_WRONLY);

Apart from that LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

