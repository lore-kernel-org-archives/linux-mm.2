Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC11BF8E4A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 04:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1C66B0005; Fri, 17 Apr 2026 00:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262246B0089; Fri, 17 Apr 2026 00:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A02C6B008A; Fri, 17 Apr 2026 00:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 097F56B0005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:37:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A42F813BFD2
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:37:12 +0000 (UTC)
X-FDA: 84666788304.04.F49CF11
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id DDB251C0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:37:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bVYKLgV5;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776400631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVyS+mQkhwP5a7tuOzG5TqsYQMmlG1hMkxkwX6WFouA=;
	b=PNibz7E6WuXeJQ37e1zOwtfrfAqX+cAOGlxLou1xpO3A5l+gTggJdR5/IIxQ4C1QyzRNX8
	gbf5aohcQMHmkoNYQkg5xfSqYivW7eqvRL0aa/A6bNETwcuXdAU4hL7M1yBdFutpl7yG1o
	GSNWa4lDb2X6UG7CncU2fCXQ/G2QjYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776400631; a=rsa-sha256;
	cv=none;
	b=xJmm2oPfj/aQraYgK9D16xAdPo13yn0eVyfH/K3i2XMNxnhNWckrZDrap9ZvZ9sdhkfEkP
	xP/9Chsa/ymJEJznlACs5TImE008CvNzD9uUmK6XFm7Nx3MGK3+1rMsWdhrbiNNM6Ak9By
	2vecuO2DJAOxZmb8xlvjAr6j6zNUDtA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bVYKLgV5;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FC081E8D;
	Thu, 16 Apr 2026 21:37:04 -0700 (PDT)
Received: from [10.164.148.40] (MacBook-Pro.blr.arm.com [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9066C3F641;
	Thu, 16 Apr 2026 21:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776400630; bh=U+PvVVWTwBKNhQRSl1RUbETFIYWroVoewkV9BFEmcmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bVYKLgV5/Ibm/FJaEhb5pnZ8w2Cij/DsMFDF0lhu68SPQF/hwkDEWdVewd64H/axC
	 Y2QNAEJ2V5I016LZFd18ZvXPsefvLdpkaKPrxLsGSoH2l2uhXBHEVm5Wz7CTalmiOv
	 pC59srDHZKS5o9ypWvoFTVhdFZqo07pDAg6qydCM=
Message-ID: <1edbe2b8-2754-4995-baeb-6b9ecaf05137@arm.com>
Date: Fri, 17 Apr 2026 10:07:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
To: Mark Brown <broonie@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DDB251C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: exxfhy1ppxchsibkxgxdbj4fch4k55kp
X-Rspam-User: 
X-HE-Tag: 1776400630-187304
X-HE-Meta: U2FsdGVkX18Pezo8/RR38kMcQB9JhhuRDAxWBJGgDoMzdmr6t/Mf9Yocje/ORWx33K1kXLR3KI1NiQfT2HARVaFgT+/sjY9aULqUYof8oYdBjw1w4rnrNue/3P0iO7orHNr54dPOq6/oMHRm0Z6JSCYiisOQo28fK+MNXdzdLHJ+GzXvT8zS3g3Ko09Fcc/viESxuyrZNU722sG7kaALOhVZoCjXKja3nv7vh4pfdQ9bs9C5kNDFTINoi9WCQzzLl09ftyXpvSx4//M9QN55FwTf3G9LdpgxHRJg5ZLYktb1PJMvatY37e5VZ9R/Blls3eABT+RRIccLJEvnjTpIr/ODDk6O3oYC4A76NPhKuSyu8PhFM+KJmw00MCXR/MvFaOTOYkPCIZEOnQZUTT6/sXOQiOzNkmQcrdSkic42ADO7qO+tK01+Ihefbtu/d9V6MsAj2Vxw0M0gulUZbeoDzifKP7dRNvb9mK2c5yPCw2e6ngGsEVkJFRQOKHn5DSCjkYuG3P2FnNsCOSKzcxUf2CPZJ3+hWWGxBaZ+a2bwnJS0fFsgvx80Meui3aSTaGpe0peRtHPx49V6SNQ/MoqGP4AG+6MCqnvcInG8gRk+/nnoBiBxsp/ty4XYyIJfwpXEJwNr6obzK8mJoxfDWAlpK7Y34pOFUwG8TGCbtvAOYSIxdzqjala6/v9EY67wAmfKVMlrI9LOcw6J1IiMD51sa++iAp9FSVkLKO5DV/i8VnUD6LBCMHTFylXrXl+XYj5pg25Rz03pLbZXKZmcHDjgGloaOVTxZfXAkVWJp37tFS3Ghgk6O55Hwv3ceCmnimerEcyDvHQbFH75VMTIxZaVlMvcVipMVVol+p9S6SfT4LMa4/ILr2QfOPxVDYn5CVnPMGxNV3U4Fu7JhwS71E9BuAl1pAzIchzBQK6vs4QZxnkUEwyIOKELAJIPcrjG56lqVVU33FwpFXCe72T6uOE
 YnhxK9j3
 Jve41fHJOS1f0JY3pzdwfASVr7QmKDPAPgami9I9fyDQKFuPQMnS9ugjxqPDgVokk5sT52gPgjAQpv1ARpinmkBuPkOJ8FOiXHP4XjOgVdwalDQJNbxwOr/RZXqjcJp2qH6Rt3QWRiOb2mxT5dr/B55g6E+jRDYQn6I1xR/Y9BMT44wvy1vjfNvfZUZxtuRFTOSnU2HxbDU6CSwsntw3W1wvUu/+a9lCgdF39xAw6MSHAq+ojenEZeEs1Gc0QSn+GOkhwALEPER0DS6UY85dD6yIvSW42ImHykSU05iqdVkGioh6SQcr26fZrMLnQnNSwt5H5x44/JJ4xIeQIG45BxZkqnSCKjt1oPnTXh0s6YvXoXF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 17/04/26 12:10 am, Mark Brown wrote:
> Several of the mm selftests made use of /proc/pid/mem as part of their
> operation but we do not specify this in the config fragment for them, at
> least mkdirty and ksm_functional_tests have this requirement.
> 
> This has been working fine in practice since PROC_MEM_ALWAYS_FORCE was the
> default setting but commit 599bbba5a36f ("proc: make PROC_MEM_FORCE_PTRACE
> the Kconfig default") that is no longer the case, meaning that tests run
> on kernels built based on defconfigs have started having the new more
> restrictive default and failing. Add PROC_MEM_ALWAYS_FORCE to the config
> fragment for the mm selftests.
> 
> Thanks to Aishwarya TCV for spotting the issue and identifying the commit
> that introduced it.
> 
> Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  tools/testing/selftests/mm/config | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
> index 1dbe2b4558ab..06f78bd232e2 100644
> --- a/tools/testing/selftests/mm/config
> +++ b/tools/testing/selftests/mm/config
> @@ -13,3 +13,4 @@ CONFIG_PROFILING=y
>  CONFIG_UPROBES=y
>  CONFIG_MEMORY_FAILURE=y
>  CONFIG_HWPOISON_INJECT=m
> +CONFIG_PROC_MEM_ALWAYS_FORCE=y
> 
> ---
> base-commit: 599bbba5a36f6de57ab14c373c25881e2b5273f5
> change-id: 20260416-selftests-mm-proc-mem-always-force-5ce1b26022c2
> 
> Best regards,
> --  
> Mark Brown <broonie@kernel.org>
> 
> 


