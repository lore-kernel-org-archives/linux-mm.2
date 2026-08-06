Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F7DC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0C56B0095; Thu,  6 Aug 2026 03:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7E76B0096; Thu,  6 Aug 2026 03:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE6D6B0098; Thu,  6 Aug 2026 03:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C07BF6B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:10:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63E1940103
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:10:13 +0000 (UTC)
X-FDA: 85069970706.17.6D1EF6A
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id ADA95C0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:10:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UegLZfKy;
	spf=pass (imf22.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786000211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxkf9l/6VRKPUFdY+I+2JUrRfOgcQ7nzG7Tljs67NVc=;
	b=JP6OVapvuXT0dUm0Z6L1mpx2bpt8EUd/GjfEG8vS3U7794AYbqBI8lTSZkK2exTLhXrqf8
	MnrZUTIA3ynozIoW9g/iw6Crg08aBeNX97U5F6F4A1RawGRLxw38LfAARhUZqieauScVe6
	53EyD7M7FVfiK76zoktiiSz7UdGZsxY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UegLZfKy;
	spf=pass (imf22.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786000211;
	b=XWyKPUILBfvwsPjRdEMxlZehmIpH3//s5oCXUS9RM3UIPJqVcL4C5QGIZo1/Z4fKerYrUb
	QSxAXvs1uaaS431vrUVZJk7tUBlY60koGZARXp4kQOX34zfcNh2lag8B/fQhfV+Gf0o5lF
	dFh9rJmHq2NkvJo5o4EmyVq1iMChwEk=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8485ef63b68so2652785b3a.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 00:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786000210; x=1786605010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pxkf9l/6VRKPUFdY+I+2JUrRfOgcQ7nzG7Tljs67NVc=;
        b=UegLZfKyzIfchfY7FJlu/6lrae5dTysqe+TFBprHxbGRdJVDdYb9s3j6QzhgbIqoC7
         s3k9vjCPFmgAD7P1DOCtStLFVRgmTwuMh5d2hNPwEMZg/rxbPVkCH3xd5guuJxYrxQfo
         ucuWAKHC8qkPusycq/QSRhnN9E6ZjrCb4AlMiR+Eugx25Az5va871CPZowmRoG4E9eJP
         uAFy/r9hb3k5ozkXm23mCC/AcT3bKfdecM8K5OsE60bVBDPAlwJHLkkI0CfnKSEtbG3G
         oOxN4m3dhTp6kUhzKgWEurp7hKPGet0ZnLvXiHx941h9XuabYWQ16IuRc+62IRYMyvuS
         N6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786000210; x=1786605010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pxkf9l/6VRKPUFdY+I+2JUrRfOgcQ7nzG7Tljs67NVc=;
        b=TkUfOlQcIpe7WTIiNOuhg4bXPj8n3MdR8E37OJ5xJ79kp7pdNI1fV9JfSAihyPtZY4
         5THjJCLBw54JsoLzXOGLQp/5PNYU/ffTve3RM93dBJ8TH9hTwVlzVnz/DJ4bRhjciIFE
         jEOPdZDx0asAbUGSPVoP8fkuC3FBOeXzp4VhFISwCpAoekLYqIGvQ6FF+MD/z1dz8+Vs
         s6FRTMxD5QcyN0jo7iy+ybgyfT9e96AH4/pT4T0cmroaS54K/DC/VKNtzTdNgv7vPyvU
         A8zK4dG8wKKC1zZoKaJeRMD90KdtB9VmXA0Z+wQp/cna3XDRtr9DBVrMCaUpWXEX8caB
         43TQ==
X-Gm-Message-State: AOJu0YweLnpEe1A8x04tSNrA+a1eIfUYkAglPL7TKRK7uj7Of9+s0iSc
	RtYl9SzaxUWDBI3cttN1/ZUCOiNrjg88eCMuYpUnCZNmOfH0UD4h6/zv
X-Gm-Gg: AR+sD11olote3rC7nrEFzaWHAN6oNySap+OfRCBzZN/k7vWZ8Kj8IuaY2nrkoFj8kaX
	1h/G7efUmoCnaNU/b14JaGOnrhLT8gDskdLilWJINHnIQRdmQcnfPWeF4lc7CEXVtiO8GCPgjTg
	st5DSzac0JrmeWipL5aPqcbR152mteU3CEHbdyQiz0Pdcd+vy5Phq3sPvEJsgQUHa2LIlBBhGmE
	7NA92bvCK0LtGpcppDKd4sPvuvUspjtS0WS9o7PfkwoxQgQeAUYP3blSo4sRmNABrPcEHtAbLjD
	5Qd2d2U8aZeXteEJ3YD2ZLLYMdsnzuo3sojDjojdZRC4kDzOgWurIXv8DFXM3VTw+eivwNIZnFP
	cfVeLl/ewFxzQykt7AIhofM9ihiyfQCGa2SbSIuWBRBqFjo+kYDSi0LxyEC6H+sXgqhV6sBhh4A
	T111ePUlIdPHmia1lRppdtR+SBf9yj4QDo0qyVXbPTXJuotBxVE2l7KfY3qFOHkSFbNqzXTCKS/
	BTLlaKqMIKH7Rvf
X-Received: by 2002:a05:6a00:4218:b0:845:ce5f:c926 with SMTP id d2e1a72fcca58-84f2e210308mr14993193b3a.1.1786000210573;
        Thu, 06 Aug 2026 00:10:10 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f45bc9cffsm760154b3a.59.2026.08.06.00.10.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Aug 2026 00:10:10 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/2] mm/zswap: Fix global shrinker when memory cgroup is disabled
Date: Thu,  6 Aug 2026 15:09:42 +0800
Message-Id: <20260806070943.95542-2-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260806070943.95542-1-jiahao.kernel@gmail.com>
References: <20260806070943.95542-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kw838u89r5gz438sndgbm4na4g6dujpr
X-Rspamd-Queue-Id: ADA95C0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786000211-310310
X-HE-Meta: U2FsdGVkX1+WPNUUm2XuiX+2GFubAy6rDvkRDRrDdYCRgZvV79ED4RGWxUFExCl812nwhYmt3kxPN2k/UepNFxnarlfZXESrRarVz18iEdReqERVfbmUy1RTRSx7/SUXOVR6qyCdW1UxPzDBYKYkUqNPiSHz8pHFDGoff0kAlHHAi3Dz+qcjwV/KPsQZbB2dmblYsedwjnomSARuifRXX4hDVjet8/M2jQ6Pc/tardXU+GX5VPVPA7cd+R8iuhAGLRxqtt6pOs70mGqnDmF6TreDPZ92HJUKE/7UqDcYCmyrryxOVi6MlprdjJbKpvQF1kvnRw5jGtrcfKYDR1xqA4/n/N56g2a7f4lIpkvkEbQpyM1hJip1XuZiWwl57QOr9w+AiQH74Q5+bewh1asl3yCghxv1n7ISUueOpjvW8G44aaP8o3Htn7fylt00LOlLVlRf8WTp8QB81oVj2/EAyBMd8ltX9M1jMfx+SbNIu/Yr5LkaKc/vy4QEK3b7F6j8oyGLNfg/XSMK+7w0Vsw5CDYIjdrm253ofLUN6nvhBi6ZBrWkzuloxlkjyYDXudDppOOsSVFQJUbgoF0422vIkbWmywpRX894SnRwFmMw2O/8bK1HybZYwDVKU4NNH9xomuLOEMbJJfso8z/1aeWSkrUVE3HRaWsYJ2HO65JJAUZlCjGBAi/Ar3Ud2EUydAgnCZ772EFeCbTgN2lTUxHa4SKK076AwVirE+AyMkoTNi/sC04Ex6tw5iBntcGU1iodffLKKOZkCSUXeYPys06jaCu1tOw8Pnsrp+DyIqWUTHp7E5NW2AmLXn+L835fT1eqV+2NQdLS479WcBFFyzEuEXCphH4v+g1aOB4b9Adg4qeKdp3Gtbp2o2zu4JSOaUx3oJziFC4BacQN5vPmhJTJj9VuTiP3/SashgM+yU9CnhOaMez4nzBe2BaHMcxCV4LtTpEPHxW9ycq0adA5y5L
 A9dGb6qK
 d22+/xaK4Cwd+2FWSBR2wrJnomOPGp6FVBNcTn+Dp89chmd9zUcW1q7VBzKhng6JV+thV03AGAzjX+vD+MMH4lItMAYs8WGoSfqeJrXZ5DeQSQjUfQWnI+dbQa/BpbTf1CnPMyJt3c0p93smXsYD3+qG5SfPZ2oRJseV2mjcgAEtngtY8/6thlV9odD6rlXq1RZbdZa04+vCFAIq5DQ35qwMOrS9hAXV4i3/NCzZnzLy2DyZv2OPDZjiki2VdpVXMi2/iwEijAMXrGLKnIJfTWLX6N7Xzoh6pWQbQtXXhS1QhsgEXmauIo097/o+FqXrXZzu14Xdk02evOQf7zbuwXG8EUiyhc/B18i/KS02kv3dJVp9ZHipED33phWfPobbYBHBN34e7AWKf/6RGRkZfXOcO/+9Fr4LL9nUXxAJE0o3Wg816urRHZRtLrh5quRmhkhBmSaYErcPjuc32KAGc8Oxfy/c7/ATr/UKvhCZqspYTnRvz/We+e99w6gYFSdh415JVvmZ3BMYXFduYKMV8RZ8Qrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Zswap writeback when the global pool limit is hit fails when memory
cgroup is disabled. The pool remains full until it is organically
drained by swapins or memory freeing, leading to zswap store failures
and pages bypassing getting written directly to the backing swap device,
causing LRU inversion (hotter pages with higher fault latency).

This happens because mem_cgroup_iter() always returns NULL when
memory cgroups are disabled. As a result, the global shrinker
shrink_worker() repeatedly takes empty walks. After MAX_RECLAIM_RETRIES
failed attempts, the worker gives up without writing back any pages.

Therefore, when memory cgroup is disabled, fall through with the !memcg
branch and shrink the root memcg directly.

With memcg disabled, shrink_memcg() only returns -ENOENT when the root
LRU is empty, which means the total pages are already below thr. In the
absence of heavy concurrent zswap stores, the loop then safely bails out
via the zswap_total_pages() <= thr check; otherwise, it will resume
shrinking the memcg after processing the reschedule check. For any other
return value from shrink_memcg(), the loop is guaranteed to terminate,
either after MAX_RECLAIM_RETRIES failures or once the threshold is met.

Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Cc: stable@vger.kernel.org
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reported-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index b5a17ea20237..48fc7b575e24 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1356,11 +1356,12 @@ static void shrink_worker(struct work_struct *w)
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
 		spin_unlock(&zswap_shrink_lock);
 
-		if (!memcg) {
-			/*
-			 * Continue shrinking without incrementing failures if
-			 * we found candidate memcgs in the last tree walk.
-			 */
+		/*
+		 * A NULL memcg ends a full hierarchy pass (except when memcg is
+		 * disabled, where it is always NULL: fall through to the root LRU).
+		 * Count a failure only if the last pass found no candidates.
+		 */
+		if (!memcg && !mem_cgroup_disabled()) {
 			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
 				break;
 
@@ -1379,7 +1380,7 @@ static void shrink_worker(struct work_struct *w)
 		 * and failures.
 		 */
 		if (ret == -ENOENT)
-			continue;
+			goto resched;
 		++attempts;
 
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
-- 
2.34.1


