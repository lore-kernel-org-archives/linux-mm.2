Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1708CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C83C8E0012; Wed, 15 Oct 2025 05:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2783B8E0002; Wed, 15 Oct 2025 05:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E188E0012; Wed, 15 Oct 2025 05:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0630F8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:08:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F16B1A0B65
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:08:10 +0000 (UTC)
X-FDA: 83999771940.25.52FB199
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id C708B40008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:08:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760519289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWdzM1o0bP51JTmnXgOxvnMFxR/jfYHObOzz7l/dgus=;
	b=uYjAXd0QfF8ZNpqW5ecTSUYY6Sa033AgvSwqW3LYi3aC4tNytH7R0T5beQuvP69tWTtWkJ
	wRIsHLxgTD0impcOeCGenBoqbAjkx+A8di4pQewu+Uvc2RNiZv0a+lxcxs+Mnvh8RnJE8v
	8B7GcUs4m8ALQKLoSP+ItHIxYOWie/w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760519289; a=rsa-sha256;
	cv=none;
	b=2Vk6iIzePxPqRDS4Y4ylXDJ8kK2xEPjjHs8NgRlkaI/bly7ijfwrr6vCuEEB3p/L+i1xc7
	DlCwHv0c0WfIgixb+jVRIpYcS+StKgwZQkno/VkiHuXpwpPFNILtcLmxz/89wu9UKtZlaP
	FQXt5pR8DXoXKky31TCmMJTbHCL7B2M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D8371655;
	Wed, 15 Oct 2025 02:08:00 -0700 (PDT)
Received: from [10.163.67.182] (unknown [10.163.67.182])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EFC5E3F6A8;
	Wed, 15 Oct 2025 02:08:05 -0700 (PDT)
Message-ID: <cdd96bd2-f759-4637-b61e-c77fcd9a24c5@arm.com>
Date: Wed, 15 Oct 2025 14:38:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: use <stdbool.h> in page_owner_sort.c
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251015085843.104443-1-ye.liu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251015085843.104443-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C708B40008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1m9tygqr74r5k3ugddbcej47rqriwzo4
X-HE-Tag: 1760519288-603435
X-HE-Meta: U2FsdGVkX189cMTAPm4ayazjuvZeVGLJDX4KXfS7rNVtnoNzxppnw0gQvcbLQzlpgv1kKj0EW7KphKnBANVsq93fRnZ3nx1n3mcZ0yladewlP3j4i5gD+/cmoMAidUf+UWQ1Lv7NrLKETEJkgNFlRZn9q8jcGQDzz7GzIFHzDVu5LS0oYF7CW6zWZheHXQ1IroZspkjsEKLn+o3ca9+yyPVPbjecc39RzixgXGY3Jy72JsTMpEeNzi4FM7w3si/SiAh+H42fOsnHHJnTTCAFBmFVHq4Cl5J+Gnd049yzYIdkeTI2FBRFbxR7N5guOvFGRysQxcHpKvbHg9lY7uzTlEKaW1pt7VS/PIZRptCr+A0jOwIbZAJqKXjnW3x1Fh+Nghl/KmECrFfsjCeghXJaovB49nISceesseoLn91r8+0Blqu7C1HCYxWKbAiSMtF2pHt8QmWfIbItBYcBqKNUMyB1TjJCJk8OZviFJ2dfXKp1ISS4ba9JcA/K69XKwoYpPrXGTM1DWN5/FOqOoyYkaSBxQQ5RD9fxn7hAyRNv8w7STPYGXwmnFKrwtiOqpCRlOaFJfPyZQETw5k0yUd0tCMwdc3DYOSJ2WWKT+Pm2DUT3kgZJWCATHD2XAxHlxeiKiG05XEu4Tuaosk+pT1bgsp1LHQm8V0accLewtiqmTeKsWr4AWMq318pEysRHDqld5ffnTpa7lfXN9VzF9RhbxapclUN/OmUWXbi/N6ARoUBdDTVHHkijSRoMluHX9sGk7YQfSXHu/2wY2LHAvA04DfZw5Is0VuW9StDF4d3f4qYG1nxlz7ATVAYiMqzBBfBfMBk6SPJR8bex+nQB8rypyys05VKhvlA81TFMRB8EdBEbIav+Agc/nPId5Ju+vSlJN1xCsVzotC6p9Ug1APupudHechUkDX/jQ6suUkIG5tQogLLMzU+3MrzEfAXGPR5mPnF1n16DQo6lXHA+uwr
 hK+1khZ1
 eewxFoNsDdit5LfzfnOOC76drzpS/1afrgRnhkrLetHGzYxuyTDosst06pHVedplWlvRybEPmM9GsSCUAGQ9W8vJIUJWjah53KwIEQdzTfUCpjq+C+WYvM+lZuAWHNScDHDzRZbvpyx05MrDwOT9y0MMz2l1q0sZNDRzFRD2OJDOUDSHXQQumW1Rnhye25xe8h0J4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/10/25 2:28 pm, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Use standard <stdbool.h> instead of manually defining bool, true and false.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>   tools/mm/page_owner_sort.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
> index 880e36df0c11..cbd195d7b5da 100644
> --- a/tools/mm/page_owner_sort.c
> +++ b/tools/mm/page_owner_sort.c
> @@ -13,6 +13,7 @@
>   
>   #include <stdio.h>
>   #include <stdlib.h>
> +#include <stdbool.h>
>   #include <sys/types.h>
>   #include <sys/stat.h>
>   #include <fcntl.h>
> @@ -23,9 +24,9 @@
>   #include <linux/types.h>
>   #include <getopt.h>
>   
> -#define bool int
> -#define true 1
> -#define false 0
> +//#define bool int
> +//#define true 1
> +//#define false 0
>   #define TASK_COMM_LEN 16

You forgot to remove these :)

>   
>   struct block_list {

