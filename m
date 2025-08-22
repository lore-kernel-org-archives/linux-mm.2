Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC015CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056A18E00C9; Fri, 22 Aug 2025 14:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007A08E009D; Fri, 22 Aug 2025 14:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86C78E00C9; Fri, 22 Aug 2025 14:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D80CD8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:03:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94DF4B62B6
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:03:27 +0000 (UTC)
X-FDA: 83805165654.18.6D03264
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1D0F4000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:03:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdmUi0Li;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755885805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSn/5EMhJ+t7Xb8g+d9lI6Cl0/CdI1WQwxt5WWd9YOk=;
	b=ieZ1781CJQ5dLss0RZqVrN/kmfRSmLd7cnSFnq1GqB0k7zinrIFuTZb3BSfwhvxcWlXDFN
	cgUew79QMmiJ9VwNN2OPWPZ6WX+oFD11Tda5+sSf13poqgTb8k4iWeU+M6hCARDgBtRc0Q
	pqC77akGlCtYvLXOJFVRXDH19pkj8Q0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755885805; a=rsa-sha256;
	cv=none;
	b=MuBBc/cQmp4TGTS6RHxEdTC6jftzIvMoBzhkkID7n5w9+fO0GHZPlB1+rdyx1xtjHXJ8SF
	nR9YNDfUvwT6xitApKpDP2Se1nRVgNt7jxFWEv1lBSUzYSMahGZGTFoVLV37tuQqPD4h73
	ns6yCB2Ps+STlJM7vFmnF3/xbFxMSFE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdmUi0Li;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 078AB5C696A;
	Fri, 22 Aug 2025 18:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D5CC4CEED;
	Fri, 22 Aug 2025 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755885804;
	bh=xob6THafiHnjeYW4E4LIe3j9rn0C9XUlMt5gpe6z5/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdmUi0Li249VOCRkvixm0n00rznR0YOsJAhfyJyKsxqa6NvT4NhEEOINaUF1FgsS2
	 01Lm/3DlKaPNnM/gpCaVC2P8P0HtxM3j3ptDNwZDtAEz2sJU1XtVtXQkJTsxlXaRxh
	 J7+9zufeGr8y6p4o/kUkj8RxqOX17SQVxV/8IeVA3AIht+5uYfqt+izS3HoCIEbx5u
	 IeSM7TSpAOq9mj1PdkX+suNwV8d+G1f12J/eaYuMz0JynAEs5YL58sObGL7grteSH6
	 t9vwSUySwXvl357WauwptuZ4nWPqgy6UUxwUh+6I9BoYzX7ZYCp5JHVNjfUXrpGea5
	 AzkM9LhPIGe4g==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 11/11] mm/damon: add damon_ctx->min_region
