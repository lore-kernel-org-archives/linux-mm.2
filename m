Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8600BC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 06:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C866B00EA; Thu, 22 Jan 2026 01:16:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3ED6B00EB; Thu, 22 Jan 2026 01:16:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2CE6B00EC; Thu, 22 Jan 2026 01:16:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0576B00EA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:16:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A50FD1E2E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:16:09 +0000 (UTC)
X-FDA: 84358589658.02.80EB432
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88B5AA0003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:16:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769062567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XPMnw0p4O7H4pPV+pOcEKrOxcoUIA2Jfvmh+8om7vlg=;
	b=LvuTxV44/ThrFR/5X5xnc17/JNzKuk5dyG1N8s3iZ/gMfuAHtTf0EM8tHiZSeLLhDdWdfi
	FRtXwHR0cOvhccZ1s1U0Adle5c8UAeDlE3KX2vihspXiZli1L9UfJNA3yIGUhVUR6Fnby7
	c8irqf5oiK4fxiaE8kKTcaDyli8mzr4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769062567; a=rsa-sha256;
	cv=none;
	b=WHM2uZAPc2b1Uxa682g/mFU9nI2Y1xuOf4bwBVef6u5MSLhRioViR6qHfWMrORtCzqlEQM
	e2XoT8M+ACkTrC0xmQjfQpXB90FY0WW8HQKxIluFYpQQj50lNL1NWKFW2qvkANvnWbYAaH
	d9eIUpyvIQuKI4QQfM6bXi5hn8QF7dw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B9D81476;
	Wed, 21 Jan 2026 22:16:00 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC71D3F740;
	Wed, 21 Jan 2026 22:16:03 -0800 (PST)
Message-ID: <a3a8784b-4a4d-457c-8fba-1f27a71d5a0e@arm.com>
Date: Thu, 22 Jan 2026 11:46:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] selftests/mm: fix faulting-in code in
 pagemap_ioctl test
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Usama Anjum <Usama.Anjum@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-7-kevin.brodsky@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260107164842.3289559-7-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: i745fbfr36u3j7jn4wf147fr4edsj7ao
X-Rspam-User: 
X-Rspamd-Queue-Id: 88B5AA0003
X-HE-Tag: 1769062567-587966
X-HE-Meta: U2FsdGVkX18O+c7LiDJNEMt7I1QLyPg4Rw+cLaY7+kWa1rVfkSOpXGrbroQeoLrc7g6CYj3U6Bw/mV0X/66oiIYhC1CI08OCLk1eiNyMXRUI0wKnPOsd9fJrUdGzHCNCwhQbxMnCK6xKmN4eBEaKoJrhR0b0qikMkq/lgrodnk8/fQ2ieJuSfud++MaOAB1vtaXl8ddjnD3LQs80d7RdZsxl1VdOjVpcnHEo07Oru46DTa/c96jlwDHwSkFDza6oGT1p64FQVgEimt5WmKDtSNjJiOk9gWzLQBWK1iIPHWF+WixqIgreQrfSuqhdqovMB8+2+rjQhT9CfU+oT6MabYzsUdRsdw3U7Mw77aWwYymFzT0JifCyg8YEIRPVIcU1cyEJSjiCWS9trs+M/IvHvA1J8KqdQ8XQH7eZZuCwO/cajcTTqpkBHkMpivtDj7dz4pu/LljvhIHg62y3B81mQFlAr7q6FGjVNikvZd5IZMvZ/zTspkLxYNc6bcTI1y1SwJHogketYC96MNTCxPMapRc4njen10l8ZUqcJEQsv8krpyaUawRZsSuF4wrBsNXC3pxI94FmzNjKgZeRb69J1GzD9xG9wi9cRX2PwcuY7aa3va6FHuOpKW0bXQEGLA5JPRtUQqB5FMGkITS+0CG7f/N3z5llLEGPTMMYdmjqM+EoxaMyDndIDif3eUhTYqzWu1JL7DwEiDCiCWe/4pJa7X5OnAb9MqF2Mr3JprnnC3uPJkv5XMLTyrU5jzjNPDbo4aTkiQt8umyuHZ3an/yf+P/Vpb7rU5N3sZ32PbGMuJOcwC3+2sQMU/KimaAYrtrttNNcadQtR01N0AnCRTlyVl991CQlnkoF/8+6rStw/E8su8fJC2jKaG8+eUd6/3Iz+9UxeXrVO/KfQBcZhaXqzGCM0/rbNqffvn/a6AoiXVd0UzsBEKF1cPQuj7X2NI53ro2R86Qzlk9PjMuLn66
 2XYEsBmv
 gKzmjx7Z9K3FBhfT/UslRw9Jj2i8gt+4gghuF0/YssRgj82/lCUH11UEBzRQsFs+WxqQL0+zAR013NtgkffXiTG51NsJbD8k96kKKyKsALal4Rbn/ri8oUQNMBfC6dIo+PiSAqHFsAzTKjla0QpOtn1LrdH2GhtbEugkNM9zzCcQrWLgZ8Sisvs3H53iffUqW9vT/L4+Pve9Tj6cXDISssaCCMLQI/oIGaE/l8ntcMeFrncZzRFSLDcnO/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/01/26 10:18 pm, Kevin Brodsky wrote:
> One of the pagemap_ioctl tests attempts to fault in pages by
> memcpy()'ing them to an unused buffer. This probably worked
> originally, but since commit 46036188ea1f ("selftests/mm: build with
> -O2") the compiler is free to optimise away that unused buffer and
> the memcpy() with it. As a result there might not be any resident
> page in the mapping and the test may fail.
>
> We don't need to copy all that memory anyway. Just fault in every
> page.
>
> Cc: Usama Anjum <Usama.Anjum@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Reviewed-by: Dev Jain <dev.jain@arm.com>

> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 2cb5441f29c7..80d7c391f8f5 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -1056,7 +1056,6 @@ int sanity_tests(void)
>  	struct page_region *vec;
>  	char *mem, *fmem;
>  	struct stat sbuf;
> -	char *tmp_buf;
>  
>  	/* 1. wrong operation */
>  	mem_size = 10 * page_size;
> @@ -1167,8 +1166,7 @@ int sanity_tests(void)
>  	if (fmem == MAP_FAILED)
>  		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
>  
> -	tmp_buf = malloc(sbuf.st_size);
> -	memcpy(tmp_buf, fmem, sbuf.st_size);
> +	force_read_pages_in_range(fmem, sbuf.st_size);
>  
>  	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
>  			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);

