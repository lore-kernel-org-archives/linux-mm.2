Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E5FC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE1F6B0092; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760B76B0095; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605226B0096; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 376856B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4635914016A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:26 +0000 (UTC)
X-FDA: 85161789972.15.75A254D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B58BFA0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OOnu/tWm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0ux2Ajr+KLUU8fQjRJzy/leuNsARMPnQOrajKg2u/o=;
	b=c4DXjclFYF1A9OjSzeKo2BOg7fl8LyCYwV1vDZvwTRe9v1jhpm8TLpTf+7sOBZYjFfNVto
	V5uMWElBeVAfPQgtTHAO8NmwoD1D6ow7qJ9YwPWOhbY1Zqjrve4aRqKIgBdHP9da9hBO+r
	8tUyfKEDONgU8P+EqccG9EDcUj+0lj4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186384;
	b=taog1JiUCvtuPQtV+1MtFhg0SH9iGcNJJyOSl5dBrdfW/aPBGUhONuhDOE39YchuIds5w6
	QXMogqYDF61/03mDPw8ZfZGzxK90tZ+tGbsSD/KR3TZF1sW/nWsVW5hmHu8lMru1AeCT0P
	b0nvm9hYfJnF7DR9oK+CyYHqAohL4po=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OOnu/tWm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5409A601FB;
	Mon, 31 Aug 2026 14:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38F11F00A3F;
	Mon, 31 Aug 2026 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186384;
	bh=j0ux2Ajr+KLUU8fQjRJzy/leuNsARMPnQOrajKg2u/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OOnu/tWm7FfN/WVmuah++vaeUv4DTc82sDlwfcr2fojF5ZyGY1ykULsmmlY5KU12p
	 tT56GE1m+DVb8VmGJzfdb7Awq9W4WmaX5D5fOuECuUGO+ZEKDO4r4RmWiOr2M821vI
	 2SeZlnWf5CULk4zQd2cQ2/0cy+hkpUiDq894szbRuHeGbG+gD2ecFNJ6wmFpA6wPXn
	 sFMeKH5ncp+HwYNPBy50vTiy4AGoUnWRrFr+q6p6o7Z9nZfBdZJsXs7O0MouB8kcuW
	 dnFZt459wBFA+cGkZqr27oXM1TsX5DLpIZU17wb/bf5sSL2jYUwIXqcUf8VixxYxN9
	 LQMbH3H8wLu6Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon/core: remove declaration of __damon_commit_ctx()
Date: Mon, 31 Aug 2026 07:26:03 -0700
Message-ID: <20260831142611.77572-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831142611.77572-1-sj@kernel.org>
References: <20260831142611.77572-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B58BFA0004
X-Stat-Signature: ctqajq9bxstu18p4n3xcw4z161hykm18
X-Rspam-User: 
X-HE-Tag: 1788186384-703034
X-HE-Meta: U2FsdGVkX1/OyLjdzRha9QRHblAuIC04qBEGlV54WXz5blF2N5hyURodz6KYtkw68Tr6XdJbcD29r9oPFVWiyu3sBNZkpgqhSeT7Y0/XUJzLEZ1DYlNy3XSJavNABbnJYeC3K6H7URDRbRzb8MdsjD+5RNLr88/S/Q5qfFB+ftLckQGsJVyahGxuUoooC/6A+n+BIPTBFUiK28jtlhV1KoTtYv6SGdsXth0AC1tPK06+AJCxlLB0EYI46W5qLgf+rBx53LL8yH9xRiQE0qjMoADWhOMVslNKb1qM91SDmkVr9XHs94NVilYVAxH5upzCim/8CD79yr87wzRuzC8vlynsK6vMZIN//eYccdSnczLqBd4lHA3wLjs19iE2UU0rDOpjG4bx4eIXVvj8k+hRs+i04T5DFpDsE8+VJEB6xEgkBXk5g8aEwaPROfpTTtG2aqcKdD6bX5DwQs+8hF+hk7hDHCAoD3zrFhl3r3MeVFvpasyhUZ4keIT1jF+XAStwQKXFmQsVFXAu0Y0mIw1seqtHPMMmCkMW4THLILbbQFN+fu4awEx2iMkCjoT7+J6n85JtIgTpKJ1A6dOCFkDG58Mm9v+jZ+A+HyKDbY/dUOB5AToEYilTUj/LdvrxQ/hpWN9mRdKsk6NrGaJLaHRDoe91zevZJKbZ/jznPL14uiazvZarNo+VTIcUwpcgTy5IuAR8xnotkBiFjhkj3BLtYiWfleLpMdPNEBk3M12Sshmp0DDsa7xPN0pJ5mIWQUeM6AzaTJKAW8ykvM0nJ7TwAWtv2X6Oz22VEIR5h4O4AiE/II9GGalPXcaC8NOfvSoziwgZiz7ybR6Iu+A/V783BXy6OGgMoYI/yj+yPnJ9Em+k+bGQTHDVii2Pk57d9EHOcCaMezvSrnqGY3d2zmQTrecxWpX4axttw/W7z/MORY+dAaql7xJvLC5owSTYg6lxa63CRpTjiwreCg0ftcK
 M9Zw/X2q
 8LfZciI7NBRvbNCa3/HCqomrnP1Q7kSgyFLEast6LdqtHZxrexoy0PPUonZCKc+RYToae9PQG8adpXXtxzdPX4AVwpUQ8mgi0nESOr3umtL6QCuIVdtT/JpXQSa6d8ASU9r8f5pSuvbbSCfiVEG0ds34YV1QCpkL9O5CzNodwC3GJPEEh+IdDmokRKTBFgIBZwzhevGJroNxeq7NDtTi7NQO4Lr3riLJCqDKAJs8IrZeMD5NxRTgPPbEEIEk203UIO1nO6VKyyPvY+prhpydD4/pcRMm6MJXjys0byhgLqJg2HnRLVKhlhOPdfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

It was added by commit b1471afe4d10 ("mm/damon/core: do parameter testing
commit on damon_start()") but is actually not needed.  Remove it.

Changes from v1
- v1: https://lore.kernel.org/20260806170701.79266-1-zenghui.yu@linux.dev
- Collect R-b: from SJ.
- Rebase to latest mm-new.

Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b3f8bea774c2d..79515ef03fc2a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1961,8 +1961,6 @@ static int __damon_start(struct damon_ctx *ctx)
 	return err;
 }
 
-static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src);
-
 /**
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
-- 
2.47.3

