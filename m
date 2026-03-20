Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03ED71098792
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568936B0158; Fri, 20 Mar 2026 10:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5191B6B015A; Fri, 20 Mar 2026 10:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455A76B015B; Fri, 20 Mar 2026 10:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32B036B0158
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:37:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 068F01C834
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:37:00 +0000 (UTC)
X-FDA: 84566693400.28.0331A4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 56160A001C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:36:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKVTp6KA;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774017418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7MVlNBLUjEykXVLpYkz3REm+wG6tnG8fASZNanjWYds=;
	b=NIaZii3WANOVqTDPq7sDilEKsEWmWut7ZhGzICnspRQtX2Q0vjH8UilsyCj1TAIoDBvRMP
	O2Y/dvcCB/kxm8mWmqD0MREmXag6BPNWDANo+3Gqq8n8gGRw0AzLEfoXyIWX+2U/vp9Dgd
	mcNweFosFSA0danqTWM9zEBsHF2+X9A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKVTp6KA;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774017418; a=rsa-sha256;
	cv=none;
	b=xzdMy81K6xu2jrbq7z1hAiAH+UkoxkgUUErrAvfqlIgjmgaHcgMpTus7woN51NbIQzMMCu
	SSRWbUYcYh4e9FFjgbldpjrxB3EnKU8kYI7x1pW//6z2Uml2ubNGsUxUu22w4w7HmXDS5Z
	R2mP/8hd5yNGqeklisbCje3AWUsa9D4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51A9943ED1;
	Fri, 20 Mar 2026 14:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B720C19425;
	Fri, 20 Mar 2026 14:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017417;
	bh=57rJfUQAzyJc72kKvlo3Pe8XwVTNUIRzo2jHH5/276s=;
	h=From:To:Cc:Subject:Date:From;
	b=oKVTp6KAQCxqCCoKSLQzOOSP35j2OIp7iBzMm2hm2Pcd7chbFmWhl0eOFJn1ojRR2
	 as0eQmcmZk6Kc2mbV2yTAXZmd8qtl1UEfzZW6Eh9qh46HJFHrdscn7YkMXrnQfYb3A
	 v4pfhjFDR/jKcOU+DbNbDLa/sLuA2AHQQ9z33yZ2oGHeGoTQvMKZ8ibkHX2smSkLU8
	 /7p0PnQvO2VDEbrRs9Zrgm8KfiSoPPZeGAHoMY29yewq0WiwYzY5GXLaksDcuPkMxd
	 1hhn8+VCJY4LnOYHQD3rrQ5uvl4G8IRXw2+NqfOS1ADvgPeRkHuL/CEsp5y39BMyam
	 QWf1OkLYGZYdg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Law <objecting@objecting.org>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/damon/core: document damos_commit_dests() failure semantics
