Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25B5CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3FE96B0088; Tue, 12 May 2026 07:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17586B008A; Tue, 12 May 2026 07:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53F06B008C; Tue, 12 May 2026 07:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C841B6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:13:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7430EA02D0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:13:26 +0000 (UTC)
X-FDA: 84758506812.02.4E99CB1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id A95372000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:13:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gV7TN+Db;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778584404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ptym+zcgxtoW2DZJWr1cMq8C6Qk+XHoj2FvlPceLXHU=;
	b=amLjpOkmgeNnoUFZ5giydV0HKUHIspB2ZR2lwLAaW8uBmcOrzIrSQr0Qjwn/klcDGUWldt
	fQ8NWjba9fKhPk9oQKRWI2BSENFb0r5MfCiCd/rwucxhz0Qj1satD5WTFoRcc/xq6qQvci
	zce/kNptjoA8OgxdrY8gc7YGGZDEnec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778584404; a=rsa-sha256;
	cv=none;
	b=fywGUTm0HIuffy1aRZi1VWdSKfgyO/dR/sSiXSgBEcIxCq4UvUYfyv8WupUZzRs7JojsRO
	a+zer+wzwTyfP/gBeyRIVhZPcV3nksZhWz/vIQoCz4QoEmeUwBz7OZfNJcBmIGirEwz++J
	U5c4fI4qqeb6pVr6y0xbfVoMwT/DEJc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gV7TN+Db;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26C6C1691;
	Tue, 12 May 2026 04:13:18 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A1773F85F;
	Tue, 12 May 2026 04:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778584403; bh=rBzh25T0xairjqFtgwirNaUtmwEFujCzK8ALPjS6dRg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gV7TN+Dbz5tzaOrAbCMWHlB+ykfhxbyPEdM4wcjGYq+0I1X2m8RQcA7h/EnzXTodh
	 shob5b98AgeVYcZX7fZWcMf6PGfj7nb0xTIc/7Y+kJAluCLYK6muaymcTD0KUEIcvS
	 /vTSpdtMRdxyAQJQtmQ1brWsFwyRQPX10X+gxOYc=
Message-ID: <df87e6a4-b157-42c7-a596-cbdbd99806cd@arm.com>
Date: Tue, 12 May 2026 16:43:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix mmap() return value check in
 run_migration_benchmark
To: Hongfu Li <lihongfu@kylinos.cn>, jgg@ziepe.ca, leon@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260512101305.139509-1-lihongfu@kylinos.cn>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260512101305.139509-1-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A95372000C
X-Stat-Signature: t6jd4yq7tqxogcbjbyhffj7unr6wbmx4
X-Rspam-User: 
X-HE-Tag: 1778584404-314650
X-HE-Meta: U2FsdGVkX18hEGis/WbNCgy9lXnFQDvJTKeolS+ueabrtIPf64e3cdH/fPfUhLOFAsI/CtXgCwoZ+cRozFKPl9JOc+YIIAg3r0JJTouwUotKrPF3sLqliULi5TmxRRUQlxmEpUo2odwCCQnyRMc8ekce2TEqGhY5sKmG8zXWrBBwOZSUVdhzUCwQkSlxYOJ6lkD3cYdN+dlvvXjn9RZf/psEQU29Aw38yY3MH8tte60jcIwIPEnPpI2QpffgntSMpW85xRXLtzobmb+boSd7q0J7kkJVVxGmJIF8SNRK1sCRDS4s2mrhhHIQ/IXXA8M6k1LY83arRJk+tEMdf1BFEgvdP7KaB/dkNoFEoWshEB9Gr8CGwEPiNwOZvcbg/vj2zHrOOWmyKwakq8Yx6XMMiDBt3UFOyRw33IVgpguqaDfECEZZMEjObM9QMXPHI76oh7USSSMcWPsohI9J6KAivhdmrgv7K1M64xr3XN2Djtyj+m3IL1fYLFqLmGnHJ9dcOiPF/VE7ln43EXtRnyuR4Kej3VayJaEAqhYRKE60i06zWRpbbCONYoNSjbKTEt/qtGF6NAynOZfje/5MC/btOHFyH2+CJH/na9EOEyCFqeN9VYxvhHyOyQBlREt7frfgrH2QilrUx5ZqfJ1N5oWgJC3PTEMhD7jLaLZxqggjEk80WorOw555F7zs+DtwP9EcZHL2XZDh92lmNznuiNYy0d6PyFIBQolUuHFomBR1JpsT1aDeC5ep22OD/7N5fQa7xjbj6ihYMEl8IO07z1U4gP0orp9loafi1edS/+6eR036ARfQw7MFDuqeNw5vOiFZatVyUuKWkhDnn2jouxbDJ4KGfex6faEEFgU1QYH4wIljP8Ad20RJp+6P+tsoBUB3v407RcDLftkPciPLrhB+o7cs8os1BcSS01b0A8cgb9w5VPMei1DSv6d35kW6NqvMwaIvvOO9emW2RrOhYAe
 YJcMP31h
 4Y0nML6y4W7YhFMmxy0iyaCWiDlewkXaFLMWH7UdRGWIC/9B5jtdQrYbA5UJ7id7UUjJLQiE+jfgbYFxqE248VO0yLyhDC7cMnfui2b5nZ5dgefeQ+MqgcF4fa+V+3ALe5q7jyY9IIk4S7ni+yXSUuXoo7wuOkTigfBEQCAlRmgzYRT3IElF4Q+4GmE6z/sSyIGh+6BoNTK+6OcBisZQuGd6AvLmRyrZG8FAgap3MYoWVCY699GEqJ4k2Ni8J6BE9xqxq/38enHN+vjNwG5GBmonr7Gta3OcD0LYffdvG4l0MvHKU1t1zaYc4PEKXuekEDIeZf4At5crurBh2TE3hcwBRPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/05/26 3:43 pm, Hongfu Li wrote:
> mmap() returns MAP_FAILED on error, not NULL.  The current check uses
> !buffer->ptr, which evaluates to false when mmap() fails (since
> MAP_FAILED is (void *)-1, not 0), so the error path is never taken.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  tools/testing/selftests/mm/hmm-tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index 788689497e92..d72adba5c74e 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2688,7 +2688,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
>  			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>  
> -	if (!buffer->ptr)
> +	if (buffer->ptr == MAP_FAILED)
>  		return -1;
>  
>  	/* Apply THP hint if requested */


