Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7751F10BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71FE46B00A0; Fri, 27 Mar 2026 03:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7C46B00A1; Fri, 27 Mar 2026 03:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6351E6B00A3; Fri, 27 Mar 2026 03:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52D1B6B00A0
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:43:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AF161A1006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:43:24 +0000 (UTC)
X-FDA: 84591052728.20.4D663BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 71E56C000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:43:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DlLhAyHe;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774597402; a=rsa-sha256;
	cv=none;
	b=5pQ8hAh9rY8pludvCKuwBpq14MPh/eINz51VChHwUKIATHbi4rx+aywIBCN5MLfQSz4dWk
	V9FgEM9WEh8YaXV3JXP9EJDtwP8uvYywWucgOGlDGXZpl6dOxWKswosEoFB5uAa3P9HtUc
	hgb0quf/A9JVHjPhHq4GqPb6WJ8cPVY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aS0ZDBFT+km+i4D0iguUuVeIos6tCZucvfqCQWk3/uU=;
	b=4BydtUPQ2paY5R/pfbu9TqgIFOfqP9eBEeJ2UV5RxnBi3zgyJ7xyLCJkL7ukabMgNlHvTl
	qSRwVnhuAV42trVg7i1gYf10X3UC6kqIpRB8MDQ5t5rt/6VLNuRpbonlGV0EP9o6tR8Zfs
	jRKK0MVpqN+VbDGDZ8uAUHQJWU3LTCU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DlLhAyHe;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C69C56132F;
	Fri, 27 Mar 2026 07:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF11BC19423;
	Fri, 27 Mar 2026 07:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774597401;
	bh=eyiuDI5+j2IGudrMvn0lNdS+Db9kkRSzKAotrCUDXlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DlLhAyHeZhRIChrdemb+X2yZ7YUm9230Cu6LUCehyh9PNxz6ZwHOSrv2d/UXn+gIv
	 0yLlEnQX5FML37QQZwNZORmJQFoAkPTUfEccEiWjzPZewFYGf+TeyDFxR0NVM3J4ZK
	 bDbFc2F2n74L1yzTkMCcL766zNGRfvq6Vu2LMca3gY+bvdMfPVC7OlIaDiCN0JEDrC
	 4GHMfq+bvPDER8AX1qL280a2yKuQiWH7TR1dWykAHLhkyRjtTTPZNwaCkR+W1ZN4L/
	 QxPqLA6ucd7xpdsRSvHnv9BlIXuzqgLIYrPm8klZcUBEjrvjHYD/cNFvKZv6s2GoHb
	 d5xzoV37OhUpg==
Date: Fri, 27 Mar 2026 07:43:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v6 1/6] selftests/mm/guard-regions: skip collapse test
 when thp not enabled
Message-ID: <399e238e-ed6a-4d74-b075-ead17fb47d3c@lucifer.local>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324013316.2590422-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324013316.2590422-2-chuhu@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 71E56C000A
X-Stat-Signature: xmkt7cfr9y5ctgq7fxh4c5nw3dhyxgne
X-HE-Tag: 1774597402-818349
X-HE-Meta: U2FsdGVkX18dZAduv/nacPPuWiT172Ja8Biwy+GXZQRMMQuy3pG77oJ+1QVAgzAgVdGylHes9fwdn7TNUg+xkT7k94lrEcsRq9Tk6LfdSY9dpix+LBnaNhjrXL9HnNIRXNcqZSx6eYuGQSDPLN8GbDdgrpF6gcL46YlwuT6zVkA15tYd0nmlK35UVr2D9Pk6HnTOaBBZAiBuPhPEnwfStSuADkybtIQ/h7vEKH6jCPNvLh7n2oTDj3CTxGxmuFOnA4ZZyoXz0I8SiBHsBHCy8SeTuNWYXpmzbnJuHQ66a4SUGEEtc7cerXQUvuGjoQ7RngIviKSwPzr3VqKz3rMbeDJry2zlei/WYqQW8M3i23jUJfjRwZ1Efiu9m5M1HONUJtE+gHGgkiHhKMj/ZmHi0MOp4XXgkx+WPk5A35iDkvpXGtD6PopxcmbK0+VlrB8EnRRPwmJkCmYbXlTFyYqWIgj6MNbBkWJxsqkQnyb9+9oAGk3qA/zeYQ0xXNh1927aMUJ1t0HgYKpOjQenX0viExuw58mVBXRm3H1VChl0IgPmu/fBDPSKdTZ/nBRLEEjNhCjpnmNW5MWXzSCD8snEDT8VWz1dJnEw6Vv2h+n6i8dG6FDAArVDCi9oCcWsauFz2rgxtNE+JyuIyjwxgmFbNz5ho/+CzG0+aXBZm6m+Bj0tIfq1vXnqDHbpPvubdAC+rHlzuhQJ93dP/1mFxEyHhbuOXeBGRrxs/GxRRueaCF2Piwp8JZ5jjcIEuy5LttZZqUsW0Y71wHttsS9VUaNDhhS3Jf5lCXpA7bLN5F/g4jPRuSG/GugiNjaRVV/u313EakBWnqMsoFXxa7sztioQd5R8wFWMtjaxh/jnHmDKPNoz1C0zpOh0lhGMoTP2p2DYy6COqM9dFnpRF49cvfUBhSmhamDuUSViPpKbMTSJxJuilI7cM7LjP/h//D18qOAE0IDQvEtXmT7mBf6YA/L
 M/nKQc9i
 RjlOoDmWonNEgWE0nzhv2yvxfXRaKw433aU8DPWspDzJK4maEbeRqD2QGwXVv0V4FV6G1mcynTvBatUmaLY75vtlWJaK3cDBPURMuNLdcXoaLJkkY6gmnd7IEydnM58xgKQDvbdE2rg54hseOzqEu5+ZtCtpzQ7IbFPHKgYlHIq7Bc2FIsFIVXiOqqCmijDEWpEaOLzStxwYXegLg8y4UYYbzwl76OFJJkwY4srN1L628EZpiAmVN9Uci7/xL6nn+rxPyLR7Xwqkxto9DO0fOGVadjFLY8zTCIBJN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 09:33:11AM +0800, Chunyu Hu wrote:
> When thp is not available, just skip the collape tests to avoid the false
> negative.
>
> Without the change, run with a thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard -n 1
>   <snip/>
>   #  RUN           guard_regions.anon.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.anon.collapse
>   not ok 2 guard_regions.anon.collapse
>   <snip/>
>   #  RUN           guard_regions.shmem.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.shmem.collapse
>   not ok 32 guard_regions.shmem.collapse
>   <snip/>
>   #  RUN           guard_regions.file.collapse ...
>   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
>   # collapse: Test terminated by assertion
>   #          FAIL  guard_regions.file.collapse
>   not ok 62 guard_regions.file.collapse
>   <snip/>
>   # FAILED: 87 / 90 tests passed.
>   # 17 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0
>
> With this change, run with thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard -n 1
>   <snip/>
>   #  RUN           guard_regions.anon.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.anon.collapse
>   ok 2 guard_regions.anon.collapse # SKIP Transparent Hugepages not available
>   <snip/>
>   #  RUN           guard_regions.file.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.file.collapse
>   ok 62 guard_regions.file.collapse # SKIP Transparent Hugepages not available
>   <snip/>
>   #  RUN           guard_regions.shmem.collapse ...
>   #      SKIP      Transparent Hugepages not available
>   #            OK  guard_regions.shmem.collapse
>   ok 32 guard_regions.shmem.collapse # SKIP Transparent Hugepages not available
>   <snip/>
>   # PASSED: 90 / 90 tests passed.
>   # 20 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

Pretty sure I reviewed this already (but hey I forget to propagate tags myself
sometimes so meh :P), anyway:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Cheers, Lorenzo

> ---
> Changes in v5:
>   - updated reviewed-by and acked-by
> Changes in v4:
>   - use thp_available instead of thp_is_enabled() as when thp is set to
>     never, madvise(MADV_COLLAPSE) will still succeed by design. So a
>     failure in madvise(MADV_COLLAPSE) on guard region will verify guard
>     region denies it. This is suggested from AI.
>   - removed the 'Reviewed-by' and 'Acked-by' as the code changes. Sorry for
>     that but it seems the changes is a little huge? (1 out of 2 lines)..
> Changes in v3:
>   - commit message: update the log snippet with where the fail happens and
>     add the '-n1' to the command.
>   - fix the 'false positive' to 'false negative'
>   - add reviwed by from Mike
> Changes in v2:
>   - add reviewed by from Zi and Lorenzo
>   - add acked-by from David
> ---
>  tools/testing/selftests/mm/guard-regions.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index dbd21d66d383..48e8b1539be3 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -21,6 +21,7 @@
>  #include <sys/uio.h>
>  #include <unistd.h>
>  #include "vm_util.h"
> +#include "thp_settings.h"
>
>  #include "../pidfd/pidfd.h"
>
> @@ -2195,6 +2196,9 @@ TEST_F(guard_regions, collapse)
>  	char *ptr;
>  	int i;
>
> +	if (!thp_available())
> +		SKIP(return, "Transparent Hugepages not available\n");
> +
>  	/* Need file to be correct size for tests for non-anon. */
>  	if (variant->backing != ANON_BACKED)
>  		ASSERT_EQ(ftruncate(self->fd, size), 0);
> --
> 2.53.0
>

