Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98245CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 00:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D959000E3; Wed, 13 Aug 2025 20:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016F1900088; Wed, 13 Aug 2025 20:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20F49000E3; Wed, 13 Aug 2025 20:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD678900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:57:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DDB31604BB
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:57:44 +0000 (UTC)
X-FDA: 83773550448.09.295B7CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id AC3C91A0006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:57:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MOcl/GGf";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755133062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9rPM1F4Bmpk8+Y8IZxAqyCeXh6yO7JggUuOCKIZCqc=;
	b=FQ0G6Y/1RzeeEohXRH8O57AqMs8u/z2DT8cPdrByKG8Tjfk+u2IhYx7IaXswG3/kfcxp1P
	+36+7zVHzUM3rJyl9ay+XklHrAAbJeZ2akNK1BgT1+k7ai7q+I48gcbop9/QPf4zNbPXnr
	Cp65J1TouhXOmD0OOkO/NQc6pnQnoco=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MOcl/GGf";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755133062; a=rsa-sha256;
	cv=none;
	b=JSZoP3gJrPx/mrPffu8pmjRyBvr1Q1J6xxf9/EsOeAlnCaZCgz7X5pBvnNi9XGxdGNziZ3
	orRFqMcjGgqVFFDwXSc55Skq6mRwtyl0t4IBgkzotNk5Nbw2/3nTskt/t+iZ1PZFEMcHLN
	0WbH9mX/lP9vV3bCOeW3iP8HnMmeSTE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFA86601EE;
	Thu, 14 Aug 2025 00:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EE4C4CEED;
	Thu, 14 Aug 2025 00:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755133061;
	bh=153zhUSGq/KWvkkdlqL7wLh94pOu0kTwnsKJAuOqD14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOcl/GGfHB4GpoAi6OiNe1lLxxd54T5fSjtzKKYyxnjje7GHL0MsHp/TYCJAB1XG+
	 QrZULcM+dWWj8pjXjiFwjTwmz4rfV/Duu4mrxP2+zauPGCN7TvrsK8iDYMynrGDYX9
	 wQ8vbSH4TFObnopKdvw/XE3rAaZ1N4cY0z53bdK+lpDtHbD6L5T4kyxEmqxJzXK9Cw
	 agUIel/yCiDCoa/nskdheQjzD74m8i+MUS3oRbwInZby0C8WFzTcm4/AgUDmrWUQ8M
	 6doSFc7I0n2F2gCu5r3CVbaBdxJW78ojMSsHtj/cCwoCFfZfMI8VF5GbHx+sZhVVEq
	 YEk2OQR/xJ70Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 00/16] mm/damon: support ARM32 with LPAE
