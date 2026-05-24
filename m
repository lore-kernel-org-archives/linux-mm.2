Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8A3CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 17:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B316B0092; Sun, 24 May 2026 13:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BE26B0095; Sun, 24 May 2026 13:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A217D6B0098; Sun, 24 May 2026 13:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0546B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 13:06:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E45E21A0D57
	for <linux-mm@kvack.org>; Sun, 24 May 2026 17:06:20 +0000 (UTC)
X-FDA: 84802941720.04.27B9D10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 37D5616000F
	for <linux-mm@kvack.org>; Sun, 24 May 2026 17:06:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOTGBYFt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779642379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIF+d7eP3FZA+FXOPpFTmfAEaiVGtYOh/X4XUDIQvc0=;
	b=4Qe3AjeYfC4bE1jTekYvmEuCwgMsxw4zfKmck9iCdETXVMcWCyDrO5maXlwdk1rGSeP3ae
	TFa6/218EfeB2Ei9r5GS0tRUJ7p9iQoTblKztEcCnC+Kw2nR4M7TD0uHL2QIPPl86NutMR
	91tGlAXXDc9P3sGdq8GQYUJqOpjpcm4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOTGBYFt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779642379; a=rsa-sha256;
	cv=none;
	b=minkroNz0GhawaRe33bGbaeagz9XEsH28IAla4Bob4kRYfwq/0CyFvmoLbd6ELxm5YfUXh
	FHGdlTwlRzHi99N8xTZNQh2mLCkMJJp9/8arlss+q7nMmrubYZ9vgDhaUAlvoe0ZAOVyiW
	vbml6B1PetDYX5L+rVZGc+DzYZYs6R0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C2B941A33;
	Sun, 24 May 2026 17:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FDE1F00A3A;
	Sun, 24 May 2026 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779642378;
	bh=SIF+d7eP3FZA+FXOPpFTmfAEaiVGtYOh/X4XUDIQvc0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=HOTGBYFtSVQVuX6OIVGpgvGVGz99mWvpmdUgcyRaIviFkNulvzY+CxrGr8DlBA1KV
	 52BQVrRSDfQPoQsf0Ctc/SUoRuARvw/NjGp/TSVp03BHAFL1qeUzwAeYcvbPfjqS2Y
	 /3XmKF9GQ0V5Wu3Nkp3C5pNb8iTQpVfmn95DJTDmK0XItoVhJvYScRjEpJc4XRvJRE
	 jH57+HwOhlvQx2IVM5UQAjTouLv1so4L7p8mKhPEm6jNcCErv5leqTUHp6iXR4Cg9z
	 jMQ4lVjknfolAjX+X52h/2XcmQHwvR7njKIBOrz2sKRx9/LCMeJuZl4vPvRbg7idaR
	 NI2qxXj7GR3PQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 2/4] tools/lib/mm: move hugepage_settings out of
 selftests
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <20260521111801.173019-3-sarthak.sharma@arm.com>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
 <20260521111801.173019-3-sarthak.sharma@arm.com>
