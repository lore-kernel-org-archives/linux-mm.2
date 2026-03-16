Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F4D6EFCBB3
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0DD26B0142; Mon, 16 Mar 2026 02:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5CC6B0143; Mon, 16 Mar 2026 02:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15AC6B0144; Mon, 16 Mar 2026 02:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF0D16B0142
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:35:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EB9D1D5B2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:35:24 +0000 (UTC)
X-FDA: 84550964568.02.CCFCB14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A5FE420002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:35:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCPUFoSJ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ew+oru8MrStDER7faQ9Xi037BXQW5IYv3Xe+SlylAxo=;
	b=nyjWFhgfDdRgL5Ecw9iOMWw7Wsgt2PqR9xShbUTtRlE/JBDWhiHSeb5JFEaZ+3Na90MHKc
	+IR895tFz+tG0MPUOVMdvhdoq6dn7vuPTaQK4fRGSlgrvdypmlRBEhl76F9eI7laOPQwuZ
	2YuiU+mWKMGaj30PB0AoJ+D88/czHB0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCPUFoSJ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642922; a=rsa-sha256;
	cv=none;
	b=cdrd4fgVlmnFyD5v87y1osW4karshwLUZezkk4xbwAPGZUR7DEBweF4Sx3FKbBH9Hzriyq
	lCC1MK4kkUnPJZAhcfs6LxbU3N8gYxPy7kTFhXhoBZLhwweY4/F/GmUE/nizEfojx2IRpO
	5TNqW6l2vJ/t9ygiOzdA/CcL4f1pw3M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1891408C5;
	Mon, 16 Mar 2026 06:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FB5C19421;
	Mon, 16 Mar 2026 06:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773642921;
	bh=Y5aXaVuGBaiXS/GWUEXMWG35peqnApOugc3+Qo06CeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FCPUFoSJslWQgmhBOPtiAsslsXjQEv46CWWZzGE0Loz9tRvsYQ16trMBW1AnW/xGZ
	 80IVCeP/f6bx6ZK13+nzfnlPjxM6KlRagI+nkKnuojxe1t3r6ssTYHdElotg//l2Pg
	 Xz3VJYZu7pDO9areQQSsbn7+NzotQ4lwyygaJpG/VkP8uYMckiELS2nlPSD/Ih2Wgl
	 2VPZm8DcUEXJQ2ndAEPjkpDH7F06T6M2QyhPHwaSd17hCvogZKcmK0IRzvS8q+qBFc
	 8AhQi4/VE9iyCvzXDVbzJrfyEabcbrnZiBo7BBAEUbH0oPQxiPjczy8ujT4fa0kdfd
	 sY45z7NSKxSEw==
