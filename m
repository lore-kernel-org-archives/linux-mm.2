Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97BAC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16626B00BB; Tue, 25 Aug 2026 08:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE036B00C2; Tue, 25 Aug 2026 08:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDDAE6B00CB; Tue, 25 Aug 2026 08:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 834D66B00BB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:46:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87D781A03E0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:46:15 +0000 (UTC)
X-FDA: 85139764710.02.81B527E
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6274140006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:46:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GTd+8ZAp;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787661973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a2Asa4hLurNMrCEVCTFHSXC6wwWf0Qto8+IsnkijKbg=;
	b=lRf4TrIUSnx/msExeEqaklIHiaR2ri9hOYnMLbTtcSqlm60ME7XVeTLvRubYpNbWHkS27v
	by4EAbas05o8r8iEkgKFMf/6FbDkLEnvRRyxdNLC6bkTiL9dMMAPTJUSY1CqTw0Brt/9ix
	LihHrH/634PXM8OC/8wBtdiZ7TFYSR4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GTd+8ZAp;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787661973;
	b=LQseFgDHLCJ6hKhrn+yGNhBpF8kjoiPQ8so45LanHv4+scLOO0nQKISAxLID4mRXPEWmxB
	k0SHNpSyPXviRAPJMZCDz3rzXyY91p4aCOQgtodqMQyZfss+1vjytlQxcEy0SpWnHnIdm2
	YuVdC4NKMex1yccnii6tEagHn9R11qY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d6f55a7089so6180875ad.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787661972; x=1788266772; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a2Asa4hLurNMrCEVCTFHSXC6wwWf0Qto8+IsnkijKbg=;
        b=GTd+8ZApbx79wCd93acgcAz5Hh9gL5uUgDc6fOW6bbsfcAUN2kqmyBH0Q1vZGXhbJJ
         TCPQ5RUq+gBJ+CDPwKkndtiQx8/XWCGlF0cftMlQdqAHlwx7XNphuft0Jz3ugKKLySbt
         IgFvJvuewWqJe0F3ios/h2QIYZ+XiLhcXCDsVyZtziktKtEiQgoTMeCXdzSdOd1GNx+z
         dXfZsUBWAMESljMipp5DMx9l1jtNUpgoTuNT8ESGl201fIEWRoARftF1tAzC6QU2KT1r
         Kb8AfzV0zliBuCjvwl9b4FUDk7A6UyxjTWupd/pmDz3EaNPTSN0cA9VgC293gNF0sEab
         olFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787661972; x=1788266772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a2Asa4hLurNMrCEVCTFHSXC6wwWf0Qto8+IsnkijKbg=;
        b=BVvzJZxMVUyvSv7SApHtr7jKB4E0WnSbQOCcF2Gtlk2bnj3ahXrtOwqy5IwIRSrgVt
         a9O9OOOcc3TvdiXN3+dgDXvLrk1vxhR5JL1sDzPdUCBDBSvzZ/yY88yzv9UzcllBAe92
         gtCE041e34Wc/dUSDm1hR75J4odQVeeqIFF6wpFBcGsJVGE5sscCKAL+rVMQFOABpdQ4
         2GWQ6lANrPwkqmcFOj0zu6nYuU+KvDgtZSn4xiyk56af1Cc3ratldqFLdCOnQPepkTEw
         EqNwwZjR2RN1xCLSsfG+aQRrj4RuW5KH0WSmpHjBNyWLfPGnxaArjsPvfXa46G60ONjJ
         QKIg==
X-Forwarded-Encrypted: i=1; AHgh+RqGHwssvV6QIUu49ZkJiwjU+63/SCFQ9omDX7CwQ3Ac6TVN6PJDzSzn9dhpM0bXzrV1zSaMMdyX1A==@kvack.org
X-Gm-Message-State: AFuF++kyWE2dcbDDVayDqrxIDqJukeOJmSbc6IFcGp1FdUHz5Zf6/zjM
	Mh2gAxP+QtgVx+0sK18kpfD06oHdlaZwwc+o105fFpOq1bYOqM+421TB
X-Gm-Gg: AR+sD12kmLX61TCxWIFd8kmJHboaY16/EUrrG0nW6VyeMP/TIOYFnsbA/rdJ1cuyhgr
	4fO1tpmzRVMM6LVXT7K3S43Cuuzb/igUrWCtNwo9ihdcxN193sL38jGxhOaG+4DTVXuxOgETdob
	0SV/7grMbLOZ5zmEeSHxn5kwneT7LQVnr9XxWLWz/DUj42FulpRzrG+yQwEg54qsvrcU7Ix2TwS
	MDDr+dYEzN0uXJxRm1O1ms0oUytDPs7s7mOU55bLxUIwpy+cnE82mWEXN1jIv5Exa8iPyt5Axtk
	Jj7QtI3pQSdhDX+0/XT2rMOWmP3amxKLlDJps4TQ2me3SmV26Ka2Rc7F/+k2pnUw57xl8hAmbIf
	xD/bv581bY9ohTmOn0l+6yjKIKvO71Wt2QhBoUvD9s0JDZLwf+e/mS+mejllp/9AUHHUaM4Y62X
	AnRm4ZVp6GCX5Oc+dIqXWtZajo9c5pEeLsuN79BGKEnpZCffaETRzzxxYYrlUdG+3K/JWA+x9h0
	3tSciBKe58tHfkIOgO3HxoC88Q=
