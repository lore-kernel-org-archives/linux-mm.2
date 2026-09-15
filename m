Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9186FC88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60376B009B; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1E06B0093; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7764F6B009B; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2526B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12167A3FE5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:42 +0000 (UTC)
X-FDA: 85214365404.09.4796BB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6FEFF80009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2HUmvDl;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYceecOh8VdULfAbqb5wdqVn5Jc9YupqRstrIojMs2Y=;
	b=OZf2KMJ6iwWNEZn1b0T609vdFxNtsk/YChK6voaZolNGN6phx5goou0bn6hi3OtZAjxggt
	GOEgXeEP7ZdVS+vofZVAHXR3gdrn0W1sNUHeY/B0Hz/eoxTbib36YJMDe2cMLjZ4T5X516
	4bGKELAQwnfAsFTgzyLhl9SfWZxlvDw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2HUmvDl;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438180;
	b=gjkFOuWQd1v1YL65JmLJdxHBmAcb1765oYLteg5KT3PvVryixYnojR/UBtC8t8SbTUU8ZI
	5ERM30HtEU0zX41mM02m+i7IZvtYBD697E+MS34LGBwYWG4gtw1llduBN+nuSHw60L3Vx0
	OziadiioISEgsuZcA8LcSWFaZeaXAL0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B52D43D4C;
	Tue, 15 Sep 2026 02:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA761F00893;
	Tue, 15 Sep 2026 02:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438178;
	bh=nYceecOh8VdULfAbqb5wdqVn5Jc9YupqRstrIojMs2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2HUmvDl5Doa/t0qj0dO4MggM13j+UX4IjdJlFeJ9TKNBeoKyGTbe/UObXqWfVwry
	 reTBitSPAxcHjQ2ru03b4hmmklLyzcOP4N53LXAKsc3Y80KfjoLNVp02ZCOO+T0mkR
	 S2QckCnCeai/z++wwf+VAI2jsMTLH+kum3Qbn7XnM6sV87Y2X4LWztQR7+N3E6lQsf
	 ascroCQSmBJ254Eet6TrWBt0G8FG7Mn+H4lksaHT2kQK4CGFr2gHBYX9sEOqUtYF9x
	 U09Jhd0zKewp9VC15EhrfEQk7EgoltJUu7ZAA9f1rhQsxWnIZjjJSynBLoXXO/vIPd
	 lSkFEhTziJHOQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 2/8] mm/damon/core: commit hugepage_size type damon filter
Date: Mon, 14 Sep 2026 19:09:21 -0700
Message-ID: <20260915020929.102953-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915020929.102953-1-sj@kernel.org>
References: <20260915020929.102953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9qowmyrt7drsa7sio47p7bw3s7ha4dwo
X-Rspamd-Queue-Id: 6FEFF80009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789438180-659578
X-HE-Meta: U2FsdGVkX19WVwlZ6BfnSu8gf2hUHJVTBhQUn0bcEfec8Vag1/cclvXhvYvRjydyH5J/3AJSXyEpqSnc67GHmYgTeaNf2/1KHnWkLLR3QgIFUgOIMYp9m/8+Hw5NX8/jbBSy8I8mpfjsgXNOXOb3LwepNh89qVwdzcWMCs30skZkPXV6I+5xVbHZqpgbIrr/9gua3f1Pr1opjv6noiahAS1FWqtLQXjkvsORfAt4uZJyMTPNX+cJwtWy427o9bHIO3WDuU2VUsmyJT+6XiWDv0QyX7opeCMiwrDkXwGHTfvS5REQJ23Uugk9di/FeYbBuGsCRUsUHSzHRls/NCmzEs8de9I4Vwso4JjhcMhkcbzovfCrKU0D131W3NBCBxJ6QVoadLHV4fUpYtQKvlZQlb0ZQUqakg+geAwU7CQZ0WjdxFqKfv/g85bzZmAHsiBleYMwzCmJ8WCIV9ZMADJoiCnWrrEFlw8KuZ9N4q4k55HuyRsRb/+vq98i8HnZroQKRoVriiCmi64nNYuK042hLgFlDJ3qVhSGgkf5ttFrNHsnYF8D+RhaHIRn4WDnBOf9hvezQP2V68GTFU4wjiFAvXlwQXDgmegf8xuONSACeaX8HmTtvwjQyOjFo55VXFwi4xEuc9CCmSeEc/iEL2s2iqLW1H2eoomgK6ypvS+wLeN8T6PqiKPcXJWwB+Pacb+vm5q0ksb81MhTmms25NxT21uyzuYXKZmFXNl66ImxW05ZWdrIZbWluIjlZMg5zJVRSVM1CPsmnfslMPT2fpt0hMog1t90bH1ZKO77CE9Uec3DfUaK57q2+OCArFXvCoPCrQqDAWPB1u8H51hBn/tLIgCp3VerA84zkf4ifSwHoRYAzda3cdQjEXv0v8fr4qEqmMipV4Hi0zT7wcadJPBrsri8+EnCNjXgOg7dytDxvKuUHYeOpVqmFqsAzuQECCmN2GqmQNMX9CIx9Ph2EFe
 eJiVC8eT
 y006/V6kQ65WytKqpmNdCB8z+i4fAfuS8e171E8bvXYWuEcKHYe4viqDJcarLmetmSqhxqIz/PvOw2iV+VuCcle+Ibtiapzzl7F9tcvZJveeXvQBUBQexKF9dThycr6jKrrH/B5mFwX3Y9Kctzmm2ePwOmrFea5wC/hjcVcg7pueaSKd0114s8TJKndPc7wu+UDgdImknzOpZVxyhOts7RxSUCzr0mhLy1RbaSyLZE3zAcKqtBX14pRd7xtwrN1+4pvN2N1yuYxfCwioOzdC6ogYSBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend data attribute probe filters commit logic for the new
hugepage_size filter type.  Since it needs to carry the size range of
the hugepage, update the logic to update the size range fields of the
commit destination filter struct.  While doing that, validate the given
range and propagate an error if it is invalid.  Add the error handling
in the callers, too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5212bfb8f85f2..2c9cbcff37fac 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1818,7 +1818,7 @@ static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
 	return 0;
 }
 
-static void damon_commit_filter(struct damon_filter *dst,
+static int damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
 	dst->type = src->type;
@@ -1828,23 +1828,33 @@ static void damon_commit_filter(struct damon_filter *dst,
 	case DAMON_FILTER_TYPE_MEMCG:
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
+	return 0;
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
 		struct damon_probe *src)
 {
 	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damon_for_each_filter_safe(dst_filter, next, dst) {
 		src_filter = damon_nth_filter(i++, src);
-		if (src_filter)
-			damon_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damon_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damon_destroy_filter(dst_filter);
+		}
 	}
 
 	damon_for_each_filter_safe(src_filter, next, src) {
@@ -1859,6 +1869,14 @@ static int damon_commit_filters(struct damon_probe *dst,
 		case DAMON_FILTER_TYPE_MEMCG:
 			new_filter->memcg_id = src_filter->memcg_id;
 			break;
+		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+			if (src_filter->range_max < src_filter->range_min) {
+				damon_destroy_filter(new_filter);
+				return -EINVAL;
+			}
+			new_filter->range_min = src_filter->range_min;
+			new_filter->range_max = src_filter->range_max;
+			break;
 		default:
 			break;
 		}
-- 
2.47.3

