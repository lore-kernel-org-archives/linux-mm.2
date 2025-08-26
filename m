Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86971CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAAB48E00ED; Tue, 26 Aug 2025 10:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B878E00EC; Tue, 26 Aug 2025 10:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A7C8E00ED; Tue, 26 Aug 2025 10:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE8F8E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:32:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 487F711705B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:32:13 +0000 (UTC)
X-FDA: 83819148546.21.6CD0880
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B30A80005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:32:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xkh6j6tt;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKV9Agi4trDg5M71XG2/sLBMohyjmiIWDlzn3TaJPe0=;
	b=uxj34GyDzsnDnmlfhOhxFYS9mr4fp4Mh1sysiXppcqIbCVWdNBOOETjGwrdcYr7B5qtdN0
	eK0rLRhGJAm2pEpjpBpL18oPdsIhehuxxjET/v1jJufHsTSOlGPUPB1oUVwORz7yPZncjl
	yr9ZurM2DuRHHaYd0udUvluQ+brv/H4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xkh6j6tt;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756218731; a=rsa-sha256;
	cv=none;
	b=YNX2XxsN4EBYmLqLP+E1EwJWIAToaN+hRf+pm/krCUCOYv/hs5wmDwDILj04JecdNAKp/z
	0b0Cu9H/jje2KwPI1eRJnIft8GSMaS+i9v6mPlA+YtLbyxK839soLVZyDKJysO//KsgczW
	y1eRx650YTODh4UD0vG8nn52e1SysSc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 151355C6221;
	Tue, 26 Aug 2025 14:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0D0C113D0;
	Tue, 26 Aug 2025 14:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756218728;
	bh=3MNa7Fhsof0AmMz3/3fenqH4aTbi96cqmH77qoqlapE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xkh6j6ttedgo6/EZhRJER6ZSlf+Etgzm8rUfceAnudpQ7/FVwQ8z8j+8FlE5SwOMT
	 sAeoHLRcN92EJf2pp9c4uylRJq5yYVwWUZFMuKpIE8q/pmbOetJ1WWkFDeza8QAMBF
	 Jp12+F4amyxmRLNkxHd0Ts5zl0jhb3aSlSiYW9E7lxKippW7unLhgeT3gKdXI8I1MI
	 VYawzcVOcrVrfmVADqYvZZ4GGzzYeMRPUSnRLfBSq4jXtrONikVaC6x3Bwlzhae9ms
	 L1PxNtZxlHLDPZ9ZvpZyqPqGUMQaNpheoEjt7iAlPt/7WLb9W/vB2iMm+GjEdin5oC
	 zjPYVZYLVmx+A==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH 1/2] mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
Date: Tue, 26 Aug 2025 07:32:04 -0700
Message-Id: <20250826143204.54098-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250826033653.1208227-2-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9B30A80005
X-Stat-Signature: jr5msh9aijyuggitw1kmgxs8fxiha9ee
X-Rspam-User: 
X-HE-Tag: 1756218731-846046
X-HE-Meta: U2FsdGVkX19AOsNs3S92D7f+IDcCMcUN2W2r4IjMMc81Lp5EcybfEJz1HyP4Yva+2YKgbMsR7+rVb9CwmQxsiEGOMc4ButPiEq4TZ5uymzCoZOFKYAI185jF2lvXnlMQpHq2l+o38ArPNBreSaPsB63FUSVfbZTLzmsxalPTSC4/h7GTGHwOMLAfquk5PexWiR5XYkANzx6YdxYrBiq6G36cfKTmxHhWZfQWnAU7WJhOV6YhkdyigiNSKCLoqDdcPgFjwezXe8tvDKeeGFOti7D6t42wrwn3BzShPg8JOIQPQuX1FabjUD2dreaJoqZi9zVAgXLzLZIoXxps63tCun+ryXwG7Uk12cJ7YxHkhv/Y48imzrVsfc/JWhS7W6+sGvLK7JBFpwpzUR90T8V3JFhA1OaSoa3/52bSd/PbtukfXB9P73QmYJMonrv9rfWPhXtmRTaz+jDtVfBGm2J03F/EY15sX8WbkCok40CA79Z9vosFMsXq3DSH2wf++R7FfiYvf526rKP7GATWrBWrRV4jPCQx1zHM79C1hkMq/BN77vIW9Ozn5k/l+w/AkU84dJMfu+wZVoSNGNVP+v/o89azEGeKsmf5ZZlQE4dSnZHmxTYyskE5VULGmbtZ9gD7ATl6IpKEnNkqswmmovbAd7AU0seGMcLMAPYBsJJNw5YcX3c4E7Ntcvaa8XkH+mGjtUAS+/QzagdbUDVayDy4VQwq0ZbnCgv8/rmEe2wryzKsfZ+U2AcLLihZiqMcPz91fnjiooRVoM+Ck8YW0bnx+Nv3fF1C9pZBgafJ97mKpmYtnQKARIy5S+qfCa4eUYSPDHXJE6DC3P2hcFUGQR25MNsubvG/DInEk5i2V11rd6pOH8fLAhI2lRHepEWD6M+J03SW2zKfM/x1K8WLH4lPRHEMVhSVcG1M+VNlqsx9y+/B9bATtHkxLAvUTmd7Q5eWi92JISbIV0Jh2X9k23v
 v2WF+c70
 tXtyuJMf8j3wspeKPDJuIFXrqTHM5Wqh4oKiwOB3tIpH7rsscd8Mi3WljHyQlT4I2EUHLnC6Xg33KdIQLOL63bTdF+DqE5DrLuNfo1AVa05nbh47Frmrt+69fOiQzEaFAomrQ22F9G3cycdJ0skO6gH+DT/e5Xrhh33DEfVc3aN+t3Z5FDDdefOTaARgKIG/7VY9mBILSTOqvX8U2KJ3vlsgMTh4Gruph9MR8j0+6M9M/j/WT9ptspeU9ei7IMDvbb4LJVUBtWEClmMm3i2n/rsqRoTpuwoBtqUPVkDJ6PgqoCw0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 11:36:52 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> During the calculation of 'hot_thres' and 'cold_thres', either
> 'sample_interval' or 'aggr_interval' is used as the divisor,
> which may lead to division-by-zero errors. Fix it by directly
> returning -EINVAL when such a case occurs. Additionally, since
> 'aggr_interval' is already required to be set no smaller than
> 'sample_interval' in damon_set_attrs(), only the case where
> 'sample_interval' is zero needs to be checked.

Nice catch and fix!

> 
> Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")

Let's add Cc: stable@

> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

