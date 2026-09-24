Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3894C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B8D6B0095; Thu, 24 Sep 2026 04:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72346B0098; Thu, 24 Sep 2026 04:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE426B0099; Thu, 24 Sep 2026 04:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9917F6B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:39:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27C13120262
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:39:18 +0000 (UTC)
X-FDA: 85248006396.17.73F586F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A41A2120008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:39:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJaLWzWo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DUq4tGaO0XgV7gLkA9KRgzuKApXd4+gn0m0gS9k1Cj8=;
	b=tndb8aMY+Cm3h5Jx24tqDqNPfyLYa6gKGz1/N/4fX0yZy+P//2dTux1ezjIONuGlmzXaO/
	vXjfub2p2o/l+VDlJ2g++e7jRoTu1V3RdDQSkCcygmpsUJiWt/UG3eRa6KUNY2qagPwIEH
	Rrvkat9rp8tjSnWx5FjA8jRRdGzpV+8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJaLWzWo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239156;
	b=K8/HI0AilfkBinHqfia0Hh8v7yj8IqzhLyINQRoxeJmTZVYzhhqGBzOp+9j616t4yPlVjr
	26bjXMrMIuBgXKcMrwHEzQJOetjdh9dgwTvd66424XxlIn+xhsyUD+GkctuXsBthk7TMMg
	vurmQHj4XDbm5CiF204CFbDJgnli7w8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D025140A5F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74DA1F000FF;
	Thu, 24 Sep 2026 08:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790239155;
	bh=DUq4tGaO0XgV7gLkA9KRgzuKApXd4+gn0m0gS9k1Cj8=;
	h=From:To:Cc:Subject:Date;
	b=GJaLWzWol9L0JtsIAb+i5Wc041CkEFDHTJ7tOdZO46kJeT1AkJ1tHegF210T+K9f5
	 ONNmIm7qTs2zNKKFWlk4tYJfRO6iV5B5tm5gzGJ0aFNWFrQ/GrGerCJbqWecLd9tfO
	 HqeMrW/J/gU8NQENyXDj/EYMcJghq+OoZETdT48c8gvdGLKOn+hrnn6MDQadc+mA9m
	 NGyuJiAEEMk23fQwhZwnD8NjRvaPnJ1p6dEZqwnjZ43m/sRtNd+PSBwCvo5xk6k/cN
	 rnwsfdxQMey6+EHiXwGpmXXI7shytME+SDNrU70CLuCkuY4hiTUY0LleO+to7ktWrZ
	 M6G854jyyDCEg==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-09-28
Date: Thu, 24 Sep 2026 01:39:11 -0700
Message-ID: <20260924083912.3464-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uts8cbx1f54p64qkijd37jsyy5715gok
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A41A2120008
X-HE-Tag: 1790239156-358509
X-HE-Meta: U2FsdGVkX1/4MaeUKC8WC9QXXIueXVoeBUWSBnqwrHNKYSTgf4SELEezyMiaCX0UHPxjJJKOnfxQq1PnGzl92qhBPtGzw25fTlLuf8+rmSB2jcv3vGuyyc/nMfloUaPQMU1oWhEx4Rr7lA8RlqnrdugBebpiUsZ3QT7xRUyhOhChwgxPyt9HiinYdj2WhDF9P4LAvU6BmgTohCGwBii9Otk9EVa37ApapRGZL/9wC02nUszXfQTHqOSmYVQn9uFcP41+FlvHOSS2/2rmEuDaqqjLR0gZwsfAnJFxSNaYzoC7nOmMOaqYWhZiXM8EfRZ7W0gVYZBbUB94QFvpKtYGFoapWnAfGbdZcmQ335k50ArxO+mFQzxgs4MQqlCFLNunlQKPIIZ3fJZEi7r1TAUyiFPpLEs59WtamPXh+CQFhQpqoT/cehowPhYEo2T256J26HCfFaNj00k/p7d71rKPOBebrN2a5CMhFWfInLevn9miNkqx6uCHjVf+wJWuaCUNhMHxRuXZsBRiDoZJlp8hIKIlCDRsV2ySc4y0ra8hVrWWcPDhvR13OPk3ZDS9Y1/kLgLRq2X7qFbWibxh49rTkW3DzEy5Q3a9RxWjfrrL+LLn626/f92pX1qyQKRc2nUN2kxk/4DWAp/IsAlB4eFpdEs3BGX5jjEPDyX7BRgG169XBDBmxlsfG2OABK2cQ3rWOTY7VmscYmV1fq7Lu92MB7acuYEbEm+x3pnZy76Vqpzp7KYjDXAkAF7cHUnDUWzd7Wh2d9zWAEH8U5NImn6ElPegkFIy/HW/xoCFQbZK0G5bwO5IlLHrWIjd9wMGXqq4q4DMLra7gEPquvTfKaHb8I6S9WnIs6xhgVHv2C647SCABt9s+ZznMwMc4LWMdLftoeB7jCJ8pdQINmbB4R2ogQUfRPw5pofLtTX5WNRnvZlFtjzdRph2uy7AM8ZaAgbHfudv9K9Q4V3nnbj6fW0
 RSSRG0/Z
 DPQ0/Ff70YT2pFUVo0G+B7QGCResY1at+/v1ces58iXtP/HKNSIKcFWUJUNZqT8ZaPTsP2/ugKHuno/Atj2gyasf7wBlMAHYOXhr5NaCINk2WxZDLHNBc5NWI4AjGKGsYboZpLLW8wqU4YogiPtStdAmAqmCEftVRa+SNJqvvrvxCa5R0HmvE3EDah6egWrKCMk8KDQWxDDgdgrMVhlWROn3CCU+/9WmTJXsX/zZhv++8DHcHr4xIwCozKZgmooQ2hOBLAbIsXO+HOXPyngtGz4TqNK4ZP49rXYJ+NuaNapB4malHCqLDQNt2mMoutzT6YSJk40B2FnkR+GKYo/+Yx+WU5Xto5raE2BtS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-09-28.

As usual, we have two time slots for meetings in the week.  The slot for
Tuesday is already reserved, though.  I will also be in Europe in the week of
2026-09-28.  Changing the time to CEST.  Next six time slots are as below.

2026-09-28 (Mon) 18:00 CEST (not yet reserved)
2026-09-29 (Tue) 09:30 CEST (not yet reserved)
2026-10-12 (Mon) 18:00 PT (not yet reserved)
2026-10-13 (Tue) 09:30 PT (not yet reserved)
2026-10-26 (Mon) 18:00 PT (not yet reserved)
2026-10-27 (Tue) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t


Thanks,
SJ

