Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB352C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89CB6B00A2; Tue, 15 Sep 2026 06:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A9D6B00A3; Tue, 15 Sep 2026 06:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FFF6B00A4; Tue, 15 Sep 2026 06:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2DCB6B00A2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:25:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 512ACA037D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:25:36 +0000 (UTC)
X-FDA: 85215615072.06.81C30B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id A007FA0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:25:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iTQIOELw;
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kPX55JGv8qgKEcQH8SIwQKCrjlEy+jc/lb0YM6J54rY=;
	b=SWxAB9ehpDJ+j2OGMEJeFaHMomlgXLqI/XCiBQ6p9C//Vvf3AA/bicZ61fsGGxuHMcNoMN
	uQwrj1VjjlyBaKF4clo3l/cfB4dkcmiBCetaTs/MNGFvhwR3/LnZsQfXQpmNAZnoPfaFCI
	T8jo8GM3fU8odlVEnbPg7Sh9VGjo5NM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iTQIOELw;
	spf=pass (imf25.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467934;
	b=pmnidI6Vkhdn1eh3cpOYphyBlvrbNFj1HgjRegFypPJRpst3k68mla9uUarceYPsFKErfr
	Atf2gU7vLTjH7xcSIO4Af29lzCWbBfQTgJIW1c2TTQqehnPhk030GqDcu96mg8NapIi52y
	QwWFFvGGvIpOlereDslivLzPoM5tGGE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E1F0152B;
	Tue, 15 Sep 2026 03:25:30 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1C7623F7B4;
	Tue, 15 Sep 2026 03:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789467933; bh=QSQQNG/X9SZNNSgdUIC3WO0lkTHMqEVH+D2pHmZmnDI=;
	h=From:To:Cc:Subject:Date:From;
	b=iTQIOELwGV42ckI3KJMQwpU/U4rjCE7qHqaU0eXVCt3gRXAWrxbN2fdVgvNiy7feW
	 uU/vkp0t1sGoW3zggyUWi19gbQGESdYH9j1LGbvL8dT62qLC4k2XmDNqWu5BZpMDjq
	 bfaQE2FuMbYXSNDMnEsNwmFS7nKIvB4Xb+EySXek=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v5] mm/gup_test: safely calculate GUP batch size
Date: Tue, 15 Sep 2026 15:55:24 +0530
Message-ID: <20260915102524.125758-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: y4ntt6fzyceoxwcwr1mfxix4jirptrgr
X-Rspamd-Queue-Id: A007FA0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789467934-619047
X-HE-Meta: U2FsdGVkX1/rvDp5CWaxy8l7FtyPjzX+Y9+SRtYHNGlrHPGUZtxStd3yTH+ielLDqWcvYnWGyhHvwFgJif5K6wGIcOFDXgi05DiOsCm05iDPYmcoQDexM8e6PrDppSIY7MnxdJGAR+hsdqMmyTMda8an/Sv8lCA2y+OFksJ7gOfQUbYNRQe0MHazTKuFK8iocNwk0kdUvm471Q2G9ovv5CeRb6iFhkgu/PCYZjIrrrlszAeM8m8Q7eHjWhWv3MiFE/xz9lA4waAmokK7SmiTRU8xHv8dnKPR4gzh/g2dl3tWYjHpLad0aHc9Tx1KkuqragFVhyAlTkC/7H2vhoxHXAJ84h3nbBa1A8OpTrlM82R22xamThwuokhayj7t26K/Ht2P0vFH59+aD06AiJk15TI9armVCIRf3yk4q9I5UTPPl6Z33oLiBXkPf1A4UY2sPXU4y0hk+a2/OC8oDaC9bTaeqGsy4r1n+xVjiP7JyyOpbzlaQiBpNrtdSCqP2K9oMCrW2Ufw+wthTh0EDsbbyBGlm2J97Lkq00exc0lRuDy33fhInRsmGix5PnB0WR9OLzEScejhyCcuK9zDomGi0kbWrCwx+GYjgZYx0MXtkgJ2D6VJtzsW8Hk1lvkVORlka0W8XDfrAv9+T0Cdk+Va77ZRpY35Vw9uCwJyAFFf+d6Mb8T/lPKBNyq1g8davqwbcVBg9Q959iX0tnNBM2KPlieq0TRioo+0dwU7/Gtr+2PcAznEuduuN/jUqW3RhMCyOj1bO0t/3BYMVMp6eUUlXbPOMwGxT3yqN/7Bl6W5LMvYJ6GHvvib6BXPEljL3z+1/Oaii7nYuLZDoQph0wUEBHoUhXXwhDxpmHHBW7bnx+LcS0PRTBe2LEypytiaKoLrYdVVYnrrqhohMTqvbhwNTj+cruCMgOvfqZHgGyKvVkTF+WgAuktubwYPBvrrlg1+oMqt/l1CSeEcrqU0+zc
 w7HrnOdK
 klW1oPtuRZYhQSj0EBPM4/ncUKIRJ4tMkyVbByW97C5e94f5158jJB9HWCzGYNNHqNpd07h+ey7W0SoiVsbbH5ren0c/GuDzIXtbUoeNHGbtfbM62bDNy/UN7M+wi5yrJHKy21rOdCpyr80JICfq782Tq2phllk5ePGcQMMJ/ENvP1IfStF6RRYeSws8Lpm/KE7zJIata9Nrvvxb7KBs4R8ZmR/8GHG3NG43jCEZ9qALcOHydNPCNj1W7b2SdLnGc/hYN88SQ7IchMKCAoBgHHZbYmqBIZHeWiGodghmtV4lo+KxY1sYPAIt0Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__gup_test_ioctl() calculates the end of a GUP batch using:

next = addr + nr * PAGE_SIZE;

If nr is too large, it can cause next to overflow and wrap around.
If it wraps, the next > end check is bypassed and a large value
of nr is passed to the GUP call, even though the pages array was
allocated according to gup->size. This can lead to out of bounds writes.

Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
contains zero pages. The code still calls GUP functions with pages + i,
which can point past the allocated array.

Calculate nr by taking the minimum of the number of pages per call and
the pages remaining in the address range. Reject zero sized and non
page aligned gup->size values and zero nr_pages_per_call value.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
Changes in v5:
- Make the batch clamping logic easy to read
- Reject zero sized and non page aligned gup->size and zero
  gup->nr_pages_per_call

Changes in v4:
- Simplify batch clamping logic as suggested by Kiryl
- Don't call GUP functions for an empty batch
- Drop the pinned byte reporting patch since it has been applied to mm-new

v4: https://lore.kernel.org/all/20260903115033.162218-1-sarthak.sharma@arm.com/
v3: https://lore.kernel.org/all/20260901083452.115365-1-sarthak.sharma@arm.com/

 mm/gup_test.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 185ba3bb8ed1..ba74bf3f4104 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -116,7 +116,8 @@ static int __gup_test_ioctl(unsigned int cmd,
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+	    !gup->nr_pages_per_call || !PAGE_ALIGNED(gup->size))
 		return -EINVAL;
 	if (check_add_overflow((unsigned long)gup->addr,
 			       (unsigned long)gup->size, &end))
@@ -139,11 +140,9 @@ static int __gup_test_ioctl(unsigned int cmd,
 		if (nr != gup->nr_pages_per_call)
 			break;
 
+		nr = min_t(unsigned long, nr, (end - addr) / PAGE_SIZE);
+
 		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
-			next = end;
-			nr = (next - addr) / PAGE_SIZE;
-		}
 
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:

base-commit: b08a65b93426d86e3f354d655d6225397b591877
-- 
2.53.0


