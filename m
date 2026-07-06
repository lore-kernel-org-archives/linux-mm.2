Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5CFC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BE56B00EE; Mon,  6 Jul 2026 10:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4C16B00EF; Mon,  6 Jul 2026 10:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21EB6B00F0; Mon,  6 Jul 2026 10:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9607B6B00EE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 223731C7D92
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:30 +0000 (UTC)
X-FDA: 84958559700.04.5A65BD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 702FC10000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZenK5tOo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	b=f9h0gtRIeOChC0mqH90HrbwUy5U7fGTCqq2f8d410dz1pZa2wcIQ5/RPVUrXWpZtEef7Ks
	IhplmOytSaYu8b00c1ejLmz6+sN9uDUQpha+F6rJKcN/TS/p8EGskDQTacFQbMC0915vtW
	4XMsiInP5qTl+UOQnpoRzpHfy2R4FPE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZenK5tOo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347568;
	b=sO4iweuYnwXuaEMKBh2JHzbjWaU2SIwq9cJky0zlvgAGZmln79iJdpDjBE5nT1Hwcev0oo
	Cdui1UTGusiRPTz7SO8zWGYYCo3eKvAFhZkCD/OdF38lhhzd+qZfJglzNzRDrSl7p+qSeL
	8pjMbXAMNoEdQOgNIE8RQUXmHVLFldo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B50F84336D;
	Mon,  6 Jul 2026 14:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13441F00A3E;
	Mon,  6 Jul 2026 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347567;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZenK5tOo3Jj9+9DUycgnw187qw/eOsqR06vcERBfy/co0DZh9TIUv2S2siMrfTlJt
	 +x9XfuA6AaM9wsCkcuV8zRtSu07n9aj+8AzgXamMpPP6CtONus6UaKHK0kqVe2MzJz
	 ORVkEHAQBnkQt3CtrnuTFpOA+B8ezZEpHMfWsd/Grwei42sS6++dkqXnb1MKdF1S5D
	 2/WlxY6MWmtpZvXv/3tovtebklCzho6hfSShT4YNVYUdee5PcNLMjrT54zCh+kQYy2
	 pRyyYZAzGvOzHpauGKXtypSxOY2V7VQMaY+G9X0tosDCMPsEgMLk04AG6FEhh8sVO/
	 TOVJTtTBH/hSQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 16/16] Docs/ABI/damon: document probe weight file
Date: Mon,  6 Jul 2026 07:19:10 -0700
Message-ID: <20260706141912.88445-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 702FC10000D
X-Stat-Signature: m7h1k54isk16jjxaaihe3qs1xym33ny7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783347568-598826
X-HE-Meta: U2FsdGVkX1/r1/JNEUJubEtnkAfIFR9UVvvRLmAvrXbX1PdVdRHmgzadScbRsLtl18alIcG9dKd7l6PSnwtZpNoI6I8qwqoBkrTDzb4/bBF3krzdodFarIO4aIlEqIE1x2eSpHacP+fzEUPPlLDv/oR1BfQ6LKgx26WfORhJ9/OmieuvAX7hKiJ/whUCPwIxbS1qdMx6SKHtvtJyyOnNI+N81Wb6LmP28uKB/Qjg1lGoVvb1RpvR2hEqNd8MSHJFbsXYupo0Vt7t53MGztXcOcN1ZnGxPuId6Y/vX18GzwKhtJ3B2owdexeGfnSgBNblwPfNKhJK3l3pRoj7vCqxR56eG+iU2hw2/fTHMmty5L8fXqnCWP5HaROeS0uRG9KXhD+vUbkBzkprHqr8FPdd1+JLLEyTgDaQueYyF8vCJa4Fe/ulScovcO4hw/KpiyOrgFvQ+UDvlt4Ue7mmhcSOWsnAx+lnHVHrTnvkwT/F1WY3jG50adxzVMAGCih1nYUFZXqIJdfkCsW7QMPLhbPefLsS1kjzhwdVHWZIG8Ir7TZhDAknQMSlr+rz+P22gf61hdB3vgKXMwnAggGFuuU6BmcQQTsUeuMVCcgusjXqw8Hht4nOFtNWpAN0ZKpQDHHLjYsgIHeuqYCDG42vk8yBDfhIHmlGvP6pZ1OKI4GY4bdXHq6TarHeRdvIa9rZnHkpzo19TY+QtLp/hn822VuExYBrlWyuJg9g232mdv7qo5qN3XEPt1YsDNe0Yce2KY0lMaB5MVy5/r/rfE9bfFp9w9PDsSDH11zYLO5DA1vytv4oj2wsZEWSzwQjMpAMtJK4Uj/ZnYEix7CCT7lNqiV9wfDtiq8YSf7b//ef4kAk/gZ6KVz5sV2FG0cYPoE7uECfmXe8+oetRyESVlkEVyEfv2jQg+abgCjo/0f3YgEG4rbIewS1W39/2ftWGWYTgdJrkSTBiqSvuTKtbH2nmhg
 +r2Rc33b
 G5AbmMn3Se2awEQhlkDTM7OvYfvh9GunR1Qu8nX3ZiFMhC2VvBPgfZ2Pc9v5w5Ggc2Ou6b2V7R98YS5msXlJSWZ0PwJjsiTj3DGdErb/W0w9q9894WBswAi62JB9tg5UVMcgPJa7FVdCHYVs3aNknVwyOE2igE6/NrL2xEFUX5ULGkwWqzknNkahsFTKOStCBnstTtBEFy638dwoAnBhWKo72HOx9MTn4PG6KxN77bfqblpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added probe weight sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index dd6b5bd76e119..907a504fb64c5 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -164,6 +164,12 @@ Description:	Writing a number 'N' to this file creates the number of
 		directories for each DAMON probe named '0' to 'N-1' under the
 		probes/ directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/weight
+Date:		Jul 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		per-probe attribute weight.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

