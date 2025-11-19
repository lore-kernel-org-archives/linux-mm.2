Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 426D3CF31AE
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 11:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890A06B00A9; Wed, 19 Nov 2025 06:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867A76B00AA; Wed, 19 Nov 2025 06:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E156B00AB; Wed, 19 Nov 2025 06:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6350C6B00A9
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:42:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35D0C1A045C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:42:49 +0000 (UTC)
X-FDA: 84127169658.05.24DDD4B
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id E9C75180017
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:42:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763552567; a=rsa-sha256;
	cv=none;
	b=NwsHoME38rVHyv4umO7t36mZyyXN9zj+ro0js6Yif19f06cxhnSwMp1dxVPDn+OGjdJSFw
	kgKr9hE5+/byv/q0okEQNRNDVcLvfMn8tycBGy3a4wwx9pkZKP/Jsin+U4wPDKrRHlAJ6F
	2KM4lfhD5gIJdGe+o65somSdrLQktGI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763552567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=G+BB3jIgoepc61Pc/HJqok5R0Wq1hv2ySuUhJCu1SuU=;
	b=JXMtbe2NkTrjyfJg1lr6pNVy4kCfDkNO93d5ZODZI4VMCPiYVOBwiW//1OJmMF2blExPoG
	EnHhV5/+P5U+BsVYk4gLYW5+Eap4+QAnWDzZv+SrNXQm7svgeZazItK+inJBVMzHBI+GtX
	txI9F0Di7yHgb/OV0/IuNh8IisrRrT4=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 19 Nov 2025 20:42:41 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	youngjun.park@lge.com
Subject: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
Date: Wed, 19 Nov 2025 20:41:36 +0900
Message-Id: <20251119114136.594108-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E9C75180017
X-Stat-Signature: jxjjzzo536gh5fzsz974p7pzk8fxun3w
X-Rspam-User: 
X-HE-Tag: 1763552565-566052
X-HE-Meta: U2FsdGVkX1+2OF2ZdGl+qurMmIpptlzoLoxdnLrpo3daQXTHPpjGW1tEmguO4MUyU1y+BvyBSTRfug5z/zC4ZmGyvrJwJr48Dm/jCpKxjPqDnHCLjDSxpZ8uW6r2DYMozIC0g8RyMRI3GpmXtlCfvHKmNQ4mCjWL5ErY5L3Ls4/1XVQZfJAJVJKhJJWF5cuQI6lGKiGH8XGYvC9PzF1tWKSpHTGqSvolB2AGY8vx8k6ZLdDcPkQsYvXmDs+GNulJjXWFK+kBY/VvQl7DbYil3eDFarfr8GhZLCHtMwGBrBbNIIJXplQy9XK1fA7/4bmJUU0z/ztyB74dS2u8Y8Sb8V6akTwWyzKt/1Q0LcoW4Uq3LT+fog0pAz4eilIe3QLrD6ZDOjkeiLPbsKKwJDl8QqKl3Ce0qFCiLby21ZT2iqsn25pNTtwBEoNXROOglTF/+mQuB3FtzZnN+swEpghnfmmqlX1bFWNe6H7cj7FZiUlFwsZ5DRVFAymrJyE/3tDBb4MCez47e+8RY7d9Gx/Uy6Wpa9/nZoz43Z3cI9KhOh0jOEG18w0r3bMh0BXoI+AHePQrlSAIIGufGCk6XrX3E91wbpThOTs/LQX1cF/6syDVd3gLtLjxk+gJAvqHD5bVCmUSLgIYN2kl9fbyWpw58Sn3AAh5b/rjCHjtofy1Nn7vtq+KQ8jUgW3KWhX/5fBlkK3CKCVqJWiZNw3xbzN8N/IiL9lXd8MrYRHkjMc8Bd2j4Hei51p4f6cwtpj2VwozDL7T4Xz4AiF9D5UvSntZH7qYH/YTnBAwiWS9R7l6z1OjIF1lCRtnsGH8WW+iKBrU3sFlfSl+rIpe4s+dG07OirOYBk4yfEoKw2JEwGtZ/yIeB83VTP7XZesTLfGrFXuQrLf3QOjR4jiW+aP6M1wPVkavxd9r4fYOB7L4gAUDH8yD7m1QaZRKpe04hm7SP9vUFwDjbppkUuxnuMOik3x
 II0y3MLG
 sod5YIsJsTtevq/QBdexEuiukzwcOAxq/JgPkPe0Iaiv/pwSYz8bjcWHqR66FzN1TiOGVtkRotEnNWnwpFM0hVqAt+fU+NFaIYyczmC2LtyoJAOgzxtZUmvaGRoLIRssZP87dN4gCVW3jVXluo9pzap3tCfA7DpIuyZqQTK4wq/uDSAh9qUYn6pwrRY+beypSfJIyPsXUTuA3/TyD09DBP2tEZ/c1bz3rOCsEx+Ca6tvfuJOyz4/UHoAiSvJ+m0zh6klNiVFdWN4zGMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_alloc_slow() was checking `si->avail_list` instead of `next->avail_list`
when verifying if the next swap device is still in the list, which could cause
unnecessary restarts during allocation.

Fixes: 8e689f8ea45ff ("mm/swap: do not choose swap device according to numa node")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94e0f0c54168..cf780fefaf7d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1374,7 +1374,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 		 * still in the swap_avail_head list then try it, otherwise
 		 * start over if we have not gotten any slots.
 		 */
-		if (plist_node_empty(&si->avail_list))
+		if (plist_node_empty(&next->avail_list))
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
-- 
2.34.1


