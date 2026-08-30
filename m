Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D1DC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 06:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083756B0088; Sun, 30 Aug 2026 02:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D0D6B008A; Sun, 30 Aug 2026 02:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16B56B008C; Sun, 30 Aug 2026 02:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8EC06B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:31:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4123EA3AEB
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:31:59 +0000 (UTC)
X-FDA: 85156965558.06.0F39C12
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9095E120004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:31:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V4P9IsGD;
	spf=pass (imf29.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788071517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QjCEjlQx+exRVLDUDevoSIURgdv5YYALfDraYMLva0o=;
	b=EigsQ5d+QtH4gj+sKa+DKdPrU0jZ3WBJx1rLEv8jszx8xMFujbrcIxUxwRfpQEvd1D238C
	j3ODsS3ZIhHJKxAQu+tEILWEvMAEsZwxX3ZCmI3ihw62DBdvFHG6TobKk3EFwVwgURvz3u
	72iRZBR1lBG13EQ3e7ZxWX1NeZJJ2jc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788071517;
	b=58PW5zGXQ4rQIrhaDrKWTs7RjKHbcAr1ac2QyZSugsVIqkdvgpdR8bf436T9xh5elRC2Zx
	bHtF2809d93pbSnuuCFin1PnBOMg1tNOoQ4fOhm8vGhjvki4n6pxGHiy1lwE5zlF0lRHe8
	Wz6IC0Oo6XsCuJqzPb0ITaCcFQvfe38=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V4P9IsGD;
	spf=pass (imf29.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so2362155a91.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788071516; x=1788676316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QjCEjlQx+exRVLDUDevoSIURgdv5YYALfDraYMLva0o=;
        b=V4P9IsGD8pXLByK52aeQrMDAbsIL9qwRCs621rBHyWLhmrMEHwW+0t7hkhjqGLsrt7
         Devr4fK9InFmAh4zmZFD5AxE2mJJRFk7sdFLrFclk4cbEv98exDobWXLsTCX+HZefs7b
         dqibTkKp8brnX730QwKx3yrKcrZzCAxQX5oVtK0P3Eh6JDuFJw4B1TeMGljFa9ycZOLm
         +Rqc8vfTrxbDbcBibTnE7z0vV1saAYRDRIsIkKBQjyjvxvertBj34iwaZ3WZW5vzfYS/
         7hkQ85RM0MPb/zEr6ddgJt5CWg6WuVAJtzzIG7aVfJ1W9SsrvC6ANG52eFIHUeWsxXC0
         TLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788071516; x=1788676316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QjCEjlQx+exRVLDUDevoSIURgdv5YYALfDraYMLva0o=;
        b=A/jlgJnJRTW2Wt5YyOq+xbl+qk/QOWlaphLDmj9F3Mqqm/4l0PrMRfJOhuym9d2+z1
         33LAVAkALSUszK2C9mI7jlpiERymoapXye8zj/U5Ao605Mpv+a1cP9JSBmAKUbDVAR/y
         YvMLI2SG2PDuSb0AZVGJrRqfSAkUnjJ200u3Ztw286Qn2EZKL8HGD0fPewtp14cczJEc
         AriOuAHffXTfJaIwP9D6ZvQyFlM6aFrL48+r5YfOCwWpG1G3nHbFsOHzbwGES7OKlJCh
         pWLz5Grb5PXjg2Par8/uflN0DWHQrbUOxTenK8h9Y3U6XB0zXMUczKkpMWoH+FJGn4/n
         DmTQ==
X-Forwarded-Encrypted: i=1; AKwUvBwa0v779Bf+uWP30vWY9fpVkfCoSSSVwvsqaRG2iLelBugatQtpereFtF6V2wj6oFFfmU5HVkn6KA==@kvack.org
X-Gm-Message-State: AFuF++kiIwMuox7Sp34Pnwt1GrRGCvvvPMYklhw1AHRtABMfIY011ITy
	eW/XwDHuDzWnLNls7L8gQhlsGcueoIsP2k5jrxHYJnmbQSmzm4zoRYv8
X-Gm-Gg: AYBFou2cap6tFUiBfrYjPhE+kbiXOZ17+sAk4LrT/CPInx5sO4ykk3jWSp9l1fdLted
	qOO+/Sfaa9upsKwH47XfIb04aVmccIWbzqkgditBTzrnUaOBnAKWqus2JwBofXwoZrqesmRSWBG
	zA6dHrc43guv+OR+rAcwn9o/cDDiSEqtnp3f42cv1LHcCtMyDVd1nxwvlWbgpoP7nOB6NGeSlPa
	pRc/58zx4BvgC7LRd5hKmS+cwBmGIp+VSLJz6K6Pz4ujgPTYAYPl52Q/NaUBWzlx8I1ntBFq6gT
	UggL+mCVZ4D43/SXGkv9vI9Bk10gF2xhk2CVAjnkTMq0ggrp+2ktE/pf5uZcfRk8Ig3nmYg4jad
	W/URtOH4ryXRZM83rh31wm7aTqyuIwBBESbYN+FH0FckMYWv6LtQ0VXprsF+UG8VFBMTO2KPu+i
	8JBhdlrEOv8jKY5ZLQxxN45n38GSvx2miRPhMT1nYEtg+V93A7iQxyIMIPNVpjLM70cyOw1T8WZ
	UwkMadd5ksWJ8F4
X-Received: by 2002:a17:90b:55cc:b0:38f:657:6823 with SMTP id 98e67ed59e1d1-398da65a974mr587978a91.8.1788071516309;
        Sat, 29 Aug 2026 23:31:56 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396ddc0c703sm10079411a91.9.2026.08.29.23.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 23:31:55 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: fix unconditionally skip last region
Date: Sun, 30 Aug 2026 14:31:50 +0800
Message-ID: <20260830063159.6347-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9095E120004
X-Stat-Signature: gkfh7bomiimyr8nf897hynezfe9c7dix
X-HE-Tag: 1788071517-691005
X-HE-Meta: U2FsdGVkX19iEAu6LlxPWAfBKiebQ55r78FJ7in+mpgF/ZI83a/JC6lG0O+2Mhmvg2+xDPTcyEog9f8Od7EY7qwTSz5nwduJBdMKX29LD/9PfBdaERuCYkHJqXmyB2pCv2EKfrFfq0zdYmtZkwzGCYvC5ocakvNIW+JpA1Y0PeNIHLyrKw90zkkuVzDDUA3Y/uYaqueDrkKmT82CX8ek7wGRL0qcLHiaO/XUGkW3L8BuvblP2+qK2HPEMPEB/jKycTZf7EFB+9Lr4KSnjH4Zm8//gc8ilwLS+h1pJ3Qw751Ywxw0hnNtelhdYgYZdPJi10oWhxq+Mb98jT0k4l7LMtPXLd67SLBzBjgr5ACDB454x5RZDsabr+hGbZP5emv0BHLk31r+E0WJZDkynvknQYMm3JcpR78ymJg5gqJvLPWcrBZTqYzKlReeR2gMwedKg40/Rf6JdNGmyvVzTHZFL53I8Eca+JXEcTYWF1UlPT+H4QNIKxLFnOnKVih6rR4XVmK8nNxt8hSjIc9fnA2ILxR7dNHspUrHsKLIJ3jGAhVf7/NTTEghSLHc+DGxk+KtIZUodPps+9RoLbwq/arTyXqmvpnWVk37Pnn2KiWWmRLiY+7TPoEWmX7Kz3bZNSJsWFS96j6HkqwxdrlSAb/Y7/y/5KfdRlrOezTeezNHyFQiwx4i4SkTP4aGkYAt5/oLkQYvlJUYDs7AEsP/Jec5dLIpKilF7Qfl1Rx4Nvm/khCXAHz3+p0kf8H7Rdrr2NjUiEzR++rqUKezcMm6aCfjvh7zCFZ5cEZZVemxnHGx8A0wS922LMe8jIEBRJFql1NOVcPj/OKemedoAr9gQ7HLqfAwUyzBobYzqh7/O9WfSugB7sqW5HkAxfQkyu8d3w69Pj1XMd4t/S0AlTYB+SRWuDvcKW1vhPI+UrFcBK03SwDUPj58B0kov8hOfYjwZni5rQ9/CG93tpMybTZ2zm6
 YkAOy6rX
 kkvGfokAvR5CUn+CYcik5TtlSPxqRK7fL4rCAccQXHEbuMVjFKqVoR0N+e3sn1zA3OeIKmR6gAk5W86r0sU9HUarhYx2CVLRJMJV2leLeqTP59VlFmtM9AZdkv7A4FAmBwMYeG8zLiWqzQSYCGlRhWmUzzJN5Nbw0dATibO48kSvfjsz6koUmJdg4Lo4RFkWH8g+8YQWePge8vHwVpu/UOQt9YR9RBNx+LvRiKFB7Q4F2AjlzU8EzqkxkJZOsn0c5JMsK+W5Hjlwm32SFM4/ZV59ghCFapt+wFQRvx/dbirbLkD3+fm2ar/W8gFjA9ZHZZKZ6oqztWpUhm151jX0WIOxJ6KgMQvPvmJNqrOeC7zMy6UX0lihm43LTQvEaMBi7DH0Gxta4aahqquVdLvrIdgbsK2sFyNBcG26oWyA8MvTDzzfYrCL6/4AottZWuKLs8/1/xbnbeoI55Rx/CAQmD8YCxqL4DPxAVBeiXFvg+mvdObU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once quota set, the charge_{target,addr}_from unconditionally skips and
resets at the last region of the tracked target, so the last region can
be skipped even when it has not been processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

However, it is important to note that this is a very minor issue.  This
is because it is triggered only when the previous window saved/kept
charge_{target,addr}_from, and in the next window, all regions except
the last region were skipped by damos_skip_charged_region().

Fix this by only resets the charge_{target,addr}_from when last region
is reached, only skips when it applied or cannot split.

Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Cc: <stable@vger.kernel.org> # v5.16.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from v1:
- Simplify example in commit message.
- Add clarification regarding the severity of the bug to avoid causing
  users unnecessary afraid.
- Modify the patch code, each time the last region is reached, only
  charge_{target,addr}_from is reset, but the return value depends on
  the situation.
- Modify patch's title from 'mm/damon' to 'mm/damon/core', since it only
  changes core.c.
- v1: https://lore.kernel.org/damon/20260828084737.290024-1-aethernet65535@gmail.com

Changes from RFC v1:
- Minimal fix, only fixes the issue where the last-region is skipped.
- Add an example to the commit message to demonstrate that this error
  occurs very rarely.
- RFC v1: https://lore.kernel.org/damon/20260825124616.5129-1-aethernet65535@gmail.com

---
 mm/damon/core.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..fb76b530bbc6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2342,36 +2342,39 @@ static bool damos_skip_charged_region(struct damon_target *t,
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
+	bool skip = false;
 
 	/* Skip previously charged regions */
 	if (quota->charge_target_from) {
 		if (t != quota->charge_target_from)
 			return true;
-		if (r == damon_last_region(t)) {
-			quota->charge_target_from = NULL;
-			quota->charge_addr_from = 0;
-			return true;
-		}
 		if (quota->charge_addr_from &&
-				r->ar.end <= quota->charge_addr_from)
-			return true;
+				r->ar.end <= quota->charge_addr_from) {
+			skip = true;
+			goto out;
+		}
 
 		if (quota->charge_addr_from && r->ar.start <
 				quota->charge_addr_from) {
 			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
 					r->ar.start, min_region_sz);
 			if (!sz_to_skip) {
-				if (damon_sz_region(r) <= min_region_sz)
-					return true;
+				if (damon_sz_region(r) <= min_region_sz) {
+					skip = true;
+					goto out;
+				}
 				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			return true;
+			skip = true;
 		}
+	}
+out:
+	if (r == damon_last_region(t)) {
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
 	}
-	return false;
+	return skip;
 }
 
 static void damos_update_stat(struct damos *s,
-- 
2.55.0


