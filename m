Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A36EE36AC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5D36B0088; Thu, 12 Feb 2026 12:04:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD736B0089; Thu, 12 Feb 2026 12:04:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF3A6B008A; Thu, 12 Feb 2026 12:04:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4EA6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:04:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E06D4140259
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:04:08 +0000 (UTC)
X-FDA: 84436427376.15.009C575
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id A138C1C0012
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:04:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770915847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GgJE7pR3GhQaNo5/EA5Ptpb5QonxrLAyGpD4rS6qA/o=;
	b=tCXrAWHJoSrSn+xAKi01rLl5GEnC8TBCif9O+LN2BOWsaF8I/odCKC1bx8mSrh88aIdZR2
	EcWcVh137acUdS7hizufI76zpBvb3R4rIgChIGzlaY9AK8i1fueSg7eN5Mq112efElN6BV
	C4FsySyPrwbzoYipa5IFkgCMNw3eaSQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770915847; a=rsa-sha256;
	cv=none;
	b=MQ3Ao8tln1NZ9OntUQzw6ZyNjM3pZat1Km4Co2FQGh6qzmTG0P6cWWJxlMql3trQFz0ixg
	2b8j4MOiR5SgMwmFEns9uDE2UWeRz8EDFo+qMGw7Rs1kf9R9tqAPkgNdvjrerS5yoXxxQj
	15cuKQb8xP9CB4fpweUI5EvUXUeY8gM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 339A1339;
	Thu, 12 Feb 2026 09:03:58 -0800 (PST)
Received: from [10.163.135.73] (unknown [10.163.135.73])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C8A93F632;
	Thu, 12 Feb 2026 09:03:59 -0800 (PST)
Message-ID: <a354dfb9-a125-45cc-8937-84513b296274@arm.com>
Date: Thu, 12 Feb 2026 22:33:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Remove duplicate include of unistd.h
To: Chen Ni <nichen@iscas.ac.cn>, akpm@linux-foundation.org, shuah@kernel.org
Cc: linmiaohe@huawei.com, nao.horiguchi@gmail.com, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260211064311.2981726-1-nichen@iscas.ac.cn>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260211064311.2981726-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A138C1C0012
X-Stat-Signature: 83fiu7pygk3muk9egyf4ftwuguyyt5he
X-Rspam-User: 
X-HE-Tag: 1770915845-636873
X-HE-Meta: U2FsdGVkX1/wNzcyfb9kmaTNLltLP1m9QbaYQoifgz8qatLiWbOjalt8Y1NwWneM/1r4FqPQ9eJfT+t6ion0AB/GfjzUX3VmfkQYEZnZ69ja4OrTcPKXN3xYXvAzwFdRNyMR4lDcVcpJoA11H2iEO5vkEw6ng8UyK0WLcddSD1sVzralmPsAaiJc2e93jMhZE4UiyK9VAgml2cFnR8q42x5aTIaqy7sOwcfEV/3JARU0XnFgcbUq4bL1rJh4N4B6z8Hig/LuJwB/X2F2vXB4BCmyLei+on/hAiArgeuHgFmfIzzEXTEVuXbWemXj+8sa+QMgTtZbHIJjt1XbSTdJsjZShLOOizB+wN3Mg208W8Mgf8L40axFWrWRADEjychxxn034+5YgQ6MiE3CrOQoFfjNY1StZGaEea9qrKdIt5Og15qWWfoj4wOlH/8M84LEdUJ+e+MIxPEUlmYEI5uc2zMGnrbkkF0E/2b951YOrXoYvEllCpE0NO0VmY5yLEFwAK86EJ3tYwQrcWIduoI3TfCAei22s+H8UebOWWXWMEURS454dDHmIvhkZr0uHxQaj19dxF0TZGmtTIWFH7O4wWhhmcSfQzKo3N0nI068JXtU4iK0hQib43lyhelmLkEFWC2e8D/tctx9Bgvo7oZKGbZseHYoKFzBcee2XL61164F1/fXJZlS3Cs36Zcgb64IH80WjNrMj+Lisf0mHBThts5el4MMMt3kegWMVHtS3DjA899zjLAaMtGGOHNIKry0EhlPSfpGWUVLgN2DQpKz4vh3XnwrmOprAZhfojYAfcx5AMshXEwqIFrHEkiUU8+j3KPvSqgumadkT1dQLy+Uaz3TkcUag7gU2QbwH1UJMyxhnv6UUu18zdEKqPzZSdUrV+uL5u8b5axZfuZ0TlsYk99EPH4saNETffWZh3OzGujYYtjqKZkE8iNyk/PpheRQcXYqVfhZF1LjRzohDHR
 eRJ2WFpP
 BCjC8yPy9HT2fmTQzBwzvcR6P8wo6fiPKxh1WVjkG/bsSIYPQDqdcwV+fNVhpXUz0GucfvBi9PShLrcGYJSpRah6uRts6HXJyWAyQKOJ7hMXs4Co4FeREry680NP+Ibr+Uia1eIcPP2W3PFbY4hAAyVRFqTg/e8h3qAp/eLgNFuTQN8uDbdcUy6IxRt5NQue55v9lI8tchrxWk0B1Q+AsXWvuJq4JmzVvxD/9PMI8iioHjFbcWQQmIHnMA7ol1RmLtBiw8iMUGj9JADEnBmtM6qkSRsRS9HDqB/H1GE0W5oy1yArB9/f76zpbzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/02/26 12:13 pm, Chen Ni wrote:
> Remove duplicate inclusion of unistd.h in memory-failure.c to clean up
> redundant code.
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  tools/testing/selftests/mm/memory-failure.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 3d9e0b9ffb41..032ed952057c 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -13,7 +13,6 @@
>  #include <unistd.h>
>  #include <signal.h>
>  #include <setjmp.h>
> -#include <unistd.h>
>  #include <fcntl.h>
>  #include <sys/vfs.h>
>  #include <linux/magic.h>