X-Received: by 2002:a17:90b:3811:b0:393:288:29e3 with SMTP id 98e67ed59e1d1-395df24f20cmr45613753a91.10.1787661972204;
        Tue, 25 Aug 2026 05:46:12 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:c23:7fa2:94a9:2164:3642:a5a8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645c06e02sm3738983a91.17.2026.08.25.05.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 05:46:11 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Tue, 25 Aug 2026 20:46:16 +0800
Message-ID: <20260825124616.5129-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cg5apbcgz9rhjiujwoguzoo7u4yboe4d
X-Rspamd-Queue-Id: A6274140006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787661973-23046
X-HE-Meta: U2FsdGVkX1+eel9EsmQsWNgSjGezK2AFx/cgi2wbKaTgo/3JvGYX9bKBNxa5mX93SLXMte/203RuLlVuGuxViAyDYEW/FUr98W+Iuu5sbIxStEuWiidPGDalV/JhX+jV7xa4BZv0agVnDy+0q0h8LN64cdZRBxOivj55RbgWs2sRL+dryJ9ons4LLZjR0w3TSLzcSvZjMYoiAd5fzsSVBCN2B1Mi9P5YiQeYUSUkZ9uXGmzmf1BgquhJsaTmLrJfx6NmOprovM8HCSjy+YHuy5in8Sl2iXoly74D5RXWZ1eVNsUxvOY/5UqkJ1coV5/FDxb45MSw03w4S4tQuMV6gUx73ROA+RG1LIlWTzk1qpb3tSZDH3s/BjGgo7FAvGPKSgN01OPxBb0Wxem9lPHUDPRqh6Hq1ygJx9L/FHH+8AMDlyt4KhZ9anAqKJ/JqNlb61BCrgPgJS5p5Edf7PViGlum9uQ5Lr6QcGu4C/QuScvfonWEPe3LeCtxUCxLM8p/jyxCeHneHBuNUbYS7Qh25OwHfz3lWjQZ+2rhZ9ReCE15ji9CJ9cMk0ITosRuXEOu3IJjnFSgkWDK2/TyY1GUcGZLtXzR8261VLUFsUfQtC0Gs6jAzt0hSyxN5GkPRrmWBtqDhi6sLusUQYsf3o7uNcFBGO3BUnvwWN9zU7jWRPgn4iFziLbLV6TaWM4fht4dCIGkDsWadtCxYHt/52LV+CSLv/WKj3Ib1lvHpmYSSBQxvN4nmbD5x6i/kkEjfyNh5mwDS07W/zL56DjTcVpn1NIKd8TQvs1ijlB+i2kxyM1gfKr2KTauB7uVyY/lgB3wBskHbIHcrBUX4+Gc8zUV5EMyzI0py7Vphzk7Y4bji7YbwAmv2Rf/q44O13q1R+Rv7Y1lGVhPCiUaoDBVApWal5Jn6LNs1E544BaGSg8x3mcquWvDk3TLgL34svVyxqb7S6RGiX4Lot34/46irCj
 ccluoxJS
 ITvJmhmEPzf48BQAKEYsfkdqlofixhxf/Fh18T4t1Ih+VzLGbnvmPgMFQkWMACqOQ1/TaL9Cf5+F0wG0+vi5CTGIoCRiKBrfZPu8IIliP2+xqVNIH0+umKuRWfpaeVWU5AQXL5gsgAG/jffrSukJRcnAOHZcJjpxGA/X6L9HzXgHdmS4lww8b6VXUFDZZZe9Cgyeom7n0J7bQZCZvNyUNSsgaXq6jqDXLDLkQ0RYuTKIYhjNCz3B0luCmRsDFteawYbFcONC/Gy5My8kMfgwfz1QZHsfg7DOvzIFYV2fu7vd/VLdQEw0GCjCwzqjqSqBko3uK655LL/KB5hWlBDkOOb9wCVZ3r+HUH1KvhhN+1zDnF1JrnlHdHbD9yfJmkTUtVuLruooe2kgion9sTqYn/h0Qd/rOlPr9a5iY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS uses charge_target_from/charge_addr_from to remember how far a
