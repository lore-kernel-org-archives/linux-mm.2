Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209DB606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YfWc1Vwj
Received: by kanga.kvack.org (Postfix)
	id 25D8A6B05CA; Tue, 17 Nov 2026 21:22:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232B56B05C6; Tue, 17 Nov 2026 21:22:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CC06B05C6; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC4056B05CA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 476B040621
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
X-FDA: 85446641238.05.F70EE9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B4079120008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YfWc1Vwj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0jEw0vpg92YutRbGpQJgZQWm6ta9X/6Vea9IHOffLo=;
	b=WNOAd9oBilgLTLlKMXMxv7owA0UH9hqWVqfPYB1BxzaVfk38WOxpu0dXFBjsteCKwY77Km
	sGv/YoNBjxiVh3rfpf38W/+8G7h4FPBl7w3odUMIYCeUXW4RyXwnycQw1cTgP0J0HKhUiN
	Tbo3eM/FuTLOXYhRJzND4In46wU4NvE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YfWc1Vwj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968557;
	b=pqw6CyHpFGkGTMrK7nM8lgj3EudTSP55nqa5KInGbOpNq85DiWb3da2zLrSo2PT3frezIg
	mRjpEUHBIxl7iZPq5mobDcrErkj4hxZRUfy4Bw/MLOYzgRivmeCbwfz45YSEwVbc+Wv30k
	/rwmHg3M0EUWwDSOv+QF9eOHTA9/WBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCE7345CF0;
	Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E29D1F0092F;
	Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968556;
	bh=O0jEw0vpg92YutRbGpQJgZQWm6ta9X/6Vea9IHOffLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfWc1Vwjm47bFXELB7zGY2VKkdsDEEJFd6PTeLUmNvuhafE7MQTvYh6JHXRea+0LX
	 +2s2hlsNbzV6Q/0fDza2f+ujHwk9BfSva1OTlP7gJrpBj2DqA64QKZiQ072Nn3SEGi
	 ZEE0Q1rRce3KjdftZCTyZE3fnLY0dB6/GSWK/T8hPD0r90Flbfskb36ZbHXrCGg5gL
	 v4E+Bbb0/L/sW1l+cDfnBMh3Uyc2v34jEw2lKE2QC+TbH+cUWPMNCMkPVPmWQ7ypfR
	 dxki89OweR3zDk1QxZtBWaHC0AX7NjYSuobbm3NkQIDphaVwvrhDdKpdLzqz4igt4D
	 dcMZbR0b15Vaw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 12/27] mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
