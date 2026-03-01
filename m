Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE99FD0072
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0CDE6B0093; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D146B009F; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FC66B00A0; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD5A66B0093
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 629618C303
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
X-FDA: 84498216348.15.7E59206
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D2334180002
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SUbxeS22;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKevFbhkOf8A9ZeT0pK0WDaeKElkKXGjpfqciF9rJBg=;
	b=y0Frl22+qFn4dWY5P0jRQrnTDUmHrrUHIgF8Vwd3DxymCGMgHhX0A9NINYV+/PadRWLzaQ
	f8G/KE14Go2zbfPSuGZJtnBcj7Y4E0duNDmjTNdDnLc9eqTEQWfQczpLijv+1BwJwvqau0
	0vSrun6BvMd0Jd9g000DhkDg/Z2yBBg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387012; a=rsa-sha256;
	cv=none;
	b=OMnSlkGua8j7IJ6IX68JH44fdgarsD6PYBbJjRdeg0SrJHuH+JfgU7M6LHs89AGDY7hZFr
	PyNDyFdujpflNWfvtSx2cC7+efQREz48x2jpMIOrv0B4AHuVBtk3x5QZydm4odvRsIDPP9
	GwmCSBh+ZA0L9IMxAc7L2GBVJo5o1S0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SUbxeS22;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1400D600B0;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B2AC2BC86;
	Sun,  1 Mar 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387011;
	bh=BNmBp855yDuZHxGokx46EelosP2pYBbR2PhSTdYtR0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUbxeS2211g8wN7uLQz6h9AuTbom7ZZgcCc6z5itDrzXT5tpiKoAfwCKWKYAFRrqR
	 1GaBLxPbwQseaYRjzrdebGBNebNJS5sKMbh1zui3pCpBozkaVHzrzYEFCG6SppXaYe
	 1InjYimjb06EgYOFJmlm2eVKtRNipbDRS+Nt5Ahd5o4Su/CXgWRmp2Y0J/GNTh8HnE
	 D7zKJd8QVVQUjFkAJSiqyQs9XnlJ3pTfdnMTfluB7bQ3gkbYbn+jrYmAV5N6VPlTyk
	 zAUzoYG8Rgy1HFNjA2N1aQMvbexshtnP78n8u/mxiG6CrNWN8SmxXjhyVgmg8kTE8+
	 QQ7xqekehkSHw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 02/10] mm/damon/core: add damon_new_region() debug_sanity check
Date: Sun,  1 Mar 2026 09:43:17 -0800
Message-ID: <20260301174327.76849-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nqczommzzw3syce54qqk5pr59mx3k695
X-Rspam-User: 
X-Rspamd-Queue-Id: D2334180002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772387012-518139
X-HE-Meta: U2FsdGVkX19xw1YvsW2dxyRXkRT7tKsQV/lizFxGtw5EW031JtwJV1RsC7AaEtWtD7bgpIoz5YfI2GC7V91kx5FcoSmj5n5u1Qn4M9QY//cT9UmOzJfvlaw3bkaLTbmLV5UXK/ZEU8zG4fmpWSA3u8pfW0ZtFmuRQpSlLaHscoAIec9RT5P8NG9O+pRHv8S7HXyvBSLaw3Ds05rTR6My4cJwmq4snF3jJ/B65d8SyAWsWUhAJRcybuVDO2kgER1tVwZLHmDTegoYnZlvHaRN0H2301nKzVy7+XlUVfVCEiTNv/lynpUeIRWBQdud5J4aC6UNzrw6byJPKbovMnEkMFIahWDSEMCfECIQqnzfaHhtN5iWUJn3lODzf0LVbZ+g68EhikyTakAwQuQs0iY1OW0yUmLBj3ZaiEcJ6G0PfH/Tj6s2PyRqrFBkQmOmz6xkzTQWGfgAS1IhirRfZkb78Bs0ABCm1GmD+2yAVj4IKtfRMngUW7xw6CJbsrzjvQUTySbBlz4sw9Nk7i2bwvUTcy9jAvg9K5H9dUn9hswrKDtQkDupjJoKRl26LXjccfpIwD/wvhlemPR15N2Lz4eCA7iPh7+OyEwDcXXUZktBDYg1bSRU/AEfQTYdepV39SURZc40QHMARrtieSePPFl0zB+lZk9MmG4yZ7O4GevybOGrryozs3UqhbMufzKzejx5JCvtMyDxRKPXu103poyr8Qht8ds823qaUMbvaSr0h0XtHRT64PI+YpPVPwJw9OQfOQTbKd2WqFZKmpouZ5CQnXkX/nsBWCoYjRNA6C7L81DQsLwYsAf/aLpzIgt1dSSd8kWz6l6WFrCaTSQSEV5GgTcpPfAuxLC3DL8Vogh5fr1zp6+gSqIKCLxAAM80Ae7Y46wKop/wmFDvAS8TPv8A++CySo3pooqLK+2ISQsNtHr+dc7gEfUxL9GhadyEBGJrfm9VLY9qL/yMUWsqdjG
 3oO8FNWq
 rR9hVgo2YilBEB28shh9mbbPP/g7fqBtYF2hJ0xf8LtsjIy3lQEKXUZo4lXpSF3kd29Zfht8V4k4V5xFvZczDe0AaZ/oIo70m9TYwU4yxN56I23l90sZ0HLwbUz0ta+vII26qkykX6vAJjutXpWqILrDNF9TGdQdyAoNog8wcz46ZSLEedMx8PobodubSQ72eUKkrslCEhZD1gWZH02SLe5Y84kfhkd2EsTwpo42fjIh6D4u/XKJ/FpqpFw8BWCrcLIvuS/BLn/S/ZhyJ8mDRoWe1jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_new_region() is supposed to be called with only valid address
range arguments.  Do the check under DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f1a97e85824ac..0c1353164ec81 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -109,6 +109,17 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	return err;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+	WARN_ONCE(start >= end, "start %lu >= end %lu\n", start, end);
+}
+#else
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+}
+#endif
+
 /*
  * Construct a damon_region struct
  *
@@ -118,6 +129,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
 
+	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
 	if (!region)
 		return NULL;
-- 
2.47.3

