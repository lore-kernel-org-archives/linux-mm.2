Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1559107BCE6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 21:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059336B0088; Fri, 13 Mar 2026 17:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007476B0089; Fri, 13 Mar 2026 17:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E556E6B008A; Fri, 13 Mar 2026 17:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D68DA6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:42:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AF86B80BC
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:42:36 +0000 (UTC)
X-FDA: 84542364312.21.1AC36A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 26531180010
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:42:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ALvhC6pU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773438155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xsgQUSXSIplWMiX9LrlrLoTFlMTiqaMsS1EyKe87iOs=;
	b=gUo2YE5v3kZSfZvn4hCx0X85YCXIIVvyMz1btgWJwKWqqWe3nPdM9+QwZ4gRF+JRRfE1pC
	MKbTpiI3IyRihPueeC4VIm1GTYY9TmgxKpTDNvOQuMEtU6GdPoqyiLaJAHF/qGMKzkQvfj
	2VAFvZUA1k30N9jk9dmCZSIBIAFlsXg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ALvhC6pU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773438155; a=rsa-sha256;
	cv=none;
	b=AO1bWPBu0DTut0cbIOnsisqHBgxAssyzo8T0K5BjVvfNCyQ5MU6D9vhOUsDttrxESTmOpZ
	5mE1r6EkSNMcFoypdoRCj6BIDog9N2f7dDuogU7qXIH370uTpDmqsHvoCfmHZtM2HdKXby
	gwbS5XSoFQYd2Bjm7ZIfqalhd91wlqA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B1AF60132
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 21:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D03C19421;
	Fri, 13 Mar 2026 21:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773438154;
	bh=mpFwuPeB7aWEz2OJJgracIYRDJUkWSizNiHYzWcBxec=;
	h=From:To:Cc:Subject:Date:From;
	b=ALvhC6pU/XG+nKM0JpP4HwaY8kCrjmlkVSqCYPmpCN/gJFjU2OMZBGamfvXs7XbUB
	 UmRJCCVIWFWA3BdQrW36pElsnXx+edFJu0+dB7hGv/jatR2wE0UrlokemmhZdlDPVM
	 L8VsYkC8L6caWvFafQoUN0PtFJzIT1mEiY+Okq2kVoYCtVYOp3QV6wSukwj13Ivjak
	 hi5I4iLWyK/bgjGPPpDjt1c09BgZ91ClyMbbL5F+fiK0bflTDrs3G49xB3bNWGd+1E
	 mY71hYNY7P5b3iiR7gdBY6oXIRQmUnCfQubdWmA6Bg2ZoXQlM2SmDwZwTK5B2jzZY8
	 8BvBzoBvZklfg==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-03-16
Date: Fri, 13 Mar 2026 14:42:31 -0700
Message-ID: <20260313214232.25099-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26531180010
X-Stat-Signature: nmuqe5rdo7f8fan47jkgx7dgcqsgfy9q
X-Rspam-User: 
X-HE-Tag: 1773438155-285842
X-HE-Meta: U2FsdGVkX19bPfc6hyerDJzJx6kmLPZOPeHpv5XtOk1GM9HO/amFcGixiDICVbcVY4fU2OsBrOUHdOJD8DRJlaiqsifrHQQ8k8sKOnW77/9ZuY6Ukb+eAnwD3r48NmaDCyoK1EeDNhOaeiGgfQGRjytyXQ6mAY5mFL+RQ0z3s0JeA1xLYk5Ij2eTiEoXvcOiOnhf0KtV+RnoIaH3aeg6ovIco4JVQ3pIdC/38XboUjzenkArok50rBiVVEtA/HTckmgCj8YyGZR9ZDBkqcl7Svo+f8748ZE/vs/mmgM7JRT8b+TBVlIBH0nrVtkas2seeCo4nkdBNq5vHA45jabxx3mF7McHwZV+WuTJN7Dr5iIQEPuf0FxmzVby2i9lyaX7MIReVMKPQnrWWI3OURDkI/Cpta4JwxeOJ5LV7C4Q/q33Ft28z6jBurlrkyqszeQadY56c1G/NXrrKcwIj4/0qquDummQdfQ0LNggGsGrvh31JVU5SS5f/ZX07BnCJpb8PCoFpg4dLbFYRFTudg6PWuKr10hKnrI0M6FiPshPZkjeX5DrrfGhyv1wYmqY7OUKgAVzlcqT/Zy/JiAkkhycwPVKO1FMtsG3atOT5M40jQUqDlpBtT81cP9fU4DF/fz3hw17LYPalJGde+HpyWL2L7ycstJ6mVBiV+GczC9FwsUwHzzQvULSau1PsqbOicC2Kk7t6ZCaUE9UyFD0284Eoy5tZuJbFkQChM0IIZaEE11SRFDH5chgYtWPjOntyJI7DzMKs+C5n2StUkE8zdB+jAiDIP8KvLhooZZjjOY3VMVP1PnYbp40yk3bodTnubkxSm3KU1GfCdwRJY+lJevA26IYP3I+SWqIRcw6z7L6F1bIECAoXWrz4iQY8oS3A0ZcAQlJDmAr/y/5BwBLt3Ab/SWH4/v9kmH7sqfowOCEuKpT1d5eUvDQkqJLmR4F0Ye8fxPEcPA7Rpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-03-16.

As usual, we have two time slots for meetings in the week.

Next time slots including six virtual-only ones are as below.

2026-03-16 (Mon) 18:00 PT (not yet reserved)
2026-03-18 (Wed) 09:30 PT (not yet reserved)
2026-03-30 (Mon) 18:00 PT (not yet reserved)
2026-04-01 (Wed) 09:30 PT (not yet reserved)
2026-04-13 (Mon) 18:00 PT (not yet reserved)
2026-04-15 (Wed) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t

You can also get the past and upcoming schedules via
https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

