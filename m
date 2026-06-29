Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A4FCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C2E6B0005; Mon, 29 Jun 2026 06:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CEC6B0088; Mon, 29 Jun 2026 06:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64846B008A; Mon, 29 Jun 2026 06:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B30406B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:20:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4221F1A064D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:20:36 +0000 (UTC)
X-FDA: 84932556072.15.B5582F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A92C61C0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:20:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MriwyfA1;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782728434;
	b=GwoWljy0M/yBIf2K7mMtQgZXoF4jH/2NTgiamdgbzFBuS61A1nu4+FSlk8G0JFTmLnDCL7
	jTh+ayYQLoNFeAJLaOnspYEJRCuIfzVk5l5zikVpTF5EgVtw3VxoeCoH3rCN7kW3ACjZyJ
	g7iqrvGAmKAw0qowbDeQ4bG73iWlqUc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782728434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpGoUDIQQyxm8nXczBO7uDgFlJUnSsbppjIImZsuh64=;
	b=UpZnE0GVEK2u4fHpu9Z5YiUt61JFiSzs0X8vdNWkC1yR1forTsPSC+CWMIVDGJTFbTqSvv
	VluAe6irn+ZsUGxtNiu/HJdNqJgelRw8kcZ9XsZ629rwCkbhAKAywKgBwJO4uGrmQ1/mz3
	H2IUE0CiPeV2VMmoMzUfXHPJkcOS+Lo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MriwyfA1;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAE9942E18;
	Mon, 29 Jun 2026 10:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435D11F000E9;
	Mon, 29 Jun 2026 10:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728433;
	bh=HpGoUDIQQyxm8nXczBO7uDgFlJUnSsbppjIImZsuh64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MriwyfA1WkY6hiHd3yFjQ4ooJ3k5caOhTZ6fELGfsJHjiUBQOmtiRJva60TGrJYbz
	 GTaofAmjQy6vFPTWAgrEeTLgvtQf4Ktg20+JDQSE/ab4SM85mRj2ErV5y56DOeSlYN
	 VmBI0ST/NteiA80irAI67Cu/MISTaDEG9LIAGCivmlxsQ7ZazpcC2ACmwKZRiUBZc7
	 9u4EKhr3tx7qWt6xSEnnOTZovMVkpieLFG52lpdmEYfj9+hBcLccD4SwW2T9tjiU7w
	 T+eQrhTmkHlrFSTl48r2K+dKe4heyGAlxbFcyfZk4LkRfw5kwfkm/bRi0S/5vi+Rwv
	 ymyOaZKRBQlNQ==
Date: Mon, 29 Jun 2026 11:20:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, shuah@kernel.org, dev.jain@arm.com
Subject: Re: [PATCH] selftests/mm: hmm-tests: include linux/mman.h to access
 MADV_COLLAPSE
Message-ID: <akJGyxHtbA0lvPNa@lucifer>
References: <20260628143111.36863-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260628143111.36863-1-zenghui.yu@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 18keumykd9erdjb1x1ksftsnzha1ufqa
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A92C61C0002
X-HE-Tag: 1782728434-649733
X-HE-Meta: U2FsdGVkX19qhSDesMss6lsp3v6v9DDDYr9bR8aPZTVrQ+614G07iZ4rFzQ/x0rTvEXXEUPWmwvCfraFLCbxsireJ3PdqdTtL9QRcp8GUJUHHDib4LdMt6NcHQ8yrvAypvMYYNCvlEs8+Xr85C07UN5YZEua7d90SmFTSyN+w2uu7/f1exxtLQy1vIK4/hJ76jRx1Jb0xcr9tT9wksI++Aef8ZUUmL+66qgVHeXifPrcu70OVwQArsyOyQf3lP8GE8CtUrydbFDLXYLJV9HMI9qE8f0VOi49mQp9U9jCZ6poAq6NtjDmhfOyjjjSVW8ppwjal351h2FWLGnv60VOQLNMTKiQGRzFAd+yASz/d9+TjpguSU5fBYOHx3Lijdf3PaJnDYYkeP8MfGa6uAjHic9hoThocpP8YBW3JPq6A2NGSJ+IXeEumHda2qPkAdaE5vnPr0PG9dPCz3bkNZ7yBkbSzane7L/S4UWNqPB17W7hTZa4QqCF2D7kGBlxgxIvqqZyOne/FReX4YGvWo8FdBcxwINIHSfQz2X0xWO47TlBVJ1Mq7YGp4yUgJcO97LLBXvmdES3iONtrKFIHQ6n/bwInmKKtw0DgdxZBZckCzhoFe4RI5oqpUy+LGgUmIiFQLOwpmGO9ywBX1Xdo/WFzqqB5iGRHosfenIpGbTNl7IuKOBhcqDf6Ed1/ZZACNLGGounJ7g/iEcHfDyC9dXSfZtSSaEz6lfBN2mNeUYrYGr1J4kW2aXz2jd+wCExgnVzxYUS7m+E3ey4/+jYfFSY8TJgvmPEKpGovSv/ssO6qHJ5u69Kcq9PAj1T9tk9WRjKiCImMrUJzdHdvVOEc2z+Rzq6zSyla8GP+FA8Og3KVi+stFRTfUlUtsBlC29LfTV+/1oUWpvhk5NUcwkBg4TZLDl1BTDmPYUcp53Lk/MeuWM+zdB13lai8By1EIoO9hgLgY4OioJz+xuwC+ja6CI
 0x9FLm+g
 aSMHvtwifOmBwi/5pCNU/C3M3sISdpLoZ6wbfZobVxpyhjZnqJerz3Z5z/tbhJyUbEzy3pOv2deZ8KmVw5JIoT++OSuvxLewHQckwQPrfVNzhrjkleTod7we5jCq4p5pVwM+zZ84R9ctXTIXPrsu2YxqogbTcaZf7HNdqrXXaqT1tDRO7/GFNih+d9YIWB9/CJP/iUqXg5z3oMW5CfnsO01yIhI75k6s6G4aLg+cnAi3nU52nFrTv+SNcZTc8WLNEdCu0oVWXuZY5xvA5ppMj0FjYxkjqS7bQ0AveNIIgFDNDVu39kF3ynTRkt8L1HGOB5KoZLFPTH8GD4sB3kTd99NAPy/ccNXE04bfeKceXyVMRH8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 10:31:11PM +0800, Zenghui Yu wrote:
> The following compilation error occurs with an old version of glibc due to
> a recent commit adding MADV_COLLAPSE testing:
>
>  [root@localhost mm]# getconf GNU_LIBC_VERSION
>  glibc 2.34
>  [root@localhost mm]# make
>    CC       hmm-tests
>  hmm-tests.c: In function 'hmm_migrate_anon_huge_fault':
>  hmm-tests.c:2355:27: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
>   2355 |  ret = madvise(map, size, MADV_COLLAPSE);
>        |                           ^~~~~~~~~~~~~
>        |                           MADV_COLD
>  hmm-tests.c:2355:27: note: each undeclared identifier is reported only once for each function it appears in
>  make: *** [../lib.mk:225: /root/code/linux/tools/testing/selftests/mm/hmm-tests] Error 1
>
> Include linux/mman.h (which provides the definition of MADV_COLLAPSE) to
> fix the build error.
>
> Fixes: e3d8707358ea ("selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries")
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/hmm-tests.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e4c49699f3f7..2f2b9879d100 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -23,6 +23,7 @@
>  #include <time.h>
>  #include <pthread.h>
>  #include <limits.h>
> +#include <linux/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <sys/mman.h>
> --
> 2.53.0
>

Cheers, Lorenzo