Date: Mon, 16 Mar 2026 08:35:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v2 3/5] selftests/mm: move write_file helper to vm_util
Message-ID: <abekn9aBMw1e1Rw1@kernel.org>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-4-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316044335.1390608-4-chuhu@redhat.com>
X-Stat-Signature: d148958i94mcwqzaajp71qic5i8gy6ew
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A5FE420002
X-HE-Tag: 1773642922-873224
X-HE-Meta: U2FsdGVkX18Xzfs85WR2qgqSgcAtpkfLrIb1J8fqvcumrKG8gbSRy4oC7Rk+1JCCyKLTDCMClGbM9rHEveTADSXJchhxNjeIiAQ2W9JhQ+zKQ1csPtUwppIwAWrvPO8u3Pxn8t6J1uIEMXh6uAts+rdguKsHLMWU3Ivq7E1eFcKRWU5NcQvk1vjon6RFNDLvECOmDAsedb8VTVgsaqQSS1W6IrW1NZW9dd3wsqlYDT3UHrGOLBBZVVbNFkjIYLLOW9qdt+M8OU3H3fzHBvZDm+byYYeDCVp69wK28g6a3qzOdlXTZD1DvtDztgi2tWdiBo0MjtVlk5tSB9BHkFit0Khf0e47ZR3Ge3uV4kjh1/UF0qxFRR5pif20uRkAZoJ/7FyGZXrn0CBHntiKB/Vy45h05xyjYGLSIjVUPPloi0uSrjRD4tBBivF2YlM/D9koiLjniw8mK8VTmh5prSL/n09CM51mCyqk1JqQdaAasjgKB66/rG5P/wDsJ7gVSmbh4+vBcvD00lEDWwQ1Ahhqr8Kqt1axp+yOEvh7Qht/jQAFmYEsW7Pj0/VNf1hd5D0SbzvyFQlHX/CKAhwM8UpP34Bk++uvQ5DuMN8hRiw/q6XhT3WfT1/Mhb1T/9BkoDpRGD7WDNMQukZ8/ruTJrH8hMRwxUwGLLy8HeDsUI5EgqCYLp33s7uiIVTS6VliLZWxa1DmFDQaJgb6hE9dm7QXwMtaACH0gcU4cNbHJvmlZPzHdCYw11p5tcJJhXSMtSMKa7MPclOx7lL53E8tRRwttkvEoHp6aVwCI3bJ9tBVlpPS+JR6ObXT3ZgXrD/zFch/F6yb5HvMeIKnxOhxQxbFyx0bSGFf/C/1dobyigx72mHMBL54B0tQ2miHAlAKOugr84m8v5ve6kUgG1EQugolsu3wBVQWoOCPcVw0HyL7JQXxmArUIyrYme55g5kqx0nV9ger13MIeEe9UzqdQ2T
 Qnt37QGu
 MyPUbBVeY483eJzdsUbHH6XYg0BFpik5wyu//1JJjyO1rynfzmk2+YZgJ4mc1eOw4Q/1MDVRbCxsoy25I3T4hLANwPz2BJ2jbFn4pKTZJ3/Ci14wRj2UntY8pPpJd84rU4gsP5FqfkLeftZ9aJ1b6gzVF0UdcfwWZ7Duk09hV8Q2sR4UU4WIYCuT6OvXO2lfcIEIH7YnXzfp7SvANDQaW1//WyfQXacgtMl5PvQNoo7UOn+z9KrTN1CxwrSyER0k8teKEsYlr0SDu+RTaF51pGw2cX+9T4KcyQvCOYS88Em874qzsH6JGpchkbcP5nOdYOIg9QcGEdgmh3MUcunjLvi9QwPkEOqSPfgZ7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:43:33PM +0800, Chunyu Hu wrote:
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
> So here just leave one version of write_file, and move it into the vm_util.
> This make it easy to maitain and user could just include one vm_util.h when
> then don't need thp setting helpers. Keep the prototype of returning the
> written bytes num.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
> Changes in v2:
>   new patch from v2
> ---
>  .../selftests/mm/split_huge_page_test.c       | 15 ------------
>  tools/testing/selftests/mm/thp_settings.c     | 24 +------------------
>  tools/testing/selftests/mm/thp_settings.h     |  1 -
>  tools/testing/selftests/mm/vm_util.c          | 16 +++++++++++++
>  tools/testing/selftests/mm/vm_util.h          |  2 ++
>  5 files changed, 19 insertions(+), 39 deletions(-)
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
> index 574bd0f8ae48..02de28ecf31a 100644
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
> index a6d4ff7dfdc0..b4b3b48f8dc9 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -764,3 +764,19 @@ int unpoison_memory(unsigned long pfn)
>  
>  	return ret > 0 ? 0 : -errno;
>  }
> +
> +unsigned int write_file(const char *path, const char *buf, size_t buflen)
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
> +	return (unsigned int) numwritten;

If we exit on any failure, the function can be void just like in
split_huge_page_test.c. This will also simplify write_num() and read_num()
in thp_settigns.c

> +}
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index e9c4e24769c1..22c8805e0d7a 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -166,3 +166,5 @@ int unpoison_memory(unsigned long pfn);
>  
>  #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
>  #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
> +
> +unsigned int write_file(const char *path, const char *buf, size_t buflen);
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

