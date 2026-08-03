Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490C1C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671AC6B00A0; Mon,  3 Aug 2026 09:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A066B00A1; Mon,  3 Aug 2026 09:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587536B00A2; Mon,  3 Aug 2026 09:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2935A6B00A0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:47:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0DC64064C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:20 +0000 (UTC)
X-FDA: 85059361800.02.3218447
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 572A218000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ObFPZRaJ;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785747619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDyGVpKRvsgUiTdt9dQoahAliqSSSEzbSkLgMiPvdig=;
	b=241Crxh9ZBeKFY0fwxsZX2XhcI+12yhFdVLtIP1m7L4oALZBpr2ChBezU0E63SJl71xhiG
	PUnLcWIhogmLTE0adUpZNiwflncX28+VubPdMTFzNq2IgJm7zLKwPLRNsG3bK6eOK3DNbj
	zyGWU9KQoEXxDTaWZ99I5OPSnOUjPF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785747619;
	b=dhLJVMOT6Uk8GQmJHEtDWZYeRMINiiBi/gMAybIgYnrc9u0G1wGqKbhRxbXI0FydYLejkr
	Gs60L+FuQMjSzcd8eD483HndR+BUqrvgiSJjKi2vZYmlN267IVh1CAc7xaK+tHb402mxsJ
	UueiyOZqKHfRaYebQjDsNvaEt2ej7QI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ObFPZRaJ;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D420660A7F;
	Mon,  3 Aug 2026 09:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A021F00A3D;
	Mon,  3 Aug 2026 09:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785747618;
	bh=CDyGVpKRvsgUiTdt9dQoahAliqSSSEzbSkLgMiPvdig=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ObFPZRaJ8W4laigLCeQcJidIzvhokFrB0G2z7yN0xI07olHXlzOdDKdjWDIFOEbRV
	 BPQZeEBlH+c4s2v4nmga/ia0CuLoINblpoPM+/2Ceumeg5RNSg30tYm4CXrLrEd2/H
	 KjWrrXVoiKWYjbfd/9Dxj2n+03QmKunGk+jeNY/G7gx7UlKh43bQWi4pSJb8GNQOe7
	 UDFQrHmJYBlRTOCD9JyYcCJReR4hSW0qSqEFMRfRZ7PPsdsZdyXcssH8h/6ihx9xfh
	 FkJEYolppxEmm64FbrnnDQCXiPuPPFQkDddlU6aJ3UywnLRkKEo0o2r8XvGdSMN4LM
	 2x9uCp9+yu1Gw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 1/6] selftests/mm: make file helpers return errors
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260730140825.238130-2-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
 <20260730140825.238130-2-sarthak.sharma@arm.com>
Date: Mon, 03 Aug 2026 12:00:01 +0300
Message-Id: <178574760161.1561566.9774044559691998578.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: ysoxyfrq1j1yfs1g1kj3ghimmsa9tw7t
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 572A218000C
X-HE-Tag: 1785747619-760376
X-HE-Meta: U2FsdGVkX19za6//6wxhBfuBh6VGQndtfatzMl+MhWfWvMH0OgqKEJPdelvZCClXXTwnmGU7fwX8F+RlRiMHEmDxxWBAKoekF4dxYqwxI5OFFPMhQkJQrs1gYLhSZ3o/gpcD5KpPb/MXO+SV8drySJwxfeD1ZBgICf8dspf1p91FoKNnVNc+K9mIHQADzjAWGyPREGfUGkcZkxZF2SMZPAz5MPVWYaxspCU00Uq8FZ1TpqcM6HEGi4EoTxWbG1ZXKsqSDC25eo/qUkGWZSN6F6CV8DgtHtTADiFOJ2BJyt7aVQ96LAuv+GT6HWaA2eecoX9fcs0vQ9X6x2f+k1ptUd8uTd1SXt8gHhanRxH1Ft043Jbljkk3Dy6vtZ5mrBMpOREd9bXAYx3GnjViek6ZKrZKr5R//AmxIlDzifMaP6BleQErYF10oipyefI5NQy6RAAtomp5VJHjRdMEnh+3ABdCc9hTDSfqLCLNC18Kmy1XeL93X4f5jZM3u/dzqkfIjOIPnCiPxerMuUyyxEJyg/wvcYJmdaUcBcBdImyRXtVFeYMoEtKsODWbTq7DbsoTomf63RWUs2YM4EIrmcyoF7moUf6m5pCGuL+PfDDXomKSTl9Pqo0Au3KRPULgaNSzW0UiN1aYVBqDr+TZEQfPmpH3bp2odBSbS+vJtGEXzvzM7y5dZlSMerD7VrFuHXnf0+N2V3MrdKrAemM7JkYbQBYy1e48oNjCQEYm9Ay19kCIXfofg8+fO9tBAnRxgUqvqY8fLYWx68XT9oCAuH4eLogSlfSr9PK6hmDu0I0BXtmBVY450oFDuOQnxJZbwnEafV1LevNgVnCBcaYChUJSSPJhfkKDRDvCoJT3ygkxDFlAS7eqSKMoS2al8BeYwXQpN5wWhbia0oh6IhlG+2R/747Z3yj/eL+YnM6Ejf2TNCqBRDcowFYq+/umzl2mbQ50nrd1jwDxn0ovVc0FJpe
 jDF6VLv2
 EwY/KWR7hgBpT515cnMDO7sNdZPN/DzxMQgebrba1/iqwmHKqJzY2yhWQjyK0x1AOH+uiflf4bjny5jyMwquubc56GnRuWP194cLiRc6Dmu5WcwbQdHDDWcjlbAzaAFV3AxGaSIqgxhBG1DBhAoanr7H0XJgxs1BSPLUWdN0g5bnLUkrWZJPUmV1gRe+I+dI2JxF7MJXJHmyPS+Tdi70MN4KfJMJHuBz1fT2VeVhkdjolxYH4tw6thMiuSf8r3Zzse9ZQElQtb/bd+XPsgZf/xlg9qTUIUlBdYGHkG/DyYL1fHbw9u56YRJvWF48hSiaP8n5M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Change read_file(), write_file(), read_num() and write_num() in vm_util.c