Date: Tue, 17 Nov 2026 18:22:07 -0800
Message-ID: <20261118022225.100659-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4079120008
X-Stat-Signature: 4n4hdpkx9ym5ahyt5szko9h58cgtaqou
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794968557-129672
X-HE-Meta: U2FsdGVkX1+bekoG3l1dLgjQs5xxaNQLq1BJFI4mS6JAwOE06qXP5X/KVBJSaHooQlzD7A313SQqm8vdFNaE43CVrXfW3+yc5/M8HBaceDg4Hlo5RHImmXsfpo6yAmegXLKl5dzV618ugcZb60/znMsPM5pIH+5AZJyxLGhbiftE6aZ6z9EH+2HEuiz5PqopvUB2/brgyUI4BBbYHwNATWPctrDsasB3kIZIkLPrIHme5At5SPPR+ooxI3CmDSwHmO4hUId0BH50EflMP3eAYAOQv+AO95s/I6j8skojLG9nTVOdyXtL0fnp3t2i0ymJOqovlxy05Rz6NvDigshMygSqIo/uucifRlzf6juOB1cg6VMtzU+VOWO/zDPbv5LxA78BE1YHl1N5Xp8MPSL2qRXYSqLX7julHpXst1IP+cF7h9E43iv4FwjrDuIoObLMGAVccW6blYqvUTdDanWTIzgpL4HFB/S56QEVqzYy1EUz0J2LxFE1ReNkcwgh14afgT6MFnr5djArU17da9bvRc7Iohewve2aQXlAyjRUiZeEHaqFN98cy9wKXFHau/gU0L1TBMRKXp99z+vGF+7bzT/it2lxNOj8c87ItWLtu+B/eGzbA95sSJf+r4hQfAom2GWR6PhwlgzDa+wr/hW8NJ4jc3yABtLeO48igswM+PeQc3KXIAO/Np6HLrc3L7FUEXJ5pA68f8sGBu8sAgL7rwdTaeyMICIGe7noSsJ2gBuSKz4TD4/qBFAj5+GZtAK+2GUODRQM/rKYE8fh5Wc2L+l5mZNRIGWOvwUIHU5tQLi2OIvtGwahJMa7LDC2DGkaBB2SfLy37Q5W6/RE9L70NgRn56toBEF7OgCeXZbzSwY/7ZxXm32IFKMTyz6HiPdB4LOfa9E0Uy13+Egd9w++gbBLnf36GyGDk4AFNAzXuVYGJQoF6oOSe49Ywr+7yc/qrQxjgb7ZRuwlFlrhvuS
 G8NXubpY
 9hOh17wnsjpmmLCyrX77qyPIMx/GFBW05wZiEJAB/6G3jDyvQmKXqxPMQw8U3euCpJCzVtJ81dwudF5UvljuIcHPguom9uAc2GYzbR/R6vfRvZm8QEvcgobjcpHdEVRLs8XyEBUy0p/hGIYigdvZ0KSX0k8u3NBnpsWxvPv6roVLvshL/GbTslS5lfzLDG4soGvUKJBtuEBDClOSfXjkOrLirPjAocVYU38zUedusunmeT3qGyLubtlxTem4YFFHrkz+CtHqlt6Oq6T3WOZfeCjlXvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend DAMON probe filter for the existence of data attribute reports
for the probing memory.  Define a new filter type, REPORT_MADE, for the
purpose.  Add a union argument for specifying the type of the reports
for the filter.  Update the new argument for the new type when new
filter parameters of the type are committed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++++
 mm/damon/core.c       | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 35ad002d1536c..09f0dfbde8966 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -802,6 +802,7 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  * @DAMON_FILTER_TYPE_ACTIVE:		LRU-active pages.
+ * @DAMON_FILTER_TYPE_REPORT_MADE:	Report is submitted.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
@@ -810,6 +811,7 @@ enum damon_filter_type {
 	DAMON_FILTER_TYPE_PGIDLE_SET,
 	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 	DAMON_FILTER_TYPE_ACTIVE,
+	DAMON_FILTER_TYPE_REPORT_MADE,
 };
 
 /**
@@ -821,6 +823,8 @@ enum damon_filter_type {
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @range_min:	Minimum value of range arguments.
  * @range_max:	Maximum value of range arguments.
+ * @report_type:	Type of the report, if @type is
+ *			DAMON_FILTER_TYPE_REPORT_MADE..
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -832,6 +836,7 @@ struct damon_filter {
 			unsigned long range_min;
 			unsigned long range_max;
 		};
+		enum damon_report_type report_type;
 	};
 /* private: */
 	/* Siblings list. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9d492a9aaf550..24729be5ec4e6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1834,6 +1834,9 @@ static int damon_commit_filter(struct damon_filter *dst,
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		dst->report_type = src->report_type;
+		break;
 	default:
 		break;
 	}
@@ -1877,6 +1880,9 @@ static int damon_commit_filters(struct damon_probe *dst,
 			new_filter->range_min = src_filter->range_min;
 			new_filter->range_max = src_filter->range_max;
 			break;
+		case DAMON_FILTER_TYPE_REPORT_MADE:
+			new_filter->report_type = src_filter->report_type;
+			break;
 		default:
 			break;
 		}
-- 
2.47.3

