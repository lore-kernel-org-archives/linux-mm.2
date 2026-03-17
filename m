Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67349FD707A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3966B0088; Tue, 17 Mar 2026 07:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6D836B0089; Tue, 17 Mar 2026 07:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34EF6B008A; Tue, 17 Mar 2026 07:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9096B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:06:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 438AEBA599
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:06:35 +0000 (UTC)
X-FDA: 84555276750.20.4D5D4D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8682E40006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:06:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lmSJnFTl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773745593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QDRvWVMZ0ve6qv2iLjyX1aSvbOnJhjO6iiFMaGmoDc=;
	b=C6WTovZsEJFsHTeMmmQAp9swvkELw7j7XL3i6fppLoEIabziyUk/4hfbFWA6FhrmBZH5A1
	WOQjzwsI6upvchow+8AD95xFD4QF8vOYWeaZk4NXzbM8RjudeROka1w8kWsdwZe2hk37n/
	nqZ4kfEUwDF+RFcSIAEthjR4C4hjpik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773745593; a=rsa-sha256;
	cv=none;
	b=dWeeobpa3YyNR6uYAoR5rj4VYLGzL9AJAwA8a8pkycrHdorrVkwEiFqKchZrN8JMOG3FB7
	Qn7bmYzxcVsmMTPJyFdzkA3qREBX7WqJAFCyw2mUKlTCRI6YszJVIwad3N39kApLWdQUtY
	zqkMi1/LhYasypXoMRAsN8O0WJBO9sY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lmSJnFTl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85B9D435A2;
	Tue, 17 Mar 2026 11:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D040CC4CEF7;
	Tue, 17 Mar 2026 11:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745592;
	bh=GaokrveUokIisK/+DETje6sGOZkgS/z9TBu/9gRZN5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lmSJnFTl1AnFGTixEw9WHdnuFQttEx8Q2Rob8HTXIYf/i7JuOWyAbyV6LXh2t0xiT
	 +ZW5sIJbWn0M+FP219O+HWwffQUjS9/Vz08zvKASjMxI9Ft1xCxLhUm7EYM4MkX8dQ
	 x/IHthkjgClslIyDmThpxnPh6vO7m9cYRpfI3EhftGm8QkTDfZyTCO+/uQc253Gt8T
	 z3nHxO8mrDyfMlB69iTmZ42Xt7Wis9Ybtgq6nboLMwDTjx2QU4htpFDz3sQej0HTYx
	 DKAzNzvAK0rljeQvEj6TtvQtJsP4jCueK08si0P5IYoS/kUgdoPBDeozi6qVR+1hmC
	 Rvt36IXGOE3zg==
Date: Tue, 17 Mar 2026 11:06:25 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev
Subject: Re: [PATCH v3 3/5] selftests/mm: move write_file helper to vm_util
Message-ID: <c07844af-e508-4320-adb0-b05a5f026a82@lucifer.local>
References: <20260317094419.1429259-1-chuhu@redhat.com>
 <20260317094419.1429259-4-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317094419.1429259-4-chuhu@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8682E40006
X-Stat-Signature: 17ciowurqrjpdr566xpbge6zr3zsp56w
X-Rspam-User: 
X-HE-Tag: 1773745593-756950
X-HE-Meta: U2FsdGVkX1/H/QNMC74eyGgxLup0id4wXTUNEiy1RgO5NpuBn0qEVwXJmWo5IgEA8VKT6coMF/WwDojt6vM+PqDqK+ONmVgz4R4uSqkEcQQ35UGlgaAz8+zGb+dp2Y/4oJGT9g5CT5KPK2rVppdoM1Z29SqzQ3kXK0mRz+3wjSGN6UTbm0qAsuPu8H0z0wI0doOHCJf+LE4J1Xicz6hoEs8uCEvIifBXfFQBOfVaIf1Um77SV6P4AXCvTgFjvwxXXxLJmUa6jrCGmqbolnLaVFUFxWlsp3Ll+BfmDHhTlT12VbWyKg0Ohb0Az8nAub46KImNhofl813JXrjbby1fXyRyEKyMw7nZ2pR5OqVZwyCHxFGkvnm22A3uFBLMuMPncoo29DShWHdUbpMmxcH6mpbMVPmwHBnOOIgSMAP+yffF1fd+yfdY08s2Wot4bXazEbOTMRc5oK+XcPmuNBODlXhYoPjXIGcyhZTvmDVnM0V0EYj0H7X9kKHFK0x6FowwZ0e/QHQBwthnPKCPB0xyOLWZ4xwmFt1OjIJOams9FOoTwpcQvhUNfSMXF8vXzHNP8ii8xrDbjj+EOYo2fEYGxFEaCZQ051T7H5y/9PU8NX9e721GdBIp83MmY/dQFeqIep9kiHFC2sac95qJ1/U60qiAxRmowSfA6qLvliwwgPgaHbimWmS2BareKEmmrVUvKIxc1zp6NBcHBY1sVJKt6ezKuHqI2dVM4OEDqIOOuZ/JyRIZz0u6dq4gWYsLUDHiD00jkCnbejXK8D6G8gCYRjZ/+Ko6dm6XUu58FJYPyeXilPrKeXyh7C7E1D0vwHFkNuCBBcWJp1f+gs9tUMvJkGrdUooN95RbMZz/AUInJD5uhpEMKffhGUpUVDbySmyZm1Ip7ovu6ZDfHU3ORhVVQVHlOAsCTc+6eF+4/3QI+yoK28jwFqASpEDp78BgpVNOPdN16GJ1n2uC6jw+j1G
 ligOCIzA
 HBhDDX6fLddCMGWrhhfD1wRwFtz8f160UfsLJ4xbXT2nNZ0aD4ZlyNPHPsGg1dJSK/hh3mycAC5Bmr+tPjAE6G/lT5m7g/HVrLt9DHXSspuKMcYQCf7WnBqh3J1e+n3metCVHbTncUEqL4lY0PhewxUd1ZNrHatfYlLQ035rT4dpTkeKs6Qphdc1K6MqGoAPvVQYg5v1Anj8LVDdWP+dImNoFwqK9gxFhCi7hPqn0hNKB1nzNb4qnCtGM1m4TkwD5rIl0N2GN+lIgBielZzLandYp6XpuAc9I68Hd7smBXH9MltRETHkz2Sm85Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:44:17PM +0800, Chunyu Hu wrote:
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

LGTM and broadly a good idea, I do share David's concern about what if tests
that don't use the usual framework have an issue, but really that's an issue
with _those tests_ more so than this.

Anyway, nice cleanup so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

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

