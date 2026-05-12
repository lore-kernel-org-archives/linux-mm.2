Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C2C5CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0DB6B00AE; Tue, 12 May 2026 10:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13E66B00AD; Tue, 12 May 2026 10:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B530F6B00AE; Tue, 12 May 2026 10:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 959D06B00AC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FCA4C1E0E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:08 +0000 (UTC)
X-FDA: 84759020136.12.2FB199E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BFEA4180012
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sjcADgMe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RML6X7XTRgHK/kQ8GfVV3eTVLMDZ+Spwy0ED6OzWPN0=;
	b=OD1HACdcMuuhP93HxTiKCxcHWcm4H5wM63D2Z3ZKkC4QwXtEkOthted1CoMjlkwDvjGQAl
	Tg2zDN5SfiEPDG+J2w2UpzGxY2UZZdufrRmyHUAmJBlrzz7m1443Wi/xJG2kUF0h8O7wVa
	RJAFw3dZfWM9uM2x7mSCKjFr+e76jJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596626; a=rsa-sha256;
	cv=none;
	b=xU2ngnITflY2FqYZtgnibtQUBbob7ZZvlC7jpXP7tNMbve4IABu01aleZLQ3AnxCYQPm7H
	kE3qaBeO9sK3o4eFmMRcELHNXXH9VmsfxXnWUqqHYLr8QQv90XOO4pdOtz0M4spMpem0WB
	yqG55wBJok6j/7497UHRMxTs9W1t/E8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sjcADgMe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8826144A96;
	Tue, 12 May 2026 14:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CB1C2BCFA;
	Tue, 12 May 2026 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596626;
	bh=RDSWBAh50cMai+6acyW+AfVUUR9Eit/eslVnRAs5PH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjcADgMeYILQU0boHYv10V+Dio3tUD7L4BXZyaH8N6Fy/Wv3ei35ogEPMmPWNfptz
	 Weu6cImX9OnbWjBATQX7iIB5HZeDsnyweNk7Zr1cvSkOZAwEVsEbTgrfSNOvHZkDvd
	 QMBvrKs3t6z4m0oe0TRm0vJ+U/FlEjY6bye62VJ7yqFojiLJdu5RLt0xAVDJpKzGeT
	 +U8JAKl4SxCdRTNzjScVksA4/wTM5QjaAW+kUmoq99O2wxjb8dwClvHI7H20NlKRiN
	 ziy01Dl+EkbKyvsEOqOJ0Zrn9If8acBZxg0cmvqvtJ8JcsdeptGQpcbpwekL5VU5Jm
	 seyMFVg1NdQSQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 22/28] mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
Date: Tue, 12 May 2026 07:36:37 -0700
Message-ID: <20260512143645.113201-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BFEA4180012
X-Stat-Signature: xiwuj1wnyxo3g9p47ijg74gemnyad9b7
X-Rspam-User: 
X-HE-Tag: 1778596626-903838
X-HE-Meta: U2FsdGVkX19wq0/85XKQ8DgMZ8e7zdJejJBAaTNmxQnIxi3h2NB/D5tcTQKbwgsELeRkylZL+u8COewVy0nRwGUp0kZUYP2qlUNMn7MGoDWQIBxHxXstyVINpPUCNIaUW3/f8a5RHrdUDyLu4gphJ5xEUNJ9yp2VpNHwybYL8zx64Nkq/wES8tFeRDxqgjCvF1YKdgUNphQLdXjjVVbuItMp007cDZygU/y0LnYI0eGitsrI6GojOG+D6aYZ4nB/c+bOBuphBIkYm5Psh6VFOCHcmFUjC+GnvGKv4vZy4gctPeBZtygOkF99LymVjMwOC1DpSGuDcZRYgY2GTVgNocdqr3l21+NgHMxiM65MKHM+OaBDzQJJ8PfQ0n/zcwmj4h6dQkkgmK7X+xmeqMwt5X22A0nNFXjxlrzrjveGr0aITnU+OaPw9bOV9Gsk54ny9/i2EfeP3jH6s+59RHNHLqLh2BXuTx5mmphO2thD9mE7iWhRjBVIE52UIxvKxgh1Dus2vfd/kzXyf6TwvTqk1iT/yPk6A5AftxLq5zkRsnsg+dCtMz7Ut4Zp3CjUNdAm2U2+E8bk9IsaryeWSHZ5HjE17zns6YDx5kuTfnGogo6s8ptHFIG5lcNKtCmTHeE02Xs/LN0Ym0AK3ZrZqhwPGsnjl+TFYCqs42np83U1z6ilJ0COSdlgCvm5jjoBXreP+tfweMBSaIzURfMKhgR8IsA7JEJA3UfvqI9WkbkgS2/7beaFHbmHjD9dPHt2jGwvrRwVTeReY0AslgO7W3U3D8ezFYBYo+VxgUOK29wHn+PAOV0JhQyy6ptXIYC3k3/o8DAjaP1UeVD8589EcdOa1vJPboxNB7oktjmKAVVceyUZ6bkFYbjyBdHlXyDlM/kGdpkV4JUYlGzk7mn5rEFwKYcmcd11EBezeYz1cMHrFrXWnCOmb+r2BnI06VWz0t0jZgYrHVR1CLW/5PULKYG
 4kx7QqaI
 psOELJZyPyFBW91FmjyJ3vnioKBELXUIKAJTrs2kUljCxwdLh6D43vwNm9GEyRdsQmTjmuWClPT+LpggjAwJIs/p/cJQ88C9KlVYYUh1E3dWxXHuxixYAIi2SSvPCs2u20auqiqVgt1jrVpL82Zncbif+GHnXv8/8S5uvTukP8eKudTt20Ls4CAZ3cOiQ7tqk5q4ay46ZWmtkMzOoBisXFbWyNpaadZdgfpXb+rEdjpTrQNOq3AJcq5+4htiGfsjusfpj8KR4ZnVrvguSNIbJ48dc1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Belonging memory cgoup is another data attribute that can be useful to
monitor.  Introduce a new DAMON filter type, namely
DAMON_FILTER_TYPE_MEMCG, for monitoring of this attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++++
 mm/damon/core.c       | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index e9ca40cdd9102..3dec0947b93f0 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -740,9 +740,11 @@ struct damon_intervals_goal {
  * enum damon_filter_type - Type of &struct damon_filter
  *
  * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
+	DAMON_FILTER_TYPE_MEMCG,
 };
 
 /**
@@ -751,12 +753,16 @@ enum damon_filter_type {
  * @type:	Type of the region.
  * @matcing:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	union {
+		u64 memcg_id;
+	};
 	struct list_head list;
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 14b15c9876516..ef751898a3c06 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1430,6 +1430,13 @@ static void damon_commit_filter(struct damon_filter *dst,
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
+	switch (dst->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		dst->memcg_id = src->memcg_id;
+		break;
+	default:
+		break;
+	}
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
-- 
2.47.3

