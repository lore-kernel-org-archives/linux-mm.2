Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0154C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 03:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00AE6B00A5; Mon, 21 Sep 2026 23:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1196B00A6; Mon, 21 Sep 2026 23:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6986B00A7; Mon, 21 Sep 2026 23:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884EB6B00A5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:36:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0041F80376
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:36:35 +0000 (UTC)
X-FDA: 85239985992.23.4D74107
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4939F20002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:36:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KaNICKbH;
	spf=pass (imf13.hostedemail.com: domain of hanzhijian1991@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=hanzhijian1991@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790048194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xjaz0tU8TY0TcueO7EZLXNwxMWHUXDu0d5R0jWTxtYk=;
	b=smUeARKS0Yh+nzbLuzLc6IvoIxG1A9dD1Od900N8FIufzj6uhdzrANf0A+tlHy9wkgrFye
	5Ue9tnX5O3BylENDyyyJ2Htl+TXqA//Ms1B2Xnd85S8CRxvJSK3GiVIfy+UqvZ6LRoGvMc
	n1h0MB/DCy9bPH38TOvS04rDhmf0lMs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KaNICKbH;
	spf=pass (imf13.hostedemail.com: domain of hanzhijian1991@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=hanzhijian1991@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790048194;
	b=nQrj8UN3nbcl4ghEWorU7EqEZSEs0OOwHMVrijlUdUQ8Uq3YP+BsoSNmp59J0SAx8U/jLn
	PNS83RaGtUST19R5w3m90XwKQfHQL/FeiEyWpuxIebY94Bi15xxeIgv6FCzeCaOwtgt0ht
	tEEkuZUbJ7x8tAGOoLKyfGKoioXFg1o=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469f204f6so2548263b3a.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790048193; x=1790652993; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xjaz0tU8TY0TcueO7EZLXNwxMWHUXDu0d5R0jWTxtYk=;
        b=KaNICKbHWf6B47eQKY6IoD36jO/dy/1ZSYTDZT1W2RjD6JooI+ocCRXJwapFAZrr7z
         qwHU3KgU7WwhyXOXJJSyRnvwthDK2WafWVeMZCh4inl1cPbWzgyZ4Jk3fDkp4thGcNy8
         NAmLCvf7PHspqdu81y8kric764AmY8hJyv3aXuMJ1fJLALFbJN4ViGbZYiuP/TQ/YbdK
         alrcWv2m5NwyQj59vz4WwJYMJg9EhEXolWKx9mV5b7a+PkOeLwxSCEukw5xSDlTmy2Im
         rRCNvM21JKvcHRlI1Z8yF4DJjvyJNcuf2MVpiFW7fJdkX7BbTsQK9tkhxw4qKSfIqHEv
         F8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790048193; x=1790652993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xjaz0tU8TY0TcueO7EZLXNwxMWHUXDu0d5R0jWTxtYk=;
        b=oMNkvfKaNvSutrgMKOnhJzwiZEcYLfxii+jlNSHNT7sCzS3q3sLwz2f6mAdfTuyrLW
         1lwA0aXD4ejxQhi6u7UWvn4aMSDoz/fT0IE4eQhRPGnpcAXi+2eq4uTbwLpOIOIdRrrB
         8+88BvEYVkN5Hp8WTu2Kev5MRc+QcZvrlyYe6iCOcAwjKnmQAcrZpzB5nNhMbq/Rx3z9
         b6I8XozHlx5ZoXm1dCT/3Wnze9AdL1Q8tgNJsUQeqeoj+qEaUNIAoh71n9pXbx4Uw3e7
         v7Yu/AH3w1ZLLF0TzY9VLT7wIAuuZ+qfOMqcU+2L41iS6JY3o5RyfkDDG1jTWr4XILyK
         Gv6Q==
X-Forwarded-Encrypted: i=1; AKwUvBx/wDGIW4vzmggetRffIc7Ly3TY6znOdrOuIkWwNq5WHyVQfEHbMnAxuml8srEeUmUM4OODNUMQEg==@kvack.org
X-Gm-Message-State: AFuF++nXiohAS/244sGsKRmz1Pwdlkvi4jt4mFu3p9GFrcODATqYoG/H
	rGHC59ileBsmmvvWLk9J6zxFNEUpHViGaYuO7GziXAHA1nD9gKI6fQVL
X-Gm-Gg: AYBFou3POhO7gXYRUlDk7rGbhWrQcxKSxFL+NXBhImxOt7XZm1oQFso4wpNBWySYrjr
	5KXEv7ik4n7VaHZwiTbUqU93BMls13h8MouensfhZCcLBJvy/nEAf/PKCttld/0XNyC7gNMnhvA
	ZjM3qSJKgJhpoltQVyznmfh3fCPnk0zhlitUQgmW8atCi2KMsRyvyk6wXzNFfE2KxZzPm9kmFCb
	OyGo7Baj73FAJSKbo42b8SsbkYKpN0F8/oM1L1zHc2rN87j9uD7S6lUd0D16sHpM/TQbnyK5WvV
	91XO+x4zwdvrmintlaD6XwqTLzwFayf+lb/MC4/Z/Q1K3NOXNkQ/zZCcVHsigegT4e3J5IuGNLZ
	vjRcDMVnrDCfwb15FCT3AkNObLqfCD2A73UVnbUB/4V4v4NGHYAW6pgDGeIFh9gWRLOT+bDX3FV
	6A+6d68PZOLw7qG8UWTTy9lr1LJ0Dh3YXZ7K6kCLJGQRmYDkKKWhAMsYZU8QSvTua464ENm+iPM
	94qa2RD4RtkHmvkxPV6ZswZWe4Bb/g19GUyzBYpzpVBUb2B10fpqj/+gSrkJvY=
X-Received: by 2002:a05:6300:68c9:20b0:3dd:a197:7371 with SMTP id adf61e73a8af0-3dda19774d5mr7923602637.74.1790048192813;
        Mon, 21 Sep 2026 20:36:32 -0700 (PDT)
Received: from hanzj-mi.. (ec2-99-79-140-187.ca-central-1.compute.amazonaws.com. [99.79.140.187])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f2a28cddsm1235667c88.10.2026.09.21.20.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 20:36:32 -0700 (PDT)
From: Zhijian Han <hanzhijian1991@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj38.park@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon: fix typos in comments
Date: Tue, 22 Sep 2026 11:36:18 +0800
Message-ID: <20260922033618.2862687-1-hanzhijian1991@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4939F20002
X-Stat-Signature: x5h1s5ckexcqajt6str7g4goawyh1o7d
X-Rspam-User: 
X-HE-Tag: 1790048194-234712
X-HE-Meta: U2FsdGVkX1/V11S7IqUPQJkGXev+qKrOCmIoJjs6l+jWk4qDn3QeSWxz5tQ6CiFIE1Usdk8OiWR7Je0eBC8Dnks7taNm2I+tz+ocvgo8ChBPHnYl+3ov2n3xbKcq7vMI1fx2ZLxV863cA70q7f/gGPY10rm8eQiWg0KfEH3u9SIukiYqBkExKc0hP028lqbLyFRDQDlxglgf7TSi4CGdOHYuBtD+iv2rUvMtC2QXcU/uqoDxyRtYSYmEONOahgHJAGdgeJlZ1obr4vnoPrhJN7W6b3hIdVq/vzChDtq3QADdlzI3iGjK1MLnBjJHNoTxlL9+Vif1yRhp7OoyEXJTeA9LcWzHFx+04FbbayiSdyfr4brzYTkNaFktHQZyREIb8o9hzPjoh46x3UUMG1bICKKzaPMgN5cpB1ye/hMB+bGf5Wab/QwCLg8AvBeAeOTEFiDvddrlkuRBxmVlbr/eD8s4wicdpEKdyXzyN/ZpNuSTASfmy/rTI7AGX/U2nj/tjLlh3mgbDOQB/6g9I1iyZ0zkO5Usg4EfmzX3yMMmp/xxKefCN1xzoucucq4P/T6WzA4Oitogt8KYLIZyJUE1VhSo1DG3IjpeM9ylyOV3rGoMputR++6PXdy69z1hWCvrowzH4NC7g+15NuW6UCSI93cpDC5AtAuxdUyU4jn6fHX55NA8pErJ6rM0SXSInJohI1gZ4EIplRz1i0ENSaVhgGUPrWb84dna/A+tfE9TsSdAtixac0xrk36+QQVOcUqailrpHwB3O+EGmMbvL/vw3mbf8Pf8XKHhbp4oZDie1NXUerZXVB6vsQoyx/1qVwTx1ERvBeqIl0EZv8PMHdr0qDA3VKOndriix6kLVW66dx8rredpED1wvGoJzkXSxOXX0Fb/qgDitKi7z+xDKI/aVId/9ynrE50/3fp63kp0C4oH6DEhhVWGTXd7dC6T3GJcM2WMpqZsCmxag3x4ILU
 2WKzgL7Z
 adEp/Vbs8l060I9ZXQ+qj6dUEnPX2BbL6iWAxZgPZqgNlRBHZb+4v+79orhQk02qH5i6XRTRSe3VCyxbakYrnmLvOWKCepmkG8+WvjYIrdJDlTrRHGHR66E2965+9fOZwruGSWSDguNnZHH9y7IYnb1tPngCT4Vydq8zgItUrxZym32k7al8n6tlmY7N9BJqjlBauutmmurK7KM1+mPoGT3IL1mqDy7XKD97xhd8SQ+ngs5RddjcE84MV6LxgggDkkMhZxxNfMoCDFAczNhmwSa95kAO+STbME70lCcWuNbpBv9M/6sMHNJ5jGKvby5zfwo4KDXb1Aisi0o2PQ8+k1MlxMr9lBu/lfBC+IxAAxJMAXyb9ZB1P59PagprgP1+n3R6gGvvOZTWO+rf9ykt+1r9H2/9JT0ID4pt4LVR+r6GStTrSHx04gk0OXNUXMEmNFQyyV9yP99U6p+xDd2cBiU1K7w55n6xpk1Uu+2WBu2fqzGh0ig4Br6iQ8ceGECH+1OrnSPwzMuoJevFw6ZlTo0+tWdLh/flRVgpSSQ507A80qwi/WCEnyRwzmXmg4TnPXVkI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix spelling errors found by codespell in mm/damon/core.c:

- "widnow" -> "window"
- "makrs" -> "marks"

No functional changes.

Signed-off-by: Zhijian Han <hanzhijian1991@gmail.com>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1..c01b7e2a1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2328,7 +2328,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow, and return true.  The
+ * area that not charged in the previous charge window, and return true.  The
  * caller can see the second one on the next iteration of the region walk.
  * Note that this means the caller should use damon_for_each_region() instead
  * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
@@ -2486,7 +2486,7 @@ static void damos_walk_call_walk(struct damon_ctx *ctx, struct damon_target *t,
  * This function is called when kdamond finished applying the action of a DAMOS
  * scheme to all regions that eligible for the given &damos->apply_interval_us.
  * If every scheme of @ctx including @s now finished walking for at least one
- * &damos->apply_interval_us, this function makrs the handling of the given
+ * &damos->apply_interval_us, this function marks the handling of the given
  * DAMOS walk request is done, so that damos_walk() can wake up and return.
  */
 static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)
-- 
2.43.0


