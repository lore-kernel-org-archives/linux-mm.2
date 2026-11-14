Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD85D606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YK09FWet
Received: by kanga.kvack.org (Postfix)
	id D5AE76B05E8; Sat, 14 Nov 2026 02:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32936B05E9; Sat, 14 Nov 2026 02:34:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C707A6B05EA; Sat, 14 Nov 2026 02:34:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 958876B05E8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:34:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0619712034B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:34:11 +0000 (UTC)
X-FDA: 85432911102.07.6EC03E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6976F20002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:34:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=YK09FWet;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794641649;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0KoqRgmGRc0qs2TY2et1mN3EuDIIdXOqtoPQ8Z8M8aU=;
	b=h28Yh0McBngxlD2ADQrpvyljcG8hgZK4LBCaF/QV/UMB6LR+8DeHUzRJOX/uoMolw17Clh
	SdpzaaB16F6LKetOvfi1qFD5ZYD2z1Mx1STk/1G16CwG4DwiKhKTtNZgrbLdoxJbmGM84+
	46boIijp170SsUryZ7/ftQ0+ZIJGtm0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794641649;
	b=dTZks/tFPZ4xtcBKM+e9C+Ltis05Jphlr62DF1RQYtZ9ckWJuZRZF35aPJw5/cfMoUxgaD
	fR6B1buSGQ7sP3UMyXyxTEitjIQjZ7VBsgW8nc4l7FC2gFHE9XxmCk5I8pxrimPol6tXzv
	l6Qvb5rtuFCscWMamOz2lKLgJb2MSho=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=YK09FWet;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76B7546406;
	Sat, 14 Nov 2026 07:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05241F000CB;
	Sat, 14 Nov 2026 07:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794641648;
	bh=0KoqRgmGRc0qs2TY2et1mN3EuDIIdXOqtoPQ8Z8M8aU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YK09FWetI+P5+mHhL0XQXoF2JIcNoGHXGHFtzuFx2vZYChk4b90Y2+oDMXqxA6wUH
	 bHKuL2jSUsxVX4RxjOBF5u8rjA4nDG8qldlzvqWTRSJLQLwBN6ynSTix7IXRf2Ji1z
	 HMJjLl2soPKSYj7tFcyb5xNtqG0xQpSlpeeizZ8urc6FfUOpVIFdu9NxD+SeJgtGzS
	 YNDxKYpwxrM+bh62Yj5ZFhltyppkBMxdPbybCEvox8UwtXJPKBt4a/XmqT1x7M9HGx
	 ER4P6a/ysW1ITFZnM3UYQcHCdk4AFpFJZR2giet/lesrp5XXzSqTa4Ryc5VN7DqLcc
	 rnDaiP3MbGl7A==
Message-ID: <sashiko-outbox-214264@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 20/22] PM: hibernate: size the image from common memory
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, linux-serial@vger.kernel.org, damon@lists.linux.dev, linux-cxl@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, xu.xin@linux.dev, chengming.zhou@linux.dev, joshua
 .hahnjy@
 gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <20261114070959.3490008-21-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-21-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 07:34:05 +0000