quota-limited walk has progressed.  The current implementation has two
problems:

1. Once set, the cursor unconditionally skips and resets at the last
   region of the tracked target, so the last region can be skipped even
   when it has not been processed.

2. The cursor only advances when the quota becomes full.  Regions that
   are filtered out do not move the cursor, and the scheme can remain
   stuck on the same regions.

Fix this by treating the fields as a rotating walk cursor:

- Advance the cursor for every region walked while a quota is set,
  regardless of whether the region is applied or filtered out.
- Remove the unconditional last-region reset.
- Skip regions before the cursor, and rotate to the next valid target
  only after the current target has been fully walked.
- Rename charge_{target,addr}_from to walk_{target,addr}_from and
  damos_skip_charged_region() to damos_skip_walked_region().

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 include/linux/damon.h |   6 +-
 mm/damon/core.c       | 156 +++++++++++++++++++++++++++++-------------
 2 files changed, 111 insertions(+), 51 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9ab..5e0755ebad75 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -296,8 +296,10 @@ struct damos_quota {
 	/* For charging the quota */
 	unsigned long charged_sz;
 	unsigned long charged_from;
-	struct damon_target *charge_target_from;
-	unsigned long charge_addr_from;
+
+	/* For tracking the DAMOS walk position (rotating cursor) */
+	struct damon_target *walk_target_from;
+	unsigned long walk_addr_from;
 
 	/* For prioritization */
 	unsigned int min_score;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..bbdb530513a1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -404,6 +404,52 @@ static bool damon_is_last_region(struct damon_region *r,
 	return list_is_last(&r->list, &t->regions_list);
 }
 
+static bool damos_completely_walked(struct damos *s, struct damon_target *t)
+{
+	/*
+	 * '>=' instead of '==', because the region set of @t could have been
+	 * shrunken by damon_set_regions() after the cursor was saved.
+	 */
+	return s->quota.walk_target_from == t &&
+		s->quota.walk_addr_from >= damon_last_region(t)->ar.end;
+}
+
+static struct damon_target *damon_next_valid_target(struct damon_target *t,
+		struct damon_ctx *c)
+{
+	struct list_head *head = &c->adaptive_targets;
+	struct damon_target *start = t;
+	struct damon_target *next = t;
+
+	while (true) {
+		if (list_is_last(&next->list, head))
+			next = list_first_entry(head, struct damon_target, list);
+		else
+			next = list_next_entry(next, list);
+
+		if (!c->ops.target_valid || c->ops.target_valid(next))
+			return next;
+
+		if (next == start)
+			break;
+	}
+	return NULL;
+}
+
+static void damos_replace_invalid_target(struct damon_ctx *c,
+		struct damon_target *t)
+{
+	struct damos *s;
+
+	damon_for_each_scheme(s, c) {
+		if (s->quota.walk_target_from != t)
+			continue;
+
+		s->quota.walk_target_from = damon_next_valid_target(t, c);
+		s->quota.walk_addr_from = 0;
+	}
+}
+
 /**
  * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
  * @r:		region to get the weighted sum of.
@@ -673,8 +719,8 @@ static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 	quota->total_charged_ns = 0;
 	quota->charged_sz = 0;
 	quota->charged_from = 0;
-	quota->charge_target_from = NULL;
-	quota->charge_addr_from = 0;
+	quota->walk_target_from = NULL;
+	quota->walk_addr_from = 0;
 	quota->esz_bp = 0;
 	return quota;
 }
@@ -1628,9 +1674,9 @@ static int damon_commit_targets(
 
 			damon_destroy_target(dst_target, dst);
 			damon_for_each_scheme(s, dst) {
-				if (s->quota.charge_target_from == dst_target) {
-					s->quota.charge_target_from = NULL;
-					s->quota.charge_addr_from = 0;
+				if (s->quota.walk_target_from == dst_target) {
+					s->quota.walk_target_from = NULL;
+					s->quota.walk_addr_from = 0;
 				}
 			}
 		}
@@ -2312,64 +2358,54 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 }
 
 /*
- * damos_skip_charged_region() - Check if the given region or starting part of
- * it is already charged for the DAMOS quota.
+ * damos_skip_walked_region() - Check if the given region or starting part of
+ * it is already walked for the DAMOS quota.
  * @t:	The target of the region.
- * @rp:	The pointer to the region.
+ * @r:	The pointer to the region.
  * @s:	The scheme to be applied.
  * @min_region_sz:	minimum region size.
  *
- * If a quota of a scheme has exceeded in a quota charge window, the scheme's
- * action would applied to only a part of the target access pattern fulfilling
- * regions.  To avoid applying the scheme action to only already applied
- * regions, DAMON skips applying the scheme action to the regions that charged
- * in the previous charge window.
- *
- * This function checks if a given region should be skipped or not for the
- * reason.  If only the starting part of the region has previously charged,
- * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow, and return true.  The
- * caller can see the second one on the next iteration of the region walk.
- * Note that this means the caller should use damon_for_each_region() instead
- * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
- * the second region will just be ignored.
+ * When a quota is configured, DAMON records how far it has walked so that
+ * subsequent quota windows continue from that point instead of re-applying the
+ * same regions.  This function returns true for regions that are before the
+ * recorded cursor and therefore should be skipped.  If only the starting part
+ * has been walked, the region is split so that the remaining part can be
+ * visited.
  *
  * Return: true if the region should be skipped, false otherwise.
  */
-static bool damos_skip_charged_region(struct damon_target *t,
+static bool damos_skip_walked_region(struct damon_target *t,
 		struct damon_region *r, struct damos *s,
 		unsigned long min_region_sz)
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
 
-	/* Skip previously charged regions */
-	if (quota->charge_target_from) {
-		if (t != quota->charge_target_from)
-			return true;
-		if (r == damon_last_region(t)) {
-			quota->charge_target_from = NULL;
-			quota->charge_addr_from = 0;
+	if (!damos_quota_is_set(quota))
+		return false;
+
+	/* Skip previously walked regions */
+	if (quota->walk_target_from) {
+		if (t != quota->walk_target_from)
 			return true;
-		}
-		if (quota->charge_addr_from &&
-				r->ar.end <= quota->charge_addr_from)
+		if (quota->walk_addr_from &&
+				r->ar.end <= quota->walk_addr_from)
 			return true;
 
-		if (quota->charge_addr_from && r->ar.start <
-				quota->charge_addr_from) {
-			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
+		if (quota->walk_addr_from && r->ar.start <
+				quota->walk_addr_from) {
+			sz_to_skip = ALIGN_DOWN(quota->walk_addr_from -
 					r->ar.start, min_region_sz);
 			if (!sz_to_skip) {
-				if (damon_sz_region(r) <= min_region_sz)
+				if (damon_sz_region(r) <= min_region_sz) {
+					quota->walk_addr_from = r->ar.end;
 					return true;
+				}
 				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
 			return true;
 		}
-		quota->charge_target_from = NULL;
-		quota->charge_addr_from = 0;
 	}
 	return false;
 }
@@ -2627,10 +2663,6 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		damos_charge_quota(quota, sz, sz_applied);
-		if (damos_quota_is_full(quota, c->min_region_sz)) {
-			quota->charge_target_from = t;
-			quota->charge_addr_from = r->ar.end;
-		}
 	}
 	if (s->action != DAMOS_STAT)
 		r->age = 0;
@@ -2639,8 +2671,19 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
 }
 
-static void damon_do_apply_schemes(struct damon_ctx *c,
-				   struct damon_target *t,
+static void damos_walk_maybe_rotate(struct damon_ctx *c,
+				    struct damon_target *t,
+				    struct damos *s)
+{
+	struct damos_quota *quota = &s->quota;
+
+	if (damos_completely_walked(s, t)) {
+		quota->walk_target_from = damon_next_valid_target(t, c);
+		quota->walk_addr_from = 0;
+	}
+}
+
+static void damon_do_apply_schemes(struct damon_ctx *c, struct damon_target *t,
 				   struct damon_region *r)
 {
 	struct damos *s;
@@ -2658,18 +2701,31 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
-		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
-			continue;
-
 		if (s->max_nr_snapshots &&
 				s->max_nr_snapshots <= s->stat.nr_snapshots)
 			continue;
 
+		/*
+		 * Skip regions before the cursor.  If the skip makes the cursor
+		 * reach the end of this target, rotate to the next valid target
+		 * before continuing with the next region/scheme.
+		 */
+		if (damos_skip_walked_region(t, r, s, c->min_region_sz)) {
+			damos_walk_maybe_rotate(c, t, s);
+			continue;
+		}
+
 		if (damos_valid_target(c, r, s))
 			damos_apply_scheme(c, t, r, s);
 
 		if (damon_is_last_region(r, t))
 			s->stat.nr_snapshots++;
+
+		if (damos_quota_is_set(quota)) {
+			quota->walk_target_from = t;
+			quota->walk_addr_from = r->ar.end;
+			damos_walk_maybe_rotate(c, t, s);
+		}
 	}
 }
 
@@ -3241,8 +3297,10 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
-		if (c->ops.target_valid && c->ops.target_valid(t) == false)
+		if (c->ops.target_valid && c->ops.target_valid(t) == false) {
+			damos_replace_invalid_target(c, t);
 			continue;
+		}
 		damos_apply_target(c, t, max_region_sz);
 	}
 
-- 
2.55.0


