Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 824E9C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950CD6B00CF; Mon, 21 Sep 2026 11:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903456B00D1; Mon, 21 Sep 2026 11:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83ECF6B00D3; Mon, 21 Sep 2026 11:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8FE6B00CF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:15:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8FB814014F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:15:57 +0000 (UTC)
X-FDA: 85238119554.10.DF418D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53A9F140006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:15:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWgeKyzF;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZi9IVNfJSY7xxoADBVX0u2PfclU5VsMjaW1uA9UFkU=;
	b=V2VPuzktQd67GrWHFox0B58tQny/+VCbOPVzf8hDfJ5DnVu6bmRW+yrv7k3DTWw0+1mFCr
	BHKXzSB9CFLLg+Ad6sRS3dzuESaFyiizQWYuEdAu/F7dmyr7VJOnPnz7xKqrJjgAG8M+yX
	ONzHv0LH7Js8jqS74YCHl23hzHRlFXI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWgeKyzF;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003756;
	b=ZeroOlShr3Odc/yIrtWtZjREDiCrh1WWMNOwhcIHtqXY8wzrvHGtF04teRThFAugAHBVbT
	7yCHdY5extjSfpB0BNnDFa3D2jabMtmB9n2njdUza9lXZ0CphnC7GW4DADYuAB2OySxap6
	oS5rjRJ2STVpU4Fl9QAQ7XFbfAM9Uug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7ABF60142;
	Mon, 21 Sep 2026 15:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06FB1F00893;
	Mon, 21 Sep 2026 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003754;
	bh=YZi9IVNfJSY7xxoADBVX0u2PfclU5VsMjaW1uA9UFkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWgeKyzFjdqIj4tW9+UBBQAuV5uAkWPL1DXxt2dlrnleSInIzPDC/OCzQPyJlVlmd
	 SzIgeTw1WNHB2g/GbOEemtZPaq0J3qNjQEHL3MrmKqchXkpYKNydcyeErIUVd6z3gi
	 d7/8lVYaf0FPwXRYx9auipAG/RoQfJjtyYS6idYw+Cslo55S9LnJqk8Y+Fdk4Kujj0
	 cTVGjte27A9Ghxl5UQ58h24uOTUrDjEPyuQrsv1Vg3/UjoNg6gzHEbaF1J1sRfLWqb
	 SLEktZvY0vMp+P+b125uSntGrzRLnicOrFueh0ReYtxcXIcLww3zLtMIhiudE59eqa
	 G7BEEAsrvpO5g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	Adrian Huang <adrianhuang0701@gmail.com>,
	Karthikeyan KS <karthiproffesional@gmail.com>,
	SJ Park <sj@kernel.org>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] mm/damon/core: skip quota score setup when the quota is full
Date: Mon, 21 Sep 2026 08:15:43 -0700
Message-ID: <20260921151547.78472-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921151547.78472-1-sj@kernel.org>
References: <20260921151547.78472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: botdh46ktoj89boi4c3i58933qqz43r3
X-Rspamd-Queue-Id: 53A9F140006
X-Rspamd-Server: rspam07
X-HE-Tag: 1790003756-906148
X-HE-Meta: U2FsdGVkX191pr5FjhDgLWF60pOszcfUf/EbOo1krofY765k2IiNIezJOoGs7yZblPTTVHsQ9/p86vOM2R+LSu0M35kSPvMcOuhAhDdDtuEGGQINimJDr6CBALLTzPvzdz/npa2C/4GKMQ1IysFdgap3Q/N2aqRVvBrwB6+3vIvqx7w4XABbWoundx/CzMc4iWIo1yiwfN9524Ps9SyJLLGUoUQ9tZssVU4vtg18w8wFvSGsstvr/SARaGx8eIdHVfKllb/yxF9ztf6P6XLpFXqECuy4P4rDoQQXg6hLvXNLRrJLsTvTodrLWlIW5uD8QtxRVLyn6mTC1TYfmil9YrltltpbuUDINgI476txmJZYJkdp3d/t/Iby0zyuIiM28QmsM9ig0fjYN7V9RHDZbQDopSZk/YI9m/6cAi0zIyR+kVtoBJOsCmZGVTBw0x8ZiFAbTwF67Z60wczJ9yV3c5FnVIyho2rMP5fYTSiV8pHD5iNb1s84nAz7Hlo2nLzwZbXHsAjvaNQrZpHZ2kAiRcSEzIm6PlLJeLb/hDfjOD8xu1LXhqSBJpgp1LR9kmqwBaJg+IzSDO1Y2mTEOyLe8/DRRtHnBm35+9PIwiK5TK3SqcgiB46osOnefc4+RVKXPISnv9eTiDKR8qOc2gxco27cAXuO1LIkI6t4/7K5BVmDf+wYSK1Xy4rvkgvNMOGRkkTXRzdt/sSUc1f/wNvD1c+BEaxQ1YVZS7XzrE+Enp7KIMaqZACDjOfPq1v+MGFE+rdQjNpIgxRvdLoTHZOOFGvyRxgR2L9Py/NjQERZMNNV8ghKOJJoJeVE0b/laVScPaJBAaaVYJUxd+KsmLF46XoBSh6hjgpgqMpNWZ9eeBajxJTtFRfLSmcYJpOKI2KXsD9T+LsnCGhvzpPharpnpvZ/NaXyZyRGHxC2zQx7SVPc9CAiGa09Ty+VvcRJJWQctXJDoqH+js91TCc17bN
 vp94OBXG
 wfpZA8SEDMboEVsv1rpJF77jXzsTL7i1NNSZJbNFMw6hjtI5l11ZPE3EoNDrk6cMZMzK7f5oV6InVteod7k7TpTXTOEEAQpC5ElPuVNBnBb37/G3MP2Nvhd9HM40alhDNFF8yn3ZSN/kknIL/7gcfxSN7Q+IfeUL/Wfv39E4IjVoaT5IKjUGTfDUUm7fv0cEWm9pzDQgn6e59puEOvQvKFRh3ZWr8koc8cK85HxTnGUZjU+AL13WXAkDpE8m3+ReZShHS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

In damos_adjust_quota(), the quota could already be full.

In this situation, damos_adjust_quota() will still calculates
quota->min_score.  However, this min_score will not be used in this
window, because in damon_do_apply_schemes(), damos_quota_is_full() will
always returns true, preventing the scheme from being applied to any
region.

Therefore, add a short circuit for 'esz < min_region_sz' schemes to
early return from damos_adjust_quota() before calculating min_score.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260913110407.32558-1-aethernet65535@gmail.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2258b72da7a7..98c767b9e6ef 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3368,6 +3368,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	if (damos_quota_is_full(quota, c->min_region_sz))
+		return;
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.47.3

