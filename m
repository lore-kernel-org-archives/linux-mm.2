Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C341C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 16:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888D06B009C; Sun, 10 Aug 2025 12:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A0A6B00B9; Sun, 10 Aug 2025 12:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74FE96B00BA; Sun, 10 Aug 2025 12:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64EB76B00B9
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:37:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E48311404FC
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:37:37 +0000 (UTC)
X-FDA: 83761403754.21.5A548F5
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 502FAC0008
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:37:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FVIfroHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754843856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KraWhm+vMxr+K6uoezhzXiMyXcF2A3lwNDRkmnOc47w=;
	b=MxMHzwD6/+zE85m81el4sHemip6hOqCUG1VdEH4vmGKe4dFH9bTaZB6D4pV1aFE0U/bVfO
	pnQ2rNC8wMV8oz9y5hD5zmJYG8hx8qWu+FSugXC0EfaEmShvaHBIKN7JL/ixkh4WmR3dQJ
	8lm76/g4V8pJDEyLnYsIoC82CrDzleA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754843856; a=rsa-sha256;
	cv=none;
	b=ppb4uRLSR//8OWCIdW2Scr+2NvVqX6Pu5XjzMC3lXQ/yK+DzPmU7qg7jO2iKQu4VefHwx6
	kGKNgDmJEdDeL+PaPBVMshox8FyjGvoIvK7nuLPBfd4hLj4US0ZTjPo6QvaKfj6pXa/8OZ
	XzB9261g1XIMNX7q3TY9aeR+qaqMp3Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FVIfroHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3591F5C43AA;
	Sun, 10 Aug 2025 16:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F58C4CEEB;
	Sun, 10 Aug 2025 16:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754843854;
	bh=mU1CU6QSs1t+ZnPN5+7CkO8QO1LKiTJxVkyoIEy/7DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVIfroHMubMtqvBRBUD1Q+6yobVn31zakpY8QNNodPCB/8XjGjKL835sRY4waCrrr
	 q0rr6VT9V8Gzh1UMUNuoBP6HKF1OmWyjEp+Csb/cXnD2+fB6bR9t2ufD6t84EpBeju
	 HiKe6SJ7xBC0HFXTTpQzjLlQIeHCV++zWwddomokddZiJnGCIm4zK0M/nIqRbgAE9a
	 57Hz+2qNjrnoEUi+SSBLq4XjHeMKB1xLlYmT5TQlDB4wwAG//HdMQOZtRScS9w8uIL
	 P1K7f8diiZ65c3NcRhuS5xgUztipEmQFwrHf9/3PdBRuU7qa8TEd/rrhqGB3FJm5Ec
	 TYQLafZ4buYOw==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] mm/damon/core: fix commit_ops_filters by using correct nth function
Date: Sun, 10 Aug 2025 09:37:32 -0700
Message-Id: <20250810163732.45668-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810124201.15743-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 502FAC0008
X-Stat-Signature: e68qwwgkgcb7wza6pok1poxkyrgfbd91
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754843856-732760
X-HE-Meta: U2FsdGVkX195ZXXdudC3qLn8nV/DWJpOMjUUuGP8Li6ao+ZWXr9JGdSDEjuNQfBfDLe7jnH4WC+tkaCFNwlxiwk6IygdIWnborDlJf8EzxdImrx7ykIgby55I/Nj19rOPo6oNyPqGICZH79oua9lbFtVVImXs7IG0PB3FpHU+BjEs13Swxi1gtvtFF+sOdhPU/0uq5fSgs3JI4XrvW72Xv8RMojWbaHzj29HdfdenNBY6j/WMo4LGXeXTyLgirMrrYI98yf6xu9R3iHNwCkOERlmD9xwCE8RKLpSqyNsPmQbsAHatVM2t3xWKBHfjCypGrMBSH4vHvKwX6d6QQW2DOpmsn/jcVL3/DVefgsvKWQ8trG/hJpjGgQYRQx2Pf0QjJ0r+xfgoGJMPEj+3LbiKEMokiBUb4QD0UHEEsuqBMdj4J/Ec2mbplEPIG9HttnTyo9BUEgu04dkxLJSjBcH1R8K/nhDCThx4A1ZOo7q8UIfOiJdnETWxiwep8o9RsFIcI0spdQQcF5SUoBWyuJ8vvhkCNUFPTWuwfMiTErHZQyPU+AgC266Wz8J6VznZ0E8wzisfQnQRaGontCS45y4eWTAqZJBvQWEEEcQld1TWUbAcjLOQqMJmEvj8/Yb0DnTD54VhbJLY6O0gMBMBhNwFeA8BF1xoONclX+C60K9cxszc5h8LoGmdDqVA7jR3QPO9G0LxJaTc0a6bPrmiMYpWJtnS4NYPV4TqRuchVNp1HNuHyna6sD2TwzuQRMPpBEEsbdilcBVUr8fCJQyLL0Byqjzlk51UeUYAbVc5vdywZzXZOcpsyj2lOvOqk8YlyitzwIYid4kpfCB9EQ9vbiPwbvIXKMxY9LuIIm7kFwvFWoTT8IA4cIlWqyo8t7ElMEqSAulbERkAwguOmM3LHU/nPJJZ1Y79iLFUl6xSVw0blNo0ZuXjQAKJ4pUJP0v2xKVMbZ/NQfO2XbSkhCrBkG
 YWkzJ7gD
 gos4CJ80vibidmbFkADHpYPkBJOMxvWtq2guTkxtX8FM8YfEGX4t3m+2ZhEkNDkz/34xD2uJ7QPdsXCEl9QFd6XAqBj7/w+5y3n9mhHPfRWBiiTVIrjgg8MfBHvoI/xjX3r5IcqlWCgOJby/1atCGOeKbtE8QQ5CnFY1hWu5Njh2ukAlPb0nNmTIWR0wlT2o2db+yhO/Ds2XFWQJLr+C6FJGQuFgDxVYWZV7GWyS6ocaoEhOTAv4UeN3g99pYnXqJioaGgKQn9b/9DazdHhnkjsxdwttZew62/isHRw8YOb+Ibyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Sun, 10 Aug 2025 21:42:01 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
> iterates core_filters. As a result, performing a commit unintentionally
> corrupts ops_filters.
> 
> Add damos_nth_ops_filter() which iterates ops_filters. Use this function
> to fix issues caused by wrong iteration.
> 
> Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6.15.x
> Cc: stable@vger.kernel.org
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

