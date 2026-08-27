Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFC9C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4151F6B0096; Thu, 27 Aug 2026 09:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED0C6B0098; Thu, 27 Aug 2026 09:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329A36B0099; Thu, 27 Aug 2026 09:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 107686B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:44:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C573C0430
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:44:40 +0000 (UTC)
X-FDA: 85147169520.11.D19A86D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BE85A0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:44:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BUFLAjiq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787838278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nWd2JiHbGpFxdKtIgR1/mA2jBP+r1D6KF4ucSMyulY=;
	b=sJHnR2S6H9RE/uByHkQUOlEqjTPnWnwECh+bmpXADul7bYzDEtwOs123T/bna+phflfPGf
	nN+XTSX/Stl30U2bViaVzUTJqzDyIWIZkuRzL3wK405/IZ/yCHR64+PNgV/JdAlqOANg04
	ynIb8ToAqHX1puUPlKRKQsbJVzFCgcM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BUFLAjiq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787838278;
	b=IMtSpoyTIfFb3muh4LDUJF/LDPy6EoMYVqTnbuBvQwxofAJz4jM/ueh41Y9VTTBEYsH+tS
	389UMJBL2Vmep+7LN99Xw60k5/z6UcjtnjEKzNlx9lFYLjjBMYFpOGbJsQ9NlqhBUkyEDP
	OjBdXO/PYEydfoYai8xA+6biLede52M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A696600D2;
	Thu, 27 Aug 2026 13:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30561F00A3F;
	Thu, 27 Aug 2026 13:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787838277;
	bh=9nWd2JiHbGpFxdKtIgR1/mA2jBP+r1D6KF4ucSMyulY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUFLAjiqHJqs/KvRm8Y+02p8G9HG/HkY+T2ptguC+9wUOH88glOR13lJQ6rZISAAX
	 lm3zIA4U63MfGBv4Pfi2VtjrLpaPai2PlBokszEmUKOOmJgbwERCXMptu4a72rKfGd
	 7ZTAZDKkV70zKT+2f7CkRwa9eGYpT/AOeSA5yqq4Eu1X/9OcDx9E22Ruv1LRJOqhaP
	 EZ5n6GMzcEiWX8Clf1FsxQz/KmQsfFzMPovlSKjN/YFqraZ/MIszhm59tj0V6m5BFu
	 PULYTwAcBDBzKc9iM1Si+qx44h5MNPDwOe1S26QLeMyS3hzAjSwzyqxYCvw9CwyRqX
	 9ZY1pFc/+sYVw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 3/3] mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Thu, 27 Aug 2026 06:44:28 -0700
Message-ID: <20260827134429.123023-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827134429.123023-1-sj@kernel.org>
References: <20260827134429.123023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ntokm5ezp4b4tm64bp5pgebi5bpa7og
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8BE85A0004
X-Rspam-User: 
X-HE-Tag: 1787838278-332610
X-HE-Meta: U2FsdGVkX1/TZJx9oQ/sFFjxd3gF95SoU9RgVGGG7A/WMksnizOZ9nNEc8+q8rodF1ugZOE5QmO0/GTGCxmxbZQvDnaLd7JmPQObmPCJHsgLItYF8ZYEuXfkeUbvbCFKhzXFvALcJtymXt/yL6RRezvt5nJzlTV0F7HiLeW1jTsIdf1Lu5X/p+ROMnrZ9dw3cZ36rjIHCjtkWnOPZxezfEpFicIeAwWr8nS0GD23KcIM/KFdFgEPzvBZjdmG8k+9o00pUHDWywgTr5I8huaOPNjRe4txdYic2qmZySZqUHN2dfTXXXWIMzq2EuPC4GSSOY7gfqEVySQc7niG6qz1OUCOv4MjvxEmet2QmWQsG8DHpN3un64thyP3dA8qC36CK276AnKbiGZHML4J87+nFr1/EPDpo/jCS3UF6Yyc1b1fhMphfBCN/HyT3kK4xpvAXaP5bTY4Fpu33jgN7wsIOGNj00Sr7E0/cuzlFNSjaOUDxmjfXbOuK+YftLWqu3Eb/ctn2PxYXqzAwrlObDgizirO4i2HxRXogLiUBvOepE0gr5+LXS3i7QrgWkPGIk4Ble88AMoQTU+8I3bGL60KnzvpVPNEtIg81is5ADPT+3cf8nd/xA4f//T/2jmGe2t5cqu4A0YPXX8xkEgLFDxfG221jqnlknd2XcbOzxnR2zdioOi2NVL7kMqfplH6m1IjgGG3Nt3zPD0s8MB+6M0GYT/dtU8iEkeZXgJ7Guo5+k+Z0qC0h/VlmWp6cyZWSxD46P9gOcLTjya1yIhQFOufob+An1upuD0bsUhNBw+ukH03rrs2KY4He86VwT++zM8VV9qVH1qMiTmNFE2knZPGjTIc1SoDW7/UxSuSNdOz5KG6Dofhvyq1DZVk5lpmtbWh/ATq3Dh779SaVjckjfLXW11Ea560wyx8sMtj0R+4l7NvnWD7ZQTxtSp0F/2oW86TdZSdnmHdXbBGyFMfrYN
 VVfmAz+Y
 4SOBw4W2GzvX+rxdS6xzvV8gpEexWQ+EqTBnjNgAw3155WMNjgysXIE6hkSEPig90gY76u3w8wt9/0KnUI1KHpmtAeZemaB8cmwRCPe+o6zjMTLcVR7Z29Sd9Gwll73XCneHGKp9tXZNU85MJGGn7Z9oJnIKv6gP3tdW8z33LhQb/QtxClq/Zaa/yvnqU9hTQdSYYZgWK+d976khTLBjqzMJYfcDm6cUZz1SydAPJLyF1k5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When 'refresh_ms' is set, DAMON sysfs interface periodically updates
auto-tuned parameters and DAMOS stats.  The timestamp for the next
refresh is initialized when a DAMON context starts, and updated in its
damon_call() callback function.  That is, each DAMON context updates it.
However, the timestamp is a global variable that is shared with all the
contexts.  When there are multiple DAMON contexts having different
refresh_ms, the update frequency will be changed, depending on the order
of the contexts.  When there are multiple kdamonds, it will be even more
chaotic.  Fix the problem by having the timestamp per each context.

The user impact is not very critical.  It does not leak, corrupt or
crash.  The update will not be faster or slower than the lowest and
largest refresh_ms values of the contexts, respectively.  The user can
also manually ask the updates on demand using kdamond state commands.
That said, clearly this is a bug and can easily be reproduced.

Fixes: 9fd7bb5083d1 ("mm/damon/sysfs: change next_update_jiffies to a global variable")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e3858ffab4b22..f05b256c90ee7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1789,6 +1789,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long next_refresh_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -2215,17 +2216,15 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	return ctx;
 }
 
-static unsigned long damon_sysfs_next_update_jiffies;
-
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
+	if (time_before(jiffies, sysfs_kdamond->next_refresh_jiffies))
 		return 0;
-	damon_sysfs_next_update_jiffies = jiffies +
+	sysfs_kdamond->next_refresh_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -2273,8 +2272,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_next_update_jiffies =
-		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+	kdamond->next_refresh_jiffies = jiffies +
+		msecs_to_jiffies(kdamond->refresh_ms);
 
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
-- 
2.47.3

