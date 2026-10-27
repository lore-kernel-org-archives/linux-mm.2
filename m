Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED394606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UxpDHeHH
Received: by kanga.kvack.org (Postfix)
	id 04C376B06F2; Tue, 27 Oct 2026 08:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3FB96B06F3; Tue, 27 Oct 2026 08:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56376B06F4; Tue, 27 Oct 2026 08:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C72D46B06F2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:22:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B453409E3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:22:15 +0000 (UTC)
X-FDA: 85368318630.27.3741FCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 835B320008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:22:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxpDHeHH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6rA9UMp/JGSOmXViOzDwSr7LLAHqPbFa1f8OGf68K4=;
	b=Sz8+6fVfbdSj1lDlxBTJrVJuFnoxX+hNQoZ3/L5izg0ZuaXeuMDtmsSGWEgYaDto+AntOt
	xHAKXGX7p6ZI9IVoPJEBBo7D71PySf5HILP4BsoLpOMq9aO7cdMIMKAvayRDEUKmRehzKJ
	GHdB75eUa46urRMfc0HxQNw+BRnbwfI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxpDHeHH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103733;
	b=xBl5AIyjW9lEcKTOm08OO92h6JhBct9Q49UQu9DFB5RQYGyIO2uRMCVagZh6AiKilgXnjP
	TeKnDwvRWt03/XKQBfpk9anZ+zilNLFvp918ak9k+yzG/VJtftlzNQYEaAJCokpHalGhVe
	+o5mBEVQ8c/D6MjPnWkIbe3nQc8ue0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BC9A42A46;
	Tue, 27 Oct 2026 12:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51341F01825;
	Tue, 27 Oct 2026 12:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793103732;
	bh=Z6rA9UMp/JGSOmXViOzDwSr7LLAHqPbFa1f8OGf68K4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UxpDHeHHwyVTSC2pD+MOAmNN4c2M119lUqYyqPLxq+Qvp4f58sZ6KGWrDc2sKe0ND
	 tsb+ueZ5gn520fctwRvayMfwtMQouzf9jLxSmX3evATAa+rXSx8fyM5Ahe5vhofhCS
	 vg7Zj5H1ah8Azrm/6/33eDsFel2HS2lhGLD4k9pTg5nXW879Sy0nVBSQwViYtT8MKi
	 sgp3mgF9XO8szQ7PGIbD06U6CLMjpIEcKMAly0zcKNo6v96kddu6ENRyVSSwpxG8Vm
	 aAXHPWiqXsFnTSlCEKwsHJCFdaqxlHf0iElfwOeaFJP2taL6+zEg45bewKaVaGteN/
	 JwSd9Mre+m2Ng==
