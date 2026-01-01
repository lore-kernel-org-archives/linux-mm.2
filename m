Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC165EEB573
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 00:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ECAC6B0088; Wed, 31 Dec 2025 19:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4196B0089; Wed, 31 Dec 2025 19:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE536B008A; Wed, 31 Dec 2025 19:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 77B0F6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 19:32:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 233251610A3
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 00:32:34 +0000 (UTC)
X-FDA: 84281519028.20.2CC2F11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 84D5B1C000F
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 00:32:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XhPVW7U5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767227552; a=rsa-sha256;
	cv=none;
	b=5FkIuyA/ypE8quciO4RmXdIRUZv2e8jJcE3QIK8ZuFtoD9949j5Ox6pa9Sb62jSx1GxrGb
	o/qAN7gb6xNIh7MJzUdwWTZbx61T9zQ7ocTPnUT5e5I/h4tom/FLcaB/uMGztGeivfErbc
	taPElWLOnpNDCIJfq4huaGly+Mwa9Xw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XhPVW7U5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767227552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRomEK3kjB+pnBQNLzXqjNrBdNot9jiUPb+g8avNilI=;
	b=MNZetEg6Uz5fGf3SXaUFAhIROm952e8TcZ2a+0SEwB7c6vNhjC/fgRJ4/C8l1gkyE5TMIk
	Mz4BlnRatDdGNEW/g1Z18He4OvTWCGWaJ+zTiMaGeTRTqvpQC5MV1hj/H0zHoPU0LDtRWG
	DEp3GBQ2oXvyIdzPaMzZogmTp39pdxM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B358C60008;
	Thu,  1 Jan 2026 00:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56CBC113D0;
	Thu,  1 Jan 2026 00:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767227551;
	bh=k8MuGUV6krS1djDhkLddMbuWQjOZXzq/iMN57+HfM8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhPVW7U5XZOD+IsSMMuKz4Zc9IrWo90xQkGrMVtJeIQF4yXv+IWZQPQCRAI+GZ6Jv
	 NSaxHLzKEjdiB3lx3o4YT/1XlEyUt2cSzPPlB64uIcOuvuZEQfM0UoUmvkY66msLht
	 DZrm3YNe2UH3RK5lcXZkHWMpkVR3STPSTuHQx9Brmo+5Um0QGyfLL30wyhn4+Uvbnu
	 LHPX9InCYpIhkUq+WFTdyxc688vrvFxncRe4+mKfN5hiG1S3PmQGDmIMsSFQMdfgPf
	 KEUqGgclXIg4O2gF4wjrio0F3gdeNC8egLMDFTVB2KyQA3hK4kAntCIxNc1B7PIxx9
	 2rJRkXKKBe+BQ==
From: SeongJae Park <sj@kernel.org>
To: Pavel Butsykin <pbutsykin@cloudlinux.com>
Cc: SeongJae Park <sj@kernel.org>,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
Date: Wed, 31 Dec 2025 16:32:26 -0800
Message-ID: <20260101003227.84507-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251231074638.2564302-1-pbutsykin@cloudlinux.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 84D5B1C000F
X-Stat-Signature: j3kewcxttctzc1r3gy4in3esco7ydfzk
X-HE-Tag: 1767227552-953714
X-HE-Meta: U2FsdGVkX1/uiHzPKXA3rMbTPbhOkpl+zoNBfsydmkjy/NL1/nRmYd/JczW12QjaLPYdeKXaGL17X0ke4mNdvD95JBJRGaiuKA091sWOlgkTY0hzIWBX6TF3RR+mMReXPPDvAm2OxGaEvwLWyBqqdhFmK/Fmrwp1RUmAQR5OFn9mnUzjq3Fw45mlIREoWZFSdzKR8AZRAeW9C0+IhfXnvkx2J0RQ56OaIMym37fYW2P80ypR3MZYxNaO8lhGW5pMnzRgUD5GuSeX3q4AhfMdNDaGc9vIBVmcUo4RQRiHvOnV6w5pRMDk9JXKtpAQFOgtgMaZeUIPNzx3S4gD1Lc2yFPgtkcudgZlabVtQMVahvxc3oMv4dvOqcFVPAusVM4Bl/UIgQ/Rlfi1TAIAJ6CBqSB8bAONTIaUMtHTkvn84Klhfo0Yze5M0lhSCcmT4xSol0o5S4DRKycXlh+CaWO1NxNNf11g5ucZb/lNqADZeubw2f7142la+42ilbI9mrqv9HLLTKKE9tn3hm/7z+dzdLt+p1zqk2J/KFEgvUjlBJP+N4/BdTMGrPoIoO0vizj6zqIcCuxGljwL1W9kPffpCYxoRzRxmBw6RTN/upWiabxGlBMpIMyasGawnlSk3aCkAXtH9p6BJ6i2lYO2M1K9ua5Vq8yxAvdHn9uKtHkyqb45iMavDCu5mKeQUpIUQwpl2/opB8oQWjDeYP6v/AfJ6zzXSud2+u/vX50fx6PxRzUDQz6K07bpo2HLI6tSP74tVua93HST9uQvBkXoYFuZohd437V62TZSciBKMe/f58dbZZh3bdn4ZTZ8iY5jQZlPvZTiBjk3BtLPRPiq84dA9obtZEoie3NF7ATrEg7AfrW7Wbz07amD5dD7wk/K8jPq6YTjLe47l6iJPAWCCDu/X3W34GCws6bsUGRSjynAKqkWDe9ILfiEEuK34xXVbWN1zVNSxfffGj7ZKP62sKJ
 pNIQp52J
 AKuaXVMcRlRaDV2yN5QtVCoVyDyTinoC7xVwShMY4Pl7QN4ZlhPLBvGAXdlsYBm24Eheemz1NfFF5RdvGgbOt7+lsdJ8vMI11bN/2M/6xjX1cYIw18AigjEVUPUobKsEiCabadq3YZQKx6yhFSgfW5AWlZYcMVMjfUHWXo5TPPNJNndiJPMWorDpJy1zwP3jMm8J9fOyS/ia7QVHcHnw/TSHRkDlzjBIuyC8hKKMuJoY483o6wenOC75ycz/5vXrjQ8o3o/l15vo502UFILHu9iPopuov5kgHD745xxVXcPseK99KQLM1hZF/HAZpMiYAAOindxKok2L77+3XDImx7i9orQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 11:46:38 +0400 Pavel Butsykin <pbutsykin@cloudlinux.com> wrote:

> crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
> only for NULL and can pass an error pointer to crypto_free_acomp().
> Use IS_ERR_OR_NULL() to only free valid acomp instances.
> 
> Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside the lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>
> ---
>  mm/zswap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..ac9b7a60736b 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -787,7 +787,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	return 0;
>  
>  fail:
> -	if (acomp)
> +	if (!IS_ERR_OR_NULL(acomp))
>  		crypto_free_acomp(acomp);
>  	kfree(buffer);
>  	return ret;

I understand you are keeping NULL case to keep the old behavior.  But, seems
the case cannot happen to me for following reasons.

First of all, the old NULL check was only for crypto_alloc_acomp_node()
failure.  But crypto_alloc_acomp_node() seems not returning NULL, to by breif
look of the code.  And the failure check of crypto_alloc_acomp_node() is
actually doing only IS_ERR() check.

So, it seems IS_ERR() here is enough.  Or, if I missed a case that
crypto_alloc_acomp_node() returns NULL, the above crypto_alloc_acomp_node()
failure check should be updated to use IS_ERR_OR_NULL()?


Thanks,
SJ

[...]

