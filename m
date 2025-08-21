Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6564FCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17798E0016; Thu, 21 Aug 2025 13:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6CF8E0001; Thu, 21 Aug 2025 13:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03E28E0016; Thu, 21 Aug 2025 13:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E77B8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:18:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41FE7C04D7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:18:33 +0000 (UTC)
X-FDA: 83801423706.12.2C65972
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7A8F40012
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:18:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MUT8jbA+;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755796711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwv1MpnsZBGA/aVHhVSZAJUgfKITpN27WyPKMqoJz/g=;
	b=JCO2NMYkQyYzsLvhxi81NyXpnXQ9AcR87NsWvKXbk0ARguCrdn2hU+CUE1Rn2X9BASsaNK
	Y4QSoRvCD5TpJND/8iTbJdX+8xnp8rZLGPZXj7oFlkixRkI5CdVoFfC0tvuNXFgKiFCBqd
	VDGAc2EBl7+SNXrRmPbC0HO3IX4+d88=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MUT8jbA+;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755796711; a=rsa-sha256;
	cv=none;
	b=1JZZqP70ViPxGQv14T83FXBnUSEqUvCjIHmirXwAYEjfMbayFbS3w0dfECBcuN4BPzDeZi
	t3+uTzkYAfRRtMtquxAZU4iQa+ONChAG1QP9yLU0Bdl5PegS9hcVhnmbpqMdk3fY5NsRsR
	lIwZDZFPxagqwc0yCAaXc0B8ElQphew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EAB6601F8;
	Thu, 21 Aug 2025 17:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48C9C4CEEB;
	Thu, 21 Aug 2025 17:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796710;
	bh=GmBT5KRpg58kaKAnaoXx0aJiwi9SIUnxrOyht6yCL7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUT8jbA+133Fd8JH5x0vCeXig1RV+9vpZgVO8PkkgxrE9zj++RHvnTvro1KqLsKtD
	 WCn4Fi5ZiHhnRTMbevTS2MFB6QrAIdF3hOE0vs/n5OmTnOmmIaNsYsj5daUy0DS+KZ
	 BqWm7BCcHo4NfF6olWackzf5BkY/tXke4qfTCTl/5cQsV7J0Un0Ny2W5opt9h2XBms
	 dAXWdT+gSA++3A9kozufV3io5VNKbuItoCqhyzF/XhiHndp6aNXEgzQTEweYjIcfZN
	 Q9pB1E1YIHl+0yd47Vph5kPrAysWQ+R/8iPI5Xz617FNXGM6IfOButiohATQvnEidn
	 5xCjkFto1k46Q==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 05/11] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Thu, 21 Aug 2025 10:18:28 -0700
Message-Id: <20250821171828.81974-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-6-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mtxrhpne7s9a11fxp7uogksbtkwj35k9
X-Rspam-User: 
X-Rspamd-Queue-Id: B7A8F40012
X-Rspamd-Server: rspam01
X-HE-Tag: 1755796711-228592
X-HE-Meta: U2FsdGVkX19SIegEtDwU4p2mbccHPrlcketNB2dx4ma0syIwNE/YhNaFbgRO1QTNZVwoVHtq1rei3irhE6yKgY+vRWUmyytpnJ2yHc8wd6ZdeLywiBDAfHRZnuPoAl1nBdMXzTVTjH+waUpRNvDbWy9Dch7qmySR4tEiQdZW2Ej/Fjwhe0HADTK70rFA6UsNvkWEvsULLB6u51fUtiht9aJidFjzUzDdwO/zqAGdeou0facy2gJZ87tj1O9heFt0n/wjCyJdG474FHcMOdVwCbc05AQ4Tav7yhgI5RzBmedLS4iTPDl7xjxkTBeZE29LDnP52Laf7mu4lMegcZ7vux6f88MqzL1z8Pjh57XlsCbOSnSVjG+BYPLdl3t3C43Nfs96I78vUk5dv8L7+CVrFh6+HmkvDiEq+nYSaiY4tlIlnMOcIgh3RXE45+CVAm0kV15jKq4Sbw/FzGLt+zoEFBU8ZG/UZsvMV+613nqAbTzR5pOZtQJtzw2nfzaP/933qmjQVradJceyy6zT5JSY4N9wFijg0qz8RBJTZ7mJyJxrEpPK0/E9bXdfix7kzs1k4VH5KHKNa36BoKAJublxBLpHFImUnjMPKYIUqU3SBurEpaTbhKmYShE2++wWppUxndR7WjXIvVZTXWn2WTeWSq7omnSi0LtEEv6i2sN09TBiYoTc0Mnly4W3PQ6QzJt37BXJcF9B/uKZ0AR1jELa6tp+cZEWN2g5EzT36C5E2Gu3MD6s/QuXdBjRaC0fuHnW9/f0Fs0NHrTMuGn1IVyM1bLIVJxl5+xTKFkrNR5p9V4hjk0K4GGdE6zq/m4tDg3VvGoF4MEPlN0rYdobd+lJMPMcLwih5i9jv3aamwZ6rTMHjVKamfLCtAonHpzcM6HtEB2l/nUB2M/W8ZZVFrV3h5fiZwfNlhWarAGx+dLO2GRiykvQJqcB4yer5NMT90QRxPGPIZkyyAMrK8Zro/3
 wcrrzOvc
 QFjFGUHQuniOw1OEKZIL76dygam5AWYObTy4Fb+XXp5s5CPZ+wOjaD0h+2QpHcfrZEtp1npFIWvngjrdbKw06wb7T6anwmSwXcaa/4DHtj+KeJf3XBEeNJnSUwogh6Dg45Ade+b10p52T3dn75PPxAwnyxFY8xol3ujbbl0ZPNhLRjtyOWfxAHrDjy7KDtfEJfyBkw+Bp2JlzDy911kHimAJJvN3r32GfKalOWAf37a0JJNYzGk8pExmpwwVPhNkk6xV/L0PCrtkqfasoCWxPmOpR3I6KuWWGKQ45AsufWt78EFld2NPBE813gVos4t8LUiXGJiuHS0C0zXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:53 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_MIGRATE_HOT and DAMOS_MIGRATE_COLD
> action handling from the DAMOS operation implementation for the physical
> address space.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