Date: Tue, 27 Oct 2026 12:22:07 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	kas@kernel.org
Subject: Re: [PATCH] selftests/mm: fix khugepaged_race build with older glibc
Message-ID: <auCXZk9g9nFK1Kbs@gremlin>
References: <20261027122013.4286-1-zenghui.yu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027122013.4286-1-zenghui.yu@linux.dev>
X-Rspamd-Queue-Id: 835B320008
X-Stat-Signature: ozmpqiazswih94aeitr3sjq6nuf5xidk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793103734-518479
X-HE-Meta: U2FsdGVkX1/d0nvC8qEOO3OHbNTg4q1ysdKkDjmoEpkazUBDa3MKzNa1tK+sUmrRkR0EpY0wQDbJxQBeuI+q/bo3RjqNnHQOTj6/4cwfi0Fj8krW7JtBhDZGydJfegOCA0trD1IpPYTzsYvYg7lhpwX62mnhHHL8ncVNc1jjDNcC26DoA3G/nSQ8O0BO5Lhb3WHzKjEIM2f0ptoy7cdOeA2ZIhuRuO+hGX4w4hhFiCHy4mlVgdi1LCu/XkIlgoyM6vJ9EXrlli8iugaJQDwbpHOk9UslaZbubnVuOSR3KXRD7fgXQHoVL0dE8QA/x3svtJiHoLpRde8gJZOK5xEjrOLF6R0MzKymfeM6s8XvLwbdQ/AQm6POFYrBTaCDIK8B2UJ4v6W3rLni6ZE14vX5MnMMo2NHQYFyUcIaIfszQaC8lTR8TZipViK1sbrLp3xpfMuUOjwYMDdgYfpkCW3SB4eTzl6SI6ApfOovCdXvnz/mdXVWCZmYd/te8JZXRXqU+3n12dy1cdm0U9lPJN7NM/BLiE5FLxK7ay6RtMNljs2zcMCmAiPlMS9aL3qQIRFdUZ6sA3AGgWzIf68AsqcCd1hIT2x4bP2+Hhj9maMJDSNvR0/afmxkRMl/WCbIp5gVF/L4OL2hy40KqOMC09AlqMOiCwbVFBMw7xq1zm4iCaJwK5X+zX3Bx5KG093K6ZlMX+4r5SG9ifOhP9OeYAoRZZfyW9AQ4Syt/wBsoocMaUHjuVBcX+uaelCoeQTGMzKlqqMCo1EFitHEZq9wshP/n2uZZOe+7LU78Q8XYqgNwBTEfRdNyiePN/Bca4H9QEo8P1QS5VL9t8jOUEpN6ZaPXvbm1AMikrLQC6a46JI/cSA7UHoZYihFZIIDlEaJLdRcg+FUbctW72iVgKfhTDk9XxVxN4NWX/qZgMP8IWu5Un2biNCsBVYb7bCygRQ3xBEgO3YBjBxbT2AilaXuD+2
 01dRcfhm
 sbAGaz5F7ouDaHpPV+knqT2rbaXu4aLit5cn9ZGX4gVhoCpHAXG8MZ8kZpYcQUgUyJ8yGKe9AsORfv96ceIEqb0cESPY03yCvenGKyttzTO0iXwiigqfhVlejSVWccMiCG5vD52EVbkjjMImDjxAF6mKsYJ+H8HnjxrESclRCFy4PVBpBZ3OLfrSLS+dZvMG6YLnxzmpwYzxsOLy+6qq9tBumGAW4GSXdFD1+ZMcz74+B6usVP7H5bDvz5Bh/9BgjofsmnBwZgu2E4afIF9bnUSFmSK9J6GgY/TXi5l5zaVdYF18ysPRFOi0z/QfMKh5rw+J4kVj6QddcIWOJHQ1oaDQjtSGDMlP1kO59EswilJRE+JU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 08:20:13PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>
> glibc versions before 2.37 do not define MADV_COLLAPSE in <sys/mman.h>, so
> khugepaged_race fails to build against them (e.g. glibc 2.34):
>
> [root@localhost mm]# make
>   CC       khugepaged_race
> khugepaged_race.c: In function 'main':
> khugepaged_race.c:506:23: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
>   506 |       hpage_pmd_size, MADV_COLLAPSE);
>       |                       ^~~~~~~~~~~~~
>       |                       MADV_COLD
> khugepaged_race.c:506:23: note: each undeclared identifier is reported only once for each function it appears in
> make: *** [../lib.mk:225: /data/code/mm/tools/testing/selftests/mm/khugepaged_race] Error 1
>
> Include <linux/mman.h> to get the UAPI definition of MADV_COLLAPSE.
>
> Fixes: 66c374464438 ("selftests/mm: add khugepaged race harness")
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Seems sensible enough so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged_race.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
> index abb0678522cd..1a27cb39745b 100644
> --- a/tools/testing/selftests/mm/khugepaged_race.c
> +++ b/tools/testing/selftests/mm/khugepaged_race.c
> @@ -8,6 +8,7 @@
>  #define _GNU_SOURCE
>  #include <errno.h>
>  #include <fcntl.h>
> +#include <linux/mman.h>
>  #include <pthread.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> --
> 2.56.0
>

--
Cheers, Lorenzo

