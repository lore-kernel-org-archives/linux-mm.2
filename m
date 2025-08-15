Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E954FCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851338E0201; Fri, 15 Aug 2025 13:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828D48E0001; Fri, 15 Aug 2025 13:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766268E0201; Fri, 15 Aug 2025 13:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6678E8E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:25:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB0F0C022E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:25:50 +0000 (UTC)
X-FDA: 83779669260.01.DC6F80B
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5EA3C8000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:25:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=No3wDu4e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755278749; a=rsa-sha256;
	cv=none;
	b=ZwbdvSnmyE1MlriEmGij5P1u/5G9b2mPhTOpcpU+cuYarmeJRyl7IFFu8rRfaZJ8a9Baav
	BtprKYO+d16iaPiKi/odhnvO/SWgyaeWfSWsOh+CKRssUrb6SkCBkWkyTgc+ev1TIpWVho
	y4VdR6sO6pt2XtquQ1GcDj9Lrj+enGA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=No3wDu4e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755278749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Teoc+h8qYLAZ5KToY9BYDt2OYVpuat9QJRUQLmkvJ8=;
	b=jXKiyQwDxgbu2ksUuUZ8Ft5oLh9YGTf/yjCsspTD+GwRlQk0Huvps/MnjN7CVTFxjXRVtY
	sO4qAytvMZ8YcBBKxwHJwSLCztDglAms+3yTy+TFQbQ9S9AoK/Q+eP87nODBFnjNqsoczD
	ZGGU7/LisjE1Oien/ENQ5WgfIMC94YM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id B61D2A5833B;
	Fri, 15 Aug 2025 17:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B03CC4CEF1;
	Fri, 15 Aug 2025 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755278748;
	bh=msGWC1/RAZgteUgYi93sQRCDJCKwtZbfv2QzEL6uo3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No3wDu4ePfXF5qKNrBOEU0BcU6rHhpqx3CuOPn6mEUvyoonDg5qO2qEgRwWrADzK9
	 bsGYwaGn6VRDZQ/pdz8fG+qA8TLawAIezHHabhToPbksyUaIpUycHwSNrJA24nLrRm
	 7GWsCcW0XAywWvn+YECqFp0b87RtjAQL25LRAq1R8gQjStkuQ/HUOk+zWlpd0H4fdJ
	 28iYdihGrMfdsnOs4BicidthVZCVbiRMYocpDhUJtnzaH0SlmRfULaA7KMcydWk2jO
	 +8JkZi+biZ+aKvgSuSFsMUct+QeenvfogVW58tqTsGUGEJMLTdGeyf5lchWIkPuuCU
	 t1Z+f3lVVQNAQ==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stablee@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: fix damos_commit_filter not changing allow
Date: Fri, 15 Aug 2025 10:25:45 -0700
Message-Id: <20250815172545.16704-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250815094059.133769-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EA3C8000F
X-Stat-Signature: wcxou5yhusrjik5sijq3iherx14hiyiq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755278749-680899
X-HE-Meta: U2FsdGVkX1+pkIP8naSL6Zer+sBJXNrU4i6/dLoDcOGPkoKGiifVZXdqHzmcgf0tYNcfC7gJtzcC/fYNjT5SvoldF4ckYBmT+YPD2dxxLxWU/TFLzwQklAuX2tanTviIKaS4w8KItXIEgcsqDGrN6XDL14XOrBZwG/Y9wc0oCKnDsPGFdyNrn0ZYHpGmhWlYVo2Qa38uN7kbRkkEQMFYBfh+9Q+vOW2Xdk6wgsV+cGxe2cvAI/aE9glDfSxOfYEfDlfI88R9mD9FORvU83MuXSrdZmtmtkDm6EUHHo7iIer7FPeBZ6Ml/tVHjW5qA82fTq5yoh7sTy5kaQwByQCh0ze1d7RE04ZbZZBfTC7ZtQ9uBSaZcnIxIc4fjJcN8EnIGMdHSbUAFsNP9L/k7EAsAmP2Bbo/BIydGqv9lKwDRXJTc7PevTqouKn+oz99SQicXlLkPrXpLmcvKSpm1LPfwoHMXznr/0CHGqMvHGMViuHXwAMgqqxp6+EQ3YdmrJ5g4oTiIDmN+Mhl4QAuuz4nwdtLLn3e4h9P4bfGJ5BZEtMHRO+09KmGz69tfs+i4Pu5reBNpraMgYgcGP019gUaSJy0wM4C4Tc/gmWZ3OBd9Th60qbAGa+W0AQG0NXjk2wb84TMZ2PXsbHulnpp0jifYzkFwCX8smzf4zDe4ntMy4gcMwcL79Mo6KiE8bdBqwMgiOkdB2TTUSdlDGXfxvNjlJEgB70t0nblnNibgc0ocE0wAinjivf/FhxRT9Xj/c9dPNmK2xFXz27gHK9Xzq1Pby/yj2JEtiP1/DqeK3b6yoQ+tcTDCSeJYHTdFUyTrzJXiSp9qiTLywNDb/MYtbYkRlKXryYcHN4/jXLRE2+g8nDR7yKS0NVnXI2/3zzBHDSr6rj5tqNF6B9PSRDyuMCOEVWJpFUAiRHt+mncVBN0LD5MFIY3XFlmTdAWv8H352B/aF0ezumlHC5A9l6y0T7
 G++jeQi1
 WpU9c3F10w127kUt2v9pDaaaFZKfOiqs7m/lBcS91TWgCo44FKlidKO6xoVny97uftRu8z2gvptb+yvtf3ewtaUZVsKcPdecrQ3fug9teKiUTfk7hQjplNtuHXf3ZuwGZKcjLLbTbLhJm37rWCQ+DVgjN2p4WpLiMj46GGESDfz32BhDQb2IRX5sCYaLBvD/WMz9FnSBaCdMxWnlAqfqua3h9n+TakhHTkk5QiHmLRNRQv54oLZBIf64Ym23m7gtJv4iXd/93fT3Iiu4ZpjvZqaW7J1EtQGcm14BUm1V7K/tgW2c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 18:40:59 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Current damos_commit_filter() not persist allow value of filter. As a
> result, changing allow value of filter and commit doesn't change
> allow value.
> 
> Add the missing allow value update, so commit filter now persist changing
> allow value well.

Thank you for finding and fixing this!

> 
> Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")

At the time of the commit, damos_filter->allow didn't exist.  I think below is
more correct.

Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")

Also,

Cc: stablee@vger.kernel.org # 6.14.x

> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> While fixing kselftest, I found another bug and succeeded in
> reproducing. I think this patch is similar with previeous patch [1].
> Also instead of sending patch with test, should we check which is better:
> a seperate patch or patchset?

Separate patches are better for me.

I'm not sure how you will make the test, but I'd usggest making the test as a
kunit test.

Please refer to mm/damon/tets/core-kunit.h file.


Thanks,
SJ

[...]

