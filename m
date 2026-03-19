Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A7F1090257
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92076B055E; Thu, 19 Mar 2026 13:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42F96B0560; Thu, 19 Mar 2026 13:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F9C6B0561; Thu, 19 Mar 2026 13:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6D6C6B055E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:21:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A1F913B72E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:21:15 +0000 (UTC)
X-FDA: 84563478510.04.C0FF187
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E35C4100003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:21:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZdx2Prs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773940873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PV2sFERgk/6GDDy1Na8ccLwgsZ1nrAl/UxRErXdMHhU=;
	b=ONwmb7pXeZfqIxcW2hi19zdsWyrNuVYcRgHkUy2nGRJygeGmocDl025MKQE8Kjode43ywA
	OLWIefmnBl0/qyCeajSE9N36j9SIPc5r/Po0S3hfJymqGwPHJSx9KoMOTmehRrdTbdVbwl
	ROFo2CIxt9NGMN37etxfYWJpYHc9jcY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZdx2Prs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773940873; a=rsa-sha256;
	cv=none;
	b=r9AtidvOjf58Ps6fwED7MJhHfEVUzK3olRX+pRKwVrj2nM6COB6znfVvOe8V0d9IJ0lr86
	6crtXhIREoMwjV6ZbH1Hco71YwzSba1Ntks4eCP7bp5lKxNoPg5j7KBwVcHmxqZUvaNZfB
	KhZSdG75tFMA34GlLSKu95M/aQ9MyXQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DA31600AD;
	Thu, 19 Mar 2026 17:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C273C19424;
	Thu, 19 Mar 2026 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940873;
	bh=3b6YqAkapmSDefp0qy4dwdPUjANX/OK7tVoPqcanxz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SZdx2PrsXJgpbU+zzwntBo7drYhhQRyydtcfqtmVAEsmkXY7+2UhwaaC7x10LCpfE
	 mP0SFlWNqdUwMc2eGLEt0whI2xqWw3K0UeDHirldfuA4lxdsS8qoFlu7X13/K+uS2b
	 T028yzQuWp9PEU7X6z2FA/+wlqYCzqU0/qIXbVic8fc+RHAIMOD/LynnSqhHnw/kaN
	 VhTEejhGk95L05hPq9XelkmzOOcP0XP+VX976DuV7nSORSQyP02R+pJiJXOJJojzYv
	 HJ61YNSvhfV//T9wo4Lym3BUyr3g9QM3foHE0XpkAvogerRe/ZRjsF8mPGVAnsO0/8
	 VjpYK6I4QvJAA==
Date: Thu, 19 Mar 2026 19:21:03 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v4 1/5] selftests/mm/guard-regions: skip collapse test
 when thp not enabled
Message-ID: <abwwf6WlLwdQDBE0@kernel.org>
References: <20260319160656.1480279-1-chuhu@redhat.com>
 <20260319160656.1480279-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319160656.1480279-2-chuhu@redhat.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E35C4100003
X-Stat-Signature: hbncr46d3t6resktd371ffb586awg1oq
X-Rspam-User: 
X-HE-Tag: 1773940873-420895
X-HE-Meta: U2FsdGVkX1/FK8AphFuUNXi85DJi/A14DL/WsSuFHrUhDP5Xaq+xlFbpE4T+dJNgdg0hYbGxMe+DIDUeuHSTbz1pXc9rmzKHN4nqoPgadk0CURD5kzPB9VfR5VJwulpD6SMwCX/KTNw7Vup3SRFf3igxq1alAFK8pdOqqqYo/RxNtDzX+d3/kTM/ibc7WEPVJG3OZnZV6W/h8QNfOZ3RJbd9BSIFKSJzVohECLAwzoWNAR1RJk7svJAemf+mo4v6zBtyUBZLptBrSSSuOPDqEpzs0gFtFBL63Jg4xwEa2RXtA8ePe/bH21i7lG3ElZa4xqBASxSetFttoZinK+3KtRbGWCpb7nSrMcJ28GSiZpFryGhdDjFRHlk+ZLEVV/Fc7UucB4M/PSTzHkrsBL59rNpJ8oJhsF7vj9Iie4lf55E9TwryZBd/pmuZyraGR8DPWw5o0LVv9nqPpfJgiWSnu8HGqJmgAogG7uqcisl90fyR6P1WY+6DhFMzOIE0gnuWzxWezWByBF9h6x6MAPWIb4CqO8txLJercmvQ7DZzNYiWRxJVmPuwE/rkXuCkopxtAd6+SmIzF/ujG11HKhkEtiSzXklJUqqUOtnk++K38AwVF9BxH8QRg/+WQxjdHTJDACOJowfPqFHHj+ai7ZQJAICeICR4I8lRQM+0QssUfPtwDK7W86VczB9+UuTw+ZRZ3GZPQJxvQdmxpDHrM2Fnzycb/NBEO1sWLOcWohnpNdvVE0eYWZK+Zp++XjzyHVPTCtdngYz2GuJYfoM8egzI2T3btSX8vgFgVdMuN0ZYpp0uXGw/m/5VQYv5Ki4fMJRI0AchW1dBoyvh07U1ygLFrPx8B/3msWh8FkK8oYqqye3cliw1v1AVN7re6GmaVJeErVmtAyiL3nFDqITewXH/1BdqTPiDtnfmFsO4MPLSTgKzZfzp6wdRnm8KEfAmn3IsI5PNsxMRi2UFiH6sONI
 u7rTIk4G
 q5sQRnjmtfNNLGra1BnKCflJ0NubmvhLDy9m/Y8scxSIlSiLwX+hGgJZ0CB1HndMOgvuBCukmI/EYxBTjr5lt4dCskBl2VPXvcgzwZ6ttLxWfhWVENaZeGhc1lt5HH8xJQqYA8mtULRBxXT2sSEi8aKEa3cGqz4POWBuPo7pBwcHJOQtoHYfhthE0v+9zXUMPTyxmIYTb+HnjcgCkRdvhlCyvLMaj9lCBm5PttDsGRshjMjB/uYv5+2C+JxnH94sEKxqAiOOdT7epqSVmB5BxA+3qSD/WAMJ0ZdlJgltozdZ1nfQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 12:06:52AM +0800, Chunyu Hu wrote:
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
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
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
> 
> base-commit: 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