X-Stat-Signature: 93ztfo8htyofnzq69qognm3i3rw6koot
X-Rspam-User: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6976F20002
X-HE-Tag: 1794641649-350430
X-HE-Meta: U2FsdGVkX188xh90IppbXoEVUX1pJbSQ6M1gg2CkiylX+oGwr38I+txVP3VaSkyPtTpQBTLFQK0wrMIt3OxXsxwPnHaE9UzSX+ohRY16RmpIMKjE2ybkeqJbPk5CWulXhfmLPoMfKTXEYhFrP0Uj6gW4CuLcVt5QQS7ZT8c7r0KHCpbiD72Q+xK0d862oqU9M2aWyt3Yo+WXIBjrE6J8paxz3QJTQFKqB6NLtJ8ANXcurbEqga1s7l90NvFCHKZW3XQJzLZlWh8AO20eMlZE83JWhmr636fVnqm4MM9mW9SE4A7dRp1wMlki9oLSeGCnsaYxQIYrR/c+ircDoIxcHe87RA5eJSNz92FfbK4xGkey8fUpNm0TMpMu7AIVExW5msPGmCxcpvP07SRmmUqHw3UbtdvyLHGFrpFUy8nRVS1dIZ6Ll8fiAT+fXQaqMb3GM8yUdlgIzsm2Wzq6mNw0UCBAgGyQ2B6/yDjOtiBPHo/cFxNbpQF1C5k8oljNSb3MkbaIn4XAD127JIIqt6ut1ELLG9lyztVU+a80t4JJDeq7BQqlngRjmXM5W2dLJMKda7cViSejJgTmCLH5YcHLsgNJ/tAroTzWkHtBCrGLyaBoIvW2rz3rn3ZOxCL1DOkhFwrPWJvR9XFbcqtHn7ZWZgDFLkHa1jI32T3NB30oSYsF31YrTUV/TBZ0OKbFSt2vBxn8OxrDSdXR7b63LMODkUgQrlNHVesD81Y1M/+43KKnwMvLy5w9Cchlls41sTnBSHYIevowaE5iJ5JOzittWzSIo5mLyzCcbOG3WQn70WD2r7KI4mFUpaW3VxCUyjhaWCUq6k2uxXrphaC03sDwh3itP5996kbSpX8UNfNCM4Adu5VA8+yL8ISF9303OKSDkbsRtIUMPO8b8+jCauMcZtwp0Citce0HUHqhkl0ovGbFHIlE2l0swBrz6AND92I2KPTNGAR2J7Ju/YYQ9H/
 6ADvT0Yz
 8qXKLH/HOLLzQmT2vwy7sjmMDfKL2m3fDKTR7N891U7s2mHbkJC6hp3jpu8PBzbLBxJU32aiYdDXTq4crXT/Onynr5a9XvmBkmeIINPsu9jkaK8jhlWmfBHdnppMDG2xVv6DIcUn8P+p75cOq9X3OZ6pGof5HNxN3JcMXAUk/Uskjgs+VdgQ7/iGKVS1preYS4hxmz8jA1JILCIjNiKlEWt7hYnefSSFjLWPEJnMUT2wnfmH6SazHE+kNMsbmn5gPoErVF6U8Rdu2U1hOc3D5gT0rdaTvj25tO89oZggTllYYq91R/QNpUTWF9bIjnyFys3VI6RJtOiOpzkbnr6hb13dEZddzQUfhxIhv5kdProP4nsbozF4oi4+6BmyvG538Kqk6pk+vZ66tDba7shw4SiMgvzf+Ac49l5me0BiU6DRYoLWQg3f4L5ukRtlqu0pYZTl5hbfHaNyA8hvFRzSKKakWv7l5lrwTYfcxmHHRrC1vyoC4L6tVBW5khqMttB29HqfPeAFbPzz4gf8BhcCZGdmOvmQnXMjNxSqvYMoVM7OifeciWt5wi6nNTg8UqsOOXOhv6Aa2oz68pE9s58s1s1ZDUT48zPYRiU/p0Eu0kfd/IwcMxB+xcIwLyGYe28dCKiyAmB0B8ka3Qm/W+fbhefToE3i4g4j9pQoOn+cxyWAiSm6xtJUrBNNXM4qKED8mWXyzc1ZsgQqa5xBUcvz+NiiUgg/PYtPlyZ17NlTHMu7mOKReFPOEvM4SZ8qpFOf6WXlqbAm0mFmnce+KHQPHkA695R181bwCvni7QTwXBeDhYRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] PM: hibernate: count_free_highmem_pages() ignores
  N_MEMORY_COMMON
--

commit 7cc6e673516327174024379e9585052d08c1578f
Author: Gregory Price (Meta) <gourry@gourry.net>

PM: hibernate: size the image from common memory

This commit restricts free page accounting in hibernate_preallocate_memory()
and enough_free_mem() to zones on N_MEMORY_COMMON nodes while keeping the
metadata estimate across all populated zones.

> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index d5dba0e50b2eb..8aeb086a3fd3d 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c

[ ... ]

> @@ -2011,9 +2013,10 @@ static int enough_free_mem(unsigned int nr_pages, =
unsigned int nr_highmem)
>  	struct zone *zone;
>  	unsigned int free =3D alloc_normal;
> =20
> -	for_each_populated_zone(zone)
> +	for_each_populated_zone_state(zone, N_MEMORY_COMMON) {
>  		if (!is_highmem(zone))
>  			free +=3D zone_page_state(zone, NR_FREE_PAGES);
> +	}
> =20
>  	nr_pages +=3D count_pages_for_highmem(nr_highmem);
>  	pr_debug("Normal pages needed: %u + %u, available pages: %u\n",

[Severity: Medium]
Should count_free_highmem_pages() also iterate over N_MEMORY_COMMON zones?

On CONFIG_HIGHMEM systems, enough_free_mem() calls count_pages_for_highmem(=
),
which calls count_free_highmem_pages():

kernel/power/snapshot.c:count_free_highmem_pages() {
	struct zone *zone;
	unsigned int cnt =3D 0;

	for_each_populated_zone(zone)
		if (is_highmem(zone))
			cnt +=3D zone_page_state(zone, NR_FREE_PAGES);

	return cnt;
}

Because count_free_highmem_pages() still sums all populated zones,
enough_free_mem() continues to count free highmem pages on non-common nodes=
 as
available room for the image, undercounting the normal pages needed to back
highmem copies.

In addition, alloc_highmem_pages() and prepare_highmem_image() use
count_free_highmem_pages() to bound loops that call alloc_image_page() or
alloc_page() with __GFP_HIGHMEM and pass the returned page directly to
page_to_pfn() or swsusp_page_is_free() without a NULL check, which can
dereference NULL when highmem on N_MEMORY_COMMON nodes is exhausted while
non-common nodes still have free highmem pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114070959.3490=
008-1-gourry@gourry.net?part=3D20

