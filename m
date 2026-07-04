Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3FEC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337D56B00B6; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E94E6B00B7; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8686B00B9; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE8556B00B7
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FCB11A0555
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
X-FDA: 84951887454.13.B1E7218
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CF9D018000A
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDVRcrhB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olFdFfKM+xhZk7bT8mfvZKSUiKHFir4KbcqXYJV6Ncs=;
	b=a+nJH2K8E+hlt/NcQoue7x0vOQ1cfOkSLbMfEWa3VAqWQdrcNqS9pKN2+8ViHo9VbJ1ssr
	25ixae+fQtpBPUMqxitrj7zMZtqEE/vExRTD20kX4HiUA+9R/tRc11wNCXIcicpTsxpdie
	PJ+aP2zE8PkLJTlTifwepsQ4Wgupv8U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDVRcrhB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188705;
	b=MeD3qh7bT7n/zopNB3STobv+mj/zJtXn7T19/uxqedT1Gve3vFNzZrmjCJGlZd2dCiM29+
	Pfjg9Lw5y80/CYhHdzsY9cjglxMtl1YaIpXmyTv4aTRwK/rqcuMnjXepFf11fTZeQddbwn
	aoe/z6z7NWF2h28hiCdbdf7MGxJC7Xs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6367E60EEF;
	Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE2D1F00A3D;
	Sat,  4 Jul 2026 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188705;
	bh=olFdFfKM+xhZk7bT8mfvZKSUiKHFir4KbcqXYJV6Ncs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDVRcrhBwsub7eqVFNZ9z68FATqkCed2A9ODsn4DLnvuLFaodv3EDW2+Q1ommlE7K
	 RHOumldPU4kfEoTVS2FgAHVYTFT5QvUsTRW8srZAQUblRlgxiEfpJnigR4XZzyZkCq
	 vSIVhvPf3KWmZY+mlIicRgwbHx9xeU0r1Vb/ta3XBdKUgEAtJznfDAW3meAzkCOKkW
	 7PO5eXFacQ0edDPaUwdYA9JB98joMg2HPPESRcE5MiVeQkEdW4tQifoAOS4gHr/ipM
	 g/fZ+BuGhWQXXwVr3jQ41wMC2FPOEOmfxUCuYBVMDPQcO8XdvdNMH29KnRtGWSqtOR
	 9Ea+uuZlym/+Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/11] mm/damon/core: stop ctxs in damon_start() before returning an error
Date: Sat,  4 Jul 2026 11:11:24 -0700
Message-ID: <20260704181135.132956-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: utu1mnzt853o5aoye4jwhrzjsjegpnq6
X-Rspamd-Queue-Id: CF9D018000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783188705-840821
X-HE-Meta: U2FsdGVkX1/eKvN4H6I2Kjd/NrlL7ZOz20831d/PPfLos/KM77pkRJI2uFGqDgWB0zohkWijwX/ot38gHfub2zOnvTF8phuroZkqtmvWEnu1dD2THyyjOwaT0ObzlwMaRiNDQUjKLEIaIPNDKjtOvr1YE5ZsYxtaLOC6ifwPWjC0K83WXJ2vs37E91UEicwK9W9KVaEV6HfIeMh6oezF7qV2HXcBw7nXMbvajjCMbxJ2v/LfPK2poIoSRnYqzaD1bVgA4H04NcQvUzvrLLuPkf1kYNTIe4Cdn2qO1tMj+cWOQp6VwM+d7+NhwOfwrZnWgu2oJWC0B0YIb4dDG/eQ2sVlI1Glz1iv4BwYLqWrRbjzNhFuqm0M9+r7W3AFc3VBGGB3IzIZTxDB97fvR6PFelnMca+fz10dLFHuOsDredhrvTN1AM7BooOCrtPZlds0A9F/w3Tcm2Ave7xkKN0cEZod5ishy1mAI0V82oyYyp/AFGbaB33kkGc3jcsg0bz13WzDjW+sgfITxlhlGuDrNHITTgMaVOKrFgXQgEJZh7jgAV9hRLidBvIXS7KAe9Wyoet0hIENHmbSRjRdzVHulMk8E1khnsZqDOz8qxzy/xkwgVm3sUyxv9rNI8gUhinMUpa7qodvXQj3sfPPnpSOFp/8KDwWruzcKeflKJcU2YWoTcrB+cG/r+4k5XkwBN3uG0MJ90TW6uvJ0KpMoLvMsnaoh3J7PULnkJMmKfcf25vRHT9ji1nfCbhSzwiHUeM3fqc2sUwg/BZjEhs2ivVEcR3HuZgUfcqhDlE1aM5FFQ/ouD2H28IzGgrrt3tvgApoUYZvimuehWOuCFwvdSkLVVoZsGTW5lO0Bi+WZeQf3EwHrqv8APYVgjxUbYixO9jj2X5X1V0yG6tl0eSJO8tq7z7aUbsPdH7gKqQsCRzWAE2srgp3iZghGDwwnszlL4o3mxz675qKMtr4a/rzYcS
 nwL6gitP
 Waeyj/gdFijHuMH+pLeZSOo7ThCnd4b+uvmLKOHt9gETcDs5UU1GfsRlOtEFfYeYgKdSW+hpI6/JYULkOldY9bh+6b9+vTErq0816SmDkmdyllij8HILURUD34R7IvNb+z/LC5HSMfsbPfiv/viXWUrVXr1t0yhxkNZO3CN/nrIixP1IfvrrjzEigUBz7mxoKtyKjpwlOQZU/sxnW8b1kbNF79Eza02yi7SOLIHA6S3tYQ06P/wBZ1yMfTHidad4+kVgOihpa1uYTjJbXQXqLA0N3OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When multiple contexts are passed to damon_start(), the function starts
the contexts one by one.  If any of the operations fails, it immediately
returns an error.  Contexts that successfully started before the failure
keep running.  The caller should catch this and stop the contexts.  It
is complicated and easy to make mistakes.  Stop all contexts in
damon_start() under the failures.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3c5a46e1c079a..16d9223c33a72 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1909,8 +1909,10 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 
 	for (i = 0; i < nr_ctxs; i++) {
 		err = __damon_start(ctxs[i]);
-		if (err)
+		if (err) {
+			damon_stop(ctxs, i);
 			break;
+		}
 		nr_running_ctxs++;
 	}
 	if (exclusive && nr_running_ctxs)
-- 
2.47.3

