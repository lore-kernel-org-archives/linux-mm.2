Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96FA11075270
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DC06B0557; Thu, 19 Mar 2026 13:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7B66B0559; Thu, 19 Mar 2026 13:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98316B055B; Thu, 19 Mar 2026 13:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5B36B0557
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:20:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 227BD1406B0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:20:34 +0000 (UTC)
X-FDA: 84563476788.15.6E5E9F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E04880003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:20:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRpy9Hsp;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773940832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zagDourUJZsnvT0mEY8+RoZSWfkMje4Vgxrl4MKPo9w=;
	b=JYnf3dTvu3T9hB53GkgSXAC+7fFCBrmQ4V/8EryJAtsNMGBh/kMQ+e86zBRKUsDUe1nf8e
	CHgkFneclmtRBvFBMYSnGv0e8TngHNYeEDOXIVkdKaphdYcM+ENQURq7ZBwqipefZJm/mE
	lxktCkSogEzfuQygMyLC3MP/vZ4h7Fk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRpy9Hsp;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773940832; a=rsa-sha256;
	cv=none;
	b=8SeGLE7V0gPDGH1p/thivfqQ8VsVlcXqSDE9wf2LGNyTEZzmxfQ+u0jLJwoWAGn7o0qaAb
	r/d/NjpESrF2Vq52kqD0LiB5PXJ0IBiFeKMrHWVxeLORRdcAz0KcErY6rknbEPvv1ueoJR
	PtdO+4V+w+9dVg6PYYCltLOpsWZC3Ng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 141E760053;
	Thu, 19 Mar 2026 17:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276EEC19424;
	Thu, 19 Mar 2026 17:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940831;
	bh=kgD69+muWITBcTGV+KnbYP0pvQSkkY00OjAstUepKTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QRpy9HspVOZRZmYSyOUluLhCW++p7IYk/JfgMXF8/I6KwQNt0a7Il/pRFHYqeGTxA
	 p8hRxBLbUEGCLblYuhsPZd20WTgVIKXNT5IP2NvK9nU+43GNMVqaebUPI9XqtHX8/p
	 t+tOPiuAR720tqf3kAgj6SsQy551k5QBq1RwYvSjV7GLPQ0QYFHNItmVo+fyjMd/Ru
	 ns7J8tk6IKfWw+UmRemKyORFNPfLe4atGyXEJtZA7F3P21Uqz8n7eVNEQoeoM+8HwL
	 C6te3esHkTUSuwxl/hDH+GQAQ8Cj63BgZeVryqmZWz1iThwHipQIuFNYCd7SPZlzJy
	 Da5HQQOmzC1wA==
Date: Thu, 19 Mar 2026 19:20:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v4 3/5] selftests/mm: move write_file helper to vm_util
Message-ID: <abwwVUnk1QlYJ0zD@kernel.org>
References: <20260319160656.1480279-1-chuhu@redhat.com>
 <20260319160656.1480279-4-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319160656.1480279-4-chuhu@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E04880003