Date: Fri, 22 Aug 2025 11:03:22 -0700
Message-Id: <20250822180322.47842-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <8b3f1571-6510-453f-96d4-f365eb10d02d@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1D0F4000F
X-Stat-Signature: y8umz51yzx59xb69ka4syjra3mraee5u
X-HE-Tag: 1755885805-582278
X-HE-Meta: U2FsdGVkX1/mTNor5omL8gQ12Xxhjf5CGuEnrL8yjWyzTfmqgYGjHAoyaa/8E6VxDYNEAH5UNf2nC/9jX39ec02NJs3jbAplQxy3joxKixkH/wfyE+K0wQ7cxREbFSG0LxNcbJzSW6OZsAgWwjdWc3c62bSUcD+hYie0F3WSW22FNcZHAdB8l/hbOeEqpUnybV+4iu3LKWHkb8jDpe4G37FK8mZo4WrztkpcolrfXRcWAk3VAPxX4Nody3gmmNubg7PBRrL17sPFHkCZGFApiDq/mvv2Bx6C0grJ26b8Nt86IE+A516sHQ/gibpTyv+RKEMF0k8ny1JGM3gGsxlXCXWM1gj2v5fD8E7lTHxJj16cqYCeAgzkdoECcVnyUfFtunKO/pqPOyWxKXoxtaEbWQH992BJSas7KMAmM3kJ9PtEHNNzo6cDwHKTu0Ig1yxPyfKC7o9Uyp4JQsuTvxizzRIwrSd0NJVhLGOdo5afmBWLD59TQPHJEJIdULk92VHzA6K3oVRc2sFr3RsMl3wdFh84AIJP7hzPvRaxiTwWcnkAOWkOvkXgi0EA7YSLjIt0O4uNgK9+Qgo2UxIsjYUsFNU09BOS9VqjUuPeoDExOHyThmCVXxqNn1nDK79bQgveASqMdhcajNbsEzvhlZO6WtkfdwOjI2uNt48MxtbLMp1dnD8En494613L1ST+b2E296Rbjg0snsmHHMxIDPTOQsZh5NyXAdQTkbimpGfw/LXjsldCXf/zIdp6nHS8ID1dOurWwbcML3VAwBLH0043YP1Du6u1ccpwJHdlvjaZF2iilbXP9O521cJUwKL0r++IxGBKNNv9tVscZniTtNMKvpcN80QGSkeF/VzN0E3tQlA8QfvvudK5c5Vom892DB5of06dyedYf12aAj1VYqVrVOLQys9KcrytkOitr0OQgOcDMpcvFFLMJ0yvYJ6hN/te92oTxAEUvID2DtIcK5d
 YvTT1hMB
 mqSuctXmcF7fP4Nc6WZja3XUOerM6QUMkLD6LD7++wPl+8bVrso/C7NBtXc+bOGkVmkXTfKad1SUkgpFyCPTfpowyErk8m/Sk4CjBcbvLKoZ2RYqGmEa3znu9aUuOG+xnBvWFBgkpRfNE3l08FnrO2e+wwiMSi+tJ+Jh55X6Z8Zbzik/RGvRnqZsvYXNWprMI4riUYErklAlfH8mlNSAIGvlOtluq2UFVLl8bys5vAL9gkF/KhExKGOC8flC6crLdhyrvg2pUiuE4DLpY/D6YEV508mr6APGVpdxHTqIZyez8MQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 09:29:04 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> 
> 在 2025/8/22 1:33, SeongJae Park 写道:
> > On Thu, 21 Aug 2025 18:51:59 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> >
> >> Adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096'
> >> bytes and cause data alignment issues[1].
> >>
> >> Add damon_ctx->min_region to change DAMON_MIN_REGION from a global
> > s/min_region/min_sz_region/ ?
> >
> >> macro value to per-context variable.
> >>
> >> [1] https://lore.kernel.org/all/527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com
> >>
> >> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> >> ---
> >>   include/linux/damon.h        |  4 ++-
> >>   mm/damon/core.c              | 67 ++++++++++++++++++++----------------
> >>   mm/damon/sysfs.c             |  8 +++--
> >>   mm/damon/tests/core-kunit.h  | 21 ++++++-----
> >>   mm/damon/tests/vaddr-kunit.h |  2 +-
> >>   mm/damon/vaddr.c             |  2 +-
> >>   6 files changed, 61 insertions(+), 43 deletions(-)
> > [...]
> >> @@ -1248,6 +1253,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> >>   	}
> >>   	dst->ops = src->ops;
> >>   	dst->addr_unit = src->addr_unit;
> >> +	dst->min_sz_region = max(DAMON_MIN_REGION / src->addr_unit, 1);
> > Can't we set this as src->min_sz_region?
> >
> > I asked a same question[1] to the previous version but seems it was missed.
> 
> I apologize for the issues caused by my misunderstanding and carelessness.
> I will make adjustments and release the v2 version as soon as possible, and I
> will not make similar mistakes again in the future.

No worry, we all miss someething sometimes ;) I confirmed your change on v2.
Thank you for correctly making the change.


Thanks,
SJ

[...]

