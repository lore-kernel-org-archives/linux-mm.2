Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A74CBC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7A26B00A1; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890366B00A6; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7033A6B00A3; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324986B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8145A401AA
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
X-FDA: 84955934952.30.BEAF1AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D6A011C0005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vpa9Ws+v;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qg/rQtc4ZF10NY3hyCPz6BwwN6rWMQvMaKKDQZFcro=;
	b=J0hjUOI6aiUfGV4Av0eqC2hPbtPFNfsqT+CKSA151Hm1tkoJgnZtuhM32aYHPMLwsdAsoe
	KsjeeBlevmYTjENcdTzNqT5g1lTXzdIb63COvG4fomTmUjpcYCU7KZh5Wyve/MlH558v0S
	DvPjEamoKyb5hrkHQC1n6Jm9t1Qrzps=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vpa9Ws+v;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285074;
	b=JzmGP44yEyVCDWnLZX7rchpzkwH+1xwcek53gQa1G/ncHiE5CkAxJhjqVoCjvSNnuJY2D4
	RVhbOTBrT4xfwss8uQIA8PzSJtmqU2lKxcZg0Cfv7iwGC3tIGFNsgMYMe3F0uFLHdqvCru
	rgBmbv+Q/icXOZsrwPRnCbuW5fpsTMs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A924743C4F;
	Sun,  5 Jul 2026 20:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D371F00ACA;
	Sun,  5 Jul 2026 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285073;
	bh=0qg/rQtc4ZF10NY3hyCPz6BwwN6rWMQvMaKKDQZFcro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vpa9Ws+vaP6dLQ2Jvg5viEsvUbec//lvGeaiv+tIQgnzGMLfrPyGhn7xK0j0QE5eR
	 3TOBWS5eX0C90ErtWnfNQLMyjAlK97XZa0RyZZgmgfTUKWePDurufC+YF6bClYRtYw
	 2OC2IVxJJVfgjcvs7EMpK7XkJ6kwy3+MaCGPOe2+0wvNZkWBfkg1vse57rc85/nFY/
	 YAOHG1H5TkvUr4oTZUIOZpDzHNXwWx6sVcLEpmHediGhT1S2lMg2j3lbXa3R3KsxMZ
	 A69ftIrNMmzJQZDOIBmnmjyM3nLebhKhjX2sfX1eWXkeNr81xwYwQPd1azFlsa3TOB
	 VSCbC2uiXL+LQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/16] mm/damon/core: introduce damon_probe->weight
Date: Sun,  5 Jul 2026 13:57:23 -0700
Message-ID: <20260705205743.98656-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6A011C0005
X-Stat-Signature: egejzjzr9oznwgrjch5epbyyw68ps7qe
X-HE-Tag: 1783285074-631635
X-HE-Meta: U2FsdGVkX1/o/FCFfTj2M2rVZSrhGosdrha0bAjgt3EU4VQm/J/DxC7p6WbMpqH4vx/9b9b+2UABnAr9vU8eQImmpjoVlNIx0j041rVa6SrAdbZLYpPbnI5GiD7mmi2w19TuCNNmQJvvZWwVBYSlJ2C/FU6KZDDFGvz7rWugwGPzIUkImT+UYeY7y6reIvzfVHoUZcG8IZMHp4WpUoi7uw0RhOevTL5NVEX3V5QCNHG+3O/J6NwUoVb4yl40w/dhu1WeNITF6Fgy9qW5FB6525Ue5FOiDjqjetG7OI3tfIypfchDyGh87+FXxnI7RMG3lwEqYWpKxClLCtxBJoAPe6omWN0kRxX5i+PKt96ezxYsSXKGgBL/OE82vPWTY5IU21p7X+GavmvlMDUv4DhzcUkWoXgkXsqVS8znFHU9zpisBOTaNjQFGb1D/KnibdIeRgpQNUlm39WbXkJJ6e2ztcJGLIQQ2u0bojrSXEw4YRnyKam0i5YLIiTp4i1nbtil2SBVLYPckTIPoJJie0wwCTNW4C+SdLtEk0hS552jiDPWspxUJ09izB9KYAzAnqWUnHjmLUw0sA/7QRKVFR4r8CZ0ooNwqg19jHTIcLUz7UGzmLIEVw8/jdqCYLNzzVEiQrMOR8t1+Pxl4TCjppzf4JoMsWcKB73QORgcnT1Bkh0dvHX/LJCuUCcmbTfgEPljrEPTICJumdZbIlcu/lK5fOaY/muZ9DFaEhgAHdsTXs8x+9t3pczyFwoA5yNf+5y11IJ4+qdtHrBC3USj+3j5OUMttHGUtZgQQfO4D3kLkl3BH+UCNwouMWqeUjGLpQiSg6XCfHqd/W+ytcGT0Jjhhrxxkx24043AMay1tz+XxnzrP2dyS8nAs+lSzig3rM4l45+n3pagztDmOVLfYecGJRHbCf6rtgzAacoQAGAXcppo0vTHvwlyzLZnuiv2p04VfMT0yzEbB70nzUWO++Q
 ppDELxeu
 c5Re5db52o9IdgNZl2+prqdJ5iNhyfQ5F0+dj6TBWpPNDGPU1OZ9Ug+dYswuvoZO0KoObCAGmw+M2/mkqtP2vt5qRwFAlgneya5Mfeh799ij7UMWeEALdVTkZs75JGj6aaTqqwKhgyKYX7ZU6oJjMup1nMvwinfUlxbdOVqi7EG+sgqmzCfZEuf2a5WBJ0qf5vUq6LPMREqC/8h+wVWfR3AzSPb7O1CD5Q3sf6tDYTcnX/TbFCIayHCdF2pe6dnzk787x7AJVl3RIMciLoSbodRj6Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new field, weight to damon_probe struct.  The field is used to
specify the degree of the API caller's interest to the data attribute
of the probe.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 1 +
 mm/damon/core.c       | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 19b7e839bde0b..c9c1de7ec0e7b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -764,6 +764,7 @@ struct damon_filter {
  * @list:	Siblings list.
  */
 struct damon_probe {
+	unsigned int weight;
 	struct list_head filters;
 	struct list_head list;
 };
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 390e00b3685ef..ca5c3f3e45fc6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -166,6 +166,7 @@ struct damon_probe *damon_new_probe(void)
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	p->weight = 0;
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -1641,6 +1642,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 	damon_for_each_probe_safe(dst_probe, next, dst) {
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
+			dst_probe->weight = src_probe->weight;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1657,6 +1659,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		if (!new_probe)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
+		new_probe->weight = src_probe->weight;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