Date: Fri, 20 Mar 2026 07:36:45 -0700
Message-ID: <20260320143648.91673-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 56160A001C
X-Rspamd-Server: rspam07
X-Stat-Signature: wy7nmp4gwbmhaz1ayy31xonktqa858r7
X-Rspam-User: 
X-HE-Tag: 1774017418-473507
X-HE-Meta: U2FsdGVkX1++tKyrEnWdQKDvyl2tje1vumRUEr41z+zzMuYM3QA1IpJ2h/zMqDJ+fKsGTQkltNreJABoxj/L+1/XHEnT595aBP9MjR0U7/Gdg3TVO8CqJBP3owc4fe8LoDKLlreiJ84iZ9o6km9NKdX6Ehnm1QvYAlYPxaghmUKccACbbMdo/iERAtUkpn0kXcUgaNOA5H3i9d6ccV10GjjQ5iVRlVGTYa8Gm39D0plbOsE1E50IKTSXnxzejRRzzJHzcEWKnocm4hUDsUZRG/s6Co3vOtZZUruDqRrvbC16hsdhCuPjefipyUtUSwXcPfq3VdeZLXatHf+txIYi0ckQQLpXh2IvDj0p3iO77RBklKLKW+6jKo9Vc9NwODsIHjtTy4sTTGzIRhfB0RM2ZOS7SxRmftjitSHrMgWO67mqVQhnUKeP8lGd3i6j6HCjAO1OLJZFThA7ddY0imppqduuLPXGIW5E9gfVTjpB/wYnpg/qSL+OA3rMAMQPkOrvLws/qSuzj86DEygIOzSfEgPoUG3a5UuQCW/n8ZZ9qxrAKPuwCNBUSiNTJCmBxvORzMDHcQ3awC83IegNoR3T69/CBU6kTlnaIMeKFdy+CkCMA4AqBCPFXxUPE0kRi+vMWvWgRBFAMxYPoakJA7OFySi6lzY6ZdKGjq0dbKmWSdl2PoH7gmQQvlR6NhqzB6SBbuCY9R9HkeTBDLT4qPjfAcdCYGoH//RWFVaoz45sKKHQarqsRIcjM8tXjnu3KgozykuwnK6weWXGFCyuyNo9amO3a1mJroWDCppFCl7CjRwuEL5zywk0+27p3aSg+tjbBRuTmSHg+dr3h4eNZ2Sqnr2r+XRuRF6lLiBeRNjzKAJGCj1yTnzD5imcKNUqgkqG/bKpKj63VfJEDVWVUKDmIMKRxkIFrV2OZiy8Cyu2Ioy1hYFEWAdeCrXhCA1YAhCNP5TWHaaC3g54PIzbGH+
 quCZRrhg
 T+XdjMt9X1BsyROagxzUMq7eK/JyW6q8WBMIUHCJj2QdfcMYW/didP6wuSmEF8jXBaDKYNYEuaHmHUql5sXtcI+AGnsrpAdviyTUnsSv05VngviJzO2UV1XAI3TYP8iYS7BlE78VnGhQZsYws4QewYH60qtZV+gY6n0adsXG30VSxo32qTv6uZdp459q8Dr+DCu3x0NnfaXIdzMb3IKUxZFnw4os1gZKtQWOYLApnP1xOhHa+UHznsy7gqGgy6CaC+QU70s+PNBDoYfgqWGu4byr//pncrypnn32YIteuMRsk4Yt6W/xRPYG7CJqzOaScDVCzJzGftvKpp69aehFGMAUPrEmexdMje5OPUMg9LoFE6ervXt4Z6B1H24um2K9KlbfQvO7Knb3uqPzzSF0bF5DsuwLlzK2q2yrIjDj3U9KH9jg+YW6qgsRuEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <objecting@objecting.org>

Add a kernel-doc-like comment to damos_commit_dests() documenting its
allocation failure contract: on -ENOMEM, the destination structure is
left in a partially torn-down state that is safe to deallocate via
damon_destroy_scheme(), but must not be reused for further commits.

This was unclear from the code alone and led to a separate patch [1]
attempting to reset nr_dests on failure.  Make the intended usage
explicit so future readers do not repeat the confusion.

[1] https://lore.kernel.org/20260318214939.36100-1-objecting@objecting.org

Signed-off-by: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lore.kernel.org/20260319071332.114595-1-objecting@objecting.org)
- Use kernel-doc like comment instead of kernel-doc for static function.
- Add a link to the previous discussion.
- Update description.
- Rebase to latest mm-new.
- Collect Reviewed-by: of SJ.

 mm/damon/core.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4dae03a37f9ac..df9f5e94e0ddd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1060,6 +1060,23 @@ static void damos_set_filters_default_reject(struct damos *s)
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+/*
+ * damos_commit_dests() - Copy migration destinations from @src to @dst.
+ * @dst:	Destination structure to update.
+ * @src:	Source structure to copy from.
+ *
+ * If the number of destinations has changed, the old arrays in @dst are freed
+ * and new ones are allocated.  On success, @dst contains a full copy of
+ * @src's arrays and count.
+ *
+ * On allocation failure, @dst is left in a partially torn-down state: its
+ * arrays may be NULL and @nr_dests may not reflect the actual allocation
+ * sizes.  The structure remains safe to deallocate via damon_destroy_scheme(),
+ * but callers must not reuse @dst for further commits — it should be
+ * discarded.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
 static int damos_commit_dests(struct damos_migrate_dests *dst,
 		struct damos_migrate_dests *src)
 {

base-commit: 4fbbbf18fd43c2d7b692749b7c853157f901b709
-- 
2.47.3

