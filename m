Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D98CC61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B78D6B00B2; Wed,  2 Sep 2026 21:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456BF6B00B3; Wed,  2 Sep 2026 21:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C0A6B00B5; Wed,  2 Sep 2026 21:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6D76B00B2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:07:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B97AA42D2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:07:32 +0000 (UTC)
X-FDA: 85170663144.25.A6DDA8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1A9A140008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:07:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGh6AA0p;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SsJPfKsekeE5VptqHXgsGnvsq0lAUhbBGf4TqY9ku8=;
	b=bv/xTS6GkbyVJ9Qf6RBPj9oogtif7TZFNc62jkhT7rIIVvkoXx/wA6Xxxp7KdNw9dPoZ1m
	h6LfJiR/x7FwckV9bwYJc00JimF7yXOMGRXVewM4pM8ytGQy0tkgTzIsazRs7NWX7XFeuS
	ajvx6p9RC47gn5raZF+EO4PkDO3g8U8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397651;
	b=TOWSavNmmNs5PL1upOzXMVBkX5+XFDJcJDC2C0XtWqSONqfsiRgNDHRCXDcTSM69UADOXP
	mDELEWoKjNqvIyst4MbTVuYfuUDFAv+oLvBcCbJVKNLWaJDTy+ua3wHfdEtfsg/QOrHhIf
	lwRm5gSIruzB2T+r8O7OpHJj2rpuJtk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGh6AA0p;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50C5043DEC;
	Thu,  3 Sep 2026 01:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3831F00A3E;
	Thu,  3 Sep 2026 01:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397650;
	bh=4SsJPfKsekeE5VptqHXgsGnvsq0lAUhbBGf4TqY9ku8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGh6AA0pHU71NdvZh0YOA3rFuHLBh0+RJ6ntehGQFIdA3dHZJ2H3oD3+XPLYRSriF
	 LTEFCe6UfMTb9+tEdnICcKKV5oB9MjFdPfkc1xS9T/xhVPd2xJlAV8J3cvUAfGUHlP
	 vvzQXrli3zLDtSYA6HOZrUadW/uVdH2QHl6NDYA2l7J5zvF78Eav8fUXsYj5GAiBBP
	 M2nr6zPaKt8NqM6sStlOOQ7O8Yp3uR+jY0Dj4txCzJnpZvv02TKy4bAuwHlD9dycAZ
	 cGYn6aLuZt7I8CbZV1aH/y2OD4hqiDp1cZHaE3gm1EPsKpdluIyBeTOyCeU/606EU/
	 Zp9wmQVnjLgvw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] Revert "samples/damon/mtier: error out for zero quota goal target values"
Date: Wed,  2 Sep 2026 18:07:21 -0700
Message-ID: <20260903010722.94244-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903010722.94244-1-sj@kernel.org>
References: <20260903010722.94244-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nz6nqe4iyjy3f7tjqdqh1etakj64tw56
X-Rspamd-Queue-Id: 1A9A140008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788397650-367350
X-HE-Meta: U2FsdGVkX19jInCvgGTjjsJGWXoXqKrjjZB/eXBYpSDFm16arBBRus4lQoCjKa2XcNAvJ9R2I6CHyeQt+rEf7SU3fJHRPfqx01v6by/uNNr8z3hMeVE0nBT06qJdtb7P8ZCEjewxKU8lrBsM/LmWt7t/pIQjsjrivk40AwwUraJU1r1sP2t/WR2wU5/jwe4QXAYerOITLlJocsQ58r+GXsqwnXILBorM1xfaIgBaLM7rztLwzpxJB6o7fqA4gMjQrwbPiX6lwQuCZLc1s5iuB5EFYI8DFDeKjVSldJKJh7yRDqQDCb6LHa2xejqOthwatUUONBt9lTme0oBidoDkowE1CmPn3/moBZxRDGF6W+7XHpalI3mdyP0X0e9hK24wJGCdTM1lTjrhYmQW2/AbJVg/7E2p6JKZFnV0RQYUXBCnRre8VCCiFueQeSwi98MwvwE5psBaF8O+XkK1ibh0+pVxyc53FTVDCKHQ3wPWC/vBrbCHNrihZOvhruEdtGizB9dMim5zBfA6bb3iid4+tZBh4GHU5bHlqIfACVc83aI5k8xuKs5cY7b56FHEsZEv6Om5ORFk7Qk0ij8mMNpaaWlHaHWSdStA8r19Y8o47KIaqTXoxfk0h359qgizPprDylTkLLzbKThM31Czf+gNfE6jAe85E3e91753NeC1mQwwM3sM0v/NfRjrOoy3rusY/8/VZYuhLlTkGtZPkIPqMNbHp0eacaOJ0YsC9kJRJcoZ/xlblazwCoskA8NELBiENDe1rWmE+L9co6Br2h9SarGRYPIHVDhPRj5S2IeAgQtwnbKV9+gspuS6NuURi8o6H8qeE23C8hYSb4UH7HC8GWh+D6j3gANQgirTAsEMZcpkglxnkslAN7M5qnNcRMaf9YT04M/Qp/z8gd5YsIedjJT1xkO7hsckJfRZZT8GwBveGliChE4RnQh7+WOmd3XYmEOQwEQlIeIjcwH940y
 CYqHW/l9
 /fYrMhmIV6eCH0EPnF0a3YLMBh8JRVfwvuzASDKXFSLcqSnlYiwW67KGU9MqcJbnZgKpr6MGZbeT/x93bz9De80xrGNO3FCk6maAaLOzRFrRWwHdmaHt1AC/F24b3RPPfMTPjNUFO5lK9IZRBoWSpyLS3sUzzQCxvTu9pCuBZRCqDyeow9vdjJC8Q1iDMKjQuPu2GrpGGCTiiAZ9Z1dbJBhOJMqaVPF8KHfAdY/RpmRSfxrA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit a16fd3ad9d89b05475864da97327870464611736.

The commit was made to avoid zero damos quota goal target value, because
it can trigger division-by-zero.  Now the core layer handles the corner
case.  It returns an error for any attempt setting the aero
target_value.  The corner case handling in DAMON_SAMPLE_MTIER is hence
no more needed.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index bea45c87cc9be..27dc88bdf7a0e 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -161,9 +161,6 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	if (!scheme)
 		goto free_out;
 	damon_set_schemes(ctx, &scheme, 1);
-	/* zero target value causes division by zero in damos_quota_store() */
-	if (!node0_mem_used_bp || !node0_mem_free_bp)
-		goto free_out;
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,
-- 
2.47.3

