Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4671CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 18:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80DC8E0003; Tue, 21 Oct 2025 14:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58408E0002; Tue, 21 Oct 2025 14:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94E88E0003; Tue, 21 Oct 2025 14:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B843B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:14:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43A9411A447
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:14:00 +0000 (UTC)
X-FDA: 84022920240.20.9A806E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91DE214000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:13:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761070438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rPQw1oK5IIsKcwOJzcbBxK9+jM8HHdfqaq5vyUcDUWM=;
	b=WDgvUyrJAISi0YoCWC2bvyEXCy+eCYpjbf0ZBicyOFXLiH2QOgbW/pi9AzByXlTPqrGSXZ
	6msjN+V1xLhWFlXYh+UHyjQvQ1CeBdhGasezy/+PPJ6U893dpxdeE3kjkrGDsnln0kwfIV
	rge4vKEfN8KIkN1r6k0HDp/HbrB0JCs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761070438; a=rsa-sha256;
	cv=none;
	b=7wEOhhP5N0qgdZeVrwJNDIRwAzUEM1K/MIbEPeDkMjjAmES8IkPIWRhPtB5wQLSCBVgQe8
	fBtKd5BQPH2Ue8LGH6x3uM237P1heAmKTtFRBw3Wg0tOVq93Ux02zIz4xCfDLdsPXeSMlI
	jFfS0u3NkxMT9WIuLJ/R+/j/U6XMbf0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F26344EB2;
	Tue, 21 Oct 2025 18:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1E0C4CEF1;
	Tue, 21 Oct 2025 18:13:55 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org,
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com,
	Will Deacon <will@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] arm64: mte: Do not warn if the page is already tagged in copy_highpage()
Date: Tue, 21 Oct 2025 19:13:53 +0100
Message-ID: <20251021181353.3842660-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91DE214000C
X-Stat-Signature: xwfu3y361gwx3xwcjgfo5swrpdekeudx
X-Rspam-User: 
X-HE-Tag: 1761070438-960396
X-HE-Meta: U2FsdGVkX1929576/RwWmIzwgAN5VLdHekHQIkJVSx0CKd6Lp7G4mt84ojAkOAvC3NM0yPSLdUecbCJ7GcvvAnL/hoDzZteemxCv+aBqZQbhSIV3SnRJW0GIaF/Nc8uH3SyONCNC1UtiH8NF3DlkG2v7Frc7zIqWfBQqQAYLWPd402PIhs4BqZvPzSY6hzC0rVMvPXl6Sq82YsOIQwxzdlAst4phsGSYnirjaD3s29NrJiiT98SUFFtuPNlYiut/GHu3zmw3GcSirCxwj+bTVtcatdvv6dRHVpATRgSKstrwY9CrVierKM0gwiulutEQOZR4KkRpOkqRyVP88PfQyAu7cxw0RmW1O7Eh9vbGnamRB/jsqYi1wBWTOY9A6UvtTZP+JilYyMu2wzosczMGReHuOACldda9KJJnfjSVtbrWWeq+mXKDbog3DqUe+FmmYyoU6cV6bUL58jEy2jiurJikzYNtgWU7YHurBUEB2RnZjrZd6lbslpZG7EZ+dycsueNZZ/68c2DIXN+UzlBLRurWlFLf3u/QeXitqr+Du4n4d1e4Ci9akLxeYNpJOOccyzL0LOYJNaTzZo7OMdJeoxnM0sa3P/Ut5J8iHxS8kDgFwovsuKuMOZC6GjqL4Zc8hojZzJODJq5swcNDdtMSdwsSjAXeKd5R3AJF0/ocF1DcPYofbdEkF+ksQikx4i9zqVs6KLzko7FUJDRHQMLrcS9MzDQr8Cg7Ks+ONSsYBhWjC7Pu/u4otn35k3DG8hfAmp3L8h9NALxIO/GqN5LPuyQw3jhfJV0b2S3aSo7M0GN+Q/ESBs4u0UvGWmwy3a9/30l6PC1f+tO5smeld5nzrtY/JgANwRgBdgio7NgJPAm00K3DgGSPdshWzbEPSjvPmu9FvQnM9/Z1ikh6fNELuR0C4ahvoEGbwV2E5WxMjJYy5u9IL3ZzYLb8PI5yU0OPtwUTrSd8WanH2/ePt4n
 rVBB06zH
 4QAQBj18+r7f+ATDispY9pnrmCAsB1F7MS9Gy2s6AhJbl/sNE8Vi06mHzWK5Q26hOwKVXCqVhAEDBctwmG7JAHv9r4Hin17D3HYUNsb/KoSLeVljXONWzOQDeN3eNcWNzjXbT6/1Rnlxk/5GfyBjG0pUUQoXzvIiwMq7prz6KZXZJ4Oj5USCbWiX9y8NnWWUMvDV5/muUdPkdtVOmQvaHqjunaXeP1qkXOI4NaAAIjo3fBtXuyu4fUA3hVlhe/L3qD1bImHww9I1VkZm+2stwYAJG6faKu8zRlF5/0m+fpZTJyKyW9VAGwmfB6DqkggcA3SR5Ci0V7aT//pVmkasSQo1DH8822vfstt+qlwqCbe2U40caPXWS6Jmz5rNYC7Mt1dwDLuhcBNE0xR0llcMXNOpfx6TsPJIwBU9kxGqxZUzeQ2lZe3H/eAOc+UsnbFHDnVoR5x9Vy7XTs/7c0ujzPZZc+F/XYsbkKtxj4ySiqs23x3B3gIRBDhKgrI3JN7xGgV1wX21DqpjmP2EdTHK1mnTCMkO3HpddRqcHW77Zr0wfSXJWFx8EQjMZpHv5mn6FSpdlCjOA9mmd38NUsJMuISlhwkQ/yCe94jPxw4H66BCeCsjw/1YaoGpMy6X+YjC0LK6jsSI76dtaTHD0Ne/PKz6jalR5d4BQJ+wQtWT8PBTZf9SzFzN6yoB2og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The arm64 copy_highpage() assumes that the destination page is newly
allocated and not MTE-tagged (PG_mte_tagged unset) and warns
accordingly. However, following commit 060913999d7a ("mm: migrate:
support poisoned recover from migrate folio"), __folio_mc_copy() is
called before __folio_migrate_mapping(). If the latter fails (-EAGAIN),
the copy will be done again to the same destination page. Since
copy_highpage() already set the PG_mte_tagged flag, this second copy
will warn.

Replace the WARN_ON(page already tagged) in the arm64 copy_highpage()
with a comment.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/68dda1ae.a00a0220.102ee.0065.GAE@google.com
Cc: <stable@vger.kernel.org> # 6.12.x
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 arch/arm64/mm/copypage.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index a86c897017df..40749d0a385c 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -51,8 +51,13 @@ void copy_highpage(struct page *to, struct page *from)
 		}
 		folio_set_hugetlb_mte_tagged(dst);
 	} else if (page_mte_tagged(from)) {
-		/* It's a new page, shouldn't have been tagged yet */
-		WARN_ON_ONCE(!try_page_mte_tagging(to));
+		/*
+		 * Most of the time it's a new page that shouldn't have been
+		 * tagged yet. However, folio migration can end up reusing the
+		 * same page without untagging it. Ignore the warning if the
+		 * page is already tagged.
+		 */
+		try_page_mte_tagging(to);
 
 		mte_copy_page_tags(kto, kfrom);
 		set_page_mte_tagged(to);

