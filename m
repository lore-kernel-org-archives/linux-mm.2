Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B6FC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 06:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82ED16B00EC; Thu, 22 Jan 2026 01:22:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBAC6B00ED; Thu, 22 Jan 2026 01:22:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711AC6B00EE; Thu, 22 Jan 2026 01:22:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 602876B00EC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:22:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E60F51AEBDF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:22:22 +0000 (UTC)
X-FDA: 84358605324.04.10ECB1C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2D07720003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:22:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769062941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=88K5L3V+VvX+ZM8Xb7PFrjC9E6U6yjCAoaG/3hNTgaU=;
	b=JYlzUmRMhKBugUSjT+XxO8AYZ1n6PEujVZijFhzy/9zoIL3JoZeTczN1j6DHEp8fnW5Ufo
	4hr9bJMguCq+aQlcFuKrM2w/l2ADTaZrRC3e5tlqJZwebA8ltg8R78h2lgjOLJwyPof7P2
	mq/Ser6ESP0vmPXoejqx0KOK5nJ8IGg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769062941; a=rsa-sha256;
	cv=none;
	b=gpugrawf4Fkh9TPnLCnmIqjOT9yNOz/YLbaP5ai9IF0X+/Z7pEWNeifeEaHRXFAf4tQn98
	VnfX2FDQi6z/PrXAmAFtoz23aGRKociQu+V/lCzppW4fIwNjrhWxOP23rF/WWCsLAxHg3j
	dgttHuy09g2Scfum4hG3FrBaPMyZ5oU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD5031476;
	Wed, 21 Jan 2026 22:22:13 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46DE93F740;
	Wed, 21 Jan 2026 22:22:17 -0800 (PST)
Message-ID: <0e5e303c-19b0-4c16-bd94-2354f6553846@arm.com>
Date: Thu, 22 Jan 2026 11:52:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/8] selftests/mm: fix exit code in pagemap_ioctl
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Usama Anjum <Usama.Anjum@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-8-kevin.brodsky@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260107164842.3289559-8-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D07720003
X-Stat-Signature: b1t9pw3cob5o4jrkug7qc1ahzzzxfdro
X-Rspam-User: 
X-HE-Tag: 1769062940-766267
X-HE-Meta: U2FsdGVkX19Cg3i5mXQ5G7Y7E7HB7Lf0sRdNHR0b//uJPBYhrQQHajLngXqiGo2ZQUTdJRCn4v5EMqGeN9+00/1yNi/4WSdxMdiikib2jhpIRMFkPqTgtc9Ol+OCnntyKcmVLmslI4EsifRoJDyxlMkHfWiNRLjy1tiDMeOruKgaTzpAx8h1XVtSue6+zRrvhwyTP1APQZ/7q3aboJhBaFgHNBuClUzV9keypjFP1sAuydeYWFnQjZbXE6S5Scv2OQ5zTXss8TEhXwqHQ8JyJiX0/QGZt/HE5tjbIuL0Dx8bsXPXfet3jspQMqnfWpE+H3u6KhVosIdbLTtADr7dBLwy/OsUt/VnQrd831WW6Z5AE1tyyUgMBDuzgD2+MCRCiU0z2YU6a2G9E4dMcOECx8Pw55y7YcqtRS2yCOc0xbweCkW5bMJ93J4lH/l0yWSmb/V2NlL+GZ9We5kN7M6r8OTRopFGLyyd4GUB6FPolbexD3K0yt84wLMeBdTS9gQQXwW6yY1nX7zcjsEiY6mP9y7g7MmPbpY0RhNvq5P8ehC1vIVnqzZTwcGy19jtyL/oWgP2MRy0s1LaVyi0SH1iIiEJ4rVC60SnE2fPvkFPVweGA1Hd9YzzqvbMIbQyjQZo2oesqbfcEMilG8RO+b2keVbZS/tkZZjGJXVvg8ibeALRd/Nk+UQHCjYZyNJqAdXGGSAi6jHxf1UKHuAPYhxNISlFIQlYk3HkWgrkxpmuWyfQhr9C4Lw5hQQfISxiZxE/Bchk1VjFIDe8h20Vdsp8QdLDcA3NADW5Rl5SsbU6URQiIENTYhYJP6moIS5a+IAGob7pkHIcbNvE1ucWi4k2Z9iz96C+WO40RziB9ivL/EPh5a78OkSn39tKhcNNBzsXYyQOZBHAoWXS8iTKhouxoecUR4kNWFfIyetmSZHQLi6udbj/LyWAKkoeL/bmHI/b/ebeb/hpiXnmcflu+5H
 ktC/guaQ
 tK/2jTyNRptO5l9lAyTlc6bAXm4HNCHOd6Q/7ejYZ4ynWo+Q8d5i1Gct30iAK++Of2fQz8gASRGulvkmgaJSAxsCj3dUP+NWkfd39Hb3lOrw/xgCzcf4z5SIHXegYJKH0iqjIA7ItS1rrFlKn0Gb6eHOpk/pft0f+fUIVwgxFN5tv6wlSSuuqKgQOm7lWoh1Jd7c1QKv5PbKzRrezJvpnD4jfA7IG9bO7pStMZAeh4Ijsi/Ac9/r6BG2WxO94BmScTJawLZatONzEI6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/01/26 10:18 pm, Kevin Brodsky wrote:
> Make sure pagemap_ioctl exits with an appropriate value:
>
> * If the tests are run, call ksft_finished() to report the right
>   status instead of reporting PASS unconditionally.
>
> * Report SKIP if userfaultfd isn't available (in line with other
>   tests)
>
> * Report FAIL if we failed to open /proc/self/pagemap, as this file
>   has been added a long time ago and doesn't depend on any CONFIG
>   option (returning -EINVAL from main() is meaningless)
>
> Cc: Usama Anjum <Usama.Anjum@arm.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Reviewed-by: Dev Jain <dev.jain@arm.com>

> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 80d7c391f8f5..7b214e8755f7 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -1551,7 +1551,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  	ksft_print_header();
>  
>  	if (init_uffd())
> -		ksft_exit_pass();
> +		ksft_exit_skip("Failed to initialize userfaultfd\n");
>  
>  	ksft_set_plan(117);
>  
> @@ -1560,7 +1560,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  
>  	pagemap_fd = open(PAGEMAP, O_RDONLY);
>  	if (pagemap_fd < 0)
> -		return -EINVAL;
> +		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
>  
>  	/* 1. Sanity testing */
>  	sanity_tests_sd();
> @@ -1732,5 +1732,5 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  	zeropfn_tests();
>  
>  	close(pagemap_fd);
> -	ksft_exit_pass();
> +	ksft_finished();
>  }

