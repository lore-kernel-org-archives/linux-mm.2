Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246FAF531F4
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 06:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1666B0088; Tue, 14 Apr 2026 02:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8FA6B008A; Tue, 14 Apr 2026 02:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0996B0092; Tue, 14 Apr 2026 02:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3205C6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:52:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2F9CE372F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:52:17 +0000 (UTC)
X-FDA: 84656242314.09.4230FEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 46CDD4000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:52:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l3OfO1zr;
	spf=pass (imf12.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776149536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FA20Xc9pAW1o0Por0z9BI3IS44NlGYpjhrvnhRi4JIk=;
	b=TwpgXl2c0gdc19YZOBfW4ALwfLx2U6bBB9h/WuIoBd5YeXWNW5gG4qYl9Oqiqr/oKbhlrB
	scLX6csC9LvgOrcyg9Kp46IOVow9X6QYilammvZnSOxWIZldcJ3h74U9SlDpgUP7e5hvUZ
	pDVLMzp2QVMavz8TgZKpuRCHUHY/iSk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l3OfO1zr;
	spf=pass (imf12.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776149536; a=rsa-sha256;
	cv=none;
	b=pCiTXfYK8VYdjUs4C1M83M/QKp+xnMWsu4vrR5PItaRe43CT1uvHJzI9IUG4hVwdXRFg5+
	eAzZJcy0bIe2MZ751k8LI6Mv0uOUYoiknGnJ+s/iiFNk1oRFFNA2sN0TTrwBQs605bSjUs
	ssw5/CaLzjdof3j7q+OnlvnkZ8P4sJ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94E5B60018;
	Tue, 14 Apr 2026 06:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F241C19425;
	Tue, 14 Apr 2026 06:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776149535;
	bh=kIgQxPIstY5Hnf2wEsVfMAa0QL5Z30y6cxFvGVD83Vw=;
	h=From:To:Cc:Subject:Date:From;
	b=l3OfO1zr+4AQtU5i3EXFDuZK9ABQGbrNJ7sYLgItekge5HMATapGwK4GvA2hApyyx
	 I1Dwc5fjPTnR7lQ8IsGoQEOSkVk9tarUG8F0LRPaftZNYVwkVXH1vkitYZu1uRkghc
	 BwJhkI8/s/Oaj0jLkQ0VJAS+aG/92A4BZLVDYGp629tGpDPcxLwyEAm2uL5Et74ZG5
	 Vl917h5pkpKHzBOJ/QsRYhpGNyzdkmyhG4GuXvcoYNOr4NXxbxmswyt1iFrp1uz6AL
	 Nc2xaBGx98FhBywR1H/ovvXg3l7uduOuPMnLGyuxVgfg1ST8TAEE3sewS71C8y3Czu
	 xEqzqzYldOavQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Koichiro Den <koichiro.den@canonical.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] mm/vmscan: avoid false-positive -Wuninitialized warning
Date: Tue, 14 Apr 2026 08:51:58 +0200
Message-Id: <20260414065206.3236176-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tye98uxubptg1hhe511mwgdyupggi66z
X-Rspamd-Queue-Id: 46CDD4000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1776149536-961309
X-HE-Meta: U2FsdGVkX186L0r/loyXr8OyYMk0Czx6mc001oXIxLd0WMY96gH0HwIIgH9ht5bn3HzAd53xZd8lR4Q9AMs03i521Ksyk15XfAN4QSR0vw2xLTs5bVBunBmMxhWrUrsu33CH4IbV79Hr2sULh0oe2UN4nEgpbF0IhZazUJjtXVQjzzyzeN9tPSY0QRu1jmDzksS0pf0/ShSbThYcLXyePwMURjlWQEg3BjA220oexHWpzL7Bn3g6kYCHUKQP6Myq01VXMwkH9BHncawJCjPwlFcly6JSJNKCbtrHIpe2lmF9P8ZmZ36BuUs8QaYKICP2+uJ66ZTYoKvd2ssrwKQ4DFY7ck4DWzp7hZ2L+FVXKDWFXjgFxHcSRRB97/g4Nde0W6llmMkERzk/XKHEP05b6Y6zOeaezOk+ejfE1HzsNK5Yhx1Tkrg4e/ctWdi0tlH+eicn7DugoX4wvKNgsHBS7/lmPCLe4STXnPZiZVExT19eEoYmrKCcPvEJ5XNJIGLuPdQqe2+WFUMqlhs6Onh85vxMWaGw1PZdStZ/rVT33Er5fcmr/paurHRwPGek/+/kMlVzWrB7sWv8ydtVsAp5VVgTQ9hvNy/7njmdpb/LZJ9SuR682OuyXmB3MQ31VVQvx2oDzyp2uQBf4qFl8RvpMDONGKsAK+q8aM2MN5KrNQs3jHbM3qOqd/0VA1SDc8D9zkhIj3I2OsiXX48DVRViX32yfeRy8XIXsSUMFwEb5MY679udAxvqytxWNaJkbykdIO1y2wj7vuiJ8uswTr8zh4PD8XrHpxEJtc2s02eklcTIiB1vHM45iiphTYxT4uZqz+zZDMReyrbukptv1khUZ8+CC2KubSEsDDYVlkOpxjVxHIEEt4jJObEnRgyZCk13KmQr29snsxmcDGXM0GodVFCy6beGlPXRP8J2ExfC2Jw+b5yQJn1v4UEd7+Kkk3tMjVuTIbi0KRHxYIKF5Lx
 L2dMDVBb
 x8gE2n1TjtCpEooMqn0SDL9ANIxd8UR08cOUQMZPMZMQE5FG50Wjr3VWpC+3w36OgcUrbnnspvCxFV0CuyfpMm257KtF1ZbcJ5TBEBDNpm7z9+nN5rUPhCUgu8UM2HJ569o/HEGj4uXMDReMxylRnrhMG+gIsJCUqhqFYtMp9F3MEWV5dggntazjsMwgIcUpOXGL/QYRx8lcG1UTIxfnWG5wzBlzUDqfobyyjCIiauxRK/ypYjp+0uTorl0X2aeNxA3xa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

When the -fsanitize=bounds sanitizer is enabled, gcc-16 sometimes runs
into a corner case in the read_ctrl_pos() pos function, where it sees
possible undefined behavior from the 'tier' index overflowing, presumably
in the case that this was called with a negative tier:

In function 'get_tier_idx',
    inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
mm/vmscan.c: In function 'isolate_folios':
mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=uninitialized]

Part of the problem seems to be that read_ctrl_pos() has unusual calling
conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
smaller positive number makes it read a single tier instead.

Shut up the warning by adding a fake initialization to the two instances
of this variable that can run into that corner case.

Link: https://lore.kernel.org/all/CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5EmiCHP+1fBpg@mail.gmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: replace the earlier more invasive cleanup with a trivial
    workaround
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d3312c51f3f2..f829435d2807 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4760,7 +4760,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
 	int tier;
-	struct ctrl_pos sp, pv;
+	struct ctrl_pos sp, pv = {};
 
 	/*
 	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
@@ -4779,7 +4779,7 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	struct ctrl_pos sp, pv;
+	struct ctrl_pos sp, pv = {};
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
-- 
2.39.5


