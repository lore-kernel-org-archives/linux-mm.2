Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C278ED46C01
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 23:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68336B0005; Wed, 28 Jan 2026 18:31:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15E26B0089; Wed, 28 Jan 2026 18:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21936B008A; Wed, 28 Jan 2026 18:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE7A06B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:31:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CD491B1473
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 23:31:39 +0000 (UTC)
X-FDA: 84382971918.03.20F3A57
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 646C4180009
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 23:31:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Li8FflG3;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769643097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVNVdrc3ypCMw932N3L2i4gO/mh6FGcnGz0CdF36/xc=;
	b=vytUIG/BBKLen3jfCeS0OhPTLG5W5xEc1B0p1UexhNLGJHJPNs/BaDQiadJk7Y6ruuAqPj
	HQU0EcafH2poaFnTb7GhQrLDTvP4skayt6LEg7uO5o/0LM96zGGntvcoPgUBiv0IgAc4YO
	vwFzqIlM3KMlNZPUeXeeEgZp0yVwmPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769643097; a=rsa-sha256;
	cv=none;
	b=TqNCeJPiYTmhojS4gqsxVaEWbj+Pf9GKlv9C/tSV3jnqI/na9iMLpB71fjvbi8eB81MR/2
	8vM+tRjuiP9JCXQZsORd378//LxNONpLQmwuRmaBQkUj1WcnKz++zH3ay6YF4lPZ67PPzo
	5FX0MSELEA7rf2BPs1/iXc4E0JJLeVw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Li8FflG3;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260128233133euoutp024d392f5188b952a4f31e8de21409fd7b~PCQSHHUwi1995419954euoutp02i
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 23:31:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260128233133euoutp024d392f5188b952a4f31e8de21409fd7b~PCQSHHUwi1995419954euoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769643093;
	bh=cVNVdrc3ypCMw932N3L2i4gO/mh6FGcnGz0CdF36/xc=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Li8FflG3uz0fSMb6YkEdWieBNXVAjxjus6/oD9fTw5PN89eHHLNG3C4b9lrBuvrIS
	 VpROMrLMKJ0Qrh/wylHkRs3gd/uN6TdJ+kyw25mW86HoBNZLh5ARaqMVpglRMU6mYg
	 RvmK4XlRKa2kKYbTjIfljwI89NmYXzE3e6t8TPro=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260128233132eucas1p1f57368f41dcd3a718cada8b95c1a3fab~PCQRTTpUD2444824448eucas1p13;
	Wed, 28 Jan 2026 23:31:32 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260128233132eusmtip2187009b9292de67a5ea37de687f298d6~PCQQrNe6A1539815398eusmtip2G;
	Wed, 28 Jan 2026 23:31:32 +0000 (GMT)
Message-ID: <7809b35a-fee2-43e2-999b-9244e5efaa17@samsung.com>
Date: Thu, 29 Jan 2026 00:31:31 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] mm: cma: Fix stub for
 cma_skip_dt_default_reserved_mem()
To: Mark Brown <broonie@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
	Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, "Rob Herring (Arm)" <robh@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260128233132eucas1p1f57368f41dcd3a718cada8b95c1a3fab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260128163207eucas1p15d5e6380ad65350de185ded053d0ed2d
X-EPHeader: CA
X-CMS-RootMailID: 20260128163207eucas1p15d5e6380ad65350de185ded053d0ed2d
References: <CGME20260128163207eucas1p15d5e6380ad65350de185ded053d0ed2d@eucas1p1.samsung.com>
	<20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