Date: Sun, 24 May 2026 20:06:02 +0300
Message-Id: <177964236208.4000040.6637433432678119173.b4-review@b4>
X-Mailer: b4 0.15.2
X-Stat-Signature: e67tasjybynbgo7tqz93zij3jizi4kqj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37D5616000F
X-Rspam-User: 
X-HE-Tag: 1779642379-890614
X-HE-Meta: U2FsdGVkX1/hs0wZZnVlHzjrC5wFTWAfUyEEGu3PqfmFsJwGVw4L98BSgYbs4DA8pVGpf/yonJ1i5EM2dWrRDtNEp1gdbGvajz9x5bvrrSOipBg+xxx4673/VMeCEfsSEWykOTK7qe/4RBYVRcBSDcWKoyKKmIzCKdbdSEVc+Hy8Fpf2QLCjLgwaQnv5dmoi0xDBV0q9XXZYJ3QvGit4wf3m6DUUxrC4xm+orDfk1u8w8YCVFOwSiN7g9dY0lgoQ3+fepgwq4itLwdunPB5PyPRlM/iVXPZIYr1OnFiI64Tiv+xGmmdQhWElT28I1ggi8XtIvaFmGAmX0GnKqJ5dLXdSRs6GiQ3gL8NEGfrjctAw+cvIs8LlGdRHL5xvYDOkWTPGjaWi6CC+0ka5jKdkAaxLVtRnIa+AsP6UdnQK7rjgksfl9t0CR07eTomrf8DhHnkglW5cxQ2BVkeDWEyqIABa7maKHoteYTPUCRvsXJu1/oV3rAIU93ABlhqKpZb+XTroT+wdI5QtgKG0ZQLDAcer7Is0d91SQkMm5DXzr1NiFVUJdD+HktwnVUKqQ1vcFX88IMKavvJQ8IC1Jj5nkZKIaLOzJUJYueoItIfbWPriuyYhsl31WBAz5oom5HZu4QtfoQpNhd2DvQ4Wzyuwn51a2g76wFW6cEQtRnMac+ugmUKjEmF/FPvJ5tcicaidYi58AtUvL3cVsBFfsLIjZt792xOnTo/xDNb8PKMj6Cb67zAd3fvoh3fEGHtpm5y3/VnTbWmgGVEQH9gYp+Gg1JXcOTK88OK1i1T9eIi6K8097VIn003TgZaoaF8hcUt9NqoBL2JorCegSfWiiDvkKoZp9q4OZqfdWyNeLfKvxiVTFrrL9LLY4hpff04g9XCS5F1GoSZo9o0JdY+o1FmH9T1DisXII1YkftlgnRcGhmWgS4mPnUuRo11Ay+5KDXtMU9i2PgQUuKBTBd8l5re
 dsyHr5Vo
 5xB1OLHvAmNBUV7gs7KhZAwJfRaDQqrU+q4NnMOtcQrMM5/uJvLgr5a+haGe9FzD5m8SYfdEMzFamnZ3kMjsDBFkZpUYI1DQwUS0oNyQ3sVFRRkaU5O2wYSTW2RITBgtH2rs0CsPdrH1z5iizfB9wjcqBqiTtmKcQhEWy5GPNbhJAkwTCWqxzK8Q0mRJOKSn9Wyzwahga+kDiKd/zsk6yzxhs1wVup00tBupvmpskdxHzROULlulA2Tedu2YE04/sYP4L6LNIOoAphjzOI6pX+1NayKjHDyAer0Jeq50QO1nac7eNijG1PajHuXA3jsBYxCmAVmXQNWQvBDIumzkI4k+II1dDF4UQW4HXTVjOjBw80S8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 16:47:59 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:

Hi Sarthak,

>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
> similarity index 98%
> rename from tools/testing/selftests/mm/hugepage_settings.c
> rename to tools/lib/mm/hugepage_settings.c
> index 5e947abb7425..b08b27776fc5 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/lib/mm/hugepage_settings.c
> @@ -383,8 +387,6 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
>  		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
>  			continue;
>  		sizes[count++] = kb * 1024;
> -		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
> -			       kb);

I believe this message is useful for debugging.

> @@ -503,7 +505,6 @@ unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
>  		return 0;
>  
>  	if (nr_enabled > max) {
> -		ksft_print_msg("detected %d huge page sizes, will only test %d\n", nr_enabled, max);

And this one as well.

>
> diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
> index de0633f9a7e5..7c58506c0aa7 100644
> --- a/tools/testing/selftests/mm/compaction_test.c
> +++ b/tools/testing/selftests/mm/compaction_test.c
> @@ -15,9 +15,9 @@
>  #include <errno.h>
>  #include <unistd.h>
>  #include <string.h>
> +#include <mm/hugepage_settings.h>

As with file_utils.h this can also go to vm_utils.h IMHO.

-- 
Sincerely yours,
Mike.