X-Stat-Signature: y66bcjeazsgdirc5u79e343kg51946po
X-Rspam-User: 
X-HE-Tag: 1773940832-962410
X-HE-Meta: U2FsdGVkX18KYCQesvm2mTTxfKe7efbcARMZdGAro3PIQHBkZ+VcE21C8XAGiWpIFnqLef5OYssbhrsghKLa2ZnztoyL6EMryBVU8ZZMjleJv8AhrNLnwpowIdzlSklFx9Q7aXzVLDSCspXSW6At9zR+7BjwRtDr74NYKE+kE5ykr8+GbAbzPbKR2cMBhe/OhTD2deh4qHC6BKjCHNLloo8HGtXZkQbkyPSHS3YFEA3G7+QQTfyHISp75ubkEpwlHhx6Uvre9+8FpcIgsYCodjFOzed4bifLQ02kRkdG+bOV8Q7pychZAM4kNbEyxc/HkGZjI5CDQviUuJW5vE7WfU656pi1AOjcEV1nOVzJ5NJ7/8h6GOPgI+O/Zzt+ac1RiAvPTs7F5mbODZ8WZ5s4gWfOPKshMnHyqXCbToh03mTE3/IbtlwKjC2lCQKFZJwB7K3d3GfgqleFNAC6HHIlXKok8CENAX5Ai2ylQS6IL1t+/MJTKmaBwm8YQyYjKaM8Gun/hXXupggh8wovPrwpzux3V35dS2IF64gpZQIo2bG27zIhaeacST3Ffc7E4523bwdua9GIEkoEF7WSyLqay73sG227dPjy958Wpvk2X6trJBSKZh1J2UM2WQrQTK/iXAZB/hAchKVNohvVphH4H18oGRAR5u3s6SYEgyZZIXxgOQdBei9xQfQWOmigj3elDCJfSxRz7XYfH+dzI4+a+fU/3KVFHoLElyt/sqkRYyUdEfkHrvXpbVI5+MvzPz6MfbuNydwqllM1PnAq0Uh4+RF7wkgLk1L8jEG/ZuT/Kqc0Pv5MyYpJd9/Q5x1kt7i+77mLRjURCrkQER6CBNatbATawfVfgy+a3DWotHeFXecaepJNJEsccfGf0oxrsWCouEUiROQClsdTpwzHmSDiYZUOVDX2XLIyx+WfaupQdWrhDluEYLnU62bzpJLuwajhXuRzA4nPDzIWdJKTPmj
 2/j0sYir
 HrYj111CEa/1srNIxG6xfXOGU9NYUbp3GpzZqaB3eT8nxDk7615nFjzHn5BgHqwyQcVf4Q8V6wxkw6Rhkzl3YB4m8QX7xYjwNC0xFYrdJ5mcZRZEftZuuU81l9DRRD0gg80ELsonqioc199CvI+/HpHmc6sxCTSRo6Lit9Y7N1fQGovpeY3dw+7ZqZ/yuJlYFEdsV/ttPDG7lfVwA5FXHKCHXt2ENiQKgIw/5BofZa7RTC4yq7tLTjRj2NMlXpxEl5Ex8NT/R7+3qUwzo+p1Ed7zsnY3Idfar9yIZur1qFu+itvPXiVBf5PPuSnVWOLp+hF6K+pAPozWG0ACBFpOgzh5x5h7CTQSdJk9m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 12:06:54AM +0800, Chunyu Hu wrote:
> thp_settings provides write_file() helper for safely writing to a file and
> exit when write failure happens. It's a very low level helper and many sub
> tests need such a helper, not only thp tests.
> 
> split_huge_page_test also defines a write_file locally. The two have minior
> differences in return type and used exit api. And there would be conflicts
> if split_huge_page_test wanted to include thp_settings.h because of
> different prototype, making it less convenient.
> 
> It's possisble to merge the two, although some tests don't use the
> kselftest infrastrucutre for testing. It would also work when using the
> ksft_exit_msg() to exit in my test, as the counters are all zero. Output
> will be like:
> 
>   TAP version 13
>   1..62
>   Bail out! /proc/sys/vm/drop_caches1 open failed: No such file or directory
>   # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> So here we just keep the version in split_huge_page_test, and move it into
> the vm_util. This makes it easy to maitain and user could just include one
> vm_util.h when they don't need thp setting helpers. Keep the prototype of
> void return as the function will exit on any error, return value is not
> necessary, and will simply the callers like write_num() and write_string().
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes in v3:
>   - make the write_file void return
> Changes in v2:
>   new patch from v2
> ---
>  .../selftests/mm/split_huge_page_test.c       | 15 --------
>  tools/testing/selftests/mm/thp_settings.c     | 35 ++-----------------
>  tools/testing/selftests/mm/thp_settings.h     |  1 -
>  tools/testing/selftests/mm/vm_util.c          | 15 ++++++++
>  tools/testing/selftests/mm/vm_util.h          |  2 ++
>  5 files changed, 20 insertions(+), 48 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index e0167111bdd1..93f205327b84 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -255,21 +255,6 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
>  	return status;
>  }
>  
> -static void write_file(const char *path, const char *buf, size_t buflen)
> -{
> -	int fd;
> -	ssize_t numwritten;
> -
> -	fd = open(path, O_WRONLY);
> -	if (fd == -1)
> -		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> -
> -	numwritten = write(fd, buf, buflen - 1);
> -	close(fd);
> -	if (numwritten < 1)
> -		ksft_exit_fail_msg("Write failed\n");
> -}
> -
>  static void write_debugfs(const char *fmt, ...)
>  {
>  	char input[INPUT_MAX];
> diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
> index 574bd0f8ae48..e748ebfb3d4e 100644
> --- a/tools/testing/selftests/mm/thp_settings.c
> +++ b/tools/testing/selftests/mm/thp_settings.c
> @@ -6,6 +6,7 @@
>  #include <string.h>
>  #include <unistd.h>
>  
> +#include "vm_util.h"
>  #include "thp_settings.h"
>  
>  #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
> @@ -64,29 +65,6 @@ int read_file(const char *path, char *buf, size_t buflen)
>  	return (unsigned int) numread;
>  }
>  
> -int write_file(const char *path, const char *buf, size_t buflen)
> -{
> -	int fd;
> -	ssize_t numwritten;
> -
> -	fd = open(path, O_WRONLY);
> -	if (fd == -1) {
> -		printf("open(%s)\n", path);
> -		exit(EXIT_FAILURE);
> -		return 0;
> -	}
> -
> -	numwritten = write(fd, buf, buflen - 1);
> -	close(fd);
> -	if (numwritten < 1) {
> -		printf("write(%s)\n", buf);
> -		exit(EXIT_FAILURE);
> -		return 0;
> -	}
> -
> -	return (unsigned int) numwritten;
> -}
> -
>  unsigned long read_num(const char *path)
>  {
>  	char buf[21];
> @@ -104,10 +82,7 @@ void write_num(const char *path, unsigned long num)
>  	char buf[21];
>  
>  	sprintf(buf, "%ld", num);
> -	if (!write_file(path, buf, strlen(buf) + 1)) {
> -		perror(path);
> -		exit(EXIT_FAILURE);
> -	}
> +	write_file(path, buf, strlen(buf) + 1);
>  }
>  
>  int thp_read_string(const char *name, const char * const strings[])
> @@ -165,11 +140,7 @@ void thp_write_string(const char *name, const char *val)
>  		printf("%s: Pathname is too long\n", __func__);
>  		exit(EXIT_FAILURE);
>  	}
> -
> -	if (!write_file(path, val, strlen(val) + 1)) {
> -		perror(path);
> -		exit(EXIT_FAILURE);
> -	}
> +	write_file(path, val, strlen(val) + 1);
>  }
>  
>  unsigned long thp_read_num(const char *name)
> diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/thp_settings.h
> index 76eeb712e5f1..7748a9009191 100644
> --- a/tools/testing/selftests/mm/thp_settings.h
> +++ b/tools/testing/selftests/mm/thp_settings.h
> @@ -63,7 +63,6 @@ struct thp_settings {
>  };
>  
>  int read_file(const char *path, char *buf, size_t buflen);
> -int write_file(const char *path, const char *buf, size_t buflen);
>  unsigned long read_num(const char *path);
>  void write_num(const char *path, unsigned long num);
>  
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index a6d4ff7dfdc0..ad96d19d1b85 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -764,3 +764,18 @@ int unpoison_memory(unsigned long pfn)
>  
>  	return ret > 0 ? 0 : -errno;
>  }
> +
> +void write_file(const char *path, const char *buf, size_t buflen)
> +{
> +	int fd;
> +	ssize_t numwritten;
> +
> +	fd = open(path, O_WRONLY);
> +	if (fd == -1)
> +		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> +
> +	numwritten = write(fd, buf, buflen - 1);
> +	close(fd);
> +	if (numwritten < 1)
> +		ksft_exit_fail_msg("Write failed\n");
> +}
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index e9c4e24769c1..1a07305ceff4 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -166,3 +166,5 @@ int unpoison_memory(unsigned long pfn);
>  
>  #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
>  #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
> +
> +void write_file(const char *path, const char *buf, size_t buflen);
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