X-Rspamd-Queue-Id: 646C4180009
X-Stat-Signature: xubdc67tpq3imy7yaarpdy11reqiy66e
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769643096-145820
X-HE-Meta: U2FsdGVkX1+O8U65xT9GLh695BOkIAQUR8+jJqIVcY9gnPWzDOiD4m8zh6cPs429SP5vJisDgG/qsAhfJE6/YqsRo36Nc2oB0W6VscSQbBtuWTtcxIiT5MpVO7V98fYQ4DGZHjX/o4EPCd8zMRvaDQQrfUX2vcd+CeFfo5yhHeN28Z1xoaZLU3TrehiOcJtq9NfCiTSg6yHWnefCoE1a+aicDqK6J5i6NnbDCPVCEcbWRkdj+x95jNEVnDI65NDq9wX6P2UPWEehyukJitLJfBOctTNx4/mSGYfkBONJuIVnS8cjeGNLZFLiB8QSr7tJfG4USDUp8yL5VO6yrZNFhzt0tvHDA2RVdJ5/YTKZ040aPvi+RbujvOjRGc2FkM28GebhLYoGbPekyFsoZJfKvAp3O+vjakeDYTtXuZiLyvZnuKZs+M49wiUJbWbvliDt2WdllM6H1zF9qVbcudhyeoBo+QCz/UpzvLwEftL8MYuV32f7s1u79dkYIC2kGICvIaoGYvxr11oR9NMe9CsjdbISrk+8urYzY0eRQGtvPy64Ru7gZ+pqc3X605mJpFUoLh6uROfkvRKAvn+YXjZXsITwoDAwSUY9Ku5lirBD0AliAdFJd0tjnxumvJV1HSr0EkG58RYwurQAEbRd8B/8rP5IHUBiB4aROiMzVbUxWn/LVlRKPBeUPe3h37hrmDiGDvoCimVtmgm378hhDun4qH2j5++FK1sELzGFzxLO20+czS8t6VFWOS6tfU+vUrQOtoy6qGvKtFzFEGM9gEC737wUYeWxGgHfd6KumZkz7rtF283OKZo7eZTztZxCiAaeMYyOdVXWPbVt28yGjUdIYRJv+YfKO9BtEvjxN1X6aPxyGamLH/TJYH7I91fBkwWVVJS0hsledmf+Y3cjyc8ADA6MDuWOI/n0wyW2ykdgSzdWJ26/FECZX0tFMvvybfK26nqZToWDQeWxuMESLz0
 k26peS9h
 nK003QIwU30Q+/mcLGcXgJZVRE8CHMlpIV85c8vu6aGTkMPZlRzJaqopHMxKxQJthSIOh6pGS8eh8ykUlaXr6/5DsJLU4kJD2f+AYdvKBvM9MExRnLltoTR4coAYbxfnJS+sGkVrpBG1haLjekFGn7c/muBq9fN5YIkmENzjdP2tWaVGCYFdXzAVVhAIuhgL8kJSdSzzJLbT6DocczudVOxHwPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.01.2026 17:28, Mark Brown wrote:
> The stub for cma_skip_dt_default_reserved_mem() is not inlined so
> triggers build warnings:
>
> In file included from /tmp/next/build/fs/proc/meminfo.c:18:
> /tmp/next/build/include/linux/cma.h:68:13: warning: 'cma_skip_dt_default_reserved_mem' defined but not used [-Wunused-function]
>     68 | static bool cma_skip_dt_default_reserved_mem(void)
>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> which are fatal with -Werror.
>
> Fixes: 26332ae848f08 ("of: reserved_mem: Allow reserved_mem framework detect "cma=" kernel param")
> Signed-off-by: Mark Brown <broonie@kernel.org>

I'm really sorry for this build break and thanks for applying this fix 
for today's release.

This issue has been introduced by my amendment to the original patch, so 
if You don't mind, I will amend it again and squash with this fix to 
avoid messing the last minute fix with potentially not bisectable branch.

> ---
>   include/linux/cma.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 0bf408360641..d0793eaaadaa 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -65,7 +65,7 @@ extern void cma_reserve_pages_on_error(struct cma *cma);
>   #ifdef CONFIG_DMA_CMA
>   extern bool cma_skip_dt_default_reserved_mem(void);
>   #else
> -static bool cma_skip_dt_default_reserved_mem(void)
> +static inline bool cma_skip_dt_default_reserved_mem(void)
>   {
>   	return false;
>   }
>
> ---
> base-commit: d0d97f0b2b2b4633022dfaef4ac08af0b7917efe
> change-id: 20260128-cma-fix-stubs-26b13ce1471d
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


