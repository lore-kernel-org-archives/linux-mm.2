Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6E3BCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02F68E000E; Thu, 25 Sep 2025 05:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9F78E0001; Thu, 25 Sep 2025 05:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D180E8E000E; Thu, 25 Sep 2025 05:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C26498E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:36:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 788731A03F2
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:36:58 +0000 (UTC)
X-FDA: 83927268516.09.631937E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9F5F140011
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:36:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNS63t1Y;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758793016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iU/8C3bgykcpIT0EMohp1A76R0smAaapZClkufQQk0Y=;
	b=UxOlToNOpgENUwN7Mt0HnEt2Q8k2KJqoVxLPxslypkZspsxXNYdJLZ7ur3FCJGMCYv51SH
	C42mSGa02ciSCs725tj1wQDfshpaQqzPeSjfYzSJyPLs0echYBr278dAcMCE1rdzhUVH7e
	GY0YfxH2Q1v7aGMhOvoAFt5t+Ig53Qo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758793016; a=rsa-sha256;
	cv=none;
	b=U9gln+6iyuxXAoC3H4c/ZVcMOsLAb80RrehILnxUPbjbDst6qGlC6yzoh/yDWjvy+RB1jf
	FkRonC572zm4fUWap5YIpf2FqZ3Pl3HGESZxurbhywCMd4HRoFPnt+8Y2KyYsXroQQlY1J
	8KRx9zg3zArjMTM+BQrdBoQ/BaGvYvY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNS63t1Y;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCBCF44C97;
	Thu, 25 Sep 2025 09:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6028FC4CEF0;
	Thu, 25 Sep 2025 09:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758793015;
	bh=cs/L+0FILav66EYCnGQ2S40EG8qSxOGdJiC2KVHCzWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KNS63t1YVh7qWaG9Mk5Zip6SaVXM184O6Qb2KV9EMskZBqPPNfZqUFaosPgubxI18
	 LsQkBDCtSVyx3pKh33fZtIqyy12Ylj1u4PkXwoZ13XS7W8A2O8hAbcQkgnLAOOWWDS
	 V50+hLErC1yQn0xrCei7L9bUlOtJLem7eOc27U/dgZNnkINcCBklSIByRyGkBDviIA
	 ZBORN1BW1GZhZAr2sA44EmknpdQE0QJSuQ7TMFjLIgo1/4NQlHPlgk+ipdL/JPGt0w
	 kBcA0MSKyXA3ud22LA7rGP5/i3c2K+dQuXuqtjkZ+VaTEL0JaJYwFLOzkEiTxeXDwl
	 gb7mZHKeW8Vow==
Date: Thu, 25 Sep 2025 12:36:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH 0/2] drivers/base/node: fold node register and unregister
 functions
Message-ID: <aNUNLlyy2Kj5VsGX@kernel.org>
References: <cover.1758736423.git.donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1758736423.git.donettom@linux.ibm.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9F5F140011
X-Stat-Signature: jcfyebu5863zz791ice7wdmxinf91hr1
X-Rspam-User: 
X-HE-Tag: 1758793016-669302
X-HE-Meta: U2FsdGVkX18CRyYAfixrb9tgfKwonbxXwJD5voxyib2s3v1/oyEEjjW5bnlEDxFYRLHFbbRD53u3Ftl10Y6li6QJfp5Cav9diq1XXjNQEfxhGHqgm/X1Wj6wRdk7xoj7rPS7dQgXfJAnqqBFEiRymgaZpui+s/YWtG+b28Ui/wXSZs1ALkXGX5Of9LXs1RRFD5arn3gXk/FvbG1MMwID8kXQnvS9bHOA8HOIXTZ2unMilllCOhpb6Y++WUmxL4VkQaoGzjSPYnCjOD6RkR5Dl0Xjxp9SlZolylWT/B4TvJMTcUeK2rxzGE8W3uD4G6cDSKqPCCMo1+LTXHXVQuXEIftyTVulo9xI3HENpCr+BWW681Fbr1H1aZwyBafkdhsc2Qtu8hb2Jqk+jsc2sOCxN1U1ibwmWcai4tRHL5QDsS3DNRrZwGWgXsru/4dVfTrduH32gERtTFwJ67v9nfX+6zi4AxVZsN3/SknqWN3PdJ/LKtyoE6eR8lkakLWArp0q5msRb8cxGF2sh4uGMOCb/Rm29LoHSRkwhKc5MrljjbcAbuDlwmVdDzDYXrk2GAM2IDVxlJdEOE7/IOSvZVnz3+TF1ITj8BTaYmqgj5B0aErOvdnUy3cDfgoM2QWyQqcDX/kUzT4dz18jU4KytFW4CRFSnDlZwJqH94PEKc77fuJjU7jE7ft/cqjBOfqW39L9l7qrtXTmKngT161bmsXwHWFNxD8MvUKEFmvz7C+TufjlnWAdd91MfgUBdITqX4Kmj0I98PkMoAtj7o2W8I7xnfu7lo1uXusGs+NPcSyajiSJERUubmopwTNwvFmXet1JAgHVed8BNU6yHuQG7uUN0xpOzJf0yW3JujmzqWYjb+H2lgbf8PozCaKU51DAt02Rf35ftYiltgNxb0iniPBRs1wsTFgVmH5myTPIRo73FSD50C6vTvZP6NHbzlkvC8/ZtZ8RjUOfzBnKkG0v4In
 3ItUx7V7
 83D9qZvVvxzXQ6awMY2yhbQLlo4tvalTR+REbbrJXMWmJYwWoU7WsaebJPyFBg3/vevrbk0EIHZ7HHH4xdpXXaxNNIOtxbDEZocHrnHpD8vv9UqaxbkKS1rm+quFJgHuBCVLvrU56v2HLzIJpx27FljdjtcowTr868pTUvJdx/TqgBiTXYunph062aOwtennjaiMWrtOfqojFMKzxVnMjeX8/ua8ewyak9dKJ+0v5oPZREOjdmMprBT0eT/2mC9FXdmyB44+IKQjDsnUjFsT3CmAhrwJ3LzMAScQy+Pd3Y247ygPXk0TrgOSabhwyENrKU6xHW+lMdihc8+NSPTEQ1Bw92sWSVC0tacdWaPe+JRalUjAL4XbNqM4Erw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 12:10:49AM +0530, Donet Tom wrote:
> This change came from the discussion in [1]. It consists of two patches:
> 
> The first patch merges register_one_node() and register_node(), leaving a
> single register_node() function.
> 
> The second patch merges unregister_one_node() and unregister_node(), leaving
> a single unregister_node() function.
> 
> There is no functional change in these patches.
> 
> [1] https://lore.kernel.org/all/5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com/
> 
> Donet Tom (2):
>   drivers/base/node: merge register_one_node() and register_node() to a
>     single function.
>   drivers/base/node: merge unregister_one_node() and unregister_node()
>     to a single function.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  arch/powerpc/platforms/pseries/pci_dlpar.c |  2 +-
>  arch/x86/mm/numa.c                         |  4 +-
>  drivers/base/node.c                        | 89 +++++++++-------------
>  include/linux/node.h                       | 10 +--
>  mm/memory_hotplug.c                        |  8 +-
>  mm/mm_init.c                               |  2 +-
>  6 files changed, 49 insertions(+), 66 deletions(-)
> 
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