> to report failures to callers instead of exiting from the helper.
> 
> Make read_file() return a negative errno on failure instead of 0, so
> callers can distinguish a successful read from an I/O error. Also make
> read_num() reject negative and malformed values.
> 
> Update callers to print diagnostics and fail wherever required. This
> patch prepares the helpers to be moved to tools/lib/mm without
> kselftest dependency.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 2eab2110ac6a..db0db8a3df7c 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -8,6 +8,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <errno.h>
>  
>  #include "vm_util.h"
>  #include "hugepage_settings.h"
> @@ -61,8 +62,10 @@ int thp_read_string(const char *name, const char * const strings[])
>  		exit(EXIT_FAILURE);
>  	}
>  
> -	if (!read_file(path, buf, sizeof(buf))) {
> -		perror(path);
> +	ret = read_file(path, buf, sizeof(buf));
> +	if (ret < 0) {
> +		errno = -ret;
> +		ksft_perror(path);

I'm not a fan of changing errno, why can't we use

	ksft_print_msg("%s: %s\n", path, strerror(ret));

>  		exit(EXIT_FAILURE);
>  	}
>  
> @@ -700,91 +700,139 @@ int unpoison_memory(unsigned long pfn)
>  
>  int read_file(const char *path, char *buf, size_t buflen)
>  {
> -	int fd;
> +	int fd, err;
>  	ssize_t numread;
>  
>  	fd = open(path, O_RDONLY);
>  	if (fd == -1)
> -		return 0;
> +		return -errno;
>  
>  	numread = read(fd, buf, buflen - 1);
>  	if (numread < 1) {
> +		err = numread ? errno : ENODATA;
>  		close(fd);
> -		return 0;
> +		return -err;
>  	}
>  
>  	buf[numread] = '\0';
>  	close(fd);
>  
> -	return (unsigned int) numread;
> +	return (int)numread;

Do we really care about how many bytes we read?
Can't we return 0 for success and -error code for failure?

Will also make checks for read_file() return value neater.

>  }
>  
> -unsigned long read_num(const char *path)
> +int read_num(const char *path, unsigned long *num)
>  {
> +	unsigned long val;
> +	int ret;
>  	char buf[21];
> +	char *end;
>  
> -	if (read_file(path, buf, sizeof(buf)) < 0)
> -		ksft_exit_fail_perror("read_file()");
> +	if (!num)
> +		return -EINVAL;
>  
> -	return strtoul(buf, NULL, 10);
> +	ret = read_file(path, buf, sizeof(buf));
> +	if (ret < 0)
> +		return ret;
> +
> +	errno = 0;
> +	val = strtoul(buf, &end, 10);
> +	if (errno)
> +		return -errno;
> +
> +	if (end == buf || buf[0] == '-')
> +		return -EINVAL;

We can check the sign right after read_file() and skip errno dance
around strtoul().

-- 
Sincerely yours,
Mike.


