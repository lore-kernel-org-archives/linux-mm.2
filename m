Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE71F4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531D56B008A; Mon, 23 Mar 2026 11:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2D56B008C; Mon, 23 Mar 2026 11:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41FF86B0092; Mon, 23 Mar 2026 11:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30E1D6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:49:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAF801A0C07
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:49:07 +0000 (UTC)
X-FDA: 84577761534.10.AAFCEC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1D9CF20007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:49:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gyb9cPTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774280946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VU67ppKIlHNY+vC2jhTt+1jz5LuPx2WFBBRyAfaFWcQ=;
	b=SMPm1+fVct86HpxmMDwUVWyDZ5i8O4OrULOOIN3Tl5rU8QpNHtmKBuoCGjt1FQqvIAX3rP
	lOL/MqTsl1KMYpjSMIX7o9gRuDxMaxwI/yleCNfp6P5u3JKz4xuhNRnrj9Pii2f/EBtsqj
	0x5qrpd9TmGPFEDUYg36+pu74hkSvcE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774280946; a=rsa-sha256;
	cv=none;
	b=yOE/3hChJBVnK1ZdCT21+vMZkCH+WOXwhjlQgK5oOnI+XOfvlaXiH5dzTMXACRG0bQ045a
	FLKeog1L/ybdTBECcdC4jy7jpwqTn6aPMYpBfce1IEcVXguZuLErEEyXPw4HTyLDO9JeZF
	npHI1oKXR7UtNtwM6sXaY/JQTEV88KU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gyb9cPTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F167442D1;
	Mon, 23 Mar 2026 15:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CC2C4CEF7;
	Mon, 23 Mar 2026 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774280945;
	bh=MMLWnE4+owXgbpiWUI1UdF31XC9AUzjDGtFrfk10ct4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gyb9cPTF4uDc6h/CEIQTbhZL2XfjiK64YwEU9X2eh9SgOoDYTBlUZJNv+QfpGHd5w
	 3GipXY2MMeqNMnRrX6uI/uOic1dokXzAvVQuUkNZ4mgiMiujxNBo+OZlUjNbFUbfRv
	 G+eUzltAzGsYCa/hpZ4PW4nrQf1QBH93s0BEK3Jt/pENYR8WC/3O3AEx2iScta1mAD
	 jtbf2laiX5ZQOsn31A/97djG05ERFZo1X4bNGBq4cULXYvyBVzakO6UBh7LjF0MkY7
	 MwTWbOaRQB7DoJcH4wqOL3K/m32AaeHOA8xWIIEhS92OE162vFEPv2ydpe9WfdU+Ws
	 TUA+TJH+KSoiA==
Date: Mon, 23 Mar 2026 15:48:58 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev
Subject: Re: [PATCH v5 3/6] selftests/mm: move write_file helper to vm_util
Message-ID: <b992bd2d-f811-407e-835f-30d9c9d707ad@lucifer.local>
References: <20260323151753.2576137-1-chuhu@redhat.com>
 <20260323151753.2576137-4-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323151753.2576137-4-chuhu@redhat.com>
X-Rspamd-Queue-Id: 1D9CF20007
X-Stat-Signature: tdgk3rnq7jrmpnb8yzsufk1qugfge8gu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774280945-454284
X-HE-Meta: U2FsdGVkX19WGsYXp14eRVh7CCU/0caPIDmszMPNVvplACU2RLNqaXiOHYfqLJOoigOLuO3RUjnLUEWO9mqHsL/1oLrySMxPLw91+fM0pj2Ka/NOG5ZMvx+0fe0Lf8iQOp7s1nwIQu9fMHpkKK0ZnnLS4dWf659PE1NF1y2iMCYe95RMEVHXpcoNZDbyuQke0Fg1USfwJRTZyWBmAP/v03u0aQlBbYFvBlfrxFm99hp74f15yJlqdLnI63TsF1oE+nUbFG/T8s26vLJSGhwPTdbJzy3kOTEQNtAiix4DqzR6EiwNT2c3BMGBg1jHefa/JTEi0cbP5xEPXVGPbV858TrVCy0cBAyhGgFCU8F4hLSpXpIdH3XUk56iGWGjxStqBtZl8ZDKMKhtBrCZgu4mo3biCDlA+uLjHUklpTtG1ajAln8XpvbIuGLsDRJ+TJvKnCXd4s8BViaXfVZgNXCrmoYPDpvh9npNbfhVz6NxtMOpbFhSi6bSLaF4EZ+j8WGNYWum+thwQymOmTXO/qFWuPqTuYpJj79swrXQ7vqvfxM07LE8uzAl8Ow5s57ecb5BShJzBe2HQc5KE8J4W/8N++ladqzZaKUDtbyG4tmWj7ctmgahR0jiOISUlm6OHEMZ9j6WkDbmIBy4OCyoMvU258SECKK9016uDZl29uW8j+yP/hhdyT+DTgm/egSONLJ59nPrLYGuMtI52HTzi+qCzyx4J/rkDvrDu4VO+h6VVnZu6olwEJH4mfogvD3n/zI4EDsDJZzBjJa0zFNDj70NeDLTGZHWDSqxJETQoK+WNna+sRkyu4cw+/uMu6gpXCcYWVlsdZq1sNxXysxUfb6PUJBoLsgFbD9Us3Y8rR0tb78x19sG4Sul6UGesPvjU4Q5qxl5xr3Vs1ASv+aB1BtUsJxerF+PhRDPif+IHyegSzumKDKtCvquUJymnWrCofr+8x09EPtp3wBSTv6iewG
 ZftWCt3/
 kMFFJyxma4Ef22kqxWLbUiHLsuJ2Zio33w7iExG0r5w8m55TsA2iBZq75vQChSi5CaTTjM200CrlJ6Ekn4JdBJuLHqt6m5JAjdgoAZHLDOsKvqvBlGstljButDnKBFJ6r2WohchCfp4aYYVucmbViE8AfnHlu+fh4XJjfdHp0ooGxqUZLKfBQvo9mU4Ttw73AoDmO/UzzIoxuGbP6e/r0s2rhWGlnbngoIlRj3+Ai8fFro3Sp0YNKuOBwfiRBkSOo0+VY+CV8lnctOUlB6UWXYkFz9tpBVXdFpppQnuEUf/dh79nhtIEsLpMQWI04da+xzyXcjz22DiiyKtvt0QkZ7Exo5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:17:50PM +0800, Chunyu Hu wrote:
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
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

I already reviewed this :) but easy to accidentally forget to propagate
tags. Anyway, as before:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Cheers, Lorenzo

> ---
> Changes in v5:
>   - updated acked-by and reviewed-by
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