Date: Wed, 13 Aug 2025 17:57:38 -0700
Message-Id: <20250814005738.52844-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813172545.6637-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC3C91A0006
X-Rspam-User: 
X-Stat-Signature: yq4uionuun3nf11519pabh7hpnwctbuf
X-Rspamd-Server: rspam09
X-HE-Tag: 1755133062-113453
X-HE-Meta: U2FsdGVkX1/ueUsf3pHNfyr3xlIN4FXOc6t5HKxM/u1X0nwvvG8LbC2pGbUYUUBNHG2D08z9WzfWk63juuyDNdPZOWZY9qRA69rHd7gnXlIgPz7ZmYRTvKdh22d+qlOIO/qg+64/fS7qvfga6K7bxQTOda1td4qfEncTvWOW+5m6gGPu2ByPUJVz/nrUIqX5wpF1nuUMiyyzXqW7ZduHCbRSxuVW31z9gZDCfZozxmbhaLWd9hyqkZfBNP94fj6TDePERGJ6ed7oaoeqdVlDQPBvSxS7eeuA0f7kSwr09kAtjXSDwDEQZSTN1ssGI0aSEZOwq8Xeo38MpW09/UCCQcTL0l1lPjQqUI3J3G/S4g/iD2brZxmtNdrhstPd0B9PlACQw28KdPONBandKdQbXMrFwFa3jA6FljgYG3FrTqwGynmXptZNF/BjBsxBOtRJ0vX3d+5jApnGxywefp6GtvsPb0OiH/2akfQyZZRDRBB7LJvwtLALHwiRvXuVv1C5cgRDyDBd6C5kJqi9SF216rZZnPQFeenY7c1RGWfnxajdGFUvZ6WDhHdb/Otk8pd6Pw91eQzdGOIE+d07NCviSjSxK8H22VmSVMK8UTdHMtpMDBj0iSE1Y+HR+V5JZ1QZCemL6S/PFq8G2erz/LSQ+m7N9spPjd74YGSdC1AjWlgMRqmDPTdA5XD9vQ2rgKsLQgMAZVFUnRKH8obVvm639F5qiLY+uXzna/WFj8nhEom5hR/IwQNIzfktKS2zv1BlqglDaNDq56ELqlyi/CLYzY7RURUOCtju6NHPEX1Atpf80nb+aTNlKNAOYe1aj/RSfPwyPW9LdSaW5Ov+lZZYvsj0e1JkbP0J6sqQRBFn4kWs2PwkGizB5RBd7oRwKKmjle3ADLoFwY+x8heqoHXwb0GiNy4cEo7cUSTm5QopRbK0yEwUaW2Axl3rMknXm8KJX7o+vLvibSlsBOLoIGC
 de0sReEu
 Fjxjp0uOH3voNX5urZS82da7hwAiwDrskMmoDoPN16NejIQ+sQkPs7XHqBr7Bp8gqWyNtgLHr/lCI0+uVHuxyOiUAsna9cIGiI5iuDvJVAg+jECX7Velw0OtPcxkarzlQf2n9CglpfcPdIzz5PM1Fqrjf84uZGmkk7qhk7mDAeQw2M+z7SVRgFATw0Ve8CJdfKQtAmd+ysH+yXoOVN2e981GEZI+8fusehfsTFiElDuv21mA/7hGM5LI1nJMI++23PV0B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 10:25:44 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hello Quanmin,
> 
> On Wed, 13 Aug 2025 13:06:50 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> 
> > Previously, DAMON's physical address space monitoring only supported
> > memory ranges below 4GB on LPAE-enabled systems. This was due to
> > the use of 'unsigned long' in 'struct damon_addr_range', which is
> > 32-bit on ARM32 even with LPAE enabled.
> > 
> > Implements DAMON compatibility for ARM32 with LPAE enabled.
> 
> Thank you for working on this, Quanmin!
> 
> > 
> > Patches 01/16 through 10/16 are from the mailing list[1], add a new core
> > layer parameter called 'addr_unit'. Operations set layer can translate a
> > core layer address to the real address by multiplying the parameter value
> > to the core layer address.
> > 
> > Patches 11/16 through 14/16 extend and complement patches 01~10, addressing
> > various issues introduced by the addr_unit implementation.
> > 
> > Patches 15/16 and 16/16 complete native DAMON support for 32-bit systems.
> 
> Overall, looks good to me.  I have a few change requests including below major
> ones, though.
> 
> First, let's squash patches for fixing problems made with patches 1-10 into
> patches 1-10.  If you don't mind, I will post RFC v2 of those so that you can
> pick into your series.
> 
> Second, let's keep DAMOS stats in 'unsigned long' type.  This require fixups of
> patches 1-10.  If you don't mind, I will also do this in RFC v2 of those.

Instead of posting completely new RFC v2 of the ten patches, I think posting
fixup patches as replies to this thread might be a better approach.  I will
make fixups first, see what looks easier for working together with you, and
either post entirely new version of the patch series, or send individual fixups
as replies to each patch of this thread.

And one more questions.  What is the baseline if this series?  I cannot simply
apply these patches on mm-unstable or mm-new.  It would be nice if you could
share a git tree having these patches fully applied, since 'cherry-pick' is
easier than 'am' for me.


Thanks,
SJ

[...]

