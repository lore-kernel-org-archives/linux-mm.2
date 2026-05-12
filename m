Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE77CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1C1B6B008A; Tue, 12 May 2026 10:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3DF6B0096; Tue, 12 May 2026 10:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A356B0095; Tue, 12 May 2026 10:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71A846B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 345621C0F12
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:01 +0000 (UTC)
X-FDA: 84759019842.19.6D3D9AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9569780009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:36:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u8AlupVL;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Exn9eDcOjVzqUvSiy20OrE4uwVyBbJlWb3MBX7UN5OQ=;
	b=RwCN0vmKVjNH59BRjewQZnZO94vt0VZBBQh+lWa/hPf1KpXS5iG/eEIi3A4mfX5zN9gQVW
	zSvPNT/ADydctlmZJ9QhB2wpOVNlYZATlO0Y3W9BuGK71Pi6CAtFW8VApVaXG/UlQxIKTO
	yG2eqGZXP9H39zU1vOZr7aXieoFA6Fs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596619; a=rsa-sha256;
	cv=none;
	b=kHH7FESuCdvcCf3BbgYBckerGSsw8yqx3+iaLjPmkpioMeVDY/TwVo6/KzQC77NPwat0QQ
	9r88Bj93vyi9u2nbkwsOIboey4bsJpJTM1x0aKTv/h+mPABD7+H9O8uSSxBR5IwzGcHO+3
	wCEiH8sIuq01nf3lsY0TXiGDavMbeOA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u8AlupVL;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6214244A96
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276F6C2BCB0;
	Tue, 12 May 2026 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596618;
	bh=Kv/gTWHqRbjarAkUDYzqDqtowKyfqdWveUKMXCNryl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8AlupVLS1/yOZDBq/YBHs6Etf1hzyDcoDgyGOywrrbHpKek6miAl160dXWIV/axo
	 USjQNX8qlTa2CtPD2MmEvaJJSHpO7wpwqFO3UIz8w+ybbqatFdNSVXKB2jzPiqWiK7
	 nn9HuL/R6aPJGnvjDveabwfs5EY8V4CxUjtVAEyeX51gX1fUxmoCZrGeLo87uyOg+y
	 PJnvvjvOAjqe6Lis/onqkS4hWs5G8KE81O9FhaAwFol+Ue/X6HibYtLI4b9Pmn33UD
	 E0SCs8jb0riZTbQGQOzECIKM8s4mxgIUfIWeehWjdXBqnK5BITutYf15csztKw1hP9
	 jF0Zgv4lQMpKg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 01/28] mm/damon/core: introduce struct damon_probe
Date: Tue, 12 May 2026 07:36:16 -0700
Message-ID: <20260512143645.113201-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9569780009
X-Rspam-User: 
X-Stat-Signature: 6cdkkrmz89j1b57fpwq7ff9wg461ghd4
X-HE-Tag: 1778596619-173100
X-HE-Meta: U2FsdGVkX19qA6p8+/wQbA3ZSCwwWguVKXK8UeJhokGBLERxIQ+1uOk5pa/dAXCUVRS7iIDvyaSDGW9BI98257CQJgqaQCwn8sDL0+y0HitOwtCiIH8g0hGMj9qV1kBFYTePEjZL2SF6TXXLkm6xSXHxujC9zSXpS6UeznIUwJ/L99XKQAPvaJX7iTQ77H5hZ5ni1zcnhEkK+j83T5nOIVP9PIOYgJIDD3vY8bKGKsOEheATMRD+CDKoeiX/XYE6fZGZklXeMIFLrZtHNuBiwq63sHS1K2hWtlbVc4gJEkTDSwM0gYDkj78EaxuKwstA5AHodplXz9N+VLEQVTX0wS3KEIz40Z3zpsOgZ6xudd5T6O2byLqLoRh9WoyBXgdAGFYOVNeZazb3iYaJEryhCaseO3AeIESRlHBIvHgmLGQdAxZUKndUaYdfz1HrCjXeLmXGgIEf6SK6tm5HPVk6uOcIsFqVFuId9MLh+DBlikUQyC2CiyBAlXdsQc2x4JQSx5SVdYAcFlDt7bcgOcIxS/K548jYkLFzRMnbcl7gAe6d9zIrXH7Fauo4B9s5EwJ+N2VxR4QPgSQW8+5dCCmPm7ZNPRoj8UiUQDngxP6puQPqb/IPbCRiRIjKBXR6ac/N6qVt25bxluaAJ0QXM5rJltYv5wNe9FPEmLCpE+/vM9eDOcXSfrpOE/3qrMi4YL4Szd3G2PuzZMuVvEw3A+S6lcUJKkTH2J+UfM7OAlKWfhrbb0Yftku1hBPbkaLmQ0O/PEzBN5CvjSGO7QL3fKe4P9qseAlqXP9VCV4bmFSqS5BCcbCGXMKmXyfUlKyUJdhSdfGimwDwnvEYyjKi3Fj3JnWLiFxi4xOkzNH2CnsZ4fBQByAV4GuLyZilUpqKpMoGwvdp1Hn6/l7kbUZ8jahScmHlewWn3FG3w3Tr+7ovhwtOMYCz7VYxYxLkY+NtyoOpJ0W6YOyEx54RcMsHeRc
 QaNGAaAa
 aoZ6TacMwUMgHotFqlO42RZNhVr/zQOLcsaehDK4Oly1uC2a8l1ApPeQ1SZmlQgseoi0rhA7rLafZN8b4gfo9M2EtnZUXH1YEtyFIQRpKrjCv99DoC0udYcP3N+GtDgbY0YmR8Gk0ij9k7AxAZC8bl/L5/SmNclBgAgcOpsTr4hg6fUxHdZlF2YYtixQtMToiTn2OoWQhfExSgdpBGXVY30JJ0xVwI8x/p754JgSJI1v05hBfr/tvV14dK2Ls4VkyB2lxoBKB0P81pNH/acoB/gwvUc8BHHNvDGW4boDkUDMSpE5bSxjs7hamwBN8GLKhfgKjsjQmZwB11P/rf1GqSgHnkPxjXTLV01htIalr0Nnf6xfRYka+ZfaFgls9Q22LJy1M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a data structure for data attribute probe.  It is just a
linked list header at this step.  It will be extended in a way that it
can determine if a given memory has a specific data attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4d4f031bcb453..4794931fa2ea3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -730,6 +730,15 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * struct damon_probe - Data region attribute probe.
+ *
+ * @list:	Siblings list.
+ */
+struct damon_probe {
+	struct list_head list;
+};
+
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
-- 
2.47.3

