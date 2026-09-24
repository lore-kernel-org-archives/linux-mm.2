Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E20CC98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AD26B0098; Thu, 24 Sep 2026 01:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0253C6B0099; Thu, 24 Sep 2026 01:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F516B009B; Thu, 24 Sep 2026 01:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB48B6B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:00:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3290D80224
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:45 +0000 (UTC)
X-FDA: 85247455650.21.5F0AB8F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 80A871C0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VoQ3Sil+;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBrA4B4V5ZO5iERuABPWoek7KU+EcH3kb5qa8+bb5KI=;
	b=Ow7PHRKMSzjchCUgacrGBoYQOpTruHR9alocjRN4jLHVu93tYITtSS+0YEYvelv8cQsLa6
	hbnP2o7JQ3ezjHY3AwqBgcbHRtzqCA9j2Dj53IXtz1IrjJ44sVHaBI34wI5X61iVNmQVdf
	XUsoL8yvWfayqPCgh4Zv+1C9T3SBJ/A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VoQ3Sil+;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226043;
	b=z89wg0mnHzR3D7BMmUlGn0II9iFAysQBxEYNYCSf0CcRQeSwNGxOe/HIEAB7J2J1FjPans
	bJx27zaW2u1NBO2QeuwkK5hGwXcv4o/hNya5taHDNWKe3w9CohmBL3xWY7/NxM96bmMRxY
	sXnr6bzt11OPFzoee5B1uCbnrpv7xOs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA0191476;
	Wed, 23 Sep 2026 22:00:38 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A171A3F86C;
	Wed, 23 Sep 2026 22:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790226042; bh=EmkguL785IIXMYOOGQrzJ/6/Y6ZZO1ERK0FFTi6WP+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoQ3Sil+u+bZMg3gQzQxSDAl5ZC1MWS/6iqveSX+OWgskIoqG3Ry90TTIuPJS8Cn6
	 i7jwJdERAIbLo+84agDoFnJTIV0pU5Yti+FWAWyXM8OA1nzzLZwAbALQKXmfP+YJb5
	 LpEYezMaDIsIuuEYUagvFmvju0a9K7vjwJJ0NBag=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND 4/9] selftests/mm: mremap_test: correct multiple VMA range size
Date: Thu, 24 Sep 2026 10:30:04 +0530
Message-ID: <20260924050009.19974-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 80A871C0005
X-Rspam-User: 
X-Stat-Signature: snzdy79br8m5pnkkp5rwfrei4oq5jfjj
X-HE-Tag: 1790226043-398271
X-HE-Meta: U2FsdGVkX18XRjrqmYqN/o80GNTguDNR4j5eKF+3jnkQ/kFT2Vt8DRVLmwlbdqSesbds2rNKd1CQ6lN9b9+JFI3MhgLoUytdEgtZFtyTc6qgKWgxP3hP79b5xLpTVcT/XgG2AOA5hprwa1r8xOAv/K3bv6G0NnL/PbTG5fCH2+mQooe1im4aInokED68Cls84XM69aoPKRYykGXodYFLLg8yE0CvIf+6uMqAdyQE3jMpTEdCh8srnCqAUuLJOL/e9hphxjDvoB1Yi2VAy/1TF3eTyfPimtEp2EnSP+3DK+3CFCuooRDo0ANn9Iv/8/5Q1h7vjSnGQnQWgkhYKSQq9fc181/a3//oVTozpha+ft2tXt5pmzCo9MjVxzOmIfKob9WxUkJc2rwHkt0hQYqGSdVdnaGGrmqp6uKOO3/YaGbkk3m3+Z2xTlAhJdHsNShrMHuWSZLZGTJ1AneGvmA1q/r8DRph+9CR99pO8BtH3EpSCu9DIu7gaIWoLk+NzpzuES0JFocoaq077/1dQbB2bzr6S+Ig2kd8ijnB4/zWBtM1lVpxdRuNia+5XNBO9eqKWAaGtuoWUtYPzJkBf6xjwjvKOYcHZES8R40wt4NPLxxEVj8tLjgqEBSUZSAfvlJnOGZpBPjSYI0pEmAl1X+JXlh+54tRhTCwd07F9ojVOMVgPlmf0bG2j/9rLToUhRBilnBYq9PsJaXpjj6TDLJkrVSTtTvo2b11mQmYwAhzEJ1V2cmO9Mpc/HNyLAf61Ax4hwmYO8NBwKuUWDO/wsAR+PKchVgVpBiE+y1siaagqi1J+u57z7rvkAlsIMYkrS2AMIfavbVyUJA4naL0sMtW0e53faU248tbPIhIbSpGdfgro3xH3bvRpGhRsllSGF1Ye2Vg/zJr/dlHaM8gIQv5VK1WvMvIcKIKm54eM8d4iUsz3MlYAaMvjvGxqueUznrAT4Ir4GGQpcyALtzYD1M
 Bz2UR71J
 bMb9w+f1X9EMtzsVLHqwlkrsRefx29jUdy182JDmTWzpKuVZM+EhhqBXTNUUWlOGg7KQ+ljmSBMK8/47be407gql+2BnuPk8YSDb2FW5ju9VX3xMzEUmvAo4Nl6xLOrvUZCAj+M0MCh4XOEciWa+YJy6iDu/oJXsq+OSmMl1YHB2+K3US9PbhsGMOp/SYuhz2U9N+yw/J18pGAr5OZVt2EGhemR/X+Geeldlw12cwfoA3dwIOLYvH5uNbRI1gW17t38g7rjPoeBeYrmNt/AyBXtBKT7jShyMvay+N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the test mremap_move_multiple_vmas(), pages 4
to 6 form a single VMA. But the helper function
is_multiple_vma_range_ok() checks pages 4 and 5 as
one range and treats page 6 separately.

Check all three pages as a single range and skip
the page 6 iteration to match the actual VMA layout.

Fixes: d53f248258e1 ("tools/testing/selftests: extend mremap_test to test multi-VMA mremap")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index ba9b7f7566d0..869df22d46db 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -373,7 +373,10 @@ static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
 	for (i = 0; i <= 10; i += 2) {
 		int j;
 		char *buf = &ptr[i * page_size];
-		size_t size = i == 4 ? 2 * page_size : page_size;
+		size_t size = i == 4 ? 3 * page_size : page_size;
+
+		if (i == 6)
+			continue;
 
 		for (j = 0; j < size; j++) {
 			char chr = rand();
-- 
2.53.0


