Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC72C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EB66B0099; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A37D6B009B; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF4C6B0096; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAA346B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:12:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74213160270
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:28 +0000 (UTC)
X-FDA: 85187609976.13.DAB2A73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CF87B18000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KHBRoN/J";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801146;
	b=fBcszuklz1MfAK3F1YXe4U51+hJbe7jzPaPDyfuAeTaAYZ5gJ9/1GaFmMLzq/GB1Oo1y+e
	o/IH8QqGkjFS+3h+1Eo1zz727Y7+ln44yGdRBFXDMV4fJnKhv9YC/xEuBOZ85a8483yD7W
	mX4oZcu5VPv6EnHvNHsunhi9mm6pRrw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KHBRoN/J";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dxxa5wP8u6+NzrCeSUKIx091CaUINS3Abxx04SVxcHc=;
	b=4Nl116Im61NnAcvH4qz+OxLzA2BUgiLJhPr7pCfYsqx64eMeZATMc/7DweJXhfvsLLUjkE
	SpLnDY0Z8yGyRCNr1E+z/D+MhMNCd9NCP0WLitcErX9lcSd5WerYC3s2SNce6XOF//8C0y
	wbv4cWaqaaAFq5wXyKeTd0XF+FbDIvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0072C43CE4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B364C1F00A3E;
	Mon,  7 Sep 2026 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801145;
	bh=Dxxa5wP8u6+NzrCeSUKIx091CaUINS3Abxx04SVxcHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHBRoN/JWf+JSmblQjMDXNP3atlUTDvNsd4f4vJv+3KdhlTwqVCDKx4TLP5HdJMh7
	 SZCE1v99rIiKmttJvXs0hQmgyeiICbIfE25qXhypdvBuI7kqoG+Vc/mjPjDy/954BN
	 pqDCLAOXybS3PKOZT9s9efM7vhJ8xnm+RKldCioPS8IRAeBZ8GKqdyLevetfjmlNSV
	 F9f9eDyaUSNODVeD2BZn0Fym77oZj/rSloYHl3AF31Goqky1lq1JkiYdLzS2yewKmV
	 GY2qrMU5jJDYPXyEFILOEaFPcyB8ClW0xf1i6cvH6A8NLIQuMMS/JURU8T1c9zJL4R
	 E/ovuggBfCETw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/7] mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
Date: Mon,  7 Sep 2026 10:12:10 -0700
Message-ID: <20260907171218.101430-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171218.101430-1-sj@kernel.org>
References: <20260907171218.101430-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kmcabz8b34sws3ekd9sxjdiasj8tg3s1
X-Rspamd-Queue-Id: CF87B18000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788801146-901250
X-HE-Meta: U2FsdGVkX19Ufi+6GL7g7Yp1reMct1CVYcU/gkBlPZZxJryARKTtaa0Nf/CyETjSiQxjIcaMf/88RerqQPqqVxM+wFz/APyBj7WZNOyG3tML6lFeDgMa57kcSGvUn4DCJyPfjWpM78OlX6g7bafnMQB3NcI8CLVPImdZtsd74n6nSCzsTikBrRb6yx89Vxr6EeVY6Cz4jT9Ss51ViRfYnA9kuKDMUSV+HppBKbSQT4MLJAKSyegnsoApGQqHU6AmKdi5kSYFerCVjUfuWw7ShpYNKuBeTPSYaqadF0ZrJLh1j2KEQRheNduQW2P/AXBGZRUuGgFvNX77NjW/GuVUrd00DJiWb0YVNeBajJg1KiOnuNQbC3qbTCc+fYtaVFGIB9My+NJ/7vhYp7Q5MpD67ujuHzDZ9M9jBmYOiSz/abTy0LrcZwVpVqn8Ry3otQwgscq1Xu4h4P1usD03s/yCqH30bbw1bY0Hbq19qqiK3+VfDQikEGT9nIc6bMe6R0yq4mUeEG8RgLRSHkuQfHCRqpL1ss43BALRSmZXU/NSKHdEItQprkkBpNl9nAQOeVaSZfK3KC9wxk1/0ZMgEs5mSeSrcfqjoVsNOrO4tp7hHZyh8OJpFqGCy0rVaj4Jj5BuMJlZIL4r3xlV/R8C8zvWL6VWn78J3dnuKYGu8MxHcfaXA73f2IBysRkxEXwawJrMnkDk+r9UAfiLO9IcDqvpR8fTmVkLxGsJhuhA5ezoW88wnRgGYRgoZxvGRs0az3ebQPL8PxxV0IykMNDZLhKi67AP6q2Mb7nc692Zaa9N8Yki97h4hpmn85dD4Glfjp3KCgbyM+mLMgy1QY+HiiIALiXdbHuzYLgYk05507sf7/M9CZqoXe+Z4g2relFw+QQrqmSfsHkHfqBHrOjICns1SA1N5GqM1iQKYR0pLYUpqVSo6AyLXEuTfZcmWidUY8hIeq6N8rTJbfjuqUa7REl
 342K3L90
 mhgFqSs0Uto1j/H+QyySml/ftf7lHXrrUgCa69RvImxN3p779NRCBHP3/7twXm9dy5hyWHn7n1YfXRylI14kU8SnHYVrTnIOhduYZsIC4GcEJgQYZ9aMYBHOdfhuXt1P+CGnCrblsRODf0w7L1K/d87rgFu2eR5/mZmgtOfswJt4CVMKdm1IBlDqLU2awjALyR35f+gYjr/2ZmnJVhLosW+sEh6QR9VcyuyOeO2a2JWJvtdzhj+1Yy5jupJ43RA5Hr4h1tnIDupj3qr8ACqJq9u+OslKJOOdBUKl8w6nQNCIXdXzGz22076azcM1Pl/BpbQR7RYMp4VbUNxa9eBc/3p1N0aenTafDj0UZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON kernel API to introduce new DAMOS core filter type,
PROBE_HITS_WSUM.  It will allow API callers to describe the DAMOS action
target regions based on their probe_hits weighted sum.  For describing
the filtering target weighted sum range, add two type-dependent union
fields to damos_filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 871d26adf6ae5..1deda16bb70b5 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -399,6 +399,7 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_UNMAPPED:	Unmapped pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
+ * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
  * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
@@ -420,6 +421,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_UNMAPPED,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
+	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 	NR_DAMOS_FILTER_TYPES,
 };
 
@@ -434,6 +436,8 @@ enum damos_filter_type {
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
  * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
  * byte of the region matches to this given condition and avoid applying the
@@ -450,6 +454,10 @@ struct damos_filter {
 		struct damon_addr_range addr_range;
 		int target_idx;
 		struct damon_size_range sz_range;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* List head for siblings. */
-- 
2.47.3

