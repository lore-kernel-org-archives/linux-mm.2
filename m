Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026CCD609A1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD016B0005; Tue, 16 Dec 2025 09:58:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3C96B0089; Tue, 16 Dec 2025 09:58:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D44B6B008A; Tue, 16 Dec 2025 09:58:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4B16B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:58:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B733359FC6
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:58:20 +0000 (UTC)
X-FDA: 84225639960.09.A5C50C6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05AAB40005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:58:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765897099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2zdyYVBNlZ5QjL1rgMjcKL9/ZT1VUndSTfu2B4KF+Wk=;
	b=o+l9Xepl/OYPb3sAZ3bMA9lkbQe8zFvLANRB9oF+R9tK05j0NE3T3ZCKqFpolj05mVwEh3
	FL33GGxdJLuy4JMbI4mFGwmF3+VHWZV8YqIkJLy9DGFxgox2GJiDWuqBCSjGzwb35GRrgO
	xXvidXWwesuDtwqLK56KCp6dW3JX3jg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765897099; a=rsa-sha256;
	cv=none;
	b=kVoFZuB4J9/Ey+ivrxBj1qvGIN1ad9s+icblRb12Blwo8KG8D5j8gYHUDluCnxy+4abI74
	odeelOwTlqHcP6NFaiixi5rZfpVaE6LMMhcLwXUXCwVgfCF2tQ771dFuZ9Ao6esBvkukOk
	mzybc1SMqRZLbgSAp95TLBWzPx1YPD8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E9FDFEC;
	Tue, 16 Dec 2025 06:58:11 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63C633F73B;
	Tue, 16 Dec 2025 06:58:16 -0800 (PST)
Message-ID: <9d4c6f30-1262-461c-9fb8-25f7c8f4ad0e@arm.com>
Date: Tue, 16 Dec 2025 14:58:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] selftests/mm: fix exit code in pagemap_ioctl
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Usama Anjum <Usama.Anjum@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-5-kevin.brodsky@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251216142633.2401447-5-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05AAB40005
X-Stat-Signature: 1e7c9fnk19bgr1auumwo84ktyg5q95d1
X-Rspam-User: 
X-HE-Tag: 1765897098-199877
X-HE-Meta: U2FsdGVkX18+BQ76PX22JwCJG+XlYaWghZdd+IQ9oEk4+81pHspzr58RsEkj+o3nLKMcZspUqI14vOJfCYh20hBp+LP1tbHrl4l4sQ+oABiz5kCVxT5+SMtPkmJmEj0/6SZ1cKZ5Kg9W7wBJleWlZqPZ1BpXqHGz2PuWj/fNGj1mbOmEcqoxGk35nBmIMmsU0dFXBl/x49O0KPAp+IGAIk5kCgKHgICkbgLQMOuy6jSzfAd+l6MVwSznNit+aaS1iL5fj3XfSKK6KUtahk4JMecCPvKr9+sHCwdqDOEF8B+tPoMlkuLt9F8i6hPtV2RJzDW2egffX28BT2zinZmJc9jucR/8WzPb27SBRCYUCOZRJ1fsp+sCqY98CbgZp2zKbppB9ijYGwiPRU+BGYyFL+4cylxcFVZOOWw2q2thOW7UcyehVKkYDnksNoCbobr+qHrM/5IBk+HyVcdgZxmw9gBz/JurhgJAOM8G2JdPe+KRnBo8QoLu3ediO/1Ckayq1xh6IYD2DpMD6PsBzZid6mBijRwW3W24Vf2Uq+vjJ4gMP0nGXi03iMhxhkuz1FzcLqd6m9Va36xowFP8YNoRmGrEb1BBV1t0EPhq0PlJHoZWFH9ekHeT6sPToFhH2wruh2cMUfPcta4HPruBMCt+3I0ZikSdkozLd3lBKfXPQRiqCh+csaSdCpsS/a9ZJsTK3O68wYoHRtWMraCUYwoGdxnFyEgRbJtOBBMGCgfVrkca///80j0kMn+cxhacfkHuSBytwZjd3/FxPBqtHQvl/m/emUFjsZ08fKtWOQe9/DB00wjElKwiXd1Uu/nC1tcw6RTdk6Kx9T4tD+CKP2299wxQqC00iL/KtvQkkzLVeTgQ74HoEbDo5v+/Vlcss553fbY7FcFh5B+abB9lfsZIVPQK7PZwP8ZI33S+GWIY8O4GThA+MHmmG3SpAnWDIW/nUlAxSRi91fNET+2GgXk
 /m+pOlTB
 q/rG9gjcAMa8oSdVuFUZ3CmMtH1HJw4jTz7Qvk3pqvn505TStQl0aZG/efNxNkZ9UM2gO9FpgHA6jtzyuBsmfHhpqeJ37DT5OU4GUC3yuts41rwv4bpiZNHBkg3g+r+91Tqk8K9qy3f8i8gGFT7/SzVy5HIUwZDWD9ZKviOuaVwX9kkbmr1bdKGmzwYcmOVvYWE1CIyG7y8F//FDOdcN41azdTa6Zy2D+Y+9si/LrWhA3amj3JVbsgFk5Zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/12/2025 14:26, Kevin Brodsky wrote:
> pagemap_ioctl always reports success, whether the tests succeeded or
> not. Call ksft_finished() to report the right status.
> 
> While at it also fix the exit code in unexpected situations:
> 
> - Report SKIP if userfaultfd isn't available (in line with other
>   tests)
> 
> - Report FAIL if we failed to open /proc/self/pagemap (returning
>   -EINVAL from main() is meaningless)
> 
> Cc: Usama Anjum <Usama.Anjum@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 67a7a3705604..aeedb96dfffb 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -1553,7 +1553,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  	ksft_print_header();
>  
>  	if (init_uffd())
> -		ksft_exit_pass();
> +		ksft_exit_skip("Failed to initialize userfaultfd\n");
>  
>  	ksft_set_plan(117);
>  
> @@ -1562,7 +1562,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  
>  	pagemap_fd = open(PAGEMAP, O_RDONLY);
>  	if (pagemap_fd < 0)
> -		return -EINVAL;
> +		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
>  
>  	/* 1. Sanity testing */
>  	sanity_tests_sd();
> @@ -1734,5 +1734,5 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  	zeropfn_tests();
>  
>  	close(pagemap_fd);
> -	ksft_exit_pass();
> +	ksft_finished();
>  }


