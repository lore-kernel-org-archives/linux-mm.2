Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D1AC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73DA86B0095; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8276B0096; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D64C6B0098; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BAA56B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC3BA805B0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
X-FDA: 85040405646.24.057AF73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3220440005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TD5nRq9B;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OrmqzezRZHpLkQbXvsx8kdT8w9xKKaZj6lZcjNbOnP4=;
	b=rLH8IN2Ek9SRWyxoqYE0pnFIKhNSHm1DMjPqsVo42VtKjaLUo9mGbla1++w8Lr17+NdwQs
	tbuY+Ilx76avfz5gDrrv8/F17sO8aX+cexHd6z8rwDQYEbrjNDCySaLL5DZwXzRPjbBwjJ
	wD4yAIRdoqnFMdGEuvoKSPfyp70gEi0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TD5nRq9B;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296282;
	b=Bte2Lfc4SVKcSjcGp+rwycoWYEu4DUayFKLxPQp/pNS+4umuC76IvjmV/kjIF1QczxyeKI
	n3bO1kDcO7imcmUPaaj/w7TdPnGSnhNAqMXPS7l+UuSRf+Sa1pEc9wr4OJtTscZnoz1SKe
	mv/Dlib1GSGIsQ/LH723ZEPbcmfP+5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29AB14022A;
	Wed, 29 Jul 2026 03:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64C21F00A3F;
	Wed, 29 Jul 2026 03:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296281;
	bh=OrmqzezRZHpLkQbXvsx8kdT8w9xKKaZj6lZcjNbOnP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TD5nRq9BrIBNUNfBlS7ERMfjkrbTQsnW9PQaVv/TJJGgmWTHMk+Ch28JKpN6hT5vf
	 lpEcSwBdhMu+fJqh+EyKbyfJg+LZFJZhS+JeB5dD7md/+dK9Hpkmt14xWAHaVcfR2b
	 iGWQBKy+hDf86toKlZEWflOolW16RmoFxw9ra3sDmGFnQ5aPEvhDhdLGqHydQ+MHyd
	 V9aqPBmpxh0b09lBd/f5JmvVoSTAZv1lz7ZvDwmWXlu3bhtY0Navh0Soq9Ug+LVPFH
	 SApGHpoPVyPMoa6dmXIvbKV4StR1xv67nIVoRa7pZxz6AWswA6PLH3GSuJ2cIL4BEW
	 rIBYYzIEwtitg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 03/10] mm/damon/vaddr: remove a debug message
Date: Tue, 28 Jul 2026 20:37:43 -0700
Message-ID: <20260729033751.131213-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3220440005
X-Rspamd-Server: rspam01
X-Stat-Signature: jo3fwb5s467maepabhb81kb7msomeg6m
X-HE-Tag: 1785296282-615065
X-HE-Meta: U2FsdGVkX1+BbawJNj5YL4TWo1rpo5XSdgK5ev2mnaDYXBCDUdouI+uvLF6KPpC8rg5kIKrF7sDFMfTTyaoDzaaISWDGih1j1uxwLTFOdbdhsiXqKHxT3dud/YAUpp2pyrOExWwvSTFOl1ooAdzMCTzUgGuTlTVdsZDPEoNJwgO76PHrbWFqnZ7nUzDV5oR1ZcDRlMElzi1pRxk45CMl51SXZN0kiEf99BE4rMMz8k7uXiDrtMr7cno8PkfnGwgR0qRmR0xCroiLT4V+B+kbStWfMC3z8QnjMDQFl8yKl1v8aQ2chjSI/WEU9MIZaJcE3mM5S0p0BRiYSV4zJ+kRRkQp4WwEaCjK/hK3SJ2NTyfryoiYW75FgaGTCMT79GfKxasAzOMnNSvvw+A9uuWMDU8REGz2CZai0J4cvTBHFfkokasWCKyvX0Fz4E7gPcXYmHBdktU5qdShmTkGWA3S1Mj/x2Xy+HAXGpEisP/TV4K5XMAKkMIDjmBqTbXigU+7c83iI76vBxDzKTdV2Cs1lflgH2JStpDhNJDcsgO00KqdL8pw1rMJ0aJ0beaD5fH1mbS7gkhmb+tlokJCr2Zc4ZhXf6731bCoIAjlGwXKhsECsacPSFDwN8EDVll3rTHC9TM5q56QI0h+i8lQWKQLt/fkVeaseSkFUDEAMesJ8CCCZM+6oePSMpsbqQFYZlSe95OpYR+UgidE0d5BQM+cX/wuEBxSbQ7T11ZDWdWPCXtBdzgmnaSQNhsAJmg6mW+ltABCLojptrdwzUdRyVokdQ3hOP53Mlonhd3M+Geo7LFYrkJ/Cmbao5hxfh6uvGybm01VY+lgkQ/xrheiXPXAd151RtF2G1o+Deae1OtN04suAgrhoLV23qjhr1WImzmeTaN5VlfA91nMN7OVZsjiweGLytlaE2AXrJhLIM+giSMNNn2N+gEdxpGfhBhJkX4WI6kcN/MX5CQimkMEDRj
 wMymBEh5
 WwMqOuLJsvXSPiLl6fAkbbr0hp1AE8hH5Z8S58VqAyPrcdOC1W8mKUN1euvain7DRBVupHZb6Xkjzq0ANuW0ObD85HGfxXkuoH4VffKIVN7g2i9khFngoWpUvzVWdeMK0A1ftfijLXeoq8mMgI39fQzGryuAHWUDMaUCYD88bvhxb44vtDMvKRtncKjhOvfV35HwD9o85y+7s8tHPABna0rpBl1siJrBZ4X3K4o/z7xUuqtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is a debug message in the DAMON virtual address space operation
set.  It has not really been used in a meaningful way for the last few
years, though.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 0648400b2d65b..1b220f6f2632b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -189,22 +189,12 @@ static int damon_va_three_regions(struct damon_target *t,
  *   <BIG UNMAPPED REGION 2>
  *   <stack>
  */
-static void __damon_va_init_regions(struct damon_ctx *ctx,
-				     struct damon_target *t)
+static void __damon_va_init_regions(struct damon_target *t)
 {
-	struct damon_target *ti;
 	struct damon_addr_range regions[3];
-	int tidx = 0;
 
-	if (damon_va_three_regions(t, regions)) {
-		damon_for_each_target(ti, ctx) {
-			if (ti == t)
-				break;
-			tidx++;
-		}
-		pr_debug("Failed to get three regions of %dth target\n", tidx);
+	if (damon_va_three_regions(t, regions))
 		return;
-	}
 
 	damon_set_regions(t, regions, 3, DAMON_MIN_REGION_SZ);
 }
@@ -217,7 +207,7 @@ static void damon_va_init(struct damon_ctx *ctx)
 	damon_for_each_target(t, ctx) {
 		/* the user may set the target regions as they want */
 		if (!damon_nr_regions(t))
-			__damon_va_init_regions(ctx, t);
+			__damon_va_init_regions(t);
 	}
 }
 
-- 
2.47.3

