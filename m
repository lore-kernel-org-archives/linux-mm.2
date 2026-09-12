Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E215FC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A996B00B9; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93006B00BE; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACCD6B00B8; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 464416B00B9
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 796DA160577
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:26 +0000 (UTC)
X-FDA: 85206197412.05.6DD2D7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E855116000D
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLar0xk3;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VxGvxt644mU37ynH6tDMhkQ6DkJqcqbvynSb2Y6zpJM=;
	b=FdzjOh7lhahhgx8ztY6QhTyjvBofw1Ca+grYjh7lDjYBpT7m9nJ+apih1UlgC3ZiTdXSCY
	meY9BJXHMNagczcC7GNrTJd2OmOvcCFcCP4RhJC+Z2YZNuo7k7ranUeZwR9QchEaijCVVB
	/WTptsPIXSGYzFdXDsNGmxmj5nE6Q8E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243703;
	b=L65CpXJ9ec9w7OW6GnXDNmXk1ap7oh8qceC8sbVtpHlNqUeoqAie6ejONRYaYg7V+jhqF1
	eimSvT0GTMfVQ/JSgBApzrJfgNBKoABhyl1Vyet9TnBtxQ8xfehmAt/CMl48qgTfXrb2fj
	egKYmszDsdOYbd89HL7j/oHuNGI4/FI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLar0xk3;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8456B60236;
	Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198421F0089B;
	Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243703;
	bh=VxGvxt644mU37ynH6tDMhkQ6DkJqcqbvynSb2Y6zpJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLar0xk3+wrSqDaUCIrCVeEZhjtSPCRM4Lck/b2BMqT0oYQoVI+wSsLu5NpLCbekG
	 VJs+ZSntM6rRfTCgZIom2pkMMYn+M9+2z+DY9IYT4UTccJyjYwVWSrutpXogcj0Re8
	 iGDiwCiLKYKPF9UFCHnckXE+fCeyxymutvjZFHNFusakyvr59gSj0cA88wtCknHuLG
	 OmhCLDrw87SKqQGABG8imD8nEgXxdbfDewhfJZy6vRxMPn6oLX3yBeBsZLl88Mp8iH
	 ZXs1FV11liRqLbBRd4DZCswAjFOvmGspSlKXymiUOOw7Vj7vk+dw/h80fjix/TLfaM
	 Azf+4Ovx3PJyg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/9] mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
Date: Sat, 12 Sep 2026 13:08:03 -0700
Message-ID: <20260912200814.145612-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gpjgmfbbemsrth1rd6pdfhhyb6e4gmeh
X-Rspamd-Queue-Id: E855116000D
X-HE-Tag: 1789243703-617854
X-HE-Meta: U2FsdGVkX1/JQNT6MVgTgTHV9fvRtnLj5+Odbp8hsXNm/LFWkaG9kYbVVP+ruYPSUrD6+5AXWqhM+NeFsb7/atsQ73Ac5DbQmDqzKLwkGddUK9dz4uB7KqajfXYhP9x900UH89KrKyY0hQLgl3zF4CZi57DQZJaDQttjMjbxlLGGQ+HykN1HeJAkJoaXGvM2XOEV/z6WNt8ift81pDobYAs1r/+uPX5SVI1dJK3hT20kcO8BaJ5GuTU3uK/pqEmsH5CCsZ4UzxANkvGrYyhf9Nr/c3NPjJMuag3dkzCMEQDm00DbYm10uUY+RtziH2/PD2puO+y33PinioEiRCvs4HFxFYVhARi0ayRvmPr5Mt6EotMzvja+HiXc1s//k4dKhvHQmgZ3fQmFN+6kfF67Z4iIdecvpssnP6zsdwaXur/YGTnZZyIJgI8MJkASA76qr0Q9fMQaVe7kY8a+LJYzenmAHUkE68GURjDziH5MROSFnyAr7l9+6tI0tfPRrcsRvC8dd6p+nojB7l8a3HMofmcs2PxAxMijkJQIktpB7sDW2BBz4XmO2lG7RDsPiPAuFZsoJqm7OjLXhNlOi1gSBz+K8bps2kpMaOWCXoxEjGwoXCcIXre0ThniQfX4QhjPxhIVpiwqAwgcw/WKQEBaYfLR/+g0j5Q8dkZzrgjZ/mqzdK/bDKkb6KAZRp0BljgbChdSafwwK+LoGX5P71PtMjae+r92qEDJnKnLKKEkqadHbI7h62cZRqdBGNjHM5oGIvbwPk5iHRF/kacNqkpDY+dfHYQD4DwKYAOPYyKbaMkqX/lg/EGLTfewx24Y+S6U5NWckK8KRB7Ldwe+IR2JRFnxz0fRGF07dFcNiTaTXiE2ZJa6euBMPV3cQ6FNnpZNBb0wNGt7KFPUCFVFKZOe/zpaqqUFyOyYNXMKwkqBdW2OplfRVEYqeJUPRFviIL9JyQVMMoa5T1TkHAVsqz1
 n+EV74hS
 iM/WziKlmYKvKFBqIdTGvqd0e3nfEvz5WOB7KOtXCxcgHzxafCbABYNFo+qbMmsPFJP2Qno6HFVxPDPMRbosQskhkClgKtCusmuM7THPlALUf5bBU2VAxYjHQ+tCy14dz5GvvLIyi1ytQOFanXZQmmnG1aBs4pyx+p4HzCmdKtAVBmHXxGPFukGxIcqJX4x+qWCnrXcV9jhLg63pTcuFn0JOgW8nZpGgVifZAa/SZvi8/fJ8YoUrslZnicGLklETVhHXQyGoBlp6OIDu0+Bp4y+v88w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_feed_loop_next_input() is open-coding absolute diff calculation
instead of the dedicated helper, abs_diff(), for no good reason.  Use
the dedicated helper.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 373339f961967..61bb25674cd23 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2920,10 +2920,7 @@ static unsigned long damon_feed_loop_next_input(unsigned long last_input,
 	if (score >= goal * 2)
 		return min_input;
 
-	if (over_achieving)
-		score_goal_diff = score - goal;
-	else
-		score_goal_diff = goal - score;
+	score_goal_diff = abs_diff(score, goal);
 
 	if (last_input < ULONG_MAX / score_goal_diff)
 		compensation = last_input * score_goal_diff / goal;
-- 
2.47.3

