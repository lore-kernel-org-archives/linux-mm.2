Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F41CCD190
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 18:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0DE8E0140; Tue, 14 Oct 2025 14:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51978E0090; Tue, 14 Oct 2025 14:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E6F8E0140; Tue, 14 Oct 2025 14:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7FE38E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:25:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A5C747890
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:25:47 +0000 (UTC)
X-FDA: 83997548334.30.01DA26A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CED9D160013
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:25:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E2AyN+Ce;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760466345; a=rsa-sha256;
	cv=none;
	b=LggUmIaMRRwIm0abcyxQlxH+hGtbx8dY2ZNkUAxFVEcOYKKUZJPUF6spJZRW+uy75AbdJ4
	qFnti5UFSkFbTn57rGcFVFmxgQYV+87EO/LFx22bM4Tbk6d+uvVg2rPVds49bNAtlECfog
	0JBQ+L4pZhLQN0Y2a4fzKfTjBKa3pBw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E2AyN+Ce;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760466345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32n1d2otLM7Q0/zmoqqDj9sZxbmafRtI842WNuwOZAc=;
	b=JKhxZA4+b3HMGkcE+9Hjy/3xAcRikfZMt33q2T00w/j8al4FmLpv65cYecfUZkNMmLP6Wi
	wziKnWc/vJn+RKHNfPhkQ+wVvwFCiVKd6yHtaBpTU641x3NNAUhts6LOVyzeAeML/m00G/
	3dOO4YaPlK3xn8kuxG+pNK95SAooAlQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43D36623B7;
	Tue, 14 Oct 2025 18:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA96C4CEFE;
	Tue, 14 Oct 2025 18:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760466344;
	bh=Y9Tu1SuK1U50HGeWWFYQ+9vjydcCGD17mbmw+C/L+jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2AyN+CehSRvFD/j7+72y7eCCx5KD9lOnW44xvaH8EcNmnjIwBBM5Iex5eJKgoJJF
	 aV675fWSmz8FYbykCkaVNnXbCCrhsGyw8HYiGYFiAc9aXZPKySyRpq/QWzRjC7AqOu
	 OtJze5iSOjj+BC38p54cQxWMmR0/pbfmngU0Fy8EfjjzKEfgHmL1XGrxm44+8VOppI
	 lx6FEMTXDf7w59st2U6h0c5fiaaIUE7flkXphoS6fhA4Oin4a7K1BknfGcBrXmwZDp
	 +UwgJ+gPwEZ7033tWzkzYfUT0cyfa8bJ9qmxk57G89vFXFX92eCsyFDMDDWxGdtn8v
	 p8AR5OGYabQXA==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/core: fix potential memory leak by cleaning ops_filter in damon_destroy_scheme
Date: Tue, 14 Oct 2025 11:25:38 -0700
Message-ID: <20251014182539.50115-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251014084225.313313-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8d79zon1f9uet8qz9my9zpysuyawhnym
X-Rspamd-Queue-Id: CED9D160013
X-Rspamd-Server: rspam09
X-HE-Tag: 1760466345-846287
X-HE-Meta: U2FsdGVkX1/e+QTCuWX3pO/DKaBREFT9/0Vq/hQIbS4dyKWZSuVFFTbEoF6QxzXUBTmq1DDq2n6jRxORqRGPinpO+IQN2GN2JZVMxnOGREGdyal4rXOx00MyxG6jH90YPn2v0xFpgNZ/By0etMSaGaRuSl5Q/I0XJ0dTryvW6xokrC73dS8dfv2nKg3LE7uuSh27gtFOBZTX10kArl3E8pfM7q/qK8MoBjk/x0IgR36fSZ89l4ik7v+umCbzBzmdi41cuaVyuSspkykt0DUOqsETJ8MkEKq75CxrNtKDgmVh1FxWvIuHPjws7sVs7w7kTVuR/7fSVFd4CQkixXnE9ZUAsVhOaU/hGgJqDedqurEV+wwEkMkxjK9HR+gYCTN54ZsAuk3xmKp4MamOcr1r4FmuOegHHSFE9keS3RLWY8xXJsnsKSXNBGXLvSKamSxEwfG2IUK7wAB73U6zKMtTT8SYvskYfx6wm4iPg+g/jLREbHgDLuhzYtdacO61QFVmnbhcSL1O5j9+ZsSN7z7rMwf1vo8Pq8YGWGAygLCsAEaR06T1wE+Mmo518hPP98I1mASU0qw9soU7GKDGt68gXwTJ6YPtBJVwZzUrnetEPjb7itHujf4ntovRlhD5BEGjMPMwC3va2buYruIRDw9awJ1+5dS2vpc4LmCeZWw2SBO8B08uoXF++DpyU7YD6iJ3StohO7afjdcC/GlV+IXg19Cq1toDYuzY1M1MA5ygmQ22zpohek3cl+2cs9n31zozo7DNR0qpCQhOY7AsaC6hYZ7sGNs9LoVX0B5kddPk3bK5eytnN0dTHyVpN1QV3GdyC4Po/EyqGKEefE21LipvqghmIH3ByysOOcPhKbZMJgqLmLykybhqaWYSTuiyaXhrZ8FA2Pqrzi7nyjvWsAnXKHywFBvElpcu5uqbn9etIdy80evjanKyiTC2T/UZAyDDfmwtlJcgVjejeYookSG
 AWjg+iX0
 4p+pwzAW+c4HKD4Xt6oOXYsluL4ollKmhxQ8QZjg9xNTvdi9XeSbwCv1TYU5SX3MmK83gtfraHq5F2jcsT16BU1y0Mn5ayaIVp1BRJCa1ocYyy4XQKx/N6XZf7SM0uSv23iGQ7zyE0rg1bWbsSs8+CGSZmYoEhOO2NwHLnwMPy3GtbVG89fI1WHrXUUr42GHtZzjWosx+ZhNfzj/bc3r+HaXzWf5tLFrLGWKir58baCgT+hb5NjIP99YkGCjGzD2c5/KyHI6p2rgdkR2BMCiylcd4s/bGLfvSFyhFhuV9RFkHH8E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 16:42:25 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Currently, damon_destroy_scheme() only cleans up the filter list but
> leaves ops_filter untouched, which could lead to memory leaks when
> a scheme is destroyed.
> 
> This patch ensures both filter and ops_filter are properly freed in
> damon_destroy_scheme(), preventing potential memory leaks.

Thank you for fixing this!

FYI the leak is not only potential but can easily be reproduced using the ops
damos filters.  For example, I was able to reproduce it using DAMON user-space
tool (damo), like below.

    $ sudo ./damo start
    $ sudo ./damo report access --snapshot_damos_filter allow anon

After the above steps I confirmed it leaks the memory using kmemleak.

> 
> Fixes: ab82e57981d0 ("mm/damon/core: introduce damos->ops_filters")
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

