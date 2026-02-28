Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB11AFEE4EE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 17:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2D86B0005; Sat, 28 Feb 2026 12:42:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9CB6B0088; Sat, 28 Feb 2026 12:42:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A85D6B0089; Sat, 28 Feb 2026 12:42:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 853D46B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 12:42:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2743B1601D4
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:42:19 +0000 (UTC)
X-FDA: 84494584398.10.1C11787
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 911F04000E
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:42:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UhIVkNU2;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772300537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kXc7JQYGYlklnssYfjTra3mEEFr+3C3dNNIll3QhN5o=;
	b=bstwUIeqQmqPH5EOLjMUlyRUo4hNegbYIrjbCWUZpc73LBHx/1s/LkeDtm/s/b0Wx9BvTr
	xzYVC+TWIEjQT0m9dwDdHVPYYZLjZr338GhYSb2YD5Rj4dQt5AcsCBfBHZce3LuqBlV2ks
	ac67bWmz6aQKUdmNPwlRbmaDJZPvzv0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772300537; a=rsa-sha256;
	cv=none;
	b=A8DnnnMDt3wQ1OiizhJLefBRD3Ld0u6QxcHWzQiyDgpe3nSAk24nM6wrEwk/bhPzmEF1S+
	+6QGAgBxY/ob9I50l4cmCbVXZd2rLutL0qpEDPXNTtw4pnpwTRFaFLB8NjWdVm9C5NetGl
	gcjVFTfRVWmA/4GJsdKwAktXYsTN9CM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UhIVkNU2;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B4C343A6D
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271E3C116D0;
	Sat, 28 Feb 2026 17:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300536;
	bh=wojLBurTdVIocTYrUG+SckAORkviSrPRVTgmvgwchPQ=;
	h=From:To:Cc:Subject:Date:From;
	b=UhIVkNU2kb6XM1y94sNzc09rbebeZn2OIiFwW5C7n/NQhg5yuMYAcIzAsdgxkhuyt
	 ASC4u3o7MRzENnyn4Ip9OkR5vMjxMDchyIVa735Y8mBivSImwHMNNOiYhvCArFSxA+
	 OiB6nm7O7ThP0u/doHJsqzovYjc2U3bEe0T8wwOJ2ZGfmEaDe6h5pFoe0x1EyT3Hl1
	 CoKf2t28OfMSl1oqX8gNcIpwDswjH7wl9sCkmXXOCJ6z0BU6tgk7zE9TVJK0XNfRov
	 ktNJf4CatgswoMv987lCkQkXttThGJBvpPyMalvHvfSMhDu24JK5t8XgTCMbTs8vgu
	 /fyIf671Rl8Mg==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-03-02
Date: Sat, 28 Feb 2026 09:42:13 -0800
Message-ID: <20260228174214.91429-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 911F04000E
X-Stat-Signature: 5tm4mepyqqcnjhw9kqorq97zi73zuajw
X-HE-Tag: 1772300537-847205
X-HE-Meta: U2FsdGVkX1/NQbbuR8YejFVR5zTfEsbSrooL1MzoSy0Cg4afnfckj+MNJCOe7VBsPthTDwQboHSwKlf3VS0d2b8mqVwNrZJMKkaBe3xEbJVNbXgtOqbyf0oi2jV5HWKPgCOuptJW+rmwSSvka3rWrhNeeFfi6zWhRy2uxAr+y/ozq5a9M75GswfETFwPF/kl0phHP+Qb04YDoC1EEmORhWbWqr/QQe94MzfcXFzvUNdb5x9y8MnEjhaa2Klwgfl1WWt1oajo/J++k21/xdi0OQjvjP/bn9g0N0O3MHibEwMcVgvmXuncprzFyjM6TGfiSLpF3/RoaBHUjFxf/Hq9/wTGbtH1jHr79Z5oCwjzReqBnJiBAMnoh6yDjuThLKuGlP+S+ZcleH204v9OUeYVnNXWZ2m6cdbmM5iaDaXwLIac5Ehq85U94VDpCM31rcjBXhITKP6AsC+mR7BScVXU36SecU5U0afX1yQuDjsjF3ql1GFurAUouRhe2X6uw7nvp9I00tWjOwA6kr2sZThpDKROL/J4S1LE1KGvGtS5O20K0yGXxNaRw+/VpHLPEhxKWmBA+X7rlV8lPVtd1w8/EoCVNGsO4mpH9Dkv2bV+eKDMf8DKZzLJ5OlhVTYpUiLCbHxZwlPvgJrib+YBYMyj5PG074uS9tVpKfcd5XDWbFCI4E/R4pe+b7BhQ44hWPsem5XuwmN25O8vmKHosxvINXzXSe9oeTOZZEbkAr/b1zECNHX5klRFXsPIGFTf8b93gxuWRAogsLP/3uywrFecCjfbs6LzMD4KFVzN+RN1/RzRqpI5Z3o/tpAFe/Od2fHSgnlWKnHLIv8nwq24HjzUSdEA5YAsUDlPuQGCN42ess6gXy6DkA2bZqGITqT635qEVZ47rcbRXqz4lw9eGHB0zFq/rYO0tkydPh8ytSEZPblYWvsnpWpikeImzAjOi39VWQ5uaPFcdguWMY0KcX9
 ShlVeODV
 wFmwQfXQlnX/Je2gxbsitei1CbXVWVvz4yzi/xVfIW4nlWrkPJqnKLhVv1zAajZRzcIrp0miKXhPoJKxbXMT9QHbt+qWaA4H9V75n+QGrQj0canmiQ0wZqiV3HA8E5qeRQY7d9uzXow8PhAkY2rFaTLblUCWgq1e3fBErlHBimtbLUzr/6Xb1FDtJLjLpKGOKdAeU30wB8RHmBBGdfjHJh6qxv+mbpAGWGx7McsbOrdWilnM+1/GWXkg4N26IOX28kckqzBY4fmKy8pySO+K2d5RsvTWBQMSvQmia4RV7KduJOgsRu75ZIz13C48ndEnVvsTXYpVq25xbE61ha3CMA0r1Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-03-02.

As usual, we have two time slots for meetings in the week.

Next time slots including six virtual-only ones are as below.

2026-03-02 (Mon) 18:00 PT (not yet reserved)
2026-03-04 (Wed) 09:30 PT (not yet reserved)
2026-03-16 (Mon) 18:00 PT (not yet reserved)
2026-03-18 (Wed) 09:30 PT (not yet reserved)
2026-03-30 (Mon) 18:00 PT (not yet reserved)
2026-04-01 (Wed) 09:30 PT (not yet reserved)

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

